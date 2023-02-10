Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2449B691A58
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 09:51:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231609AbjBJIva (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 03:51:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230267AbjBJIv2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 03:51:28 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on20718.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e8a::718])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22B4780743
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 00:51:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bq5ZJ/xM9rod5mLCljUrERj7MRL1Fxfa24VI4KqKgm2VGodrCgaLvTjk1jlG4FdfYZwAcQjjjHdAk2Rcu5i74S7QOoJsCwJCxywSLtlKd93za5J6WMZkXViV3ivu2MlV76tyDTi0ITKEVqW4R9X8Mwy+vKA9rRVmvroQWVA9lSmwdBRBqLgIGLPZncU1D5iCGiVPTSfImn7WURV0wMEIuFA5eVFQtxPNB6C08nOBlKTJMgVWcreFW0jPp6qxvqd+KOvh/2Q9LWhHh5iCVZpjxGEeho3OCZPt8BJDBvASj7xnELM3CWY5ts0pBX/8APE8BDW2v0iWUghHjQSgm6RfLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K2k+RHjhN4DtSBYmPbZ6eYz6PW2HF+aXe6TvjTK3bHE=;
 b=i7zhtHI4s3f/sItd3jloCC3OfY7a7brXe+r1tZj0GpBRJi1Tj+csok/PgRYeXn0dck8iW9ZqHtLJ1j06MpEfXbeBw9fYo3c2BkuboU0yMrPJA5wWJmRyygasIFark+e0UK9B5oKNWeHWt64zs4ErrO+1SVQOH14qVvviZdz4pDk55JlzZfU+UtEBWsMiV0Iar9xP5U27JCYxEW2bXdxT1ExPbgpyhyE7J8JPgCPnCWGHFKP9CfLKLkPhtnucmDQ/knTCTPTRoIGMxU1mtfdWSaODkPwrlphd81EzVpyrBrecp+fZBexnLvBW3g0zjmfe56DKN6VJXrUpC1d/j946vQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K2k+RHjhN4DtSBYmPbZ6eYz6PW2HF+aXe6TvjTK3bHE=;
 b=PSKXQG6B2e0TxO7cBsetuIedokXWiwe9ShzBrUwXIL5mXRTMFHJ/zDe3956w3ecWbYSBFZIQTrS+vT2Ji19wEQugxk07dpnZla1VJBCIrDPvv08k50MI76SZadIjtSXBqTR9eO9u8vGGRtsR37+wiJpKJcCePHDzLX97iQd1mig=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BN0PR13MB5230.namprd13.prod.outlook.com (2603:10b6:408:159::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Fri, 10 Feb
 2023 08:51:22 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%9]) with mapi id 15.20.6086.021; Fri, 10 Feb 2023
 08:51:22 +0000
Date:   Fri, 10 Feb 2023 09:51:16 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, tariqt@nvidia.com,
        saeedm@nvidia.com, jacob.e.keller@intel.com, gal@nvidia.com,
        kim.phillips@amd.com, moshe@nvidia.com
Subject: Re: [patch net-next 5/7] devlink: convert param list to xarray
Message-ID: <Y+YFhKDN3A8EO/EA@corigine.com>
References: <20230209154308.2984602-1-jiri@resnulli.us>
 <20230209154308.2984602-6-jiri@resnulli.us>
 <Y+UjMZre+qzqO4Th@corigine.com>
 <Y+X37DzDakgVVAZL@nanopsycho>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y+X37DzDakgVVAZL@nanopsycho>
X-ClientProxiedBy: AM0PR06CA0129.eurprd06.prod.outlook.com
 (2603:10a6:208:ab::34) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BN0PR13MB5230:EE_
X-MS-Office365-Filtering-Correlation-Id: 14be47b6-1c5d-46f2-526f-08db0b43fc04
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HWq6l4CNOwvc5ES5vsBmL8byQ9LiYuPxKRyR9ZuPJF5Z3R2RKRM7Qjfjtg6knea2P6bg9rvA5UkYzqG8+j0zCw2Mq0wvid+tF70j0iI4WrtLh81CmVqECKETf5r3WTN2Y0usUFVqvgeMpMxsq/xwzOfPf7kazNgnPHnilPW/IOY+6/jx8mhS69WLPOUg8jvJJnFy+Y5vg4n7sw/3BdgRnZuofH64nerQ5OvpOMvK7q8rdVaoHrqH4+FhdQ0LgOFS/GvoAG+ZphozVn+Td5nEcz4pz8Ga+jpdKF+dGhwMbREBGwxE6spxNNLIAtxvX5lS96R9QRct4q1FsBqIj408RMTnsXoqXvQ9ggcw5Mx8583QfVoAY8XBzYizSLW8fOjXvlYUCCmirrYVt78VfiM9DDmtFJMOQh1YOt8yJAC8J3JUf9+pNc4TSR2Q5NGT6H/PHW+AJX1M4e+5uK0iyyLD34tVEqp7WC9AeykW401ISvBy1hqGn03eJVhyy5LYPs53aI4sd8d6H7ZAU02pxahRNtc7+hrgjj1dnebLDMUuhvzWibXj6N9x/J6cwwLfVuapVRbP+lkYSBpgzcmsJ099MElTHL3XQdzr9GfMzrfkzQCOLTcuaTa0v/jlvHUPVUL3bNpJiIK279Mc4X4th3kBZQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(346002)(366004)(396003)(136003)(39840400004)(451199018)(38100700002)(44832011)(6512007)(8936002)(186003)(5660300002)(7416002)(6486002)(36756003)(4744005)(2616005)(4326008)(478600001)(6506007)(6666004)(66946007)(66556008)(316002)(6916009)(8676002)(66476007)(86362001)(41300700001)(2906002)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3O9YvGu04K7zN38E7q1EMXvHDFHrG/7aMe/IJln+KW1EYzcZ8dki8aO7uyV+?=
 =?us-ascii?Q?po0rbmcPN6jaIGjsT1iPI3TDU2rVNaKQNEv9FZvbpLpxqcKqrQPTuZGjd79I?=
 =?us-ascii?Q?GJAVPsBHlpRGEJVW5cKqciQn0wLOQFTpqLja0eTlEoTIYmTHH09Nif333Xg2?=
 =?us-ascii?Q?uiB4f1HgnagD6ORHrTdQTedq3H+Z7wOihl/n/PN0iiPeWbGss/1XNe056LaS?=
 =?us-ascii?Q?T7RrVk/NemH76f/coOSo9IlUeMX+yzbClAJMzr83b+FRAmTl0NwVHHhIoKwD?=
 =?us-ascii?Q?t8L4Xl0wt4VWmQ7ikFbPaPcRkZhRJERWNjpGReFArgBfLFgLSeWi9cQ3W2bt?=
 =?us-ascii?Q?lPDWF8csrIXJ9kUWFSd2Fl7kJKbUw2IpmDogowaO/iJ2N+5GRRwWF4GzwPaO?=
 =?us-ascii?Q?b0zuY6dcLxazjIB20qqJEsVYV/2DY6NxbGzvm51Oz8GuaSPaJsVV2Pf/LOCN?=
 =?us-ascii?Q?S3vGXHeJBHSavc5dY7d9c8n6PAJHW5dASECE4rKXPpe/VC8aAwrO7F1qqjcN?=
 =?us-ascii?Q?fsR0fEVdrYJcEWMSTGXI5W4enhGUcHh++XJOnqfWWi+gZs+L2SBMvUHrnkDz?=
 =?us-ascii?Q?FnxLBdiSbzKS9fqm3iqBZDV7xAurywe4or8uePsDox33U9DgDTQqKtx22VtE?=
 =?us-ascii?Q?jwoiF4nIYtkrCY4r8VWT+kHFoqxyQZlwRd9F1LZgPISa8Mlb+Cqedac6mJNL?=
 =?us-ascii?Q?Wcjbq6hyobfPMF8o4lcxCbEfSk3kQwGsQlBZXSP8C40eba4Y9pwDIJ3R8SZb?=
 =?us-ascii?Q?KHaEFD/taWh9R50BIfEnWJvbmpDxGRCLuxrW/8H6BwGSy/16TuMZzUtTCS2k?=
 =?us-ascii?Q?XnUFKKllj7KLbhzzxF0I64isU2OWDWMMvLcc5W/aT/H2f+t+iZFoUO5O6ltz?=
 =?us-ascii?Q?hOmpkV5DQP2Asb0V4ifGSnObc+jLk7qIt1fYxbfGc4IXCBhIk81KIw46Op/k?=
 =?us-ascii?Q?UTz3bAxD03xetPc5BvnXhua2teXWqqaQ83PV4jFvXiu+N8+w370uR6u4sDa9?=
 =?us-ascii?Q?lb1khKfNYu1PSy+3AMf+Cq+HdZQcydm3JJ5f07siJ+HJw1v3jR39tFKkW+fP?=
 =?us-ascii?Q?ik7p35GooKtWN6YEMuKEX1b/52+Y+B+qSRD8hM3+yZ4IBK0GlpYKXgu4v7co?=
 =?us-ascii?Q?LiSPTlAKT8Q2UhUnguKAnaFIVkqltJuGMXE2aZGaWdHu6SCPeU1F7O/ZZyZF?=
 =?us-ascii?Q?1zGNIjZg0lADo3W1oxyUXCegPtyvztw00azsEu9xXhk2uNzNEzL7TspwlUqT?=
 =?us-ascii?Q?LnKbZREk2sodhWW17hbvCKDVwIQ2E1Wj3J9B7lJRB9ql3A1DDIUXnYX+ds0u?=
 =?us-ascii?Q?EcHLPFlLn8CRQTjuICBvaeCBTiZOxnsotZ1/pu0rLRj3yGDODhe0PYji3/mD?=
 =?us-ascii?Q?w0/cE43HevkrSeOJPdGFHvT0mrLC3gn+FqxH5ZhwAZ6CqrBCn/iPXIbWwr5e?=
 =?us-ascii?Q?20z01NILcVMQ0icdPApupJk8JHbY7+C2CS0ofOJS3gUjYDXDqNAOpiViN+tY?=
 =?us-ascii?Q?DgMxq59Bi23F/ABAD6CXJlbIXBEhNv01KE4aK7uD0P7V/NMNwYAzM1MR9UYN?=
 =?us-ascii?Q?9nvxVHwdAmToj7uiZEIlnLz+VU3dVixilJl5HJwQXg1odimoBO0EIDqBfrGl?=
 =?us-ascii?Q?uL2kDMyicMJ2cY4VOfEG1p17N1AnCR6ym+jFV4+jl78Oa+2TYRmfgb1sKITJ?=
 =?us-ascii?Q?lqX2Ug=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 14be47b6-1c5d-46f2-526f-08db0b43fc04
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2023 08:51:22.3944
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W6dMvycsUImdGQjw0uIYS2mGqBoV0ZoO/30w9k9I1ktBptnd3dkBOEtQB7h+hN3rhQmcpqshMVh+eQjQVwWawABrUrgCXK/VY20owScru8k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR13MB5230
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 10, 2023 at 08:53:16AM +0100, Jiri Pirko wrote:
> Thu, Feb 09, 2023 at 05:45:37PM CET, simon.horman@corigine.com wrote:
> >On Thu, Feb 09, 2023 at 04:43:06PM +0100, Jiri Pirko wrote:
> >> From: Jiri Pirko <jiri@nvidia.com>
> >> 
> >> Loose the linked list for params and use xarray instead.
> >
> >I gather this is related to:
> >
> >[patch net-next 6/7] devlink: allow to call
> >        devl_param_driverinit_value_get() without holding instance lock
> >
> >Perhaps it is worth mentioning that here.
> 
> Well I do that in the cover letter. But I will make a note here and in
> the other patch too.

Thanks, I do think it adds clarity.
But of course it is up to you.
