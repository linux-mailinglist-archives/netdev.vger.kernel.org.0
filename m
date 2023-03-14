Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F0DF6B8F38
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 11:05:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229960AbjCNKFY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 06:05:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229886AbjCNKFW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 06:05:22 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6A8C637F0
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 03:05:18 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id k25-20020a7bc419000000b003ed23114fa7so4017907wmi.4
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 03:05:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112; t=1678788317;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=mHJ2BlNCHzZNJ+PeIcSkNJ8xPYEE7jjHajBGYh/Esp0=;
        b=0eUvRPd0LEFKeN4ExLeUPUM6orE75LEkykN2PyFpe9qWWgVjBIccJylxTRLnXleCvx
         p9JQJ7Bx6dIuNwi5mEnQeT0Pv8OocozwlTAvcpMILbJ2wfYofYbsMYntbQzLMdTeluW6
         T/IUS7EKDIthBiMvi/DGzPJNnm8vsZET0NuJ0hJdVxl2WmrTsmEhfA1tMF924vIxEhKY
         Yllu/vHWXZA5iIr3LCeadS2YrXXnV7qLWZ7PoStnjf7REhT3nhfb32v6ipq9VNXHCUQM
         hhwyEskq49ZzY5pA9sV1OYe8VsT9CGO+0vjWMd5xR0SE/QMZAATwDVp7WU490yAUh9qi
         UYwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678788317;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mHJ2BlNCHzZNJ+PeIcSkNJ8xPYEE7jjHajBGYh/Esp0=;
        b=TyWM6O0ZMTormF0Rnb/cFNUREa25uuBjzPmf6P/niO5to0rJ43/NrdsLDiywGRQKKr
         bop1rOhCRPrjp0CDSmbFkSnXQMfgEFzTQeKIqHmvz+H6eGoxd6f6dZYnboCAsWwUxivr
         Xb7iU6kWaijsHnkLPOYVqCOHsJ/BxiWHCr1eNssMWO0P7CpIVzfef+cAF9J7wo1LalKD
         p/htzCAAfY4GDEzNkXwNnAUVDm2wGKOuFLYj0bWcBqWXegoIyE//TVtw5LbCzm02toOf
         TuY5Ew5knMIGbzWfFTyRhggUvmOy5COpsHuRix0OYovw0AjTbVxRQtS09yJgj8dFBKpY
         S4GQ==
X-Gm-Message-State: AO0yUKUxNHW0nynomklp3b6CsYUkGZBSTb5NsrceK7jpFl0OCdBF2jNi
        YF00UOk63iTQqjp0PIrA5SWSiA==
X-Google-Smtp-Source: AK7set/vhWMaj3UeJQAuytBkmY8X1MYJemK0fnWlGedVGfe6JJpKzV3Azij69JVdWVDCQ8sXCGzCJA==
X-Received: by 2002:a05:600c:3107:b0:3dc:55d9:ec8 with SMTP id g7-20020a05600c310700b003dc55d90ec8mr12834473wmo.41.1678788317055;
        Tue, 14 Mar 2023 03:05:17 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id g15-20020a05600c310f00b003dc4480df80sm2500582wmo.34.2023.03.14.03.05.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Mar 2023 03:05:16 -0700 (PDT)
Date:   Tue, 14 Mar 2023 11:05:15 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Vadim Fedorenko <vadfed@meta.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Vadim Fedorenko <vadim.fedorenko@linux.dev>, poros@redhat.com,
        mschmidt@redhat.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-clk@vger.kernel.org
Subject: Re: [PATCH RFC v6 6/6] ptp_ocp: implement DPLL ops
Message-ID: <ZBBG2xRhLOIPMD0+@nanopsycho>
References: <20230312022807.278528-1-vadfed@meta.com>
 <20230312022807.278528-7-vadfed@meta.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230312022807.278528-7-vadfed@meta.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sun, Mar 12, 2023 at 03:28:07AM CET, vadfed@meta.com wrote:
>Implement basic DPLL operations in ptp_ocp driver as the
>simplest example of using new subsystem.
>
>Signed-off-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
>---
> drivers/ptp/Kconfig   |   1 +
> drivers/ptp/ptp_ocp.c | 209 ++++++++++++++++++++++++++++++++++++++++--
> 2 files changed, 200 insertions(+), 10 deletions(-)
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
>index 4bbaccd543ad..02c95e724ec8 100644
>--- a/drivers/ptp/ptp_ocp.c
>+++ b/drivers/ptp/ptp_ocp.c
>@@ -23,6 +23,8 @@
> #include <linux/mtd/mtd.h>
> #include <linux/nvmem-consumer.h>
> #include <linux/crc16.h>
>+#include <linux/dpll.h>
>+#include <uapi/linux/dpll.h>

Don't include UAPI directly. I'm pretty sure I had this comment earlier.


> 
> #define PCI_VENDOR_ID_FACEBOOK			0x1d9b
> #define PCI_DEVICE_ID_FACEBOOK_TIMECARD		0x0400
>@@ -267,6 +269,7 @@ struct ptp_ocp_sma_connector {
> 	bool	fixed_dir;
> 	bool	disabled;
> 	u8	default_fcn;
>+	struct dpll_pin *dpll_pin;
> };
> 
> struct ocp_attr_group {
>@@ -353,6 +356,7 @@ struct ptp_ocp {
> 	struct ptp_ocp_signal	signal[4];
> 	struct ptp_ocp_sma_connector sma[4];

It is quite customary to use defines for const numbers like this. Why
don't you do that in ptp_ocp?


> 	const struct ocp_sma_op *sma_op;
>+	struct dpll_device *dpll;
> };
> 
> #define OCP_REQ_TIMESTAMP	BIT(0)
>@@ -2689,16 +2693,9 @@ sma4_show(struct device *dev, struct device_attribute *attr, char *buf)
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
>@@ -2733,6 +2730,21 @@ ptp_ocp_sma_store(struct ptp_ocp *bp, const char *buf, int sma_nr)
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
>+
>+	return ptp_ocp_sma_store_val(bp, val, mode, sma_nr);
>+}
>+
> static ssize_t
> sma1_store(struct device *dev, struct device_attribute *attr,
> 	   const char *buf, size_t count)
>@@ -4171,12 +4183,151 @@ ptp_ocp_detach(struct ptp_ocp *bp)
> 	device_unregister(&bp->dev);
> }
> 
>+static int ptp_ocp_dpll_pin_to_sma(const struct ptp_ocp *bp, const struct dpll_pin *pin)
>+{
>+	int i;
>+
>+	for (i = 0; i < 4; i++) {
>+		if (bp->sma[i].dpll_pin == pin)
>+			return i;

Just pass &bp->sma[i] as a priv to dpll_pin_register().
and get that pointer directly in pin ops. No need for lookup and use of
sma_nr at all.


>+	}
>+	return -1;
>+}
>+
>+static int ptp_ocp_dpll_lock_status_get(const struct dpll_device *dpll,
>+				    enum dpll_lock_status *status,
>+				    struct netlink_ext_ack *extack)
>+{
>+	struct ptp_ocp *bp = (struct ptp_ocp *)dpll_priv(dpll);

No need to cast (void *), remove it.


>+	int sync;
>+
>+	sync = ioread32(&bp->reg->status) & OCP_STATUS_IN_SYNC;
>+	*status = sync ? DPLL_LOCK_STATUS_LOCKED : DPLL_LOCK_STATUS_UNLOCKED;
>+
>+	return 0;
>+}
>+
>+static int ptp_ocp_dpll_source_idx_get(const struct dpll_device *dpll,
>+				    u32 *idx, struct netlink_ext_ack *extack)
>+{
>+	struct ptp_ocp *bp = (struct ptp_ocp *)dpll_priv(dpll);
>+
>+	if (bp->pps_select) {
>+		*idx = ioread32(&bp->pps_select->gpio1);
>+		return 0;
>+	}
>+	return -EINVAL;
>+}
>+
>+static int ptp_ocp_dpll_mode_get(const struct dpll_device *dpll,
>+				    u32 *mode, struct netlink_ext_ack *extack)
>+{
>+	*mode = DPLL_MODE_AUTOMATIC;
>+

No need for empty line, I believe.


>+	return 0;
>+}
>+
>+static bool ptp_ocp_dpll_mode_supported(const struct dpll_device *dpll,
>+				    const enum dpll_mode mode,
>+				    struct netlink_ext_ack *extack)
>+{
>+	if (mode == DPLL_MODE_AUTOMATIC)
>+		return true;
>+
>+	return false;

Just:
	return mode == DPLL_MODE_AUTOMATIC;

>+}
>+
>+static int ptp_ocp_dpll_direction_get(const struct dpll_pin *pin,
>+				     const struct dpll_device *dpll,
>+				     enum dpll_pin_direction *direction,
>+				     struct netlink_ext_ack *extack)
>+{
>+	struct ptp_ocp *bp = (struct ptp_ocp *)dpll_priv(dpll);
>+	int sma_nr = ptp_ocp_dpll_pin_to_sma(bp, pin);
>+
>+	if (sma_nr < 0)
>+		return -EINVAL;
>+
>+	*direction = bp->sma[sma_nr].mode == SMA_MODE_IN ? DPLL_PIN_DIRECTION_SOURCE :
>+							   DPLL_PIN_DIRECTION_OUTPUT;
>+	return 0;
>+}
>+
>+static int ptp_ocp_dpll_direction_set(const struct dpll_pin *pin,
>+				     const struct dpll_device *dpll,
>+				     enum dpll_pin_direction direction,
>+				     struct netlink_ext_ack *extack)
>+{
>+	struct ptp_ocp *bp = (struct ptp_ocp *)dpll_priv(dpll);
>+	int sma_nr = ptp_ocp_dpll_pin_to_sma(bp, pin);
>+	enum ptp_ocp_sma_mode mode;
>+
>+	if (sma_nr < 0)
>+		return -EINVAL;
>+
>+	mode = direction == DPLL_PIN_DIRECTION_SOURCE ? SMA_MODE_IN : SMA_MODE_OUT;
>+	return ptp_ocp_sma_store_val(bp, 0, mode, sma_nr);
>+}
>+
>+static int ptp_ocp_dpll_frequency_set(const struct dpll_pin *pin,
>+			      const struct dpll_device *dpll,
>+			      const u32 frequency,

Why you need const for u32?


>+			      struct netlink_ext_ack *extack)
>+{
>+	struct ptp_ocp *bp = (struct ptp_ocp *)dpll_priv(dpll);
>+	int sma_nr = ptp_ocp_dpll_pin_to_sma(bp, pin);
>+	int val = frequency == 10000000 ? 0 : 1;

This is weird. I believe you should handle unsupported frequencies
gracefully.


>+
>+	if (sma_nr < 0)
>+		return -EINVAL;
>+
>+

Avoid double empty lines.


>+	return ptp_ocp_sma_store_val(bp, val, bp->sma[sma_nr].mode, sma_nr);
>+}
>+
>+static int ptp_ocp_dpll_frequency_get(const struct dpll_pin *pin,
>+			      const struct dpll_device *dpll,
>+			      u32 *frequency,
>+			      struct netlink_ext_ack *extack)
>+{
>+	struct ptp_ocp *bp = (struct ptp_ocp *)dpll_priv(dpll);
>+	int sma_nr = ptp_ocp_dpll_pin_to_sma(bp, pin);
>+	u32 val;
>+
>+	if (sma_nr < 0)
>+		return -EINVAL;
>+
>+	val = bp->sma_op->get(bp, sma_nr);
>+	if (!val)
>+		*frequency = 1000000;
>+	else
>+		*frequency = 0;

I don't follow. How the frequency could be 0? Does that mean that the
pin is disabled? If yes, you should rather implement
.state_on_dpll_get
.state_on_dpll_set

and leave the frequency constant.


>+	return 0;
>+}
>+
>+static struct dpll_device_ops dpll_ops = {

const


>+	.lock_status_get = ptp_ocp_dpll_lock_status_get,
>+	.source_pin_idx_get = ptp_ocp_dpll_source_idx_get,

Should be called "source_pin_get" and return (struct dpll_pin *)
On the driver api level, no reason to pass indexes. Work with objects.


>+	.mode_get = ptp_ocp_dpll_mode_get,
>+	.mode_supported = ptp_ocp_dpll_mode_supported,
>+};
>+
>+static struct dpll_pin_ops dpll_pins_ops = {

const


>+	.frequency_get = ptp_ocp_dpll_frequency_get,
>+	.frequency_set = ptp_ocp_dpll_frequency_set,
>+	.direction_get = ptp_ocp_dpll_direction_get,
>+	.direction_set = ptp_ocp_dpll_direction_set,
>+};
>+
> static int
> ptp_ocp_probe(struct pci_dev *pdev, const struct pci_device_id *id)
> {
>+	struct dpll_pin_properties prop;
> 	struct devlink *devlink;
>+	char sma[4] = "SMA0";

Won't fit. Just use:
char *sma = "SMA0"
to be safe


> 	struct ptp_ocp *bp;
>-	int err;
>+	int err, i;
>+	u64 clkid;
> 
> 	devlink = devlink_alloc(&ptp_ocp_devlink_ops, sizeof(*bp), &pdev->dev);
> 	if (!devlink) {
>@@ -4226,8 +4377,44 @@ ptp_ocp_probe(struct pci_dev *pdev, const struct pci_device_id *id)
> 
> 	ptp_ocp_info(bp);
> 	devlink_register(devlink);
>-	return 0;
> 
>+	clkid = pci_get_dsn(pdev);
>+	bp->dpll = dpll_device_get(clkid, 0, THIS_MODULE);
>+	if (!bp->dpll) {
>+		dev_err(&pdev->dev, "dpll_device_alloc failed\n");
>+		goto out;
>+	}
>+
>+	err = dpll_device_register(bp->dpll, DPLL_TYPE_PPS, &dpll_ops, bp, &pdev->dev);
>+	if (err)
>+		goto out;
>+
>+	prop.description = &sma[0];
>+	prop.freq_supported = DPLL_PIN_FREQ_SUPP_MAX;
>+	prop.type = DPLL_PIN_TYPE_EXT;
>+	prop.any_freq_max = 10000000;
>+	prop.any_freq_min = 0;
>+	prop.capabilities = DPLL_PIN_CAPS_DIRECTION_CAN_CHANGE;
>+
>+	for (i = 0; i < 4; i++) {
>+		sma[3] = 0x31 + i;

Ugh. Just use the static const array as I suggested in the dpll patch
reply. Helps you avoid this sort of "magic".


>+		bp->sma[i].dpll_pin = dpll_pin_get(clkid, i, THIS_MODULE, &prop);
>+		if (IS_ERR_OR_NULL(bp->sma[i].dpll_pin)) {

How it could be NULL?


>+			bp->sma[i].dpll_pin = NULL;

This would not be needed if the error path iterates over
indexes which were successul.


>+			goto out_dpll;
>+		}
>+		err = dpll_pin_register(bp->dpll, bp->sma[i].dpll_pin, &dpll_pins_ops, bp, NULL);
>+		if (err)
>+			goto out_dpll;
>+	}
>+
>+	return 0;
>+out_dpll:
>+	for (i = 0; i < 4; i++) {
>+		if (bp->sma[i].dpll_pin)

You don't do unregister of pin here.


>+			dpll_pin_put(bp->sma[i].dpll_pin);
>+	}
>+	dpll_device_put(bp->dpll);
> out:
> 	ptp_ocp_detach(bp);
> out_disable:
>@@ -4243,6 +4430,8 @@ ptp_ocp_remove(struct pci_dev *pdev)
> 	struct ptp_ocp *bp = pci_get_drvdata(pdev);
> 	struct devlink *devlink = priv_to_devlink(bp);
> 
>+	dpll_device_unregister(bp->dpll);
>+	dpll_device_put(bp->dpll);
> 	devlink_unregister(devlink);
> 	ptp_ocp_detach(bp);
> 	pci_disable_device(pdev);
>-- 
>2.34.1
>
