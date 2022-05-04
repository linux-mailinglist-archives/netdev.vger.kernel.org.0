Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC3E85197C2
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 09:03:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345182AbiEDHGw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 03:06:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345172AbiEDHGv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 03:06:51 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2042.outbound.protection.outlook.com [40.107.244.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E921D22289
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 00:03:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a4xn/nnzx7N62l3mJrAYJFuzwM6e+WvEFHOEWDE9Oi4SnZ5Gub5/waZrZOmbVvX48MzsMsjy/MmpO7hsbQN5HPdK5PAZCsjpVSVR3M24uryUvbzLrrvWfSFU28QW6c+mrT4D9JuAgSvAFNUxpNS/hoKaMGSvrPZRVPIsIuhblYnQWhFVmU4FyIYLyqxcXmqvn2Ju88eWLdMBPmD7PaFVBLMOOJ/T1Pzkfw8lmBSM8fwK6MTEtzF71QrIukPh+hfrR5cbpfMs7XmOg32YwvGATiioIZDH8Jep0ewumNFi95TJWwSXj3Bw3B+QOYnI7LQIKx/RdefmF7rrZ2tIYdQOfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7BlwR3kYAYk9NptSU4m7pVMUetmChk9XqYe+RfS/A9o=;
 b=obIRtKt7IjBoD0gjf5f3AmGEDZ86O8wHtvynx/XeV1frWHqp7qed5JaiI/D4xjEV17q7vAxf0JrB1RftQ9iBXlebMgvvZK2xgxvSoYMoIUZOwtpff9Ux8jorUfwQ7VZDBFQK+S7M9FZqGhAEX90axVh5Xz4JaTgO1iWBfs+9oKGsxm/Cb4f8IVEoQS+BqJyivOVJjHJCDV69xf8tu4eXoRJzb2Qidb1B84pqZo+uP5hrnvFXywbltXodhACWJkjXhxFEMpx4cUDYFHmuHX/+zwXUks9lD5fOpbeFay+NcVCUpibvReHmjsJfmosnmfRxyPuPwdqSVDNsbwvPvGcXWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7BlwR3kYAYk9NptSU4m7pVMUetmChk9XqYe+RfS/A9o=;
 b=NwUhlM7XwRD+TW4lpoKRsPw6dIBejKCFdn/xBGhX1MX4qujbLs6+2aSfWCYGzFJ0frI1mF5PYF5IeKDXHxdF9kd9lFtr6I8ABzsbXESNd1U39TrFLIJ2p+wYmNdnBLZ6imKrLUDwaydHZRI8n/fQEM7vagR8bgW/pg+OUEjNT++fqCCl3Zr0p6Wb1a/KO+SlZB4Ks9+1PPq1xqw/+1w0/YlUpY0ydqz4JRdzp+7TAA1IsF/niY5A6O5o2ax04tGW5byXKZWTUKYHH0Cm3eKwMty/xs74F4rR74ABBv5FttSDmV9i1Xlp4tXDdEgriLtyYv3WULezvkodT9pUGpFcYw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by PH7PR12MB6586.namprd12.prod.outlook.com (2603:10b6:510:212::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.28; Wed, 4 May
 2022 07:03:11 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca%4]) with mapi id 15.20.5206.025; Wed, 4 May 2022
 07:03:11 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>
Subject: [pull request][net 00/15] mlx5 fixes 2022-05-03
Date:   Wed,  4 May 2022 00:02:41 -0700
Message-Id: <20220504070256.694458-1-saeedm@nvidia.com>
X-Mailer: git-send-email 2.35.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR17CA0015.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::28) To BY5PR12MB4209.namprd12.prod.outlook.com
 (2603:10b6:a03:20d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a395358f-9906-4206-9a76-08da2d9c2699
X-MS-TrafficTypeDiagnostic: PH7PR12MB6586:EE_
X-Microsoft-Antispam-PRVS: <PH7PR12MB65866CA6F1D57BF848CAD6C7B3C39@PH7PR12MB6586.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CC32X0KUx1LrgcQF+lTUU6IeXUoARKwGuiFMzge8Vg26gMynWsqND+iK/EuNUFBYT8GV4kVFQBE+tRT7gD7idII7DlskQVwhOzuNOtjybeK6uDq0RuWzWpvdGywpXCVjhclEEdawssfShPC3M2lleQMa4DLK6jAa2rMViZXIm7kx3vb0wM/p2kF0hHRHHyUfz9uflsirEhJUKE2BTZJjDvqW4j4k2KQC4eM+TKu0q/mjG7xEw75AXJhJ0lVJZ3huk9edrenpfqq7mnruu/BVsRTeD5PdY5T+cBfLBXnsGAEuL2Z595n6cAcwYMu9OrpgSD7iCIvVgPnHZfeW9ugX751Oci4PmCEl0wGTOvAsLq87nItOLPNTuVGeV0rvfWU6mjzOKFm6+h42c66hGg/tdEsdzSKI0wsJuXucR/dIb/7PYUDYJjwz8e5ejHNY+0ZpaO9x9PSYmu9HRcQbYdpHholJ0kZADv3thtnXqvcELKpZZpdwtbouhLwTHCT8kT5/D7k0iPco21NGDiG3tj1zAyRtv2ilsyYgUcVhOov6kJScuGEiv5RAjGCmrXcrCRglROTzWOUwOo/1UABdcb6fb51XMnhckpHk1r2PKokq+jQsDU0igQ2NEflCH/Z6aCq5AvdBCxNXGJh72YiU43AZZg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(316002)(86362001)(83380400001)(36756003)(1076003)(107886003)(186003)(66556008)(66946007)(4326008)(66476007)(8676002)(2616005)(2906002)(8936002)(6512007)(6486002)(38100700002)(5660300002)(110136005)(6506007)(508600001)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?I6gh3BLJ7stcZ0XUOXnp+GM2YHl8lnrT8poIpZC+jOq2EiPN+wwaaOdRiTxb?=
 =?us-ascii?Q?zGn2BBx57qnwqCoEsTuD1dPEEAwT6ryCmoCeV/6XPNOJv62iEWSyUu+gr98f?=
 =?us-ascii?Q?X/mlGSymvolHGshsH4YgSK7++kt3UxWeiieRSIGE7epaWWoYP6qZXEtqpyhH?=
 =?us-ascii?Q?qkdK/gI3BmIaaFvoK7DFwKpJliUBglHJ+guyCHTkl4iSl0BhrtzRGYpp5s+T?=
 =?us-ascii?Q?vCrGCkODtSdG+yqPOd5BzF40BgcieUZrYMSRRyZ+JBoCXbSP9dB9MP6DMPgk?=
 =?us-ascii?Q?JGPRkwPYsjPxVmayor6P0YcwCw+WqwVKimvv8wmWDWTAEHCCnlor6Zx8Koau?=
 =?us-ascii?Q?TrvCbw1W54t94q/q+ETKXMp3wWg9X2BNJ4tFlj+OhlxBIKqk15QFlKE5f59X?=
 =?us-ascii?Q?p3gpdjKGyX1HZO1PU/QJ9r8a1y4s4ja1WhShvY0nEx0RBJ+pj1rXbCGBhKJo?=
 =?us-ascii?Q?h5dXjKHcb7Wcnq0WzHBRNMjMJHxgJ644VjR/f05znoDzRusPT5r7BGUVaN8D?=
 =?us-ascii?Q?IBiXyAmLCP9EALfwC50ANPCjwfmF4LFSx8l6NYhi48l3wSFGWtkFMSXU8oHv?=
 =?us-ascii?Q?jtbA0ztVIGFj0dGlSD66/PaQJk5vaJFe5861Ep6gieBxTbyhctBlxcDBUEYq?=
 =?us-ascii?Q?pMciNBI0Z49cwBrsQQ+7bSd7bKMoUjD/1/WgzcCJ9prO8Jsc0EBx3Z8BhMqi?=
 =?us-ascii?Q?D0C1CcBLL9hrdrSChMef0TPxeSh1QDNTs82N4EnWuKv+SQ0M0zZa9BkqbA+J?=
 =?us-ascii?Q?IdMLnSQNcLFtBzdB9UHnwcJLUE+RCkuHL/ZrdvAMrxFqR+hMvhGkHvYsdlAF?=
 =?us-ascii?Q?3SfGS+EyRcTypB+qWzvx0LqMH17R1k7sgzPOdUY692Q79bFc/eu2+QOChJGM?=
 =?us-ascii?Q?TbPlPyI6nUJWsdlozqolB3Jy0Cn2wbFpHkLYqMPAiK9LJk8lo4akrx42cSxq?=
 =?us-ascii?Q?UpocCvzCgyOcla5jyPCCvUuIUSPmS5lur37l5n8oN7N7v8DjlyfNDri3nLBJ?=
 =?us-ascii?Q?Ol2Fsz88xJqOUTFXMk8YzWlQYJiipZ1JKgfBKyD4Xq+n2XhHVK5xk5jtVTun?=
 =?us-ascii?Q?v09thWwky+CMW8rmUg+s+7KflRrh6yTJIztOBNNcEaWQZRKhkvDM9JbcEA4a?=
 =?us-ascii?Q?Oc6K1j/6R5Q9g0JzYxpgSFMPTr/mH1Ad0RwckJssT8Ro6KaN6MKHn3Hm0b1b?=
 =?us-ascii?Q?v03x214Ja7Xv1n63dF+mVgch42aJf5pAsuKXEcB5jN3Bw5mj9V1mlF3MqU8A?=
 =?us-ascii?Q?xydAOCTQaLAorvWv3vmx3rKi7QsyoOxNj7e4T2kx+SWqZZcslr2fLeAgyI7J?=
 =?us-ascii?Q?eduIU4tvws+ZjFtyVz9nZc0bTpXhx5RX91+6+Fn6ByrXFgm1jzTIVq0T5eLn?=
 =?us-ascii?Q?Tq19HiPLlSwPoBLRzrEeI+bzNuhIRIA7yIX63Mfb2lM/Q+vvk0MH7Trhdtsu?=
 =?us-ascii?Q?jNxF3lcxoJXxYrTT68rSyIfn1gtDyAC8k1adVDb2ct2kcMx1t8Y3fYIC6L8K?=
 =?us-ascii?Q?1CQ7DiFtDt8G8Oyt2YJlE9Ov//QuY7W6hauSA+KOLZi1FbVk69Xw3yFPatHx?=
 =?us-ascii?Q?UB4vXt0cQXOUBgvcaBoNlrsuSltKayU70Bq2v5PbQr014IyYGQc5e893qZuQ?=
 =?us-ascii?Q?X2URpfTV6l0e6QkPFlQRqEuPSm+q5ArU78UTnGNVgyZt/hIfuYAHuKhlCIpt?=
 =?us-ascii?Q?bcnzeQ64UlJrFKJAcGBkCTG9MFxoDWV0Wvc88vmuz5XnuGpMGqq+DaCZ7RpK?=
 =?us-ascii?Q?IXt1e90e0rI+TQjbuOjvrogPWnICSbIkF1qWYH3LM8xNEP0KzYK6?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a395358f-9906-4206-9a76-08da2d9c2699
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2022 07:03:11.3188
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QO81S7PYhj9kmigmcx9aYiBLfDr2n6yRi8kishuz/t+Vlr5VYyhYi1BPdLrNQwDGxPr5wGjTJ7kxTfBLxNgBlQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6586
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series provides bug fixes to mlx5 driver.
Please pull and let me know if there is any problem.

Thanks,
Saeed.


The following changes since commit 0a806ecc4023fcf393fcc1093f4a532813ca4124:

  Merge branch 'bnxt_en-bug-fixes' (2022-05-03 17:41:35 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-fixes-2022-05-03

for you to fetch changes up to a042d7f5bb68c47f6e0e546ca367d14e1e4b25ba:

  net/mlx5: Fix matching on inner TTC (2022-05-04 00:00:07 -0700)

----------------------------------------------------------------
mlx5-fixes-2022-05-03

----------------------------------------------------------------
Ariel Levkovich (4):
      net/mlx5e: Fix wrong source vport matching on tunnel rule
      net/mlx5e: TC, Fix ct_clear overwriting ct action metadata
      net/mlx5e: TC, fix decap fallback to uplink when int port not supported
      net/mlx5e: Avoid checking offload capability in post_parse action

Aya Levin (1):
      net/mlx5: Fix slab-out-of-bounds while reading resource dump menu

Mark Bloch (1):
      net/mlx5: Fix matching on inner TTC

Mark Zhang (1):
      net/mlx5e: Fix the calling of update_buffer_lossy() API

Moshe Shemesh (2):
      net/mlx5: Fix deadlock in sync reset flow
      net/mlx5: Avoid double clear or set of sync reset requested

Moshe Tal (1):
      net/mlx5e: Fix trust state reset in reload

Paul Blakey (1):
      net/mlx5e: CT: Fix queued up restore put() executing after relevant ft release

Vlad Buslov (4):
      net/mlx5e: Don't match double-vlan packets if cvlan is not set
      net/mlx5e: Lag, Fix use-after-free in fib event handler
      net/mlx5e: Lag, Fix fib_info pointer assignment
      net/mlx5e: Lag, Don't skip fib events on current dst

 .../ethernet/mellanox/mlx5/core/diag/rsc_dump.c    | 31 ++++++++---
 .../ethernet/mellanox/mlx5/core/en/port_buffer.c   |  4 +-
 .../ethernet/mellanox/mlx5/core/en/tc/act/act.c    |  3 +-
 .../net/ethernet/mellanox/mlx5/core/en/tc/act/ct.c | 34 +++++++++++-
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c | 24 ++++-----
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h | 11 ++++
 .../net/ethernet/mellanox/mlx5/core/en/tc_tun.c    |  3 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c | 10 ++++
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    | 11 ++++
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c | 60 +++++++++++++---------
 drivers/net/ethernet/mellanox/mlx5/core/lag/mp.c   | 38 +++++++++-----
 drivers/net/ethernet/mellanox/mlx5/core/lag/mp.h   |  7 ++-
 .../net/ethernet/mellanox/mlx5/core/lag/port_sel.c |  2 +-
 .../net/ethernet/mellanox/mlx5/core/lib/fs_ttc.c   |  2 +
 15 files changed, 173 insertions(+), 69 deletions(-)
