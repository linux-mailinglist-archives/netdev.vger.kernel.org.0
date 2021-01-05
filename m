Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 915A22EB459
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 21:39:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728536AbhAEUjq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 15:39:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727958AbhAEUjp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 15:39:45 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 887D7C061796
        for <netdev@vger.kernel.org>; Tue,  5 Jan 2021 12:39:05 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id s15so359482plr.9
        for <netdev@vger.kernel.org>; Tue, 05 Jan 2021 12:39:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=22Faw56S5HKEvb2svCBhaed1b5xh9ETVt1Q8JJvErqM=;
        b=Caqwy8xrU2Ca9dx4BssGlkewLI82xQV33Yu38Q4x/uDzM9HpBV8x2JVCQ7oanEUQoL
         qmA9w1AW4tf1gv418s+ykK0dFHt/eAdHrMObIj1GTSm22wL95GmUMvO7SDr7JcJ+ASeB
         bSIvuiOhAqpP15aMsSKCT1rUN4/OrJF9eMNLl7fw3lyUIeLJKW0yBpO8tUGyJ5jB3/5a
         hcl8tmx9kKTNR/DncmgpiMvyLaIaQh6fcphr0ugJCG33F+luxQe11mxax3hCzK+RDEhd
         8txuEd3tQtEn70ldRRvEBdPKqhynyPH7te8vjudCKE6jUFUYP2Hl1uEsDDg+ePfFpumD
         ObCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=22Faw56S5HKEvb2svCBhaed1b5xh9ETVt1Q8JJvErqM=;
        b=iiNJXjv3Nf2fU+7/nYIs24GNwy62E938nlvmYNeAjeSGA8oh7DYwOlMw5ZQpquRvVM
         BPEqJ+waZkAr5b9hWhHocOwdb0+rxfjSkqmfkZl+KfeCk4pSL6t1HGeXrUlqSnPegOub
         S63DccCozCWbSXXT8o5JfD1O0av+fccO8JckXx0TEg10FuZ+kj3tbYolPQUjPlCwZ5R9
         xg+wEUvl3sNWDQ7hVYSl7IL5DG71k3i5RX41WYLncGVbQTayFbiriqtR/9aUPApfzxIb
         MM8S8ac65Q10nfW7W4rRCVqybpKprXmDDy5iURvBRhdr1hXRo8RhyOonoxvEQa4sNzgZ
         UBYQ==
X-Gm-Message-State: AOAM53096prUe+/AkdjDGv8n8cp+MtcR+ldfPjZZ4DuN0Xz2zxxyv+pt
        4Qr6jLc55XC3cys/aE8vtJ6EhAWDekJ2DEMRLDk=
X-Google-Smtp-Source: ABdhPJyLBVX3k/p01RuZauyaZL7C71aYDjFGIyYgZt20pV+iyV56jRzmHkpjn67mGe+Bqzqhe/iSqXneyJD73iqALLM=
X-Received: by 2002:a17:902:6f01:b029:dc:3182:ce69 with SMTP id
 w1-20020a1709026f01b02900dc3182ce69mr1288410plk.10.1609879144962; Tue, 05 Jan
 2021 12:39:04 -0800 (PST)
MIME-Version: 1.0
References: <20210105190725.1736246-1-kuba@kernel.org>
In-Reply-To: <20210105190725.1736246-1-kuba@kernel.org>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Tue, 5 Jan 2021 12:38:54 -0800
Message-ID: <CAM_iQpVMBjoSFH34cunM+e+E6Qu+eWVfoduo5LvyupRHq1OG1w@mail.gmail.com>
Subject: Re: [PATCH net v2] net: bareudp: add missing error handling for bareudp_link_config()
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        martin.varghese@nokia.com, Willem de Bruijn <willemb@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 5, 2021 at 11:07 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> .dellink does not get called after .newlink fails,
> bareudp_newlink() must undo what bareudp_configure()
> has done if bareudp_link_config() fails.
>
> v2: call bareudp_dellink(), like bareudp_dev_create() does

Thanks for the update. Just one question below.

>
> Fixes: 571912c69f0e ("net: UDP tunnel encapsulation module for tunnelling different protocols like MPLS, IP, NSH etc.")
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  drivers/net/bareudp.c | 22 ++++++++++++++--------
>  1 file changed, 14 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/net/bareudp.c b/drivers/net/bareudp.c
> index 708171c0d628..85de5f96c02b 100644
> --- a/drivers/net/bareudp.c
> +++ b/drivers/net/bareudp.c
> @@ -645,11 +645,20 @@ static int bareudp_link_config(struct net_device *dev,
>         return 0;
>  }
>
> +static void bareudp_dellink(struct net_device *dev, struct list_head *head)
> +{
> +       struct bareudp_dev *bareudp = netdev_priv(dev);
> +
> +       list_del(&bareudp->next);
> +       unregister_netdevice_queue(dev, head);
> +}
> +
>  static int bareudp_newlink(struct net *net, struct net_device *dev,
>                            struct nlattr *tb[], struct nlattr *data[],
>                            struct netlink_ext_ack *extack)
>  {
>         struct bareudp_conf conf;
> +       LIST_HEAD(list_kill);
>         int err;
>
>         err = bareudp2info(data, &conf, extack);
> @@ -662,17 +671,14 @@ static int bareudp_newlink(struct net *net, struct net_device *dev,
>
>         err = bareudp_link_config(dev, tb);
>         if (err)
> -               return err;
> +               goto err_unconfig;
>
>         return 0;
> -}
> -
> -static void bareudp_dellink(struct net_device *dev, struct list_head *head)
> -{
> -       struct bareudp_dev *bareudp = netdev_priv(dev);
>
> -       list_del(&bareudp->next);
> -       unregister_netdevice_queue(dev, head);
> +err_unconfig:
> +       bareudp_dellink(dev, &list_kill);
> +       unregister_netdevice_many(&list_kill);

Why do we need unregister_netdevice_many() here? I think
bareudp_dellink(dev, NULL) is sufficient as we always have
one instance to unregister?

(For the same reason, bareudp_dev_create() does not need it
either.)

Thanks.
