Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02B37584641
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 21:33:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231925AbiG1TMV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 15:12:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229619AbiG1TMT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 15:12:19 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2083.outbound.protection.outlook.com [40.107.237.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D20213ED75;
        Thu, 28 Jul 2022 12:12:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oQdW6HfNlgnOwuKZvHkTQL18DASDeM3eBcemMNUiNFSi5bDfVNETkitZyLktzJ/OCfthltFm/CrWRqs63Dn87EGu/dXVGOufljR8d/VJY4TlmDiw94Hpgk5YBfyNbC8jbj8cLcQkIL0awzeVlDZnQiIk3n4cmqhLGUHTpgHMNaY0357xguTvakp7QX8fj3exJbEEBSmV0Gi24lMhS08EVRn5+wYonfWxNAbHDUVRkjyYR6k/uJ8xwng5VMkYYieP+kL9wIqZoselhiCZzdfOUqjgI43yr2a3G3XuQm/n8b/1ipelaDnEUggEpCFSfVmTjNkpdTBLY6QBHffm0ME7GQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P+5xxT5L4J58k7i5PH3vFXHzuep3ASUR5JAs2+Ui9/Y=;
 b=U662atqvnbOMghTv4M6KnmR3VfZ/I9e9TUQgCWKgDqY2MXBhXntEgMg6zRBZQqD03eG8/QmAE/O+N5F2gQoTWuCwyWf8wrbrRZIkx3zaaSG6lQIQr2p2km7MYaUi3FpBB3NZQss6zDlPLp4QKsdvlhfSP4HDW+rZcEcNO0yGQWQ102AyiiVeq/O7Isx3YsbU3sKsRm2aJehgSh5kvem7z8+k+iaI19Tu8GVsyoZyk5WlC+agqkavAujYhC1N/1+fZ3Y2hgqwZUJxR/iKd6tL9LpRQeMPKYI54428wHzeZnBRlf9VgVCNFMJ6TOzEf0ZJaNRQn9QSk2avApewVREjzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P+5xxT5L4J58k7i5PH3vFXHzuep3ASUR5JAs2+Ui9/Y=;
 b=fiC84kGMcmOw7+2ZLQSyOd84l5Bbx6UzK6Enetcr6xP9hNNGj18/vAgN/KbH8aBgtseQZXFVjh+dCziD1eoPX7fHy1mxvMQphQAbkdij2cw3Z6DWnEq5k0h76tqFFp+bAB3h+lsPxLGp1fEbya2a/K5EWhpMkdvZFkAOyMMN/c7+qFVJAExqsNqEnV0dHbNU1BfR9JDYdI4h4hOxkTJlNqKhPyuwhOduzDLBSC1++Wpgrt07Wr5Hd05ofEz/z7dROu5+JjsAkJeeeXJbqrrLDhh+uMNPPCYtu32jGzn49GA0rSnjQ76dqkNJ9n+KDC7N7NwIHxmm9N/I01gVABJL7w==
Received: from BN9PR03CA0166.namprd03.prod.outlook.com (2603:10b6:408:f4::21)
 by SN1PR12MB2382.namprd12.prod.outlook.com (2603:10b6:802:2e::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Thu, 28 Jul
 2022 19:12:16 +0000
Received: from BN8NAM11FT010.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f4:cafe::64) by BN9PR03CA0166.outlook.office365.com
 (2603:10b6:408:f4::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.24 via Frontend
 Transport; Thu, 28 Jul 2022 19:12:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.236) by
 BN8NAM11FT010.mail.protection.outlook.com (10.13.177.53) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5482.10 via Frontend Transport; Thu, 28 Jul 2022 19:12:16 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Thu, 28 Jul
 2022 19:12:14 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Thu, 28 Jul
 2022 12:12:14 -0700
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.986.26 via Frontend Transport; Thu, 28 Jul
 2022 12:12:10 -0700
From:   Tariq Toukan <tariqt@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>
CC:     Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        Gal Pressman <gal@nvidia.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        <linux-kernel@vger.kernel.org>, Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net-next V4 0/3] Introduce and use NUMA distance metrics
Date:   Thu, 28 Jul 2022 22:12:00 +0300
Message-ID: <20220728191203.4055-1-tariqt@nvidia.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3246adec-fffc-4c54-d84a-08da70cd15e6
X-MS-TrafficTypeDiagnostic: SN1PR12MB2382:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SkYfm972cVs/e3/zSwQBTVtED/3EJ1lMkvFO5k4WU0cvVKsqeKSKC7cn3TOD9OKFCzh1DR3xnJ7i+tkjD6V84DXN9KuxmhDeDgKfgW+PgfOuCKRf0Qz+60HWw5gDIcEn/frrbzuFpXoedGqrN3PJVzzCS8cAQlm2qtQENZrUUBnNSLUrByG17Q6uJa1eTbkmI7k2IiITTxSQlelmTmuJNwm6YEcf3g3GVNBFwND+UDOU0rGfeZqYDb/+njnYNYH1ziiKuQlU+iNHwej6PffGhuYyoqxGYjzjRdfMtjR1A1rKZH+RIAIHcMxIYaqLJkcU3IIPyfzrAZVon5ib7FFKH97Pg56hB+1Sb99piwTj7BLSvYkUf5Rmaof1QbjJrKaFWRtk2YkFMo4RPAQEarwQ3gjyjk/xTSy1IXq0rqVBjQYVWZlGt6QdER1sRwDd4Ar8j9ddX1dyjEWJne2VD9JYNsHvbOx+QU32YRyrqod6DVM/WTjmHkq3YdAWXFoLKMGGMvT1OF85cs90j4pi7epYbtVtluabUY4vQPrJYGPbFlnZeKcWObJQbLSS9tJpuf0YqYZTW7wBAP9vOqsYN+MMJ3exTcyQijxNRK9w4WMNhaELws3Gkyte31yRGk07n40ZmbnjOyBDt/k6YtoaRgEeCwBRFtMckLsTsh7sIJKPqO+occjJIl0cysyZPXxp2adksrFYVD/TuHY8T08t9RPy0kMb7Lm0YFQK1pwg4+em1oo4KwNf1jaAnqUFCsrmhsvR8JoyTycEsn15G/CoyvMSZdSwQFBpZUxbzSPoJ7aEo6tNJsxr1Q3QFregNCha2zf/Se0BqghSUGTJ9NgxsNNqWQ==
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(376002)(396003)(346002)(136003)(46966006)(36840700001)(40470700004)(107886003)(336012)(54906003)(6666004)(26005)(36860700001)(7696005)(86362001)(83380400001)(110136005)(40480700001)(186003)(316002)(41300700001)(2616005)(8936002)(2906002)(478600001)(5660300002)(7416002)(82740400003)(47076005)(81166007)(1076003)(82310400005)(8676002)(40460700003)(426003)(4326008)(356005)(70206006)(70586007)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2022 19:12:16.2684
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3246adec-fffc-4c54-d84a-08da70cd15e6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT010.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2382
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Implement and expose CPU spread API based on the scheduler's
sched_numa_find_closest().  Use it in mlx5 and enic device drivers.  This
replaces the binary NUMA preference (local / remote) with an improved one
that minds the actual distances, so that remote NUMAs with short distance
are preferred over farther ones.

This has significant performance implications when using NUMA-aware
memory allocations, improving the throughput and CPU utilization.

Regards,
Tariq

v4:
- memset to zero the cpus array in case !CONFIG_SMP.

v3:
- Introduce the logic as a common API instead of being mlx5 specific.
- Add implementation to enic device driver.
- Use non-atomic version of __cpumask_clear_cpu.

v2:
- Replace EXPORT_SYMBOL with EXPORT_SYMBOL_GPL, per Peter's comment.
- Separate the set_cpu operation into two functions, per Saeed's suggestion.
- Add Saeed's Acked-by signature.


Tariq Toukan (3):
  sched/topology: Add NUMA-based CPUs spread API
  net/mlx5e: Improve remote NUMA preferences used for the IRQ affinity
    hints
  enic: Use NUMA distances logic when setting affinity hints

 drivers/net/ethernet/cisco/enic/enic_main.c  | 10 +++-
 drivers/net/ethernet/mellanox/mlx5/core/eq.c |  5 +-
 include/linux/sched/topology.h               |  5 ++
 kernel/sched/topology.c                      | 49 ++++++++++++++++++++
 4 files changed, 65 insertions(+), 4 deletions(-)

-- 
2.21.0

