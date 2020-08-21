Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89CAC24CDCF
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 08:15:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727787AbgHUGPJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 02:15:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:37406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725268AbgHUGPG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Aug 2020 02:15:06 -0400
Received: from embeddedor (187-162-31-110.static.axtel.net [187.162.31.110])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4D07620702;
        Fri, 21 Aug 2020 06:15:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597990505;
        bh=HtZtEqMJWa6v3dxpOCJD+qG/hLS19G82LkSofuiaKCE=;
        h=Date:From:To:Cc:Subject:From;
        b=Cg1UFB2hWRgaLxqJET7zYpuqVCiBC4EDIvlIvizwTJRLITR7lbwgVf8v9E4JMEO5a
         LCANYFbYh/n4r/+OvfTCFObuUveacrjkqpv4CWf2lqKFhtTHONj6kW9wLwwU+CPLFu
         zZlTLgNJs0bIP6EI8cVDYIUsBOyEmkDhTMMo1Z7c=
Date:   Fri, 21 Aug 2020 01:20:52 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Stanislaw Gruszka <stf_xl@wp.pl>,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: [PATCH][next] rt2x00: Use fallthrough pseudo-keyword
Message-ID: <20200821062052.GA8618@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace the existing /* fall through */ comments and its variants with
the new pseudo-keyword macro fallthrough[1]. Also, remove unnecessary
fall-through markings when it is the case.

[1] https://www.kernel.org/doc/html/v5.7/process/deprecated.html?highlight=fallthrough#implicit-switch-case-fall-through

Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 .../net/wireless/ralink/rt2x00/rt2400pci.c    |  2 +-
 .../net/wireless/ralink/rt2x00/rt2500pci.c    |  2 +-
 .../net/wireless/ralink/rt2x00/rt2800lib.c    | 42 +++++++++----------
 .../net/wireless/ralink/rt2x00/rt2800mmio.c   |  1 -
 .../net/wireless/ralink/rt2x00/rt2800usb.c    |  1 -
 drivers/net/wireless/ralink/rt2x00/rt61pci.c  |  3 +-
 drivers/net/wireless/ralink/rt2x00/rt73usb.c  |  1 -
 7 files changed, 24 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2400pci.c b/drivers/net/wireless/ralink/rt2x00/rt2400pci.c
index c1ac933349d1..c8bb378148c3 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2400pci.c
@@ -1291,7 +1291,7 @@ static void rt2400pci_txdone(struct rt2x00_dev *rt2x00dev,
 			break;
 		case 2: /* Failure, excessive retries */
 			__set_bit(TXDONE_EXCESSIVE_RETRY, &txdesc.flags);
-			/* Fall through - this is a failed frame! */
+			fallthrough;	/* this is a failed frame! */
 		default: /* Failure */
 			__set_bit(TXDONE_FAILURE, &txdesc.flags);
 		}
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2500pci.c b/drivers/net/wireless/ralink/rt2x00/rt2500pci.c
index 0859adebd860..2e015c16cd4b 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2500pci.c
@@ -1419,7 +1419,7 @@ static void rt2500pci_txdone(struct rt2x00_dev *rt2x00dev,
 			break;
 		case 2: /* Failure, excessive retries */
 			__set_bit(TXDONE_EXCESSIVE_RETRY, &txdesc.flags);
-			/* Fall through - this is a failed frame! */
+			fallthrough;	/* this is a failed frame! */
 		default: /* Failure */
 			__set_bit(TXDONE_FAILURE, &txdesc.flags);
 		}
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
index a779fe771a55..fed6d21cd6ce 100644
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
@@ -2567,7 +2567,7 @@ static void rt2800_config_channel_rf3052(struct rt2x00_dev *rt2x00dev,
 		switch (rt2x00dev->default_ant.tx_chain_num) {
 		case 1:
 			rt2x00_set_field8(&rfcsr, RFCSR1_TX1_PD, 1);
-			/* fall through */
+			fallthrough;
 		case 2:
 			rt2x00_set_field8(&rfcsr, RFCSR1_TX2_PD, 1);
 			break;
@@ -2576,7 +2576,7 @@ static void rt2800_config_channel_rf3052(struct rt2x00_dev *rt2x00dev,
 		switch (rt2x00dev->default_ant.rx_chain_num) {
 		case 1:
 			rt2x00_set_field8(&rfcsr, RFCSR1_RX1_PD, 1);
-			/* fall through */
+			fallthrough;
 		case 2:
 			rt2x00_set_field8(&rfcsr, RFCSR1_RX2_PD, 1);
 			break;
@@ -2768,10 +2768,10 @@ static void rt2800_config_channel_rf3053(struct rt2x00_dev *rt2x00dev,
 	switch (rt2x00dev->default_ant.tx_chain_num) {
 	case 3:
 		rt2x00_set_field8(&rfcsr, RFCSR1_TX2_PD, 1);
-		/* fallthrough */
+		fallthrough;
 	case 2:
 		rt2x00_set_field8(&rfcsr, RFCSR1_TX1_PD, 1);
-		/* fallthrough */
+		fallthrough;
 	case 1:
 		rt2x00_set_field8(&rfcsr, RFCSR1_TX0_PD, 1);
 		break;
@@ -2780,10 +2780,10 @@ static void rt2800_config_channel_rf3053(struct rt2x00_dev *rt2x00dev,
 	switch (rt2x00dev->default_ant.rx_chain_num) {
 	case 3:
 		rt2x00_set_field8(&rfcsr, RFCSR1_RX2_PD, 1);
-		/* fallthrough */
+		fallthrough;
 	case 2:
 		rt2x00_set_field8(&rfcsr, RFCSR1_RX1_PD, 1);
-		/* fallthrough */
+		fallthrough;
 	case 1:
 		rt2x00_set_field8(&rfcsr, RFCSR1_RX0_PD, 1);
 		break;
@@ -3005,10 +3005,10 @@ static void rt2800_config_channel_rf3853(struct rt2x00_dev *rt2x00dev,
 	switch (rt2x00dev->default_ant.tx_chain_num) {
 	case 3:
 		rt2x00_set_field8(&rfcsr, RFCSR1_TX2_PD, 1);
-		/* fallthrough */
+		fallthrough;
 	case 2:
 		rt2x00_set_field8(&rfcsr, RFCSR1_TX1_PD, 1);
-		/* fallthrough */
+		fallthrough;
 	case 1:
 		rt2x00_set_field8(&rfcsr, RFCSR1_TX0_PD, 1);
 		break;
@@ -3017,10 +3017,10 @@ static void rt2800_config_channel_rf3853(struct rt2x00_dev *rt2x00dev,
 	switch (rt2x00dev->default_ant.rx_chain_num) {
 	case 3:
 		rt2x00_set_field8(&rfcsr, RFCSR1_RX2_PD, 1);
-		/* fallthrough */
+		fallthrough;
 	case 2:
 		rt2x00_set_field8(&rfcsr, RFCSR1_RX1_PD, 1);
-		/* fallthrough */
+		fallthrough;
 	case 1:
 		rt2x00_set_field8(&rfcsr, RFCSR1_RX0_PD, 1);
 		break;
@@ -4216,14 +4216,14 @@ static void rt2800_config_channel(struct rt2x00_dev *rt2x00dev,
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
@@ -4241,12 +4241,12 @@ static void rt2800_config_channel(struct rt2x00_dev *rt2x00dev,
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
@@ -5438,10 +5438,10 @@ void rt2800_vco_calibration(struct rt2x00_dev *rt2x00dev)
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
@@ -5451,10 +5451,10 @@ void rt2800_vco_calibration(struct rt2x00_dev *rt2x00dev)
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
@@ -10100,10 +10100,10 @@ static int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
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
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800mmio.c b/drivers/net/wireless/ralink/rt2x00/rt2800mmio.c
index 110bb391c372..6e7c14757261 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800mmio.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800mmio.c
@@ -593,7 +593,6 @@ void rt2800mmio_queue_init(struct data_queue *queue)
 		break;
 
 	case QID_ATIM:
-		/* fallthrough */
 	default:
 		BUG();
 		break;
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800usb.c b/drivers/net/wireless/ralink/rt2x00/rt2800usb.c
index 4cc64fe481a7..d08b251ec5a2 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800usb.c
@@ -746,7 +746,6 @@ static void rt2800usb_queue_init(struct data_queue *queue)
 		break;
 
 	case QID_ATIM:
-		/* fallthrough */
 	default:
 		BUG();
 		break;
diff --git a/drivers/net/wireless/ralink/rt2x00/rt61pci.c b/drivers/net/wireless/ralink/rt2x00/rt61pci.c
index eefce76fc99b..43c3cdd13710 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt61pci.c
@@ -2130,7 +2130,7 @@ static void rt61pci_txdone(struct rt2x00_dev *rt2x00dev)
 			break;
 		case 6: /* Failure, excessive retries */
 			__set_bit(TXDONE_EXCESSIVE_RETRY, &txdesc.flags);
-			/* Fall through - this is a failed frame! */
+			fallthrough;	/* this is a failed frame! */
 		default: /* Failure */
 			__set_bit(TXDONE_FAILURE, &txdesc.flags);
 		}
@@ -2953,7 +2953,6 @@ static void rt61pci_queue_init(struct data_queue *queue)
 		break;
 
 	case QID_ATIM:
-		/* fallthrough */
 	default:
 		BUG();
 		break;
diff --git a/drivers/net/wireless/ralink/rt2x00/rt73usb.c b/drivers/net/wireless/ralink/rt2x00/rt73usb.c
index e908c303b677..e69793773d87 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt73usb.c
@@ -2373,7 +2373,6 @@ static void rt73usb_queue_init(struct data_queue *queue)
 		break;
 
 	case QID_ATIM:
-		/* fallthrough */
 	default:
 		BUG();
 		break;
-- 
2.27.0

