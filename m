Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70A2C5509AA
	for <lists+netdev@lfdr.de>; Sun, 19 Jun 2022 12:31:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234150AbiFSKa4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jun 2022 06:30:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233922AbiFSKaw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jun 2022 06:30:52 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2046.outbound.protection.outlook.com [40.107.237.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E178FD3B
        for <netdev@vger.kernel.org>; Sun, 19 Jun 2022 03:30:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l8T1QevxBGYsSciBWBaimGVH6Yiv1MQq1LPADCYmrj7AaVvgenM4iU86hqfAJ1uy01l1AbFhOmOvg1a1KJeVnmxaX/ntSZvlwnrg8CGYPnyhbHXwvaRt0N02iifj+9lFkgocv/oq2XqxQQaH32Infii9FFonCIh9P2DtxIv55gyTG+8ZM00X4WosX7EgdZbdMkWzQ/VN957z3n0lByJrUz4skYRGLl9n5wuuZO3ERAvACaqmQG7BPj4/VpqFkY3NshM8ptxFMPvJXgSrvYLMh96Z1Z+nUVS9mdCyZUhx/jkTBLxkgAKPuP+T5IkZZdvtSBHzo0PFq9t7Iik7BpBk1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6fW5zhy8neLg/GTAQ7zJLR5VTpKgmIaFDoz8d88VMIM=;
 b=TpfcG/PGKEsIjHEdavfDO3l3wk85IaFQzH+LWnExPzO+Qr9DX65CkswSXElkINFjxfNfF37ICa2+/CaITWXEMCrmZ6w/Msqo74JrARU+Gml8G9YK4gGF/Q6hCc2Edrk90UQtbGySV8G0DfN4c6R6+b6i58Md1XL2Av3r74w6ZCpWjRrXPskAm2J51rlR7CqqILS/0xpqMIo3atnsbKbahkWjxPKjDVKQle3l1tBVT4mkNflfy+wUJlkur3XVsTVGNM2ruvGWCKc9AplFJVatGpQpUDPvsrTrnQ67bKm2L5norM3LIQrJS1UqaWr6IoEAkk70RmE3t9LA0dndgkFMJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6fW5zhy8neLg/GTAQ7zJLR5VTpKgmIaFDoz8d88VMIM=;
 b=MTggjKql9O2/dAKOm6lWtE337VjL2rhyK1fbHPfUqsOW7t25THvPupog4TG19kmplUbQsS70uYc43LgYno/xuSkKzo97OEZsFKAhavPWi21ATjHQYqgZeH7LXcf9NyDkL+K4XoZEBuJ7R/tKjdV55TvyWVm1EsgOZLLy1mv2JFrzMMnF1CsKD7+9XM4b10kNmwffUXFVqQgGr7pX6Ndx8vOAteMnNWkBmWwhJ9AFRMD2aGK2mFgHRX2Gfq8q+iZkn3kt0pb31amXzakI3YAhuiJFC9oKf/Ag6n9gaD7effpZ13HDsjMy2T2lDs7nYdSlbLsuyl8aJr9Yqo3LMbtCaw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by DM5PR12MB1193.namprd12.prod.outlook.com (2603:10b6:3:70::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5353.16; Sun, 19 Jun 2022 10:30:46 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::9157:69c9:ea8f:8190]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::9157:69c9:ea8f:8190%9]) with mapi id 15.20.5353.014; Sun, 19 Jun 2022
 10:30:46 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, amcohen@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 09/13] mlxsw: reg: Replace MID related fields in SFGC register
Date:   Sun, 19 Jun 2022 13:29:17 +0300
Message-Id: <20220619102921.33158-10-idosch@nvidia.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220619102921.33158-1-idosch@nvidia.com>
References: <20220619102921.33158-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MR2P264CA0016.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:500:1::28) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bf7efc1b-047b-48e4-ee04-08da51dec59d
X-MS-TrafficTypeDiagnostic: DM5PR12MB1193:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB1193434E60A8490114B31ED4B2B19@DM5PR12MB1193.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4S1JC+lqHb67cLiz6oZXeYyUzxF3FP0xXYxhLzUOwnQH8GVK2G94Kd0W7bq3cF+S5/qAk5yY+jkP8OQeFrK2YJY/yqygstImITFAP6kjSaEgV3A4rH5RiuXYIdnoud+uMxqW+ntLFnp08CVFC0nxedVtWgottdxlqJBAA4lD3B8UUr4LBoCTf+EbSh5Bt9HpZfp+sTNYiv6oJIYrjmaTvEO7fdzMVA328W+n/SGlgPlolYRF6i8T8KroS0/mdVWcYfyL2PNgO7O1Vo/d18F18yhVkPAlA/2Eo5EQ1wwWBaSM6N8SSsZf1lbLLaKv3KTxvwX/RP71FoiIH8hHqPPd9K7TFDcitXCPhI+7YZZ3yfntc87x6lsDR+qFmBuIXHnQtlAvbES/4vCvJLX22H+oRaobeXHKyZSRXq2XIj4n1fRCAJCyV9LcXEu+ORLRgUsEhtpSdVvfX9i11h/hMDzzM5lEArYZRxQNo7M4X2DbKCjBZVi3hvMrchogd+TU09gM7O1Fm6blqU+JxbNZwCaUK7qR+jdEdWHRq+afQlAblX9RSAnDR8cz+eEeb8aXdGkRYzXyWPIldMZJQ4tNpvtkVO9NkQqTJIBxrsMWOvxPZpfmCfh31ieVj39M0hXWqZzh39y8moLWQhOxIfSetSgJ/Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(83380400001)(36756003)(26005)(107886003)(2906002)(1076003)(186003)(2616005)(4326008)(8676002)(6506007)(6666004)(66556008)(86362001)(66946007)(8936002)(66476007)(5660300002)(6916009)(6512007)(38100700002)(6486002)(498600001)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ek8fyIGHhTXVnxRq32hvirX9IHJL2YOMAAoX8hnjz0wdIdycjjnREEee6wgO?=
 =?us-ascii?Q?mMVglbco5wnGhJ3sATURmhChczYjhlmSSZfIBhoC8nfl8sfFleF408AlNrr9?=
 =?us-ascii?Q?A4boSt10divcERc7nn/w4APc/QGfHm4iSgQdu8o6s0oTAVabiECLH4r5lufn?=
 =?us-ascii?Q?T6TqwwkXJoS5z0R9wqMUm/BvcDs88ZBzhEKwWjMLsbKi2PNWNk71/+RbFvTr?=
 =?us-ascii?Q?Ns5Fm6YIUy9YCvXxYG87RIpCrt/3qCJRgygc+kmCFNHiNbVScXGXDxiy29lt?=
 =?us-ascii?Q?wTJkZdv+hBIsFGkTqLlR5lE6JjWEFGBLsNVMPokaCJ/R+5RsMJiBWG3vqbHY?=
 =?us-ascii?Q?1SYQGGv7nD3iqlk0uwLBoEB5QXY3sO74WSYYHuPD2CvCYqDw0cY6NEOudjux?=
 =?us-ascii?Q?FWsEv4UgvaIh9fVxuq13DoCyI/6xJQtUD2We/PctYqevzt/6fcDWxdQgGdra?=
 =?us-ascii?Q?h0/FaTEsbgOiVw1zBLOQx4565K1l29B2BoLjByNQGDXotQ7DKdegZmq2zkCW?=
 =?us-ascii?Q?e4f2+5HaOr81hfi+nMw4zQT2Ec+Eoq5b/jbr3jbq2KoTEuPKh/EBrF5E8XFm?=
 =?us-ascii?Q?YSfRYpxvFw2IKqb3n8hrd02LVd/zpnjT5QOGTZ/ebz4AXQbWz42NP4SdLLBC?=
 =?us-ascii?Q?vu83aCwVRNxnSItuleFwloJRxYnlyoTXH+zFgMpeqZtx3/Dh/Z1f/IhTH/dk?=
 =?us-ascii?Q?X9EX80lexiHJBAkPijaktZWQYXcwDQ6eAKWaxOYi8RFH31CMQ7fe7Ul731L6?=
 =?us-ascii?Q?kcCW9XIqCBpunJQKECt26RLzKHyUfb2+ICXccM2cOrKZQJZ+l+kRnnOK4xvx?=
 =?us-ascii?Q?zYHU9Ur+VmAcyTD9iXEEk//WYu6MmolLGgSGTJ+QTguVDXd0sdY0vSY30e+Z?=
 =?us-ascii?Q?tcTiuhR541kojDV5leICfNBn5DVYXVWBUqxnPwInLjMLjAEkALuz1ir6rWtY?=
 =?us-ascii?Q?4PVfdfqjSntFNUKirhTaQjHl0aOfJ3z68i2vabF67Kdm+6vPsTyQ8LZWirXW?=
 =?us-ascii?Q?y1yn5kpxqVaSsuxQghS6p6WjYJFpb5UX7sTLEItFxPayr+Ot7NOmfaJ3kmlv?=
 =?us-ascii?Q?ekAYlV9kXqxpd3MpTvZ8kmd4/GE5B6nKByvjbfQB3HWobTB2BX81v+KrOkTc?=
 =?us-ascii?Q?ndgxmmHqQQj5I2hw+X6LFNY1n7R51Mjfy0hLJQ8/RLeola2nWtHfcKEDf4QH?=
 =?us-ascii?Q?pDmnB4aRk169Cp9QDLA7Q6npd3x+xQ5G68DKuCsmJ/mtvNQ669hE01AeL9nI?=
 =?us-ascii?Q?JsHdKQsM+AO7Ps5uRJWgW7VhT3YD1OfJT6KH1vLGKQyA4Ge9yhOuTFnyM/ZL?=
 =?us-ascii?Q?rwpTnecsGB+mAoB5/xrXUodih0Mfqh9jYtj5ga1WNn1Sdgjb0Z2EBSTPv9zy?=
 =?us-ascii?Q?iNJNKN8UJi3mQ/LmGSdC2V+mg6hv0EJDCnS1nIyQIGaBLs1t8jwvJ7WwcJdE?=
 =?us-ascii?Q?b0mbI8eHLVGCgjoXtrOUuGegrnGAARq/XJMMVGt34DWBaPqiAYmmLN/gwiil?=
 =?us-ascii?Q?4Tj9RRSHZRyMlYbXmAYbo9yVECDP4Qa28wSvO8hsAbTIpi0PaeXISwOTlopo?=
 =?us-ascii?Q?QykGMS2qDIAgl5CR3cz88wmVAfED4UdIpHa6YmFo1vl3Cta7dnTS0uenjzQ5?=
 =?us-ascii?Q?296pzZ3PKWWz9IvUxwigD6s2XJXnel8MGHTI1GkN75v31YVUmiovb+UsRZT1?=
 =?us-ascii?Q?xes3/9hXMC20y7OnZEpkHQxQJpIIB+9XADWXDkdj0Do0i1+G4rgMJ4xWHMj6?=
 =?us-ascii?Q?qS/OXYJ6MQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bf7efc1b-047b-48e4-ee04-08da51dec59d
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2022 10:30:46.7490
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mFxR8UK9C5CCDUhS5sYuZBvH5FrmjXHk73IzaCSyUrh5jzIZs6AIlU5g+XI9792kqsbPOR7vHukIuakXv93O7w==
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

SFGC register maps {packet type, bridge type} -> {MID base, table type}.
As preparation for unified bridge model, remove 'mid' field and add
'mid_base' field.

The MID index (index to PGT table which maps MID to local port list and
SMPE index) is a result of 'mid_base' + 'fid_offset'. Using the legacy
bridge model, firmware configures 'mid_base'. However, using the new model,
software is responsible to configure it via SFGC register.

The 'mid_base' is configured per {packet type, bridge type}, for
example, for {Unicast, .1Q}, {Broadcast, .1D}.

Add the field 'mid_base' to SFGC register and increase the length of the
register accordingly.

Remove the field 'mid' as currently it is ignored by the device, its use
is an old leftover.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/port.h |  2 --
 drivers/net/ethernet/mellanox/mlxsw/reg.h  | 17 +++++++++--------
 2 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/port.h b/drivers/net/ethernet/mellanox/mlxsw/port.h
index 741fd2989d12..ac4d4ea51597 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/port.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/port.h
@@ -15,8 +15,6 @@
 #define MLXSW_PORT_SWID_TYPE_IB		1
 #define MLXSW_PORT_SWID_TYPE_ETH	2
 
-#define MLXSW_PORT_MID			0xd000
-
 #define MLXSW_PORT_MAX_IB_PHY_PORTS	36
 #define MLXSW_PORT_MAX_IB_PORTS		(MLXSW_PORT_MAX_IB_PHY_PORTS + 1)
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index c32c433c2f93..160a724c9a6a 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -1032,7 +1032,7 @@ static inline void mlxsw_reg_spaft_pack(char *payload, u16 local_port,
  * to packet types used for flooding.
  */
 #define MLXSW_REG_SFGC_ID 0x2011
-#define MLXSW_REG_SFGC_LEN 0x10
+#define MLXSW_REG_SFGC_LEN 0x14
 
 MLXSW_REG_DEFINE(sfgc, MLXSW_REG_SFGC_ID, MLXSW_REG_SFGC_LEN);
 
@@ -1089,12 +1089,6 @@ MLXSW_ITEM32(reg, sfgc, table_type, 0x04, 16, 3);
  */
 MLXSW_ITEM32(reg, sfgc, flood_table, 0x04, 0, 6);
 
-/* reg_sfgc_mid
- * The multicast ID for the swid. Not supported for Spectrum
- * Access: RW
- */
-MLXSW_ITEM32(reg, sfgc, mid, 0x08, 0, 16);
-
 /* reg_sfgc_counter_set_type
  * Counter Set Type for flow counters.
  * Access: RW
@@ -1107,6 +1101,14 @@ MLXSW_ITEM32(reg, sfgc, counter_set_type, 0x0C, 24, 8);
  */
 MLXSW_ITEM32(reg, sfgc, counter_index, 0x0C, 0, 24);
 
+/* reg_sfgc_mid_base
+ * MID Base.
+ * Access: RW
+ *
+ * Note: Reserved when legacy bridge model is used.
+ */
+MLXSW_ITEM32(reg, sfgc, mid_base, 0x10, 0, 16);
+
 static inline void
 mlxsw_reg_sfgc_pack(char *payload, enum mlxsw_reg_sfgc_type type,
 		    enum mlxsw_reg_sfgc_bridge_type bridge_type,
@@ -1118,7 +1120,6 @@ mlxsw_reg_sfgc_pack(char *payload, enum mlxsw_reg_sfgc_type type,
 	mlxsw_reg_sfgc_bridge_type_set(payload, bridge_type);
 	mlxsw_reg_sfgc_table_type_set(payload, table_type);
 	mlxsw_reg_sfgc_flood_table_set(payload, flood_table);
-	mlxsw_reg_sfgc_mid_set(payload, MLXSW_PORT_MID);
 }
 
 /* SFDF - Switch Filtering DB Flush
-- 
2.36.1

