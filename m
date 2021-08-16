Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D41BF3ED4CD
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 15:06:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237233AbhHPNFb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 09:05:31 -0400
Received: from mail-dm6nam10on2080.outbound.protection.outlook.com ([40.107.93.80]:30620
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237025AbhHPNFN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Aug 2021 09:05:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NpdkBOdmfUI5UA1Qamx3Z895vnLKHutT3qbWFPsOTOfLw0BZS5lAyPtY6e08xe5k7puxH3uBWlaTppnaeU221FM2ePzhGgzEM43G8IEGYHnK2aDk21vom8i94SQ/Q/ihxERz7xq/z1MqLSTApa7nAyrai01cDem8iukEQi5S9w1oxDvvl6HgoAoh/DJLE+S52gY3jtFpCMqFperabn+cHriNjoa1lWto+ulYjo/R/aJO7FxfpuHpj8uLRTRl1YwDRWSXUk1Q978XuY0sq8F701W58/We7JhI8K+A0UvFtVx7h93C2AIsxeGF3L2Lryz9ADB32oATXeTHcaxy+aVRKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LG1XhtVuCaCd5OjS2979QwneiWyRZvxVtjhTdxJzZ4E=;
 b=LlkB32IvfuJ2INqckhJXgueDCiUT9wIfXAAROPewBWqOxgLXUxSdvyGOFWNhfqiULv1v9kH6vnCpBYz4MpRtWEF67lTMoNZyyum32CtFJQXM8suseHBFB2U2Ev34+1WB76SHL/mjHL4quixXuOUM4RxJIgz92ihjLmkad4W+Ut802VuL55aD9hiATXMDBhY4WIjHBuq34T6h6t4vY0YJEQDVKs5hEj+WYmwNGM2jG5WrnnKHSK4L28z1O7Q7Qw4Nj87vBO2ubC67JCz/P+yNkHjqZcvYQS09F/c7WxjOQyJSPBOmEpPo02VPvYO362C+Cq7GlmxGE21O6mKYkQ467g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LG1XhtVuCaCd5OjS2979QwneiWyRZvxVtjhTdxJzZ4E=;
 b=D7HC6MifPLEuPCsjC0uXfhDFrGRArujAjxcQcOypgx8QMacAoaG1w/Pg9ePY5180rd5G2ba9XeTFYWRySH/yQj5UcuZGdyR6+ukl2ccVJB9SOK1BAjHiQ8FPmORKDnE8a+fbiezXqiFK3I/pKoeXyyWhZyPfnbSHMojLhlmFcTWAbhjxNiTOJgRGLwIIjX5BjrjoVNFcp03y9vy0spnckHmK3LMRFPJjEBmm7ODLpnzyeYGB7d+Svhs7+4WooCfTbkomz3N71fiCAjIUgxN//u0W8TSk/mvdZ6ohjZTFlZdf6p2xs3wNw5BfBB44jfT0HCw8IFfmlyii0Bsc+0v/kg==
Received: from CH2PR12MB3895.namprd12.prod.outlook.com (2603:10b6:610:2a::13)
 by CH2PR12MB4246.namprd12.prod.outlook.com (2603:10b6:610:a9::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.19; Mon, 16 Aug
 2021 13:04:38 +0000
Received: from CH2PR12MB3895.namprd12.prod.outlook.com
 ([fe80::9473:20a9:50d1:4b1f]) by CH2PR12MB3895.namprd12.prod.outlook.com
 ([fe80::9473:20a9:50d1:4b1f%6]) with mapi id 15.20.4415.023; Mon, 16 Aug 2021
 13:04:38 +0000
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
Subject: RE: [PATCH v1 1/6] gpio: mlxbf2: Convert to device PM ops
Thread-Topic: [PATCH v1 1/6] gpio: mlxbf2: Convert to device PM ops
Thread-Index: AQHXkpZGM/yx3akJD0WfnrDIzZ0lYat2F2+Q
Date:   Mon, 16 Aug 2021 13:04:38 +0000
Message-ID: <CH2PR12MB3895C5A27672000417F0E90CD7FD9@CH2PR12MB3895.namprd12.prod.outlook.com>
References: <20210816115953.72533-1-andriy.shevchenko@linux.intel.com>
 <20210816115953.72533-2-andriy.shevchenko@linux.intel.com>
In-Reply-To: <20210816115953.72533-2-andriy.shevchenko@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linux.intel.com; dkim=none (message not signed)
 header.d=none;linux.intel.com; dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0153c21e-cffa-4544-7860-08d960b6678e
x-ms-traffictypediagnostic: CH2PR12MB4246:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CH2PR12MB42466A3C594440502B5706B7D7FD9@CH2PR12MB4246.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:158;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BfiCGq2mWJv43kPMnQSZixluICLgwFuCysMTRoaREXgIukUvr7H9t9bdMNgRuAR9K/BMXM4XnpjL3F6tEv2MsZx772t3YBboCY7+Okf+ekxRX8WvTJeSJL8Vsf8n56SLHZEXYrliTd5FRBDH35StmDTivh51eXLY2Ws2DnGzmILderpMH83IxzOaMrYGne93OvKVBKh2yKnFjVkG8IND6h8Nvf/xuxSIhElHzv5Vo8pq73pPIpdZWNYCZzQ9FhJ0RuEFZ9BoFqAkbadzqTyyFpnkUd6tmICLi/qQ59BJ4vaQrhHrLUCQFmMdQo/3KcS12GR2hBEbvKE6/uf6sOMq227qcwbDTAhxIZ0lPtA0Q61A5srsz1V1YsWcyYtc5pwa2CyrP4w1JZjDz/ZLr6+lB192L495OJh/dj1Mbm8gevESlPoivixVPbjeGg+xyO/VPMuAa7dlAwY+f/LZZmHeSC2QAnK7SPjWsYzPxrFu0TVaTVMdCjL+n36Uqc3TRksNbcbQqLEsdtCOnSDCJKfXGWEUlRDD7vnzoMhsp+PpghCIojuP3Ydi418QvrG8EuOkzTSLKy0VqL3+PTKk0pwgT+JcOe1Z9uqpjmlFysvdnJTM5e0JqNxhZLK6MsRiiCco6ZRGEt8iZHroccgzeAlFp7To7HhSkDMEndtj960gH5o0pS1k/bXA/fJe6qK5vjPsAVJiAiUVHN+NdymFaRN0qA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR12MB3895.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(366004)(346002)(136003)(396003)(110136005)(86362001)(316002)(478600001)(54906003)(7696005)(52536014)(107886003)(2906002)(8676002)(8936002)(9686003)(7416002)(55016002)(4326008)(186003)(83380400001)(33656002)(53546011)(26005)(38100700002)(122000001)(66946007)(64756008)(66446008)(66556008)(66476007)(6506007)(71200400001)(38070700005)(5660300002)(76116006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?r4G6SwrLu23greljENKELrvnTLTu++Z9nmKhnnndqVB0bKfc8d77WN5SLulx?=
 =?us-ascii?Q?1jpUF70KEkEgwqdiWWJq0cBqpmAgrK1zmk307LOv8+5hEAwfmm3+Dm91G9h/?=
 =?us-ascii?Q?3XbTW8DLACrGar44m/r3ukKehFx/K0LMLm9X0kQCOaq8rX7H58cNSwkn5Wl6?=
 =?us-ascii?Q?wlgxvRMNurtuGrCN2bKL10SZp4LTmjpXfigzXpNC5gWBmsKK9KK9HGvqjkFd?=
 =?us-ascii?Q?eqSgvamGaC90TXEWC9vdaSrHyj1QcAASxUoLfWsuRRgel2XJMAvjX3Z3en+l?=
 =?us-ascii?Q?gBQiibS8zZUNV+rbAlBBpGib6RRebGHq8rwmTZgaXnkUKe2zLrgbG7Yxx+Zw?=
 =?us-ascii?Q?xQDJWMP2E63a2nwDJHnHe60c1unZxLcVRLEFZdtMke/cmwWiJYuj04Wf7WYn?=
 =?us-ascii?Q?aZMlICkXBr2jvUIGC/xwXvjwKg6mDamMsmFB3DvQgcZ9nOkT1MBnEXu0o5qU?=
 =?us-ascii?Q?BBGG46E/cNYYlVt3iheev9cnlRJOgXWYpLKV42fKhGxibuSn2Tj9sR5FVt69?=
 =?us-ascii?Q?Yimece3SnPbdlk8Z4u0g/aUMHT2MQUKSafBZWmca4HHOi2hU0esU2lKKcwFV?=
 =?us-ascii?Q?dFY4UEhQqfK7uPOYQr4wdD9JhgYowebPasaTT8AZRq1AcaOevrEqEChZoXJu?=
 =?us-ascii?Q?DOZS8oTBkFWLhGBtssz9HjG2IVOJ/4KmfP+QqcxRoPkbtN/IhvSLkLPXElaB?=
 =?us-ascii?Q?VbyOl/vIDiuL35KeF6JIp+OKOFvuOWVxzg1QS6vqCeHU/ep5iqjY1Omjx/TF?=
 =?us-ascii?Q?idUGcqbWdXNWcpoMBLD5ysK00qpGiIlMOI7CmjwGnHi8TJiVphUQQ5ObkfwG?=
 =?us-ascii?Q?v0F60rLW8i7cSRR4jaDlJSGc8GDHSVj/y0z4+cccziJDYiuDy4lyd9VWLEOY?=
 =?us-ascii?Q?L9NXdSakgRUOP1q7nBscIrFJi0ij8Hyq/Ukg/DAq0xIAZg0P6IF/bZeqhYYR?=
 =?us-ascii?Q?u9ZzkekotfyGx7ABbNIYTwsdZ1Gcztaa0A5Hm75nxVUlbjrCANUyiaYLjqh5?=
 =?us-ascii?Q?2rkuAQuul+cbiiyHvELp5xC52lBC1gHMXZL2nbcXrT6f+dxqxg2LrA+cAywl?=
 =?us-ascii?Q?L9pZbXcLvVLBDpLxqmzeavSCH4uWtthq4zd0FTJemvuEfqCDZkE3ZF2k57cV?=
 =?us-ascii?Q?722WWmYUM2Gl/Wk34IRpqrTk8pOX8Jic1k1BKd5ard5ioKg/9CPo4NI8BFwp?=
 =?us-ascii?Q?/QmAjFZ7B+rhlyRHfjeMyKvnJlOuC5ibDhwngpbbbeoyXh/lIgeINcbxKR0I?=
 =?us-ascii?Q?1XROBjRGOhtIJAHer8aYgPbEyckbqFvr542qQf9RL++ClqWZUxGFc9NUuQ8B?=
 =?us-ascii?Q?j70HOBXjYw59V3wMv05HtIzO?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB3895.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0153c21e-cffa-4544-7860-08d960b6678e
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Aug 2021 13:04:38.6310
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zG+oSs3pjcXtYyP03iBeSGRz/LDAsHnbD520bZ+uX+GAnXsofuCVz9f5J8VWBLdNK7BrtiUz/Lmr1cDctQzPWA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4246
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Acked-by: Asmaa Mnebhi <asmaa@nvidia.com>

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
Subject: [PATCH v1 1/6] gpio: mlxbf2: Convert to device PM ops
Importance: High

Convert driver to use modern device PM ops interface.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/gpio/gpio-mlxbf2.c | 21 ++++++---------------
 1 file changed, 6 insertions(+), 15 deletions(-)

diff --git a/drivers/gpio/gpio-mlxbf2.c b/drivers/gpio/gpio-mlxbf2.c index =
befa5e109943..68c471c10fa4 100644
--- a/drivers/gpio/gpio-mlxbf2.c
+++ b/drivers/gpio/gpio-mlxbf2.c
@@ -47,12 +47,10 @@
 #define YU_GPIO_MODE0_SET		0x54
 #define YU_GPIO_MODE0_CLEAR		0x58
=20
-#ifdef CONFIG_PM
 struct mlxbf2_gpio_context_save_regs {
 	u32 gpio_mode0;
 	u32 gpio_mode1;
 };
-#endif
=20
 /* BlueField-2 gpio block context structure. */  struct mlxbf2_gpio_contex=
t { @@ -61,9 +59,7 @@ struct mlxbf2_gpio_context {
 	/* YU GPIO blocks address */
 	void __iomem *gpio_io;
=20
-#ifdef CONFIG_PM
 	struct mlxbf2_gpio_context_save_regs *csave_regs; -#endif  };
=20
 /* BlueField-2 gpio shared structure. */ @@ -284,11 +280,9 @@ mlxbf2_gpio_=
probe(struct platform_device *pdev)
 	return 0;
 }
=20
-#ifdef CONFIG_PM
-static int mlxbf2_gpio_suspend(struct platform_device *pdev,
-				pm_message_t state)
+static int __maybe_unused mlxbf2_gpio_suspend(struct device *dev)
 {
-	struct mlxbf2_gpio_context *gs =3D platform_get_drvdata(pdev);
+	struct mlxbf2_gpio_context *gs =3D dev_get_drvdata(dev);
=20
 	gs->csave_regs->gpio_mode0 =3D readl(gs->gpio_io +
 		YU_GPIO_MODE0);
@@ -298,9 +292,9 @@ static int mlxbf2_gpio_suspend(struct platform_device *=
pdev,
 	return 0;
 }
=20
-static int mlxbf2_gpio_resume(struct platform_device *pdev)
+static int __maybe_unused mlxbf2_gpio_resume(struct device *dev)
 {
-	struct mlxbf2_gpio_context *gs =3D platform_get_drvdata(pdev);
+	struct mlxbf2_gpio_context *gs =3D dev_get_drvdata(dev);
=20
 	writel(gs->csave_regs->gpio_mode0, gs->gpio_io +
 		YU_GPIO_MODE0);
@@ -309,7 +303,7 @@ static int mlxbf2_gpio_resume(struct platform_device *p=
dev)
=20
 	return 0;
 }
-#endif
+static SIMPLE_DEV_PM_OPS(mlxbf2_pm_ops, mlxbf2_gpio_suspend,=20
+mlxbf2_gpio_resume);
=20
 static const struct acpi_device_id __maybe_unused mlxbf2_gpio_acpi_match[]=
 =3D {
 	{ "MLNXBF22", 0 },
@@ -321,12 +315,9 @@ static struct platform_driver mlxbf2_gpio_driver =3D {
 	.driver =3D {
 		.name =3D "mlxbf2_gpio",
 		.acpi_match_table =3D ACPI_PTR(mlxbf2_gpio_acpi_match),
+		.pm =3D &mlxbf2_pm_ops,
 	},
 	.probe    =3D mlxbf2_gpio_probe,
-#ifdef CONFIG_PM
-	.suspend  =3D mlxbf2_gpio_suspend,
-	.resume   =3D mlxbf2_gpio_resume,
-#endif
 };
=20
 module_platform_driver(mlxbf2_gpio_driver);
--
2.30.2

