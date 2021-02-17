Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4FFB31DDFE
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 18:14:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234340AbhBQRN7 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 17 Feb 2021 12:13:59 -0500
Received: from mga17.intel.com ([192.55.52.151]:45679 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234282AbhBQRN4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Feb 2021 12:13:56 -0500
IronPort-SDR: z8BdrBP6bYVx8VlJ2jZJeqIr0/rzfudMnbD9SsM8tOv7u9tRv69azkwhyRD6iTSTI9pU1te0bX
 kuZ22rS0d4AQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9898"; a="163039261"
X-IronPort-AV: E=Sophos;i="5.81,184,1610438400"; 
   d="scan'208";a="163039261"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2021 09:13:15 -0800
IronPort-SDR: Ze8hAK6HItV4g6zHQhfupFSfrmcGUQEuGy1aaFVF31i+EmsF3J0xduCKFOkGcaCBGcbbCMTpVW
 M10pDqE4dSAQ==
X-IronPort-AV: E=Sophos;i="5.81,184,1610438400"; 
   d="scan'208";a="400034792"
Received: from mvalka-mobl1.ger.corp.intel.com (HELO localhost) ([10.252.39.140])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2021 09:13:06 -0800
From:   Jani Nikula <jani.nikula@linux.intel.com>
To:     Petr Mladek <pmladek@suse.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>
Cc:     Christian =?utf-8?Q?K=C3=B6nig?= <christian.koenig@amd.com>,
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
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Raju Rangoju <rajur@chelsio.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH v1 1/3] string: Consolidate yesno() helpers under string.h hood
In-Reply-To: <YC0QBvv9HXr64ySf@alley>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <20210215142137.64476-1-andriy.shevchenko@linux.intel.com> <43456ba7-c372-84cc-4949-dcb817188e21@amd.com> <CAHp75VfVXnqdVRAPQ36vZeD-ZMCjWmjA_-6T=jnOEVMne4bv0g@mail.gmail.com> <YC0QBvv9HXr64ySf@alley>
Date:   Wed, 17 Feb 2021 19:13:03 +0200
Message-ID: <8735xubotc.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 17 Feb 2021, Petr Mladek <pmladek@suse.com> wrote:
> On Mon 2021-02-15 16:39:26, Andy Shevchenko wrote:
>> +Cc: Sakari and printk people
>> 
>> On Mon, Feb 15, 2021 at 4:28 PM Christian König
>> <christian.koenig@amd.com> wrote:
>> > Am 15.02.21 um 15:21 schrieb Andy Shevchenko:
>> > > We have already few similar implementation and a lot of code that can benefit
>> > > of the yesno() helper.  Consolidate yesno() helpers under string.h hood.
>> > >
>> > > Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
>> >
>> > Looks like a good idea to me, feel free to add an Acked-by: Christian
>> > König <christian.koenig@amd.com> to the series.
>> 
>> Thanks.
>> 
>> > But looking at the use cases for this, wouldn't it make more sense to
>> > teach kprintf some new format modifier for this?
>> 
>> As a next step? IIRC Sakari has at some point the series converted
>> yesno and Co. to something which I don't remember the details of.
>> 
>> Guys, what do you think?
>
> Honestly, I think that yesno() is much easier to understand than %py.
> And %py[DOY] looks really scary. It has been suggested at
> https://lore.kernel.org/lkml/YCqaNnr7ynRydczE@smile.fi.intel.com/#t
>
> Yes, enabledisable() is hard to parse but it is still self-explaining
> and can be found easily by cscope. On the contrary, %pyD will likely
> print some python code and it is not clear if it would be compatible
> with v3. I am just kidding but you get the picture.

Personally I prefer %s and the functions.

I think the format specifiers have become unwieldy. I don't remember any
of the kernel specific ones by heart, I always look them up or just
cargo-cult. I think the fourcc format specifiers are a nice cleanup, but
I don't remember them either. I'd like something like %foo{yesno} where,
if you remember the %foo part, you could actually also remember the
rest.

But really if you get *any* version accepted, I'm not going to argue
against it, and you can disregard this as meaningless bikeshedding.

BR,
Jani.


-- 
Jani Nikula, Intel Open Source Graphics Center
