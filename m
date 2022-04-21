Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3925250A4A8
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 17:49:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1390307AbiDUPv2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 11:51:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229787AbiDUPv2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 11:51:28 -0400
Received: from ha.nfschina.com (unknown [IPv6:2400:dd01:100f:2:72e2:84ff:fe10:5f45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0AA164738D;
        Thu, 21 Apr 2022 08:48:35 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by ha.nfschina.com (Postfix) with ESMTP id 71E1D1E80D0B;
        Thu, 21 Apr 2022 23:46:02 +0800 (CST)
X-Virus-Scanned: amavisd-new at test.com
Received: from ha.nfschina.com ([127.0.0.1])
        by localhost (ha.nfschina.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 5oMn8UwNA64M; Thu, 21 Apr 2022 23:45:59 +0800 (CST)
Received: from ubuntu.localdomain (unknown [101.228.255.56])
        (Authenticated sender: yuzhe@nfschina.com)
        by ha.nfschina.com (Postfix) with ESMTPA id EA9491E80CF9;
        Thu, 21 Apr 2022 23:45:58 +0800 (CST)
From:   Yu Zhe <yuzhe@nfschina.com>
To:     mareklindner@neomailbox.ch, sw@simonwunderlich.de, a@unstable.cc,
        sven@narfation.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com
Cc:     b.a.t.m.a.n@lists.open-mesh.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, liqiong@nfschina.com,
        kernel-janitors@vger.kernel.org, Yu Zhe <yuzhe@nfschina.com>
Subject: [PATCH] batman-adv: remove unnecessary type castings
Date:   Thu, 21 Apr 2022 08:48:29 -0700
Message-Id: <20220421154829.9775-1-yuzhe@nfschina.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,RDNS_NONE,
        SPF_HELO_NONE,T_SPF_TEMPERROR autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

remove unnecessary void* type castings.

Signed-off-by: Yu Zhe <yuzhe@nfschina.com>
---
 net/batman-adv/bridge_loop_avoidance.c |  4 ++--
 net/batman-adv/translation-table.c     | 10 +++++-----
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/net/batman-adv/bridge_loop_avoidance.c b/net/batman-adv/bridge_loop_avoidance.c
index 7f8a14d99cdb..38cc21370eda 100644
--- a/net/batman-adv/bridge_loop_avoidance.c
+++ b/net/batman-adv/bridge_loop_avoidance.c
@@ -65,7 +65,7 @@ batadv_bla_send_announce(struct batadv_priv *bat_priv,
  */
 static inline u32 batadv_choose_claim(const void *data, u32 size)
 {
-	struct batadv_bla_claim *claim = (struct batadv_bla_claim *)data;
+	struct batadv_bla_claim *claim = data;
 	u32 hash = 0;
 
 	hash = jhash(&claim->addr, sizeof(claim->addr), hash);
@@ -86,7 +86,7 @@ static inline u32 batadv_choose_backbone_gw(const void *data, u32 size)
 	const struct batadv_bla_backbone_gw *gw;
 	u32 hash = 0;
 
-	gw = (struct batadv_bla_backbone_gw *)data;
+	gw = data;
 	hash = jhash(&gw->orig, sizeof(gw->orig), hash);
 	hash = jhash(&gw->vid, sizeof(gw->vid), hash);
 
diff --git a/net/batman-adv/translation-table.c b/net/batman-adv/translation-table.c
index 8478034d3abf..f579060aa503 100644
--- a/net/batman-adv/translation-table.c
+++ b/net/batman-adv/translation-table.c
@@ -106,7 +106,7 @@ static inline u32 batadv_choose_tt(const void *data, u32 size)
 	struct batadv_tt_common_entry *tt;
 	u32 hash = 0;
 
-	tt = (struct batadv_tt_common_entry *)data;
+	tt = data;
 	hash = jhash(&tt->addr, ETH_ALEN, hash);
 	hash = jhash(&tt->vid, sizeof(tt->vid), hash);
 
@@ -2766,7 +2766,7 @@ static void batadv_tt_tvlv_generate(struct batadv_priv *bat_priv,
 	u32 i;
 
 	tt_tot = batadv_tt_entries(tt_len);
-	tt_change = (struct batadv_tvlv_tt_change *)tvlv_buff;
+	tt_change = tvlv_buff;
 
 	if (!valid_cb)
 		return;
@@ -3994,7 +3994,7 @@ static void batadv_tt_tvlv_ogm_handler_v1(struct batadv_priv *bat_priv,
 	if (tvlv_value_len < sizeof(*tt_data))
 		return;
 
-	tt_data = (struct batadv_tvlv_tt_data *)tvlv_value;
+	tt_data = tvlv_value;
 	tvlv_value_len -= sizeof(*tt_data);
 
 	num_vlan = ntohs(tt_data->num_vlan);
@@ -4037,7 +4037,7 @@ static int batadv_tt_tvlv_unicast_handler_v1(struct batadv_priv *bat_priv,
 	if (tvlv_value_len < sizeof(*tt_data))
 		return NET_RX_SUCCESS;
 
-	tt_data = (struct batadv_tvlv_tt_data *)tvlv_value;
+	tt_data = tvlv_value;
 	tvlv_value_len -= sizeof(*tt_data);
 
 	tt_vlan_len = sizeof(struct batadv_tvlv_tt_vlan_data);
@@ -4129,7 +4129,7 @@ static int batadv_roam_tvlv_unicast_handler_v1(struct batadv_priv *bat_priv,
 		goto out;
 
 	batadv_inc_counter(bat_priv, BATADV_CNT_TT_ROAM_ADV_RX);
-	roaming_adv = (struct batadv_tvlv_roam_adv *)tvlv_value;
+	roaming_adv = tvlv_value;
 
 	batadv_dbg(BATADV_DBG_TT, bat_priv,
 		   "Received ROAMING_ADV from %pM (client %pM)\n",
-- 
2.25.1

