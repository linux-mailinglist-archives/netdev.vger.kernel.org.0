Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFEFC397705
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 17:45:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234465AbhFAPrB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 11:47:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233301AbhFAPq6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Jun 2021 11:46:58 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A40EC061574;
        Tue,  1 Jun 2021 08:45:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=pGxMEf6cI2zmD9A2dr6Kcpgggt5wOUbfj+KDV5ZubZY=; b=NiDf3wGs/Dj5kjAPmbl4MKtYo+
        a8b0jBJbKLjq3hxLXq1Doy+fC4Pthit/xOi7d0QLc+aqukDU51f9w8zpPP4+8yfaSdryX3eDRWLNZ
        pv7rFzdASFxJZ0pSqYv6uOBAnToIdRvYC4qzLPfeGNogN30PAEr7rGRlDtxPCjX0vxtgUUEnM86zu
        PUgrOvaIptk4S8FbhZwyri9zczlYuOB27S0opY/UPCCKdmqyf3ZhpClumu4OCo3xvjuJUwzCIO+Au
        AalERUlqMwibyjmQdFhiHRC/7fiOieFmnBOgCSjEclDY9ko7njzupUhqVvcOroRFcIDcKvQu++meI
        1Vosh+ZQ==;
Received: from willy by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lo6Yi-00AAfU-PH; Tue, 01 Jun 2021 15:44:05 +0000
Date:   Tue, 1 Jun 2021 16:44:00 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
Cc:     Justin He <Justin.He@arm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Petr Mladek <pmladek@suse.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
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
Message-ID: <YLZVwFh9MZJR3amM@casper.infradead.org>
References: <20210528113951.6225-1-justin.he@arm.com>
 <20210528113951.6225-3-justin.he@arm.com>
 <YLDpSnV9XBUJq5RU@casper.infradead.org>
 <AM6PR08MB437691E7314C6B774EFED4BDF7229@AM6PR08MB4376.eurprd08.prod.outlook.com>
 <YLEDwFCPcFx+qeul@casper.infradead.org>
 <AM6PR08MB437615DB6A6DEC33223A3138F7229@AM6PR08MB4376.eurprd08.prod.outlook.com>
 <YLEKqGkm8bX6LZfP@casper.infradead.org>
 <AM6PR08MB43764764B52AAC7F05B71056F73E9@AM6PR08MB4376.eurprd08.prod.outlook.com>
 <YLZSgZIcWyYTmqOT@casper.infradead.org>
 <CAHp75VfYgEtJeiVp8b10Va54QShyg4DmWeufuB_WGC8C2SE2mQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHp75VfYgEtJeiVp8b10Va54QShyg4DmWeufuB_WGC8C2SE2mQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 01, 2021 at 06:36:41PM +0300, Andy Shevchenko wrote:
> On Tue, Jun 1, 2021 at 6:32 PM Matthew Wilcox <willy@infradead.org> wrote:
> > On Tue, Jun 01, 2021 at 02:42:15PM +0000, Justin He wrote:
> 
> ...
> 
> > Just don't put anything
> > in the buffer if the user didn't supply enough space.  As long as you
> > get the return value right, they know the string is bad (or they don't
> > care if the string is bad)
> 
> It might be that I'm out of context here, but printf() functionality
> in the kernel (vsprintf() if being precise)  and its users consider
> that it should fill buffer up to the end of whatever space is
> available.

Do they though?  What use is it to specify a small buffer, print a
large filename into it and then use that buffer, knowing that it wasn't
big enough?  That would help decide whether we should print the
start or the end of the filename.

Remember, we're going for usefulness here, not abiding by the letter of
the standard under all circumstances, no matter the cost.  At least
partially because we're far outside the standard here; POSIX does
not specify what %pD does.

"The argument shall be a pointer to void. The value of the
pointer is converted to a sequence of printable characters, in an
implementation-defined manner."

