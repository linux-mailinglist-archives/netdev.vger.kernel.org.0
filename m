Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5720A43B624
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 17:53:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237157AbhJZPzp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 11:55:45 -0400
Received: from mail-bn8nam11on2072.outbound.protection.outlook.com ([40.107.236.72]:26528
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237044AbhJZPzm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 11:55:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QJFyDHzYX4jEQGtpao8ZURmYIJBY/rjlbR6RRP+M1Zfy5k+WZm/yqvEo6lUS1+zl32kWCCW+7RKIX4+SaAFmNAtOSccMBsuB2HQsoO9kC1WIfNzQ4d4fcHH8r7S/0jLOkm7WXmhCslA91oEY8zrV+XXwrmgqLIGYx9h0S7nbBumS38h8pcNO3oh6z9pFCZYA9Li/NrG/pLBJSOXEN6cWD9v5aOA83ogleuxQozrE5mIGfiO1toAUZfZtTRlKkXks+3oEXE5eVqK6O6+/CKs8XECXrHFYOGCjKwePooVq69pNVxG+ti3x8/FKaCP2ilt5iHP3ZMe6pk+ceWyVPsMN7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bEjCWNZYrn8XPPtwQH4pXNNGioVr8pifD5YhrY2cFBM=;
 b=ocUF/r3ghtVKvfTu/XAtnTt7dbhvTJmL3vg+kd/R9W/mBUwyKkAQBFoPPC10vcGnYiokfCM7Bcn5UpB8Y/K7FFps87XQm71svheZbmWLlg9UYb0PIAGlACiNB/Bk/KSHBZpK5tJiz451OlfS2IG5XwlLn1bde0HEBOnL2UX/cbZId857Dc6iWIPwtUJoAYoIqzfhQnn2oMK20TlDwvuQvr9XsC4e+AnuG9B6UWB2yNuZz9Wn/74VYGkuj5Zb49bCWtRL6pXDkc4m4m1bk+bwUQc6zYQYJU4wfz37Zdolq05e652Zi2g/zgf0tAw1xXL3uKkSD+ut+c7Y4snabFXg2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bEjCWNZYrn8XPPtwQH4pXNNGioVr8pifD5YhrY2cFBM=;
 b=HCIHUjWTxzS2BqLE85gcDPQWq33V5VQJf7x3y5Oje8Eu/vVLy7kRp3eWLGcp44+4m6mBpjl3zAHMQLJY6Oi7CsEKu4oMhlXz1W+u+D+EfzPF94rk/LLnJUBxszfKZ8RWXigT2cSsO/N6MhYjr5AZcu3CyF9usc5kVKiwy+NoZwxQW/zW/Gad3YwAmTKQ4nGu0xfrJJwMvw32ISA/rMPG1AaVaKqLCUREeuSV8CLQIrPaELmAUasu84PEVkgt9IabcPB8wDojwJDVnxQsr743oqlNmX7tpwN5j/evQAKyKS9U6ltWGJ+o69uD7qzdFhO9fQnnKvmBB8IVs/Ie1+nlxQ==
Received: from PH0PR12MB5481.namprd12.prod.outlook.com (2603:10b6:510:d4::15)
 by PH0PR12MB5434.namprd12.prod.outlook.com (2603:10b6:510:d5::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Tue, 26 Oct
 2021 15:53:17 +0000
Received: from PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::e061:9284:b153:e633]) by PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::e061:9284:b153:e633%3]) with mapi id 15.20.4628.020; Tue, 26 Oct 2021
 15:53:17 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     Saeed Mahameed <saeedm@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Leon Romanovsky <leonro@nvidia.com>
Subject: RE: [PATCH net-next] net/mlx5: remove the recent devlink params
Thread-Topic: [PATCH net-next] net/mlx5: remove the recent devlink params
Thread-Index: AQHXyn5N378XuU/pfUmx16xNd0vsJKvlbIoA
Date:   Tue, 26 Oct 2021 15:53:17 +0000
Message-ID: <PH0PR12MB5481970AFEFD9C969B42BE20DC849@PH0PR12MB5481.namprd12.prod.outlook.com>
References: <20211026152939.3125950-1-kuba@kernel.org>
In-Reply-To: <20211026152939.3125950-1-kuba@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0211af84-0c09-401f-0f89-08d99898ba4a
x-ms-traffictypediagnostic: PH0PR12MB5434:
x-microsoft-antispam-prvs: <PH0PR12MB5434E7D26481378232D24C19DC849@PH0PR12MB5434.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2150;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lrLFBQFpFAfY21UVIbD1QYarCw4uIhNKAdVL9MAhWgBE1ptx0SDDjruO8BCyqT5vooyWnZ9aJiLE8ppfsDIW/a4mD3JI31l0Z+a/JkBovAsaB/ZsuorV0kWx0NiHmM3h99ahu+Ddpleej8OxJ1UID+p88JkyZbLxjemMr4iS+uhPfDH5C3KJ2VdfNBOYJ42UqjrxYMJiu6zbQPmr0SS5jZeJWZrfHsjnRbkvEaepIfcp9depiYO1LgsN5HOHSGphbT9Fs0SCxW6HpABndAKuYRpPy6Dwo4sR08at+jwO1OxzLpCiCLw7YCh5572GSF13rpo5lojxLjhxfzp1EpN7KQwAuKDzAP4g5Pn0HMx7BNU3Ip3aWbA717Ew5B7ONcK8mE5SCFmA6DskWHwHRmQbX+hyrJs7ZBPOB7fNIkHoVXJV+mPIwzjR/YKiaPEjka+/ags/B7AoQB3Tjnge6SCEzFXALFtY/ry9zf9u36KEtyT85oexBTYNmEnkCeG/RGXA8x9G607/GrwUWdBz3tHGZG6Dq++kqvUqen5hrAfzFcdupcMkklOkwkIorGH9UrVBLjfvuYWKLDrQ/i4k+ABgON3YQFpRUFHm/BpRwDY6hk2kYy7r9RZA9RGzv6gTCm8ZfwlW6SoMALoP7a6GpqIzBFSLX/YfNsJmmMnMQf0rtyWFB+UnjkrgGpq1kiwwNPe6GCWUnZZY0hx62eqMTcZrIw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5481.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(33656002)(38100700002)(2906002)(38070700005)(8676002)(54906003)(76116006)(66476007)(9686003)(66446008)(122000001)(86362001)(110136005)(71200400001)(186003)(5660300002)(316002)(52536014)(26005)(6506007)(8936002)(7696005)(53546011)(55016002)(107886003)(508600001)(4326008)(66556008)(66946007)(64756008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?NnazgGFFK07qMxjas+C0QC11tnDspRbPBuHHJLj/q+Gngfb7gCcUKhx53ddi?=
 =?us-ascii?Q?au3V+rim8/w33HjOan5l7isz5n+pHcvr/OXyKSxc5gDBex8bj73YvcgUf6Nj?=
 =?us-ascii?Q?yNlhp9JB6HN1RNrtYHv1BPNvCxu77hM8oqaNl+ABfzCO+iOmooc+U16hCtyr?=
 =?us-ascii?Q?t1V2kisrlcPn0g6XEdcGGDQYjCKPadfWJcLVLIa4rFXXO+yoz0J2imPyBJbO?=
 =?us-ascii?Q?CocLdfA1jivdp+cIa4s+1LxKHBgz/ima77o0FY1JCW4NzKweH9kzed48tOXp?=
 =?us-ascii?Q?woxVvKguahOGa+dpBjT2PO3n9IAmOyO0fykGMil7q1nHj92m5m5K2oSWFjhn?=
 =?us-ascii?Q?RIEkc0LSivqbl6lHOE1SPDhbeC3xAP+QUTh6WUusSiFM75mpMZ3HAoepAc0t?=
 =?us-ascii?Q?nKAkFVOTK2zGOl+RqRfEQG9fzJdz/YjkLhxN18VuD/OwvxLWnol2h4NPY6s2?=
 =?us-ascii?Q?/4oFS3YavgBVubuA9iHpNF1lStVVoCA4+UloFlCSM7Z7y7qBvWsYfMsUfKRW?=
 =?us-ascii?Q?Qxn4SKp7BJMbxdQ3swXQkaScGGptqjCFFq/2ipvMBMeCc3vXKDnPGKXhUnXA?=
 =?us-ascii?Q?H1TJqNC6c7bMWHc/f8ayyqRebjXE9TDyjBVOp+cMHo6FX4QQ/mF2wpq1dwy+?=
 =?us-ascii?Q?+6zy0a0Mpd+e0EIMIebzlPp2iswGvJNjwJ8h9BebTVgDdOwjZhLBO63CmWql?=
 =?us-ascii?Q?HIhEGdxxFSX1MeqBTHSy/Q50/guQ5sARHRPtg+AWs2DuNIuFICfoOBg2SFQX?=
 =?us-ascii?Q?BAfkH78GE+gKvwmijpKOIjbUhafwOUovnAi735uTMVOaPCFc9FpZ4AUCv8hg?=
 =?us-ascii?Q?30+ojJ/wloB44zkVvHXnIC6ATVR/7wN3jF2niLzrHYk/RibH0hfWv88oZ8/A?=
 =?us-ascii?Q?6Drli6YAhMmGX6DrYES7ZGye8CLvsS4FOMIKBRL6zP6NA8wTIieOayNiRqHk?=
 =?us-ascii?Q?joX7SbVlnNWybxD7KiGpG+WtXhFnWFd66gekWGG7qPj0xwQOSaOtSOVvtVVO?=
 =?us-ascii?Q?HkFdyco2FlDMZW+z3vYj5X4ZMzZfTpG2jmBMh7gPNtk+bpnqQohmm8shQ2/Q?=
 =?us-ascii?Q?6sEgqbQ7upQlS9Nm7aWrMNxqsElsGqORS8pAnqt0Id45O9lKUxB1BtByEAcf?=
 =?us-ascii?Q?KEMLjBp9kMY1+zTVbFdD5OxP593lQQ1ITLsMkdDzkj3lJfhGV+zgOEwdiS6v?=
 =?us-ascii?Q?aIXV1cibZGexalMX9alU+gEz7qBmo7Q3Ip8tOkATWAKrJxCVJbwEUxHz/HRF?=
 =?us-ascii?Q?DBd6MjHqyY+FTqy5SNa5jjpxYmYjn+8o3XZGoaBotKrFF4s/4oxR9Nhp7AvB?=
 =?us-ascii?Q?60doutL+WUpwd2ywELOD0L7jAGW/HeLT/fn+44PYfOsTCeVh0uksYaukXui/?=
 =?us-ascii?Q?ZFd3q4326sRJVNCC6Ei296qiC6R2napibUUC5ekwx0NEXb0BB0fbylpf2pGW?=
 =?us-ascii?Q?Ep/AWVlzgQB6V5M2mQLZMKvl+AgC2UXUzUgOvijL/8eSqh8lrnhQJrAfxtO9?=
 =?us-ascii?Q?aeswkbuTSmaPgjdIiXIte/94/fBGmVYjzpa3ibukLI3IVsHJrf0oPq9aCxr7?=
 =?us-ascii?Q?3aYe3esVyO4ydVkDS6c3tSQvIkIt9hE9PJV2DQtdwWuM81qoWM8VOEAmd7Is?=
 =?us-ascii?Q?SCJ6OUaD/Y7sw0UIIH+1ZFA=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5481.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0211af84-0c09-401f-0f89-08d99898ba4a
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Oct 2021 15:53:17.6984
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MN91BpHH8nCnnnTLB6PaPjx1FsnOEmPdj7h+FGOILqOEzjR8Z8f/czox1hPlBryuwzqUJ3zZDyxuHQN34XSq4A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5434
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Tuesday, October 26, 2021 9:00 PM
> To: davem@davemloft.net
> Cc: Saeed Mahameed <saeedm@nvidia.com>; netdev@vger.kernel.org; Leon
> Romanovsky <leonro@nvidia.com>; Jakub Kicinski <kuba@kernel.org>
> Subject: [PATCH net-next] net/mlx5: remove the recent devlink params
>=20
> revert commit 46ae40b94d88 ("net/mlx5: Let user configure io_eq_size
> param") revert commit a6cb08daa3b4 ("net/mlx5: Let user configure
> event_eq_size param") revert commit 554604061979 ("net/mlx5: Let user
> configure max_macs param")
>=20
> The EQE parameters are applicable to more drivers, they should be configu=
red
> via standard API, probably ethtool. Example of another driver needing
> something similar:

ethool is not a good choice for following reasons.

1. EQs of the mlx5 core devlink instance is used by multiple auxiliary devi=
ces, namely net, rdma, vdpa.
2. And sometime netdevice doesn't even exists to operate via ethtool (but d=
evlink instance exist to serve other devices).
3. ethtool doesn't have notion set the config and apply (like devlink reloa=
d)
Such reload operation is useful when user wants to configure more than one =
parameter and initialize the device only once.
Otherwise dynamically changing parameter results in multiple device re-init=
 sequence that increases device setup time.

Should we define the devlink resources in the devlink layer, instead of dri=
ver?
So that multiple drivers can make use of them without redefinition?
