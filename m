Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00D36576F98
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 17:05:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230135AbiGPPF2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jul 2022 11:05:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229938AbiGPPF1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Jul 2022 11:05:27 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 556831B7B3
        for <netdev@vger.kernel.org>; Sat, 16 Jul 2022 08:05:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mAPwOr8BjkRPDd2BoWcbDuDadBIgmFT/Vb+yufy3y81DMJw5gdPmYYsPY9kJvrO94p1Ou4pgqIxd2vGCGhSMhUXUskRUMGIPPtmYjBbVbL9McRewdRYana8/OItetAmYbQrUFp7/suCujo8UbY7V6J91UX6B2azejk3HBqgwmh1FC9CDsQEq+Y/54WweZroEpDydfCi8L4g1cc6JCJKlANKbWblIe8Pmqj5xRH48ve6Il9IvgslFu0LT5oa+9Qs0rQhfzRSUSLQpYgamthRnnhAKZ0zV6i1kMg7ooHEvjCHXG094u3ts9CPIu8JOowYNc9D3LwRyJQZ7uvfdPwTQ0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pV3tpumYLFyHGa6iXNyl/FH64kDtrp1lYvZcHvovN48=;
 b=g9JiJ3/MjgHOEbZKdxZCk96s5MmapOi6nxk6m5P5LqJPeXMqiH5dVhMwQbPEZYh+6MPjUhatO0HkkYQ7r0ma/+tFqoKWiXYrgs53Jb5NZ1NJ3Um8uTg6ui2wnDnm7OKqt5q5PyKczt1BV8TMFVZUnX7Z20CEaThNNVXhxNOSW8WD9N92k81LJcAdMrvZlflurmt6kSGlDAkXcOVFzViRMY3Q0BFOlOyLd8AAfluyYpbeE8oxL2b1Vd70UwT440uZVix3w38q6b+x9TYL3rVTup5PUaV1+9dCGThGvvD6NyIJxdB2UtF01DpFyxT+YqlZwr90tBK2+xuz75WHBzx/Fg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pV3tpumYLFyHGa6iXNyl/FH64kDtrp1lYvZcHvovN48=;
 b=goHaf8vHnZEqUIEkqLiTDziMXWL77zPquC+EMVPCHzrerRr1cO6W+Dxfg99NOgs31M2FFKlb6BSfgGXC4+MbeRb2Q+u1OAc9eIyQ9wit9lW7y1M3yE8AOMo/DMYnTUDvrorOD7QvYSBrqmZVxEwoiW/6cB921WPj1vO2FLq82+NAyJ5Kyq590S+0mjevz/T0poab4jHDaWLHM9j/VBm8XR4fAcHBiehGchGGrZgtoI9SKGWHiE993eS3n8lKTBwHUeNi0CZK+HTKhRkIVk3kuPKSqrfm3Yoe2lBKIOWjvobjbrnRhju0Ga5NgmE6zFcfLEhR00sYrZKRGqoB6bn7IA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by BN8PR12MB3012.namprd12.prod.outlook.com (2603:10b6:408:64::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.19; Sat, 16 Jul
 2022 15:05:21 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a525:8fcf:95ec:f7ad]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a525:8fcf:95ec:f7ad%9]) with mapi id 15.20.5438.017; Sat, 16 Jul 2022
 15:05:21 +0000
Date:   Sat, 16 Jul 2022 18:05:15 +0300
From:   Ido Schimmel <idosch@nvidia.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, sthemmin@microsoft.com, dsahern@gmail.com,
        mlxsw@nvidia.com
Subject: Re: [patch iproute2-next v3] devlink: add support for linecard show
 and type set
Message-ID: <YtLTq/6dsTIrJetO@shredder>
References: <20220716112451.3392453-1-jiri@resnulli.us>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220716112451.3392453-1-jiri@resnulli.us>
X-ClientProxiedBy: VI1PR0602CA0021.eurprd06.prod.outlook.com
 (2603:10a6:800:bc::31) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5b69a8e9-bd08-4125-0d3e-08da673c9a6a
X-MS-TrafficTypeDiagnostic: BN8PR12MB3012:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PPn7+AESeEQyy9wNoph/ox21ILs9vWTKbeLz2CqRKZ5OaTVQgQD9wKKbnyYR9bPX3S3arvvg/g6LfNi7++5NoTxRNAsT5DU91NYPluqymm/9ZTrowhapLslS0QmtzMU0J4MvKz5uTcx7LXU+gZnpnqV1GJEMkYBgABgLTcb0sNoD0hIKEUAdr620++UP9tK5ii9YDUD4KQbwM49S+RAVcGQt2+z5h1bTddkf+DIggXcJHehbHO8ImDhw8x/MEYHs7v2dQh+KGnGaxoY7pFamK2esWd6ztCq8pbcL7HJu9fVcUu6dA6exg0iO/nS4SFqy9jpsB1XBdKT4BFT1wmJCAig5rI4/SI4xhrCYvDWuWZytCtcHU3jg7bXkINaaPyAv90qx3ZAUdKWI1vUjQiP+1McisfZFe2sOigVyWp3h5Te+IzmUSKIUHEb7MCUxBUAo7asFsXC+wvg2O1QaND6GGUpegrezjHoi73KFYfYRBiv9xK6/+9eq74g6iapLT9oUHPJtD1aS6ovn8GBn6qX/O4onI/oWnQoY/UcFQrjRZ5d6w8cqM8K0quaIR2+5O1z+tPCBOKZGcxSQXxcfJzABUCzh7xjjxV1e8uBdVuHKAI7r+tH5n0ddG60SWmooJ9151D9x07BjEhZi8n7op16FKUoG2oQo65i1F5R0JD/VRWS+6Gx1zIqJy9UdnUIK0IWvmr2GiYeNodDkFMry7cOZUoEqivNiJ/gnLAJUdJbWvh7xvboHTAmHiOPcog5cL1St
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(376002)(366004)(39860400002)(136003)(346002)(396003)(478600001)(6916009)(316002)(6486002)(38100700002)(8676002)(4326008)(66946007)(33716001)(4744005)(9686003)(6512007)(26005)(107886003)(41300700001)(5660300002)(6666004)(8936002)(86362001)(66476007)(66556008)(6506007)(186003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?s11vwOokLimExYhM5MFuOu/+/JDN4+nugqZjU4C2PNUQsl9H66ICJ/lXQpFu?=
 =?us-ascii?Q?/QCrI0KlglLIF4zj9dPsIet+t5m4wDBAEGIFCjYQBXYrkcQLjDr7z+xIqNVX?=
 =?us-ascii?Q?esrwPWOWNy8ZRPnh8SOZoAI/gQeOyEruxPWG4N63z7LYd4uFb+3rf/JDkAin?=
 =?us-ascii?Q?PyBObE92/1nSLfb4TOb6iQ52izyEx30Fc20hDwjrZAlhxv8vilZbiv8IEA4K?=
 =?us-ascii?Q?5AI/8icakEART24qOuq9KXouAjYn0RN6/OyJ62fgVaFYWwfWd7nCbg7KrAY5?=
 =?us-ascii?Q?4h9+5QOIi/PBApHY9ynHhaczBfQ2/fBTJQAm2RSxAXgkmsPLL2ZARWImT1jE?=
 =?us-ascii?Q?OXOcfYbNrHksW0QemCNWFWqpPfBw7FLuLP7C3TUfw5l6URiTVwqvhmhEfbQt?=
 =?us-ascii?Q?1KuUBgIwYViXY1izZrTWxfxGBM2/S7bcKegT7wGzz7HsxJP6Z+LbS69ReBTy?=
 =?us-ascii?Q?CDhE5wO1m9U0YVpzLsasHoBL5kSop3mFTNe1AsrVNbehXAMnr0B8oT1dM2z7?=
 =?us-ascii?Q?R6GZs4ihDFn4nGtcsGuzF7DGBuxXSGazRSJmOzjqBDiBgIvfie3Ze00E2C4X?=
 =?us-ascii?Q?8TfNd6L4wm+ezBtfAx+JA41Y6Wgyjq2uwYCE7khmklWdeGex4K7z4TDOORnV?=
 =?us-ascii?Q?PZO+5497hvsVMSqWh07wcmlS4Q/mY4UAVxs2uhmb/uzxRFUXAajVBk/9ybOM?=
 =?us-ascii?Q?rGjbrczici9LUoovQH0B2qUY+f0Qtk5ykx2hWPPoN7Tb0TYLvj61Be5U/FrB?=
 =?us-ascii?Q?oI/eTd6f8WTgX94B6Ash0QnRPzlS6iKv6XM/jz4uJU1Px8TBbCWvQYdoJcn+?=
 =?us-ascii?Q?Y0rGTkl2q2DiYFdyZhueMQ8oE6sLr71lgIOt548RvPvv5snOkCj8AzL5G4P+?=
 =?us-ascii?Q?uKevoJzRu9U4S1VJh7+IhH3R4sSKYjBokiV4o+ZY+i3nqbLgm2b3A6CcAgiR?=
 =?us-ascii?Q?Jo14Qmlr2gdCB6AF/sBSjQCh3Oo+4YiKIxwGk2LcpqgPwyKBiJ5itk/mWmN0?=
 =?us-ascii?Q?7liPrECxxT+Iuc9KJ7qLIDHzPegvaK20VUynRdOsJCtwMbE0/mPkxEQh3qYT?=
 =?us-ascii?Q?BvcTQoysXhLec0283wZBrV6DuO8r6styLSDojiYU0aGvo1fFuCyGngs7CnBv?=
 =?us-ascii?Q?IpOfeMYEcYE7i1e1bPxyx+RchirDVowfSBtSVw84TGDJAEQwXBV8VKmnVgei?=
 =?us-ascii?Q?RhW7fy/cmGE6k3Mv3YNhUkG9USlQ9qSLyqyIeEBsO7XUm0T7GXyiF1S2zZl8?=
 =?us-ascii?Q?2ZzJythGtedk1hHY49qLKoc62oCeXjo5jK84tc7kTYydJvwjRAD/NvcJXLP/?=
 =?us-ascii?Q?PssLrillicwzohG/OAgEqc53YTjgXZIwemfaRum6pxrh+LEZXqNrEpiA+MnL?=
 =?us-ascii?Q?JuUS9WEZgNmP/C+ZMWBTvEhvjlF7iH5/eeKydOdV1/IxZu4/LdeqOfrBc/zd?=
 =?us-ascii?Q?di53lqbGsQFjmDezWAKZryNvlmTQFljZZ5xkzurNn/aniL8P7bWZjhJ5hIUt?=
 =?us-ascii?Q?w2MeOfcR2krrfmGGBtvOib/uK8pN+4LKrYFwah4+H3M3mi0iLCC8Oulfe96+?=
 =?us-ascii?Q?FAWnQhrdEYDht6fpZyxfKELjZBnti9KktN5qGsO4?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b69a8e9-bd08-4125-0d3e-08da673c9a6a
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2022 15:05:21.4104
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8ZyfBSMOFMFIpOy0LYqv+vIgd3rhtQngP/3pafOkYQm/N1y+Fjo9lI55ywq8HdTZCzNGwuUe0BNSt786Qbtzcg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3012
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 16, 2022 at 01:24:51PM +0200, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> Introduce a new object "lc" to add devlink support for line cards with
> two commands:
> show - to get the info about the line card state, list of supported
>        types as reported by kernel/driver.
> set - to set/clear the line card type.
> 

[...]

> Signed-off-by: Jiri Pirko <jiri@nvidia.com>

Reviewed-by: Ido Schimmel <idosch@nvidia.com>
