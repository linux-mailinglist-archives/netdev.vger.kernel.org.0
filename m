Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C939B7AE2B
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 18:39:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727460AbfG3Qie (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 12:38:34 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:32984 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726631AbfG3Qid (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 12:38:33 -0400
Received: by mail-ed1-f65.google.com with SMTP id i11so63147413edq.0
        for <netdev@vger.kernel.org>; Tue, 30 Jul 2019 09:38:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IEFe0aSQ4roEfzWjGEzF6LZL/QUHjIreCKeZCjz5VTE=;
        b=IXoE5a20DoWjrdeQl5IslbOUiYCppt9jOWqSmJBTXVCfSgZEYx48gbJpqc93bhT+b6
         hJBNo/H+JLNbJy0bOUI4vrHVoapXyM2ek6L9+6KD/PFA32sjbirq3oD4G7wS1Jm2v0Gn
         s/q2Kf3SZWy5gDjV6ayID4KIwxmeAHEEF+/oD15KlV0Ajr6Z1goaYePBkP7935Kx7ozN
         FQGtkhmolwJMRRZPAAxILDqQ3zHvLh7+rKldOJtl5LtnRGQ+EKpAcuxWw65M/+ewI6bg
         o3MRcIjIHOmv990gsYeDdUuacPtgctT3zm106m4PeEbdjlZOcWyCpf4QFX/WykGYPhTK
         8vXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IEFe0aSQ4roEfzWjGEzF6LZL/QUHjIreCKeZCjz5VTE=;
        b=QO+2M5hTbiMx1vwOPWSNq0oZVf4vV6st0HXB9gfBW8QGM9kU3J+zWlsNg3gfFyId4L
         BMx+8rhMxbmWV2h4gdRo2KfkeTgYUTU6fnpOOluGmjX9NZ8Bvcfs/04kuGw1FM7A7qsy
         8m/zVtt9raNqr50VrQ9ewNotnUAQRBslQQJePvHNbXomolMo+9CX9iRpv6LvuleWqasI
         rNzo9ZpTNL7I/icZj+li8W9Riu5hPi6qhL3eU1Yiei/FNtuOQkruZorgPWttSqfyJtgz
         iGh1tWdOKBMeAJ9i0MxcRDEuayQ1WO6YH490PjqdBZEnEkMt1I0PXoJeHD+3Xj59GnDa
         quoA==
X-Gm-Message-State: APjAAAULKUdj5arOkq+34lGbWvK+2R3FXaYtqdpx5o/MD1USvk3oOl/Z
        YTVXSElD4J1mE+hB4Pz3akWbcYfmnYlrx1MiV1E=
X-Google-Smtp-Source: APXvYqzo4YeStjH95GAO1otH1zYS5Y7IFPORy4mGWctboZUnWyEpeMoED0FES6oftg1s8wT7nG5eAJlxxmnKcL1YEkY=
X-Received: by 2002:aa7:d30b:: with SMTP id p11mr104851838edq.23.1564504712018;
 Tue, 30 Jul 2019 09:38:32 -0700 (PDT)
MIME-Version: 1.0
References: <20190729234934.23595-1-saeedm@mellanox.com> <20190729234934.23595-9-saeedm@mellanox.com>
 <CA+FuTSfnikCV_J2cUEeafCaui8KxrK4njRR9rqgpo+5JhBxR9g@mail.gmail.com>
In-Reply-To: <CA+FuTSfnikCV_J2cUEeafCaui8KxrK4njRR9rqgpo+5JhBxR9g@mail.gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 30 Jul 2019 12:37:55 -0400
Message-ID: <CAF=yD-LgfHTJrfyaVfokKkZWwPpz4uxYDKA11+jgO5rAq1LamA@mail.gmail.com>
Subject: Re: [net-next 08/13] net/mlx5e: Protect tc flows hashtable with rcu
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Vlad Buslov <vladbu@mellanox.com>,
        Jianbo Liu <jianbol@mellanox.com>,
        Roi Dayan <roid@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 30, 2019 at 12:16 PM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> On Mon, Jul 29, 2019 at 7:50 PM Saeed Mahameed <saeedm@mellanox.com> wrote:
> >
> > From: Vlad Buslov <vladbu@mellanox.com>
> >
> > In order to remove dependency on rtnl lock, access to tc flows hashtable
> > must be explicitly protected from concurrent flows removal.
> >
> > Extend tc flow structure with rcu to allow concurrent parallel access. Use
> > rcu read lock to safely lookup flow in tc flows hash table, and take
> > reference to it. Use rcu free for flow deletion to accommodate concurrent
> > stats requests.
> >
> > Add new DELETED flow flag. Imlement new flow_flag_test_and_set() helper
> > that is used to set a flag and return its previous value. Use it to
> > atomically set the flag in mlx5e_delete_flower() to guarantee that flow can
> > only be deleted once, even when same flow is deleted concurrently by
> > multiple tasks.
> >
> > Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
> > Reviewed-by: Jianbo Liu <jianbol@mellanox.com>
> > Reviewed-by: Roi Dayan <roid@mellanox.com>
> > Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
> > ---
>
> > @@ -3492,16 +3507,32 @@ int mlx5e_delete_flower(struct net_device *dev, struct mlx5e_priv *priv,
> >  {
> >         struct rhashtable *tc_ht = get_tc_ht(priv, flags);
> >         struct mlx5e_tc_flow *flow;
> > +       int err;
> >
> > +       rcu_read_lock();
> >         flow = rhashtable_lookup_fast(tc_ht, &f->cookie, tc_ht_params);
> > -       if (!flow || !same_flow_direction(flow, flags))
> > -               return -EINVAL;
> > +       if (!flow || !same_flow_direction(flow, flags)) {
> > +               err = -EINVAL;
> > +               goto errout;
> > +       }
> >
> > +       /* Only delete the flow if it doesn't have MLX5E_TC_FLOW_DELETED flag
> > +        * set.
> > +        */
> > +       if (flow_flag_test_and_set(flow, DELETED)) {
> > +               err = -EINVAL;
> > +               goto errout;
> > +       }
> >         rhashtable_remove_fast(tc_ht, &flow->node, tc_ht_params);
> > +       rcu_read_unlock();
> >
> >         mlx5e_flow_put(priv, flow);
>
> Dereferencing flow outside rcu readside critical section? Does a build
> with lockdep not complain?

Eh no, it won't. The surprising part to me was to use a readside
critical section when performing a write action on an RCU ptr. The
DELETED flag ensures that multiple writers will not compete to call
rhashtable_remove_fast. rcu_read_lock is a common pattern to do
rhashtable lookup + delete.

>
> >
> >         return 0;
> > +
> > +errout:
> > +       rcu_read_unlock();
> > +       return err;
> >  }
> >
> >  int mlx5e_stats_flower(struct net_device *dev, struct mlx5e_priv *priv,
> > @@ -3517,8 +3548,10 @@ int mlx5e_stats_flower(struct net_device *dev, struct mlx5e_priv *priv,
> >         u64 bytes = 0;
> >         int err = 0;
> >
> > -       flow = mlx5e_flow_get(rhashtable_lookup_fast(tc_ht, &f->cookie,
> > -                                                    tc_ht_params));
> > +       rcu_read_lock();
> > +       flow = mlx5e_flow_get(rhashtable_lookup(tc_ht, &f->cookie,
> > +                                               tc_ht_params));
> > +       rcu_read_unlock();
> >         if (IS_ERR(flow))
> >                 return PTR_ERR(flow);
>
> Same, in code below this check?

Never mind, sorry. I missed that this took a reference on the ptr
returned from rhashtable_lookup.
