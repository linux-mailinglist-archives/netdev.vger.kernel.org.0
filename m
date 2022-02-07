Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AA394ACCDF
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 02:06:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240890AbiBHBFx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 20:05:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236967AbiBGX25 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 18:28:57 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 296E3C061355
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 15:28:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=pWM4FZqrea3JHZK282FxRrr1rNb1E0rzMCXnPEljQ+E=; b=GwnPFKiIzxYv5hr0DS9H36vd0Y
        6Wnq8H3lB9utun3HWM/sXVECVzHyVwU9+uJiJ+6IqZhYO2uq2YuPf83MGWdxII0vlL4hI+M7m9Wf8
        wMAyEaexrRzSrosoLu3Jjf5AiuM5n8WAs9YqTr6CXD17C/zuPv4gwJ1n7WHhOwM60CHw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nHDRF-004iac-HJ; Tue, 08 Feb 2022 00:28:53 +0100
Date:   Tue, 8 Feb 2022 00:28:53 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Enguerrand de Ribaucourt 
        <enguerrand.de-ribaucourt@savoirfairelinux.com>
Cc:     netdev@vger.kernel.org, hkallweit1@gmail.com, linux@armlinux.org.uk
Subject: Re: [PATCH v2 1/2] net: phy: micrel: add Microchip KSZ 9897 Switch
 PHY support
Message-ID: <YgGrNWeq6A7Rw3zG@lunn.ch>
References: <20220207174532.362781-1-enguerrand.de-ribaucourt@savoirfairelinux.com>
 <20220207174532.362781-2-enguerrand.de-ribaucourt@savoirfairelinux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220207174532.362781-2-enguerrand.de-ribaucourt@savoirfairelinux.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +	/* KSZ8081A3/KSZ8091R1 PHY and KSZ9897 switch share the same
> +	 * exact PHY ID. However, they can be told apart by the default value
> +	 * of the LED mode. It is 0 for the PHY, and 1 for the switch.
> +	 */
> +	ret &= (MICREL_KSZ8081_CTRL2_LED_MODE0 | MICREL_KSZ8081_CTRL2_LED_MODE1);
> +	if (!ksz_8081)
> +		return ret;
> +	else
> +		return !ret;

What exactly does MICREL_KSZ8081_CTRL2_LED_MODE0 and
MICREL_KSZ8081_CTRL2_LED_MODE1 mean? We have to be careful in that
there could be use cases which actually wants to configure the
LEDs. There have been recent discussions for two other PHYs recently
where the bootloader is configuring the LEDs, to something other than
their default value.

      Andrew
