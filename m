Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 826C23F5EC1
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 15:13:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237370AbhHXNOV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 09:14:21 -0400
Received: from mail-mw2nam10on2057.outbound.protection.outlook.com ([40.107.94.57]:8513
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236443AbhHXNOU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Aug 2021 09:14:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jQsbfRDmLNQFJ/DQ+m0FyK9Q0i+YeaBRxOMP7sCKAEjanP9VU/cq0c+FtJRrBBk8PQWohjZfxHXKvbj7MnFsg5eeSl2W6upcK+FaymfNYtBLfMR/yyTFoZ7fQY/BltuTfLhJJmXxnpKYyklLKkkrHj8fuAJBAPye1P6nIOCsv/BQcjI0Cd0XjoGYOm1Rv0XChhyjqIujKrIMhs3FTAubCrKX8MfisJBLNAsgLXQDCDTB/biBCIORoL93x0wnc4ErxyQT/tDzfDjHoTwY1Mm6pzj5v+suWKuqRERkyFPYufc7FUwc4/+TVW1nFCFb59b/7nj2CFdQ2O2F3wSCQQrJ4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aMJ0WJ58HseRtifSwka7BEiPkGEbJiqtY+z1H08GGYU=;
 b=chs/ii6YoJeO8nssiYmNaOXE/n+sdpcggCWygIzMHLxNXY8Z2bh2ZwHORee81aWEhxUDvE3iSQpI35FccHfrbgrzY/vgJFxX3LaC+EHbupxshLx4FP0bg+HhirVBHfQXEDDXarMvHy11210yXAWVfdrE12emlOU/A1R18ZE5o54Wv8c+gGW2+kreUxAX94yxvIKuK4O4h9fCTBQ6RZsMJLuQYKmufuBLbn3wfh9nErevH52C8rR2mP3Ann0yrWfYvnKiAURzO5SgHJs3RhecUEzWDKgG4l3UoOrhO84kPPg/iia3CSwOyy/uYUOGZddfUdwthqRz67GTQaOFu9cJVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aMJ0WJ58HseRtifSwka7BEiPkGEbJiqtY+z1H08GGYU=;
 b=QNNhRa7mszQlZALzgkBIIpsLKb814wPHw5SCtQ1jyACO48axaOfPnCDHCWFfsKtM60fYst0nVMLHi0NLr8skgqJoqvT8wJDIuBssdVcdMq/TeS0cSInAu5nKW17Sor3WmN1GFTWkhxqhOKaWtFAr8vNXhVbUNOr6jKsm33ypzDkI28iEJ6vC0SIDv96S2r3tYas6ofMWyA8bZoCz+qTai6gxVFSgn//jGBHRvKzHREmh3z4KUUwku/O2HCsoPCR67O7/+bpTrOIhFz0KWVfUNDRrzKUE1okAxOBWE37nTv/u/cYh5EwivWtNWlpevnnEQSWFf8THXgkQZ+jgBCNRhg==
Authentication-Results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5094.namprd12.prod.outlook.com (2603:10b6:208:312::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Tue, 24 Aug
 2021 13:13:30 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::1de1:52a9:cf66:f336]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::1de1:52a9:cf66:f336%8]) with mapi id 15.20.4436.024; Tue, 24 Aug 2021
 13:13:30 +0000
Date:   Tue, 24 Aug 2021 10:13:28 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Mark Zhang <markzhang@nvidia.com>
Cc:     dledford@redhat.com, saeedm@nvidia.com, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, aharonl@nvidia.com, netao@nvidia.com,
        leonro@nvidia.com
Subject: Re: [PATCH rdma-next 10/10] RDMA/nldev: Add support to get current
 enabled optional counters
Message-ID: <20210824131328.GV1721383@nvidia.com>
References: <20210818112428.209111-1-markzhang@nvidia.com>
 <20210818112428.209111-11-markzhang@nvidia.com>
 <20210823194459.GC1006065@nvidia.com>
 <29c4973e-2e9b-9ea1-e8f4-c10e73671f21@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <29c4973e-2e9b-9ea1-e8f4-c10e73671f21@nvidia.com>
X-ClientProxiedBy: BL1PR13CA0316.namprd13.prod.outlook.com
 (2603:10b6:208:2c1::21) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.113.129) by BL1PR13CA0316.namprd13.prod.outlook.com (2603:10b6:208:2c1::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.6 via Frontend Transport; Tue, 24 Aug 2021 13:13:29 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mIWF6-004SKO-TW; Tue, 24 Aug 2021 10:13:28 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 31e9802a-cdd3-4ce4-7d71-08d96700f766
X-MS-TrafficTypeDiagnostic: BL1PR12MB5094:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB5094B947D97FAFDBF26EA64FC2C59@BL1PR12MB5094.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RLDjWzwwdlRTZfSgjdZJ3mzmj/cVTH30hIB+ZkldRJPt5xqtXpO9KLJgblvOPYbLDOVTsPcuPR3hWn69GgtQPDguFvirA+w+YyhW5bkxuiGX+waUUyB7D+m81hQnQpT9RsBGCZO5st/oQY6DoAIaoM8c5daWpHxoHj3wWH3+xyub+6LfU1LHoGJJZWNzPy8Rg5udGsmbVb7toHptVBsVM7pLxhKAjMSna2M2XMYcWwXwkMeB+6OOpLV73I6Jil+oBh3mXLZbw3JZKbbkX48nzD3NYuAxDTi+2Oyg4uAk4axl/fEfR+Aw8srg4XirNmjGLPZy6WWQC8lK1sxpTzCW39x3GYle1P8X6xLgr0b1J962sr4feepFdKrnmWXCbmV5E1C8PqBGOtTOxTr1prklUV8G1jVClRIHd6Arc7UDlj/v03vT8h0utMCcGATz7pTjDnu3wnRdMt1TGt8CSpLxnklpxYL5yJFxxRhoHiUPii3X13GJafCPMIn80Bl1sPjvRhAvVwKk2+qzKtLUzWBK0Nd1u4YW26q9NLh6hBmue5dCVjdXJcSJrZhB9SnF2nooaray5tcKv5DlOcv5sVrvoIm6gyR3Df2flDym620MI5oEsR+dKw9hcxDSmf8dqOohJVrPp7yuKz5IpUT+58fslg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(316002)(426003)(8676002)(37006003)(2906002)(86362001)(1076003)(26005)(36756003)(9786002)(6636002)(9746002)(53546011)(66556008)(66476007)(8936002)(66946007)(6862004)(38100700002)(5660300002)(186003)(4326008)(107886003)(508600001)(2616005)(33656002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cXTod175rVu6H4WCpHObhn6uzeG+mhXpWH2IzFM8Y154JzZFsUG6qAMYk+Cx?=
 =?us-ascii?Q?NxnMM+Ye+PfL4XnZN9KEC3qZExG735/NIr7FWJxcfWhWvRGupVr2mFUGaVjq?=
 =?us-ascii?Q?uU8Jjdy61O0LXvoFStikZvtK+gQv3ooHqyoJ6CVr1zL57zdhzHB2ssL9whGB?=
 =?us-ascii?Q?AbRqJ3zBByHentk9K6HRtxoLfgzUm4/x6XeOW0h8aVJDzHrcZGpvC5lgodUu?=
 =?us-ascii?Q?5gK9hsEPo+xcb7eTi07EnGZMfHgmYf4xmr3F/RXvM37xrg28yxgJN2IxFysh?=
 =?us-ascii?Q?AmW+Di6zLZKhTYVZw/b8PjyDQO86/cwl1dBkPA/5k0+GezOTbMFIxeuI1onl?=
 =?us-ascii?Q?QuqgDoLoXHlBVMUChznRoIz8KHIlftuAMkoJqBszEavEDpHgtiRPsgwjB8fx?=
 =?us-ascii?Q?dS+HuyV+B0iiSwFxvbJnr5ibwPnv/efHV7/aPJbd47s36WEaxiyk00twLWH7?=
 =?us-ascii?Q?2LS6A2S+8KWz81Saeq4XYchhy2LfVyKqSOeRYfX6wMGL28Qu1M44nrWweKyM?=
 =?us-ascii?Q?r5LGmXEz6ISlI+MlmcMg78X3WIKF/ZRTtypM34xC+1ovT65Pnev+HUIkkUST?=
 =?us-ascii?Q?5CP3urFoNpEchx6hXRxiHJHNE/c4zK8wbnGZD1XaPe3IZcjrPFFypE8S4+/t?=
 =?us-ascii?Q?HsQFCyKq9IqVP3yC5qwON2l5Iq5LMysWwT5eYWZ4nFBRbFLRewfckLPueslk?=
 =?us-ascii?Q?R02iFSdrMaP0a5AJrJlZZDFFj1rd7gmvL/O9NoINew0Xqert0li6TlEFbP6p?=
 =?us-ascii?Q?dK45JLPmOe7ivbbsru3tlPtRKk1slfnEFwv5IQIuxI+ZFXxGm8nbupcUHKQq?=
 =?us-ascii?Q?9pALHQA2cvdmdOq8Vy74wPxXN6rqxVJqJE2L+Ncv2iXA9OvHj7In2lyECzpz?=
 =?us-ascii?Q?vP40jIPLc092K2Kfq1Jf8XRSExKZAMqExhKxo5uVwwfDc6YZInW85LaavdnT?=
 =?us-ascii?Q?iW/TQ0BydG7HCFOiGDdWk/e5iSOhM/xX801KuGA/imZUrfksY6xFmcg2koMR?=
 =?us-ascii?Q?jET6us8KSkmwV1k5nhqsKnGA/lIJpyRizzeLzXr9Ep94Xid3zIXqurle9LAb?=
 =?us-ascii?Q?1v31SH6SXHgRJEmFn343X9qUKDFcUEGksgN0yIGPTMJYWaYaF4XmXOerRiOS?=
 =?us-ascii?Q?a2tRK+75im+fGwp/ten1iOzxaFzmhavX2mAF+HSDGbmfJHudjw13CEivwi6W?=
 =?us-ascii?Q?7vOztLTumkYKFVtagJ/USIlJqhO5fN3NRTmq+RuOQr4+QMkEm3XlVH8FgSOK?=
 =?us-ascii?Q?WqtfjzWqMCHpO39zSBrm2qouK0q3WZDxBTG37AwM/Hb5fPJY52y+HRaoi2Ui?=
 =?us-ascii?Q?TqD1W38OoaLoKmyTPNs0R+qK?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 31e9802a-cdd3-4ce4-7d71-08d96700f766
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2021 13:13:30.0544
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FJJJhvu6Lh8TWvVyjfq4D6xZ7hm131AJKALgMGmKKB68X7qoPoInu46sjkAGcw8T
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5094
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 24, 2021 at 10:13:34AM +0800, Mark Zhang wrote:
> On 8/24/2021 3:44 AM, Jason Gunthorpe wrote:
> > On Wed, Aug 18, 2021 at 02:24:28PM +0300, Mark Zhang wrote:
> > 
> > > diff --git a/include/uapi/rdma/rdma_netlink.h b/include/uapi/rdma/rdma_netlink.h
> > > index 79e6ca87d2e0..57f39d8fe434 100644
> > > +++ b/include/uapi/rdma/rdma_netlink.h
> > > @@ -557,6 +557,8 @@ enum rdma_nldev_attr {
> > >   	RDMA_NLDEV_ATTR_STAT_OPCOUNTER_ENTRY,	/* nested table */
> > >   	RDMA_NLDEV_ATTR_STAT_OPCOUNTER_ENTRY_NAME,	/* string */
> > >   	RDMA_NLDEV_ATTR_STAT_OPCOUNTER_ENTRY_VALUE,	/* u64 */
> > > +	RDMA_NLDEV_ATTR_STAT_OP_MODE_LIST,		/* u8 */
> > > +	RDMA_NLDEV_ATTR_STAT_OP_MODE_LIST_SUPPORTED,	/* u8 */
> > 
> > See, here - shouldn't manipulation of MODE_LIST be done by a normal
> > RDMA_NLDEV_CMD_STAT_SET with the new MODE_LIST array? This doesn't seem
> > netlinky at all..
> 
> Both of them are flags and this is a "get" operation; "MODE_LIST" asks
> kernel to return currently enabled op-counters, "MODE_LIST_SUPPORTED" asks
> kernel to return supported op-counters. Maybe the macro name are not good?

The marcors are fine, the protocol is just a bit wonky. The ADD/REMOVE
idea should only be used on top level objects, but this is a nested
sub so you should be using SET to manipulate it and it should provide
the entire current list, not a add/remove type operation.

Jason
