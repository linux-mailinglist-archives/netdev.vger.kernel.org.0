Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20EC6493C98
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 16:06:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344958AbiASPGn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jan 2022 10:06:43 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:49320 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235115AbiASPGn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jan 2022 10:06:43 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D64CCB80E09;
        Wed, 19 Jan 2022 15:06:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04AE5C004E1;
        Wed, 19 Jan 2022 15:06:36 +0000 (UTC)
Date:   Wed, 19 Jan 2022 10:06:35 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Sakari Ailus <sakari.ailus@linux.intel.com>
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
        Christian =?UTF-8?B?S8O2bmln?= <christian.koenig@amd.com>,
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
Message-ID: <20220119100635.6c45372b@gandalf.local.home>
In-Reply-To: <YefXg03hXtrdUj6y@paasikivi.fi.intel.com>
References: <20220119072450.2890107-1-lucas.demarchi@intel.com>
        <20220119072450.2890107-2-lucas.demarchi@intel.com>
        <YefXg03hXtrdUj6y@paasikivi.fi.intel.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 19 Jan 2022 11:18:59 +0200
Sakari Ailus <sakari.ailus@linux.intel.com> wrote:

> On Tue, Jan 18, 2022 at 11:24:48PM -0800, Lucas De Marchi wrote:
> > @@ -1354,8 +1345,7 @@ static bool tomoyo_print_condition(struct tomoyo_io_buffer *head,
> >  	case 3:
> >  		if (cond->grant_log != TOMOYO_GRANTLOG_AUTO)
> >  			tomoyo_io_printf(head, " grant_log=%s",
> > -					 tomoyo_yesno(cond->grant_log ==
> > -						      TOMOYO_GRANTLOG_YES));
> > +					 yesno(cond->grant_log == TOMOYO_GRANTLOG_YES));  
> 
> This would be better split on two lines.

Really? Yuck!

I thought the "max line size" guideline was going to grow to a 100, but I
still see it as 80. But anyway...

	cond->grant_log ==
	TOMOYO_GRANTLOG_YES

is not readable at all. Not compared to

	cond->grant_log == TOMOYO_GRANTLOG_YES

I say keep it one line!

Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>

-- Steve

> 
> Then,
> 
> Reviewed-by: Sakari Ailus <sakari.ailus@linux.intel.com>

