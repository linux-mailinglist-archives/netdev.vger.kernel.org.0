Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D6A1527AB3
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 00:30:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235877AbiEOWaf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 May 2022 18:30:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235596AbiEOWac (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 May 2022 18:30:32 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CA41EDF14
        for <netdev@vger.kernel.org>; Sun, 15 May 2022 15:30:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652653827;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dNOJjfT5TRUPaCz6oz9ahXU+hrVa4PXoiSsuweG0pE0=;
        b=ah7gyAn1FWii3tC5FLhjDRGcRpjHQoUGQoEgI4ikJvo44c9YCQ5mk7Nx6ygwEAnr8DeZ7U
        GNKgyrNUux6bWsiHRaCVoDNINXRL1CbIL7yuWub6RDixbF0HVQUq6owpvWc5atznN7tkm0
        potQToFUpvCaiOI6cocK9aLTqtgnZrA=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-454-skztCsafNM2w02LC6bN5CA-1; Sun, 15 May 2022 18:30:26 -0400
X-MC-Unique: skztCsafNM2w02LC6bN5CA-1
Received: by mail-qt1-f199.google.com with SMTP id br6-20020a05622a1e0600b002f3d470aa4dso10328351qtb.21
        for <netdev@vger.kernel.org>; Sun, 15 May 2022 15:30:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dNOJjfT5TRUPaCz6oz9ahXU+hrVa4PXoiSsuweG0pE0=;
        b=E4u+gGdrsL0/3EsmMub2ILoq+WjFNBumxQrFE48i/eiH3HI3U8BHFn0BT/mlXoZ0F6
         rYRQNKIQU7oU4u4W1HsEqRQi0ENhuvgzM+jvvqQHDvnDGg82XG7Yk61dElYvoghHwLth
         n7czhJ0lQN+FTf8jPhpShAerWWHYBGtzG+SlBu6bFaVrb5qOk8Z5mv3zA+SU7S9t7K0k
         gFdt8aqkNbsMM3BbGbTVXe6LRlUddvFFLfMR/86Fr7ng2tKNFxhOHGyI5eh2aWLGWh3/
         nZS8aXKfsAesJtd0crQBnhz2Q0bxmXHRZOf4yIaxTQTUNPoPZ/1HNjbZP8dWFpa4+O18
         oC8w==
X-Gm-Message-State: AOAM530GTU03RWAbTZjcCm+i5JRu9RzD+fVQjgi0vARCfMibNgCw88xl
        kwUwCRYHfM+kNGxZdoz9/CwGYrAvZvUndq48ouvfh3DVV+CKa9WRd9BRXfnUYTZeEEPJdRAh6rr
        v9HonogpIGo0uE97XfP3s6ZECDARC+csA
X-Received: by 2002:a05:6214:f64:b0:45b:955:84a5 with SMTP id iy4-20020a0562140f6400b0045b095584a5mr13077737qvb.2.1652653826459;
        Sun, 15 May 2022 15:30:26 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwurA33+UVORZOkm63/xFqkRTjb6WYNLouBoePnslHeEpYr8sSC8jRCKvQufsm2AW1iz+0NDXTQ8L8LOK5VxnQ=
X-Received: by 2002:a05:6214:f64:b0:45b:955:84a5 with SMTP id
 iy4-20020a0562140f6400b0045b095584a5mr13077729qvb.2.1652653826273; Sun, 15
 May 2022 15:30:26 -0700 (PDT)
MIME-Version: 1.0
References: <20220512143314.235604-1-miquel.raynal@bootlin.com> <20220512143314.235604-11-miquel.raynal@bootlin.com>
In-Reply-To: <20220512143314.235604-11-miquel.raynal@bootlin.com>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Sun, 15 May 2022 18:30:15 -0400
Message-ID: <CAK-6q+jYb7A2RzG3u7PJYKZU9D5A=vben-Wnu-3EsUU-rqGT2Q@mail.gmail.com>
Subject: Re: [PATCH wpan-next v2 10/11] net: mac802154: Add a warning in the
 hot path
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Network Development <netdev@vger.kernel.org>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Thu, May 12, 2022 at 10:34 AM Miquel Raynal
<miquel.raynal@bootlin.com> wrote:
>
> We should never start a transmission after the queue has been stopped.
>
> But because it might work we don't kill the function here but rather
> warn loudly the user that something is wrong.
>
> Set an atomic when the queue will remain stopped. Reset this atomic when
> the queue actually gets restarded. Just check this atomic to know if the
> transmission is legitimate, warn if it is not.
>
> Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> ---
>  include/net/cfg802154.h |  1 +
>  net/mac802154/tx.c      | 16 +++++++++++++++-
>  net/mac802154/util.c    |  1 +
>  3 files changed, 17 insertions(+), 1 deletion(-)
>
> diff --git a/include/net/cfg802154.h b/include/net/cfg802154.h
> index 8b6326aa2d42..a1370e87233e 100644
> --- a/include/net/cfg802154.h
> +++ b/include/net/cfg802154.h
> @@ -218,6 +218,7 @@ struct wpan_phy {
>         struct mutex queue_lock;
>         atomic_t ongoing_txs;
>         atomic_t hold_txs;
> +       atomic_t queue_stopped;

Maybe some test_bit()/set_bit() is better there?

- Alex

