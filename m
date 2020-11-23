Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E8182C0F56
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 16:56:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732730AbgKWPvz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 10:51:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731987AbgKWPvy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 10:51:54 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EDD6C0613CF;
        Mon, 23 Nov 2020 07:51:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=Bj8IsgcBUP1tMlbxsnt+v78ZaLFATDewDNz07x7jB8E=; b=lNFVhTRmgDvSLwPcVyLjphrWX
        yrDoxWB9bc32VqepIvRNt0LpSSLM8Mkl+FKitGFVDpiGfHs5tFtiHQpZWgoy952o8fUiyIR7aqDp7
        +TP/4sppx4NjqKQ5efNUqZQomo8dQv1nYeL1Ug/GGQbFBI0CaV0mqQ1NwX1tJ5cNCmrraHwFB7AhD
        wWKatgkFf+PfSDGYgL0rZb+vQkOPFhKGgGB1DYkDhoX6lMoqUxXLfU2bXUAd25aSv8QscBo3V3ClO
        kFg2lic1ywy6UTpm7KbDSEm6q02hsycgkA8JP7kG3BfT6PVj6gfST0p/lPq8jVCs5S09sidbXe/z3
        m70yNM4aw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35116)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1khE87-0006CQ-Fh; Mon, 23 Nov 2020 15:51:51 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1khE84-0006RU-Ly; Mon, 23 Nov 2020 15:51:48 +0000
Date:   Mon, 23 Nov 2020 15:51:48 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Stefan Chulski <stefanc@marvell.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Nadav Haklai <nadavh@marvell.com>,
        Yan Markman <ymarkman@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "mw@semihalf.com" <mw@semihalf.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>
Subject: Re: [EXT] Re: [PATCH v1] net: mvpp2: divide fifo for dts-active
 ports only
Message-ID: <20201123155148.GX1551@shell.armlinux.org.uk>
References: <1606143160-25589-1-git-send-email-stefanc@marvell.com>
 <20201123151049.GV1551@shell.armlinux.org.uk>
 <CO6PR18MB3873522226E3F9A608371289B0FC0@CO6PR18MB3873.namprd18.prod.outlook.com>
 <20201123153332.GW1551@shell.armlinux.org.uk>
 <CO6PR18MB3873B4205ECAF2383F9539CCB0FC0@CO6PR18MB3873.namprd18.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CO6PR18MB3873B4205ECAF2383F9539CCB0FC0@CO6PR18MB3873.namprd18.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 23, 2020 at 03:44:05PM +0000, Stefan Chulski wrote:
> > > > On Mon, Nov 23, 2020 at 04:52:40PM +0200, stefanc@marvell.com wrote:
> > > > > From: Stefan Chulski <stefanc@marvell.com>
> > > > >
> > > > > Tx/Rx FIFO is a HW resource limited by total size, but shared by
> > > > > all ports of same CP110 and impacting port-performance.
> > > > > Do not divide the FIFO for ports which are not enabled in DTS, so
> > > > > active ports could have more FIFO.
> > > > >
> > > > > The active port mapping should be done in probe before FIFO-init.
> > > >
> > > > It would be nice to know what the effect is from this - is it a
> > > > small or large boost in performance?
> > >
> > > I didn't saw any significant improvement with LINUX bridge or
> > > forwarding, but this reduced PPv2 overruns drops, reduced CRC sent errors
> > with DPDK user space application.
> > > So this improved zero loss throughput. Probably with XDP we would see a
> > similar effect.
> > >
> > > > What is the effect when the ports on a CP110 are configured for 10G,
> > > > 1G, and 2.5G in that order, as is the case on the Macchiatobin board?
> > >
> > > Macchiatobin has two CP's.  CP1 has 3 ports, so the distribution of FIFO would
> > be the same as before.
> > > On CP0 which has a single port, all FIFO would be allocated for 10G port.
> > 
> > Your code allocates for CP1:
> > 
> > 32K to port 0 (the 10G port on Macchiatobin) 8K to port 1 (the 1G dedicated
> > ethernet port on Macchiatobin) 4K to port 2 (the 1G/2.5G SFP port on
> > Macchiatobin)
> > 
> > I'm questioning that allocation for port 1 and 2.
> 
> Yes, but this allocation exists also in current code.
> From HW point of view(MAC and PPv2) maximum supported speed
> in CP110: port 0 - 10G, port 1 - 2.5G, port 2 - 2.5G.
> in CP115: port 0 - 10G, port 1 - 5G, port 2 - 2.5G.
> 
> So this allocation looks correct at least for CP115.
> Problem that we cannot reallocate FIFO during runtime, after specific speed negotiation.

We could do much better. DT has a "max-speed" property for ethernet
controllers. If we have that property, then I think we should use
that to determine the initialisation time FIFO allocation.

As I say, on Macchiatobin, the allocations we end up with are just
crazy when you consider the port speeds that the hardware supports.
Maybe that should be done as a follow-on patch - but I think it
needs to be done.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
