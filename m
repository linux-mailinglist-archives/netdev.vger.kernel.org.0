Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B722E41CE8E
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 23:54:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345909AbhI2V4T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 17:56:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345002AbhI2V4Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 17:56:16 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E799C06161C
        for <netdev@vger.kernel.org>; Wed, 29 Sep 2021 14:54:34 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id r18so13835843edv.12
        for <netdev@vger.kernel.org>; Wed, 29 Sep 2021 14:54:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=WwZm+Bazgh1tPSkCG/l9i4Q6lqEGNmyYxZ2Q3JwSwZE=;
        b=kXfHmDswKn9y2pmlM1b0PWttNfHJifjuSX3gLMsZg+f1IK4fM1+fvwbyFzhDBGSbn/
         YicMepK4aosA+sRmOHd4u0mdV3PuDX9XTjkcDb7Xpx3G9YhQy7Pbc4AN2hJb01JF0reU
         XtFcGMiEYWL4k9YOq+Wvjn45Oqn6t5K+Me++rH9SlwcUNeb3dhHhu/FISlRTPbfnVHQp
         I042x2EC/lfCJBeEkMHvBVxvx1puZ2AmLimHiSSLYxnEkQx3mAiN0gzByPZvXnH14UDZ
         vNzgLlO47b0mZX0MOISFoE+rjoWdDAMO1X7LyFyfWNNOfBWcGCPsm6kpEYpwXEdBKTMf
         S+mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=WwZm+Bazgh1tPSkCG/l9i4Q6lqEGNmyYxZ2Q3JwSwZE=;
        b=L6GQF4Jln8WOaOfk47Jg5YJvYwrItFUZb0ZpJScCeRxBVPTSlxqE5qfrLHVmG1Dpyi
         WQY/pQRrJ/SdGgsqLu5tZqT2x2+bbn2ismG2mPcR9VW0zGjOPgAQ/oE3FpsQSGXAZmH7
         rhBa/OvanTQColPwmBfbG4U6Z0adaSCEh3sRgD86sEu6qNw3NJPadGE9ArXmM3zq1Jcg
         ZzwX4hICR1iGXAZj9/iJV/HTjoGdiX82NBIgb/7YtRwURZCMKwaTUbFrIgRhndrCRyHQ
         A3zj/JcDtQ5VLYSKmiByYHtE29MsrpCeBD3RhOBzjHprL3ENL6OAF7pJZwuYI/s4YLOf
         k2Iw==
X-Gm-Message-State: AOAM531HAtsRWhSGf0jbvPz7ugNO8Z8nzMAQtjQESSP6GyK5PGT8fbSQ
        5BDFGukD3/vBsGj2yaecsII=
X-Google-Smtp-Source: ABdhPJyMxHE12CexpN6bnLFIdoC/kgp9NqnkyPPEojiHiAh9Rf6ON8eaBgANj9fGTHYrZd/hG1RS1g==
X-Received: by 2002:a17:906:199a:: with SMTP id g26mr2568662ejd.90.1632952472686;
        Wed, 29 Sep 2021 14:54:32 -0700 (PDT)
Received: from skbuf ([188.26.53.217])
        by smtp.gmail.com with ESMTPSA id u2sm159232edb.6.2021.09.29.14.54.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 14:54:32 -0700 (PDT)
Date:   Thu, 30 Sep 2021 00:54:30 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Mauri Sandberg <sandberg@mailfence.com>,
        DENG Qingfang <dqfext@gmail.com>
Subject: Re: [PATCH net-next 4/4 v4] net: dsa: rtl8366rb: Support setting STP
 state
Message-ID: <20210929215430.kyi5ekdu5i36um2k@skbuf>
References: <20210929210349.130099-1-linus.walleij@linaro.org>
 <20210929210349.130099-5-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210929210349.130099-5-linus.walleij@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 29, 2021 at 11:03:49PM +0200, Linus Walleij wrote:
> This adds support for setting the STP state to the RTL8366RB
> DSA switch. This rids the following message from the kernel on
> e.g. OpenWrt:
> 
> DSA: failed to set STP state 3 (-95)
> 
> Since the RTL8366RB has one STP state register per FID with
> two bit per port in each, we simply loop over all the FIDs
> and set the state on all of them.
> 
> Cc: Vladimir Oltean <olteanv@gmail.com>
> Cc: Alvin Šipraga <alsi@bang-olufsen.dk>
> Cc: Mauri Sandberg <sandberg@mailfence.com>
> Cc: DENG Qingfang <dqfext@gmail.com>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
> ChangeLog v1->v4:
> - New patch after discovering that we can do really nice
>   bridge offloading with these bits.
> ---
>  drivers/net/dsa/rtl8366rb.c | 47 +++++++++++++++++++++++++++++++++++++
>  1 file changed, 47 insertions(+)
> 
> diff --git a/drivers/net/dsa/rtl8366rb.c b/drivers/net/dsa/rtl8366rb.c
> index 748f22ab9130..c143fdab4802 100644
> --- a/drivers/net/dsa/rtl8366rb.c
> +++ b/drivers/net/dsa/rtl8366rb.c
> @@ -110,6 +110,14 @@
>  
>  #define RTL8366RB_POWER_SAVING_REG	0x0021
>  
> +/* Spanning tree status (STP) control, two bits per port per FID */
> +#define RTL8368S_SPT_STATE_BASE		0x0050 /* 0x0050..0x0057 */

What does "SPT" stand for?

Also, is there any particular reason why these are named after RTL8368S,
when the entire driver has a naming scheme which follows RTL8366RB?

> +#define RTL8368S_SPT_STATE_MSK		0x3
> +#define RTL8368S_SPT_STATE_DISABLED	0x0
> +#define RTL8368S_SPT_STATE_BLOCKING	0x1
> +#define RTL8368S_SPT_STATE_LEARNING	0x2
> +#define RTL8368S_SPT_STATE_FORWARDING	0x3
> +
>  /* CPU port control reg */
>  #define RTL8368RB_CPU_CTRL_REG		0x0061
>  #define RTL8368RB_CPU_PORTS_MSK		0x00FF
> @@ -254,6 +262,7 @@
>  #define RTL8366RB_NUM_LEDGROUPS		4
>  #define RTL8366RB_NUM_VIDS		4096
>  #define RTL8366RB_PRIORITYMAX		7
> +#define RTL8366RB_NUM_FIDS		8
>  #define RTL8366RB_FIDMAX		7
>  
>  #define RTL8366RB_PORT_1		BIT(0) /* In userspace port 0 */
> @@ -1359,6 +1368,43 @@ rtl8366rb_port_bridge_flags(struct dsa_switch *ds, int port,
>  	return 0;
>  }
>  
> +static void
> +rtl8366rb_port_stp_state_set(struct dsa_switch *ds, int port, u8 state)
> +{
> +	struct realtek_smi *smi = ds->priv;
> +	u16 mask;
> +	u32 val;
> +	int i;
> +
> +	switch (state) {
> +	case BR_STATE_DISABLED:
> +		val = RTL8368S_SPT_STATE_DISABLED;
> +		break;
> +	case BR_STATE_BLOCKING:
> +	case BR_STATE_LISTENING:
> +		val = RTL8368S_SPT_STATE_BLOCKING;
> +		break;
> +	case BR_STATE_LEARNING:
> +		val = RTL8368S_SPT_STATE_LEARNING;
> +		break;
> +	case BR_STATE_FORWARDING:
> +		val = RTL8368S_SPT_STATE_FORWARDING;
> +		break;
> +	default:
> +		dev_err(smi->dev, "unknown bridge state requested\n");
> +		return;
> +	};
> +
> +	mask = (RTL8368S_SPT_STATE_MSK << (port * 2));

Could you not add a port argument:

#define RTL8366RB_STP_MASK			GENMASK(1, 0)
#define RTL8366RB_STP_STATE(port, state)	(((state) << ((port) * 2))
#define RTL8366RB_STP_STATE_MASK(port)		RTL8366RB_STP_STATE(RTL8366RB_STP_MASK, (port))

	regmap_update_bits(smi->map, RTL8366RB_STP_STATE_BASE + i,
			   RTL8366RB_STP_STATE_MASK(port),
			   RTL8366RB_STP_STATE(port, val));

> +	val <<= (port * 2);
> +
> +	/* Set the same status for the port on all the FIDs */
> +	for (i = 0; i < RTL8366RB_NUM_FIDS; i++) {
> +		regmap_update_bits(smi->map, RTL8368S_SPT_STATE_BASE + i,
> +				   mask, val);
> +	}
> +}
> +
>  static void
>  rtl8366rb_port_fast_age(struct dsa_switch *ds, int port)
>  {
> @@ -1784,6 +1830,7 @@ static const struct dsa_switch_ops rtl8366rb_switch_ops = {
>  	.port_disable = rtl8366rb_port_disable,
>  	.port_pre_bridge_flags = rtl8366rb_port_pre_bridge_flags,
>  	.port_bridge_flags = rtl8366rb_port_bridge_flags,
> +	.port_stp_state_set = rtl8366rb_port_stp_state_set,
>  	.port_fast_age = rtl8366rb_port_fast_age,
>  	.port_change_mtu = rtl8366rb_change_mtu,
>  	.port_max_mtu = rtl8366rb_max_mtu,
> -- 
> 2.31.1
> 

