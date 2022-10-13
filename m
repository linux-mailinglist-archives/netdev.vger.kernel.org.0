Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C6CD5FD6EF
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 11:23:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229547AbiJMJXk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 05:23:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229825AbiJMJXb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 05:23:31 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2046.outbound.protection.outlook.com [40.107.223.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BCB6F53FF
        for <netdev@vger.kernel.org>; Thu, 13 Oct 2022 02:23:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jASnXhLzkcvj5wp8N//0Q+x4jsFfAYHfTNLIZ21kknlKKJBTlc4Gm2TqSy5ze9TothJyAbi+IZQlN4TZ58GnQqFfdtisAFy8NmccEsSJ1ZopQqsg1xXNMEQMBwDzwaFjsXNikYFXTrgG/+qfAWn2AFtzukNr2wsIm/CQIMDjCdFix+wnlcSSdluvjR8hQBJ64BHBsl9BH17cUSSzNw+NuT2ura/iPOl1Ky2BWQvaDwiVIqsobgOeuyed3awK6wmXqARhfnDRtISropc4YF/F9mGW/Jux97oSQLUYWS+P0tuM0yn7RDqYxybojbEVSmb92KyUXQjzvqznzGFkq/loGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ypJ2TgwdyeHH2utB1SHNCC3bujjvkgW6aIS3dhf7tqs=;
 b=HF9M7m7GxmVxXp7QCInec4L4/sx9wCsx0ShZcbIIAO4HgRvbeF84SYi5IZqKtN0tlgaVZnptyPGKggwWsqx2+YW/ySlUn/Gsz/C2OiX6vlNNRzk96JQYo/oSKqAvkXc/lo0IwKBddnGoXhi18C+00lF9vb6dIYBdYtP/zLg2wcbo2p7+LSpyyzci9bmHI6x9ea78jeP/9pJsavMdWJRUxIlQCg2CPvYkPdjTWqybY8FdT2JGMRzNTwnNhIdjR2EJSf8KFXrEkn2NEQaJFBaJfHWCoJyuQ5C4ZkLmlqDu0+n3x+vrEgMya3pKW4Md6Jbtjn+/z8/yqe3auAImwcsFYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ypJ2TgwdyeHH2utB1SHNCC3bujjvkgW6aIS3dhf7tqs=;
 b=PUrC0nq3WxRVB8ebBedgjLvo6qswB0zVKquceKD0B2j79yxzO/GAHiOQtEoEpt/SH7p/ztU44Z4DIssfXn4/Go3wESA2ARimslWfS4QUwsq4Dkrvdr+rLgGxYZr890U4VsifbmTRObdfVUWF+hJbRo6a3VKRqlvZm8OZziiwH7Y=
Received: from DS7PR05CA0076.namprd05.prod.outlook.com (2603:10b6:8:57::13) by
 CH3PR12MB7546.namprd12.prod.outlook.com (2603:10b6:610:149::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5709.21; Thu, 13 Oct
 2022 09:23:26 +0000
Received: from DM6NAM11FT035.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:57:cafe::86) by DS7PR05CA0076.outlook.office365.com
 (2603:10b6:8:57::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.10 via Frontend
 Transport; Thu, 13 Oct 2022 09:23:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 DM6NAM11FT035.mail.protection.outlook.com (10.13.172.100) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5723.20 via Frontend Transport; Thu, 13 Oct 2022 09:23:26 +0000
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Thu, 13 Oct
 2022 04:23:25 -0500
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28 via Frontend
 Transport; Thu, 13 Oct 2022 04:23:24 -0500
From:   <edward.cree@amd.com>
To:     <netdev@vger.kernel.org>, <linux-net-drivers@amd.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <habetsm.xilinx@gmail.com>,
        <johannes@sipsolutions.net>, <marcelo.leitner@gmail.com>,
        Edward Cree <ecree.xilinx@gmail.com>
Subject: [RFC PATCH v2 net-next 1/3] netlink: add support for formatted extack messages
Date:   Thu, 13 Oct 2022 10:23:00 +0100
Message-ID: <26c2cf2e699de83905e2c21491b71af0e34d00d8.1665567166.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1665567166.git.ecree.xilinx@gmail.com>
References: <cover.1665567166.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT035:EE_|CH3PR12MB7546:EE_
X-MS-Office365-Filtering-Correlation-Id: 773192e4-0ecc-48a7-4403-08daacfc9585
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Z70gcjvt64tgxKJpWBYpsCPfu/OXOVPItOfKRgJOZEPXOw1G/Gy88LNub/rDySTfM0AGRWk8hHJOqfafXepZe6/QpT8XkzaAvfy9p6/cgTYZaUGtmZuvxUVoGJdjN6E6eDf03vpVGLIsuv5jmcRf5qW+QgQ7PbU2wVK+aSIxYPfQG3HTIqK2rSL4EKvqwdbqPCurd1FpurvFGzWymJN4xQJ1nk9o0aCCX8cC5Rwwb3gCpqVHNzXVCs9A+JqpwXMoDMUmm/FrtF29JKL1BcflEybciHNoCVhMw0DXVahQWYRBG48KxnrXJuuONyNsvs3rxLdLV8bkSR/uwrbkF4l+BAZcSGMzwxSQVPqZg78ZvfRB5MHtIs+nsnVCtFouv0Yd1eKkcsffofEWTuK7wtG3Zzwt2a/Rij/ODSHozSoKLMIvzFNt5BHsJp8GnwbOWyNPv7zM0W+ZkToedJymQvFAx/cySbVtz1ptOp4K1Rk+/joogqoZtVM06kHnCGcPcjgwQJeNh7uNBczCjhucDH6FfaNesnsZvZgr1lSn1Bosjs9HyEo6MieEErrgZmBfZN0FNHGtFDQafW173+4fwZPn1SmHNAtfMkvmZfDq0RoCPWayzphvwsqIZYaYmhzOKD4mXL7BMweSceTw+Uo5dY/emUKjRzeBou/a6/rkV9UZNT12LfbmbxY6c9q/5Eug9FYVa2wUPHYjynBDY/s8bc58xhi3S0qwJ4Xxec/iYAAjp3YCx+8CYXH6HiG7HQyhH4sbrJgpnBp36szHhhQr9LD8cI61umq1Fe2cP5f9JkJA3lSRhrfFYZdgr6+9uySDb1Ou
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(396003)(346002)(39860400002)(136003)(376002)(451199015)(46966006)(36840700001)(40470700004)(9686003)(356005)(316002)(110136005)(6636002)(54906003)(82740400003)(86362001)(478600001)(55446002)(81166007)(36756003)(36860700001)(26005)(40480700001)(40460700003)(336012)(186003)(6666004)(4326008)(41300700001)(8676002)(5660300002)(15650500001)(8936002)(47076005)(426003)(83380400001)(2906002)(82310400005)(70586007)(2876002)(70206006)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2022 09:23:26.5840
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 773192e4-0ecc-48a7-4403-08daacfc9585
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT035.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7546
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
 include/linux/netlink.h | 25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

diff --git a/include/linux/netlink.h b/include/linux/netlink.h
index d51e041d2242..4cbe87739c4d 100644
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
@@ -102,9 +105,27 @@ struct netlink_ext_ack {
 		__extack->_msg = __msg;			\
 } while (0)
 
+#define NL_SET_ERR_MSG_FMT(extack, fmt, args...) do {			\
+	struct netlink_ext_ack *__extack = (extack);			\
+									\
+	if (!__extack)							\
+		break;							\
+	if (snprintf(__extack->_msg_buf, NETLINK_MAX_FMTMSG_LEN,	\
+		     (fmt), ##args) >= NETLINK_MAX_FMTMSG_LEN)		\
+		net_warn_ratelimited("truncated extack: " fmt "\n",	\
+				     ##args);				\
+									\
+	do_trace_netlink_extack(__extack->_msg_buf);			\
+									\
+	__extack->_msg = __extack->_msg_buf;				\
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
