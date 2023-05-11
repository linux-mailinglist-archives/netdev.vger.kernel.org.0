Return-Path: <netdev+bounces-1980-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 193F26FFD45
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 01:29:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DB63A1C210A8
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 23:29:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3AC9182D8;
	Thu, 11 May 2023 23:29:29 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 656353FDF
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 23:29:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8179FC433EF;
	Thu, 11 May 2023 23:29:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683847768;
	bh=SLlcwEuE4JpFNFcPjNi/S0l6z/1UC6psRw1iRRUVsYs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=efUdlcXR/weB6qRSybLmpnKrQG4ctSZoORqH6nEZTv0i+nAPO4aErh3H652p78bhZ
	 tVE+QXHCkMDO7gRC+eRJ7rKBpsXJZQ/l/knP+UPmqN5P4YyFLbvYLE/N+2mpU8jehw
	 JDTysC+qkto2m3UoixYkCKVqqj2MKCiOiS0dSMR1lNHOnC6XTnUF1I9jWNYP4e6LhG
	 h9d8bKTpoQq3YuR4xqlTf/GqOXvMYILRNsWv+evIyyp7FR/57/Fu6XvxYSnFYFbXoV
	 M6uJbiFNqPHw4+XLoGIe9pJpTllMPFIVdCOcujeyDwvddeGva5nJ+dpAi7mfwoO6kW
	 fb+AFD5Kkdh9g==
Date: Thu, 11 May 2023 16:29:26 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>
Cc: Vadim Fedorenko <vadfed@meta.com>, Jiri Pirko <jiri@resnulli.us>,
 Jonathan Lemon <jonathan.lemon@gmail.com>, Paolo Abeni <pabeni@redhat.com>,
 "Olech, Milena" <milena.olech@intel.com>, "Michalik, Michal"
 <michal.michalik@intel.com>, "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>, poros <poros@redhat.com>, mschmidt
 <mschmidt@redhat.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
 "linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>, Vadim Fedorenko
 <vadim.fedorenko@linux.dev>
Subject: Re: [RFC PATCH v7 1/8] dpll: spec: Add Netlink spec in YAML
Message-ID: <20230511162926.009994bb@kernel.org>
In-Reply-To: <DM6PR11MB4657EF0A57977C56264BC7A99B749@DM6PR11MB4657.namprd11.prod.outlook.com>
References: <20230428002009.2948020-1-vadfed@meta.com>
	<20230428002009.2948020-2-vadfed@meta.com>
	<ZFOe1sMFtAOwSXuO@nanopsycho>
	<20230504142451.4828bbb5@kernel.org>
	<MN2PR11MB46645511A6C93F5C98A8A66F9B749@MN2PR11MB4664.namprd11.prod.outlook.com>
	<20230511082053.7d2e57e3@kernel.org>
	<DM6PR11MB4657EF0A57977C56264BC7A99B749@DM6PR11MB4657.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 11 May 2023 20:53:40 +0000 Kubalewski, Arkadiusz wrote:
> >Because I think that'd be done by an NCO, no?  
> 
> From docs I can also see that chip has additional designated dpll for NCO mode,
> and this statement:
> "Numerically controlled oscillator (NCO) behavior allows system software to steer
> DPLL frequency or synthesizer frequency with resolution better than 0.005 ppt."
> 
> I am certainly not an expert on this, but seems like the NCO mode for this chip
> is better than FREERUN, since signal produced on output is somehow higher quality.

Herm, this seems complicated. Do you have a use case for this? 
Maybe we can skip it :D

My reading of the quote is that there is an NCO which SW can control
precisely. But that does not answer the questions:
 - is the NCO driven by system clock or can it be used in locked mode?
 - what is the "system software"? FW which based on temperature
   information, and whatever else compensates drift of system clock?
   or there are exposed registers to control the NCO?


