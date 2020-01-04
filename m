Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2EA4D13045A
	for <lists+netdev@lfdr.de>; Sat,  4 Jan 2020 21:22:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726207AbgADUWc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Jan 2020 15:22:32 -0500
Received: from mail-ed1-f66.google.com ([209.85.208.66]:38624 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726118AbgADUWb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Jan 2020 15:22:31 -0500
Received: by mail-ed1-f66.google.com with SMTP id i16so44392237edr.5
        for <netdev@vger.kernel.org>; Sat, 04 Jan 2020 12:22:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=herbertland-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Jo/es1bK9TL9ZxtJXz72HZbUQDjbaMXm4JH5pDJSadU=;
        b=0xMqOf3walrxOucfGDHZiJSymLsCOoZkcjLigWHuY6wuoC/bfa3E8vObf6P/WxP3RU
         U5TZyHj9QFz7OMSWJZT67QrPaHcGutgdnjSigIFTYNPJ3RMZ+oBaWcPyJe1rF3l9GSeR
         bARu5KRWu3LTgpljGxbaSQ2HHwbYc74L895G6PKsY3pNAg4T/uDW518jGbesgqco14/C
         MwL/OWahma14J14gmB/eTaKYAPt+gH+TFi2CREe6cC9DZ+tuC2Ll7Ud5VpfUtdsol/CS
         kGA3oTj53zjg2KBh339brKPu6mXwsYPzZEB6SA1iDLzN2H59zu3aj+/MtpWdSQdm5IK5
         +xCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Jo/es1bK9TL9ZxtJXz72HZbUQDjbaMXm4JH5pDJSadU=;
        b=b9/Ojv/B7hoV3vAyOWAxkmSLx3KbBrvwROK5MW0IwU/wrde6jwSospvdAPHH7Sthto
         QTZznE5o6Wg0031NFt/rXatdFtZc7ql8bTvMKyIBOqprS8Uf/MTGYUTJFBD2zHGsZ24h
         1Ojy84LNkuChLPXwUWm1WHRnh4Gw5tWnyLVkt/2TYIpt97gTOxv75fKLCmNXFQQ8Nay2
         ZeiZu/HLwGHqOZJke//COup679+4h5EivYYeyaBW1MeyCpUdfvBfsAvWFuCQzn+g1oZ7
         VtWZFjb38ZZtsrW4IoqY2OBC9Q6/ZkENFOEEpVbMkVl79ZSqwEJgpwrQGoQ/vVUAwZ7+
         GXTg==
X-Gm-Message-State: APjAAAWzIztx61XlA1vkmbiztpUIUtUTFa3UlPGU9Znyyzm1g7LAue0O
        9rgduchYW0HUcSZV3tFfeu80QAdmSUjtXToU4t52BA==
X-Google-Smtp-Source: APXvYqxSIPJkID/Ovtq2y3uaDTnDu4nhHRzqvp7vzFLnUxR6XsZajE934qSv8LDJY2p2L/tibWqIKAYJpMSLnXMrTsU=
X-Received: by 2002:a17:906:2e53:: with SMTP id r19mr99905534eji.306.1578169348714;
 Sat, 04 Jan 2020 12:22:28 -0800 (PST)
MIME-Version: 1.0
References: <CALx6S361vkhp8rLzP804oMz2reuDgQDjm9G_+eXfq5oQpVscyg@mail.gmail.com>
 <20200103.124517.1721098411789807467.davem@davemloft.net> <CALx6S34vyjNnVbYfjqB1mNDDr3-zQixzXk=kgDqjJ0yxHVCgKg@mail.gmail.com>
 <20200103.145739.1949735492303739713.davem@davemloft.net> <CALx6S359YAzpJgzOFbb7c6VPe9Sin0F0Vn_vR+8iOo4rY57xQA@mail.gmail.com>
 <CAAedzxpG77vB3Z8XsTmCYPRB2Hn43otPMXZW4t0r3E-Wh98kNQ@mail.gmail.com>
 <CALx6S37eaWwst7H3ZsuOrPkhoes4dkVLHfi60WFv9hXPJo0KPw@mail.gmail.com>
 <20200104100556.43a28151003a1f379daec40c@gmail.com> <CALx6S341Uad+31k9sGsRWTHyHmNgJWdN0s87c_KUfk=_-4SAjw@mail.gmail.com>
 <20200104210229.30c753f96317b6e0974aefe9@gmail.com>
In-Reply-To: <20200104210229.30c753f96317b6e0974aefe9@gmail.com>
From:   Tom Herbert <tom@herbertland.com>
Date:   Sat, 4 Jan 2020 12:22:17 -0800
Message-ID: <CALx6S34LC+cOmJvfqQVDS7JdAWRAQ7M+cays8VFrmEgXWt4Ggw@mail.gmail.com>
Subject: Re: [PATCH v8 net-next 0/9] ipv6: Extension header infrastructure
To:     kernel Dev <ahabdels.dev@gmail.com>
Cc:     Erik Kline <ek@loon.com>, David Miller <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Simon Horman <simon.horman@netronome.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 4, 2020 at 11:02 AM kernel Dev <ahabdels.dev@gmail.com> wrote:
>
> Hi Tom,
>
> I wasn=E2=80=99t accusing anyone in my message. It is a personal opinion.
> If my message was misunderstood, then please accept my apologies.
>
> Also SRv6 is not highly controversial and this is proven by its adoption =
rate and ecosystem.

It was controversial in the five years it look to get to WGLC, and
thanks to things like extension header insertion it will remain
controversial.

> I have never seen a highly controversial technology that has (in two year=
s) at least 8 public deployments and is supported by 18 publicly known rout=
ing platforms from 8 different vendors. Also has support in the mainline of=
 Linux kernel, FD.io VPP, Wireshark, tcpdump, iptables and nftables.
>

These support only support some subset of the protocol. For instance,
SRv6 TLVs including HMAC TLV are defined in SRH, however only Linux
claims to support them. However, the Linux implementation isn't
protocol conformant: it doesn't support required padding options and
just assumes HMAC is the one and only TLV. Previously, I've posted
patches to fix that based on the generic parser in this patch set.
Those original patches for fixing SRv6 would now be out of date since
it was decided to change the PADN option type in SRv6 to be 5 instead
of 1 thereby breaking compatibility with HBH and Destination Options.
Seeing as how you seem interested in SRv6, it would be nice if you
could look into fixing the SRv6 TLV implementation to be conformant (I
can repost my original patches if that would help).

Thanks,
Tom


> If you are a network operator, would you deply a highly controversial tec=
hnology in your network ?
>
>
> On Sat, 4 Jan 2020 09:45:59 -0800
> Tom Herbert <tom@herbertland.com> wrote:
>
> > On Sat, Jan 4, 2020 at 12:05 AM kernel Dev <ahabdels.dev@gmail.com> wro=
te:
> > >
> > > Tom,
> > >
> > > I will not go into whether Tom or router vendors is right from IETF p=
erspective as here is not the place to discuss.
> > >
> > > But it seems to me that the motivation behind these patches is just t=
o pushback on the current IETF proposals.
> > >
> > Sorry, but that is completely untrue. The patches are a general
> > improvement. The ability to allow modules to register handlers for
> > options code points has nothing to do with "pushback on the current
> > IETF protocols". This sort of registration is a mechanism used all
> > over the place. Similarly, allowing non-priveledged users to send
> > options is not for any specific protocol-- it is a *general*
> > mechanism.
> >
> > > The patches timeline is completely aligned with when IETF threads get=
 into tough discussions (May 2019, August 2019, and now).
> > >
> > Yes, discussion about new protocols in IETF tends to correlate with
> > development and implementation of the protocols. That shouldn't
> > surprise anyone. SRv6 for instance was highly controversial in IETF
> > and yet the patches went in.
> >
> > > I=E2=80=99m not the one to decide, but IMO people should not add stuf=
f to the kernel just to enforce their opinions on other mailers.
> >
> > I take exception with your insinuation. Seeing as how you might be new
> > to Linux kernel development I will ignore it. But, in the future, I
> > strongly suggest you be careful about accusing people about their
> > motivations based solely on one interaction.
> >
> > Tom
> >
> >
> > >
> > >
> > > On Fri, 3 Jan 2020 16:37:33 -0800
> > > Tom Herbert <tom@herbertland.com> wrote:
> > >
> > > > On Fri, Jan 3, 2020 at 3:53 PM Erik Kline <ek@loon.com> wrote:
> > > > >
> > > > > On Fri, 3 Jan 2020 at 15:49, Tom Herbert <tom@herbertland.com> wr=
ote:
> > > > > >
> > > > > > On Fri, Jan 3, 2020 at 2:57 PM David Miller <davem@davemloft.ne=
t> wrote:
> > > > > > >
> > > > > > > From: Tom Herbert <tom@herbertland.com>
> > > > > > > Date: Fri, 3 Jan 2020 14:31:58 -0800
> > > > > > >
> > > > > > > > On Fri, Jan 3, 2020 at 12:45 PM David Miller <davem@davemlo=
ft.net> wrote:
> > > > > > > >>
> > > > > > > >> From: Tom Herbert <tom@herbertland.com>
> > > > > > > >> Date: Fri, 3 Jan 2020 09:35:08 -0800
> > > > > > > >>
> > > > > > > >> > The real way to combat this provide open implementation =
that
> > > > > > > >> > demonstrates the correct use of the protocols and show t=
hat's more
> > > > > > > >> > extensible and secure than these "hacks".
> > > > > > > >>
> > > > > > > >> Keep dreaming, this won't stop Cisco from doing whatever i=
t wants to do.
> > > > > > > >
> > > > > > > > See QUIC. See TLS. See TCP fast open. See transport layer e=
ncryption.
> > > > > > > > These are prime examples where we've steered the Internet f=
rom host
> > > > > > > > protocols and implementation to successfully obsolete or at=
 least work
> > > > > > > > around protocol ossification that was perpetuated by router=
 vendors.
> > > > > > > > Cisco is not the Internet!
> > > > > > >
> > > > > > > Seriously, I wish you luck stopping the SRv6 header insertion=
 stuff.
> > > > > > >
> > > > > > Dave,
> > > > > >
> > > > > > I agree we can't stop it, but maybe we can steer it to be at le=
ast
> > > > > > palatable. There are valid use cases for extension header inser=
tion.
> > > > > > Ironically, SRv6 header insertion isn't one of them; the propon=
ents
> > > > > > have failed to offer even a single reason why the alternative o=
f IPv6
> > > > > > encapsulation isn't sufficient (believe me, we've asked _many_ =
times
> > > > > > for some justification and only get hand waving!). There are, h=
owever,
> > > > > > some interesting uses cases like in IOAM where the operator wou=
ld like
> > > > > > to annotate packets as they traverse the network. Encapsulation=
 is
> > > > > > insufficient if they don't know what the end point would be or =
they
> > > > > > don't want the annotation to change the path the packets take (=
versus
> > > > > > those that aren't annotated).
> > > > > >
> > > > > > The salient problem with extension header insertion is lost of
> > > > >
> > > > > And the problems that can be introduced by changing the effective=
 path MTU...
> > > > >
> > > > Eric,
> > > >
> > > > Yep, increasing the size of packet in transit potentially wreaks ha=
voc
> > > > on PMTU discovery, however I personally think that the issue might =
be
> > > > overblown. We already have the same problem when tunneling is done =
in
> > > > the network since most tunneling implementations and deployments ju=
st
> > > > assume the operator has set large enough MTUs. As long as all the
> > > > overhead inserted into the packet doesn't reduce the end host PMTU
> > > > below 1280, PMTU discovery and probably even PTB for a packet with
> > > > inserted headers still has right effect.
> > > >
> > > > > > attribution. It is fundamental in the IP protocol that the cont=
ents of
> > > > > > a packet are attributed to the source host identified by the so=
urce
> > > > > > address. If some intermediate node inserts an extension header =
that
> > > > > > subsequently breaks the packet downstream then there is no obvi=
ous way
> > > > > > to debug this. If an ICMP message is sent because of the receiv=
ing
> > > > > > data, then receiving host can't do much with it; it's not the s=
ource
> > > > > > of the data in error and nothing in the packet tells who the cu=
lprit
> > > > > > is. The Cisco guys have at least conceded one point on SRv6 ins=
ertion
> > > > > > due to pushback on this, their latest draft only does SRv6 inse=
rtion
> > > > > > on packets that have already been encapsulated in IPIP on ingre=
ss into
> > > > > > the domain. This is intended to at least restrict the modified =
packets
> > > > > > to a controlled domain (I'm note sure if any implementations en=
force
> > > > > > this though). My proposal is to require an "attribution" HBH op=
tion
> > > > > > that would clearly identify inserted data put in a packet by
> > > > > > middleboxes (draft-herbert-6man-eh-attrib-00). This is a tradeo=
ff to
> > > > > > allow extension header insertion, but require protocol to give
> > > > > > attribution and make it at least somewhat robust and manageable=
.
> > > > > >
> > > > > > Tom
> > > > >
> > > > > FWIW the SRv6 header insertion stuff is still under discussion in
> > > > > spring wg (last I knew).  I proposed one option that could be use=
d to
> > > >
> > > > It's also under discussion in 6man.
> > > >
> > > > > avoid insertion (allow for extra scratch space
> > > > > https://mailarchive.ietf.org/arch/msg/spring/UhThRTNxbHWNiMGgRi3U=
0SqLaDA),
> > > > > but nothing has been conclusively resolved last I checked.
> > > > >
> > > >
> > > > I saw your proposal. It's a good idea from POV to be conformant wit=
h
> > > > RFC8200 and avoid the PMTU problems, but the header insertion
> > > > proponents aren't going to like it at all. First, it means that the
> > > > source is in control of the insertion policy and host is required t=
o
> > > > change-- no way they'll buy into that ;-). Secondly, if the scratch
> > > > space isn't used they'll undoubtedly claim that is unnecessary
> > > > overhead.
> > > >
> > > > Tom
> > > >
> > > > > As everyone probably knows, the draft-ietf-* documents are
> > > > > working-group-adopted documents (though final publication is neve=
r
> > > > > guaranteed).  My current reading of 6man tea leaves is that neith=
er
> > > > > "ICMP limits" and "MTU option" docs were terribly contentious.
> > > > > Whether code reorg is important for implementing these I'm not
> > > > > competent enough to say.
> > >
> > >
> > > --
>
>
> --
> kernel Dev <ahabdels.dev@gmail.com>
