Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07670677E5C
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 15:49:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231856AbjAWOtU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 09:49:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229791AbjAWOtT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 09:49:19 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AD149029;
        Mon, 23 Jan 2023 06:49:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=ia7/ZP4bXCGrUTRpWB18mfOkIKozBHuhD3EIMORkx0k=; b=O8/XFVt31/zl9ZjV9ewgaMejPj
        tJXOTjslf7VsJmQb1vGgqrFQ0fDtlRb7SnsYIFgwyyWbKGWTzLTIr8iaUBMjaxcnEAjAKrW5A/+Ef
        YnBBvYGofuKK68Ab9veSREz/D4SmLwzcqTsFGTrEFyXDzk/Uu7MoYtyHyN+2asjHtDNU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pJy8F-002urF-MU; Mon, 23 Jan 2023 15:49:11 +0100
Date:   Mon, 23 Jan 2023 15:49:11 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jerome Brunet <jbrunet@baylibre.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        linux-amlogic@lists.infradead.org,
        Kevin Hilman <khilman@baylibre.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        linux-kernel@vger.kernel.org,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Qi Duan <qi.duan@amlogic.com>
Subject: Re: [PATCH net] net: mdio-mux-meson-g12a: force internal PHY off on
 mux switch
Message-ID: <Y86eZwWbhjNwrd76@lunn.ch>
References: <20230123135037.195157-1-jbrunet@baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230123135037.195157-1-jbrunet@baylibre.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 23, 2023 at 02:50:37PM +0100, Jerome Brunet wrote:
> Force the internal PHY off then on when switching to the internal path.
> This fixes problems where the PHY ID is not properly set.
> 
> Fixes: 7090425104db ("net: phy: add amlogic g12a mdio mux support")
> Suggested-by: Qi Duan <qi.duan@amlogic.com>
> Co-developed-by: Heiner Kallweit <hkallweit1@gmail.com>
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
> ---
> 
> The initial discussion about this change can be found here:
> https://lore.kernel.org/all/1j4jslwen5.fsf@starbuckisacylon.baylibre.com/
> 
>  drivers/net/mdio/mdio-mux-meson-g12a.c | 23 ++++++++++++++++-------
>  1 file changed, 16 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/net/mdio/mdio-mux-meson-g12a.c b/drivers/net/mdio/mdio-mux-meson-g12a.c
> index 4a2e94faf57e..da61f00a6666 100644
> --- a/drivers/net/mdio/mdio-mux-meson-g12a.c
> +++ b/drivers/net/mdio/mdio-mux-meson-g12a.c
> @@ -4,6 +4,7 @@
>   */
>  
>  #include <linux/bitfield.h>
> +#include <linux/delay.h>
>  #include <linux/clk.h>
>  #include <linux/clk-provider.h>
>  #include <linux/device.h>
> @@ -151,6 +152,7 @@ static const struct clk_ops g12a_ephy_pll_ops = {
>  static int g12a_enable_internal_mdio(struct g12a_mdio_mux *priv)
>  {
>  	int ret;
> +	u32 value;

Reverse Christmas tree please. Longest first, shortest last.

	Andrew
