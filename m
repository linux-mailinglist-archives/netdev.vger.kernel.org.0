Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BA384CAA4E
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 17:33:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230164AbiCBQeA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 11:34:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242730AbiCBQdp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 11:33:45 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2083.outbound.protection.outlook.com [40.107.236.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E52A4B877
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 08:33:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cFFasxMwhh43nDXGyNh6ia2jSeSpHGqPiN/vOZgbxlnn+/CMsA8mBCA4tXkzKnlwkyrx5wKnQGfbsUiD4DVixJxdoBP4eTg+bSWwEevpyGnsf29pBf9dCsJx3KTZhYr9EWMO/ymuP0QU2baE9VyN2Lmy/sqkUinX82+fvepkU0i4j/C3zKaBfUevyZ2AO94jf++rDC/hoJKRKY85DC3ovYnMqJ8B8tq4gWowgGodz8xZ0/LoYBZSw1JWrUKVBm4cPKjhU6RmfJLEV9ABbwBSfsg3qSFrB27kq/I4B4kCFyaTW8LR/CMhCttyPEzp2W+OeEM1auUg0UXvcqOwnR/M/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yJ5oktitWkDDvYvGVIfZD4g1vVPTE6/bC7VtpIdZvWY=;
 b=PxRq9LlokolFGtj1cDelOUOfqB9y9njQBVQYlPE3R5XciyLKiyvnjYpfMxyySIYrCkwT9mE8Qj34/4eb8S7I0Uv509hfs1Am0yeqrRa0MkndHvoPjH3l5OuYvRoQQrY6dez82FRnUe8gllHQnwuFkT4epfO0mkNRDDmlyvTAgaYrkvAypGpA4h59i/cnXbd/o6abwHOn4yaAJj3X0l9+LI2HLo/XnS3CtuedWZbC+qqKfpSNIWcEb3eo7NqTt1x38EM5hyJnxA4b+Z0oOEnFggmWzlG4CGqZREZpwywlUxZV+PWnLnIMF6bhZ/nNyrLPSNBGxkHwAPT2sg6kqx7nDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yJ5oktitWkDDvYvGVIfZD4g1vVPTE6/bC7VtpIdZvWY=;
 b=Yt/yqxMWXtQsGHvtyu0ck5DCKxtyi2HbEh2eZzbzuW/yupmnuEqKqJvW4jS7e1x+ntPYkQIhkDJlk1tlWfwpe3Phx1BMakxTuMj5wrxh7DSMCivYs6rSQ61XDCcab5pieSi1ho5mQLZht5BfeJEsg23jOy88d74AOUj4tMPnOwBOdU/6hgPXBkGhUBI4ry8LNXx/5z6At/ftlOBqM0Os2p64bKWbDB+ppaWI1ijS8hMveCAUJ+3LhgDvNskblvhc3QC0/HuBTKdc4/8tTXVUPNOMBQSKVUFRB9kKc2e7375F2BSssB8FoxazOf+D2WGqi6ziBONA7sSrUS5Xh9BWmA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by BYAPR12MB3208.namprd12.prod.outlook.com (2603:10b6:a03:13b::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.25; Wed, 2 Mar
 2022 16:32:58 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::95a1:8c7f:10ef:2581]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::95a1:8c7f:10ef:2581%6]) with mapi id 15.20.5038.014; Wed, 2 Mar 2022
 16:32:58 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, petrm@nvidia.com,
        jiri@nvidia.com, roopa@nvidia.com, razor@blackwall.org,
        dsahern@gmail.com, andrew@lunn.ch, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next v2 10/14] mlxsw: reg: Fix packing of router interface counters
Date:   Wed,  2 Mar 2022 18:31:24 +0200
Message-Id: <20220302163128.218798-11-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220302163128.218798-1-idosch@nvidia.com>
References: <20220302163128.218798-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P189CA0029.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:802:2a::42) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bbbab3a3-c04e-44da-138f-08d9fc6a4fb3
X-MS-TrafficTypeDiagnostic: BYAPR12MB3208:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB320891C0B064CB09AD4DDAD6B2039@BYAPR12MB3208.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5jUONqpac9/2wfYqRNsD91JonPr3IlI/yKQJUS5ucjq9NTbC7+CHPzahIUa01wTn/Xh2SpOzjs8W3sAfZrEvdUOnFLmrc/QtECnzCUyDxHPQa+29avz+scKDBg0NkU6RDBx1ZJwnp2plxmvV/z5Igrtn8y2DW87B2h6bAZ2YalNyplu94GvldIeuTwj+1pgkLFaLHF06k+fZnqjr/EkA1qOliv6ySfWuVpbdcJ69IuNoz9zo4We0PXOhETR9QmhJGu9D7/Y+FVUaFZymUE3/l3TTWXIT/E67n6AXa3m8LfKx28ijaCGLfPaaUD5SE43eG35Ei6wuQ/sbxxPZmphETiVcYCt19Lz50Kl972UxLRQRmusYs7VxJUWnxu+0k2ItJ6lTS+80nzihT31RO4cxddjrBtSSp7ceJIACnrFscT6L/NYM0S3pvvH/EQPKR7E10eEXucOYrI+5MWMHyzJW2qhZOKpF0bCDQL46OLduYpe1qs8aLuKQXxEXvXpho6i+kkefMGfQFS9woayAlOL1tij+eYz/eZBJdnzPgxNbvfAaXU7lFUAyZ8N0e0dEx+kqmOfHUWRqEKXYazU/Ol7uJkAKwn0M5eWaJfHolNIV7iEFDyLXArdHC8aWj9GrTHgHWf2nV+2qljXDmlXv6Kmpkg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8936002)(66574015)(6512007)(107886003)(4326008)(66946007)(66476007)(38100700002)(66556008)(2616005)(2906002)(86362001)(5660300002)(8676002)(26005)(83380400001)(186003)(6666004)(36756003)(6486002)(508600001)(316002)(6916009)(6506007)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/dfswdcCmJ6WhJoSCEGDsvglMVlyO8wywemVq3Sy2MW0yrtZ45S4+sApn7Pj?=
 =?us-ascii?Q?gRgPcy4QVcBYE+h1DzjYqDsw+BPVfz2Jj6YuiCS4vZA6nBxQnT5aGC7j0h63?=
 =?us-ascii?Q?JWriYa5CspmBiI6Egmg5ne/LDdO2Z6FFUcr9kSEN9HTW3WDoixa42u2s/QfC?=
 =?us-ascii?Q?NAdl/3RmCzHM/JDd/nn9R/vY/T4+xx4iUeq+fQ+T4wSyDxppEQ1OBQKThTbE?=
 =?us-ascii?Q?5S3n9GVdsgt9PTVw7yTrw0OfN4YbXUbQRyb9OTAGf0W0z3sUUOJ6pAxlmLu2?=
 =?us-ascii?Q?Ryqk4AEZCR7/BcMFdFto1e67HJ79xXp8Vb43qhJm+BkmhihrzAjM/K2ghh8P?=
 =?us-ascii?Q?ghTYuGotRrjwV8SOTKiPmaxGmCwiG9MxKWUbyLPQeReuKQnh28J8dvY5AUtG?=
 =?us-ascii?Q?BiS6RNvsOUGjSuG8BaLyjDqisFP1scuT1GsnGk0lqdBJBItRAc4N37X5hfTZ?=
 =?us-ascii?Q?Nk7M4V6Rq4+4snr8As6LSuD5Wz8dxnis5ZMdRIn6ppW8jtGAzg/Qh25C6rpQ?=
 =?us-ascii?Q?cWs0ofYZhJlPz2AgCDuh0RZPk4t4a7LNIGP0WqBO6MwYoDlGxugplOicMkdj?=
 =?us-ascii?Q?RSRUpztFBiont4Qmp4NwJb1BZDdfrfeyhVM3t2H3cCT77Je2VLS0EmfAa4eX?=
 =?us-ascii?Q?JR+DOcPdmgUjrJ7VFdJrsUYR7/D2uo3zOP3D1NhaBiY3wWmCxEmdpFo0p8QL?=
 =?us-ascii?Q?5Bqqi+2IJLH8f0E7dvRbo+h9XlE9C7HfzvYr4iEqqiwj7SsV4jh/PN8yhpXj?=
 =?us-ascii?Q?Qu06eQqcGgcdrnq/NGFe6BP3awcEUHMgijYvu/x/0hK74lobDkZypSNu2Rij?=
 =?us-ascii?Q?RCFPX0QUkH9DG3giyCTSjEJtLSm6rgmVkMOS98dlf5HOvXwgOqHYI9raboYk?=
 =?us-ascii?Q?eh1JxBxGiVD12nMtV9ToYATWs+tkvENqAXYmjpaNQa7HzGTP4zlEOJx3Z96g?=
 =?us-ascii?Q?fYPJzO4MPS3P9/u6xSOk2ehKMWNyqmDC2H7mJdYGEOHmhxH58k22Ho4uTQgV?=
 =?us-ascii?Q?YYdLRkolKZ+nczfu/w2603NYSQ70rJgR3jYwqTc3kJWP7PpTZ97Az1gmI6BY?=
 =?us-ascii?Q?2TvsywW2qNRYAVTYz5ghRPYK30sQAtb1BSBFgoB6VLH7g7u7OjfTXzGCTyxO?=
 =?us-ascii?Q?OnOKpGKmPkiWtLjr2knyRAnPjbu5A2yg3e8aIHYrmidv8sPekctPL9GZfCQF?=
 =?us-ascii?Q?tVYarNlcimmPHuAAf8571rCHF33WPUWypWEzpb5+T9LrKG77UvyGaIjM/DZv?=
 =?us-ascii?Q?B6X/qwuegeij53QGaI2J8a/1ny6EhK/dL2QCA8kS1TiLpX6Z6LZ/VOia9fwm?=
 =?us-ascii?Q?e35FMNHTlTJCJqbnMOUHYvO6Z6cVO2ZCCz9JCI+1dvjoM4a3CEKQA+5kf52M?=
 =?us-ascii?Q?5weVOgS+gS8oKyBsVlkNl6ngyQEHbV3O0LkAS344SQLzkxtjCSwhFrnIvZ2m?=
 =?us-ascii?Q?e00AK5DJloxPW3HZ+4tX6krVfRB1ALMCbsOVWywX85UTZLShTb4dTGVc58Er?=
 =?us-ascii?Q?WyVm24pzo2sMh2bBsxn2otejkuJWqeXBIsFjdBpOFb1mcMJSeedNDnywUitF?=
 =?us-ascii?Q?/1j470eKAPMbQHAz8Wwcjv3axa98yeo1+QNXN7dtXRhARe0cbb/4e+YWWYsS?=
 =?us-ascii?Q?3+uHgjsMA7rQG4H/cUwheL4=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bbbab3a3-c04e-44da-138f-08d9fc6a4fb3
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2022 16:32:58.6316
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B3cxnygTZw1J1TXPa0EVNUa7VlMAhQhFc1bpAd21oAIkRSmbB7uYuqR/r1VPSoBySjC1oURGraTk0+pe0YVOYQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3208
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@nvidia.com>

The function mlxsw_reg_ritr_counter_pack() formats a register to configure
a router interface (RIF) counter. The parameter `egress' determines whether
an ingress or egress counter is to be configured. RITR, the register in
question, has two sets of counter-related fields: one for ingress, one for
egress. When setting values of the fields, the function sets the proper
counter index field, but when setting the counter type, it always sets the
egress field. Thus configuration of ingress counters is broken, and in fact
an attempt to configure an ingress counter mangles a previously configured
egress counter.

This was never discovered, because there is currently no way to enable
ingress counters on a router interface, only the egress one.

Fix in an obvious way.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index dce21daaf330..67b1a2f8397f 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -6784,12 +6784,14 @@ static inline void mlxsw_reg_ritr_counter_pack(char *payload, u32 index,
 		set_type = MLXSW_REG_RITR_COUNTER_SET_TYPE_BASIC;
 	else
 		set_type = MLXSW_REG_RITR_COUNTER_SET_TYPE_NO_COUNT;
-	mlxsw_reg_ritr_egress_counter_set_type_set(payload, set_type);
 
-	if (egress)
+	if (egress) {
+		mlxsw_reg_ritr_egress_counter_set_type_set(payload, set_type);
 		mlxsw_reg_ritr_egress_counter_index_set(payload, index);
-	else
+	} else {
+		mlxsw_reg_ritr_ingress_counter_set_type_set(payload, set_type);
 		mlxsw_reg_ritr_ingress_counter_index_set(payload, index);
+	}
 }
 
 static inline void mlxsw_reg_ritr_rif_pack(char *payload, u16 rif)
-- 
2.33.1

