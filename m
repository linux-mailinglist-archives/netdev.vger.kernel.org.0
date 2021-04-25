Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5958A36A3E1
	for <lists+netdev@lfdr.de>; Sun, 25 Apr 2021 03:19:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229951AbhDYBUH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Apr 2021 21:20:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229687AbhDYBUG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Apr 2021 21:20:06 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A75AC061574;
        Sat, 24 Apr 2021 18:19:27 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id bx20so60484474edb.12;
        Sat, 24 Apr 2021 18:19:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7qMzhN/e+jpxAR24tyrQUmKft76I/dbVtvs0AcxWx1g=;
        b=PCpsgsy5ID5M7bkoEoEU3pRLSgCdYzp/T8A8tTwwY2imC/Q9kLWxZX1Kw+VZ1CKjrj
         YaiwFeKZa5JLcWbu7hAJXwSGMXGbRrIXytmSWAzHI5t7y5uY2rS9YGB7pgorv7ttkA8G
         W0seifSA8sHfqhTjsIp9aZ/pKsAdPiBeDzucRgizf13JA5aBC5H/3siXDeSf+s+OV27+
         uCDve2XrGNScYUemUZPmWKcUjpyoLw8D/Xp38YLXSX+ooTbWYDswPnNdAdzyqtwtZhTI
         3AuFmUwXZmbGd54483ilpQlW1ghLFhnUbIZvbaZLYbJfhSZLLaQ2uebjs/6IVqIHf7rT
         nYvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7qMzhN/e+jpxAR24tyrQUmKft76I/dbVtvs0AcxWx1g=;
        b=RRvmD3tQ90aoA8FVliwnjoYtTkmqn+iWrjUlYvsC+we/So1IDWqLE7a+XIthG3dDEr
         XQHpyQIiPymiRDvj+bFhOKdy+VAwyTJd7aze8IFfvrAQWITPwieTT8scTP138ScyLPro
         QfhzGC8DkF/P5ydSjjkANX+2mTwfVc99Wv1Zn8E4Kz6GG9vkKnfVUfDyTM/7KugOvhHi
         613c3juFpV1FRZ307R9T8tkeyJ/PvIQumshdF9aBjqde48c3hfs8VHXfxfCsd2r6EEtb
         30Vgl4TF/ujgavdW6MvvvbvSprjXD5JYeyNetG5HC8tbdDHvIzo3kBDx92NElz1gDwAG
         KJ5A==
X-Gm-Message-State: AOAM530R6INuB5u/7yEeuqVXLoczqIo8ECz34SxvgyjOZ1p/6kSBlg7/
        HrEMdVCNSYtinT3DBoLKlbI=
X-Google-Smtp-Source: ABdhPJzeFix8alnTi639bZjNfC8LynvA7kifQQFD5FScrYcF7mMxlRb++qSxJ90CBrc+tpgpa9dxjw==
X-Received: by 2002:a05:6402:2215:: with SMTP id cq21mr12980291edb.177.1619313565338;
        Sat, 24 Apr 2021 18:19:25 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.gmail.com with ESMTPSA id u13sm8167638ejj.16.2021.04.24.18.19.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Apr 2021 18:19:25 -0700 (PDT)
Date:   Sun, 25 Apr 2021 03:19:22 +0200
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/14] drivers: net: dsa: qca8k: apply switch revision fix
Message-ID: <YITDmjB1pd+7oebm@Ansuel-xps.localdomain>
References: <20210423014741.11858-1-ansuelsmth@gmail.com>
 <20210423014741.11858-12-ansuelsmth@gmail.com>
 <e644aba9-a092-3825-b55b-e0cca158d28b@gmail.com>
 <YISLHNK8binc9T1N@Ansuel-xps.localdomain>
 <bbbb511a-0ab7-77e4-2dde-473d25b90d17@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bbbb511a-0ab7-77e4-2dde-473d25b90d17@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 24, 2021 at 06:09:27PM -0700, Florian Fainelli wrote:
> 
> 
> On 4/24/2021 2:18 PM, Ansuel Smith wrote:
> > On Thu, Apr 22, 2021 at 07:02:37PM -0700, Florian Fainelli wrote:
> >>
> >>
> >> On 4/22/2021 6:47 PM, Ansuel Smith wrote:
> >>> qca8k require special debug value based on the switch revision.
> >>>
> >>> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> >>> ---
> >>>  drivers/net/dsa/qca8k.c | 23 +++++++++++++++++++++--
> >>>  1 file changed, 21 insertions(+), 2 deletions(-)
> >>>
> >>> diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
> >>> index 193c269d8ed3..12d2c97d1417 100644
> >>> --- a/drivers/net/dsa/qca8k.c
> >>> +++ b/drivers/net/dsa/qca8k.c
> >>> @@ -909,7 +909,7 @@ qca8k_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
> >>>  {
> >>>  	const struct qca8k_match_data *data;
> >>>  	struct qca8k_priv *priv = ds->priv;
> >>> -	u32 reg, val;
> >>> +	u32 phy, reg, val;
> >>>  
> >>>  	/* get the switches ID from the compatible */
> >>>  	data = of_device_get_match_data(priv->dev);
> >>> @@ -928,7 +928,26 @@ qca8k_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
> >>>  	case 3:
> >>>  	case 4:
> >>>  	case 5:
> >>> -		/* Internal PHY, nothing to do */
> >>> +		/* Internal PHY, apply revision fixup */
> >>> +		phy = qca8k_port_to_phy(port) % PHY_MAX_ADDR;
> >>> +		switch (priv->switch_revision) {
> >>> +		case 1:
> >>> +			/* For 100M waveform */
> >>> +			qca8k_phy_dbg_write(priv, phy, 0, 0x02ea);
> >>> +			/* Turn on Gigabit clock */
> >>> +			qca8k_phy_dbg_write(priv, phy, 0x3d, 0x68a0);
> >>> +			break;
> >>> +
> >>> +		case 2:
> >>> +			qca8k_phy_mmd_write(priv, phy, 0x7, 0x3c, 0x0);
> >>> +			fallthrough;
> >>> +		case 4:
> >>> +			qca8k_phy_mmd_write(priv, phy, 0x3, 0x800d, 0x803f);
> >>> +			qca8k_phy_dbg_write(priv, phy, 0x3d, 0x6860);
> >>> +			qca8k_phy_dbg_write(priv, phy, 0x5, 0x2c46);
> >>> +			qca8k_phy_dbg_write(priv, phy, 0x3c, 0x6000);
> >>> +			break;
> >>
> >> This would be better done with a PHY driver that is specific to the
> >> integrated PHY found in these switches, it would provide a nice clean
> >> layer and would allow you to expose additional features like cable
> >> tests, PHY statistics/counters, etc.
> > 
> > I'm starting to do some work with this and a problem arised. Since these
> > value are based on the switch revision, how can I access these kind of
> > data from the phy driver? It's allowed to declare a phy driver in the
> > dsa directory? (The idea would be to create a qca8k dir with the dsa
> > driver and the dedicated internal phy driver.) This would facilitate the
> > use of normal qca8k_read/write (to access the switch revision from the
> > phy driver) using common function?
> 
> The PHY driver should live under drivers/net/phy/ and if you need to
> communicate the switch revision to the PHY driver you can use
> phydev->dev_flags and implement a dsa_switch_ops::get_phy_flags()
> callback and define a custom bitmask.
> 
> As far as the read/write operations if your switch implements a custom
> mii_bus for the purpose of doing all of the underlying indirect register
> accesses, then you should be fine. A lot of drivers do that however if
> you want an example of both (communicating something to the PHY driver
> and having a custom MII bus) you can look at drivers/net/dsa/bcm_sf2.c
> for an example.
> -- 
> Florian

Thanks a lot for the suggestions. Will send v2 to the net-next branch
hoping I did all the correct way. 

