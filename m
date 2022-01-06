Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D914C48625F
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 10:50:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237580AbiAFJuP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 04:50:15 -0500
Received: from mail-dm6nam11on2136.outbound.protection.outlook.com ([40.107.223.136]:45888
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237565AbiAFJuO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jan 2022 04:50:14 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=URfXur/eObQEujd90nxt2XqbMejLQbAVabTlO9Cr5S7x2KWRvZB3Mt+ZU1yVg/hzPMRgJwj5AbTI78Vumdu/SAGLFRqOLZqr/8Pztu2ltBYIA7C3Xb4Jo6YuTA60BIYujX8JaCE5QP73Ye6o2xeXxuprp7/Y5bSG8X5W4AMFsfLGsL/X4vono0niDbuxbak3r6P+o9+cUnPJHI8Dkz504tQYM8IsUn0w1zJX1Sc2OKw58DGPHjxOvKDZODLikJ21IFBUuzOW5wybj/SIXWGH0wLMrXk8HAdUIPeZoaMA1pnJV7qHVDmMdDbYPkXf2LDcklDuxW7A7s9EhuUmB7jSxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zWYSbmrGIF5bi/y233V28kh+cQa9fQUdJf5Y7aGFM+E=;
 b=MOgFUOBijjFXVTIBsiJ/QsLitlHsaHVVzhtxqInCzCuR/FuRKsOPhmuzQP6JcfX2ZOr1eLWXVLHcJiXn6MIc5CveOgjnFGddDZGc0chlAOHcT0lz3tHbOVxSrcw/F40cnvpDjlNvrDMT/eEhaiWZBLax5hIWyyRftvbnfdeCuEndN4lbdOUU0WSyZwd79RlPYW1mCGIzQVcw+frsTMOrvrWHwNpnQXscz9HXI7bvjLv5AW2tPmEAIeTI8Boro3j/jNKQ69/ahoFkAwpgQFRV2KmLvxpSbMtHiNFq2kKlwDCLMcxzu1+GDxA5pEQNmfOmixJ2Z0DwUsA50qjMc6lGSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zWYSbmrGIF5bi/y233V28kh+cQa9fQUdJf5Y7aGFM+E=;
 b=KvmAO39y5u+CAouYFLySkHVZ2mcvGr2vUVrTwBWv8y4wUCj4cd5r3gAKX547xzWKxjWsfHWN/uGai9DIA/9vap8l2vxui7pkV0pU+/q27eS0E4emi7l+d8OXeneBNdroXMGphd/pGEArTPPbgMMrU8TVgXVMwMvUZO+PALVrM54=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by MW5PR10MB5689.namprd10.prod.outlook.com
 (2603:10b6:303:19a::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.16; Thu, 6 Jan
 2022 09:50:11 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f%4]) with mapi id 15.20.4844.017; Thu, 6 Jan 2022
 09:50:10 +0000
Date:   Thu, 6 Jan 2022 01:50:03 -0800
From:   Colin Foster <colin.foster@in-advantage.com>
To:     netdev@vger.kernel.org
Cc:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        katie.morris@in-advantage.com, UNGLinuxDriver@microchip.com
Subject: ocelot-pcs - qsgmii planning
Message-ID: <20220106095003.GA253016@euler>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-ClientProxiedBy: MW3PR06CA0001.namprd06.prod.outlook.com
 (2603:10b6:303:2a::6) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 35db09b5-94d8-46f4-dc37-08d9d0f9eda2
X-MS-TrafficTypeDiagnostic: MW5PR10MB5689:EE_
X-Microsoft-Antispam-PRVS: <MW5PR10MB5689E375851550D5E0F26578A44C9@MW5PR10MB5689.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3q3kYQOSTwyd34HrangT/UjaJniEImlV+1NyO3t+CokwhIe5lZ8N4OHqpxY0hymjfSmVDJT8N2u4mTEFGDqyXBwVYgZ5sRpGa5S8vqCBmhMo61MESPOt2bgkdGu1ieiD+iT2EkBhKwyZzfQxzUklY2MR5TU4MWyrF4AwyN4jEBqHVVUClE+5OjJmtVI3XxTnrM8azgzVttiasnvtneG9FrVVjlnjvVPn+fo3ghYTT2asSppYruzSvvubZObTXtKIRmX3uqfdAaatA95QtLd11eyUE9hm5pecRR9msZwg0A9Wgpcttoiq9tKO5gigQJMuTis+4w1wZ5mQ1gTttGPeOrpE35xSiwvJibcT1dapJNxxRze9NExDAQoFT0fu06B5LS2JnT9Hs0Yd8kdanaFJDhy7FP8ukK36DgtLZoOyOKMM6IXbimCRN7ggR6QQpdin5ktl8iG0+on28EzupZWmYdRy5aepTTe/KgwOD4ySpFHit80KS+HSl7c/VHsKYqImJ+hN4kpgblpTj6vAmiOugZni4uCdxqGjlxfbmPviy111svKIWFEsJBD/5CVGiVrqLXOcCKsdBoDnaQ51Sm+8Q4fEkQwNUO051kvlCof/UZUzNM6wbXfVf8rdr3c3fZbvhOzaKlzI2bg7Dn8AT6g+2f3c0sTOi9+e9tg10JEe0UolnoYKvlZtDxpkpNzWkAZkRbwSmXn8LuV6T7IFHVRHGw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(376002)(366004)(346002)(39830400003)(396003)(136003)(42606007)(52116002)(1076003)(66946007)(8676002)(33656002)(33716001)(6666004)(83380400001)(6916009)(66476007)(66556008)(508600001)(54906003)(6486002)(316002)(6512007)(38100700002)(8936002)(9686003)(38350700002)(2906002)(6506007)(186003)(44832011)(86362001)(26005)(4326008)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pxItyU5Vvc/Owseq68cLqNXClxjPp6EvuAdAO6oUW2nFa0RQ+e6QrL0dGtub?=
 =?us-ascii?Q?22cTdyjOk2TNKotjHOg4Xq5NeJEpA/+qmsT/zpJTxZ8dYWNEENZGndIms+Fg?=
 =?us-ascii?Q?jdee9RGckTNBntl1JJoTVqzdx4qftSlG/frNFIWz6vMqlmfbYPqKXf2xt6Bh?=
 =?us-ascii?Q?n4Fl7DJJKNJ0lgzU6+971Xuu+6P7y1ox9QuJCLhJF/T31IaN8C9v+Yc+AFX/?=
 =?us-ascii?Q?Ku/WY/9K2JaywcxEtV0P/k6rM7CR8kPUDS1aOTGT6KBI7MtCdIbZB+UEZtwp?=
 =?us-ascii?Q?+Yibn4MZN4K2JHskuWaV/WavtGaZFfyJNg1H70iLbIEX7FktqBntb+VkZMP4?=
 =?us-ascii?Q?pUSgpVoOwTbQe9eV7gQgz67xMuTsZIx0M2bFYbDoOpaek0AmkMndOe7TwYJc?=
 =?us-ascii?Q?4L8e9wkmZRWel9NmcZSwRnymzcmKjOnDlpArbj987j2SV4CqAzqdWZbey2++?=
 =?us-ascii?Q?VJXghbxjOQpOaRcaTXpbAAkGnq4YgTnPX176qR2MGiYuqssySjkYw5TCWmVc?=
 =?us-ascii?Q?pjPFMArpSLb8h9VjH5MoQEFNG/qOap/HZb8ZqjvFnAUgfHmW/IY9KtxW6nRo?=
 =?us-ascii?Q?CejqpG9eRrMwhHYz2yV3xMUKeiGirGvcYtOfSXnL8uF1hjHknoNk2xkmmb7o?=
 =?us-ascii?Q?5yR80B0GErhbz9Dltuu7nna50EyJZr4ttN/YoZRiisVkkBmniLjkGWKNklVt?=
 =?us-ascii?Q?ywWHv+A9aAqcYJMjiLLRxbzzmxMSbh/g3MOhK/qz109KNVXPyXNzhdJrB2Zx?=
 =?us-ascii?Q?BH8YosWrRHm6Gi84MH4IXrEQxbpMLzhbkp2RtcReXcX4OLuJ8kIdLPEjJBFd?=
 =?us-ascii?Q?XF1aBQiWkuy8IVr546kffmQmBBEgsIijzzFmEJKryE3gAkUkzeAGWKs3jrW0?=
 =?us-ascii?Q?Qhc619j4T03dCNS1wrybvrjcisycUkr6dfusVAMOrJP7AdYg065Xq3OM3vIA?=
 =?us-ascii?Q?4gDqpIYew9VhAo2Loh+V5ZKoh4Roiji0MCOt0fWj7lYdZCu70IHfvMXNVC8/?=
 =?us-ascii?Q?/dWSxZ5ZN/gNrUkTVd6EealYBm1uz7IZuPrA4UHDkBy1VOlmDy4tS0M+WvFv?=
 =?us-ascii?Q?+Gi8kap1GBt6eDyiM0ljM7/etoyOZGHtzfmgwunnzUbaU1m3O5agvwak6eU0?=
 =?us-ascii?Q?+AbPqaiEKfuOTv4VpjC/fCL3xfFPbFV498KVz49pyzVwwWwAJ57tc7Dc2N6f?=
 =?us-ascii?Q?mtvQOkS10llseaJy/6/WKnv5iy4qUxRhksjcNOBle2C0QCe3KYcRiem5Hl+v?=
 =?us-ascii?Q?TxXOyeWzChsy/Hs/cHtIBIPuoANfZvX8y3/RU835zW1O8wfKi0LTkT8c9j3T?=
 =?us-ascii?Q?auxHZ9BvXZOyORyJ5hpXtXsW+ycDLveyYSmEUH0Em/vaaem4scvwIhQsUNTq?=
 =?us-ascii?Q?I7MJikhorRK2234yIftWAj3x5ocizJnPDptul1YtHIGBZducG3OdDOwRzZMw?=
 =?us-ascii?Q?GUqToeWJr4FDmvcpLAnlRb9OZNmHuoyfK9G+nbfWyUJwHJxYwwfNdCeAG46U?=
 =?us-ascii?Q?1r2xUt3Ix/7ePRnbUDENHAiWa99Lsw9dbPMU1IdD66uComfsW+5ydt2lvkQf?=
 =?us-ascii?Q?pKJ3HUmLBRWJzcSBfDdXnZHDl2ZPq7kB4KASHg6fR8kRRkLk2CVZI+F1Xbdk?=
 =?us-ascii?Q?672WrzP1BeTwAoivTLBrfAcxYU1EyxI+a5w9JXX588j88EWiO27PGg0givoS?=
 =?us-ascii?Q?pfXs2g=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 35db09b5-94d8-46f4-dc37-08d9d0f9eda2
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2022 09:50:10.7255
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RUH2tHtGgcGC2FS9IoGOiTC6b/hCGZB0Bkb0tk4ApIQdeyteSLNjCyhvS70jNs7IctqV/wVYWOq7hnoYxYC4h7IsDapSH5Z2ldwdeHkICP4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5689
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alexandre, Vladimir, and those with interest of Ocelot chips,

I'm starting this thread to just touch base before I dive into any PCS
changes for Ocelot. I've appreciated all your guidance, and the only
time I felt I've been led astray is when Alexandre told me it should be
easy :-)

I'm at the point where I'm starting to integrate the additional 4 copper
ports of the VSC7512 reference board. They are 4 ports connected through
a QSGMII bus, to a VSC8514 phy.

The 8514 driver seems to be getting invoked, and running just fine.
Also, I was able to slightly modify (hack*)
drivers/phy/mscc/phy-ocelot-serdes.c to work with my in-development
ocelot-mfd. I believe that is what I need to configure the HSIO
registers.

(*the device_is_mfd info I was using falls apart with the
HSIO/syscon/mfd implementation here, sadly. A new probe function would
easily clean that up, but it is more for me to think about... I digress)

I'm using these device tree settings:

    port@4 {
        reg = <4>;
        label = "swp4";
        status = "okay";
        phy-handle = <&sw_phy4>;
        phy-mode = "qsgmii";
        phys = <&serdes 4 SERDES6G(0)>;
    };
    port@5 {
        reg = <5>;
        label = "swp5";
        status = "okay";
        phy-handle = <&sw_phy5>;
        phy-mode = "qsgmii";
        phys = <&serdes 5 SERDES6G(0)>;
    };
...
    serdes: serdes {
        compatible = "mscc,vsc7514-serdes";
        #phy-cells = <2>;
    };
    mdio1: mdio1 {
        compatible = "mscc,ocelot-miim",
        pinctrl-names = "default";
        pinctrl-0 = <&miim1>;
        #address-cells = <1>;
        #size-cells = <0>;

        sw_phy4: ethernet-phy@4 {
            reg = <0x4>;
        };
    };

[    3.886787] libphy: ocelot_ext MDIO bus: probed
[    5.345891] ocelot-ext-switch ocelot-ext-switch: PHY [ocelot-ext-switch-mii:00] driver [Generic PHY] (irq=POLL)
[    5.357341] ocelot-ext-switch ocelot-ext-switch: configuring for phy/internal link mode
[    5.372525] ocelot-ext-switch ocelot-ext-switch swp1 (uninitialized): PHY [ocelot-ext-switch-mii:01] driver [Generic PHY] (irq=POLL)
[    5.388865] ocelot-ext-switch ocelot-ext-switch swp2 (uninitialized): PHY [ocelot-ext-switch-mii:02] driver [Generic PHY] (irq=POLL)
[    5.405086] ocelot-ext-switch ocelot-ext-switch swp3 (uninitialized): PHY [ocelot-ext-switch-mii:03] driver [Generic PHY] (irq=POLL)
[    6.291876] ocelot-ext-switch ocelot-ext-switch swp4 (uninitialized): PHY [ocelot-miim1-mii:04] driver [Microsemi GE VSC8514 SyncE] (irq=POLL)
[    6.471891] ocelot-ext-switch ocelot-ext-switch swp5 (uninitialized): PHY [ocelot-miim1-mii:05] driver [Microsemi GE VSC8514 SyncE] (irq=POLL)
[    6.651895] ocelot-ext-switch ocelot-ext-switch swp6 (uninitialized): PHY [ocelot-miim1-mii:06] driver [Microsemi GE VSC8514 SyncE] (irq=POLL)
[    6.831879] ocelot-ext-switch ocelot-ext-switch swp7 (uninitialized): PHY [ocelot-miim1-mii:07] driver [Microsemi GE VSC8514 SyncE] (irq=POLL)


It seems like that, along with everything in vsc7514_phylink_mac_config,
should be everything I need for operation of the four ports through the
8512. I've added OCELOT_QUIRK_SGMII_PORTS_MUST_BE_UP - but I'm not sure
that's a quirk I need. Plus the only behavior it currently adds is once
the port is up, it never comes back down.

The current behavior I'm seeing is links and rates get detected, packets
appear to be getting transmitted (ethtool stats) but they aren't, and
nothing is received on either end.

Is there something I'm missing with the device tree? Or is this the
purpose of the PCS driver I'm looking into? I'm getting a feeling that
my configuration is correct, and that I need to add SerDes support for
these ports in phylink_mac_config... I noticed that there's the "SGMII
only for now" comment, and when I look at the reference application for
the 7512 there's a comment "external phy uses QSGMII interface" that
appears to set the SGMII_MODE_ENA bit to 0.


Thank you as always for your time,

Colin Foster.
