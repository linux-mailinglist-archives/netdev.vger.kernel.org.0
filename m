Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA23741B28A
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 17:02:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241489AbhI1PDp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 11:03:45 -0400
Received: from mail-bn8nam11on2064.outbound.protection.outlook.com ([40.107.236.64]:26689
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241400AbhI1PDo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Sep 2021 11:03:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bi3+BEzfcAkxq01R/a2jTYze8nO6lR3TREu853RFGg+YzHjIPAf5zcFlCyQ9t9jytxK981pAODVOLBnU0Zoo4KeqAKimheE9C+mfYNFMQGPDCNBGzRanlW8QCU+SkkMJjfYMivZA3k8GOC52NxRO+w4d19XTW0VGQQUDE3JMTCPmvCPKNSdWHKUpwPDHv6GJvGbdd+zL1Or+F9XewpoSw/chn92RSuLgftatHZBNsI6C0lsy8cCbVYa/ND9wjhQ0N7i9Zdg0U1sIINQvC9siCFXx8DS73YnIPqYGfV8RY8BYJzM6NWXVm9sAFmzl+NBnGEXbd1l8m1QcYTd4KjuIbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=WI8MrPQWGI7rAbIIonR3452Qph1dPZtaq12b1WrLtIc=;
 b=bEftNudVYddx+CoIXHW9N2bGE0liec5kOsaXZyUyzlN4RMC0VJg4F5jEKGlHLZ7yBdVHBpQ/9ZsURl2PHzxvdXkeYi/tFx/nGzYqh0mr2zMugtApn+S7OiWk8Svq2c4H6GdtoCqg888Y4APTYqcO6Du77mATbiWehbGeEkaR3jJwY+DbN+cw3BERmDV9RWtzx7wZ6U+MbIlYiQp7MdaW9dFWw32NG5C9Mi0SbLo24sO6YnZhCCAOaTec2MD67ZgoDJ3k47u02eV/8gLDmC2cWcRTOJQHy9QCm5FCHRZyAvBJJKRgIxvIAIyqU/3UzKYdPlL/5GUpCvObbsY3Qe+FLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WI8MrPQWGI7rAbIIonR3452Qph1dPZtaq12b1WrLtIc=;
 b=ubbsEKVFsqKepGRuQv6ci4FxXpPcpdys1VKu+cBi4XxTEKujMfnnG6uZAx+k+4EtpAh3VSdBsv/tPdXPp4BvIlFXgAUFppmVZWTjTsG6+LCkpoh8n7qUkrm0pUsDuzDhqrMt458VxQckwH8HidOL9o6zT6XA4vcW+/0wcaqGUuX1imQPucRQTbHZWhBqZLdIXi5ybbca2ZnQy0Y+KExfqhunGwN//Rlkjf6SgxpP3Q8Hkz4y1SSZSKMyi7Vwka+ENbcydZsrl9ZB1yvRYWTKFN/pStYT+ERIPOoC9IQUeKNvhfa9NeATAVi2OxkAFdnnHIxgzAf0X3tl0PMl0KM8oA==
Received: from CH2PR12MB3895.namprd12.prod.outlook.com (2603:10b6:610:2a::13)
 by CH2PR12MB4263.namprd12.prod.outlook.com (2603:10b6:610:a6::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.14; Tue, 28 Sep
 2021 15:02:03 +0000
Received: from CH2PR12MB3895.namprd12.prod.outlook.com
 ([fe80::a46b:a8b7:59d:9142]) by CH2PR12MB3895.namprd12.prod.outlook.com
 ([fe80::a46b:a8b7:59d:9142%5]) with mapi id 15.20.4544.021; Tue, 28 Sep 2021
 15:02:03 +0000
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
Thread-Index: AQHXsLi5/ezHFM2t80qMnoiP1wWjOauzEi0AgADJmACABBI7EIAAAriAgAACbtCAAAsjgIABjviQ
Date:   Tue, 28 Sep 2021 15:02:02 +0000
Message-ID: <CH2PR12MB389530F4A65840FE04DC8628D7A89@CH2PR12MB3895.namprd12.prod.outlook.com>
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
x-ms-office365-filtering-correlation-id: c27ebbb1-85cf-4da1-ee0f-08d98290ee0f
x-ms-traffictypediagnostic: CH2PR12MB4263:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CH2PR12MB42635D53D96EF1E1B9C56A0DD7A89@CH2PR12MB4263.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /GH/iNPdzKZ8ibhlPnENuKZeR3SRONuV5hYuX9hZ10Sd7ge6zATDP7tEyDTkznISm+h7rnAGA2YQrjUYSPj20crQGi2cn7/dS0CYcs9yPdDXvQcboI47RjkR1HjkCYQO34JK/uIv9IKdNAapFTNjbvY9vU9xUZ4RrG5r9liP0wSXz3DXfYhHynWF16ljdc8+lm7KC3pTdYyV4izhxZQiQqrtuEtmAnZ+3dTduCYOjUDidTIQW9hQT9XIH7SSuK6FSIJue3lQ4mw/IEU8MWGWAlxWEPQrS3fSsWaNwUl5YN58qSbw36VP8YIG6bDzAas7S+aunf1nVTyT7YNXi13yAyTTwiFCaOXqjMAVpDo8Z/xFvePtPveGYx0suYR6Wl+jZWzo6nSBhJMqkX6LsbIiIasU7MDle+MKdq32S0txZzERTYDnqhmBb/It7uQg6tppI6U7SKN6kFQ2amDi9c1XCq4qSdOcAldoElUbVYcK7Xk0/qOysMIGL6VCK1WVtlr34uO8wjdW6ZM9XKuMi28B8eahoNxH14mZ5LVoMAP16avUr7UxXJ2GXS1Qc4UQ2fCE4g3ZeJ6HhRv4eDdNyq474BoEeZ2HjnNGVj9KAAxYT342BWPAwTlHqMAjoZs7+yUGGY4r1NBzVvozeidA00BSJgHWNEJXFpQYQGfPmAPmESLJ6cymTjcP4FSZn2iz/XmtZJeXGjjzN39nasc1SWb0/A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR12MB3895.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8936002)(55016002)(186003)(52536014)(86362001)(76116006)(7416002)(38070700005)(71200400001)(54906003)(83380400001)(5660300002)(9686003)(2906002)(316002)(8676002)(6916009)(122000001)(7696005)(66446008)(64756008)(66476007)(66946007)(66556008)(508600001)(38100700002)(6506007)(107886003)(4326008)(26005)(33656002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?+7PLm79hvOGPtGC3ThZExJR4LYiVed1Uxbv+PeNwforLJ7DDYbyCRjdNY3J0?=
 =?us-ascii?Q?TxWT5iS+uljVP6J5YL38VoXDY9rwW11F1FXCj4Y11JxFnJ0kM1+lh2qrPH8d?=
 =?us-ascii?Q?+taB8trdGllpNc6W3IxMKMe1pABgdKM6mea9iTg88g0fkhL7X3dpvYJP1Pfl?=
 =?us-ascii?Q?D3b4aXjARzAPCVjZI9x9xjxzWqs3xushBpBqZJTH+fsjYlzOLrI+RhL+Aif7?=
 =?us-ascii?Q?Fixmoue1lNgo85BTlJ73XOHDGkBdD+npnVJdrewTng2i011a/hv1B+QKzRRe?=
 =?us-ascii?Q?LZJLcmix+yk7VKvYr4rDKxCEJkhnLuHfwHAP63xbsP0CigBDyNKBE0IkIOSQ?=
 =?us-ascii?Q?5y4sA+Kp3I2Vqk1yrZqyrNUYVIoiZt37TJ1ICUHRRUcO0luhRmaF9cc+MBLq?=
 =?us-ascii?Q?ztYWM5KAMEc/NTKdIeM1HNQ3PGXM2cdbUawzJaa4wkO88VAqrFYrvmTFyR6J?=
 =?us-ascii?Q?QHfIoCrZqGtJAzzUWiLPTR7HQz12P8F7aaYrHmneEFJRacodPafeGo4kRnW0?=
 =?us-ascii?Q?OYxDKL1VCBFV0y/u/hMLxyEXEAkNTum+dUBDokUYlEVSu0fSrMnaDVDbOJfm?=
 =?us-ascii?Q?vvf2eablr9LNcBHavFSlOzTO9IwWLE24rdCSQE/j/KJzhuyrSBq82Qvp8SZO?=
 =?us-ascii?Q?TJbxJwGN+9xJaXh9Dn3fHDxjzK+iRehy+CXHWnFegGObtuvCKZStxtrfGlo/?=
 =?us-ascii?Q?9qts8P4S1q9xUxLcUEg5uPXF98fCoDWwHBXvp8A/k0TG3DUVsgLpnaa8z4xf?=
 =?us-ascii?Q?z3eDpEwuSb7kK4NOZ8/CQXRCvnohJFbA7hkH8SwOJrLSxa0VDN6mn6BT85dD?=
 =?us-ascii?Q?ixpsn+/gKhQxJsqwJkpT841GqNjM3UsDeBzzpPMTnGXtKP/oiE0Mj2CoPFEz?=
 =?us-ascii?Q?ppY1cEOpnLkqmz2jIV+I1pbLAIYHjXHi1nEIuHeRBQAxxncC30x+VTDCZ/zC?=
 =?us-ascii?Q?x4lqtmwMLz/pYoYN4m2dE95ekGuQg8j7VaTSpu8PFNRzyPxJOC+l4MoTmp98?=
 =?us-ascii?Q?paZDG5NnSq7nA3Wii/r5W9Za09xTU4c/5EGdfWdIKWY7tqgSY2k5kjvHlwNm?=
 =?us-ascii?Q?HP7hyX8uHk8WKspnkHYg12lRPLR13UQEZe1S2bahkwVHSO65J2GujvnkILou?=
 =?us-ascii?Q?x4j/UyMOgxYpzrMAWaADtRsWTuGpGSW+/q4dUhoic2XIZIYtrsi/hIp3hD7r?=
 =?us-ascii?Q?qm6veatCo0OPS8dnxcgJNhTzls5DdmKlLBrkxzm9K5dnKT2OrBkClDGXMBo/?=
 =?us-ascii?Q?DCCmT/qxJB2JPRxUZBc3AAUQMCkNGGTYaVPHSolrg8yg3ZBZ1X5SZK7kX2ec?=
 =?us-ascii?Q?I+pELnoIGPME0b70ZxbPKcZ0?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB3895.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c27ebbb1-85cf-4da1-ee0f-08d98290ee0f
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Sep 2021 15:02:02.9829
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZY2qjAT4VsnQvHdto9uJ+146gLLfvoAY04MBDSpvg0fk76Via7nRcdu0WdyU6tUupuImR8uZ/gXyh/n6ixaFtg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4263
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> So the PHY is level based. The PHY is combing multiple interrupt sources=
=20
> into one external interrupt. If any of those internal interrupt sources a=
re
> active, the external interrupt is active. If there are > multiple active =
sources
> at once, the interrupt stays low, until they are all cleared. This means
> there is not an edge per interrupt. There is one edge when the first inte=
rnal
> source occurs, and no more edges, > even if there are more internal inter=
rupts.

> The general flow in the PHY interrupt handler is to read the interrupt st=
atus
> register, which tells you which internal interrupts have fired. You then
> address these internal interrupts one by one.

In KSZ9031, Register MII_KSZPHY_INTCS=3D0x1B reports all interrupt events a=
nd
clear on read. So if there are 4 different interrupts, once it is read once=
, all 4 clear at once.
The micrel.c driver has defined ack_interrupt to read the above reg and is =
called every time the
interrupt handler phy_interrupt is called. So in this case, we should be go=
od.
The code flow in our case would look like this:
- 2 interrupt sources (for example, link down followed by link up) set in M=
II_KSZPHY_INTCS
- interrupt handler (phy_interrupt) reads MII_KSZPHY_INT which automaticall=
y clears both
interrupts
- another internal source triggers and sets the register.
- The second edge will be caught accordingly by the GPIO.

> This can take some time, MDIO is a slow bus etc. While handling these int=
errupt sources,
> it could be another internal interrupt source triggers. This new internal=
 interrupt source
> keeps the external interrupt active. But there has not been an edge, sinc=
e the interrupt=20
> handler is still clearing the sources which caused the first interrupt. W=
ith level interrupts,
> this is not an issue. When the interrupt handler exits, the interrupt is =
re-enabled. Since it
> is still active, due to the unhandled internal interrupt sources, the lev=
el interrupt
> immediately fires again. the handler then sees this new interrupt and han=
dles it.
> At that point the level interrupt goes inactive.

