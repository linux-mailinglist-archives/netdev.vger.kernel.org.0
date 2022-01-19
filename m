Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A50194940FF
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 20:37:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357053AbiASTgf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jan 2022 14:36:35 -0500
Received: from mga07.intel.com ([134.134.136.100]:5752 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1357020AbiASTg1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Jan 2022 14:36:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642620987; x=1674156987;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Y7zetMO+F9o9TgvTfnNqU31+rhVBHq60hicGgEyx15I=;
  b=HhzYV4lDUyY0zhE8U9LQ4rni4Lm3Ln4mXgY1xQjSoU0F2uTie+LxGlkM
   oBRWJSzwQGh1DLAMGrizOHtiJEZmuHVs/sQ/H9wek9g+0jDqqizd21ahz
   5Q6yuBeSbylYJ36SPljxQlWeqdMbmYGeqgD6driL4fn9Ed1koxRm6XfLl
   z5U43+DqrU/2SojfAKvFemPc2jFBAJR0wJucfy+l95KoRsWQ0ZBDYX8Sh
   /xiQwZyyoQftkKaXbMlqk+/fMXEOyY4f9m0w68N2+No83ldeVojKwQxcP
   swXuoQLBb8M3RwThIz9M5DRnXpL7HCK6PUS3XTcXr6oOdv0dof51eYgIX
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10231"; a="308510733"
X-IronPort-AV: E=Sophos;i="5.88,300,1635231600"; 
   d="scan'208";a="308510733"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2022 11:26:27 -0800
X-IronPort-AV: E=Sophos;i="5.88,300,1635231600"; 
   d="scan'208";a="765057648"
Received: from smile.fi.intel.com ([10.237.72.61])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2022 11:26:19 -0800
Received: from andy by smile.fi.intel.com with local (Exim 4.95)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1nAGZw-00CEZW-RK;
        Wed, 19 Jan 2022 21:25:08 +0200
Date:   Wed, 19 Jan 2022 21:25:08 +0200
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
Message-ID: <YehllDq7wC3M2PQZ@smile.fi.intel.com>
References: <20220119072450.2890107-1-lucas.demarchi@intel.com>
 <20220119072450.2890107-2-lucas.demarchi@intel.com>
 <YefXg03hXtrdUj6y@paasikivi.fi.intel.com>
 <20220119100635.6c45372b@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220119100635.6c45372b@gandalf.local.home>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 19, 2022 at 10:06:35AM -0500, Steven Rostedt wrote:
> On Wed, 19 Jan 2022 11:18:59 +0200
> Sakari Ailus <sakari.ailus@linux.intel.com> wrote:
> > On Tue, Jan 18, 2022 at 11:24:48PM -0800, Lucas De Marchi wrote:
> > > @@ -1354,8 +1345,7 @@ static bool tomoyo_print_condition(struct tomoyo_io_buffer *head,
> > >  	case 3:
> > >  		if (cond->grant_log != TOMOYO_GRANTLOG_AUTO)
> > >  			tomoyo_io_printf(head, " grant_log=%s",
> > > -					 tomoyo_yesno(cond->grant_log ==
> > > -						      TOMOYO_GRANTLOG_YES));
> > > +					 yesno(cond->grant_log == TOMOYO_GRANTLOG_YES));  
> > 
> > This would be better split on two lines.
> 
> Really? Yuck!
> 
> I thought the "max line size" guideline was going to grow to a 100, but I
> still see it as 80. But anyway...
> 
> 	cond->grant_log ==
> 	TOMOYO_GRANTLOG_YES
> 
> is not readable at all. Not compared to
> 
> 	cond->grant_log == TOMOYO_GRANTLOG_YES
> 
> I say keep it one line!
> 
> Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>

I believe Sakari strongly follows the 80 rule, which means...

> > Reviewed-by: Sakari Ailus <sakari.ailus@linux.intel.com>

...chose either of these tags and be happy with :-)

-- 
With Best Regards,
Andy Shevchenko


