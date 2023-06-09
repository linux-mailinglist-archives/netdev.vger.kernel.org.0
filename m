Return-Path: <netdev+bounces-9525-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C8C587299D9
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 14:24:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 362A428190B
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 12:24:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF443168B3;
	Fri,  9 Jun 2023 12:23:34 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB5B21643A
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 12:23:34 +0000 (UTC)
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 475014480;
	Fri,  9 Jun 2023 05:22:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686313372; x=1717849372;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5WPrS52zb0quZ22nsjjd4QojVrNAjJlh1Yv6DdS8TyU=;
  b=fEryJd5D0XdKlkw1P5iE3H4KTU6H8TMwM1niEna6Sp1xHte1NHW2rOBR
   ScFWAuKrfB/E1eHhwx3kpH/eYSYKnKYU8+0VGjxAyskAegpylwI02btJs
   fMQ0FkBTfkpYn86WGuskVDJAR2IbvWyT3Mnmj5hR6PqtQZzGdKCFzLm+S
   H95JKKxmLh0gijU/s5jE2LEBloezWDgcCLClhMSXlMCdltAniotNeQmfM
   dYuKkl4AoEuUNXnZVZXXKD/tMm9JIhap9efP9FbAhMKLnC5msIA6LdS/p
   J6TORSijCeRxXu0aPMPMDw6sqQH9US2S+jSOywjl2vAi+foJNdXUXdt7t
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10735"; a="337220415"
X-IronPort-AV: E=Sophos;i="6.00,229,1681196400"; 
   d="scan'208";a="337220415"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2023 05:22:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10735"; a="710348814"
X-IronPort-AV: E=Sophos;i="6.00,229,1681196400"; 
   d="scan'208";a="710348814"
Received: from amlin-018-114.igk.intel.com ([10.102.18.114])
  by orsmga002.jf.intel.com with ESMTP; 09 Jun 2023 05:22:35 -0700
From: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
To: kuba@kernel.org,
	jiri@resnulli.us,
	arkadiusz.kubalewski@intel.com,
	vadfed@meta.com,
	jonathan.lemon@gmail.com,
	pabeni@redhat.com
Cc: corbet@lwn.net,
	davem@davemloft.net,
	edumazet@google.com,
	vadfed@fb.com,
	jesse.brandeburg@intel.com,
	anthony.l.nguyen@intel.com,
	saeedm@nvidia.com,
	leon@kernel.org,
	richardcochran@gmail.com,
	sj@kernel.org,
	javierm@redhat.com,
	ricardo.canuelo@collabora.com,
	mst@redhat.com,
	tzimmermann@suse.de,
	michal.michalik@intel.com,
	gregkh@linuxfoundation.org,
	jacek.lawrynowicz@linux.intel.com,
	airlied@redhat.com,
	ogabbay@kernel.org,
	arnd@arndb.de,
	nipun.gupta@amd.com,
	axboe@kernel.dk,
	linux@zary.sk,
	masahiroy@kernel.org,
	benjamin.tissoires@redhat.com,
	geert+renesas@glider.be,
	milena.olech@intel.com,
	kuniyu@amazon.com,
	liuhangbin@gmail.com,
	hkallweit1@gmail.com,
	andy.ren@getcruise.com,
	razor@blackwall.org,
	idosch@nvidia.com,
	lucien.xin@gmail.com,
	nicolas.dichtel@6wind.com,
	phil@nwl.cc,
	claudiajkang@gmail.com,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org,
	intel-wired-lan@lists.osuosl.org,
	linux-rdma@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	poros@redhat.com,
	mschmidt@redhat.com,
	linux-clk@vger.kernel.org,
	vadim.fedorenko@linux.dev
Subject: [RFC PATCH v8 09/10] ptp_ocp: implement DPLL ops
Date: Fri,  9 Jun 2023 14:18:52 +0200
Message-Id: <20230609121853.3607724-10-arkadiusz.kubalewski@intel.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20230609121853.3607724-1-arkadiusz.kubalewski@intel.com>
References: <20230609121853.3607724-1-arkadiusz.kubalewski@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Vadim Fedorenko <vadim.fedorenko@linux.dev>

Implement basic DPLL operations in ptp_ocp driver as the
simplest example of using new subsystem.

Signed-off-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Signed-off-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
---
 drivers/ptp/Kconfig   |   1 +
 drivers/ptp/ptp_ocp.c | 329 +++++++++++++++++++++++++++++++++++-------
 2 files changed, 278 insertions(+), 52 deletions(-)

diff --git a/drivers/ptp/Kconfig b/drivers/ptp/Kconfig
index b00201d81313..e3575c2e34dc 100644
--- a/drivers/ptp/Kconfig
+++ b/drivers/ptp/Kconfig
@@ -177,6 +177,7 @@ config PTP_1588_CLOCK_OCP
 	depends on COMMON_CLK
 	select NET_DEVLINK
 	select CRC16
+	select DPLL
 	help
 	  This driver adds support for an OpenCompute time card.
 
diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
index ab8cab4d1560..40a1ab7053d4 100644
--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -23,6 +23,7 @@
 #include <linux/mtd/mtd.h>
 #include <linux/nvmem-consumer.h>
 #include <linux/crc16.h>
+#include <linux/dpll.h>
 
 #define PCI_VENDOR_ID_FACEBOOK			0x1d9b
 #define PCI_DEVICE_ID_FACEBOOK_TIMECARD		0x0400
@@ -260,12 +261,21 @@ enum ptp_ocp_sma_mode {
 	SMA_MODE_OUT,
 };
 
+static struct dpll_pin_frequency ptp_ocp_sma_freq[] = {
+	DPLL_PIN_FREQUENCY_1PPS,
+	DPLL_PIN_FREQUENCY_10MHZ,
+	DPLL_PIN_FREQUENCY_IRIG_B,
+	DPLL_PIN_FREQUENCY_DCF77,
+};
+
 struct ptp_ocp_sma_connector {
 	enum	ptp_ocp_sma_mode mode;
 	bool	fixed_fcn;
 	bool	fixed_dir;
 	bool	disabled;
 	u8	default_fcn;
+	struct dpll_pin		   *dpll_pin;
+	struct dpll_pin_properties dpll_prop;
 };
 
 struct ocp_attr_group {
@@ -294,6 +304,7 @@ struct ptp_ocp_serial_port {
 
 #define OCP_BOARD_ID_LEN		13
 #define OCP_SERIAL_LEN			6
+#define OCP_SMA_NUM			4
 
 struct ptp_ocp {
 	struct pci_dev		*pdev;
@@ -350,8 +361,9 @@ struct ptp_ocp {
 	u32			ts_window_adjust;
 	u64			fw_cap;
 	struct ptp_ocp_signal	signal[4];
-	struct ptp_ocp_sma_connector sma[4];
+	struct ptp_ocp_sma_connector sma[OCP_SMA_NUM];
 	const struct ocp_sma_op *sma_op;
+	struct dpll_device *dpll;
 };
 
 #define OCP_REQ_TIMESTAMP	BIT(0)
@@ -835,6 +847,7 @@ static DEFINE_IDR(ptp_ocp_idr);
 struct ocp_selector {
 	const char *name;
 	int value;
+	u64 frequency;
 };
 
 static const struct ocp_selector ptp_ocp_clock[] = {
@@ -855,31 +868,31 @@ static const struct ocp_selector ptp_ocp_clock[] = {
 #define SMA_SELECT_MASK		GENMASK(14, 0)
 
 static const struct ocp_selector ptp_ocp_sma_in[] = {
-	{ .name = "10Mhz",	.value = 0x0000 },
-	{ .name = "PPS1",	.value = 0x0001 },
-	{ .name = "PPS2",	.value = 0x0002 },
-	{ .name = "TS1",	.value = 0x0004 },
-	{ .name = "TS2",	.value = 0x0008 },
-	{ .name = "IRIG",	.value = 0x0010 },
-	{ .name = "DCF",	.value = 0x0020 },
-	{ .name = "TS3",	.value = 0x0040 },
-	{ .name = "TS4",	.value = 0x0080 },
-	{ .name = "FREQ1",	.value = 0x0100 },
-	{ .name = "FREQ2",	.value = 0x0200 },
-	{ .name = "FREQ3",	.value = 0x0400 },
-	{ .name = "FREQ4",	.value = 0x0800 },
-	{ .name = "None",	.value = SMA_DISABLE },
+	{ .name = "10Mhz",  .value = 0x0000,      .frequency = 10000000 },
+	{ .name = "PPS1",   .value = 0x0001,      .frequency = 1 },
+	{ .name = "PPS2",   .value = 0x0002,      .frequency = 1 },
+	{ .name = "TS1",    .value = 0x0004,      .frequency = 0 },
+	{ .name = "TS2",    .value = 0x0008,      .frequency = 0 },
+	{ .name = "IRIG",   .value = 0x0010,      .frequency = 10000 },
+	{ .name = "DCF",    .value = 0x0020,      .frequency = 77500 },
+	{ .name = "TS3",    .value = 0x0040,      .frequency = 0 },
+	{ .name = "TS4",    .value = 0x0080,      .frequency = 0 },
+	{ .name = "FREQ1",  .value = 0x0100,      .frequency = 0 },
+	{ .name = "FREQ2",  .value = 0x0200,      .frequency = 0 },
+	{ .name = "FREQ3",  .value = 0x0400,      .frequency = 0 },
+	{ .name = "FREQ4",  .value = 0x0800,      .frequency = 0 },
+	{ .name = "None",   .value = SMA_DISABLE, .frequency = 0 },
 	{ }
 };
 
 static const struct ocp_selector ptp_ocp_sma_out[] = {
-	{ .name = "10Mhz",	.value = 0x0000 },
-	{ .name = "PHC",	.value = 0x0001 },
-	{ .name = "MAC",	.value = 0x0002 },
-	{ .name = "GNSS1",	.value = 0x0004 },
-	{ .name = "GNSS2",	.value = 0x0008 },
-	{ .name = "IRIG",	.value = 0x0010 },
-	{ .name = "DCF",	.value = 0x0020 },
+	{ .name = "10Mhz",	.value = 0x0000,  .frequency = 10000000 },
+	{ .name = "PHC",	.value = 0x0001,  .frequency = 1 },
+	{ .name = "MAC",	.value = 0x0002,  .frequency = 1 },
+	{ .name = "GNSS1",	.value = 0x0004,  .frequency = 1 },
+	{ .name = "GNSS2",	.value = 0x0008,  .frequency = 1 },
+	{ .name = "IRIG",	.value = 0x0010,  .frequency = 10000 },
+	{ .name = "DCF",	.value = 0x0020,  .frequency = 77000 },
 	{ .name = "GEN1",	.value = 0x0040 },
 	{ .name = "GEN2",	.value = 0x0080 },
 	{ .name = "GEN3",	.value = 0x0100 },
@@ -890,15 +903,15 @@ static const struct ocp_selector ptp_ocp_sma_out[] = {
 };
 
 static const struct ocp_selector ptp_ocp_art_sma_in[] = {
-	{ .name = "PPS1",	.value = 0x0001 },
-	{ .name = "10Mhz",	.value = 0x0008 },
+	{ .name = "PPS1",	.value = 0x0001,  .frequency = 1 },
+	{ .name = "10Mhz",	.value = 0x0008,  .frequency = 1000000 },
 	{ }
 };
 
 static const struct ocp_selector ptp_ocp_art_sma_out[] = {
-	{ .name = "PHC",	.value = 0x0002 },
-	{ .name = "GNSS",	.value = 0x0004 },
-	{ .name = "10Mhz",	.value = 0x0010 },
+	{ .name = "PHC",	.value = 0x0002,  .frequency = 1 },
+	{ .name = "GNSS",	.value = 0x0004,  .frequency = 1 },
+	{ .name = "10Mhz",	.value = 0x0010,  .frequency = 10000000 },
 	{ }
 };
 
@@ -2282,22 +2295,35 @@ ptp_ocp_sma_fb_set_inputs(struct ptp_ocp *bp, int sma_nr, u32 val)
 static void
 ptp_ocp_sma_fb_init(struct ptp_ocp *bp)
 {
+	struct dpll_pin_properties prop = {
+		.board_label = NULL,
+		.type = DPLL_PIN_TYPE_EXT,
+		.capabilities = DPLL_PIN_CAPS_DIRECTION_CAN_CHANGE,
+		.freq_supported_num = ARRAY_SIZE(ptp_ocp_sma_freq),
+		.freq_supported = ptp_ocp_sma_freq,
+
+	};
 	u32 reg;
 	int i;
 
 	/* defaults */
+	for (i = 0; i < OCP_SMA_NUM; i++) {
+		bp->sma[i].default_fcn = i & 1;
+		bp->sma[i].dpll_prop = prop;
+		bp->sma[i].dpll_prop.board_label =
+			bp->ptp_info.pin_config[i].name;
+	}
 	bp->sma[0].mode = SMA_MODE_IN;
 	bp->sma[1].mode = SMA_MODE_IN;
 	bp->sma[2].mode = SMA_MODE_OUT;
 	bp->sma[3].mode = SMA_MODE_OUT;
-	for (i = 0; i < 4; i++)
-		bp->sma[i].default_fcn = i & 1;
-
 	/* If no SMA1 map, the pin functions and directions are fixed. */
 	if (!bp->sma_map1) {
-		for (i = 0; i < 4; i++) {
+		for (i = 0; i < OCP_SMA_NUM; i++) {
 			bp->sma[i].fixed_fcn = true;
 			bp->sma[i].fixed_dir = true;
+			bp->sma[1].dpll_prop.capabilities &=
+				~DPLL_PIN_CAPS_DIRECTION_CAN_CHANGE;
 		}
 		return;
 	}
@@ -2307,7 +2333,7 @@ ptp_ocp_sma_fb_init(struct ptp_ocp *bp)
 	 */
 	reg = ioread32(&bp->sma_map2->gpio2);
 	if (reg == 0xffffffff) {
-		for (i = 0; i < 4; i++)
+		for (i = 0; i < OCP_SMA_NUM; i++)
 			bp->sma[i].fixed_dir = true;
 	} else {
 		reg = ioread32(&bp->sma_map1->gpio1);
@@ -2329,7 +2355,7 @@ static const struct ocp_sma_op ocp_fb_sma_op = {
 };
 
 static int
-ptp_ocp_fb_set_pins(struct ptp_ocp *bp)
+ptp_ocp_set_pins(struct ptp_ocp *bp)
 {
 	struct ptp_pin_desc *config;
 	int i;
@@ -2396,16 +2422,16 @@ ptp_ocp_fb_board_init(struct ptp_ocp *bp, struct ocp_resource *r)
 
 	ptp_ocp_tod_init(bp);
 	ptp_ocp_nmea_out_init(bp);
-	ptp_ocp_sma_init(bp);
 	ptp_ocp_signal_init(bp);
 
 	err = ptp_ocp_attr_group_add(bp, fb_timecard_groups);
 	if (err)
 		return err;
 
-	err = ptp_ocp_fb_set_pins(bp);
+	err = ptp_ocp_set_pins(bp);
 	if (err)
 		return err;
+	ptp_ocp_sma_init(bp);
 
 	return ptp_ocp_init_clock(bp);
 }
@@ -2445,6 +2471,14 @@ ptp_ocp_register_resources(struct ptp_ocp *bp, kernel_ulong_t driver_data)
 static void
 ptp_ocp_art_sma_init(struct ptp_ocp *bp)
 {
+	struct dpll_pin_properties prop = {
+		.board_label = NULL,
+		.type = DPLL_PIN_TYPE_EXT,
+		.capabilities = 0,
+		.freq_supported_num = ARRAY_SIZE(ptp_ocp_sma_freq),
+		.freq_supported = ptp_ocp_sma_freq,
+
+	};
 	u32 reg;
 	int i;
 
@@ -2459,16 +2493,17 @@ ptp_ocp_art_sma_init(struct ptp_ocp *bp)
 	bp->sma[2].default_fcn = 0x10;	/* OUT: 10Mhz */
 	bp->sma[3].default_fcn = 0x02;	/* OUT: PHC */
 
-	/* If no SMA map, the pin functions and directions are fixed. */
-	if (!bp->art_sma) {
-		for (i = 0; i < 4; i++) {
+
+	for (i = 0; i < OCP_SMA_NUM; i++) {
+		/* If no SMA map, the pin functions and directions are fixed. */
+		bp->sma[i].dpll_prop = prop;
+		bp->sma[i].dpll_prop.board_label =
+			bp->ptp_info.pin_config[i].name;
+		if (!bp->art_sma) {
 			bp->sma[i].fixed_fcn = true;
 			bp->sma[i].fixed_dir = true;
+			continue;
 		}
-		return;
-	}
-
-	for (i = 0; i < 4; i++) {
 		reg = ioread32(&bp->art_sma->map[i].gpio);
 
 		switch (reg & 0xff) {
@@ -2479,9 +2514,13 @@ ptp_ocp_art_sma_init(struct ptp_ocp *bp)
 		case 1:
 		case 8:
 			bp->sma[i].mode = SMA_MODE_IN;
+			bp->sma[i].dpll_prop.capabilities =
+				DPLL_PIN_CAPS_DIRECTION_CAN_CHANGE;
 			break;
 		default:
 			bp->sma[i].mode = SMA_MODE_OUT;
+			bp->sma[i].dpll_prop.capabilities =
+				DPLL_PIN_CAPS_DIRECTION_CAN_CHANGE;
 			break;
 		}
 	}
@@ -2548,6 +2587,9 @@ ptp_ocp_art_board_init(struct ptp_ocp *bp, struct ocp_resource *r)
 	/* Enable MAC serial port during initialisation */
 	iowrite32(1, &bp->board_config->mro50_serial_activate);
 
+	err = ptp_ocp_set_pins(bp);
+	if (err)
+		return err;
 	ptp_ocp_sma_init(bp);
 
 	err = ptp_ocp_attr_group_add(bp, art_timecard_groups);
@@ -2689,16 +2731,9 @@ sma4_show(struct device *dev, struct device_attribute *attr, char *buf)
 }
 
 static int
-ptp_ocp_sma_store(struct ptp_ocp *bp, const char *buf, int sma_nr)
+ptp_ocp_sma_store_val(struct ptp_ocp *bp, int val, enum ptp_ocp_sma_mode mode, int sma_nr)
 {
 	struct ptp_ocp_sma_connector *sma = &bp->sma[sma_nr - 1];
-	enum ptp_ocp_sma_mode mode;
-	int val;
-
-	mode = sma->mode;
-	val = sma_parse_inputs(bp->sma_op->tbl, buf, &mode);
-	if (val < 0)
-		return val;
 
 	if (sma->fixed_dir && (mode != sma->mode || val & SMA_DISABLE))
 		return -EOPNOTSUPP;
@@ -2733,6 +2768,20 @@ ptp_ocp_sma_store(struct ptp_ocp *bp, const char *buf, int sma_nr)
 	return val;
 }
 
+static int
+ptp_ocp_sma_store(struct ptp_ocp *bp, const char *buf, int sma_nr)
+{
+	struct ptp_ocp_sma_connector *sma = &bp->sma[sma_nr - 1];
+	enum ptp_ocp_sma_mode mode;
+	int val;
+
+	mode = sma->mode;
+	val = sma_parse_inputs(bp->sma_op->tbl, buf, &mode);
+	if (val < 0)
+		return val;
+	return ptp_ocp_sma_store_val(bp, val, mode, sma_nr);
+}
+
 static ssize_t
 sma1_store(struct device *dev, struct device_attribute *attr,
 	   const char *buf, size_t count)
@@ -4171,12 +4220,148 @@ ptp_ocp_detach(struct ptp_ocp *bp)
 	device_unregister(&bp->dev);
 }
 
+static int ptp_ocp_dpll_lock_status_get(const struct dpll_device *dpll,
+					void *priv,
+					enum dpll_lock_status *status,
+					struct netlink_ext_ack *extack)
+{
+	struct ptp_ocp *bp = priv;
+	int sync;
+
+	sync = ioread32(&bp->reg->status) & OCP_STATUS_IN_SYNC;
+	*status = sync ? DPLL_LOCK_STATUS_LOCKED : DPLL_LOCK_STATUS_UNLOCKED;
+
+	return 0;
+}
+
+static int ptp_ocp_dpll_source_idx_get(const struct dpll_device *dpll,
+				       void *priv, u32 *idx,
+				       struct netlink_ext_ack *extack)
+{
+	struct ptp_ocp *bp = priv;
+
+	if (bp->pps_select) {
+		*idx = ioread32(&bp->pps_select->gpio1);
+		return 0;
+	}
+	return -EINVAL;
+}
+
+static int ptp_ocp_dpll_mode_get(const struct dpll_device *dpll, void *priv,
+				 u32 *mode, struct netlink_ext_ack *extack)
+{
+	*mode = DPLL_MODE_AUTOMATIC;
+	return 0;
+}
+
+static bool ptp_ocp_dpll_mode_supported(const struct dpll_device *dpll,
+					void *priv, const enum dpll_mode mode,
+					struct netlink_ext_ack *extack)
+{
+	return mode == DPLL_MODE_AUTOMATIC;
+}
+
+static int ptp_ocp_dpll_direction_get(const struct dpll_pin *pin,
+				      void *pin_priv,
+				      const struct dpll_device *dpll,
+				      void *priv,
+				      enum dpll_pin_direction *direction,
+				      struct netlink_ext_ack *extack)
+{
+	struct ptp_ocp_sma_connector *sma = pin_priv;
+
+	*direction = sma->mode == SMA_MODE_IN ?
+				  DPLL_PIN_DIRECTION_INPUT :
+				  DPLL_PIN_DIRECTION_OUTPUT;
+	return 0;
+}
+
+static int ptp_ocp_dpll_direction_set(const struct dpll_pin *pin,
+				      void *pin_priv,
+				      const struct dpll_device *dpll,
+				      void *dpll_priv,
+				      enum dpll_pin_direction direction,
+				      struct netlink_ext_ack *extack)
+{
+	struct ptp_ocp_sma_connector *sma = pin_priv;
+	struct ptp_ocp *bp = dpll_priv;
+	enum ptp_ocp_sma_mode mode;
+	int sma_nr = (sma - bp->sma);
+
+	if (sma->fixed_dir)
+		return -EOPNOTSUPP;
+	mode = direction == DPLL_PIN_DIRECTION_INPUT ?
+			    SMA_MODE_IN : SMA_MODE_OUT;
+	return ptp_ocp_sma_store_val(bp, 0, mode, sma_nr);
+}
+
+static int ptp_ocp_dpll_frequency_set(const struct dpll_pin *pin,
+				      void *pin_priv,
+				      const struct dpll_device *dpll,
+				      void *dpll_priv, u64 frequency,
+				      struct netlink_ext_ack *extack)
+{
+	struct ptp_ocp_sma_connector *sma = pin_priv;
+	struct ptp_ocp *bp = dpll_priv;
+	const struct ocp_selector *tbl;
+	int sma_nr = (sma - bp->sma);
+	int val, i;
+
+	if (sma->fixed_fcn)
+		return -EOPNOTSUPP;
+
+	tbl = bp->sma_op->tbl[sma->mode];
+	for (i = 0; tbl[i].name; i++)
+		if (tbl[i].frequency == frequency)
+			return ptp_ocp_sma_store_val(bp, val, sma->mode, sma_nr);
+	return -EINVAL;
+}
+
+static int ptp_ocp_dpll_frequency_get(const struct dpll_pin *pin,
+				      void *pin_priv,
+				      const struct dpll_device *dpll,
+				      void *dpll_priv, u64 *frequency,
+				      struct netlink_ext_ack *extack)
+{
+	struct ptp_ocp_sma_connector *sma = pin_priv;
+	struct ptp_ocp *bp = dpll_priv;
+	const struct ocp_selector *tbl;
+	int sma_nr = (sma - bp->sma);
+	u32 val;
+	int i;
+
+	val = bp->sma_op->get(bp, sma_nr);
+	tbl = bp->sma_op->tbl[sma->mode];
+	for (i = 0; tbl[i].name; i++)
+		if (val == tbl[i].value) {
+			*frequency = tbl[i].frequency;
+			return 0;
+		}
+
+	return -EINVAL;
+}
+
+static const struct dpll_device_ops dpll_ops = {
+	.lock_status_get = ptp_ocp_dpll_lock_status_get,
+	.source_pin_idx_get = ptp_ocp_dpll_source_idx_get,
+	.mode_get = ptp_ocp_dpll_mode_get,
+	.mode_supported = ptp_ocp_dpll_mode_supported,
+};
+
+static const struct dpll_pin_ops dpll_pins_ops = {
+	.frequency_get = ptp_ocp_dpll_frequency_get,
+	.frequency_set = ptp_ocp_dpll_frequency_set,
+	.direction_get = ptp_ocp_dpll_direction_get,
+	.direction_set = ptp_ocp_dpll_direction_set,
+};
+
 static int
 ptp_ocp_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	struct devlink *devlink;
 	struct ptp_ocp *bp;
-	int err;
+	int err, i;
+	u64 clkid;
 
 	devlink = devlink_alloc(&ptp_ocp_devlink_ops, sizeof(*bp), &pdev->dev);
 	if (!devlink) {
@@ -4226,8 +4411,39 @@ ptp_ocp_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	ptp_ocp_info(bp);
 	devlink_register(devlink);
-	return 0;
 
+	clkid = pci_get_dsn(pdev);
+	bp->dpll = dpll_device_get(clkid, 0, THIS_MODULE);
+	if (IS_ERR(bp->dpll)) {
+		dev_err(&pdev->dev, "dpll_device_alloc failed\n");
+		goto out;
+	}
+
+	err = dpll_device_register(bp->dpll, DPLL_TYPE_PPS, &dpll_ops, bp);
+	if (err)
+		goto out;
+
+	for (i = 0; i < OCP_SMA_NUM; i++) {
+		bp->sma[i].dpll_pin = dpll_pin_get(clkid, i, THIS_MODULE, &bp->sma[i].dpll_prop);
+		if (IS_ERR(bp->sma[i].dpll_pin))
+			goto out_dpll;
+
+		err = dpll_pin_register(bp->dpll, bp->sma[i].dpll_pin, &dpll_pins_ops,
+					&bp->sma[i]);
+		if (err) {
+			dpll_pin_put(bp->sma[i].dpll_pin);
+			goto out_dpll;
+		}
+	}
+
+	return 0;
+out_dpll:
+	while (i) {
+		--i;
+		dpll_pin_unregister(bp->dpll, bp->sma[i].dpll_pin, &dpll_pins_ops, &bp->sma[i]);
+		dpll_pin_put(bp->sma[i].dpll_pin);
+	}
+	dpll_device_put(bp->dpll);
 out:
 	ptp_ocp_detach(bp);
 out_disable:
@@ -4242,7 +4458,16 @@ ptp_ocp_remove(struct pci_dev *pdev)
 {
 	struct ptp_ocp *bp = pci_get_drvdata(pdev);
 	struct devlink *devlink = priv_to_devlink(bp);
+	int i;
 
+	for (i = 0; i < OCP_SMA_NUM; i++) {
+		if (bp->sma[i].dpll_pin) {
+			dpll_pin_unregister(bp->dpll, bp->sma[i].dpll_pin, &dpll_pins_ops, bp);
+			dpll_pin_put(bp->sma[i].dpll_pin);
+		}
+	}
+	dpll_device_unregister(bp->dpll, &dpll_ops, bp);
+	dpll_device_put(bp->dpll);
 	devlink_unregister(devlink);
 	ptp_ocp_detach(bp);
 	pci_disable_device(pdev);
-- 
2.37.3


