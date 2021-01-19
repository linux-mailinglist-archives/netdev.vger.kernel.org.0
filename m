Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85D972FC1C2
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 22:03:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387548AbhASVB6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 16:01:58 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:43127 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731893AbhASVA6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 16:00:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1611090058; x=1642626058;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=mwYgYrzxMbxsnnfaYbK7dQXBmCyRJjxIkznIATJAT00=;
  b=aEZ/Ktv1iz51BuqAYUL3ExFdJVjjUn86Xm9PQOcDVvJ0Nwf6cVx8WmWj
   LPfm3BSIP9K11PBgsxZgDqPTKX/JMSa75G4ZY17J6jlGlFLYAA91L4J3E
   XG0L7n/TXskf7NXhTXzyp35PI/MtdNOlRi6zQ7wjTMf4AEQyQMtmJmTl6
   OXrhsA8rsOnULC2SCt1ipE74zHpD5hyWrxj+l35dQSR5IKTa1DycusrTP
   8I8DdKp/ieW1BafzsSz9rsD6gd/2ofN/2sWda+UlzKNfOKGas3D6vNW8b
   YeU0tOHuDHPoxtl8p+qBuEyMdQ9CzZGZokyHF2IPM8zmhqsISRW2sGxs3
   g==;
IronPort-SDR: IPQs4+9uoVaysBHS2pyMPeetTZmdcdMgptCbbWBOGHs2tU2bVXqs6Y9rz+bdUkZIsV5x/OFgVv
 9QvZ06ry35boY5iq7DrvHgJayOLZKNhwZoLnnXD5sd21ry/npnOINiGJLkbF+efm0ccShs9ICl
 5UX86tGYnd5tYTYMXsO9ZKZT+oRNIyjcGuNjMZTcOGb7flIT1CE0xaYrbOGhv1BWDqMb7SVrc9
 qM9dZFaP1vuZNOi2SMdehYGpgQ56HaZc0eV1ApoPrYBY5p4+qT2RDhb8exod1ZwWC+pPjax41z
 zNo=
X-IronPort-AV: E=Sophos;i="5.79,359,1602572400"; 
   d="scan'208";a="100678276"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 19 Jan 2021 13:59:42 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 19 Jan 2021 13:59:42 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Tue, 19 Jan 2021 13:59:41 -0700
Date:   Tue, 19 Jan 2021 21:59:39 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "bridge@lists.linux-foundation.org" 
        <bridge@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] net: mrp: use stp state as substitute for
 unimplemented mrp state
Message-ID: <20210119205939.x3dxkbgjyuzzcxnk@soft-dev3.localdomain>
References: <20210118181319.25419-1-rasmus.villemoes@prevas.dk>
 <20210118185618.75h45rjf6qqberic@soft-dev3.localdomain>
 <20210118194632.zn5yucjfibguemjq@skbuf>
 <20210118202036.wk2fuwa3hysg4dmj@soft-dev3.localdomain>
 <20210118212735.okoov5ndybszd6m5@skbuf>
 <20210119083240.37cxv3lxi25hwduj@soft-dev3.localdomain>
 <YAcAIcwfp8za9JUo@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <YAcAIcwfp8za9JUo@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 01/19/2021 16:52, Andrew Lunn wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> On Tue, Jan 19, 2021 at 09:32:40AM +0100, Horatiu Vultur wrote:
> > The 01/18/2021 21:27, Vladimir Oltean wrote:
> > > EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> > >
> > > On Mon, Jan 18, 2021 at 09:20:36PM +0100, Horatiu Vultur wrote:
> > > > The 01/18/2021 19:46, Vladimir Oltean wrote:
> > > > >
> > > > > On Mon, Jan 18, 2021 at 07:56:18PM +0100, Horatiu Vultur wrote:
> > > > > > The reason was to stay away from STP, because you can't run these two
> > > > > > protocols at the same time. Even though in SW, we reuse port's state.
> > > > > > In our driver(which is not upstreamed), we currently implement
> > > > > > SWITCHDEV_ATTR_ID_MRP_PORT_STATE and just call the
> > > > > > SWITCHDEV_ATTR_ID_PORT_STP_STATE.
> > > > >
> > > > > And isn't Rasmus's approach reasonable, in that it allows unmodified
> > > > > switchdev drivers to offload MRP port states without creating
> > > > > unnecessary code churn?
> > > >
> > > > I am sorry but I don't see this as the correct solution. In my opinion,
> > > > I would prefer to have 3 extra lines in the driver and have a better
> > > > view of what is happening. Than having 2 calls in the driver for
> > > > different protocols.
> > >
> > > I think the question boils down to: is a MRP-unaware driver expected to
> > > work with the current bridge MRP code?
> >
> > If the driver has switchdev support, then is not expected to work with
> > the current bridge MRP code.
> 
> >
> > For example, the Ocelot driver, it has switchdev support but no MRP
> > support so this is not expected to work.
> 
> Then ideally, we need switchdev core to be testing for the needed ops
> and returning an error which prevents MRP being configured when it
> cannot work.

Yes, that would be great, I had a look at the handled attribute of the
switchdev_notifier_port_attr_info but I am not sure.

But what about adding some 'if (IS_ENBABLED(NET_SWITCHDEV))' in br_mrp.c
and then calling the functions br_mrp_switchdev_ only if this is
enabled.  Then whenever the switchdev call returns an error then is
cleared that MRP can't be configured.

> 
>        Andrew

-- 
/Horatiu
