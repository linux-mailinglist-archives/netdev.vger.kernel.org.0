Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7624B173471
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 10:45:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726661AbgB1Jo7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 04:44:59 -0500
Received: from mail-eopbgr80131.outbound.protection.outlook.com ([40.107.8.131]:34216
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726400AbgB1Jo7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Feb 2020 04:44:59 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kgD1R+9z7Wgj84I7c5j4yuna9lEJvlX1HDvT5uGveadEZvjRdyEwcVxcaUlfEwh1gi9rfEHavYLp0GdFIYcJDvmZcZneeEwiuvfm8BqfYkotBvTjTeqfW8+QmCK3f9m61wXd2t48rG99+5ZP82srPOKOurumzgPRFSRigwH1Jvk2+ccuEy/uQtwEvzJk9qYK08p7rm8q/l2XF+KS50xlPS65akU0CE7dn/Ug2UiFVZxB2VHO9G+vTPf6sqiqr5foBLeJEbIkffHPw2X6Y7qm8Nh2E9QZyfZtifg00oEqklUTDWjI3Bqr0MPUye8HUAD6if2PcLCgqTx0F7KbJiM8Sw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yd28kipyr9zkr26PW5bXAAluK4+BionNN2m6Akvd8IQ=;
 b=WvRVKv9Ha1ABl/II6skf9FRuLQfWYtzXWpXmFEzHxFJCjkZ36zdfKx2a9n10ZkaRvcwWQru5RtUNuyaMGk0ATFUiJKbZZ4gvGaQHbM2ocGYI5mlQmhAz8uSVZvC8A3UZgcBlOvWI2hUGjunt7x1EN7EbTsUTklerm+85fXHaRp8UMM3XOfnXx467XiSXPtmhg3f1fBvMZh+1r0Gqb5bX9PFqIN2VQyWBruJn+WUXzfWN1CHXY6hr8U01AqnzxFwADsADHl6zZ5sH0w6Q7eJ7lJ8Olx379OxLVFvCHqPzlz9itBskC4H76+7RcefSZkEgDWC4FMTfKVlKy6oBtAecgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yd28kipyr9zkr26PW5bXAAluK4+BionNN2m6Akvd8IQ=;
 b=WIcI4Rxh3hdEla6z9/PgE2nKIHiwJH1flCA1Oe8WQTOWBBJLXrDcJ1RSTn2mpDMPpaQ2sOUnjDfKldBENTicI7ri1whNVM9/mJ7n0YSa9bz1uANmXTE3kKt0SwARBdMzqgiGw43dNPbin8mnnMWa5Gmpzbw/28Cy53OlQTOTNG8=
Received: from VI1P190MB0399.EURP190.PROD.OUTLOOK.COM (10.165.195.138) by
 VI1P190MB0111.EURP190.PROD.OUTLOOK.COM (10.172.82.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2750.21; Fri, 28 Feb 2020 09:44:54 +0000
Received: from VI1P190MB0399.EURP190.PROD.OUTLOOK.COM
 ([fe80::a587:f64e:cbb8:af96]) by VI1P190MB0399.EURP190.PROD.OUTLOOK.COM
 ([fe80::a587:f64e:cbb8:af96%4]) with mapi id 15.20.2772.012; Fri, 28 Feb 2020
 09:44:53 +0000
Received: from plvision.eu (217.20.186.93) by AM6P195CA0015.EURP195.PROD.OUTLOOK.COM (2603:10a6:209:81::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.15 via Frontend Transport; Fri, 28 Feb 2020 09:44:52 +0000
From:   Vadym Kochan <vadym.kochan@plvision.eu>
To:     Jiri Pirko <jiri@resnulli.us>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Andrii Savka <andrii.savka@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>
Subject: Re: [RFC net-next 1/3] net: marvell: prestera: Add Switchdev driver
 for Prestera family ASIC device 98DX325x (AC3x)
Thread-Topic: [RFC net-next 1/3] net: marvell: prestera: Add Switchdev driver
 for Prestera family ASIC device 98DX325x (AC3x)
Thread-Index: AQHV6/jzY7yqWky1LUqTk1e6REHYB6gtohWAgAHwnQCAAJe3gIAANRAA
Date:   Fri, 28 Feb 2020 09:44:53 +0000
Message-ID: <20200228094446.GA2663@plvision.eu>
References: <20200225163025.9430-1-vadym.kochan@plvision.eu>
 <20200225163025.9430-2-vadym.kochan@plvision.eu>
 <20200226155423.GC26061@nanopsycho> <20200227213150.GA9372@plvision.eu>
 <20200228063451.GH26061@nanopsycho>
In-Reply-To: <20200228063451.GH26061@nanopsycho>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM6P195CA0015.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:209:81::28) To VI1P190MB0399.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:802:35::10)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=vadym.kochan@plvision.eu; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [217.20.186.93]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3266884d-6963-4fbd-501c-08d7bc32dccb
x-ms-traffictypediagnostic: VI1P190MB0111:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1P190MB0111E90653061BB50CD9104695E80@VI1P190MB0111.EURP190.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 0327618309
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(396003)(366004)(346002)(39830400003)(376002)(189003)(199004)(8676002)(33656002)(36756003)(26005)(66946007)(86362001)(186003)(66476007)(1076003)(64756008)(6916009)(16526019)(66446008)(2906002)(66556008)(81156014)(956004)(4326008)(54906003)(508600001)(8936002)(55016002)(8886007)(2616005)(7696005)(71200400001)(44832011)(81166006)(107886003)(52116002)(316002)(5660300002)(21314003);DIR:OUT;SFP:1102;SCL:1;SRVR:VI1P190MB0111;H:VI1P190MB0399.EURP190.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: plvision.eu does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vt0CE8RGn5biDilvM2dkyyX72B5+S/T4o9FOt99QxysXHkglqfl5tj+LtC4Ud8STbQhtRkLB2gEKUyh4z8Z11h71fTlVRE1VnDD0sgEcm8KluOCtnRlFJri6cNuyYGUD1EazuOciavFjyA5YC6WV1f4G6Obf0J3FDapI/m3DwJ6optrZL7Kp6FgLluaJtpqOEfg/SfaAg9UJEbMrkTILX4KRf3959SwTRVOQjhB3dkVmSh+th0kx85BNmfvEXdjTSrEQfb7kr8j7hgtmRSch5MbJlMQBJPRMsKyJc0mE3w+W5HPliLmJ9PL8K5keOzg59CgV95R4EM2K/FKlmARB1qC+K8co16ynhldNbxzd2Z/jeOEErNx6I8TUM8Mz4yWGyp5NMBM2Ae/70PqCruBqvIpZQw66rNklWiO6IG99IzRCyrDXTc7fg3Nn7fbEW4CTnzNhIsnBu/8xZr3SQGcQOVeAEA2pJkbpwJag8Pze57YzG+QZXO8/qMdrmU0uvvQV
x-ms-exchange-antispam-messagedata: 53+VHv66rHIyR6JLiwKRr95sEXMEYwd71eeNch58O0wt+YB3nd3+pm/C3XKx5sC7+eVSM3s9ih20GOL4Q2Qk9VEfIdfpOnKNLeZBUnQddodWVpQWjj6iyjFQUGMMWyh6DOAy9jaZF6JARItjrtJU/g==
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2C1627D7860D254DB5F53F06C3BF3A89@EURP190.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 3266884d-6963-4fbd-501c-08d7bc32dccb
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Feb 2020 09:44:53.8410
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: shLTZYXy2VyWxuKD+Fe0THnSzXE4ErdLYmGRGjP9/NPYw+CFdh0XOrYWuwia0S0yM64PgvzDb9KYsihdJwZ8FqUYaQ6NKlhtzFPCO7NGWZA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1P190MB0111
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jiri,

On Fri, Feb 28, 2020 at 07:34:51AM +0100, Jiri Pirko wrote:
> Thu, Feb 27, 2020 at 10:32:00PM CET, vadym.kochan@plvision.eu wrote:
> >Hi Jiri,
> >
> >On Wed, Feb 26, 2020 at 04:54:23PM +0100, Jiri Pirko wrote:
> >> Tue, Feb 25, 2020 at 05:30:54PM CET, vadym.kochan@plvision.eu wrote:
> >> >Marvell Prestera 98DX326x integrates up to 24 ports of 1GbE with 8
> >> >ports of 10GbE uplinks or 2 ports of 40Gbps stacking for a largely
> >> >wireless SMB deployment.
> >> >
> >> >This driver implementation includes only L1 & basic L2 support.
> >> >
> >> >The core Prestera switching logic is implemented in prestera.c, there=
 is
> >> >an intermediate hw layer between core logic and firmware. It is
> >> >implemented in prestera_hw.c, the purpose of it is to encapsulate hw
> >> >related logic, in future there is a plan to support more devices with
> >> >different HW related configurations.
> >> >
> >> >The following Switchdev features are supported:
> >> >
> >> >    - VLAN-aware bridge offloading
> >> >    - VLAN-unaware bridge offloading
> >> >    - FDB offloading (learning, ageing)
> >> >    - Switchport configuration
> >> >
> >> >Signed-off-by: Vadym Kochan <vadym.kochan@plvision.eu>
> >> >Signed-off-by: Andrii Savka <andrii.savka@plvision.eu>
> >> >Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
> >> >Signed-off-by: Serhiy Boiko <serhiy.boiko@plvision.eu>
> >> >Signed-off-by: Serhiy Pshyk <serhiy.pshyk@plvision.eu>
> >> >Signed-off-by: Taras Chornyi <taras.chornyi@plvision.eu>
> >> >Signed-off-by: Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>
> >> >---

[SNIP]

> >> >+#include <linux/kernel.h>
> >> >+#include <linux/module.h>
> >> >+#include <linux/list.h>
> >> >+#include <linux/netdevice.h>
> >> >+#include <linux/netdev_features.h>
> >> >+#include <linux/etherdevice.h>
> >> >+#include <linux/ethtool.h>
> >> >+#include <linux/jiffies.h>
> >> >+#include <net/switchdev.h>
> >> >+
> >> >+#include "prestera.h"
> >> >+#include "prestera_hw.h"
> >> >+#include "prestera_drv_ver.h"
> >> >+
> >> >+#define MVSW_PR_MTU_DEFAULT 1536
> >> >+
> >> >+#define PORT_STATS_CACHE_TIMEOUT_MS	(msecs_to_jiffies(1000))
> >> >+#define PORT_STATS_CNT	(sizeof(struct mvsw_pr_port_stats) / sizeof(u=
64))
> >>=20
> >> Keep the prefix for all defines withing the file. "PORT_STATS_CNT"
> >> looks way to generic on the first look.
> >>=20
> >>=20
> >> >+#define PORT_STATS_IDX(name) \
> >> >+	(offsetof(struct mvsw_pr_port_stats, name) / sizeof(u64))
> >> >+#define PORT_STATS_FIELD(name)	\
> >> >+	[PORT_STATS_IDX(name)] =3D __stringify(name)
> >> >+
> >> >+static struct list_head switches_registered;
> >> >+
> >> >+static const char mvsw_driver_kind[] =3D "prestera_sw";
> >>=20
> >> Please be consistent. Make your prefixes, name, filenames the same.
> >> For example:
> >> prestera_driver_kind[] =3D "prestera";
> >>=20
> >> Applied to the whole code.
> >>=20
> >So you suggested to use prestera_ as a prefix, I dont see a problem
> >with that, but why not mvsw_pr_ ? So it has the vendor, device name part=
s
>=20
> Because of "sw" in the name. You have the directory named "prestera",
> the modules are named "prestera_*", for the consistency sake the
> prefixes should be "prestera_". "mvsw_" looks totally unrelated.
>=20
>=20

I understand. If possible I'd like to get rid of long prefix which is if
to use prestera_xxx. I looked at mlxsw prefix format, and it looks for
me that mvpr_ may be OK in this case ? Also it will make funcs/types
name shorter which makes code read easier.

[SNIP]

> >
> >Regards,
> >Vadym Kochan

I am sorry that this naming issue took more discussion than should, I
just want to define it once an never change it, (it is a bit pain to
rename the whole code with new naming convention :) ).

Regards,
Vadym Kochan
