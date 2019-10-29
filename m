Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA623E802D
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 07:21:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730550AbfJ2GVK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 02:21:10 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:36321 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726067AbfJ2GVJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 02:21:09 -0400
Received: by mail-qk1-f193.google.com with SMTP id d13so731343qko.3;
        Mon, 28 Oct 2019 23:21:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=7AyYYBBoYqktJmpu7YidYfR9Gt/NHAxFLE3EQQEapFU=;
        b=q1xJPwp07d9zkc4xJ5vp2GKTarCf6lYzBu1kRfTU88bJSJlpC/JEAgEjMEEBtMXWJY
         wZmffil0qzePeimWLAj29NmT+kVHyknGbseBcrUnRo/M5TZsmMVFWTZXMtI21m2N0uw3
         S1/7UPzamaeVqlAgeGzMTuy9fchNJ31QCFmeEl6Tjs1pV6UIX/zjGKh3FwOz/GDYviG1
         o/2w7B/ceoBl4ZTHvrFOa4+xyaLvKxu9AwxgXySUqduPMH4NmqVlbaQUagio5vOLRIG+
         YhHgL7vwqdxWAdi2pJ47oAl5kIOjFCf0aUbnGVis/GUqzZaBt2IyUtfimpiYEqOz/2ct
         YHzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=7AyYYBBoYqktJmpu7YidYfR9Gt/NHAxFLE3EQQEapFU=;
        b=MG5NYOeroEXULTkUu5oamqPn8hsqyHp04mF/sDuUaxZ+Khzt4TIsBBmjeygW4S+J90
         9oq2MpcSf0VAkFELHu2wXXN5mQMfoJS+zxrNqo8BCcmoRgUD82IQZf58s00pgYfVRBFB
         MRCy7aVT7xD0VEniIfJzJCdkkZ1i0kx0k/6/BSVsdAUiQRLyBIbrLpX7OLjiC19kQJ6A
         aiiM/HbRoUVh3LIj0VnpvMR9vjgbn2vBwx/D1mPs2O0yRXtLSpuCdSrgXFQSPFIZpC44
         usPJdbdhUd7lLYrOonCM8G/ZgHD/PtbLRd6KdWPqm3QlyzhdVVnNqMa6kWFOhVwv2TfB
         vAnA==
X-Gm-Message-State: APjAAAU6zNcNpWlaLpF7x3sIEI+kCzFOdjGoW/4GWcqwXmJ6wy3B41ir
        v3sz3HiVzfstir3f+lUODrUwPljaSUnjoxuPoko=
X-Google-Smtp-Source: APXvYqzOa0gNeDWXXdXpfJspHp0TCQcSI5Bh5QnoMPKIDX+2RT546t9M6D3YaoD6YOc6HSwxoUTFnA8jID5WsSWkm50=
X-Received: by 2002:a37:8b03:: with SMTP id n3mr19568077qkd.493.1572330068487;
 Mon, 28 Oct 2019 23:21:08 -0700 (PDT)
MIME-Version: 1.0
References: <20191025071842.7724-1-bjorn.topel@gmail.com> <20191025071842.7724-2-bjorn.topel@gmail.com>
 <20191028105508.4173bf8b@cakuba.hsd1.ca.comcast.net> <CAJ+HfNhVZFNV3bZPhhiAd8ObechCJ5CdODM=W1Qf0wdN97TL=w@mail.gmail.com>
 <20191028152629.0dec07d1@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <20191028152629.0dec07d1@cakuba.hsd1.ca.comcast.net>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Tue, 29 Oct 2019 07:20:55 +0100
Message-ID: <CAJ+HfNjDzNg9wdNkhx7BVkK5Udd3_WP0UMT8jTyssd254M6NsQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 1/2] xsk: store struct xdp_sock as a flexible
 array member of the XSKMAP
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        bpf <bpf@vger.kernel.org>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 28 Oct 2019 at 23:26, Jakub Kicinski
<jakub.kicinski@netronome.com> wrote:
>
> On Mon, 28 Oct 2019 23:11:50 +0100, Bj=C3=B6rn T=C3=B6pel wrote:
> > On Mon, 28 Oct 2019 at 18:55, Jakub Kicinski
> > <jakub.kicinski@netronome.com> wrote:
> > >
> > > On Fri, 25 Oct 2019 09:18:40 +0200, Bj=C3=B6rn T=C3=B6pel wrote:
> > > > From: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
> > > >
> > > > Prior this commit, the array storing XDP socket instances were stor=
ed
> > > > in a separate allocated array of the XSKMAP. Now, we store the sock=
ets
> > > > as a flexible array member in a similar fashion as the arraymap. Do=
ing
> > > > so, we do less pointer chasing in the lookup.
> > > >
> > > > Signed-off-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
> > >
> > > Thanks for the re-spin.
> > >
> > > > diff --git a/kernel/bpf/xskmap.c b/kernel/bpf/xskmap.c
> > > > index 82a1ffe15dfa..a83e92fe2971 100644
> > > > --- a/kernel/bpf/xskmap.c
> > > > +++ b/kernel/bpf/xskmap.c
> > >
> > > > @@ -92,44 +93,35 @@ static struct bpf_map *xsk_map_alloc(union bpf_=
attr *attr)
> > > >           attr->map_flags & ~(BPF_F_NUMA_NODE | BPF_F_RDONLY | BPF_=
F_WRONLY))
> > > >               return ERR_PTR(-EINVAL);
> > > >
> > > > -     m =3D kzalloc(sizeof(*m), GFP_USER);
> > > > -     if (!m)
> > > > +     numa_node =3D bpf_map_attr_numa_node(attr);
> > > > +     size =3D struct_size(m, xsk_map, attr->max_entries);
> > > > +     cost =3D size + array_size(sizeof(*m->flush_list), num_possib=
le_cpus());
> > >
> > > Now we didn't use array_size() previously because the sum here may
> > > overflow.
> > >
> > > We could use __ab_c_size() here, the name is probably too ugly to use
> > > directly and IDK what we'd have to name such a accumulation helper...
> > >
> > > So maybe just make cost and size a u64 and we should be in the clear.
> > >
> >
> > Hmm, but both:
> >   int bpf_map_charge_init(struct bpf_map_memory *mem, size_t size);
> >   void *bpf_map_area_alloc(size_t size, int numa_node);
> > pass size as size_t, so casting to u64 doesn't really help on 32-bit
> > systems, right?
>
> Yup :( IOW looks like the overflows will not be caught on 32bit
> machines in all existing code that does the (u64) cast. I hope
> I'm wrong there.
>
> > Wdyt about simply adding:
> >   if (cost < size)
> >     return ERR_PTR(-EINVAL)
> > after the cost calculation for explicit overflow checking?
>
> We'd need that for all users of these helpers. Could it perhaps makes
> sense to pass "alloc_size" and "extra_cost" as separate size_t to
> bpf_map_charge_init() and then we can do the overflow checking there,
> centrally?
>

The cost/size calculations seem to vary a bit from map to map, so I
don't know about the extra size_t arguments... but all of them do use
u64 for cost and explicit casting, in favor of u32 overflow checks.
Changing bpf_map_charge_init()/bpf_map_area_alloc() size to u64 would
be the smallest change, together with a 64-to-32 overflow check in
those functions.

> We can probably get rid of all the u64 casting too at that point,
> and use standard overflow helpers, yuppie :)
>

Yeah, that's the other path, but more churn (check_add_overflow() in every =
map).

Preferred path?

> > So, if size's struct_size overflows, the allocation will fail.
> > And we'll catch the cost overflow with the if-statement, no?
> >
> > Another option is changing the size_t in bpf_map_... to u64. Maybe
> > that's better, since arraymap and devmap uses u64 for cost/size.
