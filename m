Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F30EC51B556
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 03:42:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235938AbiEEBqR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 21:46:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235887AbiEEBqP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 21:46:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57D61DFD1
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 18:42:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1F563B82AA2
        for <netdev@vger.kernel.org>; Thu,  5 May 2022 01:42:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DE15C385A5;
        Thu,  5 May 2022 01:42:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651714955;
        bh=oIo0r+SeZSnR3FeIlGK8+8wswghaclLisVdCzxh2+3A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jdU0bR6M6XC1rQUIcSIK601MzW4bdJjH+qzPvk7CO1FEs3HFB44I4rkc6e2Qn+ozA
         U6qEZAvf26simM/b1+ja9jr4dUIARd9EiQLbYre3eiwKK4GZwNaj9vCAcrtuRCAa7x
         qcyef62QI/ejDCjJ2YoUBH3DBD+PHmI5btdge7SlZntLxcClnOqDmLfqEcJYp9bcV2
         a6xnjf0cZzsnuSfc0rS31SxpUb2DBQZQt5EBO4yjs/3wDwu61eoC9b1FxBhk9BG9jT
         d/OellfhRQT0bTPbu5OEtks1aPnYWKCVQCKFC3svJ3z2g+kYFp52QvYZNqJAg479Fe
         RBq3/815EK49Q==
Date:   Thu, 5 May 2022 09:42:28 +0800
From:   Shawn Guo <shawnguo@kernel.org>
To:     Josua Mayer <josua@solid-run.com>
Cc:     netdev@vger.kernel.org, alvaro.karsz@solid-run.com,
        Russell King <linux@armlinux.org.uk>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>
Subject: Re: [PATCH v3 3/3] ARM: dts: imx6qdl-sr-som: update phy
 configuration for som revision 1.9
Message-ID: <20220505014228.GF14615@dragon>
References: <20220419102709.26432-1-josua@solid-run.com>
 <20220428082848.12191-1-josua@solid-run.com>
 <20220428082848.12191-4-josua@solid-run.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220428082848.12191-4-josua@solid-run.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 28, 2022 at 11:28:48AM +0300, Josua Mayer wrote:
> Since SoM revision 1.9 the PHY has been replaced with an ADIN1300,
> add an entry for it next to the original.
> 
> As Russell King pointed out, additional phy nodes cause warnings like:
> mdio_bus 2188000.ethernet-1: MDIO device at address 1 is missing
> To avoid this the new node has its status set to disabled. U-Boot will
> be modified to enable the appropriate phy node after probing.
> 
> The existing ar8035 nodes have to stay enabled by default to avoid
> breaking existing systems when they update Linux only.
> 
> Co-developed-by: Alvaro Karsz <alvaro.karsz@solid-run.com>
> Signed-off-by: Alvaro Karsz <alvaro.karsz@solid-run.com>
> Signed-off-by: Josua Mayer <josua@solid-run.com>
> ---
> V2 -> V3: new phy node status set disabled
> V1 -> V2: changed dts property name
> 
>  arch/arm/boot/dts/imx6qdl-sr-som.dtsi | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/imx6qdl-sr-som.dtsi b/arch/arm/boot/dts/imx6qdl-sr-som.dtsi
> index f86efd0ccc40..ce543e325cd3 100644
> --- a/arch/arm/boot/dts/imx6qdl-sr-som.dtsi
> +++ b/arch/arm/boot/dts/imx6qdl-sr-som.dtsi
> @@ -83,6 +83,16 @@ ethernet-phy@4 {
>  			qca,clk-out-frequency = <125000000>;
>  			qca,smarteee-tw-us-1g = <24>;
>  		};
> +
> +		/*
> +		 * ADIN1300 (som rev 1.9 or later) is always at address 1. It
> +		 * will be enabled automatically by U-Boot if detected.
> +		 */
> +		ethernet-phy@1 {
> +			reg = <1>;
> +			adi,phy-output-clock = "125mhz-free-running";

Hmm, I failed to find binding doc for this.

Shawn

> +			status = "disabled";
> +		};
>  	};
>  };
>  
> -- 
> 2.34.1
> 
