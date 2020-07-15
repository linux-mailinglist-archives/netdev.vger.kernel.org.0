Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E00842214D2
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 21:02:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726843AbgGOTCx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 15:02:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726472AbgGOTCw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 15:02:52 -0400
Received: from mail-qv1-xf43.google.com (mail-qv1-xf43.google.com [IPv6:2607:f8b0:4864:20::f43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71FF4C061755;
        Wed, 15 Jul 2020 12:02:52 -0700 (PDT)
Received: by mail-qv1-xf43.google.com with SMTP id e3so1392961qvo.10;
        Wed, 15 Jul 2020 12:02:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=VyAVcQaNINAmdgfn3DeUKsJSMWboAnsYMQn078/0TbU=;
        b=V7iBTIjCkRQ75iJPpcfF9bhlaL0i6on8F00Ql0ckjQGg4TTGW+i5+lcqrkQJ0aosW5
         dnHgZqQxgKJbBFtx0l6hcaurgOamtArgyKFDiS+hx5TUNLP5uO9DpfA4yqwqbfoXgBlk
         DdGNOoxLRIRHV0W8zbK0HoAo9vCUjgTC9TfNFntKAGW1sXZ7ID9kztFdJJ+gJqBqPm+d
         ECTaONlytDJywHk9/FPdIP0Bed6wGzKsMUmQchPH+TOgVNY0Y0Rmo6svR6YR/IOz5SaQ
         fbPNP+PbCXTX2j5LAPFQPkmyV3SMHBkhbJJNsmJHt2tn8/47Z7gLrAAFEHDm2qcO1WDE
         6TRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=VyAVcQaNINAmdgfn3DeUKsJSMWboAnsYMQn078/0TbU=;
        b=oUMO7PNQc1z6kytbMYO2NO60itk3MHEiVz1OcZ3yzfPFffYSBsbKEJ8JjgPmZLh9G3
         Huau63vef+gFfr5g0ioIcEub0gXMpHskjhzUxyD4Bm6KpEVDmIydNemufYcPxUh9dn6m
         YEJk42IqFGSBlKs0T7PdUWMZ5LhHZxpOP6ug7CU4ssJkVpX/8PmCydJtYDlJDco22z6V
         LJQFPiDs86ZoeS3T4Y09oTDVgPyXWflTNVp/w+MhJO6w2Fb2tOeMREOM3/QRVRj+qkOf
         T8sFmOh8Xj3lVu1GpICYdHERL2YleDGs3VIeQninGA3znaO5QxO+hi0QupR3K8vIrpzc
         A7BA==
X-Gm-Message-State: AOAM530A8lF45PD0rn/klzmcpfPRjuWKLYC1JFGMbXqw2tAtfD1bhkC7
        K0axadrrMIpb0t7LmhaHeLTibkCWIphN9DZzPHk=
X-Google-Smtp-Source: ABdhPJy27YVBp0SNnFfNG4y5YiuduvE8GtodUbjCDZeFeNn8OuYiZWGyaXKhlEoufyYGNwILWx73q2xY8SX+h/XSLE0=
X-Received: by 2002:a0c:9ae2:: with SMTP id k34mr707485qvf.247.1594839771625;
 Wed, 15 Jul 2020 12:02:51 -0700 (PDT)
MIME-Version: 1.0
References: <159467113970.370286.17656404860101110795.stgit@toke.dk>
 <159467114405.370286.1690821122507970067.stgit@toke.dk> <CAEf4BzZ_-vXP_3hSEjuceW10VX_H+EeuXMiV=_meBPZn7izK8A@mail.gmail.com>
 <87r1tegusj.fsf@toke.dk> <CAEf4Bzbu1wnwWFOWYA3e6KFeSmfg8oANPWD9LsUMRy2E_zrQ0w@mail.gmail.com>
 <87pn8xg6x7.fsf@toke.dk> <CAEf4BzYAoetyfyofTX45RQjtz3M-c9=YNeH1uRDbYgK4Ae0TwA@mail.gmail.com>
 <87d04xg2p4.fsf@toke.dk> <20200714231133.ap5qnalf6moptvfk@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20200714231133.ap5qnalf6moptvfk@ast-mbp.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 15 Jul 2020 12:02:40 -0700
Message-ID: <CAEf4Bzbqh=G5B=JwG4115icvX=Ryd_KvYcSt=GRUqfJLPiNC8A@mail.gmail.com>
Subject: Re: BPF logging infrastructure. Was: [PATCH bpf-next 4/6] tools: add
 new members to bpf_attr.raw_tracepoint in bpf.h
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Networking <netdev@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 14, 2020 at 4:11 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Wed, Jul 15, 2020 at 12:19:03AM +0200, Toke H=C3=B8iland-J=C3=B8rgense=
n wrote:
> > Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
> >
> > >> However, assuming it *is* possible, my larger point was that we
> > >> shouldn't add just a 'logging struct', but rather a 'common options
> > >> struct' which can be extended further as needed. And if it is *not*
> > >> possible to add new arguments to a syscall like you're proposing, my
> > >> suggestion above would be a different way to achieve basically the s=
ame
> > >> (at the cost of having to specify the maximum reserved space in adva=
nce).
> > >>
> > >
> > > yeah-yeah, I agree, it's less a "logging attr", more of "common attr
> > > across all commands".
> >
> > Right, great. I think we are broadly in agreement with where we want to
> > go with this, actually :)
>
> I really don't like 'common attr across all commands'.
> Both of you are talking as libbpf developers who occasionally need to
> add printk-s to the kernel.

How did you come to this conclusion?

Inability to figure out what's wrong when using BPF is at the top of
complaints from many users, together with hard to understand logs from
verifier.

> That is not an excuse to bloat api that will be
> useful to two people.

What do you mean specifically by bloat in API? I could understand how
it would bloat the API if we were to add log-related fields into every
part of bpf_attr, one for each type of commands. But that's exactly
what I advocate to not do.

But having even a slight improvement of error reporting, beyond
current -EINVAL, -E2BIG, etc, would improve experience immensely for
*all* BPF users.

>
> The only reason log_buf sort-of make sense in raw_tp_open is because
> btf comparison is moved from prog_load into raw_tp_open.
> Miscompare of (prog_fd1, btf_id1) vs (prog_fd2, btf_id2) can be easily so=
lved
> by libbpf with as nice and as human friendly message libbpf can do.
>
> I'm not convinced yet that it's a kernel job to print it nicely. It certa=
inly can,
> but it's quite a bit different from two existing bpf commands where log_b=
uf is used:
> PROG_LOAD and BTF_LOAD. In these two cases the kernel verifies the progra=
m
> and the BTF. raw_tp_open is different, since the kernel needs to compare
> that function signatures (prog_fd1, btf_id1) and (prog_fd2, btf_id2) are
> exactly the same. The kernel can indicate that with single specific errno=
 and
> libbpf can print human friendly function signatures via btf_dump infra fo=
r
> humans to see.
> So I really don't see why log_buf is such a necessity for raw_tp_open.
