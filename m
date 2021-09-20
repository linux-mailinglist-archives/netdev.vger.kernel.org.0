Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21D68412757
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 22:34:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232033AbhITUgC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 16:36:02 -0400
Received: from mail-dm6nam10on2072.outbound.protection.outlook.com ([40.107.93.72]:45089
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229676AbhITUeA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Sep 2021 16:34:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KqKhbyFq3zAj+N/WdrrJC46nAaGkaiK2tRVz+w03ECERVNeOZ3HTNM9OEtgo9zsIadmYsftNWi+49AuvvN9aBvO4wwWaEfQOxLQW/y4xeB97Qw+TI2Z8geMx/eA9bqALocKY6A2WgO2g9OLLM+A74FVL+YWd3cps9+8UEMdU003WBy0v1e2/PGLAqCswLPS7iYcnzmuLDYRmZdU6+OjKxbLFfrTP3L4XsXPiFegLTuIkP1cXYs4jVEmlMB7F8YrbhUa9MOvmxC0ZPhAZAldKjQtJG9Xx6f/5qyQcUftMruVzLDuz79TNsKpYeO/LYxG0AJvBCDWLJvWJRNZnuAGYNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=36yHqRT378cT0gVTkFTmtgtCuYH+/lNAImNzMyqsxsw=;
 b=cUg+B64ACFMlsLA8EOrIEB6Xs+t7wzLGajk6oqNBf3+gqwTqOLu4ssEzyA/TjOztZLKQRB/vJTasrdrUZ91Wh3JONYaNe8kEWgcE1bnNgUEPZmL5lMiDH5udGFyae7kcnwNu8CaMLhTWcIemWMmSlZqVaRvAgKmflRjW1BSBjpXxKMRzRhxiFuO9icF9wqLxO5ZUYk83aZvgGNp2FWlbH/cqElTnG9J8z1qk5AeMPlr/bta+EbtSh56EWWeTrIeBlH8HiCf80b2WmEQctwqOL9aEtU6nIKHVgslsxBPrLdlfQXUgiVBT20VydvfsGqOUsmPdasRQhCjstrOWDTnevQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=36yHqRT378cT0gVTkFTmtgtCuYH+/lNAImNzMyqsxsw=;
 b=AZUO5us79jkSPsLlk5NTOUlUBcGLeTWemnuhy7smsnm4zI1c1gFkGEVVFQ1jhc39UVrUswUI3S3q9lBGV2FT3095BTj/3TAB2TIjPS1Bj0Ga7yqd6+zL16+rbKGfhY1Wxp2PiEAkD3874mBMXcyUHz2SklNlDmuEHZUiGuSnCKtx2svGJViLGaCeozDaOarPDOnkE/iJs79S9YYN67lpdEkZ/nmRW21Qv0plNB562shAw0oLrfbkAPuMRgGPnVnSmez2GTUFWmXwUu7ACAPcuyAJ9H8T7LJzesN/DPOx5+5BKLT7rv4KNMUkWy2sOh/aCQ5Y7MNvgHzBiX+BqPN5UA==
Received: from CH2PR12MB3895.namprd12.prod.outlook.com (2603:10b6:610:2a::13)
 by CH2PR12MB4954.namprd12.prod.outlook.com (2603:10b6:610:63::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.18; Mon, 20 Sep
 2021 20:32:31 +0000
Received: from CH2PR12MB3895.namprd12.prod.outlook.com
 ([fe80::a46b:a8b7:59d:9142]) by CH2PR12MB3895.namprd12.prod.outlook.com
 ([fe80::a46b:a8b7:59d:9142%5]) with mapi id 15.20.4523.018; Mon, 20 Sep 2021
 20:32:31 +0000
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
Thread-Index: AQHXqoEVVyA+enuCGUKWJgFkwmB1oKumsuKAgAABitCAADi7AIAGX2jQ
Date:   Mon, 20 Sep 2021 20:32:31 +0000
Message-ID: <CH2PR12MB3895ACE512BA0471889E38BBD7A09@CH2PR12MB3895.namprd12.prod.outlook.com>
References: <20210915222847.10239-1-asmaa@nvidia.com>
 <20210915222847.10239-2-asmaa@nvidia.com> <YUNPO9/YacBNr/yQ@lunn.ch>
 <CH2PR12MB3895D5E16EAA1D3E5796C177D7DC9@CH2PR12MB3895.namprd12.prod.outlook.com>
 <YUOAHMmaSf2gs6ho@lunn.ch>
In-Reply-To: <YUOAHMmaSf2gs6ho@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c5ede59f-427e-495b-9098-08d97c75c5a4
x-ms-traffictypediagnostic: CH2PR12MB4954:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CH2PR12MB49546E00360FFE722A1CA628D7A09@CH2PR12MB4954.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4502;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5msDLayzazwxjQfYA4L9ye+SZXSk2z94aCPe2tNsTsvpVehm3MVO1RNEMrK1PFa3gGszqEeWGXYXFoCW1BcVkgVzPelnhGMwGdhhx51jFTS+UgkbEWHutxY0HcCEBHag+kg/WXDxRWGh5xJ+7QIGLFRG8rZAuTZrWPNXVXjwcviRNeiKpnhcTJa9V7rJfsyXvboYvgd6bwqse+l8KlGtj1gMKNc9xiEcKvFBJhb3if1sA1kSYdG81Xcvk2w8POgnbTRjpY4jQ1UVi8RzfGnY+3c2Lnr3A2cqi3HW4vUOieadoJOVg/fFljvhl0K52o7CKdNPcoX/BSFZXxF0RWnYk2uWxSFiBR6FkFcI9d/9y13x9JaQl+kbDvxGdQd1TCHLZluPkXZbd8F2IpyP1Qn80JLrdvt6sESQx3Owyfv8JtwOJFXIlscQXUzWvk++w7EuAlEDfcB454VZ/WVFKLjfX+6BsVWI2fRPBrl5boXv/XlvW6LIZXjP4SHxhysXpeJ6QgdFV+VgcKUisbZ39EwMmd5FdjRQARyeL6OmwQPxX1QVe44Le4Y23CQoBee/o2w+QLBGbIwYWOr+Mekl74Dv+/vVle/W99yv25ZiPkmttG4uBLqrvfsAddQWVk3mt2FJPVKa7WFZNWQZP/tqwPrnya0JhstBMd6PgX5uv7mhMF4rYRRhpzLOOYyCviXxudShcJqv7bQGfQs0s5+Eloumqw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR12MB3895.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(508600001)(76116006)(2906002)(9686003)(316002)(4326008)(83380400001)(86362001)(66476007)(66946007)(8676002)(54906003)(8936002)(6506007)(45080400002)(33656002)(55016002)(38100700002)(71200400001)(66556008)(7416002)(66446008)(64756008)(5660300002)(26005)(52536014)(6916009)(107886003)(7696005)(122000001)(186003)(38070700005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?tdV+RMU9ITUUMIFrKffPlhpf3pfKLAsNUYDn1SS2GgphV3wuR9Qmrgk+3buk?=
 =?us-ascii?Q?4Heg53YzNsRr0puwlAHcVGeihkj3ZJEjyw6RD8Db7obfM5jXwWU7dL5A86GV?=
 =?us-ascii?Q?TXS/jYHiAV9e/n88WWeneYGY/XKehUZlHbYzWqf9Fsnd89/+727A6ZLB3Xno?=
 =?us-ascii?Q?xKbZKZFW30vsZt3yTE0lkXIUhqOjECsT3wuz37VtMLpXm5zJMugtOAv+Y9i5?=
 =?us-ascii?Q?vLFvk+MXYstZRrcF3B/OpWdmcRDP/qP2d1slkppR2fSl3ZiAKDYzf8xHsqEO?=
 =?us-ascii?Q?puE8NfQ0y62FF4mvfOZ1h+oU99eGB//+9lbYJyqYFdi744yQB373sJVzeloA?=
 =?us-ascii?Q?MRP3mXlmbMQknglGNpcpcIg6hs+OtYaupeqweSTQ0WF2sxSPYCyFDblKLAuf?=
 =?us-ascii?Q?maY5I/0+VUnPcvUwb/XpbNexmPk08LBmbPkL93swWYuU02aPQVz5Uwyzdtvb?=
 =?us-ascii?Q?ZUxWc5CkexZS84lJubnT/ZFSxtf+RVOlLMJ61HdrR0+JIiT/yoFs9C2zZ0jY?=
 =?us-ascii?Q?oKbNX2fRkfGWUHMdMy8Z1GjuVmJe3zFpwNk0nCewTn/1DqebY/qcZUvTF/ZT?=
 =?us-ascii?Q?CPYAIUOuB+abYA8cUa2RcYzr+otdLHzdqxO7T4bj+96qEdI2XhbFasqahwFJ?=
 =?us-ascii?Q?3ib8E1FRsySP5f8IQPwe0Jg4N3s3GMOYnyVFSdYP/b/ADstq1WE5/7EgGz3e?=
 =?us-ascii?Q?/U/LcbujZHMWCBtPRi8qqsQheHAerVRcdhi0SNwdjEIR/cbooXNLcwVjtHPr?=
 =?us-ascii?Q?0sO/oZNsxosnptLh5F9P+GZ5L0bu42ciorbSJe7uFznWb7kfjuabvCSb2sKc?=
 =?us-ascii?Q?9Jbha123v6K/i9/mW3pSFgIVLEsmb8fyCKNiqWPB+RZ2DZnenD5PRW4LZPei?=
 =?us-ascii?Q?wz/aYcR+3s7Qf5/m6E1fUmH4tFHidLKaamjhmt5hOGZ5fX2+N1IHSvMiR3ZV?=
 =?us-ascii?Q?Uc5HJIwCZBjCNwXb8tN411TlxIxpqqrMa23H23kPe57ojrO6/sR4PldtbhhQ?=
 =?us-ascii?Q?qUC86txxS17GebhpVhVSn9DTvHnEGR+uOd+Qbf0ClPHuF3CDxpwEqjfPNjaA?=
 =?us-ascii?Q?h6rBjd+0ipVguUJa3NG0gZGVflpMeToCyNLEmwffb2Cj8z1vdl6fjdVWnZvD?=
 =?us-ascii?Q?Pb4nIUCUTkksSH0I4KevdIx1oKMI1rP40B1MdlJLuDvdHmxXkyxO6ed2sn3L?=
 =?us-ascii?Q?HMIJvNkcXbz8Bb4bFCc8j8UzCgDy613QoibhRRjOomoW29XoQyjBROFrC6ce?=
 =?us-ascii?Q?AASpTBo/t+o8cUeNipJz51+0G7FWZ9Ri9AMavXgZXimFEWJGOqQAeMPALyvo?=
 =?us-ascii?Q?eB+Aur8+7tpNDwoyng1WsImR?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB3895.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c5ede59f-427e-495b-9098-08d97c75c5a4
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Sep 2021 20:32:31.7081
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ARxQJs29NZfo6B0O8O/j5OtYG03tGhVqsDyurWtlMCw9+jDbmmpDu5kyQzDFFuZKoIJIocL9H7Mg1KrIkb19BA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4954
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > +	val =3D readl(gs->gpio_io + YU_GPIO_CAUSE_OR_EVTEN0);
> > +	val |=3D BIT(offset);
> > +	writel(val, gs->gpio_io + YU_GPIO_CAUSE_OR_EVTEN0);
>=20
> What exactly does this do? It appears to clear the interrupt, if i unders=
tand
> mlxbf2_gpio_irq_handler(). I don't know the GPIO framework well enough to=
 know if this is
> correct. It does mean if the interrupt signal is active but masked, and y=
ou enable it, you appear
> to loose the interrupt? Maybe you want the interrupt to fire as soon as i=
t is enabled?
>=20
> Asmaa>>
> YU_GPIO_CAUSE_OR_CLRCAUSE - Makes sure the interrupt is initially cleared=
. Otherwise, we
> will not receive further interrupts.

> If the interrupt status bit is set, as soon as you unmask the interrupt, =
the hardware should fire
> the interrupt. At least, that is how interrupt controllers usually work.

> A typical pattern is that the interrupt fires. You mask it, ack it, and t=
hen do what is needed to
> actually handle the interrupt. While doing the handling, the hardware can=
 indicate the interrupt
> again. But since it is masked nothing happened. This avoids your interrup=
t handler going
> recursive.
> Once the handler has finished, the interrupt is unmasked. At this point i=
t actually fires, triggering
> the interrupt handler again.

Asmaa>> mlxbf2_gpio_irq_enable seems to be called only once when the driver=
 is loaded.
And I will actually remove mlxbf2_gpio_irq_ack because it is not being call=
ed at all.
After further investigation, that function is called via chained_irq_enter =
which is itself invoked in
the interrupt handler. It should have looked something like this:

static irqreturn_t mlxbf2_gpio_irq_handler(int irq, void *ptr)
{
    chained_irq_enter(gc->irq->chip, desc);
    // rest of the code here
    chained_irq_exit(gc->irq->chip, desc);
}

But in our case, we decided to directly request the irq  instead of passing=
 a flow-handler to
gpiochip_set_chained_irqchip, because the irq has to be marked as shared (I=
RQF_SHARED).
gpio-mt7621.c does something similar.
Moreover, whenever an interrupt is fired by HW, it is automatically disable=
d/masked until
it is explicitly cleared by Software. And this line takes care of it in mlx=
bf2_gpio_irq_handler:
writel(pending, gs->gpio_io + YU_GPIO_CAUSE_OR_CLRCAUSE);

After a HW reset, all gpio interrupts are disabled by default by HW. The HW=
 will not signal
any gpio interrupt as long as all bits in YU_GPIO_CAUSE_OR_EVTEN0 are 0.
In mlxbf2_gpio_irq_enable, we configure a specific gpio as an interrupt by =
writing 1 to
YU_GPIO_CAUSE_OR_EVTEN0. I just wanted to make sure there is no trash value=
 in
YU_GPIO_CAUSE_OR_CLRCAUSE before enabling gpio interrupt support.
So pending interrupts in YU_GPIO_CAUSE_OR_CLRCAUSE only matters if
YU_GPIO_CAUSE_OR_EVTEN0 is set accordingly.
Does this answer your question?

> Please also get your email client fixed. I wrap my emails at around 75 ch=
aracters. Your mailer
> has destroyed it. Your text should also be wrapped at about 75 characters=
.

Asmaa>> Sorry about that. I wrapped my outlook emails around 75 characters,=
 I hope it works.


