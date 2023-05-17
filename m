Return-Path: <netdev+bounces-3446-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BDB9F707287
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 21:46:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 777582816B3
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 19:46:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A2E334CF6;
	Wed, 17 May 2023 19:46:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A2D6111AD
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 19:46:54 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75354E61
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 12:46:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=njMnH353mMtc+zoSSHk7eQbJtdd8Ef8tQ2WBlNsL9xw=; b=la3jqWxaATp6SUh4f47+rtmcol
	olZrrQ2e6JdVqVrEt3+okomJvvYeYQVOM8UBD5pjNGLp2iNmY3gfdpx2FRS4VtwZVs0pW2IkdEbCP
	xZjcolxD5irlnWGqewCDFTL84cvWwMHlGknWIuVc4KESW3ufunkKY8Q9YBjXr/HfmSm4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1pzN6h-00DAR7-1U; Wed, 17 May 2023 21:46:43 +0200
Date: Wed, 17 May 2023 21:46:43 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Vladimir Oltean <vladimir.oltean@nxp.com>,
	"Russell King (Oracle)" <linux@armlinux.org.uk>,
	=?iso-8859-1?Q?K=F6ry?= Maincent <kory.maincent@bootlin.com>,
	netdev@vger.kernel.org, glipus@gmail.com,
	maxime.chevallier@bootlin.com, vadim.fedorenko@linux.dev,
	richardcochran@gmail.com, gerhard@engleder-embedded.com,
	thomas.petazzoni@bootlin.com, krzysztof.kozlowski+dt@linaro.org,
	robh+dt@kernel.org
Subject: Re: [PATCH net-next RFC v4 2/5] net: Expose available time stamping
 layers to user space.
Message-ID: <2f89e35e-b1c9-4e08-9f60-73a96cc6e51a@lunn.ch>
References: <20230511203646.ihljeknxni77uu5j@skbuf>
 <54e14000-3fd7-47fa-aec3-ffc2bab2e991@lunn.ch>
 <ZF1WS4a2bbUiTLA0@shell.armlinux.org.uk>
 <20230511210237.nmjmcex47xadx6eo@skbuf>
 <20230511150902.57d9a437@kernel.org>
 <20230511230717.hg7gtrq5ppvuzmcx@skbuf>
 <20230511161625.2e3f0161@kernel.org>
 <20230512102911.qnosuqnzwbmlupg6@skbuf>
 <20230512103852.64fd608b@kernel.org>
 <20230517121925.518473aa@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230517121925.518473aa@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 17, 2023 at 12:19:25PM -0700, Jakub Kicinski wrote:
> On Fri, 12 May 2023 10:38:52 -0700 Jakub Kicinski wrote:
> > On Fri, 12 May 2023 13:29:11 +0300 Vladimir Oltean wrote:
> > > On Thu, May 11, 2023 at 04:16:25PM -0700, Jakub Kicinski wrote:  
> > > > Oh, you should tell me, maybe off-list then. 'Cause I don't know any.    
> > > 
> > > I hope the examples given in private will make you reconsider the
> > > validity of my argument about DMA timestamps.  
> > 
> > I may have lost track of what the argument is. There are devices
> > which will provide a DMA stamp for Tx and Rx. We need an API that'll
> > inform the user about it. 
> > 
> > To be clear I'm talking about drivers which are already in the tree,
> > not opening the door for some shoddy new HW in.
> 
> It dawned on me while reading a phylink discussion that I may have
> misunderstood the meaning of the MAC vs PHY time stamp sources.
> By the standard - stamping happens under the MAC, so MAC is 
> the "right" place to stamp, not the PHY. And there can be multiple 
> PHYs technically? Are we just using the MAC vs PHY thing as an
> implementation aid, to know which driver to send the request to?
> 
> Shouldn't we use the clock ID instead?

As i said in an earlier thread, with a bit of a stretch, there could
be 7 places to take time stamps in the system. We need some sort of
identifier to indicate which of these stampers to use.

Is clock ID unique? In a switch, i think there could be multiple
stampers, one per MAC port, sharing one clock? So you actually need
more than a clock ID.

Also, 'By the standard - stamping happens under the MAC'. Which MAC?
There can be multple MAC's in the pipeline. MACSEC and rate adaptation
in the PHY are often implemented by the PHY having a MAC
reconstituting the frame from the bitstream and putting it into a
queue. Rate adaptation can then be performed by the PHY by sending
pause frames to the 'primary' MAC to slow it down. MACSEC in the PHY
takes frames in the queues and if they match a filter they get
encrypted. The PHY then takes the frame out of the queue and passes
them to a second MAC in the PHY which creates a bitstream and then to
a 'PHY' to generate signals for the line.

In this sort of setup, you obviously don't want the 'primary' MAC
doing the stamping. You want the MAC nearest to the line, or better
still the 'PHY' within the PHY just before the line.

      Andrew

