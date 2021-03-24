Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16AF7347AD7
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 15:36:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236288AbhCXOfb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 10:35:31 -0400
Received: from mail-co1nam11on2059.outbound.protection.outlook.com ([40.107.220.59]:49443
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235922AbhCXOfM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Mar 2021 10:35:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YmgXUeuDvuC3kU5DTax3Cr5Fd8jaMs1B0yviq+fXmdxj61Z56ZMCqk+OdsD+42UIF8BXVUxH9/M+J95Ot6jQF0pWJm3WGJAxsWCANhqureZ7ZL2cVF/t3s19cXKdhODZHUzRFwwoEyXz216pO+8jJMsKTlId2eOCCqzGXg5+mmeUr7HaY5n62uBV/K2ckNjdyK6ruBYdfS/K+F31cWTA/yns3P/GX9w1CZN15aY1tw//yg9cRn4lHwNbf0QIoCa1CmjuA2OMzSjARclwnEWaKmGb/+87e3nqQ7J7Bf8G/V1/af98hTZ6yDpFR/mJnelv5IrxUShCDZkbYfKWAc1oMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KyxCenQClNqBoinFK/TOL5mFik+ZgxRULE9WOJ9Z1Hg=;
 b=I6Mcxa9av6s05Ti8uK+o0Y3TbTII7D2fuwCf3SmaDVdJVLhRQQejJOTd+Rv/At4NnBmm5ITys75Olne3SqTKb3CnQMmLGE9Wtl8+oVkjpLZKgdyHGqCwHNd8pGHsNYxb6F4+Mni9/V28H7CzBETiyEfSkomLYJXdSPw2S6tS2aAo5/6Ah5RQE0XaG50WkLc3zDRtBs/Y6GFo8jwWfvGJfEX2d0M+aaA53UaElHQ3dgQqSY0wtJlJ+MR9/OZIYFK7JRyWgf3lD7qcKzNdaRP+Pi4WWnn4FHqXBPof5QwtKT26o5xkYcV6Eh7zj+xjIvLCIbNzs7u/q0csYRfFcsNRzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KyxCenQClNqBoinFK/TOL5mFik+ZgxRULE9WOJ9Z1Hg=;
 b=SfOowABYakJTessvqAcJ1x0E9gTfJrlW+SgxHZzHk6QFSD/5M2DXnCZCmCL/RkjqGNZeYFOFAtWuLnlhe/hk6wv1UzsE8ItfA6H/arzuYPY8LWbRR/WubN61qsjBGZJGtSIrWt3GIHt6vtvSs6EE+wkIjdnSRKraRcN7HKiHrSG7Q9ZqR7wPco/sQSFK9ie2T32b6M5qsjRdU2Y2d3AOJ1Ei3wadI0sZeGhvNx9JF1zmRjZ7XhLzq4gei8Vw5Dr3euddK4CMLbYuu+ATFzcYb096F3TDbAsPW8TwHIiPIiRwIt8sb79stEsx05y+bSv4L2It3nj81rWoRvEypsKtzA==
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR12MB2437.namprd12.prod.outlook.com (2603:10b6:4:ba::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32; Wed, 24 Mar
 2021 14:35:11 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3955.027; Wed, 24 Mar 2021
 14:35:11 +0000
Date:   Wed, 24 Mar 2021 11:35:09 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Shiraz Saleem <shiraz.saleem@intel.com>, dledford@redhat.com,
        kuba@kernel.org, davem@davemloft.net, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, david.m.ertman@intel.com,
        anthony.l.nguyen@intel.com,
        Mustafa Ismail <mustafa.ismail@intel.com>
Subject: Re: [PATCH v2 08/23] RDMA/irdma: Register auxiliary driver and
 implement private channel OPs
Message-ID: <20210324143509.GB481507@nvidia.com>
References: <20210324000007.1450-1-shiraz.saleem@intel.com>
 <20210324000007.1450-9-shiraz.saleem@intel.com>
 <YFtC9hWHYiCR9vIC@unreal>
 <20210324140046.GA481507@nvidia.com>
 <YFtJ8EraVBJsYjuT@unreal>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YFtJ8EraVBJsYjuT@unreal>
X-Originating-IP: [206.223.160.26]
X-ClientProxiedBy: CH2PR17CA0020.namprd17.prod.outlook.com
 (2603:10b6:610:53::30) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (206.223.160.26) by CH2PR17CA0020.namprd17.prod.outlook.com (2603:10b6:610:53::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24 via Frontend Transport; Wed, 24 Mar 2021 14:35:10 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lP4bF-0021yy-MK; Wed, 24 Mar 2021 11:35:09 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 98944052-6df3-4662-d212-08d8eed20769
X-MS-TrafficTypeDiagnostic: DM5PR12MB2437:
X-Microsoft-Antispam-PRVS: <DM5PR12MB2437A165828006FF3A8AF101C2639@DM5PR12MB2437.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SDmaAPqJ7zqOKZhfc8EPWx3ebbSx/wUtkNiAxKDk53IiHICNYU4RSHIcTpSPVW1hdL2vXqdnpt3s8LlY6tykYy+tG9FqcPzEjW7o1c3221jxixQWO5Wu3zTFZzXI3gcoB57gdkZlVZLrVLIgW2Skikz8GAXiQio+fiGv6msr2oSFUKVXZ6YJ70U+I40N+ZE5tM1/gGJICwQ7PaiSyNUc6FgwZMJ/8kDJSGlMi/N+DmMWRgBo+dWyjRBM+NHDeB4L4pOWT7/BG6IFWtkRUgF/W14Yr2MvY+nQpO3KZreLmEO05zfCH5ZZ+7+5nbqkfi5qo7fwOuHbLrKhU21ift3P2wk+WpKLQ2rQ+27C3s9OOm8cFYwcNsrZK6XMh7AbK859OPitNIE4398lti8RUnGZIlwwy7rGs9+l1oATAK7vu8iDKH3gqdJozwEb3ZOoKP+DoQPbkN2UV6UL+E1u5te9vW3zAMkagTs3paToPlnVwm3UdwZjQqv57bEhJpsOxVt/Q/6ZYNT2hnzBI/WQa7FHk7JZjw4GpIx7ZIcevipvI/zL0prIKpWOFa2DNoDZgSJrhyPPefkfPdQf+mJLuXNwzWICePkFyfKrCONLhFj3Kxni+XB5FuQcLyuzyWKyNtvo0ZR2peEjZ1zhBVeSngQkEUwcpQp20Ta5g7AdzkJ6+t3wV56Q9Fj+U623PaAaSO+S
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(346002)(366004)(136003)(376002)(5660300002)(4326008)(6916009)(66476007)(8936002)(66946007)(8676002)(26005)(33656002)(316002)(54906003)(2616005)(9746002)(38100700001)(83380400001)(86362001)(186003)(7416002)(9786002)(478600001)(66556008)(2906002)(36756003)(1076003)(426003)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?rKY6PmhcysqLkugP4LMtb4Q83293oEI6zN9rQk0Uh+WEkIuQ67DnGKSqfuDR?=
 =?us-ascii?Q?sKFdVu9oe5vtJflCyCgQaOfk6WZ/4wDn3S38bYB+scQWApnX1kXGKdnY2175?=
 =?us-ascii?Q?ERF9Hb88YtQHdXkhvfm3HGEByvMLutCFpBLnTGDWwVZ2IpPcfgcJK5zBJh4z?=
 =?us-ascii?Q?Lq2eIks9WwMITqqygOM+lafm/wYFRAAOvvsD5qbsRpn1qDo5YZSzrJA7aIfO?=
 =?us-ascii?Q?yVHuEUvw8Ct/UVqsWlkOLEsCTY/3ES10whHbD/NK6fG5Or1M0wJ7twyYEFzw?=
 =?us-ascii?Q?6VrdWp+Gec7ORoFuhHThc2zbYIHrIWtBl4A+EQEboLos/VB232d0aWO4xM+U?=
 =?us-ascii?Q?ujBKcyUZKeBnc/Ffd5z927oOQF5JpSFEF4R0itwfW1wIOdeqFNTnWFhkBA7K?=
 =?us-ascii?Q?UxNHawvDMRFxkkUYX5uM6lHyTXyh0fhTrjZziGM8CayfTky2XL1WWW8uaHCE?=
 =?us-ascii?Q?TY7J3auoY0L5gX8XsPKKIe8RHXpwASKasCosHiDuvDR60o7r5KN8JOeLjwvk?=
 =?us-ascii?Q?+wyaz/kFSk3nPsWpy4L0NkqPIoNbfDW1HX8Ps16axgLq2sm9aM61C5XOzSy5?=
 =?us-ascii?Q?A5yWdufjp4JhwQaXpselMVFWdUVKx2pjKBkd3bONmK8OJyaDSBwa1F1I+rR+?=
 =?us-ascii?Q?Kw9RXqbjlPPET7v+FXCSdQXl04K5ONSMyYyPt1ajTEDqb7TGssMr5qySut2W?=
 =?us-ascii?Q?E3ihIJ8/rEa7pntcnEp3zc4NGXZcXIsWtALNX+2zY+ey1fJaTn8fMNVP6Yrg?=
 =?us-ascii?Q?2ufXoMkkC1VUBWACSGwjm2Ei3NKkNOeT38B0Op0DkKPem+MolAmijcbTQc5z?=
 =?us-ascii?Q?9EKFjXmgXn+K9q3yhIpsXZtSsujMdOL/8Ztczh3Ed+VxRM1uUstVAHc5kSYD?=
 =?us-ascii?Q?nSUJNV4Ooskv/bQPM028pDsx3zQn2p4H5qKnuzF7Mn8qkJgnUFnhhAyf8HLi?=
 =?us-ascii?Q?taMoNW10P7YOENJqcInsGJiik1ggrXQ6+D8bLJ462VeqvmoseSLioXMEu/XM?=
 =?us-ascii?Q?j1xJ013CbTLQuF2jqwW7XAuwpr0K88bXoQGOIq2zR6aSccK+M9ovOtPe8ldm?=
 =?us-ascii?Q?22YHzCiyZKsefYcXPXSp1dBIqfC8s+oe1t5ef4bEWGhbotbU/6EpelEwDAzF?=
 =?us-ascii?Q?fQRTMArVYIu8tw5XMm0fXMtTNRSrbPFXie55af+JgaIGxGtOy91bV2X+l0Qn?=
 =?us-ascii?Q?1BbYRg6/l4AtlX/Ll+MJPEAA2qwPgDdtDhioeA7iXNi4MHGzSYP2NudN6Ihh?=
 =?us-ascii?Q?S0nmluRO+sKUw/5wSfI8UGr6sMwW5chhNH2dw34TRSYVxsS/oDF85PXcGNm0?=
 =?us-ascii?Q?1ewYez63qYjqc7xYxFvg/ysj?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 98944052-6df3-4662-d212-08d8eed20769
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2021 14:35:11.1771
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +zfcbWI+hV/b9sPuIYjS+YTtRAp2tlM276Rb83BnMhiJa+gqvi+chhl9pQJ6th1G
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2437
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 24, 2021 at 04:17:20PM +0200, Leon Romanovsky wrote:
> On Wed, Mar 24, 2021 at 11:00:46AM -0300, Jason Gunthorpe wrote:
> > On Wed, Mar 24, 2021 at 03:47:34PM +0200, Leon Romanovsky wrote:
> > > On Tue, Mar 23, 2021 at 06:59:52PM -0500, Shiraz Saleem wrote:
> > > > From: Mustafa Ismail <mustafa.ismail@intel.com>
> > > > 
> > > > Register auxiliary drivers which can attach to auxiliary RDMA
> > > > devices from Intel PCI netdev drivers i40e and ice. Implement the private
> > > > channel ops, and register net notifiers.
> > > > 
> > > > Signed-off-by: Mustafa Ismail <mustafa.ismail@intel.com>
> > > > Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
> > > >  drivers/infiniband/hw/irdma/i40iw_if.c | 229 +++++++++++++
> > > >  drivers/infiniband/hw/irdma/main.c     | 382 ++++++++++++++++++++++
> > > >  drivers/infiniband/hw/irdma/main.h     | 565 +++++++++++++++++++++++++++++++++
> > > >  3 files changed, 1176 insertions(+)
> > > >  create mode 100644 drivers/infiniband/hw/irdma/i40iw_if.c
> > > >  create mode 100644 drivers/infiniband/hw/irdma/main.c
> > > >  create mode 100644 drivers/infiniband/hw/irdma/main.h
> > > 
> > > <...>
> > > 
> > > > +/* client interface functions */
> > > > +static const struct i40e_client_ops i40e_ops = {
> > > > +	.open = i40iw_open,
> > > > +	.close = i40iw_close,
> > > > +	.l2_param_change = i40iw_l2param_change
> > > > +};
> > > > +
> > > > +static struct i40e_client i40iw_client = {
> > > > +	.ops = &i40e_ops,
> > > > +	.type = I40E_CLIENT_IWARP,
> > > > +};
> > > > +
> > > > +static int i40iw_probe(struct auxiliary_device *aux_dev, const struct auxiliary_device_id *id)
> > > > +{
> > > > +	struct i40e_auxiliary_device *i40e_adev = container_of(aux_dev,
> > > > +							       struct i40e_auxiliary_device,
> > > > +							       aux_dev);
> > > > +	struct i40e_info *cdev_info = i40e_adev->ldev;
> > > > +
> > > > +	strncpy(i40iw_client.name, "irdma", I40E_CLIENT_STR_LENGTH);
> > > > +	cdev_info->client = &i40iw_client;
> > > > +	cdev_info->aux_dev = aux_dev;
> > > > +
> > > > +	return cdev_info->ops->client_device_register(cdev_info);
> > > 
> > > Why do we need all this indirection? I see it as leftover from previous
> > > version where you mixed auxdev with your peer registration logic.
> > 
> > I think I said the new stuff has to be done sanely, but the i40iw
> > stuff is old and already like this.
> 
> They declared this specific "ops" a couple of lines above and all the
> functions are static. At least for the new code, in the irdma, this "ops"
> thing is not needed.

It is the code in the 'core' i40iw driver that requries this, AFAICT

Jason
