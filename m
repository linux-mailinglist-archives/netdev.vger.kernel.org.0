Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A28CA83769
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 18:57:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730505AbfHFQ54 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 12:57:56 -0400
Received: from mail-eopbgr130051.outbound.protection.outlook.com ([40.107.13.51]:24736
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732048AbfHFQ5z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Aug 2019 12:57:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jpJWiqbGsgA3VdC+B8nm/JcL6uL0zjAVPDg41c/KAvVI8Ie982AQj8z9YwAG+CyvD02cB7R3cvewFNTqNvK5kvoyyay5Pls/30hpzUJu8JqmZ0rU8hWdMxgZ5J7h5tPszbHal2riQqgYw/ePSRwJujPk6PYltQrXGWTSoNY+iREvdg1cYtjqmUKLdRYy+g+/hCNUXUKmZ5VF3cct5MZPmea2Xcs7Zl5zhW0CV9fLxRW8D/74R33FY35+HWpAnbpj1F3lqDpI8jda5nMx7dZ64/xvOpeTqpHFzoKv16/XIzwLdMhik9ktg+iLkX1OnveuSpv8/WdgcufWO32zVrTd/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CLqfcmvJobaavkqTmv9oEcUNZomO3M53ymvne+tCvuk=;
 b=iG+sfAiZ9grx3herGbuOGWD32agFkIKm5vc4HQq2e9GDjJ9ob9lEtgzpVtDpDfFZ8ZMwswS19FPuOGIH8AsSyJeU2Qp7H0nDoxKOH/ECIiQ/g9hom8pvZVFB9xx/g3Cb62AJsQ5BfAgWOtZfkiDwC/uc1aXobboMPbULWi5eIzePD7TU4pZh7U+D8WcrqHuS8LLhpLVK6hcb9XquTiRLqFGKtJkE2p1jrQOUwKssNV4b11v4IMgv/vqqTrcSJ74mTh+ps+uHg3n7wNCkZdvI7PiCi8dJJOJ/qUTKzB6ZaUvXx8HLWoOSw14w0B5xQW1vfPOX7KSOfb8BUAunx4OvdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CLqfcmvJobaavkqTmv9oEcUNZomO3M53ymvne+tCvuk=;
 b=LU+cBafV6VP0W4jUj3MgzoTyTKsNSo3cgEGWEIEOaFSnZlWoLmxkO8/c+rIwdzhXNzigKiGM653fIywrbkH0eSHAGCC98Zxmjqkc4kaKxZGPbfdGJ49pJCe4OUV7Vhb9HJiZ3oMI7IAaAV9ctL+HFnCCj5xnMABm1/HkFtbQr8g=
Received: from VI1PR05MB3152.eurprd05.prod.outlook.com (10.170.237.145) by
 VI1PR05MB4318.eurprd05.prod.outlook.com (52.133.12.146) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2136.17; Tue, 6 Aug 2019 16:57:51 +0000
Received: from VI1PR05MB3152.eurprd05.prod.outlook.com
 ([fe80::c407:16fe:412b:9809]) by VI1PR05MB3152.eurprd05.prod.outlook.com
 ([fe80::c407:16fe:412b:9809%5]) with mapi id 15.20.2136.018; Tue, 6 Aug 2019
 16:57:51 +0000
From:   Leon Romanovsky <leonro@mellanox.com>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
CC:     RDMA mailing list <linux-rdma@vger.kernel.org>,
        Michael Guralnik <michaelgur@mellanox.com>,
        Moni Shoua <monis@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH rdma-next v2 0/4] ODP support for mlx5 DC QPs
Thread-Topic: [PATCH rdma-next v2 0/4] ODP support for mlx5 DC QPs
Thread-Index: AQHVTCtOqQKjL+5WjEGHmx9JTdNfD6buV86A
Date:   Tue, 6 Aug 2019 16:57:50 +0000
Message-ID: <20190806165747.GA4832@mtr-leonro.mtl.com>
References: <20190806074807.9111-1-leon@kernel.org>
In-Reply-To: <20190806074807.9111-1-leon@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR0P264CA0158.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1b::26) To VI1PR05MB3152.eurprd05.prod.outlook.com
 (2603:10a6:802:1b::17)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=leonro@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [77.137.115.125]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 545b2ed5-2b9b-4b9a-2f81-08d71a8f373a
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR05MB4318;
x-ms-traffictypediagnostic: VI1PR05MB4318:
x-ms-exchange-purlcount: 2
x-microsoft-antispam-prvs: <VI1PR05MB4318F8DA260B52DBBD9D6337B0D50@VI1PR05MB4318.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 0121F24F22
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(366004)(376002)(346002)(39860400002)(54534003)(189003)(199004)(2906002)(966005)(81156014)(14454004)(81166006)(71200400001)(68736007)(66446008)(66556008)(66946007)(99286004)(6436002)(8676002)(9686003)(110136005)(54906003)(71190400001)(1076003)(64756008)(25786009)(33656002)(6512007)(3846002)(6116002)(229853002)(86362001)(186003)(316002)(8936002)(6306002)(66476007)(6506007)(6636002)(7736002)(478600001)(53936002)(305945005)(102836004)(26005)(6246003)(486006)(52116002)(256004)(446003)(4326008)(5660300002)(476003)(66066001)(11346002)(76176011)(6486002)(386003);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4318;H:VI1PR05MB3152.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: vJbV+E1LpCb1MZnF/IMlIqExEegxV1TWtRZi0ZesgxWkXl7FES46yZmMU6a906yV2iQ1eH4JCkmfoOJ2eQNUMLswr/M4BWwNs6ijOQ3ytZ70lR2IzNaF5Mc7w1dDMXaSorezBzT32lfRKM0CrfTcotgLeeIOpXoJ4FQNgNjnU5/FNJWRitIlvyjf3nxB7vRvVPgVrzinTuVPvAdf+Zbes7JnundEWGEK1c0jFzZAwEVakhfqG75Ex2sGu3rasaRhVU97DM1oe1on1ZuCJjsuUr++KVjdi8c96eyzzAWEez0+zbWTu9/eD6nqbyhPIP9DkFKJj0On+rc3k7lAaA0HsWpMwjuXq4zvnxmu8aGhVuEq02kl2S0pSE130ndC5gESkmWdA7GE0IwuTSuuul9PE6mvbNRGmrN5CZK72JgfsqI=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <00AFFEB43C92D94E8A899FC77763A6A5@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 545b2ed5-2b9b-4b9a-2f81-08d71a8f373a
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Aug 2019 16:57:50.6569
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: leonro@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4318
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 06, 2019 at 10:48:03AM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@mellanox.com>
>
> Changelog
>  v2:
>  * Fixed reserved_* field wrong name (Saeed M.)
>  * Split first patch to two patches, one for mlx5-next and one for rdma-n=
ext. (Saeed M.)
>  v1:
>  * Fixed alignment to u64 in mlx5-abi.h (Gal P.)
>  * https://lore.kernel.org/linux-rdma/20190804100048.32671-1-leon@kernel.=
org
>  v0:
>  * https://lore.kernel.org/linux-rdma/20190801122139.25224-1-leon@kernel.=
org
>
> -------------------------------------------------------------------------=
--------
> From Michael,
>
> The series adds support for on-demand paging for DC transport.
> Adding handling of DC WQE parsing upon page faults and exposing
> capabilities.
>
> As DC is mlx-only transport, the capabilities are exposed to the user
> using the direct-verbs mechanism. Namely through the
> mlx5dv_query_device.
>
> Thanks

Please drop this series, we will reevaluate it.

Thanks

>
> Michael Guralnik (4):
>   net/mlx5: Set ODP capabilities for DC transport
>   IB/mlx5: Query ODP capabilities for DC
>   IB/mlx5: Expose ODP for DC capabilities to user
>   IB/mlx5: Add page fault handler for DC initiator WQE
>
>  drivers/infiniband/hw/mlx5/main.c             |  6 +++++
>  drivers/infiniband/hw/mlx5/mlx5_ib.h          |  1 +
>  drivers/infiniband/hw/mlx5/odp.c              | 27 ++++++++++++++++++-
>  .../net/ethernet/mellanox/mlx5/core/main.c    |  6 +++++
>  include/linux/mlx5/mlx5_ifc.h                 |  4 ++-
>  include/uapi/rdma/mlx5-abi.h                  |  3 +++
>  6 files changed, 45 insertions(+), 2 deletions(-)
>
> --
> 2.20.1
>
