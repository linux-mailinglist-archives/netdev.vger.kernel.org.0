Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F0F63705DC
	for <lists+netdev@lfdr.de>; Sat,  1 May 2021 08:13:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231575AbhEAGOT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 May 2021 02:14:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbhEAGOS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 May 2021 02:14:18 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C6F6C06174A;
        Fri, 30 Apr 2021 23:13:29 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id m11so572203pfc.11;
        Fri, 30 Apr 2021 23:13:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=KYWQk+3xvF2krMev5F9btNbGIGq/MIb60igDndIpebg=;
        b=aMTK+mvII3gD3l0j6jmw3U+sOcoFJEWGs5w6j7xY5iowDEOcs93ww/IOI8j5VJ5RKK
         ZnYIMyQ8HrYJXBL6k2GrmmA5bi3PTr4NqKPrBiV8XyH1HVaA6OZh8hhQZFSBB7Kd9xDO
         Ojxn+pjIbzBuuvhWBA1ip9o4afl5lppQnWMZHcktuc32nW8txJY4d46uJhUJtsif3rkG
         W8El2FIi1VgffRgvxtdDe+VF3X7lsre7TG+NyyoujSsrQE/r4vdX1R13It0SRhMuQyAc
         98mYVRCm59V3/h+G1oGl6ZbcuTiy7yF7ztrlvcA2XG0PJKQYS+r0re3RqJ2KVjUCtnTP
         MonQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=KYWQk+3xvF2krMev5F9btNbGIGq/MIb60igDndIpebg=;
        b=M8NaObKJ5okXh6+l//a7Jh0+SVVI90hympibT03SJCVtTqGJ0Iv6xWAl6O/L6Nv1s3
         hH42T3EkHP4KELn+BAfLli8LRN45rBDiOy/E2VZiB6WSePxAeI+6McNzy2xxSkDXELMG
         VJN2En490UPDDdK+KBRrfHnJBoYPBQI25ro6/kZwaJfQvaPgAYQ9plFBDlTbkoO8zntT
         U/dOszhZAcjH2lCypcLpKoxQYzR07yd3Y3u2lavuMawU1TfLEDf9Fw53onpzyxbl+6eR
         kTs7GqadCr97NxJB4dJUDlT/yLRrM98DqvpZexqzPQoO34ZRChnAeJzvhv5ZsdmfmP2L
         hZpQ==
X-Gm-Message-State: AOAM531/cTNL/miBhcdQQzgB+EZNEAqCMJ6zUbBny9wSlEHX/BM++Tdg
        v0hOViRTPswoHUoLh8AVxHA=
X-Google-Smtp-Source: ABdhPJwYlpa+m4Irr90ZVLDiCJP1TuKyY4W80dB5bWA9huZ3XykJ0Djr0aCJyfyk2EebwhVX0d0xpQ==
X-Received: by 2002:a62:1ec2:0:b029:275:9866:be33 with SMTP id e185-20020a621ec20000b02902759866be33mr8340462pfe.15.1619849608604;
        Fri, 30 Apr 2021 23:13:28 -0700 (PDT)
Received: from localhost ([112.79.230.123])
        by smtp.gmail.com with ESMTPSA id 76sm3687590pfw.58.2021.04.30.23.13.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Apr 2021 23:13:28 -0700 (PDT)
Date:   Sat, 1 May 2021 11:43:25 +0530
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
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
Subject: Re: [PATCH bpf-next v5 1/3] libbpf: add netlink helpers
Message-ID: <20210501061325.ohfnhejmcohch7a5@apollo>
References: <20210428162553.719588-1-memxor@gmail.com>
 <20210428162553.719588-2-memxor@gmail.com>
 <CAEf4Bzbc502GS+2t=Bj79FRDkE+mWRfP=DfD289zsNXB2oT+iA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAEf4Bzbc502GS+2t=Bj79FRDkE+mWRfP=DfD289zsNXB2oT+iA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 01, 2021 at 12:34:39AM IST, Andrii Nakryiko wrote:
> On Wed, Apr 28, 2021 at 9:26 AM Kumar Kartikeya Dwivedi
> <memxor@gmail.com> wrote:
> >
> > This change introduces a few helpers to wrap open coded attribute
> > preparation in netlink.c. It also adds a libbpf_nl_send_recv that is useful
> > to wrap send + recv handling in a generic way. Subsequent patch will
> > also use this function for sending and receiving a netlink response.
> > The libbpf_nl_get_link helper has been removed instead, moving socket
> > creation into the newly named libbpf_nl_send_recv.
> >
> > Every nested attribute's closure must happen using the helper
> > nlattr_end_nested, which sets its length properly. NLA_F_NESTED is
> > enforced using nlattr_begin_nested helper. Other simple attributes
> > can be added directly.
> >
> > The maxsz parameter corresponds to the size of the request structure
> > which is being filled in, so for instance with req being:
> >
> > struct {
> >         struct nlmsghdr nh;
> >         struct tcmsg t;
> >         char buf[4096];
> > } req;
> >
> > Then, maxsz should be sizeof(req).
> >
> > This change also converts the open coded attribute preparation with the
> > helpers. Note that the only failure the internal call to nlattr_add
> > could result in the nested helper would be -EMSGSIZE, hence that is what
> > we return to our caller.
> >
> > The libbpf_nl_send_recv call takes care of opening the socket, sending the
> > netlink message, receiving the response, potentially invoking callbacks,
> > and return errors if any, and then finally close the socket. This allows
> > users to avoid identical socket setup code in different places. The only
> > user of libbpf_nl_get_link has been converted to make use of it.
> >
> > __bpf_set_link_xdp_fd_replace has also been refactored to use it.
> >
> > Reviewed-by: Toke Høiland-Jørgensen <toke@redhat.com>
> > Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> > ---
> >  tools/lib/bpf/netlink.c | 117 ++++++++++++++++++----------------------
> >  tools/lib/bpf/nlattr.h  |  48 +++++++++++++++++
> >  2 files changed, 100 insertions(+), 65 deletions(-)
> >
> > diff --git a/tools/lib/bpf/netlink.c b/tools/lib/bpf/netlink.c
> > index d2cb28e9ef52..6daee6640725 100644
> > --- a/tools/lib/bpf/netlink.c
> > +++ b/tools/lib/bpf/netlink.c
> > @@ -131,72 +131,53 @@ static int bpf_netlink_recv(int sock, __u32 nl_pid, int seq,
> >         return ret;
> >  }
> >
> > +static int libbpf_nl_send_recv(struct nlmsghdr *nh, __dump_nlmsg_t fn,
> > +                              libbpf_dump_nlmsg_t _fn, void *cookie);
> > +
> >  static int __bpf_set_link_xdp_fd_replace(int ifindex, int fd, int old_fd,
> >                                          __u32 flags)
> >  {
> > -       int sock, seq = 0, ret;
> > -       struct nlattr *nla, *nla_xdp;
> > +       struct nlattr *nla;
> > +       int ret;
> >         struct {
> >                 struct nlmsghdr  nh;
> >                 struct ifinfomsg ifinfo;
> >                 char             attrbuf[64];
> >         } req;
> > -       __u32 nl_pid = 0;
> > -
> > -       sock = libbpf_netlink_open(&nl_pid);
> > -       if (sock < 0)
> > -               return sock;
> >
> >         memset(&req, 0, sizeof(req));
> >         req.nh.nlmsg_len = NLMSG_LENGTH(sizeof(struct ifinfomsg));
> >         req.nh.nlmsg_flags = NLM_F_REQUEST | NLM_F_ACK;
> >         req.nh.nlmsg_type = RTM_SETLINK;
> > -       req.nh.nlmsg_pid = 0;
> > -       req.nh.nlmsg_seq = ++seq;
> >         req.ifinfo.ifi_family = AF_UNSPEC;
> >         req.ifinfo.ifi_index = ifindex;
> >
> >         /* started nested attribute for XDP */
> > -       nla = (struct nlattr *)(((char *)&req)
> > -                               + NLMSG_ALIGN(req.nh.nlmsg_len));
> > -       nla->nla_type = NLA_F_NESTED | IFLA_XDP;
> > -       nla->nla_len = NLA_HDRLEN;
> > +       nla = nlattr_begin_nested(&req.nh, sizeof(req), IFLA_XDP);
> > +       if (!nla)
> > +               return -EMSGSIZE;
> >
> >         /* add XDP fd */
> > -       nla_xdp = (struct nlattr *)((char *)nla + nla->nla_len);
> > -       nla_xdp->nla_type = IFLA_XDP_FD;
> > -       nla_xdp->nla_len = NLA_HDRLEN + sizeof(int);
> > -       memcpy((char *)nla_xdp + NLA_HDRLEN, &fd, sizeof(fd));
> > -       nla->nla_len += nla_xdp->nla_len;
> > +       ret = nlattr_add(&req.nh, sizeof(req), IFLA_XDP_FD, &fd, sizeof(fd));
> > +       if (ret < 0)
> > +               return ret;
> >
> >         /* if user passed in any flags, add those too */
> >         if (flags) {
> > -               nla_xdp = (struct nlattr *)((char *)nla + nla->nla_len);
> > -               nla_xdp->nla_type = IFLA_XDP_FLAGS;
> > -               nla_xdp->nla_len = NLA_HDRLEN + sizeof(flags);
> > -               memcpy((char *)nla_xdp + NLA_HDRLEN, &flags, sizeof(flags));
> > -               nla->nla_len += nla_xdp->nla_len;
> > +               ret = nlattr_add(&req.nh, sizeof(req), IFLA_XDP_FLAGS, &flags, sizeof(flags));
> > +               if (ret < 0)
> > +                       return ret;
> >         }
> >
> >         if (flags & XDP_FLAGS_REPLACE) {
> > -               nla_xdp = (struct nlattr *)((char *)nla + nla->nla_len);
> > -               nla_xdp->nla_type = IFLA_XDP_EXPECTED_FD;
> > -               nla_xdp->nla_len = NLA_HDRLEN + sizeof(old_fd);
> > -               memcpy((char *)nla_xdp + NLA_HDRLEN, &old_fd, sizeof(old_fd));
> > -               nla->nla_len += nla_xdp->nla_len;
> > +               ret = nlattr_add(&req.nh, sizeof(req), IFLA_XDP_EXPECTED_FD, &flags, sizeof(flags));
>
> shouldn't old_fd be used here?
>

Ouch, yes, thanks for spotting this.

> > +               if (ret < 0)
> > +                       return ret;
> >         }
> >
> > -       req.nh.nlmsg_len += NLA_ALIGN(nla->nla_len);
> > +       nlattr_end_nested(&req.nh, nla);
> >
> > -       if (send(sock, &req, req.nh.nlmsg_len, 0) < 0) {
> > -               ret = -errno;
> > -               goto cleanup;
> > -       }
> > -       ret = bpf_netlink_recv(sock, nl_pid, seq, NULL, NULL, NULL);
> > -
> > -cleanup:
> > -       close(sock);
> > -       return ret;
> > +       return libbpf_nl_send_recv(&req.nh, NULL, NULL, NULL);
> >  }
> >
> >  int bpf_set_link_xdp_fd_opts(int ifindex, int fd, __u32 flags,
>
> [...]
>
> > -int libbpf_nl_get_link(int sock, unsigned int nl_pid,
> > -                      libbpf_dump_nlmsg_t dump_link_nlmsg, void *cookie)
> > +static int libbpf_nl_send_recv(struct nlmsghdr *nh, __dump_nlmsg_t fn,
> > +                              libbpf_dump_nlmsg_t _fn, void *cookie)
> >  {
> > -       struct {
> > -               struct nlmsghdr nlh;
> > -               struct ifinfomsg ifm;
> > -       } req = {
> > -               .nlh.nlmsg_len = NLMSG_LENGTH(sizeof(struct ifinfomsg)),
> > -               .nlh.nlmsg_type = RTM_GETLINK,
> > -               .nlh.nlmsg_flags = NLM_F_DUMP | NLM_F_REQUEST,
> > -               .ifm.ifi_family = AF_PACKET,
> > -       };
> > -       int seq = time(NULL);
> > +       __u32 nl_pid = 0;
> > +       int sock, ret;
> >
> > -       req.nlh.nlmsg_seq = seq;
> > -       if (send(sock, &req, req.nlh.nlmsg_len, 0) < 0)
> > -               return -errno;
> > +       if (!nh)
> > +               return -EINVAL;
> > +
> > +       sock = libbpf_netlink_open(&nl_pid);
> > +       if (sock < 0)
> > +               return sock;
> >
> > -       return bpf_netlink_recv(sock, nl_pid, seq, __dump_link_nlmsg,
> > -                               dump_link_nlmsg, cookie);
> > +       nh->nlmsg_pid = 0;
> > +       nh->nlmsg_seq = time(NULL);
> > +       if (send(sock, nh, nh->nlmsg_len, 0) < 0) {
> > +               ret = -errno;
> > +               goto end;
> > +       }
> > +
> > +       ret = bpf_netlink_recv(sock, nl_pid, nh->nlmsg_seq, fn, _fn, cookie);
>
> what's the difference between fn and _fn, can this be somehow
> reflected in the name?
>

You can use fn as a common parsing function for the same RTM_GET* message, and
then use _fn to parse a nested layer of attributes below it to fill in different
kind of opts (through the cookie user data parameter).

How about outer_cb, inner_cb?

> > +
> > +end:
> > +       close(sock);
> > +       return ret;
> >  }
> > diff --git a/tools/lib/bpf/nlattr.h b/tools/lib/bpf/nlattr.h
> > index 6cc3ac91690f..1c94cdb6e89d 100644
> > --- a/tools/lib/bpf/nlattr.h
> > +++ b/tools/lib/bpf/nlattr.h
> > @@ -10,7 +10,10 @@
> >  #define __LIBBPF_NLATTR_H
> >
> >  #include <stdint.h>
> > +#include <string.h>
> > +#include <errno.h>
> >  #include <linux/netlink.h>
> > +
> >  /* avoid multiple definition of netlink features */
> >  #define __LINUX_NETLINK_H
> >
> > @@ -103,4 +106,49 @@ int libbpf_nla_parse_nested(struct nlattr *tb[], int maxtype,
> >
> >  int libbpf_nla_dump_errormsg(struct nlmsghdr *nlh);
> >
> > +static inline struct nlattr *nla_data(struct nlattr *nla)
> > +{
> > +       return (struct nlattr *)((char *)nla + NLA_HDRLEN);
> > +}
> > +
> > +static inline struct nlattr *nh_tail(struct nlmsghdr *nh)
> > +{
> > +       return (struct nlattr *)((char *)nh + NLMSG_ALIGN(nh->nlmsg_len));
> > +}
> > +
> > +static inline int nlattr_add(struct nlmsghdr *nh, size_t maxsz, int type,
> > +                            const void *data, int len)
> > +{
> > +       struct nlattr *nla;
> > +
> > +       if (NLMSG_ALIGN(nh->nlmsg_len) + NLA_ALIGN(NLA_HDRLEN + len) > maxsz)
> > +               return -EMSGSIZE;
> > +       if ((!data && len) || (data && !len))
>
> we use !!data != !!len for this in at least few places
>

Ok.

> > +               return -EINVAL;
> > +
> > +       nla = nh_tail(nh);
> > +       nla->nla_type = type;
> > +       nla->nla_len = NLA_HDRLEN + len;
> > +       if (data)
> > +               memcpy(nla_data(nla), data, len);
> > +       nh->nlmsg_len = NLMSG_ALIGN(nh->nlmsg_len) + NLA_ALIGN(nla->nla_len);
> > +       return 0;
> > +}
> > +
>
> [...]

--
Kartikeya
