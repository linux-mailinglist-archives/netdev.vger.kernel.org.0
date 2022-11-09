Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED2646230E6
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 18:01:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229678AbiKIRBH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 12:01:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231343AbiKIRAm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 12:00:42 -0500
Received: from nbd.name (nbd.name [46.4.11.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D658DF35;
        Wed,  9 Nov 2022 08:57:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
        s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=810KJYvQua3Tgj0eTQnOjCyIwfPHWRslPBRk0KhS8r0=; b=NfgRes3FlgLZOAi5KPhr9WSYdb
        rrBOtRbDLSQNvOvLOh6GDIC6Y8+5WVCLr8KEzM46i2phVihE73iMK3m3knPfug2NL4xmYMdgRQjGY
        KslSg1b2y1q1dfWQMjh40HhMGbWbK3pRT4Da2eR4NAaPIDW4Yu/BGunFKikhGOOJHcGg=;
Received: from p200300daa72ee100054f3c61b16ef6e7.dip0.t-ipconnect.de ([2003:da:a72e:e100:54f:3c61:b16e:f6e7] helo=localhost.localdomain)
        by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305_SHA256
        (Exim 4.94.2)
        (envelope-from <nbd@nbd.name>)
        id 1oso2B-000l4N-M4; Wed, 09 Nov 2022 17:34:39 +0100
From:   Felix Fietkau <nbd@nbd.name>
To:     netdev@vger.kernel.org, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 11/12] net: ethernet: mtk_eth_soc: set NETIF_F_ALL_TSO
Date:   Wed,  9 Nov 2022 17:34:25 +0100
Message-Id: <20221109163426.76164-12-nbd@nbd.name>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221109163426.76164-1-nbd@nbd.name>
References: <20221109163426.76164-1-nbd@nbd.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Significantly improves performance by avoiding unnecessary segmentation

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.h b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
index 1c85fbad5bc1..60da6936559a 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.h
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
@@ -49,8 +49,7 @@
 				 NETIF_F_RXCSUM | \
 				 NETIF_F_HW_VLAN_CTAG_TX | \
 				 NETIF_F_HW_VLAN_CTAG_RX | \
-				 NETIF_F_SG | NETIF_F_TSO | \
-				 NETIF_F_TSO6 | \
+				 NETIF_F_SG | NETIF_F_ALL_TSO | \
 				 NETIF_F_IPV6_CSUM |\
 				 NETIF_F_HW_TC)
 #define MTK_HW_FEATURES_MT7628	(NETIF_F_SG | NETIF_F_RXCSUM)
-- 
2.38.1

