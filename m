Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B1BB4F6D9D
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 23:59:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236887AbiDFWBL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 18:01:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236848AbiDFWBJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 18:01:09 -0400
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51656144B4D;
        Wed,  6 Apr 2022 14:59:12 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id s13so5074215ljd.5;
        Wed, 06 Apr 2022 14:59:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=G7GoAGmrCgUPdtytsGs0a1leDFtXk/Sryc7dvR4B8po=;
        b=oa6N9hT4QSIgJM8JzzESLpAkYCrIQqGh5UWRXVFx/SkMxf9S8rh3+aqOnZFEY8s2nl
         L3aUwvEHJdXDcaIYA0FPviWlQoWMl9dkReZJYwLcmoI1qqWOtfJEcoLJFRox7pGLzTKB
         UFrXDpglZsMy+gtzdoOBlxOsE9uJ/Fwn/bHmRmxZePNDp0VHkSNfuIkAlwg7OYjWVITV
         K+iA6AZyV2QwTPv4HCk2r6tAWWvMRH9S1gPRGkTSQ5udyDkZTGZK40EChAIb2AmMkP5L
         IYDs7vKsU5Jwk8XTHO2lZMaHQ/+ZjFnrwQhYpKTfj3phnjWjPy0ykBVPIuMKE8zAEGn2
         CbJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=G7GoAGmrCgUPdtytsGs0a1leDFtXk/Sryc7dvR4B8po=;
        b=p2p87RoIQo9AdsX11HJeNE6idfCWmL4asVdrUR7wQvXXCccX96uJE/bOvajICAEVvp
         rc4WfIeYMkeq0h9bbZnkU+z7OF38J3b8CSDCTatvQniiREN11lF1ev0iUEn0v1xDtHNV
         G8TjryESZ9C72C+8W2tRk4lm3rjjxzyjjV0ORyFYsX37N+TtXxsObomr4POzUTR/lIrc
         Hnf+L029Sqkx3eej13EaGhj5AGOOVxJuEmXLSelnrMSKZD9azUFdVjWSD1YnTYFWKg0l
         WykFiODv/c5rMpxHVpRR6znT1jml2v8zviyCVZdYnsuaDlNk4Z/033fKZRoO5ywDNztO
         BE9w==
X-Gm-Message-State: AOAM530nNxF7bWrMLzAZes8Ckl7Nd1oPYR5mpgb0dnUQWh25Yk9uno8C
        HBc3ylEoVdnUzlzbfDLdndbP7aHapw00MlUei/U=
X-Google-Smtp-Source: ABdhPJyydyMKDwXvcxuiQSGuSO9Dfv4b+spLx3oRypDLhbf0zMQFMsm8oBNa93vcSCVpF5Lsb96BXIxeMQgiIzWIK0Y=
X-Received: by 2002:a2e:860a:0:b0:249:93fb:f45f with SMTP id
 a10-20020a2e860a000000b0024993fbf45fmr6753344lji.77.1649282350657; Wed, 06
 Apr 2022 14:59:10 -0700 (PDT)
MIME-Version: 1.0
References: <20220406153441.1667375-1-miquel.raynal@bootlin.com> <20220406153441.1667375-10-miquel.raynal@bootlin.com>
In-Reply-To: <20220406153441.1667375-10-miquel.raynal@bootlin.com>
From:   Alexander Aring <alex.aring@gmail.com>
Date:   Wed, 6 Apr 2022 17:58:59 -0400
Message-ID: <CAB_54W4epiqcATJhLB9JDZPKGZTj_jbmVwDHRZT9MxtXY6g-QA@mail.gmail.com>
Subject: Re: [PATCH v5 09/11] net: ieee802154: atusb: Call _xmit_error() when
 a transmission fails
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
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Wed, Apr 6, 2022 at 11:34 AM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
>
> ieee802154_xmit_error() is the right helper to call when a transmission
> has failed. Let's use it instead of open-coding it.
>
> Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> ---
>  drivers/net/ieee802154/atusb.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/net/ieee802154/atusb.c b/drivers/net/ieee802154/atusb.c
> index f27a5f535808..d04db4d07a64 100644
> --- a/drivers/net/ieee802154/atusb.c
> +++ b/drivers/net/ieee802154/atusb.c
> @@ -271,9 +271,8 @@ static void atusb_tx_done(struct atusb *atusb, u8 seq)
>                  * unlikely case now that seq == expect is then true, but can
>                  * happen and fail with a tx_skb = NULL;
>                  */
> -               ieee802154_wake_queue(atusb->hw);
> -               if (atusb->tx_skb)
> -                       dev_kfree_skb_irq(atusb->tx_skb);
> +               ieee802154_xmit_error(atusb->hw, atusb->tx_skb,
> +                                     IEEE802154_SYSTEM_ERROR);

That should then call the xmit_error for ANY other reason which is not
802.15.4 specific which is the bus_error() function?

- Alex
