Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15F8562B408
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 08:35:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233043AbiKPHfh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 02:35:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232864AbiKPHfE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 02:35:04 -0500
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on20630.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e8c::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0DF313EAA
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 23:34:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PwUWmpXSBKMn+9YR7Qr/z3ujhsrAR/zK5IDS2ERMG66XtwFqOmt6TbYb40NF4rfqPM6pN99QHI4VqEHsAivdEsKOXq2zu+CecjBnvvwgYDRxe4oW4lzkicVZF1TviuCx4Q1veRlbW+C+7K5VraY2GVZPnOSAXebDNE+lVq8YDbQgLlk8ry4QTBOq/t+xsYzPq0s9x07QZrLhadxgcTLJDLIRz0K+17vXNN9iWqUONc0+yHdCnnWwunsoOj1gN5XXntGrdH/ueZOzoH7UtFwaDS7bo8XEKdJc2c6uNzcMQwtKCCWuwBoOnh76qAbP3Whz7R8zSANF62/o1vYK299bMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VtvF4AmCy1BGWCNEoJcMXDzzM96AImoN0rZD44NPlbY=;
 b=UU50APM+DkjXPv72T15vyw70YlNzWyVMCdpZB4HdIdf8XVlbM22GnpUDZY+iCRh/YayZAvxGRoOMqe0LGLhkW0xFIivJR0PN/f2wq+IBxmmwpRFj9COnZOa9u22d1hUiBzHkIYBAQZBXRthyYcp/IGTHvC26e28l8/7csll9fAP7ggKZG5aIWlh5gZN+8aCxsCGZplHJdtSFLenaLdnm2B6n97eBqUWERia3piQr3KMNCdhqEL9ig3xIN+tV4cfFkZRSD7Q3dtPluyPv/vgmIy9Zz+GtXhm/GgqUa/8cgv12X2JluOtIL7QcYfHFq9giHux6oMFAR/tPx/XKovFM2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VtvF4AmCy1BGWCNEoJcMXDzzM96AImoN0rZD44NPlbY=;
 b=RKVffFlYhO+glY3grjtB7RItxe7+CxM1PAO4yFZE1wEI5GZkDBB8qf1zuvhiAG0nY23hyKWncpArEIlnCPKz0/D9V6VA2jAyYGP8eU8q95Fhf3ah4LGZMBtykvDiEjIwdGRQpdPU0wF67xbVMkB7WdJpDKIalqdxZGrj84WEG/7l0nPfyRRaeDsPRfexfiDpVvCuPAaRGGh1zg2BwFOzxGwew7UCkcUEx7L8DWd5bGuygL7040cnCZbHozCYH8nXbTdzHXK7Krej2p5hH6GUCDHvOqZ0Y/iXFDAZMRyGfi637BtwE8kx2TG1vpzA5vnh/pZRmDr7VShDI6JaAhFwmw==
Received: from DS7P222CA0006.NAMP222.PROD.OUTLOOK.COM (2603:10b6:8:2e::23) by
 PH7PR12MB7428.namprd12.prod.outlook.com (2603:10b6:510:203::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5813.18; Wed, 16 Nov 2022 07:34:01 +0000
Received: from DM6NAM11FT088.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:2e:cafe::49) by DS7P222CA0006.outlook.office365.com
 (2603:10b6:8:2e::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.18 via Frontend
 Transport; Wed, 16 Nov 2022 07:34:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 DM6NAM11FT088.mail.protection.outlook.com (10.13.172.147) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5834.8 via Frontend Transport; Wed, 16 Nov 2022 07:34:01 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 15 Nov
 2022 23:33:38 -0800
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Tue, 15 Nov 2022 23:33:38 -0800
Received: from dev-r-vrt-138.mtr.labs.mlnx (10.127.8.10) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.986.36 via Frontend
 Transport; Tue, 15 Nov 2022 23:33:37 -0800
From:   Roi Dayan <roid@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     Roi Dayan <roid@nvidia.com>, Paul Blakey <paulb@nvidia.com>,
        "Stephen Hemminger" <stephen@networkplumber.org>,
        David Ahern <dsahern@kernel.org>
Subject: [PATCH iproute2 1/2] tc: ct: Fix ct commit nat forcing addr
Date:   Wed, 16 Nov 2022 09:33:11 +0200
Message-ID: <20221116073312.177786-2-roid@nvidia.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221116073312.177786-1-roid@nvidia.com>
References: <20221116073312.177786-1-roid@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT088:EE_|PH7PR12MB7428:EE_
X-MS-Office365-Filtering-Correlation-Id: 21b2057d-9f60-4665-8dc0-08dac7a4ee51
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8wiZRDiBb92Twzhnnn7bYmOFYhn4z3VHnHttzl0H9n1lWyq1zBzOXjcg5i/nhSeTJmocvrqmF9LOrHAMbBmUKwTQ44RpxEVUO3umoqSmm2C4KnA4xgFTxHa+VlhEdRAMSkZ6urmjnRN/+3RwsIsK2gJZb3rdORcBVNs+D/rfr1hXyjNrluYnY1xUxAlTYBgUIABqvv8NXr5nsCzxg3eVuqkGm2Bm7nqKCz1Zdo1f9oPsu5vhQp8DRegdSfcMuD5/XL4y+VoPQ/RK4I0+lZiQIllnMdg43Ayuxm8i5BOQv/oYVHM45vqdhGWpi+1wQq5Q/7UEbUSZqBfNyaqCKmUUPFBAGE7xrZAB0IZivrYGV8sSy83eSR9FAX9JSWbPHKKBY8F1tQbmQ4OUwUaO4R3whDMfkb0eomIcYftl0oDz6tY+atjA2gc7iAh3QWfPyrXBXU9Kj0d4g4S0dHak++R6lNOvmZPR2t6gGdZoEL+qE9xiHlU2APexMPr1y4htcnnnRS5F9fDLvWC3yVigrAfebE+3AztAmnq5eoXIuP3j10vVYAx1uxwRQuQw330/fYvB2WAS5SL3wU5Cdqt4FpClHzsN4/cBYQTj+5Ho0fF6V/oO1w8iLG/uNYrj+EVbX+wvaWt5nP8f1vmhnUCCwv+cVOM9lXs8bX3iOlNvHM3fQgCFYGAggg+RE/Mck54xp9/iiHu7H13GKu7Z24Cd6+wdmV6Pb27X92vnGFyW+Yx9FbRMl1M256P5tkUefZMD4mVwuAwouHFPlDA3g78WBaiNOQ==
X-Forefront-Antispam-Report: CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(396003)(136003)(376002)(346002)(451199015)(36840700001)(40470700004)(46966006)(5660300002)(40460700003)(316002)(6916009)(54906003)(41300700001)(1076003)(8676002)(4326008)(47076005)(36756003)(336012)(2616005)(426003)(186003)(70586007)(70206006)(82310400005)(7636003)(82740400003)(83380400001)(8936002)(356005)(36860700001)(86362001)(40480700001)(2906002)(6666004)(478600001)(26005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2022 07:34:01.1670
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 21b2057d-9f60-4665-8dc0-08dac7a4ee51
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT088.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7428
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Action ct commit should accept nat src/dst without an addr. Fix it.

Fixes: c8a494314c40 ("tc: Introduce tc ct action")
Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Paul Blakey <paulb@nvidia.com>
---
 man/man8/tc-ct.8 | 2 +-
 tc/m_ct.c        | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/man/man8/tc-ct.8 b/man/man8/tc-ct.8
index 2fb81ca29aa4..78d05e430c36 100644
--- a/man/man8/tc-ct.8
+++ b/man/man8/tc-ct.8
@@ -47,7 +47,7 @@ Specify a masked 32bit mark to set for the connection (only valid with commit).
 Specify a masked 128bit label to set for the connection (only valid with commit).
 .TP
 .BI nat " NAT_SPEC"
-.BI Where " NAT_SPEC " ":= {src|dst} addr" " addr1" "[-" "addr2" "] [port " "port1" "[-" "port2" "]]"
+.BI Where " NAT_SPEC " ":= {src|dst} [addr" " addr1" "[-" "addr2" "] [port " "port1" "[-" "port2" "]]]"
 
 Specify src/dst and range of nat to configure for the connection (only valid with commit).
 .RS
diff --git a/tc/m_ct.c b/tc/m_ct.c
index a02bf0cc1655..1b8984075a67 100644
--- a/tc/m_ct.c
+++ b/tc/m_ct.c
@@ -23,7 +23,7 @@ usage(void)
 		"	ct commit [force] [zone ZONE] [mark MASKED_MARK] [label MASKED_LABEL] [nat NAT_SPEC]\n"
 		"	ct [nat] [zone ZONE]\n"
 		"Where: ZONE is the conntrack zone table number\n"
-		"	NAT_SPEC is {src|dst} addr addr1[-addr2] [port port1[-port2]]\n"
+		"	NAT_SPEC is {src|dst} [addr addr1[-addr2] [port port1[-port2]]]\n"
 		"\n");
 	exit(-1);
 }
@@ -234,7 +234,7 @@ parse_ct(struct action_util *a, int *argc_p, char ***argv_p, int tca_id,
 
 			NEXT_ARG();
 			if (matches(*argv, "addr") != 0)
-				usage();
+				continue;
 
 			NEXT_ARG();
 			ret = ct_parse_nat_addr_range(*argv, n);
-- 
2.38.0

