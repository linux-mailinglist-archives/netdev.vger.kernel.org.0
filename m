Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B37E7509FA0
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 14:27:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384543AbiDUMaO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 08:30:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384630AbiDUMaK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 08:30:10 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5E7531372
        for <netdev@vger.kernel.org>; Thu, 21 Apr 2022 05:27:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=igRtZHcpgynSUjzrTXxfuwObmrQFk9SFfrkdbrtI60s=; b=oyVLLdFx+HV4UdDKWQ98XJI8TR
        TNJVD9Eib/so3B8jXoU02H4RvkkrmYidMvVuTgWLmWI+DlNLg6tvrs+D0poQJf8jdHtw0QFWFUCsh
        iSBj8jgluAlQpbV3KlzKo2dRtWktD4TIpNLXpxNkJwX1nVRk88MywYaKF7yxVw2xkAzk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nhVu0-00Gncv-UR; Thu, 21 Apr 2022 14:27:16 +0200
Date:   Thu, 21 Apr 2022 14:27:16 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Josua Mayer <josua@solid-run.com>
Cc:     netdev@vger.kernel.org, alvaro.karsz@solid-run.com,
        Russell King <linux@armlinux.org.uk>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>
Subject: Re: [PATCH v2 3/3] ARM: dts: imx6qdl-sr-som: update phy
 configuration for som revision 1.9
Message-ID: <YmFNpLLLDzBNPqGf@lunn.ch>
References: <20220410104626.11517-1-josua@solid-run.com>
 <20220419102709.26432-1-josua@solid-run.com>
 <20220419102709.26432-4-josua@solid-run.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220419102709.26432-4-josua@solid-run.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 19, 2022 at 01:27:09PM +0300, Josua Mayer wrote:
> Since SoM revision 1.9 the PHY has been replaced with an ADIN1300,
> add an entry for it next to the original.
> 
> Co-developed-by: Alvaro Karsz <alvaro.karsz@solid-run.com>
> Signed-off-by: Alvaro Karsz <alvaro.karsz@solid-run.com>
> Signed-off-by: Josua Mayer <josua@solid-run.com>
> ---
> V1 -> V2: changed dts property name
> 
>  arch/arm/boot/dts/imx6qdl-sr-som.dtsi | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/imx6qdl-sr-som.dtsi b/arch/arm/boot/dts/imx6qdl-sr-som.dtsi
> index f86efd0ccc40..d46182095d79 100644
> --- a/arch/arm/boot/dts/imx6qdl-sr-som.dtsi
> +++ b/arch/arm/boot/dts/imx6qdl-sr-som.dtsi
> @@ -83,6 +83,12 @@ ethernet-phy@4 {
>  			qca,clk-out-frequency = <125000000>;
>  			qca,smarteee-tw-us-1g = <24>;
>  		};
> +
> +		/* ADIN1300 (som rev 1.9 or later) */
> +		ethernet-phy@1 {
> +			reg = <1>;
> +			adi,phy-output-clock = "125mhz-free-running";
> +		};

There is currently the comment:

                 * The PHY can appear at either address 0 or 4 due to the
                 * configuration (LED) pin not being pulled sufficiently.
                 */

It would be good to add another comment about this PHY at address 1.

   Andrew
