Return-Path: <netdev+bounces-3436-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 66D307071E1
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 21:19:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 22A2E2811A5
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 19:19:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B40D31F05;
	Wed, 17 May 2023 19:19:28 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31868111B4
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 19:19:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94156C433EF;
	Wed, 17 May 2023 19:19:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684351167;
	bh=pv57v+L5LwhleTIr9vC89uYE5ANrp9INSfimIZ+XJ/4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=RGdwc8YTyeX6ejoPilPUlTpIA45HryV3udFORfyFUbsLAGgAFhzbaF9Ajl0SHrw8d
	 ofoG7UTVzZEjUbf8ao96/KTEEJ9QY+zDCdPTw5Mixns5gazR3QI/bpR0RgRtPMr2+u
	 pk4cadZZ7AJnoJm7LhfzqhhoKMhNSwR6f+hBl3G0CK67K693AYCLpkXbs3KZe3yUOt
	 tdpYlG6aGD2AnQY1GS+mvH8A1RAXmmNBLTPtkfZb8JrJ1TG07coaPszUjA+JPyi7Fv
	 6+xhRTQZXYVCqfdhWMvTPd/lPoGL4r7rjJC1kS/vDkgc8NoaoMfrOrm+U0IgJgd9PE
	 YajnSWAlQmWHg==
Date: Wed, 17 May 2023 12:19:25 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Vladimir Oltean <vladimir.oltean@nxp.com>
Cc: "Russell King (Oracle)" <linux@armlinux.org.uk>, Andrew Lunn
 <andrew@lunn.ch>, =?UTF-8?B?S8O2cnk=?= Maincent
 <kory.maincent@bootlin.com>, netdev@vger.kernel.org, glipus@gmail.com,
 maxime.chevallier@bootlin.com, vadim.fedorenko@linux.dev,
 richardcochran@gmail.com, gerhard@engleder-embedded.com,
 thomas.petazzoni@bootlin.com, krzysztof.kozlowski+dt@linaro.org,
 robh+dt@kernel.org
Subject: Re: [PATCH net-next RFC v4 2/5] net: Expose available time stamping
 layers to user space.
Message-ID: <20230517121925.518473aa@kernel.org>
In-Reply-To: <20230512103852.64fd608b@kernel.org>
References: <20230406173308.401924-1-kory.maincent@bootlin.com>
	<20230406173308.401924-3-kory.maincent@bootlin.com>
	<20230406184646.0c7c2ab1@kernel.org>
	<20230511203646.ihljeknxni77uu5j@skbuf>
	<54e14000-3fd7-47fa-aec3-ffc2bab2e991@lunn.ch>
	<ZF1WS4a2bbUiTLA0@shell.armlinux.org.uk>
	<20230511210237.nmjmcex47xadx6eo@skbuf>
	<20230511150902.57d9a437@kernel.org>
	<20230511230717.hg7gtrq5ppvuzmcx@skbuf>
	<20230511161625.2e3f0161@kernel.org>
	<20230512102911.qnosuqnzwbmlupg6@skbuf>
	<20230512103852.64fd608b@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 12 May 2023 10:38:52 -0700 Jakub Kicinski wrote:
> On Fri, 12 May 2023 13:29:11 +0300 Vladimir Oltean wrote:
> > On Thu, May 11, 2023 at 04:16:25PM -0700, Jakub Kicinski wrote:  
> > > Oh, you should tell me, maybe off-list then. 'Cause I don't know any.    
> > 
> > I hope the examples given in private will make you reconsider the
> > validity of my argument about DMA timestamps.  
> 
> I may have lost track of what the argument is. There are devices
> which will provide a DMA stamp for Tx and Rx. We need an API that'll
> inform the user about it. 
> 
> To be clear I'm talking about drivers which are already in the tree,
> not opening the door for some shoddy new HW in.

It dawned on me while reading a phylink discussion that I may have
misunderstood the meaning of the MAC vs PHY time stamp sources.
By the standard - stamping happens under the MAC, so MAC is 
the "right" place to stamp, not the PHY. And there can be multiple 
PHYs technically? Are we just using the MAC vs PHY thing as an
implementation aid, to know which driver to send the request to?

Shouldn't we use the clock ID instead?

