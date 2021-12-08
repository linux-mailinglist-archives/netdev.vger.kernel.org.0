Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BED5046D579
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 15:17:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234904AbhLHOVP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 09:21:15 -0500
Received: from mail-bn8nam12on2063.outbound.protection.outlook.com ([40.107.237.63]:35936
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234854AbhLHOVP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Dec 2021 09:21:15 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C3X6LOf/6xItAnq1XR/LzZ0XXrDWJ5D3FvbgfnxFdSUJeioBdl6bRHzQDlntc6xBZMAyCT5Nxic6OLGa9J8Bdr0i6j1+U1ChfhKqbqCQBPigsNP4VJuvK2y7GHAb+YxFZ9vYn1HgjYdXNqD02p31rK5WUdTRCKyNsISXItCYATPmvf7tyHTRqUSo5FLLYMBMH57VoSW7g7jmwVvdSrD5gE6cXAvBXhF2Bj3EFDTRsd0J74FwBcGx5AvDAG3OMdIHtw1c9O8yjuINSinki615Cvc5JO2c6h4xaQBXZ4C3vpuXlzz/9Kvd5KN+sEeWu4JADMnli+Sj2FoYa6GRFvqCsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hRp7U5UhtXRzUwe3tj+FzWDZ1mIUAwynP2DOQitpzc0=;
 b=PyaQLgjMU37WDSfozeHNBabzYTWkRHA1VhN55oiWaiJe6Zn3EqU0Yix/st07Sokb5NfLmw79HgrXFFL56her4ZT7y7cY8NuXaLQmBkmD7iSBkzEPWParUnPfxRfcJch7sEnHad9o22D9/PK1EYP1fFD5MfVXr/c4WtdjcykiY6YH1477TVCxSDiO6wMZ23ffE9qxpJuOrbbels7UWSs9QcybkYFAXhsxi9C+BgwX8AXTXEymGRX14JhglUKexeJw312JH1tHtTBTMkpaqz1FZkFeOaeGPVcQu3CzHwDERnNngfd9UCHqZzNle2csjZvAj9yg7fWaUQoMULN6HqrAAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hRp7U5UhtXRzUwe3tj+FzWDZ1mIUAwynP2DOQitpzc0=;
 b=JoNW0Hg3/T+X5KzEmFEXWa1MZarLvFWg/firVoarn5pmYOUx1xBr9KKUnZGykSK4VZ5hCeUNVHQzITxEoLtWyMo3wwdcDAOh8qWhDq0cr0dU+NzEPzfBtilnAUGfYmRxu5eaoXHFtLGGYjc1LAS3+jJF0tVC41K0Qugt8FSBx/WZy5c5tkdvhf2i3k2Ru4YvtcJOnrLKdx1pRQKW4UVn48BWlFr0NYs8Yvu//rX2hSuqtssiMa8swU2MMEZHkyekRJ4oZSuIqpr70iH0h7toFhyzIPqHXv4YOS9/RWwCDHUoSyI9a6ygrKQcvktUkI+saTXmmldEmylkcycfLl7PKA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5373.namprd12.prod.outlook.com (2603:10b6:5:39a::17)
 by DM4PR12MB5117.namprd12.prod.outlook.com (2603:10b6:5:390::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.12; Wed, 8 Dec
 2021 14:17:42 +0000
Received: from DM4PR12MB5373.namprd12.prod.outlook.com
 ([fe80::10d0:8c16:3110:f8ac]) by DM4PR12MB5373.namprd12.prod.outlook.com
 ([fe80::10d0:8c16:3110:f8ac%7]) with mapi id 15.20.4755.022; Wed, 8 Dec 2021
 14:17:42 +0000
From:   Shay Drory <shayd@nvidia.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     jiri@nvidia.com, saeedm@nvidia.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Shay Drory <shayd@nvidia.com>
Subject: [PATCH net-next v3 0/7] net/mlx5: Memory optimizations
Date:   Wed,  8 Dec 2021 16:17:15 +0200
Message-Id: <20211208141722.13646-1-shayd@nvidia.com>
X-Mailer: git-send-email 2.21.3
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM5PR0502CA0011.eurprd05.prod.outlook.com
 (2603:10a6:203:91::21) To DM4PR12MB5373.namprd12.prod.outlook.com
 (2603:10b6:5:39a::17)
MIME-Version: 1.0
Received: from nps-server-23.mtl.labs.mlnx (94.188.199.18) by AM5PR0502CA0011.eurprd05.prod.outlook.com (2603:10a6:203:91::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.17 via Frontend Transport; Wed, 8 Dec 2021 14:17:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d834b778-cd67-4321-ae09-08d9ba557f46
X-MS-TrafficTypeDiagnostic: DM4PR12MB5117:EE_
X-Microsoft-Antispam-PRVS: <DM4PR12MB51178A9DF978B7E850988F56CF6F9@DM4PR12MB5117.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +E/6zNYEtKf+b3ym2hKsr22HONKvSY0zG51Oh0RjznYqtIHdcDHEUYjTgG4TEqWFDDDucc37BdwuVjTemYcQ2gdSo8va1aG/QTwD7RZ8vzKXYjUZG1tKg8KxtOHEgpZkLPuzC9ydSbNGzX0D7jePYfeGFmCYxkxnqvGaWYDBddZeu3bSvGwluZOSt99hD2uURJuZtinzALj/5eGkPBCRAzibq2/QQtoL9MT+FZhSUaWFvWmve1+CDHYtU196gbGn6vSzEbp7dgJA3VyNgP3nBxr7WB7VqLgb/S447l7ErxhsuRJz6KzFT/bOKVDIsENjVPLNlU4oDmIEBv7sqfVJjOMc+z+CNvyWqatRRHHbeqzen37T9wUTmOEhMGWt3YG839aQoOenaE1IMFa00QwnMAmA3xZFnYKdAwQIOIwDp+3uwqa9jWsh8VARb0tYoqB55qG/KcsY/IxvUcP/8d6wziiYoZb9J4344xm4Rx3byU0S/V5NHRO78ymqJvM7Tbel5lQJ6C96GIUVsssfmJHVZtgMMHANdiuZP8eJGGr32dcoASBKgjlyVvqH8Sz9NY3EGraLmjgymuhvVeqNLCqMyVEbzzsvkf/FByruB0SEh0hTIrmPwgUj+9UmGJddLwwSHpsv/fZSkTT0Azfd2/0LgLYWvw5F7Y7Pj7/bEkaOWbWia31KQtHMHZMuyLCuIBUDa+UQLmAnP3J73uLqwP43Hg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5373.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(5660300002)(316002)(83380400001)(52116002)(4326008)(107886003)(86362001)(6486002)(110136005)(6506007)(26005)(66946007)(66476007)(66556008)(6666004)(186003)(36756003)(8676002)(6512007)(8936002)(508600001)(1076003)(2906002)(2616005)(956004)(38100700002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yym2CvTu2QZRBs67gwhTp1zRZQF/Rd+17/CzXLG89xGyrzkguZA5aIpbgBys?=
 =?us-ascii?Q?knnNiaDzxjDvC5scFhoxgow6B9v+bLRE5HuyeihLU6uFKorVZgdEJUmW1tq8?=
 =?us-ascii?Q?TP7y176deeNu5fKl0SyGg/FWCqgvgx+7vB1i28IOH9laYTXGL83J8edxun7k?=
 =?us-ascii?Q?MyBfK3R6kOSprNvCkKLA5WXcMac1UCL6AQ4cEDOAx3IopYfIDOu9B77b2aza?=
 =?us-ascii?Q?zUvaPkWHqMlWEwPc/1uJ8rSlhFkBeTp9ZJvrmSMZ7FoE8lQSJO7ktCc2R5Kg?=
 =?us-ascii?Q?kQUdGjClazzw5RTUuQgmStZ9iAc3x0N/wowC0JzHCtesXKM1h+nFmSecFY15?=
 =?us-ascii?Q?oF4R9AMp6sRJQLSnsqDxG+rPLq8/9UxTLNj+kaTHydfZ326D370FhjnGLZNf?=
 =?us-ascii?Q?kXAieAtefopg1qk8mavkcJV/ADVeO6zHhErBYses/qdCKpqFyHKqlf+FqIuy?=
 =?us-ascii?Q?EO64kxsQUC7JEkTsSkr46WXfuOjly7xsB1wfGCstNU6pPgPozf9dXl5u2qmg?=
 =?us-ascii?Q?SYIyHwpWfIrJif0fXyLvMABjU7CYxnQd5vOz6BxdCLWLVzQwKiZVjdDq6vTr?=
 =?us-ascii?Q?8yNLH4JD2JhfBAHZ5c4DawG6PLjPDxE7EiXRnu9iM5q2gZv99p+g2kIuuE+o?=
 =?us-ascii?Q?bf8ILcHarC4EwfXDPwSnoEhmipXUe6BqcWqaHuUC6qN9hGZ+QuF9chrQpyqK?=
 =?us-ascii?Q?PHh7eMsH4//RpbwUQxrSY+UInP4kYN0UN87KS6IUe5RUaPT3V5WHRYJOgRRA?=
 =?us-ascii?Q?kU87vKpuGiKkkxiqKdNCYdwodERnoxHN5aGzjNpEc+tU1Y3vtUwd+x0xEj1C?=
 =?us-ascii?Q?p4DyKdwvYDkkDasIFvEtL9h64EJxYM4ie0+GIOma7zZXhaKax6VUR2xSf1pR?=
 =?us-ascii?Q?c3CeNKqTKXizorsaOoJzi9D5Cc5WmyP1MkhXHCEX9uUpO/xaCzzk33H+tk86?=
 =?us-ascii?Q?VyvcObBpv6gXlOY1DqR44EV3iZs2+t7rqa17IvhaGYLaa9aONJyKkloDpod3?=
 =?us-ascii?Q?nqq3DcL75BA2+maK0SDoXbID6iF4yy6cp4sWqz9sEoniB3PnGCHgGMU9QfDN?=
 =?us-ascii?Q?xknnA7zezShxbLW0Tb4euRF/60lYKEUGA1pmAA2bIO7UPHjtc+vP6vHYlLdR?=
 =?us-ascii?Q?/nax1W3gF7VmJsD4ttqoEJM6gHuw6GJ6Ow5ZQ6nfP1VpJbz7xFGaOZwSiSpV?=
 =?us-ascii?Q?D9zU6gtq2OcRRHJTfdfi2QBP1uCGY4jTsPVti8mSWfmaBBmF3LagD2yMyBc/?=
 =?us-ascii?Q?MihujAJ98ExI/fNEG4DXVZppfrL1zApHarzuVDvQCorEA4OiC5/okSz3xyER?=
 =?us-ascii?Q?4iGPQXct8UW8G64VWWlMokubaaY69AB5bZNyB6J/7cG17P55B7B9qiff5OJM?=
 =?us-ascii?Q?FGttprWWaFLmYP6P1Y0aaQfdIvWgEya7kcF1mvEQkF0laKPy163Lc1HOWRXS?=
 =?us-ascii?Q?DZx99VQTUgpUnqaTshMAtNB4KUW4j6kJD4oP/txammxkYqL4VC0+klLmSaxJ?=
 =?us-ascii?Q?pcQ7SUoPKtB2USR8OyKzypeljXtYq3mLl1/p8ZlVpsTkdVPvIDhKH2tNeCKd?=
 =?us-ascii?Q?2aZcSfYxJiL/8J8rSCQVDCSWTOYHlTq5r8oE66iAH5bqjjjbZY3hoX2An1VA?=
 =?us-ascii?Q?Q4AKW49mg/Aayz3929vMroM=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d834b778-cd67-4321-ae09-08d9ba557f46
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5373.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2021 14:17:42.1981
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qDkZjbTyMZUfkOlpYM11yN9Zl7/CONLVPduHJXY2+xyRRRrTdMqIWSgoyV5mh5DRxq0/KQTrZlzBwKT+noRdgQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5117
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series provides knobs which will enable users to
minimize memory consumption of mlx5 Functions (PF/VF/SF).
mlx5 exposes two new generic devlink params for EQ size
configuration and uses devlink generic param max_macs.

Patches summary:
 - Patch-1 Introduce log_max_current_uc_list_wr_supported bit 
 - Patches-2-3 Provides I/O EQ size param which enables to save
   up to 128KB.
 - Patches-4-5 Provides event EQ size param which enables to save
   up to 512KB.
 - Patch-6 Clarify max_macs param.
 - Patch-7 Provides max_macs param which enables to save up to 70KB

In total, this series can save up to 700KB per Function.

---
changelog:
v2->v3:
- change type of EQ size param to u32 per Jiri suggestion.
- separate ifc changes to new patch
v1->v2:
- convert io_eq_size and event_eq_size from devlink_resources to
  generic devlink_params

Shay Drory (7):
  net/mlx5: Introduce log_max_current_uc_list_wr_supported bit
  devlink: Add new "io_eq_size" generic device param
  net/mlx5: Let user configure io_eq_size param
  devlink: Add new "event_eq_size" generic device param
  net/mlx5: Let user configure event_eq_size param
  devlink: Clarifies max_macs generic devlink param
  net/mlx5: Let user configure max_macs generic param

 .../networking/devlink/devlink-params.rst     | 12 ++-
 Documentation/networking/devlink/mlx5.rst     | 10 +++
 .../net/ethernet/mellanox/mlx5/core/devlink.c | 88 +++++++++++++++++++
 drivers/net/ethernet/mellanox/mlx5/core/eq.c  | 34 ++++++-
 .../net/ethernet/mellanox/mlx5/core/main.c    | 21 +++++
 include/linux/mlx5/mlx5_ifc.h                 |  2 +-
 include/net/devlink.h                         |  8 ++
 net/core/devlink.c                            | 10 +++
 8 files changed, 180 insertions(+), 5 deletions(-)

-- 
2.21.3

