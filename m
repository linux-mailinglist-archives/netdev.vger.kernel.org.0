Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEE083F0616
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 16:15:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239838AbhHROPX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 10:15:23 -0400
Received: from mail-eopbgr110107.outbound.protection.outlook.com ([40.107.11.107]:31128
        "EHLO GBR01-CWL-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239835AbhHROOn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Aug 2021 10:14:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EHbnEFsqZ6NSF6GvsDb7zLCwORgkXQ+i2JSlW1WuUiAIeCiMsLSqwP/zzzHiJF9FwiCfoCgs4GnN21cjKDobhzaBC7I4M3dflkZdRFHULYkJEn2Mv/+c1UUsZqQMTuDYXzYzYbwFwVIoHiXdrpa0EAz1LBKXNu5jSX5ahaxwLuAQF1KimL69m4xA7/IK94Hrlk2yNdx3aHNOnDM0r57STO51FU8IjbDevBe+Wvntj13wYYhz/qoYsjlE4slSJsLkKlySThhGXl8V0p6frS9vRKiCT9oUHekbcQ5lhxDh4CamDWK9IJrBFQbkz0Fdv92p9q+qW+LMrd30mJNOWaYGwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ApLoHeRK31DKGhWRmu2xxYr5QmHYjTkmXamwc9QILeQ=;
 b=W44Mn8BitpAFSr0adUWWelZ0SJ0DdPTsc7JkFehdGYtbo800BVGNXWRu6iqmi6V0nnmemh6WFjLNtW4EL0dMXpaKPp5bXh3qswd2wou/G8t21J80BiVKK+Hu2JE43Qm9xastbluOwt/B3KaL5IjhNIrE0YG3jxL9t632T24FvIcJH3jTJXxhV2SLXk7NuqEgbMapseGDevoEkdG44nEnnaJNp4TrBMtjQZMXx62ei7fTOnZ6Gj5StVn8tssE08i6nlS0bQJJPWhlrfcEXyOj3DN9eZ/3CoGmfiN6pai79UoWsb/0aJw81+LGfRqAixgIgCl4MnO9AwpVfbw7sQWEsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=purelifi.com; dmarc=pass action=none header.from=purelifi.com;
 dkim=pass header.d=purelifi.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=purevlc.onmicrosoft.com; s=selector2-purevlc-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ApLoHeRK31DKGhWRmu2xxYr5QmHYjTkmXamwc9QILeQ=;
 b=LcPaSrSd8LRRuE/TBs95671Cx4KmZa7K8s5iaRTcQYSgOfaizXjIgv9NsDMBWUEHk+G11BKqHzziyG/Hcb78CaNaZl+oyZMi4oYJ09zZuxuEiJh1ed+vbVfKrhwNSZ+HemSjlVY4EsWegHFVwzNHThIpXm77iQMYONj209qhmqA=
Authentication-Results: purelifi.com; dkim=none (message not signed)
 header.d=none;purelifi.com; dmarc=none action=none header.from=purelifi.com;
Received: from CWLP265MB3217.GBRP265.PROD.OUTLOOK.COM (2603:10a6:400:bb::9) by
 CWXP265MB3173.GBRP265.PROD.OUTLOOK.COM (2603:10a6:400:b5::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4415.17; Wed, 18 Aug 2021 14:14:04 +0000
Received: from CWLP265MB3217.GBRP265.PROD.OUTLOOK.COM
 ([fe80::b867:2f6b:483e:62e3]) by CWLP265MB3217.GBRP265.PROD.OUTLOOK.COM
 ([fe80::b867:2f6b:483e:62e3%9]) with mapi id 15.20.4436.019; Wed, 18 Aug 2021
 14:14:04 +0000
From:   Srinivasan Raju <srini.raju@purelifi.com>
Cc:     mostafa.afgani@purelifi.com,
        Srinivasan Raju <srini.raju@purelifi.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-kernel@vger.kernel.org (open list),
        linux-wireless@vger.kernel.org (open list:NETWORKING DRIVERS (WIRELESS)),
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS)
Subject: [PATCH] [v15] wireless: Initial driver submission for pureLiFi STA devices
Date:   Wed, 18 Aug 2021 15:13:00 +0100
Message-Id: <20210818141343.7833-1-srini.raju@purelifi.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210226130810.119216-1-srini.raju@purelifi.com>
References: <20210226130810.119216-1-srini.raju@purelifi.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LNXP265CA0090.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:76::30) To CWLP265MB3217.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:400:bb::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (46.226.5.242) by LNXP265CA0090.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:76::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Wed, 18 Aug 2021 14:14:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 50f02e16-111b-483d-4d65-08d962526ef6
X-MS-TrafficTypeDiagnostic: CWXP265MB3173:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CWXP265MB31739B473840C4F9C1722B36E0FF9@CWXP265MB3173.GBRP265.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:311;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ArfBjF0c8gCsnBSC/h22jH0QM1Lil9sfo02njMIK3Pqpxfb+JGw8FMwObxxMTbKUJUSCxyrUJS04yrO3z13ZgnrWAoRxsD6YLkUrARAysGg1f4bWmfm5IcdRCsxvc5H8uIgslrIQcQ8AbBaOt0e+4lzjfeVg6IFy7HlUgv3U+DH3FUjd2hBWPZMVMlfpX2vDqe/cA/SJEumydtFzvACTQJflkOllP9SqeJVqobmtQnSLqhd3Ofwpxx86aZMxCGrl7vMPuLHHC2ApnuA3eSAGH8OyMgzIs+W8Skq1FgBmIiKRDDLaM9ofAOjJZigPrkP7NMKyPSeITGPvRJR6pwoMyRdaAovb2wKvjZ9h4TAjgc9cYSUZ6pLuKQfgmIa86KhZcjY+g/jUQO/9SwzbPoxJ3W8ihdvb/Wq21Za7i0NNWkR2ejlUEpzugy55l8RxjoJ3WZqqNmLPMwMzI1KXJXWRBnlYSJBwD9sVbxtlw84xeDbtdtRrkwAK1bqOOpl/TVKiBTK6qFwvrq8iax8qJ9nfPoUxEhfHKlbkpu2soqeXBTXLW57y70vftR9uRuWntaxKdt4Ov2U3YT3R9yB8KKL05y/UBsfVKGlmDa8g83PMUiAbS7X00wNuL6yirHZ+UAQN/cZTLnY++iJF55I7lNLN8RMiYT0yV32T2iebBKgGbiGjGAc+4lWkF9hRoAIxWkHoPLHhm4V6hC1phRL8ZLXB7jd8QQ7UhoQxrOcAVa3+tCY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWLP265MB3217.GBRP265.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(6029001)(4636009)(366004)(83380400001)(109986005)(38100700002)(2906002)(8936002)(1076003)(6486002)(508600001)(66946007)(956004)(4326008)(66476007)(2616005)(66556008)(30864003)(8676002)(5660300002)(6506007)(54906003)(316002)(6512007)(26005)(186003)(86362001)(38350700002)(36756003)(52116002)(266003)(579004)(559001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dUN47nMEb30Tsk/ccuVKJgPnWhYTtGwH9qCwKVPRZYr4a1W5sPQnz+YMGBOl?=
 =?us-ascii?Q?vimmwkHS9rol7U9oFPBI5agnLofKn/9/jPnyuiA9y7/oZQMYWWzF1E81aj6j?=
 =?us-ascii?Q?rfBAxygg5lzwZZvWd+1t/fSuEzIX1IDEt431IaHv1s1Ju0MsnC18WKzP3uyP?=
 =?us-ascii?Q?EimvthXZRc6nsfuXINLqWcMLsns83dQVWoXcwx7YzmjrY8NOZOxa/a96oUvx?=
 =?us-ascii?Q?7X8lfa2L2mkmD6aeEUct7A+sF5CV3eIx9WYPVGyjtEohw1otARfh/2yDyA5j?=
 =?us-ascii?Q?AkReY7KkYfUp+/VWJIKV5YLGqccenNPXUQ06PcE27bMvV3I8D10qTts6z2hQ?=
 =?us-ascii?Q?kXqz3ZyRg1qzRUc3X61+ND/M8UKcZusP7VzzIeeLIMVzXjmOZ9vJUthFbYBp?=
 =?us-ascii?Q?5KdXYsCLphGFtv0iVIyOmr51wXIf4w3ixHw0mNxeTKR57WbWw3WzgTDLUh+B?=
 =?us-ascii?Q?papeXKEdqNXYa947Gi2kWsr02VV926AqMzmgtrLfIf+TA2ssMkhpSx+5uhfF?=
 =?us-ascii?Q?U3lfv/djx2Q71oOcLeRpeJLFCpjNDHus9ArINn9ik0dkrey0k6aBwjuIcN0a?=
 =?us-ascii?Q?/fFX0/88eM74LFQJbjMNssJAfz8MZMFwhFIY+BVVvOvABoZYSKKhreX3e5UD?=
 =?us-ascii?Q?C05v93Yfqg8J5pxpUl5B8IWvQWWz7hdrW69u6l2ZIQQqn/8j/U7ksLcXWEQ7?=
 =?us-ascii?Q?DhoW819WABfYSpY2ovAtnA9kGostFNCrO6WcxcbyL55wNYkX4tvZis/7KPpv?=
 =?us-ascii?Q?vGlbqwwdEG7uXXsZOVw9hZEFhzzKPIJYHCl1soMFiqUEBwh5a5KnvMRO4F2x?=
 =?us-ascii?Q?DSxPdLAAujJk8IgGYHCwtDo65gPVdOd01ky1n6/fal/DzBkt+h1lbashoYAp?=
 =?us-ascii?Q?MwEvsGjjkWMlwkIQq7PJFIhWb49+95kLQIbs5aA7wCTkw5AV03EL61K5i8Pz?=
 =?us-ascii?Q?9CitD4UDFDxNWeqdD+nJe5n79Du/FE5f53pKNyMND7eWGKvp9xj3zEddtIjo?=
 =?us-ascii?Q?cPuwkiLlb5XPLtpBhNEpFTW6G4X35sdKCKMBIuXcAoQc0cCLl1fcMPmAehZO?=
 =?us-ascii?Q?qaxAvQg8W7FPmm26jyYW8WA+uQzf/xTegXVAKQlASv5yc37KSSs1S/eQsOVf?=
 =?us-ascii?Q?hzNlpEde9G5g03eiUlDOyWFyS5BGpZIiI95mj66I91lB6zTrhV3Be0gIxNp2?=
 =?us-ascii?Q?mf67IViyIT0GaMO5HZDteFt4HdyrtO1/FxCM57Hp80WRkTsuLMOYkSy3WpmH?=
 =?us-ascii?Q?Q1wlDn41jpZNn+XpXxzdxFAk7IfpbGy+gFGRUat/3YyhM2un3P4b27dgOQVK?=
 =?us-ascii?Q?KrVM2Y4SFMxxJDwM4CwvFHZ8?=
X-OriginatorOrg: purelifi.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 50f02e16-111b-483d-4d65-08d962526ef6
X-MS-Exchange-CrossTenant-AuthSource: CWLP265MB3217.GBRP265.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2021 14:14:04.0839
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 5cf4eba2-7b8f-4236-bed4-a2ac41f1a6dc
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JKDWacQSbiNTxF92OwvDwxyDfETmkA1xkkx2rVLN3PSq/Q/Tn30OKKo4Tx8ZDzxsL3bQ/yoqOdzJxeT6JPhfrg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CWXP265MB3173
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This introduces the pureLiFi LiFi driver for LiFi-X, LiFi-XC
and LiFi-XL USB devices.

This driver implementation has been based on the zd1211rw driver.

Driver is based on 802.11 softMAC Architecture and uses
native 802.11 for configuration and management.

The driver is compiled and tested in ARM, x86 architectures and
compiled in powerpc architecture.

Signed-off-by: Srinivasan Raju <srini.raju@purelifi.com>

---
v15:
 - resubmit v14 of the patch
v14:
 - Endianess comments addressed
 - Sparse checked and fixed warnings
 - Firmware files renamed to lowercase
 - All other review comments in v13 addressed
v13:
- Removed unused #defines
v12:
- Removed sysfs, procfs related code
- Addressed race condition bug
- Used macros instead of magic numbers in firmware.c
- Added copyright in all files
v11, v10:
- Addressed review comment on readability
- Changed firmware names to match products
v9:
- Addressed review comments on style and content defects
- Used kmemdup instead of alloc and memcpy
v7 , v8:
- Magic numbers removed and used IEEE80211 macors
- Other code style and timer function fixes (mod_timer)
v6:
- Code style fix patch from Joe Perches
v5:
- Code refactoring for clarity and redundnacy removal
- Fix warnings from kernel test robot
v4:
- Code refactoring based on kernel code guidelines
- Remove multi level macors and use kernel debug macros
v3:
- Code style fixes kconfig fix
v2:
- Driver submitted to wireless-next
- Code style fixes and copyright statement fix
v1:
- Driver submitted to staging
---
---
 MAINTAINERS                                   |    6 +
 drivers/net/wireless/Kconfig                  |    1 +
 drivers/net/wireless/Makefile                 |    1 +
 drivers/net/wireless/purelifi/Kconfig         |   17 +
 drivers/net/wireless/purelifi/Makefile        |    2 +
 drivers/net/wireless/purelifi/plfxlc/Kconfig  |   14 +
 drivers/net/wireless/purelifi/plfxlc/Makefile |    3 +
 drivers/net/wireless/purelifi/plfxlc/chip.c   |   97 ++
 drivers/net/wireless/purelifi/plfxlc/chip.h   |   84 ++
 .../net/wireless/purelifi/plfxlc/firmware.c   |  292 +++++
 drivers/net/wireless/purelifi/plfxlc/intf.h   |   36 +
 drivers/net/wireless/purelifi/plfxlc/mac.c    |  841 ++++++++++++++
 drivers/net/wireless/purelifi/plfxlc/mac.h    |  194 ++++
 drivers/net/wireless/purelifi/plfxlc/usb.c    | 1014 +++++++++++++++++
 drivers/net/wireless/purelifi/plfxlc/usb.h    |  179 +++
 15 files changed, 2781 insertions(+)
 create mode 100644 drivers/net/wireless/purelifi/Kconfig
 create mode 100644 drivers/net/wireless/purelifi/Makefile
 create mode 100644 drivers/net/wireless/purelifi/plfxlc/Kconfig
 create mode 100644 drivers/net/wireless/purelifi/plfxlc/Makefile
 create mode 100644 drivers/net/wireless/purelifi/plfxlc/chip.c
 create mode 100644 drivers/net/wireless/purelifi/plfxlc/chip.h
 create mode 100644 drivers/net/wireless/purelifi/plfxlc/firmware.c
 create mode 100644 drivers/net/wireless/purelifi/plfxlc/intf.h
 create mode 100644 drivers/net/wireless/purelifi/plfxlc/mac.c
 create mode 100644 drivers/net/wireless/purelifi/plfxlc/mac.h
 create mode 100644 drivers/net/wireless/purelifi/plfxlc/usb.c
 create mode 100644 drivers/net/wireless/purelifi/plfxlc/usb.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 492bc169c3bd..1fd6f64c614c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -15040,6 +15040,12 @@ T:	git git://linuxtv.org/media_tree.git
 F:	Documentation/admin-guide/media/pulse8-cec.rst
 F:	drivers/media/cec/usb/pulse8/
 
+PURELIFI USB DRIVER
+M:	Srinivasan Raju <srini.raju@purelifi.com>
+L:	linux-wireless@vger.kernel.org
+S:	Supported
+F:	drivers/net/wireless/purelifi/
+
 PVRUSB2 VIDEO4LINUX DRIVER
 M:	Mike Isely <isely@pobox.com>
 L:	pvrusb2@isely.net	(subscribers-only)
diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
index 7add2002ff4c..404afe574920 100644
--- a/drivers/net/wireless/Kconfig
+++ b/drivers/net/wireless/Kconfig
@@ -28,6 +28,7 @@ source "drivers/net/wireless/intersil/Kconfig"
 source "drivers/net/wireless/marvell/Kconfig"
 source "drivers/net/wireless/mediatek/Kconfig"
 source "drivers/net/wireless/microchip/Kconfig"
+source "drivers/net/wireless/purelifi/Kconfig"
 source "drivers/net/wireless/ralink/Kconfig"
 source "drivers/net/wireless/realtek/Kconfig"
 source "drivers/net/wireless/rsi/Kconfig"
diff --git a/drivers/net/wireless/Makefile b/drivers/net/wireless/Makefile
index 80b324499786..e3345893c9c5 100644
--- a/drivers/net/wireless/Makefile
+++ b/drivers/net/wireless/Makefile
@@ -13,6 +13,7 @@ obj-$(CONFIG_WLAN_VENDOR_INTERSIL) += intersil/
 obj-$(CONFIG_WLAN_VENDOR_MARVELL) += marvell/
 obj-$(CONFIG_WLAN_VENDOR_MEDIATEK) += mediatek/
 obj-$(CONFIG_WLAN_VENDOR_MICROCHIP) += microchip/
+obj-$(CONFIG_WLAN_VENDOR_PURELIFI) += purelifi/
 obj-$(CONFIG_WLAN_VENDOR_RALINK) += ralink/
 obj-$(CONFIG_WLAN_VENDOR_REALTEK) += realtek/
 obj-$(CONFIG_WLAN_VENDOR_RSI) += rsi/
diff --git a/drivers/net/wireless/purelifi/Kconfig b/drivers/net/wireless/purelifi/Kconfig
new file mode 100644
index 000000000000..e39afec3dcae
--- /dev/null
+++ b/drivers/net/wireless/purelifi/Kconfig
@@ -0,0 +1,17 @@
+# SPDX-License-Identifier: GPL-2.0-only
+config WLAN_VENDOR_PURELIFI
+	bool "pureLiFi devices"
+	default y
+	help
+	  If you have a pureLiFi device, say Y.
+
+	  Note that the answer to this question doesn't directly affect the
+	  kernel: saying N will just cause the configurator to skip all the
+	  questions about these cards. If you say Y, you will be asked for
+	  your specific card in the following questions.
+
+if WLAN_VENDOR_PURELIFI
+
+source "drivers/net/wireless/purelifi/plfxlc/Kconfig"
+
+endif # WLAN_VENDOR_PURELIFI
diff --git a/drivers/net/wireless/purelifi/Makefile b/drivers/net/wireless/purelifi/Makefile
new file mode 100644
index 000000000000..56ebf96bd298
--- /dev/null
+++ b/drivers/net/wireless/purelifi/Makefile
@@ -0,0 +1,2 @@
+# SPDX-License-Identifier: GPL-2.0-only
+obj-$(CONFIG_PURELIFI_XLC)		:= plfxlc/
diff --git a/drivers/net/wireless/purelifi/plfxlc/Kconfig b/drivers/net/wireless/purelifi/plfxlc/Kconfig
new file mode 100644
index 000000000000..400ab2ee660c
--- /dev/null
+++ b/drivers/net/wireless/purelifi/plfxlc/Kconfig
@@ -0,0 +1,14 @@
+# SPDX-License-Identifier: GPL-2.0-only
+config PURELIFI_XLC
+	tristate "pureLiFi X, XL, XC device support"
+	depends on CFG80211 && MAC80211 && USB
+	help
+	   This option adds support for pureLiFi LiFi wireless USB adapters.
+
+	   The pureLiFi X, XL, XC USB devices are based on 802.11 OFDM PHY.
+
+	   Supports common 802.11 encryption/authentication methods including
+	   Open, WPA, WPA2-Personal and WPA2-Enterprise (802.1X).
+
+	   To compile this driver as a module, choose m here. The module will
+	   be called purelifi_xlc.
diff --git a/drivers/net/wireless/purelifi/plfxlc/Makefile b/drivers/net/wireless/purelifi/plfxlc/Makefile
new file mode 100644
index 000000000000..3d66f485c024
--- /dev/null
+++ b/drivers/net/wireless/purelifi/plfxlc/Makefile
@@ -0,0 +1,3 @@
+# SPDX-License-Identifier: GPL-2.0-only
+obj-$(CONFIG_PURELIFI_XLC)	:= purelifi_xlc.o
+purelifi_xlc-objs 		+= chip.o firmware.o usb.o mac.o
diff --git a/drivers/net/wireless/purelifi/plfxlc/chip.c b/drivers/net/wireless/purelifi/plfxlc/chip.c
new file mode 100644
index 000000000000..53ad5ebaa47c
--- /dev/null
+++ b/drivers/net/wireless/purelifi/plfxlc/chip.c
@@ -0,0 +1,97 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2021 pureLiFi
+ */
+
+#include <linux/kernel.h>
+#include <linux/errno.h>
+
+#include "chip.h"
+#include "mac.h"
+#include "usb.h"
+
+void purelifi_chip_init(struct purelifi_chip *chip,
+			struct ieee80211_hw *hw,
+			struct usb_interface *intf)
+{
+	memset(chip, 0, sizeof(*chip));
+	mutex_init(&chip->mutex);
+	purelifi_usb_init(&chip->usb, hw, intf);
+}
+
+void purelifi_chip_release(struct purelifi_chip *chip)
+{
+	purelifi_usb_release(&chip->usb);
+	mutex_destroy(&chip->mutex);
+}
+
+int purelifi_set_beacon_interval(struct purelifi_chip *chip, u16 interval,
+				 u8 dtim_period, int type)
+{
+	if (!interval ||
+	    (chip->beacon_set &&
+	     le16_to_cpu(chip->beacon_interval) == interval))
+		return 0;
+
+	chip->beacon_interval = cpu_to_le16(interval);
+	chip->beacon_set = true;
+	return plf_usb_wreq((const u8 *)&chip->beacon_interval,
+			     sizeof(chip->beacon_interval),
+			     USB_REQ_BEACON_INTERVAL_WR);
+}
+
+int purelifi_chip_init_hw(struct purelifi_chip *chip)
+{
+	unsigned char *addr = purelifi_mac_get_perm_addr(purelifi_chip_to_mac(chip));
+	struct usb_device *udev = interface_to_usbdev(chip->usb.intf);
+
+	pr_info("purelifi chip %04x:%04x v%02x %pM %s\n",
+		le16_to_cpu(udev->descriptor.idVendor),
+		le16_to_cpu(udev->descriptor.idProduct),
+		le16_to_cpu(udev->descriptor.bcdDevice),
+		addr,
+		purelifi_speed(udev->speed));
+
+	return purelifi_set_beacon_interval(chip, 100, 0, 0);
+}
+
+int purelifi_chip_switch_radio(struct purelifi_chip *chip, u16 value)
+{
+	int r;
+	__le16 radio_on = cpu_to_le16(value);
+
+	r = plf_usb_wreq((const u8 *)&radio_on, sizeof(value), USB_REQ_POWER_WR);
+	if (r)
+		dev_err(purelifi_chip_dev(chip), "POWER_WR failed (%d)\n", r);
+	return r;
+}
+
+int purelifi_chip_enable_rxtx(struct purelifi_chip *chip)
+{
+	purelifi_usb_enable_tx(&chip->usb);
+	return purelifi_usb_enable_rx(&chip->usb);
+}
+
+void purelifi_chip_disable_rxtx(struct purelifi_chip *chip)
+{
+	static const u8 value;
+
+	plf_usb_wreq(&value, sizeof(value), USB_REQ_RXTX_WR);
+	purelifi_usb_disable_rx(&chip->usb);
+	purelifi_usb_disable_tx(&chip->usb);
+}
+
+int purelifi_chip_set_rate(struct purelifi_chip *chip, u8 rate)
+{
+	int r;
+
+	if (!chip)
+		return -EINVAL;
+
+	r = plf_usb_wreq(&rate, sizeof(rate), USB_REQ_RATE_WR);
+	if (r)
+		dev_err(purelifi_chip_dev(chip), "RATE_WR failed (%d)\n", r);
+	return r;
+}
+
+MODULE_LICENSE("GPL");
diff --git a/drivers/net/wireless/purelifi/plfxlc/chip.h b/drivers/net/wireless/purelifi/plfxlc/chip.h
new file mode 100644
index 000000000000..6ba1875730b7
--- /dev/null
+++ b/drivers/net/wireless/purelifi/plfxlc/chip.h
@@ -0,0 +1,84 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (c) 2021 pureLiFi
+ */
+
+#ifndef _LF_X_CHIP_H
+#define _LF_X_CHIP_H
+
+#include <net/mac80211.h>
+
+#include "usb.h"
+
+enum unit_type_t {
+	STA = 0,
+	AP = 1,
+};
+
+struct purelifi_chip {
+	struct purelifi_usb usb;
+	struct mutex mutex; /* lock to protect chip data */
+	enum unit_type_t unit_type;
+	u16 link_led;
+	u8  beacon_set;
+	__le16 beacon_interval;
+};
+
+struct purelifi_mc_hash {
+	u32 low;
+	u32 high;
+};
+
+#define purelifi_chip_dev(chip) (&(chip)->usb.intf->dev)
+
+void purelifi_chip_init(struct purelifi_chip *chip,
+			struct ieee80211_hw *hw,
+			struct usb_interface *intf);
+
+void purelifi_chip_release(struct purelifi_chip *chip);
+
+void purelifi_chip_disable_rxtx(struct purelifi_chip *chip);
+
+int purelifi_chip_init_hw(struct purelifi_chip *chip);
+
+int purelifi_chip_enable_rxtx(struct purelifi_chip *chip);
+
+int purelifi_chip_set_rate(struct purelifi_chip *chip, u8 rate);
+
+int purelifi_set_beacon_interval(struct purelifi_chip *chip, u16 interval,
+				 u8 dtim_period, int type);
+
+int purelifi_chip_switch_radio(struct purelifi_chip *chip, u16 value);
+
+static inline struct purelifi_chip *purelifi_usb_to_chip(struct purelifi_usb
+							 *usb)
+{
+	return container_of(usb, struct purelifi_chip, usb);
+}
+
+static inline void purelifi_mc_clear(struct purelifi_mc_hash *hash)
+{
+	hash->low = 0;
+	/* The interfaces must always received broadcasts.
+	 * The hash of the broadcast address ff:ff:ff:ff:ff:ff is 63.
+	 */
+	hash->high = 0x80000000;
+}
+
+static inline void purelifi_mc_add_all(struct purelifi_mc_hash *hash)
+{
+	hash->low  = 0xffffffff;
+	hash->high = 0xffffffff;
+}
+
+static inline void purelifi_mc_add_addr(struct purelifi_mc_hash *hash,
+					u8 *addr)
+{
+	unsigned int i = addr[5] >> 2;
+
+	if (i < 32)
+		hash->low |= 1U << i;
+	else
+		hash->high |= 1 << (i - 32);
+}
+#endif /* _LF_X_CHIP_H */
diff --git a/drivers/net/wireless/purelifi/plfxlc/firmware.c b/drivers/net/wireless/purelifi/plfxlc/firmware.c
new file mode 100644
index 000000000000..d177fe7f4e76
--- /dev/null
+++ b/drivers/net/wireless/purelifi/plfxlc/firmware.c
@@ -0,0 +1,292 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2021 pureLiFi
+ */
+
+#include <linux/firmware.h>
+#include <linux/bitrev.h>
+
+#include "mac.h"
+#include "usb.h"
+
+static int send_vendor_request(struct usb_device *udev, int request,
+			       unsigned char *buffer, int buffer_size)
+{
+	return usb_control_msg(udev,
+			       usb_rcvctrlpipe(udev, 0),
+			       request, 0xC0, 0, 0,
+			       buffer, buffer_size, PLF_USB_TIMEOUT);
+}
+
+static int send_vendor_command(struct usb_device *udev, int request,
+			       unsigned char *buffer, int buffer_size)
+{
+	return usb_control_msg(udev,
+			       usb_sndctrlpipe(udev, 0),
+			       request, USB_TYPE_VENDOR /*0x40*/, 0, 0,
+			       buffer, buffer_size, PLF_USB_TIMEOUT);
+}
+
+int download_fpga(struct usb_interface *intf)
+{
+#define PLF_VNDR_FPGA_STATE_REQ 0x30
+#define PLF_VNDR_FPGA_SET_REQ 0x33
+#define PLF_VNDR_FPGA_SET_CMD 0x34
+#define PLF_VNDR_FPGA_STATE_CMD 0x35
+	int r, actual_length;
+	int fw_data_i, blk_tran_len = PLF_BULK_TLEN;
+	const char *fw_name;
+	unsigned char *fpga_dmabuff = NULL;
+	unsigned char *fw_data;
+	const struct firmware *fw = NULL;
+	struct usb_device *udev = interface_to_usbdev(intf);
+
+	if ((le16_to_cpu(udev->descriptor.idVendor) ==
+				PURELIFI_X_VENDOR_ID_0) &&
+	    (le16_to_cpu(udev->descriptor.idProduct) ==
+				PURELIFI_X_PRODUCT_ID_0)) {
+		fw_name = "plfxlc/lifi-x.bin";
+		dev_dbg(&intf->dev, "bin file for X selected\n");
+
+	} else if ((le16_to_cpu(udev->descriptor.idVendor)) ==
+					PURELIFI_XC_VENDOR_ID_0 &&
+		   (le16_to_cpu(udev->descriptor.idProduct) ==
+					PURELIFI_XC_PRODUCT_ID_0)) {
+		fw_name = "plfxlc/lifi-xc.bin";
+		dev_dbg(&intf->dev, "bin file for XC selected\n");
+
+	} else {
+		r = -EINVAL;
+		goto error;
+	}
+
+	r = request_firmware(&fw, fw_name, &intf->dev);
+	if (r) {
+		dev_err(&intf->dev, "request_firmware failed (%d)\n", r);
+		goto error;
+	}
+	fpga_dmabuff = kmalloc(PLF_FPGA_STATUS_LEN, GFP_KERNEL);
+
+	if (!fpga_dmabuff) {
+		r = -ENOMEM;
+		goto error_free_fw;
+	}
+	send_vendor_request(udev, PLF_VNDR_FPGA_SET_REQ,
+			    fpga_dmabuff, PLF_FPGA_STATUS_LEN);
+
+	send_vendor_command(udev, PLF_VNDR_FPGA_SET_CMD, NULL, 0);
+
+	if (fpga_dmabuff[0] != PLF_FPGA_MG) {
+		dev_err(&intf->dev, "fpga_dmabuff[0] is wrong\n");
+		r = -EINVAL;
+		goto error_free_fw;
+	}
+
+	for (fw_data_i = 0; fw_data_i < fw->size;) {
+		int tbuf_idx;
+
+		if ((fw->size - fw_data_i) < blk_tran_len)
+			blk_tran_len = fw->size - fw_data_i;
+
+		fw_data = kmemdup(&fw->data[fw_data_i], blk_tran_len,
+				  GFP_KERNEL);
+
+		for (tbuf_idx = 0; tbuf_idx < blk_tran_len; tbuf_idx++) {
+			/* u8 bit reverse */
+			fw_data[tbuf_idx] = bitrev8(fw_data[tbuf_idx]);
+		}
+		r = usb_bulk_msg(udev,
+				 usb_sndbulkpipe(interface_to_usbdev(intf),
+						 fpga_dmabuff[0] & 0xff),
+				 fw_data,
+				 blk_tran_len,
+				 &actual_length,
+				 2 * PLF_USB_TIMEOUT);
+
+		if (r)
+			dev_err(&intf->dev, "Bulk msg failed (%d)\n", r);
+
+		kfree(fw_data);
+		fw_data_i += blk_tran_len;
+	}
+
+	kfree(fpga_dmabuff);/* free PLF_FPGA_STATUS_LEN*/
+	fpga_dmabuff = NULL;
+	fpga_dmabuff = kmalloc(PLF_FPGA_STATE_LEN, GFP_KERNEL);
+	if (!fpga_dmabuff) {
+		r = -ENOMEM;
+		goto error_free_fw;
+	}
+	memset(fpga_dmabuff, 0xff, PLF_FPGA_STATE_LEN);
+
+	send_vendor_request(udev, PLF_VNDR_FPGA_STATE_REQ, fpga_dmabuff,
+			    PLF_FPGA_STATE_LEN);
+
+	dev_dbg(&intf->dev, "%*ph\n", 8, fpga_dmabuff);
+
+	if (fpga_dmabuff[0] != 0) {
+		r = -EINVAL;
+		goto error_free_fw;
+	}
+
+	send_vendor_command(udev, PLF_VNDR_FPGA_STATE_CMD, NULL, 0);
+
+	msleep(PLF_MSLEEP_TIME);
+
+error_free_fw:
+	kfree(fpga_dmabuff);
+	release_firmware(fw);
+error:
+	return r;
+}
+
+int download_xl_firmware(struct usb_interface *intf)
+{
+#define PLF_VNDR_XL_FW_CMD 0x80
+#define PLF_VNDR_XL_DATA_CMD 0x81
+#define PLF_VNDR_XL_FILE_CMD 0x82
+#define PLF_VNDR_XL_EX_CMD 0x83
+	const struct firmware *fwp = NULL;
+	struct firmware_file file = {0};
+	int s, r;
+	u8 *buf;
+	u32 i;
+	const char *fw_pack;
+	struct usb_device *udev = interface_to_usbdev(intf);
+
+	r = send_vendor_command(udev, PLF_VNDR_XL_FW_CMD, NULL, 0);
+	msleep(PLF_MSLEEP_TIME);
+
+	if (r) {
+		dev_err(&intf->dev, "vendor command failed (%d)\n", r);
+		return -EINVAL;
+	}
+	/* Code for single pack file download */
+
+	fw_pack = "plfxlc/lifi-xl.bin";
+
+	r = request_firmware(&fwp, fw_pack, &intf->dev);
+	if (r) {
+		dev_err(&intf->dev, "request_firmware failed (%d)\n", r);
+		return -EINVAL;
+	}
+	file.total_files = get_unaligned_le32(&fwp->data[0]);
+	file.total_size = get_unaligned_le32(&fwp->size);
+
+	dev_dbg(&intf->dev, "XL Firmware (%d, %d)\n",
+		file.total_files, file.total_size);
+
+	buf = kzalloc(PLF_XL_BUF_LEN, GFP_KERNEL);
+	if (!buf) {
+		release_firmware(fwp);
+		return -ENOMEM;
+	}
+
+	if (file.total_files > 10) {
+		dev_err(&intf->dev, "Too many files (%d)\n", file.total_files);
+		release_firmware(fwp);
+		kfree(buf);
+		return -EINVAL;
+	}
+
+	/* Download firmware files in multiple steps */
+	for (s = 0; s < file.total_files; s++) {
+		buf[0] = s;
+		r = send_vendor_command(udev, PLF_VNDR_XL_FILE_CMD, buf,
+					PLF_XL_BUF_LEN);
+
+		if (s < file.total_files - 1)
+			file.size = get_unaligned_le32(&fwp->data[4 + ((s + 1) * 4)])
+				    - get_unaligned_le32(&fwp->data[4 + (s) * 4]);
+		else
+			file.size = file.total_size -
+				    get_unaligned_le32(&fwp->data[4 + (s) * 4]);
+
+		if (file.size > file.total_size || file.size > 60000) {
+			dev_err(&intf->dev, "file size is too large (%d)\n", file.size);
+			break;
+		}
+
+		file.start_addr = get_unaligned_le32(&fwp->data[4 + (s * 4)]);
+
+		if (file.size % PLF_XL_BUF_LEN && s < 2)
+			file.size += PLF_XL_BUF_LEN - file.size % PLF_XL_BUF_LEN;
+
+		file.control_packets = file.size / PLF_XL_BUF_LEN;
+
+		for (i = 0; i < file.control_packets; i++) {
+			memcpy(buf,
+			       &fwp->data[file.start_addr + (i * PLF_XL_BUF_LEN)],
+			       PLF_XL_BUF_LEN);
+			r = send_vendor_command(udev, PLF_VNDR_XL_DATA_CMD, buf,
+						PLF_XL_BUF_LEN);
+		}
+		dev_dbg(&intf->dev, "fw-dw step=%d,r=%d size=%d\n", s, r,
+			file.size);
+	}
+	release_firmware(fwp);
+	kfree(buf);
+
+	/* Code for single pack file download ends fw download finish*/
+
+	r = send_vendor_command(udev, PLF_VNDR_XL_EX_CMD, NULL, 0);
+	dev_dbg(&intf->dev, "download_fpga (4) (%d)\n", r);
+
+	return 0;
+}
+
+struct flash_t {
+	unsigned char enabled;
+	unsigned int sector_size;
+	unsigned int sectors;
+	unsigned char ec;
+};
+
+int upload_mac_and_serial(struct usb_interface *intf,
+			  unsigned char *hw_address,
+			  unsigned char *serial_number)
+{
+#define PLF_MAC_VENDOR_REQUEST 0x36
+#define PLF_SERIAL_NUMBER_VENDOR_REQUEST 0x37
+#define PLF_FIRMWARE_VERSION_VENDOR_REQUEST 0x39
+#define PLF_SERIAL_LEN 14
+#define PLF_FW_VER_LEN 8
+	struct usb_device *udev = interface_to_usbdev(intf);
+	unsigned char *dma_buffer = NULL;
+	unsigned long long firmware_version;
+
+	dma_buffer = kmalloc(PLF_SERIAL_LEN, GFP_KERNEL);
+	if (!dma_buffer)
+		return -ENOMEM;
+
+	BUILD_BUG_ON(ETH_ALEN > PLF_SERIAL_LEN);
+	BUILD_BUG_ON(PLF_FW_VER_LEN > PLF_SERIAL_LEN);
+
+	send_vendor_request(udev, PLF_MAC_VENDOR_REQUEST, dma_buffer,
+			    ETH_ALEN);
+
+	memcpy(hw_address, dma_buffer, ETH_ALEN);
+
+	send_vendor_request(udev, PLF_SERIAL_NUMBER_VENDOR_REQUEST,
+			    dma_buffer, PLF_SERIAL_LEN);
+
+	send_vendor_request(udev, PLF_SERIAL_NUMBER_VENDOR_REQUEST,
+			    dma_buffer, PLF_SERIAL_LEN);
+
+	memcpy(serial_number, dma_buffer, PLF_SERIAL_LEN);
+
+	memset(dma_buffer, 0x00, PLF_SERIAL_LEN);
+
+	send_vendor_request(udev, PLF_FIRMWARE_VERSION_VENDOR_REQUEST,
+			    (unsigned char *)dma_buffer, PLF_FW_VER_LEN);
+
+	memcpy(&firmware_version, dma_buffer, PLF_FW_VER_LEN);
+
+	dev_info(&intf->dev, "Firmware Version: %llu\n", firmware_version);
+	kfree(dma_buffer);
+
+	dev_dbg(&intf->dev, "Mac: %pM\n", hw_address);
+
+	return 0;
+}
+
diff --git a/drivers/net/wireless/purelifi/plfxlc/intf.h b/drivers/net/wireless/purelifi/plfxlc/intf.h
new file mode 100644
index 000000000000..93b77b7666b6
--- /dev/null
+++ b/drivers/net/wireless/purelifi/plfxlc/intf.h
@@ -0,0 +1,36 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (c) 2021 pureLiFi
+ */
+
+#define PURELIFI_BYTE_NUM_ALIGNMENT 4
+#define ETH_ALEN 6
+#define AP_USER_LIMIT 8
+
+struct rx_status {
+	__be16 rssi;
+	u8     rate_idx;
+	u8     pad;
+	__be64 crc_error_count;
+} __packed;
+
+enum usb_req_enum_t {
+	USB_REQ_TEST_WR            = 0,
+	USB_REQ_MAC_WR             = 1,
+	USB_REQ_POWER_WR           = 2,
+	USB_REQ_RXTX_WR            = 3,
+	USB_REQ_BEACON_WR          = 4,
+	USB_REQ_BEACON_INTERVAL_WR = 5,
+	USB_REQ_RTS_CTS_RATE_WR    = 6,
+	USB_REQ_HASH_WR            = 7,
+	USB_REQ_DATA_TX            = 8,
+	USB_REQ_RATE_WR            = 9,
+	USB_REQ_SET_FREQ           = 15
+};
+
+struct usb_req_t {
+	__be32         id; /* should be usb_req_enum_t */
+	__be32	       len;
+	u8             buf[512];
+};
+
diff --git a/drivers/net/wireless/purelifi/plfxlc/mac.c b/drivers/net/wireless/purelifi/plfxlc/mac.c
new file mode 100644
index 000000000000..35d80985ea9f
--- /dev/null
+++ b/drivers/net/wireless/purelifi/plfxlc/mac.c
@@ -0,0 +1,841 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2021 pureLiFi
+ */
+
+#include <linux/netdevice.h>
+#include <linux/etherdevice.h>
+#include <linux/slab.h>
+#include <linux/usb.h>
+#include <linux/gpio.h>
+#include <linux/jiffies.h>
+#include <net/ieee80211_radiotap.h>
+
+#include "chip.h"
+#include "mac.h"
+#include "usb.h"
+
+static const struct ieee80211_rate purelifi_rates[] = {
+	{ .bitrate = 10,
+		.hw_value = PURELIFI_CCK_RATE_1M,
+		.flags = 0 },
+	{ .bitrate = 20,
+		.hw_value = PURELIFI_CCK_RATE_2M,
+		.hw_value_short = PURELIFI_CCK_RATE_2M
+			| PURELIFI_CCK_PREA_SHORT,
+		.flags = IEEE80211_RATE_SHORT_PREAMBLE },
+	{ .bitrate = 55,
+		.hw_value = PURELIFI_CCK_RATE_5_5M,
+		.hw_value_short = PURELIFI_CCK_RATE_5_5M
+			| PURELIFI_CCK_PREA_SHORT,
+		.flags = IEEE80211_RATE_SHORT_PREAMBLE },
+	{ .bitrate = 110,
+		.hw_value = PURELIFI_CCK_RATE_11M,
+		.hw_value_short = PURELIFI_CCK_RATE_11M
+			| PURELIFI_CCK_PREA_SHORT,
+		.flags = IEEE80211_RATE_SHORT_PREAMBLE },
+	{ .bitrate = 60,
+		.hw_value = PURELIFI_OFDM_RATE_6M,
+		.flags = 0 },
+	{ .bitrate = 90,
+		.hw_value = PURELIFI_OFDM_RATE_9M,
+		.flags = 0 },
+	{ .bitrate = 120,
+		.hw_value = PURELIFI_OFDM_RATE_12M,
+		.flags = 0 },
+	{ .bitrate = 180,
+		.hw_value = PURELIFI_OFDM_RATE_18M,
+		.flags = 0 },
+	{ .bitrate = 240,
+		.hw_value = PURELIFI_OFDM_RATE_24M,
+		.flags = 0 },
+	{ .bitrate = 360,
+		.hw_value = PURELIFI_OFDM_RATE_36M,
+		.flags = 0 },
+	{ .bitrate = 480,
+		.hw_value = PURELIFI_OFDM_RATE_48M,
+		.flags = 0 },
+	{ .bitrate = 540,
+		.hw_value = PURELIFI_OFDM_RATE_54M,
+		.flags = 0 }
+};
+
+static const struct ieee80211_channel purelifi_channels[] = {
+	{ .center_freq = 2412, .hw_value = 1 },
+	{ .center_freq = 2417, .hw_value = 2 },
+	{ .center_freq = 2422, .hw_value = 3 },
+	{ .center_freq = 2427, .hw_value = 4 },
+	{ .center_freq = 2432, .hw_value = 5 },
+	{ .center_freq = 2437, .hw_value = 6 },
+	{ .center_freq = 2442, .hw_value = 7 },
+	{ .center_freq = 2447, .hw_value = 8 },
+	{ .center_freq = 2452, .hw_value = 9 },
+	{ .center_freq = 2457, .hw_value = 10 },
+	{ .center_freq = 2462, .hw_value = 11 },
+	{ .center_freq = 2467, .hw_value = 12 },
+	{ .center_freq = 2472, .hw_value = 13 },
+	{ .center_freq = 2484, .hw_value = 14 },
+};
+
+static int purelifi_mac_config_beacon(struct ieee80211_hw *hw,
+				      struct sk_buff *beacon);
+
+int purelifi_mac_preinit_hw(struct ieee80211_hw *hw, const u8 *hw_address)
+{
+	SET_IEEE80211_PERM_ADDR(hw, hw_address);
+	return 0;
+}
+
+void purelifi_block_queue(struct purelifi_usb *usb, bool block)
+{
+	if (block)
+		ieee80211_stop_queues(purelifi_usb_to_hw(usb));
+	else
+		ieee80211_wake_queues(purelifi_usb_to_hw(usb));
+}
+
+int purelifi_mac_init_hw(struct ieee80211_hw *hw)
+{
+	int r;
+	struct purelifi_mac *mac = purelifi_hw_mac(hw);
+	struct purelifi_chip *chip = &mac->chip;
+
+	r = purelifi_chip_init_hw(chip);
+	if (r) {
+		dev_warn(purelifi_mac_dev(mac), "init hw failed (%d)\n", r);
+		return r;
+	}
+
+	dev_dbg(purelifi_mac_dev(mac), "irq_disabled (%d)\n", irqs_disabled());
+	regulatory_hint(hw->wiphy, "00");
+	return r;
+}
+
+void purelifi_mac_release(struct purelifi_mac *mac)
+{
+	purelifi_chip_release(&mac->chip);
+	lockdep_assert_held(&mac->lock);
+}
+
+int purelifi_op_start(struct ieee80211_hw *hw)
+{
+	purelifi_hw_mac(hw)->chip.usb.initialized = 1;
+	return 0;
+}
+
+void purelifi_op_stop(struct ieee80211_hw *hw)
+{
+	struct purelifi_mac *mac = purelifi_hw_mac(hw);
+
+	clear_bit(PURELIFI_DEVICE_RUNNING, &mac->flags);
+}
+
+int purelifi_restore_settings(struct purelifi_mac *mac)
+{
+	struct sk_buff *beacon;
+	int beacon_interval, beacon_period;
+
+	spin_lock_irq(&mac->lock);
+	beacon_interval = mac->beacon.interval;
+	beacon_period = mac->beacon.period;
+	spin_unlock_irq(&mac->lock);
+
+	if (mac->type != NL80211_IFTYPE_ADHOC)
+		return 0;
+
+	if (mac->vif) {
+		beacon = ieee80211_beacon_get(mac->hw, mac->vif);
+		if (beacon) {
+			purelifi_mac_config_beacon(mac->hw, beacon);
+			kfree_skb(beacon);
+			/* Returned skb is used only once and lowlevel
+			 *  driver is responsible for freeing it.
+			 */
+		}
+	}
+
+	purelifi_set_beacon_interval(&mac->chip, beacon_interval,
+				     beacon_period, mac->type);
+
+	spin_lock_irq(&mac->lock);
+	mac->beacon.last_update = jiffies;
+	spin_unlock_irq(&mac->lock);
+
+	return 0;
+}
+
+/**
+ * purelifi_mac_tx_status: reports tx status of a packet if required
+ * @hw: a &struct ieee80211_hw pointer
+ * @skb: a sk-buffer
+ * @flags: extra flags to set in the TX status info
+ * @ackssi: ACK signal strength
+ * @success: True for successful transmission of the frame
+ *
+ * This information calls ieee80211_tx_status_irqsafe() if required by the
+ * control information. It copies the control information into the status
+ * information.
+ *
+ */
+static void purelifi_mac_tx_status(struct ieee80211_hw *hw,
+				   struct sk_buff *skb,
+				   int ackssi,
+				   struct tx_status *tx_status)
+{
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	int success = 1;
+
+	ieee80211_tx_info_clear_status(info);
+
+	if (tx_status)
+		success = !tx_status->failure;
+
+	if (success)
+		info->flags |= IEEE80211_TX_STAT_ACK;
+	else
+		info->flags &= ~IEEE80211_TX_STAT_ACK;
+
+	info->status.ack_signal = 50;
+	ieee80211_tx_status_irqsafe(hw, skb);
+}
+
+/**
+ * purelifi_mac_tx_to_dev: callback for USB layer
+ * @skb: a &sk_buff pointer
+ * @error: error value, 0 if transmission successful
+ *
+ * Informs the MAC layer that the frame has successfully transferred to the
+ * device. If an ACK is required and the transfer to the device has been
+ * successful, the packets are put on the @ack_wait_queue with
+ * the control set removed.
+ */
+void purelifi_mac_tx_to_dev(struct sk_buff *skb, int error)
+{
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	struct ieee80211_hw *hw = info->rate_driver_data[0];
+	struct purelifi_mac *mac = purelifi_hw_mac(hw);
+
+	ieee80211_tx_info_clear_status(info);
+	skb_pull(skb, sizeof(struct purelifi_ctrlset));
+
+	if (unlikely(error ||
+		     (info->flags & IEEE80211_TX_CTL_NO_ACK))) {
+		ieee80211_tx_status_irqsafe(hw, skb);
+	} else {
+		struct sk_buff_head *q = &mac->ack_wait_queue;
+
+		skb_queue_tail(q, skb);
+		while (skb_queue_len(q)/* > PURELIFI_MAC_MAX_ACK_WAITERS*/) {
+			purelifi_mac_tx_status(hw, skb_dequeue(q),
+					       mac->ack_pending ?
+					       mac->ack_signal : 0,
+					       NULL);
+			mac->ack_pending = 0;
+		}
+	}
+}
+
+static int purelifi_mac_config_beacon(struct ieee80211_hw *hw,
+				      struct sk_buff *beacon)
+{
+	return plf_usb_wreq((const u8 *)beacon->data, beacon->len,
+			USB_REQ_BEACON_WR);
+}
+
+static int fill_ctrlset(struct purelifi_mac *mac, struct sk_buff *skb)
+{
+	unsigned int frag_len = skb->len;
+	unsigned int tmp;
+	u32 temp_len = 0;
+	u32 temp_payload_len = 0;
+	struct purelifi_ctrlset *cs;
+
+	if (skb_headroom(skb) < sizeof(struct purelifi_ctrlset)) {
+		dev_dbg(purelifi_mac_dev(mac), "Not enough hroom(1)\n");
+		return 1;
+	}
+
+	cs = (void *)skb_push(skb, sizeof(struct purelifi_ctrlset));
+	temp_payload_len = frag_len;
+	temp_len = temp_payload_len +
+		  sizeof(struct purelifi_ctrlset) -
+		  sizeof(cs->id) - sizeof(cs->len);
+
+	/* data packet lengths must be multiple of four bytes
+	 * and must not be a multiple of 512
+	 * bytes. First, it is attempted to append the
+	 * data packet in the tailroom of the skb. In rare
+	 * ocasions, the tailroom is too small. In this case,
+	 * the content of the packet is shifted into
+	 * the headroom of the skb by memcpy. Headroom is allocated
+	 * at startup (below in this file). Therefore,
+	 * there will be always enough headroom. The call skb_headroom
+	 * is an additional safety which might be
+	 * dropped.
+	 */
+
+	/*check if 32 bit aligned and align data*/
+	tmp = skb->len & 3;
+	if (tmp) {
+		if (skb_tailroom(skb) < (3 - tmp)) {
+			if (skb_headroom(skb) >= 4 - tmp) {
+				u8 len;
+				u8 *src_pt;
+				u8 *dest_pt;
+
+				len = skb->len;
+				src_pt = skb->data;
+				dest_pt = skb_push(skb, 4 - tmp);
+				memmove(dest_pt, src_pt, len);
+			} else {
+				return -ENOBUFS;
+			}
+		} else {
+			skb_put(skb, 4 - tmp);
+		}
+		temp_len += 4 - tmp;
+	}
+
+	/* check if not multiple of 512 and align data*/
+	tmp = skb->len & 0x1ff;
+	if (!tmp) {
+		if (skb_tailroom(skb) < 4) {
+			if (skb_headroom(skb) >= 4) {
+				u8 len = skb->len;
+				u8 *src_pt = skb->data;
+				u8 *dest_pt = skb_push(skb, 4);
+
+				memcpy(dest_pt, src_pt, len);
+			} else {
+				/* should never happen because
+				 * sufficient headroom was reserved
+				 */
+				return -ENOBUFS;
+			}
+		} else {
+			skb_put(skb, 4);
+		}
+		temp_len += 4;
+	}
+
+	cs->id = cpu_to_be32(USB_REQ_DATA_TX);
+	cs->len = cpu_to_be32(temp_len);
+	cs->payload_len_nw = cpu_to_be32(temp_payload_len);
+
+	return 0;
+}
+
+/**
+ * purelifi_op_tx: transmits a network frame to the device
+ *
+ * @dev: mac80211 hardware device
+ * @skb: socket buffer
+ * @control: the control structure
+ *
+ * This function transmit an IEEE 802.11 network frame to the device. The
+ * control block of the skbuff will be initialized. If necessary the incoming
+ * mac80211 queues will be stopped.
+ */
+static void purelifi_op_tx(struct ieee80211_hw *hw,
+			   struct ieee80211_tx_control *control,
+			   struct sk_buff *skb)
+{
+	struct purelifi_mac *mac = purelifi_hw_mac(hw);
+	struct purelifi_usb *usb = &mac->chip.usb;
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	struct purelifi_header *plhdr = (void *)skb->data;
+	unsigned long flags;
+	int r;
+
+	r = fill_ctrlset(mac, skb);
+	if (r)
+		goto fail;
+
+	info->rate_driver_data[0] = hw;
+
+	if (plhdr->frametype  == IEEE80211_FTYPE_DATA) {
+		u8 *dst_mac = plhdr->dmac;
+		u8 sidx;
+		bool found = false;
+		struct purelifi_usb_tx *tx = &usb->tx;
+
+		for (sidx = 0; sidx < MAX_STA_NUM; sidx++) {
+			if (!(tx->station[sidx].flag & STATION_CONNECTED_FLAG))
+				continue;
+			if (!memcmp(tx->station[sidx].mac, dst_mac, ETH_ALEN)) {
+				found = true;
+				break;
+			}
+		}
+
+		/* Default to broadcast address for unknown MACs */
+		if (!found)
+			sidx = STA_BROADCAST_INDEX;
+
+		/* Stop OS from sending packets, if the queue is half full */
+		if (skb_queue_len(&tx->station[sidx].data_list) > 60)
+			purelifi_block_queue(usb, true);
+
+		/* Schedule packet for transmission if queue is not full */
+		if (skb_queue_len(&tx->station[sidx].data_list) < 256) {
+			skb_queue_tail(&tx->station[sidx].data_list, skb);
+			purelifi_send_packet_from_data_queue(usb);
+		} else {
+			goto fail;
+		}
+	} else {
+		spin_lock_irqsave(&usb->tx.lock, flags);
+		r = plf_usb_wreq_async(&mac->chip.usb, skb->data, skb->len,
+				       USB_REQ_DATA_TX, tx_urb_complete, skb);
+		spin_unlock_irqrestore(&usb->tx.lock, flags);
+		if (r)
+			goto fail;
+	}
+	return;
+
+fail:
+	dev_kfree_skb(skb);
+}
+
+/**
+ * purelifi_filter_ack: filters incoming packets for acknowledgements
+ * @dev: the mac80211 device
+ * @rx_hdr: received header
+ * @stats: the status for the received packet
+ *
+ * This functions looks for ACK packets and tries to match them with the
+ * frames in the tx queue. If a match is found the frame will be dequeued and
+ * the upper layers is informed about the successful transmission. If
+ * mac80211 queues have been stopped and the number of frames still to be
+ * transmitted is low the queues will be opened again.
+ *
+ * Returns 1 if the frame was an ACK, 0 if it was ignored.
+ */
+static int purelifi_filter_ack(struct ieee80211_hw *hw, struct ieee80211_hdr *rx_hdr,
+			       struct ieee80211_rx_status *stats)
+{
+	struct purelifi_mac *mac = purelifi_hw_mac(hw);
+	struct sk_buff *skb;
+	struct sk_buff_head *q;
+	unsigned long flags;
+	bool found = 0;
+	int i, position = 0;
+
+	if (!ieee80211_is_ack(rx_hdr->frame_control))
+		return 0;
+
+	dev_dbg(purelifi_mac_dev(mac), "ACK Received\n");
+
+	/* code based on zy driver, this logic may need fix */
+	q = &mac->ack_wait_queue;
+	spin_lock_irqsave(&q->lock, flags);
+
+	skb_queue_walk(q, skb) {
+		struct ieee80211_hdr *tx_hdr;
+
+		position++;
+
+		if (mac->ack_pending && skb_queue_is_first(q, skb))
+			continue;
+		else if (mac->ack_pending == 0)
+			break;
+
+		tx_hdr = (struct ieee80211_hdr *)skb->data;
+		if (likely(ether_addr_equal(tx_hdr->addr2, rx_hdr->addr1))) {
+			found = 1;
+			break;
+		}
+	}
+
+	if (found) {
+		for (i = 1; i < position; i++)
+			skb = __skb_dequeue(q);
+		if (i == position) {
+			purelifi_mac_tx_status(hw, skb,
+					       mac->ack_pending ?
+					       mac->ack_signal : 0,
+					       NULL);
+			mac->ack_pending = 0;
+		}
+
+		mac->ack_pending = skb_queue_len(q) ? 1 : 0;
+		mac->ack_signal = stats->signal;
+	}
+
+	spin_unlock_irqrestore(&q->lock, flags);
+	return 1;
+}
+
+int purelifi_mac_rx(struct ieee80211_hw *hw, const u8 *buffer,
+		    unsigned int length)
+{
+	struct purelifi_mac *mac = purelifi_hw_mac(hw);
+	struct ieee80211_rx_status stats;
+	const struct rx_status *status;
+	struct sk_buff *skb;
+	int bad_frame = 0;
+	__le16 fc;
+	int need_padding;
+	unsigned int payload_length;
+	static unsigned short int min_exp_seq_nmb;
+	int sidx;
+	struct purelifi_usb_tx *tx;
+
+	/* Packet blockade during disabled interface. */
+	if (!mac->vif)
+		return 0;
+
+	memset(&stats, 0, sizeof(stats));
+	status = (struct rx_status *)buffer;
+
+	stats.flag     = 0;
+	stats.freq     = 2412;
+	stats.band     = NL80211_BAND_2GHZ;
+	mac->rssi      = -15 * be16_to_cpu(status->rssi) / 10;
+
+	stats.signal   = mac->rssi;
+
+	if (status->rate_idx > 7)
+		stats.rate_idx = 0;
+	else
+		stats.rate_idx = status->rate_idx;
+
+	mac->crc_errors = be64_to_cpu(status->crc_error_count);
+
+	if (!bad_frame &&
+	    purelifi_filter_ack(hw, (struct ieee80211_hdr *)buffer, &stats) &&
+	    !mac->pass_ctrl)
+		return 0;
+
+	buffer += sizeof(struct rx_status);
+	payload_length = get_unaligned_be32(buffer);
+
+	/* MTU = 1500, MAC header = 36, CRC = 4, sum = 1540 */
+	if (payload_length > 1560) {
+		dev_err(purelifi_mac_dev(mac), " > MTU %u\n", payload_length);
+		return 0;
+	}
+	buffer += sizeof(u32);
+
+	fc = get_unaligned((__le16 *)buffer);
+	need_padding = ieee80211_is_data_qos(fc) ^ ieee80211_has_a4(fc);
+
+	tx = &mac->chip.usb.tx;
+
+	for (sidx = 0; sidx < MAX_STA_NUM - 1; sidx++) {
+		if (memcmp(&buffer[10], tx->station[sidx].mac, ETH_ALEN))
+			continue;
+		if (tx->station[sidx].flag & STATION_CONNECTED_FLAG) {
+			tx->station[sidx].flag |= STATION_HEARTBEAT_FLAG;
+			break;
+		}
+	}
+
+	if (sidx == MAX_STA_NUM - 1) {
+		for (sidx = 0; sidx < MAX_STA_NUM - 1; sidx++) {
+			if (tx->station[sidx].flag & STATION_CONNECTED_FLAG)
+				continue;
+			memcpy(tx->station[sidx].mac, &buffer[10], ETH_ALEN);
+			tx->station[sidx].flag |= STATION_CONNECTED_FLAG;
+			tx->station[sidx].flag |= STATION_HEARTBEAT_FLAG;
+			break;
+		}
+	}
+
+	switch (buffer[0]) {
+	unsigned short int seq_nmb;
+
+	case IEEE80211_STYPE_PROBE_REQ:
+		dev_dbg(purelifi_mac_dev(mac), "Probe request\n");
+		break;
+	case IEEE80211_STYPE_ASSOC_REQ:
+		dev_dbg(purelifi_mac_dev(mac), "Association request\n");
+		break;
+	case IEEE80211_STYPE_AUTH:
+		dev_dbg(purelifi_mac_dev(mac), "Authentication req\n");
+		min_exp_seq_nmb = 0;
+		break;
+	case IEEE80211_FTYPE_DATA:
+		seq_nmb = (buffer[23] << 4) | ((buffer[22] & 0xF0) >> 4);
+
+		if (seq_nmb < min_exp_seq_nmb &&
+		    ((min_exp_seq_nmb - seq_nmb) < 3000))
+			dev_dbg(purelifi_mac_dev(mac), "seq_nmb < min_exp\n");
+		else
+			min_exp_seq_nmb = (seq_nmb + 1) % 4096;
+		break;
+	}
+
+	skb = dev_alloc_skb(payload_length + (need_padding ? 2 : 0));
+	if (!skb)
+		return -ENOMEM;
+
+	if (need_padding)
+		/* Make sure that the payload data is 4 byte aligned. */
+		skb_reserve(skb, 2);
+
+	skb_put_data(skb, buffer, payload_length);
+	memcpy(IEEE80211_SKB_RXCB(skb), &stats, sizeof(stats));
+	ieee80211_rx_irqsafe(hw, skb);
+	return 0;
+}
+
+static int purelifi_op_add_interface(struct ieee80211_hw *hw,
+				     struct ieee80211_vif *vif)
+{
+	struct purelifi_mac *mac = purelifi_hw_mac(hw);
+	static const char * const iftype80211[] = {
+		[NL80211_IFTYPE_STATION]	= "Station",
+		[NL80211_IFTYPE_ADHOC]		= "Adhoc"
+	};
+
+	if (mac->type != NL80211_IFTYPE_UNSPECIFIED)
+		return -EOPNOTSUPP;
+
+	if (vif->type == NL80211_IFTYPE_ADHOC ||
+	    vif->type == NL80211_IFTYPE_STATION) {
+		dev_dbg(purelifi_mac_dev(mac), "%s %s\n", __func__,
+			iftype80211[vif->type]);
+		mac->type = vif->type;
+		mac->vif = vif;
+	} else {
+		dev_dbg(purelifi_mac_dev(mac), "unsupported iftype\n");
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
+static void purelifi_op_remove_interface(struct ieee80211_hw *hw,
+					 struct ieee80211_vif *vif)
+{
+	struct purelifi_mac *mac = purelifi_hw_mac(hw);
+
+	mac->type = NL80211_IFTYPE_UNSPECIFIED;
+	mac->vif = NULL;
+}
+
+static int purelifi_op_config(struct ieee80211_hw *hw, u32 changed)
+{
+	return 0;
+}
+
+#define SUPPORTED_FIF_FLAGS \
+	(FIF_ALLMULTI | FIF_FCSFAIL | FIF_CONTROL | \
+	 FIF_OTHER_BSS | FIF_BCN_PRBRESP_PROMISC)
+static void purelifi_op_configure_filter(struct ieee80211_hw *hw,
+					 unsigned int changed_flags,
+					 unsigned int *new_flags,
+					 u64 multicast)
+{
+	struct purelifi_mc_hash hash = {
+		.low = multicast,
+		.high = multicast >> 32,
+	};
+	struct purelifi_mac *mac = purelifi_hw_mac(hw);
+	unsigned long flags;
+
+	/* Only deal with supported flags */
+	changed_flags &= SUPPORTED_FIF_FLAGS;
+	*new_flags &= SUPPORTED_FIF_FLAGS;
+
+	/* If multicast parameter
+	 * (as returned by purelifi_op_prepare_multicast)
+	 * has changed, no bit in changed_flags is set. To handle this
+	 * situation, we do not return if changed_flags is 0. If we do so,
+	 * we will have some issue with IPv6 which uses multicast for link
+	 * layer address resolution.
+	 */
+	if (*new_flags & (FIF_ALLMULTI))
+		purelifi_mc_add_all(&hash);
+
+	spin_lock_irqsave(&mac->lock, flags);
+	mac->pass_failed_fcs = !!(*new_flags & FIF_FCSFAIL);
+	mac->pass_ctrl = !!(*new_flags & FIF_CONTROL);
+	mac->multicast_hash = hash;
+	spin_unlock_irqrestore(&mac->lock, flags);
+
+	/* no handling required for FIF_OTHER_BSS as we don't currently
+	 * do BSSID filtering
+	 */
+	/* FIXME: in future it would be nice to enable the probe response
+	 * filter (so that the driver doesn't see them) until
+	 * FIF_BCN_PRBRESP_PROMISC is set. however due to atomicity here, we'd
+	 * have to schedule work to enable prbresp reception, which might
+	 * happen too late. For now we'll just listen and forward them all the
+	 * time.
+	 */
+}
+
+static void purelifi_op_bss_info_changed(struct ieee80211_hw *hw,
+					 struct ieee80211_vif *vif,
+					 struct ieee80211_bss_conf *bss_conf,
+					 u32 changes)
+{
+	struct purelifi_mac *mac = purelifi_hw_mac(hw);
+	int associated;
+
+	dev_dbg(purelifi_mac_dev(mac), "changes: %x\n", changes);
+
+	if (mac->type != NL80211_IFTYPE_ADHOC) { /* for STATION */
+		associated = is_valid_ether_addr(bss_conf->bssid);
+		goto exit_all;
+	}
+	/* for ADHOC */
+	associated = true;
+	if (changes & BSS_CHANGED_BEACON) {
+		struct sk_buff *beacon = ieee80211_beacon_get(hw, vif);
+
+		if (beacon) {
+			purelifi_mac_config_beacon(hw, beacon);
+			kfree_skb(beacon);
+			/*Returned skb is used only once and
+			 * low-level driver is
+			 * responsible for freeing it.
+			 */
+		}
+	}
+
+	if (changes & BSS_CHANGED_BEACON_ENABLED) {
+		u16 interval = 0;
+		u8 period = 0;
+
+		if (bss_conf->enable_beacon) {
+			period = bss_conf->dtim_period;
+			interval = bss_conf->beacon_int;
+		}
+
+		spin_lock_irq(&mac->lock);
+		mac->beacon.period = period;
+		mac->beacon.interval = interval;
+		mac->beacon.last_update = jiffies;
+		spin_unlock_irq(&mac->lock);
+
+		purelifi_set_beacon_interval(&mac->chip, interval,
+					     period, mac->type);
+	}
+exit_all:
+	spin_lock_irq(&mac->lock);
+	mac->associated = associated;
+	spin_unlock_irq(&mac->lock);
+}
+
+static int purelifi_get_stats(struct ieee80211_hw *hw,
+			      struct ieee80211_low_level_stats *stats)
+{
+	stats->dot11ACKFailureCount = 0;
+	stats->dot11RTSFailureCount = 0;
+	stats->dot11FCSErrorCount = 0;
+	stats->dot11RTSSuccessCount = 0;
+	return 0;
+}
+
+static const char et_strings[][ETH_GSTRING_LEN] = {
+	"phy_rssi",
+	"phy_rx_crc_err"
+};
+
+static int purelifi_get_et_sset_count(struct ieee80211_hw *hw,
+				      struct ieee80211_vif *vif, int sset)
+{
+	if (sset == ETH_SS_STATS)
+		return ARRAY_SIZE(et_strings);
+
+	return 0;
+}
+
+static void purelifi_get_et_strings(struct ieee80211_hw *hw,
+				    struct ieee80211_vif *vif,
+				    u32 sset, u8 *data)
+{
+	if (sset == ETH_SS_STATS)
+		memcpy(data, *et_strings, sizeof(et_strings));
+}
+
+static void purelifi_get_et_stats(struct ieee80211_hw *hw,
+				  struct ieee80211_vif *vif,
+				  struct ethtool_stats *stats, u64 *data)
+{
+	struct purelifi_mac *mac = purelifi_hw_mac(hw);
+
+	data[0] = mac->rssi;
+	data[1] = mac->crc_errors;
+}
+
+static int purelifi_set_rts_threshold(struct ieee80211_hw *hw, u32 value)
+{
+	return 0;
+}
+
+static const struct ieee80211_ops purelifi_ops = {
+	.tx                 = purelifi_op_tx,
+	.start              = purelifi_op_start,
+	.stop               = purelifi_op_stop,
+	.add_interface      = purelifi_op_add_interface,
+	.remove_interface   = purelifi_op_remove_interface,
+	.set_rts_threshold  = purelifi_set_rts_threshold,
+	.config             = purelifi_op_config,
+	.configure_filter   = purelifi_op_configure_filter,
+	.bss_info_changed   = purelifi_op_bss_info_changed,
+	.get_stats          = purelifi_get_stats,
+	.get_et_sset_count  = purelifi_get_et_sset_count,
+	.get_et_stats       = purelifi_get_et_stats,
+	.get_et_strings     = purelifi_get_et_strings,
+};
+
+struct ieee80211_hw *purelifi_mac_alloc_hw(struct usb_interface *intf)
+{
+	struct purelifi_mac *mac;
+	struct ieee80211_hw *hw;
+
+	hw = ieee80211_alloc_hw(sizeof(struct purelifi_mac), &purelifi_ops);
+	if (!hw) {
+		dev_dbg(&intf->dev, "out of memory\n");
+		return NULL;
+	}
+	set_wiphy_dev(hw->wiphy, &intf->dev);
+
+	mac = purelifi_hw_mac(hw);
+	memset(mac, 0, sizeof(*mac));
+	spin_lock_init(&mac->lock);
+	mac->hw = hw;
+
+	mac->type = NL80211_IFTYPE_UNSPECIFIED;
+
+	memcpy(mac->channels, purelifi_channels, sizeof(purelifi_channels));
+	memcpy(mac->rates, purelifi_rates, sizeof(purelifi_rates));
+	mac->band.n_bitrates = ARRAY_SIZE(purelifi_rates);
+	mac->band.bitrates = mac->rates;
+	mac->band.n_channels = ARRAY_SIZE(purelifi_channels);
+	mac->band.channels = mac->channels;
+
+	hw->wiphy->bands[NL80211_BAND_2GHZ] = &mac->band;
+
+	ieee80211_hw_set(hw, RX_INCLUDES_FCS);
+	ieee80211_hw_set(hw, SIGNAL_DBM);
+	ieee80211_hw_set(hw, HOST_BROADCAST_PS_BUFFERING);
+	ieee80211_hw_set(hw, MFP_CAPABLE);
+
+	hw->wiphy->interface_modes =
+		BIT(NL80211_IFTYPE_STATION) |
+		BIT(NL80211_IFTYPE_ADHOC);
+
+	hw->max_signal = 100;
+	hw->queues = 1;
+	hw->extra_tx_headroom = sizeof(struct purelifi_ctrlset) + 4;
+	/* 4 for 32 bit alignment if no tailroom */
+
+	/* Tell mac80211 that we support multi rate retries */
+	hw->max_rates = IEEE80211_TX_MAX_RATES;
+	hw->max_rate_tries = 18;   /* 9 rates * 2 retries/rate */
+
+	skb_queue_head_init(&mac->ack_wait_queue);
+	mac->ack_pending = 0;
+
+	purelifi_chip_init(&mac->chip, hw, intf);
+
+	SET_IEEE80211_DEV(hw, &intf->dev);
+	return hw;
+}
+
+MODULE_LICENSE("GPL");
diff --git a/drivers/net/wireless/purelifi/plfxlc/mac.h b/drivers/net/wireless/purelifi/plfxlc/mac.h
new file mode 100644
index 000000000000..49c08ba07260
--- /dev/null
+++ b/drivers/net/wireless/purelifi/plfxlc/mac.h
@@ -0,0 +1,194 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (c) 2021 pureLiFi
+ */
+
+#ifndef _PURELIFI_MAC_H
+#define _PURELIFI_MAC_H
+
+#include <linux/kernel.h>
+#include <net/mac80211.h>
+
+#include "chip.h"
+
+#define PURELIFI_CCK                  0x00
+#define PURELIFI_OFDM                 0x10
+#define PURELIFI_CCK_PREA_SHORT       0x20
+
+#define PURELIFI_OFDM_PLCP_RATE_6M	0xb
+#define PURELIFI_OFDM_PLCP_RATE_9M	0xf
+#define PURELIFI_OFDM_PLCP_RATE_12M	0xa
+#define PURELIFI_OFDM_PLCP_RATE_18M	0xe
+#define PURELIFI_OFDM_PLCP_RATE_24M	0x9
+#define PURELIFI_OFDM_PLCP_RATE_36M	0xd
+#define PURELIFI_OFDM_PLCP_RATE_48M	0x8
+#define PURELIFI_OFDM_PLCP_RATE_54M	0xc
+
+#define PURELIFI_CCK_RATE_1M	(PURELIFI_CCK | 0x00)
+#define PURELIFI_CCK_RATE_2M	(PURELIFI_CCK | 0x01)
+#define PURELIFI_CCK_RATE_5_5M	(PURELIFI_CCK | 0x02)
+#define PURELIFI_CCK_RATE_11M	(PURELIFI_CCK | 0x03)
+#define PURELIFI_OFDM_RATE_6M	(PURELIFI_OFDM | PURELIFI_OFDM_PLCP_RATE_6M)
+#define PURELIFI_OFDM_RATE_9M	(PURELIFI_OFDM | PURELIFI_OFDM_PLCP_RATE_9M)
+#define PURELIFI_OFDM_RATE_12M	(PURELIFI_OFDM | PURELIFI_OFDM_PLCP_RATE_12M)
+#define PURELIFI_OFDM_RATE_18M	(PURELIFI_OFDM | PURELIFI_OFDM_PLCP_RATE_18M)
+#define PURELIFI_OFDM_RATE_24M	(PURELIFI_OFDM | PURELIFI_OFDM_PLCP_RATE_24M)
+#define PURELIFI_OFDM_RATE_36M	(PURELIFI_OFDM | PURELIFI_OFDM_PLCP_RATE_36M)
+#define PURELIFI_OFDM_RATE_48M	(PURELIFI_OFDM | PURELIFI_OFDM_PLCP_RATE_48M)
+#define PURELIFI_OFDM_RATE_54M	(PURELIFI_OFDM | PURELIFI_OFDM_PLCP_RATE_54M)
+
+#define PURELIFI_RX_ERROR		0x80
+#define PURELIFI_RX_CRC32_ERROR		0x10
+
+#define PLF_REGDOMAIN_FCC	0x10
+#define PLF_REGDOMAIN_IC	0x20
+#define PLF_REGDOMAIN_ETSI	0x30
+#define PLF_REGDOMAIN_SPAIN	0x31
+#define PLF_REGDOMAIN_FRANCE	0x32
+#define PLF_REGDOMAIN_JAPAN_2	0x40
+#define PLF_REGDOMAIN_JAPAN	0x41
+#define PLF_REGDOMAIN_JAPAN_3	0x49
+
+enum {
+	MODULATION_RATE_BPSK_1_2 = 0,
+	MODULATION_RATE_BPSK_3_4,
+	MODULATION_RATE_QPSK_1_2,
+	MODULATION_RATE_QPSK_3_4,
+	MODULATION_RATE_QAM16_1_2,
+	MODULATION_RATE_QAM16_3_4,
+	MODULATION_RATE_QAM64_1_2,
+	MODULATION_RATE_QAM64_3_4,
+	MODULATION_RATE_AUTO,
+	MODULATION_RATE_NUM
+};
+
+#define purelifi_mac_dev(mac) (purelifi_chip_dev(&(mac)->chip))
+
+#define PURELIFI_MAC_STATS_BUFFER_SIZE 16
+#define PURELIFI_MAC_MAX_ACK_WAITERS 50
+
+struct purelifi_ctrlset {
+	__be32		id;/*should be usb_req_enum_t*/
+	__be32		len;
+	u8              modulation;
+	u8              control;
+	u8              service;
+	u8		pad;
+	__le16		packet_length;
+	__le16		current_length;
+	__le16		next_frame_length;
+	__le16		tx_length;
+	__be32		payload_len_nw;
+} __packed;
+
+/*overlay*/
+struct purelifi_header {
+	struct purelifi_ctrlset plf_ctrl;
+	u32    frametype;
+	u8    *dmac;
+} __packed;
+
+struct tx_status {
+	u8 type;
+	u8 id;
+	u8 rate;
+	u8 pad;
+	u8 mac[ETH_ALEN];
+	u8 retry;
+	u8 failure;
+} __packed;
+
+enum mac_flags {
+	MAC_FIXED_CHANNEL = 0x01,
+};
+
+struct beacon {
+	struct delayed_work watchdog_work;
+	struct sk_buff *cur_beacon;
+	unsigned long last_update;
+	u16 interval;
+	u8 period;
+};
+
+enum purelifi_device_flags {
+	PURELIFI_DEVICE_RUNNING,
+};
+
+struct purelifi_mac {
+	struct purelifi_chip chip;
+	spinlock_t lock; /* lock for mac data */
+	struct ieee80211_hw *hw;
+	struct ieee80211_vif *vif;
+	struct beacon beacon;
+	struct work_struct set_rts_cts_work;
+	struct work_struct process_intr;
+	struct purelifi_mc_hash multicast_hash;
+	u8 intr_buffer[USB_MAX_EP_INT_BUFFER];
+	u8 regdomain;
+	u8 default_regdomain;
+	u8 channel;
+	int type;
+	int associated;
+	unsigned long flags;
+	struct sk_buff_head ack_wait_queue;
+	struct ieee80211_channel channels[14];
+	struct ieee80211_rate rates[12];
+	struct ieee80211_supported_band band;
+
+	/* whether to pass frames with CRC errors to stack */
+	unsigned int pass_failed_fcs:1;
+
+	/* whether to pass control frames to stack */
+	unsigned int pass_ctrl:1;
+
+	/* whether we have received a 802.11 ACK that is pending */
+	bool ack_pending;
+
+	/* signal strength of the last 802.11 ACK received */
+	int ack_signal;
+
+	unsigned char hw_address[ETH_ALEN];
+	char serial_number[256];
+	u64 crc_errors;
+	u64 rssi;
+};
+
+static inline struct purelifi_mac *
+purelifi_hw_mac(struct ieee80211_hw *hw)
+{
+	return hw->priv;
+}
+
+static inline struct purelifi_mac *
+purelifi_chip_to_mac(struct purelifi_chip *chip)
+{
+	return container_of(chip, struct purelifi_mac, chip);
+}
+
+static inline struct purelifi_mac *
+purelifi_usb_to_mac(struct purelifi_usb *usb)
+{
+	return purelifi_chip_to_mac(purelifi_usb_to_chip(usb));
+}
+
+static inline u8 *purelifi_mac_get_perm_addr(struct purelifi_mac *mac)
+{
+	return mac->hw->wiphy->perm_addr;
+}
+
+struct ieee80211_hw *purelifi_mac_alloc_hw(struct usb_interface *intf);
+void purelifi_mac_release(struct purelifi_mac *mac);
+
+int purelifi_mac_preinit_hw(struct ieee80211_hw *hw, const u8 *hw_address);
+int purelifi_mac_init_hw(struct ieee80211_hw *hw);
+
+int purelifi_mac_rx(struct ieee80211_hw *hw, const u8 *buffer,
+		    unsigned int length);
+void purelifi_mac_tx_failed(struct urb *urb);
+void purelifi_mac_tx_to_dev(struct sk_buff *skb, int error);
+int purelifi_op_start(struct ieee80211_hw *hw);
+void purelifi_op_stop(struct ieee80211_hw *hw);
+int purelifi_restore_settings(struct purelifi_mac *mac);
+void purelifi_block_queue(struct purelifi_usb *usb, bool block);
+
+#endif
diff --git a/drivers/net/wireless/purelifi/plfxlc/usb.c b/drivers/net/wireless/purelifi/plfxlc/usb.c
new file mode 100644
index 000000000000..b48d69902a76
--- /dev/null
+++ b/drivers/net/wireless/purelifi/plfxlc/usb.c
@@ -0,0 +1,1014 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2021 pureLiFi
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/device.h>
+#include <linux/errno.h>
+#include <linux/slab.h>
+#include <linux/skbuff.h>
+#include <linux/usb.h>
+#include <linux/workqueue.h>
+#include <linux/proc_fs.h>
+#include <linux/fs.h>
+#include <linux/string.h>
+#include <linux/module.h>
+#include <net/mac80211.h>
+#include <asm/unaligned.h>
+#include <linux/version.h>
+#include <linux/sysfs.h>
+
+#include "mac.h"
+#include "usb.h"
+
+static atomic_t data_queue_flag;
+
+/*Tx retry backoff timer (in milliseconds).*/
+# define TX_RETRY_BACKOFF_MS 10
+# define STA_QUEUE_CLEANUP_MS 5000
+
+/*Tx retry backoff timer (in jiffies).*/
+# define TX_RETRY_BACKOFF_JIFF ((TX_RETRY_BACKOFF_MS * HZ) / 1000)
+# define STA_QUEUE_CLEANUP_JIFF ((STA_QUEUE_CLEANUP_MS * HZ) / 1000)
+
+static struct usb_device_id usb_ids[] = {
+	{ USB_DEVICE(PURELIFI_X_VENDOR_ID_0, PURELIFI_X_PRODUCT_ID_0),
+	  .driver_info = DEVICE_LIFI_X },
+	{ USB_DEVICE(PURELIFI_XC_VENDOR_ID_0, PURELIFI_XC_PRODUCT_ID_0),
+	  .driver_info = DEVICE_LIFI_XC },
+	{ USB_DEVICE(PURELIFI_XL_VENDOR_ID_0, PURELIFI_XL_PRODUCT_ID_0),
+	  .driver_info = DEVICE_LIFI_XL },
+	{}
+};
+
+static struct usb_interface *ez_usb_interface;
+
+static inline u16 get_bcd_device(const struct usb_device *udev)
+{
+	return le16_to_cpu(udev->descriptor.bcdDevice);
+}
+
+/* Ensures that MAX_TRANSFER_SIZE is even. */
+#define MAX_TRANSFER_SIZE (USB_MAX_TRANSFER_SIZE & ~1)
+
+#define urb_dev(urb) (&(urb)->dev->dev)
+
+void purelifi_send_packet_from_data_queue(struct purelifi_usb *usb)
+{
+	struct sk_buff *skb = NULL;
+	unsigned long flags;
+	static u8 sidx;
+	u8 last_served_sidx;
+	struct purelifi_usb_tx *tx = &usb->tx;
+
+	spin_lock_irqsave(&tx->lock, flags);
+	last_served_sidx = sidx;
+	do {
+		sidx = (sidx + 1) % MAX_STA_NUM;
+		if (!tx->station[sidx].flag & STATION_CONNECTED_FLAG)
+			continue;
+		if (!(tx->station[sidx].flag & STATION_FIFO_FULL_FLAG))
+			skb = skb_peek(&tx->station[sidx].data_list);
+	} while ((sidx != last_served_sidx) && (!skb));
+
+	if (skb) {
+		skb = skb_dequeue(&tx->station[sidx].data_list);
+		plf_usb_wreq_async(usb, skb->data, skb->len, USB_REQ_DATA_TX,
+				   tx_urb_complete, skb);
+		if (skb_queue_len(&tx->station[sidx].data_list) <= 60)
+			purelifi_block_queue(usb, false);
+	}
+	spin_unlock_irqrestore(&tx->lock, flags);
+}
+
+static void handle_rx_packet(struct purelifi_usb *usb, const u8 *buffer,
+			     unsigned int length)
+{
+	purelifi_mac_rx(purelifi_usb_to_hw(usb), buffer, length);
+}
+
+#define STATION_FIFO_ALMOST_FULL_MESSAGE     0
+#define STATION_FIFO_ALMOST_FULL_NOT_MESSAGE 1
+#define STATION_CONNECT_MESSAGE              2
+#define STATION_DISCONNECT_MESSAGE           3
+
+static void rx_urb_complete(struct urb *urb)
+{
+	int r;
+	static u8 retry;
+	struct purelifi_usb *usb;
+	struct purelifi_usb_tx *tx;
+	const u8 *buffer;
+	static u8 fpga_link_connection_f;
+	unsigned int length;
+	u16 status;
+	u8 sidx;
+
+	if (!urb) {
+		dev_err(purelifi_usb_dev(usb), "urb is NULL.\n");
+		return;
+	} else if (!urb->context) {
+		dev_err(purelifi_usb_dev(usb), "urb ctx is NULL.\n");
+		return;
+	}
+	usb = urb->context;
+
+	if (usb->initialized != 1)
+		return;
+
+	switch (urb->status) {
+	case 0:
+		break;
+	case -ESHUTDOWN:
+	case -EINVAL:
+	case -ENODEV:
+	case -ENOENT:
+	case -ECONNRESET:
+	case -EPIPE:
+		dev_dbg(urb_dev(urb), "urb %p error %d\n", urb, urb->status);
+		return;
+	default:
+		dev_dbg(urb_dev(urb), "urb %p error %d\n", urb, urb->status);
+		if (retry++ < PURELIFI_URB_RETRY_MAX) {
+			dev_dbg(urb_dev(urb), "urb %p resubmit %d", urb, retry);
+			goto resubmit;
+		} else {
+			dev_dbg(urb_dev(urb), "urb %p  max resubmits reached", urb);
+			retry = 0;
+			return;
+		}
+	}
+
+	buffer = urb->transfer_buffer;
+	length = (*(u32 *)(buffer + sizeof(struct rx_status)))
+		 + sizeof(u32);
+
+	tx = &usb->tx;
+
+	if (urb->actual_length != 8) {
+		if (usb->initialized && fpga_link_connection_f)
+			handle_rx_packet(usb, buffer, length);
+		goto resubmit;
+	}
+
+	status = buffer[7];
+
+	dev_dbg(&usb->intf->dev, "Recv status=%u\n", status);
+	dev_dbg(&usb->intf->dev, "Tx packet MAC=%x:%x:%x:%x:%x:%x\n",
+		buffer[0], buffer[1], buffer[2], buffer[3],
+		buffer[4], buffer[5]);
+
+	switch (status) {
+	case STATION_FIFO_ALMOST_FULL_NOT_MESSAGE:
+		dev_dbg(&usb->intf->dev,
+			"FIFO full not packet receipt\n");
+		tx->mac_fifo_full = 1;
+		for (sidx = 0; sidx < MAX_STA_NUM; sidx++)
+			tx->station[sidx].flag |= STATION_FIFO_FULL_FLAG;
+		break;
+	case STATION_FIFO_ALMOST_FULL_MESSAGE:
+		dev_dbg(&usb->intf->dev, "FIFO full packet receipt\n");
+
+		for (sidx = 0; sidx < MAX_STA_NUM; sidx++)
+			tx->station[sidx].flag &= 0xFD;
+
+		purelifi_send_packet_from_data_queue(usb);
+		break;
+	case STATION_CONNECT_MESSAGE:
+		fpga_link_connection_f = 1;
+		dev_dbg(&usb->intf->dev, "ST_CONNECT_MSG packet receipt\n");
+		break;
+	case STATION_DISCONNECT_MESSAGE:
+		fpga_link_connection_f = 0;
+		dev_dbg(&usb->intf->dev, "ST_DISCONN_MSG packet receipt\n");
+		break;
+	default:
+		dev_dbg(&usb->intf->dev, "Unknown packet receipt\n");
+		break;
+	}
+
+resubmit:
+	r = usb_submit_urb(urb, GFP_ATOMIC);
+	if (r)
+		dev_dbg(urb_dev(urb), "urb %p resubmit fail (%d)\n", urb, r);
+}
+
+static struct urb *alloc_rx_urb(struct purelifi_usb *usb)
+{
+	struct usb_device *udev = purelifi_usb_to_usbdev(usb);
+	struct urb *urb;
+	void *buffer;
+
+	urb = usb_alloc_urb(0, GFP_KERNEL);
+	if (!urb)
+		return NULL;
+
+	buffer = usb_alloc_coherent(udev, USB_MAX_RX_SIZE, GFP_KERNEL,
+				    &urb->transfer_dma);
+	if (!buffer) {
+		usb_free_urb(urb);
+		return NULL;
+	}
+
+	usb_fill_bulk_urb(urb, udev, usb_rcvbulkpipe(udev, EP_DATA_IN),
+			  buffer, USB_MAX_RX_SIZE,
+			  rx_urb_complete, usb);
+	urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
+
+	return urb;
+}
+
+static void free_rx_urb(struct urb *urb)
+{
+	if (!urb)
+		return;
+	usb_free_coherent(urb->dev, urb->transfer_buffer_length,
+			  urb->transfer_buffer, urb->transfer_dma);
+	usb_free_urb(urb);
+}
+
+static int __lf_x_usb_enable_rx(struct purelifi_usb *usb)
+{
+	int i, r;
+	struct purelifi_usb_rx *rx = &usb->rx;
+	struct urb **urbs;
+
+	r = -ENOMEM;
+	urbs = kcalloc(RX_URBS_COUNT, sizeof(struct urb *), GFP_KERNEL);
+	if (!urbs)
+		goto error;
+
+	for (i = 0; i < RX_URBS_COUNT; i++) {
+		urbs[i] = alloc_rx_urb(usb);
+		if (!urbs[i])
+			goto error;
+	}
+
+	spin_lock_irq(&rx->lock);
+
+	dev_dbg(purelifi_usb_dev(usb), "irq_disabled %d\n", irqs_disabled());
+
+	if (rx->urbs) {
+		spin_unlock_irq(&rx->lock);
+		r = 0;
+		goto error;
+	}
+	rx->urbs = urbs;
+	rx->urbs_count = RX_URBS_COUNT;
+	spin_unlock_irq(&rx->lock);
+
+	for (i = 0; i < RX_URBS_COUNT; i++) {
+		r = usb_submit_urb(urbs[i], GFP_KERNEL);
+		if (r)
+			goto error_submit;
+	}
+
+	return 0; /*no error return*/
+
+error_submit:
+	for (i = 0; i < RX_URBS_COUNT; i++)
+		usb_kill_urb(urbs[i]);
+	spin_lock_irq(&rx->lock);
+	rx->urbs = NULL;
+	rx->urbs_count = 0;
+	spin_unlock_irq(&rx->lock);
+error:
+	if (urbs) {
+		for (i = 0; i < RX_URBS_COUNT; i++)
+			free_rx_urb(urbs[i]);
+	}
+	return r;
+}
+
+int purelifi_usb_enable_rx(struct purelifi_usb *usb)
+{
+	int r;
+	struct purelifi_usb_rx *rx = &usb->rx;
+
+	mutex_lock(&rx->setup_mutex);
+	r = __lf_x_usb_enable_rx(usb);
+	if (!r)
+		usb->rx_usb_enabled = 1;
+
+	mutex_unlock(&rx->setup_mutex);
+
+	return r;
+}
+
+static void __lf_x_usb_disable_rx(struct purelifi_usb *usb)
+{
+	int i;
+	unsigned long flags;
+	struct urb **urbs;
+	unsigned int count;
+	struct purelifi_usb_rx *rx = &usb->rx;
+
+	spin_lock_irqsave(&rx->lock, flags);
+	urbs = rx->urbs;
+	count = rx->urbs_count;
+	spin_unlock_irqrestore(&rx->lock, flags);
+
+	if (!urbs)
+		return;
+
+	for (i = 0; i < count; i++) {
+		usb_kill_urb(urbs[i]);
+		free_rx_urb(urbs[i]);
+	}
+	kfree(urbs);
+	rx->urbs = NULL;
+	rx->urbs_count = 0;
+}
+
+void purelifi_usb_disable_rx(struct purelifi_usb *usb)
+{
+	struct purelifi_usb_rx *rx = &usb->rx;
+
+	mutex_lock(&rx->setup_mutex);
+	__lf_x_usb_disable_rx(usb);
+	usb->rx_usb_enabled = 0;
+	mutex_unlock(&rx->setup_mutex);
+}
+
+/**
+ * purelifi_usb_disable_tx - disable transmission
+ * @usb: the driver USB structure
+ *
+ * Frees all URBs in the free list and marks the transmission as disabled.
+ */
+void purelifi_usb_disable_tx(struct purelifi_usb *usb)
+{
+	struct purelifi_usb_tx *tx = &usb->tx;
+	unsigned long flags;
+
+	atomic_set(&tx->enabled, 0);
+
+	/* kill all submitted tx-urbs */
+	usb_kill_anchored_urbs(&tx->submitted);
+
+	spin_lock_irqsave(&tx->lock, flags);
+	WARN_ON(!skb_queue_empty(&tx->submitted_skbs));
+	WARN_ON(tx->submitted_urbs != 0);
+	tx->submitted_urbs = 0;
+	spin_unlock_irqrestore(&tx->lock, flags);
+
+	/* The stopped state is ignored, relying on ieee80211_wake_queues()
+	 * in a potentionally following purelifi_usb_enable_tx().
+	 */
+}
+
+/**
+ * purelifi_usb_enable_tx - enables transmission
+ * @usb: a &struct purelifi_usb pointer
+ *
+ * This function enables transmission and prepares the &purelifi_usb_tx data
+ * structure.
+ */
+void purelifi_usb_enable_tx(struct purelifi_usb *usb)
+{
+	unsigned long flags;
+	struct purelifi_usb_tx *tx = &usb->tx;
+
+	spin_lock_irqsave(&tx->lock, flags);
+	atomic_set(&tx->enabled, 1);
+	tx->submitted_urbs = 0;
+	ieee80211_wake_queues(purelifi_usb_to_hw(usb));
+	tx->stopped = 0;
+	spin_unlock_irqrestore(&tx->lock, flags);
+}
+
+/**
+ * tx_urb_complete - completes the execution of an URB
+ * @urb: a URB
+ *
+ * This function is called if the URB has been transferred to a device or an
+ * error has happened.
+ */
+void tx_urb_complete(struct urb *urb)
+{
+	struct sk_buff *skb;
+	struct ieee80211_tx_info *info;
+	struct purelifi_usb *usb;
+
+	skb = (struct sk_buff *)urb->context;
+	info = IEEE80211_SKB_CB(skb);
+	/* grab 'usb' pointer before handing off the skb (since
+	 * it might be freed by purelifi_mac_tx_to_dev or mac80211)
+	 */
+	usb = &purelifi_hw_mac(info->rate_driver_data[0])->chip.usb;
+
+	switch (urb->status) {
+	case 0:
+		break;
+	case -ESHUTDOWN:
+	case -EINVAL:
+	case -ENODEV:
+	case -ENOENT:
+	case -ECONNRESET:
+	case -EPIPE:
+		dev_dbg(urb_dev(urb), "urb %p error %d\n", urb, urb->status);
+		break;
+	default:
+		dev_dbg(urb_dev(urb), "urb %p error %d\n", urb, urb->status);
+		return;
+	}
+
+	purelifi_mac_tx_to_dev(skb, urb->status);
+	purelifi_send_packet_from_data_queue(usb);
+	usb_free_urb(urb);
+}
+
+/**
+ * purelifi_usb_tx: initiates transfer of a frame of the device
+ *
+ * @usb: the driver USB structure
+ * @skb: a &struct sk_buff pointer
+ *
+ * This function tranmits a frame to the device. It doesn't wait for
+ * completion. The frame must contain the control set and have all the
+ * control set information available.
+ *
+ * The function returns 0 if the transfer has been successfully initiated.
+ */
+int purelifi_usb_tx(struct purelifi_usb *usb, struct sk_buff *skb)
+{
+	int r;
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	struct usb_device *udev = purelifi_usb_to_usbdev(usb);
+	struct urb *urb;
+	struct purelifi_usb_tx *tx = &usb->tx;
+
+	if (!atomic_read(&tx->enabled)) {
+		r = -ENOENT;
+		goto out;
+	}
+
+	urb = usb_alloc_urb(0, GFP_ATOMIC);
+	if (!urb) {
+		r = -ENOMEM;
+		goto out;
+	}
+
+	usb_fill_bulk_urb(urb, udev, usb_sndbulkpipe(udev, EP_DATA_OUT),
+			  skb->data, skb->len, tx_urb_complete, skb);
+
+	info->rate_driver_data[1] = (void *)jiffies;
+	skb_queue_tail(&tx->submitted_skbs, skb);
+	usb_anchor_urb(urb, &tx->submitted);
+
+	r = usb_submit_urb(urb, GFP_ATOMIC);
+	if (r) {
+		dev_dbg(purelifi_usb_dev(usb), "urb %p submit failed (%d)\n",
+			urb, r);
+		usb_unanchor_urb(urb);
+		skb_unlink(skb, &tx->submitted_skbs);
+		goto error;
+	}
+	return 0;
+error:
+	usb_free_urb(urb);
+out:
+	return r;
+}
+
+static inline void init_usb_rx(struct purelifi_usb *usb)
+{
+	struct purelifi_usb_rx *rx = &usb->rx;
+
+	spin_lock_init(&rx->lock);
+	mutex_init(&rx->setup_mutex);
+
+	if (interface_to_usbdev(usb->intf)->speed == USB_SPEED_HIGH)
+		rx->usb_packet_size = 512;
+	else
+		rx->usb_packet_size = 64;
+
+	if (rx->fragment_length != 0)
+		dev_dbg(purelifi_usb_dev(usb), "fragment_length error\n");
+}
+
+static inline void init_usb_tx(struct purelifi_usb *usb)
+{
+	struct purelifi_usb_tx *tx = &usb->tx;
+
+	spin_lock_init(&tx->lock);
+	atomic_set(&tx->enabled, 0);
+	tx->stopped = 0;
+	skb_queue_head_init(&tx->submitted_skbs);
+	init_usb_anchor(&tx->submitted);
+}
+
+void purelifi_usb_init(struct purelifi_usb *usb, struct ieee80211_hw *hw,
+		       struct usb_interface *intf)
+{
+	memset(usb, 0, sizeof(*usb));
+	usb->intf = usb_get_intf(intf);
+	usb_set_intfdata(usb->intf, hw);
+	hw->conf.chandef.width = NL80211_CHAN_WIDTH_20;
+	init_usb_tx(usb);
+	init_usb_rx(usb);
+}
+
+void purelifi_usb_release(struct purelifi_usb *usb)
+{
+	purelifi_op_stop(purelifi_usb_to_hw(usb));
+	purelifi_usb_disable_tx(usb);
+	purelifi_usb_disable_rx(usb);
+	usb_set_intfdata(usb->intf, NULL);
+	usb_put_intf(usb->intf);
+}
+
+const char *purelifi_speed(enum usb_device_speed speed)
+{
+	switch (speed) {
+	case USB_SPEED_LOW:
+		return "low";
+	case USB_SPEED_FULL:
+		return "full";
+	case USB_SPEED_HIGH:
+		return "high";
+	default:
+		return "unknown";
+	}
+}
+
+int purelifi_usb_init_hw(struct purelifi_usb *usb)
+{
+	int r;
+
+	r = usb_reset_configuration(purelifi_usb_to_usbdev(usb));
+	if (r) {
+		dev_err(purelifi_usb_dev(usb), "cfg reset failed (%d)\n", r);
+		return r;
+	}
+	return 0;
+}
+
+static void get_usb_req(struct usb_device *udev, const u8 *buffer,
+			u32 buffer_len, enum usb_req_enum_t usb_req_id,
+			struct usb_req_t *usb_req)
+{
+	u8 *buffer_dst_p = usb_req->buf;
+	const u8 *buffer_src_p = buffer;
+	__be32 payload_len_nw = cpu_to_be32(buffer_len + FCS_LEN);
+	u32 temp_usb_len = 0;
+
+	usb_req->id = cpu_to_be32(usb_req_id);
+	usb_req->len  = cpu_to_be32(0);
+
+	/* Copy buffer length into the transmitted buffer, as it is important
+	 * for the Rx MAC to know its exact length.
+	 */
+	if (usb_req->id == cpu_to_be32(USB_REQ_BEACON_WR)) {
+		memcpy(buffer_dst_p, &payload_len_nw, sizeof(payload_len_nw));
+		buffer_dst_p += sizeof(payload_len_nw);
+		temp_usb_len += sizeof(payload_len_nw);
+	}
+
+	memcpy(buffer_dst_p, buffer_src_p, buffer_len);
+	buffer_dst_p += buffer_len;
+	buffer_src_p += buffer_len;
+	temp_usb_len +=  buffer_len;
+
+	/* Set the FCS_LEN (4) bytes as 0 for CRC checking. */
+	memset(buffer_dst_p, 0, FCS_LEN);
+	buffer_dst_p += FCS_LEN;
+	temp_usb_len += FCS_LEN;
+
+	/* Round the packet to be transmitted to 4 bytes. */
+	if (temp_usb_len % PURELIFI_BYTE_NUM_ALIGNMENT) {
+		memset(buffer_dst_p, 0, PURELIFI_BYTE_NUM_ALIGNMENT -
+		       (temp_usb_len %
+			PURELIFI_BYTE_NUM_ALIGNMENT));
+		buffer_dst_p += PURELIFI_BYTE_NUM_ALIGNMENT -
+				(temp_usb_len %
+				PURELIFI_BYTE_NUM_ALIGNMENT);
+		temp_usb_len += PURELIFI_BYTE_NUM_ALIGNMENT -
+				(temp_usb_len % PURELIFI_BYTE_NUM_ALIGNMENT);
+	}
+
+	usb_req->len = cpu_to_be32(temp_usb_len);
+}
+
+int plf_usb_wreq_async(struct purelifi_usb *usb, const u8 *buffer,
+		       int buffer_len, enum usb_req_enum_t usb_req_id,
+		       usb_complete_t complete_fn,
+		       void *context)
+{
+	int r;
+	struct usb_device *udev = interface_to_usbdev(ez_usb_interface);
+	struct urb *urb = usb_alloc_urb(0, GFP_ATOMIC);
+
+	usb_fill_bulk_urb(urb, udev, usb_sndbulkpipe(udev, EP_DATA_OUT),
+			  (void *)buffer, buffer_len, complete_fn, context);
+
+	r = usb_submit_urb(urb, GFP_ATOMIC);
+
+	if (r)
+		dev_err(&udev->dev, "async write submit failed (%d)\n", r);
+
+	return r;
+}
+
+int plf_usb_wreq(const u8 *buffer, int buffer_len,
+		 enum usb_req_enum_t usb_req_id)
+{
+	int r;
+	int actual_length;
+	int usb_bulk_msg_len;
+	unsigned char *dma_buffer = NULL;
+	struct usb_device *udev = interface_to_usbdev(ez_usb_interface);
+	struct usb_req_t usb_req;
+
+	get_usb_req(udev, buffer, buffer_len, usb_req_id, &usb_req);
+	usb_bulk_msg_len = sizeof(__le32) + sizeof(__le32) +
+			   be32_to_cpu(usb_req.len);
+
+	dma_buffer = kmemdup(&usb_req, usb_bulk_msg_len, GFP_KERNEL);
+
+	if (!dma_buffer) {
+		r = -ENOMEM;
+		goto error;
+	}
+
+	r = usb_bulk_msg(udev,
+			 usb_sndbulkpipe(udev, EP_DATA_OUT),
+			 dma_buffer, usb_bulk_msg_len,
+			 &actual_length, USB_BULK_MSG_TIMEOUT_MS);
+	kfree(dma_buffer);
+error:
+	if (r)
+		dev_err(&udev->dev, "usb_bulk_msg failed (%d)\n", r);
+
+	return r;
+}
+
+static void slif_data_plane_sap_timer_callb(struct timer_list *t)
+{
+	struct purelifi_usb *usb = from_timer(usb, t, tx.tx_retry_timer);
+
+	purelifi_send_packet_from_data_queue(usb);
+	timer_setup(&usb->tx.tx_retry_timer,
+		    slif_data_plane_sap_timer_callb, 0);
+	mod_timer(&usb->tx.tx_retry_timer, jiffies + TX_RETRY_BACKOFF_JIFF);
+}
+
+static void sta_queue_cleanup_timer_callb(struct timer_list *t)
+{
+	struct purelifi_usb *usb = from_timer(usb, t, sta_queue_cleanup);
+	struct purelifi_usb_tx *tx = &usb->tx;
+	int sidx;
+
+	for (sidx = 0; sidx < MAX_STA_NUM - 1; sidx++) {
+		if (!(tx->station[sidx].flag & STATION_CONNECTED_FLAG))
+			continue;
+		if (tx->station[sidx].flag & STATION_HEARTBEAT_FLAG) {
+			tx->station[sidx].flag ^= STATION_HEARTBEAT_FLAG;
+		} else {
+			memset(tx->station[sidx].mac, 0, ETH_ALEN);
+			tx->station[sidx].flag = 0;
+		}
+	}
+	timer_setup(&usb->sta_queue_cleanup,
+		    sta_queue_cleanup_timer_callb, 0);
+	mod_timer(&usb->sta_queue_cleanup, jiffies + STA_QUEUE_CLEANUP_JIFF);
+}
+
+static int probe(struct usb_interface *intf,
+		 const struct usb_device_id *id)
+{
+	int r = 0;
+	struct purelifi_chip *chip;
+	struct purelifi_usb *usb;
+	struct purelifi_usb_tx *tx;
+	struct ieee80211_hw *hw = NULL;
+	static u8 hw_address[ETH_ALEN];
+	static u8 serial_number[PURELIFI_SERIAL_LEN];
+	unsigned int i;
+
+	ez_usb_interface = intf;
+
+	hw = purelifi_mac_alloc_hw(intf);
+
+	if (!hw) {
+		r = -ENOMEM;
+		goto error;
+	}
+
+	chip = &purelifi_hw_mac(hw)->chip;
+	usb = &chip->usb;
+	tx = &usb->tx;
+
+	r = upload_mac_and_serial(intf, hw_address, serial_number);
+
+	if (r) {
+		dev_err(&intf->dev, "MAC and Serial upload failed (%d)\n", r);
+		goto error;
+	}
+	chip->unit_type = STA;
+	dev_dbg(&intf->dev, "unit type is station");
+
+	r = purelifi_mac_preinit_hw(hw, hw_address);
+	if (r) {
+		dev_dbg(&intf->dev, "init mac failed (%d)\n", r);
+		goto error;
+	}
+
+	r = ieee80211_register_hw(hw);
+	if (r) {
+		dev_dbg(&intf->dev, "register device failed (%d)\n", r);
+		goto error;
+	}
+	dev_info(&intf->dev, "%s\n", wiphy_name(hw->wiphy));
+
+	if ((le16_to_cpu(interface_to_usbdev(intf)->descriptor.idVendor) ==
+				PURELIFI_XL_VENDOR_ID_0) &&
+	    (le16_to_cpu(interface_to_usbdev(intf)->descriptor.idProduct) ==
+				PURELIFI_XL_PRODUCT_ID_0)) {
+		r = download_xl_firmware(intf);
+	} else {
+		r = download_fpga(intf);
+	}
+	if (r != 0) {
+		dev_err(&intf->dev, "FPGA download failed (%d)\n", r);
+		goto error;
+	}
+
+	tx->mac_fifo_full = 0;
+	spin_lock_init(&tx->lock);
+
+	msleep(PLF_MSLEEP_TIME);
+	r = purelifi_usb_init_hw(usb);
+	if (r < 0) {
+		dev_dbg(&intf->dev, "usb_init_hw failed (%d)\n", r);
+		goto error;
+	}
+
+	msleep(PLF_MSLEEP_TIME);
+	r = purelifi_chip_switch_radio(chip, 1); /* Switch ON Radio */
+	if (r < 0) {
+		dev_dbg(&intf->dev, "chip_switch_radio_on failed (%d)\n", r);
+		goto error;
+	}
+
+	msleep(PLF_MSLEEP_TIME);
+	r = purelifi_chip_set_rate(chip, 8);
+	if (r < 0) {
+		dev_dbg(&intf->dev, "chip_set_rate failed (%d)\n", r);
+		goto error;
+	}
+
+	msleep(PLF_MSLEEP_TIME);
+	r = plf_usb_wreq(hw_address, ETH_ALEN, USB_REQ_MAC_WR);
+	if (r < 0) {
+		dev_dbg(&intf->dev, "MAC_WR failure (%d)\n", r);
+		goto error;
+	}
+
+	purelifi_chip_enable_rxtx(chip);
+
+	/* Initialise the data plane Tx queue */
+	atomic_set(&data_queue_flag, 1);
+	for (i = 0; i < MAX_STA_NUM; i++) {
+		skb_queue_head_init(&tx->station[i].data_list);
+		tx->station[i].flag = 0;
+	}
+	tx->station[STA_BROADCAST_INDEX].flag |= STATION_CONNECTED_FLAG;
+	for (i = 0; i < ETH_ALEN; i++)
+		tx->station[STA_BROADCAST_INDEX].mac[i] = 0xFF;
+	atomic_set(&data_queue_flag, 0);
+
+	timer_setup(&tx->tx_retry_timer, slif_data_plane_sap_timer_callb, 0);
+	tx->tx_retry_timer.expires = jiffies + TX_RETRY_BACKOFF_JIFF;
+	add_timer(&tx->tx_retry_timer);
+
+	timer_setup(&usb->sta_queue_cleanup,
+		    sta_queue_cleanup_timer_callb, 0);
+	usb->sta_queue_cleanup.expires = jiffies + STA_QUEUE_CLEANUP_JIFF;
+	add_timer(&usb->sta_queue_cleanup);
+
+	usb->initialized = 1;
+	return 0;
+error:
+	if (hw) {
+		purelifi_mac_release(purelifi_hw_mac(hw));
+		ieee80211_unregister_hw(hw);
+		ieee80211_free_hw(hw);
+	}
+	return r;
+}
+
+static void disconnect(struct usb_interface *intf)
+{
+	struct ieee80211_hw *hw = purelifi_intf_to_hw(intf);
+	struct purelifi_mac *mac;
+	struct purelifi_usb *usb;
+
+	/* Either something really bad happened, or
+	 * we're just dealing with
+	 * a DEVICE_INSTALLER.
+	 */
+	if (!hw)
+		return;
+
+	mac = purelifi_hw_mac(hw);
+	usb = &mac->chip.usb;
+
+	del_timer_sync(&usb->tx.tx_retry_timer);
+	del_timer_sync(&usb->sta_queue_cleanup);
+
+	ieee80211_unregister_hw(hw);
+
+	purelifi_usb_disable_tx(usb);
+	purelifi_usb_disable_rx(usb);
+
+	/* If the disconnect has been caused by a removal of the
+	 * driver module, the reset allows reloading of the driver. If the
+	 * reset will not be executed here,
+	 * the upload of the firmware in the
+	 * probe function caused by the reloading of the driver will fail.
+	 */
+	usb_reset_device(interface_to_usbdev(intf));
+
+	purelifi_mac_release(mac);
+	ieee80211_free_hw(hw);
+}
+
+static void purelifi_usb_resume(struct purelifi_usb *usb)
+{
+	struct purelifi_mac *mac = purelifi_usb_to_mac(usb);
+	int r;
+
+	r = purelifi_op_start(purelifi_usb_to_hw(usb));
+	if (r < 0) {
+		dev_warn(purelifi_usb_dev(usb),
+			 "Device resume failed (%d)\n", r);
+
+		if (usb->was_running)
+			set_bit(PURELIFI_DEVICE_RUNNING, &mac->flags);
+
+		usb_queue_reset_device(usb->intf);
+		return;
+	}
+
+	if (mac->type != NL80211_IFTYPE_UNSPECIFIED) {
+		r = purelifi_restore_settings(mac);
+		if (r < 0) {
+			dev_dbg(purelifi_usb_dev(usb),
+				"restore failed (%d)\n", r);
+			return;
+		}
+	}
+}
+
+static void purelifi_usb_stop(struct purelifi_usb *usb)
+{
+	purelifi_op_stop(purelifi_usb_to_hw(usb));
+	purelifi_usb_disable_tx(usb);
+	purelifi_usb_disable_rx(usb);
+
+	usb->initialized = 0;
+}
+
+static int pre_reset(struct usb_interface *intf)
+{
+	struct ieee80211_hw *hw = usb_get_intfdata(intf);
+	struct purelifi_mac *mac;
+	struct purelifi_usb *usb;
+
+	if (!hw || intf->condition != USB_INTERFACE_BOUND)
+		return 0;
+
+	mac = purelifi_hw_mac(hw);
+	usb = &mac->chip.usb;
+
+	usb->was_running = test_bit(PURELIFI_DEVICE_RUNNING, &mac->flags);
+
+	purelifi_usb_stop(usb);
+
+	return 0;
+}
+
+static int post_reset(struct usb_interface *intf)
+{
+	struct ieee80211_hw *hw = usb_get_intfdata(intf);
+	struct purelifi_mac *mac;
+	struct purelifi_usb *usb;
+
+	if (!hw || intf->condition != USB_INTERFACE_BOUND)
+		return 0;
+
+	mac = purelifi_hw_mac(hw);
+	usb = &mac->chip.usb;
+
+	if (usb->was_running)
+		purelifi_usb_resume(usb);
+
+	return 0;
+}
+
+static struct purelifi_usb *get_purelifi_usb(struct usb_interface *intf)
+{
+	struct ieee80211_hw *hw = purelifi_intf_to_hw(intf);
+	struct purelifi_mac *mac;
+
+	/* Either something really bad happened, or
+	 * we're just dealing with
+	 * a DEVICE_INSTALLER.
+	 */
+	if (!hw)
+		return NULL;
+
+	mac = purelifi_hw_mac(hw);
+	return &mac->chip.usb;
+}
+
+#ifdef CONFIG_PM
+
+static int suspend(struct usb_interface *interface,
+		   pm_message_t message)
+{
+	struct purelifi_usb *pl = get_purelifi_usb(interface);
+	struct purelifi_mac *mac = purelifi_usb_to_mac(pl);
+
+	if (!pl || !purelifi_usb_dev(pl))
+		return -ENODEV;
+	if (pl->initialized == 0)
+		return 0;
+	pl->was_running = test_bit(PURELIFI_DEVICE_RUNNING, &mac->flags);
+	purelifi_usb_stop(pl);
+	return 0;
+}
+
+static int resume(struct usb_interface *interface)
+{
+	struct purelifi_usb *pl = get_purelifi_usb(interface);
+
+	if (!pl || !purelifi_usb_dev(pl))
+		return -ENODEV;
+	if (pl->was_running)
+		purelifi_usb_resume(pl);
+	return 0;
+}
+
+#endif
+
+static struct usb_driver driver = {
+	.name        = KBUILD_MODNAME,
+	.id_table    = usb_ids,
+	.probe        = probe,
+	.disconnect    = disconnect,
+	.pre_reset    = pre_reset,
+	.post_reset    = post_reset,
+#ifdef CONFIG_PM
+	.suspend        = suspend,
+	.resume         = resume,
+#endif
+	.disable_hub_initiated_lpm = 1,
+};
+
+static struct workqueue_struct *purelifi_workqueue;
+
+static int __init usb_init(void)
+{
+	int r;
+
+	purelifi_workqueue = create_singlethread_workqueue(driver.name);
+	if (!purelifi_workqueue) {
+		pr_err("%s couldn't create workqueue\n", driver.name);
+		r = -ENOMEM;
+		goto error;
+	}
+
+	r = usb_register(&driver);
+	if (r) {
+		destroy_workqueue(purelifi_workqueue);
+		pr_err("%s usb_register() failed %d\n", driver.name, r);
+		return r;
+	}
+
+	pr_debug("Driver initialized :%s\n", driver.name);
+	return 0;
+
+error:
+	return r;
+}
+
+static void __exit usb_exit(void)
+{
+	usb_deregister(&driver);
+	destroy_workqueue(purelifi_workqueue);
+	pr_debug("%s %s\n", driver.name, __func__);
+}
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("USB driver for pureLiFi devices");
+MODULE_AUTHOR("pureLiFi");
+MODULE_VERSION("1.0");
+MODULE_FIRMWARE("plfxlc/lifi-x.bin");
+MODULE_DEVICE_TABLE(usb, usb_ids);
+
+module_init(usb_init);
+module_exit(usb_exit);
diff --git a/drivers/net/wireless/purelifi/plfxlc/usb.h b/drivers/net/wireless/purelifi/plfxlc/usb.h
new file mode 100644
index 000000000000..28c1ac7d9062
--- /dev/null
+++ b/drivers/net/wireless/purelifi/plfxlc/usb.h
@@ -0,0 +1,179 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (c) 2021 pureLiFi
+ */
+
+#ifndef _PURELIFI_USB_H
+#define _PURELIFI_USB_H
+
+#include <linux/completion.h>
+#include <linux/netdevice.h>
+#include <linux/spinlock.h>
+#include <linux/skbuff.h>
+#include <linux/usb.h>
+
+#include "intf.h"
+
+#define USB_BULK_MSG_TIMEOUT_MS 2000
+
+#define PURELIFI_X_VENDOR_ID_0   0x16C1
+#define PURELIFI_X_PRODUCT_ID_0  0x1CDE
+#define PURELIFI_XC_VENDOR_ID_0  0x2EF5
+#define PURELIFI_XC_PRODUCT_ID_0 0x0008
+#define PURELIFI_XL_VENDOR_ID_0  0x2EF5
+#define PURELIFI_XL_PRODUCT_ID_0 0x000A /* Station */
+
+#define PLF_FPGA_STATUS_LEN 2
+#define PLF_FPGA_STATE_LEN 9
+#define PLF_BULK_TLEN 16384
+#define PLF_FPGA_MG 6 /* Magic check */
+#define PLF_XL_BUF_LEN 64
+
+#define PLF_USB_TIMEOUT 1000
+#define PLF_MSLEEP_TIME 200
+
+#define PURELIFI_URB_RETRY_MAX 5
+
+#define purelifi_usb_dev(usb) (&(usb)->intf->dev)
+
+int plf_usb_wreq(const u8 *buffer, int buffer_len,
+		 enum usb_req_enum_t usb_req_id);
+void tx_urb_complete(struct urb *urb);
+
+enum {
+	USB_MAX_RX_SIZE       = 4800,
+	USB_MAX_EP_INT_BUFFER = 64,
+};
+
+/* USB interrupt */
+struct purelifi_usb_interrupt {
+	spinlock_t lock;/* spin lock for usb interrupt buffer */
+	struct urb *urb;
+	void *buffer;
+	int interval;
+};
+
+#define RX_URBS_COUNT 5
+
+struct purelifi_usb_rx {
+	spinlock_t lock;/* spin lock for rx urb */
+	struct mutex setup_mutex; /* mutex lockt for rx urb */
+	u8 fragment[2 * USB_MAX_RX_SIZE];
+	unsigned int fragment_length;
+	unsigned int usb_packet_size;
+	struct urb **urbs;
+	int urbs_count;
+};
+
+struct station_t {
+   //  7...3    |    2      |     1     |     0	    |
+   // Reserved  | Heartbeat | FIFO full | Connected |
+	unsigned char flag;
+	unsigned char mac[ETH_ALEN];
+	struct sk_buff_head data_list;
+};
+
+struct firmware_file {
+	u32 total_files;
+	u32 total_size;
+	u32 size;
+	u32 start_addr;
+	u32 control_packets;
+} __packed;
+
+#define STATION_CONNECTED_FLAG 0x1
+#define STATION_FIFO_FULL_FLAG 0x2
+#define STATION_HEARTBEAT_FLAG 0x4
+
+#define PURELIFI_SERIAL_LEN 256
+/**
+ * struct purelifi_usb_tx - structure used for transmitting frames
+ * @enabled: atomic enabled flag, indicates whether tx is enabled
+ * @lock: lock for transmission
+ * @submitted: anchor for URBs sent to device
+ * @submitted_urbs: atomic integer that counts the URBs having sent to the
+ *   device, which haven't been completed
+ * @stopped: indicates whether higher level tx queues are stopped
+ */
+#define STA_BROADCAST_INDEX (AP_USER_LIMIT)
+#define MAX_STA_NUM         (AP_USER_LIMIT + 1)
+struct purelifi_usb_tx {
+	atomic_t enabled;
+	spinlock_t lock; /*spinlock for USB tx */
+	u8 mac_fifo_full;
+	struct sk_buff_head submitted_skbs;
+	struct usb_anchor submitted;
+	int submitted_urbs;
+	u8 stopped:1;
+	struct timer_list tx_retry_timer;
+	struct station_t station[MAX_STA_NUM];
+};
+
+/* Contains the usb parts. The structure doesn't require a lock because intf
+ * will not be changed after initialization.
+ */
+struct purelifi_usb {
+	struct timer_list sta_queue_cleanup;
+	struct purelifi_usb_rx rx;
+	struct purelifi_usb_tx tx;
+	struct usb_interface *intf;
+	u8 req_buf[64]; /* purelifi_usb_iowrite16v needs 62 bytes */
+	bool rx_usb_enabled;
+	bool initialized;
+	bool was_running;
+};
+
+enum endpoints {
+	EP_DATA_IN  = 2,
+	EP_DATA_OUT = 8,
+};
+
+enum devicetype {
+	DEVICE_LIFI_X  = 0,
+	DEVICE_LIFI_XC  = 1,
+	DEVICE_LIFI_XL  = 1,
+};
+
+int plf_usb_wreq_async(struct purelifi_usb *usb, const u8 *buffer,
+		       int buffer_len, enum usb_req_enum_t usb_req_id,
+		       usb_complete_t complete_fn, void *context);
+
+static inline struct usb_device *
+purelifi_usb_to_usbdev(struct purelifi_usb *usb)
+{
+	return interface_to_usbdev(usb->intf);
+}
+
+static inline struct ieee80211_hw *
+purelifi_intf_to_hw(struct usb_interface *intf)
+{
+	return usb_get_intfdata(intf);
+}
+
+static inline struct ieee80211_hw *
+purelifi_usb_to_hw(struct purelifi_usb *usb)
+{
+	return purelifi_intf_to_hw(usb->intf);
+}
+
+void purelifi_usb_init(struct purelifi_usb *usb, struct ieee80211_hw *hw,
+		       struct usb_interface *intf);
+void purelifi_send_packet_from_data_queue(struct purelifi_usb *usb);
+void purelifi_usb_release(struct purelifi_usb *usb);
+void purelifi_usb_disable_rx(struct purelifi_usb *usb);
+void purelifi_usb_enable_tx(struct purelifi_usb *usb);
+void purelifi_usb_disable_tx(struct purelifi_usb *usb);
+int purelifi_usb_tx(struct purelifi_usb *usb, struct sk_buff *skb);
+int purelifi_usb_enable_rx(struct purelifi_usb *usb);
+int purelifi_usb_init_hw(struct purelifi_usb *usb);
+const char *purelifi_speed(enum usb_device_speed speed);
+
+/*Firmware declarations */
+int download_xl_firmware(struct usb_interface *intf);
+int download_fpga(struct usb_interface *intf);
+
+int upload_mac_and_serial(struct usb_interface *intf,
+			  unsigned char *hw_address,
+			  unsigned char *serial_number);
+
+#endif
-- 
2.25.1

