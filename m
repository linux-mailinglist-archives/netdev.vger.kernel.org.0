Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6145442FCAF
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 22:00:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242918AbhJOUBs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 16:01:48 -0400
Received: from mail-co1nam11on2055.outbound.protection.outlook.com ([40.107.220.55]:3494
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S242867AbhJOUBq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Oct 2021 16:01:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Osnn38fcwXdf0cv8/9mNvA+VNtbSJSXc+5csa6blk0TCZ3Au3g1GZWXKHrQe4evk7q+RbG+rqYBqGPJ0S+CR3fs4qIBn62U4yLPE3iS/6s+AFz9Yf1B4zCs8u/c8xVGLsQlfP7VA+tdsYIfSyl/IcXFAW3YOHnh1yKBiT+v4fyzBmFcyIUnVjWSL/LjwuW557DfTvqCNj6GgnYBbiu8ybJAaa/dOuj667WmNxdNHHoVnsChVEQDGVnlxmx89ModOoQiAN/NslX2A7ercqKiikLTBEzlxs7sSG2a5m6Q+o6f/HljG3aUxxtKcD6kd/FdAf0Q9Tm9p55MQ7fjWohmUOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lCHo0Mf4t7HUiemJNhHUfLAeH41+rJ8ovFq84qdtxfk=;
 b=edum6S2+MrAzyQ6yyEvciuTVUmXLGCRSWDX7/aCQ06lTmyMjmoZDyXB7mxnm1M/Zo/7/djJDO8hE/xn9PFCjDwjakPlYsmM3LL6upCw5rbtYtdpZNF9LMZcLQsPAMRQxKtxhWFr17Cw+jn6kSSdqmUHowOqDatNiynJeireApiN7uU9E80hh1FTzEIK28JfGhaRRT2QP1ZW9fI0BO/uGtbsv1GFtJUooBIKp7UHBR405MryLZyjwKGDAcDQQgNtWjn7kQ8a/MLvss8ThhoLO4kCZRYW3w9q533io2Dn0f2ZgFiNQOklRWlETEiGPkIa2hXwag1+j3yPhX37y4Hyk6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lCHo0Mf4t7HUiemJNhHUfLAeH41+rJ8ovFq84qdtxfk=;
 b=W8t3BhYu8RNFu45WOpXrBa+/WwzdWaxdFoQObXc2FdzV920xuUl5xrATU/K3irjCVyTGPh6w+EbPE2HiQtplyI3Sx4BYODBkMt7epHNrbRjy4+DYBzgi7SXpWCS7czPzoEXQikqL0s9kpourpJC6KivC7fFisWFac/vUZU1zq+w0120CR9n+oJ7jYTSQHahgi0kUb7ntvkvj7vE9Jjs3+qZCl7E3ExGrd2rsDBmex6rU8OC73F7kl/gQ/5WHT116YdFxNAZUQM0t/+c0oROITJnVqz+5QI4/9NQThXKjiA2mV5P+OumAzhIwDZiTPhMVL719Nm3trIOZsXoMg5FIGQ==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5363.namprd12.prod.outlook.com (2603:10b6:208:317::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.17; Fri, 15 Oct
 2021 19:59:38 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%6]) with mapi id 15.20.4608.017; Fri, 15 Oct 2021
 19:59:38 +0000
Date:   Fri, 15 Oct 2021 16:59:37 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>, bhelgaas@google.com,
        saeedm@nvidia.com, linux-pci@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, kuba@kernel.org, leonro@nvidia.com,
        kwankhede@nvidia.com, mgurtovoy@nvidia.com, maorg@nvidia.com
Subject: Re: [PATCH V1 mlx5-next 11/13] vfio/mlx5: Implement vfio_pci driver
 for mlx5 devices
Message-ID: <20211015195937.GF2744544@nvidia.com>
References: <20211013094707.163054-1-yishaih@nvidia.com>
 <20211013094707.163054-12-yishaih@nvidia.com>
 <20211015134820.603c45d0.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211015134820.603c45d0.alex.williamson@redhat.com>
X-ClientProxiedBy: BL1P223CA0017.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:208:2c4::22) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by BL1P223CA0017.NAMP223.PROD.OUTLOOK.COM (2603:10b6:208:2c4::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15 via Frontend Transport; Fri, 15 Oct 2021 19:59:38 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mbTMf-00FTJe-7p; Fri, 15 Oct 2021 16:59:37 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 25cdc98c-1dfa-40e5-157e-08d99016517a
X-MS-TrafficTypeDiagnostic: BL1PR12MB5363:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB536364ACA786DCD5A78D0053C2B99@BL1PR12MB5363.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cE33LyU5kpVk3TXJVYMuVsLvCmu0xVpjJvSwDyUpQwzPVMIbvzntlx48AT1qBP2ChTv1G0CdI0K0QBljgktHtvRpVtRtlZQFYfU87XG7vWqrakvQG7SHGpKp7Dkj7BxGtNzD8Ru2E53fhE/t7bHvHw8ldVdcY1I2U7N+G1R3j1AJ+0ymgKYX+X8ixg3QH+8vzgxCp7skZOWr7c11VYSdNYF/7AXplaekgLsMHoHxdrG4rRJ6o7H54TM4nLwHUCfb8dK92051r951qKemQ5hkHIhdwU5w8SSps+y7KTKQAr0U62vj+9mb3BXMnNQh2wtP1raGuNJC5xRqss1al/hhewQjIqLBxcPWLRV7HsaziOB82n8Hr7ddCU4dkSMOLUyBRtHCsxgVXujQh989AUkm2/k7U27G5FU6i/sWh5yA/S+CIXcj1Bcp2VFNBd1RTP/u5NQc0JQrx0DsDru8/28hT+AX4I6KEh0topnizqC3H7ymIpc0lDW/4sTtKa8OM8ApaJSuZDsuv7AF1vrnmyUKGkoOBCZC+1vV01Bk8ifbjESSAvDDvhlWvXWEvxQ/0aNUmxsR9fSYHb58AeOlaN0uFWuRYDD/AyjXM9ekunjAcxEEVe17vRR9ypNGl+/xU0JYNWs1sblKX5NRoLHQbXUx6A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(38100700002)(186003)(8676002)(26005)(86362001)(107886003)(9786002)(2906002)(9746002)(36756003)(5660300002)(66476007)(4326008)(2616005)(66946007)(66556008)(8936002)(316002)(6916009)(1076003)(508600001)(426003)(33656002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?o32JoXDfV9SWsJEtqs/mJWorXzCPL4hth8cu8DbrTI91r8nPEYg9wK5TKs0M?=
 =?us-ascii?Q?ZAU0C/+9wcXOzve4uSMUgQX8wSbfeEVV8nG25C6QIUQsH7AhtfJxElPbCsgw?=
 =?us-ascii?Q?zGD/S0ce3GbLH8mWHspvJHMMTOgUP3pallU9UvMb/e3W21SMnmvaGsO1wmxT?=
 =?us-ascii?Q?QWke811HsRTOIzfR7urZfDhbFlmkuf0YTYe72nF3iiZ1Dh+vVmMWXw0MW0gm?=
 =?us-ascii?Q?JsIsNambH25XhlNSfmV+nBHpgtXoEPtHzmi+CUc4mxR2+n6zHVZyAmKXm9j7?=
 =?us-ascii?Q?IS23pjifKne10KfRUQzixQ18fff9V3hJA5ZTcu4jmncFG6FmctlwbAKruKgB?=
 =?us-ascii?Q?QdKC9OgAguZloyOc/Ie+qaPB8W01Oz3o1h7jFUEzC/6e86ijGGUV8dP28aCz?=
 =?us-ascii?Q?AE/QibRqDEUVAfFnoCWzEEztylPvwLU/JMpXJpl3xwIkNPEjrTgMj5ys/ecK?=
 =?us-ascii?Q?xR1FPxMhcldAxukq27ZEfbf+PVFrR5uI6DuUAWU4g8qIsUWva1plxeqXvVJ1?=
 =?us-ascii?Q?Q8/ti60IEQ2UCz6qmWRERvlQP/LmkRzcZdCwGEuStxYW0FgjlgUW7Zsgy7Ty?=
 =?us-ascii?Q?/45AFc9SkmCiBoMmWtzzTezNLD9q97iMjulpO1mssf/yXTsMu19oM5WgnFEu?=
 =?us-ascii?Q?NKbmqhFD0A33z0s46EAM6jzFZVOYiU9jvXFayeqVdT3p+nVS0w9zxZaDWe9G?=
 =?us-ascii?Q?Ao/6C0FdQkHXy7hfGNXhfB5oTi6rRf+uIpkj3ldNLRVxiXpdmWIE0Bxm1TVN?=
 =?us-ascii?Q?0wUEhQR20DNDheoMPIy2ARdXlmGolTKJi/2XQPYsdQ9d7k/UCsp9PKZakY4+?=
 =?us-ascii?Q?IDG0/Yr+YQBjP0unTJsxqhBEN6vs0CQg2Yv0jeXgYWepJ69WQVEvldjtxCjI?=
 =?us-ascii?Q?VfiNwlNE8jvrtC0tEfjO0QEl2NPkIKSbkylaI/LklCA7nDWq9eiLp9BjQDh2?=
 =?us-ascii?Q?LnR35HEuodi9qQLP5s85xxoKRwrlxYsN2xjy7SkcM3Qdl4Oe4KyEGQyJ0L4S?=
 =?us-ascii?Q?QkPO+a5S83NZx6r+LuI1bBV9vXKePZJzwRSrghLyrTrt2YDfV/64n6ktj4o0?=
 =?us-ascii?Q?yfib9nQZgdEPbF8/7S9xGDgcS5GXyKm4ou6uBgC+5Hk2Z8CUA7vDQDIskTWT?=
 =?us-ascii?Q?s7JKgnCFgdHECak2kMe3QPIRcZsbjbAMR8L98RRUoTh/MeN+FRzvzNRc3N/L?=
 =?us-ascii?Q?12fSYVI1QGuX49PgoJAjgAL9ghFx+BwjSIdh3oE/fcWQP9Pp2R57ehjMemfj?=
 =?us-ascii?Q?mMgqijGaRTgB9mDQaBNvQ8R3Qgr2i/NQJoCdzOw4cPu+/IlflbfLwJrAGC0p?=
 =?us-ascii?Q?INgqINwoiirVRU5Cva3mS8rF?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 25cdc98c-1dfa-40e5-157e-08d99016517a
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2021 19:59:38.2780
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gBg5FBEtYcS88+L67pmJ9d47kzjtRiiV7Bu2wUqu9IrB15h7/gdPWCV/wYJcVkM3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5363
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 15, 2021 at 01:48:20PM -0600, Alex Williamson wrote:
> > +static int mlx5vf_pci_set_device_state(struct mlx5vf_pci_core_device *mvdev,
> > +				       u32 state)
> > +{
> > +	struct mlx5vf_pci_migration_info *vmig = &mvdev->vmig;
> > +	u32 old_state = vmig->vfio_dev_state;
> > +	int ret = 0;
> > +
> > +	if (vfio_is_state_invalid(state) || vfio_is_state_invalid(old_state))
> > +		return -EINVAL;
> 
> if (!VFIO_DEVICE_STATE_VALID(old_state) || !VFIO_DEVICE_STATE_VALID(state))

AFAICT this macro doesn't do what is needed, eg

VFIO_DEVICE_STATE_VALID(0xF000) == true

What Yishai implemented is at least functionally correct - states this
driver does not support are rejected.

> > +	/* Running switches off */
> > +	if ((old_state & VFIO_DEVICE_STATE_RUNNING) !=
> > +	    (state & VFIO_DEVICE_STATE_RUNNING) &&
> 
> ((old_state ^ state) & VFIO_DEVICE_STATE_RUNNING) ?

It is not functionally the same, xor only tells if the bit changed, it
doesn't tell what the current value is, and this needs to know that it
changed to 1

> > +	    (old_state & VFIO_DEVICE_STATE_RUNNING)) {
> > +		ret = mlx5vf_pci_quiesce_device(mvdev);
> > +		if (ret)
> > +			return ret;
> > +		ret = mlx5vf_pci_freeze_device(mvdev);
> > +		if (ret) {
> > +			vmig->vfio_dev_state = VFIO_DEVICE_STATE_INVALID;
> 
> 
> No, the invalid states are specifically unreachable, the uAPI defines
> the error state for this purpose.

Indeed

> The states noted as invalid in the
> uAPI should be considered reserved at this point.  If only there was a
> macro to set an error state... ;)

It should just assign a constant value, there is only one error state.

Jason
