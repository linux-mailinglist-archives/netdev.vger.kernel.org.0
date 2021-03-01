Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DE58327916
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 09:22:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232888AbhCAIWF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Mar 2021 03:22:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232849AbhCAIV6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 03:21:58 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 491C9C06174A
        for <netdev@vger.kernel.org>; Mon,  1 Mar 2021 00:21:17 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id ci14so7588897ejc.7
        for <netdev@vger.kernel.org>; Mon, 01 Mar 2021 00:21:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=EoXFYeEw3KEDQKOrwVz/cIXJahTTaeLX0DT+rLifwdI=;
        b=bb0QRgXb8Yet/pNSa+nDWdjPbwkQoj3pnNrqdtbWeNr3wrMj8n/vUOIY8Aqy6i6ogt
         rCPIsQL1hcyuWWEYvVdh0NQGcISaJwY5sKYIuf0OCCGyzgpASuo1v1mEjblgTo05Vtl3
         pYxrERXgPkobwDBgb8qHigANNUriamd0OwWKIbrgedFmMJ7ugMLWfzFMSM/JGmOYYpZ/
         Choor3Qtgufut7a9w3qkXWcm/0nBpTpwnzVDo83eBAJZHpb9BeJLSG3O7KjZCuZUp6Nc
         eNHfCZoq1bdJmwJkdbYlHKKtGFsfOWv5RdnfYiBJ/6HaQeoTmojMUVoHE2Id98cOMCvT
         C5sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=EoXFYeEw3KEDQKOrwVz/cIXJahTTaeLX0DT+rLifwdI=;
        b=NPKH6y5xw4aBdZ4Hcia+QlEfJivOMJ+3foe07GCosZNmI1EA13BKwEO6f7EVUcIhzY
         xyKZb01bzHE76DahMB3Y+oNiEXEEBaee3znqL35oKCP/I3cjswM0Jfmc2+XA1L0xMzI0
         UhxCG3mjbjVg2SDH+VuaAiIlPQjuqRhzpz4aHTebdIPfVJQauJNNCzUDuUsmAKXtkBho
         ScdbPJ2y+RB9+sprUSj4ZtKXzHY2yB2MIxbSwydBI/XLLcNa8jO5ofE5HTwGY2f6ygwQ
         u8yzMUZH2ZoJQZfwwNyU/fRy+9vNkzJM4v+lSzKLDdMRMO5UE9vZE+VsemcrHnX3bNGJ
         lLaQ==
X-Gm-Message-State: AOAM533FCbNEVTpEUX8yOPR0kUScn04tucz9Sa/eCBR9IjyUYAcxyZdZ
        DDU8Qv8cUGvNvLicS2pFDfI=
X-Google-Smtp-Source: ABdhPJwvrabCJsqWQUjYI6nP+JLO1n6lWGfgT6+/m6UwJ6YPQmw8CpALe5dm9UBCY9qIXCuB7D8eyA==
X-Received: by 2002:a17:907:2513:: with SMTP id y19mr14660248ejl.241.1614586875891;
        Mon, 01 Mar 2021 00:21:15 -0800 (PST)
Received: from skbuf ([188.25.217.13])
        by smtp.gmail.com with ESMTPSA id r5sm13316705ejx.96.2021.03.01.00.21.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Mar 2021 00:21:15 -0800 (PST)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
X-Google-Original-From: Ioana Ciornei <ciornei.ioana@gmail.com>
Date:   Mon, 1 Mar 2021 10:21:14 +0200
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Ioana Ciornei <ciorneiioana@gmail.com>, davem@davemloft.net,
        netdev@vger.kernel.org, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk, Ioana Ciornei <ioana.ciornei@nxp.com>,
        Sven Schuchmann <schuchmann@schleissheimer.de>
Subject: Re: [PATCH net] net: phy: ti: take into account all possible
 interrupt sources
Message-ID: <20210301082114.4cniggpjletsnibj@skbuf>
References: <20210226153020.867852-1-ciorneiioana@gmail.com>
 <20210228120027.76488180@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210228120027.76488180@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 28, 2021 at 12:00:27PM -0800, Jakub Kicinski wrote:
> On Fri, 26 Feb 2021 17:30:20 +0200 Ioana Ciornei wrote:
> > diff --git a/drivers/net/phy/dp83822.c b/drivers/net/phy/dp83822.c
> > index be1224b4447b..f7a2ec150e54 100644
> > --- a/drivers/net/phy/dp83822.c
> > +++ b/drivers/net/phy/dp83822.c
> > @@ -290,6 +290,7 @@ static int dp83822_config_intr(struct phy_device *phydev)
> >  
> >  static irqreturn_t dp83822_handle_interrupt(struct phy_device *phydev)
> >  {
> > +	bool trigger_machine = false;
> >  	int irq_status;
> >  
> >  	/* The MISR1 and MISR2 registers are holding the interrupt status in
> > @@ -305,7 +306,7 @@ static irqreturn_t dp83822_handle_interrupt(struct phy_device *phydev)
> >  		return IRQ_NONE;
> >  	}
> >  	if (irq_status & ((irq_status & GENMASK(7, 0)) << 8))
> > -		goto trigger_machine;
> > +		trigger_machine = true;
> >  
> >  	irq_status = phy_read(phydev, MII_DP83822_MISR2);
> >  	if (irq_status < 0) {
> > @@ -313,11 +314,11 @@ static irqreturn_t dp83822_handle_interrupt(struct phy_device *phydev)
> >  		return IRQ_NONE;
> >  	}
> >  	if (irq_status & ((irq_status & GENMASK(7, 0)) << 8))
> > -		goto trigger_machine;
> > +		trigger_machine = true;
> >  
> > -	return IRQ_NONE;
> > +	if (!trigger_machine)
> > +		return IRQ_NONE;
> >  
> > -trigger_machine:
> >  	phy_trigger_machine(phydev);
> >  
> >  	return IRQ_HANDLED;
> 
> Would it be better to code it up as:
> 
> 	irqreturn_t ret = IRQ_NONE;
> 
> 	if (irq_status & ...)
> 		ret = IRQ_HANDLED;
> 
> 	/* .. */
> 
> 	if (ret != IRQ_NONE)
> 		phy_trigger_machine(phydev);
> 
> 	return ret;
> 
> That reads a tiny bit better to me, but it's probably majorly
> subjective so I'm happy with existing patch if you prefer it.

I think I prefer it as it is and this is because it would be in line
with all the other PHY drivers which do this:

	if (!(irq_status & int_enabled))
		return IRQ_NONE;

	phy_trigger_machine(phydev);

	return IRQ_HANDLED;

Ioana
