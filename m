Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFB1347A6CB
	for <lists+netdev@lfdr.de>; Mon, 20 Dec 2021 10:23:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231796AbhLTJXS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 04:23:18 -0500
Received: from mx1.tq-group.com ([93.104.207.81]:58435 "EHLO mx1.tq-group.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231598AbhLTJXP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Dec 2021 04:23:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1639992195; x=1671528195;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wl9Rqy+TKAE8RR3C1C5wy5Vb2TL1BeN8BoibLPNcVMA=;
  b=MgOYIBj69eDSgKqU1/ofDYfSnZti9ca7Wb0EMycFS/Xvgq261WYa9WMk
   ZviVivaPl39h/07G366OH7Y2tJh8vhs+aZjaaS/i8yzp1zfU3LJmBeQ/V
   ogKEbsaDirmh57MyfbOGg01H0xb696E29/w0UY1RJ3UIoG0fvzeJg4Hh+
   j3ag+S8AxS23wQtkdezfVzxHTGFSt1CqVWKgYK1MJCPsr2IPAyhQBKtRL
   6xRw5epGuKD3Akkj5otvPmfq0e1olYFg4CLt91Zz7q79ojoLmcO6dT31h
   D2HAWj3+krxDSRse/JNiNGTCZ4H5WD1bjfXHHj3dz6khZCh6NaBKEOef3
   g==;
X-IronPort-AV: E=Sophos;i="5.88,220,1635199200"; 
   d="scan'208";a="21148425"
Received: from unknown (HELO tq-pgp-pr1.tq-net.de) ([192.168.6.15])
  by mx1-pgp.tq-group.com with ESMTP; 20 Dec 2021 10:23:11 +0100
Received: from mx1.tq-group.com ([192.168.6.7])
  by tq-pgp-pr1.tq-net.de (PGP Universal service);
  Mon, 20 Dec 2021 10:23:11 +0100
X-PGP-Universal: processed;
        by tq-pgp-pr1.tq-net.de on Mon, 20 Dec 2021 10:23:11 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1639992191; x=1671528191;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wl9Rqy+TKAE8RR3C1C5wy5Vb2TL1BeN8BoibLPNcVMA=;
  b=OsbcBDu9rY2fsYjDG1598JGNeUnIs06caT3D09pTVBqMGnGa2kSZftcT
   HTkJxf/MDz/57uZC+TBElD9Qvpb3U5iF8taqqttwe9BpnlhAkViOGTGt3
   MjKXL11OqYtH0tZXKRFzIoBmFa/XwEb0JbHrgbzkh/EVnhkvwpC/8ansc
   RH1WyBd0D9z+1CQpMiaOalu4EWSxe7nZn6eZXG45v33HmxWhxhnhxpDiB
   cRZgxoaDyvSwmO5cLtWANXFmjo42CClzjp8JHdHS5ekb6DjFQhkG2UXYl
   lUA0W2lyCt6u3MpEHuQiRdALPO6MAFKhZdCfCLCOYxng+Nkmk4ab37YOa
   Q==;
X-IronPort-AV: E=Sophos;i="5.88,220,1635199200"; 
   d="scan'208";a="21148424"
Received: from vtuxmail01.tq-net.de ([10.115.0.20])
  by mx1.tq-group.com with ESMTP; 20 Dec 2021 10:23:11 +0100
Received: from localhost.localdomain (SCHIFFERM-M2.tq-net.de [10.121.201.15])
        by vtuxmail01.tq-net.de (Postfix) with ESMTPA id 5BCC4280078;
        Mon, 20 Dec 2021 10:23:11 +0100 (CET)
From:   Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
To:     stable@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-can@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        davem@davemloft.net, kuba@kernel.org,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
Subject: [PATCH 5.15 3/3] can: m_can: pci: use custom bit timings for Elkhart Lake
Date:   Mon, 20 Dec 2021 10:22:17 +0100
Message-Id: <84123eb125bcd05458f2da0280536cff1a5ca284.1639990483.git.matthias.schiffer@ew.tq-group.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1639990483.git.matthias.schiffer@ew.tq-group.com>
References: <cover.1639990483.git.matthias.schiffer@ew.tq-group.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

commit ea4c1787685dbf9842046f05b6390b6901ee6ba2 upstream.

The relevant datasheet [1] specifies nonstandard limits for the bit timing
parameters. While it is unclear what the exact effect of violating these
limits is, it seems like a good idea to adhere to the documentation.

[1] Intel Atom® x6000E Series, and Intel® Pentium® and Celeron® N and J
    Series Processors for IoT Applications Datasheet,
    Volume 2 (Book 3 of 3), July 2021, Revision 001

Fixes: cab7ffc0324f ("can: m_can: add PCI glue driver for Intel Elkhart Lake")
Link: https://lore.kernel.org/all/9eba5d7c05a48ead4024ffa6e5926f191d8c6b38.1636967198.git.matthias.schiffer@ew.tq-group.com
Signed-off-by: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/m_can/m_can_pci.c | 48 ++++++++++++++++++++++++++++---
 1 file changed, 44 insertions(+), 4 deletions(-)

diff --git a/drivers/net/can/m_can/m_can_pci.c b/drivers/net/can/m_can/m_can_pci.c
index 8f184a852a0a..b56a54d6c5a9 100644
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
 
@@ -84,9 +89,40 @@ static struct m_can_ops m_can_pci_ops = {
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
@@ -114,6 +150,8 @@ static int m_can_pci_probe(struct pci_dev *pci, const struct pci_device_id *id)
 	if (!mcan_class)
 		return -ENOMEM;
 
+	cfg = (const struct m_can_pci_config *)id->driver_data;
+
 	priv = cdev_to_priv(mcan_class);
 
 	priv->base = base;
@@ -125,7 +163,9 @@ static int m_can_pci_probe(struct pci_dev *pci, const struct pci_device_id *id)
 	mcan_class->dev = &pci->dev;
 	mcan_class->net->irq = pci_irq_vector(pci, 0);
 	mcan_class->pm_clock_support = 1;
-	mcan_class->can.clock.freq = id->driver_data;
+	mcan_class->bit_timing = cfg->bit_timing;
+	mcan_class->data_timing = cfg->data_timing;
+	mcan_class->can.clock.freq = cfg->clock_freq;
 	mcan_class->ops = &m_can_pci_ops;
 
 	pci_set_drvdata(pci, mcan_class);
@@ -178,8 +218,8 @@ static SIMPLE_DEV_PM_OPS(m_can_pci_pm_ops,
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
2.25.1

