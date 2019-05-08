Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 738C71770D
	for <lists+netdev@lfdr.de>; Wed,  8 May 2019 13:30:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727904AbfEHLaO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 May 2019 07:30:14 -0400
Received: from mail-eopbgr800089.outbound.protection.outlook.com ([40.107.80.89]:2337
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727866AbfEHLaL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 May 2019 07:30:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector1-analog-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TppapvdTdEWShhGPGCPSH9uz8QgU5Op8E8ytcSMFOwg=;
 b=OQVIVgK5JxJMqIfsuBpJyNhsOscNjrf8QoWcS71HKHv5ECSFl4t6qL8cjbEvHO9onyxqCP7Eiq7Wxh8YLQX/ufSvCV0VABMsC9ZaqNqGS8uuuvsMFWUm0Wa0qvupkiH+emRfafnbKdPIl4OkQQXlSvhfm9OK1pHqR4K81+Fv0Z8=
Received: from CY4PR03CA0091.namprd03.prod.outlook.com (2603:10b6:910:4d::32)
 by BLUPR03MB550.namprd03.prod.outlook.com (2a01:111:e400:880::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.1856.12; Wed, 8 May
 2019 11:30:03 +0000
Received: from BL2NAM02FT017.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e46::204) by CY4PR03CA0091.outlook.office365.com
 (2603:10b6:910:4d::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.1878.21 via Frontend
 Transport; Wed, 8 May 2019 11:30:03 +0000
Authentication-Results: spf=pass (sender IP is 137.71.25.55)
 smtp.mailfrom=analog.com; lists.freedesktop.org; dkim=none (message not
 signed) header.d=none;lists.freedesktop.org; dmarc=bestguesspass action=none
 header.from=analog.com;
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.55 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.55; helo=nwd2mta1.analog.com;
Received: from nwd2mta1.analog.com (137.71.25.55) by
 BL2NAM02FT017.mail.protection.outlook.com (10.152.77.174) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.1856.11
 via Frontend Transport; Wed, 8 May 2019 11:30:02 +0000
Received: from NWD2HUBCAS7.ad.analog.com (nwd2hubcas7.ad.analog.com [10.64.69.107])
        by nwd2mta1.analog.com (8.13.8/8.13.8) with ESMTP id x48BU1rk023711
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Wed, 8 May 2019 04:30:01 -0700
Received: from saturn.analog.com (10.50.1.244) by NWD2HUBCAS7.ad.analog.com
 (10.64.69.107) with Microsoft SMTP Server id 14.3.408.0; Wed, 8 May 2019
 07:30:01 -0400
From:   Alexandru Ardelean <alexandru.ardelean@analog.com>
To:     <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <linux-ide@vger.kernel.org>, <linux-clk@vger.kernel.org>,
        <linux-rpi-kernel@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-rockchip@lists.infradead.org>, <linux-pm@vger.kernel.org>,
        <linux-gpio@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
        <intel-gfx@lists.freedesktop.org>, <linux-omap@vger.kernel.org>,
        <linux-mmc@vger.kernel.org>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>, <devel@driverdev.osuosl.org>,
        <linux-usb@vger.kernel.org>, <kvm@vger.kernel.org>,
        <linux-fbdev@vger.kernel.org>, <linux-mtd@lists.infradead.org>,
        <cgroups@vger.kernel.org>, <linux-mm@kvack.org>,
        <linux-security-module@vger.kernel.org>,
        <linux-integrity@vger.kernel.org>, <alsa-devel@alsa-project.org>
CC:     <gregkh@linuxfoundation.org>, <andriy.shevchenko@linux.intel.com>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: [PATCH 08/16] cpufreq/intel_pstate: remove NULL entry + use match_string()
Date:   Wed, 8 May 2019 14:28:34 +0300
Message-ID: <20190508112842.11654-10-alexandru.ardelean@analog.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190508112842.11654-1-alexandru.ardelean@analog.com>
References: <20190508112842.11654-1-alexandru.ardelean@analog.com>
MIME-Version: 1.0
Content-Type: text/plain
X-ADIRoutedOnPrem: True
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.55;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(1496009)(376002)(396003)(136003)(39860400002)(346002)(2980300002)(199004)(189003)(8676002)(77096007)(47776003)(50466002)(50226002)(26005)(478600001)(336012)(51416003)(186003)(2616005)(1076003)(2201001)(7696005)(246002)(426003)(86362001)(110136005)(106002)(305945005)(126002)(16586007)(446003)(2441003)(316002)(11346002)(54906003)(476003)(486006)(36756003)(107886003)(76176011)(53416004)(8936002)(5660300002)(4326008)(7416002)(356004)(6666004)(7636002)(44832011)(2906002)(48376002)(70586007)(70206006)(921003)(1121003)(2101003)(83996005);DIR:OUT;SFP:1101;SCL:1;SRVR:BLUPR03MB550;H:nwd2mta1.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail10.analog.com;A:1;MX:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 86204a62-8a3c-4b5a-9dba-08d6d3a8834f
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4709054)(2017052603328);SRVR:BLUPR03MB550;
X-MS-TrafficTypeDiagnostic: BLUPR03MB550:
X-Microsoft-Antispam-PRVS: <BLUPR03MB550ACAC1A7934C08542BCC1F9320@BLUPR03MB550.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:541;
X-Forefront-PRVS: 0031A0FFAF
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: rxv/XoCD6aaHG0TrRZkKWXDRcX000pKd7bfq3vJ62ePHcuWPHuGNJPBOqwgOijZqx3E8HU+x999IZl+ba88JfR0vYIb7Obj0j1eZUKusZuk8BQ/3y6BrYo03I2LI4DxBWK7qu2MZ9Itfu0i5LUpmIJtONUQwaJE75922TD4j9KqTqEJtt7Oe/4c20rd7gXAxLMfmFvG64Cz4/6AKOCc11G5CrFVaAO+gYxZukEzvn6JfBa8EqYvBAsn6lRm+PFLP0hqCZn/uR2nN9VOclRHqQPxm+Va0rH6apLh63EtDW7LtpBEfmUsSBBtIhzfYTLNJ1UfI6Mz02xdbaV19/8eub1YBOgpTClnEpYZAmVHWy3iJ9vzMVWpkffbsdAGUPXMahcgSR5z55fgI7Obs6j3WIQGQdzC6GP62894A4z71zMk=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2019 11:30:02.9332
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 86204a62-8a3c-4b5a-9dba-08d6d3a8834f
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.55];Helo=[nwd2mta1.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLUPR03MB550
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The change is mostly cosmetic.

The `energy_perf_strings` array is static, so match_string() can be used
(which will implicitly do a ARRAY_SIZE(energy_perf_strings)).

The only small benefit here, is the reduction of the array size by 1
element.

Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
---
 drivers/cpufreq/intel_pstate.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
index 6ed1e705bc05..ab9a0b34b900 100644
--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -593,8 +593,7 @@ static const char * const energy_perf_strings[] = {
 	"performance",
 	"balance_performance",
 	"balance_power",
-	"power",
-	NULL
+	"power"
 };
 static const unsigned int epp_values[] = {
 	HWP_EPP_PERFORMANCE,
@@ -680,8 +679,8 @@ static ssize_t show_energy_performance_available_preferences(
 	int i = 0;
 	int ret = 0;
 
-	while (energy_perf_strings[i] != NULL)
-		ret += sprintf(&buf[ret], "%s ", energy_perf_strings[i++]);
+	for (; i < ARRAY_SIZE(energy_perf_strings); i++)
+		ret += sprintf(&buf[ret], "%s ", energy_perf_strings[i]);
 
 	ret += sprintf(&buf[ret], "\n");
 
@@ -701,7 +700,7 @@ static ssize_t store_energy_performance_preference(
 	if (ret != 1)
 		return -EINVAL;
 
-	ret = __match_string(energy_perf_strings, -1, str_preference);
+	ret = match_string(energy_perf_strings, str_preference);
 	if (ret < 0)
 		return ret;
 
-- 
2.17.1

