Return-Path: <netdev+bounces-2249-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C0961700E05
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 19:38:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D79C01C2127E
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 17:38:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D23E200D9;
	Fri, 12 May 2023 17:38:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48D2E200A5
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 17:38:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C0A3C433EF;
	Fri, 12 May 2023 17:38:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683913133;
	bh=iJuJVYAOXaNp9McLSmxN0AIKQJxPPbZOrdHyqusxNfY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=iYw44mBq/a1EyhI0nNEq2ZZ2ECPCZLXkUYf/gryFLFtn16rsHHkqmadJZtSZg5V60
	 h3F75gPKEDpPG0ovYuQzG2ZK7qNy01SM9GgOBhww8B8i22Ia5ZJXMUTzcwu/bZHkAc
	 WJ9kuHrR26R33mmSAxOVDP8ybkbO12Gndev2sjLfVUmdQfpC6qzyQ0FBL0iI8yQum2
	 CzQaZKN+9Dum2XJaWBx0pnZbkbfHFWjb3dLYxa8fn1jAu9jpczeF8srnPTmSGMAYbs
	 4mOM70N9uDLugzueaEOZoWQ3p1JrTO+nsjx04FsbmoUKo9k3lThibPsOF0AcVeIuU1
	 NgHD/OpH4e07Q==
Date: Fri, 12 May 2023 10:38:52 -0700
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
Message-ID: <20230512103852.64fd608b@kernel.org>
In-Reply-To: <20230512102911.qnosuqnzwbmlupg6@skbuf>
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
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 12 May 2023 13:29:11 +0300 Vladimir Oltean wrote:
> On Thu, May 11, 2023 at 04:16:25PM -0700, Jakub Kicinski wrote:
> > > I mean, I can't ignore the fact that there are NICs that can provide
> > > 2-step TX timestamps at line rate for all packets (not just PTP) for
> > > line rates exceeding 10G, in band with the descriptor in its TX
> > > completion queue. I don't want to give any names, just to point out
> > > that there isn't any inherent limitation in the technology.  
> > 
> > Oh, you should tell me, maybe off-list then. 'Cause I don't know any.  
> 
> I hope the examples given in private will make you reconsider the
> validity of my argument about DMA timestamps.

I may have lost track of what the argument is. There are devices
which will provide a DMA stamp for Tx and Rx. We need an API that'll
inform the user about it. 

To be clear I'm talking about drivers which are already in the tree,
not opening the door for some shoddy new HW in.

