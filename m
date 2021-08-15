Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 818B93ECA9C
	for <lists+netdev@lfdr.de>; Sun, 15 Aug 2021 21:10:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230451AbhHOTLJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Aug 2021 15:11:09 -0400
Received: from mail-co1nam11on2139.outbound.protection.outlook.com ([40.107.220.139]:20449
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229743AbhHOTLH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 15 Aug 2021 15:11:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lQsj0RzutT8fk5jvRtmAdtgs59NCaqt9tle4Mxc4mHRpPOdwVuQZYA2Y8TnQl5j7N1foNuMNYge5fbn2PYl8LHwjdbzXXyXWqDsCMcw+wXgAmIHI4BMi5bNKKN05qMHbE/bSDddCHI6kjHYDl6qqkPhqhv7RJyPr9XkNpcie21D+E1y26K3T3U1jcCBgtvesXRVuy6QvjFDGnGxRC/RTDNJvp630bd6FMHIU9n6PmLwI5gHgXAPXDQJSZIjH7hISowvSW3mLYb9X2LKzY3uBi3gcHS+m+augpBtmJz4UfrM6kWaymWphM2LO4eKtuo2RrVmMPSaV7HSP6fcp0K9CxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EWh6nCUAGjWVtBiQcC78Y+X45XymRqD8YhZd7XEJIEo=;
 b=IDaXCxT2TQnJ20ZqRx7HVCFLHqLCASrX0UthPrR+G1z6U4e6sI5siynGGCJ1XSLuAzJR/GL5h3ScPYYWWx0GCdZCPIQoWKV4ZTsPjGRpqznb2rvU5fcIU56UOoqWjdzM/OSqlRtBqkTNdTuppkEeBJF4aCK5eT84cY8bhkPnS20TAU8juwNkfFBohlYh5pdfIYEY4gay5YrwB904DETdEG5D7o+KUb8ckZLI/53gReeMN6VKhvW1zvN7dbiv/lJ+aAlnXxFk8tFbVNfay++imn3yBfJ9ibSkJ/0dwdeGyUp4vl4GINVZMqi8RXPiwXH4+wcTnc2CuPm57hNzfBxM0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EWh6nCUAGjWVtBiQcC78Y+X45XymRqD8YhZd7XEJIEo=;
 b=wgP8Wt1+LY9+PTnBHHrLd3gfe646qxsRqKz6re9KG84eUh9x3vVIhq9wfkS/OfyeDzl8TeQwJqgF867y8LqunpStZojlYfdpL1Tnb73b6QZ8vcep/DticoftqAmsToeO5QmaEdupEI302Yh3dsWAKJ1bjkEmUw2pRtVPoz4jeTk=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by CO6PR10MB5443.namprd10.prod.outlook.com
 (2603:10b6:303:13e::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.16; Sun, 15 Aug
 2021 19:10:35 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::e81f:cf8e:6ad6:d24d]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::e81f:cf8e:6ad6:d24d%3]) with mapi id 15.20.4415.022; Sun, 15 Aug 2021
 19:10:35 +0000
Date:   Sun, 15 Aug 2021 12:10:29 -0700
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        claudiu.manoil@nxp.com, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v3 net-next 09/10] net: dsa: ocelot: felix: add
 support for VSC75XX control over SPI
Message-ID: <20210815191029.GA3328995@euler>
References: <20210814025003.2449143-1-colin.foster@in-advantage.com>
 <20210814025003.2449143-10-colin.foster@in-advantage.com>
 <20210814114329.mycpcfwoqpqxzsyl@skbuf>
 <20210814120211.v2qjqgi6l3slnkq2@skbuf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210814120211.v2qjqgi6l3slnkq2@skbuf>
X-ClientProxiedBy: MWHPR1701CA0024.namprd17.prod.outlook.com
 (2603:10b6:301:14::34) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from euler (67.185.175.147) by MWHPR1701CA0024.namprd17.prod.outlook.com (2603:10b6:301:14::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.14 via Frontend Transport; Sun, 15 Aug 2021 19:10:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 914ee486-74ac-4807-9ae2-08d960205be0
X-MS-TrafficTypeDiagnostic: CO6PR10MB5443:
X-Microsoft-Antispam-PRVS: <CO6PR10MB5443993CA6EF7E96C99A385CA4FC9@CO6PR10MB5443.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xI3hLBNO+F4k8JxTjegeEDtIxY4aPM/Pg2mNnzwArnYBfmm+JWKhbJ49n0UldcRrq3mMwGzljaGpgjGNGu28Fozlyk7WeitzwYvGNHI2udXcLubPLZ2bJddlM6EVSwmMyi6CddPoC0kZgwHiZnwzjsQSU+KQ8s4HB52644JUYbxjlk7LFitU8XJ/D//cv5tjT4RMZWU+rGxSfP54oZKsG2R+genqehAkHlb5qUXcUBNRCDOsW6jMOlhXT3CVuLSO2sbVRN1azj/jvzE8s1x58gRZixPEZKEVkUFYc/R5kUGCUr3F6aY4Ir4ASSxvq/vA5CIhJrs5UaZXqBMe4kFUeXt/QboCVKWFoRg17oK4zPuZQSPFxTlZmKcqD8VWdsWwn20tbTXAIkZHW3GPLt2GyT3q2zy29zQcOFPTW84m0+e60yX7olgEa0GK0RQA2MwKm1CiBWxm0/YlY2AERmzFlbEDXy27yerArBFUeORr9Ap8hCjylCZHDcwuV8TUWoXdrwjXptKc+y6PCbe2wIkRVoj+X06V7ExkW6ykMs3Hj+8KdhiCSXKbAjRFGzHqH5QJuNSXX/qrOdsF+3lEJ4QeKwQVsrPznb3bn3ZQm+Abg18kW9jIcOTBNGCxEF7hn9p84G1lWoW73W0CwzZHuaP2AQRmbzvAIZJkJdXAY476XLEpNg5SyC0PHUeJbHkSA9acg7XEFt7HD/zDlaLO+1ZE6JkMWqOlxHSFgB6T3ubmTFqECSgTfXECnyz3QsYEjABVj5XL+rT8oi7e5ElW+xEfAg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(396003)(136003)(39830400003)(346002)(86362001)(9686003)(9576002)(38350700002)(4326008)(66476007)(66556008)(66946007)(316002)(508600001)(44832011)(33716001)(2906002)(5660300002)(956004)(26005)(33656002)(6666004)(186003)(52116002)(6916009)(7416002)(83380400001)(8936002)(38100700002)(6496006)(1076003)(8676002)(55016002)(966005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QdRZkugfpVFZWOazOltSrHBxCo1h21RUWJE/k48fhyCn4ZwE9UCwKyny8/Lw?=
 =?us-ascii?Q?aaynmyCSraX/SLOkMJaZzOrcjiHVHSpcWUFnodq2G+WRcG1Z02U7AF51maWt?=
 =?us-ascii?Q?LoLFjExIWdrPsR8z+4DMu07AOfpvn43yG4AIXHtW+fAyK97VQvaZB76deXqd?=
 =?us-ascii?Q?TbzdtqYoClzTX2iP3mcnT/GogwkfcMnhiw5zATY/JtKEVnOld4HPi6LTAlTF?=
 =?us-ascii?Q?cY2jQYNoSnELXGGBI8XD1+nynLWuhhlBq6h1TSOW+1b1/YGAuCk2AeNXom9l?=
 =?us-ascii?Q?Lja1ym1NlO/McynHB/PWMiZxcAmnTq/Riv48sCIJwC31O+TpH97jOQwsGPat?=
 =?us-ascii?Q?X/l0uWu82mT8oIwrjtyaqUiFYPcRu+YGeTCZx/lQhhBXcEU0tbFswr/earkK?=
 =?us-ascii?Q?hSNO47Lthsb+QWNV1e3iFdurF3+UawxqsUSOLpguMJRqAhCEM3Hz7FDEkTmK?=
 =?us-ascii?Q?OHTVBEok6Pj1zllqpypAdJ9/SBJzxupxQMTlvtNc8XuM14b68SNPiqmXQBBO?=
 =?us-ascii?Q?YoJa/xAPfysPdkbsxqvtTzyyJMd2YWc6mNAKg8/arOAZO2Aqz7tOFq31b++g?=
 =?us-ascii?Q?XNIwcRHJ3i1QgnyuVr4iGavp6RWK36FvOTRR4LdN1Y3CVEzL24XbdJ9yEOYA?=
 =?us-ascii?Q?E6kH7d7nEK3HvgY8NkC38/BmP7Tf4PiNWYtitO5A/Ksfas7eq9R0NDZbqBqv?=
 =?us-ascii?Q?0LjRQbA8oUJPnAWBfbas5pcrxpxw5srbtvkR8F8lRV8afpYhf6Y87jp1/0By?=
 =?us-ascii?Q?jdmCDcgnBQlzUXILs/SGipiWLWfKtHYzPucg+b2Hu5epDddsoNszSljEZlBK?=
 =?us-ascii?Q?87vNsnCmtyg9PW3YQk6hplSZN//KruziwvF6qIWPD+ws45ZDzG6UDh7WWw1Q?=
 =?us-ascii?Q?g5Xtw4EschIWq+6FD2JQVQzy4GtItn5YvcndzW9LuqUfLnFS9OLfSAejLz8f?=
 =?us-ascii?Q?SGPOoEnOCEG6SZc33IycU23PJGGd6DJ5cf537Qb8E0MFseUYTC+7fK47THDt?=
 =?us-ascii?Q?LSkexQaheWBA8faidKRcrkeSnAVKYWyWGxNOJ0gKpEVVCjc9djBYpnOyp7Ph?=
 =?us-ascii?Q?TlfH/zAd7WUtseZs8t8pcNMBr/+3xa3bKK5NLZCnkjrc/fnhdolt8+8ap/S/?=
 =?us-ascii?Q?DPzbofqGqy4ej2KRODPRd/qrXhrfqMPuckGfSPZ8A8Iydg7HuJRVjGMBms+a?=
 =?us-ascii?Q?/QYQxCuNfzGOXOwW5T6gfs+IxYK23y07U13TBeJq0ZdJyktCl4aT5PvHh9aD?=
 =?us-ascii?Q?Y7GzHm70IpamYJD2vSGpCBgpBaCXR/4VfBisk0Aju21/g8VN5MsRjT9IuACO?=
 =?us-ascii?Q?mGX2Kppi73BiXov13OdIRzqH?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 914ee486-74ac-4807-9ae2-08d960205be0
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2021 19:10:34.9070
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PL+3z/xlYyc4B0eTU9ZC9uTdf1gzAmHZZ9df0HILnuT1pmFu5V9m9Xj+uyYBShfDfCeWL0CHrOnjnT6Yk8DgtnL0zrj7AymJWIGG1PxXtNM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5443
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 14, 2021 at 03:02:11PM +0300, Vladimir Oltean wrote:
> On Sat, Aug 14, 2021 at 02:43:29PM +0300, Vladimir Oltean wrote:
> > The issue is that the registers for the PCS1G block look nothing like
> > the MDIO clause 22 layout, so anything that tries to map the struct
> > ocelot_pcs over a struct mdio_device is going to look like a horrible
> > shoehorn.
> > 
> > For that we might need Russell's assistance.
> > 
> > The documentation is at:
> > http://ww1.microchip.com/downloads/en/DeviceDoc/VMDS-10489.pdf
> > search for "Information about the registers for this product is available in the attached file."
> > and then open the PDF embedded within the PDF.
> 
> In fact I do notice now that as long as you don't use any of the
> optional phylink_mii_c22_pcs_* helpers in your PCS driver, then
> struct phylink_pcs has pretty much zero dependency on struct mdio_device,
> which means that I'm wrong and it should be completely within reach to
> write a dedicated PCS driver for this hardware.
> 
> As to how to make the common felix.c work with different implementations
> of struct phylink_pcs, one thing that certainly has to change is that
> struct felix should hold a struct phylink_pcs **pcs and not a
> struct lynx_pcs **pcs.
> 
> Does this mean that we should refactor lynx_pcs_create() to return a
> struct phylink_pcs * instead of struct lynx_pcs *, and lynx_pcs_destroy()
> to receive the struct phylink_pcs *, use container_of() and free the
> larger struct lynx_pcs *? Yes, probably.
> 
> If you feel uncomfortable with this, I can try to refactor lynx_pcs to
> make it easier to accomodate a different PCS driver in felix.

I think this is pretty straightforward. That seems like the same thing
I'd done to get regmap working in this patch since my first attempt.

Should this be a new commit in this patchset or a standalone patch?
