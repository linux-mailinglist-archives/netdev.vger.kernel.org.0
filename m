Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D3ED49C791
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 11:31:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239989AbiAZKbX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 05:31:23 -0500
Received: from mail-bn7nam10on2084.outbound.protection.outlook.com ([40.107.92.84]:51617
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239985AbiAZKbV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jan 2022 05:31:21 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PgcGxYsVM87ViYZbRVXUjl0E7II9Idl3EcWhhVwegScfiaP+uHLUKKF78HkqiXTvUym1V3Uic4k2aICWSGGs8YtH/D04AeFgRbDWQnhkSnoeJbdcDu3BvIgO/fbiKqscGwwjwtLYJK65lVTNxU80m/dcit+uZ9Rjhhkst5e36v0Wtj2pijTXw7c4sxFtebIrOYExSIOs7bn8vKQ6OfLEcRtF1xXPzEUbsN2te6Pg2n9suGfmoLEokyTTD9V1EvQO1CMiI3R/KJsbw5qNSdzqG+v4idYdy6Ifmn+ThsT4ZIc4BDM1aAHmO6kIYprm7GqKCo+UjW1lXtiKWa7oOBThOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xJ9m9wVNFP/ns5Va2Cram2cfiMjVb2RiKkLc9SRq7K4=;
 b=RgHfaRpGV+VfC0CcKk0q4kxmjtW3lfaeFxID4JQN2iYRDnKxgxaz4vzuHMos6dk1ASCLoh+CRwQe1leSjiMLvwOixzihelZZhvcB0d2RQhHlS++7zOx8aEJPdQDptNHehdHKryl/qaHKT3xEMRefcR0IzSsi3rgFLOAw5ReIx4zUvFqohv9Mh7JOww8qSxQSxYoAGl/ESvnetcIgQf9dD9q/RGs0Wo7efCNAwPV2My0/92PHYoH2NkBloWA+TeOv49JsSXHfu270nFPOIe7D2ePAH2XHvsrLSqP099/goPeFRXYcoeq5kAP4x9BxW3u9FY+o3YTxD9DnCi4vg7g5Aw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xJ9m9wVNFP/ns5Va2Cram2cfiMjVb2RiKkLc9SRq7K4=;
 b=lDR7irw3y+dLksa1K8h/30aqYcbkvdQi+CBJ5+AxOYMrUJTi/rFRKTp+bVi8O5DETpMyRo8LHEE9eLmqUPqsYS1wQuYBdwBAefVdZFjfI/5RWzLvhF4yA/64njkin9Ev80Qb+YWjTlDrpeCSgSiTfi9xjFh7s13ZpMUe+f7GaCz/2xqFRlXXtEI2tcRhwZngPuUGwKBuTK/1HTq84ukIzGFtjA0Ln00jAtDoskGTfISKa/ibgtbPs8XXthLjgjpcgHZTJZFEBRuup8xRkmmtkWkQdLgRNLJOk7ycOgtdsU60/b/eWtHAfS2NnCeeYQY9khEqQMF/IgqJhLMtAYLt7g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB3527.namprd12.prod.outlook.com (2603:10b6:a03:13c::12)
 by SA0PR12MB4461.namprd12.prod.outlook.com (2603:10b6:806:9c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.8; Wed, 26 Jan
 2022 10:31:19 +0000
Received: from BYAPR12MB3527.namprd12.prod.outlook.com
 ([fe80::3dfb:4df1:dcf1:4561]) by BYAPR12MB3527.namprd12.prod.outlook.com
 ([fe80::3dfb:4df1:dcf1:4561%5]) with mapi id 15.20.4909.017; Wed, 26 Jan 2022
 10:31:19 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, petrm@nvidia.com,
        danieller@nvidia.com, vadimp@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 1/9] mlxsw: spectrum_ethtool: Remove redundant variable
Date:   Wed, 26 Jan 2022 12:30:29 +0200
Message-Id: <20220126103037.234986-2-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220126103037.234986-1-idosch@nvidia.com>
References: <20220126103037.234986-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VE1PR08CA0016.eurprd08.prod.outlook.com
 (2603:10a6:803:104::29) To BYAPR12MB3527.namprd12.prod.outlook.com
 (2603:10b6:a03:13c::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 453f2783-c940-4731-da54-08d9e0b6fdc8
X-MS-TrafficTypeDiagnostic: SA0PR12MB4461:EE_
X-Microsoft-Antispam-PRVS: <SA0PR12MB44611A7FA9E9A8E0798C65CAB2209@SA0PR12MB4461.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:626;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PPUU6vVQ2tyD1avSMN/627WuqGO5Io4TaiZPg5JXlXQEV0o+duXcpPOu2iw84SMP5hn4tciyoi5KZ4lxJqR0mKSDRIHhBsou147nwomxP4OWtDXJGW/OXGaRhRGzUGDmZ+7H4bVyWVh2fp1++6TEe/4kgHSQVCerqmWlo7h8u5aQwCdYRc0cqFGQ37zVAVGqNqWC4rREtT+s0ANi8qzaD37wRj6CrtnIlUsYshCQWC3ousqWLCR+8mdKh6R9hmnuIVJMSVIOfVO0dWNZfQ5LGPq3CDZesDdo4NFmMLWbsa5jLGtKbOpWQpC5UwG/e2XQ4fUbO5wdlPxpUpcj8tweh9pRdN/kM5d627Vd7hdXjLvFGAtdGynCZsVGRxx7DeUg5Mpa38xVqLzm9MD612ecl6AWJGzVf5ikVjAd6XXvpy+rTmih70VzyI9Y5wfV9eJtNCzEKsCakHjpzy0CyQwMfZKr2DVS/BqFXL39fqeI/xBmNGkx9nl8rGm4ygqunZozJiK3N6SMUN8D4L+A3JB2AY/XbDrIPpVzHDTXXLYSPToc4nfgSuO0xJ0azC3tkDznoNuknk6CYV4D6+3uslcebCmgkGC2BCHEBqk7xFIxsCoWIcZ5MqK8kg8JFFoKWtaJkfODIXyxY3E6CQ6pIggwww==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB3527.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66946007)(107886003)(86362001)(66476007)(508600001)(8676002)(66556008)(38100700002)(2616005)(5660300002)(8936002)(6666004)(83380400001)(4326008)(6916009)(186003)(6486002)(6512007)(6506007)(2906002)(316002)(26005)(36756003)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WaTCxZ/mKjg//bz2nZ0Iny7h+fKkE7SRsDt8/wSC34SAiFuqWs1ihk9bql4/?=
 =?us-ascii?Q?zG0e81s+AvMuvWlyhv3LPPXT0Jx6Eb1+ux37LH7yf9rdEpCkwk8eY2xPOCEx?=
 =?us-ascii?Q?ityZnpHV8lmBNEsOMNpuvTemxMnZwyLIZ17sjFL60ljG9EnJJT/JMzA/1Ev8?=
 =?us-ascii?Q?Z/0ATFjYvO++ElSyTyHOzwou1dZaOQJGU9zGC+9IHAVSXzb8mRqvWco6K6H9?=
 =?us-ascii?Q?Vu16LkHAIOPzBSZka16VTkd929oWCYkPTclKNRa+THoyHantfHzE1CVGVtq1?=
 =?us-ascii?Q?gLa7pGtqqkltGRSX9ID+zbwlmebTcJrN9qVji+NeSqNvr92JKjrFY5II1i2X?=
 =?us-ascii?Q?RG9d4uQI2h7HPcwCxiCDOeF6ZW+6ZiWP5aXTDUbVxnUlpS76pdOuvhFytd7P?=
 =?us-ascii?Q?pFdl7hn3XTpV14TfHbWzNPhxGxvxQuOXG+jKE3XZ5EunZ1AKc51tl8OH4myu?=
 =?us-ascii?Q?J4qdtaTgXlppuOFQ1RWDLw/M2zZUh4Jbrka7Tg+InmPyjMULwW/kvAH2zN/V?=
 =?us-ascii?Q?24nMjGa6ldmn6zhyFym5fwHTjO2alkPTbXn6Zn5zYuHcuS+jmYIav3k4SHqk?=
 =?us-ascii?Q?kWgOEOSyKDJdfhFQo21ixhjQTdW6STTcAJT56IhHH0JuNlWMIuADrGa476uY?=
 =?us-ascii?Q?NIdLfvVT1GiUiKE9OMuNz7aO8LzDOgLayysvNDql2on3drL9auA6Skq1TjGz?=
 =?us-ascii?Q?Maciy4h0vM5fd40bLkqXQ5TfiyETeK/atyaFFlsBO4AIPGkUXA/tY2rR86NB?=
 =?us-ascii?Q?28RzHO8hW0fz5eO5BwNMVqLfyp4rK17pPk2mNdMZYgG9qjb4wIEDPAwtm1Od?=
 =?us-ascii?Q?U7XhfBkIsTOjQadQgrWfEamF7LFdCDKHVpXS4sgEfXNy662PMYdHmySD1JFp?=
 =?us-ascii?Q?/M55LqfFbK+DHsKxho9pr9MU3Pdd68iITK4F6rwsayy0mz/nRkZLSamxgnE+?=
 =?us-ascii?Q?VYlCHq1Ua6K3FIpz6Pq38uKjpX7jtG033Ca8Uses/cD2H/5WgbVlSLDZ+3ip?=
 =?us-ascii?Q?ZrhuDkxw5KsbMPjBiqBBvMytADatd9apWk+sUyldz1QxIqJkmdi3/6LOvE8u?=
 =?us-ascii?Q?GuAfdqutrpx7/tyr8+7OQjOiijSv+3Fnd4Kq1ncmbIsJjmsjylxWfNS48Vp+?=
 =?us-ascii?Q?e1u2BWAHQMoNMTGZRtT6/WR1ukC6baAGpiyc76upVi7lzUvaAixDCImhsAs0?=
 =?us-ascii?Q?WoXlLUoM+6OQ/HpKSUviXA3F2Q2lc4Y1xBSy/81uNwevITP1rxs1axqacusk?=
 =?us-ascii?Q?WiK3OXkCLPCW+x7fFAqztQItzzzK3cEtDhV0TxOhmHTNrKbLsJurMYLx8ut9?=
 =?us-ascii?Q?nLivoNwpcKj8MMnk3vDesRn0Uuy6QgyQrbavlVmZYd1WLrx0v56726W5Io6d?=
 =?us-ascii?Q?IFHnwjTzTYT6OEvmq3euqBYmVPiBJ8RBa1JrIV5jpkGnLXfC/gy2OXe3F9iK?=
 =?us-ascii?Q?IALxvnpO0xk0iONeE2eeMnfPh0SftIP4qYz5/nkSUt+5ilaoiykOe1BwqmKJ?=
 =?us-ascii?Q?+eNSOn4q3hCcP94dlVV3eJlu0fFQh6PigmaKb2r0AYB8PjjprYlMtP1deCGB?=
 =?us-ascii?Q?y050YvHebLZQo/hoC33+FqkufPdLdwRbsz025pPvWQ0qBNRFV4tlWCfcwHwH?=
 =?us-ascii?Q?ihpeodLKtf3fPgq5AgDXVKo=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 453f2783-c940-4731-da54-08d9e0b6fdc8
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3527.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2022 10:31:19.7666
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9BY7zO0BTver5VZOW7a/5tkIIGRvUnmmJPmFIdfKKbWkfGAIZ5y10dB8IHZ98CsM3Kgr0nLpinbb3GizUO00mQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4461
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove the 'err' variable and simply return.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_ethtool.c | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c
index 20530712eadb..68c0ddf3b6c1 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c
@@ -1034,13 +1034,10 @@ static int mlxsw_sp_get_module_info(struct net_device *netdev,
 {
 	struct mlxsw_sp_port *mlxsw_sp_port = netdev_priv(netdev);
 	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
-	int err;
-
-	err = mlxsw_env_get_module_info(mlxsw_sp->core,
-					mlxsw_sp_port->mapping.module,
-					modinfo);
 
-	return err;
+	return mlxsw_env_get_module_info(mlxsw_sp->core,
+					 mlxsw_sp_port->mapping.module,
+					 modinfo);
 }
 
 static int mlxsw_sp_get_module_eeprom(struct net_device *netdev,
@@ -1048,13 +1045,10 @@ static int mlxsw_sp_get_module_eeprom(struct net_device *netdev,
 {
 	struct mlxsw_sp_port *mlxsw_sp_port = netdev_priv(netdev);
 	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
-	int err;
-
-	err = mlxsw_env_get_module_eeprom(netdev, mlxsw_sp->core,
-					  mlxsw_sp_port->mapping.module, ee,
-					  data);
 
-	return err;
+	return mlxsw_env_get_module_eeprom(netdev, mlxsw_sp->core,
+					   mlxsw_sp_port->mapping.module, ee,
+					   data);
 }
 
 static int
-- 
2.33.1

