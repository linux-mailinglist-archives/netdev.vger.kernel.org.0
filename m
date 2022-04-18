Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E0C9504CD6
	for <lists+netdev@lfdr.de>; Mon, 18 Apr 2022 08:46:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236838AbiDRGrO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Apr 2022 02:47:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236831AbiDRGrF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Apr 2022 02:47:05 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam08on2068.outbound.protection.outlook.com [40.107.100.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC5A313DF9
        for <netdev@vger.kernel.org>; Sun, 17 Apr 2022 23:44:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VYbTMcGUf+2U4Av71r8T/bOVy1f/W/TCqzYMtJ3bxkMJ9lyyuccbFlCpv53a6uBnI5uFt9LY0IaWFDd+c4AhJ28q8abfczMX3i8c3DL2GanDPCWxZyw1T13GKsy0DB9tj1t3KiUS3lzW+mUJHM/Wykw6p0dty5Y64LZyW0APolT6ZaAxrZL8AUHrq3U4wnODNL4vtnmPmH/Rz9m6LmGtJZLKCVE/0PgtAEdcnV+e7w3MgU0fHBWe4HgWaSJcc+7a7yE586kb96/tfM1zEWDPxXemjoJFEpKWv08qgamCJp0KJfCLYZYaoIuNEmNPl+O0Dwa+AmWGh6Zcaep0Eo2R/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MR/XWXMsbUYwbVlyUQvIKbDDN9woUiFrodYeydXtEbc=;
 b=I6EuiP58hmsIeu4wfl9V4OiMi6ohItlA4tcPf9sYNRIEGSnFyv+G5YeARtQ4a/5G2XC68V0lqeJsSdxVo9k1GTklGfwrmGilqjjMzqMYXc3r3gWWEjrq94nVQXkb8niX8SAtouBI90dWYGOp9GVW4OLM8QsxqAR0MwxcGcY0J4CmuAXn8hPFYKdDp385XgMXo0rTyJ3vqGMENZGNrmfy1zgyKXDH+3by+TAFOivahjsTfBWSy4nrWPNE1+zYwyq2KrD5514JESMI+3R8S+v84N4hcxwimTaoX077ySJw8hJsLqB9Jgs9UlVH9EQ7s6gqO9omRjPOCupQuYomdQRZ6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MR/XWXMsbUYwbVlyUQvIKbDDN9woUiFrodYeydXtEbc=;
 b=D5Wi4pqLb3jp+HDSa05TblCbefYQeuo0QPuHIOomSEW7yK7QqJ1NYAY8BQDna3C8+8WToGNbrF0C/qQ7pwg7gaQmyDhncyS11UGdd4Fa539dRho6Hj4rR1AlHFQ0q586lFhSysg0LpZr1VL92m3ICjGcKtIR7pzx42LsL2XezeCMwQixBnzLuB9gFT2pKJOUsoRBJEv5gQOeUFzJfo8iYA2JzRRAUKQMDhe18dv2xUc6YAYkGJ6IfMJPoNq4Rkcz7tQNNV7t9twiaIU43q/WEZIbHaycWneg28nEYm6n+Yefgj7xd/DZz23/kDhLfNivynnw9u+eMAXEZR405ZYeHw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by MN2PR12MB3664.namprd12.prod.outlook.com (2603:10b6:208:159::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Mon, 18 Apr
 2022 06:44:26 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::6131:18cc:19ae:2402]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::6131:18cc:19ae:2402%6]) with mapi id 15.20.5164.025; Mon, 18 Apr 2022
 06:44:26 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        jiri@nvidia.com, vadimp@nvidia.com, petrm@nvidia.com,
        andrew@lunn.ch, dsahern@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 11/17] mlxsw: reg: Add Management DownStream Device Control Register
Date:   Mon, 18 Apr 2022 09:42:35 +0300
Message-Id: <20220418064241.2925668-12-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220418064241.2925668-1-idosch@nvidia.com>
References: <20220418064241.2925668-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P265CA0058.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2af::8) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6067e084-0a96-4c1c-9293-08da2106e15d
X-MS-TrafficTypeDiagnostic: MN2PR12MB3664:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB3664BCADEC171238A281BC88B2F39@MN2PR12MB3664.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9SIPVsMRrJl4EeWzmETUlaxe4Ngdg21nneb9ud30grxOsxKP0h8fZIbNEOhdpmLoWBxGjiMsFhAz3ErdlceW23+QxThV1xWzPajtwG7wpU5ajxTeb9GULDEOeI+nym+DXp8ItbLGFkvucmQr4kAuJpcHiuIQHnBvzAXnDGp6cMp2oL6BA/ySi9ZgqHeemjBlipNKiQJcvl5mNtIRuqfU7Cr7lQ3VlAivF06fay4KCILth/tpxwL6cWI0IcS14U8wVsGzq78TTp6iwQ9yOEn3zZ9jhoovnf0drXHiC0/C40MOGpGuBXuBmTDnHo7cbelcbmVcHmnKv0T0nJb+COlaxumWCi73bGTfg2rq16Z77BOv+IIJKdP5zq+4x9gKw+b+8uV1qMNRuoa65rN19d0/SRLJsSOU/OlxtBvfwGfDlFgUun/cmdm6eAVrBqLQC85au6zjE4Y15Pyw5I387uAe9gZiADQLTPj9dily8z1vjT9HEU/Vcq3SNLaxQUfn4lJ9qvYBAJ711gClFRGW/IQQwvwGR7y84WBdqVH7tqukWw+OWLr0Bx5VQHMfXa0HIEgiJ2R9js6Ifr22SiHs4uXV6dln9noGKB5bwP2s3F4Wx/a6rtcEz9DBk7bc1sysExVqHpCemgnTd/5jf/vQuhALsA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(107886003)(66556008)(316002)(4326008)(8676002)(508600001)(8936002)(6486002)(66476007)(5660300002)(6512007)(186003)(66946007)(38100700002)(86362001)(26005)(83380400001)(36756003)(2616005)(6666004)(2906002)(6916009)(6506007)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?S69O5hrMN7wx/1CO72RGcC8TrwWFGjBrDCx2B0ctUM1r9kTBJWUvY5tPti9r?=
 =?us-ascii?Q?NhH1A6TrIGoX02bso9Z+BYVH/u0CnzWJQfN1BCiVaqLVXPsN7EP4b8Y3+LtT?=
 =?us-ascii?Q?4cdFsMyI62DqCzbbbhZio3flTSJcakFtnivIocUj4kh/E5W+6Sozz3ONU8gV?=
 =?us-ascii?Q?SWaGIOBeLlhYWCEpp0lXwlkIegtN13gv/AQbwsxlSR5NGKoLEKO8YbzMf+F7?=
 =?us-ascii?Q?BfzJNNAI2LQx7mV1SQDgrrhOig7A40/dYVXldbggkuj/TehwJqgJ+bB8Ta0Q?=
 =?us-ascii?Q?vj2kvd9qlilPnNJ+oAoVvJUYniQPJSo4sy8lzMzrDJMEaeLP1lsdboisPF9E?=
 =?us-ascii?Q?UfEJ/bGpROfz9PAQXxCoWaNnbEdV2nbJR2XU21HqvBo3u7A6ZAFKNZ+nbVLg?=
 =?us-ascii?Q?cat2+nqDFFPLv/n/WCJuoj0GCeFK7W8mBvpC+zx4Q/mY5qMYBlyXMt5x5GTI?=
 =?us-ascii?Q?d/J16Z1leYWHeUZVRCn4PTf9UQl34VqMybiH3uI+VEud5Nrvx4Ct62AvD3TU?=
 =?us-ascii?Q?J4DpwA3EA1nfwAUY/O8+831cJF0qnvhs/HVgrUVQRkoqY3DgqR/Zsq3yTSoS?=
 =?us-ascii?Q?c+OyqG307Gkma8nRamnYt2/yyIGhTKqy6IbUjpwpiSc5EXGfaJ+owg6yhYV1?=
 =?us-ascii?Q?xA+RC9L0aIsuRlq+gI4+dS9moXBxeUV8RBkKlIAP2/XMEjIKCwdsklTcg21q?=
 =?us-ascii?Q?Hjiot3FVwgeTIxK1CwPIS9AMIs82p8nQ3nuk5m0oKu+ePRe4Ad/d8HYxo76A?=
 =?us-ascii?Q?MbSByEHZwgSHWmiOOZNM+rjGDlNh7BLFM2C3WeUeCBCxZ5QyyDoFgpNyM/s/?=
 =?us-ascii?Q?HQVcbl2eHfVvPlfeau7Rsy1qDPhWLxGnQJ0TYFjJIWBjnLw6LptOULD5g8l5?=
 =?us-ascii?Q?nZ2HgEIeRyWnbgH+Qtxcz9KjD4fCkuTDwq3PV0zrKJfHwENJKWMwD62JU+8y?=
 =?us-ascii?Q?vt5vVxvk9saWnMxVr3SsdmvVijF6mEaXP3NH2R4UhihaFQahMfLIKcfrIzN1?=
 =?us-ascii?Q?M1lQrpvtb0B/dqYQGnGXcrE40MOUP5e9Ir4C3f7N3HCaDT9qRVhvNvJuQDrc?=
 =?us-ascii?Q?9EtSWYIV9dLAOfrjgmUPWboJevVE7oubAnO16mqaPQ0AKCckAtcrIHDVDkkR?=
 =?us-ascii?Q?6gpMctYfTWhoE4GCaWPDx7uP+2rQEVpPF2GeC+lmTjTJ2bq5QTeve92/9d+c?=
 =?us-ascii?Q?/GnoXLohjNbNDXIzU+FD4lhwgZQQYD1anny1PLy01WfRnSnv9zbHqx+GQSYT?=
 =?us-ascii?Q?viwwmggw81cad7OQ65swOE4eqyBLrWA1pdMCJA3YjGd4f5YZt3toP0Q+b7W5?=
 =?us-ascii?Q?0SlK5XUh5DkxlMMyjEiuBDFxxuaHK5wxFla4yJNp1UnhiEEmgIC3TEYvHouF?=
 =?us-ascii?Q?KOwdOFsfM5Q8gDH/qY5aZ9nrioBYlCt0t3Q5bL/C/SUqVTILXouTfu4VIJve?=
 =?us-ascii?Q?xTrQowhzk5DQJSpMmT6De2hd4Ik+qWNJaqAyXtIsLQ+QoTadKCGCYbBAWKMb?=
 =?us-ascii?Q?n+Uvv2LqZYh3omxEXJZwHPkwMkUFSs9Eq1d0Au+iZ0cf0KuBxyrmMia4AfDG?=
 =?us-ascii?Q?93Uc49A+SKz0X1xN7rfF97gnjTBibO7GMVyY6C16C9a5s2cTjycThGu21dU9?=
 =?us-ascii?Q?8f75KMIMTyzxwjrJma4pX2KVHdoRUiGCn6xqw/6G8Qe3sB6AVabO/7FT+Z/U?=
 =?us-ascii?Q?gieHrbBnxWgvNA86T350N47AiwfQy17+3a2YhpWTLwBzTpg5iJBQJJF7XuAu?=
 =?us-ascii?Q?TAHgxDpQWw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6067e084-0a96-4c1c-9293-08da2106e15d
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2022 06:44:26.2278
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZtkBxRJ4ugj3pPco1XbkWlkuEfwgGA6kWKGnKF4ZPp1+o92u5ZYjQgU1a+/HD+FWlhfrWzd9zdY1fgtgXhvZrA==
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

The MDDC register allows to control downstream devices and line cards.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h | 37 +++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index 1595b33ac519..31a91de61537 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -11635,6 +11635,42 @@ mlxsw_reg_mddq_slot_name_unpack(const char *payload, char *slot_ascii_name)
 	mlxsw_reg_mddq_slot_ascii_name_memcpy_from(payload, slot_ascii_name);
 }
 
+/* MDDC - Management DownStream Device Control Register
+ * ----------------------------------------------------
+ * This register allows to control downstream devices and line cards.
+ */
+#define MLXSW_REG_MDDC_ID 0x9163
+#define MLXSW_REG_MDDC_LEN 0x30
+
+MLXSW_REG_DEFINE(mddc, MLXSW_REG_MDDC_ID, MLXSW_REG_MDDC_LEN);
+
+/* reg_mddc_slot_index
+ * Slot index. 0 is reserved.
+ * Access: Index
+ */
+MLXSW_ITEM32(reg, mddc, slot_index, 0x00, 0, 4);
+
+/* reg_mddc_rst
+ * Reset request.
+ * Access: OP
+ */
+MLXSW_ITEM32(reg, mddc, rst, 0x04, 29, 1);
+
+/* reg_mddc_device_enable
+ * When set, FW is the manager and allowed to program the downstream device.
+ * Access: RW
+ */
+MLXSW_ITEM32(reg, mddc, device_enable, 0x04, 28, 1);
+
+static inline void mlxsw_reg_mddc_pack(char *payload, u8 slot_index, bool rst,
+				       bool device_enable)
+{
+	MLXSW_REG_ZERO(mddc, payload);
+	mlxsw_reg_mddc_slot_index_set(payload, slot_index);
+	mlxsw_reg_mddc_rst_set(payload, rst);
+	mlxsw_reg_mddc_device_enable_set(payload, device_enable);
+}
+
 /* MFDE - Monitoring FW Debug Register
  * -----------------------------------
  */
@@ -12955,6 +12991,7 @@ static const struct mlxsw_reg_info *mlxsw_reg_infos[] = {
 	MLXSW_REG(mfgd),
 	MLXSW_REG(mgpir),
 	MLXSW_REG(mddq),
+	MLXSW_REG(mddc),
 	MLXSW_REG(mfde),
 	MLXSW_REG(tngcr),
 	MLXSW_REG(tnumt),
-- 
2.33.1

