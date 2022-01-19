Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E25F494102
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 20:37:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357028AbiASTgg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jan 2022 14:36:36 -0500
Received: from mga03.intel.com ([134.134.136.65]:2092 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1357034AbiASTgb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Jan 2022 14:36:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642620991; x=1674156991;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=wjoA2KAzAua/sWhboAdUBsDnQlEM3jScHHUyibF2GDY=;
  b=m/EXx4aOo0j66OMNiEOA9TZ4byifa5vS2jXnLdlP3CVDAz/20sCKq7X9
   7Lu43HZh/lb6yRYazJIsfxHzwXN/7jUhpRBTpx+JEgwJrmQBeyq/lU6cu
   Dzj7PfeBJ1sn5aNyy5usVDn5KV6XREiOPJuihFrNjuip6E42XQ9gZuaBk
   MBQkCv/znYVXXbXWEjBqVlRzwH/tJvDmayAIxhgS2YqfKJ8WEx2zmbcAz
   hBPzbGRoKfLXlSM4XRITe8nPYD/vudbq165NqY8XmmBFcdPVftJfylul4
   GevokQabSOlcwyV7jRpwqjxUFigm6XacBltFLiEm9J2mLWbAU6LLkRg3P
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10231"; a="245130462"
X-IronPort-AV: E=Sophos;i="5.88,300,1635231600"; 
   d="scan'208";a="245130462"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2022 11:32:06 -0800
X-IronPort-AV: E=Sophos;i="5.88,300,1635231600"; 
   d="scan'208";a="672288940"
Received: from smile.fi.intel.com ([10.237.72.61])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2022 11:31:58 -0800
Received: from andy by smile.fi.intel.com with local (Exim 4.95)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1nAGfP-00CEep-7a;
        Wed, 19 Jan 2022 21:30:47 +0200
Date:   Wed, 19 Jan 2022 21:30:47 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Lucas De Marchi <lucas.demarchi@intel.com>
Cc:     linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
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
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Vishal Kulkarni <vishal@chelsio.com>
Subject: Re: [PATCH 3/3] drm: Convert open yes/no strings to yesno()
Message-ID: <Yehm5/DJ5Ljo1EWs@smile.fi.intel.com>
References: <20220119072450.2890107-1-lucas.demarchi@intel.com>
 <20220119072450.2890107-4-lucas.demarchi@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220119072450.2890107-4-lucas.demarchi@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 18, 2022 at 11:24:50PM -0800, Lucas De Marchi wrote:
> linux/string_helpers.h provides a helper to return "yes"/"no"
> strings. Replace the open coded versions with yesno(). The places were
> identified with the following semantic patch:
> 
> 	@@
> 	expression b;
> 	@@
> 
> 	- b ? "yes" : "no"
> 	+ yesno(b)
> 
> Then the includes were added, so we include-what-we-use, and parenthesis
> adjusted in drivers/gpu/drm/v3d/v3d_debugfs.c. After the conversion we
> still see the same binary sizes:
> 
>    text    data     bss     dec     hex filename
> 1442171   60344     800 1503315  16f053 ./drivers/gpu/drm/radeon/radeon.ko
> 1442171   60344     800 1503315  16f053 ./drivers/gpu/drm/radeon/radeon.ko.old
> 5985991  324439   33808 6344238  60ce2e ./drivers/gpu/drm/amd/amdgpu/amdgpu.ko
> 5985991  324439   33808 6344238  60ce2e ./drivers/gpu/drm/amd/amdgpu/amdgpu.ko.old
>  411986   10490    6176  428652   68a6c ./drivers/gpu/drm/drm.ko
>  411986   10490    6176  428652   68a6c ./drivers/gpu/drm/drm.ko.old
> 1970292  109515    2352 2082159  1fc56f ./drivers/gpu/drm/nouveau/nouveau.ko
> 1970292  109515    2352 2082159  1fc56f ./drivers/gpu/drm/nouveau/nouveau.ko.old

...

>  #include <linux/module.h>
>  #include <linux/sched.h>
>  #include <linux/slab.h>
> +#include <linux/string_helpers.h>

+ blank line?

> +#include <linux/string_helpers.h>

...

>  	seq_printf(m, "\tDP branch device present: %s\n",
> -		   branch_device ? "yes" : "no");
> +		   yesno(branch_device));

Now it's possible to keep this on one line.

...

>  	drm_printf_indent(p, indent, "imported=%s\n",
> -			  obj->import_attach ? "yes" : "no");
> +			  yesno(obj->import_attach));

81 here, but anyway, ditto!

...

>   */

+blank line here?

> +#include <linux/string_helpers.h>
> +
>  #include "aux.h"
>  #include "pad.h"

...

>  	seq_printf(m, "MMU:        %s\n",
> -		   (ident2 & V3D_HUB_IDENT2_WITH_MMU) ? "yes" : "no");
> +		   yesno(ident2 & V3D_HUB_IDENT2_WITH_MMU));
>  	seq_printf(m, "TFU:        %s\n",
> -		   (ident1 & V3D_HUB_IDENT1_WITH_TFU) ? "yes" : "no");
> +		   yesno(ident1 & V3D_HUB_IDENT1_WITH_TFU));
>  	seq_printf(m, "TSY:        %s\n",
> -		   (ident1 & V3D_HUB_IDENT1_WITH_TSY) ? "yes" : "no");
> +		   yesno(ident1 & V3D_HUB_IDENT1_WITH_TSY));
>  	seq_printf(m, "MSO:        %s\n",
> -		   (ident1 & V3D_HUB_IDENT1_WITH_MSO) ? "yes" : "no");
> +		   yesno(ident1 & V3D_HUB_IDENT1_WITH_MSO));
>  	seq_printf(m, "L3C:        %s (%dkb)\n",
> -		   (ident1 & V3D_HUB_IDENT1_WITH_L3C) ? "yes" : "no",
> +		   yesno(ident1 & V3D_HUB_IDENT1_WITH_L3C),
>  		   V3D_GET_FIELD(ident2, V3D_HUB_IDENT2_L3C_NKB));

I believe it's fine to join back to have less LOCs (yes, it will be 83 or so,
but I believe in these cases it's very much okay).

-- 
With Best Regards,
Andy Shevchenko


