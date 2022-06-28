Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8334155EF05
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 22:14:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232110AbiF1UOX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 16:14:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231828AbiF1UNu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 16:13:50 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE7F813D64;
        Tue, 28 Jun 2022 13:07:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
        Message-ID:Sender:Reply-To:Content-ID:Content-Description;
        bh=a6AnJ5JUpgsz1KJ9YhexUeYWOp5iHJCwBQ9saqPDdtA=; b=VnaHISVICqlvsTwkAW4MliAcH+
        B5kOQBGYkOHR9O/YlEzHCKMUa5OBO76qUrCigMoSp+tNLqYtegiT3LTn6YRmj9cRVlVN83kVdJjaO
        JKmYquyVSTibvxqOm0Va5VzPlZgaxgf2PzPoEVI1OrzsW1FO2zr+vNTYskV2OGp5lzwDnXmDyjXNj
        GCf41sQpWwvJwVO+tKlAQYl6Kc3vPBkVCEI3oGkQyHzmudUODto0RUIzFiivhsch/Uf9b+NvNJsCi
        rSmhPEIGEdA4Ol3SHO6d8+Ie7srm2JixdDNX9emZd7yZ/hICP1AxizvXriC7npaHtK2z5gju0N9F1
        Elus4IGA==;
Received: from c-73-157-219-8.hsd1.or.comcast.net ([73.157.219.8] helo=[10.0.0.153])
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o6HV3-007yNs-7R; Tue, 28 Jun 2022 20:07:53 +0000
Message-ID: <ddb01b36-1369-f0e3-49ab-3c0a571fe708@infradead.org>
Date:   Tue, 28 Jun 2022 13:07:51 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v11 net-next 9/9] mfd: ocelot: add support for the vsc7512
 chip via spi
Content-Language: en-US
To:     Colin Foster <colin.foster@in-advantage.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-gpio@vger.kernel.org
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Lee Jones <lee.jones@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Linus Walleij <linus.walleij@linaro.org>,
        Wolfram Sang <wsa@kernel.org>,
        Terry Bowman <terry.bowman@amd.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>
References: <20220628081709.829811-1-colin.foster@in-advantage.com>
 <20220628081709.829811-10-colin.foster@in-advantage.com>
From:   Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20220628081709.829811-10-colin.foster@in-advantage.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/28/22 01:17, Colin Foster wrote:
> --- a/drivers/mfd/Kconfig
> +++ b/drivers/mfd/Kconfig
> @@ -962,6 +962,24 @@ config MFD_MENF21BMC
>  	  This driver can also be built as a module. If so the module
>  	  will be called menf21bmc.
>  
> +config MFD_OCELOT
> +	bool "Microsemi Ocelot External Control Support"
> +	depends on SPI_MASTER
> +	select MFD_CORE
> +	select REGMAP_SPI
> +	help
> +	  Ocelot is a family of networking chips that support multiple ethernet
> +	  and fibre interfaces. In addition to networking, they contain several
> +	  other functions, including pictrl, MDIO, and communication with

	Is that                      pinctrl,
?

> +	  external chips. While some chips have an internal processor capable of
> +	  running an OS, others don't. All chips can be controlled externally
> +	  through different interfaces, including SPI, I2C, and PCIe.
> +
> +	  Say yes here to add support for Ocelot chips (VSC7511, VSC7512,
> +	  VSC7513, VSC7514) controlled externally.
> +
> +	  If unsure, say N.

-- 
~Randy
