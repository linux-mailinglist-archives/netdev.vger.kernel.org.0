Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5AEC2C3B26
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 09:34:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726515AbgKYIdZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 03:33:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725287AbgKYIdZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Nov 2020 03:33:25 -0500
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1701BC0613D4
        for <netdev@vger.kernel.org>; Wed, 25 Nov 2020 00:33:21 -0800 (PST)
Received: by mail-pf1-x442.google.com with SMTP id q10so1662639pfn.0
        for <netdev@vger.kernel.org>; Wed, 25 Nov 2020 00:33:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=L7u8tuTuSm8ghjOH6e9+EEtngo0gcd0IGL/XJf0nIO8=;
        b=oozjlueywfdZ+jbKMi9EuDKhHqsbsrxSP7KZ2ijkxSpYe0uOAkrhq3Pa3yDjscMC9m
         ThoYP+7oBEE6NyDN8gDv4/zGCa+aJw9oMNHqOv4jxprtApnlvh9YTkt5zTc55Njycs+B
         D7nMXXFycCcOc9nO5C480lEGHjjU1JCYA1qsy3/aSTxTLAKWr5vuGJfvMXmCMI7Wb7y2
         RTlohVHC5TBugXPi6E3hzz2P7N5w1YKou5N2hNk7WBiEPNcqm0kcIZTnCXtxvdF7SI58
         NF2dqd8SP898pyVmU0+xL41aAjdL4NbwfESQsLjaIqWaqTnb64lW0mcgbZ0vKsC2hIZt
         Ig6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=L7u8tuTuSm8ghjOH6e9+EEtngo0gcd0IGL/XJf0nIO8=;
        b=gmvxzkw6ZZDHa1t06HQqryX5+wvONZ20ppudrnRHiu2OA15S7LJ0W8576H9YzQ1bcc
         WAg5mtPz4K228T+17VKkUc7lid4IJUGY3nttJS88DIB4gtSpP1twsJY96oZ+ZGTxoa7R
         uhgdHlICMoD6zi9EsU/a9Qy4vbXGkKaC/Kni48c3wE0ntNGss2dS9zmmPBt5s7fneWIE
         dSMTiR38nqBu9bDtn1CmNSRT56bFyaBIKwSi2rjANHosp1AULsZ762R2u8tEnNb08l4K
         pnMBQohnNb8SchEnuDv+Z9SLcmD+gC5yUF19v/AVl4/YmylJm2cUBx9Vr950zEgXYyTl
         TTlw==
X-Gm-Message-State: AOAM533maFVqQjAIr+7tbBUf9fgxxijHcGa0Zdlt3kIehkk64PM9cqlM
        MoA51HW7I7lY2DqmbCb2HQ41UimSh5vsL5wiWms=
X-Google-Smtp-Source: ABdhPJyBo/Fu11h7nyPmF/y9s1I+up1sp5xg1rRMGbUL/l66bJ8WjcDUitCvtlCg0O5D6w+K850E+Tc6yxdcv1mccUE=
X-Received: by 2002:a17:90a:4687:: with SMTP id z7mr2806684pjf.168.1606293200711;
 Wed, 25 Nov 2020 00:33:20 -0800 (PST)
MIME-Version: 1.0
References: <1606143915-25335-1-git-send-email-yanjunz@nvidia.com> <c3472d5f-54da-2e20-2c3c-3f6690de6f04@iogearbox.net>
In-Reply-To: <c3472d5f-54da-2e20-2c3c-3f6690de6f04@iogearbox.net>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Wed, 25 Nov 2020 09:33:09 +0100
Message-ID: <CAJ8uoz3WssKhD_CRhJSHRQDAB7nrkjz1P8Uaozxy3UwLZWnNaw@mail.gmail.com>
Subject: Re: [PATCH v3 1/1] xdp: remove the function xsk_map_inc
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Zhu Yanjun <yanjunz@nvidia.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        Zhu Yanjun <zyjzyj2000@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 25, 2020 at 1:02 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 11/23/20 4:05 PM, Zhu Yanjun wrote:
> > From: Zhu Yanjun <zyjzyj2000@gmail.com>
> >
> > The function xsk_map_inc is a simple wrapper of bpf_map_inc and
> > always returns zero. As such, replacing this function with bpf_map_inc
> > and removing the test code.
> >
> > Signed-off-by: Zhu Yanjun <zyjzyj2000@gmail.com>
> > ---
> >   net/xdp/xsk.c    |  2 +-
> >   net/xdp/xsk.h    |  1 -
> >   net/xdp/xskmap.c | 13 +------------
> >   3 files changed, 2 insertions(+), 14 deletions(-)
> >
> > diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> > index cfbec3989a76..a3c1f07d77d8 100644
> > --- a/net/xdp/xsk.c
> > +++ b/net/xdp/xsk.c
> > @@ -548,7 +548,7 @@ static struct xsk_map *xsk_get_map_list_entry(struct xdp_sock *xs,
> >       node = list_first_entry_or_null(&xs->map_list, struct xsk_map_node,
> >                                       node);
> >       if (node) {
> > -             WARN_ON(xsk_map_inc(node->map));
> > +             bpf_map_inc(&node->map->map);
> >               map = node->map;
> >               *map_entry = node->map_entry;
> >       }
> > diff --git a/net/xdp/xsk.h b/net/xdp/xsk.h
> > index b9e896cee5bb..0aad25c0e223 100644
> > --- a/net/xdp/xsk.h
> > +++ b/net/xdp/xsk.h
> > @@ -41,7 +41,6 @@ static inline struct xdp_sock *xdp_sk(struct sock *sk)
> >
> >   void xsk_map_try_sock_delete(struct xsk_map *map, struct xdp_sock *xs,
> >                            struct xdp_sock **map_entry);
> > -int xsk_map_inc(struct xsk_map *map);
> >   void xsk_map_put(struct xsk_map *map);
> >   void xsk_clear_pool_at_qid(struct net_device *dev, u16 queue_id);
> >   int xsk_reg_pool_at_qid(struct net_device *dev, struct xsk_buff_pool *pool,
> > diff --git a/net/xdp/xskmap.c b/net/xdp/xskmap.c
> > index 49da2b8ace8b..6b7e9a72b101 100644
> > --- a/net/xdp/xskmap.c
> > +++ b/net/xdp/xskmap.c
> > @@ -11,12 +11,6 @@
> >
> >   #include "xsk.h"
> >
> > -int xsk_map_inc(struct xsk_map *map)
> > -{
> > -     bpf_map_inc(&map->map);
> > -     return 0;
> > -}
> > -
> >   void xsk_map_put(struct xsk_map *map)
> >   {
>
> So, the xsk_map_put() is defined as:
>
>    void xsk_map_put(struct xsk_map *map)
>    {
>          bpf_map_put(&map->map);
>    }
>
> What is the reason to get rid of xsk_map_inc() but not xsk_map_put() wrapper?
> Can't we just remove both while we're at it?

Yes, why not. Makes sense.

Yanjun, could you please send a new version that removes this too?

Thank you both!

> Thanks,
> Daniel
