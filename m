Return-Path: <netdev+bounces-11639-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 05BAF733C94
	for <lists+netdev@lfdr.de>; Sat, 17 Jun 2023 00:49:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 383CA2818A0
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 22:49:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CABC7480;
	Fri, 16 Jun 2023 22:49:49 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B2E96FAA
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 22:49:49 +0000 (UTC)
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2071.outbound.protection.outlook.com [40.107.94.71])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42C4E30FF;
	Fri, 16 Jun 2023 15:49:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lf955dut4byZVeatrjzA9I3ngvbCpDEuSwKJQTpv1lZZkQc4iIT7zg7jGxhrJGvZVnm79622reOyAcrxg2FMrQV62kOq1UE5mqdur4ZZDXP95AWymNSZp495REQ1tAEc53jNw3X8dDndKZhvMVHYpujQVQuBJGjS1CUP75+vyAYBXHokINOC75dOtbhl+qDI9SKvfr50pO8JRxaSzimvYtUoXslzTJFAzjigacl/mx4bfhNUG3Y7SJbeIl5rneO0xflDc7SMHDJYS39CL7OGaXMZNSl63vRYDnQeIobQ4iVhjpjPlKhCydVKcrXS++5QvrJYEuyYQvIY/Si0nfcxZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2fYHefOymAMHVQP267l1cfyOGzNJ5uGgMkmjCOi2Ptg=;
 b=NyYoiKNYsbuT4KlWzMvdm9WA+mUBO0tRf+gY+K0qYva2RQcwmGG4QtqHyqo+9/932oVxIMNYxbYUkgWT4xVjwYofMmwBn/N37ItaurN12KDBRqcsKU154YjQAaKmIsM2Tq4sGD5vABxp3b0xPhr28x+3uKYOu7E8wip8MFTfLFAslaxlMSG9CL0cfxKNuz338SUsYFsZQTjTJRp/ZwWFhpbselIssRsJn2IDoQHKXPmPh1XQI0JU4CWIUAkkd5YwUAD6CenbIYFYBXz11m/D3XzR6uO/uNcO87rtPyj5KCap5N66j3TZ+66IHnBBLF1AyFvK2NYLhUn3vI5Y8c2igg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gmail.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2fYHefOymAMHVQP267l1cfyOGzNJ5uGgMkmjCOi2Ptg=;
 b=kNv3hobFdy627Dxx7kuQpy4yIf05aXC/VKbw4cCqp4Xy5FYgP33RalP0Hm94OZLCdaOjAectNJn86R5OTFvdIxn8ZSduDFSDGBtgwqMuBMxtw37Z3OxyynMqjWfAKnPjuRa0d4twL4j0Kdq2xrBaoaSXy+T9wCZZ56tNKHkGzvA=
Received: from BN8PR04CA0056.namprd04.prod.outlook.com (2603:10b6:408:d4::30)
 by CY5PR12MB6573.namprd12.prod.outlook.com (2603:10b6:930:43::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.25; Fri, 16 Jun
 2023 22:49:46 +0000
Received: from BN8NAM11FT099.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:d4:cafe::a) by BN8PR04CA0056.outlook.office365.com
 (2603:10b6:408:d4::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.30 via Frontend
 Transport; Fri, 16 Jun 2023 22:49:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 BN8NAM11FT099.mail.protection.outlook.com (10.13.177.197) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6500.30 via Frontend Transport; Fri, 16 Jun 2023 22:49:45 +0000
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Fri, 16 Jun
 2023 17:49:45 -0500
Received: from xcbamaftei43x.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23 via Frontend
 Transport; Fri, 16 Jun 2023 17:49:44 -0500
From: Alex Maftei <alex.maftei@amd.com>
To: <richardcochran@gmail.com>, <shuah@kernel.org>
CC: Alex Maftei <alex.maftei@amd.com>, <linux-kselftest@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: [PATCH net 1/2] selftests/ptp: Add -x option for testing PTP_SYS_OFFSET_EXTENDED
Date: Fri, 16 Jun 2023 23:48:44 +0100
Message-ID: <e3e14166f0e92065d08a024159e29160b815d2bf.1686955631.git.alex.maftei@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1686955631.git.alex.maftei@amd.com>
References: <cover.1686955631.git.alex.maftei@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN8NAM11FT099:EE_|CY5PR12MB6573:EE_
X-MS-Office365-Filtering-Correlation-Id: f3494a2a-dc65-4b58-e3e7-08db6ebbfb69
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	RHiNWEa8dwK1wZ68QuxB/Pq3NR6zBJsa1ccwD1omN5ReIQPpo4ekP82KQnX/eJ8aQeKHyTrjHph9ksqN2snx4SNuSRh3rEJqwwt59T+F1dXdrVNv9Y4aSNiNWRGgJalS/V3qPgOLNEuX1I1yEc45YGY+ZlBaHEgKJS531CR0vgs/MfGpKpuWipxT4Zr3ivdUONi7qgj+gKMK9vn6RutkdPJMonDsg+zh/MNWtoDCJnIzds8/0K66cUN+xMraNiA5WyVxnH4ltx+xelnsikG+KkLS4ZFrxi0vu+2omHwAE119MafaqeEv4PFkNRNW1n+fB0aaLOPTcfDm4pJQMZx145zha7iawhZK9N7JYjmQ01+WVUuAEOrFNGVrNvtSLZz0o6WzDRtROZw/ziR/DGLk70jEA/4UA6ZXZDSoFplOQYzKvxGy9TkTliJO/dyG69S+YGIaV1fxwsr4hrCTwXmkjX/hnD2JrtETxq71z61tEg2c8kCtDC6/OfUDQtID8qHVfHDKWtmZ6vxxBRp6/DZPInFEJT8KvFFYuaqlkpUsCGoZb16dazz/boRghPol8I8SPSqYxffRZT1XVcAlIWgEdN8eIwTjbgBefo7UzmRWS6mbYf0U/zYnUi/aweGRWAaHmZqbeJlCWcn3hdpIgZN9WSzB2v0F3a38T+kg8pOhggtAIpum3jSidbAppyblTJOjFA9bUEgerWFIZpqoLm+um57ep2i2kIUyMjhCy8+z7bQtE8+EUYtEdQgDAKdeJnr/JnBMncw5gcOYb74gy1T3RA==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(376002)(396003)(346002)(39860400002)(136003)(451199021)(40470700004)(36840700001)(46966006)(36860700001)(336012)(426003)(47076005)(83380400001)(40460700003)(2906002)(2616005)(86362001)(36756003)(82310400005)(81166007)(356005)(82740400003)(54906003)(40480700001)(8936002)(316002)(8676002)(41300700001)(5660300002)(478600001)(70206006)(70586007)(4326008)(26005)(186003)(110136005)(44832011)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2023 22:49:45.8705
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f3494a2a-dc65-4b58-e3e7-08db6ebbfb69
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN8NAM11FT099.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6573
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The -x option (where 'x' stands for eXtended) takes an argument which
represents the number of samples to request from the PTP device.
The help message will display the maximum number of samples allowed.
Providing an invalid argument will also display the maximum number of
samples allowed.

Signed-off-by: Alex Maftei <alex.maftei@amd.com>
---
 tools/testing/selftests/ptp/testptp.c | 42 +++++++++++++++++++++++++--
 1 file changed, 40 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/ptp/testptp.c b/tools/testing/selftests/ptp/testptp.c
index cfa9562f3cd8..2a99973ffc1b 100644
--- a/tools/testing/selftests/ptp/testptp.c
+++ b/tools/testing/selftests/ptp/testptp.c
@@ -142,8 +142,9 @@ static void usage(char *progname)
 		" -S         set the system time from the ptp clock time\n"
 		" -t val     shift the ptp clock time by 'val' seconds\n"
 		" -T val     set the ptp clock time to 'val' seconds\n"
+		" -x val     get an extended ptp clock time with the desired number of samples (up to %d)\n"
 		" -z         test combinations of rising/falling external time stamp flags\n",
-		progname);
+		progname, PTP_MAX_SAMPLES);
 }
 
 int main(int argc, char *argv[])
@@ -157,6 +158,7 @@ int main(int argc, char *argv[])
 	struct timex tx;
 	struct ptp_clock_time *pct;
 	struct ptp_sys_offset *sysoff;
+	struct ptp_sys_offset_extended *soe;
 
 	char *progname;
 	unsigned int i;
@@ -174,6 +176,7 @@ int main(int argc, char *argv[])
 	int index = 0;
 	int list_pins = 0;
 	int pct_offset = 0;
+	int getextended = 0;
 	int n_samples = 0;
 	int pin_index = -1, pin_func;
 	int pps = -1;
@@ -188,7 +191,7 @@ int main(int argc, char *argv[])
 
 	progname = strrchr(argv[0], '/');
 	progname = progname ? 1+progname : argv[0];
-	while (EOF != (c = getopt(argc, argv, "cd:e:f:ghH:i:k:lL:n:p:P:sSt:T:w:z"))) {
+	while (EOF != (c = getopt(argc, argv, "cd:e:f:ghH:i:k:lL:n:p:P:sSt:T:w:x:Xz"))) {
 		switch (c) {
 		case 'c':
 			capabilities = 1;
@@ -250,6 +253,13 @@ int main(int argc, char *argv[])
 		case 'w':
 			pulsewidth = atoi(optarg);
 			break;
+		case 'x':
+			getextended = atoi(optarg);
+			if (getextended < 1 || getextended > PTP_MAX_SAMPLES) {
+				fprintf(stderr, "number of extended timestamp samples must be between 1 and %d; was asked for %d\n", PTP_MAX_SAMPLES, getextended);
+				return -1;
+			}
+			break;
 		case 'z':
 			flagtest = 1;
 			break;
@@ -516,6 +526,34 @@ int main(int argc, char *argv[])
 		free(sysoff);
 	}
 
+	if (getextended) {
+		soe = calloc(1, sizeof(*soe));
+		if (!soe) {
+			perror("calloc");
+			return -1;
+		}
+
+		soe->n_samples = getextended;
+
+		if (ioctl(fd, PTP_SYS_OFFSET_EXTENDED, soe))
+			perror("PTP_SYS_OFFSET_EXTENDED");
+		else {
+			printf("extended timestamp request returned %d samples\n",
+				getextended);
+
+			for (i = 0; i < getextended; i++) {
+				printf("sample #%2d: system time before: %lld.%09u\n",
+				i, soe->ts[i][0].sec, soe->ts[i][0].nsec);
+				printf("            phc time: %lld.%09u\n",
+				soe->ts[i][1].sec, soe->ts[i][1].nsec);
+				printf("            system time after: %lld.%09u\n",
+				soe->ts[i][2].sec, soe->ts[i][2].nsec);
+			}
+		}
+
+		free(soe);
+	}
+
 	close(fd);
 	return 0;
 }
-- 
2.28.0


