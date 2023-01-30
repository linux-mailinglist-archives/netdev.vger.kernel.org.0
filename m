Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89E9D681A1B
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 20:14:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238372AbjA3TOS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 14:14:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238371AbjA3TOA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 14:14:00 -0500
Received: from mail-ot1-f54.google.com (mail-ot1-f54.google.com [209.85.210.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 617441258A;
        Mon, 30 Jan 2023 11:13:56 -0800 (PST)
Received: by mail-ot1-f54.google.com with SMTP id n25-20020a9d7119000000b0068bd8c1e836so595042otj.3;
        Mon, 30 Jan 2023 11:13:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lDbFnuxG6l1XpAjgFtySnYvXxJnNbaz7Bf6sNMcCGX4=;
        b=ouX6SY47YFzyD4kAkd22g+6c7r6s/xTJzzXXnaIFdXLzo7PcZhQq2zzzU0JYfKwznG
         cCxtnESkSW/E0ipXudJANEE2QzMKqfrCLhhv4fVeqFjCrYkG/JaadcKAjmgor2f4Rfmq
         JBzdMvO5qN/FJZ8CxrP2KaBWne7Pvj/TUmbJZQety8bnH8vFDrC6EK8XiMeSOuD7OZy6
         xm7Yal8hlvg4jjvDcHa5vakywegsSZ8vboAK56rI3ilEZZsTDq0sDnjx+52BO4qQKkxH
         O8rDRuKbAZa8O8+FTDwVELRdasmTa60C8vtCa1ggnYl1xOCyJTGsFRGGYrBvhcqDKlwJ
         QhhA==
X-Gm-Message-State: AO0yUKXpHPxz9+9mwZ3X83JBiysz9E7GFRvtX2tN4Ot2rmTX+6S6SXuj
        Lzl0FDtaBVQYd1rALVJsgg==
X-Google-Smtp-Source: AK7set+NgLz0rGXW5Fy2JfEXdFn9B54OxgBFqrzlgrEh5IT4KYnpQM/zbzKA4lTH3Ozild12Pxhg9w==
X-Received: by 2002:a9d:63d0:0:b0:68b:d34d:8ac1 with SMTP id e16-20020a9d63d0000000b0068bd34d8ac1mr2209032otl.23.1675106035599;
        Mon, 30 Jan 2023 11:13:55 -0800 (PST)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id p18-20020a9d76d2000000b0068655f477a6sm5658380otl.50.2023.01.30.11.13.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jan 2023 11:13:55 -0800 (PST)
Received: (nullmailer pid 3204106 invoked by uid 1000);
        Mon, 30 Jan 2023 19:13:54 -0000
Date:   Mon, 30 Jan 2023 13:13:54 -0600
From:   Rob Herring <robh@kernel.org>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Leon Romanovsky <leon@kernel.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [v3] wiznet: convert to GPIO descriptors
Message-ID: <20230130191354.GA3192963-robh@kernel.org>
References: <20230127095839.3266452-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230127095839.3266452-1-arnd@kernel.org>
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 27, 2023 at 10:57:08AM +0100, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> The w5100/w5300 drivers only support probing with old platform data in
> MMIO mode, or probing with DT in SPI mode. There are no users of this
> platform data in tree, and from the git history it appears that the only
> users of MMIO mode were on the (since removed) blackfin architecture.
> 
> Remove the platform data option, as it's unlikely to still be needed, and
> change the internal operation to GPIO descriptors, making the behavior
> the same for SPI and MMIO mode. The other data in the platform_data
> structure is the MAC address, so make that also handled the same for both.
> 
> It would probably be possible to just remove the MMIO mode driver
> completely, but it seems fine otherwise, and fixing it to use the modern
> interface seems easy enough.
> 
> The CONFIG_WIZNET_BUS_SHIFT value was apparently meant to be set
> at compile time to a machine specific value. This was always broken
> for multiplatform configurations with conflicting requirements, and
> in the mainline kernel it was set to 0 anyway. Leave it defined
> locally as 0 but rename it to something without the CONFIG_ prefix.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
> v3: include linux/gpio/consumer.h to avoid build failure without GPIOLIB
> v2: replace CONFIG_WIZNET_BUS_SHIFT with a constant
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  .../devicetree/bindings/net/wiznet,w5x00.txt  |  4 +-

Acked-by: Rob Herring <robh@kernel.org>

>  drivers/net/ethernet/wiznet/w5100-spi.c       | 21 ++-----
>  drivers/net/ethernet/wiznet/w5100.c           | 61 ++++++++++---------
>  drivers/net/ethernet/wiznet/w5100.h           |  3 +-
>  drivers/net/ethernet/wiznet/w5300.c           | 54 ++++++++--------
>  include/linux/platform_data/wiznet.h          | 23 -------
>  6 files changed, 71 insertions(+), 95 deletions(-)
>  delete mode 100644 include/linux/platform_data/wiznet.h
