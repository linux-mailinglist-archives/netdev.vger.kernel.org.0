Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1843156068
	for <lists+netdev@lfdr.de>; Fri,  7 Feb 2020 22:02:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727117AbgBGVCP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Feb 2020 16:02:15 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:38600 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727012AbgBGVCP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 Feb 2020 16:02:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=kCPIBb7PRdtHNTGbHTeczBnKti7EH8CesgLtB7yonEM=; b=SPcJOp49GCMyk+QIC1kQEa9LB2
        xKp2Vy3Dayy9aWD9J01ng8CWjZ+jobdf6MqFo+/t1qNzS+ARIssCAsKhiUPC23Pf6M33EB55wbPax
        gZ5WeXHNXrwCZMXAtI05S1Vmbn7cY63rB0F7GaPASn4naCFieLmE9jl4y/Ur0iXBj7Fo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1j0AlN-0005Q5-M8; Fri, 07 Feb 2020 22:02:09 +0100
Date:   Fri, 7 Feb 2020 22:02:09 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Tim Harvey <tharvey@gateworks.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        rrichter@marvell.com, linux-arm-kernel@lists.infradead.org,
        davem@davemloft.net, sgoutham@marvell.com
Subject: Re: [PATCH] net: thunderx: use proper interface type for RGMII
Message-ID: <20200207210209.GD19213@lunn.ch>
References: <1581108026-28170-1-git-send-email-tharvey@gateworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1581108026-28170-1-git-send-email-tharvey@gateworks.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 07, 2020 at 12:40:26PM -0800, Tim Harvey wrote:
> The configuration of the OCTEONTX XCV_DLL_CTL register via
> xcv_init_hw() is such that the RGMII RX delay is bypassed
> leaving the RGMII TX delay enabled in the MAC:
> 
> 	/* Configure DLL - enable or bypass
> 	 * TX no bypass, RX bypass
> 	 */
> 	cfg = readq_relaxed(xcv->reg_base + XCV_DLL_CTL);
> 	cfg &= ~0xFF03;
> 	cfg |= CLKRX_BYP;
> 	writeq_relaxed(cfg, xcv->reg_base + XCV_DLL_CTL);
> 
> This would coorespond to a interface type of PHY_INTERFACE_MODE_RGMII_RXID
> and not PHY_INTERFACE_MODE_RGMII.
> 
> Fixing this allows RGMII PHY drivers to do the right thing (enable
> RX delay in the PHY) instead of erroneously enabling both delays in the
> PHY.

Hi Tim

This seems correct. But how has it worked in the past? Does this
suggest there is PHY driver out there which is doing the wrong thing
when passed PHY_INTERFACE_MODE_RGMII?

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
