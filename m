Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA3B025ABC1
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 15:08:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726307AbgIBNH5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 09:07:57 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:39947 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727894AbgIBNG6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Sep 2020 09:06:58 -0400
Received: by mail-pf1-f195.google.com with SMTP id c142so2805333pfb.7;
        Wed, 02 Sep 2020 06:06:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZPF6dcQt0YspR4Xib4GiZ0r7jS4hXKfnkGhS0zP4NFk=;
        b=RQS+GfuiJaGcJAi8vmGc0liMEQX5tqBt2uP6pM7osVFOxysxY2RHV0JwvqNMibEBbR
         znrdO0AEEsS6AzjJUpjj12XE4qUFjtfTlbZ8Zt3ZLPfZRiwADGKOdX3ZZZl0Yl75Ijfn
         9K1pRIp/Dr0yX7QzvlE00ESZXiZxBdN6MNe589NYVlTSTrvkDV7q78O3ZAxGoCUSYKW9
         LFiWvQSUZI7BeTsVr6JcrEy/DUWl9mRmZ39yurbJe9SFUjrSBMmIEgJeOaqQAOz18V+h
         dHWnBBaE3PZCsMrqsEsnJy7SKGMlmyfCwMF32mSbBkLBnF/1ps4OUgI443tHT8/o+XsG
         +L3Q==
X-Gm-Message-State: AOAM531511Pxhdwsm3uF2tSy0wzodOSGRaBB3TZeddPrT54BR67twgQ8
        O9OMssB/LaYUSSi3ID8vV7k=
X-Google-Smtp-Source: ABdhPJwPmrf398xnMvtfm/dKvd1BlAwctzmXR1VlzXIw7uKq1ba2wEmv4f31KHoU7evDmRJvIbM47Q==
X-Received: by 2002:a63:e645:: with SMTP id p5mr1823225pgj.276.1599051960056;
        Wed, 02 Sep 2020 06:06:00 -0700 (PDT)
Received: from localhost.localdomain ([49.236.93.204])
        by smtp.gmail.com with ESMTPSA id t11sm5565946pfe.165.2020.09.02.06.05.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2020 06:05:59 -0700 (PDT)
From:   Leesoo Ahn <dev@ooseel.net>
To:     dev@ooseel.net
Cc:     Stanislaw Gruszka <stf_xl@wp.pl>,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] rt2x00: Use fallthrough pseudo-keyword macro
Date:   Wed,  2 Sep 2020 22:05:06 +0900
Message-Id: <20200902130507.227611-1-dev@ooseel.net>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace all '/* fall through */' comments with the macro[1].

[1]: https://www.kernel.org/doc/html/v5.7/process/deprecated.html?highlight=fallthrough#implicit-switch-case-fall-through

Signed-off-by: Leesoo Ahn <dev@ooseel.net>
---
 .../net/wireless/ralink/rt2x00/rt2400pci.c    |  3 ++-
 .../net/wireless/ralink/rt2x00/rt2500pci.c    |  3 ++-
 .../net/wireless/ralink/rt2x00/rt2800lib.c    | 27 ++++++++++---------
 drivers/net/wireless/ralink/rt2x00/rt61pci.c  |  3 ++-
 4 files changed, 20 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2400pci.c b/drivers/net/wireless/ralink/rt2x00/rt2400pci.c
index c1ac933349d1..2eb06ffd20cd 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2400pci.c
@@ -1291,7 +1291,8 @@ static void rt2400pci_txdone(struct rt2x00_dev *rt2x00dev,
 			break;
 		case 2: /* Failure, excessive retries */
 			__set_bit(TXDONE_EXCESSIVE_RETRY, &txdesc.flags);
-			/* Fall through - this is a failed frame! */
+			/* this is a failed frame! */
+			fallthrough;
 		default: /* Failure */
 			__set_bit(TXDONE_FAILURE, &txdesc.flags);
 		}
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2500pci.c b/drivers/net/wireless/ralink/rt2x00/rt2500pci.c
index 0859adebd860..44c489a8891b 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2500pci.c
@@ -1419,7 +1419,8 @@ static void rt2500pci_txdone(struct rt2x00_dev *rt2x00dev,
 			break;
 		case 2: /* Failure, excessive retries */
 			__set_bit(TXDONE_EXCESSIVE_RETRY, &txdesc.flags);
-			/* Fall through - this is a failed frame! */
+			/* this is a failed frame! */
+			fallthrough;
 		default: /* Failure */
 			__set_bit(TXDONE_FAILURE, &txdesc.flags);
 		}
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
index a779fe771a55..cbba7b3a0e1a 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -928,7 +928,7 @@ static void rt2800_rate_from_status(struct skb_frame_desc *skbdesc,
 	switch (rt2x00_get_field32(status, TX_STA_FIFO_PHYMODE)) {
 	case RATE_MODE_HT_GREENFIELD:
 		flags |= IEEE80211_TX_RC_GREEN_FIELD;
-		/* fall through */
+		fallthrough;
 	case RATE_MODE_HT_MIX:
 		flags |= IEEE80211_TX_RC_MCS;
 		break;
@@ -2037,6 +2037,7 @@ static void rt2800_config_ht_opmode(struct rt2x00_dev *rt2x00dev,
 		 * We decide to protect everything
 		 * -> fall through to mixed mode.
 		 */
+		fallthrough;
 	case IEEE80211_HT_OP_MODE_PROTECTION_NONHT_MIXED:
 		/*
 		 * Legacy STAs are present
@@ -2567,7 +2568,7 @@ static void rt2800_config_channel_rf3052(struct rt2x00_dev *rt2x00dev,
 		switch (rt2x00dev->default_ant.tx_chain_num) {
 		case 1:
 			rt2x00_set_field8(&rfcsr, RFCSR1_TX1_PD, 1);
-			/* fall through */
+			fallthrough;
 		case 2:
 			rt2x00_set_field8(&rfcsr, RFCSR1_TX2_PD, 1);
 			break;
@@ -2576,7 +2577,7 @@ static void rt2800_config_channel_rf3052(struct rt2x00_dev *rt2x00dev,
 		switch (rt2x00dev->default_ant.rx_chain_num) {
 		case 1:
 			rt2x00_set_field8(&rfcsr, RFCSR1_RX1_PD, 1);
-			/* fall through */
+			fallthrough;
 		case 2:
 			rt2x00_set_field8(&rfcsr, RFCSR1_RX2_PD, 1);
 			break;
@@ -4216,14 +4217,14 @@ static void rt2800_config_channel(struct rt2x00_dev *rt2x00dev,
 				   rf->channel > 14);
 		rt2x00_set_field32(&tx_pin, TX_PIN_CFG_PA_PE_G2_EN,
 				   rf->channel <= 14);
-		/* fall-through */
+		fallthrough;
 	case 2:
 		/* Turn on secondary PAs */
 		rt2x00_set_field32(&tx_pin, TX_PIN_CFG_PA_PE_A1_EN,
 				   rf->channel > 14);
 		rt2x00_set_field32(&tx_pin, TX_PIN_CFG_PA_PE_G1_EN,
 				   rf->channel <= 14);
-		/* fall-through */
+		fallthrough;
 	case 1:
 		/* Turn on primary PAs */
 		rt2x00_set_field32(&tx_pin, TX_PIN_CFG_PA_PE_A0_EN,
@@ -4241,12 +4242,12 @@ static void rt2800_config_channel(struct rt2x00_dev *rt2x00dev,
 		/* Turn on tertiary LNAs */
 		rt2x00_set_field32(&tx_pin, TX_PIN_CFG_LNA_PE_A2_EN, 1);
 		rt2x00_set_field32(&tx_pin, TX_PIN_CFG_LNA_PE_G2_EN, 1);
-		/* fall-through */
+		fallthrough;
 	case 2:
 		/* Turn on secondary LNAs */
 		rt2x00_set_field32(&tx_pin, TX_PIN_CFG_LNA_PE_A1_EN, 1);
 		rt2x00_set_field32(&tx_pin, TX_PIN_CFG_LNA_PE_G1_EN, 1);
-		/* fall-through */
+		fallthrough;
 	case 1:
 		/* Turn on primary LNAs */
 		rt2x00_set_field32(&tx_pin, TX_PIN_CFG_LNA_PE_A0_EN, 1);
@@ -5438,10 +5439,10 @@ void rt2800_vco_calibration(struct rt2x00_dev *rt2x00dev)
 		switch (rt2x00dev->default_ant.tx_chain_num) {
 		case 3:
 			rt2x00_set_field32(&tx_pin, TX_PIN_CFG_PA_PE_G2_EN, 1);
-			/* fall through */
+			fallthrough;
 		case 2:
 			rt2x00_set_field32(&tx_pin, TX_PIN_CFG_PA_PE_G1_EN, 1);
-			/* fall through */
+			fallthrough;
 		case 1:
 		default:
 			rt2x00_set_field32(&tx_pin, TX_PIN_CFG_PA_PE_G0_EN, 1);
@@ -5451,10 +5452,10 @@ void rt2800_vco_calibration(struct rt2x00_dev *rt2x00dev)
 		switch (rt2x00dev->default_ant.tx_chain_num) {
 		case 3:
 			rt2x00_set_field32(&tx_pin, TX_PIN_CFG_PA_PE_A2_EN, 1);
-			/* fall through */
+			fallthrough;
 		case 2:
 			rt2x00_set_field32(&tx_pin, TX_PIN_CFG_PA_PE_A1_EN, 1);
-			/* fall through */
+			fallthrough;
 		case 1:
 		default:
 			rt2x00_set_field32(&tx_pin, TX_PIN_CFG_PA_PE_A0_EN, 1);
@@ -10100,10 +10101,10 @@ static int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 	switch (rx_chains) {
 	case 3:
 		spec->ht.mcs.rx_mask[2] = 0xff;
-		/* fall through */
+		fallthrough;
 	case 2:
 		spec->ht.mcs.rx_mask[1] = 0xff;
-		/* fall through */
+		fallthrough;
 	case 1:
 		spec->ht.mcs.rx_mask[0] = 0xff;
 		spec->ht.mcs.rx_mask[4] = 0x1; /* MCS32 */
diff --git a/drivers/net/wireless/ralink/rt2x00/rt61pci.c b/drivers/net/wireless/ralink/rt2x00/rt61pci.c
index eefce76fc99b..16ec523375e2 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt61pci.c
@@ -2130,7 +2130,8 @@ static void rt61pci_txdone(struct rt2x00_dev *rt2x00dev)
 			break;
 		case 6: /* Failure, excessive retries */
 			__set_bit(TXDONE_EXCESSIVE_RETRY, &txdesc.flags);
-			/* Fall through - this is a failed frame! */
+			/* this is a failed frame! */
+			fallthrough;
 		default: /* Failure */
 			__set_bit(TXDONE_FAILURE, &txdesc.flags);
 		}
-- 
2.25.4

