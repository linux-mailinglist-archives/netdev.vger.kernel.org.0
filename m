Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 097B98D680
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 16:48:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726551AbfHNOsX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 10:48:23 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:60546 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725955AbfHNOsW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Aug 2019 10:48:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=bJ9gQdtGbgJ5BV5zdf9JVzIkLWkCjkQmNcShPcCxPq4=; b=aFsU3FXgTm9FxHZwnEe4qZctLy
        c2Fs2dayERZcwlddQafUEZ+jN3x3O0yqF7CZazaI9uex4cG31091AnCArQibE7duzSxZZeephFG6e
        0rjmcbRqTqNtCUJMf0OoLTMQm4s3ekhUCm8yPMiinN9EFZK/Wy97ZMEyDLQz5vL7CUOU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hxuZZ-0002TI-Cv; Wed, 14 Aug 2019 16:48:21 +0200
Date:   Wed, 14 Aug 2019 16:48:21 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <marek.behun@nic.cz>
Cc:     netdev@vger.kernel.org, Vivien Didelot <vivien.didelot@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net-next v2] net: dsa: mv88e6xxx: check for mode change
 in port_setup_mac
Message-ID: <20190814144821.GQ15047@lunn.ch>
References: <20190814144024.27975-1-marek.behun@nic.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190814144024.27975-1-marek.behun@nic.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 14, 2019 at 04:40:24PM +0200, Marek Behún wrote:
> The mv88e6xxx_port_setup_mac checks if the requested MAC settings are
> different from the current ones, and if not, does nothing (since chaning
> them requires putting the link down).
> 
> In this check it only looks if the triplet [link, speed, duplex] is
> being changed.
> 
> This patch adds support to also check if the mode parameter (of type
> phy_interface_t) is requested to be changed. The current mode is
> computed by the ->port_link_state() method, and if it is different from
> PHY_INTERFACE_MODE_NA, we check for equality with the requested mode.
> 
> In the implementations of the mv88e6250_port_link_state() method we set
> the current mode to PHY_INTERFACE_MODE_NA - so the code does not check
> for mode change on 6250.
> 
> In the mv88e6352_port_link_state() method, we use the cached cmode of
> the port to determine the mode as phy_interface_t (and if it is not
> enough, eg. for RGMII, we also look at the port control register for
> RX/TX timings).
> 
> Signed-off-by: Marek Behún <marek.behun@nic.cz>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
