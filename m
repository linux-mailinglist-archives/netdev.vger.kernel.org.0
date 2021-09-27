Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0518041964D
	for <lists+netdev@lfdr.de>; Mon, 27 Sep 2021 16:26:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234827AbhI0O2R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Sep 2021 10:28:17 -0400
Received: from mail-mw2nam12on2089.outbound.protection.outlook.com ([40.107.244.89]:15148
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234832AbhI0O2O (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Sep 2021 10:28:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ed89Xc1gpXP5w9hEK8o/ZJiyDJ702kdfuK1HX0SG7sp33+dGGhBDMPYzWW/NvgYfOTnI+mKmRJ9nUoZInt6kRgEGdecGtXs736WfLr+Tm6IZupS679B92EWEZOeB59keBlvJZ8wgdOCnSmmgqgvKhu6deqE/2fbQ7dQmo6GQ24n/ywiVkmo0vdEOUGYGDfje/+jhlOQ9/WcZCEeO47BcGHaQ8phja0A991uXdqJQ6fPun8rfZWXvPlqY9Iv298Os5Z+a7eRKHAZHXfmaNUImYr+pqxLTtUd80bheeguaM8cz1V6XfzohIoJgquvZNMjxHHOnixBVWfgC0hLodfDOcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=cfnK3UemhEAC/V4DyCbySzsfmaet2ykLYF3Ym3vujO8=;
 b=bws28Npp8IyKKtqLLRBE3Lbj4jdsBNZJQKJOBeiNcgOVqSNJY1W9EoNw38RW6u4CiouHbZzJe/mAi//c7itYXosXuKPJ9PRlenUPNCwHZpwQi15GViNXDKkC+rMmwVUmzKsSBrd0qi/mYOoMO5O7b3o2legFfcZwtvAGhq1lNJgJpQGKEwtZiJXvpuTSZOGHs2/ZEzFN+TH9sIZR4CLoFtQW0HSRBbc2LPBoutLdyL881WC4/VXBSmILUBJ4GHH7Hd80X6UEDlmdGyjR6ibQuBkI3avoBFcqA1rZgDdtoiixEY8hi3tkC7PEMi+tYjheoDS96aI30KWM8HWUF4oH5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cfnK3UemhEAC/V4DyCbySzsfmaet2ykLYF3Ym3vujO8=;
 b=c59yBHVmDgMU7bMS4Fjt6q77/iX+TvwSQUbf9jmKfaWnAkgj6kEBdA+VJ9c5QBs+ad0eFK5iZhiAP9f1pElWNvvdXA58uoHq897YJ/vEAsrOjTYAS1Mo9AqlXY6IdGKdlTu84drQQLXy4cVNeJU/uXVYY6A7WqiSAeyZpgtLb4QGrVMnjcL3Ius1Lo08WekTz1fPN6eMuRszwg5T9fQ9Tkg0AnZLmFV2S54uGCscNDq/bMbot0K1gHY1UvNNv06yJht24e7JFWOaxIhuoQA9CUmaw+aHAedZQ4H5a+RQo91e9JMjDB2439lqYgo8buoTPo6Zejx7fSCa7StMNIlcQA==
Received: from CH2PR12MB3895.namprd12.prod.outlook.com (2603:10b6:610:2a::13)
 by CH2PR12MB4295.namprd12.prod.outlook.com (2603:10b6:610:a7::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.15; Mon, 27 Sep
 2021 14:26:33 +0000
Received: from CH2PR12MB3895.namprd12.prod.outlook.com
 ([fe80::a46b:a8b7:59d:9142]) by CH2PR12MB3895.namprd12.prod.outlook.com
 ([fe80::a46b:a8b7:59d:9142%5]) with mapi id 15.20.4544.021; Mon, 27 Sep 2021
 14:26:33 +0000
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
Thread-Index: AQHXsLi5/ezHFM2t80qMnoiP1wWjOauzEi0AgADJmACABBI7EIAAAriAgAACbtCAAAG8oA==
Date:   Mon, 27 Sep 2021 14:26:33 +0000
Message-ID: <CH2PR12MB38956613C5D7ACD6078FC86ED7A79@CH2PR12MB3895.namprd12.prod.outlook.com>
References: <20210923202216.16091-1-asmaa@nvidia.com>
 <20210923202216.16091-2-asmaa@nvidia.com> <YU26lIUayYXU/x9l@lunn.ch>
 <CACRpkdbUJF6VUPk9kCMPBvjeL3frJAbHq+h0-z7P-a1pSU+fiw@mail.gmail.com>
 <CH2PR12MB38951F2326196AB5B573A73DD7A79@CH2PR12MB3895.namprd12.prod.outlook.com>
 <YVHQQcv2M6soJR6u@lunn.ch>
 <CH2PR12MB389585F7D5EFE5E2453593DBD7A79@CH2PR12MB3895.namprd12.prod.outlook.com>
In-Reply-To: <CH2PR12MB389585F7D5EFE5E2453593DBD7A79@CH2PR12MB3895.namprd12.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 69452594-ad32-4e60-67f1-08d981c2ce6a
x-ms-traffictypediagnostic: CH2PR12MB4295:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CH2PR12MB4295CF292AF6466114663405D7A79@CH2PR12MB4295.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qsr0d2sN+uL9UoL2rqWc5f++rH8KkNG7EZVg8elYVYNOkTM3NwKDckF/fkaxnz4oqhq72kjiK2tpBJ61EjJPbi3ue9Py45PcLQRg+4ABwAKli7sXM8hSxMBfWwu30y7fb/FTBD1SFXJg16wUZaikIzQm/Xs/m1gtOaE+ZL9FjUhwqUOVfuokwTBnysvb9pzSr9thvp8Tzm/L7/CrGBrV5F8Pm4fc0n0W/2xCZ5ADpMzj0Lpe72imt9t3niD3xrkpFwSoATSHDpubsFX/6xYfZ27aU+Cpu8Xris5ypuK72bvYVhCgRwyKGzPr3oPpTzi531d9BF/BBd4MoPm9FFiEhZV7RDNzXiPyyLztf6bsoFMBLY9IY5CkqlvwhnB6YNVZ6KGKX4PtygLWuAL7bCbZPzdRvdkEhbwg95+eXoNgIym6D8qOz0mizSO14gvbUtGvZxCAweeZoLbqqYNu33qOBg5CZ3Lg4Y9bHPdRGU3nQjoCQQXvSCrkjPcCdxHe/yYC5Iu5BQ/3ZRMchU0+3nusucdA59+1/ND0qr5M2hOBzaRlOVSrqRCWj6a4qDwpREebu2yy5+ZIggyejtRCMxB7jbFSN64SuP8IrtIOQ1qKCvTBapvSDzcYfo3j3o5VPbFsbXEHNFdFLgPP0ynXfzXZR6rn4lMw3V4hYTuHIh8niBPos5UT+7S+UBKBV1wc2vCTWvZIDa3lBzbMrel3Ounf/Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR12MB3895.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(4326008)(38070700005)(4744005)(33656002)(86362001)(6506007)(6916009)(26005)(107886003)(38100700002)(83380400001)(122000001)(2940100002)(52536014)(186003)(7696005)(9686003)(71200400001)(76116006)(2906002)(8936002)(54906003)(316002)(5660300002)(64756008)(7416002)(66446008)(66476007)(66556008)(508600001)(8676002)(55016002)(66946007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?LuFQAmypfRQ68vamzwC5fdAiCyj46MA3j3IC3HT32eHBsHuqfdoZaNZ5tEcl?=
 =?us-ascii?Q?FrVWUAZLQAfb96Tnqrgh5tIt/UeshYJo3BJ7UPSvfP522lmThoqVFQEo9Sag?=
 =?us-ascii?Q?z44/OY7ijfS+OtnGEG98NpAtbCXovgx0ztBExuREh8GLwhnJUm8ttDHpRBGJ?=
 =?us-ascii?Q?Yy+4E2mFdis8ADWsWBNiFmHdRxWqsdnfTOZ9YrAO86a5S4+oVO9s3q6uaHqF?=
 =?us-ascii?Q?tAf2IajPZijWAsQ3dc99vZg2YjYnKDISLkJRRxIQonn1WtHXOwtGOclD808W?=
 =?us-ascii?Q?va4pmVx/oR4v1VZMwSLLlE5NC8ZByx/cjzfDkIQo3CxNMCIzo/92O89JRIAt?=
 =?us-ascii?Q?mG3nnVfUdnAACiyM/Ge10j2XmBXxNOPHwWZuTUqjxCRTDiN3eLVPUk9rveKL?=
 =?us-ascii?Q?0Yg7HbCdYL+PwcO1Wth5e7YjlhJG/UyP1kYw+Dx4f35IblvHeAxEPXwE9NQq?=
 =?us-ascii?Q?Ku+iYcayWLeLh3fZsFqqTCqZDN+hu4l+79MbRgefG/R59k88admhfLw7yzaR?=
 =?us-ascii?Q?UNrAJHY20scWUHvUjjXNFPfV0idns3tXNWwa3ib7xaZrvXnqq1Rmsrz1H1Zr?=
 =?us-ascii?Q?sajBkEO3bKBB4ni32CxnN7k0vvj7W8sieTdtxYOzzVupsmiXCKK2aeAGf0UX?=
 =?us-ascii?Q?2Cgpf2rr1nKqmvUPZognTXYI6N62vme6tv/MdKCk5hrFj0ZS2u4vb4Y7mkH0?=
 =?us-ascii?Q?d0tyLm81e2u81NVrjNwO8AF1rVWskJBmu2fmHa74DmdR57tPN4IglROsiVph?=
 =?us-ascii?Q?CHMaK2n873nu9xcb2apUXmOWSvM/xRkVqSnTU2fyFzvPC60UKqDQNHhp9dKs?=
 =?us-ascii?Q?XaIGYMDAO+PbhKPKwCPGW3NiOfydtVMKBPumFKesXE/0iKYcKFIC7FORWipK?=
 =?us-ascii?Q?JbzC4kb3o/4zWRJIDTH44sqbN/+pu00zoWor1UCsyTwpreNbwJiBlSltTucF?=
 =?us-ascii?Q?OGUsEcRpGLlfSOKdUhdRXa1b3ZeB11QqVra6Lpzx0NIO8B8WODw3ULu6nBum?=
 =?us-ascii?Q?3A1OZd9YkPXhi8koUA8XwenYy4ipXXI0Rxnw2+Xv8U7ubEm9FVJLVKE8RIwE?=
 =?us-ascii?Q?/MXKKfW369b4n0acxzZibgTJS02QTL+Am6FN8T0EIuyOIRMrk0kP0ZY7Xmm1?=
 =?us-ascii?Q?918GoMnR/IeS4jpC2CKmFoEOY3DyzfZSnc7l1YEaMLfKVPS2zZ28K6hj5F5D?=
 =?us-ascii?Q?TNNAhnT7LAiD2MUNV0TjRBmjFjiTEJ5+mFvGyoTwTyA/soWV0xahE4bDjS5s?=
 =?us-ascii?Q?iJWOhAkrU9hfgXhLNU+OURHKxc3tR5ft3csoREL1tMBluQo2MZfopzAkJJf+?=
 =?us-ascii?Q?z1LkzOst4gzfh3r1KmB24P1c?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB3895.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 69452594-ad32-4e60-67f1-08d981c2ce6a
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Sep 2021 14:26:33.5504
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pze1czk5SHdj7RRwlaGi/I595o70ZCsytatblKJG5gDRi+flZzh+GU67nitO+cz2eS/Ii1cVKOXEqv5PK771+Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4295
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> The BlueField GPIO HW only support Edge interrupts.

O.K. So please remove all level support from this driver,
and return -EINVAL if requested to do level.
This also means, you cannot use interrupts with the
Ethernet PHY. The PHY is using level interrupts.

Why not? The HW folks said it is alright because they
Do some internal conversion of PHY signal and we have
tested This extensively.

Oh sorry I misunderstood what you meant.
In software we don't use the GPIO pin value itself to
Register the interrupt. We use a HW interrupt common
To all GPIO pins. So we should be ok. We only set this
EDGE register because it is required from a HW
Perspective to detect the INT_N signal.
