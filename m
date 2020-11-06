Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78F0F2A98D5
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 16:54:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727520AbgKFPyJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 10:54:09 -0500
Received: from pb-smtp21.pobox.com ([173.228.157.53]:55823 "EHLO
        pb-smtp21.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726422AbgKFPyJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Nov 2020 10:54:09 -0500
X-Greylist: delayed 378 seconds by postgrey-1.27 at vger.kernel.org; Fri, 06 Nov 2020 10:54:03 EST
Received: from pb-smtp21.pobox.com (unknown [127.0.0.1])
        by pb-smtp21.pobox.com (Postfix) with ESMTP id 3345DE899A;
        Fri,  6 Nov 2020 10:47:45 -0500 (EST)
        (envelope-from nico@fluxnic.net)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=pobox.com; h=date:from:to
        :cc:subject:in-reply-to:message-id:references:mime-version
        :content-type; s=sasl; bh=RtcsJt/eTMQX0AekdetyiPtDTdw=; b=R+8hpm
        5jijOjnYvLj6tOfX/5oNII7cSgMn0PxUgIPK0K+jvt8kluVjwjjsno6FBG4hMoSo
        cSnHihLGcCFX2yKHp8+4yvCbtfVTNt3yRGHV7wn1bYsyVRuA/NJkC+LN9eqx0MlP
        t4tYXm3vwqmPiZ5wcJvebR5R0G5zg9Op5Zc3k=
Received: from pb-smtp21.sea.icgroup.com (unknown [127.0.0.1])
        by pb-smtp21.pobox.com (Postfix) with ESMTP id 2AA98E8999;
        Fri,  6 Nov 2020 10:47:45 -0500 (EST)
        (envelope-from nico@fluxnic.net)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed; d=fluxnic.net;
 h=date:from:to:cc:subject:in-reply-to:message-id:references:mime-version:content-type; s=2016-12.pbsmtp; bh=1DuSZ7eFlMbweAWYzlgwFaZ72TKaER7Yq9u+ilYIfEg=; b=WLNPjRP7XOdMKGgx7N/X/QPEidwIAH4A0zbbRwRXGoEO4pKRW3nZIHXjJP5GEbgMhbFJjkJwu3Rk5nHAMH+NhXYMWf7xxAJHtCBJBOVCx4lAnjRppPJLM64qbC5KvdnX1pznCJttUL29EslMXl5WAR2wGEdcPgIx8LSZrIlCxC0=
Received: from yoda.home (unknown [24.203.50.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by pb-smtp21.pobox.com (Postfix) with ESMTPSA id 1C8E4E8997;
        Fri,  6 Nov 2020 10:47:42 -0500 (EST)
        (envelope-from nico@fluxnic.net)
Received: from xanadu.home (xanadu.home [192.168.2.2])
        by yoda.home (Postfix) with ESMTPSA id 438DE2DA0963;
        Fri,  6 Nov 2020 10:47:40 -0500 (EST)
Date:   Fri, 6 Nov 2020 10:47:40 -0500 (EST)
From:   Nicolas Pitre <nico@fluxnic.net>
To:     David Laight <David.Laight@ACULAB.COM>
cc:     'Jakub Kicinski' <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        netdev <netdev@vger.kernel.org>, Lee Jones <lee.jones@linaro.org>
Subject: RE: [PATCH net-next v2 6/7] drivers: net: smc911x: Fix cast from
 pointer to integer of different size
In-Reply-To: <4892cf6d877c4e529d941345dcdb015a@AcuMS.aculab.com>
Message-ID: <nycvar.YSQ.7.78.906.2011061032200.2184@knanqh.ubzr>
References: <20201104154858.1247725-1-andrew@lunn.ch> <20201104154858.1247725-7-andrew@lunn.ch> <20201105144711.40a2f8f6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <babda61688af4f42b4a9e0fb41808272@AcuMS.aculab.com> <nycvar.YSQ.7.78.906.2011060942360.2184@knanqh.ubzr>
 <4892cf6d877c4e529d941345dcdb015a@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Pobox-Relay-ID: 67CECEBA-2047-11EB-B1A5-D609E328BF65-78420484!pb-smtp21.pobox.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 6 Nov 2020, David Laight wrote:

> From: Nicolas Pitre
> > Sent: 06 November 2020 15:06
> > 
> > On Fri, 6 Nov 2020, David Laight wrote:
> > 
> > > From: Jakub Kicinski
> > > > Sent: 05 November 2020 22:47
> > > >
> > > > On Wed,  4 Nov 2020 16:48:57 +0100 Andrew Lunn wrote:
> > > > > -	buf = (char*)((u32)skb->data & ~0x3);
> > > > > -	len = (skb->len + 3 + ((u32)skb->data & 3)) & ~0x3;
> > > > > -	cmdA = (((u32)skb->data & 0x3) << 16) |
> > > > > +	offset = (unsigned long)skb->data & 3;
> > > > > +	buf = skb->data - offset;
> > > > > +	len = skb->len + offset;
> > > > > +	cmdA = (offset << 16) |
> > > >
> > > > The len calculation is wrong, you trusted people on the mailing list
> > > > too much ;)
> > >
> > > I misread what the comment-free convoluted code was doing....
> > >
> > > Clearly it is rounding the base address down to a multiple of 4
> > > and passing the offset in cmdA.
> > > This is fine - but quite why the (I assume) hardware doesn't do
> > > this itself and just document that it does a 32bit read is
> > > another matter - the logic will be much the same and I doubt
> > > anything modern is that pushed for space.
> > >
> > > However rounding the length up to a multiple of 4 is buggy.
> > > If this is an ethernet chipset it must (honest) be able to
> > > send frames that don't end on a 4 byte boundary.
> > > So rounding up the length is very dubious.
> > 
> > I probably wrote that code. Probably something like 20 years ago at this
> > point. I no longer have access to the actual hardware either.
> > 
> > But my recollection is that this ethernet chip had the ability to do 1,
> > 2 or 4 byte wide data transfers.
> > 
> > To be able to efficiently use I/O helpers like readsl()/writesl() on
> > ARM, the host memory pointer had to be aligned to a 32-bit boundary
> > because misaligned accesses were not supported by the hardware and
> > therefore were very costly to perform in software with a bytewise
> > approach. Remember that back then, the CPU clock was very close to the
> > actual ethernet throughput and PIO was the only option.
> > 
> > This was made even worse by the fact that, on some boards, the hw
> > designers didn't consider connecting the byte select signals as a
> > worthwhile thing to do. That means only 32-bit wide access to the chip
> > were possible.
> > 
> > So to work around this, the skb buffer address was rounded down, the
> > length was rounded up, and
> > the on-chip pointer was adjusted to refer to the actual data
> > payload accordingly with the original length. Therefore the proposed
> > patch is indeed wrong.
> 
> Which one, the one that rounds the length up.
> Or the one that just adds 'initial padding'.

Let's say the hunk quoted above. That's what caught my attention.

My suggestion would be to simply change the u32 cast to uintptr_t to 
quiet warnings and leave it at that.

> > Just to say that, although the code might look suspicious, there was a
> > reason for that and it did work correctly for a long long time at this
> > point. Obviously those were only 32- bit systems (I really doubt those
> > ethernet chips were ever used on 64-bit systems).
> 
> Oh, OK, this is one of the ethernet chips that had an on-chip fifo
> that the software had to use PIO to fill.
> (I remember them well! Mostly 16bit ISA ones and the odd EISA one.)
> 
> So you can 'cheat' at the start of the frame to do aligned 32-bit writes.
> (Unless the skb has odd fragmentation - unlikely for IP.)
> 
> The end of frame is more problematic if the byte enables are missing.
> Depending exactly on how the end of frame is signalled.
> If the frame length is passed (which probably needs to include the
> initial pad) then it may not matter about extra bytes in the tx fifo.

It was more like on-chip SRAM than an actual FIFO. The position within 
that SRAM for the frame to send could be modified which is why having 
2 extra bytes of unrelated data at the beginning didn't matter. And the 
command to send the frame has a byte length, so that takes care of the 
extra trailing bytes too.

> (Provided they don't end up in the following frame.)

No because the data start is adjusted again for the next one.

Trust me, it all worked fine back then, confirmed by multiple tests and 
ethernet dumps.

> I wonder when this was last used?

It was still common in 2005 or so.

This very chip is still being used by a few individuals interested in 
running latest kernels on vintage hardware.


Nicolas
