Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F99B4276A2
	for <lists+netdev@lfdr.de>; Sat,  9 Oct 2021 04:23:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244316AbhJICYj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 22:24:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244153AbhJICYi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Oct 2021 22:24:38 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A51C1C061570
        for <netdev@vger.kernel.org>; Fri,  8 Oct 2021 19:22:42 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id j5so46494624lfg.8
        for <netdev@vger.kernel.org>; Fri, 08 Oct 2021 19:22:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TZT+N+q8vGs87DnSpEWl5fCzYe66D8bAj5z2pbB185E=;
        b=X7T+RjuywN78Vi9AfPy889tCFaqFrW0lSrThW354P0UkmR4XUWCjsbKBbhxbr0uxkH
         SySb3VDnyIP7uHnxMdJ0CU/lTd5tieSG7qMRSuT1s3fHEc0A2XEVYKFBQUxpMGMNcf7I
         uhKEk8sAbr5c8xl0X8QyA6Khibj6i0S2Gindjb8ynvuRpfj1M8uE4NTk1W6BDETjvBhg
         Eonj6sUnrqBCLL0i6hhuqSQioon8Uhhf6ciyIlCvB413rjePFIQUYSQuvO4A7GcOwQBu
         9RfKea7U/1SbUBUetpQIMQ6GZmr8unXqOAwq1GhGyDzX3m+GkWMv73mBCN8Q4kL2zxC1
         vCrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TZT+N+q8vGs87DnSpEWl5fCzYe66D8bAj5z2pbB185E=;
        b=u7eQat7cIe2FreeleVfgHSZvIWqp+nC86T60UyIScUilIZ/xOdHgMoGxwCMqvdxvHx
         wB5JdlM+xrPyIApb2R1q0FjLgPoxXJVGt5knR+asd7K9HXY1dDCfLS50Sihm6yTSy/Jb
         r7IlAIIS7AXlBtpryQfb13FhCEhmO3rA1iUSny+C7QSsVxFxLJRLbizSuvlqucJfRYqj
         kV3YllmsQocOqZzu1U1VD5gkUjDk41niFO1CQTAC0ZVmkU+s/MuqGfLtjP1uitP6e/oZ
         xfvQF3Q6sT72gVd/mFzsOu3FxOh5v53QDKoU74YBm61IAj2k3hJWz/sTP8gcVJS+tX/1
         kEBQ==
X-Gm-Message-State: AOAM531GD22Z4hZxYKfhEQPzTtaTdbI1b4YGKYpnR7tuJcZTO0dubOMx
        D3KPThu/yj6h29Mor352s4luBBlnrigls5zG/cqNkbwr
X-Google-Smtp-Source: ABdhPJxjEj6skfI87Zcl8b/itP6b2XREriypM39ZofrhaWQaBnDTEdGvQKHuUkbTuaafS07L1XMWeJ4HmXADcDzxkzo=
X-Received: by 2002:a05:651c:230e:: with SMTP id bi14mr6167883ljb.467.1633746161057;
 Fri, 08 Oct 2021 19:22:41 -0700 (PDT)
MIME-Version: 1.0
References: <20211008175913.3754184-1-kuba@kernel.org> <20211008175913.3754184-2-kuba@kernel.org>
In-Reply-To: <20211008175913.3754184-2-kuba@kernel.org>
From:   Zhu Yanjun <zyjzyj2000@gmail.com>
Date:   Sat, 9 Oct 2021 10:22:29 +0800
Message-ID: <CAD=hENeJsFhKEcYjUYgwUYDHbaXPMqtifxsXPJXGayW2GJrxfg@mail.gmail.com>
Subject: Re: [PATCH net-next 1/5] ethernet: forcedeth: remove direct
 netdev->dev_addr writes
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Rain River <rain.1986.08.12@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 9, 2021 at 1:59 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> forcedeth writes to dev_addr byte by byte, make it use
> a local buffer instead. Commit the changes with
> eth_hw_addr_set() at the end.
>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> CC: Rain River <rain.1986.08.12@gmail.com>
> CC: Zhu Yanjun <zyjzyj2000@gmail.com>

Thanks & Regards.

Reviewed-by: Zhu Yanjun <zyjzyj2000@gmail.com>

Zhu Yanjun

> ---
>  drivers/net/ethernet/nvidia/forcedeth.c | 49 +++++++++++++------------
>  1 file changed, 26 insertions(+), 23 deletions(-)
>
> diff --git a/drivers/net/ethernet/nvidia/forcedeth.c b/drivers/net/ethernet/nvidia/forcedeth.c
> index 3f269f914dac..9b530d7509a4 100644
> --- a/drivers/net/ethernet/nvidia/forcedeth.c
> +++ b/drivers/net/ethernet/nvidia/forcedeth.c
> @@ -5711,6 +5711,7 @@ static int nv_probe(struct pci_dev *pci_dev, const struct pci_device_id *id)
>         u32 phystate_orig = 0, phystate;
>         int phyinitialized = 0;
>         static int printed_version;
> +       u8 mac[ETH_ALEN];
>
>         if (!printed_version++)
>                 pr_info("Reverse Engineered nForce ethernet driver. Version %s.\n",
> @@ -5884,50 +5885,52 @@ static int nv_probe(struct pci_dev *pci_dev, const struct pci_device_id *id)
>         txreg = readl(base + NvRegTransmitPoll);
>         if (id->driver_data & DEV_HAS_CORRECT_MACADDR) {
>                 /* mac address is already in correct order */
> -               dev->dev_addr[0] = (np->orig_mac[0] >>  0) & 0xff;
> -               dev->dev_addr[1] = (np->orig_mac[0] >>  8) & 0xff;
> -               dev->dev_addr[2] = (np->orig_mac[0] >> 16) & 0xff;
> -               dev->dev_addr[3] = (np->orig_mac[0] >> 24) & 0xff;
> -               dev->dev_addr[4] = (np->orig_mac[1] >>  0) & 0xff;
> -               dev->dev_addr[5] = (np->orig_mac[1] >>  8) & 0xff;
> +               mac[0] = (np->orig_mac[0] >>  0) & 0xff;
> +               mac[1] = (np->orig_mac[0] >>  8) & 0xff;
> +               mac[2] = (np->orig_mac[0] >> 16) & 0xff;
> +               mac[3] = (np->orig_mac[0] >> 24) & 0xff;
> +               mac[4] = (np->orig_mac[1] >>  0) & 0xff;
> +               mac[5] = (np->orig_mac[1] >>  8) & 0xff;
>         } else if (txreg & NVREG_TRANSMITPOLL_MAC_ADDR_REV) {
>                 /* mac address is already in correct order */
> -               dev->dev_addr[0] = (np->orig_mac[0] >>  0) & 0xff;
> -               dev->dev_addr[1] = (np->orig_mac[0] >>  8) & 0xff;
> -               dev->dev_addr[2] = (np->orig_mac[0] >> 16) & 0xff;
> -               dev->dev_addr[3] = (np->orig_mac[0] >> 24) & 0xff;
> -               dev->dev_addr[4] = (np->orig_mac[1] >>  0) & 0xff;
> -               dev->dev_addr[5] = (np->orig_mac[1] >>  8) & 0xff;
> +               mac[0] = (np->orig_mac[0] >>  0) & 0xff;
> +               mac[1] = (np->orig_mac[0] >>  8) & 0xff;
> +               mac[2] = (np->orig_mac[0] >> 16) & 0xff;
> +               mac[3] = (np->orig_mac[0] >> 24) & 0xff;
> +               mac[4] = (np->orig_mac[1] >>  0) & 0xff;
> +               mac[5] = (np->orig_mac[1] >>  8) & 0xff;
>                 /*
>                  * Set orig mac address back to the reversed version.
>                  * This flag will be cleared during low power transition.
>                  * Therefore, we should always put back the reversed address.
>                  */
> -               np->orig_mac[0] = (dev->dev_addr[5] << 0) + (dev->dev_addr[4] << 8) +
> -                       (dev->dev_addr[3] << 16) + (dev->dev_addr[2] << 24);
> -               np->orig_mac[1] = (dev->dev_addr[1] << 0) + (dev->dev_addr[0] << 8);
> +               np->orig_mac[0] = (mac[5] << 0) + (mac[4] << 8) +
> +                       (mac[3] << 16) + (mac[2] << 24);
> +               np->orig_mac[1] = (mac[1] << 0) + (mac[0] << 8);
>         } else {
>                 /* need to reverse mac address to correct order */
> -               dev->dev_addr[0] = (np->orig_mac[1] >>  8) & 0xff;
> -               dev->dev_addr[1] = (np->orig_mac[1] >>  0) & 0xff;
> -               dev->dev_addr[2] = (np->orig_mac[0] >> 24) & 0xff;
> -               dev->dev_addr[3] = (np->orig_mac[0] >> 16) & 0xff;
> -               dev->dev_addr[4] = (np->orig_mac[0] >>  8) & 0xff;
> -               dev->dev_addr[5] = (np->orig_mac[0] >>  0) & 0xff;
> +               mac[0] = (np->orig_mac[1] >>  8) & 0xff;
> +               mac[1] = (np->orig_mac[1] >>  0) & 0xff;
> +               mac[2] = (np->orig_mac[0] >> 24) & 0xff;
> +               mac[3] = (np->orig_mac[0] >> 16) & 0xff;
> +               mac[4] = (np->orig_mac[0] >>  8) & 0xff;
> +               mac[5] = (np->orig_mac[0] >>  0) & 0xff;
>                 writel(txreg|NVREG_TRANSMITPOLL_MAC_ADDR_REV, base + NvRegTransmitPoll);
>                 dev_dbg(&pci_dev->dev,
>                         "%s: set workaround bit for reversed mac addr\n",
>                         __func__);
>         }
>
> -       if (!is_valid_ether_addr(dev->dev_addr)) {
> +       if (is_valid_ether_addr(mac)) {
> +               eth_hw_addr_set(dev, mac);
> +       } else {
>                 /*
>                  * Bad mac address. At least one bios sets the mac address
>                  * to 01:23:45:67:89:ab
>                  */
>                 dev_err(&pci_dev->dev,
>                         "Invalid MAC address detected: %pM - Please complain to your hardware vendor.\n",
> -                       dev->dev_addr);
> +                       mac);
>                 eth_hw_addr_random(dev);
>                 dev_err(&pci_dev->dev,
>                         "Using random MAC address: %pM\n", dev->dev_addr);
> --
> 2.31.1
>
