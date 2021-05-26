Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBC96390DDE
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 03:16:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232871AbhEZBSR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 21:18:17 -0400
Received: from m12-15.163.com ([220.181.12.15]:44120 "EHLO m12-15.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232861AbhEZBSR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 May 2021 21:18:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=L7XiY+7mgOog8s8SKi
        t6bVTDt1jsAuMP1tb0o80uVDE=; b=OhtinFcLZR8G6Rlfy1vEB7o5wqXLrHHrxR
        p6I3GVFFBy5umTSo23RTfi+4sS5/WUy4MCbH2O6oYvlqtYWRY5JpsoMd5zVT2Knx
        07I0DJ4UxYsTPH0e3v7Bi+xcysLiVTNZTLXkubEyv1lNgfXHGPjwJUJ/+XPoxUfQ
        20gLSC9dc=
Received: from wengjianfeng.ccdomain.com (unknown [218.17.89.92])
        by smtp11 (Coremail) with SMTP id D8CowAAXHhJvoa1gMCxICQ--.49S2;
        Wed, 26 May 2021 09:16:37 +0800 (CST)
From:   samirweng1979 <samirweng1979@163.com>
To:     krzysztof.kozlowski@canonical.com, davem@davemloft.net
Cc:     linux-nfc@lists.01.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        wengjianfeng <wengjianfeng@yulong.com>
Subject: [PATCH v2] nfc: st-nci: remove unnecessary labels
Date:   Wed, 26 May 2021 09:16:24 +0800
Message-Id: <20210526011624.11204-1-samirweng1979@163.com>
X-Mailer: git-send-email 2.15.0.windows.1
X-CM-TRANSID: D8CowAAXHhJvoa1gMCxICQ--.49S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxWF43Cw1UWr1xtF43Xw13urg_yoW5WFy3pa
        yYgFW8CF48KFyxXa4UJan7ZF1fCw4xKrZ3GF97u34Ivr4YyrnFqF4kAF10vF4ayFZ5G3W7
        ta1jyF47Wan3JF7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jBQ6dUUUUU=
X-Originating-IP: [218.17.89.92]
X-CM-SenderInfo: pvdpx25zhqwiqzxzqiywtou0bp/1tbiLxWesVUMYsAasQAAsF
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wengjianfeng <wengjianfeng@yulong.com>

Some labels are only used once, so we delete them and use the
return statement instead of the goto statement.

Signed-off-by: wengjianfeng <wengjianfeng@yulong.com>
---
 drivers/nfc/st-nci/vendor_cmds.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/nfc/st-nci/vendor_cmds.c b/drivers/nfc/st-nci/vendor_cmds.c
index c6a9d30..94b6000 100644
--- a/drivers/nfc/st-nci/vendor_cmds.c
+++ b/drivers/nfc/st-nci/vendor_cmds.c
@@ -98,7 +98,7 @@ static int st_nci_hci_dm_get_info(struct nfc_dev *dev, void *data,
 	r = nci_hci_send_cmd(ndev, ST_NCI_DEVICE_MGNT_GATE, ST_NCI_HCI_DM_GETINFO,
 			     data, data_len, &skb);
 	if (r)
-		goto exit;
+		return r;
 
 	msg = nfc_vendor_cmd_alloc_reply_skb(dev, ST_NCI_VENDOR_OUI,
 					     HCI_DM_GET_INFO, skb->len);
@@ -117,7 +117,6 @@ static int st_nci_hci_dm_get_info(struct nfc_dev *dev, void *data,
 
 free_skb:
 	kfree_skb(skb);
-exit:
 	return r;
 }
 
@@ -131,7 +130,7 @@ static int st_nci_hci_dm_get_data(struct nfc_dev *dev, void *data,
 	r = nci_hci_send_cmd(ndev, ST_NCI_DEVICE_MGNT_GATE, ST_NCI_HCI_DM_GETDATA,
 			     data, data_len, &skb);
 	if (r)
-		goto exit;
+		return r;
 
 	msg = nfc_vendor_cmd_alloc_reply_skb(dev, ST_NCI_VENDOR_OUI,
 					     HCI_DM_GET_DATA, skb->len);
@@ -150,7 +149,6 @@ static int st_nci_hci_dm_get_data(struct nfc_dev *dev, void *data,
 
 free_skb:
 	kfree_skb(skb);
-exit:
 	return r;
 }
 
@@ -216,7 +214,7 @@ static int st_nci_hci_get_param(struct nfc_dev *dev, void *data,
 
 	r = nci_hci_get_param(ndev, param->gate, param->data, &skb);
 	if (r)
-		goto exit;
+		return r;
 
 	msg = nfc_vendor_cmd_alloc_reply_skb(dev, ST_NCI_VENDOR_OUI,
 					     HCI_GET_PARAM, skb->len);
@@ -235,7 +233,6 @@ static int st_nci_hci_get_param(struct nfc_dev *dev, void *data,
 
 free_skb:
 	kfree_skb(skb);
-exit:
 	return r;
 }
 
@@ -262,7 +259,7 @@ static int st_nci_hci_dm_vdc_measurement_value(struct nfc_dev *dev, void *data,
 			     ST_NCI_HCI_DM_VDC_MEASUREMENT_VALUE,
 			     data, data_len, &skb);
 	if (r)
-		goto exit;
+		return r;
 
 	msg = nfc_vendor_cmd_alloc_reply_skb(dev, ST_NCI_VENDOR_OUI,
 				HCI_DM_VDC_MEASUREMENT_VALUE, skb->len);
@@ -281,7 +278,6 @@ static int st_nci_hci_dm_vdc_measurement_value(struct nfc_dev *dev, void *data,
 
 free_skb:
 	kfree_skb(skb);
-exit:
 	return r;
 }
 
@@ -299,7 +295,7 @@ static int st_nci_hci_dm_vdc_value_comparison(struct nfc_dev *dev, void *data,
 			     ST_NCI_HCI_DM_VDC_VALUE_COMPARISON,
 			     data, data_len, &skb);
 	if (r)
-		goto exit;
+		return r;
 
 	msg = nfc_vendor_cmd_alloc_reply_skb(dev, ST_NCI_VENDOR_OUI,
 					HCI_DM_VDC_VALUE_COMPARISON, skb->len);
@@ -318,7 +314,6 @@ static int st_nci_hci_dm_vdc_value_comparison(struct nfc_dev *dev, void *data,
 
 free_skb:
 	kfree_skb(skb);
-exit:
 	return r;
 }
 
-- 
1.9.1

