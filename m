Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A54F32669FA
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 23:21:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725847AbgIKVVW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 17:21:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725815AbgIKVVU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 17:21:20 -0400
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89F7DC061573;
        Fri, 11 Sep 2020 14:21:20 -0700 (PDT)
Received: by mail-yb1-xb44.google.com with SMTP id s19so2230607ybc.5;
        Fri, 11 Sep 2020 14:21:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=DLewDH8B32UDJC7zgttlgNRwhvOuSjPN288ZDKEUvDw=;
        b=XQpQdLuPV4mEHOZSOP/ga4DxclfecHC26hxctghYPbVHqPIJ9JnDaWmQdXenk2TPzf
         +ACMY9iKwh6UrQl/Yl4AnCONTIpyQN2UWMwxnHNxoEKdPLIVYslhfsssM1H2+HNJ7kl8
         jrvSvHfneYBmmTptzkSJIKl0lUdhOqBGSA/FdYmrL2rbrQVQR3GRUVNQZFCjmqHEkBwI
         7w8LpzQDKVCs/hlpspF7AohgTWn1wm7B7BYyBY0nloQwhHdzgfU8OOwWcgpKfbrO7THU
         HM/Dyb1NfoSyIBEqsMQGI9s0gATsXKtl6owy2PYjpDqIdlASQHeVPPw1dhauE5TWCurL
         7zQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=DLewDH8B32UDJC7zgttlgNRwhvOuSjPN288ZDKEUvDw=;
        b=HkLOLiigvExzT8cNsCh4guf0Z+jkVYlA5Q95QrYX4NcUMFCggdn1XRuuvjTLSQs20H
         BolAwP4Akl87yXh3i/ITS5HMi7SIxHQBlvUIb3zgcE+CPog087S1DnR7eJ7D4BnsBKf4
         IVrZVIf2gm7URghzPQfaTdAuoGDAeFSc/wkIecxUFoPbVqOuPp+mgYegAcZ6cBO704re
         hU+bvv+Lsjd3iSaVddnAEQJw2ja/If012mbCFCSEk/eLLXiVXYvUEnK40KGSUxAk8rdO
         eIh09uBboMQqacxiJROZbEcK83RWhD90BEn/inbWNKKrqTdFxnLyQsOfWERgyZJqzxIg
         DduQ==
X-Gm-Message-State: AOAM533c4kev3jUuu97dtyJ2g3Svsb0zou5aVn4ck4s/g+g8r/HvtL53
        MQDaMdmn7gqEpdFMIW/v18qAHIUXjOOZtDLMDJY=
X-Google-Smtp-Source: ABdhPJx5D/ucU0li4jM7XSgoVzyjsfkE7XJ8aNX3w5E9wSH4R7YSaHouU82SlrOzoda+GCxWohDNF/NBMO7/WcIvzhM=
X-Received: by 2002:a25:7b81:: with SMTP id w123mr5490058ybc.260.1599859279381;
 Fri, 11 Sep 2020 14:21:19 -0700 (PDT)
MIME-Version: 1.0
References: <159981835466.134722.8652987144251743467.stgit@toke.dk> <159981836238.134722.1932000789183895507.stgit@toke.dk>
In-Reply-To: <159981836238.134722.1932000789183895507.stgit@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 11 Sep 2020 14:21:08 -0700
Message-ID: <CAEf4BzY3NpGvE6qW0Uiuzqch95tmh1xXiVHs0oviT_bb8R0Wdw@mail.gmail.com>
Subject: Re: [PATCH RESEND bpf-next v3 7/9] libbpf: add support for supplying
 target to bpf_raw_tracepoint_open()
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
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 11, 2020 at 3:00 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>
> This adds support for supplying a target fd and btf ID for the
> raw_tracepoint_open() BPF operation, using a new bpf_raw_tracepoint_opts
> structure. This can be used for attaching freplace programs to multiple
> destinations.
>
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> ---
>  tools/lib/bpf/bpf.c      |   13 ++++++++++++-
>  tools/lib/bpf/bpf.h      |    9 +++++++++
>  tools/lib/bpf/libbpf.map |    1 +
>  3 files changed, 22 insertions(+), 1 deletion(-)
>
> diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
> index 82b983ff6569..25c62993c406 100644
> --- a/tools/lib/bpf/bpf.c
> +++ b/tools/lib/bpf/bpf.c
> @@ -804,17 +804,28 @@ int bpf_obj_get_info_by_fd(int bpf_fd, void *info, =
__u32 *info_len)
>         return err;
>  }
>
> -int bpf_raw_tracepoint_open(const char *name, int prog_fd)
> +int bpf_raw_tracepoint_open_opts(const char *name, int prog_fd,

We've had discussion around naming low-level APIs with options and
agreed with Andrey Ignatov that we'll follow the _xattr suffix naming
for low-level APIs. So let's keep it consistent, I suppose...

Please also add bpf_program__attach_trace_opts() for high-level API.

> +                                struct bpf_raw_tracepoint_opts *opts)
>  {
>         union bpf_attr attr;
>
> +       if (!OPTS_VALID(opts, bpf_raw_tracepoint_opts))
> +               return -EINVAL;
> +
>         memset(&attr, 0, sizeof(attr));
>         attr.raw_tracepoint.name =3D ptr_to_u64(name);
>         attr.raw_tracepoint.prog_fd =3D prog_fd;
> +       attr.raw_tracepoint.tgt_prog_fd =3D OPTS_GET(opts, tgt_prog_fd, 0=
);
> +       attr.raw_tracepoint.tgt_btf_id =3D OPTS_GET(opts, tgt_btf_id, 0);
>
>         return sys_bpf(BPF_RAW_TRACEPOINT_OPEN, &attr, sizeof(attr));
>  }
>

[...]
