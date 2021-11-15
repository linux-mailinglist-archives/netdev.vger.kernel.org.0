Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6619545011B
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 10:21:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236975AbhKOJYF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 04:24:05 -0500
Received: from mx1.tq-group.com ([93.104.207.81]:45337 "EHLO mx1.tq-group.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236638AbhKOJX6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Nov 2021 04:23:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1636968063; x=1668504063;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=7+q5wOUq3ntaAvVRKhGKpGVjQieDwZAsdV21wJvDGe8=;
  b=jV/RPWlW+DobyRIOZ+U6VaqCnybBOAHBC31ZY1peJ5ZCg5b0ldTQaxVk
   YkEOc8f9z+K8EW6G3Qp5aeatoz4yK0mbSNaMqPzcdcT0EpeaCGCqwcrZQ
   UuqT0kvJQ/tuK4CKPiPAWk9qtfQYcWtSCK3cV4VS1i7L+4DDXTLGljMdC
   sOUcM1by/Uej/eZavcJFr+sqr+7mpXlk/miSxRbV8BJCugwjVhl/8Oi0M
   lT9kDYgSNJg4iHbBrlz+bM0c0ubziH4ahC+lYrOxrrOHvJz5InR/JGpaN
   CUqXDQ7RlqVuxHH3842eFfuSENI/M+z0Br6D7vxPjj+xLmFL+gKP0Wgin
   w==;
X-IronPort-AV: E=Sophos;i="5.87,236,1631570400"; 
   d="scan'208";a="20459398"
Received: from unknown (HELO tq-pgp-pr1.tq-net.de) ([192.168.6.15])
  by mx1-pgp.tq-group.com with ESMTP; 15 Nov 2021 10:20:19 +0100
Received: from mx1.tq-group.com ([192.168.6.7])
  by tq-pgp-pr1.tq-net.de (PGP Universal service);
  Mon, 15 Nov 2021 10:20:19 +0100
X-PGP-Universal: processed;
        by tq-pgp-pr1.tq-net.de on Mon, 15 Nov 2021 10:20:19 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1636968019; x=1668504019;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=7+q5wOUq3ntaAvVRKhGKpGVjQieDwZAsdV21wJvDGe8=;
  b=me7vdP7UgpW0m6fTZt9K17MMH0JXBBo5v34HGQ9nhmTbe5Il8YLpoaj8
   OAOV2xuoe1DeQ/Y6jdhambzQG8WEOJWDvHSxJua2YihV40gAgr9tPjwui
   LAxM/LhMluBIjyR2TTmAoRjO/e9Fju5PTREXmmryrPSan72sTUX0zKicM
   9T7lYEMZOekB2/IkvzakDMTbRWHCXViLYQ+KbAKU9kON1DGXZeCDXRmaY
   kv4jN9gIp6UyK1DNajXFYiIBjNBfTwu6HO8Qx62vIi1UZVBkRXjCjGppW
   ypGRnr4ZyQRRSOOGu8ViiEQBivL2J9c9XL0tugyWprQSX4coyHRaVKNjY
   A==;
X-IronPort-AV: E=Sophos;i="5.87,236,1631570400"; 
   d="scan'208";a="20459397"
Received: from vtuxmail01.tq-net.de ([10.115.0.20])
  by mx1.tq-group.com with ESMTP; 15 Nov 2021 10:20:19 +0100
Received: from schifferm-ubuntu4.tq-net.de (schifferm-ubuntu4.tq-net.de [10.121.48.12])
        by vtuxmail01.tq-net.de (Postfix) with ESMTPA id 8B74428007F;
        Mon, 15 Nov 2021 10:20:19 +0100 (CET)
From:   Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
To:     Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Felipe Balbi (Intel)" <balbi@kernel.org>,
        Jarkko Nikula <jarkko.nikula@linux.intel.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
Subject: [PATCH net 4/4] can: m_can: pci: use custom bit timings for Elkhart Lake
Date:   Mon, 15 Nov 2021 10:18:52 +0100
Message-Id: <9eba5d7c05a48ead4024ffa6e5926f191d8c6b38.1636967198.git.matthias.schiffer@ew.tq-group.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1636967198.git.matthias.schiffer@ew.tq-group.com>
References: <cover.1636967198.git.matthias.schiffer@ew.tq-group.com>
In-Reply-To: <cover.1636967198.git.matthias.schiffer@ew.tq-group.com>
References: <cover.1636967198.git.matthias.schiffer@ew.tq-group.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The relevant datasheet [1] specifies nonstandard limits for the bit timing
parameters. While it is unclear what the exact effect of violating these
limits is, it seems like a good idea to adhere to the documentation.

[1] Intel Atom® x6000E Series, and Intel® Pentium® and Celeron® N and J
    Series Processors for IoT Applications Datasheet,
    Volume 2 (Book 3 of 3), July 2021, Revision 001

Fixes: cab7ffc0324f ("can: m_can: add PCI glue driver for Intel Elkhart Lake")
Signed-off-by: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
---
 drivers/net/can/m_can/m_can_pci.c | 48 ++++++++++++++++++++++++++++---
 1 file changed, 44 insertions(+), 4 deletions(-)

diff --git a/drivers/net/can/m_can/m_can_pci.c b/drivers/net/can/m_can/m_can_pci.c
index d3c030a13cbe..8bbbaa264f0d 100644
--- a/drivers/net/can/m_can/m_can_pci.c
+++ b/drivers/net/can/m_can/m_can_pci.c
@@ -18,9 +18,14 @@
 
 #define M_CAN_PCI_MMIO_BAR		0
 
-#define M_CAN_CLOCK_FREQ_EHL		200000000
 #define CTL_CSR_INT_CTL_OFFSET		0x508
 
+struct m_can_pci_config {
+	const struct can_bittiming_const *bit_timing;
+	const struct can_bittiming_const *data_timing;
+	unsigned int clock_freq;
+};
+
 struct m_can_pci_priv {
 	struct m_can_classdev cdev;
 
@@ -74,9 +79,40 @@ static struct m_can_ops m_can_pci_ops = {
 	.read_fifo = iomap_read_fifo,
 };
 
+static const struct can_bittiming_const m_can_bittiming_const_ehl = {
+	.name = KBUILD_MODNAME,
+	.tseg1_min = 2,		/* Time segment 1 = prop_seg + phase_seg1 */
+	.tseg1_max = 64,
+	.tseg2_min = 1,		/* Time segment 2 = phase_seg2 */
+	.tseg2_max = 128,
+	.sjw_max = 128,
+	.brp_min = 1,
+	.brp_max = 512,
+	.brp_inc = 1,
+};
+
+static const struct can_bittiming_const m_can_data_bittiming_const_ehl = {
+	.name = KBUILD_MODNAME,
+	.tseg1_min = 2,		/* Time segment 1 = prop_seg + phase_seg1 */
+	.tseg1_max = 16,
+	.tseg2_min = 1,		/* Time segment 2 = phase_seg2 */
+	.tseg2_max = 8,
+	.sjw_max = 4,
+	.brp_min = 1,
+	.brp_max = 32,
+	.brp_inc = 1,
+};
+
+static const struct m_can_pci_config m_can_pci_ehl = {
+	.bit_timing = &m_can_bittiming_const_ehl,
+	.data_timing = &m_can_data_bittiming_const_ehl,
+	.clock_freq = 200000000,
+};
+
 static int m_can_pci_probe(struct pci_dev *pci, const struct pci_device_id *id)
 {
 	struct device *dev = &pci->dev;
+	const struct m_can_pci_config *cfg;
 	struct m_can_classdev *mcan_class;
 	struct m_can_pci_priv *priv;
 	void __iomem *base;
@@ -104,6 +140,8 @@ static int m_can_pci_probe(struct pci_dev *pci, const struct pci_device_id *id)
 	if (!mcan_class)
 		return -ENOMEM;
 
+	cfg = (const struct m_can_pci_config *)id->driver_data;
+
 	priv = cdev_to_priv(mcan_class);
 
 	priv->base = base;
@@ -115,7 +153,9 @@ static int m_can_pci_probe(struct pci_dev *pci, const struct pci_device_id *id)
 	mcan_class->dev = &pci->dev;
 	mcan_class->net->irq = pci_irq_vector(pci, 0);
 	mcan_class->pm_clock_support = 1;
-	mcan_class->can.clock.freq = id->driver_data;
+	mcan_class->bit_timing = cfg->bit_timing;
+	mcan_class->data_timing = cfg->data_timing;
+	mcan_class->can.clock.freq = cfg->clock_freq;
 	mcan_class->ops = &m_can_pci_ops;
 
 	pci_set_drvdata(pci, mcan_class);
@@ -168,8 +208,8 @@ static SIMPLE_DEV_PM_OPS(m_can_pci_pm_ops,
 			 m_can_pci_suspend, m_can_pci_resume);
 
 static const struct pci_device_id m_can_pci_id_table[] = {
-	{ PCI_VDEVICE(INTEL, 0x4bc1), M_CAN_CLOCK_FREQ_EHL, },
-	{ PCI_VDEVICE(INTEL, 0x4bc2), M_CAN_CLOCK_FREQ_EHL, },
+	{ PCI_VDEVICE(INTEL, 0x4bc1), (kernel_ulong_t)&m_can_pci_ehl, },
+	{ PCI_VDEVICE(INTEL, 0x4bc2), (kernel_ulong_t)&m_can_pci_ehl, },
 	{  }	/* Terminating Entry */
 };
 MODULE_DEVICE_TABLE(pci, m_can_pci_id_table);
-- 
2.17.1

