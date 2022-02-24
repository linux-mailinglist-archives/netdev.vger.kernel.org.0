Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B9754C2D36
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 14:35:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235061AbiBXNff (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 08:35:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234967AbiBXNfe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 08:35:34 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2056.outbound.protection.outlook.com [40.107.243.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB975178699
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 05:35:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DhZM8czDcc2+lTbZgzVkY5z2jTFi17+LkxomEqRwzORalfX3rj1k33ItdteXJcaRmPO+2GKxB235YRyS6HmyskvWAycKwnw4lE+HoPoKEXfVcTSmKwwjJX2GrJt/f4C/9EcgnYD4jfgtmOQgRY0t0JxMx/txf7B7GspPiz9sHCcg6S0fLl21nOsOycePojUeIKSfojn86y1A5cVEZ7p7muF2ESCcaNPuEkaw9+pRxrA5TEHqhdjhcc/m4X4MjiQMxk4SvwgbtdEwU46g0/dc1QjIYASLptmE1qOLi0QMCd6hES5jZ9JKqqVWqNp6BvvBkkpSg8ZsFd0b6wwLxAzqaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yJ5oktitWkDDvYvGVIfZD4g1vVPTE6/bC7VtpIdZvWY=;
 b=aAai960nXgOxG+8ZeujcBW1xAj4ZG0NBtblGx/xtWyPrPNmuLctrznzANYLRBJDMO0calxOgVjZvaxto45M1zD+Kg6IouPKB+l4HtMWnQ58s5yr+5YlneH79bRm41pp47bMTnmNS0/yXOv9ZHdhn6/8/LtcCAR6SnZKYuhfXN6O5I3Fvz5Luxjm5+MIiu7EbK6ztVVXxUIes1SzP6Ys7JglZBtlI2Ldvtd1fEEVSTt2uSlUyz/I84v+OzaOtLOigoXfOOKz4OQeikpujDnwXyBakPX3PCeoKB0y+FgWRFLnf+vAcMngUGgRjD/C7RCAvY45Iw/S3YtP/upcGiPfeWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yJ5oktitWkDDvYvGVIfZD4g1vVPTE6/bC7VtpIdZvWY=;
 b=ggxhnpTcC5ujyoad3nCZ5kOO+7qaR3VhLrLtGwxM0pV3Wb5FEnAvNCoY23Po/4aLcvBHLnSYQE2TN5t/N5eo5OMMVLUaBck7Wnm9mCZyIUAqltOJ35ij6nVfat9He9pcRcuLuKbMe/PiwSJP3OamVDJzCyHhuMVVg3lbMZSRkZQnEDbvr5GBsI5LWg852r2HGlQzBNMNf98QyQZ6fbGlggi81wbxtlAT+FQA2MmBE6MRJoUggAS/qj0CR/zytfZLCmYU2opP0n8wdl6qSaBe1/kXCBNecSARDvksU3Z0yq8vJ1loDM85vbV8ZOcly1xE9wK+9ySoPo+hnQg4yBDcyw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by DS7PR12MB6008.namprd12.prod.outlook.com (2603:10b6:8:7f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.24; Thu, 24 Feb
 2022 13:35:01 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::95a1:8c7f:10ef:2581]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::95a1:8c7f:10ef:2581%7]) with mapi id 15.20.5017.025; Thu, 24 Feb 2022
 13:35:01 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, petrm@nvidia.com,
        jiri@nvidia.com, razor@blackwall.org, roopa@nvidia.com,
        dsahern@gmail.com, andrew@lunn.ch, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 10/14] mlxsw: reg: Fix packing of router interface counters
Date:   Thu, 24 Feb 2022 15:33:31 +0200
Message-Id: <20220224133335.599529-11-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220224133335.599529-1-idosch@nvidia.com>
References: <20220224133335.599529-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P190CA0036.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:802:2b::49) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: df55d8d0-0f11-429a-2d62-08d9f79a7540
X-MS-TrafficTypeDiagnostic: DS7PR12MB6008:EE_
X-Microsoft-Antispam-PRVS: <DS7PR12MB60082B10AC2E01ED5FE4C2DCB23D9@DS7PR12MB6008.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /xWtHNjdm4Zfmja1yDboVwe3pFrIxE9sPg7rNmPhq75FJplW7ZoI9DDmCd/omR+NPUi1HLdHZAoBPzMyYCuxj5x/KSE0fcvEjOE1loXg3cWJQGAgZ2kpZ75wCTgDqnRSy1LUU0cRXlo5LiPNqLcBBIHZZD159ymRFG7o6uYq/CKa2xsZnW8AOPIWAaoKF01nwmjAIlcH49Uy3sNULzRU0u34sj+iUFRC30msRr10E/A3mg2xd5hu4VhTDxKGdM4qROo6GPZwlNlRLcUrbwyYUJfrhfYJ9aMk/TkqTqunnDASg5oreFS1uehDTeJ9lCgEhl3UoiPb2TtQeC1mcg8FEssXuUTJJXKvkQXMqNDz4bohKC4ErziVuhXy3llblRNTiLnUYEHRg6ME5S6FFdARejE0clUjDVlJoQJBf4RFrpHVd9M7kDut6JtTrgetV7sn0X55TnH9YCqF82MSZ5z0OSgcwlhOQ23aq5228EZ8KSdYZSjPKhK41blFOv1sWG21orbNeDS05MF8Seugv2JHiXSRYQUOyBsktyEYDqsbyu4lYIueoymZsVSiYfWSwQQtVtXYMHckM0oPiQwBp112zbRyHXHw0NwyLlwElx81I9o+oxOd6/d7a/j+o5psSSjkLLUpTjdKnUpMG+uYLdWs2A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(26005)(2616005)(66476007)(66946007)(316002)(38100700002)(186003)(6916009)(4326008)(8676002)(86362001)(66556008)(36756003)(6512007)(1076003)(107886003)(5660300002)(83380400001)(508600001)(66574015)(6666004)(2906002)(8936002)(6486002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GIk1UPHrYkg81p76QkcqlmCnrKjuKY+3Qa2vSQfJm8t1iCwGYQISDnLZHALJ?=
 =?us-ascii?Q?vEkQ78eCzZpr05mGIg0sZPVbXcjIzoT066ux2y0fxserDvzDT9/qc6m3KHBe?=
 =?us-ascii?Q?T44YakVaa/HC6KmBqq6QXdUBH88TcWVZ0UPc8qUcE/ekdVT9TqNlG55Pol8Z?=
 =?us-ascii?Q?TOA03I+YXlVczJqb6Uqd1oaNLTY0SgxMa01WCGlFf0zOeW1Z5iRiIeyvvp2F?=
 =?us-ascii?Q?HXx0YZziePNCcpMHZyVtDFdXNdTYmOS2FdtMRY7lZUJSyIiOoJ5R0/6NM4U8?=
 =?us-ascii?Q?a8foVMB8H8cT6AVVkOwvCIBAkCsIUWKcGX3/bZn/RzTtv7VwpsiydHGW9d85?=
 =?us-ascii?Q?j7tpbFqnl17JduY0KjDWMrkjAT+ROshNJF4rpyAGimZIExFW0twHrRGI4Jgx?=
 =?us-ascii?Q?wsBC1bNrGXXONSLVeGEoy0AZbba6bhu9g4G3RiM2b/UxG6DR5V1XEbeud+Gt?=
 =?us-ascii?Q?Z3c8CQxhCybCy74eQ9e2fXeCqchGYuiTy5/y9mHuBQNhDUY0/EdNKxagSr4k?=
 =?us-ascii?Q?UPSAIy3Bj12VHZqWwB18qnPEQP1/DHytrtrPGDXtzKkDsVB/mPXwf7X0hZq3?=
 =?us-ascii?Q?Z0WciE8ehhIGqZ/QRg/EtJd2+48L1xotfbwFLT87JUNHu+tzl1qEfsoLOL3t?=
 =?us-ascii?Q?8lhCp7kaI75X2AWkVtsMkYzMphKaVC2SyHy3h8oUnXYYDIPsJf5k6lFIGTwy?=
 =?us-ascii?Q?F4Gs4Llz2mabNwqajOkQa1A8CusmUkhNDwRV7mf8JDFvYtxnlTYW4u3+1M+J?=
 =?us-ascii?Q?m8nPlOMgiudvytO2s76P6T/lYFavto/gnwgbbhxni2xAQzJLLCR5sxWLT64c?=
 =?us-ascii?Q?lsCVRV4TOp7DuKLeRIyD6SttMw3k5ZXRpaEmilU/OU3c0J3m0fa/Jg4gTU/F?=
 =?us-ascii?Q?tny2yUyzYVb4a2KNCZYRVzufcMoITGy6dTkj9MhnLMaqNUvvjEYqsGEOxqyn?=
 =?us-ascii?Q?mzM8qzsKHxZsk/qJbKz7gZmaxAcfgpgS7sL+iXdJUdhKOsdhcUFyUv/BrTno?=
 =?us-ascii?Q?hvJhUrXfF0lgydDxIPt2bfGXuKZREcKXxd2k3YGxjW6uvj8ybh8Z5t3qhbCS?=
 =?us-ascii?Q?fHrxSA55f2N9AtUOrMSNdQV6tr1gHhVXfvhJbZYpZDf0QfsNwW2CRXs9WZi5?=
 =?us-ascii?Q?8ThATzi6HYtGz0Nr+P8trkA8XnilxIhWSB3lJggqhoddZ39wlw2RIqF5cuY7?=
 =?us-ascii?Q?1Jy2tJTEuWpABIBZXda3zxaZA0ds6E1sBHjgUJPSO1/si9aGjCowO/c0Ke4k?=
 =?us-ascii?Q?i34Zs7ZrIAoLKWajPMKax01I4XZATOpSgvFF383oB98u7nRQqieaZ15DMKHP?=
 =?us-ascii?Q?Hsg/OBHIiBUsCWL5V8bxdvVAlDIzT4GCsJxhibTFpPnDgGDVF8pafSor/6x8?=
 =?us-ascii?Q?Es4QAG6V1lXlipDbALUvpffmcLLjo5zkyM3rJWkgyuGadctZ2mTaMnjCJZXS?=
 =?us-ascii?Q?wGGKdgC8eR5O1sJoqVNBavOfSzvPFuUnMtoixcg0VWMgnqAVjI0eoqK6bMjB?=
 =?us-ascii?Q?xukiBIU/Kn1MX0XFSJbZGceUDJ4pOnbaLulieBKe8atxbcFoGy7mS7u8J9MN?=
 =?us-ascii?Q?tFkRn2V2S3buBgk91T+jD7Njuoitu1M+gDCe5paRYGhvx0bSeajToxfBiT9F?=
 =?us-ascii?Q?/Uy1cGFnjMT9YGQ0veX/E/A=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df55d8d0-0f11-429a-2d62-08d9f79a7540
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2022 13:35:01.4581
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2EuFKY9iD2WghioZEahEEbWgKjHvve1yxlk1qj2M+83LAExY/l95xArxwntR/C11wcDpLxfWYGWBf+mAiuN9Pw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6008
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

