Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 726D14F65CB
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 18:43:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237584AbiDFQgV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 12:36:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237855AbiDFQgK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 12:36:10 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2082.outbound.protection.outlook.com [40.107.93.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 942E01CD7C5;
        Wed,  6 Apr 2022 06:54:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zq5Wz0MIx83xXFdENNgYKfZwdhiABCP5qe8NNfdLpDihBO7Y3N+GgQKrMtdLgIAAfRAItaB8oUmFdQX/tWfs/nTN3yDAsZD1o+FY4En1whe8ZaL5qz/H64bWPyImESFLG27H9KZ3NBP434TkMhlzCcJmtivPH7iNwalLbqE8LGIHXRH9K9ZD7UyyXJgrRbrYbe0U2lWsN7bciSCCjcCieiVwJPZB5+N0qD9r0yzN76YhIAnLpx+TAkKvNiZXXIdY8n6JzRphtGWNUdn+0ZtbHG9HOxT8ONO7Oy43uPYvyouChsKobh1EqXenvKYirYG9iTRXY1dFacC2PW7wT45VXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=51ebBRoOpjgO7xjAcjgrfC3aKeje9aSvxO/OfJrv0ew=;
 b=jq5uVhb/8wgQeZJUc7YckYPidg3cPGQgjH4sB/N4rD4W/7j/iEvCNb1mRHUGq8A+RVJgW5g1D7l8l+mQyVfqSFvJ5vZc5WyRRz3Li73wCM2NVzUGcAwDeFenSoYnJXtpoqhDBg9Xy0fkUJrTZD4SsBvk/EBjGzxwRT/GWu0NFliQLRIWzeLtwlBJ+jT1RAV6Nbh5+cEeR9ifl/pCNh9qXA4/Sg19V0SWLNBqy0OH+pqr1Qt2EH0z6/Ltyqzqu+hErTCSs1c753Q0VL27TLqMk3ct58bjGrDE+ovwR3UQwOJ3BoL1Nwx3jvsuxpkjnfJXopQEDhyfXItQkWVy5Uq4eQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=greyhouse.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=51ebBRoOpjgO7xjAcjgrfC3aKeje9aSvxO/OfJrv0ew=;
 b=laqQQSNVy4gW/lIohl+iT1vmat1w4A0+a3PL9hVbwgIUwH3seCzO7pHnmDopWJWvrDI8V9q4dsCtEiIYU/iM8xnebiUkswzhZ0jsvTuoLejoMoXfg/ZufcbLuACWtfaJdSImCHAHyHvfcy8gw718QI3XNTJIrSfSv6bIN9vMeq55w9KyouoolvbbLyiiKXvTMKhBVTeBGv+uODHoiGXN+vbMoW+jFxNC6V8MGXPZjMbyRfezj9Tit/Hoas5Ttua2JC9X5XowqkQTAUdNBxfGBlcHfsd3LqJVPmoVa0Aia+bhVDSQUGgHelWX1Z+WUAAw22PkPxqAymp5c6vvqHl42w==
Received: from BN1PR13CA0018.namprd13.prod.outlook.com (2603:10b6:408:e2::23)
 by CY4PR1201MB0152.namprd12.prod.outlook.com (2603:10b6:910:1b::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Wed, 6 Apr
 2022 13:54:39 +0000
Received: from BN8NAM11FT005.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e2:cafe::4d) by BN1PR13CA0018.outlook.office365.com
 (2603:10b6:408:e2::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.21 via Frontend
 Transport; Wed, 6 Apr 2022 13:54:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 BN8NAM11FT005.mail.protection.outlook.com (10.13.176.69) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5144.20 via Frontend Transport; Wed, 6 Apr 2022 13:54:38 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Wed, 6 Apr
 2022 13:54:38 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Wed, 6 Apr 2022
 06:54:37 -0700
Received: from vdi.nvidia.com (10.127.8.9) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.986.22 via Frontend Transport; Wed, 6 Apr
 2022 06:54:34 -0700
From:   Gal Pressman <gal@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Jay Vosburgh" <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        "Andy Gospodarek" <andy@greyhouse.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, Gal Pressman <gal@nvidia.com>
Subject: [PATCH] bonding: Update layer2 and layer2+3 hash formula documentation
Date:   Wed, 6 Apr 2022 16:54:20 +0300
Message-ID: <20220406135420.21682-1-gal@nvidia.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 95988924-912f-46fc-2b5d-08da17d4fe18
X-MS-TrafficTypeDiagnostic: CY4PR1201MB0152:EE_
X-Microsoft-Antispam-PRVS: <CY4PR1201MB0152E46F7566A6B0428EF53FC2E79@CY4PR1201MB0152.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: y55mxTUSfTqzs2KNZiRTgqHhN52BjWfUm6ABxcGPOwDqq3THqqypnhJA0JFLXAOtA55J1pMj6Xrh1TVjwivBPcVBKpoH1rOtLuHs9lH4qiWArBIf2aOknVk3yyYPDf8lh47VwZyanxZZHjz/nuiZpTw7znB3geJCWPzMyI69F6xjKJlxVEsduOshxKWym4D2DCQ5G7JLjPG2qt/mKrBHzj+HNMOdE7w9E519i1sVWLKH15wbYWK49c7C5P1M9Dp9gEJEJ0ELLxC+ivsvPD96ElayTCNCl8ABvyX28Z75jZzvxQ2OqwkaMHqG3lrclo42h384WDzRlOc9qRiyd264R9oItAzVf/sLwMnGOVjAT1JNTsuRJzo7c8nS7X147GDtUlxoYKGJa8wSK1wIC05Wc9RVQyk8ZYgOaTqbqVP9XexUxObwEDHE73HrlBs7f6Sh0cHQJNt4uL7zW6Mgo5d/YNcPkA8fDFtQTRdDxgirSuU1FTrapWf3uTncQeh/J8Adp7ZCDN7008Kzo7Plu/aPFOe5E2FN2z3xyKFubfEPooJZxQUWh6cyDJ9lSgH5tGDQLMzGKHbPSKYtchcfGvqQzpmRoVGX3lvR1/8UM5nrV+QBO/HjyWFxi7YXi1fplE4oy6lpKRzAtOTWHVVc8Z1pbLLHLdLNDPX0wGZEOdI/MEu38lcyhLvs43wgqG7R4LTokGP37EsE7wWkQuNAHAB7tQ==
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(36840700001)(46966006)(2906002)(316002)(7696005)(356005)(6666004)(110136005)(36756003)(36860700001)(47076005)(4326008)(70586007)(8676002)(70206006)(83380400001)(5660300002)(40460700003)(7416002)(82310400005)(54906003)(107886003)(1076003)(2616005)(186003)(508600001)(336012)(26005)(81166007)(8936002)(86362001)(426003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2022 13:54:38.7974
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 95988924-912f-46fc-2b5d-08da17d4fe18
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT005.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB0152
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When using layer2 or layer2+3 hash, only the 5th byte of the MAC
addresses is used.

Signed-off-by: Gal Pressman <gal@nvidia.com>
---
 Documentation/networking/bonding.rst | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/networking/bonding.rst b/Documentation/networking/bonding.rst
index 525e6842dd33..43be3782e5df 100644
--- a/Documentation/networking/bonding.rst
+++ b/Documentation/networking/bonding.rst
@@ -894,7 +894,7 @@ xmit_hash_policy
 		Uses XOR of hardware MAC addresses and packet type ID
 		field to generate the hash. The formula is
 
-		hash = source MAC XOR destination MAC XOR packet type ID
+		hash = source MAC[5] XOR destination MAC[5] XOR packet type ID
 		slave number = hash modulo slave count
 
 		This algorithm will place all traffic to a particular
@@ -910,7 +910,7 @@ xmit_hash_policy
 		Uses XOR of hardware MAC addresses and IP addresses to
 		generate the hash.  The formula is
 
-		hash = source MAC XOR destination MAC XOR packet type ID
+		hash = source MAC[5] XOR destination MAC[5] XOR packet type ID
 		hash = hash XOR source IP XOR destination IP
 		hash = hash XOR (hash RSHIFT 16)
 		hash = hash XOR (hash RSHIFT 8)
-- 
2.25.1

