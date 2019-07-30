Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F26B67AD5F
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 18:16:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728773AbfG3QQV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 12:16:21 -0400
Received: from mail-yw1-f65.google.com ([209.85.161.65]:42319 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727578AbfG3QQV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 12:16:21 -0400
Received: by mail-yw1-f65.google.com with SMTP id z63so23981308ywz.9
        for <netdev@vger.kernel.org>; Tue, 30 Jul 2019 09:16:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KZFdGbtfNDebHsOvAkh47VjVTqsjW+r0MS7p21EsAro=;
        b=Oc+IGbcyKIezQN+KkCn7emJ6GSQcNqomjb7NqgpUg+dB0/I24a4FJuhbarHi7dRCy8
         Z5U8lUQ0kMWWmPjjyI5AAow+v1kIl6ajWrxfn62p5UFj5HGazHFXtAez+wZ7ubeOHv5O
         h4oBkVepySHbbSF0HXlW0jUwQxddX5tr0t527VK0HGzHFOTnd/sChPo/7DM/mGCL6ezn
         62gxjj+y+o4+vp9SJE67Lemrz+BoWRcsv755vtXzafToMRQZa9UbEWr3KSdxXUR5xVVX
         +BBZVMloB2YE9rypZ5h6zmRHCv5jmQNNYMNia54EDXwzh59UJtB0v+vQNgjodV7i7zeN
         InLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KZFdGbtfNDebHsOvAkh47VjVTqsjW+r0MS7p21EsAro=;
        b=LPBi3VkmKPxmXthsdCbjAR3NvDV6J2LxYkgPyuGFyKEO4Oa++rCvdFVgh5m7AGn/Qw
         SzShZDC17cJLiArhOgQVbWUGHjgXteT2vrukRcDZMQCoW5Fpsydq0J/5ziDXZshVku1l
         dMSrHBY+KrFLSEg944GQl6BacJ1+Y/v4jfiI9q3JmuF75xVOalP9Ajd3vofEn95xcgfG
         s59HTkH4wkjxlMPyDz1hfi/nmyldH439QBsvmTPXcpT1du6iBk242kG2yWwwCWF0WW0d
         /lcf2yr9Ut/RHPOg6JujBWsT1CLGGWRlguuzEGKPTrvR0Wtrej9afB18yAG5t8oc8m98
         oh6g==
X-Gm-Message-State: APjAAAWjfilVHMtFu7nCnqrESITroCpwt9s6ZcbEmBd+YJpcpUeqxTvi
        sYydy4K8RfehbKztXkQXQWvK61sS
X-Google-Smtp-Source: APXvYqwQ6a3MnZGTZ+aYeOHunaAR5JSatAYhkpXeYwYF+t8xPLNcRMvKkhIBORsBXhF0ARXjGJ83pQ==
X-Received: by 2002:a81:af06:: with SMTP id n6mr68436334ywh.449.1564503379941;
        Tue, 30 Jul 2019 09:16:19 -0700 (PDT)
Received: from mail-yb1-f172.google.com (mail-yb1-f172.google.com. [209.85.219.172])
        by smtp.gmail.com with ESMTPSA id i137sm14910497ywa.3.2019.07.30.09.16.19
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Jul 2019 09:16:19 -0700 (PDT)
Received: by mail-yb1-f172.google.com with SMTP id x188so1217734yba.8
        for <netdev@vger.kernel.org>; Tue, 30 Jul 2019 09:16:19 -0700 (PDT)
X-Received: by 2002:a5b:b46:: with SMTP id b6mr53836624ybr.391.1564503378599;
 Tue, 30 Jul 2019 09:16:18 -0700 (PDT)
MIME-Version: 1.0
References: <20190729234934.23595-1-saeedm@mellanox.com> <20190729234934.23595-9-saeedm@mellanox.com>
In-Reply-To: <20190729234934.23595-9-saeedm@mellanox.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 30 Jul 2019 12:15:42 -0400
X-Gmail-Original-Message-ID: <CA+FuTSfnikCV_J2cUEeafCaui8KxrK4njRR9rqgpo+5JhBxR9g@mail.gmail.com>
Message-ID: <CA+FuTSfnikCV_J2cUEeafCaui8KxrK4njRR9rqgpo+5JhBxR9g@mail.gmail.com>
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

On Mon, Jul 29, 2019 at 7:50 PM Saeed Mahameed <saeedm@mellanox.com> wrote:
>
> From: Vlad Buslov <vladbu@mellanox.com>
>
> In order to remove dependency on rtnl lock, access to tc flows hashtable
> must be explicitly protected from concurrent flows removal.
>
> Extend tc flow structure with rcu to allow concurrent parallel access. Use
> rcu read lock to safely lookup flow in tc flows hash table, and take
> reference to it. Use rcu free for flow deletion to accommodate concurrent
> stats requests.
>
> Add new DELETED flow flag. Imlement new flow_flag_test_and_set() helper
> that is used to set a flag and return its previous value. Use it to
> atomically set the flag in mlx5e_delete_flower() to guarantee that flow can
> only be deleted once, even when same flow is deleted concurrently by
> multiple tasks.
>
> Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
> Reviewed-by: Jianbo Liu <jianbol@mellanox.com>
> Reviewed-by: Roi Dayan <roid@mellanox.com>
> Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
> ---

> @@ -3492,16 +3507,32 @@ int mlx5e_delete_flower(struct net_device *dev, struct mlx5e_priv *priv,
>  {
>         struct rhashtable *tc_ht = get_tc_ht(priv, flags);
>         struct mlx5e_tc_flow *flow;
> +       int err;
>
> +       rcu_read_lock();
>         flow = rhashtable_lookup_fast(tc_ht, &f->cookie, tc_ht_params);
> -       if (!flow || !same_flow_direction(flow, flags))
> -               return -EINVAL;
> +       if (!flow || !same_flow_direction(flow, flags)) {
> +               err = -EINVAL;
> +               goto errout;
> +       }
>
> +       /* Only delete the flow if it doesn't have MLX5E_TC_FLOW_DELETED flag
> +        * set.
> +        */
> +       if (flow_flag_test_and_set(flow, DELETED)) {
> +               err = -EINVAL;
> +               goto errout;
> +       }
>         rhashtable_remove_fast(tc_ht, &flow->node, tc_ht_params);
> +       rcu_read_unlock();
>
>         mlx5e_flow_put(priv, flow);

Dereferencing flow outside rcu readside critical section? Does a build
with lockdep not complain?

>
>         return 0;
> +
> +errout:
> +       rcu_read_unlock();
> +       return err;
>  }
>
>  int mlx5e_stats_flower(struct net_device *dev, struct mlx5e_priv *priv,
> @@ -3517,8 +3548,10 @@ int mlx5e_stats_flower(struct net_device *dev, struct mlx5e_priv *priv,
>         u64 bytes = 0;
>         int err = 0;
>
> -       flow = mlx5e_flow_get(rhashtable_lookup_fast(tc_ht, &f->cookie,
> -                                                    tc_ht_params));
> +       rcu_read_lock();
> +       flow = mlx5e_flow_get(rhashtable_lookup(tc_ht, &f->cookie,
> +                                               tc_ht_params));
> +       rcu_read_unlock();
>         if (IS_ERR(flow))
>                 return PTR_ERR(flow);

Same, in code below this check?
