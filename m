Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD9FE3DAAEA
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 20:30:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230114AbhG2Sa2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 14:30:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbhG2SaY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Jul 2021 14:30:24 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D1CBC061765;
        Thu, 29 Jul 2021 11:30:20 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id a26so12693250lfr.11;
        Thu, 29 Jul 2021 11:30:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=TAdDceQVUngpDy2MWRCVwVSd4gWYibtnRV4Hhvmmdh0=;
        b=YeSrQBszugRcb6ZAsSkIjI/e1Xc8dq5OGiFuA8MX6PTrynJsOWS8RuTEdPLRucyOyt
         /tP1azLQsOd59ZUOUgyc9DKYJA1e4nnZuAb7I6GczrNuLCCfsfZ0YwjG8lGA5sa7I2YY
         QyEvrxydqu+OZUq5TneiipOcYPjMG9Ui5flXNmp8q4FSAUyIoEquTzI5f/jI2i0ix+VH
         M9p7MhjJEv2bmAuO2C7FVvNhriRntaAnp5ggweLspV4ClkpoHGyNn1AP0FQ8FD+A6VQB
         cHRh1MVnjiQmgnYriS3Ct7rMq/V/8iOv2vN+elmlMx3XCsSSfG4DnkHe79dhMP42tr8c
         tjmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TAdDceQVUngpDy2MWRCVwVSd4gWYibtnRV4Hhvmmdh0=;
        b=NHidhQBnYmPm6Cp93jyLCRXwEZ9HWjp2xAhpcA9l8mbRCFu6k88tI3RgPNaCNN66FS
         JWtXUwocBnooveeAQSMLThkxbPkixWHH7RTWajfWS+SC4FNoZ9n0Fc0d8wXB8GRVKc91
         UwwX7ddwgSPpa48YnYQZywWJtWIVkNTFMy4j8FpuKVEm8O+ySJPVjbycEkRIdOLBT4eM
         s3eLZPImPJg0G+Fdh8axRYv5K1+UHHl0imwg7YTh3t9gvl09zIFAYGph0pf1qAZyzzP4
         uASC0+sZpxKVurhv3JS9QdC2pYWbr6s0Nz2KzgxlXS1+HAslL44QN4BbUIKg8Kcg1eyA
         heFg==
X-Gm-Message-State: AOAM530DRa7JgsM5z1UtfQDHi4s2KDvi75mhY2hI41QLhxsGPvBn4HMI
        GmO53/Zfu84iZs71e/09QPQ=
X-Google-Smtp-Source: ABdhPJyNVKuxYkF1eyM/3Jmwa9WLVrqX2XkfuAqWLnBH9LQymGCGyw/3G8nO+BOVL9vDmYBgo0h7CA==
X-Received: by 2002:ac2:5149:: with SMTP id q9mr4660117lfd.476.1627583418256;
        Thu, 29 Jul 2021 11:30:18 -0700 (PDT)
Received: from [192.168.1.102] ([31.173.80.187])
        by smtp.gmail.com with ESMTPSA id p21sm370068lfo.199.2021.07.29.11.30.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Jul 2021 11:30:17 -0700 (PDT)
Subject: Re: [PATCH net-next 10/18] ravb: Factorise ravb_ring_format function
To:     Biju Das <biju.das.jz@bp.renesas.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Adam Ford <aford173@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Yuusuke Ashizuka <ashiduka@fujitsu.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>
References: <20210722141351.13668-1-biju.das.jz@bp.renesas.com>
 <20210722141351.13668-11-biju.das.jz@bp.renesas.com>
From:   Sergei Shtylyov <sergei.shtylyov@gmail.com>
Message-ID: <a3f637b9-2e65-909c-01a3-d5275007866c@gmail.com>
Date:   Thu, 29 Jul 2021 21:30:15 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210722141351.13668-11-biju.das.jz@bp.renesas.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/22/21 5:13 PM, Biju Das wrote:

> The ravb_ring_format function uses extended descriptor in rx for
> R-Car where as it use normal descriptor for RZ/G2L. Factorise
> rx ring buffer buildup to extend the support for later SoC.
> 
> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
> Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> ---
>  drivers/net/ethernet/renesas/ravb.h      |  1 +
>  drivers/net/ethernet/renesas/ravb_main.c | 34 +++++++++++++++---------
>  2 files changed, 23 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/net/ethernet/renesas/ravb.h b/drivers/net/ethernet/renesas/ravb.h
> index 3a9cf6e8671a..a3258c5d0c3d 100644
> --- a/drivers/net/ethernet/renesas/ravb.h
> +++ b/drivers/net/ethernet/renesas/ravb.h
> @@ -990,6 +990,7 @@ enum ravb_chip_id {
>  
>  struct ravb_ops {
>  	void (*ring_free)(struct net_device *ndev, int q);
> +	void (*ring_format)(struct net_device *ndev, int q);

   Like I said, we don't need another indirection.... also both ops are for RX.

[...]
> diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
> index a3b8b243fd54..c23f0d420c70 100644
> --- a/drivers/net/ethernet/renesas/ravb_main.c
> +++ b/drivers/net/ethernet/renesas/ravb_main.c
> @@ -311,26 +311,15 @@ static void ravb_ring_free(struct net_device *ndev, int q)
>  }
>  
>  /* Format skb and descriptor buffer for Ethernet AVB */
> -static void ravb_ring_format(struct net_device *ndev, int q)
> +static void ravb_ring_format_rx(struct net_device *ndev, int rxq)

   How about ravb_rx_ring_format(struct net_device *ndev, int q)?

[...]

MBR, Sergei
