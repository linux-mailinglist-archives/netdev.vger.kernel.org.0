Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFD97482ABA
	for <lists+netdev@lfdr.de>; Sun,  2 Jan 2022 11:18:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232237AbiABKSQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jan 2022 05:18:16 -0500
Received: from mail-dm6nam10on2082.outbound.protection.outlook.com ([40.107.93.82]:5229
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229899AbiABKSQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 2 Jan 2022 05:18:16 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H13Mz3DyJNwdomidd6/yRXxsPYQ8unD5a2VlcBT71D6JhDVq4eurlJ4i2l7slb7elZCSkbeUzzpltg+lphOxo3NkeLfwbAxb/OgS8HnCYYmhrPOKIkvqScqrX7fc/qXOPmWLxJwiriTpuwRG6RUNmRGRiSG5lE94BiXYMOThLyIWtP4STBfzliDLxejsiBRhHEG0xzzqZBxiBGEV0ryskTpq33CppqqgHTUmzqzHjug+iqqRxNUxprv80CkWhorFrqiLqGUWIYCvNWICNtHgSB4F7X6ePwgHn3NTGMeYT5jQPTuCfLGiS+xuS5VkTduQ38LSQHXnluw4d/wnJWuNCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SPeUzGfcXWINVqzScIaHY8YBLQhn0t7MYnvszeD+Bi4=;
 b=JDPNvvJBO3YzmG3q2oTX3MfSoqKh+4XHHmdpizYUX+bIBUnFVIXmTgAyUrgYFfZT3tp+3qGUg9wACfV4I87w91+hdRb9HXihiKYIMCo0eHlu4qm/wg6/5+TrrUvgS20tuo3zJxaUIZnjB74ZMu5/4C7foTYCw1hMTijFSpsqVFnE3zFT5H3LFUYBXs8PhLGMBB41xgK+4DIjwtUTmkL/WEb2zPJ5+v7kTtfruOD1CGOc0MEPt+yBXo+Nv6/vy1pK2PAY7wtio0qeE+m1zbCdN9D9J7EU6yv+eRkXpdbb1lcwlywprmIDIETzzZT9goSNzVVdQp6zLDebNfU51Bvllw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SPeUzGfcXWINVqzScIaHY8YBLQhn0t7MYnvszeD+Bi4=;
 b=rgwLzZ+rcxEtppUueoC87lQfYGBnLI2vi4x0yXU7afjZLAspxhTSgrO7Y//KGfJVz5hsh+0i3npHMV24fHATW0rMXOw8LodS6H1A0/0vPQTo7cc7DP2myaAwnXp7xK3dgD5q1qjnVvwUHBDofqYXjoR6YqRIIeWJS5H+YjJ4YrlJElDFSe1BPpWXQyPBD1VQ42SFhuH6eR4d+4Mw+vGehz5Bj4hs5XjrS3w/h5kSTr9feuZ0L6gd+KNv4MrKyNX2eIId7I7qbdC1JVhc0i0kkmC/f3PNWuwqcL5e0m/2ovtlSo0MBiSEkMs52P8kWMpFsz+5prz7vziSnUoKZn/BXg==
Received: from MW2PR12MB2489.namprd12.prod.outlook.com (2603:10b6:907:d::25)
 by MWHPR12MB1533.namprd12.prod.outlook.com (2603:10b6:301:f::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.14; Sun, 2 Jan
 2022 10:18:10 +0000
Received: from MW2PR12MB2489.namprd12.prod.outlook.com
 ([fe80::9c0d:5311:e246:2be6]) by MW2PR12MB2489.namprd12.prod.outlook.com
 ([fe80::9c0d:5311:e246:2be6%7]) with mapi id 15.20.4844.015; Sun, 2 Jan 2022
 10:18:10 +0000
From:   Yevgeny Kliteynik <kliteyn@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>, Jonathan Corbet <corbet@lwn.net>
CC:     Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Muhammad Sammar <muhammads@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: RE: [net-next  07/16] net/mlx5: DR, Add support for dumping steering
 info
Thread-Topic: [net-next  07/16] net/mlx5: DR, Add support for dumping steering
 info
Thread-Index: AQHX/HzVEbuXNicCrEuBCpMFakiqA6xKTaEAgAGKGTCAAAZFAIADrN3Q
Date:   Sun, 2 Jan 2022 10:18:10 +0000
Message-ID: <MW2PR12MB248939D125D0BF0151BC5949C0489@MW2PR12MB2489.namprd12.prod.outlook.com>
References: <20211229062502.24111-1-saeed@kernel.org>
        <20211229062502.24111-8-saeed@kernel.org>
        <20211229181650.33978893@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <MW2PR12MB2489C8551828CFE500F4492EC0469@MW2PR12MB2489.namprd12.prod.outlook.com>
 <20211230180948.7be1ddb5@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20211230180948.7be1ddb5@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9c9497ed-f829-4a69-5387-08d9cdd92db3
x-ms-traffictypediagnostic: MWHPR12MB1533:EE_
x-microsoft-antispam-prvs: <MWHPR12MB1533AA8190B041F6B017C562C0489@MWHPR12MB1533.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ockjNcUJfrDtkKc7i/af59639mzGrDuObnCYpDtMLSx6aEcqOy4AnBMq5lDksPzAQmMqgCGAqWVaPyzAlCTR1LNN8J+6RJEtBQrDaYy9Ho5vHXgkJPLTLEkoMSGAPJTnQl6/3MrXJkq7a9XiYdLbjbDL3kzzw9AKiYSJGN1wF4+NyNgt9pRevZu+hfcCBeLej6d7ZeGDebMOelDF5b5hXFxjhUT6w1E61dsrUC4ih0ziS7UUt0LphdTPOyRhw+Cfw7yU3r/uSU9F2TG9yVyHZB4RL9zJcBU6yqTTxVeMFNh9Au1ZCVbpr9+k6sq57mcnjFO03ostKe8Aghh9cA0bfRqUzSp/vFfkp2ZBNpZCsqeZGz8P4YV6GIUGlapGb4UrI9VufqsNd2HK0yMQcmk2wl/1mDeKylcze8KSCH1s0jMBXoGJMonriAMcJ++6c13wDBI24jeISgMlMjtsKYopgXjVaDRPP+E9dUPfm6PQOWCkJnvfnprDp4E0Gm0aWNifdr/oQv8vC6vEg0OrGje/jZEj8x6ffd5ylIlJdVE1sJh1Z5nSv6wToO3V9+APeHE8tLtOQSYZ+fW4Cmo/6M/hVZm8/c14Wbt9BcgZWyfjkqjaBK9qU2dAGCBHMKK+MAD0QzaugNN9zsCfbNWYLFjqIQNDl2QIUiaI3+WMvb5sd8TdpXOlyxzgnWghlJzg3fK3SOQ/hhClu/8snzT39W2Yl3nywLEJAbwSF5IEdJ8E7JX6cYXuFV6GVsQCe/L0dHNaxuXvzYou1TvBCA+qn4ZW9bpElLv7NqM81NuoUUgaVPdbSnkQ0s9lBod7VC0Tz5jdyMXkTd7K2nBVo75HKrjQRA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR12MB2489.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(38070700005)(55016003)(186003)(8676002)(4326008)(9686003)(86362001)(7696005)(54906003)(110136005)(38100700002)(122000001)(5660300002)(15974865002)(508600001)(71200400001)(66446008)(64756008)(66556008)(66476007)(66946007)(76116006)(52536014)(26005)(8936002)(316002)(33656002)(966005)(2906002)(83380400001)(6506007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?fbLk3ELP676Zx7aUhK5DWcMHrraNucfvhqv9/CMlZo4uvWJ+LDwXhD7BdvVu?=
 =?us-ascii?Q?h+D7xwZXgV88bDI8mGdBhy39SemfXui3ySP1UBYMq+k4SjQfxSN7Uy+g/UAI?=
 =?us-ascii?Q?mXZcPvajpRMqVHxxppPU5HrqUkaIoUE41BUHsoPv5pnrzQcMDZx4hTcwN1Ib?=
 =?us-ascii?Q?Bf/kSRiQE+EVhZwEqSWtP4KA2w6ietOLH1ZtT3lQ7CxNGCwIOI8bqaGF117H?=
 =?us-ascii?Q?1sx8Pfa3mTwaR0EYOcFKbUXIq0X1yw4cyagTammUq9Qa/2yBw4e5wblQRMSj?=
 =?us-ascii?Q?m5FzwVJ2iYxAy3+bLwD5aoa7dRdE/zsk6YD4ZhEP87oLiP/LQyqPaSe7fEJE?=
 =?us-ascii?Q?98TOJa+5zxr2HUm5tLvFkj+TvWyMXTYtyzOZVslUw7rchb2MNokQsmCjCsGg?=
 =?us-ascii?Q?QIJapxeAZ+aL+lAonbigUyP7XaImsvTD9Ftzn7dL7G8pLckrn1V/3GXjMaBp?=
 =?us-ascii?Q?YxIEQNkT5qMUgtnPzTMsk6yi3alHTN/t+d8QlFn2YIsYyYwBb8Y6l7KDkCTp?=
 =?us-ascii?Q?Zmdeyro4ajcGDpbTrvrPMzkypvhYI4BnhuXDrOk4PDe4eO4p8KxgsJwrxPGb?=
 =?us-ascii?Q?p4OuQyg63or4K/QkWf1bcolm08Ee+aRxGItOMY9n8TTlLPpZoq1GhsUHs0V3?=
 =?us-ascii?Q?Z1qruJzviRww4mCmdSEPBuEZAg0ibH/lfNRcnNFheolkXjX6kRMQ1bL1c7LS?=
 =?us-ascii?Q?vpzwS14kEG/1J7b+CQv6Gd4rkdS0S1N0pk2zfSqSnWu6wPusjbU99y02d+BF?=
 =?us-ascii?Q?YHL+AN482gMQTgvtTOMZjaExEAmvOQQGpboDqs/x2Z5CcN9yR/eVAVogwwy1?=
 =?us-ascii?Q?Rp2RPWbn+WyZIpABQadoHzJhCficmlnj6dLbImQB0dk7UFIULsWhHy5eKlmw?=
 =?us-ascii?Q?vHaQnLsDc9sTYssUaNjhXN5dyff00kOm8P74wTgwObzSAbZ+wD3ZL0CGDMyJ?=
 =?us-ascii?Q?AuCZ6NTrrRfGb9/y/SUKWFi1568SjbPhVlGibjTZ+ReiLhzA8XHpL4wZgIuh?=
 =?us-ascii?Q?437NHQHwcAHKjWas5D68ktxXi8HhZZ5qu2F+xo34WFZft/qJqj/eH0bJzIwH?=
 =?us-ascii?Q?HEBAGiouJNeORdSUqM6aaV+53g/qj0O5PJpnI9ePTuFrWgiW+32qLgfzGNKo?=
 =?us-ascii?Q?FT5Crv5TXlY4Smypbx7xFWxHJneZ10f5RAiSkDgyeDWOMLNJssvG8zPhJga2?=
 =?us-ascii?Q?0N1cD/ioBcdYq97wB+7BNBAjr5rXfov1eD6j8A1eBOvjjDdp+fcQwLCo3yb0?=
 =?us-ascii?Q?EVYHVCTRpCQ+nKMcMVnA+eYex100NkEQpIKUY3C6RGbOikk/dIUtYf/56+Xu?=
 =?us-ascii?Q?fxRk1CQorn9CY1XPer6dIPWIAW6GJc09ehJQ4IZSedCfGNyF8c9I6+ELd4k0?=
 =?us-ascii?Q?x+jA6i7JXLMRFNJyv/+meGK7j0H7J2wDXMkaFim8c9172t2G5ut6K+NGCDI2?=
 =?us-ascii?Q?bWpj0dlNSOr9ixssvMuUS8aF7oqxP97gEzXEsKJwMaFCaExGfavryxA6MJh1?=
 =?us-ascii?Q?W8PSVIWnG8qjPI21sFWTu447VQoOlh3tStE4+M3f7VCaQ2wdBrBwX+qkYe9x?=
 =?us-ascii?Q?jIH0r69XV80cwcpD2RTUD6IE2r7uzMeTgucnDE28kU1Tent/xfJczrpSwu0m?=
 =?us-ascii?Q?mQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB2489.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c9497ed-f829-4a69-5387-08d9cdd92db3
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Jan 2022 10:18:10.6710
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WeexNCDMHSWiaXxIR8/47Z1lkP8Cmslmr1lxcCC1crwSMNNke9UwLo1Loa2o6AILv2RBDv3sagD8cVkq9W7Y1w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1533
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Friday, December 31, 2021 04:10
>
> On Fri, 31 Dec 2021 01:49:54 +0000 Yevgeny Kliteynik wrote:
> > Actually, this was written based on debugfs functions documentation,=20
> > where it states that "if an error occurs, NULL will be returned"
> >
> > https://www.kernel.org/doc/htmldocs/filesystems/API-debugfs-create-dir.=
html
> >
> > Looking at the code, I see that it's no longer the case.
>=20
> Oh, I see. That looks like some old, out of date version of the docs.
> The text was already correct in 5.15, it seems:
>=20
> https://elixir.bootlin.com/linux/v5.15/source/fs/debugfs/inode.c#L549
>=20
> Also this render of the docs is correct:
>=20
> https://www.kernel.org/doc/html/latest/filesystems/api-summary.html#c.deb=
ugfs_create_dir
=20
The thing is, www.kernel.org/doc/htmldocs/ is the first and the only
doc link that I see when googling some debugfs functions.
Bing shows this as the first link, and the updated documentation
as the second link.

www.kernel.org/doc/htmldocs/index.html shows that this was generated
for kernel 4.12.0. So yes, it is very dated, but for some reason search
engines rank it highest. It's possible that debugfs is not the only case
with this problem.

-- YK

> I don't really know who's responsible for the kernel.org docs...
> Let's CC Jon.
>=20
> Jon, is the www.kernel.org/doc/htmldocs/ copy intentionally what it is?
> Anyone we should talk to?

