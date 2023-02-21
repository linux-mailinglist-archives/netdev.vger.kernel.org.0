Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57B7269DE83
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 12:11:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233993AbjBULLb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 06:11:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233982AbjBULLK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 06:11:10 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29324234F2;
        Tue, 21 Feb 2023 03:11:09 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id z8so3710414wrm.8;
        Tue, 21 Feb 2023 03:11:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+Vc79bWCpRiLJ+dwUFSriT0T5tlYigG2gcPRn6VTB+Q=;
        b=jbfTXpeYUw4apFbNxtM2iClaQ0bIe0hj3aYX1vCMRl2oXylABg8ylItAjHfldCRfBF
         BGOr1514t1L2hH63J+AqxnzqDI6Tchu1JW8vORqRUNra/8e87N+F1oCPg035EZCsxUeq
         nZxvsnGvYBZd8btx1ZGsH5YeFr8Zk5AIoLiTGhrMX6MzZ1//FVdWpq2eykwpoeNDEfma
         wBynsJJY/vHNP5E/o7w3f/FlY/sOyXOvjxx/bE07EtClwS5MwUSqUztz739fKHXV8pMZ
         XVzp5qzqEHG43PdrUrrvnVLkp99qru9QYlS+1rTEbuEGwmxr9pcoVbMEzyqrCB7Gfy6b
         Pw1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+Vc79bWCpRiLJ+dwUFSriT0T5tlYigG2gcPRn6VTB+Q=;
        b=GCEMiNg9RoW5uKGAmodwBlJfBW+h71/sUOvXp9DNKsZfOjuhRfzGW6OZcqbdxTVOxr
         MTsSaGJL0PunbkMYeJpnLWlrl2htBHtOWSgexBYVb3gNH7v+GyQJHGZbft4xit5DnM/o
         p9WkVDsrd9z/jO+DmnsAfOJc0bmj2TS/BtrPpfUld5HVuW/ivprfOXbN7bkVTVEfA21u
         0t2NjdVmK2+1GAdRKpxvHNbkw5VlF34/Yn8CgGsgAmkHF3dN4mvzTIltkP+p9LLIoOI3
         PDE9bNq/8YROb0iTRm4Q2jwDru8vc/aEQkB6BtsWazQUvQ4KxW3ZfYAvtM4oB4wGFtsP
         3xMw==
X-Gm-Message-State: AO0yUKWzFKJztPPbThdvHoTcBid6OswI3stHLqbm2Ym3G5EsyRdAXB+u
        h54YNCH2nLMyorQFS7aXQW8=
X-Google-Smtp-Source: AK7set9SeHglCwmtMWvVShP6vBpaKk77MFkzhWPQzWKVv0/MOBJLSmyfY4P4ydVv1sxzwfBlPglcDg==
X-Received: by 2002:a5d:410b:0:b0:2c5:8c56:42d3 with SMTP id l11-20020a5d410b000000b002c58c5642d3mr2924029wrp.23.1676977867613;
        Tue, 21 Feb 2023 03:11:07 -0800 (PST)
Received: from ?IPV6:2a01:c22:6e4d:5f00:c8b7:365d:f8a9:9c38? (dynamic-2a01-0c22-6e4d-5f00-c8b7-365d-f8a9-9c38.c22.pool.telefonica.de. [2a01:c22:6e4d:5f00:c8b7:365d:f8a9:9c38])
        by smtp.googlemail.com with ESMTPSA id s17-20020a5d4ed1000000b002c4084d3472sm1126462wrv.58.2023.02.21.03.11.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Feb 2023 03:11:06 -0800 (PST)
Message-ID: <2e90ab1e-5773-bf9c-36b3-8da325fd4955@gmail.com>
Date:   Tue, 21 Feb 2023 12:11:05 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH net-next] net: phy: update obsolete comment about
 PHY_STARTING
Content-Language: en-US
To:     Wolfram Sang <wsa+renesas@sang-engineering.com>,
        linux-renesas-soc@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>, Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230221105711.39364-1-wsa+renesas@sang-engineering.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
In-Reply-To: <20230221105711.39364-1-wsa+renesas@sang-engineering.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 21.02.2023 11:57, Wolfram Sang wrote:
> Commit 899a3cbbf77a ("net: phy: remove states PHY_STARTING and
> PHY_PENDING") missed to update a comment in phy_probe. Remove
> superfluous "Description:" prefix while we are here.
> 
> Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
> ---
>  drivers/net/phy/phy_device.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
> index 8cff61dbc4b5..3a515955ffd8 100644
> --- a/drivers/net/phy/phy_device.c
> +++ b/drivers/net/phy/phy_device.c
> @@ -3019,9 +3019,7 @@ EXPORT_SYMBOL_GPL(fwnode_get_phy_node);
>   * phy_probe - probe and init a PHY device
>   * @dev: device to probe and init
>   *
> - * Description: Take care of setting up the phy_device structure,
> - *   set the state to READY (the driver's init function should
> - *   set it to STARTING if needed).
> + * Take care of setting up the phy_device structure, set the state to READY.
>   */
>  static int phy_probe(struct device *dev)
>  {

Reviewed-by: Heiner Kallweit <hkallweit1@gmail.com>
