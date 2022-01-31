Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 618214A518F
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 22:38:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381128AbiAaViS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 16:38:18 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:36120 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1376564AbiAaViJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 31 Jan 2022 16:38:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=J2Ock0kJwzCfmO0Tr8ruQr0Ddk79PqA0RN/4O5SfH40=; b=zGQkENbdHVdBVV2yYQ2yUW5ylU
        TS8oxl46z6gFJpQ19lqjHxVW/RKHBn4Ep1KPoV453fMLySk4p8MsXkvatQlff7AYvza+TLqsiLfIo
        OoYC2G4RLPKZC5Ak5+bh7rL9EREK9EzDPRM5RPotoJyvCGZ2gnWIpwrR3THw2/hvNMsw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nEeNA-003fVl-M5; Mon, 31 Jan 2022 22:38:04 +0100
Date:   Mon, 31 Jan 2022 22:38:04 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net-next 4/5] net: lan743x: Add support of selection
 between SGMII and GMII Interface
Message-ID: <YfhWvIs31WKAEiq7@lunn.ch>
References: <20220127173055.308918-1-Raju.Lakkaraju@microchip.com>
 <20220127173055.308918-5-Raju.Lakkaraju@microchip.com>
 <YfMX1ob3+1RT+d8/@lunn.ch>
 <20220131180946.sqxcbnhu54ajc5am@microsemi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220131180946.sqxcbnhu54ajc5am@microsemi.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Accepted. I will change.
> 
> > > +             if (chip_ver & STRAP_READ_SGMII_EN_) {
> > > +                     sgmii_ctl = lan743x_csr_read(adapter, SGMII_CTL);
> > > +                     sgmii_ctl |= SGMII_CTL_SGMII_ENABLE_;
> > > +                     sgmii_ctl &= ~SGMII_CTL_SGMII_POWER_DN_;
> > > +                     lan743x_csr_write(adapter, SGMII_CTL, sgmii_ctl);
> > > +                     netif_info(adapter, drv, adapter->netdev, "SGMII operation\n");
> > 
> > And def initially this and the next one.
> > 
> 
> I did not get "def initially" means ?

I suspect that was my spelling checker getting confused, or me picking
the wrong suggestion. I meant 'definitely'. You don't want to spam the
log with SGMII vs GMII operation in the normal case. This should be
netif_dbg()

	Andrew
