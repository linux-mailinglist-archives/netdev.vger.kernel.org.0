Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B87040CD34
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 21:27:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231611AbhIOT3N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 15:29:13 -0400
Received: from mail-dm6nam10on2061.outbound.protection.outlook.com ([40.107.93.61]:60832
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231583AbhIOT3L (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Sep 2021 15:29:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IMNKU6gUtIKmXHw+VrwLPvGfO7EWCx4c/nPB6N4/YsuvDiRL9+bShLMhNPw/spbKYZT4SEGffdGT2cvvSSqk6M5Trn1bLEDLzxi8bMK0FjiFq6YMDcKkltkh7VFeRhmjBgd2tYq1wEbjyeXW24CP9or3HNXV2KqalIn7BZ5dwGsevML1E5tXghTTegvwBx+dUj6BY6E3P1qH5uMm0olyr4rzQ0VLGaH+wrSuTgjivmFWPVaZz+QZsUAUXGrF61NuDlpCj9P+ZMX+DdKRdfvwTYTuUPdReC/JKL2WGQK2lxXqpSoMm0UufYm997Yd3N2XSK+REzknaEic/goQ2AIsYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=KWuQL4Gel86ltbYscK31uyfz2fKoBm+ZM4wGBea2K3s=;
 b=N+gDyxYDPWmCulylrae7n3jE8L6c7MrpGismrxoTsm4Y7uy5oaiwvrYef1BMwlEa99g/K1TNsIrQ7m2CFvDo7AZSfTMRxbUQteUlmN1dzyQXVSyNOKdEDdBs/b3BGLbw+wkHnlg72MBFgrWlb2sDiRnVNadKz2c7UptuBNE8TqLo2R20QjdOIpoqiGqYJg6voAXcQk/454f/idJfCsQNqybnwttQ7TFP6bSTRH9ezQossM0mp92Ny31+ZQ5wwhUwT+GCIUEPJKesVDcNEBbh+QJHkZ9GJmdepFbQpBUuh4i0zIE3Qu2q1Mrw7B6kZQseFKmR/8kHFBzknAJaY6ZfjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KWuQL4Gel86ltbYscK31uyfz2fKoBm+ZM4wGBea2K3s=;
 b=Z53TLNOGkBI8oeYHwneZrn8XV8HUJzR4D0D3nojcNEEpvWU41o2coeNnhMY8DOS1ZyrxFnIuuMtWdTV1DHuKJxHERjvWJc0vmc14VcWUK7+Wov8Wk+b4PQhKTxlfMmxG4Er2MkLIBCkwu5LE36rfLywG0O0++oMPh+TjF393JWug3VxfQNJaOr8mQ6sWEF0GovEDBQFbM7aw1SKLyGkYDc7FpFfSmbzjZlckZVythsvtij2W7MPD7N13ArkmhVf51wVU/m2U5B+5dJL7cScRXl2TcQJqw+f7gwUVrkE0GfwufitZLkIwDZu+1wrbnaJm8a+1rkixUaWsPfliG8DL1A==
Received: from CH2PR12MB3895.namprd12.prod.outlook.com (2603:10b6:610:2a::13)
 by CH2PR12MB4199.namprd12.prod.outlook.com (2603:10b6:610:a7::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Wed, 15 Sep
 2021 19:27:51 +0000
Received: from CH2PR12MB3895.namprd12.prod.outlook.com
 ([fe80::a46b:a8b7:59d:9142]) by CH2PR12MB3895.namprd12.prod.outlook.com
 ([fe80::a46b:a8b7:59d:9142%5]) with mapi id 15.20.4500.019; Wed, 15 Sep 2021
 19:27:51 +0000
From:   Asmaa Mnebhi <asmaa@nvidia.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Andrew Lunn <andrew@lunn.ch>
CC:     David Thompson <davthompson@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Liming Sun <limings@nvidia.com>
Subject: RE: [PATCH v1 5/6] TODO: gpio: mlxbf2: Introduce IRQ support
Thread-Topic: [PATCH v1 5/6] TODO: gpio: mlxbf2: Introduce IRQ support
Thread-Index: AQHXkpZRAcQDwgai0k+eK2nQg5Bpo6t2INuggAMu2gCALFilUA==
Date:   Wed, 15 Sep 2021 19:27:51 +0000
Message-ID: <CH2PR12MB3895E8CDC7DC1AD0144E1416D7DB9@CH2PR12MB3895.namprd12.prod.outlook.com>
References: <20210816115953.72533-1-andriy.shevchenko@linux.intel.com>
 <20210816115953.72533-6-andriy.shevchenko@linux.intel.com>
 <CH2PR12MB3895ACF821C8242AA55A1DCDD7FD9@CH2PR12MB3895.namprd12.prod.outlook.com>
 <YR0UPG2451aGt9Xg@smile.fi.intel.com>
In-Reply-To: <YR0UPG2451aGt9Xg@smile.fi.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linux.intel.com; dkim=none (message not signed)
 header.d=none;linux.intel.com; dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4ab5089b-71c8-488d-72b7-08d9787ee877
x-ms-traffictypediagnostic: CH2PR12MB4199:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CH2PR12MB4199411E37A9C5A1383F2FFCD7DB9@CH2PR12MB4199.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5m9kSDCOwOMIUjF+EnpegzoVKAI6HvjuZN2HVPMe+18ABYhg3/SP8e3IDt9eVut/GO3ZhggkvI7OVLNQdc6vIbSn9vBGZ1qrYjDud7pzcbTwpVV5jRPEjEPiNAyOelqCRf3pd+U2Se6lHtb1it1IkruSTkZe7nzWJ2vjnGeNKMN+oq3SN+YJvBKvJmJ9raRV9FodEF5L0iOOkRQTVDTkbSFrUrO6VddoyXX1JE2MHpeUgl671XieKCvz8e43T/+DilABZh67Qj4f1+Xx/oVMKsPW+t5/B/fnJvXBTdEepIeRjfmp6dnHUEoD1FMGXQ5JXXDMLz1BuhjjuHdVr4Qkv7ft3JfQBatIBvKsWoeh+GTrIbeNkHvrqtTF8NJbHP7CFUv3d5cpoF4wXomzlrU/3J+NLf5N/xZbHKlPhWe3OwinfLNI0PyYOTRWIGs0uW//FI3UDj32pupEOYTIHL7rqYlFWSPaJgzY19UiTAgtb9ct2F3UVwUY7UwO5i1FVZobOVyLDOJy72NRolnEvruNp4odl+zhH6OYlIkD/mz878nTo937ClrC+KzqXht9hr/UDR16wrMvctEkB9xHAKbBPihuGu5kOvgse3rhxWLYCSHH/S1uPaGbCwlWtHetbrCKoGwjmoEVtxyGjGlSR5f9Mb7xFKeHGoXudRpvyKJ3W9sIFBeIgPKBHJgcb4GKpxSzMBh9SfxZePWqVEBM+4mmq488KdI1/UrnH0XQJ+AxPuo=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR12MB3895.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(346002)(136003)(366004)(376002)(186003)(8676002)(8936002)(64756008)(66446008)(66556008)(86362001)(4326008)(478600001)(316002)(26005)(33656002)(7416002)(53546011)(107886003)(71200400001)(5660300002)(2906002)(6506007)(38070700005)(54906003)(52536014)(110136005)(76116006)(122000001)(38100700002)(66946007)(9686003)(7696005)(55016002)(66476007)(83380400001)(341764005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?BaKKRZy0ZhSzZywI8APFYRhi0qVaoysZcKikyHoGtbJvyl8LU5x7yBL3KJoy?=
 =?us-ascii?Q?8iOWqP75c0B9XdK5m6x7P1P2As3ggrxQz0O8R9ilarmJvRX8ey19CIpV+CZo?=
 =?us-ascii?Q?hWsFnn7VdyyN6ChlLnO20g80INSpcMcIBLrrogCI5IIjifP5NOLe4wKmKD8O?=
 =?us-ascii?Q?C4B+Cafpkx8D0Irj/JH8mXrq3Ho02X1w1wlv//jO/dPNxr+T6dWdqz4P1acA?=
 =?us-ascii?Q?LL4mIIapco1yCnDUqNcZVpTLhpzByk4D6r6SKdr6szF90A3zOZOfTugSo4JC?=
 =?us-ascii?Q?0xuXZdFIApqsB3+CFZ6xH5PtypHJpvMJep7EyYqXdOqI3C4yz04C8q42rxPe?=
 =?us-ascii?Q?ywoAyScoWt7K5MkuXeHdKZBTcoZHL4Ru4IACEbkCAOQy2LKjElv8/cdvjZZB?=
 =?us-ascii?Q?ikAZqDBxxlnBNymAV51xz4iTpUXC/1gRWF7b8DTeFLbOcKbRVTn1t/vJ8trs?=
 =?us-ascii?Q?pf1eXrsiwaomfHZzea9g5s8raKdzjFkx1mnTr3tbE4eI1Y98OnhO42EdQKLi?=
 =?us-ascii?Q?kSFANnthaxjgKV0pFWI22YY4lCjnY1LeOhbnXp/o2nJDZPrY4p0CNbjQ49z0?=
 =?us-ascii?Q?uB3bG7Iw345Iw3+QuS7uDSbSvx3HeGsv4PtqBU27gjR6X9fKbtzGPJ/PORDF?=
 =?us-ascii?Q?2gMOG8zDYSi4dfulSEajDZRjvpClk9izzTeVho1Ww1VqIKuDKhHSPI6OnsaO?=
 =?us-ascii?Q?v0oQcVJRlzGxPfLefZ6sS16g29pyz/8kcpvKkWbQ6F7LX8vC6HrhxoXMeuuA?=
 =?us-ascii?Q?QCxxH7wckv7VOTC6ehMXu6cXkWg0SIs2lDf918UaUeiW0XtibMht9en2zwkD?=
 =?us-ascii?Q?4R/q9/+O184S9+rdBjrIIMC33ROJKeL3vgHnFbOC+1nmJdVw27wvSLjc9GM6?=
 =?us-ascii?Q?myEH5bQ5HBQWMC2lXRkN8mjGA1XZJ06+MlJ8ynY6vAxqJxfgv0bsEL7+OeIt?=
 =?us-ascii?Q?PiYvxpODLkrzj6VPC2oefdCWbMecV4WfFrbnudmpAj0kNCzRwCnTfCStYum5?=
 =?us-ascii?Q?aAHFBe+1YZ0SqpgF7rnDzrhlWh2nVXaUKEy2LoIfp3D8xhOvabr3JGIqEzqk?=
 =?us-ascii?Q?si8y0N8gNyQR59qz+NIerj5YCknM1huqlTybRCrNMxv4MLefuZDk5EfM8ajY?=
 =?us-ascii?Q?huSnuiWDprOqr7R7EbU6Oxp1xBA93GjhlFzsyL8kDcxvLid0aoPzR9p28ThQ?=
 =?us-ascii?Q?cFOCG/b4YJv6185ssme6Fu1cB/kBI+JyN/RnGGJlQ9EFE/hMqcPQJjs5JvR4?=
 =?us-ascii?Q?5I1H9MpMtdmL4gJOe7YkMWVpCRIHUZ09hUGSlD+Bk0TKSTORBqy9u+5+rVVa?=
 =?us-ascii?Q?Zvi3E7OIUX5ZVut6Mf0Njj+K?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB3895.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ab5089b-71c8-488d-72b7-08d9787ee877
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Sep 2021 19:27:51.0270
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2ZgQsk2T6dA5NnbSkTm38vrUQV431naakuX4QCkNF/rbZLOVt8lrkX5RLlppgyyThuERouE3cOsfXIK4ywmrNQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4199
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andy, Hi Andrew,

I have a question regarding patch submission. I am going to mimic what Andy=
 has done for v5/6 and v6/6 and send 2 patches in a bundle as follows:
/* for the cover letter */ : Subject: [PATCH v1 0/2] gpio: mlxbf2: Introduc=
e proper interrupt handling
Subject: [PATCH v1 1/2] gpio: mlxbf2: Introduce IRQ support
Subject: [PATCH v1 2/2] net: mellanox: mlxbf_gige: Replace non-standard int=
errupt handling

Questions:
1) do the subject lines look ok? i.e. sending patches that target "net" as =
opposed to "net-next"
2) would you like me to add a "Fixes" tag to each patch as follows? I am no=
t sure if you consider this a bug?
Fixes: f92e1869d74e ("Add Mellanox BlueField Gigabit Ethernet driver")

Thank you.
Asmaa

-----Original Message-----
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>=20
Sent: Wednesday, August 18, 2021 10:08 AM
To: Asmaa Mnebhi <asmaa@nvidia.com>
Cc: David Thompson <davthompson@nvidia.com>; linux-kernel@vger.kernel.org; =
linux-gpio@vger.kernel.org; netdev@vger.kernel.org; linux-acpi@vger.kernel.=
org; Linus Walleij <linus.walleij@linaro.org>; Bartosz Golaszewski <bgolasz=
ewski@baylibre.com>; David S. Miller <davem@davemloft.net>; Jakub Kicinski =
<kuba@kernel.org>; Rafael J. Wysocki <rjw@rjwysocki.net>; Liming Sun <limin=
gs@nvidia.com>
Subject: Re: [PATCH v1 5/6] TODO: gpio: mlxbf2: Introduce IRQ support
Importance: High

On Mon, Aug 16, 2021 at 09:34:50PM +0000, Asmaa Mnebhi wrote:
> From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Sent: Monday, August 16, 2021 8:00 AM

...

> +static irqreturn_t mlxbf2_gpio_irq_handler(int irq, void *ptr) {
>=20
> So how do you suggest registering this handler?

As usual. This handler should be probably registered via standard mechanism=
s.
Perhaps it's hierarchical IRQ, then use that facility of GPIO library.
(see gpio-dwapb.c for the example).

> 1) should I still use BF_RSH0_DEVICE_YU_INT shared interrupt signal?

I don't know your hardware connection between GPIO and GIC. You have to loo=
k into TRM and see how they are connected and what should be programmed for=
 the mode you want to run this in.

> 2) or does Linux kernel know (based on parsing GpioInt) how trigger=20
> the handler based on the GPIO datain changing (active low/high)? In=20
> this case, the kernel will call this handler whenever the GPIO pin (9=20
> or 12) value changes.

After driver in place kernel will know how to map, register and handle the =
GPIO interrupt. But the GIC part is out of the picture here. It may be you =
will need additional stuff there, like disabling (or else) the interrupts, =
or providing a bypass. I can't answer to this.

> I need to check whether GPIO is active low/high but lets assume for=20
> now it is open drain active low. We will use acpi_dev_gpio_irq_get to=20
> translate GpioInt to a Linux IRQ number:

> irq =3D acpi_dev_gpio_irq_get_by(ACPI_COMPANION(dev), "phy-gpios", 0);=20
> ret =3D devm_request_irq(dev, irq, mlxbf2_gpio_irq_handler, IRQF_ONESHOT=
=20
> | IRQF_SHARED, dev_name(dev), gs);

Yes.
(I dunno about one short and shared flags, but you should know it better th=
an me)

> And I will need to add GpioInt to the GPI0 ACPI table as follows:

But you told me that it's already on the market, how are you suppose to cha=
nge existing tables?

> // GPIO Controller
>       Device(GPI0) {
>        Name(_HID, "MLNXBF22")
>         Name(_UID, Zero)
>         Name(_CCA, 1)
>         Name(_CRS, ResourceTemplate() {
>           // for gpio[0] yu block
>          Memory32Fixed(ReadWrite, 0x0280c000, 0x00000100)
>          GpioInt (Level, ActiveLow, Exclusive, PullDefault, , " \\_SB.GPI=
0") {9}
>         })
>         Name(_DSD, Package() {
>           ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
>           Package() {
>             Package () { "phy-gpios", Package() {^GPI0, 0, 0, 0 }},
>             Package () { "rst-pin", 32 }, // GPIO pin triggering soft res=
et on BlueSphere and PRIS
>           }
>         })
>       }

No, it's completely wrong. The resources are provided by GPIO controller an=
d consumed by devices. You showed me the table for the consumer, which is g=
ood (of course if you wish to use Edge triggered interrupts there).

...

> +		handle_nested_irq(nested_irq);

> Now how can the mlxbf_gige_main.c driver also retrieve this nested_irq=20
> to register its interrupt handler as well? This irq.domain is only=20
> visible to the gpio-mlxbf2.c driver isn't it?  phydev->irq (below)=20
> should be populated with nested_irq at init time because it is used to=20
> register the phy interrupt in this generic function:

nested here is an example, you have to check which one to use.

Moreover the code misses ->irq_set_type() callback.

So, yes, domain will be GPIOs but IRQ core will handle it properly.

> void phy_request_interrupt(struct phy_device *phydev) {
> 	int err;
>=20
> 	err =3D request_threaded_irq(phydev->irq, NULL, phy_interrupt,
> 				   IRQF_ONESHOT | IRQF_SHARED,
> 				   phydev_name(phydev), phydev);

You have several IRQ resources (Interrupt() and GpioInt() ones) in the cons=
umer device node. I don't know how your hardware is designed, but if you wa=
nt to use GPIO, then this phydev->irq should be a Linux vIRQ returned from =
above mentioned acpi_dev_gpio_irq_get_by() call. Everything else is magical=
ly happens.

...

> +	int offset =3D irqd_to_hwirq(irqd) % MLXBF2_GPIO_MAX_PINS_PER_BLOCK;

> Why is the modulo needed? Isn't the hwirq returned a number between 0=20
> and
> MLXBF2_GPIO_MAX_PINS_PER_BLOCK-1 ?

It's copy'n'paste from somewhere, since you have device per bank you don't =
need it.

...

> We also need to make sure that the gpio driver is loaded before the=20
> mlxbf-gige driver. Otherwise, the mlxbf-gige 1G interface fails to come u=
p.
> I have implemented this dependency on the gpio driver before,=20
> something like this at the end of the mlxbf-gige driver:

> MODULE_SOFTDEP("pre: gpio_mlxbf2");

No, when you have GPIO device is listed in the tables the IRQ mapping will =
return you deferred probe. It doesn't matter when device will appear, but i=
t will be functional only when all resource requirements are satisfied.

Above soft dependency doesn't guarantee this, deferred probe does.

--
With Best Regards,
Andy Shevchenko


