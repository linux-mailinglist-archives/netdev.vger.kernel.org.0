Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92D745BF2AD
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 03:21:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231153AbiIUBVS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 21:21:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230489AbiIUBVN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 21:21:13 -0400
Received: from mout.kundenserver.de (mout.kundenserver.de [217.72.192.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEEC16E2F5;
        Tue, 20 Sep 2022 18:21:10 -0700 (PDT)
Received: from weisslap.fritz.box ([31.19.218.61]) by mrelayeu.kundenserver.de
 (mreue107 [212.227.15.183]) with ESMTPSA (Nemesis) id
 1N3bCH-1pIZCO2eUF-010d9d; Wed, 21 Sep 2022 03:20:47 +0200
From:   =?UTF-8?q?Michael=20Wei=C3=9F?= <michael.weiss@aisec.fraunhofer.de>
To:     Paolo Abeni <pabeni@redhat.com>, Pravin B Shelar <pshelar@ovn.org>,
        "David S . Miller" <davem@davemloft.net>
Cc:     =?UTF-8?q?Michael=20Wei=C3=9F?= <michael.weiss@aisec.fraunhofer.de>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        dev@openvswitch.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 net 2/2] net: openvswitch: allow conntrack in non-initial user namespace
Date:   Wed, 21 Sep 2022 03:19:46 +0200
Message-Id: <20220921011946.250228-3-michael.weiss@aisec.fraunhofer.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220921011946.250228-1-michael.weiss@aisec.fraunhofer.de>
References: <20220921011946.250228-1-michael.weiss@aisec.fraunhofer.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:BZwZqra0fOpBo5DVYUl5XUVi7Kok+GGwO5onMDYdcGcI7jZt+Za
 5QHLkghZdmb6mEzWfUu3bebBmpyDEUBMN8ytbZLBK2BlqhltE0PmQUiN7lc7xBLGvVqhOG3
 Ix/n2Cy72dQ+lWNUQf+UOAgryZI6qJuwB1kDvYRxfGL7Q0bvX7nqbNBJuxt2xYGNgS5syc4
 dWsEDIIcNfJyoHq2pFoow==
X-UI-Out-Filterresults: notjunk:1;V03:K0:oc1+IDA1xcs=:1w107+qGS9SSneJIbfovYW
 qSxlP3HtT60j3vdnGvTDgF4JZJUFxacnPDhYT0JMpIoD/U2x0yMJqLvOWQfIPqX/skSKlzDoJ
 wPt4WAlSfKst4e7FWu8NReJr0A5ON5Y7lB3pssU2Jesy2dFNk+gUfKg3ypK8G4eWJAvdv7uyU
 AXH0fYRRlRj0nJOk+s8f3nl+Yd9jgaRZpR3VxmeBwDIHaj7UhmrrJZPFecFX/rPUZknFMIGrJ
 HOOtFkpNLjXOXu2AjTA7Ei97UGoH/78vtsW8H8/Fmal5Ttk4mVv4Khxd6MLcxFLpCQPmJvqYA
 GfPnpdb2tfYNIFxncb4kE6CwcJ+G42gNxJNd9f8i/xd9E6gAzMbZykxxe0PvEux1dPogL0t1O
 Be6o1D/mSwdeZ9S47y2/vuBLbRutummtdTGeGEsGQwDIp7bLRTv2tY48JodFIh4GoHaTqnBh1
 MQEfKOVsObM3sDL8UlplgKRPsN7mJzN7V+dN/NomsHjCkJAEauddsTGpY1PAfeLafLfUkMofY
 zf8uvjvUO53BZjS2Idv56xdvfLoG5dO8a0CUuuD/RAf4nZD7yo1VvoUyTB3PCSKjboJMiM+bD
 QK4oj0A8gtf6QNFp5BoHlJE13DKejCYhgb71RtXFPniXu8pNTPc9ZN4p4fVlYjAPu2HbFdNFM
 B4acUQsm8C1xe9xY7uI+RmFlsX13ndWnLEQTkiHgo1U4w0kD4PmQu0mtHY/5UyqOV/gqRCe2n
 /SykCRMD/p9/EOIz0pFWD6PchwvxH/lJXnvZoXJjX8RGZLA7JYf75DAf269zPXmWV+ZIfyuH8
 +wsj4Le4S8AtywXG/E4We/gcEu70Q==
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
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
 net/openvswitch/conntrack.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
index 4e70df91d0f2..9142ba322991 100644
--- a/net/openvswitch/conntrack.c
+++ b/net/openvswitch/conntrack.c
@@ -2252,14 +2252,16 @@ static int ovs_ct_limit_cmd_get(struct sk_buff *skb, struct genl_info *info)
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

