Return-Path: <netdev+bounces-592-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F9226F85ED
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 17:35:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CF95028107C
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 15:35:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6156C2D6;
	Fri,  5 May 2023 15:35:35 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26B226FAE
	for <netdev@vger.kernel.org>; Fri,  5 May 2023 15:35:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB4C9C433D2;
	Fri,  5 May 2023 15:35:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683300933;
	bh=OPlunUdfvXK6uRgblU/QUedptc22mJhlsbSHxPNaQxs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=uBEgDxn0+0bsBQOFEUNODO6ici04abrkTGxM1Ti7VAM95VsgFk2A0hHDwHKCokrS8
	 Mrr294E3dvqDcIRNgYol1IsU5EujK8O1Bob44G/BGBu1hsfmNh4OBqj2ndi5SdVWqy
	 5iWznbzqTVUTHsSD+XIIkJg+XW8ORTejSLrh1Strkj5/sTefdvMAohby9eElUbrgUG
	 6LUZ7KNWtiZC0/ZLdYpG/hFQ69ZlV//oirR09L+2v9j879UzQBu50mA9hpFpZg0/YA
	 mgu0x7txicTMdWoyqHeqjH9oSLXHR/AkaAr/aKKT00tmV6uZuyiVbQF7nc2upziaPW
	 S07MJj9QPSIjw==
Date: Fri, 5 May 2023 08:35:31 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Jiri Pirko <jiri@resnulli.us>
Cc: "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>, Vadim
 Fedorenko <vadim.fedorenko@linux.dev>, Vadim Fedorenko <vadfed@meta.com>,
 Jonathan Lemon <jonathan.lemon@gmail.com>, Paolo Abeni <pabeni@redhat.com>,
 poros <poros@redhat.com>, mschmidt <mschmidt@redhat.com>,
 "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
 linux-arm-kernel@lists.infradead.org, "linux-clk@vger.kernel.org"
 <linux-clk@vger.kernel.org>, "Olech, Milena" <milena.olech@intel.com>,
 "Michalik, Michal" <michal.michalik@intel.com>
Subject: Re: [PATCH RFC v6 2/6] dpll: Add DPLL framework base functions
Message-ID: <20230505083531.57966958@kernel.org>
In-Reply-To: <ZFTdR93aDa6FvY4w@nanopsycho>
References: <ZDwg88x3HS2kd6lY@nanopsycho>
	<20230417124942.4305abfa@kernel.org>
	<ZFDPaXlJainSOqmV@nanopsycho>
	<20230502083244.19543d26@kernel.org>
	<ZFITyWvVcqgRtN+Q@nanopsycho>
	<20230503191643.12a6e559@kernel.org>
	<ZFOQWmkBUtgVR06R@nanopsycho>
	<20230504090401.597a7a61@kernel.org>
	<ZFPwqu5W8NE6Luvk@nanopsycho>
	<20230504114421.51415018@kernel.org>
	<ZFTdR93aDa6FvY4w@nanopsycho>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 5 May 2023 12:41:11 +0200 Jiri Pirko wrote:
> >connector label (i.e. front panel label)? Or also applicable to
> >internal pins? It'd be easier to talk details if we had the user
> >facing documentation that ships with these products.  
> 
> I think is is use case specific. Some of the pins face the user over
> physical port, they it is a front panel label. Others are internal
> names. I have no clue how to define and mainly enforce rules here.

It should be pretty easy to judge if we see the user-facing
documentation vendors have.

> But as an example, if you have 2 pins of the same type, only difference
> is they are connected to front panel connector "A" and "B", this is the
> label you have to pass to the ID query. Do you see any other way?

Sound perfectly fine, if it's a front panel label, let's call 
the attribute DPLL_A_PIN_FRONT_PANEL_LABEL. If the pin is not
brought out to the front panel it will not have this attr.
For other type of labels we should have different attributes.

