Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA32552D9FD
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 18:15:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241914AbiESQPW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 12:15:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241884AbiESQPL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 12:15:11 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2104.outbound.protection.outlook.com [40.107.223.104])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E2F9C6E66;
        Thu, 19 May 2022 09:15:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JnnqO6HGHZQlqritq+QDYPWLz8b8oz07ryq0O6otcHqHlVQ9HH3+yqXQKVfvOv1l0bATd/Mjli4B8Gb3PW1RJ4/R4c7hj3FU/yfHpgcys/DbdyydJyQp2KfcTDAQiDGIYE4j4+XkjqRQpk/fas4Agpu6FwCQq7NWtr7XRoLKPK77erZtJYstrMPKr7Da0G0LdAcvM8lomiGMSvzJ+SKknsMawxSU0UvE6NK7VYSb6FCLrRAi+buS2Q9skuKXjnCNhwqIP5LBR09wdGQygigFwMveOsCgqsrmAhGf7aC2jsE1jiiidbpGJ+QrwUDVbl3CSFA72oc/+kYek/tTjshTdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/Zc3b+BaL7ysHuMHfDTSq7L+R/64h0Lny/+JHh/H9hM=;
 b=RD6NvYG49MIBHZ4+ZcRs7luqA8QijG8Etzf30NDRJj+ZV6RlsvN15NBQIDQ+Vz7kGvb8GbqcBlCRlMuaZCM5tmucRr/HPKILMlhqxY5mgZATyy77C2RKdESK6IPFQ2AYWMurElQl+yjkruHsgTcleaEPZXs5G+b/waqEXhdqNsZ5lMj5YFpvYfqvdV6ML/MWsDLMnDZJrZ2alrQ2Xa7/xntbz8tG+35ALPrSd1QWyMndE4ngXBKdyk57+qa4qvlIKFvVxgDAJya7XzSvBl82aaJe1n4u+E75LQG6u9X8Vxdl5ezNdT883MC0B5JUQcBGG1m4CZv1/BV/bLJSD5/QmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/Zc3b+BaL7ysHuMHfDTSq7L+R/64h0Lny/+JHh/H9hM=;
 b=hW4I1kA9lMaeOBLa0NKJyJb3zC7liyD866u5qusxp06LF3ysWJixHjf6YMiuec0YtA1g+cw7lbmldmw+vZ2GVv9qEOfTuZliSLyaCDQ/PXuG3bVKbDTTmtEiYUvxBtG4Kt4WAHDOb3sbM2kK7xg19+y78v/ND1vH0ClYaLPXFIA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by SJ0PR10MB4495.namprd10.prod.outlook.com
 (2603:10b6:a03:2d6::5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.16; Thu, 19 May
 2022 16:15:06 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::4581:787c:1a7a:873e]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::4581:787c:1a7a:873e%3]) with mapi id 15.20.5250.018; Thu, 19 May 2022
 16:15:06 +0000
Date:   Thu, 19 May 2022 09:15:00 -0700
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
Message-ID: <20220519161500.GA51431@colin-ia-desktop>
References: <20220508185313.2222956-1-colin.foster@in-advantage.com>
 <20220509171304.hfh5rbynt4qtr6m4@skbuf>
 <20220514220010.GB3629122@euler>
 <20220519144441.tqhihlaq6vbmpmvd@skbuf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220519144441.tqhihlaq6vbmpmvd@skbuf>
X-ClientProxiedBy: CO2PR04CA0065.namprd04.prod.outlook.com
 (2603:10b6:102:1::33) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c22e82c0-1d32-4b5c-1292-08da39b2bce6
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4495:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR10MB44959DCFE1D375F14C999798A4D09@SJ0PR10MB4495.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CKHFilznIM+70/o5Lcy3NcLv9bslsGcGS2BbvjUa/LOHb2n8u30PfsOV5tHv8FXUJz/VXghXw8F0MfLxKip3JX4njEfnwUrOblLP2bvX/+KhB2ixU5H4MBOLH2AMXVPZ2v2UQNgfmwRu4uWOFSRLWwEtN+3btBJpoi6FO7yAhUhUnxbVYBuHa+QngKhHCPP2GRYfPwwYQmjEuIXVy8atBaPSVHjQX+x+/xULN0aOlvpt612mDR7PBQP+CBAO0V59537yFcWQ04ueEAYaU7xyazTf8Heis5W4RMJJzHicXrgOVhlcYsIu6yJqbtbqvnzhZjZJZ83cDonOJZayQz4Rc+JtXT8H127E+f0hhalg01iP5RNV9Bi/BkO3Vcmy3nW9cGnfWNDJDC/GWs3HtME3/5NCImri5wSGFzypbtM84OhK7IAq1RLbkclH7O4WOuCr7/18T/l9oFhnthyvuEIbhC/UkhNnia+5mOS77vEqyVRuG0VSolj1/xE8VXDQtsYLzftbX55Thg76b7eIMQw8DwFbAwhszpesdB1nUXte6fy5Nlvn6ttNULyfpJxxdezKHCV6cOHhSgjRsRmg1i+dCnwoSjUlVgCF6K+t6sPdVkPjVViTJd5d1SHeQ5R0j/3Y/EIhYLj+RuCh/0IlJHaBpIekiI8CuPJ6G25a1ExlG1t9S7DeWF2BotdxDdbp3X7lD7L61k7L+aqin5vQvQxI6Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(376002)(346002)(366004)(396003)(136003)(39830400003)(54906003)(6486002)(7416002)(5660300002)(508600001)(1076003)(6916009)(66476007)(86362001)(2906002)(44832011)(38100700002)(38350700002)(66556008)(66946007)(6506007)(186003)(8676002)(83380400001)(316002)(4326008)(33716001)(8936002)(52116002)(9686003)(6512007)(26005)(6666004)(41300700001)(33656002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?G/35sgrkn0znt5elVyk0WxzZWC+tuG/JqHvrg2dN1D+IM2NrYjeNeUwOXVbL?=
 =?us-ascii?Q?wVCYVFH3x4uLWIxjUc4a3rJYx3p5c8FAxSlUqI3iDlLVPRm4LW/44TN2D4gO?=
 =?us-ascii?Q?otmuGnAS7wL16RIjjlr0fS1B+mE40xNCldsg+o1Zwp50WoVHy0Wj4lT+STZ2?=
 =?us-ascii?Q?0c/G0HZnp75Lt16vqy01CxweTroFMrp9P7rGw+RsvylaNkpXyCtpD46Assmf?=
 =?us-ascii?Q?sfkbEcEVYYkDpfk6wLgjnB3QEA5t8SWQQt6C9ZcYknqSslBeCln1mcUx6X44?=
 =?us-ascii?Q?oOfRY2UCMQqe/0U8LrPBkll7uYjr+4Zb2wZGzHJCJ+iw4nEKze00V8GHp5hl?=
 =?us-ascii?Q?SQIiU2pPYmcqA65yNWaUf0UJBTiY26jJiFSJv3du8tQ0bxEPGltf88UqBqo9?=
 =?us-ascii?Q?6bHizZliDADX0GN/EwIRuumrz/6mvjoKKPuBzhg28h8ibQEf4sgxu0BS6dTt?=
 =?us-ascii?Q?4yjq75YWURq/2tmQ30lbFUMx6F+WaRhkoOI6og/J0S2hAn9hwrevGXeep+6e?=
 =?us-ascii?Q?rf/mfH6pBIlCU6QbLFFyrJ+yLXlu4Hy45yKnphw88fwamur9AcIlzQKUKZR1?=
 =?us-ascii?Q?Fx/QC9KVZYkw51wz3oO4diAqgiDXitHSZDoPOyPLSQ89wlPl8CpodZ9lQ02M?=
 =?us-ascii?Q?OAhTVQ4LiVHuquHeQcoTwy+5QMzVFVZYjQWVkJaLYcPFU2EoYJvrp5giBk5U?=
 =?us-ascii?Q?qmZ3Yz8k0oYRvlKP1KzP0Ly4GKkMVULOdLSKwePPP7HHaA1qXuhd/ZNUVKKv?=
 =?us-ascii?Q?3hdtctjYTeeDEHqeG6xroa539yoWRsjsHc/MdfoA/Pik5CT2kXvUdyusdism?=
 =?us-ascii?Q?nvCyA3aAcSW0XliQ+CRVSq//1Fxk0KDLv9dEFHUk1MUQXdjtB0nOpgaEwQkW?=
 =?us-ascii?Q?yhD+dK69itPBl3JAeHDavRnQli01TXqGU0CsmX0PHZBe1fLZ1Ozf/IXQYgaN?=
 =?us-ascii?Q?QTbDQNMGgLnt8T5HoRp3Z0kMfavq5YF0OqOWW8u0G8NrOJzNiccQzPZUSinu?=
 =?us-ascii?Q?rzHaW0G+YpNUd0WGaCo/CjJqPfI0l45jWLrCdYlZsWQEKbrlTNoobcht6S4G?=
 =?us-ascii?Q?ywfN0WeeljqSDoiTEo6YwKRTpDLPPHwwBgNGW+N43yIwv4JPpNXTUO8fCy+M?=
 =?us-ascii?Q?RoYvl/pzOKG38y3zBRAfXCAIla9uSKHybIQzEcF6TYCgqRJVwC08nayjfpei?=
 =?us-ascii?Q?UxAvcjq4ROilWEbz3Qj0TIjakwpns4pFb5qTinn9j+dGGPxh2vmy8e7tJw3Z?=
 =?us-ascii?Q?kcPtdFQw+e+KNVVWM2lDv1KiDtSoQk6scJQeTUP9/jNPISC65Mnjkmg421O4?=
 =?us-ascii?Q?0zt91eo3Zzkb/kcynkwvq74h609ELDMRBM7lGjPa+toqIaqTIZOzYItqUh68?=
 =?us-ascii?Q?8ZboXzqiPoFCL9n0Cs3vQNFbQJT+VK8EvlohlFIDT+urZVhQIWGx4I3mbI2l?=
 =?us-ascii?Q?TzYtuUyaSCdcyNoXiZgwS0SC10mfARqxD5LluWW9jM4KZV/2D7o1LdTAsNsi?=
 =?us-ascii?Q?Vd2Q9BK32UQSlUkGGOPyQL0ICALRiye3YE0yKniHssCQnBIDouhKExrz3w39?=
 =?us-ascii?Q?FGdliC5iXjUTImqIEna0rwjbdpfcOEhJB5JMlRVtYl7P/mWbkfQQSs/CN8pH?=
 =?us-ascii?Q?jBzJwwyT5zVXqIohcY2icl9BOkRvcOnjVj5sHAU5krXT8uTdWXIDU/s6iv7y?=
 =?us-ascii?Q?ub1lFMLGZG1IhGWAYbiG96zq1sXsOSvLwQnGELuR17+VAkCMQtwQYOygKmf6?=
 =?us-ascii?Q?7nVC3dzy1Y2VZBBeVf6pWACKmtRkj+4=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c22e82c0-1d32-4b5c-1292-08da39b2bce6
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2022 16:15:06.5627
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nNsU7Qf8AD5Je7KSZP28x6ffcTGDcMzHvFEq2Z6D09/kMNjrWZX9AefojRDS7yDC7GwByDHJ7GUX6YKXWLFHQ6blKuaW83XSfdHhN+uk/JM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4495
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

On Thu, May 19, 2022 at 02:44:41PM +0000, Vladimir Oltean wrote:
> Hi Colin,
> 
> On Sat, May 14, 2022 at 03:00:10PM -0700, Colin Foster wrote:
> > On Mon, May 09, 2022 at 05:13:05PM +0000, Vladimir Oltean wrote:
> > > Hi Colin,
> > > 
> > > On Sun, May 08, 2022 at 11:52:57AM -0700, Colin Foster wrote:
> > > > 
> > > > 		mdio0: mdio0@0 {
> > > 
> > > This is going to be interesting. Some drivers with multiple MDIO buses
> > > create an "mdios" container with #address-cells = <1> and put the MDIO
> > > bus nodes under that. Others create an "mdio" node and an "mdio0" node
> > > (and no address for either of them).
> > > 
> > > The problem with the latter approach is that
> > > Documentation/devicetree/bindings/net/mdio.yaml does not accept the
> > > "mdio0"/"mdio1" node name for an MDIO bus.
> > 
> > I'm starting this implementation. Yep - it is interesting.
> > 
> > A quick grep for "mdios" only shows one hit:
> > arch/arm64/boot/dts/freescale/fsl-lx2160a-bluebox3.dts
> > 
> > While that has an mdios field (two, actually), each only has one mdio
> > bus, and they all seem to get parsed / registered through
> > sja1105_mdiobus_.*_register.
> > 
> > 
> > Is this change correct (I have a feeling it isn't):
> > 
> > ocelot-chip@0 {
> >     #address-cells = <1>;
> >     #size-cells = <0>;
> > 
> >     ...
> > 
> >     mdio0: mdio@0 {
> >         reg=<0>;
> >         ...
> >     };
> > 
> >     mdio1: mdio@1 {
> >         reg = <1>;
> >         ...
> >     };
> >     ...
> > };
> > 
> > When I run this with MFD's (use,)of_reg, things work as I'd expect. But
> > I don't directly have the option to use an "mdios" container here
> > because MFD runs "for_each_child_of_node" doesn't dig into
> > mdios->mdio0...
> 
> Sorry for the delayed response. I think you can avoid creating an
> "mdios" container node, but you need to provide some "reg" values based
> on which the MDIO controllers can be distinguished. What is your convention
> for "reg" values of MFD cells? Maybe pass the base address/size of this
> device's regmap as the "reg", even if the driver itself won't use it?

No worries. Everyone is busy.

Right now it looks like this:

}, {
    .name = "ocelot-miim0",
    .of_compatible = "mscc,ocelot-miim",
    .of_reg = 0,
    .use_of_reg = true,
    .num_resources = ARRAY_SIZE(vsc7512_miim0_resources),
    .resources = vsc7512_miim0_resources,
}, {
    .name = "ocelot-miim1",
    .of_compatible = "mscc,ocelot-miim",
    .num_resources = ARRAY_SIZE(vsc7512_miim1_resources),
    .of_reg = 1,
    .use_of_reg = true,
    .resources = vsc7512_miim1_resources,
}, {

"0" and "1" being somewhat arbitrary... although they are named as such
in the datasheet.


So you're thinking it might look more like:

.of_reg = vsc7512_miim0_resources[0].start,

and the device tree would be:

mdio0: mdio@0x7107009c {
    reg = <0x7107009c>;
};


I could see that making sense. The main thing I don't like is applying
the address-cells to every peripheral in the switch. It seems incorrect
to have:

switch {
    address-cells = <1>;
    mdio0: mdio@7107009c {
        reg = <0x7107009c>;
    };
    gpio: pinctrl {
        /* No reg parameter */
    };
};

That's what I currently have. To my surprise it actually doesn't throw
any warnings, which I would've expected.


I could see either 0/1 or the actual base addresses making sense.
Whichever you'd suggest.

I've got another day or two to button things up, so it looks like I
missed the boat for this release. This should be ready to go on day 1
after the window.
