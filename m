Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 150DC5800DB
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 16:37:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232861AbiGYOhO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 10:37:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235695AbiGYOhL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 10:37:11 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2051.outbound.protection.outlook.com [40.107.102.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57CDF17ABB;
        Mon, 25 Jul 2022 07:37:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MUehGlbkpZ1ycSVlwjQmhdOnxRSNettl996VtXaPXOIVFC2qPU9PYpM8gIC/zVMWtehHhTrcvEkqxHVv3xSjrs9upt5/+9feq055CH4DzF11UTXWlQ2a4Cm4hcb7GRUjQYORied9ztqZDmVglqljbAk+1sOzSHb2kCJWuianyggX2Z5KmHXgjFDoosfuUhlm0Zxd+7T+uXPtO1UYft+KcLWUSEPgQFXOJBBNeyZPbpv9BkhI1o4Wqs/aE1pKAxpkqfoj8NWnPdpibvRqmF2BkczRNXxZge0CxTVXGOGeEntb8wv31ITjEBBVhBLAAzWAF7hV7a02PJBKSqPArXlboA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=329IoBNhpNzFPJfLrtooZgOHPUbUnuiKBMI8vrHtd3A=;
 b=JqOhQpcszWgrKXz5FEUDXJDg4jX7DyBnzNfsRhZFK1mopZ0jZJFl5ZGDmUTm/QOpP8F8KLGpgj3MUNGPc0gxbmBt87tz6xf+6GY844RHIC0BeqwFWPyAMJVdq0+2Mf7qzmIJCc3WOBAoveNI0Cd3Z3tKBEXbKrJS3+fz6TYgc5A911NIXluKXtM1YPqvx2BIJ0Ro9yNpf/2HgTrwv520+5Pdw7l5WuVRhJkBoRHJmqlrtFv1n6qWLTPHpq40uFMmfVjxx+CXPGsVTMok+SdGAFQDz+m+uc9otZhfz+WYAb9v5Io7i1rULPtQwF9dCuJfgB/zhVlhEjNG6Ilar+Hn2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=329IoBNhpNzFPJfLrtooZgOHPUbUnuiKBMI8vrHtd3A=;
 b=s0vZnDcSEed+LgxWEchSLC1Zg+B7WhhaS89c5rxtQ4Q24U7Wfpx+cT7OsZnqE5Xb0BWXuhCIZIL73r+Ld8hMlzASN65O4wPvkmDRdSNuls9bA1CIOXPdqZ99nheVA9lZ5PwbG2Sy7yQVcPH77hhDLiO/wfnN58sh/66cgiyQyAqh7QiuR7LGsJ6Bo+VAGnET1t9xvDaOfUcZArdh2MdD8+4iC7do83zLGhuedtGb4OqN1bg5FmnImxgjyRWNOIRhPbqsWZipPkKphJZraFNIcetmlX1uoW8KwG1t9KPnTc1LwmmFVh3rPBw+TVdGmfrSt4yma4JTI0XZMllvhWV91w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by CH2PR12MB4232.namprd12.prod.outlook.com (2603:10b6:610:a4::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Mon, 25 Jul
 2022 14:37:08 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ac35:7c4b:3282:abfb]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ac35:7c4b:3282:abfb%3]) with mapi id 15.20.5458.024; Mon, 25 Jul 2022
 14:37:08 +0000
Date:   Mon, 25 Jul 2022 11:37:06 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        "saeedm@nvidia.com" <saeedm@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "Martins, Joao" <joao.m.martins@oracle.com>,
        "leonro@nvidia.com" <leonro@nvidia.com>,
        "maorg@nvidia.com" <maorg@nvidia.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>
Subject: Re: [PATCH V2 vfio 06/11] vfio: Introduce the DMA logging feature
 support
Message-ID: <20220725143706.GD3747@nvidia.com>
References: <20220714081251.240584-1-yishaih@nvidia.com>
 <20220714081251.240584-7-yishaih@nvidia.com>
 <20220718163024.143ec05a.alex.williamson@redhat.com>
 <8242cd07-0b65-e2b8-3797-3fe5623ec65d@nvidia.com>
 <20220719132514.7d21dfaf.alex.williamson@redhat.com>
 <20220719200825.GK4609@nvidia.com>
 <BN9PR11MB527610E578F01DC631F626A88C919@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220721115038.GX4609@nvidia.com>
 <BN9PR11MB5276924990601C5770C633198C959@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5276924990601C5770C633198C959@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: MW4PR03CA0283.namprd03.prod.outlook.com
 (2603:10b6:303:b5::18) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8c94be7f-c0e6-4b94-c210-08da6e4b26ed
X-MS-TrafficTypeDiagnostic: CH2PR12MB4232:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jMLu+Vav9+ETz7JJpt4LWHAVLsqSFy2FM66MyKvEsLwAcR9EB/x1SDX7vC/ieK3Og8vacI4ks0bGJ0rDZna7LkIz/7kJ4qpPnFFySrOIBlyz4LFh1BNhLsUP/dKr3QvxMEYeJkBwycoy0REHF7KanwvgkGRXyvEfBBGjqd4jjK+5adg0lMNYR9rcaYm1S7Wlp7Nm4uLnZhkfvOkA79p48Q6M9RJGZi7I1lIMo7/Rc+XaAc01iUeppvQiJb4qsRP3TLc7yRFIR4Gn4vJArdSTfsQnPHcSs16FzIJ4Ch8P7lV1Rf8qGC7THQ2By6VvKQeswDIhWSnpvP48R83e1qfUymBA+1+Zf3CFr1u3a8xmI1cYrA7oFG1LCTmh1QIu5xsr9+w5gwxQw/9dCf2MZCKqacPY+5hoNJcwmi5s3yW0Jwy6NYWiGrR1GviNiVz90Kd2W8WXVYg4jKMI5Az8MgCVq2Zl9CnP2nWVU/XpPc0xCeyhlhliqLM6VaMkzCALlyn8Lx9QOH5pQOX6goENCbz4XcfJP4WnrHspJwLxcClb/9bS0YNjj+VLzwK+tN6SJwuI4WhWkLZSuLUC5L8tsoySyrrhOQdeE17u0MAKMLIpaQlLlgrMPJW2Id0O1AY0V023ihOg9Qs/m64VgbTKIYxJ5b4AhkoJ27CbUJh90DVsBUW1G6wB22CggYLzdtWWtj0cfcePR1uzjYcf77nAUoaLA36nMNsRR3OpnKnng51ZlohGZZ6x6y7WzOiTcR7lo7JD
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(136003)(39860400002)(366004)(396003)(346002)(33656002)(86362001)(38100700002)(8936002)(478600001)(4744005)(6486002)(6862004)(5660300002)(41300700001)(316002)(66476007)(186003)(66556008)(8676002)(66946007)(4326008)(1076003)(2616005)(6512007)(26005)(6506007)(2906002)(54906003)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2CiLp5prm/e2w0g7MAWoiGuGA1IX4N8md0rqPb9ESc41cLORmWrQlq77cUvv?=
 =?us-ascii?Q?pYo3DP6lBtsl+vPF39+/hh5h+AJELqY7BRUNWRoJUxOvQHwlHcVd2SRGnwP5?=
 =?us-ascii?Q?ON8tVORk0xWk/kWEO/x69R5k80btRiCATojlbvTFf7SeUzXSjA5PXKVUABf5?=
 =?us-ascii?Q?NWpFC+nW4iU1YdVJ8QF6mxdR54jkZoWxCrBOWoS0fEvvSSC2XXZ+utA+GGq7?=
 =?us-ascii?Q?uJ8pa9O2L9xjPkAcWSIXgKS9y0yMa0isvxh8TKjj38iHybWRct4UBmz8/6Hq?=
 =?us-ascii?Q?/KdMb0Rk5UltOCkqo3+hAaU1yDNIYwCyw2GXP7RGov3VJgJTdHcSWTU20ony?=
 =?us-ascii?Q?m64R0JxvwL74XRCNP5BxzfzrXdqK4DP2Ya+4r5JCsj9ax647zAOrJ+8UY0Mp?=
 =?us-ascii?Q?IYFewUMBXolRQPBh3WahTtbaXuJc/fnZ9sqYNUVetcM33624jwEPFnBRQqwK?=
 =?us-ascii?Q?qiZ/PmDLveI+uedsURI3cZC9RrboxB59dDqdA6isVIxoNMpEGLzPHXeB5+t0?=
 =?us-ascii?Q?ApQJAOQFBAgh8MVU+TLbKClKxje43xOi++UroVAFccbyfuDu8NnwCMFDMG/H?=
 =?us-ascii?Q?IX8KRiEEh3faHgmCzQ7xNvYgWQNh8gwaDMDAFSWJgGlxFecgUl4g2P/Ih0k7?=
 =?us-ascii?Q?aM9tRKB1+reuSSgGOkhxIqvrt949KhHByjMNPS1Wswxqi22rGRVpE6Q+Chbp?=
 =?us-ascii?Q?4tMAd9cor3iSUVKVcHEgRV7YHc+xAQ+9nIcAg9ZnvLcv0oE4KDYc/dSFj+re?=
 =?us-ascii?Q?ovjLzb7LeEesuD3kkf7t1Bg/dZZ2R82rp3GFHCzEfUfI+dUHYYOo+Mn+DjTP?=
 =?us-ascii?Q?QrThbJpp54R+RfWBxo8KFxkAqnG6x+FVlE5rl3Uoa2lViYysKFUY+bvBChrW?=
 =?us-ascii?Q?bOHlRo/UnHQOyXNLLLc8B9G4z6dkXG7IrIcq3/3eOnvzMcjm9oFs6zBH/d6P?=
 =?us-ascii?Q?Yzp+qtfj7Ne3deznmkC7mzNG7LG0Qh+mDvcMb39QcxZKOonNo+0t2kEYkMiB?=
 =?us-ascii?Q?noNzRT2DvqZZtK5HsUsKMhclbz+nzyxDsBIhlza82QedDkaWd7w8NlyHkTtv?=
 =?us-ascii?Q?fyDl1odfxsv0skTJlZBVim6iMD4hM+FGu/gc2FF0FxyXKgqFm5VeCbVxyYCN?=
 =?us-ascii?Q?qrlBupzYXiDXgBoFEyEfDfoyhCS6HD71ZK+t2NMmxp4DG79ERIiKGnrJQ8Hl?=
 =?us-ascii?Q?XtSAvruiLVtKwysLChYQQbT3+Sp+xoxI5xYImdBm2IkoXUUYUbtFc/2/rk00?=
 =?us-ascii?Q?Afb5rCKO+uwTILOYJrf51uwiDdhHK08UYs6olO/MZBPAaqF0QDFv6qaEzL1A?=
 =?us-ascii?Q?U9m+VJAnnlc65EN3LgRXEnZ3R9tH3ygpO3ycGbDVpar7Bak4VLmma3k5xJV5?=
 =?us-ascii?Q?CheBsnnG0/5wYwtz6s2BCTSaklRMwQ4Mu5vtFxjhUQXVbo1A+NIzwmLo3+B1?=
 =?us-ascii?Q?gCNGEHzlHXxmSiIlhlzn+6+KGS/CBKeLaJEd+6AENxcRmoDcQjkGsOfES1A5?=
 =?us-ascii?Q?7scqMNhRZZ+2777SWPK57Bgboi6HOnceCwgD6N4+oeLfq2/5uM0e3cDBO/IH?=
 =?us-ascii?Q?C9e38Td1lZss8opwANZbAYLeZQC5rd4mBXPq9IQK?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c94be7f-c0e6-4b94-c210-08da6e4b26ed
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2022 14:37:08.3251
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ylpnlcDoPvZcl9/pXzvV9YWQ2mGQOiTZlutLbiECr+Qi5UEiFeARLYmheWT2a+CV
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4232
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 25, 2022 at 07:38:52AM +0000, Tian, Kevin wrote:

> > Yes. qemu has to select a static aperture at start.
> > 
> >  The entire aperture is best, if that fails
> > 
> >  A smaller aperture and hope the guest doesn't use the whole space, if
> >  that fails,
> > 
> >  The entire guest physical map and hope the guest is in PT mode
> 
> That sounds a bit hacky... does it instead suggest that an interface
> for reporting the supported ranges on a tracker could be helpful once
> trying the entire aperture fails?

It is the "try and fail" approach. It gives the driver the most
flexability in processing the ranges to try and make them work. If we
attempt to describe all the device constraints that might exist we
will be here forever.

Eg the driver might be able to do the entire aperture, but it has to
use 2M pages or something.

Jason
