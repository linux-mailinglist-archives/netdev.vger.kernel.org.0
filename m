Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2838563E65F
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 01:20:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229842AbiLAAUG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 19:20:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229800AbiLAATn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 19:19:43 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18CF11C431;
        Wed, 30 Nov 2022 16:17:51 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id z20so235617edc.13;
        Wed, 30 Nov 2022 16:17:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=WVj64qAtRgX8Z3JwUjtW5pZMQEDu05ynwbkezRsMWTo=;
        b=ZTLoFaiLM1GjQoUT4Af8bSKI7sURHwRL+uLvvy3H5ZdYfBlNfGeMjJEyKvLpTK4Ebl
         /8LfB2LlCrtulB4quWhepDZYX/Ptl5DfeKXqTq/avBbGk0KwNa+AQ2d9yI9e9fxfWJid
         NPlmOoAlntvSti27NPEFX1SZurP/gzyrNP8tUzQvCCXN5vqfXpYjF8bf/cvzFtL1zYKB
         LYfnKRq5gEK3vwUVB1+nx4oPcxD4PDaNqd1RQwm5cCR3YIKXhKsb5c0HsSaiBpo94Xwa
         zIkjQaBHCUeX7Ye2jpOq6M1w5GO499bQhf/4dPkmiM2YltB8mKabc5VjzK5fvb49/kBO
         INbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WVj64qAtRgX8Z3JwUjtW5pZMQEDu05ynwbkezRsMWTo=;
        b=VDYO82FEfVTlmk7+Lcynm2Sjey8t72NuwFlj1YumDZ32yNPulMT6eQItdCNFWipT/A
         /rtDm7tEBJAIrexyOtZLWRLHAX8idf3eu/EvkpvDgNHsyQX17fKCIsw712i3ae+7Ex/I
         FwTIvBBqJy7/asFbtYI44/EwQ9CyU6gatBJWYcb0Yt5fsbdnYx+6N0R8WT5k/wWKYURF
         XfkRsyjqCOc9he2oSyrTlrUUG6zalg0P/L2pl8JngAO5+aqqp30dc/aMBKbh/4YdXwj0
         Wlabe7lRCHOusjyiPgvMqCKvCQWW6TuPf8iDWVd9v8olgcixnadqb7Hvd3y9BtgDHtnM
         zKgA==
X-Gm-Message-State: ANoB5pkXPOG1AvJ+oAxeajFda4U3pXJOgxYq+Tf7uD8uFmZZM4qm8LjH
        3rSppT0dKlgEDHsbkSyuvac=
X-Google-Smtp-Source: AA0mqf5OZFJCDSDqIKa5+5rwnnaAdtR1yzwn3AJ0fet0dKcApeChDz6p34VPQvl8rctUq2WvumWHyA==
X-Received: by 2002:a05:6402:e8c:b0:468:89dd:aa0b with SMTP id h12-20020a0564020e8c00b0046889ddaa0bmr58449815eda.258.1669853869442;
        Wed, 30 Nov 2022 16:17:49 -0800 (PST)
Received: from skbuf ([188.26.184.222])
        by smtp.gmail.com with ESMTPSA id vf6-20020a170907238600b007bebfc97f44sm1154921ejb.75.2022.11.30.16.17.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Nov 2022 16:17:49 -0800 (PST)
Date:   Thu, 1 Dec 2022 02:17:46 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Arun Ramadoss <arun.ramadoss@microchip.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux@armlinux.org.uk,
        Tristram.Ha@microchip.com, richardcochran@gmail.com,
        ceggers@arri.de
Subject: Re: [Patch net-next v1 01/12] net: dsa: microchip: ptp: add the
 posix clock support
Message-ID: <20221201001746.ha72fty32s6ckvu6@skbuf>
References: <20221128103227.23171-1-arun.ramadoss@microchip.com>
 <20221128103227.23171-1-arun.ramadoss@microchip.com>
 <20221128103227.23171-2-arun.ramadoss@microchip.com>
 <20221128103227.23171-2-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221128103227.23171-2-arun.ramadoss@microchip.com>
 <20221128103227.23171-2-arun.ramadoss@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 28, 2022 at 04:02:16PM +0530, Arun Ramadoss wrote:
> From: Christian Eggers <ceggers@arri.de>
> 
> This patch implement routines (adjfine, adjtime, gettime and settime)
> for manipulating the chip's PTP clock. It registers the ptp caps
> to posix clock register.
> 
> Signed-off-by: Christian Eggers <ceggers@arri.de>
> Co-developed-by: Arun Ramadoss <arun.ramadoss@microchip.com>
> Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
> 
> ---
> RFC v2 -> Patch v1
> - Repharsed the Kconfig help text
> - Removed IS_ERR_OR_NULL check in ptp_clock_unregister
> - Add the check for ptp_data->clock in ksz_ptp_ts_info
> - Renamed MAX_DRIFT_CORR to KSZ_MAX_DRIFT_CORR
> - Removed the comments
> - Variables declaration in reverse christmas tree
> - Added the ptp_clock_optional
> ---
> diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
> index c6726cbd5465..5a6bfd42c6f9 100644
> --- a/drivers/net/dsa/microchip/ksz_common.h
> +++ b/drivers/net/dsa/microchip/ksz_common.h
> @@ -444,6 +447,19 @@ static inline int ksz_write32(struct ksz_device *dev, u32 reg, u32 value)
>  	return ret;
>  }
>  
> +static inline int ksz_rmw16(struct ksz_device *dev, u32 reg, u16 mask,
> +			    u16 value)
> +{
> +	int ret;
> +
> +	ret = regmap_update_bits(dev->regmap[1], reg, mask, value);
> +	if (ret)
> +		dev_err(dev->dev, "can't rmw 16bit reg: 0x%x %pe\n", reg,
> +			ERR_PTR(ret));

Is the colon misplaced? What do you want to say, "can't rmw 16bit reg: 0x0 -EIO",
or "can't rmw 16bit reg 0x0: -EIO"?

Reminds me of a joke:
"The inventor of the Oxford comma has died. Tributes have been led by
J.K. Rowling, his wife and the Queen of England".

> +
> +	return ret;
> +}
> +
>  static inline int ksz_write64(struct ksz_device *dev, u32 reg, u64 value)
>  {
>  	u32 val[2];
> +static int ksz_ptp_settime(struct ptp_clock_info *ptp,
> +			   const struct timespec64 *ts)
> +{
> +	struct ksz_ptp_data *ptp_data = ptp_caps_to_data(ptp);
> +	struct ksz_device *dev = ptp_data_to_ksz_dev(ptp_data);
> +	int ret;
> +
> +	mutex_lock(&ptp_data->lock);
> +
> +	/* Write to shadow registers and Load PTP clock */
> +	ret = ksz_write16(dev, REG_PTP_RTC_SUB_NANOSEC__2, PTP_RTC_0NS);
> +	if (ret)
> +		goto error_return;
> +
> +	ret = ksz_write32(dev, REG_PTP_RTC_NANOSEC, ts->tv_nsec);
> +	if (ret)
> +		goto error_return;
> +
> +	ret = ksz_write32(dev, REG_PTP_RTC_SEC, ts->tv_sec);
> +	if (ret)
> +		goto error_return;
> +
> +	ret = ksz_rmw16(dev, REG_PTP_CLK_CTRL, PTP_LOAD_TIME, PTP_LOAD_TIME);
> +
> +error_return:

I would avoid naming labels with "error_", if the success code path is
also going to run through the code they point to. "goto unlock" sounds
about right.

> +	mutex_unlock(&ptp_data->lock);
> +
> +	return ret;
> +}
> +
> +static const struct ptp_clock_info ksz_ptp_caps = {
> +	.owner		= THIS_MODULE,
> +	.name		= "Microchip Clock",
> +	.max_adj	= KSZ_MAX_DRIFT_CORR,
> +	.gettime64	= ksz_ptp_gettime,
> +	.settime64	= ksz_ptp_settime,
> +	.adjfine	= ksz_ptp_adjfine,
> +	.adjtime	= ksz_ptp_adjtime,
> +};

Is it a conscious decision to have this structure declared here in the
.rodata section (I think that's where this goes?), when it will only be
used as a blueprint for the implicit memcpy (struct assignment) in
ksz_ptp_clock_register()?

Just saying that it would be possible to initialize the fields in
ptp_data->caps even without resorting to declaring one extra structure,
which consumes space. I'll leave you alone if you ACK that you know your
assignment below is a struct copy and not a pointer assignment.

> +
> +int ksz_ptp_clock_register(struct dsa_switch *ds)
> +{
> +	struct ksz_device *dev = ds->priv;
> +	struct ksz_ptp_data *ptp_data;
> +	int ret;
> +
> +	ptp_data = &dev->ptp_data;
> +	mutex_init(&ptp_data->lock);
> +
> +	ptp_data->caps = ksz_ptp_caps;
> +
> +	ret = ksz_ptp_start_clock(dev);
> +	if (ret)
> +		return ret;
> +
> +	ptp_data->clock = ptp_clock_register(&ptp_data->caps, dev->dev);
> +	if (IS_ERR_OR_NULL(ptp_data->clock))
> +		return PTR_ERR(ptp_data->clock);
> +
> +	ret = ksz_rmw16(dev, REG_PTP_MSG_CONF1, PTP_802_1AS, PTP_802_1AS);
> +	if (ret)
> +		goto error_unregister_clock;

Registering a structure with a subsystem generally means that it becomes
immediately accessible to user space, and its (POSIX clock) ops are callable.

You haven't explained what PTP_802_1AS does, concretely, even though
I asked for a comment in the previous patch set. Is it okay for the PTP
clock to be registered while the PTP_802_1AS bit hasn't been yet written?
The first few operations might take place with it still unset.

I know what 802.1AS is, I just don't know what the register field does.

> +
> +	return 0;
> +
> +error_unregister_clock:
> +	ptp_clock_unregister(ptp_data->clock);
> +	return ret;
> +}
