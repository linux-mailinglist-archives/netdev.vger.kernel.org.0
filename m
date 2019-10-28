Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE873E7C50
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 23:26:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728302AbfJ1W0u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 18:26:50 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:42447 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728299AbfJ1W0q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Oct 2019 18:26:46 -0400
Received: by mail-lj1-f194.google.com with SMTP id a21so13061883ljh.9
        for <netdev@vger.kernel.org>; Mon, 28 Oct 2019 15:26:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=+W8NXcUMSwQU4tmWfuOjXH/YdczQr29wVj3/RDD0bRE=;
        b=kAQ5WV3bLgfo64Lew3HD3JkAqmnXGW8EGdSLFobCNrQWlHVtRSuj+9KTJt9vRTOZZZ
         1zWImeybPuLKtyihHrRQDDxKgdDLDV12tXcy+/6T4OF6Rm6T/+rbtlZ5PYqSiqN5n+du
         /kvSgzQeZvst4kWeKjfA7ViGEc+uzMl9nFufr7qYRCNwXgXNaAQXd0fOqdFGSM27itge
         phfX2YE8emB5BwDErQHOaWXJJg9k9pwe7WH/HWqK2cO0GnpFjpfMjx9c+jR3P1nJNVJH
         sGNouUkN6qlxYS9hT0sPL3krK/EHj3tYJdBhXs69TNlIPCv7uMbDcDOoqcY1iMUkBZ8f
         CVeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=+W8NXcUMSwQU4tmWfuOjXH/YdczQr29wVj3/RDD0bRE=;
        b=ESenUH/ZR6+pSMAMhFYBWH7nayf7tYt4cXF6UbI8PGV8sSyJ9moPLt1WjmRkrcdra+
         i84G90kV73a9rdUu6jiI7C6XHwepA6UjQkj+Ou/077KgEW+VlPFcuTTqqI9ZvvsxNXdq
         CEAUm/N4a0Hsg7ybZ/38Yd+5GapTuTGhZipvtly4uItDo54ay5cOuxk0h99PfiKu5NnE
         BuG9SFO5X3gxkwQ08hpDERcI4kNm7vvhuywdyjMaKjyXYtdfD5wfp8Hwb8MhV3sr2nof
         8+9Oj3onKnrP9l/P3cDs/B/znYo2BHYZDgXLtEOkZQpjvBMybjz79tnIIBpAyvDHNLK7
         +ZNg==
X-Gm-Message-State: APjAAAVqC4ZmNH5bGCEu3CkGC5icsnROS2N1kRWSC8Oyo7GFbQf3v1YJ
        nOtvdMCkgluVjt09X/IiMiYEYg==
X-Google-Smtp-Source: APXvYqwwFRD1vnHvtflc3Mc6RCCZDoEmrCV9uRcWlO/RBW6fjxl0Jr5nT+DXCW+hUsW8kJVT8gRr/A==
X-Received: by 2002:a2e:3304:: with SMTP id d4mr117466ljc.142.1572301604235;
        Mon, 28 Oct 2019 15:26:44 -0700 (PDT)
Received: from cakuba.hsd1.ca.comcast.net ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id u26sm6050415lfd.19.2019.10.28.15.26.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Oct 2019 15:26:43 -0700 (PDT)
Date:   Mon, 28 Oct 2019 15:26:29 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        bpf <bpf@vger.kernel.org>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNl?= =?UTF-8?B?bg==?= 
        <toke@redhat.com>
Subject: Re: [PATCH bpf-next v2 1/2] xsk: store struct xdp_sock as a
 flexible array member of the XSKMAP
Message-ID: <20191028152629.0dec07d1@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <CAJ+HfNhVZFNV3bZPhhiAd8ObechCJ5CdODM=W1Qf0wdN97TL=w@mail.gmail.com>
References: <20191025071842.7724-1-bjorn.topel@gmail.com>
        <20191025071842.7724-2-bjorn.topel@gmail.com>
        <20191028105508.4173bf8b@cakuba.hsd1.ca.comcast.net>
        <CAJ+HfNhVZFNV3bZPhhiAd8ObechCJ5CdODM=W1Qf0wdN97TL=w@mail.gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 28 Oct 2019 23:11:50 +0100, Bj=C3=B6rn T=C3=B6pel wrote:
> On Mon, 28 Oct 2019 at 18:55, Jakub Kicinski
> <jakub.kicinski@netronome.com> wrote:
> >
> > On Fri, 25 Oct 2019 09:18:40 +0200, Bj=C3=B6rn T=C3=B6pel wrote: =20
> > > From: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
> > >
> > > Prior this commit, the array storing XDP socket instances were stored
> > > in a separate allocated array of the XSKMAP. Now, we store the sockets
> > > as a flexible array member in a similar fashion as the arraymap. Doing
> > > so, we do less pointer chasing in the lookup.
> > >
> > > Signed-off-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com> =20
> >
> > Thanks for the re-spin.
> > =20
> > > diff --git a/kernel/bpf/xskmap.c b/kernel/bpf/xskmap.c
> > > index 82a1ffe15dfa..a83e92fe2971 100644
> > > --- a/kernel/bpf/xskmap.c
> > > +++ b/kernel/bpf/xskmap.c =20
> > =20
> > > @@ -92,44 +93,35 @@ static struct bpf_map *xsk_map_alloc(union bpf_at=
tr *attr)
> > >           attr->map_flags & ~(BPF_F_NUMA_NODE | BPF_F_RDONLY | BPF_F_=
WRONLY))
> > >               return ERR_PTR(-EINVAL);
> > >
> > > -     m =3D kzalloc(sizeof(*m), GFP_USER);
> > > -     if (!m)
> > > +     numa_node =3D bpf_map_attr_numa_node(attr);
> > > +     size =3D struct_size(m, xsk_map, attr->max_entries);
> > > +     cost =3D size + array_size(sizeof(*m->flush_list), num_possible=
_cpus()); =20
> >
> > Now we didn't use array_size() previously because the sum here may
> > overflow.
> >
> > We could use __ab_c_size() here, the name is probably too ugly to use
> > directly and IDK what we'd have to name such a accumulation helper...
> >
> > So maybe just make cost and size a u64 and we should be in the clear.
> > =20
>=20
> Hmm, but both:
>   int bpf_map_charge_init(struct bpf_map_memory *mem, size_t size);
>   void *bpf_map_area_alloc(size_t size, int numa_node);
> pass size as size_t, so casting to u64 doesn't really help on 32-bit
> systems, right?

Yup :( IOW looks like the overflows will not be caught on 32bit
machines in all existing code that does the (u64) cast. I hope=20
I'm wrong there.

> Wdyt about simply adding:
>   if (cost < size)
>     return ERR_PTR(-EINVAL)
> after the cost calculation for explicit overflow checking?

We'd need that for all users of these helpers. Could it perhaps makes
sense to pass "alloc_size" and "extra_cost" as separate size_t to
bpf_map_charge_init() and then we can do the overflow checking there,
centrally?

We can probably get rid of all the u64 casting too at that point,
and use standard overflow helpers, yuppie :)

> So, if size's struct_size overflows, the allocation will fail.
> And we'll catch the cost overflow with the if-statement, no?
>=20
> Another option is changing the size_t in bpf_map_... to u64. Maybe
> that's better, since arraymap and devmap uses u64 for cost/size.
