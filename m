Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DAF56EF7AA
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 17:19:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241267AbjDZPTy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 11:19:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241266AbjDZPTx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 11:19:53 -0400
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68BB06581
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 08:19:46 -0700 (PDT)
Received: by mail-qk1-x735.google.com with SMTP id af79cd13be357-74df41e2e61so379116185a.3
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 08:19:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1682522385; x=1685114385;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ovWq5VhmBvgIp6He2y2dqOTFqocFoccuMULvHPkxqV8=;
        b=BUpUMnFxxxlzc+IZcb8bBWkVgvbSpkEs4yGwvlAsciqFRvrzmEg023pB2H4xlyIxVL
         uy0/xN+v9ucPlSDm5cFGu6hmwKD4RseIJbEQfm31nXIk6Y3rgt8eoJThzQwRUUPaaUB8
         /7CSr8GPbhLqngVaMNi0WXu0AH9ASn4tjSDTK/76AmwD4XoNIOYyUdy0VK+vLI9rE5YI
         lJfv4GknbEKXEO2F0x4gGS8hhXIUZzXpfCPrrTL0NXZpi9j0v3GfdaZhdk7zNl/qhtY4
         dkvLUNRSAnatbIhmhHIg0J8EczQ8JKVPfU6cLuG1/u6xrXffi71j2qoYOaYeXjn82t8c
         liXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682522385; x=1685114385;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ovWq5VhmBvgIp6He2y2dqOTFqocFoccuMULvHPkxqV8=;
        b=b8r0zedNJKA9wCAuo4+1oHTzJURR3iGb5EkjMUV5PgSCK5E/0vzZML//uSdwE1RsUA
         rnkFZnO28qHHFPRbki6aHDqDQa3gboUnwBqKxX7mc922WhYs6Cv1/gpjZKVcvjG1jwnw
         L1gzkleC2HZ5Q9xT6htlFSudb3Z6dMX3kiOpDGw6dsDGAFlEj3WGV2NcgTBCge/FnT51
         nVW4+ngJvA8Ql28Qy6zIXoLT9Pmwrt/UyDkiOGYqb2XS08SIFaxwQgbUb3M4WKy9NegP
         yhm0xuaD2Wl4Qjo8KfIowXbAr2/oIjxLfw6xcXNgFS2U5pxPxw6oMh38eB5Y+4hdwMBH
         /RqQ==
X-Gm-Message-State: AC+VfDyIv+pb5GCFx/F7vGffSYqLcqvbEN7vW3VHamj2ZRIKHImDWZAf
        gIwLZotv3754wu3itbbp+xiGYw==
X-Google-Smtp-Source: ACHHUZ5gcHROzTHpKUf47kqrXKUmBiCdje7ous2Z4vVIggEN3UoShVaP83aV+zVp5XnEibQmB3YvBw==
X-Received: by 2002:ac8:5c8e:0:b0:3f1:e81f:288 with SMTP id r14-20020ac85c8e000000b003f1e81f0288mr1094023qta.68.1682522385445;
        Wed, 26 Apr 2023 08:19:45 -0700 (PDT)
Received: from localhost.localdomain (bras-base-kntaon1618w-grc-29-174-95-194-35.dsl.bell.ca. [174.95.194.35])
        by smtp.gmail.com with ESMTPSA id cb7-20020a05622a1f8700b003ee4b5a2dd3sm1018558qtb.21.2023.04.26.08.19.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Apr 2023 08:19:44 -0700 (PDT)
From:   Victor Nogueira <victor@mojatatu.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, Victor Nogueira <victor@mojatatu.com>
Subject: [PATCH net v3] net/sched: act_mirred: Add carrier check
Date:   Wed, 26 Apr 2023 15:19:40 +0000
Message-Id: <20230426151940.639711-1-victor@mojatatu.com>
X-Mailer: git-send-email 2.25.1
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

There are cases where the device is adminstratively UP, but operationally 
down. For example, we have a physical device (Nvidia ConnectX-6 Dx, 25Gbps)
who's cable was pulled out, here is its ip link output:

5: ens2f1: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc mq state DOWN mode DEFAULT group default qlen 1000
    link/ether b8:ce:f6:4b:68:35 brd ff:ff:ff:ff:ff:ff
    altname enp179s0f1np1

As you can see, it's administratively UP but operationally down.
In this case, sending a packet to this port caused a nasty kernel hang (so
nasty that we were unable to capture it). Aborting a transmit based on
operational status (in addition to administrative status) fixes the issue.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Victor Nogueira <victor@mojatatu.com>
v1->v2: Add fixes tag
v2->v3: Remove blank line between tags + add change log, suggested by Leon
---
 net/sched/act_mirred.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/act_mirred.c b/net/sched/act_mirred.c
index ec43764e92e7..0a711c184c29 100644
--- a/net/sched/act_mirred.c
+++ b/net/sched/act_mirred.c
@@ -264,7 +264,7 @@ TC_INDIRECT_SCOPE int tcf_mirred_act(struct sk_buff *skb,
 		goto out;
 	}
 
-	if (unlikely(!(dev->flags & IFF_UP))) {
+	if (unlikely(!(dev->flags & IFF_UP)) || !netif_carrier_ok(dev)) {
 		net_notice_ratelimited("tc mirred to Houston: device %s is down\n",
 				       dev->name);
 		goto out;
-- 
2.25.1

