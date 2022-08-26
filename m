Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 136F45A2F89
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 21:03:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344267AbiHZTCN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 15:02:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344599AbiHZTCL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 15:02:11 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AC0D5302F
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 12:02:08 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id n17so2835323wrm.4
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 12:02:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fungible.com; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=2UfkFBhjICw50bVxur3buKyhXzyNIYy7LxMe2iqoGBs=;
        b=GXOVZIjb9PJtKaHGsXOOrYnmxVhvReR4JHIDrgFijOsOEFBr1SfyCa+n2wrpQvZiIH
         wJ0IMxu5OjTuWgyFNzbCl6bCnM2RykOwAhug4CqKGPQzIAwMjZxZ5jYSHZXJW6JZJgvc
         KLWsbmDLaKD06DC4cz2LGlgSM9aVW1LuS6nS0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=2UfkFBhjICw50bVxur3buKyhXzyNIYy7LxMe2iqoGBs=;
        b=vwsvexkgjHtOdYbNhPFJo1/z+qnXEEaeX12uQnB5ncFVy4ERoqL4lkcPPiSVB0h4E+
         /RWccBWMHH3pQemH0O9k8X1fnVPumaIZ1NqTXthw6qvdS+1E+11LDclm9iWTkNpgf83/
         WQ67S1w3gNgwOHOkG57M6/jJiF6RjuXN3XZanaLVJRWnlFEtqD+2i4OTLyTc9OkHQSCm
         jbIP1uY/bWjPspDWebtu0S4bFj64hCfIelXnVIv9cb35I7L2h0+w9zhfAHzq6ki1ISfD
         HVqCNlid20oGjlMAgl9RvMxXWya+Yl7zAdQlXGio7H+Kuzqc/PxaLkqRQP3yM9WeyIgO
         V+LA==
X-Gm-Message-State: ACgBeo3SPTwxDQ8tvZQMDR2PRI1rhskPIaqhsl5F7ldXAkRIiI1+TVe+
        B7NHGzlgCGEgFcY2fB1vzotLBMAlUI9+JMwDnr0ZcA==
X-Google-Smtp-Source: AA6agR75EGWNFtrGlCbHwXq4IjggLyUwY1epUH3Enj81qseUiqTV+RJql/G+dra9roShjgNll8XZQCdIFEVjxe9y37o=
X-Received: by 2002:a5d:6d8f:0:b0:225:6285:47fb with SMTP id
 l15-20020a5d6d8f000000b00225628547fbmr568736wrs.211.1661540527557; Fri, 26
 Aug 2022 12:02:07 -0700 (PDT)
MIME-Version: 1.0
References: <20220826110411.1409446-1-jiri@resnulli.us>
In-Reply-To: <20220826110411.1409446-1-jiri@resnulli.us>
From:   Dimitris Michailidis <d.michailidis@fungible.com>
Date:   Fri, 26 Aug 2022 12:01:56 -0700
Message-ID: <CAOkoqZnX2bGtvb6Keajo7Edy5G6Joc=CSxNfNrgbeYmXT=BA+A@mail.gmail.com>
Subject: Re: [patch net-next] funeth: remove pointless check of devlink
 pointer in create/destroy_netdev() flows
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Networking <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, pabeni@redhat.com,
        edumazet@google.com, Dimitrios Michailidis <dmichail@fungible.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 26, 2022 at 4:04 AM Jiri Pirko <jiri@resnulli.us> wrote:
>
> From: Jiri Pirko <jiri@nvidia.com>
>
> Once devlink port is successfully registered, the devlink pointer is not
> NULL. Therefore, the check is going to be always true and therefore
> pointless. Remove it.
>
> Signed-off-by: Jiri Pirko <jiri@nvidia.com>

Thanks for the patch.

Acked-by: Dimitris Michailidis <dmichail@fungible.com>

> ---
>  drivers/net/ethernet/fungible/funeth/funeth_main.c | 12 ++++--------
>  1 file changed, 4 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/net/ethernet/fungible/funeth/funeth_main.c b/drivers/net/ethernet/fungible/funeth/funeth_main.c
> index f247b7ad3a88..b6de2ad82a32 100644
> --- a/drivers/net/ethernet/fungible/funeth/funeth_main.c
> +++ b/drivers/net/ethernet/fungible/funeth/funeth_main.c
> @@ -1802,16 +1802,14 @@ static int fun_create_netdev(struct fun_ethdev *ed, unsigned int portid)
>         if (rc)
>                 goto unreg_devlink;
>
> -       if (fp->dl_port.devlink)
> -               devlink_port_type_eth_set(&fp->dl_port, netdev);
> +       devlink_port_type_eth_set(&fp->dl_port, netdev);
>
>         return 0;
>
>  unreg_devlink:
>         ed->netdevs[portid] = NULL;
>         fun_ktls_cleanup(fp);
> -       if (fp->dl_port.devlink)
> -               devlink_port_unregister(&fp->dl_port);
> +       devlink_port_unregister(&fp->dl_port);
>  free_stats:
>         fun_free_stats_area(fp);
>  free_rss:
> @@ -1830,10 +1828,8 @@ static void fun_destroy_netdev(struct net_device *netdev)
>         struct funeth_priv *fp;
>
>         fp = netdev_priv(netdev);
> -       if (fp->dl_port.devlink) {
> -               devlink_port_type_clear(&fp->dl_port);
> -               devlink_port_unregister(&fp->dl_port);
> -       }
> +       devlink_port_type_clear(&fp->dl_port);
> +       devlink_port_unregister(&fp->dl_port);
>         unregister_netdev(netdev);
>         fun_ktls_cleanup(fp);
>         fun_free_stats_area(fp);
> --
> 2.37.1
>
