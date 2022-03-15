Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F41CE4D9FA6
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 17:09:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349920AbiCOQKu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 12:10:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349915AbiCOQKt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 12:10:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3AB242A3A
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 09:09:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5F05CB8175F
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 16:09:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDEBEC340E8;
        Tue, 15 Mar 2022 16:09:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647360574;
        bh=P8D69NfHTrCFQAof2BclMMG9GAELeB8cqoJ0NGQder8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Pxl3gPECNo+QjvB5QZtWfU1gmSYAq1r+Kx5o6j/H27H2GGvA9E4OYrCHTPy0e6RqX
         /zE0mCWlgk8/w+IsTyAWqQc4tN/JcM7Aa85KDkPStLBmEPynToE0rg+VAAh/C+uGQ6
         sqbABBF/gYgJHpW13YAT/p2jmMPVq43m+L/LrCDy9A14SuPMTxD3etuQEtQuw99KLM
         OS6Cy1TFsIPzBl0+0+pthwkDC6jd0TVFCS4/LhPwc7thhD1b8q0VcV7uh16rIFvTCl
         Dg+apFgRnVR+arwwAyw7OBvHNwDgF4IOBIuli314wecpR4B5VzP0Bn6y+j4OPGEqaj
         U8zyeyjb48Q4g==
Date:   Tue, 15 Mar 2022 17:09:29 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Stefan Roese <sr@denx.de>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH] net: phy: marvell: Add errata section 5.1 for Alaska
 PHY
Message-ID: <20220315170929.5f509600@dellmb>
In-Reply-To: <20220315074827.1439941-1-sr@denx.de>
References: <20220315074827.1439941-1-sr@denx.de>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 15 Mar 2022 08:48:27 +0100
Stefan Roese <sr@denx.de> wrote:

> From: Leszek Polak <lpolak@arri.de>
> 
> As per Errata Section 5.1, if EEE is intended to be used, some register
> writes must be done once after every hardware reset. This patch now adds
> the necessary register writes as listed in the Marvell errata.
> 
> Without this fix we experience ethernet problems on some of our boards
> equipped with a new version of this ethernet PHY (different supplier).
> 
> The fix applies to Marvell Alaska 88E1510/88E1518/88E1512/88E1514
> Rev. A0.
> 
> Signed-off-by: Leszek Polak <lpolak@arri.de>
> Signed-off-by: Stefan Roese <sr@denx.de>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Heiner Kallweit <hkallweit1@gmail.com>
> Cc: Russell King <linux@armlinux.org.uk>
> Cc: David S. Miller <davem@davemloft.net>
> ---
>  drivers/net/phy/marvell.c | 42 +++++++++++++++++++++++++++++++++++++++
>  1 file changed, 42 insertions(+)
> 
> diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
> index 2429db614b59..0f4a3ab4a415 100644
> --- a/drivers/net/phy/marvell.c
> +++ b/drivers/net/phy/marvell.c
> @@ -1179,6 +1179,48 @@ static int m88e1510_config_init(struct phy_device *phydev)
>  {
>  	int err;
>  
> +	/* As per Marvell Release Notes - Alaska 88E1510/88E1518/88E1512/
> +	 * 88E1514 Rev A0, Errata Section 5.1:
> +	 * If EEE is intended to be used, the following register writes
> +	 * must be done once after every hardware reset.
> +	 */
> +	err = marvell_set_page(phydev, 0x00FF);
> +	if (err < 0)
> +		return err;
> +	err = phy_write(phydev, 17, 0x214B);
> +	if (err < 0)
> +		return err;
> +	err = phy_write(phydev, 16, 0x2144);
> +	if (err < 0)
> +		return err;
> +	err = phy_write(phydev, 17, 0x0C28);
> +	if (err < 0)
> +		return err;
> +	err = phy_write(phydev, 16, 0x2146);
> +	if (err < 0)
> +		return err;
> +	err = phy_write(phydev, 17, 0xB233);
> +	if (err < 0)
> +		return err;
> +	err = phy_write(phydev, 16, 0x214D);
> +	if (err < 0)
> +		return err;
> +	err = phy_write(phydev, 17, 0xCC0C);
> +	if (err < 0)
> +		return err;
> +	err = phy_write(phydev, 16, 0x2159);
> +	if (err < 0)
> +		return err;

Can you please create a static const struct and then do this in a for
cycle? Somethign like this

static const struct { u16 reg17, reg16; } errata_vals = {
  { 0x214B, 0x2144 }, ...
};

for (i = 0; i < ARRAY_SIZE(errata_vals); ++i) {
  err = phy_write(phydev, 17, errata_vals[i].reg17);
  if (err)
    return err;
  err = phy_write(phydev, 16, errata_vals[i].reg16);
  if (err)
    return err;
}
