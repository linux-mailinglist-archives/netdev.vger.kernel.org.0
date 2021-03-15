Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2209633B058
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 11:50:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230215AbhCOKtt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 06:49:49 -0400
Received: from mail-eopbgr130048.outbound.protection.outlook.com ([40.107.13.48]:40165
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229579AbhCOKtk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Mar 2021 06:49:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jyxTO93NAlfDt4Afa5ejmjhgmdnbjzvmNEzuncQ9+owvQNoLVxMxlWEpTUq7HJCgGjBqoR/4J81l7UQffgokl8ay2CxYnYBzDmJes7ZJ+sMpu0wqrQMX6Ek2TZZljNacMmfN5Kz+JeA4y9PNxQm/FNAAP6WTBbyoqZoU+w89QU56yhgCmOqGnz/XoRjuLzkKameaXO79OmB+FJ0QiF+avEJy03iCWbdmX2xRMs0Dp8RcUMxVvOal1yxd/5Cc1gP0L4PODpM7qodyc1Yz9Sg3WXcux+iZW9+aD3FvLTErU0Ld0EhKKItPqgLGT+2WVx6l9KTzaDoFD0+PD3VwvOpwnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FpdcuSDMoS1nNzCxM9Oy3TGUXYlkvZ+BsnVsNicVrhE=;
 b=PtXPW7G3EBwgarZUh9MAnvZ28szYmtNEZmz0ehVr3ORVOmV71FGw/dLL+B9jRq1sNoyZIBjmumlroIwCqHAQalcQKLoolKeXHI5JXzNcfueGhnnl4MDa1c+VhkswaQxFmBmSKe7EYOzOAnUcjru162zCOPyBeV1OPTY1Ht49zgm+UcSmzNsAs9gX0wyVyooUMKJOg7TsWHvvXF4Ozt004Uy9FBXHlCbab0+Z9HK5Q7kjbbRTKkVQyLgUOl5zuFbD5TSr5ncd3tikl7+WNzLdaJua4wAKsw+qe3KqYEVVZaQSyqXry7x5gjzxnvenC5wn371H0SU/E65EzQauNg/c8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FpdcuSDMoS1nNzCxM9Oy3TGUXYlkvZ+BsnVsNicVrhE=;
 b=fyoljTSrGU72or0C8bTK0xOpJHSWxGzssVowEA9LwnUFy3elydC2z4SFa0luq22seiCsNFT1Fz8hK2guEaKNIcP481HUP4OKE+/M+05uz8QbA1i/1GXlC7lIfa0uOKIeTkUSHX2ZLR86WrvOa1cIV14q9QcJD4KpV2JAm3WaVPc=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM4PR0401MB2404.eurprd04.prod.outlook.com (2603:10a6:200:4b::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32; Mon, 15 Mar
 2021 10:49:36 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::1cd:7101:5570:cd79]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::1cd:7101:5570:cd79%7]) with mapi id 15.20.3933.032; Mon, 15 Mar 2021
 10:49:35 +0000
From:   Calvin Johnson <calvin.johnson@oss.nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Doug Berger <opendmb@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Iyappan Subramanian <iyappan@os.amperecomputing.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Keyur Chudgar <keyur@os.amperecomputing.com>,
        Quan Nguyen <quan@os.amperecomputing.com>,
        Ray Jui <rjui@broadcom.com>,
        Russell King <linux@armlinux.org.uk>,
        Scott Branden <sbranden@broadcom.com>
Cc:     Calvin Johnson <calvin.johnson@oss.nxp.com>,
        bcm-kernel-feedback-list@broadcom.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH] net: mdio: Alphabetically sort header inclusion
Date:   Mon, 15 Mar 2021 16:19:05 +0530
Message-Id: <20210315104905.8683-1-calvin.johnson@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [14.142.151.118]
X-ClientProxiedBy: HK2PR02CA0159.apcprd02.prod.outlook.com
 (2603:1096:201:1f::19) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by HK2PR02CA0159.apcprd02.prod.outlook.com (2603:1096:201:1f::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.31 via Frontend Transport; Mon, 15 Mar 2021 10:49:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: a6654702-13a3-4529-fbd3-08d8e7a0060d
X-MS-TrafficTypeDiagnostic: AM4PR0401MB2404:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM4PR0401MB2404A7DBEF848C213BA88555D26C9@AM4PR0401MB2404.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:257;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2VaRpsHSVer1YDMdoZK6FqLN+VOVS4Teehx1GCJo7decil1xB/IBFlEASWAtiJftcgGir54U94t8p0Yk60xCGiiXrWYfeJdvl16T5yD3pvUF3YKxEGPRyJZHKbroitHqGwWPOKnm7eKw9m/aLXKdFiWWnKwb1+SSzv9eHC94Titq/AM6/Xi8MotHejquiGQkcOVVIs20g3rXIgWt2MvhQ+sCrQ5TxW7sMYMFbHI0f6YA3EC9sJvtkqbEpD230r1yfA4PB8GasiSWwKlwXw4XsRUqug6va1AnSWAH2Y7Xn5QKtVq0ZagTSAkuiDYA5UJqVOnIIAhMbPJ300C76N6pnyN++RtNQ8cpU22znHC2o9Yk/lZVZkBtAYW7SjEpU0oy/yK9Hg9xYL4RJqq1wA5/7DPEZyocp43DFeBGFgozZD1Qc8T4KiEzS+qTPTYBeX1qoMGjrJqwMdQL0eAjVJB9AEUvJiFHz36eslQ+wrbKijsmhbJh+Bhz8kcQSly8pb3ZT/zMqERFAtPWMlgJwtqo1suVNtT0/iup6xByR+HIeZ2+4vTqXdd+XxKR1t2MGl6As/PVZRbwccns/elK/ZqxaFkach4ahzmtZiHf/CGPxBuSA60NulPyriJ2tOlFMDex0zFX1qF9r1EKueQ+9yCuXg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(39860400002)(366004)(346002)(396003)(921005)(66946007)(30864003)(26005)(6506007)(52116002)(8676002)(66476007)(956004)(478600001)(66556008)(55236004)(4326008)(1006002)(2906002)(316002)(1076003)(5660300002)(83380400001)(6512007)(186003)(16526019)(2616005)(86362001)(110136005)(44832011)(7416002)(6666004)(6486002)(8936002)(110426009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?/xlaS9sMBWAKoHzlSDQmee/+g1yFQmHAxxLRKCREmEPD3j2N6bZVzW31vV4K?=
 =?us-ascii?Q?x+p2NAkQE7d6nZuymlkOL9MpB57g//1Q4SIRogDu6YEft4snKz1gEPVM5p0g?=
 =?us-ascii?Q?l1lIUtkzWabHrUCCY7nt07VpuDxhRCFMAS9fc++ZRBroC5kHN2698xUtcVh/?=
 =?us-ascii?Q?PlMpPAelgONIZ+oJbUZ/OGG5EdI5I8tTDhf2kevDDrK+DPyhZq1tei8IRFLT?=
 =?us-ascii?Q?TIbDN5nxgHUGb9YipS67KS9MtictXPcUFWWVFYVhjg2kXcG5mtGXjMfHd0A/?=
 =?us-ascii?Q?Nt10y7jTjRtSx1KUbgAAoZQMefJQirPTyN6YtPwiYtPlmpSjtFn6tc+NIIIB?=
 =?us-ascii?Q?coiKr8b3w8Cd/Rd3gQFgTb9dkblW+qtyHm+sGyXKrQ3egkjDygVAhw3zFw8S?=
 =?us-ascii?Q?08Sn3T+bMSOzBCBErCdPosXVSp32Bd5/P7hety6+fQEbjDmYtz+o4RTzBZ4J?=
 =?us-ascii?Q?gv3aTxNAp7LuaJlf4WwEjCrYzG0Nd8RQDBmV1NbrlHPkSMJGWLVJBaO7dgKu?=
 =?us-ascii?Q?vGIqYHA5Od3mrppruZrBp9E5Nf/l2MJrDmHtGQ8RKFX7HWesJhczzO86uVmL?=
 =?us-ascii?Q?mxaSdG/lNF7gR63D6uJal+0VcdCFU7KxC1O1DiG+LFcTugR7PeBD9k2vrDFI?=
 =?us-ascii?Q?z42e52FJfB6rByFRt6mn+01VYM4jvfNjrn0lE/jGlZaTeTRkyTYTUVIwdy1D?=
 =?us-ascii?Q?svRxI3fUqpAyem090cDHdCT3qkOG/ubbB/GXDdEzK53fEPf/56K3x2Ek0e/Z?=
 =?us-ascii?Q?v0sJMH6zbqr6vUxuLrMPPGstfyDYndsZ8QbtHCCf272SPU6JoX1P5/A5lcei?=
 =?us-ascii?Q?djWmwPJVNIStilRmL3MaGWS8wxRzK7mk0mjye7hSWIscZ6L7R2Y/qat22VPe?=
 =?us-ascii?Q?LXWvVRsNJCO/jiEiYNZq6mlHTw3e1Bv1IZlJc0VDGt+ybBRGKQtmeZAuG8/P?=
 =?us-ascii?Q?Gllssc7AfpN1y3T456z6qJGSd2Yzt4mNheO0ca1sVVAq+9C/3quBF1RP+KxT?=
 =?us-ascii?Q?UVsDb4/xeSxyF2HRIt1QbCYRBRHgan1eJ8xqqJADr/LBNf8Etyq3olb9G2/I?=
 =?us-ascii?Q?7hTzKiGUeMpDZbkb55D+1UgUrmuGOLfLwCT7y7BKgKa3qJyFrcTFU2/Q+amr?=
 =?us-ascii?Q?qaLwVc2OOowE/dFkBjkHIXpCq48Uz52yjWz7JDrZkFDUE6PHOKY9AWW6LL/+?=
 =?us-ascii?Q?yvbF/4vfWOBULomVOgiwBTMh7sXfNBUdpIU9YS/VcCdJnBqLTZj8PP+ypsqO?=
 =?us-ascii?Q?TsqOsCMgGpVnCoMXGMrL++KvSxfflK0JV7JVw2Z7xoiNyLkpeca9oqc37Osa?=
 =?us-ascii?Q?XYHRdLK2Sw8VPbsVQhyH7X2dF2a0j6y4PwwUugk0Uc1twQ=3D=3D?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a6654702-13a3-4529-fbd3-08d8e7a0060d
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2021 10:49:35.8416
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YhqWMlMoHKUOpODKi5K1y9LhNr5ypGHZ2qIIBpXJP9O3mPNwdPNjkl2KE5hfucf4bmu4nXsvmceUX/YDmwMY/w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0401MB2404
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alphabetically sort header inclusion

Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
---

 drivers/net/mdio/mdio-bcm-unimac.c      | 16 +++++++---------
 drivers/net/mdio/mdio-bitbang.c         |  4 ++--
 drivers/net/mdio/mdio-cavium.c          |  2 +-
 drivers/net/mdio/mdio-gpio.c            | 10 +++++-----
 drivers/net/mdio/mdio-ipq4019.c         |  4 ++--
 drivers/net/mdio/mdio-ipq8064.c         |  4 ++--
 drivers/net/mdio/mdio-mscc-miim.c       |  8 ++++----
 drivers/net/mdio/mdio-mux-bcm-iproc.c   | 10 +++++-----
 drivers/net/mdio/mdio-mux-gpio.c        |  8 ++++----
 drivers/net/mdio/mdio-mux-mmioreg.c     |  6 +++---
 drivers/net/mdio/mdio-mux-multiplexer.c |  2 +-
 drivers/net/mdio/mdio-mux.c             |  6 +++---
 drivers/net/mdio/mdio-octeon.c          |  8 ++++----
 drivers/net/mdio/mdio-thunder.c         | 10 +++++-----
 drivers/net/mdio/mdio-xgene.c           |  6 +++---
 drivers/net/mdio/of_mdio.c              | 10 +++++-----
 16 files changed, 56 insertions(+), 58 deletions(-)

diff --git a/drivers/net/mdio/mdio-bcm-unimac.c b/drivers/net/mdio/mdio-bcm-unimac.c
index fbd36891ee64..5d171e7f118d 100644
--- a/drivers/net/mdio/mdio-bcm-unimac.c
+++ b/drivers/net/mdio/mdio-bcm-unimac.c
@@ -5,20 +5,18 @@
  * Copyright (C) 2014-2017 Broadcom
  */
 
+#include <linux/clk.h>
+#include <linux/delay.h>
+#include <linux/io.h>
 #include <linux/kernel.h>
-#include <linux/phy.h>
-#include <linux/platform_device.h>
-#include <linux/sched.h>
 #include <linux/module.h>
-#include <linux/io.h>
-#include <linux/delay.h>
-#include <linux/clk.h>
-
 #include <linux/of.h>
-#include <linux/of_platform.h>
 #include <linux/of_mdio.h>
-
+#include <linux/of_platform.h>
+#include <linux/phy.h>
 #include <linux/platform_data/mdio-bcm-unimac.h>
+#include <linux/platform_device.h>
+#include <linux/sched.h>
 
 #define MDIO_CMD		0x00
 #define  MDIO_START_BUSY	(1 << 29)
diff --git a/drivers/net/mdio/mdio-bitbang.c b/drivers/net/mdio/mdio-bitbang.c
index d3915f831854..0f457c436335 100644
--- a/drivers/net/mdio/mdio-bitbang.c
+++ b/drivers/net/mdio/mdio-bitbang.c
@@ -14,10 +14,10 @@
  * Vitaly Bordug <vbordug@ru.mvista.com>
  */
 
-#include <linux/module.h>
+#include <linux/delay.h>
 #include <linux/mdio-bitbang.h>
+#include <linux/module.h>
 #include <linux/types.h>
-#include <linux/delay.h>
 
 #define MDIO_READ 2
 #define MDIO_WRITE 1
diff --git a/drivers/net/mdio/mdio-cavium.c b/drivers/net/mdio/mdio-cavium.c
index 1afd6fc1a351..95ce274c1be1 100644
--- a/drivers/net/mdio/mdio-cavium.c
+++ b/drivers/net/mdio/mdio-cavium.c
@@ -4,9 +4,9 @@
  */
 
 #include <linux/delay.h>
+#include <linux/io.h>
 #include <linux/module.h>
 #include <linux/phy.h>
-#include <linux/io.h>
 
 #include "mdio-cavium.h"
 
diff --git a/drivers/net/mdio/mdio-gpio.c b/drivers/net/mdio/mdio-gpio.c
index 1b00235d7dc5..56c8f914f893 100644
--- a/drivers/net/mdio/mdio-gpio.c
+++ b/drivers/net/mdio/mdio-gpio.c
@@ -17,15 +17,15 @@
  * Vitaly Bordug <vbordug@ru.mvista.com>
  */
 
-#include <linux/module.h>
-#include <linux/slab.h>
+#include <linux/gpio/consumer.h>
 #include <linux/interrupt.h>
-#include <linux/platform_device.h>
-#include <linux/platform_data/mdio-gpio.h>
 #include <linux/mdio-bitbang.h>
 #include <linux/mdio-gpio.h>
-#include <linux/gpio/consumer.h>
+#include <linux/module.h>
 #include <linux/of_mdio.h>
+#include <linux/platform_data/mdio-gpio.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
 
 struct mdio_gpio_info {
 	struct mdiobb_ctrl ctrl;
diff --git a/drivers/net/mdio/mdio-ipq4019.c b/drivers/net/mdio/mdio-ipq4019.c
index 25c25ea6da66..9cd71d896963 100644
--- a/drivers/net/mdio/mdio-ipq4019.c
+++ b/drivers/net/mdio/mdio-ipq4019.c
@@ -3,10 +3,10 @@
 /* Copyright (c) 2020 Sartura Ltd. */
 
 #include <linux/delay.h>
-#include <linux/kernel.h>
-#include <linux/module.h>
 #include <linux/io.h>
 #include <linux/iopoll.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
 #include <linux/of_address.h>
 #include <linux/of_mdio.h>
 #include <linux/phy.h>
diff --git a/drivers/net/mdio/mdio-ipq8064.c b/drivers/net/mdio/mdio-ipq8064.c
index 1bd18857e1c5..8fe8f0119fc1 100644
--- a/drivers/net/mdio/mdio-ipq8064.c
+++ b/drivers/net/mdio/mdio-ipq8064.c
@@ -7,12 +7,12 @@
 
 #include <linux/delay.h>
 #include <linux/kernel.h>
+#include <linux/mfd/syscon.h>
 #include <linux/module.h>
-#include <linux/regmap.h>
 #include <linux/of_mdio.h>
 #include <linux/phy.h>
 #include <linux/platform_device.h>
-#include <linux/mfd/syscon.h>
+#include <linux/regmap.h>
 
 /* MII address register definitions */
 #define MII_ADDR_REG_ADDR                       0x10
diff --git a/drivers/net/mdio/mdio-mscc-miim.c b/drivers/net/mdio/mdio-mscc-miim.c
index 11f583fd4611..b36e5ea04ddf 100644
--- a/drivers/net/mdio/mdio-mscc-miim.c
+++ b/drivers/net/mdio/mdio-mscc-miim.c
@@ -6,14 +6,14 @@
  * Copyright (c) 2017 Microsemi Corporation
  */
 
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/phy.h>
-#include <linux/platform_device.h>
 #include <linux/bitops.h>
 #include <linux/io.h>
 #include <linux/iopoll.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
 #include <linux/of_mdio.h>
+#include <linux/phy.h>
+#include <linux/platform_device.h>
 
 #define MSCC_MIIM_REG_STATUS		0x0
 #define		MSCC_MIIM_STATUS_STAT_PENDING	BIT(2)
diff --git a/drivers/net/mdio/mdio-mux-bcm-iproc.c b/drivers/net/mdio/mdio-mux-bcm-iproc.c
index 42fb5f166136..641cfa41f492 100644
--- a/drivers/net/mdio/mdio-mux-bcm-iproc.c
+++ b/drivers/net/mdio/mdio-mux-bcm-iproc.c
@@ -3,14 +3,14 @@
  * Copyright 2016 Broadcom
  */
 #include <linux/clk.h>
-#include <linux/platform_device.h>
+#include <linux/delay.h>
 #include <linux/device.h>
-#include <linux/of_mdio.h>
+#include <linux/iopoll.h>
+#include <linux/mdio-mux.h>
 #include <linux/module.h>
+#include <linux/of_mdio.h>
 #include <linux/phy.h>
-#include <linux/mdio-mux.h>
-#include <linux/delay.h>
-#include <linux/iopoll.h>
+#include <linux/platform_device.h>
 
 #define MDIO_RATE_ADJ_EXT_OFFSET	0x000
 #define MDIO_RATE_ADJ_INT_OFFSET	0x004
diff --git a/drivers/net/mdio/mdio-mux-gpio.c b/drivers/net/mdio/mdio-mux-gpio.c
index 10a758fdc9e6..3c7f16f06b45 100644
--- a/drivers/net/mdio/mdio-mux-gpio.c
+++ b/drivers/net/mdio/mdio-mux-gpio.c
@@ -3,13 +3,13 @@
  * Copyright (C) 2011, 2012 Cavium, Inc.
  */
 
-#include <linux/platform_device.h>
 #include <linux/device.h>
-#include <linux/of_mdio.h>
+#include <linux/gpio/consumer.h>
+#include <linux/mdio-mux.h>
 #include <linux/module.h>
+#include <linux/of_mdio.h>
 #include <linux/phy.h>
-#include <linux/mdio-mux.h>
-#include <linux/gpio/consumer.h>
+#include <linux/platform_device.h>
 
 #define DRV_VERSION "1.1"
 #define DRV_DESCRIPTION "GPIO controlled MDIO bus multiplexer driver"
diff --git a/drivers/net/mdio/mdio-mux-mmioreg.c b/drivers/net/mdio/mdio-mux-mmioreg.c
index d1a8780e24d8..c02fb2a067ee 100644
--- a/drivers/net/mdio/mdio-mux-mmioreg.c
+++ b/drivers/net/mdio/mdio-mux-mmioreg.c
@@ -7,13 +7,13 @@
  * Copyright 2012 Freescale Semiconductor, Inc.
  */
 
-#include <linux/platform_device.h>
 #include <linux/device.h>
+#include <linux/mdio-mux.h>
+#include <linux/module.h>
 #include <linux/of_address.h>
 #include <linux/of_mdio.h>
-#include <linux/module.h>
 #include <linux/phy.h>
-#include <linux/mdio-mux.h>
+#include <linux/platform_device.h>
 
 struct mdio_mux_mmioreg_state {
 	void *mux_handle;
diff --git a/drivers/net/mdio/mdio-mux-multiplexer.c b/drivers/net/mdio/mdio-mux-multiplexer.c
index d6564381aa3e..527acfc3c045 100644
--- a/drivers/net/mdio/mdio-mux-multiplexer.c
+++ b/drivers/net/mdio/mdio-mux-multiplexer.c
@@ -4,10 +4,10 @@
  * Copyright 2019 NXP
  */
 
-#include <linux/platform_device.h>
 #include <linux/mdio-mux.h>
 #include <linux/module.h>
 #include <linux/mux/consumer.h>
+#include <linux/platform_device.h>
 
 struct mdio_mux_multiplexer_state {
 	struct mux_control *muxc;
diff --git a/drivers/net/mdio/mdio-mux.c b/drivers/net/mdio/mdio-mux.c
index 6a1d3540210b..110e4ee85785 100644
--- a/drivers/net/mdio/mdio-mux.c
+++ b/drivers/net/mdio/mdio-mux.c
@@ -3,12 +3,12 @@
  * Copyright (C) 2011, 2012 Cavium, Inc.
  */
 
-#include <linux/platform_device.h>
-#include <linux/mdio-mux.h>
-#include <linux/of_mdio.h>
 #include <linux/device.h>
+#include <linux/mdio-mux.h>
 #include <linux/module.h>
+#include <linux/of_mdio.h>
 #include <linux/phy.h>
+#include <linux/platform_device.h>
 
 #define DRV_DESCRIPTION "MDIO bus multiplexer driver"
 
diff --git a/drivers/net/mdio/mdio-octeon.c b/drivers/net/mdio/mdio-octeon.c
index d1e1009d51af..8ce99c4888e1 100644
--- a/drivers/net/mdio/mdio-octeon.c
+++ b/drivers/net/mdio/mdio-octeon.c
@@ -3,13 +3,13 @@
  * Copyright (C) 2009-2015 Cavium, Inc.
  */
 
-#include <linux/platform_device.h>
+#include <linux/gfp.h>
+#include <linux/io.h>
+#include <linux/module.h>
 #include <linux/of_address.h>
 #include <linux/of_mdio.h>
-#include <linux/module.h>
-#include <linux/gfp.h>
 #include <linux/phy.h>
-#include <linux/io.h>
+#include <linux/platform_device.h>
 
 #include "mdio-cavium.h"
 
diff --git a/drivers/net/mdio/mdio-thunder.c b/drivers/net/mdio/mdio-thunder.c
index 3d7eda99d34e..cb1761693b69 100644
--- a/drivers/net/mdio/mdio-thunder.c
+++ b/drivers/net/mdio/mdio-thunder.c
@@ -3,14 +3,14 @@
  * Copyright (C) 2009-2016 Cavium, Inc.
  */
 
-#include <linux/of_address.h>
-#include <linux/of_mdio.h>
-#include <linux/module.h>
+#include <linux/acpi.h>
 #include <linux/gfp.h>
-#include <linux/phy.h>
 #include <linux/io.h>
-#include <linux/acpi.h>
+#include <linux/module.h>
+#include <linux/of_address.h>
+#include <linux/of_mdio.h>
 #include <linux/pci.h>
+#include <linux/phy.h>
 
 #include "mdio-cavium.h"
 
diff --git a/drivers/net/mdio/mdio-xgene.c b/drivers/net/mdio/mdio-xgene.c
index 461207cdf5d6..7ab4e26db08c 100644
--- a/drivers/net/mdio/mdio-xgene.c
+++ b/drivers/net/mdio/mdio-xgene.c
@@ -13,11 +13,11 @@
 #include <linux/io.h>
 #include <linux/mdio/mdio-xgene.h>
 #include <linux/module.h>
-#include <linux/of_platform.h>
-#include <linux/of_net.h>
 #include <linux/of_mdio.h>
-#include <linux/prefetch.h>
+#include <linux/of_net.h>
+#include <linux/of_platform.h>
 #include <linux/phy.h>
+#include <linux/prefetch.h>
 #include <net/ip.h>
 
 static bool xgene_mdio_status;
diff --git a/drivers/net/mdio/of_mdio.c b/drivers/net/mdio/of_mdio.c
index ea9d5855fb52..094494a68ddf 100644
--- a/drivers/net/mdio/of_mdio.c
+++ b/drivers/net/mdio/of_mdio.c
@@ -8,17 +8,17 @@
  * out of the OpenFirmware device tree and using it to populate an mii_bus.
  */
 
-#include <linux/kernel.h>
 #include <linux/device.h>
-#include <linux/netdevice.h>
 #include <linux/err.h>
-#include <linux/phy.h>
-#include <linux/phy_fixed.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/netdevice.h>
 #include <linux/of.h>
 #include <linux/of_irq.h>
 #include <linux/of_mdio.h>
 #include <linux/of_net.h>
-#include <linux/module.h>
+#include <linux/phy.h>
+#include <linux/phy_fixed.h>
 
 #define DEFAULT_GPIO_RESET_DELAY	10	/* in microseconds */
 
-- 
2.17.1

