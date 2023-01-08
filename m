Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8298661651
	for <lists+netdev@lfdr.de>; Sun,  8 Jan 2023 16:50:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231454AbjAHPus (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Jan 2023 10:50:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbjAHPur (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Jan 2023 10:50:47 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2072.outbound.protection.outlook.com [40.107.100.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F2586415
        for <netdev@vger.kernel.org>; Sun,  8 Jan 2023 07:50:44 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GC07LIqZXCLZQ9+eUDxd/3gitqo7MJ1Ub24JWnp0ta5y/Vh/TW/QSFNXXIYfashUh2s+n3AAWUuTLA41U2VwKGs7Xn8ubyS82zS8p96v6X6P1mT0bx+LyyedruyI17dxNIKOCPIEUY4my79f5dXQUv3P3E/Vt3es0CEi4XSx1HhwzrNCbiLkVurO3Xf6QZj2XMF3o49UhiyqcsFqYyjr/C4dN+vFPSqoZ2xaM3zn5pFAVS19sh8YHDJqEoJTZdbyNEKj5AfRTUs98P5+L+evs2BNvZIB5uQiLf+jSQBHaW+k3Rawbx8N1UOlAb+Bfz9/dex7scsATBMc6SgBLueW8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aRCsAaH7BgNhvqkT6VbTj1uESx1TKOcKtXNWsAzzuVk=;
 b=E2wDEl+4ltKtPvwO9gui3VgJwvYTHCV6dei5eVaWclkROekCAChDgjtWmev+RynI+63iJVyvO3jSgh/oAQDoYsL1iZ4yov4nXf+BaelRa1YpsTxAa6u/5Fd5DJgjMsiIW+BEpzwBUUApUpibaoYoahmRA1HySSWa+ksM9LspMHK85VGGWOB0e5ju2KOzq3dT/Tj8+4iZct4/cKCzUgBJineM86X8afYbxmv9cc4ol1B6ZN9fRVbsfrgAZJkn+3GkWiYkoaggbe/gLoHhwbeggGOFrgcp4to0EvXhKps2TE0baphLQ2/NbCCct3jE6NwDwQM8tZ/mOlBmxrvR7YC8+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aRCsAaH7BgNhvqkT6VbTj1uESx1TKOcKtXNWsAzzuVk=;
 b=VC/zsd6bZbLfwCIiO91a/gZAigArYJAhzllI0YacFE8zLsYbsb4YE9OvVXHasutKVs/v9BHEeV1hrnq3ywzjKGFzB3vzBgpk41+BnWF8pDjn16CQzsPGj0sDrALiXGKMG6XfqgEfoCMiQyJaatWkc5AXh3pOBS0cjZ5FAtBJvpfQRtMRowPB8awXB2iHl140KCT5sChcjy48xTPo/zA96kK+h0p/ND4ycr3dNPQ9n68elwHzeDoDNoLxq82cDg7PZz4SPH7Apqgjp2yYtUWID1tOfsXuO+j4Lejh2GGgRnQN4EebBVIgI1PHypXYf5i1rPj40T5I1EOulZ1sSH9YcQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by DM6PR12MB4449.namprd12.prod.outlook.com (2603:10b6:5:2a5::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Sun, 8 Jan
 2023 15:50:42 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a600:9252:615:d31a]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a600:9252:615:d31a%3]) with mapi id 15.20.5986.018; Sun, 8 Jan 2023
 15:50:42 +0000
Date:   Sun, 8 Jan 2023 17:50:36 +0200
From:   Ido Schimmel <idosch@nvidia.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, michael.chan@broadcom.com,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        tariqt@nvidia.com, saeedm@nvidia.com, leon@kernel.org,
        petrm@nvidia.com, mailhol.vincent@wanadoo.fr,
        jacob.e.keller@intel.com, gal@nvidia.com
Subject: Re: [patch net-next v2 3/9] devlink: remove linecard reference
 counting
Message-ID: <Y7rmTO+Pf2QIM/sN@shredder>
References: <20230107101151.532611-1-jiri@resnulli.us>
 <20230107101151.532611-4-jiri@resnulli.us>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230107101151.532611-4-jiri@resnulli.us>
X-ClientProxiedBy: LO2P265CA0070.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:60::34) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|DM6PR12MB4449:EE_
X-MS-Office365-Filtering-Correlation-Id: fbfe22b4-0a44-4491-976c-08daf19018ea
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BHHLCxooPoei6BgFjbumLtH8OVHOKLj4pBuT6Z0MEk/i/aeZQwBe9gwD+ow4Piz3LJ28GEsoZgdI4mSygAd3iwJmhoRMBN9pMvoQBO/dUXYRQzGZxsD1nyndzoO8urulAyFl7R4Ed6Lx4KaAZsQ9ecPizZlargBGiIbrfWkumSqRd5BqWHg2mW0jvcUUAb+rdhYPekyASlvCy+pVFzsCXhrQjJqx3YDGNC9TqutLb/diKMjhMZmNW1Y1kOX2dmNr7TmyE7wMWk6FJQKQGQsPUGKwvMDd6Ejn5WQBLhByCvo2RYYpNnyIaQ8sRJbfKHlnyEplqfDelGc6yP2FCao8KrtbC7Y59+XQi1cq6opZl2SkNVRTWPF9whLKSEIUfbFv2P36mOxZH3sPNLG1frK9uEnfF2djnFrnZBYT9Nmb3MONJ6uv1PG94Ig12IIXmKtGT4iXsdGSRSsEmVrpWJigQxgtlwcSE8uQFJoZz8Dp8acs0M1wZ8s1fCC6C9Skizpw5qn7UiQt6JO26aN8NX2rurpyy6iHIreYwPOlg4wyjfStXTubfI/gYpgNJV0Tmf1nzdEO1m9PrQ6iqqAhaLNZLvHMswq6ooiWPQV0Brus6LoRg9nn4X+3xUTIU5QFz3pLdD8JUdWfGpPJk1e9GMJ47w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(7916004)(376002)(136003)(366004)(396003)(346002)(39860400002)(451199015)(86362001)(2906002)(5660300002)(8936002)(7416002)(4744005)(41300700001)(83380400001)(66946007)(66556008)(6666004)(6506007)(107886003)(38100700002)(33716001)(6486002)(8676002)(26005)(6916009)(316002)(4326008)(66476007)(186003)(9686003)(6512007)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fdCWFILxOGnFo09FtMVrFaej8fX9B0rQ1Vqb/dGRnEp9KDny8y5pZKpkPy6b?=
 =?us-ascii?Q?yxX++15jCdZ5X6TIGKe9AUPC2M/4ZQdyom8/Is7k4M1y0d/rWSkmZ2CwQp+C?=
 =?us-ascii?Q?OgeFzfi+m0KXSP93eYPx24ViSI4B+AMWK/Lz4iFHy4E7gFKXpo4szVqv0t2H?=
 =?us-ascii?Q?3g+fXa11ih1UbKIpyFlNxh1F9YNBlE3BiZZ2MWKOrmG6zyKvCCCwMi3xKMhJ?=
 =?us-ascii?Q?7MMHMSIcPGCR3Q76ZUHrSoUhOLqwNTFoyRJE6936gHOU6uYlWTmgaehwOgz+?=
 =?us-ascii?Q?SyzXg3AoUAFr74HBlac60D6oOg/uNTtewtNQ4zozemFbLRowJxhJJqJRFmQS?=
 =?us-ascii?Q?lMgIWxy0CRdxDZNmK09GbvP2RQq1Jzk8w8DR1tdbdSojSUP1Klx1Yq1P2Kdx?=
 =?us-ascii?Q?aox/h1sGYPh2a5ejLVMy5qI88othjGS5v2dhfi5INsSouzkKJQLnzBwwvoip?=
 =?us-ascii?Q?u32bMpCt2wcm13SaEcbSvYwaSdhCIYznupVxFj/wBh2GR1DykW3YU/+EbUzC?=
 =?us-ascii?Q?njtbkEvYnOdaLW8I+8fV0pbcK/WKk2ldpVt1in4CaDtJdYaKj7/5wJaeUfLF?=
 =?us-ascii?Q?uo6SGx/WOTrw96g4MiN0zaqe72/5OdXXcbMiJgtkcnd0+brp2WGsihYY4j3g?=
 =?us-ascii?Q?QrnIyLUB4ZzYrMCKTSSNGVpIsRbrebveispPByEe9jeusRk1KVGS0cVgkWW/?=
 =?us-ascii?Q?4M5PLB00ylwbCYT2rY0YmV/cYi6KFhFz5a3kVztsemh+RYZsDtJRcE89icFb?=
 =?us-ascii?Q?HDQroP0FJI/WP3pO0cEJLIK3AQv0GB3AnvYJvFBwLQhbCS8ufSiuUOjWpKeQ?=
 =?us-ascii?Q?m0k14UANAiaYtzrhy0PHxslcHV+n2CK616YKUURuV+V2mr4wpcVool0Kgqxi?=
 =?us-ascii?Q?GSDWkwivMBX77lHQuFhIwM39ZKDM+OpoqPLp6lUNR5cq20V35OvcykwWI8QC?=
 =?us-ascii?Q?2zLOQ2/fzEdXTzK37/mkGuqPJ88mN6oV8rHoFP+6e7sVsnT15PKKQQYymVf6?=
 =?us-ascii?Q?8UPeGLc8/aG7d3wTjz6n7UZJjFc5PB3qOtQHu2ZMatsGRrJYyQ4K7fVhzGAS?=
 =?us-ascii?Q?ZUTOf47hApPATB1drSdLjtp8lUlcIGHX6BQzmHQzdpZ2OLi8nVuFZ3tzw5+N?=
 =?us-ascii?Q?aveUVq1wPEdytR2J5aHHEPiTZGEI855N6otm2q24hGcb/Z9Fui/sUUNBcmib?=
 =?us-ascii?Q?ilEw/C0ujIBEk20Jh783XBrhBwzSQXDiH+mc+bvAAA/L6qbsa03IUnDPkMKa?=
 =?us-ascii?Q?h9gniRP+HaT1j2rsJbdHZ4n59vO7tdApwdwIvJVvhvTd6R5fTmr/R5e4adV6?=
 =?us-ascii?Q?nXdSB/8GVMS5maTdX2E0N1vbweZMShP4Gcu3mnFoFvCuyvnWwQsYmRF1fTOs?=
 =?us-ascii?Q?8Q+G8u0mojd0IYJgnDB8pUb1OOUQJzSOyBb1b4XDVZsLTJNvX6hs71G9m82G?=
 =?us-ascii?Q?TLxcg+nv9gjPTbSGqfn7OItMijvaQASlu/ZGq8081L++oky4hl6zfPcmCn1B?=
 =?us-ascii?Q?jBvD1+1OgEVyFnP5PvB9+JWauq9hpQ0LNmnL6/S9bqICSCQg0OQlwtil/HQw?=
 =?us-ascii?Q?wWEuKDMPT8v56lMQXVZuovNNmnyhUiVTVc/DpO8u?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fbfe22b4-0a44-4491-976c-08daf19018ea
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2023 15:50:42.3207
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p69FIYYQ88D6xS149LIzPFtVLiF8ClP7fNkG2F6swlVQwVy3oJzQTytQdX78xw6IYaJ0sZgvt3b00cWmaWXkZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4449
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 07, 2023 at 11:11:44AM +0100, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> As long as the linecard live time is protected by devlink instance

s/live/life/

> lock, the reference counting is no longer needed. Remove it.
> 
> Signed-off-by: Jiri Pirko <jiri@nvidia.com>
> ---
>  net/devlink/leftover.c | 14 ++------------
>  net/devlink/netlink.c  |  5 -----
>  2 files changed, 2 insertions(+), 17 deletions(-)

devlink_linecard_put() needs to be removed from
net/devlink/devl_internal.h
