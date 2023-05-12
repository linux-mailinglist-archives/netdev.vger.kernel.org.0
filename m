Return-Path: <netdev+bounces-2227-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C07F3700D2F
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 18:42:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C65BC1C21307
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 16:42:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9B33200AE;
	Fri, 12 May 2023 16:42:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5AA1A32
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 16:42:30 +0000 (UTC)
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2083.outbound.protection.outlook.com [40.107.100.83])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45AB12D43
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 09:42:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QUb2PwbDH8tBQfdcbkRe3QLdojZ9Q4xhIQ6QwixsVNo/1/YKxK8f5vblOgeyZv5kliysMEIttDaNru87oEwAqo6ySa3TvQ3jKLpQ123xPr9hqOb236gwnKJwjPALesF+eOUSucIHesOrIq5vAwWJVnplaU0u1zF00CozjCqjXdNfbBiuQNjaPpcvuITGRncESA5a2iLjPlqR63Tq4nqvVQt5Gv4aJKqN/RPNlma5lrwDk5Sk694/Yd5lfpnKNXalQH+1BeRMRbRaQ62aWhnM2wC5mJqnZ/rViBmeUtjnbbNMUALRcQrqyBPonXKZLS5MXpkd5TSwYf1BgZLdc44D1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CGkPv1ctrZW9CN0lt+rts3somr25zx/uF5ZLD3356wY=;
 b=dTjxm4c63oJZ4C6OPL6u3jwspEp3f6wB003nuZ2Q8dLEktUUcaToB9Kg0PvoZAa+NV6mruuUxEXDoEr94m5w+c90rOn/YtM8507lPo8hJt74mmtcpuLrGuQjgvZ+mLvNBq44lYCTBJfeXwvHMMKX3EzxBcXweoKseWL9L4lOjMe4iRmmcAwvDKsFgHvSaI4J5rb18pL3uq2sawmgb0OehWvQ4QkoHG5H+AfZ9194jh3cZdsgUYNqFMQLma7fOtgGf8Mm6H9SDECYnOQPA3yNUUcXM4xIK2SttpYe6VpAWyveNCxKDp7xKc2Df+2E0YePiPxsto7S8MFJvCadYBJxAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=temperror (sender ip
 is 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com;
 dmarc=temperror action=none header.from=amd.com; dkim=none (message not
 signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CGkPv1ctrZW9CN0lt+rts3somr25zx/uF5ZLD3356wY=;
 b=HSNQFHWto+sDOFEik4NkrzCHcHFDDXs7zuLQzUiSvcwXQPaRHC7usQ47AZp1zX5frSAHdSQ0hSmVOqNjO76YmVDxrMBaWCZQW3OT9c4JouIryGAkqh+EUeZ/AYloH/HbaktPs/TolwFQuCcAi2zL9b1jtKSY81mZ/G6GVSiJxZ8=
Received: from BN0PR02CA0053.namprd02.prod.outlook.com (2603:10b6:408:e5::28)
 by MN2PR12MB4550.namprd12.prod.outlook.com (2603:10b6:208:24e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.23; Fri, 12 May
 2023 16:42:27 +0000
Received: from BN8NAM11FT083.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e5:cafe::7d) by BN0PR02CA0053.outlook.office365.com
 (2603:10b6:408:e5::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.24 via Frontend
 Transport; Fri, 12 May 2023 16:42:27 +0000
X-MS-Exchange-Authentication-Results: spf=temperror (sender IP is
 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=temperror action=none header.from=amd.com;
Received-SPF: TempError (protection.outlook.com: error in processing during
 lookup of amd.com: DNS Timeout)
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT083.mail.protection.outlook.com (10.13.177.75) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6387.24 via Frontend Transport; Fri, 12 May 2023 16:42:26 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 12 May
 2023 11:42:24 -0500
From: Shannon Nelson <shannon.nelson@amd.com>
To: <dsahern@kernel.org>
CC: <netdev@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
	<mst@redhat.com>, <jasowang@redhat.com>, <shannon.nelson@amd.com>,
	<allen.hubbe@amd.com>, <drivers@pensando.io>
Subject: [PATCH] vdpa: consume device_features parameter
Date: Fri, 12 May 2023 09:41:45 -0700
Message-ID: <29db10bca7e5ef6b1137282292660fc337a4323a.1683907102.git.allen.hubbe@amd.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT083:EE_|MN2PR12MB4550:EE_
X-MS-Office365-Filtering-Correlation-Id: 69057f1b-49d8-4878-b849-08db5307de34
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	p7b3qB/7UtH+QPmL0Wubq/9fQtKa97WIr9rzqRhcS9rFF8zL3kFGMz5eABJSdZXEdyKzDewFMlFZUbjEJVYjCkxH11MtJvtYgjNW67QpVVutNUswPFb7Y193PGoEI108ly6ZzWzloQbXF/hsLaBaDVItdP2pGcYm9a09leEgslC6m8ekgee299sOMZcBCooprRh/WwV4Bk6kVLAAc+8+hguGe+HZ3Q1YwclETH9J2y+GXsDSgxiurpMTaVCzZfLIfYUgO0xcBq269XSjfnU9ZCrdE7EMVoXLsS9O+jvoBIueXo0homxHJ5uGRTVZMoSxDl+WutPRp1hi8INmNj9x9T74ZgALCym4EfP/X2mEWm3GH7IDO2MtE2MX/BbAF9I6b7U3iSrdpY4J1cmIz+1QiJfqEIg5vPZac9PY+3N9vKXP34J+vwQgtWAfyw5mWgqvnA1bV4biC/EhTCprIxs52+nMwvdf5ZbA0B+NKvlMhoWcQ9sWbKayuLQSmPz0I6vv0CL8JcRDRiL/k6p3JPVEm7C2f+MAUDfDIsutMa48AKZ+HUz8oYzTgggSEyEPVdobu6DPiWx7XttYHcUPtSI2UUSdVNjnRAjSYee8S8zqsYMAhhI89CO0DiGjNUpZMVvNFq9Ew9PoVK/br0qnnAs6aKNkptfEHrNqJH8WV0N2z74ZwthZpNKXrCQ9XRhhKwbNvaVeRY5JkCclduD+SHap2z/0A8ceOJBC2VOrcV4e/zlmfDrXUzf7F3ti2r2vPEbFvGR+pzkLgBDHiZh3bYJydQ==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(346002)(376002)(39860400002)(136003)(396003)(451199021)(36840700001)(40470700004)(46966006)(81166007)(356005)(41300700001)(6666004)(82310400005)(4326008)(6916009)(36756003)(316002)(4744005)(2906002)(70586007)(54906003)(86362001)(40480700001)(70206006)(478600001)(82740400003)(40460700003)(47076005)(44832011)(426003)(2616005)(336012)(36860700001)(63370400001)(63350400001)(5660300002)(26005)(8676002)(16526019)(8936002)(186003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2023 16:42:26.0461
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 69057f1b-49d8-4878-b849-08db5307de34
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN8NAM11FT083.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4550
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Allen Hubbe <allen.hubbe@amd.com>

Consume the parameter to device_features when parsing command line
options.  Otherwise the parameter may be used again as an option name.

 # vdpa dev add ... device_features 0xdeadbeef mac 00:11:22:33:44:55
 Unknown option "0xdeadbeef"

Fixes: a4442ce58ebb ("vdpa: allow provisioning device features")
Signed-off-by: Allen Hubbe <allen.hubbe@amd.com>
Reviewed-by: Shannon Nelson <shannon.nelson@amd.com>
---
 vdpa/vdpa.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/vdpa/vdpa.c b/vdpa/vdpa.c
index 27647d73d498..8a2fca8647b6 100644
--- a/vdpa/vdpa.c
+++ b/vdpa/vdpa.c
@@ -353,6 +353,8 @@ static int vdpa_argv_parse(struct vdpa *vdpa, int argc, char **argv,
 						&opts->device_features);
 			if (err)
 				return err;
+
+			NEXT_ARG_FWD();
 			o_found |= VDPA_OPT_VDEV_FEATURES;
 		} else {
 			fprintf(stderr, "Unknown option \"%s\"\n", *argv);
-- 
2.17.1


