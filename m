Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6D03666200
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 18:33:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234573AbjAKRdp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 12:33:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235327AbjAKRdS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 12:33:18 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54128637B
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 09:31:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YH3MV4oUfgKN0Kvy9ujeEvMVO/7EjQcBNMzqIA11/mKadWtYp/IbpY0fjFuHfW8PSlsgn86q8kAcAgT8YRUeJkOj7MqrnfvkkaAC7KH3cuOw1dNE+ZlMlKj5pY25/s5Om2WjcN1HYMKa3dRWN2QNhXfVStnLgKvDf5mstYI9X4kV5l188q+Fr7RST818yIB6N7Mn7kErq9wvcp1pOUcCzHSJHBzVtFxSBdhylIfxgI/gn2ZcN0oofxvF/bjuhpYcU2DaWiutgC5PtIbnqEHf0MKC6GZs8+AqJwL4lNdw7FVbicHDtyWE6C2XJZZbLN9YFuh6qmbJLg/8K+0LlDc6FA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JTV+lVQERvElOO3HNHW8P6RJTYAmZ2QrYeIvR4Pidc0=;
 b=TeBkIWp7jP9g9PAb4smgCWftyxqzFNmSFh+7XrH0ShVca+O9hLKCDcoBOGcmU6VQmMyG1UDgA0KST4MOkYAlbvf+K8wxV50Syh7soe72oS+K/c5L8bRwkBtxAkxvmLZ2xQx9/08gvr1hzJ82QgSP3Bu4aGdsEOQTcRDlTCu33N2NC+VMNHeSYZ62csdpWjG4qUEEPm+4Pme5bTCDs/1FtJOg+Z6Ht6hCeXp7DJnhdVqb4TCqlmmP6T1icLFyG7BGbzsoqGJ3vyw/rJKbPezTLPe7j9c/5cwu8SPpO5knqeb9GGB8WruO1OenSaUFI/EYbSbel5W00cQxxL1u9VtplQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JTV+lVQERvElOO3HNHW8P6RJTYAmZ2QrYeIvR4Pidc0=;
 b=iSqNFD7PZOAAq53+r7r2gSzKDPougqmRKS3LXs3/L4qDhDqjpq0zx7xEqPC5PYEQ/pS96njyAwkxcrM46gg3St4rNHZ+PbWIUHN42nPdYA3W0Hey3lzhsjvVpiY+A8dpU6RIbtiuEl2GI13qnurz1hegZ42K8J1noTD7U0uZqoA=
Received: from MW4PR03CA0341.namprd03.prod.outlook.com (2603:10b6:303:dc::16)
 by DM4PR12MB5277.namprd12.prod.outlook.com (2603:10b6:5:390::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Wed, 11 Jan
 2023 17:31:00 +0000
Received: from CO1NAM11FT038.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:dc:cafe::80) by MW4PR03CA0341.outlook.office365.com
 (2603:10b6:303:dc::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.13 via Frontend
 Transport; Wed, 11 Jan 2023 17:31:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT038.mail.protection.outlook.com (10.13.174.231) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6002.13 via Frontend Transport; Wed, 11 Jan 2023 17:30:59 +0000
Received: from jatayu.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 11 Jan
 2023 11:30:00 -0600
From:   Raju Rangoju <Raju.Rangoju@amd.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <edumazet@google.com>,
        <pabeni@redhat.com>, <Shyam-sundar.S-k@amd.com>,
        <Raju.Rangoju@amd.com>, Ajith Nayak <Ajith.Nayak@amd.com>
Subject: [PATCH net 1/2] amd-xgbe: TX Flow Ctrl Registers are h/w ver dependent
Date:   Wed, 11 Jan 2023 22:58:51 +0530
Message-ID: <20230111172852.1875384-2-Raju.Rangoju@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230111172852.1875384-1-Raju.Rangoju@amd.com>
References: <20230111172852.1875384-1-Raju.Rangoju@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT038:EE_|DM4PR12MB5277:EE_
X-MS-Office365-Filtering-Correlation-Id: 59f55df7-a38f-49c1-e983-08daf3f99b12
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9DeAs4vqnyv5G+maU0E4KI4a+4XOHq1+O20ddxpRpXALKJHrh/kkwaeIkGihhXfVynFvhMulSoe8ydLOy5Txd/Z5FM6sKwE+/EMDUQk+gRy64jzR7KPqAEWYPG52cr3j1joNUZ+qCNWlIawgh1fMTDVJr+CGhW5zVriAOuL6KAwwRiu0WbvaTjDHDtlu6hlcKRkO3U2HKkva8SKu6O/+UQCYlYIhT7rLh7CDWEm9JNDwcz/xt+djsbU3qKdHPjY26IWBYymjsfWJShOcIyVsOgnLbu5sjlayCw0WODUW18J6xfiku+hv0H2AM4AIq7Z2hnow6xHOPRUIzyCiUwZQombW6ni87FBkSW2PafJTjB6HMvx4ENsSxz2Xj/2iFYwj8OUGZ+zJqQ7XG/YmtzyogNVOS10YYHdp96D/43Z4/NijUTG4J/fpXA46CWMUDFTJWbPPRCwySUNc7GipL5/y5wE5HGbNIi7rHlA5Z7YAMz4ZQ8NSSG5saDnXNIXT9rghQ0ma5NmPlRI2cGKZGMe7WaNE7BJLnmMoxMN7tHEYRCZunjfuc3FNfPt4gzkT1n3N8fwkPERHr1NBwSZkNVgHbl9w5cErecJwbBNMAi/wpx+b9iZyGEGq3bZGmq+V8MDMOS0BicjVCErLVLv2YMFvDUSYa2AOV4RyUhloyPn1X5yC+lzqmPk8UFsEYSIPoHNOuOJnA+ee5zjzIPfuYzNjUizg6N5RtUUdNpOQWZ0FfCc=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(346002)(396003)(376002)(136003)(39860400002)(451199015)(40470700004)(46966006)(36840700001)(36860700001)(82740400003)(6666004)(81166007)(356005)(2906002)(478600001)(2616005)(1076003)(16526019)(7696005)(26005)(186003)(5660300002)(40480700001)(316002)(83380400001)(8936002)(40460700003)(82310400005)(36756003)(86362001)(426003)(47076005)(41300700001)(6916009)(8676002)(336012)(70586007)(54906003)(70206006)(4326008)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2023 17:30:59.9054
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 59f55df7-a38f-49c1-e983-08daf3f99b12
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT038.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5277
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is difference in the TX Flow Control registers (TFCR) between the
revisions of the hardware. The older revisions of hardware used to have
single register per queue. Whereas, the newer revision of hardware (from
ver 30H onwards) have one register per priority.

Update the driver to use the TFCR based on the reported version of the
hardware.

Fixes: c5aa9e3b8156 ("amd-xgbe: Initial AMD 10GbE platform driver")
Co-developed-by: Ajith Nayak <Ajith.Nayak@amd.com>
Signed-off-by: Ajith Nayak <Ajith.Nayak@amd.com>
Signed-off-by: Raju Rangoju <Raju.Rangoju@amd.com>
Acked-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
---
 drivers/net/ethernet/amd/xgbe/xgbe-dev.c | 23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-dev.c b/drivers/net/ethernet/amd/xgbe/xgbe-dev.c
index 3936543a74d8..4030d619e84f 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-dev.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-dev.c
@@ -524,19 +524,28 @@ static void xgbe_disable_vxlan(struct xgbe_prv_data *pdata)
 	netif_dbg(pdata, drv, pdata->netdev, "VXLAN acceleration disabled\n");
 }
 
+static unsigned int xgbe_get_fc_queue_count(struct xgbe_prv_data *pdata)
+{
+	unsigned int max_q_count = XGMAC_MAX_FLOW_CONTROL_QUEUES;
+
+	/* From MAC ver 30H the TFCR is per priority, instead of per queue */
+	if (XGMAC_GET_BITS(pdata->hw_feat.version, MAC_VR, SNPSVER) >= 0x30)
+		return max_q_count;
+	else
+		return min_t(unsigned int, pdata->tx_q_count, max_q_count);
+}
+
 static int xgbe_disable_tx_flow_control(struct xgbe_prv_data *pdata)
 {
-	unsigned int max_q_count, q_count;
 	unsigned int reg, reg_val;
-	unsigned int i;
+	unsigned int i, q_count;
 
 	/* Clear MTL flow control */
 	for (i = 0; i < pdata->rx_q_count; i++)
 		XGMAC_MTL_IOWRITE_BITS(pdata, i, MTL_Q_RQOMR, EHFC, 0);
 
 	/* Clear MAC flow control */
-	max_q_count = XGMAC_MAX_FLOW_CONTROL_QUEUES;
-	q_count = min_t(unsigned int, pdata->tx_q_count, max_q_count);
+	q_count = xgbe_get_fc_queue_count(pdata);
 	reg = MAC_Q0TFCR;
 	for (i = 0; i < q_count; i++) {
 		reg_val = XGMAC_IOREAD(pdata, reg);
@@ -553,9 +562,8 @@ static int xgbe_enable_tx_flow_control(struct xgbe_prv_data *pdata)
 {
 	struct ieee_pfc *pfc = pdata->pfc;
 	struct ieee_ets *ets = pdata->ets;
-	unsigned int max_q_count, q_count;
 	unsigned int reg, reg_val;
-	unsigned int i;
+	unsigned int i, q_count;
 
 	/* Set MTL flow control */
 	for (i = 0; i < pdata->rx_q_count; i++) {
@@ -579,8 +587,7 @@ static int xgbe_enable_tx_flow_control(struct xgbe_prv_data *pdata)
 	}
 
 	/* Set MAC flow control */
-	max_q_count = XGMAC_MAX_FLOW_CONTROL_QUEUES;
-	q_count = min_t(unsigned int, pdata->tx_q_count, max_q_count);
+	q_count = xgbe_get_fc_queue_count(pdata);
 	reg = MAC_Q0TFCR;
 	for (i = 0; i < q_count; i++) {
 		reg_val = XGMAC_IOREAD(pdata, reg);
-- 
2.25.1

