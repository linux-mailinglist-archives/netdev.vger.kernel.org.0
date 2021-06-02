Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BFE73992CA
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 20:46:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229553AbhFBSsW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 14:48:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229467AbhFBSsW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 14:48:22 -0400
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3059BC06174A;
        Wed,  2 Jun 2021 11:46:25 -0700 (PDT)
Received: by mail-il1-x135.google.com with SMTP id o9so3106537ilh.6;
        Wed, 02 Jun 2021 11:46:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=42lSeKIaV1CGNphmGC2qEO05eLA2cNyDNNBAKkeOzoI=;
        b=nXFG0t/B4mMaFeGppWiVlZHLZBrXWg5M1e6Be801+km1/mw3+c6HukNhhHzaGZNJxG
         wDHD0gNhq9DxSlEiAYWP94k9l43JE+XxIMAM5LeVVjggOsy8y/lGJAmosSenGwFk+Cgy
         F4DD/rChJ9CjbQX+APjuqrUmHiQFWskBR4UqlHQpkucx1e9ikXHNaQ9zObOlP3QHV9r6
         jDMpahGVameU5O6X3h+ePPxLCoRuXQF8BdslOrcHF2JapTMj5TElJRmyGJPAGua/aYA1
         dGh32f5mD2Q/K9zZemcHCb5lho/Pu2F+cc7TC743KuXVPJImOXZRpDSRQT6K66mGDDu8
         8XKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=42lSeKIaV1CGNphmGC2qEO05eLA2cNyDNNBAKkeOzoI=;
        b=DcD9uNakJdvXfv3ESf1KD4oiVT9s3rxLdIwlFs/TJ07aQ2hvCOzySey/sgB5vgqUig
         JwQ1NiBU3WIljxf5tP9xmFBjgDnmff/7LfOTzMqqveNDdJRTfi3oz7HRurOek3ognFZX
         nItaT1mDHXlmoKn/3rLu2edfxIFb6epjwUHXgsJ1r4PJ/vJ4TmzxJDbhS7ii55+J6Unk
         XR01MBpgVV7qRZyIu6Hx9rveMFskngHcXnCz2arls/J1wixVDTp1y61DehjVsyzEYi4j
         WQKGj0Puc5suh2x0f+WgA66nxxVAwOU/IcNd6FVOOkhdbgKblOZm0NS1QhiBzFLe4oxd
         1y3Q==
X-Gm-Message-State: AOAM533NO/lPyWpsDHT5s3Os+ZKEr1NLImTJ3wfcZOtvzYrcvWbGJ7oY
        bYmSyaxvcA3p1NTEia/U38A=
X-Google-Smtp-Source: ABdhPJxXmmwBPh+BoeL9Vpyd3HPwW6l0gQ/244uTe34OToaOLxt4JzZHN/Hd5v74L1WjLXZGPoRBTg==
X-Received: by 2002:a05:6e02:1be8:: with SMTP id y8mr27283526ilv.52.1622659584454;
        Wed, 02 Jun 2021 11:46:24 -0700 (PDT)
Received: from localhost ([172.243.157.240])
        by smtp.gmail.com with ESMTPSA id s10sm451225ilu.34.2021.06.02.11.46.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Jun 2021 11:46:24 -0700 (PDT)
Date:   Wed, 02 Jun 2021 11:46:15 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        David Miller <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, kernel-team <kernel-team@fb.com>
Message-ID: <60b7d1f7e3640_5c74020841@john-XPS-13-9370.notmuch>
In-Reply-To: <20210602181333.3m4vz2xqd5klbvyf@apollo>
References: <20210520185550.13688-1-alexei.starovoitov@gmail.com>
 <CAM_iQpWDgVTCnP3xC3=z7WCH05oDUuqxrw2OjjUC69rjSQG0qQ@mail.gmail.com>
 <CAADnVQ+V5o31-h-A+eNsHvHgOJrVfP4wVbyb+jL2J=-ionV0TA@mail.gmail.com>
 <CAM_iQpU-Cvpf-+9R0ZdZY+5Dv+stfodrH0MhvSgryv_tGiX7pA@mail.gmail.com>
 <CAM_iQpVYBNkjDeo+2CzD-qMnR4-2uW+QdMSf_7ohwr0NjgipaQ@mail.gmail.com>
 <CAADnVQJUHydpLwtj9hRWWNGx3bPbdk-+cQiSe3MDFQpwkKmkSw@mail.gmail.com>
 <CAM_iQpXUBuOirztj3kifdFpvygKb-aoqwuXKkLdG9VFte5nynA@mail.gmail.com>
 <20210602020030.igrx5jp45tocekvy@ast-mbp.dhcp.thefacebook.com>
 <874kegbqkd.fsf@toke.dk>
 <20210602175436.axeoauoxetqxzklp@kafai-mbp>
 <20210602181333.3m4vz2xqd5klbvyf@apollo>
Subject: Re: [RFC PATCH bpf-next] bpf: Introduce bpf_timer
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kumar Kartikeya Dwivedi wrote:
> On Wed, Jun 02, 2021 at 11:24:36PM IST, Martin KaFai Lau wrote:
> > On Wed, Jun 02, 2021 at 10:48:02AM +0200, Toke H=C3=B8iland-J=C3=B8rg=
ensen wrote:
> > > Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
> > >
> > > >> > In general the garbage collection in any form doesn't scale.
> > > >> > The conntrack logic doesn't need it. The cillium conntrack is =
a great
> > > >> > example of how to implement a conntrack without GC.
> > > >>
> > > >> That is simply not a conntrack. We expire connections based on
> > > >> its time, not based on the size of the map where it residents.
> > > >
> > > > Sounds like your goal is to replicate existing kernel conntrack
> > > > as bpf program by doing exactly the same algorithm and repeating
> > > > the same mistakes. Then add kernel conntrack functions to allow l=
ist
> > > > of kfuncs (unstable helpers) and call them from your bpf progs.
> > >
> > > FYI, we're working on exactly this (exposing kernel conntrack to BP=
F).
> > > Hoping to have something to show for our efforts before too long, b=
ut
> > > it's still in a bit of an early stage...
> > Just curious, what conntrack functions will be made callable to BPF?
> =

> Initially we're planning to expose the equivalent of nf_conntrack_in an=
d
> nf_conntrack_confirm to XDP and TC programs (so XDP one works without a=
n skb,
> and TC one works with an skb), to map these to higher level lookup/inse=
rt.
> =

> --
> Kartikeya

I think this is a missed opportunity. I can't see any advantage to
tying a XDP datapath into nft. For local connections use a socket lookup
no need for tables at all. For middle boxes you need some tables, but
again really don't see why you want nft here. An entirely XDP based
connection tracker is going to be faster, easier to debug, and
more easy to tune to do what you want as your use cases changes.

Other than architecture disagreements, the implementation of this
gets ugly. You will need to export a set of nft hooks, teach nft
about xdp_buffs and then on every packet poke nft. Just looking
at nf_conntrack_in() tells me you likely need some serious surgery
there to make this work and now you've forked a bunch of code that
could be done generically in BPF into some C hard coded stuff you
will have to maintain. Or you do an ugly hack to convert xdp into
skb on every packet, but I'll NAK that because its really defeats
the point of XDP. Maybe TC side is easier because you have skb,
but then you miss the real win in XDP side. Sorry I don't see any
upsides here and just more work to review, maintain code that is
dubious to start with.

Anyways original timers code above LGTM.

.John=
