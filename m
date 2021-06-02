Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1280439924B
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 20:14:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229653AbhFBSQb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 14:16:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbhFBSQa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 14:16:30 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 704D0C061574;
        Wed,  2 Jun 2021 11:14:37 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id c12so2856657pfl.3;
        Wed, 02 Jun 2021 11:14:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=FwuJ0u4UB9KKYUxy2ZJWFHPpRAw5cDFJ3xn49DV3QA4=;
        b=u8REXWcegYopPJEHIKOuueDX5DkAXwcwZEb752wefyYwOYNS458kIkjQMnqzy54y+r
         jZuDyle4ZfahMSlQLG9+IrBeTztYjMsF9d/ko+tmk0ggBQzj2zx3CPMb7H/l9ODc5SFg
         JsX9Lcj3otPIaVTZ8eZQdlGSlLGC40sQudTdXXxyAgjaD1mTf6N776oY/80SpHE9alie
         05ZPg0GWJVFNtGGvGVRwuR83CY/F+MaZkCEIbsUAzZVCTkNlpgrz9H+GhiDZBNICs1DA
         KylR7mkkTrmp3K96SRxWXwfoDprke+9uKtQIPVP5rUOFUeCucMM/zv/lq/UcMiuf8quQ
         2V1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=FwuJ0u4UB9KKYUxy2ZJWFHPpRAw5cDFJ3xn49DV3QA4=;
        b=o8rWzaYODxskqFc8aiiT978cKm7o6CYRb2VxhZ2N9C+D7cG4+uPCOA2Vf2a981Jri8
         5CjY9jox/ZOVRl1oNUnKEwn8JAupIR3JSaNKjrRvEkr/HcY9x2ReMdczxIqtuvahJ7Vy
         dvimOjOm5Ymk5Mw+fAgAEBL7TJT069JciZM4YWia56ChtExENeyK9MMfK/Duqu3Eo1Sy
         EDoC6agGi1T2dK5k8zmppNJsazonFktS3QyTJaYRJtfxoyBlBlqwO4OIsSPqBGl/eEsc
         TMFeYZAgLgOv9zBqidRogunEbOGIW4pEaqTbQOw4f0QASuwd9ak4IG5Ro2NedgVkx+qZ
         WiQg==
X-Gm-Message-State: AOAM530TTYhCB1bVZW2+dtNBF6LM9HtnwJ6a/lvE6qECRrKdWp8r8mXb
        qYQkaFMAWEaBNKCvm1s0f9w=
X-Google-Smtp-Source: ABdhPJy+2LsmijJ7jvZK8+x6/j5ZPKnWSYTrdqBLRgpASXLKs7ze8JX5I69TfjtC5Snq5f45add2HA==
X-Received: by 2002:a63:125d:: with SMTP id 29mr18783065pgs.151.1622657676950;
        Wed, 02 Jun 2021 11:14:36 -0700 (PDT)
Received: from localhost ([2402:3a80:11c3:3834:fb69:d961:ca12:b10d])
        by smtp.gmail.com with ESMTPSA id w23sm256889pfi.220.2021.06.02.11.14.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Jun 2021 11:14:36 -0700 (PDT)
Date:   Wed, 2 Jun 2021 23:43:33 +0530
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        David Miller <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, kernel-team <kernel-team@fb.com>
Subject: Re: [RFC PATCH bpf-next] bpf: Introduce bpf_timer
Message-ID: <20210602181333.3m4vz2xqd5klbvyf@apollo>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210602175436.axeoauoxetqxzklp@kafai-mbp>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 02, 2021 at 11:24:36PM IST, Martin KaFai Lau wrote:
> On Wed, Jun 02, 2021 at 10:48:02AM +0200, Toke Høiland-Jørgensen wrote:
> > Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
> >
> > >> > In general the garbage collection in any form doesn't scale.
> > >> > The conntrack logic doesn't need it. The cillium conntrack is a great
> > >> > example of how to implement a conntrack without GC.
> > >>
> > >> That is simply not a conntrack. We expire connections based on
> > >> its time, not based on the size of the map where it residents.
> > >
> > > Sounds like your goal is to replicate existing kernel conntrack
> > > as bpf program by doing exactly the same algorithm and repeating
> > > the same mistakes. Then add kernel conntrack functions to allow list
> > > of kfuncs (unstable helpers) and call them from your bpf progs.
> >
> > FYI, we're working on exactly this (exposing kernel conntrack to BPF).
> > Hoping to have something to show for our efforts before too long, but
> > it's still in a bit of an early stage...
> Just curious, what conntrack functions will be made callable to BPF?

Initially we're planning to expose the equivalent of nf_conntrack_in and
nf_conntrack_confirm to XDP and TC programs (so XDP one works without an skb,
and TC one works with an skb), to map these to higher level lookup/insert.

--
Kartikeya
