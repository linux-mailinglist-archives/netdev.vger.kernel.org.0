Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AD0D4535DE
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 16:33:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238314AbhKPPfR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 10:35:17 -0500
Received: from mail-mw2nam12on2123.outbound.protection.outlook.com ([40.107.244.123]:24673
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238306AbhKPPfF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Nov 2021 10:35:05 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ij+F+KE0/Gtp+j2gOxK0gmiQBRp6U8u8q6UTcomuQUbE/mrlF5ZM0F9knrItcUlM8kUrSeLN9QL1fRoqhoH4xKoXL10TUql/hFxj98XdOhcyLpWKhDNJaYzUpaWdMs9/MNC2AHITLdbJ90icxLjI41yAA5AuCuksFQu3w9+pweMqEXDowiLw5a8e7gW9tf6+PaTkkpRLr32z71pYP5QdFBr/nn6j1q/oql97eIfxSsIEKECMzIJ1OhNbkFNVIhkZN2Sw6UJDDJSCCbC/c1UVodbrulTnEYhmRdJPeybSHrRxX1yFeZcD7URCIAemZvZT9YkRqgqkVaV1Y0GyJPiybA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tq7ffUK1RMN78mX8DR++EdgVzEdJD0Ps0WakrR/O9zE=;
 b=Iyk6HghalrprA2CflwKJmKHo79nqKR5S8tWEwWBUhy25PmpdxIrYhOf5b0o9eMkNjpiwDYQlVWW1JQpn+v/Y4eEa6DEM8t9XF1SYI3PFyvZ5ZbCMSP2S1D/zLoI5E7nSK28m7VtCHHqAUqF6xljzTN04pnGAU7BDQhWypAjMp73yg56ghNvmKnM1vWWsx4V0/0LraxOQeBuHhrokAHc6eyv2yrKuPebEa3HzvFEk9uHg6Ba+2om96bfeO86VfespEwf30LVymyh6gQ97YQcuvMqhg/jAMnqnmHWPIyMaOzjrGS5mGQuFl5SXElj5KcrKQ/jM+ovQ3/cnfzRS7kqnBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tq7ffUK1RMN78mX8DR++EdgVzEdJD0Ps0WakrR/O9zE=;
 b=Dx8puCoMGjnIFNe9xxZ7gOCQR9cTLw7oVlJIRw0G6cgQjs+0Xe3dw7L4j1r1bGtTJMNFSlMflA5wA3Ne1PDB/pEagp7jUy5npsgqJ6JYQcY97zzInIczgj3diLQw4BLs3oCfP9bXu0tUBk1LiBifuNuG7PgnZbUq+v0amSh5wpM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by CO1PR10MB4403.namprd10.prod.outlook.com
 (2603:10b6:303:9a::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.26; Tue, 16 Nov
 2021 15:32:05 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f%5]) with mapi id 15.20.4713.019; Tue, 16 Nov 2021
 15:32:05 +0000
Date:   Tue, 16 Nov 2021 07:32:08 -0800
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: Re: [RFC PATCH v4 net-next 00/23] add support for VSC75XX control
 over SPI
Message-ID: <20211116153208.GB8651@DESKTOP-LAINLKC.localdomain>
References: <20211116062328.1949151-1-colin.foster@in-advantage.com>
 <20211116111059.sqthwmkiq2ng3t2l@skbuf>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211116111059.sqthwmkiq2ng3t2l@skbuf>
X-ClientProxiedBy: MWHPR22CA0032.namprd22.prod.outlook.com
 (2603:10b6:300:69::18) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
Received: from DESKTOP-LAINLKC.localdomain (96.93.101.165) by MWHPR22CA0032.namprd22.prod.outlook.com (2603:10b6:300:69::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19 via Frontend Transport; Tue, 16 Nov 2021 15:32:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 05b7caf7-1321-4470-9c33-08d9a9163e62
X-MS-TrafficTypeDiagnostic: CO1PR10MB4403:
X-Microsoft-Antispam-PRVS: <CO1PR10MB4403B6036C98449AC7C40F45A4999@CO1PR10MB4403.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9vxwguypewf4oTKYh0b6ALx0ENKuUKMRqG/s7HcZP1rvQufs+oxjM6kGYz+tgsPmgm9igOjs7zz2n8CAYkCXqxY7Ribj0NXTMaPhisUqarsqVgWNIR9rV+DOCLlNiekFa0inSDFpqUr9zuzz43q5z45FM1cyKPWNPFbZLVgmDP2AAiU1Ug6lv/7XnRs/Wj4sfWP8n6G2/3gXySiB+W4lueYoZPBINr0r339rOY8nZbU8oMfSAR5OELaM2EoLpO/toMEiKhJCtqMbEXVClVoWp8EfHKqPEE3Pu/yckSstGK1hsg2SSj1bVsD3SzQxoO83boiZRl59no1snhClI5b0DFdEurBlzHXMoUqTcmozSugZpaf4zC6Aw4MjntMSQaZv0uvk7nU4XmmiBHF5CoYTo42G6oAoPc4Np6w09whjKUV2p2BtV5B1SC7hiwWX2lBvz6QI6rWaDusX/EElFifNpfBA4wbT0H/r2ZkyVS5osV+wgI2Sjtdl6BqFpllXvjvziyO+97vEWWDJpe3vbf4AnNOoGUAwQ/Di43pMxFM/ejM6Bm14QGIbQltL1COb/VdYI7Bp6qf6Uya9h28nz/hFJXRkZurAP2l0atrKyawXYhGpzxjd7S5Ut/YZsw7NdGKL9uDfsyAQM9zip58EiTQlkakwbL7aWLuYb3ik16Da4JOm0RoR2O6lNI5J1Kr15I9N7uZLWRErUxwcGdmemPlSyA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(39830400003)(396003)(346002)(376002)(136003)(30864003)(186003)(1076003)(4326008)(66946007)(2906002)(26005)(54906003)(316002)(66476007)(83380400001)(7416002)(508600001)(33656002)(38350700002)(7696005)(6506007)(52116002)(86362001)(5660300002)(44832011)(956004)(9686003)(6916009)(55016002)(66556008)(8676002)(8936002)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eDBFZHNWV3VGOGtqZHhIbjFQQVZrV25tOU5aRmdQZitJdmJQTFE5Tjk4MjZ5?=
 =?utf-8?B?TDBVOVdyQ2ZSd1RybEg1L0x3R0VzTTZZcG1RWTlEWHlCME03SUx0MVZwTzdn?=
 =?utf-8?B?TDR6ZmU5TThVMVNvaDB4YndvcWxXMkpaa3ptM0VJa0hiZm9LNmRkZGRnblRJ?=
 =?utf-8?B?UmF1dUllcyttWHF3MytNamlTcklaWGtaVG4xTmpVT0pIWnU2OHpiTDBOekNs?=
 =?utf-8?B?alFlVCtKWTNZWVJWNGVaM0FrOEhvUUFlMHU5TWR1eDlDQ3FFcUtWdDZlZXVO?=
 =?utf-8?B?S0M3dHpVU0w4dWJ3NDRFVThIR0NUS0cvQzhEdnJrc0d5cVlzTC9LUy85UlNj?=
 =?utf-8?B?Ti9WRzgydHZHVmRrcUZEM0F1TnZFUFlsNEtldThoTmlxZUhESVBlU21mMGRh?=
 =?utf-8?B?NG5xS0V0Qlk4S1dkTEgzdWNlNWM0YzJVMVRvTEsyc21JU1dWSmNjbnkzQm4z?=
 =?utf-8?B?NEhEejFSS2Y4dHBxd0dGUlZXc2dnU2NyYzd5c3RUNE50amU4U2x5WVBxY3FK?=
 =?utf-8?B?Y3JQSWZ6cmpWeTA1SmF1ZlB4b2VtWFgzcVV6ZzVUUDY5dHQvR3JoaHQ5NnZX?=
 =?utf-8?B?R3ZYYTEvWlRTMjl4M3QrZkVHTG1sVGZ5d3g3MTZoWElKNFJmMStranpLVk1C?=
 =?utf-8?B?TU9OQlQ5cEJzWUEyeG15ZFpucDY4dHU2WnVjWE1IWGI0aTdGNHFNajdQQXhT?=
 =?utf-8?B?Z2pwWDk4cndRZUtOL1V1VURDR3BuYTZ6bmM2anM1Q204V2xxR0Yvb3lPQTZ5?=
 =?utf-8?B?ZnJOeWdaU0xaQzIxTjZLNmcreXZZbmZsYURxQlZHcUtQd3ZHcWhKK2ZabGFG?=
 =?utf-8?B?L21mY0RJMnpyMStEZDhmWDRxZEN4RE5NZjg0amFMQ2sxcTVRWGFCdEk1R0pT?=
 =?utf-8?B?WURJM0lVVGtkTFJKOWlOdG5ob3hnakFNZzNxdk1Hd0JkTmF4RGdFbVd4WU1S?=
 =?utf-8?B?SXlLQUp4SzdhSXAweC9oUW5qNHU0a2MvUE9CQ3J0V3AwdUtxcER1S0REWUw1?=
 =?utf-8?B?dWFUd2ZSUkNFWkhoc0xrQ2hoclhUQU9KZW5BeG1ucit5S3lJeEszeVBVVTF3?=
 =?utf-8?B?VXEwT1VSVlBDeEJZUnllM1pnNnRGNTdKbHk1WldLYmRKUUVVWkxEaWZKY0pK?=
 =?utf-8?B?c00vaDJwVWQ4RVNiMkdYbDBOejBoYVoxb1lES2xuQXcwZUd5Mlp6TzFHNjh5?=
 =?utf-8?B?OURwV0U5cHBLdFp6N25PS2JXVkRXUTNwWjZSZnUrSnpiaFhrR1RIS04xZVFZ?=
 =?utf-8?B?V3VCWCtlMUIvcURSZE5QQ1RkakI1dG90Y3gycGRlSVhYN08wcjQ5S0YvQTBS?=
 =?utf-8?B?OXJlMDVNUnJGalVEMTVhaFhGbWZmOXhVbEFhY1pOZk5iZlBRbWdLTnFxYjlp?=
 =?utf-8?B?SUpCb0RpQ01DUTB3a2gxZmp5N2lJS1hIL21BYmZhNHBnZUVlYTdlVndBZmxY?=
 =?utf-8?B?MGF5TkYrZGJBU2JaSXZOOW0vbFkzZFdGVXZLUFQ1S1V5VnUyV2FFemhXdEMz?=
 =?utf-8?B?NmVRbkMwNm9WT25SaEF5cDF1RDRqZ3hUZEs5SkEyUjdNQmtkOThLeU9IN1No?=
 =?utf-8?B?c01pMzdpamphZW9mSTZHOFNmZlJ0bUhNdzE0UnFwdmZKWlQrU1R2QmZZcnJN?=
 =?utf-8?B?WE5JWW1pMTBaZ2RwcjI3R2dMVlVZTWNkZHFlMU1peGRPWUxUdlUwdFlUbzhY?=
 =?utf-8?B?SmRXTUw2SGxiOVY3aENzZ3NnakpTVkRTRG9qT3V2Y0xpQzBMMDB1Y0dkM0x3?=
 =?utf-8?B?MUdKczJENXlBNHRwb1BhdDBkbGhGMFROSE1aTU5JK0ZxazVndUF4UzhiSkpr?=
 =?utf-8?B?R1FlTFo3cU5XdTM0RDFLK2pySUhYVFhGWUFFRjN1VVFLbDJzOEFHNVRuL1U4?=
 =?utf-8?B?US9qODZXVld2L3VwZyt6SmorcTRNTGs1ZFQ3K09WUG1Dd2s5bE4vdHRIRDJl?=
 =?utf-8?B?aHljd2VVczRPL0JyVmJKdThKeEFQVVVYaGQzR0ZsSXdzYk5jb2Z0QXV4elBG?=
 =?utf-8?B?bFE2TmovNm1TemNaWmRxbk5QTXdlM1EwNFNIVTN0TFJKZDN5ZStqR2VCQllk?=
 =?utf-8?B?aU9YL3UrKzQzaS9IdTd1aWdsVFVEay9FZld6bzN4YnBhTjR0UFAvM0d2VC9q?=
 =?utf-8?B?Uk1uanpOV20yeXBlRWtyOVJrdVRucjlMOEpRcFpWSkFKQWR2WFZ0S01iaCtB?=
 =?utf-8?B?TEVjd05TdlBjYVdmWGJjbnA3S0ZINkNEdjRhZUl3MGFQVkt3TXRqUjQwcFRm?=
 =?utf-8?Q?21CQJ5u/JXzGDzdKLQBHIRI03OXMurKDwhmdrwiAgA=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 05b7caf7-1321-4470-9c33-08d9a9163e62
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2021 15:32:05.5327
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e/GAwBpVzMoN1OOf5NeB8flq9Md7J1XqvH+bp+p5YO+B3C26Tjvkmt0U8HFJtgCSvpyxFJbz4xgR0sBBYrzHNvIIwwz2syTRsfadUMWWLP4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4403
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 16, 2021 at 11:10:59AM +0000, Vladimir Oltean wrote:
> On Mon, Nov 15, 2021 at 10:23:05PM -0800, Colin Foster wrote:
> > My apologies for this next RFC taking so long. Life got in the way.
> > 
> > 
> > The patch set in general is to add support for the VSC7511, VSC7512,
> > VSC7513 and VSC7514 devices controlled over SPI. The driver is
> > relatively functional for the internal phy ports (0-3) on the VSC7512.
> > As I'll discuss, it is not yet functional for other ports yet.
> > 
> > I still think there are enough updates to bounce by the community
> > in case I'm terribly off base or doomed to chase my tail.
> > 
> 
> I would try to get rid of some of the patches now, instead of gathering
> a larger and larger pile. Here is a list of patches that I think could
> be submitted right away (possibly as part of independent series;
> parallelize as much as you can):
> 
> [01/23] net: dsa: ocelot: remove unnecessary pci_bar variables
> [02/23] net: mdio: mscc-miim: convert to a regmap implementation
> [03/23] net: dsa: ocelot: seville: utilize of_mdiobus_register
> [04/23] net: dsa: ocelot: felix: switch to mdio-mscc-miim driver for indirect mdio …
> [05/23] net: dsa: ocelot: felix: Remove requirement for PCS in felix devices
> [06/23] net: dsa: ocelot: felix: add interface for custom regmaps
> [07/23] net: dsa: ocelot: felix: add per-device-per-port quirks
> [08/23] net: mscc: ocelot: split register definitions to a separate file
> [09/23] net: mscc: ocelot: expose ocelot wm functions
> [18/23] net: phy: lynx: refactor Lynx PCS module to use generic phylink_pcs
> [19/23] net: dsa: felix: name change for clarity from pcs to mdio_device
> [20/23] net: dsa: seville: name change for clarity from pcs to mdio_device
> [21/23] net: ethernet: enetc: name change for clarity from pcs to mdio_device
> [22/23] net: pcs: lynx: use a common naming scheme for all lynx_pcs variables
> 
> Now that you've submitted them all already, let's wait for some feedback
> before resending smaller chunks.

Thank you for your response as always!

This will make v5 a lot easier for me to keep straight. I think this one
might also be a good one to submit earlier, since it actually does
change behavior:

pinctrl: ocelot: update pinctrl to automatic base address

I'd probably want to drag this trivial one along as well:

pinctrl: ocelot: combine get resource and ioremap into single call

> 
> > 
> > The main changes for V4 are trying to get pinctrl-ocelot and
> > pinctrl-microchip-sgpio functional. Without pinctrl-ocelot,
> > communication to external phys won't work. Without communication to
> > external phys, PCS ports 4-7 on the dev board won't work. Nor will any
> > fiber ports. 
> > 
> > 
> > The hardware setup I'm using for development is a beaglebone black, with
> > jumpers from SPI0 to the microchip VSC7512 dev board. The microchip dev 
> > board has been modified to not boot from flash, but wait for SPI. An
> > ethernet cable is connected from the beaglebone ethernet to port 0 of
> > the dev board.
> > 
> > 
> > The device tree I'm using for the VSC7512 is below. Note that ports 4-7
> > are still not expected to work, but left in as placeholders for when
> > they do.
> > 
> > 
> > &spi0 {
> > 	#address-cells = <1>;
> > 	#size-cells = <0>;
> > 	status = "okay";
> > 
> > 	ethernet-switch@0{
> > 		 compatible = "mscc,vsc7512";
> > 		 spi-max-frequency = <250000>;
> 
> Can't go faster than 250 KHz? That's sad.

Haven't tried faster speeds. During the early days there was an error on
my setup due to too long of wires. Crosstalk / capacitance... I slowed
the SPI bus to a crawl while debugging that and never turned it back up. 

If it'll help anyone: transitions on the MOSI I believe were causing
glitches on the CS line. This made the VSC7512 sad.

> 
> > 		 reg = <0>;
> > 
> > 		 ports {
> 
> there's an extra preceding space here, for all 4 lines from "compatible" to "ports".

I'll fix it. Thanks.

> 
> > 			#address-cells = <1>;
> > 			#size-cells = <0>;
> > 
> > 			port@0 {
> > 				reg = <0>;
> > 				label = "cpu";
> > 				status = "okay";
> > 				ethernet = <&mac_sw>;
> > 				phy-handle = <&sw_phy0>;
> > 				phy-mode = "internal";
> > 			};
> > 
> > 			port@1 {
> > 				reg = <1>;
> > 				label = "swp1";
> > 				status = "okay";
> > 				phy-handle = <&sw_phy1>;
> > 				phy-mode = "internal";
> > 			};
> > 
> > 			port@4 {
> > 				reg = <4>;
> > 				label = "swp4";
> > 				status = "okay";
> > 				phy-handle = <&sw_phy4>;
> > 				phy-mode = "sgmii";
> > 			};
> > 		};
> > 
> > 		mdio {
> > 			#address-cells = <1>;
> > 			#size-cells = <0>;
> > 
> > 			sw_phy0: ethernet-phy@0 {
> > 				#address-cells = <1>;
> > 				#size-cells = <0>;
> 
> PHY nodes don't need #address-cells and #size-cells.

Thank you. I'll remove these and the ones below.

> 
> > 				reg = <0x0>;
> > 			};
> > 
> > 			sw_phy1: ethernet-phy@1 {
> > 				#address-cells = <1>;
> > 				#size-cells = <0>;
> > 				reg = <0x1>;
> > 			};
> > 
> > 			sw_phy2: ethernet-phy@2 {
> > 				#address-cells = <1>;
> > 				#size-cells = <0>;
> > 				reg = <0x2>;
> > 			};
> > 
> > 			sw_phy3: ethernet-phy@3 {
> > 				#address-cells = <1>;
> > 				#size-cells = <0>;
> > 				reg = <0x3>;
> > 			};
> > 
> > 			sw_phy4: ethernet-phy@4 {
> > 				#address-cells = <1>;
> > 				#size-cells = <0>;
> > 				reg = <0x4>;
> > 			};
> > 
> > 			sw_phy5: ethernet-phy@5 {
> > 				#address-cells = <1>;
> > 				#size-cells = <0>;
> > 				reg = <0x5>;
> > 			};
> > 
> > 			sw_phy6: ethernet-phy@6 {
> > 				#address-cells = <1>;
> > 				#size-cells = <0>;
> > 				reg = <0x6>;
> > 			};
> > 
> > 			sw_phy7: ethernet-phy@7 {
> > 				#address-cells = <1>;
> > 				#size-cells = <0>;
> > 				reg = <0x7>;
> > 			};
> > 		};
> > 
> > 		gpio: pinctrl {
> > 			compatible = "mscc,ocelot-pinctrl";
> > 			#address-cells = <1>;
> > 			#size-cells = <0>;
> 
> I don't think that #address-cells and #size-cells are needed here, since
> "led-shift-reg-pins" does not have any address unit.
> 
> > 			#gpio_cells = <2>;
> > 			gpio-ranges = <&gpio 0 0 22>;
> > 
> > 			led_shift_reg_pins: led-shift-reg-pins {
> > 				pins = "GPIO_0", "GPIO_1", "GPIO_2", "GPIO_3";
> > 				function = "sg0";
> > 			};
> > 		};
> > 
> > 		sgpio: sgpio {
> > 			compatible = "mscc,ocelot-sgpio";
> > 			#address-cells = <1>;
> > 			#size-cells = <0>;
> > 			bus-frequency=<12500000>;
> > 			clocks = <&ocelot_clock>;
> > 			microchip,sgpio-port-ranges = <0 31>;
> > 
> > 			sgpio_in0: sgpio@0 {
> > 				compatible = "microchip,sparx5-sgpio-bank";
> > 				reg = <0>;
> > 				gpio-controller;
> > 				#gpio-cells = <3>;
> > 				ngpios = <32>;
> > 			};
> > 
> > 			sgpio_out1: sgpio@1 {
> > 				compatible = "microchip,sparx5-sgpio-bank";
> > 				reg = <1>;
> > 				gpio-controller;
> > 				gpio-cells = <3>;
> > 				ngpios = <32>;
> > 			};
> > 		};
> > 	};
> > };
> > 
> > 
> > My main focus is getting the ocelot-pinctrl driver fully functional. My
> > current hope is that it would correctly set GPIO pins 0-3 into the "sg0"
> > state. That is not the case right now, and I'll be looking into why. The
> > behavior I'm hoping for is to be able to configure the sgpio LEDs for
> > activity at the very least. Link status would be a bonus.
> > 
> > 
> > I do have pinctrl by way of debugfs and sysfs. There aren't any debug
> > LEDs that are attached to unused pins, unfortunately. That would've been
> > really helpful. So there's a key takeaway for dev-board manufacturers.
> > 
> > 
> > As you'll see, the main changes to the three drivers I'm utilizing
> > (mscc_miim, pinctrl-ocelot, and pinctrl-microchip-sgpio) follow a
> > similar path. First, convert everything to regmap. Second, expose
> > whatever functions are necessary to fully utilize an external regmap.
> > 
> > 
> > One thing to note: I've been following a pattern of adding "offset"
> > variables to these drivers. I'm looking for feedback here, because I
> > don't like it - however I feel like it is the "least bad" interface I
> > could come up with. 
> > 
> > 
> > Specifically, ocelot has a regmap for GCB. ocelot-pinctrl would create a
> > smaller regmap at an address of "GCB + 0x34".
> > 
> > 
> > There are three options I saw here:
> > 1. Have vsc7512_spi create a new regmap at GCB + 0x34 and pass that to
> > ocelot-pinctrl
> > 2. Give ocelot-pinctrl the concept of a "parent bus" by which it could
> > request a regmap. 
> > 3. Keep the same GCB regmap, but pass in 0x34 as an offset.
> > 
> > 
> > I will admit that option 2 sounds very enticing, but I don't know if
> > that type of interaction exists. If not, implementing it is probably
> > outside the scope of a first patch set. As such, I opted for option 3.
> 
> I think that type of interaction is called "mfd", potentially even "syscon".

Before diving in, I'd come across mfd and thought that might be the
answer. I'll reconsider it now that I have several months of staring at
kernel code under my belt. Maybe an mfd that does SPI setup and chip
resetting. Then I could remove all SPI code from ocelot_vsc7512_spi.

> 
> > 
> > 
> > Version 4 also fixes some logic for MDIO probing. It wasn't using the
> > device tree by way of of_mdiobus_register. Now it is.
> > 
> > 
> > The relevant boot log for the switch / MDIO bus is here. As expected,
> > devices 4-7 are missing. If nothing else, that is telling me that the
> > device tree is working.
> > 
> > [    4.005195] mdio_bus spi0.0-mii:03: using lookup tables for GPIO lookup
> > [    4.005205] mdio_bus spi0.0-mii:03: No GPIO consumer reset found
> > [    4.006586] mdio_bus spi0.0-mii: MDIO device at address 4 is missing.
> > [    4.014333] mdio_bus spi0.0-mii: MDIO device at address 5 is missing.
> > [    4.022009] mdio_bus spi0.0-mii: MDIO device at address 6 is missing.
> > [    4.029573] mdio_bus spi0.0-mii: MDIO device at address 7 is missing.
> > [    8.386624] vsc7512 spi0.0: PHY [spi0.0-mii:00] driver [Generic PHY] (irq=POLL)
> > [    8.397222] vsc7512 spi0.0: configuring for phy/internal link mode
> > [    8.419484] vsc7512 spi0.0 swp1 (uninitialized): PHY [spi0.0-mii:01] driver [Generic PHY] (irq=POLL)
> > [    8.437278] vsc7512 spi0.0 swp2 (uninitialized): PHY [spi0.0-mii:02] driver [Generic PHY] (irq=POLL)
> > [    8.452867] vsc7512 spi0.0 swp3 (uninitialized): PHY [spi0.0-mii:03] driver [Generic PHY] (irq=POLL)
> > [    8.465007] vsc7512 spi0.0 swp4 (uninitialized): no phy at 4
> > [    8.470721] vsc7512 spi0.0 swp4 (uninitialized): failed to connect to PHY: -ENODEV
> > [    8.478388] vsc7512 spi0.0 swp4 (uninitialized): error -19 setting up PHY for tree 0, switch 0, port 4
> > [    8.489636] vsc7512 spi0.0 swp5 (uninitialized): no phy at 5
> > [    8.495371] vsc7512 spi0.0 swp5 (uninitialized): failed to connect to PHY: -ENODEV
> > [    8.502996] vsc7512 spi0.0 swp5 (uninitialized): error -19 setting up PHY for tree 0, switch 0, port 5
> > [    8.514186] vsc7512 spi0.0 swp6 (uninitialized): no phy at 6
> > [    8.519882] vsc7512 spi0.0 swp6 (uninitialized): failed to connect to PHY: -ENODEV
> > [    8.527539] vsc7512 spi0.0 swp6 (uninitialized): error -19 setting up PHY for tree 0, switch 0, port 6
> > [    8.538716] vsc7512 spi0.0 swp7 (uninitialized): no phy at 7
> > [    8.544451] vsc7512 spi0.0 swp7 (uninitialized): failed to connect to PHY: -ENODEV
> > [    8.552079] vsc7512 spi0.0 swp7 (uninitialized): error -19 setting up PHY for tree 0, switch 0, port 7
> > [    8.571962] device eth0 entered promiscuous mode
> > [    8.576684] DSA: tree 0 setup
> > [   10.490093] vsc7512 spi0.0: Link is Up - 100Mbps/Full - flow control off
> > 
> > 
> > Much later on, I created a bridge with STP (and two ports jumped
> > together) as a test. Everything seems to be working as expected. 
> > 
> > 
> > [59839.920340] cpsw-switch 4a100000.switch: starting ndev. mode: dual_mac
> > [59840.013636] SMSC LAN8710/LAN8720 4a101000.mdio:00: attached PHY driver (mii_bus:phy_addr=4a101000.mdio:00, irq=POLL)
> > [59840.031444] 8021q: adding VLAN 0 to HW filter on device eth0
> > [59840.057406] vsc7512 spi0.0 swp1: configuring for phy/internal link mode
> > [59840.089302] vsc7512 spi0.0 swp2: configuring for phy/internal link mode
> > [59840.121514] vsc7512 spi0.0 swp3: configuring for phy/internal link mode
> > [59840.167589] br0: port 1(swp1) entered blocking state
> > [59840.172818] br0: port 1(swp1) entered disabled state
> > [59840.191078] device swp1 entered promiscuous mode
> > [59840.224855] br0: port 2(swp2) entered blocking state
> > [59840.229893] br0: port 2(swp2) entered disabled state
> > [59840.245844] device swp2 entered promiscuous mode
> > [59840.270839] br0: port 3(swp3) entered blocking state
> > [59840.276003] br0: port 3(swp3) entered disabled state
> > [59840.291674] device swp3 entered promiscuous mode
> > [59840.663239] vsc7512 spi0.0: Link is Down
> > [59841.691641] vsc7512 spi0.0: Link is Up - 100Mbps/Full - flow control off
> > [59842.167897] cpsw-switch 4a100000.switch eth0: Link is Up - 100Mbps/Full - flow control off
> > [59842.176481] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
> > [59843.216121] vsc7512 spi0.0 swp1: Link is Up - 1Gbps/Full - flow control rx/tx
> > [59843.231076] IPv6: ADDRCONF(NETDEV_CHANGE): swp1: link becomes ready
> > [59843.237593] br0: port 1(swp1) entered blocking state
> > [59843.242629] br0: port 1(swp1) entered listening state
> > [59843.301447] vsc7512 spi0.0 swp3: Link is Up - 1Gbps/Full - flow control rx/tx
> > [59843.309027] IPv6: ADDRCONF(NETDEV_CHANGE): swp3: link becomes ready
> > [59843.315544] br0: port 3(swp3) entered blocking state
> > [59843.320545] br0: port 3(swp3) entered listening state
> > [59845.042058] br0: port 3(swp3) entered blocking state
> > [59858.401566] br0: port 1(swp1) entered learning state
> > [59871.841910] br0: received packet on swp1 with own address as source address (addr:24:76:25:76:35:37, vlan:0)
> > [59873.761495] br0: port 1(swp1) entered forwarding state
> > [59873.766703] br0: topology change detected, propagating
> > [59873.776278] IPv6: ADDRCONF(NETDEV_CHANGE): br0: link becomes ready
> > [59902.561908] br0: received packet on swp1 with own address as source address (addr:24:76:25:76:35:37, vlan:0)
> > [59926.494446] vsc7512 spi0.0 swp2: Link is Up - 1Gbps/Full - flow control rx/tx
> > [59926.501959] IPv6: ADDRCONF(NETDEV_CHANGE): swp2: link becomes ready
> > [59926.508702] br0: port 2(swp2) entered blocking state
> > [59926.513868] br0: port 2(swp2) entered listening state
> > [59941.601540] br0: port 2(swp2) entered learning state
> > [59956.961493] br0: port 2(swp2) entered forwarding state
> > [59956.966711] br0: topology change detected, propagating
> > [59968.481839] br0: received packet on swp1 with own address as source address (addr:24:76:25:76:35:37, vlan:0)
> > 
> > 
> > In order to make this work, I have modified the cpsw driver, and now the
> > cpsw_new driver, to allow for frames over 1500 bytes. Otherwise the
> > tagging protocol will not work between the beaglebone and the VSC7512. I
> > plan to eventually try to get those changes in mainline, but I don't
> > want to get distracted from my initial goal.
> > 
> > 
> > RFC history:
> > v1 (accidentally named vN)
> > 	* Initial architecture. Not functional
> > 	* General concepts laid out
> > 
> > v2
> > 	* Near functional. No CPU port communication, but control over all
> > 	external ports
> > 	* Cleaned up regmap implementation from v1
> > 
> > v3
> > 	* Functional
> > 	* Shared MDIO transactions routed through mdio-mscc-miim
> > 	* CPU / NPI port enabled by way of vsc7512_enable_npi_port /
> > 	felix->info->enable_npi_port
> > 	* NPI port tagging functional - Requires a CPU port driver that supports
> > 	frames of 1520 bytes. Verified with a patch to the cpsw driver
> > 
> > v4
> >     * Functional
> >     * Device tree fixes
> >     * Add hooks for pinctrl-ocelot - some functionality by way of sysfs
> >     * Add hooks for pinctrl-microsemi-sgpio - not yet fully functional
> >     * Remove lynx_pcs interface for a generic phylink_pcs. The goal here
> >     is to have an ocelot_pcs that will work for each configuration of
> >     every port. 
> > 
> > 
> > 
> > Colin Foster (23):
> >   net: dsa: ocelot: remove unnecessary pci_bar variables
> >   net: mdio: mscc-miim: convert to a regmap implementation
> >   net: dsa: ocelot: seville: utilize of_mdiobus_register
> >   net: dsa: ocelot: felix: switch to mdio-mscc-miim driver for indirect
> >     mdio access
> >   net: dsa: ocelot: felix: Remove requirement for PCS in felix devices
> >   net: dsa: ocelot: felix: add interface for custom regmaps
> >   net: dsa: ocelot: felix: add per-device-per-port quirks
> >   net: mscc: ocelot: split register definitions to a separate file
> >   net: mscc: ocelot: expose ocelot wm functions
> >   pinctrl: ocelot: combine get resource and ioremap into single call
> >   pinctrl: ocelot: update pinctrl to automatic base address
> >   pinctrl: ocelot: convert pinctrl to regmap
> >   pinctrl: ocelot: expose ocelot_pinctrl_core_probe interface
> >   pinctrl: microchip-sgpio: update to support regmap
> >   device property: add helper function fwnode_get_child_node_count
> >   pinctrl: microchip-sgpio: change device tree matches to use nodes
> >     instead of device
> >   pinctrl: microchip-sgpio: expose microchip_sgpio_core_probe interface
> >   net: phy: lynx: refactor Lynx PCS module to use generic phylink_pcs
> >   net: dsa: felix: name change for clarity from pcs to mdio_device
> >   net: dsa: seville: name change for clarity from pcs to mdio_device
> >   net: ethernet: enetc: name change for clarity from pcs to mdio_device
> >   net: pcs: lynx: use a common naming scheme for all lynx_pcs variables
> >   net: dsa: ocelot: felix: add support for VSC75XX control over SPI
> > 
> >  drivers/base/property.c                       |  20 +-
> >  drivers/net/dsa/ocelot/Kconfig                |  16 +
> >  drivers/net/dsa/ocelot/Makefile               |   7 +
> >  drivers/net/dsa/ocelot/felix.c                |  29 +-
> >  drivers/net/dsa/ocelot/felix.h                |  10 +-
> >  drivers/net/dsa/ocelot/felix_mdio.c           |  54 +
> >  drivers/net/dsa/ocelot/felix_mdio.h           |  13 +
> >  drivers/net/dsa/ocelot/felix_vsc9959.c        |  38 +-
> >  drivers/net/dsa/ocelot/ocelot_vsc7512_spi.c   | 946 ++++++++++++++++++
> >  drivers/net/dsa/ocelot/seville_vsc9953.c      | 136 +--
> >  .../net/ethernet/freescale/dpaa2/dpaa2-mac.c  |  12 +-
> >  .../net/ethernet/freescale/dpaa2/dpaa2-mac.h  |   3 +-
> >  .../net/ethernet/freescale/enetc/enetc_pf.c   |  27 +-
> >  .../net/ethernet/freescale/enetc/enetc_pf.h   |   4 +-
> >  drivers/net/ethernet/mscc/Makefile            |   3 +-
> >  drivers/net/ethernet/mscc/ocelot.c            |   8 +
> >  drivers/net/ethernet/mscc/ocelot_devlink.c    |  31 +
> >  drivers/net/ethernet/mscc/ocelot_vsc7514.c    | 548 +---------
> >  drivers/net/ethernet/mscc/vsc7514_regs.c      | 522 ++++++++++
> >  drivers/net/mdio/mdio-mscc-miim.c             | 167 +++-
> >  drivers/net/pcs/pcs-lynx.c                    |  36 +-
> >  drivers/pinctrl/pinctrl-microchip-sgpio.c     | 127 ++-
> >  drivers/pinctrl/pinctrl-ocelot.c              | 207 ++--
> >  include/linux/mdio/mdio-mscc-miim.h           |  19 +
> >  include/linux/pcs-lynx.h                      |   9 +-
> >  include/linux/property.h                      |   1 +
> >  include/soc/mscc/ocelot.h                     |  60 ++
> >  include/soc/mscc/vsc7514_regs.h               |  27 +
> >  28 files changed, 2219 insertions(+), 861 deletions(-)
> >  create mode 100644 drivers/net/dsa/ocelot/felix_mdio.c
> >  create mode 100644 drivers/net/dsa/ocelot/felix_mdio.h
> >  create mode 100644 drivers/net/dsa/ocelot/ocelot_vsc7512_spi.c
> >  create mode 100644 drivers/net/ethernet/mscc/vsc7514_regs.c
> >  create mode 100644 include/linux/mdio/mdio-mscc-miim.h
> >  create mode 100644 include/soc/mscc/vsc7514_regs.h
> > 
> > -- 
> > 2.25.1
> >
