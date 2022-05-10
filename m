Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67D855204B7
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 20:47:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240317AbiEISrr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 14:47:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240291AbiEISrp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 14:47:45 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2134.outbound.protection.outlook.com [40.107.94.134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D48A18995A;
        Mon,  9 May 2022 11:43:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ake5Z55zKZbGC9jkakyDY0SVMFzkX6KkvrrH6iReUzZHjGpQQXLZAnawYNPYHKp5EzRcaieZuVrNt4ht5SLU0Jhmfmc4ArBjGTyWXGgvy9BhPJGNgLSdhd0ngHaCl35MzR05MJ3TH1NKQhV97CL5VdeJz0daytm+sDEKr5N/skqv2vk6/Xmqmm0hifBQubsu0hVoiIbndQcrpu8UcTW7J6qVEqMmYPsyX0fuwzU7c7YAgpzW+tu+wkV0sx6dDJtZTocSA5jxDBaCOAORNWhvbpQYh1eOFNdkfqHB0wEBHOk6giLPzSTH/2U92gIeihFEuc4jk9XWD4CxUoAm/KEnSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pPWXwZEFEF1tBnKXajc80zx2yFE8J8tQUW2HrwpJXwM=;
 b=hSrSKl4QNFYE/r3myfRO+DkqDP184sL9p+fuHBEM5dkkmXHr/8b5nFzfwIH9DMt6S+xfeWcL3ttnfru5fXz8rfs48vU/XIgL3jaNxpx9OcCGGx6HRB435iF5fLx9vxiC+S0hYGDuK+CT3l21uYatuBawdvMg2jUgqfWPONgBuQkE94TfAyEVG+j8DmaPtWf/ukZ1J48JYzihbiIqQwkqRmRAEslExER0qHJ5AhCcecSt5E67F2Bh43O77sfLH07qMzSoJiM6Q/c2Zv71NRxZbh0waTDypAxXv56r3idLPJ69Jh2r5fPuT7R53/qT3/BFXg9d8sWNfxr/tmKGkWIA6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pPWXwZEFEF1tBnKXajc80zx2yFE8J8tQUW2HrwpJXwM=;
 b=rwLI8RKqTRUZ1G+Z7KjsrK3N07ZScjGBu0RUPcih8hDbMmuIrEoEYB6V7OZu5pPmrP9Oyqhutd/nCSAR/GKeVvL/+kcFFwseJjE7/ahSHejFWSmFcDKKx8R7nPzmqyoGN04Sr1OEBPP+ZuU+Z2Js8XBKFXZBZHAHy6GFDSi4+o8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by CY4PR10MB2037.namprd10.prod.outlook.com
 (2603:10b6:903:125::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.21; Mon, 9 May
 2022 18:43:46 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::4581:787c:1a7a:873e]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::4581:787c:1a7a:873e%3]) with mapi id 15.20.5227.020; Mon, 9 May 2022
 18:43:46 +0000
Date:   Mon, 9 May 2022 18:43:50 -0700
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Terry Bowman <terry.bowman@amd.com>,
        Wolfram Sang <wsa@kernel.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: Re: [RFC v8 net-next 00/16] add support for VSC7512 control over SPI
Message-ID: <20220510014350.GI895@COLIN-DESKTOP1.localdomain>
References: <20220508185313.2222956-1-colin.foster@in-advantage.com>
 <20220509171304.hfh5rbynt4qtr6m4@skbuf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220509171304.hfh5rbynt4qtr6m4@skbuf>
X-ClientProxiedBy: MW4PR03CA0263.namprd03.prod.outlook.com
 (2603:10b6:303:b4::28) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2b32658d-dd47-41fd-52c8-08da31ebd980
X-MS-TrafficTypeDiagnostic: CY4PR10MB2037:EE_
X-Microsoft-Antispam-PRVS: <CY4PR10MB203797915E7022250E03F708A4C69@CY4PR10MB2037.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /UwWre8g3jPknYJAFhM47VHalCu0J1ZNoJUuQ5s8Q37jSHB8y9uQ/Xv5GKpD6jcRbGwYPHbWodzL5BA3NZHIIFjEZt1jOLNCCviW9Z980dO94naISFVoX/+36eomaIw4xwyZCQoRc/kVrMUzdgSlcf8ebWwJ4Bi95m2yfDleQ5ItprrGBdzYYTP2Xel/uFNfjcaaWK/tJkGSBLs4Ek1SggexAcrYjCI4+TVUZMJ/1Kho6m+TAHBUOe07d6a8jgsQGPxeZpaKNDkfwI80p0ykSxubyPpBlbNCInzVM17/fhTVj34hJdRJuMsGKuJKmxTAoHMXnwBFDcdDZL0zopillxf0aXaKy4OMgCXQhSyTYG7Q3RFZP64TJFcGW/NBIMgnDDUXMcDnIeWIq+ErZVEfEJ9JRDPiMrOwQwChcvX6m/I8YKO7w8EtatmPqNIRDP+fRpgIk+wHH+nN+L3ZqOk1B+yLJr7e/BRETYcu1zxk2vrzNiFPGlJXdwQ9mpE4X3IwujAYcPrmwe8dbg8vkqFYSjMfYn/sKaQdsehgphm/1vv5cYfjfVlv9Q2BJQ+pW8WtTkBGFafKWcq0SDeYXdK2+BOI9C5VrkM/E1pyMpwvRNUwW2g7ZKhVMX+S0lozWX78IvHKfPqVNfU6Ou9RnccFWGl0bhuq6dPt40+xlvX9li80X3wPBHhPRREUWecyFhkNrAh2Ysc54Eh7BLX+H3wC+w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(376002)(396003)(136003)(39830400003)(366004)(346002)(33656002)(66556008)(66476007)(66946007)(8676002)(1076003)(508600001)(4326008)(83380400001)(186003)(7416002)(6512007)(26005)(9686003)(86362001)(6666004)(6486002)(316002)(54906003)(6916009)(6506007)(52116002)(8936002)(2906002)(44832011)(30864003)(5660300002)(38350700002)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rbQpBFTrx15+nn3DhjkUsiogjfLS+fLZEpytr27rkByXdUsIR6flDGpPS6hh?=
 =?us-ascii?Q?Z1ai5fCYhzOVQfutq9C8sfUBL8qnuXVP/J0JjbrlMzDVVz3JZ6toOXL6huW/?=
 =?us-ascii?Q?Q5RMX5O811L+iLia+n/hSbvnv6cwqiKZ2It06gVv+OHdNe+q2WeCdXIUbAor?=
 =?us-ascii?Q?n9dZNm1UUGp7xWZiaxRVsB2eFXURwlyZPgqfx3S3GCfSVVgqzcd2DLfjoWy0?=
 =?us-ascii?Q?VRn76R5h5Ixj7KoVK1dMFdOYnRp3PV2Luhluc31GtyPRwPAf7XY7W0g0jcM7?=
 =?us-ascii?Q?ePeWxn5+MUOliNs0d/FoNyBWDhX5/Di35vXv0g6unmloSzPELnW3zozbnepv?=
 =?us-ascii?Q?U7Yxa8HgZxgri3Kz+3MvpSkSn/+jJ55Gly1ipKhhSYytB0dXZbzpoaX89hVc?=
 =?us-ascii?Q?PQGWFjunPrFHdPxI6DfZ4um1hyPjltGukKpE8ifGFcCYoKKdeUnCzGaHnDHP?=
 =?us-ascii?Q?whaNpGlUwnSbu4ishA7ntLTKCOCnmMHrYuWTtnGsDnuok0TZdsrXTMK5m9lu?=
 =?us-ascii?Q?zvXzJ1pfziCUG7jIU8wAo0A2lCy8Sv0PkTE8BkqFpYUaWDCZwqxF1s/bZ/tD?=
 =?us-ascii?Q?jF4bBwXUKT33p7I4skzxU7N2C0ICwhwUm42EBbMZiVGpMH9V6kOACNOoSmPe?=
 =?us-ascii?Q?gYbXXOTmliBFoNP7Zi8MkaqHmuBGYdx9plSZUJrbPtSHiZwG4XQn5EVLYGh7?=
 =?us-ascii?Q?CcplRLhbC6Uvmfd5Tpx1jw4SANPfEaogk7azP8uAdHQwxe1Dp52dc7BpH8bx?=
 =?us-ascii?Q?0y+XeTHlUGoczfj8VTnFJni9KlifDwJLqv6aaGoR+7z1f9PSsjGaEctZSrCi?=
 =?us-ascii?Q?4mAtgY3Qq52MmGzkwNdXOiX+sz0DiEaNa7xv/p6Ya3rmOzSPGZtt9TdmSvDe?=
 =?us-ascii?Q?HZIHvjeiOYBBTfOjMRGxvFmZUrBPUMEHlI3WwtjIXj6uqxKcJmGL9xY40PZ2?=
 =?us-ascii?Q?b++cSnHfSSDqU5m0whef+PEIOwN3R6miyf1S2m6LDwOhCYmD7701zsQPNCXX?=
 =?us-ascii?Q?unDWbLl9OtacIp6ZwYkVKAK5fw82GFO1GVQTGkD9wZYdJuqo1XM+0yvdcKd3?=
 =?us-ascii?Q?SQcaUJV4b/3rqzpa04ek0Go5+WksHi5fZs74wFcAgI2hoJRUJmL81AX59j/R?=
 =?us-ascii?Q?JbzPRNPqjIkn17AJLN9qRfsNsTFDRjmMQp+A2eACzz2u9LL1bL3Ua9lVmCwn?=
 =?us-ascii?Q?gZ8LfOrhfGBhtt1H7ZETOS1LuOttWaY+nugVnSgQjq0pK9IAknq3S1CYxzVv?=
 =?us-ascii?Q?OVeN9Vy/67ynhahrDAvEXNMRckQrrdPsy59wKPFks6DjDoNwgHV8LW1rWT2k?=
 =?us-ascii?Q?ZyUzXd3Wyf4yswu52hBeiMEXzMdjQ7iGYF29VlQXUAdc8Vy08mz2zK/HyKPG?=
 =?us-ascii?Q?fE2vOx6QVxKtt3oMpY0cYxG/meVVBMrQ2A2K4Lrer/1kBc/N2EPkTuolSNlV?=
 =?us-ascii?Q?MrSCWpfIqEtLjdS6ht0xtk5/NiTw95OwjP0PxXunSIEzxPtVAF1laKVWec6W?=
 =?us-ascii?Q?FxEEA5qgp3Fsch7smzPQWI2mzSeq3bDhdzm5+amuntZWQO+Hc4VUwtACh6/h?=
 =?us-ascii?Q?3V9dB2FZ8uoTELqdkquZXj4q3gbdc/ulStN4zqim83B2JD0OJa8AvI76wpW2?=
 =?us-ascii?Q?u3rfyF/9oxYHyQOUoUEfD+6ZNAqPslTPtkRpw2ZxFWEskUQxPw8QVdaK2kEN?=
 =?us-ascii?Q?3dWOXEOFnhmkSqUtO+UE5NwKoFODkL8pThwN/MHkL1zSTLACEDtzu+LhRAl2?=
 =?us-ascii?Q?gF69X0PZa2GEpI9OHfBlotzKFsXfE+uhvVIywRCKw3CkegHj6Qqi?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b32658d-dd47-41fd-52c8-08da31ebd980
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2022 18:43:46.4987
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pH4bsp0MfKXPBy96nipZygZIzTJC4Z3nXIbCLW7AsdXLqCEoN9QfpRm/UFh1GDUlQv59oRu83O7uvPidl0EcBcnbgqPK6omYOf8jIvqSiNo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB2037
X-Spam-Status: No, score=0.0 required=5.0 tests=BAYES_00,DATE_IN_FUTURE_06_12,
        DKIM_SIGNED,DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 09, 2022 at 05:13:05PM +0000, Vladimir Oltean wrote:
> Hi Colin,
> 
> On Sun, May 08, 2022 at 11:52:57AM -0700, Colin Foster wrote:
> > The patch set in general is to add support for the VSC7512, and
> > eventually the VSC7511, VSC7513 and VSC7514 devices controlled over
> > SPI. The driver is believed to be fully functional for the internal
> > phy ports (0-3)  on the VSC7512. It is not yet functional for SGMII,
> > QSGMII, and SerDes ports.
> > 
> > I have mentioned previously:
> > The hardware setup I'm using for development is a beaglebone black, with
> > jumpers from SPI0 to the microchip VSC7512 dev board. The microchip dev
> > board has been modified to not boot from flash, but wait for SPI. An
> > ethernet cable is connected from the beaglebone ethernet to port 0 of
> > the dev board.
> > 
> > The relevant sections of the device tree I'm using for the VSC7512 is
> > below. Notably the SGPIO LEDs follow link status and speed from network
> > triggers.
> > 
> > In order to make this work, I have modified the cpsw driver, and now the
> > cpsw_new driver, to allow for frames over 1500 bytes. Otherwise the
> > tagging protocol will not work between the beaglebone and the VSC7512. I
> > plan to eventually try to get those changes in mainline, but I don't
> > want to get distracted from my initial goal. I also had to change
> > bonecommon.dtsi to avoid using VLAN 0.
> 
> This ti,dual-emac-pvid thing is a really odd thing to put in the device
> tree. But what's the problem with VLAN 0 anyway?

Ahh, I see that was an exchange between me and Grygorii Strashko that
wasn't public. Looking now, it might be VLAN 1...

I'd see "failed to initialize vlan filtering" when I ran "ip link set
dev swp1 master br0" because the default bridge vlan conflicted with
slave_data->dual_emac_res_vlan = port_id;
(drivers/net/ethernet/ti/cpsw_new.c, around line 1325)

My initial attempt was to just change cpsw_port1
ti,dual-emac-pvid=<12>; but that didn't change the behavior. Maybe if I
went back to it again, seeing as I'm much older and wiser than I was
before, I could find the correct device tree solution... Ideally I think
I should have the ability to not enable cpsw_port1 and be good.

But I think the magic was really just to set
slave_data->dual_emac_res_vlan = 10 + port_id; to avoid conflicts.


This became an issue at 5.15, when cpsw_new was rolled in to the .dtsis
I've been using.

> 
> > 
> > I believe much of the MFD sections are very near feature-complete,
> > whereas the switch section will require ongoing work to enable
> > additional ports / features. This could lead to a couple potential
> > scenarios:
> > 
> > The first being patches 1-8 being split into a separate patch set, while
> > patches 9-16 remain in the RFC state. This would offer the pinctrl /
> > sgpio / mdio controller functionality, but no switch control until it is
> > ready.
> > 
> > The second would assume the current state of the switch driver is
> > acceptable (or at least very near so) and the current patch set gets an
> > official PATCH set (with minor changes as necessary - e.g. squashing
> > patch 16 into 14). That might be ambitious.
> > 
> > The third would be to keep this patch set in RFC until switch
> > functionality is more complete. I'd understand if this was the desired
> > path... but it would mean me having to bug more reviewers.
> 
> Considering that the merge window is approaching, I'd say get the
> non-DSA stuff accepted until then, then repost the DSA stuff in ~3 weeks
> from now as non-RFC, once v5.18 is cut and the development for v5.20
> (or whatever the number will be) begins.

That's the approach I'd prefer as well.

> 
> > / {
> > 	vscleds {
> > 		compatible = "gpio-leds";
> > 		vscled@0 {
> > 			label = "port0led";
> > 			gpios = <&sgpio_out1 0 0 GPIO_ACTIVE_LOW>;
> > 			default-state = "off";
> > 			linux,default-trigger = "ocelot-miim0.2.auto-mii:00:link";
> > 		};
> > 		vscled@1 {
> > 			label = "port0led1";
> > 			gpios = <&sgpio_out1 0 1 GPIO_ACTIVE_LOW>;
> > 			default-state = "off";
> > 			linux,default-trigger = "ocelot-miim0.2.auto-mii:00:1Gbps";
> > 		};
> > [ ... ]
> > 	};
> > };
> > 
> > &spi0 {
> > 	#address-cells = <1>;
> > 	#size-cells = <0>;
> > 	status = "okay";
> > 
> > 	ocelot-chip@0 {
> > 		compatible = "mscc,vsc7512_mfd_spi";
> 
> Can you use hyphens instead of underscores in this compatible string?
> 
> > 		spi-max-frequency = <2500000>;
> > 		reg = <0>;
> > 
> > 		ethernet-switch@0 {
> 
> I don't think the switch node should have any address?
> 
> > 			compatible = "mscc,vsc7512-ext-switch";
> > 			ports {
> > 				#address-cells = <1>;
> > 				#size-cells = <0>;
> > 
> > 				port@0 {
> > 					reg = <0>;
> > 					label = "cpu";
> > 					status = "okay";
> > 					ethernet = <&mac_sw>;
> > 					phy-handle = <&sw_phy0>;
> > 					phy-mode = "internal";
> > 				};
> > 
> > 				port@1 {
> > 					reg = <1>;
> > 					label = "swp1";
> > 					status = "okay";
> > 					phy-handle = <&sw_phy1>;
> > 					phy-mode = "internal";
> > 				};
> > 			};
> > 		};
> > 
> > 		mdio0: mdio0@0 {
> 
> This is going to be interesting. Some drivers with multiple MDIO buses
> create an "mdios" container with #address-cells = <1> and put the MDIO
> bus nodes under that. Others create an "mdio" node and an "mdio0" node
> (and no address for either of them).
> 
> The problem with the latter approach is that
> Documentation/devicetree/bindings/net/mdio.yaml does not accept the
> "mdio0"/"mdio1" node name for an MDIO bus.

Hmm... That'll be interesting indeed. The 7514
(arch/mips/boot/dts/mscc/ocelot.dtsi) is where I undoubtedly started.
Is there an issue with the 7514, or is it just an issue with my
implementation, which should be:

mdio0: mdio@0 {

instead of mdio0@0?

> 
> > 			compatible = "mscc,ocelot-miim";
> > 			#address-cells = <1>;
> > 			#size-cells = <0>;
> > 
> > 			sw_phy0: ethernet-phy@0 {
> > 				reg = <0x0>;
> > 			};
> > 
> > 			sw_phy1: ethernet-phy@1 {
> > 				reg = <0x1>;
> > 			};
> > 
> > 			sw_phy2: ethernet-phy@2 {
> > 				reg = <0x2>;
> > 			};
> > 
> > 			sw_phy3: ethernet-phy@3 {
> > 				reg = <0x3>;
> > 			};
> > 		};
> > 
> > 		mdio1: mdio1@1 {
> > 			compatible = "mscc,ocelot-miim";
> > 			pinctrl-names = "default";
> > 			pinctrl-0 = <&miim1>;
> > 			#address-cells = <1>;
> > 			#size-cells = <0>;
> > 
> > 			sw_phy4: ethernet-phy@4 {
> > 				reg = <0x4>;
> > 			};
> > 
> > 			sw_phy5: ethernet-phy@5 {
> > 				reg = <0x5>;
> > 			};
> > 
> > 			sw_phy6: ethernet-phy@6 {
> > 				reg = <0x6>;
> > 			};
> > 
> > 			sw_phy7: ethernet-phy@7 {
> > 				reg = <0x7>;
> > 			};
> > 		};
> > 
> > 		gpio: pinctrl@0 {
> 
> Similar thing with the address. All these @0 addresses actually conflict
> with each other.
> 
> > 			compatible = "mscc,ocelot-pinctrl";
> > 			gpio-controller;
> > 			#gpio_cells = <2>;
> > 			gpio-ranges = <&gpio 0 0 22>;
> > 
> > 			led_shift_reg_pins: led-shift-reg-pins {
> > 				pins = "GPIO_0", "GPIO_1", "GPIO_2", "GPIO_3";
> > 				function = "sg0";
> > 			};
> > 
> > 			miim1: miim1 {
> > 				pins = "GPIO_14", "GPIO_15";
> > 				function = "miim";
> > 			};
> > 		};
> > 
> > 		sgpio: sgpio {
> 
> And mixing nodes with addresses with nodes without addresses is broken too.
> 
> > 			compatible = "mscc,ocelot-sgpio";
> > 			#address-cells = <1>;
> > 			#size-cells = <0>;
> > 			bus-frequency=<12500000>;
> > 			clocks = <&ocelot_clock>;
> > 			microchip,sgpio-port-ranges = <0 15>;
> > 			pinctrl-names = "default";
> > 			pinctrl-0 = <&led_shift_reg_pins>;
> > 
> > 			sgpio_in0: sgpio@0 {
> > 				compatible = "microchip,sparx5-sgpio-bank";
> > 				reg = <0>;
> > 				gpio-controller;
> > 				#gpio-cells = <3>;
> > 				ngpios = <64>;
> > 			};
> > 
> > 			sgpio_out1: sgpio@1 {
> > 				compatible = "microchip,sparx5-sgpio-bank";
> > 				reg = <1>;
> > 				gpio-controller;
> > 				#gpio-cells = <3>;
> > 				ngpios = <64>;
> > 			};
> > 		};
> > 	};
> > };
> > 
> > And I'll include the relevant dmesg prints - I don't love the "invalid
> > resource" prints, as they seem to be misleading. They're a byproduct of
> > looking for IO resources before falling back to REG.
> > 
> > [    0.000000] Booting Linux on physical CPU 0x0
> > [    0.000000] Linux version 5.18.0-rc5-01295-g47053e327c52 (X@X) (arm-linux-gnueabi-gcc (Ubuntu 9.4.0-1ubuntu1~20.04.1) 9.4.0, GNU ld (GNU Binutils for Ubuntu) 2.34) #630 SMP PREEMPT Sun May 8 10:56:51 PDT 2022
> > ...
> > [    2.829319] pinctrl-ocelot ocelot-pinctrl.0.auto: DMA mask not set
> 
> Why does this get printed, if you put a dump_stack() in of_dma_configure_id()?

I'll run that tonight.

> 
> > [    2.835718] pinctrl-ocelot ocelot-pinctrl.0.auto: invalid resource
> > [    2.842717] gpiochip_find_base: found new base at 2026
> > [    2.842774] gpio gpiochip4: (ocelot-gpio): created GPIO range 0->21 ==> ocelot-pinctrl.0.auto PIN 0->21
> > [    2.845693] gpio gpiochip4: (ocelot-gpio): added GPIO chardev (254:4)
> > [    2.845828] gpio gpiochip4: registered GPIOs 2026 to 2047 on ocelot-gpio
> > [    2.845855] pinctrl-ocelot ocelot-pinctrl.0.auto: driver registered
> > [    2.855925] pinctrl-microchip-sgpio ocelot-sgpio.1.auto: DMA mask not set
> > [    2.863089] pinctrl-microchip-sgpio ocelot-sgpio.1.auto: invalid resource
> > [    2.870801] gpiochip_find_base: found new base at 1962
> > [    2.871528] gpio_stub_drv gpiochip5: (ocelot-sgpio.1.auto-input): added GPIO chardev (254:5)
> > [    2.871666] gpio_stub_drv gpiochip5: registered GPIOs 1962 to 2025 on ocelot-sgpio.1.auto-input
> > [    2.872364] gpiochip_find_base: found new base at 1898
> > [    2.873244] gpio_stub_drv gpiochip6: (ocelot-sgpio.1.auto-output): added GPIO chardev (254:6)
> > [    2.873354] gpio_stub_drv gpiochip6: registered GPIOs 1898 to 1961 on ocelot-sgpio.1.auto-output
> > [    2.881148] mscc-miim ocelot-miim0.2.auto: DMA mask not set
> > [    2.886929] mscc-miim ocelot-miim0.2.auto: invalid resource
> > [    2.893738] mdio_bus ocelot-miim0.2.auto-mii: GPIO lookup for consumer reset
> > [    2.893769] mdio_bus ocelot-miim0.2.auto-mii: using device tree for GPIO lookup
> > [    2.893802] of_get_named_gpiod_flags: can't parse 'reset-gpios' property of node '/ocp/interconnect@48000000/segment@0/target-module@30000/spi@0/ocelot-chip@0/mdio0[0]'
> > [    2.893898] of_get_named_gpiod_flags: can't parse 'reset-gpio' property of node '/ocp/interconnect@48000000/segment@0/target-module@30000/spi@0/ocelot-chip@0/mdio0[0]'
> > [    2.893996] mdio_bus ocelot-miim0.2.auto-mii: using lookup tables for GPIO lookup
> > [    2.894012] mdio_bus ocelot-miim0.2.auto-mii: No GPIO consumer reset found
> > [    3.395738] mdio_bus ocelot-miim0.2.auto-mii:00: GPIO lookup for consumer reset
> > [    3.395777] mdio_bus ocelot-miim0.2.auto-mii:00: using device tree for GPIO lookup
> > [    3.395840] of_get_named_gpiod_flags: can't parse 'reset-gpios' property of node '/ocp/interconnect@48000000/segment@0/target-module@30000/spi@0/ocelot-chip@0/mdio0/ethernet-phy@0[0]'
> > [    3.395959] of_get_named_gpiod_flags: can't parse 'reset-gpio' property of node '/ocp/interconnect@48000000/segment@0/target-module@30000/spi@0/ocelot-chip@0/mdio0/ethernet-phy@0[0]'
> > [    3.396069] mdio_bus ocelot-miim0.2.auto-mii:00: using lookup tables for GPIO lookup
> > [    3.396086] mdio_bus ocelot-miim0.2.auto-mii:00: No GPIO consumer reset found
> > ...
> > [    3.449187] ocelot-ext-switch ocelot-ext-switch.4.auto: DMA mask not set
> > [    5.336880] ocelot-ext-switch ocelot-ext-switch.4.auto: PHY [ocelot-miim0.2.auto-mii:00] driver [Generic PHY] (irq=POLL)
> > [    5.349087] ocelot-ext-switch ocelot-ext-switch.4.auto: configuring for phy/internal link mode
> > [    5.363619] ocelot-ext-switch ocelot-ext-switch.4.auto swp1 (uninitialized): PHY [ocelot-miim0.2.auto-mii:01] driver [Generic PHY] (irq=POLL)
> > [    5.381396] ocelot-ext-switch ocelot-ext-switch.4.auto swp2 (uninitialized): PHY [ocelot-miim0.2.auto-mii:02] driver [Generic PHY] (irq=POLL)
> > [    5.398525] ocelot-ext-switch ocelot-ext-switch.4.auto swp3 (uninitialized): PHY [ocelot-miim0.2.auto-mii:03] driver [Generic PHY] (irq=POLL)
> 
> Do the PHYs not have a specific driver?

When I have the other four ports defined, those correctly find the
vsc85xx driver, perform serdes calibration, etc. (assuming I have that
phy support compiled in) The internal phys I believe have always just
been using a generic driver.

> 
> > [    5.422048] device eth0 entered promiscuous mode
> > [    5.426785] DSA: tree 0 setup
> > ...
> > [    7.450067] ocelot-ext-switch ocelot-ext-switch.4.auto: Link is Up - 100Mbps/Full - flow control off
> > [   21.556395] cpsw-switch 4a100000.switch: starting ndev. mode: dual_mac
> > [   21.648564] SMSC LAN8710/LAN8720 4a101000.mdio:00: attached PHY driver (mii_bus:phy_addr=4a101000.mdio:00, irq=POLL)
> > [   21.667970] 8021q: adding VLAN 0 to HW filter on device eth0
> > [   21.705360] ocelot-ext-switch ocelot-ext-switch.4.auto swp1: configuring for phy/internal link mode
> > [   22.018230] ocelot-ext-switch ocelot-ext-switch.4.auto: Link is Down
> > [   23.771740] cpsw-switch 4a100000.switch eth0: Link is Up - 100Mbps/Full - flow control off
> > [   24.090929] ocelot-ext-switch ocelot-ext-switch.4.auto: Link is Up - 100Mbps/Full - flow control off
> > [   25.853021] ocelot-ext-switch ocelot-ext-switch.4.auto swp1: Link is Up - 1Gbps/Full - flow control rx/tx
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
> > v5
> >     * Restructured to MFD
> >     * Several commits were split out, submitted, and accepted
> >     * pinctrl-ocelot believed to be fully functional (requires commits
> >     from the linux-pinctrl tree)
> >     * External MDIO bus believed to be fully functional
> > 
> > v6
> >     * Applied several suggestions from the last RFC from Lee Jones. I
> >       hope I didn't miss anything.
> >     * Clean up MFD core - SPI interaction. They no longer use callbacks.
> >     * regmaps get registered to the child device, and don't attempt to
> >       get shared. It seems if a regmap is to be shared, that should be
> >       solved with syscon, not dev or mfd.
> > 
> > v7
> >     * Applied as much as I could from Lee and Vladimir's suggestions. As
> >       always, the feedback is greatly appreciated!
> >     * Remove "ocelot_spi" container complication
> >     * Move internal MDIO bus from ocelot_ext to MFD, with a devicetree
> >       change to match
> >     * Add initial HSIO support
> >     * Switch to IORESOURCE_REG for resource definitions
> > 
> > v8
> >     * Applied another round of suggestions from Lee and Vladimir
> >     * Utilize regmap bus reads, which speeds bulk transfers up by an
> 
> bus -> bulk?

Either is probably valid. Here I'm referencing struct regmap_bus, 
so _regmap_bus_read allows the utilization of bulk transfers for stats.

> 
> >       order of magnitude
> >     * Add two additional patches to utilize phylink_generic_validate
> >     * Changed GPL V2 to GPL in licenses where applicable (checkpatch)
> >     * Remove initial hsio/serdes changes from the RFC
> > 
> > 
> > Colin Foster (16):
> >   pinctrl: ocelot: allow pinctrl-ocelot to be loaded as a module
> >   pinctrl: microchip-sgpio: allow sgpio driver to be used as a module
> >   net: ocelot: add interface to get regmaps when exernally controlled
> >   net: mdio: mscc-miim: add ability to be used in a non-mmio
> >     configuration
> >   pinctrl: ocelot: add ability to be used in a non-mmio configuration
> >   pinctrl: microchip-sgpio: add ability to be used in a non-mmio
> >     configuration
> >   resource: add define macro for register address resources
> >   mfd: ocelot: add support for the vsc7512 chip via spi
> >   net: mscc: ocelot: expose ocelot wm functions
> >   net: dsa: felix: add configurable device quirks
> >   net: mscc: ocelot: expose regfield definition to be used by other
> >     drivers
> >   net: mscc: ocelot: expose stats layout definition to be used by other
> >     drivers
> >   net: mscc: ocelot: expose vcap_props structure
> >   net: dsa: ocelot: add external ocelot switch control
> >   net: dsa: felix: add phylink_get_caps capability
> >   net: dsa: ocelot: utilize phylink_generic_validate
> > 
> >  drivers/mfd/Kconfig                        |  18 +
> >  drivers/mfd/Makefile                       |   2 +
> >  drivers/mfd/ocelot-core.c                  | 138 ++++++++
> >  drivers/mfd/ocelot-spi.c                   | 311 +++++++++++++++++
> >  drivers/mfd/ocelot.h                       |  34 ++
> >  drivers/net/dsa/ocelot/Kconfig             |  14 +
> >  drivers/net/dsa/ocelot/Makefile            |   5 +
> >  drivers/net/dsa/ocelot/felix.c             |  29 +-
> >  drivers/net/dsa/ocelot/felix.h             |   3 +
> >  drivers/net/dsa/ocelot/felix_vsc9959.c     |   1 +
> >  drivers/net/dsa/ocelot/ocelot_ext.c        | 366 +++++++++++++++++++++
> >  drivers/net/dsa/ocelot/seville_vsc9953.c   |   1 +
> >  drivers/net/ethernet/mscc/ocelot_devlink.c |  31 ++
> >  drivers/net/ethernet/mscc/ocelot_vsc7514.c | 230 +------------
> >  drivers/net/ethernet/mscc/vsc7514_regs.c   | 200 +++++++++++
> >  drivers/net/mdio/mdio-mscc-miim.c          |  31 +-
> >  drivers/pinctrl/Kconfig                    |   4 +-
> >  drivers/pinctrl/pinctrl-microchip-sgpio.c  |  26 +-
> >  drivers/pinctrl/pinctrl-ocelot.c           |  35 +-
> >  include/linux/ioport.h                     |   5 +
> >  include/soc/mscc/ocelot.h                  |  19 ++
> >  include/soc/mscc/vsc7514_regs.h            |   6 +
> >  22 files changed, 1251 insertions(+), 258 deletions(-)
> >  create mode 100644 drivers/mfd/ocelot-core.c
> >  create mode 100644 drivers/mfd/ocelot-spi.c
> >  create mode 100644 drivers/mfd/ocelot.h
> >  create mode 100644 drivers/net/dsa/ocelot/ocelot_ext.c
> > 
> > -- 
> > 2.25.1
> >
