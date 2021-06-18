Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 453BB3ABFFA
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 02:09:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233172AbhFRAMC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 20:12:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232479AbhFRAMB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Jun 2021 20:12:01 -0400
Received: from gate2.alliedtelesis.co.nz (gate2.alliedtelesis.co.nz [IPv6:2001:df5:b000:5::4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15717C06175F
        for <netdev@vger.kernel.org>; Thu, 17 Jun 2021 17:09:52 -0700 (PDT)
Received: from svr-chch-seg1.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id 9A99783640;
        Fri, 18 Jun 2021 12:09:49 +1200 (NZST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1623974989;
        bh=AHBtbXwm2xMmYb4uxx88KQ1fnNAj1rBtjk3rabAXtrQ=;
        h=From:To:CC:Subject:Date:References:In-Reply-To;
        b=KBjb4e7NGGlHi/FYiPsjftrv67LhziiNGr406pVO2qowfQawMfquHiUsuLZ6aLQAE
         Wr7ABnywBQSZs2mTvOWIMy8Ce+pRDqsMmRc57ZWdQoa/LGJk5Vkvr9om5Y8A+OhpEB
         kYUAQHLklD+2riV27YX4cn/+yp+trWeGJqhct13aZTu83KLZx9WkGkAjAcTfoQetXs
         vONkgKLC/NsEjyW1ub0oQ1f8IvKF/1Zqce7NgFcqSfO3O9L+DZpMd8B4rbsSUKfhOa
         EuPsYNudnYdm7BMfgRGj6Kt06vNzBCSGY9vhQ0e/ddUH9ohQWTJXnK4PSOu54ixmKe
         Q3S9dLO37Mo+Q==
Received: from svr-chch-ex1.atlnz.lc (Not Verified[2001:df5:b000:bc8::77]) by svr-chch-seg1.atlnz.lc with Trustwave SEG (v8,2,6,11305)
        id <B60cbe44d0001>; Fri, 18 Jun 2021 12:09:49 +1200
Received: from svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8::77) by
 svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8::77) with Microsoft SMTP Server
 (TLS) id 15.0.1497.18; Fri, 18 Jun 2021 12:09:49 +1200
Received: from svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8]) by
 svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8%12]) with mapi id
 15.00.1497.018; Fri, 18 Jun 2021 12:09:49 +1200
From:   Callum Sinclair <Callum.Sinclair@alliedtelesis.co.nz>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "dsahern@kernel.org" <dsahern@kernel.org>,
        "nikolay@nvidia.com" <nikolay@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linus.luessing@c0d3.blue" <linus.luessing@c0d3.blue>
Subject: Re: [PATCH 1/1] net: Allow all multicast packets to be received on a
 interface.
Thread-Topic: [PATCH 1/1] net: Allow all multicast packets to be received on a
 interface.
Thread-Index: AQHXY15AjPZKD1gBPUW680Mm+Pg7t6sXd18AgAFtyb4=
Date:   Fri, 18 Jun 2021 00:09:48 +0000
Message-ID: <1623974988948.39187@alliedtelesis.co.nz>
References: <20210617095020.28628-1-callum.sinclair@alliedtelesis.co.nz>
 <20210617095020.28628-2-callum.sinclair@alliedtelesis.co.nz>,<YMtZspsYH0wd9SVf@lunn.ch>
In-Reply-To: <YMtZspsYH0wd9SVf@lunn.ch>
Accept-Language: en-US, en-NZ
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.32.1.11]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-SEG-SpamProfiler-Analysis: v=2.3 cv=IOh89TnG c=1 sm=1 tr=0 a=Xf/6aR1Nyvzi7BryhOrcLQ==:117 a=xqWC_Br6kY4A:10 a=oKJsc7D3gJEA:10 a=8nJEP1OIZ-IA:10 a=r6YtysWOX24A:10 a=VwQbUJbxAAAA:8 a=Ikd4Dj_1AAAA:8 a=62ntRvTiAAAA:8 a=BjvkRneYAAAA:8 a=TQE1fwpsvIluFpPGKlQA:9 a=wPNLvfGTeEIA:10 a=AjGcO6oz07-iQ99wixmX:22 a=pToNdpNmrtiFLRE6bQ9Z:22 a=RwQB74oxMe2pVKaOgktC:22
X-SEG-SpamProfiler-Score: 0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew=0A=
=0A=
> What is the big picture here? Are you trying to move the snooping=0A=
> algorithm into user space? User space will then add/remove Multicast=0A=
> FIB entries to the bridge to control where mulitcast frames are sent?=0A=
=0A=
Yes I want to run a IGMP, MLD and PIM implementation in userspace and=0A=
just use the kernel to send multicast frames to addresses that have been=0A=
installed into the multicast forwarding cache.=0A=
=0A=
> In the past i have written a multicast routing daemon. It is a similar=0A=
> problem. You need access to all the join/leaves. But the stack does=0A=
> provide them, if you bind to the multicast routing socket. Why not use=0A=
> that mechanism? Look in the mrouted sources for an example.=0A=
=0A=
Ah I can see that I get the IGMP and MLD packets now. I was just creating=
=0A=
the socket as a IP socket without multicast routing. Thanks for your help.=
=0A=
=0A=
Cheers=0A=
Callum=0A=
________________________________________=0A=
From: Andrew Lunn <andrew@lunn.ch>=0A=
Sent: Friday, June 18, 2021 2:18 AM=0A=
To: Callum Sinclair=0A=
Cc: dsahern@kernel.org; nikolay@nvidia.com; netdev@vger.kernel.org; linux-k=
ernel@vger.kernel.org; linus.luessing@c0d3.blue=0A=
Subject: Re: [PATCH 1/1] net: Allow all multicast packets to be received on=
 a interface.=0A=
=0A=
On Thu, Jun 17, 2021 at 09:50:20PM +1200, Callum Sinclair wrote:=0A=
> To receive IGMP or MLD packets on a IP socket on any interface the=0A=
> multicast group needs to be explicitly joined. This works well for when=
=0A=
> the multicast group the user is interested in is known, but does not=0A=
> provide an easy way to snoop all packets in the http://scanmail.trustwave=
.com/?c=3D20988&d=3DwNnL4EU-bOXOuxnfu9BLng8ncWxDIw3ACrur9S2N4w&u=3Dhttp%3a%=
2f%2f224%2e0%2e0%2e0%2f8 or the=0A=
> FF00::/8 range.=0A=
>=0A=
> Define a new sysctl to allow a given interface to become a IGMP or MLD=0A=
> snooper. When set the interface will allow any IGMP or MLD packet to be=
=0A=
> received on sockets bound to these devices.=0A=
=0A=
Hi Callum=0A=
=0A=
What is the big picture here? Are you trying to move the snooping=0A=
algorithm into user space? User space will then add/remove Multicast=0A=
FIB entries to the bridge to control where mulitcast frames are sent?=0A=
=0A=
In the past i have written a multicast routing daemon. It is a similar=0A=
problem. You need access to all the join/leaves. But the stack does=0A=
provide them, if you bind to the multicast routing socket. Why not use=0A=
that mechanism? Look in the mrouted sources for an example.=0A=
=0A=
     Andrew=0A=
