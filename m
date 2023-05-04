Return-Path: <netdev+bounces-262-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6992F6F6846
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 11:28:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 251AD280CBC
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 09:28:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 866634C69;
	Thu,  4 May 2023 09:27:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BFAAED4
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 09:27:59 +0000 (UTC)
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE3193A82
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 02:27:54 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id 4fb4d7f45d1cf-50bc4ba28cbso388030a12.0
        for <netdev@vger.kernel.org>; Thu, 04 May 2023 02:27:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20221208.gappssmtp.com; s=20221208; t=1683192473; x=1685784473;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=DlMPQyYkhlk13xRSyZTO32Sp+zpmDMVqz0Ddt7Xu0ic=;
        b=VMfi/eKlTpOiQGdcer3Xw1SfySJ/BVKxjIIg/gJpArsjkJq9dBPo5KD83TWlf1CWb6
         mcpunK28CJs8j8Gp5qKkPKSJ9xB1L/GW3zcsyzcvQeqvE3Wa3b1+AyE+5VxqJ+JviUW/
         4zr5+qCP2kSpvCi0oes94gltmU4SIakrf7nSLuzc7PjqRsT2sDc6lgSbPijBWJ1GkKLr
         S+oERSKaLKjWBB9Q61IE2seejoD+Bvis6uXaWakp2y3RfGtmGia3bTxSvXPXYHgmya3S
         +HR8wMlO3MFq35xTfmVQsFGJ1b/NaRwg3KqjGnVc0Ppil6QSjxmmp01w3n3vdB3xxpLa
         P6/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683192473; x=1685784473;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DlMPQyYkhlk13xRSyZTO32Sp+zpmDMVqz0Ddt7Xu0ic=;
        b=eF/JHb5LHKjskB0gJmdx91/FNt+RJx53KRPRRPlCst/RZzUa2lc9dbJ9CF2FtI/li6
         nH5lFk49YP+OH2r7o3pzrU90/igfVksUhAOXuqUkJU9p+G6USYPkco405q/SELQqBy1W
         okxAqGx2p0ujIrtAa5cbFUmx5gT2X6XqBWIoTqGh2yj9QRb9qmmMJTm3OyLY9exqL9tW
         LBbiwpgzS8WI8P/YxHQvYVeTPCJtLhrP/QDjhQDTk+u56jlWpOwDRiFxvwR5Qyb39J5y
         fNzc3oziVeF03sb3gf9MnK3lZGPVTvgwuo4CDYRiU8E90FsvXSqHNuZxLcQj1ua6o+b1
         94TA==
X-Gm-Message-State: AC+VfDxo+6A+zSEEtVW+ud364LBZUefrCHPNSMNIqiWP+yNplK1ksWkK
	PFtghlVwQ7ZOf5O7yQ6M4Q19O/nO5l/xd1xstOs=
X-Google-Smtp-Source: ACHHUZ7VsjaA4NSROmR/Pe0H2JWimn3m3skAh5y/Le2jI+U44997g5Nd80134aQSYF1P5OqUsYh3VQ==
X-Received: by 2002:a17:907:3209:b0:94e:8d26:f610 with SMTP id xg9-20020a170907320900b0094e8d26f610mr5013794ejb.28.1683192473030;
        Thu, 04 May 2023 02:27:53 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id my34-20020a1709065a6200b0094f6f45b2c1sm18585796ejc.156.2023.05.04.02.27.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 May 2023 02:27:52 -0700 (PDT)
Date: Thu, 4 May 2023 11:27:51 +0200
From: Jiri Pirko <jiri@resnulli.us>
To: Vadim Fedorenko <vadfed@meta.com>
Cc: Jakub Kicinski <kuba@kernel.org>,
	Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
	Jonathan Lemon <jonathan.lemon@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Milena Olech <milena.olech@intel.com>,
	Michal Michalik <michal.michalik@intel.com>,
	linux-arm-kernel@lists.infradead.org,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>, poros@redhat.com,
	mschmidt@redhat.com, netdev@vger.kernel.org,
	linux-clk@vger.kernel.org
Subject: Re: [RFC PATCH v7 6/8] ptp_ocp: implement DPLL ops
Message-ID: <ZFN6lwE2Up8xV+I6@nanopsycho>
References: <20230428002009.2948020-1-vadfed@meta.com>
 <20230428002009.2948020-7-vadfed@meta.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230428002009.2948020-7-vadfed@meta.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Fri, Apr 28, 2023 at 02:20:07AM CEST, vadfed@meta.com wrote:
>From: Vadim Fedorenko <vadim.fedorenko@linux.dev>
>
>Implement basic DPLL operations in ptp_ocp driver as the
>simplest example of using new subsystem.
>
>Signed-off-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
>---
> drivers/ptp/Kconfig   |   1 +
> drivers/ptp/ptp_ocp.c | 327 +++++++++++++++++++++++++++++++++++-------
> 2 files changed, 276 insertions(+), 52 deletions(-)
>
>diff --git a/drivers/ptp/Kconfig b/drivers/ptp/Kconfig
>index b00201d81313..e3575c2e34dc 100644
>--- a/drivers/ptp/Kconfig
>+++ b/drivers/ptp/Kconfig
>@@ -177,6 +177,7 @@ config PTP_1588_CLOCK_OCP
> 	depends on COMMON_CLK
> 	select NET_DEVLINK
> 	select CRC16
>+	select DPLL
> 	help
> 	  This driver adds support for an OpenCompute time card.
> 
>diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
>index 2b63f3487645..100e5da0aeb3 100644
>--- a/drivers/ptp/ptp_ocp.c
>+++ b/drivers/ptp/ptp_ocp.c
>@@ -23,6 +23,7 @@
> #include <linux/mtd/mtd.h>
> #include <linux/nvmem-consumer.h>
> #include <linux/crc16.h>
>+#include <linux/dpll.h>
> 
> #define PCI_VENDOR_ID_FACEBOOK			0x1d9b
> #define PCI_DEVICE_ID_FACEBOOK_TIMECARD		0x0400
>@@ -261,12 +262,21 @@ enum ptp_ocp_sma_mode {
> 	SMA_MODE_OUT,
> };
> 
>+static struct dpll_pin_frequency ptp_ocp_sma_freq[] = {

const

>+	DPLL_PIN_FREQUENCY_1PPS,
>+	DPLL_PIN_FREQUENCY_10MHZ,
>+	DPLL_PIN_FREQUENCY_IRIG_B,
>+	DPLL_PIN_FREQUENCY_DCF77,
>+};
>+
> struct ptp_ocp_sma_connector {
> 	enum	ptp_ocp_sma_mode mode;
> 	bool	fixed_fcn;
> 	bool	fixed_dir;
> 	bool	disabled;
> 	u8	default_fcn;
>+	struct dpll_pin		   *dpll_pin;
>+	struct dpll_pin_properties dpll_prop;
> };
> 
> struct ocp_attr_group {
>@@ -295,6 +305,7 @@ struct ptp_ocp_serial_port {
> 
> #define OCP_BOARD_ID_LEN		13
> #define OCP_SERIAL_LEN			6
>+#define OCP_SMA_NUM			4
> 
> struct ptp_ocp {
> 	struct pci_dev		*pdev;
>@@ -351,8 +362,9 @@ struct ptp_ocp {
> 	u32			ts_window_adjust;
> 	u64			fw_cap;
> 	struct ptp_ocp_signal	signal[4];
>-	struct ptp_ocp_sma_connector sma[4];
>+	struct ptp_ocp_sma_connector sma[OCP_SMA_NUM];
> 	const struct ocp_sma_op *sma_op;
>+	struct dpll_device *dpll;
> };
> 
> #define OCP_REQ_TIMESTAMP	BIT(0)
>@@ -836,6 +848,7 @@ static DEFINE_IDR(ptp_ocp_idr);
> struct ocp_selector {
> 	const char *name;
> 	int value;
>+	u64 frequency;
> };
> 
> static const struct ocp_selector ptp_ocp_clock[] = {
>@@ -856,31 +869,31 @@ static const struct ocp_selector ptp_ocp_clock[] = {
> #define SMA_SELECT_MASK		GENMASK(14, 0)
> 
> static const struct ocp_selector ptp_ocp_sma_in[] = {
>-	{ .name = "10Mhz",	.value = 0x0000 },
>-	{ .name = "PPS1",	.value = 0x0001 },
>-	{ .name = "PPS2",	.value = 0x0002 },
>-	{ .name = "TS1",	.value = 0x0004 },
>-	{ .name = "TS2",	.value = 0x0008 },
>-	{ .name = "IRIG",	.value = 0x0010 },
>-	{ .name = "DCF",	.value = 0x0020 },
>-	{ .name = "TS3",	.value = 0x0040 },
>-	{ .name = "TS4",	.value = 0x0080 },
>-	{ .name = "FREQ1",	.value = 0x0100 },
>-	{ .name = "FREQ2",	.value = 0x0200 },
>-	{ .name = "FREQ3",	.value = 0x0400 },
>-	{ .name = "FREQ4",	.value = 0x0800 },
>-	{ .name = "None",	.value = SMA_DISABLE },
>+	{ .name = "10Mhz",  .value = 0x0000,      .frequency = 10000000 },
>+	{ .name = "PPS1",   .value = 0x0001,      .frequency = 1 },
>+	{ .name = "PPS2",   .value = 0x0002,      .frequency = 1 },
>+	{ .name = "TS1",    .value = 0x0004,      .frequency = 0 },
>+	{ .name = "TS2",    .value = 0x0008,      .frequency = 0 },
>+	{ .name = "IRIG",   .value = 0x0010,      .frequency = 10000 },
>+	{ .name = "DCF",    .value = 0x0020,      .frequency = 77500 },
>+	{ .name = "TS3",    .value = 0x0040,      .frequency = 0 },
>+	{ .name = "TS4",    .value = 0x0080,      .frequency = 0 },
>+	{ .name = "FREQ1",  .value = 0x0100,      .frequency = 0 },
>+	{ .name = "FREQ2",  .value = 0x0200,      .frequency = 0 },
>+	{ .name = "FREQ3",  .value = 0x0400,      .frequency = 0 },
>+	{ .name = "FREQ4",  .value = 0x0800,      .frequency = 0 },
>+	{ .name = "None",   .value = SMA_DISABLE, .frequency = 0 },
> 	{ }
> };
> 
> static const struct ocp_selector ptp_ocp_sma_out[] = {
>-	{ .name = "10Mhz",	.value = 0x0000 },
>-	{ .name = "PHC",	.value = 0x0001 },
>-	{ .name = "MAC",	.value = 0x0002 },
>-	{ .name = "GNSS1",	.value = 0x0004 },
>-	{ .name = "GNSS2",	.value = 0x0008 },
>-	{ .name = "IRIG",	.value = 0x0010 },
>-	{ .name = "DCF",	.value = 0x0020 },
>+	{ .name = "10Mhz",	.value = 0x0000,  .frequency = 10000000 },
>+	{ .name = "PHC",	.value = 0x0001,  .frequency = 1 },
>+	{ .name = "MAC",	.value = 0x0002,  .frequency = 1 },
>+	{ .name = "GNSS1",	.value = 0x0004,  .frequency = 1 },
>+	{ .name = "GNSS2",	.value = 0x0008,  .frequency = 1 },
>+	{ .name = "IRIG",	.value = 0x0010,  .frequency = 10000 },
>+	{ .name = "DCF",	.value = 0x0020,  .frequency = 77000 },
> 	{ .name = "GEN1",	.value = 0x0040 },
> 	{ .name = "GEN2",	.value = 0x0080 },
> 	{ .name = "GEN3",	.value = 0x0100 },
>@@ -891,15 +904,15 @@ static const struct ocp_selector ptp_ocp_sma_out[] = {
> };
> 
> static const struct ocp_selector ptp_ocp_art_sma_in[] = {
>-	{ .name = "PPS1",	.value = 0x0001 },
>-	{ .name = "10Mhz",	.value = 0x0008 },
>+	{ .name = "PPS1",	.value = 0x0001,  .frequency = 1 },
>+	{ .name = "10Mhz",	.value = 0x0008,  .frequency = 1000000 },
> 	{ }
> };
> 
> static const struct ocp_selector ptp_ocp_art_sma_out[] = {
>-	{ .name = "PHC",	.value = 0x0002 },
>-	{ .name = "GNSS",	.value = 0x0004 },
>-	{ .name = "10Mhz",	.value = 0x0010 },
>+	{ .name = "PHC",	.value = 0x0002,  .frequency = 1 },
>+	{ .name = "GNSS",	.value = 0x0004,  .frequency = 1 },
>+	{ .name = "10Mhz",	.value = 0x0010,  .frequency = 10000000 },
> 	{ }
> };
> 
>@@ -2283,22 +2296,34 @@ ptp_ocp_sma_fb_set_inputs(struct ptp_ocp *bp, int sma_nr, u32 val)
> static void
> ptp_ocp_sma_fb_init(struct ptp_ocp *bp)
> {
>+	struct dpll_pin_properties prop = {

Why don't you have this as static const outside the function?


>+		.label = NULL,

Pointless init.


>+		.type = DPLL_PIN_TYPE_EXT,
>+		.capabilities = DPLL_PIN_CAPS_DIRECTION_CAN_CHANGE,
>+		.freq_supported_num = ARRAY_SIZE(ptp_ocp_sma_freq),
>+		.freq_supported = ptp_ocp_sma_freq,
>+
>+	};
> 	u32 reg;
> 	int i;
> 
> 	/* defaults */
>+	for (i = 0; i < OCP_SMA_NUM; i++) {
>+		bp->sma[i].default_fcn = i & 1;
>+		bp->sma[i].dpll_prop = prop;
>+		bp->sma[i].dpll_prop.label = bp->ptp_info.pin_config[i].name;
>+	}
> 	bp->sma[0].mode = SMA_MODE_IN;
> 	bp->sma[1].mode = SMA_MODE_IN;
> 	bp->sma[2].mode = SMA_MODE_OUT;
> 	bp->sma[3].mode = SMA_MODE_OUT;
>-	for (i = 0; i < 4; i++)
>-		bp->sma[i].default_fcn = i & 1;
>-
> 	/* If no SMA1 map, the pin functions and directions are fixed. */
> 	if (!bp->sma_map1) {
>-		for (i = 0; i < 4; i++) {
>+		for (i = 0; i < OCP_SMA_NUM; i++) {
> 			bp->sma[i].fixed_fcn = true;
> 			bp->sma[i].fixed_dir = true;
>+			bp->sma[1].dpll_prop.capabilities &=
>+				~DPLL_PIN_CAPS_DIRECTION_CAN_CHANGE;
> 		}
> 		return;
> 	}
>@@ -2308,7 +2333,7 @@ ptp_ocp_sma_fb_init(struct ptp_ocp *bp)
> 	 */
> 	reg = ioread32(&bp->sma_map2->gpio2);
> 	if (reg == 0xffffffff) {
>-		for (i = 0; i < 4; i++)
>+		for (i = 0; i < OCP_SMA_NUM; i++)
> 			bp->sma[i].fixed_dir = true;
> 	} else {
> 		reg = ioread32(&bp->sma_map1->gpio1);
>@@ -2330,7 +2355,7 @@ static const struct ocp_sma_op ocp_fb_sma_op = {
> };
> 
> static int
>-ptp_ocp_fb_set_pins(struct ptp_ocp *bp)
>+ptp_ocp_set_pins(struct ptp_ocp *bp)
> {
> 	struct ptp_pin_desc *config;
> 	int i;
>@@ -2397,16 +2422,16 @@ ptp_ocp_fb_board_init(struct ptp_ocp *bp, struct ocp_resource *r)
> 
> 	ptp_ocp_tod_init(bp);
> 	ptp_ocp_nmea_out_init(bp);
>-	ptp_ocp_sma_init(bp);
> 	ptp_ocp_signal_init(bp);
> 
> 	err = ptp_ocp_attr_group_add(bp, fb_timecard_groups);
> 	if (err)
> 		return err;
> 
>-	err = ptp_ocp_fb_set_pins(bp);
>+	err = ptp_ocp_set_pins(bp);
> 	if (err)
> 		return err;
>+	ptp_ocp_sma_init(bp);
> 
> 	return ptp_ocp_init_clock(bp);
> }
>@@ -2446,6 +2471,14 @@ ptp_ocp_register_resources(struct ptp_ocp *bp, kernel_ulong_t driver_data)
> static void
> ptp_ocp_art_sma_init(struct ptp_ocp *bp)
> {
>+	struct dpll_pin_properties prop = {
>+		.label = NULL,
>+		.type = DPLL_PIN_TYPE_EXT,
>+		.capabilities = 0,

Same comment as to the similar prop struct above. Plus another pointless
init here.


>+		.freq_supported_num = ARRAY_SIZE(ptp_ocp_sma_freq),
>+		.freq_supported = ptp_ocp_sma_freq,
>+
>+	};
> 	u32 reg;
> 	int i;
> 
>@@ -2460,16 +2493,16 @@ ptp_ocp_art_sma_init(struct ptp_ocp *bp)
> 	bp->sma[2].default_fcn = 0x10;	/* OUT: 10Mhz */
> 	bp->sma[3].default_fcn = 0x02;	/* OUT: PHC */
> 
>-	/* If no SMA map, the pin functions and directions are fixed. */
>-	if (!bp->art_sma) {
>-		for (i = 0; i < 4; i++) {
>+
>+	for (i = 0; i < OCP_SMA_NUM; i++) {
>+		/* If no SMA map, the pin functions and directions are fixed. */
>+		bp->sma[i].dpll_prop = prop;
>+		bp->sma[i].dpll_prop.label = bp->ptp_info.pin_config[i].name;
>+		if (!bp->art_sma) {
> 			bp->sma[i].fixed_fcn = true;
> 			bp->sma[i].fixed_dir = true;
>+			continue;
> 		}
>-		return;
>-	}
>-
>-	for (i = 0; i < 4; i++) {
> 		reg = ioread32(&bp->art_sma->map[i].gpio);
> 
> 		switch (reg & 0xff) {
>@@ -2480,9 +2513,13 @@ ptp_ocp_art_sma_init(struct ptp_ocp *bp)
> 		case 1:
> 		case 8:
> 			bp->sma[i].mode = SMA_MODE_IN;
>+			bp->sma[i].dpll_prop.capabilities =
>+				DPLL_PIN_CAPS_DIRECTION_CAN_CHANGE;
> 			break;
> 		default:
> 			bp->sma[i].mode = SMA_MODE_OUT;
>+			bp->sma[i].dpll_prop.capabilities =
>+				DPLL_PIN_CAPS_DIRECTION_CAN_CHANGE;
> 			break;
> 		}
> 	}
>@@ -2549,6 +2586,9 @@ ptp_ocp_art_board_init(struct ptp_ocp *bp, struct ocp_resource *r)
> 	/* Enable MAC serial port during initialisation */
> 	iowrite32(1, &bp->board_config->mro50_serial_activate);
> 
>+	err = ptp_ocp_set_pins(bp);
>+	if (err)
>+		return err;
> 	ptp_ocp_sma_init(bp);
> 
> 	err = ptp_ocp_attr_group_add(bp, art_timecard_groups);
>@@ -2690,16 +2730,9 @@ sma4_show(struct device *dev, struct device_attribute *attr, char *buf)
> }
> 
> static int
>-ptp_ocp_sma_store(struct ptp_ocp *bp, const char *buf, int sma_nr)
>+ptp_ocp_sma_store_val(struct ptp_ocp *bp, int val, enum ptp_ocp_sma_mode mode, int sma_nr)
> {
> 	struct ptp_ocp_sma_connector *sma = &bp->sma[sma_nr - 1];
>-	enum ptp_ocp_sma_mode mode;
>-	int val;
>-
>-	mode = sma->mode;
>-	val = sma_parse_inputs(bp->sma_op->tbl, buf, &mode);
>-	if (val < 0)
>-		return val;
> 
> 	if (sma->fixed_dir && (mode != sma->mode || val & SMA_DISABLE))
> 		return -EOPNOTSUPP;
>@@ -2734,6 +2767,20 @@ ptp_ocp_sma_store(struct ptp_ocp *bp, const char *buf, int sma_nr)
> 	return val;
> }
> 
>+static int
>+ptp_ocp_sma_store(struct ptp_ocp *bp, const char *buf, int sma_nr)
>+{
>+	struct ptp_ocp_sma_connector *sma = &bp->sma[sma_nr - 1];
>+	enum ptp_ocp_sma_mode mode;
>+	int val;
>+
>+	mode = sma->mode;
>+	val = sma_parse_inputs(bp->sma_op->tbl, buf, &mode);
>+	if (val < 0)
>+		return val;
>+	return ptp_ocp_sma_store_val(bp, val, mode, sma_nr);
>+}
>+
> static ssize_t
> sma1_store(struct device *dev, struct device_attribute *attr,
> 	   const char *buf, size_t count)
>@@ -4172,12 +4219,148 @@ ptp_ocp_detach(struct ptp_ocp *bp)
> 	device_unregister(&bp->dev);
> }
> 
>+static int ptp_ocp_dpll_lock_status_get(const struct dpll_device *dpll,
>+					void *priv,
>+					enum dpll_lock_status *status,
>+					struct netlink_ext_ack *extack)
>+{
>+	struct ptp_ocp *bp = priv;
>+	int sync;
>+
>+	sync = ioread32(&bp->reg->status) & OCP_STATUS_IN_SYNC;
>+	*status = sync ? DPLL_LOCK_STATUS_LOCKED : DPLL_LOCK_STATUS_UNLOCKED;

Does your device support event delivery in case of the status change?
ice and mlx5 drivers do poll for changes in this area anyway. It's a
part of this patchset. You should do the same if your device does
not support events.

Could you please implement notifications using
dpll_device_notify() for status change and dpll_pin_notify() for pin
state change?



>+
>+	return 0;
>+}
>+
>+static int ptp_ocp_dpll_source_idx_get(const struct dpll_device *dpll,
>+				       void *priv, u32 *idx,
>+				       struct netlink_ext_ack *extack)
>+{
>+	struct ptp_ocp *bp = priv;
>+
>+	if (bp->pps_select) {
>+		*idx = ioread32(&bp->pps_select->gpio1);
>+		return 0;
>+	}
>+	return -EINVAL;
>+}
>+
>+static int ptp_ocp_dpll_mode_get(const struct dpll_device *dpll, void *priv,
>+				 u32 *mode, struct netlink_ext_ack *extack)
>+{
>+	*mode = DPLL_MODE_AUTOMATIC;
>+	return 0;
>+}
>+
>+static bool ptp_ocp_dpll_mode_supported(const struct dpll_device *dpll,
>+					void *priv, const enum dpll_mode mode,
>+					struct netlink_ext_ack *extack)
>+{
>+	return mode == DPLL_MODE_AUTOMATIC;
>+}
>+
>+static int ptp_ocp_dpll_direction_get(const struct dpll_pin *pin,
>+				      void *pin_priv,
>+				      const struct dpll_device *dpll,
>+				      void *priv,
>+				      enum dpll_pin_direction *direction,
>+				      struct netlink_ext_ack *extack)
>+{
>+	struct ptp_ocp_sma_connector *sma = pin_priv;
>+
>+	*direction = sma->mode == SMA_MODE_IN ?
>+				  DPLL_PIN_DIRECTION_SOURCE :
>+				  DPLL_PIN_DIRECTION_OUTPUT;
>+	return 0;
>+}
>+
>+static int ptp_ocp_dpll_direction_set(const struct dpll_pin *pin,
>+				      void *pin_priv,
>+				      const struct dpll_device *dpll,
>+				      void *dpll_priv,
>+				      enum dpll_pin_direction direction,
>+				      struct netlink_ext_ack *extack)
>+{
>+	struct ptp_ocp_sma_connector *sma = pin_priv;
>+	struct ptp_ocp *bp = dpll_priv;
>+	enum ptp_ocp_sma_mode mode;
>+	int sma_nr = (sma - bp->sma);
>+
>+	if (sma->fixed_dir)

I believe that this is a pointless check as DPLL_PIN_CAPS_DIRECTION_CAN_CHANGE
is not set and therefore the check in dpll_pin_direction_set() will be
true and -EOPNOTSUPP will be returned from there.
Remove this.


>+		return -EOPNOTSUPP;
>+	mode = direction == DPLL_PIN_DIRECTION_SOURCE ?
>+			    SMA_MODE_IN : SMA_MODE_OUT;
>+	return ptp_ocp_sma_store_val(bp, 0, mode, sma_nr);

You need sma_nr just here. Why can't you change ptp_ocp_sma_store_val()
to accept struct ptp_ocp_sma_connector * instead avoiding the need for
tne sma_nr completely?


>+}
>+
>+static int ptp_ocp_dpll_frequency_set(const struct dpll_pin *pin,
>+				      void *pin_priv,
>+				      const struct dpll_device *dpll,
>+				      void *dpll_priv, u64 frequency,
>+				      struct netlink_ext_ack *extack)
>+{
>+	struct ptp_ocp_sma_connector *sma = pin_priv;
>+	struct ptp_ocp *bp = dpll_priv;
>+	const struct ocp_selector *tbl;
>+	int sma_nr = (sma - bp->sma);
>+	int val, i;
>+
>+	if (sma->fixed_fcn)

In that case, just fill up a single frequency in the properties,
avoid this check-fail and let the dpll core handle it.


>+		return -EOPNOTSUPP;
>+
>+	tbl = bp->sma_op->tbl[sma->mode];
>+	for (i = 0; tbl[i].name; i++)
>+		if (tbl[i].frequency == frequency)
>+			return ptp_ocp_sma_store_val(bp, val, sma->mode, sma_nr);
>+	return -EINVAL;
>+}
>+
>+static int ptp_ocp_dpll_frequency_get(const struct dpll_pin *pin,
>+				      void *pin_priv,
>+				      const struct dpll_device *dpll,
>+				      void *dpll_priv, u64 *frequency,
>+				      struct netlink_ext_ack *extack)
>+{
>+	struct ptp_ocp_sma_connector *sma = pin_priv;
>+	struct ptp_ocp *bp = dpll_priv;
>+	const struct ocp_selector *tbl;
>+	int sma_nr = (sma - bp->sma);

1) void "()"s here.
2) why don't you fill the sma_nr in struct ptp_ocp_sma_connector to make
   this easier to follow? IDK, just a suggestion, take or leave.

Same applies to the the rest of similar occurances above.


>+	u32 val;
>+	int i;
>+
>+	val = bp->sma_op->get(bp, sma_nr);
>+	tbl = bp->sma_op->tbl[sma->mode];
>+	for (i = 0; tbl[i].name; i++)
>+		if (val == tbl[i].value) {
>+			*frequency = tbl[i].frequency;
>+			return 0;
>+		}
>+
>+	return -EINVAL;
>+}
>+
>+static const struct dpll_device_ops dpll_ops = {
>+	.lock_status_get = ptp_ocp_dpll_lock_status_get,
>+	.source_pin_idx_get = ptp_ocp_dpll_source_idx_get,

This op is a leftover, in dpll core it is not called. This was removed
and agreed that drivers should implement state_on_dpll_get() op for pins
to see which one is connected.

Please fix here and remove the leftover from DPLL patch #2 as well.


>+	.mode_get = ptp_ocp_dpll_mode_get,
>+	.mode_supported = ptp_ocp_dpll_mode_supported,
>+};
>+
>+static const struct dpll_pin_ops dpll_pins_ops = {
>+	.frequency_get = ptp_ocp_dpll_frequency_get,
>+	.frequency_set = ptp_ocp_dpll_frequency_set,
>+	.direction_get = ptp_ocp_dpll_direction_get,
>+	.direction_set = ptp_ocp_dpll_direction_set,
>+};
>+
> static int
> ptp_ocp_probe(struct pci_dev *pdev, const struct pci_device_id *id)
> {
> 	struct devlink *devlink;
> 	struct ptp_ocp *bp;
>-	int err;
>+	int err, i;
>+	u64 clkid;
> 
> 	devlink = devlink_alloc(&ptp_ocp_devlink_ops, sizeof(*bp), &pdev->dev);
> 	if (!devlink) {
>@@ -4227,8 +4410,39 @@ ptp_ocp_probe(struct pci_dev *pdev, const struct pci_device_id *id)
> 
> 	ptp_ocp_info(bp);
> 	devlink_register(devlink);
>-	return 0;
> 
>+	clkid = pci_get_dsn(pdev);
>+	bp->dpll = dpll_device_get(clkid, 0, THIS_MODULE);

I suggested this the last time, but again: Could you please:
1) rename dpll_device_get to __dpll_device_get
2) introduce dpll_device_get as a macro filling up THIS_MODULE

Then drivers will just call always:
bp->dpll = dpll_device_get(clkid, 0);
and the macro will fillup the module automatically.

Please do the same for dpll_pin_get()


>+	if (IS_ERR(bp->dpll)) {
>+		dev_err(&pdev->dev, "dpll_device_alloc failed\n");

You need to fix your error path to call devlink_unregister() in this
case.


>+		goto out;
>+	}
>+
>+	err = dpll_device_register(bp->dpll, DPLL_TYPE_PPS, &dpll_ops, bp, &pdev->dev);
>+	if (err)

You need to fix your error path to call dpll_device_put() in this
case.


>+		goto out;
>+
>+	for (i = 0; i < OCP_SMA_NUM; i++) {
>+		bp->sma[i].dpll_pin = dpll_pin_get(clkid, i, THIS_MODULE, &bp->sma[i].dpll_prop);
>+		if (IS_ERR(bp->sma[i].dpll_pin))
>+			goto out_dpll;
>+
>+		err = dpll_pin_register(bp->dpll, bp->sma[i].dpll_pin, &dpll_pins_ops,
>+					&bp->sma[i], NULL);
>+		if (err) {
>+			dpll_pin_put(bp->sma[i].dpll_pin);
>+			goto out_dpll;
>+		}
>+	}
>+
>+	return 0;
>+out_dpll:
>+	while (i) {
>+		--i;

	while (i--) {
	?

>+		dpll_pin_unregister(bp->dpll, bp->sma[i].dpll_pin, &dpll_pins_ops, &bp->sma[i]);
>+		dpll_pin_put(bp->sma[i].dpll_pin);
>+	}
>+	dpll_device_put(bp->dpll);
> out:
> 	ptp_ocp_detach(bp);
> out_disable:
>@@ -4243,7 +4457,16 @@ ptp_ocp_remove(struct pci_dev *pdev)
> {
> 	struct ptp_ocp *bp = pci_get_drvdata(pdev);
> 	struct devlink *devlink = priv_to_devlink(bp);
>+	int i;
> 
>+	for (i = 0; i < OCP_SMA_NUM; i++) {
>+		if (bp->sma[i].dpll_pin) {

Remove this pointless check. It is always true.


>+			dpll_pin_unregister(bp->dpll, bp->sma[i].dpll_pin, &dpll_pins_ops, bp);
>+			dpll_pin_put(bp->sma[i].dpll_pin);
>+		}
>+	}
>+	dpll_device_unregister(bp->dpll, &dpll_ops, bp);
>+	dpll_device_put(bp->dpll);
> 	devlink_unregister(devlink);
> 	ptp_ocp_detach(bp);
> 	pci_disable_device(pdev);
>-- 
>2.34.1
>

