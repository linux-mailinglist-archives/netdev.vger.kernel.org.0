Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A979F3F1938
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 14:28:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239212AbhHSM3P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 08:29:15 -0400
Received: from mail-bn8nam12on2079.outbound.protection.outlook.com ([40.107.237.79]:5985
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236605AbhHSM3N (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Aug 2021 08:29:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=avPi1HsRM0Lq42/CZxt2ct8yqDXhS+E3BlC7xAEksvtzuLChzsz2bsnvGDjzTRpQjifkIWrrVE4IAFIcN9ABB7axUw9nprI1TMO0LasN4Q75/cxR/tNEwMvRo2i8SUdAiu2CI5yvDshlYGmoMWXrI9g++R1fIvXLHcV2olR8TAg+PalIzUoehOyw356oD89rnsjY6DaAZnyQm7YSNy1bObtcDKZxTvkgOZYXWBp1DtrMLxlq0EYrk0w9owaMmZgCxMFUOxsxD+V/xQnAWmq3814Z7BI7vK6sG4G3u5AsSXlNVBMyEaHuEVLRbJdrgy5dGkOeDksI7kWp9NUjMb9ZeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tAbWSSGy0VCBOtkAPF4dywY6s40VWQapW+p76rT+Fm0=;
 b=A8tZhhHVTlWP0uyTvtL3REmJ+pilqszEf51ReQJcyr1sJF7WjnOrVelnO//cW7d/l8Yx/kGfnIIhAFSWlTI2ZjtbyQAGsFmTrC7ZIw90f1Gg3Bjy+hm1IHSf6K1Ex7dylEQjD/TE9A6RxP8mx+GrKubhsMu4bVcDx+lyyuihzn0Mt6+Wma7GcGAJ6RjQZHgfcMJI3NCEPlwh0FPwcAjDQlK+BrBzN0aLncqHABayofigPGiP96N4JWWMpvmIytXkIfLDQMb0n8z3iGAvBxAQ9CHLGwUidLRuHIv08clg+ebs7zaKarB8efBxyIgYxvryX4X/CYsPSak5mCZGQQeZjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tAbWSSGy0VCBOtkAPF4dywY6s40VWQapW+p76rT+Fm0=;
 b=PX87A8vGpr+feCoK95FqM9VxAH1pa56psvh/XsHXjxw+BWNQ1m49BImmIg3m2WjIYysa0PGpz3VF3jrfX5MA/eI8RSNgYKl5A6S0LrzgUmzmM4GDiMO9ObVYDZBuVxS9wJwi9nK4pP0XAme6spVQaatkslYex7hBKOZBZKTo4k6Blui25l1U3Bs5P/OXlWlvhELjvlJsTDr9dL24g++eBnspbPBN83mZHrJWOrZ0vNgzR89wpz8+cjYzGxCT+YuobU6B/8Oue/9pCbDM90t14P1izWJ3tkCimlI50a20BUhD6NAFj36ECFUcD4qxd/AdId9WaVwAOJ1xTaXeuaEqqQ==
Received: from CH2PR12MB3895.namprd12.prod.outlook.com (2603:10b6:610:2a::13)
 by CH2PR12MB4024.namprd12.prod.outlook.com (2603:10b6:610:2a::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Thu, 19 Aug
 2021 12:28:35 +0000
Received: from CH2PR12MB3895.namprd12.prod.outlook.com
 ([fe80::9473:20a9:50d1:4b1f]) by CH2PR12MB3895.namprd12.prod.outlook.com
 ([fe80::9473:20a9:50d1:4b1f%6]) with mapi id 15.20.4436.019; Thu, 19 Aug 2021
 12:28:35 +0000
From:   Asmaa Mnebhi <asmaa@nvidia.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
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
Thread-Index: AQHXkpZRAcQDwgai0k+eK2nQg5Bpo6t2INuggAMu2gCAAI8ugIAA5xYA
Date:   Thu, 19 Aug 2021 12:28:34 +0000
Message-ID: <CH2PR12MB38954F84310BE1D749CBECAAD7C09@CH2PR12MB3895.namprd12.prod.outlook.com>
References: <20210816115953.72533-1-andriy.shevchenko@linux.intel.com>
 <20210816115953.72533-6-andriy.shevchenko@linux.intel.com>
 <CH2PR12MB3895ACF821C8242AA55A1DCDD7FD9@CH2PR12MB3895.namprd12.prod.outlook.com>
 <YR0UPG2451aGt9Xg@smile.fi.intel.com> <YR2MV6+uQjjhueoS@lunn.ch>
In-Reply-To: <YR2MV6+uQjjhueoS@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f4f78396-0828-428e-7eaa-08d9630cdd2e
x-ms-traffictypediagnostic: CH2PR12MB4024:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CH2PR12MB4024F4C790EAE0118E8F0007D7C09@CH2PR12MB4024.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1Ut1d0l+WjVJIILP0IZ5yfV1/llSIj55eWK3CHKWi9fFnHBEFofiGN/cpdsqiBZ13TnWfi2yruUuDSxSDAVaCv7eX59p6IAlf70UXGX899kwVZbkR0sHbaK/EsDd//H/Ng6NUh/fk67vgLI5JVccW8kUaXdVGMrXuBlC+8ylG4J1RTPXq7FPWXXIv1mBjCvuy67zfU5qfrJDWTb+g4WzeV1WIg9MKxRq7u3Qjl8mX55pi0MMUZ3hKZCyodcfoDFRTE4OkjaL2y+8oWQbn9i68rq+n1rcg14WObXc/i1gkHF6f+NRn/OIUUsjHL+NaSUMSSVqNahYIjqI/LwHC9ypqMEX86sed18Lm3I+41kqTnT5xeQE5i/xvpff1xaH6qTRiI03q3R+SBsACwUTP76hNF+fEVl7tW/LAh6KU7WPbwABD+Nwa8AaBAFLNBHu9JqWJeOe+j2t1ILkNuRRUEfJ0QFtQojryQYbj20UMfSHICHVUH0hl/UtDcaCXS4nNeMKoIyOWEXNIlALDhWP0awdy5nmGaRW03/jlbg9aAHuPw+a35+4AEZwm+kN5TyG0Zk3IXh6u+repRasWfqUFxGP9HaFxbj+qUTL1PaZbxhcNyeNC2voJ/7nw2+gEOJj/G1oMh/5V6dt9e4MT0ssMt9r8nl8CcSVaTwobfIgcJToiqlL1VSueo86pEVNmoJNAXPfE3fPXUoSGDPTWfzksUT1Fw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR12MB3895.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(366004)(136003)(39860400002)(376002)(4326008)(55016002)(110136005)(54906003)(71200400001)(52536014)(83380400001)(53546011)(6506007)(5660300002)(38070700005)(66446008)(66556008)(76116006)(186003)(66476007)(64756008)(9686003)(26005)(7696005)(478600001)(66946007)(7416002)(8936002)(8676002)(107886003)(316002)(33656002)(86362001)(122000001)(38100700002)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?pH4ZGzXuq/k2NXh7fTG2VsM36p6EvRpsShmkJbX1sM72h0pk+nbEv5c7Ze9y?=
 =?us-ascii?Q?mM/DUuM3i9cy9MoqShU+iyU68fRR3it0vDRkq0nxnNKY9UTtGynndWgCSziq?=
 =?us-ascii?Q?b7++6AogxnXtmt6MFqdl0HEJcq7QZ7a2FlranV9SPyDAhyRXaHyGZMOPtvqj?=
 =?us-ascii?Q?wdwYMSlXURWzxX2GextMn2xnQ0OoCs/2LXjzsaeme7v/u/RaKVTUqcIXHTyY?=
 =?us-ascii?Q?um+HPqEFkobaPEfcnBE1wYY2vjmJ5UFjOKxtqjhUYM7ZBV933XJhm+GNCToq?=
 =?us-ascii?Q?gFDoxH7uxpLqF5TZsq0/oPWEs6cTEhnmntKkV2CoxH+KftGnr1ADgHflPWEp?=
 =?us-ascii?Q?6QlPxNqs438V3LIlwOWialQGDYX+TGcMykbXJMI2GkmzxOLNz14LbXyvmtZ1?=
 =?us-ascii?Q?Kg9walr15SJiSZNYaFcjQFVGl2CATF6ZMCdb78xHXfvsQqCZ3tjou/wVStkC?=
 =?us-ascii?Q?iKb/uNpO+fCnxgVolLRHXhLxBNBoiC6a1WhaqZ6zmeBGgEneLcjNnt5o5jrl?=
 =?us-ascii?Q?d5k/R0qxvxTTDQ474wXWrtwkEh9/Yodb/tEttJs61sMFm+KGdUXvXWeop1Xi?=
 =?us-ascii?Q?Z8mzJwznn7IBOTaJKsbupYNo4lusA5XHMyiAMbYld1SPQnYmOmvq54xjeH2e?=
 =?us-ascii?Q?P34gmxfNVMZVhSb46LO4jjuKJ4FyS64peRRmVkkECit1UX3rZCagtYeFSDgF?=
 =?us-ascii?Q?UnFGrBVZ/S02TL5ZCcV0rIpRNVgSlWn4BqRoqcWgjMn0Kzb3tdwSsWnCAnxX?=
 =?us-ascii?Q?xojBreS+HL2H+ALaBELFSq2WXfadxWc2yP06TgaS443asoXLQ80W82vDB8im?=
 =?us-ascii?Q?bVvShPvg0t0xmr5KPHKpNuMgM1mQWGh98jirayY4aEF0/ds5DjKrH8B0cWpD?=
 =?us-ascii?Q?GHuMRg7yxnXxhw7mQaRugeupAqRP10hVduVS40z+fVYmDeRrjFeIxZZE+gAq?=
 =?us-ascii?Q?f5hKomUZFcH4BENdoUWC4SO7Kzgmy6yx/RFGDeAlrC0iWRSXEoJlWWLfvfoM?=
 =?us-ascii?Q?hEwUI0XgRhuzwZ4JFjQqfTJtAv9LTvQ+EtANQgw77mevzBouUYTo8SQJVH/z?=
 =?us-ascii?Q?kGE/9QAAq/e/llM6npMjFTrZz9Hsjr5E/7SCjhoJBKPxA3bCt/0sba3e7yw3?=
 =?us-ascii?Q?yS4+tUmdijZDJYnBPHpUnCBEgy3leFhsEQEOYGCdFlsz7TnI0zrzIH8FrPNu?=
 =?us-ascii?Q?S8X5n0jwaSG+6VfNqoaPvFd2CAnH7KgcqidkyyPbkY+kvZqpmMkxMIc1HN1R?=
 =?us-ascii?Q?g/T7kWQ3gqAjb9BouEM+SVlgIbh5CicRQUsM1M+zK+1vmgGC/H+RFjWJGG3M?=
 =?us-ascii?Q?JkpMaYdwr+iuUkpP9T6t62zN?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB3895.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f4f78396-0828-428e-7eaa-08d9630cdd2e
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Aug 2021 12:28:35.0405
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WbO5NWM5qwrhoySQyeqhATFytDSLvFhrOu5YYk7Zatc3AJ7fpC6nDatQaI/hlsmV+Kjao3vBQwU2E+BYzYtm4A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4024
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thank you Andrew and Andy! I will prepare 2 patches (one for gpio-mlxbf2.c =
and one for mlxbf-gige) and send it your way.

-----Original Message-----
From: Andrew Lunn <andrew@lunn.ch>=20
Sent: Wednesday, August 18, 2021 6:40 PM
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Asmaa Mnebhi <asmaa@nvidia.com>; David Thompson <davthompson@nvidia.com=
>; linux-kernel@vger.kernel.org; linux-gpio@vger.kernel.org; netdev@vger.ke=
rnel.org; linux-acpi@vger.kernel.org; Linus Walleij <linus.walleij@linaro.o=
rg>; Bartosz Golaszewski <bgolaszewski@baylibre.com>; David S. Miller <dave=
m@davemloft.net>; Jakub Kicinski <kuba@kernel.org>; Rafael J. Wysocki <rjw@=
rjwysocki.net>; Liming Sun <limings@nvidia.com>
Subject: Re: [PATCH v1 5/6] TODO: gpio: mlxbf2: Introduce IRQ support
Importance: High

Hi Asmaa

> > And I will need to add GpioInt to the GPI0 ACPI table as follows:
>=20
> But you told me that it's already on the market, how are you suppose=20
> to change existing tables?

BIOSes have as many bugs a the kernel. So your product should be designed s=
o you can upgrade the kernel and upgrade the BIOS.

phylib itself does not care if there is an interrupt or not. It will fall b=
ack to polling. So if your driver finds itself running with old tables, it =
does not matter. Just print a warning to the kernel logs suggesting the use=
r upgrades their BIOS firmware.

> > // GPIO Controller
> >       Device(GPI0) {
> >        Name(_HID, "MLNXBF22")
> >         Name(_UID, Zero)
> >         Name(_CCA, 1)
> >         Name(_CRS, ResourceTemplate() {
> >           // for gpio[0] yu block
> >          Memory32Fixed(ReadWrite, 0x0280c000, 0x00000100)
> >          GpioInt (Level, ActiveLow, Exclusive, PullDefault, , " \\_SB.G=
PI0") {9}
> >         })
> >         Name(_DSD, Package() {
> >           ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
> >           Package() {
> >             Package () { "phy-gpios", Package() {^GPI0, 0, 0, 0 }},
> >             Package () { "rst-pin", 32 }, // GPIO pin triggering soft r=
eset on BlueSphere and PRIS
> >           }
> >         })
> >       }
>=20
> No, it's completely wrong. The resources are provided by GPIO=20
> controller and consumed by devices.

In the device tree world, you list the interrupt in the PHY node.
Documentation/devicetree/bindings/net/ethernet-phy.yaml gives an
example:

    ethernet {
        #address-cells =3D <1>;
        #size-cells =3D <0>;

        ethernet-phy@0 {
            compatible =3D "ethernet-phy-id0141.0e90", "ethernet-phy-ieee80=
2.3-c45";
            interrupt-parent =3D <&PIC>;
            interrupts =3D <35 1>;
            reg =3D <0>;

            resets =3D <&rst 8>;
            reset-names =3D "phy";
            reset-gpios =3D <&gpio1 4 1>;
            reset-assert-us =3D <1000>;
            reset-deassert-us =3D <2000>;
        };
    };

You need to do something similar in the ACPI world. There was a very long d=
iscussion in this area recently, and some patches merged. You probably need=
 to build on that. See:

firmware-guide/acpi/dsd/phy.rst

	Andrew
