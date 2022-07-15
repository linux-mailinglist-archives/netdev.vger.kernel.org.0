Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42BDF575D03
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 10:08:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231589AbiGOIIW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 04:08:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbiGOIIV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 04:08:21 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2089.outbound.protection.outlook.com [40.107.223.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ABE87E80C;
        Fri, 15 Jul 2022 01:08:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UxuDu+Iann7zCLzJB1uciyw3SvquTLi3f0nNrIBz7KxbH6hXM6OJiRfzEUC61kOj0argGEA2C1upyIRQsMB2MWwjrve6atGoLTdCsM9zpriyHrqYR28VqIDvlos5lF3EU3WDKE50hYxNbGU82qDILPcmo9ncfHnRYOUO0DyvP8IV9UsdFjejQy+7vhJcs6Avm4xIy5Kt49+pJEKvzMEdLfxFzvE8MrpFJcisVLviF4Ki30EbfcaWBcQ0Wv5GlR/4yL9zxqTUSBairfMnKxDPaZRY7FlWXlI7JbZ8IZwcUPvfW9nTbVXtyQk0X7n9xbo0h1g7Vo8sP7VmAl4oKRB0Sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1VHMJ8JZ0zbljW7SbCr6XszFZk/M5TuMosh+7Gau7vM=;
 b=Zfr+fexYGeHmSN1xk9zxIigFaddcCW2meLcA2HSgcPM+b3LtEUise1Q9ELLcpqL7/uu0t3olAj/CNY5GJN/81BITMJCXbIEOHfXEDRuGvU25ETK7cLRsUvJawKvnNBZjGWAe9R6GBcGmPXxCwtC6WLV2ZU1hY5Fey+DzEhme4JWbIE2J/A27HZL9BlctpiHH2+W38hkYGBRDM0n/2mJfZq8Xu00I/isPmT+xb+iIAwtFpCb43j7H4JB9jnQXJOKwcleXRqsE76G5GrudxNv1aeS0/DOTIb/qhCRIBt+5itAwGlLwjjjt+P3Gc/031GQ6x/5mYGZMKKBncHgYrsfE8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1VHMJ8JZ0zbljW7SbCr6XszFZk/M5TuMosh+7Gau7vM=;
 b=ELVerD0YwxNaBx+ctxYi4X5XZ3ldAFFLY6/MQxFXKR/W/xHjb9QdNPa5iWp1iVSWFTI4WyDSMimmfrJTCkpOQRXu3ttIAePgsGOBYNJ8PKPuCyVX0qUwjgikZt416OfULp3vYlGYnCbHV+BBdrHfBl4OK+W7WL7fmoqWn229TRkrb+JExjOHNxa31xsEBdrrGsc9jCPvZqHqDvm9AHDSKoenm20Z9TpDwus1q+5YopMwyjpg0Xmv9rR3SMVR9iYFlgeiKhYd/CAIjihPCkFoI1aj3wEaZ/NyM1XZA0ZIbWD2nFWKCgGWjsUdhn1B5L+PfI8wJ8Tsk7+bYs8pGv8XsQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DM5PR1201MB0074.namprd12.prod.outlook.com (2603:10b6:4:57::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.25; Fri, 15 Jul
 2022 08:08:19 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ac35:7c4b:3282:abfb]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ac35:7c4b:3282:abfb%3]) with mapi id 15.20.5438.013; Fri, 15 Jul 2022
 08:08:18 +0000
Date:   Fri, 15 Jul 2022 05:08:13 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Saeed Mahameed <saeedm@nvidia.com>
Cc:     Saeed Mahameed <saeed@kernel.org>,
        Leon Romanovsky <leonro@nvidia.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, Mark Bloch <mbloch@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: Re: [PATCH rdma-next 5/5] RDMA/mlx5: Expose steering anchor to
 userspace
Message-ID: <YtEgbZh63bs7w0v3@nvidia.com>
References: <20220703205407.110890-1-saeed@kernel.org>
 <20220703205407.110890-6-saeed@kernel.org>
 <20220713223133.gbbt4fbphzpc42hx@sx1>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220713223133.gbbt4fbphzpc42hx@sx1>
X-ClientProxiedBy: LO2P265CA0223.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:b::19) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9df7df07-1850-4e65-c7ba-08da66392d18
X-MS-TrafficTypeDiagnostic: DM5PR1201MB0074:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Um5M6uOMGHK1fi5cyD684WhqzZ90dcgndSWduKlqjvdzq67pQIUIIQ3DK85Aq668WHh2vv0+x1xAes7xMvGXFeKfjOo4IkFfmGchbi39ZACwjdAY0zqgy3sLwT9ONd/cvq6ozU/8KG4jc7ux7cO9IvQm+xeWGNbGBYuBVKeoxjy8E7LzNiryJea/5eA7f2mrim4JRw67g+9H2fQ/v03zF74EHT8/AaNr83sSwpQMvwQvP14k65MUjprKVtJU6LHIC2gaj9IqxFh4Zcvo1JWllsJUQvUIA5wCNhnr9tftXMT4xLBrd8lV/WtOq+bDw1f47pdSFJD6mtCQY+lu+5MlI5KHzGuCp8Tj2Ou7OxZosBL4c2lxteWAux6jZIk1ctVRiU6guMolgIczNqmSacUks5/HRHoTA6HiYeZB7pTKMSFRPU7jfdUYtl3eqgKuoG8H2qL8JudF2diDvC5k6iynp6h/zaEf4psSFn/tMjJa9dIk9q13Z9i/M0YbbNostG8yufIuY/wSRWxU5t4K5Im/DXlOhEqZU5svvVVSdVxzDKApYI26euo+d6Hyxa1aE3kA6GGW+14twN+cz/f/ZpwmN12E9AJyUADR+genmaWXd6WlYsCGfmdhMenfeqP4PXjeUPuFbpsdoYATUAMvGyqJ3jXknDKm7o2TGs66sqJsXQUHf37uvYfsc5RAcINH9EiJIpK+MR5OyHbcdP2RLaXDrQPXxgItqoCnwWDed9aNSCe6Gej6KDFQYCfsVpXP9CH+
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(366004)(346002)(376002)(396003)(136003)(2906002)(36756003)(83380400001)(38100700002)(6512007)(186003)(26005)(6486002)(107886003)(2616005)(6862004)(316002)(86362001)(66946007)(54906003)(8936002)(4326008)(66556008)(5660300002)(66476007)(8676002)(478600001)(37006003)(6666004)(6636002)(41300700001)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Ie74bqh8NpEr3Da41kMf119shC3uAcb6GlK5YuZIsAIoAVvGkR7FXYQvLERO?=
 =?us-ascii?Q?e1nQOGPmszo1jTCXOAOQefMm+76D6z5Sg7is2qvFTkMgFtrHuh1geAZTe/Dz?=
 =?us-ascii?Q?R+CDOjO6s9QZZ7FdUWP/Cc1gj/hm77eMDv6UI8ZmrUOo9Wkw7uEWQ4TziH92?=
 =?us-ascii?Q?XiVqxUJjztSPzimCaBrLdXlkE8NQz/QQhvlMgLIcdDmQe+AYJX7RyeOqp+gQ?=
 =?us-ascii?Q?3jzSiz62OUH6hh7Dy1XTIsO+gDYZsPfFKMxoiOjjwC9Swu1Xfmg5Mrzz2ZGy?=
 =?us-ascii?Q?P6auoznOHiwREIlTQMyspRQTFvOt6QbpOiK4NUdHy4O37nxtfY/GqHO4aVod?=
 =?us-ascii?Q?ZS+cFQp1PmkidudxWlKfCJOUDIg59mNo6ibOOJSCNadIwsjQRe4ImvryU1w3?=
 =?us-ascii?Q?fr9lVKrhsExlC51ey1DNKCZyzbItHBFEIcSrFK+0APo1devkcKqD3v69BOeX?=
 =?us-ascii?Q?tpt7GTz8ysPVGkOeb2XS8M4gokBkUx6WObllGvLgpsZdsquAH+j/BSC4K44+?=
 =?us-ascii?Q?RK0Jf1/9Cf1wv+V+WFB8J+NFZ/d3O9frEfbWG3EWHJ2UFXkaFDNcLtl3U+em?=
 =?us-ascii?Q?QogIym6xQTN2LRG5xOGzkn1qVAa3BkFaQwBg7zEAQXwuJZ+je1L3/4vYLVI+?=
 =?us-ascii?Q?OhaNYB/iKcOMdl34aonJzGYSvUoFQj+uI6EaDeLPyUScJJTwW0DNXUWlRrNs?=
 =?us-ascii?Q?DsKk5Wf5ZwT/W+LBf7MHBCRf49dJdbGfCdyNih2WuhkAAHnwJ1q/VltvSdE1?=
 =?us-ascii?Q?iHx6ZEL6hnY/gKygJSVXdMPHzvRuqtL3NL+aVEBwENpqPe5wXQZcr8PA4/K2?=
 =?us-ascii?Q?kU/qFApRHCJUiVN29Y8rnYhxPaBhOZdSv5JoFphndJJmzgMqvyCQPBK+LM6D?=
 =?us-ascii?Q?SXbeq47u66T2hGY+ApOYDTl/8h7JDv7wgVnj42U4djAcEoOXtVbRmWSVcfgf?=
 =?us-ascii?Q?raWevN9BU6HTJmDKWLaOa4jvndGLaGe3c3afUfcHgnLb+7qOh/LxGwv8zTnZ?=
 =?us-ascii?Q?AUJEMVfen1E7pT+cKaM7px80maVg5FBb0O8/QeqHEtw9x5wz9Kh2JP7bk2Oi?=
 =?us-ascii?Q?jZKQisVCxzpzgJoOKHzbypxdf9cs/O3a5ra/eGmDxG+1G8cw4N7vQ06LJPW0?=
 =?us-ascii?Q?BO2s/Mmr3GVknNuuWCWWhgLlJB5XkF5BCiSbk6/O26chOC0DSuipXf6VdMCH?=
 =?us-ascii?Q?IKXOhiz0hqwmL21tbdyBvEY4Z5L2X+Z6DUKXk17nPx5Sr7Ned2nTdJacR4G/?=
 =?us-ascii?Q?KoWpcDdzr8DB2MfIBYdOtCjpAsg2doSwkSW22rYVwW8gANX9xs9Jc4C3vLLU?=
 =?us-ascii?Q?PBeJKdel6USAY5hDG+KRW50orxECZhFP72TBXc6OkOHrwYKsDREDKSmQiTpC?=
 =?us-ascii?Q?niMVcvIlf/C0A2uR/a36/kK+5P88Cmbx9QS+hYIDZSmZwOfpTwOSs+IDZH45?=
 =?us-ascii?Q?gNkhHVm1SxiqQ9h8sxt1kipJsrWtaOYH9foTnAHkdM5XwynJ3P4oE+h9PM2U?=
 =?us-ascii?Q?EHxVkO0QremIrFKPfjfprZVM2g1mlWkYR3h32gMczNnhMuyGyJDDnDqkVX3E?=
 =?us-ascii?Q?Dsh+qvOMeg1rkmcOu5IJfEuNQk4rU9mXlXrQFFJV?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9df7df07-1850-4e65-c7ba-08da66392d18
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2022 08:08:18.3207
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T0w0Yy59p+246uvhq7m1D9U1c5D2ucm5/qj8JNqp5pKFpOjCv9HKPjq2WZZS7rsB
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB0074
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 13, 2022 at 03:31:33PM -0700, Saeed Mahameed wrote:
> On 03 Jul 13:54, Saeed Mahameed wrote:
> > From: Mark Bloch <mbloch@nvidia.com>
> > 
> > Expose a steering anchor per priority to allow users to re-inject
> > packets back into default NIC pipeline for additional processing.
> > 
> > MLX5_IB_METHOD_STEERING_ANCHOR_CREATE returns a flow table ID which
> > a user can use to re-inject packets at a specific priority.
> > 
> > A FTE (flow table entry) can be created and the flow table ID
> > used as a destination.
> > 
> > When a packet is taken into a RDMA-controlled steering domain (like
> > software steering) there may be a need to insert the packet back into
> > the default NIC pipeline. This exposes a flow table ID to the user that can
> > be used as a destination in a flow table entry.
> > 
> > With this new method priorities that are exposed to users via
> > MLX5_IB_METHOD_FLOW_MATCHER_CREATE can be reached from a non-zero UID.
> > 
> > As user-created flow tables (via RDMA DEVX) are created with a non-zero UID
> > thus it's impossible to point to a NIC core flow table (core driver flow tables
> > are created with UID value of zero) from userspace.
> > Create flow tables that are exposed to users with the shared UID, this
> > allows users to point to default NIC flow tables.
> > 
> > Steering loops are prevented at FW level as FW enforces that no flow
> > table at level X can point to a table at level lower than X.
> > 
> > Signed-off-by: Mark Bloch <mbloch@nvidia.com>
> > Reviewed-by: Yishai Hadas <yishaih@nvidia.com>
> > Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
> > ---
> > drivers/infiniband/hw/mlx5/fs.c          | 138 ++++++++++++++++++++++-
> > drivers/infiniband/hw/mlx5/mlx5_ib.h     |   6 +
> > include/uapi/rdma/mlx5_user_ioctl_cmds.h |  17 +++
> 
> Jason, Can you ack/nack ? This has uapi.. I need to move forward with this
> submission.

Yes, it looks fine, can you update the shared branch?

Jason
