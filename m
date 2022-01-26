Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0908F49C964
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 13:16:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241145AbiAZMQ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 07:16:26 -0500
Received: from mga01.intel.com ([192.55.52.88]:24474 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233973AbiAZMQ0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jan 2022 07:16:26 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10238"; a="270988224"
X-IronPort-AV: E=Sophos;i="5.88,318,1635231600"; 
   d="scan'208";a="270988224"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2022 04:16:26 -0800
X-IronPort-AV: E=Sophos;i="5.88,318,1635231600"; 
   d="scan'208";a="674341619"
Received: from smile.fi.intel.com ([10.237.72.61])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2022 04:16:19 -0800
Received: from andy by smile.fi.intel.com with local (Exim 4.95)
        (envelope-from <andy.shevchenko@gmail.com>)
        id 1nChCh-00Eaiw-DB;
        Wed, 26 Jan 2022 14:15:11 +0200
Date:   Wed, 26 Jan 2022 14:15:11 +0200
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
To:     Lucas De Marchi <lucas.demarchi@intel.com>
Cc:     Emma Anholt <emma@anholt.net>, David Airlie <airlied@linux.ie>,
        nouveau@lists.freedesktop.org,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        dri-devel@lists.freedesktop.org,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Vishal Kulkarni <vishal@chelsio.com>,
        Francis Laniel <laniel_francis@privacyrequired.com>,
        Kentaro Takeda <takedakn@nttdata.co.jp>,
        amd-gfx@lists.freedesktop.org, Ben Skeggs <bskeggs@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Harry Wentland <harry.wentland@amd.com>,
        Petr Mladek <pmladek@suse.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Leo Li <sunpeng.li@amd.com>, intel-gfx@lists.freedesktop.org,
        Raju Rangoju <rajur@chelsio.com>,
        Julia Lawall <julia.lawall@lip6.fr>,
        Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [Intel-gfx] [PATCH v2 09/11] drm: Convert open-coded yes/no
 strings to yesno()
Message-ID: <YfE7T7gl+0GrlFt/@smile.fi.intel.com>
References: <20220126093951.1470898-1-lucas.demarchi@intel.com>
 <20220126093951.1470898-10-lucas.demarchi@intel.com>
 <CAHp75Vd+TmShx==d_JHZUu0Q-9X7CmZEOFdKnSrcRKs81Gxn3g@mail.gmail.com>
 <20220126104345.r6libof7z7tqjqxi@ldmartin-desk2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220126104345.r6libof7z7tqjqxi@ldmartin-desk2>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 26, 2022 at 02:43:45AM -0800, Lucas De Marchi wrote:
> On Wed, Jan 26, 2022 at 12:12:50PM +0200, Andy Shevchenko wrote:
> > On Wed, Jan 26, 2022 at 11:39 AM Lucas De Marchi
> > <lucas.demarchi@intel.com> wrote:

...

> > >  411986   10490    6176  428652   68a6c drm.ko.old
> > >  411986   10490    6176  428652   68a6c drm.ko
> > >   98129    1636     264  100029   186bd dp/drm_dp_helper.ko.old
> > >   98129    1636     264  100029   186bd dp/drm_dp_helper.ko
> > > 1973432  109640    2352 2085424  1fd230 nouveau/nouveau.ko.old
> > > 1973432  109640    2352 2085424  1fd230 nouveau/nouveau.ko
> > 
> > This probably won't change for modules, but if you compile in the
> > linker may try to optimize it. Would be nice to see the old-new for
> > `make allyesconfig` or equivalent.
> 
> just like it would already do, no? I can try and see what happens, but
> my feeling is that we won't have any change.

Maybe not or maybe a small win. Depends how compiler puts / linker sees
that in two cases. (Yeah, likely it should be no differences if all
instances are already caught by linker)

-- 
With Best Regards,
Andy Shevchenko


