Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C34640DE8D
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 17:49:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240144AbhIPPuP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 11:50:15 -0400
Received: from mail-bn7nam10on2076.outbound.protection.outlook.com ([40.107.92.76]:25056
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240126AbhIPPuO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Sep 2021 11:50:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gzRgLlVEoSOt5AdyX9Xu4laDQtraD+4LEYJSirDXGNnjPUuXCDDLFLSaygG7DST/I2rJlYzJ0xI53gOa4K1O+xLwCBniEyWKIYavaB2pBVj4FZ7RGAL9e0ZGfyckz2hyu5AFvAUlHcJTlQxH+iqP0WLY2fEMfz9BpgAJAB5N0dDjAWXrHmEI+aK99zMjpRp5iDRPRx+Izszq3VdyCuxP2DzHyt2ot5EObPoecD5X+i9GX9RnXTKPJoAf909oS9vpxXRLMki3tudzF+W4Xb2MGUPj85VzW1Nek0mdUCgTCiD1k/Z4cC79BXqGvvUv5bYVMLfB7hwktr4v4H/bOatR5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=sUzza7z5a95TMuwSVipHSQItmdJRvTDuiF5ffNkYPlc=;
 b=n165IOiYajsSy98N2QLT6ops5FFRiEHYEmpcui8m6JpIVuDucwzjUMYTKx5BaeJiDoEhrj7KSx57yubWPBiS5tufCJNc+PYmkSat3hvTyn/Ditk6wjJUiBCVVhx9bA40yjEBCWT0du642iG4zq++xNhn5wABB94q02VycfquOp7urqyqtPm5Z/58AMAWKPUYy4CithQ6OIqTsxtknmSFLdI/b2SxtHWccjGMupMjz7SeZHw2vejio1fQrZi06VUNtwWgJRZfI3FwkOgi/n2LacnRNInAeCDyFgs7+0teoVADfiGXlEk0ky5Wy+pKzZVq/4f9uUq/Mu94EsGS1wihGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sUzza7z5a95TMuwSVipHSQItmdJRvTDuiF5ffNkYPlc=;
 b=dMdgQWZwPlKxLtY34Mm7zZHJz4OyagOiX/syR0AAJIjFM20tquXrI+lvyMDEL/qpxwnwhO0xgPViNHeRpsr3GEI5ffaYlGikiFotovf62TN5ga3xY3JgZs4DcqPbidOVXPZGq0oMUt+s8KRhOVfnV5RA2aGEUfXtDY+zGNM1ma9Y/MDu2jch//BJVoZhheGwkXFqtw/+DNu5tvHteeZsZlxUIxir38YVdmdJsLhO/xreCae35Uo69sNO4nhOt2kIs1iaPNEPxexaH1NQvzokowHWqB6scO+sH+YNOPLlWjdHoVxRCWiYneMsGoLxK0aKj9f3rXIPOxAb6J7IgH/VeQ==
Received: from CH2PR12MB3895.namprd12.prod.outlook.com (2603:10b6:610:2a::13)
 by CH2PR12MB4891.namprd12.prod.outlook.com (2603:10b6:610:36::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.18; Thu, 16 Sep
 2021 15:48:52 +0000
Received: from CH2PR12MB3895.namprd12.prod.outlook.com
 ([fe80::a46b:a8b7:59d:9142]) by CH2PR12MB3895.namprd12.prod.outlook.com
 ([fe80::a46b:a8b7:59d:9142%5]) with mapi id 15.20.4523.016; Thu, 16 Sep 2021
 15:48:52 +0000
From:   Asmaa Mnebhi <asmaa@nvidia.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "andy.shevchenko@gmail.com" <andy.shevchenko@gmail.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "bgolaszewski@baylibre.com" <bgolaszewski@baylibre.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        David Thompson <davthompson@nvidia.com>
Subject: RE: [PATCH v1 1/2] gpio: mlxbf2: Introduce IRQ support
Thread-Topic: [PATCH v1 1/2] gpio: mlxbf2: Introduce IRQ support
Thread-Index: AQHXqoEVVyA+enuCGUKWJgFkwmB1oKumsuKAgAABitA=
Date:   Thu, 16 Sep 2021 15:48:51 +0000
Message-ID: <CH2PR12MB3895D5E16EAA1D3E5796C177D7DC9@CH2PR12MB3895.namprd12.prod.outlook.com>
References: <20210915222847.10239-1-asmaa@nvidia.com>
 <20210915222847.10239-2-asmaa@nvidia.com> <YUNPO9/YacBNr/yQ@lunn.ch>
In-Reply-To: <YUNPO9/YacBNr/yQ@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bc52171c-c330-4aa9-7d8c-08d979297b86
x-ms-traffictypediagnostic: CH2PR12MB4891:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CH2PR12MB4891A0092774242AED51DD84D7DC9@CH2PR12MB4891.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QaJjQa6iYvTaytKsEZKL8DCSaAZYRB3Dagj/rCY65OQB4Fpsohj95SEDZJmPVJgZZ8jghi4c+VgBJAPzcCzU+ZGsui/8Z4H8iMiV1q37Q9XYwxSkcN9OqXZ/avw+FOzQ1I6EuvU8h9gw+XwGhkhkaFwjhiurgjYGPZpFqXOoOxTvmJg/7Nt9eg1pP9Zs0uZQI6c6QIE4iApP0Qh+gr83GYH2AaS15Ndx7E7j7Lwui2lECP8F1bg2IaR1aBg3/jL0M92aoEr+LY9pJYJbWLOtissqy47hXY9L/2nannrNVgWHVRftFsHBccFSCj0+qrBYozAC00KLjllBoqDYZNp/tlrYh0vtXCLz9bF2dT6GES5L/Vmx0LyArqAEQAYEeb7f5P/Ix2p9apDXxonCxWr/8wEYfTX6W0j1dAEzvHR3zXd36X9Fy5a3ER3KpznxB7bMrIVt/eZ2KRY8KV/rI73hNUakMf+zYtnZHTeZc+0RsQ3vbW5xKwkIVLz/qXYxCqZmRHFxcs34//Np1gK3oejy8RRRImKhEbVTDr3ipi1hV4Iioos+fnjK89DJ5VWHyjAnKQ7VBhR75nJo4zP16p2YZGqhDSVilAEDOIvBz7kDJVMqySE3GQ9ZZPwC6TxNnNF68OamTDnRdJS5Is3sB6JOrGaSG4+VPqk09UDi0rtw4IM2oiNcs70irwPMCJQLiQBarzGyiGiZuWfwTV4WZzfgbw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR12MB3895.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(376002)(346002)(396003)(39860400002)(5660300002)(6506007)(316002)(55016002)(54906003)(66446008)(66476007)(52536014)(4326008)(122000001)(8676002)(186003)(64756008)(8936002)(76116006)(86362001)(66946007)(478600001)(66556008)(26005)(7696005)(71200400001)(6916009)(2906002)(83380400001)(107886003)(33656002)(38100700002)(38070700005)(9686003)(7416002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ifJjatJ7eB2P/ravyLyPbh9rhKYy61WIklblQ/gcI22N7wHIk+IYHVUA5DMK?=
 =?us-ascii?Q?hoeDWBtUDh16xsUAtKKp93EHpVkm7i6BkzlXcXPxX3X98oynjiy8UBSMIw0C?=
 =?us-ascii?Q?l2yfbYDk/6FyzhsVE6H1SSSPdR4jeTLEh+gRiZ7oXtu1IxRzvMqIxFBGLwed?=
 =?us-ascii?Q?7+UhhqcBI3YStpKEq+DudAN7rD9rwEknx76wXInxiVJ3c2QcosQoDG8V1M5f?=
 =?us-ascii?Q?RwE54P0xNinZQipKjd0l0OX3VFfqA0JgZYhAPb9lgKjX804tGzLKx5RywOvn?=
 =?us-ascii?Q?7f7UcphTA0fQD7BVYG6jPZjrhiH37iTPGCmF84jLD9GJlasJrMS+P2zfJg5y?=
 =?us-ascii?Q?Uu17aFGMR7oWzVgqet2jvivQ15RYBauoHpW3wA6hDknuIqLXx2yhDyTtX/jt?=
 =?us-ascii?Q?P4f9R0rd9iMik/20Ja24nJdDobUT4bphNGMqyIlEWYWpEjGntX2gRMoGjV9c?=
 =?us-ascii?Q?pQQYDfYH4A69fZL44+cy2mVl5wB/ZnzGL+O7HLeNm31I0S11ywJwaMAbjZ1x?=
 =?us-ascii?Q?5uC8LLxPIiyg0phQgWPr0oQNgd4XyDTxDRp675mEjyLA3iLW9JAMd8ezWoij?=
 =?us-ascii?Q?+DSKwi3gbHtSffW6NaenfHkNbKMNt9Yh9IyiZ4DOhE2jKrj0QDELI2pkKIrx?=
 =?us-ascii?Q?WZBo1ez15upF9gFaypnkb8Sss2gvz6lV0MKDLjIuZzFAdl1tWkZaYTK2/XL6?=
 =?us-ascii?Q?kA5cuSyIz98Iw+nKOG/qiVlPMscEP3pMcWSHtfHkUmqw3NCXTt/PCDOsCSA5?=
 =?us-ascii?Q?AUrq0S1tGs86vgXvOc9Mfd0o81k3U6pZtXn5oRyYIFVwUTYZW4lQLBHLcL29?=
 =?us-ascii?Q?EBEtAMMV6B2c8AdeufiHQNaOXMF9Qf4CcKfWfbtSF85jjyC2m5rxrfvB785L?=
 =?us-ascii?Q?Y6JdRebyArELlGT6b6GCULBwiuGFJX4IcdPAaj45fZOfFU7GxSQO0fK/ztMK?=
 =?us-ascii?Q?xMB3sWMO+x8ckNf668yRs1Yvd1m6pQVgvU+ghjJm8t8snQaeOCdyr2dvIhTT?=
 =?us-ascii?Q?rtWkOUR/h14h0xqymBH4UL0QazF2yZHrBN5UiABYZ0+aK6WmojsDdMgjl6nA?=
 =?us-ascii?Q?kAQ/UKokAFmQslEtrnzkj3/wj6tsp4syLcdOpQT5i4BvecR2srQdWDD9HeWd?=
 =?us-ascii?Q?6QNnqoNxNf+fN9Inklb/id6u70XbuJzp7L/ssEZjj1KwuwqVOKJoeIKMr04m?=
 =?us-ascii?Q?NLMQIjwclKHKsjS9jLr8YCj4l24LgC3MWI+XH40MacDoWhuL2Yd9GgwVWJuB?=
 =?us-ascii?Q?dPYMHwndTvrTJVqeV1UFCYcU7ZZLTBlB2x2Nr3e7LKkkcseu1VD72XNBuB+t?=
 =?us-ascii?Q?xDaskvc3UkdWxi/z43hCvZ/8?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB3895.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc52171c-c330-4aa9-7d8c-08d979297b86
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Sep 2021 15:48:52.1108
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +Q5t27dCDTPBbNtSiFPb3I2hiAdUU5MAFQbZDWzH4DmwizZnROjuTzjFte9yyXl9a6NwHG2AucOEVQG6+vScEg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4891
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +	/* Enable PHY interrupt by setting the priority level */

This should be an abstract driver for a collection of GPIO lines.
Yes, one of these GPIOs is used for the PHY, but the GPIO driver does not c=
are. So please remove this comment.
Asmaa>> Done

> +	val =3D readl(gs->gpio_io + YU_GPIO_CAUSE_OR_EVTEN0);
> +	val |=3D BIT(offset);
> +	writel(val, gs->gpio_io + YU_GPIO_CAUSE_OR_EVTEN0);

What exactly does this do? It appears to clear the interrupt, if i understa=
nd mlxbf2_gpio_irq_handler(). I don't know the GPIO framework well enough t=
o know if this is correct. It does mean if the interrupt signal is active b=
ut masked, and you enable it, you appear to loose the interrupt? Maybe you =
want the interrupt to fire as soon as it is enabled?

Asmaa>>
YU_GPIO_CAUSE_OR_CLRCAUSE - Makes sure the interrupt is initially cleared. =
Otherwise, we will not receive further interrupts.
YU_GPIO_CAUSE_OR_EVTEN0 - All interrupts are disabled by default. This regi=
ster is what actually unmasks/enables the specific interrupt to start "firi=
ng".

> +static void mlxbf2_gpio_irq_mask(struct irq_data *irqd) {
> +	mlxbf2_gpio_irq_disable(irqd);
> +}
> +
> +static void mlxbf2_gpio_irq_unmask(struct irq_data *irqd) {
> +	mlxbf2_gpio_irq_enable(irqd);
> +}

Do these two functions have any value?

Asmaa>>
This code is actually not being called. enable/disable is what's being call=
ed. So I will remove it.

> +	switch (type & IRQ_TYPE_SENSE_MASK) {
> +	case IRQ_TYPE_EDGE_BOTH:
> +	case IRQ_TYPE_LEVEL_MASK:
> +		fall =3D true;
> +		rise =3D true;
> +		break;
> +	case IRQ_TYPE_EDGE_RISING:
> +	case IRQ_TYPE_LEVEL_HIGH:
> +		rise =3D true;
> +		break;
> +	case IRQ_TYPE_EDGE_FALLING:
> +	case IRQ_TYPE_LEVEL_LOW:
> +		fall =3D true;
> +		break;

This looks wrong. You cannot map a level interrupt into an edge. It looks l=
ike your hardware only supports edges. If asked to do level, return -EINVAL=
.

Asmaa>> done

> +
> +	/* The INT_N interrupt level is active low.
> +	 * So enable cause fall bit to detect when GPIO
> +	 * state goes low.
> +	 */

I don't understand this comment.

Asmaa>> removed.=20

