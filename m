Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 636DD1F0C51
	for <lists+netdev@lfdr.de>; Sun,  7 Jun 2020 17:01:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727896AbgFGPBT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jun 2020 11:01:19 -0400
Received: from mail-eopbgr140053.outbound.protection.outlook.com ([40.107.14.53]:5605
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726595AbgFGPAo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 7 Jun 2020 11:00:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Id1+p2ZPbgB6/xGNMnsxAqRlcRlfn81NYLNxbkDuyUFK/xW/KcGnxqWF+EJo8IwNftJLTNnMI9c2Y8UPUmBnJRgKGrtZeR41VZvGr1BFat4MfgOkFQNdeVKTfr8qnM63dSqBDEg+4QgTMFeItwOonaBSDClWk+Av5eNR6s97sjuTotCLQqetOvy9bIMgh2L2oazKtK9CQamM70f9d59m5lIZsjJ1+CWXOh1Ue45FnQNAWjc1j01Ob01vrnsLOJDRfwRQM9xlqM+Uoc9yKvgcfEOz7PRwBZkF2ClZy70kersULkkHmes6kq2xj8j1oRtv6JUCiYK+GUmsQTPLXgIsiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MgRRxQ+O0Z2SZMU9eeAAdcWzucLsoqyMAt4nVQ8kTlE=;
 b=n9Ccl4k02Y+rQ7RIxF6e9ivE48aONSwynM/t6hvIXGypAWmn/40qoGfPnUzl+RG3nto1a/e1KuaQ3yYzETmWU6xj1UrXJ5cRNiGZBuqp1V+OJHX6oJm09D4j/FzHQtG7zzdmP/cssUjxkFaXZVus30GgO66tcXmgevrr6DjzReGinWhOdVPSmgBJRVd0/kk6hPWRfjY5Qs5fvWpeZNEnasgtKHsp+/zihE1TNaIEL0TgLAAgGbTDEDpuZvT35nL1crOgPph5MNZLQXvS+vz2n3AvD8GIyAW02q1aBeFdPAzNvUl0HxBeZhujX9Cp+h0F2wFYQDfEcoO7IHOvR4bTkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MgRRxQ+O0Z2SZMU9eeAAdcWzucLsoqyMAt4nVQ8kTlE=;
 b=V+ZtD8tfa0DZP7LOWbJOio1DTT7ZrNQRNmhQLvgxPrP3DbTEA2rSW/rDZbP4xc0DXUjJJQwA7qf4JNXyZhkcGebiRRy0ZuGxTx8NnysOCX6g1ep1LKVEHPF+bez/SDqwlz+0h+pORUiupHHi1AhhO/C8ADgwRxlh4VaRx00D+Og=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from AM0PR0502MB3826.eurprd05.prod.outlook.com
 (2603:10a6:208:1b::25) by AM0PR0502MB4003.eurprd05.prod.outlook.com
 (2603:10a6:208:2::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.23; Sun, 7 Jun
 2020 15:00:20 +0000
Received: from AM0PR0502MB3826.eurprd05.prod.outlook.com
 ([fe80::2dae:c2a2:c26a:f5b]) by AM0PR0502MB3826.eurprd05.prod.outlook.com
 ([fe80::2dae:c2a2:c26a:f5b%7]) with mapi id 15.20.3066.023; Sun, 7 Jun 2020
 15:00:20 +0000
From:   Amit Cohen <amitc@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, corbet@lwn.net,
        jiri@mellanox.com, idosch@mellanox.com, shuah@kernel.org,
        mkubecek@suse.cz, gustavo@embeddedor.com, amitc@mellanox.com,
        cforno12@linux.vnet.ibm.com, andrew@lunn.ch, f.fainelli@gmail.com,
        linux@rempel-privat.de, alexandru.ardelean@analog.com,
        ayal@mellanox.com, petrm@mellanox.com, mlxsw@mellanox.com,
        liuhangbin@gmail.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: [RFC PATCH net-next 06/10] mlxsw: reg: Port Diagnostics Database Register
Date:   Sun,  7 Jun 2020 17:59:41 +0300
Message-Id: <20200607145945.30559-7-amitc@mellanox.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200607145945.30559-1-amitc@mellanox.com>
References: <20200607145945.30559-1-amitc@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR10CA0015.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:17c::25) To AM0PR0502MB3826.eurprd05.prod.outlook.com
 (2603:10a6:208:1b::25)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-r-vrt-155.mtr.labs.mlnx (37.142.13.130) by AM0PR10CA0015.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:17c::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.18 via Frontend Transport; Sun, 7 Jun 2020 15:00:18 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 42992024-919a-43dc-e515-08d80af37f2a
X-MS-TrafficTypeDiagnostic: AM0PR0502MB4003:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR0502MB4003BB2F439AF354B66E5196D7840@AM0PR0502MB4003.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-Forefront-PRVS: 04270EF89C
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nEJTGRLjtrwdX1aagqckzbsCFAC4can4SvjyyX5lD9pBeIHJP726/RKpKidYQX3ObUYoWcgKBPBG4nj6H1cc/Huu3Xb/1N+7V+aB/MdMG96rdz278n9RT/kfTa3QtygP540ODf22jcQ6D17RnIln0dYGnRotVCrX20nSbD3TtZAQqONd2sXQ4r+SEc9fvcMZ0tE1MBeSKXbChLq9BrWGg5J8PUQhHoLttPH2s45WpCrAwMPf88RUvYGuh2oZ4ix/LdPml6IbKTn8Nh1SG6qaHr+m/Bl+Zb9vJHc9mgeOtfw1UYtgIi1SXeR6qgIgaLbtiXvEnVzwu4yZxL7NUE0pC0FAE38C8CX0wM9+WWnOu5ucs8WbNUxrBJoLF5nLmdeh
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR0502MB3826.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(376002)(366004)(346002)(136003)(39860400002)(66476007)(66946007)(66556008)(1076003)(186003)(8936002)(16526019)(26005)(52116002)(478600001)(6506007)(36756003)(2906002)(6666004)(7416002)(5660300002)(8676002)(4326008)(83380400001)(6486002)(316002)(86362001)(6916009)(2616005)(956004)(6512007)(130980200001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: /q+oVQjfTJCbDzJG8gvwx3F5lefNSYHsiSvq4gHQgVXToGNsDDv3+UBWfwVa3RlZVDn/yy1RPFMVrZ1ccpMbz3eeRleBK3aHUYZkTTc8hJDMFJbgY3/h7HZHb8raTHdLodlbF+MZnMJE7dexZWVxqFnm2W8jRIPmEwXamJsnnwzK9hEC6r5HxnkfKvd1sftw/xtYaODdqspoF9+QFGlpGmFzbUhzM3JRq6nEnwyWO235+MMp2FXmR6bggC3mpWzFaZyfHEb5t4ybEz6zEFHmAaTqcEfUn15yyjAXksI8W6oVO05B2mdDS6glfVDcezGQRC1nCO/P5YqLT6IyB2AmwtEvVDhuMmzvZijvvd4DHHHbp8mqtWeLfc2+Z04f3YUxUrP10DCFiTpS530pripp8RAUG6vrG1nb4ea+8ZSE2Ait8nantOliwPtfYezT6hQf6cMthdVEu9vSyrvXvRKcu8Xnj9M6jNuubNUSdIO29aM=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 42992024-919a-43dc-e515-08d80af37f2a
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2020 15:00:20.2411
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jRRdVPrxVHl0YGWLUNtzXgjwwTAr+xfmHeiAu2YbaZlasnmdj/7wdkSQ7y1P+yc+sugoxWRVJJp/vEgF1aHlPg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0502MB4003
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The PDDR register enables to read the Phy debug database.

Signed-off-by: Amit Cohen <amitc@mellanox.com>
Reviewed-by: Petr Machata <petrm@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h | 51 +++++++++++++++++++++++
 1 file changed, 51 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index fcb88d4271bf..b76c839223b5 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -5438,6 +5438,56 @@ static inline void mlxsw_reg_pplr_pack(char *payload, u8 local_port,
 				 MLXSW_REG_PPLR_LB_TYPE_BIT_PHY_LOCAL : 0);
 }
 
+/* PDDR - Port Diagnostics Database Register
+ * -----------------------------------------
+ * The PDDR enables to read the Phy debug database
+ */
+#define MLXSW_REG_PDDR_ID 0x5031
+#define MLXSW_REG_PDDR_LEN 0x100
+
+MLXSW_REG_DEFINE(pddr, MLXSW_REG_PDDR_ID, MLXSW_REG_PDDR_LEN);
+
+/* reg_pddr_local_port
+ * Local port number.
+ * Access: Index
+ */
+MLXSW_ITEM32(reg, pddr, local_port, 0x00, 16, 8);
+
+enum mlxsw_reg_pddr_page_select {
+	MLXSW_REG_PDDR_PAGE_SELECT_TROUBLESHOOTING_INFO = 1,
+};
+
+/* reg_pddr_page_select
+ * Page select index.
+ * Access: Index
+ */
+MLXSW_ITEM32(reg, pddr, page_select, 0x04, 0, 8);
+
+enum mlxsw_reg_pddr_trblsh_group_opcode {
+	/* Monitor opcodes */
+	MLXSW_REG_PDDR_TRBLSH_GROUP_OPCODE_MONITOR,
+};
+
+/* reg_pddr_group_opcode
+ * Group selector.
+ * Access: Index
+ */
+MLXSW_ITEM32(reg, pddr, trblsh_group_opcode, 0x08, 0, 16);
+
+/* reg_pddr_status_opcode
+ * Group selector.
+ * Access: RO
+ */
+MLXSW_ITEM32(reg, pddr, trblsh_status_opcode, 0x0C, 0, 16);
+
+static inline void mlxsw_reg_pddr_pack(char *payload, u8 local_port,
+				       u8 page_select)
+{
+	MLXSW_REG_ZERO(pddr, payload);
+	mlxsw_reg_pddr_local_port_set(payload, local_port);
+	mlxsw_reg_pddr_page_select_set(payload, page_select);
+}
+
 /* PMTM - Port Module Type Mapping Register
  * ----------------------------------------
  * The PMTM allows query or configuration of module types.
@@ -10758,6 +10808,7 @@ static const struct mlxsw_reg_info *mlxsw_reg_infos[] = {
 	MLXSW_REG(pbmc),
 	MLXSW_REG(pspa),
 	MLXSW_REG(pplr),
+	MLXSW_REG(pddr),
 	MLXSW_REG(pmtm),
 	MLXSW_REG(htgt),
 	MLXSW_REG(hpkt),
-- 
2.20.1

