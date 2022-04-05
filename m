Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34EC14F462F
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 01:02:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241627AbiDEUAB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 16:00:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1451940AbiDEPyK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 11:54:10 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0BE912E77D
        for <netdev@vger.kernel.org>; Tue,  5 Apr 2022 07:49:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=+UXAjBtR+par1eNANQQR44eVeNMSFyy5Nd35Ufev2VE=; b=GTebAwQYzuCaaXTqLz1BRsgxkU
        0BVavZs9MPIUEfV2YztTt7ranS/grTURUI/TdJynEABmNF6Dx7XM/8mwpSKLZCNQJVc6lSXdY2EBW
        EZi7YVCGH3NCx9G+M8fNK7zCBjdsLwvzzNcTbEK4mV7BGxCn6dr8wyxRgVbpHTomCcfo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nbkUd-00EG96-Tq; Tue, 05 Apr 2022 16:49:15 +0200
Date:   Tue, 5 Apr 2022 16:49:15 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Conor.Dooley@microchip.com
Cc:     palmer@rivosinc.com, apatel@ventanamicro.com,
        netdev@vger.kernel.org, Nicolas.Ferre@microchip.com,
        Claudiu.Beznea@microchip.com, linux@armlinux.org.uk,
        hkallweit1@gmail.com, linux-riscv@lists.infradead.org
Subject: Re: riscv defconfig CONFIG_PM/macb/generic PHY regression in
 v5.18-rc1
Message-ID: <YkxW68j5N4hVgY18@lunn.ch>
References: <9f4b057d-1985-5fd3-65c0-f944161c7792@microchip.com>
 <YkxDOWfULPFo7xFi@lunn.ch>
 <98b571fb-993e-9fe1-1cf9-dc09651feb0b@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <98b571fb-993e-9fe1-1cf9-dc09651feb0b@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 05, 2022 at 02:18:17PM +0000, Conor.Dooley@microchip.com wrote:
> 
> 
> On 05/04/2022 13:25, Andrew Lunn wrote:
> > On Tue, Apr 05, 2022 at 01:05:12PM +0000, Conor.Dooley@microchip.com wrote:
> >> [ 2.818894] macb 20112000.ethernet eth0: PHY [20112000.ethernet-ffffffff:09] driver [Generic PHY] (irq=POLL)
> > 
> > Hi Conor
> > 
> > In general, it is better to use the specific PHY driver for the PHY
> > then rely on the generic PHY driver. I think the Icicle Kit has a
> > VSC8662? So i would suggest you enable the Vitesse PHYs.
> 
> Hi Andrew, thanks for the quick reply.
> It does indeed have a Vitesse VSC8662, but the link never seems to
> come up for me [1] so I have been using Generic PHY. I'll try look
> at why that is. Either way would like to know what's gone wrong in
> the Generic PHY case since that's what's available in the riscv
> defconfig.

Hi Conor

Generic PHY is purely best effort fall back for when there is nothing
better. It might work, it might not, depending on the PHY. If it is a
simple PHY which only implements the registers defined in 802.3 clause
22, and not much more, it has a good chance of working. Otherwise, you
really should be using the specific driver.

Don't worry too much about the defconfig, nobody actually uses
it. Distros have their own which turn on most things. So a real system
probably does have the correct PHY driver.

	 Andrew
