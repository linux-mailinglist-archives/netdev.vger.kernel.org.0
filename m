Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBBA81AEAE
	for <lists+netdev@lfdr.de>; Mon, 13 May 2019 03:11:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727279AbfEMBLv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 May 2019 21:11:51 -0400
Received: from mail-eopbgr00068.outbound.protection.outlook.com ([40.107.0.68]:57582
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727083AbfEMBLu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 12 May 2019 21:11:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IbvwiC5g12ktlDMR5DznnFAsjMGpvLm+aOt2kY3Mtc8=;
 b=FhgLFaQATH/Nx2ZqtP2ZP1VmIYfZ5Rm53d4qNTSmZKJBbVADUadi0a8nCfDmJfeFUBKyC+tjQWaBvGPF0LqJOa8VXusNkxEoXA+7wdhdY0mjebs+hPjJXF4wWIsjBgDo0VN0SCnk4xMCfVbj9+Mpz2xkFjk6Qbv5g0wXljtmMCo=
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com (10.171.182.144) by
 VI1PR05MB5311.eurprd05.prod.outlook.com (20.178.8.220) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1878.22; Mon, 13 May 2019 01:11:42 +0000
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::711b:c0d6:eece:f044]) by VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::711b:c0d6:eece:f044%5]) with mapi id 15.20.1878.024; Mon, 13 May 2019
 01:11:42 +0000
From:   Jason Gunthorpe <jgg@mellanox.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
CC:     David Miller <davem@davemloft.net>,
        Doug Ledford <dledford@redhat.com>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        Linux List Kernel Mailing <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>
Subject: Re: Annoying gcc / rdma / networking warnings
Thread-Topic: Annoying gcc / rdma / networking warnings
Thread-Index: AQHVCBnqId2qpywf80SpyVwZsFlKM6ZoQWSA
Date:   Mon, 13 May 2019 01:11:42 +0000
Message-ID: <20190513011131.GA7948@mellanox.com>
References: <CAHk-=whbuwm5FbkPSfftZ3oHMWw43ZNFXqvW1b6KFMEj5wBipA@mail.gmail.com>
In-Reply-To: <CAHk-=whbuwm5FbkPSfftZ3oHMWw43ZNFXqvW1b6KFMEj5wBipA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: YQBPR0101CA0058.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c00:1::35) To VI1PR05MB4141.eurprd05.prod.outlook.com
 (2603:10a6:803:4d::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jgg@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [156.34.49.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 110facee-c907-4fb2-cca5-08d6d73ff589
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:VI1PR05MB5311;
x-ms-traffictypediagnostic: VI1PR05MB5311:
x-microsoft-antispam-prvs: <VI1PR05MB53115C1ECF5A9732BDAFD473CF0F0@VI1PR05MB5311.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0036736630
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(366004)(396003)(39860400002)(346002)(376002)(189003)(199004)(71190400001)(6436002)(71200400001)(68736007)(316002)(6486002)(53936002)(81166006)(8936002)(6116002)(3846002)(66946007)(33656002)(8676002)(81156014)(99286004)(1076003)(2906002)(64756008)(229853002)(7736002)(73956011)(66556008)(66476007)(6512007)(102836004)(14454004)(305945005)(66446008)(54906003)(4326008)(386003)(26005)(446003)(14444005)(186003)(256004)(5660300002)(66066001)(6246003)(52116002)(476003)(2616005)(76176011)(11346002)(6506007)(478600001)(36756003)(53546011)(486006)(6916009)(25786009)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5311;H:VI1PR05MB4141.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: XnVFaJ7qMb8KG8czPQLYydk9xMnvjFrrKfrPx+PzDDCzW4D76xXEa1fsy41aSFLuf3NeVdfFeGV9GQTJtgip5J2XcZSXXXcFsphoYq9D7li83m3fm845gE/S9BGzXKL7gzD8qypluoN9scQmvoXBWc09439Ktn3Ip3dma5Tl4gnPVfdd7J3r+Vo04SxvkKo2kCcJTTpDMMcYkUX7jEAhLpj+10C7B+VBxocBPs4TKZrYr+tKnK+NtwxhS/g93RE/5no0lpkUQIINcvAQ+tIC6k/kY4qf3aBGBvK5PCdeOmKVPc5wYQ4/V01jUiD6omAjIu6JDFa5Z23b8xeUTygkliEwTwhvyWR46BONT0Ug+TSBD+Ih1nbPuBLclaJs9zZ5iC+Q1F/Jv4QQs4JVZlA/VTvJABkgeHFjvO31QiZ0cb4=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <033C054F7D32E54F9DBDAE6C64BA08E5@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 110facee-c907-4fb2-cca5-08d6d73ff589
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 May 2019 01:11:42.4956
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5311
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 11, 2019 at 12:52:06PM -0400, Linus Torvalds wrote:
> Jason and Davem,
>  with gcc-9, I'm now seeing a number of annoying warnings from the
> rdma layer. I think it depends on the exact gcc version, because I'm
> seeing them on my laptop but didn't see them on my desktop, probably
> due to updating at different times.

I can see them too on a latest FC30 compiler.. It is pretty amazing
FC30 shipped this month with a compiler that was just released 10 days
ago. :)

Also a lot of of 'taking address of a packed member' warnings in RDMA
code for structs that probably should be aligned(4) not packed. I'll
have to look at those more carefully this week and see what can be
done.

> So if you look at the types like gcc does, then the rdma layer really
> is passing a pointer to a 16-byte sockaddr, and then filling it with
> (much bigger) sockaddr_ip6 data.

It looks like gcc is assuming that since we started with the _sockaddr
union member that the memory is actually bounded to that specific
member. This doesn't seem unreasonable and matches a lot of uses of
unions. However I wonder how that sort of analysis is going to work in
the kernel, considering our container_of idiom breaks it in the same
way, but maybe that is special case'd..

So if we tell gcc the sockaddr memory is actually the whole union then
it becomes happy, see below.

> So David, arguably the kernel "struct sockaddr" is simply wrong, if it
> can't contain a "struct sockaddr_in6". No? Is extending it a huge
> problem for other users that don't need it (mainly stack, I assume..)?

We have sockaddr_storage for this, and arguably this code is just
over-optimizing to save a few bytes of stack vs sockaddr_storage..
=20
> Also equally arguably, the rdma code could just use a "struct
> sockaddr_in6 for this use and avoid the gcc issue, couldn't it?=20

I think the specific sockaddr types should only ever be used if we
*know* the sa_family is that type. If the sa_family is not known then
it should be sockaddr or sockaddr_storage. Otherwise things get very
confusing.

When using sockaddr_storage code always has the cast to sockaddr
anyhow, as it is not a union, so this jaunty cast is not out of place
in sockets code.

Below silences the warning, and the warning continues to work in other
cases, ie if I remove _sockaddr_in6 from the union I do get compile
warnings about out of bound references.

Jason

From 38a4d7e4644a13378c11381feb3936aa1faf9f58 Mon Sep 17 00:00:00 2001
From: Jason Gunthorpe <jgg@mellanox.com>
Date: Sun, 12 May 2019 21:57:57 -0300
Subject: [PATCH] RDMA: Directly cast the sockaddr union to sockaddr

gcc 9 now does allocation size tracking and thinks that passing the member
of a union and then accessing beyond that member's bounds is an overflow.

Instead of using the union member, use the entire union with a cast to
get to the sockaddr. gcc will now know that the memory extends the full
size of the union.

Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
---
 drivers/infiniband/core/addr.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/core/addr.c b/drivers/infiniband/core/addr.=
c
index 0dce94e3c49561..d0b04b0d309fa6 100644
--- a/drivers/infiniband/core/addr.c
+++ b/drivers/infiniband/core/addr.c
@@ -730,8 +730,8 @@ int roce_resolve_route_from_path(struct sa_path_rec *re=
c,
 	if (rec->roce.route_resolved)
 		return 0;
=20
-	rdma_gid2ip(&sgid._sockaddr, &rec->sgid);
-	rdma_gid2ip(&dgid._sockaddr, &rec->dgid);
+	rdma_gid2ip((struct sockaddr *)&sgid, &rec->sgid);
+	rdma_gid2ip((struct sockaddr *)&dgid, &rec->dgid);
=20
 	if (sgid._sockaddr.sa_family !=3D dgid._sockaddr.sa_family)
 		return -EINVAL;
@@ -742,7 +742,7 @@ int roce_resolve_route_from_path(struct sa_path_rec *re=
c,
 	dev_addr.net =3D &init_net;
 	dev_addr.sgid_attr =3D attr;
=20
-	ret =3D addr_resolve(&sgid._sockaddr, &dgid._sockaddr,
+	ret =3D addr_resolve((struct sockaddr *)&sgid, (struct sockaddr *)&dgid,
 			   &dev_addr, false, true, 0);
 	if (ret)
 		return ret;
@@ -814,22 +814,22 @@ int rdma_addr_find_l2_eth_by_grh(const union ib_gid *=
sgid,
 	struct rdma_dev_addr dev_addr;
 	struct resolve_cb_context ctx;
 	union {
-		struct sockaddr     _sockaddr;
 		struct sockaddr_in  _sockaddr_in;
 		struct sockaddr_in6 _sockaddr_in6;
 	} sgid_addr, dgid_addr;
 	int ret;
=20
-	rdma_gid2ip(&sgid_addr._sockaddr, sgid);
-	rdma_gid2ip(&dgid_addr._sockaddr, dgid);
+	rdma_gid2ip((struct sockaddr *)&sgid_addr, sgid);
+	rdma_gid2ip((struct sockaddr *)&dgid_addr, dgid);
=20
 	memset(&dev_addr, 0, sizeof(dev_addr));
 	dev_addr.net =3D &init_net;
 	dev_addr.sgid_attr =3D sgid_attr;
=20
 	init_completion(&ctx.comp);
-	ret =3D rdma_resolve_ip(&sgid_addr._sockaddr, &dgid_addr._sockaddr,
-			      &dev_addr, 1000, resolve_cb, true, &ctx);
+	ret =3D rdma_resolve_ip((struct sockaddr *)&sgid_addr,
+			      (struct sockaddr *)&dgid_addr, &dev_addr, 1000,
+			      resolve_cb, true, &ctx);
 	if (ret)
 		return ret;
=20
--=20
2.21.0
