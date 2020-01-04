Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BBB21303F2
	for <lists+netdev@lfdr.de>; Sat,  4 Jan 2020 20:02:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726219AbgADTCf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Jan 2020 14:02:35 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:42068 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726118AbgADTCf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Jan 2020 14:02:35 -0500
Received: by mail-wr1-f66.google.com with SMTP id q6so45273260wro.9
        for <netdev@vger.kernel.org>; Sat, 04 Jan 2020 11:02:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=O1CVZqjGq90DiCv3r9KTC9exgp9cO5LkASvAwo4XsmU=;
        b=cAJP0bgM4eeMDlJ925K33yJCfcfxg9BMLErCUMcPD936xcF7yds5/53iyiWpOMkKZ2
         UT5mbFleozF8We6wiBG5cvUw36F1wR5xN7/52zfLF8uGDoGOH9pRVppiIKx2tavu6zJA
         8fygrxDbfm5GVigmD6FiyWA0wKWXWCYgtimeIi2PD0mo7+rheePxO9rnTQZEDwwJCLRu
         skO4i5dxPpjJr9PBujJqyz1OPxfeejO6NcQv4M0ybdzyaFtpcfRQMNNnXmpw3vjpXJdN
         FXwFG1MStaShFj71242Ikqsfsx8l77egpO+gfZyADvLWs83k2CE+S/q6y4mArhHPKkOQ
         K0TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=O1CVZqjGq90DiCv3r9KTC9exgp9cO5LkASvAwo4XsmU=;
        b=JCyRZ+CDIv1txYsdNDGYLAUjYm5WwerjcVukeoZ9GR0gCew5wwz30LSFZR+GruHV7W
         pRKqiVX5O+8/Prkw783EhTu0s/FZZrznTK04Cggg5b2kX0v4JXEcg7J0yxlUofL5cAHk
         8boCGd9vmQNKQoGWKwdSZLcGp663MC+97xkxZi7I2tDorkav1w7ijPpuGnanq+zLIY+i
         IMfdtWTYH/gx/mITpnVOATjkegcOdbW4TQ2mvo9Y0An101M/K4Pv3894rfGNPqrMzj1z
         RX3XgbGzNRrL3j1noQ84G1lkIN+vtr+i3Qv62NIcG5dE5sczHmhl8fmKzYfec8dHr1dD
         zkOw==
X-Gm-Message-State: APjAAAXMUOA+zuN2FBuLDARQUA7CaAIO6G7ZcXTI53dsuvAqJ+sB63E1
        GshXTmSuSE1A0jdFOat2xOw=
X-Google-Smtp-Source: APXvYqySSYFWB5JmHMl6iPIHnqBu7M0310+tDD5JIlLAjhM9fKGy2Mq4630UF0Xu+uvhNeJx88kUFQ==
X-Received: by 2002:adf:f581:: with SMTP id f1mr96582797wro.264.1578164552833;
        Sat, 04 Jan 2020 11:02:32 -0800 (PST)
Received: from ahabdels-m-j3jg.lan (ppp-94-64-192-96.home.otenet.gr. [94.64.192.96])
        by smtp.gmail.com with ESMTPSA id g21sm70457895wrb.48.2020.01.04.11.02.31
        (version=TLS1 cipher=AES128-SHA bits=128/128);
        Sat, 04 Jan 2020 11:02:32 -0800 (PST)
Date:   Sat, 4 Jan 2020 21:02:29 +0200
From:   kernel Dev <ahabdels.dev@gmail.com>
To:     Tom Herbert <tom@herbertland.com>
Cc:     Erik Kline <ek@loon.com>, David Miller <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Simon Horman <simon.horman@netronome.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Subject: Re: [PATCH v8 net-next 0/9] ipv6: Extension header infrastructure
Message-Id: <20200104210229.30c753f96317b6e0974aefe9@gmail.com>
In-Reply-To: <CALx6S341Uad+31k9sGsRWTHyHmNgJWdN0s87c_KUfk=_-4SAjw@mail.gmail.com>
References: <CALx6S361vkhp8rLzP804oMz2reuDgQDjm9G_+eXfq5oQpVscyg@mail.gmail.com>
        <20200103.124517.1721098411789807467.davem@davemloft.net>
        <CALx6S34vyjNnVbYfjqB1mNDDr3-zQixzXk=kgDqjJ0yxHVCgKg@mail.gmail.com>
        <20200103.145739.1949735492303739713.davem@davemloft.net>
        <CALx6S359YAzpJgzOFbb7c6VPe9Sin0F0Vn_vR+8iOo4rY57xQA@mail.gmail.com>
        <CAAedzxpG77vB3Z8XsTmCYPRB2Hn43otPMXZW4t0r3E-Wh98kNQ@mail.gmail.com>
        <CALx6S37eaWwst7H3ZsuOrPkhoes4dkVLHfi60WFv9hXPJo0KPw@mail.gmail.com>
        <20200104100556.43a28151003a1f379daec40c@gmail.com>
        <CALx6S341Uad+31k9sGsRWTHyHmNgJWdN0s87c_KUfk=_-4SAjw@mail.gmail.com>
X-Mailer: Sylpheed 3.4.1 (GTK+ 2.24.21; x86_64-apple-darwin10.8.0)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Tom, 

I wasn’t accusing anyone in my message. It is a personal opinion. 
If my message was misunderstood, then please accept my apologies. 

Also SRv6 is not highly controversial and this is proven by its adoption rate and ecosystem.
I have never seen a highly controversial technology that has (in two years) at least 8 public deployments and is supported by 18 publicly known routing platforms from 8 different vendors. Also has support in the mainline of Linux kernel, FD.io VPP, Wireshark, tcpdump, iptables and nftables.

If you are a network operator, would you deply a highly controversial technology in your network ? 


On Sat, 4 Jan 2020 09:45:59 -0800
Tom Herbert <tom@herbertland.com> wrote:

> On Sat, Jan 4, 2020 at 12:05 AM kernel Dev <ahabdels.dev@gmail.com> wrote:
> >
> > Tom,
> >
> > I will not go into whether Tom or router vendors is right from IETF perspective as here is not the place to discuss.
> >
> > But it seems to me that the motivation behind these patches is just to pushback on the current IETF proposals.
> >
> Sorry, but that is completely untrue. The patches are a general
> improvement. The ability to allow modules to register handlers for
> options code points has nothing to do with "pushback on the current
> IETF protocols". This sort of registration is a mechanism used all
> over the place. Similarly, allowing non-priveledged users to send
> options is not for any specific protocol-- it is a *general*
> mechanism.
> 
> > The patches timeline is completely aligned with when IETF threads get into tough discussions (May 2019, August 2019, and now).
> >
> Yes, discussion about new protocols in IETF tends to correlate with
> development and implementation of the protocols. That shouldn't
> surprise anyone. SRv6 for instance was highly controversial in IETF
> and yet the patches went in.
> 
> > I’m not the one to decide, but IMO people should not add stuff to the kernel just to enforce their opinions on other mailers.
> 
> I take exception with your insinuation. Seeing as how you might be new
> to Linux kernel development I will ignore it. But, in the future, I
> strongly suggest you be careful about accusing people about their
> motivations based solely on one interaction.
> 
> Tom
> 
> 
> >
> >
> > On Fri, 3 Jan 2020 16:37:33 -0800
> > Tom Herbert <tom@herbertland.com> wrote:
> >
> > > On Fri, Jan 3, 2020 at 3:53 PM Erik Kline <ek@loon.com> wrote:
> > > >
> > > > On Fri, 3 Jan 2020 at 15:49, Tom Herbert <tom@herbertland.com> wrote:
> > > > >
> > > > > On Fri, Jan 3, 2020 at 2:57 PM David Miller <davem@davemloft.net> wrote:
> > > > > >
> > > > > > From: Tom Herbert <tom@herbertland.com>
> > > > > > Date: Fri, 3 Jan 2020 14:31:58 -0800
> > > > > >
> > > > > > > On Fri, Jan 3, 2020 at 12:45 PM David Miller <davem@davemloft.net> wrote:
> > > > > > >>
> > > > > > >> From: Tom Herbert <tom@herbertland.com>
> > > > > > >> Date: Fri, 3 Jan 2020 09:35:08 -0800
> > > > > > >>
> > > > > > >> > The real way to combat this provide open implementation that
> > > > > > >> > demonstrates the correct use of the protocols and show that's more
> > > > > > >> > extensible and secure than these "hacks".
> > > > > > >>
> > > > > > >> Keep dreaming, this won't stop Cisco from doing whatever it wants to do.
> > > > > > >
> > > > > > > See QUIC. See TLS. See TCP fast open. See transport layer encryption.
> > > > > > > These are prime examples where we've steered the Internet from host
> > > > > > > protocols and implementation to successfully obsolete or at least work
> > > > > > > around protocol ossification that was perpetuated by router vendors.
> > > > > > > Cisco is not the Internet!
> > > > > >
> > > > > > Seriously, I wish you luck stopping the SRv6 header insertion stuff.
> > > > > >
> > > > > Dave,
> > > > >
> > > > > I agree we can't stop it, but maybe we can steer it to be at least
> > > > > palatable. There are valid use cases for extension header insertion.
> > > > > Ironically, SRv6 header insertion isn't one of them; the proponents
> > > > > have failed to offer even a single reason why the alternative of IPv6
> > > > > encapsulation isn't sufficient (believe me, we've asked _many_ times
> > > > > for some justification and only get hand waving!). There are, however,
> > > > > some interesting uses cases like in IOAM where the operator would like
> > > > > to annotate packets as they traverse the network. Encapsulation is
> > > > > insufficient if they don't know what the end point would be or they
> > > > > don't want the annotation to change the path the packets take (versus
> > > > > those that aren't annotated).
> > > > >
> > > > > The salient problem with extension header insertion is lost of
> > > >
> > > > And the problems that can be introduced by changing the effective path MTU...
> > > >
> > > Eric,
> > >
> > > Yep, increasing the size of packet in transit potentially wreaks havoc
> > > on PMTU discovery, however I personally think that the issue might be
> > > overblown. We already have the same problem when tunneling is done in
> > > the network since most tunneling implementations and deployments just
> > > assume the operator has set large enough MTUs. As long as all the
> > > overhead inserted into the packet doesn't reduce the end host PMTU
> > > below 1280, PMTU discovery and probably even PTB for a packet with
> > > inserted headers still has right effect.
> > >
> > > > > attribution. It is fundamental in the IP protocol that the contents of
> > > > > a packet are attributed to the source host identified by the source
> > > > > address. If some intermediate node inserts an extension header that
> > > > > subsequently breaks the packet downstream then there is no obvious way
> > > > > to debug this. If an ICMP message is sent because of the receiving
> > > > > data, then receiving host can't do much with it; it's not the source
> > > > > of the data in error and nothing in the packet tells who the culprit
> > > > > is. The Cisco guys have at least conceded one point on SRv6 insertion
> > > > > due to pushback on this, their latest draft only does SRv6 insertion
> > > > > on packets that have already been encapsulated in IPIP on ingress into
> > > > > the domain. This is intended to at least restrict the modified packets
> > > > > to a controlled domain (I'm note sure if any implementations enforce
> > > > > this though). My proposal is to require an "attribution" HBH option
> > > > > that would clearly identify inserted data put in a packet by
> > > > > middleboxes (draft-herbert-6man-eh-attrib-00). This is a tradeoff to
> > > > > allow extension header insertion, but require protocol to give
> > > > > attribution and make it at least somewhat robust and manageable.
> > > > >
> > > > > Tom
> > > >
> > > > FWIW the SRv6 header insertion stuff is still under discussion in
> > > > spring wg (last I knew).  I proposed one option that could be used to
> > >
> > > It's also under discussion in 6man.
> > >
> > > > avoid insertion (allow for extra scratch space
> > > > https://mailarchive.ietf.org/arch/msg/spring/UhThRTNxbHWNiMGgRi3U0SqLaDA),
> > > > but nothing has been conclusively resolved last I checked.
> > > >
> > >
> > > I saw your proposal. It's a good idea from POV to be conformant with
> > > RFC8200 and avoid the PMTU problems, but the header insertion
> > > proponents aren't going to like it at all. First, it means that the
> > > source is in control of the insertion policy and host is required to
> > > change-- no way they'll buy into that ;-). Secondly, if the scratch
> > > space isn't used they'll undoubtedly claim that is unnecessary
> > > overhead.
> > >
> > > Tom
> > >
> > > > As everyone probably knows, the draft-ietf-* documents are
> > > > working-group-adopted documents (though final publication is never
> > > > guaranteed).  My current reading of 6man tea leaves is that neither
> > > > "ICMP limits" and "MTU option" docs were terribly contentious.
> > > > Whether code reorg is important for implementing these I'm not
> > > > competent enough to say.
> >
> >
> > --


-- 
kernel Dev <ahabdels.dev@gmail.com>
