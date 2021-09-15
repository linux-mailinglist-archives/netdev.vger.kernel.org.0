Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C35B140CA1C
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 18:31:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229528AbhIOQcj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 12:32:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229465AbhIOQci (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Sep 2021 12:32:38 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78FEDC061574
        for <netdev@vger.kernel.org>; Wed, 15 Sep 2021 09:31:19 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id b7so3104134pfo.11
        for <netdev@vger.kernel.org>; Wed, 15 Sep 2021 09:31:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Nvpz8TciJSk0SkItiyYZulqYelLJE+AQMqpqnO2zU4c=;
        b=Fgff/0PjYF6iSUSDmiablqcABRL2gOTrzWgsrcMGzJjNl4PJIhKKzH3RnmjyTqa5Ku
         DCx6no6fSf6/us5aboCo5VjCBNTHLP3n1kAEGxhlzj+X7W7rKwtqitT6J43Hn/c2L4WK
         jn6gKcvodh6+CXIeZCbMGSzuY9ch616hyWfJZLpWYsx8g7jrLsKUHWAvtavf4vFWu/OX
         oh3AW9ngUeO9UMqqZ0drdkyuwUnP9LBD/FBgiT9hykLVhkl3kWIdl6PnEMA2z0AfhMkC
         s/9K6xuf5eOJ7FEPktz9bkrCfSgLxY4KV2BCEahrvJOAB/DKotrUw/3UCXK+hQF2Wkup
         9ATg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Nvpz8TciJSk0SkItiyYZulqYelLJE+AQMqpqnO2zU4c=;
        b=Xq7dkUOCN++jx+WjtMHTSMqyhMCn8Bdi36f229qy2vlT5wFEOx7tnDywxgs12PhaLG
         NE38IuSExb9aAtez/6kbpJUaTO8NFTg/J7stBy2rffRRZBXmlW0EoNQlMXb9vAj2KgE6
         st3txJq8+8eBo1a8RxE2XIW2KyR2GPi+fLsYKmY7sMWKVX9EHW/mku1uqNYL+J1WhxL2
         U/ZnIsE2iBaopwMOWkXB2Z9QdvBajrhUUeY9KVqYitPBCmuHQoyFpgvBsZKCZBFGpTMb
         toxJT24aeWFXTCxHLEZUImAC4CaUtgLqo2F9wwtQnXLtvwpQqUqqG3laBCakIJZeUC/m
         VeQQ==
X-Gm-Message-State: AOAM533rfKkUxPxqnP7EzWkhJWagrA44tg5+J9CjKD4s0lsOkP7OsHRY
        mt0J01D3TJfBEDI88wQ6OLcpIW+vH49b+ykzlL0=
X-Google-Smtp-Source: ABdhPJwsj3tVllLe4gqdbO7g481FxMji9+m3rdGT8Job1WNpk0ImK210GYnLcCrivIe/COKFixaz/etLvQ6OuCmzzCE=
X-Received: by 2002:a63:6ec5:: with SMTP id j188mr594892pgc.218.1631723478981;
 Wed, 15 Sep 2021 09:31:18 -0700 (PDT)
MIME-Version: 1.0
References: <20210913225332.662291-1-kuba@kernel.org> <20210913225332.662291-2-kuba@kernel.org>
In-Reply-To: <20210913225332.662291-2-kuba@kernel.org>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Wed, 15 Sep 2021 09:31:08 -0700
Message-ID: <CAM_iQpVec_FY-71n3VUUgo8YCcn00+QzBBck9h1RGNaFzXX_ig@mail.gmail.com>
Subject: Re: [PATCH net-next 1/3] net: sched: update default qdisc visibility
 after Tx queue cnt changes
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Eric Dumazet <edumazet@google.com>,
        Matthew Massey <matthewmassey@fb.com>,
        Dave Taht <dave.taht@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 13, 2021 at 3:53 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> mq / mqprio make the default child qdiscs visible. They only do
> so for the qdiscs which are within real_num_tx_queues when the
> device is registered. Depending on order of calls in the driver,
> or if user space changes config via ethtool -L the number of
> qdiscs visible under tc qdisc show will differ from the number
> of queues. This is confusing to users and potentially to system
> configuration scripts which try to make sure qdiscs have the
> right parameters.
>
> Add a new Qdisc_ops callback and make relevant qdiscs TTRT.
>
> Note that this uncovers the "shortcut" created by
> commit 1f27cde313d7 ("net: sched: use pfifo_fast for non real queues")
> The default child qdiscs beyond initial real_num_tx are always
> pfifo_fast, no matter what the sysfs setting is. Fixing this
> gets a little tricky because we'd need to keep a reference
> on whatever the default qdisc was at the time of creation.
> In practice this is likely an non-issue the qdiscs likely have
> to be configured to non-default settings, so whatever user space
> is doing such configuration can replace the pfifos... now that
> it will see them.
>

Looks reasonable.

> diff --git a/net/core/dev.c b/net/core/dev.c
> index 74fd402d26dd..f930329f0dc2 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -2921,6 +2921,8 @@ int netif_set_real_num_tx_queues(struct net_device *dev, unsigned int txq)
>                 if (dev->num_tc)
>                         netif_setup_tc(dev, txq);
>
> +               dev_qdisc_change_real_num_tx(dev, txq);
> +

Don't we need to flip the device with dev_deactivate()+dev_activate()?
It looks like the only thing this function resets is qdisc itself, and only
partially.


>                 dev->real_num_tx_queues = txq;
>
>                 if (disabling) {
> diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
> index a8dd06c74e31..66d2fbe9ef50 100644
> --- a/net/sched/sch_generic.c
> +++ b/net/sched/sch_generic.c
> @@ -1330,6 +1330,15 @@ static int qdisc_change_tx_queue_len(struct net_device *dev,
>         return 0;
>  }
>
> +void dev_qdisc_change_real_num_tx(struct net_device *dev,
> +                                 unsigned int new_real_tx)
> +{
> +       struct Qdisc *qdisc = dev->qdisc;
> +
> +       if (qdisc->ops->change_real_num_tx)
> +               qdisc->ops->change_real_num_tx(qdisc, new_real_tx);
> +}
> +
>  int dev_qdisc_change_tx_queue_len(struct net_device *dev)
>  {
>         bool up = dev->flags & IFF_UP;
> diff --git a/net/sched/sch_mq.c b/net/sched/sch_mq.c
> index e79f1afe0cfd..db18d8a860f9 100644
> --- a/net/sched/sch_mq.c
> +++ b/net/sched/sch_mq.c
> @@ -125,6 +125,29 @@ static void mq_attach(struct Qdisc *sch)
>         priv->qdiscs = NULL;
>  }
>
> +static void mq_change_real_num_tx(struct Qdisc *sch, unsigned int new_real_tx)

This is nearly identical to mqprio_change_real_num_tx(), can we reuse
it?

Thanks.
