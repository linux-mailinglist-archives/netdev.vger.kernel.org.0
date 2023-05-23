Return-Path: <netdev+bounces-4511-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6274D70D236
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 05:09:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 32D781C20C94
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 03:09:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 519D6A930;
	Tue, 23 May 2023 03:07:39 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46E4ABA20
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 03:07:39 +0000 (UTC)
Received: from smtpbgeu2.qq.com (smtpbgeu2.qq.com [18.194.254.142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59C6894
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 20:07:31 -0700 (PDT)
X-QQ-mid: bizesmtp73t1684811245t4uo78q2
Received: from localhost.localdomain ( [122.235.247.1])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Tue, 23 May 2023 11:07:24 +0800 (CST)
X-QQ-SSF: 01400000000000N0Z000000A0000000
X-QQ-FEAT: Xz3VOcA7Mr2+6qHwlGHRsiZa3yjETckbLOj/6VbVmQDdV/P+eofY86PgqEWRz
	udpPKj2xHrBodXRa9I3tuC8C5loCzKf57PJjLEOvAmpd+6KmqeGm9qZgZfVwjYvLkEAfIcl
	UYzldyP6KYW0rdnx3USsyhODMmAbD1YH58hvoGuzOfxqUaMaG2LZ2xjRwWZoQXKqhvH1u16
	M+i8nH4DNsgqHU5lDwn+jLAmQzZPeAlM3IbiJEyHIUqabhlbgoiI45pyELSFGxxTU+36NuJ
	jgGFpuNsII7o5PAkySpa5oEUNOrkVL/kOSiRnv4AnkhoLhy0CRXbWhdE5Cbee4NOUzn6H1K
	rhUuvwOab5MW1vyrv4PSHHWC88l8wyLQNXU5NUR/Y+i3bZbkQPX2NzFkaWRJAsP3ohEo7Ee
	hvZIz5+FNdg=
X-QQ-GoodBg: 2
X-BIZMAIL-ID: 2085660521681462880
From: Mengyuan Lou <mengyuanlou@net-swift.com>
To: netdev@vger.kernel.org
Cc: jiawenwu@trustnetic.com,
	Mengyuan Lou <mengyuanlou@net-swift.com>
Subject: [PATCH net-next v6 4/8] net: libwx: Implement xx_set_features ops
Date: Tue, 23 May 2023 11:06:54 +0800
Message-Id: <20230523030658.17738-5-mengyuanlou@net-swift.com>
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

Implement wx_set_features function which to support
ndo_set_features.

Signed-off-by: Mengyuan Lou <mengyuanlou@net-swift.com>
---
 drivers/net/ethernet/wangxun/libwx/wx_lib.c  | 20 ++++++++++++++++++++
 drivers/net/ethernet/wangxun/libwx/wx_lib.h  |  1 +
 drivers/net/ethernet/wangxun/libwx/wx_type.h |  2 ++
 3 files changed, 23 insertions(+)

diff --git a/drivers/net/ethernet/wangxun/libwx/wx_lib.c b/drivers/net/ethernet/wangxun/libwx/wx_lib.c
index 3be2b64b7ec8..c07c4496112a 100644
--- a/drivers/net/ethernet/wangxun/libwx/wx_lib.c
+++ b/drivers/net/ethernet/wangxun/libwx/wx_lib.c
@@ -2727,4 +2727,24 @@ void wx_get_stats64(struct net_device *netdev,
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


