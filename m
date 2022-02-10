Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A6174B1430
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 18:28:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238107AbiBJR1q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 12:27:46 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:39950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233830AbiBJR1o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 12:27:44 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2070.outbound.protection.outlook.com [40.107.236.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 637531021;
        Thu, 10 Feb 2022 09:27:45 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QrmLNoxMGMr9a3E0i0LoxT0blkZZGg/ogVvqHxQo06JkAnAYuFX0IcubB7u9jvFKyeSqjfkc+vVcp9y6GxN6fo5+aET1y3Kq0p4yiNt8vPqy3uJSyekt81mgev8qZREcACwILSA2BKpbb5xKeeeGQ2ZuUbtgswUUjevvMFi5gkdJj2EJWx3XjjeUcCapuzxQWBmzVCExRdLxRqdoTw4ycRhW4l7YALBK086suThLXGObGvrt5O0NqhZ90yuDwWQJaqqwmCzlTmbk3ACRAHThqEiA7egD1n/Xcs0MTQ6WX6c5foNRKn2H4N1Z3GT75OChX26xNzTd/rq16AbAYG5asQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tBQphY8MmtSaxR1gqY1ZAGa3/Ciccft1+FeJtOF7+p8=;
 b=XkUYyp0dJML5Y7Kw/6IpSD3/73Z7iSFsBohuWjk3fTCCZDPkmYV2O1Bb9W4QNuSLFE15UGR0Kp2jE2mmg0/G51dGeidkVmi1lF2hj6PfExRSBz8t5xm7Ufyl5i1RsZSL8ySKup9l+sxBUcz+MhNd5jC2nMy19dzc0RQWe+RokAnsYl/23brMGDF386CqPDbtBgaCLEVuZolB0wAURVVlN6p8MJS5QpOFf65x10l0bmyF45ElqtLJ/BO7VXNAj9q+y6rFqQ9TEcneAG1GecKotfwGcvIwgOlkpzxAme7KVkB741foDUQC0pfVBlpN2ztFlHup42UBULY1Z2/D+W0G6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tBQphY8MmtSaxR1gqY1ZAGa3/Ciccft1+FeJtOF7+p8=;
 b=Zu+0BBCvbnd3LZ9YUFj3FD5f4thsbsEiqQtK3KDPrF9jLNMQVaCgEcmh0dVY+U5ElOXLyp/2Ff8C90jQ1SFJ+8O7gte7w+6Cg30M/OBa4rTE381RtEeeY9qxvhQjIyQ+eFKkJT0T0YhzBMYT8jD4M59dsw3eFRvNElnOjbob/WyX+ssjNnUys+ans7/S2a+stB19HANmaT4owQGbQXUIvOYxxV7zS4d77izecEe/z5KRwRxmCuJzRR5oxTUwbXC99foac4SDG494Kz0Tvo0YVP6jGzcgJQexyrgzwxrqhz9yx4ZZPaCupdBcZJr2OkSC0YTHgodH9I/TS4tPVU8bRw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by MWHPR12MB1310.namprd12.prod.outlook.com (2603:10b6:300:a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11; Thu, 10 Feb
 2022 17:27:42 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3%4]) with mapi id 15.20.4975.011; Thu, 10 Feb 2022
 17:27:42 +0000
Date:   Thu, 10 Feb 2022 13:27:41 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>, bhelgaas@google.com,
        saeedm@nvidia.com, linux-pci@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, kuba@kernel.org, leonro@nvidia.com,
        kwankhede@nvidia.com, mgurtovoy@nvidia.com, maorg@nvidia.com,
        ashok.raj@intel.com, kevin.tian@intel.com,
        shameerali.kolothum.thodi@huawei.com
Subject: Re: [PATCH V7 mlx5-next 14/15] vfio/mlx5: Use its own PCI reset_done
 error handler
Message-ID: <20220210172741.GI4160@nvidia.com>
References: <20220207172216.206415-1-yishaih@nvidia.com>
 <20220207172216.206415-15-yishaih@nvidia.com>
 <20220208170801.39dab353.alex.williamson@redhat.com>
 <20220209023918.GO4160@nvidia.com>
 <20220210094811.0f95fbd8.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220210094811.0f95fbd8.alex.williamson@redhat.com>
X-ClientProxiedBy: BL1PR13CA0412.namprd13.prod.outlook.com
 (2603:10b6:208:2c2::27) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c5f13afd-43e1-4c6f-4a97-08d9ecbaa4d9
X-MS-TrafficTypeDiagnostic: MWHPR12MB1310:EE_
X-Microsoft-Antispam-PRVS: <MWHPR12MB1310A1B051C7A7B3F6B7BF69C22F9@MWHPR12MB1310.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cjshcV3cP8Bck2KurVRMpMqKn5Hjqgsrigj2tLqGQg4lQwpSRdCyrJYixbUsis4oWMEJiOlaX+Jf1pyd8roglAuPfSN4XwpA7j+8ffrykPv6PBEhsc/Pou3kCNpJdWoqYCOZR79X/OVHh1NRgy6tLzNSggzIMnzA7GeeRG4bqgC6J1jJftRiR4paUUYondZSKQczRHSf8oFnyM5nSMiTJ49LuJwbMp2QU6mt8PkK0FMLPtXumRbiOOYNJqPZBTUaxCQSTLbmZcLpktyJMMDQ6bV6pv40SRVy8YOm5hVrdIpJA44F5r/GUyKCmdIKK8y9P9XOJlJhuy3MTdCEmCIhAyN6EmmYUHtddEqa1mfJOezbnsk+o2dCZmnEbHn7UqXBNJ9Seak03J/KuKnNGm4hBxpHJQgEL+126LiT3kNmfCDxlLchNApvh48p0rM80TnCxACmbMohT0k19yeavMfbrN7Jgr75002X90Ctps5OZJ3FdI7DcXcMaBMWDGk8ALdISE1x7ioJ+j+oAC2Tl+Fg8HdDTCwVjtB78xd8dr8iSMNbXEwUQD5qq5Qy1VkqPvcWfprAZyHlYrq0VPGplrGHOeySClCf/ZbVtl0qVt1FdlvMPrkANeDeIZ8LS9iVwE4w02BlhCeleFJi6uHsxU0c1g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(26005)(38100700002)(1076003)(2616005)(6512007)(4326008)(186003)(6506007)(6486002)(83380400001)(6916009)(36756003)(86362001)(316002)(508600001)(33656002)(2906002)(5660300002)(8936002)(8676002)(66946007)(66476007)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ma02OrTg8vBLN2cESMuwEfw4bUQgz8KyZhiRQ0CCpXwydPpX75E5WWcPxJD4?=
 =?us-ascii?Q?0HZzLqKbRZH3nQuXrLwK8xLJmqD6Pe4YoQ2wLUCe7rDNO1S3x0cWyaS4nGA+?=
 =?us-ascii?Q?mAFAw0nTuAnOKUyjvsQAfDGAJzxhHBgyPOCSz3akVz+QIdOI68qYue16QOoy?=
 =?us-ascii?Q?DSEx7kcJbKFSu8aF8DDkE5u35PUv8yQ5uHNXLvC/krdWlJKhaT2KsW3Kjh7k?=
 =?us-ascii?Q?+gaeD/ZcPGv5L6GAm89l2WkEqultIfy7Io7WLGnsjEg/A7sBLRD5py5xzvgR?=
 =?us-ascii?Q?FTb6PTNl9a2qL5Zkjf61cmTe2mLIis2ZOzLB27BpmC9x8jJLVa4E1fORJsku?=
 =?us-ascii?Q?448ku4Gtjt2FHiEBw1etsSey/q6fm8d2WD3gHe5un3rr762OrECldUzsOx9U?=
 =?us-ascii?Q?tPEDTCE8M8Vn5hZDoXLdl70ZMt0ttDVSIP7IE/HJt1TBXpZ3SIDirC9D0M20?=
 =?us-ascii?Q?/lvZXpH679OdMg2bhw4VX8aoPF9yE0J/viMuM8FwKDkhxvK2bDYLU59aNEKn?=
 =?us-ascii?Q?FeXeQJfXZz04QzjNw0LAQdxNA5J0LqZ9eMoBBWaYEBdoaZqZ7d1b7lla0z3l?=
 =?us-ascii?Q?0Id7Ki78LAOlL8OKgxK9Mnlq2RBoRd7IazTUCVLa/gq/4sqXILMqyGviOMdj?=
 =?us-ascii?Q?hc6uLjVwjclRMzxSDsXEL1+hz/PEIuKIOTheVO1+dNKUZdXrKf45DrCoyxGo?=
 =?us-ascii?Q?5KjIj1o32bdLG5KiP3mO8eacJjXfMBCun1wU/OhTd7Gxj1NuqML4LfHKVP6i?=
 =?us-ascii?Q?25a+0NtstriGZS3INsJwWgOomsOyNxdOPxnd3V8SO6Dyabn+xEaOqZLpNpA2?=
 =?us-ascii?Q?dj3mwQtY/2ILMEpFJTnmDAV50LcfIxqpVMyZzIdylhPMF2xTpx25WmyG17sR?=
 =?us-ascii?Q?Oa7vSa5VN5DDsHLWyG1NB18Yb+zBWdTvHNCFV/7LgiDuNdps8VDW8JZgnOwF?=
 =?us-ascii?Q?KVgzhjT5qemfTyuuQwXZCU1i4hHxukbP6zoSmg5XS2XcGh9sUIPhjSXnqgNJ?=
 =?us-ascii?Q?+MFMDvdEVJCYQb6KSV3e7ZRdZXVLE1qeFXKo8VNaQotdAfURJ4vwSzARmDYE?=
 =?us-ascii?Q?PSEoOE/dltD1rpUTYns5AwHZe1CY8g5E63xT6rKia4c/4dtiRap6T7aBoIB2?=
 =?us-ascii?Q?kaLX7s2VGy/XAFkKXIX0gRlY3C1SUYZmHXyTZm5JvM163+N/ColdMzRQ/fJ8?=
 =?us-ascii?Q?aB5IYwRrB6uOVevR9VCTgytO1fNlEWoyV76AX6rBly29JMAgVZc1VShIVp60?=
 =?us-ascii?Q?i+pdfR2LU8qjZdaZi20MkMdv2tFLGjcTjn4nbaM5cawylcVdu0mbdHEJjZIX?=
 =?us-ascii?Q?fuRwA1vX7Q8iGUrTkAM6AUIJm1wo7eVn0rLb+O6dy5CyVe1aUo/Gg1r9Ev19?=
 =?us-ascii?Q?SXZSWt1CiDZ6Mj/yyG+qZh/gpTX+18j6jh9ydgQq1EAHF96X8HCDBX7SPb5s?=
 =?us-ascii?Q?D7GWEMLBeiT2YdU91FnQ/fSWc31y832F6rInbjaIQetlGnbU4BRqj5iFEUm3?=
 =?us-ascii?Q?R2dfUFkSJzFDPb0CpPFB+4RdfTLqJzkb91BgQriP0fgW7XRSJQrmDqbYLWDO?=
 =?us-ascii?Q?TKYURx+HoZ6f+6yk3P4=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c5f13afd-43e1-4c6f-4a97-08d9ecbaa4d9
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2022 17:27:42.6848
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ch1oXwjTlkIseVi7LW2uFEj/+NAxZptKZtQFqJCCQ9f9N28iKazpLxPRQ6AaDXHa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1310
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 10, 2022 at 09:48:11AM -0700, Alex Williamson wrote:

> Specifically, I suspect we can trigger this race if the VM reboots as
> we're initiating a migration in the STOP_COPY phase, but that's maybe
> less interesting if we expect the VM to be halted before the device
> state is stepped.  

Yes, STOP_COPY drivers like mlx5/acc are fine here inherently.

We have already restricted what device touches are allowed in
STOP_COPY, and this must include reset too. None of the two drivers
posted can tolerate a reset during the serialization step. 

mlx5 will fail the STOP_COPY FW command and I guess acc will 'tear'
its register reads and produce a corrupted state.

> More interesting might be how a PRE_COPY transition works relative
> to asynchronous VM resets triggering device resets.  Are we
> serializing all access to reset vs this DEVICE_FEATURE op or are we
> resorting to double checking the device state, and how do we plan to
> re-initiate migration states if a VM reset occurs during migration?
> Thanks,

The device will be in PRE_COPY with VCPUs running. An async reset will
be triggered in the guest, so the device returns to RUNNING and the
data_fd's immediately return an errno.

There are three ways qemu can observe this:

 1) it is actively using the data_fds, so it immediately gets an
    error and propogates it up, aborting the migration
    eg it is doing read(), poll(), iouring, etc.

 2) it is done with the PRE_COPY phase of the data_fd and is moving
    toward STOP_COPY.
    In this case the vCPU is halted and the SET_STATE to STOP_COPY
    will execute, without any race, either:
      PRE_COPY -> STOP_COPY (data_fd == -1)
      RUNNING -> STOP_COPY (data_fd != -1)
    The expected data_fd is detected in the WIP qemu patch, however it
    mishandles the error, we will fix it.

 3) it is aborting the PRE_COPY migration, closing the data_fd and
    doing SET_STATE to RUNNING. In which case it doesn't know the
    device was reset. close() succeeds and SET_STATE RUNNING -> RUNNING
    is a nop.

Today's qemu must abort the migration at this point and fully restart
it because it has no mechanism to serialize a 'discard all of this
device's PRE_COPY state up to here' tag.

Some future qemu could learn to do this and then the receiver would
discard already sent device state - by triggering reset and a new
RUNNING -> RESUMING on the receiving device. In this case qemu would
have a choice of:
  abort the entire migration
  restart just this device back to PRE_COPY
  stop the vCPUs and use STOP_COPY

In any case, qemu fully detects this race as a natural part of its
operations and knows with certainty when it commands to go to
STOP_COPY, with vCPUs halted, if the preceeding PRE_COPY state is
correct or not.

It is interesting you bring this up, I'm not sure this worked properly
with v1. It seems we have solved it, inadvertently even, by using the
basic logic of the FSM and FD.

Jason
