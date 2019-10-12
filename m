Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27059D4CFB
	for <lists+netdev@lfdr.de>; Sat, 12 Oct 2019 06:39:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727117AbfJLEji (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Oct 2019 00:39:38 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:41575 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725308AbfJLEji (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Oct 2019 00:39:38 -0400
Received: by mail-qk1-f195.google.com with SMTP id p10so10853425qkg.8;
        Fri, 11 Oct 2019 21:39:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PU5A0rMo6h/AN53yEdMkH1cbtwmXRZQw5wdGeCa2KK8=;
        b=rH4YOcA8D2zHbbv+8A20cwEv1kgqdl871UA/bSFC0+LnA1wWU7ap04XyZyNvRZNqqY
         iYhRoxNM1zN86SkIVNKInAYHCQFqUfvG31rs/61l0V/sTLVoXy7MFBDIc7XHsRlV0zFk
         Yj6a6ggjQiQtUcgEas+I0DgFL/bj1yA2li2vtBsQKoULxZgrRKZmfLuN+0gSwp0B98tI
         yMWOaeM/U5oqiaFw5yqIgZUaW2QqylA4Rx9IOtDdbzwUu8Gge8Vimx/NIpnfdbaq+tJX
         cF1HyxosD6b4YmQRTsiQr1oW0t2tms5AAWIJI4Fb+XkuQ8GZrOjXoTM1n247MrHsvT33
         1H/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PU5A0rMo6h/AN53yEdMkH1cbtwmXRZQw5wdGeCa2KK8=;
        b=QcRc+Tjw3E4mpP/gf8kp1egEMjc6p3djJceN4mto5/NcaTXxDumKBb2S0PtMr+Dibn
         4umBrBh+ga9jHZUlS6AlNDIAuZ+Fq++LE8N+QTA/FfiyR281q+hTOva11ButLbw6Sr6T
         XSvE+Q9rJ7w2/6ybwqmxxO46vMiSW2yWbWCVT6ZUP5HsrbNC7zob7IPfcm24041UIuWZ
         N9UEx5FVO1JfgHmhPszNneJEmMLVYUmixGj8KcB7GfMhu9RMBSyduKLd3mk61g1mxNEE
         nXs/1x1GNAo7DXPZMo2lnIcGTqKqfN+tDDeydEcpC/aGBukeuHcXsNPtMfosmRKQ/dUk
         DHQA==
X-Gm-Message-State: APjAAAXPG7snpmgSHy/JB4ICQHnMMFVfOT94hJ3zZrRbAcavwlkvwUss
        HFJ2OiclYYwlI9XwDN+thhm6HohD9KDHALp6/JA=
X-Google-Smtp-Source: APXvYqwDUy47yvolLXAO+7gLVvTCyyP8lSqDsZ8RC03KEzBnPA0+ToQPaNJ7CeeBsHmmZ7lWG8eI3FJu6LEmMuJzEcY=
X-Received: by 2002:a37:6d04:: with SMTP id i4mr19931385qkc.36.1570855176965;
 Fri, 11 Oct 2019 21:39:36 -0700 (PDT)
MIME-Version: 1.0
References: <20191010041503.2526303-1-ast@kernel.org> <20191010041503.2526303-6-ast@kernel.org>
 <CAEf4BzZxQDUzYYjF091135d+O_fwZVdK9Dqw5H4_z=5QBqueYg@mail.gmail.com> <0dbf83e8-10ec-cc17-c575-949639a7f018@fb.com>
In-Reply-To: <0dbf83e8-10ec-cc17-c575-949639a7f018@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 11 Oct 2019 21:39:25 -0700
Message-ID: <CAEf4BzYG1dkMtmpg=_MptE0pKMtSuoYk8W7MxJqzRLY_fTkyKA@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 05/12] libbpf: auto-detect btf_id of raw_tracepoint
To:     Alexei Starovoitov <ast@fb.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "x86@kernel.org" <x86@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 11, 2019 at 5:40 PM Alexei Starovoitov <ast@fb.com> wrote:
>
> On 10/11/19 11:07 AM, Andrii Nakryiko wrote:
> > On Wed, Oct 9, 2019 at 9:17 PM Alexei Starovoitov <ast@kernel.org> wrote:
> >>
> >> For raw tracepoint program types libbpf will try to find
> >> btf_id of raw tracepoint in vmlinux's BTF.
> >> It's a responsiblity of bpf program author to annotate the program
> >> with SEC("raw_tracepoint/name") where "name" is a valid raw tracepoint.
> >> If "name" is indeed a valid raw tracepoint then in-kernel BTF
> >> will have "btf_trace_##name" typedef that points to function
> >> prototype of that raw tracepoint. BTF description captures
> >> exact argument the kernel C code is passing into raw tracepoint.
> >> The kernel verifier will check the types while loading bpf program.
> >>
> >> libbpf keeps BTF type id in expected_attach_type, but since
> >> kernel ignores this attribute for tracing programs copy it
> >> into attach_btf_id attribute before loading.
> >>
> >> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> >> ---
> >>   tools/lib/bpf/bpf.c    |  3 +++
> >>   tools/lib/bpf/libbpf.c | 17 +++++++++++++++++
> >>   2 files changed, 20 insertions(+)
> >>
> >> diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
> >> index cbb933532981..79046067720f 100644
> >> --- a/tools/lib/bpf/bpf.c
> >> +++ b/tools/lib/bpf/bpf.c
> >> @@ -228,6 +228,9 @@ int bpf_load_program_xattr(const struct bpf_load_program_attr *load_attr,
> >>          memset(&attr, 0, sizeof(attr));
> >>          attr.prog_type = load_attr->prog_type;
> >>          attr.expected_attach_type = load_attr->expected_attach_type;
> >> +       if (attr.prog_type == BPF_PROG_TYPE_RAW_TRACEPOINT)
> >> +               /* expected_attach_type is ignored for tracing progs */
> >> +               attr.attach_btf_id = attr.expected_attach_type;
> >>          attr.insn_cnt = (__u32)load_attr->insns_cnt;
> >>          attr.insns = ptr_to_u64(load_attr->insns);
> >>          attr.license = ptr_to_u64(load_attr->license);
> >> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> >> index a02cdedc4e3f..8bf30a67428c 100644
> >> --- a/tools/lib/bpf/libbpf.c
> >> +++ b/tools/lib/bpf/libbpf.c
> >> @@ -4586,6 +4586,23 @@ int libbpf_prog_type_by_name(const char *name, enum bpf_prog_type *prog_type,
> >>                          continue;
> >>                  *prog_type = section_names[i].prog_type;
> >>                  *expected_attach_type = section_names[i].expected_attach_type;
> >> +               if (*prog_type == BPF_PROG_TYPE_RAW_TRACEPOINT) {
> >> +                       struct btf *btf = bpf_core_find_kernel_btf();
> >> +                       char raw_tp_btf_name[128] = "btf_trace_";
> >> +                       char *dst = raw_tp_btf_name + sizeof("btf_trace_") - 1;
> >> +                       int ret;
> >> +
> >> +                       if (IS_ERR(btf))
> >> +                               /* lack of kernel BTF is not a failure */
> >> +                               return 0;
> >> +                       /* prepend "btf_trace_" prefix per kernel convention */
> >> +                       strncat(dst, name + section_names[i].len,
> >> +                               sizeof(raw_tp_btf_name) - (dst - raw_tp_btf_name));
> >> +                       ret = btf__find_by_name(btf, raw_tp_btf_name);
> >> +                       if (ret > 0)
> >> +                               *expected_attach_type = ret;
> >
> > Well, actually, I realized after I gave Acked-by, so not yet :)
> >
> > This needs kernel feature probe of whether kernel supports specifying
> > attach_btf_id, otherwise on older kernels we'll stop successfully
> > loading valid program.
>
> The code above won't find anything on older kernels.
> The patch 1 of the series has to be there for proper btf to be
> generated by pahole.
> Before that happens expected_attach_type will stay zero
> and corresponding copy in attach_btf_id will be zero as well.
> I see no issues being compatible with older kernels.

indeed, this one is not an issue.

>
> > But even if kernel supports attach_btf_id, I think users still need to
> > opt in into specifying attach_btf_id by libbpf. Think about existing
> > raw_tp programs that are using bpf_probe_read() because they were not
> > created with this kernel feature in mind. They will suddenly stop
> > working without any of user's fault.
>
> This one is excellent catch.
> loop1.c should have caught it, since it has
> SEC("raw_tracepoint/kfree_skb")
> {
>    int nested_loops(volatile struct pt_regs* ctx)
>     .. = PT_REGS_RC(ctx);
>
> and verifier would have rejected it.
> But the way the test is written it's not using libbpf's autodetect
> of program type, so everything is passing.
