Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70F6A2B4835
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 16:07:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731381AbgKPPCi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 10:02:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731370AbgKPPCe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 10:02:34 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63C75C061A47
        for <netdev@vger.kernel.org>; Mon, 16 Nov 2020 07:02:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=uNt4M6blJde8bHOvi0a0yCMpEmKGhZIOtOO8+7FVTWY=; b=IfCTlik97c9yFX+9NdQZyHXA5
        nvr5kPUpRGrBYTpeNHU05KfrR12d5PFGFUM4Ip5VeQp4TrD/osoxClj5FpDza85RC1adFCUvulDyL
        hrQyYP+TfYiBo2/Ker2IdDpjumuttlLFfxGNKCwbRQk0ohm9fgV3l4aAGsf8FgtpblN9lq317UXqt
        gG7uKgogq8slQAZNr8SlCC6ZF8SN9Z/RzhAsHRvT1X5KzJBUmzcv9lyJEZ99emck8TjVsgab8ltoe
        n6H0MtwLS8MuN/CnVl5CnZnPf9zKvgpx92xcoLWl7SMXgGO2OP3Bq4kvmb0H23sXbgQn+4lhh8sB2
        kF/QBhwAQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:60446)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1keg1J-0007Q6-FI; Mon, 16 Nov 2020 15:02:17 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1keg1I-0007Y9-HR; Mon, 16 Nov 2020 15:02:16 +0000
Date:   Mon, 16 Nov 2020 15:02:16 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH net-next v3 4/5] net: phy: marvell10g: change MACTYPE if
 underlying MAC does not support it
Message-ID: <20201116150216.GK1551@shell.armlinux.org.uk>
References: <20201116111511.5061-1-kabel@kernel.org>
 <20201116111511.5061-5-kabel@kernel.org>
 <20201116154552.5a1e4b02@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201116154552.5a1e4b02@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 16, 2020 at 03:45:52PM +0100, Marek Behún wrote:
> Hi Russell,
> 
> previously you replied on this patch:
> 
> > This'll do as a stop-gap until we have a better way to determine which
> > MACTYPE mode we should be using.
> 
> Can we consider this as Acked-by ?

Not really.

The selection of MACTYPE isn't as simple as you make out in this patch.
If we know that the MAC supports 2500BASE-X and/or SGMII, that means
MACTYPES 0, 3, 4, 5 are possible to fit that, all likely will work if
we restrict the PHY to either 2.5G only or 1G..10M only. However, it
only becomes important if the faster speeds are supported at the MAC.

I'm afraid I haven't put much thought into how to solve it, and as I'm
totally demotivated at the moment, that's unlikely to change.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
