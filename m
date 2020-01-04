Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38E0A12FFB4
	for <lists+netdev@lfdr.de>; Sat,  4 Jan 2020 01:37:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727267AbgADAhr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jan 2020 19:37:47 -0500
Received: from mail-ed1-f66.google.com ([209.85.208.66]:35576 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726703AbgADAhq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jan 2020 19:37:46 -0500
Received: by mail-ed1-f66.google.com with SMTP id f8so43035235edv.2
        for <netdev@vger.kernel.org>; Fri, 03 Jan 2020 16:37:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=herbertland-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yRUOj7sg3b/KJCWYRhxgi1gUv/c629gnWM6Oy4naWL0=;
        b=qJt1yPGOJiHShGJbVqOA3WOSJVJ8fVnMjIzPoj1j+1RdI8xZh/fcJs7b1jsv+/bimM
         HOGIDaX1zdQ4HdjVa4rfN8T/PWgNtch9p3AKoRi6Lkqwr/bkc6qbHjvJc2e4EpI5bKgp
         WSNEZXoEvPiuw0FHH6I15HvovTnG7ptP1gJVTFFCjVzfW5+885O0O0lhwb+hgQPOzZnS
         /+CkrmfvUIYXrRhNabN+YtHxtLPvBnB4eBwO7emGkF5QbtLDszkRTak1q+V5dwAnnw4x
         p2scM25YHTBGbTxqEdIDAokLi8lCMHApcvLeURwWQHQopIMLPyaRQ02ICEgI+ABcSF4+
         f7kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yRUOj7sg3b/KJCWYRhxgi1gUv/c629gnWM6Oy4naWL0=;
        b=fUY3jPirWDqb4CnH1eXw3mv4v5KKfou3O2hkf4Eyd+oMwv0NBIWC0D+0AFzDd4rMtN
         BKfVMT55bu7xP2/PcYhifXJuceTsmyW7lbsdfrTSyjoY4Y666qCvdDI2Mge7vKheknSd
         17Vj67iT9JwWqzfAXW6K7RiBzQ+5m2ylZ4hI+yX0atscOu9k4/PhaNJvZUBgMPnOP6tX
         1hASmSWz+NEEbz7A6kGGlIHcHhfj+Redo/vsCxmL3jlYlLwzo5MyIgQHuAUqsTcdCunD
         AuvMDaAW7Tt5T5aP0wank/uzkS68rIPEXQDjVTKIHNzXzBjzu2FiSdaL++kiAoeJ+HfX
         p59g==
X-Gm-Message-State: APjAAAX5MvWnVtJgJc1S3Euv5yuTZVsLYYe1lECpPFYy0/AWCC5+nM7N
        Ui3d3WSHfe4HdYtL3vV2gaGBrPw94kVzfDoAqfWWoA==
X-Google-Smtp-Source: APXvYqzMT/PQiNBDN5sAAVC+FpmQCrhcbpTLCTITKtWQbIMReP8jgfMywe7BmnH0e1C9lh2Siw/MtTJlmrriq9XKssM=
X-Received: by 2002:aa7:db04:: with SMTP id t4mr95260452eds.122.1578098264306;
 Fri, 03 Jan 2020 16:37:44 -0800 (PST)
MIME-Version: 1.0
References: <CALx6S361vkhp8rLzP804oMz2reuDgQDjm9G_+eXfq5oQpVscyg@mail.gmail.com>
 <20200103.124517.1721098411789807467.davem@davemloft.net> <CALx6S34vyjNnVbYfjqB1mNDDr3-zQixzXk=kgDqjJ0yxHVCgKg@mail.gmail.com>
 <20200103.145739.1949735492303739713.davem@davemloft.net> <CALx6S359YAzpJgzOFbb7c6VPe9Sin0F0Vn_vR+8iOo4rY57xQA@mail.gmail.com>
 <CAAedzxpG77vB3Z8XsTmCYPRB2Hn43otPMXZW4t0r3E-Wh98kNQ@mail.gmail.com>
In-Reply-To: <CAAedzxpG77vB3Z8XsTmCYPRB2Hn43otPMXZW4t0r3E-Wh98kNQ@mail.gmail.com>
From:   Tom Herbert <tom@herbertland.com>
Date:   Fri, 3 Jan 2020 16:37:33 -0800
Message-ID: <CALx6S37eaWwst7H3ZsuOrPkhoes4dkVLHfi60WFv9hXPJo0KPw@mail.gmail.com>
Subject: Re: [PATCH v8 net-next 0/9] ipv6: Extension header infrastructure
To:     ek@loon.com
Cc:     David Miller <davem@davemloft.net>,
        Ahmed Abdelsalam <ahabdels.dev@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Simon Horman <simon.horman@netronome.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 3, 2020 at 3:53 PM Erik Kline <ek@loon.com> wrote:
>
> On Fri, 3 Jan 2020 at 15:49, Tom Herbert <tom@herbertland.com> wrote:
> >
> > On Fri, Jan 3, 2020 at 2:57 PM David Miller <davem@davemloft.net> wrote:
> > >
> > > From: Tom Herbert <tom@herbertland.com>
> > > Date: Fri, 3 Jan 2020 14:31:58 -0800
> > >
> > > > On Fri, Jan 3, 2020 at 12:45 PM David Miller <davem@davemloft.net> wrote:
> > > >>
> > > >> From: Tom Herbert <tom@herbertland.com>
> > > >> Date: Fri, 3 Jan 2020 09:35:08 -0800
> > > >>
> > > >> > The real way to combat this provide open implementation that
> > > >> > demonstrates the correct use of the protocols and show that's more
> > > >> > extensible and secure than these "hacks".
> > > >>
> > > >> Keep dreaming, this won't stop Cisco from doing whatever it wants to do.
> > > >
> > > > See QUIC. See TLS. See TCP fast open. See transport layer encryption.
> > > > These are prime examples where we've steered the Internet from host
> > > > protocols and implementation to successfully obsolete or at least work
> > > > around protocol ossification that was perpetuated by router vendors.
> > > > Cisco is not the Internet!
> > >
> > > Seriously, I wish you luck stopping the SRv6 header insertion stuff.
> > >
> > Dave,
> >
> > I agree we can't stop it, but maybe we can steer it to be at least
> > palatable. There are valid use cases for extension header insertion.
> > Ironically, SRv6 header insertion isn't one of them; the proponents
> > have failed to offer even a single reason why the alternative of IPv6
> > encapsulation isn't sufficient (believe me, we've asked _many_ times
> > for some justification and only get hand waving!). There are, however,
> > some interesting uses cases like in IOAM where the operator would like
> > to annotate packets as they traverse the network. Encapsulation is
> > insufficient if they don't know what the end point would be or they
> > don't want the annotation to change the path the packets take (versus
> > those that aren't annotated).
> >
> > The salient problem with extension header insertion is lost of
>
> And the problems that can be introduced by changing the effective path MTU...
>
Eric,

Yep, increasing the size of packet in transit potentially wreaks havoc
on PMTU discovery, however I personally think that the issue might be
overblown. We already have the same problem when tunneling is done in
the network since most tunneling implementations and deployments just
assume the operator has set large enough MTUs. As long as all the
overhead inserted into the packet doesn't reduce the end host PMTU
below 1280, PMTU discovery and probably even PTB for a packet with
inserted headers still has right effect.

> > attribution. It is fundamental in the IP protocol that the contents of
> > a packet are attributed to the source host identified by the source
> > address. If some intermediate node inserts an extension header that
> > subsequently breaks the packet downstream then there is no obvious way
> > to debug this. If an ICMP message is sent because of the receiving
> > data, then receiving host can't do much with it; it's not the source
> > of the data in error and nothing in the packet tells who the culprit
> > is. The Cisco guys have at least conceded one point on SRv6 insertion
> > due to pushback on this, their latest draft only does SRv6 insertion
> > on packets that have already been encapsulated in IPIP on ingress into
> > the domain. This is intended to at least restrict the modified packets
> > to a controlled domain (I'm note sure if any implementations enforce
> > this though). My proposal is to require an "attribution" HBH option
> > that would clearly identify inserted data put in a packet by
> > middleboxes (draft-herbert-6man-eh-attrib-00). This is a tradeoff to
> > allow extension header insertion, but require protocol to give
> > attribution and make it at least somewhat robust and manageable.
> >
> > Tom
>
> FWIW the SRv6 header insertion stuff is still under discussion in
> spring wg (last I knew).  I proposed one option that could be used to

It's also under discussion in 6man.

> avoid insertion (allow for extra scratch space
> https://mailarchive.ietf.org/arch/msg/spring/UhThRTNxbHWNiMGgRi3U0SqLaDA),
> but nothing has been conclusively resolved last I checked.
>

I saw your proposal. It's a good idea from POV to be conformant with
RFC8200 and avoid the PMTU problems, but the header insertion
proponents aren't going to like it at all. First, it means that the
source is in control of the insertion policy and host is required to
change-- no way they'll buy into that ;-). Secondly, if the scratch
space isn't used they'll undoubtedly claim that is unnecessary
overhead.

Tom

> As everyone probably knows, the draft-ietf-* documents are
> working-group-adopted documents (though final publication is never
> guaranteed).  My current reading of 6man tea leaves is that neither
> "ICMP limits" and "MTU option" docs were terribly contentious.
> Whether code reorg is important for implementing these I'm not
> competent enough to say.
