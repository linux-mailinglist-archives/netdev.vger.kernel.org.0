Return-Path: <netdev+bounces-10595-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6EC0E72F401
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 07:12:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 288402812B8
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 05:12:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6BC64642;
	Wed, 14 Jun 2023 05:12:14 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D8EF361
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 05:12:14 +0000 (UTC)
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2078.outbound.protection.outlook.com [40.107.244.78])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E49F1A5;
	Tue, 13 Jun 2023 22:12:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P3uTUDq3SxJu6xA9QL+2h6L8PYEiWu6DgUHsye23IIHeMGi42Wgx3zlX0SrVZQPZAW3IG7vUYIjXNneiFqOJsjrVZoKZMcQHO+9r4pSLJPIyCbX+rsi9v87TWYxURqQ7rW/FUA4wURTbEa26MokbEeXC2VhUQB9WHjYZQNDfnTqP0q1vMX+8j7CKA3G5OQ+akyLhlwj1OmauZWcp8hAJ+rS/2WC8JPuflOWeAeohhfVbB+SheZLW7MVs7B2KYNuug4/Epc983bPtt1u82dX9MEqG5W7ve+n9s+qwmsgmISd8xPwSfBGWhRjsCEXfICSI3zA4NWjYUI0D8SzaFBsXcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Hm/tu4mz5Gmz2Ja041/NOVvk5LY/67kdp0CN3dLue+4=;
 b=it20rpuPqi3Vb2an61aQcCA54OZEeLhtCqXM3LOiCE6JRboFftIaPJgbvsCYef6NFzMmt0aZmP9g+gHmvXQuS6wKvLPhsysn48wG4Ctr/FvELu8vd84ivCNWQ47r7L6UAMZhoeEKvICzLDR8YSMFd4gAfSHMwAh/sppateY9+XJkKuMomHkiwgRj9XuTeGNy8fVASO/6tlha8TqSXElchWGD+hxAKJxY8Rfo4gIp+2EXgVG1n/lYDijdVwca+jvUsDzDhRr8Gz2tmMQgZ+z95xTlkIuxJoYEs6nnogjkvO+RutgzpyBSR+IekTHU/h+vBB2vwmnhu1KZo/KVfZPVgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gmail.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hm/tu4mz5Gmz2Ja041/NOVvk5LY/67kdp0CN3dLue+4=;
 b=RsnUkJAxJKvizgPSrEARZMn7z0NG6P1ks1Bm5LlQgRn7/nUay9CSkFW8YpSoSGm53clk52MSnxW/4nvYpPsu1o2CroLmKBWAGk9v5ijZRW3+/ETAxYIxVSxPfDJMqQWZWcJt2oqMrBmCWcZMM2JGqdeauYd/hsMQeckvCcDjfPg=
Received: from DM6PR02CA0074.namprd02.prod.outlook.com (2603:10b6:5:1f4::15)
 by DM4PR12MB6373.namprd12.prod.outlook.com (2603:10b6:8:a4::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6455.41; Wed, 14 Jun 2023 05:12:09 +0000
Received: from CY4PEPF0000EE3A.namprd03.prod.outlook.com
 (2603:10b6:5:1f4:cafe::80) by DM6PR02CA0074.outlook.office365.com
 (2603:10b6:5:1f4::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.36 via Frontend
 Transport; Wed, 14 Jun 2023 05:12:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000EE3A.mail.protection.outlook.com (10.167.242.14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6500.25 via Frontend Transport; Wed, 14 Jun 2023 05:12:09 +0000
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Wed, 14 Jun
 2023 00:12:08 -0500
Received: from xhdsneeli40.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2507.23 via Frontend
 Transport; Wed, 14 Jun 2023 00:12:05 -0500
From: Sarath Babu Naidu Gaddam <sarath.babu.naidu.gaddam@amd.com>
To: <richardcochran@gmail.com>, <netdev@vger.kernel.org>
CC: <simon.horman@corigine.com>, <andrew@lunn.ch>,
	<linux-kernel@vger.kernel.org>, <vincent.cheng.xh@renesas.com>,
	<harini.katakam@amd.com>, <git@amd.com>, <sarath.babu.naidu.gaddam@amd.com>
Subject: [PATCH V2] ptp: clockmatrix: Add Defer probe if firmware load fails
Date: Wed, 14 Jun 2023 10:42:04 +0530
Message-ID: <20230614051204.1614722-1-sarath.babu.naidu.gaddam@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE3A:EE_|DM4PR12MB6373:EE_
X-MS-Office365-Filtering-Correlation-Id: 375ad525-3808-4360-fa2d-08db6c95e7c6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	Lda0sWyNLQAYV4rdB0+/ANauYxvEIDfCY/RabtYFQm2LY+ukIzIZgrwUYdZSbjfIo38QixR5wpTMuXQH4LDTHcujaMaiQzgccccSM5Sfkwqt3NvgkJQlix+4PpgHnxvHY/c++2RXII3aPDUUee9cpf1UXnVH66a+n3xC3Ku364x4cTGELodcbvB0XNCtE17dTnJ+z48Yx5Cd10ksFYPcIhkNHy0rMJ+q8MJwb+A3V3T51Sx3l/NWqe0kSwPuUeOZX2DHCHIZf4kIlDAmR7yWm86dFfgzFROZV0SHa3tOloWEezdlVvPN5NBmhxBzmlIRpOM6QtQypnB+Mdh0dKJ8/USBjOPwQkQjzC86TRS8VY2Xio543bu6OeXg9iUOXwVMjlx1fGCK4/gEk8r3l9SwJePoZYwekyPkaiFUFP44fJxrMIAWDj4P0ExMFJojYljtuS3YWrHMFjtJ7J1VICeL1mL0p2FisL1LVsRyqWI6fC7eg1qacyjtKcsP7IIj2D2Y6d86olJQ2vteyTtQ54wYZz/yJ1xc0vz0kyaPx35QOilzEn9Xb9fG7Ohzy7dE8rSrNlBCOUkJwOLaxPem9ErqRMZeNwwaT/TD9d6ssfZBrTFaehedXi3G5wgsnnYRUfE5e5dbp87K7K9lrifS4vJgpRGxLNxJQ9dirqVedSPoZmCjY537kR0U+wLlrinMxFB0MxHFwkcvgwk3u2K92zeisb9j53MaFgsYydEnipiof5nVzPhRBIxnw3VfCV1LYu8S7m3DHxHehOL2rsUr+DDlTA==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(346002)(39860400002)(136003)(376002)(396003)(451199021)(40470700004)(46966006)(36840700001)(86362001)(40480700001)(36756003)(103116003)(82310400005)(81166007)(356005)(82740400003)(40460700003)(478600001)(110136005)(54906003)(8936002)(8676002)(5660300002)(70206006)(4326008)(41300700001)(316002)(2906002)(36860700001)(47076005)(336012)(2616005)(426003)(83380400001)(1076003)(26005)(70586007)(186003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2023 05:12:09.6467
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 375ad525-3808-4360-fa2d-08db6c95e7c6
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE3A.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6373
X-Spam-Status: No, score=1.9 required=5.0 tests=AC_FROM_MANY_DOTS,BAYES_00,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Clock matrix driver can be probed before the rootfs containing
firmware/initialization .bin is available. The current driver
throws a warning and proceeds to execute probe even when firmware
is not ready. Instead, defer probe and wait for the .bin file to
be available.

Signed-off-by: Sarath Babu Naidu Gaddam <sarath.babu.naidu.gaddam@amd.com>
---
Changes in V2:
1) Added mutex_unlock(idtcm->lock); before returning EPROBE_DEFER.
2) Moved failure log after defer probe.
---
 drivers/ptp/ptp_clockmatrix.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/ptp/ptp_clockmatrix.c b/drivers/ptp/ptp_clockmatrix.c
index c9d451bf89e2..b3cb136257e3 100644
--- a/drivers/ptp/ptp_clockmatrix.c
+++ b/drivers/ptp/ptp_clockmatrix.c
@@ -2424,8 +2424,13 @@ static int idtcm_probe(struct platform_device *pdev)
 
 	err = idtcm_load_firmware(idtcm, &pdev->dev);
 
-	if (err)
+	if (err) {
+		if (err == -ENOENT) {
+			mutex_unlock(idtcm->lock);
+			return -EPROBE_DEFER;
+		}
 		dev_warn(idtcm->dev, "loading firmware failed with %d", err);
+	}
 
 	wait_for_chip_ready(idtcm);
 
-- 
2.25.1


