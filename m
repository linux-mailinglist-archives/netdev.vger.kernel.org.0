Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21BAF48C5FC
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 15:27:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354113AbiALO1P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 09:27:15 -0500
Received: from mga06.intel.com ([134.134.136.31]:18005 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1354104AbiALO1O (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Jan 2022 09:27:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641997634; x=1673533634;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version:content-id;
  bh=70f07ZC28IPZ2habVcLvcewJJFq9+Hjoq0AtWrfBIuE=;
  b=Z0+CnTcUEUmNb1i7cH94zQoUm6u48lEXFlKoJwYjmoT8Qb2oSsdvCgnM
   tmjNJpz2Ns8rmFuTCINhc9yYqN4udRT7HxG2wp1/C1zvGNpfa6hR3u90W
   gc/9BhPVLMNjEXjznVolkOzHNDGGBsF44V//6NekImIuhXEwahvxdfUpl
   VkNJQGpDTFmpNeXaboPXZtycvOqDfv6PkhPygjNnruFv8H+IEJDR42x+h
   3Riy5/JaBFynEfG23peJMEN4zgwrBDNdrFowt0CmYPOG9SG2LuOfp9OYe
   HIguvy8LnfP2GNNma5VC7Y28oM23Hw0d5iZZTWx2L6ImRlVriL4I5PQh/
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10224"; a="304482649"
X-IronPort-AV: E=Sophos;i="5.88,282,1635231600"; 
   d="scan'208";a="304482649"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2022 06:25:03 -0800
X-IronPort-AV: E=Sophos;i="5.88,282,1635231600"; 
   d="scan'208";a="529192853"
Received: from frpiroth-mobl2.ger.corp.intel.com ([10.251.217.139])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2022 06:24:56 -0800
Date:   Wed, 12 Jan 2022 16:24:52 +0200 (EET)
From:   =?ISO-8859-15?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
cc:     "Martinez, Ricardo" <ricardo.martinez@linux.intel.com>,
        Netdev <netdev@vger.kernel.org>, linux-wireless@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        m.chetan.kumar@intel.com, chandrashekar.devegowda@intel.com,
        linuxwwan@intel.com, chiranjeevi.rapolu@linux.intel.com,
        haijun.liu@mediatek.com, amir.hanania@intel.com,
        dinesh.sharma@intel.com, eliot.lee@intel.com,
        mika.westerberg@linux.intel.com, moises.veleta@intel.com,
        pierre-louis.bossart@intel.com, muralidharan.sethuraman@intel.com,
        Soumya.Prakash.Mishra@intel.com, sreehari.kancharla@intel.com
Subject: Re: [PATCH net-next v3 01/12] net: wwan: t7xx: Add control DMA
 interface
In-Reply-To: <Yd6+GjPLP2qCCEfv@smile.fi.intel.com>
Message-ID: <b0cb18b-dc7b-9241-b21a-850d055d86@linux.intel.com>
References: <20211207024711.2765-1-ricardo.martinez@linux.intel.com> <20211207024711.2765-2-ricardo.martinez@linux.intel.com> <a6325ef-e06e-c236-9d23-42fdb8b62747@linux.intel.com> <2b21bfa5-4b18-d615-b6ab-09ad97d73fe4@linux.intel.com>
 <Yd6+GjPLP2qCCEfv@smile.fi.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; BOUNDARY="8323329-1622803756-1641997396=:1851"
Content-ID: <9021e3ee-e380-b093-8c62-1f68ddb1aa90@linux.intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-1622803756-1641997396=:1851
Content-Type: text/plain; CHARSET=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Content-ID: <cb2f909c-34ed-2212-4252-3e9f2769a3b8@linux.intel.com>

On Wed, 12 Jan 2022, Andy Shevchenko wrote:

> On Tue, Jan 11, 2022 at 08:55:58PM -0800, Martinez, Ricardo wrote:
> > On 12/16/2021 3:08 AM, Ilpo Järvinen wrote:
> > > On Mon, 6 Dec 2021, Ricardo Martinez wrote:
> 
> > > > +	if (req->entry.next == &ring->gpd_ring)
> > > > +		return list_first_entry(&ring->gpd_ring, struct cldma_request, entry);
> > > > +
> > > > +	return list_next_entry(req, entry);
> 
> ...
> 
> > > > +	if (req->entry.prev == &ring->gpd_ring)
> > > > +		return list_last_entry(&ring->gpd_ring, struct cldma_request, entry);
> > > > +
> > > > +	return list_prev_entry(req, entry);
> 
> ...
> 
> > > Wouldn't these two seems generic enough to warrant adding something like
> > > list_next/prev_entry_circular(...) to list.h?
> > 
> > Agree, in the upcoming version I'm planning to include something like this
> > to list.h as suggested:
> 
> I think you mean for next and prev, i.o.w. two helpers, correct?
> 
> > #define list_next_entry_circular(pos, ptr, member) \
> 
> >     ((pos)->member.next == (ptr) ? \
> 
> I believe this is list_entry_is_head().

It takes .next so it's not the same as list_entry_is_head() and 
list_entry_is_last() doesn't exist.

-- 
 i.

> >     list_first_entry(ptr, typeof(*(pos)), member) : \
> >     list_next_entry(pos, member))
> 
> 
--8323329-1622803756-1641997396=:1851--
