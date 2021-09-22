Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FAAA414B9A
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 16:16:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236227AbhIVOSO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 10:18:14 -0400
Received: from mail-dm3nam07on2076.outbound.protection.outlook.com ([40.107.95.76]:53057
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236209AbhIVOSM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Sep 2021 10:18:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QzJyqNw6QAYX4wKiImyGZNRvTiK4ui2pKHCihfl7IiEPV4P3ZHgM89YHmRjvnEiuBRIeESIQ+3L8oMpW4iaU8P3MudErqAgkCaU4cHz8Vbk0Y6CbW9bRpYtfLAIQ73d8bGtXXBoZBy0dzfz+Due4WAH8zNB3S7BAgIR4z88qIbpLEBDyT2GvRhJqRKWhr+A8Ho2UdBwTmH7Gpt4Jm3wizYIbxZo1rvVHY/zKmDQXXLaelK1eCM9TMKjLA05pvo474rReNsyPDGccIGOCdpy611bArDh9xv5+LB0hewa7EX52VUtGiv5R9O8swP6qXAXwEMfEF+oapyQnrPommz+zmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=L/8lqdfay3+BRI8NYoHU9LLvcHVURqOZMoeW03IHg0g=;
 b=CKesvpABtYlhIfAZQbe9bfr/CRs3LEFDHBe4M4cjU2A7UkHblKpPQXJptiEWusbyR8CZs6KyxnxYakfp5fYXtV9LvFV25hMk+4rP5VeH03CphuVXDNcUyF1odzSSjr1ednHrcL1STvxRIjTbZImeiv/LqsvHO0utJ39OEM19wESSDxN7PJiHgQ7t39qgTpUFtJgaKb21oYEFSrlmwjZ3PHjuXBDbykUmw5BXDSMbQn9uajPUK9NZWLTmAi1hSjfnKvV7lrldgZ0MP2LpJNgL4XtxK/uifcYtkRE73eaq4Zh813Azl1vxx5E5SIengFggpsSHpq0fovJjrikbamadVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L/8lqdfay3+BRI8NYoHU9LLvcHVURqOZMoeW03IHg0g=;
 b=hH85b8xNMqb4c+Klomto1Fo4tbq471sezX/GtrHCf9Wvi1q+/99psRy1WJjO/Ck4vEq0Etl0keRAe6F3SRMbA/i5sUEu9HqgA6rvW6wnijzGirlcm8p4AV+3hTu8By79azDBF+/nDWPdzqkAAbQIqeLb1nCrMONpNVPZzWUrMSLADUFM76hdyJ46xKx1l0EPwqtMO6t3vQZbo3OoHoaGZq6/8Djh0UDVLZGU3nYWSdqOl0FRx2IrEszlZRWopiARqAl97LO/kWZ4MUJ1FWvzVG0E+e2sDOOT6XoKo/8JdKLXIJVzEsbKV+ZSZOkRqXf83RSG63tixrZm2S81wkKqtw==
Received: from CH2PR12MB3895.namprd12.prod.outlook.com (2603:10b6:610:2a::13)
 by CH2PR12MB4876.namprd12.prod.outlook.com (2603:10b6:610:67::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.24; Wed, 22 Sep
 2021 14:16:40 +0000
Received: from CH2PR12MB3895.namprd12.prod.outlook.com
 ([fe80::a46b:a8b7:59d:9142]) by CH2PR12MB3895.namprd12.prod.outlook.com
 ([fe80::a46b:a8b7:59d:9142%5]) with mapi id 15.20.4523.018; Wed, 22 Sep 2021
 14:16:40 +0000
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
Thread-Index: AQHXrmWkzr3ID0dlqEu/CHaf9JymsquvFGcAgAAAj5A=
Date:   Wed, 22 Sep 2021 14:16:40 +0000
Message-ID: <CH2PR12MB38951F1A008AE68A6FE7ED96D7A29@CH2PR12MB3895.namprd12.prod.outlook.com>
References: <20210920212227.19358-1-asmaa@nvidia.com>
 <20210920212227.19358-2-asmaa@nvidia.com> <YUpdjh8dtjz29TWU@lunn.ch>
In-Reply-To: <YUpdjh8dtjz29TWU@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 86543640-3249-4325-732b-08d97dd39905
x-ms-traffictypediagnostic: CH2PR12MB4876:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CH2PR12MB4876242DBC3955CF89ECC453D7A29@CH2PR12MB4876.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XJ+mGcYZ19HOk8cPUKAw3aBB6+NKuIJgSlBRImoGqRcj47W0S+NBhixU/flUv7A9TaNoSCXDSS54x/W3lYooJaCg5jpgHpQMS29veA14j6DWphGNdxfnZVAGu3RolSgOdVJfRDpr0Lp0bwpD39km4eotBOZcKHjgeIRqg0hmT3RfVLiqFWttXNgSqMTXGJZ2uRNG4Az9J8JVNp0cRw99+D2Dn7VN9d7RnEJWZZTmO6EA8xdvpOL04kobqdb4ZMlQRblZ8hz4/kLL4IkPUGbjOhalfzOY+5WyfXfrTDHi8/Rz7An0aGwwxDsfwtV41DxuITYpctljqmJBW/JnLhEtdGZxjzfHMydZPgWKc9LaheBOrrAUfC2nSjjb+YwYIFr59OgRUcf/qcDADYXtnMNsZvZDx0Q7bzE6ylAmCvdXC4idtCrnSiCWFxVs7UNiJtL8P+PXEgk4hYaq6muoRt+9HGBhR9I2qnBZLPGTKV1Ua6CFFQKE3YF0K9dWqAr4CRp6w83IImGAXJvbOTaQk0bpjMDDwCL8Q2VPL3XumReO0oZ1MRdHO53eWiapvngQ9tThB7PEt+4I29fnPdMhWbGP3gaGRkv9SMQ4e7nUft509w0kVH7/FKDzhEm3Klb4Us2vrE9DgbVN2bV3VnTuKweHS8ClaTIt6UBzxwf7wjXwXW8NA5e18/hbH29mD+vKAdyaAEvu5wlL7qGBrLqPcPbG6w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR12MB3895.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(86362001)(4326008)(9686003)(38100700002)(71200400001)(54906003)(66476007)(122000001)(7696005)(107886003)(316002)(8676002)(55016002)(2906002)(38070700005)(5660300002)(8936002)(6506007)(33656002)(64756008)(76116006)(186003)(7416002)(26005)(66446008)(66556008)(508600001)(6916009)(66946007)(52536014);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?pNXmTLIUtYqcp7t9VJYBPWroAV0JPKpBJR/k+XS1HV7BqKK79LOWZgSdS7ue?=
 =?us-ascii?Q?P57W5Q4RNNL4CbW5ZmHItYhTWrRoTQYY+XQCXM7WrO34vTjBCfCURYTVYGdc?=
 =?us-ascii?Q?fFkn3rUYsnpKcmn/xEKQ/+YOt7G0RPGWTpKlxL9CxwrGaiEHrPozdmvCYx/E?=
 =?us-ascii?Q?8Of7oSZGNs/6qeseYor6A2dXdz2/bjpKijMINepK1XWJq+MxZ6Qxv6UKdQ2O?=
 =?us-ascii?Q?USqdvoQoWhBPGeZrFn+5Pgob9kUQCpo2pNeD0SD5P8lgo5XzwNQzFLwd7wzg?=
 =?us-ascii?Q?N1731Yb2Ub/fiwbNcJC0LR2EqD8ikR9wp+OwzQdo/vFhbodO7I81GEBz35YC?=
 =?us-ascii?Q?LrMGJ/zizMlqiHhgWF0G8KOXdtuJ2GfRJiItZF0rdbBMkDUQdMBVxOfXI8c3?=
 =?us-ascii?Q?8Dr/+ZANsSxgFQuvZaZO0qV2eE/9rT2kZMmscAm35590rhawPBHnMDbgKqTN?=
 =?us-ascii?Q?3crGnmpR8d6hCtImfaxWkP1t7Qk/VukTK9jctQ8zw8zHxWspHGdnUhMAQpOw?=
 =?us-ascii?Q?ZZM3GSx/cdK7j62IDPx74Pc8bOj48flmMq/5exRYlPkDMoOOO21cqLKu8xlu?=
 =?us-ascii?Q?6l3GFwwwmd9O4c2Nf21XVPtYzY0ZyDGZiZPD8GN/yDO1oQdEC/vyWEuCed99?=
 =?us-ascii?Q?KG7ImglYluhSbhpGALY3l+4qAK7gh2yaVFO2sgWeyyZl3axORR07uTYkQ05n?=
 =?us-ascii?Q?9uZG4q1+uIT0U2X0GR8A0R1Rqt6nMUNNc3AyK4KM0LPH16UfB1tsV1cnKbx4?=
 =?us-ascii?Q?kuazsKsuR537KLkxAYl7C9Oua53LCsRL4u1Ph6azIw27tpLyLDlyEoiccgaq?=
 =?us-ascii?Q?Xnyg7DHNKTEQQG6AJANZJPaeYeracGEZSHQ/PFDLjXfgUdJXTbOJH5gQtnFA?=
 =?us-ascii?Q?EX4z/JzooH0mssxxjAjR5y4Tf/4HaN3EL/BjgHLrgKLPq5or5LAqJSkdOS3x?=
 =?us-ascii?Q?MPbnYKzXCSzGpf1wNYpX3ykbpK3xqaEpXgXtmCTLT0rvepIJ63PcH36i1Z7/?=
 =?us-ascii?Q?LUgfU6YAiQZc6KlgOQWzy/g2OUZKFo1LW6YJMQ6mARhh44uKd/XPidosA4dK?=
 =?us-ascii?Q?XOibMSHrgXPQfz/ZI5LM3LZ1AmRqcmbUsA730sjHH6MrhmCs05+o9iIv58Hi?=
 =?us-ascii?Q?PguhxJFkxaV4hr+1aOGxWwzmaV+8gteasUa4aqJ9Np2U1xZXe/4tAy3p5Y67?=
 =?us-ascii?Q?Tlg4b2xcJjmDdRa9mev8EAqSSyji6zYtKZOsuNtlJxR/x806HsVnXzpO7+w7?=
 =?us-ascii?Q?Ex3tvSAJ/uu2HjS03OpK7Bs1A7FI4DroSQSrb7opgr/0Hzj5Ip5LRYZ6koLP?=
 =?us-ascii?Q?YSE=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB3895.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 86543640-3249-4325-732b-08d97dd39905
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Sep 2021 14:16:40.7289
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vrD+L9/miJplHl6L8buuBT387ON9HTgG/8l5VmmkBCY967ZSd4HJuslLNADNZOMf5jcVUfRMM1GRv26ElA6ZYA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4876
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> +static int
> +mlxbf2_gpio_irq_set_type(struct irq_data *irqd, unsigned int type) {
> +
> +	switch (type & IRQ_TYPE_SENSE_MASK) {
> +	case IRQ_TYPE_EDGE_BOTH:
> +		fall =3D true;
> +		rise =3D true;
> +		break;
> +	case IRQ_TYPE_EDGE_RISING:
> +		rise =3D true;
> +		break;
> +	case IRQ_TYPE_EDGE_FALLING:
> +		fall =3D true;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}

> What PHY are you using? I think every one i've looked at are=20
> level triggered, not edge. Using an edge interrupt might work 99%=20
> of the time, but when the timing is just wrong, you can loose an interrup=
t.
> Which might mean phylib thinks the link is down, when it fact it is up.=20
> You will need to unplug and replug to recover from that.

It is the micrel PHY KSZ9031 so it is an active low level interrupt.
Here, IRQ_TYPE_EDGE* macros are mainly used to decide whether to write the
YU_GPIO_CAUSE_FALL_EN register vs the YU_GPIO_CAUSE_RISE_EN register.
These 2 registers are used in both LEVEL/EDGE interrupts.
So I will add back the IRQ_TYPE_LEVEL_LOW and IRQ_TYPE_LEVEL_HIGH as I
did before to configure YU_GPIO_CAUSE_FALL_EN and
YU_GPIO_CAUSE_HIGH_EN respectively. The PHY interrupt signal is physically
Connected to an open drain GPIO pin so software only needs to set
YU_GPIO_CAUSE_FALL_EN register in this case.

Thanks.
Asmaa
