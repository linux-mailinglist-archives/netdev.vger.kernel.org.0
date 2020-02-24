Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E570116A65C
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 13:47:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727393AbgBXMrh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 07:47:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:53002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726778AbgBXMrh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Feb 2020 07:47:37 -0500
Received: from localhost (95-141-97-180.as16211.net [95.141.97.180])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7444A2072D;
        Mon, 24 Feb 2020 12:47:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582548454;
        bh=RFoS0XwskBiZFNVHWB51s86/gyyO1NSdhT0NCh46r0k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eOh0VUShL3u9AXixt5yxW1EQBNqCAPvXRSNlnZgviaRMOD2UHVJDAeQQcpPwpK3ji
         unP7z+wZPN68hKpSKxwSl0o0AWeR8xaB5tFCLEyZ5BjW4VJZnk5ed+HjhIx/cZdqd6
         N+8RpBunIjvkJNgqRkaF8dLX4pbaGlmbPurf+wyo=
Date:   Mon, 24 Feb 2020 13:47:32 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        Doug Ledford <dledford@redhat.com>,
        Ira Weiny <ira.weiny@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Network Development <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT] Networking
Message-ID: <20200224124732.GA694161@kroah.com>
References: <20150624.063911.1220157256743743341.davem@davemloft.net>
 <CA+55aFybr6Fjti5WSm=FQpfwdwgH1Pcfg6L81M-Hd9MzuSHktg@mail.gmail.com>
 <CAMuHMdViacgi1W8acma7GhWaaVj92z6pg-g7ByvYOQL-DToacA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdViacgi1W8acma7GhWaaVj92z6pg-g7ByvYOQL-DToacA@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 24, 2020 at 11:01:09AM +0100, Geert Uytterhoeven wrote:
> Hi Linus,
> 
> On Thu, Jun 25, 2015 at 1:38 AM Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> > On Wed, Jun 24, 2015 at 6:39 AM, David Miller <davem@davemloft.net> wrote:
> > >   git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git master
> >
> > On the *other* side of the same conflict, I find an even more
> > offensive commit, namely commit 4cd7c9479aff ("IB/mad: Add support for
> > additional MAD info to/from drivers") which adds a BUG_ON() for a
> > sanity check, rather than just returning -EINVAL or something sane
> > like that.
> >
> > I'm getting *real* tired of that BUG_ON() shit. I realize that
> > infiniband is a niche market, and those "commercial grade" niche
> > markets are more-than-used-to crap code and horrible hacks, but this
> > is still the kernel. We don't add random machine-killing debug checks
> > when it is *so* simple to just do
> >
> >         if (WARN_ON_ONCE(..))
> >                 return -EINVAL;
> >
> > instead.
> 
> And if we follow that advice, friendly Greg will respond with:
> "We really do not want WARN_ON() anywhere, as that causes systems with
>  panic-on-warn to reboot."
> https://lore.kernel.org/lkml/20191121135743.GA552517@kroah.com/

Yes, we should not have any WARN_ON calls for something that userspace
can trigger, because then syzbot will trigger it and we will get an
annoying report saying to fix it :)

thanks,

greg k-h
