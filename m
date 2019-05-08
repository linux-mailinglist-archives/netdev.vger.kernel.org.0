Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 759EA176FE
	for <lists+netdev@lfdr.de>; Wed,  8 May 2019 13:30:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727784AbfEHLaA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 May 2019 07:30:00 -0400
Received: from mail-eopbgr770084.outbound.protection.outlook.com ([40.107.77.84]:8420
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727660AbfEHL3y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 May 2019 07:29:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector1-analog-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rVLioUPEPqmLMHoafnG2eJ5Cabj4oTBfKzSwICAOZ9c=;
 b=Kita+OJXRAHOVOM4gc4T1ntvIpWXz9HblUP3WpCUvTZByqJb3AyQ6OCJOQXhT+nqZ0ov9swu97CQHO0OZnp09ddpoJpdTOX3W3VKHDnVu0FlLVa52EOq1Xr7ZugLQwjrSchc/lvI/eCXy7ZUv+nBny5Xxeys9i2Si58dimzAfg4=
Received: from BN6PR03CA0060.namprd03.prod.outlook.com (2603:10b6:404:4c::22)
 by BLUPR03MB552.namprd03.prod.outlook.com (2a01:111:e400:883::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.1856.12; Wed, 8 May
 2019 11:29:48 +0000
Received: from BL2NAM02FT021.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e46::200) by BN6PR03CA0060.outlook.office365.com
 (2603:10b6:404:4c::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.1856.11 via Frontend
 Transport; Wed, 8 May 2019 11:29:47 +0000
Authentication-Results: spf=pass (sender IP is 137.71.25.57)
 smtp.mailfrom=analog.com; lists.freedesktop.org; dkim=none (message not
 signed) header.d=none;lists.freedesktop.org; dmarc=bestguesspass action=none
 header.from=analog.com;
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.57 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.57; helo=nwd2mta2.analog.com;
Received: from nwd2mta2.analog.com (137.71.25.57) by
 BL2NAM02FT021.mail.protection.outlook.com (10.152.77.158) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.1856.11
 via Frontend Transport; Wed, 8 May 2019 11:29:47 +0000
Received: from NWD2HUBCAS7.ad.analog.com (nwd2hubcas7.ad.analog.com [10.64.69.107])
        by nwd2mta2.analog.com (8.13.8/8.13.8) with ESMTP id x48BTl35017158
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Wed, 8 May 2019 04:29:47 -0700
Received: from saturn.analog.com (10.50.1.244) by NWD2HUBCAS7.ad.analog.com
 (10.64.69.107) with Microsoft SMTP Server id 14.3.408.0; Wed, 8 May 2019
 07:29:46 -0400
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
Subject: [PATCH 05/16] ALSA: oxygen: use new match_string() helper/macro
Date:   Wed, 8 May 2019 14:28:31 +0300
Message-ID: <20190508112842.11654-7-alexandru.ardelean@analog.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190508112842.11654-1-alexandru.ardelean@analog.com>
References: <20190508112842.11654-1-alexandru.ardelean@analog.com>
MIME-Version: 1.0
Content-Type: text/plain
X-ADIRoutedOnPrem: True
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.57;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(979002)(1496009)(136003)(346002)(376002)(39860400002)(396003)(2980300002)(199004)(189003)(76176011)(126002)(305945005)(4326008)(8936002)(478600001)(106002)(48376002)(44832011)(316002)(70586007)(110136005)(70206006)(5660300002)(50226002)(51416003)(7696005)(486006)(54906003)(50466002)(2201001)(16586007)(1076003)(2441003)(47776003)(14444005)(7636002)(36756003)(356004)(86362001)(6666004)(8676002)(446003)(11346002)(186003)(107886003)(2906002)(426003)(53416004)(77096007)(246002)(476003)(2616005)(336012)(7416002)(26005)(921003)(2101003)(1121003)(83996005)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:BLUPR03MB552;H:nwd2mta2.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail11.analog.com;A:1;MX:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 66efb482-cb0a-4dad-e5d6-08d6d3a87a1f
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4709054)(2017052603328);SRVR:BLUPR03MB552;
X-MS-TrafficTypeDiagnostic: BLUPR03MB552:
X-Microsoft-Antispam-PRVS: <BLUPR03MB552AF7B38F8203AAA30511DF9320@BLUPR03MB552.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 0031A0FFAF
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: e/To3BPzuLghSO94HDnZlxoz8w67oaeR4GSzahZT9wHatcz1zrWh6fCxUMAieE1jx47k0sRobJfJVMtHF6W19Tt9mzjOE1Lu1pitLTXvTYnWDfIHRbocgJHDAtxc9EVQk/DKKZoTBrSu0hL6fWGXjHzQ6643G/LeohDW4CeQx3HGpAo6nMhSKo06dWsOGgF8+yLFj4fQ5P3zYsgKcz+tIwrJHRcgPbJNGxFE+RUIIh8EdipADsgsLBuXl6YKd3ykQqSQoqrQUiSwSHgirDUboymSwsWHchiPV5ab5yzm94c51T28FewuN+V+WtyvJ28SovC51o8MtkuP86kD1Xn9HGHuClYC+YNCsIEjvGeEDYas4Zxt8B5+ACjPzvfNHJ5qVl55hDB4b7DOIbfGhCY/0XisSYWHvRU0oj0SFJLi5yE=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2019 11:29:47.5230
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 66efb482-cb0a-4dad-e5d6-08d6d3a87a1f
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.57];Helo=[nwd2mta2.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLUPR03MB552
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The change is purely cosmetic at this point in time, but it does highlight
the change done in lib/string.c for match_string().

Particularly for this change, a control mode can be removed/added at a
different index/enum-value, and the match_string() helper will continue
until the end of the array and ignore the NULL.

Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
---
 sound/pci/oxygen/oxygen_mixer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/pci/oxygen/oxygen_mixer.c b/sound/pci/oxygen/oxygen_mixer.c
index 13c2fb75fd71..961fd1cbc712 100644
--- a/sound/pci/oxygen/oxygen_mixer.c
+++ b/sound/pci/oxygen/oxygen_mixer.c
@@ -1086,7 +1086,7 @@ static int add_controls(struct oxygen *chip,
 		err = snd_ctl_add(chip->card, ctl);
 		if (err < 0)
 			return err;
-		j = __match_string(known_ctl_names, CONTROL_COUNT, ctl->id.name);
+		j = match_string(known_ctl_names, ctl->id.name);
 		if (j >= 0) {
 			chip->controls[j] = ctl;
 			ctl->private_free = oxygen_any_ctl_free;
-- 
2.17.1

