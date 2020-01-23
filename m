Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF9FF147407
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 23:49:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729324AbgAWWt0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 17:49:26 -0500
Received: from mail-eopbgr140054.outbound.protection.outlook.com ([40.107.14.54]:5863
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726232AbgAWWtZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Jan 2020 17:49:25 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PVYCYhPhVvfQACKH4jxwYG3/eGQMk29vBiBRHPf9If92XsoYH5tiFpnN08te0jhx88CGeIm5R5SXQ+6s5AIEihdzS0hqdHptw70Ln2KIg/hUzqYUgeQJj/muIVQ5d4wTKie3t8lT1m7kYPho2SRWxMlHBfuqc2qFMfmC4cfErGhHUd8Tr7SGAoyoDnaNj9oI149F5cVAKce0wmnplajS9AHbqPTWDmltx2oWAnPoCixsujlSUCOuBCN/9WoyTX1/Aznfe9F/YS7YgZSuccCW+afvpv22qSZQcL3o69w2EFQn2g7LK00E2SdovP+qAUZQqcMxDZBlbgLBQ4pQ/JfaIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QpaC0S1u8E16W5qGKm8aUCb5Npyybv9EZ2dIzL+Z+KE=;
 b=A7hO/H7MglbX5GeV1q50ujWz345D+34LWg+YxE2/wmpdjgzBxNQx6ojIghAymkkjhR/D8lkFOG8IqsBWkgZVZPy1YYuwYCRUae1NQ3CmjxGjngbFfEp6i0xWEmeL6Ny0CLfpv970vLzqX2Hqt3RcXUVBz0kdd0jO4DbB2YRCJtMlpm2D/pOQl9yL3kho6YxRFJ1LBViLTT7Wt4TI/3pnPl3xbVOZ21UmpQmU3G3FyTGifd34Gc/lQNGDaDwUhFoCAkRUBdEXQWWIcUW4EKfU7WMYlyMNu5BEK8YbUfURXbJ4t4LxDS7sC7IgxHCUvUNXPWX34h7mY5B3ukz4xz3WsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QpaC0S1u8E16W5qGKm8aUCb5Npyybv9EZ2dIzL+Z+KE=;
 b=OUJNymD5ATd172HOsGm9aNr0wB5Li+UaupnDSNlXRXng3DQe/3MDJo/J5bq2DtIyBue6LNc8g6xzQ4Muk0PspLgFSU8ftrTQ8edGJ2DomZe7rXBUO+3ehJaQd5hdcD0FKfOrn84WCZoMbQ6UB7wYXjbWxXkg9njdcrwiSR3uBok=
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com (52.133.14.15) by
 VI1PR05MB3168.eurprd05.prod.outlook.com (10.170.235.141) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.24; Thu, 23 Jan 2020 22:49:22 +0000
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::1c00:7925:d5c6:d60d]) by VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::1c00:7925:d5c6:d60d%7]) with mapi id 15.20.2644.027; Thu, 23 Jan 2020
 22:49:22 +0000
Received: from mlx.ziepe.ca (199.201.64.131) by MWHPR15CA0050.namprd15.prod.outlook.com (2603:10b6:301:4c::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2665.21 via Frontend Transport; Thu, 23 Jan 2020 22:49:22 +0000
Received: from jgg by jggl.ziepe.ca with local (Exim 4.90_1)    (envelope-from <jgg@mellanox.com>)      id 1iulHn-0003wO-V5; Thu, 23 Jan 2020 18:49:15 -0400
From:   Jason Gunthorpe <jgg@mellanox.com>
To:     David Miller <davem@davemloft.net>
CC:     "leon@kernel.org" <leon@kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "dledford@redhat.com" <dledford@redhat.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        "santosh.shilimkar@oracle.com" <santosh.shilimkar@oracle.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [net-next, rdma-next] [pull request] Use ODP MRs for kernel ULPs
Thread-Topic: [net-next, rdma-next] [pull request] Use ODP MRs for kernel ULPs
Thread-Index: AQHVz2OPYEit//2cFkOd4SlTd9Kfsaf03YkAgAQCXIA=
Date:   Thu, 23 Jan 2020 22:49:22 +0000
Message-ID: <20200123224915.GK7947@mellanox.com>
References: <20200120073046.75590-1-leon@kernel.org>
 <20200121.103546.795107006412728523.davem@davemloft.net>
In-Reply-To: <20200121.103546.795107006412728523.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR15CA0050.namprd15.prod.outlook.com
 (2603:10b6:301:4c::12) To VI1PR05MB4141.eurprd05.prod.outlook.com
 (2603:10a6:803:44::15)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jgg@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [199.201.64.131]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: f40399d4-832e-4839-7ffa-08d7a0567cf6
x-ms-traffictypediagnostic: VI1PR05MB3168:|VI1PR05MB3168:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB31685734233E79F286FD2A72CF0F0@VI1PR05MB3168.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 029174C036
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(346002)(376002)(396003)(39860400002)(136003)(199004)(189003)(1076003)(52116002)(6666004)(2906002)(316002)(66476007)(66556008)(64756008)(66446008)(71200400001)(26005)(6916009)(66946007)(54906003)(186003)(33656002)(8936002)(4744005)(5660300002)(86362001)(9786002)(9746002)(478600001)(81156014)(36756003)(4326008)(2616005)(8676002)(81166006)(24400500001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB3168;H:VI1PR05MB4141.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UbKBxc4rZFag702I33XXy2JwGtckdForfJplO6y8yteYXzCVFFdaASvmdb1+8TP/KeFUH+vOUHFhR+CRma/PqodylWYmv9acFYUnimlWNZefjHzqp+5R7hRR4U1oAipGccOWlWFbh5MokrbcwHEZ1yn2DK7VarPtK/WOxIQyPb1EVSwIoJHq7R+aCZYyQ6FTXuZBrKeHhdOT3FEbMSo1NMx5xr7/Zh9IhDIq/aBsvwLXoHRS1Brfam8X1Hig5FqEx1YO+ClMDlz7ZcqAoUltuyOXJ+RwOPZmPEgn+gj917iumXOEHgsPYXsXBaYAazGeRj0abFLJ8uG+eg1N9pCLhIU8k5mLOY4KhEMRcRL9J3XHm3Y/mkC0aSsdV94FOfEc2xFR1S0NetUsH98BQjjgPRRVti5cAR66OEV9Z53VhU9l8kUv/QixL7vaNOSsA/VIB0ORqwJg70X44oi4ugpJn73At2080mzuMpLO4LYrsVgDxEnZRHf08oyAuZB6hOEM
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3C9B7205D765CF4195B6C6918F0F2789@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f40399d4-832e-4839-7ffa-08d7a0567cf6
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jan 2020 22:49:22.3193
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 23JBEsKEVUmiqVd/mW0YP657Z0bq3MvmFfwaQ41tL5OpL+wNSqkwzG3viCqLWzkpzlUBmQv+h3DOpQmDHUx4KA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB3168
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 21, 2020 at 10:35:46AM +0100, David Miller wrote:
> From: Leon Romanovsky <leon@kernel.org>
> Date: Mon, 20 Jan 2020 09:30:46 +0200
>=20
> > From: Leon Romanovsky <leonro@mellanox.com>
> >=20
> > Hi David, Jakub, Doug and Jason
> >=20
> > This is pull request to previously posted and reviewed series [1] which=
 touches
> > RDMA and netdev subsystems. RDMA part was approved for inclusion by Jas=
on [2]
> > and RDS patches were acked by Santosh [3].
> >=20
> > For your convenience, the series is based on clean v5.5-rc6 tag and app=
lies
> > cleanly to both subsystems.
> >=20
> > Please pull and let me know if there's any problem. I'm very rare doing=
 PRs
> > and sorry in advance if something is not as expected.
>=20
> Pulled into net-next, thanks.

I've merged it into rdma.get as well, thanks everyone

Jason
