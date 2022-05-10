Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C8DA520D71
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 07:58:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236946AbiEJGCm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 02:02:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236944AbiEJGCS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 02:02:18 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2073.outbound.protection.outlook.com [40.107.94.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E32A293B6A
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 22:58:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ax8MdMFENANqeY9kAq88T52qRbBUkQdRSvfLQ2iIAc2CtB2PjaugLCcJBeeChBspcUib6kG+87I57VdKh32BsgBbPp+Cj52eTs/3LyU3mBywoZv9cw+c4jldVu2/Lff9SHGI7qQ4BCVM9LEpgW0O2PJSXq3CWpkqbSdCivT/vlUrljXnkKZZWu4lRRPiBFfqYY/nxhYg0bKPaf5oe+Kr8alErGHyQKjufOSEJl8b3AlbB1RjR77bQcdp7+MNjsVzEAjBJpcDfPKiDD5BnG5tLQ0RSQCsfvEu/BeGBnRU+lF65dLWihZWTHrrLPzZOhj6ihpjIldLbteOTLIMCK/gmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rRsVg0qbusxgdeHO/9K3JiujOHxOp0tkU/t0hLhir3w=;
 b=d5IZyFLOWXV1to3Lqu2dfQAAKmdO1oveh7QNaptIfqS80jK13frJJ0G7RlVaW054DBWkm4Up0IrmTxMm9L14/9k/Kv7Zd/JJDtO5fa4PYzt6Qz6hlg/iczoVjCovotWYOElwzhRn5OO4VVCSnWW+btu+uCKD97tJUWJ9FstGPmMMy80KFKltfsNMhB20LcFK22bW9IkEfwOM2ePfrEEojslYU1YQoseIZKPku9GLfoycsRXTsmuhbndAGEg2XCYQkayhuQL7hDa4WKiPgUv4KxMsforiO4THQOp3o/M1bl5dVZFicEvq1OuyTV/Whs9cqIRmnxgPZ3QmwJDR59YDqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rRsVg0qbusxgdeHO/9K3JiujOHxOp0tkU/t0hLhir3w=;
 b=QQCiwT/GJ5Ir9Obol+76DMqFPEv3tesRVLXnCiPlEGQQ/JcFrV0qcRbTiTPRleI/OrLoxBrDIRmZfA372zPowFCRgIOPeoc4KkdNL8mCMba09PWYbWHOFqMQqx27tNtVETfoR17CytXehdLhYQ6lrXUsjtWLO7jZ/c/4ieu8KhP/VR9B2jNvswS7X0mP+eO9Z9QwDXUPEgIl7hkZYj2Rz3AQASEkrtMy5/exrbPHRm/W5wfFq6d/+1WzlcidDiWdvvH72xwHCWSgS2ZLAVxizUhDTTW6ZkRRNyEzmfgEexivMNraQQcxl4irJfxhHn/f/o//h70E6Y0hG0JQm3Z9zA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by CY5PR12MB6383.namprd12.prod.outlook.com (2603:10b6:930:3d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.25; Tue, 10 May
 2022 05:58:11 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca%4]) with mapi id 15.20.5227.023; Tue, 10 May 2022
 05:58:11 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Mark Bloch <mbloch@nvidia.com>,
        Maor Gottlieb <maorg@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 10/15] net/mlx5: Lag, use hash when in roce lag on 4 ports
Date:   Mon,  9 May 2022 22:57:38 -0700
Message-Id: <20220510055743.118828-11-saeedm@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220510055743.118828-1-saeedm@nvidia.com>
References: <20220510055743.118828-1-saeedm@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0128.namprd05.prod.outlook.com
 (2603:10b6:a03:33d::13) To BY5PR12MB4209.namprd12.prod.outlook.com
 (2603:10b6:a03:20d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 516de739-0bd7-455d-8de6-08da324a108a
X-MS-TrafficTypeDiagnostic: CY5PR12MB6383:EE_
X-Microsoft-Antispam-PRVS: <CY5PR12MB638377225AB2CAE529A4FA13B3C99@CY5PR12MB6383.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nwiy+O87CAjzSKZ7pdAXRZVkklPpK8cgDZCk3erxu4G35RS7/syZdZRAXkG89OOsCP9WdVKBSVL0DNsKwAEQ0sRjDtlaiHXVgGP5VW4oa9BVEAuAcSHLuJl6UpmYhKv1CGe7cJ3OjYZXBGyv0Lde5+6RqwUEZM/vUmnqIP7ZGg82c8YmStnxrLI6BxtJvH1jtEe1ZQzYH0F6fsQzDFYnHdyrn2qHAJF5nFl2ujwK0IOy6Vu8/X/MEwJBPughwMPjh6l4IkOwXYaDVWDDQtApPPs+5ENLLuxMdNMXQOLc87/pDS916l6mzL+4Jn6q+6xosopM8mi6+jqTcdzrgVXU7B8VkhrCyo/lUZHBJsi7rbnVl7hPzj1Zimb11aeKzI/zwgqmVKaNvjhjp9cJpxDS5jDikFewgJ+4d/NLNykRXWteefkzBXZcZ572Gj07f7clVBy7e3CPCdBt+AjfHYEfvgyS5y2DOaCg9bcavB19bwWHMQMYuYgJAp6alRb9DUcWiMm5EMhwvtHE1cZDSOTh5FQiEIneJTlFj2lop2xijd49ZD038xt3xSXx0C7gpjbDj+hxkZ+StPN+O+bB7DBotTzovYm0+NdUD+Q8hIOs5aKzKfG1zvj5cBlV1Gvex5SdiHym8v/2m3qQA5aR3D924A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(110136005)(316002)(8676002)(36756003)(2906002)(6506007)(107886003)(2616005)(1076003)(83380400001)(38100700002)(186003)(4326008)(8936002)(6486002)(5660300002)(508600001)(6666004)(66556008)(66946007)(66476007)(86362001)(6512007)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mHl1gV8mma/D41CQfnt2OQ7idn6enO1NtY7R1KUHswa70O6nP/dN4bwivtor?=
 =?us-ascii?Q?N8GK34wqr2wBcXFGs3qec3EwQgFeiDVEywSBdmPNtBkhUuZABDmc51r+ClH2?=
 =?us-ascii?Q?+bqicE6/SmbNldesV2p1SiKpFsKktdHA572aM/2iFrzOQDZdYx4LKzgSVmUv?=
 =?us-ascii?Q?KuLMaRFkpgtDy57fuxCeFk7NTGF3uk+ZDYkvyztR4AkEytaw1hPtwEu1JlUs?=
 =?us-ascii?Q?znQNW7ZNRoZmGGAKx5aBnQWmZsevKrtdfW2qfppKGASfuPb7jjtyzQw8Y5gj?=
 =?us-ascii?Q?aFTDZp0EBYgK8KnjZghQ9BAelrXOt5Kocd/1jGL820KJu3VHNdIsvRhLVxvg?=
 =?us-ascii?Q?ZUNhzDjgz1LK+Yt1FHIWNTxiHuxAveAZ5yqeLVnT5FKzTIRLEkI8F/Andq5/?=
 =?us-ascii?Q?Ap/4WMPc1P4R5H2UC0lrtg7GyRY0ZukOg8Cf3jPNrDMcaTe2Xhw11Im1ZCjr?=
 =?us-ascii?Q?+0D8tRpjzhslhurw3Euy3kofIEB8OKVFQSdmphwWgwzyKp9wqvKzs6TIeAkg?=
 =?us-ascii?Q?l4aNItkk3DM9w/NEIDXsN2lsq9gvzLNKZLOPgJnJ7kcHofCsHsDQtGKpw3D8?=
 =?us-ascii?Q?8e/3pknghq0W/TBuV/XFr8OYHVALQj43lfWsakST3sXnYAIo7OVq+Q943dZi?=
 =?us-ascii?Q?/mW4GfkjZTsKUdPzxkTSTKxJl0LmXh6h129jXzsJwPb+zSue8niRwBbcgmfj?=
 =?us-ascii?Q?VqFAf4d+T35nIswBSRmnAQIV39zXd1ExZf+5nl3eD7UYsETGfnXNr7MLT2NH?=
 =?us-ascii?Q?JV4TlVyWNhmv9YtFRNbwGHE7buGLCiUVIScGL2b3wnExhx0F+xYGAiGfYqVg?=
 =?us-ascii?Q?Mmq5ki8fyBqMlaonKxya4wntrWCC9/kcbKb4UsXcgJ5nCRo3+i4MIkZkw9ne?=
 =?us-ascii?Q?Dc5O8LzJoaK3zKkhkYIB7adVtk2lbaSAG4HZGuKBVeYDEB7FRbcM6/ZKuXE6?=
 =?us-ascii?Q?8dBPThnUPdvrtOjtn7Ci+4Emaki1gP7srKPUfP4frwGYTPAqfGLWsxgzBv4M?=
 =?us-ascii?Q?d6jJxdPdRA7aVeIgVOqv6H+P/ysqci2erSK6/vsk5DpiLzGo+ySOmE6XqfdA?=
 =?us-ascii?Q?KykqNVUWCqdMsA2pnW5PyAbNTGQApKfD2B4AXsOFmHZKy3MflHV9vb7bDBxm?=
 =?us-ascii?Q?tMNkPsDy5L6boctugMWJzg0eR8TFUkchwr7sNQYyp2tjHSFvT2tmJr1lgK7n?=
 =?us-ascii?Q?WkNgikmd4xDQM1khxnOX2I8e+d8/jlmUTK6eAjcwyMJR3sFtTmNczSgkXvmM?=
 =?us-ascii?Q?NPS1nLgSmzmQ7ABOKWxd+iZPrff8FywHG8A4qV+rnUMvPh3X3xQVjqwvMZ2L?=
 =?us-ascii?Q?bSrTSXybg9/EJzs1IhYLngO/ztW61y/pl8QOezDOnefpaejgDdctJEMfnW/U?=
 =?us-ascii?Q?vGakfobqLBWiSonnQw9FUOn3H95XsZ4JSf9LjnPFo1NOVt21DRO0CsfNvM/o?=
 =?us-ascii?Q?SHyAJLYyrZgti+OLe4Ztsz4aOJdsoSjJOuROzsCUxtXK9VC9F1+tjlaCdZk1?=
 =?us-ascii?Q?0AAO4UDXKS8CGUdQltyjGNNLeOe7rxef2vSN6fOomqzOurckQnXBgvuCbIwZ?=
 =?us-ascii?Q?NVkNEg1wUHSJVq3w9ga5QF8rPdMbirHVlJ6OZJ9URk5SnDEMgNfMWySFsoW7?=
 =?us-ascii?Q?yBe0cfaR5MtaDZMwIl1Z4yD9oretjzTqBz4h91CamncaOlTlrlMRQoHz7htc?=
 =?us-ascii?Q?8ubF3kkQ48xDjXEmJnT+jP9HJ3tz6uOi5B5wCR1/pvvTmZLLLIE3ciCDoxlq?=
 =?us-ascii?Q?xPrpex8RmGLuTXv8IhH3nhjEe5QfXTWcf0CGd17JWyLxDok/jCFv?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 516de739-0bd7-455d-8de6-08da324a108a
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2022 05:58:11.4381
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wSXEPra/14JV/5dkAT5nT7eHMvrp8Irl+Q+erowlWaKg0mFTgfmmVFaxitxWiKofzX0jSbxylpbr1Jn/Q5DUIg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6383
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mark Bloch <mbloch@nvidia.com>

Downstream patches will add support for lag over 4 ports.
In that mode we will only use hash as the uplink selection method.
Using hash instead of queue affinity (before this patch) offers key
advantages like:

- Align ports selection method with the method used by the bond device

- Better packets distribution where a single queue can transmit from
  multiple ports (with queue affinity a queue is bound to a single port
  regardless of the packet being sent).

- In case of failover we traffic is split between multiple ports and not
  a single one like in queue affinity.

Going forward it was decided that queue affinity will be deprecated
as using hash provides a better user experience which means on 4 ports
HCAs hash will always be used.

Future work will add hash support for 2 ports HCAs as well.

Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Maor Gottlieb <maorg@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/lag/lag.c | 45 +++++++++++++++----
 1 file changed, 36 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
index 4678b50b7e18..4f6867eba5fb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
@@ -310,17 +310,41 @@ void mlx5_modify_lag(struct mlx5_lag *ldev,
 		mlx5_lag_drop_rule_setup(ldev, tracker);
 }
 
-static void mlx5_lag_set_port_sel_mode(struct mlx5_lag *ldev,
-				       struct lag_tracker *tracker, u8 *flags)
+#define MLX5_LAG_ROCE_HASH_PORTS_SUPPORTED 4
+static int mlx5_lag_set_port_sel_mode_roce(struct mlx5_lag *ldev,
+					   struct lag_tracker *tracker, u8 *flags)
 {
-	bool roce_lag = !!(*flags & MLX5_LAG_FLAG_ROCE);
 	struct lag_func *dev0 = &ldev->pf[MLX5_LAG_P1];
 
-	if (roce_lag ||
-	    !MLX5_CAP_PORT_SELECTION(dev0->dev, port_select_flow_table) ||
-	    tracker->tx_type != NETDEV_LAG_TX_TYPE_HASH)
-		return;
-	*flags |= MLX5_LAG_FLAG_HASH_BASED;
+	if (ldev->ports == MLX5_LAG_ROCE_HASH_PORTS_SUPPORTED) {
+		/* Four ports are support only in hash mode */
+		if (!MLX5_CAP_PORT_SELECTION(dev0->dev, port_select_flow_table))
+			return -EINVAL;
+		*flags |= MLX5_LAG_FLAG_HASH_BASED;
+	}
+
+	return 0;
+}
+
+static int mlx5_lag_set_port_sel_mode_offloads(struct mlx5_lag *ldev,
+					       struct lag_tracker *tracker, u8 *flags)
+{
+	struct lag_func *dev0 = &ldev->pf[MLX5_LAG_P1];
+
+	if (MLX5_CAP_PORT_SELECTION(dev0->dev, port_select_flow_table) &&
+	    tracker->tx_type == NETDEV_LAG_TX_TYPE_HASH)
+		*flags |= MLX5_LAG_FLAG_HASH_BASED;
+	return 0;
+}
+
+static int mlx5_lag_set_port_sel_mode(struct mlx5_lag *ldev,
+				      struct lag_tracker *tracker, u8 *flags)
+{
+	bool roce_lag = !!(*flags & MLX5_LAG_FLAG_ROCE);
+
+	if (roce_lag)
+		return mlx5_lag_set_port_sel_mode_roce(ldev, tracker, flags);
+	return mlx5_lag_set_port_sel_mode_offloads(ldev, tracker, flags);
 }
 
 static char *get_str_port_sel_mode(u8 flags)
@@ -382,7 +406,10 @@ int mlx5_activate_lag(struct mlx5_lag *ldev,
 
 	mlx5_infer_tx_affinity_mapping(tracker, &ldev->v2p_map[MLX5_LAG_P1],
 				       &ldev->v2p_map[MLX5_LAG_P2]);
-	mlx5_lag_set_port_sel_mode(ldev, tracker, &flags);
+	err = mlx5_lag_set_port_sel_mode(ldev, tracker, &flags);
+	if (err)
+		return err;
+
 	if (flags & MLX5_LAG_FLAG_HASH_BASED) {
 		err = mlx5_lag_port_sel_create(ldev, tracker->hash_type,
 					       ldev->v2p_map[MLX5_LAG_P1],
-- 
2.35.1

