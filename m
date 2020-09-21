Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69B63273699
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 01:25:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728794AbgIUXZW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 19:25:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728704AbgIUXZW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 19:25:22 -0400
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C451CC061755;
        Mon, 21 Sep 2020 16:25:21 -0700 (PDT)
Received: by mail-yb1-xb44.google.com with SMTP id s19so11516830ybc.5;
        Mon, 21 Sep 2020 16:25:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=/JvXjBAMGbXXV/PxSZdZ34blnYYJeWOBOrsXHHvxARg=;
        b=VMDpWt/SCrxwrUcemyNiTiPAgV+njgvS9tZC/yuTh40WGQDL+QwvC+dRnhHpK3/F0L
         rLoHehwGBGmknbPo/TtyE92ho8+oipIka76E8zt4yY+Lr3u9UH7R/Lq3Oiolyv+tr/z5
         W1Si6OnTFifrxJFEL2U4Mxo9bi7vb1PKJxESZ66l9FbSPceYvFwsxyhwvKhLH8dEpIec
         7bc5JLK/1/2NnuMFKQjJSN74Kpu5o32PVfQZ5xhYG/gBac96woPr0ysYwOBvD5zEfE4y
         5Gv0jkpkhyVJc7vdAoN24N+Eq50c1+0gXq7vCjG9bBZbHCbhPfai4FjxVmI6xdNceEWx
         6szw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=/JvXjBAMGbXXV/PxSZdZ34blnYYJeWOBOrsXHHvxARg=;
        b=EW8I80u4BfWCpHK4HzbrTgqsboo8kzoxRtd+yt5LNW4NTlJASp2WqJ+OSlBbGq7Bbr
         IqYm/GBbSVz83IvuMVM8qoDUTHGZrVz1daBphdlfmWYiHQhOeDnGMup6NOSPMWJDoisR
         ZtRyvyENX/i83Npc3/fZJ4a8kPZAwI7CYtGVCNqVNui6j5MIusSaZE8OyW0s3ZfZninE
         IuJwKyX04LUZRVryslzNjjdwXNcbh03XH/4QkJ8aR/clAHFHhKbta57F4khzhpNngriU
         V+PMzHclUaDtJ+vWP7FhZpNQZdqM0gOIyq0J87lm9r0vzQ1cCdZ/ry1nY4OzNRPNB3L1
         V4Qg==
X-Gm-Message-State: AOAM533v2YIwg4QNch7M+Zu6ebbzO2QSry96mrmRRafKE9BoRVFJuuD/
        5CHpyxY3uhUTBPCviyeXVWPgMNP8yprjRmXK6V4=
X-Google-Smtp-Source: ABdhPJwKa0kP/03+ETw5Ba5evR9emH2uvP6AEmzsarARr9U0AVIyCju7ohNN86J9TQCbgkF8UlFJ3ks9jRrtc/U6AZk=
X-Received: by 2002:a25:4446:: with SMTP id r67mr3127767yba.459.1600730720964;
 Mon, 21 Sep 2020 16:25:20 -0700 (PDT)
MIME-Version: 1.0
References: <160051618267.58048.2336966160671014012.stgit@toke.dk> <160051619397.58048.16822043567956571063.stgit@toke.dk>
In-Reply-To: <160051619397.58048.16822043567956571063.stgit@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 21 Sep 2020 16:25:10 -0700
Message-ID: <CAEf4BzZnAFtB4Zq8dxee=B=3Z46JR4dn9wA=DOeOURB77N4yRg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v7 10/10] selftests: Add selftest for disallowing
 modify_return attachment to freplace
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

On Sat, Sep 19, 2020 at 4:50 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>
> This adds a selftest that ensures that modify_return tracing programs
> cannot be attached to freplace programs. The security_ prefix is added to
> the freplace program because that would otherwise let it pass the check f=
or
> modify_return.
>
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> ---

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  .../selftests/bpf/prog_tests/fexit_bpf2bpf.c       |   68 ++++++++++++++=
++++++
>  .../selftests/bpf/progs/fmod_ret_freplace.c        |   14 ++++
>  .../selftests/bpf/progs/freplace_get_constant.c    |    2 -
>  3 files changed, 83 insertions(+), 1 deletion(-)
>  create mode 100644 tools/testing/selftests/bpf/progs/fmod_ret_freplace.c
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/fexit_bpf2bpf.c b/too=
ls/testing/selftests/bpf/prog_tests/fexit_bpf2bpf.c
> index 27677e015730..6339d125ef9a 100644
> --- a/tools/testing/selftests/bpf/prog_tests/fexit_bpf2bpf.c
> +++ b/tools/testing/selftests/bpf/prog_tests/fexit_bpf2bpf.c
> @@ -233,6 +233,72 @@ static void test_func_replace_multi(void)
>                                   prog_name, true, test_second_attach);
>  }
>
> +static void test_fmod_ret_freplace(void)
> +{
> +       const char *tgt_name =3D "./test_pkt_access.o";
> +       const char *freplace_name =3D "./freplace_get_constant.o";
> +       const char *fmod_ret_name =3D "./fmod_ret_freplace.o";
> +       struct bpf_link *freplace_link =3D NULL, *fmod_link =3D NULL;
> +       struct bpf_object *freplace_obj =3D NULL, *pkt_obj, *fmod_obj =3D=
 NULL;
> +       struct bpf_program *prog;
> +       __u32 duration =3D 0;
> +       int err, pkt_fd;
> +
> +       err =3D bpf_prog_load(tgt_name, BPF_PROG_TYPE_UNSPEC,
> +                           &pkt_obj, &pkt_fd);
> +       /* the target prog should load fine */
> +       if (CHECK(err, "tgt_prog_load", "file %s err %d errno %d\n",
> +                 tgt_name, err, errno))
> +               return;
> +       DECLARE_LIBBPF_OPTS(bpf_object_open_opts, opts,
> +                           .attach_prog_fd =3D pkt_fd,
> +                          );

this is variable declaration, it has to be together with all the variables =
above

> +
> +       freplace_obj =3D bpf_object__open_file(freplace_name, &opts);
> +       if (CHECK(IS_ERR_OR_NULL(freplace_obj), "freplace_obj_open",
> +                 "failed to open %s: %ld\n", freplace_name,
> +                 PTR_ERR(freplace_obj)))
> +               goto out;
> +
> +       err =3D bpf_object__load(freplace_obj);
> +       if (CHECK(err, "freplace_obj_load", "err %d\n", err))
> +               goto out;
> +
> +       prog =3D bpf_program__next(NULL, freplace_obj);
> +       freplace_link =3D bpf_program__attach_trace(prog);
> +       if (CHECK(IS_ERR(freplace_link), "freplace_attach_trace", "failed=
 to link\n"))
> +               goto out;
> +
> +       opts.attach_prog_fd =3D bpf_program__fd(prog);
> +       fmod_obj =3D bpf_object__open_file(fmod_ret_name, &opts);
> +       if (CHECK(IS_ERR_OR_NULL(fmod_obj), "fmod_obj_open",
> +                 "failed to open %s: %ld\n", fmod_ret_name,
> +                 PTR_ERR(fmod_obj)))
> +               goto out;
> +
> +       err =3D bpf_object__load(fmod_obj);
> +       if (CHECK(err, "fmod_obj_load", "err %d\n", err))
> +               goto out;
> +
> +       prog =3D bpf_program__next(NULL, fmod_obj);
> +       fmod_link =3D bpf_program__attach_trace(prog);
> +       if (CHECK(!IS_ERR(fmod_link), "fmod_attach_trace",
> +                 "linking fmod_ret to freplace should fail\n"))
> +               goto out;
> +
> +out:
> +       if (!IS_ERR_OR_NULL(freplace_link))
> +               bpf_link__destroy(freplace_link);
> +       if (!IS_ERR_OR_NULL(fmod_link))
> +               bpf_link__destroy(fmod_link);
> +       if (!IS_ERR_OR_NULL(freplace_obj))
> +               bpf_object__close(freplace_obj);
> +       if (!IS_ERR_OR_NULL(fmod_obj))
> +               bpf_object__close(fmod_obj);

no need for all IS_ERR_OR_NULL checks

> +       bpf_object__close(pkt_obj);
> +}
> +
> +

[...]
