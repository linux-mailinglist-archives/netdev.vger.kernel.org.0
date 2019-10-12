Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CC6BD4CF2
	for <lists+netdev@lfdr.de>; Sat, 12 Oct 2019 06:25:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727345AbfJLEZk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Oct 2019 00:25:40 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:33941 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726278AbfJLEZj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Oct 2019 00:25:39 -0400
Received: by mail-qt1-f193.google.com with SMTP id 3so17008059qta.1;
        Fri, 11 Oct 2019 21:25:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=xFu57Uv7mYHz6TwuCO6HnCr2WI/LkU3GVw5FXCsOtlE=;
        b=gsOScwjRx5tZcQQswSZjxqLKh8NZGjPdYYxm/P7e4dbjeKQ1EVh0r70/2229I8EC5x
         mxbqeFCEMyNwLoR+LU1TgRnyTEzm/Fnw0p9aNLTbtfimfkaMmkgh1Y977hNzP748ZipB
         DODQP3b/diPeuzZ+UhjyDNXh0PGU30zJvex2bTHz9tQHi04DpW5PLN7yYN+5cNri62l9
         FGyen8hucNZ3/xoikWkZEb5yj2wztpuYW0Ok235nCpYmeGrHBR7v4ikUDQ0lIiTyQIHO
         2ZK6tjefs1ntb53b5oj7Zv4BpnhYIF9X0iyCSctksf+PBYclPmxsvJCl8RiJCxNMzpNG
         WK3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=xFu57Uv7mYHz6TwuCO6HnCr2WI/LkU3GVw5FXCsOtlE=;
        b=KgbIYg+pBALSghNRIJCV76lsKMbF8Qob5PKdyU5T7AipcfPf+1PeJUAYE/ba7xWEiL
         lWyFuvn8M3nrCQ4FAicECNOO1AqyPttlRplIU0915UlUpnisOOaAqacn0HvzJCWFqVv/
         AA6ehMNScd2xD9v0sO1A21fhpw/GgB35YQ12lnTQkdi/IKmBtwTyqvfOXwKr1pGS8+Ms
         ymfIj+N8il2UW2+GvRiIWH0H2GlKODGINwJXePn4XmVIsobGfTo+kP3pbwChhfHLXzIc
         BrcU9602aTwamUiXMgNh4JkDLx+1xzll3Qz1IyaQ7ERwsPpJxgHDOZXzToePeoG+HuGk
         gwVw==
X-Gm-Message-State: APjAAAX+6BgW3Z1ax7I2OYQbGS4w6gzguaLB3HBM0QgZtM/m/3Hg7Fid
        gsGvWItxtTnjz0fyNRlanQrzoj66z2BtXYFZDwQ=
X-Google-Smtp-Source: APXvYqxV6kU2AXZ9NcPKO+XLt1H5cMzsCgZZL7SUFRyyyS4pk7khn7n28E0Y4hyUSmdEoS2wF2XCk5zj5ndnPrpoRaI=
X-Received: by 2002:a0c:fde4:: with SMTP id m4mr9879303qvu.163.1570854338519;
 Fri, 11 Oct 2019 21:25:38 -0700 (PDT)
MIME-Version: 1.0
References: <20191010041503.2526303-1-ast@kernel.org> <20191010041503.2526303-11-ast@kernel.org>
 <CAEf4BzbmE_ADjjhu-+mLkQN_5HD6Azhrb-VuprAaoqxP1bb3OQ@mail.gmail.com> <ba51c8c3-94fc-413a-0935-aaa307127666@fb.com>
In-Reply-To: <ba51c8c3-94fc-413a-0935-aaa307127666@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 11 Oct 2019 21:25:27 -0700
Message-ID: <CAEf4BzZ1nPgz-=fHPmKKMBAEt8Yvqp7dsJ4m5FDJUC=0+8qmpw@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 10/12] bpf: check types of arguments passed
 into helpers
To:     Alexei Starovoitov <ast@fb.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "x86@kernel.org" <x86@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 11, 2019 at 6:39 PM Alexei Starovoitov <ast@fb.com> wrote:
>
> On 10/11/19 12:02 PM, Andrii Nakryiko wrote:
> > On Wed, Oct 9, 2019 at 9:15 PM Alexei Starovoitov <ast@kernel.org> wrot=
e:
> >>
> >>   /* type of values returned from helper functions */
> >> @@ -235,11 +236,17 @@ struct bpf_func_proto {
> >>          bool gpl_only;
> >>          bool pkt_access;
> >>          enum bpf_return_type ret_type;
> >> -       enum bpf_arg_type arg1_type;
> >> -       enum bpf_arg_type arg2_type;
> >> -       enum bpf_arg_type arg3_type;
> >> -       enum bpf_arg_type arg4_type;
> >> -       enum bpf_arg_type arg5_type;
> >> +       union {
> >> +               struct {
> >> +                       enum bpf_arg_type arg1_type;
> >> +                       enum bpf_arg_type arg2_type;
> >> +                       enum bpf_arg_type arg3_type;
> >> +                       enum bpf_arg_type arg4_type;
> >> +                       enum bpf_arg_type arg5_type;
> >> +               };
> >> +               enum bpf_arg_type arg_type[5];
> >> +       };
> >> +       u32 *btf_id; /* BTF ids of arguments */
> >
> > are you trying to save memory with this? otherwise not sure why it's
> > not just `u32 btf_id[5]`? Even in that case it will save at most 12
> > bytes (and I haven't even check alignment padding and stuff). So
> > doesn't seem worth it?
>
> Glad you asked :)
> It cannot be "u32 btf_id[5];".
> Guess why?

/data/users/andriin/linux/kernel/bpf/verifier.c: In function
=E2=80=98check_helper_call=E2=80=99:
/data/users/andriin/linux/kernel/bpf/verifier.c:4097:19: error:
assignment of read-only location =E2=80=98fn->btf_id[i]=E2=80=99
     fn->btf_id[i] =3D btf_resolve_helper_id(&env->log, fn->func, 0);
                   ^
That answers it :) Yeah, indirection w/ pointer is a clever hack :)

> I think it's a cool trick.
> I was happy when I finally figured out to solve it this way
> after analyzing a bunch of ugly solutions.
>
> >> + *
> >> + *             The value to write, of *size*, is passed through eBPF =
stack and
> >> + *             pointed by *data*.
> >
> > typo? pointed __to__ by *data*?
>
> I'm not an grammar expert. That was a copy paste from existing comment.
>
> >> + *
> >> + *             *ctx* is a pointer to in-kernel sutrct sk_buff.

randomly spotted "sutrct" here :)

> >> + *
> >> + *             This helper is similar to **bpf_perf_event_output**\ (=
) but
> >> + *             restricted to raw_tracepoint bpf programs.
> >
> > nit: with BTF type tracking enabled?
>
> sure.
>
> >> +       for (i =3D 0; i < 5; i++) {
> >> +               if (fn->arg_type[i] =3D=3D ARG_PTR_TO_BTF_ID) {
> >> +                       if (!fn->btf_id[i])
> >> +                               fn->btf_id[i] =3D btf_resolve_helper_i=
d(&env->log, fn->func, 0);
> >
> > bug: 0 -> i  :)
>
> Nice catch.
> Clearly I don't have a use case yet for 2nd arg being ptr_to_btf.

This actually brings an interesting question. There are a bunch of
helpers that track stuff like iphdr and so on. You could use that to
test, except you can't, because their args are not marked as
ARG_PTR_TO_BTF_ID. But marking it as such would break usual program
types that don't track BTF. I wonder if it's possible to have some
arrangement, that make the same helper be, sort of "BTF-enabled" for
BTF-enabled type of programs (so far just raw tracepoint with
attach_btf_id set), but for other programs where BTF types are not
tracked it still allows normal semantics. Thoughts?
