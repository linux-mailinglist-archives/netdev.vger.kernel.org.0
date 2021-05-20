Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DC55389AC9
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 03:12:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230223AbhETBOK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 21:14:10 -0400
Received: from m12-14.163.com ([220.181.12.14]:34983 "EHLO m12-14.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230190AbhETBOJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 May 2021 21:14:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=Qy19LWiFKg7bMwsI8f
        6hYFJflRBkGjDtCi5WynYB9s4=; b=OyQZgY+Cpa38F9OE3FWL6Zqvux3x/A34+P
        jVpUjQ+31GlQHNbG76fEdcNT4MY983cq9C8ZNh9ZuOhhuWPZ9fNxWDABVDUx5msj
        a8HnL0an0XvzYql7M5ggswNzT4udrxh/nS6blUqWAdyWIsXSqymhxQDN//oItb12
        37QFsuCfE=
Received: from wengjianfeng.ccdomain.com (unknown [218.17.89.92])
        by smtp10 (Coremail) with SMTP id DsCowACnGzGKs6Vg2mmRJw--.1930S2;
        Thu, 20 May 2021 08:55:41 +0800 (CST)
From:   samirweng1979 <samirweng1979@163.com>
To:     tony0620emma@gmail.com, kvalo@codeaurora.org, davem@davemloft.net,
        kuba@kernel.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        wengjianfeng <wengjianfeng@yulong.com>
Subject: [PATCH] rtw88: coex: remove unnecessary variable and label
Date:   Thu, 20 May 2021 08:55:45 +0800
Message-Id: <20210520005545.31272-1-samirweng1979@163.com>
X-Mailer: git-send-email 2.15.0.windows.1
X-CM-TRANSID: DsCowACnGzGKs6Vg2mmRJw--.1930S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxAFWrCF48WF4Dtw18JFW5ZFb_yoW5tr1xpF
        Wa9a43JrZ8Jr4rXr48GFWFkFyY9w4xtayxA39Yy34fJw18Xr4kZF1DCa4Yyrn0grWrWr1a
        gF4Dt3y3ua17GFDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07bOxhLUUUUU=
X-Originating-IP: [218.17.89.92]
X-CM-SenderInfo: pvdpx25zhqwiqzxzqiywtou0bp/xtbBLA2YsV++Lz7CHgAAsk
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wengjianfeng <wengjianfeng@yulong.com>

In some funciton, the variable ret just used as return value,and
out label just return ret,so ret and out label are unnecessary,
we should delete these and use return true/false to replace.

Signed-off-by: wengjianfeng <wengjianfeng@yulong.com>
---
 drivers/net/wireless/realtek/rtw88/coex.c | 40 ++++++++-----------------------
 1 file changed, 10 insertions(+), 30 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/coex.c b/drivers/net/wireless/realtek/rtw88/coex.c
index cedbf38..103e877 100644
--- a/drivers/net/wireless/realtek/rtw88/coex.c
+++ b/drivers/net/wireless/realtek/rtw88/coex.c
@@ -630,20 +630,16 @@ static bool rtw_coex_get_bt_scan_type(struct rtw_dev *rtwdev, u8 *scan_type)
 	struct rtw_coex_info_req req = {0};
 	struct sk_buff *skb;
 	u8 *payload;
-	bool ret = false;
 
 	req.op_code = BT_MP_INFO_OP_SCAN_TYPE;
 	skb = rtw_coex_info_request(rtwdev, &req);
 	if (!skb)
-		goto out;
+		return false;
 
 	payload = get_payload_from_coex_resp(skb);
 	*scan_type = GET_COEX_RESP_BT_SCAN_TYPE(payload);
 	dev_kfree_skb_any(skb);
-	ret = true;
-
-out:
-	return ret;
+	return true;
 }
 
 static bool rtw_coex_set_lna_constrain_level(struct rtw_dev *rtwdev,
@@ -651,19 +647,15 @@ static bool rtw_coex_set_lna_constrain_level(struct rtw_dev *rtwdev,
 {
 	struct rtw_coex_info_req req = {0};
 	struct sk_buff *skb;
-	bool ret = false;
 
 	req.op_code = BT_MP_INFO_OP_LNA_CONSTRAINT;
 	req.para1 = lna_constrain_level;
 	skb = rtw_coex_info_request(rtwdev, &req);
 	if (!skb)
-		goto out;
+		return false;
 
 	dev_kfree_skb_any(skb);
-	ret = true;
-
-out:
-	return ret;
+	return true;
 }
 
 #define case_BTSTATUS(src) \
@@ -3533,19 +3525,15 @@ static bool rtw_coex_get_bt_patch_version(struct rtw_dev *rtwdev,
 	struct rtw_coex_info_req req = {0};
 	struct sk_buff *skb;
 	u8 *payload;
-	bool ret = false;
 
 	req.op_code = BT_MP_INFO_OP_PATCH_VER;
 	skb = rtw_coex_info_request(rtwdev, &req);
 	if (!skb)
-		goto out;
+		return false;
 
 	payload = get_payload_from_coex_resp(skb);
 	*patch_version = GET_COEX_RESP_BT_PATCH_VER(payload);
-	ret = true;
-
-out:
-	return ret;
+	return true;
 }
 
 static bool rtw_coex_get_bt_supported_version(struct rtw_dev *rtwdev,
@@ -3554,19 +3542,15 @@ static bool rtw_coex_get_bt_supported_version(struct rtw_dev *rtwdev,
 	struct rtw_coex_info_req req = {0};
 	struct sk_buff *skb;
 	u8 *payload;
-	bool ret = false;
 
 	req.op_code = BT_MP_INFO_OP_SUPP_VER;
 	skb = rtw_coex_info_request(rtwdev, &req);
 	if (!skb)
-		goto out;
+		return false;
 
 	payload = get_payload_from_coex_resp(skb);
 	*supported_version = GET_COEX_RESP_BT_SUPP_VER(payload);
-	ret = true;
-
-out:
-	return ret;
+	return true;
 }
 
 static bool rtw_coex_get_bt_supported_feature(struct rtw_dev *rtwdev,
@@ -3575,19 +3559,15 @@ static bool rtw_coex_get_bt_supported_feature(struct rtw_dev *rtwdev,
 	struct rtw_coex_info_req req = {0};
 	struct sk_buff *skb;
 	u8 *payload;
-	bool ret = false;
 
 	req.op_code = BT_MP_INFO_OP_SUPP_FEAT;
 	skb = rtw_coex_info_request(rtwdev, &req);
 	if (!skb)
-		goto out;
+		return false;
 
 	payload = get_payload_from_coex_resp(skb);
 	*supported_feature = GET_COEX_RESP_BT_SUPP_FEAT(payload);
-	ret = true;
-
-out:
-	return ret;
+	return true;
 }
 
 struct rtw_coex_sta_stat_iter_data {
-- 
1.9.1

