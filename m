Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28C2912FF44
	for <lists+netdev@lfdr.de>; Sat,  4 Jan 2020 00:49:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726380AbgACXtD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jan 2020 18:49:03 -0500
Received: from mail-ed1-f65.google.com ([209.85.208.65]:36873 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726232AbgACXtD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jan 2020 18:49:03 -0500
Received: by mail-ed1-f65.google.com with SMTP id cy15so42937939edb.4
        for <netdev@vger.kernel.org>; Fri, 03 Jan 2020 15:49:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=herbertland-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3zQ5uQs5btnu4bFKPaeRzn5Cbo90rMvLNzWKjMEsSJQ=;
        b=t+ZV5LeVWCTmGyU5SrhqG4bF8SY5uGwc03SiFek9EiM3+F1A62j2u5jSfRNsGCQNfa
         Ru8HrYzh6ZJq27YVj4F32jc5PWJ9RjhfSMRhOM1EgJ155ofInC1ism0HHP++uTB7XOHY
         fFBYLF9HlGQ61XNqrTIbYO82UMhaEJ4F7DCLLdAntAIlFGYr0kv/sPhwr1Pdh0isHRib
         Yk9oNvak3LtxjMDS+/rSE8m0YKFOSHoziqxyZ77TyjtIEluaErLd9joQNQ6UB87B6MgL
         KI5q4JEX6Xd4nMiFJE447A0XA0VpANdEvJJdlFv2z/1BJD208RpM5+vJuZsnxBgHsJDu
         auNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3zQ5uQs5btnu4bFKPaeRzn5Cbo90rMvLNzWKjMEsSJQ=;
        b=U4ERegf/sjrr/z/A6JkYWnvg+3Weu53JGH/gKEkNYaM+LOhqHF7ELzYOboHkbQSs4d
         I3d8V2Jl/eWuApe0qmhSFeOLShpjZ2vvfvWH5GD6im7P89aFitoI1Z6f4rp7bosqLR0T
         g1ZPsFIWLfQc3g+DC5FPPgMO05cuyeLQavD8JhufK/CQqIuWbTtctPh6jkwjtoMO2pp3
         yJ61lLQe7h+Ho0ddG5b5JhcNVVY18BUndRGD83to5grrNhBuMw91R9x49ANTq6/7EhOH
         MKpV076+94v+MlPh5XIPN8BBYTzigVbmcZovDr0u6TJsFTU8CKccqg5CR1mA0DWQLhET
         c7NQ==
X-Gm-Message-State: APjAAAVDvZO741hGv01g4yN2GpFbl5YBwqGwvdpwSzHrChDY2WP8t9/7
        K+7LVJxEOoIWCne5GAMfa/hcV/NOv/HgwmVvYzxXbfTqwqw=
X-Google-Smtp-Source: APXvYqy2mQhG48Jg8g6eCoSkH1gV3+T6PKr+NKjiIUM/Ng8GdaN99LxEWZIj1t5vwWyXzkr+3xwwblSV84MJO5T3a+8=
X-Received: by 2002:a17:906:5e4d:: with SMTP id b13mr98088753eju.266.1578095341175;
 Fri, 03 Jan 2020 15:49:01 -0800 (PST)
MIME-Version: 1.0
References: <CALx6S361vkhp8rLzP804oMz2reuDgQDjm9G_+eXfq5oQpVscyg@mail.gmail.com>
 <20200103.124517.1721098411789807467.davem@davemloft.net> <CALx6S34vyjNnVbYfjqB1mNDDr3-zQixzXk=kgDqjJ0yxHVCgKg@mail.gmail.com>
 <20200103.145739.1949735492303739713.davem@davemloft.net>
In-Reply-To: <20200103.145739.1949735492303739713.davem@davemloft.net>
From:   Tom Herbert <tom@herbertland.com>
Date:   Fri, 3 Jan 2020 15:48:50 -0800
Message-ID: <CALx6S359YAzpJgzOFbb7c6VPe9Sin0F0Vn_vR+8iOo4rY57xQA@mail.gmail.com>
Subject: Re: [PATCH v8 net-next 0/9] ipv6: Extension header infrastructure
To:     David Miller <davem@davemloft.net>
Cc:     Ahmed Abdelsalam <ahabdels.dev@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Simon Horman <simon.horman@netronome.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 3, 2020 at 2:57 PM David Miller <davem@davemloft.net> wrote:
>
> From: Tom Herbert <tom@herbertland.com>
> Date: Fri, 3 Jan 2020 14:31:58 -0800
>
> > On Fri, Jan 3, 2020 at 12:45 PM David Miller <davem@davemloft.net> wrote:
> >>
> >> From: Tom Herbert <tom@herbertland.com>
> >> Date: Fri, 3 Jan 2020 09:35:08 -0800
> >>
> >> > The real way to combat this provide open implementation that
> >> > demonstrates the correct use of the protocols and show that's more
> >> > extensible and secure than these "hacks".
> >>
> >> Keep dreaming, this won't stop Cisco from doing whatever it wants to do.
> >
> > See QUIC. See TLS. See TCP fast open. See transport layer encryption.
> > These are prime examples where we've steered the Internet from host
> > protocols and implementation to successfully obsolete or at least work
> > around protocol ossification that was perpetuated by router vendors.
> > Cisco is not the Internet!
>
> Seriously, I wish you luck stopping the SRv6 header insertion stuff.
>
Dave,

I agree we can't stop it, but maybe we can steer it to be at least
palatable. There are valid use cases for extension header insertion.
Ironically, SRv6 header insertion isn't one of them; the proponents
have failed to offer even a single reason why the alternative of IPv6
encapsulation isn't sufficient (believe me, we've asked _many_ times
for some justification and only get hand waving!). There are, however,
some interesting uses cases like in IOAM where the operator would like
to annotate packets as they traverse the network. Encapsulation is
insufficient if they don't know what the end point would be or they
don't want the annotation to change the path the packets take (versus
those that aren't annotated).

The salient problem with extension header insertion is lost of
attribution. It is fundamental in the IP protocol that the contents of
a packet are attributed to the source host identified by the source
address. If some intermediate node inserts an extension header that
subsequently breaks the packet downstream then there is no obvious way
to debug this. If an ICMP message is sent because of the receiving
data, then receiving host can't do much with it; it's not the source
of the data in error and nothing in the packet tells who the culprit
is. The Cisco guys have at least conceded one point on SRv6 insertion
due to pushback on this, their latest draft only does SRv6 insertion
on packets that have already been encapsulated in IPIP on ingress into
the domain. This is intended to at least restrict the modified packets
to a controlled domain (I'm note sure if any implementations enforce
this though). My proposal is to require an "attribution" HBH option
that would clearly identify inserted data put in a packet by
middleboxes (draft-herbert-6man-eh-attrib-00). This is a tradeoff to
allow extension header insertion, but require protocol to give
attribution and make it at least somewhat robust and manageable.

Tom
