Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F1F8567867
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 22:31:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231358AbiGEUa0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 16:30:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231351AbiGEUaY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 16:30:24 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2123.outbound.protection.outlook.com [40.107.220.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 598D91C11D;
        Tue,  5 Jul 2022 13:30:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MmhJBqtaXDx/n0VfqqFvbdDC9ZLLrVmjzSqqXqVq4PFehJmXu7Ya/pirkjVQgNE4KOVUxRPnu5ia4TibMomVUAluiWs1969q388kjEY/AadUjlBqm7Bb0xmsu6L1yS9nAIgM92iGlU/BPUhawJAR+Dr0rDotA2QEWec1wz5K0PGf/Zat8vEKX7zglF/V9YVp/ov02XJoJlaMTV3q0GkA2iLH4q5/1O5f62s/Fnl/6XgtXUr4C4Iwb1Y+TJ/oFEFrjOG3czAkRc0rUH1R82NWMLUd8DySjauBBVoRs+e8MRgvtW3HRnB8/tOEauqL08lVGdpgwMWjvvH9b1RBVs0LBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ewt7xtqenT/f3Fqi86bvbWAR22GvkMi4JmzpIOiqrl8=;
 b=QyraZIfRYiHJV4BE/AskAygrDMPQ81OWzJrMKmEtjM2SehlWbOtba29OZlzzt9ighHFDwFofc0YhyK5kmHNOyn72J1NqJgE6TlqJqa8raY1U/lzb22dWOuidgGvWsfI18/Qe2su8kOSUTfwsWBEhiLcqeHWTkiJHXiqqYdj/iF1L/uiqo3cj8o+kXe53P41nVGb8fsV+hBxHMOzlmW54xWkSTbOc954hALiaY4JBng6WFK/zd/rjE6a8UpFPa+3+MY3vlO/CcsxyVUbIE6nn0GAC2nixP4QdhI4XZqbg21Xln5N2YwqNsOs9+JxuuWiYP1u7rwSXDyZeNI/z48YTHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ewt7xtqenT/f3Fqi86bvbWAR22GvkMi4JmzpIOiqrl8=;
 b=VVn1IIgPx8n85j+KGl3EipU1F+W7bT36SaRWUMXng7qAS0fUc/EVhTduFXtNupnmIleGVTjCbefAslHhy+yNM76XsrcU/4LcYHNZeIVgHWv9ndENrwMZ6eCUybpEkI37qswqFxm6psW3AdaRMkHCKdkRtu3YUmyCA8pPXwWygLo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by MWHPR10MB1487.namprd10.prod.outlook.com
 (2603:10b6:300:21::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.14; Tue, 5 Jul
 2022 20:30:20 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::712f:6916:3431:e74e]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::712f:6916:3431:e74e%6]) with mapi id 15.20.5395.020; Tue, 5 Jul 2022
 20:30:20 +0000
Date:   Tue, 5 Jul 2022 13:30:15 -0700
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Rob Herring <robh@kernel.org>
Cc:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-gpio@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Lee Jones <lee.jones@linaro.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Linus Walleij <linus.walleij@linaro.org>,
        Wolfram Sang <wsa@kernel.org>,
        Terry Bowman <terry.bowman@amd.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        katie.morris@in-advantage.com
Subject: Re: [PATCH v12 net-next 0/9] add support for VSC7512 control over SPI
Message-ID: <20220705203015.GA2830056@euler>
References: <20220701192609.3970317-1-colin.foster@in-advantage.com>
 <20220705202422.GA2546662-robh@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220705202422.GA2546662-robh@kernel.org>
X-ClientProxiedBy: MWHPR18CA0072.namprd18.prod.outlook.com
 (2603:10b6:300:39::34) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 838fadef-3197-4088-2b85-08da5ec52e10
X-MS-TrafficTypeDiagnostic: MWHPR10MB1487:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iDn1wt63QkjA1joj/CYlSu2aYrzH//s8tZX5t7NAgS8CGXK/qqRNlWrN42v7WJ4KHuWVeJqBUWlhtoFgOoUUjnIegZaMG4kIc+XEHvAmQNgSVTbM5O2lIqo3zuy8hNiDBGgQcJFmN5Bdagn9+Gk5fjuQfiA+lNwEBePAGHooIDJKMbON6HCSoNvf9Y/gClD4s43/b5yQxcHxawL3Y9XY/O0n4Ih4vmkpXGw2W6zqmro35gjOzOZgtU34x+EC9RjK/s4SXzv4uZ3L+pRDNYnwO11xUwZVhLlFRf79YJkfO7588jKjJXYdnFQvElDeIsaN1Me7p9hpIidxcwtDiABAP9VPAe3k9OLQRz95eDsR5+8KjNAwNfesActSzkfhjmBSuMZlz7QhbvyE11HzEU0gNdmSF0obHstfCzK7jviXOc03fd0K0ysySLz8IYsYwIqH94UDaAfLEewS2x2ILtTMR/ncvjl1V+st+yJXsBvRR88tHJsWqnlfqUUHBeZ5IQDmMoNSOdKeHoWvY0NvCSuHpf+glwXAfiXipeQHBy3sHq8t20Iq2Zfy4q9EaN6W+F2BUg3EgWrTAi8dq46tFUX12lR2b0wVSgo4M/LBKnuarTUDuMdA/7jqKXJem0VtGuHTKBruhUzLZN3e/ZCz/yHHHC6HXqNi3Ao64bD1JJGBeT0IDyOUFvlkGrIP9KWbeivEQu1aBOvl4MPkq2QwgDw6wluB2twbzWUg+opcGNqaTxgw20thkLfcFMsw2N2jCx1RYQgxU68Tofl3Rqk6LSwlvlujQaJMh1vuD+drxQwCgvtTImzW2QGmtvbioWkUABFU
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(376002)(39830400003)(346002)(366004)(396003)(136003)(478600001)(6666004)(6486002)(54906003)(41300700001)(7416002)(26005)(44832011)(6512007)(9686003)(316002)(8936002)(6916009)(5660300002)(52116002)(86362001)(186003)(4326008)(8676002)(66556008)(66476007)(66946007)(107886003)(38350700002)(38100700002)(33716001)(1076003)(6506007)(2906002)(83380400001)(33656002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rvZMRDdaIsRJ7C98LefsLebajT5gWoLIIxUzAo+WtEv6g+eL1onNwgrsDJZa?=
 =?us-ascii?Q?/qR6DzYubvX/5p5OwhebQzIFMGSi4sshsKZTerS/9SU1ku4kS/q9dmAY0CYc?=
 =?us-ascii?Q?joNo8f7lyitrt386XYNPC3aGWAK+XPDfJGn/YmkmvPBnVQllMKV/OarbNWoj?=
 =?us-ascii?Q?VYDsbJaPVSCz1OWxSn5YfyNL8GUZdxUnWp8JvrdVPyrO9QGob3uaG8jdeK1n?=
 =?us-ascii?Q?0XzKFLouskUqiRAJ+Np0BfyUPtzEM1IYzEYsoWLFwyIANrC99caDhQu23s1I?=
 =?us-ascii?Q?v7usRg4wVld5W4ngnEgsiqAMuCKp97kbjzi9gANOQRT72XYb8FH4jc0bMTtV?=
 =?us-ascii?Q?H7L4M+bwkNwYxIA9GiFhcnQZllZKRiXLx54AT+dAv2B0t88Nxa7HasgNFZ3I?=
 =?us-ascii?Q?RXXTnBF0gc+b3WvBybGcFP3SW+G4Uis+cvMTxe+TTIkVKOa+gEvKrFCS1WZp?=
 =?us-ascii?Q?qrLhIc/iflvTsCj4mgzwXEbNPu8QUdsWAzN/TGnZpRdqqylV+cTTLERbr90h?=
 =?us-ascii?Q?aA48aD0Z18vuBP2ODyACClCJMJly//k56DWf7nYJlonOEBKVOhI6a7bfVm/x?=
 =?us-ascii?Q?UGIKXKx6slf7ggJIoqjAuaheLQ1O0/hCg4oLUlsyxE/H0cCPYTiubz29U8mD?=
 =?us-ascii?Q?mbpiA94RZGS60KqIu0tVGd9nXZLRbn5UUqCOAtit0skq5yBkXXfyBj8kuCyU?=
 =?us-ascii?Q?9aGkvPr8CW8W/W7fhfhaVfEA3qqGBRtN1mlV93wkUkU+NZ7Zam/UO6o4jvxX?=
 =?us-ascii?Q?9RLzE4ofZZ0bx08/EHHU50C66bHuRN7UywRUgHVG68r90VLqprffEzD2uFX9?=
 =?us-ascii?Q?FSVhXFP8MUD04yDcGdkshGDui2mcBgDVpE//krKCYz4C/VOmBsXCHpMwM9W8?=
 =?us-ascii?Q?+5Y9M+koX/+hg1DPFDWr+X69mHaa9FUqMfkxkClgyo3EnqSta+TEP5rXCC7c?=
 =?us-ascii?Q?6dwCQ5Pi6w0Qde6+HR4D7KnHc2YbYBx8uiRrLT4W/8dG1tD7wPzCtKFtL/cd?=
 =?us-ascii?Q?be2kUZ62SGpYV8ehWna45a3joM8Ziya5hbZPRAxCvCNqO50pDN+3W/cJfEXD?=
 =?us-ascii?Q?1Rdo4FyrwswPzu7rOck0VR3Yq63zl4O43qMsaLEA7kbbtM5N92kAjNRevfG/?=
 =?us-ascii?Q?qvuKDUlHlzry9ICUKSYsdMPtv+WTwhWBK0Zk5v6hx7nmprwnSSKPtNbxpZmU?=
 =?us-ascii?Q?msYLwUcKrNzr+begLf864ow4aq3NWLZosJcOyf5C8EdkRbPUIqePsSjgUvIt?=
 =?us-ascii?Q?Nqu7gZ/LTE7g2PCeZKotjoiykkeipfPbxuhN5xgY/+Rsyy9Wx7fNPlybKsLU?=
 =?us-ascii?Q?J6exAl0I6YAC0ikNzEwktzPEQzt/NT74ZhgrQUKVHvWCvq5dYuRQWEDKDO2z?=
 =?us-ascii?Q?Ed/lkxbeDL9KE1Ds4BiMkU2HqkuWJpaara9JkKtwiYkUeLukz5rWAmAfTQH+?=
 =?us-ascii?Q?WdUSrcHcOkgfEwNkug4SlzqjE6zaJ+V6h7D1egcI3E4lkSwLrHhGcY2lz4KH?=
 =?us-ascii?Q?j26T9OnApqJXZLEXKTKFBIXj+3zYZTBkyQej7d2yWzfhhlBnDp0tvMhqJyQL?=
 =?us-ascii?Q?2nWvx96YMSjr0dZXUoO981HX2kpQCRbQr4hAno/22UZ6/8fN8FLWSVL08y8/?=
 =?us-ascii?Q?1w=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 838fadef-3197-4088-2b85-08da5ec52e10
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jul 2022 20:30:20.3382
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IS1ovhf/6/q7EmFPjvJSYWdguMzdWi7owi92Lfj5m0riUfFl02bAyERbAl7YxtY62kfRX8xLUUZz0QtPpdEfR5nqmNkWfz9IisrLXVkDmOc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1487
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 05, 2022 at 02:24:22PM -0600, Rob Herring wrote:
> On Fri, Jul 01, 2022 at 12:26:00PM -0700, Colin Foster wrote:
> > The patch set in general is to add support for the VSC7512, and
> > eventually the VSC7511, VSC7513 and VSC7514 devices controlled over
> > SPI. Specifically this patch set enables pinctrl, serial gpio expander
> > access, and control of an internal and an external MDIO bus.
> > 
> > I have mentioned previously:
> > The hardware setup I'm using for development is a beaglebone black, with
> > jumpers from SPI0 to the microchip VSC7512 dev board. The microchip dev
> > board has been modified to not boot from flash, but wait for SPI. An
> > ethernet cable is connected from the beaglebone ethernet to port 0 of
> > the dev board. Network functionality will be included in a future patch set.
> > 
> > The device tree I'm using is included in the documentation, so I'll not
> > include that in this cover letter. I have exported the serial GPIOs to the
> > LEDs, and verified functionality via
> > "echo heartbeat > sys/class/leds/port0led/trigger"
> > 
> > / {
> > 	vscleds {
> > 		compatible = "gpio-leds";
> > 		vscled@0 {
> > 			label = "port0led";
> > 			gpios = <&sgpio_out1 0 0 GPIO_ACTIVE_LOW>;
> > 			default-state = "off";
> > 		};
> > 		vscled@1 {
> > 			label = "port0led1";
> > 			gpios = <&sgpio_out1 0 1 GPIO_ACTIVE_LOW>;
> > 			default-state = "off";
> > 		};
> > [ ... ]
> > 	};
> > };
> > 
> > [    0.000000] Booting Linux on physical CPU 0x0
> > [    0.000000] Linux version 5.19.0-rc3-00745-g30c05ffbecdc (arm-linux-gnueabi-gcc (Ubuntu 9.4.0-1ubuntu1~20.04.1) 9.4.0, GNU ld (GNU Binutils for Ubuntu) 2.34) #826 SMP PREEMPT Fri Jul 1 11:26:44 PDT 2022
> > ...
> > [    1.952616] pinctrl-ocelot ocelot-pinctrl.0.auto: DMA mask not set
> > [    1.956522] pinctrl-ocelot ocelot-pinctrl.0.auto: driver registered
> > [    1.967188] pinctrl-microchip-sgpio ocelot-sgpio.1.auto: DMA mask not set
> > [    1.983763] mscc-miim ocelot-miim0.2.auto: DMA mask not set
> > [    3.020687] mscc-miim ocelot-miim1.3.auto: DMA mask not set
> > 
> > 
> > I only have hardware to test the last patch, so any testers are welcome.
> > I've been extra cautious about the ocelot_regmap_from_resource helper
> > function, both before and after the last patch. I accidentally broke it
> > in the past and would like to avoid doing so again.
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
> >       order of magnitude
> >     * Add two additional patches to utilize phylink_generic_validate
> >     * Changed GPL V2 to GPL in licenses where applicable (checkpatch)
> >     * Remove initial hsio/serdes changes from the RFC
> > 
> > v9
> >     * Submitting as a PATCH instead of an RFC
> >     * Remove switch functionality - will be a separate patch set
> >     * Remove Kconfig tristate module options
> >     * Another round of suggestions from Lee, Vladimir, and Andy. Many
> >       thanks!
> >     * Add documentation
> >     * Update maintainers
> > 
> > v10
> >     * Fix warming by removing unused function
> > 
> > v11
> >     * Suggestions from Rob and Andy. Thanks!
> >     * Add pinctrl module functionality back and fixing those features
> >     * Fix aarch64 compiler error
> > 
> > v12
> >     * Suggestions from Vladimir, Andy, Randy, and Rob. Thanks as always!
> 
> Not all that useful as a changelog. I have no idea what I told you as 
> that was probably 100s of reviews ago. When writing changelogs for patch 
> revisions, you need to describe what changed. And it's best to put that 
> into the relevant patch. IOW, I want to know what I said to change so I 
> know what I need to look at again in particular.
> 
> And now that I've found v11, 'suggestions from Rob' isn't really 
> accurate as you fixed errors reported by running the tools.
> 
> Rob

Good point - I'll be more clear going forward.
