Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 273B46CA18D
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 12:37:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233669AbjC0Khd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 06:37:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233666AbjC0KhV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 06:37:21 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2067.outbound.protection.outlook.com [40.107.102.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63CDF2D40
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 03:37:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZElPsPVokgeUh3e/t8fUFZ0J2NgJyPj8T21UL6u0ZODvYeNxXewEF1EjhRrrWRJlDwew63VWMOSc2irnVONO4tyLB3MnWZBR3N3f+jTRzlG+2WC+cuUciEEPLOeVL56fwQulPb0avEJhro5hwy1T6qQihWxfOrtgbTyyXUj8hnwJV+WdmOGX7vZZ6WYuATHJ0rtFPnIMVsIgsTJvgHa62prljRxzxpKQWVt0QYycc/coDe8viG69GoB9RybDysv+zKYuq4LBeFFsluAQiTjcWgX4uaBWSNfNgSf0bkl7cDDvCylz9B5P87tPIY/Qy8b2rGmEiT6FgzcPlYLL+60SIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t4douRBoesjCVoasycLCrl2h6LOv89nBGTmdoQ4OZp4=;
 b=WBeXHd3AlNsD5yzn9lp9SpMU97yB8ARwefLH9hFr1+vUjhH58nslPQ+WXZLqQfryqK4k+Gkv2aJ5qC583lVasXnJKkKdlkWSpCfvukBca4V7GYrZz0LW71kFgFM3+eHvxDx8TpOSZR9uz9IRiQhxh6BLQ2l4eSeAUcTWSRmYY2gl7BsnF68L5ERnprrqWmHzUE1bYzf8z+AZMqwxZHMbI3jipGGITYQOPcYQcaFrVPlH7e/ummGybxYXez9ioPl08dZPLD4Jj9sS0VNEMzHutHsl3kDjkEITL7TAmLdCUq5doehAqpZMRTjGZrS8YJUvb4awhMY2R+x38iuheaDc3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t4douRBoesjCVoasycLCrl2h6LOv89nBGTmdoQ4OZp4=;
 b=euJfEYGF4SvxNT5gNOzJIZi0IXx6svG8v4oewrZ2rL7JHMXQayeWw+Utk8bfHVqaucHfc5ChEp5aBwpSJ0V8mKdWJs+EEQd7znZ8E4R6j9tq8T2RRt4hHfjHMJCb3TRSTJDNYas8DaIFaJFdM87gIsyksA4HCd1JT6+HBHE39h8=
Received: from BN9PR03CA0577.namprd03.prod.outlook.com (2603:10b6:408:10d::12)
 by PH7PR12MB7258.namprd12.prod.outlook.com (2603:10b6:510:206::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.41; Mon, 27 Mar
 2023 10:37:15 +0000
Received: from BL02EPF000100D0.namprd05.prod.outlook.com
 (2603:10b6:408:10d:cafe::9d) by BN9PR03CA0577.outlook.office365.com
 (2603:10b6:408:10d::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.41 via Frontend
 Transport; Mon, 27 Mar 2023 10:37:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 BL02EPF000100D0.mail.protection.outlook.com (10.167.241.204) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6178.30 via Frontend Transport; Mon, 27 Mar 2023 10:37:15 +0000
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 27 Mar
 2023 05:37:13 -0500
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34 via Frontend
 Transport; Mon, 27 Mar 2023 05:37:12 -0500
From:   <edward.cree@amd.com>
To:     <linux-net-drivers@amd.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <edumazet@google.com>
CC:     Edward Cree <ecree.xilinx@gmail.com>, <netdev@vger.kernel.org>,
        <habetsm.xilinx@gmail.com>, <michal.swiatkowski@linux.intel.com>,
        <simon.horman@corigine.com>
Subject: [PATCH net-next v3 3/6] sfc: handle enc keys in efx_tc_flower_parse_match()
Date:   Mon, 27 Mar 2023 11:36:05 +0100
Message-ID: <ed8574398db32deed2ba6ed30820322a7c1cd65a.1679912088.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1679912088.git.ecree.xilinx@gmail.com>
References: <cover.1679912088.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF000100D0:EE_|PH7PR12MB7258:EE_
X-MS-Office365-Filtering-Correlation-Id: 33cf3fd6-6733-4d89-25d2-08db2eaf3b65
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Gp29uRvf8RsYk79DWwuqMOJJDoEHA5fslqq6DP50Ok9wyZaMcu7UjU9aqII5A9K+uH6CZ1j9BFswXPwzwTtNglEYIkrlUA04mzAu8VX9We7psACfTEmFeqVxR/41OMJqVQu/QD4IAYSWxzQFJ7lP0bGa9y8v0K6YYK6z7+yI/Aind0hId8xfPuj/bdag+QT17g3PktjBy3GwSl6ozuGVovOnoQkgTnLyTPpkJ/K9rCs4f70JtbtjEo0xeb0FK66WEPe7tKY3TArNzK+X8oOGDE8Ivxd2V0mDBmhiptibp5+581xHt0PuXO+nSI0RRvyjKbkQnzHumL9xvSMpLF0YsuEzijIquInJU7DXEMIvqePbLbUQ8huygOHy+ZUz/buQij2BplRmwy1lkO6k56oFrn4Ui6upOYgYgJWfljEqGQy5BXaT3sSYmiOb0IwoWYqZPapx8E4j4NZgY87nTRubaQDe51mX33AhYcN5y6DRTz6bLIbc0o0HQQtlyRUNl8samnRh2CEK7ivObhNNMhEGWWh7lyKNouHBLigkAbuvAV995YEFRuFXLjCUjNxf508M2AXJ+VdkHj0O6SnK4XNSkxq/3qs3ebwL1bba/oV7WL3g+CD1fhYTOWhj+0Q7EVii9nvukHFYqcvJ7xcNgTQmMOiZIReHqVXsMzup1ZgF4KqwHhrUZzPEKQ40JkF6p0ORzFySHJHGHvk57Dmy6ElE13fOAswEu877/iR04Jc+qLM=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(376002)(39860400002)(346002)(396003)(136003)(451199021)(46966006)(36840700001)(40470700004)(54906003)(110136005)(478600001)(6666004)(40480700001)(26005)(9686003)(316002)(8936002)(4326008)(8676002)(70206006)(70586007)(41300700001)(40460700003)(81166007)(82740400003)(336012)(5660300002)(36860700001)(36756003)(186003)(2876002)(2906002)(82310400005)(356005)(86362001)(426003)(47076005)(55446002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2023 10:37:15.3227
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 33cf3fd6-6733-4d89-25d2-08db2eaf3b65
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BL02EPF000100D0.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7258
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Edward Cree <ecree.xilinx@gmail.com>

Translate the fields from flow dissector into struct efx_tc_match.
In efx_tc_flower_replace(), reject filters that match on them, because
 only 'foreign' filters (i.e. those for which the ingress dev is not
 the sfc netdev or any of its representors, e.g. a tunnel netdev) can
 use them.

Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
---
Changed in v2: removed bogus 'kcompat' ifdefs (spotted by Michal)
---
 drivers/net/ethernet/sfc/tc.c | 61 +++++++++++++++++++++++++++++++++++
 1 file changed, 61 insertions(+)

diff --git a/drivers/net/ethernet/sfc/tc.c b/drivers/net/ethernet/sfc/tc.c
index 34c1ff87ba5e..21eb79b20978 100644
--- a/drivers/net/ethernet/sfc/tc.c
+++ b/drivers/net/ethernet/sfc/tc.c
@@ -193,6 +193,11 @@ static int efx_tc_flower_parse_match(struct efx_nic *efx,
 	      BIT(FLOW_DISSECTOR_KEY_IPV4_ADDRS) |
 	      BIT(FLOW_DISSECTOR_KEY_IPV6_ADDRS) |
 	      BIT(FLOW_DISSECTOR_KEY_PORTS) |
+	      BIT(FLOW_DISSECTOR_KEY_ENC_KEYID) |
+	      BIT(FLOW_DISSECTOR_KEY_ENC_IPV4_ADDRS) |
+	      BIT(FLOW_DISSECTOR_KEY_ENC_IPV6_ADDRS) |
+	      BIT(FLOW_DISSECTOR_KEY_ENC_PORTS) |
+	      BIT(FLOW_DISSECTOR_KEY_ENC_CONTROL) |
 	      BIT(FLOW_DISSECTOR_KEY_TCP) |
 	      BIT(FLOW_DISSECTOR_KEY_IP))) {
 		NL_SET_ERR_MSG_FMT_MOD(extack, "Unsupported flower keys %#x",
@@ -280,6 +285,57 @@ static int efx_tc_flower_parse_match(struct efx_nic *efx,
 	MAP_KEY_AND_MASK(PORTS, ports, src, l4_sport);
 	MAP_KEY_AND_MASK(PORTS, ports, dst, l4_dport);
 	MAP_KEY_AND_MASK(TCP, tcp, flags, tcp_flags);
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ENC_CONTROL)) {
+		struct flow_match_control fm;
+
+		flow_rule_match_enc_control(rule, &fm);
+		if (fm.mask->flags) {
+			NL_SET_ERR_MSG_FMT_MOD(extack, "Unsupported match on enc_control.flags %#x",
+					       fm.mask->flags);
+			return -EOPNOTSUPP;
+		}
+		if (!IS_ALL_ONES(fm.mask->addr_type)) {
+			NL_SET_ERR_MSG_FMT_MOD(extack, "Unsupported enc addr_type mask %u (key %u)",
+					       fm.mask->addr_type,
+					       fm.key->addr_type);
+			return -EOPNOTSUPP;
+		}
+		switch (fm.key->addr_type) {
+		case FLOW_DISSECTOR_KEY_IPV4_ADDRS:
+			MAP_ENC_KEY_AND_MASK(IPV4_ADDRS, ipv4_addrs, enc_ipv4_addrs,
+					     src, enc_src_ip);
+			MAP_ENC_KEY_AND_MASK(IPV4_ADDRS, ipv4_addrs, enc_ipv4_addrs,
+					     dst, enc_dst_ip);
+			break;
+#ifdef CONFIG_IPV6
+		case FLOW_DISSECTOR_KEY_IPV6_ADDRS:
+			MAP_ENC_KEY_AND_MASK(IPV6_ADDRS, ipv6_addrs, enc_ipv6_addrs,
+					     src, enc_src_ip6);
+			MAP_ENC_KEY_AND_MASK(IPV6_ADDRS, ipv6_addrs, enc_ipv6_addrs,
+					     dst, enc_dst_ip6);
+			break;
+#endif
+		default:
+			NL_SET_ERR_MSG_FMT_MOD(extack,
+					       "Unsupported enc addr_type %u (supported are IPv4, IPv6)",
+					       fm.key->addr_type);
+			return -EOPNOTSUPP;
+		}
+		MAP_ENC_KEY_AND_MASK(IP, ip, enc_ip, tos, enc_ip_tos);
+		MAP_ENC_KEY_AND_MASK(IP, ip, enc_ip, ttl, enc_ip_ttl);
+		MAP_ENC_KEY_AND_MASK(PORTS, ports, enc_ports, src, enc_sport);
+		MAP_ENC_KEY_AND_MASK(PORTS, ports, enc_ports, dst, enc_dport);
+		MAP_ENC_KEY_AND_MASK(KEYID, enc_keyid, enc_keyid, keyid, enc_keyid);
+	} else if (dissector->used_keys &
+		   (BIT(FLOW_DISSECTOR_KEY_ENC_KEYID) |
+		    BIT(FLOW_DISSECTOR_KEY_ENC_IPV4_ADDRS) |
+		    BIT(FLOW_DISSECTOR_KEY_ENC_IPV6_ADDRS) |
+		    BIT(FLOW_DISSECTOR_KEY_ENC_IP) |
+		    BIT(FLOW_DISSECTOR_KEY_ENC_PORTS))) {
+		NL_SET_ERR_MSG_FMT_MOD(extack, "Flower enc keys require enc_control (keys: %#x)",
+				       dissector->used_keys);
+		return -EOPNOTSUPP;
+	}
 
 	return 0;
 }
@@ -373,6 +429,11 @@ static int efx_tc_flower_replace(struct efx_nic *efx,
 	rc = efx_tc_flower_parse_match(efx, fr, &match, extack);
 	if (rc)
 		return rc;
+	if (efx_tc_match_is_encap(&match.mask)) {
+		NL_SET_ERR_MSG_MOD(extack, "Ingress enc_key matches not supported");
+		rc = -EOPNOTSUPP;
+		goto release;
+	}
 
 	if (tc->common.chain_index) {
 		NL_SET_ERR_MSG_MOD(extack, "No support for nonzero chain_index");
