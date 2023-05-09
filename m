Return-Path: <netdev+bounces-1197-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5FC256FC98E
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 16:52:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A760F281316
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 14:52:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7FAF17FF1;
	Tue,  9 May 2023 14:52:51 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C616A17FE2
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 14:52:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0139C433EF;
	Tue,  9 May 2023 14:52:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683643969;
	bh=zEEBJd+nxrJPiSWPKfluMykCPlc660JynNlsMAogrbE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=XG0W0/MiuxekFieKSbnHTeOZbQYboqtd9G14FEUT224mB1OVUQmx7URbYjxHXZGmX
	 7FUIG8WBtjLRd0PFkGactzJhjCqVwsc3SGoD1Men0sIdR92ZJIZmMHjVJFhk0HEhpi
	 xHkmTjvC1JJd2aQwFnBAAjtBCNEB6AWMqyj2V8GL/0HlYxiRCHbZNrsEpA3gnhdT3o
	 ZwcrRjl1/P8eeaJZNKMUTeDNQok9QJ++sz1IpdFtZeuBBZ+heut14RuGA0h+5I+D6k
	 9dypEQ/2Tvje4au0hK8Hr/dKaikUKUGjwXDJ4Zwd33zkwCPhejJfj749GeqRLW/5cM
	 CbaGf+30afylw==
Date: Tue, 9 May 2023 07:52:47 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Jiri Pirko <jiri@resnulli.us>
Cc: Paolo Abeni <pabeni@redhat.com>, "Kubalewski, Arkadiusz"
 <arkadiusz.kubalewski@intel.com>, Vadim Fedorenko
 <vadim.fedorenko@linux.dev>, Vadim Fedorenko <vadfed@meta.com>, Jonathan
 Lemon <jonathan.lemon@gmail.com>, poros <poros@redhat.com>, mschmidt
 <mschmidt@redhat.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
 linux-arm-kernel@lists.infradead.org, "linux-clk@vger.kernel.org"
 <linux-clk@vger.kernel.org>, "Olech, Milena" <milena.olech@intel.com>,
 "Michalik, Michal" <michal.michalik@intel.com>
Subject: Re: [PATCH RFC v6 2/6] dpll: Add DPLL framework base functions
Message-ID: <20230509075247.2df8f5aa@kernel.org>
In-Reply-To: <ZFn74xJOtiXatfHQ@nanopsycho>
References: <ZFOQWmkBUtgVR06R@nanopsycho>
	<20230504090401.597a7a61@kernel.org>
	<ZFPwqu5W8NE6Luvk@nanopsycho>
	<20230504114421.51415018@kernel.org>
	<ZFTdR93aDa6FvY4w@nanopsycho>
	<20230505083531.57966958@kernel.org>
	<ZFdaDmPAKJHDoFvV@nanopsycho>
	<d86ff1331a621bf3048123c24c22f49e9ecf0044.camel@redhat.com>
	<ZFjoWn9+H932DdZ1@nanopsycho>
	<20230508124250.20fb1825@kernel.org>
	<ZFn74xJOtiXatfHQ@nanopsycho>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 9 May 2023 09:53:07 +0200 Jiri Pirko wrote:
> >Yup. Even renaming EXT to something that's less.. relative :(  
> 
> Suggestion?

Well, is an SMT socket on the board an EXT pin?
Which is why I prefer PANEL.

> >> Well sure, in case there is no "label" attr for the rest of the types.
> >> Which I believe it is, for the ice implementation in this patchset.
> >> Otherwise, there is no way to distinguish between the pins.
> >> To have multiple attrs for label for multiple pin types does not make
> >> any sense to me, that was my point.  
> >
> >Come on, am I really this bad at explaining this?  
> 
> Or perhaps I'm just slow.
> 
> >If we make a generic "label" attribute driver authors will pack
> >everything they want to expose to the user into it, and then some.  
> 
> What's difference in generic label string attr and type specific label
> string attr. What is stopping driver developers to pack crap in either
> of these 2. Perhaps I'm missing something. Could you draw examples?
> 
> >So we need attributes which will feel *obviously* *wrong* to abuse.  
> 
> Sure, I get what you say and agree. I'm just trying to find out the
> actual attributes :)

PANEL label must match the name on the panel. User can take the card
into their hand, look at the front, and there should be a label/sticker/
/engraving which matches exactly what the kernel reports.

If the label is printed on the board it's a BOARD_LABEL, if it's the
name of a trace in board docs it's a BOARD_TRACE, if it's a pin of 
the ASIC it's a PACKAGE_PIN.

If it's none of those, or user does not have access to the detailed
board / pinout - don't use the label.

