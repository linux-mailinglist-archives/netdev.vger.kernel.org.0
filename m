Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A274C7DDD2
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 16:24:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732004AbfHAOYl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 10:24:41 -0400
Received: from mail-eopbgr50089.outbound.protection.outlook.com ([40.107.5.89]:11945
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731986AbfHAOYl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Aug 2019 10:24:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D8IvnzRowVExBPKJvSrixxoT9RF8K1Xq+bhUgatK9YwEn3h0PwByIbXPHnePhUuP4QkYZRlrQUBFLkkMtjAzlk6OZA4/SsfBSDExwIYNl2jQ6zkcOElywTZv7ZqbIdoL8KvvRembPvMjTm7FRIYgUX2MHM2ZbIN3u21psdc49voGQoHJQiFlmpK3mD2LT1/VO231i1Jqnfi827RwPgLXq312ps/v0p2EFNC/PyfsjDM0cHj0PzO1Dr4N3B1c6Nmom2ny3ARpf1iF3xxQE+RwVd/1g9uEXT8WofnqebEwbapvCnWoGPpFZoA7iZbQIBDzdr21EvnT9XiAcqfymbuMjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ftlIbwRarAUZznkG3GrVxXv0ERwyRigpgVBNwOhoMpI=;
 b=ht+njWZr24shbNbw9S8CnxKNl58A8IEjEJSKxRNHr46t9O1zMJrj17vEn0D6YbhSV5kYPLagNMfd03NCxif0N1yYCCUxqpptMr1+shsvIz2kfPg1Q9nK8xx32BE3X9tZrgnlDaOoY9Mxe6zg3+QXtzK/774pu0r60EmjIUoml766HPF+Vlkr6F8e7RlB2mSM5botAst2ZOabV02aPFiMdJaCRxrhkWYiZzkg0NpeV7EOrePRMz9gmWI4U9WfwuliQOx5dNe3Ten0ja2gMvS+V3U740s7Zp+wj0gp2p/l5c6r4TyitWwMWr/GQjjpj2fTCy2VY6NeaDnfYnWrI+B8wA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ftlIbwRarAUZznkG3GrVxXv0ERwyRigpgVBNwOhoMpI=;
 b=ax45Q65Q5OIkL6LA3gHGD/3XGRCH57npNB52wxpgoZnDd0NgqTQ8WgeVkMn4JSEemP52Y8ZUdBKkqCHKyiOqIvkqZ4NaBqpjDClClBgeoQaQ8Pv6q6BXDTpU9iIEuqgQlJAsfN7qI4YWpyntZqtkNcahrxsbw2IvRiHRcRp8CWE=
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com (10.171.182.144) by
 VI1PR05MB6238.eurprd05.prod.outlook.com (20.178.124.29) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.15; Thu, 1 Aug 2019 14:24:37 +0000
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::5c6f:6120:45cd:2880]) by VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::5c6f:6120:45cd:2880%4]) with mapi id 15.20.2136.010; Thu, 1 Aug 2019
 14:24:37 +0000
From:   Jason Gunthorpe <jgg@mellanox.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     Doug Ledford <dledford@redhat.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Michael Guralnik <michaelgur@mellanox.com>,
        Moni Shoua <monis@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH rdma-next 0/3] ODP support for mlx5 DC QPs
Thread-Topic: [PATCH rdma-next 0/3] ODP support for mlx5 DC QPs
Thread-Index: AQHVSGOxrLc2pW/YvUu4V2Ix3/TJEqbmWOQA
Date:   Thu, 1 Aug 2019 14:24:37 +0000
Message-ID: <20190801142432.GD23885@mellanox.com>
References: <20190801122139.25224-1-leon@kernel.org>
In-Reply-To: <20190801122139.25224-1-leon@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: QB1PR01CA0025.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c00:2d::38) To VI1PR05MB4141.eurprd05.prod.outlook.com
 (2603:10a6:803:4d::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jgg@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [156.34.55.100]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 35bca7bb-cbaa-438b-a9a6-08d7168bfb59
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:VI1PR05MB6238;
x-ms-traffictypediagnostic: VI1PR05MB6238:
x-microsoft-antispam-prvs: <VI1PR05MB6238D7CA74F90C9783189712CFDE0@VI1PR05MB6238.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 01165471DB
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(396003)(39860400002)(346002)(136003)(376002)(199004)(189003)(6512007)(81166006)(478600001)(25786009)(305945005)(8936002)(476003)(53936002)(81156014)(446003)(11346002)(66946007)(229853002)(36756003)(2616005)(71190400001)(4326008)(68736007)(71200400001)(8676002)(64756008)(66446008)(66476007)(66556008)(33656002)(7736002)(66066001)(99286004)(316002)(54906003)(6116002)(52116002)(3846002)(76176011)(186003)(6506007)(386003)(2906002)(5660300002)(1076003)(6436002)(6916009)(6246003)(6486002)(102836004)(14454004)(486006)(86362001)(26005)(4744005)(256004);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6238;H:VI1PR05MB4141.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: ninUkD+v0MVx4zKLIWA++ZnStLvZLCA/ACplQpyRyfB7j0CGQ+T5w0YK29z202m0PrpP17dMucuTLpXp5+TMamrksuUtMIU9vCj2LApmemwU8/mWlpEHai7wWqMpQQQPue4ngk5ZJyqdbx+RUQy5cld/pgnBKcTctlgZie2phK+s8Df9k5gYEDq8SVOGRItpZJ4Ur7jYHCD9G1HvkkkZVqcJ9w6KUGDNmBJqL7f/Iq6exZ9/vGaFxilZyv19nBKrFvWliD3cvX1zFBPqFIcIQgx/pSQ2H6muXqniYbI1yHOjS3l0IquEBHcPyG3rfl6SHAs/WisOnsl4HG9unldNADVY0909Q6wrxnWOb2+IJ1wSR8eBMjKeCeuMaX/8R9R8XelRrcTP3zYBPr5FRt/RTu/1KOfEos/6kngOEgiexRc=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <0F90C8B9BB2C6A4C9E351F6A2822DE29@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 35bca7bb-cbaa-438b-a9a6-08d7168bfb59
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Aug 2019 14:24:37.1765
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jgg@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6238
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 01, 2019 at 03:21:36PM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@mellanox.com>
>=20
> From Michael,
>=20
> The series adds support for on-demand paging for DC transport.
> Adding handling of DC WQE parsing upon page faults and exposing
> capabilities.
>=20
> As DC is mlx-only transport, the capabilities are exposed to the user
> using the direct-verbs mechanism. Namely through the mlx5dv_query_device.

The cover letter should like to the RDMA core PR that uses the new
API...

Jason
