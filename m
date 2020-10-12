Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5E3628B47F
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 14:20:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388454AbgJLMU2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 08:20:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388209AbgJLMU2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 08:20:28 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB5F2C0613D1
        for <netdev@vger.kernel.org>; Mon, 12 Oct 2020 05:20:27 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id t7so14519406ilf.10
        for <netdev@vger.kernel.org>; Mon, 12 Oct 2020 05:20:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=codJjfFpUB7yFKdzDGxPNsE9k2tf5zO8nIAdm/LAccs=;
        b=ejNPyHqZIGbPK8xHeo6JPxYGNzlAzWvJ3L+GcKxz30BSfNkG18irpPNJ2ihA7Tev0l
         pLnjSe95AFAb4Ms5yh387lKw7dJU3mpzfraPwYnqiubqcsDccIUL+1/YMfO1OkwtW1gS
         6ezD0KCg0pSm91GHBV8I89C6kX6Op9XLljX5sZmciiYLOVnzC4hijM8AcQQrlGBxArvJ
         pvbNQ9Wijb4PBCaUbHh9JlCHB1lEUWBH3OQ23oB/cdQ8qWwJMrGcrzwm2eM0d6Fen6/J
         jCPxLNyUYATiBJx0OWR/OmAXCPJXm9K8upqzS3fNXKWrodkYC+ZzsPUestOFD7YNFLck
         MvQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=codJjfFpUB7yFKdzDGxPNsE9k2tf5zO8nIAdm/LAccs=;
        b=WSe/fqlYGc4dE9n0gXFsFz7qUcO1wY/BQx1OT3RxJCbig5V+euJpwyL/SXSUdYWP4i
         52CDOiAbfmCX2pASL3QvOMv0RHxb8fsVdAdGjSCENdQ88+bDahpsubCBpKyWRAz2Ogjc
         4VramXSQD90HkT/qwPYxhtRuhL9WI2Slazca3Q1HSn2SmW8/J/LVVkdYopoysF9JPoVO
         oeQwuKz2oalxqc9Lrc2AiecC1rMS7zGleR9zv6F8BS6ynYioRo5h9RJLCOJhRwWRyd7n
         /WhvAK263DJwu550gEuIrM/8UmeqJeVjsVG7H1L1vYoErApQZPmV5sPbFYXdSlRq/H9r
         MeGA==
X-Gm-Message-State: AOAM533NHLVQ2kikqY5pLS7whrB3/3nl/JFtjZN8Q/D5KVAutxGiO467
        FEAtxSmymz+ra2TaqZ195M95AqwFzk59vD1c7G8x1Q==
X-Google-Smtp-Source: ABdhPJzVhgjs7DEshXDI2I/lX0MRdzs4t+AubVA7E7D/6NsX+vf80BaRkSjcA4wLlIOYLXjLCnGQ4Sc6LInRamJkaeQ=
X-Received: by 2002:a92:b610:: with SMTP id s16mr15618441ili.6.1602505226974;
 Mon, 12 Oct 2020 05:20:26 -0700 (PDT)
MIME-Version: 1.0
References: <20200928071744.18253-1-brgl@bgdev.pl>
In-Reply-To: <20200928071744.18253-1-brgl@bgdev.pl>
From:   Bartosz Golaszewski <brgl@bgdev.pl>
Date:   Mon, 12 Oct 2020 14:20:16 +0200
Message-ID: <CAMRc=MexKweGRjF5KNg1saz7NmE+tQq=03oR3wzoMsaTcm+CAA@mail.gmail.com>
Subject: Re: [PATCH] net: ethernet: ixgbe: don't propagate -ENODEV from ixgbe_mii_bus_init()
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     intel-wired-lan@lists.osuosl.org, netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Yongxin Liu <yongxin.liu@windriver.com>,
        "David S . Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 28, 2020 at 9:17 AM Bartosz Golaszewski <brgl@bgdev.pl> wrote:
>
> From: Bartosz Golaszewski <bgolaszewski@baylibre.com>
>
> It's a valid use-case for ixgbe_mii_bus_init() to return -ENODEV - we
> still want to finalize the registration of the ixgbe device. Check the
> error code and don't bail out if err == -ENODEV.
>
> This fixes an issue on C3000 family of SoCs where four ixgbe devices
> share a single MDIO bus and ixgbe_mii_bus_init() returns -ENODEV for
> three of them but we still want to register them.
>
> Fixes: 09ef193fef7e ("net: ethernet: ixgbe: check the return value of ixgbe_mii_bus_init()")
> Reported-by: Yongxin Liu <yongxin.liu@windriver.com>
> Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
> ---
>  drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> index 2f8a4cfc5fa1..d1623af30125 100644
> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> @@ -11032,7 +11032,7 @@ static int ixgbe_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>                         true);
>
>         err = ixgbe_mii_bus_init(hw);
> -       if (err)
> +       if (err && err != -ENODEV)
>                 goto err_netdev;
>
>         return 0;
> --
> 2.26.1
>

Hi!

Gentle ping for this patch. Who's picking up networking patches now
that David is OoO? Should I Cc someone else?

Bartosz
