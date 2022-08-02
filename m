Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C222F58770A
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 08:18:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235408AbiHBGSY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Aug 2022 02:18:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230298AbiHBGSX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Aug 2022 02:18:23 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06C71F5A0
        for <netdev@vger.kernel.org>; Mon,  1 Aug 2022 23:18:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ViisEAt3wwNuvZrVzURMFggSBvDZAuIBOhfOPfI/YOjOt291RqvHRiJiY0Qb797Kh+BBsgRagwuAwu6fYZXsvgZz1vgh44SRkqP9qDN1jvNIOt3cfdNNqWn+afKbyPCgnz8/5Zp29IS3VKsWZ21aoykYb2mQnnnc4cRZtvzO0T3J+GY4rccPAljVio0S3HVXlHaqf/31txIWq8mn8opLxu3VAuJAkChElTXabG3sQCZAc+zc+oPh0jJfEKZ4/gdP85sSSy300FUJ/orGc7PnFWbEDhhhuDKEl92evp0TxUmIkSBrjBwzKLpNUgNuurH4cB4LSMRSpQrbLhRrRnc8fA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EvanBTKym0NPSWPhgLh3n/2nfa6x/j9C4au56zSpk3g=;
 b=E0+AWlUtG3+WumhYWHE8+BE9sQEnTBzB2nM8DbzTc8CaB4kL6TEZ2LifFWMRvcFxrZlM3WueZ0mlOSkUAtd2u2HKh86VQovTWBLkxydkl+jeP+U/nSNQuclc0DOmBNHgDjM3jD4Ew4GS34Q4XmztuLLS2kmA1teoN1Ksm+2hUIxXcWDNrhak1HyEBElvsEaj2nSBcJm4Hi1jglQwIZrVdNYNxtcV1oSbOpp2XEKufYAYAIkhuL57PCXYyiqwNbzqWni8BU/IuAVCxm6Cy85nSPxT2W5jt3T9hd5DjqedIP6Z0dIkUVP+4tSzlb9zLusRCuAhokFKoQd1h3ZqwZ0icA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=queasysnail.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EvanBTKym0NPSWPhgLh3n/2nfa6x/j9C4au56zSpk3g=;
 b=hNCPTmYvnP7/Qz4cUq2Or7pMj7KnYpgdBEtlA0+AQsloqALw/Bc3PSlY7qeTPub7smeI5I542keEp3aknBZzTAsy2owX8WAnaTGf9tPW0jKhG1+sbhaF+rUbE9a8tk2xbWxn/ki31ES4n6TvHUEynGxwLRR/Ft8NFD5VMIWnWH0lI+dHLhCWpfq5J5MEtJK2dif1P6yCQ689yFOxiPmvId8DU6v3MoUlchddWE+MX6txqhdOYfMujmBGXIX2NkJ+ZEN/nFrB3yyr58lFCh5vBj5A6rd8Q6YAoVAuTS90DXqVhRcOMCXXFjDGNqy40n8fXYNokOLSNUYiQl5vBXP+vg==
Received: from BN9PR03CA0783.namprd03.prod.outlook.com (2603:10b6:408:13f::8)
 by BYAPR12MB3080.namprd12.prod.outlook.com (2603:10b6:a03:de::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.11; Tue, 2 Aug
 2022 06:18:20 +0000
Received: from BN8NAM11FT020.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:13f:cafe::f) by BN9PR03CA0783.outlook.office365.com
 (2603:10b6:408:13f::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.16 via Frontend
 Transport; Tue, 2 Aug 2022 06:18:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.234) by
 BN8NAM11FT020.mail.protection.outlook.com (10.13.176.223) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5482.10 via Frontend Transport; Tue, 2 Aug 2022 06:18:18 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 DRHQMAIL101.nvidia.com (10.27.9.10) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Tue, 2 Aug 2022 06:18:18 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.26; Mon, 1 Aug 2022 23:18:17 -0700
Received: from vdi.nvidia.com (10.127.8.9) by mail.nvidia.com (10.126.190.181)
 with Microsoft SMTP Server id 15.2.986.26 via Frontend Transport; Mon, 1 Aug
 2022 23:18:16 -0700
From:   <ehakim@nvidia.com>
To:     <dsahern@kernel.org>, <netdev@vger.kernel.org>
CC:     <raeds@nvidia.com>, <tariqt@nvidia.com>, <sd@queasysnail.net>,
        Emeel Hakim <ehakim@nvidia.com>
Subject: [PATCH main v2 1/3] macsec: add option to pass flag list to ip link add command
Date:   Tue, 2 Aug 2022 09:18:11 +0300
Message-ID: <20220802061813.24082-1-ehakim@nvidia.com>
X-Mailer: git-send-email 2.21.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 66c5546a-b573-4db8-46ed-08da744ecb2e
X-MS-TrafficTypeDiagnostic: BYAPR12MB3080:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: j3dTnib62Gl7jFQEPD/LyzmIXu6fd2/0Udb5ERJEePLwtQrOUQtng1GowIcr5hf46sTXfr+qTv1VBYoiD3EkrVQ9pMXzsUoMesGgEOvErt3TzD4jQ1OQJqKc+n+6i5MnaQQRBkZRtCeOjrrlzp64VKmzVweqorSxWzydQBSXvG0kKc7BKlpBwNb5K5cvv0m1PGOXqpYQdQs55GVXMnL7rVNv3D0CHTarx2eSlQJxkWKfcDip+0jyy1mRN96VSbuvJPHzuojWNDDJTly/hVtzzyD7ZIA6G2o2pxDbRPeDHwag4bWhJDWbczOinjh87fUtYQwRYtF0Wb2R8eqaXHYvnxQ5LKXCADQBYV28OB88/TgGMdV/bZecAXqzCchpAa588J75rqOIQW6cwSbSieQdFx9yqAEbhDuosPEhEKYmBYmx31AXlWtELBplufNy8O1rAploEZFbh2Tr9Im9gd5DKGf+IeccUL8W0Q9UqcDj47JANQZtYWqdkULOmAeIsSNg12u1+SCHUg3UcCHgpzmCGY9ksEf7NtFdmb2KM5iX9KZSNcktfnqNKx8sOPYHqIeXOLBrgf2XloL37ZIexp99n2mM4wdVIND64G863EQxXMTLsMiclccTxi8hN5wGNR+o4MaGsm/QU0geUveUALwRaL6CU7VuZE1+AoE+gi236BSbRprIHZFE0bY/rUtgqse2+J5n6eLdIjKkqLnIWKV4PPK0IrM2g/ZghU9IMiIcPkrzvr21jjl4UgZtBL/q1XGZVr5+1lvjAjqHRLLkmpTuEexfAG+ieWRlKsF/V/R7pJLDZtBewYkVgCKsFqI5R5GHEJdVmR41vxZfIevAU3ZcSA==
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(346002)(396003)(376002)(136003)(40470700004)(36840700001)(46966006)(356005)(86362001)(26005)(478600001)(186003)(2616005)(1076003)(107886003)(82310400005)(7696005)(81166007)(336012)(426003)(47076005)(2906002)(40460700003)(6666004)(41300700001)(8936002)(82740400003)(83380400001)(2876002)(5660300002)(110136005)(36860700001)(40480700001)(36756003)(316002)(54906003)(8676002)(70206006)(70586007)(4326008)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Aug 2022 06:18:18.9706
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 66c5546a-b573-4db8-46ed-08da744ecb2e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT020.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3080
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Emeel Hakim <ehakim@nvidia.com>

This patch introduces a new flag list option to ip link add
command using type macsec, the patch prepares a framework for
passing and parsing flag list for future features like macsec
extended packet number (XPN) to use.

Signed-off-by: Emeel Hakim <ehakim@nvidia.com>
---
 ip/ipmacsec.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/ip/ipmacsec.c b/ip/ipmacsec.c
index bf48e8b5..9aeaafcc 100644
--- a/ip/ipmacsec.c
+++ b/ip/ipmacsec.c
@@ -1256,9 +1256,28 @@ static void usage(FILE *f)
 		"                  [ validate { strict | check | disabled } ]\n"
 		"                  [ encodingsa { 0..3 } ]\n"
 		"                  [ offload { mac | phy | off } ]\n"
+		"                  [ flag FLAG-LIST ]\n"
+		"FLAG-LIST :=      [ FLAG-LIST ] FLAG\n"
+		"FLAG :=\n"
 		);
 }
 
+static int macsec_flag_parse(__u8 *flags, int *argcp, char ***argvp)
+{
+	int argc = *argcp;
+	char **argv = *argvp;
+
+	while (1) {
+		/* parse flag list */
+		break;
+	}
+
+	*argcp = argc;
+	*argvp = argv;
+
+	return 0;
+}
+
 static int macsec_parse_opt(struct link_util *lu, int argc, char **argv,
 			    struct nlmsghdr *n)
 {
@@ -1271,6 +1290,7 @@ static int macsec_parse_opt(struct link_util *lu, int argc, char **argv,
 	bool es = false, scb = false, send_sci = false;
 	int replay_protect = -1;
 	struct sci sci = { 0 };
+	__u8 flags = 0;
 
 	ret = get_sci_portaddr(&sci, &argc, &argv, true, true);
 	if (ret < 0) {
@@ -1388,6 +1408,9 @@ static int macsec_parse_opt(struct link_util *lu, int argc, char **argv,
 				return ret;
 			addattr8(n, MACSEC_BUFLEN,
 				 IFLA_MACSEC_OFFLOAD, offload);
+		} else if (strcmp(*argv, "flag") == 0) {
+			NEXT_ARG();
+			macsec_flag_parse(&flags, &argc, &argv);
 		} else {
 			fprintf(stderr, "macsec: unknown command \"%s\"?\n",
 				*argv);
-- 
2.21.3

