Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C44BB493AF8
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 14:18:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354768AbiASNSM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jan 2022 08:18:12 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:34898 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354779AbiASNSF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jan 2022 08:18:05 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 54C8621123;
        Wed, 19 Jan 2022 13:18:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1642598283; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5030rwRdQVdGOVRRFHRTkRKqifOJXNno9J3Z4c5+1YA=;
        b=X+sTq95MaR4ipOc0sga1XDfWcMiW9FTvop0fDJWvb/D9s4D7IGDBilB2aVkSGlh5aFcJD/
        n/WEnrXPiJsFn6TQAANEUr68P561Vum2hTmCOBIaTd3It9Hqa5/LYx0lz0+wL5aAgSaYNR
        fPvU2djzpoRxXztcSp7BAsmfXILijxY=
Received: from suse.cz (unknown [10.100.224.162])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id DB985A3B89;
        Wed, 19 Jan 2022 13:18:01 +0000 (UTC)
Date:   Wed, 19 Jan 2022 14:18:01 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     Lucas De Marchi <lucas.demarchi@intel.com>
Cc:     linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, amd-gfx@lists.freedesktop.org,
        linux-security-module@vger.kernel.org,
        nouveau@lists.freedesktop.org, netdev@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
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
        Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>,
        Raju Rangoju <rajur@chelsio.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Vishal Kulkarni <vishal@chelsio.com>
Subject: Re: [PATCH 0/3] lib/string_helpers: Add a few string helpers
Message-ID: <YegPiR7LU8aVisMf@alley>
References: <20220119072450.2890107-1-lucas.demarchi@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220119072450.2890107-1-lucas.demarchi@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue 2022-01-18 23:24:47, Lucas De Marchi wrote:
> Add some helpers under lib/string_helpers.h so they can be used
> throughout the kernel. When I started doing this there were 2 other
> previous attempts I know of, not counting the iterations each of them
> had:
> 
> 1) https://lore.kernel.org/all/20191023131308.9420-1-jani.nikula@intel.com/
> 2) https://lore.kernel.org/all/20210215142137.64476-1-andriy.shevchenko@linux.intel.com/#t
> 
> Going through the comments I tried to find some common ground and
> justification for what is in here, addressing some of the concerns
> raised.
> 
> d. This doesn't bring onoff() helper as there are some places in the
>    kernel with onoff as variable - another name is probably needed for
>    this function in order not to shadow the variable, or those variables
>    could be renamed.  Or if people wanting  <someprefix>
>    try to find a short one

I would call it str_on_off().

And I would actually suggest to use the same style also for
the other helpers.

The "str_" prefix would make it clear that it is something with
string. There are other <prefix>_on_off() that affect some
functionality, e.g. mute_led_on_off(), e1000_vlan_filter_on_off().

The dash '_' would significantly help to parse the name. yesno() and
onoff() are nicely short and kind of acceptable. But "enabledisable()"
is a puzzle.

IMHO, str_yes_no(), str_on_off(), str_enable_disable() are a good
compromise.

The main motivation should be code readability. You write the
code once. But many people will read it many times. Open coding
is sometimes better than misleading macro names.

That said, I do not want to block this patchset. If others like
it... ;-)


> e. One alternative to all of this suggested by Christian König
>    (43456ba7-c372-84cc-4949-dcb817188e21@amd.com) would be to add a
>    printk format. But besides the comment, he also seemed to like
>    the common function. This brought the argument from others that the
>    simple yesno()/enabledisable() already used in the code is easier to
>    remember and use than e.g. %py[DOY]

Thanks for not going this way :-)

> Last patch also has some additional conversion of open coded cases. I
> preferred starting with drm/ since this is "closer to home".
> 
> I hope this is a good summary of the previous attempts and a way we can
> move forward.
> 
> Andrew Morton, Petr Mladek, Andy Shevchenko: if this is accepted, my
> proposal is to take first 2 patches either through mm tree or maybe
> vsprintf. Last patch can be taken later through drm.

I agree with Andy that it should go via drm tree. It would make it
easier to handle potential conflicts.

Just in case, you decide to go with str_yes_no() or something similar.
Mass changes are typically done at the end on the merge window.
The best solution is when it can be done by a script.

Best Regards,
Petr
