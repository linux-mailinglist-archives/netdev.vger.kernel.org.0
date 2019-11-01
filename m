Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 606ECEBF39
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 09:31:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730288AbfKAIbT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 04:31:19 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:37943 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730178AbfKAIbT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Nov 2019 04:31:19 -0400
Received: by mail-qt1-f196.google.com with SMTP id t26so12013876qtr.5;
        Fri, 01 Nov 2019 01:31:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=85jQntHdwZ7NNoYlz56MOfQOzIghN40YqD7QNYQWWc4=;
        b=VvyCwvchngcy0PF0WwTySW0FVAFhNhJxQpObQMO5sQ10JGVb11b0R11dXLrBzyQ2dg
         o/kbmF5BP4v0G7szLGvIPPyU+HqpM+ZgWxhEiZE53lt84usmVAOcCOVRag3a8c/q4zck
         5ApD5f8vv+L1d1KWXXgghZNziF3dZoYkmk1XJM9acAr5BdCWXhRdHVxaYR4v5gLfhRKM
         3KChd7uVcN8wVHW2pqbLQstV1NX2wJaX0OrMec517zbHPkWrFRDz7ar0vaSycO4ktwuC
         0pjjLEvy1i1VVcNnc5GQZYvOAznSmnZQqz2K6HqsWWRgjJJiAW+jO62l4tq4pqbN1EOR
         c0gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=85jQntHdwZ7NNoYlz56MOfQOzIghN40YqD7QNYQWWc4=;
        b=SJxgNh6wH+rKEO4cmXI1FivIA4tLTPAV+HXIacHctXroDBbyITQMchZc8HDBGwd3Vd
         txAvmwCBg0gIZqWqHkkn7iGFKI6P8z2Vg2dwrXxvlXzwgWdzXDFq7IW+ewQgpHM9B1xb
         YZXFNdCswzGkO2H0c8+ybgMOOKxVN5bo/av0Pqcf8aiuSzuQmOELNC8FW+X4VIfdZezx
         YGb9hhKVNoDKiMe4UybYR8S16jsENM1hCYg9knbyLmaWtHanPbKEqR/z0jNMbDjlFYzg
         eP8G8tDpR3Q9o295I9R2tqcIHmNHkHl6G/NSux/ebNU56SbfxPAe1K+1M7bGT1ziyEg5
         ytRg==
X-Gm-Message-State: APjAAAVtXtUL+xkQ+kwMt/vQHFb+uIrRgJSzXsd+/3wfg/la+++F95Nl
        rtaovTZruG8AOO3zesRSYa8STSCJUh3HiZMoRcU=
X-Google-Smtp-Source: APXvYqxzDU+h/SfDg79vd3rLdR4QtF8B9kHraWvhIyhED7fObjAwFkn9w4OexVWLM/swqb7/2GtiROBCO1mFey7MWo8=
X-Received: by 2002:a0c:94fb:: with SMTP id k56mr9011768qvk.127.1572597076393;
 Fri, 01 Nov 2019 01:31:16 -0700 (PDT)
MIME-Version: 1.0
References: <20191031084749.14626-1-bjorn.topel@gmail.com> <20191031084749.14626-3-bjorn.topel@gmail.com>
 <20191031234804.GA20080@pc-63.home>
In-Reply-To: <20191031234804.GA20080@pc-63.home>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Fri, 1 Nov 2019 09:31:04 +0100
Message-ID: <CAJ+HfNgAggmm0ti09O8MeyZ+qwWpug-_kHRZQFaMROUC5B3LDQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 2/3] bpf: implement map_gen_lookup() callback
 for XSKMAP
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Netdev <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        bpf <bpf@vger.kernel.org>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 1 Nov 2019 at 00:48, Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On Thu, Oct 31, 2019 at 09:47:48AM +0100, Bj=C3=B6rn T=C3=B6pel wrote:
> > From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
[...]
> > +static u32 xsk_map_gen_lookup(struct bpf_map *map, struct bpf_insn *in=
sn_buf)
> > +{
> > +     const int ret =3D BPF_REG_0, mp =3D BPF_REG_1, index =3D BPF_REG_=
2;
> > +     struct bpf_insn *insn =3D insn_buf;
> > +
> > +     *insn++ =3D BPF_LDX_MEM(BPF_W, ret, index, 0);
> > +     *insn++ =3D BPF_JMP_IMM(BPF_JGE, ret, map->max_entries, 5);
> > +     *insn++ =3D BPF_ALU64_IMM(BPF_LSH, ret, ilog2(sizeof(struct xsk_s=
ock *)));
> > +     *insn++ =3D BPF_ALU64_IMM(BPF_ADD, mp, offsetof(struct xsk_map, x=
sk_map));
> > +     *insn++ =3D BPF_ALU64_REG(BPF_ADD, ret, mp);
> > +     *insn++ =3D BPF_LDX_MEM(BPF_DW, ret, ret, 0);
>
> Your map slots are always exactly sizeof(struct xdp_sock *), right? Would=
n't
> this BPF_DW crash on 32 bit?
>
> Meaning, it would have to be BPF_LDX_MEM(BPF_SIZEOF(struct xsk_sock *), .=
..)?
>

Indeed. Thanks for finding this. I'll do a respin.

Bj=C3=B6rn
