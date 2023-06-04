Return-Path: <netdev+bounces-7763-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 40C517216FC
	for <lists+netdev@lfdr.de>; Sun,  4 Jun 2023 14:35:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 73AAF281112
	for <lists+netdev@lfdr.de>; Sun,  4 Jun 2023 12:35:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF11B4423;
	Sun,  4 Jun 2023 12:35:17 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 992053C26
	for <netdev@vger.kernel.org>; Sun,  4 Jun 2023 12:35:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 747E9C433D2;
	Sun,  4 Jun 2023 12:35:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685882116;
	bh=LAU3MqFiobE6h+SNuyH1VdksI4ZIOJWXcHjmQ+ID920=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NdfIwx8frvudVykT7PcTe3xuiLOPfEb79fDrfmPsOR3xal90A7lphS+5S26ywQvsd
	 ELB8Xwj5t1ek2NN6ayc5WYeAwx5NSIO/A4X2Zc0FgRJb1II6xFm5DH/6Cb9VbQYLTM
	 /r6PXJ2Khr19OtTnl4ShttWaEQFmwQOCRYgfeyTN41GUuHxALMdaCuvrDrWDeIZRYG
	 hFypbo1ZuISoHHmE0P4/isxZ9BDX0zSDE606kAMdUMiHJAF06xua9BfRxjhbIdscAn
	 cn6gwUfuldpTKzcadgrD0jcZ1UeNYuCNUGiQjnS++Y8QLZD6swzG5yZ4rKRBV65JhF
	 v0HQCmitrkWHg==
Date: Sun, 4 Jun 2023 20:35:04 +0800
From: Shawn Guo <shawnguo@kernel.org>
To: "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc: Vladimir Oltean <vladimir.oltean@nxp.com>, Andrew Lunn <andrew@lunn.ch>,
	s.hauer@pengutronix.de, arm@kernel.org,
	netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH v2] ARM: dts: vf610: ZII: Add missing phy-mode and fixed
 links
Message-ID: <20230604123504.GJ4199@dragon>
References: <20230525182606.3317923-1-andrew@lunn.ch>
 <20230525182606.3317923-1-andrew@lunn.ch>
 <20230529133507.y7ph5x2u3drlt5zd@skbuf>
 <20230604120748.GC4199@dragon>
 <ZHyCg+Anqsdvt4V9@shell.armlinux.org.uk>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZHyCg+Anqsdvt4V9@shell.armlinux.org.uk>

On Sun, Jun 04, 2023 at 01:24:35PM +0100, Russell King (Oracle) wrote:
> On Sun, Jun 04, 2023 at 08:07:48PM +0800, Shawn Guo wrote:
> > On Mon, May 29, 2023 at 04:35:07PM +0300, Vladimir Oltean wrote:
> > > On Thu, May 25, 2023 at 08:26:06PM +0200, Andrew Lunn wrote:
...
> > > > diff --git a/arch/arm/boot/dts/vf610-zii-ssmb-spu3.dts b/arch/arm/boot/dts/vf610-zii-ssmb-spu3.dts
> > > > index 20beaa8433b6..f5ae0d5de315 100644
> > > > --- a/arch/arm/boot/dts/vf610-zii-ssmb-spu3.dts
> > > > +++ b/arch/arm/boot/dts/vf610-zii-ssmb-spu3.dts
> > > > @@ -154,7 +154,7 @@ ports {
> > > >  
> > > >  				port@0 {
> > > >  					reg = <0>;
> > > > -					label = "cpu";
> > > > +					phy-mode = "rmii";
> > > >  					ethernet = <&fec1>;
> > > >  
> > > >  					fixed-link {
> > > 
> > > Shouldn't these have been rev-rmii to be consistent with what was done
> > > for arm64?
> > 
> > Should I drop the patch for now, or can this be changed incrementally if
> > needed?
> 
> What we have here is something that is "close enough". It isn't 100%
> correct, but acceptable for the time being, and isn't something that
> will ever become a problem, since the hardware itself can not have
> its interface mode changed (it's set by pin strapping.)
> 
> It's something that can be fixed later.

Thanks for the clarification, Russell!

Shawn

