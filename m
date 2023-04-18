Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D89C46E7006
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 01:44:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231265AbjDRXon (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 19:44:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230036AbjDRXom (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 19:44:42 -0400
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 951861BD4
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 16:44:41 -0700 (PDT)
Received: by mail-oi1-x229.google.com with SMTP id 5614622812f47-38c00f19654so862825b6e.2
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 16:44:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1681861481; x=1684453481;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=fCCInKlpGqgZDqoeFeRD/ihJGUuvwkAnb/xpTrkTqmk=;
        b=jWnLwYnRnY2GaaljESQE9+VYI5QPGjMhP6YxuJ11+Jojim36xR5mdhTgEn7UzhgEQH
         zYY24yvp0dEwffOxPidBcuRrdHfWJKNi6W7pYKPpfvje4SOnEEEbyl5m/CJsjR9kwruY
         lNbut2cm3asuHwFN23+kMfxDGRz+eJx1QHu4xLXunS08/HFeCd6tGdwUD/zy2OXv5js1
         uRnU1svIJVScAINZ+g9JgAR7TDUtYtGMhFSxWOc2JyyJu+Tz7y7cdKnJrvRBY7rfwGWw
         7aRYmU6g7N/+cmInaykot2GqbDliAuxKu7KvY5XtTvF2MwSrKLFGfEcZUCDSRlsx3R1H
         qsNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681861481; x=1684453481;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fCCInKlpGqgZDqoeFeRD/ihJGUuvwkAnb/xpTrkTqmk=;
        b=S4UlMORAo46yq2qmZoh5UvfSiCwxJSm/KUKEduKspJUOAvRr3+zZsxNyV2/D8Ii4CT
         pHiG6NZGpY6wAO2KZxch1/yVO6mOaRYGRsqEXsYSgsZEKJBvS3BzqBvkAkRfCEG/sKQ6
         BzD4GAKQtXlV1Bm8wBGuunjq/UGiEfuJvllxzybp2qHOhmzf8KzrohgXZSXvmjYwg751
         +fOktvSWUUM9WS1kKItff+cddtx8Nmir6OgtzKUj775RRkfUS1gSJrawq/eA5Rxu9s2s
         im8g1cawc9tgkngsrSl0HNltSdVF9X3UszHhlQUM+Wf/HOLchBHsyePVqSSMhhF0Ubis
         3QMg==
X-Gm-Message-State: AAQBX9c1wA6OYdHtDU2cUPW7/WQJ25T7/zxm0e83rJKQVP5clPGOQ9Ig
        mOZfh2AoaTWdx1lEfRgx2J6hGpoHm67iFxVFDhI=
X-Google-Smtp-Source: AKy350am+pGQMfbm5jPi91+OndDp9rTOLgFWEwm72GqDmlSPMRbXfu0cRu5vR5g3+irrsB2ecgJyiw==
X-Received: by 2002:a05:6808:28d:b0:38b:37dc:88d3 with SMTP id z13-20020a056808028d00b0038b37dc88d3mr1792757oic.45.1681861480844;
        Tue, 18 Apr 2023 16:44:40 -0700 (PDT)
Received: from localhost.localdomain ([2804:14d:5c5e:44fb:4981:84ab:7cf2:bd9a])
        by smtp.gmail.com with ESMTPSA id o10-20020acad70a000000b0038bae910f7bsm5084357oig.1.2023.04.18.16.44.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Apr 2023 16:44:40 -0700 (PDT)
From:   Pedro Tammela <pctammela@mojatatu.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, simon.horman@corigine.com,
        Pedro Tammela <pctammela@mojatatu.com>
Subject: [PATCH net-next v4 0/5] net/sched: act_pedit: minor improvements
Date:   Tue, 18 Apr 2023 20:43:49 -0300
Message-Id: <20230418234354.582693-1-pctammela@mojatatu.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series aims to improve the code and usability of act_pedit for
netlink users.

Patches 1-2 improves error reporting for extended keys parsing with extack.

Patch 3 checks the static offsets a priori on create/update. Currently,
this is done at the datapath for both static and runtime offsets.

Patch 4 removes a check from the datapath which is redundant since the
netlink parsing validates the key types.

Patch 5 changes the 'pr_info()' calls in the datapath to rate limited
versions.

v3->v4: Break the old patch 1 into two patches.
v2->v3: Propagate nl_parse errors in patch 1 like the original version.
v1->v2: Added patch 3 to the series as discussed with Simon.

Pedro Tammela (5):
  net/sched: act_pedit: simplify 'ex' key parsing error propagation
  net/sched: act_pedit: use extack in 'ex' parsing errors
  net/sched: act_pedit: check static offsets a priori
  net/sched: act_pedit: remove extra check for key type
  net/sched: act_pedit: rate limit datapath messages

 net/sched/act_pedit.c | 88 +++++++++++++++++++++----------------------
 1 file changed, 42 insertions(+), 46 deletions(-)

-- 
2.34.1

