Return-Path: <netdev+bounces-4510-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 64BA370D234
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 05:08:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 31E2F1C20C53
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 03:08:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE80879E3;
	Tue, 23 May 2023 03:07:38 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4A1EA930
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 03:07:38 +0000 (UTC)
Received: from smtpbgeu1.qq.com (smtpbgeu1.qq.com [52.59.177.22])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BE618F
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 20:07:35 -0700 (PDT)
X-QQ-mid: bizesmtp73t1684811249txchai6m
Received: from localhost.localdomain ( [122.235.247.1])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Tue, 23 May 2023 11:07:28 +0800 (CST)
X-QQ-SSF: 01400000000000N0Z000000A0000000
X-QQ-FEAT: aBJFcW+uBGax9seF68EWQQifctQVTtZfSNK6H8DoOfh61owuUDC0XA3ZH8Ph3
	GPtX2AaMC1AVPgsdFcjAB/ttrE7FMNrVYILf1epoAhw8TKAZ5qCpX37oTA4XJRhtWYQsOtK
	BKxDv7DgUMefwe0HVP8UzFT416v09KksIhQlT9FxexXXppNc3Lm1A7KC6powatk31AereOz
	bb8GJLckpRR5h/HpRKDyVbG8KJD0Axwy8u/pBKjQDept8F3OhPXTJkGLLhN7ME0SBg0gBmR
	b8pG+0t1KVKJJZEYmIoMXH2luI8uP1MuZT0LGz9j11kaHHxRfgpPtHsSWvoa7xupgo5rh8B
	7bzzA4NyIm4RKOV7wnQIkzorzooNoAX1O8OZhQPz7vz+H6X2vhcpQEYYkctzi2cDQIwjY1x
	zq/fSc5hiek=
X-QQ-GoodBg: 2
X-BIZMAIL-ID: 11648049311883441971
From: Mengyuan Lou <mengyuanlou@net-swift.com>
To: netdev@vger.kernel.org
Cc: jiawenwu@trustnetic.com,
	Mengyuan Lou <mengyuanlou@net-swift.com>
Subject: [PATCH net-next v6 5/8] net: ngbe: Add netdev features support
Date: Tue, 23 May 2023 11:06:55 +0800
Message-Id: <20230523030658.17738-6-mengyuanlou@net-swift.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230523030658.17738-1-mengyuanlou@net-swift.com>
References: <20230523030658.17738-1-mengyuanlou@net-swift.com>
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
	RCVD_IN_MSPIKE_H2,SPF_PASS,T_SCC_BODY_TEXT_LINE,T_SPF_HELO_TEMPERROR
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


