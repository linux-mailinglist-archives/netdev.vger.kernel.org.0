Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0B36564D89
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 08:13:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229545AbiGDGMv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 02:12:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbiGDGMv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 02:12:51 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E592338BB
        for <netdev@vger.kernel.org>; Sun,  3 Jul 2022 23:12:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PCACJSzwprKmLrZVhIjiz3cU12A+3YXhX18UaYnJo8m2fPBqaZFPuAc/O6tVuTXRgmAzZBYhaOTNt9zXdGRlTYfZ7uUYQwPvr59v902RAbSOEMVvQJPM/OFUT4hB67nKtvMfCNRWVTdpCxhJBqnI+jazJWW8cxmV4F8R5LC9OCOfvc0X+mXmVr3aKQKtnJp5fh/rK8dbrh+1QPOs/XuxyI69do+sv/vQfugJEzKL4z1Hcdf+DjFtyHPaccn/RcP0oipXGluqzXXY7mrI6FUKczxBnkT8ZR4Zyr/QSnG4nBT+vognLAyHkMa0Gj3CA7q3RBu4OS76d6EHVjzWeC/Iww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LdA/BT4GDbVHKXqBKE698lI3SlqFQvUH4SbwirZgxLc=;
 b=WOOmC1sdzCCzAXy4tTYIGYbJJYHPp8txLslcLrzy579+5g5Tk1Or0G8ZHLpMUFc3cAjj28RRoJFATz4v/LHKMzYJO+J61g1QU9PC+Oyn3TnUeTdJURo9HUebiM6d0jcwBksmb9S6GLSuUWqsjomtwbYaDX6nj5ixUhFQ/tH1DhfW4e8Qo/IiwnKOgMQr/T19/uM5CCG0jlvcPm7H3aNMR4ozt7nsXCXpaCxu1P2Sk4krABLuUBZ21lPWXi8QBSpj3jIcVy7HUW8cTLnQbzStxXRqct5iBKLyfRewx+qBvh9HhwATa6G5VrfXl5WPjo/wmUCy6LtbUMp/vtudtu3EHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LdA/BT4GDbVHKXqBKE698lI3SlqFQvUH4SbwirZgxLc=;
 b=VRtYRyV/xIm5aEjVCiKDNMvPzyEfhfCzk/IlrHqfpj/A9+XiSij3zSKorr+K4Ek4jlDf62fdSoR0y+7N1cpC3ZmoPdJLC9fPmDRv3NFvYFGT7a/P9zEsy1Px6tw0CgGt03DTRuFk1uG40sYnyc3p8qikyX2N5G6I4yIQ1pqfgv+RBGlkWRWeshRfyYFj/R5ReoqFOQbD8h4LUKr0lT2XcK2JD5SqrsUlDnAWX+ifEQafdnHdycL/oMk8ds//jCBSOhEvXnEClvbbqalZjMDFDJt0Qu8nCjbXpyAhrc1bVuy2BMzVAIh2F3T2eMzS79BSODMFIZ4tGnRkXmkT6COJyQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by DM6PR12MB3068.namprd12.prod.outlook.com (2603:10b6:5:3e::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.14; Mon, 4 Jul
 2022 06:12:44 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::611c:e609:d343:aa34]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::611c:e609:d343:aa34%7]) with mapi id 15.20.5395.020; Mon, 4 Jul 2022
 06:12:44 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, amcohen@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next v2 00/13] mlxsw: Unified bridge conversion - part 6/6
Date:   Mon,  4 Jul 2022 09:11:26 +0300
Message-Id: <20220704061139.1208770-1-idosch@nvidia.com>
X-Mailer: git-send-email 2.36.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P190CA0016.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:802:2b::29) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ee7a1fc4-8dea-4a97-1172-08da5d8435d8
X-MS-TrafficTypeDiagnostic: DM6PR12MB3068:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vM+3Xtz2e21QLyZNXEZ20seDRH37ockWj7UmvMVv7EyFuud68i7Vv3GzDjgg8tlEfWnctDi4d22dxW69BHFhrJd+Gde3iwlgY6E5YwZm9Y21vhLOT7Cnpi6XD5AU0uBb6ciR9rKd/fmXY4Ub+atuwLkKF1ThfobmkpDQ7fI3bk4wUy49yw2XA9EyVOkDKJHq/SVaFW+jmCZPQIwnybeLcqEzvx0L7nlwoqf9DN9mCH1zFSZKt0lJyp7o/UesdNGRru4kIERDjMF6iRPcHh+tOEt6OKvIgBWQ1eosW8/Lxz1i8cwKJSKbCTMCdAeq/VgCdvVXj/l1PdO/VUVyRPvaN7wFZ3KIS06cbgk+5R1jH6dcpQ/TVkA3zSD8rnO/nX3ctgJR22WG867MBZOCW2rOnQZIdRepx84U/yLZPPaYGFxexyrNeZcrxvf7E81Ty2du4J3ChT0mE1IzZbPRnsB0UoKa7CPpBNMtIcr+/YlNzOvA8AWdYtHTO0eM0IyWGsbh7dxH4HFp6+Kt8rN5NGJFh6Fh/yU03UYj9UhbLxD68R31l0dcE2bBZDCM6+aNALDQaDBxtOmAh7kjPzdWd352Plgqep1C93eoNzVlRxQeqOHEIYScUm5mq0aSsMQmJhIdruF0M0Yik9C05RO/0Tyo6G7VSqoYcQx8zMRmzduATiJActTMJQnU77jTsxox4mkd4Ec8yAXx2+2TnhArCxddQ+YlU2xqrBnnMK659lMqVW21rOuJqNJHT0htjjYMeiymDWP7e/kaWfPJccaWC71go82S1FBPivo1zXV1MZuhqhHpcJDhP+48iGmQQoN6+XOPYDnmKoG+4GuoJ1UMf73JoQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(136003)(376002)(366004)(346002)(39860400002)(6666004)(6506007)(6512007)(4326008)(2616005)(8676002)(66946007)(26005)(66476007)(66556008)(6486002)(966005)(6916009)(86362001)(41300700001)(316002)(38100700002)(186003)(1076003)(107886003)(66574015)(83380400001)(478600001)(2906002)(8936002)(5660300002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?83vbzT5dLp7l7y63cqy/Uyw9Ktp5chpjhpk6CJb0y2mp7+vJwJK3BRQRJVdh?=
 =?us-ascii?Q?vdtTCJXp+zxoe9V/092iEgkfUr/t+SrUiiKznL06xN6hE4gRHXaq+AEwvIHN?=
 =?us-ascii?Q?OvdnBjASHDkZ88kqsy5QW3SvMQ+Jj5XImzVxnZby/yBPrhPH7JAklMKweEII?=
 =?us-ascii?Q?zoq1SRz+9AFuQM3cbYr6gEfYpCWNbpyTqbaBsXOPpckE/I8cyCf/UaM5EQVj?=
 =?us-ascii?Q?vmF7kY7u4iR4GS20a3WzBBQaUUJZRqy2NEKIXAW7P6yAPAWwycORLdqWnzto?=
 =?us-ascii?Q?XE5BxVLEHOxfgrZcP58L7vjBgOAayK5yNe1XU2/WILzD1S4G6mh4sO8tAjEj?=
 =?us-ascii?Q?eDHXhY9qfHRMkTVERt1999AvuIKCes9NlhY4/i0dGsYpBNPdJCifyVg6tjHo?=
 =?us-ascii?Q?HR0V5PtQ5CCK8BfDDQx09Cthds0F64D8wvgryOGzDLvA6GalprR96l2Jcy9P?=
 =?us-ascii?Q?zbYMbySF6WbSuQEn3dOWfE2ER8i/URblyGaXL5GWNw/Qz1ph/owy/2oKQIQI?=
 =?us-ascii?Q?DnQKirs/HTjtuFCvPfT03dbDxrHsIBgBIKd1vSw79T6INLvC+8qespg6qEAz?=
 =?us-ascii?Q?uBj82JwctpQnhqHmCyEe8Qum04JNBbeDtqOCzPXXhZapfcMLe4RRwYBkzHBH?=
 =?us-ascii?Q?A/PQ63bvwyLiLharwd6yXAZHCxWtYKkFIn6XgrLDZL42affY0H4YTS97LwGO?=
 =?us-ascii?Q?IIs4QYqnskg76of0QwtZo5KRliM1Jgi1drtj/utEDj1Xm5hB5atNOvEAbzHv?=
 =?us-ascii?Q?XJ+ElxIXSyhzLtRTJkkWFx5fjEVx68Dfnlv4wSbmGTyKYXgRkrPHXxRptde1?=
 =?us-ascii?Q?mWu2X7WKted08P1WtVXIqxUgzY9WxUpkA8M2xKI/I6WNR7JVoVRW2XrSjG2d?=
 =?us-ascii?Q?B0Bi296KtNv6srz1eHwWJ50X/151ORoyGuWQcwDSYDCuTcF0Br/atBF3u0Gz?=
 =?us-ascii?Q?+SDXCraTFaBrFGaeiiUHIQIimBNrkS+SMxbLdi+wFRSoAgmXFBX9V63PL58P?=
 =?us-ascii?Q?g28zLv/LCr9R32tKNEGUBqohvuhs95uQbl+44FHY9q1nk/CopzGK50fxu7Da?=
 =?us-ascii?Q?oLS9920bymrCDXp9d4PXb1yCYxMuOs9zAu72sqtRmXw8oxrD4LvS0uJrztEm?=
 =?us-ascii?Q?1AFjd0vpXvKH988zI5YiWpbCs2p1Xa7Ls3kiae05LrkThwEAJgWXGzfDuXoU?=
 =?us-ascii?Q?BDagwwQQvs5s0i2p8Uoq/Cy+6p10X5EswqbMaMElA+ecnRlVS5NkyoKnE5Jf?=
 =?us-ascii?Q?WbpMYCNMkfKltoj53rWLAPCuM9lgYZX0RX6xOvFAVdPBmrfw4NSlREDOail3?=
 =?us-ascii?Q?43k3QXpXrBDZoqouFv/RVWv07iavFvD7CUYMSbsmc8+9s7UWOZ33sr3s3A9n?=
 =?us-ascii?Q?er2TWvfM0kK0JCNhdm3BI6XokZ6lWAs8nl50SNX0LumAgHSVw9QHwRg4XxfD?=
 =?us-ascii?Q?/1h4c5hjcGFOHjem/EDfKY1O3AtBN22qhRXq23q8FaTMPXGWCU6HNcYJQunm?=
 =?us-ascii?Q?TyxydiANyL42GjRMhbfRMhGWbMkX13gYYcb47gs7EWziIM1/gxCTi+1vIJmN?=
 =?us-ascii?Q?11vgu+zRyUHfjDF8NnQ3a0HOy1xg2yAg+anp+VBH?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee7a1fc4-8dea-4a97-1172-08da5d8435d8
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jul 2022 06:12:44.7703
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WOFdnyeNuLMI1A8iCbH6Oq8NNOU93m3dnSlmLJ2MG2DlG1cVuARt5cTZTHlMEPBxqV2WpOifcem5lP7fbY7ZPg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3068
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is the sixth and final part of the conversion of mlxsw to the
unified bridge model. It transitions the last bits of functionality that
were under firmware's responsibility in the legacy model to the driver.
The last patches flip the driver to the unified bridge model and clean
up code that was used to make the conversion easier to review.

Patchset overview:

Patch #1 sets the egress VID for known unicast packets. For multicast
packets, the egress VID is configured using the MPE table. See commit
8c2da081c8b8 ("mlxsw: spectrum_fid: Configure egress VID classification
for multicast").

Patch #2 configures the VNI to FID classification that is used during
decapsulation.

Patch #3 configures ingress router interface (RIF) in FID classification
records, so that when a packet reaches the router block, its ingress RIF
is known. Care is taken to configure this in all the different flows
(e.g., RIF set on a FID, {Port, VID} joins a FID that already has a RIF
etc.).

Patch #4 configures the egress VID for routed packets. For such packets,
the egress VID is not set by the MPE table or by an FDB record at the
egress bridge, but instead by a dedicated table that maps {Egress RIF,
Egress port} to a VID.

Patch #5 removes VID configuration from RIF creation as in the unified
bridge model firmware no longer needs it.

Patch #6 sets the egress FID to use in RIF configuration so that the
device knows using which FID to bridge the packet after routing.

Patches #7-#9 add a new 802.1Q family and associated VLAN RIFs. In the
unified bridge model, we no longer need to emulate 802.1Q FIDs using
802.1D FIDs as VNI can be associated with both.

Patches #10-#11 finally flip the driver to the unified bridge model.

Patches #12-#13 clean up code that was used to make the conversion
easier to review.

v2:
* Fix build failure [1] in patch #1.

[1] https://lore.kernel.org/netdev/20220630201709.6e66a1bb@kernel.org/

Amit Cohen (13):
  mlxsw: Configure egress VID for unicast FDB entries
  mlxsw: spectrum_fid: Configure VNI to FID classification
  mlxsw: Configure ingress RIF classification
  mlxsw: spectrum_fid: Configure layer 3 egress VID classification
  mlxsw: spectrum_router: Do not configure VID for sub-port RIFs
  mlxsw: Configure egress FID classification after routing
  mlxsw: Add support for VLAN RIFs
  mlxsw: Add new FID families for unified bridge model
  mlxsw: Add support for 802.1Q FID family
  mlxsw: Add ubridge to config profile
  mlxsw: Enable unified bridge model
  mlxsw: spectrum_fid: Remove flood_index() from FID operation structure
  mlxsw: spectrum_fid: Remove '_ub_' indication from structures and
    defines

 drivers/net/ethernet/mellanox/mlxsw/cmd.h     |  13 +
 drivers/net/ethernet/mellanox/mlxsw/core.h    |   2 +
 drivers/net/ethernet/mellanox/mlxsw/pci.c     |   5 +
 drivers/net/ethernet/mellanox/mlxsw/reg.h     |  30 +-
 .../net/ethernet/mellanox/mlxsw/spectrum.c    |  29 +-
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |   8 +-
 .../ethernet/mellanox/mlxsw/spectrum_fid.c    | 780 ++++++++++++++----
 .../ethernet/mellanox/mlxsw/spectrum_pgt.c    |  21 +-
 .../ethernet/mellanox/mlxsw/spectrum_router.c | 147 +++-
 .../ethernet/mellanox/mlxsw/spectrum_router.h |   1 -
 .../mellanox/mlxsw/spectrum_switchdev.c       |  28 +-
 11 files changed, 829 insertions(+), 235 deletions(-)

-- 
2.36.1

