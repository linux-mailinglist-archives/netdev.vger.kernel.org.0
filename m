Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EC4C41CC79
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 21:15:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346510AbhI2TQc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 15:16:32 -0400
Received: from mail-co1nam11on2042.outbound.protection.outlook.com ([40.107.220.42]:38657
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1343734AbhI2TQb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Sep 2021 15:16:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MM+8KeO+85U5JRvLJ9FMKI0flNav+hzKvYUM3/v8utwSBaPiuDqbUz2SNCyCMShEuOPVUt5Rc90tvH75TeIA/b5lsN7czEwTEg2yeBGdiK/qz8RE94N1mplWtGo7BSLsa820JlYo1rMEsea0oNpXops8Lt50JO179Fhwfm2m1aTfCFQOBqCH592e0tDfF6motQ0Hhy6ucvHME9Punu75ssEmzOaxSIg86SrZWbG0tyKoEivuy9m8SK7fq9rZzDFn40czNTktEUTreWEIUMGeuNMG0EI0eOo9xjXvcDbsVDx37CMZIhcFKCPLIoZm/QQRrmJXxMb46Y6QaUkaUKAOng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=QeKQnhOFmjy+rfUzeL+/9SYI275SGkujxtpY5+I5nuQ=;
 b=hETm1uSVC+Mr2yj1mQeIl+LX+48brMyxgCG3GpIUvRGS7GHj3Ehplu2R1rEDoNwGi3QwEKAd1ruRvZU2pRscx46xMPMsDg2WTY87Yxjsh3/ic7Q+zvS2+e7eJYw1PL+wa391LDkTsyiSL6YCo+NWY0DFNpNHFAXS6zg6cHrsharOsB7eT556ZVx9LOY35aWVTyW4k3lGx0DizpOm3iz5N0Iylqt9uUFLyiDXmE2Ix+p8OfDZRC6paiZJ5quU0fb+6Pt0zFBIdygs9VcSxAxRd1h6ym4BsoYp9B3/YbuFjXgxCE502L4tDY3ZOS0h+B3txg3T5tlXsejprBnVPn+Vow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QeKQnhOFmjy+rfUzeL+/9SYI275SGkujxtpY5+I5nuQ=;
 b=q1bTEus5wge+9II5DnbT29AL7B8A5SstAgv+0hQg2hqEzgVOsfOn+eSM8JQyNUHgqZYMY5IRzzCP9WK+koF7nNzCAmlhg42BWn3gYr6wKnMMeqW60cgd7JtZotwS2ix1oKs7Qfyv9ZNbGSdQk/fDrKTaVrXCk95nYyySsGomM0bCmrWY/4f2cuJbKldFGFNMq+bIsXfNO8Fb9WJs5OrmwRmDkkonekYjbTdEZgdEtldg4vvKHLC1TEUqjpViuP9xOLok7OEzxRanmkXnxOhl6YTMIC0jpDViT5HALjCE0CH3E2Vo5ns8mzjYiE3OBclYr3XOZM9p1+quUckxw27yDg==
Received: from CH2PR12MB3895.namprd12.prod.outlook.com (2603:10b6:610:2a::13)
 by CH2PR12MB4038.namprd12.prod.outlook.com (2603:10b6:610:7b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.20; Wed, 29 Sep
 2021 19:14:48 +0000
Received: from CH2PR12MB3895.namprd12.prod.outlook.com
 ([fe80::a46b:a8b7:59d:9142]) by CH2PR12MB3895.namprd12.prod.outlook.com
 ([fe80::a46b:a8b7:59d:9142%5]) with mapi id 15.20.4544.021; Wed, 29 Sep 2021
 19:14:48 +0000
From:   Asmaa Mnebhi <asmaa@nvidia.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Linus Walleij <linus.walleij@linaro.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        David Thompson <davthompson@nvidia.com>
Subject: RE: [PATCH v3 1/2] gpio: mlxbf2: Introduce IRQ support
Thread-Topic: [PATCH v3 1/2] gpio: mlxbf2: Introduce IRQ support
Thread-Index: AQHXsLi5/ezHFM2t80qMnoiP1wWjOauzEi0AgADJmACABBI7EIAAAriAgAACbtCAAAsjgIAAAWRQgABFnwCAAxBt0A==
Date:   Wed, 29 Sep 2021 19:14:48 +0000
Message-ID: <CH2PR12MB3895BD75A1BD0048A93B4A51D7A99@CH2PR12MB3895.namprd12.prod.outlook.com>
References: <20210923202216.16091-1-asmaa@nvidia.com>
 <20210923202216.16091-2-asmaa@nvidia.com> <YU26lIUayYXU/x9l@lunn.ch>
 <CACRpkdbUJF6VUPk9kCMPBvjeL3frJAbHq+h0-z7P-a1pSU+fiw@mail.gmail.com>
 <CH2PR12MB38951F2326196AB5B573A73DD7A79@CH2PR12MB3895.namprd12.prod.outlook.com>
 <YVHQQcv2M6soJR6u@lunn.ch>
 <CH2PR12MB389585F7D5EFE5E2453593DBD7A79@CH2PR12MB3895.namprd12.prod.outlook.com>
 <YVHbo/cJcHzxUk+d@lunn.ch>
 <CH2PR12MB3895E69636DDB3811C0EAE3DD7A79@CH2PR12MB3895.namprd12.prod.outlook.com>
 <YVIXNEmhoMW7c1S/@lunn.ch>
In-Reply-To: <YVIXNEmhoMW7c1S/@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9407d020-c849-4b8f-5a41-08d9837d6799
x-ms-traffictypediagnostic: CH2PR12MB4038:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CH2PR12MB4038B769C499A66A529F2FD8D7A99@CH2PR12MB4038.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: EJ7TCUOZuGLiLK9o26EeXFMqNr/EDuaB+YSVrUOgbYlEJBIuuR5vdpyJegn+O8iPbG1ej1wr06tPcuGG+pfH7ZS6m5aGUDPlvnuFTaKnci0KeGZF8bZTBce7YWENThFCUX4hS6T+CcI3hRo3VObj+D5/3YP22ILTX+H0Qk7fCEcAUla/SKey3Qg8m8UBCox5sSJYtcaBfKD5p2qtkWC8Z8C5T9CEXJJ+ITiqG/DzwROwaSDmn8IZEplrRQCIl9uLZ3bIAwL46dkki/uDAVDmTjupPbxtU9W4Pvz2+pJocYkhaqaU80/4R55BbASsXc+lbb563f4QQhfSIYO9JgNp/to0EWys0QcSZ+raKSArjZA8ac1GPhyJbhEif8BBUi4WUcINulpudtrDcdwnnGz9O/2/tn9iUpape9+g/YMNw7y4q0Yi6rNIS5xcy7rcWAc0YFlqFtwbRIF3sRrm735ecPoSIvWaIdWX4p967WpVs7YYkiG659j0YWH7gF/UjI989qQhbSAAVUqyjHmDFWYBRaTpCf+Ywltp9wdA4FC8MjOTZ8euf5hVa/5tlQqNet/fs86spoMNVYBm33FA8FHD62hXQ12CsEqVjicYmb16ZLzx9rMZZF9hiR7ZAY7WlJRH92o42Buv2pVolC2jyBtKMoxaM+1M2fSOMW3ylDULEaT7JOUNJyMy0Kzv2Og66Hpgqjyo1InWqamLfdWk0Lv5wA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR12MB3895.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(186003)(64756008)(7696005)(76116006)(2906002)(9686003)(66556008)(8936002)(38070700005)(7416002)(66476007)(508600001)(5660300002)(66946007)(55016002)(66446008)(86362001)(4326008)(83380400001)(52536014)(33656002)(8676002)(6916009)(122000001)(38100700002)(71200400001)(107886003)(6506007)(26005)(54906003)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?cts3kknhtMMeEPa/3/T5rqP0Fi2xYTXUuP8OpaNEmQO2omekRlNK6IwNpQ0U?=
 =?us-ascii?Q?NNCE02t8E7kfuDd9SDSoOZpJlUwH8o/DOc3+lNYz7PZAGLlNmIGAsu/CC1To?=
 =?us-ascii?Q?cJkze3hWXuGEwIqb/B5HqOmabmb2oh1PCyyi8OXcB1csnswmXZ/DklCimRpL?=
 =?us-ascii?Q?uo7xY2r5fYwIWQeRTTqhqy3T2ptHE7WFYcBuf/Vg0hMgY6eAqG1gFyJ1eDbA?=
 =?us-ascii?Q?gEDic1ba8EF66MXpkmRjaSk6acpO7KMr3jyuSLhweAQwnjNrn03R5+pMgFsj?=
 =?us-ascii?Q?bmuhkcutVXs/n12ljCWIiCWOvDBIep1DQ/Ch62hnjLvAuNJYPBDyGa/7AT+a?=
 =?us-ascii?Q?etx1t8TgRJPCIQvyXUTqOk3zJz7v0QOttYutwEKEadCQ59bjtjCbC5Vustzb?=
 =?us-ascii?Q?ZF1zNp9EL6v7Y5ZS3d1D0yfkk76zDB5rb5M0xl5aLCgdxwtNxEMkkHrE5X5x?=
 =?us-ascii?Q?3qu84+VnCb0J0Rlumz5cO9Sg5QcUbGAGI6NvuqNgGzzAdgRGfzsZs4aGyM9u?=
 =?us-ascii?Q?ujRQfL7vkxr8GaEtAx6JtHFX1UT3KjR3RPWI3vVpWre08+jsoSQF1f2nGd4h?=
 =?us-ascii?Q?YDCVHQCM0id8E2eSQ7gOmIfmv9vjyK99vm91JpeuP6EN9oYBbMXj6AP9oxYV?=
 =?us-ascii?Q?vidAz/Rkkxq8yqlnUFucIHOPONSyA4QpHbXkGEruG+AjTH+vqYmSccvGy/RC?=
 =?us-ascii?Q?GwXmkpn6xMkgUYiUYL3IaJCkEn04PYt7XN9eYxLpms67BPyY+3l8aoQoeIwA?=
 =?us-ascii?Q?XjGy5A6azXYys0siZ5NBUiGmfX/TLvK7HlewFkWWYaOz5JgVMy0sY7hhdS4s?=
 =?us-ascii?Q?uz3ZI4QSeNonnrHgvMM129KujT2RvQZb9yEXoyoYvDg1J9HOrYjGnwBBXQQH?=
 =?us-ascii?Q?dimyo0cpFCY7fmwF59+FApOczufym+Sg9VXiPE+ifbuO6DMQB8Qt8iRYk05n?=
 =?us-ascii?Q?joomQQF11j3wAUN291YY6tuyZ7GlXOJO1TGDdNrzZVWbES+CavCxmq9QJJQj?=
 =?us-ascii?Q?gsHCxQWVWNSrl/2gWUR6eXt2ghpShkZ3WxwZkhM/Eqh3RwfIp9nqLNy06Q1B?=
 =?us-ascii?Q?vesg1+b61ZjAqhGU76I24C80kS6C5luIMzYWTA8OHh8DqXmUGL6I9vtoY4an?=
 =?us-ascii?Q?dDwrO+w8hK5X8BqFpFlNEjeISsUuCNHD5bVkBbKWDcT6jA1eel7tuIqLfCzV?=
 =?us-ascii?Q?KTLiI/+/bgoJ/XoxxcIutq8bcV2wxbMdukllja+xQppOLdcTsfeT12bRkAfi?=
 =?us-ascii?Q?rqrkbrfu8/Sag8fckdbUhUkEuwXwtgkEN3Yag90QECKBZW9uaGuEb7Bdps4X?=
 =?us-ascii?Q?X/FXli5Fo+BIZVDQdpwN4GVj?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB3895.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9407d020-c849-4b8f-5a41-08d9837d6799
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Sep 2021 19:14:48.0550
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4Y83w33/2CJmK487zDo74lfd9wbc9ZfapUQNM/3RD3syeypA7xCSBtcm1anLL1/vBpFXa65ZU1Da+mwFSFOWoA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4038
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> Asmaa>> Thank you very much for the detailed and clear explanation!
> we only enable/support link up/down interrupts. QA has tested bringing=20
> up/down the network interface +200 times in a loop.

The micrel driver currently only uses two interrupts of the available 8.=20
So it will be hard to trigger the problem with the current driver. Your=20

best way to trigger it is going to bring the link down as soon as it goes u=
p.

 So you get first a link up, and then a link down very shortly afterwards.

There is however nothing stopping developers making use of the other interr=
upts.=20

That will then increase the likelihood of problems.

What does help you is that the interrupt register is clear on read. So the =
race condition=20
window is small.

Asmaa>> Hi Andrew,

I had a meeting today with the HW folks to explain the problem at stake.
The flow for this issue is like this:
1) PHY issues INT_N signal (active low level interrupt)
2) falling edge detected on the GPIO and transmitted to software
3) the first thing mlxbf2_gpio_irq_handler does is to clear the GPIO interr=
upt.
However even if we clear the GPIO interrupt, the GPIO value itself
will be low as long as the INT_N signal is low. The GPIO HW triggers
the interrupt by detecting the falling edge of the GPIO pin.
4) mlxbf2_gpio_irq_handler triggers phy_interrupt which
calls drv->handler_interrupt.
handle_interrupt in our case =3D kszphy_handle_interrupt, which reads
MII_KSZPHY_INTCS regs and hence clears all interrupts at once.=20

- if no other interrupt happens within this time frame, INT_N goes
back to 1 and the next interrupt will trigger another GPIO falling edge

- if the interrupt happens after the MDIO read, then it is not a problem. T=
he
read would have already cleared the register and INT_N would go back to 1.
So the new interrupt will trigger a new GPIO falling edge interrupt.

Problem:
- however, if there is a second interrupt right before or during the MDIO r=
ead of
MII_KSZPHY_INTCS, it might not be detected by our GPIO HW.

Anyways, the HW folks agreed that this is a problem since indeed they do no=
t
support LEVEL interrupts on the GPIOs at the moment.
They suggested to read the GPIO pin value to check if it has returned to hi=
gh
in mlxbf2_gpio_irq_handler, then trigger the phy_interrupt handler.
But I don't think it is a good workaround because there could be a chain
of interrupts which hold the  LEVEL low for a long time, and we don't want =
to
be waiting too long in an interrupt handler routine.
I would greatly appreciate some more feedback on what is the best way to de=
al
With this in the upstreamed version of the driver.
HW folks said they will fix this in future BlueField generations.


> The software interrupt and handler is not registered based on the GPIO=20
> interrupt but rather a HW interrupt which is common to all GPIO pins=20
> (irrelevant here, but this is edge triggered):
> ret =3D devm_request_irq(dev, irq, mlxbf2_gpio_irq_handler,
>                                         IRQF_SHARED, name, gs);

IRQF_SHARED implied level. You cannot have a shared interrupt which is usin=
g edges.

      Andrew
