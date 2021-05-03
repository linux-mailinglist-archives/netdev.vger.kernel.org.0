Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8DA837232F
	for <lists+netdev@lfdr.de>; Tue,  4 May 2021 00:47:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229781AbhECWsi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 May 2021 18:48:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbhECWsi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 May 2021 18:48:38 -0400
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7685EC061574;
        Mon,  3 May 2021 15:47:44 -0700 (PDT)
Received: by mail-yb1-xb2a.google.com with SMTP id b131so9692874ybg.5;
        Mon, 03 May 2021 15:47:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=u05xLMWupQyNU1kgP1zZqASY4PvNhijjHgm3cpXcysQ=;
        b=ItRqT5lj6RiBwOhX2OOqpCFKgfr9MfmlmeZK+GHH0SNm/Wm5j/6gVJr91rcJos6KOW
         fZvBabaGJ3L7bDKfrJ9WIuoXHWfL32zuwaf30SSJbyicTal8UDSSWFYaMH39qTn9DCA4
         HTYxMdLxbfw5ILE8aLHT5xvuza8hv7N7IyYP4C2ON4CnNJc/0bM2XNFvkoZx5XM+Arm/
         IwBk5ktph2SRI3EaLcPVRqDxcyoaRQRFEY9o8F9FnEnDFLLUK9mWQVYQo7DlDKocOAd+
         7p5qhcXBfFM50slXrxCRtvzybwY78DTMn886HqbwDeIaCbQI8oJgpdxbh7GkszmRT1VE
         Ww3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=u05xLMWupQyNU1kgP1zZqASY4PvNhijjHgm3cpXcysQ=;
        b=aLfJWkccRRr3OI5i6XVkeE58G/dGwH31E4vitySMBhTwVmv16J2WT06NTzRxrw9DIX
         CMVIsn0wCvnjkR2D4JpeSdy8DwNHlU/26G4+5Zr7uep1jMSlERp4AhDRj4zckxXGxdQa
         8Sq2wKYoRhJgIb9Q53k6V5S/YjmoXLtcPC06QnEbjHHSwm2NFB9TFXK/bfdfej9S/hKb
         8NK4Bxf1Q+BPSbgarju+3pA7VroSaAeQZPB/z6Rng7IQ5sj0K3fzCOwsR/HukbIy17T0
         rODisLV3EXyZueayjKwffFWDjp+tWTgZdLZjHvNdVhDLYai/aID8HbzrytZSx5uQVp2N
         ANUw==
X-Gm-Message-State: AOAM530WYqdYb6QUesD6xmnX1l7gf31VWDxuw2Z9stUW8b2uEAf5Oqtb
        i3gbG788UgQ9FclYK2B3LKopSMd/5n6y2uQcC7U=
X-Google-Smtp-Source: ABdhPJyXBbKEUHd5qJntflkGn3mZ6oo+lpMd8V01Wf7TjzExVcf5NhQYFpik2/iI1D6/IBB4h9/P4DTmil0v6VBzb1U=
X-Received: by 2002:a25:1455:: with SMTP id 82mr29930925ybu.403.1620082063426;
 Mon, 03 May 2021 15:47:43 -0700 (PDT)
MIME-Version: 1.0
References: <20210428162553.719588-1-memxor@gmail.com> <20210428162553.719588-2-memxor@gmail.com>
 <CAEf4Bzbc502GS+2t=Bj79FRDkE+mWRfP=DfD289zsNXB2oT+iA@mail.gmail.com> <20210501061325.ohfnhejmcohch7a5@apollo>
In-Reply-To: <20210501061325.ohfnhejmcohch7a5@apollo>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 3 May 2021 15:47:32 -0700
Message-ID: <CAEf4BzbwbqsWyc7cuk550Cg+F35rQFzAuLE+oJ6roBOcA=4jeA@mail.gmail.com>
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

On Fri, Apr 30, 2021 at 11:13 PM Kumar Kartikeya Dwivedi
<memxor@gmail.com> wrote:
>
> On Sat, May 01, 2021 at 12:34:39AM IST, Andrii Nakryiko wrote:
> > On Wed, Apr 28, 2021 at 9:26 AM Kumar Kartikeya Dwivedi
> > <memxor@gmail.com> wrote:
> > >
> > > This change introduces a few helpers to wrap open coded attribute
> > > preparation in netlink.c. It also adds a libbpf_nl_send_recv that is =
useful
> > > to wrap send + recv handling in a generic way. Subsequent patch will
> > > also use this function for sending and receiving a netlink response.
> > > The libbpf_nl_get_link helper has been removed instead, moving socket
> > > creation into the newly named libbpf_nl_send_recv.
> > >
> > > Every nested attribute's closure must happen using the helper
> > > nlattr_end_nested, which sets its length properly. NLA_F_NESTED is
> > > enforced using nlattr_begin_nested helper. Other simple attributes
> > > can be added directly.
> > >
> > > The maxsz parameter corresponds to the size of the request structure
> > > which is being filled in, so for instance with req being:
> > >
> > > struct {
> > >         struct nlmsghdr nh;
> > >         struct tcmsg t;
> > >         char buf[4096];
> > > } req;
> > >
> > > Then, maxsz should be sizeof(req).
> > >
> > > This change also converts the open coded attribute preparation with t=
he
> > > helpers. Note that the only failure the internal call to nlattr_add
> > > could result in the nested helper would be -EMSGSIZE, hence that is w=
hat
> > > we return to our caller.
> > >
> > > The libbpf_nl_send_recv call takes care of opening the socket, sendin=
g the
> > > netlink message, receiving the response, potentially invoking callbac=
ks,
> > > and return errors if any, and then finally close the socket. This all=
ows
> > > users to avoid identical socket setup code in different places. The o=
nly
> > > user of libbpf_nl_get_link has been converted to make use of it.
> > >
> > > __bpf_set_link_xdp_fd_replace has also been refactored to use it.
> > >
> > > Reviewed-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> > > Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> > > ---
> > >  tools/lib/bpf/netlink.c | 117 ++++++++++++++++++--------------------=
--
> > >  tools/lib/bpf/nlattr.h  |  48 +++++++++++++++++
> > >  2 files changed, 100 insertions(+), 65 deletions(-)
> > >
> > > diff --git a/tools/lib/bpf/netlink.c b/tools/lib/bpf/netlink.c
> > > index d2cb28e9ef52..6daee6640725 100644
> > > --- a/tools/lib/bpf/netlink.c
> > > +++ b/tools/lib/bpf/netlink.c
> > > @@ -131,72 +131,53 @@ static int bpf_netlink_recv(int sock, __u32 nl_=
pid, int seq,
> > >         return ret;
> > >  }
> > >
> > > +static int libbpf_nl_send_recv(struct nlmsghdr *nh, __dump_nlmsg_t f=
n,
> > > +                              libbpf_dump_nlmsg_t _fn, void *cookie)=
;
> > > +
> > >  static int __bpf_set_link_xdp_fd_replace(int ifindex, int fd, int ol=
d_fd,
> > >                                          __u32 flags)
> > >  {
> > > -       int sock, seq =3D 0, ret;
> > > -       struct nlattr *nla, *nla_xdp;
> > > +       struct nlattr *nla;
> > > +       int ret;
> > >         struct {
> > >                 struct nlmsghdr  nh;
> > >                 struct ifinfomsg ifinfo;
> > >                 char             attrbuf[64];
> > >         } req;
> > > -       __u32 nl_pid =3D 0;
> > > -
> > > -       sock =3D libbpf_netlink_open(&nl_pid);
> > > -       if (sock < 0)
> > > -               return sock;
> > >
> > >         memset(&req, 0, sizeof(req));
> > >         req.nh.nlmsg_len =3D NLMSG_LENGTH(sizeof(struct ifinfomsg));
> > >         req.nh.nlmsg_flags =3D NLM_F_REQUEST | NLM_F_ACK;
> > >         req.nh.nlmsg_type =3D RTM_SETLINK;
> > > -       req.nh.nlmsg_pid =3D 0;
> > > -       req.nh.nlmsg_seq =3D ++seq;
> > >         req.ifinfo.ifi_family =3D AF_UNSPEC;
> > >         req.ifinfo.ifi_index =3D ifindex;
> > >
> > >         /* started nested attribute for XDP */
> > > -       nla =3D (struct nlattr *)(((char *)&req)
> > > -                               + NLMSG_ALIGN(req.nh.nlmsg_len));
> > > -       nla->nla_type =3D NLA_F_NESTED | IFLA_XDP;
> > > -       nla->nla_len =3D NLA_HDRLEN;
> > > +       nla =3D nlattr_begin_nested(&req.nh, sizeof(req), IFLA_XDP);
> > > +       if (!nla)
> > > +               return -EMSGSIZE;
> > >
> > >         /* add XDP fd */
> > > -       nla_xdp =3D (struct nlattr *)((char *)nla + nla->nla_len);
> > > -       nla_xdp->nla_type =3D IFLA_XDP_FD;
> > > -       nla_xdp->nla_len =3D NLA_HDRLEN + sizeof(int);
> > > -       memcpy((char *)nla_xdp + NLA_HDRLEN, &fd, sizeof(fd));
> > > -       nla->nla_len +=3D nla_xdp->nla_len;
> > > +       ret =3D nlattr_add(&req.nh, sizeof(req), IFLA_XDP_FD, &fd, si=
zeof(fd));
> > > +       if (ret < 0)
> > > +               return ret;
> > >
> > >         /* if user passed in any flags, add those too */
> > >         if (flags) {
> > > -               nla_xdp =3D (struct nlattr *)((char *)nla + nla->nla_=
len);
> > > -               nla_xdp->nla_type =3D IFLA_XDP_FLAGS;
> > > -               nla_xdp->nla_len =3D NLA_HDRLEN + sizeof(flags);
> > > -               memcpy((char *)nla_xdp + NLA_HDRLEN, &flags, sizeof(f=
lags));
> > > -               nla->nla_len +=3D nla_xdp->nla_len;
> > > +               ret =3D nlattr_add(&req.nh, sizeof(req), IFLA_XDP_FLA=
GS, &flags, sizeof(flags));
> > > +               if (ret < 0)
> > > +                       return ret;
> > >         }
> > >
> > >         if (flags & XDP_FLAGS_REPLACE) {
> > > -               nla_xdp =3D (struct nlattr *)((char *)nla + nla->nla_=
len);
> > > -               nla_xdp->nla_type =3D IFLA_XDP_EXPECTED_FD;
> > > -               nla_xdp->nla_len =3D NLA_HDRLEN + sizeof(old_fd);
> > > -               memcpy((char *)nla_xdp + NLA_HDRLEN, &old_fd, sizeof(=
old_fd));
> > > -               nla->nla_len +=3D nla_xdp->nla_len;
> > > +               ret =3D nlattr_add(&req.nh, sizeof(req), IFLA_XDP_EXP=
ECTED_FD, &flags, sizeof(flags));
> >
> > shouldn't old_fd be used here?
> >
>
> Ouch, yes, thanks for spotting this.
>
> > > +               if (ret < 0)
> > > +                       return ret;
> > >         }
> > >
> > > -       req.nh.nlmsg_len +=3D NLA_ALIGN(nla->nla_len);
> > > +       nlattr_end_nested(&req.nh, nla);
> > >
> > > -       if (send(sock, &req, req.nh.nlmsg_len, 0) < 0) {
> > > -               ret =3D -errno;
> > > -               goto cleanup;
> > > -       }
> > > -       ret =3D bpf_netlink_recv(sock, nl_pid, seq, NULL, NULL, NULL)=
;
> > > -
> > > -cleanup:
> > > -       close(sock);
> > > -       return ret;
> > > +       return libbpf_nl_send_recv(&req.nh, NULL, NULL, NULL);
> > >  }
> > >
> > >  int bpf_set_link_xdp_fd_opts(int ifindex, int fd, __u32 flags,
> >
> > [...]
> >
> > > -int libbpf_nl_get_link(int sock, unsigned int nl_pid,
> > > -                      libbpf_dump_nlmsg_t dump_link_nlmsg, void *coo=
kie)
> > > +static int libbpf_nl_send_recv(struct nlmsghdr *nh, __dump_nlmsg_t f=
n,
> > > +                              libbpf_dump_nlmsg_t _fn, void *cookie)
> > >  {
> > > -       struct {
> > > -               struct nlmsghdr nlh;
> > > -               struct ifinfomsg ifm;
> > > -       } req =3D {
> > > -               .nlh.nlmsg_len =3D NLMSG_LENGTH(sizeof(struct ifinfom=
sg)),
> > > -               .nlh.nlmsg_type =3D RTM_GETLINK,
> > > -               .nlh.nlmsg_flags =3D NLM_F_DUMP | NLM_F_REQUEST,
> > > -               .ifm.ifi_family =3D AF_PACKET,
> > > -       };
> > > -       int seq =3D time(NULL);
> > > +       __u32 nl_pid =3D 0;
> > > +       int sock, ret;
> > >
> > > -       req.nlh.nlmsg_seq =3D seq;
> > > -       if (send(sock, &req, req.nlh.nlmsg_len, 0) < 0)
> > > -               return -errno;
> > > +       if (!nh)
> > > +               return -EINVAL;
> > > +
> > > +       sock =3D libbpf_netlink_open(&nl_pid);
> > > +       if (sock < 0)
> > > +               return sock;
> > >
> > > -       return bpf_netlink_recv(sock, nl_pid, seq, __dump_link_nlmsg,
> > > -                               dump_link_nlmsg, cookie);
> > > +       nh->nlmsg_pid =3D 0;
> > > +       nh->nlmsg_seq =3D time(NULL);
> > > +       if (send(sock, nh, nh->nlmsg_len, 0) < 0) {
> > > +               ret =3D -errno;
> > > +               goto end;
> > > +       }
> > > +
> > > +       ret =3D bpf_netlink_recv(sock, nl_pid, nh->nlmsg_seq, fn, _fn=
, cookie);
> >
> > what's the difference between fn and _fn, can this be somehow
> > reflected in the name?
> >
>
> You can use fn as a common parsing function for the same RTM_GET* message=
, and
> then use _fn to parse a nested layer of attributes below it to fill in di=
fferent
> kind of opts (through the cookie user data parameter).
>
> How about outer_cb, inner_cb?

so the outer thingy is "message" and internal one is "attribute" in
netlink lingo? If yes, then parse_msg and parse_attr would make more
sense, imo. If not, outer_cb/inner_cb is fine as well.

>
> > > +
> > > +end:
> > > +       close(sock);
> > > +       return ret;
> > >  }
> > > diff --git a/tools/lib/bpf/nlattr.h b/tools/lib/bpf/nlattr.h
> > > index 6cc3ac91690f..1c94cdb6e89d 100644
> > > --- a/tools/lib/bpf/nlattr.h
> > > +++ b/tools/lib/bpf/nlattr.h
> > > @@ -10,7 +10,10 @@
> > >  #define __LIBBPF_NLATTR_H
> > >
> > >  #include <stdint.h>
> > > +#include <string.h>
> > > +#include <errno.h>
> > >  #include <linux/netlink.h>
> > > +
> > >  /* avoid multiple definition of netlink features */
> > >  #define __LINUX_NETLINK_H
> > >
> > > @@ -103,4 +106,49 @@ int libbpf_nla_parse_nested(struct nlattr *tb[],=
 int maxtype,
> > >
> > >  int libbpf_nla_dump_errormsg(struct nlmsghdr *nlh);
> > >
> > > +static inline struct nlattr *nla_data(struct nlattr *nla)
> > > +{
> > > +       return (struct nlattr *)((char *)nla + NLA_HDRLEN);
> > > +}
> > > +
> > > +static inline struct nlattr *nh_tail(struct nlmsghdr *nh)
> > > +{
> > > +       return (struct nlattr *)((char *)nh + NLMSG_ALIGN(nh->nlmsg_l=
en));
> > > +}
> > > +
> > > +static inline int nlattr_add(struct nlmsghdr *nh, size_t maxsz, int =
type,
> > > +                            const void *data, int len)
> > > +{
> > > +       struct nlattr *nla;
> > > +
> > > +       if (NLMSG_ALIGN(nh->nlmsg_len) + NLA_ALIGN(NLA_HDRLEN + len) =
> maxsz)
> > > +               return -EMSGSIZE;
> > > +       if ((!data && len) || (data && !len))
> >
> > we use !!data !=3D !!len for this in at least few places
> >
>
> Ok.
>
> > > +               return -EINVAL;
> > > +
> > > +       nla =3D nh_tail(nh);
> > > +       nla->nla_type =3D type;
> > > +       nla->nla_len =3D NLA_HDRLEN + len;
> > > +       if (data)
> > > +               memcpy(nla_data(nla), data, len);
> > > +       nh->nlmsg_len =3D NLMSG_ALIGN(nh->nlmsg_len) + NLA_ALIGN(nla-=
>nla_len);
> > > +       return 0;
> > > +}
> > > +
> >
> > [...]
>
> --
> Kartikeya
