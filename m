Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6884438F891
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 05:13:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230175AbhEYDOt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 23:14:49 -0400
Received: from m12-16.163.com ([220.181.12.16]:42644 "EHLO m12-16.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229837AbhEYDOs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 May 2021 23:14:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=O4aWaenFwErQ5NgDAP
        P33jwWpuJnsnsLDR5iqBxt9s4=; b=Hn1Pkl1zZ+qNEf3B8V7CPbULllVRhjguqK
        78LUee5tBX3Af3TQt8RaFHC/GVgf0gCswIKg5Q2Ns+MyZGZhjd2jabMJVHgJ+GOg
        p4nAGptH3m5D1CmgIyYiAgfNS6EnoyeEjU6nrTEccOMtDAD76ywLiq8AnjP4+kBi
        NNmCKobTc=
Received: from wengjianfeng.ccdomain.com (unknown [218.17.89.92])
        by smtp12 (Coremail) with SMTP id EMCowACXnRk5a6xgb+iitA--.6330S2;
        Tue, 25 May 2021 11:12:58 +0800 (CST)
From:   samirweng1979 <samirweng1979@163.com>
To:     krzysztof.kozlowski@canonical.com, davem@davemloft.net
Cc:     linux-nfc@lists.01.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        wengjianfeng <wengjianfeng@yulong.com>
Subject: [PATCH] nfc: st-nci: remove unnecessary labels
Date:   Tue, 25 May 2021 11:12:54 +0800
Message-Id: <20210525031254.12196-1-samirweng1979@163.com>
X-Mailer: git-send-email 2.15.0.windows.1
X-CM-TRANSID: EMCowACXnRk5a6xgb+iitA--.6330S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxJFW5CFWxWF1UJw43Xr4xJFb_yoW5Aryrpa
        yYgFW8CF18KFyxXa4UJan7ZF1fC3yxKFZ3GF97u34Ivr4YyrnFvF4kAF10vF4ayFWkG3W7
        ta1jyF42gan3JF7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jma09UUUUU=
X-Originating-IP: [218.17.89.92]
X-CM-SenderInfo: pvdpx25zhqwiqzxzqiywtou0bp/1tbiHRqdsVSIq3yNjQAAsg
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wengjianfeng <wengjianfeng@yulong.com>

In some functions, use goto exit statement, which just return r.
and exit label only used once in each funciton, so we use return
to replace goto statement and remove exit label.

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


