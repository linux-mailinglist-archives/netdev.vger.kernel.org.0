Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91ECB570475
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 15:39:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230145AbiGKNjK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 09:39:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229903AbiGKNjG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 09:39:06 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2070.outbound.protection.outlook.com [40.107.244.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EEC641D03
        for <netdev@vger.kernel.org>; Mon, 11 Jul 2022 06:39:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gnMfg0fCeCUsYufIgAiIefsM7zvwz7h/9szyC9pG9zNdW46vXh0ojg1fhUzUKroxY7FxqPmoh+iLBwVde4xljCgFczq82JqJPATfaqrsAS7E7V3UrUI4nOnz3r5fcvq+kCD8CAdoTcziAnRzqz3nfGvPamMygE3zu/4ix30OfT/TUMlrXX4SK0q9spRjz+/dIboJa5ndq1Q9xjNbuh2C986kfbkc6CZWL4+zK9DZ8huM1/C6lSrYU1LphbJC0ZdhlA/KnBxJlAR4OKIswDqFEE58Nm//x1lR0TNr0EGXIPpwMbBCb2m7pmgIszXSI+U948tCYDy/8mSnr5N5GjcnNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hIy3YsDxGBqOp8a75931J9Daa24GoGPUgMM6RuABzfM=;
 b=VxfjLJqX7VtMaeHVrbbnnZ6wbL+x1ZZ8I6O+o0+Z89gJ/V+mi1WAnKjKUQMa7kO7BFOLl0fjYRgk2TlEhGnLFX6WL9G041aa+fN28NLN/btsXvI3ZMsgp1DB9syLIByWlQ9AhPGqvbFJjFdmiojy1sEocJCifri5emhIbDd/RY6fa8iMpi5HhIh2FrlwPhuoECuIfALx2mJxY6ucau3CSWtNqiVsNm5xfH7LW6CRQjvcB/WV67cP+oGSjHADTXizYMgOOzzHfk4AFiCQLYhQRa9CXYwrEs0iwiUa8wWHq2DSODXj45aKvNXqqAO2I0CbjY9kyhbQG78VLXVinbx0JA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hIy3YsDxGBqOp8a75931J9Daa24GoGPUgMM6RuABzfM=;
 b=KM+pGiUDhWXiXOHbHragbp3N+pX6x4RJ11sIgWgPz8ABi3KiXx2nYtEGsEXL/fApM1z/Rq/1FKdPgla2tN0YvO8E4/oL48nsIs92s9YNUPEOiUMAHxDuBzBZl5TKJ/JumDz1bPnM3SK9xeltfd+FjGb9rbxA+j0bIcoN6Mrhh2xU934j5AaF+uoIqttNSpU+SQsdchtA1hOZ1VKL3QX3W84L0eg3A/LMvaH/mWGX2r9sQIp4ZmlDVz6z28gwkm8SyI3P5wt3TzeW5ukdL+KL2XgwwdnzbFh9fnYvqcbxxhuniSyTzlC9i+JLI/3basmbP6V0w0sds9SAQQczFZtj1A==
Received: from DM6PR07CA0067.namprd07.prod.outlook.com (2603:10b6:5:74::44) by
 SJ0PR12MB5485.namprd12.prod.outlook.com (2603:10b6:a03:305::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.15; Mon, 11 Jul
 2022 13:39:02 +0000
Received: from DM6NAM11FT055.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:74:cafe::73) by DM6PR07CA0067.outlook.office365.com
 (2603:10b6:5:74::44) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.26 via Frontend
 Transport; Mon, 11 Jul 2022 13:39:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.234) by
 DM6NAM11FT055.mail.protection.outlook.com (10.13.173.103) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5417.15 via Frontend Transport; Mon, 11 Jul 2022 13:39:02 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 DRHQMAIL101.nvidia.com (10.27.9.10) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Mon, 11 Jul 2022 13:39:01 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.26; Mon, 11 Jul 2022 06:39:01 -0700
Received: from vdi.nvidia.com (10.127.8.9) by mail.nvidia.com (10.126.190.182)
 with Microsoft SMTP Server id 15.2.986.26 via Frontend Transport; Mon, 11 Jul
 2022 06:38:59 -0700
From:   <ehakim@nvidia.com>
To:     <dsahern@kernel.org>, <netdev@vger.kernel.org>
CC:     <raeds@nvidia.com>, <tariqt@nvidia.com>,
        Emeel Hakim <ehakim@nvidia.com>
Subject: [PATCH v1 1/3] macsec: add option to pass flag list to ip link add command
Date:   Mon, 11 Jul 2022 16:38:51 +0300
Message-ID: <20220711133853.19418-1-ehakim@nvidia.com>
X-Mailer: git-send-email 2.21.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d83fd129-4cd1-4846-4044-08da6342b763
X-MS-TrafficTypeDiagnostic: SJ0PR12MB5485:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Qxsqy02SgyK+esfEt2SFR34X7hU5MIrm/qk6MKTmURRrVYW7F3gz2rnExkJWJx/5Zsg+uslGfQMv9p8inJaV+uwX916GCWY3HY+4VaB4VUwKXIDThHWLNH3l4Yu4fNFm9NXldsbOrtNgWBoXjfVIEs9J2kxWd2GFUgn0Us7Nk/4PUGUYiFdfmwhki19avlwkLoh4T4XB5PJWK5IZ4tVcvt1ULZcKGUvdo4vMOv6vIlpVCZpmLZuPT0CqQqpAnKSTP3CDZH1i5gs8mmpBldzPXAyvFKzAuPKfZdpTFW2G0PPbpuithIYCsXCjRuEnIxkRV8fs0mXMBNIHCrfAB0ymUkn5zBXYAp9/umoJMnB8VCmdjP1CBAQF17O8XCc5FGzkQbMH20zfPtl8rr7F10+r1dVrixDKd9OYYvUDY1jjki5Wt1jU1bggSY69a699rhZ/P+IWkv1+mYsjTkcawGn2JnKVZ5yf8nQcQeBBwQDU+PQoCBILJlo6uvLRUcihHV+S9+IgHQduRK+Iwj2xO+AmB3HG3xXk2uehbKuu7k7O1esdX9+F72id4X5AYic2QluxlOQ/O9nALw+kHF0Y1MdoYAD5tC8VFjJAdzQQ9eCjnUCuOf17o8dWUpgWikpHv3kziEIwxkv913LWo8ElkG7aRjkfDX150+HNZ9+mqIRgCGKvgrTkDo2qjb5nn7mALxAHiniMlDO4vi79KeUYr43/0A+AUMb1EsLdflfRljJn/9gHZI98xV0TrJL5cm46YN+hihv8jaOUufFPIcjiWj6kAk5UMc743OifDbVd4bAoplx9wvKL86VAIbRXuAJ7j9510djHjKq6FiYX2tYwYsTxfZLBmILS43XMsp+ziI6vHu4=
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(396003)(136003)(376002)(346002)(40470700004)(46966006)(36840700001)(47076005)(2906002)(478600001)(336012)(36860700001)(26005)(2876002)(426003)(110136005)(356005)(82310400005)(40460700003)(83380400001)(36756003)(40480700001)(107886003)(70206006)(54906003)(8936002)(186003)(1076003)(81166007)(5660300002)(4326008)(8676002)(41300700001)(2616005)(7696005)(316002)(82740400003)(86362001)(6666004)(70586007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2022 13:39:02.0823
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d83fd129-4cd1-4846-4044-08da6342b763
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT055.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5485
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
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
2.26.3

