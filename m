Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E33D1533F9
	for <lists+netdev@lfdr.de>; Wed,  5 Feb 2020 16:36:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727052AbgBEPg2 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 5 Feb 2020 10:36:28 -0500
Received: from mail-vs1-f68.google.com ([209.85.217.68]:45743 "EHLO
        mail-vs1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726592AbgBEPg1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Feb 2020 10:36:27 -0500
Received: by mail-vs1-f68.google.com with SMTP id v141so1563256vsv.12
        for <netdev@vger.kernel.org>; Wed, 05 Feb 2020 07:36:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=nNSaYcuH3CLgDyaV+0jVr4gDCM9RLWpNWYCUwe4cHoA=;
        b=Ynebi0vqBTYuopNOgZUVaZOOiaOobpCTnA5jzFblMTlmvJXwI/ca6o4/hgXAAQmIF2
         B2xN3/ZB8Mi1oXAD/QqmmNGa8rO19CIbUXmGCwDodzGQnfP6v88SZuSiA4JfLWYRgnaM
         YjBvVonektR/Wd0EMEOr8WU9jH72Vr+Ao0tKdncI2L8PIGwJpp36N0fe23OG+kt0sZwg
         BHcr28Qw7QMpGhGLhIbtJ/qQlebm8YTeO2CkbgVJ1O7YiOnfn6I34YaX51M14GW3f/Qp
         qv3ESRb2kk3oYePNng7oShmf8nVFU89nyUWOz3gGBmaU0LMhIBub/j2au8HHOV9qOgNi
         Dngw==
X-Gm-Message-State: APjAAAVyL27bp4xxyrzOJpTW/TyjViwiIHzZNu58ZmFC8YJ2GW9nQ0Yw
        kJ1lBPQCQa3zO0fPYSr4CLMdg/DgrgsnWt+pcmk=
X-Google-Smtp-Source: APXvYqyZMh/7MAeGwNb3rL5yBb9WjeNAb8Gs5PQ+IuMH2497GzsL1O0hTeLL11as0wv9mT+UNYLnkYGxdIz93W/RBnI=
X-Received: by 2002:a67:31d8:: with SMTP id x207mr22785203vsx.192.1580916986822;
 Wed, 05 Feb 2020 07:36:26 -0800 (PST)
MIME-Version: 1.0
References: <20200122203253.20652-1-lrizzo@google.com> <875zh2bis0.fsf@toke.dk>
 <953c8fee-91f0-85e7-6c7b-b9a2f8df5aa6@iogearbox.net> <87blqui1zu.fsf@toke.dk>
 <CAMOZA0Kmf1=ULJnbBUVKKjUyzqj2JKfp5ub769SNav5=B7VA5Q@mail.gmail.com>
 <875zh2hx20.fsf@toke.dk> <CAMOZA0JSZ2iDBk4NOUyNLVE_KmRzYHyEBmQWF+etnpcp=fe0kQ@mail.gmail.com>
 <b22e86ef-e4dd-14a3-fb1b-477d9e61fefa@iogearbox.net> <87r1zpgosp.fsf@toke.dk>
 <CAMOZA0+neBeXKDyQYxwP0MqC9TqGWV-d3S83z_EACH=iOEb6mw@mail.gmail.com>
 <87r1zog9cj.fsf@toke.dk> <CAMOZA0KZOyEjJj3N7WQNRYi+n91UKkWihQRjxdrbCs9JdM5cbg@mail.gmail.com>
 <87a76cfstd.fsf@toke.dk>
In-Reply-To: <87a76cfstd.fsf@toke.dk>
From:   Luigi Rizzo <rizzo@iet.unipi.it>
Date:   Wed, 5 Feb 2020 07:36:15 -0800
Message-ID: <CA+hQ2+g+owSWzwEsnYmnY2S3ipCXPXsghYF0--aorTCJ1gVpSg@mail.gmail.com>
Subject: Re: [PATCH] net-xdp: netdev attribute to control xdpgeneric skb linearization
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Luigi Rizzo <lrizzo@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        netdev <netdev@vger.kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Jubran, Samih" <sameehj@amazon.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 24, 2020 at 1:28 PM Toke Høiland-Jørgensen <toke@redhat.com> wrote:
>
> Luigi Rizzo <lrizzo@google.com> writes:
>
> > On Fri, Jan 24, 2020 at 7:31 AM Toke Høiland-Jørgensen <toke@redhat.com> wrote:
> >>
> >> Luigi Rizzo <lrizzo@google.com> writes:
> >>
> > ...
> >> > My motivation for this change is that enforcing those guarantees has
> >> > significant cost (even for native xdp in the cases I mentioned - mtu >
> >> > 1 page, hw LRO, header split), and this is an interim solution to make
> >> > generic skb usable without too much penalty.
> >>
> >> Sure, that part I understand; I just don't like that this "interim"
> >> solution makes generic and native XDP diverge further in their
> >> semantics...
> >
> > As a matter of fact I think it would make full sense to use the same approach
> > to control whether native xdp should pay the price converting to linear buffers
> > when the hw cannot guarantee that.
> >
> > To me this seems to be a case of "perfect is enemy of good":..
>
> Hmm, I can kinda see your point (now that I've actually grok'ed how the
> length works with skbs and generic XDP :)). I would still worry that
> only having the header there would lead some XDP programs to just
> silently fail. But on the other hand, this is opt-in... so IDK - maybe
> this is fine to merge as-is, and leave improvements for later?

Sorry I let this slip, any consensus on this patch?

Thanks
Luigi

-- 
-----------------------------------------+-------------------------------
 Prof. Luigi RIZZO, rizzo@iet.unipi.it  . Dip. di Ing. dell'Informazione
 http://www.iet.unipi.it/~luigi/        . Universita` di Pisa
 TEL      +39-050-2217533               . via Diotisalvi 2
 Mobile   +39-338-6809875               . 56122 PISA (Italy)
-----------------------------------------+-------------------------------
