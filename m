Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 875264D782A
	for <lists+netdev@lfdr.de>; Sun, 13 Mar 2022 21:21:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235547AbiCMUWQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Mar 2022 16:22:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230136AbiCMUWP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Mar 2022 16:22:15 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BCEF7A9B0;
        Sun, 13 Mar 2022 13:21:06 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id s25so23747484lfs.10;
        Sun, 13 Mar 2022 13:21:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=g9Ta+Q+xlSrkvjGgDj1mxjhaXC8ED1/49sZigT1q9Ag=;
        b=ct9AlhJ1DNltBYDZzMe9bmw/jFFCZz8Le2HKXsK3Qv7UTv8u57qvU6H3s1RXiQ5ORO
         oqoaEI7P/qPRQII7m8fLdvh3sealWItTob1bMu0ZbCRY5zuM19UE+jVpB0QBRawGw9ls
         hk7DTqvrrm2rLLwjYwgYnA6AebuqJdj7CKRftDOBlNb3dSOduUVyqgf8rV+TWjcNJlMF
         IrvI+R4lqSz7ZOSxmYthdKpSchuok32sOIb5KpcSJoRrCwCl6gW2Vl8azMf+esECE/OI
         v1WjPrvAeNPGf4jYvKkP+jSBkA2JodHKK/7Beun3wk49XWccXGbvpQ4Xz+vMJ/GEei8H
         w5iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=g9Ta+Q+xlSrkvjGgDj1mxjhaXC8ED1/49sZigT1q9Ag=;
        b=wB3YtdGxyqSgCuS3ED8iTI+l7+yvsPcV5AQqzjnf9HQVEsvI7EHZskJdSx8T9P6Res
         jl4wJl2oEhIrN6HHMuY6rw/MvziepUiGRPe02FkT/Wh5UKie+JXkInw2Sukm/ETL65nL
         0+42tk6mi8QIP9Vew9aXSQ7Tjl8et8iavDsTmOI+DWq/x44FoO9F+JywscujwTJxv7aL
         nWF7Yn/dQmUKWN4a5RKvjGHgnE+kYWoA8NcZ2PFqJCZ06qQwbr5iSx5v3CpRhEqwPHbZ
         Gz7FmY3ZZTK+7Vkp4U6GH6dLnIwaNBO/HMoSRa3iuaRz6xQUJW/qD1rkgwchdgDoKV/N
         DLuA==
X-Gm-Message-State: AOAM530SyRv5A4C8WZteV4/05V3KZcHo/aQ09Kx/hc8PpwvnIaytPvnQ
        40ntT6bqU9ADjGXobu11jebwDMIpoYcTXlxwq6w=
X-Google-Smtp-Source: ABdhPJznfGKDrBvdIWyRxPXaMBDszMG4RowOTHALroRwnT9YrIvFWBhar7aKQGrJzLRM7qwHAMSXqLuMpb7+7OyzZ/o=
X-Received: by 2002:ac2:4207:0:b0:442:bf8b:eee with SMTP id
 y7-20020ac24207000000b00442bf8b0eeemr11904691lfh.536.1647202864380; Sun, 13
 Mar 2022 13:21:04 -0700 (PDT)
MIME-Version: 1.0
References: <20220303182508.288136-1-miquel.raynal@bootlin.com> <20220303182508.288136-10-miquel.raynal@bootlin.com>
In-Reply-To: <20220303182508.288136-10-miquel.raynal@bootlin.com>
From:   Alexander Aring <alex.aring@gmail.com>
Date:   Sun, 13 Mar 2022 16:20:53 -0400
Message-ID: <CAB_54W5Fr-1d7O4L4s4A=-TWiP9X06C9u9gC8pKM7TE9B+6shQ@mail.gmail.com>
Subject: Re: [PATCH wpan-next v3 09/11] net: ieee802154: atusb: Call
 _xmit_error() when a transmission fails
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

On Thu, Mar 3, 2022 at 1:25 PM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
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
> index f27a5f535808..9fa7febddff2 100644
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
> +                                     IEEE802154_MAC_ERROR);

I think we should have a consens what kind of 802.15.4 error we
deliver in such a case. This is more some kind of bus/device error not
related to a 802.15.4 operation, and in this case we should use the
SYSTEM_ERROR which 802.15.4 says it can be used for a kind of "user
specific error"? I mean it is not user specific but 802.15.4 spec will
never reference it to make some special handling if it occurs... just
"something failed".

- Alex
