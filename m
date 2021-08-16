Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8DEB3ED4F2
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 15:06:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237449AbhHPNGg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 09:06:36 -0400
Received: from mail-dm3nam07on2080.outbound.protection.outlook.com ([40.107.95.80]:48544
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234035AbhHPNFq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Aug 2021 09:05:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CkdRTyEFu/SXcl8UUquZt7PAvSGB2UGl2aE3RSwvm5RxH6cclAtTSaNw8PsNXFTeW+Z0az+npPY268Z1M5Ho4XtPKmLARqyFVi6MgopreaT+tScVtQ6+h/p7tRxO6/tnRZITeXVvzkhV7/GTfK5c8M3ule2CN6ljYSp17f7opftEv+WzXtHS2NnUsKNTIamSHmY/7UQxfi7WgYPqKzlXXPTtgA0mNkjdcLH5VGA/p6Q0xgxJr/sr8H4L41tVMJM/DYjQlaiz8Nz0jyz9m4XevBiu5Cy+pc2G40E9V9LY+MVLjjW1NIZ7akPUfiTB8UhiPxpwfKzBNy2LV03BK1kegw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wWr6teL8RklV673sdnPGzcj2GdMgbPLK1UIc9lEZolo=;
 b=Qy5AhEd5JJh7fc4hovkjygEj6lDuB7fetBPM0sXTBHjpd2FzydpdtrvRr5nh9MKPv4p6SZjKJQbc80ZRmpMt8A40L6uFG/Z6HKzJdfSQDAnyKs5WDhFY+eX8eEwQ7mb+/ZYtMtui6cSiEEyP1pVteGxD/HJblDRMGIB1YzJmicKJ+HNmGtwc9R1maY11C+a7krhcAXd2gJCEaRwSmkiwy1Va9wlKtoHciY1PULHNkP862gh5VYLOeXQEAqIOjIOLHUu37iJtFI+Na/k1DD+lerQKNDCSb+OhW0I/Ow1j8V01G+trhWSLY1FHn8uJ5DiAn6ITj+zomgj4berQ//S06Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wWr6teL8RklV673sdnPGzcj2GdMgbPLK1UIc9lEZolo=;
 b=nJtRgE35Lp4D9G+Zw/BaoNJG34ESTtGo3igwRpf6OkB0cAo2sH8Ele5iNRRiYoKMBqItVNx1CtmOVU0Kuj8a9VMOwb0p8x94FKHOC3qwb+RXKT31631uRWkzBNIAxsc8lPrxiB4L+1XQUb1II3JbjUn+rtC252Mhny2xBAg2wWdChZ+BRSsgcFeUOm2tOQ/3A0egeyxfoHcDwUYEiR7EvNKu60gdgGkkcxIkzPxDVmmTAQ9hLhxrbILIuCekXaXPQcIam8mkCKkBgMfAlkPFZI4VwfEYWYsZXxjgzzBvHEUVal2WlFfLPriFBLFXkkcI4Je94RRbCc13fky9gWKO1A==
Received: from CH2PR12MB3895.namprd12.prod.outlook.com (2603:10b6:610:2a::13)
 by CH2PR12MB3879.namprd12.prod.outlook.com (2603:10b6:610:23::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.16; Mon, 16 Aug
 2021 13:05:13 +0000
Received: from CH2PR12MB3895.namprd12.prod.outlook.com
 ([fe80::9473:20a9:50d1:4b1f]) by CH2PR12MB3895.namprd12.prod.outlook.com
 ([fe80::9473:20a9:50d1:4b1f%6]) with mapi id 15.20.4415.023; Mon, 16 Aug 2021
 13:05:13 +0000
From:   Asmaa Mnebhi <asmaa@nvidia.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        David Thompson <davthompson@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
CC:     Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Liming Sun <limings@nvidia.com>
Subject: RE: [PATCH v1 2/6] gpio: mlxbf2: Drop wrong use of ACPI_PTR()
Thread-Topic: [PATCH v1 2/6] gpio: mlxbf2: Drop wrong use of ACPI_PTR()
Thread-Index: AQHXkpZCShMAc8SB+E6iRJuHTNKSuqt2GXDA
Date:   Mon, 16 Aug 2021 13:05:13 +0000
Message-ID: <CH2PR12MB3895560A6FAC554D50F4DEA0D7FD9@CH2PR12MB3895.namprd12.prod.outlook.com>
References: <20210816115953.72533-1-andriy.shevchenko@linux.intel.com>
 <20210816115953.72533-3-andriy.shevchenko@linux.intel.com>
In-Reply-To: <20210816115953.72533-3-andriy.shevchenko@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linux.intel.com; dkim=none (message not signed)
 header.d=none;linux.intel.com; dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fc64b237-d20d-4b9a-e022-08d960b67c77
x-ms-traffictypediagnostic: CH2PR12MB3879:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CH2PR12MB3879F73F13DE3C00C02480D7D7FD9@CH2PR12MB3879.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2331;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Mlbw85YQzqNOKCtNJDlUrXA7QmIHTM3LK5tjJs85vHAFn6MfRBzxRqRzx3Gn2a8osdo1Lh/sS+m2JT+F9QWEkzgloHM4158LfZ+ncUxU2pO8dfLjlr+W0fVvl0D0qndT2fOXJytBkR/cOl2F3NHveBts2jx5X/sQjLCgop9bSbc3S/NFdhJPAVOl0JXNFriGXR5Xylwu+gT69593oXvKGvtzPZtU/MGHgOQOOgS9K8VkBNyqYNj7zaC51mxRh7jkY7HmSmqCftguc+ni3IkN8Ljtp3TB4BdzyLQfcVyEPXDpRUUkpNc+JmQ6Zf/9aR+930VXVBlc56cRq6fCd7jlKeCPQ4V7oTCFUXxkeepZd2WtLXIwXbkHMClZ5g1P9VGcplAorGUXc5t20oW6Y8xj+ef+R0rdTxG3xODq0TT7BMun/SYvXoPX+yuFYxmUaa72oX50pc34G/ABgp0WQZRBgM4RDMEkwMDaYq+Dyc475GnUbuQnUPWLMaIGHrn15/UowzB5n9nY8UTkyEEp94B60kuxZ1sdTJweAoQvuI+KxsJqefbuaQOr99o8TbuYcOGit2COgnWwXbBz538iDmoshfQPytDND/khJRf66ecMb5+HJsE9AcaMm/U+Q8wtHu3UjFHfTXLMix6+N+o9hwaTv2oedTM7R8XGkc3GEPguqkTJuoxbGOLLNVU/XI8bc0mXl86E8phX5zvkGe3lkqUGuw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR12MB3895.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(366004)(376002)(136003)(39860400002)(86362001)(26005)(52536014)(53546011)(6506007)(5660300002)(83380400001)(71200400001)(4326008)(122000001)(316002)(2906002)(9686003)(66446008)(66556008)(107886003)(64756008)(7416002)(66946007)(38070700005)(38100700002)(33656002)(55016002)(478600001)(8936002)(54906003)(110136005)(7696005)(76116006)(8676002)(186003)(66476007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?AEI4qeObBnvtgwqufHKv2ViZB+AVjmnHJmrRub7oL0KCxvEu5ljYe9s3uNlI?=
 =?us-ascii?Q?vDqDO8+WLPlUS/J6egxGPq+JpxbYCBcR8r+31gd5JjW13uQJ8PHbwcNTVhTe?=
 =?us-ascii?Q?UYPaLRULnwv0SO79Yiftr1tOKjjODETEgV5EEWJLmdBaF+aJz6gZbp6XXb7x?=
 =?us-ascii?Q?pUvHwUrNiuS5CL1bxLGML634e00wWwc09P44VAkmcuA94Tr5HopXJzWFzbVZ?=
 =?us-ascii?Q?mW1akO2x1skFDlcU8plxTPwwf8Tid1PIAmXfJchtGUmGWJNo64qt/LO1U3Gq?=
 =?us-ascii?Q?B5hq4P/HDJMUBGKIzNG+kDG74hsy/8jQYZerEdwXSV6aF9OksNuoQznCjxPK?=
 =?us-ascii?Q?SnkHJ4fQFjrGmS3QFNBx+Gno+OjbVGOP0lxXe6DaVXeGsL4TqTMvpa2NKsQG?=
 =?us-ascii?Q?4+1nhnYAbW1JpLYTn+I94S1ziVqY2NHr5+FUC84tqWOOjg6YNwWq1DMNyTRk?=
 =?us-ascii?Q?7PDue2D027pe4qnDrZtakyICC+LEAWvmaa3YjqsgcDsIh8UnsGij/oa9O3kb?=
 =?us-ascii?Q?jnXlvTgNrqXlT2KjTXEXYF0RZuMQCjbtyOAXIc3og45uIbGH68uMGDgvgEgM?=
 =?us-ascii?Q?/EBeFDh8ir10GG0LMhs3y1QEp5NqjUopATckB9b6Tt9zAjxE46G86DDm0e2D?=
 =?us-ascii?Q?hDphz1K7P8SWshGtaQSP6PJrvU/+kEEODtVih0QEXAQmdM4HHeQ4wlqZZOOt?=
 =?us-ascii?Q?+F3iJQk+/oLf3olTO58I/82JQrDX0BNZl3wzZmp4f2aVrtylfC827UQDeCm5?=
 =?us-ascii?Q?2tgyp8wbmbh1gzj7IiIMxXnEtca173HwKoMSKwfuqi+uHe9B++8Tg6/SNYXy?=
 =?us-ascii?Q?10LKM2Ccj2NsSEq11Xxkkt1tUj68yzF+NEHl+pnE9tMAVCil9pkAf+XpMO1J?=
 =?us-ascii?Q?/hBc7zN0E0L76V2Vm6O+cE1frWuqabGGB3yD4rTP08NZRdIDPICTWCJGpTYN?=
 =?us-ascii?Q?fjydlQytgDbAdPpeXlMKLrPQlVYe6147ZmxjXNQJlL7NgKnvmDVOt2sLoy9B?=
 =?us-ascii?Q?ACnoowhs0rsVfedx1DFXlx+we5e1PWA1Y6txYG5YJ7gcnK1XD7bOfmwOHE/x?=
 =?us-ascii?Q?xVkiCqqhV2zubbKzeSavENKHbDWYwdfi+CkDM9wHZ1O4bFjUwWskDFCDF3k7?=
 =?us-ascii?Q?3dwp/ymuU/lbb7S5cPyWjsYCGs9O99zt4sjKBWnccxjdPah6EwhTQcCqQIOM?=
 =?us-ascii?Q?pxJd4eDt+u+DZJhYViKIFeSysy2XyjnBSI4QCxRqZU/9B7Yu8bwNFCdhoSjc?=
 =?us-ascii?Q?dXFlRV0+2szp7UKIx+NNZNOATmwSF00LIET/qWdVjymgI/RJEfpGqJ/Puygu?=
 =?us-ascii?Q?i6HuO0o3MLuNuxyKXOn2Utjz?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB3895.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fc64b237-d20d-4b9a-e022-08d960b67c77
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Aug 2021 13:05:13.7081
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TZhuO1AKRFW8eFw/xMYqpytSZgNwGFcGltsTGfirN+wOT+4P4Ar/U3Bagl9DXHnokmz1IqMWWAjus+jSubiTpQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB3879
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Acked-by: Asmaa Mnehi <asmaa@nvidia.com>

-----Original Message-----
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>=20
Sent: Monday, August 16, 2021 8:00 AM
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>; David Thompson <da=
vthompson@nvidia.com>; linux-kernel@vger.kernel.org; linux-gpio@vger.kernel=
.org; netdev@vger.kernel.org; linux-acpi@vger.kernel.org
Cc: Linus Walleij <linus.walleij@linaro.org>; Bartosz Golaszewski <bgolasze=
wski@baylibre.com>; David S. Miller <davem@davemloft.net>; Jakub Kicinski <=
kuba@kernel.org>; Rafael J. Wysocki <rjw@rjwysocki.net>; Asmaa Mnebhi <asma=
a@nvidia.com>; Liming Sun <limings@nvidia.com>
Subject: [PATCH v1 2/6] gpio: mlxbf2: Drop wrong use of ACPI_PTR()
Importance: High

ACPI_PTR() is more harmful than helpful. For example, in this case if CONFI=
G_ACPI=3Dn, the ID table left unused which is not what we want.

Instead of adding ifdeffery here and there, drop ACPI_PTR() and replace acp=
i.h with mod_devicetable.h.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/gpio/gpio-mlxbf2.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpio/gpio-mlxbf2.c b/drivers/gpio/gpio-mlxbf2.c index =
68c471c10fa4..c0aa622fef76 100644
--- a/drivers/gpio/gpio-mlxbf2.c
+++ b/drivers/gpio/gpio-mlxbf2.c
@@ -1,6 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
=20
-#include <linux/acpi.h>
 #include <linux/bitfield.h>
 #include <linux/bitops.h>
 #include <linux/device.h>
@@ -8,6 +7,7 @@
 #include <linux/io.h>
 #include <linux/ioport.h>
 #include <linux/kernel.h>
+#include <linux/mod_devicetable.h>
 #include <linux/module.h>
 #include <linux/platform_device.h>
 #include <linux/pm.h>
@@ -307,14 +307,14 @@ static SIMPLE_DEV_PM_OPS(mlxbf2_pm_ops, mlxbf2_gpio_s=
uspend, mlxbf2_gpio_resume)
=20
 static const struct acpi_device_id __maybe_unused mlxbf2_gpio_acpi_match[]=
 =3D {
 	{ "MLNXBF22", 0 },
-	{},
+	{}
 };
 MODULE_DEVICE_TABLE(acpi, mlxbf2_gpio_acpi_match);
=20
 static struct platform_driver mlxbf2_gpio_driver =3D {
 	.driver =3D {
 		.name =3D "mlxbf2_gpio",
-		.acpi_match_table =3D ACPI_PTR(mlxbf2_gpio_acpi_match),
+		.acpi_match_table =3D mlxbf2_gpio_acpi_match,
 		.pm =3D &mlxbf2_pm_ops,
 	},
 	.probe    =3D mlxbf2_gpio_probe,
--
2.30.2

