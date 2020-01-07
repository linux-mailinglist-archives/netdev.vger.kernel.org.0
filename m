Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C648B1328DF
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 15:28:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728323AbgAGO17 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 09:27:59 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:56051 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728307AbgAGO16 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 09:27:58 -0500
Received: by mail-wm1-f65.google.com with SMTP id q9so19172927wmj.5
        for <netdev@vger.kernel.org>; Tue, 07 Jan 2020 06:27:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8ll6pfs0Lc5//nYvpISCuHiKbMMPSEB1tli1fUPNlSg=;
        b=C2Zgb0gk53QFakA+hm0alU0B6aizD6IyrrLToQCUKL+u/c1IoZRtViOlYhgNyl7jVA
         A7akQeSwCuMi8Sd2PaBUGpdcA9pSb+bsD7bIYvGaE/DOIAzbC0FNcLcEmDhHcMg1BSwZ
         wMtfV83Gyw/4c6wKowXV7H+ifSJDaE4+fr1IKCrF6ONREPFBcslrEZq7YzdL98jqAX2X
         lw4ktk3VmjADXFOIgfFctELEJbGfBS5YXqB5wy20iWgN1Nv6FM2Dz0KnB8unJU46J9gL
         8E/7uCGlWyN5aHNS4Mw8+mlbQBGDuqWJ0GKID59uYPayOsrrBRCKILFBJZYVYapZbHlS
         X4iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8ll6pfs0Lc5//nYvpISCuHiKbMMPSEB1tli1fUPNlSg=;
        b=Ab1VE+cvfVI/s+oFgVXyFXYtLx0RD+fiWvCIINiwZjvxi7yTxyvHiwKwfIO6Ap7Rnh
         WU03hkmDgIULlUvqBa6rsmTCnPzaP5e/+IoUpA75Kj8dK+zKHFDF6dbUiiF8e6VKGhAS
         M9zao/g6gfX9E+t3tv2LLAS0800t+EW4cf64M+YfvN1wiAcf57fgvIxArHbWHLw3+zJ7
         hvzBDj4TRQkCusoaO9+Cw6Nr6QY2T+60HvJL93v6jPZTHBux6GYFvOa9V1NoVaushi+/
         gtSTOor06M5VpUgcEnoh6hQIOqLyY9S6N883Rs1eHDjNy03cTZF2b0+QAnvkbVUmPVjg
         FTNg==
X-Gm-Message-State: APjAAAUV+qP3i9ot5noXPgrF6KRoCDWHMNBwgXORjpNIGJsY1xXGehVT
        Kop08yIFw/OYREPfbg1TUcM=
X-Google-Smtp-Source: APXvYqzG+rEUWpb/IQfJrvw4PvjZD0C4vtygtpGzb1hMkVOVDvbL4HflHIIRbBxu8UHors3mO2lebA==
X-Received: by 2002:a1c:dc08:: with SMTP id t8mr42127219wmg.139.1578407275698;
        Tue, 07 Jan 2020 06:27:55 -0800 (PST)
Received: from AHABDELS-M-J3JG ([192.135.27.141])
        by smtp.gmail.com with ESMTPSA id z83sm27294079wmg.2.2020.01.07.06.27.54
        (version=TLS1 cipher=AES128-SHA bits=128/128);
        Tue, 07 Jan 2020 06:27:55 -0800 (PST)
Date:   Tue, 7 Jan 2020 15:27:54 +0100
From:   kernel Dev <ahabdels.dev@gmail.com>
To:     Tom Herbert <tom@herbertland.com>
Cc:     Erik Kline <ek@loon.com>, David Miller <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Simon Horman <simon.horman@netronome.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Subject: Re: [PATCH v8 net-next 0/9] ipv6: Extension header infrastructure
Message-Id: <20200107152754.eb96a3c6424422fffb694c86@gmail.com>
In-Reply-To: <CALx6S34LC+cOmJvfqQVDS7JdAWRAQ7M+cays8VFrmEgXWt4Ggw@mail.gmail.com>
References: <CALx6S361vkhp8rLzP804oMz2reuDgQDjm9G_+eXfq5oQpVscyg@mail.gmail.com>
        <20200103.124517.1721098411789807467.davem@davemloft.net>
        <CALx6S34vyjNnVbYfjqB1mNDDr3-zQixzXk=kgDqjJ0yxHVCgKg@mail.gmail.com>
        <20200103.145739.1949735492303739713.davem@davemloft.net>
        <CALx6S359YAzpJgzOFbb7c6VPe9Sin0F0Vn_vR+8iOo4rY57xQA@mail.gmail.com>
        <CAAedzxpG77vB3Z8XsTmCYPRB2Hn43otPMXZW4t0r3E-Wh98kNQ@mail.gmail.com>
        <CALx6S37eaWwst7H3ZsuOrPkhoes4dkVLHfi60WFv9hXPJo0KPw@mail.gmail.com>
        <20200104100556.43a28151003a1f379daec40c@gmail.com>
        <CALx6S341Uad+31k9sGsRWTHyHmNgJWdN0s87c_KUfk=_-4SAjw@mail.gmail.com>
        <20200104210229.30c753f96317b6e0974aefe9@gmail.com>
        <CALx6S34LC+cOmJvfqQVDS7JdAWRAQ7M+cays8VFrmEgXWt4Ggw@mail.gmail.com>
X-Mailer: Sylpheed 3.4.1 (GTK+ 2.24.21; x86_64-apple-darwin10.8.0)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 4 Jan 2020 12:22:17 -0800
Tom Herbert <tom@herbertland.com> wrote:

> On Sat, Jan 4, 2020 at 11:02 AM kernel Dev <ahabdels.dev@gmail.com> wrote:
> >
> > Hi Tom,
> >
> > I wasn’t accusing anyone in my message. It is a personal opinion.
> > If my message was misunderstood, then please accept my apologies.
> >
> > Also SRv6 is not highly controversial and this is proven by its adoption rate and ecosystem.
> 
> It was controversial in the five years it look to get to WGLC, and
> thanks to things like extension header insertion it will remain
> controversial.

But it is not anymore :) 

> 
> > I have never seen a highly controversial technology that has (in two years) at least 8 public deployments and is supported by 18 publicly known routing platforms from 8 different vendors. Also has support in the mainline of Linux kernel, FD.io VPP, Wireshark, tcpdump, iptables and nftables.
> >
> 
> These support only support some subset of the protocol. For instance,
> SRv6 TLVs including HMAC TLV are defined in SRH, however only Linux
> claims to support them. However, the Linux implementation isn't
> protocol conformant: it doesn't support required padding options and
> just assumes HMAC is the one and only TLV. Previously, I've posted
> patches to fix that based on the generic parser in this patch set.
> Those original patches for fixing SRv6 would now be out of date since
> it was decided to change the PADN option type in SRv6 to be 5 instead
> of 1 thereby breaking compatibility with HBH and Destination Options.
> Seeing as how you seem interested in SRv6, it would be nice if you
> could look into fixing the SRv6 TLV implementation to be conformant (I
> can repost my original patches if that would help).

I’m ok and willing to contribute to add missing pieces of SRv6 to the Linux kernel. 

I was just not convinced with the idea of IPv4 extensions headers as we do not need to reinvent the wheel. 

We need IPv6 as we ran out of IPv4, and I believe SRv6 can handle most of IPv6 use-cases. 

> 
> Thanks,
> Tom
> 
> 
> > If you are a network operator, would you deply a highly controversial technology in your network ?
> >
> >
> > On Sat, 4 Jan 2020 09:45:59 -0800
> > Tom Herbert <tom@herbertland.com> wrote:
> >
> > > On Sat, Jan 4, 2020 at 12:05 AM kernel Dev <ahabdels.dev@gmail.com> wrote:
> > > >
> > > > Tom,
> > > >
> > > > I will not go into whether Tom or router vendors is right from IETF perspective as here is not the place to discuss.
> > > >
> > > > But it seems to me that the motivation behind these patches is just to pushback on the current IETF proposals.
> > > >
> > > Sorry, but that is completely untrue. The patches are a general
> > > improvement. The ability to allow modules to register handlers for
> > > options code points has nothing to do with "pushback on the current
> > > IETF protocols". This sort of registration is a mechanism used all
> > > over the place. Similarly, allowing non-priveledged users to send
> > > options is not for any specific protocol-- it is a *general*
> > > mechanism.
> > >
> > > > The patches timeline is completely aligned with when IETF threads get into tough discussions (May 2019, August 2019, and now).
> > > >
> > > Yes, discussion about new protocols in IETF tends to correlate with
> > > development and implementation of the protocols. That shouldn't
> > > surprise anyone. SRv6 for instance was highly controversial in IETF
> > > and yet the patches went in.
> > >
> > > > I’m not the one to decide, but IMO people should not add stuff to the kernel just to enforce their opinions on other mailers.
> > >
> > > I take exception with your insinuation. Seeing as how you might be new
> > > to Linux kernel development I will ignore it. But, in the future, I
> > > strongly suggest you be careful about accusing people about their
> > > motivations based solely on one interaction.
> > >
> > > Tom
> > >
> > >
> > > >
> > > >
> > > > On Fri, 3 Jan 2020 16:37:33 -0800
> > > > Tom Herbert <tom@herbertland.com> wrote:
> > > >
> > > > > On Fri, Jan 3, 2020 at 3:53 PM Erik Kline <ek@loon.com> wrote:
> > > > > >
> > > > > > On Fri, 3 Jan 2020 at 15:49, Tom Herbert <tom@herbertland.com> wrote:
> > > > > > >
> > > > > > > On Fri, Jan 3, 2020 at 2:57 PM David Miller <davem@davemloft.net> wrote:
> > > > > > > >
> > > > > > > > From: Tom Herbert <tom@herbertland.com>
> > > > > > > > Date: Fri, 3 Jan 2020 14:31:58 -0800
> > > > > > > >
> > > > > > > > > On Fri, Jan 3, 2020 at 12:45 PM David Miller <davem@davemloft.net> wrote:
> > > > > > > > >>
> > > > > > > > >> From: Tom Herbert <tom@herbertland.com>
> > > > > > > > >> Date: Fri, 3 Jan 2020 09:35:08 -0800
> > > > > > > > >>
> > > > > > > > >> > The real way to combat this provide open implementation that
> > > > > > > > >> > demonstrates the correct use of the protocols and show that's more
> > > > > > > > >> > extensible and secure than these "hacks".
> > > > > > > > >>
> > > > > > > > >> Keep dreaming, this won't stop Cisco from doing whatever it wants to do.
> > > > > > > > >
> > > > > > > > > See QUIC. See TLS. See TCP fast open. See transport layer encryption.
> > > > > > > > > These are prime examples where we've steered the Internet from host
> > > > > > > > > protocols and implementation to successfully obsolete or at least work
> > > > > > > > > around protocol ossification that was perpetuated by router vendors.
> > > > > > > > > Cisco is not the Internet!
> > > > > > > >
> > > > > > > > Seriously, I wish you luck stopping the SRv6 header insertion stuff.
> > > > > > > >
> > > > > > > Dave,
> > > > > > >
> > > > > > > I agree we can't stop it, but maybe we can steer it to be at least
> > > > > > > palatable. There are valid use cases for extension header insertion.
> > > > > > > Ironically, SRv6 header insertion isn't one of them; the proponents
> > > > > > > have failed to offer even a single reason why the alternative of IPv6
> > > > > > > encapsulation isn't sufficient (believe me, we've asked _many_ times
> > > > > > > for some justification and only get hand waving!). There are, however,
> > > > > > > some interesting uses cases like in IOAM where the operator would like
> > > > > > > to annotate packets as they traverse the network. Encapsulation is
> > > > > > > insufficient if they don't know what the end point would be or they
> > > > > > > don't want the annotation to change the path the packets take (versus
> > > > > > > those that aren't annotated).
> > > > > > >
> > > > > > > The salient problem with extension header insertion is lost of
> > > > > >
> > > > > > And the problems that can be introduced by changing the effective path MTU...
> > > > > >
> > > > > Eric,
> > > > >
> > > > > Yep, increasing the size of packet in transit potentially wreaks havoc
> > > > > on PMTU discovery, however I personally think that the issue might be
> > > > > overblown. We already have the same problem when tunneling is done in
> > > > > the network since most tunneling implementations and deployments just
> > > > > assume the operator has set large enough MTUs. As long as all the
> > > > > overhead inserted into the packet doesn't reduce the end host PMTU
> > > > > below 1280, PMTU discovery and probably even PTB for a packet with
> > > > > inserted headers still has right effect.
> > > > >
> > > > > > > attribution. It is fundamental in the IP protocol that the contents of
> > > > > > > a packet are attributed to the source host identified by the source
> > > > > > > address. If some intermediate node inserts an extension header that
> > > > > > > subsequently breaks the packet downstream then there is no obvious way
> > > > > > > to debug this. If an ICMP message is sent because of the receiving
> > > > > > > data, then receiving host can't do much with it; it's not the source
> > > > > > > of the data in error and nothing in the packet tells who the culprit
> > > > > > > is. The Cisco guys have at least conceded one point on SRv6 insertion
> > > > > > > due to pushback on this, their latest draft only does SRv6 insertion
> > > > > > > on packets that have already been encapsulated in IPIP on ingress into
> > > > > > > the domain. This is intended to at least restrict the modified packets
> > > > > > > to a controlled domain (I'm note sure if any implementations enforce
> > > > > > > this though). My proposal is to require an "attribution" HBH option
> > > > > > > that would clearly identify inserted data put in a packet by
> > > > > > > middleboxes (draft-herbert-6man-eh-attrib-00). This is a tradeoff to
> > > > > > > allow extension header insertion, but require protocol to give
> > > > > > > attribution and make it at least somewhat robust and manageable.
> > > > > > >
> > > > > > > Tom
> > > > > >
> > > > > > FWIW the SRv6 header insertion stuff is still under discussion in
> > > > > > spring wg (last I knew).  I proposed one option that could be used to
> > > > >
> > > > > It's also under discussion in 6man.
> > > > >
> > > > > > avoid insertion (allow for extra scratch space
> > > > > > https://mailarchive.ietf.org/arch/msg/spring/UhThRTNxbHWNiMGgRi3U0SqLaDA),
> > > > > > but nothing has been conclusively resolved last I checked.
> > > > > >
> > > > >
> > > > > I saw your proposal. It's a good idea from POV to be conformant with
> > > > > RFC8200 and avoid the PMTU problems, but the header insertion
> > > > > proponents aren't going to like it at all. First, it means that the
> > > > > source is in control of the insertion policy and host is required to
> > > > > change-- no way they'll buy into that ;-). Secondly, if the scratch
> > > > > space isn't used they'll undoubtedly claim that is unnecessary
> > > > > overhead.
> > > > >
> > > > > Tom
> > > > >
> > > > > > As everyone probably knows, the draft-ietf-* documents are
> > > > > > working-group-adopted documents (though final publication is never
> > > > > > guaranteed).  My current reading of 6man tea leaves is that neither
> > > > > > "ICMP limits" and "MTU option" docs were terribly contentious.
> > > > > > Whether code reorg is important for implementing these I'm not
> > > > > > competent enough to say.
> > > >
> > > >
> > > > --
> >
> >
> > --
> > kernel Dev <ahabdels.dev@gmail.com>


-- 
kernel Dev <ahabdels.dev@gmail.com>
