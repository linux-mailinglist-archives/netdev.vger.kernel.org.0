Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F7306A1DE6
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 16:01:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230104AbjBXPBd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 10:01:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229630AbjBXPBb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 10:01:31 -0500
Received: from mail-oa1-x36.google.com (mail-oa1-x36.google.com [IPv6:2001:4860:4864:20::36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D47D44DBC3
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 07:01:29 -0800 (PST)
Received: by mail-oa1-x36.google.com with SMTP id 586e51a60fabf-17264e9b575so10753975fac.9
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 07:01:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=s72mSQc4W5QVF4ZFx2TJZek+ALooZA1xeO/KSXL8kkc=;
        b=6/1URl4yTmoUl39YYrroBpIdWBJfEzJcVvfqGRHY/ggX0aCce7PHfoLb29cv/71/QI
         v9kfO9GdeWSRQnULHzUrR0Y9pkErFmFSUd+hBGqVsAT7V8GW30ORRhfxN3sE9mM2BFS0
         vjFpIksGAR7Z68fWuzUI7DHdmMTYCnT7Gh+FLFCZ49U7X2sNkET4fRj637BHdqHW5cgZ
         fTRwjWik0YMyi/YZXiygQTd+o/52tOy5fOIBs1wDEF/5V8UNB7myY3y+L2RRDAsCMJUn
         0inT1zB0h2sykhMIb4zBByr4R1dT09iq/SPYLmfVoq/6QbF1HOhYpK4q0u7HQkJWtx6r
         0I0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=s72mSQc4W5QVF4ZFx2TJZek+ALooZA1xeO/KSXL8kkc=;
        b=VLGOCxLPQW/SyRZ/7zrGmrflR2LMyKxt5/RcVGp/Jz38ANixg4FBTdnR5h7OsfCsWj
         54q7FlZZZJK4NNHsMC4j4qz5qyB3EfPCJGcMvsdw3cQ5zEvJ4nMxgPakANsagyjM6KDI
         gVn0pNgoSS1+qbapkr1+PMaxTsF0Op7P4CJ7XSyG9mntcaWdhIAet28BVFhZzHwiTjST
         urudsUk5YCAZyPf1Gy19wWHYLMEwDv77Cc0spvT/drGxfjWcGXp6clLTYbMpiYVzNnNS
         wRJlSIUOuTGb2DxlVghafp19mimKpFALMMk02zGqlwpNDyPRNltLvTCQQAzY3iMHQ+0A
         R7bQ==
X-Gm-Message-State: AO0yUKVTJ58XHvz5AK9We6zVeWu7QAJ7cnXrTdPEbb2JzT4h+DNvSb66
        ozDBJUO6JMZUl/l3ksbDqSf0YN1YQtQ5+oCC
X-Google-Smtp-Source: AK7set976svRmkjUPztB7Ox7cL+/SDswH1OFfNprzr+IJ5UQD68G4l/BVzS2FHpbGwZbGKU1JlmCdQ==
X-Received: by 2002:a05:6870:f717:b0:172:36bf:e281 with SMTP id ej23-20020a056870f71700b0017236bfe281mr5844335oab.23.1677250888852;
        Fri, 24 Feb 2023 07:01:28 -0800 (PST)
Received: from localhost.localdomain ([2804:14d:5c5e:4698:aecd:86a3:8e0c:a9df])
        by smtp.gmail.com with ESMTPSA id r28-20020a05683002fc00b00686a19ffef1sm3237636ote.80.2023.02.24.07.01.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Feb 2023 07:01:24 -0800 (PST)
From:   Pedro Tammela <pctammela@mojatatu.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, amir@vadai.me, dcaratti@redhat.com,
        willemb@google.com, simon.horman@netronome.com,
        john.hurley@netronome.com, yotamg@mellanox.com, ozsh@nvidia.com,
        paulb@nvidia.com, Pedro Tammela <pctammela@mojatatu.com>
Subject: [PATCH net 0/3] net/sched: fix action bind logic
Date:   Fri, 24 Feb 2023 12:00:55 -0300
Message-Id: <20230224150058.149505-1-pctammela@mojatatu.com>
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

