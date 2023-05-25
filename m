Return-Path: <netdev+bounces-5479-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 891207118DC
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 23:14:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0B0C51C20F41
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 21:14:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43F0024E9E;
	Thu, 25 May 2023 21:14:32 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2913A1EA8B
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 21:14:32 +0000 (UTC)
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2086.outbound.protection.outlook.com [40.107.101.86])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 479C09E;
	Thu, 25 May 2023 14:14:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hk5oQvfgc44rV0cvvZe1fuHrcPBcBBQTxfekSjkrBUeLl1dtLJYxydWEtEMRhjA4+ZuoLDh2ZcZxHIkAfpTmmc0oAt6d+4n5UQ31BvVDmhUJAtirtwFlm6w9Ebn9xWSqRlrW3nPeqk8fJIck0Bj+T2QAidPtRcaJQp9woVnQfZ7pOQHB8GYtHob+9vUKGXESg1kbmdjZyvsr1gH/l1WHQhJufqSImPM5+wQLyrMJludbcaq6L3zh2Ed+KxbNQzWYrFBeyoYhByGLB92qtl2qZBQSiTHOpau5E8Ud8KsIxnQRrdj7jInL9cFm5xZZJp/o+KYjdIZjAP+gbxWdhstovA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OnMpYLLCBQ6qeulIOv2PyoEMFubfH8Q+LayzKZcAogk=;
 b=QjwWc6w0oRsE2Z/Mpet/b1lYSk/EAi6betfTSjYMzH7dRVLXdz13R5tgq0Tbe+l+DJTMVXdD7vAjrbGt3MVj+i0FgVJm2Nyupqq3PW+iIu1vxxTmPdjU0FRhA4YW1CzCCgs798ZZShRmNJtqVyyc25oHAQd3aOfWtJve8gd/SOPVeUMB2Qpj7b0I890IZU5/zluv4RcvMmrnOlcPOljo8RbNa9xX5cmMfvXs7qmJhBuB5ftHHeC2mv8o24aFvOrXKGg2dVRhUfOYumEcTYxc3dudM58ecLUQ8o14NEBXDFpBUdI4uEATVnvbJvP8hxgRrOiVWqHxHTUjzvVNQY4K2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=aculab.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OnMpYLLCBQ6qeulIOv2PyoEMFubfH8Q+LayzKZcAogk=;
 b=e01RcUvvYNeMgdFctd6KKEOZ2pl5ryZ3A6/b4VT4yRCgIz4P8u0qRSxF0UNz92RM6b44N9gn6UJt//8LHuLgU+5DHvEFpJNipM/etsEcXstPQSe12lP6PUdYLhf4ubFFtz6im+vBkayTGhftKT0S64XPUVS9zqGaQ6WyfqnB9hg=
Received: from DM5PR08CA0029.namprd08.prod.outlook.com (2603:10b6:4:60::18) by
 IA1PR12MB6283.namprd12.prod.outlook.com (2603:10b6:208:3e5::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6411.28; Thu, 25 May 2023 21:14:28 +0000
Received: from DM6NAM11FT095.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:60:cafe::77) by DM5PR08CA0029.outlook.office365.com
 (2603:10b6:4:60::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.16 via Frontend
 Transport; Thu, 25 May 2023 21:14:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 DM6NAM11FT095.mail.protection.outlook.com (10.13.172.180) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6433.17 via Frontend Transport; Thu, 25 May 2023 21:14:27 +0000
Received: from SATLEXMB05.amd.com (10.181.40.146) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 25 May
 2023 16:14:27 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB05.amd.com
 (10.181.40.146) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 25 May
 2023 16:14:27 -0500
Received: from yuho-dev.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2375.34 via Frontend
 Transport; Thu, 25 May 2023 16:14:26 -0500
From: Kenny Ho <Kenny.Ho@amd.com>
To: David Laight <David.Laight@aculab.com>, Jakub Kicinski <kuba@kernel.org>,
	Andrew Lunn <andrew@lunn.ch>, Marc Dionne <marc.dionne@auristor.com>, "Kenny
 Ho" <y2kenny@gmail.com>, David Howells <dhowells@redhat.com>, "David S.
 Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, "Paolo
 Abeni" <pabeni@redhat.com>, "linux-afs@lists.infradead.org"
	<linux-afs@lists.infradead.org>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, <alexander.deucher@amd.com>
CC: Kenny Ho <Kenny.Ho@amd.com>
Subject: [PATCH] Truncate UTS_RELEASE for rxrpc version
Date: Thu, 25 May 2023 17:13:46 -0400
Message-ID: <20230525211346.718562-1-Kenny.Ho@amd.com>
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
X-MS-TrafficTypeDiagnostic: DM6NAM11FT095:EE_|IA1PR12MB6283:EE_
X-MS-Office365-Filtering-Correlation-Id: d9bf4e0b-bfef-41f2-19e2-08db5d650610
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	8e+3+xJJalhLVKKEHp0PA+Yn9E7cDXUweo3GTe2TNR2wbK2N+GXuuIJrphmG2y7GP36tXt0yg4e90CZdZPYzzcXUmll1160mZqy6LQ/K4C340YZzq9KSOicwcMq1orzXqYtiUZdvqQEexmOtloom5BT7tkXMgt2oyOr0BJrUSBdmgU21VDD2ikm3GnTjAteaUw/e9iOa4kit/J/+H/os6fjc3MOPiWEwh6qfxd/Q8mzir33dfW6gKP1XUPK4TqV9GkGUff+MMA2HXeUSpHKe42/d6ChTa9c4eX5i05La9EU4Gju4Xq+Znc/TnqCnRHbSIz3IZts+Blq6IOLv6kmKVhFh4/FxlDSY38Ly0iUwBNQT8hzyR1cnE50SvRFfbK5Cc4HORY3/JdNdTEeqWvBnkd8KiU5naAJqWKu3LNFumxCOjpkb/iCwjPer6Mzq1IflfrGGtutCk4xe8XPngB8OMtvrpGk/TLC+GMvaP6+oHI8Pr0j7zGhGLnsXKAPInfUgoWlCht7VLQqC1c/cudKi6Ar9YbHMn79SxIrqt8cM3Ck+OPsXi/hr9W7CuMdQu+3VUe0tMGMLxEvrH077MUV/X0lUAXODzgafm8UTqOjSDOJy9kKTR4g2m3QLdNT3Xqr5Nh5AMYc/HU11iHPFqZh2x29iSwOrEKp5FO7nDT7iY3Era8iKJ2wgmSa8YTO6yt8Vptjpq9s3xy0bHth05VpsOetOOdNWFbIJikgZfM4ZWTOHrzeJi1sLCV/dseRbrb5k9k1/GgqPymlnTZkPdxMAWw==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(376002)(39860400002)(136003)(396003)(346002)(451199021)(40470700004)(46966006)(36840700001)(7696005)(6666004)(966005)(40460700003)(2616005)(186003)(36860700001)(83380400001)(426003)(336012)(1076003)(47076005)(26005)(40480700001)(36756003)(82740400003)(82310400005)(86362001)(921005)(81166007)(356005)(70206006)(2906002)(70586007)(7416002)(316002)(6636002)(4326008)(8936002)(8676002)(41300700001)(5660300002)(478600001)(110136005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2023 21:14:27.7074
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d9bf4e0b-bfef-41f2-19e2-08db5d650610
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DM6NAM11FT095.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6283
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

UTS_RELEASE has maximum length of 64 which can cause rxrpc_version to
exceed the 65 byte message limit.

Per https://web.mit.edu/kolya/afs/rx/rx-spec
"If a server receives a packet with a type value of 13, and the
client-initiated flag set, it should respond with a 65-byte payload
containing a string that identifies the version of AFS software it is
running."

Current implementation causes compile error when WERROR is turned on and
when UTS_RELEASE exceed the length of 49 (making the version string more
than 64 characters.)

Signed-off-by: Kenny Ho <Kenny.Ho@amd.com>
---
 net/rxrpc/local_event.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/rxrpc/local_event.c b/net/rxrpc/local_event.c
index 19e929c7c38b..90af6fbb9266 100644
--- a/net/rxrpc/local_event.c
+++ b/net/rxrpc/local_event.c
@@ -16,8 +16,6 @@
 #include <generated/utsrelease.h>
 #include "ar-internal.h"
 
-static const char rxrpc_version_string[65] = "linux-" UTS_RELEASE " AF_RXRPC";
-
 /*
  * Reply to a version request
  */
@@ -30,6 +28,7 @@ static void rxrpc_send_version_request(struct rxrpc_local *local,
 	struct sockaddr_rxrpc srx;
 	struct msghdr msg;
 	struct kvec iov[2];
+	static char rxrpc_version_string[65];
 	size_t len;
 	int ret;
 
@@ -38,6 +37,12 @@ static void rxrpc_send_version_request(struct rxrpc_local *local,
 	if (rxrpc_extract_addr_from_skb(&srx, skb) < 0)
 		return;
 
+	if (!rxrpc_version_string[0])
+		snprintf(rxrpc_version_string,
+				sizeof(rxrpc_version_string),
+				"linux-%.49s AF_RXRPC",
+				UTS_RELEASE);
+
 	msg.msg_name	= &srx.transport;
 	msg.msg_namelen	= srx.transport_len;
 	msg.msg_control	= NULL;
-- 
2.25.1


