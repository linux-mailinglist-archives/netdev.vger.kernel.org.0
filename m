Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF48068FC4E
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 02:00:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230422AbjBIBAK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 20:00:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229938AbjBIBAI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 20:00:08 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2070.outbound.protection.outlook.com [40.107.92.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE08A233E0;
        Wed,  8 Feb 2023 17:00:06 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VfG6f5VadH9DLcEhV8KHHRqZ7dglzXZhVla0uo3Eh/wJm/ICtVyBDDLq/Uzup+iX9pVn4U0cSRGqDaIUImo8991Qo23KrPCXBtD2bqvLTn9r/QLGTnWm3VXP/ci3xjvothVeRPCGBFNi7mgL30bCqePSBr/c2mlKzzw3WjjPaXBQhdu18zZFNmitO+fmN1/hM0r4eg3BNlZbe65pBy+8fKBdNrhaQkOb/SgNyT1ih6JSpkQmQb4+abxbNtjuTCiMhesU/zF4MbZt6KvMApcUPPvHGf1Vd5tvrazJG/qtvVGvcxhaPHFImASmnnkTbfR/w3WwxJPlMyIqQzFdd+pd5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DbCdEsUTopTXrdS/REb6vgcEkTKAG1qFaLPuat4itng=;
 b=GojYuYpgcVN/KPO5JNQDHRsx37NbtebZwOUPt7T6g7MCEPGGv6eGB7oLbDtyjAgMtCzClpT9mFd15XJtwm4ba4/KrGcjLEDX04rI5Xt/1EuKdzQXrV2wKeGn9z9EDD6kiC227sn9NV8/GjxWDAt2fxhbO6pSRGbe2QrTuZyL3iplAtAYwWoiyDtdoejM1D1EfEd4okfAeEvoTVquKtw8H3ME41To2kNivcerAhHOUUU0ASdkEXzHsHI6XGYOUaa3ozGvzEjfdQlhvMZJn+sFHYBX5zIxWQUK/aRTC7yvnQUF6wVS8aGNPWl92ajYDfUi6H7/419ztnPzoa0JAF5wyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DbCdEsUTopTXrdS/REb6vgcEkTKAG1qFaLPuat4itng=;
 b=ATegeWNZ9tDNeCosWEzYm5LI90PL+sXsqQrlgVYlvRXmVPiL1yt1HDRQd2qwiX9FUQqffUvPMsBi+m6cZaAjw6ZCbcVWP5QccfkeDKFmGY+AZ5OgAvCFSLeqlvN7yivWA6kiA0J4SOohBo3rBrgO1ylgZMrGTvtjI/FWpuyZgFWS7wfz+b9ZChJ8++ztHc8EVDHwkjPbGpIZEEbDuEMgm1pKJdFh4lMDf7B4MrotyMzF1qUeBzcUE2RKQ4RIy66isnX0w/1d/0AqeFm8tW3/hR0dgGd1GRda2R8wn7vovLp2GENcXKkNl0+mFc978gCD2xkAvhSXf15TSmcKQpfx4Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by MW3PR12MB4442.namprd12.prod.outlook.com (2603:10b6:303:55::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Thu, 9 Feb
 2023 01:00:01 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee%4]) with mapi id 15.20.6064.031; Thu, 9 Feb 2023
 01:00:00 +0000
Date:   Wed, 8 Feb 2023 20:59:59 -0400
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
Message-ID: <Y+RFj3QfGIsmvTab@nvidia.com>
References: <Y92kaqJtum3ImPo0@nvidia.com>
 <20230203174531.5e3d9446@kernel.org>
 <Y+EVsObwG4MDzeRN@nvidia.com>
 <20230206163841.0c653ced@kernel.org>
 <Y+KsG1zLabXexB2k@nvidia.com>
 <20230207140330.0bbb92c3@kernel.org>
 <Y+PKDOyUeU/GwA3W@nvidia.com>
 <20230208151922.3d2d790d@kernel.org>
 <Y+Q95U+61VaLC+RJ@nvidia.com>
 <20230208164807.291d232f@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230208164807.291d232f@kernel.org>
X-ClientProxiedBy: BL0PR02CA0140.namprd02.prod.outlook.com
 (2603:10b6:208:35::45) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|MW3PR12MB4442:EE_
X-MS-Office365-Filtering-Correlation-Id: 7d6172e0-01bf-4614-0f92-08db0a38f81d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Wwjv1cwm1hU0eShQL5cLY2SAM6bpTs40Hk7ZXeESLuCQS0TKvGdv8df7qxISkkeJMUoPkPwx28LIlfhFleYqX+eC+IO/5s1DloZrUwPEpqaXvXOppFRxsy7ju0ZzsK8TgzSV9mVQhPsEQ+V1cXRoUH5LHLd/H5z3gjpDqKdLEm5lFC0xa5fH1Ppr8oRy0ToLruYpleuvQWm0cjvwyIUP29KRmKY++4w56+b3s3kWYpAZgJ+lZ72TW+y+aVccKs5BJ94139iiEN0ZNju1FGXRvWkIEPp4qmwmO0rsrUFcRl9rBueNxWDojS0sL6fIOYL7vfjzLz/uoWsVQE8fgEHVME/98UjCSEfIV7Fz/a0W9t068LTM9ZXA/UllYIe6Mywz2Ig5A8otezN7IJ6NnH6Ufu1TkFugQUcXix55NxsxzIaPQEl8vXcqLeVllc/zXqDnsC/hmSLoIPuarPFhu+qA0UUWZtXw1IgtsAA0HGSXse41gGqOBCsXnu9tep9vqYEWZqKDZKBowtVTjFzMwebvEVokaHhKpmTBiMtvdGN01OyVrEPREFINJRJH2008RzWfBCnimE6Aw0AQpAKGz9fYKSje+YZI84LFWhk5/KVsfxukPotkx9XYd2+uUN/wkMf1P9X6fVOoxWL/bZiYPl7udDWcWWXsaQrBWnwskyFFtYYqZ0SFgaP2PgV+awjSoGDS
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(376002)(39860400002)(366004)(136003)(346002)(451199018)(5660300002)(36756003)(2906002)(2616005)(38100700002)(8676002)(4326008)(66946007)(54906003)(6916009)(66476007)(8936002)(26005)(66556008)(41300700001)(186003)(6512007)(6506007)(316002)(478600001)(86362001)(6486002)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9qF+rf31D7/DgYPaUPT5MUHrs0g4MRm8ABvwDBA147x+9py6FYJz/OPhaKB+?=
 =?us-ascii?Q?T3dEv6vi5BHn+4rLBCNVJcdZZKuuX18/NbIVb8RBO4Ar1G1RObXTVvaPJmMU?=
 =?us-ascii?Q?hc6WFs9Tpj1fxabLuhSfX7HZ8ucvMg87A1LpuZTm5kdL4zERhtK1Ni5SvLun?=
 =?us-ascii?Q?JYHS+pIHOU3g6Tvg1MJjLxygzduYoiXet2VHlF5qhOZP4IgsPDORd9P6urak?=
 =?us-ascii?Q?RTpHoWbzOut18Q8sP/Day6VaL5Rl6FGj58Q1agDQiv9B/dzVVxwU66M45nSw?=
 =?us-ascii?Q?/Pr1wxuMAq4mfZ+FStLNXBPiKSGnPdjS25/6owAZFcQiU/y9yMD/hRKJKDlp?=
 =?us-ascii?Q?o/MNG1eUV7avjsha4l6ENxOyMA0FtRrQyfyoiIonOFs0GU9yx+ufrD+mp5MG?=
 =?us-ascii?Q?2DfbLFOaA5g6aBsN8/Jp0BRRf4+mBBOjVSOor56KtZACLoapdfSqyHqhi8O9?=
 =?us-ascii?Q?/7hmClsHbHWH5cElNoFRY2DuzNzaU9f5RxI4ew7tY4a9Q+ZS+V+BlN2hy2/f?=
 =?us-ascii?Q?NOv2O05sHj/Nkm4Gosk6/YmAS96YWRaavOG8ie4hwVcnqKmImacsob5UwnR7?=
 =?us-ascii?Q?uTh8bMPhcCKL0aZOymoRs90KMK8/Dj5wdMgKjY06iRj715tvO8yIHTPu1eVC?=
 =?us-ascii?Q?9bqESv57z+i11OYdx7RZL/UdoUuJe6Pn2Y4NB5wj3Gyb1SN2MNec2qvVCrgL?=
 =?us-ascii?Q?ZZxae1OtwF6YX2PZi0/TVGMXnnARsRP/Bnsz/3mApiQABT4P+XB+6zMkjBCG?=
 =?us-ascii?Q?bcAkDNmhBphmxdiKPuntv17UHeR1EuhLjrANuYJfhhVbP7cmdOuSXpRzRYUa?=
 =?us-ascii?Q?CmBp3+rejpWblrfLUqgJOKyZaWZZTneWaLCeOI4cC65LKP2QCxOMa3+K9Pq7?=
 =?us-ascii?Q?fCbKyvEcwyuf6gynDnWmJbhNaynYJsCL1sj9jP/uRMzFnGrk0dbpYbA/VnfB?=
 =?us-ascii?Q?10YpRDSwoFuBlgmLwlDRPLEpFWvUSRtSh0k/sWHFul+2C/WVD2oeIM22NQvB?=
 =?us-ascii?Q?eA5LJlyH3RJFA+yyItj/GHnjCUF45f9KSryWdY8hOL4NJdJHCiDj+ZnNGYkM?=
 =?us-ascii?Q?Y2MvtbwQAIUz7ovvPxSJIqEqk+Rdw/DtQ/y9mxzzJjJyVB4D+VVagBg7q8c8?=
 =?us-ascii?Q?93SdL60Gj1DTSEc5i4jesXO5vEdb2Q1cebDfY09MWFMxXliIxKkmJLRBDLPI?=
 =?us-ascii?Q?O96TOUKBuNa0YztbfHh9/FaXS5MXnVf0azee4k4T6BCihUgfEUUAaf7+XiiE?=
 =?us-ascii?Q?yF0tJfisUWvS6ZGpnVtNOcT9jrmvPB4gCxnRzxn8tP5YojVj6IyzamA68Zyd?=
 =?us-ascii?Q?L2geXwDOHfafy1Dg3hwq6VXqW0+RmS6URg8jkS5loQpImNWSJ5HCH9a3Mx6f?=
 =?us-ascii?Q?0U1aJ4QL8A0jyyz7yhPUQgbysKCwL+W+N4+tqN1UCq3QZpsZ3wRfBDnvofOZ?=
 =?us-ascii?Q?MKFRJB9E8zeEdFFJ+vu5Xyia9k2jF9WWLqcoolLA6F9davF7CQpf8hHOcT5r?=
 =?us-ascii?Q?Y5tfs70JkjZmE3heIlUy2S3egOKCMKG5KXBGOM+ku9LxhH3iuEV3VJ7KivVp?=
 =?us-ascii?Q?8UVY1ybHLypH0B1TjAj3vsu7H8X38GKoTuVX/LmO?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d6172e0-01bf-4614-0f92-08db0a38f81d
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2023 01:00:00.1251
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZJqJf4YnLS+DibUkiKg8PL9oZQOeVLuslC+3uMDizT1aWb8xnTn9lDEJVe0sYqlX
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4442
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 08, 2023 at 04:48:07PM -0800, Jakub Kicinski wrote:
> On Wed, 8 Feb 2023 20:27:17 -0400 Jason Gunthorpe wrote:
> > On Wed, Feb 08, 2023 at 03:19:22PM -0800, Jakub Kicinski wrote:
> > > On Wed, 8 Feb 2023 12:13:00 -0400 Jason Gunthorpe wrote:  
> > > > I can't accept yours because it means RDMA stops existing. So we must
> > > > continue with what has been done for the last 15 years - RDMA
> > > > (selectively) mirrors the IP and everything running at or below the IP
> > > > header level.  
> > > 
> > > Re-implement bits you need for configuration, not stop existing.  
> > 
> > This is completely technically infeasible. They share IP addresess, we
> > cannot have two stacks running IPSEC on top of othe same IP address
> > without co-ordinating. Almost every part is like that to some degree.
> > 
> > And even if we somehow did keep things 100% seperated, with seperated
> > IPs - Linus isn't going to let me copy and paste the huge swaths of
> > core netdev code required to do IP stuff (arp, nd, routing, icmp,
> > bonding, etc) into RDMA for a reason like this.
> > 
> > So, it really is a complete death blow to demand to keep these things
> > separated.
> > 
> > Let alone what would happen if we applied the same logic to all the
> > places sharing the IP with HW - remember iscsi? FCoE?
> 
> Who said IP configuration.

Please explain to me your vision how we could do IPSEC in rdma and
continue to use an IP address owned by netdev while netdev is also
running IPSEC on the same IP address for netdev traffic.

I can't see how it is even technically possible.

Tell me how the NIC knows, on a packet by packet basis, if the IPSEC
or IKE packet should be delivered to netdev or to RDMA.

Jason
