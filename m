Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A129D4BD2B2
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 00:49:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245268AbiBTXgI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Feb 2022 18:36:08 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230463AbiBTXgH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Feb 2022 18:36:07 -0500
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 124724AE34;
        Sun, 20 Feb 2022 15:35:45 -0800 (PST)
Received: by mail-lj1-x22a.google.com with SMTP id u7so4656946ljk.13;
        Sun, 20 Feb 2022 15:35:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mS6wYfpUPCsSzuWc87Rw1Dc1Z08LynQyPP1cb55dLQE=;
        b=jpp7WJ4OtFe6tMD7vsQfn6i8TFsZlKXJuDnnvGKDf34ZGVgVOxx5+Kj77xMyjBeCEE
         7bOmTSC9RlpSzfPUYr9u1vHScwSLShA7J7DcRestg2pYpEhYtaD1tGc4GRAglgQPod72
         qkdQCC7opkC0i66frp+TmDeM+Ono56oYv6jAXVeNHeQ4UBmIbombagPQ3/B9oDkUARyE
         GOv+7RX/0lTs13cUTfdpE5aoygNeo9+87E9uJ8hCH5PQgxnn1fiszYjs0nSyprKOTPo7
         OF67d+3xh2eo/1VGwvuGKVpQfqwz96eamg19U+MvFaPAivN0v3mojYYc63lpsTvk3kBR
         D7Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mS6wYfpUPCsSzuWc87Rw1Dc1Z08LynQyPP1cb55dLQE=;
        b=8L0Vns2PKT70UcYUsACPfADZwb7BjaORvvNjfqQbC5dDmua4clUQ6Hn5c7jr0jFSel
         /Bf1LGI+X5USYWDBgoJRNRcL4mB2/oBFiX+c8rtg7o72/q5RSfIS+uCgTtp7Hg3Q6ZTr
         IbigYvClKgpyhS3Ndc6H9/zyFN4YHRegehfC0fqtPHePgo+qXYea857bnFrkhIi5jJRV
         GqyPHr0vxANKboVtIzc//dTWixZ/l0RjzF+jh11UuBFzfViaU14AeFetPdS+39rl2D9Y
         ilW+o4XgtUfEDdfSlRLvUevdPnk5qJ0r2N7uz96nIazL7rZCDvjQ41tLnBpQ9nEK5mvm
         Ke8g==
X-Gm-Message-State: AOAM530E4Gq3uckBC00b4qtG7VC1WXDT9jP+i4ANVmvVq+Vx4jsZHj+6
        E2f9IpWdLuEdcRk4Q0RmQU+cGr0Yziy8ssF/6Cs=
X-Google-Smtp-Source: ABdhPJwGq7iIirB91WZp4+Pir303/1Sl5fuE4JWaJSr2e1mrg/NJjZRDzKHYCzp+2D63SyITDGgtwEKhlp+RXr2UuEU=
X-Received: by 2002:a2e:7a15:0:b0:244:c138:7379 with SMTP id
 v21-20020a2e7a15000000b00244c1387379mr12964476ljc.312.1645400143101; Sun, 20
 Feb 2022 15:35:43 -0800 (PST)
MIME-Version: 1.0
References: <20220207144804.708118-1-miquel.raynal@bootlin.com> <20220207144804.708118-5-miquel.raynal@bootlin.com>
In-Reply-To: <20220207144804.708118-5-miquel.raynal@bootlin.com>
From:   Alexander Aring <alex.aring@gmail.com>
Date:   Sun, 20 Feb 2022 18:35:31 -0500
Message-ID: <CAB_54W5X+zN1YvN9SL32NVFCbqFbiR2GE-r132SXkpMKN21FhQ@mail.gmail.com>
Subject: Re: [PATCH wpan-next v2 04/14] net: ieee802154: atusb: Call
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

On Mon, Feb 7, 2022 at 9:48 AM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
>
> ieee802154_xmit_error() is the right helper to call when a transmission
> has failed. Let's use it instead of open-coding it.
>
> Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> ---
>  drivers/net/ieee802154/atusb.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
>
> diff --git a/drivers/net/ieee802154/atusb.c b/drivers/net/ieee802154/atusb.c
> index f27a5f535808..0e6f180b4e79 100644
> --- a/drivers/net/ieee802154/atusb.c
> +++ b/drivers/net/ieee802154/atusb.c
> @@ -271,9 +271,7 @@ static void atusb_tx_done(struct atusb *atusb, u8 seq)
>                  * unlikely case now that seq == expect is then true, but can
>                  * happen and fail with a tx_skb = NULL;
>                  */
> -               ieee802154_wake_queue(atusb->hw);
> -               if (atusb->tx_skb)
> -                       dev_kfree_skb_irq(atusb->tx_skb);
> +               ieee802154_xmit_error(atusb->hw, atusb->tx_skb, false);
>
Are you sure you can easily convert this? You should introduce a
"ieee802154_xmit_error_irq()"?

- Alex
