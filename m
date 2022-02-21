Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F5A44BEA7F
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 20:36:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232045AbiBUTGs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 14:06:48 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbiBUTGr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 14:06:47 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9005C13CE4;
        Mon, 21 Feb 2022 11:06:23 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id s14so13975256edw.0;
        Mon, 21 Feb 2022 11:06:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=ceab05HpR+ch4TiH/Ob+GFc5+HuiNbuq+Jenpr7lwVY=;
        b=HwR7DkTjKPXlt4FrU/+Ajrp3Ch6Yk9qvXE0fIx8SjYAQjR76JkgOwTA+i+ahZCzaxt
         J00wR7GMsnxrMoLd0RrUdLUsdpM+qJ2XVBT+vpc5vyve5JPUuYQG9zeVYithd7tsEL2K
         c4sfPNc1cE23cGRJde900zuust3i0bAQGsi5V0U6YNphYds8kXX96Bc9MWE1F1jWYnST
         dYqAM+SK8Y5Eh5q1aAz9FOAeKdcjut26JgGmVinGz+3UXwWy2Z2gEaSshav3p2Jx336Y
         De6Xy5111TmgFJhF98xndSovZ/QcUI4eM7tBFrw3JNIDxEdVjZabi87YPPgEwzKsDFLH
         hXLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=ceab05HpR+ch4TiH/Ob+GFc5+HuiNbuq+Jenpr7lwVY=;
        b=Ozea6GpuC9XeLlmlUaa+EKjaLMR438HVmJeBHTciUmyaFgH8QI5DqLzLUV6JHxKARf
         Rj397RKHlY0Qw4p29VQw5djNU+fZvQCVJ8DXczLdQm62iRHisJB+kLiOo0CIt1EZ7pyP
         9gUMUBcKwIwVAnOoNOb3YOwN9HXWvMnA8dkWWvIyN4z65BvpWcG3ZnU27W07sKJWLtnK
         YXcjtp49h+q+9CqywImNzIjzatwxsUcBOqomb9j4pfQ+FA8aPqJhd9CEwqM1EF1VKek5
         EW6JEpRtlfWk+20atRx2/ZArGZ0Pe/OV8aQPdlEqRdIVLO2yfXd/gZDDgmTvy3nFQGtC
         OjoA==
X-Gm-Message-State: AOAM530n3pjIeISTxn+tDB3ZOHkeMEcmJayp4a6mhVwmNZIBc92bTBb+
        7dPJX9+j2yc9xRG5y5GbP7c=
X-Google-Smtp-Source: ABdhPJyFxhMatni7cLWuGFa67F+eaPI+3F3yFbkng7b/N+qeLlNJr5ElGOCe40QfwPtTNJxrUoT+Rg==
X-Received: by 2002:a50:8714:0:b0:410:5c41:3f25 with SMTP id i20-20020a508714000000b004105c413f25mr22483492edb.183.1645470381959;
        Mon, 21 Feb 2022 11:06:21 -0800 (PST)
Received: from skbuf ([188.25.231.156])
        by smtp.gmail.com with ESMTPSA id lw18sm5394725ejb.88.2022.02.21.11.06.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Feb 2022 11:06:21 -0800 (PST)
Date:   Mon, 21 Feb 2022 21:06:19 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Alvin =?utf-8?Q?=C5=A0ipraga?= <alvin@pqrs.dk>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michael Rasmussen <mir@bang-olufsen.dk>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 net-next 1/2] net: dsa: realtek: allow subdrivers to
 externally lock regmap
Message-ID: <20220221190619.4zgv7vwyvzcvxxxk@skbuf>
References: <20220221184631.252308-1-alvin@pqrs.dk>
 <20220221184631.252308-2-alvin@pqrs.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220221184631.252308-2-alvin@pqrs.dk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 21, 2022 at 07:46:30PM +0100, Alvin Šipraga wrote:
> From: Alvin Šipraga <alsi@bang-olufsen.dk>
> 
> Currently there is no way for Realtek DSA subdrivers to serialize
> consecutive regmap accesses. In preparation for a bugfix relating to
> indirect PHY register access - which involves a series of regmap
> reads and writes - add a facility for subdrivers to serialize their
> regmap access.
> 
> Specifically, a mutex is added to the driver private data structure and
> the standard regmap is initialized with custom lock/unlock ops which use
> this mutex. Then, a "nolock" variant of the regmap is added, which is
> functionally equivalent to the existing regmap except that regmap
> locking is disabled. Functions that wish to serialize a sequence of
> regmap accesses may then lock the newly introduced driver-owned mutex
> before using the nolock regmap.
> 
> Doing things this way means that subdriver code that doesn't care about
> serialized register access - i.e. the vast majority of code - needn't
> worry about synchronizing register access with an external lock: it can
> just continue to use the original regmap.
> 
> Another advantage of this design is that, while regmaps with locking
> disabled do not expose a debugfs interface for obvious reasons, there
> still exists the original regmap which does expose this interface. This
> interface remains safe to use even combined with driver codepaths that
> use the nolock regmap, because said codepaths will use the same mutex
> to synchronize access.
> 
> With respect to disadvantages, it can be argued that having
> near-duplicate regmaps is confusing. However, the naming is rather
> explicit, and examples will abound.
> 
> Finally, while we are at it, rename realtek_smi_mdio_regmap_config to
> realtek_smi_regmap_config. This makes it consistent with the naming
> realtek_mdio_regmap_config in realtek-mdio.c.
> 
> Signed-off-by: Alvin Šipraga <alsi@bang-olufsen.dk>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

>  drivers/net/dsa/realtek/realtek-mdio.c | 46 ++++++++++++++++++++++--
>  drivers/net/dsa/realtek/realtek-smi.c  | 48 ++++++++++++++++++++++++--
>  drivers/net/dsa/realtek/realtek.h      |  2 ++
>  3 files changed, 91 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/dsa/realtek/realtek-mdio.c b/drivers/net/dsa/realtek/realtek-mdio.c
> index 0308be95d00a..31e1f100e48e 100644
> --- a/drivers/net/dsa/realtek/realtek-mdio.c
> +++ b/drivers/net/dsa/realtek/realtek-mdio.c
> @@ -98,6 +98,20 @@ static int realtek_mdio_read(void *ctx, u32 reg, u32 *val)
>  	return ret;
>  }
>  
> +static void realtek_mdio_lock(void *ctx)

I looked even at the build results for v1 and I don't know exactly why
sparse doesn't complain about the lack of __acquires() and __releases()
annotations, to avoid context imbalance warnings.

https://patchwork.kernel.org/project/netdevbpf/patch/20220216160500.2341255-2-alvin@pqrs.dk/

Anyway, those aren't of much use IMO (you can't get it to do anything
but very trivial checks), and if sparse doesn't complain for whatever
reason, I certainly won't request you to add them.

I see other implementations don't have them either - like vexpress_config_lock.
