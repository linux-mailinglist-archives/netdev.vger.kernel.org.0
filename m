Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86A7431F062
	for <lists+netdev@lfdr.de>; Thu, 18 Feb 2021 20:51:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233158AbhBRTsD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Feb 2021 14:48:03 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:46703 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231248AbhBRTji (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Feb 2021 14:39:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1613677177; x=1645213177;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=oKsHfUJVhU6NzBcOiwBQNhHOXYxZmcLSOoVnV4tzW8k=;
  b=rzrG9lN7Q3r0CvAZgoMFUqGCYnpeBEpbpl/jZJk9yNddXvg8Cq8DwQeb
   KTlkvBeiN4erPCYm8Sf+6cS179atqUDUvM/TGDAwXu/Z3SZmKVHoxTnUx
   IerTUEOOy9UHu2NzJqR/G4ZDy8BpCw0bs8vCi8D82aoTaNdoTWMnSvpJp
   Vj5KH9nPT0uvsdOiBwbgEWGSd2kWtN2RfZdDhYTclPml+RojtMXTURyGg
   l2OuytbatQmmwlHi63Xkkjbg2zeOvpKFDZP8xDjOU2OXavHMKSLq7Xe6v
   Fs5fEX4JavLq8ZTNscqK1uMqg6G8BUXO5Q88sL904D9rITRaALiMMlPNU
   A==;
IronPort-SDR: 5WR+IHikk2vaDf+84YecMb+lbC531azptAkr/7fi37LgZQYo4djotzaeIif36m0EeAdnjNxlG3
 hHTVo6AY5ERg3957cnoeJNC6kwcvTwWkD3kZtZPsE2ClOpSxve2JUukUKvzfOFGJ5rWgn5OgGQ
 RTsGVT8WyJx2UTJ0rK0H/Tu6R3cgDosuwVR6fCHBby0V90fPxzvM4V478tcLPXvQcZMUR6q9IF
 YVu98iIutvJYTofJkiNMIhxyyWY+ubE/gC/PTE9WhyvbeyFhfrzRuTua+XlDVcEF0UfJJ9tGG5
 Xio=
X-IronPort-AV: E=Sophos;i="5.81,187,1610434800"; 
   d="scan'208";a="110291652"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 18 Feb 2021 12:38:20 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 18 Feb 2021 12:38:19 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Thu, 18 Feb 2021 12:38:19 -0700
Date:   Thu, 18 Feb 2021 20:38:18 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] net: mscc: Fix MRP switchdev driver
Message-ID: <20210218193818.r6o2reb3agcv5ovk@soft-dev3.localdomain>
References: <20210218114726.648927-1-horatiu.vultur@microchip.com>
 <20210218131758.g4vsvmowggxdklfj@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20210218131758.g4vsvmowggxdklfj@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 02/18/2021 13:17, Vladimir Oltean wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 

Hi Vladimir,

> Hi Horatiu,
> 
> On Thu, Feb 18, 2021 at 12:47:26PM +0100, Horatiu Vultur wrote:
> > This patch fixes the ocelot MRP switchdev driver such that also DSA
> > driver can use these functions. Before the driver presumed that the
> > net_device uses a 'struct ocelot_port_private' as priv which was wrong.
> >
> > The only reason for using ocelot_port_private was to access the
> > net_device, but this can be passed as an argument because we already
> > have this information. Therefore update the functions to have also the
> > net_device parameter.
> >
> > Fixes: a026c50b599fa ("net: dsa: felix: Add support for MRP")
> > Fixes: d8ea7ff3995ea ("net: mscc: ocelot: Add support for MRP")
> > Reported-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> > Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> >
> > ---
> 
> Do you mind if we drop this patch for now (the net-next pull request was
> already sent) and I will ensure that the MRP assist for Felix DSA works
> properly when I find the time to compile your mrp/cfp user space
> packages and give them a try?

Yes is perfectly fine for me.

> 
> There are more issues to be fixed than your patch addresses. For
> example, MRP will only work with the NPI-based tagging protocol,
> somebody needs to reject MRP objects when ocelot-8021q is in use.
> I think it's better for someone who has access to a DSA setup to ensure
> that the driver is in a reasonable state.

I agree on that. If this will require any changes to the switchdev part,
I would definitely like to test those.

> 
> Sorry for not reviewing the MRP patches in time.

-- 
/Horatiu
