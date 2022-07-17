Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD73257749D
	for <lists+netdev@lfdr.de>; Sun, 17 Jul 2022 07:23:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230501AbiGQFXh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jul 2022 01:23:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbiGQFXg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jul 2022 01:23:36 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2048.outbound.protection.outlook.com [40.107.94.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A35F15A05;
        Sat, 16 Jul 2022 22:23:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O+wcQ9ApetDEeazZ2SpgXHX3UBU5DJ5Vk/9lx6U+L8S1M19F8Fa62W0Nqm8RipbSOFjEkbPyIQh4nIOUAFA4TmLPiS/UB/Yy4IF/4QeF1RND6Xcf7zdCRO4kW29BUkD3d6eYfhCcnl5OQ1IiloJ4hEimRDUgyFZi/dJAPD8Fobji8s+GgyauKlvY/Bzsyk1H7CxOHst8e40XnP8nX1bQcxy78+OrHqCwoUALq4LQRFvuGIHRDaESgchZX2aWjbzsOwyh9GNwzy4gE2wJrjVNJX9X0QiDHrORzunBOCFHcrt/JvvwCk9JPeyXGzy7x/tLNZDRrNpiHfE88QW6chh4Wg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WmvdY1C4UjBbZGN6Muy6CICOwlwZeQBZfvzGxahW0ik=;
 b=R1nQyGFadBQWxlDoKDPgXM21TKGohBIz7k8coK50oVL49eVeWu/pkXyI6HRP93GvNEng2kl7hmZiuz7KGuIM5p72z3+SYIpBl9qJf7aRzLQtXgU4NNWR+rSLD746+4WfvgRbcaadTlIXdlWmsaiCi8q3uybiwJNv+SQgfm/ern2ersKAxs1zatOgQIn6PPTWAk+a0K3VTlsajD2A07ys6yYJv8JSt0C0wzL9i0+RtHL2y63itHQ0McElgXgSUpZYVY9adn17lCJD9Fuo4KNUEIaqKzCeISTDAcG6qGD6+DOuwWzlPevZnJMWmIu2htGn//9/kSDUL+nPSWQsrL3dKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WmvdY1C4UjBbZGN6Muy6CICOwlwZeQBZfvzGxahW0ik=;
 b=YPp3YejrKBtEwGf8lvELUU6a1esgOYxp8em863vFXcoy11p3n2szwfFxPZuKNBTJE9wp3t87V9eq1YDoYikxrZ7uMNccMqFu3K6iXFzlt/3QbDdZUjkU3ZD6gXxyKnUOCloqsElqmf0YLKxE+2eqcnzywoLWx/5l/RYmC8bDaEgNWrOyrCLsw8TlU3O6YYlyft3kFtvw1aNapjWEvzhVafXoH6j9zEFbYACfrR0lGbdc8nl+P3D3BvZMnOge8GHcabfscAzDeG77o16XqEC2bkSWGvl/I3EcfDAM+1Whj81sUJmJQwaC+X1pBG2ucetxcyeZQK/Zh4DzI++OprvUdQ==
Received: from BN0PR02CA0060.namprd02.prod.outlook.com (2603:10b6:408:e5::35)
 by DM6PR12MB4793.namprd12.prod.outlook.com (2603:10b6:5:169::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.17; Sun, 17 Jul
 2022 05:23:30 +0000
Received: from BN8NAM11FT016.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e5:cafe::e) by BN0PR02CA0060.outlook.office365.com
 (2603:10b6:408:e5::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.20 via Frontend
 Transport; Sun, 17 Jul 2022 05:23:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.238) by
 BN8NAM11FT016.mail.protection.outlook.com (10.13.176.97) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5438.12 via Frontend Transport; Sun, 17 Jul 2022 05:23:30 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Sun, 17 Jul
 2022 05:23:29 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Sat, 16 Jul
 2022 22:23:28 -0700
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.986.26 via Frontend Transport; Sat, 16 Jul
 2022 22:23:25 -0700
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
Subject: [PATCH net-next 0/2] mlx5: Use NUMA distance metrics
Date:   Sun, 17 Jul 2022 08:22:59 +0300
Message-ID: <20220717052301.19067-1-tariqt@nvidia.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 60d3c89a-e593-4c90-c4c1-08da67b47c48
X-MS-TrafficTypeDiagnostic: DM6PR12MB4793:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SIqXANrf7PTGKq4pg3i8n3x/0WHr1CX8sI1QwV7dKIQt/JyYteFYMB0pGU5AG3+ccM1sGR4VgZX+WGLhMqi5m8iqHwJXf9D8046MQpkI0e1XKMDHNz0ZHCVQXAYEXCFNG39ZXE/5kLuSFZEsdnXU79Zq9OolxfUM4f3EXzC4aakg1eWE1doFYNvGw5x+0rWn2k90TNASfqrR7crOb5ib04hGmfm48fYlfoxPtHX7iDhh1Iwf+OQgoGaXW8RWjxEweLqqhVe7T5pR1iI83NcL6OdB6Qy+kb0czzgYq0w5Iva/VtUNXgGpM6orMQFMI++aYqDUXOgwhOHlG056y2xa2IHUUwAkq5IsKpxM/dfXFBanLPJzdDIyXB5I9QFcnuFkhmM5vi0fOrmijHQrdJ8qcOeBzSx0K2/Nnm9+6JfQ+YPgbodHHCvh133jsmHbGk9esDWk3I1scFZlZnTJYcSxvdyPmTdaBSy/3gNCEuh1EmUinv76DwyX1x2C271rB9ffg7SiApWVQFuGyc0Wg2V+4ZomENHKD8L8KSQi6xX4TzA0fCNN/sxiYDOyj6+nMszchZVVYS8fQbnni3VlVGZ3XG55x1do+yS2IHwsWatGo60APDa5F7GOdeZoaYCdJTofZNdW5OaQct91wJyWnhwUj0FUYt+s3G3gvyH/OoQdLHwlKmNam7M936EbOem4owHeoblW1pnJhXYhPuYUj+nwmT4F/SreQi/O6bRMjk89ipn0Dl1yaXw2F6YjyzxdMQE8x0OWNRTiJ1VN6E1PxxjhKYUvqE/8OcYEt3ySRe9dAnDtVzJWLPJ1sfgjRCTSoExdnDf7CKN6Vuztvf6JUthniKlTvknx2mMCQga5cGKOlLQ=
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(136003)(396003)(346002)(376002)(39860400002)(36840700001)(40470700004)(46966006)(86362001)(478600001)(1076003)(186003)(2616005)(41300700001)(7696005)(6666004)(26005)(107886003)(81166007)(356005)(82740400003)(336012)(83380400001)(426003)(47076005)(36860700001)(2906002)(8936002)(4744005)(5660300002)(7416002)(36756003)(40480700001)(82310400005)(8676002)(70206006)(70586007)(316002)(110136005)(54906003)(40460700003)(4326008)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jul 2022 05:23:30.1545
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 60d3c89a-e593-4c90-c4c1-08da67b47c48
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT016.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4793
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Expose the scheduler's sched_numa_find_closest() function, and use it in
mlx5 device driver.  This replaces the binary NUMA preference (local /
remote) with an improved one that minds the actual distances, so that
remote NUMAs with short distance are preferred over farther ones.

This has significant performance implications when using NUMA-aware
memory allocations, improving the throughput and CPU utilization.

Regards,
Tariq

Tariq Toukan (2):
  sched/topology: Expose sched_numa_find_closest
  net/mlx5e: Improve remote NUMA preferences used for the IRQ affinity
    hints

 drivers/net/ethernet/mellanox/mlx5/core/eq.c | 46 ++++++++++++++++++--
 include/linux/sched/topology.h               |  2 +
 kernel/sched/topology.c                      |  1 +
 3 files changed, 46 insertions(+), 3 deletions(-)

-- 
2.21.0

