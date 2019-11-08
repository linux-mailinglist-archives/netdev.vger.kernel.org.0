Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BF3AF5B55
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 23:51:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728235AbfKHWu4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 17:50:56 -0500
Received: from mail-qk1-f196.google.com ([209.85.222.196]:43770 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726095AbfKHWuz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 17:50:55 -0500
Received: by mail-qk1-f196.google.com with SMTP id z23so6720089qkj.10;
        Fri, 08 Nov 2019 14:50:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=7nSB+QohS5sigWBoZJznnXIK0WJL+cpXl/mjxZlP6Gw=;
        b=mhMibkO9sXhsew/qx7eYsa3KqD/WTIpFkrSH5CTBSZnTJl5+uIQLu4LaahwBAc5PfO
         qh+euGm4WDtb6AwHzzMKkHYBHgsuv+519dL3Jhv7wnWIVk92P0avf0Oo6gxw0v1HNeR7
         8BVsy4cEa27mRmW71WnGSbDXRKG3WRVLn5nzvO8BywoqB7vO1FUhEZZp2bUPlbLnGnjZ
         k/HxX+jplUHx7FBdKpHZRGARjsk4PPK4mNGpsKe69Yq9x1B3mJvs4X4UCN+LHQtsF5Jp
         3wuOwyw2Wuj0MgZE1IK7UMpUw6jsYL7WtiCPtFz3pvN4o5n23FcnC2SDzg0hPj6I1JDh
         hirw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=7nSB+QohS5sigWBoZJznnXIK0WJL+cpXl/mjxZlP6Gw=;
        b=aQ3AObqbIdhZ16FRuwxYJviS53t4m05yhyMyJOM65ohpf5OuxD3yiiEnPdbADd4t/v
         p3n29O+4X2zd+1WtQqJz3cDEWUBok+KpF8U8qwtQsuTJtZow5iv2BXH1beW/y7S5M31e
         bRLm6wGBlqVfM0lBZA4ArpQxgCLjElgszxmC2oojm6ky+GET1KrmIYJWGfJi765Yk10W
         L9vMbbu7x1Zbz72T9+ZCpNZvAwy5RmxWw/3xz44Nsj1ZGb+odp3Y5n2m9pbE6sESt3zz
         c+1hgGYxFqu9fhC9glHm/Ojuhfhd765Q25SyAcOXZc3psS3eAm5tPSygIB8YdviqZoWf
         12NQ==
X-Gm-Message-State: APjAAAUddyTEAonpfAz14O6dLy4r/TLKedwUhpIF5bSFO5jlv/hPj9qT
        DUr90zlryd8uyi9ctUVMACSJy7FOHve+XmhR+TQ=
X-Google-Smtp-Source: APXvYqyvB80rgmp0RPpa+TEubehvXskirm8OtcAtsxlSBmje/EB2rJlVbwgWLX6mypnrpF3FZawIMU7+Om5zJZRrdFc=
X-Received: by 2002:a05:620a:1011:: with SMTP id z17mr11657852qkj.39.1573253454667;
 Fri, 08 Nov 2019 14:50:54 -0800 (PST)
MIME-Version: 1.0
References: <157324878503.910124.12936814523952521484.stgit@toke.dk> <157324878850.910124.10106029353677591175.stgit@toke.dk>
In-Reply-To: <157324878850.910124.10106029353677591175.stgit@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 8 Nov 2019 14:50:43 -0800
Message-ID: <CAEf4BzZxcvhZG-FHF+0iqia72q3YA0dCgsgFchibiW7dkFQm2A@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 3/6] libbpf: Propagate EPERM to caller on
 program load
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 8, 2019 at 1:33 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redha=
t.com> wrote:
>
> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>
> When loading an eBPF program, libbpf overrides the return code for EPERM
> errors instead of returning it to the caller. This makes it hard to figur=
e
> out what went wrong on load.
>
> In particular, EPERM is returned when the system rlimit is too low to loc=
k
> the memory required for the BPF program. Previously, this was somewhat
> obscured because the rlimit error would be hit on map creation (which doe=
s
> return it correctly). However, since maps can now be reused, object load
> can proceed all the way to loading programs without hitting the error;
> propagating it even in this case makes it possible for the caller to reac=
t
> appropriately (and, e.g., attempt to raise the rlimit before retrying).
>
> Acked-by: Song Liu <songliubraving@fb.com>
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> ---
>  tools/lib/bpf/libbpf.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index cea61b2ec9d3..582c0fd16697 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -3721,7 +3721,7 @@ load_program(struct bpf_program *prog, struct bpf_i=
nsn *insns, int insns_cnt,
>                 free(log_buf);
>                 goto retry_load;
>         }
> -       ret =3D -LIBBPF_ERRNO__LOAD;
> +       ret =3D (errno =3D=3D EPERM) ? -errno : -LIBBPF_ERRNO__LOAD;
>         cp =3D libbpf_strerror_r(errno, errmsg, sizeof(errmsg));
>         pr_warn("load bpf program failed: %s\n", cp);
>
> @@ -3749,7 +3749,7 @@ load_program(struct bpf_program *prog, struct bpf_i=
nsn *insns, int insns_cnt,
>                         }
>                 }
>
> -               if (log_buf)
> +               if (log_buf && ret !=3D -EPERM)
>                         ret =3D -LIBBPF_ERRNO__KVER;

This whole special casing of EPERM looks weird. Should we just pass
through all the errors instead?

But also, I don't think you can assume that if you get EPERM, then it
must be setrlimit problem...


>         }
>
>
