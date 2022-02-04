Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB2D14A9226
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 02:58:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345616AbiBDB6z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 20:58:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229775AbiBDB6z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 20:58:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0814BC061714
        for <netdev@vger.kernel.org>; Thu,  3 Feb 2022 17:58:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7A5F2B8362B
        for <netdev@vger.kernel.org>; Fri,  4 Feb 2022 01:58:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3C8EC340E8;
        Fri,  4 Feb 2022 01:58:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643939932;
        bh=H2xb367KslN75m0tIGi3PTvns/zVSpShBovSNJRWk6s=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FHoc3lIQVzFRPw5K6XsSecdpPOzM+AQ3Db2vydlYEmxfFXX9Wg2bgh3pt4uSF0HqA
         N/ovKcQlNRSimq5Os7Oay9SGDD+VeCtWqbP8iiMOUDy4xT7J6MRk72PeN06sDSCMoo
         FPwDKXg7rbSl/I5IT3Q0okLCpQEQwRbQrWmKQn+m/eFwjJ64LHzDLzXfmTJKHkGynP
         kokGTV5BywpCRWoA78wxTbOkylxs7EPIi9i5sm/ajcWEU9PXn/bJNlv0tUXWUD+1M/
         qWUtoxQA+yz3hj/DNjVSDxV3n6vyJxESCQlQGdvCJETqoEQAZi6NXQtLP6qwiwcSBL
         7vTZ7pvkx4Bbg==
Date:   Thu, 3 Feb 2022 17:58:50 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>
Cc:     netdev@vger.kernel.org, linus.walleij@linaro.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        alsi@bang-olufsen.dk, arinc.unal@arinc9.com,
        frank-w@public-files.de, davem@davemloft.net
Subject: Re: [PATCH net-next v6 05/13] net: dsa: realtek: convert subdrivers
 into modules
Message-ID: <20220203175850.5d0a8cf4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220128060509.13800-6-luizluca@gmail.com>
References: <20220128060509.13800-1-luizluca@gmail.com>
        <20220128060509.13800-6-luizluca@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 28 Jan 2022 03:05:01 -0300 Luiz Angelo Daros de Luca wrote:
> diff --git a/drivers/net/dsa/realtek/Kconfig b/drivers/net/dsa/realtek/Kconfig
> index 1c62212fb0ec..cd1aa95b7bf0 100644
> --- a/drivers/net/dsa/realtek/Kconfig
> +++ b/drivers/net/dsa/realtek/Kconfig
> @@ -2,8 +2,6 @@
>  menuconfig NET_DSA_REALTEK
>  	tristate "Realtek Ethernet switch family support"
>  	depends on NET_DSA
> -	select NET_DSA_TAG_RTL4_A
> -	select NET_DSA_TAG_RTL8_4
>  	select FIXED_PHY
>  	select IRQ_DOMAIN
>  	select REALTEK_PHY
> @@ -18,3 +16,21 @@ config NET_DSA_REALTEK_SMI
>  	help
>  	  Select to enable support for registering switches connected
>  	  through SMI.
> +
> +config NET_DSA_REALTEK_RTL8365MB
> +	tristate "Realtek RTL8365MB switch subdriver"
> +	default y
> +	depends on NET_DSA_REALTEK
> +	depends on NET_DSA_REALTEK_SMI
> +	select NET_DSA_TAG_RTL8_4
> +	help
> +	  Select to enable support for Realtek RTL8365MB
> +
> +config NET_DSA_REALTEK_RTL8366RB
> +	tristate "Realtek RTL8366RB switch subdriver"
> +	default y
> +	depends on NET_DSA_REALTEK
> +	depends on NET_DSA_REALTEK_SMI
> +	select NET_DSA_TAG_RTL4_A
> +	help
> +	  Select to enable support for Realtek RTL8366RB

Why did all these new config options grow a 'default y'? Our usual
policy is to default drivers to disabled.
