Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49E642A1AE7
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 23:04:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725857AbgJaWEB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Oct 2020 18:04:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:38660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725782AbgJaWEA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 31 Oct 2020 18:04:00 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DA77C2072C;
        Sat, 31 Oct 2020 22:03:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604181840;
        bh=vKrIdrKzKmTiUrHQcXrGyvaiTb/mYhEni5U1apPYqrc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bMevfpwqvpLfjFwh8YFzIlZUuC+xTTXqrqJ1Zz+MAr05a53LBKGnO4h5hMG3qvcY0
         XuWKmRFHo4RjpgGfxOECl0JsfTZ6hbLHi5ljGYSbhgs8THDemi9i10rYCbUjnYMfV2
         qWl3cPTzVGqp2G2sg2lJcod3+IvwHfR6cGeBgZe8=
Date:   Sat, 31 Oct 2020 15:03:59 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Xie He <xie.he.0141@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Krzysztof Halasa <khc@pm.waw.pl>
Subject: Re: [PATCH net-next] net: dlci: Deprecate the DLCI driver (aka the
 Frame Relay layer)
Message-ID: <20201031150359.0f944863@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <CAK8P3a1kJT50s+BVF8-fmX6ctX2pmVtcg5rnS__EBQvseuqWNA@mail.gmail.com>
References: <20201028070504.362164-1-xie.he.0141@gmail.com>
        <20201030200705.6e2039c2@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <CAJht_EOk43LdKVU4qH1MB5pLKcSONazA9XsKJUMTG=79TJ-3Rg@mail.gmail.com>
        <20201031095146.5e6945a1@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <CAK8P3a1kJT50s+BVF8-fmX6ctX2pmVtcg5rnS__EBQvseuqWNA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 31 Oct 2020 22:41:30 +0100 Arnd Bergmann wrote:
> On Sat, Oct 31, 2020 at 5:53 PM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > On Fri, 30 Oct 2020 22:10:42 -0700 Xie He wrote:  
> > > > The usual way of getting rid of old code is to move it to staging/
> > > > for a few releases then delete it, like Arnd just did with wimax.  
> > >
> > > Oh. OK. But I see "include/linux/if_frad.h" is included in
> > > "net/socket.c", and there's still some code in "net/socket.c" related
> > > to it. If we move all these files to "staging/", we need to change the
> > > "include" line in "net/socket.c" to point to the new location, and we
> > > still need to keep a little code in "net/socket.c". So I think if we
> > > move it to "staging/", we can't do this in a clean way.  
> >
> > I'd just place that code under appropriate #ifdef CONFIG_ so we don't
> > forget to remove it later.  It's just the dlci_ioctl_hook, right?
> >
> > Maybe others have better ideas, Arnd?  
> 
> I think it can just go in the bin directly.

Ack, fine by me.

> I actually submitted a couple of patches to clean up drivers/net/wan
> last year but didn't follow up with a new version after we decided
> that x.25 is still needed, see
> https://lore.kernel.org/netdev/20191209151256.2497534-1-arnd@arndb.de/
> 
> I can resubmit if you like.

Let's just leave it at DLCI/SDLA for now, we can revisit once Dave 
is back :)
