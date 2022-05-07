Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21AD351E3B8
	for <lists+netdev@lfdr.de>; Sat,  7 May 2022 05:10:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244361AbiEGDMH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 23:12:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230141AbiEGDME (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 23:12:04 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7B5386FA33
        for <netdev@vger.kernel.org>; Fri,  6 May 2022 20:08:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651892895;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/+3bFC46isrTR6zfpg+LqSuag/89ZCJ8zvzZLnx6hwg=;
        b=XbIT24Qeax38frwx6MjwHjKz/YZQZgvEswY/SPk2X/ui2YWmoNiPVH40BrvEIUDGNwQ54M
        FnFrptlJDp03QlKzr/Kb8bWp8ThiXne81SM5sCfg3l3Z58OX3hAAHQcoMTQkpEDav+kLBz
        XTht9/TJPR+ttClpQPbct2+sEinD5i0=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-218-tC8B_vXjP3ql1QTn8nB61g-1; Fri, 06 May 2022 23:08:14 -0400
X-MC-Unique: tC8B_vXjP3ql1QTn8nB61g-1
Received: by mail-lf1-f69.google.com with SMTP id br16-20020a056512401000b004739cf51722so3994808lfb.6
        for <netdev@vger.kernel.org>; Fri, 06 May 2022 20:08:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/+3bFC46isrTR6zfpg+LqSuag/89ZCJ8zvzZLnx6hwg=;
        b=xTiQu1XWvP85aVIY6oD8bQ8lB9yz4TshwquNQqsvjUltzna2Ib3yLsqUiiQl6VdaNV
         MV+Qlr9E5508FsbpHlcCyJTMH11UcdfpU2aK6xBInO7pCK714+XKD6RdFo91gL9EcO1e
         fihc6AGdEhLseNWPSEvNIRxrKxfUnlVqZLv2N0d2qiy6D3o5gVl/G6F1TibXg8u8w0sz
         rVa30Ljd8mp47/5LBC7Uo55tVawixfao+789I9zuDmu4Plb9EF2aEluhLry0Op9fL5wL
         uc0tGwrOGKqfl8dTaLiSxm0wqmUj88jO7/ZrgkCFRIpgnKPxJh0Ao6gIcGBjXBu0r9Om
         lbBg==
X-Gm-Message-State: AOAM533S2lXNYC6fqRJ7TKyCKAuQx/KS7ddTT4j4EVwB+6N8htWsALMQ
        MZQ3INMuBgJn2sgJgAEtt/VjEeXzPKAr0Dk8hZHTYlH7COQ3AsxLfy5U3XYh7QbFZhT1IVvQgO5
        wM7WEjDjyA3+hwnZyv4GGzren3QV/IyXp
X-Received: by 2002:a19:ca50:0:b0:471:f556:92b with SMTP id h16-20020a19ca50000000b00471f556092bmr4550649lfj.587.1651892892825;
        Fri, 06 May 2022 20:08:12 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyQwCiiiucbpZkb6D8tG4eL5848+nS4cvx3pLhvoJLouxsCa8uQPKeY6G+rYj+4Rrbtodz/8fknlPZIMYtA++Q=
X-Received: by 2002:a19:ca50:0:b0:471:f556:92b with SMTP id
 h16-20020a19ca50000000b00471f556092bmr4550634lfj.587.1651892892569; Fri, 06
 May 2022 20:08:12 -0700 (PDT)
MIME-Version: 1.0
References: <20220506170751.822862-1-kuba@kernel.org> <20220506170751.822862-6-kuba@kernel.org>
In-Reply-To: <20220506170751.822862-6-kuba@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Date:   Sat, 7 May 2022 11:08:01 +0800
Message-ID: <CACGkMEv7frdwDZdib_J4i-V5sVrqwNb=-pu5uXvjr0dfv9H5Fw@mail.gmail.com>
Subject: Re: [PATCH net-next 5/6] net: virtio: switch to netif_napi_add_weight()
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem <davem@davemloft.net>, netdev <netdev@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, mst <mst@redhat.com>,
        virtualization <virtualization@lists.linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 7, 2022 at 1:08 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> virtio netdev driver uses a custom napi weight, switch to the new
> API for setting custom weight.
>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Acked-by: Jason Wang <jasowang@redhat.com>

> ---
> CC: mst@redhat.com
> CC: jasowang@redhat.com
> CC: virtualization@lists.linux-foundation.org
> ---
>  drivers/net/virtio_net.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index ebb98b796352..db05b5e930be 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -3313,8 +3313,8 @@ static int virtnet_alloc_queues(struct virtnet_info *vi)
>         INIT_DELAYED_WORK(&vi->refill, refill_work);
>         for (i = 0; i < vi->max_queue_pairs; i++) {
>                 vi->rq[i].pages = NULL;
> -               netif_napi_add(vi->dev, &vi->rq[i].napi, virtnet_poll,
> -                              napi_weight);
> +               netif_napi_add_weight(vi->dev, &vi->rq[i].napi, virtnet_poll,
> +                                     napi_weight);
>                 netif_napi_add_tx_weight(vi->dev, &vi->sq[i].napi,
>                                          virtnet_poll_tx,
>                                          napi_tx ? napi_weight : 0);
> --
> 2.34.1
>

