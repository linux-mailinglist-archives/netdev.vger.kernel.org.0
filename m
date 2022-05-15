Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 766C0527AB0
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 00:29:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235563AbiEOW3E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 May 2022 18:29:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229824AbiEOW3D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 May 2022 18:29:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 401A5DF0C
        for <netdev@vger.kernel.org>; Sun, 15 May 2022 15:29:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652653741;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rPiXGxvB043ZSjvpXVuJ8kp1cvd5Znu1YEXZQlc2cCg=;
        b=JuqcKKzTJQkLlKmZqzajkvdTMcZ28yLpNqPYvKrBkP6Dw0nV5Z4tIsO5+MQNOEI67ZvyU/
        RPMaT6W7uMcIht9bags69HS9YmrojZkwdlzMFbiOhGYrSNDgmfLLutA5j34UoRn3zHHV+4
        72Q72w7d60w0ejAU5Y1GLrMcEKQAboY=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-79-4hYBFCHWOQq5ooW2qSjEDg-1; Sun, 15 May 2022 18:29:00 -0400
X-MC-Unique: 4hYBFCHWOQq5ooW2qSjEDg-1
Received: by mail-qv1-f69.google.com with SMTP id ke27-20020a056214301b00b0045a82079370so10841076qvb.20
        for <netdev@vger.kernel.org>; Sun, 15 May 2022 15:28:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rPiXGxvB043ZSjvpXVuJ8kp1cvd5Znu1YEXZQlc2cCg=;
        b=1mIjoJlRoZGNz9x0aQSXon+GhdJlY7hfG98SVnKvhJFfBeUwrCRiG9tmfN52drPQ5T
         PBK1uLNya6uAwuYuMZOWPCsmIWwV40+ohz9FkBpcz/W1NiqqB8o4ludKx2J0oFrmye69
         3yGsyqpJyjcDwTe4aucWlr8vwovjZVjd2+pgb0bezBA6PmeorpeqLzvhwzIy+ndJKAlR
         oXF6VZx+gf5nu7NPHIuGFMqprQXPNuGi5MXObYa5bmW4T8UdKY4BgNVRct7h18qhdmtj
         MEHNXrjHzgOj9wqAJTBVvJ/D5U5aNeop0MSLiKqEFQOTTb+3SK4pcpI69ZhOqdPWSxEO
         mvgw==
X-Gm-Message-State: AOAM531FOZwkYMtf9L1lP4r3cusAUYZhE2HVEOW++kEXMbjF4hIyJsfh
        FB9bFBTCxai9pO8jQ3uh6CuK/XSLPw1F2KHvGgtbZFzA4Fks0DHEX1q6GRH2SgKIwA4HxBjzBAl
        oX3Q4gWXdvZoVvwpkO1FDmZeFKdSgWz3N
X-Received: by 2002:a05:622a:351:b0:2f3:d8e4:529f with SMTP id r17-20020a05622a035100b002f3d8e4529fmr13386688qtw.123.1652653739455;
        Sun, 15 May 2022 15:28:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwzN1V1g6z450TKZD/3TQsykdXoozq5Y8cuGJSffdR7VbZUfKZvdKyuAuBdrLols3zzQRtslo34iuHJPIuEBos=
X-Received: by 2002:a05:622a:351:b0:2f3:d8e4:529f with SMTP id
 r17-20020a05622a035100b002f3d8e4529fmr13386676qtw.123.1652653739263; Sun, 15
 May 2022 15:28:59 -0700 (PDT)
MIME-Version: 1.0
References: <20220512143314.235604-1-miquel.raynal@bootlin.com> <20220512143314.235604-10-miquel.raynal@bootlin.com>
In-Reply-To: <20220512143314.235604-10-miquel.raynal@bootlin.com>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Sun, 15 May 2022 18:28:48 -0400
Message-ID: <CAK-6q+ipHdD=NJB2N7SHQ0TUvNpc0GQXZ7dWM9nDxqyqNgxdSA@mail.gmail.com>
Subject: Re: [PATCH wpan-next v2 09/11] net: mac802154: Introduce a
 synchronous API for MLME commands
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
> This is the slow path, we need to wait for each command to be processed
> before continuing so let's introduce an helper which does the
> transmission and blocks until it gets notified of its asynchronous
> completion. This helper is going to be used when introducing scan
> support.
>
> Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> ---
>  net/mac802154/ieee802154_i.h |  1 +
>  net/mac802154/tx.c           | 25 +++++++++++++++++++++++++
>  2 files changed, 26 insertions(+)
>
> diff --git a/net/mac802154/ieee802154_i.h b/net/mac802154/ieee802154_i.h
> index a057827fc48a..f8b374810a11 100644
> --- a/net/mac802154/ieee802154_i.h
> +++ b/net/mac802154/ieee802154_i.h
> @@ -125,6 +125,7 @@ extern struct ieee802154_mlme_ops mac802154_mlme_wpan;
>  void ieee802154_rx(struct ieee802154_local *local, struct sk_buff *skb);
>  void ieee802154_xmit_sync_worker(struct work_struct *work);
>  int ieee802154_sync_and_hold_queue(struct ieee802154_local *local);
> +int ieee802154_mlme_tx(struct ieee802154_local *local, struct sk_buff *skb);
>  netdev_tx_t
>  ieee802154_monitor_start_xmit(struct sk_buff *skb, struct net_device *dev);
>  netdev_tx_t
> diff --git a/net/mac802154/tx.c b/net/mac802154/tx.c
> index 38f74b8b6740..ec8d872143ee 100644
> --- a/net/mac802154/tx.c
> +++ b/net/mac802154/tx.c
> @@ -128,6 +128,31 @@ int ieee802154_sync_and_hold_queue(struct ieee802154_local *local)
>         return ieee802154_sync_queue(local);
>  }
>
> +int ieee802154_mlme_tx(struct ieee802154_local *local, struct sk_buff *skb)
> +{
> +       int ret;
> +
> +       /* Avoid possible calls to ->ndo_stop() when we asynchronously perform
> +        * MLME transmissions.
> +        */
> +       rtnl_lock();

I think we should make an ASSERT_RTNL() here, the lock needs to be
earlier than that over the whole MLME op. MLME can trigger more than
one message, the whole sync_hold/release queue should be earlier than
that... in my opinion is it not right to allow other messages so far
an MLME op is going on? I am not sure what the standard says to this,
but I think it should be stopped the whole time? All those sequence
diagrams show only some specific frames, also remember that on the
receive side we drop all other frames if MLME op (e.g. scan) is going
on?

- Alex

