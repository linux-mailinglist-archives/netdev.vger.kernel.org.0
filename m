Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A30B504CD8
	for <lists+netdev@lfdr.de>; Mon, 18 Apr 2022 08:46:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236851AbiDRGrM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Apr 2022 02:47:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236859AbiDRGrE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Apr 2022 02:47:04 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam08on2086.outbound.protection.outlook.com [40.107.100.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F33D19031
        for <netdev@vger.kernel.org>; Sun, 17 Apr 2022 23:44:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FrNTITSn1A5FLevQMKExZzCaV18JnPE5XZEAi9y86mn4B5+JRajV1krGJ2s4TTUuXXBPZTGunnI7GrhrYuWzRH76V0ItMgPjhAYphZY2fmI7PoHeLA5ANIpfD33SFao4WH24o1zendlH7gaQDnGbPj1dM7ciD0+233hHgzGHOZRjzk5tnA7Bj+n5JtapItLXc/2/Vs4kEM08jcX+8feNTf3Gq2TfiRwQpOCNd8mBZThgJXaiDVfo6gsbI/AW3wUXoe2B2Kg960Xa5sxMQWbn6snjj5HPSH5+eH3opuh5GBMUPa5ILihaAHq9druEW0x0gb9MgZBtfSGiJK36M9lv8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KwgkG/eRV98o9cmTNw0Js1zt2lqnigHHkVyi2P1f3EA=;
 b=XzE5Ui/kOcuo38yVzFi3AecRZ1F+A6dV8GBhQPGyiT0Koj/2E/LIJ8cdP7jqiSrD3fRxWuhBydzA56Ha7gZBRqJCnY9tXXL/PBD4rKIuyZEWyegcQDNn0bgY9iX39DwbZO8R6vsQzqvRT3pu6hKdY62GyyamMGvQi/k2FmCldeimz+eWo6YI9ir6h3OvstlrRuOFtqD1zHVbpVHMp0c7nNq1qVEcjLrRF53PgRw3a/6ew44ep6QdJFwcFeQRSVRSIgdjesUStJPqGQ8az+8IK8s5w6knOD/LArky9u4C5xTShlw6YXO5r7SwacqW60Sk/rOBw2RH0kkkWGONW9kGbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KwgkG/eRV98o9cmTNw0Js1zt2lqnigHHkVyi2P1f3EA=;
 b=lv2qu2+LBDYGR8g8OoCWEFfdMlHPM/J39/JdtKep8R7spn3wt3o8IFYrwGXGKWjgT2yvmt7jRZ+DazItflMecuPuvAtbqCv33rUED3yZh45wlhMO3HjnYZXEB0PO/0eIHAo8zPMxhqPpwHMR+qvCIjs568yf57geE0jA06fgWHR8pQhoNbAXGjh4P3lyFUNWcK4A+wpH9lZ9/WqlM6QPD0aINMQNN2jHJAC35PXCn9Sp/2/1C4l3LWKFFXvUBVEl6wfnkLJBlLxC5znMWmZ/wjjwqrjadhTNJHcRwGwvppHxobRDcBZAFBZt9lXA8kHC6MqwQRn4BGXEMcA9OugoSg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by MN2PR12MB3664.namprd12.prod.outlook.com (2603:10b6:208:159::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Mon, 18 Apr
 2022 06:44:21 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::6131:18cc:19ae:2402]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::6131:18cc:19ae:2402%6]) with mapi id 15.20.5164.025; Mon, 18 Apr 2022
 06:44:21 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        jiri@nvidia.com, vadimp@nvidia.com, petrm@nvidia.com,
        andrew@lunn.ch, dsahern@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 10/17] mlxsw: reg: Add Management DownStream Device Query Register
Date:   Mon, 18 Apr 2022 09:42:34 +0300
Message-Id: <20220418064241.2925668-11-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220418064241.2925668-1-idosch@nvidia.com>
References: <20220418064241.2925668-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0405.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:189::14) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c75c1820-46dd-4e46-8cb3-08da2106de77
X-MS-TrafficTypeDiagnostic: MN2PR12MB3664:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB36640DF5F6B12B2D8F87354DB2F39@MN2PR12MB3664.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ILDWBHk6VAZrNZO6cr2OuPji7vSPwz0K1dOLoY0vfstXy0nvEwX18J6FYy8DRpBobz/6Afkxs1RtKKD9d40WeQ7fRuRyoMWqfll9aQSzuSrQxW1IaZ1RGHdbCm/Ew0h7ZAXSZxoTFwnMgOHnS4Dr4zQQEaBpuOUIzaQNk1WKvClNUpR0tcoQRQNc4piTZSmOTVxojQHIGYaXEoD5JQPd2GjJJBt4SpEWmyJNw0qQUwh64MsqK2yOalv9ta2Sxs9nqrMDAAFRfofAX5BUc92SJ0Qds284A5u34jIAsQZnpMUFgTl2m3rQsNlQ7VeLQ7isLLwLef0V2BDbrpURrqmSBkJIdfZrIhb8a+WP3QqU90dQBYRBwNn2I63WfV6n0iN6N3tdRSl94ghKX766vpnVNYRLrv+p/jatQS7/00nBCXDdF0m2C/fH/aqe9zxqe0lgrvh2ucqDwdN+8/WF8l+h6Z2vVhXD+pLFBRzip2O2RW77CwhZa2Avtm7JvXB2/NEBC/a6tFBxHFoRtiUSj6kc34lWgKkELPPUgcz2Ap9JDOCSfGrn4LFTp7mpmOt0Iw9ftXMr/wzsWfNkNWK2jIKxYiL62/rLiAUl8yDq3oB7nt7GiCS5KLd8LPJSPFZ5dhH/C51K+1JOWZd4gfHRuBIpuQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(107886003)(66556008)(316002)(4326008)(8676002)(508600001)(8936002)(6486002)(66476007)(5660300002)(6512007)(186003)(66946007)(38100700002)(86362001)(26005)(83380400001)(36756003)(2616005)(6666004)(2906002)(6916009)(6506007)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UT60RBWcaLwZZcVkR+C87CWoYT3vK64x1blBbtlUxlDSje4o7Bzx7AlJomXE?=
 =?us-ascii?Q?pe9OmWMOedvlLO56/4nSzsdR1UtB9wFUTcAVs2gtQtuXl1ZG63pD3ljF8QLx?=
 =?us-ascii?Q?3p9pU8PSRPkMyzGQA7yVAokr254Gt30KV4+GwpSFofsIZ4uWGTOF42dK51oS?=
 =?us-ascii?Q?ZdV0NojzYa5EzPGNypC/OCkQKLtuNCYiazR+bDjTAFXcBVrpml43mRcysexo?=
 =?us-ascii?Q?TK+AtvNUeof0Z0kd5/nk8t5zRhIBCcC7uLQs37g/I6+wjDZsp3Vb1Rmaa8Ax?=
 =?us-ascii?Q?/dOSj2s1O7uY77d7Xxd/bmOoUjMEc1HXX+L0/Kl3QgC/nZQOmQ0N3FDfyf8y?=
 =?us-ascii?Q?f01ZF/11CLslAaAkiG82O5Htpi31G4Wool6dpE7hrKLFftGuL7hbyEO1Jlod?=
 =?us-ascii?Q?umeEuBs9caWLDxCGDRSSLeUJeewTKmvdHM8MSdNIoY1s31d0zyCjJTPSr7gQ?=
 =?us-ascii?Q?yfewLl5cDRDnkqVq3WB6CLY6d69JbC8r8a7PiiWtB1PBIho2LjEOs8B6TjY7?=
 =?us-ascii?Q?qw/bv48TvY9UU+Dot94Sjz3aFpbRp/v9h0swzC3OzqYQom64QpQR9lY8CCta?=
 =?us-ascii?Q?LPn+g5jAW2Pd2yg14HOIQKXJ0T1JfXIHSAobpjc7d+iVBzeQwxXIAImSMOWc?=
 =?us-ascii?Q?F6gqahDubPS4iJXGLtHgm/y7v8UqRjHfA9yUlkijb+yrabL7aG3AcIQUbdge?=
 =?us-ascii?Q?W0rcCSlDsyKi+ER9duBIaS0c9WQH9yhsQOFIQAZ0gt3fWPkxuXk5o8MktA+P?=
 =?us-ascii?Q?Z4dtfq+FAeXMgjF62SvsfkD2N1iivSHEOyp8SlvkhyiB5agzBwxT8LF9bH4G?=
 =?us-ascii?Q?NyHApWrt7rLCyoiwn7yjh6GY0npEfkkzH2te2LwtzCHqzenmbBzBuJAKKHD6?=
 =?us-ascii?Q?wRmnbuLCrvG8k5fqOTFUDbOyk3OCBJH0C464sZim76vPtmzwS09VkE8H+HIc?=
 =?us-ascii?Q?Yvo5QdAsmCIk1PNdgcCdCjEvoosK2XMFa9Yo7mzDlRITJDzlArn4sujcV38J?=
 =?us-ascii?Q?MpynaXwRM4gMUQyxADlsntDceCjaxZ5hi/67GD3mBocT2jGCd9XFbmybFWDg?=
 =?us-ascii?Q?MiNNqVXGu8KyP7jfrxRlyACkjxvCYtfuDXDVXHcnehSllO7nW97kfJI01egp?=
 =?us-ascii?Q?CN58lGJN1SggF21B6lY1/ws1YZvgbdqH3JuKpl38ErZgaWQdAI4grmGHHEXr?=
 =?us-ascii?Q?E7qcKgXDaW0f94d6J8h9bOemF5vNwRJBQFmMqFkEys05gphQh3f/pp/6nYuQ?=
 =?us-ascii?Q?kip+C8bk+FhIXGoL/BTo1nq9u7wVJiYFw3OjWAWYHthZVgWb/RDZDSyn/BWD?=
 =?us-ascii?Q?3H0UWaLu8+WGqoFjmkTIc9UFcyuac95OvhJUk1JGlcCrFbi8MfXeKisZGd/f?=
 =?us-ascii?Q?orBkUBJx3237nw97peDc8ztAvYiy57ljkCnnT5VEIw5WX+SJjXxDi6vPWwf6?=
 =?us-ascii?Q?qVNw0NuVvoJ03QL10EqQk3BQ3PDC/S9mn495kVFS9AEpJ8cG6PVQIx7flUaU?=
 =?us-ascii?Q?Jyer7HjlsCFofK/q9UA7F7Z548R66SaQVTM1GaSPDpt+2B0lSpjdcC5oIWAN?=
 =?us-ascii?Q?ibZV3F5dCB+aFTndx6OHZZ7gQn0PsBqRhHOSa8QQ1QjSV/8oddIBgLNmJuVc?=
 =?us-ascii?Q?Pu+r2dG6fBre5YhZqro4LNZTZSJXW9IxI1UDowghR0dIUxfie5dgLY4nOzvH?=
 =?us-ascii?Q?RMONnkK6rve4gfbpUruQZKUB7juYb/IC7ryDFBb1bV1F4nHBvMAJYebeQpQP?=
 =?us-ascii?Q?x98aCYWoxg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c75c1820-46dd-4e46-8cb3-08da2106de77
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2022 06:44:21.4586
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GWz7EbdgevaVTz39gvgRSjxyFu/R2aOPXZylhGTh7/YQnJ+axfzmzkaY+GzrXAg1loVb52MunIqHUuPmrhDmAQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3664
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

The MDDQ register allows to query the DownStream device properties.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h | 144 ++++++++++++++++++++++
 1 file changed, 144 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index 7b51a63d23c1..1595b33ac519 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -11492,6 +11492,149 @@ mlxsw_reg_mgpir_unpack(char *payload, u8 *num_of_devices,
 		*num_of_slots = mlxsw_reg_mgpir_num_of_slots_get(payload);
 }
 
+/* MDDQ - Management DownStream Device Query Register
+ * --------------------------------------------------
+ * This register allows to query the DownStream device properties. The desired
+ * information is chosen upon the query_type field and is delivered by 32B
+ * of data blocks.
+ */
+#define MLXSW_REG_MDDQ_ID 0x9161
+#define MLXSW_REG_MDDQ_LEN 0x30
+
+MLXSW_REG_DEFINE(mddq, MLXSW_REG_MDDQ_ID, MLXSW_REG_MDDQ_LEN);
+
+/* reg_mddq_sie
+ * Slot info event enable.
+ * When set to '1', each change in the slot_info.provisioned / sr_valid /
+ * active / ready will generate a DSDSC event.
+ * Access: RW
+ */
+MLXSW_ITEM32(reg, mddq, sie, 0x00, 31, 1);
+
+enum mlxsw_reg_mddq_query_type {
+	MLXSW_REG_MDDQ_QUERY_TYPE_SLOT_INFO = 1,
+	MLXSW_REG_MDDQ_QUERY_TYPE_SLOT_NAME = 3,
+};
+
+/* reg_mddq_query_type
+ * Access: Index
+ */
+MLXSW_ITEM32(reg, mddq, query_type, 0x00, 16, 8);
+
+/* reg_mddq_slot_index
+ * Slot index. 0 is reserved.
+ * Access: Index
+ */
+MLXSW_ITEM32(reg, mddq, slot_index, 0x00, 0, 4);
+
+/* reg_mddq_slot_info_provisioned
+ * If set, the INI file is applied and the card is provisioned.
+ * Access: RO
+ */
+MLXSW_ITEM32(reg, mddq, slot_info_provisioned, 0x10, 31, 1);
+
+/* reg_mddq_slot_info_sr_valid
+ * If set, Shift Register is valid (after being provisioned) and data
+ * can be sent from the switch ASIC to the line-card CPLD over Shift-Register.
+ * Access: RO
+ */
+MLXSW_ITEM32(reg, mddq, slot_info_sr_valid, 0x10, 30, 1);
+
+enum mlxsw_reg_mddq_slot_info_ready {
+	MLXSW_REG_MDDQ_SLOT_INFO_READY_NOT_READY,
+	MLXSW_REG_MDDQ_SLOT_INFO_READY_READY,
+	MLXSW_REG_MDDQ_SLOT_INFO_READY_ERROR,
+};
+
+/* reg_mddq_slot_info_lc_ready
+ * If set, the LC is powered on, matching the INI version and a new FW
+ * version can be burnt (if necessary).
+ * Access: RO
+ */
+MLXSW_ITEM32(reg, mddq, slot_info_lc_ready, 0x10, 28, 2);
+
+/* reg_mddq_slot_info_active
+ * If set, the FW has completed the MDDC.device_enable command.
+ * Access: RO
+ */
+MLXSW_ITEM32(reg, mddq, slot_info_active, 0x10, 27, 1);
+
+/* reg_mddq_slot_info_hw_revision
+ * Major user-configured version number of the current INI file.
+ * Valid only when active or ready are '1'.
+ * Access: RO
+ */
+MLXSW_ITEM32(reg, mddq, slot_info_hw_revision, 0x14, 16, 16);
+
+/* reg_mddq_slot_info_ini_file_version
+ * User-configured version number of the current INI file.
+ * Valid only when active or lc_ready are '1'.
+ * Access: RO
+ */
+MLXSW_ITEM32(reg, mddq, slot_info_ini_file_version, 0x14, 0, 16);
+
+/* reg_mddq_slot_info_card_type
+ * Access: RO
+ */
+MLXSW_ITEM32(reg, mddq, slot_info_card_type, 0x18, 0, 8);
+
+static inline void
+__mlxsw_reg_mddq_pack(char *payload, u8 slot_index,
+		      enum mlxsw_reg_mddq_query_type query_type)
+{
+	MLXSW_REG_ZERO(mddq, payload);
+	mlxsw_reg_mddq_slot_index_set(payload, slot_index);
+	mlxsw_reg_mddq_query_type_set(payload, query_type);
+}
+
+static inline void
+mlxsw_reg_mddq_slot_info_pack(char *payload, u8 slot_index, bool sie)
+{
+	__mlxsw_reg_mddq_pack(payload, slot_index,
+			      MLXSW_REG_MDDQ_QUERY_TYPE_SLOT_INFO);
+	mlxsw_reg_mddq_sie_set(payload, sie);
+}
+
+static inline void
+mlxsw_reg_mddq_slot_info_unpack(const char *payload, u8 *p_slot_index,
+				bool *p_provisioned, bool *p_sr_valid,
+				enum mlxsw_reg_mddq_slot_info_ready *p_lc_ready,
+				bool *p_active, u16 *p_hw_revision,
+				u16 *p_ini_file_version,
+				u8 *p_card_type)
+{
+	*p_slot_index = mlxsw_reg_mddq_slot_index_get(payload);
+	*p_provisioned = mlxsw_reg_mddq_slot_info_provisioned_get(payload);
+	*p_sr_valid = mlxsw_reg_mddq_slot_info_sr_valid_get(payload);
+	*p_lc_ready = mlxsw_reg_mddq_slot_info_lc_ready_get(payload);
+	*p_active = mlxsw_reg_mddq_slot_info_active_get(payload);
+	*p_hw_revision = mlxsw_reg_mddq_slot_info_hw_revision_get(payload);
+	*p_ini_file_version = mlxsw_reg_mddq_slot_info_ini_file_version_get(payload);
+	*p_card_type = mlxsw_reg_mddq_slot_info_card_type_get(payload);
+}
+
+#define MLXSW_REG_MDDQ_SLOT_ASCII_NAME_LEN 20
+
+/* reg_mddq_slot_ascii_name
+ * Slot's ASCII name.
+ * Access: RO
+ */
+MLXSW_ITEM_BUF(reg, mddq, slot_ascii_name, 0x10,
+	       MLXSW_REG_MDDQ_SLOT_ASCII_NAME_LEN);
+
+static inline void
+mlxsw_reg_mddq_slot_name_pack(char *payload, u8 slot_index)
+{
+	__mlxsw_reg_mddq_pack(payload, slot_index,
+			      MLXSW_REG_MDDQ_QUERY_TYPE_SLOT_NAME);
+}
+
+static inline void
+mlxsw_reg_mddq_slot_name_unpack(const char *payload, char *slot_ascii_name)
+{
+	mlxsw_reg_mddq_slot_ascii_name_memcpy_from(payload, slot_ascii_name);
+}
+
 /* MFDE - Monitoring FW Debug Register
  * -----------------------------------
  */
@@ -12811,6 +12954,7 @@ static const struct mlxsw_reg_info *mlxsw_reg_infos[] = {
 	MLXSW_REG(mtptpt),
 	MLXSW_REG(mfgd),
 	MLXSW_REG(mgpir),
+	MLXSW_REG(mddq),
 	MLXSW_REG(mfde),
 	MLXSW_REG(tngcr),
 	MLXSW_REG(tnumt),
-- 
2.33.1

