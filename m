Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 165AD5509A2
	for <lists+netdev@lfdr.de>; Sun, 19 Jun 2022 12:30:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232954AbiFSKaL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jun 2022 06:30:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232782AbiFSKaJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jun 2022 06:30:09 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2088.outbound.protection.outlook.com [40.107.237.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67AC6CE23
        for <netdev@vger.kernel.org>; Sun, 19 Jun 2022 03:30:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cPhdKHua3+tW57EEvdlM/lxfA8PWT5xAQ3wdRFeL4zLtGzrMlfZyweybNrRntzLGV4zM2vJLZPPKwSDg9UTpCzwlDhDoJ3FvOyTs6iW/VlOTHURdHnfE6AhJt/igmpjTq7SFnTX32ZJsgHVadiYQJLK5CJVF+grd2vPMlA2+j6W5kykJS1fuo748PEpmXy4lk9/SF55AxikvgwGI0hjenRn2hdRmtcXfkQ1Qu0yY3Jhgk7zKL0BTSuWTfm6MmXF435wVINPHGLgs6peuWbO2rpq3uZlXBcgFjNqfOhXMOXlguvBnPLOhB1SObQEg8e04r+Ds5AYnlhYyuw0wo+i8FA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0fIn89F1NOoO/Cq5M9EELupScD8N3rWzhEtQJWXf8tM=;
 b=G8IGiLkoR5D9nyk5or3HfKjsg2m93UoCaiVafiJdNwoAl6htax/CD58jHDTOV3rtBbjQzbBcG58qOa5sxkoLBMIvcxjc4iEEaa8AsCuPGWLdLScIARA7+bMkVAv8Rz4dsTVpi8oZ+VLeEu5bxBMYXW2nP3a8DSSZLS2sQ8v9HhqO3gBljHeZ9JMfO+0LlsWx1Qhb0OL2f5mqxJX5X/gwCmGoQ0GcqCn1Ghg2TAV5qkwIF9EhdrCSC36yQ22Mu9QZz1ZMC1w861RzYfOAHXUL3REK0w8s4dqJOcqj0iZnXx4s9kegSL0EQV24qPLAG1W6HXgZ6YvfzHvKQ064jM71vA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0fIn89F1NOoO/Cq5M9EELupScD8N3rWzhEtQJWXf8tM=;
 b=TCFX+96A5e0FNAeNV8YHOCTmCGI/pQepM30z4Ud+kSf3WNI2Y8rsGmuqtdZ0cROqyYErreVQoS0MgGqvbcBYrXZpTz/97NtsK26rvKlY9mwBw+ae7MbfHOH3NYO6BH3TAbZ9qVGyhx2ofF3TPzQ+ya6DWCG+sYmLdlxQgsqdfNPGchoTXpu4iIKFpm6uo9QgDnmAp68VNqCh4ow1qPtIhdeAwY31XoDSlBhnE72qaqT+wyY95jp/NjHfTMvncZ6cdHLdnlsatqbNS8N3a3cfkJtem6NZmwpUbRUYJzizXuMzQd9hY4RIid/iF1hV08Wo58jvKo+qVckIUb3oS9VRWA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by DM5PR12MB1193.namprd12.prod.outlook.com (2603:10b6:3:70::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5353.16; Sun, 19 Jun 2022 10:30:06 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::9157:69c9:ea8f:8190]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::9157:69c9:ea8f:8190%9]) with mapi id 15.20.5353.014; Sun, 19 Jun 2022
 10:30:06 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, amcohen@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 02/13] mlxsw: reg: Add ingress RIF related fields to SFMR register
Date:   Sun, 19 Jun 2022 13:29:10 +0300
Message-Id: <20220619102921.33158-3-idosch@nvidia.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220619102921.33158-1-idosch@nvidia.com>
References: <20220619102921.33158-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MR2P264CA0013.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:500:1::25) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 15437e46-823c-4548-650a-08da51dead9e
X-MS-TrafficTypeDiagnostic: DM5PR12MB1193:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB11931B540A471BF566BAEF35B2B19@DM5PR12MB1193.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qCHJjfKO1M43MexJZ8RrY/u2DHOxQRqTJNpFn/Et5MTVR4uXqHyGfiiO8q/56afbFecjirX7wBCDXxVWMJgO9yblbKla1uNjkSmpC6ZaBKPlEDusv1LiM+ce6I0Hop/67uYhD4vuD/ZSSGEXD/sWm2OOEI5UP/p3OzVkf7wC5QrNu+rSZnh3WPxNWavV9Jd8APItt5Fhy6GKSwnkX9W7HZNW3Pi5e7p92zUhyvDLPoGHNF7qzoZD0g9YiLFfMVclmbByinskPFlZuB0r2dB1pSf5tj5b2deT5Cgksb46W6T1rorHlFT5Q+IF7X9t+8kEwk7OWzGTllruf5+KMoCAENLNAzi2J7Rwi/AsTo95lP7lhbI+aKf/NwoSkZQ5BeqeB1LmCiaNbI37nNyGaK4wVxFkS48Qij07KJRkgVuK2Zpy9uc+j/Z867qoMpyYLJAjtB++A7tq2y3aJL9WsSWeJorvyaAphXJUe95ciHWnI3vV4qkCS5v8wLcySq3iKwGjWDun1pYKDBZ8gE8ai9xOmVG7DEIy7gq7OD8R/CZikiCgvulZC67NvWx318XnQNikJ8vPS3N03+Rux7qgTz1LGFDjRBOCDl+OpDWlXcLRKXArFWXMOZOya38PSMzokAvcGDLcMa0baegAdn4yiLgIug==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(83380400001)(36756003)(26005)(66574015)(107886003)(2906002)(1076003)(186003)(2616005)(4326008)(8676002)(6506007)(6666004)(66556008)(86362001)(66946007)(8936002)(66476007)(5660300002)(6916009)(6512007)(38100700002)(6486002)(498600001)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1Rms4cRdTG9bfo0cA/YLo4ypAYdRTTSHRChMCGGno4HTjcs6qS6kJECWIxs8?=
 =?us-ascii?Q?wmcvMTIf/b5e8tJQjWdmaLq7YWPj/TuAD/hTBJwQwArQBItfV2KU4d8HEj83?=
 =?us-ascii?Q?U4uAbsm9rXWD7H4s3EgraTmbgAQt4pAqKXVtKwvaFtvqWJ0EBL2EAMlliKNd?=
 =?us-ascii?Q?3J0xvQGIirWFdtGFqfb3/MYlwHZQl1s7GzjYkxWlCzNh3vv6MfB3m0WaWzVK?=
 =?us-ascii?Q?Q/h/1hGeBxiMW+L3ksBH52yBUmW+jYmJoBmvVqlEupJaTwn3/VmV6Ek0BB5c?=
 =?us-ascii?Q?iEBClBnRF+7DusSfmLFMUdW/PBud5tqWkNTFdVWu0nHYyxAOfVMTNTK4iDUz?=
 =?us-ascii?Q?PXNAWtP9t67z5pGy7DRKSnt1CNvu0drBJD94hf/lo9Eri6K4jTKOvic/oqd+?=
 =?us-ascii?Q?onXReeUwL8z8ivJKByipbdgSC2RDpbpaYYDeVBh49bjMPTi/fTZ/otEdHsPT?=
 =?us-ascii?Q?6Jqd815mUpo3Ge/h3xLnRCijpFqfAzn7K2ds2X0vPBBrm8Yiq7wzabWO7YlU?=
 =?us-ascii?Q?OyzaoSrLrvByp8tL8/pmNaqD2jSvirk2r67nVEPJaJfVxOTkWYNCTFN/nD6M?=
 =?us-ascii?Q?104AnblKgT+j/Tv9o6fUusdY2CbTYraYOnSAvfnDCmaa1kMmOm8mDD9h1jak?=
 =?us-ascii?Q?cJ3IwU+e01vkIZmvZeC08fUcYHV5Pq6DcJGm3gUifywD1ZGl8O4k37q7CaAz?=
 =?us-ascii?Q?JVx+k6J/otNZ61Cm0gWi1ZeAZTvEgHX3N0dgSJTah83YZRwDb3uQGqqlNs1/?=
 =?us-ascii?Q?d9dWolYmw4oRkLzXzGnmK9JSUO5rAo5YtnkYsPmWHqAvAPGxiDzZA5DPfJiG?=
 =?us-ascii?Q?sfMUcQ9SUkn4/5RcYwGxexFKiOK93Rur1N5osCw8C59AlCr5YiEPbyyZK1OZ?=
 =?us-ascii?Q?Ls/Q5g6SSgZAEjJFNEOmcn1NMlR9qoUun1B3EixEkPO4LiEo95ogyhulLd7s?=
 =?us-ascii?Q?5zuDtLvszd6FpfHyePJ1EuQ3I6FnIjFuwpCYBfWr/EHSumunlT40PGrjvWL+?=
 =?us-ascii?Q?cF1/vPFNHQcPV9tgIMdlic51oc2mOVr3cQ1AFlAflzehSpczC6sozN5+VTON?=
 =?us-ascii?Q?j+rzfKMJN2m+guCjrUy8ijhKScwa8VszlW+EYQa3fCBZfNk4G4T7hIQOuVBG?=
 =?us-ascii?Q?Im0sfrWZgxIdCVLVzduLWgQIEvW9WUcSRxesTWn/JdltpUQnxfso+uqC1k+Y?=
 =?us-ascii?Q?k6tT+6MHEshQFY2kdkesvvMMTUFZCg3ML+LUC7gKbTs87zRzScXfiONZnYNz?=
 =?us-ascii?Q?G6X1iXuN6D9ybjvqTqW5HX/PxomhVSsMMivUXzZUMceg+ryzcqsRpz9JkiR7?=
 =?us-ascii?Q?ee0O0sZ1W5TfWXf+pNVwzsExfQ20hNjrE3V79QIoyV94y6KquIfayBuuIjbw?=
 =?us-ascii?Q?v5Cw50IWMyJ77X8HxlhuVizGVgkGV+qLkCkFHxTRzzEUmiIdavPZ6PG9f4LQ?=
 =?us-ascii?Q?FFHQf6/kzg8bHGqgfeKu7kqKxj93NT90ZU8ZEUBDsMAkKnF+Ym0lCFco+Wq/?=
 =?us-ascii?Q?kxnoV/YJWsRiZDlq11RLGCSNTHT2e0Zipp00uL1c03EXOmQRCjDl9gfa97L4?=
 =?us-ascii?Q?uEO1QlClaXoVmrRZ8SvAZM9EAUBadqxqIVYXZDv9Vak/S8wPAjfLrC0tmnl6?=
 =?us-ascii?Q?nsNLvYL92A2m4yKmnPCw6uI621I8BSF2kmULje6yK5Y1wxRFx3SK8Z8TbktB?=
 =?us-ascii?Q?nArRSgH6C8B7/Yobn4ruNszt8SwoERmAher8jfnuq0NCDQTv7e6U3CdWgknN?=
 =?us-ascii?Q?toR268AoTw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15437e46-823c-4548-650a-08da51dead9e
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2022 10:30:06.4868
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PfFoLgr/tbHuoWnsxa67FXZIRjvzTgc/LhPPwLMBWUa9tUr6k5/nn51lWIeheLEa+vyA92h09LSj8eQiJj3nzg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1193
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

SFMR register creates and configures FIDs. As preparation for unified
bridge model, add some required fields for future use.

On ingress, after ingress ACL, a packet needs to be classified to a FID.
The key for this lookup can be one of:
1. VID. When port is not in virtual mode.
2. {RQ, VID}. When port is in virtual mode.
3. FID. When FID was set by ingress ACL.
   For example, via VR_AND_FID_ACTION.

Since RITR no longer performs ingress configuration, the ingress RIF for
the last entry type needs to be set via new fields in SFMR - 'irif_v'
and 'irif'.

Add the two mentioned fields for future use.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index 18b9fbf11d71..26495b29e632 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -1818,6 +1818,26 @@ MLXSW_ITEM32(reg, sfmr, vv, 0x10, 31, 1);
  */
 MLXSW_ITEM32(reg, sfmr, vni, 0x10, 0, 24);
 
+/* reg_sfmr_irif_v
+ * Ingress RIF valid.
+ * 0 - Ingress RIF is not valid, no ingress RIF assigned.
+ * 1 - Ingress RIF valid.
+ * Must not be set for a non valid RIF.
+ * Access: RW
+ *
+ * Note: Reserved when legacy bridge model is used.
+ */
+MLXSW_ITEM32(reg, sfmr, irif_v, 0x14, 24, 1);
+
+/* reg_sfmr_irif
+ * Ingress RIF (Router Interface).
+ * Range is 0..cap_max_router_interfaces-1.
+ * Access: RW
+ *
+ * Note: Reserved when legacy bridge model is used and when irif_v=0.
+ */
+MLXSW_ITEM32(reg, sfmr, irif, 0x14, 0, 16);
+
 static inline void mlxsw_reg_sfmr_pack(char *payload,
 				       enum mlxsw_reg_sfmr_op op, u16 fid,
 				       u16 fid_offset)
-- 
2.36.1

