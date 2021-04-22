Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A0AC3685DD
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 19:28:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238434AbhDVR2b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 13:28:31 -0400
Received: from mail-mw2nam10on2097.outbound.protection.outlook.com ([40.107.94.97]:53345
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236058AbhDVR2a (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Apr 2021 13:28:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jdJ5XKU2V7aqdgej4sO7M2mAJYeuVBEE8JDB8mB2adh5G19XPwsUJDjzQrZTu5Uk8XPwpH1tjrvrgplVZhOYFOxBmOKA8nqzy1c86dfjsuolS7o7JgeEyfktuh9eAtTlWpG/wx3+ujDHL26Rfqd3cY966TN3dXqHWTnTkH+hi3gmksY/RVRQz8yB0uKC1/fzZNaGiPIC8zH2SqST9gqr4WXKFLYPtQVcvJ68xf+0TsUpN1vPfmsXiBY/BfWH2BMvBnlAVIJoI2MHrrhsx6qvGff+P1wq0528VGn4i5/z8dMEjWdI3KYQnMCr6AXhPCIJGdGvpVBinXnkNtlkZ8dDng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MGrQTV3gTFgwhHi7CzQiMf0mbbCj9SPgO7EKdErjqac=;
 b=l5napk6doeOKCONYw5f8lwEj0rP4BxVkB9U1USuhAiqDqofSkEH7PEsWEioGiMuCUvyqQjxpeuDSvEW6aCNINbcTNVGrG+ural1/uLPfpnpOJmUbUDLquJ8gpvpquKpUz4ASX8xNLrLwBtlJUSHAnyrLvlFDvIqa60lsy7hQbEGAJQnIamfbqAQ9H0yhNkZeYt79Fmp7eqfN9+EWy2RK464G2g/NOkyZSrAIkhL1s4Vo98hwn6txOVLnnpyMg+QcOMJxNBViHycBLFdEmcUc2dR2VKuhEEtQaBcGIvCnmIiEX/rspMcmwZiq5QsPV3v+6NiXC4ZNsroLsiT8eDy4MQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MGrQTV3gTFgwhHi7CzQiMf0mbbCj9SPgO7EKdErjqac=;
 b=SQEuHLJ8jLzt4XzcZXVKOYBgIvIfaT1eluLhu/3RJF7wBBvon36rpKQH2U5VKrzgKIhYAdnpRspDCacIhTCaY+12cW4avAkNt5yFbDSURPNNpoEdop9huHb9uI9TJtyyP56jaOYj0xjGPQSR56Pa+OY6oSrPSy3MLYRoS9iXd90=
Received: from MW2PR2101MB0892.namprd21.prod.outlook.com
 (2603:10b6:302:10::24) by MWHPR21MB0639.namprd21.prod.outlook.com
 (2603:10b6:300:127::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.5; Thu, 22 Apr
 2021 17:27:54 +0000
Received: from MW2PR2101MB0892.namprd21.prod.outlook.com
 ([fe80::5548:cbd8:43cd:aa3d]) by MW2PR2101MB0892.namprd21.prod.outlook.com
 ([fe80::5548:cbd8:43cd:aa3d%6]) with mapi id 15.20.4065.008; Thu, 22 Apr 2021
 17:27:54 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     Arnd Bergmann <arnd@kernel.org>, KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Arnd Bergmann <arnd@arndb.de>,
        Shachar Raindel <shacharr@microsoft.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] net: mana: fix PCI_HYPERV dependency
Thread-Topic: [PATCH] net: mana: fix PCI_HYPERV dependency
Thread-Index: AQHXN3xJ/rfMR5JpBUSHXQTEKxwOSqrAyd+w
Date:   Thu, 22 Apr 2021 17:27:54 +0000
Message-ID: <MW2PR2101MB0892209BCEEE47259A7AE03BBF469@MW2PR2101MB0892.namprd21.prod.outlook.com>
References: <20210422133444.1793327-1-arnd@kernel.org>
In-Reply-To: <20210422133444.1793327-1-arnd@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=a29a2ba8-a3e5-410d-85c3-cb51b8a26dc0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-04-22T17:24:59Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=microsoft.com;
x-originating-ip: [2601:600:8b00:6b90:753d:cc43:efdd:9f99]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d939df14-4fab-49e1-c87e-08d905b3f67b
x-ms-traffictypediagnostic: MWHPR21MB0639:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR21MB06397040E1BE84626A0519EDBF469@MWHPR21MB0639.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: t7Tk1cwpJBHrFTgHRgd6g/V9yGZvWQhBjVlRQO44Bna0c2xvvP1+CU6Q1kmNK9XWC1yQi5xoASf7lOf2a41y0J2N+61AmLcwwWaHb75iVxQHs7Mu5U9Yk7PxcXIZE1HGoUwZfokUpRvP9SwCjWt7AgTabKEu0ClkOatW+4Z5gFLA1VGq/nTUuKwXrKpifo45pptlmtX6fhrYNg7SWIny+NS5BabBiWB7itYxNpKY7dqdAR6baZi3Vz3x2pgWvZ4SD7mtcdj7pRmmmH/vSo4PrgGIRPezYL6SVWYdE1oENhEn4nI3FJF/4z7Bz0hitvkY09dqyJs0+AGY6vADAL6rGlkZe4gPcGU0MXPZ6j2kF+zFiS4FSRZHZYfdf20dyxxAtMW7fA87IQotQmHZ/Vu845fbfhqGtfH9JTiUH7cYYICnDEX+vxOJYbyt5L+ordfsNHkjalAeQ8+nP/8IOEBMC2SUMDDdxDzTsbgO7ArC33uVmRKrW5/a3m2XdHeZrWC8LWdN6Zxc+Mxk3z8B3ls37j0pM66EiSjEPgGqjtefODCgyceAGir1IyTnA4lHXQCjafLUCsuQhJFqhr6sNwnajP+A1BeImF9wBHpc7OBqFZk=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR2101MB0892.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(10290500003)(8990500004)(55016002)(9686003)(8676002)(33656002)(7696005)(86362001)(8936002)(76116006)(2906002)(66946007)(64756008)(66556008)(4326008)(5660300002)(66476007)(316002)(38100700002)(122000001)(71200400001)(82960400001)(6506007)(52536014)(82950400001)(66446008)(478600001)(186003)(83380400001)(110136005)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?0h5j+oEOoxkqYfDYTYo5CqsBGpGP92wGAauzHEDzT/sQXe361fHxCazaEv5A?=
 =?us-ascii?Q?Fc/Bu0tQNZrOeLSEWAhVXu4vVI/lSAYRsZSArx9sfyqiYe9WXH95XW03eZJt?=
 =?us-ascii?Q?r59nF/CAeEYBQZnD6Tvd5B+1OdpsWa0AGXmHIW3LFvNvHZ62SQj1GLM9vK0d?=
 =?us-ascii?Q?2QNwWkngfS5S7TFZpQoO0yxFupnQ+ns0OuV1ZWqEc1TGB8+1lNSt7i3qJ3km?=
 =?us-ascii?Q?m8ndsJVyM1IZZTc/MJaRNjXylxjtpuJRJ247sGjF9lISyzuHgCIq6qNJp2fg?=
 =?us-ascii?Q?izXfYRt22vJ8izUacyDWXfyyY+M4zNi3zBXJurJ8wW5JvTvSrvVBvLRR7Jho?=
 =?us-ascii?Q?AACqsaNtSb+TLYnRCTqF2lPPDUfSmFI35FCEkLjaEE9UsScBQJkFhCgXn5uo?=
 =?us-ascii?Q?n0NGwEZ6g38F6R8sqlEnskRXSvjBFTsX/ckS5E5K2hHd9ckPeCh/o8LUxAEW?=
 =?us-ascii?Q?jE9qV0zYDqoJJXzKkOjcrjNGC2eWyor+NwPD3yilJ6DI07mfYBPLtLLUMq5/?=
 =?us-ascii?Q?iPYJ3C0fmF0L2OHIQ2+n1L7RHax9ejvnC3Ex3RuQxwc1xTmmXUC9BKGGoPuT?=
 =?us-ascii?Q?A+r8XXqUtnCl0SvcT5fkmcuGghJhreWJj5pgZjccGkZNq5/BR30cDobnbpwO?=
 =?us-ascii?Q?XbL9Bza0PP0VBLeW6cglQ5gNmfQ8Un+S3Lduj4J6VQI5clCliNdYKjmnvZ2K?=
 =?us-ascii?Q?JExngcPYzGX/pKR8+UcYCo8M+lhUx7omK+cryJLIH9rXQCJEYSJF6vvUP5Kc?=
 =?us-ascii?Q?ITn4sCGygJsWJAZTCWcIaIKqbORDW+cuAKIIic1ibvraIWMFLXPnWcS2gzkN?=
 =?us-ascii?Q?PvV1m+SGyM16J1ettahaZLX7G2S86qH8E5fa97kRC0Iv5qjZRMnQm8WHCVk/?=
 =?us-ascii?Q?8qqyEdmkA+S2fuSSr7F8rG8DqvZ4Xu0tELHYEmpPJHXWqnj+i41I9jlXuF/U?=
 =?us-ascii?Q?XBn1A5hjzrMqgXN6kan5Si9dlO6QdKV0gGQ5rzQcXDxIY2gvbh7fcdygeNZN?=
 =?us-ascii?Q?OMkZ0IticeBABGenoNtHORqkkLQtGzuMvR9EYX0LiUTbQikV17PZURCML3rX?=
 =?us-ascii?Q?E8NBvhra5yHJi+CCR7MlonV5jXYGSrRQEItapSZim2Ia4OBxvF3EEL7uMnDh?=
 =?us-ascii?Q?UUzJQb5TqL84mROxbE1izA2OLqGC2/qmqw+WFk0BTR5mZNBQfLJfrloF7UsB?=
 =?us-ascii?Q?IEZ/VglvGGC0s6scdNU9xvL25+K+uZRNxQP6qZWkfvBe2pUMvBS2dKmT+HSx?=
 =?us-ascii?Q?gVK9ey8+X2W/ilmD2FmDvg+SiIWa5hlmH6bND/wxKGiRtF1r4UxgQuFpnkPv?=
 =?us-ascii?Q?tr62ythoWFLHpdEp0dgY7HxwE+Pm2IIeAF8w+ouenWd1BPWpg0Zn3uQe9xdD?=
 =?us-ascii?Q?kn9VOEj9wTgtQTi03EdOHvkTxRhR?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR2101MB0892.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d939df14-4fab-49e1-c87e-08d905b3f67b
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Apr 2021 17:27:54.0928
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +rAZH2JfyjSEjXFFez8hR0GxeNJj2U0DGjdrA15V69Hr69IDMeLjCfq1QtN36u/icQfsEbtWhPUhowVM2Hvr+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR21MB0639
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Arnd Bergmann <arnd@kernel.org>
> Sent: Thursday, April 22, 2021 6:35 AM
>  ...
> From: Arnd Bergmann <arnd@arndb.de>
>=20
> The MANA driver causes a build failure in some configurations when
> it selects an unavailable symbol:
>=20
> WARNING: unmet direct dependencies detected for PCI_HYPERV
>   Depends on [n]: PCI [=3Dy] && X86_64 [=3Dy] && HYPERV [=3Dn] && PCI_MSI=
 [=3Dy]
> && PCI_MSI_IRQ_DOMAIN [=3Dy] && SYSFS [=3Dy]
>   Selected by [y]:
>   - MICROSOFT_MANA [=3Dy] && NETDEVICES [=3Dy] && ETHERNET [=3Dy] &&
> NET_VENDOR_MICROSOFT [=3Dy] && PCI_MSI [=3Dy] && X86_64 [=3Dy]
> drivers/pci/controller/pci-hyperv.c: In function 'hv_irq_unmask':
> drivers/pci/controller/pci-hyperv.c:1217:9: error: implicit declaration o=
f
> function 'hv_set_msi_entry_from_desc'
> [-Werror=3Dimplicit-function-declaration]
>  1217 |
> hv_set_msi_entry_from_desc(&params->int_entry.msi_entry, msi_desc);
>       |         ^~~~~~~~~~~~~~~~~~~~~~~~~~
>=20
> A PCI driver should never depend on a particular host bridge
> implementation in the first place, but if we have this dependency
> it's better to express it as a 'depends on' rather than 'select'.
>=20
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Reviewed-by: Dexuan Cui <decui@microsoft.com>

