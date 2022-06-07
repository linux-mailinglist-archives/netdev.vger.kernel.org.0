Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24C6154203D
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 02:24:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384504AbiFHATx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 20:19:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442074AbiFGW6d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 18:58:33 -0400
Received: from mail-qv1-xf35.google.com (mail-qv1-xf35.google.com [IPv6:2607:f8b0:4864:20::f35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 827073351D9
        for <netdev@vger.kernel.org>; Tue,  7 Jun 2022 13:03:50 -0700 (PDT)
Received: by mail-qv1-xf35.google.com with SMTP id h18so13067905qvj.11
        for <netdev@vger.kernel.org>; Tue, 07 Jun 2022 13:03:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Om3MvdQAS3nKu64/e5dGUxUwumOruzWxGu07pA/tJes=;
        b=hddgR5o4VDWGC7k8SiryzlGNlZDhe2Hq11IAbj8rNL7qQBcqntFs755Xu/ls4cVziu
         42Ev5YGGvfz2aaOSE+H0WDNRe+usRGnnPXPNWLCgu7s1dv9Bc+OiQe8gSJEho6T7QtRQ
         Wk58jk3n7PaeXeTfRCdalM7MaZMsDg7TKGyi8tMLSy73y3A2QOXsfbllue3SBjbKBOAN
         dDEDQh0EgPLgl0U9hO5+68fZ3q6Gme6t96/Fo5Wp0SgQEG08+NH9yqyY4F2sVM27hM35
         eXc8Zn9CzsD+Aotm2Ak6+3gUNOseE+OygIqB3cHl6NX9t7Z90Xa4m7Osn2prPrzUPW/f
         RZXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Om3MvdQAS3nKu64/e5dGUxUwumOruzWxGu07pA/tJes=;
        b=hkyjcjyOLAw5bwpDp6Jy8zFgUcHEa699vE4/6No/QOs0y6nDru7Hh9TC5Rj17Bd0ou
         HhefJ/oZvQ0XntJt6fd9oZ+/uqrr0QLKRsVqdW3XTkTbSb5g/QilSfP90Dd8bO9H8EJM
         3KS52tos9Iugt3ENr7AySPg8Fj9Vrwsmkg8Wo783bCLVLpkeIKWipD6qp57vtVY1MfO2
         b3/LQMKKxdGOyL7mTISS5pgavUdTgHlWARvyrCqyi0yJ54CbYHI7fgYg5Q9U5T3k+g8S
         PcBZJyEbnKL4zjdIF7UaegQ3c1QzJ1V6k/BUOla4XH881iRHtsr47cGXNKg5ocITPOmH
         3LkQ==
X-Gm-Message-State: AOAM531YXo6CidteTt3oIK2ujGjLOI+Mr3G491KKqfwdewvIVgT698gM
        xCr0K392kXJTHWBCny07g4nzrBBrCrAspGkkITrAsg==
X-Google-Smtp-Source: ABdhPJz7TcgiDc29zFfdxzsqSF2U/8DOho5BpM81w0d/Cthw1JRCD74Df+eoJDhj38GI0v5a5e3eHaQ/pqzXv71zB+A=
X-Received: by 2002:a05:6214:2688:b0:46a:471a:dc83 with SMTP id
 gm8-20020a056214268800b0046a471adc83mr15262081qvb.22.1654632226533; Tue, 07
 Jun 2022 13:03:46 -0700 (PDT)
MIME-Version: 1.0
References: <20220606230107.D70B55EC0B30@us226.sjc.aristanetworks.com>
 <ed6768c1-80b8-aee2-e545-b51661d49336@nvidia.com> <20220606201910.2da95056@hermes.local>
 <CA+HUmGidY4BwEJ0_ArRRUKY7BkERsKomYnOwjPEayNUaS8wv=w@mail.gmail.com> <20220607103218.532ff62c@hermes.local>
In-Reply-To: <20220607103218.532ff62c@hermes.local>
From:   Francesco Ruggeri <fruggeri@arista.com>
Date:   Tue, 7 Jun 2022 13:03:35 -0700
Message-ID: <CA+HUmGjmq4bMOEg50nQYHN_R49aEJSofxUhpLbY+LG7vK2fUdw@mail.gmail.com>
Subject: Re: neighbour netlink notifications delivered in wrong order
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     Andy Roulin <aroulin@nvidia.com>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 7, 2022 at 10:32 AM Stephen Hemminger
<stephen@networkplumber.org> wrote:
>
> On Tue, 7 Jun 2022 09:29:45 -0700
> Francesco Ruggeri <fruggeri@arista.com> wrote:
>
> > On Mon, Jun 6, 2022 at 8:19 PM Stephen Hemminger
> > <stephen@networkplumber.org> wrote:
> > >
> > > On Mon, 6 Jun 2022 19:07:04 -0700
> > > Andy Roulin <aroulin@nvidia.com> wrote:
> > >
> > > > diff --git a/net/core/neighbour.c b/net/core/neighbour.c
> > > > index 54625287ee5b..a91dfcbfc01c 100644
> > > > --- a/net/core/neighbour.c
> > > > +++ b/net/core/neighbour.c
> > > > @@ -2531,23 +2531,19 @@ static int neigh_fill_info(struct sk_buff *skb,
> > > > struct neighbour *neigh,
> > > >       if (nla_put(skb, NDA_DST, neigh->tbl->key_len, neigh->primary_key))
> > > >               goto nla_put_failure;
> > > >
> > > > -     read_lock_bh(&neigh->lock);
> > > >       ndm->ndm_state   = neigh->nud_state;
> > >
> > > Accessing neighbor state outside of lock is not safe.
> > >
> > > But you should be able to use RCU here??
> >
> > I think the patch removes the lock from neigh_fill_info but it then uses it
> > to protect all calls to neigh_fill_info, so the access should still be safe.
> > In case of __neigh_notify the lock also extends to protect rtnl_notify,
> > guaranteeing that the state cannot be changed while the notification
> > is in progress (I assume all state changes are protected by the same lock).
> > Andy, is that the idea?
>
> Neigh info is already protected by RCU, is per neighbour reader/writer lock
> still needed at all?

The goal of the patch seems to be to make changing a neighbour's state and
delivering the corresponding notification atomic, in order to prevent
reordering of notifications. It uses the existing lock to do so.
Can reordering be prevented if the lock is replaced with rcu?
