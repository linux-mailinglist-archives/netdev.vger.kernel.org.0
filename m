Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 495D034B32D
	for <lists+netdev@lfdr.de>; Sat, 27 Mar 2021 00:52:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231180AbhCZXwU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 19:52:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230076AbhCZXwN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Mar 2021 19:52:13 -0400
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8F3FC0613AA;
        Fri, 26 Mar 2021 16:52:12 -0700 (PDT)
Received: by mail-yb1-xb36.google.com with SMTP id g38so7471355ybi.12;
        Fri, 26 Mar 2021 16:52:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=A/DxK0IqPOowuaWf/XWHVxZ1o9ERXvrsfkywPdSZpZI=;
        b=SQMokkogfL6zf18KuVeWZ/w6WWNyN3qAM8F6QaU0lA2rJiDaeck1+Z56LazQox5uBb
         hbm6WRF0HedpivWO1xVvr1Mvahjx5LQLDiS3VOZxOJF5k7k8XKsvFbXcqOVvnq9eY13R
         VlfqzuPuf5BVwnzJArwyy06r2pxvyZuCV/hYNcApoo8xEL1IQlVm/24tglRcV2Xv+FkP
         ae48HwTrO4DQx7MUN+3mPGKWaRAvFHy45WafMlxBY9adR5yG5hRtxrT9p7MYFlTMs184
         bsFKLA7zd71xWkDPHoqkz+MkbJk4Os7sftLmr36CJ5e5yfunBu+CmLh7g4Muo8zEfH30
         RGLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=A/DxK0IqPOowuaWf/XWHVxZ1o9ERXvrsfkywPdSZpZI=;
        b=A4Egdx1Y5Qo0GSPdNUWdWrA/62EUUB35PeckNewfHwwnRRgWtZkQelddx+CYbuPGlY
         mlerKDv1nmodU+HiW2SMe9wdSIRFywjvNV4cxRnNB/5igeeXDznDtXs5QUqmsXUjK8Ag
         ZkATVjTNaGTnI/77rMqCKVV4+veuNEBkxX4c8dfOcmEHa9VZVwUez4KqyLlFNJvQnjoD
         r8ei89k109zsLeXU+4P7wKk+SNAneIEsmGZxxBLNvcsyk47RGCq5+bKgF6jG7PVXU6jk
         JEA/FGdQMpxrUgWkya3xyaghLtO7gIirxFrUy8ip4J9HrEMtEQy3gX1QWDmnegWkO8Qu
         VhOg==
X-Gm-Message-State: AOAM531Sxea9VheM50Vc0lrrCsz8V5OjE9VCWbxmmsxlhb34GCDl376V
        g4TH4aQKfItq2M0OYIH/JIxEQHL4zUaH80qSf9A=
X-Google-Smtp-Source: ABdhPJxT/E9ty0hI8D3AL/6I4EEjG0n8PBCxXMHCbgs8nmn25pXsNd/iffjBH9r7n6rkUUTZwmPyp8LIYA3Sjt4v0RM=
X-Received: by 2002:a25:7d07:: with SMTP id y7mr22663291ybc.425.1616802731751;
 Fri, 26 Mar 2021 16:52:11 -0700 (PDT)
MIME-Version: 1.0
References: <20210325120020.236504-1-memxor@gmail.com> <20210325120020.236504-3-memxor@gmail.com>
In-Reply-To: <20210325120020.236504-3-memxor@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 26 Mar 2021 16:52:01 -0700
Message-ID: <CAEf4BzZXVB5KG6P1DQLDs-2qMkWgKY7WcFdJd0c_ULF7xzZxiQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/5] libbpf: add helpers for preparing netlink attributes
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 25, 2021 at 5:01 AM Kumar Kartikeya Dwivedi
<memxor@gmail.com> wrote:
>
> This change introduces a few helpers to wrap open coded attribute
> preparation in netlink.c.
>
> Every nested attribute's closure must happen using the helper
> end_nlattr_nested, which sets its length properly. NLA_F_NESTED is
> enforeced using begin_nlattr_nested helper. Other simple attributes
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
> helpers. Note that the only failure the internal call to add_nlattr
> could result in the nested helper would be -EMSGSIZE, hence that is what
> we return to our caller.
>
> Reviewed-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> ---
>  tools/lib/bpf/netlink.c | 37 +++++++++++++++--------------------
>  tools/lib/bpf/nlattr.h  | 43 +++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 59 insertions(+), 21 deletions(-)
>
> diff --git a/tools/lib/bpf/netlink.c b/tools/lib/bpf/netlink.c
> index 4dd73de00b6f..f448c29de76d 100644
> --- a/tools/lib/bpf/netlink.c
> +++ b/tools/lib/bpf/netlink.c
> @@ -135,7 +135,7 @@ static int __bpf_set_link_xdp_fd_replace(int ifindex,=
 int fd, int old_fd,
>                                          __u32 flags)
>  {
>         int sock, seq =3D 0, ret;
> -       struct nlattr *nla, *nla_xdp;
> +       struct nlattr *nla;
>         struct {
>                 struct nlmsghdr  nh;
>                 struct ifinfomsg ifinfo;
> @@ -157,36 +157,31 @@ static int __bpf_set_link_xdp_fd_replace(int ifinde=
x, int fd, int old_fd,
>         req.ifinfo.ifi_index =3D ifindex;
>
>         /* started nested attribute for XDP */
> -       nla =3D (struct nlattr *)(((char *)&req)
> -                               + NLMSG_ALIGN(req.nh.nlmsg_len));
> -       nla->nla_type =3D NLA_F_NESTED | IFLA_XDP;
> -       nla->nla_len =3D NLA_HDRLEN;
> +       nla =3D begin_nlattr_nested(&req.nh, sizeof(req), IFLA_XDP);
> +       if (!nla) {
> +               ret =3D -EMSGSIZE;
> +               goto cleanup;
> +       }
>
>         /* add XDP fd */
> -       nla_xdp =3D (struct nlattr *)((char *)nla + nla->nla_len);
> -       nla_xdp->nla_type =3D IFLA_XDP_FD;
> -       nla_xdp->nla_len =3D NLA_HDRLEN + sizeof(int);
> -       memcpy((char *)nla_xdp + NLA_HDRLEN, &fd, sizeof(fd));
> -       nla->nla_len +=3D nla_xdp->nla_len;
> +       ret =3D add_nlattr(&req.nh, sizeof(req), IFLA_XDP_FD, &fd, sizeof=
(fd));
> +       if (ret < 0)
> +               goto cleanup;
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
> +               ret =3D add_nlattr(&req.nh, sizeof(req), IFLA_XDP_FLAGS, =
&flags, sizeof(flags));
> +               if (ret < 0)
> +                       goto cleanup;
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
> +               ret =3D add_nlattr(&req.nh, sizeof(req), IFLA_XDP_EXPECTE=
D_FD, &flags, sizeof(flags));
> +               if (ret < 0)
> +                       goto cleanup;
>         }
>
> -       req.nh.nlmsg_len +=3D NLA_ALIGN(nla->nla_len);
> +       end_nlattr_nested(&req.nh, nla);
>
>         if (send(sock, &req, req.nh.nlmsg_len, 0) < 0) {
>                 ret =3D -errno;
> diff --git a/tools/lib/bpf/nlattr.h b/tools/lib/bpf/nlattr.h
> index 6cc3ac91690f..463a53bf3022 100644
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
> @@ -103,4 +106,44 @@ int libbpf_nla_parse_nested(struct nlattr *tb[], int=
 maxtype,
>
>  int libbpf_nla_dump_errormsg(struct nlmsghdr *nlh);
>
> +
> +/* Helpers for preparing/consuming attributes */
> +
> +#define NLA_DATA(nla) ((struct nlattr *)((char *)(nla) + NLA_HDRLEN))

`((char *)nh + NLMSG_ALIGN(nh->nlmsg_len))` seems to be another
popular one (three occurrences in this file), maybe extract that one
as well?

And can you please use functions, not macros? This way you can specify
what types you expect, as one of the benefits.

> +
> +static inline int add_nlattr(struct nlmsghdr *nh, size_t maxsz, int type=
,
> +                            const void *data, int len)
> +{
> +       struct nlattr *nla;
> +
> +       if (NLMSG_ALIGN(nh->nlmsg_len) + NLA_ALIGN(NLA_HDRLEN + len) > ma=
xsz)
> +               return -EMSGSIZE;
> +       if ((!data && len) || (data && !len))
> +               return -EINVAL;
> +
> +       nla =3D (struct nlattr *)((char *)nh + NLMSG_ALIGN(nh->nlmsg_len)=
);
> +       nla->nla_type =3D type;
> +       nla->nla_len =3D NLA_HDRLEN + len;
> +       if (data)
> +               memcpy((char *)nla + NLA_HDRLEN, data, len);
> +       nh->nlmsg_len =3D NLMSG_ALIGN(nh->nlmsg_len) + NLA_ALIGN(nla->nla=
_len);
> +       return 0;
> +}
> +
> +static inline struct nlattr *begin_nlattr_nested(struct nlmsghdr *nh, si=
ze_t maxsz,
> +                                              int type)
> +{
> +       struct nlattr *tail;
> +
> +       tail =3D (struct nlattr *)((char *)nh + NLMSG_ALIGN(nh->nlmsg_len=
));
> +       if (add_nlattr(nh, maxsz, type | NLA_F_NESTED, NULL, 0))
> +               return NULL;
> +       return tail;
> +}
> +
> +static inline void end_nlattr_nested(struct nlmsghdr *nh, struct nlattr =
*tail)

I don't know much about their use (yet, I feel like I'm about to learn
:( ), but would nlattr_add, nlattr_begin_nested/nlattr_start_nested,
nlattr_end_nested make sense and be a bit more in line with overall
object_action naming pattern?

> +{
> +       tail->nla_len =3D ((char *)nh + NLMSG_ALIGN(nh->nlmsg_len)) - (ch=
ar *)(tail);
> +}
> +
>  #endif /* __LIBBPF_NLATTR_H */
> --
> 2.30.2
>
