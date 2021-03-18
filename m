Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1322B340092
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 09:03:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229752AbhCRICb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 04:02:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229704AbhCRICB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 04:02:01 -0400
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC71EC06174A
        for <netdev@vger.kernel.org>; Thu, 18 Mar 2021 01:02:00 -0700 (PDT)
Received: by mail-lj1-x232.google.com with SMTP id 16so6342756ljc.11
        for <netdev@vger.kernel.org>; Thu, 18 Mar 2021 01:02:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cIe1Uvj7oaFehOcIYPhM15B/Z4PlB2/52IGYbN2NUD0=;
        b=LvSadRdFKf+eCHT5juLIX+dXVKNgS+ASE6A8RUPsBhdBniNMMaiQ5yh9CFEjw21Fy7
         3XCq6Yvc64seQKnVE541XZ58ISoFo2t1Wr95iGi86KJRnK+w98QKBEyKhTZ/AJh2PEK2
         yATrnsb6ZZm6m8fei6XWl9lndNH8Yhyf2Up0ttZ/MnYD04QoSRmjURoJospmfdDPY2BI
         hhViHqaKn/sorflGc+pqdhqIhaJXZMx/ET7ZbnBwgdN81iFHb9r7/gsMkyRvMrgnlMv0
         7ZyD60nRVRTUsp3vp4X0JM5dmPb8nOjGD0pOmYccBxZUh71prQVsBPGKgC654d/sHuTq
         zQ5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cIe1Uvj7oaFehOcIYPhM15B/Z4PlB2/52IGYbN2NUD0=;
        b=IMJFuNAhEqdzb3bfxjEESlg68++Ad+x9Gnik+CSi3qkjlvlfBvz5DCIAYS7mz8WG1z
         zBl6HdnCZ2wkzVHqW7ov2bFAZHnC6D8Gjj3Xh4TI5gQrM1TKzKQC0abgpzsz+jIiAiDE
         ZiCH+hQLMXPQ3AWeQEnQMj9lm5MAlC9hNyItfynjsudxDriWF/+RK1sYrt/C830FiTeC
         eU/6F19jCaAcDOjWNwyuIDBsfg+QcK7L9VwHZLhrTz3ZbGfvAcpYz9uY49Uj1bBM626G
         KlsbSM7WEMhNhpLs4bGI3u269Kl0+tpwGm049M6xYjwcvsMAG/ejYW8oF4ITbB6yHrAs
         dJzg==
X-Gm-Message-State: AOAM533xgyBpJHHMHKFY+BLMPeTwItM0K/awlkwSO+7S3/uf8Ucul0/O
        5ruIJEpcufvzAPpULo7l0MU=
X-Google-Smtp-Source: ABdhPJzywrgQ2pSHmOsaMcxTJ9XoZ9Bek3umSwzj/n0gT5qrOrHq1+0XjvoVSjRxNG/xNT2uhrU0dA==
X-Received: by 2002:a2e:b5a5:: with SMTP id f5mr4684559ljn.336.1616054519402;
        Thu, 18 Mar 2021 01:01:59 -0700 (PDT)
Received: from localhost.lan (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.gmail.com with ESMTPSA id m19sm142717ljb.10.2021.03.18.01.01.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Mar 2021 01:01:59 -0700 (PDT)
From:   =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH net-next V2 2/2] net: dsa: bcm_sf2: fix BCM4908 RGMII reg(s)
Date:   Thu, 18 Mar 2021 09:01:43 +0100
Message-Id: <20210318080143.32449-2-zajec5@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210318080143.32449-1-zajec5@gmail.com>
References: <20210318080143.32449-1-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rafał Miłecki <rafal@milecki.pl>

BCM4908 has only 1 RGMII reg for controlling port 7.

Fixes: 73b7a6047971 ("net: dsa: bcm_sf2: support BCM4908's integrated switch")
Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
 drivers/net/dsa/bcm_sf2.c      | 11 +++++++----
 drivers/net/dsa/bcm_sf2_regs.h |  1 +
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/bcm_sf2.c b/drivers/net/dsa/bcm_sf2.c
index 4261a06ad050..9150038b60cb 100644
--- a/drivers/net/dsa/bcm_sf2.c
+++ b/drivers/net/dsa/bcm_sf2.c
@@ -36,7 +36,12 @@ static u16 bcm_sf2_reg_rgmii_cntrl(struct bcm_sf2_priv *priv, int port)
 {
 	switch (priv->type) {
 	case BCM4908_DEVICE_ID:
-		/* TODO */
+		switch (port) {
+		case 7:
+			return REG_RGMII_11_CNTRL;
+		default:
+			break;
+		}
 		break;
 	default:
 		switch (port) {
@@ -1228,9 +1233,7 @@ static const u16 bcm_sf2_4908_reg_offsets[] = {
 	[REG_PHY_REVISION]	= 0x14,
 	[REG_SPHY_CNTRL]	= 0x24,
 	[REG_CROSSBAR]		= 0xc8,
-	[REG_RGMII_0_CNTRL]	= 0xe0,
-	[REG_RGMII_1_CNTRL]	= 0xec,
-	[REG_RGMII_2_CNTRL]	= 0xf8,
+	[REG_RGMII_11_CNTRL]	= 0x014c,
 	[REG_LED_0_CNTRL]	= 0x40,
 	[REG_LED_1_CNTRL]	= 0x4c,
 	[REG_LED_2_CNTRL]	= 0x58,
diff --git a/drivers/net/dsa/bcm_sf2_regs.h b/drivers/net/dsa/bcm_sf2_regs.h
index 3d5515fe43cb..7bffc80f241f 100644
--- a/drivers/net/dsa/bcm_sf2_regs.h
+++ b/drivers/net/dsa/bcm_sf2_regs.h
@@ -21,6 +21,7 @@ enum bcm_sf2_reg_offs {
 	REG_RGMII_0_CNTRL,
 	REG_RGMII_1_CNTRL,
 	REG_RGMII_2_CNTRL,
+	REG_RGMII_11_CNTRL,
 	REG_LED_0_CNTRL,
 	REG_LED_1_CNTRL,
 	REG_LED_2_CNTRL,
-- 
2.26.2

