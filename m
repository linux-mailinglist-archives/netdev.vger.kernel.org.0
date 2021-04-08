Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90C6835830F
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 14:16:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231466AbhDHMQT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 08:16:19 -0400
Received: from mail-bn8nam08on2064.outbound.protection.outlook.com ([40.107.100.64]:3553
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229751AbhDHMQQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Apr 2021 08:16:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b7MZD2PBEsmN8/gbEt7MjAzEwb4mSlanDBwxgBVhDJZYnBTRekOndDapb1h+jZcgj50qSdaKEmRjPTBxfHczHgF6tSfGjPXjdcCqmcvm+2ZZqswSQyBqL3PYv1ZmghNQ4qiVoszFrJPax5ex/x9EXrGw8NA2qTU3mtv4h4/HznPqh3PYze77RoJLxAXyhOrpz1iw68e75tB29fU0KeyuCF8PjaHdjqY8qLGGjq2IHxg0d37jXQ3WSvDRbuBjqlxEhm5o6idLio83U4TW922P6VcvjRjkSyZCucQOWnmXu/6CVmYS5dSHGfvuphuemJzfZ0iBZbdiDM0eanYuon0v1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qqpVQO99rmH99EFB9g4Y0gGAbL0u43jOWRqoKWCWF5g=;
 b=jsBwewpatKbYc4Kaebcjr2ALx//akVRnAg2ANdxHE0PzG0h+CWpAna0zISpgrr3ddCvvT3svoKz0zKC+8T9DWtH98oGoCVCucHKJFyZoIlqaFSA9p+h6C9gMvkWisachPDIRz/SuAj+FGtE6su4gTIV4jGKFqr4H4DwRdjvh1Dp11qjgEnkRqJyCGn7KM0NN9I3v2NmwaFH0kALgFBCxcLREh8jYujVdVS+ZQhh60nyD9eh83J5skmcNd2x1w504wp39iL+Omjrm1vFTuj38v2Xst2yN3RATtfcIO5Rjb8fLi7cC2kRuYNhaWgpc4dsfph+Cv02Kc43rJVieioxADw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qqpVQO99rmH99EFB9g4Y0gGAbL0u43jOWRqoKWCWF5g=;
 b=RhcfOctHuzM0Asrnt6eIwWqi/jRvvi3zCCx2ghANI/hh+ZslnLA4YX8yXUdeuOy+NQRxEch5noh7sl353Grp392IwLBCna9K3a3bIP9K/vqL1LaFAOkO9aiFi8B1bdWVwwby/iTrlPF3Qj9/TgLf+RQme2x6sC1sWKjNiYXtX2/ui2OLOgXjHtUkVW0Q+B1uq7lGxAsfB5IUP9GRsoDmfv0vaMQGXEVE3L+5gvHvp1BPj+9QVAcMMY/c+kYuk/Oj0tEllAJU8MrmVruVe4NSDzoit+vRNsQSLahu36ohIFxpsaRy49dWqbojwVFWZRSa6FpkJ67ulRZFzg20wRZu5w==
Authentication-Results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR1201MB0105.namprd12.prod.outlook.com (2603:10b6:4:54::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.26; Thu, 8 Apr
 2021 12:16:03 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3999.032; Thu, 8 Apr 2021
 12:16:03 +0000
Date:   Thu, 8 Apr 2021 09:16:01 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Parav Pandit <parav@nvidia.com>
Cc:     Leon Romanovsky <leon@kernel.org>,
        Doug Ledford <dledford@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Karsten Graul <kgraul@linux.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "rds-devel@oss.oracle.com" <rds-devel@oss.oracle.com>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>
Subject: Re: [PATCH rdma-next 4/8] IB/core: Skip device which doesn't have
 necessary capabilities
Message-ID: <20210408121601.GR7405@nvidia.com>
References: <20210405055000.215792-1-leon@kernel.org>
 <20210405055000.215792-5-leon@kernel.org>
 <20210406154646.GW7405@nvidia.com>
 <BY5PR12MB4322E477DA2334233EAD5173DC759@BY5PR12MB4322.namprd12.prod.outlook.com>
 <20210407151359.GI7405@nvidia.com>
 <BY5PR12MB4322B39A132397E661680A4BDC759@BY5PR12MB4322.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BY5PR12MB4322B39A132397E661680A4BDC759@BY5PR12MB4322.namprd12.prod.outlook.com>
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: BL0PR02CA0053.namprd02.prod.outlook.com
 (2603:10b6:207:3d::30) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by BL0PR02CA0053.namprd02.prod.outlook.com (2603:10b6:207:3d::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.16 via Frontend Transport; Thu, 8 Apr 2021 12:16:03 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lUTZp-002hmY-UT; Thu, 08 Apr 2021 09:16:01 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: adfc2c1d-6568-437c-be17-08d8fa881432
X-MS-TrafficTypeDiagnostic: DM5PR1201MB0105:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR1201MB01055597473B9E146A05569DC2749@DM5PR1201MB0105.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:565;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pzHXaBxL1HfOkzcnRvHYyMSLVgzB266FJjrGJ7S0OVGXDOr2zek590iGI7e1trJpkuz3OF588c+wUiGqXV4ZZewiTTaUtsfdhVJptS+IljmCXMSmUNjkGMeB/9fyZR33Kgr9/mt0C9hwWimVDnmXvMafpuemzoE5gKrR1qM5FTMcCkFcP4RSghpfLXcMmvtQQTbwvqtJ+zUun2b1Hm+gzJyWvU4O5gLqliJbHwMTIavizLL6ziVuQcQeoeiZhpl+rOvclVLVeaS+KXfF4BBklpcOxTXh+v4KNyHVKnFD400wyNBo246Y1kMXpqNo0jEKEtrqZZBJOWudxWD/FzOntK+Cgc6M8kfJvrmqc/a02XJI+wvYYAFlz9UBqVgaTmH0h7pab9vG/u4cSvOoIgVUgpVQbI1C1rgTvRX327xPGgUp35fwcknlKTg+xr1PLOkxnFe1gDdgOkP0veNGHOsuu0YsTrN0b9hYc3K1SA/29Fs+mN8HPRGOE12VTBMSUVoe1aN/Ok8/BH4epMdHDETyTdo8aoRyj3+0ADSa3zakAmtDG8oNJoYk2haaZzdHdh77ANRXb2yarNLDCAm8JG3PInBStDrxHOY7wbYq9P6DlqaVUV9L7p1codXODdo2w3dE6zrzDxAQG3RfvsRaZXpNyOOuHkT8Gp/PLkKqq/C/DnU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(136003)(39860400002)(366004)(346002)(6636002)(36756003)(186003)(26005)(7416002)(316002)(9786002)(37006003)(9746002)(54906003)(5660300002)(6862004)(4326008)(4744005)(66476007)(2616005)(426003)(478600001)(66946007)(66556008)(8936002)(1076003)(86362001)(8676002)(38100700001)(33656002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Gy9YQammP118enaKZoMAmfc9+oSkGZXowtKZQu+otEGuUWr5jdesB7RJ41b2?=
 =?us-ascii?Q?7pUPkrS0vllqIxM8FtvwkuUQrLsb66+B+kzbT7PFpTiEA5RpWhmUxyO7ZcJM?=
 =?us-ascii?Q?CkEp7Db9p1b9etfrCEF68POFimsKa9+CoTV1yLX52fyMR7ErjG4YG6Vmou71?=
 =?us-ascii?Q?v8nK4tRu+iYuUKquKL5WzBl6DAd4u6/Mb1b4thwvCNFBVQa/nUWw4Svv0SAE?=
 =?us-ascii?Q?LkBzHd0xFdJ4v7ctQtCqfv9isPcvwp+nOUUX8qctMy6Nb42qFsNLm7OuQOiq?=
 =?us-ascii?Q?CaW1Cz9WHOHCl1lHxyMj9VnTvzxpNSALrwfYVV0v7/gSBgcmtA0VckdMsjUN?=
 =?us-ascii?Q?zOEmsA/Da2ZFg8EHKA/YkyMS1sVj82LL6QIrCXQCEuFtsYfnboPzOujL5wcA?=
 =?us-ascii?Q?B2sazWBzAmLKWhmp1XDs9g1hPsk7GmfduNxjsHuaLsFFWydO2rHWXaeJEIvs?=
 =?us-ascii?Q?I4M7/THH25UGUPkYJZBOFxjnftNTSlxuNM6dD2SHm5lEIEszFftFsR+EmkM4?=
 =?us-ascii?Q?lo9OO4gUv92To58vBXEA2FN6g/LstjBPy5PaFpghku565m45frqTI9B2pUKg?=
 =?us-ascii?Q?XQ6eGohnSy7RbTx2BS8RVD2gP4bIBLkUr4JowJ+TgBDWH846IJkbdeH/PmOU?=
 =?us-ascii?Q?pcIrH8tn1j04icmS4/p3u5AqnPUOpksQ3fZF47cqufnxU84xfKJ55hoclmDK?=
 =?us-ascii?Q?Hzl4FwEozcm5E7o1H6aMppLWa+0Z1cxrpgkxqQ33rplCYee9qI7EHqUuOjc6?=
 =?us-ascii?Q?Sr2nZdmbozKpSXt6N+a3EdLnUnRqan4pwVU9dl4Kh9hxdLPAJQml6fleaRvi?=
 =?us-ascii?Q?uPuwIfAT22602lE/SVUl2gGecsupVEF3F5LKPOPCjsqM663T1xKhR6+NPptx?=
 =?us-ascii?Q?s6p+gvnd/9T3iIwA/A1159XByT+bfLzjtMVPkFc5h1WNA3mw1GtdnFhDjRGy?=
 =?us-ascii?Q?5HkPjV8ko+5pJcdTepxuO4LDAIzMrKiCc88UD6A22OS98jDTE7lxnk8JU/kN?=
 =?us-ascii?Q?w/JqzSAiMohyM3TFho3Slh4TYvDTgL7Mmgwxz9RphF1ajb96zKwYhCIUfEfp?=
 =?us-ascii?Q?R7AyV1P4mROBOOUvSwB7aoo0vAvrw7fbCv711/MWsLE6vAEmbef2mWGmrcZX?=
 =?us-ascii?Q?RzqdKs2w5Pi2UVNWLuGMcnssuRvqDMKrzlz6wBLmEY303rtUD+kPVbyPfg02?=
 =?us-ascii?Q?l3pbll3+J25zgt2h4Ng/AFl0q/rTMBQIh7i5fefdFdLvQgyHcXe4x6xP8sOe?=
 =?us-ascii?Q?RxWrGXcpC7Wadgk1m0jg4yv2sS3fSz7FeQs3BZpsz1kP8UiYQCfKampn3vE1?=
 =?us-ascii?Q?cEo+aZ/bXUMSszrAKckYPYsXwdNzhxdgtcGNNCGdkThz7Q=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: adfc2c1d-6568-437c-be17-08d8fa881432
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2021 12:16:03.6699
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gE439sZzILH9m4RFipQO16KbpjaojSI/OccX6mO+rsfv77zj1U9XnuIQ4bD3Tib4
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB0105
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 07, 2021 at 03:44:35PM +0000, Parav Pandit wrote:

> > If it returns EOPNOTUPP then the remove is never called so if it allocated
> > memory and left it allocated then it is leaking memory.
> > 
> I probably confused you. There is no leak today because add_one
> allocates memory, and later on when SA/CM etc per port cap is not
> present, it is unused left there which is freed on remove_one().
> Returning EOPNOTUPP is fine at start of add_one() before allocation.

Most of ULPs are OK, eg umad does:

	umad_dev = kzalloc(struct_size(umad_dev, ports, e - s + 1), GFP_KERNEL);
	if (!umad_dev)
		return -ENOMEM;
	for (i = s; i <= e; ++i) {
		if (!rdma_cap_ib_mad(device, i))
			continue;

	if (!count) {
		ret = -EOPNOTSUPP;
		goto free;
free:
	/* balances kref_init */
	ib_umad_dev_put(umad_dev);

It looks like only cm.c and cma.c need fixing, just fix those two.

The CM using ULPs have a different issue though..

Jason
