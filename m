Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7C29689C07
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 15:39:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233120AbjBCOj2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 09:39:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231233AbjBCOj1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 09:39:27 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2073.outbound.protection.outlook.com [40.107.223.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 216F634312
        for <netdev@vger.kernel.org>; Fri,  3 Feb 2023 06:39:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j//NV0LGy8pM716kDphFHRbbXTbCzBM/AKGIYx9zd1ZynccmqkQiB9vRHVmpJsdJEqW79LwuaGoQlDuPC8kIYU2QsrIjXDDy7ZCJAwHZIyFHbnrw49DaILckpVc+GR/VozjLzRBcdSGgngCsTueRP7r+dj5m7j/M0RTU6j7uE6m5wYcGpfbOqzAJ9SiUhrxjdvDaVyT0hmoVclKr4tqQlD9zQr4djudxv+b+faoOp3LufQvlTDuqVnWRBwQYFH65eByDE9W2lVAdfSm9EYt6pSFhH8ETBeaUr++snp04Mu+iPfSaqNXnGJKqEvFoHeGaoz1vacx42VEN/E5i+wbCng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pcPpoSiSaGxNIfnuIIRDoLKO9CGyQ76D8Xx9uyJRWWA=;
 b=l1iMVaiY+HypL9kA37IMxo+8rSa9MrU/B6fHBXWubfs8EUn6i4eKdf5FPx+U4LGDok/WqH0+mC2ybnnfhIacNK+ni+BzP+LXoHh+qJSZNKgJ9g3YHfnEmo3Fk3G3Zoipr54eGJNWb9Kq2/64DhSqj12ruMGCP4YmF7B1btPJHKGs2oyeY/ZZ1nZhJS8XBx9Q6OHF0DO6vjJBrZJgRXBSrsHST9DbI7BbtYMGE6p8RhQ2XpoB8dCGpY7GNb0m2ziUxBPeFdK/2I65f2JxrUZd/UWz3FoMufRtrSZ1z7VxPdZoor7AvA6RxCkPeiOMadnWyiEErbiigp867xa/E1l+4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pcPpoSiSaGxNIfnuIIRDoLKO9CGyQ76D8Xx9uyJRWWA=;
 b=Xosl8u09r8DyYKvTrif9/ScUiBtZm2QEceLMRH3L6pSRsRzAIQDWWA0wEAH2EFz+SluBrPIMa+dKmEnSXBQ+htFpTBkrdnNkG4p9aLC9NH/lZTgelMhu6EBAYsuY8pfub2WxVtsZwUhAqKP2rbDwU3xhDkp2xic2HCH77GdRsCXYfz3+jCfrWDjS8tiDTaxFji7OzFPxWwS3UwQAjH/8mlAxLuGm/KqtWpV2f/+8mzYuz24O8W1asa2ljYFhrwdTRMZjxnb4WrYXsq3+9MZ7pL40A/gyFjO5ggvfbXJa5fx2GXrk+d3JxNba+7+W2vKg7yqDv8vhG0bnSansMN+H/A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by BL0PR12MB4865.namprd12.prod.outlook.com (2603:10b6:208:17c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.25; Fri, 3 Feb
 2023 14:39:22 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::7d2c:828f:5cae:7eab]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::7d2c:828f:5cae:7eab%9]) with mapi id 15.20.6064.025; Fri, 3 Feb 2023
 14:39:22 +0000
Date:   Fri, 3 Feb 2023 16:39:16 +0200
From:   Ido Schimmel <idosch@nvidia.com>
To:     Petr Machata <petrm@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Subject: Re: [PATCH net-next v3 08/16] net: bridge: Add netlink knobs for
 number / maximum MDB entries
Message-ID: <Y90clBUNv2c8ScHl@shredder>
References: <cover.1675359453.git.petrm@nvidia.com>
 <ad5b9a4a971f7a38951cb8475ca3c9a16057b0fd.1675359453.git.petrm@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ad5b9a4a971f7a38951cb8475ca3c9a16057b0fd.1675359453.git.petrm@nvidia.com>
X-ClientProxiedBy: VI1PR04CA0122.eurprd04.prod.outlook.com
 (2603:10a6:803:f0::20) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|BL0PR12MB4865:EE_
X-MS-Office365-Filtering-Correlation-Id: b5d02e75-287f-49fb-577b-08db05f470aa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vpIseCE7lFvegtEX1j5TWD4s1FXg4h7lLSGseyekT4MKBSvGz9ZZN/k378h71V1aZaWuvAnhg8C4RxUQURB13dq3Qe2bj4Iepe2vwBrbkfGRnwLsW1/JjSBFOjIr1ZLOCIIBJNJDH9amdkw+u6do4h9tbJT7JwehxlSiZVAbLXcLIl32fBF0NckyNF7Yrg2UK1gzmcW4wq5e5qQ+6KrzAgHS52p7T0v17kig2OKXHKs23htEqqAu+fE1q9adpZQT39e0EFkEebMpuVzq7vETDPD7X6n5dJzYDbhRwgMJRY37NaXNoVu45mfezR4CaB9MKdXj3ayjJ8+UAw3wJNlw+0kEc9FWtlwUl6RKzqxMNf6ZGdgV06H/AqTfCuN2KDrnGutE47jIfWpklYdJ7ufiw/h3KQfpm+7lL9fwUzs+fUMptpJ1442H7dvxdpT/6IViVowN6WP36gjtQIu5p4NFIom5PLKtRtxqSPMoV/0NJndrlGu70jtKOquyNPFyA4XAd+2IdfmvSv4R8WRseytyoJoT7nxf8PiQV6PVrtt8QIgZGlhIuKjiPU8HcrU6fRHaRDArVdX6jiHXh8OSLVu0JGEkRqhhyJFZY+uwqRZhbb/NF/XxOLP0I22V1G1RTGDPIg66V2DGqhwOGU8gcaIHXg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(4636009)(396003)(39860400002)(376002)(346002)(136003)(366004)(451199018)(5660300002)(41300700001)(2906002)(316002)(66946007)(66476007)(66556008)(4326008)(54906003)(8676002)(6636002)(6486002)(66574015)(6512007)(6666004)(9686003)(478600001)(26005)(186003)(33716001)(8936002)(6862004)(86362001)(83380400001)(38100700002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5n+xtVPDkPtzLceLpEDXSl2HUOuN+EMRlVP1AWPDkZZBTnziOGemANFkQUHN?=
 =?us-ascii?Q?FH1BBqLFbtfxe1wHQ1pMPzLyho6qQ8wF21pFe5tX7VXhJjpx3IAL2CCOE1eX?=
 =?us-ascii?Q?d82HCo5WfmsuIq0m2jggBU7K6zuBHVnPyN4skZZSUeW0l/FL/zYiUiwBO3LN?=
 =?us-ascii?Q?zKmXXA3rFEBSi9VPJ76h4YHZuxCMMySn5u48oUQ518H7pXYgQ9hST0JAzoe3?=
 =?us-ascii?Q?NXteK2XGZQ1rVud4Own/VXej9rEGNR7dGdb75GwinX/2iSU/D8xMV8m1d1sT?=
 =?us-ascii?Q?DIoue/7rwgz+jPpoWED3ICG6PSWxi3ypAfMLqZA+lruKqT8yo+85ih/0177x?=
 =?us-ascii?Q?cHT+qDsoxm2aqIyGgRQu2A4AFzd+MJJn59BFiOj2X7bDiBAf/n6eHEUo8Tso?=
 =?us-ascii?Q?uZqvV7ZlusGOYtom3iUFk0L0PZUJ5HhbHp3H018CmNNW2RV9iJk4q5nG7X81?=
 =?us-ascii?Q?GGlSIvgnUg/Ahv7pEz7A3j1FHI0WytIJ2ZEAm9osDVU6lnSsBxQG6pMrXadR?=
 =?us-ascii?Q?CU5quXG6BaRbTmJRtf3QNqC59Al8uhU/+gGNI13moAe40hPAKDyHZM12fL2Z?=
 =?us-ascii?Q?Qj+xp6/+w9PMU1UQ2aCXJZfZYagfSispSPV+CGyibwDxPTe7pu3HabunIx5T?=
 =?us-ascii?Q?IuJXgiI377HgM6+WgBfO+4mifsSfhnaSnrzU+T614C36Tw/C4dvR/v/Esj7I?=
 =?us-ascii?Q?BQarQFg/9/1ELK3jbDpFzZ+3KYIMK0XF8Y0CBHXJEftUfWp82KzPn2ZqdkA9?=
 =?us-ascii?Q?0w/+NvVCXVzfJDWp+ree7Z04OU8iZMPLDKB4ajNrWenN/7b0ba43lsiyiYu+?=
 =?us-ascii?Q?h+POTgyWe8cC372oYQ7Mpsr5GdYB/xJVmokOyAtynf/Cf4m2K2Kd13o1dgVF?=
 =?us-ascii?Q?BeJ4sbaSDelLmfDUUlic50jNmeHj6yHB/Vk78tARhfzqCjdrmVdb5jttWuY1?=
 =?us-ascii?Q?YoxvaxIYZgt7qWgpniR1R00rFq7m5DZEEpjttCdzuCxHHH1VMjSvTwCykhyX?=
 =?us-ascii?Q?DHvcYeq7bvzabyIWGKvJOJEjU32RhLuxgr7t0f4PSPZZurndkK48QN2Q7rml?=
 =?us-ascii?Q?IMorAqgSVo5hA7WzgNAoH4u8Vf0LGKwh0HfJevgwtBbYRzO4ACJMnJkJ11Qp?=
 =?us-ascii?Q?COD40Cc1Plr1ApTSO/yWOfhAZxO+eXD1Csk7p8tRr7QVz+SpCDX0pectCm4U?=
 =?us-ascii?Q?kpMJUU5+Nq0Dmgol1CQ6JHfM14r8aPnrtAz0mBLf5G2u8uSigX2cfJkjxOse?=
 =?us-ascii?Q?FEG+OP1rTAwsdq20eZgl7nvGF7EFHqTQxqOGIExSOMZnEUfWpXLVsyW7FDa3?=
 =?us-ascii?Q?X2M/l2SEZMLZ2pGiv7SNSO17Lp6j6iFivsY7EjQ42JHgkBgel9F1XLQ2zMeX?=
 =?us-ascii?Q?apk9syc4IjvrzxgS0sfKQf/ltGHcP2vNJD3u8PCocm8ylW1mJSsuNgdxt6ZT?=
 =?us-ascii?Q?floCi83yw4ypyWNo+jlDnpaWuUW49JvqMeTA5DnwT6r9pwuxgJt8/rRehply?=
 =?us-ascii?Q?mP0HWsnu2eLmNJvuDieTLtdmWONM+kUsRY4Ky81WDpTbKmybQBh3y6T/+Ybj?=
 =?us-ascii?Q?+x1E3C6dhWZnNMXCyscnR9UbFe1jJknCzoCGeAzb?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b5d02e75-287f-49fb-577b-08db05f470aa
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2023 14:39:22.4817
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1EAQ32Q4x7PuHr3ZG20aTfeWL5NL3/CQMNqiUeoZltDvH107i5EmgU/+cbgrGd5WZAVZYAIG3nEWa5xdkbz4VQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB4865
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 02, 2023 at 06:59:26PM +0100, Petr Machata wrote:
> The previous patch added accounting for number of MDB entries per port and
> per port-VLAN, and the logic to verify that these values stay within
> configured bounds. However it didn't provide means to actually configure
> those bounds or read the occupancy. This patch does that.
> 
> Two new netlink attributes are added for the MDB occupancy:
> IFLA_BRPORT_MCAST_N_GROUPS for the per-port occupancy and
> BRIDGE_VLANDB_ENTRY_MCAST_N_GROUPS for the per-port-VLAN occupancy.
> And another two for the maximum number of MDB entries:
> IFLA_BRPORT_MCAST_MAX_GROUPS for the per-port maximum, and
> BRIDGE_VLANDB_ENTRY_MCAST_MAX_GROUPS for the per-port-VLAN one.
> 
> Note that the two new IFLA_BRPORT_ attributes prompt bumping of
> RTNL_SLAVE_MAX_TYPE to size the slave attribute tables large enough.
> 
> The new attributes are used like this:
> 
>  # ip link add name br up type bridge vlan_filtering 1 mcast_snooping 1 \
>                                       mcast_vlan_snooping 1 mcast_querier 1
>  # ip link set dev v1 master br
>  # bridge vlan add dev v1 vid 2
> 
>  # bridge vlan set dev v1 vid 1 mcast_max_groups 1
>  # bridge mdb add dev br port v1 grp 230.1.2.3 temp vid 1
>  # bridge mdb add dev br port v1 grp 230.1.2.4 temp vid 1
>  Error: bridge: Port-VLAN is already in 1 groups, and mcast_max_groups=1.
> 
>  # bridge link set dev v1 mcast_max_groups 1
>  # bridge mdb add dev br port v1 grp 230.1.2.3 temp vid 2
>  Error: bridge: Port is already in 1 groups, and mcast_max_groups=1.
> 
>  # bridge -d link show
>  5: v1@v2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 master br [...]
>      [...] mcast_n_groups 1 mcast_max_groups 1
> 
>  # bridge -d vlan show
>  port              vlan-id
>  br                1 PVID Egress Untagged
>                      state forwarding mcast_router 1
>  v1                1 PVID Egress Untagged
>                      [...] mcast_n_groups 1 mcast_max_groups 1
>                    2
>                      [...] mcast_n_groups 0 mcast_max_groups 0
> 
> Signed-off-by: Petr Machata <petrm@nvidia.com>

Reviewed-by: Ido Schimmel <idosch@nvidia.com>
