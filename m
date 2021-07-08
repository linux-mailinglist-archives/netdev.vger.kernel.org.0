Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B70F3C13EE
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 15:11:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231880AbhGHNOJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Jul 2021 09:14:09 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:46182 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230080AbhGHNOJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Jul 2021 09:14:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=gS8AFk63aQm9ubdaiQKcXkzcytAXfuI8lQWGTpI+e3o=; b=5x
        Gg5TuF+v9iaN2x1WBOp57Gi40bGBD+dB8fZuDaHEd64j4rzJuK2fBLnrsSRAJc3RtFoOz4GsHU/eL
        032iduhfQDa8AkOcTve/LFSczTM57dVmW+PNUTEk/ZA/EBzEUBZjCd4y/gBNpwCvfKS+nw5XtMOWK
        pthAzVtA9MWLoGs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1m1ToB-00Cdsh-1w; Thu, 08 Jul 2021 15:11:15 +0200
Date:   Thu, 8 Jul 2021 15:11:15 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Ismail, Mohammad Athari" <mohammad.athari.ismail@intel.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] net: phy: reconfigure PHY WOL in resume if WOL
 option still enabled
Message-ID: <YOb5cy2giMYO1V5U@lunn.ch>
References: <20210708004253.6863-1-mohammad.athari.ismail@intel.com>
 <YOZTmfvVTj9eo+to@lunn.ch>
 <CO1PR11MB4771D3BB3D8722BF3454AD4AD5199@CO1PR11MB4771.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CO1PR11MB4771D3BB3D8722BF3454AD4AD5199@CO1PR11MB4771.namprd11.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Hi Andrew,
> 
> In our platform, the PHY interrupt pin is not connected to Host CPU. So, the CPU couldn`t service the PHY interrupt.  The PHY interrupt pin is connected to a power management controller (PMC) as a HW wake up signal. The PMC itself couldn't act as interrupt controller to service the PHY interrupt.
> 
> During WOL event, the WOL signal is sent to PMC through the PHY interrupt pin to wake up the PMC. Then, the PMC will wake up the Host CPU and the whole system.

How is the PMC connected to the host? LPC? At wake up can you ask it
why it woke you up? What event it was, power restored, power button
press, or WOL? Can the PMC generate interrupts over the LPC? What PMC
is it? Is there a datasheet for it?

Getting your architecture correct will also solve your S3/S4 problems.

    Andrew
