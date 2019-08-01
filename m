Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 318A77DDDD
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 16:25:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732024AbfHAOZU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 10:25:20 -0400
Received: from mail-eopbgr50071.outbound.protection.outlook.com ([40.107.5.71]:8095
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731986AbfHAOZU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Aug 2019 10:25:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cY7ZDqKEWC27u1sLcp1jVY+0qyMZ+LDDtiKLEPZ8zIvyvkod3C7zjnx2zj9H5EXu12kFsjEe8ii1ctAmqvi/G2xOJov0WBZd5HLTHSkiUh+i+hYkAxyn6W6LP6wXpm89O/HQNLwbP7TL2Xt/pxScXJSvaWRP7qNAc4K0OkHHk0rPRGHFPmNit5liZYa2LLYoMHfmopQdveRVR4IfHLEjzEfmqh5DEuiqwIoiTcICgPBuoUWaubrTo3M/Lc91ZnH6BNrfaXp4sKqC4M2XfCwsFusi0grllVvMHM8Gda2DlqS3QAt6E2avsY8temx7X4zC10twgxBpt++uQHPF4qAAYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V7uTr23ADJj3XKmlKmhi/lGFJlYSxHpn66oMRf9hJg0=;
 b=ev2Vp7dG/tSC88zl1F3v+glG+DxUpduB6rXj9s/4eyh3INNSSVUxfP8L0H0j9f/izfgXHsJcJK4zcDAafNC8kj/g/DKq15FoPmj/H4cq5aJIMbiNwHb6LdAyEz82YyuR0MhXrUZrMKyJ/yRmu1b+9RoOKsvdBEZjATIl2I0z4JPgSyWIaeFU47f+Xcj/XEyhlQ6X2hjq8DUgY+d2UOOwuKsCOiK37ETsrckUUb70XDg6yw6euLrsfxaUh8htKT2GO5OS1lLepRh11sLvqBhi4UQp1QXi0cYjseTeJ7oCva+cOHj1OjRCpDPx6t6fdjY3shET4+XD4IPfoo+hIxh6aw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V7uTr23ADJj3XKmlKmhi/lGFJlYSxHpn66oMRf9hJg0=;
 b=KUvMEBfdU4GzD5Sw5seFBw78/jRhrB2A92+MfVqyt/25aoyUzU+aBxp0lCMpWdAZiCZdHt4PW8BQS/v8Ty5hZJNhRShPMQrY0JKYiUlsR/mZdxFpraonngvu/E4cXZDmngmvUIqquufD9wdF2/sqY53QzE+qUHvDX6KJxyupwrw=
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com (10.171.182.144) by
 VI1PR05MB6238.eurprd05.prod.outlook.com (20.178.124.29) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.15; Thu, 1 Aug 2019 14:25:16 +0000
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::5c6f:6120:45cd:2880]) by VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::5c6f:6120:45cd:2880%4]) with mapi id 15.20.2136.010; Thu, 1 Aug 2019
 14:25:16 +0000
From:   Jason Gunthorpe <jgg@mellanox.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     Doug Ledford <dledford@redhat.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Michael Guralnik <michaelgur@mellanox.com>,
        Moni Shoua <monis@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH mlx5-next 1/3] IB/mlx5: Query ODP capabilities for DC
Thread-Topic: [PATCH mlx5-next 1/3] IB/mlx5: Query ODP capabilities for DC
Thread-Index: AQHVSGOyR3ad8JsdxkSDN4m56yce3abmWRKA
Date:   Thu, 1 Aug 2019 14:25:16 +0000
Message-ID: <20190801142511.GE23885@mellanox.com>
References: <20190801122139.25224-1-leon@kernel.org>
 <20190801122139.25224-2-leon@kernel.org>
In-Reply-To: <20190801122139.25224-2-leon@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: QB1PR01CA0010.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c00:2d::23) To VI1PR05MB4141.eurprd05.prod.outlook.com
 (2603:10a6:803:4d::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jgg@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [156.34.55.100]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e2a92453-acb0-401f-78bc-08d7168c1295
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:VI1PR05MB6238;
x-ms-traffictypediagnostic: VI1PR05MB6238:
x-microsoft-antispam-prvs: <VI1PR05MB6238857F53E33BB118589B30CFDE0@VI1PR05MB6238.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2887;
x-forefront-prvs: 01165471DB
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(396003)(39860400002)(346002)(136003)(376002)(199004)(189003)(6512007)(81166006)(478600001)(25786009)(305945005)(8936002)(476003)(53936002)(81156014)(446003)(11346002)(66946007)(229853002)(36756003)(2616005)(71190400001)(4326008)(68736007)(71200400001)(8676002)(64756008)(66446008)(66476007)(66556008)(33656002)(7736002)(66066001)(99286004)(316002)(54906003)(6116002)(52116002)(3846002)(76176011)(186003)(6506007)(386003)(2906002)(5660300002)(1076003)(6436002)(6916009)(6246003)(6486002)(102836004)(14454004)(486006)(86362001)(26005)(4744005)(256004);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6238;H:VI1PR05MB4141.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: /aZD/EInMUwNexr+n6zpDPvsHAH6R+JptqoxpBjAoB2pLPDeLQQJjb+2nLPG+U2g0I/J0tylZiIdlp+nFueyFp6PAzIawwB/OEPZo96QEWU2vCkEDCvAzZjQO7OOaYxE3Ba4v9xYJ5ZN28K/zmxKIsqAwKlgRZ8IDxY1usMy/MSvX+8mk6L6p2BGIGVJSA6BXDeJuq/gAbQ0P/6+C1Sq1dIk9sf7pHE03+zwHEhHxO+NmqkmUlGRDugqXC6mDBKAFWdWo8LKFhwjpxREpZuWwVzCpE6C3SSu17Y9/IkqTyuEkMub4DpSAOsBl6N0D5krJiEQ0sqklQ/6vgCnXQxoMxP7mcgVZdZgx903xGLC+/09+1fPuBZ7kYo4GEgWZu9rDD7aMquW7Muz2vqBlnMVthRl9q6hQKJgfswb79qaKig=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <B691C513CBC1B945BFE1D46356628C12@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e2a92453-acb0-401f-78bc-08d7168c1295
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Aug 2019 14:25:16.0751
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

On Thu, Aug 01, 2019 at 03:21:37PM +0300, Leon Romanovsky wrote:

> diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.=
h
> index ec571fd7fcf8..5eae8d734435 100644
> +++ b/include/linux/mlx5/mlx5_ifc.h
> @@ -944,7 +944,9 @@ struct mlx5_ifc_odp_cap_bits {
> =20
>  	struct mlx5_ifc_odp_per_transport_service_cap_bits xrc_odp_caps;
> =20
> -	u8         reserved_at_100[0x700];
> +	struct mlx5_ifc_odp_per_transport_service_cap_bits dc_odp_caps;
> +
> +	u8         reserved_at_100[0x6E0];
>  };

Not splitting this to mlx5-next?

Jason
