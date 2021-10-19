Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD86643349B
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 13:24:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235166AbhJSL0h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 07:26:37 -0400
Received: from mail-bn8nam11on2072.outbound.protection.outlook.com ([40.107.236.72]:60833
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230097AbhJSL0g (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Oct 2021 07:26:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WlcccycrLFfDbVsUNq8T+tTYbvKStZdNQrEyW13cmRyz8FT20GtOQehpdHQLd5RPVOltWzbD5ub/Eqj0xv/MiaqGNZPdnWSzsRrlTmcSdiuFa5tkuCmsoeqflo1c5WXyieW5SJJrzNWf19Ns+WHVP0iGYY4pKTokZolRgDo/ifOP+mDRX1srf1nMjyMsl5i8MZ8lkjzyiOs8hFI9k5KIn1+jM86MVluN7rNNYK5sqnqKS9yi0xiAHivmUK7+GB+HVDnf+ScoLLsBKPEdWBZkXhHvR74jHPru6jEEDRBlXxF+REQqlDBZO3T6dTI2wHtvkwTJJkxnbaX79md40Ununw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rVMmlKfGG07jo5aGkWrfnD8iqW6Zmrwbz14refnX0vs=;
 b=Rg8C8erv3BOzwZH4hOfN1W3nPBdx+w4TrLD0HFtmh6vgsiV9sOefBrxXiIbEdqCbshrr4u7jiiLwGZhhNf0Rh2iYPmfrotYZ9LvaeVmQy1DRwNXoQNDDNp316H94J4uMDejJRx5GvEAth/6DOyrZRWD/27PWexMsyNhgvJtgjv4+R+Nc5VBQNOXpsGi8vffRzMmSFkV4++yeQKoRzzErdW07Dik56etRPNM8pQSN/A0m0PNNqeblU7wuhbirRNqv/KjmnF0A0LRudQPg0haKtmt4c2Li9MsgVKaskps5uIiBA9IIXwTt01AtR1cRwCBywXtgMoKI4aAOyAZlDm925A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rVMmlKfGG07jo5aGkWrfnD8iqW6Zmrwbz14refnX0vs=;
 b=Tz3O42DOOBiSCCvarrF3sKPdHlZt+4/d65y0/AyT4BSX71QyJygBND3+xfs8bOXdmrZR38DaIBKOHd8Rd0D99Gp2Ow/m8XNhi0h6gG59osaVNeoxDIc+MOdo0guuAG725mugoPtJuGN6s1Brrd7HBGQaKVyTetsNqkRadiLkOVIDyIhYY7Hy++f6rNM8Ph7byqr4NR+VQFrcEcXbyRjuOYNTbbdqreGTLu5Oae3AFykVFi2wk4VfLIXYY24bYU1tsg8PeQa1xRbYTSTbMzBLd/1eQsKRbVoskHdwb8oS1JRRE0j229rqSS9p7QgRe9/8rqqcINM7hnoD7meANODRXQ==
Authentication-Results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5206.namprd12.prod.outlook.com (2603:10b6:208:31c::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16; Tue, 19 Oct
 2021 11:24:22 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%8]) with mapi id 15.20.4628.015; Tue, 19 Oct 2021
 11:24:22 +0000
Date:   Tue, 19 Oct 2021 08:24:20 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "saeedm@nvidia.com" <saeedm@nvidia.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "leonro@nvidia.com" <leonro@nvidia.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "mgurtovoy@nvidia.com" <mgurtovoy@nvidia.com>,
        "maorg@nvidia.com" <maorg@nvidia.com>
Subject: Re: [PATCH V1 mlx5-next 11/13] vfio/mlx5: Implement vfio_pci driver
 for mlx5 devices
Message-ID: <20211019112420.GR2744544@nvidia.com>
References: <20211013094707.163054-1-yishaih@nvidia.com>
 <20211013094707.163054-12-yishaih@nvidia.com>
 <ed08f3350c594a63982856434d19d728@huawei.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ed08f3350c594a63982856434d19d728@huawei.com>
X-ClientProxiedBy: MN2PR12CA0020.namprd12.prod.outlook.com
 (2603:10b6:208:a8::33) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by MN2PR12CA0020.namprd12.prod.outlook.com (2603:10b6:208:a8::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.18 via Frontend Transport; Tue, 19 Oct 2021 11:24:21 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mcnEC-00GfpT-QE; Tue, 19 Oct 2021 08:24:20 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 87ef3b23-a876-4776-9f7c-08d992f2ffad
X-MS-TrafficTypeDiagnostic: BL1PR12MB5206:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB52061E4246912D381DA15E33C2BD9@BL1PR12MB5206.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bjlLldjQxzMaBbJ0e5ij/uY21JWqM3DRFEn91c4wc+tQt4CYCWEntoqxpwpcKyZffuev9Fo6dNyY5sINfJpMa42ioA0f3owBV87TrbZgqSXzdxJryofk/X5s5+x30cidRFusSu+Vf8oyNxASdVHj5b6KJ7+/4gEX30VOTsbOc3wmEwN50Jh3n3IjDB5s88+mO7tTUTfJIeETsGCFJKLaVD8CPUseq2UGmtfRZTm2XVEpJWoMPMWnU7RFY32nabdwLSMz8SRZc5dodX6uGKpsDgEYXwjGnZnzWFHjmEPPC6xUwNHLyWgrynoU9+wbK7YekZOO4xRvCPFyBhXldmWE3wiDtaOe64rzCy4XP2jJ7m/PER56mTXuy8JiKLs2WRUKPCBCnbcvULeNGf5IYFt1WV2uryFubFtNaZWv/4V6QnvdW/YDImrPIqmXRwfYAZmeF5QcLn0BjvtWsvubjcg/26ppmbQ0E6+g86BRJ9QbYdQmYoBHkgUm/1lfIPTvZsRZ2MRTWT9NMr6zz0uyPEpkwUHAuP1JuehfQ/Nj2eQqbjjcqaXy15kn6WN/wUpRdOAMjlmRORBW8DEeIKtKoNUPtemJk5YzqNktgehoeWmWLOTIyYRdvCGdEWmIIUmRowDQshu6Wcx11HyTpc3KYUyvjg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(5660300002)(33656002)(2906002)(6916009)(9746002)(9786002)(107886003)(508600001)(8936002)(86362001)(4326008)(8676002)(66946007)(38100700002)(26005)(66556008)(36756003)(54906003)(66476007)(316002)(426003)(1076003)(186003)(4744005)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yhT1gMwMf7kK5p+1GP8oP4iu3ASPzNeMCjYPs0tp6dnh2oQhjtNaa11D13yu?=
 =?us-ascii?Q?txz32w0CsTb4ziPIrcLc2ZGoHGRwPMDVZf6Hgr9bl7tGLAOnthO3nT2em/FG?=
 =?us-ascii?Q?d3nY9G5/l/qESGE+zpwzzV1lIJ21R3+fMtPnP0DuHlb5v9pDHSCXHvv5rrNG?=
 =?us-ascii?Q?6Sk3hbSwg44/PrlILnZBieVB7SMFMUNECuBz6lO88fJGRWmFqdvlqZ33nmRL?=
 =?us-ascii?Q?td1S7PFLbjvaSVNrwxM09+OkLVIP23gVaVdrn+sZbH1aO2dgbJW8uHHEqAmA?=
 =?us-ascii?Q?gEy2IzvTX5qYvXhNrcZyZ6wUw39XQ/1Qn8gQ2ZFOaDmP3JTB6GheupRcujJr?=
 =?us-ascii?Q?SlhzbpIJJoD3K0sipSwMVqN6gxkgDu1ZXGPZ3bZVxCDQgx6ME3LX8r/8tKvU?=
 =?us-ascii?Q?3vRnJ2WFFIodn6LrhuT/65RTmz0UC8V4nUutzXc9WpOxyhpWa/aAe3t3Utgq?=
 =?us-ascii?Q?zTpjJq/z1FPH+0K1s1AYdN2bGHvhC7SicQfWolMAwxXuVnQyvcdJneVnZ3H5?=
 =?us-ascii?Q?fL5LpNEo4eDiJOQ2JXi4EIZhF83Tjosi/A2sNUR2T8s2Rrcbmlgv/qwzA6Rx?=
 =?us-ascii?Q?j+0241bWRzA+55zixZTHGu9yCO6bWbp1o7MChvFM4ysRU1H7FlHC4Wj7bovH?=
 =?us-ascii?Q?ZcB+pUU6CPFhAW2nWLo84rmn9K5RQTFv3LKtBWQ83EUkAiOpMZKnhDmSqSFP?=
 =?us-ascii?Q?CY0PbrBxvIZTslC5Q/AWMdu+MCUyduArVGtqwctTOVvB9V8/mO3fnWK+miyz?=
 =?us-ascii?Q?ssUuw88OsgotOF/CaBiarECfrmGjKHM3/3douS0T2vzefgAduaGW8LGfjmCO?=
 =?us-ascii?Q?kb7fK91ieD3ZxKFFRRz7GBh+RDQEGvSbiwrvF5Y/5oFHD7VuI/rMvTT3t9Od?=
 =?us-ascii?Q?abApNbc2p+RWYqr2O8B3JEQiCW8N/zHxqSQYCCicdF2x5dci3mZ7GpFUh10n?=
 =?us-ascii?Q?ullAYKaCRSwqukSsicNGKImDnX+PQDKGQQNLDEWAqx7omwYnzlMS0fezk42R?=
 =?us-ascii?Q?c1Vp3lpggwNPK2DSrUkNg7X15z86LLN7txozzVDPXGpwLXBQzkl2m3kLQsTE?=
 =?us-ascii?Q?blDpBXGyF2rwodvkb6D3DdJxRx/OIesE1uMN9eYOma7cznZDCtRbhKvltHqd?=
 =?us-ascii?Q?FM9w7NKLl1Aez254/faTaCWJtNqQ+JTjDt6HmI+03NzdBHLvjaSj3DuAU5fw?=
 =?us-ascii?Q?bsOYKaXTOgQt0+OSUmySKhc/0DIcfduJUEnze5r76EZAZy1sci9nv1qCS4F6?=
 =?us-ascii?Q?s/SR5qZWI9hF25X7Et561Qzdw9A+DJGLTU9/Ptjq5IOS2C6RONXRnUEBSeMK?=
 =?us-ascii?Q?kvj5cIsj6YClGTXDST5kWge4?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87ef3b23-a876-4776-9f7c-08d992f2ffad
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2021 11:24:22.0070
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jkmrS6CEEPRb+C73toDXr6JWoxeS3R6edXK/j44DhqHHWRO7bnuQ/XqPSA23A4iC
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5206
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 19, 2021 at 09:59:03AM +0000, Shameerali Kolothum Thodi wrote:

> > +	/* Saving switches on */
> > +	if ((old_state & VFIO_DEVICE_STATE_SAVING) !=
> > +	    (state & VFIO_DEVICE_STATE_SAVING) &&
> > +	    (state & VFIO_DEVICE_STATE_SAVING)) {
> > +		if (!(state & VFIO_DEVICE_STATE_RUNNING)) {
> > +			/* serialize post copy */
> > +			ret = mlx5vf_pci_save_device_data(mvdev);
> 
> Does it actually get into post-copy here? The pre-copy state(old_state) 
> has the _SAVING bit set already and post-copy state( new state) also
> has _SAVING set. It looks like we need to handle the post copy in the above
> "Running switches off" and check for (state & _SAVING). 

Right, if statements cannot be nested like this. Probably like this:

if ((new_state ^ old_state) & (VFIO_DEVICE_STATE_SAVING|VFIO_DEVICE_STATE_RUNNING) !=
    (new_state & (VFIO_DEVICE_STATE_SAVING|VFIO_DEVICE_STATE_RUNNING)) == (VFIO_DEVICE_STATE_SAVING)

Jason
