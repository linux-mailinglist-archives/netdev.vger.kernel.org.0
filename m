Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 474A163D5C5
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 13:41:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234971AbiK3MlX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 07:41:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235022AbiK3MlS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 07:41:18 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63E3745A3D
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 04:41:15 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id b2so24731355eja.7
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 04:41:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ef4MN0+eiRK/U5L1HWQnz6Gd+zHs4uX/l+25isOTBVk=;
        b=McmCsJE9hm81K42xcfoG3ozU2VLQFSIt5Z8igzAkJXfUFxGDRDawFNDo0p9wKzkNYX
         sI3OooiPBLoiVsqko4tExwcBPy5Tku/DFuqTS/KdoIojb3uY2szo2vI7yzkNyu00cCYU
         OtO7G9kQjtdVstxJ2tyjbmbakkoywp988qsB1dyNL0eNVcOPlsC3cXm6j7rioIhqhRsQ
         M24U2awKAQg4X3AfSqEO+N4o0dHzORI4iZW1DmOttZ9pJ4yOX6MlmUTFvKdAPxzSVxq6
         fDnb9xrOXk7h6lOuvRFmi5lACjDgyrvrf4/6JXtE2UDp4XjzYxcPcNVVDz4kCtJdUDk7
         VCmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ef4MN0+eiRK/U5L1HWQnz6Gd+zHs4uX/l+25isOTBVk=;
        b=INozGDSzgK97DHJKUC8ZBj2amgf3vF3+YcfEdqFM40I/Bm7QSMEt+ACUMAP8PIAgqd
         FzltWyIDUPr6La869msnz/ZGZvwu2VU+ZLWnZf0E0NstO9QklaVYUsmlfgeTs4MdUleu
         iDxHTLL+dk9atp7HQ6Vv75Dh4VJw2hG++CAvkaLEfzCTwVXPZDbTv79eUzZBpKZjYy8e
         zlpZ7casrr/YbLwAf3CH72e58pGiqXkfv4mRG/OZfMszAgYwItNcCpM+LCGRuTM41vKp
         hDT+KVwOceCWFUjSrEc6+FPF50xE9NdiJyEbKCqYZ5eqCnmkFrxYV9HOmBzb/gm0WxPf
         fAqA==
X-Gm-Message-State: ANoB5pko+NskLyNATv81F4qeiAPQo1IN86jlzB526DX67p7+jLOISij9
        X+9sFMbleaPxT6EZtTJ69vk0MQ==
X-Google-Smtp-Source: AA0mqf6K0+ksxXAofUzIcSeXlkd1avQRIpPTFO8dD6M1MG69KQt0+DjSdx3anuEPxl/vvrAJsJvG2A==
X-Received: by 2002:a17:906:a418:b0:7a5:e944:9e48 with SMTP id l24-20020a170906a41800b007a5e9449e48mr53525435ejz.109.1669812073923;
        Wed, 30 Nov 2022 04:41:13 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id p26-20020a17090653da00b007417041fb2bsm601340ejo.116.2022.11.30.04.41.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Nov 2022 04:41:13 -0800 (PST)
Date:   Wed, 30 Nov 2022 13:41:12 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Vadim Fedorenko <vfedorenko@novek.ru>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Vadim Fedorenko <vadfed@fb.com>,
        linux-arm-kernel@lists.infradead.org, linux-clk@vger.kernel.org
Subject: Re: [RFC PATCH v4 4/4] ptp_ocp: implement DPLL ops
Message-ID: <Y4dPaHx1kT3A80n/@nanopsycho>
References: <20221129213724.10119-1-vfedorenko@novek.ru>
 <20221129213724.10119-5-vfedorenko@novek.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221129213724.10119-5-vfedorenko@novek.ru>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Nov 29, 2022 at 10:37:24PM CET, vfedorenko@novek.ru wrote:
>From: Vadim Fedorenko <vadfed@fb.com>
>
>Implement basic DPLL operations in ptp_ocp driver as the
>simplest example of using new subsystem.
>
>Signed-off-by: Vadim Fedorenko <vadfed@fb.com>
>---
> drivers/ptp/Kconfig   |   1 +
> drivers/ptp/ptp_ocp.c | 123 +++++++++++++++++++++++++++++-------------
> 2 files changed, 87 insertions(+), 37 deletions(-)
>
>diff --git a/drivers/ptp/Kconfig b/drivers/ptp/Kconfig
>index fe4971b65c64..8c4cfabc1bfa 100644
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
>index 154d58cbd9ce..605853ac4a12 100644
>--- a/drivers/ptp/ptp_ocp.c
>+++ b/drivers/ptp/ptp_ocp.c
>@@ -23,6 +23,8 @@
> #include <linux/mtd/mtd.h>
> #include <linux/nvmem-consumer.h>
> #include <linux/crc16.h>
>+#include <linux/dpll.h>
>+#include <uapi/linux/dpll.h>
> 
> #define PCI_VENDOR_ID_FACEBOOK			0x1d9b
> #define PCI_DEVICE_ID_FACEBOOK_TIMECARD		0x0400
>@@ -353,6 +355,7 @@ struct ptp_ocp {
> 	struct ptp_ocp_signal	signal[4];
> 	struct ptp_ocp_sma_connector sma[4];
> 	const struct ocp_sma_op *sma_op;
>+	struct dpll_device *dpll;
> };
> 
> #define OCP_REQ_TIMESTAMP	BIT(0)
>@@ -835,18 +838,19 @@ static DEFINE_IDR(ptp_ocp_idr);
> struct ocp_selector {
> 	const char *name;
> 	int value;
>+	int dpll_type;
> };
> 
> static const struct ocp_selector ptp_ocp_clock[] = {
>-	{ .name = "NONE",	.value = 0 },
>-	{ .name = "TOD",	.value = 1 },
>-	{ .name = "IRIG",	.value = 2 },
>-	{ .name = "PPS",	.value = 3 },
>-	{ .name = "PTP",	.value = 4 },
>-	{ .name = "RTC",	.value = 5 },
>-	{ .name = "DCF",	.value = 6 },
>-	{ .name = "REGS",	.value = 0xfe },
>-	{ .name = "EXT",	.value = 0xff },
>+	{ .name = "NONE",	.value = 0,		.dpll_type = 0 },
>+	{ .name = "TOD",	.value = 1,		.dpll_type = 0 },
>+	{ .name = "IRIG",	.value = 2,		.dpll_type = 0 },
>+	{ .name = "PPS",	.value = 3,		.dpll_type = 0 },
>+	{ .name = "PTP",	.value = 4,		.dpll_type = 0 },
>+	{ .name = "RTC",	.value = 5,		.dpll_type = 0 },
>+	{ .name = "DCF",	.value = 6,		.dpll_type = 0 },
>+	{ .name = "REGS",	.value = 0xfe,		.dpll_type = 0 },
>+	{ .name = "EXT",	.value = 0xff,		.dpll_type = 0 },
> 	{ }
> };
> 
>@@ -855,37 +859,37 @@ static const struct ocp_selector ptp_ocp_clock[] = {
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
>+	{ .name = "10Mhz",	.value = 0x0000,	.dpll_type = DPLL_PIN_SIGNAL_TYPE_10_MHZ },
>+	{ .name = "PPS1",	.value = 0x0001,	.dpll_type = DPLL_PIN_SIGNAL_TYPE_1_PPS },
>+	{ .name = "PPS2",	.value = 0x0002,	.dpll_type = DPLL_PIN_SIGNAL_TYPE_1_PPS },
>+	{ .name = "TS1",	.value = 0x0004,	.dpll_type = DPLL_PIN_SIGNAL_TYPE_CUSTOM_FREQ },
>+	{ .name = "TS2",	.value = 0x0008,	.dpll_type = DPLL_PIN_SIGNAL_TYPE_CUSTOM_FREQ },
>+	{ .name = "IRIG",	.value = 0x0010,	.dpll_type = DPLL_PIN_SIGNAL_TYPE_CUSTOM_FREQ },
>+	{ .name = "DCF",	.value = 0x0020,	.dpll_type = DPLL_PIN_SIGNAL_TYPE_CUSTOM_FREQ },
>+	{ .name = "TS3",	.value = 0x0040,	.dpll_type = DPLL_PIN_SIGNAL_TYPE_CUSTOM_FREQ },
>+	{ .name = "TS4",	.value = 0x0080,	.dpll_type = DPLL_PIN_SIGNAL_TYPE_CUSTOM_FREQ },
>+	{ .name = "FREQ1",	.value = 0x0100,	.dpll_type = DPLL_PIN_SIGNAL_TYPE_CUSTOM_FREQ },
>+	{ .name = "FREQ2",	.value = 0x0200,	.dpll_type = DPLL_PIN_SIGNAL_TYPE_CUSTOM_FREQ },
>+	{ .name = "FREQ3",	.value = 0x0400,	.dpll_type = DPLL_PIN_SIGNAL_TYPE_CUSTOM_FREQ },
>+	{ .name = "FREQ4",	.value = 0x0800,	.dpll_type = DPLL_PIN_SIGNAL_TYPE_CUSTOM_FREQ },
>+	{ .name = "None",	.value = SMA_DISABLE,	.dpll_type = 0 },
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
>-	{ .name = "GEN1",	.value = 0x0040 },
>-	{ .name = "GEN2",	.value = 0x0080 },
>-	{ .name = "GEN3",	.value = 0x0100 },
>-	{ .name = "GEN4",	.value = 0x0200 },
>-	{ .name = "GND",	.value = 0x2000 },
>-	{ .name = "VCC",	.value = 0x4000 },
>+	{ .name = "10Mhz",	.value = 0x0000,	.dpll_type = DPLL_PIN_SIGNAL_TYPE_10_MHZ },
>+	{ .name = "PHC",	.value = 0x0001,	.dpll_type = DPLL_PIN_SIGNAL_TYPE_CUSTOM_FREQ },
>+	{ .name = "MAC",	.value = 0x0002,	.dpll_type = DPLL_PIN_SIGNAL_TYPE_CUSTOM_FREQ },
>+	{ .name = "GNSS1",	.value = 0x0004,	.dpll_type = DPLL_PIN_SIGNAL_TYPE_1_PPS },
>+	{ .name = "GNSS2",	.value = 0x0008,	.dpll_type = DPLL_PIN_SIGNAL_TYPE_1_PPS },
>+	{ .name = "IRIG",	.value = 0x0010,	.dpll_type = DPLL_PIN_SIGNAL_TYPE_CUSTOM_FREQ },
>+	{ .name = "DCF",	.value = 0x0020,	.dpll_type = DPLL_PIN_SIGNAL_TYPE_CUSTOM_FREQ },
>+	{ .name = "GEN1",	.value = 0x0040,	.dpll_type = DPLL_PIN_SIGNAL_TYPE_CUSTOM_FREQ },
>+	{ .name = "GEN2",	.value = 0x0080,	.dpll_type = DPLL_PIN_SIGNAL_TYPE_CUSTOM_FREQ },
>+	{ .name = "GEN3",	.value = 0x0100,	.dpll_type = DPLL_PIN_SIGNAL_TYPE_CUSTOM_FREQ },
>+	{ .name = "GEN4",	.value = 0x0200,	.dpll_type = DPLL_PIN_SIGNAL_TYPE_CUSTOM_FREQ },
>+	{ .name = "GND",	.value = 0x2000,	.dpll_type = 0 },
>+	{ .name = "VCC",	.value = 0x4000,	.dpll_type = 0 },
> 	{ }
> };
> 
>@@ -4175,12 +4179,41 @@ ptp_ocp_detach(struct ptp_ocp *bp)
> 	device_unregister(&bp->dev);
> }
> 
>+static int ptp_ocp_dpll_get_attr(struct dpll_device *dpll, struct dpll_attr *attr)
>+{
>+	struct ptp_ocp *bp = (struct ptp_ocp *)dpll_priv(dpll);
>+	int sync;
>+
>+	sync = ioread32(&bp->reg->status) & OCP_STATUS_IN_SYNC;
>+	dpll_attr_lock_status_set(attr, sync ? DPLL_LOCK_STATUS_LOCKED : DPLL_LOCK_STATUS_UNLOCKED);

get,set,confuse. This attr thing sucks, sorry :/


>+
>+	return 0;
>+}
>+
>+static int ptp_ocp_dpll_pin_get_attr(struct dpll_device *dpll, struct dpll_pin *pin,
>+				     struct dpll_pin_attr *attr)
>+{
>+	dpll_pin_attr_type_set(attr, DPLL_PIN_TYPE_EXT);

This is exactly what I was talking about in the cover letter. This is
const, should be put into static struct and passed to
dpll_device_alloc().


>+	return 0;
>+}
>+
>+static struct dpll_device_ops dpll_ops = {
>+	.get	= ptp_ocp_dpll_get_attr,
>+};
>+
>+static struct dpll_pin_ops dpll_pin_ops = {
>+	.get	= ptp_ocp_dpll_pin_get_attr,
>+};
>+
> static int
> ptp_ocp_probe(struct pci_dev *pdev, const struct pci_device_id *id)
> {
>+	const u8 dpll_cookie[DPLL_COOKIE_LEN] = { "OCP" };
>+	char pin_desc[PIN_DESC_LEN];
> 	struct devlink *devlink;
>+	struct dpll_pin *pin;
> 	struct ptp_ocp *bp;
>-	int err;
>+	int err, i;
> 
> 	devlink = devlink_alloc(&ptp_ocp_devlink_ops, sizeof(*bp), &pdev->dev);
> 	if (!devlink) {
>@@ -4230,6 +4263,20 @@ ptp_ocp_probe(struct pci_dev *pdev, const struct pci_device_id *id)
> 
> 	ptp_ocp_info(bp);
> 	devlink_register(devlink);
>+
>+	bp->dpll = dpll_device_alloc(&dpll_ops, DPLL_TYPE_PPS, dpll_cookie, pdev->bus->number, bp, &pdev->dev);
>+	if (!bp->dpll) {
>+		dev_err(&pdev->dev, "dpll_device_alloc failed\n");
>+		goto out;
>+	}
>+	dpll_device_register(bp->dpll);

You still have the 2 step init process. I believe it would be better to
just have dpll_device_create/destroy() to do it in one shot.


>+
>+	for (i = 0; i < 4; i++) {
>+		snprintf(pin_desc, PIN_DESC_LEN, "sma%d", i + 1);
>+		pin = dpll_pin_alloc(pin_desc, PIN_DESC_LEN);
>+		dpll_pin_register(bp->dpll, pin, &dpll_pin_ops, bp);

Same here, no point of having 2 step init.


>+	}
>+
> 	return 0;


Btw, did you consider having dpll instance here as and auxdev? It would
be suitable I believe. It is quite simple to do it. See following patch
as an example:

commit bd02fd76d1909637c95e8ef13e7fd1e748af910d
Author: Jiri Pirko <jiri@nvidia.com>
Date:   Mon Jul 25 10:29:17 2022 +0200

    mlxsw: core_linecards: Introduce per line card auxiliary device




> 
> out:
>@@ -4247,6 +4294,8 @@ ptp_ocp_remove(struct pci_dev *pdev)
> 	struct ptp_ocp *bp = pci_get_drvdata(pdev);
> 	struct devlink *devlink = priv_to_devlink(bp);
> 
>+	dpll_device_unregister(bp->dpll);
>+	dpll_device_free(bp->dpll);
> 	devlink_unregister(devlink);
> 	ptp_ocp_detach(bp);
> 	pci_disable_device(pdev);
>-- 
>2.27.0
>
