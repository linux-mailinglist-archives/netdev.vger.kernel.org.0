Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC939426CF2
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 16:47:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242503AbhJHOtV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 10:49:21 -0400
Received: from mail-bn8nam12on2042.outbound.protection.outlook.com ([40.107.237.42]:38753
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230511AbhJHOtT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Oct 2021 10:49:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SX253S7fcLyFlaC7GySdc841WDfVYQm/465vHYdfIrpaGDgjEIFfTi/tB+9G5ZGmSVQrgjiGtXhqR3vdUs0+2XPa5LXzmVLmv4mavofiS9vfoDLzftAPeTBFEJ6KC9xShPJvqEIe1gSA3qOiYcT+9s5pkVFV0zpq7nP9bVh8g2xfRbg6pAcAyBPcgT5zmLaOntxzZYjtHoVOVM4Zb4PrHvFAa/WWgKEjnxEXeZOZxDxwcNCx8qQyW8lFI6ybDaWxZMmy1ykXfUIFepll1k8lAWwpDBqqGyr6FQIYQ3tgMuDATdO6Mgvwb7Nhyp1bZs/psiNH4Hbu4/Sb/spQ6aOcWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xEtB7mq3hSIDYqJZSn6cq2Yw/pWJuIL4Lh9EyyJseOY=;
 b=N6HIDrgfsbA1/1iWbwdKU2RC1RVuVxq5Wu0Og0JTlxqlvBhK3OQnOhFVTPpUA0Epsrao9hFUMsjSB0Bs/IhiHvXwzNEb29BBqFaM4cj9uvkOymSltrExACvuZGnotvuvwMiqO+/kf0kTn7H4do0sqlk8OWGHTy0ZGbjzcxVgeuaTlVaYbEGiFj7FD5auPvUudofmEyAggXV1OnFQ+F72fcDQYUnHLN/PVk+LYKwJwpbBMkX+z36esas1EnIAjSaUk6SyMJ9L7VemwAn5+WKgFC+ufc+rewXVkZ3HCZFm0LthHqI4hpVUK8cQU3mK+UvRbsapitnOaGwOaXmvyhiGAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xEtB7mq3hSIDYqJZSn6cq2Yw/pWJuIL4Lh9EyyJseOY=;
 b=qjQiL8HjOp1+CebFx93zwPqUO0HwsEb49SGUk0chMSxFCYMn1SUkE8pJhRb6IQU5LLleZM440VCiPgUCm7eyu/AlpbMZaRec6Nx+o2gdAMKEoMQs+aiNn5D6IW7SGsul5Hxh0FTVtsMnpoVHY/a/HhOlrHn5qxzEBwA9SVWAVg+e0eZUJ8g52As8q1JCuPfMFUTtYbnRQx78c9LZ17Uy0ZhI8qZ2ycUYSQ+Vn5ggNxC8LK6bcWuLpie/fSp7PA+zy+H0VqH/mgSKMVMgZF4rKtRpfC4TGufXxOkn8rn7Q1YnbukHVL4QROBngJ6eu7mz5TKwY7m87qRqjcrXEXSqXA==
Received: from CH2PR12MB3895.namprd12.prod.outlook.com (2603:10b6:610:2a::13)
 by CH2PR12MB4101.namprd12.prod.outlook.com (2603:10b6:610:a8::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18; Fri, 8 Oct
 2021 14:47:22 +0000
Received: from CH2PR12MB3895.namprd12.prod.outlook.com
 ([fe80::a46b:a8b7:59d:9142]) by CH2PR12MB3895.namprd12.prod.outlook.com
 ([fe80::a46b:a8b7:59d:9142%5]) with mapi id 15.20.4566.026; Fri, 8 Oct 2021
 14:47:22 +0000
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
Thread-Index: AQHXsLi5/ezHFM2t80qMnoiP1wWjOauzEi0AgADJmACABBI7EIAAAriAgAACbtCAAAsjgIABjviQgAHxZACADcUy8A==
Date:   Fri, 8 Oct 2021 14:47:21 +0000
Message-ID: <CH2PR12MB3895604241F78A6D368DAD6ED7B29@CH2PR12MB3895.namprd12.prod.outlook.com>
References: <20210923202216.16091-1-asmaa@nvidia.com>
 <20210923202216.16091-2-asmaa@nvidia.com> <YU26lIUayYXU/x9l@lunn.ch>
 <CACRpkdbUJF6VUPk9kCMPBvjeL3frJAbHq+h0-z7P-a1pSU+fiw@mail.gmail.com>
 <CH2PR12MB38951F2326196AB5B573A73DD7A79@CH2PR12MB3895.namprd12.prod.outlook.com>
 <YVHQQcv2M6soJR6u@lunn.ch>
 <CH2PR12MB389585F7D5EFE5E2453593DBD7A79@CH2PR12MB3895.namprd12.prod.outlook.com>
 <YVHbo/cJcHzxUk+d@lunn.ch>
 <CH2PR12MB389530F4A65840FE04DC8628D7A89@CH2PR12MB3895.namprd12.prod.outlook.com>
 <YVTLjp1RSPGNZlUJ@lunn.ch>
In-Reply-To: <YVTLjp1RSPGNZlUJ@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a26349d3-673a-41ea-d665-08d98a6a891a
x-ms-traffictypediagnostic: CH2PR12MB4101:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CH2PR12MB4101E0C9AD2EFDC6805F4439D7B29@CH2PR12MB4101.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: d5JXHRkTTwfOLj4gp+IVi4UyBeSrbDNw2+A6aG4KpMmP90hdzxJ92UzL9G1mxfDnoqpidd9daPd6OyZxS7rEFMeqOeN+9AQ6mcguMMO20OFCFV13U5r+wy/WacQNM4F5w8eF/wP1fpGO6TLa+CuRsf2HKdDnhZMIeeyKuvwyM9mCP7xMl6bvIvL4D2TevUWzHoVw6UM29e1SPT+/e5BWo4ngFBkGedO/Ks7C1oIj7FXoQKtRFLMjt8tUBbqpCk9Vkk/JTYNzMjVlyYt0AWnxny/5Ox0fiYHluadg7HMArZzKrMWlIijWj666Z72mFMtF16AROaBHV3tUqu1LFulb21WOp2XqVIZuQ4vEcj5OEw2n3OLiyLvcr9t1ktWAuKYoWIN1Lj0FKGtDtKKhmlaAxCr1UuOz/VYTpt0PGyyXzsLGzcTrrQGwHrbQatRwrNYvQDQKupx8Jjd4T3hfITDMtzyTOrYjvGou0J+PDhWgbym8VMJfxZi1yzn6sqRqo93r/pNiC+L6M9kwsxvN7ee2JuH4EpTCcBAsmt8pBRtN35t+W8I9XaQawS6BXzaz0KCoVIXxScOqgPsuXQqma3qTW9VR6E7/Xrf8CiEzNcVU93O8CdgQRVf6R1pQNkA7c9sJGKPFRTFlo5ZXnfEVibNcWxgpuhz+onr6003SGMadqNOb2cGCnS61lyEf9/ZhhngEXFyyN37CYS/uXfzBGusIGg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR12MB3895.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(26005)(38070700005)(52536014)(5660300002)(76116006)(66946007)(64756008)(55016002)(86362001)(66476007)(66556008)(4326008)(9686003)(107886003)(186003)(66446008)(508600001)(8676002)(7416002)(2906002)(38100700002)(54906003)(8936002)(316002)(71200400001)(122000001)(33656002)(6506007)(6916009)(7696005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Jw8B0p2WfKHSFZJaGi8uPZ505IAe3941ztDSqmNMI3GnVVmVnjGRcKSQ1AsV?=
 =?us-ascii?Q?tmy8UMM1k0PUnKFhsqpv/yXmY6v8KQQsmq23JCWwUTf8L0nfRFGssCMN8Yox?=
 =?us-ascii?Q?bmU9D707O6YzDM1hAKPRB8JcNlE8zT+pJUldjqn0jzmqcIS2f2bLqnGCkKEg?=
 =?us-ascii?Q?V1skLhDQKwi3LGfh8ZZRVAxTAdZ1HOh4S8Tb5o1RGgeIKXHP/l1YzgJHvhIc?=
 =?us-ascii?Q?buXVLmKzN5vOU6EsCA8oz/XUBOSLaBnzhxwGW6YKN74p2bzzaBbBQxafkbam?=
 =?us-ascii?Q?c5uG12m1gUVS4D3vyLdgRnKAT2fRoAIN5KbFhO9bUbR6NTnhGBL7wBg77Ckt?=
 =?us-ascii?Q?BDTgnTuGJVO8RQOeefVxfqbUSuO+Xv+msDZJ7hYXTqCZl+wQjmUDTb/GYmbk?=
 =?us-ascii?Q?aR54H+ikfFqLypS49ZexcSav7QgMSKkRZtKgH+NqQ9eAVrTa9r6EhsMYvrrM?=
 =?us-ascii?Q?E8sti/5FYG40Ia8ae0QfdZUCDeYrlBxxeu7OmuHl/y4pASkx6D+Fh4Z6JJcN?=
 =?us-ascii?Q?qzF0nqEy/o8C+fBCVdIWu0/TVWuFq7lrj2gyfn0/QP7pkgzBwAKD7I2pIc42?=
 =?us-ascii?Q?riP0Ka5DDaVeIxZucFshZ208HHsmKpoVYkTMgVP4UrE4WrGSyHcHfz4Nx6pE?=
 =?us-ascii?Q?cfb3nR8VBFvgSrB7R2wEkLRCocIomZ1MQ6w0oGJ/gZ758LaKYNM7ucrQiBAk?=
 =?us-ascii?Q?3RmL8etd0vlUwDJgL1IGPbcu07D6BPb+/q1PNvWKGmzoGTIyRiujh2xN4B/Y?=
 =?us-ascii?Q?YmI5JMlu2WNcVXFMn2ahm+r/paIctvVxa9HnhUMy9wsYBu7wHpba2KvrEBBW?=
 =?us-ascii?Q?/yLxr2djmLDz4wFOAIC4Qba59qeWhtUag6y3l3VDer1m1RaQt/DWTVmBH+pV?=
 =?us-ascii?Q?FYPN4Z0xV1emfH7M/0F0BrgokXxlz6T8eiaTT+QI3Yz56TA8Rm0rG7Mb6R+H?=
 =?us-ascii?Q?9zpeuSFR7qnMHSpt8M6BmJ8A1WOBEJvXclBnpkhJbdDEQ53zeKvOuosqDkRI?=
 =?us-ascii?Q?NpzlHlMTdypvo5kg61MitK4L5IsSSFCfSTSIaNS/WKSQKuepzq7+YQoEQDm+?=
 =?us-ascii?Q?Yc2ukP7cHxshZLn9YDJw1q8b97lUcdazZRSf8d6u9AePbqFrIEc3b3uzLJJ8?=
 =?us-ascii?Q?SuDwiPEbKN6V2fgINkW1ECC3A+3bQv8GIv+KwoUThbrzuGACPDv6I+9VtBAX?=
 =?us-ascii?Q?15c+/Ced8/z8WNvJsCCbvgwQlwzxCNkuqt9dPNM9n+U4ItBu9c5F2EP6QLeH?=
 =?us-ascii?Q?J5vgS4VZCDIM+M2HKflNXVOU5KBh9MegldqyyvrQ44Jej1yKO9IymvdZcYg2?=
 =?us-ascii?Q?OsisyN7+sRVOdBWXFwAeRsrU?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB3895.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a26349d3-673a-41ea-d665-08d98a6a891a
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Oct 2021 14:47:22.0270
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OPzdXLWVBYNcOTDeJ1kSiuNO5VA7wUwHUivZ0p47gUc2irVJVfyLg2dDdhOqQzLBiPE+0Mjm4bMBSbTUSLwyUw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4101
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> In KSZ9031, Register MII_KSZPHY_INTCS=3D0x1B reports all interrupt=20
> events and clear on read. So if there are 4 different interrupts, once it=
 is read once, all 4 clear at once.
> The micrel.c driver has defined ack_interrupt to read the above reg=20
> and is called every time the interrupt handler phy_interrupt is called. S=
o in this case, we should be good.
> The code flow in our case would look like this:
> - 2 interrupt sources (for example, link down followed by link up) set=20
> in MII_KSZPHY_INTCS
> - interrupt handler (phy_interrupt) reads MII_KSZPHY_INT which=20
> automatically clears both interrupts
> - another internal source triggers and sets the register.
> - The second edge will be caught accordingly by the GPIO.

> I still think there is a small race window. You product manager needs to =
decide if that is acceptable, or if you should poll the PHY.

I talked to both our managers and the HW team and they said it is ok to use=
 the interrupt for our product.

> Anyway, it is clear the hardware only does level interrupts, so the GPIO =
driver should only accept level interrupts. -EINVAL otherwise.

There is an on going conversation with HW folks to address this for future =
BlueField generations.

Thank you.
Asmaa
