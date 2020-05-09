Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B49D1CC1C4
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 15:25:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727789AbgEINZk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 09:25:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726013AbgEINZk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 May 2020 09:25:40 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:3201:214:fdff:fe10:1be6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A0C6C061A0C;
        Sat,  9 May 2020 06:25:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=xxlsFN8Q2F7QH7NHZLiYgcMIZjPCMsIK8HIfpq4aIt4=; b=CC1qQzYwUvi3gcWuWkniLvbVn
        +1SRe5Cwu1ktiXbITbx+OQsj8ufkHeYyYXavUQ5G5gwuX8rEDg/htQ5Z3UTaSlk1FaY3fbig7HjaG
        4jngtXZSQnGJNq86asL7QOfbiLmUL4ynk0NVBKbW4DfmWiRrCwmjM83LRyssNFOg4ypmuT5CDjrBv
        p8Hzmc5aThtcAw2lvomwaQSPUA55cbUugMVtTVHNQT2EopMpJlHYOwfb99RjDxWfYUtnWSiC3iwfG
        X/VuA0b750K672ePelBIBzgBLRIMg+49G/ukh6HsSUZnSw8FcWZI4KjPwFRVaCNsxQL3SqKCMQW1G
        7KVQRW2aA==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:38026)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jXPTr-0003zF-P5; Sat, 09 May 2020 14:25:29 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jXPTo-0002su-Mn; Sat, 09 May 2020 14:25:24 +0100
Date:   Sat, 9 May 2020 14:25:24 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Stefan Chulski <stefanc@marvell.com>
Cc:     Matteo Croce <mcroce@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        "gregory.clement@bootlin.com" <gregory.clement@bootlin.com>,
        "miquel.raynal@bootlin.com" <miquel.raynal@bootlin.com>,
        Nadav Haklai <nadavh@marvell.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>
Subject: Re: [EXT] Re: [PATCH net-next 3/5] net: mvpp2: cls: Use RSS contexts
 to handle RSS tables
Message-ID: <20200509132524.GD1551@shell.armlinux.org.uk>
References: <20190524100554.8606-1-maxime.chevallier@bootlin.com>
 <20190524100554.8606-4-maxime.chevallier@bootlin.com>
 <CAGnkfhzsx_uEPkZQC-_-_NamTigD8J0WgcDioqMLSHVFa3V6GQ@mail.gmail.com>
 <20200423170003.GT25745@shell.armlinux.org.uk>
 <CAGnkfhwOavaeUjcm4_+TG-xLxQA519o+fR8hxBCCfSy3qpcYhQ@mail.gmail.com>
 <DM5PR18MB1146686527DE66495F75D0DAB0A30@DM5PR18MB1146.namprd18.prod.outlook.com>
 <CAGnkfhwV4YyR9f1KC8VFx4FPRYkAoXXUURa715wb3+=23=rr6Q@mail.gmail.com>
 <DM5PR18MB11462564D691544445CA2A43B0A30@DM5PR18MB1146.namprd18.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM5PR18MB11462564D691544445CA2A43B0A30@DM5PR18MB1146.namprd18.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 09, 2020 at 12:31:21PM +0000, Stefan Chulski wrote:
> > -----Original Message-----
> > From: Matteo Croce <mcroce@redhat.com>
> > Sent: Saturday, May 9, 2020 3:16 PM
> > To: Stefan Chulski <stefanc@marvell.com>
> > Cc: David S . Miller <davem@davemloft.net>; Maxime Chevallier
> > <maxime.chevallier@bootlin.com>; netdev <netdev@vger.kernel.org>; LKML
> > <linux-kernel@vger.kernel.org>; Antoine Tenart
> > <antoine.tenart@bootlin.com>; Thomas Petazzoni
> > <thomas.petazzoni@bootlin.com>; gregory.clement@bootlin.com;
> > miquel.raynal@bootlin.com; Nadav Haklai <nadavh@marvell.com>; Marcin
> > Wojtas <mw@semihalf.com>; Linux ARM <linux-arm-
> > kernel@lists.infradead.org>; Russell King - ARM Linux admin
> > <linux@armlinux.org.uk>
> > Subject: Re: [EXT] Re: [PATCH net-next 3/5] net: mvpp2: cls: Use RSS contexts to
> > handle RSS tables
> > 
> > Hi,
> > 
> > The point is that RXHASH works fine on all interfaces, but on the gigabit one
> > (eth2 usually).
> > And on the 10 gbit interface is very very effective, the throughput goes 4x when
> > enabled, so it would be a big drawback to disable it on all interfaces.
> > 
> > Honestly I don't have any 2.5 gbit hardware to test it on eth3, so I don't know if
> > rxhash actually only works on the first interface of a unit (so eth0 and eth1), or
> > if it just doesn't work on the gigabit one.
> > 
> > If someone could test it on the 2.5 gbit port, this will be helpful.
> 
> RSS tables is part of Packet Processor IP, not MAC(so it's not related to specific speed). Probably issue exist on specific packet processor ports.
> Since RSS work fine on first port of the CP, we can do the following:
> if (port-> id == 0)
> 	dev->hw_features |= NETIF_F_RXHASH;

I can confirm that Macchiatobin Single Shot eth0 port works with a
1G Fibre SFP or 10G DA SFP with or without rxhash on.

So it seems Stefan's hunch that it is port related is correct.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up
