Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A0E25282ED
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 13:13:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242945AbiEPLNY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 07:13:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242966AbiEPLM6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 07:12:58 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D55A2F01C;
        Mon, 16 May 2022 04:12:56 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id dk23so27919301ejb.8;
        Mon, 16 May 2022 04:12:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=6hMDjOrTAE3diAoZxz5cxSEFvkxO6o8jPO8oMHqD0pE=;
        b=JaO5qTYbXiNAu7e32sXuV8ai0ftIGiKMUc61uFgtS26hHmokyvZ4CA2B+3KDazkS5V
         HXLnKzBeuaPP7wmWCjMPmN8EEt8ZY6B8A+4uvzEMR5btCsHPXzoL5Ww8FeikKkPs5cW4
         5m5t+EZR17df+Z30ScKCwJDYzB7mcmgPeL1E+/nj/1uNsJEp9JcTXYZMYFyMk5gSQbwb
         kjKot8ZzZ12C2iIj2hJ3xNFz+70lB5FHi3YhH3jfV4966ac4ypA4sHhJmMS2EABWDZUY
         /YwiLfd2mCLmvdTZi9mRrXKxGzTffw/1LVbU2tmC4aIugLBjGmn1WFZcjaSYeJ8j15xi
         NZMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6hMDjOrTAE3diAoZxz5cxSEFvkxO6o8jPO8oMHqD0pE=;
        b=EUjiVBBon4A0ygYh/cKNAbmPkznr+24FGcYbso6I6H9IayE1utbxXkx3pQAcSshk/1
         185Wx9HoKcRK3HjgDKOOUONMERFsZX5Myei6cgBpyOfvvhrEvNQJmrIpt6ezfXau1hIH
         /gc8ODC6iV6EqXLbz8r/aDez2czPJbe0+IIrR2DH23DWwiDb+YJvp7QZiTeKQyG60LTn
         aY8xUaZoqQn4jZirjV63t259oQW+QxD8QTmjvOAmwD2mDtWkTUhgiWF2+hY2vhZ3mEjr
         exPo9VHumO8FKvEzoOC3StEMj7YUxkvwE1p2rhLMa4EMSTBrzvOu7/loFZU/FgWAXZad
         iPLw==
X-Gm-Message-State: AOAM531t8PlUI2huc065048OG29W9svIZCWgloIPuKW9OrCHLggWuLEK
        eBLCTXSaywFgHxqp4qqF0CM=
X-Google-Smtp-Source: ABdhPJzsAwDRZfUEo1XS+urcWt4CPtD86+gNxl8dLKOekqyj1lY4VS3N8tGpuu5CmVqfOjEalegwsQ==
X-Received: by 2002:a17:906:cb90:b0:6f4:d91b:1025 with SMTP id mf16-20020a170906cb9000b006f4d91b1025mr15074638ejb.177.1652699574926;
        Mon, 16 May 2022 04:12:54 -0700 (PDT)
Received: from skbuf ([188.25.160.86])
        by smtp.gmail.com with ESMTPSA id v2-20020a1709067d8200b006f3ef214e7asm3546441ejo.224.2022.05.16.04.12.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 May 2022 04:12:54 -0700 (PDT)
Date:   Mon, 16 May 2022 14:12:52 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Arun Ramadoss <arun.ramadoss@microchip.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Marek Vasut <marex@denx.de>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [RFC Patch net-next v2 4/9] net: dsa: microchip: move port
 memory allocation to ksz_common
Message-ID: <20220516111252.rggqmaj7mxv6fieg@skbuf>
References: <20220513102219.30399-1-arun.ramadoss@microchip.com>
 <20220513102219.30399-5-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220513102219.30399-5-arun.ramadoss@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 13, 2022 at 03:52:14PM +0530, Arun Ramadoss wrote:
> ksz8795 and ksz9477 init function initializes the memory to dev->ports
> and assigns the ds real number of ports. Since both the routines are
> same, moved the allocation of port memory to ksz_switch_register after
> init.
> 
> Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
> ---

Does this actually work? ksz8_switch_init() and ksz9477_switch_init()
still dereference dev->ports. They are called from dev->dev_ops->init()
from ksz_switch_register(). You have moved the devm_kzalloc() to _after_
the dev->dev_ops->init() call. So these functions are accessing memory
behind a not-yet-allocated pointer.

>  drivers/net/dsa/microchip/ksz8795.c    | 8 --------
>  drivers/net/dsa/microchip/ksz9477.c    | 8 --------
>  drivers/net/dsa/microchip/ksz_common.c | 9 +++++++++
>  3 files changed, 9 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
> index b6032b65afc2..91f29ff7256c 100644
> --- a/drivers/net/dsa/microchip/ksz8795.c
> +++ b/drivers/net/dsa/microchip/ksz8795.c
> @@ -1599,11 +1599,6 @@ static int ksz8_switch_init(struct ksz_device *dev)
>  
>  	dev->reg_mib_cnt = MIB_COUNTER_NUM;
>  
> -	dev->ports = devm_kzalloc(dev->dev,
> -				  dev->info->port_cnt * sizeof(struct ksz_port),
> -				  GFP_KERNEL);
> -	if (!dev->ports)
> -		return -ENOMEM;
>  	for (i = 0; i < dev->info->port_cnt; i++) {
>  		mutex_init(&dev->ports[i].mib.cnt_mutex);
>  		dev->ports[i].mib.counters =
> @@ -1615,9 +1610,6 @@ static int ksz8_switch_init(struct ksz_device *dev)
>  			return -ENOMEM;
>  	}
>  
> -	/* set the real number of ports */
> -	dev->ds->num_ports = dev->info->port_cnt;
> -
>  	/* We rely on software untagging on the CPU port, so that we
>  	 * can support both tagged and untagged VLANs
>  	 */
> diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
> index c712a0011367..1a0fd36e180e 100644
> --- a/drivers/net/dsa/microchip/ksz9477.c
> +++ b/drivers/net/dsa/microchip/ksz9477.c
> @@ -1482,11 +1482,6 @@ static int ksz9477_switch_init(struct ksz_device *dev)
>  	dev->reg_mib_cnt = SWITCH_COUNTER_NUM;
>  	dev->mib_cnt = TOTAL_SWITCH_COUNTER_NUM;
>  
> -	dev->ports = devm_kzalloc(dev->dev,
> -				  dev->info->port_cnt * sizeof(struct ksz_port),
> -				  GFP_KERNEL);
> -	if (!dev->ports)
> -		return -ENOMEM;
>  	for (i = 0; i < dev->info->port_cnt; i++) {
>  		spin_lock_init(&dev->ports[i].mib.stats64_lock);
>  		mutex_init(&dev->ports[i].mib.cnt_mutex);
> @@ -1499,9 +1494,6 @@ static int ksz9477_switch_init(struct ksz_device *dev)
>  			return -ENOMEM;
>  	}
>  
> -	/* set the real number of ports */
> -	dev->ds->num_ports = dev->info->port_cnt;
> -
>  	return 0;
>  }
>  
> diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
> index fd2f1bd3feb5..717734fe437e 100644
> --- a/drivers/net/dsa/microchip/ksz_common.c
> +++ b/drivers/net/dsa/microchip/ksz_common.c
> @@ -768,6 +768,15 @@ int ksz_switch_register(struct ksz_device *dev,
>  	if (ret)
>  		return ret;
>  
> +	dev->ports = devm_kzalloc(dev->dev,
> +				  dev->info->port_cnt * sizeof(struct ksz_port),
> +				  GFP_KERNEL);
> +	if (!dev->ports)
> +		return -ENOMEM;
> +
> +	/* set the real number of ports */
> +	dev->ds->num_ports = dev->info->port_cnt;
> +
>  	/* Host port interface will be self detected, or specifically set in
>  	 * device tree.
>  	 */
> -- 
> 2.33.0
> 

