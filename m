Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 248F639449E
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 16:56:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236687AbhE1O6J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 10:58:09 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:47158 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236439AbhE1O6B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 May 2021 10:58:01 -0400
Received: from mail-ua1-f72.google.com ([209.85.222.72])
        by youngberry.canonical.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <krzysztof.kozlowski@canonical.com>)
        id 1lmduS-0004BX-Pz
        for netdev@vger.kernel.org; Fri, 28 May 2021 14:56:24 +0000
Received: by mail-ua1-f72.google.com with SMTP id k17-20020ab071510000b02902351d1972d8so1996031uao.19
        for <netdev@vger.kernel.org>; Fri, 28 May 2021 07:56:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YZNBNLLuM7Y420WwKOJBdrZZvuC/Ic8dNT+7222oonE=;
        b=AC+HnHYwTik2e1waVd6v1biZJ5fBsrI8bMYHMYsEV52IlDS3wjC+TDzEw7hCmcjnV/
         HK0JwBuAKMiEbtmMNKzs+fv9fNcMLVSEItMKP/jLwg/iwsQxEo7Pgw5/hEiOyEzjF68C
         3SVoF+3zX0MAMwd469wfv7wEFHMETelh7aI6Dh4kqtLXIyB9+8H6l4OlQwxKiM97y0QT
         CixZ3+FgMUON3VzpdetJIwlv6YWlP2WWcAFUz4u6iVgbrkw2CHWeKKmSu9bWT9hfKNYK
         IB7/OSqEGm8uW1Xz9HKurFLDoKXdi4Tz7l4SqHUDtY/McsxzS2P3hMtTa9Mmt81tbN7j
         IdQQ==
X-Gm-Message-State: AOAM530xUHJzT1AzjM/viDx7Hf2sHSEh5zODtsoFNOAw1Zqwrfo87OZ5
        CQlWe9Itb2XBXmbhUTWelstnTiVXkv2el+we2o38sU90xfubLdtPwqNDVM6Q/Yc1i1VNoPlZPAA
        swQcO8OoBOI7ZOAGsIWqqNQ38Vhoo8HtP1g==
X-Received: by 2002:a67:4386:: with SMTP id q128mr7616334vsa.40.1622213783376;
        Fri, 28 May 2021 07:56:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw462ZGNtRzoDdQxtj02u5ROHTD96PxGOFoWyntWWXLSO2xCeDF+4IY7LVGZ/iWdl63W5/rIA==
X-Received: by 2002:a67:4386:: with SMTP id q128mr7616310vsa.40.1622213783206;
        Fri, 28 May 2021 07:56:23 -0700 (PDT)
Received: from localhost.localdomain ([45.237.48.3])
        by smtp.gmail.com with ESMTPSA id c15sm743661vko.15.2021.05.28.07.56.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 May 2021 07:56:22 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Randy Dunlap <rdunlap@infradead.org>,
        Jakub Kicinski <kuba@kernel.org>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 06/11] nfc: pn533: drop ftrace-like debugging messages
Date:   Fri, 28 May 2021 10:55:29 -0400
Message-Id: <20210528145534.125460-3-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210528145534.125460-1-krzysztof.kozlowski@canonical.com>
References: <20210528145330.125055-1-krzysztof.kozlowski@canonical.com>
 <20210528145534.125460-1-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that the kernel has ftrace, any debugging calls that just do "made
it to this function!" and "leaving this function!" can be removed.
Better to use standard debugging tools.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
 drivers/nfc/pn533/i2c.c   |  5 -----
 drivers/nfc/pn533/pn533.c | 46 ---------------------------------------
 drivers/nfc/pn533/usb.c   |  4 ----
 3 files changed, 55 deletions(-)

diff --git a/drivers/nfc/pn533/i2c.c b/drivers/nfc/pn533/i2c.c
index bfc617acabae..bb04fddb0504 100644
--- a/drivers/nfc/pn533/i2c.c
+++ b/drivers/nfc/pn533/i2c.c
@@ -174,9 +174,6 @@ static int pn533_i2c_probe(struct i2c_client *client,
 	struct pn533 *priv;
 	int r = 0;
 
-	dev_dbg(&client->dev, "%s\n", __func__);
-	dev_dbg(&client->dev, "IRQ: %d\n", client->irq);
-
 	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C)) {
 		nfc_err(&client->dev, "Need I2C_FUNC_I2C\n");
 		return -ENODEV;
@@ -239,8 +236,6 @@ static int pn533_i2c_remove(struct i2c_client *client)
 {
 	struct pn533_i2c_phy *phy = i2c_get_clientdata(client);
 
-	dev_dbg(&client->dev, "%s\n", __func__);
-
 	free_irq(client->irq, phy);
 
 	pn53x_unregister_nfc(phy->priv);
diff --git a/drivers/nfc/pn533/pn533.c b/drivers/nfc/pn533/pn533.c
index 2c7f9916f206..cd64bfe20402 100644
--- a/drivers/nfc/pn533/pn533.c
+++ b/drivers/nfc/pn533/pn533.c
@@ -1075,8 +1075,6 @@ static int pn533_tm_get_data_complete(struct pn533 *dev, void *arg,
 	u8 status, ret, mi;
 	int rc;
 
-	dev_dbg(dev->dev, "%s\n", __func__);
-
 	if (IS_ERR(resp)) {
 		skb_queue_purge(&dev->resp_q);
 		return PTR_ERR(resp);
@@ -1124,8 +1122,6 @@ static void pn533_wq_tm_mi_recv(struct work_struct *work)
 	struct sk_buff *skb;
 	int rc;
 
-	dev_dbg(dev->dev, "%s\n", __func__);
-
 	skb = pn533_alloc_skb(dev, 0);
 	if (!skb)
 		return;
@@ -1148,8 +1144,6 @@ static void pn533_wq_tm_mi_send(struct work_struct *work)
 	struct sk_buff *skb;
 	int rc;
 
-	dev_dbg(dev->dev, "%s\n", __func__);
-
 	/* Grab the first skb in the queue */
 	skb = skb_dequeue(&dev->fragment_skb);
 	if (skb == NULL) {	/* No more data */
@@ -1186,8 +1180,6 @@ static void pn533_wq_tg_get_data(struct work_struct *work)
 	struct sk_buff *skb;
 	int rc;
 
-	dev_dbg(dev->dev, "%s\n", __func__);
-
 	skb = pn533_alloc_skb(dev, 0);
 	if (!skb)
 		return;
@@ -1206,8 +1198,6 @@ static int pn533_init_target_complete(struct pn533 *dev, struct sk_buff *resp)
 	size_t gb_len;
 	int rc;
 
-	dev_dbg(dev->dev, "%s\n", __func__);
-
 	if (resp->len < ATR_REQ_GB_OFFSET + 1)
 		return -EINVAL;
 
@@ -1260,8 +1250,6 @@ static int pn533_rf_complete(struct pn533 *dev, void *arg,
 {
 	int rc = 0;
 
-	dev_dbg(dev->dev, "%s\n", __func__);
-
 	if (IS_ERR(resp)) {
 		rc = PTR_ERR(resp);
 
@@ -1283,8 +1271,6 @@ static void pn533_wq_rf(struct work_struct *work)
 	struct sk_buff *skb;
 	int rc;
 
-	dev_dbg(dev->dev, "%s\n", __func__);
-
 	skb = pn533_alloc_skb(dev, 2);
 	if (!skb)
 		return;
@@ -1360,8 +1346,6 @@ static int pn533_poll_dep(struct nfc_dev *nfc_dev)
 	u8 *next, nfcid3[NFC_NFCID3_MAXSIZE];
 	u8 passive_data[PASSIVE_DATA_LEN] = {0x00, 0xff, 0xff, 0x00, 0x3};
 
-	dev_dbg(dev->dev, "%s", __func__);
-
 	if (!dev->gb) {
 		dev->gb = nfc_get_local_general_bytes(nfc_dev, &dev->gb_len);
 
@@ -1511,8 +1495,6 @@ static int pn533_poll_complete(struct pn533 *dev, void *arg,
 	struct pn533_poll_modulations *cur_mod;
 	int rc;
 
-	dev_dbg(dev->dev, "%s\n", __func__);
-
 	if (IS_ERR(resp)) {
 		rc = PTR_ERR(resp);
 
@@ -1783,8 +1765,6 @@ static int pn533_activate_target_nfcdep(struct pn533 *dev)
 	struct sk_buff *skb;
 	struct sk_buff *resp;
 
-	dev_dbg(dev->dev, "%s\n", __func__);
-
 	skb = pn533_alloc_skb(dev, sizeof(u8) * 2); /*TG + Next*/
 	if (!skb)
 		return -ENOMEM;
@@ -1866,8 +1846,6 @@ static int pn533_deactivate_target_complete(struct pn533 *dev, void *arg,
 {
 	int rc = 0;
 
-	dev_dbg(dev->dev, "%s\n", __func__);
-
 	if (IS_ERR(resp)) {
 		rc = PTR_ERR(resp);
 
@@ -1892,8 +1870,6 @@ static void pn533_deactivate_target(struct nfc_dev *nfc_dev,
 	struct sk_buff *skb;
 	int rc;
 
-	dev_dbg(dev->dev, "%s\n", __func__);
-
 	if (!dev->tgt_active_prot) {
 		nfc_err(dev->dev, "There is no active target\n");
 		return;
@@ -1988,8 +1964,6 @@ static int pn533_dep_link_up(struct nfc_dev *nfc_dev, struct nfc_target *target,
 	u8 *next, *arg, nfcid3[NFC_NFCID3_MAXSIZE];
 	u8 passive_data[PASSIVE_DATA_LEN] = {0x00, 0xff, 0xff, 0x00, 0x3};
 
-	dev_dbg(dev->dev, "%s\n", __func__);
-
 	if (dev->poll_mod_count) {
 		nfc_err(dev->dev,
 			"Cannot bring the DEP link up while polling\n");
@@ -2067,8 +2041,6 @@ static int pn533_dep_link_down(struct nfc_dev *nfc_dev)
 {
 	struct pn533 *dev = nfc_get_drvdata(nfc_dev);
 
-	dev_dbg(dev->dev, "%s\n", __func__);
-
 	pn533_poll_reset_mod_list(dev);
 
 	if (dev->tgt_mode || dev->tgt_active_prot)
@@ -2092,8 +2064,6 @@ static struct sk_buff *pn533_build_response(struct pn533 *dev)
 	struct sk_buff *skb, *tmp, *t;
 	unsigned int skb_len = 0, tmp_len = 0;
 
-	dev_dbg(dev->dev, "%s\n", __func__);
-
 	if (skb_queue_empty(&dev->resp_q))
 		return NULL;
 
@@ -2133,8 +2103,6 @@ static int pn533_data_exchange_complete(struct pn533 *dev, void *_arg,
 	int rc = 0;
 	u8 status, ret, mi;
 
-	dev_dbg(dev->dev, "%s\n", __func__);
-
 	if (IS_ERR(resp)) {
 		rc = PTR_ERR(resp);
 		goto _error;
@@ -2288,8 +2256,6 @@ static int pn533_transceive(struct nfc_dev *nfc_dev,
 	struct pn533_data_exchange_arg *arg = NULL;
 	int rc;
 
-	dev_dbg(dev->dev, "%s\n", __func__);
-
 	if (!dev->tgt_active_prot) {
 		nfc_err(dev->dev,
 			"Can't exchange data if there is no active target\n");
@@ -2356,8 +2322,6 @@ static int pn533_tm_send_complete(struct pn533 *dev, void *arg,
 {
 	u8 status;
 
-	dev_dbg(dev->dev, "%s\n", __func__);
-
 	if (IS_ERR(resp))
 		return PTR_ERR(resp);
 
@@ -2388,8 +2352,6 @@ static int pn533_tm_send(struct nfc_dev *nfc_dev, struct sk_buff *skb)
 	struct pn533 *dev = nfc_get_drvdata(nfc_dev);
 	int rc;
 
-	dev_dbg(dev->dev, "%s\n", __func__);
-
 	/* let's split in multiple chunks if size's too big */
 	if (skb->len > PN533_CMD_DATAEXCH_DATA_MAXLEN) {
 		rc = pn533_fill_fragment_skbs(dev, skb);
@@ -2426,8 +2388,6 @@ static void pn533_wq_mi_recv(struct work_struct *work)
 	struct sk_buff *skb;
 	int rc;
 
-	dev_dbg(dev->dev, "%s\n", __func__);
-
 	skb = pn533_alloc_skb(dev, PN533_CMD_DATAEXCH_HEAD_LEN);
 	if (!skb)
 		goto error;
@@ -2476,8 +2436,6 @@ static void pn533_wq_mi_send(struct work_struct *work)
 	struct sk_buff *skb;
 	int rc;
 
-	dev_dbg(dev->dev, "%s\n", __func__);
-
 	/* Grab the first skb in the queue */
 	skb = skb_dequeue(&dev->fragment_skb);
 
@@ -2533,8 +2491,6 @@ static int pn533_set_configuration(struct pn533 *dev, u8 cfgitem, u8 *cfgdata,
 	struct sk_buff *resp;
 	int skb_len;
 
-	dev_dbg(dev->dev, "%s\n", __func__);
-
 	skb_len = sizeof(cfgitem) + cfgdata_len; /* cfgitem + cfgdata */
 
 	skb = pn533_alloc_skb(dev, skb_len);
@@ -2580,8 +2536,6 @@ static int pn533_pasori_fw_reset(struct pn533 *dev)
 	struct sk_buff *skb;
 	struct sk_buff *resp;
 
-	dev_dbg(dev->dev, "%s\n", __func__);
-
 	skb = pn533_alloc_skb(dev, sizeof(u8));
 	if (!skb)
 		return -ENOMEM;
diff --git a/drivers/nfc/pn533/usb.c b/drivers/nfc/pn533/usb.c
index 84d2bfabf42b..bd7f7478d189 100644
--- a/drivers/nfc/pn533/usb.c
+++ b/drivers/nfc/pn533/usb.c
@@ -354,8 +354,6 @@ static void pn533_acr122_poweron_rdr_resp(struct urb *urb)
 {
 	struct pn533_acr122_poweron_rdr_arg *arg = urb->context;
 
-	dev_dbg(&urb->dev->dev, "%s\n", __func__);
-
 	print_hex_dump_debug("ACR122 RX: ", DUMP_PREFIX_NONE, 16, 1,
 		       urb->transfer_buffer, urb->transfer_buffer_length,
 		       false);
@@ -375,8 +373,6 @@ static int pn533_acr122_poweron_rdr(struct pn533_usb_phy *phy)
 	void *cntx;
 	struct pn533_acr122_poweron_rdr_arg arg;
 
-	dev_dbg(&phy->udev->dev, "%s\n", __func__);
-
 	buffer = kmemdup(cmd, sizeof(cmd), GFP_KERNEL);
 	if (!buffer)
 		return -ENOMEM;
-- 
2.27.0

