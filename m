Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6ECF68FBFA
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 01:27:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230347AbjBIA1Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 19:27:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbjBIA1Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 19:27:24 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 080F31E5F5;
        Wed,  8 Feb 2023 16:27:22 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=inTbE+DmWmB/0ojSFcodSKSMtG7QsoKHGa/OCk3Jmc7qM90zIVVbpeBPRu+kNWiCrmUTWdc1aQ9rR1XICIz+/PvNbJWjtypOhshSfYDVWGw5Z3WMA1scqQ5i19Xrbq3gMAMBKYAscvg7hy9Oo1Cq8jW1dTwqzelPZRrSKluBnrnJCvQfTR4zuFsKTG9Z7xtcUm7VT+W3vsCCee0JOne5wXTsGPI2AFFliIg1L0OR3rgKsJTt4Kbdu4vXZuaUKdt+XaiaWkTSw59Hllr6oFSkj2cGqL6LaS0J0pEIFNBRK63xerxTeL2g4h0RJJYH+xtLgxE1+gfIf7jzZsdq2ubuQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ByD4u/hC1SxEPhOyWboc2KfT6MamP7fdSIAJRbLAHbA=;
 b=Tn49VrY7c1GfgAx5vcb8btahO7XzsfrKVIqbwqdE0wxZtBtLVYZaCUD2rd4jkdfrqtdgsxSNNaWx2JhPbezVtqMzVZt1TMfwUtmlMmKiIJJtG1NBZu+bEQzDMWz9GTAqNh3RCN5c5g+yEFQG2PY20FNYX8sUw4mBs9tzTEkdtgIG3k9sGkNFNZ+pk6O856Z4bAMTm+WYXiWs72/7xDKeo9u/vxWtejH9j93imrjixXDXH/FhxSzNSbaEsCft+XU3EsDMXMjiCeUHn6xb0MpKTE4y+KtaCqzqaRAvXsmQzff/0VRmtL5IFhcewyIfdFUrpCquvIIOWgxxZqDqh0DjrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ByD4u/hC1SxEPhOyWboc2KfT6MamP7fdSIAJRbLAHbA=;
 b=Pk1l2Hu1aHH3QeIJrwMgJ+SiXOITtszGV6zMn32JNc/cBdE7v2HmRyTmAUnZ0nH1Iw328BVTwU19D2XL2ZvO52xd+5X81GbC1jRotUxs0p7WPyDGjxnpcAuAxkfiSK7bkZWcMXU2QZY8Ai1mvFdFOh6GjIn5iiY+r78iiaVZ3mhVPfTYhyLedTwF28M+xRu2jIYQ4ZXN+5Al753qekhXnBSuwnnDdaamMV4XXEtHuzp/qupKx7I1BFUG+29hHcicx6XMtBqyObWG3WLVvArhmo8WE5CriAOpfCuCo+f3f/eKpq8AvFC8vqhfAlB00zLbbUjtsEOuNrc3Kt8YBU4Wbg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DM4PR12MB6230.namprd12.prod.outlook.com (2603:10b6:8:a7::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Thu, 9 Feb
 2023 00:27:19 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee%4]) with mapi id 15.20.6064.031; Thu, 9 Feb 2023
 00:27:19 +0000
Date:   Wed, 8 Feb 2023 20:27:17 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Saeed Mahameed <saeed@kernel.org>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: pull-request: mlx5-next 2023-01-24 V2
Message-ID: <Y+Q95U+61VaLC+RJ@nvidia.com>
References: <Y91pJHDYRXIb3rXe@x130>
 <20230203131456.42c14edc@kernel.org>
 <Y92kaqJtum3ImPo0@nvidia.com>
 <20230203174531.5e3d9446@kernel.org>
 <Y+EVsObwG4MDzeRN@nvidia.com>
 <20230206163841.0c653ced@kernel.org>
 <Y+KsG1zLabXexB2k@nvidia.com>
 <20230207140330.0bbb92c3@kernel.org>
 <Y+PKDOyUeU/GwA3W@nvidia.com>
 <20230208151922.3d2d790d@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230208151922.3d2d790d@kernel.org>
X-ClientProxiedBy: MN2PR01CA0029.prod.exchangelabs.com (2603:10b6:208:10c::42)
 To LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DM4PR12MB6230:EE_
X-MS-Office365-Filtering-Correlation-Id: a8477da8-8220-486c-6bff-08db0a346711
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JUr1bo92hnPtGH0Kw7C3/LedW55Zy/QsvGaYfqoVIJw8VLwqOpLZ5IXf1G5mbZMudAFwBNGUxjdiI+cMqvGm6FWfXFzyZLmbB+XBveokLS/9abR1xK9SY9OW4yY06w7O+o46aIo87ldbcTPGn3uHV2rhH9ahCphCFB9EW4Azr0d3xUNs5X4qkEGCIFgN6Xeg5nkqnh3FTQJxo+a3j+9+N9HR3ieZVFZkpJDzB8J7ER0m3XpKPgL3/xBf7loThv0smIE0DEHBACB1f1Gj7VHrLM2qsKf0DBV+dyGaHrNo+Nl9IquHsI8StXv9PGJLY68XaoARppqkMO0c7MfWxkIbTpYAYRspjESK+Mwpgj3kZobZbL5+jJGNzq0H6Hj/1MnM9SUo/UYnMDbHC//LZFbdkw5i9vC8feaVm0cDYV3rutUop6nQpxuGa7d04WI6ii0uIY/2WcMC3q54/8sXOCdNHwKoso3yvE2RgDB4btekCMTX5ATXdtp93ZrQzqntq8GgyUlNxOLcLU0LBmZr5pWqAaJfuOev6nKYMQEgsgm8wTiR3hfCeoR4O7+5zGZOooT8VccmbMsJlqhegtkbH3YX+hxV3bh6ryITs1yVvHEx3j7IVFBiymlN/89URZtka7hk8qnHiVRdO8WEMVWGRZZmJg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(39860400002)(396003)(346002)(136003)(366004)(451199018)(6486002)(8936002)(6512007)(186003)(5660300002)(26005)(66946007)(66556008)(6916009)(8676002)(4326008)(316002)(41300700001)(6506007)(54906003)(2906002)(86362001)(478600001)(66476007)(36756003)(2616005)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1/KOStkw9dW/rzHVBRdzZXrNgVxEqj/B4JGjvk9QqDE72sOyaeOtWsBlOj0J?=
 =?us-ascii?Q?XZGY4uwR7Kdj9xELUi7BCs65WLz4Aq6QSLWdenV/8jpSpFTHTj0jvXpy7Si3?=
 =?us-ascii?Q?IPNFVdXuWWqMY6nzBRNUiLPyMHZ8oazpZ8iSNNZxoT2L1nzGXc5vS4zoEALB?=
 =?us-ascii?Q?taJivrMFbhXkFmv8Pro0IbWmdp9J7pO+gOAwNFNl6qaj+KkFlpTHlZwwrxs1?=
 =?us-ascii?Q?HOFnwLvih7eX8+l+NwrwW2EVFJR5L7mdo/6lDIggDH1y2ZiZwdijKNHMhlR7?=
 =?us-ascii?Q?CjY+PO96lwHx9NeECDj83wPDV7qSE8iYdeiZXh5yLq1/gyDP288HkZj/ZhBZ?=
 =?us-ascii?Q?e0vbqhOEJ+YLuJC5mLlcKMf15SiFtGpEHv4o3zD9Pla2xWN4Lb2b1xEmmu/U?=
 =?us-ascii?Q?rcDEzKKST8KRQZegYM0I2egYofnkDOJcccxWVcVOkzOLAP9vYOs7qWJsHqCG?=
 =?us-ascii?Q?bGx81xOBMBiOYAo2tWQh675MfM+i6MEjhb+K9xJuEujUD0ZdWEgsQp24vYVf?=
 =?us-ascii?Q?Js1qeXc24JzTCk5uvF3ZmKBQAJLmNzPTlXd+AAPG17oiSLhIqQdvRhNcRJS5?=
 =?us-ascii?Q?7Zx5yL3LIxtaVwkqnaQNzBX5djSvh2lg24g7QGfBmp9gOP21mJ7ZJfVvjRZv?=
 =?us-ascii?Q?0vUuIfFHDEdSoRbSO3NyvgKEQxgNELXIJkb632m7zX3foLbKX+Pr34dCHKK0?=
 =?us-ascii?Q?2avL50srvpNVupCE16gHCnMZaNtMFdUmy7o68+4+fGjUtUo9B+48eEzj0pcX?=
 =?us-ascii?Q?G8UyRPJs2hexphlwtvsGT+s01Nlkm5dP1+1TnVo4IAu0NHkQKAGRk+Kd+aXt?=
 =?us-ascii?Q?fjV7GdFBqSfCdZejDSQOkStd3HR/Ax0nMBldL2PhxzhCyZ90OpoFta9p5Wuf?=
 =?us-ascii?Q?mzxsvx0r/vYZkhI5381dJjhS5BpIW+o/GFk4XmNKPVKUUkBMY7+E1v0Uisa9?=
 =?us-ascii?Q?oBxp6ah5vfRRHbG2a8gsmOD/2sYUefA7En1WouIAE7cdEMcMsGHGmjJK6/TX?=
 =?us-ascii?Q?EM2Mg8Mv6iXY4ZpcK9FOVIbXRs0WzS+C0T4Q17MzUWKIk0iNDC1kmwnPZvIF?=
 =?us-ascii?Q?xyRMNC8OHO2caVFqW8XrHzUUQc7L8iObHSlVCjPTSZJyJgKTbI11x5qBYaFc?=
 =?us-ascii?Q?rozc3M3Qny9923C7xABWCjvus/5lVg1aNEb0qb01V09xoPdUsxTDN4Q8k9Ak?=
 =?us-ascii?Q?Jn5rcjmuOkEhfYf4UM3lGMp5ctN38y0psVxD35vliNHZsdnee/9Xn1qwCE1u?=
 =?us-ascii?Q?VB/ThOPNIBUg/Kbi2tFCcW6FDs0QmyStqdq+SEW06zDcOVIchxCUcAFCFcSc?=
 =?us-ascii?Q?epQ92uoKJ7pGLaMa2hwE9w47fM1QPN6XDxAGbaUoRTPpertLqOqIKRzx0TWj?=
 =?us-ascii?Q?+x/6okrWu8Wycw3TFFucu1utW/Mt8mjwcKyskmErq0CqEaUMuylhpz9Dr/v6?=
 =?us-ascii?Q?09dwZiWCY+RZGAuwuc7IqW/YFzwqfyYTD4LgJID72hWmrBtomfZkQXWqj5EH?=
 =?us-ascii?Q?QFJr/pngeFnIoaPia1IE//l9ZK7EGkExvcgl3R1o+R8QnTESk4HSUhxZLujn?=
 =?us-ascii?Q?Y/rD6xVj+Heyt01bGu0Lf2xd3U1RNJ2tbEU69wV0?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a8477da8-8220-486c-6bff-08db0a346711
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2023 00:27:18.8703
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TOfXF9aVD7ZJ8miMmXsM1a9O+sDdA04zC3Yshom6iCx4akcL9xIRwJdggqHXyJ8K
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6230
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 08, 2023 at 03:19:22PM -0800, Jakub Kicinski wrote:
> On Wed, 8 Feb 2023 12:13:00 -0400 Jason Gunthorpe wrote:
> > On Tue, Feb 07, 2023 at 02:03:30PM -0800, Jakub Kicinski wrote:
> > > > I also would like to not discuss this :)  
> > > 
> > > Well, then... Suggest a delineation or a way forward if you don't like
> > > mine. The circular conversation + RDMA gets its way has to end sooner
> > > or later.  
> > 
> > I can't accept yours because it means RDMA stops existing. So we must
> > continue with what has been done for the last 15 years - RDMA
> > (selectively) mirrors the IP and everything running at or below the IP
> > header level.
> 
> Re-implement bits you need for configuration, not stop existing.

This is completely technically infeasible. They share IP addresess, we
cannot have two stacks running IPSEC on top of othe same IP address
without co-ordinating. Almost every part is like that to some degree.

And even if we somehow did keep things 100% seperated, with seperated
IPs - Linus isn't going to let me copy and paste the huge swaths of
core netdev code required to do IP stuff (arp, nd, routing, icmp,
bonding, etc) into RDMA for a reason like this.

So, it really is a complete death blow to demand to keep these things
separated.

Let alone what would happen if we applied the same logic to all the
places sharing the IP with HW - remember iscsi? FCoE?

> > > So "Make it all the same". Now you're saying hyperscalers have their
> > > own standards.  
> > 
> > What do you mean? "make it all the same" can be done with private or
> > open standards?
> 
> Oh. If it's someone private specs its probably irrelevant to the open
> source community?

No, it's what I said I dislike. Private specs, private HW, private
userspace, proprietary kernel forks, but people still try to get
incomplete pieces of stuff into the mainline kernel.

> Sad situation. Not my employer and not in netdev, I hope.

AFAIK your and my employer have done a good job together on joint
projects over the years and have managed to end up with open source
user spaces for almost everything subtantive in the kernel.

> > I have no idea how you are jumping to some conclusion that since the
> > RDMA team made their patches it somehow has anything to do with the
> > work Leon and the netdev team will deliver in future?
> 
> We shouldn't reneg what was agreed on earlier.

Who reneg'd? We always said we'd do it and we are still saying we plan
to do it.

> > Hasn't our netdev team done enough work on TC stuff to earn some
> > faith that we do actually care about TC as part of our portfolio?
> 
> Shouldn't have brought it up in the past discussion then :|
> Being asked to implement something tangential to your goals for 
> the community to accept your code is hardly unheard of.

We agreed to implement. I'm asking for patience since we have a good
historical track record.

Jason
