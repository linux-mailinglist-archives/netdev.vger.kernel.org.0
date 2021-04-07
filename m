Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBCF33577E3
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 00:43:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229544AbhDGWnm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 18:43:42 -0400
Received: from mail-mw2nam10on2071.outbound.protection.outlook.com ([40.107.94.71]:23584
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229488AbhDGWni (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Apr 2021 18:43:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZoEDVn+8mq1bu0OFu+IGu5K44cW1irW66XlkcIxk99mRjlrNPhUMzX8LJhN71tSvTRD2tvTR5eKZEukGwJAwLt/RkDVOrEqIDgbaHfO/Cd2Rrt9M80H6xm6KFdLp/QkyQgFjKMdqAwe9WEWEZsI+bCfq3efJOLmKuHcisbc4vK+cJdXh0cVCEbxVm2Spf6i/96Ey4ubpS/NtwBZJ/20NCVoeP9ZV8nPsw2Xos5j+SnMc8u4UmAZLmSLQUK2Faf/OgYfX+EAccMacreyweV3LPLINRxSewe90UNbiw34i1ejOXkmlSTOFvtL8yKVUBwvNaOf4Vbe3VInt/U/5uwUIPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EW1IgKbJBMGRG/BtV+75TSYJM7ikNvKAQ9Y8VNqTrMU=;
 b=WIDxVomQRRtNt2jcw18R6UOdKXO4d8SA7b8jqa7yzrPI4UolMtu30jxNvGqQB1im8JPzTp1KYCPJ/2IQhNRd4s4xyU/sBse4g+ytG+ozPQfmqyivxs6jyboZhpvVQIedR4xR9lfhbrJe3hOJUTR0PaBhTEq797Cnbvu+619stukG8Q5rE4TOGpOh6M0IfpNMTUOFzANhtiONXFtUhoUFGLtY76pkcPpvpzQU/Iq1U80E1kq6m3KgLJNxDclJMFkMnepKRqzvBzDtolBXiCXz1x1YOiipEVfZ8gk3vLnwvbkl6opgI9oI788VhaG9vyTdWO8lKYswOVjtLXrprzbUTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EW1IgKbJBMGRG/BtV+75TSYJM7ikNvKAQ9Y8VNqTrMU=;
 b=o6/u87Z3ZixpNEWjkvHGR4Js6FirXkKTDiGRDXhdsc29h0iBc7cImbIrvbtrpXNC7y8Zs1W9BDwSju8ZIzFkkoCvdJwTa9dWkOjTcg/WtIj1HgMM9t4KHelR/CLOxp4cbx1IkzABs+7XEQCLKxhqUlBasv6GTpMIznf+n6s3J6hSsW9UwH7L/kOZNZGtyJMHMovsCVkd/+vcHDuhOzESSWh1wENONpLxC59HHFhdqpzNNt4FoJpyNyAXoBbvK/+/tGoLfOyNQ5MfrYJRdI4zvRV58ceT/7m+o1hUsjJvNvXsPQKGpJb+Yt0B3WVT+DNr7fIr20SwlZthdJYPqBsIOg==
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR12MB1754.namprd12.prod.outlook.com (2603:10b6:3:10f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.32; Wed, 7 Apr
 2021 22:43:26 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3999.032; Wed, 7 Apr 2021
 22:43:26 +0000
Date:   Wed, 7 Apr 2021 19:43:24 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Saleem, Shiraz" <shiraz.saleem@intel.com>
Cc:     "dledford@redhat.com" <dledford@redhat.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
Subject: Re: [PATCH v4 01/23] iidc: Introduce iidc.h
Message-ID: <20210407224324.GH282464@nvidia.com>
References: <20210406210125.241-1-shiraz.saleem@intel.com>
 <20210406210125.241-2-shiraz.saleem@intel.com>
 <20210407154430.GA502757@nvidia.com>
 <1e61169b83ac458aa9357298ecfab846@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1e61169b83ac458aa9357298ecfab846@intel.com>
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: BL1PR13CA0226.namprd13.prod.outlook.com
 (2603:10b6:208:2bf::21) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by BL1PR13CA0226.namprd13.prod.outlook.com (2603:10b6:208:2bf::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.6 via Frontend Transport; Wed, 7 Apr 2021 22:43:25 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lUGtQ-002OFy-CZ; Wed, 07 Apr 2021 19:43:24 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4035e8bf-ede6-4c70-422c-08d8fa168e80
X-MS-TrafficTypeDiagnostic: DM5PR12MB1754:
X-Microsoft-Antispam-PRVS: <DM5PR12MB17543926416DAEED7BAAB735C2759@DM5PR12MB1754.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YitiTG1wEzPHJ/5Z6TbAuUJqjGbgAYQmjC1K/PfN+FqvnHcBnyEY2knzigU3Oz6O5CN/sPIq/iZVp4McBAh+vfnHQNXQQ2DorD/Jhu2//DcdZM+xrM7E7rZOYrmpW511ozNQpbT4ltbWcSFgolM1VZte/ZUJABV7fz5LgNrU8tvb3yr4SzhTdNMGM7qcBQjL59ZOgBQY1lDUquZGtssVB6Z8bWh417t4trzCubhFsWU6s1Xkkm23efsJtlTemVNjEh8Z+lurbb2AVD8SC/hWobqOpfQy8hwCKdWARMQ3mTdtXtt7CM8PPQAFSLKsqR4kKrWgdjkeApATjNNCU0La1aln0KabdFb4kboLwHmsXd18DBcw+RQ1/f/6kdDwe3n7YFubiU3QqflFUCZjGtCnXd7tMElbbxnj5CVnHMhW8RaY7FNNWeRTK8hb3qMb4kGeUiveDtnlXHGFqdb8H8CSiXiFvTydq1YY7qpBYiiE0pVPKlWkSg1MfsB3wGzFOj3OmQ79HTYsDRh2Xgh6I+/22wtmiWZr3eTfpiAOqODR+uciTZwEE35qmFetYPxzyVbYb9NlAHJ8XVbi0BAriQAITZzuQJJ8/WDFYbWypLfK32tCWgegQsH47i98N63jLsrt81EOzAaPSI/vvd7tSewgGPOUVwFKH7qanGNiPiBD1fXCsvrSYcBzU4oAmO+heFpp
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(136003)(39860400002)(376002)(346002)(9786002)(36756003)(66476007)(66946007)(2906002)(83380400001)(38100700001)(26005)(66556008)(8936002)(9746002)(1076003)(54906003)(6916009)(186003)(8676002)(2616005)(4326008)(5660300002)(33656002)(426003)(86362001)(478600001)(316002)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?QVame/CBvZs+dgwNKZnTxNYdhf6X4SEcmAm0mQMAeVB5hCVMcT+jSDC80Wkz?=
 =?us-ascii?Q?ZMqzercFAXmTavNpn5i1dNwmxG9mlsdr4rVatQtRliVfEx8tkwRpCS69sjTl?=
 =?us-ascii?Q?ZitMC3ZoeURHT6GsetzduBqVZxDZmwzAuAQMtECnQRSYzO+Z/AdDONDbzHNv?=
 =?us-ascii?Q?MudDQ1zj4dNUng2raRLs7c7wdNCfdbutVdaxMneHYeBM09LvMr/vsJ8YHJsm?=
 =?us-ascii?Q?wtWBb/IGwVY+1QJPHQA+BoUO2vww4j267kbhcGgre02+re/s1RHkTOYKFzZc?=
 =?us-ascii?Q?mWR35k+vjPibqVUDx6uDU2NeodVHwrSD+Ks6VvcG9oDG5ozNsStOiNRvbUZW?=
 =?us-ascii?Q?Wrh82ijdXQYkC5ZJ/PKltD+JLDQ/qGPE3OOR0JUO2Pby2eug52IKiq0jntZJ?=
 =?us-ascii?Q?R/eKE+PahIKXrkgbAg5ML2Wzs0lPyRJKvrX/Cs7ze/F1dx0eFk+shyaFQyfn?=
 =?us-ascii?Q?Xu9R0EmN68r/IqjVGBRcr86wAgUR5bmM4+w3NDvj4v/z9YiTHIG0cbTCAYHK?=
 =?us-ascii?Q?2tJUdyOaTirtPq/pFjBARnoc+/kUDVmSfBSL9igc0pL50CsKcxTshCANtwRn?=
 =?us-ascii?Q?vF0+WCLVYrscJjI7qhF/PktB8hz3dvvZIimdwgq9mmte0Z4GvD+b6enRJNXg?=
 =?us-ascii?Q?znMw+lJl7mN1OKQeO5IiqFI7T0qeWpwAlAR9QqT4QECmDm7CoMxyY5wFaRHJ?=
 =?us-ascii?Q?YQiMiUjIKxm6yov6ivYs+CaWEqegPMJ/YnyOLdUG+cv/6AXhyKZCxuJPtuuN?=
 =?us-ascii?Q?VFWU+3c9J/e1Sa8SYgeVzScCXl8zOm/Pkx0sXfUlbQRnKIKxuxAZENpZxdtG?=
 =?us-ascii?Q?RWdbVPzcH1syaP1OqPYnQvSsmYOJwu/Opk0QO2OfnOATS9OGhYstEwgxJvJA?=
 =?us-ascii?Q?nl0YL4BPu0eroLM0HsZ5Y0o5MO+X5N5Opt9xp4ggvG+FCaPmyQSRESj2Slju?=
 =?us-ascii?Q?0J4ifJcd+QGbTl7F0hbJKhIx8QbjtZ8LV7MBrE8uKeY/R52yI1kTTKvZfK2g?=
 =?us-ascii?Q?6ivpMZA+kE4xuAqXadqT/CO5/lE7+lxDxznHy+aaoqqAs2ET48lOcEaBDTW4?=
 =?us-ascii?Q?NIB1/rJRImRjfrt5x7nnPFQlfLAN8QNq1ccgYlajJ+yswjXHkQkCWlRzzfys?=
 =?us-ascii?Q?hB8qGnSOrWCKSLepIK09PSucoK4kRTpW+6a947JaxlZ7cKV8oPxC02oTcuaX?=
 =?us-ascii?Q?BBAAXjqSpxBdZdzGM5VkNyXoDanALRAR+8laXIc/2N7/z2Ho2yTkIrlXMEOf?=
 =?us-ascii?Q?yad0IzW5fuzwj9ILHjQS1dxzcZV5R8bRla5G4XycT4quTNrFs/1+zbUm4SOz?=
 =?us-ascii?Q?NBF6kke6Jen4+GX0RfnBZQTGJYHOoGdCkmUyOwH0GuiZbg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4035e8bf-ede6-4c70-422c-08d8fa168e80
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2021 22:43:26.2948
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IZPv2HD0mxJBQuVmyUaUy0BvfR4OYS8Q7JcC3B1wExZdnDgSA1oQYTYEFaGDRGcY
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1754
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 07, 2021 at 08:58:49PM +0000, Saleem, Shiraz wrote:
> > Subject: Re: [PATCH v4 01/23] iidc: Introduce iidc.h
> > 
> > On Tue, Apr 06, 2021 at 04:01:03PM -0500, Shiraz Saleem wrote:
> > 
> > > +/* Following APIs are implemented by core PCI driver */ struct
> > > +iidc_core_ops {
> > > +	/* APIs to allocate resources such as VEB, VSI, Doorbell queues,
> > > +	 * completion queues, Tx/Rx queues, etc...
> > > +	 */
> > > +	int (*alloc_res)(struct iidc_core_dev_info *cdev_info,
> > > +			 struct iidc_res *res,
> > > +			 int partial_acceptable);
> > > +	int (*free_res)(struct iidc_core_dev_info *cdev_info,
> > > +			struct iidc_res *res);
> > > +
> > > +	int (*request_reset)(struct iidc_core_dev_info *cdev_info,
> > > +			     enum iidc_reset_type reset_type);
> > > +
> > > +	int (*update_vport_filter)(struct iidc_core_dev_info *cdev_info,
> > > +				   u16 vport_id, bool enable);
> > > +	int (*vc_send)(struct iidc_core_dev_info *cdev_info, u32 vf_id, u8 *msg,
> > > +		       u16 len);
> > > +};
> > 
> > What is this? There is only one implementation:
> > 
> > static const struct iidc_core_ops ops = {
> > 	.alloc_res			= ice_cdev_info_alloc_res,
> > 	.free_res			= ice_cdev_info_free_res,
> > 	.request_reset			= ice_cdev_info_request_reset,
> > 	.update_vport_filter		= ice_cdev_info_update_vsi_filter,
> > 	.vc_send			= ice_cdev_info_vc_send,
> > };
> > 
> > So export and call the functions directly.
> 
> No. Then we end up requiring ice to be loaded even when just want to
> use irdma with x722 [whose ethernet driver is "i40e"].

So what? What does it matter to load a few extra kb of modules?

If you had both drivers use the same ops interface you'd have an
argument.

Jason
