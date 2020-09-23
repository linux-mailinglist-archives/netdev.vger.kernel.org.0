Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AE0E275E8E
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 19:25:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726667AbgIWRZq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 13:25:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726332AbgIWRZq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 13:25:46 -0400
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 424DBC0613CE;
        Wed, 23 Sep 2020 10:25:46 -0700 (PDT)
Received: by mail-yb1-xb43.google.com with SMTP id v60so308264ybi.10;
        Wed, 23 Sep 2020 10:25:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=kWOrvkuGzGPsC3zloyFmNac+ukysTeJknc2HiMKEFM4=;
        b=uEUc6m1YvQbjpGQ5mQ/LuCPJCXTRHR6hZgvlV57Mo5O3zzIKTs48Oqhg4YtRdEVStC
         fKrfL7gmtQy1ZUExlIPlKnycMlvg6DZARTSdKXWFSbAwqF3nJItshb732BvfXqK+HjBw
         894eG8sT+nfeC5hJnjcBPePM25eeTJUELdNkm86YRgJ8qecZJFRoeyuAY7Z8D8YqMy6d
         7PQoVTPpjtjoD6NXMzGidLllJxp5AHUtYFYbEtmx4S7PU9tMft/TW24svbCaoQo3RO1A
         H49mXkipIFZrh0ftpOeFx3MEQyXdGRP1lG1ztqpdCYpEhjID9wDYcjMIe9L1u53Xy+gh
         sSLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=kWOrvkuGzGPsC3zloyFmNac+ukysTeJknc2HiMKEFM4=;
        b=d0iL1Bb2GK2K1ZCIi435T9RI2CrLV5XzOKfzYMlCiHWt4rUDmZ6Wn0Uca9JanWjH7F
         Em3LVVdMXsDlijqBic1IGBTqTh3FPcBv4Fuu0pMq5cQNIAvDqgS7gQJd0w34a71tvfis
         koQR0R4XRdWygvd4aTgS2cSdpYnj/OHQswGeZ7LGkFhh4BngE1NMdxJdiyQ03ijXeUZ0
         iPZytsltUrpjuPfeYWUT+FbEE9c7ZK9ElKt4JldtzyeU64X6H/0yldxQLBbMmfOpd9dp
         KLEtI52RA/b4PTbNhDAFnnUkKlZM6VWPNi1TuPeb17rwkEpLHq0H44gKmcmwPZdQVAcs
         gl2g==
X-Gm-Message-State: AOAM5318coR74mSk3kdybDHJpTwT+QhC03Vl/CTz+2Duk/4jdz8CHD8H
        9QLzWKUFlEXw5NaSeVDBx//j3TA19bUsjLQZStM=
X-Google-Smtp-Source: ABdhPJxKC0eyQ+uFgRidhjfs9AHxbZqx48WHA0SoOy4cTXjICj0NWtMA2t1aZrLMkxrDUI7WOA0tX6j43LG1MYim308=
X-Received: by 2002:a25:9d06:: with SMTP id i6mr1479214ybp.510.1600881945512;
 Wed, 23 Sep 2020 10:25:45 -0700 (PDT)
MIME-Version: 1.0
References: <160079991372.8301.10648588027560707258.stgit@toke.dk> <160079991486.8301.10483022567832542496.stgit@toke.dk>
In-Reply-To: <160079991486.8301.10483022567832542496.stgit@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 23 Sep 2020 10:25:34 -0700
Message-ID: <CAEf4Bzb_f9fOaSYsL=DJkyuV0hTWgDZHpn8GUrrULE_dsC+o=w@mail.gmail.com>
Subject: Re: [PATCH bpf-next v8 01/11] bpf: disallow attaching modify_return
 tracing functions to other BPF programs
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

On Tue, Sep 22, 2020 at 11:39 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@red=
hat.com> wrote:
>
> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>
> From the checks and commit messages for modify_return, it seems it was
> never the intention that it should be possible to attach a tracing progra=
m
> with expected_attach_type =3D=3D BPF_MODIFY_RETURN to another BPF program=
.
> However, check_attach_modify_return() will only look at the function name=
,
> so if the target function starts with "security_", the attach will be
> allowed even for bpf2bpf attachment.
>
> Fix this oversight by also blocking the modification if a target program =
is
> supplied.
>
> Fixes: 18644cec714a ("bpf: Fix use-after-free in fmod_ret check")
> Fixes: 6ba43b761c41 ("bpf: Attachment verification for BPF_MODIFY_RETURN"=
)
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> ---

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  kernel/bpf/verifier.c |    5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index 15ab889b0a3f..797e2b0d8bc2 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -11471,6 +11471,11 @@ static int check_attach_btf_id(struct bpf_verifi=
er_env *env)
>                                 verbose(env, "%s is not sleepable\n",
>                                         prog->aux->attach_func_name);
>                 } else if (prog->expected_attach_type =3D=3D BPF_MODIFY_R=
ETURN) {
> +                       if (tgt_prog) {
> +                               verbose(env, "can't modify return codes o=
f BPF programs\n");
> +                               ret =3D -EINVAL;
> +                               goto out;
> +                       }
>                         ret =3D check_attach_modify_return(prog, addr);
>                         if (ret)
>                                 verbose(env, "%s() is not modifiable\n",
>
