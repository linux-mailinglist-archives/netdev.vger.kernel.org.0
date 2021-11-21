Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D45FC4585E6
	for <lists+netdev@lfdr.de>; Sun, 21 Nov 2021 19:22:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238526AbhKUSZJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Nov 2021 13:25:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231214AbhKUSZI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Nov 2021 13:25:08 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DAC1C061574;
        Sun, 21 Nov 2021 10:22:03 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id b184-20020a1c1bc1000000b0033140bf8dd5so11728224wmb.5;
        Sun, 21 Nov 2021 10:22:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:to:cc:subject:references:mime-version
         :content-disposition:in-reply-to;
        bh=BZWKiaPEoQsg9cp7kfKTtjPNp6vx4x07h9a6sr2zEgA=;
        b=QX1MAH1hyKkpn6DxZ3W8FsLwtdXAzc2kZXaj7R/xtWiG8aUSV5niOFF4BrQb09S6P1
         1Puo/etnG0b/x67QLoPL2NQ9IFsRbcEY2AspCHSkl4sJwb5ng3NCVyk9mRouYytlMb3y
         lWttcYIIA2uc8nPgNPODxNhhAGaFSHiWPyYq0GReDyxNXInXjAv7y7XTcNkm62AMLsTP
         AHcdcW14lsHDE4zxnl6VWMzTwNWwnEhkCAP5R3eLfsMTRBXoVw+fXA8sqHRgwqZpNQgr
         xO/v8iaGQ/wRtIiFDrVZcp5tnShMAKFWoMfgrSG3kUH3+TvyAZBOXNq8lwGSdu3WOE7D
         hMFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:to:cc:subject:references
         :mime-version:content-disposition:in-reply-to;
        bh=BZWKiaPEoQsg9cp7kfKTtjPNp6vx4x07h9a6sr2zEgA=;
        b=6fKBLUatQyMRgNDZmgegCbB5bQuzdZfK8MVzQq8P7zxeGtyx0DCkd2lfVFxJ54McTB
         jD+N3ma8wPrFHLpqH4mzU6hlem2Lklx/wKi5ClZvnLO/CoJ6pkTNex1p+w18YSVeAMBy
         eF78n0jLCYAWjZmFrbr5IVMsDQ4PWhYDcr0S/Fl5utb8uh/C/d3mP8XIxdnGlJ3ZIE6V
         A1M/tC6h4IGqGzHHX2dRK21GmwSORr1EcE4r3BPBa0Iv6yECuNupqLIUqYMef6qZBBrF
         CtsPr85qkzdmhLmXL+RCE+raEShVWBrtks/vD/V5VOkG58cH096f3rA1ktGRRcFa/b3/
         +Eew==
X-Gm-Message-State: AOAM5339rB5hS41MNRh7l7X2trqwc6YmqO1A8QZX27imopIzG09s6QaC
        Z88O3rjbIp/C2LKCVXh5rMHNNbQZapQ=
X-Google-Smtp-Source: ABdhPJx4sxwyqnT3zcTKgdCy1vNIwb6gD/xiz8/JBU0o+bV+S5B23qphd7f1fkkIAzFozMmtApkLzQ==
X-Received: by 2002:a05:600c:a42:: with SMTP id c2mr22157656wmq.154.1637518921603;
        Sun, 21 Nov 2021 10:22:01 -0800 (PST)
Received: from Ansuel-xps. (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.gmail.com with ESMTPSA id b10sm6573239wrt.36.2021.11.21.10.22.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Nov 2021 10:22:01 -0800 (PST)
Message-ID: <619a8e49.1c69fb81.8ed71.f713@mx.google.com>
X-Google-Original-Message-ID: <YZqOSIrpcC9mz8ny@Ansuel-xps.>
Date:   Sun, 21 Nov 2021 19:22:00 +0100
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan McDowell <noodles@earth.li>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [net PATCH 1/2] net: dsa: qca8k: fix internal delay applied to
 the wrong PAD config
References: <20211119020350.32324-1-ansuelsmth@gmail.com>
 <20211121181829.qymovkzzhxj2fn3v@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211121181829.qymovkzzhxj2fn3v@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 21, 2021 at 08:18:29PM +0200, Vladimir Oltean wrote:
> On Fri, Nov 19, 2021 at 03:03:49AM +0100, Ansuel Smith wrote:
> > With SGMII phy the internal delay is always applied to the PAD0 config.
> > This is caused by the falling edge configuration that hardcode the reg
> > to PAD0 (as the falling edge bits are present only in PAD0 reg)
> > Move the delay configuration before the reg overwrite to correctly apply
> > the delay.
> > 
> > Fixes: cef08115846e ("net: dsa: qca8k: set internal delay also for sgmii")
> > Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> > ---
> 
> This removes the need for your other patch "net: dsa: qca8k: skip sgmii
> delay on double cpu conf", right?
>

Correct the problem was really with overwriting and not with some
malfunction with setting the delay to both rgmii and sgmii.
And also as you pointed out, the delay was ignored with sgmii phy mode
and delay not declared in the dts.

> >  drivers/net/dsa/qca8k.c | 12 ++++++------
> >  1 file changed, 6 insertions(+), 6 deletions(-)
> > 
> > diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
> > index a429c9750add..d7bcecbc1c53 100644
> > --- a/drivers/net/dsa/qca8k.c
> > +++ b/drivers/net/dsa/qca8k.c
> > @@ -1433,6 +1433,12 @@ qca8k_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
> >  
> >  		qca8k_write(priv, QCA8K_REG_SGMII_CTRL, val);
> >  
> > +		/* From original code is reported port instability as SGMII also
> > +		 * require delay set. Apply advised values here or take them from DT.
> > +		 */
> > +		if (state->interface == PHY_INTERFACE_MODE_SGMII)
> > +			qca8k_mac_config_setup_internal_delay(priv, cpu_port_index, reg);
> > +
> >  		/* For qca8327/qca8328/qca8334/qca8338 sgmii is unique and
> >  		 * falling edge is set writing in the PORT0 PAD reg
> >  		 */
> > @@ -1455,12 +1461,6 @@ qca8k_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
> >  					QCA8K_PORT0_PAD_SGMII_TXCLK_FALLING_EDGE,
> >  					val);
> >  
> > -		/* From original code is reported port instability as SGMII also
> > -		 * require delay set. Apply advised values here or take them from DT.
> > -		 */
> > -		if (state->interface == PHY_INTERFACE_MODE_SGMII)
> > -			qca8k_mac_config_setup_internal_delay(priv, cpu_port_index, reg);
> > -
> >  		break;
> >  	default:
> >  		dev_err(ds->dev, "xMII mode %s not supported for port %d\n",
> > -- 
> > 2.32.0
> > 

-- 
	Ansuel
