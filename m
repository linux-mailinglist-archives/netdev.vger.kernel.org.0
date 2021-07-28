Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 511123D8D20
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 13:52:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236177AbhG1LwP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 07:52:15 -0400
Received: from mail-vi1eur05on2058.outbound.protection.outlook.com ([40.107.21.58]:21025
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236186AbhG1LwM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Jul 2021 07:52:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DNQQWXSWKeGW2xjQS0C7JZck1kpzL9zxPIrZs58qKfinnsDSObbEjguYmustN8pWJrHVj3GiTR6opaTXui02IWESnx6UKFsMeIyt2z6YAwZEZBwTYPvaYH7nlXAeMg4ZCNJda19uXXsODZ0YpHoKdzbDoBafHaiQcLifZgMWxsGyg+lZ0AjJdyAo9lXrA3ny9+AkwqhxIU+vCtbHx+ZWiNTFkkrPP/rdSbA6yAyZEcKMMayNhUZsxujILdMfpXb58Rn75W+/38ejAAHGiz2U5lJIW3I0cS7zcRJwg5eYQkN8hkTc3MI96JrBUj5FSmNKZz0sFVmsRDkCpBfn7Bjqag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=43zfs4b5nK8AZVA74c3pSdk24qL9GavyQBs4r2Ja6Y8=;
 b=j54cNwyHCasdE9qHp9FNhFOehq4W6KrHylKEJegW3fZhNpEzvf3Be7s22SKkf+gDizi8SyxC5FIieVHmCPE8hi5T1YnmOzrL/9G4n07wdf5JxJaSYmVbDqTQK+jOZ0Rvzj5zXbVqauHVu9Aj7Flxi+Ycnr8JCIBptgzJl9NSr/ZnAq2AQdR6rlHjbOnMvf4zvBtq4zQyUxqd52F1K+FVVUKNOa7MPiHBiwUBWWsI0fVyqkC23Qj6ASHThTm1qeFQsPrv6YfoqH2fdXjwOE2muQRIIyvVBvesUxS+534U2Snhf+521l6JNK7VjgWWNiPCpOwwUXb5KPSrtW4fY4Xb7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=43zfs4b5nK8AZVA74c3pSdk24qL9GavyQBs4r2Ja6Y8=;
 b=UPpED8s7sa/FNwMrGhxgjYfnk6B28TCceahSshILxa83LMynNPFzV4UOY3XqpGOLnGxmOqU5hROi4DwhHwitQ1dlQAy1hDTPaQm1bwHDie2Q8spZorYfis/lBdnDZPRkDJUAVBD2V2IVxJO+4U0QriF6L6FU6XCfKqMIn2ibVKc=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB6PR04MB3094.eurprd04.prod.outlook.com (2603:10a6:6:10::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18; Wed, 28 Jul
 2021 11:52:05 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9c70:fd2f:f676:4802]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9c70:fd2f:f676:4802%9]) with mapi id 15.20.4352.032; Wed, 28 Jul 2021
 11:52:05 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        shawnguo@kernel.org, s.hauer@pengutronix.de
Cc:     kernel@pengutronix.de, festevam@gmail.com, linux-imx@nxp.com,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH V2 net-next 3/7] net: fec: add imx8mq and imx8qm new versions support
Date:   Wed, 28 Jul 2021 19:51:59 +0800
Message-Id: <20210728115203.16263-4-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210728115203.16263-1-qiangqing.zhang@nxp.com>
References: <20210728115203.16263-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR01CA0100.apcprd01.prod.exchangelabs.com
 (2603:1096:3:15::26) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2PR01CA0100.apcprd01.prod.exchangelabs.com (2603:1096:3:15::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18 via Frontend Transport; Wed, 28 Jul 2021 11:52:01 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a6ccba1a-d6be-4ec6-5ec6-08d951be1e9e
X-MS-TrafficTypeDiagnostic: DB6PR04MB3094:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB6PR04MB309405EC48E21F5CB2E1A080E6EA9@DB6PR04MB3094.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +iwz4k1zvoZkxQYKBIhnSeJ3xxd6Wdrn0ge0Jwo/1O/uuwys0e2eauxQIv6cYGl9ayLCfRSro5uWxCC5o1xr8JX/nMzfkNo3tQ55uPuvrcA35aGHDqOMDY/tHRCcnQFY9IhM8Jen9A+XbxjMD6zdiF9QSM0P8q1n1JiF6PtPu3FHBTaFVg42GEA7u4YFuMWpArRfpp4+IrN81xs3zHHZWIoIhMcA0rDf8gklTA4iqiwYThxeUX7FzxB7K6j3wdFEC/j569t1IUkP67hbCsrAkJ0WcfcWYm+jAkPdoTYr41dXv14pcegxnuTCjgZPb5yskbynAmkj+x5Heo5dGun+5V0d1Eg5bq3q/ytuo0vlFKVSZgRGPrNdkQp6HW4soekKo2ix8bTCtPXnDAwjvgVWF8929rR1hpdwV6oKNYAJ+GshSnjQkpaxwv44/emO4Lp3IMHJ2vI3NSaCHKa1uoQW87tQWNrYZLIBSEmKOcOeqBseFT0ZPvlEazu5Qq2OkvGgfDQ5p96VC0mxpLs0sbxT73gnzlJmNw43vmy3lNRzLuj+e0SXwA4Xq9Ef3hSZVA5ynxWxMvrE8xQM9wNvvo75yApUO/RUEszoQcF6zFVhAPY5+rkVEpALZwGN99COo5ug1rHOXvXxeojcbCNoIk3tg7M6rdncfWn0G74cPPXM8bUwVm67QapTr4q+W/kQMCHiDkIpSdnUy6G6GAY3YsBGQm1IQlYYZEaAFtObuB8EM8c=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39840400004)(136003)(396003)(366004)(376002)(346002)(6512007)(7416002)(26005)(2906002)(6486002)(66946007)(66476007)(66556008)(8676002)(1076003)(6506007)(478600001)(38350700002)(38100700002)(186003)(5660300002)(2616005)(956004)(36756003)(86362001)(316002)(52116002)(83380400001)(4326008)(8936002)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?V0lj0dfXX0EnDf66VmdTk3Dpiax7iM4+VGA8dBxl3HXUcIREbMgk7m+yCURk?=
 =?us-ascii?Q?SNidd/Xq00swZDJcYawx1s1aA4C556b4CADHi/h8mT+HUxKAcmluq3b2IwNO?=
 =?us-ascii?Q?odd43xU14SyMshXRa6Vu4T4nuDLxBJnKiKy6A7fIUocSAL71lIEAJN0Ab1rc?=
 =?us-ascii?Q?+Rtn+rLnIbOF8WkI2tY0LpckIW+EaGPuRG5zS0VKR8kJrBKBUQN/yhP7GhZG?=
 =?us-ascii?Q?nsjPvwR8o8CySRUanbts/t/WIPILHKWVUiIph/Ry1BIC3gAQlJ4n26JTfn/8?=
 =?us-ascii?Q?fUCYD07gcHGP4TDueiJox7iwigid46m+P/EDDgixMJIphlXHIlfMGVRrOvNa?=
 =?us-ascii?Q?Cuh5bRwntGh4E1u5kJX0/w+5nq0vS310wygDPj/ggCvpmNwKGY+RDixQRvJ4?=
 =?us-ascii?Q?xIppc3V9wkx5yeHMGEWYHVicqg2E+Y95/ecRULgQzbVskwNdS4HNCaF8is9x?=
 =?us-ascii?Q?0wc/5uYvXAwHKdEeLbECUkH2ZtXGpBTdQl5d3mGjd3GrJrxwCZQZi3u3D6OW?=
 =?us-ascii?Q?3EwuAp1VwRVsq6nLMdK5vtu0M2Fo1pkLXqcm9t7opewjst0Zb12LLZVIyoFk?=
 =?us-ascii?Q?5v1OzVyBjkMxYYWE21Fb25zeTgLsFidXuh0c4gS8Mm8/h2YmeOisaRVN5/9Z?=
 =?us-ascii?Q?bzMXufMBHMS8VkeCEWJ1K5VbDh8xkRUZ8Q7sbY57KMyLR544ROvEYnIz2e9u?=
 =?us-ascii?Q?mCHzoS4uW8bVuFJO4LL3V2cpqU6KnInrTnidKv8wD3aDgg1gavdIAnj3W/hE?=
 =?us-ascii?Q?frYlBTqFOeCikcVc8K4N0wUDl60o0dS4oNpgS23irWsqbPfwG7IEnrXmeqaz?=
 =?us-ascii?Q?bomxIu82yAgBkXEARyGD7CWAKEVFxJuUbwaKt5qpnOAy0426D/xAJarhO82t?=
 =?us-ascii?Q?Lj4RH9cY1CcTe6GhkQ3RA7h1CRxuRzKzOSOOZJSbGzxxVzQRiAE4cQ2kqWyf?=
 =?us-ascii?Q?AEK6zg9bWVPywYrbmbY3ICkBCS2Gc3xJ3CYLMzDoE2uUCoW/JSHD+6km4shi?=
 =?us-ascii?Q?NDGbWz+6ujhuZdYz7+7yVbA1EiJjUd+vmT7nHq7Jtxv39SbEfayIAN8BV4ic?=
 =?us-ascii?Q?6UpPpsVFGz633NTBJnTcrrxPY87ILKvU7sL1OuXAc5gi5uuvKtoJbVB6U3sB?=
 =?us-ascii?Q?39zj04O9CIVzeNy6ssmh/l2VwJo7yM1AVBTbrSuBsF05Q3ic7AEwOveGZ2Oj?=
 =?us-ascii?Q?1T+cNQ/PIU1E/cewOq7ImoDiWnbromcsiDkxKazdt28tHgj2UhDSl31rwh/k?=
 =?us-ascii?Q?+MHoL+7BKwl4lu6Wl+MT0VX8YGxgwdSOOawkyortlo89McrWWiWRnZjUhWWO?=
 =?us-ascii?Q?ny5f6rmzIYEQzWEUKmtUBGhR?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a6ccba1a-d6be-4ec6-5ec6-08d951be1e9e
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2021 11:52:05.0829
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I08uAIFq9Ftjw0WiUrFyLVx1tudPt+B3PZFR3UgGTaGK3krlAHLlPSKmRqvmnemiGeGkKCWD/9DPmAmn4P93YQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR04MB3094
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Fugang Duan <fugang.duan@nxp.com>

The ENET of imx8mq and imx8qm are basically the same as imx6sx,
but they have new features support based on imx6sx, like:
- imx8mq: supports IEEE 802.3az EEE standard.
- imx8qm: supports RGMII mode delayed clock.

Signed-off-by: Fugang Duan <fugang.duan@nxp.com>
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 drivers/net/ethernet/freescale/fec.h      | 13 ++++++++++
 drivers/net/ethernet/freescale/fec_main.c | 30 +++++++++++++++++++++++
 2 files changed, 43 insertions(+)

diff --git a/drivers/net/ethernet/freescale/fec.h b/drivers/net/ethernet/freescale/fec.h
index 2e002e4b4b4a..c1f93aa79d63 100644
--- a/drivers/net/ethernet/freescale/fec.h
+++ b/drivers/net/ethernet/freescale/fec.h
@@ -472,6 +472,19 @@ struct bufdesc_ex {
  */
 #define FEC_QUIRK_HAS_MULTI_QUEUES	(1 << 19)
 
+/* i.MX8MQ ENET IP version add new feature to support IEEE 802.3az EEE
+ * standard. For the transmission, MAC supply two user registers to set
+ * Sleep (TS) and Wake (TW) time.
+ */
+#define FEC_QUIRK_HAS_EEE		(1 << 20)
+
+/* i.MX8QM ENET IP version add new feture to generate delayed TXC/RXC
+ * as an alternative option to make sure it works well with various PHYs.
+ * For the implementation of delayed clock, ENET takes synchronized 250MHz
+ * clocks to generate 2ns delay.
+ */
+#define FEC_QUIRK_DELAYED_CLKS_SUPPORT	(1 << 21)
+
 struct bufdesc_prop {
 	int qid;
 	/* Address of Rx and Tx buffers */
diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index e361be85f26f..d9ba9d6f7af7 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -135,6 +135,26 @@ static const struct fec_devinfo fec_imx6ul_info = {
 		  FEC_QUIRK_HAS_COALESCE | FEC_QUIRK_CLEAR_SETUP_MII,
 };
 
+static const struct fec_devinfo fec_imx8mq_info = {
+	.quirks = FEC_QUIRK_ENET_MAC | FEC_QUIRK_HAS_GBIT |
+		  FEC_QUIRK_HAS_BUFDESC_EX | FEC_QUIRK_HAS_CSUM |
+		  FEC_QUIRK_HAS_VLAN | FEC_QUIRK_HAS_AVB |
+		  FEC_QUIRK_ERR007885 | FEC_QUIRK_BUG_CAPTURE |
+		  FEC_QUIRK_HAS_RACC | FEC_QUIRK_HAS_COALESCE |
+		  FEC_QUIRK_CLEAR_SETUP_MII | FEC_QUIRK_HAS_MULTI_QUEUES |
+		  FEC_QUIRK_HAS_EEE,
+};
+
+static const struct fec_devinfo fec_imx8qm_info = {
+	.quirks = FEC_QUIRK_ENET_MAC | FEC_QUIRK_HAS_GBIT |
+		  FEC_QUIRK_HAS_BUFDESC_EX | FEC_QUIRK_HAS_CSUM |
+		  FEC_QUIRK_HAS_VLAN | FEC_QUIRK_HAS_AVB |
+		  FEC_QUIRK_ERR007885 | FEC_QUIRK_BUG_CAPTURE |
+		  FEC_QUIRK_HAS_RACC | FEC_QUIRK_HAS_COALESCE |
+		  FEC_QUIRK_CLEAR_SETUP_MII | FEC_QUIRK_HAS_MULTI_QUEUES |
+		  FEC_QUIRK_DELAYED_CLKS_SUPPORT,
+};
+
 static struct platform_device_id fec_devtype[] = {
 	{
 		/* keep it for coldfire */
@@ -161,6 +181,12 @@ static struct platform_device_id fec_devtype[] = {
 	}, {
 		.name = "imx6ul-fec",
 		.driver_data = (kernel_ulong_t)&fec_imx6ul_info,
+	}, {
+		.name = "imx8mq-fec",
+		.driver_data = (kernel_ulong_t)&fec_imx8mq_info,
+	}, {
+		.name = "imx8qm-fec",
+		.driver_data = (kernel_ulong_t)&fec_imx8qm_info,
 	}, {
 		/* sentinel */
 	}
@@ -175,6 +201,8 @@ enum imx_fec_type {
 	MVF600_FEC,
 	IMX6SX_FEC,
 	IMX6UL_FEC,
+	IMX8MQ_FEC,
+	IMX8QM_FEC,
 };
 
 static const struct of_device_id fec_dt_ids[] = {
@@ -185,6 +213,8 @@ static const struct of_device_id fec_dt_ids[] = {
 	{ .compatible = "fsl,mvf600-fec", .data = &fec_devtype[MVF600_FEC], },
 	{ .compatible = "fsl,imx6sx-fec", .data = &fec_devtype[IMX6SX_FEC], },
 	{ .compatible = "fsl,imx6ul-fec", .data = &fec_devtype[IMX6UL_FEC], },
+	{ .compatible = "fsl,imx8mq-fec", .data = &fec_devtype[IMX8MQ_FEC], },
+	{ .compatible = "fsl,imx8qm-fec", .data = &fec_devtype[IMX8QM_FEC], },
 	{ /* sentinel */ }
 };
 MODULE_DEVICE_TABLE(of, fec_dt_ids);
-- 
2.17.1

