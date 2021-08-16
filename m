Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 363EC3EDF59
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 23:34:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233357AbhHPVf0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 17:35:26 -0400
Received: from mail-dm6nam12on2085.outbound.protection.outlook.com ([40.107.243.85]:12896
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231707AbhHPVfZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Aug 2021 17:35:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Js2AvVwa8djq692XTUUgYq9vdWH8iVcM+B0L/snqw2VjGMNSFGrMmvltQvZ9hTDygE8nu1upLilkvzVamFDuC2+pS8IwZ2ejOgjyyRyfcgSDBbvWEnHGFKDcyfirhp8DH8u47Kg7vMUQqTv28FsQNrIcxzm0SUeJKgleLEkaIBRH8AWP9Q+PeBpmqCCQvp+YnjVC91hUdx83uAmw/Uad5Wofge1LQr7TQwt20E+VVHdcfw0swuM23fqy9liRk37I90sfo1HK1+2SBHW0jYph7NAj0Y1/DtLPoBZmi9AI0O5CNR+2f/v5r0O7vwg05Q3ose96O8VqyfG0UWggZfYY5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bg/itZBO4dpSoDeYSViwqPcCA0IE9jtJfZKWqCcgrdM=;
 b=BjdhmcmDuZZY5ejPJ18hb2lP6vFsfpIckQ/dcDVNHxqB1wFgj9r4hCWB0Yl2hZFE3YQ3shIP+4T1fqngBCz9MnHewFGWDV9M2b2HfmoUVJhqzsJI5+2skDPtwKVKf1AuXOykA7suMTrYcFT669L7Syjp++JgEgZNVqr9gvBEP1m7f0/qhiopYjiwgBibkk152u2QLmmgsuLDvBhWfo5aJDp3ozTQyLUV8wkMLuSFwpP+BCTW2KWjpjm1gCCi1xxFOYcg2uxysk3wT8M2RBJxXBfrt0Fu9cwu7wavI3nj/V9Ao7fOcizDxTtLwPaWnh2WYmUxUgFvJx+Z8Uff7lA88g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bg/itZBO4dpSoDeYSViwqPcCA0IE9jtJfZKWqCcgrdM=;
 b=upQGnEJwIHYhOpleXso5JP++knJWEM+4ZxbCmy/7WK9anaGDjaBNSffGCLFjK+jYQjRRc2E1zHpHxkqSN0zdwYOwiSYN+PtKrzKeygM9ETWyK+SCUgLqeJnvRxOthxuSHtsooVRxY5FW3NhxR46EblLhMlJ39C0tBI7fMqdD3CIFc9kfO+lsx0menGddOLgyAFVVQExW7sxXiN88gd98enlP/TcUmPelqQR7VpkPEeeMmVfHtpG2OzmGW2hvzx1YzBS7KBBuJ6TTXW16e5vg8eps0aiUTgQEzWUbBRGBMsyw04oJvEpVbqS+fwPN1qHIi34ZRwcZwxXwKwNVaYEE2g==
Received: from CH2PR12MB3895.namprd12.prod.outlook.com (2603:10b6:610:2a::13)
 by CH2PR12MB3781.namprd12.prod.outlook.com (2603:10b6:610:27::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.19; Mon, 16 Aug
 2021 21:34:51 +0000
Received: from CH2PR12MB3895.namprd12.prod.outlook.com
 ([fe80::9473:20a9:50d1:4b1f]) by CH2PR12MB3895.namprd12.prod.outlook.com
 ([fe80::9473:20a9:50d1:4b1f%6]) with mapi id 15.20.4415.023; Mon, 16 Aug 2021
 21:34:51 +0000
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
Subject: RE: [PATCH v1 5/6] TODO: gpio: mlxbf2: Introduce IRQ support
Thread-Topic: [PATCH v1 5/6] TODO: gpio: mlxbf2: Introduce IRQ support
Thread-Index: AQHXkpZRAcQDwgai0k+eK2nQg5Bpo6t2INug
Date:   Mon, 16 Aug 2021 21:34:50 +0000
Message-ID: <CH2PR12MB3895ACF821C8242AA55A1DCDD7FD9@CH2PR12MB3895.namprd12.prod.outlook.com>
References: <20210816115953.72533-1-andriy.shevchenko@linux.intel.com>
 <20210816115953.72533-6-andriy.shevchenko@linux.intel.com>
In-Reply-To: <20210816115953.72533-6-andriy.shevchenko@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linux.intel.com; dkim=none (message not signed)
 header.d=none;linux.intel.com; dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6d0be91c-c204-467c-4142-08d960fdae19
x-ms-traffictypediagnostic: CH2PR12MB3781:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CH2PR12MB378130CBE1CF800495C5BF5BD7FD9@CH2PR12MB3781.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rQjUBkwZlt9RP41IBi34pzZJI4uZYUL1siqUHyXNkF4lCwpcoJG6SRXeHhxM9B2KVSMGu3KbgWZ6hrjk82pakxdDrXIx649nPK/q9CIeM5I/wmUtFugcjIKVd/PFNtv6WVYyWYKuyCskOOveilc/eQpHBmnWTx1E6RurHsXV+qPxK9+Zlz6ati/o6AxF2NJvq6MY9ZPXLbsWH9HVGGi7qG3WkpSdoD8wR0Z194qJpmkSOZm7BDQFPa6sHegx9E8yhVo5DmrYTGdSdqiKvO596Gfrk6LEOFA1G2CLqjoa1+FGKwEbWjQt3vt5s7YpU/PRIT03H0SBcZSH4iu59wq+Y0fS5fzILWhwVi3g2urDvb2EXWf0/k4rkj11saSqAAucCi2NMGuo182R0pxQqSZoB0SsMPNciDZX1wc45aT7rn1c6Me3xehpzrcZhgMequ+nPSuTMZkrc5oVnSLjlzIZkdVDjrX5d2dQ+tqvfbaDv9PVwrVpbwdpcAius+VGmH9+O+DRBwiEI5dDUUIS2ZzSaK6V79yyBLeZwd5l5J1rEeqIePrAMTZnXViq0g9N4Y9u8WkUvs1PaBFIBD2ReXNARlBC9r7XsjKA+u7KIL/tHlHZtg5M614isn5YtpwJTE/eSy56JzDbsr/rkQ706UcTgYRjLv+tn0v7eO5/BWYVxUyhIeCdweIxHIXY9fe1Tq2mmX50lHhbRIEkVU/YUuYjIg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR12MB3895.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(396003)(346002)(136003)(39860400002)(122000001)(38100700002)(83380400001)(86362001)(8676002)(38070700005)(5660300002)(64756008)(66446008)(9686003)(66556008)(55016002)(52536014)(66946007)(66476007)(76116006)(71200400001)(7696005)(4326008)(7416002)(478600001)(33656002)(186003)(8936002)(54906003)(110136005)(316002)(107886003)(26005)(6506007)(2906002)(53546011);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ipun95feci0thjemSY5RJeHAtYh45YAdElckcjmiSfOaZsNgjIEuLCXDHB4C?=
 =?us-ascii?Q?KpVxS3Lbz/g0H0rFUPYKZj9EEg8Gy/vAW5pfm5/1B/aKgqb0M68iq6DLBawX?=
 =?us-ascii?Q?AosGk+byCmkRuRSUDC/h8sUVGREepDMx/AZH/yJi037M75yx17jl8qImmTI9?=
 =?us-ascii?Q?lAJF6b7X2On9G2z5kdeqpoI0LUZZo5xVr6KDX412I7qVVUiqSGIRTlnM1DP0?=
 =?us-ascii?Q?5iRYdkXsFK9ZLzIszQyjFIkX5ZqwGTTvqzE6M7EFEjWSz/FBvNLX5bCatB33?=
 =?us-ascii?Q?LfY03K10wxXg5G/Lr/Nfl1/uObU2t1jts3+yFmbU+t/LV7RoyyIDtU8gGxBN?=
 =?us-ascii?Q?CGOR7OPXup2Dfbqw/eF+GIwfE9o46cJsvkkI6dke7fYVfSSHemkyIygB+Hs9?=
 =?us-ascii?Q?sbSGJ8BFFiHE7d5Km/NOVIIKO/IlQJLJguOH0ZLBklaKSh2UcnkmM2mZF73X?=
 =?us-ascii?Q?AmuNeqIAd+vjGlKjOYAh7xbhtDs5anTZXsBOeo90J4BIW0dpSifj7HNyTetG?=
 =?us-ascii?Q?taskxQV3T5cwxbfncWkJeieQxn1WpgXTEJ2+7wjmldogAzbmsWk1jSWz8pmB?=
 =?us-ascii?Q?qDi44vwgv9tw9W3tiYqN4Wgy4G5TdtBuA8ILWEyN3Y5uEUDsIaORF17RMkLW?=
 =?us-ascii?Q?Os1z+H89kjZTO1OWReesFvoBMKni8ZF1mfZjtrs8iH1Y40hd7wJVLifDROTi?=
 =?us-ascii?Q?cE9CS2evaKd6m3SkVf9F9G3+S8Irfp0gJeI413y9o5vDH2PLLhJ2AKVFmJ6a?=
 =?us-ascii?Q?HsEVLp+YwqO7sEZHSJqIXyBvYdV6fo92+EvI2L8Xp48QWv0ux4V4880/cUX9?=
 =?us-ascii?Q?OoDiv2m5CaB01zdu7PixkUj5qJj1HD5zMUwuJpz2AjGyUfOKt5eE4EfqkU+U?=
 =?us-ascii?Q?o1JLyAFhKSbJepRo0BfE5bclvCy+9nCXTas7XORrtYXVyWd0IeSR8viG6Sod?=
 =?us-ascii?Q?RBgFe9h3WrSdC7HdKpjmNGCuymFJfRfnSTdVcS0t+6HFAWWDJYlCUHgdBZVg?=
 =?us-ascii?Q?dKFNM9xCb2DXBj6Ei6oLyKDxSdPdmafiSb/8hjm9AROYSD2DicVqUbHUJSgd?=
 =?us-ascii?Q?O9EBwl7CFrK+Yx7GIp6yN19V+csL64aAGrK+mUFrgOXBwITlDKgIIQKCTWjw?=
 =?us-ascii?Q?UoAObN2ANzBUr8tQb+oPNRWZK17CdYgadXtr36ZXJOv6UNnICvDyKPldqgpT?=
 =?us-ascii?Q?ymP7JUoYhYNAqUPfaJiP8/8CNclEJfQcPm70XlI7o2gP9gxZ3bhY8dghsFRa?=
 =?us-ascii?Q?Vq0V4eW6q5b7dGKxVxpUikGVpbwwffanMFBz/gCTOqtpfQ6omlMNyDffpXvx?=
 =?us-ascii?Q?YaHu+KLDUEutYxPGGgfKDL2B?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB3895.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d0be91c-c204-467c-4142-08d960fdae19
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Aug 2021 21:34:51.2399
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RrzNz+/yqdsmjwECSp2u4R2wZGLS5yPU5T6BjwUdtv+jnX5COBlUqaIS+Pm+B6oZ8FrxeIBx+WS42gCSUFsCSg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB3781
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andy,

Thanks for your help!
Please see my comments/questions below.

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
Subject: [PATCH v1 5/6] TODO: gpio: mlxbf2: Introduce IRQ support
Importance: High

TBD

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/gpio/gpio-mlxbf2.c | 106 +++++++++++++++++++++++++++++++++++++
 1 file changed, 106 insertions(+)

diff --git a/drivers/gpio/gpio-mlxbf2.c b/drivers/gpio/gpio-mlxbf2.c index =
3ed95e958c17..bd4c29120b62 100644
--- a/drivers/gpio/gpio-mlxbf2.c
+++ b/drivers/gpio/gpio-mlxbf2.c
@@ -43,9 +43,13 @@
 #define YU_GPIO_MODE0			0x0c
 #define YU_GPIO_DATASET			0x14
 #define YU_GPIO_DATACLEAR		0x18
+#define YU_GPIO_CAUSE_FALL_EN		0x48
 #define YU_GPIO_MODE1_CLEAR		0x50
 #define YU_GPIO_MODE0_SET		0x54
 #define YU_GPIO_MODE0_CLEAR		0x58
+#define YU_GPIO_CAUSE_OR_CAUSE_EVTEN0	0x80
+#define YU_GPIO_CAUSE_OR_EVTEN0		0x94
+#define YU_GPIO_CAUSE_OR_CLRCAUSE	0x98
=20
 struct mlxbf2_gpio_context_save_regs {
 	u32 gpio_mode0;
@@ -218,6 +222,108 @@ static int mlxbf2_gpio_direction_output(struct gpio_c=
hip *chip,
 	return ret;
 }
=20
+static void mlxbf2_gpio_irq_enable(struct mlxbf2_gpio_context *gs, int=20
+offset) {
+	unsigned long flags;
+	u32 val;
+
+	spin_lock_irqsave(&gs->gc.bgpio_lock, flags);
+	val =3D readl(gs->gpio_io + YU_GPIO_CAUSE_OR_CLRCAUSE);
+	val |=3D BIT(offset);
+	writel(val, gs->gpio_io + YU_GPIO_CAUSE_OR_CLRCAUSE);
+
+	/* The INT_N interrupt level is active low.
+	 * So enable cause fall bit to detect when GPIO
+	 * state goes low.
+	 */
+	val =3D readl(gs->gpio_io + YU_GPIO_CAUSE_FALL_EN);
+	val |=3D BIT(offset);
+	writel(val, gs->gpio_io + YU_GPIO_CAUSE_FALL_EN);
+
+	/* Enable PHY interrupt by setting the priority level */
+	val =3D readl(gs->gpio_io + YU_GPIO_CAUSE_OR_EVTEN0);
+	val |=3D BIT(offset);
+	writel(val, gs->gpio_io + YU_GPIO_CAUSE_OR_EVTEN0);
+	spin_unlock_irqrestore(&gs->gc.bgpio_lock, flags); }
+
+static void mlxbf2_gpio_irq_disable(struct mlxbf2_gpio_context *gs, int=20
+offset) {
+	unsigned long flags;
+	u32 val;
+
+	spin_lock_irqsave(&gs->gc.bgpio_lock, flags);
+	val =3D readl(gs->gpio_io + YU_GPIO_CAUSE_OR_EVTEN0);
+	val &=3D ~BIT(offset);
+	writel(val, gs->gpio_io + YU_GPIO_CAUSE_OR_EVTEN0);
+	spin_unlock_irqrestore(&gs->gc.bgpio_lock, flags); }
+
+static void mlxbf2_gpio_irq_ack(struct mlxbf2_gpio_context *gs, int=20
+offset) {
+	unsigned long flags;
+	u32 val;
+
+	spin_lock_irqsave(&gs->gc.bgpio_lock, flags);
+	val =3D readl(gs->gpio_io + YU_GPIO_CAUSE_OR_CLRCAUSE);
+	val |=3D BIT(offset);
+	writel(val, gs->gpio_io + YU_GPIO_CAUSE_OR_CLRCAUSE);
+	spin_unlock_irqrestore(&gs->gc.bgpio_lock, flags); }
+
+static irqreturn_t mlxbf2_gpio_irq_handler(int irq, void *ptr) {

So how do you suggest registering this handler?

1) should I still use BF_RSH0_DEVICE_YU_INT shared interrupt signal?

2) or does Linux kernel know (based on parsing GpioInt) how trigger the han=
dler based on the GPIO datain changing (active low/high)? In this case, the=
 kernel will call this handler whenever the GPIO pin (9 or 12) value change=
s. I need to check whether GPIO is active low/high but lets assume for now =
it is open drain active low. We will use acpi_dev_gpio_irq_get to translate=
 GpioInt to a Linux IRQ number:
irq =3D acpi_dev_gpio_irq_get_by(ACPI_COMPANION(dev), " phy-gpios ", 0);
ret =3D devm_request_irq(dev, irq, mlxbf2_gpio_irq_handler, IRQF_ONESHOT | =
IRQF_SHARED, dev_name(dev), gs);

And I will need to add GpioInt to the GPI0 ACPI table as follows:

// GPIO Controller
      Device(GPI0) {
       Name(_HID, "MLNXBF22")
        Name(_UID, Zero)
        Name(_CCA, 1)
        Name(_CRS, ResourceTemplate() {
          // for gpio[0] yu block
         Memory32Fixed(ReadWrite, 0x0280c000, 0x00000100)
         GpioInt (Level, ActiveLow, Exclusive, PullDefault, , " \\_SB.GPI0"=
) {9}
        })
        Name(_DSD, Package() {
          ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
          Package() {
            Package () { "phy-gpios", Package() {^GPI0, 0, 0, 0 }},
            Package () { "rst-pin", 32 }, // GPIO pin triggering soft reset=
 on BlueSphere and PRIS
          }
        })
      }


+	struct mlxbf2_gpio_context *gs =3D ptr;
+	struct gpio_chip *gc =3D &gs->gc;
+	unsigned long pending;
+	u32 level;
+
+	pending =3D readl(gs->gpio_io + YU_GPIO_CAUSE_OR_CAUSE_EVTEN0);
+	for_each_set_bit(level, &pending, gc->ngpio) {
+		int nested_irq =3D irq_find_mapping(gc->irq.domain, level);
+
+		handle_nested_irq(nested_irq);

Now how can the mlxbf_gige_main.c driver also retrieve this nested_irq to r=
egister its interrupt handler as well? This irq.domain is only visible to t=
he gpio-mlxbf2.c driver isn't it?
phydev->irq (below) should be populated with nested_irq at init time becaus=
e it is used to register the phy interrupt in this generic function:

void phy_request_interrupt(struct phy_device *phydev)
{
	int err;

	err =3D request_threaded_irq(phydev->irq, NULL, phy_interrupt,
				   IRQF_ONESHOT | IRQF_SHARED,
				   phydev_name(phydev), phydev);
	if (err) {
		phydev_warn(phydev, "Error %d requesting IRQ %d, falling back to polling\=
n",
			    err, phydev->irq);
		phydev->irq =3D PHY_POLL;
	} else {
		if (phy_enable_interrupts(phydev)) {
			phydev_warn(phydev, "Can't enable interrupt, falling back to polling\n")=
;
			phy_free_interrupt(phydev);
			phydev->irq =3D PHY_POLL;
		}
	}
}
EXPORT_SYMBOL(phy_request_interrupt);


+	}
+
+	return IRQ_RETVAL(pending);
+}
+
+static void mlxbf2_gpio_irq_mask(struct irq_data *irqd) {
+	struct gpio_chip *gc =3D irq_data_get_irq_chip_data(irqd);
+	struct mlxbf2_gpio_context *gs =3D gpiochip_get_data(gc);
+	int offset =3D irqd_to_hwirq(irqd) % MLXBF2_GPIO_MAX_PINS_PER_BLOCK;
Why is the modulo needed? Isn't the hwirq returned a number between 0 and M=
LXBF2_GPIO_MAX_PINS_PER_BLOCK-1 ?

+
+	mlxbf2_gpio_irq_disable(gs, offset);
+}
+
+static void mlxbf2_gpio_irq_unmask(struct irq_data *irqd) {
+	struct gpio_chip *gc =3D irq_data_get_irq_chip_data(irqd);
+	struct mlxbf2_gpio_context *gs =3D gpiochip_get_data(gc);
+	int offset =3D irqd_to_hwirq(irqd) % MLXBF2_GPIO_MAX_PINS_PER_BLOCK;
+
+	mlxbf2_gpio_irq_enable(gs, offset);
+}
+
+static void mlxbf2_gpio_irq_bus_lock(struct irq_data *irqd) {
+	mutex_lock(yu_arm_gpio_lock_param.lock);
+}
+
+static void mlxbf2_gpio_irq_bus_sync_unlock(struct irq_data *irqd) {
+	mutex_unlock(yu_arm_gpio_lock_param.lock);
+}
+
+static struct irq_chip mlxbf2_gpio_irq_chip =3D {
+	.name			=3D "mlxbf2_gpio",
+	.irq_mask		=3D mlxbf2_gpio_irq_mask,
+	.irq_unmask		=3D mlxbf2_gpio_irq_unmask,
+	.irq_bus_lock		=3D mlxbf2_gpio_irq_bus_lock,
+	.irq_bus_sync_unlock	=3D mlxbf2_gpio_irq_bus_sync_unlock,
+};
+

We also need to make sure that the gpio driver is loaded before the mlxbf-g=
ige driver. Otherwise, the mlxbf-gige 1G interface fails to come up. I have=
 implemented this dependency on the gpio driver before, something like this=
 at the end of the mlxbf-gige driver:
MODULE_SOFTDEP("pre: gpio_mlxbf2");

 /* BlueField-2 GPIO driver initialization routine. */  static int  mlxbf2_=
gpio_probe(struct platform_device *pdev)
--
2.30.2

