Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A7F1273690
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 01:19:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728814AbgIUXTA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 19:19:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728712AbgIUXTA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 19:19:00 -0400
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58BB1C061755;
        Mon, 21 Sep 2020 16:19:00 -0700 (PDT)
Received: by mail-yb1-xb41.google.com with SMTP id 133so4220573ybg.11;
        Mon, 21 Sep 2020 16:19:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=QJUxRgiR0v3ZMO04GOVBgOH6wTgbfBMvgq8YZpvWH64=;
        b=FK/rNCgVt6x2whYc6aywikM7fpAEMerQq/hXVRPs5R88QCIF987Rmwa8hCt1y54Pzn
         RHw+s8YYoWaYZAZZCp4dQd6G4MbHknWI98rHm3WZNQY76SxcJNdIFwWTVwgEojyyG3E8
         /483geOvhwh6h9nUrhwYaWcdR2X+1AdDpZbLb/ZJhHXfOjeAb4zMk142rsmmwyRXVTl8
         hIl2WQfo0jeh/wLVg5J7Ozy2djXU0ZQojYlPOxAGc5Q5YT/3HzM20YNz676hyV86JbMw
         BdlFLwu9IxFpPSnsFRoQ5R3pQ2MmIR+NARBdO97N4Unp6MOAz8GPEQT60sPBFKIcQULQ
         0gGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=QJUxRgiR0v3ZMO04GOVBgOH6wTgbfBMvgq8YZpvWH64=;
        b=NZeHzHIZxxpoJpB2mjaLHOw562SA2Ab3+mO7x33vlq3shUbDHIEkrQ/0M6ciVMAHuL
         FbiTZDLZQGojlQW953n8NfkHzWc+kgyHd3cGQDr1U+gyT09DojfLDvTLeqFxIgxQHLyR
         P545ifziXfkBaTE3Z0I6MvtN2G/dWzwf66w0xIZzq2CBs7nILWNxq9nS8BeXVhHxNgpr
         rPLxmVdPqfYU7pOV3qs4gxrgeJ/ZlEaML4JnBJqOc0Z40qlBjoQu46AGSkxVjSK4nq2c
         /Q5MvWlvN5pUYTQ8B3XI30Ytnxs1YHLUeYjnvRoR5JlkdoRCMMoBYdLJ6ZjLd08SlGFZ
         cTkw==
X-Gm-Message-State: AOAM533mSmSZYmi0T1DvJxXHnuiz0RL+enHHhqVli5d6VCicnhthp+Mu
        WwT9E+wHnYOMoQYWMMKsBR6DmZ1kOfwrtW8nPGY0HKpM9fQ=
X-Google-Smtp-Source: ABdhPJzJMzzJoeTi+OX1WRbyTwgD3wtfCul605973K6jY+Ivf82BosNT7rtCe0u2aqHKWwfVELqt3S8iCTg8bJgIddA=
X-Received: by 2002:a25:8541:: with SMTP id f1mr2872140ybn.230.1600730339641;
 Mon, 21 Sep 2020 16:18:59 -0700 (PDT)
MIME-Version: 1.0
References: <160051618267.58048.2336966160671014012.stgit@toke.dk> <160051619067.58048.3593613677214772554.stgit@toke.dk>
In-Reply-To: <160051619067.58048.3593613677214772554.stgit@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 21 Sep 2020 16:18:48 -0700
Message-ID: <CAEf4BzZHAgEn3dodbqZVp==7d_KsC4nuS-AwgFvAjDFiF4L4BA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v7 07/10] libbpf: add support for freplace
 attachment in bpf_link_create
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        KP Singh <kpsingh@chromium.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 19, 2020 at 4:51 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>
> This adds support for supplying a target btf ID for the bpf_link_create()
> operation, and adds a new bpf_program__attach_freplace() high-level API f=
or
> attaching freplace functions with a target.
>
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> ---
>  tools/lib/bpf/bpf.c      |   18 +++++++++++++++---
>  tools/lib/bpf/bpf.h      |    3 ++-
>  tools/lib/bpf/libbpf.c   |   36 +++++++++++++++++++++++++++++++-----
>  tools/lib/bpf/libbpf.h   |    3 +++
>  tools/lib/bpf/libbpf.map |    1 +
>  5 files changed, 52 insertions(+), 9 deletions(-)
>

Looks good, but let's add meaningful error messages, especially that
it's so trivial to do and obvious what exactly is wrong.

> +struct bpf_link *bpf_program__attach_freplace(struct bpf_program *prog,
> +                                             int target_fd,
> +                                             const char *attach_func_nam=
e)
> +{
> +       int btf_id;
> +
> +       if (!!target_fd !=3D !!attach_func_name || prog->type !=3D BPF_PR=
OG_TYPE_EXT)
> +               return ERR_PTR(-EINVAL);

Can you please split those two and have separate error messages for
both, following libbpf's format, e.g.,:

prog '%s': should be freplace program type

and

prog '%s': either both or none of target FD and target function name
should be provided

> +
> +       if (target_fd) {
> +

nit: why empty line?

> +               btf_id =3D libbpf_find_prog_btf_id(attach_func_name, targ=
et_fd);
> +               if (btf_id < 0)
> +                       return ERR_PTR(btf_id);
> +
> +               return bpf_program__attach_fd(prog, target_fd, btf_id, "f=
replace");
> +       } else {
> +               /* no target, so use raw_tracepoint_open for compatibilit=
y
> +                * with old kernels
> +                */
> +               return bpf_program__attach_trace(prog);
> +       }
>  }
>

[...]
