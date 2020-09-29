Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 311ED27D34F
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 18:05:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730117AbgI2QFI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 12:05:08 -0400
Received: from mail-vi1eur05on2041.outbound.protection.outlook.com ([40.107.21.41]:48608
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729528AbgI2QFI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Sep 2020 12:05:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UXe6SEzmNI1AMNxMIStgL2HwOE9DkR1nD1vfwHiaJx7KRhQGDjKr9JMBpbtFdzQ3yGAUm3fy0u3eSYcfL29hOBuGq/N0YtLSIyn4wdk84TW7aQTuhkIqcXfFPdLB80Lgb+5Rji76frL6ThVlhOqUf8aEpyKa7GwYF5Ur9YZl2vX9+8PW5kXf+V8wqFlGZyG1bEF9CuJrV69cLq0a/CcCvJnlQwPlOHICR/Ny/EsKOIuJNDy7x9uBCYBatyhIzEqlPLXwKQhekRY/eFfTG3EjaOKzAJ947BkjIHV6jB2elmIOVLqP1ChRdS0ZVcQs+CW5+aEWrkbIFFp1Pa539CSGYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0AKGhZYFCU+dDvNaeLChfMQp0g4uWJUzmL47apN497k=;
 b=j/or8e7KDwvTe382vWsFli4S9LwePsDc+I11xar7aowLD1dKFYDVbJPXdaQNlVG5woXOF5rB5xnKcywndjU5K/MruB+8htbbJX12MT70iqChbdPxF3x1K1NFerZNDIalbu7vTYFqS828RlAwczZNtMKzqhrmC8YHNxhprW3boOVy0jUIbAB3mcKkuXN1YajQxXWzOnq74Hp95bQ8cxptowxjrQF637LRzJSJuOXJ+zwTInnO7P3dDHy1Tra/UseIfkG3/sKS53ky9rj3jlIwQ9XHxgZWk0D348b1lk43cjUeWEv9OSX7cmPjc29IZqHz8Z4aa9oB1+QFPVzQcry+Gg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0AKGhZYFCU+dDvNaeLChfMQp0g4uWJUzmL47apN497k=;
 b=DkFron5GM44ggD9NHCzcQsDwTKWOYQPXM56ke9g+cYQvDe+j51WYcLDKCqp2mUanDKVSKhyOTVCxdzzxXZBbEOd0kvheHQVGqj5X3mZMoiidt+kD4gM7ky6EGRw0XrYl3TVg8RmHLSSHzU1W/BTlqRBNxyEAswWN9icQk4I6flw=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB4228.eurprd04.prod.outlook.com (2603:10a6:208:66::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.24; Tue, 29 Sep
 2020 16:05:03 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::a997:35ae:220c:14ef]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::a997:35ae:220c:14ef%7]) with mapi id 15.20.3412.029; Tue, 29 Sep 2020
 16:05:03 +0000
Date:   Tue, 29 Sep 2020 21:34:43 +0530
From:   Calvin Johnson <calvin.johnson@oss.nxp.com>
To:     Grant Likely <grant.likely@arm.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Jon <jon@solid-run.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        netdev@vger.kernel.org, linux.cj@gmail.com,
        linux-acpi@vger.kernel.org, nd <nd@arm.com>
Subject: Re: [net-next PATCH v7 1/6] Documentation: ACPI: DSD: Document MDIO
 PHY
Message-ID: <20200929160443.GA9110@lsv03152.swis.in-blr01.nxp.com>
References: <20200715090400.4733-1-calvin.johnson@oss.nxp.com>
 <20200715090400.4733-2-calvin.johnson@oss.nxp.com>
 <f7d2de9c-a679-1ad2-d6ba-ca7e2f823343@arm.com>
 <20200929051703.GA10849@lsv03152.swis.in-blr01.nxp.com>
 <20200929134302.GF3950513@lunn.ch>
 <8dff0439-100c-cdee-915f-e793b55f9007@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8dff0439-100c-cdee-915f-e793b55f9007@arm.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: SG2PR04CA0143.apcprd04.prod.outlook.com
 (2603:1096:3:16::27) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR04CA0143.apcprd04.prod.outlook.com (2603:1096:3:16::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.34 via Frontend Transport; Tue, 29 Sep 2020 16:04:59 +0000
X-Originating-IP: [14.142.151.118]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 5cfdcd86-4a74-40b4-cbfd-08d864916c8a
X-MS-TrafficTypeDiagnostic: AM0PR04MB4228:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB4228A56AD923F29F2DA67858D2320@AM0PR04MB4228.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: m7kdSV/O+5iIogDjeKyDH5WDrpsoykSykSVkiNo9l74yHsi6oYHH184FSpuN3P6oN3cRvVW5H5e/QdTmSxpxqhbCZhd/o6QAL98AHWZlI/eCyRvNpReEnVFz6f3SSm1UMiWCAIB/9U5sFCFKqGSZ7FPpC0MZm2SEud6Ekb232OydA4ETA8MUY3wNTwWOtSxiSca2ZU6I92jeM3bWOKKS2Qpc5p5TwTlpZ5cUWGzKatKfECe2S0lzqs7n7VpeJUPQ5gFKOxd5MOqW4cNipsloPGk3rMJG/WhSbu82/aBElkVJpDdZHiLXSS+uejntjjokiSG3khEECMmHkivg7Ce3nmJs+kQ/luq/a42REvj7tEaS0HdRO4Xo2LOlZPdx+Li3+TVyoY+I9BvCo4BmybB7D5rLCDXM0LDu/mNREE7CLz5s/XL9wzz6DY0MgMkAGWpD8IooI4wMGESQw4m2drRFzvDHXgp8SmBf8+DPVKlq2j4CemhbZB7w/KExMG1GBqem
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(396003)(346002)(366004)(376002)(66946007)(66476007)(66556008)(186003)(54906003)(16526019)(9686003)(316002)(83380400001)(6916009)(86362001)(5660300002)(1076003)(33656002)(1006002)(6666004)(966005)(478600001)(8936002)(55016002)(956004)(44832011)(2906002)(52116002)(7696005)(7416002)(8676002)(55236004)(6506007)(53546011)(4326008)(26005)(110426005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: /Bd8gvVhND1P/Phyi5DbCciKYi6WTZxsqrzUx76Pc4PR6OHUbggbqY/mgfjD4KTB8NiVsIyr2UYDM9kg/7Q822zDUXp9k1XAbPL7FfCXfByaeC5MDR3Tbd9oq8/RWh9BSxJPb6TLsnbTW7FsdhXy1e7p8cRws6yROErwLPj7g4i+2Sn77w7ir26NlbhVtaKJv+O77RFMRjX87c0PwOXPHS2zROOYuLQkLIWq3OzmQ0WBEdXx7i5aNiI2t6qSj0WqsOc0W/JzFL91q6zi5XtGhphnpGrZp1cBVT7yhYz39OnrMaUgCNwD1cx2rYAXSh5BLp8i1Jc9yt9k+NPS36J1aH1uwEmVarzOd+okF2a1T+ldILtCsuTbpXVZuFg8HUiSMTNYbZUbT2DQHjU/v3I72Wd5VTN6AssSqlcFeg6M2k1boFhn1yt0XIp1+vquzSOgGxWYtOiyvNNfmb6P9i4qdzfE/KL9g/PYe2WPZnWQnqN5QdKinWpkekCx4CdOQiMTwDFZly8h9Ld4qfth0mvSF8QyMBdS4Xo8uMl8CfrSd8bZ5IepLNcj0fY5/T+SVOv3X/y7RP6UCnzuB/7/goQKpSVqLLuOkTfNxgjLlSnXF2n8Mm221iezU1YPho9W0d8hyiwXAbA14cdrymIMNkjPyw==
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5cfdcd86-4a74-40b4-cbfd-08d864916c8a
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2020 16:05:03.1793
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kx/t++PZxPqypcdGcwibwsdK7CzcI84D6nBkzv3EhBAg2bMN8Ll3fUpq37uVEH/Z4b8H+WdrWUJttGbvH5adUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4228
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 29, 2020 at 04:53:47PM +0100, Grant Likely wrote:
> 
> 
> On 29/09/2020 14:43, Andrew Lunn wrote:
> > On Tue, Sep 29, 2020 at 10:47:03AM +0530, Calvin Johnson wrote:
> > > Hi Grant,
> > > 
> > > On Fri, Sep 25, 2020 at 02:34:21PM +0100, Grant Likely wrote:
> > > > > +DSDT entry for MDIO node
> > > > > +------------------------
> > > > > +a) Silicon Component
> > > > > +--------------------
> > > > > +	Scope(_SB)
> > > > > +	{
> > > > > +	  Device(MDI0) {
> > > > > +	    Name(_HID, "NXP0006")
> > > > > +	    Name(_CCA, 1)
> > > > > +	    Name(_UID, 0)
> > > > > +	    Name(_CRS, ResourceTemplate() {
> > > > > +	      Memory32Fixed(ReadWrite, MDI0_BASE, MDI_LEN)
> > > > > +	      Interrupt(ResourceConsumer, Level, ActiveHigh, Shared)
> > > > > +	       {
> > > > > +		 MDI0_IT
> > > > > +	       }
> > > > > +	    }) // end of _CRS for MDI0
> > > > > +	    Name (_DSD, Package () {
> > > > > +	      ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
> > > > > +	      Package () {
> > > > > +		 Package () {"little-endian", 1},
> > > > > +	      }
> > > > 
> > > > Adopting the 'little-endian' property here makes little sense. This looks
> > > > like legacy from old PowerPC DT platforms that doesn't belong here. I would
> > > > drop this bit.
> > > 
> > > I'm unable to drop this as the xgmac_mdio driver relies on this variable to
> > > change the io access to little-endian. Default is big-endian.
> > > Please see:
> > > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/net/ethernet/freescale/xgmac_mdio.c?h=v5.9-rc7#n55
> > 
> > Hi Calvin
> > 
> > Are we talking about the bus controller endiannes, or the CPU
> > endianness?
> 
> This is orthogonal to the MDIO bus issue. This is a legacy of the xgmac IP
> block originating in PowerPC platforms with a big-endian bus wiring. The
> flag here tells the driver to use little endian when accessing MMIO
> registers.
> 
> > If we are talking about the CPU endiannes, are you plan on supporting
> > any big endian platforms using ACPI? If not, just hard code it.
> > Newbie ACPI question: Does ACPI even support big endian CPUs, given
> > its x86 origins? >
> > If this is the bus controller endianness, are all the SoCs you plan to
> > support via ACPI the same endianness? If they are all the same, you
> > can hard code it.
> 
> I would agree. The ACPI and DT probe paths are different. It would be easy
> to automatically set the little-endian flag by default when xgmac is
> described via ACPI.

Thanks Andrew and Grant for this suggestion. Yes, this is an easy way to solve
this problem. Will do that.

Regards
Calvin

