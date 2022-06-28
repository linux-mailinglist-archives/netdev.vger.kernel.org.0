Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A51755EF95
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 22:28:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232847AbiF1U1X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 16:27:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231629AbiF1U1L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 16:27:11 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2130.outbound.protection.outlook.com [40.107.93.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F09D63EABF;
        Tue, 28 Jun 2022 13:24:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XnO57DEwj35vub4VodnFZrr5FiSDqVLyrDXyJfPKWG2fy7VWQQkC8tSHFHvVT6x7kRxLhcTedCa3Uis11Nkh4FFrXOfQ1babWfmJD3l997r2cpLLaEqf09b+Wajvaazjm5qYPTDAKt4M1t2CSOw9U0fb75gphcvVxci4pf7Dr0XMTR1o87tlTCccbtBFgnoIrQMpkNEEyRXS8QXRyLkxSNjXzLcQWfj9mdOrvcKcXPSs+ZlGCXE0SMyA/FjbFT0aRIFvxkEscKI/gayAizAjkp34ziu3UFDhnF39tk82G9eQrQL8UTDxzHSL0dY813ygmQI0/nhSmSDwk3lLpcvHow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hhxSz/WXvqXBlexHjsl4bwD90IyLpxEGog6zAE6q94I=;
 b=m33UyivZpXCKoT1ZMoIpxMgPcVc3N3kOKtGMqNnxYwIK2eYRyt/bJYWldGGhkZ36KOn4l8+8/tGn4h8QPjn2cUcw1aKzs2tpuZRn4XQCxxXnNmjcGE59jYyhcAn4Ib8qpw+DcyBShchEn5Ocbe9ZdGtVgtHFYIYtbTHHa6XpfsY7afswA1aLNNwyHHYhVvrXnMfRgKZAW5juB8EYFeOO/RRni+wz72HW/KYpfDx1qyKeh3zypN203qT10DV3hs2gErTOHldIJzQHK0If4ShccsJ0CuY6pyEujY14GRh9n4kOxLspdwugSWUd237aVgNemIt5/QhH+JRErCyHamZpgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hhxSz/WXvqXBlexHjsl4bwD90IyLpxEGog6zAE6q94I=;
 b=IDj4KoSB88qmk7P56M05i5CriEtI+ow/aCy4T8jyM0Wn9SiYO5GTe5O+27XNrBpBNyxGPbDbuvs2rpiMm+1e/wmBVe0zHnVreWqQ3TIvTLkYZW8nYBk3VhXvIMmzhf5MnO2h2i/+h71R1PklwbGhQ5WGg1ANB7bR9RoK9LwWKcs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by CY4PR10MB1544.namprd10.prod.outlook.com
 (2603:10b6:903:2b::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.18; Tue, 28 Jun
 2022 20:24:25 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::712f:6916:3431:e74e]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::712f:6916:3431:e74e%6]) with mapi id 15.20.5373.018; Tue, 28 Jun 2022
 20:24:25 +0000
Date:   Tue, 28 Jun 2022 13:24:22 -0700
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-gpio@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Lee Jones <lee.jones@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
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
        Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: Re: [PATCH v11 net-next 9/9] mfd: ocelot: add support for the
 vsc7512 chip via spi
Message-ID: <20220628202422.GF855398@euler>
References: <20220628081709.829811-1-colin.foster@in-advantage.com>
 <20220628081709.829811-10-colin.foster@in-advantage.com>
 <ddb01b36-1369-f0e3-49ab-3c0a571fe708@infradead.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ddb01b36-1369-f0e3-49ab-3c0a571fe708@infradead.org>
X-ClientProxiedBy: MWHPR21CA0056.namprd21.prod.outlook.com
 (2603:10b6:300:db::18) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 301a6289-5e84-43fe-063a-08da594431b8
X-MS-TrafficTypeDiagnostic: CY4PR10MB1544:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: I64Zfutwp0eG8T55h5DQ62Y1FrMKsp+V6db6PuqgsGrZiKq3lt/tyNvDX1V3p+xI8SOtGSPnG5dlB5Wf9e91zhaPw15BPGddYG5vgkeLPKBgNIZ8wYNHHPsHDDJZDuCGvE0TBhmV0oSgYmzkUBGWFnszrbYskbQQf/tgOIoWvEZFCOZQ31mfQ5a5bSZ8RFME5thRjQ68OL21xqQXh2+KEZkWVdLqzrykCDCTFBZTBgXrj9DFC8KILxoh+tef3ndojHZWr6gQ+OhGj2C7RTkUYzac0YQRUBCDIgrspmBl6YSbKSKcEp8sPCf6bEgZqVVEsKH7pBHG+4rEGO3HBU93GIIIfPed7V2+fuckQIuozKX55Pr42L+W6YfHipLlBBOLXOoOWJR/gGBdBfb7+fOZZJZNzGZKEYB2aFp/qkM1m/+L8Oyp6XykpbvUHquR9BYi+ac61oCz/Xax/xQl4qhPrXmZTzDefZyaUOBbfrp7nfKH3JxkQgHGHT92UwpbKM+vyJ/9kQE7pwA93JY5gGV+gjbJH9XmjKK/4YYsfHUveZjg7/FEqgExOk/wXMh07+SADKFkI069vZsYCDMBp+HjYhoypydGuXZkPEpiHSdYH5fWS0bI1Ldyspy532sqKqu6QdFJ5L/aVuu0U3TrH/eHE/R2CGbzC60oA8kJm4PncpNPthjlHnJlvQQT4eQMmT4z19JqasDlczkHPP0Bdvd5LyGeYqQ+QtFChmLtZWVC9Im4gr9J21yQGEuMIBQCMsMlhWG/PcpknDcHp7PRgxr5/lx+2RlsFP7TajzNxXEo1FA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(39840400004)(346002)(366004)(396003)(136003)(376002)(38350700002)(6916009)(44832011)(2906002)(54906003)(6666004)(6486002)(1076003)(38100700002)(316002)(186003)(7416002)(478600001)(6506007)(8936002)(86362001)(33716001)(5660300002)(53546011)(52116002)(4326008)(33656002)(66476007)(26005)(8676002)(41300700001)(9686003)(66946007)(66556008)(6512007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?65ZqCL/i7gj/yfAdP58el4rKTuMIM2wI0g5EL9O4Y5LeUIXFHBuTWYwT+jQv?=
 =?us-ascii?Q?ee024mhApTZElF5f7XENDSM6FFVGwNvvLp9lz2ZD35IKMKTW6ppEX1jerYPX?=
 =?us-ascii?Q?SeNE3mrRS36OjmeF39S0qB4aOEwav3sd2pCAmpjahjlYLPqMX7YdVtSANUyz?=
 =?us-ascii?Q?1/3TylEJvso5a5knxOfrY2AXY1bMd3COJuZJGzqVD2KvVNCo5Z9L9+vmVVKj?=
 =?us-ascii?Q?SgK3A8qhp4PfmUAenwqWFv5asAnZ+/ftp20NTJIY0Eht8FxypKJ/FQQtgwIE?=
 =?us-ascii?Q?SCJcsOayYKKuJY6XENUXmY4a8cRycDeVjpR5m0oeoGYL1BlGJX3eXWWLJHY9?=
 =?us-ascii?Q?OWj2LudFy8bscqFv+icMtr0r3jaqPzLf7ezRYhpxSRCLxxh+khQ9bernE3GD?=
 =?us-ascii?Q?XfTJmRiykG3HpQCRxPkfFyjXcD/YzNik1A0MgSF/IL/czt1+aMqBQsO5YwQU?=
 =?us-ascii?Q?31tApU26va2VG4J18qIoXZvIBhwNDf4hsw58ZD1x33Enan3TmJ0lN3hPKXN6?=
 =?us-ascii?Q?cay8BF6O/iHFCVc9iQYFuczvR9IttsGy98nqO7q31MQVSz+ls4nj0GNXRW1+?=
 =?us-ascii?Q?L6cCzV81mtj+8mv2nJOiYzaK54Rvwfw5BONpTb0/dERkII8LgmQjgYTiL6Ya?=
 =?us-ascii?Q?vaIAu9wjqMtGHJn4ri5AONkBv1NHS2eAxOkW5CBeP8x3ZeZfx4c50reGIRvT?=
 =?us-ascii?Q?eFwoXBuiCOwwLZ/2uAXqNDFJGt6CzYRUr4Vrajqt8vDVziHG3INE2e7fZL1h?=
 =?us-ascii?Q?IhMrbdLH9Bc1A/fbfzMZeJVWdNUIQhwKEbgsoAQG4IHFkT8YPa2Q2Te6kegh?=
 =?us-ascii?Q?tvd3igMpZl0v+nUI1W6dDT0eVED4DLbyZFuuU59pHWm1NPQF6nYoggkSurFe?=
 =?us-ascii?Q?9Bca6zIOQMXJl4mKceJtJ+kFXkLnwq62IaSWhTpcC29XWL5HX+UitCriaOyD?=
 =?us-ascii?Q?7ZvFOVKekhJiqIBusSdZ3I+99w24AMoXkTsoZs58+XGZJw2Y2AwPpiXNhXgM?=
 =?us-ascii?Q?x95zUsCBE8AA47DRncTReC3+FiK5U/dYmlk/SM1SR25H652N1yhuE/1Wkthx?=
 =?us-ascii?Q?83AmY8cx1b+Ev467+Zu2iXPPP2aSPh3zCpiXfD0KT+R9KDXNYA8IIeQ0GWHM?=
 =?us-ascii?Q?hiK+FnQJcCpgSimGTQNpC3++8aUNGZl062VPg2oRlkysgV4+kUCgrX8IQvSx?=
 =?us-ascii?Q?KqdQgAxAymUKaotLAc3LzGBz39kQfZQ169RoSRZ2i29S2TmSYGYS0LxzUqZs?=
 =?us-ascii?Q?+a8wwSVVXQ9ikKfjBD/TyIANhO4R9HRK4isB+wwJEB0DCb9PfaFj/FR9AIN5?=
 =?us-ascii?Q?L/mbaPG6FPTDz/Mg9rIWuJ7ycNK8AhLvaqE11v72IzABzGnqhAUckGKvd0rV?=
 =?us-ascii?Q?cGSLRv/dSyD633d9m+Jjxle6oxMgT5RbPTzzM0Hkeq7WbdHwWDQmIU9SYRtM?=
 =?us-ascii?Q?obsb7GYAvxnNfVPr4+wuXZyUYxr3INZV4eF9dRzUdC6k0mYgxPp4D51wFwCi?=
 =?us-ascii?Q?P5u4V2ytdx+CgVCnwNHuBhlfu4zsmzS67h029veMxkCeQykPVcr2zV4JiGwi?=
 =?us-ascii?Q?PKJ46kdm/7RA4L22Z50nhyRc6YWK6/7wEN+gN9qPfBJvwozStAQJn0VJp6lI?=
 =?us-ascii?Q?NHGXglyjUU/P1QPq1yBUH20=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 301a6289-5e84-43fe-063a-08da594431b8
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2022 20:24:25.5325
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lK+IidhfyQPlFflwvUaOjeitFbCmBQznb3Q7PnId/ke7pR4bOLf+e9jg5E4vM3fW+8fv8z95I1XL2NNmTvNmgVhZqZUT9oWZ9Ma5F3Y3PcI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1544
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 28, 2022 at 01:07:51PM -0700, Randy Dunlap wrote:
> 
> 
> On 6/28/22 01:17, Colin Foster wrote:
> > --- a/drivers/mfd/Kconfig
> > +++ b/drivers/mfd/Kconfig
> > @@ -962,6 +962,24 @@ config MFD_MENF21BMC
> >  	  This driver can also be built as a module. If so the module
> >  	  will be called menf21bmc.
> >  
> > +config MFD_OCELOT
> > +	bool "Microsemi Ocelot External Control Support"
> > +	depends on SPI_MASTER
> > +	select MFD_CORE
> > +	select REGMAP_SPI
> > +	help
> > +	  Ocelot is a family of networking chips that support multiple ethernet
> > +	  and fibre interfaces. In addition to networking, they contain several
> > +	  other functions, including pictrl, MDIO, and communication with
> 
> 	Is that                      pinctrl,
> ?

Yep. Good catch. Thanks!

> 
> > +	  external chips. While some chips have an internal processor capable of
> > +	  running an OS, others don't. All chips can be controlled externally
> > +	  through different interfaces, including SPI, I2C, and PCIe.
> > +
> > +	  Say yes here to add support for Ocelot chips (VSC7511, VSC7512,
> > +	  VSC7513, VSC7514) controlled externally.
> > +
> > +	  If unsure, say N.
> 
> -- 
> ~Randy
