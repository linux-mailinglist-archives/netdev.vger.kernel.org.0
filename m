Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61E8FF5C8F
	for <lists+netdev@lfdr.de>; Sat,  9 Nov 2019 01:51:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726219AbfKIAvP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 19:51:15 -0500
Received: from mail-qt1-f196.google.com ([209.85.160.196]:37157 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726092AbfKIAvP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 19:51:15 -0500
Received: by mail-qt1-f196.google.com with SMTP id g50so8673796qtb.4;
        Fri, 08 Nov 2019 16:51:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=MdlO8VSAOVIeytkK27+o2cB/y/ljZsfnURutKT8DXT0=;
        b=JdceBSK67YSb6IK70LbVcQtCv8nug5GRt2gq+U46nKuKoJGUqaqrEyOfoOqzZeXdU0
         6Ch6h7A4YKgDTaq6Yj1SeROdEpuc3Ujpt2E/XDGIMeJI72z1QVMcm956G3odJBXoK/OJ
         A7J6pU6LGEkrIVZBJGEJ92K7Cw02bv+fJhRQj665sum+D/EHdDMdQ6Hj/lcM3DoJUAoq
         5jHIrqAg4uO4Ui649lwYcPj1doVy/JokeOgEEyCwPhoB+3OHd38onqbGpKUFlIpWSEAh
         RlP5wuHUUYIwVjArcHRlDt8v7MJVSeSXmDUuxRAaQb3euitGFveVQe/kMdgx4XZck3Ia
         X7eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=MdlO8VSAOVIeytkK27+o2cB/y/ljZsfnURutKT8DXT0=;
        b=gCas5wG+vklSc3JdSvlGNfV4M+4DncdhCY6ISPrVg7C6XTufiF2UL0jPXr3MeHLwB9
         mG6b2M29amckgf5dyKqEXP+ESPKxJ/ZvyOalmUTqbRj1TxkD+ibVI9HGW5UlJsCnAZSt
         rkFjRveD93j29AhlkJV2DAdSV04Q4UnSB+Z8Crg3jY8LM+TqXnJHwc04enRueyscw4lW
         kpejsKsws7/Hr7R9uXAFLA6O8DEKKdk9eIO+K66rnjg8j9Vf9fyWUSO0JGXRyDZVycNc
         pY30Ed4eClxEa0NjC2KESbhggTYYxx1Si89XkiNbttdMPqwcWVZGdkt0BoZS8wfMw2Nx
         k5SA==
X-Gm-Message-State: APjAAAURLnwVhg6QcyAwVBxgm3phb2cpB/xDP6EYrgfzJStXq32ub9hC
        lDN5qO517hho/LkUmrGno+2TxsJpTdZxp6APKG4=
X-Google-Smtp-Source: APXvYqwyXbUwpdtnK14sNV/xOIfyCiUr6uuhPsxJXSJR8oxpkFo+NYK1/aMwlT3pNJIY33i2hnGtw7WQ7vDVV1PlRmg=
X-Received: by 2002:aed:35e7:: with SMTP id d36mr13815932qte.59.1573260674455;
 Fri, 08 Nov 2019 16:51:14 -0800 (PST)
MIME-Version: 1.0
References: <157325765467.27401.1930972466188738545.stgit@toke.dk> <157325766011.27401.5278664694085166014.stgit@toke.dk>
In-Reply-To: <157325766011.27401.5278664694085166014.stgit@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 8 Nov 2019 16:51:03 -0800
Message-ID: <CAEf4BzYvv6pCHygeNyOBE4MRtcLxE1XP4Ww+sxoaPgQw5i1Rjw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 5/6] libbpf: Add bpf_get_link_xdp_info()
 function to get more XDP information
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

On Fri, Nov 8, 2019 at 4:01 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redha=
t.com> wrote:
>
> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>
> Currently, libbpf only provides a function to get a single ID for the XDP
> program attached to the interface. However, it can be useful to get the
> full set of program IDs attached, along with the attachment mode, in one
> go. Add a new getter function to support this, using an extendible
> structure to carry the information. Express the old bpf_get_link_id()
> function in terms of the new function.
>
> Acked-by: David S. Miller <davem@davemloft.net>
> Acked-by: Song Liu <songliubraving@fb.com>
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> ---
>  tools/lib/bpf/libbpf.h   |   10 ++++++
>  tools/lib/bpf/libbpf.map |    1 +
>  tools/lib/bpf/netlink.c  |   82 ++++++++++++++++++++++++++++++----------=
------
>  3 files changed, 65 insertions(+), 28 deletions(-)
>

[...]

>
> -int bpf_get_link_xdp_id(int ifindex, __u32 *prog_id, __u32 flags)
> +int bpf_get_link_xdp_info(int ifindex, struct xdp_link_info *info,
> +                         size_t info_size, __u32 flags)
>  {
>         struct xdp_id_md xdp_id =3D {};
>         int sock, ret;
>         __u32 nl_pid;
>         __u32 mask;
>
> -       if (flags & ~XDP_FLAGS_MASK)
> +       if (flags & ~XDP_FLAGS_MASK || info_size < sizeof(*info))
>                 return -EINVAL;

Well, now it's backwards-incompatible: older program passes smaller
(but previously perfectly valid) sizeof(struct xdp_link_info) to newer
version of libbpf. This has to go both ways: smaller struct should be
supported as long as program doesn't request (using flags) something,
that can't be put into allowed space.

I know it's PITA to support this, but that's what we have to do for
forward/backward compatibility.

>
>         /* Check whether the single {HW,DRV,SKB} mode is set */
> @@ -274,14 +272,42 @@ int bpf_get_link_xdp_id(int ifindex, __u32 *prog_id=
, __u32 flags)
>         xdp_id.ifindex =3D ifindex;
>         xdp_id.flags =3D flags;
>
> -       ret =3D libbpf_nl_get_link(sock, nl_pid, get_xdp_id, &xdp_id);
> -       if (!ret)
> -               *prog_id =3D xdp_id.id;
> +       ret =3D libbpf_nl_get_link(sock, nl_pid, get_xdp_info, &xdp_id);
> +       if (!ret) {
> +               memset(info, 0, info_size);
> +               memcpy(info, &xdp_id.info, min(info_size, sizeof(xdp_id.i=
nfo)));

nit: memset above should start at info + min(info_size, sizeof(xdp_id.info)=
)

> +       }
>
>         close(sock);
>         return ret;
>  }
>

[...]
