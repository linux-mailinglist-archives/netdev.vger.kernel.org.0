Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D41C313015A
	for <lists+netdev@lfdr.de>; Sat,  4 Jan 2020 09:14:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726036AbgADIGB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Jan 2020 03:06:01 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:43531 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725870AbgADIGB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Jan 2020 03:06:01 -0500
Received: by mail-wr1-f67.google.com with SMTP id d16so44377260wre.10
        for <netdev@vger.kernel.org>; Sat, 04 Jan 2020 00:05:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hIcQtQZI5h8Lnl7+D1+XH1RDltc+skEk5Q/sEE7UuA4=;
        b=NufvtSd6xb1VFnMcq4fvYEHj6gXtd2TSRLtE2mZlaO9VIJc5ehmMWEYrGsbyi5//ZU
         2G0QzDslTmQLz+g5M1PaqD0anqWWWDBp5EU6ZNbhrOxJCKK+OvzfLWmHTQ1fWGc+glZ5
         yv7ORlt/j8fqNivEE5BAYt7g6M1UiiqLzNz33Z8WOyk5LMdbbXcNVyo9HiGjpZ6J/FgM
         vQV3aKHaC3mvynhF9QDgbCvc2QNSIFTfgej30B0RPEQ5cMadWK2fOB478cB/Vjf7bnmO
         ETdO3VNto5w8210kH4n+onZ6fW1DqvlJJBZA9CW2fv3+JptkF4qGPLtclvrYcqNv2NLQ
         MvGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hIcQtQZI5h8Lnl7+D1+XH1RDltc+skEk5Q/sEE7UuA4=;
        b=nmE8jzn7Mc6k/Qv4UIAiPpvYhXv3gMKhwkoITXQp7xh2kQGri2yQozIUisrkfWi/Yh
         IReJsyIqpABGEs8k07m2+agQt8+tpDEQM/efnBTp32ltgZo4xzu4fKcfYdT/t6/i3iY6
         3ENoOGNUExL2yonDdgdQJDPVrIfps9gCC/92KJan6WIQNEwDQ4EELwCA61rGfn2Pc5hr
         xpCLkisLT4tQzQjVOs7fDuFcxRTGBxUrGc/or2c683d9zDDotMcqA5so3FXNQsnD9+X6
         rcXrzUZvsBShYf3yKaw7mLmRUdl9wzUCzgENj0gj82am6fKxs82/9zrn4ozXhG4m0gF1
         40CA==
X-Gm-Message-State: APjAAAWpEL3N9eqn27FcHagdyYFv+3mmv4W2lu+/BtGs2L5d7biclhBk
        NRvc6uoLYLDjfyT3+TkkD30=
X-Google-Smtp-Source: APXvYqzTmuRAjXOSD6jXGL+KKA7ydGkXqG9a1Txz5m7CXCjhtNst3+nPeguAp8sDmAGjpk0+OhTJXA==
X-Received: by 2002:adf:f789:: with SMTP id q9mr94405189wrp.103.1578125158289;
        Sat, 04 Jan 2020 00:05:58 -0800 (PST)
Received: from ahabdels-m-j3jg.lan (ppp-94-64-192-96.home.otenet.gr. [94.64.192.96])
        by smtp.gmail.com with ESMTPSA id f16sm63021516wrm.65.2020.01.04.00.05.56
        (version=TLS1 cipher=AES128-SHA bits=128/128);
        Sat, 04 Jan 2020 00:05:57 -0800 (PST)
Date:   Sat, 4 Jan 2020 10:05:56 +0200
From:   kernel Dev <ahabdels.dev@gmail.com>
To:     Tom Herbert <tom@herbertland.com>
Cc:     ek@loon.com, David Miller <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Simon Horman <simon.horman@netronome.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Subject: Re: [PATCH v8 net-next 0/9] ipv6: Extension header infrastructure
Message-Id: <20200104100556.43a28151003a1f379daec40c@gmail.com>
In-Reply-To: <CALx6S37eaWwst7H3ZsuOrPkhoes4dkVLHfi60WFv9hXPJo0KPw@mail.gmail.com>
References: <CALx6S361vkhp8rLzP804oMz2reuDgQDjm9G_+eXfq5oQpVscyg@mail.gmail.com>
        <20200103.124517.1721098411789807467.davem@davemloft.net>
        <CALx6S34vyjNnVbYfjqB1mNDDr3-zQixzXk=kgDqjJ0yxHVCgKg@mail.gmail.com>
        <20200103.145739.1949735492303739713.davem@davemloft.net>
        <CALx6S359YAzpJgzOFbb7c6VPe9Sin0F0Vn_vR+8iOo4rY57xQA@mail.gmail.com>
        <CAAedzxpG77vB3Z8XsTmCYPRB2Hn43otPMXZW4t0r3E-Wh98kNQ@mail.gmail.com>
        <CALx6S37eaWwst7H3ZsuOrPkhoes4dkVLHfi60WFv9hXPJo0KPw@mail.gmail.com>
X-Mailer: Sylpheed 3.4.1 (GTK+ 2.24.21; x86_64-apple-darwin10.8.0)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tom, 

I will not go into whether Tom or router vendors is right from IETF perspective as here is not the place to discuss. 

But it seems to me that the motivation behind these patches is just to pushback on the current IETF proposals. 

The patches timeline is completely aligned with when IETF threads get into tough discussions (May 2019, August 2019, and now). 

I’m not the one to decide, but IMO people should not add stuff to the kernel just to enforce their opinions on other mailers. 

 
On Fri, 3 Jan 2020 16:37:33 -0800
Tom Herbert <tom@herbertland.com> wrote:

> On Fri, Jan 3, 2020 at 3:53 PM Erik Kline <ek@loon.com> wrote:
> >
> > On Fri, 3 Jan 2020 at 15:49, Tom Herbert <tom@herbertland.com> wrote:
> > >
> > > On Fri, Jan 3, 2020 at 2:57 PM David Miller <davem@davemloft.net> wrote:
> > > >
> > > > From: Tom Herbert <tom@herbertland.com>
> > > > Date: Fri, 3 Jan 2020 14:31:58 -0800
> > > >
> > > > > On Fri, Jan 3, 2020 at 12:45 PM David Miller <davem@davemloft.net> wrote:
> > > > >>
> > > > >> From: Tom Herbert <tom@herbertland.com>
> > > > >> Date: Fri, 3 Jan 2020 09:35:08 -0800
> > > > >>
> > > > >> > The real way to combat this provide open implementation that
> > > > >> > demonstrates the correct use of the protocols and show that's more
> > > > >> > extensible and secure than these "hacks".
> > > > >>
> > > > >> Keep dreaming, this won't stop Cisco from doing whatever it wants to do.
> > > > >
> > > > > See QUIC. See TLS. See TCP fast open. See transport layer encryption.
> > > > > These are prime examples where we've steered the Internet from host
> > > > > protocols and implementation to successfully obsolete or at least work
> > > > > around protocol ossification that was perpetuated by router vendors.
> > > > > Cisco is not the Internet!
> > > >
> > > > Seriously, I wish you luck stopping the SRv6 header insertion stuff.
> > > >
> > > Dave,
> > >
> > > I agree we can't stop it, but maybe we can steer it to be at least
> > > palatable. There are valid use cases for extension header insertion.
> > > Ironically, SRv6 header insertion isn't one of them; the proponents
> > > have failed to offer even a single reason why the alternative of IPv6
> > > encapsulation isn't sufficient (believe me, we've asked _many_ times
> > > for some justification and only get hand waving!). There are, however,
> > > some interesting uses cases like in IOAM where the operator would like
> > > to annotate packets as they traverse the network. Encapsulation is
> > > insufficient if they don't know what the end point would be or they
> > > don't want the annotation to change the path the packets take (versus
> > > those that aren't annotated).
> > >
> > > The salient problem with extension header insertion is lost of
> >
> > And the problems that can be introduced by changing the effective path MTU...
> >
> Eric,
> 
> Yep, increasing the size of packet in transit potentially wreaks havoc
> on PMTU discovery, however I personally think that the issue might be
> overblown. We already have the same problem when tunneling is done in
> the network since most tunneling implementations and deployments just
> assume the operator has set large enough MTUs. As long as all the
> overhead inserted into the packet doesn't reduce the end host PMTU
> below 1280, PMTU discovery and probably even PTB for a packet with
> inserted headers still has right effect.
> 
> > > attribution. It is fundamental in the IP protocol that the contents of
> > > a packet are attributed to the source host identified by the source
> > > address. If some intermediate node inserts an extension header that
> > > subsequently breaks the packet downstream then there is no obvious way
> > > to debug this. If an ICMP message is sent because of the receiving
> > > data, then receiving host can't do much with it; it's not the source
> > > of the data in error and nothing in the packet tells who the culprit
> > > is. The Cisco guys have at least conceded one point on SRv6 insertion
> > > due to pushback on this, their latest draft only does SRv6 insertion
> > > on packets that have already been encapsulated in IPIP on ingress into
> > > the domain. This is intended to at least restrict the modified packets
> > > to a controlled domain (I'm note sure if any implementations enforce
> > > this though). My proposal is to require an "attribution" HBH option
> > > that would clearly identify inserted data put in a packet by
> > > middleboxes (draft-herbert-6man-eh-attrib-00). This is a tradeoff to
> > > allow extension header insertion, but require protocol to give
> > > attribution and make it at least somewhat robust and manageable.
> > >
> > > Tom
> >
> > FWIW the SRv6 header insertion stuff is still under discussion in
> > spring wg (last I knew).  I proposed one option that could be used to
> 
> It's also under discussion in 6man.
> 
> > avoid insertion (allow for extra scratch space
> > https://mailarchive.ietf.org/arch/msg/spring/UhThRTNxbHWNiMGgRi3U0SqLaDA),
> > but nothing has been conclusively resolved last I checked.
> >
> 
> I saw your proposal. It's a good idea from POV to be conformant with
> RFC8200 and avoid the PMTU problems, but the header insertion
> proponents aren't going to like it at all. First, it means that the
> source is in control of the insertion policy and host is required to
> change-- no way they'll buy into that ;-). Secondly, if the scratch
> space isn't used they'll undoubtedly claim that is unnecessary
> overhead.
> 
> Tom
> 
> > As everyone probably knows, the draft-ietf-* documents are
> > working-group-adopted documents (though final publication is never
> > guaranteed).  My current reading of 6man tea leaves is that neither
> > "ICMP limits" and "MTU option" docs were terribly contentious.
> > Whether code reorg is important for implementing these I'm not
> > competent enough to say.


-- 
