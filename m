Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1236F198CB
	for <lists+netdev@lfdr.de>; Fri, 10 May 2019 09:14:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727010AbfEJHOX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 May 2019 03:14:23 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:42946 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726855AbfEJHOX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 May 2019 03:14:23 -0400
Received: by mail-wr1-f65.google.com with SMTP id l2so6385131wrb.9
        for <netdev@vger.kernel.org>; Fri, 10 May 2019 00:14:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=8vhSJYdbDo4hmcaw9TnoN03bZbsoMDpBUCHFXbyR/K4=;
        b=MFqL+9+X0sm8BkKpuJx1bVMj4iTTj/Co1wnnjYzzhiHXTtgGQdpFJ/jOyFJkcjjGiS
         O5eaPpK9+JlbuRLuiSKOoGvBPP86sklq5AD0KwT1ldvyhMHhMwxCIBlvxDBAwQb/Q+ci
         XBFmNosme4K+SuuHyNh5RsTZv1HUlgjYsiovIfM0NeQr8BaSP2364n+F+GtyKJi1ybSN
         Q/PG0iYZ9HoThBZAuRlFlUX1O13V+gGaP8V9mr6onT7QJMnsx334A6+F8d9sO/z41M2l
         SrW0gJRpTQlS/y2rD5B41QSK3T8NMVLmCtklijPr55KNtgO4ZPpfpqKFBCM6dRD43NGw
         38pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=8vhSJYdbDo4hmcaw9TnoN03bZbsoMDpBUCHFXbyR/K4=;
        b=rDvtQg6ktZxnMGAYJKDYgIEiqDmuibt8t9T/TPk6Snk1LBhBmyCDmj4TXj11OlgXCI
         fX2/x+cqpDhIzKq9vRXoNLXripZ8aG1rb9vATfrguGzd+BKQRRxF8TeFoh25o5umCGWw
         PyknYsYdOnRf9TT5Qeqwf3vt/ByiKMlMKbm6d5NyvpzzoZz3m+VVzradj+X7+A25ndVi
         aNQoJMoZ9aK60jIIwFln/6qz0IWhqd+YVEScF9AiSH97L3jZo1BsJ/78ji/maoqAHsCf
         ZPPMwrFBGmv6OqJMtaC1pqgLw1LQftvlvBDV7435gmPtOtaATeTWZfnLmBDgQkIp2xRT
         QhUQ==
X-Gm-Message-State: APjAAAUfwiuK7JLeoD7D+RBBUKcqC7bxiOHTp0UdHo2uJ2ynd4EzjAw9
        ypA1J1Su9R87oGytj+T3b54aqQ==
X-Google-Smtp-Source: APXvYqy69mm3aXgNaBk9C+3iR8OkVvrFzyQEUwiMhFLr8AJ5XTD2ckTjNjPH+iiVTrKXhGZnZj3hgg==
X-Received: by 2002:a05:6000:1250:: with SMTP id j16mr6226051wrx.200.1557472461889;
        Fri, 10 May 2019 00:14:21 -0700 (PDT)
Received: from dell ([2.27.167.43])
        by smtp.gmail.com with ESMTPSA id l16sm1856711wrb.40.2019.05.10.00.14.20
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 10 May 2019 00:14:21 -0700 (PDT)
Date:   Fri, 10 May 2019 08:14:19 +0100
From:   Lee Jones <lee.jones@linaro.org>
To:     Thomas Bogendoerfer <tbogendoerfer@suse.de>
Cc:     Ralf Baechle <ralf@linux-mips.org>,
        Paul Burton <paul.burton@mips.com>,
        James Hogan <jhogan@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.com>, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        netdev@vger.kernel.org, linux-rtc@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: Re: [PATCH v2 2/4] mfd: ioc3: Add driver for SGI IOC3 chip
Message-ID: <20190510071419.GB7321@dell>
References: <20190409154610.6735-1-tbogendoerfer@suse.de>
 <20190409154610.6735-3-tbogendoerfer@suse.de>
 <20190508102313.GG3995@dell>
 <20190509160220.bb5382df931e5bd0972276df@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190509160220.bb5382df931e5bd0972276df@suse.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 09 May 2019, Thomas Bogendoerfer wrote:

> On Wed, 8 May 2019 11:23:13 +0100
> Lee Jones <lee.jones@linaro.org> wrote:
> 
> > On Tue, 09 Apr 2019, Thomas Bogendoerfer wrote:
> > 
> > > +static u32 crc8_addr(u64 addr)
> > > +{
> > > +	u32 crc = 0;
> > > +	int i;
> > > +
> > > +	for (i = 0; i < 64; i += 8)
> > > +		crc8_byte(&crc, addr >> i);
> > > +	return crc;
> > > +}
> > 
> > Not looked into these in any detail, but are you not able to use the
> > CRC functions already provided by the kernel?
> 
> they are using a different polynomial, so I can't use it.

Would it be worth moving support out to somewhere more central so
others can use this "polynomial"?

> > > +	}
> > > +	pr_err("ioc3: CRC error in NIC address\n");
> > > +}
> > 
> > This all looks like networking code.  If this is the case, it should
> > be moved to drivers/networking or similar.
> 
> no it's not. nic stands for number in a can produced by Dallas Semi also
> known under the name 1-Wire (https://en.wikipedia.org/wiki/1-Wire).
> SGI used them to provide partnumber, serialnumber and mac addresses.
> By placing the code to read the NiCs inside ioc3 driver there is no need
> for locking and adding library code for accessing these informations.

Great.  So it looks like you should be using this, no?

  drivers/base/regmap/regmap-w1.c

> > > +static struct resource ioc3_uarta_resources[] = {
> > > +	DEFINE_RES_MEM(offsetof(struct ioc3, sregs.uarta),
> > 
> > You are the first user of offsetof() in MFD.  Could you tell me why
> > it's required please?
> 
> to get the offsets of different chip functions out of a struct.

I can see what it does on a coding level.

What are you using it for in practical/real terms?

Why wouldn't any other MFD driver require this, but you do?

> > Please drop all of these and statically create the MFD cells like
> > almost all other MFD drivers do.
> 
> I started that way and it blew up the driver and create a bigger mess
> than I wanted to have. What's your concern with my approach ?
> 
> I could use static mfd_cell arrays, if there would be a init/startup
> method per cell, which is called before setting up the platform device.
> That way I could do the dynamic setup for ethernet and serial devices.

You can set platform data later.  There are plenty of examples of
this in the MFD subsystem.  Statically define what you can, and add
the dynamic stuff later.

> > > +static void ioc3_create_devices(struct ioc3_priv_data *ipd)
> > > +{
> > > +	struct mfd_cell *cell;
> > > +
> > > +	memset(ioc3_mfd_cells, 0, sizeof(ioc3_mfd_cells));
> > > +	cell = ioc3_mfd_cells;
> > > +
> > > +	if (ipd->info->funcs & IOC3_ETH) {
> > > +		memcpy(ioc3_eth_platform_data.mac_addr, ipd->nic_mac,
> > > +		       sizeof(ioc3_eth_platform_data.mac_addr));
> > 
> > Better to pull the MAC address from within the Ethernet driver.
> 
> the NiC where the MAC address is provided is connected to the ioc3
> chip outside of the ethernet register set. And there is another
> NiC connected to the same 1-W bus. So moving reading of the MAC
> address to the ethernet driver duplicates code and adds complexity
> (locking). Again what's your concern here ?

Does this go away if you use the already provided 1-wire API?

> > > +	if (ipd->info->funcs & IOC3_SER) {
> > > +		writel(GPCR_UARTA_MODESEL | GPCR_UARTB_MODESEL,
> > > +			&ipd->regs->gpcr_s);
> > > +		writel(0, &ipd->regs->gppr[6]);
> > > +		writel(0, &ipd->regs->gppr[7]);
> > > +		udelay(100);
> > > +		writel(readl(&ipd->regs->port_a.sscr) & ~SSCR_DMA_EN,
> > > +		       &ipd->regs->port_a.sscr);
> > > +		writel(readl(&ipd->regs->port_b.sscr) & ~SSCR_DMA_EN,
> > > +		       &ipd->regs->port_b.sscr);
> > > +		udelay(1000);
> > 
> > No idea what any of this does.
> > 
> > It looks like it belongs in the serial driver (and needs comments).
> 
> it configures the IOC3 chip for serial usage. This is not part of
> the serial register set, so it IMHO belongs in the MFD driver.

So it does serial things, but doesn't belong in the serial driver?

Could you please go into a bit more detail as to why you think that?

Why is it better here?

It's also totally unreadable by the way!

> > > +	}
> > > +#if defined(CONFIG_SGI_IP27)
> > 
> > What is this?  Can't you obtain this dynamically by probing the H/W?
> 
> that's the machine type and the #ifdef CONFIG_xxx are just for saving space,
> when compiled for other machines and it's easy to remove.

Please find other ways to save the space.  #ifery can get very messy,
very quickly and is almost always avoidable.

> > > +	if (ipd->info->irq_offset) {
> > 
> > What does this really signify?
> 
> IOC3 ASICs are most of the time connected to a SGI bridge chip. IOC3 can
> provide two interrupt lines, which are wired to the bridge chip. The first
> interrupt is assigned via the PCI core, but since IOC3 is not a PCI multi
> function device the second interrupt must be treated here. And the used
> interrupt line on the bridge chip differs between boards.

Please provide a MACRO, function or something else which results in
more readable code.  Whatever you choose to use, please add this text
above, it will be helpful for future readers.

> Thank you for your review. I'll address all other comments not cited in
> my mail.

NP

-- 
Lee Jones [李琼斯]
Linaro Services Technical Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
