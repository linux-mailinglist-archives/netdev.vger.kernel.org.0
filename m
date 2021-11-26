Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07A3045EA0A
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 10:12:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359846AbhKZJPk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 04:15:40 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:36981 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238592AbhKZJNk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Nov 2021 04:13:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1637917827; x=1669453827;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ru+c9z1oNlyIiQwDj3KxFHyHp3VS1yhZ8W7J+7bnaBo=;
  b=GtZtKkOUhhl5OVBMJILGEP+tDQ0Xhxiuxlm1RrAamI4t3aenqj3+RSbb
   4FsTBHLqe4/0FT9bWIPxSlkG74+6WnFLsbdvopArTzhanSB7wYNUKMWGA
   h9VzpFFs1xHNYbf8gevPtTaR4kwwY863bE5DzdLxCM6A6azQo/bZLSURu
   5Vq8tDb8ju51PN/jKApcbBRBZZPNPjdAx/aenfV3/UsQqZYfGgS6reavB
   WIkZAi4Vb+2Ke4ro1qmYK4xqa3czVcGr39HwTEECtqe+SMS4EiHDzk2cR
   dMq6LVASarA+qOglV4sllzcS5TXBbBzdVOPH45ruNwAz6AbIp3fRYmkbq
   w==;
IronPort-SDR: xw72zawMbrjhpLX6vr0whCXdh/U3N16Oey1brVEYT9kTvjcNfYn5y+Kj3u+BtWkkiRr/eDdLo7
 svoo2ou2MVZrvu/rerouXWD8H73I3/z0Pjn9YVFPxjAHRMso9wujcLwNQXofE9HE9aO/EJjD/W
 wOXeXuf0N4BqMr3Ugae026LoOGa6ObONzRZLh5QcpCwzbCoe/g0xLwnJRp/NZMpkuHDB32hcPZ
 Uq/5SLxK7kSZdQ88H8BBqkJdTbm7hNcBI6PIxbvIEoPveMi6iVoQtxfwiU3fvaofvliCCR5sPH
 V9MC7xcRZqbSq1l5kLub8Hg1
X-IronPort-AV: E=Sophos;i="5.87,265,1631602800"; 
   d="scan'208";a="153320083"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 26 Nov 2021 02:10:27 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Fri, 26 Nov 2021 02:10:27 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2176.14 via Frontend
 Transport; Fri, 26 Nov 2021 02:10:26 -0700
Date:   Fri, 26 Nov 2021 10:12:21 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <robh+dt@kernel.org>,
        <UNGLinuxDriver@microchip.com>, <p.zabel@pengutronix.de>,
        <linux@armlinux.org.uk>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v2 3/6] net: lan966x: add port module support
Message-ID: <20211126091221.tzrqsgawavlzitp5@soft-dev3-1.localhost>
References: <20211123135517.4037557-1-horatiu.vultur@microchip.com>
 <20211123135517.4037557-4-horatiu.vultur@microchip.com>
 <YZ59hpDWjNjvx5kP@lunn.ch>
 <20211125092638.7b2u75zdv2ulekmo@soft-dev3-1.localhost>
 <YZ+kvpCmWomKNr9l@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <YZ+kvpCmWomKNr9l@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 11/25/2021 15:59, Andrew Lunn wrote:

Hi Andrew,

> 
> > If I undestood you correctly I have tried to do the following:
> >
> > struct lan966x_ifh {
> >     __be32 timestamp;
> >     __be32 bypass : 1;
> >     __be32 port : 3;
> >     ...
> > };
> >
> > But then I start to get errors from sparse:
> >
> > error: invalid bitfield specifier for type restricted __be32.
> 
> Maybe look at struct iphdr. It has bitfields for the header length and
> the IP version.

I think it would get pretty messy to add all these defines in the
lan966x_ifh struct. One reason is that the IFH contains 38 fields.

I have send another version(v4) where I think I have simplified it a little
bit more. If you think is still not clear enough, I will try again the
approach that you proposed.

> 
>     Andrew

-- 
/Horatiu
