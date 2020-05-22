Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E8631DEF87
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 20:53:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730867AbgEVSxi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 14:53:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730840AbgEVSxh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 14:53:37 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5B1EC061A0E;
        Fri, 22 May 2020 11:53:37 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id n11so6264661qkn.8;
        Fri, 22 May 2020 11:53:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HcqR82MYzwNZxeA4COU/Pg+NYpk4dCNhb8s6EAGCmGM=;
        b=njFTqkKPnIb/PxSDZDDhGzJozUPXKsZFFUwihZp/PPmCq7UmCc+qfk3e7lqRs/lvaH
         qD89AigBea7hvjvzL++zRtX7t5xC2ah6ZLfTNyGC0eAelt474cNh8YlTkYfjv3D6Ve3K
         8rU/WiV/u3YwfbQrBKGpv6vlq2BDHhLDt8u4SEBNYKiwJTaaI259+dNp016CSVHcZcaV
         A0EzJVVnlw3Fa++pc0E1OcICd9Xim6jqK95fULJR7jNPMZ8es+nTti37kPNNmBWVTkls
         WwNqoaO7X1OBUCwzxr9lg5fkN2siILSna/2K4qtnJ8H2Plt1sBOluVLik39eLmS9psjQ
         pGrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HcqR82MYzwNZxeA4COU/Pg+NYpk4dCNhb8s6EAGCmGM=;
        b=BB5e4H4cP/gD20G+yzlANWD6WYQp5Q/gIK1vTFcUkyWJ7W4qAi8oVU49a8HF5Oyw0h
         j+mjdR1vafA07MolcM2mNQ3kHJpNCsFo/Uqd0f/GQMNjRGWxo5+0P0YelWTkEaMvgxF0
         7gq6ZycyCXoAGH4P61ZlBUgIaAEsLPQ0nlVNMTOgZEwbrQFXzDsRjceQ7NpVABwZyabH
         2Hil15Dluw/7H65xROUWQtQsbw1soC+sxzLMC1tqsbCP+BujG8Cx95VEVyfh3l1hPK6q
         gKZsGGh7F4E73Nh/e2RSfA/hnngfHRnLEyTRcHBiNa8irwV/X393hkR6TlFs/1NJmxwt
         /0Hw==
X-Gm-Message-State: AOAM5314x94/qn227t3PPl7aapLzcZKj9+MbRJtl2iZGFo8tNBG+m7cw
        cMkuVkstd+36sYvLHYNKIm0qI/gk0m740tAFu4w=
X-Google-Smtp-Source: ABdhPJwDXx5XsCMdrnaTnBz49AfXhZhuoCYmZymMcZxd5AH4NMWnzwv0AxrWWae+ct/AoY1/KtioNfc8zRV4EbteBk4=
X-Received: by 2002:a37:6508:: with SMTP id z8mr4075372qkb.39.1590173616910;
 Fri, 22 May 2020 11:53:36 -0700 (PDT)
MIME-Version: 1.0
References: <20200517195727.279322-1-andriin@fb.com> <20200517195727.279322-4-andriin@fb.com>
 <20200522011335.f4bfabh32puptotu@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20200522011335.f4bfabh32puptotu@ast-mbp.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 22 May 2020 11:53:26 -0700
Message-ID: <CAEf4BzYqzJmRfCxtY6qqRZ0vfR7kDsMLvGgT1iENZ82WAh0TVg@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 3/7] bpf: track reference type in verifier
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 21, 2020 at 6:13 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Sun, May 17, 2020 at 12:57:23PM -0700, Andrii Nakryiko wrote:
> >
> > +static enum bpf_ref_type get_release_ref_type(enum bpf_func_id func_id)
> > +{
> > +     switch (func_id) {
> > +     case BPF_FUNC_sk_release:
> > +             return BPF_REF_SOCKET;
> > +     case BPF_FUNC_ringbuf_submit:
> > +     case BPF_FUNC_ringbuf_discard:
> > +             return BPF_REF_RINGBUF;
> > +     default:
> > +             return BPF_REF_INVALID;
> > +     }
> > +}
> > +
> >  static bool may_be_acquire_function(enum bpf_func_id func_id)
> >  {
> >       return func_id == BPF_FUNC_sk_lookup_tcp ||
> > @@ -464,6 +477,28 @@ static bool is_acquire_function(enum bpf_func_id func_id,
> >       return false;
> >  }
> >
> > +static enum bpf_ref_type get_acquire_ref_type(enum bpf_func_id func_id,
> > +                                           const struct bpf_map *map)
> > +{
> > +     enum bpf_map_type map_type = map ? map->map_type : BPF_MAP_TYPE_UNSPEC;
> > +
> > +     switch (func_id) {
> > +     case BPF_FUNC_sk_lookup_tcp:
> > +     case BPF_FUNC_sk_lookup_udp:
> > +     case BPF_FUNC_skc_lookup_tcp:
> > +             return BPF_REF_SOCKET;
> > +     case BPF_FUNC_map_lookup_elem:
> > +             if (map_type == BPF_MAP_TYPE_SOCKMAP ||
> > +                 map_type == BPF_MAP_TYPE_SOCKHASH)
> > +                     return BPF_REF_SOCKET;
> > +             return BPF_REF_INVALID;
> > +     case BPF_FUNC_ringbuf_reserve:
> > +             return BPF_REF_RINGBUF;
> > +     default:
> > +             return BPF_REF_INVALID;
> > +     }
> > +}
>
> Two switch() stmts to convert helpers to REF is kinda hacky.
> I think get_release_ref_type() could have got the ref's type as btf_id from its
> arguments which would have made it truly generic and 'enum bpf_ref_type' would
> be unnecessary, but sk_lookup_* helpers return u64 and don't have btf_id of
> return value. I think we better fix that. Then btf_id would be that ref type.

True, sure. I'll drop this patch in next version, because everything
works without it. Then we can generalize this eventually.
