Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A86A50DEE9
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 13:36:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234899AbiDYLjs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 07:39:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229870AbiDYLjq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 07:39:46 -0400
Received: from mail.nfschina.com (unknown [IPv6:2400:dd01:100f:2:72e2:84ff:fe10:5f45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2FE1E1B0;
        Mon, 25 Apr 2022 04:36:40 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mail.nfschina.com (Postfix) with ESMTP id 047D91E80D56;
        Mon, 25 Apr 2022 19:33:34 +0800 (CST)
X-Virus-Scanned: amavisd-new at test.com
Received: from mail.nfschina.com ([127.0.0.1])
        by localhost (mail.nfschina.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id fHsaOolkcdnu; Mon, 25 Apr 2022 19:33:31 +0800 (CST)
Received: from ubuntu.localdomain (unknown [101.228.255.56])
        (Authenticated sender: yuzhe@nfschina.com)
        by mail.nfschina.com (Postfix) with ESMTPA id C9AB71E80C99;
        Mon, 25 Apr 2022 19:33:30 +0800 (CST)
From:   Yu Zhe <yuzhe@nfschina.com>
To:     mareklindner@neomailbox.ch, sw@simonwunderlich.de, a@unstable.cc,
        sven@narfation.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com
Cc:     b.a.t.m.a.n@lists.open-mesh.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, liqiong@nfschina.com,
        kernel-janitors@vger.kernel.org, Yu Zhe <yuzhe@nfschina.com>
Subject: [PATCH] batman-adv: remove unnecessary type castings
Date:   Mon, 25 Apr 2022 04:36:35 -0700
Message-Id: <20220425113635.1609532-1-yuzhe@nfschina.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220421154829.9775-1-yuzhe@nfschina.com>
References: <20220421154829.9775-1-yuzhe@nfschina.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,RDNS_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

remove unnecessary void* type castings.

Signed-off-by: Yu Zhe <yuzhe@nfschina.com>
---
 net/batman-adv/translation-table.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/batman-adv/translation-table.c b/net/batman-adv/translation-table.c
index 8478034d3abf..cbf96eebf05b 100644
--- a/net/batman-adv/translation-table.c
+++ b/net/batman-adv/translation-table.c
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

