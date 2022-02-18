Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 937404BADD2
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 01:05:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229904AbiBRADe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 19:03:34 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:35108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229893AbiBRADc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 19:03:32 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2044.outbound.protection.outlook.com [40.107.223.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6248415A38;
        Thu, 17 Feb 2022 16:03:10 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MF0OojIi0DHgEdAXVzKq+Gk4yGwdA8fP/9m8oWMQbQ3vum9u647b1oupAwEWiDZCp84H2h04aZvQduTOtYIblz3vOOSqRN4dk8AMo6lyEeLXc9+pizDB+5XIK76O3+Pi4Mezde8kr1ZBlw75YKKD7qredYgF+ctU4IOXkEJ618xYFyIzKID8EM2vT5yqf040mJYZr7C4tiHlNMDajL1s9H40kyTIeoNFpBnWizpV3Pwm4hcgpdHur71ggtZcOZHs3bmPSNlz7DP8/CWiAMDCfHs2qnkajLk9GA/xPI4IxHEkqSBJLOmeBpkFsjY9X5oRYDi+2R8pl54Mc2GHGyPWjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HS8PWxY/fjuT2svUrLbwj/FhdkvC0bIpEav5owJfP9w=;
 b=akm7clyahuQh0/2RbgQmZpW4HwDKFkfG3p6qT890W+Us0v9efOpLOsXKSbDkzvFjgLXN3kyPRpr6EUF2viSxjKbzE5+oz17omZ7FpIqBUSNpoE5KIAcMLdYAB8G9Md5+AOdvK0x3tMQxiQA2gZ/VV30PcH18ZXS5dASRK5QczLGUB7NztNOzSG67md02OpYUq7dn9ymbrNtHkzi06myE7/VE0kln1EvW7hfTppL/ZTJV5+KqSNL8LkTdn8RXiEoS/mCNBjnNFNRmupQCju1lg0HCnz0WRJ6pnPDTwVJYvb1h0MSE66IiuLIyMWLdB7UREsh5ErXLUkkg1XuRqGGq1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HS8PWxY/fjuT2svUrLbwj/FhdkvC0bIpEav5owJfP9w=;
 b=hu/ffBdUbh6PWDhajjjOtYrqvK7ZVhNkw8evwiZqqw2sSL+KvpbMXmaJQtc3TPYem4q+g8bAlaUtRVfnZeWGH+4Tv3QCLXfxIzNHLGlzUJIGDB74WEWSNrGpknpfcJ+fbC5QrmxjPwtZMI3C3tjUXyA9E7p/tyJE0dHQQWc9gx//GgrDAAxYptqE0PXTZ+YfZrTXzFpbUm7FS8waOqVK1LULO0BF/TMdWP2CUgzWq5qv8r1RcuQiLD3T/uU35LaF5qyhuAsEFohH1CVCOtMtHA6ftcN7pALpVjdwNM81OnmrRx4QDUz160rYQdXHDZsQrB+idCwvh9Ss5ZjUqffoxg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (52.135.49.15) by
 BY5PR12MB4273.namprd12.prod.outlook.com (10.255.126.144) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4995.15; Fri, 18 Feb 2022 00:03:08 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3%5]) with mapi id 15.20.4995.018; Fri, 18 Feb 2022
 00:03:08 +0000
Date:   Thu, 17 Feb 2022 20:03:06 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>, bhelgaas@google.com,
        saeedm@nvidia.com, linux-pci@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, kuba@kernel.org, leonro@nvidia.com,
        kwankhede@nvidia.com, mgurtovoy@nvidia.com, maorg@nvidia.com,
        ashok.raj@intel.com, kevin.tian@intel.com,
        shameerali.kolothum.thodi@huawei.com
Subject: Re: [PATCH V7 mlx5-next 15/15] vfio: Extend the device migration
 protocol with PRE_COPY
Message-ID: <20220218000306.GM4160@nvidia.com>
References: <20220207172216.206415-1-yishaih@nvidia.com>
 <20220207172216.206415-16-yishaih@nvidia.com>
 <20220217101554.26f05eb1.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220217101554.26f05eb1.alex.williamson@redhat.com>
X-ClientProxiedBy: BLAPR03CA0035.namprd03.prod.outlook.com
 (2603:10b6:208:32d::10) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e393ada6-d783-448a-96f0-08d9f2720b5f
X-MS-TrafficTypeDiagnostic: BY5PR12MB4273:EE_
X-Microsoft-Antispam-PRVS: <BY5PR12MB427360BBAD62BFFFBCE885B9C2379@BY5PR12MB4273.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZoX+1wNg3cEKyD1zL1tzyTFzrdgafxLvrnSP5bVscI9v4jNOGjjNPKWcJQVSvEmFOCZ3P2WeQYvmU+By6sEBORxVWd8Hsi2kw90aSFvxJmDwxAnOwi4XkOAsjHY0P2T4IS26FcnZIfdT8/G0sJPnUDVASUCgo/foFaaKYfiqwrrJd5GEpuXhn2kbHxl0zxC62NtBQ0Y2nbI6UoSgAXZfk9U9jtKn5nel07mZq/u8aIr+dgt+6DkWN9zqmQSGdjfuLVQ14vnh3oXThJ9afq7ZvtAGNtN3hxUxQBJsVN6MzejMNobnKxwHGDFLFju0ez3S/W6s/FEwZPM/TiNoowDwp39EJxmrQPYniJL2W7ZS4QjpjsEMpm+RvMw24pq+qLkt4PyDyh2EUonKtQCboRDGxx/AGP//PBbyPJ4HiPWr2KVOuXSsBqZjfzNMmlYPtmTTpMh4jOePnm+A7+vsYVIFzkwpBaaawpBCNdHUGeGqnN+jihnR2lilIr/MYrGTR8IxKcAePeGayxLaJxP6xjbl7SJ9gzsnW1d2uYhWmapCEk89CDp32uzNvpd6PgJfNqSsDzhZs69WexzOEjSUOLTgSAehNV+78GMStrgXacS3aFKQHraRy5Kt/C4V4o0uXyqrH82lcDrAgTp2BPBVmzDE4A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6506007)(6486002)(508600001)(186003)(26005)(2616005)(36756003)(5660300002)(8936002)(6512007)(66946007)(316002)(1076003)(66556008)(2906002)(4326008)(6916009)(66476007)(38100700002)(86362001)(8676002)(33656002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zYXdrCUqeQsxfbfTJUKjpBY5icyTYER858BGI09YMtFNrK0q62G/zhYFRKpK?=
 =?us-ascii?Q?/85AK6xVw3llwrO5NKBpUBOZbEPyYhFiAwb1fS0YteTlbcRP8/EIUS/DgRby?=
 =?us-ascii?Q?psutQDrCe7JG1r/CsBVQ5znb+H2UHc/6tGMaYF99WcQQxXx2nyj2gNmxD3tp?=
 =?us-ascii?Q?sdeukA+XGkjUEj6TQWewfpYj++b6zlKZQ2vR39T+Jg96o5RBPUHvOFXq5Rn2?=
 =?us-ascii?Q?Dxkpu7lsX4kHzyRWIKZmkb/rSMVNPsGpYCQuikJMJa3SrCy3GL/tRtIEBW2U?=
 =?us-ascii?Q?rYeNC8T5hJwJq2BEJbN+n0jR67dn/qvUpyQg4CF9C0/M7ynx0k1k7s5smW5g?=
 =?us-ascii?Q?Lu7V75TvANjLxQ7TGaSe/xcxN6PRvs4bCuH4bqCvdFp/FQxbHxrEU8dqlH02?=
 =?us-ascii?Q?zklDvm2BG5wfE6VJfp7BIp23C79t0LNWrxwHw0vy2xCDuHTz5MNsLFgeZa4u?=
 =?us-ascii?Q?yfvH5MgaZXzCUmewsPm2LcJ1flKVicKlDeEIIvImQy1pFHvtLgU2OyXCxCef?=
 =?us-ascii?Q?tdUwLGWWZ6KbTsRj8OtwDjuBM34s7jt90wo87B/CY/qZD+gW8f3yVkTIxx6L?=
 =?us-ascii?Q?tMP5KSx+Qcb35HgwQCTgm6+Ovo+6152Dg3iV6nD+00VfY3LlC4fpczX1+v98?=
 =?us-ascii?Q?W1V+ZE7rcKAvottwFQmV0SgxnuCr9lPpd13aWaiAlqQ4KMpYRR+j/ruWss7J?=
 =?us-ascii?Q?cfzx+fWCfEXJBqAXmOJPNqvOIq3TyVoB4e13EszakvTvGbMhc7Cej9rgwaGa?=
 =?us-ascii?Q?LggNdhFCV67wS8umEMJJgCUaslXXGxHktHc4EAFuNWI+V0cORju7WvKbJLcz?=
 =?us-ascii?Q?PdeOZRe11i1YPPvuHbQcgimNdWC7ILz8ZRjOCTDRlTVL5f1CC20RXmAV4XL1?=
 =?us-ascii?Q?13BgaL4coJQmnsVaYEbbxb1Ry89A6N6Xpp/d6O3WBDGPeN5s5/ZlK3C4V5nq?=
 =?us-ascii?Q?1EQ4rzWuVhgWPN8rJRRBls6EZTF0C88IFzP/CIYnFYqu2hTjVGhIPA8LKOFF?=
 =?us-ascii?Q?P3z5OinkPmzQMEGjOwkJsdU/q0oXjsCl34O3zkwaYrZ7ungtwz1WQGlX2jjZ?=
 =?us-ascii?Q?mlKIzaEfLGl9VDsKF58FuGmLU1pDcLrK42IrbD8yR3IPIxW3Tnr91YVfICN4?=
 =?us-ascii?Q?VppcUcot9610dYXeXSLGdY9TvT1d+KU1wu5Ow4KrRhQfo9rrI4fI5uEEiN1o?=
 =?us-ascii?Q?kPlnnVI2ZXlC4MIJB47PF2GBl6B6Kti3L1xcAnBQxYFAKqzFenDJ8XJnkuPL?=
 =?us-ascii?Q?CqL4Z9lzl6FJ2ien5C4EK5yJATE1WqjZcfDnf+tfJt4UEd/3NCl+RjFKgSIv?=
 =?us-ascii?Q?/6FjnUcxXvG7Mdq521V8rNyd1SfB+HqL8sLHROWw2ReGcQZvc+So4pFxPvzu?=
 =?us-ascii?Q?ThM8OZeulmdEASfeoAsedLr4BNv/IfX5aq62m3VGmQBuXlmyA4HJXov2TnoO?=
 =?us-ascii?Q?Zy4Duh2BrFuFt6sV0+NMjRth1TVFEcwimRLoJ8Y3mhj8dmGI2JX65eTawhLe?=
 =?us-ascii?Q?NTKdJHbWFmxIaLhl+pfNxVPxlfwKlYsmF2ZW6AvRAT9ZzYcczA+LRAAHIyKt?=
 =?us-ascii?Q?rytfoNF6vs49N5kUKPs=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e393ada6-d783-448a-96f0-08d9f2720b5f
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2022 00:03:08.5017
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9QlXYI6ACPVmoF1b3iVyiyBXULfkJlR775HjbK8hPT0VtYwOT7zvbGQ9Pkvv3oxZ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4273
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 17, 2022 at 10:15:54AM -0700, Alex Williamson wrote:

> I feel obligated to ask, is PRE_COPY support essentially RFC at this
> point since we have no proposed in-kernel users?

Yes, it is included here because the kernel in v1 had PRE_COPY, so it
seemed essential to show how this could continue to look to evaluate
v2.

NVIDIA has an out of tree driver that implemented PRE_COPY in the v1
protocol, and we have some future plan to use it in a in-tree driver.

> It seems like we're winding down comments on the remainder of the
> series and I feel ok with where it's headed and the options we have
> available for future extensions.  

Thanks, it was a lot of work for everyone to get here!

Yishai has all the revisions from Kevin included, he will sent it on
Sunday. Based on this Leon will make a formal PR next week so it can
go into linux-next through your tree. We have to stay co-ordinated
with our netdev driver branch..

I will ping the acc team and make it priority to review their next
vresion. Let's try to include their driver as well.

We'll start to make a more review ready qemu series.

> PS - Why is this a stand-alone ioctl rather than a DEVICE_FEATURE?

You asked for the ioctl to be on the data_fd, so there is no
DEVICE_FEATURE infrastructure and I think it doesn't make sense to put
a multiplexor there. We have lots of ioctl numbers and don't want this
to be complicated for performance.

Thanks,
Jason
