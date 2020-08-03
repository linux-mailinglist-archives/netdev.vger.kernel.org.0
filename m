Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29A8123ABFA
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 19:58:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728566AbgHCR6e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 13:58:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:54774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726239AbgHCR6e (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Aug 2020 13:58:34 -0400
Received: from gmail.com (unknown [104.132.1.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C4EF122B45;
        Mon,  3 Aug 2020 17:58:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596477513;
        bh=8kJJz6W/mGZtko6NJf68mrmroXbObC8q8KfF+PQIH3I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=alKiqgzMUdWV9Mzs5zcN4fyg3p/X5TiiDveOG7C4wnqW94hnWw/lIA0n8psIu+jns
         45wEDRMAucjA7d/YfdLyisGHnWDlS/xuO/u8HyZOK5FvNd9nD15G0EIkWEm69CMWxp
         eoz5HgyXVG/XjiCGV7phP6pXr3DcS2mtJWMm8FwQ=
Date:   Mon, 3 Aug 2020 10:58:32 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     syzbot <syzbot+24ebd650e20bd263ca01@syzkaller.appspotmail.com>,
        davem@davemloft.net, johan.hedberg@gmail.com, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        marcel@holtmann.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Subject: Re: KASAN: slab-out-of-bounds Read in hci_le_meta_evt
Message-ID: <20200803175832.GB1644292@gmail.com>
References: <000000000000a876b805abfa77e0@google.com>
 <20200803171232.GR1551@shell.armlinux.org.uk>
 <20200803172104.GA1644292@gmail.com>
 <20200803173223.GS1551@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200803173223.GS1551@shell.armlinux.org.uk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 03, 2020 at 06:32:24PM +0100, Russell King - ARM Linux admin wrote:
> On Mon, Aug 03, 2020 at 10:21:04AM -0700, Eric Biggers wrote:
> > On Mon, Aug 03, 2020 at 06:12:33PM +0100, Russell King - ARM Linux admin wrote:
> > > Dear syzbot,
> > > 
> > > Please explain why you are spamming me with all these reports - four so
> > > far.  I don't understand why you think I should be doing anything with
> > > these.
> > > 
> > > Thanks.
> > 
> > syzbot just uses get_maintainer.pl.
> > 
> > $ ./scripts/get_maintainer.pl net/bluetooth/hci_event.c
> > Marcel Holtmann <marcel@holtmann.org> (maintainer:BLUETOOTH SUBSYSTEM)
> > Johan Hedberg <johan.hedberg@gmail.com> (maintainer:BLUETOOTH SUBSYSTEM)
> > "David S. Miller" <davem@davemloft.net> (maintainer:NETWORKING [GENERAL])
> > Jakub Kicinski <kuba@kernel.org> (maintainer:NETWORKING [GENERAL])
> > Russell King <linux@armlinux.org.uk> (maintainer:SFF/SFP/SFP+ MODULE SUPPORT)
> > linux-bluetooth@vger.kernel.org (open list:BLUETOOTH SUBSYSTEM)
> > netdev@vger.kernel.org (open list:NETWORKING [GENERAL])
> > linux-kernel@vger.kernel.org (open list)
> 
> Ah, and, because the file mentions "phylink" (although it makes no use
> of the phylink code), get_maintainer spits out my address. Great.
> 
> So how do I get get_maintainer to identify patches that are making use
> of phylink, but avoid this bluetooth code... (that's not a question.)
> 

I think "K: " (content regex) in MAINTAINERS is best avoided.  This isn't the
first time that someone has volunteered to maintain all files containing $foo,
then complained when they receive emails for those files as they requested...

If you do really want to use it, can you use a more specific regex?  E.g. a
regex that matches "#include <linux/phylink.h>" or some specific function(s)?

- Eric
