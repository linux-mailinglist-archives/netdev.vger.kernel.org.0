Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31E643700F5
	for <lists+netdev@lfdr.de>; Fri, 30 Apr 2021 21:04:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231567AbhD3TFl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Apr 2021 15:05:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229954AbhD3TFk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Apr 2021 15:05:40 -0400
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AADEC06174A;
        Fri, 30 Apr 2021 12:04:51 -0700 (PDT)
Received: by mail-yb1-xb29.google.com with SMTP id y2so82347545ybq.13;
        Fri, 30 Apr 2021 12:04:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=v6mLZ59Y81Eu1T/WqCdE66FX9X1FJGEt1IqbQXqz2zA=;
        b=bqgq2MRDsHna2BV1wX74v2iUafA3hh/FBX9oefXrmoMgssMl+CgNVNpoCbRh53ur2Y
         WKwjjVS6C0AX5Z9yUnkBwFSiV5xnUtyB+JokM0tawy8KsyQkvM820w8HEN3JFna5s0Fq
         688ZCT/g6bk19TKNzcNTfgBXzf3BnCcZ5BOITIPKCC7Gg7WcV2dKNJbdB5f7S/D7kWCk
         CYI1yYonayA09t2d9+31WqZdrPV2P8JzGQnpeTzWQhmD0YSWQvR1ZfkO7orKbOJf98TW
         h9V4kwxuosGV+j29an80gtuBjaN+Mt5GTEg0vLID9S6MOeQfIcGAB//w/3jvWCVeM7Du
         r9cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=v6mLZ59Y81Eu1T/WqCdE66FX9X1FJGEt1IqbQXqz2zA=;
        b=SrxS0lsJvxfYi+KcxFEayHVux/192sQGFnzI43tICo0mYhkBZ0+1i3zqU2p/TxGUYP
         F8VtI8EqpSIzlp1u2rytWdcxxOcgUvKFHAs5O4aztJjFZDI+puohlW2U6YL9wvAfmBvg
         xh5nvI1XeHyzG2Z9si1Hd3QQ0z3NGjorvtO3Z92+Yn7XVqVui6tly+ZGNrjLqx0otbsU
         i08zrLYM4QViM601jRegviXvlq5KkyGJ6YO42JOlYwsIbkEniUbSWifvzPeHr6HqXjVr
         VDtHw00n/F1+P+vC2LCbOz9nH+SFx2rnZjK16ef+V+11epAW2J5yz4Xl/TJ86er2vrZA
         dTxQ==
X-Gm-Message-State: AOAM531iwE45yRDcdX/RlGn6+mu5MnPIPEI2zW69wJ+LzUksqIvnw8aD
        CcLdEaDh+Pk05/JMV0AuDXUQ+NE/QwfI1B7Lczw=
X-Google-Smtp-Source: ABdhPJxMw0Pq8/Oij4R+oEHFAGWpqaCtxAnw/bMhFG6QkKpEIasJeSBf86CiSf4WlbVi5porOgre5sEFb+qpV5jshEw=
X-Received: by 2002:a25:7507:: with SMTP id q7mr9278776ybc.27.1619809490823;
 Fri, 30 Apr 2021 12:04:50 -0700 (PDT)
MIME-Version: 1.0
References: <20210428162553.719588-1-memxor@gmail.com> <20210428162553.719588-2-memxor@gmail.com>
In-Reply-To: <20210428162553.719588-2-memxor@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 30 Apr 2021 12:04:39 -0700
Message-ID: <CAEf4Bzbc502GS+2t=Bj79FRDkE+mWRfP=DfD289zsNXB2oT+iA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v5 1/3] libbpf: add netlink helpers
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Shaun Crampton <shaun@tigera.io>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 28, 2021 at 9:26 AM Kumar Kartikeya Dwivedi
<memxor@gmail.com> wrote:
>
> This change introduces a few helpers to wrap open coded attribute
> preparation in netlink.c. It also adds a libbpf_nl_send_recv that is usef=
ul
> to wrap send + recv handling in a generic way. Subsequent patch will
> also use this function for sending and receiving a netlink response.
> The libbpf_nl_get_link helper has been removed instead, moving socket
> creation into the newly named libbpf_nl_send_recv.
>
> Every nested attribute's closure must happen using the helper
> nlattr_end_nested, which sets its length properly. NLA_F_NESTED is
> enforced using nlattr_begin_nested helper. Other simple attributes
> can be added directly.
>
> The maxsz parameter corresponds to the size of the request structure
> which is being filled in, so for instance with req being:
>
> struct {
>         struct nlmsghdr nh;
>         struct tcmsg t;
>         char buf[4096];
> } req;
>
> Then, maxsz should be sizeof(req).
>
> This change also converts the open coded attribute preparation with the
> helpers. Note that the only failure the internal call to nlattr_add
> could result in the nested helper would be -EMSGSIZE, hence that is what
> we return to our caller.
>
> The libbpf_nl_send_recv call takes care of opening the socket, sending th=
e
> netlink message, receiving the response, potentially invoking callbacks,
> and return errors if any, and then finally close the socket. This allows
> users to avoid identical socket setup code in different places. The only
> user of libbpf_nl_get_link has been converted to make use of it.
>
> __bpf_set_link_xdp_fd_replace has also been refactored to use it.
>
> Reviewed-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> ---
>  tools/lib/bpf/netlink.c | 117 ++++++++++++++++++----------------------
>  tools/lib/bpf/nlattr.h  |  48 +++++++++++++++++
>  2 files changed, 100 insertions(+), 65 deletions(-)
>
> diff --git a/tools/lib/bpf/netlink.c b/tools/lib/bpf/netlink.c
> index d2cb28e9ef52..6daee6640725 100644
> --- a/tools/lib/bpf/netlink.c
> +++ b/tools/lib/bpf/netlink.c
> @@ -131,72 +131,53 @@ static int bpf_netlink_recv(int sock, __u32 nl_pid,=
 int seq,
>         return ret;
>  }
>
> +static int libbpf_nl_send_recv(struct nlmsghdr *nh, __dump_nlmsg_t fn,
> +                              libbpf_dump_nlmsg_t _fn, void *cookie);
> +
>  static int __bpf_set_link_xdp_fd_replace(int ifindex, int fd, int old_fd=
,
>                                          __u32 flags)
>  {
> -       int sock, seq =3D 0, ret;
> -       struct nlattr *nla, *nla_xdp;
> +       struct nlattr *nla;
> +       int ret;
>         struct {
>                 struct nlmsghdr  nh;
>                 struct ifinfomsg ifinfo;
>                 char             attrbuf[64];
>         } req;
> -       __u32 nl_pid =3D 0;
> -
> -       sock =3D libbpf_netlink_open(&nl_pid);
> -       if (sock < 0)
> -               return sock;
>
>         memset(&req, 0, sizeof(req));
>         req.nh.nlmsg_len =3D NLMSG_LENGTH(sizeof(struct ifinfomsg));
>         req.nh.nlmsg_flags =3D NLM_F_REQUEST | NLM_F_ACK;
>         req.nh.nlmsg_type =3D RTM_SETLINK;
> -       req.nh.nlmsg_pid =3D 0;
> -       req.nh.nlmsg_seq =3D ++seq;
>         req.ifinfo.ifi_family =3D AF_UNSPEC;
>         req.ifinfo.ifi_index =3D ifindex;
>
>         /* started nested attribute for XDP */
> -       nla =3D (struct nlattr *)(((char *)&req)
> -                               + NLMSG_ALIGN(req.nh.nlmsg_len));
> -       nla->nla_type =3D NLA_F_NESTED | IFLA_XDP;
> -       nla->nla_len =3D NLA_HDRLEN;
> +       nla =3D nlattr_begin_nested(&req.nh, sizeof(req), IFLA_XDP);
> +       if (!nla)
> +               return -EMSGSIZE;
>
>         /* add XDP fd */
> -       nla_xdp =3D (struct nlattr *)((char *)nla + nla->nla_len);
> -       nla_xdp->nla_type =3D IFLA_XDP_FD;
> -       nla_xdp->nla_len =3D NLA_HDRLEN + sizeof(int);
> -       memcpy((char *)nla_xdp + NLA_HDRLEN, &fd, sizeof(fd));
> -       nla->nla_len +=3D nla_xdp->nla_len;
> +       ret =3D nlattr_add(&req.nh, sizeof(req), IFLA_XDP_FD, &fd, sizeof=
(fd));
> +       if (ret < 0)
> +               return ret;
>
>         /* if user passed in any flags, add those too */
>         if (flags) {
> -               nla_xdp =3D (struct nlattr *)((char *)nla + nla->nla_len)=
;
> -               nla_xdp->nla_type =3D IFLA_XDP_FLAGS;
> -               nla_xdp->nla_len =3D NLA_HDRLEN + sizeof(flags);
> -               memcpy((char *)nla_xdp + NLA_HDRLEN, &flags, sizeof(flags=
));
> -               nla->nla_len +=3D nla_xdp->nla_len;
> +               ret =3D nlattr_add(&req.nh, sizeof(req), IFLA_XDP_FLAGS, =
&flags, sizeof(flags));
> +               if (ret < 0)
> +                       return ret;
>         }
>
>         if (flags & XDP_FLAGS_REPLACE) {
> -               nla_xdp =3D (struct nlattr *)((char *)nla + nla->nla_len)=
;
> -               nla_xdp->nla_type =3D IFLA_XDP_EXPECTED_FD;
> -               nla_xdp->nla_len =3D NLA_HDRLEN + sizeof(old_fd);
> -               memcpy((char *)nla_xdp + NLA_HDRLEN, &old_fd, sizeof(old_=
fd));
> -               nla->nla_len +=3D nla_xdp->nla_len;
> +               ret =3D nlattr_add(&req.nh, sizeof(req), IFLA_XDP_EXPECTE=
D_FD, &flags, sizeof(flags));

shouldn't old_fd be used here?

> +               if (ret < 0)
> +                       return ret;
>         }
>
> -       req.nh.nlmsg_len +=3D NLA_ALIGN(nla->nla_len);
> +       nlattr_end_nested(&req.nh, nla);
>
> -       if (send(sock, &req, req.nh.nlmsg_len, 0) < 0) {
> -               ret =3D -errno;
> -               goto cleanup;
> -       }
> -       ret =3D bpf_netlink_recv(sock, nl_pid, seq, NULL, NULL, NULL);
> -
> -cleanup:
> -       close(sock);
> -       return ret;
> +       return libbpf_nl_send_recv(&req.nh, NULL, NULL, NULL);
>  }
>
>  int bpf_set_link_xdp_fd_opts(int ifindex, int fd, __u32 flags,

[...]

> -int libbpf_nl_get_link(int sock, unsigned int nl_pid,
> -                      libbpf_dump_nlmsg_t dump_link_nlmsg, void *cookie)
> +static int libbpf_nl_send_recv(struct nlmsghdr *nh, __dump_nlmsg_t fn,
> +                              libbpf_dump_nlmsg_t _fn, void *cookie)
>  {
> -       struct {
> -               struct nlmsghdr nlh;
> -               struct ifinfomsg ifm;
> -       } req =3D {
> -               .nlh.nlmsg_len =3D NLMSG_LENGTH(sizeof(struct ifinfomsg))=
,
> -               .nlh.nlmsg_type =3D RTM_GETLINK,
> -               .nlh.nlmsg_flags =3D NLM_F_DUMP | NLM_F_REQUEST,
> -               .ifm.ifi_family =3D AF_PACKET,
> -       };
> -       int seq =3D time(NULL);
> +       __u32 nl_pid =3D 0;
> +       int sock, ret;
>
> -       req.nlh.nlmsg_seq =3D seq;
> -       if (send(sock, &req, req.nlh.nlmsg_len, 0) < 0)
> -               return -errno;
> +       if (!nh)
> +               return -EINVAL;
> +
> +       sock =3D libbpf_netlink_open(&nl_pid);
> +       if (sock < 0)
> +               return sock;
>
> -       return bpf_netlink_recv(sock, nl_pid, seq, __dump_link_nlmsg,
> -                               dump_link_nlmsg, cookie);
> +       nh->nlmsg_pid =3D 0;
> +       nh->nlmsg_seq =3D time(NULL);
> +       if (send(sock, nh, nh->nlmsg_len, 0) < 0) {
> +               ret =3D -errno;
> +               goto end;
> +       }
> +
> +       ret =3D bpf_netlink_recv(sock, nl_pid, nh->nlmsg_seq, fn, _fn, co=
okie);

what's the difference between fn and _fn, can this be somehow
reflected in the name?

> +
> +end:
> +       close(sock);
> +       return ret;
>  }
> diff --git a/tools/lib/bpf/nlattr.h b/tools/lib/bpf/nlattr.h
> index 6cc3ac91690f..1c94cdb6e89d 100644
> --- a/tools/lib/bpf/nlattr.h
> +++ b/tools/lib/bpf/nlattr.h
> @@ -10,7 +10,10 @@
>  #define __LIBBPF_NLATTR_H
>
>  #include <stdint.h>
> +#include <string.h>
> +#include <errno.h>
>  #include <linux/netlink.h>
> +
>  /* avoid multiple definition of netlink features */
>  #define __LINUX_NETLINK_H
>
> @@ -103,4 +106,49 @@ int libbpf_nla_parse_nested(struct nlattr *tb[], int=
 maxtype,
>
>  int libbpf_nla_dump_errormsg(struct nlmsghdr *nlh);
>
> +static inline struct nlattr *nla_data(struct nlattr *nla)
> +{
> +       return (struct nlattr *)((char *)nla + NLA_HDRLEN);
> +}
> +
> +static inline struct nlattr *nh_tail(struct nlmsghdr *nh)
> +{
> +       return (struct nlattr *)((char *)nh + NLMSG_ALIGN(nh->nlmsg_len))=
;
> +}
> +
> +static inline int nlattr_add(struct nlmsghdr *nh, size_t maxsz, int type=
,
> +                            const void *data, int len)
> +{
> +       struct nlattr *nla;
> +
> +       if (NLMSG_ALIGN(nh->nlmsg_len) + NLA_ALIGN(NLA_HDRLEN + len) > ma=
xsz)
> +               return -EMSGSIZE;
> +       if ((!data && len) || (data && !len))

we use !!data !=3D !!len for this in at least few places

> +               return -EINVAL;
> +
> +       nla =3D nh_tail(nh);
> +       nla->nla_type =3D type;
> +       nla->nla_len =3D NLA_HDRLEN + len;
> +       if (data)
> +               memcpy(nla_data(nla), data, len);
> +       nh->nlmsg_len =3D NLMSG_ALIGN(nh->nlmsg_len) + NLA_ALIGN(nla->nla=
_len);
> +       return 0;
> +}
> +

[...]
