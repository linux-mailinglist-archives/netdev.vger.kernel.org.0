Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03C093C3E0A
	for <lists+netdev@lfdr.de>; Sun, 11 Jul 2021 18:42:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232613AbhGKQor (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Jul 2021 12:44:47 -0400
Received: from mail-bn7nam10on2094.outbound.protection.outlook.com ([40.107.92.94]:54832
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229817AbhGKQoq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 11 Jul 2021 12:44:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aqoGVmkeriw4I51KIvD56MpdGr26qCHOUt/i3p4iXAZtE96kSYye0kbmEePhNc+DZLt+49jPGdZdhSGu65gQZmGA0CQh7eLWjqwtFtf19cGaxD81HGd2FUXoxiLn80dvBuAjgvoH+O0Ss+VXClIrhcFUYLAZKlHFUNfclmZuw8NZDXDNiV9/3M9JeHlC3pbY5npGfyFNCiNQ+Qo3s22MJIKjAlFZpUhqQxNduldpc6O2oJ95QKEPMTWTnUbkBe/KgIt80saNwyzm5BNjiv8/fiVG+MM7zY4DgWEmGrCrTpLVlK1ZidhYiJUDuWMAhAj12EenVBUHmHm5uR/9H8Ya7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K49tqi3VqJ7BwS60/L4FCGdontYv7TtrmjwvPwvlCSM=;
 b=eRNdFY+/IbCqLi1wJkpDxQiyYlbOCOD7O+0Jr5tnuIktpE4+08/oXVv9WNfkJXSx+5kmbrcddLJ/qWtVpPciQVSwKd1Yp2NNvRvYex8DDpFFOg6k23gPN0XEYs/fmbV/usd0WZVTV5CxmLxf4cU763W3Vd+SjFjFw9GgH56LfaBCFiq560oXalYO/WvPvgeKq6yp8pMhWt1ffitOTZSkVuEsz7a+/sD3cHp2LO9zFzZ1zVd81DNT89J6zUFfFs507GWG4UMTQuxK74OM4rke+pR5ln0GBLj2tEnL86JxqPRfDvvH4InkQK1OgHOuEV0KFG79Zan89VGlw+AvJ19QbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K49tqi3VqJ7BwS60/L4FCGdontYv7TtrmjwvPwvlCSM=;
 b=mwtybTVOSf34FmfR1n44sOJ5JtFs9vC2LDK8CMVfKWrh0OxadVlmFMn0GpJoVr91xYYvpEERcy2kUIPkERPwvczUG5Ze3axPalYr2OGiOk7gIWEmmsnH1025oLvw3wsfMV+/xeaYnoiDL1M+ZBUFPDEGngfiuvQaEVQl744uaY8=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by CO1PR10MB4611.namprd10.prod.outlook.com
 (2603:10b6:303:92::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.19; Sun, 11 Jul
 2021 16:41:56 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::e81f:cf8e:6ad6:d24d]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::e81f:cf8e:6ad6:d24d%3]) with mapi id 15.20.4308.026; Sun, 11 Jul 2021
 16:41:56 +0000
Date:   Sun, 11 Jul 2021 09:41:53 -0700
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        claudiu.manoil@nxp.com, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, linux@armlinux.org.uk,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 net-next 2/8] net: dsa: ocelot: felix: move MDIO
 access to a common location
Message-ID: <20210711164153.GC2219684@euler>
References: <20210710192602.2186370-1-colin.foster@in-advantage.com>
 <20210710192602.2186370-3-colin.foster@in-advantage.com>
 <20210710195913.owqvc7llnya74axl@skbuf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210710195913.owqvc7llnya74axl@skbuf>
X-ClientProxiedBy: SJ0PR03CA0222.namprd03.prod.outlook.com
 (2603:10b6:a03:39f::17) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from euler (67.185.175.147) by SJ0PR03CA0222.namprd03.prod.outlook.com (2603:10b6:a03:39f::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.19 via Frontend Transport; Sun, 11 Jul 2021 16:41:55 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 164a69ce-6943-42f3-42bc-08d9448acbab
X-MS-TrafficTypeDiagnostic: CO1PR10MB4611:
X-Microsoft-Antispam-PRVS: <CO1PR10MB46111C92D5D197A500C7AD59A4169@CO1PR10MB4611.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: U3LlQP4BNZAd1p/7faD2JkJQTzsxA4DUn45fa7XFAkqzeCnEr5CJuyQvre9pDfKZcIIPzFtk0AcUpuGdW5AvVMJGlLUhp42ZoQ5NpnNwjHzHgmNS5tz8WWiv/46PxLo7cw5fjRC+GG75qAzu7kAK3WcIOAqYigLBjQNWn0dsLi44ccdGnok0BeQaCvZn9C7C3fjFojMxgkYaEAKAVHkju2a+u2D+gFFiv+zZqENPQmAiMtqDRyxVLdSv4qfhZRg8OMiAIGZkdUfmTuexJlstxsltDurcTArQNsxR/Xb4RzlQWjMgKz2L0QGpasiEFQlE4JZtMRDh4oZWdARX4cp76wx2fGjzTbXdjJYUPQIqrc86Q5WqWUQwqPovEud6Mxm8fYa2Srjs/G8yWsWApENsU3n//xNLlfbMaNHbKjYKKmm8rKU65enGFLLZVk81U/ZFumhSBMSo2fWj1j8prQTDOf9C1nifvinJckOAaKeoisoYeu+N0MT43U2N02+DXifPj8/TM1c8tePnmSmu3Nc+VTwwDOMrTwIG10BkbRWrtAIwfbDyS5VtoEGzBVwgn9wCPTVnbMHlGav75EEiHz9CxnfnE9Eeu1ACK0GIoRJuNvPd1raZcnA8hbX51QpdKsMurLrp4cdhfdnOwr2rAHdSqUdNHpxqOO8tCzFmOLC9GNER0Z7AKiUOR/BJrW1JOR+TCD5RU+1Ps49wHtoWZ4Z9vw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(376002)(366004)(346002)(39840400004)(66556008)(66476007)(26005)(956004)(478600001)(55016002)(8676002)(9576002)(86362001)(33656002)(83380400001)(52116002)(6496006)(38350700002)(316002)(66946007)(2906002)(9686003)(44832011)(33716001)(8936002)(4326008)(38100700002)(1076003)(186003)(4744005)(5660300002)(6916009)(7416002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8ro3128sZcAMCszi7+M2WlXYvxM6yOl38Cj3qI/0P1GCeM0w4I8IxBArUIfN?=
 =?us-ascii?Q?U/ZqV9VbEVo4KvMabGFVNcKTR+feo2IAabrXsqyjaor7lImT+6D9NFYsZu7v?=
 =?us-ascii?Q?5aYdHTNIAjeT/FFTCSfVAIjYaSrHabEohcuAK3SeuFOabOj4m420H7oqcNDw?=
 =?us-ascii?Q?C97pVCAE0lhXrwHuNDqPV3VE3i1Cg69L6SZW4VJlCQ/qbZsrTgb7HxdAfchu?=
 =?us-ascii?Q?LewVbE7celwiRFV+vQUNXXR/0WWNtdBa0aQuPKNGxzOF4Nn5EezTJxsVU/aO?=
 =?us-ascii?Q?hCFoK6JX5AFx1H2VbYip6L4e7+n/60xeqEwnre/Jh7Fq0WjmNpm8ddYMITx2?=
 =?us-ascii?Q?k5TtrjtbguprEhfuaG45gSkFMjFQLfhHG9WpNlBTX5VAzXTSKBqBr0hkYTc2?=
 =?us-ascii?Q?GQ8tGfS/KteA1sXV4n0khuAPihzPJZkOUsCCKCiTBzV2UsKLvzKpqQwtKNEx?=
 =?us-ascii?Q?kmunOrJ3LaYp6zmUG8GjQei5q1/TjDbzmpMzvI4px+tI19DCIbDdOxvMFgv/?=
 =?us-ascii?Q?875gQ1w03r0cllie7sqEJeT1bCEodUeUa8Rd0uwv28B8Jl1Gtg2/zqE7TFUz?=
 =?us-ascii?Q?zA8Kl4CkIsdIs41hFQD8HxXzzUC69jXxOnRa+13EVtV6h3QlLtM1VHUOZ0rs?=
 =?us-ascii?Q?w5pqSZvQPel6/qE/1RBD+WDJ12EuelzlqyhTb3u2B0SdleGW6O3rrYf+afUM?=
 =?us-ascii?Q?6drmLV5hPpFjj8j0PThQ+cWGqGwBjV4jNjj8CRpqlFQ1NTKtd4PMvTrbU6MS?=
 =?us-ascii?Q?xnJNc2LNx/smdgPum5buTgAN5Rdy6z7HPSiO6Ff4msCW63IoVosTkbvSzgKn?=
 =?us-ascii?Q?LpnKQ0IZaMSwJSwNrGnSk4+9KuH8n0skahOsLHSCngKPz9ePYHDL2p9wIhdo?=
 =?us-ascii?Q?9TjZ0MlplfOPpHsqActn5iSLB9lfTCZ8D1ai1LWQV6fJ0iNPlFXC6ATbgWFD?=
 =?us-ascii?Q?qp2mK0OX/9kjPzvrKEO+1rj35fr7Dob0eBkk0pspxPTi4hgMwi8VOlml1Pz/?=
 =?us-ascii?Q?nega8jpRszXaexQPTu0d+4Uj443oZZwq6Xskbx6cFQWo023GdLWjUmawWj67?=
 =?us-ascii?Q?7rvkrPrXduRjuqheEgrJidmquCUXTWNG42aUg+PjEfqOZqCpm1xCQKOcHC4s?=
 =?us-ascii?Q?TB/9LUFw5KuQJjwkt290uzaL5j//OMuOSaR0S51UgzbuMzqfmZvbChKSJRf2?=
 =?us-ascii?Q?qZ9i/Hmh/wMRILjAYJe6V9y+29Is1hDa3wmX7X8rybytnzwc8y1J+QL4lYFM?=
 =?us-ascii?Q?3LnmqX5jb2j0QtGwTghe79isz8C3emNqoX3lLHQeV7y8SvBn/OsVKJ4Z3H8E?=
 =?us-ascii?Q?p7FyLKyDj60+slg2PE7+09jU?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 164a69ce-6943-42f3-42bc-08d9448acbab
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2021 16:41:56.5368
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FVbUjJZFyanI5nwvbmAkhYPNXsShTCxtNysh7IgW74CARPZGdLEBARfbP5+EgQe4idb2E8EW7kQsufSnJFuAo+kCPLuIKKAfx4pNdl2Weng=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4611
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 10, 2021 at 10:59:13PM +0300, Vladimir Oltean wrote:
> On Sat, Jul 10, 2021 at 12:25:56PM -0700, Colin Foster wrote:
> > Indirect MDIO access is a feature that doesn't need to be specific to the
> > Seville driver. Separate the feature to a common file so it can be shared.
> > 
> > Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> > ---
> 
> In fact, this same piece of hardware has a dedicated driver inside
> drivers/net/mdio/mdio-mscc-miim.c. The only problem is that it doesn't
> work with regmap, and especially not with a caller-supplied regmap. I
> was too lazy to do that, but it is probably what should have been done.
> 
> By comparison, felix_vsc9959.c was coded up to work with an internal
> MDIO bus whose ops are implemented by another driver (enetc_mdio). Maybe
> you could take that as an example and have mdio-mscc-miim.c drive both
> seville and ocelot.

I didn't know about that code. I'll definitely look into it.
