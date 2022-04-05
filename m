Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73AF34F5420
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 06:48:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237625AbiDFE0t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 00:26:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359677AbiDEUuK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 16:50:10 -0400
Received: from nbd.name (nbd.name [IPv6:2a01:4f8:221:3d45::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7246F3FAF;
        Tue,  5 Apr 2022 13:25:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=t5jZ5UOKbMDeuexSpI3bYXnypby/Oh1y2Y1e1cvnIqk=; b=cHgmUqRBsuUv80/YX5lqww1qed
        /XnGoeyHg2arZAFL/ceUKsorRfhtU/jYqmfv54qUBlreVkBiZFUKVMbpFUxzlg37VLLOZF5bKxxK2
        O0gk8JDyeM6fe25E/g3yHxFWJ7dgytKLSjW64ZpfEtHSLyi80y0wEoapr2NX466GQOYQ=;
Received: from p200300daa70ef200456864e8b8d10029.dip0.t-ipconnect.de ([2003:da:a70e:f200:4568:64e8:b8d1:29] helo=Maecks.lan)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1nbpJZ-00035V-UO; Tue, 05 Apr 2022 21:58:10 +0200
From:   Felix Fietkau <nbd@nbd.name>
To:     netdev@vger.kernel.org, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>
Cc:     linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 13/14] net: ethernet: mtk_eth_soc: remove bridge flow offload type entry support
Date:   Tue,  5 Apr 2022 21:57:54 +0200
Message-Id: <20220405195755.10817-14-nbd@nbd.name>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405195755.10817-1-nbd@nbd.name>
References: <20220405195755.10817-1-nbd@nbd.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

According to MediaTek, this feature is not supported in current hardware

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/ethernet/mediatek/mtk_ppe.c         | 8 --------
 drivers/net/ethernet/mediatek/mtk_ppe_debugfs.c | 1 -
 2 files changed, 9 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_ppe.c b/drivers/net/ethernet/mediatek/mtk_ppe.c
index a7fe33bbde63..aa0d190db65d 100644
--- a/drivers/net/ethernet/mediatek/mtk_ppe.c
+++ b/drivers/net/ethernet/mediatek/mtk_ppe.c
@@ -84,13 +84,6 @@ static u32 mtk_ppe_hash_entry(struct mtk_foe_entry *e)
 	u32 hash;
 
 	switch (FIELD_GET(MTK_FOE_IB1_PACKET_TYPE, e->ib1)) {
-		case MTK_PPE_PKT_TYPE_BRIDGE:
-			hv1 = e->bridge.src_mac_lo;
-			hv1 ^= ((e->bridge.src_mac_hi & 0xffff) << 16);
-			hv2 = e->bridge.src_mac_hi >> 16;
-			hv2 ^= e->bridge.dest_mac_lo;
-			hv3 = e->bridge.dest_mac_hi;
-			break;
 		case MTK_PPE_PKT_TYPE_IPV4_ROUTE:
 		case MTK_PPE_PKT_TYPE_IPV4_HNAPT:
 			hv1 = e->ipv4.orig.ports;
@@ -572,7 +565,6 @@ int mtk_ppe_start(struct mtk_ppe *ppe)
 	      MTK_PPE_FLOW_CFG_IP4_NAT |
 	      MTK_PPE_FLOW_CFG_IP4_NAPT |
 	      MTK_PPE_FLOW_CFG_IP4_DSLITE |
-	      MTK_PPE_FLOW_CFG_L2_BRIDGE |
 	      MTK_PPE_FLOW_CFG_IP4_NAT_FRAG;
 	ppe_w32(ppe, MTK_PPE_FLOW_CFG, val);
 
diff --git a/drivers/net/ethernet/mediatek/mtk_ppe_debugfs.c b/drivers/net/ethernet/mediatek/mtk_ppe_debugfs.c
index d4b482340cb9..eb0b598f14e4 100644
--- a/drivers/net/ethernet/mediatek/mtk_ppe_debugfs.c
+++ b/drivers/net/ethernet/mediatek/mtk_ppe_debugfs.c
@@ -32,7 +32,6 @@ static const char *mtk_foe_pkt_type_str(int type)
 	static const char * const type_str[] = {
 		[MTK_PPE_PKT_TYPE_IPV4_HNAPT] = "IPv4 5T",
 		[MTK_PPE_PKT_TYPE_IPV4_ROUTE] = "IPv4 3T",
-		[MTK_PPE_PKT_TYPE_BRIDGE] = "L2",
 		[MTK_PPE_PKT_TYPE_IPV4_DSLITE] = "DS-LITE",
 		[MTK_PPE_PKT_TYPE_IPV6_ROUTE_3T] = "IPv6 3T",
 		[MTK_PPE_PKT_TYPE_IPV6_ROUTE_5T] = "IPv6 5T",
-- 
2.35.1

