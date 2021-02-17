Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46E0731D9BA
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 13:48:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232789AbhBQMqu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 07:46:50 -0500
Received: from mx2.suse.de ([195.135.220.15]:41734 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232688AbhBQMqq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Feb 2021 07:46:46 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1613565959; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=N00yAhsyZbw+Nel/sbxQYAWqciOhUzp9bz7wDMnc5es=;
        b=X95Zya3LHME58OqF/fGOges5Ys2yN9XI9UOk1w4f4CQcA/Ji7pUuY5gTbuBmcaGxOAAlR0
        VZlYkf6Brip0RW+RZIDnZtVwCKLZ31/SZOAFdyEPBkyMeDAlAl+SNdaLEKU6ksQT1aIM19
        vTTytiQ0WWvTgFE3S2DIgxsEVdTyXiM=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 4C233AF26;
        Wed, 17 Feb 2021 12:45:59 +0000 (UTC)
Date:   Wed, 17 Feb 2021 13:45:58 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
Cc:     Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Mikita Lipski <mikita.lipski@amd.com>,
        Eryk Brol <eryk.brol@amd.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>,
        Francis Laniel <laniel_francis@privacyrequired.com>,
        amd-gfx@lists.freedesktop.org,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        netdev <netdev@vger.kernel.org>,
        Harry Wentland <harry.wentland@amd.com>,
        Leo Li <sunpeng.li@amd.com>, David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Raju Rangoju <rajur@chelsio.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH v1 1/3] string: Consolidate yesno() helpers under
 string.h hood
Message-ID: <YC0QBvv9HXr64ySf@alley>
References: <20210215142137.64476-1-andriy.shevchenko@linux.intel.com>
 <43456ba7-c372-84cc-4949-dcb817188e21@amd.com>
 <CAHp75VfVXnqdVRAPQ36vZeD-ZMCjWmjA_-6T=jnOEVMne4bv0g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHp75VfVXnqdVRAPQ36vZeD-ZMCjWmjA_-6T=jnOEVMne4bv0g@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon 2021-02-15 16:39:26, Andy Shevchenko wrote:
> +Cc: Sakari and printk people
> 
> On Mon, Feb 15, 2021 at 4:28 PM Christian König
> <christian.koenig@amd.com> wrote:
> > Am 15.02.21 um 15:21 schrieb Andy Shevchenko:
> > > We have already few similar implementation and a lot of code that can benefit
> > > of the yesno() helper.  Consolidate yesno() helpers under string.h hood.
> > >
> > > Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> >
> > Looks like a good idea to me, feel free to add an Acked-by: Christian
> > König <christian.koenig@amd.com> to the series.
> 
> Thanks.
> 
> > But looking at the use cases for this, wouldn't it make more sense to
> > teach kprintf some new format modifier for this?
> 
> As a next step? IIRC Sakari has at some point the series converted
> yesno and Co. to something which I don't remember the details of.
> 
> Guys, what do you think?

Honestly, I think that yesno() is much easier to understand than %py.
And %py[DOY] looks really scary. It has been suggested at
https://lore.kernel.org/lkml/YCqaNnr7ynRydczE@smile.fi.intel.com/#t

Yes, enabledisable() is hard to parse but it is still self-explaining
and can be found easily by cscope. On the contrary, %pyD will likely
print some python code and it is not clear if it would be compatible
with v3. I am just kidding but you get the picture.

Best Regards,
Petr
