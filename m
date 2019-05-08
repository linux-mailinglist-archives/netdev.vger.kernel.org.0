Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18C2417725
	for <lists+netdev@lfdr.de>; Wed,  8 May 2019 13:30:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728075AbfEHLam (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 May 2019 07:30:42 -0400
Received: from mail-eopbgr690080.outbound.protection.outlook.com ([40.107.69.80]:22976
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727611AbfEHLaj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 May 2019 07:30:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector1-analog-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2xB20OGypICNQZWKblrMBkQ0pTKCSJ0Q3IEFfzUPnKg=;
 b=OU6NQB7gZLvgySovwjwuTY2etpF1iO6NIq66rWqRGCUiVZgLKtFpVlZd4T6Py3DBngyiFNbGK+24eWSQtNjs4A7tc5MhJPa01bLOUy7MmYUoNiqC73UHrXSzKYsrLmXi0lLtdGKUF37hhNtj7Q6bcYHbG4OmMRmSM1ZaEchIrU0=
Received: from BN6PR03CA0072.namprd03.prod.outlook.com (2603:10b6:404:4c::34)
 by BL2PR03MB546.namprd03.prod.outlook.com (2a01:111:e400:c24::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.1878.20; Wed, 8 May
 2019 11:30:31 +0000
Received: from SN1NAM02FT010.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e44::204) by BN6PR03CA0072.outlook.office365.com
 (2603:10b6:404:4c::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.1878.20 via Frontend
 Transport; Wed, 8 May 2019 11:30:31 +0000
Authentication-Results: spf=pass (sender IP is 137.71.25.55)
 smtp.mailfrom=analog.com; lists.freedesktop.org; dkim=none (message not
 signed) header.d=none;lists.freedesktop.org; dmarc=bestguesspass action=none
 header.from=analog.com;
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.55 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.55; helo=nwd2mta1.analog.com;
Received: from nwd2mta1.analog.com (137.71.25.55) by
 SN1NAM02FT010.mail.protection.outlook.com (10.152.72.86) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.1856.11
 via Frontend Transport; Wed, 8 May 2019 11:30:30 +0000
Received: from NWD2HUBCAS7.ad.analog.com (nwd2hubcas7.ad.analog.com [10.64.69.107])
        by nwd2mta1.analog.com (8.13.8/8.13.8) with ESMTP id x48BUTmG023837
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Wed, 8 May 2019 04:30:29 -0700
Received: from saturn.analog.com (10.50.1.244) by NWD2HUBCAS7.ad.analog.com
 (10.64.69.107) with Microsoft SMTP Server id 14.3.408.0; Wed, 8 May 2019
 07:30:28 -0400
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
Subject: [PATCH 13/16] drm/edid: use new match_string() helper/macro
Date:   Wed, 8 May 2019 14:28:39 +0300
Message-ID: <20190508112842.11654-15-alexandru.ardelean@analog.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190508112842.11654-1-alexandru.ardelean@analog.com>
References: <20190508112842.11654-1-alexandru.ardelean@analog.com>
MIME-Version: 1.0
Content-Type: text/plain
X-ADIRoutedOnPrem: True
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.55;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(1496009)(346002)(136003)(396003)(376002)(39860400002)(2980300002)(189003)(199004)(476003)(11346002)(426003)(4744005)(2906002)(2616005)(2441003)(76176011)(446003)(5660300002)(126002)(50466002)(478600001)(14444005)(336012)(1076003)(6666004)(356004)(4326008)(7636002)(70206006)(48376002)(70586007)(8676002)(44832011)(106002)(8936002)(36756003)(486006)(86362001)(2201001)(186003)(246002)(7696005)(51416003)(50226002)(77096007)(26005)(53416004)(107886003)(16586007)(47776003)(110136005)(316002)(7416002)(54906003)(305945005)(921003)(1121003)(2101003)(83996005);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2PR03MB546;H:nwd2mta1.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail10.analog.com;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 82b1335a-441b-419e-9856-08d6d3a89439
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4709054)(2017052603328);SRVR:BL2PR03MB546;
X-MS-TrafficTypeDiagnostic: BL2PR03MB546:
X-Microsoft-Antispam-PRVS: <BL2PR03MB546A0446D493C9B8758CD80F9320@BL2PR03MB546.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:883;
X-Forefront-PRVS: 0031A0FFAF
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: kmgGUzYPdSV3VTFQV+645Mo10A43GRXumFLi/W3XTjg1/M6xsukN+9rUN0IEc1bpKKy667zEgMFcVvXWcjId4XLWq9COaVWObLgjv+ECyHMfF3UQZ2r8Kgj98qGfkp0RBf19Vdds8vUWwSTvaF2rcMnY7SkNLYOmiIQKJbisjJFYRVzkdggu5As2YO/FOWeLeeiZD6CNT43j8lN3ZL5zG4mxQSHXD5C0/Xk/lCDaFDFKEwC7jfuEtfVLnLG1YdYS+kTOlcR8iq6azQ5dad8FIBhs/tXgGYgvdPkV9Gf7wcXJK5krdcwXTEiraKBMYAh6lP+jwPKITVndILCgjF+ZiXZ4GtmD3M+nbm2W5hBvNq75XUxA2x3cL2WFwMdjfR3E2ORzA4OMp0kNEVjtA5ZnWIP4u5/lz0dsfTZDTkp8rOc=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2019 11:30:30.3712
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 82b1335a-441b-419e-9856-08d6d3a89439
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.55];Helo=[nwd2mta1.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL2PR03MB546
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The `generic_edid_name` is a static array of strings.
Using match_string() (which computes the array size via ARRAY_SIZE())
is possible.

The change is mostly cosmetic.
No functionality change.

Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
---
 drivers/gpu/drm/drm_edid_load.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_edid_load.c b/drivers/gpu/drm/drm_edid_load.c
index 1450051972ea..66e1e325ff37 100644
--- a/drivers/gpu/drm/drm_edid_load.c
+++ b/drivers/gpu/drm/drm_edid_load.c
@@ -186,7 +186,7 @@ static void *edid_load(struct drm_connector *connector, const char *name,
 	int i, valid_extensions = 0;
 	bool print_bad_edid = !connector->bad_edid_counter || (drm_debug & DRM_UT_KMS);
 
-	builtin = __match_string(generic_edid_name, GENERIC_EDIDS, name);
+	builtin = match_string(generic_edid_name, name);
 	if (builtin >= 0) {
 		fwdata = generic_edid[builtin];
 		fwsize = sizeof(generic_edid[builtin]);
-- 
2.17.1

