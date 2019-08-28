Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE389A0684
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 17:41:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726713AbfH1Plj convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 28 Aug 2019 11:41:39 -0400
Received: from mga12.intel.com ([192.55.52.136]:6239 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726576AbfH1Pli (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Aug 2019 11:41:38 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 28 Aug 2019 08:41:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,441,1559545200"; 
   d="scan'208";a="185660004"
Received: from kmsmsx153.gar.corp.intel.com ([172.21.73.88])
  by orsmga006.jf.intel.com with ESMTP; 28 Aug 2019 08:41:35 -0700
Received: from pgsmsx110.gar.corp.intel.com (10.221.44.111) by
 KMSMSX153.gar.corp.intel.com (172.21.73.88) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 28 Aug 2019 23:41:34 +0800
Received: from pgsmsx114.gar.corp.intel.com ([169.254.4.237]) by
 PGSMSX110.gar.corp.intel.com ([169.254.13.32]) with mapi id 14.03.0439.000;
 Wed, 28 Aug 2019 23:41:34 +0800
From:   "Ong, Boon Leong" <boon.leong.ong@intel.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jose Abreu <joabreu@synopsys.com>,
        "Voon, Weifeng" <weifeng.voon@intel.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: RE: [PATCH v1 net-next] net: phy: mdio_bus: make mdiobus_scan also
 cover PHY that only talks C45
Thread-Topic: [PATCH v1 net-next] net: phy: mdio_bus: make mdiobus_scan also
 cover PHY that only talks C45
Thread-Index: AQHVXDc1fRg6jt0ytUq1rAVRvV6sOqcNOWeAgAAHYgCAAVd0AIAABzAAgAIVuuA=
Date:   Wed, 28 Aug 2019 15:41:33 +0000
Message-ID: <AF233D1473C1364ABD51D28909A1B1B75C22CD3C@pgsmsx114.gar.corp.intel.com>
References: <1566870769-9967-1-git-send-email-weifeng.voon@intel.com>
 <e9ece5ad-a669-6d6b-d050-c633cad15476@gmail.com>
 <20190826185418.GG2168@lunn.ch>
 <D6759987A7968C4889FDA6FA91D5CBC814758ED8@PGSMSX103.gar.corp.intel.com>
 <20190827154918.GO2168@lunn.ch>
In-Reply-To: <20190827154918.GO2168@lunn.ch>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiZTY3OWJkYzMtNzhkOS00YjkyLWI1NzgtNmIyZDIyNTJkZTBhIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiNGhONGNFZDZjak5IUXJiYU5wMlB0R3NtS0d5NWpMMHZhVmxaVzZBXC90K0xLMjJWRDNLXC9IVEY5WmVrcWhGK1wvWiJ9
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [172.30.20.205]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>On Tue, Aug 27, 2019 at 03:23:34PM +0000, Voon, Weifeng wrote:
>> > > > Make mdiobus_scan() to try harder to look for any PHY that only
>> > talks C45.
>> > > If you are not using Device Tree or ACPI, and you are letting the MDIO
>> > > bus be scanned, it sounds like there should be a way for you to
>> > > provide a hint as to which addresses should be scanned (that's
>> > > mii_bus::phy_mask) and possibly enhance that with a mask of possible
>> > > C45 devices?
>> >
>> > Yes, i don't like this unconditional c45 scanning. A lot of MDIO bus
>> > drivers don't look for the MII_ADDR_C45. They are going to do a C22
>> > transfer, and maybe not mask out the MII_ADDR_C45 from reg, causing an
>> > invalid register write. Bad things can then happen.
>> >
>> > With DT and ACPI, we have an explicit indication that C45 should be used,
>> > so we know on this platform C45 is safe to use. We need something
>> > similar when not using DT or ACPI.
>> >
>> > 	  Andrew
>>
>> Florian and Andrew,
>> The mdio c22 is using the start-of-frame ST=01 while mdio c45 is using ST=00
>> as identifier. So mdio c22 device will not response to mdio c45 protocol.
>> As in IEEE 802.1ae-2002 Annex 45A.3 mention that:
>> " Even though the Clause 45 MDIO frames using the ST=00 frame code
>> will also be driven on to the Clause 22 MII Management interface,
>> the Clause 22 PHYs will ignore the frames. "
>>
>> Hence, I am not seeing any concern that the c45 scanning will mess up with
>> c22 devices.
>
>Hi Voon
>
>Take for example mdio-hisi-femac.c
>
>static int hisi_femac_mdio_read(struct mii_bus *bus, int mii_id, int regnum)
>{
>        struct hisi_femac_mdio_data *data = bus->priv;
>        int ret;
>
>        ret = hisi_femac_mdio_wait_ready(data);
>        if (ret)
>                return ret;
>
>        writel((mii_id << BIT_PHY_ADDR_OFFSET) | regnum,
>               data->membase + MDIO_RWCTRL);
>
>
>There is no check here for MII_ADDR_C45. So it will perform a C22
>transfer. And regnum will still have MII_ADDR_C45 in it, so the
>writel() is going to set bit 30, since #define MII_ADDR_C45
>(1<<30). What happens on this hardware under these conditions?
>
>You cannot unconditionally ask an MDIO driver to do a C45
>transfer. Some drivers are going to do bad things.

Andrew & Florian, thanks for your review on this patch and insights on it.
We will look into the implementation as suggested as follow. 

- for each bit clear in mii_bus::phy_mask, scan it as C22
- for each bit clear in mii_bus::phy_c45_mask, scan it as C45

We will work on this and resubmit soonest. 
