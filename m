Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 575673DA147
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 12:40:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236640AbhG2Kkt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 06:40:49 -0400
Received: from smtp-relay-canonical-0.canonical.com ([185.125.188.120]:34476
        "EHLO smtp-relay-canonical-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236169AbhG2Kkl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Jul 2021 06:40:41 -0400
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com [209.85.218.69])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPS id 391E33F239
        for <netdev@vger.kernel.org>; Thu, 29 Jul 2021 10:40:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1627555238;
        bh=a08v9hxy0zgk30tu0EPhwU1/dVMKGIwopyByTRLQTW8=;
        h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=JSE+sse5AK/JvJNGhV7vdPnzd3eYs2rDC75u6Mf29C2lO9rRofDhpS6NoU33uy36T
         ZZ2l7whi5jMpSpt7BwwsFxnnEDsIXDG6zEuAXeOayLqgORFACY2d8kBO8PMt2aPMml
         5sZBI/qgy4KuXo6oYUufe04N+ny4SKUfDdcEx7qL7WVblBARU4WY9MFvOK9rJBYlMF
         aDM2xlNid8niIGQWJy8cHOZqORnkxdtr4JNppnzARupATcD1anmF7BNg2s641fbA1q
         /Z+74eihU+KJ1RFEllS6pL+4hVba1RXmIfiFqlKAZyjmpqoEsE7poabPuNGcQ/qInZ
         V7sYFKbLGSfJQ==
Received: by mail-ej1-f69.google.com with SMTP id gg1-20020a170906e281b029053d0856c4cdso1825205ejb.15
        for <netdev@vger.kernel.org>; Thu, 29 Jul 2021 03:40:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=a08v9hxy0zgk30tu0EPhwU1/dVMKGIwopyByTRLQTW8=;
        b=h1eLNerjBba0YyJvhbBV7uChpL3YVL2ffN8lgiK2jmjFU7QpcCE21IS4AO5Hi+IuBh
         T8xWr/ljyrWn+jBnk/JR3fv5UQdgm+zFpDwVmo46goXAxs5RDyW5YwN9IrUiLV0trvHq
         LvpR7wskHDAuUGU1tEgnGdZbkvucj218H0O7dqhlR/DVXyVwcCN8WDh1oUB9NP+KeXAw
         ru0X9ucKkoW50MudKptQmEERg5z0fGjHyEArFfLHjkC50+S0sor/2atm1lDrkGCT5Sf3
         H9mdcasIuSjjz0LNLpxLpu7y7nkehVaYOS0yC+PPw7ecHAV0FVaaqkbDdXSsV7x+H8JJ
         Ubnw==
X-Gm-Message-State: AOAM531S0VBKITYHxtbbeVbi/seIQS2OFZE2Ib0c/Odu1IgFvveFPpqL
        Dmlbtm71f8ZP3iKekwsc11R7dgZS6alWvDScbXE5Uuvm7xTVQDAD8nvseI+h13ozks2Er2gWpC5
        zWPQ2oFNaSKcrwmjnRfVW1/fiNn16ivnIHg==
X-Received: by 2002:a17:906:94cd:: with SMTP id d13mr4063281ejy.158.1627555237729;
        Thu, 29 Jul 2021 03:40:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxpcC8Z7IC55TpoG5cbgBRsSSS6C555lTVpoloQhomyURPjel7+zQOzWNYTmYIp//p8tRPZ1g==
X-Received: by 2002:a17:906:94cd:: with SMTP id d13mr4063260ejy.158.1627555237495;
        Thu, 29 Jul 2021 03:40:37 -0700 (PDT)
Received: from localhost.localdomain ([86.32.47.9])
        by smtp.gmail.com with ESMTPSA id c14sm824475ejb.78.2021.07.29.03.40.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jul 2021 03:40:37 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Mark Greer <mgreer@animalcreek.com>,
        Bongsu Jeon <bongsu.jeon@samsung.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: [PATCH 03/12] nfc: port100: constify several pointers
Date:   Thu, 29 Jul 2021 12:40:13 +0200
Message-Id: <20210729104022.47761-4-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210729104022.47761-1-krzysztof.kozlowski@canonical.com>
References: <20210729104022.47761-1-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Several functions do not modify pointed data so arguments and local
variables can be const for correctness and safety.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
 drivers/nfc/port100.c | 37 ++++++++++++++++++++-----------------
 1 file changed, 20 insertions(+), 17 deletions(-)

diff --git a/drivers/nfc/port100.c b/drivers/nfc/port100.c
index ccb5c5fab905..517376c43b86 100644
--- a/drivers/nfc/port100.c
+++ b/drivers/nfc/port100.c
@@ -526,7 +526,7 @@ static inline u8 port100_checksum(u16 value)
 }
 
 /* The rule: sum(data elements) + checksum = 0 */
-static u8 port100_data_checksum(u8 *data, int datalen)
+static u8 port100_data_checksum(const u8 *data, int datalen)
 {
 	u8 sum = 0;
 	int i;
@@ -568,10 +568,10 @@ static void port100_tx_update_payload_len(void *_frame, int len)
 	le16_add_cpu(&frame->datalen, len);
 }
 
-static bool port100_rx_frame_is_valid(void *_frame)
+static bool port100_rx_frame_is_valid(const void *_frame)
 {
 	u8 checksum;
-	struct port100_frame *frame = _frame;
+	const struct port100_frame *frame = _frame;
 
 	if (frame->start_frame != cpu_to_be16(PORT100_FRAME_SOF) ||
 	    frame->extended_frame != cpu_to_be16(PORT100_FRAME_EXT))
@@ -589,23 +589,24 @@ static bool port100_rx_frame_is_valid(void *_frame)
 	return true;
 }
 
-static bool port100_rx_frame_is_ack(struct port100_ack_frame *frame)
+static bool port100_rx_frame_is_ack(const struct port100_ack_frame *frame)
 {
 	return (frame->start_frame == cpu_to_be16(PORT100_FRAME_SOF) &&
 		frame->ack_frame == cpu_to_be16(PORT100_FRAME_ACK));
 }
 
-static inline int port100_rx_frame_size(void *frame)
+static inline int port100_rx_frame_size(const void *frame)
 {
-	struct port100_frame *f = frame;
+	const struct port100_frame *f = frame;
 
 	return sizeof(struct port100_frame) + le16_to_cpu(f->datalen) +
 	       PORT100_FRAME_TAIL_LEN;
 }
 
-static bool port100_rx_frame_is_cmd_response(struct port100 *dev, void *frame)
+static bool port100_rx_frame_is_cmd_response(const struct port100 *dev,
+					     const void *frame)
 {
-	struct port100_frame *f = frame;
+	const struct port100_frame *f = frame;
 
 	return (PORT100_FRAME_CMD(f) == PORT100_CMD_RESPONSE(dev->cmd->code));
 }
@@ -655,7 +656,8 @@ static void port100_recv_response(struct urb *urb)
 	schedule_work(&dev->cmd_complete_work);
 }
 
-static int port100_submit_urb_for_response(struct port100 *dev, gfp_t flags)
+static int port100_submit_urb_for_response(const struct port100 *dev,
+					   gfp_t flags)
 {
 	dev->in_urb->complete = port100_recv_response;
 
@@ -666,7 +668,7 @@ static void port100_recv_ack(struct urb *urb)
 {
 	struct port100 *dev = urb->context;
 	struct port100_cmd *cmd = dev->cmd;
-	struct port100_ack_frame *in_frame;
+	const struct port100_ack_frame *in_frame;
 	int rc;
 
 	cmd->status = urb->status;
@@ -708,7 +710,7 @@ static void port100_recv_ack(struct urb *urb)
 	schedule_work(&dev->cmd_complete_work);
 }
 
-static int port100_submit_urb_for_ack(struct port100 *dev, gfp_t flags)
+static int port100_submit_urb_for_ack(const struct port100 *dev, gfp_t flags)
 {
 	dev->in_urb->complete = port100_recv_ack;
 
@@ -753,8 +755,9 @@ static int port100_send_ack(struct port100 *dev)
 	return rc;
 }
 
-static int port100_send_frame_async(struct port100 *dev, struct sk_buff *out,
-				    struct sk_buff *in, int in_len)
+static int port100_send_frame_async(struct port100 *dev,
+				    const struct sk_buff *out,
+				    const struct sk_buff *in, int in_len)
 {
 	int rc;
 
@@ -960,7 +963,7 @@ static void port100_abort_cmd(struct nfc_digital_dev *ddev)
 	usb_kill_urb(dev->in_urb);
 }
 
-static struct sk_buff *port100_alloc_skb(struct port100 *dev, unsigned int size)
+static struct sk_buff *port100_alloc_skb(const struct port100 *dev, unsigned int size)
 {
 	struct sk_buff *skb;
 
@@ -1152,7 +1155,7 @@ static int port100_in_configure_hw(struct nfc_digital_dev *ddev, int type,
 static void port100_in_comm_rf_complete(struct port100 *dev, void *arg,
 				       struct sk_buff *resp)
 {
-	struct port100_cb_arg *cb_arg = arg;
+	const struct port100_cb_arg *cb_arg = arg;
 	nfc_digital_cmd_complete_t cb = cb_arg->complete_cb;
 	u32 status;
 	int rc;
@@ -1330,7 +1333,7 @@ static void port100_tg_comm_rf_complete(struct port100 *dev, void *arg,
 					struct sk_buff *resp)
 {
 	u32 status;
-	struct port100_cb_arg *cb_arg = arg;
+	const struct port100_cb_arg *cb_arg = arg;
 	nfc_digital_cmd_complete_t cb = cb_arg->complete_cb;
 	struct port100_tg_comm_rf_res *hdr;
 
@@ -1453,7 +1456,7 @@ static int port100_listen_mdaa(struct nfc_digital_dev *ddev,
 static int port100_listen(struct nfc_digital_dev *ddev, u16 timeout,
 			  nfc_digital_cmd_complete_t cb, void *arg)
 {
-	struct port100 *dev = nfc_digital_get_drvdata(ddev);
+	const struct port100 *dev = nfc_digital_get_drvdata(ddev);
 	struct sk_buff *skb;
 
 	skb = port100_alloc_skb(dev, 0);
-- 
2.27.0

