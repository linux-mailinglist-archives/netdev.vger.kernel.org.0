Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D90D427ABB7
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 12:21:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726617AbgI1KV1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 06:21:27 -0400
Received: from mail-eopbgr100121.outbound.protection.outlook.com ([40.107.10.121]:6172
        "EHLO GBR01-LO2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726565AbgI1KV1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Sep 2020 06:21:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HJDAW5IfPTomMqNTjYBFw2gkccB6v0YmAkx2xVei4ULwyC28XnFMr7/CB6DT/o2q5DbMVMPhX8JTFDQ9gVuXE7onEH8lsGz8HQho86LKSel+C27m4P9QivctuI/BvTmV099IDcVfva9QUjTh+7tQKuoO+EB6gH8ng+LX1PB28iRqECexZpsDecVtQT5hSqlUZd39Pf+RRIICqBXIeiY1UXmw/eBIhx4o2tuE4cZsTPQ+u8CZHQ7P+gynyaOQJrU312u/VVG2zhRmNDCpBNNnkVITLoqCOdNdqAPLLsWboI/NU0d5RvtXGQH3IsBav8aSuSmI0vSYQU+lWr4zqRci3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hny/oi8j/SQwjma4mP+zGK3bxkdjrEhaY7os25Ac+28=;
 b=InYnRY6KnlLQKd1O+Nn0OeLvZ6FAp37mom+MBsxL7RQs1S6L2IwDraYvLPYt31Tp6U2/Eeodv+YRmtyphoZcYMhsQc+ksGS6OUMQDMBqqLqEbjP9BIL2BjzDyQ1eWzLH646xl75TAsSUVf7zBCXXrRRah3IXmLB6jDU7iOoYFSUEVMvN1E3b9ZdX2RX7y6bE9XUkbyLEW2tlSGwV+wRBTH2txVaDXjvIrl6TRyPSbFShhFH/XCjnl1ZC5rcOBJBMXhLJrtydzz5jRIqj8PuJKPByntWmdQDl/Zgqez5qXR5GjL0PF6vG7X6gDiAGzOy+RHDsS/KxROLGvLsNmcw3tQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=purelifi.com; dmarc=pass action=none header.from=purelifi.com;
 dkim=pass header.d=purelifi.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=purevlc.onmicrosoft.com; s=selector2-purevlc-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hny/oi8j/SQwjma4mP+zGK3bxkdjrEhaY7os25Ac+28=;
 b=u4tCfoqx3CAWAjCllvtqkgvPAkxRkMf9MdgX81BsKdx/dH1bPayrSa6imW4vdNUZFJF4u4CDC/3Qtb9pom3WmAGmB70FeZvKouQYgtFWopYrcdmtZruenAzRcWEuD9WIqqqhGa3HDp9ah2JxdRyLjIp9Qi7G+GN+H6vn2dGdTYA=
Authentication-Results: purelifi.com; dkim=none (message not signed)
 header.d=none;purelifi.com; dmarc=none action=none header.from=purelifi.com;
Received: from CWLP265MB1972.GBRP265.PROD.OUTLOOK.COM (2603:10a6:400:6f::14)
 by CWLP265MB0324.GBRP265.PROD.OUTLOOK.COM (2603:10a6:401:1a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.28; Mon, 28 Sep
 2020 10:21:01 +0000
Received: from CWLP265MB1972.GBRP265.PROD.OUTLOOK.COM
 ([fe80::e102:fffb:c3b6:780f]) by CWLP265MB1972.GBRP265.PROD.OUTLOOK.COM
 ([fe80::e102:fffb:c3b6:780f%8]) with mapi id 15.20.3412.029; Mon, 28 Sep 2020
 10:21:01 +0000
From:   Srinivasan Raju <srini.raju@purelifi.com>
Cc:     mostafa.afgani@purelifi.com,
        Srinivasan Raju <srini.raju@purelifi.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Rob Herring <robh@kernel.org>,
        linux-kernel@vger.kernel.org (open list),
        linux-wireless@vger.kernel.org (open list:NETWORKING DRIVERS (WIRELESS)),
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS)
Subject: [PATCH] [v2] wireless: Initial driver submission for pureLiFi devices
Date:   Mon, 28 Sep 2020 15:49:49 +0530
Message-Id: <20200928102008.32568-1-srini.raju@purelifi.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200924151910.21693-1-srini.raju@purelifi.com>
References: <20200924151910.21693-1-srini.raju@purelifi.com>
Content-Type: text/plain
X-ClientProxiedBy: BMXPR01CA0095.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:b00:54::35) To CWLP265MB1972.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:400:6f::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (103.104.125.104) by BMXPR01CA0095.INDPRD01.PROD.OUTLOOK.COM (2603:1096:b00:54::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.20 via Frontend Transport; Mon, 28 Sep 2020 10:20:54 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [103.104.125.104]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1813ede8-8812-4dfc-b160-08d8639830c3
X-MS-TrafficTypeDiagnostic: CWLP265MB0324:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CWLP265MB03240891F21DF798D33896E3E0350@CWLP265MB0324.GBRP265.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wrul8Gg7EIrwf4/W3CdWGKGXLbNdgRfUJOq9yWIWe38aw4M5YyBnS1Vb4+9Vxg7xJZMQ0vSliT/tlhBKw9cX6SC/ut3u877oHIeR2TcrLTOTJcFyVpByEApfkCiT/SpleXLxSHfz2P9Mpz5B9D0lIRX5z13rqXfryFwW7L0OiL7fpEC7TFAKP4hDF1VboDG5QvnCkM3g7LH8bUILQHUWTX0ZgRp3T87XCCWGu1M3q4CH1L5C55fsKlPAc1NXU65ku5sbCdz37ztFInVOYGySx0fc2E/nk+1SqT5O3tZMeP1GcmqlLGIvgT7EfDPzLEm/x+JcZAU8WRvcpVaHkGNa0mrWTVLv/ff5QjkVZ8SYNt3IXSjhc38CKCz0BQqzVZLyZmfuhrFbk5uPtwJIKEBxCtZzjOvHl4lPFku5E0LlyOOPxUV47UsUYO4Zb3NKIGAhJ9q63L8TLlF74zZOibBHFA1bQL7gxSaOwH6+Z3pofMs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWLP265MB1972.GBRP265.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(6029001)(4636009)(136003)(396003)(366004)(346002)(39830400003)(376002)(26005)(2906002)(8936002)(52116002)(2616005)(8676002)(30864003)(83380400001)(6512007)(6486002)(316002)(16526019)(4326008)(1076003)(66946007)(186003)(54906003)(6506007)(36756003)(69590400008)(5660300002)(478600001)(66556008)(86362001)(66476007)(109986005)(6666004)(956004)(87944003)(266003)(579004)(559001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: KNCixIqhHbNeodBQSofG7xynBUzDGqUIGnnQ4cnQiO8xPZo1sPP+5FpqB/0JjAtbP5UBUWL+YeBqdmSaR/Pu8GIGQFOHu69dqL6m5RnMQ1bEGJm7C2X5oaTxM1+BWPK6ZojmCSlOv4xY1o3yqPYnM6x19jumtuZhwixo9609hZfnXK5kLbEja6VrXmwCX7Cq/8AWSH/m50C6VxiCUHoNlq1bW1cFkhFFVwpf9Brfalcwtd4EhlM0TprPqLL+e14/ZO1w5KgZVjgdjCeWXLVg4Pu3IfMez0VqXpEQix12NiY7LIUGs21Iexg1CPVzN0EMPSzF6AnQyUCRHLW4MCu4Qg1Az7eGNDMAJdETUfKscEbtzEtX9TCQGl6ycXZcq7ee0m3Cr767bm+hz58oUoChmwzuW6s/OXHqnxe0TTAIGplJT65Rja5OnD8l8GII3WbwEagRf9gkrs/S77bFt414SV8m5658lIAQKx6yB5L+stOVyRPX1UAyWxlfu2USnZNFlqwiSiJhSFDCKfLjTyYdqCLILe4qN0ly5KSfCxD3cY/ZzeBtgTm+xB9Le1fpClQPHFYZu8xsZ6LCOXSaq9wShPAalr3MOFEDJpZ1h24bSnQpRN+dxo6GYDj77eci2+ylqmzrYM5cnKF6f5xSQHsm+w==
X-OriginatorOrg: purelifi.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1813ede8-8812-4dfc-b160-08d8639830c3
X-MS-Exchange-CrossTenant-AuthSource: CWLP265MB1972.GBRP265.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Sep 2020 10:21:00.9592
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 5cf4eba2-7b8f-4236-bed4-a2ac41f1a6dc
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: f4c+6EMzEoMskfFHZ2rGhVN0G6fuQoM7kXPwTjnKrQOJ/Tc008q0RcQi2mf6JBgVLyzIowfyNmwqPytngkFC5Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CWLP265MB0324
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This introduces the pureLiFi LiFi driver for LiFi-X, LiFi-XC
and LiFi-XL USB devices, which provide lightweight, highspeed secure and
fully networked wireless communications via light.

This driver implementation has been based on the zd1211rw driver

Driver is based on 802.11 softMAC Architecture and uses
native 802.11 for configuration and management
The driver is compiled and tested in ARM, x86 architectures and
compiled in powerpc architecture

Signed-off-by: Srinivasan Raju <srini.raju@purelifi.com>
---
 MAINTAINERS                                   |    5 +
 drivers/net/wireless/Kconfig                  |    1 +
 drivers/net/wireless/Makefile                 |    1 +
 drivers/net/wireless/purelifi/Kconfig         |   38 +
 drivers/net/wireless/purelifi/Makefile        |    3 +
 drivers/net/wireless/purelifi/chip.c          |  120 ++
 drivers/net/wireless/purelifi/chip.h          |   81 +
 drivers/net/wireless/purelifi/def.h           |   46 +
 drivers/net/wireless/purelifi/log.h           |   15 +
 drivers/net/wireless/purelifi/mac.c           |  957 +++++++++
 drivers/net/wireless/purelifi/mac.h           |  178 ++
 .../net/wireless/purelifi/mac_usb_interface.h |   38 +
 drivers/net/wireless/purelifi/usb.c           | 1872 +++++++++++++++++
 drivers/net/wireless/purelifi/usb.h           |  148 ++
 14 files changed, 3503 insertions(+)
 create mode 100644 drivers/net/wireless/purelifi/Kconfig
 create mode 100644 drivers/net/wireless/purelifi/Makefile
 create mode 100644 drivers/net/wireless/purelifi/chip.c
 create mode 100644 drivers/net/wireless/purelifi/chip.h
 create mode 100644 drivers/net/wireless/purelifi/def.h
 create mode 100644 drivers/net/wireless/purelifi/log.h
 create mode 100644 drivers/net/wireless/purelifi/mac.c
 create mode 100644 drivers/net/wireless/purelifi/mac.h
 create mode 100644 drivers/net/wireless/purelifi/mac_usb_interface.h
 create mode 100644 drivers/net/wireless/purelifi/usb.c
 create mode 100644 drivers/net/wireless/purelifi/usb.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 42c69d2eeece..0e8cd1decafe 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14098,6 +14098,11 @@ T:	git git://linuxtv.org/media_tree.git
 F:	Documentation/admin-guide/media/pulse8-cec.rst
 F:	drivers/media/cec/usb/pulse8/
 
+PUREILIFI USB DRIVER
+M:	Srinivasan Raju <srini.raju@purelifi.com>
+S:	Maintained
+F:	drivers/net/wireless/purelifi
+
 PVRUSB2 VIDEO4LINUX DRIVER
 M:	Mike Isely <isely@pobox.com>
 L:	pvrusb2@isely.net	(subscribers-only)
diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
index 170a64e67709..b87da3139f94 100644
--- a/drivers/net/wireless/Kconfig
+++ b/drivers/net/wireless/Kconfig
@@ -48,6 +48,7 @@ source "drivers/net/wireless/st/Kconfig"
 source "drivers/net/wireless/ti/Kconfig"
 source "drivers/net/wireless/zydas/Kconfig"
 source "drivers/net/wireless/quantenna/Kconfig"
+source "drivers/net/wireless/purelifi/Kconfig"
 
 config PCMCIA_RAYCS
 	tristate "Aviator/Raytheon 2.4GHz wireless support"
diff --git a/drivers/net/wireless/Makefile b/drivers/net/wireless/Makefile
index 80b324499786..c403dda7a14e 100644
--- a/drivers/net/wireless/Makefile
+++ b/drivers/net/wireless/Makefile
@@ -20,6 +20,7 @@ obj-$(CONFIG_WLAN_VENDOR_ST) += st/
 obj-$(CONFIG_WLAN_VENDOR_TI) += ti/
 obj-$(CONFIG_WLAN_VENDOR_ZYDAS) += zydas/
 obj-$(CONFIG_WLAN_VENDOR_QUANTENNA) += quantenna/
+obj-$(WLAN_VENDOR_PURELIFI) += purelifi/
 
 # 16-bit wireless PCMCIA client drivers
 obj-$(CONFIG_PCMCIA_RAYCS)	+= ray_cs.o
diff --git a/drivers/net/wireless/purelifi/Kconfig b/drivers/net/wireless/purelifi/Kconfig
new file mode 100644
index 000000000000..ff05eaf0a8d4
--- /dev/null
+++ b/drivers/net/wireless/purelifi/Kconfig
@@ -0,0 +1,38 @@
+# SPDX-License-Identifier: GPL-2.0
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
+config PURELIFI
+
+	tristate "pureLiFi device support"
+	depends on CFG80211 && MAC80211 && USB
+	help
+	   Say Y if you want to use LiFi.
+
+	   This driver makes the adapter appear as a normal WLAN interface.
+
+	   The pureLiFi device requires external STA firmware to be loaded.
+
+	   To compile this driver as a module, choose M here: the module will
+	   be called purelifi.
+
+config PURELIFI_AP
+
+	tristate "pureLiFi device Access Point support"
+	depends on PURELIFI
+	help
+	   Say Y if you want to use LiFi in Access Point mode.
+
+	   The pureLiFi device requires external AP firmware to be loaded.
+
+endif # WLAN_VENDOR_PURELIFI
diff --git a/drivers/net/wireless/purelifi/Makefile b/drivers/net/wireless/purelifi/Makefile
new file mode 100644
index 000000000000..1f20055e741f
--- /dev/null
+++ b/drivers/net/wireless/purelifi/Makefile
@@ -0,0 +1,3 @@
+# SPDX-License-Identifier: GPL-2.0
+obj-$(CONFIG_PURELIFI)		:= purelifi.o
+purelifi-objs 		+= chip.o usb.o mac.o
diff --git a/drivers/net/wireless/purelifi/chip.c b/drivers/net/wireless/purelifi/chip.c
new file mode 100644
index 000000000000..32e6984703b6
--- /dev/null
+++ b/drivers/net/wireless/purelifi/chip.c
@@ -0,0 +1,120 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <linux/kernel.h>
+#include <linux/errno.h>
+
+#include "def.h"
+#include "chip.h"
+#include "mac.h"
+#include "usb.h"
+#include "log.h"
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
+	PURELIFI_ASSERT(!mutex_is_locked(&chip->mutex));
+	purelifi_usb_release(&chip->usb);
+	mutex_destroy(&chip->mutex);
+}
+
+int purelifi_set_beacon_interval(struct purelifi_chip *chip, u16 interval,
+				 u8 dtim_period, int type)
+{
+	if (!interval || (chip->beacon_set &&
+			  chip->beacon_interval == interval)) {
+		return 0;
+	}
+
+	chip->beacon_interval = interval;
+	chip->beacon_set = true;
+	return usb_write_req((const u8 *)&chip->beacon_interval,
+			     sizeof(chip->beacon_interval),
+			     USB_REQ_BEACON_INTERVAL_WR);
+}
+
+static void print_chip_info(struct purelifi_chip *chip)
+{
+	u8 *addr = purelifi_mac_get_perm_addr(purelifi_chip_to_mac(chip));
+	struct usb_device *udev = interface_to_usbdev(chip->usb.intf);
+
+	pr_info("purelifi chip %04hx:%04hx v%04hx  %02x-%02x-%02x %s\n",
+		le16_to_cpu(udev->descriptor.idVendor),
+		le16_to_cpu(udev->descriptor.idProduct),
+		le16_to_cpu(udev->descriptor.bcdDevice),
+		addr[0], addr[1], addr[2],
+		speed(udev->speed));
+}
+
+int purelifi_chip_init_hw(struct purelifi_chip *chip)
+{
+	print_chip_info(chip);
+	return purelifi_set_beacon_interval(chip, 100, 0, 0);
+}
+
+int purelifi_chip_switch_radio(struct purelifi_chip *chip, u32 value)
+{
+	int r;
+
+	r = usb_write_req((const u8 *)&value, sizeof(value), USB_REQ_POWER_WR);
+	if (r)
+		pl_dev_err(purelifi_chip_dev(chip), "%s::r=%d",
+			   __func__, r);
+	return r;
+}
+
+int purelifi_chip_switch_radio_on(struct purelifi_chip *chip)
+{
+	return purelifi_chip_switch_radio(chip, 1);
+}
+
+int purelifi_chip_switch_radio_off(struct purelifi_chip *chip)
+{
+	return purelifi_chip_switch_radio(chip, 0);
+}
+
+void purelifi_chip_enable_rxtx_urb_complete(struct urb *urb_struct)
+{
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
+	u32 value;
+
+	value = 0;
+	usb_write_req((const u8 *)&value, sizeof(value), USB_REQ_RXTX_WR);
+	purelifi_usb_disable_rx(&chip->usb);
+	purelifi_usb_disable_tx(&chip->usb);
+}
+
+int purelifi_chip_set_rate(struct purelifi_chip *chip, u32 rate)
+{
+	int r;
+	static struct purelifi_chip *chip_p;
+
+	if (chip)
+		chip_p = chip;
+	if (!chip_p)
+		return -EINVAL;
+
+	r = usb_write_req((const u8 *)&rate, sizeof(rate), USB_REQ_RATE_WR);
+	if (r)
+		pl_dev_err(purelifi_chip_dev(chip), "%s::r=%d",
+			   __func__, r);
+	return r;
+}
+
+MODULE_LICENSE("GPL");
diff --git a/drivers/net/wireless/purelifi/chip.h b/drivers/net/wireless/purelifi/chip.h
new file mode 100644
index 000000000000..892ecaf7d5d3
--- /dev/null
+++ b/drivers/net/wireless/purelifi/chip.h
@@ -0,0 +1,81 @@
+/* SPDX-License-Identifier: GPL-2.0 */
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
+	u16 beacon_interval;
+};
+
+struct purelifi_mc_hash {
+	u32 low;
+	u32 high;
+};
+
+#define purelifi_chip_dev(chip) (&(chip)->usb.intf->dev)
+
+static inline struct purelifi_chip *purelifi_usb_to_chip(struct purelifi_usb
+							 *usb
+							)
+{
+	return container_of(usb, struct purelifi_chip, usb);
+}
+
+void purelifi_chip_init(struct purelifi_chip *chip,
+			struct ieee80211_hw *hw,
+			struct usb_interface *intf);
+void purelifi_chip_release(struct purelifi_chip *chip);
+int purelifi_chip_init_hw(struct purelifi_chip *chip);
+
+/* Locking functions for reading and writing registers.
+ * The different parameters are intentional.
+ */
+int purelifi_chip_switch_radio_on(struct purelifi_chip *chip);
+int purelifi_chip_switch_radio_off(struct purelifi_chip *chip);
+int purelifi_chip_enable_rxtx(struct purelifi_chip *chip);
+void purelifi_chip_disable_rxtx(struct purelifi_chip *chip);
+int purelifi_chip_set_rate(struct purelifi_chip *chip, u32 rate);
+int purelifi_set_beacon_interval(struct purelifi_chip *chip, u16 interval,
+				 u8 dtim_period, int type);
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
+	hash->low = 0xffffffff;
+	hash->high = 0xffffffff;
+}
+
+static inline void purelifi_mc_add_addr(struct purelifi_mc_hash *hash,
+					u8 *addr
+					)
+{
+	unsigned int i = addr[5] >> 2;
+
+	if (i < 32)
+		hash->low |= 1 << i;
+	else
+		hash->high |= 1 << (i - 32);
+}
+#endif /* _LF_X_CHIP_H */
diff --git a/drivers/net/wireless/purelifi/def.h b/drivers/net/wireless/purelifi/def.h
new file mode 100644
index 000000000000..295dfb45b568
--- /dev/null
+++ b/drivers/net/wireless/purelifi/def.h
@@ -0,0 +1,46 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#ifndef _PURELIFI_DEF_H
+#define _PURELIFI_DEF_H
+
+#include <linux/kernel.h>
+#include <linux/stringify.h>
+#include <linux/device.h>
+
+typedef u16 __nocast purelifi_addr_t;
+
+#define dev_printk_f(level, dev, fmt, args...) \
+	dev_printk(level, dev, "%s() " fmt, __func__, ##args)
+
+#ifdef DEBUG
+#  define dev_dbg_f(dev, fmt, args...) \
+	  dev_printk_f(KERN_DEBUG, dev, fmt, ## args)
+#  define dev_dbg_f_limit(dev, fmt, args...) do { \
+	if (net_ratelimit()) \
+		dev_printk_f(KERN_DEBUG, dev, fmt, ## args); \
+} while (0)
+#  define dev_dbg_f_cond(dev, cond, fmt, args...) ({ \
+	bool __cond = !!(cond); \
+	if (unlikely(__cond)) \
+		dev_printk_f(KERN_DEBUG, dev, fmt, ## args); \
+})
+#else
+#  define dev_dbg_f(dev, fmt, args...)  (void)(dev)
+#  define dev_dbg_f_limit(dev, fmt, args...) (void)(dev)
+#  define dev_dbg_f_cond(dev, cond, fmt, args...) (void)(dev)
+#endif /* DEBUG */
+
+#ifdef DEBUG
+#  define PURELIFI_ASSERT(x) \
+do { \
+	if (unlikely(!(x))) { \
+		pr_debug("%s:%d ASSERT %s VIOLATED!\n", \
+			__FILE__, __LINE__, __stringify(x)); \
+		dump_stack(); \
+	} \
+} while (0)
+#else
+#  define PURELIFI_ASSERT(x) do { } while (0)
+#endif
+
+#endif /* _PURELIFI_DEF_H */
diff --git a/drivers/net/wireless/purelifi/log.h b/drivers/net/wireless/purelifi/log.h
new file mode 100644
index 000000000000..5e275da9ba12
--- /dev/null
+++ b/drivers/net/wireless/purelifi/log.h
@@ -0,0 +1,15 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#ifndef _PURELIFI_LOG
+#define _PURELIFI_LOG
+
+#ifdef PL_DEBUG
+#define pl_dev_info(dev, fmt, arg...) dev_info(dev, fmt, ##arg)
+#define pl_dev_warn(dev, fmt, arg...) dev_warn(dev, fmt, ##arg)
+#define  pl_dev_err(dev, fmt, arg...) dev_err(dev, fmt, ##arg)
+#else
+#define pl_dev_info(dev, fmt, arg...) (void)(dev)
+#define pl_dev_warn(dev, fmt, arg...) (void)(dev)
+#define  pl_dev_err(dev, fmt, arg...) (void)(dev)
+#endif
+#endif
diff --git a/drivers/net/wireless/purelifi/mac.c b/drivers/net/wireless/purelifi/mac.c
new file mode 100644
index 000000000000..c6be289f8431
--- /dev/null
+++ b/drivers/net/wireless/purelifi/mac.c
@@ -0,0 +1,957 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <linux/netdevice.h>
+#include <linux/etherdevice.h>
+#include <linux/slab.h>
+#include <linux/usb.h>
+#include <linux/gpio.h>
+#include <linux/jiffies.h>
+#include <net/ieee80211_radiotap.h>
+
+#include "def.h"
+#include "chip.h"
+#include "mac.h"
+#include "log.h"
+
+#ifndef IEEE80211_BAND_2GHZ
+#define IEEE80211_BAND_2GHZ NL80211_BAND_2GHZ
+#endif
+
+static const struct ieee80211_rate purelifi_rates[] = {
+	{ .bitrate = 10,
+		.hw_value = PURELIFI_CCK_RATE_1M, },
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
+		.flags = 0 },
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
+				      struct sk_buff *beacon, bool in_intr);
+
+int purelifi_mac_preinit_hw(struct ieee80211_hw *hw, unsigned char *hw_address)
+{
+	SET_IEEE80211_PERM_ADDR(hw, hw_address);
+	return 0;
+}
+
+void block_queue(struct purelifi_usb *usb, const u8 *mac, bool block)
+{
+#ifdef CONFIG_PURELIFI_AP
+	struct ieee80211_vif *vif = purelifi_usb_to_mac(usb)->vif;
+	struct ieee80211_sta *sta = ieee80211_find_sta(vif, mac);
+
+	if (!sta) {
+		//Print Debugs
+	} else {
+		ieee80211_sta_block_awake(purelifi_usb_to_hw(usb), sta,
+					  block);
+	}
+#else
+	if (block)
+		ieee80211_stop_queues(purelifi_usb_to_hw(usb));
+	else
+		ieee80211_wake_queues(purelifi_usb_to_hw(usb));
+#endif
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
+		pl_dev_warn(purelifi_mac_dev(mac), "%s::purelifi_chip_init_hw	failed. (%d)\n",
+			    __func__, r);
+		goto out;
+	}
+	PURELIFI_ASSERT(!irqs_disabled());
+
+	r = regulatory_hint(hw->wiphy, "CA");
+out:
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
+	regulatory_hint(hw->wiphy, "EU");
+	purelifi_hw_mac(hw)->chip.usb.initialized = 1;
+	return 0;
+}
+
+void purelifi_op_stop(struct ieee80211_hw *hw)
+{
+	struct purelifi_mac *mac = purelifi_hw_mac(hw);
+	struct purelifi_chip *chip = &mac->chip;
+	struct sk_buff *skb;
+	struct sk_buff_head *ack_wait_queue = &mac->ack_wait_queue;
+
+	pl_dev_info(purelifi_mac_dev(mac), "%s", __func__);
+
+	clear_bit(PURELIFI_DEVICE_RUNNING, &mac->flags);
+
+	/* The order here deliberately is a little different from the open()
+	 * method, since we need to make sure there is no opportunity for RX
+	 * frames to be processed by mac80211 after we have stopped it.
+	 */
+
+	return;  //don't allow stop for debugging rx_urb_complete failure
+	purelifi_chip_switch_radio_off(chip);
+
+	while ((skb = skb_dequeue(ack_wait_queue)))
+		dev_kfree_skb_any(skb);
+	return;  //don't allow stop for debugging rx_urb_complete failure
+}
+
+int purelifi_restore_settings(struct purelifi_mac *mac)
+{
+	struct sk_buff *beacon;
+	struct purelifi_mc_hash multicast_hash;
+	int beacon_interval, beacon_period;
+
+	dev_dbg_f(purelifi_mac_dev(mac), "\n");
+
+	spin_lock_irq(&mac->lock);
+	multicast_hash = mac->multicast_hash;
+	beacon_interval = mac->beacon.interval;
+	beacon_period = mac->beacon.period;
+	spin_unlock_irq(&mac->lock);
+
+	if (mac->type == NL80211_IFTYPE_MESH_POINT ||
+	    mac->type == NL80211_IFTYPE_ADHOC ||
+			mac->type == NL80211_IFTYPE_AP) {
+		if (mac->vif) {
+			beacon = ieee80211_beacon_get(mac->hw, mac->vif);
+			if (beacon) {
+				purelifi_mac_config_beacon(mac->hw, beacon,
+							   false);
+				kfree_skb(beacon);
+				/* Returned skb is used only once and lowlevel
+				 *  driver is responsible for freeing it.
+				 */
+			}
+		}
+
+		purelifi_set_beacon_interval(&mac->chip, beacon_interval,
+					     beacon_period, mac->type);
+
+		spin_lock_irq(&mac->lock);
+		mac->beacon.last_update = jiffies;
+		spin_unlock_irq(&mac->lock);
+	}
+
+	return 0;
+}
+
+/**
+ * purelifi_mac_tx_status - reports tx status of a packet if required
+ * @hw - a &struct ieee80211_hw pointer
+ * @skb - a sk-buffer
+ * @flags: extra flags to set in the TX status info
+ * @ackssi: ACK signal strength
+ * @success - True for successful transmission of the frame
+ *
+ * This information calls ieee80211_tx_status_irqsafe() if required by the
+ * control information. It copies the control information into the status
+ * information.
+ *
+ * If no status information has been requested, the skb is freed.
+ */
+static void purelifi_mac_tx_status(struct ieee80211_hw *hw,
+				   struct sk_buff *skb,
+		int ackssi, struct tx_status *tx_status)
+{
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	int success = 1, retry = 1;
+
+	ieee80211_tx_info_clear_status(info);
+
+	if (tx_status) {
+		success = !tx_status->failure;
+		retry = tx_status->retry + success;
+	}
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
+ * purelifi_mac_tx_to_dev - callback for USB layer
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
+		//FIXME : do we need to fill in anything ?
+		ieee80211_tx_status_irqsafe(hw, skb);
+	} else {
+		// ieee80211_tx_status_irqsafe(hw, skb);
+		struct sk_buff_head *q = &mac->ack_wait_queue;
+
+		skb_queue_tail(q, skb);
+		while (skb_queue_len(q)/* > PURELIFI_MAC_MAX_ACK_WAITERS*/) {
+			purelifi_mac_tx_status(hw, skb_dequeue(q),
+					       mac->ack_pending ?
+					mac->ack_signal : 0,
+					NULL);
+			mac->ack_pending = 0;
+		}
+	}
+}
+
+static int purelifi_mac_config_beacon(struct ieee80211_hw *hw,
+				      struct sk_buff *beacon, bool in_intr)
+{
+	return usb_write_req((const u8 *)beacon->data, beacon->len,
+			USB_REQ_BEACON_WR);
+}
+
+static int fill_ctrlset(struct purelifi_mac *mac, struct sk_buff *skb)
+{
+	unsigned int frag_len = skb->len;
+	unsigned int tmp;
+	struct purelifi_ctrlset *cs;
+
+	if (skb_headroom(skb) >= sizeof(struct purelifi_ctrlset)) {
+		cs = (struct purelifi_ctrlset *)skb_push(skb,
+				sizeof(struct purelifi_ctrlset));
+	} else {
+		pl_dev_info(purelifi_mac_dev(mac), "Not enough hroom(1)\n");
+		return 1;
+	}
+
+	cs->id = USB_REQ_DATA_TX;
+	cs->payload_len_nw = frag_len;
+	cs->len = cs->payload_len_nw + sizeof(struct purelifi_ctrlset)
+		- sizeof(cs->id) - sizeof(cs->len);
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
+	/*check if 32 bit aligned */
+	tmp = skb->len & 3;
+	if (tmp) {
+		if (skb_tailroom(skb) >= (3 - tmp)) {
+			skb_put(skb, 4 - tmp);
+		} else {
+			if (skb_headroom(skb) >= 4 - tmp) {
+				u8 len;
+				u8 *src_pt;
+				u8 *dest_pt;
+
+				len = skb->len;
+				src_pt = skb->data;
+				dest_pt = skb_push(skb, 4 - tmp);
+				memcpy(dest_pt, src_pt, len);
+			} else {
+				return 1;
+			}
+		}
+		cs->len +=  4 - tmp;
+	}
+
+	//check if not multiple of 512
+	tmp = skb->len & 0x1ff;
+	if (!tmp) {
+		if (skb_tailroom(skb) >= 4) {
+			skb_put(skb, 4);
+		} else {
+			if (skb_headroom(skb) >= 4) {
+				u8 len = skb->len;
+				u8 *src_pt = skb->data;
+				u8 *dest_pt = skb_push(skb, 4);
+
+				memcpy(dest_pt, src_pt, len);
+			} else {
+				/* should never happen b/c
+				 * sufficient headroom was reserved
+				 */
+				return 1;
+			}
+		}
+
+		cs->len +=  4;
+	}
+
+	cs->id = TO_NETWORK(cs->id);
+	cs->len = TO_NETWORK(cs->len);
+	cs->payload_len_nw = TO_NETWORK(cs->payload_len_nw);
+
+	return 0;
+}
+
+/**
+ * purelifi_op_tx - transmits a network frame to the device
+ *
+ * @dev: mac80211 hardware device
+ * @skb: socket buffer
+ * @control: the control structure
+ *
+ * This function transmit an IEEE 802.11 network frame to the device. The
+ * control block of the skbuff will be initialized. If necessary the incoming
+ * mac80211 queues will be stopped.
+ */
+extern void send_packet_from_data_queue(struct purelifi_usb *usb);
+static void purelifi_op_tx(struct ieee80211_hw *hw,
+			   struct ieee80211_tx_control *control,
+			   struct sk_buff *skb)
+{
+	struct purelifi_mac *mac = purelifi_hw_mac(hw);
+	struct purelifi_usb *usb = &mac->chip.usb;
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	unsigned long flags;
+	int r;
+
+	r = fill_ctrlset(mac, skb);
+	if (r)
+		goto fail;
+	info->rate_driver_data[0] = hw;
+
+	if (skb->data[24] != 0x08 && skb->len == 116)
+		pl_dev_info(purelifi_mac_dev(mac), "%s::ping\n", __func__);
+
+	if (skb->data[24] != 0x08) {
+		spin_lock_irqsave(&usb->tx.lock, flags);
+		r = usb_write_req_async(&mac->chip.usb, skb->data, skb->len,
+					USB_REQ_DATA_TX, tx_urb_complete, skb);
+		spin_unlock_irqrestore(&usb->tx.lock, flags);
+		if (r)
+			goto fail;
+	} else {
+		u8 dst_mac[ETH_ALEN];
+		u8 sidx;
+		bool found = false;
+
+		memcpy(dst_mac, &skb->data[28], ETH_ALEN);
+		for (sidx = 0; sidx < MAX_STA_NUM; sidx++) {
+			if (usb->tx.station[sidx].flag &
+					STATION_CONNECTED_FLAG) {
+				if (!memcmp(usb->tx.station[sidx].mac,
+					    dst_mac, ETH_ALEN)) {
+					found = true;
+					break;
+				}
+			}
+		}
+
+		// Default to broadcast address for unknown MACs.
+
+		if (!found)
+			sidx = STA_BROADCAST_INDEX;
+
+		// Stop OS from sending any packets,
+		// if the queue is half full.
+		if (skb_queue_len(&usb->tx.station[sidx].data_list) > 60)
+			block_queue(usb, usb->tx.station[sidx].mac, true);
+
+		// Schedule packet for transmission if queue is not full
+		if (skb_queue_len(&usb->tx.station[sidx].data_list) < 256) {
+			skb_queue_tail(&usb->tx.station[sidx].data_list, skb);
+			send_packet_from_data_queue(usb);
+		} else {
+			dev_kfree_skb(skb);
+		}
+	}
+	return;
+
+fail:
+	dev_kfree_skb(skb);
+}
+
+/**
+ * filter_ack - filters incoming packets for acknowledgements
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
+static int filter_ack(struct ieee80211_hw *hw, struct ieee80211_hdr *rx_hdr,
+		      struct ieee80211_rx_status *stats)
+{
+	struct purelifi_mac *mac = purelifi_hw_mac(hw);
+	struct sk_buff *skb;
+	struct sk_buff_head *q;
+	unsigned long flags;
+	int found = 0;
+	int i, position = 0;
+
+	if (!ieee80211_is_ack(rx_hdr->frame_control))
+		return 0;
+	pl_dev_info(purelifi_mac_dev(mac), "%s::ACK Received", __func__);
+	return 0;
+
+	q = &mac->ack_wait_queue;
+	spin_lock_irqsave(&q->lock, flags);
+	skb_queue_walk(q, skb) {
+		struct ieee80211_hdr *tx_hdr;
+
+		position++;
+
+		if (mac->ack_pending && skb_queue_is_first(q, skb))
+			continue;
+
+		tx_hdr = (struct ieee80211_hdr *)skb->data;
+		if (likely(ether_addr_equal(tx_hdr->addr2, rx_hdr->addr1))) {
+			found = 1;
+			break;
+		}
+	}
+
+	if (found) {
+		for (i = 1; i < position; i++) {
+			skb = __skb_dequeue(q);
+			purelifi_mac_tx_status(hw, skb,
+					       mac->ack_pending ?
+					mac->ack_signal : 0,
+					NULL);
+			mac->ack_pending = 0;
+		}
+
+		mac->ack_pending = 1;
+		mac->ack_signal = stats->signal;
+
+		/* Prevent pending tx-packet on AP-mode */
+		if (mac->type == NL80211_IFTYPE_AP) {
+			skb = __skb_dequeue(q);
+			purelifi_mac_tx_status(hw, skb,
+					       mac->ack_signal, NULL);
+			mac->ack_pending = 0;
+		}
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
+	u32 crc_error_cnt_low, crc_error_cnt_high;
+	int sidx;
+
+	// Packet blockade during disabled interface.
+	if (!mac->vif)
+		return 0;
+
+	memset(&stats, 0, sizeof(stats));
+	status = (struct rx_status *)buffer;
+
+	stats.flag     = 0;
+	stats.freq     = 2412;
+	stats.band     = IEEE80211_BAND_2GHZ;
+	mac->rssi      = -15 * ntohs(status->rssi) / 10;
+
+	stats.signal   = mac->rssi;
+
+	if (status->rate_idx > 7)
+		stats.rate_idx = 0;
+	else
+		stats.rate_idx = status->rate_idx;
+
+	crc_error_cnt_low = status->crc_error_count;
+	crc_error_cnt_high = status->crc_error_count >> 32;
+	mac->crc_errors = ((u64)ntohl(crc_error_cnt_low) << 32) |
+		ntohl(crc_error_cnt_high);
+
+	if (!bad_frame &&
+	    filter_ack(hw, (struct ieee80211_hdr *)buffer, &stats) &&
+	    !mac->pass_ctrl)
+		return 0;
+
+	buffer += sizeof(struct rx_status);
+	payload_length = TO_HOST(*(u32 *)buffer);
+
+	// MTU = 1500, MAC header = 36, CRC = 4, sum = 1540
+	if (payload_length > 1560) {
+		pl_dev_info(purelifi_mac_dev(mac), "%s::payload_length=%u\n",
+			    __func__, payload_length);
+		return 0;
+	}
+	buffer += sizeof(u32);
+
+	fc = get_unaligned((__le16 *)buffer);
+	need_padding = ieee80211_is_data_qos(fc) ^ ieee80211_has_a4(fc);
+
+	for (sidx = 0; sidx < MAX_STA_NUM - 1; sidx++) {
+		if (!memcmp(&buffer[10],
+			    mac->chip.usb.tx.station[sidx].mac,
+					ETH_ALEN)) {
+			if (mac->chip.usb.tx.station[sidx].flag &
+					STATION_CONNECTED_FLAG) {
+				mac->chip.usb.tx.station[sidx].flag |=
+					STATION_HEARTBEAT_FLAG;
+				break;
+			}
+		}
+	}
+
+	if (sidx == MAX_STA_NUM - 1) {
+		for (sidx = 0; sidx < MAX_STA_NUM - 1; sidx++) {
+			if (!(mac->chip.usb.tx.station[sidx].flag &
+						STATION_CONNECTED_FLAG
+			     )) {
+				memcpy(mac->chip.usb.tx.station[sidx].mac,
+				       &buffer[10],
+						ETH_ALEN);
+				mac->chip.usb.tx.station[sidx].flag |=
+					STATION_CONNECTED_FLAG;
+				mac->chip.usb.tx.station[sidx].flag |=
+					STATION_HEARTBEAT_FLAG;
+				break;
+			}
+		}
+	}
+
+	if (buffer[0] == 0xb0) {
+		pl_dev_info(purelifi_mac_dev(mac), "%s:Authentication req\n",
+			    __func__);
+	} else if (buffer[0] == 0x40) {
+		pl_dev_info(purelifi_mac_dev(mac), "%s:Probe request\n",
+			    __func__);
+	} else if (buffer[0] == 0x0) {
+		pl_dev_info(purelifi_mac_dev(mac), "%s:Association request\n",
+			    __func__);
+	}
+
+	if (buffer[0] == 0xb0) {
+		min_exp_seq_nmb = 0;
+	} else if (buffer[0] == 0x08) {
+		unsigned short int seq_nmb = (buffer[23] << 4) |
+			((buffer[22] & 0xF0) >> 4);
+
+		if (seq_nmb < min_exp_seq_nmb &&
+		    ((min_exp_seq_nmb - seq_nmb) < 3000)) {
+			// return 0;
+		} else {
+			min_exp_seq_nmb = (seq_nmb + 1) % 4096;
+		}
+	}
+
+	skb = dev_alloc_skb(payload_length + (need_padding ? 2 : 0));
+	if (!skb)
+		return -ENOMEM;
+	if (need_padding) {
+		/* Make sure that the payload data is 4 byte aligned. */
+		skb_reserve(skb, 2);
+	}
+
+	/* FIXME : could we avoid this big memcpy ? */
+	memcpy(skb_put(skb, payload_length), buffer, payload_length);
+	memcpy(IEEE80211_SKB_RXCB(skb), &stats, sizeof(stats));
+	ieee80211_rx_irqsafe(hw, skb);
+	return 0;
+}
+
+static int purelifi_op_add_interface(struct ieee80211_hw *hw,
+				     struct ieee80211_vif *vif)
+{
+	struct purelifi_mac *mac = purelifi_hw_mac(hw);
+
+	pl_dev_info(purelifi_mac_dev(mac), "%s\n", __func__);
+
+	if (mac->type != NL80211_IFTYPE_UNSPECIFIED)
+		return -EOPNOTSUPP;
+
+	switch (vif->type) {
+	case NL80211_IFTYPE_MONITOR:
+		pl_dev_info(purelifi_mac_dev(mac),
+			    "%s::NL80211_IFTYPE_MONITOR\n",
+				__func__);
+		break;
+	case NL80211_IFTYPE_MESH_POINT:
+		pl_dev_info(purelifi_mac_dev(mac),
+			    "%s::NL80211_IFTYPE_MESH_POINT\n",
+				__func__);
+		break;
+	case NL80211_IFTYPE_STATION:
+		pl_dev_info(purelifi_mac_dev(mac),
+			    "%s::NL80211_IFTYPE_STATION\n",
+				__func__);
+		break;
+	case NL80211_IFTYPE_ADHOC:
+		pl_dev_info(purelifi_mac_dev(mac),
+			    "%s::NL80211_IFTYPE_ADHOC\n",
+				__func__);
+		break;
+	case NL80211_IFTYPE_AP:
+		pl_dev_info(purelifi_mac_dev(mac),
+			    "%s::vif->type=NL80211_IFTYPE_AP\n",
+				__func__);
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+	mac->type = vif->type;
+	mac->vif = vif;
+	return 0;
+}
+
+static void purelifi_op_remove_interface(struct ieee80211_hw *hw,
+					 struct ieee80211_vif *vif)
+{
+	struct purelifi_mac *mac = purelifi_hw_mac(hw);
+
+	pl_dev_info(purelifi_mac_dev(mac), "%s\n", __func__);
+	mac->type = NL80211_IFTYPE_UNSPECIFIED;
+	mac->vif = NULL;
+}
+
+static int purelifi_op_config(struct ieee80211_hw *hw, u32 changed)
+{
+	struct purelifi_mac *mac = purelifi_hw_mac(hw);
+
+	spin_lock_irq(&mac->lock);
+	spin_unlock_irq(&mac->lock);
+
+	return 0;
+}
+
+#define SUPPORTED_FIF_FLAGS \
+	(FIF_ALLMULTI | FIF_FCSFAIL | FIF_CONTROL | \
+	 FIF_OTHER_BSS | FIF_BCN_PRBRESP_PROMISC)
+static void purelifi_op_configure_filter(struct ieee80211_hw *hw,
+					 unsigned int changed_flags,
+		unsigned int *new_flags,
+		u64 multicast)
+{
+	struct purelifi_mc_hash hash = {
+		.low = multicast,
+		.high = multicast >> 32,
+	};
+	struct purelifi_mac *mac = purelifi_hw_mac(hw);
+	unsigned long flags;
+	int r;
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
+	//purelifi_chip_set_multicast_hash(&mac->chip, &hash);
+
+	if (changed_flags & FIF_CONTROL) {
+		/* TODO: Re-enable these lines?
+		 * r = set_rx_filter(mac);
+		 * if (r)
+		 * pl_dev_err(purelifi_mac_dev(mac),
+		 *  "set_rx_filter error %d\n", r);
+		 */
+		r = 0;
+	}
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
+		struct ieee80211_bss_conf *bss_conf,
+		u32 changes)
+{
+	struct purelifi_mac *mac = purelifi_hw_mac(hw);
+	int associated;
+
+	pl_dev_info(purelifi_mac_dev(mac), "%s\n", __func__);
+	pl_dev_info(purelifi_mac_dev(mac), "changes: %x\n", changes);
+
+	if (mac->type == NL80211_IFTYPE_MESH_POINT ||
+	    mac->type == NL80211_IFTYPE_ADHOC ||
+	    mac->type == NL80211_IFTYPE_AP) {
+		associated = true;
+		if (changes & BSS_CHANGED_BEACON) {
+			struct sk_buff *beacon = ieee80211_beacon_get(hw,
+					vif);
+
+			if (beacon) {
+				purelifi_mac_config_beacon(hw, beacon, false);
+				kfree_skb(beacon);
+				/*Returned skb is used only once and
+				 * low-level driver is
+				 * responsible for freeing it.
+				 */
+			}
+		}
+
+		if (changes & BSS_CHANGED_BEACON_ENABLED) {
+			u16 interval = 0;
+			u8 period = 0;
+
+			if (bss_conf->enable_beacon) {
+				period = bss_conf->dtim_period;
+				interval = bss_conf->beacon_int;
+			}
+
+			spin_lock_irq(&mac->lock);
+			mac->beacon.period = period;
+			mac->beacon.interval = interval;
+			mac->beacon.last_update = jiffies;
+			spin_unlock_irq(&mac->lock);
+
+			purelifi_set_beacon_interval(&mac->chip, interval,
+						     period, mac->type);
+		}
+	} else {
+		associated = is_valid_ether_addr(bss_conf->bssid);
+	}
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
+const char et_strings[][ETH_GSTRING_LEN] = {
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
+		struct ethtool_stats *stats, u64 *data)
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
+		dev_dbg_f(&intf->dev, "out of memory\n");
+		return NULL;
+	}
+	set_wiphy_dev(hw->wiphy, &intf->dev);
+
+	mac = purelifi_hw_mac(hw);
+
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
+	hw->wiphy->bands[IEEE80211_BAND_2GHZ] = &mac->band;
+
+#ifdef ieee80211_hw_set
+	_ieee80211_hw_set(hw, IEEE80211_HW_RX_INCLUDES_FCS);
+	_ieee80211_hw_set(hw, IEEE80211_HW_SIGNAL_DBM);
+	_ieee80211_hw_set(hw, IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING);
+	_ieee80211_hw_set(hw, IEEE80211_HW_MFP_CAPABLE);
+#else
+	hw->flags = IEEE80211_HW_RX_INCLUDES_FCS |
+		IEEE80211_HW_SIGNAL_DBM |
+		IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING |
+		IEEE80211_HW_MFP_CAPABLE;
+#endif
+
+	hw->wiphy->interface_modes =
+		BIT(NL80211_IFTYPE_MESH_POINT) |
+		BIT(NL80211_IFTYPE_STATION) |
+		BIT(NL80211_IFTYPE_ADHOC) |
+		BIT(NL80211_IFTYPE_AP);
+
+	hw->max_signal = 100;
+	hw->queues = 1;
+	hw->extra_tx_headroom = sizeof(struct purelifi_ctrlset) + 4;
+	//4 for 32 bit alignment if no tailroom
+
+	//Tell mac80211 that we support multi rate retries
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
diff --git a/drivers/net/wireless/purelifi/mac.h b/drivers/net/wireless/purelifi/mac.h
new file mode 100644
index 000000000000..35e28cc4dffb
--- /dev/null
+++ b/drivers/net/wireless/purelifi/mac.h
@@ -0,0 +1,178 @@
+/* SPDX-License-Identifier: GPL-2.0 */
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
+#define MODULATION_RATE_BPSK_1_2  0
+#define MODULATION_RATE_BPSK_3_4  (MODULATION_RATE_BPSK_1_2  + 1)
+#define MODULATION_RATE_QPSK_1_2  (MODULATION_RATE_BPSK_3_4  + 1)
+#define MODULATION_RATE_QPSK_3_4  (MODULATION_RATE_QPSK_1_2  + 1)
+#define MODULATION_RATE_QAM16_1_2 (MODULATION_RATE_QPSK_3_4  + 1)
+#define MODULATION_RATE_QAM16_3_4 (MODULATION_RATE_QAM16_1_2 + 1)
+#define MODULATION_RATE_QAM64_1_2 (MODULATION_RATE_QAM16_3_4 + 1)
+#define MODULATION_RATE_QAM64_3_4 (MODULATION_RATE_QAM64_1_2 + 1)
+#define MODULATION_RATE_AUTO      (MODULATION_RATE_QAM64_3_4 + 1)
+#define MODULATION_RATE_NUM       (MODULATION_RATE_AUTO      + 1)
+
+#define purelifi_mac_dev(mac) (purelifi_chip_dev(&(mac)->chip))
+
+#define PURELIFI_MAC_STATS_BUFFER_SIZE 16
+#define PURELIFI_MAC_MAX_ACK_WAITERS 50
+
+struct purelifi_ctrlset {
+	enum usb_req_enum_t id;
+	u32            len;
+	u8             modulation;
+	u8             control;
+	u8             service;
+	u8             pad;
+	__le16         packet_length;
+	__le16         current_length;
+	__le16          next_frame_length;
+	__le16         tx_length;
+	u32            payload_len_nw;
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
+	spinlock_t intr_lock; /* not used : interrupt lock for mac */
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
+	unsigned int ack_pending:1;
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
+static inline struct purelifi_mac *purelifi_hw_mac(struct ieee80211_hw *hw)
+{
+	return hw->priv;
+}
+
+static inline struct purelifi_mac *purelifi_chip_to_mac(struct purelifi_chip
+		*chip)
+{
+	return container_of(chip, struct purelifi_mac, chip);
+}
+
+static inline struct purelifi_mac *purelifi_usb_to_mac(struct purelifi_usb *usb)
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
+int purelifi_mac_preinit_hw(struct ieee80211_hw *hw, unsigned char *hw_address);
+int purelifi_mac_init_hw(struct ieee80211_hw *hw);
+
+int purelifi_mac_rx(struct ieee80211_hw *hw, const u8 *buffer,
+		    unsigned int length);
+void purelifi_mac_tx_failed(struct urb *urb);
+void purelifi_mac_tx_to_dev(struct sk_buff *skb, int error);
+int purelifi_op_start(struct ieee80211_hw *hw);
+void purelifi_op_stop(struct ieee80211_hw *hw);
+int purelifi_restore_settings(struct purelifi_mac *mac);
+void block_queue(struct purelifi_usb *usb, const u8 *mac, bool block);
+
+#ifdef DEBUG
+void purelifi_dump_rx_status(const struct rx_status *status);
+#else
+#define purelifi_dump_rx_status(status)
+#endif
+
+#endif
diff --git a/drivers/net/wireless/purelifi/mac_usb_interface.h b/drivers/net/wireless/purelifi/mac_usb_interface.h
new file mode 100644
index 000000000000..20e96671e0a7
--- /dev/null
+++ b/drivers/net/wireless/purelifi/mac_usb_interface.h
@@ -0,0 +1,38 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#ifndef _PURELIFI_MAC_DRIVER_USB_INTERFACE
+#define _PURELIFI_MAC_DRIVER_USB_INTERFACE
+#define PURELIFI_BYTE_NUM_ALIGNMENT 4
+#ifndef ETH_ALEN
+#define ETH_ALEN 6
+#endif
+#define AP_USER_LIMIT 8
+
+struct rx_status {
+	u16 rssi;
+	u8  rate_idx;
+	u8  pad;
+	u64 crc_error_count;
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
+	enum usb_req_enum_t id;
+	u32            len;
+	u8             buf[512];
+};
+
+#endif
diff --git a/drivers/net/wireless/purelifi/usb.c b/drivers/net/wireless/purelifi/usb.c
new file mode 100644
index 000000000000..759095910175
--- /dev/null
+++ b/drivers/net/wireless/purelifi/usb.c
@@ -0,0 +1,1872 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/firmware.h>
+#include <linux/device.h>
+#include <linux/errno.h>
+#include <linux/slab.h>
+#include <linux/skbuff.h>
+#include <linux/usb.h>
+#include <linux/workqueue.h>
+#include <linux/string.h>
+#include <linux/proc_fs.h>
+#include <linux/fs.h>
+#include <linux/module.h>
+#include <net/mac80211.h>
+#include <asm/unaligned.h>
+#include <linux/version.h>
+#include <linux/sysfs.h>
+
+#include "def.h"
+#include "mac.h"
+#include "usb.h"
+#include "log.h"
+
+#define FCS_LEN 4
+
+#define PURELIFI_X_VENDOR_ID_0  0x16C1
+#define PURELIFI_X_PRODUCT_ID_0 0x1CDE
+#define PURELIFI_XC_VENDOR_ID_0  0x2EF5
+#define PURELIFI_XC_PRODUCT_ID_0 0x0008
+#define PURELIFI_XL_VENDOR_ID_0 0x2EF5
+
+#ifdef CONFIG_PURELIFI_AP
+#define PURELIFI_XL_PRODUCT_ID_0 0x000B
+#else
+#define PURELIFI_XL_PRODUCT_ID_0 0x000A
+#endif
+
+#undef  LOAD_MAC_AND_SERIAL_FROM_FILE
+#undef  LOAD_MAC_AND_SERIAL_FROM_FLASH
+#define LOAD_MAC_AND_SERIAL_FROM_EP0
+
+#define PROC_FOLDER "purelifi"
+#define MODULATION_FILENAME "modulation"
+#define QUEUE_MANAGEMENT_DEBUG 0
+
+struct proc_dir_entry *proc_folder;
+struct proc_dir_entry *modulation_proc_entry;
+static atomic_t data_queue_flag;
+
+#define USB_ALLOC_URB(a, b) usb_alloc_urb(a, b)
+#define USB_ALLOC_COHERENT(a, b, c, d) usb_alloc_coherent(a, b, c, d)
+#define USB_FREE_COHERENT(a, b, c, d) usb_free_coherent(a, b, c, d)
+#define USB_FREE_URB(a) usb_free_urb(a)
+
+//Define the duration of the Tx retry backoff timer (in milliseconds).
+# define TX_RETRY_BACKOFF_MS 10
+# define STA_QUEUE_CLEANUP_MS 5000
+//Define the duration of the Tx retry backoff timer (in jiffies).
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
+struct usb_interface *ez_usb_interface;
+
+static inline u16 get_bcd_device(const struct usb_device *udev)
+{
+	return le16_to_cpu(udev->descriptor.bcdDevice);
+}
+
+/* Ensures that MAX_TRANSFER_SIZE is even. */
+#define MAX_TRANSFER_SIZE (USB_MAX_TRANSFER_SIZE & ~1)
+
+MODULE_FIRMWARE("purelifi/li_fi_x/fpga.bit");
+
+#define urb_dev(urb) (&(urb)->dev->dev)
+
+void send_packet_from_data_queue(struct purelifi_usb *usb)
+{
+	struct sk_buff *skb = NULL;
+	unsigned long flags;
+	static u8 sidx;
+	u8 last_served_sidx;
+
+	spin_lock_irqsave(&usb->tx.lock, flags);
+	last_served_sidx = sidx;
+	do {
+		sidx = (sidx + 1) % MAX_STA_NUM;
+		if ((usb->tx.station[sidx].flag &
+					STATION_CONNECTED_FLAG)) {
+			if (!(usb->tx.station[sidx].flag &
+						STATION_FIFO_FULL_FLAG)) {
+				skb = skb_peek(&usb->tx.station
+						[sidx].data_list);
+			}
+		}
+	} while ((sidx != last_served_sidx) && (!skb));
+
+	if (skb) {
+		skb = skb_dequeue(&usb->tx.station[sidx].data_list);
+		usb_write_req_async(usb, skb->data, skb->len, USB_REQ_DATA_TX,
+				    tx_urb_complete, skb);
+		if (skb_queue_len(&usb->tx.station[sidx].data_list)
+				<= 60) {
+			block_queue(usb, usb->tx.station[sidx].mac,
+				    false);
+		}
+	}
+	spin_unlock_irqrestore(&usb->tx.lock, flags);
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
+int rx_usb_enabled;
+static void rx_urb_complete(struct urb *urb)
+{
+	int r;
+	struct purelifi_usb *usb;
+	struct purelifi_usb_rx *rx;
+	struct purelifi_usb_tx *tx;
+	const u8 *buffer;
+	static u8 fpga_link_connection_f;
+	unsigned int length;
+
+	if (!urb) {
+		pl_dev_err(purelifi_usb_dev(usb),
+			   "%s:URB is NULL.\n", __func__);
+		return;
+	} else if (!urb->context) {
+		pl_dev_err(purelifi_usb_dev(usb),
+			   "%s:!urb->context is NULL.\n", __func__);
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
+		dev_dbg_f(urb_dev(urb), "urb %p error %d\n", urb,
+			  urb->status);
+		return;
+	default:
+		dev_dbg_f(urb_dev(urb), "urb %p error %d\n", urb,
+			  urb->status);
+			goto resubmit;
+	}
+
+	buffer = urb->transfer_buffer;
+	length = (*(u32 *)(buffer + sizeof(struct rx_status))) + sizeof(u32);
+
+	rx = &usb->rx;
+	tx = &usb->tx;
+
+	if (urb->actual_length == 8) {
+		u16 status = buffer[7];//SM (buffer[6] << 8) | buffer[7];
+		u8 sidx;
+
+		pl_dev_info(&usb->intf->dev, "%s::Received status=%u\n",
+			    __func__, status
+			   );
+		pl_dev_info(&usb->intf->dev,
+			    "%s::Tx packet MAC=%x:%x:%x:%x:%x:%x\n",
+			    __func__,
+			    buffer[0],
+			    buffer[1],
+			    buffer[2],
+			    buffer[3],
+			    buffer[4],
+			    buffer[5]
+			  );
+		if (status == STATION_FIFO_ALMOST_FULL_NOT_MESSAGE) {
+			pl_dev_info(&usb->intf->dev,
+				    "FIFO full packet receipt.\n"
+				   );
+#ifdef CONFIG_PURELIFI_AP
+
+		for (sidx = 0; sidx < MAX_STA_NUM; sidx++) {
+			if (usb->tx.station[sidx].flag &
+					STATION_CONNECTED_FLAG &&
+			    !memcmp(usb->tx.station[sidx].mac, buffer,
+				    ETH_ALEN)) {
+				pl_dev_info(&usb->intf->dev,
+					    "%s:: FIFO at sidx =%d\n",
+						__func__, sidx);
+					usb->tx.station[sidx].flag |=
+						STATION_FIFO_FULL_FLAG;
+				break;
+			} else if (usb->tx.station[sidx].flag &
+					STATION_CONNECTED_FLAG) {
+				pl_dev_info(&usb->intf->dev,
+					    "st[%d].mac=%x:%x:%x:%x:%x:%x\n",
+						sidx,
+						usb->tx.station[sidx].mac[0],
+						usb->tx.station[sidx].mac[1],
+						usb->tx.station[sidx].mac[2],
+						usb->tx.station[sidx].mac[3],
+						usb->tx.station[sidx].mac[4],
+						usb->tx.station[sidx].mac[5]
+					   );
+			}
+		}
+		if (sidx == MAX_STA_NUM) {
+			pl_dev_warn(&usb->intf->dev,
+				    "%s::Station not found.\n",
+					__func__);
+		}
+#else
+		tx->mac_fifo_full = 1;
+		for (sidx = 0; sidx < MAX_STA_NUM; sidx++) {
+			usb->tx.station[sidx].flag |=
+				STATION_FIFO_FULL_FLAG;
+		}
+#endif
+	} else if (status == STATION_FIFO_ALMOST_FULL_MESSAGE) {
+		pl_dev_info(&usb->intf->dev,
+			    "FIFO full packet receipt.\n");
+#ifdef CONFIG_PURELIFI_AP
+		for (sidx = 0; sidx < MAX_STA_NUM; sidx++) {
+			if (usb->tx.station[sidx].flag &
+					STATION_CONNECTED_FLAG &&
+					!memcmp(usb->tx.station[sidx].mac,
+						buffer, ETH_ALEN)) {
+				pl_dev_info(&usb->intf->dev,
+					    "%s::Remove FIFO flag at sidx = %d\n",
+					__func__,
+					sidx
+	     );
+				usb->tx.station[sidx].flag &= 0xFD;
+				break;
+			}
+		}
+#else
+		for (sidx = 0; sidx < MAX_STA_NUM; sidx++)
+			usb->tx.station[sidx].flag &= 0xFD;
+#endif
+			send_packet_from_data_queue(usb);
+		} else if (status == STATION_CONNECT_MESSAGE) {
+			fpga_link_connection_f = 1;
+			pl_dev_info(&usb->intf->dev,
+				    "ST_CONNECT_MSG packet receipt.\n");
+		} else if (status == STATION_DISCONNECT_MESSAGE) {
+			fpga_link_connection_f = 0;
+			pl_dev_info(&usb->intf->dev,
+				    "ST_DISCONN_MSG packet receipt.\n");
+		}
+	} else {
+		if (usb->initialized && fpga_link_connection_f)
+			handle_rx_packet(usb, buffer, length);
+	}
+
+resubmit:
+	r = usb_submit_urb(urb, GFP_ATOMIC);
+	if (r)
+		dev_dbg_f(urb_dev(urb), "urb %p resubmit error %d\n", urb, r);
+}
+
+static struct urb *alloc_rx_urb(struct purelifi_usb *usb)
+{
+	struct usb_device *udev = purelifi_usb_to_usbdev(usb);
+	struct urb *urb;
+	void *buffer;
+
+	urb = USB_ALLOC_URB(0, GFP_KERNEL);
+	if (!urb)
+		return NULL;
+	buffer = USB_ALLOC_COHERENT(udev, USB_MAX_RX_SIZE, GFP_KERNEL,
+				    &urb->transfer_dma);
+	if (!buffer) {
+		USB_FREE_URB(urb);
+		return NULL;
+	}
+
+	usb_fill_bulk_urb(urb, udev, usb_rcvbulkpipe(udev, EP_DATA_IN),
+			  buffer, USB_MAX_RX_SIZE,
+			rx_urb_complete, usb);
+	urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
+
+	return urb;
+}
+
+static void free_rx_urb(struct urb *urb)
+{
+	if (!urb)
+		return;
+	USB_FREE_COHERENT(urb->dev, urb->transfer_buffer_length,
+			  urb->transfer_buffer, urb->transfer_dma);
+	USB_FREE_URB(urb);
+}
+
+static int __lf_x_usb_enable_rx(struct purelifi_usb *usb)
+{
+	int i, r;
+	struct purelifi_usb_rx *rx = &usb->rx;
+	struct urb **urbs;
+
+	pl_dev_info(&usb->intf->dev, "%s:\n", __func__);
+
+	dev_dbg_f(purelifi_usb_dev(usb), "\n");
+
+	r = -ENOMEM;
+	urbs = kcalloc(RX_URBS_COUNT, sizeof(struct urb *), GFP_KERNEL);
+	if (!urbs)
+		goto error;
+	for (i = 0; i < RX_URBS_COUNT; i++) {
+		urbs[i] = alloc_rx_urb(usb);
+		if (!urbs[i])
+			goto error;
+	}
+
+	PURELIFI_ASSERT(!irqs_disabled());
+	spin_lock_irq(&rx->lock);
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
+	return 0;
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
+		rx_usb_enabled = 1;
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
+	pl_dev_info(&usb->intf->dev, "%s\n", __func__);
+
+	spin_lock_irqsave(&rx->lock, flags);
+	urbs = rx->urbs;
+	count = rx->urbs_count;
+	spin_unlock_irqrestore(&rx->lock, flags);
+	if (!urbs)
+		return;
+
+	for (i = 0; i < count; i++) {
+		usb_kill_urb(urbs[i]);
+		free_rx_urb(urbs[i]);
+	}
+	kfree(urbs);
+
+	spin_lock_irqsave(&rx->lock, flags);
+	rx->urbs = NULL;
+	rx->urbs_count = 0;
+	spin_unlock_irqrestore(&rx->lock, flags);
+}
+
+void purelifi_usb_disable_rx(struct purelifi_usb *usb)
+{
+	struct purelifi_usb_rx *rx = &usb->rx;
+
+	pl_dev_info(&usb->intf->dev, "%s\n", __func__);
+	mutex_lock(&rx->setup_mutex);
+	__lf_x_usb_disable_rx(usb);
+	rx_usb_enabled = 0;
+	mutex_unlock(&rx->setup_mutex);
+
+	//tasklet_kill(&rx->reset_timer_tasklet);
+	//cancel_delayed_work_sync(&rx->idle_work);
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
+	struct purelifi_usb_tx *tx;
+
+	skb = (struct sk_buff *)urb->context;
+	info = IEEE80211_SKB_CB(skb);
+	/* grab 'usb' pointer before handing off the skb (since
+	 * it might be freed by purelifi_mac_tx_to_dev or mac80211)
+	 */
+	usb = &purelifi_hw_mac(info->rate_driver_data[0])->chip.usb;
+	tx = &usb->tx;
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
+		dev_dbg_f(urb_dev(urb), "urb %p error %d\n", urb,
+			  urb->status);
+		break;
+	default:
+		dev_dbg_f(urb_dev(urb), "urb %p error %d\n", urb,
+			  urb->status);
+		return;
+	}
+
+	purelifi_mac_tx_to_dev(skb, urb->status);
+	send_packet_from_data_queue(usb);
+	USB_FREE_URB(urb);
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
+	urb = USB_ALLOC_URB(0, GFP_ATOMIC);
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
+		dev_dbg_f(purelifi_usb_dev(usb), "error submit urb %p %d\n",
+			  urb, r);
+		usb_unanchor_urb(urb);
+		skb_unlink(skb, &tx->submitted_skbs);
+		goto error;
+	}
+	return 0;
+error:
+	USB_FREE_URB(urb);
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
+	if (interface_to_usbdev(usb->intf)->speed == USB_SPEED_HIGH)
+		rx->usb_packet_size = 512;
+	else
+		rx->usb_packet_size = 64;
+
+	PURELIFI_ASSERT(rx->fragment_length == 0);
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
+	usb_set_intfdata(usb->intf, NULL);
+	usb_put_intf(usb->intf);
+	/* FIXME: usb_interrupt, usb_tx, usb_rx? */
+}
+
+const char *speed(enum usb_device_speed speed)
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
+		pl_dev_err(purelifi_usb_dev(usb),
+			   "couldn't reset configuration. Error %d\n",
+				r);
+		return r;
+	}
+	return 0;
+}
+
+static int send_vendor_request(struct usb_device *udev, int request,
+			       unsigned char *buffer, int buffer_size)
+{
+	return usb_control_msg(udev,
+			usb_rcvctrlpipe(udev, 0),
+			request,
+			0xC0,
+			0,
+			0,
+			buffer,
+			buffer_size,
+			1000
+			);
+}
+
+static int send_vendor_command(struct usb_device *udev, int request,
+			       unsigned char *buffer, int buffer_size)
+{
+	return usb_control_msg(udev,
+			usb_sndctrlpipe(udev, 0),
+			request,
+			0x40,
+			0,
+			0,
+			buffer,
+			buffer_size,
+			1000
+			);
+}
+
+static int download_fpga(struct usb_interface *intf)
+{
+	int r, actual_length;
+	struct firmware *fw = NULL;
+	unsigned char *fw_data;
+	unsigned char fpga_setting[2];
+	unsigned char fpga_state[9];
+	const char *fw_name;//[] = "purelifi/li_fi_x/fpga.bit";
+	int fw_data_i;
+	unsigned char *fpga_dmabuff;
+	int blk_tran_len = 16384;
+
+	fpga_dmabuff = NULL;
+
+	if ((le16_to_cpu(interface_to_usbdev(intf)->descriptor.idVendor) ==
+			 PURELIFI_X_VENDOR_ID_0) &&
+			 (le16_to_cpu(interface_to_usbdev
+			 (intf)->descriptor.idProduct) ==
+			  PURELIFI_X_PRODUCT_ID_0)) {
+		fw_name = "purelifi/li_fi_x/fpga.bit";
+		pl_dev_info(&intf->dev,
+			    "%s::bit file for X selected.\n", __func__);
+	} else if ((PURELIFI_XC_VENDOR_ID_0 ==
+				le16_to_cpu(interface_to_usbdev
+				(intf)->descriptor.idVendor)) &&
+				(le16_to_cpu(interface_to_usbdev
+					     (intf)->descriptor.idProduct) ==
+				PURELIFI_XC_PRODUCT_ID_0)) {
+		fw_name = "purelifi/li_fi_x/fpga_xc.bit";
+		pl_dev_info(&intf->dev,
+			    "%s::bit filefor XC selected.\n", __func__);
+	} else {
+		r = -EINVAL;
+		goto error;
+	}
+
+	r = request_firmware((const struct firmware **)&fw, fw_name,
+			     &intf->dev);
+	if (r) {
+		pl_dev_err(&intf->dev, "%s::request_firmware failed.(%d)\n",
+			   __func__, r);
+		goto error;
+	}
+	/* WARNING: unnecessary cast may hide bugs
+	 */
+	fpga_dmabuff = kmalloc(2, GFP_KERNEL);
+
+	if (!fpga_dmabuff) {
+		r = -ENOMEM;
+		goto error_free_fw;
+	}
+	send_vendor_request(interface_to_usbdev(intf),
+			    0x33,
+			    fpga_dmabuff,//fpga_setting,
+			    sizeof(fpga_setting)
+			   );
+
+	memcpy(fpga_setting, fpga_dmabuff, 2);
+	kfree(fpga_dmabuff);
+
+	send_vendor_command(interface_to_usbdev(intf),
+			    0x34,
+			    NULL,
+			    0
+			  );
+
+	if (fpga_setting[0] != 6) {
+		pl_dev_err(&intf->dev,
+			   "%s::fpga_setting[0] wrong.\n", __func__);
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
+		fw_data = kmalloc(blk_tran_len, GFP_KERNEL);
+
+		memcpy(fw_data, &fw->data[fw_data_i], blk_tran_len);
+		for (tbuf_idx = 0; tbuf_idx < blk_tran_len; tbuf_idx++) {
+			fw_data[tbuf_idx] =
+				((fw_data[tbuf_idx] & 128) >> 7) |
+				((fw_data[tbuf_idx] &  64) >> 5) |
+				((fw_data[tbuf_idx] &  32) >> 3) |
+				((fw_data[tbuf_idx] &  16) >> 1) |
+				((fw_data[tbuf_idx] &   8) << 1) |
+				((fw_data[tbuf_idx] &   4) << 3) |
+				((fw_data[tbuf_idx] &   2) << 5) |
+				((fw_data[tbuf_idx] &   1) << 7);
+		}
+		r = usb_bulk_msg(interface_to_usbdev(intf),
+				 usb_sndbulkpipe(interface_to_usbdev(intf),
+						 fpga_setting[0] & 0xFF),
+				 fw_data,
+				 blk_tran_len,
+				 &actual_length,
+				 2000
+				);
+
+		if (r) {
+			pl_dev_err(&intf->dev, "%s::bulk msg failed. (%d)\n",
+				   __func__, r
+				  );
+		}
+
+		kfree(fw_data);
+
+		fw_data_i += blk_tran_len;
+	}
+
+	fpga_dmabuff = NULL;
+	fpga_dmabuff = kmalloc(9, GFP_KERNEL);
+	if (!fpga_dmabuff) {
+		r = -ENOMEM;
+		goto error_free_fw;
+	}
+	memset(fpga_dmabuff, 0xFF, 9);
+
+	send_vendor_request(interface_to_usbdev(intf),
+			    0x30,
+			    fpga_dmabuff,//fpga_state,
+			    sizeof(fpga_state)
+			   );
+	pl_dev_info(&intf->dev,
+		    "fpga_status %x %x %x %x %x %x %x %x %x\n",
+		    fpga_dmabuff[0],
+		    fpga_dmabuff[1],
+		    fpga_dmabuff[2],
+		    fpga_dmabuff[3],
+		    fpga_dmabuff[4],
+		    fpga_dmabuff[5],
+		    fpga_dmabuff[6],
+		    fpga_dmabuff[7],
+		    fpga_dmabuff[8],
+		    __func__
+		   );
+	if (fpga_dmabuff[0] != 0) {
+		r = -EINVAL;
+		kfree(fpga_dmabuff);
+		goto error_free_fw;
+	}
+
+	kfree(fpga_dmabuff);
+
+	send_vendor_command(interface_to_usbdev(intf),
+			    0x35,
+			    NULL,
+			    0
+			   );
+
+	//wait because the EZ-USB FW also waits
+	msleep(200);
+
+error_free_fw:
+	release_firmware(fw);
+error:
+	return r;
+}
+
+static int download_XL_FW(struct usb_interface *intf)
+{
+	int r;
+
+	struct firmware *fw_packed = NULL;
+	int step;
+	u8 *buf;
+	u32 size, nmb_of_control_packets, i, no_of_files;
+	u32 tot_size, start_addr;
+	const char *fw_pack;
+
+	r = send_vendor_command(interface_to_usbdev(intf),
+				0x80,
+				NULL,
+				0
+				);
+	msleep(100);
+	// Code for single pack file download
+	fw_pack = "purelifi/li_fi_x/Li-Fi-XL.bin";
+	r = request_firmware((const struct firmware **)&fw_packed, fw_pack,
+			     &intf->dev);
+	if (r) {
+		pl_dev_err(&intf->dev, "%s::request_firmware failed.(%d)\n",
+			   __func__, r
+			   );
+		goto error;
+	}
+	no_of_files = *(u32 *)&fw_packed->data[0];
+	tot_size = fw_packed->size;
+	pl_dev_err(&intf->dev,
+		   "XL Firmware file(%d, %d)\n", no_of_files, tot_size);
+
+	buf = kmalloc(64, GFP_KERNEL);
+	r = -ENOMEM;
+	if (!buf)
+		goto error;
+	memset(buf, 0, 64);
+
+	for (step = 0; step < no_of_files; step++) {
+		buf[0] = step;
+		r = send_vendor_command(interface_to_usbdev(intf),
+					0x82,
+					buf,
+					64
+					);
+
+		if (step < no_of_files - 1)
+			size = *(u32 *)&fw_packed->data[4 + ((step + 1) * 4)]
+				- *(u32 *)&fw_packed->data[4 + (step) * 4];
+		else
+			size = tot_size -
+				*(u32 *)&fw_packed->data[4 + (step) * 4];
+
+		start_addr = *(u32 *)&fw_packed->data[4 + (step * 4)];
+
+		if ((size % 64) && step < 2)
+			size += 64 - size % 64;
+		nmb_of_control_packets = size / 64;
+
+		for (i = 0; i < nmb_of_control_packets; i++) {
+			memcpy(buf,
+			       &fw_packed->data[start_addr + (i * 64)], 64);
+			r = send_vendor_command(interface_to_usbdev(intf),
+						0x81,
+						buf,
+						64
+					       );
+		}
+	  dev_info(&intf->dev,
+		   "%s::Downloading firmware step %d,r=%d size %d\n",
+			  __func__, step, r, size);
+	}
+	release_firmware(fw_packed);
+	kfree(buf);
+	// Code for single pack file download ends
+	//fw download finish
+	r = send_vendor_command(interface_to_usbdev(intf),
+				0x83,
+				NULL,
+				0
+			       );
+	dev_info(&intf->dev, "download_fpga (4), r=%d\n", r);
+error:
+	return r;
+}
+
+struct flash_t {
+	unsigned char enabled;
+	unsigned int sector_size;
+	unsigned int sectors;
+	unsigned char ec;
+};
+
+static void pretty_print_mac(struct usb_interface *intf, char *serial_number,
+			     unsigned char *hw_address
+			    )
+{
+	unsigned char i;
+
+	for (i = 0; i < ETH_ALEN; i++)
+		pl_dev_info(&intf->dev, "%s::hw_address[%d]=%x\n",
+			    __func__, i, hw_address[i]);
+}
+
+static int upload_mac_and_serial_number(struct usb_interface *intf,
+					unsigned char *hw_address,
+					unsigned char *serial_number)
+{
+#ifdef LOAD_MAC_AND_SERIAL_FROM_FILE
+	struct firmware *fw = NULL;
+	int r;
+	char *mac_file_name = "purelifi/li_fi_x/mac.ascii";
+
+	r = request_firmware((const struct firmware **)&fw, mac_file_name,
+			     &intf->dev);
+	if (r) {
+		pl_dev_err(&intf->dev, "%s::request_firmware fail.(%d)\n",
+			   __func__, r);
+		goto ERROR;
+	}
+	pl_dev_info(&intf->dev, "%s::fw->data=%s\n", __func__, fw->data);
+	r = sscanf(fw->data,
+		   "%hhx:%hhx:%hhx:%hhx:%hhx:%hhx",
+			&hw_address[0],
+			&hw_address[1],
+			&hw_address[2],
+			&hw_address[3],
+			&hw_address[4],
+			&hw_address[5]);
+	if (r != 6) {
+		pl_dev_err(&intf->dev, "%s::fw_dw usage :args fail.(%d)\n",
+			   __func__, r);
+		goto ERROR;
+	}
+	release_firmware(fw);
+	char *serial_file_name = "purelifi/li_fi_x/serial.ascii";
+
+	r = request_firmware((const struct firmware **)&fw,
+			     serial_file_name,
+			&intf->dev);
+	if (r) {
+		pl_dev_err(&intf->dev, "%s::request_firmware fail.(%d)\n",
+			   __func__, r);
+		goto ERROR;
+	}
+	pl_dev_info(&intf->dev, "%s::fw->data=%s\n", __func__, fw->data);
+	strcpy(serial_number, fw->data);
+	pl_dev_info(&intf->dev, "%s::serial_number=%s\n", __func__,
+		    serial_number);
+	release_firmware(fw);
+	pretty_print_mac(intf, serial_number, hw_address);
+ERROR:
+	return r;
+#endif
+#ifdef LOAD_MAC_AND_SERIAL_FROM_FLASH
+	struct flash_t flash;
+	unsigned char *flash_sector_buf;
+	unsigned int sector_index;
+
+#define FLASH_EC_BUSY 3
+	do {
+		unsigned char buf[8];
+
+		msleep(200);
+
+		send_vendor_request(interface_to_usbdev(intf),
+				    0x40,
+				    buf,
+				    sizeof(buf)
+				   );
+		flash.enabled = buf[0] & 0xFF;
+
+		if (flash.enabled) {
+			flash.sectors = ((buf[6] & 255) << 24) |
+				((buf[5] & 255) << 16) |
+				((buf[4] & 255) <<  8) |
+				(buf[3] & 255);
+			flash.sector_size =
+				((buf[2] & 255) << 8) | (buf[1] & 255);
+		} else {
+			flash.sectors = 0;
+			flash.sector_size = 0;
+		}
+
+		if (flash.sector_size & 0x8000)
+			flash.sector_size = 1 << (flash.sector_size & 0x7FFF);
+
+		flash.ec = buf[7] & 0xFF;
+	} while (flash.ec == FLASH_EC_BUSY);
+
+	flash_sector_buf = kmalloc(flash.sector_size,
+				   GFP_KERNEL);
+	if (!flash_sector_buf)
+		return -ENOMEM;
+
+	if (!flash.enabled) {
+		pl_dev_err(&intf->dev, "%s:Flash is not enabled", __func__);
+		return -EINVAL;
+	}
+
+	read_flash(intf, &flash, 0, flash_sector_buf);
+	sector_index = *((unsigned int *)flash_sector_buf);
+
+	read_flash(intf, &flash, sector_index, flash_sector_buf);
+	memcpy(hw_address, flash_sector_buf, ETH_ALEN);
+	strncpy(serial_number, &flash_sector_buf[ETH_ALEN], 256);
+
+	pretty_print_mac(intf, serial_number, hw_address);
+	kfree(flash_sector_buf);
+	return 0;
+#endif
+#ifdef LOAD_MAC_AND_SERIAL_FROM_EP0
+#define USB_MAC_VENDOR_REQUEST 0x36
+#define USB_SERIAL_NUMBER_VENDOR_REQUEST 0x37
+#define USB_FIRMWARE_VERSION_VENDOR_REQUEST 0x39
+#define SERIAL_NUMBER_LENGTH 14
+	int r = 0;
+	unsigned char *dma_buffer = NULL;
+	unsigned long long firmware_version;
+
+	dma_buffer = kmalloc(14, GFP_KERNEL);
+	if (!dma_buffer) {
+		r = -ENOMEM;
+		goto error;
+	}
+	send_vendor_request(interface_to_usbdev(intf),
+			    USB_MAC_VENDOR_REQUEST,
+			    dma_buffer,//hw_address_dma_buffer,
+			    ETH_ALEN
+			   );
+	memcpy(hw_address, dma_buffer, ETH_ALEN);
+
+	send_vendor_request(interface_to_usbdev(intf),
+			    USB_SERIAL_NUMBER_VENDOR_REQUEST,
+			    dma_buffer,//serial_number_dma_buffer,
+			    14
+			   );
+	send_vendor_request(interface_to_usbdev(intf),
+			    USB_SERIAL_NUMBER_VENDOR_REQUEST,
+			    dma_buffer,//serial_number_dma_buffer,
+			    14
+			   );
+	memcpy(serial_number, dma_buffer, SERIAL_NUMBER_LENGTH);
+
+	memset(dma_buffer, 0x00, 14);
+	send_vendor_request(interface_to_usbdev(intf),
+			    USB_FIRMWARE_VERSION_VENDOR_REQUEST,
+			    (unsigned char *)dma_buffer,
+			    8
+			   );
+	memcpy(&firmware_version, dma_buffer, sizeof(unsigned long long));
+	dev_info(&intf->dev, "Firmware Version: %llu, Revision: 16418\n",
+		 firmware_version);
+	kfree(dma_buffer);
+
+	pretty_print_mac(intf, serial_number, hw_address);
+error:
+	return r;
+#endif
+}
+
+static void get_usb_req(struct usb_device *udev, const u8 *buffer,
+			int buffer_len, enum usb_req_enum_t usb_req_id,
+			struct usb_req_t *usb_req)
+{
+	u8 *buffer_dst_p = usb_req->buf;
+	const u8 *buffer_src_p = buffer;
+	u32 payload_len_nw = TO_NETWORK((buffer_len + FCS_LEN));
+
+	usb_req->id = usb_req_id;
+	usb_req->len  = 0;
+
+	// Copy buffer length into the transmitted buffer, as it is important
+	// for the Rx MAC to know its exact length.
+	if (usb_req->id == USB_REQ_BEACON_WR) {
+		memcpy(buffer_dst_p, &payload_len_nw, sizeof(payload_len_nw));
+		buffer_dst_p += sizeof(payload_len_nw);
+		usb_req->len += sizeof(payload_len_nw);
+	}
+
+	memcpy(buffer_dst_p, buffer_src_p, buffer_len);
+	buffer_dst_p += buffer_len;
+	buffer_src_p += buffer_len;
+	usb_req->len +=  buffer_len;
+
+	// Set the FCS_LEN (4) bytes as 0 for CRC checking.
+	memset(buffer_dst_p, 0, FCS_LEN);
+	buffer_dst_p += FCS_LEN;
+	usb_req->len += FCS_LEN;
+
+	// Round the packet to be transmitted to 4 bytes.
+	if (usb_req->len % PURELIFI_BYTE_NUM_ALIGNMENT) {
+		memset(buffer_dst_p, 0, PURELIFI_BYTE_NUM_ALIGNMENT -
+				(usb_req->len % PURELIFI_BYTE_NUM_ALIGNMENT));
+		buffer_dst_p += PURELIFI_BYTE_NUM_ALIGNMENT -
+			(usb_req->len % PURELIFI_BYTE_NUM_ALIGNMENT);
+		usb_req->len += PURELIFI_BYTE_NUM_ALIGNMENT -
+			(usb_req->len % PURELIFI_BYTE_NUM_ALIGNMENT);
+	}
+
+	usb_req->id = TO_NETWORK(usb_req->id);
+	usb_req->len = TO_NETWORK(usb_req->len);
+}
+
+int usb_write_req_async(struct purelifi_usb *usb, const u8 *buffer,
+			int buffer_len, enum usb_req_enum_t usb_req_id,
+		usb_complete_t complete_fn,
+		void *context)
+{
+	int r;
+	struct usb_device *udev = interface_to_usbdev(ez_usb_interface);
+	struct urb *urb = usb_alloc_urb(0, GFP_ATOMIC);
+
+	usb_fill_bulk_urb(urb,
+			  udev,
+			  usb_sndbulkpipe(udev, EP_DATA_OUT),
+			  (void *)buffer,
+			  buffer_len,
+			  complete_fn,
+			  context
+			);
+
+	r = usb_submit_urb(urb, GFP_ATOMIC);
+
+	if (r)
+		pl_dev_err(&udev->dev, "%s::r = %d\n", __func__, r);
+
+	return r;
+}
+
+int usb_write_req(const u8 *buffer, int buffer_len,
+		  enum usb_req_enum_t usb_req_id)
+{
+	int r;
+	int actual_length;
+	int usb_bulk_msg_len;
+	unsigned char *dma_buffer = NULL;
+	struct usb_device *udev = interface_to_usbdev(ez_usb_interface);
+	struct usb_req_t usb_req;
+
+	get_usb_req(udev, buffer, buffer_len, usb_req_id, &usb_req);
+	usb_bulk_msg_len = sizeof(usb_req.id) + sizeof(usb_req.len) +
+		TO_HOST(usb_req.len);
+
+	dma_buffer = kzalloc(usb_bulk_msg_len, GFP_KERNEL);
+	if (!dma_buffer) {
+		r = -ENOMEM;
+		goto error;
+	}
+	memcpy(dma_buffer, &usb_req, usb_bulk_msg_len);
+
+	r = usb_bulk_msg(udev,
+			 usb_sndbulkpipe(udev, EP_DATA_OUT),
+			 dma_buffer,//&usb_req,
+			 usb_bulk_msg_len,
+			 &actual_length,
+			 USB_BULK_MSG_TIMEOUT_MS
+			);
+	kfree(dma_buffer);
+error:
+	if (r) {
+		pl_dev_err(&udev->dev, "%s::usb_bulk_msg unsuccesful.(%d)\n",
+			   __func__, r);
+	}
+	return r;
+}
+
+static void slif_data_plane_sap_timer_callb(struct timer_list *t)
+{
+	struct purelifi_usb *usb = from_timer(usb, t, tx.tx_retry_timer);
+
+	send_packet_from_data_queue(usb);
+	usb->tx.tx_retry_timer.expires = jiffies + TX_RETRY_BACKOFF_JIFF;
+	timer_setup(&usb->tx.tx_retry_timer,
+		    slif_data_plane_sap_timer_callb, 0);
+	add_timer(&usb->tx.tx_retry_timer);
+}
+
+#if QUEUE_MANAGEMENT_DEBUG
+static void tx_station_pretty_print(struct purelifi_usb *usb)
+{
+	int sidx;
+	const char *heading =
+		" | Queue | Heartbeat | FIFO full | Connected | MAC\n"
+	pl_dev_info(&usb->intf->dev, heading);
+	for (sidx = 0; sidx < MAX_STA_NUM; sidx++) {
+		pl_dev_info(&usb->intf->dev,
+			    " |   %d   |     %d     |     %d      |     %d  |"
+			    sidx,
+			    ((usb->tx.station[sidx].flag &
+			    STATION_HEARTBEAT_FLAG) != 0),
+			    ((usb->tx.station[sidx].flag &
+			    STATION_FIFO_FULL_FLAG) != 0),
+			    ((usb->tx.station[sidx].flag &
+			    STATION_CONNECTED_FLAG) != 0),
+		pl_dev_info(&usb->intf->dev,
+			    " %hhx:%hhx:%hhx:%hhx:%hhx:%hhx\n",
+			    usb->tx.station[sidx].mac[0] & 0xFF,
+			    usb->tx.station[sidx].mac[1] & 0xFF,
+			    usb->tx.station[sidx].mac[2] & 0xFF,
+			    usb->tx.station[sidx].mac[3] & 0xFF,
+			    usb->tx.station[sidx].mac[4] & 0xFF,
+			    usb->tx.station[sidx].mac[5] & 0xFF
+			   );
+	}
+}
+#endif
+
+static void sta_queue_cleanup_timer_callb(struct timer_list *t)
+{
+	struct purelifi_usb *usb = from_timer(usb, t, sta_queue_cleanup);
+	int sidx;
+
+	for (sidx = 0; sidx < MAX_STA_NUM - 1; sidx++) {
+		if (usb->tx.station[sidx].flag & STATION_CONNECTED_FLAG) {
+			if (usb->tx.station[sidx].flag &
+					STATION_HEARTBEAT_FLAG) {
+				usb->tx.station[sidx].flag ^=
+					STATION_HEARTBEAT_FLAG;
+			} else {
+				memset(usb->tx.station[sidx].mac, 0,
+				       ETH_ALEN);
+				usb->tx.station[sidx].flag = 0;
+			}
+		}
+	}
+	usb->sta_queue_cleanup.expires = jiffies + STA_QUEUE_CLEANUP_JIFF;
+	timer_setup(&usb->sta_queue_cleanup,
+		    sta_queue_cleanup_timer_callb,
+			0);
+	add_timer(&usb->sta_queue_cleanup);
+}
+
+static enum unit_type_t get_unit_type(char *serial_number,
+				      struct usb_interface *intf)
+{
+#ifdef CONFIG_PURELIFI_AP
+	pl_dev_info(&intf->dev, "%s::Unit-type is an AP!\n", __func__);
+	return AP;
+#else
+	pl_dev_info(&intf->dev, "%s::Unit-type is an STA!\n", __func__);
+	return STA;
+#endif
+}
+
+char usr_input[8] = {0};
+
+static ssize_t purelifi_store_frequency(struct device *dev,
+					struct device_attribute *attr,
+					const char *buf,
+					size_t len)
+{
+	int i, r, row, col, predivider, feedback_divider, output_div_0;
+	int output_div_1, output_div_2, clkout3_phase;
+	char values[6][4] = {{0}, {0} };
+	bool valid = false;
+	int rv = 0;
+
+	row = 0; col = 0;
+	for (i = 0; i < min(len, sizeof(values)); i++) {
+		values[row][col] = buf[i];
+		col++;
+		if (buf[i] == 0x20) {
+			row++;
+			col = 0;
+		} else if (buf[i] == 0x0A) {
+			if (row == 5 && col > 0) {
+				rv = sscanf((char *)&values[0][0],
+					    "%d", &predivider);
+				if (rv != 1)
+					valid = false;
+				rv = sscanf((char *)&values[1][0],
+					    "%d", &feedback_divider);
+				if (rv != 1)
+					valid = false;
+				rv = sscanf((char *)&values[2][0],
+					    "%d", &output_div_0);
+				if (rv != 1)
+					valid = false;
+				rv = sscanf((char *)&values[3][0],
+					    "%d", &output_div_1);
+				if (rv != 1)
+					valid = false;
+				rv = sscanf((char *)&values[4][0],
+					    "%d", &output_div_2);
+				if (rv != 1)
+					valid = false;
+				rv = sscanf((char *)&values[5][0],
+					    "%d", &clkout3_phase);
+				if (rv != 1)
+					valid = false;
+				valid = true;
+
+				break;
+			}
+		}
+	}
+
+	if (valid) {
+		usr_input[0] = (char)predivider;
+		usr_input[1] = (char)feedback_divider;
+		usr_input[2] = (char)output_div_0;
+		usr_input[3] = (char)output_div_1;
+		usr_input[4] = (char)output_div_2;
+		usr_input[5] = (char)clkout3_phase;
+		pl_dev_err(dev,
+			   "options IP_DIV: %d VCO_MULT: %d OP_DIV_PHY: %d",
+			    usr_input[0], usr_input[1], usr_input[2]);
+		pl_dev_err(dev,
+			   "OP_DIV_CPU: %d OP_DIV_USB: %d CLK3_PH: %d\n",
+			   usr_input[3], usr_input[4], usr_input[5]);
+		r = usb_write_req((const u8 *)&usr_input[0],
+				  sizeof(usr_input), USB_REQ_SET_FREQ);
+	} else {
+		pl_dev_err(dev, "Your options are invalid\n");
+	}
+
+	return len;
+}
+
+static ssize_t purelifi_show_sysfs(struct device *dev,
+				   struct device_attribute *attr,
+				   char *buf)
+{
+	return 0;
+}
+
+static const struct device_attribute purelifi_attr_frequency = {
+	  .attr = {.name = "frequency", .mode = (0666)},
+	  .show = purelifi_show_sysfs,
+	  .store = purelifi_store_frequency,
+};
+
+static ssize_t purelifi_store_modulation(struct device *dev,
+					 struct device_attribute *attr,
+					 const char *buf,
+					 size_t len)
+{
+	int rate, i;
+	char usr_input[8] = {0, 0, 0, 0, 0, 0, 0, 0};
+	int rv = 0;
+
+	for (i = 0; i < min(len, sizeof(usr_input)); i++)
+		usr_input[i] = buf[i];
+	usr_input[7] = 0;
+	rv = sscanf((char *)&usr_input[0], "%d", &rate);
+	if (rv != 1)
+		return 0;
+	purelifi_chip_set_rate(NULL, rate);
+	return len;
+}
+
+static ssize_t purelifi_show_modul(struct device *dev,
+				   struct device_attribute *attr,
+				   char *buf)
+{
+	return 0;
+}
+
+static struct device_attribute purelifi_attr_modulation = {
+	.attr = {.name = "modulation", .mode = (0666)},
+	.show = purelifi_show_modul,
+	.store = purelifi_store_modulation,
+};
+
+static void create_config(struct usb_interface *intf)
+{
+	struct device *dev;
+
+	dev = &intf->dev;
+	if (device_create_file(dev, &purelifi_attr_modulation)) {
+		pl_dev_err(&intf->dev,
+			   "failed to create modulation sysfs entry\n");
+		return;
+	}
+	if (device_create_file(dev, &purelifi_attr_frequency)) {
+		device_remove_file(dev, &purelifi_attr_modulation);
+		pl_dev_err(&intf->dev,
+			   "failed to create frequency sysfs entry\n");
+	}
+}
+
+static int probe(struct usb_interface *intf,
+		 const struct usb_device_id *id)
+{
+	int r = 0;
+	struct purelifi_usb *usb;
+	struct purelifi_chip *chip;
+	struct ieee80211_hw *hw = NULL;
+	static unsigned char hw_address[ETH_ALEN];
+	static unsigned char serial_number[256];
+	unsigned int i;
+
+	ez_usb_interface = intf;
+
+	create_config(intf);
+	hw = purelifi_mac_alloc_hw(intf);
+
+	if (!hw) {
+		r = -ENOMEM;
+		goto error;
+	}
+
+	chip = &purelifi_hw_mac(hw)->chip;
+	usb = &chip->usb;
+
+	r = upload_mac_and_serial_number(intf, hw_address, serial_number);
+	if (r) {
+		pl_dev_err(&intf->dev,
+			   "%s:MAC and Serial upload failed%d\n",
+				__func__, r);
+	} else {
+		pl_dev_info(&intf->dev,
+			    "%s:MAC and Serial upload succeeded%d\n",
+				__func__, r);
+	}
+	chip->unit_type = get_unit_type(serial_number, intf);
+
+	r = purelifi_mac_preinit_hw(hw, hw_address);
+	if (r) {
+		dev_dbg_f(&intf->dev, "init mac,line %d Error %d\n",
+			  __LINE__, r);
+		goto error;
+	}
+
+	r = ieee80211_register_hw(hw);
+	if (r) {
+		dev_dbg_f(&intf->dev, "register device Error%d\n", r);
+		goto error;
+	}
+	pl_dev_info(&intf->dev, "%s\n", wiphy_name(hw->wiphy));
+
+	if ((le16_to_cpu(interface_to_usbdev(intf)->descriptor.idVendor) ==
+				PURELIFI_XL_VENDOR_ID_0) &&
+			(le16_to_cpu(interface_to_usbdev(intf)->
+				     descriptor.idProduct) ==
+				PURELIFI_XL_PRODUCT_ID_0)) {
+		r = download_XL_FW(intf);
+	} else {
+		r = download_fpga(intf);
+	}
+	if (r != 0) {
+		dev_err(&intf->dev, "%s:FPGA download failure.(%d)\n",
+			__func__, r);
+		goto error;
+	} else {
+		dev_info(&intf->dev, "%s::FPGA download success.\n",
+			 __func__);
+	}
+	usb->tx.mac_fifo_full = 0;
+	spin_lock_init(&usb->tx.lock);
+
+	msleep(200);
+	r = purelifi_usb_init_hw(usb);
+	if (r < 0) {
+		pl_dev_info(&intf->dev, "%s::usb_init_hw fail (%d)\n",
+			    __func__, r);
+		goto error;
+	} else {
+		pl_dev_info(&intf->dev, "%s::usb_init_hw success (%d)\n",
+			    __func__, r);
+	}
+
+	msleep(200);
+	r = purelifi_chip_switch_radio_on(chip);
+	if (r < 0) {
+		pl_dev_info(&intf->dev,
+			    "%s::chip_switch_radio_on failed (%d)\n",
+				__func__, r);
+		goto error;
+	} else {
+		pl_dev_info(&intf->dev,
+			    "%s::chip_switch_radio_on success (%d)\n",
+				__func__, r);
+	}
+
+	msleep(200);
+	r = purelifi_chip_set_rate(chip, 8);
+	if (r < 0) {
+		pl_dev_info(&intf->dev,
+			    "%s::purelifi_chip_set_rate fail (%d)\n",
+				__func__, r);
+		goto error;
+	} else {
+		pl_dev_info(&intf->dev,
+			    "%s::purelifi_chip_set_rate succeeded.\n",
+				__func__);
+	}
+
+	msleep(200);
+	r = usb_write_req(hw_address, ETH_ALEN, USB_REQ_MAC_WR);
+	if (r < 0) {
+		pl_dev_info(&intf->dev,
+			    "%s::USB_REQ_MAC_WR failure. (%d)\n",
+				__func__, r);
+		goto error;
+	} else {
+		pl_dev_info(&intf->dev,
+			    "%s::USB_REQ_MAC_WR success. (%d)\n",
+				__func__, r);
+	}
+	purelifi_chip_enable_rxtx(chip);
+
+	//Initialise the data plane Tx queue.
+	atomic_set(&data_queue_flag, 1);
+	for (i = 0; i < MAX_STA_NUM; i++) {
+		skb_queue_head_init(&usb->tx.station[i].data_list);
+		usb->tx.station[i].flag = 0;
+	}
+	usb->tx.station[STA_BROADCAST_INDEX].flag |=
+		STATION_CONNECTED_FLAG;
+	for (i = 0; i < ETH_ALEN; i++)
+		usb->tx.station[STA_BROADCAST_INDEX].mac[i] = 0xFF;
+	atomic_set(&data_queue_flag, 0);
+
+	timer_setup(&usb->tx.tx_retry_timer,
+		    slif_data_plane_sap_timer_callb, 0);
+	usb->tx.tx_retry_timer.expires = jiffies + TX_RETRY_BACKOFF_JIFF;
+	add_timer(&usb->tx.tx_retry_timer);
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
+	pl_dev_info(&intf->dev, "%s\n", __func__);
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
+	del_timer(&usb->tx.tx_retry_timer);
+	del_timer(&usb->sta_queue_cleanup);
+
+	dev_dbg_f(purelifi_usb_dev(usb), "\n");
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
+	device_remove_file(&intf->dev, &purelifi_attr_modulation);
+	device_remove_file(&intf->dev, &purelifi_attr_frequency);
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
+		pl_dev_warn(purelifi_usb_dev(usb),
+			    "Device resume fail error %d. Retry...\n",
+				r);
+		if (usb->was_running)
+			set_bit(PURELIFI_DEVICE_RUNNING, &mac->flags);
+		usb_queue_reset_device(usb->intf);
+		return;
+	}
+
+	if (mac->type != NL80211_IFTYPE_UNSPECIFIED) {
+		r = purelifi_restore_settings(mac);
+		if (r < 0) {
+			dev_dbg(purelifi_usb_dev(usb),
+				"restore error, %d\n", r);
+			return;
+		}
+	}
+}
+
+static void purelifi_usb_stop(struct purelifi_usb *usb)
+{
+	pl_dev_info(&usb->intf->dev, "%s\n", __func__);
+
+	purelifi_op_stop(purelifi_usb_to_hw(usb));
+
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
+	pl_dev_info(&intf->dev, "%s\n", __func__);
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
+	mutex_lock(&mac->chip.mutex);
+	return 0;
+}
+
+static int post_reset(struct usb_interface *intf)
+{
+	struct ieee80211_hw *hw = usb_get_intfdata(intf);
+	struct purelifi_mac *mac;
+	struct purelifi_usb *usb;
+
+	pl_dev_info(&intf->dev, "%s\n", __func__);
+	if (!hw || intf->condition != USB_INTERFACE_BOUND)
+		return 0;
+
+	mac = purelifi_hw_mac(hw);
+	usb = &mac->chip.usb;
+
+	mutex_unlock(&mac->chip.mutex);
+
+	if (usb->was_running)
+		purelifi_usb_resume(usb);
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
+
+	if (!pl || !purelifi_usb_dev(pl))
+		return -ENODEV;
+	if (pl->initialized == 0)
+		return 0;
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
+#else
+
+#define suspend NULL
+#define resume  NULL
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
+	.suspend        = suspend,
+	.resume         = resume,
+	.disable_hub_initiated_lpm = 1,
+};
+
+struct workqueue_struct *purelifi_workqueue;
+
+static int modulation_open(struct inode *inode_p, struct file *file_p)
+{
+	return 0;
+}
+
+static ssize_t modulation_read(struct file *file_p,
+			       char __user *user_p,
+		size_t offset, loff_t *off_p)
+{
+	return 0;
+}
+
+ssize_t modulation_write(struct file *file_p,
+			 const char __user *buffer,
+		size_t count, loff_t *actual_data_written)
+{
+	int rate;
+	char usr_input[8] = {0, 0, 0, 0, 0, 0, 0, 0};
+	int rv = 0;
+
+	if (copy_from_user(usr_input, buffer, min(count, sizeof(usr_input))))
+		return -EFAULT;
+	usr_input[7] = 0;
+	rv = sscanf((char *)&usr_input[0], "%d", &rate);
+	if (rv != 1)
+		return 0;
+	purelifi_chip_set_rate(NULL, rate);
+	return count;
+}
+
+static const struct proc_ops  modulation_fops = {
+	.proc_open  = modulation_open,
+	.proc_read  = modulation_read,
+	.proc_write = modulation_write
+};
+
+static int create_proc_entry_e(struct proc_dir_entry *entry,
+			       size_t size,
+			       mode_t mode,
+			       const struct proc_ops *fops,
+			       const char *entry_name,
+			       struct proc_dir_entry *parent
+			     )
+{
+	entry = proc_create(entry_name, mode, parent, fops);
+	if (!(entry))
+		return -ENOMEM;
+	return 0;
+}
+
+static int __init usb_init(void)
+{
+	int r;
+
+	proc_folder = proc_mkdir(PROC_FOLDER, NULL);
+	if (!proc_folder) {
+		pr_err("Error creating proc folder.\n");
+		r = -ENOMEM;
+		goto error;
+	}
+
+	r = create_proc_entry_e(modulation_proc_entry, sizeof(u32), 0666,
+				&modulation_fops, MODULATION_FILENAME,
+				proc_folder);
+	if (r)
+		goto remove_proc_dir;
+
+	purelifi_workqueue = create_singlethread_workqueue(driver.name);
+	if (!purelifi_workqueue) {
+		pr_err("%s couldn't create workqueue\n",
+		       driver.name);
+		r = -ENOMEM;
+		goto remove_modulation_proc_file;
+	}
+
+	r = usb_register(&driver);
+	if (r) {
+		destroy_workqueue(purelifi_workqueue);
+		pr_err("%s usb_register() failed. Error  %d\n",
+		       driver.name, r);
+		return r;
+	}
+
+	pr_debug("%s:Initialized\n", driver.name);
+	return 0;
+
+remove_modulation_proc_file:
+	remove_proc_entry(MODULATION_FILENAME, proc_folder);
+remove_proc_dir:
+	remove_proc_entry(PROC_FOLDER, NULL);
+error:
+	return r;
+}
+
+static void __exit usb_exit(void)
+{
+	pr_debug("%s %s\n", driver.name, __func__);
+	remove_proc_entry(MODULATION_FILENAME, proc_folder);
+	remove_proc_entry(PROC_FOLDER, NULL);
+	if (ez_usb_interface) {
+		device_remove_file(&ez_usb_interface->dev,
+				   &purelifi_attr_modulation);
+		device_remove_file(&ez_usb_interface->dev,
+				   &purelifi_attr_frequency);
+	}
+	usb_deregister(&driver);
+	destroy_workqueue(purelifi_workqueue);
+}
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("USB driver for pureLiFi devices");
+MODULE_AUTHOR("pureLiFi Ltd");
+MODULE_VERSION("1.0");
+MODULE_DEVICE_TABLE(usb, usb_ids);
+
+module_init(usb_init);
+module_exit(usb_exit);
diff --git a/drivers/net/wireless/purelifi/usb.h b/drivers/net/wireless/purelifi/usb.h
new file mode 100644
index 000000000000..f438f26a406b
--- /dev/null
+++ b/drivers/net/wireless/purelifi/usb.h
@@ -0,0 +1,148 @@
+/* SPDX-License-Identifier: GPL-2.0 */
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
+#include "def.h"
+#include "mac_usb_interface.h"
+
+#define TO_NETWORK(X) ((((X) & 0xFF000000) >> 24) | (((X) & 0xFF0000) >> 8) |\
+		      (((X) & 0xFF00) << 8) | (((X) & 0xFF) << 24))
+
+#define TO_NETWORK_16(X) ((((X) & 0xFF00) >> 8) | (((X) & 0x00FF) << 8))
+
+#define TO_NETWORK_32(X) TO_NETWORK(X)
+
+#define TO_HOST(X)    TO_NETWORK(X)
+#define TO_HOST_16(X) TO_NETWORK_16(X)
+#define TO_HOST_32(X) TO_NETWORK_32(X)
+
+#define USB_BULK_MSG_TIMEOUT_MS 2000
+
+int usb_write_req(const u8 *buffer, int buffer_len,
+		  enum usb_req_enum_t usb_req_id);
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
+   //  7...3    |    2     |     1     |     0     |
+   // Reserved  | Hearbeat | FIFO full | Connected |
+	unsigned char flag;
+	unsigned char mac[ETH_ALEN];
+	struct sk_buff_head data_list;
+};
+
+#define STATION_CONNECTED_FLAG 0x1
+#define STATION_FIFO_FULL_FLAG 0x2
+#define STATION_HEARTBEAT_FLAG 0x4
+
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
+	u8 initialized:1, was_running:1;
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
+int usb_write_req_async(struct purelifi_usb *usb, const u8 *buffer,
+			int buffer_len, enum usb_req_enum_t usb_req_id,
+		usb_complete_t complete_fn, void *context);
+
+#define purelifi_usb_dev(usb) (&(usb)->intf->dev)
+static inline struct usb_device *purelifi_usb_to_usbdev(struct purelifi_usb
+		*usb)
+{
+	return interface_to_usbdev(usb->intf);
+}
+
+static inline struct ieee80211_hw *purelifi_intf_to_hw(struct usb_interface
+		*intf)
+{
+	return usb_get_intfdata(intf);
+}
+
+static inline struct ieee80211_hw *purelifi_usb_to_hw(struct purelifi_usb
+		*usb)
+{
+	return purelifi_intf_to_hw(usb->intf);
+}
+
+void purelifi_usb_init(struct purelifi_usb *usb, struct ieee80211_hw *hw,
+		       struct usb_interface *intf);
+int purelifi_usb_init_hw(struct purelifi_usb *usb);
+void purelifi_usb_release(struct purelifi_usb *usb);
+int purelifi_usb_enable_rx(struct purelifi_usb *usb);
+void purelifi_usb_disable_rx(struct purelifi_usb *usb);
+void purelifi_usb_enable_tx(struct purelifi_usb *usb);
+void purelifi_usb_disable_tx(struct purelifi_usb *usb);
+int purelifi_usb_tx(struct purelifi_usb *usb, struct sk_buff *skb);
+const char *speed(enum usb_device_speed speed);
+#endif
-- 
2.17.1

