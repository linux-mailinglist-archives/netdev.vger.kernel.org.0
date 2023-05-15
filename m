Return-Path: <netdev+bounces-2639-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 93801702C5E
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 14:11:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9458C1C20B41
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 12:11:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3F00C8DE;
	Mon, 15 May 2023 12:10:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D96C9C8DD
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 12:10:22 +0000 (UTC)
X-Greylist: delayed 66 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 15 May 2023 05:10:20 PDT
Received: from smtpbgbr1.qq.com (smtpbgbr1.qq.com [54.207.19.206])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 095BEB8
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 05:10:19 -0700 (PDT)
X-QQ-mid: bizesmtp77t1684152545t9q5wfpr
Received: from localhost.localdomain ( [115.200.228.151])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Mon, 15 May 2023 20:09:03 +0800 (CST)
X-QQ-SSF: 01400000000000N0Z000000A0000000
X-QQ-FEAT: aBJFcW+uBGaXIRS0iGCFKc8PdGLL7nADYpbo4VVDwji7fiudC+ioOYrDwyR8i
	1IYKfvXCmSskGUIizcUUV+dkyL2e6vNNx0QyiqtrLpScLFz/S3JB9801xVDgJsXrWUFXMPO
	ck5+bdhiaC6GHb78dOIHuRrzrjTGAaAnw1F3r7s6TeHOyXieZjDnEW5vBWduT85l8liVmzX
	P0BwE+OEg1uF5cGG5JJJo8jH+Wv3EhPZQfhmarlUyXFY9Dg/UE15qvbAgw3PntMwAn45ShK
	lbqIGBIfEREEKUkWMyQqJJ4ycDCOZG9l03RFSV+RR61obKReVX47odT0cyYaLuUwURP2Zvv
	UOIZxl1Evill8SiBfGtskdrymJeq/w8NnNWsKRkcREeLrOWOxfH6PrWOcr5Y+1fhBet5rB8
	ZoLEZKvUFgo=
X-QQ-GoodBg: 2
X-BIZMAIL-ID: 12725189698868552876
From: Mengyuan Lou <mengyuanlou@net-swift.com>
To: netdev@vger.kernel.org
Cc: jiawenwu@trustnetic.com,
	Mengyuan Lou <mengyuanlou@net-swift.com>
Subject: [PATCH net-next v5 4/8] net: libwx: Implement xx_set_features ops
Date: Mon, 15 May 2023 20:08:25 +0800
Message-Id: <20230515120829.74861-5-mengyuanlou@net-swift.com>
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
	SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Implement wx_set_features fuction which to support
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
index 842e2b3685ef..7f91c3b04291 100644
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


