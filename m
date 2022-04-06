Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74E114F635B
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 17:34:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236298AbiDFPbe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 11:31:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236136AbiDFPbX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 11:31:23 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2064.outbound.protection.outlook.com [40.107.220.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38AF669718F;
        Wed,  6 Apr 2022 05:42:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q57vXZK1fL3cMGE7Tj0VnH7U//UN9fuQUWg+jbtDuydIUuZvBxV5kTrSevga76dNsBDJucC9xNeYuXPWeSo7VEHjdPJBilcvCHAXBly8sxH7VK/utQBAmtLfOHAbAp0FkTxPXPKKMdEx0et5o+xgQf8+unWPRioGOvqEuvLPIe7FxCGU8uH6vRGqv5oWIMgDtAW2Ns0XYk7anEpR5CWlpyda6KCLUDtrHfzbzeBt5skHGs7NW4+CvbMUY3Y00XD2tPsfwIlHy5XOMMH8fuN9uU/zeyPXvY5uzGgHC7n2EFGu6Cg0U7zOlk1WrTesM15uUupVA4Cgg+J15xGRJW9xhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JyEmuYJyu3qzg30My0LkTXGWMVX0B3AzB57sjkGZChg=;
 b=L5fslhE7d7ol+PdLyiqc8wfiwMTcrjea4sOA9G3rbXv0p8wOx6HBqdbG3l4wpVqJ0HcuJmEU5Z6Vv9TcfyHFxFNV//9fQmQZlravkztMOKbFtBBiEjY2rkSBjFQ7G8I5BYmTi8u5jcAEF2KiPIEbQB9ucaTI3PNJB9XYsZHoVs+pNubg4zngSe+dJi0Vl8GCm+zEZiCl/gSxGE700BTwQqxwfo39Y3La2lVbdS6KJb1N/ZwhX+t4egDX8PAsgAcvJ7a5uBYwCK+iPYwt15+7vQqYfvjhkZKJ0dkeRZF3GPYE6HVGlLR1Dk6omLTs0lAtOMx3dCmK9CeCTzyBdjgxlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JyEmuYJyu3qzg30My0LkTXGWMVX0B3AzB57sjkGZChg=;
 b=fFcZUv9uixlYO/2713KxMeYYrL/8OyuHVIo4x4BkZqslXK3aaxrvZh0Oufo0q6N7D8jOhB6mIUmUPNChP6tYNLUs04L2PeJqnasIS5zIRoML4s9pbS5AxEaCwJJECsXasCEfRnA0EzDATBafIIFINUbHqYz5dOGadrY7UEH7XJRZ4wHCWlwAHeWqt+DSia0GrascH8fTQxX8vcaLbzfgIiGAbehm3DmMo0FYCX6WKHeVJUcTpnrmGRvvSO0hWNILd+ePX22MuXCawNCsGSkmsslDEReRqQhYyXlRzsgq2YDybLLfkG3Wexk/Wo8mWcQNE++iXq2wuoePfEYA4HgXsQ==
Received: from DM6PR03CA0088.namprd03.prod.outlook.com (2603:10b6:5:333::21)
 by DM6PR12MB3052.namprd12.prod.outlook.com (2603:10b6:5:11e::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Wed, 6 Apr
 2022 12:41:43 +0000
Received: from DM6NAM11FT015.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:333:cafe::f4) by DM6PR03CA0088.outlook.office365.com
 (2603:10b6:5:333::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.21 via Frontend
 Transport; Wed, 6 Apr 2022 12:41:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 DM6NAM11FT015.mail.protection.outlook.com (10.13.172.133) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5144.20 via Frontend Transport; Wed, 6 Apr 2022 12:41:43 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Wed, 6 Apr
 2022 12:41:43 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Wed, 6 Apr 2022
 05:41:42 -0700
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com (10.129.68.9)
 with Microsoft SMTP Server id 15.2.986.22 via Frontend Transport; Wed, 6 Apr
 2022 05:41:37 -0700
From:   Maxim Mikityanskiy <maximmi@nvidia.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Arthur Fabre <afabre@cloudflare.com>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        "Maxim Mikityanskiy" <maximmi@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH bpf v5 1/2] bpf: Support dual-stack sockets in bpf_tcp_check_syncookie
Date:   Wed, 6 Apr 2022 15:41:12 +0300
Message-ID: <20220406124113.2795730-1-maximmi@nvidia.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 88f42e7e-5005-4f42-3fc0-08da17cace49
X-MS-TrafficTypeDiagnostic: DM6PR12MB3052:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB3052F4BBB83FEFB19AAFD794DCE79@DM6PR12MB3052.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kAn+4pUK64ojKO5t/BtZeriGy1udGMN0JYM80SVeXcQEcNlwzzvFTD/7YfREG22tek10jiAN3aujP9nUWx26qLVfJ7klN4Djd0vneleMv5YC30qVV/XUCBwe7jQx18bOQdi1vpSIyHwAq134xgsPjbZ0kO2BcbNLWjcnaYYfIDGn8HYgP72bIPvoz6xIvK1jTxaFnLafIJufkRr3aR6XvQcjgAiU/Ivpm98PvC3Dtbu0N0b9Qt/dCYtbtH2FI0aeao3R9ThfOhz1DCeamyp6FraXwp+W4B5lEIs+LJ2e1A6x5ltj1lcJnDEpzo647fnff6rKtrwn4LBAOYpUnwWL/jI9eB46wraO82XiltkLBwTkU0fQjytZ8Zxt6aTvJhQbM6Cu4ydcdZ3CBB2Bs8uVjHGttZoVTH/g9XAf0Y6c/KM8utyHE7et/74SdOZFxCQPLaCsApbvqVlMv6uZDHKkZFnZtTUGNh8PiQSJllOtam3Cc981rJKgoIIXIk5LVsZwdVTcOIwes3DPFiokKHRqxKEZ2NIa7ZLfTYitHkjWVIgtfrKqIila/I1wL3IwrPZ/+kpkGlFOdWEPeSOu+Mgv2533huj98BSZwib9ao7MbO9ee8Bc9mA6m+96G4ZL8WDeKgxgP+wQmXCPcbjsiuGm5C5o0ngJh/8/B8kGu6kWg0IqykD4RiP+ry+R4CGigJb8JZ5wWrrQmudEVPF2skk7nw==
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(6666004)(82310400005)(40460700003)(186003)(83380400001)(1076003)(47076005)(86362001)(316002)(26005)(336012)(508600001)(7416002)(5660300002)(426003)(8676002)(36860700001)(70586007)(36756003)(70206006)(7696005)(4326008)(8936002)(81166007)(107886003)(110136005)(54906003)(2616005)(356005)(2906002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2022 12:41:43.6992
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 88f42e7e-5005-4f42-3fc0-08da17cace49
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT015.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3052
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

bpf_tcp_gen_syncookie looks at the IP version in the IP header and
validates the address family of the socket. It supports IPv4 packets in
AF_INET6 dual-stack sockets.

On the other hand, bpf_tcp_check_syncookie looks only at the address
family of the socket, ignoring the real IP version in headers, and
validates only the packet size. This implementation has some drawbacks:

1. Packets are not validated properly, allowing a BPF program to trick
   bpf_tcp_check_syncookie into handling an IPv6 packet on an IPv4
   socket.

2. Dual-stack sockets fail the checks on IPv4 packets. IPv4 clients end
   up receiving a SYNACK with the cookie, but the following ACK gets
   dropped.

This patch fixes these issues by changing the checks in
bpf_tcp_check_syncookie to match the ones in bpf_tcp_gen_syncookie. IP
version from the header is taken into account, and it is validated
properly with address family.

Fixes: 399040847084 ("bpf: add helper to check for a valid SYN cookie")
Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Acked-by: Arthur Fabre <afabre@cloudflare.com>
---
 net/core/filter.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index a7044e98765e..64470a727ef7 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -7016,24 +7016,33 @@ BPF_CALL_5(bpf_tcp_check_syncookie, struct sock *, sk, void *, iph, u32, iph_len
 	if (!th->ack || th->rst || th->syn)
 		return -ENOENT;
 
+	if (unlikely(iph_len < sizeof(struct iphdr)))
+		return -EINVAL;
+
 	if (tcp_synq_no_recent_overflow(sk))
 		return -ENOENT;
 
 	cookie = ntohl(th->ack_seq) - 1;
 
-	switch (sk->sk_family) {
-	case AF_INET:
-		if (unlikely(iph_len < sizeof(struct iphdr)))
+	/* Both struct iphdr and struct ipv6hdr have the version field at the
+	 * same offset so we can cast to the shorter header (struct iphdr).
+	 */
+	switch (((struct iphdr *)iph)->version) {
+	case 4:
+		if (sk->sk_family == AF_INET6 && ipv6_only_sock(sk))
 			return -EINVAL;
 
 		ret = __cookie_v4_check((struct iphdr *)iph, th, cookie);
 		break;
 
 #if IS_BUILTIN(CONFIG_IPV6)
-	case AF_INET6:
+	case 6:
 		if (unlikely(iph_len < sizeof(struct ipv6hdr)))
 			return -EINVAL;
 
+		if (sk->sk_family != AF_INET6)
+			return -EINVAL;
+
 		ret = __cookie_v6_check((struct ipv6hdr *)iph, th, cookie);
 		break;
 #endif /* CONFIG_IPV6 */
-- 
2.30.2

