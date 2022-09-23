Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E5435E7C0F
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 15:39:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231845AbiIWNj3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 09:39:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231783AbiIWNj1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 09:39:27 -0400
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.17.13])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE50A13BCEC;
        Fri, 23 Sep 2022 06:39:21 -0700 (PDT)
Received: from weisslap.fritz.box ([31.19.218.61]) by mrelayeu.kundenserver.de
 (mreue107 [212.227.15.183]) with ESMTPSA (Nemesis) id
 1MEF87-1oRVkB2g6P-00ABiH; Fri, 23 Sep 2022 15:39:02 +0200
From:   =?UTF-8?q?Michael=20Wei=C3=9F?= <michael.weiss@aisec.fraunhofer.de>
To:     Paolo Abeni <pabeni@redhat.com>, Pravin B Shelar <pshelar@ovn.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Joe Stringer <joe@cilium.io>, Andy Zhou <azhou@ovn.org>,
        =?UTF-8?q?Michael=20Wei=C3=9F?= <michael.weiss@aisec.fraunhofer.de>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        dev@openvswitch.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 net-next 2/2] net: openvswitch: allow conntrack in non-initial user namespace
Date:   Fri, 23 Sep 2022 15:38:20 +0200
Message-Id: <20220923133820.993725-3-michael.weiss@aisec.fraunhofer.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220923133820.993725-1-michael.weiss@aisec.fraunhofer.de>
References: <20220923133820.993725-1-michael.weiss@aisec.fraunhofer.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:LHiZC01TYNuQgQi1n7k4fjs48kn5evKqTxORFX0N4WGhIiWE1qt
 ytlmRPcQeMizccFmES5wgcNTy73yUGF1YYehKezF6UnKhoaDdy6RMYimmM5rpUkO2ChLYyO
 wuiFKVoh9BkATo37lKSMYqGIOcltEms47WoH0diAa9JHiPZlAa9v6g52Nd84mDQqg1kDBco
 eAPyAKiEIABd7x3Tpk2jA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:NoCYHAXAiuc=:BkTba5eXU+OtZQg/tp7Xf/
 LPiN3nxlZB66+C5CPHChpTEAVl0ILzWTZFvYsuMV4MusszuRQiuD5ngdyVOLD+O3olIkF9Shi
 Ibd9vy9ROYLZe006fVOZiyHcKpkVVVstJiHO415iiA+bCnXanu5SQ9yxE+LqnThpzcCx1tLqC
 zMwRKzmzKnr6DeRJP2kF+h4pWlQWjivfZHBwNYM+yshldHlAbNgmvXQlZHSE/9+RTQWHU359j
 UJ+IUzWezMojl2SrSpCbXj5pQR+cERBrPVIlSXs5VNmd23ilQvRYAWE9Qbn0wNIWcohCtOv1g
 VJl2arIHAoXhzne3aYYQvPEzaEKMLcjXEk9HG5GHqo6Q7HyBxwQSg2wUb716Wacyws4PGUfyG
 q1UptSqcYaANoH6/V+0JibQhny1NgbJbf4cqAugCL4KFM2TkDZzPuWl5ZC2HiuSpLQ3R2vM1h
 45FN5ws/KwSX3kkSns91oweWOiFHsuOKy4ztVTTk1qyxqwPQf6jdn/lQFn/VULQha0hhJEg45
 TLvoE3IZY5Ok38iKZ5S+rwvKNqXinixCcektKi6KrC/u06rgdqJinv9FjTxjC4RromsG0SQyp
 uNclstL3Ul+4djrODCAyVvqVLOZ1jcZMjD8Rus2Dj9rlr8Tjbd69uuAyr+sQklDTYcujYXv3Z
 kXKh0D2bhdn5VuxDsbalzhvbFVKYwQcSePChm1Cgaltk3Ldi255l2O2AiI5PQSiCNfRStF4zS
 IF7b9ef8oRA5ICrRsvFlxeGna8aKEsx5+JLof3g9Lv3xZmoKF/t/r46PN0uvunbVbtlYX1WMW
 PPHmjNiYod+4QvRn0f2iquDR/L/BQ==
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Similar to the previous commit, the Netlink interface of the OVS
conntrack module was restricted to global CAP_NET_ADMIN by using
GENL_ADMIN_PERM. This is changed to GENL_UNS_ADMIN_PERM to support
unprivileged containers in non-initial user namespace.

Signed-off-by: Michael Weiß <michael.weiss@aisec.fraunhofer.de>
---
 net/openvswitch/conntrack.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
index 48e8f5c29b67..cb255d8ed99a 100644
--- a/net/openvswitch/conntrack.c
+++ b/net/openvswitch/conntrack.c
@@ -1982,7 +1982,8 @@ static int ovs_ct_limit_set_zone_limit(struct nlattr *nla_zone_limit,
 		} else {
 			struct ovs_ct_limit *ct_limit;
 
-			ct_limit = kmalloc(sizeof(*ct_limit), GFP_KERNEL);
+			ct_limit = kmalloc(sizeof(*ct_limit),
+					   GFP_KERNEL_ACCOUNT);
 			if (!ct_limit)
 				return -ENOMEM;
 
@@ -2252,14 +2253,16 @@ static int ovs_ct_limit_cmd_get(struct sk_buff *skb, struct genl_info *info)
 static const struct genl_small_ops ct_limit_genl_ops[] = {
 	{ .cmd = OVS_CT_LIMIT_CMD_SET,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
-		.flags = GENL_ADMIN_PERM, /* Requires CAP_NET_ADMIN
-					   * privilege. */
+		.flags = GENL_UNS_ADMIN_PERM, /* Requires CAP_NET_ADMIN
+					       * privilege.
+					       */
 		.doit = ovs_ct_limit_cmd_set,
 	},
 	{ .cmd = OVS_CT_LIMIT_CMD_DEL,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
-		.flags = GENL_ADMIN_PERM, /* Requires CAP_NET_ADMIN
-					   * privilege. */
+		.flags = GENL_UNS_ADMIN_PERM, /* Requires CAP_NET_ADMIN
+					       * privilege.
+					       */
 		.doit = ovs_ct_limit_cmd_del,
 	},
 	{ .cmd = OVS_CT_LIMIT_CMD_GET,
-- 
2.30.2

