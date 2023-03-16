Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1C2A6BD950
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 20:35:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229838AbjCPTfD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 15:35:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbjCPTfC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 15:35:02 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0CF2279A0;
        Thu, 16 Mar 2023 12:35:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=H5gbxQ3xd9jnXCka4iAvxyrdV7F1pbgn4IZ9nwpLThc=; b=SSMFuvk+7Tmje9kOGRleZrf2RY
        cbjywDRcDk7Vm07fPXljq9wAhYmBBa0RcCE3NCiayt1FKGV1X3oINhjVc6Ue3EbuHmxthyapprx1P
        JCXXjH6trsVr0oPKQhDr4YKOlk034ScjyRTR3UpQ7ylBqS5TEJKWHi1LPrvHKdBUZxvY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pctN7-007XNJ-6V; Thu, 16 Mar 2023 20:34:45 +0100
Date:   Thu, 16 Mar 2023 20:34:45 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Bartosz Wawrzyniak <bwawrzyn@cisco.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, nicolas.ferre@microchip.com,
        claudiu.beznea@microchip.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, xe-linux-external@cisco.com,
        danielwa@cisco.com, olicht@cisco.com, mawierzb@cisco.com
Subject: Re: [PATCH] net: macb: Set MDIO clock divisor for pclk higher than
 160MHz
Message-ID: <7f3d0f2c-8bf9-41aa-8a7f-79407753df3b@lunn.ch>
References: <20230316100339.1302212-1-bwawrzyn@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230316100339.1302212-1-bwawrzyn@cisco.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 16, 2023 at 10:03:39AM +0000, Bartosz Wawrzyniak wrote:
> Currently macb sets clock divisor for pclk up to 160 MHz.
> Function gem_mdc_clk_div was updated to enable divisor
> for higher values of pclk.
> 
> Signed-off-by: Bartosz Wawrzyniak <bwawrzyn@cisco.com>
> ---
>  drivers/net/ethernet/cadence/macb.h      | 2 ++
>  drivers/net/ethernet/cadence/macb_main.c | 6 +++++-
>  2 files changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/cadence/macb.h b/drivers/net/ethernet/cadence/macb.h
> index 14dfec4db8f9..c1fc91c97cee 100644
> --- a/drivers/net/ethernet/cadence/macb.h
> +++ b/drivers/net/ethernet/cadence/macb.h
> @@ -692,6 +692,8 @@
>  #define GEM_CLK_DIV48				3
>  #define GEM_CLK_DIV64				4
>  #define GEM_CLK_DIV96				5
> +#define GEM_CLK_DIV128				6
> +#define GEM_CLK_DIV224				7

Do these divisors exist for all variants? I'm just wondering why these
are being added now, rather than back in 2011-03-09.

   Andrew
