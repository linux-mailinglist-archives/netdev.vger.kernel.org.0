Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 824CF54888E
	for <lists+netdev@lfdr.de>; Mon, 13 Jun 2022 18:02:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242256AbiFMPph (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 11:45:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243386AbiFMPpU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 11:45:20 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2078.outbound.protection.outlook.com [40.107.243.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3B1816CF50
        for <netdev@vger.kernel.org>; Mon, 13 Jun 2022 06:22:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y7YXCdfOjkZVG+XGq6mgw/huflpUO+GUEzrWQsdmSGODPpQjOdr1fJQ5SEXazf7Y61aYjfyErUYKrjJIiYkHH/ysTe1Q1LleN6o5OYPRG28Usm1PtuVudz+T5VnVkxD2LkOtF6x3K60chuqa9RaduhS2HSs0TlIWxqg15OwA2khIdw9FWN5K04HMRd6Bq8b+Hr6riL3pMcnAuzhtalSTAbhV2Ggm497j2Z+k2e8mhuQsoKQYyC2KntUgZFVrHovE2PFwhLlnTNjs5d47GEf94dLYwtiHJ/xmF9jOnq5iIVWLtEcsRuWp6pL5IHTB9uW62yTagbofOSdTSQfLaUagyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=neQNqRZanJ1OG0gOXd3Kam0wtV+AJxZKSoPM32nFZq4=;
 b=hZovuRDICB2JFiR6UTt71imgcLtnSKjCFWvzkCZUXgwax9y8PCFKj3cfSo7QlrfNykP4i01HfqEUO8vno2zqdPaCF7gE9TMQHcCKt/rEa+fiFP+y2fz/n1vdsWFpcokVMRZ8X99KkEGgSZctQOFRf3Gtq1GASpzR/lRyLO8e9F4ueU+VP9U+8V6TV4ekJhl05dd37Jqk49fACYVMlTPcCU8xCl6/A7bIrbUdMY9GddRRiOw4xzgFi9sOLn+O7g0Y2nN23FzkIknjTiXLdDQdPemvPmvo16vegY6PDS7+PtOwC5MAwZpXTpAjeWubsQ3BYFkUsHUSvqH1TaaWq2hWSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=neQNqRZanJ1OG0gOXd3Kam0wtV+AJxZKSoPM32nFZq4=;
 b=EIMgKGHYeGkqJGJsrps5ybBS1AZEUG/7uWwo0in4vk1bYJ1LIPR7cc1YRGDYIpoTo+EjQUeeSeEa9peFYjdcnd6s5zARVuLq3Z9/h5avAVF7y9QwXUZcqr7j5TG40pM63JbA7V1Xt9Uk+mEUCZBlqZJwJV2WvthyWq6ZGT7/Kli/KgDA/ClS0sjpZ/9CF7TrMMqn1lc6viQ8QtTDqaOh0zvoDVAH8MBiklkgusqsDSH+CT7u4dT6jFXWiv4CbXTPsaVTnKvzukwslpNdDueEYD8iwrL2fTFnRFEEQ/sAbR/P+R0ooghwxrPgd6+7giczd/6iN1a2+h8HRmNZUXTI1Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by BL1PR12MB5361.namprd12.prod.outlook.com (2603:10b6:208:31f::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.13; Mon, 13 Jun
 2022 13:21:57 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::9157:69c9:ea8f:8190]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::9157:69c9:ea8f:8190%7]) with mapi id 15.20.5332.020; Mon, 13 Jun 2022
 13:21:57 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 0/3] mlxsw: Remove XM support
Date:   Mon, 13 Jun 2022 16:21:13 +0300
Message-Id: <20220613132116.2021055-1-idosch@nvidia.com>
X-Mailer: git-send-email 2.36.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MR1P264CA0166.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:501:55::7) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8628f1e1-9905-44d8-24d1-08da4d3fb0f2
X-MS-TrafficTypeDiagnostic: BL1PR12MB5361:EE_
X-Microsoft-Antispam-PRVS: <BL1PR12MB536128FF88DA72B025E22D4AB2AB9@BL1PR12MB5361.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HYFiYyDzdpSY3b+yu8v+GwAG+czTs9i3tM2+WH/iBqbZTOSV935k/f1Opw4I9qSqVa593XLPX6a82U06+sTFs3xwVDcp7CqzwcvM+m20NQ3v+bATxir2OwSqsG2IPDk5Ph4z4lOJ+tPfUgrXvQOntzob/S5bla0vW3G+UaK/tSWO8onVqJ3Z87FSsBcrm96/tHfsdWuVgGrntdCwY2LoPzW2U3Eb0kFQhIevkYXuWEbQIOChirE4hAjFysq7dIMQSChVA9FuCoB7r+9GKXvQAou8AGfJ2iu6w/RcQEy8ORghkVG+z/aYjZwLgnjAsJt8VI1lZuMhV5DRoTFrgWgzQNfpO443ylQDxz0dqhV+N6GBBS1G1e7nVec3d4RtGAaLfuAzQn26HkF/4BOgNOk8zh4DVXIjiUZqgB6r68n86RDj3iTc/9mLDApIZK4AP88tCcoMqOVdTBo4kwpJ7zc/Pu2YvSBeJD7iJHkzNYEw4kbp05H7mQNcCoPjWBhykTLuBt5EKLKrYwaYCzkoOvC8PJyXRiBOoVB8WKCRUeExCLQoy8ewmvOUYTDi8qsgL7nv7hOYiuMfGRHRLhS/+J9BYje6ZCXC2RTkV4pNGyCvAJ3llhw8k7VSAcBfzN13eKM6d/GwRSus4iHwYoHoOc4KuQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(316002)(6916009)(36756003)(66476007)(4326008)(66946007)(38100700002)(2906002)(8676002)(107886003)(86362001)(6666004)(66556008)(66574015)(8936002)(6486002)(6512007)(2616005)(26005)(5660300002)(6506007)(83380400001)(1076003)(508600001)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DuB15BbLVSTBZ2KT4uSVkBWpAuPsHbsyFw7s0QoEmRbt1kluRxuYlQwnU3gC?=
 =?us-ascii?Q?ehUoFxNWLiYuiEpOOaQwn6SFtxJReie+CrXSU66GzdtJb9myJ9+rgj4EvLRx?=
 =?us-ascii?Q?D+o+VmyG8Xx7LLxXhRIR7ubMuNk51kdkNpD6J367zBz5rYqKwC4rdzC8dyk0?=
 =?us-ascii?Q?BeFPjhIVvpYtlX7koDYRiDS3V4Ft5MtcknVUVjSoIdPyCWsPHAKMKHUdPzJL?=
 =?us-ascii?Q?tQTPMbDaLDnNX3ZI6H7nNUhyjvX1arW5QttWRpkVBrCf6Udhs7IWi5chHLgz?=
 =?us-ascii?Q?bGNiodSSvbHHUEBgIfD2bGFMvAs63+tH0A7M3cho6pyDOrnCV1cwWyGNb529?=
 =?us-ascii?Q?Y1AHQ2WW0YcwlSwEegWadFrsiaQZvD94bwtgd6UoaVJhJ7Pv+TBWP8bXN2xV?=
 =?us-ascii?Q?rr6EXM7wN6Ozd29d1/Uh7U0dY5y5YT194Qba1WG9tfnxa8lKSjYkey/hz6sI?=
 =?us-ascii?Q?osvZNZe0Fs9+QUR3YqQYEGGM16XcvLuQKqZLcXTlUB43MBHFbZDB+KnjxeUK?=
 =?us-ascii?Q?ahzLpvKThT/HayHtDaKlbCH/o7tEPA7bI5yTP1iMSq+lxCzGDP1zic4X10Ig?=
 =?us-ascii?Q?sLC/zSN1FttmmCRM89GCxa6LODXozhBFZVeNiCfwPMieDCyX/ZpQwGpzYztY?=
 =?us-ascii?Q?Vfn/htN3ocADq6kfpFCa50GAsbu1SwYqt9OtE55T8XbmGPCDJvZjHuy0hNfw?=
 =?us-ascii?Q?duADWVHy6e6zays5ICDugZB5XlPXiiCTM1UPPHMchusKWBkNdLwt7MrOMxPA?=
 =?us-ascii?Q?PmRxhRWLTY9zhbtRW/pDjyAq349+AKLyYSQ9WKyCdZ1g/TeW/HE+mP+ss6PF?=
 =?us-ascii?Q?6fPleslgV26Ug9ddMN7tg4J2GbHjcyfXIetTmAMUjj4yrKHkGiezC8Acvjvk?=
 =?us-ascii?Q?eMq48aSjz17tgkSee/TdQ1J4U4uT75JTTJOuaB7HDkg58Wu3rj28ahPtVciI?=
 =?us-ascii?Q?vbg54WTUzCrqvJJvzIFmArQD2JKrt0dZm2aUNWalNFMUFutoASkgkcpLsaq6?=
 =?us-ascii?Q?BZDxvC/mrJiiFzyFNbvPHsZkMFQsSW9teHTqAlCEuR1xcn5pIrn6VyAdjJMq?=
 =?us-ascii?Q?oAO5PBBr09n8Mua/znUKVmaSt7ud9yzoJiqtJgAXXwn4NlrHjt+UEn8dkaqj?=
 =?us-ascii?Q?kBo0TgQ7PSGjRmrgcEygIiQZNA4G77Tl8TWTFxDD1iyk4Pu9ToKWe89w6iY6?=
 =?us-ascii?Q?4+nX+MqhnLJqmsuIELBFvntZzQhbtOyIrffxf0qr97p1O3c7ksAvyCS/qnTt?=
 =?us-ascii?Q?6U1FqM9HGQYZO/7RmKyzJ3aDuy8Ja0Kgtwj1x9HBNTZ/4EfzWLT7o2ZkmVxW?=
 =?us-ascii?Q?wi41Dh27jJP9sYy3XWm+YeKG/iOjWKB7efYk/K9T05LVr++pbIuOR1QmJZW6?=
 =?us-ascii?Q?dQu9ctJfqzXEJAb/OTelbsZxoBJU9NYSJ/UT88d6DFDSJ2+Fp62dxaYo6hdv?=
 =?us-ascii?Q?pLNGy96c7m2Jha/SYAD/YWeVirv1L9O9yGJPhGREKxke4+0VaddJQjedRuMi?=
 =?us-ascii?Q?d5w55coKuTpXD36aivYk5GnzTvUPfkWvPxlaPR/CJoxhYM6+ivxNCNOEr1M5?=
 =?us-ascii?Q?m30F9gdR7DdrZ2y/iG7H0BwXWHX4zD8bF9/uJvvVhTM525UaKSLj0MI68G0o?=
 =?us-ascii?Q?4Orp0ky7zk6+UHLfozvrePqrs/gz6o0aMSelX0aBWkq8Bacy3oHNS5yDZ36e?=
 =?us-ascii?Q?W3F0RZre1opgOXNDr4yug6yAf0eRjVmbXZX8kNdrQsC1P0pHfByi8I5cfDoA?=
 =?us-ascii?Q?NjfC5bHQrg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8628f1e1-9905-44d8-24d1-08da4d3fb0f2
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2022 13:21:57.4689
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uB+XOqLGu+wkvyCqgMihYSG2EloQRUVLWAxjEf8vwtKQGQoUdcQaXVePzTKkjMDF1oC+gZElJAZFu0hb2zHVgQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5361
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The XM was supposed to be an external device connected to the
Spectrum-{2,3} ASICs using dedicated Ethernet ports. Its purpose was to
increase the number of routes that can be offloaded to hardware. This was
achieved by having the ASIC act as a cache that refers cache misses to the
XM where the FIB is stored and LPM lookup is performed.

Testing was done over an emulator and dedicated setups in the lab, but
the product was discontinued before shipping to customers.

Therefore, in order to remove dead code and reduce complexity of the
code base, revert the three patchsets that added XM support.

Petr Machata (3):
  mlxsw: Revert "Introduce initial XM router support"
  mlxsw: Revert "Prepare for XM implementation - prefix insertion and
    removal"
  mlxsw: Revert "Prepare for XM implementation - LPM trees"

 drivers/net/ethernet/mellanox/mlxsw/Makefile  |   1 -
 drivers/net/ethernet/mellanox/mlxsw/cmd.h     |  30 -
 drivers/net/ethernet/mellanox/mlxsw/core.c    |  12 -
 drivers/net/ethernet/mellanox/mlxsw/core.h    |  12 +-
 drivers/net/ethernet/mellanox/mlxsw/minimal.c |   3 +-
 drivers/net/ethernet/mellanox/mlxsw/pci.c     |  33 +-
 drivers/net/ethernet/mellanox/mlxsw/reg.h     | 670 +-------------
 .../net/ethernet/mellanox/mlxsw/spectrum.c    |   5 -
 .../ethernet/mellanox/mlxsw/spectrum_router.c | 857 +++++-------------
 .../ethernet/mellanox/mlxsw/spectrum_router.h |  75 --
 .../mellanox/mlxsw/spectrum_router_xm.c       | 812 -----------------
 11 files changed, 244 insertions(+), 2266 deletions(-)
 delete mode 100644 drivers/net/ethernet/mellanox/mlxsw/spectrum_router_xm.c

-- 
2.36.1

