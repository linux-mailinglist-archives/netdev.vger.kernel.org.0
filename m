Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45ACA522486
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 21:09:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234158AbiEJTJn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 15:09:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233466AbiEJTJk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 15:09:40 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF6F724D60D
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 12:09:36 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id g23so21130455edy.13
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 12:09:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=u6FmVRwp9SHSnjVRc0nOO09lhBUyCuNuYF9AWJHlgv8=;
        b=MOstS8oTohcQJdpAfliBc/590Z05K1FTFJcOBwO8Krmk38ilynOtNjy3bKXRvJKR5D
         feIE5pl144uRKIYOFOz8tvvoj/Zr+6p63dV8Kxkr3SJ3455mwfr7EvrgxOXNaQg6J7rs
         /EqSSlcOiWNlvNZAJdlI4lhSYHd80fHeyK3dCIDY7nxByIyR9wp/fxpGGjqMhLC17NcO
         h/KXCjQcitrWr2poGZVEOOUybLZ5w03MrcxRMD4EtqbSl0dtiUWOrOcW/gp40D+7Er+q
         wzJp4+IX9kHy/A2yifLF/kDlo+tV6txlredJ/y0t3u7C67Po+cIa3fiDTHyzqvrVGf5g
         1n4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=u6FmVRwp9SHSnjVRc0nOO09lhBUyCuNuYF9AWJHlgv8=;
        b=DjtUqAjGpIiE//ejyD2azDLoabPiPpMyO4tIucBCVF5YEC+Q9sQ5GVRuNH+BxTdaF/
         7jmdl9e5RwvMPipX6CAjjeQVKjFD0JLMjRQwUeXngNFN3WyltsJBnChmjL7dcpBcHCiN
         ccVJWaHLdfHKfNvPM9FTzwccyodHxwfNBxG7Es7cPdW1JBHiygTcBCJKK3DJ0H6ogGKA
         SQowFAyRltNsVZDI2/B4qKTePWIp8YLWk9wTyYNV3c9mFmuKe1NWZJhRxAvgJEgXoPpy
         Ndd4D7z+iujMR/68mXx8LQ6ro9qWDLew+XQhZ4SAPtpQXjUQF3veqdeW70w60qLNjlB3
         CiGg==
X-Gm-Message-State: AOAM533eb3s9nADpe2yXUw/yaWTCZJ5r4jAjJBnpRtC6sznvcF8dMucx
        tIT1ojF2vZB5zZiKBWlsldE=
X-Google-Smtp-Source: ABdhPJyIUlQzyEas37CJY5uDBUaOS8M9ciYChmR7Z8lg4SVIKmCQt5EH9cz3O8vdgDSM4Yusn/mBeA==
X-Received: by 2002:a50:d713:0:b0:428:8fe8:63f6 with SMTP id t19-20020a50d713000000b004288fe863f6mr15773414edi.365.1652209775162;
        Tue, 10 May 2022 12:09:35 -0700 (PDT)
Received: from skbuf ([188.25.160.86])
        by smtp.gmail.com with ESMTPSA id v17-20020a170906489100b006f3ef214dd4sm75027ejq.58.2022.05.10.12.09.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 May 2022 12:09:34 -0700 (PDT)
Date:   Tue, 10 May 2022 22:09:32 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev <netdev@vger.kernel.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        Markus Koch <markus@notsyncing.net>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Hao Chen <chenhao288@hisilicon.com>
Subject: Re: [PATCH net-next 07/10] net: ethernet: freescale: xgmac: Separate
 C22 and C45 transactions for xgmac
Message-ID: <20220510190932.hnjxke3tmkaxi53i@skbuf>
References: <20220508153049.427227-1-andrew@lunn.ch>
 <20220508153049.427227-8-andrew@lunn.ch>
 <20220510182818.w7kl3vmlgvqjjj4u@skbuf>
 <Ynq2phuiw8mLN8bZ@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ynq2phuiw8mLN8bZ@lunn.ch>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 10, 2022 at 09:01:58PM +0200, Andrew Lunn wrote:
> On Tue, May 10, 2022 at 09:28:18PM +0300, Vladimir Oltean wrote:
> > On Sun, May 08, 2022 at 05:30:46PM +0200, Andrew Lunn wrote:
> > > The xgmac MDIO bus driver can perform both C22 and C45 transfers.
> > > Create separate functions for each and register the C45 versions using
> > > the new API calls where appropriate.
> > > 
> > > Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> > > ---
> > >  drivers/net/ethernet/freescale/xgmac_mdio.c | 154 +++++++++++++++-----
> > >  1 file changed, 117 insertions(+), 37 deletions(-)
> > > 
> > > diff --git a/drivers/net/ethernet/freescale/xgmac_mdio.c b/drivers/net/ethernet/freescale/xgmac_mdio.c
> > > index ec90da1de030..ddfe6bf1f231 100644
> > > --- a/drivers/net/ethernet/freescale/xgmac_mdio.c
> > > +++ b/drivers/net/ethernet/freescale/xgmac_mdio.c
> > > @@ -128,30 +128,59 @@ static int xgmac_wait_until_done(struct device *dev,
> > >  	return 0;
> > >  }
> > >  
> > > -/*
> > > - * Write value to the PHY for this device to the register at regnum,waiting
> > > +/* Write value to the PHY for this device to the register at regnum,waiting
> > >   * until the write is done before it returns.  All PHY configuration has to be
> > >   * done through the TSEC1 MIIM regs.
> > >   */
> > > -static int xgmac_mdio_write(struct mii_bus *bus, int phy_id, int regnum, u16 value)
> > > +static int xgmac_mdio_write_c22(struct mii_bus *bus, int phy_id, int regnum,
> > > +				u16 value)
> > >  {
> > >  	struct mdio_fsl_priv *priv = (struct mdio_fsl_priv *)bus->priv;
> > >  	struct tgec_mdio_controller __iomem *regs = priv->mdio_base;
> > > -	uint16_t dev_addr;
> > > +	bool endian = priv->is_little_endian;
> > >  	u32 mdio_ctl, mdio_stat;
> > > +	u16 dev_addr;
> > >  	int ret;
> > > +
> > > +	mdio_stat = xgmac_read32(&regs->mdio_stat, endian);
> > > +	dev_addr = regnum & 0x1f;
> > 
> > Please move this either to the variable declaration, or near the mdio_ctl write,
> > or just integrate it into the macro argument.
> 
> There are masks like this in some drivers, others don't. Since for the
> majority of the MDIO bus drivers i don't have the hardware i was
> trying to keep my changes to a minimum, so i'm less likely to break
> it.
> 
> Once we have all the bus drivers converted, we can validate all the
> requests in the core to guarantee no users are passing invalid values
> to the drivers. And then all these masks can be removed.

Sure, I was going to revisit this comment, keep the masking with 0x1f,
I remembered in the meanwhile that it's supposed to represent
MII_MMD_CTRL_DEVAD_MASK, and that there is other stuff potentially
encoded in the devad, like post-increment stuff.

> > 
> > > +	mdio_stat &= ~MDIO_STAT_ENC;
> > > +
> > 
> > You can remove this empty line during read-modify-write patterns.
> 
> Sure, but just an FYI: the old code probably did it that way. My aim
> is to split C22 from C45, not re-write/clean up every driver. I have
> over 40 patches in total, without doing cleanups.

You are modifying this part of the code anyway.
