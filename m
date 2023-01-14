Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 610DF66A770
	for <lists+netdev@lfdr.de>; Sat, 14 Jan 2023 01:20:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230144AbjANAUn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 19:20:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229797AbjANAUm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 19:20:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9DCD26F1;
        Fri, 13 Jan 2023 16:20:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1402362384;
        Sat, 14 Jan 2023 00:20:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 616B1C433D2;
        Sat, 14 Jan 2023 00:20:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673655638;
        bh=jB/n2oqoPZWrRVR1g4+7Zx4XohoKCQJBT0cq+l8bSDo=;
        h=In-Reply-To:References:Subject:From:Cc:To:Date:From;
        b=GUfA6jFoM/MJGbIJ5k+tLoWy/OgmbxwJ2hbtq9B0ykvd+RGR4biMoVJNVswg4T9hz
         MdXE9Oz6wU4fK6/gKbAHb/kvmTayvq59oMkY61T6VIRQFUp5/xMa84vAUdn6IYpQ+N
         nE9T6so/xcG2RXUaxwCVNZHk8Ct3SzOoMV21LnZp/k+U9d2vN8aOJf+NkmvAKsGssC
         w+v20RbY/6myV9yyhVY810+Cr+PsqGMN4dwaSq3y1Dr3NuOnTnuF49qH/lu+PpU+iQ
         VnoEFizNDLVE6ym7H24C+VAzcX7afIpUXGPQYAYmP95+5CmqiJ02GrCKsi2Yt9Gyeb
         v+n8lVKn6Vr3A==
Message-ID: <66131cea80d3a8a33e559f84fb808c6b.sboyd@kernel.org>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20230113142718.3038265-5-o.rempel@pengutronix.de>
References: <20230113142718.3038265-1-o.rempel@pengutronix.de> <20230113142718.3038265-5-o.rempel@pengutronix.de>
Subject: Re: [PATCH v1 04/20] ARM: imx6q: use of_clk_get_by_name() instead of_clk_get() to get ptp clock
From:   Stephen Boyd <sboyd@kernel.org>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Lee Jones <lee@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-clk@vger.kernel.org, netdev@vger.kernel.org
To:     Abel Vesa <abelvesa@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Michael Turquette <mturquette@baylibre.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>
Date:   Fri, 13 Jan 2023 16:15:53 -0800
User-Agent: alot/0.10
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Quoting Oleksij Rempel (2023-01-13 06:27:02)
> It is not clear from the code what clock should be taken. So, make sure it
> is readable and no other clock will be taken by accident.
>=20
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---
>  arch/arm/mach-imx/mach-imx6q.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/arch/arm/mach-imx/mach-imx6q.c b/arch/arm/mach-imx/mach-imx6=
q.c
> index 7f6200925752..4885d3dfcf7f 100644
> --- a/arch/arm/mach-imx/mach-imx6q.c
> +++ b/arch/arm/mach-imx/mach-imx6q.c
> @@ -98,7 +98,7 @@ static void __init imx6q_1588_init(void)
>         if (!IS_ERR(fec_enet_ref))
>                 goto put_node;
> =20
> -       ptp_clk =3D of_clk_get(np, 2);
> +       ptp_clk =3D of_clk_get_by_name(np, "ptp");

The 'clocks' property in DTS should not be reordered. Order matters in
the binding. This patch makes the code do a string comparison (or a
few?) in the name of readability. Perhaps make a #define for '2' like
CLOCKS_PTP_INDEX, or just don't change it because it ain't broke.
