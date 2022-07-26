Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B73E45808AF
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 02:14:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232120AbiGZAOF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 20:14:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232178AbiGZAOE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 20:14:04 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4F2927FEE;
        Mon, 25 Jul 2022 17:14:03 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id mf4so23444239ejc.3;
        Mon, 25 Jul 2022 17:14:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=RjAABNLn2RXdMld/WknyUgPOruiRH8hGVQ9Xhd2XuJM=;
        b=QBNHbBNGfgaH/jYAq+bJa/tTVZ073zXcthViK62C39y6uEG5jIj/lo+J2PsUKf1Lkq
         hFKe4/hud5JgC9HzM/KsRpXdRmzK3l/sltso4Js79vtxij2kybwE4qX9kM6Tyv+wvC8H
         27+tUyZ3Xa4eR7kPx/bkrQ/WXV4aB2l+S24uVuU4tIGPMpINdSrTHwieUkPDaKfA6D7D
         fYWQPRHcToFU8H3P7OUwwlyHWmDGxXwCvHNbdVa36xcQ0B2uKHYMGWJKkqHvDvrNKCRr
         4TnJ7GfW1FnGq+ZaDPWvIxAq8vCBHML8lBpDZJgM2+EJZ35sA7Fd1+JFIDcp+8ikll+F
         cXxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=RjAABNLn2RXdMld/WknyUgPOruiRH8hGVQ9Xhd2XuJM=;
        b=NvXztdIlQbTsKch1CVfuUDURjahdlBTNp7OjYeJ8gx/6VygkrpeZykDpnFOpSTzvl/
         mqk+msiEXyoVBt8hYxGIO8jt6YlIj/RYXzEbtxxHg5bIkUkCzumUSOa7cQQAQGhUhFu4
         7YGjRjNsn9X3VCHjYPv9Q/FeljLHlckV8X6sEVI5DRFYwhDMbhm7M1jC/vKbLFHmvSuV
         nZ0N75c4ICNltq4kRkgTuGnbnMZBa1goRydfLT5jWx/SJn0kv53lA3YPRPBxcKBfxScU
         pwkBHMcrRJtfEnTtoV/reP0+Z3YEZPbJ5uu9V5mqJtfa1KTOqVCDZa7RqnPGIPEzzXQy
         mxKA==
X-Gm-Message-State: AJIora/GWQ10RTLo6w5+ZaVx2IOJAJwz18zVCwY/HP/RKQRM3HykWoNl
        T0GwqehuFcAws/jPOP6wnrw=
X-Google-Smtp-Source: AGRyM1vmgXFPwq9hO1NnwpRu2q5JFTe36azADRT5HWrY7YSkuK5Yl6LwO1jzeVHOKDnGP1b3jNAdRw==
X-Received: by 2002:a17:907:1c95:b0:72b:4e37:7736 with SMTP id nb21-20020a1709071c9500b0072b4e377736mr11864415ejc.516.1658794442478;
        Mon, 25 Jul 2022 17:14:02 -0700 (PDT)
Received: from skbuf ([188.25.231.115])
        by smtp.gmail.com with ESMTPSA id we10-20020a170907234a00b006fec4ee28d0sm5921431ejb.189.2022.07.25.17.14.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jul 2022 17:14:02 -0700 (PDT)
Date:   Tue, 26 Jul 2022 03:13:59 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Christian Marangi <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [net-next PATCH v3 06/14] net: dsa: qca8k: move mib init
 function to common code
Message-ID: <20220726001359.m2sfsvyph2rufqly@skbuf>
References: <20220723141845.10570-1-ansuelsmth@gmail.com>
 <20220723141845.10570-7-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220723141845.10570-7-ansuelsmth@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 23, 2022 at 04:18:37PM +0200, Christian Marangi wrote:
> The same mib function is used by drivers based on qca8k family switch.
> Move it to common code to make it accessible also by other drivers.
> 
> Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> ---
> diff --git a/drivers/net/dsa/qca/qca8k-common.c b/drivers/net/dsa/qca/qca8k-common.c
> index 2f96f1d4b921..9e9e3f0b7179 100644
> --- a/drivers/net/dsa/qca/qca8k-common.c
> +++ b/drivers/net/dsa/qca/qca8k-common.c
> @@ -138,3 +138,39 @@ int qca8k_bulk_write(struct qca8k_priv *priv, u32 reg, u32 *val, int len)
>  
>  	return 0;
>  }
> +
> +int
> +qca8k_busy_wait(struct qca8k_priv *priv, u32 reg, u32 mask)

Can take up a single line.

> +{
> +	u32 val;
> +
> +	return regmap_read_poll_timeout(priv->regmap, reg, val, !(val & mask), 0,
> +				       QCA8K_BUSY_WAIT_TIMEOUT * USEC_PER_MSEC);
> +}
