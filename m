Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 227A3440088
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 18:46:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229837AbhJ2QtD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 12:49:03 -0400
Received: from mail-bn8nam11on2065.outbound.protection.outlook.com ([40.107.236.65]:28385
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229607AbhJ2QtC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Oct 2021 12:49:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aVk4Hk8pCs9nwxPTpym6J7q/0wcni2PEATL5dl0fD+iZKRgMqcuWunMdLsM/xlUz/5pY4netetJdyXmOd/3/jrCM1+FBDKAaUsWejbaTi4PnTT1KDhvXwUxNTuxsUAyDbBkwRe4tsgyr+9ikckbXzXHqbTlevvww/JyOeptXW/kHrOb5X37GNtKDlg3fVxCIj7LMSSz4lJ1VKqLmdP6qxsPZQoe7ntMgVHXC42etdxSB0xwzui/OVD+oR+/De5xJnw/swA0PFZkT+EI5JBNlgJQzqw2/tPbw/+XB4fKjFox8Ckwoc2oS3I/kicj4pJitJpQ1NOSKQMEX8ZvL7bkXmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3zSAiYCQfG7r8ljqTe21dJsvWHxWok6RtK4CFs1FNo0=;
 b=NTX1EOW0Tj3Lq6bUbxMjaBpPdD6hd+/VSqD/sVeS8DSL4qP6FwrULeiz03VJU1qPH0F3yplLIQoSjnaynsMZrhmxa2yBPXlNT0P1Ds0ue1wYJJmEzwokEzuR6n/iykHGI6FRYDYrgEyZpTj1HIOHILEG1qCpJP84IdjvPZpLADQzFPqXcJBKIAgV1dEy6AOpZgpG8gv9L2oroW9prLUh5WI4DBbWUYpxcwnMsWOkkDAwZ/Hmjo6blQuP8DlcAnTghK1SeE9bHKDooaG5MVKPxDFv1wC+43IDR9Rwj/shCADT0jsVBksa0Wm/o4TT2wxZTTeZujrKFRaIsqhkDTqm8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3zSAiYCQfG7r8ljqTe21dJsvWHxWok6RtK4CFs1FNo0=;
 b=KG0C+hvI3IxGP7nexQ3ddppyJ9JMClbmoQGFPj4jNdRyYNip6kD5gQlkrwYXIhbsU7E3GllPadZV3Ik3Q0/TcdxGpAXUf2o14Cu2kYDFAAGo5JH18OaWom9MLbdyZZXyD6fB2Shp9BJy+dVosWqOPmr6OPYn3TAle67UeOlKa8ji5QNN37az58sBuHwDZFXEnRS0VMwz+MgqF4xm56t5Dp6L003ISfqV/q9CBfrHV81wWmbLtlKNGsdTAltcvzgINe1/gnsjRPDcmww2g7E9ohtj/VoLVlcxvlFr1GXoolfwh1YOgconhaArTbmAGS8QViHDCTOwr8b+ggH2/dEm0Q==
Received: from CH2PR12MB3895.namprd12.prod.outlook.com (2603:10b6:610:2a::13)
 by CH2PR12MB4971.namprd12.prod.outlook.com (2603:10b6:610:6b::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15; Fri, 29 Oct
 2021 16:46:31 +0000
Received: from CH2PR12MB3895.namprd12.prod.outlook.com
 ([fe80::601f:cc3:1f01:9cfa]) by CH2PR12MB3895.namprd12.prod.outlook.com
 ([fe80::601f:cc3:1f01:9cfa%5]) with mapi id 15.20.4649.015; Fri, 29 Oct 2021
 16:46:31 +0000
From:   Asmaa Mnebhi <asmaa@nvidia.com>
To:     Bartosz Golaszewski <brgl@bgdev.pl>
CC:     Andy Shevchenko <andy.shevchenko@gmail.com>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        "David S . Miller" <davem@davemloft.net>,
        "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        David Thompson <davthompson@nvidia.com>
Subject: RE: [PATCH v5 0/2] gpio: mlxbf2: Introduce proper interrupt handling
Thread-Topic: [PATCH v5 0/2] gpio: mlxbf2: Introduce proper interrupt handling
Thread-Index: AQHXweR+tF9fiz8nsEOmSLAd12nUwqvdx00AgAx9hsA=
Date:   Fri, 29 Oct 2021 16:46:31 +0000
Message-ID: <CH2PR12MB3895A1C9868F8F0C9CA3FC45D7879@CH2PR12MB3895.namprd12.prod.outlook.com>
References: <20211015164809.22009-1-asmaa@nvidia.com>
 <CAMRc=McSPG61nnq9sibBunwso1dsO6Juo2M8MtQuEEGZbWqDNw@mail.gmail.com>
In-Reply-To: <CAMRc=McSPG61nnq9sibBunwso1dsO6Juo2M8MtQuEEGZbWqDNw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: bgdev.pl; dkim=none (message not signed)
 header.d=none;bgdev.pl; dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: be410601-8f79-4231-e853-08d99afba917
x-ms-traffictypediagnostic: CH2PR12MB4971:
x-microsoft-antispam-prvs: <CH2PR12MB49719C1034DC69E9E55752BDD7879@CH2PR12MB4971.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: p2Th0CLWHjmwDaZO19mHRolX+W58sTDwarh70ncnomG/lMujduNZiMu3YcOkqWE4FtvGKMjkfKU9ZetRnb9GAb8A0wLBiTpzokM82RHHH7Qi4NpORz/JGaquCt0h4Q8wC7svB6xPZMOY7MGWmbOzoEmbJvX3uuc0Xi5qXujp1FrcGLU0rBos/7KsJcN2KpcekFPSSqjxRc7xTbcgwJpsouRGz0T98oy6ywq+51qEkZd5y90ni8LPLg3j8oPtnyB6xGMWKpPFbkZRbHmLN7UM+2wXYkrXeGN1oZhel6Kclk8aAJP4uPU+moQlN3cISgclQ2KyOhMkjB1TLntz80KPlx0TU70Tfo9x+3QWESV556jHXaVqT9FzsJG+CLTH4CcyQBPimosIgmSGqBQgxclc9yeStaCefx78Y42alHtxyG+LE80a1O3suAe1bhdizfTZoSUhstUA9Z4cvQ09szl0ufT0mCdPK7Guebo7CKvJhZTctAxa1jgvwjyIkip6UUXZrB6zoGLe1UZvSjLaIAbShVpnLXY4pcVH4FL6HwWzbkFhj3zC5sdwitiO8Uv4O0oZ011WywBYi4zAFHWnD0ql7J7ZQlUvAVAjkZqU3EXfX8BjiGgkT2GkmY3ETOCXf5K4em9f2AFxHskJ/MV3+9LXUK97v9fZkoj64q2keFC2wl/yJPgdF7ByFuf7NCKnOe8oYJLgcqgk8A8OZ6GOq2ZOvur6lFCQT1AQSAZlPbzM8I8a7830WqZj/U/zlZaAH1ZwFN/wLSGvKIUXhhOwTPiGo0hP7AhP1NlWIxbo5eERdZw=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR12MB3895.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(71200400001)(76116006)(83380400001)(8936002)(53546011)(186003)(7696005)(508600001)(107886003)(66446008)(64756008)(66556008)(8676002)(38070700005)(86362001)(66476007)(66946007)(122000001)(38100700002)(6506007)(2906002)(9686003)(33656002)(316002)(966005)(54906003)(26005)(55016002)(4326008)(6916009)(52536014)(7416002)(5660300002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?iwgIdcgTVPspTxRIJEHlX0lMaJGWrkJyMR70/jBpU7A9XL7nfEoiSoTZzwjB?=
 =?us-ascii?Q?2TibV8SgSkFhVUjBvD4WmUslLrehE7vPlKdnhFrKDqHpKkQulsZDdx2x1DL2?=
 =?us-ascii?Q?Lbs2u8z9Wnm2iwYT+78N3WlD/9oQYPekt8TCAJBwJx6cakL4zHG2rWY64Pzi?=
 =?us-ascii?Q?yzykU1q15EG8n2lHC7iCMnbNxKRpC6H3t3RhMVF1qC5Zd0ynYwqhqNhz0yBi?=
 =?us-ascii?Q?+fpiISYqhQHbLlMvwAkuyJVMZhLDTX1cmCnqlQV/lMoUrka9W889z3w06A1R?=
 =?us-ascii?Q?VCw3H2YaxktksFqDSK/JMdntWZM3eGZmyBLS4dWeeaeit2jF5nS8AQvBcJrS?=
 =?us-ascii?Q?XpPWPoNIMY3ORwyCud79yCrfZIy9QAanZnnaLL1bkxRm4z1hRtuzQr5cdHgY?=
 =?us-ascii?Q?hwt2KobqZrz4nuGnbbhhCvvHhSXmW3BdynxROtjByWDjknaVkyo/R/G1vJKz?=
 =?us-ascii?Q?WmrhYJTQsrP0ho8UDp3YpOsI1H18WoWU+s2YtUZ61otOnmRMyqRpdUKM0+kd?=
 =?us-ascii?Q?VYnCYb85A4g3s+kPZYU7eUoIdYNFobeknF8RrARylgfgOrj5CKvu/S9bsjse?=
 =?us-ascii?Q?+CloqIW9YzsD3XQgIEbsLbBaONK5MgIeFWB0iGyj1yKUgJkphf+9JMqjrRBa?=
 =?us-ascii?Q?lSz13WccPijUGoVj3P+O7SA4SEFzEGXnlWszM4I7tjbYsJJ6DcjCR4HT4uvd?=
 =?us-ascii?Q?T7TgXo+8A8Q/QbkwaLgpQ9RYStc3ty4QUzUoRfgYtWPISl88lpxRZ8+jr61f?=
 =?us-ascii?Q?Plv0voiqGLuieGt6CtZGTJQLyAHS6mpf/tZ5/XSvN2G+sa8d8LUGUg0PLCgS?=
 =?us-ascii?Q?K4VXc4WmGzEzxdYglbNbOMYAZyPGcIIcGjdo+8NLLaYb80ym46vmBxEeYMN4?=
 =?us-ascii?Q?Irv44Pz4GOWhKCoqWzuYJNyVV2WhjOMD00KS8MzLJUjCvOmhVT99VVAHLrG8?=
 =?us-ascii?Q?2fUoN9AxvrHXtVMKjKOE/zS1f/DFkOArnzQsKI9QFBxIIGqKkeZpe3mFYXsn?=
 =?us-ascii?Q?apSgH3sAK6HqA7P4L+HxXYJEZ9pYVT7EZuk7luXsDPjIBUEl6Hv/TnU8vE73?=
 =?us-ascii?Q?8NuIPjwJHG6zQEqT9NVmJERkI0E69f31pbL1S/yFEvCHWV4dZ2ccW+6dYylM?=
 =?us-ascii?Q?AmyQjAqTIvldDU9tUGd9KGr2nPps+UihcjsP2p4QXwB2UexYunmPQZgfuaiD?=
 =?us-ascii?Q?OC0KsUaSIujEK1gYtVF1qaEdCL8+MqF1kOJkl7rd8Kb32kw0lClkSgoKa2FM?=
 =?us-ascii?Q?y3g2TRDA82Sqac7ZcInJS6/F1NarS6f2uS/6onzhQjUdUsEHFJa55bJDm8YI?=
 =?us-ascii?Q?j2wwPISv1fgaKRJAA9SqOTtIgD1aOmDZo5Napqc2/e6Dl+U5rzB1ccdvYY/H?=
 =?us-ascii?Q?kuQ2ieX44qFU4i1isbH/8G4UD7Yrn0asXzRXloWGdE/m5m6aL1qz3aduu/al?=
 =?us-ascii?Q?P8g3IgpIjMD0ZhHK2CGsLuwH0mAcdf7W3FRnJuj6WR9PRi/EeCRaW8j2Hs8a?=
 =?us-ascii?Q?0FM2n5qwzHpnfbzJ8iQrqTRxXhmhX8U6+DDmGKbRhYGHSN8o8EtpVAWVFqkJ?=
 =?us-ascii?Q?DiVpuqltCPYQYoKu5pjDe/cCy6BAcxRzm+jKcK1nQa2r8ifcyEg6UWr/git8?=
 =?us-ascii?Q?hQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB3895.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be410601-8f79-4231-e853-08d99afba917
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Oct 2021 16:46:31.3081
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EvwmsWdKKH3+0YvtKSM9w4PCXNuRHPr72nHcFl6YSFYRXgunCG4GeX55QsRBOY3CmMq3K0GQ2PWebpA1QkOrSQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4971
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Bart,

I was just wondering what is the status for this series of patches?

Thank you.
Asmaa

-----Original Message-----
From: Bartosz Golaszewski <brgl@bgdev.pl>=20
Sent: Thursday, October 21, 2021 2:01 PM
To: Asmaa Mnebhi <asmaa@nvidia.com>
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>; open list:GPIO SUBSYSTEM <=
linux-gpio@vger.kernel.org>; netdev <netdev@vger.kernel.org>; Linux Kernel =
Mailing List <linux-kernel@vger.kernel.org>; ACPI Devel Maling List <linux-=
acpi@vger.kernel.org>; Andrew Lunn <andrew@lunn.ch>; Jakub Kicinski <kuba@k=
ernel.org>; Linus Walleij <linus.walleij@linaro.org>; Bartosz Golaszewski <=
bgolaszewski@baylibre.com>; David S . Miller <davem@davemloft.net>; Rafael =
J . Wysocki <rjw@rjwysocki.net>; David Thompson <davthompson@nvidia.com>
Subject: Re: [PATCH v5 0/2] gpio: mlxbf2: Introduce proper interrupt handli=
ng
Importance: High

On Fri, Oct 15, 2021 at 6:48 PM Asmaa Mnebhi <asmaa@nvidia.com> wrote:
>
> This is a follow up on a discussion regarding proper handling of GPIO=20
> interrupts within the gpio-mlxbf2.c driver.
>
> Link to discussion:
> https://lore.kernel.org/netdev/20210816115953.72533-7-andriy.shevchenk
> o@linux.intel.com/T/
>
> Patch 1 adds support to a GPIO IRQ handler in gpio-mlxbf2.c.
> Patch 2 is a follow up removal of custom GPIO IRQ handling from the=20
> mlxbf_gige driver and replacing it with a simple IRQ request. The ACPI=20
> table for the mlxbf_gige driver is responsible for instantiating the=20
> PHY GPIO interrupt via GpioInt.
>
> Andy Shevchenko, could you please review this patch series.
> David Miller, could you please ack the changes in the mlxbf_gige=20
> driver.
>
> v5 vs. v4 patch:
> - Remove a fix which check if bgpio_init has failed.
>   This fix should in a separate patch targeting the stable
>   branch.
>

Hi Asmaa! Did you send this fix? I can't find it in my inbox or on patchwor=
k.

Bart
