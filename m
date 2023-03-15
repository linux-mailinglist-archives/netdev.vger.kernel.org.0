Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 693CE6BB142
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 13:26:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232467AbjCOMZ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 08:25:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232259AbjCOMZj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 08:25:39 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D49E94F73
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 05:24:45 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id l7-20020a05600c1d0700b003eb5e6d906bso1069840wms.5
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 05:24:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112; t=1678883084;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=N8Q16rN2NC1bUs0QIqv2nI8RfdbcEWG6Vm+CziVAYyg=;
        b=XrRTA92pEHcNrFy9rxSNXyh4JU2gg74xZKKlfIIYz1x3OPCPRnTtvpF3V6ZJ1uZjdc
         ZFUUa+aLky5M2zoTjnw/ltjuwh8XYetA0lhkRl74E5/RjxjSdn02nGk9r94BFKkjNsoA
         D6QgrmBjeRd13wiaaviVqy6udNv3bgPaqsZUeDaSa37j7dcxvyAlnUQLCRyh9OIGSObH
         QT5Q6RtKpgZ4EgaXgLztjzPyij1o5tTKbjjhQbYh6jWFJqGuNoa8Y4ptbS6//GC275d1
         vzQQacT2e9zvNBrwRXIxMiZjJZYDcmNmNSCw8ek7kkAtNOEWgHLoX0wkKo9NUwsEct7H
         mJ5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678883084;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=N8Q16rN2NC1bUs0QIqv2nI8RfdbcEWG6Vm+CziVAYyg=;
        b=0EqJLRQ7CAxspZhG+L8RmyA+33B8JlhUwDHOlVKz8NtH8ebTUbrwCfCyc/U2VTm7tN
         Qusmw5oQEpl/gLJIjnMFguLZ4fyhFatwdzkb7faoBTOTENBDnEujpPm35I3V+AYSSKcI
         MFhM7rSoPCkpaVkoOSnXYJ8jlhXmQTR3LniuUmSaXftZ5SR8E2dGRE9IcoFoMdmgUVlf
         mHnVc+yZVShqSYJDoNc7kY/p4HZ6YU2WZjws8Qi9R5avpf0DUVJ581ufMWoD85pF8dR+
         y4zxgfD/VZaEs1VxqRiah2wDOpySS5tVw6loWUdl8zoReyXR/ewm3XlRUdsQjEqygr4t
         UHsQ==
X-Gm-Message-State: AO0yUKVfK0z8xehDlLgPJqp22zl4jOQhgF4wtOroQGfl9/hXuV6R/aWS
        KiscrHoVjr821x89Zaz3WFYJmA==
X-Google-Smtp-Source: AK7set9CxeX6fv+kK+SIgm8U/7uBdHsaSF7lKLMdNpjeUv3AfGy51YiWbwR75EdQ9qxaVheAt/ls6Q==
X-Received: by 2002:a05:600c:1912:b0:3ed:2217:4636 with SMTP id j18-20020a05600c191200b003ed22174636mr10441630wmq.19.1678883084004;
        Wed, 15 Mar 2023 05:24:44 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id k26-20020a7bc31a000000b003eb596cbc54sm1856832wmj.0.2023.03.15.05.24.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Mar 2023 05:24:43 -0700 (PDT)
Date:   Wed, 15 Mar 2023 13:24:42 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Vadim Fedorenko <vadim.fedorenko@linux.dev>
Cc:     Vadim Fedorenko <vadfed@meta.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>, poros@redhat.com,
        mschmidt@redhat.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-clk@vger.kernel.org
Subject: Re: [PATCH RFC v6 6/6] ptp_ocp: implement DPLL ops
Message-ID: <ZBG5CpF/o2wZkgSX@nanopsycho>
References: <20230312022807.278528-1-vadfed@meta.com>
 <20230312022807.278528-7-vadfed@meta.com>
 <ZBBG2xRhLOIPMD0+@nanopsycho>
 <d192e0ac-3fa3-c799-ac93-84a17e6f6d50@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d192e0ac-3fa3-c799-ac93-84a17e6f6d50@linux.dev>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Mar 15, 2023 at 01:10:33AM CET, vadim.fedorenko@linux.dev wrote:
>On 14/03/2023 10:05, Jiri Pirko wrote:
>> Sun, Mar 12, 2023 at 03:28:07AM CET, vadfed@meta.com wrote:
>> > Implement basic DPLL operations in ptp_ocp driver as the
>> > simplest example of using new subsystem.
>> > 
>> > Signed-off-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
>> > ---
>> > drivers/ptp/Kconfig   |   1 +
>> > drivers/ptp/ptp_ocp.c | 209 ++++++++++++++++++++++++++++++++++++++++--
>> > 2 files changed, 200 insertions(+), 10 deletions(-)
>> > 
>> > diff --git a/drivers/ptp/Kconfig b/drivers/ptp/Kconfig
>> > index fe4971b65c64..8c4cfabc1bfa 100644
>> > --- a/drivers/ptp/Kconfig
>> > +++ b/drivers/ptp/Kconfig
>> > @@ -177,6 +177,7 @@ config PTP_1588_CLOCK_OCP
>> > 	depends on COMMON_CLK
>> > 	select NET_DEVLINK
>> > 	select CRC16
>> > +	select DPLL
>> > 	help
>> > 	  This driver adds support for an OpenCompute time card.
>> > 
>> > diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
>> > index 4bbaccd543ad..02c95e724ec8 100644
>> > --- a/drivers/ptp/ptp_ocp.c
>> > +++ b/drivers/ptp/ptp_ocp.c
>> > @@ -23,6 +23,8 @@
>> > #include <linux/mtd/mtd.h>
>> > #include <linux/nvmem-consumer.h>
>> > #include <linux/crc16.h>
>> > +#include <linux/dpll.h>
>> > +#include <uapi/linux/dpll.h>
>> 
>> Don't include UAPI directly. I'm pretty sure I had this comment earlier.
>> 
>
>Ah, yeah, you've mentioned it for ice driver last time, but I forgot to check
>it here. Removed.
>
>> 
>> > 
>> > #define PCI_VENDOR_ID_FACEBOOK			0x1d9b
>> > #define PCI_DEVICE_ID_FACEBOOK_TIMECARD		0x0400
>> > @@ -267,6 +269,7 @@ struct ptp_ocp_sma_connector {
>> > 	bool	fixed_dir;
>> > 	bool	disabled;
>> > 	u8	default_fcn;
>> > +	struct dpll_pin *dpll_pin;
>> > };
>> > 
>> > struct ocp_attr_group {
>> > @@ -353,6 +356,7 @@ struct ptp_ocp {
>> > 	struct ptp_ocp_signal	signal[4];
>> > 	struct ptp_ocp_sma_connector sma[4];
>> 
>> It is quite customary to use defines for const numbers like this. Why
>> don't you do that in ptp_ocp?
>
>Historical reasons. Jonathan might answer this question.
>I will add it to my TODO list for the driver.
>
>> > 	const struct ocp_sma_op *sma_op;
>> > +	struct dpll_device *dpll;
>> > };
>> > 
>> > #define OCP_REQ_TIMESTAMP	BIT(0)
>> > @@ -2689,16 +2693,9 @@ sma4_show(struct device *dev, struct device_attribute *attr, char *buf)
>> > }
>> > 
>> > static int
>> > -ptp_ocp_sma_store(struct ptp_ocp *bp, const char *buf, int sma_nr)
>> > +ptp_ocp_sma_store_val(struct ptp_ocp *bp, int val, enum ptp_ocp_sma_mode mode, int sma_nr)
>> > {
>> > 	struct ptp_ocp_sma_connector *sma = &bp->sma[sma_nr - 1];
>> > -	enum ptp_ocp_sma_mode mode;
>> > -	int val;
>> > -
>> > -	mode = sma->mode;
>> > -	val = sma_parse_inputs(bp->sma_op->tbl, buf, &mode);
>> > -	if (val < 0)
>> > -		return val;
>> > 
>> > 	if (sma->fixed_dir && (mode != sma->mode || val & SMA_DISABLE))
>> > 		return -EOPNOTSUPP;
>> > @@ -2733,6 +2730,21 @@ ptp_ocp_sma_store(struct ptp_ocp *bp, const char *buf, int sma_nr)
>> > 	return val;
>> > }
>> > 
>> > +static int
>> > +ptp_ocp_sma_store(struct ptp_ocp *bp, const char *buf, int sma_nr)
>> > +{
>> > +	struct ptp_ocp_sma_connector *sma = &bp->sma[sma_nr - 1];
>> > +	enum ptp_ocp_sma_mode mode;
>> > +	int val;
>> > +
>> > +	mode = sma->mode;
>> > +	val = sma_parse_inputs(bp->sma_op->tbl, buf, &mode);
>> > +	if (val < 0)
>> > +		return val;
>> > +
>> > +	return ptp_ocp_sma_store_val(bp, val, mode, sma_nr);
>> > +}
>> > +
>> > static ssize_t
>> > sma1_store(struct device *dev, struct device_attribute *attr,
>> > 	   const char *buf, size_t count)
>> > @@ -4171,12 +4183,151 @@ ptp_ocp_detach(struct ptp_ocp *bp)
>> > 	device_unregister(&bp->dev);
>> > }
>> > 
>> > +static int ptp_ocp_dpll_pin_to_sma(const struct ptp_ocp *bp, const struct dpll_pin *pin)
>> > +{
>> > +	int i;
>> > +
>> > +	for (i = 0; i < 4; i++) {
>> > +		if (bp->sma[i].dpll_pin == pin)
>> > +			return i;
>> 
>> Just pass &bp->sma[i] as a priv to dpll_pin_register().
>> and get that pointer directly in pin ops. No need for lookup and use of
>> sma_nr at all.
>
>I'm still thinking about the change that you proposed to remove these
>_priv() helpers. I have to look into ice code to be sure we won't break
>any assumptions in it with moving to additional (void *) parameter.

There are basically 2 ways:
someop(struct subsystemobj *x, void *priv)
{
	struct *mine = priv;
}
or:
someop(struct subsystemobj *x)
{
	struct *mine = subsystem_get_priv(x);
}

Both are more or less equal. The first has benefit that the caller most
usually has direct access to the priv, so it can just easily pass it on.
Also, you as the driver write see right away there is a priv arg and
makes you want to use it and not figure out odd lookups to get to the
same priv.


>
>> 
>> > +	}
>> > +	return -1;
>> > +}
>> > +
>> > +static int ptp_ocp_dpll_lock_status_get(const struct dpll_device *dpll,
>> > +				    enum dpll_lock_status *status,
>> > +				    struct netlink_ext_ack *extack)
>> > +{
>> > +	struct ptp_ocp *bp = (struct ptp_ocp *)dpll_priv(dpll);
>> 
>> No need to cast (void *), remove it.
>> 
>Fixed everywhere in the code, thanks.
>
>
>> 
>> > +	int sync;
>> > +
>> > +	sync = ioread32(&bp->reg->status) & OCP_STATUS_IN_SYNC;
>> > +	*status = sync ? DPLL_LOCK_STATUS_LOCKED : DPLL_LOCK_STATUS_UNLOCKED;
>> > +
>> > +	return 0;
>> > +}
>> > +
>> > +static int ptp_ocp_dpll_source_idx_get(const struct dpll_device *dpll,
>> > +				    u32 *idx, struct netlink_ext_ack *extack)
>> > +{
>> > +	struct ptp_ocp *bp = (struct ptp_ocp *)dpll_priv(dpll);
>> > +
>> > +	if (bp->pps_select) {
>> > +		*idx = ioread32(&bp->pps_select->gpio1);
>> > +		return 0;
>> > +	}
>> > +	return -EINVAL;
>> > +}
>> > +
>> > +static int ptp_ocp_dpll_mode_get(const struct dpll_device *dpll,
>> > +				    u32 *mode, struct netlink_ext_ack *extack)
>> > +{
>> > +	*mode = DPLL_MODE_AUTOMATIC;
>> > +
>> 
>> No need for empty line, I believe.
>
>Ok.
>
>> > +	return 0;
>> > +}
>> > +
>> > +static bool ptp_ocp_dpll_mode_supported(const struct dpll_device *dpll,
>> > +				    const enum dpll_mode mode,
>> > +				    struct netlink_ext_ack *extack)
>> > +{
>> > +	if (mode == DPLL_MODE_AUTOMATIC)
>> > +		return true;
>> > +
>> > +	return false;
>> 
>> Just:
>> 	return mode == DPLL_MODE_AUTOMATIC;
>> 
>Done, thanks!
>
>> > +}
>> > +
>> > +static int ptp_ocp_dpll_direction_get(const struct dpll_pin *pin,
>> > +				     const struct dpll_device *dpll,
>> > +				     enum dpll_pin_direction *direction,
>> > +				     struct netlink_ext_ack *extack)
>> > +{
>> > +	struct ptp_ocp *bp = (struct ptp_ocp *)dpll_priv(dpll);
>> > +	int sma_nr = ptp_ocp_dpll_pin_to_sma(bp, pin);
>> > +
>> > +	if (sma_nr < 0)
>> > +		return -EINVAL;
>> > +
>> > +	*direction = bp->sma[sma_nr].mode == SMA_MODE_IN ? DPLL_PIN_DIRECTION_SOURCE :
>> > +							   DPLL_PIN_DIRECTION_OUTPUT;
>> > +	return 0;
>> > +}
>> > +
>> > +static int ptp_ocp_dpll_direction_set(const struct dpll_pin *pin,
>> > +				     const struct dpll_device *dpll,
>> > +				     enum dpll_pin_direction direction,
>> > +				     struct netlink_ext_ack *extack)
>> > +{
>> > +	struct ptp_ocp *bp = (struct ptp_ocp *)dpll_priv(dpll);
>> > +	int sma_nr = ptp_ocp_dpll_pin_to_sma(bp, pin);
>> > +	enum ptp_ocp_sma_mode mode;
>> > +
>> > +	if (sma_nr < 0)
>> > +		return -EINVAL;
>> > +
>> > +	mode = direction == DPLL_PIN_DIRECTION_SOURCE ? SMA_MODE_IN : SMA_MODE_OUT;
>> > +	return ptp_ocp_sma_store_val(bp, 0, mode, sma_nr);
>> > +}
>> > +
>> > +static int ptp_ocp_dpll_frequency_set(const struct dpll_pin *pin,
>> > +			      const struct dpll_device *dpll,
>> > +			      const u32 frequency,
>> 
>> Why you need const for u32?
>
>No need, true, removed.
>
>> 
>> > +			      struct netlink_ext_ack *extack)
>> > +{
>> > +	struct ptp_ocp *bp = (struct ptp_ocp *)dpll_priv(dpll);
>> > +	int sma_nr = ptp_ocp_dpll_pin_to_sma(bp, pin);
>> > +	int val = frequency == 10000000 ? 0 : 1;
>> 
>> This is weird. I believe you should handle unsupported frequencies
>> gracefully.
>> 
>
>Currently hardware supports fixed frequencies only. That's why I have to
>do this kind of "dance". Hopefully we will improve it to support variable
>frequency.
>
>> 
>> > +
>> > +	if (sma_nr < 0)
>> > +		return -EINVAL;
>> > +
>> > +
>> 
>> Avoid double empty lines.
>> 
>
>Yep.
>
>> 
>> > +	return ptp_ocp_sma_store_val(bp, val, bp->sma[sma_nr].mode, sma_nr);
>> > +}
>> > +
>> > +static int ptp_ocp_dpll_frequency_get(const struct dpll_pin *pin,
>> > +			      const struct dpll_device *dpll,
>> > +			      u32 *frequency,
>> > +			      struct netlink_ext_ack *extack)
>> > +{
>> > +	struct ptp_ocp *bp = (struct ptp_ocp *)dpll_priv(dpll);
>> > +	int sma_nr = ptp_ocp_dpll_pin_to_sma(bp, pin);
>> > +	u32 val;
>> > +
>> > +	if (sma_nr < 0)
>> > +		return -EINVAL;
>> > +
>> > +	val = bp->sma_op->get(bp, sma_nr);
>> > +	if (!val)
>> > +		*frequency = 1000000;
>> > +	else
>> > +		*frequency = 0;
>> 
>> I don't follow. How the frequency could be 0? Does that mean that the
>> pin is disabled? If yes, you should rather implement
>> .state_on_dpll_get
>> .state_on_dpll_set
>> 
>> and leave the frequency constant.
>
>It's actually a mistake. It should be 1 which means 1Hz, PPS. The value
>returned by sma_op->get is actually the type of the signal where 0 is 1PPS, 1
>is 10Mhz and so on.

So you support freq change? In the comment above you wrote "Currently
hardware supports fixed frequencies only". I'm confused.
The point is:
1) if you support freq change, you should sanitize the input properly in
   frequency_set() and return correct actual value in frequency_get()
2) if you don't support freq change, avoid filling-up these ops
   entirely.

>
>> 
>> 
>> > +	return 0;
>> > +}
>> > +
>> > +static struct dpll_device_ops dpll_ops = {
>> 
>> const
>> 
>
>Will change it together with API part. Otherwise it doesn't compile.
>
>> 
>> > +	.lock_status_get = ptp_ocp_dpll_lock_status_get,
>> > +	.source_pin_idx_get = ptp_ocp_dpll_source_idx_get,
>> 
>> Should be called "source_pin_get" and return (struct dpll_pin *)
>> On the driver api level, no reason to pass indexes. Work with objects.
>> 
>
>Good point, will improve it.
>
>> 
>> > +	.mode_get = ptp_ocp_dpll_mode_get,
>> > +	.mode_supported = ptp_ocp_dpll_mode_supported,
>> > +};
>> > +
>> > +static struct dpll_pin_ops dpll_pins_ops = {
>> 
>> const
>> 
>
>Yep.
>
>> 
>> > +	.frequency_get = ptp_ocp_dpll_frequency_get,
>> > +	.frequency_set = ptp_ocp_dpll_frequency_set,
>> > +	.direction_get = ptp_ocp_dpll_direction_get,
>> > +	.direction_set = ptp_ocp_dpll_direction_set,
>> > +};
>> > +
>> > static int
>> > ptp_ocp_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>> > {
>> > +	struct dpll_pin_properties prop;
>> > 	struct devlink *devlink;
>> > +	char sma[4] = "SMA0";
>> 
>> Won't fit. Just use:
>> char *sma = "SMA0"
>> to be safe
>> 
>Got it.
>
>> 
>> > 	struct ptp_ocp *bp;
>> > -	int err;
>> > +	int err, i;
>> > +	u64 clkid;
>> > 
>> > 	devlink = devlink_alloc(&ptp_ocp_devlink_ops, sizeof(*bp), &pdev->dev);
>> > 	if (!devlink) {
>> > @@ -4226,8 +4377,44 @@ ptp_ocp_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>> > 
>> > 	ptp_ocp_info(bp);
>> > 	devlink_register(devlink);
>> > -	return 0;
>> > 
>> > +	clkid = pci_get_dsn(pdev);
>> > +	bp->dpll = dpll_device_get(clkid, 0, THIS_MODULE);
>> > +	if (!bp->dpll) {
>> > +		dev_err(&pdev->dev, "dpll_device_alloc failed\n");
>> > +		goto out;
>> > +	}
>> > +
>> > +	err = dpll_device_register(bp->dpll, DPLL_TYPE_PPS, &dpll_ops, bp, &pdev->dev);
>> > +	if (err)
>> > +		goto out;
>> > +
>> > +	prop.description = &sma[0];
>> > +	prop.freq_supported = DPLL_PIN_FREQ_SUPP_MAX;
>> > +	prop.type = DPLL_PIN_TYPE_EXT;
>> > +	prop.any_freq_max = 10000000;
>> > +	prop.any_freq_min = 0;
>> > +	prop.capabilities = DPLL_PIN_CAPS_DIRECTION_CAN_CHANGE;
>> > +
>> > +	for (i = 0; i < 4; i++) {
>> > +		sma[3] = 0x31 + i;
>> 
>> Ugh. Just use the static const array as I suggested in the dpll patch
>> reply. Helps you avoid this sort of "magic".
>> 
>well, yes. but at the same time Arkadiusz raised a good question about
>accessing driver's memory from the subsystem code - doesn't look clean.

It is completely clean and we do it everywhere in the kernel.
No problem what so ever.


>
>> 
>> > +		bp->sma[i].dpll_pin = dpll_pin_get(clkid, i, THIS_MODULE, &prop);
>> > +		if (IS_ERR_OR_NULL(bp->sma[i].dpll_pin)) {
>> 
>> How it could be NULL?
>> 
>
>Allocation fail?

No? I mean, I don't see such possibility of return value of dpll_pin_get()
Do you see it or are you just guessing? :)


>
>> 
>> > +			bp->sma[i].dpll_pin = NULL;
>> 
>> This would not be needed if the error path iterates over
>> indexes which were successul.
>> 
>
>Yeah, I'll make it the same way it's done in ice.
>
>
>> 
>> > +			goto out_dpll;
>> > +		}
>> > +		err = dpll_pin_register(bp->dpll, bp->sma[i].dpll_pin, &dpll_pins_ops, bp, NULL);
>> > +		if (err)
>> > +			goto out_dpll;
>> > +	}
>> > +
>> > +	return 0;
>> > +out_dpll:
>> > +	for (i = 0; i < 4; i++) {
>> > +		if (bp->sma[i].dpll_pin)
>> 
>> You don't do unregister of pin here.
>> 
>Yeah, actually error path and unload path should be re-implemented.
>
>> 
>> > +			dpll_pin_put(bp->sma[i].dpll_pin);
>> > +	}
>> > +	dpll_device_put(bp->dpll);
>> > out:
>> > 	ptp_ocp_detach(bp);
>> > out_disable:
>> > @@ -4243,6 +4430,8 @@ ptp_ocp_remove(struct pci_dev *pdev)
>> > 	struct ptp_ocp *bp = pci_get_drvdata(pdev);
>> > 	struct devlink *devlink = priv_to_devlink(bp);
>> > 
>> > +	dpll_device_unregister(bp->dpll);
>> > +	dpll_device_put(bp->dpll);
>> > 	devlink_unregister(devlink);
>> > 	ptp_ocp_detach(bp);
>> > 	pci_disable_device(pdev);
>> > -- 
>> > 2.34.1
>> > 
>
