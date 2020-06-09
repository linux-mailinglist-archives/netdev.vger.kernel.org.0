Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19B841F4854
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 22:53:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727017AbgFIUxK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jun 2020 16:53:10 -0400
Received: from mx2.suse.de ([195.135.220.15]:60948 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725993AbgFIUxK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Jun 2020 16:53:10 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 0A9B4AD5F;
        Tue,  9 Jun 2020 20:53:08 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 9845460485; Tue,  9 Jun 2020 22:53:03 +0200 (CEST)
Date:   Tue, 9 Jun 2020 22:53:03 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        David Miller <davem@davemloft.net>, stephen@networkplumber.org,
        o.rempel@pengutronix.de, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com, kuba@kernel.org, corbet@lwn.net,
        linville@tuxdriver.com, david@protonic.nl, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, linux@armlinux.org.uk,
        mkl@pengutronix.de, marex@denx.de, christian.herber@nxp.com,
        amitc@mellanox.com, petrm@mellanox.com
Subject: Re: [PATCH ethtool v1] netlink: add master/slave configuration
 support
Message-ID: <20200609205303.z3kfoptj7w2jpnts@lion.mk-sys.cz>
References: <202006091222.CB97F743AD@keescook>
 <20200609.123437.1057990370119930723.davem@davemloft.net>
 <202006091244.C8B5F9525@keescook>
 <20200609.130517.1373472507830142138.davem@davemloft.net>
 <202006091312.F91BB4E0CE@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202006091312.F91BB4E0CE@keescook>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 09, 2020 at 01:29:42PM -0700, Kees Cook wrote:
> On Tue, Jun 09, 2020 at 01:05:17PM -0700, David Miller wrote:
> > From: Kees Cook <keescook@chromium.org>
> > Date: Tue, 9 Jun 2020 12:49:48 -0700
> > 
> > > Okay, for now, how about:
> > > 
> > > - If we're dealing with an existing spec, match the language.
> > 
> > Yes.
> > 
> > > - If we're dealing with a new spec, ask the authors to fix their language.
> > 
> > Please be more specific about "new", if it's a passed and ratified standard
> > then to me it is "existing".
> 
> Sure. But many kernel devs are also interacting with specifications as
> they're being developed. We can have an eye out for this when we're in
> such positions.

I fully agree that this is the right place to raise concern like this.
But I have to remind that here we are talking about implementation of an
existing standard.

> > > - If a new version of a spec has updated its language, adjust the kernel's.
> > 
> > Unless you're willing to break UAPI, which I'm not, I don't see how this is
> > tenable.
> 
> We'll get there when we get there. I honestly don't think any old spec is
> actually going to change their language; I look forward to being proven
> wrong. But many times there is no UAPI. If it's some register states
> between driver and hardware, no users sees or cares what the register
> is named.

In my eyes, that would be one less reason to invent different names for
them just to avoid someone being offended.

If you look into include/linux/tcp.h, you can find this comment near the
beginning of struct tcp_sock definition:

/*
 *	RFC793 variables by their proper names. This means you can
 *	read the code and the spec side by side (and laugh ...)
 *	See RFC793 and RFC1122. The RFC writes these in capitals.
 */

It is a bit confusing now as there have been some reorderings but you
can see that even if it's an internal kernel data structure, original
author(s) of the code considered it beneficial to use the same names as
standard for the state variables so that people reading the code don't
need a translation table between state variables in kernel code and in
standards.

The same IMHO holds for your example with register states or names:
I believe it is highly beneficial to make them consistent with technical
documentation. There are even cases where we violate kernel coding style
(e.g. by using camelcase) to match the names from specification.

> > This is why I'm saying, just make sure new specs use language that is
> > less controversial.  Then we just use what the specs use.
> > 
> > Then you don't have to figure out what to do about established UAPIs
> > and such, it's a non-issue.
> 
> Yes, but there are places where people use these terms where they are
> NOT part of specs, and usually there is actually _better_ terminology
> to be used, and we can easily stop adding those. And we can start to
> rename old "independent" cases too.

Surely there are - but it is not the case here.

Michal
