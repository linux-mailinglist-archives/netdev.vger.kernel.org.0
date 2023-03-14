Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F0366BA0A6
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 21:25:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229519AbjCNUZD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 16:25:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229636AbjCNUZC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 16:25:02 -0400
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06CB62A6F8
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 13:24:58 -0700 (PDT)
Received: by mail-ot1-x331.google.com with SMTP id t10-20020a9d774a000000b00698d7d8d512so942165otl.10
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 13:24:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112; t=1678825497;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=sZB108+OWHZCmnow6ZzPOoaVb18Po7zx5G8aguH1LQ0=;
        b=zv6q3COLFJ05KzICokZIzMtHipmzoxyLRiXqQRiwkmAYL4sDzWOALAAwOcQa73daoW
         fmLZUHdZmQDabTym92O/H8sX0M4tUZ1XISkfWZOrJPZhB3Hf4DzVh/HzNKZdJtiAbIFX
         c+HPitAKNDQmclPczg9+vGPjxlDgstX9ktVEdTIyh4EEfFVv1VqClYIAwpi4bHZDcAYy
         QgNfakQ9hNZAWblA7j809zJnFYTYz6H0incu+SHSEd4sDZFdwBDIH91w4ZyZQFzCBVoZ
         eVUcFY6PZ+6q4UJTh8vyZ2blmIy5LiSgwKKxuCKAhyT+wBhJkDKIMw0bj4iYoWWqFJFD
         LsWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678825497;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sZB108+OWHZCmnow6ZzPOoaVb18Po7zx5G8aguH1LQ0=;
        b=XBDZzHPr/wObb2GUisTeQMH59NdlQvfV9xY0JJIGCY2TTX7WYFs5HEfQR3x+B5yjKq
         gGVSwcklGh+G3rWlR5cGbE+tctC8qtqmYrNp+2meMoUQHJSOqMD7z2Sp5n1H6/Hp1hNK
         opYRJzqvYYbAokrE9HrP3E2krt2JE0WAUwxCw0y97+E9A2Haza+S/MCMgC7z85BKuHL7
         nIMcMKBd1i1QxVOcMzhcpgdkHv2cDZYnUuj4AhZT+8PWvZH8e5QXO5YZV85HQih4+MxD
         S82WDAVTSjULKlft21/4uE0FFgDujlj1E5UVazPzhINqlu3CBrrcd7vUG1L1eic1krop
         dg8g==
X-Gm-Message-State: AO0yUKWTx7gND4fV8Nys9L/cGvU6vJQIqchQCoKK82GGuDYH39adOgR8
        +bYXbdcb9fG77g9sV0ZW2PuEkoTfuQkKsm4FRJs=
X-Google-Smtp-Source: AK7set++WldBTYw5IQU21g0zQjjWAUPGhhUUexj5ClbKENFRbbiXBM3liLlzdcelUYzJ0MkHRKbYFA==
X-Received: by 2002:a9d:851:0:b0:697:3da3:e404 with SMTP id 75-20020a9d0851000000b006973da3e404mr1856308oty.38.1678825497234;
        Tue, 14 Mar 2023 13:24:57 -0700 (PDT)
Received: from localhost.localdomain ([2804:14d:5c5e:4698:95f9:b8d9:4b9:5297])
        by smtp.gmail.com with ESMTPSA id 103-20020a9d0870000000b00690e783b729sm1509278oty.52.2023.03.14.13.24.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Mar 2023 13:24:56 -0700 (PDT)
From:   Pedro Tammela <pctammela@mojatatu.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, Pedro Tammela <pctammela@mojatatu.com>
Subject: [PATCH net-next v2 0/4] net/sched: act_pedit: minor improvements
Date:   Tue, 14 Mar 2023 17:24:44 -0300
Message-Id: <20230314202448.603841-1-pctammela@mojatatu.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series aims to improve the code and usability of act_pedit for
netlink users.

Patch 1 improves error reporting for extended keys parsing with extack.
While at it, do a minor refactor on error handling.

Patch 2 checks the static offsets a priori on create/update. Currently,
this is done at the datapath for both static and runtime offsets.

Patch 3 removes a check from the datapath which is redundant since the
netlink parsing validates the key types.

Patch 4 changes the 'pr_info()' calls in the datapath to rate limited
versions.

v1->v2: Added patch 3 to the series as discussed with Simon.

Pedro Tammela (4):
  net/sched: act_pedit: use extack in 'ex' parsing errors
  net/sched: act_pedit: check static offsets a priori
  net/sched: act_pedit: remove extra check for key type
  net/sched: act_pedit: rate limit datapath messages

 net/sched/act_pedit.c | 77 +++++++++++++++++++------------------------
 1 file changed, 33 insertions(+), 44 deletions(-)

-- 
2.34.1

