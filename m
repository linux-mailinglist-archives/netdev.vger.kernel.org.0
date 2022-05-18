Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4DE052AF83
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 02:58:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232993AbiERA6p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 20:58:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232990AbiERA6n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 20:58:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4A02653E3E
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 17:58:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652835521;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wJkD+7oiHBwfQ5b1c2K9F5TgSK//yqvR5ZJ7NvoECkI=;
        b=F5BkiOipS2nHEgoiCr1gjjtWHs6wbALCaBXuQw15EhkA5WggnB9XBUbDdcObwskJPHGJXq
        7M4Ag3Tw6+9kjwnZmledncDIHc9wuwfPcGuWZrYfuPmTzzGZj1xeEUHFQCOpKde2sZVdFE
        vl6LHomaS6jO5F1i1uWNFl0IRnLiO+Q=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-548-e5SEsVB4NLWAj5X82sAm5Q-1; Tue, 17 May 2022 20:58:30 -0400
X-MC-Unique: e5SEsVB4NLWAj5X82sAm5Q-1
Received: by mail-qt1-f198.google.com with SMTP id q13-20020a05622a04cd00b002f3c0e197afso657962qtx.0
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 17:58:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wJkD+7oiHBwfQ5b1c2K9F5TgSK//yqvR5ZJ7NvoECkI=;
        b=7Z3VnB8ux6mpNNmbq2z/sZpwM6PrOFK4EKzHHBlOJ921ky90T3mhMagk8TjHbhR8KS
         H7oMguc4KoPOzcYV+0Lod8ZH3Vm2rm3LgnWJFgNhnvNw3Wz81BFloX4plN/cg3JgXRH2
         EtZAopRtMQdAgXiIxSq6EFdWfCMo2GUfioWpOHUQeMhntKeBrvv8RIIMXpvTi/mG3g5A
         vxDFbdFWREiXNpuS6hxRODds4Ny8w+lJ43QQJiwvbiJlhrDvUZvBLF75mcZOTCfCvydv
         KaWKDfxC0D0Z7mXQPlF89FeHyReTInpOcAPo8HRGhzvnpzSesxhL+JP8GTgYURcNST3G
         3VxA==
X-Gm-Message-State: AOAM5302uj8Caf0KnMqEP9ZeryF/CR8u2aAMGbfvDaNvhJsNXGgZsfLF
        LdF8K7W7yQjmvSzw1AK4tQvYCOcdgViv+CPBQW8NCdY8UD1YSfin/HasLl0aInr8wD7easkJLRx
        C3+Fo8qtRyvOPhoYUm3wyf9NWw7jKihxC
X-Received: by 2002:a05:6214:c29:b0:45a:fedd:7315 with SMTP id a9-20020a0562140c2900b0045afedd7315mr22355456qvd.59.1652835510131;
        Tue, 17 May 2022 17:58:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxg2xsobmhJ0gWNTQvpUgTVzDFpajtyaVVrEIKB3QgnXbi3qDoqkxEKIgNnDwQs+aBbl3JSmsaueD+fg+PJM0s=
X-Received: by 2002:a05:6214:c29:b0:45a:fedd:7315 with SMTP id
 a9-20020a0562140c2900b0045afedd7315mr22355440qvd.59.1652835509965; Tue, 17
 May 2022 17:58:29 -0700 (PDT)
MIME-Version: 1.0
References: <20220517163450.240299-1-miquel.raynal@bootlin.com> <20220517163450.240299-11-miquel.raynal@bootlin.com>
In-Reply-To: <20220517163450.240299-11-miquel.raynal@bootlin.com>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Tue, 17 May 2022 20:58:19 -0400
Message-ID: <CAK-6q+g=9_aqTOmMYxCn6p=Z=uPNyifjVXe4hzC82ZF1QPpLMg@mail.gmail.com>
Subject: Re: [PATCH wpan-next v3 10/11] net: mac802154: Add a warning in the
 hot path
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
> index 8881b6126b58..f4e7b3fe7cf0 100644
> --- a/include/net/cfg802154.h
> +++ b/include/net/cfg802154.h
> @@ -218,6 +218,7 @@ struct wpan_phy {
>         spinlock_t queue_lock;
>         atomic_t ongoing_txs;
>         atomic_t hold_txs;
> +       unsigned long queue_stopped;

Can we name it something like state_flags (as phy state flags)? Pretty
sure there will be more coming, or internal_flags, no idea...
something_flags...

>         wait_queue_head_t sync_txq;
>
>         char priv[] __aligned(NETDEV_ALIGN);
> diff --git a/net/mac802154/tx.c b/net/mac802154/tx.c
> index 6cc4e5c7ba94..e36aca788ea2 100644
> --- a/net/mac802154/tx.c
> +++ b/net/mac802154/tx.c
> @@ -123,9 +123,13 @@ static int ieee802154_sync_queue(struct ieee802154_local *local)
>
>  int ieee802154_sync_and_hold_queue(struct ieee802154_local *local)
>  {
> +       int ret;
> +
>         ieee802154_hold_queue(local);
> +       ret = ieee802154_sync_queue(local);
> +       set_bit(0, &local->phy->queue_stopped);
>

Define the 0 as WPAN_PHY_STATE_QUEUE_STOPPED_BIT or something like
that, above wpan_phy.

- Alex

