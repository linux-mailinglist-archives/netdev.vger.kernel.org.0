Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEBE43074D1
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 12:32:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231461AbhA1L26 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 06:28:58 -0500
Received: from mail-eopbgr00071.outbound.protection.outlook.com ([40.107.0.71]:49709
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231264AbhA1L2j (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Jan 2021 06:28:39 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dWGS45VEsoFsNeDxdCV94DZgeBH41Rg2hbWGikgA7hr6Klj96ncTNU35ba1xy4iqUJX5KXFHFqiPzgrG65Cp7dRsm+Rqmie49WSGg9VM6YKzMHdqCQUboK9EiczUcWAkgvYCZNw2C6AR5P1KvuLTAd8GzIETFCpwkl44xFuBPpa8fbq4E41OIjvscv1s3Pe1lf5Jd2EpOC8cHQt1yrggGDvAcG6E4qe3ZNgBr+AJ9d9vegOAhkKELZ2DgOB5pnHs5Z4WH7lNys8VgwXq+UgNyCe4xbf60Y2XkPZE74ZvANG10xHYch0U1w3dPwIs9HLG8Y/XHOVzk/JeYag9WYXo7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7bpqcwIOonLdK1BVqqZ5xOZvdeDtU8MvgoJpvYFq+tE=;
 b=FTMSqj+T843nyVOGDIjNlPnvVltFJgcsUeiTVgtyB1zf4zZGX+6Wiblbl8cD+vbCy5KILgLPZ3KBjXbvEexxTbRIkfy8+Ujc+TxVBneyuKfVEEDYXh1i5sx0gxZI5ztLmX1LsUdP0D37JKlW+xxCEtDD2Af1mKuBpKX3taGapLyLesDb6ypAQ8NFdqWxI90zH5+98xrHuW8X5Lw/lMRwuGA8pylkvdbG68x4bofiV4pBeLit9vBE7TBLcCwh6o2pyR6iOF9QHvDImX4L1vb/ZDvvRogMm8CRhkCGbiHiRsasIo9bKUT1YMkswk2H8hbBQW2kXr8rqpoAZujK/EEkkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7bpqcwIOonLdK1BVqqZ5xOZvdeDtU8MvgoJpvYFq+tE=;
 b=ml6xvfQNg1MGycOp1qMT+94wIH05+6LwMQBToXjztg+DTup8Uc+ta+HqFFgugCb4ny+EHn4aUevVTRHVkmlyJ2pdUGeCN8vC5iB2GOGTEmc9YJjIw0TdnuACX1J4FH11AXiNpFcOJ7v/KuUV7ecMJjHPSeaJHAB9LSGme1YrIFw=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB5475.eurprd04.prod.outlook.com (2603:10a6:208:115::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.15; Thu, 28 Jan
 2021 11:27:50 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::e90e:b1d6:18a2:2d42]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::e90e:b1d6:18a2:2d42%5]) with mapi id 15.20.3784.015; Thu, 28 Jan 2021
 11:27:49 +0000
Date:   Thu, 28 Jan 2021 16:57:29 +0530
From:   Calvin Johnson <calvin.johnson@oss.nxp.com>
To:     "Rafael J. Wysocki" <rafael@kernel.org>
Cc:     Grant Likely <grant.likely@arm.com>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Florin Laurentiu Chiculita <florinlaurentiu.chiculita@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Pieter Jansen Van Vuuren <pieter.jansenvv@bamboosystems.io>,
        Jon <jon@solid-run.com>, Saravana Kannan <saravanak@google.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        "linux.cj" <linux.cj@gmail.com>,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: Re: [net-next PATCH v4 01/15] Documentation: ACPI: DSD: Document
 MDIO PHY
Message-ID: <20210128112729.GA28413@lsv03152.swis.in-blr01.nxp.com>
References: <20210122154300.7628-1-calvin.johnson@oss.nxp.com>
 <20210122154300.7628-2-calvin.johnson@oss.nxp.com>
 <CAJZ5v0iX3uU36448ALA20hiVk968VKTsvgwLrp8ur96MQo3Acw@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJZ5v0iX3uU36448ALA20hiVk968VKTsvgwLrp8ur96MQo3Acw@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [14.142.151.118]
X-ClientProxiedBy: SG2PR03CA0100.apcprd03.prod.outlook.com
 (2603:1096:4:7c::28) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR03CA0100.apcprd03.prod.outlook.com (2603:1096:4:7c::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.8 via Frontend Transport; Thu, 28 Jan 2021 11:27:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 0ce17817-7128-4ff6-b133-08d8c37fbe3e
X-MS-TrafficTypeDiagnostic: AM0PR04MB5475:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB5475BD84E5DAAC19F442DD42D2BA9@AM0PR04MB5475.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BMXMRtJ9yLoKWvJM2uWqOEUq2MnxrPnJuMazcciPPUNbqpWiVplg2YvRXrchAWFl1apPT7we+Na/hVpsbw7ibZyCTNc4Sc139opr5jVnB4VROY/FXojCN8gsz87Cvc3byLJS1MZcx1nToWSIE9P1S83j6NdiSAvlyNExNzJ9XBBwhHUv/ZlJ7VhmRW9OgV0CPogMG1HX9IKHZq8D+1kkH8ZjUasOE+AgIfGHQ96aFvrCTjjfPCBpvLyza9X+Pk/ISrDpTQrMu6qZrZ3XNPzQZWElaZOLNNtFHBLpNH4a7qYU2GPKXLrEqdS8XisNUKHeGSVqvvarTP+++HMb73pFNIq+SQH7e44TI+EbvnxY8lfgLl07dZu/aMNbzkSyKUpI7W+UZ406j47m3Z4nDzqT+6zLD0EBiccvXDedP3poMXUKUr586PJasfD8t84b8voMzlCKpVCr9azgKiYlGtFqUaUy2iIIPUVxXd3Od4rZoVaB+UUxgP4x6cTrjt9LZlQ9l/I0VrwKA9vILeHtAUdBvJ9G5j4eC5dN42uWmUUSIm/QyaCHiU7Sbfue9edCuq9emmd5Lk0dEfw5QuPAjcmJDQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(366004)(376002)(346002)(39860400002)(316002)(478600001)(8676002)(6916009)(33656002)(44832011)(83380400001)(9686003)(7416002)(55016002)(52116002)(186003)(86362001)(7696005)(54906003)(6666004)(956004)(2906002)(26005)(1006002)(66946007)(66476007)(8936002)(55236004)(1076003)(5660300002)(4326008)(66556008)(16526019)(6506007)(53546011)(110426009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?ZPwmxZtvLynJVhLE3Brji1TVcFgVCuM0lgxJ9kL24W6g8XGTzyquwOkKmcHT?=
 =?us-ascii?Q?AnUrzVamSKoMRJyWo9CETr0wo6t/wHZUXABJWX9XXP/M3DVpgKKO23t6DG19?=
 =?us-ascii?Q?2ZAcbVTZujgvD5aF9VRm9coU0qRLS6MHBvXtIo01lGuC+Tv927t+VPGvQB2X?=
 =?us-ascii?Q?MMHa40d4hPNFvXYvuhIWw/+/b7LE4bPMgzEL7QB/nYD1UBEGxforibTkX8Xc?=
 =?us-ascii?Q?kayewSb/yhySYAgN+4qyFO10ynez/49/Kf288NYl17PCPw89F2LmSUcDjqJd?=
 =?us-ascii?Q?HdM3WvhvfR+hS0Rm93OaeoIrx0gdq2Kowj9IlC1QZVLlxuWdaiEiux0Xqbbl?=
 =?us-ascii?Q?oy/ojBt+vXqxOYkqWLOMOR+0sl/1bKBZdi659jOIkhFr/8TgbHIvd2QpzESK?=
 =?us-ascii?Q?68frWSviUaBzAPSRx2px8uMBiEVwc5uNqY5+nO2Y38HsQjglCWRLmEFiUCRm?=
 =?us-ascii?Q?HuDN3gY6ESyVSRm3xqCZJ+RzC0/C8Q6FXVwOz0SkgN3Mab358C3STHNuPUrX?=
 =?us-ascii?Q?XzKRNpEcMJTEHMN63n3wwWUh6lrk8KLsgiFy0qepyCliRtYjEjN6jWc3Lq62?=
 =?us-ascii?Q?dccF8h2mpJJ2aYq8BcWR6zXyj248afgZ5/agl68OOJr9jL2UBljqmJJJ5mMb?=
 =?us-ascii?Q?pjGPlfDu9VtFA8MK7zIeTYTi6wvNa/uUifqEOHLH2F1Dmm3IsontVzVAyb4N?=
 =?us-ascii?Q?eYJ+pm1luGbADa69z3GOSxVXCvqLacy0ACiwa5SG6n+0Xot4VLt16V3VrVv4?=
 =?us-ascii?Q?mU/rBP+5m13qNEhBVu5WVPQZO4UJKTBcHBLYVUNmjl5K/czbqEt+0LmJGgON?=
 =?us-ascii?Q?HcRCiRX83JqWardjEB0Z+PIN9RHaZO44LLgk19S/RPCUvfE17Vgnd9HJZsK4?=
 =?us-ascii?Q?VOHiaetifFVvnVn08ZdSaOGwv05rhiE7jL1x0fnYgDuaU0Posojp9NbXIO8S?=
 =?us-ascii?Q?/2LDDT31WBfi+BQG2AYFAtvFKP4LazmtjwrCHTH4ibuoqsmXn/qXgWPhhIC2?=
 =?us-ascii?Q?ss+8W3CoRlBKoP4VESD0g8fltrsNs0Wyr8aigQOux2heO26gIXgFV8BCU++Z?=
 =?us-ascii?Q?aAuUIAnB?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ce17817-7128-4ff6-b133-08d8c37fbe3e
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2021 11:27:49.8294
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dSD9kCiBXDIuDwRfYV8tXig/PMluBb4gRWDFZ32TjYiBIVVqJElLAU0qt5Y08lAbM6FiCghX4rwbtHfovhRVVQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5475
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Rafael,

Thanks for the review. I'll work on all the comments.

On Fri, Jan 22, 2021 at 08:22:21PM +0100, Rafael J. Wysocki wrote:
> On Fri, Jan 22, 2021 at 4:43 PM Calvin Johnson
> <calvin.johnson@oss.nxp.com> wrote:
> >
> > Introduce ACPI mechanism to get PHYs registered on a MDIO bus and
> > provide them to be connected to MAC.
> >
> > Describe properties "phy-handle" and "phy-mode".
> >
> > Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
> > ---
> >
> > Changes in v4:
> > - More cleanup
> 
> This looks much better that the previous versions IMV, some nits below.
> 
> > Changes in v3: None
> > Changes in v2:
> > - Updated with more description in document
> >
> >  Documentation/firmware-guide/acpi/dsd/phy.rst | 129 ++++++++++++++++++
> >  1 file changed, 129 insertions(+)
> >  create mode 100644 Documentation/firmware-guide/acpi/dsd/phy.rst
> >
> > diff --git a/Documentation/firmware-guide/acpi/dsd/phy.rst b/Documentation/firmware-guide/acpi/dsd/phy.rst
> > new file mode 100644
> > index 000000000000..76fca994bc99
> > --- /dev/null
> > +++ b/Documentation/firmware-guide/acpi/dsd/phy.rst
> > @@ -0,0 +1,129 @@
> > +.. SPDX-License-Identifier: GPL-2.0
> > +
> > +=========================
> > +MDIO bus and PHYs in ACPI
> > +=========================
> > +
> > +The PHYs on an MDIO bus [1] are probed and registered using
> > +fwnode_mdiobus_register_phy().
> 
> Empty line here, please.
> 
> > +Later, for connecting these PHYs to MAC, the PHYs registered on the
> > +MDIO bus have to be referenced.
> > +
> > +The UUID given below should be used as mentioned in the "Device Properties
> > +UUID For _DSD" [2] document.
> > +   - UUID: daffd814-6eba-4d8c-8a91-bc9bbf4aa301
> 
> I would drop the above paragraph.
> 
> > +
> > +This document introduces two _DSD properties that are to be used
> > +for PHYs on the MDIO bus.[3]
> 
> I'd say "for connecting PHYs on the MDIO bus [3] to the MAC layer."
> above and add the following here:
> 
> "These properties are defined in accordance with the "Device
> Properties UUID For _DSD" [2] document and the
> daffd814-6eba-4d8c-8a91-bc9bbf4aa301 UUID must be used in the Device
> Data Descriptors containing them."
> 
> > +
> > +phy-handle
> > +----------
> > +For each MAC node, a device property "phy-handle" is used to reference
> > +the PHY that is registered on an MDIO bus. This is mandatory for
> > +network interfaces that have PHYs connected to MAC via MDIO bus.
> > +
> > +During the MDIO bus driver initialization, PHYs on this bus are probed
> > +using the _ADR object as shown below and are registered on the MDIO bus.
> 
> Do you want to mention the "reg" property here?  I think it would be
> useful to do that.

No. I think we should adhere to _ADR in MDIO case. The "reg" property for ACPI
may be useful for other use cases that Andy is aware of.

Regards
Calvin
