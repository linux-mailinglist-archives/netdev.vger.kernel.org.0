Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A2FD5F78E7
	for <lists+netdev@lfdr.de>; Fri,  7 Oct 2022 15:26:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229871AbiJGN0I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Oct 2022 09:26:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229825AbiJGN0B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Oct 2022 09:26:01 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2064.outbound.protection.outlook.com [40.107.94.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81D36804BB
        for <netdev@vger.kernel.org>; Fri,  7 Oct 2022 06:26:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TWK4S1k2y8Wg8+5rXNb9Ifuufmx67e0rXncPjFgwMAxeCBxee46i8pLi+vIrQq7vDmDE4zRumKtyQFifaEUqNBHIKbydDtAqZ3pnIIDtjAf2LFGju9S/en5hEkNgu74A8KAc7ILNjhieLRzUpRhj5GrqAqzDarNR1wa2t/dYvRwrCUCAHKn5oi7uINuR7SglXXBMcqv/R/33cbaLBKzr2EU18ms/cVQGvruWNk3adXL868iVc7Ke7j4ngo7pyxrfJLdqR4o0zkjz2QUm2xWZfSnVzFUkx5oEDCZk332l7NkX5mJmvgB2pdgLJTCbaFgJWEMSySHaH8gwCsN58s6xrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xnWBKHKTLfuv2S/GtZBRJEdx4mMTvJ20/eezlUBIiyo=;
 b=KsvsM4GzZiMiQoWQBKd0OBTcDR0R8oge53vHZqV2svZVhj7b+6QlFqh282ceKWhAlVB070EoVzBfcS28Wsh6s7gLiPa+CdMvBDjmL5Tcyzkwva6EBWhB78/qz8EV8KXiL7kyvZ3E7j2Pl3Nq2lYrRqR7SayyJ4hxmc0eywKger0DRZQe9ecNQxL2RifakVQC6Bg7yuxf18SEDdQrC5kiZ++1P++E+kXuM+Vi7I0+xz1etUsH6J98IxbwTBc0qoFj2v+iwtMr9riA9SgRHkPkafFJitluaCZNk+7f22dliwryidQe0wX1Wb3I1U7Frt4Q17D99dVfk9K+girAb+L1Zw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=fail (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xnWBKHKTLfuv2S/GtZBRJEdx4mMTvJ20/eezlUBIiyo=;
 b=jI33SK2hbc5UJ2JrPwZGeWy9mNOqGjNn0cfmSPiO4GTx1ulNf2FrjuOp0my688B1LxouibdFRv4UFOX+zoePCZXlhSvwBUZtBUxFz38HMGj88vzmArdZGTl3VeJHOdnsgumgeNrcXV0Yyb65/jfyMXvmoLR/MAu76Gw9ga6kmQTMiab4chWdlxXte+eATJ10OtDKqlhOuMkVFTQsl5hcXQcG5T2BpBmfKv9L9suNvWTYM4MtJmGqGNiyaz9PB66aBkJrX+E0J+hxFgUby3mnmpLRr7Be5a8SBdGFu3DLYYYpkCqWD2PzXcmIAbnBtq7w7MsteRsOR7V4mpDbvR6sKA==
Received: from BN9PR03CA0770.namprd03.prod.outlook.com (2603:10b6:408:13a::25)
 by PH8PR12MB6867.namprd12.prod.outlook.com (2603:10b6:510:1ca::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5709.15; Fri, 7 Oct
 2022 13:25:56 +0000
Received: from BN8NAM11FT033.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:13a:cafe::6b) by BN9PR03CA0770.outlook.office365.com
 (2603:10b6:408:13a::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5709.15 via Frontend
 Transport; Fri, 7 Oct 2022 13:25:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT033.mail.protection.outlook.com (10.13.177.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5709.10 via Frontend Transport; Fri, 7 Oct 2022 13:25:56 +0000
Received: from SATLEXMB05.amd.com (10.181.40.146) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Fri, 7 Oct
 2022 08:25:55 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB05.amd.com
 (10.181.40.146) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Fri, 7 Oct
 2022 08:25:55 -0500
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28 via Frontend
 Transport; Fri, 7 Oct 2022 08:25:53 -0500
From:   <ecree@xilinx.com>
To:     <netdev@vger.kernel.org>, <linux-net-drivers@amd.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <habetsm.xilinx@gmail.com>,
        <johannes@sipsolutions.net>, <marcelo.leitner@gmail.com>,
        Edward Cree <ecree.xilinx@gmail.com>
Subject: [RFC PATCH net-next 1/3] netlink: add support for formatted extack messages
Date:   Fri, 7 Oct 2022 14:25:12 +0100
Message-ID: <a01a9a1539c22800b2a5827cf234756f13fa6b97.1665147129.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1665147129.git.ecree.xilinx@gmail.com>
References: <cover.1665147129.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT033:EE_|PH8PR12MB6867:EE_
X-MS-Office365-Filtering-Correlation-Id: baa61242-49c8-4ee7-96cc-08daa8677746
X-MS-Exchange-SenderADCheck: 0
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: r/5ckp8fIvwncBKtrIT+j1poPslnZV26YsI+e42KarMaYScUuNTgyVQ9lf8ix051I1a2OqIl6WByHDyUDF3Yh+MvHt7Y9234wVopd6oRlSQKHmvOVX18fWqHfYMwfJOxJQypi/tWNEHPaLGZJqLzCWkIJ4Guies77K5jI1HMtESFZKZ82inE2gGBmheoPu9vX5U22l9Lri+22c3RuolqIr4VW7V9ghM8GQYkse3LsnNLgZ/T/YzQOHN3xZTCrQY7cZAyi2KU7wcBJhXVJ8ZcCbrS1BmfzZw/vEQCYtQzVlaqNiH1hj6JXm/XZtJDNfnwGDk03tOx+ij85Gmzt+Iy17D9Kap6/zB7b+GgeUZAUNH8Gc5XRAQFcItnhVCsDE61dHlcqgP+1A3iPQqLgmts5Bs3r/gmeaajBt9VaPM1ickYVye6/CG1lpJpS9S1jCC/z8SGTZ+AZ82DcdxbuFsSaqItyw77lBAFXTx3N5pfhTeXuJDI8cf4m/es25zyj5r61cuvvkXICxaxgPUqtn/pO/Ack2ilCChbPb7ezE7F+qhp8GvYqZPlQ/ne3yGqrzAW9pzdNo3I8HEahM0IFz5oCOcB9BPAKDM3otiuRFEtg7k0Yme25+mh3yLLdkbBXkdj3CuYHMbk0QAr9YurTN/HTa995parnNl6pCNeSuPpiLj41HcpHZ7/aabfytrTvcqp6unWSOouA6pvCa3DuOJIkWarasYbKGffUXp03ttAPfnQZ6UnE3ZceuKHApzHXeutJZQcZrr5yhdAuOu98XwmH0xVs/4cZYZ0HUPZqkk8WM8e1jtZlshx0fWWOF8AAA+8
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(136003)(396003)(39860400002)(346002)(376002)(451199015)(46966006)(36840700001)(40470700004)(47076005)(26005)(70586007)(70206006)(4326008)(8676002)(41300700001)(9686003)(2906002)(186003)(2876002)(15650500001)(36756003)(8936002)(42882007)(336012)(55446002)(5660300002)(36860700001)(478600001)(40480700001)(82310400005)(6666004)(83170400001)(316002)(40460700003)(356005)(83380400001)(81166007)(82740400003)(110136005)(54906003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Oct 2022 13:25:56.1934
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: baa61242-49c8-4ee7-96cc-08daa8677746
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT033.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6867
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=no
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
 include/linux/netlink.h | 21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/include/linux/netlink.h b/include/linux/netlink.h
index d51e041d2242..bfab9dbd64fa 100644
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
@@ -102,9 +105,23 @@ struct netlink_ext_ack {
 		__extack->_msg = __msg;			\
 } while (0)
 
+#define NL_SET_ERR_MSG_FMT(extack, fmt, args...) do {		\
+	struct netlink_ext_ack *__extack = (extack);		\
+								\
+	scnprintf(__extack->_msg_buf, NETLINK_MAX_FMTMSG_LEN,	\
+		  (fmt), ##args);				\
+	do_trace_netlink_extack(__extack->_msg_buf);		\
+								\
+	if (__extack)						\
+		__extack->_msg = __extack->_msg_buf;		\
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
