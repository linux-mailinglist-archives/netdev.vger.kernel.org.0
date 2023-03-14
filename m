Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC0276B8C3D
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 08:54:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230255AbjCNHyV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 03:54:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230280AbjCNHyE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 03:54:04 -0400
Received: from proxima.lasnet.de (proxima.lasnet.de [IPv6:2a01:4f8:121:31eb:3::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D2571114C;
        Tue, 14 Mar 2023 00:54:01 -0700 (PDT)
Received: from [10.196.200.216] (unknown [88.128.88.188])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id 55641C1360;
        Tue, 14 Mar 2023 08:53:49 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=datenfreihafen.org;
        s=2021; t=1678780440;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KQN5XtmNExyibOI8xA/+lsumWUm3e/taRoixYMjERsE=;
        b=pCEcG05lhGpCn9MgXRORpL+GWUpKtag8l+csz0178ztZqMbT2TQvd1vV1vB+6whAxjZ9IZ
        /rsK5ilviX8W2sGkKeqfjv3NHsQNln4U7SaID0c126AhSlhjsVJ8x8u5c5pUyMed7lRMpz
        mAfD1yXyxVfeSrfuf4ojYgGQSR/I3jLdkBVqoyrCQlxDG+vSDAhrQWIYhAL8Se+/UPPV9S
        ppjpdAe3rp9zDAh8aghqPiQSchCQkP1CUfeOWpp8q7rl/T3B69Q8MTdjvQPVusb0Nvr0Et
        sjeT/t+/b6+RQXgIjfnDhpSLK3Dt1IMtVTvVIOeV54ThnXM+lH24tWNas/b/Yg==
Message-ID: <65d7793d-2faa-fd2f-5b02-89fe4e4f0083@datenfreihafen.org>
Date:   Tue, 14 Mar 2023 08:53:48 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 12/12] net: ieee802154: ca8210: drop owner from driver
Content-Language: en-US
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Alexander Aring <alex.aring@gmail.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-wpan@vger.kernel.org
References: <20230311173303.262618-1-krzysztof.kozlowski@linaro.org>
 <20230311173303.262618-12-krzysztof.kozlowski@linaro.org>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
In-Reply-To: <20230311173303.262618-12-krzysztof.kozlowski@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello.

On 11.03.23 18:33, Krzysztof Kozlowski wrote:
> Core already sets owner in spi_driver.
> 
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> ---
>   drivers/net/ieee802154/ca8210.c | 1 -
>   1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/net/ieee802154/ca8210.c b/drivers/net/ieee802154/ca8210.c
> index 65d28e8a87c9..ca1fa56cca68 100644
> --- a/drivers/net/ieee802154/ca8210.c
> +++ b/drivers/net/ieee802154/ca8210.c
> @@ -3180,7 +3180,6 @@ MODULE_DEVICE_TABLE(of, ca8210_of_ids);
>   static struct spi_driver ca8210_spi_driver = {
>   	.driver = {
>   		.name =                 DRIVER_NAME,
> -		.owner =                THIS_MODULE,
>   		.of_match_table =       ca8210_of_ids,
>   	},
>   	.probe  =                       ca8210_probe,

Acked-by: Stefan Schmidt <stefan@datenfreihafen.org>

regards
Stefan Schmidt
