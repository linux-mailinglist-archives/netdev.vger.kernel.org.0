Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EFFE2C0C2A
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 14:57:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388353AbgKWNt0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 08:49:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729975AbgKWNtX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 08:49:23 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF37CC0613CF
        for <netdev@vger.kernel.org>; Mon, 23 Nov 2020 05:49:23 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id 34so14300907pgp.10
        for <netdev@vger.kernel.org>; Mon, 23 Nov 2020 05:49:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8RmJXHpYL9X9Xu352SZMllwZPOcHHeoaushVidGNGmc=;
        b=TD5p03OfbWwjPJm/x3hgUa0PLpW3M9IZ6z4lgmoSDMTF1m7DCBGVm0HhZgo/IsbSZf
         jJRYpx5ADCnezCdRs32jZjPRcXOGY8YSSvvGLScLimHOTk+IAfn8cpknSo4edlKWIWlk
         bD7syxUibE2lJl/zIUbhrC6IxYWsnO9ap+9HiaS0Eu2CuqUqzQCaYkKJ/cJsRdaochhT
         7vHtHD3coQb/yHBEDj+5bu/GeMLNFSVDUbg+0vOZGiYnJWbhyAZg/3gLowFmkONHG+rq
         1lSei6G9VKg52BxaJPh3TEyv8+8q/lEQkbPwxaT41fi70QFLbV38QM4OrzU88alig012
         MLIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8RmJXHpYL9X9Xu352SZMllwZPOcHHeoaushVidGNGmc=;
        b=UKA2o/l59kDadVp5J7NUK5NGTF7GSLL/mJCFUPud71c+uB2lminpdP8Rz044i8F5U1
         GEDrv2/kj32mHckdEpfzWwZPB+Jva8V7YlitCCoHd/Zj3CVC1//vn7MN/OPBJThJzJam
         QG0itlbTG4LYPvMEEbaFmZElZkinB45Q2xXuoQx/T/GJakgmKKY6SVuP6NshRXAoL2C4
         pmK4hd3o8svRL/tIf7cgiYXukt3o8maY1vVZGO2jKT4InTDRik268OMyMONSeUneH2Fj
         k0JgJKrl77yUF8BFF4ra8cTdtWcYZmDZ7AGDU/Kk7dtlk66xmKxIhvFHEJ4n24DpKiLl
         Z/Pg==
X-Gm-Message-State: AOAM532NbkjGI6y1riF7KfyLLdB7BYlgSSYHxq/XLpbElGDd8f4cqoL+
        QfN6I/fhEQ5So9jtQEPnMgK+nMM6OwvDP493Yete3yFvXJrmpvPz8wM=
X-Google-Smtp-Source: ABdhPJzF/QNzA181AonYflqfKpTQpICyWurcATXJ8me7DwJWE5sfTUG4G0n3exWPOslQt9d/8+gTtz3B5quAAlKpjF0=
X-Received: by 2002:a17:90a:ea05:: with SMTP id w5mr11324380pjy.204.1606139363088;
 Mon, 23 Nov 2020 05:49:23 -0800 (PST)
MIME-Version: 1.0
References: <20201123120531.724963-1-zyjzyj2000@gmail.com> <CAD=hENfysbUCNapfFZ6i0tOFo5Ge3QS+iQSt2ySBDb10zFdgwg@mail.gmail.com>
 <CAJ8uoz1TO7ULPDTK0ajyrjVFqB2REw=ncgT1c-NDhTciDeNfNg@mail.gmail.com> <CAD=hENeHFSJOO=Kt060y0R29d4wn87ESdrqY6n6ACA--LkZEFA@mail.gmail.com>
In-Reply-To: <CAD=hENeHFSJOO=Kt060y0R29d4wn87ESdrqY6n6ACA--LkZEFA@mail.gmail.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Mon, 23 Nov 2020 14:49:11 +0100
Message-ID: <CAJ8uoz2rfeDKhJCRwNCSs2oT+M=Xv0z=pW+7k2m5yqq-K6ceDg@mail.gmail.com>
Subject: Re: [PATCHv2 1/1] xdp: remove the function xsk_map_inc
To:     Zhu Yanjun <zyjzyj2000@gmail.com>
Cc:     "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 23, 2020 at 2:37 PM Zhu Yanjun <zyjzyj2000@gmail.com> wrote:
>
> On Mon, Nov 23, 2020 at 8:19 PM Magnus Karlsson
> <magnus.karlsson@gmail.com> wrote:
> >
> > On Mon, Nov 23, 2020 at 1:11 PM Zhu Yanjun <zyjzyj2000@gmail.com> wrote:
> > >
> > > On Mon, Nov 23, 2020 at 8:05 PM <zyjzyj2000@gmail.com> wrote:
> > > >
> > > > From: Zhu Yanjun <zyjzyj2000@gmail.com>
> > > >
> > > > The function xsk_map_inc is a simple wrapper of bpf_map_inc and
> > > > always returns zero. As such, replacing this function with bpf_map_inc
> > > > and removing the test code.
> > > >
> > > > Signed-off-by: Zhu Yanjun <zyjzyj2000@gmail.com>
> > >
> > >
> > > > ---
> > > >  net/xdp/xsk.c    |  1 -
> > > >  net/xdp/xsk.h    |  1 -
> > > >  net/xdp/xskmap.c | 13 +------------
> > > >  3 files changed, 1 insertion(+), 14 deletions(-)
> > > >
> > > > diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> > > > index cfbec3989a76..c1b8a888591c 100644
> > > > --- a/net/xdp/xsk.c
> > > > +++ b/net/xdp/xsk.c
> > > > @@ -548,7 +548,6 @@ static struct xsk_map *xsk_get_map_list_entry(struct xdp_sock *xs,
> > > >         node = list_first_entry_or_null(&xs->map_list, struct xsk_map_node,
> > > >                                         node);
> > > >         if (node) {
> > > > -               WARN_ON(xsk_map_inc(node->map));
> >
> > This should be bpf_map_inc(&node->map->map); Think you forgot to
> > convert this one.
>
> In include/linux/bpf.h:
> "
> ...
> 1213 void bpf_map_inc(struct bpf_map *map);
> ...
> "

Sorry if I was not clear enough. What I meant is that you cannot just
remove WARN_ON(xsk_map_inc(node->map)). You need to replace it with
bpf_map_inc(&node->map->map), otherwise you will not make a map_inc
and the refcount will be wrong. Please send a v3 using git send-email
so it is nice and clean.

> Zhu Yanjun
> >
> > > >                 map = node->map;
> > > >                 *map_entry = node->map_entry;
> > > >         }
> > > > diff --git a/net/xdp/xsk.h b/net/xdp/xsk.h
> > > > index b9e896cee5bb..0aad25c0e223 100644
> > > > --- a/net/xdp/xsk.h
> > > > +++ b/net/xdp/xsk.h
> > > > @@ -41,7 +41,6 @@ static inline struct xdp_sock *xdp_sk(struct sock *sk)
> > > >
> > > >  void xsk_map_try_sock_delete(struct xsk_map *map, struct xdp_sock *xs,
> > > >                              struct xdp_sock **map_entry);
> > > > -int xsk_map_inc(struct xsk_map *map);
> > > >  void xsk_map_put(struct xsk_map *map);
> > > >  void xsk_clear_pool_at_qid(struct net_device *dev, u16 queue_id);
> > > >  int xsk_reg_pool_at_qid(struct net_device *dev, struct xsk_buff_pool *pool,
> > > > diff --git a/net/xdp/xskmap.c b/net/xdp/xskmap.c
> > > > index 49da2b8ace8b..6b7e9a72b101 100644
> > > > --- a/net/xdp/xskmap.c
> > > > +++ b/net/xdp/xskmap.c
> > > > @@ -11,12 +11,6 @@
> > > >
> > > >  #include "xsk.h"
> > > >
> > > > -int xsk_map_inc(struct xsk_map *map)
> > > > -{
> > > > -       bpf_map_inc(&map->map);
> > > > -       return 0;
> > > > -}
> > >
> > > Hi, Magnus
> > >
> > > The function xsk_map_inc is replaced with bpf_map_inc.
> > >
> > > Zhu Yanjun
> > >
> > > > -
> > > >  void xsk_map_put(struct xsk_map *map)
> > > >  {
> > > >         bpf_map_put(&map->map);
> > > > @@ -26,17 +20,12 @@ static struct xsk_map_node *xsk_map_node_alloc(struct xsk_map *map,
> > > >                                                struct xdp_sock **map_entry)
> > > >  {
> > > >         struct xsk_map_node *node;
> > > > -       int err;
> > > >
> > > >         node = kzalloc(sizeof(*node), GFP_ATOMIC | __GFP_NOWARN);
> > > >         if (!node)
> > > >                 return ERR_PTR(-ENOMEM);
> > > >
> > > > -       err = xsk_map_inc(map);
> > > > -       if (err) {
> > > > -               kfree(node);
> > > > -               return ERR_PTR(err);
> > > > -       }
> > > > +       bpf_map_inc(&map->map);
> > > >
> > > >         node->map = map;
> > > >         node->map_entry = map_entry;
> > > > --
> > > > 2.25.1
> > > >
