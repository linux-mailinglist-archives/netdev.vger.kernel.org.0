Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97A074BFFF4
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 18:17:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234598AbiBVRSA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 12:18:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234612AbiBVRR4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 12:17:56 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2075.outbound.protection.outlook.com [40.107.244.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77B4C109A59
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 09:17:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZNTPTdTLOQQTceRmVCHeU7qX9MnsmicL4nLiMzgqTRyM3rCNCOJRqmwfNjXwutfewrTOhGf/WB/eWr9/M7PpzEg213IpXtKoGCibZ25mr7RTzPJnurD/KgMX1m07UEE9WavirWOCZ7OojN/M7Pp8DUhk4hvhoke8RK3mEPsNC40iZaDOs3KpK6sbAtI+BYPfWOOLmMZLzJTzTK5rm0PT0MDRkqdmIpqlmlTAB3LF7L/itNKT5XMcTPE/4r78nZA+vJIjP9uwGeZHfAW9ZHgF6yniWgDW2nxQvnkRvH9OUq12MBsF2FuKhiw8ZSjS2d08dCSKKHGfL4RoWi3npfC+pw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QfBDH4HKjtKwiblDTAG+0U9gAVC9njQymNg9K8/OPa0=;
 b=cTLHAAHhioqBLvvI4ODiu82ULtpdu9gXy5EQMsU7ymm3Ob1W61LXrDpacyq/86gSQPBovKUoO7YpfNBgekZcXN9nHnf2I3CAZoAFg9IA4Y7cG38lfQ/RH8TJuG5Pd26ttEwQ5GB1awu6YflCIsV5wAeMo6xSKbgeC0Lu/eizPyNKPNWyCPusuVQ+PwlnnmjBcyZNRWEE3ChiWN2F8pr0HC3OwL9PuJskyCfok5yVJZ5VgQdxLzKEDQp+KmnFt/BMGRccGkVZHIR5p/q7LPbmLF4+V8b07rzM5frpVQKIviA3Fw2xfLJEvSzUDKbL4pBBWivJJI3VG6ej9vUZG6RYdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QfBDH4HKjtKwiblDTAG+0U9gAVC9njQymNg9K8/OPa0=;
 b=E4EvRYpnZjRRpdQR3x35i9Ew0X9+xKCtDB9dayKbCx30w/oZjAMSQmGHYRCc0PLoNditVI82AgjyobWgAQaKLOISSkjrnPj64w3skykfEhtmxd1mEYAidcejLdSEMLc/pdX/Sm3KAUronlvXAC7CkTcRzAv2ueXfGVH1Wegzrd0ubUCmU+5k6AqHAKzqUP15jfUnmQHhlJdVWF48q1ZHbwYrRAOXPz7Kr+xYKTXEJ1KOnKiAR+mNf9QEOFv3N8aQfh8QEHDXCCIiqxllM3dNsTl0/UK04r11JoENX5Gy1SdYbRrEWTG3ptNNA/VbKTuQQkWAWuvQWrgfpmxxBpAilQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by DM4PR12MB5214.namprd12.prod.outlook.com (2603:10b6:5:395::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.17; Tue, 22 Feb
 2022 17:17:29 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::95a1:8c7f:10ef:2581]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::95a1:8c7f:10ef:2581%7]) with mapi id 15.20.5017.022; Tue, 22 Feb 2022
 17:17:29 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, petrm@nvidia.com,
        jiri@nvidia.com, danieller@nvidia.com, vadimp@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 00/12] mlxsw: Various updates
Date:   Tue, 22 Feb 2022 19:16:51 +0200
Message-Id: <20220222171703.499645-1-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR06CA0087.eurprd06.prod.outlook.com
 (2603:10a6:803:8c::16) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 48779b77-cbce-47f1-5f98-08d9f6273434
X-MS-TrafficTypeDiagnostic: DM4PR12MB5214:EE_
X-Microsoft-Antispam-PRVS: <DM4PR12MB521447EABCF082D405704DEEB23B9@DM4PR12MB5214.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 01CDyoDkP1rzpjxcobJUQ808l26GnSEDJZjSNACdM8JdPaXhiN4qqpv5m5zWGEk63cqSa8mI6GQLjrAEael6q6rri3A9Vy1mJ/hmHhsa2BSVLhG8mXMS1y1qUwR8trVqnqOAmLpr/3vXytQr0m8hp/WJdmXDl7kmle7ViWR5zLN5qVrK4B9sJN7YRiwqKXghs8axfmG2NuG9KTP/lZHEBbENbdZxG8jnx0vwvekrHDTDqaJYXBHdJ7acN3bbZAYrtT/2IFqL1l6/IpJ97/OEMrnDeRmYMezlLskrnBSjzbF39bHKq4ZQ0uawxLosUQ8YZQln3mTSQz33wHpzoUond3JGQc54kNM78m5cHN4YzKEQZVbmZfGICE+tEJjUmaV/KptcMUGDeO0nvQV7VOyCXeC4VW7XYejQyeVBJwOkcEOxBw+APiTjZG6kgpg40gF2s6BtGfyIcGcQ0jZ4KNJp4OZJUbpw/GT5BobqqE9nt3TVDUZMf34NyADtlp9rm1taEVOI3Px3es5K89wjNq55fdyWeeSoKpla6sEBN1sRlqfngYKM0MndYuNELKk3rkVhGwD1QCp2ePXBL6Z++f14NyijGGHPnKDf9XIottcUwhLUcPK2xCPi3A0shnt+mA23VX26XfbNMm2zqg1lOvGFRQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(83380400001)(6916009)(316002)(66556008)(107886003)(2906002)(2616005)(5660300002)(1076003)(8676002)(66476007)(6506007)(36756003)(6512007)(6486002)(508600001)(38100700002)(8936002)(15650500001)(66946007)(86362001)(26005)(4326008)(186003)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WnFBOychZ0RJsl7CQMRaRCdvm4xkmCUfaIDMrZXKqQY0JpUB+JNh5AknLofz?=
 =?us-ascii?Q?twcFuUb2Xcf6t6+UWI/JLg0Esd9KSE4Nxb2rIzNzomj+L7Ox0S+Z336ws//X?=
 =?us-ascii?Q?L1mmcnP+qNt5+isMXlLC0dom6cMafwSa/tYft0Vds9PwUvPzgKPWPPJ4anKI?=
 =?us-ascii?Q?7EeruD0A+nL3kn9c4JBwSnIpFeBco5yK8P/5u4QDn9h7/JAS+kKRbjHgtiB1?=
 =?us-ascii?Q?Hk036AEVTMDH5oCVOU2KnRch8fh2V9ZHWaVo41Yj/+CLcB5HVNWptcmF4GGg?=
 =?us-ascii?Q?1GZoYBjPRTOSiweiWyjOIlN5CPZLIVfNb5mAov9ScIb4jYj9ActxT1Tc7w6L?=
 =?us-ascii?Q?AutfPqiVIZV3T61D1+HViWEvWnU8quOVCJzcaZLkOH/dFG9oV0fQE9tGnnTM?=
 =?us-ascii?Q?6ZOgslv4HrUH54sN6c4myrz7/5QjrpKLGcqjDvfvMEVPyvgtcLiYfXjySh2x?=
 =?us-ascii?Q?xhZqZCq+3D3zPmDhWkk4GhH/Z6ibs0imsgdsqUeo6quA43tUmHOfmrjpe2FT?=
 =?us-ascii?Q?Kmmrz7Di0ybDJY/RjtE4d3TpriEGOGwHdD+myNw8t4R6ajZbkSKXfCLn6wzZ?=
 =?us-ascii?Q?ppj0d5itnWvK5lmfFpD5BRaYgJbqKvP5/LYHUYaUDzs0uWtHvNPbDXXIJQwm?=
 =?us-ascii?Q?Kn1ObkknwHULHvebxcfEQJc4Hg40ZQxMbVYcXRYayo2YL76m+JzNfxzhjq+U?=
 =?us-ascii?Q?A5CTs1SJFx5AN5eIDh6/DxYBJwLDFg1wpeMoutofkSH3o4LwXTlu5ins/W+n?=
 =?us-ascii?Q?xOjW1QU+7gxRMM72YSk6hOXaj2lughIJRO6YNi2Hs9+JEUc7WYle0LhMyW8c?=
 =?us-ascii?Q?9NKRuHPHNgZl5X5GG38JV6yq3i7bgOArYqilQxAR/N9dEL1Ii+3IHxBH32hx?=
 =?us-ascii?Q?6FlVvOfYhxSDJdJsqFoH7LJEapsuO/0Sc3DE9knbtEO85Us7dIdT44SRbM4U?=
 =?us-ascii?Q?Nt6AGf/2didCe2ntSjHLCoCq3+XxPKokFSjeH3Iy0fhcwfqoAYxOkslX+diK?=
 =?us-ascii?Q?Lm59EYADENuIjk7AcqtNjORq+DXrXDTSE02N5aBNPg0TaCgoitJGx0nUqow5?=
 =?us-ascii?Q?6wAuzIdPgrBpERfQBGafxXUh1EC8CjNgXXW9bLZEmxq5HLJYEP50UAQ4BDrP?=
 =?us-ascii?Q?DIRJzr/rYmMnri/U4o7J590LnBt9hiEqOSsZLwZCsMT8ggbW4f14JzKnGmSn?=
 =?us-ascii?Q?+IbiHkg5Z/S74QXk6FkdRI2fi3BL2OEKL/5rkQEowgIEyM72u9eI+94IJy+X?=
 =?us-ascii?Q?LEYGXEqbYHElecJ988UjMMnVLsPgZdjUPHZcd90gI1a/Za0xZxtWf40w9MNr?=
 =?us-ascii?Q?eGIwxi5e65Wj7E8aL2cXpQJH6BZ/VfuaL3lgXk1n8VA4VjFCrDb1CDw79cOB?=
 =?us-ascii?Q?CJkzbDcyUTRS0eT+gcRv+f24AvIglm0p+qw2YcE9TQgd0PDXVd0XvbPGL4G9?=
 =?us-ascii?Q?QNLd5gNxeKv2OxslWxVJ2FiV/XQ6PnqtSxXSM6hNV3Wp4alSM/spBVzcuqFw?=
 =?us-ascii?Q?+TtCeDI9We7YfKfPUjDxqQCBgQwEyaYQ5t4g+dMgY0FvDVfBT10rVI0fYyAF?=
 =?us-ascii?Q?0R5MXDZ7ozihFj3/crPYUQjMRHDYEB+/yXosKsdY1kCutcwNO1snxLjJ6E8O?=
 =?us-ascii?Q?ryY1r0bvUQMpLut5K4ZbGaY=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 48779b77-cbce-47f1-5f98-08d9f6273434
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Feb 2022 17:17:29.1374
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8oFws90OpMY1ymhMlnh9Pzj+UVtGA1IkYd0RcucJKw0oa3gouMHkiv6F8ZOI6psX5lxXxf85F8D7J1W5wjmDPg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5214
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset contains miscellaneous updates to mlxsw gathered over
time.

Patches #1-#2 fix recent regressions present in net-next.

Patches #3-#11 are small cleanups performed while adding line card
support in mlxsw.

Patch #12 adds the SFF-8024 Identifier Value of OSFP transceiver in
order to be able to dump their EEPROM contents over the ethtool IOCTL
interface.

Danielle Ratson (1):
  mlxsw: core: Add support for OSFP transceiver modules

Ido Schimmel (2):
  mlxsw: spectrum_span: Ignore VLAN entries not used by the bridge in
    mirroring
  mlxsw: Remove resource query check

Jiri Pirko (1):
  mlxsw: spectrum: Remove SP{1,2,3} defines for FW minor and subminor

Vadim Pasternak (8):
  mlxsw: core: Prevent trap group setting if driver does not support
    EMAD
  mlxsw: core_thermal: Avoid creation of virtual hwmon objects by
    thermal module
  mlxsw: core_hwmon: Fix variable names for hwmon attributes
  mlxsw: core_thermal: Rename labels according to naming convention
  mlxsw: core_thermal: Remove obsolete API for query resource
  mlxsw: reg: Add "mgpir_" prefix to MGPIR fields comments
  mlxsw: core: Remove unnecessary asserts
  mlxsw: core: Unify method of trap support validation

 drivers/net/ethernet/mellanox/mlxsw/core.c    | 32 +++-----
 drivers/net/ethernet/mellanox/mlxsw/core.h    |  7 --
 .../net/ethernet/mellanox/mlxsw/core_env.c    | 38 +--------
 .../net/ethernet/mellanox/mlxsw/core_hwmon.c  | 79 +++++++++----------
 .../ethernet/mellanox/mlxsw/core_thermal.c    | 66 ++++++++--------
 drivers/net/ethernet/mellanox/mlxsw/minimal.c |  1 -
 drivers/net/ethernet/mellanox/mlxsw/reg.h     |  9 ++-
 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 45 ++++-------
 .../ethernet/mellanox/mlxsw/spectrum_span.c   |  3 +-
 9 files changed, 106 insertions(+), 174 deletions(-)

-- 
2.33.1

