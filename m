Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A79A43F05C5
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 16:08:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238896AbhHROJC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 10:09:02 -0400
Received: from mail-am6eur05on2088.outbound.protection.outlook.com ([40.107.22.88]:14305
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235675AbhHROJB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Aug 2021 10:09:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lkA7zaIwvec8YU5mw2vf6zFdJKBKokBBXt0OhoCIsHhnktW9cW0TuDMGyxbvTXoKiapcOMyDFAmUC0L2HCdz2vPCaY4aiE8SehWLNPbXIJXvxVzf7VFW+3ORFdEXMFEzz/FkAy6FdYfuJTHEd9meeZk6Zg1aiiO5R7Lz3SFe6mz8AXqe2x/hEPKKLR/EOARUb3or9OnYWBt4zKvtRrZNblf8K/vpZLoQAKpKedJ2fra8kbO3f+tdMjx54DwPgldfLCWUtv8EL6OigEFf3BN8PEwRf27tVwK2qcPx3v8Iyl1kx0D01o5en0xRMfVqjS/C0Haq7vkflQPN1aWGIFnfQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lMVdcFdrUA5HCWRcTboRjAZPr3Ig9y0YLCZkHUPpUqc=;
 b=Z5/Y0U9V7CDbFviaQOYiDz9pJLwyHmWQC1DtEped6mo1DZTtHdKbS1NslbaVbaxXXHC1vzQWi8svS4KpvKXB6SR4dhvoP2t1hJeSI0uCMQoYhev7tBJJgkGv+yrCWnqPhoTe35LJPhWI1ef/ovl+yJ+gV3eH5O1mPRKc+PMIcKmI7vOiHnlrdL1cTR9zyMzWWuR0ppDuizYVi/gIQg3pd7aqW7yT6v+p/IfeOFFTXGo3pz1xw0njD5aU2nxDWNs69+LdAAbb3bz7DU8/XUkwVqV0uYaBNiTjZaHfmeI3wNXHDf88bDJH1XnPQpG644nZaWna3FlV81XGLqbbkPupAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lMVdcFdrUA5HCWRcTboRjAZPr3Ig9y0YLCZkHUPpUqc=;
 b=TWjQ6CPPUXMDl9K3onWHcgaGxOuEtbMee7V6G8h4TJD6GXz8BDQ98uHvny0U5sMW5Gb+sluz+Db51OomME9rdLPw5HxAwusr3aOzD0skXs5mBdEqzkFwQika13UpH7KbKRoE5fR+WDG2CVlA36PWa29ko/oW+qZstO3epeR1I6c=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB7216.eurprd04.prod.outlook.com (2603:10a6:800:1b0::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.19; Wed, 18 Aug
 2021 14:08:25 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4415.024; Wed, 18 Aug 2021
 14:08:25 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "allan.nielsen@microchip.com" <allan.nielsen@microchip.com>,
        "joergen.andreasen@microchip.com" <joergen.andreasen@microchip.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "vinicius.gomes@intel.com" <vinicius.gomes@intel.com>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>,
        "vishal@chelsio.com" <vishal@chelsio.com>,
        "saeedm@mellanox.com" <saeedm@mellanox.com>,
        "jiri@mellanox.com" <jiri@mellanox.com>,
        "idosch@mellanox.com" <idosch@mellanox.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "kuba@kernel.org" <kuba@kernel.org>, Po Liu <po.liu@nxp.com>,
        Leo Li <leoyang.li@nxp.com>
Subject: Re: [RFC v2 net-next 2/8] net: mscc: ocelot: export MAC table lookup
 and write
Thread-Topic: [RFC v2 net-next 2/8] net: mscc: ocelot: export MAC table lookup
 and write
Thread-Index: AQHXk/d7FW3EK5xtW0agq9/5JXNYNat5TRQA
Date:   Wed, 18 Aug 2021 14:08:24 +0000
Message-ID: <20210818140824.qel3ydeiphkudq5o@skbuf>
References: <20210818061922.12625-1-xiaoliang.yang_1@nxp.com>
 <20210818061922.12625-3-xiaoliang.yang_1@nxp.com>
In-Reply-To: <20210818061922.12625-3-xiaoliang.yang_1@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b6a54b9f-46a1-4312-8aaa-08d96251a511
x-ms-traffictypediagnostic: VE1PR04MB7216:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VE1PR04MB72168DEDFA4380DC6A31443BE0FF9@VE1PR04MB7216.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: aHxBsepA2fqIqPISU0/eMOtRXlkIpVxWU5QF/1AHnTISQqJoc/mm77uWzrre1+zH8xDw4ZClR900PRN+cD11B4nawHS0LKNCfi1utCEFh0XXQn+ikZT8OFZWka4m+BKfJoVeZ3yGtfyyKMjsGu8kzwub3hXAs5Ceh6MkvivYfpo9K6cg4EQ/YC2eJ0syo302Is27BNkdKVhRdJ0lW8MxDX0u1DCTx8DO1h8tUtF/CJC+Fluxlp9J+yhIVvHmwv5H4fMSTiKhzR3GiR4R4U9sJWwu03yTcjq4iRQjMet2M8mUMvEtE2HJXKuWiZ4cGvdcrsmhwgPPUz7PsUejwq1gPNMkj2RVNNjmZCwG5Fyj5EU5h4xYTc0k7t4c8aP2tteBcrYYbUXqHWhLZGFviHIjyiKXrTFQqaOcs/vr7SHKWPOCJlvU8Hdfsd8F4oW9Goli6MXQk494yHWOTgGwCRSrb4unhXMoUlX6UD0UP5EuIr4Qvdt9tX9AzjWfIE017c7sYAdPun6BgpAZt5YzTn4/CMgMXy9QoIgvO+7cgD7pStUiRsMHmqjmD+syb6oaQVCkKBPP0XnGfrUnoalHzqpxJKh4dvQiTNawCKJDqU5M5pOZRXPUbNI3LMFa/ZrTUgnfKaXE8iOg3cu7UyWu/knrawee/WrUI3cesUnu2gUlMDkh17vaME42L7JuWNc4ASvEtWc3WeeMJ7GgYOjQcta5sg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(376002)(346002)(396003)(366004)(39860400002)(136003)(26005)(44832011)(71200400001)(6486002)(478600001)(76116006)(186003)(86362001)(66946007)(122000001)(6636002)(6512007)(9686003)(4744005)(33716001)(1076003)(54906003)(4326008)(8936002)(8676002)(66446008)(316002)(38100700002)(64756008)(66556008)(38070700005)(7416002)(6862004)(6506007)(5660300002)(66476007)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?8H8zlKAeedOeGXg/OKh4mq9ergdIcx+hIuXyoSSwQUHuANM8xomYZZtt54XV?=
 =?us-ascii?Q?S6uO9m41WyLksc/U7o1avuv02Fm3jMtzGVV55/k45L0c75xPsbvGQhkQQNXU?=
 =?us-ascii?Q?mHL2bKddqPZ2j4tDyOr4Q3bgO655aPKpjeQg9LH/FeR95ljExz6Ay2qmfwOQ?=
 =?us-ascii?Q?VLr68v3eUzFdMyablqrKLhGVKLUkH8h1FdJnnru3XEn4Z3QM9Cz6fj2L1K4g?=
 =?us-ascii?Q?EL4GyagXV6Qgb0INw2QMdp7mPBOxf9HoP6ZOycGoivgZ1PsuMwM+wc6XjWc9?=
 =?us-ascii?Q?FdkDar75KuDuAtK8vCovmTsU0D6AAReFG99oHrGDq0gZdkaKqJ82zzAGdLIt?=
 =?us-ascii?Q?XijlKLLMBWwNRN2m2eycLX2a03Evn3u3AKmVWf75bT3wxllxcNGvpxMbIbpE?=
 =?us-ascii?Q?LagkaCot+3BZikzMCk79SScdCMx2bzfhJ1wtm8+nXiVSZhkXtY3JUAGfFl6V?=
 =?us-ascii?Q?sKL76NQbMDOGZhIqngk7h3IDEkcLGqpny3QFt60l7xZhRBbo98rRYQX7g4rT?=
 =?us-ascii?Q?kjSvw5pLubme9oXOQYYqFSwD2luQvZ6bQFcUlC//3FRQc72M8QDK+YB1oQ6H?=
 =?us-ascii?Q?JChNVanrkReyeJBW5M/GH7oo9WMn43Z20IOOqx8qWwrm0SbLGVd5FG9wGV5/?=
 =?us-ascii?Q?z9t2wMeiVZ+CxVCp8n0CKftYO+bsNv3SEDWa/PA3fsfLAPImZ8LXkAgAd7Dl?=
 =?us-ascii?Q?OHxWVIDVZ0aFBos+BNyU0HBaNSxuR1ID7zqFPu2YRKpZKkViw6AXhjLbOGw0?=
 =?us-ascii?Q?HOZtYNAs0ZA0DwlDtiB8X4fyGoYYOz5K+oJ2wchMhIoTFhyDQ27N6G552cSM?=
 =?us-ascii?Q?l3/PlCj7jl1V8FR3JjtL9v5pw8zeZk34TVJWFW3ovQy64Z3plLqKwH45zMtY?=
 =?us-ascii?Q?dx5uPEIOZir5YRxMUKNYzpAZWoBuMI/wArzBLQELgvt3A1P8rVIdheKAn5/1?=
 =?us-ascii?Q?1XiuGU8hyLIqm8lAMFRuwTUsyo5zxh3JGEmbJ2ucxpdBQ5vT8r6Rm7l6nObz?=
 =?us-ascii?Q?9DSs6fi3pYJazh4rXUDVOgnwlXeUgevkDU8r8PUF6vQKesNmFSB5V7ogMBjl?=
 =?us-ascii?Q?xw+AGillV5pdSyKcg/Bp4KsYXjPhEHo1yeUtFrzOOf5M434nqS/eH/baLCJT?=
 =?us-ascii?Q?bmSS6wOCiiDZuOCIUF25Y48TBkKdhdPPS4ZFdbCO8FqTvcp2LptIELxCuiI0?=
 =?us-ascii?Q?ydBh/AHak6OwPrHg/KAmFIWGXhxw3VbcrEmJOlkVQnYhz3Cp8r054dtsZKkE?=
 =?us-ascii?Q?yt/7RK9GcTFmYTwINJlXiGNuUvfnkgj3Hs8xCnHyW1wt9CeuIQEqrGIxgVHA?=
 =?us-ascii?Q?n7h/UGcjJZhIdN8qVXbLoakY?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <16E171F9D19BCE4EA0A613591343D311@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b6a54b9f-46a1-4312-8aaa-08d96251a511
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Aug 2021 14:08:24.9399
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Mtn08WUAqX0sY+17Gun5Uwt1+TIMUgie7Oo/VIPlJX02+O4nYSJbM8nb//CTyzFdSrdje03upoHoJnWcBTrpsQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7216
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 18, 2021 at 02:19:16PM +0800, Xiaoliang Yang wrote:
> Felix DSA needs to use these operations as well, for its stream
> identification functions, so export them in preparation of that.
>=20
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Signed-off-by: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
> ---

Also, this patch misses a tag:

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The first sign-off is also the patch author.=
