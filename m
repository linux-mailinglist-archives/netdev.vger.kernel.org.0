Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37800644AD4
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 19:08:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229676AbiLFSH6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 13:07:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229683AbiLFSHs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 13:07:48 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2D8DF013;
        Tue,  6 Dec 2022 10:07:47 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id vp12so8151776ejc.8;
        Tue, 06 Dec 2022 10:07:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jtIWr9ch7YDQuR1NkAMllmQYeC+7Fh/NFmZpcbpce2c=;
        b=DBa9yjWkmwV3z7XRAKL/zuLsHeVUJihbjUO3drpJlSPjw4rJEoYnOH58htDTTNpfpp
         Ojk4wffktsZ/F6KS8p785i2F658k40JRcYSyttdNVHJUw34c6kaS2m8ipzz/mYUo5YET
         L2wZlIEYOZmcSIvwvIqITXeEzGpGe52nAs/AgUDoxgL6joEZo6/nklEBqLVIwr/cEZkx
         +/U2lZ+mBqFymv0RZFOqsvaAfyn7o1kzdM113Tc1TAOGLo9oy2k8yuOBBmgFaVx/rafO
         P86J+OgWQXX08wv4OOk6Qhaj8/tuuLIZhoPSij/Oo6LGpbMpp3W2cpjVaPLwyuRb+b6u
         8gDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jtIWr9ch7YDQuR1NkAMllmQYeC+7Fh/NFmZpcbpce2c=;
        b=d25hXdSbHMQeGPauDc3yDQhe6C1kiQ8I0cZIu8le0rSBVbaO+3miCtsVfD6pbd6+cd
         OKnJfSyhF9uwT/Ct0gY4KQvk9xSMgYUkHg9ktxMNPZ5rw2ekHGiJAm9fhaMENrtAJUdF
         NGInIvLf42Xof31s9sb+N+QG1oPiPZh/lLyFV26nuLFdsGrtCoV53j1sqE6vGsMpNbMt
         qgNj3I7/Mkyke43HPdOWApKG8kCGv3rRLtHaw80/8k3snKXaP1QCKs2gNtdHazHLFHPk
         j2FCSXDl+OzVZxwyMTbAyzFJDkwZc6YOraGo0nx2HSQGxjQEPm00/k5Bv2ojEX0Qeecz
         6YcQ==
X-Gm-Message-State: ANoB5pl/UZKEAB/DYPLF0rVpgBRKw7OHKLUnWq9JgmFMDKgI6/PsKqjU
        wiVA3o7jwosQWLlaLPycljo=
X-Google-Smtp-Source: AA0mqf58bl3BQWBN4ZmSExw+5aXU2AWWWQXCjKCjYcsqD6XrXzd95UcdYfYd/y8o+eshP/C3xmfRYg==
X-Received: by 2002:a17:906:830f:b0:7c0:a3c6:e788 with SMTP id j15-20020a170906830f00b007c0a3c6e788mr11382813ejx.476.1670350066157;
        Tue, 06 Dec 2022 10:07:46 -0800 (PST)
Received: from gvm01 (net-2-45-26-236.cust.vodafonedsl.it. [2.45.26.236])
        by smtp.gmail.com with ESMTPSA id l12-20020aa7d94c000000b0046b1d63cfc1sm1233187eds.88.2022.12.06.10.07.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 10:07:45 -0800 (PST)
Date:   Tue, 6 Dec 2022 19:07:56 +0100
From:   Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Oleksij Rempel <o.rempel@pengutronix.de>
Subject: Re: [PATCH v4 net-next 4/5] drivers/net/phy: add helpers to get/set
 PLCA configuration
Message-ID: <Y4+E/H5ZXqdd4med@gvm01>
References: <cover.1670329232.git.piergiorgio.beruto@gmail.com>
 <4c6bb420c2169edb31abd5c4d5fe04090ed329e4.1670329232.git.piergiorgio.beruto@gmail.com>
 <Y49Ky7aCUZxE5Fwg@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y49Ky7aCUZxE5Fwg@lunn.ch>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 06, 2022 at 02:59:39PM +0100, Andrew Lunn wrote:
> > +/* MDIO Manageable Devices (MMDs). */
> > +#define MDIO_MMD_OATC14		MDIO_MMD_VEND2
> 
> As i said in a comment somewhere, i would prefer you use
> MDIO_MMD_VEND2, not MDIO_MMD_OATC14. We want the gentle reminder that
> these registers can contain anything the vendor wants, including, but
> not limited to, PLCA.
Ok, I'll fix that.

> > +/* Open Alliance TC14 PLCA CTRL0 register */
> > +#define MDIO_OATC14_PLCA_EN	0x8000  /* PLCA enable */
> > +#define MDIO_OATC14_PLCA_RST	0x4000  /* PLCA reset */
> 
> These are bits, so use the BIT macro. When this was part of mii.h,
> that file used this hex format so it made sense to follow that
> format. Now you are in a few file, you should use the macro.
Sure, I just moved the code in the new file without thinking of changing
this. Will do.

> > +/* Open Alliance TC14 PLCA CTRL1 register */
> > +#define MDIO_OATC14_PLCA_NCNT	0xff00	/* PLCA node count */
> > +#define MDIO_OATC14_PLCA_ID	0x00ff	/* PLCA local node ID */
> > +
> > +/* Open Alliance TC14 PLCA STATUS register */
> > +#define MDIO_OATC14_PLCA_PST	0x8000	/* PLCA status indication */
> > +
> > +/* Open Alliance TC14 PLCA TOTMR register */
> > +#define MDIO_OATC14_PLCA_TOT	0x00ff
> > +
> > +/* Open Alliance TC14 PLCA BURST register */
> > +#define MDIO_OATC14_PLCA_MAXBC	0xff00
> > +#define MDIO_OATC14_PLCA_BTMR	0x00ff
> > +
> > +#endif /* __MDIO_OPEN_ALLIANCE__ */
> > diff --git a/drivers/net/phy/phy-c45.c b/drivers/net/phy/phy-c45.c
> > index a87a4b3ffce4..dace5d3b29ad 100644
> > --- a/drivers/net/phy/phy-c45.c
> > +++ b/drivers/net/phy/phy-c45.c
> > @@ -8,6 +8,8 @@
> >  #include <linux/mii.h>
> >  #include <linux/phy.h>
> >  
> > +#include "mdio-open-alliance.h"
> > +
> >  /**
> >   * genphy_c45_baset1_able - checks if the PMA has BASE-T1 extended abilities
> >   * @phydev: target phy_device struct
> > @@ -931,6 +933,184 @@ int genphy_c45_fast_retrain(struct phy_device *phydev, bool enable)
> >  }
> >  EXPORT_SYMBOL_GPL(genphy_c45_fast_retrain);
> >  
> > +/**
> > + * genphy_c45_plca_get_cfg - get PLCA configuration from standard registers
> > + * @phydev: target phy_device struct
> > + * @plca_cfg: output structure to store the PLCA configuration
> > + *
> > + * Description: if the PHY complies to the Open Alliance TC14 10BASE-T1S PLCA
> > + *   Management Registers specifications, this function can be used to retrieve
> > + *   the current PLCA configuration from the standard registers in MMD 31.
> > + */
> > +int genphy_c45_plca_get_cfg(struct phy_device *phydev,
> > +			    struct phy_plca_cfg *plca_cfg)
> > +{
> > +	int ret;
> > +
> > +	ret = phy_read_mmd(phydev, MDIO_MMD_OATC14, MDIO_OATC14_PLCA_IDVER);
> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	plca_cfg->version = ret;
> 
> It would be good to verify this value, and return -ENODEV if it is not
> valid.
Got it, thanks.

Piergiorgio
