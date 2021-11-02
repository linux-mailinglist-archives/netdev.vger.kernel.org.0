Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDD09443592
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 19:28:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229791AbhKBSbb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 14:31:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229697AbhKBSba (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Nov 2021 14:31:30 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DB93C061714;
        Tue,  2 Nov 2021 11:28:55 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id 5so731144edw.7;
        Tue, 02 Nov 2021 11:28:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xLglhMyyfoIuxmmQNs2EF8bn784/haAr2jzi2MaCmXg=;
        b=izphqh718X2gyyHaTdPEjxlb1RNWJJyIDo+G/kyMGT7nk9oFsK2Z4G90vf7m9ydiVv
         EybcgoBzQnqzJ9vgSo3qHoXNg9vzRDy2tWVj4BUOSP89T91uL4LDNfTWBkjAIMuaS6tJ
         Iq/PUPAsxx0TlFJv3E+odGslsMoOltBxFLutJRrRcWxtLSg0ovZaixHumysHDUPdqFB+
         eStSvsSyliREAozWM0oUqU53rxz28vQDI+82ltNcUARk7NjPb9sjI1v/zDqFh038LtnN
         WHhz3/vI/RmUwv17KstNGIqrBa1EVI2oHyCSHJTnXzcEhW0m8GVchO8DWPGhjksAjT/g
         eBEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xLglhMyyfoIuxmmQNs2EF8bn784/haAr2jzi2MaCmXg=;
        b=St0T9xKS1BQDmvhb4QKGOalJIwysMeh/aCBpLq+iIb72AUfg5Y/NKwc8BP7k8oXCXV
         OFxGwg7+a262FUqGZASRZ6KA1zWnuR91FyKsoWg92adCIR7Rnjs4MZKq88yxHU+AdFZa
         MKqeM6bOpu7tkGXflAaQV7XdNQke2uSxXLlLnyoPrHN9ByNnwTeqBfcADK+lP6hKE7ey
         SX0jeI8fMf3EcOVCHhzgJduW3qz/SbSmFnsHBh8uFiIMsh7bVh08DP8aD87vm1yFkw0c
         NmF/39pv5o8qtm9nk7OUs7EqNKfvD7gYRw9Gh/6t9a5TAF8+cKfw09piVZ7gfgVDDIqq
         OVVQ==
X-Gm-Message-State: AOAM5302wFEAtyq7pyWvUrBAa0D5hAnhOAweyosOJAkqj9dmtG44UkLC
        bPIRYp1ckP9kJRCJsN7zcFc=
X-Google-Smtp-Source: ABdhPJykacMMEHQ/+BlOKgVFk/HygSip7cyiy6kUdL/wRrc2hXSMDqKG89FkDhEdBHJClUyQeY1aiQ==
X-Received: by 2002:a05:6402:35c1:: with SMTP id z1mr25158969edc.141.1635877733495;
        Tue, 02 Nov 2021 11:28:53 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.gmail.com with ESMTPSA id m15sm11939104edd.5.2021.11.02.11.28.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Nov 2021 11:28:53 -0700 (PDT)
Date:   Tue, 2 Nov 2021 19:28:50 +0100
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [net-next PATCH] net: dsa: qca8k: make sure PAD0 MAC06 exchange
 is disabled
Message-ID: <YYGDYoToj2r/uYIE@Ansuel-xps.localdomain>
References: <20211102175629.24102-1-ansuelsmth@gmail.com>
 <20211102182655.t74adxlw3q3ctlas@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211102182655.t74adxlw3q3ctlas@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 02, 2021 at 08:26:55PM +0200, Vladimir Oltean wrote:
> On Tue, Nov 02, 2021 at 06:56:29PM +0100, Ansuel Smith wrote:
> > Some device set MAC06 exchange in the bootloader. This cause some
> > problem as we don't support this strange mode and we just set the port6
> > as the primary CPU port. With MAC06 exchange, PAD0 reg configure port6
> > instead of port0. Add an extra check and explicitly disable MAC06 exchange
> > to correctly configure the port PAD config.
> > 
> > Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> > ---
> 
> Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
> 
> Since net-next has closed, please add
> 
> Fixes: 3fcf734aa482 ("net: dsa: qca8k: add support for cpu port 6")
> 
> and resend to the "net" tree.
>

Oh sorry! I checked http://vger.kernel.org/~davem/net-next.html
before posting and it does say it's open. Will resend sorry.

> >  drivers/net/dsa/qca8k.c | 8 ++++++++
> >  drivers/net/dsa/qca8k.h | 1 +
> >  2 files changed, 9 insertions(+)
> > 
> > Some comments here:
> > Resetting the switch using the sw reg doesn't reset the port PAD
> > configuration. I was thinking if it would be better to clear all the
> > pad configuration but considering that the entire reg is set by phylink
> > mac config, I think it's not necessary as the PAD related to the port will
> > be reset anyway with the new values. Have a dirty configuration on PAD6
> > doesn't cause any problem as we have that port disabled and it would be
> > reset and configured anyway if defined.
> > 
> > diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
> > index ea7f12778922..a429c9750add 100644
> > --- a/drivers/net/dsa/qca8k.c
> > +++ b/drivers/net/dsa/qca8k.c
> > @@ -1109,6 +1109,14 @@ qca8k_setup(struct dsa_switch *ds)
> >  	if (ret)
> >  		return ret;
> >  
> > +	/* Make sure MAC06 is disabled */
> > +	ret = qca8k_reg_clear(priv, QCA8K_REG_PORT0_PAD_CTRL,
> > +			      QCA8K_PORT0_PAD_MAC06_EXCHANGE_EN);
> > +	if (ret) {
> > +		dev_err(priv->dev, "failed disabling MAC06 exchange");
> > +		return ret;
> > +	}
> > +
> >  	/* Enable CPU Port */
> >  	ret = qca8k_reg_set(priv, QCA8K_REG_GLOBAL_FW_CTRL0,
> >  			    QCA8K_GLOBAL_FW_CTRL0_CPU_PORT_EN);
> > diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca8k.h
> > index e10571a398c9..128b8cf85e08 100644
> > --- a/drivers/net/dsa/qca8k.h
> > +++ b/drivers/net/dsa/qca8k.h
> > @@ -34,6 +34,7 @@
> >  #define   QCA8K_MASK_CTRL_DEVICE_ID_MASK		GENMASK(15, 8)
> >  #define   QCA8K_MASK_CTRL_DEVICE_ID(x)			((x) >> 8)
> >  #define QCA8K_REG_PORT0_PAD_CTRL			0x004
> > +#define   QCA8K_PORT0_PAD_MAC06_EXCHANGE_EN		BIT(31)
> >  #define   QCA8K_PORT0_PAD_SGMII_RXCLK_FALLING_EDGE	BIT(19)
> >  #define   QCA8K_PORT0_PAD_SGMII_TXCLK_FALLING_EDGE	BIT(18)
> >  #define QCA8K_REG_PORT5_PAD_CTRL			0x008
> > -- 
> > 2.32.0
> > 

-- 
	Ansuel
