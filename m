Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAF615282C7
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 13:03:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242860AbiEPLDg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 07:03:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236439AbiEPLDe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 07:03:34 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6192645E;
        Mon, 16 May 2022 04:03:33 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id j28so3737209eda.13;
        Mon, 16 May 2022 04:03:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=o/o3v7ZExwezLINEuSL6WqytN66pCJ4TqFvl6Zpq4Lo=;
        b=X0hWfOJKDqbAk3Z4FtjoxaftEdXliEndPnQeEmR9CUQfy9CT6DkDCs43AaWOqdEH3l
         1DtSl/KwEUSn/12xwsGSpAtYrL9x7mZ3eJTvHXDW8CTcs3XKL9Q9TnZbH/hsuBCBt5FX
         4YIaSbRHYu64DnkrhLUtONd2Dn8Ow7TrLZmQmeR0kTPJTHBpKaKVyivT9dG2WLc6R9hV
         zqIsB/NKoeO38jnLrXvKDTtu6TwYsYDCPgkDrmXxJE/SB4MNcrogpROUIZyiIX3HmKK4
         9SItC5+G8Lu4AEdHtbzEIp8vSRphmSk+eNJkDov8NVEGtf92xM5GqksQIA5OuQjZfqYO
         efVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=o/o3v7ZExwezLINEuSL6WqytN66pCJ4TqFvl6Zpq4Lo=;
        b=FaYNaEKLdTTWB/sJDj55glrBVqsTMzI8G4xIaZKjhQcaeRkCAmKYlduPza9syYcQWb
         NkUIyvRdZdr3n0zCjd1byFVdag388xbOaOp/rN2+dZ/bCGsxSE1NC5lkcf/hYPsUSS9O
         i9rX1vsKQBu7dPttMAj2qmw1aICVd26ZWvHS4CEiksgS8n7mOexj59BC3UgiIbVHFhI3
         Xzv3R5SqQarGF1UjtQ6FfVtf30gHg8lv0KygZAIhP0rwMAyZBKCr8vUsMgR4ZutCqTyg
         JG1baBApYwjXMypjlIVk8+DX2p2f9P6BxkxGpw2qqIB9irLuHn498w+flY5Zj/cdNh1w
         JUGg==
X-Gm-Message-State: AOAM533TRY33EcPfvsuOC3tkK4l0erDDpuVwzcsb8FyMfmP/ahxEocv/
        iFUCOmY0wcOiXNKo3SEGYvE=
X-Google-Smtp-Source: ABdhPJzdEWLmGiWd1n0V3A06wxaMzEpKsQdnLgjd1G/qy76KhTu6N/P1UnFlkMDo0JuWxBg2YZgzgQ==
X-Received: by 2002:a05:6402:4384:b0:427:b5c0:4bf with SMTP id o4-20020a056402438400b00427b5c004bfmr12422773edc.127.1652699012407;
        Mon, 16 May 2022 04:03:32 -0700 (PDT)
Received: from skbuf ([188.25.160.86])
        by smtp.gmail.com with ESMTPSA id h11-20020a1709070b0b00b006f3ef214e5esm3548409ejl.196.2022.05.16.04.03.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 May 2022 04:03:31 -0700 (PDT)
Date:   Mon, 16 May 2022 14:03:30 +0300
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
Subject: Re: [RFC Patch net-next v2 3/9] net: dsa: microchip: perform the
 compatibility check for dev probed
Message-ID: <20220516110330.rzoqq2lzgpygk7a3@skbuf>
References: <20220513102219.30399-1-arun.ramadoss@microchip.com>
 <20220513102219.30399-4-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220513102219.30399-4-arun.ramadoss@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 13, 2022 at 03:52:13PM +0530, Arun Ramadoss wrote:
> This patch perform the compatibility check for the device after the chip
> detect is done. It is to prevent the mismatch between the device
> compatible specified in the device tree and actual device found during
> the detect. The ksz9477 device doesn't use any .data in the
> of_device_id. But the ksz8795 uses .data for assigning the regmap
> between 8830 family and 87xx family switch. Changed the regmap
> assignment based on the chip_id from the .data.
> 
> Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
> ---
>  drivers/net/dsa/microchip/ksz8795_spi.c | 37 ++++++++++++++++++++-----
>  drivers/net/dsa/microchip/ksz9477_i2c.c | 30 ++++++++++++++++----
>  drivers/net/dsa/microchip/ksz9477_spi.c | 30 ++++++++++++++++----
>  drivers/net/dsa/microchip/ksz_common.c  | 25 ++++++++++++++++-
>  drivers/net/dsa/microchip/ksz_common.h  |  1 +
>  5 files changed, 103 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/net/dsa/microchip/ksz8795_spi.c b/drivers/net/dsa/microchip/ksz8795_spi.c
> index 5f8d94aee774..1ae1b1ee9f2a 100644
> --- a/drivers/net/dsa/microchip/ksz8795_spi.c
> +++ b/drivers/net/dsa/microchip/ksz8795_spi.c
> @@ -31,9 +31,12 @@ KSZ_REGMAP_TABLE(ksz8795, 16, KSZ8795_SPI_ADDR_SHIFT,
>  KSZ_REGMAP_TABLE(ksz8863, 16, KSZ8863_SPI_ADDR_SHIFT,
>  		 KSZ8863_SPI_TURNAROUND_SHIFT, KSZ8863_SPI_ADDR_ALIGN);
>  
> +#define KSZ_88X3_FAMILY 0x8830
> +

Can we have this macro defined in ksz_common.h and used in the chip_id
of the ksz_chip_data structure as well? It makes things easier to follow
by pattern matching. And for symmetry, it would probably be good to have
such a macro for all chip ids.
