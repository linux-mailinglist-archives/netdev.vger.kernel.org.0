Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CB30436A3B
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 20:10:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232223AbhJUSNH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 14:13:07 -0400
Received: from mail-bn8nam11on2066.outbound.protection.outlook.com ([40.107.236.66]:18912
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229968AbhJUSNG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Oct 2021 14:13:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q906N8YzDiLd/honhY990NZ0+SvGE3BX30C6WUkf6F+6WkJalzhAP5lK/PHS0vyMLMEn8VfaUDne8l0TvOTepksLIWq5hbboGb2CsxxKI32jt3CDsLe1+CJojc8APZvXc9T2H1QOu6zFwT0uimks3HmLbgHCv5WfaZ++FEmQMyO/NvBIPCEqOD0Hrvxtf22UQmnklPGzjhmlkcaSnIget39I0iDypPAWxCHmYsj2dkxPHZJ7CfCDj/uIs5V6nCs0JzKp5aTmhXcnZQc6htK3VZ+AScUP0ANKNnaL/ybaPetrbbeoGxPb2klg+eWgmz4Mbb4Idv7Aic4HEEFxEd8goA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=br3GWzL3f0D4d/WF94HQPPQ0tX3/EHaKv9QW/yLcUKw=;
 b=dNo+qMpc3LWaA/IUgvT4jKJv8xZVM/Urv9IxrQnsPcO5FK9ZYyyBHwaSC+UIlzprCkEoN57yD0awo0Cz5hF8RHckYxX/XAMhnzXb61q8emf0F52HPGbnO7ecDbAlt5P6Ds7YWBnLFOYWKScyHX9dn24lBS2QGABCHubLN7Tp8H5OrRVLg7NTFCxmJmLni4dz+Q/ymhcu/Iub/6Tk5hOkN7a11Z7MeMuDHKHIhSiL8ExGnw2Shdcx6pLHpc61eAwWlwC+AKYBTkKEktz8Iap8htV4rRtOcenZOdkfry+f6Qad6CBYDWEGArBi9QnbVlcIet4jLYhSwtvQo13YM650kw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=br3GWzL3f0D4d/WF94HQPPQ0tX3/EHaKv9QW/yLcUKw=;
 b=UZiSrMCgg5DkRLvitPYLXDlzgdEjJuQhPTk63zcEJtfyVsDzYQ1fQBUpUFK1A7mF5y1aEe9R+0hsq3elhpfcvPZnqfeBERbFKh0qoqHbFoUFMlEsFbh/nqTJ0NPcU1YhwKcEgMmRyXLoWFXwF9qDawM1jlQ9FDA7D/xE4PVuHkTyhWaPXjA5TFonx1gPDBGlCUMGBz6cK4ITIOUyZrnUZ28rVB++AaT4WY73/wAiIldzIKpgnNP8ss8Kl0xSFLR3+JlslFd8vqARo7QIXKBFJzpmIGI4D5gbA7aR3ciK148mpXPtvwmZKlpCqBJcsn0yDMlJ+KpZO+8QDo78gefguA==
Received: from CH2PR12MB3895.namprd12.prod.outlook.com (2603:10b6:610:2a::13)
 by CH2PR12MB3813.namprd12.prod.outlook.com (2603:10b6:610:2c::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16; Thu, 21 Oct
 2021 18:10:47 +0000
Received: from CH2PR12MB3895.namprd12.prod.outlook.com
 ([fe80::a46b:a8b7:59d:9142]) by CH2PR12MB3895.namprd12.prod.outlook.com
 ([fe80::a46b:a8b7:59d:9142%5]) with mapi id 15.20.4608.019; Thu, 21 Oct 2021
 18:10:47 +0000
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
Thread-Index: AQHXweR+tF9fiz8nsEOmSLAd12nUwqvdx00AgAACc8A=
Date:   Thu, 21 Oct 2021 18:10:46 +0000
Message-ID: <CH2PR12MB389572C086A0F7910B8B2559D7BF9@CH2PR12MB3895.namprd12.prod.outlook.com>
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
x-ms-office365-filtering-correlation-id: ac9eef66-b988-4ef0-61c7-08d994be1b35
x-ms-traffictypediagnostic: CH2PR12MB3813:
x-microsoft-antispam-prvs: <CH2PR12MB3813A355516DE274AA7D89BCD7BF9@CH2PR12MB3813.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BpnGjtXV9Zo3Knnzn31gIWFlqYtO3p/q7V5YXVazvWeX5djibbRNPKs51IoscVWB6uyDSX3gpB/2jt42dNElWCFrGFM3QBvLfwUUN0PWY8SREi4Vg7as0aszNg4Z1quiW2iwk1q9nd3avpI0b7T+ctxmk/LMt2+VM/AaIdlhKkb7akXGFXx8reOE7lC+VdOjta7VyMe6lTCvjuae4VGe3madq1AkyjXSs+WKUGoqg2zVJwXyno2TdmvpuKFxIxDOWsBLQNY7tKHgCCw40fuIs/jKBYEIM/pWF4QebC9q/xcHNTtkRa7jnD4WZM+gECe1S1EjrND+rPQwZD4tvHvQtkbCFHxiXxQsvH1tqhiiXKEWWJ0Uvoas8tXKUN4rutAV5mFW1+wNl2DQvnAyOadMRNdB6zjyDqreuBwSnL5k864OdOWBJFon5fO8qJ7zY0VEs89VsZFsopDaSXHx53KhlvBt66SMciTPlU5PVik9Qlm/58xO0TMbq6BfvriA3LwbIr5SsDtTXFTZTPkyetcKC7cICeHM/hghe51szKO5PswgiXNV9RTo9XdXCM4vitWbNtlkLyAuYsmXoyGxMy44oGfqI4sDY9xyveyX5WqfUeGfvRsr/+Fw97Kd/+YVxGXFAKliR20k1ToZEpcyczcwowSzGcpUgogieMTJyqlMhqx9tVMy+n8/H77NLIEzHz3/wcVnxS9S/Kq69Lal5ov35vp5WFRFrtsqJuJMO6FCu8w+gQTp7fEBAvobtPX2d+xqtDZGvMiwAfUN/pxGX9SWW7U08dEPk3bG2r6vRc1F7+Y=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR12MB3895.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(53546011)(8936002)(38070700005)(6506007)(8676002)(508600001)(122000001)(38100700002)(7416002)(7696005)(71200400001)(966005)(2906002)(9686003)(5660300002)(55016002)(107886003)(66556008)(26005)(186003)(52536014)(4326008)(66446008)(64756008)(66946007)(66476007)(86362001)(76116006)(6916009)(33656002)(54906003)(83380400001)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?SibRGrunzDIw/VNuhy423wvk0q32vzLfsLxbGxh3ebKTiTQ5HTw30W90096x?=
 =?us-ascii?Q?B1lDV3Ut9vuPXfnjxDrm+oOSjKzPFd6Oil+lCQ64Gqzz3RhgWJMgzMw7YHKL?=
 =?us-ascii?Q?7yROiaxkSeonccgGMaKeTWmRwylsmkI/ZZ7WMTujP284cBatQwdefr7bgMtF?=
 =?us-ascii?Q?mwwGGFgDEpvGdkw9Hf7YPUaFEgw1yHAnfH7cWOiCN5wfIvE7HcFNBmSArxT+?=
 =?us-ascii?Q?AygoO8rEbxdIslQTnQs/5MQKBllkqwIfvMrX3S4B9L8QUn5UaA9YTKf4Fzzo?=
 =?us-ascii?Q?vtwimZ/RgV8K54pXx/LaACvNsYYlT1yW/AfRAFnYcbFXX8gIOYp1lr3IPd+Z?=
 =?us-ascii?Q?6n6by6LFdK850iaE4HiMDM9YjEnoPoTGS6D15AJWP9L0r3suo25GeBptxVU1?=
 =?us-ascii?Q?T///EocYDGSxxLoHBfxpGN4nXWrAebHm3y38hdRVA8EUD3VHObVCcqC5b/qa?=
 =?us-ascii?Q?JNbHbl9BygqWEGbY1eUzF29oIdVP9M5DVAfy/kZ/SskAfIwmfCKGQhXEhocF?=
 =?us-ascii?Q?C/LP8YUL1w4ERjZRGYWpc1Vb1H6TCxGss7zm7dUTKEl1hItfjaq74K7pTVdT?=
 =?us-ascii?Q?1r+b690VWAYosEHl8aHvOTs/RL9aKVr9Q3yBLgBCiDycY/8GKNVGHbaf/rqJ?=
 =?us-ascii?Q?wIb+NTe913j/H7NLztgzm32Y073mONsr0K7DBhkX152ZlsJBwZY87JdfpRFA?=
 =?us-ascii?Q?zgFxc73kyY9C07VPi0BvbjOttyXeMsfa0bIbx8rBd4VX6bbZ5zkgP2lqT4o0?=
 =?us-ascii?Q?fJvSivqxTvXLEmKpxr3vOkJWfrbHq0AJPM6mpm52JhZXhNxQZJkqgXve9h+y?=
 =?us-ascii?Q?hvjkfCpVsivfOSCppPUPT2/SbvhJOkePY/fmr77IM3nv88Otdu+p6Lfa9B6n?=
 =?us-ascii?Q?QPJKtqbzksw9B4haVTYMXox1PPrs9/+VqT239KXnjSkU+L+1ZJj1W2OmCKVM?=
 =?us-ascii?Q?AXYuLGctzkPUmhTz0Apl/TGeIOngceClRwdMJGOixwd4oz5nPVz61e9CoWOP?=
 =?us-ascii?Q?Ja6wN53bGVgO2Xsv9AeDecwTduxfbSSb3rQJ8dKT6STPQ6rWoCwRSlG4WGej?=
 =?us-ascii?Q?gafjQqLoPKdqO/qur4GHPz6gT1GYOgGiECS+jsNnwYwvd0pOtsCgk+nXpTFC?=
 =?us-ascii?Q?i+ohHVek0eQavSZs/xoIu/IIus0KPcdS5Sbashq3NyL0uKWTY2kJehXBfeKN?=
 =?us-ascii?Q?1k4nOo8nbmFHuVuXtud5/MCpSdFZ/mNuZVu3rIpMPV/YLj8oCAjokObT8hVO?=
 =?us-ascii?Q?23T0XCWMYjUVbZKX0XZh1BBzpQ7s6G6jkQyTXxQZYfjvjR0DV6CLnKGBz8Pe?=
 =?us-ascii?Q?rbAX5niioD2Y3ysW181QrwjGvNc2Emll9ey2v8ih3Krnj5kPcXis/mZHy2HK?=
 =?us-ascii?Q?0qyqSl1PiZGKKQYLgiOlcAyyZASQlSpN/b3IHdShRmVmO8eEhFaT/LHLt+BA?=
 =?us-ascii?Q?miMy1mn4KVQ=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB3895.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac9eef66-b988-4ef0-61c7-08d994be1b35
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Oct 2021 18:10:46.9426
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: asmaa@nvidia.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB3813
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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

Hi Bart! I haven't that separate patch yet. I will send it shortly.
