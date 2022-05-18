Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39FA452AF50
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 02:42:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232742AbiERAmG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 20:42:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231403AbiERAmF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 20:42:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7FDA42B262
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 17:42:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652834523;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wERJ4wgK47PAcOyrRzert8+bNoC3QWGPRosED/fCVhI=;
        b=Ed4mJF2rWpWAXqMfqv7LbF0IFs5wAI/MfiWk85uXoSvRrU6GorGAlomlhD6oI1betYQwsu
        POpBAu+//1JoeYDi17iLgenXJb1u/Y3DFYgXcHz2Dbi/l1RGHt/7yF2RTSftZbpRLEm4j8
        42yjofNrW7YNbBqvSnGIn+At3WS3kF0=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-154-udTdA81jMO-VrXqVmBfP5A-1; Tue, 17 May 2022 20:41:53 -0400
X-MC-Unique: udTdA81jMO-VrXqVmBfP5A-1
Received: by mail-qt1-f200.google.com with SMTP id d13-20020ac85acd000000b002f3be21793dso579729qtd.12
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 17:41:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wERJ4wgK47PAcOyrRzert8+bNoC3QWGPRosED/fCVhI=;
        b=4/u3mzIP8qWz5yKNfsE0MNqbCjSLgbapAPYtHB0dPOsvdj4oVCpMQsnVMGEgVoOMCi
         1hjSxkXsIp09UBORmhSd26CUl2lK4Nk+6IwmPrIiiRb3usT9FzjI+QXOlfZy9+nc9vzv
         mC6N7e3rWE5c83UwwwTjzAGswphxQ6XmEKrNgNisuJR9AqVaPk31ACHaR5lnf+1TSetC
         1fe/TktNuoUpDj8IHz9DslxGTJ7bFuvPccVCJuQoN7TomTl8+NMe3VeMfimGQFRlibez
         4zFP//rL7mQG9uzi/QeZecq0hhPuhSAXk6xTrF3rPV0lfsNxqKpjWUkfsc8bdCRWceqb
         TGPw==
X-Gm-Message-State: AOAM533z4kVgUxN02baUuoiuVlg9f1vEkjLxAot0CATQthuIuliB80sS
        kpPtZKVtJunju3kjmo6e5P18DCE7C57BqBYhpb41qeZRPqRT6sk+vMId3+mK3Y+71LPme+jKSny
        gl/RjxtAKqEGo4cigH4H4g1eS4enlv1Ol
X-Received: by 2002:a05:6214:23c9:b0:461:c9e7:9cd6 with SMTP id hr9-20020a05621423c900b00461c9e79cd6mr12932338qvb.116.1652834512519;
        Tue, 17 May 2022 17:41:52 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyadn0My3D3HBXaGPzhfxj2ad+FiESM98CzYwZnx8PPV1iTmsc17Wmp8wgMacF/ZISfTXzy4MvZ3P4PnTmAgi4=
X-Received: by 2002:a05:6214:23c9:b0:461:c9e7:9cd6 with SMTP id
 hr9-20020a05621423c900b00461c9e79cd6mr12932324qvb.116.1652834512298; Tue, 17
 May 2022 17:41:52 -0700 (PDT)
MIME-Version: 1.0
References: <20220517163450.240299-1-miquel.raynal@bootlin.com> <20220517163450.240299-10-miquel.raynal@bootlin.com>
In-Reply-To: <20220517163450.240299-10-miquel.raynal@bootlin.com>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Tue, 17 May 2022 20:41:41 -0400
Message-ID: <CAK-6q+jQL7cFJrL6XjuaJnNDggtO1d_sB+T+GrY9yT+Y+KC0oA@mail.gmail.com>
Subject: Re: [PATCH wpan-next v3 09/11] net: mac802154: Introduce a
 synchronous API for MLME commands
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
> This is the slow path, we need to wait for each command to be processed
> before continuing so let's introduce an helper which does the
> transmission and blocks until it gets notified of its asynchronous
> completion. This helper is going to be used when introducing scan
> support.
>
> Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> ---
>  net/mac802154/ieee802154_i.h |  1 +
>  net/mac802154/tx.c           | 46 ++++++++++++++++++++++++++++++++++++
>  2 files changed, 47 insertions(+)
>
> diff --git a/net/mac802154/ieee802154_i.h b/net/mac802154/ieee802154_i.h
> index a057827fc48a..b42c6ac789f5 100644
> --- a/net/mac802154/ieee802154_i.h
> +++ b/net/mac802154/ieee802154_i.h
> @@ -125,6 +125,7 @@ extern struct ieee802154_mlme_ops mac802154_mlme_wpan;
>  void ieee802154_rx(struct ieee802154_local *local, struct sk_buff *skb);
>  void ieee802154_xmit_sync_worker(struct work_struct *work);
>  int ieee802154_sync_and_hold_queue(struct ieee802154_local *local);
> +int ieee802154_mlme_tx_one(struct ieee802154_local *local, struct sk_buff *skb);
>  netdev_tx_t
>  ieee802154_monitor_start_xmit(struct sk_buff *skb, struct net_device *dev);
>  netdev_tx_t
> diff --git a/net/mac802154/tx.c b/net/mac802154/tx.c
> index 38f74b8b6740..6cc4e5c7ba94 100644
> --- a/net/mac802154/tx.c
> +++ b/net/mac802154/tx.c
> @@ -128,6 +128,52 @@ int ieee802154_sync_and_hold_queue(struct ieee802154_local *local)
>         return ieee802154_sync_queue(local);
>  }
>
> +static int ieee802154_mlme_op_pre(struct ieee802154_local *local)
> +{
> +       return ieee802154_sync_and_hold_queue(local);
> +}
> +
> +static int ieee802154_mlme_tx(struct ieee802154_local *local, struct sk_buff *skb)
> +{
> +       int ret;
> +
> +       /* Avoid possible calls to ->ndo_stop() when we asynchronously perform
> +        * MLME transmissions.
> +        */
> +       rtnl_lock();
> +
> +       /* Ensure the device was not stopped, otherwise error out */
> +       if (!local->open_count)
> +               return -EBUSY;
> +

No -EBUSY here, use ?-ENETDOWN?. You forgot rtnl_unlock() here.

- Alex

