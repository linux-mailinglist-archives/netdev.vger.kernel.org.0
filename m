Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A56C02E20D5
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 20:25:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728382AbgLWTXT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Dec 2020 14:23:19 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:22715 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727225AbgLWTXT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Dec 2020 14:23:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1608751398; x=1640287398;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=s+Ef01a0Zg9EmKUC0iQKIv5OjvVNc/gNMZ4RrppgasQ=;
  b=PYhIqp87hq1tnH8GtXq95iUCxZSrcA3o0pf9z8Ej21WVyfOcOh9z3Q2N
   mww86JWzxozpNoip2x5CzVeQrEK1bHLq1Tw1xyUYloGl2a21hKakGwpgd
   2UwMDH+nzH82nWnp6nVC2wXmLYv07yJjs5dZJy4knQgHtLuhuvi4k2Or4
   ug/cxFgH16pa15YT3xCw0O/R1QxYY8te28kEv4VK18GwNZR9gCUcUaF4/
   3bBewk8nrpm6ltaORjq9DLklJJ7M+JcEmAqFaPIjff27XGlDWgCEnwRhl
   lTNxTN89qK1fW1uURYfyO72EHK4Hmb6C0MHAviXBB6dBnmzf6iJ+TR7aX
   Q==;
IronPort-SDR: ONNKbXu+rljMbdNxsWVEmpM0+sa2wI1XlbNM3QYFik/DyKWtTiwttsCzSbp9hJLZMif4mlKKBX
 SKo8RmUZLfkDj2bx55Bgy/fgPFiPTfMKzAEsTlXMsDM4ckKfETcMXkfRjAZDP4dGN29F9E38k/
 53QCHPaIcieQRg4UmLdto/PQjQrrnuuUH5ivyhhYVTWsV9ghntjT2lu65RU4APfYm4Ro9wtawN
 OLleIlOaWUbahaRMC+McbvPhJ0XJr2yFtfcB5ZXzeles91XwW8s25KxknXUSkBIzdUx7hp/nor
 SXo=
X-IronPort-AV: E=Sophos;i="5.78,442,1599548400"; 
   d="scan'208";a="100870859"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 23 Dec 2020 12:22:02 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 23 Dec 2020 12:22:02 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Wed, 23 Dec 2020 12:22:02 -0700
Date:   Wed, 23 Dec 2020 20:22:01 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net 1/2] net: mrp: fix definitions of MRP test packets
Message-ID: <20201223192201.dh7das2fkhntl2tr@soft-dev3.localdomain>
References: <20201223144533.4145-1-rasmus.villemoes@prevas.dk>
 <20201223144533.4145-2-rasmus.villemoes@prevas.dk>
 <20201223175910.2ipmowhcn63mqtqt@soft-dev3.localdomain>
 <20201223184155.GT3107610@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20201223184155.GT3107610@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

The 12/23/2020 19:41, Andrew Lunn wrote:
> 
> > > @@ -96,7 +96,7 @@ struct br_mrp_ring_test_hdr {
> > >         __be16 state;
> > >         __be16 transitions;
> > >         __be32 timestamp;
> > > -};
> > > +} __attribute__((__packed__));
> >
> > Yes, I agree that this should be packed but it also needs to be 32 bit
> > alligned, so extra 2 bytes are needed.
> 
> The full structure is:
> 
> struct br_mrp_ring_test_hdr {
>         __be16 prio;
>         __u8 sa[ETH_ALEN];
>         __be16 port_role;
>         __be16 state;
>         __be16 transitions;
>         __be32 timestamp;
> };
> 
> If i'm looking at this correctly, the byte offsets are:
> 
> 0-1   prio
> 2-7   sa
> 8-9   port_role
> 10-11 state
> 12-13 transition
> 
> With packed you get
> 
> 14-17 timestamp
> 
> which is not 32 bit aligned.
> 
> Do you mean the whole structure must be 32 bit aligned? We need to add
> two reserved bytes to the end of the structure?

Sorry, I looked too fast over this. First some info, in front of the
'br_mrp_ring_test_hdr', there is 'br_mrp_tlv_hdr' which is 2
bytes. So the frame will look something like this:

... |---------|----------------|----------------------|------------| ....
... | MRP Ver | br_mrp_tlv_hdr | br_mrp_ring_test_hdr | Common TLV | ....
... |---------|----------------|----------------------|------------| ....

The standard says that for br_mrp_tlv_hdr + br_mrp_ring_test, 32 bit
alignment shall be ensured. So my understanding was that it needs to be
at word boundary(4 bytes).

So based on this, if we use packed then we get the following offsets
0	type
1	length
2-3	prio
4-9	sa
10-11	port_role
12-13	state
14-15	transition
16-19	timestamp.

Which is 20 bytes, that fits correctly. So my understanding is we need to
use packed, to remove the hole between transition and timestamp as
Rasmus suggested and should NOT use these 2 extra bytes that I
mentioned because it would not be aligned anymore.

Here you can find few more details about MRP[1]

> 
>     Andrew

[1] https://www.youtube.com/watch?v=R3vQYfwiJ2M

-- 
/Horatiu
