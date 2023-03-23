Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9EDE6C71D5
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 21:47:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231564AbjCWUrz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 16:47:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231317AbjCWUrp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 16:47:45 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2044.outbound.protection.outlook.com [40.107.244.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68E2B1ADC1
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 13:47:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C28ZfOx9cR0XvAoTa6OFz1IYv4L0nP1QBC9GDQ7cwJdRq30tKHSvBDEEpuIXjsjw6H04wR7ST/2QdCQF95Aca9pFJZHlPJ3w+gxuO8d5gnOtmcxdrkxIVauupJfLfKgmezn6ug39R8kKwlehwxnyqSv2OsSx8LyE4ySFWpNjFfZr/bPES/YqoZI66W/KkawUuS7dz5HCxk0rMrolM1TQoTyjkhEaS/OxVDX4SsXo8kd63fYemV/6LOA4WLrH5fjjBHDG5PK5RqLNq8Ei+VfScTGbJ3rgUUsHUxZp9KtXmkk5lo/41rQd4Kosl4A3rca7LvyzZsc1HSZNInt/uaQBqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pdc84NfPUUybC75AggSbPshorNvD8zYyI0Y3CNf4Gu4=;
 b=A36JYSrRYsG35SESsBxWrS2MsKDgHOhFQfmu1PhkTdLWb9GNhIX2Spbr6yLDQdpyranemJDMPnz1XuLqMLmoONRe9ED7yjkFur/rdEZYb7gqQVheB8L1XuGI6mqHZqP6eAp9ExwGB9gURyfdTpTAeVMUz35ph5NNWbFXobp+n8xSGmK0Zh0KaQV91iFwYKkLoaQVz+Xmmi98tce8N+30E/e7wmXIDgllPDzxy6i1pv08iavpINvOI0tVQBd+Dwuj3l77+l/4mB3Gyj2DC6vpwtHbI1u5/5O0vdobwYmsMkz2ejrbiAjVP02TOcgXAGKzxwtmmWBjVimDbKy1bldVAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pdc84NfPUUybC75AggSbPshorNvD8zYyI0Y3CNf4Gu4=;
 b=JPPe536QO9Y6LywqJPrYdh7kN87T7wkaZTWhNLzcYPYmvVLpVxWwR/CIrC1QhFEoacMDcjNWRxDbq1B9srPEzsM9ru91qKhmgGgk9ECQvhHwMewSQKwk3hYALYkahlMwBkdYKNMuU9h4Cg2VHriWS/TroDT5aFwy6iEvNdKkMuA=
Received: from CY5PR13CA0020.namprd13.prod.outlook.com (2603:10b6:930::28) by
 CH2PR12MB4134.namprd12.prod.outlook.com (2603:10b6:610:a7::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.37; Thu, 23 Mar 2023 20:47:40 +0000
Received: from CY4PEPF0000C982.namprd02.prod.outlook.com
 (2603:10b6:930:0:cafe::2a) by CY5PR13CA0020.outlook.office365.com
 (2603:10b6:930::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.6 via Frontend
 Transport; Thu, 23 Mar 2023 20:47:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 CY4PEPF0000C982.mail.protection.outlook.com (10.167.241.196) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6178.30 via Frontend Transport; Thu, 23 Mar 2023 20:47:39 +0000
Received: from SATLEXMB06.amd.com (10.181.40.147) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 23 Mar
 2023 15:47:37 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB06.amd.com
 (10.181.40.147) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 23 Mar
 2023 15:47:37 -0500
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34 via Frontend
 Transport; Thu, 23 Mar 2023 15:47:36 -0500
From:   <edward.cree@amd.com>
To:     <linux-net-drivers@amd.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <edumazet@google.com>
CC:     Edward Cree <ecree.xilinx@gmail.com>, <netdev@vger.kernel.org>,
        <habetsm.xilinx@gmail.com>, <michal.swiatkowski@linux.intel.com>
Subject: [PATCH net-next v2 3/6] sfc: handle enc keys in efx_tc_flower_parse_match()
Date:   Thu, 23 Mar 2023 20:45:11 +0000
Message-ID: <a90ca2a5723ce95724286847082655f01e2e7997.1679603051.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1679603051.git.ecree.xilinx@gmail.com>
References: <cover.1679603051.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000C982:EE_|CH2PR12MB4134:EE_
X-MS-Office365-Filtering-Correlation-Id: 43f366b3-b400-47cf-2b7d-08db2bdfd797
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Z+hZkx0EFrkGNIpbJHiGWGxf0ihWQcxLK672n77+Fcmq1unwjcYjuAFiUwNrT0JL71koJA13zLBX3rq29VE/AVrcyjCyeVFsIL0FisXVv63W2N7DOyhP6nP2UBGFNpqg88Q1s7Eve9WZkAY5lEmKggQ9WIr722GQgXJE/5ql3ho4ZzmV+uKiu4dNwWAlCaKX7DIJYYmt3GiPzaC1G6zO2eZevMzuyB8Sx6SpAydhfq6WfHQZK5nK60QQwxRFJnjdvW+DxDWf75tn0twgqU+d9ShKli+vDKCJQaVEN/ZYPC7X//yT6aMurdunlD4IIXPIamW3dijUizdiCEJ1aqOB2ZUo/vk7p1FDhRlEZuM9XviQjPnq3U2nKbwDc3H3LO/Uto6+ASJPXWNgeXSrSLVmJobOrbEZwoCGa6ahA3K53lsLnY9M8suARUrbkxlVjXXY1guHPQxOw7la8Eex/bceBXTtog33qJHHO9JboCDFGc8RNjfOTzKDe7MRn2gcwTgvDBlqLWSGu8LYLlQlkZfa0e52Gb6begiyjElix5LPGGt0+xXQyNDG5dMDpits6Xtnh2nEXHN5vZmivnB+c+XSlUJfNiWWR9yqq8fI3PSrdOtXRFr9oKL/+S9nwGd0Jrb3subkwmm4W7dBF4Js8mZepKjyBHl3JbnyJqfqbvKZkg634O/S7S7OKe0cv68c1Xe/GFfic1EyH4NoxKRYXP6PsjGBmkJaIEPERFI7iL85HFI=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(396003)(136003)(346002)(39860400002)(376002)(451199018)(40470700004)(36840700001)(46966006)(40460700003)(36860700001)(8676002)(4326008)(70586007)(70206006)(54906003)(41300700001)(5660300002)(82740400003)(26005)(47076005)(426003)(81166007)(8936002)(6666004)(316002)(186003)(9686003)(478600001)(336012)(110136005)(36756003)(82310400005)(55446002)(86362001)(40480700001)(2906002)(356005)(2876002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2023 20:47:39.6673
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 43f366b3-b400-47cf-2b7d-08db2bdfd797
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000C982.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4134
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
