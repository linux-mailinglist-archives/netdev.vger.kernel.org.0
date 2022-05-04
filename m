Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 547CB5197CC
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 09:04:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345213AbiEDHHO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 03:07:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345189AbiEDHGz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 03:06:55 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2042.outbound.protection.outlook.com [40.107.244.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE9CE22289
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 00:03:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NyqhhSeh+rRNarJSnSKliIFfHPywLc0IVhi3LhZOyB3Ipg2/FHJyeQYMAR+t19/Z+w4oMouZsdnBQowQ4hx6QTl8XNZ8YNoxG/nruFI+qjVnjW5x6rUh+fyL44pTD+ivqAqu4zm7JcbrIbmIIpz1lU9mM9oxD1YHJFHGqym7DvZ7ZbSbEEjrAp8mJF5nQXJr9QYSmL0dddK6c+E1xhk77CfL0s/3xZgsItLQ0+/UWD6zX6e2cq4XOv5+d5VMEWP+Qtt6yTq0bMWmX/bslbhq6fKC8ffx9jChyN9B9ksEOMez2OV9YdtvDJ/gvkCJbO2mkgeqo/dybmxEeDZHP+Z1IA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZjM0u9cKmul/1aZVCbD1DcdcGyJZUGVB43wqWd5w/4A=;
 b=eyd+DArJ4HUZWrzMN/v3gP7G/k/kbeJP9Egaf7iw/7453bEaKjaAjcWB03MU5LyGaNeMKy6fRKEIwmR6ZmGSh5z9uDDjIhSQcJbGPgohuBDVv1TMckpi5UebO7ZTyxIuIy3gfIXAM7o1Y2a1uJGnbXytSu6VN1zPcEWaNuXV6EZUffTwgEuhamJHOkfkkYHrZBlzA5TSliGeDneNfKu8R1QsOMpIsAXxKn4tHEtw41pE/MN0PEBUA7I2vAWIybZ/a4XPD4n7FYn77WSnt66M8i3WbGaR3rVzZkGrJY4qLQPuFedFgF9CGK4lZk9H+Lbsxh6WTcNxYNXmgDcuinDITA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZjM0u9cKmul/1aZVCbD1DcdcGyJZUGVB43wqWd5w/4A=;
 b=uNiItefTfMudCiM1fobvbCgZytXtZtEYjzZq1YxIpmIIo5sJH3KH5w/3ctiIUmMy2efjkDCjKMlHIMxyxHSEra4Qp14YNelSgGHm8AmfM3x+3wN/sETU+5o8mWDlOmvO6to4TLDj4npvn1ewulRCUR+tXbf74MaFp2oXzk5csdqHZ/gOMDrbEcOI7Z1tTvTUopshXVoq3tV/bdsCsivKohrRG0t8WHo+VmAXk4zLwqvZvS0mp+zgo7/BVUzsZaIz00aUDzJtsEMND8f81qGDrUhNT5se3n/j1fQM4dPkd+e70JMJZAVp3P2uePIQnzU9zYy8M6MEpmOfMenZMM/ypA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by PH7PR12MB6586.namprd12.prod.outlook.com (2603:10b6:510:212::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.28; Wed, 4 May
 2022 07:03:16 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca%4]) with mapi id 15.20.5206.025; Wed, 4 May 2022
 07:03:16 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Mark Zhang <markzhang@nvidia.com>,
        Maor Gottlieb <maorg@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 04/15] net/mlx5e: Fix the calling of update_buffer_lossy() API
Date:   Wed,  4 May 2022 00:02:45 -0700
Message-Id: <20220504070256.694458-5-saeedm@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220504070256.694458-1-saeedm@nvidia.com>
References: <20220504070256.694458-1-saeedm@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR06CA0014.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::27) To BY5PR12MB4209.namprd12.prod.outlook.com
 (2603:10b6:a03:20d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b519904d-ec46-4a10-d941-08da2d9c298f
X-MS-TrafficTypeDiagnostic: PH7PR12MB6586:EE_
X-Microsoft-Antispam-PRVS: <PH7PR12MB65865BCBD679B0E5BF220040B3C39@PH7PR12MB6586.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BCST9V+Dv46eUy/hhh4sGckVCgF4jicwieNEJ8nF7+p9jy68YZ7+OpTl4eGjpMwTPo1NN/affYh+szSRC1jn7msiNIv+yWGTxqA+lqjgnqW2SGUpRPkyZD+U5V3ElQ8XWKIZ6KZ4P8mqjt1Ux38cM0x9RE3QeIzwGNHuI0Ob492rb4UY7mpQ3X+KvIPlSHXAH2BTHeYRO0H9YItnT4nP63CKqCIKNiDhocgijk5VeGlJI58eOGB+9W1bnelg9cC+UdjAAOuLdWBF+m20RtBLRnY5dV43mvftnKsmOnUcA16BJW4rj66DeN4xADuakoCs2saHRU4W9qNXPQBxc8JnNoUsIHLIyZ+fzuFlkEbF6hjGJCClznvWhjQhSABd9xOyFhTY6dF4g459wS7Xn5e2O0RxKYzdut+HWVbmr9WRSoxq/qDgCP6w+Tn4z6gKLtheghvZZeqc3k6z2t/dZY+35GGiEBqV6N5yupCriaeUDBR9tvEmTSgYH5FNtUkWf1GrARdWWpuNiB/+uiJnwjZm/kAthFHKPsv/wXLrUfhzQeBQQUNUhfynbxAypCVIeQ2rJf79NJHRgexuhlPS7U8ugcBECnqU68Wj6JWqEtZg0TKaxgNfpKHPB7JXYR4txgMXP8LYk8p+iQH4jz/evaDq1w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(316002)(86362001)(83380400001)(36756003)(1076003)(107886003)(186003)(66556008)(66946007)(4326008)(66476007)(8676002)(2616005)(2906002)(8936002)(6512007)(6486002)(38100700002)(5660300002)(110136005)(54906003)(6506007)(508600001)(15650500001)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KHqXNfnBIctFuVwH4WTPKXa8Z5BFsMdQHDTaV6HGLA/7lB/up673LVgx20ko?=
 =?us-ascii?Q?4YnFVeA0O8aLqfE/musKSkTHTSjEYQ7DrJOpzxcYq7BlyI71R0YylCUXA9iO?=
 =?us-ascii?Q?6Z7RfB/9T7y4ZKwQJzd8lTtkuKLNQhAzGhPLLY6N2zmy1y64V3lErVAY6gm4?=
 =?us-ascii?Q?Dx12QJ7t5qKGEEAu+3RbUAayVxkTOubTP+9ZBf9Q8j1QlgQgRmiRsOwYjcNa?=
 =?us-ascii?Q?GSBIRq0HS3IeBEXkxYuLwRmOHwAsXaUN052HLuEuZFzOv27qTY6jvZfCRqJZ?=
 =?us-ascii?Q?wEZcqRW+bmT34CY/ncWfVCQ6A9v1bPc0nmS3TlEdaX+MaSFHvVwgq1hZVMyY?=
 =?us-ascii?Q?/sqIU157KHBBoSjOxL6zDjBwF+YDJ/0EZJTbxmC/lS25IBQ7rBC1JG42M9C+?=
 =?us-ascii?Q?3fp2cM76BfAksqmKF6DVaNNmA9NcrFqpXSFGwh6/IRKiN0up/5I60XGcjHu/?=
 =?us-ascii?Q?A0SneZ9jioYtHCy6dM12mqGiTFQfOitdK5vGpL/I0uPX8JK3GB+YZPXUK36e?=
 =?us-ascii?Q?lQP2xDLMjH8CXwxbJNDDVcdGdzEbnkcnW2qYGevy5F3DUQ7GrH334hcnumgD?=
 =?us-ascii?Q?oSQ0g9wKQOiq8RsaNthU88CrlbyxxdbUhaXgsKhjaMau1VlegTVYwsfIDs3W?=
 =?us-ascii?Q?3hO9AB6lUI26WQQ3CNwYxqT2nyWnf/cyeNLJdoa8fLQlQ27T7XkcOXBLa9j2?=
 =?us-ascii?Q?goGdfBHKIB+wlSIBTqg6ZgNPEp2x6lWZ6MpNYzKney+P1gIxU4qqlzLqP/sO?=
 =?us-ascii?Q?MhSsquApEp4Xg7OrwFn4BoiCCQLGcijWWtyqmwfOWvuZMevkKHZUFSWeLirY?=
 =?us-ascii?Q?bty1wK51m8I+b/r3gGwYmC9gFHwUr/vh92baLLGfJgZBEnpTROnWLjHH12cn?=
 =?us-ascii?Q?xa02MaUdCVnNhZO4bSHMI+0nEuY4C2qRlXV2ZZGKI3kjEUwzXigtLsQb7MBO?=
 =?us-ascii?Q?egIwkI+2JT+RM6/XlmcLWyGkpH4ojdcPA31XyJVX7J01tsmwL0+uSWKs4raW?=
 =?us-ascii?Q?/fwBAjArxRm2LMRSZz2I1/pHEYGXiDzK+g70JzquotbV69vKLmrGV2+NTBX+?=
 =?us-ascii?Q?j8VYTF0FWYhHmLhze7woQ7Idbalk0itq2zkfIth/CyzpYgV2mpJ9nstyiJt4?=
 =?us-ascii?Q?xUoNzU205leGoRGOqsShy+BsRtaeLnkuTkePXyEIH2WIlqABuYcbN7VY+d2i?=
 =?us-ascii?Q?9oVCYyxIRVDWdSX+f26LMY5d7Qvy9o2qE87WMUYqda+Zngzy3Sm/FHZVwr1p?=
 =?us-ascii?Q?etYV4eibMokR9g4/R37tAZu+teLo1GIgSpS6i4rXgGomWWku2m8YuUj5/Zph?=
 =?us-ascii?Q?G/RbRezp2r2Rl8WnDnbhTSvRBDNjU7/5/yUvhTX4ygyKfxX7eVUrEa6JNm+i?=
 =?us-ascii?Q?qNsn8KR4QPbAjzHJhiHXQ8nSSDxCXPMcTgmdY3GXZcXaSxHk0pU8CEFnfNOG?=
 =?us-ascii?Q?CnY1hSJGkiR9Kej5TE+f5ge4LcIZ9p8NdioQ3ZOFosdwCa+jypG4hp3gmfq+?=
 =?us-ascii?Q?Jx5T8te+SsanbNYIQ1DJX6Wc2CB4pwg0lJTz+iigmLnDbcpeDZiwPDEpepmA?=
 =?us-ascii?Q?pq1Ai1r2q9ZuQlZ2YwD3TOrEGtghC3YpaNHt/3ijM8zzOs5tZnjmCP7+AkE3?=
 =?us-ascii?Q?r/euNF8u27IVvAIYir4niKBXLnlZulo3/zC1WURp39t0OJ3PI87rEduQLVZ5?=
 =?us-ascii?Q?dOGbzF35v3NwDF/0dCS/4RR8O1RNw0Hx9SBFLZaF7sGTkhQroanZkrb17Wdu?=
 =?us-ascii?Q?PUCtHQ03h8UYCLcHJ7hjMyu0vy1zFxn5QbIEVr5FMzugWXplaBCA?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b519904d-ec46-4a10-d941-08da2d9c298f
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2022 07:03:16.3037
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wcQ3RYY1zmWqjcffcOFS1XgyFMogR84V8JY0/2jtJLGPC0sfUTFzYO6873z22Tzl67rThj90wlPYiNxOhzrgtg==
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

From: Mark Zhang <markzhang@nvidia.com>

The arguments of update_buffer_lossy() is in a wrong order. Fix it.

Fixes: 88b3d5c90e96 ("net/mlx5e: Fix port buffers cell size value")
Signed-off-by: Mark Zhang <markzhang@nvidia.com>
Reviewed-by: Maor Gottlieb <maorg@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/port_buffer.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/port_buffer.c b/drivers/net/ethernet/mellanox/mlx5/core/en/port_buffer.c
index 673f1c82d381..c9d5d8d93994 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/port_buffer.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/port_buffer.c
@@ -309,8 +309,8 @@ int mlx5e_port_manual_buffer_config(struct mlx5e_priv *priv,
 		if (err)
 			return err;
 
-		err = update_buffer_lossy(max_mtu, curr_pfc_en, prio2buffer, port_buff_cell_sz,
-					  xoff, &port_buffer, &update_buffer);
+		err = update_buffer_lossy(max_mtu, curr_pfc_en, prio2buffer, xoff,
+					  port_buff_cell_sz, &port_buffer, &update_buffer);
 		if (err)
 			return err;
 	}
-- 
2.35.1

