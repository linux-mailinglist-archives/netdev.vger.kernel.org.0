Return-Path: <netdev+bounces-3941-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EFCE5709B15
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 17:18:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D7BDC1C21286
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 15:18:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 148DA1096D;
	Fri, 19 May 2023 15:18:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06D055670
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 15:18:25 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF55DCF
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 08:18:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=AebZ/funB7MiLJdmNYBbfq9V4Ujq0jGRfsaF8oPq1LE=; b=KwOhUgj/OghdKD3tWtIbMDwgIm
	wYddICvZnZJsHHJn9xMj3osBR1kMDHsKASQBfuh6Y/KTY9gpR3QGMvstpHjWhSkGx6k8/BufgQCSD
	f7JXUTq0oxp2Bt+iUMGzJel9ULNW9xjhiaWBsv2MB00YEwT3N9HRmLT5tvlCMyZoEupk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1q01rx-00DL8a-4Y; Fri, 19 May 2023 17:18:13 +0200
Date: Fri, 19 May 2023 17:18:13 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Richard Cochran <richardcochran@gmail.com>
Cc: Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	=?iso-8859-1?Q?K=F6ry?= Maincent <kory.maincent@bootlin.com>,
	netdev@vger.kernel.org, glipus@gmail.com,
	maxime.chevallier@bootlin.com, vladimir.oltean@nxp.com,
	vadim.fedorenko@linux.dev, gerhard@engleder-embedded.com,
	thomas.petazzoni@bootlin.com, krzysztof.kozlowski+dt@linaro.org,
	robh+dt@kernel.org, linux@armlinux.org.uk
Subject: Re: [PATCH net-next RFC v4 2/5] net: Expose available time stamping
 layers to user space.
Message-ID: <636d2189-f27a-49d9-a2c4-ea980a8cd63d@lunn.ch>
References: <20230406173308.401924-1-kory.maincent@bootlin.com>
 <20230406173308.401924-3-kory.maincent@bootlin.com>
 <20230406184646.0c7c2ab1@kernel.org>
 <5f9a1929-b511-707a-9b56-52cc5f1c40ba@intel.com>
 <ZGVZXTEn+qnMyNgV@hoboy.vegasvil.org>
 <32cb61b3-16f6-5b2b-4d57-5764dc8499cc@intel.com>
 <a5435c39-438c-434c-a0b5-73bf6ecd3a99@lunn.ch>
 <ZGd+m1MQPuL3S1V6@hoboy.vegasvil.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZGd+m1MQPuL3S1V6@hoboy.vegasvil.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 19, 2023 at 06:50:19AM -0700, Richard Cochran wrote:
> On Fri, May 19, 2023 at 02:50:42PM +0200, Andrew Lunn wrote:
> 
> > I would actually say there is nothing fundamentally blocking using
> > NETWORK_PHY_TIMESTAMPING with something other than DT. It just needs
> > somebody to lead the way.
> 
> +1
>  
> > For ACPI in the scope of networking, everybody just seems to accept DT
> > won, and stuffs DT properties into ACPI tables.
> 
> Is that stuff mainline?

There is some support. But it is somewhat limited.

ACPI and networking is an odd area. ACPI has historically been
x86. And few x86 SoCs have integrated networking. Those that do seem
to me to be PCI devices internally glued onto the PCIe bus, and
firmware driving the hardware, not Linux.

Integrated networking is much more popular for other architectures
SoCs, ARM, MIPS, PowerPc. These are all DT. And in general, Linux is
controlling the hardware, which is why we have good standardised DT
bindings for MDIO busses, PHYs, SFPs, etc.

Then ARM pushed ACPI for server class ARM systems. Now server class
systems generally don't have integrated Ethernet. They have lots of
PCIe lanes, and it seems normal to put one or more NICs on PCIe. That
also gives the flexibility you can get a high performance DPU from a
network specialist, or just a plain boring 10G PCIe device. As a
result, ACPI not saying anything about networking is not really an
issue for server class machines.

The little interest i've seen for ACPI networking has come from
'hobbist' trying to use ACPI on ARM systems which are not intended to
be servers. Generally, there is a fully working DT description of the
hardware, and Linux is happy to control the hardware using that DT
description. Getting ACPI to work is mostly straight forward, due to
most building blocks being standard. xhci for USB, ata for block
devices, etc.  But they then run into the complete lack of
standardisation for networking, and nothing at all about networking in
the ACPI standard. And these people tend not to be ACPI gurus who
could extend ACPI to cover the complexity of networking hardware. So
they just stuff the existing DT properties into ACPI tables and call
it done. And i have to push back on this, because they try to stuff
everything in, including properties we have deprecated because DT has
a long history and we got things wrong along the way.
 
> > For PCI devices, there
> > has been some good work being done by Trustnetic using software nodes,
> > for gluing together GPIO controllers, I2C controller, SFP and
> > PHYLINK.
> 
> mainline also?

On the way. Trustnetic got thrown in the deep end. They are new to
mainline. They brought a typical "vendor crap driver" and tried to get
it mainlined. It reinvented everything rather then reuse what already
exists in Linux. So they are effectively writing a new driver under
our guidance. It is an unusual device, because it is a PCIe device,
but without firmware. Linux controls everything. So they have the
double trouble of being mainline newbies, plus having to do things
with mainline that nobody else has done before in order to support
their hardware. So it is moving slow. But they are sticking at it, so
i think in the end they will get it working, and it could become a
reference for others to follow.

      Andrew

