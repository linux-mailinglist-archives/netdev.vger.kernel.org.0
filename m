Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B66FE5E7C0E
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 15:39:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231876AbiIWNj2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 09:39:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbiIWNj0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 09:39:26 -0400
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.17.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDDE6139BFE;
        Fri, 23 Sep 2022 06:39:21 -0700 (PDT)
Received: from weisslap.fritz.box ([31.19.218.61]) by mrelayeu.kundenserver.de
 (mreue107 [212.227.15.183]) with ESMTPSA (Nemesis) id
 1MxmJs-1pU5KV2WtS-00zJGg; Fri, 23 Sep 2022 15:39:01 +0200
From:   =?UTF-8?q?Michael=20Wei=C3=9F?= <michael.weiss@aisec.fraunhofer.de>
To:     Paolo Abeni <pabeni@redhat.com>, Pravin B Shelar <pshelar@ovn.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Joe Stringer <joe@cilium.io>, Andy Zhou <azhou@ovn.org>,
        =?UTF-8?q?Michael=20Wei=C3=9F?= <michael.weiss@aisec.fraunhofer.de>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        dev@openvswitch.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 net-next 1/2] net: openvswitch: allow metering in non-initial user namespace
Date:   Fri, 23 Sep 2022 15:38:19 +0200
Message-Id: <20220923133820.993725-2-michael.weiss@aisec.fraunhofer.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220923133820.993725-1-michael.weiss@aisec.fraunhofer.de>
References: <20220923133820.993725-1-michael.weiss@aisec.fraunhofer.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:8BJhdeANIbyU9Gyu9QqbOBrCdMkiP8dsWL+xJhpcwLoeQRcOGhd
 D9NXxrNUUG4yYRqLdTnPi5/StOsE7PbxkHQ2NQ3ZDgGm+l9soYZIW0OhQnt4D6Zoqro1H5G
 1fVwaU6qAzrMmH6crtn3bxgZWZ9ILiX56NSxPRQTv8On9X9UL09o+3U6IbQNb3QuYimhsTJ
 ZRq1UhutwVFfu6eTc0MaA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:z0HvyUFCiHY=:C5pE8R7+bGXr8IfUQN/kQ+
 GSqPi5vKXAnh8kQCzApJQF+T2PGI7HdnzyL9RJJyvzlZrl7xi9KeaYnjt6yTKLemA4gc5U/mw
 tT/P9es9ffLfCyK4P9XPtDHRPalA+Fb+ayrfFzIWM7kSWBzOFmI/iBONEPaj+0Hj06M1CSvFD
 crZO+5zGCBR2pQFN/NI7GGzQUquUasLa5N1d9ScLYvSqnfIFbgPObEUqdDI8LVIrbom9tLMa0
 To2ruDWyDWeMRfaIjLVU7pUNEoVww/F9Jym84PE8yNE/UkBtT7zJAhxe8fNutzOnXZwhgDL3v
 A56m+VRfBi4qVax3sG3eFNwKj/sbjRy69jc8uy5Q85tazOLF9DHZued368QMCDafSPNkNuoJU
 FBAVQzr2FSKu+ZWoQRwi5WzEqZ1+mea7zc5CaNGPly3+Ee8mHFZhLy0hJaBBDaiwnAeYHX1wL
 SafX7Y4ywwksasMM4OGOV2LuKss3LMP1pkScVqtrYOQvZxlnr1NGFvkhn+zfWAhV8JqxuOsRP
 DFhNRz8WWJeMSlqjtZwy4wbz5OTP4rCq/eDAWkV4EGloe7AaseyWvG7I51rxzwRsrYm1CiSS2
 16z8d8K7hi7RM3+4WFiXnHxxgZaC+AVxLUHV2/FVDTUMh7vZPxaR6MPC4jHCtyewzdr+mDHca
 OkkSURN9otO4cMtRm3U3FaiphM+Pfu7UmKRVqCEyWpcdRRcM0wCfJpy92L/QNnANDZi95XtuL
 9JiZk+xMEfcQbRqZIYXkQYWZ6OP2DoqSPowF0cds7UwZ9rEMg8ud9cXvm82ZYgo8ftbA8ZoWd
 C1VthxIEn60oO/jnNNZY7Al2seRlQ==
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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
 net/openvswitch/meter.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/net/openvswitch/meter.c b/net/openvswitch/meter.c
index 51111a9009bd..6e38f68f88c2 100644
--- a/net/openvswitch/meter.c
+++ b/net/openvswitch/meter.c
@@ -343,7 +343,7 @@ static struct dp_meter *dp_meter_create(struct nlattr **a)
 			return ERR_PTR(-EINVAL);
 
 	/* Allocate and set up the meter before locking anything. */
-	meter = kzalloc(struct_size(meter, bands, n_bands), GFP_KERNEL);
+	meter = kzalloc(struct_size(meter, bands, n_bands), GFP_KERNEL_ACCOUNT);
 	if (!meter)
 		return ERR_PTR(-ENOMEM);
 
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

