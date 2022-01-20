Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D9AC4949B1
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 09:38:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359312AbiATIiO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 03:38:14 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:56146 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359292AbiATIiM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 03:38:12 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 1F79E1F391;
        Thu, 20 Jan 2022 08:38:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1642667889; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=S1149P6IJdsdpbMcrXZq6Mc6WqPqJoBvK3pMWsa4MN8=;
        b=mgVK2GKX4z682928eNQNmcKH4PlzeX6XpPLxSucJKp6GDejDBl9xGnHm3EQ7m1HB7u4s0x
        HmV98Y94Jgx4BP2N49y70kzTAsfC49uladYoyY9u+lMOkRTYf7K7VjPT83DyGrKubQrpNL
        4X9INnLQQrZk7xUamCgzquBLJDcbk7E=
Received: from suse.cz (unknown [10.100.224.162])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 1E602A3B81;
        Thu, 20 Jan 2022 08:38:04 +0000 (UTC)
Date:   Thu, 20 Jan 2022 09:38:04 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     Jani Nikula <jani.nikula@linux.intel.com>
Cc:     Lucas De Marchi <lucas.demarchi@intel.com>,
        linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
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
Message-ID: <YekfbKMjOP9ecc5v@alley>
References: <20220119072450.2890107-1-lucas.demarchi@intel.com>
 <YegPiR7LU8aVisMf@alley>
 <87tudzbykz.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87tudzbykz.fsf@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed 2022-01-19 16:16:12, Jani Nikula wrote:
> On Wed, 19 Jan 2022, Petr Mladek <pmladek@suse.com> wrote:
> > On Tue 2022-01-18 23:24:47, Lucas De Marchi wrote:
> >> d. This doesn't bring onoff() helper as there are some places in the
> >>    kernel with onoff as variable - another name is probably needed for
> >>    this function in order not to shadow the variable, or those variables
> >>    could be renamed.  Or if people wanting  <someprefix>
> >>    try to find a short one
> >
> > I would call it str_on_off().
> >
> > And I would actually suggest to use the same style also for
> > the other helpers.
> >
> > The "str_" prefix would make it clear that it is something with
> > string. There are other <prefix>_on_off() that affect some
> > functionality, e.g. mute_led_on_off(), e1000_vlan_filter_on_off().
> >
> > The dash '_' would significantly help to parse the name. yesno() and
> > onoff() are nicely short and kind of acceptable. But "enabledisable()"
> > is a puzzle.
> >
> > IMHO, str_yes_no(), str_on_off(), str_enable_disable() are a good
> > compromise.
> >
> > The main motivation should be code readability. You write the
> > code once. But many people will read it many times. Open coding
> > is sometimes better than misleading macro names.
> >
> > That said, I do not want to block this patchset. If others like
> > it... ;-)
> 
> I don't mind the names either way. Adding the prefix and dashes is
> helpful in that it's possible to add the functions first and convert
> users at leisure, though with a bunch of churn, while using names that
> collide with existing ones requires the changes to happen in one go.

It is also possible to support both notations at the beginning.
And convert the existing users in the 2nd step.

> What I do mind is grinding this series to a halt once again. I sent a
> handful of versions of this three years ago, with inconclusive
> bikeshedding back and forth, eventually threw my hands up in disgust,
> and walked away.

Yeah, and I am sorry for bikeshedding. Honestly, I do not know what is
better. This is why I do not want to block this series when others
like this.

My main motivation is to point out that:

    enabledisable(enable)

might be, for some people, more eye bleeding than

    enable ? "enable" : "disable"


The problem is not that visible with yesno() and onoff(). But as you said,
onoff() confliscts with variable names. And enabledisable() sucks.
As a result, there is a non-trivial risk of two mass changes:

now:

- contition ? "yes" : "no"
+ yesno(condition)

a few moths later:

- yesno(condition)
+ str_yes_no(condition)


Best Regards,
Petr
