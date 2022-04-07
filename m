Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C7A04F8424
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 17:52:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345224AbiDGPyw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 11:54:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345207AbiDGPyu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 11:54:50 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2060.outbound.protection.outlook.com [40.107.93.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BFEEC3375;
        Thu,  7 Apr 2022 08:52:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OfUDM2RxKY0pXaGRng6kPcekLViIfXX9iS0Vlvrx5E+TsJ3kPTJgL053tNac/SCkNsPVzoucGkkw/pckM7dRbh0MM0bqtsZ1dO1c6ylzIAvnDoAxijkm0sR93GSXAPZqsQWNMiV9gH0JyiYLS9Sw8pF+PXRMm7T7L+338kqUKa2eh3weUA6y4briVJSXZt6A52MIINPxyDnhhzibumiMVyNYMjA4czsYOCLnr79PkmCn86hAuRTyukl5s8Kk5hS3Xjd5cOjw4W0vP0SEApZfLGTxRb/bxS7KiAfxI/gqHS+jx85m/8Ol7poBVe3tkX+eOD/DkoN7DNR7AbBauypcag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+HnZ82/SYL5JJesvmlRnfH1R5Mccy5lOOTR8yukQr+Q=;
 b=NNipFAntaCAORWhEHvdz6UiztFN3wFyyAlFejpdi9FNKNEh4m9PwAkO2XuiE2HJF9Z2EU5vY1X7qRO6DqxgK2HxbuPBwHKULNk8lw4sGrXhd4/p5yk2JEif9iTFyHqJ2TgMgzv5YywNLN1rMgIbEE5FpanKRowV6QNN6x1eigkOb1ywL+6e+ygaugw/Ok/Sri1nVJfnJyMEzYS9amkJq4PyaxPQkjJs9Mc6E9uKSIH4YtpkgyM+csYrS/S2oNoJrT1WZ0hWvl+UI/slgDKv9t/mPhDGU8kzm2n4sH71/V04L4dbWkpWkWoK55NI6tOdSDTjxjCsHZGRs+jZDt+yLEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+HnZ82/SYL5JJesvmlRnfH1R5Mccy5lOOTR8yukQr+Q=;
 b=LKSfNpyuWi2bR2fo3DV+CUC40B6Qwm4fVPWj7WaM8zj4BkJiI4jCLrChxceVoVgabbgWrT+UQ4fq7bJFYT0Em+/HeazgqLpowN+EMRBA+8McTwxOIpMBAOmmyaaEe1fS4ayZFHvlJvVX22tz0o9DRD7fGIh2HHj+LZAbglWCbmMmWPIgALxCHht+QtVJxmA4MAvSzLGvuYAUO0sJuOwxGbC1OHwMclgOhlX76UYRbv4CRHXaTNFrtgWyujYSOls7sWo6kVvD5B4zTU7ZGzBrOLl1ES8+IonkQv9zmaVgtdLKxNf6h1C7qjTQ8RPCP4D8U3rh+K+aVX7NVTY++UB+Vg==
Received: from MN2PR12MB2912.namprd12.prod.outlook.com (2603:10b6:208:ac::18)
 by PH7PR12MB5759.namprd12.prod.outlook.com (2603:10b6:510:1d2::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.19; Thu, 7 Apr
 2022 15:52:47 +0000
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by MN2PR12MB2912.namprd12.prod.outlook.com (2603:10b6:208:ac::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.22; Thu, 7 Apr
 2022 15:52:46 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::cdfb:f88e:410b:9374]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::cdfb:f88e:410b:9374%6]) with mapi id 15.20.5144.022; Thu, 7 Apr 2022
 15:52:46 +0000
Date:   Thu, 7 Apr 2022 12:52:44 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     Ariel Elior <aelior@marvell.com>, Anna Schumaker <anna@kernel.org>,
        Jens Axboe <axboe@fb.com>,
        Christian Benvenuti <benve@cisco.com>,
        Potnuri Bharat Teja <bharat@chelsio.com>,
        Bernard Metzler <bmt@zurich.ibm.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Christoph Hellwig <hch@lst.de>,
        Keith Busch <kbusch@kernel.org>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Leon Romanovsky <leon@kernel.org>, linux-cifs@vger.kernel.org,
        linux-nfs@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-rdma@vger.kernel.org, Max Gurtovoy <mgurtovoy@nvidia.com>,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        Michal Kalderon <mkalderon@marvell.com>,
        Mustafa Ismail <mustafa.ismail@intel.com>,
        Nelson Escobar <neescoba@cisco.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>, rds-devel@oss.oracle.com,
        Sagi Grimberg <sagi@grimberg.me>,
        samba-technical@lists.samba.org,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        Selvin Xavier <selvin.xavier@broadcom.com>,
        Steve French <sfrench@samba.org>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        target-devel@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Zhu Yanjun <zyjzyj2000@gmail.com>
Subject: Re: [PATCH v2] RDMA: Split kernel-only global device caps from
 uverbs device caps
Message-ID: <20220407155244.GP2120790@nvidia.com>
References: <0-v2-22c19e565eef+139a-kern_caps_jgg@nvidia.com>
 <ca06d463-cf68-4b6f-8432-a86e34398bf0@acm.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ca06d463-cf68-4b6f-8432-a86e34398bf0@acm.org>
X-ClientProxiedBy: YT1PR01CA0074.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2d::13) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 65705c3e-10e6-4c83-0dcf-08da18aea8b3
X-MS-TrafficTypeDiagnostic: MN2PR12MB2912:EE_|PH7PR12MB5759:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB2912F93D4E64FA51A844C8A7C2E69@MN2PR12MB2912.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qcw2fGjqwo44TFG01Cu8xfQT8Gr4BLthVfkgs7rxLCGoPDL+COG+ABMAkO29a3ddEdHX14VDBLOlhMFuOvhEXu/DUjURRKS0GH2FIDRmyOZF6CG2SAf150XJmTL5fC2qFFGY0h7yh1mnupcXYokfpkI43g0F2EwdpKmr3DS+3anfHPBesGt7KoqkzVqwuHMrCovfMyC/T1FrPt78PUXh5ZqtE0s/ThoOOOqNE5MgMmrUr46Qer43uifG1QItF8Z31D5x5CWZkSuFi53ym3t9+qXxLe21TkfKbfMklZVzwREvQuFytahmyPtvUNayfGjebzWrS3q1UbMRlcdDNxQr+1dSAmmx/KDuiCfnNhnjPMVi+8M+NEteoT4i2Tjc0QQWjVr1+zO5n1/gi0UkRRB6HcuSiMcSBAs0ICvAzPJiEaFYw7krI5Z6guuR8K+yMeB4xCjifECM9R1VYfDgbP3/gSpt/5t476Kxs9xa/4xmiC/Jc9dHjlQMyKqaAL/GacnZRHlshr01m0x41VvQ/I+C1Cupq14rincUvTl2DIylBWsMV1eIRH7Qtb0mEnvVrb4p60tr35IywTx89/4yJ69/ABH6+bQISrtXmCi8bLfRbWdPzsiiKTjwLIMj5nH5kfevlDvxgg08FnZCsjyfcDcIjw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB2912.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(316002)(66476007)(36756003)(8676002)(4326008)(66556008)(66946007)(38100700002)(54906003)(6916009)(7416002)(7406005)(2906002)(6506007)(2616005)(8936002)(6486002)(53546011)(33656002)(1076003)(86362001)(5660300002)(26005)(83380400001)(508600001)(6512007)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jI09bv31gSgc4KqoUcEtSU9MvoUjF6IkLUDA6zDqecLMlpwQ0gehDCzsZGPs?=
 =?us-ascii?Q?72bUQMr7x8T+HKsAVSNBAATIS/PeZYtvsCegyhGy47ocL10zxHnMK7LED3Hq?=
 =?us-ascii?Q?bdRif32Ra8c/tGjkgk/ORFdQUrpM+D/83BKk0GDkWKdxyRUw+bWXdC8/Ii19?=
 =?us-ascii?Q?eX7ZvLCyFpxltw0OrmbTxd6yO/GHRy4eO8sZOnENY82Jm4ll/mdn3adsOHGu?=
 =?us-ascii?Q?L3wYUvrb6a0A/MIo+eao2uigJZXkh2oH6YBQ915N2EhqhFDJoi7w6bh+thje?=
 =?us-ascii?Q?sbgFImQvHJc1mVwjnka2Fw2DqKTaatj3LRroTNKvHu5U3rbeGtN+E6R7sS7/?=
 =?us-ascii?Q?jdE8l4BycJYQa0WLRcrpId8IMnhy4/klPT2pLwzfnZLFm3tpjo0G8JqG7FGk?=
 =?us-ascii?Q?Tmt1WsLRVLtoz2j5MKPJE4YxA+D9xerq74yXXa4QuNfRoo+i1cB/F8F8cTUF?=
 =?us-ascii?Q?89Zki1E0bhpvAJhvDZj0MbSVXZOqK7fBlWf6ia5LBRW7Z00uJL3aM4vhFKX/?=
 =?us-ascii?Q?ijp7nagXJOxB4pASQhpkpA9iXEG+qn0B1j1+X84HCAeSh0RmU00qHGcZg4yv?=
 =?us-ascii?Q?DAlgoIpjxdjsfEw2CIFRRR+wfkzAoMpINrLpqyrovC+nFELnm7mmJYs7LMFj?=
 =?us-ascii?Q?raGrRBGnMt6Mfh+2mW4lRd7W7C2Rm8XR7NmrXgOIct9ZAv39Fj50CzQpOaSg?=
 =?us-ascii?Q?J76o4fsH3dO2qQUj6M89FoKjLEC9FPJSZTouDfG1j0f3TYK8zRDgEatHdtII?=
 =?us-ascii?Q?9JLmiogCXN4xwpwLcA364Xwtquxpg/ve3+kksoz/7xi+ErD5+8hmjr3cOVm1?=
 =?us-ascii?Q?jpS5v9lUeKZq+Z5sFEpCUKLdr/4n4EuYu+Fv/Cim2cu8hQ6NWQkw3X0wS3gG?=
 =?us-ascii?Q?4G3/mVuOp5BMdEY1pMG60O+N1HrOb1huXOw9W7r2N/iYR5uMU4kH2jWMSZmB?=
 =?us-ascii?Q?8EjQmunG/29gpNPWyIQGCQQqZWVTYfAZXJecnZWWQCva8BDRNPMlKqFe3u4X?=
 =?us-ascii?Q?N5PLngB2jk0UaNHNjXox8ealtlhh/+goN76c37cSh4y4AwayfUzdLOD1rYqP?=
 =?us-ascii?Q?Sgjrcs3vg9qfhu/LYbYzTs+Wj+f6MvoRek51UxHA5Lt8wTr01wMaMXezP9Uw?=
 =?us-ascii?Q?9LCbNFxkathi/zfcx74p9+P6rFNdk7LcdeJqo8XKjxlO+IuXLHP7JVszKXQI?=
 =?us-ascii?Q?2QsW10UDao1so8Uyl3eLiHc9dV9ZsUUwb03avAkTKOsfrOnf6DJlPRaOy8Dc?=
 =?us-ascii?Q?JYiAmtUazsuHbO4JGxUg+11Tk9wWF3LSmDX04ZOk0v1pNmuXtRsVZp1z9WzU?=
 =?us-ascii?Q?1FFZyiST2S64UC00FrgZkmIn/DPIRfHFo70eJvC8tdEb5+QIiaAg2emRH9Td?=
 =?us-ascii?Q?TC5vNvCfWgC1n3s+E+SR5uqwvqS/fgJqw5rdr7uRNMhXTILMvvJBIMNz8/pO?=
 =?us-ascii?Q?OPgi7REUJaMVHmeF5FBFpk+vYzNJ8s4UDRzc6wMudjy/TbU9QfJAGjzwDv8p?=
 =?us-ascii?Q?AXlr93nZ4a0bFXeMb+ly+xVaGSTYi6UY3pxJ9GY2qZXimgqxFpKvA5xCjlMe?=
 =?us-ascii?Q?8YM49a1ysARwHekn09tjnKb97biy185AE3tptQKhXk9lbbAaTo4vk2OA9Mpc?=
 =?us-ascii?Q?P1R0TYQKyN1W9KGetQRZi+d4DZVteOzgxzChgKCVXNKYZrEaGiaLFqSt0wFr?=
 =?us-ascii?Q?OIt7nLDfIbuKud5McSVCO+6bQ2PDcNaGuthg9ofJlOwAC2LBLpG1fGZC0qkb?=
 =?us-ascii?Q?HWk/qnDbAA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 65705c3e-10e6-4c83-0dcf-08da18aea8b3
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2022 15:52:46.1591
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Pt1SF2cgcMFoiBm/xHJ7SbVxDq8sdxVzU2J71OjtMS2pzA7iuxA+prJf50/dNFnB
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5759
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 06, 2022 at 12:57:31PM -0700, Bart Van Assche wrote:
> On 4/6/22 12:27, Jason Gunthorpe wrote:
> > +enum ib_kernel_cap_flags {
> > +	/*
> > +	 * This device supports a per-device lkey or stag that can be
> > +	 * used without performing a memory registration for the local
> > +	 * memory.  Note that ULPs should never check this flag, but
> > +	 * instead of use the local_dma_lkey flag in the ib_pd structure,
> > +	 * which will always contain a usable lkey.
> > +	 */
> > +	IBK_LOCAL_DMA_LKEY = 1 << 0,
> > +	/* IB_QP_CREATE_INTEGRITY_EN is supported to implement T10-PI */
> > +	IBK_INTEGRITY_HANDOVER = 1 << 1,
> > +	/* IB_ACCESS_ON_DEMAND is supported during reg_user_mr() */
> > +	IBK_ON_DEMAND_PAGING = 1 << 2,
> > +	/* IB_MR_TYPE_SG_GAPS is supported */
> > +	IBK_SG_GAPS_REG = 1 << 3,
> > +	/* Driver supports RDMA_NLDEV_CMD_DELLINK */
> > +	IBK_ALLOW_USER_UNREG = 1 << 4,
> > +
> > +	/* ipoib will use IB_QP_CREATE_BLOCK_MULTICAST_LOOPBACK */
> > +	IBK_BLOCK_MULTICAST_LOOPBACK = 1 << 5,
> > +	/* iopib will use IB_QP_CREATE_IPOIB_UD_LSO for its QPs */
> > +	IBK_UD_TSO = 1 << 6,
> > +	/* iopib will use the device ops:
> > +	 *   get_vf_config
> > +	 *   get_vf_guid
> > +	 *   get_vf_stats
> > +	 *   set_vf_guid
> > +	 *   set_vf_link_state
> > +	 */
> > +	IBK_VIRTUAL_FUNCTION = 1 << 7,
> > +	/* ipoib will use IB_QP_CREATE_NETDEV_USE for its QPs */
> > +	IBK_RDMA_NETDEV_OPA = 1 << 8,
> > +};
> 
> Has it been considered to use the kernel-doc syntax? This means moving all
> comments above "enum ib_kernel_cap_flags {".

TBH I'm not a huge fan of kdoc for how wordy it is:

 /** @IBK_RDMA_NETDEV_OPA: ipoib will use IB_QP_CREATE_NETDEV_USE for its QPs */
 IBK_RDMA_NETDEV_OPA = 1 << 8,

Is the shortest format and still a bit awkward.

Given that we don't have a proper kdoc for rdma I haven't been putting
much energy there.

If someone came with patches to make a kdoc chapter and start to
organize it nicely I could see enforcing kdoc format..

Jason
