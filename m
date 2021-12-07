Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AC6846B8E3
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 11:25:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235098AbhLGK20 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 05:28:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235079AbhLGK2Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 05:28:24 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE74BC061354
        for <netdev@vger.kernel.org>; Tue,  7 Dec 2021 02:24:54 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1muXeX-0003MZ-1u
        for netdev@vger.kernel.org; Tue, 07 Dec 2021 11:24:53 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id D37636BE8E7
        for <netdev@vger.kernel.org>; Tue,  7 Dec 2021 10:24:46 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id A7D146BE8AD;
        Tue,  7 Dec 2021 10:24:43 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 677c6507;
        Tue, 7 Dec 2021 10:24:27 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        stable@vger.kernel.org,
        Jarkko Nikula <jarkko.nikula@linux.intel.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net 6/9] can: m_can: pci: fix incorrect reference clock rate
Date:   Tue,  7 Dec 2021 11:24:17 +0100
Message-Id: <20211207102420.120131-7-mkl@pengutronix.de>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211207102420.120131-1-mkl@pengutronix.de>
References: <20211207102420.120131-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>

When testing the CAN controller on our Ekhart Lake hardware, we
determined that all communication was running with twice the configured
bitrate. Changing the reference clock rate from 100MHz to 200MHz fixed
this. Intel's support has confirmed to us that 200MHz is indeed the
correct clock rate.

Fixes: cab7ffc0324f ("can: m_can: add PCI glue driver for Intel Elkhart Lake")
Link: https://lore.kernel.org/all/c9cf3995f45c363e432b3ae8eb1275e54f009fc8.1636967198.git.matthias.schiffer@ew.tq-group.com
Cc: stable@vger.kernel.org
Signed-off-by: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
Acked-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
Reviewed-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/m_can/m_can_pci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/can/m_can/m_can_pci.c b/drivers/net/can/m_can/m_can_pci.c
index d72c294ac4d3..8f184a852a0a 100644
--- a/drivers/net/can/m_can/m_can_pci.c
+++ b/drivers/net/can/m_can/m_can_pci.c
@@ -18,7 +18,7 @@
 
 #define M_CAN_PCI_MMIO_BAR		0
 
-#define M_CAN_CLOCK_FREQ_EHL		100000000
+#define M_CAN_CLOCK_FREQ_EHL		200000000
 #define CTL_CSR_INT_CTL_OFFSET		0x508
 
 struct m_can_pci_priv {
-- 
2.33.0


