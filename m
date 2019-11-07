Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE18CF33D4
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 16:54:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388931AbfKGPyZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 10:54:25 -0500
Received: from mail-ed1-f66.google.com ([209.85.208.66]:44176 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726231AbfKGPyZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 10:54:25 -0500
Received: by mail-ed1-f66.google.com with SMTP id a67so2267475edf.11
        for <netdev@vger.kernel.org>; Thu, 07 Nov 2019 07:54:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vRXyFa+8VJ1oGBmdsJRHWgI0m6mDf/apMbeKaQgJUWU=;
        b=H3md61kZxnpqqRb0Jw581W31/YrP8+ptJD/6ZFQbUiHQuIHqrCcTw+zfPQJxz/1uKk
         fBpnxlqDHyQxjHCRgDp1+UlOFxEq979kKZ9uhCf+u2OczHIkrSegeUPKR/70z11QSVkG
         H7hH5JhoZSpjHL9uz1iJzudpyqhS1xsvWI5j36x8kmbRCipjwwZLklPLDJJ+voViPSiT
         Ad4hl1OMcg0RkFWsaDJvMpeaco/PbIyIEf+XoQokUhihjnmMsmnxIn4WVOvfqH9gqmWJ
         K+71LYyypRrxda8Urkweq+HY3l79AVVji9tS5B+oGPPZQEMgH67ZZpBPcXiqMIG+tGXn
         d3AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vRXyFa+8VJ1oGBmdsJRHWgI0m6mDf/apMbeKaQgJUWU=;
        b=MoWa2Jh+fN/qC9eq0WFH83bjGOlPYmvLagVtcU+BJ1G/r5ax/mHrwhw7oBPnxb20b5
         klWHnSqpegnQG/KtzBEN1UByB+hXsnG5cThFw6teuDqOuzyX7FJ4ebzZavByRWr6ePEF
         GTnLj/l5HfpUY2QRWfEjmomyULqUKZCfJYGRH68BkJg9vwQBsjgtJ2QMHyVVyMTBoLZG
         P1zgVwVJJYzV9BqJ0zwWsBvgxzabzO2Maj8BWJA1w/nxPXr04HTAPVJ3nok0aJqHJUKs
         Bj+5XqiB6n0mZfx+U5q2RNtB+DrxpxjVlImhBfF1gMzSydpkvuZca94WQWAPqhS6Z4MW
         aQVA==
X-Gm-Message-State: APjAAAXj2PvkVY5NrUyHJkXO/zGfrKDzav5TNu/7cK5lPvAvOIL+ZR7T
        QY7UvzW33VN5yvVlR15Gj7cEdRVkDaszcoLatIk=
X-Google-Smtp-Source: APXvYqwW8IKJ0qfDobNIMpuTY7fn2pTRRtI8f1ysqTqdk6irVaCn+JvOn7c2T41Ih+lWnuK0a8eKijV76GbaAOSTZd4=
X-Received: by 2002:a17:906:7e58:: with SMTP id z24mr3756755ejr.302.1573142063659;
 Thu, 07 Nov 2019 07:54:23 -0800 (PST)
MIME-Version: 1.0
References: <cover.1570455278.git.martinvarghesenokia@gmail.com>
 <5979d1bf0b5521c66f2f6fa31b7e1cbdddd8cea8.1570455278.git.martinvarghesenokia@gmail.com>
 <CA+FuTSc=uTot72dxn7VRfCv59GcfWb32ZM5XU1_GHt3Ci3PL_A@mail.gmail.com>
 <20191017132029.GA9982@martin-VirtualBox> <CA+FuTScS+fm_scnm5qkU4wtV+FAW8XkC4OfwCbLOxuPz1YipNw@mail.gmail.com>
 <20191018082029.GA11876@martin-VirtualBox> <CA+FuTSf2u2yN1KL3vDLv-j9UQGsGo1dwXNVW8w=NCrdt7n8crg@mail.gmail.com>
 <20191107133819.GA10201@martin-VirtualBox>
In-Reply-To: <20191107133819.GA10201@martin-VirtualBox>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 7 Nov 2019 10:53:47 -0500
Message-ID: <CAF=yD-JX=juqj2yrpZ6MjksLDqF8JVjTsruu2yVh5aXL6rou5g@mail.gmail.com>
Subject: Re: [PATCH net-next 1/2] UDP tunnel encapsulation module for
 tunnelling different protocols like MPLS,IP,NSH etc.
To:     Martin Varghese <martinvarghesenokia@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jonathan Corbet <corbet@lwn.net>, scott.drennan@nokia.com,
        Jiri Benc <jbenc@redhat.com>, martin.varghese@nokia.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > I do think that with close scrutiny there is a lot more room for code
> > deduplication. Just look at the lower half of geneve_rx and
> > bareudp_udp_encap_recv, for instance. This, too, is identical down to
> > the comments. Indeed, is it fair to say that geneve was taken as the
> > basis for this device?
> >
> > That said, even just avoiding duplicating those routing functions
> > would be a good start.
> >
> > I'm harping on this because in other examples in the past where a new
> > device was created by duplicating instead of factoring out code
> > implementations diverge over time in bad ways due to optimizations,
> > features and most importantly bugfixes being applied only to one
> > instance or the other. See for instance tun.c and tap.c.
> >
> > Unrelated, an ipv6 socket can receive both ipv4 and ipv6 traffic if
> > not setting the v6only bit, so does the device need to have separate
> > sock4 and sock6 members? Both sockets currently lead to the same
> > bareudp_udp_encap_recv callback function.
>
> I was checking this.AF_INET6 allows v6 and v4 mapped v6 address.
> And it doesnot allow both at the same time.So we need both
> sockets to support v4 and v6 at the same time.correct ?

bareudp_create_sock currently creates an inet socket listening on
INADDR_ANY and an inet6 socket listening on in6addr_any with v6only.
If so, just the latter without v6only should offer the same.
