Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0052039DB11
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 13:20:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230483AbhFGLW2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 07:22:28 -0400
Received: from new4-smtp.messagingengine.com ([66.111.4.230]:59161 "EHLO
        new4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230215AbhFGLW1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 07:22:27 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 6B89D58070A;
        Mon,  7 Jun 2021 07:20:36 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Mon, 07 Jun 2021 07:20:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=3oCX7TrAVsmjzv5OoyW+OP4QSCu
        VE7NZRspF0CF6xjk=; b=HHS+8buUuKym3nfeN7FWSG1Dk0moaO5kprrASs7T0uD
        /nl9/1p5XKPb7gbbvHREDDgUoFSH52QD9ntUC8hdw1F1YEGGeuPrKmKlJoYUgCjB
        U3Ct8GXlI2tTt6dPMf4ORWZAJIIDREcQYT9xupSnYhJv4/fn84cS7SmWaI7ogQ1g
        n9szgC+S72jlhpnyGjGDEl7ZZTnzY82iyKnDu9bFZP/5NQboqoVZFYEManJVG5De
        SYtBhp58XCWGwtzkk942Ri3vEFJUeoF39lKZuUnm97865PRfBH/UzJXMxqvll4VA
        QqvjJJKhMLuto23ERDg7bUVUlL2pJSdjc2hS41WvDJw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=3oCX7T
        rAVsmjzv5OoyW+OP4QSCuVE7NZRspF0CF6xjk=; b=J9LGohqP/3UcZzJ39CBjCf
        bUBFGsbA4LH70ypDTUhrYruzzex6PivkO/u9Fh5RG5FrIIUkxy5YOWLqx1JLV9OX
        mrfGXNhwIBAP/niWtCvLCy5TwapO4Io9kp82t3HBNUhRQqH1olg/0cYWdy/CDOJ6
        0HBnuCX0zEigiY2sXSVoJD9h079GNbWB5vn7NHmfRqvGWah8+XHwVc4hO2tz0EhG
        hc67XFMiAdIMGtBT2l6iDzS/N694rRk9wigaNhmSY50vGbqxiuruGLnt7rRwgoQj
        eXB+Kbd5kg1x899hztM/J2Ix3Hne+/zUCV+bi09HLJDP8fPcZHk3pMcx1fuH/cFg
        ==
X-ME-Sender: <xms:AgG-YO6XIE6wb0zbugckGlgAg6MDKbc8OocUC6hSbUNKHfiHOjrIkg>
    <xme:AgG-YH6gvkdR9pPtp5kzIEOMLs5xroBEfpjFvl2mDMukH3MS2vreAWPN2Lzdhi-qO
    sBXZvUwT1SNKQ>
X-ME-Received: <xmr:AgG-YNfh4_-hQrnyNDuugR449PX_YSNnG7wbY9vozb_wMWwjCeOpAZ61zOOXR-fuBCLc8eOLUUbJPykddxvzfMsMTTttGXJQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfedtjedgfeelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeeuleeltd
    ehkeeltefhleduuddvhfffuedvffduveegheekgeeiffevheegfeetgfenucffohhmrghi
    nhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:AgG-YLK-BZoNafSfNpOCftqqvK5Tc0JhnFeEjlEVFh9Xw5SwAQLnzQ>
    <xmx:AgG-YCLiISKsreqbh22vdGr0ByiMfzWpRdo5EXkoZRZtAVktA1mKLg>
    <xmx:AgG-YMxw1m2Ckqu8mBL7RDD7I7ikQ7JWqkaQh1vF8OKyOjOpay6o8A>
    <xmx:BAG-YC5BlunxLm-CShEPPrQ2KS0D94mqpB6yenVrDik5NXGdKDpoIA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 7 Jun 2021 07:20:34 -0400 (EDT)
Date:   Mon, 7 Jun 2021 13:20:32 +0200
From:   Greg KH <greg@kroah.com>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     SyzScope <syzscope@gmail.com>,
        syzbot <syzbot+305a91e025a73e4fd6ce@syzkaller.appspotmail.com>,
        davem@davemloft.net, johan.hedberg@gmail.com, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        marcel@holtmann.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com,
        kernel-hardening@lists.openwall.com
Subject: Re: KASAN: use-after-free Read in hci_chan_del
Message-ID: <YL4BAKHPZqH6iPdP@kroah.com>
References: <000000000000adea7f05abeb19cf@google.com>
 <2fb47714-551c-f44b-efe2-c6708749d03f@gmail.com>
 <YL3zGGMRwmD7fNK+@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YL3zGGMRwmD7fNK+@zx2c4.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 07, 2021 at 12:21:12PM +0200, Jason A. Donenfeld wrote:
> Hi SyzScope,
> 
> On Fri, May 28, 2021 at 02:12:01PM -0700, SyzScope wrote:
>  
> > The bug was reported by syzbot first in Aug 2020. Since it remains 
> > unpatched to this date, we have conducted some analysis to determine its 
> > security impact and root causes, which hopefully can help with the 
> > patching decisions.
> > Specifically, we find that even though it is labeled as "UAF read" by 
> > syzbot, it can in fact lead to double free and control flow hijacking as 
> > well. Here is our analysis below (on this kernel version: 
> > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/log/?id=af5043c89a8ef6b6949a245fff355a552eaed240)
> > 
> > ----------------------------- Root cause analysis: 
> > --------------------------
> > The use-after-free bug happened because the object has two different 
> > references. But when it was freed, only one reference was removed, 
> > allowing the other reference to be used incorrectly.
> > [...]
> 
> Thank you very much for your detailed analysis. I think this is very
> valuable work, and I appreciate you doing it. I wanted to jump in to
> this thread here so as not to discourage you, following Greg's hasty
> dismissal. The bad arguments made I've seen have been something like:
> 
> - Who cares about the impact? Bugs are bugs and these should be fixed
>   regardless. Severity ratings are a waste of time.
> - Spend your time writing patches, not writing tools to discover
>   security issues.
> - This doesn't help my interns.
> - "research project" scare quotes.
> 
> I think this entire set of argumentation is entirely bogus, and I really
> hope it doesn't dissuade you from continuing to conduct useful research
> on the kernel.

Ok, I'd like to apologize if that was the attitude that came across
here, as I did not mean it that way.

What I saw here was an anonymous email, saying "here is a whole bunch of
information about a random syzbot report that means you should fix this
sooner!"  When there's a dump this big of "information", but no patch,
that's almost always a bad sign that the information really isn't all
that good, otherwise the author would have just sent a patch to fix it.

We are drowning in syzbot bugs at the moment, with almost no one helping
to fix them.  So much so that the only people I know of working on this
are the interns with with the LF has funded because no other company
seems willing to help out with this task.

That's not the syzbot author's fault, it's the fault of every other
company that relies on Linux at the moment.  By not providing time for
their engineers to fix these found bugs, and only add new features, it's
not going to get any better.

So this combined two things I'm really annoyed at, anonymous
contributions combined with "why are you not fixing this" type of
a report.  Neither of which were, in the end, actually helpful to us.

I'm not asking for any help for my interns, nor am I telling anyone what
to work on.  I am saying please don't annoy the maintainers who are
currently overwhelmed at the moment with additional reports of this type
when they obviously can not handle the ones that we have.

Working with the syzbot people to provide a more indepth analysis of the
problem is wonderful, and will go a long way toward helping being able
to do semi-automatic fixing of problems like this, which would be
wonderful.  But how were we supposed to know this anonymous gmail
account, with a half-completed google pages web site was not just a
troll trying to waste our time?

What proof did we have that this really was a correct report if a real
person didn't even provide their name to it?

thanks,

greg k-h
