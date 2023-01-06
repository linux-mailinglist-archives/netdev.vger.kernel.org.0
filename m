Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3708E660A56
	for <lists+netdev@lfdr.de>; Sat,  7 Jan 2023 00:38:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234399AbjAFXih (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 18:38:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229949AbjAFXif (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 18:38:35 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2056.outbound.protection.outlook.com [40.107.223.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC3BDF1E;
        Fri,  6 Jan 2023 15:38:32 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dQ32KlZp1FWCfNm6/QUJyW5ZrZSp9r+ZdDoq4/k91p0O9x/fajw0Mi8IST2ilaTqOJR/DhtElPyM5Kwc6tZsTue+uRSHfp2LkC8FdyKsJl3eR251iU3QXYQGJy7Y5Yp0VjjZaC6BGUFmy+KR8pbd1NvArAoy1wVp0u4HfYfEcQwoAOVZBkWI63tUuCed3eRQrzSkr0+mnC9Lnbo9+alHMjyyvun6UwpXFSWS2cn2N5ZtRsrCIPlWOKDI2Qfa2Wjk2YBdvPIXkwQIcGC22a9mCu9vuOlFjiFb3r2UePIup54Tdhr1f9x1USlfMb8vAKTF8FDdVKYRyADpt4glWoZgow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c7VpOdim+FQ1VEvXJYeVAjAhl+KaJWtka4U8AKk7FWU=;
 b=QnwIZ/kv/XPyRSxwFZUT3aEq60Htk/oLo47Wxv+oUjidOW3w8nrMOfktyTzMs7uuCrXCN8/3Ve6cg9l2fPXCT7hkwcNf80+O/FVPl5miJofsk86Lancljq4rhd2C3tgSEiDRptKec6FOPRZpso21tm6B4RUNQl/7yqYNl41zGtdkjO8DeF4K3KhSOxsLhOwE3l7nbuAWxK13MJwquKmvh8nePkxCD2qdZVczOnLOdpKga2/jJ/F/QKNbcvBpBQCSX5o4a+Y5CVJmB8qrFaOcqEPhBDCzywyhUhihIQ1Nsx9JnWN5gW1owhnYJlaQ4Yvcb8yvH+z8lWnxoTi9fhaB5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c7VpOdim+FQ1VEvXJYeVAjAhl+KaJWtka4U8AKk7FWU=;
 b=FhaPwRDnY5hsTEkKtqLVtRRu02hlzVuW3rKzo6vAVexLHTyizHwEdxdHHEJqhv0WWVxt623yJgBZcp13BtDqXqUkL9s+FKt4a7b+gTvnYK6bye/fmiPU/LErwZ9Q5KtC0yRscbO1wSUz4HMur2K+hUb9XkMU6bfbGjG1Wjvo2DGgCEC0088/TgvV/7cIWsFdlDVphBuluMU0B2pxzWyzr9pB9r/6SlwULM6Fn0g9azp2/CeEjD5B1UrtCnpL8HbR80Lf3qSodZ2mBKkzfoN8VBgD7v9NrbMv0QMYH5fBQ4WExK1KBXzvJe5no1BG19WGOCdR+VjZ0HVc1MSeJtL6ng==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by CH3PR12MB8330.namprd12.prod.outlook.com (2603:10b6:610:12c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Fri, 6 Jan
 2023 23:38:29 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%9]) with mapi id 15.20.5944.019; Fri, 6 Jan 2023
 23:38:28 +0000
Date:   Fri, 6 Jan 2023 19:38:27 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Saeed Mahameed <saeed@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH mlx5-next 0/8] mlx5 IPsec RoCEv2 support and netdev
 events fixes in RDMA
Message-ID: <Y7iw8yE295SNGig2@nvidia.com>
References: <20230105041756.677120-1-saeed@kernel.org>
 <20230105103846.6dc776a3@kernel.org>
 <Y7h4Cl/69g2yQzKh@x130>
 <20230106131723.2c7596e3@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230106131723.2c7596e3@kernel.org>
X-ClientProxiedBy: BL0PR05CA0023.namprd05.prod.outlook.com
 (2603:10b6:208:91::33) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|CH3PR12MB8330:EE_
X-MS-Office365-Filtering-Correlation-Id: b3f074fa-23df-4648-88f3-08daf03f1cee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: c8e5pnylZEvIjjLJsBgYhfJwwyZ2Zkw+6RxHQhUCAJddupkjzPQODGbvbINE/ZUfXcfLF1dn3GTzYJFh4IMWWzj4UApGkAMAdBG2v5iPgsogDPj3oK+ni49qCGLgicAqSU31cqp15YkfHzSr2CgBNdZetWz3lOSGktUuci6DEFRSYXYfPuNGRsizrhWa9MN6zGQlkZ8qO4gBwggQ4H/YSSGEojXF8VKsSdXlKhjGdwN4qo90q4FLJjwkRxvllp39XaGF9GDmvzbVXkZjVeP/NMEUb8bjqj5cXyyz1IGnDJlNZoHVh+UrIT6IdiJexU+UFLZPwydEjg+dF/wtfMjA54Md2a8eWO0wSm6eYgvpp5CaE3uQzA91ztdMBnieYWgKbptSTnraAEFfbojCI9Rpaoc9KHBFb/dIwYkM5BTcjwrZnxL23MWQL4WhVlejzvYkFo5g2tv9BqX5RuqAIT14PL8nUsJ5vqmE1oxyqTDSog45bcbLfTC1jOxhZNje/WCRQVEPZ3+D9lxbNGGO8cSg8trKryleiTbX/IfC0VuD0TZWeIV43Jo7OlqZWDgFvhsWRnEiZVFAA7CCdy/WPEgKYDa/m7KMu6PCQGLAy9BTePJHnfbvcNCyGdzGoQdMWu85WOT5JqP6q43n0mEMSxvC8w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(376002)(346002)(39860400002)(396003)(366004)(451199015)(41300700001)(316002)(8676002)(4326008)(2616005)(66556008)(66476007)(66946007)(36756003)(86362001)(8936002)(5660300002)(38100700002)(4744005)(54906003)(6916009)(2906002)(478600001)(6486002)(6512007)(186003)(6506007)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?byGG5wjxvEJZ4GKSKZM0+A/Ax8H3Xit1eT+na5GbftovOV1BDkRMA9JOeAwm?=
 =?us-ascii?Q?+xD+Wlcg3uQZxDiY64FoLSy23nlemMtP/wuBb44fWabDduyUGZk7SNPJ641v?=
 =?us-ascii?Q?0dcvfO5AAKBuEEtEJ7t+5QI5DvFjlZnX5H0Eot2RVxJbk+dhyqZiD7a2CffQ?=
 =?us-ascii?Q?z6AFMO1af47raHRJWmZuzjxGFvlhR/gRmARqnPsYmHV5zZxxKg6qG69SS2Y9?=
 =?us-ascii?Q?qOjBY8Xz4URG9EagSMj1aLTzIsNSLWx4bIxGMON5cc4qeOw9cQNezYSYKahg?=
 =?us-ascii?Q?KJm8XWSyEn8xqChzBRAwfK+9D/is3DSabkaEL5EGDx6Ih8b6O4qlA0AoNR7c?=
 =?us-ascii?Q?HDvARTNcewh4CBhnevGHIg9Quo7E2ck2pVBMMJqfL4S8ls9IIv6usPpbFCMI?=
 =?us-ascii?Q?y5dtzsp8IGTUbKBmr5Qq9mLqwQ3Xfv161c3MWndb8AVbA5kXckTsGxlMicUD?=
 =?us-ascii?Q?5LpXCOZ0CsZTzStkOY1IgwXBWw3r5G4Pp+DVoO+eFehtLiWel5GKFDj3/ZJO?=
 =?us-ascii?Q?VWELAU0NycZC9Bg2ii+xm4XdT5jZDZuErUdSJR6wemgW4HVtMiw/aT6/YQGF?=
 =?us-ascii?Q?ah/9zhzNE3WtDnI6Ri5Wam9CaHe2eQoCwCI2PDPdyLcwl+r0/dQ+IE84Zw8d?=
 =?us-ascii?Q?DNZ+r54rBZMB2VGEeQA1Q68AD9fE2cmltt3Xwm0yr0NC9zYELsV6FblhuEmG?=
 =?us-ascii?Q?Fec9Z59eFh7rb6shp/qGu+pGa2jcqdqimb5G/n9QbG/Sw31pALg2FK670amc?=
 =?us-ascii?Q?MmJET5JWxCEOFn6Ci3o1rpWWuGo9zh5K5P8ImMRqJYIuMA27ztmfCRzXhTLw?=
 =?us-ascii?Q?D4z0fRsE0d8vqi/uMSIUbTrLpF1Y5QMQTyfqZm7lsxLlIqxv3m+lU38jCEP1?=
 =?us-ascii?Q?BwhNpkhksXrKOv3v8srJyDP8rvmfnXHQ8SpLfK5NOh6sKb2y2ykwMt6i1/3Y?=
 =?us-ascii?Q?BZZLsjn1rRqpUEcg9ylSVPYc7JFeDXBbi5Hscvil8Ze0P6rHczMf6e4RlIDa?=
 =?us-ascii?Q?H2IziaOwss7hY0SepPm3XaMW18ATWjCXpm5qVsXzcwaWXrHhKeS4vH9YGltW?=
 =?us-ascii?Q?+nP0AwZzYiLoW+kgjMprm9pl3uoDuxoupyjDopg5r9sWbKexzJfoaDh4XxAd?=
 =?us-ascii?Q?qE0Me9Kg03FcQ30k2BUfjbgZJvnRA3NCMUM/7Pkm5fgZTcPgZ4nwKRyZ9t/Y?=
 =?us-ascii?Q?3QCcxGtmzCOhTO/iPlGtvoAeyYqsE7uJO3a2kvm2My5iFPY9fJN+8HV+nFNy?=
 =?us-ascii?Q?CPDoMivou8PugTKsn3bU4IpmbklfHxjXsn25e2RnPBe9NBI6zEMGUJ5eZpDM?=
 =?us-ascii?Q?N0g2glKylaVsqPrIXX7AVxZU0P/kxDGWuqrEM5Pq+pUP9jR37b1Z+6VEq/7p?=
 =?us-ascii?Q?DQo/rv5CX0kCvzBd1nbiUDFGRnYJ07nDLxlvWjA0yGVi14sTqju13e13eZ8j?=
 =?us-ascii?Q?VGm/nN1X9gZlODW+gxGMMSd4SxEjlGQrTKWyjW8N1geJ5Ts3VZnyTjeMPjCx?=
 =?us-ascii?Q?BEz8X6jNvoheVS56V2B5gJpEJNBPPHAFbqor64lDWfIUZUvzvTEaYlN3w8u6?=
 =?us-ascii?Q?Cnz4aBlcTXjRkIyy8/4BDBc59ZfTqTVzMWiH27Nb?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b3f074fa-23df-4648-88f3-08daf03f1cee
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2023 23:38:28.7077
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OnM+yvbABAMTQrvWrwk8izztCC7Kr4Jz8Mvy70UhJteCFUjwyxBXMTTajSKspMsn
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8330
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 06, 2023 at 01:17:23PM -0800, Jakub Kicinski wrote:
> On Fri, 6 Jan 2023 11:35:38 -0800 Saeed Mahameed wrote:
> > On 05 Jan 10:38, Jakub Kicinski wrote:
> > >On Wed,  4 Jan 2023 20:17:48 -0800 Saeed Mahameed wrote:  
> > >>   net/mlx5: Configure IPsec steering for ingress RoCEv2 traffic
> > >>   net/mlx5: Configure IPsec steering for egress RoCEv2 traffic  
> > >
> > >How is the TC forwarding coming along?  
> > 
> > Not aware of such effort, can you please elaborate ? 
> 
> When Leon posted the IPsec patches I correctly guessed that it's for
> RDMA and expressed my strong preference for RDMA to stop using netdev
> interfaces for configuration.

No, this wasn't done "for" RDMA. RDMA work loads have to run over it,
but not exclusively.

RDMA raw ethernet can already do IPSEC offload, it doesn't need this
netdev part for configuration.

IIRC it was for some non-TC forwarding VM configuration, but Leon
knows better.

Jason
