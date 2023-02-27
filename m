Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A25E6A499A
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 19:23:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbjB0SXk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 13:23:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229607AbjB0SXj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 13:23:39 -0500
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A9A6DBD7
        for <netdev@vger.kernel.org>; Mon, 27 Feb 2023 10:23:26 -0800 (PST)
Received: by mail-oi1-x22d.google.com with SMTP id e21so5948711oie.1
        for <netdev@vger.kernel.org>; Mon, 27 Feb 2023 10:23:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=cMsaFqojPw6u+Mvo9oJfaqHv1MQo5MCqHX130EoEZA4=;
        b=Tn+ppYkJ4854KA9BLznU7TfTlRII01NBGTTZ0j4Ub0FkjfZVCTddToVcqgwvrpJgf6
         P7FieupXKOxxhIdHj2fGPwG3DHF/oHNomKumJmcGOj31NM4Z/gmILG6e4pS2BH/6ymzz
         1q4SUeEltBvRvvR3eZCbcqirb5UGFYcgrRZ0GBwznV55hCnGH5Y+mBDkGQJB+a/aEpr9
         qyXtJcxvAp/Qo7inqFoLkqgDHBTrqduS8p+Qp63QzUUEv4GHdLqS9snwFMROsSKrnLW9
         O6r6IQApfnWQCbFJdY/r3I1ptDQ7HoI0Fyf7uTcc9EQWZNTKB5OBKehhd5OTN8cZ6u+q
         R1zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cMsaFqojPw6u+Mvo9oJfaqHv1MQo5MCqHX130EoEZA4=;
        b=zoBqh98QQvenmfxTn4+Lic/IySeG3aPp+tYGRZ2hUew+7tbLezBW1FyYRLzIhStVp+
         UK7sCTHDxdO6dVRW83lGSdhNtjA4tCfMculArw9fubaH7KGfwgnAGxFXQPaOjgKLONAA
         ZlwawhlKcDrCPspdRklTf8/vSHGxgiI1212o7hqg7wSgYPfhd2yypHKPKFk0dVCJ8hE+
         bAuVIdIMQ6k2JaHLgLPuEhFSpHuwvuZvtNS0wns1drKbsPEQ7AQwopnnme8kxdenx0mr
         ezsPXRu7W/tx4Un5IyQ77y7mH6Zg4tV2FEjTzbA0iAck+hXDmg/8SQ62r1v00+fAuV0N
         3zcw==
X-Gm-Message-State: AO0yUKXqhAPf9CzQFOd+pgVAVCtAUj3eU5b0eFH+Ov8ftBbm/oB7l4v1
        OXYxPzN+xf+Vt5wgxoP1kPTPh4eykO8umwpA
X-Google-Smtp-Source: AK7set87I2eGcev+TloFaR+uJDLZcTldjB5oj9WzB7o69WEFzWW5VjS++MebDwXRGdHviiQn5py4gw==
X-Received: by 2002:a54:4591:0:b0:377:fae1:1175 with SMTP id z17-20020a544591000000b00377fae11175mr50512oib.11.1677522205696;
        Mon, 27 Feb 2023 10:23:25 -0800 (PST)
Received: from localhost.localdomain ([2804:14d:5c5e:4698:4174:ef7a:c9ab:ab62])
        by smtp.gmail.com with ESMTPSA id a6-20020a056808120600b0037d59e90a07sm3403381oil.55.2023.02.27.10.23.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Feb 2023 10:23:25 -0800 (PST)
From:   Pedro Tammela <pctammela@mojatatu.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, amir@vadai.me, dcaratti@redhat.com,
        willemb@google.com, ozsh@nvidia.com, paulb@nvidia.com,
        Pedro Tammela <pctammela@mojatatu.com>
Subject: [PATCH net v2 0/3] net/sched: fix action bind logic
Date:   Mon, 27 Feb 2023 15:22:54 -0300
Message-Id: <20230227182256.275816-1-pctammela@mojatatu.com>
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

Some actions are not handling the case where an action can be created and bound to a
filter independently. These actions are checking for parameters only passed
in the netlink message for create/change/replace, which then errors out
for valid uses like:
tc filter ... action pedit index 1

In the iproute2 side, we saw a couple of actions with their parsers
broken when passing "index 1" as the only action argument, while the kernel
side accepted it correctly. We fixed those as well.

v1->v2:
- Missed clean up pointed out by Simon

Pedro Tammela (3):
  net/sched: act_pedit: fix action bind logic
  net/sched: act_mpls: fix action bind logic
  net/sched: act_sample: fix action bind logic

 net/sched/act_mpls.c   | 66 +++++++++++++++++++++++-------------------
 net/sched/act_pedit.c  | 58 ++++++++++++++++++++-----------------
 net/sched/act_sample.c | 11 +++++--
 3 files changed, 77 insertions(+), 58 deletions(-)

-- 
2.34.1

