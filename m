Return-Path: <netdev+bounces-3386-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E54AA706CEA
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 17:35:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D630B1C20968
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 15:35:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B59CB10948;
	Wed, 17 May 2023 15:35:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D2FE2F5B
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 15:35:30 +0000 (UTC)
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2115.outbound.protection.outlook.com [40.107.93.115])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB1B6A5DE;
	Wed, 17 May 2023 08:35:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bD3T165b85NeITIVT8eBlcBh6lu+BT9CSexggqv8IlungErks3H3pd7akZwpKJwtEG0CxBRg6vzPyZG9+2wOmnOObevO20yHZGIoi2C6QanJMolb4EEvIRrWeKwR1gebDTVbUwzVsgPQfyYrvQPHPVQcVtA07DkoozWilEWcNI7iAIy6WgQZhDmOkZgZz0JarsFCBt6S+wp3Z5f3GoCcy06nP4vHBSSn1BLg/jf3mQUMzXYAdLNni58H8DXG2OJCbxB8M8LV04Ms3gzBDDsGliSVdRE9yJBMZFL2TDFonsZSy7lwX2noPG8ZVAv6zFB7xWjevk6MzjZEg61WG9jRsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HZVNi/DiWxn99F4pi7d3yPC9aH+eFthHqWxC1nEdP60=;
 b=RZMpBilHR+EKAgm0ShQ/Y3OzmcwaAVAAFPsdSHCzkSSljTyPaTIe/LZACFZJ18Ld5XE7ZIzH9HvfV1akj/+HbO98/j9PyT//kXC9YJicL1sLy7KePK9+P8Wz2aeMPz5BqckXibtdEZhq1r6wR8bLRx7GQBS/Iaw73sHwbD8dlYBEGdoA5EfA+mduyiU30+W6mnsNd1mPIe/9fZJTixhoXLRSpZF7iZOIZqc/SpvlRx0YVkqEilGduMNw19VTqXno4H4y/QCFQ1QUAPm2Rq+gyjCtdrJY7djrBNoaHMm/9e0/0SPn9RSvB1zKpDKDqmyEwCotC+HwUQeTz3UDWI2LbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HZVNi/DiWxn99F4pi7d3yPC9aH+eFthHqWxC1nEdP60=;
 b=j1GxbATeKnsqIkdztDTKrqxzBTnxNa+9YMb4uLnRLdj8+hKKma7ZvGzcHPvUCaVoNMlvxcpQSQTjOP+xTLt8lyUF4yhgrbxINM8iA5KMcS+jipU3yxsCj45t02/BG0r0wglRYHSQIvO1e8DdNGtOvaihUR5UENHvn/r4+qNQw6E=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM6PR13MB3954.namprd13.prod.outlook.com (2603:10b6:5:2a3::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.33; Wed, 17 May
 2023 15:34:40 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6387.033; Wed, 17 May 2023
 15:34:40 +0000
Date: Wed, 17 May 2023 17:34:32 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Florian Fainelli <florian.fainelli@broadcom.com>
Cc: netdev@vger.kernel.org, Doug Berger <opendmb@gmail.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Russell King <linux@armlinux.org.uk>,
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 0/3] WAKE_FILTER for Broadcom PHY
Message-ID: <ZGT0CDSEI3MO5SKa@corigine.com>
References: <20230516231713.2882879-1-florian.fainelli@broadcom.com>
 <ZGSdMM32YnloAlIf@corigine.com>
 <daff5610-0ad2-9e08-b9cb-dcbc6d7938f6@broadcom.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <daff5610-0ad2-9e08-b9cb-dcbc6d7938f6@broadcom.com>
X-ClientProxiedBy: AM0PR06CA0130.eurprd06.prod.outlook.com
 (2603:10a6:208:ab::35) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DM6PR13MB3954:EE_
X-MS-Office365-Filtering-Correlation-Id: fecf84bb-cc55-4ab2-b704-08db56ec3aa9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	aKSStlO03Hq2Ga3dxC/iSRNtQ9gDB992E6MqVI3aw4UvI9GZ1mdM0ntDzroSvZ9p6BLWW7showdb4KRBFxeldI8vWX5ND/qOYx9RcFuFbF/vraM1A2UsDUj9YYfGe4KAXheRhgqF9zxJRX7ULGZsz9/Aj49ZDPuWLOEIaM6p/1/3xFHu0mZQTc9eTSBZeoojuX+G7AKrQ9nmQC9tt6MKOKRFyAoIpPr+KVA1rNV5pYHZ3HyePB1Z4drmTA6LWIxf+VrQxndmLQB3Wb9HJ3YU9n8fikB9gbj1Pj1ZiBXtenkH10q3qYCsD4k1fwV00CUibMtI4LdNlYVu3bf9P98j4QvMMkXZRbc5kXVU9EcfgN61WnavOymmvk59JbXUcloUZHYzqube53Jmhiab3jp2933QvMNUah1kCPxe63N9/cwDAbARYMa9yQXbf7Zmlz7E4vkj049MJbaSSGFt/A4V13jQPAnAtUom6okfbgQQ6LgLTCAgXLoHAr95abkQpfkBQ6A0D1Nb5T3Kn1o6LWgs9q0SkouUc/jyEHwyIMNT+MchPnEfvza5GMxkw3PdgJpt
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(366004)(346002)(376002)(396003)(39830400003)(451199021)(41300700001)(54906003)(86362001)(38100700002)(316002)(5660300002)(44832011)(7416002)(2906002)(478600001)(8936002)(4326008)(66556008)(66946007)(6916009)(8676002)(66476007)(6486002)(6666004)(36756003)(6512007)(6506007)(53546011)(186003)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ZQdjuv3Q1l3oPcTdu9a8CocgwGSbKBMzkrNhkoulj13ncgtEOaDbgW0Mafos?=
 =?us-ascii?Q?Ef8V8IqAv1g2YBCgcx8hsWBbzLJ6sv2/uPUgWE73r5bbD1AvVJNKpq3QBQHv?=
 =?us-ascii?Q?uOBKirqjD6IeRM6odbaLjMJZzJDFwBCRZQOElrNi+Al8ZhnMiAnyyyz6cZWo?=
 =?us-ascii?Q?N8V20xAmqeVrwOF3Ph0Gq7pZrgvpSPtb+Yp2laUVmDLCvHHcdesIRFVk2C5O?=
 =?us-ascii?Q?JXLWjy/WKbX8zinItVqYeYMr8iZHpeG8Oknv4xC0/8s4tmLc9GZ7lyJXhd1b?=
 =?us-ascii?Q?5lSYiJPp3li2LSfXRuYB0j2kU+lmZqy+rbigrQfBmQQyuMkB9VpJTXGjBDiU?=
 =?us-ascii?Q?OMG9jdz/lkXHf3a4xGwfP9Pgazxghfk/9TiWb05isI12Kalm58QRFUyBeJXn?=
 =?us-ascii?Q?R0F6dqL31C03ZA2B+BRvM4FaydMFMaROkO2Eby7AXiF7nIcetgDckY8DzLMm?=
 =?us-ascii?Q?sq5q97IT3O6qf12Lqnpz2jp2uWkBUS8b+kU16AELMMTc3aKDVnM55E4liVgD?=
 =?us-ascii?Q?J2GjB+bZpwGCx4skJk6Xm2vRikz/LI67tXcPlJBUWYl6HIoSv5B93Hc/83Xy?=
 =?us-ascii?Q?PGjh5kzGkrpAV+whjh3Bzd7N3o0NHQTH1XI//S2TaafpPHmEI28o4uOw7DO7?=
 =?us-ascii?Q?t5fY2e1OKDg4TmDVw2LNbTroN0KugeCi1bkUPG6lQzln5lU7zsxO6Jcizcbn?=
 =?us-ascii?Q?6NEqZnMap4xTzvRDC8FkHnMvm0bMAmwcSRSEpCMqve8tP7kGNta15oyKGtcH?=
 =?us-ascii?Q?ixx4aVS2yg74+8CIXyvHhftAVg2DOUUUsAENAY++g7D/vZuaT84Y8QYay/Wi?=
 =?us-ascii?Q?JROU8Vi35u4CShwUHZymMkwq4C5pBkzufBLrMEIOXPFErWRfUE5RPNdRi/+b?=
 =?us-ascii?Q?rc7nxDO8qdDzb7+oUPwre4x4ODlpN6QX/HxJ2yb/BZ+OGlcYWfECtIJUu11T?=
 =?us-ascii?Q?eq5PP7jhxHUKQi27DXKeImAysbOXBHtUzWjvE2jCrcskS/vsKF1fpwV/iYlb?=
 =?us-ascii?Q?mV2yxoNWOpm93E8sqcblIXvW1s75NcbTkvSTA1i81QpgdbcUBjWbRkjnK3DB?=
 =?us-ascii?Q?xMxbbAiwLRPlOnKKa86GpK7eH2POCgVrfrqu4ZZ1c/bahup4JaHUHTprKtcS?=
 =?us-ascii?Q?eJ/2d+QC8/9iOl7a3mISaYt87mTy9jd/spxegtoH0H8Bns/VYhcQpjiIZYHh?=
 =?us-ascii?Q?cThakEmdMHNmG/4WA+/flkKCUsOktyaS75yQvOndtdH/bIYa0zo84299eX4s?=
 =?us-ascii?Q?OZBy4jcBwlj3dQg5+rWeRwUo3Wy1V5QNfsHWSHJFoglLsXU61fCr5vHz8u3G?=
 =?us-ascii?Q?20sudIT+1ye8PHXc1euMYBeJ832NI+FcCcZJ6DkOmU7mMgMwzKgpihfI3rea?=
 =?us-ascii?Q?RMI4YiPh+Msuob2py/OiBvXXIiNdEzUfsFAcKWpT/hhNLxm2x5TEmpxrZex5?=
 =?us-ascii?Q?uxVR8bpphijAhaxuCXeAcaJCbI0/aQm40/GV6wAm9h+swjvpt8+b/Btxzy+o?=
 =?us-ascii?Q?/QZQd3blk47sC23Jxa+O4eBeUoAutqUeAsVoUQteHD8WipNENRh2qoQ3aDqO?=
 =?us-ascii?Q?dySjamAOBPZOlQswPI/coQ9miFJh2R4LPqnxY6lqFCY23iUIU3EZtC54aed+?=
 =?us-ascii?Q?aCCYo9cn+cUS9gRBuzHvqlUR8IKj4SKOohEHAOCakPgqQVC3GiUxdCr9WHvF?=
 =?us-ascii?Q?pWC2cQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fecf84bb-cc55-4ab2-b704-08db56ec3aa9
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2023 15:34:40.0940
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4Zay7Qz3/+sDD2jnL8zUMDd3GxdDwrvWLcNDH3eCokR9FbgiIKrbi4Y4PMFxtVKLdXkAu2OmDLFep6heqlaX5kMp32zw1QzeUlR3/P9eV+s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR13MB3954
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 17, 2023 at 08:18:25AM -0700, Florian Fainelli wrote:
> 
> 
> On 5/17/2023 2:24 AM, Simon Horman wrote:
> > On Tue, May 16, 2023 at 04:17:10PM -0700, Florian Fainelli wrote:
> > > This patch series adds support for WAKE_FILTER to the Broadcom PHY with
> > > the narrow use case of being able to program a custom Ethernet MAC DA to
> > > be waking up from.
> > > 
> > > This is currently useful for Set-top-box applications where we might
> > > want to wake-up from select multicast MAC DA pertaining to mDNS for
> > > instance (Wake-on-Cast typically).
> > > 
> > > The approach taken here is the same as what has been pioneered and
> > > proposed before for the GENET and SYSTEMPORT drivers.
> > > 
> > > Thanks!
> > 
> > Hi Florian,
> > 
> > I hate to be a pain.
> > But this series doesn't apply on net-next.
> 
> Right, that's because it depends upon "[PATCH net-next] net: phy: broadcom:
> Register dummy IRQ handler". I did not make that clear in the cover letter
> but definitively should have.

Thanks Florian, got it.

Of course review can occur within that context.
But perhaps it is best to repost once those patches are in,
so the CI can run.


