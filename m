Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EC486ED278
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 18:30:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232036AbjDXQ35 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 12:29:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230434AbjDXQ34 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 12:29:56 -0400
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ADEFD8
        for <netdev@vger.kernel.org>; Mon, 24 Apr 2023 09:29:55 -0700 (PDT)
Received: by mail-qt1-x832.google.com with SMTP id d75a77b69052e-3ef38864360so48674021cf.2
        for <netdev@vger.kernel.org>; Mon, 24 Apr 2023 09:29:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1682353794; x=1684945794;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=4FJr+qgHqM4MO33R6QGPgUx0P5wjlYPCNgqLEeSnKeY=;
        b=frYyIv4LcPSUQ49WXWZ4FqrT3tiF68Ko9Abl2ncm0LcXjM+ZBivfNJ27G9GjrkMMSb
         yh4JaIh3G3AFIfOxjWFiT8CZKxTN4Q4ZxeH+p0SRT2NLpWVzbPltZCJC4Liki17ws+Fu
         jddoXsjeyHxXgbfSiu2Py/HCRYxe+Dl/Q+l7CT33R3PG2pXpMnnvQjxf2/6qI5rg0BZz
         Jrdm3oUm9iuXJGe1hnw8MuwReU6gG7+eEQhIGAJI9wU0lf/+TM3yDqCjfgWNe/9qD7wz
         nHSG6rNS12JYRPwxRPPPIrQnfkaLkFMbPaqJzqcwbzlS258o4+kK78mhTHZHafrf7Jjq
         /pXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682353794; x=1684945794;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4FJr+qgHqM4MO33R6QGPgUx0P5wjlYPCNgqLEeSnKeY=;
        b=CuaprWjwmJc52uPIPEWwxPXYU2AfdeuQZEIb7tSZ/pXsWDASY48nEfpeKGxRRrdxVl
         Q8D24u4L85VTitdM4BcWnzBR45RMrfe/FI53UuItNGzjI4BBaZWY6FZ35JF+uNvSDu5B
         2Yk/I7VMypqZDjoeQ5NO3YDd6zyJ5YXJxnYQ34TWVwXt9bnqcP4D1rim+ys64HAp2yNl
         x6kKrrO8eFALM/cKqa8A8PB/rnQGmrWVEBzP3d+qOWCl2lfrUxHLmn8NoGlYVVmHjrvZ
         DpMEaI/B7RPIV681ovZzJQXxtaH00wlewi3MitH74MllW5z376mUM/al+mY3lqgOuPD4
         l1Uw==
X-Gm-Message-State: AAQBX9fuBGa3ZYx3ySVwD6I/TpU2Th+eaqBIAWNNyT/LJ6L1xFfWRCoF
        UFuxj6qMrWbcPf8I+Pot3I8giQ==
X-Google-Smtp-Source: AKy350ZO8F++kO8y2u3tkkDaphKAlTcPuA4eguePmKLh3jqborT10REYwuK13B+YziH2XYe5D7biMw==
X-Received: by 2002:ac8:5907:0:b0:3ef:3680:b6da with SMTP id 7-20020ac85907000000b003ef3680b6damr25408014qty.16.1682353794124;
        Mon, 24 Apr 2023 09:29:54 -0700 (PDT)
Received: from localhost.localdomain (bras-base-kntaon1618w-grc-29-174-95-194-35.dsl.bell.ca. [174.95.194.35])
        by smtp.gmail.com with ESMTPSA id n83-20020a374056000000b0074d489e517csm3708435qka.24.2023.04.24.09.29.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Apr 2023 09:29:53 -0700 (PDT)
From:   Victor Nogueira <victor@mojatatu.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, kernel@mojatatu.com,
        Victor Nogueira <victor@mojatatu.com>
Subject: [PATCH net] net/sched: act_mirred: Add carrier check
Date:   Mon, 24 Apr 2023 16:29:36 +0000
Message-Id: <20230424162936.537171-1-victor@mojatatu.com>
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

Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Victor Nogueira <victor@mojatatu.com>
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

