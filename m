Return-Path: <netdev+bounces-4822-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9478270E92A
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 00:40:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4D1701C20A52
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 22:40:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 486A4EEDB;
	Tue, 23 May 2023 22:40:28 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3420CED5
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 22:40:28 +0000 (UTC)
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2057.outbound.protection.outlook.com [40.107.92.57])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D81CBF;
	Tue, 23 May 2023 15:40:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Txw8wEsjghms3flUMUZwcj2sYwtsTj35nI9453XvMXOOGjiqSVl8T0y2EnPfL1ng17Dy8WL8l19AptyobNLREDo7LL0Bk8NBds7CLzveGGji6vfD7JNo0QXKHcdYcdkVZjuWoJQUn8w3tWJccQsLM3dqbOWoq+ngvEiIsnbWawrRa74u5tpR1MLCzl9+pkSu470hyI8bkDCHgqGeJD+5Wc1Fp1v93owbo0EFNjOX73A2u3C+UUShCIoXsutTLZaNgl9zrpCpnHoAFtqIcnVzB0v0DdJcOIU9LHqWCpqUxhYlbsaNQWsJnyRGZEd9yNkyKvrqJ0l997TkQiLy184sZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yVR95slMPVeVhHM6nc6jlrfG95xlCOFBE/tpIAri17w=;
 b=QskypTJvJflQI9i0ys7n9TsgxPuvFtpTScZYGwnrTG/w4zqcH/bMRKmTsBrNrdndKVcVrTCXUxiPHs155KJX0anrk0gOG1H+Zi5GpyyeYPrGV6ed/ZO5jGukOURFtOyyrYe+cRKfSjc2TusIcQqt/0pVv/yZgQOtKp6pUDsV+fo29ChU91olcLC+mWDAY6He1cnj5PnMu+TaJLaPa1cGABNhJw28esPD8AAHmh1n7qUKgO7Uyz7xIaYVdmHxIkn5NPyLtdvKI8o7Uzxfsu4E5VCFha2LMIDYBLC12S0AsA2/SscVFKTsIhyiZl8xZ/H2k/sG6FA6H2a1ErIJqeKJSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yVR95slMPVeVhHM6nc6jlrfG95xlCOFBE/tpIAri17w=;
 b=x/0o+ov6cP6tBRAc/aR7eiztMzMAr+BWS6Y+SkgiQNWf+WFQtvrGNtyUO3qmvmQlDa1atcDFx5kWFD0tvPqVVizc58ld0El8a9qffTnIlIfAPeWsTzy+mz/aeA6g9LXEGFJEyffWeihqyeIoTBVQo8/eDkwu/2yEGc57zVuTMiw=
Received: from BN9PR03CA0457.namprd03.prod.outlook.com (2603:10b6:408:139::12)
 by CO6PR12MB5428.namprd12.prod.outlook.com (2603:10b6:5:35c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Tue, 23 May
 2023 22:40:23 +0000
Received: from BN8NAM11FT088.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:139:cafe::f0) by BN9PR03CA0457.outlook.office365.com
 (2603:10b6:408:139::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.14 via Frontend
 Transport; Tue, 23 May 2023 22:40:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT088.mail.protection.outlook.com (10.13.177.81) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6411.30 via Frontend Transport; Tue, 23 May 2023 22:40:23 +0000
Received: from SATLEXMB07.amd.com (10.181.41.45) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 23 May
 2023 17:40:22 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB07.amd.com
 (10.181.41.45) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 23 May
 2023 15:40:22 -0700
Received: from yuho-dev.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2375.34 via Frontend
 Transport; Tue, 23 May 2023 17:40:22 -0500
From: Kenny Ho <Kenny.Ho@amd.com>
To: David Howells <dhowells@redhat.com>, Marc Dionne
	<marc.dionne@auristor.com>, "David S. Miller" <davem@davemloft.net>, "Eric
 Dumazet" <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, <linux-afs@lists.infradead.org>,
	<netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <y2kenny@gmail.com>
CC: Kenny Ho <Kenny.Ho@amd.com>
Subject: [PATCH] Remove hardcoded static string length
Date: Tue, 23 May 2023 18:39:44 -0400
Message-ID: <20230523223944.691076-1-Kenny.Ho@amd.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT088:EE_|CO6PR12MB5428:EE_
X-MS-Office365-Filtering-Correlation-Id: e953bc36-e3e4-40ba-5fcd-08db5bdeb212
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	DW8nbXNv+FVrgCN6+YauDGcIzzMydhLsQsbheevHhYannlLaY/bEkLqvjoTOM0qqCr42reIzYN67GaDY1nk620B0d0xamI+Jm6xDCRNtFamKUes9Ba0mC9oAPYZrJbmKvvBsxleI8FVy0i6r7GzjqS7ucqPYiYQ933NLayuXOsFjJ99Z0gEjWeXY4QCrSUrlJDUDrNA3aWlGacd0EtnJOgdGOec8paDKBlBkCTsd8yqt+YcBIgEWWEDUbkHKNggx4myimKlZDr2KXUTduatB708YOX1jS8Gk6InOQuTXy0TKfhxkw8imbsXvvFz6SvDzOAOU7mZRE2fhvNRTrw9XZxQMcLRJTlayVPuFLJGMbCG8BayKCbfOdeGGEKSE2E/sXvvHRfhBuJfcN4H3XT53M18xBIB9v+4U9a3L885kSp3OhRZZr2Scz47pBl22AXiadFuL+q4DW/lW4iBInIq9qp2UY/q8kr1aF0xOg61z0LJSEG31xQplkHZtWuifF8CCdj5fW9N5FrklLjogyeBZYB3MeyGJRd5+796VwWMPW42luEKQAga+DTivEn+Iu11MD9+R5IIghkJkoATBvkPM0MA+qIpT/SPfGS76JqLxMulstFbQU4nmmx1vPrI9veBX7bziBJaeqstCsYdpaFyRQctoaYPgHr3Wvj/u4aLIDQTzTljMxPbvR+O/3c0k8WKTi5uA8W8d6j+uaNvfZzZL4ohzy8ojKhI4EG0JqFoFEed7f38TudMkVI0ZB2X3FZjOxtuEypB/W8RqEgn04w0EqWwiStCMocEp106KMdGdyO0=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(376002)(39860400002)(396003)(136003)(346002)(451199021)(36840700001)(40470700004)(46966006)(41300700001)(70206006)(70586007)(2906002)(40480700001)(4744005)(186003)(1076003)(478600001)(4326008)(6666004)(7696005)(26005)(316002)(5660300002)(110136005)(7416002)(8936002)(8676002)(36860700001)(40460700003)(81166007)(921005)(356005)(36756003)(47076005)(2616005)(426003)(336012)(83380400001)(82310400005)(86362001)(82740400003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2023 22:40:23.1004
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e953bc36-e3e4-40ba-5fcd-08db5bdeb212
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN8NAM11FT088.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR12MB5428
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

UTS_RELEASE length can exceed the hardcoded length.  This is causing
compile error when WERROR is turned on.

Signed-off-by: Kenny Ho <Kenny.Ho@amd.com>
---
 net/rxrpc/local_event.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/rxrpc/local_event.c b/net/rxrpc/local_event.c
index 19e929c7c38b..61d53ee10784 100644
--- a/net/rxrpc/local_event.c
+++ b/net/rxrpc/local_event.c
@@ -16,7 +16,7 @@
 #include <generated/utsrelease.h>
 #include "ar-internal.h"
 
-static const char rxrpc_version_string[65] = "linux-" UTS_RELEASE " AF_RXRPC";
+static const char rxrpc_version_string[] = "linux-" UTS_RELEASE " AF_RXRPC";
 
 /*
  * Reply to a version request
-- 
2.25.1


