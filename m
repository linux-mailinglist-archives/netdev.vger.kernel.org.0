Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 277E617741
	for <lists+netdev@lfdr.de>; Wed,  8 May 2019 13:31:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728193AbfEHLa4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 May 2019 07:30:56 -0400
Received: from mail-eopbgr810070.outbound.protection.outlook.com ([40.107.81.70]:64128
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728076AbfEHLax (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 May 2019 07:30:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector1-analog-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BLP6T3LmL+xu1pWFiHVPh/xRUsA/EQBeKdqIkqvb8tM=;
 b=Mou+jErBJvl2+qbFwKpdjFrX8nTbxuMm9kAbp3zHsAZA2Yu/30Qn/WM6TRbbZNSO3b9THY/Eb/sEps9xXwDLMCKhkT2e6gE563qV3pa7GK6VRH3DCP3ZsKscgA/XT3bvkTHMyfFdjW8irkfZ8FepYUe+nSBapiK9qv/M4/AWiaI=
Received: from CY1PR03CA0020.namprd03.prod.outlook.com (2603:10b6:600::30) by
 DM5PR03MB3131.namprd03.prod.outlook.com (2603:10b6:4:3c::28) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1878.20; Wed, 8 May 2019 11:30:48 +0000
Received: from BL2NAM02FT016.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e46::201) by CY1PR03CA0020.outlook.office365.com
 (2603:10b6:600::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.1878.20 via Frontend
 Transport; Wed, 8 May 2019 11:30:48 +0000
Authentication-Results: spf=pass (sender IP is 137.71.25.55)
 smtp.mailfrom=analog.com; lists.freedesktop.org; dkim=none (message not
 signed) header.d=none;lists.freedesktop.org; dmarc=bestguesspass action=none
 header.from=analog.com;
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.55 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.55; helo=nwd2mta1.analog.com;
Received: from nwd2mta1.analog.com (137.71.25.55) by
 BL2NAM02FT016.mail.protection.outlook.com (10.152.77.171) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.1856.11
 via Frontend Transport; Wed, 8 May 2019 11:30:48 +0000
Received: from NWD2HUBCAS7.ad.analog.com (nwd2hubcas7.ad.analog.com [10.64.69.107])
        by nwd2mta1.analog.com (8.13.8/8.13.8) with ESMTP id x48BUlYi023920
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Wed, 8 May 2019 04:30:47 -0700
Received: from saturn.analog.com (10.50.1.244) by NWD2HUBCAS7.ad.analog.com
 (10.64.69.107) with Microsoft SMTP Server id 14.3.408.0; Wed, 8 May 2019
 07:30:47 -0400
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
Subject: [PATCH 16/16] sched: debug: use new match_string() helper/macro
Date:   Wed, 8 May 2019 14:28:42 +0300
Message-ID: <20190508112842.11654-18-alexandru.ardelean@analog.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190508112842.11654-1-alexandru.ardelean@analog.com>
References: <20190508112842.11654-1-alexandru.ardelean@analog.com>
MIME-Version: 1.0
Content-Type: text/plain
X-ADIRoutedOnPrem: True
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.55;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(1496009)(346002)(376002)(396003)(39860400002)(136003)(2980300002)(199004)(189003)(50226002)(246002)(8936002)(8676002)(5660300002)(70586007)(70206006)(14444005)(76176011)(426003)(336012)(51416003)(7696005)(4744005)(356004)(6666004)(1076003)(44832011)(476003)(2616005)(11346002)(446003)(126002)(486006)(16586007)(316002)(106002)(54906003)(110136005)(77096007)(26005)(186003)(86362001)(50466002)(478600001)(2201001)(47776003)(7416002)(305945005)(7636002)(48376002)(2441003)(53416004)(4326008)(36756003)(107886003)(2906002)(921003)(2101003)(83996005)(1121003);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR03MB3131;H:nwd2mta1.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail10.analog.com;A:1;MX:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4f9efdca-1ab7-457f-8e86-08d6d3a89e43
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4709054)(2017052603328);SRVR:DM5PR03MB3131;
X-MS-TrafficTypeDiagnostic: DM5PR03MB3131:
X-Microsoft-Antispam-PRVS: <DM5PR03MB3131EB1D4A0233D6F2CF2FE9F9320@DM5PR03MB3131.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:883;
X-Forefront-PRVS: 0031A0FFAF
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: y8JtZs2HotEuJXogFzCnWR8K541Bt2KfbZWELew5MD4nlAPku+wmdwLi/TmhK+Wakt+fvbaRFSoxotZgnMV2hufk93HL+wHu08VeIYZzAB8IoqoQv2Dvs3lnVRZh37jPq6JDJZ09fXCNHxrzaMP2dKCDMykwclc7f8Vhdsv9Hmgt6QzYljQnwVIuzcGFye7kiyk0f3KKDWznos08NxFijPl+LUMHPWnvzQlXV/iO2H1CI51TvTwttNaST8OKKWnz5OXJBqxgbJS4Kly1RQeBnhEZ3a2yJ66lTxZm6OcLmRETP89L/aXGIMwvdEBcgXHdYhM7+eUMfrZ8P6irgud1tsflo5a0tQjULWcYbJoGX3011swPClTsa1cpteMxSluefGhuVRdEo64cyvpiEdovYVJn9rugc71z/Ws3tZEK/Xg=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2019 11:30:48.0826
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f9efdca-1ab7-457f-8e86-08d6d3a89e43
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.55];Helo=[nwd2mta1.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR03MB3131
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The `sched_feat_names` array is a static array of strings.
Using match_string() (which computes the array size via ARRAY_SIZE())
is possible.

The change is mostly cosmetic.
No functionality change.

Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
---
 kernel/sched/debug.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index b0efc5fe641e..6d5f370bdfde 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -111,7 +111,7 @@ static int sched_feat_set(char *cmp)
 		cmp += 3;
 	}
 
-	i = __match_string(sched_feat_names, __SCHED_FEAT_NR, cmp);
+	i = match_string(sched_feat_names, cmp);
 	if (i < 0)
 		return i;
 
-- 
2.17.1

