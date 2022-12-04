Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64AF1641A71
	for <lists+netdev@lfdr.de>; Sun,  4 Dec 2022 03:37:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229892AbiLDChc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Dec 2022 21:37:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiLDChb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Dec 2022 21:37:31 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3971B1B9DE;
        Sat,  3 Dec 2022 18:37:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
        Message-ID:Sender:Reply-To:Content-ID:Content-Description;
        bh=SOme4rNJC+GgoyaJJOvsD0k7gpqezBS3tzWfsFGOMpg=; b=sSg7WNDnK6gKTpes03xcQuvW+7
        lx+nsJMCmWDQk6mA/gnhMvPuN8CLy0qMqXZl3pOEfYvrC67HI9IvxGB6auHW4cSUJUzgI8SO1iVBj
        pzLor/7Vw/odSg22R10UoR5masFsWH5ilMHqVSLozVpp/EIWboEmFySepxEJr6CdS55CwSDSPoubj
        zS7X1xtRq3a0vmuuWcJDseVxCHzkecd02JF2367fZSX/odb6sSpLZuAkgpiZbfKj5SDoyLCQyJPbT
        wXg+JrhBSJG2wyKbVNyqaI5Em1VXyP7gfTHIvQTpOh9QsI3jSLY2VIzFyuUqTSIh5m/ojSkmoUsiU
        c4pD7ULg==;
Received: from [2601:1c2:d80:3110::a2e7]
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1p1esT-0069XU-U4; Sun, 04 Dec 2022 02:37:14 +0000
Message-ID: <c1fd8c0b-76d9-a15c-a3e9-3bd89a6dfabc@infradead.org>
Date:   Sat, 3 Dec 2022 18:37:13 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH net-next 1/4] net/ethtool: Add netlink interface for the
 PLCA RS
Content-Language: en-US
To:     Piergiorgio Beruto <piergiorgio.beruto@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Oleksij Rempel <o.rempel@pengutronix.de>
References: <cover.1670119328.git.piergiorgio.beruto@gmail.com>
 <7209a794f6bee74fbfd76178000fd548d95c52ad.1670119328.git.piergiorgio.beruto@gmail.com>
From:   Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <7209a794f6bee74fbfd76178000fd548d95c52ad.1670119328.git.piergiorgio.beruto@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi--

On 12/3/22 18:30, Piergiorgio Beruto wrote:
> Add support for configuring the PLCA Reconciliation Sublayer on
> multi-drop PHYs that support IEEE802.3cg-2019 Clause 148 (e.g.,
> 10BASE-T1S). This patch adds the appropriate netlink interface
> to ethtool.
> 
> Signed-off-by: Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
> ---


> diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
> index e5b6cb1a77f9..99e3497b6aa1 100644
> --- a/drivers/net/phy/phy.c
> +++ b/drivers/net/phy/phy.c
> @@ -543,6 +543,40 @@ int phy_ethtool_get_stats(struct phy_device *phydev,
>  }
>  EXPORT_SYMBOL(phy_ethtool_get_stats);
>  

What is the meaning of all these empty kernel-doc comment blocks?
Why are they here?
Please delete them.

> +/**
> + *
> + */
> +int phy_ethtool_get_plca_cfg(struct phy_device *dev,
> +			     struct phy_plca_cfg *plca_cfg)
> +{
> +	// TODO
> +	return 0;
> +}
> +EXPORT_SYMBOL(phy_ethtool_get_plca_cfg);
> +
> +/**
> + *
> + */
> +int phy_ethtool_set_plca_cfg(struct phy_device *dev,
> +			     struct netlink_ext_ack *extack,
> +			     const struct phy_plca_cfg *plca_cfg)
> +{
> +	// TODO
> +	return 0;
> +}
> +EXPORT_SYMBOL(phy_ethtool_set_plca_cfg);
> +
> +/**
> + *
> + */
> +int phy_ethtool_get_plca_status(struct phy_device *dev,
> +				struct phy_plca_status *plca_st)
> +{
> +	// TODO
> +	return 0;
> +}
> +EXPORT_SYMBOL(phy_ethtool_get_plca_status);

Thanks.
-- 
~Randy
