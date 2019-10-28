Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13180E7C2F
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 23:12:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727020AbfJ1WME (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 18:12:04 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:41240 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725848AbfJ1WME (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Oct 2019 18:12:04 -0400
Received: by mail-qt1-f194.google.com with SMTP id o3so17049956qtj.8;
        Mon, 28 Oct 2019 15:12:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=CsAwmYt/wlWSZNznep779HTe5CrLlV687QSHHrd7XXA=;
        b=NSkShDnCniihs3YoIV/b8kq8h1vmg47uY6xWnKpvMt3+OzMfSdl5brBYpCq5JMy36o
         32d97l4gqj8y64bnmn8wWnencaNiJZR0jzGDbWbUmL7m406BpJa0Hjek23QRmfBfCqNZ
         W9zqbgf2wcM6dmAGmTWUPMyHs/XCn3c9vHwfw/avdBeg0KKBDaqqOCJDrPmYBdHH1OJY
         UyKF+J0cnEl4feV4VPWiHsv35wZRXqzRghcNNf9g4Zi6Iw1hjzqtoJ6BMiBs1vkG6PIK
         PaSlbs6hruEEUb9vgy9BaJWJ4qBDfAXlQE2gNCU/Dv6ZtN07SAx5rxjPruKwqejq8fj9
         SBgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=CsAwmYt/wlWSZNznep779HTe5CrLlV687QSHHrd7XXA=;
        b=uL6qJGn24pXa6uJfR4MXY0jkE6y8aHxs/PtZYXT8GWmOI/MUtkLkUwRSlHqsVwpSS7
         Y1NE3GQuwcTlQpyi/cYbKoV9blmbaRP4KBh20fmOeRp+TvMTtxXVXHeanu8IlxdP1JSB
         5Hu02HXxVZmoMqVVtRUkzXXx0l2zQU19/EXzQaUjz96L3jeDMeRqsW3bGgLppPGQaoEX
         b2NEutbKKtbrUoZADLtHXQHmArNAGVhqmlgYWbbfecOtxGVXuJ4WevvlBl/WRw8hy+K1
         q1fimM1FfWs+DVW03Jh/DHjpz/isXJnbU9iXt91YuDOqTk/crSptGfm9F3QbLi40jWAm
         k1sw==
X-Gm-Message-State: APjAAAWmb3R1kbmIHI4oB3kG5yCxqwRzLA0fJkjOkkBz+4LDMCKrj05o
        ea6bse/ZgkAOAX7hdA6aiqMF+qDS/FSDutcXWLs=
X-Google-Smtp-Source: APXvYqwPt2rXVpUsZvXZyIdat6gULAdGwfteOAIefo9gQ0KsDDMGV4g3Bjeb4ktck0wmMMzqNvbKJVpSVZkVj7cY1sI=
X-Received: by 2002:a05:6214:70f:: with SMTP id b15mr19356180qvz.97.1572300721599;
 Mon, 28 Oct 2019 15:12:01 -0700 (PDT)
MIME-Version: 1.0
References: <20191025071842.7724-1-bjorn.topel@gmail.com> <20191025071842.7724-2-bjorn.topel@gmail.com>
 <20191028105508.4173bf8b@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <20191028105508.4173bf8b@cakuba.hsd1.ca.comcast.net>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Mon, 28 Oct 2019 23:11:50 +0100
Message-ID: <CAJ+HfNhVZFNV3bZPhhiAd8ObechCJ5CdODM=W1Qf0wdN97TL=w@mail.gmail.com>
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

On Mon, 28 Oct 2019 at 18:55, Jakub Kicinski
<jakub.kicinski@netronome.com> wrote:
>
> On Fri, 25 Oct 2019 09:18:40 +0200, Bj=C3=B6rn T=C3=B6pel wrote:
> > From: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
> >
> > Prior this commit, the array storing XDP socket instances were stored
> > in a separate allocated array of the XSKMAP. Now, we store the sockets
> > as a flexible array member in a similar fashion as the arraymap. Doing
> > so, we do less pointer chasing in the lookup.
> >
> > Signed-off-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
>
> Thanks for the re-spin.
>
> > diff --git a/kernel/bpf/xskmap.c b/kernel/bpf/xskmap.c
> > index 82a1ffe15dfa..a83e92fe2971 100644
> > --- a/kernel/bpf/xskmap.c
> > +++ b/kernel/bpf/xskmap.c
>
> > @@ -92,44 +93,35 @@ static struct bpf_map *xsk_map_alloc(union bpf_attr=
 *attr)
> >           attr->map_flags & ~(BPF_F_NUMA_NODE | BPF_F_RDONLY | BPF_F_WR=
ONLY))
> >               return ERR_PTR(-EINVAL);
> >
> > -     m =3D kzalloc(sizeof(*m), GFP_USER);
> > -     if (!m)
> > +     numa_node =3D bpf_map_attr_numa_node(attr);
> > +     size =3D struct_size(m, xsk_map, attr->max_entries);
> > +     cost =3D size + array_size(sizeof(*m->flush_list), num_possible_c=
pus());
>
> Now we didn't use array_size() previously because the sum here may
> overflow.
>
> We could use __ab_c_size() here, the name is probably too ugly to use
> directly and IDK what we'd have to name such a accumulation helper...
>
> So maybe just make cost and size a u64 and we should be in the clear.
>

Hmm, but both:
  int bpf_map_charge_init(struct bpf_map_memory *mem, size_t size);
  void *bpf_map_area_alloc(size_t size, int numa_node);
pass size as size_t, so casting to u64 doesn't really help on 32-bit
systems, right?

Wdyt about simply adding:
  if (cost < size)
    return ERR_PTR(-EINVAL)
after the cost calculation for explicit overflow checking?

So, if size's struct_size overflows, the allocation will fail.
And we'll catch the cost overflow with the if-statement, no?

Another option is changing the size_t in bpf_map_... to u64. Maybe
that's better, since arraymap and devmap uses u64 for cost/size.


Bj=C3=B6rn

> > +     err =3D bpf_map_charge_init(&mem, cost);
> > +     if (err < 0)
> > +             return ERR_PTR(err);
> > +
> > +     m =3D bpf_map_area_alloc(size, numa_node);
> > +     if (!m) {
> > +             bpf_map_charge_finish(&mem);
> >               return ERR_PTR(-ENOMEM);
> > +     }
> >
> >       bpf_map_init_from_attr(&m->map, attr);
> > +     bpf_map_charge_move(&m->map.memory, &mem);
> >       spin_lock_init(&m->lock);
> >
> > -     cost =3D (u64)m->map.max_entries * sizeof(struct xdp_sock *);
> > -     cost +=3D sizeof(struct list_head) * num_possible_cpus();
> > -
> > -     /* Notice returns -EPERM on if map size is larger than memlock li=
mit */
> > -     err =3D bpf_map_charge_init(&m->map.memory, cost);
> > -     if (err)
> > -             goto free_m;
> > -
> > -     err =3D -ENOMEM;
> > -
> >       m->flush_list =3D alloc_percpu(struct list_head);
> > -     if (!m->flush_list)
> > -             goto free_charge;
> > +     if (!m->flush_list) {
> > +             bpf_map_charge_finish(&m->map.memory);
> > +             bpf_map_area_free(m);
> > +             return ERR_PTR(-ENOMEM);
> > +     }
> >
> >       for_each_possible_cpu(cpu)
> >               INIT_LIST_HEAD(per_cpu_ptr(m->flush_list, cpu));
> >
> > -     m->xsk_map =3D bpf_map_area_alloc(m->map.max_entries *
> > -                                     sizeof(struct xdp_sock *),
> > -                                     m->map.numa_node);
> > -     if (!m->xsk_map)
> > -             goto free_percpu;
> >       return &m->map;
> > -
> > -free_percpu:
> > -     free_percpu(m->flush_list);
> > -free_charge:
> > -     bpf_map_charge_finish(&m->map.memory);
> > -free_m:
> > -     kfree(m);
> > -     return ERR_PTR(err);
> >  }
> >
> >  static void xsk_map_free(struct bpf_map *map)
