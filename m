Return-Path: <netdev+bounces-476-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C283A6F7942
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 00:42:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 69EA3280F94
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 22:42:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F83FC123;
	Thu,  4 May 2023 22:42:00 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF490156C1
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 22:41:59 +0000 (UTC)
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2051.outbound.protection.outlook.com [40.107.95.51])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A0A82122;
	Thu,  4 May 2023 15:41:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iUBRVlwy02AXbtzEGTEaWaKXJb5/e/Rt11oORWn8zC+03doH+awubZHOd4WGAQXVpIwdKHdpF5y8ToWCRNnDyf4WI9r8Te56A5EbDIRZzk1+gRrktrVh6Q6k6uTWROF0BsJ2U7PgkzjZpKcDSPcw8gmpncAs2gWVqvBmJoscfIuY//VC5gjOMYO9ZrfVcYHnbLVlboq+hvGaTNAE7JG0sGJf8rxkwFW174B4Nk+QFv1tsKOcFdwQHdMwyii+9kcE8IAMzqrDT5br1SSrfNBqd1nzvjh0KZf/Nq82tqVtztgIh2TbH5Gre60W4j6Ei4mZNG9w6lF+MudYymkke2QC6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kVepyrpiRFTyzAnuz9rT+Cba+6QBGPRokq8gET8kYlA=;
 b=GKr93xzeS53tBEz5Ddfyh+/5OA/IVd1yKdUl6imatH9XFlENs64rLDvD7HTJOtSAgVWvfxkuIU+Bu1ejICMqGAgjjr15m6rPwXMulC2l2oqG5e/zpoEqui0u1EUarChR3xaeQA82uH/mk8T9Uw0slxiLzZnu7jKWExcMtrVscHKl1v9ZhBXbhruQY7NcbBjKDSTOBvQl9f8uRam2jv2hD3bnrkx09qRPSm11cAR5PYe7Yfn/oOhEDPvtjYLmqYueLZr7EpyUu1W4qlCTFHU/gdSL8rTqiqFuLfbwQu8wJ83kGUta65lZKDb16B0KvItrfC+gKyJqFpQ9z7WyoCj4mQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kVepyrpiRFTyzAnuz9rT+Cba+6QBGPRokq8gET8kYlA=;
 b=TeUShmAeJTu7DZ7ndzx2ASUqMywmRCYAiRm+A8v3aJ68b+vEh7AoKey7kjrP10TeIVOysFneSYsh/dWi/VkVSQTa63umUB1P4UELOOGxtXetSWOlqeQRMVarYWOLtnqAHxZhpC2MWOsGa1kO9yTgudtZxfhDIhFTJ/TOWVa21N5cxep/aYgzE9pTCEF5rGt3Zo6r4BK0ozobGTAWrpzxINU/i0yIR7xb1jDmeMgHQeprzTfPpd14LEstCLdJiFlcFWK2XlCKHHwOWMM3ZHVrhYJp69No5kGOfp75yCCXxrsxqvswDiJLCCU8riJSUscuO8qm8c+hc1JZd5WyebakYw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DM6PR12MB4863.namprd12.prod.outlook.com (2603:10b6:5:1b9::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.26; Thu, 4 May
 2023 22:41:56 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%6]) with mapi id 15.20.6363.022; Thu, 4 May 2023
 22:41:55 +0000
Date: Thu, 4 May 2023 19:41:54 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Brett Creeley <brett.creeley@amd.com>, kvm@vger.kernel.org,
	netdev@vger.kernel.org, alex.williamson@redhat.com,
	yishaih@nvidia.com, shameerali.kolothum.thodi@huawei.com,
	kevin.tian@intel.com, shannon.nelson@amd.com, drivers@pensando.io
Subject: Re: [PATCH v9 vfio 2/7] vfio/pds: Initial support for pds_vfio VFIO
 driver
Message-ID: <ZFQ0sqSmJuzLXLbu@nvidia.com>
References: <20230422010642.60720-1-brett.creeley@amd.com>
 <20230422010642.60720-3-brett.creeley@amd.com>
 <ZFPq0xdDWKYFDcTz@nvidia.com>
 <20230504132001.32b72926@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230504132001.32b72926@kernel.org>
X-ClientProxiedBy: BLAPR05CA0017.namprd05.prod.outlook.com
 (2603:10b6:208:36e::29) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DM6PR12MB4863:EE_
X-MS-Office365-Filtering-Correlation-Id: a936ac82-cd0c-4204-c004-08db4cf0c356
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	R6yA2/JIavd34vzQ7Rg4W8ArfB0QYYuC3CntJ8ohKqFJ3Ku0yFQi6nTdNUYmvy43wivZJPRC9EfUTO5DcMi/xkxLJBDdLtRCYTp+1SGAIA/de04uVpkbQFHwJKmoW1iq10FKmVU1kl5vjSrcG+JoBtwJ/PIhiWYs0knxkYj1+o2t0i3+4GVGXqDtq/lmilFZqOGOgqZUeUh5BgksHhCeqc5wTrf5fZzHGWdKfnAL/9XUqfb6PKm3GDDyvCVy/uwoIK2G6gY+fslN3vQlGTYAcyVjGwv31Z7rTbTfFHtzXxDA1BoxiRcW3nkB/MPl9EGKYE53HEGdrlZP8koZRUU4NBlIClPWNNI4FOLhdzZHGOrnuwP5Lwqm0a/wKrljtuSlkQF6U8PZfzXosWigq3qN7zA7l0XLHs4Nk4he7kd09vDruct/hw+rrb4teZTndW/kYcOh2NTPCfBsinhapFhT5MkesmG6/6xcAbxNSYXkU2BokpZ0URDgJaBTIaD1zmxlZJnNMt/G4TWZ3GV6mm0/QNVZiX8Kg0tiCK5gLJsT/nQpzHVuHD4QFjJAoXubfPvs
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(376002)(366004)(346002)(136003)(396003)(451199021)(86362001)(36756003)(316002)(6916009)(4326008)(66946007)(66556008)(66476007)(6486002)(478600001)(4744005)(5660300002)(8936002)(8676002)(41300700001)(2906002)(38100700002)(186003)(2616005)(6506007)(6512007)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?7VHlmnsJf3uPoR5jKnxWOVuwInmhtC03U9wx27xm6B51nqXxdIZVyh9/sm7I?=
 =?us-ascii?Q?wVLy1eFNgHcbejSVKyzbrpq6RrxUrYk6JvGZjq2rrK9hE//qTKEt0gOdIMqs?=
 =?us-ascii?Q?zbGBemRgRl0Acpsuf5I7gKxsQex/SyklKlt99Rx/ditf3goVu97In+asGExJ?=
 =?us-ascii?Q?t5MqEkPp9H0rvCbJhlqv2VgwU9Ms1QTqV2FgcGhu0AlTLOxIcXI9YCGghNot?=
 =?us-ascii?Q?OOx4WZLJT/tIRPdzx/xZbyLUIP1s+IlsGermi5aqOUvra1LkuAYA+Rww15gc?=
 =?us-ascii?Q?yobqLIH6GjSKxVDg8x7h7VfCUNmAvqwLiPr7bedlJtJMAGuCDaFqcbil6Oq+?=
 =?us-ascii?Q?QlizwpX+r0tQl8+JhEqK4h/tWjZxedzQAh+ykxEzJHdK0Gemv96NZjqZqufj?=
 =?us-ascii?Q?OFO1zq4c7wp+J0spgRballLz66nA/rtC0geTJgxMmeE927PjMw2g9aCg7Hf8?=
 =?us-ascii?Q?b4VYWtji+PoD7DOw+awgpVUsGq4KOEsUqsuHcdVyz33Ppz9ncZ4hRvSeYQ2Z?=
 =?us-ascii?Q?ZVBPACoeoQJ7hoYSl2pEQ3qwGtJLSm0Fv29rGPaqxPFmuSBqSbqjbU1uIsvy?=
 =?us-ascii?Q?pI5PQ1f1lLFl03/PS64pvJu3X5o+amXOpO9La08nXwZSocX4mvLehV6OQSfT?=
 =?us-ascii?Q?8bTM4XNwWn4By51rIVfogYGbYzP3R3ZhNYj4LK3B7lzMdwtTymtnX6gi0JAq?=
 =?us-ascii?Q?qhguX/AOnUUCdRwNzfPrTdgP6/gn01FlF6DnZBM3c8Fw6/ebIrqmbMeV+lqd?=
 =?us-ascii?Q?7HDIDxsozNP8yf2MAf+6tP7BNxYRIWosqwFCL3rRaGJ4PHIVDmeRkZux6iL4?=
 =?us-ascii?Q?hyvoC7SriUJJHu1fH3nIDMI2GT078t94kGmEM66npTkKd+OnsRHz8upMJNLM?=
 =?us-ascii?Q?GzXO3eMXn/w9n6CsVvSHE/UWWPlmbCuTwymmfz2knGuBTq1kxa0PH4euiLt6?=
 =?us-ascii?Q?2dXXjwvtkbKz7nYpKoTTZFKaBJ91l6YQU08KvVDQILVwIFb5iv3O70I4ZUAl?=
 =?us-ascii?Q?YOCnXs3OoXhMi/Xtlq2NeBoGfI6s9YX+9tQbRW1SWuxFcglC12yOH4yU5sHz?=
 =?us-ascii?Q?oyHxfLfuK9bGWWQwEF+fh6Dbe4hngy7fZfBJcQx5Gkey2zgTpmgA8tdDhug8?=
 =?us-ascii?Q?a9uvXcxmp6YjVC+TEz+yoT8EKc3qtaBpj64di9L6BzZH8dO9TbO/mnh8Siax?=
 =?us-ascii?Q?L9t0ug0j1DbUqqBnzwwxpOhlHx0kIbmsSLhLOFHBKO5g2a+idlPoSm6G+afm?=
 =?us-ascii?Q?IOHIBi/+0fdgS0bj83Hoh2fuYksb4H4HLeue070YKWIYR+WPCNE7OFQUE1Ri?=
 =?us-ascii?Q?eghb4d9XuBTxYvX4OWCpzaK5M18BXYYxZMqdp1M/MBwWhIZ+FhdwgIywV+/k?=
 =?us-ascii?Q?M+OryrauhNGUijENU7v96arzkVgRNeVUwI2RPl9twzaY1y8P5U2j/aw5fVzQ?=
 =?us-ascii?Q?QJsUJpmS6ADZbknIO4hg8fTVSx7hRG7Z5sTEi9z8SxqfktpZxkUbWAxFtWUZ?=
 =?us-ascii?Q?412Yqw42FfiL5NhRlNCCwsERwMkJAn8cfJH+6udZykNfU8adP9JlYqGGEUAT?=
 =?us-ascii?Q?HJi1Y6eKE4oaMIqCtfC8EnjyBYdA3RiSJH2fF6tl?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a936ac82-cd0c-4204-c004-08db4cf0c356
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2023 22:41:55.7866
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SsMYn4lEU0JazYGn9bkho9VtkKvYS0tZokLXUT4C2L3WftcvSErDZa9IL/xS6vQr
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4863
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 04, 2023 at 01:20:01PM -0700, Jakub Kicinski wrote:
> On Thu, 4 May 2023 14:26:43 -0300 Jason Gunthorpe wrote:
> > This indenting scheme is not kernel style. I generally suggest people
> > run their code through clang-format and go through and take most of
> > the changes. Most of what it sugges for this series is good
> > 
> > This GNU style of left aligning the function name should not be
> > in the kernel.
> 
> FTR that's not a kernel-wide rule. Please scope your coding style
> suggestions to your subsystem, you may confuse people.

It is what Documentation/process/coding-style.rst expects.

It is good advice for new submitters to follow the common style guide
consistently. The places that want different can ask for their
differences during the first review, we don't need to confuse people
with the reality that everything is an exception to someone somewhere.

Jason

