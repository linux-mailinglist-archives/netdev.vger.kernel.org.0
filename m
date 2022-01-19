Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A914494251
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 22:05:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245145AbiASVF2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jan 2022 16:05:28 -0500
Received: from mga02.intel.com ([134.134.136.20]:60076 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229544AbiASVFZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Jan 2022 16:05:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642626325; x=1674162325;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=3TDiFifv04AcCVYzOm6HZ64dJH3KSAV3f2PXyUIwWhM=;
  b=R0NNDNg+oL89hCIEiopjNT00tweh3W1TfwUR0AxFC77+bQIaLEO7OHTs
   TzChL0unoy6nhwWPpSuWytNV8+s0RcOBfcuaUibhIi77RNYm3NgTBaBX/
   adEZ3ixnv/dFl49+V9LMAI+V15+bA2WJJ1XNbOYJ2/r4G97dB1VmHLdH6
   4lWXZF0YPQUWAJd22RSMItDER7HPpry7jkrRcUDMVoi55D5AqbdjQ/Ac4
   QcaDZgVAo8ZNEMQarck21zArybA2jZvYmjBajWglTE14k0bkQGNHTs2Ow
   SfCmSgHibV782uQh7Zv3gDOBAumFcL3R2w6qLcQ/0e4j4I9ryfX8jxdSC
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10231"; a="232555374"
X-IronPort-AV: E=Sophos;i="5.88,300,1635231600"; 
   d="scan'208";a="232555374"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2022 13:05:25 -0800
X-IronPort-AV: E=Sophos;i="5.88,300,1635231600"; 
   d="scan'208";a="765084718"
Received: from smile.fi.intel.com ([10.237.72.61])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2022 13:05:17 -0800
Received: from andy by smile.fi.intel.com with local (Exim 4.95)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1nAI7i-00CH8V-7G;
        Wed, 19 Jan 2022 23:04:06 +0200
Date:   Wed, 19 Jan 2022 23:04:05 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Sakari Ailus <sakari.ailus@linux.intel.com>,
        Lucas De Marchi <lucas.demarchi@intel.com>,
        linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, amd-gfx@lists.freedesktop.org,
        linux-security-module@vger.kernel.org,
        nouveau@lists.freedesktop.org, netdev@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ben Skeggs <bskeggs@redhat.com>,
        Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel@ffwll.ch>,
        David Airlie <airlied@linux.ie>,
        "David S . Miller" <davem@davemloft.net>,
        Emma Anholt <emma@anholt.net>, Eryk Brol <eryk.brol@amd.com>,
        Francis Laniel <laniel_francis@privacyrequired.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Harry Wentland <harry.wentland@amd.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Julia Lawall <julia.lawall@lip6.fr>,
        Kentaro Takeda <takedakn@nttdata.co.jp>,
        Leo Li <sunpeng.li@amd.com>,
        Mikita Lipski <mikita.lipski@amd.com>,
        Petr Mladek <pmladek@suse.com>,
        Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>,
        Raju Rangoju <rajur@chelsio.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Vishal Kulkarni <vishal@chelsio.com>
Subject: Re: [PATCH 1/3] lib/string_helpers: Consolidate yesno()
 implementation
Message-ID: <Yeh8xRCcR7D1xdxz@smile.fi.intel.com>
References: <20220119072450.2890107-1-lucas.demarchi@intel.com>
 <20220119072450.2890107-2-lucas.demarchi@intel.com>
 <YefXg03hXtrdUj6y@paasikivi.fi.intel.com>
 <20220119100635.6c45372b@gandalf.local.home>
 <YehllDq7wC3M2PQZ@smile.fi.intel.com>
 <20220119160017.65bd1fa5@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220119160017.65bd1fa5@gandalf.local.home>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 19, 2022 at 04:00:17PM -0500, Steven Rostedt wrote:
> On Wed, 19 Jan 2022 21:25:08 +0200
> Andy Shevchenko <andriy.shevchenko@linux.intel.com> wrote:
> 
> > > I say keep it one line!
> > > 
> > > Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>  
> > 
> > I believe Sakari strongly follows the 80 rule, which means...
> 
> Checkpatch says "100" I think we need to simply update the docs (the
> documentation always lags the code ;-)

The idea of checkpatch change is for old code to avoid tons of patches
to satisfy 80 rule in (mostly) staging code. Some maintainers started /
have been using relaxed approach.

-- 
With Best Regards,
Andy Shevchenko


