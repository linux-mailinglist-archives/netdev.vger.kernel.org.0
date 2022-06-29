Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3522355FC4C
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 11:43:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231546AbiF2Jkb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 05:40:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231485AbiF2Jka (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 05:40:30 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2059.outbound.protection.outlook.com [40.107.92.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E890535A92
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 02:40:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TUPS5SgHkoOKe8SieUJEOll0vLbCC4xKgLNb+7G8CdhnYKTgJdStSa8c/SHab+M7V7nP80Dml8oJ8Glc9OzN8BBHYryskPJu51Bu/82sXNpU8X2XZEhaEW8gDipCTYnJgvGzbN1xKOJb0p/yHnSkMWIIyKvTW1atkwi4FFcUjopYLLixc0tZy9QiiFgHCjx5s1l72mCBEsVErA2IKwG4nhklcJWgsX6lnOIPgNFphJOcsID+1GKcaoM9IeKsfyFCNBrmf9Ft8RaCNvNmbs2IE+14HAK6SRDBMU71+Bt4cixazZKmRhxbApO7QaYbYLqo5zHvbNTTE5XFJNasxxmpjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GnGrw5nezzKcPT/+N3vUF5l9ZUUOd57BxQb8Z9FYpto=;
 b=MSGyC7jPtpGO27xvZmxQaqzhe+RB/tIvCoY+7iOlCee2x49hF7+DB92QAfXNFHgg+a1nDumnofHt/oCZHQrH446LWFa6mLOpYtjoSnnu/1AexNrsQa+0jnE4Qp+S/lo6knxjTMSYU9jC4PYeX4nrdkwN6iRZQ+Qo+ABxoLJ0AkAiwT2jVuESi74ewy9E0a0jT83yc/NPRhdEBfMj3nGH2w6TWtubT9/HBTqHPueGhCHHod6w6QnDDbaIVVnLbtC6zQ+1E2ups92emtYZqcx3N51V3z9JRQhvXUQWM7zZgKd2tfpFca78DFYQDcC611XB3+TGS2Bx0V+ycKGNzVEYsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GnGrw5nezzKcPT/+N3vUF5l9ZUUOd57BxQb8Z9FYpto=;
 b=QqxePkYgPUtSn31P1LkOp89eCLuM5CSm/J6YPU+yG71MXI2flqxruEe55oR1NLH7SCXhb/9PJQNSnkJELAeA5kFsLsVCKpUvTon2ZyeZQ13UHMU8iL5BffKsjDeB6dUrrdAxIYwvxONcYX6onyuCJWJhkKgcsjtGKSCo8p+2Fpu3GApHoWuk2m/k7JNUMErDZCY0vBFvYp+gb/z1e8bnxwcRuu/V0Y7/Bm+AYXHEE4R8AtEUcR9Lw5upCdsvg/4uSXOg4MLn4UYiSoS3ecWtyAuPpIfpxYwx1q1cN8rlHUU3EGias3f4fvirRa8MmIrDgC/J0l/o/1j1tAnMaown3w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by BL0PR12MB4689.namprd12.prod.outlook.com (2603:10b6:208:8f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.15; Wed, 29 Jun
 2022 09:40:27 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::611c:e609:d343:aa34]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::611c:e609:d343:aa34%5]) with mapi id 15.20.5395.014; Wed, 29 Jun 2022
 09:40:27 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, amcohen@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 00/10] mlxsw: Unified bridge conversion - part 5/6
Date:   Wed, 29 Jun 2022 12:39:57 +0300
Message-Id: <20220629094007.827621-1-idosch@nvidia.com>
X-Mailer: git-send-email 2.36.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0902CA0058.eurprd09.prod.outlook.com
 (2603:10a6:802:1::47) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 35d733ce-2660-4460-edc7-08da59b365cc
X-MS-TrafficTypeDiagnostic: BL0PR12MB4689:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wkxFLvtLhrjPepDCba8ofdANwb/ulgkR07Bd7FHwAVVoP7vlmlXEQNCdNgxB0E7rjTBV20Y3Mwi1q7hxLCypReKq68c1raIGkOL0n1hdT2bFk5d3SYpKyFnvrUJ4bO97G7CApWCD/0lJDk2yxHrN0VfurBnpHnsqrksBW9DokiG7I6G4+bq3HfSP0tW36BAxXbC3k9Hc2CS7aPSjjkXXQQ+0DtyYCNFKSgQdabzJPqDGmds2nleJ24w9HbEVI4WFXyo58YtP7GGRRJQ2qyuXCJFfGIOCCFbxipw/aZuzWsA44HLpF3RMRFs7tbs/BSk0136MwRzyX3QqTvhFfpQH9xm/gWgq5zILOSGTs5UtGXGtyfjc0MFZItv7ZDzYOaJtk5arzyMS9uwsVKozjx8lkwi88awbQCKQLKR7TDFUt0CTBlOf3tSeW099gQjB4fF0HLIdQIP9JSI4msVTVTLr8G4w0JCV6HnOa1rEO8wZzc3B3ICtaRdtjIHxfosSkU6uZLzQ/ilY0jjI98PcJ6fYliPjyHTTp/tzU7jxummXN8fl6jZymGMr2Ai/ihgLtenyqLETiDIPVNoLHaaAYYBr1TDV0a0iSG6NkzOM9dMD9Bgz+tLGqc3Y4Be/hpS/UXtdqgiiLsRj6Kee24pR4pc9L7x5SvYzT7uVz8lWMRbJ6J1DF5Fv+XQCOUiQocUZpVlCYyG4wfcA+9wylO27O4lD7KigDXEcluV7oaqvrnhvLSU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(39860400002)(366004)(346002)(136003)(396003)(6916009)(186003)(83380400001)(5660300002)(6506007)(6666004)(316002)(2906002)(1076003)(86362001)(8936002)(41300700001)(107886003)(2616005)(66946007)(8676002)(66476007)(4326008)(6512007)(66556008)(26005)(6486002)(36756003)(38100700002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SokQk+PL3BpAueKbj4e1VRbBVJyL/i9Yk1cdPCfaSVFy8/uNmeuY4Y9rZTu4?=
 =?us-ascii?Q?D+6ekEOaDg2MJSg0dvohminevRi+dRAulVuidEgeFmCboJsFbX4XCAm9R4ih?=
 =?us-ascii?Q?/sIN+BTdg9BSy7lNrum6DT19pxI5TdkeW2Hfk9TROo9l93vWKlVtRUz/MDs4?=
 =?us-ascii?Q?6fDCAwDixY16LRYbfscxElSuMV+f396YQqjB02NWDuUZd4g6CtPGXNOh6K7+?=
 =?us-ascii?Q?lYV3lagtDUE/aTQebrQDPufotFzLJzivcuRREURsY13LENm8luqGMbrGv251?=
 =?us-ascii?Q?ZEzkpAjCiVRe1RNz4q9Fbt7dIWs9USZPUWSIok53QfO/W4eGtHrFmZaRf+gq?=
 =?us-ascii?Q?ujA/9KuVA+uPTHqrOj7xhXrCgDguG+z4+ASgZWecn2DAM5D4XDnwB8f7mYbc?=
 =?us-ascii?Q?3cozDIDPxdIHSjqZKRvTTVD9Cj/lPnImpYOTlH6RI5p3Rg/aWaBgS/WYQy2m?=
 =?us-ascii?Q?ZGIiMAhWz5u0Lb0I9NpdjteJysdy2O4X8t9g/P229SSntvBGTHnDtbR7HfJz?=
 =?us-ascii?Q?+d7MihLegcFQ9AR+muDBvePpWDnhFqjmN+WqEIy4AJY/ZC4TUNjQgOOjdD7t?=
 =?us-ascii?Q?7ehr9U9+xzEX/JQOIOg65RYRqbaqnbHxYJbfpbtWSDKSDaLKO5z1Dd7LUu0F?=
 =?us-ascii?Q?Ht+2OYZ7hPnWXUB0DHwOzT9z8S6/7xZQX2IoH7vRqasJq9B0ESnGHOIb0KzW?=
 =?us-ascii?Q?SIoYORgdHPT6y1klaIOaMWVhmGJfv2NEvLnNteENhHFLYwxA758zsK+GkCQ0?=
 =?us-ascii?Q?jF59Z4qehiuhaQsYF1D7myS1cPr89NuiJ1PF2tUuLfJt0XG+gYc6hPsj7Ssz?=
 =?us-ascii?Q?/TvLfhyZaMsekzyZM3Ezw3mjZfEMXf2cIslZEgm29SC0Ufl/NBHG4NtP4LD/?=
 =?us-ascii?Q?RRvfTBUiHe8xW9j1TgO8uF4l7TF+5TuX6yrRXZdSBjd3KBNlKdCQDpREJzv0?=
 =?us-ascii?Q?SItfHI6dlvM9wySk8OMXLNdGqHtjuUTPOGDjbh4BwA4eSUHp3H8Y9ZJTdrYK?=
 =?us-ascii?Q?xb86XO6s/LxVzL6cvNDDlW+0B6DX9GcvsPh0zzUZcmBTGQMC+gHh51tN6tZ7?=
 =?us-ascii?Q?6HMoh2pet7J6Iw2jxdy25XVLLWGhYBeRDXZnIr8NXL/E1cHfdrraYQruDYOW?=
 =?us-ascii?Q?ojMdwWQqjY9/9S4jkTBLFGW7SDOy8abkkIM2Jbqpl69S8RIUZrgmzOVxMT8C?=
 =?us-ascii?Q?/g3PgaJ8mvneULaFbiPvVcXEGYItXSNfj+PF7NlwtY2MPbi1C6o6b3nPwu8d?=
 =?us-ascii?Q?gasyT91/hDu84izSemVOn+Mvi0mvq2Jo910FF6eeysicBbeweRAipXO1gMn8?=
 =?us-ascii?Q?70Bp9+IEiwpLjzHMVQ8uvrURc6tKLwplhZ5E/FmG9NHHBloHoZ5JoXlcR+a+?=
 =?us-ascii?Q?7Pb+GgkDkTOfxuRJym/qLLvL+hp9Slz3DUmI+lgz+tcTLIazG0kmhhOMvefA?=
 =?us-ascii?Q?aFFWCekDqbQ4ZCjOuR9Q0U4Ef/K17kXcZwwV3n1umkNW9834L4Aec/dqlV4g?=
 =?us-ascii?Q?ePXs4eKQy0W/a9Vsg1ugYsS0TXY7+SxCazjJwoTmks9G4owWVaXMuns2okGW?=
 =?us-ascii?Q?8xgVYuhEwbOCppMiAJfEeGExB3paK3muNVPyyX4m?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 35d733ce-2660-4460-edc7-08da59b365cc
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jun 2022 09:40:27.0636
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mdPDHUXQYXEcznSqVTVDKWWclnHedAxG7fZ+LEyyqAitzZXZ0o3y2OUVVY9j6Kvf4gNKVIbath1cd1egDkZ3MA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB4689
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is the fifth part of the conversion of mlxsw to the unified bridge
model.

The previous part that was merged in commit d521bc0a0f7c ("Merge branch
'mlxsw-unified-bridge-conversion-part-4-6'") converted the flooding code
to use the new APIs of the unified bridge model. As part of this
conversion, the flooding code started accessing the port group table
(PGT) directly in order to allocate MID indexes and configure the ports
via which a packet needs to be replicated.

MDB entries in the device also make use of the PGT table, but the
related code has its own PGT allocator and does not make use of the
common core that was added in the previous patchset. This patchset
converts the MDB code to use the common PGT code.

The first nine patches prepare the MDB code for the conversion that is
performed by the last patch.

Amit Cohen (10):
  mlxsw: Align PGT index to legacy bridge model
  mlxsw: spectrum_switchdev: Rename MID structure
  mlxsw: spectrum_switchdev: Rename MIDs list
  mlxsw: spectrum_switchdev: Save MAC and FID as a key in 'struct
    mlxsw_sp_mdb_entry'
  mlxsw: spectrum_switchdev: Add support for maintaining hash table of
    MDB entries
  mlxsw: spectrum_switchdev: Add support for maintaining list of ports
    per MDB entry
  mlxsw: spectrum_switchdev: Implement mlxsw_sp_mc_mdb_entry_{init,
    fini}()
  mlxsw: spectrum_switchdev: Add support for getting and putting MDB
    entry
  mlxsw: spectrum_switchdev: Flush port from MDB entries according to
    FID index
  mlxsw: spectrum_switchdev: Convert MDB code to use PGT APIs

 .../net/ethernet/mellanox/mlxsw/spectrum.h    |  10 +-
 .../ethernet/mellanox/mlxsw/spectrum_pgt.c    |  16 +-
 .../mellanox/mlxsw/spectrum_switchdev.c       | 697 +++++++++++-------
 3 files changed, 455 insertions(+), 268 deletions(-)

-- 
2.36.1

