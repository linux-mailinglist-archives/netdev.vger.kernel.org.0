Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71975F5BAA
	for <lists+netdev@lfdr.de>; Sat,  9 Nov 2019 00:11:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727672AbfKHXLC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 18:11:02 -0500
Received: from mail-qv1-f66.google.com ([209.85.219.66]:36280 "EHLO
        mail-qv1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726227AbfKHXLB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 18:11:01 -0500
Received: by mail-qv1-f66.google.com with SMTP id f12so2884994qvu.3;
        Fri, 08 Nov 2019 15:10:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Ql2lLaPFhSOOU0q1jXK6+MSZStci03aMlTpcYCeFuD4=;
        b=sjQcRjtxBKKF4/oKMqTIwTHahQohtDUmnAFH7KjPgG5npJNxVjOzSDew1gv0IWvWKU
         lu8GCpHmlRPqdnsWUIfNqhIQbDIO6uO9OMpRG+JFP7RpcD8i/zTqsPzAGkAwuOPF0Gu0
         fTcIgFMA0+2ogsi2tXLAMU1iNCQMwMt1m9OT6FkHeKEDIRvFynYbSZ9ri7CWldmV4Cos
         k0Uj4+3O1Wgdw5t33MdrUrk+frbihOFAqR7QH7VTMKijfRK+hlIFLGJjMNWZ4Zui3OyC
         19+2YxOlQJBbMwwCV3qdRQLZ9jK+wlE8IAxi0sr7FjaCpD8jbxUyW0gAEFbPLughXP7N
         G5Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Ql2lLaPFhSOOU0q1jXK6+MSZStci03aMlTpcYCeFuD4=;
        b=M3hHKyfKQaG3pvqY/2KzhzMu2fjrm8oUsrYOmbj66lTkbhmo4s5F+3FHLZcZ5uwUWW
         AHQMxkAIZHO2ZYhf8HWsl7nCl+ISWDcybsK5xp4LVbn5E0RglmICemkB36WeYP/d2EgD
         P/twrpxoPogvNUjgx68RMyVUUF1rWUY+jHfNg+qbv675B9ogfMgo6Yk1b2E9wbNl+uqh
         wVgpqYowJPeDgikbXBB31FAvDWyibxhZ2KQN+qqm5Hp6S97UK+wvZV4pbyt/fK4gydFB
         nnG1yx/TYmxbzEm/YOoX0f0KwR4AKc5zqbFWVnL/giInljCpLBp90eJUL7Ywwqo80GrT
         /a+g==
X-Gm-Message-State: APjAAAUtQjFigFFzWCkTN1RQANAc4KJzYGQuRG63BeoS4xhozwWleH/T
        Ku7tcjrqKiYYZnmowShvRyM9BN9t80CCuhNjkhY=
X-Google-Smtp-Source: APXvYqxn5i54AEhmfJ/OOu0ZJWVMLK9zUCNkNnuDojSJUlV+xn1CEHS3513T9NDgu8H5pniQwZLjZpHqFosnjiuNq/A=
X-Received: by 2002:ad4:558e:: with SMTP id e14mr11869316qvx.247.1573254658481;
 Fri, 08 Nov 2019 15:10:58 -0800 (PST)
MIME-Version: 1.0
References: <157324878503.910124.12936814523952521484.stgit@toke.dk> <157324879070.910124.16900285171727920636.stgit@toke.dk>
In-Reply-To: <157324879070.910124.16900285171727920636.stgit@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 8 Nov 2019 15:10:47 -0800
Message-ID: <CAEf4Bzbr7K3n8mNj-ay7WqJfxGA2hMQ3dXGDVcuKUiohm4_JBQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 5/6] libbpf: Add bpf_get_link_xdp_info()
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

On Fri, Nov 8, 2019 at 1:33 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redha=
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
> Acked-by: Song Liu <songliubraving@fb.com>
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> ---
>  tools/lib/bpf/libbpf.h   |   10 ++++++
>  tools/lib/bpf/libbpf.map |    1 +
>  tools/lib/bpf/netlink.c  |   78 ++++++++++++++++++++++++++++++----------=
------
>  3 files changed, 62 insertions(+), 27 deletions(-)
>
> diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
> index 6ddc0419337b..f0947cc949d2 100644
> --- a/tools/lib/bpf/libbpf.h
> +++ b/tools/lib/bpf/libbpf.h
> @@ -427,8 +427,18 @@ LIBBPF_API int bpf_prog_load_xattr(const struct bpf_=
prog_load_attr *attr,
>  LIBBPF_API int bpf_prog_load(const char *file, enum bpf_prog_type type,
>                              struct bpf_object **pobj, int *prog_fd);
>
> +struct xdp_link_info {
> +       __u32 prog_id;
> +       __u32 drv_prog_id;
> +       __u32 hw_prog_id;
> +       __u32 skb_prog_id;
> +       __u8 attach_mode;
> +};
> +
>  LIBBPF_API int bpf_set_link_xdp_fd(int ifindex, int fd, __u32 flags);
>  LIBBPF_API int bpf_get_link_xdp_id(int ifindex, __u32 *prog_id, __u32 fl=
ags);
> +LIBBPF_API int bpf_get_link_xdp_info(int ifindex, struct xdp_link_info *=
info,
> +                                    size_t info_size, __u32 flags);
>
>  struct perf_buffer;
>
> diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
> index 86173cbb159d..d1a782a3a58d 100644
> --- a/tools/lib/bpf/libbpf.map
> +++ b/tools/lib/bpf/libbpf.map
> @@ -193,6 +193,7 @@ LIBBPF_0.0.5 {
>
>  LIBBPF_0.0.6 {
>         global:
> +               bpf_get_link_xdp_info;
>                 bpf_map__get_pin_path;
>                 bpf_map__is_pinned;
>                 bpf_map__set_pin_path;
> diff --git a/tools/lib/bpf/netlink.c b/tools/lib/bpf/netlink.c
> index a261df9cb488..85019da01d3b 100644
> --- a/tools/lib/bpf/netlink.c
> +++ b/tools/lib/bpf/netlink.c
> @@ -25,7 +25,7 @@ typedef int (*__dump_nlmsg_t)(struct nlmsghdr *nlmsg, l=
ibbpf_dump_nlmsg_t,
>  struct xdp_id_md {
>         int ifindex;
>         __u32 flags;
> -       __u32 id;
> +       struct xdp_link_info info;
>  };
>
>  int libbpf_netlink_open(__u32 *nl_pid)
> @@ -203,26 +203,11 @@ static int __dump_link_nlmsg(struct nlmsghdr *nlh,
>         return dump_link_nlmsg(cookie, ifi, tb);
>  }
>
> -static unsigned char get_xdp_id_attr(unsigned char mode, __u32 flags)
> -{
> -       if (mode !=3D XDP_ATTACHED_MULTI)
> -               return IFLA_XDP_PROG_ID;
> -       if (flags & XDP_FLAGS_DRV_MODE)
> -               return IFLA_XDP_DRV_PROG_ID;
> -       if (flags & XDP_FLAGS_HW_MODE)
> -               return IFLA_XDP_HW_PROG_ID;
> -       if (flags & XDP_FLAGS_SKB_MODE)
> -               return IFLA_XDP_SKB_PROG_ID;
> -
> -       return IFLA_XDP_UNSPEC;
> -}
> -
> -static int get_xdp_id(void *cookie, void *msg, struct nlattr **tb)
> +static int get_xdp_info(void *cookie, void *msg, struct nlattr **tb)
>  {
>         struct nlattr *xdp_tb[IFLA_XDP_MAX + 1];
>         struct xdp_id_md *xdp_id =3D cookie;
>         struct ifinfomsg *ifinfo =3D msg;
> -       unsigned char mode, xdp_attr;
>         int ret;
>
>         if (xdp_id->ifindex && xdp_id->ifindex !=3D ifinfo->ifi_index)
> @@ -238,27 +223,40 @@ static int get_xdp_id(void *cookie, void *msg, stru=
ct nlattr **tb)
>         if (!xdp_tb[IFLA_XDP_ATTACHED])
>                 return 0;
>
> -       mode =3D libbpf_nla_getattr_u8(xdp_tb[IFLA_XDP_ATTACHED]);
> -       if (mode =3D=3D XDP_ATTACHED_NONE)
> -               return 0;
> +       xdp_id->info.attach_mode =3D libbpf_nla_getattr_u8(
> +               xdp_tb[IFLA_XDP_ATTACHED]);
>
> -       xdp_attr =3D get_xdp_id_attr(mode, xdp_id->flags);
> -       if (!xdp_attr || !xdp_tb[xdp_attr])
> +       if (xdp_id->info.attach_mode =3D=3D XDP_ATTACHED_NONE)
>                 return 0;
>
> -       xdp_id->id =3D libbpf_nla_getattr_u32(xdp_tb[xdp_attr]);
> +       if (xdp_tb[IFLA_XDP_PROG_ID])
> +               xdp_id->info.prog_id =3D libbpf_nla_getattr_u32(
> +                       xdp_tb[IFLA_XDP_PROG_ID]);
> +
> +       if (xdp_tb[IFLA_XDP_SKB_PROG_ID])
> +               xdp_id->info.skb_prog_id =3D libbpf_nla_getattr_u32(
> +                       xdp_tb[IFLA_XDP_SKB_PROG_ID]);
> +
> +       if (xdp_tb[IFLA_XDP_DRV_PROG_ID])
> +               xdp_id->info.drv_prog_id =3D libbpf_nla_getattr_u32(
> +                       xdp_tb[IFLA_XDP_DRV_PROG_ID]);
> +
> +       if (xdp_tb[IFLA_XDP_HW_PROG_ID])
> +               xdp_id->info.hw_prog_id =3D libbpf_nla_getattr_u32(
> +                       xdp_tb[IFLA_XDP_HW_PROG_ID]);
>
>         return 0;
>  }
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
> +       if (flags & ~XDP_FLAGS_MASK || info_size !=3D sizeof(*info))

This is not forward-compatible. Newer application can pass bigger
info_size, if xdp_link_info gets extended. We should probably just
zero-fill the part we don't understand.

>                 return -EINVAL;
>
>         /* Check whether the single {HW,DRV,SKB} mode is set */
> @@ -274,14 +272,40 @@ int bpf_get_link_xdp_id(int ifindex, __u32 *prog_id=
, __u32 flags)
>         xdp_id.ifindex =3D ifindex;
>         xdp_id.flags =3D flags;
>
> -       ret =3D libbpf_nl_get_link(sock, nl_pid, get_xdp_id, &xdp_id);
> +       ret =3D libbpf_nl_get_link(sock, nl_pid, get_xdp_info, &xdp_id);
>         if (!ret)
> -               *prog_id =3D xdp_id.id;
> +               memcpy(info, &xdp_id.info, sizeof(*info));
>
>         close(sock);
>         return ret;
>  }
>
> +static __u32 get_xdp_id(struct xdp_link_info *info, __u32 flags)
> +{
> +       if (info->attach_mode !=3D XDP_ATTACHED_MULTI)
> +               return info->prog_id;
> +       if (flags & XDP_FLAGS_DRV_MODE)
> +               return info->drv_prog_id;
> +       if (flags & XDP_FLAGS_HW_MODE)
> +               return info->hw_prog_id;
> +       if (flags & XDP_FLAGS_SKB_MODE)
> +               return info->skb_prog_id;
> +
> +       return 0;
> +}
> +
> +int bpf_get_link_xdp_id(int ifindex, __u32 *prog_id, __u32 flags)
> +{
> +       struct xdp_link_info info =3D {};

seems like there is no need to pre-initialize info, it should be
initialized (on success) by bpf_get_link_xdp_info?

> +       int ret;
> +
> +       ret =3D bpf_get_link_xdp_info(ifindex, &info, sizeof(info), flags=
);
> +       if (!ret)
> +               *prog_id =3D get_xdp_id(&info, flags);
> +
> +       return ret;
> +}
> +
>  int libbpf_nl_get_link(int sock, unsigned int nl_pid,
>                        libbpf_dump_nlmsg_t dump_link_nlmsg, void *cookie)
>  {
>
