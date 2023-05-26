Return-Path: <netdev+bounces-5576-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C76C7122E7
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 11:03:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4755E1C20FE4
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 09:03:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3DE110783;
	Fri, 26 May 2023 09:03:05 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9F2210948
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 09:03:05 +0000 (UTC)
Received: from smtpbgau1.qq.com (smtpbgau1.qq.com [54.206.16.166])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F4061119
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 02:03:03 -0700 (PDT)
X-QQ-mid: bizesmtp89t1685091777t5lbx765
Received: from localhost.localdomain ( [125.120.148.168])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Fri, 26 May 2023 17:02:56 +0800 (CST)
X-QQ-SSF: 01400000000000N0Z000000A0000000
X-QQ-FEAT: Xz3VOcA7Mr2+6qHwlGHRssJ9kJYyIQbHO30aqrqt8pII1Mja45Q8ioaxXIGrP
	OFrbkD9b3MgenRcnEwLk9M9Q6U0eKVMNi3TmfY3CUFI9NXj1wVcAfajWvrm8WahkjMW3Rmn
	JyUcTzSFHIg/d2XFSrqJpzJ3Y8Ki9EDIg1KlEvVeREOaPNPQtAZ3tx4lkYsebqZExTtNBo/
	NSqi+mPSTGOGfj45d7lHz7FYLxUaRDZSskKZpahu6qoYifgOPYokyRjyFP2QxQKdAdonkC0
	8P2qVyE5YlXqRGNm3+FjRS7hbGaZMlenf0NLbkSx4FX4MD7gOcC9Q1vBmLR+wR9orLEvhEF
	Y9Fky69vAn9HYVwiPigO3mjbgsZE73ZmNzTGDc4pYMcO+9PkYgRlubUfCH/htNFk+YPXZlp
	A8KohWqTWXesX10bpFNRpw==
X-QQ-GoodBg: 2
X-BIZMAIL-ID: 4897826992394885209
From: Mengyuan Lou <mengyuanlou@net-swift.com>
To: netdev@vger.kernel.org
Cc: jiawenwu@trustnetic.com,
	Mengyuan Lou <mengyuanlou@net-swift.com>
Subject: [PATCH net-next v7 4/8] net: libwx: Implement xx_set_features ops
Date: Fri, 26 May 2023 17:02:26 +0800
Message-Id: <20230526090230.71487-5-mengyuanlou@net-swift.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230526090230.71487-1-mengyuanlou@net-swift.com>
References: <20230526090230.71487-1-mengyuanlou@net-swift.com>
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


