Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9802D88C45
	for <lists+netdev@lfdr.de>; Sat, 10 Aug 2019 18:34:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726321AbfHJQed (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Aug 2019 12:34:33 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50070 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726048AbfHJQed (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 10 Aug 2019 12:34:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=+XcaMz3hAkMIn2mjsZcblkOPoXKXhcojqLISCOkCUxQ=; b=vPI0sG28vl7QxUcf0hhxI0WYXF
        zim5qzVIM0aXJoJCEWqSSxaNlAc9m/XlGqdfTW9uD5It+DeiZly+fvrlV7GmQjlmf5QQbIPBkCQpg
        XqFPfJuRgd4rjaGcsiuBp1UNhlDWezw2Qq8qU/NcVjnL/x13S0w5DEMEW+GUALZAGv9M=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hwUJz-0008N0-GI; Sat, 10 Aug 2019 18:34:23 +0200
Date:   Sat, 10 Aug 2019 18:34:23 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Antoine Tenart <antoine.tenart@bootlin.com>
Cc:     davem@davemloft.net, sd@queasysnail.net, f.fainelli@gmail.com,
        hkallweit1@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, thomas.petazzoni@bootlin.com,
        alexandre.belloni@bootlin.com, allan.nielsen@microchip.com,
        camelia.groza@nxp.com, Simon.Edelhaus@aquantia.com
Subject: Re: [PATCH net-next v2 6/9] net: macsec: hardware offloading
 infrastructure
Message-ID: <20190810163423.GA30120@lunn.ch>
References: <20190808140600.21477-1-antoine.tenart@bootlin.com>
 <20190808140600.21477-7-antoine.tenart@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190808140600.21477-7-antoine.tenart@bootlin.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 08, 2019 at 04:05:57PM +0200, Antoine Tenart wrote:
> This patch introduces the MACsec hardware offloading infrastructure.
> 
> The main idea here is to re-use the logic and data structures of the
> software MACsec implementation. This allows not to duplicate definitions
> and structure storing the same kind of information. It also allows to
> use a unified genlink interface for both MACsec implementations (so that
> the same userspace tool, `ip macsec`, is used with the same arguments).
> The MACsec offloading support cannot be disabled if an interface
> supports it at the moment.
> 
> The MACsec configuration is passed to device drivers supporting it
> through macsec_hw_offload() which is called from the MACsec genl
> helpers. This function calls the macsec ops of PHY and Ethernet
> drivers in two steps

Hi Antoine, Igor

It is great that you are thinking how a MAC driver would make use of
this. But on the flip side, we don't usual add an API unless there is
a user. And as far as i see, you only add a PHY level implementation,
not a MAC level.

Igor, what is your interest here? I know the Aquantia PHY can do
MACsec, but i guess you are more interested in the atlantic and AQC111
MAC drivers which hide the PHY behind firmware rather than make use of
the Linux aquantia PHY driver. Are you likely to be contributing a MAC
driver level implementation of MACsec soon?

Thanks
       Andrew
