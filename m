Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61E315120A8
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 20:39:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244600AbiD0SEy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 14:04:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244559AbiD0SEw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 14:04:52 -0400
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48BDE389949;
        Wed, 27 Apr 2022 11:01:39 -0700 (PDT)
Received: by mail-lj1-x234.google.com with SMTP id 17so3723848lji.1;
        Wed, 27 Apr 2022 11:01:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wBbkKr1l4fRZGddkWdNjRpCVS3NAykDQMwUSejsRuZE=;
        b=Wep757RhG8CnfBfotYSDRtSPM89WYLH2NCJRYfllAoHIz6kE3BB8fVbp0c+y3yc6Bv
         B5wf4Cicopz8UZpCjcvWdkpq7LyFm76NXTkLk6RYTA4ZuPzfSVWN7gefEOR4X/9cUQ8z
         F18gUjmpgjaaOXqF0M18sLqX2OmQB7ym9Zzs6V8wGeEeZOlpQVrtko4m2FAHhgeLLkqR
         twu6iigAKjoiQ2NerblV0hpdrrjpsSBut6ZHj2zB7Pute+Xw5B5U+kellTx9rqvIEei8
         xR5u/pN45NZcfYVnF54YDOdYeOPyNSAxHP6GviATJCskqHiEgSBjy5Rt2kmEzTS0iL57
         i1lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wBbkKr1l4fRZGddkWdNjRpCVS3NAykDQMwUSejsRuZE=;
        b=RjTP0DkSUVbOo4gQGVHjoUKo+4aGPSQERx7Pl6ytf8NjpjTVdXCIesEnr02sYCnds+
         QeoWVI8oiWGRE/9Vut+x1O1jcEfGQw3eupXecPg4vuSwJ6SxzdpDc2iEFm7Hw7uNKAHH
         vlcwHuNRK3UMk3SY6W7osj7jb6Cnbg8n5FWpF8TJ2VJkNjQcQ5U9w+8o5JEz9OMjx0Ic
         Z9978aS5P1zBzjtfXn4n0oAI57zp+r6Wro2Xki6jGstBBo1vKCsXLHyJ8ZfeRpGOnuJl
         j6aCuNnB1aoDeXY8hGeaFoyCrakFyCS1mgP0xIQMW7lXOhn2av6s+SkeW9914Zyo4EH7
         h5Ng==
X-Gm-Message-State: AOAM533deoL2A98DJ4BUXfWl+4LbQx4lA6+531HnPN4Na674oZMJEhvt
        60KbTvwKXfNPQI3D88uJia2k2J7LoD6l/cZqh9I=
X-Google-Smtp-Source: ABdhPJzXMtE1FLHK9Ck1kIGva2bRPD9aXCBn67HizHyS2mR6j+kh1lvKRN/3DmNpmvPcc72kzvxkN5B3LepnavT5iO4=
X-Received: by 2002:a2e:b888:0:b0:24e:f423:93de with SMTP id
 r8-20020a2eb888000000b0024ef42393demr17656957ljp.193.1651082497333; Wed, 27
 Apr 2022 11:01:37 -0700 (PDT)
MIME-Version: 1.0
References: <20220427164659.106447-1-miquel.raynal@bootlin.com> <20220427164659.106447-9-miquel.raynal@bootlin.com>
In-Reply-To: <20220427164659.106447-9-miquel.raynal@bootlin.com>
From:   Alexander Aring <alex.aring@gmail.com>
Date:   Wed, 27 Apr 2022 14:01:25 -0400
Message-ID: <CAB_54W7NWEYgmLfowvyXtKEsKhBaVrPzpkB1kasYpAst98mKNA@mail.gmail.com>
Subject: Re: [PATCH wpan-next 08/11] net: mac802154: Add a warning in the hot path
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Wed, Apr 27, 2022 at 12:47 PM Miquel Raynal
<miquel.raynal@bootlin.com> wrote:
>
> We should never start a transmission after the queue has been stopped.
>
> But because it might work we don't kill the function here but rather
> warn loudly the user that something is wrong.
>
> Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> ---
>  net/mac802154/ieee802154_i.h |  8 ++++++++
>  net/mac802154/tx.c           |  2 ++
>  net/mac802154/util.c         | 18 ++++++++++++++++++
>  3 files changed, 28 insertions(+)
>
> diff --git a/net/mac802154/ieee802154_i.h b/net/mac802154/ieee802154_i.h
> index b55fdefb0b34..cb61a4abaf37 100644
> --- a/net/mac802154/ieee802154_i.h
> +++ b/net/mac802154/ieee802154_i.h
> @@ -178,6 +178,14 @@ bool ieee802154_queue_is_held(struct ieee802154_local *local);
>   */
>  void ieee802154_stop_queue(struct ieee802154_local *local);
>
> +/**
> + * ieee802154_queue_is_stopped - check whether ieee802154 queue was stopped
> + * @local: main mac object
> + *
> + * Goes through all the interfaces and indicates if they are all stopped or not.
> + */
> +bool ieee802154_queue_is_stopped(struct ieee802154_local *local);
> +
>  /* MIB callbacks */
>  void mac802154_dev_set_page_channel(struct net_device *dev, u8 page, u8 chan);
>
> diff --git a/net/mac802154/tx.c b/net/mac802154/tx.c
> index a8a83f0167bf..021dddfea542 100644
> --- a/net/mac802154/tx.c
> +++ b/net/mac802154/tx.c
> @@ -124,6 +124,8 @@ bool ieee802154_queue_is_held(struct ieee802154_local *local)
>  static netdev_tx_t
>  ieee802154_hot_tx(struct ieee802154_local *local, struct sk_buff *skb)
>  {
> +       WARN_ON_ONCE(ieee802154_queue_is_stopped(local));
> +
>         return ieee802154_tx(local, skb);
>  }
>
> diff --git a/net/mac802154/util.c b/net/mac802154/util.c
> index 847e0864b575..cfd17a7db532 100644
> --- a/net/mac802154/util.c
> +++ b/net/mac802154/util.c
> @@ -44,6 +44,24 @@ void ieee802154_stop_queue(struct ieee802154_local *local)
>         rcu_read_unlock();
>  }
>
> +bool ieee802154_queue_is_stopped(struct ieee802154_local *local)
> +{
> +       struct ieee802154_sub_if_data *sdata;
> +       bool stopped = true;
> +
> +       rcu_read_lock();
> +       list_for_each_entry_rcu(sdata, &local->interfaces, list) {
> +               if (!sdata->dev)
> +                       continue;
> +
> +               if (!netif_queue_stopped(sdata->dev))
> +                       stopped = false;
> +       }
> +       rcu_read_unlock();
> +
> +       return stopped;
> +}

sorry this makes no sense, you using net core functionality to check
if a queue is stopped in a net core netif callback. Whereas the sense
here for checking if the queue is really stopped is when 802.15.4
thinks the queue is stopped vs net core netif callback running. It
means for MLME-ops there are points we want to make sure that net core
is not handling any xmit and we should check this point and not
introducing net core functionality checks. btw: if it's hit your if
branch the first time you can break?

I am not done with the review, this is just what I see now and we can
discuss that. Please be patient.

- Alex
