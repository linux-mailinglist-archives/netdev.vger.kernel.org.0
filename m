Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6160F415EA4
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 14:43:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241047AbhIWMpO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 08:45:14 -0400
Received: from mail-dm6nam10on2089.outbound.protection.outlook.com ([40.107.93.89]:5344
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240787AbhIWMpN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Sep 2021 08:45:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zy+yFVMy+ia+d2sEg2iTF9FWLHy7vY8S0z/U/LKrPoFt5MNYVirZv3U4MO9Co8kTFd8EAZ9eFf421OvYS+3Zi8+ZaKKUJ4Drcs1lCuBTOGAmUDGQ/euQwQ+QaewSDjIcuvLEIgLAXEJeZVe2veaRGylaYfo6CgwcDAxr6OA8tCn3OSaK3XBmaNyoVKlINMgEFhYUN2/pUMIlEu47DGdfBdAH9NfE9pjgLJvVKuNTx7ZIAkgg7OhZ8nmonvzEOb3ajys9EdTP4sjisK/8E4tDK4DjXfRoEe+AArH11IRV/CcCV1/Kgf8ELS+D14XTPOmM3zVvTBZ3bT1bzWfyo+J6vg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=QFy45rdekizq2LkU37JP/WndpjRfDJif5hqMQMqcchA=;
 b=E4qHf7Zgm0c9sECCj2RLe3ufOUUrjoR5+Bs292tYTtK744EkVPNGgnkNaYtXYK63nl3E8Xk8GkZSBYTEQidacutWtIf+vrfWAOxTDUoh9Vx74JEWiqKllH0aYrpPP93rrElFdWj1z+aBFnmLnGD8hhJ2JtqGmnq0eiyzlJO6J8iD/6sEwudpsGOFUm0BqYnNUgy9Ryhz/6Rkbo/uo3Q3G7lPnnkgyVkihOFGhVaRfRvTZEyxtcZjNNV2BK6RYAbENmWRG+KrE6UiO9RV3vTvMK/aztwxCj9yW1WMmyFPX6oeTHC0C4AsU0N3nO5xyUqPGKS3RVl286ic6LT7kdc65A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QFy45rdekizq2LkU37JP/WndpjRfDJif5hqMQMqcchA=;
 b=ueIEBjVtlP1RahvcbE9UW31S47TQDp78tvl0pKMC90S9CilwGm1GgYxxR+PePv+k/8k+QrTEQ4hNu8LWs0uEfzqe3lnIr1Tqy253AEZg09bvOeoW4iCqsbfMKOC1lqzXth3xLs3ZhovCuv7GVlPoZXhQmAdt1FiZUCwff49gJAFOX+sz8wthMF+5Sh9IvgoYWkppEzGxKqnbEngrh2TbWQzH8Gv3VFQTTMbF708fNa6pldTGQc6eePsmuE8XDYzE4ubX94zv8+JstoNtyWVWwBQVHdvy8v7kp1QXaryewmyAxBaNcN54dz6b0fS6Ce/pQZjYN0hfISgwgM7XDklzpw==
Received: from CH2PR12MB3895.namprd12.prod.outlook.com (2603:10b6:610:2a::13)
 by CH2PR12MB4053.namprd12.prod.outlook.com (2603:10b6:610:7c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.14; Thu, 23 Sep
 2021 12:43:39 +0000
Received: from CH2PR12MB3895.namprd12.prod.outlook.com
 ([fe80::a46b:a8b7:59d:9142]) by CH2PR12MB3895.namprd12.prod.outlook.com
 ([fe80::a46b:a8b7:59d:9142%5]) with mapi id 15.20.4523.018; Thu, 23 Sep 2021
 12:43:39 +0000
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
Subject: RE: [PATCH v2 1/2] gpio: mlxbf2: Introduce IRQ support
Thread-Topic: [PATCH v2 1/2] gpio: mlxbf2: Introduce IRQ support
Thread-Index: AQHXrmWkzr3ID0dlqEu/CHaf9JymsquvFGcAgAAAj5CAARKhAIABbCOQ
Date:   Thu, 23 Sep 2021 12:43:39 +0000
Message-ID: <CH2PR12MB3895D489497D7F45B4A45A34D7A39@CH2PR12MB3895.namprd12.prod.outlook.com>
References: <20210920212227.19358-1-asmaa@nvidia.com>
 <20210920212227.19358-2-asmaa@nvidia.com> <YUpdjh8dtjz29TWU@lunn.ch>
 <CH2PR12MB38951F1A008AE68A6FE7ED96D7A29@CH2PR12MB3895.namprd12.prod.outlook.com>
 <YUtEZvkI7ZPzfffo@lunn.ch>
In-Reply-To: <YUtEZvkI7ZPzfffo@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a81fe7e1-1ace-4d34-b933-08d97e8fc496
x-ms-traffictypediagnostic: CH2PR12MB4053:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CH2PR12MB40533E5BA810E39213A0C46ED7A39@CH2PR12MB4053.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9MZeXyuZbt+GHuLucpdIVWmtbfpOnvIox5N6gk0J2QTw11/ojY6a1T5MrRYBDMUqzrKzK659trmTClMD93BEWheQk198kcdjt7Qf5Cg4poHipRy8xk49+kVkzDheaXynAlfh6iuiHW9XGytz+dtVHefoe2VsLBFeWny/Urz9E5f/3hU9zZkc8ZgRWSTEIv+V4xovOcckk1IY37i7Ug+INl+9bqtJd02l2kmQksEPTJtKkMmZQlfIg6a5F2N60BNqkkDjB8FTMHwjIyfpF0nFZ196Yos59smZrIjuxX2+GwiSXqQ/pQIcxEAbFyD282vRAJf/Y9+zRLiWsbJufXQPSLXzATT64D+h5sqeudQDMSidz7VlBHTfdIkWxDtlkiQMv5GEF/YuGMG+K9ACQRfweJzQvihs3N+t4Io9ra2o43+kUpxdPGH+n72qnrYhIBQ3gSYOj/cbBGla9g5RhQUQdPpPsmwgMVqjOncqx+Y3aJQ57xJjZlDIKiu840mED0jRQm9lNMo004OEusZkYK6aQLcceGdnkOPpMYPtMZzp9m1G7OzMkZnURU6r9hcvZl6yYWlTybANiAK4LEH1fkOX/KUDoCGlxqJGpvgewXG/tL8wO3nXb5lt3N7M85Chc7jLN3YPtBtoPs07/xFhG/Nu0b0M9F/l5CNh417NYz3JYmjNGgI6OyY039XP4vXvRmimuCNHEOUkuQVh1UyIDWDbHg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR12MB3895.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2906002)(316002)(8936002)(83380400001)(86362001)(186003)(52536014)(8676002)(54906003)(6916009)(38070700005)(5660300002)(122000001)(38100700002)(64756008)(66946007)(107886003)(66446008)(33656002)(66476007)(66556008)(9686003)(4326008)(76116006)(7416002)(55016002)(508600001)(71200400001)(6506007)(7696005)(26005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?13ZCIiTnbTKG+HRqoKq+1kdoqK3+bT5IOyWxRH1DjvHtUr0yHOcvwexmQeMb?=
 =?us-ascii?Q?LFN0QD5maT9VZhEmA+V61xJQ4mhofpHpFuFregx3ZYRYHAgBJpcPpHEER9ff?=
 =?us-ascii?Q?9jR+DfEB9uHnj/qT9BqZoWZKGV4wA9wEB7RPVicd4Q3v3ZgrAWKnoww7oZwK?=
 =?us-ascii?Q?CerYTM9s3mnB/5qkFynsHzQHM5FnpuOcdqHZ6xK9aAcNsQeW6kkaFNXx4PhR?=
 =?us-ascii?Q?yEQagute32fRXxM8cZVcIYg5v/vSInk2hNB0tr/CUonVcor1TIFFyip8gQUx?=
 =?us-ascii?Q?g5p6+lei/ee9XsKRA2/7zTkhS5zLDY/fiT2em6DGrIAW5H0AN685lYwrzCY6?=
 =?us-ascii?Q?4pQsFxjlIS6SRByKmTrj1jQdXBo2aPqDqebkLR2yks1oUOhTz4gAOFRapHCM?=
 =?us-ascii?Q?l1vm3RICmfTok4UhIBpBiL1bwUuMXtbtcZkMioOeIK+3smjdPJw77q28ndp7?=
 =?us-ascii?Q?bLFsiu0149bKMmlokNcHF4Wptj3YiSn70vZNl/xSrz8T8m45btiy15aODww+?=
 =?us-ascii?Q?HN024JPbqeOdWir03YNL6lT31+TCbARxD0gsTCshjA/UlprQHNn0YklLjw4N?=
 =?us-ascii?Q?526hahqUBAOOS4MDBngyc4GTPlUPG0J8Lr9feT5uhCRLuqLcJNG3FEv64EH4?=
 =?us-ascii?Q?iAdfVgvV1f/zxgDTOKJQ7CJMV9P6h7Lm4XHBG0GPaE3BHmttxfZlKENG9Itb?=
 =?us-ascii?Q?vUIjL826wyTsEs2Fk79n1ift8u7Gab6Ys9BfYfIbFgTjLWge11DWkkONpC3C?=
 =?us-ascii?Q?RgCPeQfuZZD//RIo/6/NeJz2kVrFFXSulbawfEMg3ti3O0tCfRbdqtvwtoFP?=
 =?us-ascii?Q?nFJbMXpFmH0l7WUypRTzW8g+29yqY2qcsp+ZVtF6Ld29OJStxC0/VyzxoriO?=
 =?us-ascii?Q?cum0qrQ5NtPB/7mwEblczdBrfyDtrukZJJLfH+96wk/S5CZiyqkME9DX843H?=
 =?us-ascii?Q?g5mi1c1loLoDHeA2pRFKvM79+0l2ZwSTlYhQjTwtMQuAmlIpz4ey3n3qnt7M?=
 =?us-ascii?Q?PTQCYzLc9sSmuusDLYtwCtK8YEwui/OYGK/anUpQpap4l17FdNDdnSI147qg?=
 =?us-ascii?Q?sBNGLmheK+ne8xCKgLXOPEjXtFeqduk9xua9CW2WqzD4F470vYiSPy2MWuEm?=
 =?us-ascii?Q?TXDeoLPGuhtlGGqs+Zz9VRJW8EEEkrfZm4Pu9EHHi8JQFSIIUCeidALXKDnF?=
 =?us-ascii?Q?OgLyaXudvnCCy1vvfOMkV3dfRlMxmR2PtxDkpSmsyeiAU+7D0/SgrjvpfXjj?=
 =?us-ascii?Q?++i6tnpDXuR9VYAvIQ0xWXMK6mgbtFgBwcgJI9A5ARbgb/mIH/3pAg+fnsjJ?=
 =?us-ascii?Q?fbc/ot5D5uV4Al+Iyuf5dLjn?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB3895.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a81fe7e1-1ace-4d34-b933-08d97e8fc496
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Sep 2021 12:43:39.1282
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fzlYqvulIGKmXdgMhJ3DuEdehJDPvNZxBXfGXqWJTYYd+rHH3AYuXOrzNVBPs0lc3rXnkpy1mUvoSH2Az8XwTg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4053
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > +static int
> > +mlxbf2_gpio_irq_set_type(struct irq_data *irqd, unsigned int type)=20
> > +{
> > +
> > +	switch (type & IRQ_TYPE_SENSE_MASK) {
> > +	case IRQ_TYPE_EDGE_BOTH:
> > +		fall =3D true;
> > +		rise =3D true;
> > +		break;
> > +	case IRQ_TYPE_EDGE_RISING:
> > +		rise =3D true;
> > +		break;
> > +	case IRQ_TYPE_EDGE_FALLING:
> > +		fall =3D true;
> > +		break;
> > +	default:
> > +		return -EINVAL;
> > +	}
>=20
> > What PHY are you using? I think every one i've looked at are level=20
> > triggered, not edge. Using an edge interrupt might work 99% of the=20
> > time, but when the timing is just wrong, you can loose an interrupt.
> > Which might mean phylib thinks the link is down, when it fact it is up.=
=20
> > You will need to unplug and replug to recover from that.
>=20
> It is the micrel PHY KSZ9031 so it is an active low level interrupt.
> Here, IRQ_TYPE_EDGE* macros are mainly used to decide whether to write=20
> the YU_GPIO_CAUSE_FALL_EN register vs the YU_GPIO_CAUSE_RISE_EN register.
> These 2 registers are used in both LEVEL/EDGE interrupts.

> I assume you also have an YU_GPIO_CAUSE_LOW_EN and

> YU_GPIO_CAUSE_HIGH_EN registers? These registers need to

> be set for IRQ_TYPE_LEVEL_LOW and IRQ_TYPE_LEVEL_HIGH.

No we don't. I double checked with the HW team and they confirmed that
YU_GPIO_CAUSE_FALL_EN and YU_GPIO_CAUSE_RISE_EN are used in
Both level and edge interrupts cases.

Thanks.
Asnaa
