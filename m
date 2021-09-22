Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F9BC4145A9
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 11:58:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234646AbhIVJ77 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 05:59:59 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:18198 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234381AbhIVJ75 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Sep 2021 05:59:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1632304707; x=1663840707;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=28a3lLNqXtQh35HGEvcVFM9lt13KcNMXr9Ft+baDXFQ=;
  b=Wq6QUdTKlNEkAAsRIaQTgbijmYim7i/+H4bjxn4Uaj1yhtQeOKw9hVXC
   xBb+kdhD2rEQnroq5B0UAvK7nFkB6o29rUl27XQgMFTcThUGg9mjZ0EyQ
   3qxpDqbCs2GG6qqjM9EFESdqKtcPo78l8MBjm77QpMK7dBXSxKLLA6M9I
   NqsofsNYTdEyqf7lywtFrQTwqMnLW+iy3ZjZ7MX9onn5/J8pT0TQ8/kSz
   PuB3rxFUXFnK2RYm2CgqXfSyD/x2J8pWON446qakLl6JKeqvyniXuuI4x
   UbhygwxMEzRtOig7IaKlcctBK/XYuaFQeauL+jkw/fdJiWemRgWl9hDQu
   Q==;
IronPort-SDR: dR61EeXGDmxfoVB+BiPAR9niYPzuF3lQhhCvQY4domCSs7BL27IQfZk8owei7OF9cKLheLL+M0
 V1RvxRNVlpLtHqH3I0Bzy+XKwqIydo/qd30jMElG/2PendTRyeN+ICbSA7D833/ebPYrK1N49b
 6ubFEOk3dsUVQi9uHZx5odeIgayL9qFZ2ULevJgtBly0Izo2HsQSwfS2u+JfaRkw6PopmxdL+c
 SlYhPz8ai77L+iKA2EYH/RntMic9BLgV4+FeuLiiaoOENuMI28CNC232NSdJ7D+K85dcacyP2c
 cLT6j3p+SfaJpwd0j5eqgajM
X-IronPort-AV: E=Sophos;i="5.85,313,1624345200"; 
   d="scan'208";a="145122886"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 22 Sep 2021 02:58:25 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Wed, 22 Sep 2021 02:58:24 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2176.14 via Frontend
 Transport; Wed, 22 Sep 2021 02:58:24 -0700
Date:   Wed, 22 Sep 2021 11:59:53 +0200
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <robh+dt@kernel.org>,
        <linux@armlinux.org.uk>, <f.fainelli@gmail.com>,
        <alexandre.belloni@bootlin.com>, <vladimir.oltean@nxp.com>,
        <UNGLinuxDriver@microchip.com>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-phy@lists.infradead.org>, <linux-pm@vger.kernel.org>
Subject: Re: [RFC PATCH net-next 05/12] reset: lan966x: Add switch reset
 driver
Message-ID: <20210922095953.r6xcr2dtx7diavhj@soft-dev3-1.localhost>
References: <20210920095218.1108151-1-horatiu.vultur@microchip.com>
 <20210920095218.1108151-6-horatiu.vultur@microchip.com>
 <YUh6WcEVBigG61y6@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <YUh6WcEVBigG61y6@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 09/20/2021 14:11, Andrew Lunn wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> On Mon, Sep 20, 2021 at 11:52:11AM +0200, Horatiu Vultur wrote:
> > The lan966x switch SoC has a number of components that can be reset
> > indiviually, but at least the switch core needs to be in a well defined
> > state at power on, when any of the lan966x drivers starts to access the
> > switch core, this reset driver is available.
> >
> > The reset driver is loaded early via the postcore_initcall interface, and
> > will then be available for the other lan966x drivers (SGPIO, SwitchDev etc)
> > that are loaded next, and the first of them to be loaded can perform the
> > one-time switch core reset that is needed.
> 
> A lot of this looks very similar to
> reset-microchip-sparx5.c. PROTECT_REG is 0x88 rather than 0x84, but
> actually using the value is the same. SOFT_RESET_REG is identical.  So
> rather than adding a new driver, maybe you can generalize
> reset-microchip-sparx5.c, and add a second compatible string?

You are right, they look similar.
I will try to add a new compatible string.

> 
>         Andrew

-- 
/Horatiu
