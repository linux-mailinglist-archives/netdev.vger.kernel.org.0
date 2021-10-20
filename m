Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 261334345D3
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 09:21:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229823AbhJTHX0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 03:23:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229771AbhJTHXZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 03:23:25 -0400
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 632CFC06161C
        for <netdev@vger.kernel.org>; Wed, 20 Oct 2021 00:21:11 -0700 (PDT)
Received: by mail-yb1-xb2e.google.com with SMTP id r184so10185920ybc.10
        for <netdev@vger.kernel.org>; Wed, 20 Oct 2021 00:21:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kce2qR2xgSeHC5Mx7D1hXgnLANsYdx4gJMG57iC0thM=;
        b=GILxDG5ahW57iAeWs21x+fsM0PBBxl5rocf8TteNGaiEZxJCsMwiR8xaJCvsxBI/5O
         D8kkPcETVj/Nk1y5shywUdd90ee0aMbfPBz6tx6oktMG9AK1jTxTYBq2A25D5U6KejSf
         EASoKzke7tRzViekzf57v0QIQVwlJqI0Ftvlol09oiplTtKXEP+r62fZRDsv7OPdg8R/
         zmf2S7axOE4gEfYT8YL4G/8KLGA6AzPch1Oi+Mq5BPpNRErj872qo+E4GCorXFW6SZnx
         BEYwe539vNzk3hYgz3+y3VAYdCP4vuewq3h0jXpbL6zE1HGP8tEPa+CBjRenvcN09usq
         ot8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kce2qR2xgSeHC5Mx7D1hXgnLANsYdx4gJMG57iC0thM=;
        b=dYPIAUrZgL+T0rW4263S9k/fNOdUeJP7Qb6z81ZDc1EW3LoqATpWM3Z+GEODL+Wlqm
         Ty24SBPmWYLO8W3ULERH3cp/xhq/qJHOuKv3WxH4CBqA/FE+IAFPRS461hOBlzxVBC4h
         OHw3UcacV0OYSS47wi9BbC4x0kL4pGnNgdfdOSlQJMmnWbEMTxKlJBL2V8EEGIO+l99u
         H9VvVAd+BdV8b+u8te8ToURFmMXOEnuczWieH0xHCeT5ghJTI2YIwJER8LlMI9NgUyfN
         W/ynTRIoXjolJMsdyTIO82H1qQsUClyQld5WyU227qO1VqL/qw6Buz6iU6ltiYe+y05k
         0XUw==
X-Gm-Message-State: AOAM533Tr5b/bBoFZc/IV00EvBpLThOhqFb7xJDL98PVRP1/sP4GrLHl
        VrKC43zxofnHn06GJNGkLsdGgFqQDNXIKNkNXBslyg==
X-Google-Smtp-Source: ABdhPJwsyF9FMvt7PxQJBAQ5bCxRrypJBPKEcmabWajzCQvaQR0BVrdioLP40wR5SfHsAUpg2LEQTq9ymMiPXdjAGcw=
X-Received: by 2002:a25:42c9:: with SMTP id p192mr40691704yba.339.1634714470596;
 Wed, 20 Oct 2021 00:21:10 -0700 (PDT)
MIME-Version: 1.0
References: <20211019150011.1355755-1-kuba@kernel.org> <20211019150011.1355755-2-kuba@kernel.org>
In-Reply-To: <20211019150011.1355755-2-kuba@kernel.org>
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
Date:   Wed, 20 Oct 2021 10:20:34 +0300
Message-ID: <CAC_iWjJbjXm6PpaS5KeHXUrm1eA-t5FqVPzS6DQ6r_ZCBc4HXQ@mail.gmail.com>
Subject: Re: [PATCH net-next 1/6] ethernet: netsec: use eth_hw_addr_set()
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Jaswinder Singh <jaswinder.singh@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

On Tue, 19 Oct 2021 at 18:00, Jakub Kicinski <kuba@kernel.org> wrote:
>
> Commit 406f42fa0d3c ("net-next: When a bond have a massive amount
> of VLANs...") introduced a rbtree for faster Ethernet address look
> up. To maintain netdev->dev_addr in this tree we need to make all
> the writes to it got through appropriate helpers.
>
> Read the address into an array on the stack, then call
> eth_hw_addr_set().
>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> CC: jaswinder.singh@linaro.org
> CC: ilias.apalodimas@linaro.org
> ---
>  drivers/net/ethernet/socionext/netsec.c | 16 +++++++++-------
>  1 file changed, 9 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/net/ethernet/socionext/netsec.c b/drivers/net/ethernet/socionext/netsec.c
> index baa9f5d1c549..de7d8bf2c226 100644
> --- a/drivers/net/ethernet/socionext/netsec.c
> +++ b/drivers/net/ethernet/socionext/netsec.c
> @@ -2037,13 +2037,15 @@ static int netsec_probe(struct platform_device *pdev)
>         if (ret && priv->eeprom_base) {
>                 void __iomem *macp = priv->eeprom_base +
>                                         NETSEC_EEPROM_MAC_ADDRESS;
> -
> -               ndev->dev_addr[0] = readb(macp + 3);
> -               ndev->dev_addr[1] = readb(macp + 2);
> -               ndev->dev_addr[2] = readb(macp + 1);
> -               ndev->dev_addr[3] = readb(macp + 0);
> -               ndev->dev_addr[4] = readb(macp + 7);
> -               ndev->dev_addr[5] = readb(macp + 6);
> +               u8 addr[ETH_ALEN];
> +
> +               addr[0] = readb(macp + 3);
> +               addr[1] = readb(macp + 2);
> +               addr[2] = readb(macp + 1);
> +               addr[3] = readb(macp + 0);
> +               addr[4] = readb(macp + 7);
> +               addr[5] = readb(macp + 6);
> +               eth_hw_addr_set(ndev, addr);
>         }
>
>         if (!is_valid_ether_addr(ndev->dev_addr)) {
> --
> 2.31.1
>

Thanks!

Acked-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
