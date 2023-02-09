Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C984668FC58
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 02:01:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230464AbjBIBBy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 20:01:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230473AbjBIBBu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 20:01:50 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FBA1A5CA;
        Wed,  8 Feb 2023 17:01:49 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id k13so1254674plg.0;
        Wed, 08 Feb 2023 17:01:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=jTVtAZ5UoHVv+I7BJ71lJFx3ifqfkwUMomQpG/mR/iQ=;
        b=Htg2Qh8j3nvjorEPbWJqI3q3ADqSoWNkM1qWN8UBDa9dkzIattEuM8RIPWBw/j95jk
         0dHLGos2XfrO44s1knsXo5mr2SKjE7UEtTUUB7qh08/rKbQ1uU6DzqFPO2tVHXVlbO3B
         9Yj2yl6U8vyI5A6OyvzqFL0oM4Lk/dIAL2gaHZoLXquljkHoF0TgWKg4dzn/y0dIREja
         ejIs0dN9UBpdkESx0XO7JRXzWf+FL0liQlTMgmGFXxtJp8CDTKAFVSgamEgjyYNb3Rg3
         Uqiuewe0Gxfv9g8F7jLca4x9C/xsYZXXOqqfJKAGjsvjFodRXjcJuN9jBL3yJCHgEiQe
         YhVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jTVtAZ5UoHVv+I7BJ71lJFx3ifqfkwUMomQpG/mR/iQ=;
        b=TGpK2CC7ObMHdFp/WRK15a39q6klgk75qWJ2Wr6kUsgf0Ij8i09ZBmZ2DzA1PljaMD
         2r/ElaCLbAVD4zZHh1CspF6vhLzI02IMCNFH6MvDEPWD0QLvI8e8IIKdfqVoZJtzjHlG
         pfvggUsgJodIWMQAOKXwVkGQj7xgfEVt+63FgP9aSIBZJM0274UeaeBK6P8hn4+TVWI4
         ZCNNdbNTfJl9lLWa0i5KaJOCWvtlgn/m4qpe2nt7MhfkNCWV6lYglpjP9oXZRBkEnkGp
         BMgfwxbokSZVnNLU6jJsIcpJOEoKBGqmtvl8hMyof44ca9RrRKe6iz0ynWlYISSMhIXl
         emHg==
X-Gm-Message-State: AO0yUKVTOljRgxfE9RwTlwjYE6rJ0KQPfYQyzhTWUKVAXV+R7DPvfrYd
        ddlZlDqdnf5ME53a9P8V0s52Z0F9j9htXf0n7rg=
X-Google-Smtp-Source: AK7set/oWhTjP8/q+B0Jpp18qS1AJw3/mtqDZeQs7hrAPDXuByQ41v3WhuoyDKjxwUWocSL12/Qht5nP3qZ/9B8k9j4=
X-Received: by 2002:a17:90a:3f10:b0:22c:1179:3b8f with SMTP id
 l16-20020a17090a3f1000b0022c11793b8fmr1153244pjc.118.1675904508751; Wed, 08
 Feb 2023 17:01:48 -0800 (PST)
MIME-Version: 1.0
References: <20230208073445.2317192-1-yoshihiro.shimoda.uh@renesas.com>
 <20230208073445.2317192-4-yoshihiro.shimoda.uh@renesas.com>
 <4c2955c227087a2d50d3c7179e5edc2f392db1fc.camel@gmail.com> <TYBPR01MB5341C01EC932D1F53AEF188AD8D89@TYBPR01MB5341.jpnprd01.prod.outlook.com>
In-Reply-To: <TYBPR01MB5341C01EC932D1F53AEF188AD8D89@TYBPR01MB5341.jpnprd01.prod.outlook.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Wed, 8 Feb 2023 17:01:37 -0800
Message-ID: <CAKgT0Uc6DYv+08jXJS_yrs_XMkEbMXvMCvP03AdY8Q391kqt_w@mail.gmail.com>
Subject: Re: [PATCH net-next 3/4] net: renesas: rswitch: Remove gptp flag from rswitch_gwca_queue
To:     Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>
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

On Wed, Feb 8, 2023 at 3:33 PM Yoshihiro Shimoda
<yoshihiro.shimoda.uh@renesas.com> wrote:
>
> Hi Alexander,
>
> > From: Alexander H Duyck, Sent: Thursday, February 9, 2023 1:07 AM
> >
> > On Wed, 2023-02-08 at 16:34 +0900, Yoshihiro Shimoda wrote:
> > > The gptp flag is completely related to the !dir_tx in struct
> > > rswitch_gwca_queue. In the future, a new queue handling for
> > > timestamp will be implemented and this gptp flag is confusable.
> > > So, remove the gptp flag.
> > >
> > > Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
> >
> > Based on these changes I am assuming that gptp == !dir_tx? Am I
> > understanding it correctly? It would be useful if you called that out
> > in the patch description.
>
> You're correct.
> I'll modify the description to clear why gptp == !dir_tx like below on v2 patch.
> ---
> In the previous code, the gptp flag was completely related to the !dir_tx
> in struct rswitch_gwca_queue because rswitch_gwca_queue_alloc() was called
> below:
>
> < In rswitch_txdmac_alloc() >
> err = rswitch_gwca_queue_alloc(ndev, priv, rdev->tx_queue, true, false,
>                               TX_RING_SIZE);
> So, dir_tx = true, gptp = false
>
> < In rswitch_rxdmac_alloc() >
> err = rswitch_gwca_queue_alloc(ndev, priv, rdev->rx_queue, false, true,
>                               RX_RING_SIZE);
> So, dir_tx = false, gptp = true
>
> In the future, a new queue handling for timestamp will be implemented
> and this gptp flag is confusable. So, remove the gptp flag.
> ---

It is a bit more readable if the relation is explained so if you could
call that out in the description I would appreciate it.

> > > ---
> > >  drivers/net/ethernet/renesas/rswitch.c | 26 +++++++++++---------------
> > >  drivers/net/ethernet/renesas/rswitch.h |  1 -
> > >  2 files changed, 11 insertions(+), 16 deletions(-)
> > >
> > > diff --git a/drivers/net/ethernet/renesas/rswitch.c b/drivers/net/ethernet/renesas/rswitch.c
> > > index b256dadada1d..e408d10184e8 100644
> > > --- a/drivers/net/ethernet/renesas/rswitch.c
> > > +++ b/drivers/net/ethernet/renesas/rswitch.c
> > > @@ -280,11 +280,14 @@ static void rswitch_gwca_queue_free(struct net_device *ndev,
> > >  {
> > >     int i;
> > >
> > > -   if (gq->gptp) {
> > > +   if (!gq->dir_tx) {
> > >             dma_free_coherent(ndev->dev.parent,
> > >                               sizeof(struct rswitch_ext_ts_desc) *
> > >                               (gq->ring_size + 1), gq->rx_ring, gq->ring_dma);
> > >             gq->rx_ring = NULL;
> > > +
> > > +           for (i = 0; i < gq->ring_size; i++)
> > > +                   dev_kfree_skb(gq->skbs[i]);
> > >     } else {
> > >             dma_free_coherent(ndev->dev.parent,
> > >                               sizeof(struct rswitch_ext_desc) *
> > > @@ -292,11 +295,6 @@ static void rswitch_gwca_queue_free(struct net_device *ndev,
> > >             gq->tx_ring = NULL;
> > >     }
> > >
> > > -   if (!gq->dir_tx) {
> > > -           for (i = 0; i < gq->ring_size; i++)
> > > -                   dev_kfree_skb(gq->skbs[i]);
> > > -   }
> > > -
> > >     kfree(gq->skbs);
> > >     gq->skbs = NULL;
> > >  }
> >
> > One piece I don't understand is why freeing of the skbs stored in the
> > array here was removed. Is this cleaned up somewhere else before we
> > call this function?
>
> "gq->skbs = NULL;" seems unnecessary because this driver doesn't check
> whether gq->skbs is NULL or not. Also, gq->[rt]x_ring seem to be the same.
> So, I'll make such a patch which is removing unnecessary code after
> this patch series was accepted.

I was actually referring to the lines you removed above that.
Specifically I am wondering why the calls to
dev_kfree_skb(gq->skbs[i]); were removed? I am wondering if this might
be introducing a memory leak.
