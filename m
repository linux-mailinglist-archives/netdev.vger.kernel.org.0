Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E50B1419843
	for <lists+netdev@lfdr.de>; Mon, 27 Sep 2021 17:52:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235292AbhI0PyP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Sep 2021 11:54:15 -0400
Received: from mail-mw2nam08on2057.outbound.protection.outlook.com ([40.107.101.57]:9280
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235100AbhI0PyN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Sep 2021 11:54:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DxFsIeI9kZ5jiriXc15ShaH+fU6lrpC3s3+j8rnO86iPLW6hbUG5Y9bdAMzXPKG1xCveK5s5DpapqQHK6mkzFQxufmsvzVf1hPZmncKXbtr4A2qOOvcPa5P+Hb1bk3jFMzla9UlF6BIWfgo/TozL75Z2Z/eKvaFeusfED7SbBD4MKizlGHqlRe4AozyTyLpmSqALI89/TByW76swNO5KWZ9CCpTcO23m8hU43FSZK+zbwn4EfXlCYgGpyxa9LmoFTjqtofjTkrvywycuXG6fJFPwGo5Dm7FKl6Ezf2tazOOpocffV3zNr/HyZQzH3acutR6i6U8OeIKJPIr8NDG1lA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=fdEppgCzvKbB7RkJ3jtNVflS78pxJ0dPH6DSVbc8LTM=;
 b=WzsU26C8dC5w5qlHkFN00jJR46+T0aFBjTUL2vGdPHcdofP4sdkG42txCw5ywJ1LZbjnJ5v4NKcmL5mISnQ3OMufVzkSvXOnorMDfPUyUHTX/sYoEowDWVYOEE8JGf2u7jbaJ3tB0JAN3KewdoQU+I4TMZF52YlzSneSEev58WUpG3CvJo47X+TkAqq1tzJt4YeIBZRzWLGVnXK9KslC4xigEBP7TkpJbeZ6W2/aeGy3rePOQCgBYgWF3DISBnhmiZRMPMZZ457NuuvHE8Ph3eYKXHISIl2DohXCxDxCtD7pVn6HPxf+Q4oOd4LSPz2SrT4jdZUoWmwaPf+PGBRpFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fdEppgCzvKbB7RkJ3jtNVflS78pxJ0dPH6DSVbc8LTM=;
 b=G3wWMWM0ZeFQA821MIkizpqtvIHyjAl5x1MwNaYI8TRaJJd1HSurKJyZ/226SuNivFac/VFn3Qz80MOmXYfny0ov6uS19HL2sWGyzxn3dCOCPq3Z340foOlK4mLcS42Dp3jAy9WBzW6B/ShmuhQ6Ibt9oauZFQkrFzAK8ZKhAcSVBKw8XcroSLgcYQUtqirmPJtIAyxEIRztErUOzmiC5f6COivbkjNjPsYStSNo/m0X+CET91rRHOB4XwIQR8EuaClz9ZkygX6rqPl9KH59+qcmzjSvfk0aKNlfabRTFzEcngKPNwDM3jniWHahavdTt5SuHh/knHqRTMeU4D77Bg==
Received: from CH2PR12MB3895.namprd12.prod.outlook.com (2603:10b6:610:2a::13)
 by CH2PR12MB4939.namprd12.prod.outlook.com (2603:10b6:610:61::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13; Mon, 27 Sep
 2021 15:52:34 +0000
Received: from CH2PR12MB3895.namprd12.prod.outlook.com
 ([fe80::a46b:a8b7:59d:9142]) by CH2PR12MB3895.namprd12.prod.outlook.com
 ([fe80::a46b:a8b7:59d:9142%5]) with mapi id 15.20.4544.021; Mon, 27 Sep 2021
 15:52:34 +0000
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
Thread-Index: AQHXsLi5/ezHFM2t80qMnoiP1wWjOauzEi0AgADJmACABBI7EIAAAriAgAACbtCAAAsjgIAAAWRQ
Date:   Mon, 27 Sep 2021 15:52:34 +0000
Message-ID: <CH2PR12MB3895E69636DDB3811C0EAE3DD7A79@CH2PR12MB3895.namprd12.prod.outlook.com>
References: <20210923202216.16091-1-asmaa@nvidia.com>
 <20210923202216.16091-2-asmaa@nvidia.com> <YU26lIUayYXU/x9l@lunn.ch>
 <CACRpkdbUJF6VUPk9kCMPBvjeL3frJAbHq+h0-z7P-a1pSU+fiw@mail.gmail.com>
 <CH2PR12MB38951F2326196AB5B573A73DD7A79@CH2PR12MB3895.namprd12.prod.outlook.com>
 <YVHQQcv2M6soJR6u@lunn.ch>
 <CH2PR12MB389585F7D5EFE5E2453593DBD7A79@CH2PR12MB3895.namprd12.prod.outlook.com>
 <YVHbo/cJcHzxUk+d@lunn.ch>
In-Reply-To: <YVHbo/cJcHzxUk+d@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9887c1d7-7177-42ec-3776-08d981ced278
x-ms-traffictypediagnostic: CH2PR12MB4939:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CH2PR12MB4939B2D66FC857E888881775D7A79@CH2PR12MB4939.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DHKw0eXAHKd6vpumHz4hM/kFjBVKofVVGEmumvmIKAqW3FWuz5LteqFsltKF2M+BAhe9eYGhIAuxhstbhNaD4SPtr6gAOzYhUE3fbtDoIsWqhifSEsNZTaMxww6rOSA9Pexv+MbHOUiiAGHlR+sG0URoI0MSn1EXwZO3SYtr4RIe+gI1vQM+W3xIGRC0t0Z40Jo8pRGBe6NhhBH47EX8FxqgWdYeASbpGY0Yx2azklaKnnQHVh/t49aMHb5veSXqxjPa1esNOKxuwHteju3WFEb7eCAf57aCGLbFIShxM2XjOZCkPciuWdaDFprxK6WvhVyxwQpJ7PvE2eQH7Bo+ukay0VoNlrtDSiGk/C4NKBFA341jl4F5VJRfW4xwJwm/wCoehcFH0gduPlHN7rFxdHD4GLIT6y4fq8w9CIAdPLbpAcj0yD5eQCVYuKp4nBc6OH4IhSFcmU6AsA5poBpsdZ3P6CHRluey3dRKeXc943ds9Tv7gexP/vUAY7+nH5jotPQMRlCyVKyj8fdbh2uZDJCllY1fbfZ+XCFiWTJ0Rentb0xDcA1oAov1CRZ37doeW+C6/Wr9qnOWVT4wNN4y446fOplMXXoAIJmTb7liqA294XHxExKydcgIjNfQM01N2Ei4fNl5UGjYxJTmuA1TY6IhODpu4WSb2Dlpe/alS+CtCaYT6vIGjLDStQ2l1UxTOCKGnmUQXKP4+7s35w1Ekw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR12MB3895.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(55016002)(9686003)(8676002)(54906003)(7696005)(38100700002)(71200400001)(2906002)(122000001)(8936002)(83380400001)(107886003)(508600001)(26005)(6506007)(186003)(86362001)(5660300002)(6916009)(33656002)(4326008)(38070700005)(66446008)(7416002)(76116006)(64756008)(66556008)(66476007)(66946007)(52536014)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?GzshvBIYcFlmpHjl+ne4iMFCsB3bs2H5Of9OBX+euLpjHxW5BaKShkyCKYu6?=
 =?us-ascii?Q?6pI/9M9VC5eDHuFueQ1zwAAU5itl+PmDMYlYCta31M0oEC30KyhGwp221SHZ?=
 =?us-ascii?Q?Xz3q6T0PQqdYRfABXhjoVc2fFdm0VvRYnv0GAmDiTm1nIcafBBlKx0fNSh3z?=
 =?us-ascii?Q?N3usHaMAmgubFSFT1OqFeTdiqjwaUgF1Y3FmntmvOkJWPIdsa7x6OpaRTZgo?=
 =?us-ascii?Q?WfWFvjlbCq49CaJsmYwabmZawSFK4eknnY7uombwd4hwXB6KlzdK3ipgCqYa?=
 =?us-ascii?Q?Bv9KzQ7MFnQVymuVdfGn9Zm+DuiXbs1XNgTDDiTAf+O6HZoIjZeKNiJu9Dsc?=
 =?us-ascii?Q?nPQrNvyUlW+aPNzIeFisNoWx1Iq4frIbLL6SBLTdi42jmdzKJFmdr2iql33F?=
 =?us-ascii?Q?jl+ZwtzSQveOIfHXgf5aocjinpTCLb/gcLC/3nOeBHoHYRZJbH0oYo7dkoRZ?=
 =?us-ascii?Q?HmEYXzmSSGd+hfxCRHkSKWLsQrVrd6KllgzvSkypA09T3Yxt+uXyj4PdwRh3?=
 =?us-ascii?Q?GANciIutc5Vso7HKD+x0VSsmS0ifxJXJdl6ADzgO9Gjd5lnEqf07B/ZKcm/+?=
 =?us-ascii?Q?OKaEVcGC6vj2OiCYs8cpqxgR4JKaCsnpW394wYaIk+bzwBMvJBsnoOq135df?=
 =?us-ascii?Q?mk9vJDecLE0O2odszZs9l0bneZ5LTnJolvFB0/x1QFhCTWz2tYTxVUuBkJD4?=
 =?us-ascii?Q?JvUol/pIE75iygKso9vJKE+FoeTDQ9OIoH2XnZeBRlyHKa4CYHJ7j8wmWITy?=
 =?us-ascii?Q?V6F1Brndri0kq5yVFfWpfgNXSeVt7COY1vIL90y/OeBJG23PaH9CS9QuYv8b?=
 =?us-ascii?Q?C/Wp2IkUc4NH+odtwgx6pwA9rWktIq9Tb5XPLf6hU5BmyMtk4YWubwYeWhmB?=
 =?us-ascii?Q?/ywdM3gcvtGrA//bTiazM2xjnlyFDyep33mmuwJYNmdZp26xEiUbH5KBGiZw?=
 =?us-ascii?Q?7cSyyPnYDlBZpUN66ZDyt9J34XFeTBOgJCgYE0c2xapx0AXTqbhTlW/7MWdD?=
 =?us-ascii?Q?W5F0FzeUm92G4lgt/PXZ9inTuijZXathbbKgtomBZ93LezBbsReSn7pSYfUO?=
 =?us-ascii?Q?+M1hv19nnKlndTVGSkLyHaLqyjuxL9YQqmqQ94czDfHSdAX59QMZrm9faxxJ?=
 =?us-ascii?Q?uEMecPUwaawOn+2WFN8ZlMDuDeRxsf3HY9/q3y9e/BV+jZdmFltN2n7a5NmN?=
 =?us-ascii?Q?ZSZprfQpyo0v8CkNUtrTZr75M6ua4IBJnDR4KG0HwaaKbvHw3CM3v24dexRj?=
 =?us-ascii?Q?v8lXBV2qita69diusbQtMX+yZ5h3n8+ss/VJF+kWMY97Qk0I5w02fNQTuumc?=
 =?us-ascii?Q?seSGiG5TL5xHCHq1UbT2xpzT?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB3895.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9887c1d7-7177-42ec-3776-08d981ced278
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Sep 2021 15:52:34.3066
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 85g6gy8H4KOyFypJvboJDqSRxi70K2R8SQHrWM0bb8UblTxFrdBgPfMqs+Q1recyIHOFHFPbPFTVeGuVwD00RQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4939
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 27, 2021 at 02:19:45PM +0000, Asmaa Mnebhi wrote:
>=20
> > The BlueField GPIO HW only support Edge interrupts.
>=20
> O.K. So please remove all level support from this driver, and return=20
> -EINVAL if requested to do level.
> This also means, you cannot use interrupts with the Ethernet PHY. The=20
> PHY is using level interrupts.
>=20
> Why not? The HW folks said it is alright because they Do some internal=20
> conversion of PHY signal and we have tested This extensively.

So the PHY is level based. The PHY is combing multiple interrupt sources=20
into one external interrupt. If any of those internal interrupt sources are=
 active,
the external interrupt is active. If there are multiple active sources at o=
nce, the
interrupt stays low, until they are all cleared. This means there is not an=
 edge
per interrupt. There is one edge when the first internal source occurs, and=
 no
more edges, even if there are more internal interrupts.

The general flow in the PHY interrupt handler is to read the interrupt stat=
us
register, which tells you which internal interrupts have fired.
You then address these internal interrupts one by one. This can take some
time, MDIO is a slow bus etc. While handling these interrupt sources,
it could be another internal interrupt source triggers. This new internal
interrupt source keeps the external interrupt active. But there has not
been an edge, since the interrupt handler is still clearing the sources
which caused the first interrupt. With level interrupts, this is not an
issue. When the interrupt handler exits, the interrupt is re-enabled. Since
it is still active, due to the unhandled internal interrupt sources,
the level interrupt immediately fires again. the handler then sees this
new interrupt and handles it. At that point the level interrupt goes inacti=
ve.

Now think about what happens if you are using an edge interrupt
controller with a level interrupt. You get the first edge, and call the
interrupt handler. And then there are no more edges, despite there
being more interrupts. You not only loose the new interrupt, you
never see any more interrupts. You PHY link can go up and down,
it can try to report being over temperature, that it has detected
power from the peer, cable tests have passed, etc. But since there
is no edge, there is never an interrupt.

So you say it has been extensively tested. Has it been extensively
tested with multiple internal interrupt sources at the same time?
And with slight timing variations, so that you trigger this race
condition? It is not going to happen very often, but when it does,
it is going to be very bad.

Asmaa>> Thank you very much for the detailed and clear explanation!
we only enable/support link up/down interrupts. QA has tested
bringing up/down the network interface +200 times in a loop.
I agree with you that the INT_N should be connected to a GPIO
Pin which also supports level interrupt. From a software perspective,
that HW interrupt flow is not visible/accessible to software.
I was instructed by HW designers to enable the interrupt and set it as fall=
ing.
The software interrupt and handler is not registered
based on the GPIO interrupt but rather a HW interrupt which is
common to all GPIO pins (irrelevant here, but this is edge triggered):
ret =3D devm_request_irq(dev, irq, mlxbf2_gpio_irq_handler,
                                        IRQF_SHARED, name, gs);


