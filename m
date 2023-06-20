Return-Path: <netdev+bounces-12213-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D810736BEE
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 14:31:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9D08E1C20BFE
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 12:31:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 943AEBE7C;
	Tue, 20 Jun 2023 12:31:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8124D156D6
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 12:31:11 +0000 (UTC)
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BF721B4;
	Tue, 20 Jun 2023 05:31:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iC8MH1qoPL4f+wMv5FdthoTkr4QJHO7qnyMlI7GYjGZyValdIVAs0GkKLfi+O2adQOV26q3r3oHk+nDV9kpJJAjRkZWxSnMFRFZeL67ndqNguUYknLfhOciQaJ0emLGwgzu26kevEzum5Vx5ZDniODOnH8A7N8GU8CqQ6DNF/OatF1Qq5vLBQHVMoBZLtBwAjYG09798KOZwOi1h0EFhSNTye3p33gK5ImPtR1rfvy78KWa+JODGWO+bYBh8t2IF5QR/dxhOWekt3BaHRIdMMLr+oMCtTxsPgaF+pnPiy32PCh4Xuc764GsPkKXEmF5JdytKWV6ny5r78INc85od8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zGNf4fCe7A9A/J3W3jFXL8G74K5RlSFBMnQAV4R3EC0=;
 b=cLX2BzUMGy/MLeUOtOS1i6VJtImNtgT/XlPz6wkdHSnyqcCpbu8VlzaTOttlVBitTDzz3Fj3mKSYZm9l3Z2oT6AFMILKJ31vtigJeC/INlNq7B90aICqjfuGuu1Gfxwef+tX/r3RDCNZY4nq22Z1d11OUoyU9ufEFzREjmYZ13hSwp+pvHvR3aKNoE9GvwJdUGvb5d6Qq/xT6mx/8uEwn9Rv2m7jVkKtWRkfiMIkGehNoAw2NFEXcEKqYmS875K2eb8HUOXuwAtCWquhxoRYD6J3O0KyHYH4KtGua7A8TD6P6ZWeD8T0yILKB+evGTztLk8Dy31SGiwthwJrzTc6Lg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zGNf4fCe7A9A/J3W3jFXL8G74K5RlSFBMnQAV4R3EC0=;
 b=Gq5J+wo2GGOyvQbzIgWFBGfIobIymB5ECql3zM+k0j762sstSjL//SCWkn+IQ612gqzPcbtU72aD157h7eFN/JOOTKuq8xWLjN0MndmnPjjCgzC6Hriw3OLNBcatQBmjaH+zAoWAa6uL3pO9NwbnBHxWmpyENhTORZTlr7qWAI7lCBtbTSfcWk1HYdH25Zg25QEGvLVuLW6EgkJt8ySD+ny565fhHugIhJKeEm7g/BtsQxkgyiqamv1Z8WGUjWvcT0QlXq07eUNfgbv2j4jz7g2jaO5nUbswWZtXTXJPURJ+WubiGxc1Hl9cAJ5+ZQsP05e4Z5zs3N01/PVHB3LlLw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by LV8PR12MB9154.namprd12.prod.outlook.com (2603:10b6:408:190::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.37; Tue, 20 Jun
 2023 12:31:07 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%7]) with mapi id 15.20.6500.031; Tue, 20 Jun 2023
 12:31:06 +0000
Date: Tue, 20 Jun 2023 09:31:04 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: "Tian, Kevin" <kevin.tian@intel.com>
Cc: Brett Creeley <brett.creeley@amd.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"yishaih@nvidia.com" <yishaih@nvidia.com>,
	"shameerali.kolothum.thodi@huawei.com" <shameerali.kolothum.thodi@huawei.com>,
	"shannon.nelson@amd.com" <shannon.nelson@amd.com>
Subject: Re: [PATCH v10 vfio 4/7] vfio/pds: Add VFIO live migration support
Message-ID: <ZJGcCF2hBGERGUBZ@nvidia.com>
References: <20230602220318.15323-1-brett.creeley@amd.com>
 <20230602220318.15323-5-brett.creeley@amd.com>
 <BN9PR11MB5276511543775B852AD1C5A88C58A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZJBONrx5LOgpTr1U@nvidia.com>
 <BN9PR11MB5276DD9E2B791EE2C06046348C5CA@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5276DD9E2B791EE2C06046348C5CA@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: BYAPR01CA0008.prod.exchangelabs.com (2603:10b6:a02:80::21)
 To LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|LV8PR12MB9154:EE_
X-MS-Office365-Filtering-Correlation-Id: 499ea8a7-efb1-4d47-fcb4-08db718a3858
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	51GXKeQCZ285CRUE7JATPAoVSc6sl9aP3QuM1n8lYOot+0t4gNgYIWt4kqrp0syzh86O+FDloGOzK5sUO89U61jH7z3I+xN7Xr3CnLr0wlLi/8UGVR0hqRHDp41EF2rpyjlVFW5x8bI+5faIPjrJIU2qJStDr9v/NwD+nlqIGQgjUPwsKym+osK+OmkRocUI2pz3I1OhE1hK17nH17cpiSzBfelkmdytuWYryNZXblA2H91Jg2NybDrSsZeoHhHH61u2BRwzvGA6AlG6lfJzAX6Y8EdCTn8eCRMTqs4cH+Cqy1tx/XG3eWpfSo53xK8EPovcMBDqh6dec45BcB2BYYVy5HznsgiKrssv2IqKBibeZQ6SZIQ4+xRQWRm0iswT4CI2Cin/o/poSXWpKqbD4LCq8cjs2W1He5Zpi/o0cs4bWAd0ic+f0BnaQa4OEBjNt2F4C4Uhj5LfCl1ChmsMKysAlbF4a000VncdI2U2HKbljWytHTlz/LoL4NqGe9T6GDS4AMP8WCvhqixDntUrxZfQFIGqY9WlYckigA0MmJ0ggu39UkddtYMik3BKDdFW
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(396003)(366004)(39860400002)(136003)(376002)(451199021)(66946007)(8676002)(8936002)(66556008)(66476007)(26005)(186003)(6506007)(6512007)(36756003)(41300700001)(38100700002)(5660300002)(6916009)(4326008)(316002)(54906003)(66899021)(2616005)(6486002)(478600001)(2906002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Mk3Rl76koQS6S8DLJtkGlV32FRbMaAyzrpzrTapi7K5NTnDHdS//jd/JOJtb?=
 =?us-ascii?Q?Y8lh3TZ2Q5WmLdR196tjThE4+bq7f/b+Eexu2aH/Ca5CQhikYl1ALzdullMx?=
 =?us-ascii?Q?HDZEQ+QcdJF75w9L3dBZjz/6BQOaz5fnVbY/QFCZv3yBTkO1gCzmMFgkz2zC?=
 =?us-ascii?Q?dWAZHMCvb+0Fh25pq6Shr9kd9+8bQqmFxpBHH91zPdjqn0M2dSNa3n8AYPsf?=
 =?us-ascii?Q?pLsaIKthnvqih/JHIiVF0lDiq/FzpquNtFEqHbHvWSsWpbZKw4ZmB2ERVEH8?=
 =?us-ascii?Q?MbWhUa5WqxmMYgClPktZLvz54shEoy+c9bbZUqleLHhgMEhO11uKN8/LbE0R?=
 =?us-ascii?Q?GiQmtzb2hw9sjgxG2q94zJ5IyP0LEZkmgadSY82awIKSjXR2U9gkjrLQ/J6y?=
 =?us-ascii?Q?epnU0IaZQ6G4rN13XQnK27VEe1Owf899Q7ehmZG2sinDNL7U+UqjS9pbfV7i?=
 =?us-ascii?Q?kqlzx3gTWpkODbT/0yJMDsy5tgPQ/l22NZo3iB/YS+dHAk/lU5beeNMOyeLV?=
 =?us-ascii?Q?6pVNn2mBXFvtUX184B+nxCIyc8RaBkWEwfRb/nDrz9i3Uo7my5Kszy0J1QCl?=
 =?us-ascii?Q?VOgy/kJWeFtjce4QB8oTuXOamL/22rVDk+82jDRGCNzk4evF7IjxeDJVkcM1?=
 =?us-ascii?Q?19tyE66p9IlL5uFlFOjfKAEmagLOo4ZTCPoe9blqydkHr6uHQmprNhCJ1Wu2?=
 =?us-ascii?Q?yeEB8BMh4PoEhZB/JtulfjHc5thqL+Xqm5Tm+jVx754LtQTfXuGAH5596MBo?=
 =?us-ascii?Q?Q6XuE6wKNpB1J53Z5EYuHVXki0RmtJE8Apbw2TLabRQHDf9ezWYpBgyj3j8I?=
 =?us-ascii?Q?cUNtSsfKmEzXU19ltJezloUqXarxVkRaCGjzJLpSzOF+CRRUSEyjPGed//kK?=
 =?us-ascii?Q?S54oWSSfh2BJxztkY6O3S4dPh1pBqZw3W4sjJo1kPzBa6U1/WTJjqvqMS65j?=
 =?us-ascii?Q?CxZtjVDPKMyBWwqHG4CTnqc3NHOd8g3Zn8haEaT/aSviFK2+jLGezBtqaLvi?=
 =?us-ascii?Q?c4bXCGJP4GWwgsMu1RvmDquTbBKmM6UGTOZQo8AASUaWJd+XwOlrJNI8F/3Z?=
 =?us-ascii?Q?FDw+uyFzGxB20nyuRIHkEaFLxFaVAbPoJpEaj73vV1cq64NlGSvT3Fgf1xBp?=
 =?us-ascii?Q?H3SvI/dco3pQxftl+vfGSbazNSAzZuIpj8cb5PHCxOWDiYl7Xl6y6QFRFwAW?=
 =?us-ascii?Q?rDbrag7BOI1GGpVdcZ2JcsD87is3wtMypj4ZRsf23+uwnHktW5C2c3LMdxaw?=
 =?us-ascii?Q?SmE6h8QIjaWcYRkZLNCg7H1J1Oc5meK+LquAIdC8yCEmYU4aBY2rpmZKvcJO?=
 =?us-ascii?Q?ImJJCW2ensboYfLtOSkG/fixesbzte6DdXuDwS5icSgCN5Yhz5Sa5LMRrCvo?=
 =?us-ascii?Q?f+DNGKw6K/hoFVv92f6wbruQe1kZqgdmStMGPjpEzjka9BDPJlDlN3B7YDlT?=
 =?us-ascii?Q?m2oHv04YDzrHrlR6YP4qp8AriReOxJShmcolyRbbRj4N+Fu8Tadw45FLVaGN?=
 =?us-ascii?Q?ux1XxXxj6pz74Ae2QuDTrC8bRq5CFDa1vbcHgyQGh3Fh1It3Zu+wp82qy/hx?=
 =?us-ascii?Q?Sp01Fg/rSbtd/CztSDUHGkz2xEwX0BJGUwLV0oR+?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 499ea8a7-efb1-4d47-fcb4-08db718a3858
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2023 12:31:06.8954
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RCXcF3whzU7u2d9pS8Y32ZvlyStIq1rLBD5pvtViamMxQgw/aLh9vEkZAW5SNwrc
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9154
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Jun 20, 2023 at 02:02:44AM +0000, Tian, Kevin wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Monday, June 19, 2023 8:47 PM
> > 
> > On Fri, Jun 16, 2023 at 08:06:21AM +0000, Tian, Kevin wrote:
> > 
> > > Ideally the VMM has an estimation how long a VM can be paused based on
> > > SLA, to-be-migrated state size, available network bandwidth, etc. and that
> > > hint should be passed to the kernel so any state transition which may
> > violate
> > > that expectation can fail quickly to break the migration process and put the
> > > VM back to the running state.
> > >
> > > Jason/Shameer, is there similar concern in mlx/hisilicon drivers?
> > 
> > It is handled through the vfio_device_feature_mig_data_size mechanism..
> 
> that is only for estimation of copied data.
> 
> IMHO the stop time when the VM is paused includes both the time of
> stopping the device and the time of migrating the VM state.
> 
> For a software-emulated device the time of stopping the device is negligible.
> 
> But certainly for assigned device the worst-case hard-coded 5s timeout as
> done in this patch will kill whatever reasonable 'VM dead time' SLA (usually
> in milliseconds) which CSPs try to meet purely based on the size of copied
> data.

There is not alot that can be done here, the stop time cannot be
predicted in advance on these devices - the system relies on the
device having a reasonable time window.

> Wouldn't a user-specified stop-device timeout be required to at least allow
> breaking migration early according to the desired SLA?

Not really, the device is going to still execute the stop regardless
of the timeout, and when it does the VM will be broken.

With a FW approach like this it is pretty stuck, we need the FW to
remain in sync as the highest priority.

> > We want new devices to get their architecture right, they need to
> > support P2P. Didn't we talk about this already and Brett was going to
> > fix it?
> 
> Looks it's not fixed since RUNNING_P2P->STOP is a nop in this patch.

That could be OK, it needs a comment explaining why it is OK

Jason

