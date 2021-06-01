Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B08B63976BD
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 17:31:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234397AbhFAPdV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 11:33:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234305AbhFAPdO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Jun 2021 11:33:14 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A931C061574;
        Tue,  1 Jun 2021 08:31:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=spulMJU5vcfm6fCDiXKafJqkb0QFdQy2mPq+FRg3HrI=; b=MutdgsODQUN/W4vU1lKs+wXA2y
        z9fs2I5gVYi629eoU7OElZjgZFcyo/GhXq4Zp14HO7usWO1hYc45clLTQF4nLnVk1iMLyMX+mo6J4
        n99BeytS6B7UaSG/IBtoVBbH0lasTiVpvs5VXWnRwgTUlMCEKD5C3xJscexDf0op9JU/Rik9RYBj0
        jOtkW8/sivy6F+MeQA3q2xG8oy8nGdtJpsSKR6F+lrBngwSjHTYbK2SEeK8Q73GdMMOpamtPKICBZ
        YYCYK961/27+L3Kh4Id08WqDV2W0Gw7ZHT0gtgyZar+YsJzJjdk2GEQ3mXh4b8WuwxHEcEZiNW5Kl
        161ausGQ==;
Received: from willy by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lo6LJ-00AA26-Vr; Tue, 01 Jun 2021 15:30:15 +0000
Date:   Tue, 1 Jun 2021 16:30:09 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Justin He <Justin.He@arm.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
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
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH RFCv2 2/3] lib/vsprintf.c: make %pD print full path for
 file
Message-ID: <YLZSgZIcWyYTmqOT@casper.infradead.org>
References: <20210528113951.6225-1-justin.he@arm.com>
 <20210528113951.6225-3-justin.he@arm.com>
 <YLDpSnV9XBUJq5RU@casper.infradead.org>
 <AM6PR08MB437691E7314C6B774EFED4BDF7229@AM6PR08MB4376.eurprd08.prod.outlook.com>
 <YLEDwFCPcFx+qeul@casper.infradead.org>
 <AM6PR08MB437615DB6A6DEC33223A3138F7229@AM6PR08MB4376.eurprd08.prod.outlook.com>
 <YLEKqGkm8bX6LZfP@casper.infradead.org>
 <AM6PR08MB43764764B52AAC7F05B71056F73E9@AM6PR08MB4376.eurprd08.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM6PR08MB43764764B52AAC7F05B71056F73E9@AM6PR08MB4376.eurprd08.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

somehow the linux-fsdevel mailing list got dropped from this revision
of the patch set.  anyone who's following along may wish to refer to
the archives:
https://lore.kernel.org/linux-doc/20210528113951.6225-1-justin.he@arm.com/

On Tue, Jun 01, 2021 at 02:42:15PM +0000, Justin He wrote:
> > On Fri, May 28, 2021 at 03:09:28PM +0000, Justin He wrote:
> > > > I'm not sure why it's so complicated.  p->len records how many bytes
> > > > are needed for the entire path; can't you just return -p->len ?
> > >
> > > prepend_name() will return at the beginning if p->len is <0 in this case,
> > > we can't even get the correct full path size if keep __prepend_path
> > unchanged.
> > > We need another new helper __prepend_path_size() to get the full path
> > size
> > > regardless of the negative value p->len.
> >
> > It's a little hard to follow, based on just the patches.  Is there a
> > git tree somewhere of Al's patches that you're based on?
> >
> > Seems to me that prepend_name() is just fine because it updates p->len
> > before returning false:
> >
> >  static bool prepend_name(struct prepend_buffer *p, const struct qstr
> > *name)
> >  {
> >       const char *dname = smp_load_acquire(&name->name); /* ^^^ */
> >       u32 dlen = READ_ONCE(name->len);
> >       char *s;
> >
> >       p->len -= dlen + 1;
> >       if (unlikely(p->len < 0))
> >               return false;
> >
> > I think the only change you'd need to make for vsnprintf() is in
> > prepend_path():
> >
> > -             if (!prepend_name(&b, &dentry->d_name))
> > -                     break;
> > +             prepend_name(&b, &dentry->d_name);
> >
> > Would that hurt anything else?
> >
> 
> It almost works except the snprintf case,
> Consider,assuming filp path is 256 bytes, 2 dentries "/root/$long_string":
> snprintf(buffer, 128, "%pD", filp);
> p->len is positive at first, but negative after prepend_name loop.
> So, it will not fill any bytes in _buffer_.
> But in theory, it should fill the beginning 127 bytes and '\0'.

I have a few thoughts ...

1. Do we actually depend on that anywhere?
2. Is that something we should support?
3. We could print the start of the filename, if we do.  So something like
this ...

static void prepend(struct prepend_buffer *p, const char *str, int namelen)
{
	p->len -= namelen;
	if (likely(p->len >= 0)) {
		p->buf -= namelen;
		memcpy(p->buf, str, namelen);
	} else {
		char *s = p->buf;
		int buflen = strlen(p->buf);

		/* The first time we overflow the buffer */
		if (p->len + namelen > 0) {
			p->buf -= p->len + namelen;
			buflen += p->len + namelen;
		}

		if (buflen > namelen) {
			memmove(p->buf + namelen, s, buflen - namelen);
			memcpy(p->buf, str, namelen);
		} else {
			memcpy(p->buf, str, buflen);
		}
	}
}

I haven't tested this; it's probably full of confusion and off-by-one
errors.  But I hope you get the point -- we continue to accumulate
p->len to indicate how many characters we shifted off the right of the
buffer while adding the (start of) the filename on the left.

4. If we want the end of the filename instead, that looks easier:

static void prepend(struct prepend_buffer *p, const char *str, int namelen)
{
	p->len -= namelen;
	if (likely(p->len >= 0)) {
		p->buf -= namelen;
		memcpy(p->buf, str, namelen);
	} else if (p->len + namelen > 0) {
		p->buf -= p->len + namelen;
		memcpy(p->buf, str - p->len, p->len + namelen)
	}
}

But I don't think we want any of this at all.  Just don't put anything
in the buffer if the user didn't supply enough space.  As long as you
get the return value right, they know the string is bad (or they don't
care if the string is bad)
