Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB60E24CE32
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 08:48:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727791AbgHUGsK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 02:48:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:47926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726119AbgHUGsI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Aug 2020 02:48:08 -0400
Received: from embeddedor (187-162-31-110.static.axtel.net [187.162.31.110])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5B78720748;
        Fri, 21 Aug 2020 06:48:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597992488;
        bh=TnGIq0rWWRRhRPKScOtrs8fL6SIFwsJTAU40M1xoTzc=;
        h=Date:From:To:Cc:Subject:From;
        b=JOvJxLh1t2CQ4d/xcBnQdC4M/PlcgWRcQbzKImB41SdTEbYbavlIKPe/eCIOHlH3d
         GdxiHWH/fvDeFlou3aAU7ncyo2qcFwpf51JlJZIPPpBj6naLzPWVpSiN7oOa/wcmPB
         PdBLHlbUnvu7QiZF/VdP0pnlhh6ktUMV7lwnuQYU=
Date:   Fri, 21 Aug 2020 01:53:55 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Simon Kelley <simon@thekelleys.org.uk>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: [PATCH][next] atmel: Use fallthrough pseudo-keyword
Message-ID: <20200821065355.GA25808@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace the existing /* fall through */ comments and its variants with
the new pseudo-keyword macro fallthrough[1].

[1] https://www.kernel.org/doc/html/v5.7/process/deprecated.html?highlight=fallthrough#implicit-switch-case-fall-through

Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/net/wireless/atmel/at76c50x-usb.c | 2 +-
 drivers/net/wireless/atmel/atmel.c        | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/atmel/at76c50x-usb.c b/drivers/net/wireless/atmel/at76c50x-usb.c
index a63b5c2f1e17..b760c6682c4f 100644
--- a/drivers/net/wireless/atmel/at76c50x-usb.c
+++ b/drivers/net/wireless/atmel/at76c50x-usb.c
@@ -432,7 +432,7 @@ static int at76_usbdfu_download(struct usb_device *udev, u8 *buf, u32 size,
 
 		case STATE_DFU_DOWNLOAD_IDLE:
 			at76_dbg(DBG_DFU, "DOWNLOAD...");
-			/* fall through */
+			fallthrough;
 		case STATE_DFU_IDLE:
 			at76_dbg(DBG_DFU, "DFU IDLE");
 
diff --git a/drivers/net/wireless/atmel/atmel.c b/drivers/net/wireless/atmel/atmel.c
index d5875836068c..6c97a1af5e8e 100644
--- a/drivers/net/wireless/atmel/atmel.c
+++ b/drivers/net/wireless/atmel/atmel.c
@@ -1227,7 +1227,7 @@ static irqreturn_t service_interrupt(int irq, void *dev_id)
 
 		case ISR_RxFRAMELOST:
 			priv->wstats.discard.misc++;
-			/* fall through */
+			fallthrough;
 		case ISR_RxCOMPLETE:
 			rx_done_irq(priv);
 			break;
-- 
2.27.0

