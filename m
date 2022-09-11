Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A00F85B5053
	for <lists+netdev@lfdr.de>; Sun, 11 Sep 2022 19:39:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229566AbiIKRjX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Sep 2022 13:39:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbiIKRjV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Sep 2022 13:39:21 -0400
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.126.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E5681CB2F;
        Sun, 11 Sep 2022 10:39:17 -0700 (PDT)
Received: from weisslap.fritz.box ([31.19.218.61]) by mrelayeu.kundenserver.de
 (mreue012 [212.227.15.167]) with ESMTPSA (Nemesis) id
 1N2BQM-1pTPU80Oy6-013hgl; Sun, 11 Sep 2022 19:39:02 +0200
From:   =?UTF-8?q?Michael=20Wei=C3=9F?= <michael.weiss@aisec.fraunhofer.de>
To:     michael.weiss@aisec.fraunhofer.de
Cc:     Pravin B Shelar <pshelar@ovn.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        dev@openvswitch.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] net: openvswitch: allow metering in non-initial user namespace
Date:   Sun, 11 Sep 2022 19:38:24 +0200
Message-Id: <20220911173825.167352-2-michael.weiss@aisec.fraunhofer.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220911173825.167352-1-michael.weiss@aisec.fraunhofer.de>
References: <20220911173825.167352-1-michael.weiss@aisec.fraunhofer.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:w/ZIwJ+8nh0FNsS3l1YJRPVdBgx4sNNx74rYQEKqYK507/lgsNC
 DfiX5KqbUfq8xLewqauUZsW4nemeKXm5KG7jylWLaeKUkeQgowinbVHu9mu0ro88CNBiQ49
 V/ECAt946K7QBKOHnsmohJiHkPffV3Mqo+M1JYrXoDoRrTZ0ui3xvV1wnt3Gwnl6bZ74BxO
 r+AW26zOooCjM9D+dG8hA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:hMwyr5DwtJM=:DJCNPb7Ejd+YkGeiqxlq4H
 i3O+AlMvg1N+Eh8oIR/57zCeU8p54zW2HNiH0hXirbYPpa44LaSFJms478RigobsVw/1itxhu
 H/m4FWFXk/YLlaCELPvf4Y9sHuow4S0RMTgN0XoqlPxcJcMazKVJqQWlZ7I0gMkX8Kj9pSUX8
 SoiOMRdZqiQCdKoCM/+isG9eQcDExz54kik4iMFt5GoehGgbz75n8b5rjbdKDDWu5GXLwRn26
 JE3vvJ8R3jePk1zUYez8hb0qc0sBpTua5/WEeCNzocYdvaeLBYvG8G1cCEUoqa4ArEHnOr7a+
 SkrCvQgz/dkUPE4+2zfWqM14a0qvc239HU6VOxQp1b6gzY4QsS8ogVLIbrUuNWCy68AaZTtFD
 tJzU2886CR6t4uOfy/Q5xs4blQ8LJq9YAH5xWBNWlUNnRcLRvTIRjG5Ykzdc/D4bfMjGf4d23
 ebdlythCPaEZa4/2L0qy0wBdxKDQTBLIDuGqdpLnejXqRcduI6TVx8tGgMmLCVgm8IA249yLo
 yxoCcJKg40sgjDr4LBeM29iVrn8TUwFwLJXq/b3sPorAxY5T9L7AlKhNZt+tZAy9oLKMqQU+C
 0sLEv2hUGsd19o7NC4SMQGzokKXcdaiy2hauPYJNYCjPXLgDT3EJgLvCPCYP9gWHYdx+eihxW
 P0WAECMtRDXFstpSrQSjztZdfPWMRBagfXLhSv+0y/dOkf4OMnHgbbHGinfUr/EQBpK/EkTN9
 pV3hgveQdJyDGCV2ZF4xXzEhkfEP+4WsqYff2t0itW6PxXt2VJLBviyzSkppGwadi1WN1JVNW
 TXJdYSYqT4GX4ihbQ0C2RLUAP4Eug==
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Netlink interface for metering was restricted to global CAP_NET_ADMIN
by using GENL_ADMIN_PERM. To allow metring in a non-inital user namespace,
e.g., a container, this is changed to GENL_UNS_ADMIN_PERM.

Signed-off-by: Michael Weiß <michael.weiss@aisec.fraunhofer.de>
---
 net/openvswitch/meter.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/openvswitch/meter.c b/net/openvswitch/meter.c
index 04a060ac7fdf..e9ef050a0dd5 100644
--- a/net/openvswitch/meter.c
+++ b/net/openvswitch/meter.c
@@ -687,9 +687,9 @@ static const struct genl_small_ops dp_meter_genl_ops[] = {
 	},
 	{ .cmd = OVS_METER_CMD_SET,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
-		.flags = GENL_ADMIN_PERM, /* Requires CAP_NET_ADMIN
-					   *  privilege.
-					   */
+		.flags = GENL_UNS_ADMIN_PERM, /* Requires CAP_NET_ADMIN
+					       *  privilege.
+					       */
 		.doit = ovs_meter_cmd_set,
 	},
 	{ .cmd = OVS_METER_CMD_GET,
@@ -699,9 +699,9 @@ static const struct genl_small_ops dp_meter_genl_ops[] = {
 	},
 	{ .cmd = OVS_METER_CMD_DEL,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
-		.flags = GENL_ADMIN_PERM, /* Requires CAP_NET_ADMIN
-					   *  privilege.
-					   */
+		.flags = GENL_UNS_ADMIN_PERM, /* Requires CAP_NET_ADMIN
+					       *  privilege.
+					       */
 		.doit = ovs_meter_cmd_del
 	},
 };
-- 
2.30.2

