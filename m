Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF476CE76A
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 17:27:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728641AbfJGP1P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 11:27:15 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:40795 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727970AbfJGP1O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Oct 2019 11:27:14 -0400
Received: by mail-pf1-f193.google.com with SMTP id x127so8871985pfb.7
        for <netdev@vger.kernel.org>; Mon, 07 Oct 2019 08:27:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fomichev-me.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=i7kGbGc2suN20OG7NxpXcj3YwXvFtg4ljyGOOGxKoRM=;
        b=sBmKhVCcdi2z9cibVkTM9wSpCFHOj3kxh6BDo/O3zNbi9OkiHRtdSA3toEn71ZOVyR
         IvxdpuIAoAsdeYIdnyOgC5o7neCeHUe9uenr8L+FfQKd9CKxj4nTYjjsOSma3ei1MleH
         HOHIQgR6kt8JCQsb1RaS8C0zm4zbi0LwLF82I5bZ7KZ9wXDGV+vloilyQws559KdLwGG
         fV1K0BHbMd0vdRTsBYEWsGGS+77IpRYB8xvSnhLq38a0q8iJstOUY8ofigD7XlsNPQBI
         hgBWthZ49NkgUdEpJy1IADRajJRXCgIf/GUlASvA/1nTvn7ZumSnm8jrR6JSkiYslj5C
         cPDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=i7kGbGc2suN20OG7NxpXcj3YwXvFtg4ljyGOOGxKoRM=;
        b=l5uxDUUAhxj9HMgFTsl9NToHbUjIp0V7c1c7w75RARJOxWPJ0mKXXY+Sv3zdXDQ0D1
         SbbaGb2lOWVuKhMFiXp4ilVteiLJGBTSll68WjQnPFkIeup5xHskniYO6s984bdsf0lJ
         gvGEWimbzl8ZlyXKmmgWairG8aPtAknKfsSYzO0FUWHzpqZ9xunjszhnmo9CXsoSCE6M
         wSRjx3oQ6eGPIfDZX8UMh2x9GckMpyLbO9BY9pwCjScDQvoA0/8upOUU8//6IVEFT6Gu
         +t3dDpb+mKD/2fiYNxp3riOj19UoUkrqqoytWL6TVog1Fl0jmxa9+/4VFp3blc7MjbNn
         Atpg==
X-Gm-Message-State: APjAAAVSGewTrrvPoxXXb7ZWzM7vqjXi83fzekHcXh5KdSoBXSWwfZkn
        RCW9WzkJ3224RvKxOcA7THJ1eg==
X-Google-Smtp-Source: APXvYqzrmF+iwSPglJBqNfjhIRaA1MnhT5dX5t2mAgaEzZKEJRMxS5LbZ1O58w1z4HL1m5jl7ydj2w==
X-Received: by 2002:a63:8bc1:: with SMTP id j184mr31170488pge.144.1570462033045;
        Mon, 07 Oct 2019 08:27:13 -0700 (PDT)
Received: from localhost ([2601:646:8f00:18d9:d0fa:7a4b:764f:de48])
        by smtp.gmail.com with ESMTPSA id s73sm13193496pjb.15.2019.10.07.08.27.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Oct 2019 08:27:12 -0700 (PDT)
Date:   Mon, 7 Oct 2019 08:27:11 -0700
From:   Stanislav Fomichev <sdf@fomichev.me>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Stanislav Fomichev <sdf@google.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Petar Penkov <ppenkov@google.com>
Subject: Re: [PATCH bpf-next v2 1/2] bpf/flow_dissector: add mode to enforce
 global BPF flow dissector
Message-ID: <20191007152711.GA2096@mini-arch>
References: <20191004155615.95469-1-sdf@google.com>
 <20191004155615.95469-2-sdf@google.com>
 <CAEf4BzYVGYsYZn7EVfSSy0UCx6B_w4hk2y6O6cP3qqbJYi8Pzw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzYVGYsYZn7EVfSSy0UCx6B_w4hk2y6O6cP3qqbJYi8Pzw@mail.gmail.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/05, Andrii Nakryiko wrote:
> On Fri, Oct 4, 2019 at 8:58 AM Stanislav Fomichev <sdf@google.com> wrote:
> >
> > Always use init_net flow dissector BPF program if it's attached and fall
> > back to the per-net namespace one. Also, deny installing new programs if
> > there is already one attached to the root namespace.
> > Users can still detach their BPF programs, but can't attach any
> > new ones (-EEXIST).
> >
> > Cc: Petar Penkov <ppenkov@google.com>
> > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > ---
> 
> Looks good, but see my note below. Regardless:
> 
> Acked-by: Andrii Nakryiko <andriin@fb.com>
> 
> >  Documentation/bpf/prog_flow_dissector.rst |  3 ++
> >  net/core/flow_dissector.c                 | 42 ++++++++++++++++++++---
> >  2 files changed, 41 insertions(+), 4 deletions(-)
> >
> > diff --git a/Documentation/bpf/prog_flow_dissector.rst b/Documentation/bpf/prog_flow_dissector.rst
> > index a78bf036cadd..4d86780ab0f1 100644
> > --- a/Documentation/bpf/prog_flow_dissector.rst
> > +++ b/Documentation/bpf/prog_flow_dissector.rst
> > @@ -142,3 +142,6 @@ BPF flow dissector doesn't support exporting all the metadata that in-kernel
> >  C-based implementation can export. Notable example is single VLAN (802.1Q)
> >  and double VLAN (802.1AD) tags. Please refer to the ``struct bpf_flow_keys``
> >  for a set of information that's currently can be exported from the BPF context.
> > +
> > +When BPF flow dissector is attached to the root network namespace (machine-wide
> > +policy), users can't override it in their child network namespaces.
> > diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
> > index 7c09d87d3269..9821e730fc70 100644
> > --- a/net/core/flow_dissector.c
> > +++ b/net/core/flow_dissector.c
> > @@ -114,19 +114,50 @@ int skb_flow_dissector_bpf_prog_attach(const union bpf_attr *attr,
> >  {
> >         struct bpf_prog *attached;
> >         struct net *net;
> > +       int ret = 0;
> >
> >         net = current->nsproxy->net_ns;
> >         mutex_lock(&flow_dissector_mutex);
> > +
> > +       if (net == &init_net) {
> > +               /* BPF flow dissector in the root namespace overrides
> > +                * any per-net-namespace one. When attaching to root,
> > +                * make sure we don't have any BPF program attached
> > +                * to the non-root namespaces.
> > +                */
> > +               struct net *ns;
> > +
> > +               for_each_net(ns) {
> > +                       if (net == &init_net)
> > +                               continue;
> 
> You don't need this condition, if something is attached to init_net,
> you will return -EEXIST anyway. Or is this a performance optimization?
Ah, I agree, will remove an respin.

> > +
> > +                       if (rcu_access_pointer(ns->flow_dissector_prog)) {
> > +                               ret = -EEXIST;
> > +                               goto out;
> > +                       }
> > +               }
> > +       } else {
> > +               /* Make sure root flow dissector is not attached
> > +                * when attaching to the non-root namespace.
> > +                */
> > +
> 
> nit: extra empty line
Thx, will fix.

> > +               if (rcu_access_pointer(init_net.flow_dissector_prog)) {
> > +                       ret = -EEXIST;
> > +                       goto out;
> > +               }
> > +       }
> > +
> >         attached = rcu_dereference_protected(net->flow_dissector_prog,
> >                                              lockdep_is_held(&flow_dissector_mutex));
> >         if (attached) {
> >                 /* Only one BPF program can be attached at a time */
> > -               mutex_unlock(&flow_dissector_mutex);
> > -               return -EEXIST;
> > +               ret = -EEXIST;
> > +               goto out;
> >         }
> >         rcu_assign_pointer(net->flow_dissector_prog, prog);
> > +out:
> >         mutex_unlock(&flow_dissector_mutex);
> > -       return 0;
> > +       return ret;
> >  }
> >
> >  int skb_flow_dissector_bpf_prog_detach(const union bpf_attr *attr)
> > @@ -910,7 +941,10 @@ bool __skb_flow_dissect(const struct net *net,
> >         WARN_ON_ONCE(!net);
> >         if (net) {
> >                 rcu_read_lock();
> > -               attached = rcu_dereference(net->flow_dissector_prog);
> > +               attached = rcu_dereference(init_net.flow_dissector_prog);
> > +
> > +               if (!attached)
> > +                       attached = rcu_dereference(net->flow_dissector_prog);
> >
> >                 if (attached) {
> >                         struct bpf_flow_keys flow_keys;
> > --
> > 2.23.0.581.g78d2f28ef7-goog
> >
