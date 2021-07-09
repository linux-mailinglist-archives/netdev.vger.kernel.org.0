Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C2393C1D04
	for <lists+netdev@lfdr.de>; Fri,  9 Jul 2021 03:30:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230139AbhGIBdX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Jul 2021 21:33:23 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:47014 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229953AbhGIBdX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Jul 2021 21:33:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=iR/91e9r/pV24uz7F/ZCZMYq8GdTcOgKPN8iEDrQRb8=; b=ljJbRil4n+6JOT76mK3vtCkveF
        C2LNsuSXdXSMa33p02M3bMCMeg7pG/fthTEeE0tLgoSIPmnM+KjC9vIP5nGaP4+UxR0hsAGWhZzK/
        tcxWx0uksOw18Anq1E0EHrtFWfzMUKLu8F8p7+vd39w3GejF5pVaIuxOzD/A6sXzSaiE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1m1fLS-00ChH2-OR; Fri, 09 Jul 2021 03:30:22 +0200
Date:   Fri, 9 Jul 2021 03:30:22 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     "Ismail, Mohammad Athari" <mohammad.athari.ismail@intel.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] net: phy: reconfigure PHY WOL in resume if WOL
 option still enabled
Message-ID: <YOemro4DJEBl+h6N@lunn.ch>
References: <20210708004253.6863-1-mohammad.athari.ismail@intel.com>
 <YOZTmfvVTj9eo+to@lunn.ch>
 <4e159b98-ec02-33b7-862a-0e35832c3a5f@gmail.com>
 <CO1PR11MB477144A2A055B390825A9FF4D5199@CO1PR11MB4771.namprd11.prod.outlook.com>
 <9871a015-bcfb-0bdb-c481-5e8f2356e5ba@gmail.com>
 <CO1PR11MB47719C284F178753C916519FD5199@CO1PR11MB4771.namprd11.prod.outlook.com>
 <f167de1d-94cc-7465-2e6f-e1e71b66b009@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f167de1d-94cc-7465-2e6f-e1e71b66b009@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Ah yes you are right, we just skip resume in that case. OK let me think
> about it some more.

The point here is, it is an interrupt, from the perspective of the PHY
hardware and its driver. But the interrupt handler is never being
called because the interrupt output from the chip is not causing an
actual interrupt. Fix that, and your problem goes away. Or you need to
add a whole new mechanism that you are using the interrupt hardware in
the PHY some something else than an actual interrupt.

    Andrew

