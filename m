Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF8225614E7
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 10:24:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233635AbiF3IXs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 04:23:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233644AbiF3IX2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 04:23:28 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2071.outbound.protection.outlook.com [40.107.237.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CB0513F91
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 01:23:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=diZ7XUkMMAGLgKjMaXt/K5x8HN7l7NnVNeMOFwBdIH3auADmYWet4OpPQHPN6zhC/lmfTeW8aBxoEHI6yn+mhn+vKWUiy/pQTheqrj5vFjuoIbPXM6i9qAOr5fwb+5hRn4H2Ll3iO+7Rv1uXBh+ZeGbvjKOMrSlr/OS4rDy4P4X7SksF0RhkhRZYTbyUi9/jZ5KRiGO0w8yB0UaMXZosYq5OoYomjnY1uOSGIimyusT/c1h5uK1vZCvIGRqsto/LxIHOQVsOZ/X876wbPNiahGXzspmVS1DNGDKQKaxQnB/XngdciM3uKck8Lw10B4ptvk/8gvb9I0EdgqtI+uVc1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1kL5BZiHZ4Bnm35s3LC8p3AvxwnCd7ONlEZiwt1VZGI=;
 b=ZWAbLOiUNKh910JWygupeczBJC68oUMlq0jQlXjmsWuKvMdCoLYV6kEGjZH20kTIwzltpkdUm/4PKIqv5/OtUC9TLZs/frS/Io2AHuzVVSSFKOLVKO8uoNACNkffXYO4FwaMeDSXkqhVuBW8w93qOOif4vTCXSiXW+kBSxkV+lhgcm56lV2jLnBSNtkH/mmc9AFJVvwgL2MnYRR40cn3rLGjsF/cfyBRTK/1IWJPnyFGURD/m3vv5Y6oaxGkxwO7VzUNm72dqpAWY/8tfNP0ocMUirVlyZ6sMQQUJlE+KpeKzR0b2Jz2NhkDs5APupRmtEz7CDcLgA5UDL26m+ZALg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1kL5BZiHZ4Bnm35s3LC8p3AvxwnCd7ONlEZiwt1VZGI=;
 b=T4j0HGot5CaI0gJ6ECcY32FdDSDKNTrZSx8f1zdce1HEy1lfv4XshQz37MLZTyoxcL9o6Ta7BDANvBFRQIg211RUXDwt22TOm0+FJiEO1LkrHHZyTHYhy2h3J+3oB2k4MS+T3xqmdkNN5ZpIj/N9XdaXlzhorhPmBYtrkNAzWxiBEL0TZmaV2c7zUTD4px12N2EFsbeLed+XEvKCQkSp9rAIc0bHp6149UgltvjQ6PaPoMuuGomnT6E62rrZy/8fSoEtq7o9Kntzn5+kZ08BuAAZwVtw0+rMD/SUL1vQlcxphAwBTBaG5D6PV3KM7mC79pvy8Q/zDGzXu9QjcDjFjg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by MN2PR12MB2880.namprd12.prod.outlook.com (2603:10b6:208:106::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.17; Thu, 30 Jun
 2022 08:23:16 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::611c:e609:d343:aa34]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::611c:e609:d343:aa34%5]) with mapi id 15.20.5395.014; Thu, 30 Jun 2022
 08:23:16 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, amcohen@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 00/13] mlxsw: Unified bridge conversion - part 6/6
Date:   Thu, 30 Jun 2022 11:22:44 +0300
Message-Id: <20220630082257.903759-1-idosch@nvidia.com>
X-Mailer: git-send-email 2.36.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0502CA0031.eurprd05.prod.outlook.com
 (2603:10a6:803:1::44) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6df92238-e943-4975-82e1-08da5a71c7e2
X-MS-TrafficTypeDiagnostic: MN2PR12MB2880:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /nmkMUcyjaMotdZjgvVUyFpU+QLVVOJ3uGS1d++QPCyGfumcnbBnHzaTwWq0G67hxdvxaF/b81XWqySS1E09N6crdtglx1IoG58EXLF2R1dBWvu1gG+o71grLGxk3jjgghET2YidvSA1iVidF953DefDBjx9vgmd/Fxpk8P7F2KF95HVqZikn1T66QxHlva0wNbz+u/xDRv5ODHDbYk+n8gdBfbilChd7EY471/XMaApgLlbKhV0Rfet9pXjQ6CiS0htx8PgP+d94p6C8s26EarCbMmB6HNKV6Sc4fdnf5xSwV1Yc748BmiqERd9QWaNEtIjJ+zXf7wRCisEtCsHliOfwTYEkFxC133v3B29fklpeps73S1c+sZHguionItPQAPdwA4YJTAJrw5ybOB6qdMcYGOrFFtP3spyqA1G0EoYZO5LCNR5ZDHuTq4F74yrjLNSE+5v5yCTXFlGBHEnq/jkb55KGDtp78NMKO7yJbCE6giI86U0JMspptvKuxHL9mpfuPh9NdJ74MUjajbsFpbOBVXLt+nDAHo3M+SZnvOFiiT70/rNOMURlkcKSHR7d4xuQ+mIK88ukb60Qk8DaL3Zfcuf2OXcNFmShim9mKIueqXB6EZfNPThx0HoL9XgF37gKUUTdCdt0nMn6XODBnN1gebim0O2wci6qFHjPgAAfObFxCDJIY3BKa1t8qWBGqkzJ33dKzzqnAbo9bQnO+UN3mqeeOJ46S+WGcgM/Aj5xdpa1/siVS9AnC5e7newL4+kJ9zW2cCSz73o8mXCfw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(396003)(376002)(366004)(39860400002)(136003)(86362001)(6486002)(1076003)(36756003)(8676002)(66556008)(66946007)(478600001)(4326008)(66476007)(8936002)(6916009)(186003)(316002)(5660300002)(6666004)(38100700002)(6506007)(2906002)(6512007)(2616005)(83380400001)(26005)(41300700001)(107886003)(66574015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vRKAGOvc247UTF43AHrp2NZ5JBozPG11ozMLwrjEnUzWhJMn81yggOYEuFqQ?=
 =?us-ascii?Q?LHmR9bgVOxODxasUXkuEIfRbOae547GkaEefS+J2WToCupmhqQ4/pfR3WbpR?=
 =?us-ascii?Q?BL+4qBRdVdRqfA6Jkr0VoyLlZe8SDo0Vha7beHahUXsjw9ZitK1pflaZuFoZ?=
 =?us-ascii?Q?+p6Vf03u8/WozFXE5yFuhTDybHQ8yVf2xku5bvm6TQs2js9tQK/EoaDWZHXp?=
 =?us-ascii?Q?eZvYxlhBH59XvO6lBfBnwGGJo/pgJpYYRXfKqAuCKHU+FOceyPocoDkmn+mn?=
 =?us-ascii?Q?NLEzr76mQ95qtRL4SqCMI2gsbMOtk31nvK5fCYGPp6psd0SB8iVdKTbSxOp4?=
 =?us-ascii?Q?woU0i3kujISsks/l4H0ILFiu7Kf1+Nsmx9MQDqL5X/DkyxvwAccpUhd1Mk3U?=
 =?us-ascii?Q?fhoUB8l0hYyd8PYDGYuziGN23EviEHCnYmzIebM1Qc+KipqHxnHUFZntfjWD?=
 =?us-ascii?Q?061qIF1JDP3qtV1mAOapvtlnzV75N6AUK50GdJwukHz3RxnpLYrStsfj7OCj?=
 =?us-ascii?Q?jhjf25e24fu+vQJhbZ27y7hmYkocWKlqxKpJ8DLKkphpk4bwSF7jWU9owsky?=
 =?us-ascii?Q?PeKY8JIzPcQ/oiW6ldbOmd1Rvl3HOaHl7uWbVqq8EFkTXzx9O+JsNhWRIhA7?=
 =?us-ascii?Q?p7LBXbc36W6G9JTnZ1WJr5uDZ4O539S/yIpWIILh0/SIrPjaBaYcDsdxdXCV?=
 =?us-ascii?Q?T/4i5PcVeZSwK9r6r7IoCfkqtWPSYt7V75QshD7Rsr3+Ib+xywHkL1aZj0wa?=
 =?us-ascii?Q?3tQIOfCa0c1CER0m1s8pRnlq9qWxQvPOUsv+DGnVMPiaXvcZ/b0V0gFywiYF?=
 =?us-ascii?Q?1/bghRvYMWtFGafaUj+4GZE91JjWPuFbXouRtOXDh1U9k8Db0Nj9oJoDBRRD?=
 =?us-ascii?Q?v/mFHvmO2AzFvgqkbYY2gLRqiYVP18qsD7xgIW6jq/fHX8N+swz4xbUBRcfB?=
 =?us-ascii?Q?53geiVCbzub5ECju5W1eRdOUeJrxhEkPQmI9YfEdhN1iFVCZeQH4yy/hEI44?=
 =?us-ascii?Q?qGJVc04WynZZmNXq0PkTQ7xJoPoZb6PIMtgPNC2daj3fiv1bCpheaco84jHm?=
 =?us-ascii?Q?b6jIgH3yKliMtuvOyyaWJ5/eXXESOgiLmnk4E+olfq27deew8Ju60IubjXpa?=
 =?us-ascii?Q?TpcxovhhJamU6uZMexZuFXgTu1VUEYxsssvbLuLwqqFaF5AAHhJJn/IrAuw7?=
 =?us-ascii?Q?5X7ASRBTtLlkAw8uXtqyRNZeBPZCLDL5uPIRF9AERz9VA5wPfijuQ/ERvGba?=
 =?us-ascii?Q?skz53OcCci5hpfuQi650bldUfwBpAyJewy/jrwB1HMA/cbU/z+iGlp9Wjkob?=
 =?us-ascii?Q?dShb4QknhL0DwzBbPbuv5n7hJlQYH/QopjMLmM7CB4KIiIGl4FrklNuvXccI?=
 =?us-ascii?Q?VZLbJ0dhXrNsOdm5KXUsf1/1qWCgYTjONSPiUSbTr+/YFmtGLXv0kjcD+WcC?=
 =?us-ascii?Q?QnKAbWOJ4lJ1+I9VJopfNi05ULc+2857j9LwZCWf4ZX46nHEMbO5NntKf1M/?=
 =?us-ascii?Q?UP52m76GbU13K+mgICtWaqaC8vHRdgxMQ509OjQSil0OgXlXPqJlAt7l2FS7?=
 =?us-ascii?Q?vlMBpp29CSKKFRSROPzAQh0jFO80/B0x3J0k+3km?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6df92238-e943-4975-82e1-08da5a71c7e2
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2022 08:23:15.9692
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hROYiRO3npXxqj+PS51FPoltUOO4d0yywNNPpSRmnjoh+m64wkHCn3kDUDgvuJQoKniAdjVbXM8AMBho53cgZw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB2880
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
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
 .../mellanox/mlxsw/spectrum_switchdev.c       |  24 +-
 11 files changed, 827 insertions(+), 233 deletions(-)

-- 
2.36.1

