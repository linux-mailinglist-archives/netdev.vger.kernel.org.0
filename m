Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72B131D929D
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 10:54:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728631AbgESIyI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 04:54:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728595AbgESIyI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 04:54:08 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A94CBC05BD09
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 01:54:07 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id o14so12869155ljp.4
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 01:54:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1LtAw1HpkgoStGUiv5KqkpAKTjRo/vHAX75wJ6jW+ro=;
        b=WTiX5baHiDtDmo1do3xDhi6Pls2uH5z/qAtdLfDWoKk5dMpUzjkSnWDCgJSvwc3qrs
         eCTb1/m69dQtLdvUQYunob4H4tLW2JuQwJFlsuwMRS0QTY4O1MOU8fyz8X//4Kt8QuDn
         VAKnExp5lLChSmeqgMGgLeIiH05AyfMjQoJIk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1LtAw1HpkgoStGUiv5KqkpAKTjRo/vHAX75wJ6jW+ro=;
        b=rh/Qb//2qRrFfIXQZAnfqikjiVYMY5LxBxe9UW5eZ5KkJbYpS4AhAFBfONLJ6rNZYg
         VyOQaUn4sevm1oVJqxS1lVvlpubJRvj2sgvbDSBEjCWQvra5c3hrt/aOannwb5yQM5Kj
         U2ShuBEidH2d331FwhH6gFFU6JIEWwkg3zGij39kh8b1gI3esBuSjS6IItLEgLY8r63r
         P9UKGz5OafrU9wfmEGtdARIhnC0lXdlIajTHMtGONtQlMozoAT3ddLagwr9EAeJrzYOX
         blHuORruwXFiU9zdRrCY97NrmLiCItJNUN3hNkjuLUVX9N0/ehWJctsZVoBpFcRBspMi
         xNgA==
X-Gm-Message-State: AOAM533wWMwmRt/GystW6OWVeZkzEpNdPQWRpEy3CblQZja4/r7U3oyE
        ehbhxBAK2zKH1vrTg/K1ZQwXE6iMZW6tvmF6RhvD6Q==
X-Google-Smtp-Source: ABdhPJwZ8zGQj0WBswOa0UCzyx8W2h8yp/DSuPewhQBihLT4Go4pnhmmGuXkiHtPrXW1PW3n9dVVQmcbr94vXZ/rcIA=
X-Received: by 2002:a2e:8ed7:: with SMTP id e23mr3779224ljl.32.1589878446014;
 Tue, 19 May 2020 01:54:06 -0700 (PDT)
MIME-Version: 1.0
References: <20200513164140.7956-1-pablo@netfilter.org> <20200513164140.7956-8-pablo@netfilter.org>
In-Reply-To: <20200513164140.7956-8-pablo@netfilter.org>
From:   Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>
Date:   Tue, 19 May 2020 14:23:54 +0530
Message-ID: <CAHHeUGUZmM1Fvk2gbund1AhMEV=zeg_JbuPR9DQ1ovELH=iRKQ@mail.gmail.com>
Subject: Re: [PATCH 7/8 net] bnxt_tc: update indirect block support
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        paulb@mellanox.com, Oz Shlomo <ozsh@mellanox.com>,
        vladbu@mellanox.com, jiri@resnulli.us, kuba@kernel.org,
        saeedm@mellanox.com, Michael Chan <michael.chan@broadcom.com>,
        Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 13, 2020 at 10:12 PM Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>
> Register ndo callback via flow_indr_dev_register() and
> flow_indr_dev_unregister().
>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  drivers/net/ethernet/broadcom/bnxt/bnxt.h    |  1 -
>  drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c | 51 +++++---------------
>  2 files changed, 12 insertions(+), 40 deletions(-)
>
> diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
> index f6a3250ef1c5..e7d1c12673bd 100644
> --- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
> +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
> @@ -1857,7 +1857,6 @@ struct bnxt {
>         u8                      dsn[8];
>         struct bnxt_tc_info     *tc_info;
>         struct list_head        tc_indr_block_list;
> -       struct notifier_block   tc_netdev_nb;
>         struct dentry           *debugfs_pdev;
>         struct device           *hwmon_dev;
>  };
> diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
> index 782ea0771221..0eef4f5e4a46 100644
> --- a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
> +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
> @@ -1939,53 +1939,25 @@ static int bnxt_tc_setup_indr_block(struct net_device *netdev, struct bnxt *bp,
>         return 0;
>  }
>
> -static int bnxt_tc_setup_indr_cb(struct net_device *netdev, void *cb_priv,
> -                                enum tc_setup_type type, void *type_data)
> -{
> -       switch (type) {
> -       case TC_SETUP_BLOCK:
> -               return bnxt_tc_setup_indr_block(netdev, cb_priv, type_data);
> -       default:
> -               return -EOPNOTSUPP;
> -       }
> -}
> -
>  static bool bnxt_is_netdev_indr_offload(struct net_device *netdev)
>  {
>         return netif_is_vxlan(netdev);
>  }
>
> -static int bnxt_tc_indr_block_event(struct notifier_block *nb,
> -                                   unsigned long event, void *ptr)
> +static int bnxt_tc_setup_indr_cb(struct net_device *netdev, void *cb_priv,
> +                                enum tc_setup_type type, void *type_data)
>  {
> -       struct net_device *netdev;
> -       struct bnxt *bp;
> -       int rc;
> -
> -       netdev = netdev_notifier_info_to_dev(ptr);
>         if (!bnxt_is_netdev_indr_offload(netdev))
> -               return NOTIFY_OK;
> -
> -       bp = container_of(nb, struct bnxt, tc_netdev_nb);
> +               return -EOPNOTSUPP;
>
> -       switch (event) {
> -       case NETDEV_REGISTER:
> -               rc = __flow_indr_block_cb_register(netdev, bp,
> -                                                  bnxt_tc_setup_indr_cb,
> -                                                  bp);
> -               if (rc)
> -                       netdev_info(bp->dev,
> -                                   "Failed to register indirect blk: dev: %s\n",
> -                                   netdev->name);
> -               break;
> -       case NETDEV_UNREGISTER:
> -               __flow_indr_block_cb_unregister(netdev,
> -                                               bnxt_tc_setup_indr_cb,
> -                                               bp);
> +       switch (type) {
> +       case TC_SETUP_BLOCK:
> +               return bnxt_tc_setup_indr_block(netdev, cb_priv, type_data);
> +       default:
>                 break;
>         }
>
> -       return NOTIFY_DONE;
> +       return -EOPNOTSUPP;
>  }
>
>  static const struct rhashtable_params bnxt_tc_flow_ht_params = {
> @@ -2074,8 +2046,8 @@ int bnxt_init_tc(struct bnxt *bp)
>
>         /* init indirect block notifications */
>         INIT_LIST_HEAD(&bp->tc_indr_block_list);
> -       bp->tc_netdev_nb.notifier_call = bnxt_tc_indr_block_event;
> -       rc = register_netdevice_notifier(&bp->tc_netdev_nb);
> +
> +       rc = flow_indr_dev_register(bnxt_tc_setup_indr_cb, bp);
>         if (!rc)
>                 return 0;
>
> @@ -2101,7 +2073,8 @@ void bnxt_shutdown_tc(struct bnxt *bp)
>         if (!bnxt_tc_flower_enabled(bp))
>                 return;
>
> -       unregister_netdevice_notifier(&bp->tc_netdev_nb);
> +       flow_indr_dev_unregister(bnxt_tc_setup_indr_cb, bp,
> +                                bnxt_tc_setup_indr_block_cb);

Why does the driver need to provide the "cb" again during unregister,
since both "cb" and "cb_priv" are already provided during register() ?
This interface could be simplified/improved if
flow_indr_dev_register() returns an opaque handle to the object it
creates (struct flow_indr_dev *) ? The driver should just pass this
handle during unregistration. Also, why do we need the extra (3rd)
argument (flow_setup_cb_t / bnxt_tc_setup_indr_block_cb) during unreg
? It is handled internally by the driver as a part of FLOW_BLOCK_BIND
/ UNBIND ?

Thanks,
-Harsha

>         rhashtable_destroy(&tc_info->flow_table);
>         rhashtable_destroy(&tc_info->l2_table);
>         rhashtable_destroy(&tc_info->decap_l2_table);
> --
> 2.20.1
>
