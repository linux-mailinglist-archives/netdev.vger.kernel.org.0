Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EA02573F91
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 00:23:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237361AbiGMWXO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 18:23:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229895AbiGMWXN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 18:23:13 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2078.outbound.protection.outlook.com [40.107.243.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53E914B0CF;
        Wed, 13 Jul 2022 15:23:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SGyXgqXJdBU7oImO8s22LfomWWDNcOkmRcUM5NBnD0iqi0q9aUpl7K8ZwBHevc75EAGgVSPkTPBclh1s37tvaiW1O9uNrd7+JiDlIIfjWEOAvds44jejCgdzqNLqEwafZCttyOnCF1590vGZlQYXRj9NKXmz0uwhRCd18guPpBBWG7qtNQokkzj0EZLv5hoMWcsgt9bVnqGV0KLPgtad+I3XyBa2yGFTlpEH3eODLNmTZHHSECxVMZI3pTJABwEJP4/4+zs6iabZjE8i5qaYqiTWtS6BEEpogWlDNGukaQN+nD8qkdd5Fzu6wtEMTzcUbBIJgurk1n+LkhCM0tbLTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IyDVF7++TsXEpLnS7TfWVZLisxH/8DLB/NoFGOjrCKE=;
 b=k2GY34UJZWrZKD77Nx1y34ebNH1vL0iV3yHl9O7QTPjfIHQSbGrn0G/Bm083bV1g2FdBiYt/AvNZaJN4h8vkfPvAjQbNYPl/ht3fcLlj0/8+SzT/Q0UDJgqnB2jzf587mgDn+98gxNEVKBuhbqtxzmYyOBXxUWVc9dAaf1cOS21zPL5XyO1YuAvHXBkQ52hPYKCU/KubjNPPKrjWjFR8P1kH4LPzPM6IWho0uJrvKM7NnPMB8HAZ1yK9oZPzzGbmr1S6vQQPEbFXo/h/bjkaJ2hWhrOxJAN6KwJBAh45s5UISsAOiRSzTJ0TWnaOx3RYuWxtufDK1jhUpW3Dq2/PCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IyDVF7++TsXEpLnS7TfWVZLisxH/8DLB/NoFGOjrCKE=;
 b=CeSlA8+5cbrZY2eTsZLq2Bi49ho+EyQiO4Yx7oFk6x21r5Sc8d9Te5XLL/FE6rFM+ulPoT2q7n2WD1nOuXY700wvgCVaW2mKAlcNAah4QN2GmhS9s7cx2iywTN9jCDmgA+OfwRF1ZfMRgRiOVc+GDouh72bqmShuh4VaSzpeLArJdccA/R1JMxfeUKhXYVfiqgTAllqMeiHYB1TO0SjdSqPxERU77ivVOwadlEbbNV89xwVn2tNqyLR8ArI7wXGW808CAbI003egkA+gPlevh4cOLoCPDq5OtBbtL6lRDcPsFRBdDnN2xSyR0t5r0rWTY8YpZk8J7aUCteRYnrzHKA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by IA1PR12MB6161.namprd12.prod.outlook.com (2603:10b6:208:3eb::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.26; Wed, 13 Jul
 2022 22:23:10 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::900e:a8f9:4d99:1cb1]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::900e:a8f9:4d99:1cb1%4]) with mapi id 15.20.5438.013; Wed, 13 Jul 2022
 22:23:10 +0000
Date:   Wed, 13 Jul 2022 15:23:08 -0700
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: Re: [PATCH] net/mlx5: Use the bitmap API to allocate bitmaps
Message-ID: <20220713222308.6sqcsom4duvbe3pk@sx1>
References: <ca036ba3d0c2ee307e1d8cc94aaaab1686ebf1c9.1657456513.git.christophe.jaillet@wanadoo.fr>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <ca036ba3d0c2ee307e1d8cc94aaaab1686ebf1c9.1657456513.git.christophe.jaillet@wanadoo.fr>
X-ClientProxiedBy: SJ0PR03CA0389.namprd03.prod.outlook.com
 (2603:10b6:a03:3a1::34) To BY5PR12MB4209.namprd12.prod.outlook.com
 (2603:10b6:a03:20d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1045b5f4-a6f6-4e0b-8943-08da651e44a7
X-MS-TrafficTypeDiagnostic: IA1PR12MB6161:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MSqU4BbQu5i+kHiTQaJbbp5KtIu9Q8xKdtyIO2MrayKeUd+m0T+2UJNLbcmZPTPxfJw3Q6kLigORkqpwGnzuenAKDJK+xLTiDPfF2Oaa9yLZ3JZgaohWtQFU6N2keLpZxinVFGi5M23AdmolItgzTUAOEKQYc5B7nuB3fWvnMt94CBHYUqYM4kM1RhkknynyAbdjPPstX8fUaE8YaJRd7WNOQwyb0cI0SlRhOKAeQQdfZG/9Hi8QyfURDlZyFpw3047g9r7HfvcFXCW8sqWCzYbizo67S3HFi4nrVoW0ZVw0tkBrmI3lbIkn8q9GWKVKQBioaXdRbobK1Tjv/h39hnchIiNgJqlfDfm0AKuGy2p9AsHMeg3YlA9LB2rpIcPFVVe/M2T1rct1GbiSN5K6/2wUDN0Ix2eQPTocriZS6aGpxHNUdV7pUJoA5q9vnWQsP+ZOeRR7f5MPiAih+gQHwKOdYwKDaJvmJ0ZoVi7XWZb26c55nhog1/OgT+mtexiWEj+plcbjnGiYB7YiM1cVMf6ms2Tnj0S9HOPrCEQn1uMT4LdH5AKrpL8Fl1ocyQgvNS40THmFYM5X2HvNoLRtzfW1LrtU2WlJCWP8AhyIBWrImECCKyepUs77jXrGRLtAsvGz+ePJitwvWMIJn4gEYIKCowDI5ZN3RItaDNe4fs/koY2wgbh/YQ39e0Eipx8mq4jm4eadQ15ZzXqFhdf24Tlpbrcg0A6Yq/ACAuKb/80L4G1swvTv4SHF6ZOiSSAO0pl1UFAI2XEPg0PvhMFlpA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(396003)(136003)(366004)(39860400002)(346002)(376002)(4326008)(9686003)(8676002)(5660300002)(66476007)(186003)(6512007)(6916009)(7416002)(66946007)(26005)(33716001)(66556008)(2906002)(1076003)(558084003)(86362001)(6486002)(478600001)(6506007)(54906003)(316002)(41300700001)(38100700002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nZBKQj8rr68xfFjYLrPFi973dluJPNzf0QkjGtdRi5gvAIAOcMv19V9lkuhf?=
 =?us-ascii?Q?KmJXJVdD1dIsPflu9u4Ums48Ae0NMZo17J3niEjOixCOSiYL7UouHoKwJGw9?=
 =?us-ascii?Q?MqWsy5zLFa9kcxdbLoQYn0ZAgI6UTrvY3zQL7MfyrCrPL/O6sEjOmWpKqGh2?=
 =?us-ascii?Q?Ebqz5uAiAvQDQKjrCsJ3TeNXCwjQVRWd6dgko8FTEOgMOppwUig+SsztYOxv?=
 =?us-ascii?Q?UGfLPk/fKecKYX+spw1cRmld6EMgB2SZucMVxmD/1R/IrxpD8IQCKofoirKF?=
 =?us-ascii?Q?L4BuyeHWJTX68Dk9rDu561OvSNJD6YypzOlsLlbmSPBQDlwsuy1/16dK6huK?=
 =?us-ascii?Q?jtloeh3SZdZxk6LX9cxkZg0NyRZPHcumJ1mgTvCzmRxlLl3BHbhY4/P4JSev?=
 =?us-ascii?Q?BzqQKGT56BSu3SkwvnwwWUGGQLG2sR3p+VLmqDrZ8xBYyXLRRvig8ZlmK9F6?=
 =?us-ascii?Q?4ImnqhxrQG74v4Lhj+b7GxZz8F7RsWawOveiverJ+UeEGrepLi6qghWLdWJo?=
 =?us-ascii?Q?ZFhl6spXz7qKumd6IHy/GHt+BE7Ndia6V+2n7xvQ/nPJJa5l/x341Kfj4m5H?=
 =?us-ascii?Q?BjkOLBI7CtBdYp3++EaqsUjb8mXZP1N33cbt4LjwleBJXHarsL0fU4ExaX7P?=
 =?us-ascii?Q?uy4wkt/fVNKHGvgJ4IPNEE8hxBcgnA6S2R/R3uDbTKKJKX1784aAdSuXyx+Y?=
 =?us-ascii?Q?3uqwjU1YVs3HREpb/+7zULpCj575d2TqHDbwTtyJNpADEifzEoaAjGOyKifa?=
 =?us-ascii?Q?jJISM53/JWI5XkfmlvWZ22GpGO7+naYzCNgR/uIV6+XJKIYRK/H2drcTBhsD?=
 =?us-ascii?Q?OyuRt3tCSyGxm+QBjTd9jRVXhFRLj6+m8b6YjWfy5kXlCP463Hz1anieaY2b?=
 =?us-ascii?Q?K8kcjQRmwP+jZ/W+HdBiDn9ag1IkYpuqoJXDVOqOMHLlvgA2J3u73qKm1pXJ?=
 =?us-ascii?Q?ViY3dKbun/haLsa4c7UB0KJqTFraWiVrTIU/YiIf/c6PmwjkG+mTotmCyA6B?=
 =?us-ascii?Q?IRmRpaI5PZzoJnoV8zebROJrbBRF9gJGK4kDEbLBfqR5nUIIZQsaDtvAn86P?=
 =?us-ascii?Q?xfBNkgIlbIri/oSbX+UYb1w5i+6XCmh/iv6hQqRhfy6PYiXqkJGBJxsFqO2/?=
 =?us-ascii?Q?RNjbbl0EziVhYA+ONcN2oo/OsMKzoJ4xqFfsOtg4DfBWghmJ7XP5vSY80fAS?=
 =?us-ascii?Q?lZNcy6soZjN9sSRJBmKFrV0V2C8cTOs4jLMR725X0RB/gO10lnKVnCobudTu?=
 =?us-ascii?Q?j4NjFnXTVb5W5gQk+mRvNsXYu8gQQjs+YsVRYYqjqWgi8MS1I/qyjenWDS4B?=
 =?us-ascii?Q?LFf4NHsUSS/We6nJkV+cXbortR4dVuXzyd7vMEnSbVgM/61ShZMYVfURJImZ?=
 =?us-ascii?Q?oA678u/k9ZOd3UiU+n7X1aV0qOn1Ag0eLiBifnqErxEm9xYDaBbc/xFuuJx7?=
 =?us-ascii?Q?MhlgYLUx3xiv/cuLplcW7LxpV1kFuP47o/S/cyBUQuruQbj2BT6j7v1HcTVE?=
 =?us-ascii?Q?hxu7PXhh4zaghpcSztBf5HvzW50KYep5bXP5lQtvN5Fz0dmCWu3iU+S/RJCu?=
 =?us-ascii?Q?xQxvpb21aIKkaPFHjUqIrzzvkUVg34udxTjaE0Tl?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1045b5f4-a6f6-4e0b-8943-08da651e44a7
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jul 2022 22:23:10.2382
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 27Ek/uKQjhz/IBYG37Cqy0h1VbC/KRvG4AFHLDfpRXhdtXkpRsIVp9b8xMosTq9nA5O5C3d1tNkMJhSKbRfMhw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6161
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10 Jul 14:36, Christophe JAILLET wrote:
>Use bitmap_zalloc()/bitmap_free() instead of hand-writing them.
>
>It is less verbose and it improves the semantic.
>
>Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

applied to net-next-mlx5
