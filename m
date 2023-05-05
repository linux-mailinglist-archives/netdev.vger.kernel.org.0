Return-Path: <netdev+bounces-579-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 93E0A6F8408
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 15:29:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3B62528101C
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 13:29:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D798BC142;
	Fri,  5 May 2023 13:29:07 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4A41156DA
	for <netdev@vger.kernel.org>; Fri,  5 May 2023 13:29:07 +0000 (UTC)
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2074.outbound.protection.outlook.com [40.107.220.74])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CE831C0DA;
	Fri,  5 May 2023 06:29:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OHGAI4k1O6GwuqQ+tgMDZBmH6G+wOieKD39RS+A8Q6BkncVufNZNZuEdOK8JXbKyJcdUKHxMCH4ml9hErE70YizqCCnoRRcmGifB5a3libd+mlxeTXC+q5V/HQM7mgRi6Xal8aSy+TU7xClbVcV/2xerB5btJOFZTsx/p/rCTifqpdBeo/1B2bWvlQ75vXd4bAd09wGy6Hws9Vf/+j9utxM9w4AVQkzZndUkzppzTvw+umCmnLJCGj/8Ga6xxgLzMEY8Qwm6aepCBgxYDZ7R1tiMLCu3F1ZboeuFbcmi62C3MZ2rkSEr/OXopmzx0+js1NPK/Kq+dAn2Bma9qM7OYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wnG3M32av9R70Qt39G1elqB1ccsFRaF9Lkp0oRUs/ZY=;
 b=JILTdSMQD72exbn7BsqGJGFEDsqLaHP/J5pTu7r/rz6eWAakYgSq4teVTZVKP50lOkqKuthQdYFaeqUCQESE4n5T6QanPYC0vOEhDeaccHCt4CsDXwt328zW5y+jIFPd+CB2Pi3DphL0hB0neAknHRhaCLktS+jjy4xc0D6Im2r3vrjYPohA8KLTllgbJJgr/rvTH4gC5Sx8Gm0FyWL5LExipngiaZqfYVGFPxiuEXedOJm59VDz1oRzbVTfvKveSR2JNIfZrF0x8qqVAfs5PxzYMlegOEj2CdeJWM5t4wSeKDD3fwrlXZo31gg9n15igivo5JaZr0gZ/Z4FRbw/uw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wnG3M32av9R70Qt39G1elqB1ccsFRaF9Lkp0oRUs/ZY=;
 b=GlqHvwz7N22vtxsAHl21lvh/bMkpksUnFqlIvfjdZib3tz/q+4BSuO6Ucod8ZDiIvTEbIUK0EwQizinln3pOSvjg72T6+x0YznAucOQ+k+zr7klyGhSHWFXNXAq28sP1Iearp2+3yJE+IuFj94qeevj0zmDOz5ZWmc/cLy/isjk/TNJdK51ql0fqfM8g15w9ZUovtogKKK+DqWIfW2r16MYBtdi7ZM+UbXkcIEB+2mqrpF8ZV6uCXpyBA+XEBfq3joVpAq7q7csmx6DckE5CbOifqYDD9PO4HL9r6IpjeX2c3vyuFdTJOO5ABV8Cvnm+IxEKVkngJQ9qFT/qu3irsQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by PH7PR12MB8154.namprd12.prod.outlook.com (2603:10b6:510:2b9::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.26; Fri, 5 May
 2023 13:29:03 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%6]) with mapi id 15.20.6363.027; Fri, 5 May 2023
 13:29:03 +0000
Date: Fri, 5 May 2023 10:29:02 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Brett Creeley <brett.creeley@amd.com>, kvm@vger.kernel.org,
	netdev@vger.kernel.org, alex.williamson@redhat.com,
	yishaih@nvidia.com, shameerali.kolothum.thodi@huawei.com,
	kevin.tian@intel.com, shannon.nelson@amd.com, drivers@pensando.io
Subject: Re: [PATCH v9 vfio 2/7] vfio/pds: Initial support for pds_vfio VFIO
 driver
Message-ID: <ZFUEnvDYZVJnPwQa@nvidia.com>
References: <20230422010642.60720-1-brett.creeley@amd.com>
 <20230422010642.60720-3-brett.creeley@amd.com>
 <ZFPq0xdDWKYFDcTz@nvidia.com>
 <20230504132001.32b72926@kernel.org>
 <ZFQ0sqSmJuzLXLbu@nvidia.com>
 <20230504164005.16fb3deb@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230504164005.16fb3deb@kernel.org>
X-ClientProxiedBy: MN2PR15CA0041.namprd15.prod.outlook.com
 (2603:10b6:208:237::10) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|PH7PR12MB8154:EE_
X-MS-Office365-Filtering-Correlation-Id: 8d09b628-158f-4079-9bbf-08db4d6cb194
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	/xoBn3eI7n5hFIoVkbs6BbQYneuCGjYXhkRpMh+CEEYXPWrIKC2yxVb4KwGkz4azdHpPLwKFP/yB8rfRVT+QcwugcJQBRwTpfeRGl+iPnc98C+oYOM5kCFyeGWPYFqLrV23skorPuYWXXDDNPWxToNK5Hgkwgj8IVi2RsLhZzFvYZ2Cx7FDYhLmR4yaUDqrxN4Aaq/Ca2tnD+9kqQMbh5LavVLtSIqp5Nttb8cwayzchWRq8q0HmNbBm8VHXIBJLeKK0wE4PEMqlr1FK7DdOae4rehOJldGZjPdv44IF7IVWS616XyowRiRev3uSTORKzL2BGWV1sIUWDSSOTvcH5V2PkwlpPRxybWdDB5ARbnruex4QytYaQNlfrJbcWW6gcFExokKBjgZvPhmM3Yo5pkQGG7oGgj5gClrbbyB+CtxKF+BsXOBFty2xaZZSasDQFPat/bk9RcheRELXTWRrmwiZ23FJK5YVYiQ657qwhrdelC8B1+haJuDFnRslSUVsWKdABj+FMhpMsLLjixXPqH8g3WwdXtLyFerZPmOFS9AxwnqThyJmvjeQwhxldPoC
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(366004)(136003)(396003)(39860400002)(346002)(451199021)(6512007)(26005)(6506007)(186003)(478600001)(38100700002)(41300700001)(6486002)(36756003)(5660300002)(8936002)(8676002)(2616005)(316002)(66556008)(6916009)(66476007)(66946007)(4326008)(2906002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Gw/drR9UHCI6fiMtez6TTBsJ69tt3uXINesSTP+X1Tucvkx6LaTVjz98upvW?=
 =?us-ascii?Q?LEuTa2NXQg5duM+/G/8zOZWxK5vMez9zhyJswHQlq9DtIjT0kRWWQgvyouVd?=
 =?us-ascii?Q?gy9NqsUNzpvYFKtW0hhXjpsBP63iWZejKJJAkbcwRy1z9gPtdzb+l4/0qR0f?=
 =?us-ascii?Q?6ZEg+vIf6yqzNYGIFihXFnuMx2xl6dzHUTyABCeOUX11L/prLBNnwdT7CQeb?=
 =?us-ascii?Q?QWw+tFrvKk+Jguv9vyc1H5BDGVRX3imJS7PZuSbOYephgxcPDFkf4VOntxdo?=
 =?us-ascii?Q?hYPIuIV+wca713/6HtkNluTNuxwawVF8mc61Nz5XWwtLFTANx2hcGGnUsRq9?=
 =?us-ascii?Q?ULEPyRHhihdnVQyErnKo8zDty/iob4dnE1ZEYvwWtmG7FsSz1bmyhIOXY5U3?=
 =?us-ascii?Q?CmT7QE2ERDRgeFuZObAJP6wIPZBXDN7mZo6HSN+FdL7vJToLxtHZhMuP1yPg?=
 =?us-ascii?Q?J80bX0Oq8/YPhAEkCh3W7t23zTjT3qYv6qyekFvyLGygXNpftz1yWBP+o6Az?=
 =?us-ascii?Q?YmE3G8+h/egKtPZmzwVfUXD6UiBq0TQB6HtGPSd9kYIj8vY2j2TIgWDv6uMH?=
 =?us-ascii?Q?DV58AhAH9QAsUbuAUHhKL0JBbW5IOUljoCRBehda6UTloa/anO93A896UOy1?=
 =?us-ascii?Q?b9LBxjZ8SJIdsFIKwB2hQDFCzuVDbxl6DO3qn0tKLhcP98Fa2hnKspTQ5Kpu?=
 =?us-ascii?Q?UpOZkLUIvQnoj2ojMPt+mvxmPzJ6NroT9bODLfaB+n0Jq1LsJ8r/2tEJ16x5?=
 =?us-ascii?Q?Sk/9J+4beYARH9YuTvpBRg6xWAcNa6nkh9S0faoxbKKiyoNIiNR8Wvpr7Snt?=
 =?us-ascii?Q?jN7mWozvem/qTL84ibPlw34acN2UD8jYlUamIuMUUQlwM3q5JRQX82lQlg8b?=
 =?us-ascii?Q?oCfIr2UrRGcNZRI61TDRo7zvmq3wo+m3k1oMEYXQbx4v1tzSP7pKdVjCG8cN?=
 =?us-ascii?Q?SLcECFaXCVdRRT7uyrtuXjRoZ8JWD78wqFdzWpuLY3R1LI09Z/MkEdjTG2QO?=
 =?us-ascii?Q?6QUZH8s3ZYSTXDW2Qn51MP5QmaqIdcOUnXLM7YMp7bC4YLJfrEKx8KiFqePv?=
 =?us-ascii?Q?8ZbJ2aLCWKENfoJLev4KkMJSEpTW8alsyqshceatkxwqGo3+pzFY5d03mQir?=
 =?us-ascii?Q?wxrFAGG52xdEW4w4ETYpFD/I/25h78d5Sxuj0JcuYYkR9J6lD65575rEdHlH?=
 =?us-ascii?Q?TBfWQu2kXQQVov2KsAPDDU5ST54CrwLQDPCwS4vZNYyNYu8JgnZKi7i2VhZa?=
 =?us-ascii?Q?5b4EpBuYipSzj2ZZ2W0rtaVU/FSeyuviZB3ZWXvp4+TeHDySugFCOpa+Z1tq?=
 =?us-ascii?Q?aSWxfcrkV0KdCAgGid0l62JlRr90Wk0O0R2CH6wKGxHWvcXejnn7HxuMNs93?=
 =?us-ascii?Q?OhDaMDNfo2TK/TlHzOWWbPL5vLeMm9slDkoE/kg+RuyT6WUTUUULxecWk7r8?=
 =?us-ascii?Q?U5B7LFLud7ADNvwt6nwrcdtZINZO648xIAMKlDBRrFTo1W5F9DE5UUs9b2+X?=
 =?us-ascii?Q?y2JeFZAqP7rto1TaVR5oo0qx8ryLyl2eEYBy2ATmR6Y2k87VYnpQHCzLLIqp?=
 =?us-ascii?Q?SPpY4/5j43S8w0ztq+CreYFgQud6cQxVlzL6GVmW?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d09b628-158f-4079-9bbf-08db4d6cb194
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2023 13:29:03.5938
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fq/vym8rsIYPWr27Ld+aehtBsbEeR1JYF19IhQrHOPtS2+LM82piyRvrchwslRBS
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8154
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 04, 2023 at 04:40:05PM -0700, Jakub Kicinski wrote:
> On Thu, 4 May 2023 19:41:54 -0300 Jason Gunthorpe wrote:
> > On Thu, May 04, 2023 at 01:20:01PM -0700, Jakub Kicinski wrote:
> > > On Thu, 4 May 2023 14:26:43 -0300 Jason Gunthorpe wrote:  
> > > > This GNU style of left aligning the function name should not be
> > > > in the kernel.  
> > > 
> > > FTR that's not a kernel-wide rule. Please scope your coding style
> > > suggestions to your subsystem, you may confuse people.  
> > 
> > It is what Documentation/process/coding-style.rst expects.
> 
> A reference to the section? You mean the vague mentions of the GNU
> coding style? 

Here I was looking at the "left indent the function name" - that is a
GNUism. IIRC the justification is it makes it easy to find the
function with 'grep "^func"'

Coding style says:

  Descendants are always substantially shorter than the parent and
  are placed substantially to the right.  A very commonly used style
  is to align descendants to a function open parenthesis.

So this patch had things like this:

 +static void
 +pds_vfio_pci_remove(struct pci_dev *pdev)

The first line is shorter than the second and the second is left not
right placed. It doesn't even need wrapping.

I know some people like to do this in some parts of the tree
regardless of coding-style. The GNU idea is sort of reasonable after
all.

> If the function declaration does not fit in 80 chars breaking the type
> off as a separate line is often a very reasonable choice.

Reasonable yes, but not "common" :)

> Anyway, I shouldn't complain, networking still has its odd rules.
> Probably why people making up rules for no strong reason is on my mind.

I usually try to ignore most of the style details, but this one stood
out. When I checked the series against clang-format it was pretty good
otherwise. A few minor fine tunings on some line wrapping :)

Jason

