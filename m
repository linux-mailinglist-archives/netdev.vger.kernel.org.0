Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53A123978B2
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 19:06:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234556AbhFARIF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 13:08:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231918AbhFARIE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Jun 2021 13:08:04 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C0B5C061574;
        Tue,  1 Jun 2021 10:06:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=hA62la00vFMppd9s1AomcqtrMlyNDRJAkQFp1nXnFAg=; b=bhrq8HGvk2ZC9QEwuF3N+FtO15
        D91cwCGObxRWpjhgo3KsDyZ/ccqpaKL1PKiqNJ6DyXoAd3sH8j3/v38LCVcvBBaQBBbuic3LwsDAJ
        +8tAvC6xnAzAmA2HBRfvUbPq/pfObzWigW5VlFNHN6lhA+Gd/VRL+a5EXewYUpnCrHRxvkb1TzGlH
        N401VSuO7kjeKd04aOalX52/LMQFAWweJvJvB+wz/rFUfpsnLI/iY+MRzMxnPT/d5GwzdRe7k/JbE
        vf5bEBx1jR7MUlL5Kj0nk0aza5v71zysqRMPjrRoDA00lec1DdVTRanpocwFGdS/z1Iad8J2I7IBt
        rFdK0zyg==;
Received: from willy by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lo7pK-00AEY3-91; Tue, 01 Jun 2021 17:05:15 +0000
Date:   Tue, 1 Jun 2021 18:05:14 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
Cc:     Justin He <Justin.He@arm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Petr Mladek <pmladek@suse.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Jonathan Corbet <corbet@lwn.net>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Johannes Berg <johannes.berg@intel.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH RFCv2 2/3] lib/vsprintf.c: make %pD print full path for
 file
Message-ID: <YLZoyjSJyzU5w1qO@casper.infradead.org>
References: <AM6PR08MB437691E7314C6B774EFED4BDF7229@AM6PR08MB4376.eurprd08.prod.outlook.com>
 <YLEDwFCPcFx+qeul@casper.infradead.org>
 <AM6PR08MB437615DB6A6DEC33223A3138F7229@AM6PR08MB4376.eurprd08.prod.outlook.com>
 <YLEKqGkm8bX6LZfP@casper.infradead.org>
 <AM6PR08MB43764764B52AAC7F05B71056F73E9@AM6PR08MB4376.eurprd08.prod.outlook.com>
 <YLZSgZIcWyYTmqOT@casper.infradead.org>
 <CAHp75VfYgEtJeiVp8b10Va54QShyg4DmWeufuB_WGC8C2SE2mQ@mail.gmail.com>
 <YLZVwFh9MZJR3amM@casper.infradead.org>
 <YLZX9oicn8u4ZVCl@smile.fi.intel.com>
 <YLZcAesVG1SYL5fp@smile.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YLZcAesVG1SYL5fp@smile.fi.intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 01, 2021 at 07:10:41PM +0300, Andy Shevchenko wrote:
> On Tue, Jun 01, 2021 at 06:53:26PM +0300, Andy Shevchenko wrote:
> > On Tue, Jun 01, 2021 at 04:44:00PM +0100, Matthew Wilcox wrote:
> > > On Tue, Jun 01, 2021 at 06:36:41PM +0300, Andy Shevchenko wrote:
> > > > On Tue, Jun 1, 2021 at 6:32 PM Matthew Wilcox <willy@infradead.org> wrote:
> > > > > On Tue, Jun 01, 2021 at 02:42:15PM +0000, Justin He wrote:
> > > > 
> > > > ...
> > > > 
> > > > > Just don't put anything
> > > > > in the buffer if the user didn't supply enough space.  As long as you
> > > > > get the return value right, they know the string is bad (or they don't
> > > > > care if the string is bad)
> > > > 
> > > > It might be that I'm out of context here, but printf() functionality
> > > > in the kernel (vsprintf() if being precise)  and its users consider
> > > > that it should fill buffer up to the end of whatever space is
> > > > available.
> > > 
> > > Do they though?  What use is it to specify a small buffer, print a
> > > large filename into it and then use that buffer, knowing that it wasn't
> > > big enough?  That would help decide whether we should print the
> > > start or the end of the filename.
> > > 
> > > Remember, we're going for usefulness here, not abiding by the letter of
> > > the standard under all circumstances, no matter the cost.  At least
> > > partially because we're far outside the standard here; POSIX does
> > > not specify what %pD does.
> > > 
> > > "The argument shall be a pointer to void. The value of the
> > > pointer is converted to a sequence of printable characters, in an
> > > implementation-defined manner."
> > 
> > All nice words, but don't forget kasprintf() or other usages like this.
> > For the same input we have to have the same result independently on the room in
> > the buffer.
> > 
> > So, if I print "Hello, World" I should always get it, not "Monkey's Paw".
> > I.o.w.
> > 
> >  snprintf(10) ==> "Hello, Wor"
> >  snprintf(5)  ==> "Hello"
> >  snprintf(2)  !=> "Mo"
> >  snprintf(1)  !=> "M"
> >  snprintf(1)  ==> "H"
> > 
> > Inconsistency here is really not what we want.
> 
> I have to add that in light of the topic those characters should be counted
> from the end of the filename. So, we will give user as much as possible of useful
> information. I.o.w. always print the last part of filename up to the buffer
> size or if the filename is shorter than buffer we will have it in full.

Ah, not monkey's paw, but donkey hoof then ...

Here's some examples, what do you think makes sense?

snprintf(buf, 16, "bad file '%pD'\n", q);

what content do you want buf to have when q is variously:

1. /abcd/efgh
2. /a/bcdefgh.iso
3. /abcdef/gh

I would argue that
"bad file ''\n"
is actually a better string to have than any of (case 2)
"bad file '/a/bc"
"bad file 'bcdef"
"bad file 'h.iso"
