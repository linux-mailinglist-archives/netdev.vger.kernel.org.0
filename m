Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F11F373B67
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 14:35:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233470AbhEEMgj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 08:36:39 -0400
Received: from mail-mw2nam12on2091.outbound.protection.outlook.com ([40.107.244.91]:39360
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229793AbhEEMgi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 May 2021 08:36:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hGkVmW7kZvUaeAdUOq/5beiH1RxaBlZ1/D6gdF890eLjES7iNJ2LHhyGwXpyKop7dtuQ/cWJsm9jjY+ATV6ZNZuUmUZcMg/UkgudsueXK2LoB1UqONFOO4qrIYuvg17Cau6anSn5x65UYRu+F9De76ja2Q6DFjUSUM/2Ny8Nzm7BX1cIWOitdGDUhpin2wM+bn2xvswlf84Wl4NvfJPranEXF4TbvEmXmqHTSUUHgmu7izA/csMKKmK6tgzbiHXkDhyCjRmo9lK+URDXU4mE4veHcIqy7dTEd7iBR7CdYrN1ioPWTg3+APxzUvnNhvhNyqjoY3IPD0S1g2ssEIWJ9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mXiYWElifnbbh7KYKuP2vjLQ6iAsPirdtwryjRoPTbo=;
 b=a5YIiqlgny8J5cG35pqM8YCSR4R5w0c/bzEnU1a0lUdfHC1lcpVblMmjtfgrqDiPI65jOI3YXd4hYUoqo2kuCNMfuuAIIlosW9JkhdpXjN6DigqZkejI7V3/iN7pVRgLXPz/5lOVJ+92Fs+ZqL+fyKJmf8iNrMHZbfV5P2jmH4l/jBn2CKwdh7NxxTcTzM9S8p2kugejF/rcZIJ1wx36T9O1hrvrMDp5xBAqh8p8kq1H2H5W4zQT8R9fM7J9zTyiezd5/8Yhy2+aX9Q8WUpVldBdLHz3k/tFU1ah7FQYPlqwfxtXDsuVoTg9AP+cjZs2KKoACgekMup1oCWgETRY6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mXiYWElifnbbh7KYKuP2vjLQ6iAsPirdtwryjRoPTbo=;
 b=xYZj6wq2zJWr/nCUJSxKhAONJzb245bezQTD2EmTguh9fkTis3tW1qm3H/kQ35aOJ/sYz9p1hscTeyFruACKrsZ9xFpz2MH1AzkJi+uVEhsN97A5zhhoWO+BCDD4MkvTV+fZ08LrQxWSdoRWlk0nQkRA6dAluEZSuPQ8dU+uOck=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=in-advantage.com;
Received: from MWHSPR01MB355.namprd10.prod.outlook.com (2603:10b6:301:6c::37)
 by MWHPR1001MB2256.namprd10.prod.outlook.com (2603:10b6:301:31::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.26; Wed, 5 May
 2021 12:35:39 +0000
Received: from MWHSPR01MB355.namprd10.prod.outlook.com
 ([fe80::c559:f270:c9b5:a928]) by MWHSPR01MB355.namprd10.prod.outlook.com
 ([fe80::c559:f270:c9b5:a928%6]) with mapi id 15.20.4065.039; Wed, 5 May 2021
 12:35:39 +0000
Date:   Wed, 5 May 2021 05:35:32 -0700
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, Rob Herring <robh+dt@kernel.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "supporter:OCELOT ETHERNET SWITCH DRIVER" 
        <UNGLinuxDriver@microchip.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:OCELOT ETHERNET SWITCH DRIVER" <netdev@vger.kernel.org>
Subject: Re: [RFC PATCH vN net-next 2/2] net: mscc: ocelot: add support for
 VSC75XX SPI control
Message-ID: <20210505123532.GA1738454@euler>
References: <20210504051130.1207550-1-colin.foster@in-advantage.com>
 <20210504051130.1207550-2-colin.foster@in-advantage.com>
 <YJE+prMCIMiQm26Z@lunn.ch>
 <20210504125942.nx5b6j2cy34qyyhm@skbuf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210504125942.nx5b6j2cy34qyyhm@skbuf>
X-Originating-IP: [67.185.175.147]
X-ClientProxiedBy: MWHPR19CA0007.namprd19.prod.outlook.com
 (2603:10b6:300:d4::17) To MWHSPR01MB355.namprd10.prod.outlook.com
 (2603:10b6:301:6c::37)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from euler (67.185.175.147) by MWHPR19CA0007.namprd19.prod.outlook.com (2603:10b6:300:d4::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.24 via Frontend Transport; Wed, 5 May 2021 12:35:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1760409c-270b-4087-2e21-08d90fc249da
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2256:
X-Microsoft-Antispam-PRVS: <MWHPR1001MB22563B871AA3F170D2DD2D2DA4599@MWHPR1001MB2256.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EakdpluwboLTiS7Hv1P0tzN1OevHcyhMPRXF2Uo2k7Z/zvMhg+zR+U96taVLnBZlldBgxiXL+fNuPDXPoCWutaH+6wpvBCkUKoulZFNefYgvA39OGWvzU1mj0+xHLxmv+p791s//GuE7ZXPoH/Jwusnm+d4H5X8e9oeibch1mr75fSPGcwaX8bt6ObXLd05E8nkbeSs7sGGzBRsOxiWABcDLTR7ZjspBYFw706o6QCiWrYOup+JiFnSqYrd+ZMGVF4mK2mlTS986zqv98uVbX20dOkapowpzV5Ut0jVc3a1Qm5Sft3SpQdEwE7gxZidrLDEBcK/oBWZl9Qk2qNehuf9PbXjxBbbXR9DoGTvwQRP+oE86+1II8BxhdjR0eqRgQ1XGpFjEBnU81JL3qXTEQR/nNJdiOb2fIdvPArUTY0NF3v9gSns7LJqMVlOaw7GroYzD6STR9fGYvrrFy+pJvKRgohAdoO1EamKGJxTS/gYsxireGLG6icDmD03Z9njfvYBtLp7BSZcGfpSk9OlCIdyA3HsiWckycuaL/r86ww8wMEW35HqEGsca4y9h3H2+IVNzDy5rSHAm+kgNxnrDoH8Y9W2ox+ZCBCU3+XSzq3As5gRTnVkTHoCrMsHV3kp6aQ9k0Sk1YtvwFWGKtuVuXA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHSPR01MB355.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(39830400003)(346002)(376002)(136003)(478600001)(38350700002)(55016002)(9686003)(44832011)(2906002)(956004)(38100700002)(6666004)(186003)(8676002)(8936002)(16526019)(9576002)(316002)(86362001)(26005)(4326008)(66946007)(66476007)(66556008)(6916009)(7416002)(5660300002)(33656002)(54906003)(33716001)(6496006)(52116002)(83380400001)(1076003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?+01grl+yWr/+8ByuBZDTVqn0bXcqWVbWfG224qKtJx4TSPtx2ugjNyzMGnfH?=
 =?us-ascii?Q?un9NOxVX+8NAvD78L5IycB+Bmpep6R+k0pWxGFmclTJuckgNSeQgQLUz0ed3?=
 =?us-ascii?Q?bPKR9kEoxXv3KchKAacgCOa+Qx7g2SMIUdmmHhjGukX2vVr+pE2pKjAHLDxV?=
 =?us-ascii?Q?+GGXqsxwpxpOsMQtRjUiPXn2YvxuPzdmPzMPgm22jTWdtWMcWAc2DACkWPCz?=
 =?us-ascii?Q?5sp4NJXymanFHPjgpL/R1+Rq/gxjprJ08W3LZkt6fHCHsadDYBIuPtqkeeat?=
 =?us-ascii?Q?XlgL80A2Kse4o6D29MqE9rm/S9diLGW8xfImkxDNWhp86nn/jT7duxzm5aoJ?=
 =?us-ascii?Q?AHcbjTj5N8UyYSGP/qb6kp1qXqP0rVnAxPuR3Ghnxel0vVDrQsNZSXbe8SUW?=
 =?us-ascii?Q?RBTtFPqoW38FvxRt8ghQSPBkiZiZYdI/BqM/Hv89TdGAUVAi8uFFFF1iOROj?=
 =?us-ascii?Q?2pFJYak9yNOie6C24fz+fYfo2bgvLcIntUuN6ZVWPSb1C0858HQ56CgtfPGL?=
 =?us-ascii?Q?xAkD/NvXpzzKep9uVG9IRltb3DbIUv5SUUo8dlqb/QD8tTgUR11q32645nKT?=
 =?us-ascii?Q?elDBC0S6qT87h2DpUeb0vogF3aSD/fl/YfAD7D0EWWweSKc4ZDLX89lh1niR?=
 =?us-ascii?Q?6rIrXmgzl4/fwXVc/DD0PAv282YnV8tYt1Hx37LhjhaXhTw7g8qz4UgraK/N?=
 =?us-ascii?Q?22zgndgVnZs2tDGjBbiWi0fnXXbrpywoWfuTj5cpo5/8Q/Hc4VGK2DRa8E0r?=
 =?us-ascii?Q?Lcv4wIgGtll498v1kbRTjax5rS1E323ugTbny8UREWs0erEekVjQTM8eWp3C?=
 =?us-ascii?Q?kIM4WkdVrunKT/fQUAIsBQLk1Pz5knw5TdmzAw5GPj1rHlloNw29Mp7iRVyl?=
 =?us-ascii?Q?bpL34ZlmqgrxaH/2ItdPUq9KV7oitOt1erlugykJHWdS62vB9/nhJzAcjBnQ?=
 =?us-ascii?Q?vWpuhjrBqbw1rX80KLTGau7H9FyCgjKRVmR47hN94y1Fv9qDFTiIBeAnNt+z?=
 =?us-ascii?Q?m0yw/Q6hmf7IsbWMT+X8iMEOmx4XMVVxE+eBC1DE7Iur0H7clt3+X1+vwHPa?=
 =?us-ascii?Q?tQrXFc1ltxf4pApqGrSsqUMnKNVLZcXwjGUHiRAadpMGVEqQHkSWNHbrVoyd?=
 =?us-ascii?Q?Zns0iOsPUFeuhKK+T7lHytp8qbB/ncj6PcZSVNTEwgCxgIuelSiaVlGPQpz9?=
 =?us-ascii?Q?MV/bA1T3GO1/58kMPg6Y3ZnpFLoRhs3VZUs1QhGqBC4FpDOn+N0zs4RrhGEA?=
 =?us-ascii?Q?VR4cL8KAYn5A/mjuTXQPe+qVUMlSNmXUgXaMjHCA02cobVYrmir18VeKne0E?=
 =?us-ascii?Q?+cqCZIB2k/CoCqaAwSqmPDy3?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1760409c-270b-4087-2e21-08d90fc249da
X-MS-Exchange-CrossTenant-AuthSource: MWHSPR01MB355.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2021 12:35:39.1310
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PyG753LZswfoUsot6xDzDUYne7Z7vWOd24Zs5b+2VjvJQ7nw2574IzCGsuYhUB7Ebu346acY500He1hG4CHSwNVFDeUVAPfyK82u3BQGauU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1001MB2256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir and Andrew,

On Tue, May 04, 2021 at 12:59:43PM +0000, Vladimir Oltean wrote:
> On Tue, May 04, 2021 at 02:31:34PM +0200, Andrew Lunn wrote:
> > On Mon, May 03, 2021 at 10:11:27PM -0700, Colin Foster wrote:
> > > Add support for control for VSC75XX chips over SPI control. Starting with the
> > > VSC9959 code, this will utilize a spi bus instead of PCIe or memory-mapped IO to
> > > control the chip.
> > 
> > Hi Colin
> > 
> > Please fix your subject line for the next version. vN should of been
> > v1. The number is important so we can tell revisions apart.
> 
> Yes, it was my indication to use --subject-prefix="[PATCH vN net-next]",
> I was expecting Colin to replace N with 1, 2, 3 etc but I didn't make
> that clear enough :)
> 

Ha. Yes, I suppose I took that too literally. I'll fix it in vO :)

> > > 
> > > Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> > > ---
> > >  arch/arm/boot/dts/rpi-vsc7512-spi-overlay.dts |  124 ++
> > >  drivers/net/dsa/ocelot/Kconfig                |   11 +
> > >  drivers/net/dsa/ocelot/Makefile               |    5 +
> > >  drivers/net/dsa/ocelot/felix_vsc7512_spi.c    | 1214 +++++++++++++++++
> > >  include/soc/mscc/ocelot.h                     |   15 +
> > 
> > Please split this patch up. The DT overlay will probably be merged via
> > ARM SOC, not netdev. You also need to document the device tree
> > binding, as a separate patch.

I will take this out of the patch, though the feedback is helpful. I
suspect that the end result will be an example in
Documentation/devicetree/bindings/net/dsa/ocelot.txt because there isn't
any commercial hardware available with this functionality, as far as I
know. (If there is I'd love to get my hands on it!)

> > 
> > > +	fragment@3 {
> > > +		target = <&spi0>;
> > > +		__overlay__ {
> > > +			#address-cells = <1>;
> > > +			#size-cells = <0>;
> > > +			cs-gpios = <&gpio 8 1>;
> > > +			status = "okay";
> > > +
> > > +			vsc7512: vsc7512@0{
> > > +				compatible = "mscc,vsc7512";
> > > +				spi-max-frequency = <250000>;
> > > +				reg = <0>;
> > > +
> > > +				ports {
> > > +					#address-cells = <1>;
> > > +					#size-cells = <0>;
> > > +
> > > +					port@0 {
> > > +						reg = <0>;
> > > +						ethernet = <&ethernet>;
> > > +						phy-mode = "internal";
> 
> Additionally, being a completely off-chip switch, are you sure that the
> phy-mode is "internal"?

No, I'm not sure. I don't remember my justification but I had come
across something that made me believe that there needed to be at least
one "internal phy-mode" for DSA to work. This might actually make sense,
however, since it would be the port internal to the on-chip processor.

My hope was that I would've been able to test this with actual hardware
a couple weeks ago and see everything in action. Unfortunately there 
seems to be a hardware issue on my setup I'll need EE support to
troubleshoot.

When the hardware is finally communicating, I plan to do this type of
functional verification. I've been in charge of writing the interface
layer of this chip family in the past, but I have coworkers who are
familiar with the actual operation who's advice I'll seek.

> 
> > > +						fixed-link {
> > > +							speed = <1000>;
> > > +							full-duplex;
> > > +						};
> > > +					};
> > > +
> > > +					port@1 {
> > > +						reg = <1>;
> > > +						label = "swp1";
> > > +						status = "disabled";
> > > +					};
> > > +
> > > +					port@2 {
> > > +						reg = <2>;
> > > +						label = "swp2";
> > > +						status = "disabled";
> > > +					};
> > > +static void vsc7512_phylink_validate(struct ocelot *ocelot, int port,
> > > +				     unsigned long *supported,
> > > +				     struct phylink_link_state *state)
> > > +{
> > > +	struct ocelot_port *ocelot_port = ocelot->ports[port];
> > > +	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = {
> > > +		0,
> > > +	};
> > 
> > This function seems out of place. Why would SPI access change what the
> > ports are capable of doing? Please split this up into more
> > patches. Keep the focus of this patch as being adding SPI support.
> 
> What is going on is that this is just the way in which the drivers are
> structured. Colin is not really "adding SPI support" to any of the
> existing DSA switches that are supported (VSC9953, VSC9959) as much as
> "adding support for a new switch which happens to be controlled over
> SPI" (VSC7512).
> The layering is as follows:
> - drivers/net/dsa/ocelot/felix_vsc7512_spi.c: deals with the most
>   hardware specific SoC support. The regmap is defined here, so are the
>   port capabilities.
> - drivers/net/dsa/ocelot/felix.c: common integration with DSA
> - drivers/net/ethernet/mscc/ocelot*.c: the SoC-independent hardware
>   support.
> 
> I'm not actually sure that splitting the port PHY mode support in a
> separate patch is possible while keeping functional intermediate
> results. But I do agree about the rest, splitting the device tree
> changes, etc.
