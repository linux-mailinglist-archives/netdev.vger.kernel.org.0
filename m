Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D534424270
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 18:18:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239349AbhJFQU0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 12:20:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:42882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231998AbhJFQUZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Oct 2021 12:20:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0676461166;
        Wed,  6 Oct 2021 16:18:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633537113;
        bh=t5H/xR9Gh8B4ev99gfiUYiuJjRHiXsNBFPENjcrLYII=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Fw6O4L6hKS0YVHDYjLCklEKhDhszJ1ta7gQ6nE06NoSmunAYBkeLeWaZFO1HImTa6
         c/S3ADi4lqdjolyd9zXEtma0tD1ec0n24U0c4J8AaMG2rNLqMGtjQyUHe+bm7AYX0k
         YETsPs9Hv6y1CmL9g0JkJ6DlshtVVucaVqPNfNCizXxFJn9N/tWWC26QRDFOs3xi4Q
         rpoxhUQQ+tZ54Hrk88yoKVAGSaKBhLWU0e5N4YUQYlOv1HOvsH0mc/IuD1Ze6/5Xun
         /lPyUuNR1dOz8F3BLQvczyN1zekzBZJ1p117bUdyo7OE8jPlg++OVQlGlBShLP1pAd
         rk5seyW6nFUwA==
Received: by mail-ed1-f46.google.com with SMTP id v18so11934230edc.11;
        Wed, 06 Oct 2021 09:18:32 -0700 (PDT)
X-Gm-Message-State: AOAM533KU0t2QEBnKWytpsNqW6ZRYJQyHdHK6BkcD19eg9pLUS2sjedd
        25uoM9KRZInvKXhNsr/FaT3AGTLwG350KwtQow==
X-Google-Smtp-Source: ABdhPJyM7UFe9DzvIe0l+OD9gvTJUhVYGJBVSVSUs7wURjGSrj5hreFCNI00JWgdX2SrcpjFVwcxlo25twwfrn2KyUs=
X-Received: by 2002:a17:906:71d4:: with SMTP id i20mr33206868ejk.390.1633537111464;
 Wed, 06 Oct 2021 09:18:31 -0700 (PDT)
MIME-Version: 1.0
References: <20211006154426.3222199-1-kuba@kernel.org> <20211006154426.3222199-2-kuba@kernel.org>
In-Reply-To: <20211006154426.3222199-2-kuba@kernel.org>
From:   Rob Herring <robh+dt@kernel.org>
Date:   Wed, 6 Oct 2021 11:18:19 -0500
X-Gmail-Original-Message-ID: <CAL_JsqK6YzaD0wB0BsP5tghnYMbZzDHq2p6Z_ZGr99EFWhWggw@mail.gmail.com>
Message-ID: <CAL_JsqK6YzaD0wB0BsP5tghnYMbZzDHq2p6Z_ZGr99EFWhWggw@mail.gmail.com>
Subject: Re: [PATCH net-next v2 1/9] of: net: move of_net under net/
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Saravana Kannan <saravanak@google.com>,
        Marcin Wojtas <mw@semihalf.com>, Andrew Lunn <andrew@lunn.ch>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Frank Rowand <frowand.list@gmail.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        devicetree@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 6, 2021 at 10:45 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> Rob suggests to move of_net.c from under drivers/of/ somewhere
> to the networking code.
>
> Suggested-by: Rob Herring <robh@kernel.org>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> v2: new patch
> ---
>  drivers/of/Makefile               | 1 -
>  net/core/Makefile                 | 1 +
>  {drivers/of => net/core}/of_net.c | 0
>  3 files changed, 1 insertion(+), 1 deletion(-)
>  rename {drivers/of => net/core}/of_net.c (100%)
>
> diff --git a/drivers/of/Makefile b/drivers/of/Makefile
> index c13b982084a3..e0360a44306e 100644
> --- a/drivers/of/Makefile
> +++ b/drivers/of/Makefile
> @@ -7,7 +7,6 @@ obj-$(CONFIG_OF_EARLY_FLATTREE) += fdt_address.o
>  obj-$(CONFIG_OF_PROMTREE) += pdt.o
>  obj-$(CONFIG_OF_ADDRESS)  += address.o
>  obj-$(CONFIG_OF_IRQ)    += irq.o
> -obj-$(CONFIG_OF_NET)   += of_net.o
>  obj-$(CONFIG_OF_UNITTEST) += unittest.o
>  obj-$(CONFIG_OF_RESERVED_MEM) += of_reserved_mem.o
>  obj-$(CONFIG_OF_RESOLVE)  += resolver.o
> diff --git a/net/core/Makefile b/net/core/Makefile
> index 35ced6201814..37b1befc39aa 100644
> --- a/net/core/Makefile
> +++ b/net/core/Makefile
> @@ -36,3 +36,4 @@ obj-$(CONFIG_FAILOVER) += failover.o
>  obj-$(CONFIG_NET_SOCK_MSG) += skmsg.o
>  obj-$(CONFIG_BPF_SYSCALL) += sock_map.o
>  obj-$(CONFIG_BPF_SYSCALL) += bpf_sk_storage.o
> +obj-$(CONFIG_OF_NET)   += of_net.o

The OF_NET kconfig should move or disappear too. I imagine you can do just:

obj-$(CONFIG_OF) += of_net.o

> diff --git a/drivers/of/of_net.c b/net/core/of_net.c
> similarity index 100%
> rename from drivers/of/of_net.c
> rename to net/core/of_net.c
> --
> 2.31.1
>
