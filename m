Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5EE9317738
	for <lists+netdev@lfdr.de>; Wed,  8 May 2019 13:31:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728167AbfEHLay (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 May 2019 07:30:54 -0400
Received: from mail-eopbgr680071.outbound.protection.outlook.com ([40.107.68.71]:9991
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728118AbfEHLav (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 May 2019 07:30:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector1-analog-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1pGxpqtswe0uDTJtCA9b8Plg8X12C8ZZ/KC5tO0ZuVQ=;
 b=uLO3LXwdd1BWamWiK4r+Hw5jvJyCV00LM1cyhqNBKocozKsQvw+ovIXID7g91gMIvPgSp0VMC7EhKj6CA5gnlmoJcz4HY1qoPHGRgatiggRcisFhgTqP51Zl+L8WhLodnCQ/qLq5WxXaZ64lgglcD6lX1+C8qGWvddWXlxnm3bA=
Received: from CY4PR03CA0098.namprd03.prod.outlook.com (2603:10b6:910:4d::39)
 by BN3PR03MB2259.namprd03.prod.outlook.com (2a01:111:e400:7bba::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.1856.12; Wed, 8 May
 2019 11:30:44 +0000
Received: from SN1NAM02FT012.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e44::207) by CY4PR03CA0098.outlook.office365.com
 (2603:10b6:910:4d::39) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.1878.20 via Frontend
 Transport; Wed, 8 May 2019 11:30:44 +0000
Authentication-Results: spf=pass (sender IP is 137.71.25.55)
 smtp.mailfrom=analog.com; lists.freedesktop.org; dkim=none (message not
 signed) header.d=none;lists.freedesktop.org; dmarc=bestguesspass action=none
 header.from=analog.com;
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.55 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.55; helo=nwd2mta1.analog.com;
Received: from nwd2mta1.analog.com (137.71.25.55) by
 SN1NAM02FT012.mail.protection.outlook.com (10.152.72.95) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.1856.11
 via Frontend Transport; Wed, 8 May 2019 11:30:43 +0000
Received: from NWD2HUBCAS7.ad.analog.com (nwd2hubcas7.ad.analog.com [10.64.69.107])
        by nwd2mta1.analog.com (8.13.8/8.13.8) with ESMTP id x48BUgbC023898
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Wed, 8 May 2019 04:30:42 -0700
Received: from saturn.analog.com (10.50.1.244) by NWD2HUBCAS7.ad.analog.com
 (10.64.69.107) with Microsoft SMTP Server id 14.3.408.0; Wed, 8 May 2019
 07:30:42 -0400
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
Subject: [PATCH 15/16] video: fbdev: pxafb: use new match_string() helper/macro
Date:   Wed, 8 May 2019 14:28:41 +0300
Message-ID: <20190508112842.11654-17-alexandru.ardelean@analog.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190508112842.11654-1-alexandru.ardelean@analog.com>
References: <20190508112842.11654-1-alexandru.ardelean@analog.com>
MIME-Version: 1.0
Content-Type: text/plain
X-ADIRoutedOnPrem: True
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.55;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(1496009)(136003)(396003)(346002)(376002)(39860400002)(2980300002)(199004)(189003)(50466002)(2906002)(426003)(478600001)(126002)(2441003)(2616005)(476003)(51416003)(26005)(8936002)(7696005)(48376002)(77096007)(186003)(50226002)(7416002)(246002)(47776003)(356004)(11346002)(36756003)(70586007)(70206006)(8676002)(446003)(336012)(16586007)(2201001)(76176011)(1076003)(86362001)(4326008)(107886003)(486006)(5660300002)(44832011)(106002)(305945005)(110136005)(316002)(54906003)(7636002)(53416004)(921003)(83996005)(2101003)(1121003);DIR:OUT;SFP:1101;SCL:1;SRVR:BN3PR03MB2259;H:nwd2mta1.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail10.analog.com;A:1;MX:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 19467b0d-82a0-4414-fd3d-08d6d3a89be6
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4709054)(2017052603328);SRVR:BN3PR03MB2259;
X-MS-TrafficTypeDiagnostic: BN3PR03MB2259:
X-Microsoft-Antispam-PRVS: <BN3PR03MB2259B45DC5D8696943CC04CAF9320@BN3PR03MB2259.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:120;
X-Forefront-PRVS: 0031A0FFAF
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: ica2HYRZM4fdZtkxNTO9Gb+CKac0B/LUwaOW4nL6nYW79SYpz0JOGfZuZgqcdALu4tIifExiLGAs6sD77WVSTjIN3M+20mtkK8wI+pBL9/p1PoBSKfZAmfP2KGJVvCgSEHf32wy3PDodr1lg8Yuu8eqBBpgNfg053BOMOeCaI7HFr/B1OJTsQBX/ceRy48at5Iy5hIl80/NoESGq+ZAk5cvin1INqYY3Mb1qILEP4XIZVdGoHNJeTgIM/V0FqkN7/zCsxIYOu/80TBgJdrmS/t2+/MSfdRVyy3pcjddO6858KbsH4xUnc6kYGOjPaFpLAaL+RTif6KsJe22eNbSvhw8CkJVq6PtH4EXETBQCnvcVhQzisGb4TvfZgmQsWRjNXcqE9FtzT+5/kc2FZNz3c0T+2Bori5rG0j1zDojL+ig=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2019 11:30:43.2658
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 19467b0d-82a0-4414-fd3d-08d6d3a89be6
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.55];Helo=[nwd2mta1.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN3PR03MB2259
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The `lcd_types` array is a static array of strings.
Using match_string() (which computes the array size via ARRAY_SIZE())
is possible.

This reduces the array by 1 element, since the NULL (at the end of the
array) is no longer needed.

Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
---
 drivers/video/fbdev/pxafb.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/video/fbdev/pxafb.c b/drivers/video/fbdev/pxafb.c
index 0025781e6e1e..e657a04f5b1d 100644
--- a/drivers/video/fbdev/pxafb.c
+++ b/drivers/video/fbdev/pxafb.c
@@ -2114,7 +2114,7 @@ static void pxafb_check_options(struct device *dev, struct pxafb_mach_info *inf)
 #if defined(CONFIG_OF)
 static const char * const lcd_types[] = {
 	"unknown", "mono-stn", "mono-dstn", "color-stn", "color-dstn",
-	"color-tft", "smart-panel", NULL
+	"color-tft", "smart-panel"
 };
 
 static int of_get_pxafb_display(struct device *dev, struct device_node *disp,
@@ -2129,7 +2129,7 @@ static int of_get_pxafb_display(struct device *dev, struct device_node *disp,
 	if (ret)
 		s = "color-tft";
 
-	i = __match_string(lcd_types, -1, s);
+	i = match_string(lcd_types, s);
 	if (i < 0) {
 		dev_err(dev, "lcd-type %s is unknown\n", s);
 		return i;
-- 
2.17.1

