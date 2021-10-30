Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECD8D4406F2
	for <lists+netdev@lfdr.de>; Sat, 30 Oct 2021 04:42:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231641AbhJ3CpK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 22:45:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231522AbhJ3CpJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Oct 2021 22:45:09 -0400
Received: from mail-qv1-xf29.google.com (mail-qv1-xf29.google.com [IPv6:2607:f8b0:4864:20::f29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF114C061570;
        Fri, 29 Oct 2021 19:42:39 -0700 (PDT)
Received: by mail-qv1-xf29.google.com with SMTP id v2so7558488qve.11;
        Fri, 29 Oct 2021 19:42:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qMW69CHxQGpNnhAkNKPRDDtsEZGfHtFrwwNPa8aIYaY=;
        b=k/hTgn3lRJV/6kfSO/s5arnLWVXhmg6ujrGaBU3d8kb/iy8MKUHJjvbuljDJLaeboS
         Ax2ZJCREMw6F3o3Td9o2XVPPV20suzFi7wS9efLeNiWnyo/SiKV6nvu147bvucQJqiXn
         DdQVMHa9A6aXPbk8KdTeuImsXPCSb1+l1HA4sfnD5C8k+x041y8ZGqJ2rER5EDNwjtwB
         VeJMjlebHqbOVdrY4XMwjzWCVHM1Qb5rM2NczgNOTyLntSoRWC79CHc0od7A6tZ7OuAO
         MA80EKRdAG24mUnYTESjcyclT1gw1nEDL4wqPDJkQVQf7vAy9aZQrNTMB7i3QKoGw9Hd
         sIJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qMW69CHxQGpNnhAkNKPRDDtsEZGfHtFrwwNPa8aIYaY=;
        b=0qgX6YZmb/XFFALEXjAjkVynPjEI8AxKJX+NXeCz7pv+hfHr6PsNc6UEtcrA8+puDW
         tXk7FdCDpLBITEpVMIU4nIRDMglJTQlyWBeH3AUh0sz+K9fFiE9g/St3WuDrpL9RIA1q
         crgxjnYXlkXVYIV7C8Gf9FkitYUk002BUlSKnmGWWNhHpnVIdUqQVv17vXWUAmsMj3ng
         5OBHSfRA8Gi+hNHuCSfIMeb1DJvnUWYRWu5oc6EnBjghgFMejgaM1AOSGTJzVYf3WHNa
         s3EUUHW3dU3QmnBdysAbZnGAZZYzO9vMrnsCX9viZ1DtTheZjr7TN7elqhXgjPfX5BOX
         Pj/g==
X-Gm-Message-State: AOAM533WPjrXQJGwLXEIT3UfcnXtXcRYPe0F4NxNMOIGiabyrhQH5i0+
        7ZymkZtzdn7tNRftM8vfuKLc4vdQApKVZNV5Fl8=
X-Google-Smtp-Source: ABdhPJyCnJSFXqCUWrkPgYBKBMKP6N4F6HfYQLR6Ow2+wIYUh6hcbkxM4L9M/mQcNaGykrR3OCtZGgayxN+ycayHOg4=
X-Received: by 2002:a05:6214:2308:: with SMTP id gc8mr14408587qvb.31.1635561758501;
 Fri, 29 Oct 2021 19:42:38 -0700 (PDT)
MIME-Version: 1.0
References: <20211029032604.5432-1-xingwu.yang@gmail.com> <8bdab9e0-3bd4-c37-94e9-ca1f74883356@ssi.bg>
In-Reply-To: <8bdab9e0-3bd4-c37-94e9-ca1f74883356@ssi.bg>
From:   yangxingwu <xingwu.yang@gmail.com>
Date:   Sat, 30 Oct 2021 10:42:27 +0800
Message-ID: <CA+7U5Juzh+2+3Bnxc9jVPWT71=h6pwfVoWAtam7Cuxasr28C4Q@mail.gmail.com>
Subject: Re: [PATCH v2] ipvs: Fix reuse connection if RS weight is 0
To:     Julian Anastasov <ja@ssi.bg>
Cc:     Simon Horman <horms@verge.net.au>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netdev@vger.kernel.org, lvs-devel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-doc@vger.kernel.org, legend050709@qq.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

thanks Julian

I will do that

On Sat, Oct 30, 2021 at 3:25 AM Julian Anastasov <ja@ssi.bg> wrote:
>
>
>         Hello,
>
> On Fri, 29 Oct 2021, yangxingwu wrote:
>
> > Since commit dc7b3eb900aa ("ipvs: Fix reuse connection if real server is
> > dead"), new connections to dead servers are redistributed immediately to
> > new servers.
> >
> > Then commit d752c3645717 ("ipvs: allow rescheduling of new connections when
> > port reuse is detected") disable expire_nodest_conn if conn_reuse_mode is
> > 0. And new connection may be distributed to a real server with weight 0.
>
>         Can you better explain in commit message that we are changing
> expire_nodest_conn to work even for reused connections when
> conn_reuse_mode=0 but without affecting the controlled/persistent
> connections during the grace period while server is with weight=0.
>
>         Even if you target -next trees adding commit d752c3645717
> as Fixes line would be a good idea. Make sure the tree is specified
> after the v3 tag.
>
> > Co-developed-by: Chuanqi Liu <legend050709@qq.com>
> > Signed-off-by: Chuanqi Liu <legend050709@qq.com>
> > Signed-off-by: yangxingwu <xingwu.yang@gmail.com>
> > ---
> >  Documentation/networking/ipvs-sysctl.rst | 3 +--
> >  net/netfilter/ipvs/ip_vs_core.c          | 7 ++++---
> >  2 files changed, 5 insertions(+), 5 deletions(-)
> >
> > diff --git a/Documentation/networking/ipvs-sysctl.rst b/Documentation/networking/ipvs-sysctl.rst
> > index 2afccc63856e..1cfbf1add2fc 100644
> > --- a/Documentation/networking/ipvs-sysctl.rst
> > +++ b/Documentation/networking/ipvs-sysctl.rst
> > @@ -37,8 +37,7 @@ conn_reuse_mode - INTEGER
> >
> >       0: disable any special handling on port reuse. The new
> >       connection will be delivered to the same real server that was
> > -     servicing the previous connection. This will effectively
> > -     disable expire_nodest_conn.
> > +     servicing the previous connection.
> >
> >       bit 1: enable rescheduling of new connections when it is safe.
> >       That is, whenever expire_nodest_conn and for TCP sockets, when
> > diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
> > index 128690c512df..374f4b0b7080 100644
> > --- a/net/netfilter/ipvs/ip_vs_core.c
> > +++ b/net/netfilter/ipvs/ip_vs_core.c
> > @@ -2042,14 +2042,15 @@ ip_vs_in(struct netns_ipvs *ipvs, unsigned int hooknum, struct sk_buff *skb, int
> >                            ipvs, af, skb, &iph);
> >
> >       conn_reuse_mode = sysctl_conn_reuse_mode(ipvs);
> > -     if (conn_reuse_mode && !iph.fragoffs && is_new_conn(skb, &iph) && cp) {
> > +     if (!iph.fragoffs && is_new_conn(skb, &iph) && cp) {
>
>         It is even better to move the !cp->control check above:
>
>         if (!iph.fragoffs && is_new_conn(skb, &iph) && cp && !cp->control) {
>
>         Then is not needed in is_new_conn_expected() anymore.
>
> >               bool old_ct = false, resched = false;
>
>         And now you can move conn_reuse_mode here:
>
>                 int conn_reuse_mode = sysctl_conn_reuse_mode(ipvs);
>
> >               if (unlikely(sysctl_expire_nodest_conn(ipvs)) && cp->dest &&
> > -                 unlikely(!atomic_read(&cp->dest->weight))) {
> > +                 unlikely(!atomic_read(&cp->dest->weight)) && !cp->control) {
> >                       resched = true;
> >                       old_ct = ip_vs_conn_uses_old_conntrack(cp, skb);
> > -             } else if (is_new_conn_expected(cp, conn_reuse_mode)) {
> > +             } else if (conn_reuse_mode &&
> > +                        is_new_conn_expected(cp, conn_reuse_mode)) {
> >                       old_ct = ip_vs_conn_uses_old_conntrack(cp, skb);
> >                       if (!atomic_read(&cp->n_control)) {
> >                               resched = true;
> > --
> > 2.30.2
>
> Regards
>
> --
> Julian Anastasov <ja@ssi.bg>
