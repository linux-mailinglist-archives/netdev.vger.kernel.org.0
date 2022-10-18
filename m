Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED7CF602EAC
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 16:38:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230448AbiJROir (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 10:38:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229947AbiJROiq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 10:38:46 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12D2FCA8A5
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 07:38:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g2mWJrk9+fSJEJQcsySVH99C3ZCYdlpzQP+A75tkqX6+ANkCk/0t4WEtpjDx5lgu9z8eaAItOc3M99W4CEKr2TYJLGMpjRZidMUFDw5izQGTA/EU971TGNPHBfQcaFoD0+W1rxb5L3IWdK+rQrEFddMfn2CkQ3zlI4/wFzg3hs/LHIP1WKuBCSibfxjn3xwqwgtfK41OAk0aaLn6aUTGxDt4oeX60icpFQNqOyKtJAmQdPC0XV6fQmA9q0ehwTUXRPBvwpS3yz88gNjf8/L/kWa84iYlYRfVysV6er7FANdx7iC/aJca8yYLwWLjyfdk9xZlQcv7eEPM3Wqk27WPMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LSFAanyg4JjEyRGA6BhJr3WHkgUyPhdiTBX4c+A869g=;
 b=ekmCIS+nNLUiGbQ1WA1nAoFc+uUOFf+ONyD7xUzSl7sYOiv6xbpfQ38C0t8dbIDbfR9W26WpUBmDq4T1/dqVImZKjB26IFxPz35SRmmLJRCc6PLxht8MHiRbDuQUSws5WA0NPgVZkqquJzQZIbw5v0CwE2OqOWnn1I4kfaJGmLeIJP7mPjFHVq8JDusphIP895gjeXHsQcEC9O89QVPRjO8abr4sv69oq73pDoLnlDNcikN/ohxx9ufBmSO9uFcglg6o3i8nH7dHtNjMgDM6bcfnPqtsLnHnQZid+DR/OVd3ShLpYsKZdB5U5BV1cUVYKG2P4QC3wgrekpoYXxExdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LSFAanyg4JjEyRGA6BhJr3WHkgUyPhdiTBX4c+A869g=;
 b=TsBlH5D4BU8hBQ6l+5t4wrZySsPGJLfSU+JOZeZp8iU4uZqqZGiYE3PGHgECCpit6i1DWcjmXdKqmUcwFlmPXwRt4sMciiu00IIccMkMqu/KHb1dfNSOif9Iu3HZ6coCdLodoRJtI3M+sHzcPp+F88qNpE/3iSBxOg3Q+SsYof8=
Received: from DM6PR01CA0019.prod.exchangelabs.com (2603:10b6:5:296::24) by
 DM4PR12MB5198.namprd12.prod.outlook.com (2603:10b6:5:395::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5723.33; Tue, 18 Oct 2022 14:38:42 +0000
Received: from DM6NAM11FT077.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:296:cafe::48) by DM6PR01CA0019.outlook.office365.com
 (2603:10b6:5:296::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.22 via Frontend
 Transport; Tue, 18 Oct 2022 14:38:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT077.mail.protection.outlook.com (10.13.173.147) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5723.20 via Frontend Transport; Tue, 18 Oct 2022 14:38:42 +0000
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Tue, 18 Oct
 2022 09:38:15 -0500
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31 via Frontend
 Transport; Tue, 18 Oct 2022 09:38:13 -0500
From:   <edward.cree@amd.com>
To:     <netdev@vger.kernel.org>, <linux-net-drivers@amd.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <habetsm.xilinx@gmail.com>,
        <johannes@sipsolutions.net>, <marcelo.leitner@gmail.com>,
        <jiri@resnulli.us>, Edward Cree <ecree.xilinx@gmail.com>
Subject: [PATCH v3 net-next 1/3] netlink: add support for formatted extack messages
Date:   Tue, 18 Oct 2022 15:37:27 +0100
Message-ID: <f6cdbbf29de087257201abd06ddaff0593236106.1666102698.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1666102698.git.ecree.xilinx@gmail.com>
References: <cover.1666102698.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT077:EE_|DM4PR12MB5198:EE_
X-MS-Office365-Filtering-Correlation-Id: fb62d30c-0c61-4142-b5f7-08dab1167493
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pm1Tn0qGrrYUL7vHXrmTovhW4tFReU6fe77jwNaHwToOhOPWgDs5JAMu54f9ZwJwV2tTCfycDcYM8zQp995aWdrbIaNq45NwTxwsNboHm9Te36+WN7AFbZD0i5ysXF7AgZqSDSuB8wECcBtxWanXH7NXBkZ7XkyM29UpiKSOGr3ea7t+Wyu1Jz0xzQYr566yk/LN//1Bp6Wx3hF80+otZMxsaUm/1CYjCIWw/Egg0X4RfietCtZo0G0RYVaUtVbN6PdXwBTIxW3AZf1UCfmk61mgktkYeDqiWTlPCcF1poG9RgtYk/Hnp4sar0APpX1R8BgO/0vDsKJOti0/PUgT4lKRE+siRB50D94bRoy+v9qXnnQ5gC14AHGvkXI0BIKdjSw+AoY5Y15SY47DJtY0kYaIDT2OEoymyd8iFaufaKvjcqvUPRLkUbGz99hHwByOpmn+p3Cp/nYBkAJei+kqqsNzrgXHb6kFeURhUJsgq/qGODz+cl+sgWjpPKHa9gL7X1SXXXxKckcbfF6u6Iww8xk7l/j10d9elUzY+wJQcuWkbrbSfDUzK/AGnsMDgSXCNAuv9rGxgIsJtz0kiQ2zDM+pNdcWCfDNYkqIa886KlhTyZpJkM6JY/KlcrtWN+rLy+dq4SRFRD7mFNpcq5pnPyVxW/UgCXtTrk9fwzKxwWIQE4WfTcJGRDyJ1rFbKVRPnL3eDz/WprgWlc7xE1KeaOkS1QbCmuvAOgsM3qLq43kc3KHYc81gG44SknP2/EYtTeHxvcQR8ipzFkPaMdS3KaCM79GbNZ3sb2mvIfa0PtCbi5ff5+jhv1JmFRskGxPL
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(346002)(39860400002)(136003)(396003)(376002)(451199015)(40470700004)(36840700001)(46966006)(2906002)(9686003)(478600001)(2876002)(41300700001)(336012)(47076005)(36756003)(426003)(83380400001)(26005)(8936002)(5660300002)(15650500001)(7416002)(81166007)(356005)(186003)(82310400005)(55446002)(86362001)(40460700003)(40480700001)(82740400003)(36860700001)(6636002)(316002)(110136005)(6666004)(54906003)(8676002)(4326008)(70586007)(70206006)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2022 14:38:42.8799
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fb62d30c-0c61-4142-b5f7-08dab1167493
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT077.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5198
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Edward Cree <ecree.xilinx@gmail.com>

Include an 80-byte buffer in struct netlink_ext_ack that can be used
 for scnprintf()ed messages.  This does mean that the resulting string
 can't be enumerated, translated etc. in the way NL_SET_ERR_MSG() was
 designed to allow.

Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
---
 include/linux/netlink.h | 29 +++++++++++++++++++++++++++--
 1 file changed, 27 insertions(+), 2 deletions(-)

diff --git a/include/linux/netlink.h b/include/linux/netlink.h
index d51e041d2242..d81bde5a5844 100644
--- a/include/linux/netlink.h
+++ b/include/linux/netlink.h
@@ -64,6 +64,7 @@ netlink_kernel_create(struct net *net, int unit, struct netlink_kernel_cfg *cfg)
 
 /* this can be increased when necessary - don't expose to userland */
 #define NETLINK_MAX_COOKIE_LEN	20
+#define NETLINK_MAX_FMTMSG_LEN	80
 
 /**
  * struct netlink_ext_ack - netlink extended ACK report struct
@@ -75,6 +76,8 @@ netlink_kernel_create(struct net *net, int unit, struct netlink_kernel_cfg *cfg)
  * @miss_nest: nest missing an attribute (%NULL if missing top level attr)
  * @cookie: cookie data to return to userspace (for success)
  * @cookie_len: actual cookie data length
+ * @_msg_buf: output buffer for formatted message strings - don't access
+ *	directly, use %NL_SET_ERR_MSG_FMT
  */
 struct netlink_ext_ack {
 	const char *_msg;
@@ -84,13 +87,13 @@ struct netlink_ext_ack {
 	u16 miss_type;
 	u8 cookie[NETLINK_MAX_COOKIE_LEN];
 	u8 cookie_len;
+	char _msg_buf[NETLINK_MAX_FMTMSG_LEN];
 };
 
 /* Always use this macro, this allows later putting the
  * message into a separate section or such for things
  * like translation or listing all possible messages.
- * Currently string formatting is not supported (due
- * to the lack of an output buffer.)
+ * If string formatting is needed use NL_SET_ERR_MSG_FMT.
  */
 #define NL_SET_ERR_MSG(extack, msg) do {		\
 	static const char __msg[] = msg;		\
@@ -102,9 +105,31 @@ struct netlink_ext_ack {
 		__extack->_msg = __msg;			\
 } while (0)
 
+/* We splice fmt with %s at each end even in the snprintf so that both calls
+ * can use the same string constant, avoiding its duplication in .ro
+ */
+#define NL_SET_ERR_MSG_FMT(extack, fmt, args...) do {			       \
+	struct netlink_ext_ack *__extack = (extack);			       \
+									       \
+	if (!__extack)							       \
+		break;							       \
+	if (snprintf(__extack->_msg_buf, NETLINK_MAX_FMTMSG_LEN,	       \
+		     "%s" fmt "%s", "", ##args, "") >=			       \
+	    NETLINK_MAX_FMTMSG_LEN)					       \
+		net_warn_ratelimited("%s" fmt "%s", "truncated extack: ",      \
+				     ##args, "\n");			       \
+									       \
+	do_trace_netlink_extack(__extack->_msg_buf);			       \
+									       \
+	__extack->_msg = __extack->_msg_buf;				       \
+} while (0)
+
 #define NL_SET_ERR_MSG_MOD(extack, msg)			\
 	NL_SET_ERR_MSG((extack), KBUILD_MODNAME ": " msg)
 
+#define NL_SET_ERR_MSG_FMT_MOD(extack, fmt, args...)	\
+	NL_SET_ERR_MSG_FMT((extack), KBUILD_MODNAME ": " fmt, ##args)
+
 #define NL_SET_BAD_ATTR_POLICY(extack, attr, pol) do {	\
 	if ((extack)) {					\
 		(extack)->bad_attr = (attr);		\
