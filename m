Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BB993ED50B
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 15:08:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237545AbhHPNHk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 09:07:40 -0400
Received: from mail-dm6nam11on2062.outbound.protection.outlook.com ([40.107.223.62]:49569
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237351AbhHPNGT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Aug 2021 09:06:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DT+3OrKpPlcwfFD0tdQOya0gh01V+5F0lz70H5DNd/PAF6+/egVwW0eBLWxARks5E1Vhs5qbbCEBAuSkfnB+BfTpWXIep6aClxWgfsLevzsxObbCqDlOhCOu32Ors+xQU78lxfp6W6uiPVGvbsx9GTh5E09WaOyRJb1lswTtM9tK0mpGSfLVMDC5qNx07GJ/J41EcXl/rbryKtLe7s+QXBfHDhHc79AlFvtJoKXOWCmLQ8vOORYIAbnvsXBMaJX1rCZYfm789Z8WdhGsA3GaCeqITw1/2VVNV3mcacDVgmC36BHidXj7cJP3N52U6OsIp910cEBqAUdFRX1qRAshzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lO2+2y126f2xRL3QsR4YK1NZoXqp4dygPA76a1ZEW8g=;
 b=DRnHnvqDzlVfHZQ+8wsP+X+rxw3mWVctj+w8+AGYTDzuq8BSukGKhcuSRhShiS0JWc2R7UXH5V1V2aeffyeb353uj73PZwjNcVjNYNf+fAGLMUJs2bn7Bz92lvOi440JLlNQ8+puqu1l+qiLuLyEoLklYYc029Cvx179AYMjBiPeWPYG9COxilm+HqqHChICbqMpPVjdmWo9YGoALhuIbdAUQTr0MfqobSv9ZSbnNrEG0V3EQrmTbm9wphHmt+LXR4X826XCNtPsv37JuGckm7SACKd/U0KuPSU4/DNguQ5x9A/u6a2n0dWvUPW7GJbh7Pi9Vq0FudMJjNefzxtd/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lO2+2y126f2xRL3QsR4YK1NZoXqp4dygPA76a1ZEW8g=;
 b=D494kltirBQTBjoxoC+2pDVKONdrgvQeHYuAxVV9uGYXJfT9EBlF8adEN0Vi3MbUVAoXqvlk8yNRogD5azYa1pwd7m9DQ4WipmQt1rTb4a4RWBWUwGQKD81YLneFrZQmRUo3kcJUlwsdBus6RZvy12LYUmT7WoIiKK2yQGltI/DO4pvElwSx9sFTl/baLLMenLftEal6fPE6ifikVSX+lkF1TbT7YSvIHO/RwJdQp+uI3/tSZ/1Dwljd7Em5X0SXuqGDNQ8vdfVlPnQBbUOcQ5tDJyV9tOsF065mgcaChAR9vDZc2efvNowEPUDwwgPNkyj3x9+PEERs30G9nPhVNQ==
Received: from CH2PR12MB3895.namprd12.prod.outlook.com (2603:10b6:610:2a::13)
 by CH2PR12MB4071.namprd12.prod.outlook.com (2603:10b6:610:7b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.15; Mon, 16 Aug
 2021 13:05:46 +0000
Received: from CH2PR12MB3895.namprd12.prod.outlook.com
 ([fe80::9473:20a9:50d1:4b1f]) by CH2PR12MB3895.namprd12.prod.outlook.com
 ([fe80::9473:20a9:50d1:4b1f%6]) with mapi id 15.20.4415.023; Mon, 16 Aug 2021
 13:05:46 +0000
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
Subject: RE: [PATCH v1 3/6] gpio: mlxbf2: Use devm_platform_ioremap_resource()
Thread-Topic: [PATCH v1 3/6] gpio: mlxbf2: Use
 devm_platform_ioremap_resource()
Thread-Index: AQHXkpZWTbmL8hDtXEiLr5NlTfSztKt2GZgg
Date:   Mon, 16 Aug 2021 13:05:46 +0000
Message-ID: <CH2PR12MB3895B35623764C5494C5396CD7FD9@CH2PR12MB3895.namprd12.prod.outlook.com>
References: <20210816115953.72533-1-andriy.shevchenko@linux.intel.com>
 <20210816115953.72533-4-andriy.shevchenko@linux.intel.com>
In-Reply-To: <20210816115953.72533-4-andriy.shevchenko@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linux.intel.com; dkim=none (message not signed)
 header.d=none;linux.intel.com; dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5010fa8c-e79b-4b9b-ff35-08d960b68fd5
x-ms-traffictypediagnostic: CH2PR12MB4071:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CH2PR12MB407162BCF15573BD9D568A98D7FD9@CH2PR12MB4071.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:243;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WkQo+l+1q91Df0VT+3wh9jbJhhv9ydRS24e37uG2DcwqlpwARcXwyGAXKMPzCTlonK78EChvrAb5l/qnnQH1ysYQFXhf8xOpXYjJwR6u5wxGdkGoBAlEJbnn5pxUyA4itOuj/K8jXosNn81gaNwW/cBtMsrMP3BABlOPV7jPnFqUj+2ejGhtJ0YrTW1/whwMcLejHCunu6e2SgmCN1gJLlbvu855myc/q7LPylq0PIx3LBJ1A1TBMNX3OnMTkP63NWo6TUj288ffY6oKOn8XBf/jdRLJdCl2qosKNQ9Gy1spgIFD+h2teKqy+pkqmzpiTCxHc2ELwHyJvDxc5akrfOdQgz4tWhqwO4wsfCpWm1of4Re0NywNsSD4q4rF09fSAEvv2gPDp4Z/eO7wmJUWxM3X0jmz2ITmCQzArfZ+HpDJ/TSHRwQV8KEfq1HAyDzKfDCzoEeJhfp1vVjWaNbeoNputALfcQOIDE9Sr5hX9b0VX9UrCSDB3WBP51zIBl0erlDpYDizuaFFeIv/pS5nPq+gOkWZ13Y4kfq34UwjoEpuq2H6J6F9oqfgPxkQetY8fh0jqyNZhOYhr1Gob/ytXXqZFVbPE/V/fOqGUkZA9BnsBoIkeACXi/9oSd0DfbEcF9jP1SOwWjVeyj6Yh5H0wgw+sGN+2ZoVcvyKJ/z6jZPR77MCgvZmORBJhwWIwwdrPCJibdtzMWEEooQqVVbrpQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR12MB3895.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(39860400002)(376002)(366004)(396003)(26005)(110136005)(9686003)(66946007)(66446008)(53546011)(2906002)(8936002)(4326008)(478600001)(5660300002)(316002)(66556008)(76116006)(66476007)(86362001)(64756008)(33656002)(52536014)(7416002)(54906003)(186003)(8676002)(6506007)(38070700005)(122000001)(55016002)(83380400001)(71200400001)(107886003)(7696005)(38100700002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?iI/KJbFEDFH3KKgZcdQPJswJMNrH6m+0qVwRnxyZhIckwF73Icimi2K9++YZ?=
 =?us-ascii?Q?k9hn0BJVCvCl5OcnjkeyW3tL2BOTWqvDeLcp5luUKrgDJqcmIohTwKyfY95D?=
 =?us-ascii?Q?0QYmPYjEpQnedOdi99etV3ngrZ2o7O1ZE8GYnw2GNeyTly/nxF0lDMs7MmNN?=
 =?us-ascii?Q?JheLzhqVaQpUknLqIZ3YkJ8GzgF2AUZBy1DEUgUbyqS5YiUWIbYyAZf8EUpT?=
 =?us-ascii?Q?yjEjcE5iqj97ZmqaMTvBsJ5SRFx7gO0JDXWTk5B6W8FWJmMdh9MlCh18g9tq?=
 =?us-ascii?Q?e7gXt4vfZ9UzcC3yzL+lJaMysuvbckPKQ7tvnWyoMB6Ss++iJO+dntTuOiYd?=
 =?us-ascii?Q?WfHm/zLlevfQhY9OyxBjXX2yiXKfnuzOR8bWVNBJD8/Ih8JWb3viMLI3SwSD?=
 =?us-ascii?Q?jp+ZXnFOITkMvW6eGTGRmO/hHc3RbCsaabLq+Ms7lb/LifW/JkQ5DjEOjvFG?=
 =?us-ascii?Q?lBupLjCm9mL3oIIeRjsCt9SOXveAG/JDBXDvL68/D+LhWMFZ6OYcrFjhbeBZ?=
 =?us-ascii?Q?KwX05Le8v8hTwr9JJONHuY2QDOWByyW0kkLUvT0EtehF04GMA3Lz97wbXKHo?=
 =?us-ascii?Q?coEBNwPzoFSioOj2yXAx7iA8OSV/xCshbZNMQfsj9800bsGJgzZLatRo7p1O?=
 =?us-ascii?Q?hB3OwJEjI8MCy1JMU98OfhBycPUexhIsJuyVKkOSGA2RI2xvnB6jr1/xG+om?=
 =?us-ascii?Q?OWn85NiekDkxQwXy549BC7uMAjjuTkdVtBL/XF6XryHkoCnNiqnDlNmBolap?=
 =?us-ascii?Q?uQfggdwm+ymI7iP14IN1cuA9iquzAtCICj+MOynBRY2Y4POsY1ZL64G6VEgO?=
 =?us-ascii?Q?BZNJrJrdJbCMkUww91S+ZU6WHdFYbOBv/KJCb0jK7YLzG9JZq5Rzcj4rvWTh?=
 =?us-ascii?Q?zw+TLSxJyiZDaXhcEmGWzWXFygoNYN/b8FC1J9+HyHdYMZlDAIeylsrgW2kH?=
 =?us-ascii?Q?PQOegEIva2QI14xtHEnHhNeEJ3yX/s6PSVS3+sf0EaGbcZ2Jnk9oJmv6Vx9m?=
 =?us-ascii?Q?xOCyfXenH1ChHk5S2Xtz8O8fCKrHSJKw/Hyk216N11WnFid6LGNukeZoQBhx?=
 =?us-ascii?Q?GThIL95Lx2X3OyZH/6aih6vEARa3VPiAv2rMAIwjoZ1oC3w86sDh1PSSWoRN?=
 =?us-ascii?Q?9CB18TqgQyQNj2WZeJ0DulF1pJh8WJmrfLD/P8my3cBBF5DQFuaAw3GYV84j?=
 =?us-ascii?Q?rWm23EJD7or9yDyqQQIuJ3AIQLG22QSMAbO6A/1MKBfRZbrZX78jivb7Uu0L?=
 =?us-ascii?Q?5WkXSS5Aofm1wNQYgLcDUJuiPphThhgZwNL5rA47cFNY18eYJl13zdQ6D+M7?=
 =?us-ascii?Q?0W0ZFUBFDhkeoXpdQaMu/JIr?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB3895.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5010fa8c-e79b-4b9b-ff35-08d960b68fd5
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Aug 2021 13:05:46.1407
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nUUJzdqVmA4zAUEmjOztHkz7brk5WjoZlPw5GT2WqGZK8V8z2bER2+B+H/kJ4vk6BsiDSPjSQesNX5MqReG3Gg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4071
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
Subject: [PATCH v1 3/6] gpio: mlxbf2: Use devm_platform_ioremap_resource()
Importance: High

Simplify the platform_get_resource() and devm_ioremap_resource() calls with=
 devm_platform_ioremap_resource().

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/gpio/gpio-mlxbf2.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/gpio/gpio-mlxbf2.c b/drivers/gpio/gpio-mlxbf2.c index =
c0aa622fef76..c193d1a9a5dd 100644
--- a/drivers/gpio/gpio-mlxbf2.c
+++ b/drivers/gpio/gpio-mlxbf2.c
@@ -228,7 +228,6 @@ mlxbf2_gpio_probe(struct platform_device *pdev)
 	struct mlxbf2_gpio_context *gs;
 	struct device *dev =3D &pdev->dev;
 	struct gpio_chip *gc;
-	struct resource *res;
 	unsigned int npins;
 	int ret;
=20
@@ -237,13 +236,9 @@ mlxbf2_gpio_probe(struct platform_device *pdev)
 		return -ENOMEM;
=20
 	/* YU GPIO block address */
-	res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res)
-		return -ENODEV;
-
-	gs->gpio_io =3D devm_ioremap(dev, res->start, resource_size(res));
-	if (!gs->gpio_io)
-		return -ENOMEM;
+	gs->gpio_io =3D devm_platform_ioremap_resource(pdev, 0);
+	if (IS_ERR(gs->gpio_io))
+		return PTR_ERR(gs->gpio_io);
=20
 	ret =3D mlxbf2_gpio_get_lock_res(pdev);
 	if (ret) {
--
2.30.2

