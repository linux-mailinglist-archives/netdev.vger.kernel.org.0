Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A2056EF5A2
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 15:40:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240627AbjDZNkh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 09:40:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240734AbjDZNkf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 09:40:35 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 179403A8C;
        Wed, 26 Apr 2023 06:40:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=fuaE+XKKlEFErPE+8vni2L7abu3/SdWT0YIm8v/cR/E=; b=R9aJCJAj86RzbvE9pjsMecQf63
        8iVudwJtxJsXtH62qpYE1dWC4xDEodX4yIVDXwIWteToCpDqn4IYQeYrfs242yU9RrPNcQSq0SmbS
        lYLvCKR6UJNgCifJjsyR5JrmhShE6Ryo0mw7ipFGX/IurFzZXZ/a9drhbJ9OaskE8UsE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1prfNG-00BHAd-LT; Wed, 26 Apr 2023 15:39:58 +0200
Date:   Wed, 26 Apr 2023 15:39:58 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Harini Katakam <harini.katakam@amd.com>
Cc:     robh+dt@kernel.org, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, vladimir.oltean@nxp.com,
        wsa+renesas@sang-engineering.com,
        krzysztof.kozlowski+dt@linaro.org, simon.horman@corigine.com,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, harinikatakamlinux@gmail.com,
        michal.simek@amd.com, radhey.shyam.pandey@amd.com
Subject: Re: [PATCH net-next v2 1/3] phy: mscc: Use PHY_ID_MATCH_VENDOR to
 minimize PHY ID table
Message-ID: <c120d1bc-4b67-4280-a843-d269fdb27e20@lunn.ch>
References: <20230426104313.28950-1-harini.katakam@amd.com>
 <20230426104313.28950-2-harini.katakam@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230426104313.28950-2-harini.katakam@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 26, 2023 at 04:13:11PM +0530, Harini Katakam wrote:
> All the PHY devices variants specified have the same mask and
> hence can be simplified to one vendor look up for 0xfffffff0.
> Any individual config can be identified by PHY_ID_MATCH_EXACT
> in the respective structure.
> 
> Signed-off-by: Harini Katakam <harini.katakam@amd.com>

net-next is closed at the moment, so you will need to report in two
weeks time.

> diff --git a/drivers/net/phy/mscc/mscc_main.c b/drivers/net/phy/mscc/mscc_main.c
> index 62bf99e45af1..75d9582e5784 100644
> --- a/drivers/net/phy/mscc/mscc_main.c
> +++ b/drivers/net/phy/mscc/mscc_main.c
> @@ -2656,19 +2656,7 @@ static struct phy_driver vsc85xx_driver[] = {
>  module_phy_driver(vsc85xx_driver);
>  
>  static struct mdio_device_id __maybe_unused vsc85xx_tbl[] = {
> -	{ PHY_ID_VSC8504, 0xfffffff0, },
> -	{ PHY_ID_VSC8514, 0xfffffff0, },
> -	{ PHY_ID_VSC8530, 0xfffffff0, },
> -	{ PHY_ID_VSC8531, 0xfffffff0, },
> -	{ PHY_ID_VSC8540, 0xfffffff0, },
> -	{ PHY_ID_VSC8541, 0xfffffff0, },
> -	{ PHY_ID_VSC8552, 0xfffffff0, },
> -	{ PHY_ID_VSC856X, 0xfffffff0, },
> -	{ PHY_ID_VSC8572, 0xfffffff0, },
> -	{ PHY_ID_VSC8574, 0xfffffff0, },
> -	{ PHY_ID_VSC8575, 0xfffffff0, },
> -	{ PHY_ID_VSC8582, 0xfffffff0, },
> -	{ PHY_ID_VSC8584, 0xfffffff0, },
> +	{ PHY_ID_MATCH_VENDOR(0xfffffff0) },

The vendor ID is 0xfffffff0 ???

    Andrew
