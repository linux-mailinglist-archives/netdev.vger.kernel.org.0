Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86ABD4624E8
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 23:30:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232105AbhK2WdI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 17:33:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232269AbhK2WbJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 17:31:09 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C591AC096768
        for <netdev@vger.kernel.org>; Mon, 29 Nov 2021 14:27:51 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id b13so13361089plg.2
        for <netdev@vger.kernel.org>; Mon, 29 Nov 2021 14:27:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bluerivertech.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/KmtMbfeaXHuTAh4g4GRV6pvDUPLEEqbIUrWqrzrkr4=;
        b=MVciiR/0Lt0NLKjRq9rUA8C0kKeHsKsdf0Qk7wdF1y1yrM0xmZfTFv/X/5yzqZ+9QB
         vTqZJ4KDLHlujFvzzv1PiPlPgDnDSPt7TffxI7pXBiB3BdQjXuSdy5AF+uGRdaamwIQk
         mXXVNute8wPzRxjw2nWVMe0cT4ZibcmIoAatoJ4Y1g2ovWmLrXKDhLXBQQ46RbGtXqzn
         niVALQcT8seeEMznpSq4A1x/40mpUf9Fztc+Oz3YR0c1pSnYkjId2+B2xWPrZ2v0Ao5C
         c/ljTZThfQVi0S9vhUqt9iAitGGQ25haovbzXuJ9v/GXssRhiVwLb8VCk+DvaBdWqZp5
         FP1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/KmtMbfeaXHuTAh4g4GRV6pvDUPLEEqbIUrWqrzrkr4=;
        b=O3o+Ckl8zb40kPgScP6UeY7TH6oN5ogBwhO7oVvaAm7k/lHIDkhNsOxsMqQyFy1HTO
         ZGZWeBUx/lkz/aQwvq/Il47OcHu+BmF4Rd4xA4DR8QheS2Jp3aFwWiNeoklnSTVkZZtS
         UuCvGo6L6aeMLmPALXv8pfJjaAKR1u580UECkzvGnFbpt3CCM0qBK3iOlXQIpm7ljwiv
         Ul7dDo6Qev5OoXLhxmcOZuOehgwHWXTT+4tmxjGFQkWX61m5Q5gYE+VfMAjMGDdyO+IG
         AXu2SRxDl88z8bMl3ynbbR/rsKlh54q/khDtLgUZkshDlZqhIF4qLoqNNqWhDtANolFW
         PPLQ==
X-Gm-Message-State: AOAM533bLNdudczoYDrUunULhal1vknM6bplzcMXdehkwB60u99vDEMa
        lTxamAWQErSzab8HlHEPrxD3Rw==
X-Google-Smtp-Source: ABdhPJzFMLhjVLY9yCkfDQgnTgKpGAYN3oXMd2qZQsYSNGPxE+7RvtTX5dk8CU0Oy91xu3uUaBwmoQ==
X-Received: by 2002:a17:90b:4a0f:: with SMTP id kk15mr1011991pjb.223.1638224871243;
        Mon, 29 Nov 2021 14:27:51 -0800 (PST)
Received: from localhost.localdomain (c-73-231-33-37.hsd1.ca.comcast.net. [73.231.33.37])
        by smtp.gmail.com with ESMTPSA id i2sm19489983pfg.90.2021.11.29.14.27.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Nov 2021 14:27:50 -0800 (PST)
From:   Brian Silverman <brian.silverman@bluerivertech.com>
Cc:     Brian Silverman <brian.silverman@bluerivertech.com>,
        Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Dong Aisheng <b29396@freescale.com>,
        Varka Bhadram <varkabhadram@gmail.com>,
        Fengguang Wu <fengguang.wu@intel.com>,
        linux-can@vger.kernel.org (open list:MCAN MMIO DEVICE DRIVER),
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH RESEND] can: m_can: Disable and ignore ELO interrupt
Date:   Mon, 29 Nov 2021 14:26:28 -0800
Message-Id: <20211129222628.7490-1-brian.silverman@bluerivertech.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20211109021240.3013-1-brian.silverman@bluerivertech.com>
References: <20211109021240.3013-1-brian.silverman@bluerivertech.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With the design of this driver, this condition is often triggered.
However, the counter that this interrupt indicates an overflow is never
read either, so overflowing is harmless.

On my system, when a CAN bus starts flapping up and down, this locks up
the whole system with lots of interrupts and printks.

Specifically, this interrupt indicates the CEL field of ECR has
overflowed. All reads of ECR mask out CEL.

Fixes: e0d1f4816f2a ("can: m_can: add Bosch M_CAN controller support")
Signed-off-by: Brian Silverman <brian.silverman@bluerivertech.com>
---
 drivers/net/can/m_can/m_can.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index 2470c47b2e31..91be87c4f4d3 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -204,16 +204,16 @@ enum m_can_reg {
 
 /* Interrupts for version 3.0.x */
 #define IR_ERR_LEC_30X	(IR_STE	| IR_FOE | IR_ACKE | IR_BE | IR_CRCE)
-#define IR_ERR_BUS_30X	(IR_ERR_LEC_30X | IR_WDI | IR_ELO | IR_BEU | \
-			 IR_BEC | IR_TOO | IR_MRAF | IR_TSW | IR_TEFL | \
-			 IR_RF1L | IR_RF0L)
+#define IR_ERR_BUS_30X	(IR_ERR_LEC_30X | IR_WDI | IR_BEU | IR_BEC | \
+			 IR_TOO | IR_MRAF | IR_TSW | IR_TEFL | IR_RF1L | \
+			 IR_RF0L)
 #define IR_ERR_ALL_30X	(IR_ERR_STATE | IR_ERR_BUS_30X)
 
 /* Interrupts for version >= 3.1.x */
 #define IR_ERR_LEC_31X	(IR_PED | IR_PEA)
-#define IR_ERR_BUS_31X      (IR_ERR_LEC_31X | IR_WDI | IR_ELO | IR_BEU | \
-			 IR_BEC | IR_TOO | IR_MRAF | IR_TSW | IR_TEFL | \
-			 IR_RF1L | IR_RF0L)
+#define IR_ERR_BUS_31X      (IR_ERR_LEC_31X | IR_WDI | IR_BEU | IR_BEC | \
+			 IR_TOO | IR_MRAF | IR_TSW | IR_TEFL | IR_RF1L | \
+			 IR_RF0L)
 #define IR_ERR_ALL_31X	(IR_ERR_STATE | IR_ERR_BUS_31X)
 
 /* Interrupt Line Select (ILS) */
@@ -810,8 +810,6 @@ static void m_can_handle_other_err(struct net_device *dev, u32 irqstatus)
 {
 	if (irqstatus & IR_WDI)
 		netdev_err(dev, "Message RAM Watchdog event due to missing READY\n");
-	if (irqstatus & IR_ELO)
-		netdev_err(dev, "Error Logging Overflow\n");
 	if (irqstatus & IR_BEU)
 		netdev_err(dev, "Bit Error Uncorrected\n");
 	if (irqstatus & IR_BEC)

base-commit: d2f38a3c6507b2520101f9a3807ed98f1bdc545a
-- 
2.20.1

