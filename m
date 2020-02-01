Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3010914F88E
	for <lists+netdev@lfdr.de>; Sat,  1 Feb 2020 16:33:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726940AbgBAPdU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Feb 2020 10:33:20 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:32808 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726670AbgBAPdU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 1 Feb 2020 10:33:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=2PYSDAtXiyT57Pssinvpgs84tIcQLviMKfkN82DzBW0=; b=ufGQhn3uaLT+cXZ+p98Hcw23SG
        kcxrAsr1xGiIs+hWt4mT6AO07WLvrCdL1SXy7nX7HKaUBm0hkwgA8fZNeTgQP1Nll/dpVyUO3gIiB
        CwfYGXuW1wVvliGSAF5/14LVJ3Z8kuC4Tjd3a+3VMw74RkcDtIksw3Sl+n8ZcQ35Kv4A=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1ixuln-0003VR-NA; Sat, 01 Feb 2020 16:33:15 +0100
Date:   Sat, 1 Feb 2020 16:33:15 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jeremy Linton <jeremy.linton@arm.com>
Cc:     netdev@vger.kernel.org, opendmb@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, bcm-kernel-feedback-list@broadcom.com,
        linux-kernel@vger.kernel.org, wahrenst@gmx.net,
        hkallweit1@gmail.com
Subject: Re: [PATCH 4/6] net: bcmgenet: Initial bcmgenet ACPI support
Message-ID: <20200201153315.GJ9639@lunn.ch>
References: <20200201074625.8698-1-jeremy.linton@arm.com>
 <20200201074625.8698-5-jeremy.linton@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200201074625.8698-5-jeremy.linton@arm.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> @@ -3595,7 +3597,7 @@ static int bcmgenet_probe(struct platform_device *pdev)
>  	/* If this is an internal GPHY, power it on now, before UniMAC is
>  	 * brought out of reset as absolutely no UniMAC activity is allowed
>  	 */
> -	if (dn && !of_property_read_string(dn, "phy-mode", &phy_mode_str) &&
> +	if (!device_property_read_string(&pdev->dev, "phy-mode", &phy_mode_str) &&
>  	    !strcasecmp(phy_mode_str, "internal"))
>  		bcmgenet_power_up(priv, GENET_POWER_PASSIVE);

The code you are modifying appears to be old and out of date. For a
long time there has been a helper, of_get_phy_mode(). You should look
at fwnode_get_phy_mode().

   Andrew
