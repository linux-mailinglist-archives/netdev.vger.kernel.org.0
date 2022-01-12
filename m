Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BAF048C836
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 17:24:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349781AbiALQYH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 11:24:07 -0500
Received: from mga11.intel.com ([192.55.52.93]:16950 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343683AbiALQYE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Jan 2022 11:24:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642004644; x=1673540644;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=4QsmKNbFv3nX2zfsbRuGIVtYcTBp8NsUz6wrgzFB8Cg=;
  b=mBvNgq+i0A95PqowfMFIU7A1I0FGfRqIGAs5xcLbMgjNXmN8YTKLYO76
   30HFJrywa0MP/+4DbqfsqKmhUIwEX/YX8oB6aG4v6lUzIfot/xp8CXJzr
   xGZxfBsco6T+0PU7iJVuJnLHm9UhdgzKeLsiYcwvgtkvwgFt4D9f2pAwm
   id4TZNaVrFeYjrtKtlNpn0tRLKXJeyPVfJ5XJUPeohVcQj1A2lKJDBcgQ
   IPf0qCEz/jAkHMgj50L4xWpC6R9oGzm2trADFHX3O8E5NQuxZfdZpYQHE
   r5OAeTLwSSuB+HCQCco2pHFajbuWnMiJOe8FBvUmMff9ktTKDdXELlse8
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10224"; a="241326163"
X-IronPort-AV: E=Sophos;i="5.88,282,1635231600"; 
   d="scan'208";a="241326163"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2022 08:21:23 -0800
X-IronPort-AV: E=Sophos;i="5.88,282,1635231600"; 
   d="scan'208";a="490780847"
Received: from smile.fi.intel.com ([10.237.72.61])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2022 08:21:15 -0800
Received: from andy by smile.fi.intel.com with local (Exim 4.95)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1n7gLy-009l4y-3t;
        Wed, 12 Jan 2022 18:20:02 +0200
Date:   Wed, 12 Jan 2022 18:20:01 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Ilpo =?iso-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>
Cc:     "Martinez, Ricardo" <ricardo.martinez@linux.intel.com>,
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
Message-ID: <Yd7/se+LD1c1wiBA@smile.fi.intel.com>
References: <20211207024711.2765-1-ricardo.martinez@linux.intel.com>
 <20211207024711.2765-2-ricardo.martinez@linux.intel.com>
 <a6325ef-e06e-c236-9d23-42fdb8b62747@linux.intel.com>
 <2b21bfa5-4b18-d615-b6ab-09ad97d73fe4@linux.intel.com>
 <Yd6+GjPLP2qCCEfv@smile.fi.intel.com>
 <b0cb18b-dc7b-9241-b21a-850d055d86@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b0cb18b-dc7b-9241-b21a-850d055d86@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 12, 2022 at 04:24:52PM +0200, Ilpo Järvinen wrote:
> On Wed, 12 Jan 2022, Andy Shevchenko wrote:
> > On Tue, Jan 11, 2022 at 08:55:58PM -0800, Martinez, Ricardo wrote:
> > > On 12/16/2021 3:08 AM, Ilpo Järvinen wrote:
> > > > On Mon, 6 Dec 2021, Ricardo Martinez wrote:
> > 
> > > > > +	if (req->entry.next == &ring->gpd_ring)
> > > > > +		return list_first_entry(&ring->gpd_ring, struct cldma_request, entry);
> > > > > +
> > > > > +	return list_next_entry(req, entry);
> > 
> > ...
> > 
> > > > > +	if (req->entry.prev == &ring->gpd_ring)
> > > > > +		return list_last_entry(&ring->gpd_ring, struct cldma_request, entry);
> > > > > +
> > > > > +	return list_prev_entry(req, entry);
> > 
> > ...
> > 
> > > > Wouldn't these two seems generic enough to warrant adding something like
> > > > list_next/prev_entry_circular(...) to list.h?
> > > 
> > > Agree, in the upcoming version I'm planning to include something like this
> > > to list.h as suggested:
> > 
> > I think you mean for next and prev, i.o.w. two helpers, correct?
> > 
> > > #define list_next_entry_circular(pos, ptr, member) \
> > 
> > >     ((pos)->member.next == (ptr) ? \
> > 
> > I believe this is list_entry_is_head().
> 
> It takes .next so it's not the same as list_entry_is_head() and 
> list_entry_is_last() doesn't exist.

But we have list_last_entry(). So, what about

list_last_entry() == pos ? first : next;

and counterpart

list_first_entry() == pos ? last : prev;

?

> > >     list_first_entry(ptr, typeof(*(pos)), member) : \
> > >     list_next_entry(pos, member))




-- 
With Best Regards,
Andy Shevchenko


