Return-Path: <netdev+bounces-2634-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 588DD702C56
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 14:10:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4B5E81C20B82
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 12:10:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDBEDC8C7;
	Mon, 15 May 2023 12:09:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B291AC8C1
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 12:09:15 +0000 (UTC)
Received: from smtpbgsg1.qq.com (smtpbgsg1.qq.com [54.254.200.92])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF017FB
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 05:09:13 -0700 (PDT)
X-QQ-mid: bizesmtp77t1684152549tbo513fr
Received: from localhost.localdomain ( [115.200.228.151])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Mon, 15 May 2023 20:09:07 +0800 (CST)
X-QQ-SSF: 01400000000000N0Z000000A0000000
X-QQ-FEAT: CR3LFp2JE4k+wYJebE7d4JBzxrsNlkOw/oGtjWYqAILx3z88uWlqI5uAO/lkp
	EmkXfTorOOqwNsC+7ELsBGmeldVlO9wu14Ulm6QXVU0SDxhx/cOrrF3p72Dn2pCuwi6u2aK
	jTSYbGSv0jxpJh72gFR/c82SXWO5mzA9l2GpsmlrAsGW2auOdGtdniZiyIn28zv43ks6WDM
	rVcsfbpsfrQIC8Ib1FrxEWlxfC6doRn9OzAvU6NbbS/X3wjS9/E1x09NVMLEc3RkWXDMqrt
	bCdDhyk2/Sc9O6wV0Wjxgz8siHRwphu0z+GDwx8yNbE+kh+wzzs1tJe4UKTkHxp30tb/mY5
	4720u6QcrLdgQHvcMq35cocqOcYcZUdTgr7Rngrrdlr4nXZVue4+U4lzVsp/h/pVcis9JWZ
	xdAYnCkCZzM=
X-QQ-GoodBg: 2
X-BIZMAIL-ID: 13280815105367142780
From: Mengyuan Lou <mengyuanlou@net-swift.com>
To: netdev@vger.kernel.org
Cc: jiawenwu@trustnetic.com,
	Mengyuan Lou <mengyuanlou@net-swift.com>
Subject: [PATCH net-next v5 5/8] net: ngbe: Add netdev features support
Date: Mon, 15 May 2023 20:08:26 +0800
Message-Id: <20230515120829.74861-6-mengyuanlou@net-swift.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515120829.74861-1-mengyuanlou@net-swift.com>
References: <20230515120829.74861-1-mengyuanlou@net-swift.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:net-swift.com:qybglogicsvrgz:qybglogicsvrgz5a-3
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Add features and hw_features that ngbe can support.

Signed-off-by: Mengyuan Lou <mengyuanlou@net-swift.com>
---
 drivers/net/ethernet/wangxun/ngbe/ngbe_main.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c b/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c
index df6b870aa871..f234c9c4b942 100644
--- a/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c
+++ b/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c
@@ -473,6 +473,7 @@ static const struct net_device_ops ngbe_netdev_ops = {
 	.ndo_change_mtu         = wx_change_mtu,
 	.ndo_start_xmit         = wx_xmit_frame,
 	.ndo_set_rx_mode        = wx_set_rx_mode,
+	.ndo_set_features       = wx_set_features,
 	.ndo_validate_addr      = eth_validate_addr,
 	.ndo_set_mac_address    = wx_set_mac,
 	.ndo_get_stats64        = wx_get_stats64,
@@ -551,12 +552,18 @@ static int ngbe_probe(struct pci_dev *pdev,
 	ngbe_set_ethtool_ops(netdev);
 	netdev->netdev_ops = &ngbe_netdev_ops;
 
-	netdev->features |= NETIF_F_HIGHDMA;
-	netdev->features = NETIF_F_SG;
-
+	netdev->features = NETIF_F_SG | NETIF_F_IP_CSUM |
+			   NETIF_F_TSO | NETIF_F_TSO6 |
+			   NETIF_F_RXHASH | NETIF_F_RXCSUM;
+	netdev->features |= NETIF_F_SCTP_CRC | NETIF_F_TSO_MANGLEID;
+	netdev->vlan_features |= netdev->features;
+	netdev->features |= NETIF_F_IPV6_CSUM | NETIF_F_VLAN_FEATURES;
 	/* copy netdev features into list of user selectable features */
-	netdev->hw_features |= netdev->features |
-			       NETIF_F_RXALL;
+	netdev->hw_features |= netdev->features | NETIF_F_RXALL;
+	netdev->hw_features |= NETIF_F_NTUPLE | NETIF_F_HW_TC;
+	netdev->features |= NETIF_F_HIGHDMA;
+	netdev->hw_features |= NETIF_F_GRO;
+	netdev->features |= NETIF_F_GRO;
 
 	netdev->priv_flags |= IFF_UNICAST_FLT;
 	netdev->priv_flags |= IFF_SUPP_NOFCS;
-- 
2.40.1


