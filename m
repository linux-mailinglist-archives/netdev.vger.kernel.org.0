Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 805833DA154
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 12:41:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236980AbhG2KlA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 06:41:00 -0400
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:47826
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235880AbhG2Kkt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Jul 2021 06:40:49 -0400
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com [209.85.208.70])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPS id 6CFB43F23A
        for <netdev@vger.kernel.org>; Thu, 29 Jul 2021 10:40:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1627555246;
        bh=BZIMPFV8uXC9L/K0xzDgkM9m6seQbMO32c9dNbfWa80=;
        h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=BTaP1d8ydrV0hgqkvf/+UhufeiCSWdGIGAW4o196Prd6ZEqDC2WF3iYjM848wn9Dj
         VPKZ8ix+0RfiaO26QLgqT7Z/1agpsiRaeCzPIDc0jHdLJiHnmltOES+3nX113AcY88
         +9XVJP0/1JjYJRM/nSMyX2LE7f615J6AwEZ5nXupdTkR5itCw5mz66kXyZpHPcGBLf
         7rS9vDW9u8VlblQ0tv8KO25uGVKV/GU21bs4JxY77fjIaBCJ+MIo8nWAzep7v78vAn
         zsvgWkvLVPIgGMNqKzHht81g6NPRQxwWcEhaWWYlvOLySc15W0153dZ6YFCDSDaOt+
         mclQZNrRELrLA==
Received: by mail-ed1-f70.google.com with SMTP id p2-20020a50c9420000b02903a12bbba1ebso2729727edh.6
        for <netdev@vger.kernel.org>; Thu, 29 Jul 2021 03:40:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BZIMPFV8uXC9L/K0xzDgkM9m6seQbMO32c9dNbfWa80=;
        b=LfMJhctMPZP07KPs5q1R6GJZ1e4K4RL6FIahb7ZRJgzrTFQ2Zy9R1IHqjguheOOuk3
         txnvcF1fD54xLnWKk2vsQKUGb7hJcyGUfC9+h3wn09NRLQ6Ho81M1ff5+y7q+cKZBEJi
         f/bbcYWcpRTIXav3Mj4FacMtW3Mtq2BMbNg1vGTlT2U2c9OtbnR6L1V0XStF0DrTZYO8
         UNRl7mn0cYNLTYpgxHWJ+mnu0XzvP0ekrTa3DdFwHb67lpKYf67SVQVeW4hWcHKeZQJn
         9ZN8oLPUCpeiUkBX0m1nMYlz4Pw+aNWTP+Q5+vg7xbCz5D+8AayciSydXrImylRE++xs
         Tjzg==
X-Gm-Message-State: AOAM53294Oe2Acy/QmnWcvkDOKg9Hmk1l68y16HmYs8/zUDYPNimCnNV
        0eBAGnaCx57wJ2u5MmE5RXyly1j2thvNEGiHhwN82zsz+GTI2XxtAZlbBeLPyF8KVkO1GZI0yx9
        wEs5mgpYJEEb+5h0/r35Vmrw7BaoRPgX1iQ==
X-Received: by 2002:a17:906:b0c5:: with SMTP id bk5mr3881339ejb.428.1627555246144;
        Thu, 29 Jul 2021 03:40:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJygcbnz2mL1I+EM9Bv/vZsYeICNIGIdcaZXywSSZmph4zECffAhqDCrnUSC3LB/1TyQegjgiQ==
X-Received: by 2002:a17:906:b0c5:: with SMTP id bk5mr3881326ejb.428.1627555246020;
        Thu, 29 Jul 2021 03:40:46 -0700 (PDT)
Received: from localhost.localdomain ([86.32.47.9])
        by smtp.gmail.com with ESMTPSA id c14sm824475ejb.78.2021.07.29.03.40.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jul 2021 03:40:45 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Mark Greer <mgreer@animalcreek.com>,
        Bongsu Jeon <bongsu.jeon@samsung.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: [PATCH 10/12] nfc: microread: constify several pointers
Date:   Thu, 29 Jul 2021 12:40:20 +0200
Message-Id: <20210729104022.47761-11-krzysztof.kozlowski@canonical.com>
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
 drivers/nfc/microread/i2c.c       | 2 +-
 drivers/nfc/microread/microread.c | 4 ++--
 drivers/nfc/microread/microread.h | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/nfc/microread/i2c.c b/drivers/nfc/microread/i2c.c
index f91760c78455..86f593c73ed6 100644
--- a/drivers/nfc/microread/i2c.c
+++ b/drivers/nfc/microread/i2c.c
@@ -73,7 +73,7 @@ static void microread_i2c_remove_len_crc(struct sk_buff *skb)
 	skb_trim(skb, MICROREAD_I2C_FRAME_TAILROOM);
 }
 
-static int check_crc(struct sk_buff *skb)
+static int check_crc(const struct sk_buff *skb)
 {
 	int i;
 	u8 crc = 0;
diff --git a/drivers/nfc/microread/microread.c b/drivers/nfc/microread/microread.c
index 8e847524937c..9d83ccebd434 100644
--- a/drivers/nfc/microread/microread.c
+++ b/drivers/nfc/microread/microread.c
@@ -358,7 +358,7 @@ static int microread_complete_target_discovered(struct nfc_hci_dev *hdev,
 static void microread_im_transceive_cb(void *context, struct sk_buff *skb,
 				       int err)
 {
-	struct microread_info *info = context;
+	const struct microread_info *info = context;
 
 	switch (info->async_cb_type) {
 	case MICROREAD_CB_TYPE_READER_ALL:
@@ -642,7 +642,7 @@ static const struct nfc_hci_ops microread_hci_ops = {
 };
 
 int microread_probe(void *phy_id, const struct nfc_phy_ops *phy_ops,
-		    char *llc_name, int phy_headroom, int phy_tailroom,
+		    const char *llc_name, int phy_headroom, int phy_tailroom,
 		    int phy_payload, struct nfc_hci_dev **hdev)
 {
 	struct microread_info *info;
diff --git a/drivers/nfc/microread/microread.h b/drivers/nfc/microread/microread.h
index 76152d7aa53c..2ee7ccfa22dd 100644
--- a/drivers/nfc/microread/microread.h
+++ b/drivers/nfc/microread/microread.h
@@ -11,7 +11,7 @@
 #define DRIVER_DESC "NFC driver for microread"
 
 int microread_probe(void *phy_id, const struct nfc_phy_ops *phy_ops,
-		    char *llc_name, int phy_headroom, int phy_tailroom,
+		    const char *llc_name, int phy_headroom, int phy_tailroom,
 		    int phy_payload, struct nfc_hci_dev **hdev);
 
 void microread_remove(struct nfc_hci_dev *hdev);
-- 
2.27.0

