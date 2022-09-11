Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 328785B5056
	for <lists+netdev@lfdr.de>; Sun, 11 Sep 2022 19:39:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229577AbiIKRjY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Sep 2022 13:39:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbiIKRjW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Sep 2022 13:39:22 -0400
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.126.135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 329002A424;
        Sun, 11 Sep 2022 10:39:17 -0700 (PDT)
Received: from weisslap.fritz.box ([31.19.218.61]) by mrelayeu.kundenserver.de
 (mreue012 [212.227.15.167]) with ESMTPSA (Nemesis) id
 1M5jA2-1oQGBJ1wgE-0079XX; Sun, 11 Sep 2022 19:39:03 +0200
From:   =?UTF-8?q?Michael=20Wei=C3=9F?= <michael.weiss@aisec.fraunhofer.de>
To:     michael.weiss@aisec.fraunhofer.de
Cc:     Pravin B Shelar <pshelar@ovn.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        dev@openvswitch.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] net: openvswitch: allow conntrack in non-initial user namespace
Date:   Sun, 11 Sep 2022 19:38:25 +0200
Message-Id: <20220911173825.167352-3-michael.weiss@aisec.fraunhofer.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220911173825.167352-1-michael.weiss@aisec.fraunhofer.de>
References: <20220911173825.167352-1-michael.weiss@aisec.fraunhofer.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:gpLQ3c73SdDEYMlyQGcD2ju4281fFu829DmezQnPTBEZ4ckL7Dy
 o/GWcNeoeESSuI5LLfnTzuI9G3v79KI4adgJUA9SNSpFDHybQLkkkLOwaf2cuAUi1prG6s7
 4KL7kXfmeoCGhyWTo7rPh0nOzg3TcCYj0OHWLHRVpCWrhQVLMZTOJRG+mBKs+qfWsJPLpQZ
 HaIv1wnUpoeueBYl/9OGQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:OL3ZAcrJl6A=:dAi/XX0PtUHUqZaCfv7ZUJ
 4mgU7+DVleH4/NiRiBQ6pBXZQNTN8uTDTEcW0zqs3J+tJ3ILZf7GXtJwUbAM4i4aBGMtzk7vB
 aAKl7Ns7Qxq1e4lQupZ/IHbKR2VXHsaL7PiJ5E/PSbub/eSLCO5Qgpqs9iZ5DfpiIWrFdLZP5
 A7tnftiiL6t+8lEqy0cOQxxOPRa63V9BQlMVGVSTTuQ/GcQmRruwVxbd+s9N7lgljwqi5yltJ
 PQGCgs5Z6chGQXA76eRnbosS/WxrHHWlHEFEV8kJwKuntXLchSrGzgnJ9OxhIMGVupHQmlrJP
 xn4YirTwu973xrhxdrAZj1PPZfxRQtAOEh+/KUHaWs2q6KQnAzTxrnB/5l8zgLMnq/G6o/z6+
 NSmEpgnVUUZjFFQnyt8+TEAknLkv42+zRyisnzDqUC4t/Tmqmh5+dH1lTSPhroxq8NWjzskrU
 Ca4Vh5bDayDP7pxxqtaeoFmxe7lgUouQ0/7urupIjYLdKWREIDK4eBQlELz4o5EpodHaEvdIz
 mFHgc45eePlq1KGpPSr1+m/UnSjd4tistKJzOfXtoPcl8ttFNBTgOwWosctITsjYXwfex1Lb2
 zMECuLqKdHFhHwZsrR09ef6eD4cUmBEspSv06X9/UmCfBQ0cT+OG2URHstY7YtwZekAaX9jNc
 tsKJvH708i2n10MDAuyrH9j0CWgbJqVkGUAnB6jGuh3OwUXMakMsV51XrUj1Em4nNqEwfcx6l
 PzopeQu6I6vs071JnfPV4yFRMRXyLBe75W9mO6j5vr5n0wcsSDxOBL0wD6G8y5eJS4nVdTY2z
 2lYFYhRHPabDWEZ1bTC0Ab/5axFfw==
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
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
 net/openvswitch/conntrack.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
index 4e70df91d0f2..23f5b6261364 100644
--- a/net/openvswitch/conntrack.c
+++ b/net/openvswitch/conntrack.c
@@ -2252,14 +2252,14 @@ static int ovs_ct_limit_cmd_get(struct sk_buff *skb, struct genl_info *info)
 static const struct genl_small_ops ct_limit_genl_ops[] = {
 	{ .cmd = OVS_CT_LIMIT_CMD_SET,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
-		.flags = GENL_ADMIN_PERM, /* Requires CAP_NET_ADMIN
-					   * privilege. */
+		.flags = GENL_UNS_ADMIN_PERM, /* Requires CAP_NET_ADMIN
+					       * privilege. */
 		.doit = ovs_ct_limit_cmd_set,
 	},
 	{ .cmd = OVS_CT_LIMIT_CMD_DEL,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
-		.flags = GENL_ADMIN_PERM, /* Requires CAP_NET_ADMIN
-					   * privilege. */
+		.flags = GENL_UNS_ADMIN_PERM, /* Requires CAP_NET_ADMIN
+					       * privilege. */
 		.doit = ovs_ct_limit_cmd_del,
 	},
 	{ .cmd = OVS_CT_LIMIT_CMD_GET,
-- 
2.30.2

