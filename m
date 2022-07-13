Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93F70573FA0
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 00:31:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236862AbiGMWbk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 18:31:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237000AbiGMWbh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 18:31:37 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2059.outbound.protection.outlook.com [40.107.95.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EAAB4D824;
        Wed, 13 Jul 2022 15:31:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UCN4yDDll9kJs90Rl6UTJ8tcODjmfUm//kSIy+TaE1wCgB2uoWUz+BPhfOscnrvmlxZRuWIakCCgOdhWxGIMcDNEREFAtQ4R15BrMfzhHxyly2oxC0vmJzr21H84c6cIQUnuzRhKdca5tOomlQaN7PrLpoZ8mvQZGJUH4kNt6RgrXWyq8+jjw0bm8TQR4VAKCCNbNSfZ8W09HSKq/xL8NFZyG6fUhB8aQSzUmKSFIwLwArnrAUkGj9bMiFeM0ZR3WrmgpuWjHEsz6HKhsKU7dKRkz9WXFfKrnSu0fxvZ1HyL3yfCxibOiz1WjYp7vv0ss6uQ+9d+TzfSpx2pHjfQFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fsGwzIIy3XS3f3311/oGey9XyLD3CjyfDWKTlzrHA7Y=;
 b=cDNhoSiY3RB4C/mueB+AFQAYsbcBOa81cnQdnTe9SXS+EIfzTWc3mzjYSWmox/JCJ0nX2PAveuIXelbnrnhruX5QiyuBBquT7KxCQYb8vOY23vFGPMaN2H/J53PBGAgAhx1oTMpYOujqwW1yfoWJW/dUXKnd499jIn7bP+OSDcorpx8OaWUJKJxgKB4ixloZ7fvhZIkQkx6fwKS6uKBDVrH0YNx9vu1KjxVCx7zlq9NeqBFst8vcGHIT3vI1sEVjGLQJve4gor2nwv6WqXu0Hgwb36tbKvf7lpTU1cgIUoU0m1nLLquagc6UrksXviShSv1PSi8yUUTaC4aw8tpoMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fsGwzIIy3XS3f3311/oGey9XyLD3CjyfDWKTlzrHA7Y=;
 b=W/wFbPBGrmn37RgqosT1hHRMERJi7e//lksGW01AsWONpDJLaANGZ3dq8o6bk1eFUlcXAS8ttJ4UO15Zl4kEMMqjckurMN1EuF72MYs58YnO80/0gHyIsD7DvwSMp0EFF66TEWjD/68RkUDLlDXaK620ZLuRMrJUw3qhsHFf3PJnun57ieidAqjlm7YIDjMAzy5JCiohMaortc9gvja2Cel5ReL4KJnS4NANGHfuzq4MIwddKdTVN4edCqMypHsHert595vkEC+jn+QSvsIbYJW+ITjr7SVG+jGziY2j+OeGAgsAuoZ0kkTE4H4nfeUndFItMIk2gHLre/jq3j5JQg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by DM5PR1201MB0010.namprd12.prod.outlook.com (2603:10b6:3:e3::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.16; Wed, 13 Jul
 2022 22:31:35 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::900e:a8f9:4d99:1cb1]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::900e:a8f9:4d99:1cb1%4]) with mapi id 15.20.5438.013; Wed, 13 Jul 2022
 22:31:35 +0000
Date:   Wed, 13 Jul 2022 15:31:33 -0700
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, Mark Bloch <mbloch@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: Re: [PATCH rdma-next 5/5] RDMA/mlx5: Expose steering anchor to
 userspace
Message-ID: <20220713223133.gbbt4fbphzpc42hx@sx1>
References: <20220703205407.110890-1-saeed@kernel.org>
 <20220703205407.110890-6-saeed@kernel.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20220703205407.110890-6-saeed@kernel.org>
X-ClientProxiedBy: SJ0PR05CA0038.namprd05.prod.outlook.com
 (2603:10b6:a03:33f::13) To BY5PR12MB4209.namprd12.prod.outlook.com
 (2603:10b6:a03:20d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e97a8c08-6b64-4223-1375-08da651f7173
X-MS-TrafficTypeDiagnostic: DM5PR1201MB0010:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: doNE9x+yKCoDnRuITkHCrbaf6Z4IG89IzghCSFonTbW0Uw4UscUgDFBwHdJayfKJhelHw4dopCnAcOIvHp30YnubES5hxS/htaXuxmFWaLzpXNlTzG4TzOi+NW7gsFIuLcOJJSqAiovRpc9InpSylU7P5OesBs2VxuLnw/TJAEfbmKr+8Hhcuu7nLII2Pong1/PiFfzbFTr5oLpfp/hnS8AqEx0MEBTKrFDKW/Vgfxcne/nJBMtwea4tJg3tbTWrnCd+ekJeV8bSzBNPvQzuc3xXNPlqFouSXceix2ulbGQI/FFuN7d1fhtL20EBMNe+HhjkT4wwdGscZvbnyMML+7WJptLLvA6s6FfF02RFtiC06mnpiSMqKPmS+J21Y8bjz6qQkrNRXMkxuRvul5xGxb/Pz65guEEc9PCUrKF9CiRscjwnyxMV3/wDDWUMmPuhkS6jZ1IoafAzgscEdK9sI+bfFwIBdFX/kOQl5mbwW7w9x1qQu53o2X+0s9Q9m8I3UwwD5Nno8bbErkO/xIy72gqQBQMXJFxqGX4MLTT2WjQgUTVejKFIIKd673iOEAPgBXkK+NQLesCo6p9ZVbUv26IKEriqwOySyh30x6WZES6tKdaDH424I9oXhn/MG0VOXKD3ngZ1Ivp9jFWLJ80LtfMKddhuCI7QF9sUcWmOppy0KLxQS1QHzWPFsFpVFF4WHDnX9etETbRyl1BAIUL8sPV2k/bPsZJ6RrBz1Ln7QowgWVCAdL2W7yfd+qG/SMfSJ+UVSRHqp7ejM4gE/TLxlw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(39860400002)(376002)(396003)(136003)(346002)(366004)(107886003)(9686003)(186003)(41300700001)(316002)(6506007)(26005)(6512007)(1076003)(38100700002)(33716001)(8676002)(478600001)(66946007)(2906002)(6486002)(86362001)(54906003)(6916009)(4326008)(8936002)(66476007)(66556008)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TPvfPAIIJ5gdOuy+syrAG9hlN2xvzvhVOBM7pbQjf2zV7Pyw7M/5KJowaE+M?=
 =?us-ascii?Q?zBENpKIalDytbxKRBY4IIJI9DvivI4+iumebRoziVtBKwZrfyBa/e9iqk2tK?=
 =?us-ascii?Q?HLm0Xsfm40b3MciYzxIkoBLIovddnHEWkfTcqea+G27j+B/wuCmnbfuXW76M?=
 =?us-ascii?Q?ILEs0OxWvLh43Xmicow8e5c+5NlZm+vSqeZdWuIXlV5W/W8hvoJs/lLLwIt3?=
 =?us-ascii?Q?t09HAi0vcuQGo3SjZt8/NRdoNUh4AIFBR7mK/k+dvTiNZc7vsVzQZ/8mBQMZ?=
 =?us-ascii?Q?A9OtcFo319qALsDDHg7RR83MS97dZwXc3EeCqmRkuV9e3QXSt7gc9Q8lE843?=
 =?us-ascii?Q?30yo3DG/wy6VBNLVhXvt+FfxK92roD47xD5MjLl8AR/4wkTDLfdRUPNx+WMb?=
 =?us-ascii?Q?7NlB9kaUiMiNX3w1VfzF/IaU+xwWQbvECtMJxVxU4+6UDyTnMR/OM3lLwF8R?=
 =?us-ascii?Q?Eq3Vy6jvgrV6atpg4Dc104P1guqhizjJa3QQgXQXBEa2c8ZzSQ0GUw6zdKaM?=
 =?us-ascii?Q?+GXT1mapx9bcjtVn9vzTpSXT8eNERxr/0h8nPwReCQLoPORSywp9cK4edK5B?=
 =?us-ascii?Q?U+8a0PpO1ESo3WK6INcEKR1Qf46cSUOL7VEaQQo1/2OUYULp0yDMG9JJtDdh?=
 =?us-ascii?Q?iDGImnWzP3KJGGFeVSnm+kbdwQHzCOKQJF0GBvbdNZe4so/bNONKCG+DQVaV?=
 =?us-ascii?Q?EAGFdOoYHmUwtlP/IwNev4GR7qVsdXD+x9SBuH5PceXI6f3PPKEREJC0z3dX?=
 =?us-ascii?Q?FjlsQEuw8GB/cL56GiwsRYnKXRw34WZOvBrA30etkUNK7DotepDS/FLSI6Ns?=
 =?us-ascii?Q?wC+qYQsRRiT/JUuv62rDNLi5SixoEO7ddV+2XckZapecMOKABpNTfNnX6Daw?=
 =?us-ascii?Q?eSL8zZ2WQcja8KUzWa/noc7wO/YNCYkeBTkCuuh3EDG+L7/sdiYPWjFUjKtY?=
 =?us-ascii?Q?0Uy8lbt/s+4VWJADXv6jeyOk8D0WRav4gkO6p4VdUkQb3BBDVe7joIDEwnRO?=
 =?us-ascii?Q?2qGvgi5D+NaSEy9mOW/pXdQfgnDCasyt89amyUJDGG/SfecbCZgBO/tSrLi6?=
 =?us-ascii?Q?BIqsm326FlSzWLscjudRotZ+dutyQPv/cdbo/ooxhv2yH58/o6eq7EzAMqQg?=
 =?us-ascii?Q?UtsScBOtsSovMwKSLa3hBaETzyQeGvsl2r/UI0LzvcPKEIKCdbNx+ctT9NgH?=
 =?us-ascii?Q?1Eel9b02DYs1hj4hDocDwPuARkw2fRuzrxjhRAhwp6OLfjUdlgP6dswQI89J?=
 =?us-ascii?Q?U6mRr3eAzOt7TdR+4KFRG1RSHyr0rYEX6PlBNCpxwgHIrMZrlcnfndFnL+uF?=
 =?us-ascii?Q?WwdcsZT0iGM/FFq/PwqDVvo9VdHAI92f9jT8Fx9ZfNbj4PaniVlv1l6jnMRH?=
 =?us-ascii?Q?k0iAHI5vzEWTmvP+g6ovLAuT0LsBJcGMg0OrJI2DLdB9YR8QG379Xgqa064f?=
 =?us-ascii?Q?vz7pUcICWHDA3wlDZik/qlztQAoBsk1/9iXVyNBrnzDBxSJQGGMlOI+53p+h?=
 =?us-ascii?Q?ZOat4xr8qJOTkRdIVKUkzS5fyo90kftbI3BUCL5zcXLbZCjF/Qa6DL5NMAIJ?=
 =?us-ascii?Q?KOaf98Hqz/YSoUgIc4xSZk9k4/wfQN3LxynpSVOC?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e97a8c08-6b64-4223-1375-08da651f7173
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jul 2022 22:31:34.8885
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iUCXpxPmTpMLsouFlgvIPIJ58x69L829MfSzswHb7V6fUJ56gZSOEHSMmoVDf0JviHaEkJ5DcgaQTsg6XoIZIA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB0010
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 03 Jul 13:54, Saeed Mahameed wrote:
>From: Mark Bloch <mbloch@nvidia.com>
>
>Expose a steering anchor per priority to allow users to re-inject
>packets back into default NIC pipeline for additional processing.
>
>MLX5_IB_METHOD_STEERING_ANCHOR_CREATE returns a flow table ID which
>a user can use to re-inject packets at a specific priority.
>
>A FTE (flow table entry) can be created and the flow table ID
>used as a destination.
>
>When a packet is taken into a RDMA-controlled steering domain (like
>software steering) there may be a need to insert the packet back into
>the default NIC pipeline. This exposes a flow table ID to the user that can
>be used as a destination in a flow table entry.
>
>With this new method priorities that are exposed to users via
>MLX5_IB_METHOD_FLOW_MATCHER_CREATE can be reached from a non-zero UID.
>
>As user-created flow tables (via RDMA DEVX) are created with a non-zero UID
>thus it's impossible to point to a NIC core flow table (core driver flow tables
>are created with UID value of zero) from userspace.
>Create flow tables that are exposed to users with the shared UID, this
>allows users to point to default NIC flow tables.
>
>Steering loops are prevented at FW level as FW enforces that no flow
>table at level X can point to a table at level lower than X.
>
>Signed-off-by: Mark Bloch <mbloch@nvidia.com>
>Reviewed-by: Yishai Hadas <yishaih@nvidia.com>
>Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
>---
> drivers/infiniband/hw/mlx5/fs.c          | 138 ++++++++++++++++++++++-
> drivers/infiniband/hw/mlx5/mlx5_ib.h     |   6 +
> include/uapi/rdma/mlx5_user_ioctl_cmds.h |  17 +++

Jason, Can you ack/nack ? This has uapi.. 
I need to move forward with this submission.
Thanks



