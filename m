Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D3B53E1C23
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 21:07:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242248AbhHETHa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 15:07:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232716AbhHETH3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Aug 2021 15:07:29 -0400
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 310DEC061765;
        Thu,  5 Aug 2021 12:07:14 -0700 (PDT)
Received: by mail-lj1-x232.google.com with SMTP id b21so8451207ljo.13;
        Thu, 05 Aug 2021 12:07:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ONKmlzMQHSR+WTdRXvtgS3Q3dBCN8EOuUcG0etWCxEE=;
        b=IrwWWRhu7zk2Vlyhpvaaetchv4FXsImvtne/NR3RGPKvlFjNQ7RzuOZs5lBPSuxFnc
         qQA7AgEyAp45apcTyIPuShrYUYZ9SyiThQKLsm0I8HJvLJOXdT06kgJ8ILoAYzKDY0YA
         aj2mc0rmNGJk0+ItMpDlGA94AlIrjmgnZTzR0NZd8/BsEKPlf0S1kReXX00ZX3Ya7BB2
         OIAOZ20VufZLCBSCFmFuo6jfYLGd4o66CLYYjnPETOakC5KEX7gi2Hj1QyyYZ1MDsM4h
         fk6Ly9c8C5PMRmb4OSDWQcHA73HwPGUO6+0i6F+y7joIL+WQoNodmvCFUceQ76cwcKBT
         Qpcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ONKmlzMQHSR+WTdRXvtgS3Q3dBCN8EOuUcG0etWCxEE=;
        b=Xpgcgk+UAk2D3P+HPb1ky99i3m2tyqDpmCl7EGeDevzqQFSXc8m478/arUN9BOW6Ra
         vD4Wd3h1g7J643YWBuQsgyYU+Y0j878f4Wc2bXv//6EkvLjhH+KzG3J6clM/T5w/y2do
         ynCCQevhtejvXgDqTMzN+UUL5JW5tOLR8VcB2MWMykFf3qv+Abzb7ztkGVy5gFy38oZ7
         lAdR0JgYneZ5IkPMF1e1rV8Xn4APeK35XS7nskkQiv6y4wND4EwDo1mFRAGFo8+oIQTD
         6vH81uCrmCggBBDEzNXAnq7uGdbV+AhPIaC3vHRf6UGGkF3gl96CgQVWCOZRFMTzDcME
         QWZw==
X-Gm-Message-State: AOAM533MFmupwZi+fYqGMmUwIXrWFgG27vVM2DlvCp7vGI14VXZOj+fl
        mloEd2zyHxMPWAhY1dBw48w=
X-Google-Smtp-Source: ABdhPJw6wZEoJaD0L1Ok0Y6OR2fTNVlKgeupOQL74/7ksztkOa/comGhKa2+Chbc9t1438XZwfrY4Q==
X-Received: by 2002:a05:651c:b06:: with SMTP id b6mr3971517ljr.171.1628190432580;
        Thu, 05 Aug 2021 12:07:12 -0700 (PDT)
Received: from [192.168.1.102] ([178.176.79.25])
        by smtp.gmail.com with ESMTPSA id i3sm10025lfr.217.2021.08.05.12.07.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Aug 2021 12:07:12 -0700 (PDT)
Subject: Re: [PATCH net-next v2 6/8] ravb: Add net_features and
 net_hw_features to struct ravb_hw_info
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
References: <20210802102654.5996-1-biju.das.jz@bp.renesas.com>
 <20210802102654.5996-7-biju.das.jz@bp.renesas.com>
From:   Sergei Shtylyov <sergei.shtylyov@gmail.com>
Message-ID: <0daf8d07-b412-4cb0-cbfb-e8f8b84184e5@gmail.com>
Date:   Thu, 5 Aug 2021 22:07:10 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210802102654.5996-7-biju.das.jz@bp.renesas.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/2/21 1:26 PM, Biju Das wrote:

> On R-Car the checksum calculation on RX frames is done by the E-MAC
> module, whereas on RZ/G2L it is done by the TOE.
> 
> TOE calculates the checksum of received frames from E-MAC and outputs it to
> DMAC. TOE also calculates the checksum of transmission frames from DMAC and
> outputs it E-MAC.
> 
> Add net_features and net_hw_features to struct ravb_hw_info, to support
> subsequent SoCs without any code changes in the ravb_probe function.
> 
> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
> Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>

[...]
> diff --git a/drivers/net/ethernet/renesas/ravb.h b/drivers/net/ethernet/renesas/ravb.h
> index b765b2b7d9e9..3df813b2e253 100644
> --- a/drivers/net/ethernet/renesas/ravb.h
> +++ b/drivers/net/ethernet/renesas/ravb.h
> @@ -991,6 +991,8 @@ enum ravb_chip_id {
>  struct ravb_hw_info {
>  	const char (*gstrings_stats)[ETH_GSTRING_LEN];
>  	size_t gstrings_size;
> +	netdev_features_t net_hw_features;
> +	netdev_features_t net_features;

   Do we really need both of these here? It seems like the 'feartures' mirrors the enabled features?

>  	enum ravb_chip_id chip_id;
>  	int num_gstat_queue;
>  	int num_tx_desc;
> diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
> index 7a69668cb512..2ac962b5b8fb 100644
> --- a/drivers/net/ethernet/renesas/ravb_main.c
> +++ b/drivers/net/ethernet/renesas/ravb_main.c
[...]
> @@ -2077,14 +2081,14 @@ static int ravb_probe(struct platform_device *pdev)
>  	if (!ndev)
>  		return -ENOMEM;
>  
> -	ndev->features = NETIF_F_RXCSUM;
> -	ndev->hw_features = NETIF_F_RXCSUM;
> +	info = of_device_get_match_data(&pdev->dev);
> +
> +	ndev->features = info->net_features;
> +	ndev->hw_features = info->net_hw_features;

   What value you plan to set her for GbEth, NETIF_F_HW_CSUM?

[...]

MBR, Sergei
