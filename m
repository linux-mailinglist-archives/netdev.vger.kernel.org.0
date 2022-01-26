Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D07A249C5C7
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 10:05:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238750AbiAZJF3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 04:05:29 -0500
Received: from mga17.intel.com ([192.55.52.151]:44553 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231404AbiAZJF3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jan 2022 04:05:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643187929; x=1674723929;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ggEHQETAv3lIPyDtUG98X3fyvSWeMQrZEDGtYqjDGro=;
  b=GsrV4KKkI9aTnAL2asGlOF2XIAK+9sMQv4az0wGVCL6X/0dPYtnWobWZ
   b12eVG/Y019aQBgft0tyiMUzLEPEEduhS/Pyjz7UqqaN5ryb6CuFa5c1C
   8UEscW/PQu3mtPXMOn4NSOQP/le9i6HVPSIQzp6xAD/41cWGEwK/ouxIL
   aX9uBIiyjK5+nwKG1LlJDo8EYrVObpOCPye5/O/21HqZfOdfKTq/a2XUh
   BcyksDa7zfWNX3LshJMj4Ir0h7uBM9Q00iM6AMtbu6G8JEV6i6kqgghlj
   bYA9+SW+WxpjR0LGd2SPBj7VdyBAXBwrD08UZqaP7z5tkq56oHAg9sO4N
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10238"; a="227184325"
X-IronPort-AV: E=Sophos;i="5.88,317,1635231600"; 
   d="scan'208";a="227184325"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2022 01:05:28 -0800
X-IronPort-AV: E=Sophos;i="5.88,317,1635231600"; 
   d="scan'208";a="628246433"
Received: from richardt-mobl1.amr.corp.intel.com (HELO ldmartin-desk2) ([10.212.143.219])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2022 01:05:28 -0800
Date:   Wed, 26 Jan 2022 01:05:27 -0800
From:   Lucas De Marchi <lucas.demarchi@intel.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
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
        Petr Mladek <pmladek@suse.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Leo Li <sunpeng.li@amd.com>, intel-gfx@lists.freedesktop.org,
        Raju Rangoju <rajur@chelsio.com>,
        Julia Lawall <julia.lawall@lip6.fr>,
        Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH 3/3] drm: Convert open yes/no strings to yesno()
Message-ID: <20220126090527.ksuah5m6xctx7jjo@ldmartin-desk2>
X-Patchwork-Hint: comment
References: <20220119072450.2890107-1-lucas.demarchi@intel.com>
 <20220119072450.2890107-4-lucas.demarchi@intel.com>
 <Yehm5/DJ5Ljo1EWs@smile.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <Yehm5/DJ5Ljo1EWs@smile.fi.intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 19, 2022 at 09:30:47PM +0200, Andy Shevchenko wrote:
>On Tue, Jan 18, 2022 at 11:24:50PM -0800, Lucas De Marchi wrote:
>> linux/string_helpers.h provides a helper to return "yes"/"no"
>> strings. Replace the open coded versions with yesno(). The places were
>> identified with the following semantic patch:
>>
>> 	@@
>> 	expression b;
>> 	@@
>>
>> 	- b ? "yes" : "no"
>> 	+ yesno(b)
>>
>> Then the includes were added, so we include-what-we-use, and parenthesis
>> adjusted in drivers/gpu/drm/v3d/v3d_debugfs.c. After the conversion we
>> still see the same binary sizes:
>>
>>    text    data     bss     dec     hex filename
>> 1442171   60344     800 1503315  16f053 ./drivers/gpu/drm/radeon/radeon.ko
>> 1442171   60344     800 1503315  16f053 ./drivers/gpu/drm/radeon/radeon.ko.old
>> 5985991  324439   33808 6344238  60ce2e ./drivers/gpu/drm/amd/amdgpu/amdgpu.ko
>> 5985991  324439   33808 6344238  60ce2e ./drivers/gpu/drm/amd/amdgpu/amdgpu.ko.old
>>  411986   10490    6176  428652   68a6c ./drivers/gpu/drm/drm.ko
>>  411986   10490    6176  428652   68a6c ./drivers/gpu/drm/drm.ko.old
>> 1970292  109515    2352 2082159  1fc56f ./drivers/gpu/drm/nouveau/nouveau.ko
>> 1970292  109515    2352 2082159  1fc56f ./drivers/gpu/drm/nouveau/nouveau.ko.old
>
>...
>
>>  #include <linux/module.h>
>>  #include <linux/sched.h>
>>  #include <linux/slab.h>
>> +#include <linux/string_helpers.h>
>
>+ blank line?
>
>> +#include <linux/string_helpers.h>
>
>...
>
>>  	seq_printf(m, "\tDP branch device present: %s\n",
>> -		   branch_device ? "yes" : "no");
>> +		   yesno(branch_device));
>
>Now it's possible to keep this on one line.
>
>...
>
>>  	drm_printf_indent(p, indent, "imported=%s\n",
>> -			  obj->import_attach ? "yes" : "no");
>> +			  yesno(obj->import_attach));
>
>81 here, but anyway, ditto!
>
>...
>
>>   */
>
>+blank line here?
>
>> +#include <linux/string_helpers.h>
>> +
>>  #include "aux.h"
>>  #include "pad.h"
>
>...
>
>>  	seq_printf(m, "MMU:        %s\n",
>> -		   (ident2 & V3D_HUB_IDENT2_WITH_MMU) ? "yes" : "no");
>> +		   yesno(ident2 & V3D_HUB_IDENT2_WITH_MMU));
>>  	seq_printf(m, "TFU:        %s\n",
>> -		   (ident1 & V3D_HUB_IDENT1_WITH_TFU) ? "yes" : "no");
>> +		   yesno(ident1 & V3D_HUB_IDENT1_WITH_TFU));
>>  	seq_printf(m, "TSY:        %s\n",
>> -		   (ident1 & V3D_HUB_IDENT1_WITH_TSY) ? "yes" : "no");
>> +		   yesno(ident1 & V3D_HUB_IDENT1_WITH_TSY));
>>  	seq_printf(m, "MSO:        %s\n",
>> -		   (ident1 & V3D_HUB_IDENT1_WITH_MSO) ? "yes" : "no");
>> +		   yesno(ident1 & V3D_HUB_IDENT1_WITH_MSO));
>>  	seq_printf(m, "L3C:        %s (%dkb)\n",
>> -		   (ident1 & V3D_HUB_IDENT1_WITH_L3C) ? "yes" : "no",
>> +		   yesno(ident1 & V3D_HUB_IDENT1_WITH_L3C),
>>  		   V3D_GET_FIELD(ident2, V3D_HUB_IDENT2_L3C_NKB));
>
>I believe it's fine to join back to have less LOCs (yes, it will be 83 or so,
>but I believe in these cases it's very much okay).

now that we are converting to str_yes_no(), we will have a few more
chars. Some maintainers may be more strict on the 80 or 100 chars. I
will assume whatever is in the code base is the preferred form.

thanks
Lucas De Marchi

>
>-- 
>With Best Regards,
>Andy Shevchenko
>
>
