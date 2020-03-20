Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2AF7018DA8D
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 22:50:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727032AbgCTVuz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 17:50:55 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:46790 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726666AbgCTVuz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 17:50:55 -0400
Received: by mail-qk1-f194.google.com with SMTP id f28so8618701qkk.13;
        Fri, 20 Mar 2020 14:50:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=GwtjKyHvbZgdMzhpsJMoH23S9GrlSrD7P3lqEEBJMHU=;
        b=j5dROKl9nlNZHEa4VbPz0sQpXO7gvXB8dGdjFkzsTTt3cpDP0vKL5uoetNPrt4ppNA
         PmZp0HdRBYGmmdGZs/PtdfXafWPlKiOg4BICHNkgo8+f9q1Rry/P8ltyvQKB52iQlZDY
         Q54A5GlGXpj+aVPxE9pXqYc0cFGFO3wchQV61UV9yV57s5vcC3CBTHVYmkWae87zUuLN
         59LhoFZVuGZIYQGtVl22+yt51uuXISO5Zu0fM1NQegQ0ugygCAD0AbJska4VerqixASg
         jRTAQhd7V3rG1i6nKlD8g32jDasXCJi/m8HrZqOh79G4cPE/DAXaSpDHp99brsLGKZdx
         V4kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=GwtjKyHvbZgdMzhpsJMoH23S9GrlSrD7P3lqEEBJMHU=;
        b=DsDJN366PYo2ZAyumgpZgNkUzOkcbm9DWIrvksCO+aRGGv+r/HK8pIvM76B8i5GWl7
         xe8bBhGVLp+ZCEmkRTiC7wKfgP4MdGyZA2Axe7I2wCBH3DVrleRwYrPCQ9sHPbOpwppV
         zJ6vfIo8/6Ojj1+Od+yU1K2I6/48Q0b0HpExFp+aA/i9UtCVzeCQNlDYw9OBA1eM95f8
         g0IrF1ishGzy0fcyW9DSetfe1dJVH4a298c/FGH6nZfKt2IbMMXEkehtiDaXDbUVs7Q3
         0tznTPHHaBC0RJLrwY1RLh2DPuu1xhOpLv2Pf80uS8/BxPQskR5kH118vTt6WwEcH7DP
         Y3QA==
X-Gm-Message-State: ANhLgQ1e5Vxp3ijqwy9kBcgLk31MuXj0RlA3c5zueRKpSSWOPqnOfrl1
        BLIlmKqvomxc973tq2p790JtvwUnJNxhCM6rgPI=
X-Google-Smtp-Source: ADFU+vvU2ssaHVFv0olybSuNLk8M4Jqr6AfpWi+Nw14Xmv7FYP3egbBAz4NHBkTRwEcGpt3Elb0TPhNrInPxaVUCiGI=
X-Received: by 2002:a37:6411:: with SMTP id y17mr10537364qkb.437.1584741053938;
 Fri, 20 Mar 2020 14:50:53 -0700 (PDT)
MIME-Version: 1.0
References: <158472336748.296548.5028326196275429565.stgit@toke.dk> <158472337077.296548.4666186362987360141.stgit@toke.dk>
In-Reply-To: <158472337077.296548.4666186362987360141.stgit@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 20 Mar 2020 14:50:43 -0700
Message-ID: <CAEf4BzZ17_4tZfMw1DdkXT7hHBpj8nrRufm6WopBnsU7a9-evA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 3/4] libbpf: Add function to set link XDP fd
 while specifying old fd
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Andrey Ignatov <rdna@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 20, 2020 at 9:57 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>
> This adds a new function to set the XDP fd while specifying the old fd to
> replace, using the newly added IFLA_XDP_EXPECTED_FD netlink parameter.
>
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> ---
>  tools/lib/bpf/libbpf.h   |    2 ++
>  tools/lib/bpf/libbpf.map |    1 +
>  tools/lib/bpf/netlink.c  |   22 +++++++++++++++++++++-
>  3 files changed, 24 insertions(+), 1 deletion(-)
>
> diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
> index d38d7a629417..b5ca4f741e28 100644
> --- a/tools/lib/bpf/libbpf.h
> +++ b/tools/lib/bpf/libbpf.h
> @@ -445,6 +445,8 @@ struct xdp_link_info {
>  };
>
>  LIBBPF_API int bpf_set_link_xdp_fd(int ifindex, int fd, __u32 flags);
> +LIBBPF_API int bpf_set_link_xdp_fd_replace(int ifindex, int fd, int old_=
fd,
> +                                          __u32 flags);

If we end up doing it in XDP-specific way, I'd argue for using OPTS to
specify optional expected FD. That will allow to extend this API
further without adding many small variations of the same API.

>  LIBBPF_API int bpf_get_link_xdp_id(int ifindex, __u32 *prog_id, __u32 fl=
ags);
>  LIBBPF_API int bpf_get_link_xdp_info(int ifindex, struct xdp_link_info *=
info,
>                                      size_t info_size, __u32 flags);
> diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
> index 5129283c0284..154f1d94fa63 100644
> --- a/tools/lib/bpf/libbpf.map
> +++ b/tools/lib/bpf/libbpf.map
> @@ -244,4 +244,5 @@ LIBBPF_0.0.8 {
>                 bpf_link__pin_path;
>                 bpf_link__unpin;
>                 bpf_program__set_attach_target;
> +               bpf_set_link_xdp_fd_replace;
>  } LIBBPF_0.0.7;
> diff --git a/tools/lib/bpf/netlink.c b/tools/lib/bpf/netlink.c
> index 431bd25c6cdb..39bd0ead1546 100644
> --- a/tools/lib/bpf/netlink.c
> +++ b/tools/lib/bpf/netlink.c
> @@ -132,7 +132,8 @@ static int bpf_netlink_recv(int sock, __u32 nl_pid, i=
nt seq,
>         return ret;
>  }
>
> -int bpf_set_link_xdp_fd(int ifindex, int fd, __u32 flags)
> +static int __bpf_set_link_xdp_fd_replace(int ifindex, int fd, int old_fd=
,
> +                                        __u32 flags)
>  {
>         int sock, seq =3D 0, ret;
>         struct nlattr *nla, *nla_xdp;
> @@ -178,6 +179,14 @@ int bpf_set_link_xdp_fd(int ifindex, int fd, __u32 f=
lags)
>                 nla->nla_len +=3D nla_xdp->nla_len;
>         }
>
> +       if (flags & XDP_FLAGS_EXPECT_FD) {
> +               nla_xdp =3D (struct nlattr *)((char *)nla + nla->nla_len)=
;
> +               nla_xdp->nla_type =3D IFLA_XDP_EXPECTED_FD;
> +               nla_xdp->nla_len =3D NLA_HDRLEN + sizeof(int);
> +               memcpy((char *)nla_xdp + NLA_HDRLEN, &old_fd, sizeof(old_=
fd));
> +               nla->nla_len +=3D nla_xdp->nla_len;
> +       }
> +
>         req.nh.nlmsg_len +=3D NLA_ALIGN(nla->nla_len);
>
>         if (send(sock, &req, req.nh.nlmsg_len, 0) < 0) {
> @@ -191,6 +200,17 @@ int bpf_set_link_xdp_fd(int ifindex, int fd, __u32 f=
lags)
>         return ret;
>  }
>
> +int bpf_set_link_xdp_fd_replace(int ifindex, int fd, int old_fd, __u32 f=
lags)
> +{
> +       return __bpf_set_link_xdp_fd_replace(ifindex, fd, old_fd,
> +                                            flags | XDP_FLAGS_EXPECT_FD)=
;
> +}
> +
> +int bpf_set_link_xdp_fd(int ifindex, int fd, __u32 flags)
> +{
> +       return __bpf_set_link_xdp_fd_replace(ifindex, fd, -1, flags);
> +}
> +
>  static int __dump_link_nlmsg(struct nlmsghdr *nlh,
>                              libbpf_dump_nlmsg_t dump_link_nlmsg, void *c=
ookie)
>  {
>
