Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2ACD12FF50
	for <lists+netdev@lfdr.de>; Sat,  4 Jan 2020 00:53:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726803AbgACXxv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jan 2020 18:53:51 -0500
Received: from mail-yb1-f194.google.com ([209.85.219.194]:39950 "EHLO
        mail-yb1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726229AbgACXxv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jan 2020 18:53:51 -0500
Received: by mail-yb1-f194.google.com with SMTP id a2so19347184ybr.7
        for <netdev@vger.kernel.org>; Fri, 03 Jan 2020 15:53:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=loon.com; s=google;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=efmZAZJ34338Xl+n/c0VDeMLFTAbuwG8JVo74goOpYk=;
        b=KmyQ2SpWIcNbO8VnuYna0tZWEYIwICGMXCTdTjgCzhSGqz6nsoVI4zM7EwTTK+JlOM
         +1Smik76yl45rsguz43AFcIKx/OuduTEkIbf68k0e/P2jxbWxh9NrDy+6E1/w+1Sau0P
         jote5Gk9wtw6xntE1iLtry3kRaLAp8FKN5blE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=efmZAZJ34338Xl+n/c0VDeMLFTAbuwG8JVo74goOpYk=;
        b=enLgJKsyfcvuzhIe1BVgIUotKkp2KzOrs9wOD3RBN4+8NUBKSqLDTZcx+aOmWCdBqI
         1VnGu3ulhedNDL3UugWU1fLL1H/ggUWNm0nsC8BVzh+wbMDYvA5Zfjh3UKiTwWlKOmhG
         8WsZ7t9FduUjF1UlRPYdhmMNeEdPOdxHLUo/zN7Tb2xQiOa7KGDbJNxDAITM2yXzrvHT
         gA1VM90OJ3WvspOSNR3aABNYPLB+Vr6ew7jWZDy+iD6nWmIwUFQqR9DOxcLFniNpKBEa
         Gi1YPaev1STzxmvgAUw+sWWDb/vtdwLzF4vk4EaUNYVh0ely2N/WWsEMxePlcCa66Rax
         bwQA==
X-Gm-Message-State: APjAAAUr8d4FhXJCao9vIi6u9sN8zDM3Ucz3/GUpws5VzqrCqVnQFoIu
        moqzh1Dl5+c/Uv02Ff0SryaTkS16D760ZFsFbOk2yA==
X-Google-Smtp-Source: APXvYqzN9YoezTfMvYnfrzUugW9pQIeK2i6Q8tLx+61dcx0eHjK1AwaQvUri4gDS0Ups9wYi6ZCsruRUwTpFY952GSM=
X-Received: by 2002:a25:6887:: with SMTP id d129mr65716900ybc.345.1578095629383;
 Fri, 03 Jan 2020 15:53:49 -0800 (PST)
MIME-Version: 1.0
References: <CALx6S361vkhp8rLzP804oMz2reuDgQDjm9G_+eXfq5oQpVscyg@mail.gmail.com>
 <20200103.124517.1721098411789807467.davem@davemloft.net> <CALx6S34vyjNnVbYfjqB1mNDDr3-zQixzXk=kgDqjJ0yxHVCgKg@mail.gmail.com>
 <20200103.145739.1949735492303739713.davem@davemloft.net> <CALx6S359YAzpJgzOFbb7c6VPe9Sin0F0Vn_vR+8iOo4rY57xQA@mail.gmail.com>
In-Reply-To: <CALx6S359YAzpJgzOFbb7c6VPe9Sin0F0Vn_vR+8iOo4rY57xQA@mail.gmail.com>
Reply-To: ek@loon.com
From:   Erik Kline <ek@loon.com>
Date:   Fri, 3 Jan 2020 15:53:37 -0800
Message-ID: <CAAedzxpG77vB3Z8XsTmCYPRB2Hn43otPMXZW4t0r3E-Wh98kNQ@mail.gmail.com>
Subject: Re: [PATCH v8 net-next 0/9] ipv6: Extension header infrastructure
To:     Tom Herbert <tom@herbertland.com>
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

On Fri, 3 Jan 2020 at 15:49, Tom Herbert <tom@herbertland.com> wrote:
>
> On Fri, Jan 3, 2020 at 2:57 PM David Miller <davem@davemloft.net> wrote:
> >
> > From: Tom Herbert <tom@herbertland.com>
> > Date: Fri, 3 Jan 2020 14:31:58 -0800
> >
> > > On Fri, Jan 3, 2020 at 12:45 PM David Miller <davem@davemloft.net> wrote:
> > >>
> > >> From: Tom Herbert <tom@herbertland.com>
> > >> Date: Fri, 3 Jan 2020 09:35:08 -0800
> > >>
> > >> > The real way to combat this provide open implementation that
> > >> > demonstrates the correct use of the protocols and show that's more
> > >> > extensible and secure than these "hacks".
> > >>
> > >> Keep dreaming, this won't stop Cisco from doing whatever it wants to do.
> > >
> > > See QUIC. See TLS. See TCP fast open. See transport layer encryption.
> > > These are prime examples where we've steered the Internet from host
> > > protocols and implementation to successfully obsolete or at least work
> > > around protocol ossification that was perpetuated by router vendors.
> > > Cisco is not the Internet!
> >
> > Seriously, I wish you luck stopping the SRv6 header insertion stuff.
> >
> Dave,
>
> I agree we can't stop it, but maybe we can steer it to be at least
> palatable. There are valid use cases for extension header insertion.
> Ironically, SRv6 header insertion isn't one of them; the proponents
> have failed to offer even a single reason why the alternative of IPv6
> encapsulation isn't sufficient (believe me, we've asked _many_ times
> for some justification and only get hand waving!). There are, however,
> some interesting uses cases like in IOAM where the operator would like
> to annotate packets as they traverse the network. Encapsulation is
> insufficient if they don't know what the end point would be or they
> don't want the annotation to change the path the packets take (versus
> those that aren't annotated).
>
> The salient problem with extension header insertion is lost of

And the problems that can be introduced by changing the effective path MTU...

> attribution. It is fundamental in the IP protocol that the contents of
> a packet are attributed to the source host identified by the source
> address. If some intermediate node inserts an extension header that
> subsequently breaks the packet downstream then there is no obvious way
> to debug this. If an ICMP message is sent because of the receiving
> data, then receiving host can't do much with it; it's not the source
> of the data in error and nothing in the packet tells who the culprit
> is. The Cisco guys have at least conceded one point on SRv6 insertion
> due to pushback on this, their latest draft only does SRv6 insertion
> on packets that have already been encapsulated in IPIP on ingress into
> the domain. This is intended to at least restrict the modified packets
> to a controlled domain (I'm note sure if any implementations enforce
> this though). My proposal is to require an "attribution" HBH option
> that would clearly identify inserted data put in a packet by
> middleboxes (draft-herbert-6man-eh-attrib-00). This is a tradeoff to
> allow extension header insertion, but require protocol to give
> attribution and make it at least somewhat robust and manageable.
>
> Tom

FWIW the SRv6 header insertion stuff is still under discussion in
spring wg (last I knew).  I proposed one option that could be used to
avoid insertion (allow for extra scratch space
https://mailarchive.ietf.org/arch/msg/spring/UhThRTNxbHWNiMGgRi3U0SqLaDA),
but nothing has been conclusively resolved last I checked.

As everyone probably knows, the draft-ietf-* documents are
working-group-adopted documents (though final publication is never
guaranteed).  My current reading of 6man tea leaves is that neither
"ICMP limits" and "MTU option" docs were terribly contentious.
Whether code reorg is important for implementing these I'm not
competent enough to say.
