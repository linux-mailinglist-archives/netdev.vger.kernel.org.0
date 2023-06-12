Return-Path: <netdev+bounces-10209-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D5DF572CE93
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 20:38:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1F2B11C20BE1
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 18:38:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6FA83D7C;
	Mon, 12 Jun 2023 18:38:05 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C99072F26
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 18:38:05 +0000 (UTC)
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6A6598
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 11:38:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BbvMsCUOxfs7NH5XhKVdbBYnadLVX+BrpkVrDh9F7agZvyEhrmgsyLPc0NdgFe4YqEzXGJjSMWkzBONuSfwcqK+y0LakllJXo40BkEaLQLs1Kjn11VaPa0GQjKyMz4hoaOgEdh1hqe4yoiOqRMIGkpmScMoOFWxejg/q29aD43E+Ja1tuINXjoVI5IBRR55bEcTV1LO+Dv0OjovR0GAt9p+bCKZV0z+jsphQdKQmtSKEkS2wtU90Piez/UKq3Q6f7ns+yMZqhPCXAhRpDkvdy+DDsMiWhbmxj4G2WCctPNpoJY8sDWbhHKQARkPDTC1FQl/dvVXE7FU3SbW06g5RmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aunQVuHgvOxR004RxsVjwjqPwsukuy298HxDaE0bIVE=;
 b=Ve6krWE+4Oso7bDKhou/xpWkPRdG9nmuqWGEWGtw75snnaZpEdkZfI2XJ4zIdOURvWL+r+HP4OM6wKHlLL7Nh5ICiLSH2/YP1XFKj0KGsCrmMp/MtO2D314w5afxfxRQTa/nxzpbisJq+rXM4k/5kDKXmyWkgCQQnWiBF7fgrkTvvTVmd3D8Dt0H5X/XexEBUDFFjcEtsZF9ZKh3+CgptETvlKKaxiztPAAg6COqb8vF7MRIAsdbpUIliEaCuF1RGqtIzy9LmbKLdSUyQc9pqLzW4X7ZiF4bR8GJejzxe3f7y+RxI3agqTChHUKYIuR8VfwfZlmjoveAlF+mQ5EsZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aunQVuHgvOxR004RxsVjwjqPwsukuy298HxDaE0bIVE=;
 b=cmThBGKUbwVob/MNXcUMnMVgI1WmlsJbImEaNoWWi6EBmObslB7Nh06gvGDbCdPBotgGxx5s0xTbft7uP6amDBtSTfXuwE8jfLH+fN2rbgENsmTy8PEVeKT/hiP0nsbf8HY1HxYG8XJYDVu7zISrq3+dIkdNU0hq9/cwEUI+osH1eE6mXN2QJMO3aXUitAnS7mzqc7yNWF02mSEY5dAN2mAjtWim2MEQdmTz7ENYlh5xWHXfGa1IQh8N6PD7ip7f2tELlm3OQKZ3JaYB/WBpplnKDIXA7pYb3cSKGfU9q/VoQOG+56sArDvowcLH0m1xt2BYvh8jsdSMwekLDohJdw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by DM6PR12MB4385.namprd12.prod.outlook.com (2603:10b6:5:2a6::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.29; Mon, 12 Jun
 2023 18:38:01 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::66d8:40d2:14ed:7697]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::66d8:40d2:14ed:7697%5]) with mapi id 15.20.6455.030; Mon, 12 Jun 2023
 18:38:01 +0000
Date: Mon, 12 Jun 2023 21:37:53 +0300
From: Ido Schimmel <idosch@nvidia.com>
To: Jakub Kicinski <kuba@kernel.org>
Cc: mkubecek@suse.cz, danieller@nvidia.com, netdev@vger.kernel.org,
	vladyslavt@nvidia.com, linux@armlinux.org.uk, andrew@lunn.ch
Subject: Re: [PATCH ethtool-next] sff-8636: report LOL / LOS / Tx Fault
Message-ID: <ZIdmATgQXitdg8oX@shredder>
References: <20230609004400.1276734-1-kuba@kernel.org>
 <ZIV6L+pIUvZ1tip4@shredder>
 <20230612084837.6c5b5ca9@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230612084837.6c5b5ca9@kernel.org>
X-ClientProxiedBy: VI1PR09CA0084.eurprd09.prod.outlook.com
 (2603:10a6:802:29::28) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|DM6PR12MB4385:EE_
X-MS-Office365-Filtering-Correlation-Id: cec11ef6-086d-44c0-50a5-08db6b74265b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	JLEwKsSNSsVcCw+hqSdLZ7Lb5mnIX/iGEosuETW9f4HdQDn7cAVgMMuxZ8N0hAKPVqezbyRn4K2/UIJn7RgkWrRLLqxI8r6kwAQFczrI9WELme/uL9qSAiuWH8qjNigoVYEyR34Pej9sUDaQV2+b8i8yd3eJT5OSeGGSc3QO5RPouUofsJ6Z2gHX3kIWPHUefFpiy3TBBMLx38mICF1VvwPYGQH7I2crzhuZrXN7y2Fb6CXUbct3dDbyC2drrNm2btFRWX+hMHbgbR1Zu3XRPWx3Uw7/2DJCRgHSqa6kKUoqOucibA9V6zLgaDFnhMJImJwJ3hBhrhSmwT7u2iP75wnqY3sgHTnSB34i3IXSwLFgAkceV7SN5RLGuHN01kXhgcPG5f6iOA1nh9Fr+fMxGeV+ESMhn1XkwhMwcxi8/5FlueeQYjU4aTnWQiiGX1kMpvKCLwkLSzfBmvyIN4kl44WOrhTY4vZ8KSNaMCp2i3Ro1tjTT/RwcAasCZTPnAxvbaVEGnaCJBKddcy8tSU4qcy9yT0jUOwv171Tp3XuPx162jfY3ZqSgz0wIA9fKJdD
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(4636009)(366004)(136003)(396003)(39860400002)(346002)(376002)(451199021)(6486002)(6666004)(9686003)(38100700002)(86362001)(558084003)(33716001)(6506007)(6512007)(26005)(186003)(2906002)(5660300002)(8936002)(8676002)(316002)(41300700001)(6916009)(4326008)(66946007)(66556008)(66476007)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?jnlYnQ9DZkksF/P/gvoYsY2rr2oUixEbBmpA6gVkSRxcfZlrK8kQ5awiIKXv?=
 =?us-ascii?Q?O8ZZveuGMRQmgMhpIsZ9gHTduOI6Ml5bawVqFavI0ElOmHfjseodhP5MrzRl?=
 =?us-ascii?Q?b4XbvmRhJkWOp7Q++1WUq4G65Rt6KOligG6gEo5MfmQWmR5LqKc8c8rRIB9w?=
 =?us-ascii?Q?TcgaHuFcL47/eROIA8NR/c2D1lreYcLvinLt+MFAmk08pXtEJ7G5Pm5A/jK7?=
 =?us-ascii?Q?eBmqERAEEAjwpRYJQCCfxi8V1Vi6m7MycciFye1nvJcqe7cLc8D+z0nmHXam?=
 =?us-ascii?Q?6mJ0IX1PLzk5isehUvh0q5JICSwCQfbIhV/9iUg3k8uk3DxAAiJPCbbUcl5C?=
 =?us-ascii?Q?QWjJXk7GM1CNao69vv2hwzVuFcDXVXQzCqptoFowARZxGbTp7IFJUA3Ey4vb?=
 =?us-ascii?Q?QGioOo72In/TZiAZB2wddj6X8Q826Qddmwd1hhF2bO4PClriAN7r10FP+iBH?=
 =?us-ascii?Q?7zqrP26bJ7hhoX4nE0FVW+t4F5sLcX33KSUkYrTILwOKEBZxsAUUoeaUINF3?=
 =?us-ascii?Q?dbEyfP3zxEfhD6lJuA0ODPhCgem70FhIPBYNQV9iO2d9OsL5OmIiOOFRHUgc?=
 =?us-ascii?Q?2aQHLgIOIPlwPP48vXrwZ0vb1gaIKohTc1iD+OP91uiAF4OSe0ioNWrYgmXi?=
 =?us-ascii?Q?MjYzBoVgSJsB2gk4SYtchhOBasQRUlRjNGvWLdC+8bzogPFvK/zCEBmFljqZ?=
 =?us-ascii?Q?yCJDzVnQLxsnHEAX3mMUsExgiwMPYhZH1cJ35HD9nrr/wiqvWQvvTYQ47Hv0?=
 =?us-ascii?Q?r+OzVbM6TYVL85Ok9mZ6fycciQ2tAMoIww3mi4MADQxA3nwkPheTGyTdJjJe?=
 =?us-ascii?Q?1kixCuIFE8dCAj24a6DTjYgGDFIu2C0UeAGWSe/bocAmSA/JpvD571pq2ZnV?=
 =?us-ascii?Q?Ds5D1pwJEGafVWZhfe+/UKO3CgGk0n/6pDPmXjysMVrsR1Z679v4HIKu6jZR?=
 =?us-ascii?Q?3WZWRm6bgauolcSsFrjltfPusTHoCtZGVxWGUXn1Nb9ufSvaJ63W8Vl4eeCg?=
 =?us-ascii?Q?82nT/RiGJ9UCtxN2RkI7mtPP1/MbM+P8+lK26ELL6Xqut3r/b+zcgYtfLrOZ?=
 =?us-ascii?Q?ylaGn/7hJfF2eovsuYysMuFMJKJaMtZTA65En1qzI0RRp8FJ3kQQGbTborSR?=
 =?us-ascii?Q?z213KF2epOCL3vqxXs2xqMouo5wxgo3k9PTHJKSt64xsT8TdXtcKKNh0WDN4?=
 =?us-ascii?Q?0OfZNX07Ni1bIttIDXuj4F6itf/lZsT1AMb4eQFBiLokNFJ4ZbASpkCyaSzo?=
 =?us-ascii?Q?LIXvA3HZ8cISun799yaO7zx4WGEu9IrjovO1N+HnJNUcvDYtFomr3C/+qyqO?=
 =?us-ascii?Q?Q+yyJ5O9rnZjnglUWht1QNOkY3uQuYnQPTxxowI/04bZ0sH683IussOtFubH?=
 =?us-ascii?Q?0q1A+kLudVjebC4MKudU/nxxm1ZTS+mv9FqrfK0kAm7UHNDzC5MwMv6UIWwX?=
 =?us-ascii?Q?QmDjGdNbe8e2uO5weDb/TYwG9Bku+XuEhKqJDxs78mxPrgysVeyaODTPhrTP?=
 =?us-ascii?Q?k2T0TQIFBbHcZXEfVKdH3NjCUa1Yx7M143HQvVFaPC01qewWvNHHQI3nFyvT?=
 =?us-ascii?Q?nbwg1zzfqMhYUUVM2GzpiwJRcJjV9ZN5/uuOqnK5?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cec11ef6-086d-44c0-50a5-08db6b74265b
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2023 18:38:00.9402
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: os6qkYE1fqucLhuZlHY7Y8kXXGqyfUwKcfsA9gljIfa6i0sGbmxwvcehn+k1U51QOj9lFiRwh0NI2CUTByoyWw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4385
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 12, 2023 at 08:48:37AM -0700, Jakub Kicinski wrote:
> IOW works as expected, am I interpreting this correctly?

Yes, LGTM. I should be able to test CMIS patches as well. I have both PC
and AOC QSFP-DDs.

