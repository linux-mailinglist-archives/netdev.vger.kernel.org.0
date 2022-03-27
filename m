Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFAA24E887F
	for <lists+netdev@lfdr.de>; Sun, 27 Mar 2022 17:46:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235895AbiC0PsJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Mar 2022 11:48:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235952AbiC0PsE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Mar 2022 11:48:04 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 658323587A;
        Sun, 27 Mar 2022 08:46:25 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id p10so15023207lfa.12;
        Sun, 27 Mar 2022 08:46:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=W/T6cnilglnrlPlajGuRMRxaw46XIH7HRebTsnMpah4=;
        b=nXeKmJ1jEFe1tjHC9joahQV5vUN8oZeJbfcaD/Tzl3lK3RzeqExefcDysOsfSn9HyJ
         TGFwaYf1CiGAwObwFlrQNsEo4wTlRpRTzNUXhQFx9A7oVd3jJfKVFA1fuyZ93kwuqE1t
         zlWUzuU9PV5THceyRy87qOh1PPSBwTW4Ebrowfq/226uFagtAugSYkLDcOum81MTkmi+
         anxqbsTYSIN2jglPEg0Ew5zMwMBhore0Fdj633HgTBlfzdAZ3OhByzWDfnVjkvzTu4L8
         E6a5XThFFaRPvuhYwhLfBY1PdxhVIAGOHcyHbwRRiABuzVT5C7t3HAw+73I97iRuy8o7
         UCBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=W/T6cnilglnrlPlajGuRMRxaw46XIH7HRebTsnMpah4=;
        b=bKc494+PPhNu9iL74CbqDBH4+DtGfK/MKq0z2qb22Hb7l5OtDx6BjkCQVwbuCcDXVz
         zcsmbOs6U4xl2YXNRxYmXW04itIwMxERNyovfKY9KtajHLhJuUcDth9vipGW6TBEog9O
         taLZ3TZWzEm2zpPSdz+ol7FdFs0AGkBPgW0Jm1ujFx8KqeCDUacnNhLTzqkKUgWyw0eU
         j8H2VqvnDjowimm7uAiBmGd0S+CEPM5I3EkIkbQNMDLKURBM54qTS+j0WAWK8YEjaICK
         YL4PFJbp3t/kvX6RMWXJQATubTkFM8oECtDStkvzw6BoQUpR1gEsmuIGgaOeDRo4k1I5
         /aZg==
X-Gm-Message-State: AOAM531qeIv/WyWIM2yW7KZogr5+URdw5WFDD2vKNXcKrzmP0s2nBrMo
        RK1MBNuc0C6N6M//40i5DilNxOpNzkg4/LOFEW8=
X-Google-Smtp-Source: ABdhPJxmjLV0yvPZU4FK9cqcKyRX4pCXsHxBN2l6mMgNSlGu8oTLC2LrXSIxs6Xh9Tzu0aeA7sjiz6tB/utOUFInWqI=
X-Received: by 2002:a05:6512:3981:b0:448:40e5:cf90 with SMTP id
 j1-20020a056512398100b0044840e5cf90mr15362970lfu.656.1648395983587; Sun, 27
 Mar 2022 08:46:23 -0700 (PDT)
MIME-Version: 1.0
References: <20220318185644.517164-1-miquel.raynal@bootlin.com> <20220318185644.517164-8-miquel.raynal@bootlin.com>
In-Reply-To: <20220318185644.517164-8-miquel.raynal@bootlin.com>
From:   Alexander Aring <alex.aring@gmail.com>
Date:   Sun, 27 Mar 2022 11:46:12 -0400
Message-ID: <CAB_54W5A1xmHO-YrWS3+RD0N_66mzkDpPYjosHU3vHgn1zmONg@mail.gmail.com>
Subject: Re: [PATCH wpan-next v4 07/11] net: ieee802154: at86rf230: Provide
 meaningful error codes when possible
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
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,LOTS_OF_MONEY,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Fri, Mar 18, 2022 at 2:56 PM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
>
> Either the spi operation failed, or the offloaded transmit operation
> failed and returned a TRAC value. Use this value when available or use
> the default "SYSTEM_ERROR" otherwise, in order to propagate one step
> above the error.
>
> Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> ---
>  drivers/net/ieee802154/at86rf230.c | 25 +++++++++++++++++++++++--
>  1 file changed, 23 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/ieee802154/at86rf230.c b/drivers/net/ieee802154/at86rf230.c
> index d3cf6d23b57e..34d199f597c9 100644
> --- a/drivers/net/ieee802154/at86rf230.c
> +++ b/drivers/net/ieee802154/at86rf230.c
> @@ -358,7 +358,23 @@ static inline void
>  at86rf230_async_error(struct at86rf230_local *lp,
>                       struct at86rf230_state_change *ctx, int rc)
>  {
> -       dev_err(&lp->spi->dev, "spi_async error %d\n", rc);
> +       int reason;
> +
> +       switch (rc) {

I think there was a miscommunication last time, this rc variable is
not a trac register value, it is a linux errno. Also the error here
has nothing to do with a trac error. A trac error is the result of the
offloaded transmit functionality on the transceiver, here we dealing
about bus communication errors produced by the spi subsystem. What we
need is to report it to the softmac layer as "IEEE802154_SYSTEM_ERROR"
(as we decided that this is a user specific error and can be returned
by the transceiver for non 802.15.4 "error" return code.

> +       case TRAC_CHANNEL_ACCESS_FAILURE:
> +               reason = IEEE802154_CHANNEL_ACCESS_FAILURE;
> +               break;
> +       case TRAC_NO_ACK:
> +               reason = IEEE802154_NO_ACK;
> +               break;
> +       default:
> +               reason = IEEE802154_SYSTEM_ERROR;
> +       }
> +
> +       if (rc < 0)
> +               dev_err(&lp->spi->dev, "spi_async error %d\n", rc);
> +       else
> +               dev_err(&lp->spi->dev, "xceiver error %d\n", reason);
>
>         at86rf230_async_state_change(lp, ctx, STATE_FORCE_TRX_OFF,
>                                      at86rf230_async_error_recover);
> @@ -666,10 +682,15 @@ at86rf230_tx_trac_check(void *context)
>         case TRAC_SUCCESS:
>         case TRAC_SUCCESS_DATA_PENDING:
>                 at86rf230_async_state_change(lp, ctx, STATE_TX_ON, at86rf230_tx_on);
> +               return;
> +       case TRAC_CHANNEL_ACCESS_FAILURE:
> +       case TRAC_NO_ACK:
>                 break;
>         default:
> -               at86rf230_async_error(lp, ctx, -EIO);
> +               trac = TRAC_INVALID;
>         }
> +
> +       at86rf230_async_error(lp, ctx, trac);

That makes no sense, at86rf230_async_error() is not a trac error
handling, it is a bus error handling. As noted above. With this change
you mix bus errors and trac errors (which are not bus errors). If
there are no bus errors then trac should be evaluated and should
either deliver some 802.15.4 $SUCCESS_CODE or $ERROR_CODE to the
softmac stack, which is xmit_complete() or xmit_error().

- Alex
