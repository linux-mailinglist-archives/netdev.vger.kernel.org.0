Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D3E8494C0A
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 11:50:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376389AbiATKpj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 05:45:39 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:55526 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231222AbiATKpj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 05:45:39 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 971CA1F394;
        Thu, 20 Jan 2022 10:45:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1642675537; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lNXsCxk1kmLzWZ3KuMXgc2QP7yNDhqQLgFtjl4LsFGg=;
        b=s80Eh1CewTbGXaANSfdmhOC8yS7mIDv9FCt/I0hzu7cf9Pu9Si7tpC0AUMlifM6MhpyvNI
        EdQykNw0T5LfW9CMRgRZQ36TExFEeiyITs3AE72J+aELbU1yWnXuKDUzDzoC1F8NJaMUMu
        9y1MB7bqBlsK9YohaVnVWyOxwl7Ul6w=
Received: from suse.cz (unknown [10.100.224.162])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 65535A3B81;
        Thu, 20 Jan 2022 10:45:30 +0000 (UTC)
Date:   Thu, 20 Jan 2022 11:45:36 +0100
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
Message-ID: <Yek9UEHpS16/9ajt@alley>
References: <20220119072450.2890107-1-lucas.demarchi@intel.com>
 <YegPiR7LU8aVisMf@alley>
 <87tudzbykz.fsf@intel.com>
 <YekfbKMjOP9ecc5v@alley>
 <8735libwjo.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8735libwjo.fsf@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu 2022-01-20 11:12:27, Jani Nikula wrote:
> On Thu, 20 Jan 2022, Petr Mladek <pmladek@suse.com> wrote:
> > The problem is not that visible with yesno() and onoff(). But as you said,
> > onoff() confliscts with variable names. And enabledisable() sucks.
> > As a result, there is a non-trivial risk of two mass changes:
> 
> My point is, in the past three years we could have churned through more
> than two mass renames just fine, if needed, *if* we had just managed to
> merge something for a start!

Huh, this sound alarming.

Cosmetic changes just complicate history. They make "git blame" useless.
They also complicate backports. I know that it is not problem for
mainline. But there are supported stable branches, ...

There should be a good reason for such changes. They should not be
done light-heartedly.

Best Regards,
Petr
