Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D55251303CB
	for <lists+netdev@lfdr.de>; Sat,  4 Jan 2020 18:46:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726180AbgADRqO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Jan 2020 12:46:14 -0500
Received: from mail-ed1-f68.google.com ([209.85.208.68]:34957 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726061AbgADRqO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Jan 2020 12:46:14 -0500
Received: by mail-ed1-f68.google.com with SMTP id f8so619585edv.2
        for <netdev@vger.kernel.org>; Sat, 04 Jan 2020 09:46:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=herbertland-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=9WULxARaEjXJ7xsi0lYnK68WF3k00jzoQrt8ozz9ahk=;
        b=tIuHgNL2X7Xtef2xtQM+JK9MJ2YUNXiCW7wwspKrer+IsplQz3vpJdT1dOlxmGIxM7
         gvWMpZDETMcnfqQuansDy6JUn84L7rRQkFwjUTvz7gX7diV2wcgPNKhPXg1H4baTa9Wj
         Z2Kf9JgOz9vPEIr0ZFBRja+xR2tIxm1ch1RSJhZe4zLaniKEhnuADeTy5eOpDL9ADkuo
         nu+Jc12fkH2vWr9zci54C8l1yWPmLnLc0iPNslcalWRWfS/meAirkuKGDrrFAWtVHFl+
         kXclt1Act54/PoIGiURrHm+z4loDIhfdZk3DbFfFEWgn+U9fKnezZAKKUv+Ww+qEr6l6
         jBFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=9WULxARaEjXJ7xsi0lYnK68WF3k00jzoQrt8ozz9ahk=;
        b=Y1rfVjM+HkyXyRiPJcpAVpUfCVLxjXmpDWyu1Vh5AA8LceuIOS+hH/5Zzg5jIkcAyl
         Wit911fkgenJa4Ji9rubYq13y2snIBVfvQIXFlaon8JqSch+jncuuh5ek32AqdmH/jyu
         JXk5Z3uSsAjIfvxpxa6hT8mwD7r4C4rruuomAA3sp95CAY6+IsQirLn6/2ByRI866buI
         vN4im8BdCCnbRMan2HlGvmky36+gTjIuyhtYKwAZPv5PUWaw8Ifh2lW+AyOGr7st9gjE
         E32NIrjf77sFLasMilLRZJF1ITGj2vfNs8Ea98hjB+O/b2WKSE8oyrM4d7btJNFdzed3
         DrIg==
X-Gm-Message-State: APjAAAUafsIPvCp8Pv4rmAHiwHzvyJ6WhqhkjX5JMV6uRKh9sCuPnvAe
        ycpyv9CvWF709QrBvESE7gz+kwh01eqbFqjNyDx6AQ==
X-Google-Smtp-Source: APXvYqzameuLR2huNWucjMjEinUys8ksdE+TU5Kq5d0FPUkfVRdLHYh+e5+7yydheFe0a0q0OOEjsBh0sKuJj6ZHdiE=
X-Received: by 2002:a50:fb13:: with SMTP id d19mr98767578edq.87.1578159971674;
 Sat, 04 Jan 2020 09:46:11 -0800 (PST)
MIME-Version: 1.0
References: <CALx6S361vkhp8rLzP804oMz2reuDgQDjm9G_+eXfq5oQpVscyg@mail.gmail.com>
 <20200103.124517.1721098411789807467.davem@davemloft.net> <CALx6S34vyjNnVbYfjqB1mNDDr3-zQixzXk=kgDqjJ0yxHVCgKg@mail.gmail.com>
 <20200103.145739.1949735492303739713.davem@davemloft.net> <CALx6S359YAzpJgzOFbb7c6VPe9Sin0F0Vn_vR+8iOo4rY57xQA@mail.gmail.com>
 <CAAedzxpG77vB3Z8XsTmCYPRB2Hn43otPMXZW4t0r3E-Wh98kNQ@mail.gmail.com>
 <CALx6S37eaWwst7H3ZsuOrPkhoes4dkVLHfi60WFv9hXPJo0KPw@mail.gmail.com> <20200104100556.43a28151003a1f379daec40c@gmail.com>
In-Reply-To: <20200104100556.43a28151003a1f379daec40c@gmail.com>
From:   Tom Herbert <tom@herbertland.com>
Date:   Sat, 4 Jan 2020 09:45:59 -0800
Message-ID: <CALx6S341Uad+31k9sGsRWTHyHmNgJWdN0s87c_KUfk=_-4SAjw@mail.gmail.com>
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

On Sat, Jan 4, 2020 at 12:05 AM kernel Dev <ahabdels.dev@gmail.com> wrote:
>
> Tom,
>
> I will not go into whether Tom or router vendors is right from IETF persp=
ective as here is not the place to discuss.
>
> But it seems to me that the motivation behind these patches is just to pu=
shback on the current IETF proposals.
>
Sorry, but that is completely untrue. The patches are a general
improvement. The ability to allow modules to register handlers for
options code points has nothing to do with "pushback on the current
IETF protocols". This sort of registration is a mechanism used all
over the place. Similarly, allowing non-priveledged users to send
options is not for any specific protocol-- it is a *general*
mechanism.

> The patches timeline is completely aligned with when IETF threads get int=
o tough discussions (May 2019, August 2019, and now).
>
Yes, discussion about new protocols in IETF tends to correlate with
development and implementation of the protocols. That shouldn't
surprise anyone. SRv6 for instance was highly controversial in IETF
and yet the patches went in.

> I=E2=80=99m not the one to decide, but IMO people should not add stuff to=
 the kernel just to enforce their opinions on other mailers.

I take exception with your insinuation. Seeing as how you might be new
to Linux kernel development I will ignore it. But, in the future, I
strongly suggest you be careful about accusing people about their
motivations based solely on one interaction.

Tom


>
>
> On Fri, 3 Jan 2020 16:37:33 -0800
> Tom Herbert <tom@herbertland.com> wrote:
>
> > On Fri, Jan 3, 2020 at 3:53 PM Erik Kline <ek@loon.com> wrote:
> > >
> > > On Fri, 3 Jan 2020 at 15:49, Tom Herbert <tom@herbertland.com> wrote:
> > > >
> > > > On Fri, Jan 3, 2020 at 2:57 PM David Miller <davem@davemloft.net> w=
rote:
> > > > >
> > > > > From: Tom Herbert <tom@herbertland.com>
> > > > > Date: Fri, 3 Jan 2020 14:31:58 -0800
> > > > >
> > > > > > On Fri, Jan 3, 2020 at 12:45 PM David Miller <davem@davemloft.n=
et> wrote:
> > > > > >>
> > > > > >> From: Tom Herbert <tom@herbertland.com>
> > > > > >> Date: Fri, 3 Jan 2020 09:35:08 -0800
> > > > > >>
> > > > > >> > The real way to combat this provide open implementation that
> > > > > >> > demonstrates the correct use of the protocols and show that'=
s more
> > > > > >> > extensible and secure than these "hacks".
> > > > > >>
> > > > > >> Keep dreaming, this won't stop Cisco from doing whatever it wa=
nts to do.
> > > > > >
> > > > > > See QUIC. See TLS. See TCP fast open. See transport layer encry=
ption.
> > > > > > These are prime examples where we've steered the Internet from =
host
> > > > > > protocols and implementation to successfully obsolete or at lea=
st work
> > > > > > around protocol ossification that was perpetuated by router ven=
dors.
> > > > > > Cisco is not the Internet!
> > > > >
> > > > > Seriously, I wish you luck stopping the SRv6 header insertion stu=
ff.
> > > > >
> > > > Dave,
> > > >
> > > > I agree we can't stop it, but maybe we can steer it to be at least
> > > > palatable. There are valid use cases for extension header insertion=
.
> > > > Ironically, SRv6 header insertion isn't one of them; the proponents
> > > > have failed to offer even a single reason why the alternative of IP=
v6
> > > > encapsulation isn't sufficient (believe me, we've asked _many_ time=
s
> > > > for some justification and only get hand waving!). There are, howev=
er,
> > > > some interesting uses cases like in IOAM where the operator would l=
ike
> > > > to annotate packets as they traverse the network. Encapsulation is
> > > > insufficient if they don't know what the end point would be or they
> > > > don't want the annotation to change the path the packets take (vers=
us
> > > > those that aren't annotated).
> > > >
> > > > The salient problem with extension header insertion is lost of
> > >
> > > And the problems that can be introduced by changing the effective pat=
h MTU...
> > >
> > Eric,
> >
> > Yep, increasing the size of packet in transit potentially wreaks havoc
> > on PMTU discovery, however I personally think that the issue might be
> > overblown. We already have the same problem when tunneling is done in
> > the network since most tunneling implementations and deployments just
> > assume the operator has set large enough MTUs. As long as all the
> > overhead inserted into the packet doesn't reduce the end host PMTU
> > below 1280, PMTU discovery and probably even PTB for a packet with
> > inserted headers still has right effect.
> >
> > > > attribution. It is fundamental in the IP protocol that the contents=
 of
> > > > a packet are attributed to the source host identified by the source
> > > > address. If some intermediate node inserts an extension header that
> > > > subsequently breaks the packet downstream then there is no obvious =
way
> > > > to debug this. If an ICMP message is sent because of the receiving
> > > > data, then receiving host can't do much with it; it's not the sourc=
e
> > > > of the data in error and nothing in the packet tells who the culpri=
t
> > > > is. The Cisco guys have at least conceded one point on SRv6 inserti=
on
> > > > due to pushback on this, their latest draft only does SRv6 insertio=
n
> > > > on packets that have already been encapsulated in IPIP on ingress i=
nto
> > > > the domain. This is intended to at least restrict the modified pack=
ets
> > > > to a controlled domain (I'm note sure if any implementations enforc=
e
> > > > this though). My proposal is to require an "attribution" HBH option
> > > > that would clearly identify inserted data put in a packet by
> > > > middleboxes (draft-herbert-6man-eh-attrib-00). This is a tradeoff t=
o
> > > > allow extension header insertion, but require protocol to give
> > > > attribution and make it at least somewhat robust and manageable.
> > > >
> > > > Tom
> > >
> > > FWIW the SRv6 header insertion stuff is still under discussion in
> > > spring wg (last I knew).  I proposed one option that could be used to
> >
> > It's also under discussion in 6man.
> >
> > > avoid insertion (allow for extra scratch space
> > > https://mailarchive.ietf.org/arch/msg/spring/UhThRTNxbHWNiMGgRi3U0SqL=
aDA),
> > > but nothing has been conclusively resolved last I checked.
> > >
> >
> > I saw your proposal. It's a good idea from POV to be conformant with
> > RFC8200 and avoid the PMTU problems, but the header insertion
> > proponents aren't going to like it at all. First, it means that the
> > source is in control of the insertion policy and host is required to
> > change-- no way they'll buy into that ;-). Secondly, if the scratch
> > space isn't used they'll undoubtedly claim that is unnecessary
> > overhead.
> >
> > Tom
> >
> > > As everyone probably knows, the draft-ietf-* documents are
> > > working-group-adopted documents (though final publication is never
> > > guaranteed).  My current reading of 6man tea leaves is that neither
> > > "ICMP limits" and "MTU option" docs were terribly contentious.
> > > Whether code reorg is important for implementing these I'm not
> > > competent enough to say.
>
>
> --
