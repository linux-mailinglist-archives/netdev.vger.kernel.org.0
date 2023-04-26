Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54A4C6EFCFF
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 00:02:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239840AbjDZWCZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 18:02:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239750AbjDZWCX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 18:02:23 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9246188
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 15:02:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=s5OPqDMrJbPkySbXTukJDnlZGyeWsXYU9E0rr9q/9Wk=; b=YdfSPu8ai/LBIeq2wZAFC4rqfI
        uEwgfBBnBG72KsEKkG4kSv2oBpkjv29j6g9XZz7ckeMSLhAYDxFnniYVipKbyThdQ1XB++Yox+9yG
        19St7KHoOjsRM2KGDMenjVDwX6z+R6pSCVV61wezGkLGyUba5C/ElzDgdAH4H3eROPDo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1prnDQ-00BJ8D-AS; Thu, 27 Apr 2023 00:02:20 +0200
Date:   Thu, 27 Apr 2023 00:02:20 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Parthiban Veerasooran <Parthiban.Veerasooran@microchip.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        jan.huber@microchip.com, thorsten.kummermehr@microchip.com,
        ramon.nordin.rodriguez@ferroamp.se
Subject: Re: [PATCH net-next 2/2] net: phy: microchip_t1s: add support for
 Microchip LAN865x Rev.B0 PHYs
Message-ID: <c831ce86-37e4-420e-bea0-73fdfdaf7913@lunn.ch>
References: <20230426114655.93672-1-Parthiban.Veerasooran@microchip.com>
 <20230426114655.93672-3-Parthiban.Veerasooran@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230426114655.93672-3-Parthiban.Veerasooran@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +	/* disable all the interrupts
> +	 */
> +	ret = phy_write_mmd(phydev, MDIO_MMD_VEND2, LAN86XX_REG_IRQ_1_CTL, 0xFFFF);
> +	if (ret)
> +		return ret;
> +	return phy_write_mmd(phydev, MDIO_MMD_VEND2, LAN86XX_REG_IRQ_2_CTL, 0xFFFF);

This is also something which could be in a patch of its own, with an
explanation in the commit message. You said the device will generate
an interrupt after reset whatever. So it would be good to document
this odd behaviour. Also, should you actually clear the pending
interrupt, as well as disable interrupts? I assume there is an
interrupt status register? It would typically be clear on read, or
write 1 to clear a specific interrupt?

	Andrew
