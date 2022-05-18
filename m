Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A15E52AF6A
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 02:52:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232924AbiERAwz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 20:52:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232912AbiERAwx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 20:52:53 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 688C053B58
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 17:52:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652835170;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=S9mad11/WKyJ8qtJwe6UAYP1am6w3wILeYCMPsK0T8Q=;
        b=deAfIEe9EpSvy4my4eWMN0DHQRnCy/fNJI/Uo+1XCVdnn77QlIIt7lqxCay+sMuGQ3lHPv
        bW8Bz6AYO+8b3eCTyP7XTXYO4CF+qv2pxoAKbxptb8iehMqXwrWXQRx+iMjAkdMAhBMJuj
        1vNiz0Hv3AtkUxFViw4MAaA2mxIm1BA=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-141-D7DyDR2bNQ6CH6pRGFxvzQ-1; Tue, 17 May 2022 20:52:47 -0400
X-MC-Unique: D7DyDR2bNQ6CH6pRGFxvzQ-1
Received: by mail-qt1-f199.google.com with SMTP id d15-20020ac85d8f000000b002f3b3b7e0adso572888qtx.20
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 17:52:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=S9mad11/WKyJ8qtJwe6UAYP1am6w3wILeYCMPsK0T8Q=;
        b=ZqqfOaWPd+nOm3zu79DhmaGL2zwlMJJXZGQsJsyhI0/ISxi3K4WmAgQ2XX1agSfVkJ
         m+6FKUhvw8K3B9486bNn6xjMT6vq7qaCc2mEQlJXGiEmXx1kR+PtNYNLPaEEzmOtMtk3
         Lr20DNV3kf7ISb2voOkGPfJzdUDKEkiHqKAewEtLYFFLPEFnYbDDsgdEEzSJxtwYNZN+
         ZPFYmFu+Uk/jrLsmQ1lb6xykKhSK55Lx+aU6h9dOq5I3lvYNQHHM16h10MqHsJtn6cFp
         DoV+lkYnDUxyTj7P9/hrpbEGpqLlrx3/rTU6Apk43MGeP4jwt6g6m3vnkFzmWOMHfrqI
         zOFg==
X-Gm-Message-State: AOAM531eFofgEjoq91v91uhI1Z58D9i0INpYOqFWChUl/3U/XmjN1O4H
        P3lPWVaUiNPnNVsYvjAo10J+OFxE22Vh3g8nU0QM374piK56antsOAV+tYtdwCr2GcGADaDRjiq
        D9PabHl+6lzWfsk6a4gRP5lPwkA+LChTG
X-Received: by 2002:a05:620a:40c2:b0:6a0:2b1b:2b86 with SMTP id g2-20020a05620a40c200b006a02b1b2b86mr18374818qko.80.1652835166680;
        Tue, 17 May 2022 17:52:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwj5CgY3t/X6jWl5mD6OgnYRUwIXUSh+pKul9iwwO4sgu7eTlEHEdWngGAKINHo2zh9bC3tDB7N/laKZy7XqGo=
X-Received: by 2002:a05:620a:40c2:b0:6a0:2b1b:2b86 with SMTP id
 g2-20020a05620a40c200b006a02b1b2b86mr18374813qko.80.1652835166496; Tue, 17
 May 2022 17:52:46 -0700 (PDT)
MIME-Version: 1.0
References: <20220517163450.240299-1-miquel.raynal@bootlin.com> <20220517163450.240299-12-miquel.raynal@bootlin.com>
In-Reply-To: <20220517163450.240299-12-miquel.raynal@bootlin.com>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Tue, 17 May 2022 20:52:35 -0400
Message-ID: <CAK-6q+hPWRUobMATaxD6rZ1zfQUnS_6pMacr+rKVHRAWe1xzSQ@mail.gmail.com>
Subject: Re: [PATCH wpan-next v3 11/11] net: mac802154: Add a warning in the
 slow path
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Tue, May 17, 2022 at 12:35 PM Miquel Raynal
<miquel.raynal@bootlin.com> wrote:
>
> In order to be able to detect possible conflicts between the net
> interface core and the ieee802154 core, let's add a warning in the slow
> path: we want to be sure that whenever we start an asynchronous MLME
> transmission (which can be fully asynchronous) the net core somehow
> agrees that this transmission is possible, ie. the device was not
> stopped. Warning in this case would allow us to track down more easily
> possible issues with the MLME logic if we ever get reports.
>
> Unlike in the hot path, such a situation cannot be handled.
>
> Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> ---
>  net/mac802154/tx.c | 25 +++++++++++++++++++++++++
>  1 file changed, 25 insertions(+)
>
> diff --git a/net/mac802154/tx.c b/net/mac802154/tx.c
> index e36aca788ea2..53a8be822e33 100644
> --- a/net/mac802154/tx.c
> +++ b/net/mac802154/tx.c
> @@ -132,6 +132,25 @@ int ieee802154_sync_and_hold_queue(struct ieee802154_local *local)
>         return ret;
>  }
>
> +static bool ieee802154_netif_is_down(struct ieee802154_local *local)
> +{
> +       struct ieee802154_sub_if_data *sdata;
> +       bool is_down = true;
> +
> +       rcu_read_lock();
> +       list_for_each_entry_rcu(sdata, &local->interfaces, list) {
> +               if (!sdata->dev)
> +                       continue;
> +
> +               is_down = !(sdata->dev->flags & IFF_UP);
> +               if (is_down)
> +                       break;

I thought that the helper would be "netif_running()". It seems there
are multiple ways to check if an interface is up.

> +       }
> +       rcu_read_unlock();
> +
> +       return is_down;
> +}
> +
>  static int ieee802154_mlme_op_pre(struct ieee802154_local *local)
>  {
>         return ieee802154_sync_and_hold_queue(local);
> @@ -150,6 +169,12 @@ static int ieee802154_mlme_tx(struct ieee802154_local *local, struct sk_buff *sk
>         if (!local->open_count)
>                 return -EBUSY;
>
> +       /* Warn if the ieee802154 core thinks MLME frames can be sent while the
> +        * net interface expects this cannot happen.
> +        */
> +       if (WARN_ON_ONCE(ieee802154_netif_is_down(local)))
> +               return -EHOSTDOWN;

maybe also ENETDOWN? Also there is a missing rtnl_unlock().

- Alex

