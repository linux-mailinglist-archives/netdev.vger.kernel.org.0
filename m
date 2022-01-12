Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8457248C35E
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 12:41:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352937AbiALLla (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 06:41:30 -0500
Received: from mga09.intel.com ([134.134.136.24]:12712 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239705AbiALLla (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Jan 2022 06:41:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641987690; x=1673523690;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=2uK15gzDWkHyj3kQhde5Zc+sTMbtUU7DPwMlIJP9vCE=;
  b=DgGg+m71+5HTUPe4NsocPQNUHxv5CS6G5EoDQwIAAUQxfFrpafxl2+RX
   WwdmEV14seD17MNw44tR9QdZIzsR4HJgr6b7AtGz7cdNOuRen56lDU3KX
   OMO0/M3mkbexxp9nw80MpSLMIZJ2dOO3Al07QssO5efNf2MkoDUVTDw0f
   s2UVXSUDYe6MuF9am6DGSYsMpmH9jEO5vuawRKfqEf2DmUlV43RCiHD1V
   +VhBuREoO3e/aLtFUtuAMWcHYHVbSHWp11fzLsFr0PNkkrMCjsQHsXLRn
   X8MLzyKPAu5c0f168/6rMjcea+lqYer0GSSQ+br45NgpYzC0pOaMNU17i
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10224"; a="243512601"
X-IronPort-AV: E=Sophos;i="5.88,282,1635231600"; 
   d="scan'208";a="243512601"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2022 03:41:30 -0800
X-IronPort-AV: E=Sophos;i="5.88,282,1635231600"; 
   d="scan'208";a="472803361"
Received: from smile.fi.intel.com ([10.237.72.61])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2022 03:41:24 -0800
Received: from andy by smile.fi.intel.com with local (Exim 4.95)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1n7bz9-009fCO-9k;
        Wed, 12 Jan 2022 13:40:11 +0200
Date:   Wed, 12 Jan 2022 13:40:10 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     "Martinez, Ricardo" <ricardo.martinez@linux.intel.com>
Cc:     Ilpo =?iso-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>,
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
Message-ID: <Yd6+GjPLP2qCCEfv@smile.fi.intel.com>
References: <20211207024711.2765-1-ricardo.martinez@linux.intel.com>
 <20211207024711.2765-2-ricardo.martinez@linux.intel.com>
 <a6325ef-e06e-c236-9d23-42fdb8b62747@linux.intel.com>
 <2b21bfa5-4b18-d615-b6ab-09ad97d73fe4@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2b21bfa5-4b18-d615-b6ab-09ad97d73fe4@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 11, 2022 at 08:55:58PM -0800, Martinez, Ricardo wrote:
> On 12/16/2021 3:08 AM, Ilpo Järvinen wrote:
> > On Mon, 6 Dec 2021, Ricardo Martinez wrote:

> > > +	if (req->entry.next == &ring->gpd_ring)
> > > +		return list_first_entry(&ring->gpd_ring, struct cldma_request, entry);
> > > +
> > > +	return list_next_entry(req, entry);

...

> > > +	if (req->entry.prev == &ring->gpd_ring)
> > > +		return list_last_entry(&ring->gpd_ring, struct cldma_request, entry);
> > > +
> > > +	return list_prev_entry(req, entry);

...

> > Wouldn't these two seems generic enough to warrant adding something like
> > list_next/prev_entry_circular(...) to list.h?
> 
> Agree, in the upcoming version I'm planning to include something like this
> to list.h as suggested:

I think you mean for next and prev, i.o.w. two helpers, correct?

> #define list_next_entry_circular(pos, ptr, member) \

>     ((pos)->member.next == (ptr) ? \

I believe this is list_entry_is_head().

>     list_first_entry(ptr, typeof(*(pos)), member) : \
>     list_next_entry(pos, member))

-- 
With Best Regards,
Andy Shevchenko


