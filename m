Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B17106A958C
	for <lists+netdev@lfdr.de>; Fri,  3 Mar 2023 11:48:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229822AbjCCKsQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Mar 2023 05:48:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjCCKsP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Mar 2023 05:48:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF73B10AA8;
        Fri,  3 Mar 2023 02:48:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4BDFB617D4;
        Fri,  3 Mar 2023 10:48:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F6A2C433EF;
        Fri,  3 Mar 2023 10:48:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677840493;
        bh=okozz4AY2el34L2QlCjDBtxJAFsbbVEKqcfLhlw1EBk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HK54mxmwGQPNbD1pW6I15F99TXYAu6nzM7X9F8nmR1gsX/K5u+QzHgIODmTJNbJs7
         l3f9+c6TbiF6hJXjoy+wHMLp0zXfucD1AhugIaX2wKhrL8hjAq0WnDjlAH+sbiFm0i
         WAEXjDaMg5a0OyEZpLRQy+eBJHXTdg/ujjB8y0+nFqI41QCuqdWxcOnnR/1vofdxQs
         V5m6oC+BrYhIl+9HEixsnpzpjMpc8ipMvCHuudKbCg/7v58cFsXi2Uev+gNXwBS2RD
         RD3QKT/2pPF8iYGKRbnMO0EPdZiraWDtV1CCyC8SY0CHyWvdhPDqfRse8FzycWF/NS
         7xNzSNHxhy+Dw==
Date:   Fri, 3 Mar 2023 10:48:07 +0000
From:   Lee Jones <lee@kernel.org>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     linux-phy@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
        Kishon Vijay Abraham I <kishon@kernel.org>,
        Vinod Koul <vkoul@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [RFC v1 net-next 2/7] mfd: ocelot: add ocelot-serdes capability
Message-ID: <20230303104807.GW2303077@google.com>
References: <20230216075321.2898003-1-colin.foster@in-advantage.com>
 <20230216075321.2898003-3-colin.foster@in-advantage.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230216075321.2898003-3-colin.foster@in-advantage.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 15 Feb 2023, Colin Foster wrote:

> Add support for the Ocelot SERDES module to support functionality of all
> non-internal phy ports.

Looks non-controversial.

Please provide some explanation of what SERDES means / is.
 
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> ---
>  drivers/mfd/ocelot-core.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)

I'd expect this to go in via MFD once it comes out of RFC.

> diff --git a/drivers/mfd/ocelot-core.c b/drivers/mfd/ocelot-core.c
> index b0ff05c1759f..c2224f8a16c0 100644
> --- a/drivers/mfd/ocelot-core.c
> +++ b/drivers/mfd/ocelot-core.c
> @@ -45,6 +45,9 @@
>  #define VSC7512_SIO_CTRL_RES_START	0x710700f8
>  #define VSC7512_SIO_CTRL_RES_SIZE	0x00000100
>  
> +#define VSC7512_HSIO_RES_START		0x710d0000
> +#define VSC7512_HSIO_RES_SIZE		0x00000128
> +
>  #define VSC7512_ANA_RES_START		0x71880000
>  #define VSC7512_ANA_RES_SIZE		0x00010000
>  
> @@ -129,8 +132,13 @@ static const struct resource vsc7512_sgpio_resources[] = {
>  	DEFINE_RES_REG_NAMED(VSC7512_SIO_CTRL_RES_START, VSC7512_SIO_CTRL_RES_SIZE, "gcb_sio"),
>  };
>  
> +static const struct resource vsc7512_serdes_resources[] = {
> +	DEFINE_RES_REG_NAMED(VSC7512_HSIO_RES_START, VSC7512_HSIO_RES_SIZE, "hsio"),
> +};
> +
>  static const struct resource vsc7512_switch_resources[] = {
>  	DEFINE_RES_REG_NAMED(VSC7512_ANA_RES_START, VSC7512_ANA_RES_SIZE, "ana"),
> +	DEFINE_RES_REG_NAMED(VSC7512_HSIO_RES_START, VSC7512_HSIO_RES_SIZE, "hsio"),
>  	DEFINE_RES_REG_NAMED(VSC7512_QS_RES_START, VSC7512_QS_RES_SIZE, "qs"),
>  	DEFINE_RES_REG_NAMED(VSC7512_QSYS_RES_START, VSC7512_QSYS_RES_SIZE, "qsys"),
>  	DEFINE_RES_REG_NAMED(VSC7512_REW_RES_START, VSC7512_REW_RES_SIZE, "rew"),
> @@ -176,6 +184,11 @@ static const struct mfd_cell vsc7512_devs[] = {
>  		.use_of_reg = true,
>  		.num_resources = ARRAY_SIZE(vsc7512_miim1_resources),
>  		.resources = vsc7512_miim1_resources,
> +	}, {
> +		.name = "ocelot-serdes",
> +		.of_compatible = "mscc,vsc7514-serdes",
> +		.num_resources = ARRAY_SIZE(vsc7512_serdes_resources),
> +		.resources = vsc7512_serdes_resources,
>  	}, {
>  		.name = "ocelot-switch",
>  		.of_compatible = "mscc,vsc7512-switch",
> -- 
> 2.25.1
> 

-- 
Lee Jones [李琼斯]
