Return-Path: <netdev+bounces-6215-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 890667153A7
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 04:28:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 43BDB281005
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 02:28:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55D87613C;
	Tue, 30 May 2023 02:27:32 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B1F64A0E
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 02:27:32 +0000 (UTC)
Received: from smtpbguseast1.qq.com (smtpbguseast1.qq.com [54.204.34.129])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDC1FC7
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 19:27:29 -0700 (PDT)
X-QQ-mid: bizesmtp68t1685413642tu5nv6oa
Received: from localhost.localdomain ( [183.159.96.128])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Tue, 30 May 2023 10:27:21 +0800 (CST)
X-QQ-SSF: 01400000000000N0Z000000A0000000
X-QQ-FEAT: uGhnJwy6xZKC3bbBix6DHorSPgRQMpybVXAb2iJuoEBXqmVh9Mrj7LYCkLeo5
	5G+Gvcs/GM0shqA6pUpsAiljREYNaHO6DLaCX53ETof0mAZAsVAz3FArSB5g1nNFI04w3wc
	QBt5PDh0fxALWaDn4iqi9F+plULeF8Y0f2EZJnnq76bxjwX1k8/RyWHGErio9EUsAetToI5
	m59oCv7IVbbqXToldsLfnEzIj/LsQwBuKB/tBoUiz57LtY243KPvP0dKOU+FlQv4Vh2D4Ub
	X+L1+GdsA+OWFF2lCS3AFNY/u38Bi6Au8Ivenp3yiRhQ8WwTgb51ZynvYw6xFBqt2dd9h17
	3dbH+ILl/RFZodmO2fZmJ2im3CZFoR18eeDbQ1Y1XMzK0LZYSlkSsMddaoGOOSE0sSpHpjL
	DtrXjEm7SHs=
X-QQ-GoodBg: 2
X-BIZMAIL-ID: 5461040450620393910
From: Mengyuan Lou <mengyuanlou@net-swift.com>
To: netdev@vger.kernel.org
Cc: jiawenwu@trustnetic.com,
	Mengyuan Lou <mengyuanlou@net-swift.com>
Subject: [RESEND,PATCH net-next v7 4/8] net: libwx: Implement xx_set_features ops
Date: Tue, 30 May 2023 10:26:28 +0800
Message-Id: <20230530022632.17938-5-mengyuanlou@net-swift.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230530022632.17938-1-mengyuanlou@net-swift.com>
References: <20230530022632.17938-1-mengyuanlou@net-swift.com>
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
	RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Implement wx_set_features function which to support
ndo_set_features.

Signed-off-by: Mengyuan Lou <mengyuanlou@net-swift.com>
---
 drivers/net/ethernet/wangxun/libwx/wx_lib.c  | 20 ++++++++++++++++++++
 drivers/net/ethernet/wangxun/libwx/wx_lib.h  |  1 +
 drivers/net/ethernet/wangxun/libwx/wx_type.h |  2 ++
 3 files changed, 23 insertions(+)

diff --git a/drivers/net/ethernet/wangxun/libwx/wx_lib.c b/drivers/net/ethernet/wangxun/libwx/wx_lib.c
index 680f1ad36240..3dd328d33fcc 100644
--- a/drivers/net/ethernet/wangxun/libwx/wx_lib.c
+++ b/drivers/net/ethernet/wangxun/libwx/wx_lib.c
@@ -2704,4 +2704,24 @@ void wx_get_stats64(struct net_device *netdev,
 }
 EXPORT_SYMBOL(wx_get_stats64);
 
+int wx_set_features(struct net_device *netdev, netdev_features_t features)
+{
+	netdev_features_t changed = netdev->features ^ features;
+	struct wx *wx = netdev_priv(netdev);
+
+	if (changed & NETIF_F_RXHASH)
+		wr32m(wx, WX_RDB_RA_CTL, WX_RDB_RA_CTL_RSS_EN,
+		      WX_RDB_RA_CTL_RSS_EN);
+	else
+		wr32m(wx, WX_RDB_RA_CTL, WX_RDB_RA_CTL_RSS_EN, 0);
+
+	if (changed &
+	    (NETIF_F_HW_VLAN_CTAG_RX |
+	     NETIF_F_HW_VLAN_STAG_RX))
+		wx_set_rx_mode(netdev);
+
+	return 1;
+}
+EXPORT_SYMBOL(wx_set_features);
+
 MODULE_LICENSE("GPL");
diff --git a/drivers/net/ethernet/wangxun/libwx/wx_lib.h b/drivers/net/ethernet/wangxun/libwx/wx_lib.h
index 50ee41f1fa10..df1f4a5951f0 100644
--- a/drivers/net/ethernet/wangxun/libwx/wx_lib.h
+++ b/drivers/net/ethernet/wangxun/libwx/wx_lib.h
@@ -28,5 +28,6 @@ void wx_free_resources(struct wx *wx);
 int wx_setup_resources(struct wx *wx);
 void wx_get_stats64(struct net_device *netdev,
 		    struct rtnl_link_stats64 *stats);
+int wx_set_features(struct net_device *netdev, netdev_features_t features);
 
 #endif /* _NGBE_LIB_H_ */
diff --git a/drivers/net/ethernet/wangxun/libwx/wx_type.h b/drivers/net/ethernet/wangxun/libwx/wx_type.h
index a7ff6c6749d0..a52cc5ac1db6 100644
--- a/drivers/net/ethernet/wangxun/libwx/wx_type.h
+++ b/drivers/net/ethernet/wangxun/libwx/wx_type.h
@@ -111,6 +111,8 @@
 #define WX_RDB_PL_CFG_L2HDR          BIT(3)
 #define WX_RDB_PL_CFG_TUN_TUNHDR     BIT(4)
 #define WX_RDB_PL_CFG_TUN_OUTL2HDR   BIT(5)
+#define WX_RDB_RA_CTL                0x194F4
+#define WX_RDB_RA_CTL_RSS_EN         BIT(2) /* RSS Enable */
 
 /******************************* PSR Registers *******************************/
 /* psr control */
-- 
2.40.1


