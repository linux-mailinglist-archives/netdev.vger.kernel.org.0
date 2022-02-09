Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2399D4AF2FC
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 14:37:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234162AbiBINhe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 08:37:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231882AbiBINh1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 08:37:27 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 964B6C05CBA5
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 05:37:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=mhpJJFUcje+FW7mVcL4tRFBeKKeF80gmVqUxousQVY4=; b=4I/VnKkF7JsiurTmD3BjUbeBCT
        l6ttnaLtS/FFkc4RrmTq7OtSGkGZUdKnDxYuK5kQsTFzkbRsSMTYxg5XfWNcHRWCcHRPwl9KGzmgN
        eGIWCF6Ijt07WaUgKEFUKoOiW2B7CQbYMz/x0iROUOWOZHgo0JGv3NE3n611p2PRlwv8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nHn9o-0057uD-O9; Wed, 09 Feb 2022 14:37:16 +0100
Date:   Wed, 9 Feb 2022 14:37:16 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Holger Brunck <holger.brunck@hitachienergy.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Subject: Re: [v5] dsa: mv88e6xxx: make serdes SGMII/Fiber tx amplitude
 configurable
Message-ID: <YgPDjGDeg6sbUy+X@lunn.ch>
References: <20220209095427.30568-1-holger.brunck@hitachienergy.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220209095427.30568-1-holger.brunck@hitachienergy.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +	if (chip->info->ops->serdes_set_tx_p2p_amplitude) {
> +		dp = dsa_to_port(ds, port);
> +		if (dp)
> +			phy_handle = of_parse_phandle(dp->dn, "phy-handle", 0);
> +
> +		if (phy_handle && !of_property_read_u32(phy_handle,
> +							"tx-p2p-microvolt",
> +							&tx_amp)) {
> +			err = mv88e6352_serdes_set_tx_p2p_amplitude(chip, port,
> +								    tx_amp);
> +			if (err) {
> +				of_node_put(phy_handle);
> +				return err;
> +			}

You could move this test

> +		}
> +		if (phy_handle)
> +			of_node_put(phy_handle);

to here, since you need to put the phy_handle anyway.

   Andrew
