Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 887D2171B00
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 14:58:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732509AbgB0N6n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 08:58:43 -0500
Received: from mail-bn8nam12on2057.outbound.protection.outlook.com ([40.107.237.57]:34589
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732502AbgB0N6m (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Feb 2020 08:58:42 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XVb9vx1ndN3Aog7wAgiZj4Fs9DeXmHdoGn3BeecFhzMhTCxgfthXgABqaQi44x7paeSM4AIjEi9/vu9NQt32w8BNDMS+FqoRazGrPzZBq+J4Gt2tH8RBP+vJ8omZOSq6Br8lwSW4pTv7wKLDErBy9mWIDRz+PLL3gqWe7SZdGP4WGX6quvqdT7o8mCL2Le2fH1/MuvUKrSm71x1s/+GOZfF+TS7CfO5ikbU8HjIotOCgKveYWZAHapzGxWJQjpstUKIKYZtGlppPZjZOGMW55IKyO/eklgayYgCrrCyxc+fbw6I/y2UMotkzCXdZgfcoL31s9G+pJ81KrsqzgzpRcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uys8GvF9hdKV3QsGt1Vfkdyf0b/Z+MIbxqEzB0iEA40=;
 b=c7TiHN96mpUrwkSiFBcwkouxgHRhqPSWsjIlJ04kLdnyetLUIQkKPCoepXhFaE1YYJdx6X8cdUDOknPSo/2acWSWVSP57DcIJCGyKWFK4Y3KR9i9EXzw5wIubJN1U9tolfU7+94Vc73OjQ1u5aBZyC0DJrw0JKyU4jvVzgvuDPNUX+W3u/yZ9o65ad6decKOeeL8L+MTaKX4DPIY819gZxx6ggEM6RwdL2/mtwpAHmAoZcbf2E4skLXgBAb10709g543UmzykFzU/CF1B32rWJKE1CJp1tGX0pcnujho4CtbU8MR9kjiKCHp04Xh6qOdXIAvPakgGzNBJC6likxYYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uys8GvF9hdKV3QsGt1Vfkdyf0b/Z+MIbxqEzB0iEA40=;
 b=fQ9qJHQzo2AX+RCKUsdWo9+tvVARz7LRo44OaSxSh8oea0aHHhpNkxsEAueT3YTDFiprt6fnxZHGrk+dzC6WI7P5Pax9jTL8i8OhNw1Cha84M8XnaZ48yxUbyPj72VpXPXegQjKltIXUbEhBSgiEWzPapg2B+SOpDV53MFMpPx8=
Received: from SN6PR05MB5326.namprd05.prod.outlook.com (2603:10b6:805:b9::27)
 by SN6PR05MB5934.namprd05.prod.outlook.com (2603:10b6:805:fa::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.11; Thu, 27 Feb
 2020 13:58:39 +0000
Received: from SN6PR05MB5326.namprd05.prod.outlook.com
 ([fe80::8482:b122:870c:eec6]) by SN6PR05MB5326.namprd05.prod.outlook.com
 ([fe80::8482:b122:870c:eec6%5]) with mapi id 15.20.2772.012; Thu, 27 Feb 2020
 13:58:39 +0000
Received: from sc2-cpbu2-b0737.eng.vmware.com (66.170.99.1) by BYAPR08CA0011.namprd08.prod.outlook.com (2603:10b6:a03:100::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2750.18 via Frontend Transport; Thu, 27 Feb 2020 13:58:38 +0000
From:   Vivek Thampi <vithampi@vmware.com>
To:     Richard Cochran <richardcochran@gmail.com>
CC:     Pv-drivers <Pv-drivers@vmware.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: [PATCH] ptp: add VMware virtual PTP clock driver
Thread-Topic: [PATCH] ptp: add VMware virtual PTP clock driver
Thread-Index: AQHV7XYC1rThvPdYh0WXI1nYohlQZg==
Date:   Thu, 27 Feb 2020 13:58:39 +0000
Message-ID: <20200227135824.GA389099@sc2-cpbu2-b0737.eng.vmware.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [66.170.99.1]
x-clientproxiedby: BYAPR08CA0011.namprd08.prod.outlook.com
 (2603:10b6:a03:100::24) To SN6PR05MB5326.namprd05.prod.outlook.com
 (2603:10b6:805:b9::27)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=vithampi@vmware.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 20e5883e-ac1a-4400-840a-08d7bb8d2554
x-ms-traffictypediagnostic: SN6PR05MB5934:|SN6PR05MB5934:
x-ld-processed: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR05MB5934D3C2F57D69759F0817E0B9EB0@SN6PR05MB5934.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 03264AEA72
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(39860400002)(346002)(396003)(366004)(199004)(189003)(6916009)(5660300002)(478600001)(956004)(81166006)(66946007)(64756008)(71200400001)(66556008)(66476007)(2906002)(26005)(1076003)(4326008)(16526019)(186003)(8936002)(7696005)(316002)(86362001)(66446008)(81156014)(54906003)(33656002)(52116002)(55016002)(8676002);DIR:OUT;SFP:1101;SCL:1;SRVR:SN6PR05MB5934;H:SN6PR05MB5326.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4eCy8ckfS+qfiHPOylHR2HO1heYdkGKzMMNbzY2rRN8SKPibe23HWsHhsUsbR3GRVZzGb8CaXbrvWoUg5mh9M17F2ud9CnItcJ1rxd+QREvcFfgf0047RPuGl7GpndcMEqNoYoVttM3/QvKaoLx8AKKJztlFufP76mf1oFJSFtdbeRSqxGEe1ZNxA77QSJz0iohrTrSZziB+0CW1LOWiZiI7ZGjG6+UmtxqrUZZafYXtQdqX9hpoa7OLwDNOWBkYAjkERxb3Bpaa/9za06Vi53i1yVlx1F4texqR2Pl0XZbzJEl5bYPDI1RmF1rysLqtQJuZwk3TpijN0vf3mG8f21fkMGvAl0Z2dzgwVELzUqAuqNitu4SwE+F7fqTPXlN2ihtv4pp+FSCrGBeS2+k7tdbYRdyRzkCywsczEBLkLuFn0idjDJFsVPI6T209rFfe
x-ms-exchange-antispam-messagedata: 0MU1CTPz+tby6exmRcYlUu2OTruqeZQ4RQ0jBHgm/O4L91Xg6/X9mUiSDO0mX7PkujZXvGkW1R7bXVgHC6+W5nRav+PCqDdlkMtyhMb2fVZs88jP0RYtMY5Sss9hUA8TaJY6NOXklHuIalZ84OGxqA==
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1DBDE32F9A7C314C80A00A38A0CD8C21@namprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 20e5883e-ac1a-4400-840a-08d7bb8d2554
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Feb 2020 13:58:39.0261
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kvSvv97UKxgmJCX1zKCyJm2SR5ZbyO7cV7IAZLJumdwZf19VGHqBGxZJPBbrfF+CF7bBBF7XRS1se1vudlsvlg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR05MB5934
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a PTP clock driver called ptp_vmw, for guests running on VMware ESXi
hypervisor. The driver attaches to a VMware virtual device called
"precision clock" that provides a mechanism for querying host system time.
Similar to existing virtual PTP clock drivers (e.g. ptp_kvm), ptp_vmw
utilizes the kernel's PTP hardware clock API to implement a clock device
that can be used as a reference in Chrony for synchronizing guest time with
host.

The driver is only applicable to x86 guests running in VMware virtual
machines with precision clock virtual device present. It uses a VMware
specific hypercall mechanism to read time from the device.

Reviewed-by: Thomas Hellstrom <thellstrom@vmware.com>
Signed-off-by: Vivek Thampi <vithampi@vmware.com>
---
 MAINTAINERS           |   7 +++
 drivers/ptp/Kconfig   |  12 +++++
 drivers/ptp/Makefile  |   1 +
 drivers/ptp/ptp_vmw.c | 144 ++++++++++++++++++++++++++++++++++++++++++++++=
++++
 4 files changed, 164 insertions(+)
 create mode 100644 drivers/ptp/ptp_vmw.c

diff --git a/MAINTAINERS b/MAINTAINERS
index fcd79fc..871bb39 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17854,6 +17854,13 @@ S:	Supported
 F:	arch/x86/kernel/cpu/vmware.c
 F:	arch/x86/include/asm/vmware.h
=20
+VMWARE VIRTUAL PTP CLOCK DRIVER
+M:	Vivek Thampi <vithampi@vmware.com>
+M:	"VMware, Inc." <pv-drivers@vmware.com>
+L:	netdev@vger.kernel.org
+S:	Supported
+F:	drivers/ptp/ptp_vmw.c
+
 VMWARE PVRDMA DRIVER
 M:	Adit Ranadive <aditr@vmware.com>
 M:	VMware PV-Drivers <pv-drivers@vmware.com>
diff --git a/drivers/ptp/Kconfig b/drivers/ptp/Kconfig
index 475c60d..7d7bb99 100644
--- a/drivers/ptp/Kconfig
+++ b/drivers/ptp/Kconfig
@@ -127,4 +127,16 @@ config PTP_1588_CLOCK_IDTCM
 	  To compile this driver as a module, choose M here: the module
 	  will be called ptp_clockmatrix.
=20
+config PTP_1588_CLOCK_VMW
+	tristate "VMware virtual PTP clock"
+	depends on ACPI && HYPERVISOR_GUEST && X86
+	depends on PTP_1588_CLOCK
+	help
+	  This driver adds support for using VMware virtual precision
+	  clock device as a PTP clock. This is only useful in virtual
+	  machines running on VMware virtual infrastructure.
+
+	  To compile this driver as a module, choose M here: the module
+	  will be called ptp_vmw.
+
 endmenu
diff --git a/drivers/ptp/Makefile b/drivers/ptp/Makefile
index 8c83033..04b9acc 100644
--- a/drivers/ptp/Makefile
+++ b/drivers/ptp/Makefile
@@ -13,3 +13,4 @@ obj-$(CONFIG_PTP_1588_CLOCK_QORIQ)	+=3D ptp-qoriq.o
 ptp-qoriq-y				+=3D ptp_qoriq.o
 ptp-qoriq-$(CONFIG_DEBUG_FS)		+=3D ptp_qoriq_debugfs.o
 obj-$(CONFIG_PTP_1588_CLOCK_IDTCM)	+=3D ptp_clockmatrix.o
+obj-$(CONFIG_PTP_1588_CLOCK_VMW)	+=3D ptp_vmw.o
diff --git a/drivers/ptp/ptp_vmw.c b/drivers/ptp/ptp_vmw.c
new file mode 100644
index 0000000..5dca26e
--- /dev/null
+++ b/drivers/ptp/ptp_vmw.c
@@ -0,0 +1,144 @@
+// SPDX-License-Identifier: GPL-2.0 OR BSD-2-Clause
+/*
+ * Copyright (C) 2020 VMware, Inc., Palo Alto, CA., USA
+ *
+ * PTP clock driver for VMware precision clock virtual device.
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/acpi.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/ptp_clock_kernel.h>
+#include <asm/hypervisor.h>
+#include <asm/vmware.h>
+
+#define VMWARE_MAGIC 0x564D5868
+#define VMWARE_CMD_PCLK(nr) ((nr << 16) | 97)
+#define VMWARE_CMD_PCLK_GETTIME VMWARE_CMD_PCLK(0)
+
+static struct acpi_device *ptp_vmw_acpi_device;
+static struct ptp_clock *ptp_vmw_clock;
+
+
+static int ptp_vmw_pclk_read(u64 *ns)
+{
+	u32 ret, nsec_hi, nsec_lo, unused1, unused2, unused3;
+
+	asm volatile (VMWARE_HYPERCALL :
+		"=3Da"(ret), "=3Db"(nsec_hi), "=3Dc"(nsec_lo), "=3Dd"(unused1),
+		"=3DS"(unused2), "=3DD"(unused3) :
+		"a"(VMWARE_MAGIC), "b"(0),
+		"c"(VMWARE_CMD_PCLK_GETTIME), "d"(0) :
+		"memory");
+
+	if (ret =3D=3D 0)
+		*ns =3D ((u64)nsec_hi << 32) | nsec_lo;
+	return ret;
+}
+
+/*
+ * PTP clock ops.
+ */
+
+static int ptp_vmw_adjtime(struct ptp_clock_info *info, s64 delta)
+{
+	return -EOPNOTSUPP;
+}
+
+static int ptp_vmw_adjfreq(struct ptp_clock_info *info, s32 delta)
+{
+	return -EOPNOTSUPP;
+}
+
+static int ptp_vmw_gettime(struct ptp_clock_info *info, struct timespec64 =
*ts)
+{
+	u64 ns;
+
+	if (ptp_vmw_pclk_read(&ns) !=3D 0)
+		return -EIO;
+	*ts =3D ns_to_timespec64(ns);
+	return 0;
+}
+
+static int ptp_vmw_settime(struct ptp_clock_info *info,
+			  const struct timespec64 *ts)
+{
+	return -EOPNOTSUPP;
+}
+
+static int ptp_vmw_enable(struct ptp_clock_info *info,
+			 struct ptp_clock_request *request, int on)
+{
+	return -EOPNOTSUPP;
+}
+
+static struct ptp_clock_info ptp_vmw_clock_info =3D {
+	.owner		=3D THIS_MODULE,
+	.name		=3D "ptp_vmw",
+	.max_adj	=3D 0,
+	.adjtime	=3D ptp_vmw_adjtime,
+	.adjfreq	=3D ptp_vmw_adjfreq,
+	.gettime64	=3D ptp_vmw_gettime,
+	.settime64	=3D ptp_vmw_settime,
+	.enable		=3D ptp_vmw_enable,
+};
+
+/*
+ * ACPI driver ops for VMware "precision clock" virtual device.
+ */
+
+static int ptp_vmw_acpi_add(struct acpi_device *device)
+{
+	ptp_vmw_clock =3D ptp_clock_register(&ptp_vmw_clock_info, NULL);
+	if (IS_ERR(ptp_vmw_clock)) {
+		pr_err("failed to register ptp clock\n");
+		return PTR_ERR(ptp_vmw_clock);
+	}
+
+	ptp_vmw_acpi_device =3D device;
+	return 0;
+}
+
+static int ptp_vmw_acpi_remove(struct acpi_device *device)
+{
+	ptp_clock_unregister(ptp_vmw_clock);
+	return 0;
+}
+
+static const struct acpi_device_id ptp_vmw_acpi_device_ids[] =3D {
+	{ "VMW0005", 0 },
+	{ "", 0 },
+};
+
+MODULE_DEVICE_TABLE(acpi, ptp_vmw_acpi_device_ids);
+
+static struct acpi_driver ptp_vmw_acpi_driver =3D {
+	.name =3D "ptp_vmw",
+	.ids =3D ptp_vmw_acpi_device_ids,
+	.ops =3D {
+		.add =3D ptp_vmw_acpi_add,
+		.remove	=3D ptp_vmw_acpi_remove
+	},
+	.owner	=3D THIS_MODULE
+};
+
+static int __init ptp_vmw_init(void)
+{
+	if (x86_hyper_type !=3D X86_HYPER_VMWARE)
+		return -1;
+	return acpi_bus_register_driver(&ptp_vmw_acpi_driver);
+}
+
+static void __exit ptp_vmw_exit(void)
+{
+	acpi_bus_unregister_driver(&ptp_vmw_acpi_driver);
+}
+
+module_init(ptp_vmw_init);
+module_exit(ptp_vmw_exit);
+
+MODULE_DESCRIPTION("VMware virtual PTP clock driver");
+MODULE_AUTHOR("VMware, Inc.");
+MODULE_LICENSE("Dual BSD/GPL");
--=20
1.8.5.6

