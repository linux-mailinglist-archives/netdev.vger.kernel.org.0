Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 882FA751F8
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 16:59:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388818AbfGYO70 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 10:59:26 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:37536 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387834AbfGYO70 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Jul 2019 10:59:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=qzGhGryKK/q9r/TH/dGdYQxjkpGjSnnN7IFHYQqSBA0=; b=vCF/UR/Pr64xM0I4hCMFp9JkNP
        PND9Pe+/PADXEQs57J+5yzPUJ2fXmVEXus09F4By4JHF3cfb5WGfhrDdijqaiLJrxQR8aNmNkQuaT
        NtcxjbireJd7zDFSnyA3NbzcXFy4uCNYR1FN8kVMH7rxO0XVc3wkrZlDR3ks7ygYnDoI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hqfDI-0006vg-8W; Thu, 25 Jul 2019 16:59:24 +0200
Date:   Thu, 25 Jul 2019 16:59:24 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek Vasut <marex@denx.de>
Cc:     netdev@vger.kernel.org, Tristram Ha <Tristram.Ha@microchip.com>,
        "David S . Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>
Subject: Re: [PATCH 3/3] net: dsa: ksz: Add Microchip KSZ8795 DSA driver
Message-ID: <20190725145924.GB25700@lunn.ch>
References: <20190724134048.31029-1-marex@denx.de>
 <20190724134048.31029-4-marex@denx.de>
 <20190725140351.GG21952@lunn.ch>
 <ea4f2da3-a91f-f1fa-b70d-e9bd46708454@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ea4f2da3-a91f-f1fa-b70d-e9bd46708454@denx.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 25, 2019 at 04:56:37PM +0200, Marek Vasut wrote:
> On 7/25/19 4:03 PM, Andrew Lunn wrote:
> > On Wed, Jul 24, 2019 at 03:40:48PM +0200, Marek Vasut wrote:
> >> From: Tristram Ha <Tristram.Ha@microchip.com>
> >> +static void ksz8795_phy_setup(struct ksz_device *dev, int port,
> >> +			      struct phy_device *phy)
> >> +{
> >> +	if (port < dev->phy_port_cnt) {
> >> +		/*
> >> +		 * SUPPORTED_Asym_Pause and SUPPORTED_Pause can be removed to
> >> +		 * disable flow control when rate limiting is used.
> >> +		 */
> >> +		linkmode_copy(phy->advertising, phy->supported);
> >> +	}
> >> +}
> > 
> > Hi Marek
> > 
> > Do you know why this is needed?
> 
> Unfortunately, no.
> 
> It seems it copies supported features of the PHY to advertised features
> of the PHY for ports which are downstream (i.e. not the CPU port).

Hi Marek

Could you test it without this copy? Do you get sensible values from
ethtool? Does the pause configuration look sensible?

Thanks
	Andrew
