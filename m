Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43E034FBF89
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 16:48:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347462AbiDKOuF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 10:50:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347459AbiDKOuC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 10:50:02 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2074.outbound.protection.outlook.com [40.107.236.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 530B4220E6
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 07:47:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nYO7SNAGLLj7unFHgXivN+CwTLja31WAe6SlNyBk2xuDmoEDPq0Bs31fJAe8F/MpGRA4/B461aVmOSPD/irSCHAGwWb/nnaIyZ6FDriQLFeCNmOlQ7PxnUqOVgNGEaL203pCgPEwcsZDgO7sFIRrdEImIhQIjgJqs/gyBgFfxcxeYt+a5Mdowir3HBUw8q2dePUmVY/to6ga3aIpOknk1zGB0G4YXuNtXYL38t+jxUMKaUCf+ijLhmvs8oek6iCZxTRLju6zPg+OHGyu5YjljNdvWP8z1DHTZOb1vge6I2cVmzkEgEOuqblbsOQW/qX5ox+3z7JdQrektdmt0oLU4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XWoKgytLtDpVewQXf0z07Tjs2+kti+4QgFauImZQDwU=;
 b=ODrv5tEWWN9WZFVOjmKySndXitn75xceb88y8YdgqdUKvrEdIcy7gOw7gSlswWmLNV8orDB9YrrTc7zFWIZ8sV7688fPGKeGOinVmW/LseLs/zpOu7edXZhinQ7q3CJUE05A5a9Y/wLsjDQQoGkMVwHGsk0MwsMlnWt9gnnLdzEZ1N0aCUhybURanSaRc3aeHU5npQrOyPkjcuXWAtCNKm0ZRObjPPH/HLrXeeq45gqdM3gcaDL0bTy8FsLroSdrQrAVLwaLU0KUAMgLMrJhkPeQ7/ZmJQVGo0gB/CvMIZrLDa9k81AupZYcbXewY/j9PDdL+nYSkbrqfBm83xDPcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XWoKgytLtDpVewQXf0z07Tjs2+kti+4QgFauImZQDwU=;
 b=mbD8LFAIJDIPaqwY/phq6X1+AsxTkPELDqroDe5U2YB+KbYvzkV2ZxWnBz/tkVxrh1OLATFpgOzD1rI4TKMXuTKhD1lS60s9HbISpa7JqDzMMiN7irPgJQutF8fmfPT70iA26FABjSWAquS2NC8++JS4o+idQyV01S9zXCoXJEvDOHAysIqC1Uk3cG7IsS1t9niBqIV7Dqd9Mw86kRcVHTQauH5orejj0Qu58d2+QOmkAciH60zrKHQL/zpIFFDErjzsbuqcQC0N7NByfcA9zl4tE3alVfDS1LnNLyHLwYntDEZ3bDqsE15Iz8VCSHzF53ZRaGKv38ljYdcKrrOJMw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by CY4PR12MB1430.namprd12.prod.outlook.com (2603:10b6:903:3e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Mon, 11 Apr
 2022 14:47:46 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::6131:18cc:19ae:2402]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::6131:18cc:19ae:2402%5]) with mapi id 15.20.5144.029; Mon, 11 Apr 2022
 14:47:46 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        petrm@nvidia.com, jiri@nvidia.com, vadimp@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 3/8] mlxsw: reg: Extend MCIA register with new slot number field
Date:   Mon, 11 Apr 2022 17:46:52 +0300
Message-Id: <20220411144657.2655752-4-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220411144657.2655752-1-idosch@nvidia.com>
References: <20220411144657.2655752-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0474.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a8::11) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2d09f150-d5df-4781-8a05-08da1bca3dd8
X-MS-TrafficTypeDiagnostic: CY4PR12MB1430:EE_
X-Microsoft-Antispam-PRVS: <CY4PR12MB14306EE8F67E7CA642C0903CB2EA9@CY4PR12MB1430.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0fPDwNoJreqXx6QHoF2iNxkrmamzf7WNzFtpsUlTbttqGbBtKJMYoNnd4SXK1Gm09Pm9eD7R5MLYIHFGaFcTCZhE2pyFr+T56rJwz0SM1aqCRIAsNsJ1sv/KDlDKRY/0Yqqj4+6Oy0pO1F4ZTYcAUyCDtYLiiuqyACC5f2KfzDgSSYuxO3/EHt9ZOmyni6+/MKIH51+JzcPk6ZUGmr77IkbavmHm11qqkYKTOYiVXi87ny1x54j4K1grILNs2HeKrpVcCJqQKYVmxAWyTxGS/fRaACjPgdA24r1sRGivweiZYpCQyuF4LL4sxVvSCuwtGHpI14gjYf3dxNHu2NUNa75msHDRvMdarLTQbTsahnmfi1Z/ursq26NSJxVg0re4dA8LXJvtERfMh8laB71DB9lusq3atjVCQglvhj2qG6CLcbssZAax9eu0KrwKChMDIggzp+g6qAoOj/LUyPJvlbAke80QmTLrirsQ+lJvS8yHDVmeFWaqh4BcJEFL73P/2x2UHmrcnxu39y6WlARCAlusD21rsISbk6Fe2JUcQqEDcELMV+E0mJlJ3aHLELayKgCHdxMcyKMvlbCbfmIZtK/KXSWppmWellnqFjOHUEaIEWD+HkPH2PDKShdHRPkgX3uxU6u+Nsuvph7dvuJ4RQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(5660300002)(8936002)(66946007)(66556008)(6486002)(66476007)(107886003)(6512007)(2616005)(1076003)(186003)(26005)(6506007)(6666004)(36756003)(38100700002)(2906002)(83380400001)(86362001)(4326008)(8676002)(6916009)(316002)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OhreQ/tjr+Sr6jsDrpKIYJRs+NaCEToxKGZ/ppw4c2mDP8ZaDpdmbnEr+9pY?=
 =?us-ascii?Q?Y60p+y5vuZxK0feunxssfnbM9ljV8cUNEkJZD4N9oFvOwzSHjIvFuw5aVVxi?=
 =?us-ascii?Q?65y7GZWoJBklv3/zoszbNRJWya5xWQZrfatWS3xYvuonMjcPfBh4NZgyIauw?=
 =?us-ascii?Q?+yLdupBt0vBU+oLF9FYEZoShwr674wOb+mE1YyyWZNEGewuu54IE2y2ZoUSQ?=
 =?us-ascii?Q?KpYu4Bt7a/FTa3ckDehtJBqfaIZ0LvXV8/q9mW+2Ossc8qGgoewgzNpar1Ns?=
 =?us-ascii?Q?Y7/99ayqSX6JQ3ku1paBvi+xBwKjrepy5RSZyCPT842BEeaR1Go4sBmR1FzB?=
 =?us-ascii?Q?gKivksPQ+qYkU/aBxd8ISjaqgRbL6GGJZigX/+Wm5nEWNcBTuNWVcwCOqYlk?=
 =?us-ascii?Q?SuOLDK7VVUBiFLdxJUllhdRy12B6glAmjtYSmrlk/YWH8pf7BRiPadfBjE23?=
 =?us-ascii?Q?RJZcDD7E2mwJNEXYgpiF2n+3tzbdKhntRAN0a5gOlvzIZphvfzC2Xd3J22FE?=
 =?us-ascii?Q?FasvJ7xgXnEpp9di7lx2umw7bthQl5TzMFIpVPkFlJq/gqOXbtqTHIMPXWXu?=
 =?us-ascii?Q?adUwinIYx6JCnYLFonup0p6w+aXxoENYwkXHNNAQqW1+wcUlwKkdwrTAMUpA?=
 =?us-ascii?Q?ml/Z75mJKBNAsIhVfDV5PiNSMjaj71AeYXKuWwaDpsxriam3Mx28hKoTzHnX?=
 =?us-ascii?Q?i5CEyb0yZteFIZ+5fvHAeNXozad+fgi8SWC+BzykndtgjHtEa9kmoDQ+Wyhz?=
 =?us-ascii?Q?gsUAQ0Cy1TfnFWdBdYChI6YQHSglt7HpNS0Wn/8SeC852BdcEi3XFclaTTkB?=
 =?us-ascii?Q?afYvusXTimSCaMlryl1YVVaWEb9+heASi1WTqSUjInWcQDvgxDsrCpSZDXDb?=
 =?us-ascii?Q?yQ+xW690EdkQORAV7FBlAnRNfz8ejECcQmYrEZhjngLR2dXd0XPH3BqyaEVe?=
 =?us-ascii?Q?r14NqJW+oNjntopLDUnDyHMAyXV6yCmuEA5XZDwdOyzeEbeWoG6Z8LtDEwLg?=
 =?us-ascii?Q?tTz31s2XwsP9fAT8xwiDj6iUjHH/TDTzZ33gG47C/TqKcEpq36vT0X+V/bdh?=
 =?us-ascii?Q?a73eIQILgq3zI+A5ygsDISBTafeySMhxuBCfgFZJXl4jAgRsIMFSVne1lzw+?=
 =?us-ascii?Q?ackU1M1bDVqbHEQGaZ0IfqrPf40NpJ8xIWXFwUitKIIh9WE9UYo1oIgj+Yro?=
 =?us-ascii?Q?u/ohv3jZisIOTVu9FhHPEaFKvNahKBqwKfjsA79nrgn4gEUOR3hbnctfrUTm?=
 =?us-ascii?Q?DY0p9jdpN9fhybT6BJsnnkOfic919LhkjBfUNzsscnxWPjHw8jKu5zgTTdGT?=
 =?us-ascii?Q?nDpRnUUfNi0Zr2pe3YWjeEKLnYjFGi6ZcgZlcJRN8egFwJFMbljvWTUsahrI?=
 =?us-ascii?Q?12deYY2CrTr9Q/rfCuL+eLc9wrcPJoKSjk3OM48jXq+z9Ghp9lCADK6ne3Bk?=
 =?us-ascii?Q?KkWz8w2ZITuaffkngTRjmK7W4QZeNum9u0igmpnbb5C1hvVY43UMCM35ajmB?=
 =?us-ascii?Q?ew8ZyPMmPvL+LznZ2kySfdF0+NIg5Qdv3vNRh+49a2zKyyAmLHdprCf0i0FB?=
 =?us-ascii?Q?DLpCCIDaSDkAzW5Rt3xPpbcIS/5Od0gbaMAwROeec3wf1jsAod+9sf5vOCL7?=
 =?us-ascii?Q?2tK96atIWBsNFcbAgRd2yaUv2YxIlCpJGMVuZmpkNsSbvqG5e9suEpjajzfe?=
 =?us-ascii?Q?eeVR2aDtMiLH9sjfV6rn0+lMdPeHoH9uGNu89rrb35I5ISVGqLrQJs4NagfC?=
 =?us-ascii?Q?z1HyKDaFlw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d09f150-d5df-4781-8a05-08da1bca3dd8
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2022 14:47:46.2541
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zdJvzxCd8wWiMDZur6m1IoHrwvg5qLLbkb+Ogcq76vYVdRthdg5s7iNTNrYDof1JeG522yIhx21Z94uEeOOPMA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1430
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vadim Pasternak <vadimp@nvidia.com>

Extend MCIA (Management Cable Info Access Register) with new field
specifying the slot number. The purpose of this field is to support
access to MCIA register for reading cage cable information on modular
system. For non-modular systems the 'module' number uniquely identifies
the transceiver location. For modular systems the transceivers are
identified by two indexes:
- 'slot_index', specifying the slot number, where line card is located;
- 'module', specifying cage transceiver within the line card.

Signed-off-by: Vadim Pasternak <vadimp@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core_env.c | 13 +++++++------
 drivers/net/ethernet/mellanox/mlxsw/reg.h      | 14 +++++++++++---
 2 files changed, 18 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_env.c b/drivers/net/ethernet/mellanox/mlxsw/core_env.c
index 0c1306db7315..eff9ced260ea 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_env.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_env.c
@@ -69,8 +69,8 @@ mlxsw_env_validate_cable_ident(struct mlxsw_core *core, int id, bool *qsfp,
 	if (err)
 		return err;
 
-	mlxsw_reg_mcia_pack(mcia_pl, id, 0, MLXSW_REG_MCIA_PAGE0_LO_OFF, 0, 1,
-			    MLXSW_REG_MCIA_I2C_ADDR_LOW);
+	mlxsw_reg_mcia_pack(mcia_pl, 0, id, 0, MLXSW_REG_MCIA_PAGE0_LO_OFF, 0,
+			    1, MLXSW_REG_MCIA_I2C_ADDR_LOW);
 	err = mlxsw_reg_query(core, MLXSW_REG(mcia), mcia_pl);
 	if (err)
 		return err;
@@ -145,7 +145,8 @@ mlxsw_env_query_module_eeprom(struct mlxsw_core *mlxsw_core, int module,
 		}
 	}
 
-	mlxsw_reg_mcia_pack(mcia_pl, module, 0, page, offset, size, i2c_addr);
+	mlxsw_reg_mcia_pack(mcia_pl, 0, module, 0, page, offset, size,
+			    i2c_addr);
 
 	err = mlxsw_reg_query(mlxsw_core, MLXSW_REG(mcia), mcia_pl);
 	if (err)
@@ -219,12 +220,12 @@ int mlxsw_env_module_temp_thresholds_get(struct mlxsw_core *core, int module,
 			page = MLXSW_REG_MCIA_TH_PAGE_CMIS_NUM;
 		else
 			page = MLXSW_REG_MCIA_TH_PAGE_NUM;
-		mlxsw_reg_mcia_pack(mcia_pl, module, 0, page,
+		mlxsw_reg_mcia_pack(mcia_pl, 0, module, 0, page,
 				    MLXSW_REG_MCIA_TH_PAGE_OFF + off,
 				    MLXSW_REG_MCIA_TH_ITEM_SIZE,
 				    MLXSW_REG_MCIA_I2C_ADDR_LOW);
 	} else {
-		mlxsw_reg_mcia_pack(mcia_pl, module, 0,
+		mlxsw_reg_mcia_pack(mcia_pl, 0, module, 0,
 				    MLXSW_REG_MCIA_PAGE0_LO,
 				    off, MLXSW_REG_MCIA_TH_ITEM_SIZE,
 				    MLXSW_REG_MCIA_I2C_ADDR_HIGH);
@@ -419,7 +420,7 @@ mlxsw_env_get_module_eeprom_by_page(struct mlxsw_core *mlxsw_core, u8 module,
 		size = min_t(u8, page->length - bytes_read,
 			     MLXSW_REG_MCIA_EEPROM_SIZE);
 
-		mlxsw_reg_mcia_pack(mcia_pl, module, 0, page->page,
+		mlxsw_reg_mcia_pack(mcia_pl, 0, module, 0, page->page,
 				    device_addr + bytes_read, size,
 				    page->i2c_address);
 		mlxsw_reg_mcia_bank_number_set(mcia_pl, page->bank);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index 958df69cccb5..57eb6980bf8c 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -9978,6 +9978,12 @@ MLXSW_ITEM32(reg, mcia, l, 0x00, 31, 1);
  */
 MLXSW_ITEM32(reg, mcia, module, 0x00, 16, 8);
 
+/* reg_mcia_slot_index
+ * Slot index (0: Main board)
+ * Access: Index
+ */
+MLXSW_ITEM32(reg, mcia, slot, 0x00, 12, 4);
+
 enum {
 	MLXSW_REG_MCIA_STATUS_GOOD = 0,
 	/* No response from module's EEPROM. */
@@ -10077,11 +10083,13 @@ MLXSW_ITEM_BUF(reg, mcia, eeprom, 0x10, MLXSW_REG_MCIA_EEPROM_SIZE);
 				MLXSW_REG_MCIA_EEPROM_PAGE_LENGTH) / \
 				MLXSW_REG_MCIA_EEPROM_UP_PAGE_LENGTH + 1)
 
-static inline void mlxsw_reg_mcia_pack(char *payload, u8 module, u8 lock,
-				       u8 page_number, u16 device_addr,
-				       u8 size, u8 i2c_device_addr)
+static inline void mlxsw_reg_mcia_pack(char *payload, u8 slot_index, u8 module,
+				       u8 lock, u8 page_number,
+				       u16 device_addr, u8 size,
+				       u8 i2c_device_addr)
 {
 	MLXSW_REG_ZERO(mcia, payload);
+	mlxsw_reg_mcia_slot_set(payload, slot_index);
 	mlxsw_reg_mcia_module_set(payload, module);
 	mlxsw_reg_mcia_l_set(payload, lock);
 	mlxsw_reg_mcia_page_number_set(payload, page_number);
-- 
2.33.1

