Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8369864704
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 15:32:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727564AbfGJNcO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 09:32:14 -0400
Received: from mail-eopbgr80077.outbound.protection.outlook.com ([40.107.8.77]:24163
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725994AbfGJNcO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Jul 2019 09:32:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PZqaA00DuXqLyHuEIN2wKCyH0NzZTFcJL8gA8kxR43iSyx0NPZ87eGR9gbrxRaYsTlEd74sO7tFZkh+wCxWLJhReegQ2l5ZEVbJOXiNpb5y3oHxzqd8uTCGH5Htoi2rXxRYA8CvpBZiuYqoa1y/oeVnuodTytMoToJPoHl58ED6A2noPqbZlPMiK8nsPN/Kv/sfkqtkss1qtz9LJe0b366Fmu57Jlfyu3kPJyyNQIdBfInSqUUCBfrkSxkx6sadxnq5L6gjuyQYO6KqFlSMt4GNb5T1z3z0O+g8We7baHrm2weQehmGRbir9MU5M3onvjRTGhvfzQt3TKw+Zj86T3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vbALyvdhKeWZcslykN6VLOfnnvlyToGcy5+MiXsY7ME=;
 b=g45kYl80CVWdeRQD0Kq7QvEogPNDHrZICJ9nkiNyxjc2j/IWVKFmaUxcJkw9c73E2cxsgHZer+keoUN753r1CGSCF+9n1f9ShzKuVlIoxcRjv9Az4zvsNwNh9ShfnRZVqoHWDrvcdavzOc/y3MQN3WaBB0xwG4kIqUA4QG4H/IruI8mU2stI1P8SKZMszCWE1Qw40K15sopyqdobdQka19B2xHYPTRZRsmPY3U9/2Dw4vMF9zYJoeiKY92MOsjeGTw3ZwETiugCYGcYGmdJggdqjVplHmyaMsZA8ZGxwtKkjJTWEO4HhP39VK98OYD8cPlRG9qRAq2CBWLInU1GAUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vbALyvdhKeWZcslykN6VLOfnnvlyToGcy5+MiXsY7ME=;
 b=fUX2PtDzg1P6h6DqpKNDofFxUcX7+Grp7QfGzCufqPaGnGb3kl5miEQPPM5I+R/94R7Q9BaE+X16ayTvIe4N2hyYgiSxhtEucPy1o2Kl7veFRBw+7FTgEfP9zSSd5cPK6vdcMeD3C1L0qflHvqAcgavcp3oB086VETQ6s8LZNYM=
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com (10.171.182.144) by
 VI1PR05MB6461.eurprd05.prod.outlook.com (20.179.24.213) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2073.10; Wed, 10 Jul 2019 13:32:10 +0000
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::f5d8:df9:731:682e]) by VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::f5d8:df9:731:682e%5]) with mapi id 15.20.2052.020; Wed, 10 Jul 2019
 13:32:10 +0000
From:   Jason Gunthorpe <jgg@mellanox.com>
To:     Henry Orosco <henry.orosco@intel.com>
CC:     "Saleem, Shiraz" <shiraz.saleem@intel.com>,
        Leon Romanovsky <leon@kernel.org>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "dledford@redhat.com" <dledford@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Ismail, Mustafa" <mustafa.ismail@intel.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "poswald@suse.com" <poswald@suse.com>,
        "Ertman, David M" <david.m.ertman@intel.com>
Subject: Re: [rdma 14/16] RDMA/irdma: Add ABI definitions
Thread-Topic: [rdma 14/16] RDMA/irdma: Add ABI definitions
Thread-Index: AQHVMg3xm+d1qAoGS06soOrLwK8W6aa6E1uAgABOAoCAAdu/gIAACaUAgAGBJgCAAwKnAIACAtKAgAEWPoA=
Date:   Wed, 10 Jul 2019 13:32:10 +0000
Message-ID: <20190710133205.GA2887@mellanox.com>
References: <20190704021259.15489-1-jeffrey.t.kirsher@intel.com>
 <20190704021259.15489-16-jeffrey.t.kirsher@intel.com>
 <20190704074021.GH4727@mtr-leonro.mtl.com>
 <20190704121933.GD3401@mellanox.com>
 <9DD61F30A802C4429A01CA4200E302A7A684DAAA@fmsmsx124.amr.corp.intel.com>
 <20190705171650.GI31525@mellanox.com>
 <9DD61F30A802C4429A01CA4200E302A7A68512AA@fmsmsx124.amr.corp.intel.com>
 <20190708141336.GF23966@mellanox.com>
 <20190709205613.GA7440@horosco-MOBL2.amr.corp.intel.com>
In-Reply-To: <20190709205613.GA7440@horosco-MOBL2.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BL0PR0102CA0063.prod.exchangelabs.com
 (2603:10b6:208:25::40) To VI1PR05MB4141.eurprd05.prod.outlook.com
 (2603:10a6:803:4d::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jgg@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [156.34.55.100]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 76af7bd5-a57b-4a6a-0e36-08d7053b0284
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:VI1PR05MB6461;
x-ms-traffictypediagnostic: VI1PR05MB6461:
x-microsoft-antispam-prvs: <VI1PR05MB646123F98D6D62CADEADDBA0CFF00@VI1PR05MB6461.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 0094E3478A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(366004)(39860400002)(346002)(136003)(396003)(189003)(199004)(7416002)(66066001)(6436002)(6116002)(3846002)(14454004)(6486002)(6246003)(66446008)(7736002)(53936002)(6512007)(66476007)(2906002)(1076003)(64756008)(66556008)(305945005)(478600001)(66946007)(86362001)(71200400001)(71190400001)(5660300002)(256004)(11346002)(99286004)(8936002)(446003)(316002)(54906003)(229853002)(102836004)(386003)(6506007)(76176011)(36756003)(52116002)(6916009)(81156014)(81166006)(8676002)(68736007)(25786009)(2616005)(486006)(476003)(26005)(186003)(33656002)(4326008);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6461;H:VI1PR05MB4141.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Jhcx69Pi7SxMtaPIiAeSGb1CMLsMfO0RnSK+NUAi3B+B2rQDl7/6Ag42ixnkGaR6rG/zimhm1fF9dPHp3quFuozRhUc0Uyg+kPhDbSGB2JxcDqHDX9LKtisQMdQ6NBoG+rDu4NKaQXLmdDF4h8fOfSU0jVRd0QxS56QfINo/lcg5owOdZ9JhcFNQfzc6/ax7y2iW/e3tGGfdd8FZzAEba/ha75z0rEc9XmlbXACEdo1Jj42+cgXaji1ED9BOnvYWIhi7bIhOoEHdCCFAz3YM9A1f0wecWzE5L9YARoA/996sLKcHcflAjzrERRvQqn+r0dDrNdUbwkd8RW1NIvKjyISeyQxogycHpH4NNmduAtjyTYCucJvql+6DHgvptjLDx/tisjJ1pY/cREc0Kx67Bobh0VvEvPQhs3yUm1sp1L0=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <08607504A3714C4B93343223BA2C55CD@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 76af7bd5-a57b-4a6a-0e36-08d7053b0284
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jul 2019 13:32:10.4419
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jgg@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6461
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 09, 2019 at 03:56:13PM -0500, Henry Orosco wrote:
> On Mon, Jul 08, 2019 at 02:13:39PM +0000, Jason Gunthorpe wrote:
> > On Sat, Jul 06, 2019 at 04:15:20PM +0000, Saleem, Shiraz wrote:
> > > > Subject: Re: [rdma 14/16] RDMA/irdma: Add ABI definitions
> > > >=20
> > > > On Fri, Jul 05, 2019 at 04:42:19PM +0000, Saleem, Shiraz wrote:
> > > > > > Subject: Re: [rdma 14/16] RDMA/irdma: Add ABI definitions
> > > > > >
> > > > > > On Thu, Jul 04, 2019 at 10:40:21AM +0300, Leon Romanovsky wrote=
:
> > > > > > > On Wed, Jul 03, 2019 at 07:12:57PM -0700, Jeff Kirsher wrote:
> > > > > > > > From: Mustafa Ismail <mustafa.ismail@intel.com>
> > > > > > > >
> > > > > > > > Add ABI definitions for irdma.
> > > > > > > >
> > > > > > > > Signed-off-by: Mustafa Ismail <mustafa.ismail@intel.com>
> > > > > > > > Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
> > > > > > > > include/uapi/rdma/irdma-abi.h | 130
> > > > > > > > ++++++++++++++++++++++++++++++++++
> > > > > > > >  1 file changed, 130 insertions(+)  create mode 100644
> > > > > > > > include/uapi/rdma/irdma-abi.h
> > > > > > > >
> > > > > > > > diff --git a/include/uapi/rdma/irdma-abi.h
> > > > > > > > b/include/uapi/rdma/irdma-abi.h new file mode 100644 index
> > > > > > > > 000000000000..bdfbda4c829e
> > > > > > > > +++ b/include/uapi/rdma/irdma-abi.h
> > > > > > > > @@ -0,0 +1,130 @@
> > > > > > > > +/* SPDX-License-Identifier: GPL-2.0 OR BSD-2-Clause */
> > > > > > > > +/* Copyright (c) 2006 - 2019 Intel Corporation.  All right=
s reserved.
> > > > > > > > + * Copyright (c) 2005 Topspin Communications.  All rights =
reserved.
> > > > > > > > + * Copyright (c) 2005 Cisco Systems.  All rights reserved.
> > > > > > > > + * Copyright (c) 2005 Open Grid Computing, Inc. All rights=
 reserved.
> > > > > > > > + */
> > > > > > > > +
> > > > > > > > +#ifndef IRDMA_ABI_H
> > > > > > > > +#define IRDMA_ABI_H
> > > > > > > > +
> > > > > > > > +#include <linux/types.h>
> > > > > > > > +
> > > > > > > > +/* irdma must support legacy GEN_1 i40iw kernel
> > > > > > > > + * and user-space whose last ABI ver is 5  */ #define
> > > > > > > > +IRDMA_ABI_VER
> > > > > > > > +6
> > > > > > >
> > > > > > > Can you please elaborate about it more?
> > > > > > > There is no irdma code in RDMA yet, so it makes me wonder why=
 new
> > > > > > > define shouldn't start from 1.
> > > > > >
> > > > > > It is because they are ABI compatible with the current user spa=
ce,
> > > > > > which raises the question why we even have this confusing heade=
r file..
> > > > >
> > > > > It is because we need to support current providers/i40iw user-spa=
ce.
> > > > > Our user-space patch series will introduce a new provider (irdma)
> > > > > whose ABI ver. is also 6 (capable of supporting X722 and which wi=
ll
> > > > > work with i40iw driver on older kernels) and removes providers/i4=
0iw from rdma-
> > > > core.
> > > >=20
> > > > Why on earth would we do that?
> > > >=20
> > > A unified library providers/irdma to go in hand with the driver irdma=
 and uses the ABI header.
> > > It can support the new network device e810 and existing x722 iWARP de=
vice. It obsoletes
> > > providers/i40iw and extends its ABI. So why keep providers/i40iw arou=
nd in rdma-core?
> >=20
> > Why rewrite a perfectly good userspace that is compatible with the
> > future and past kernels?
> >=20
> > Is there something so wrong with the userspace provider to need this?
> >
>=20
> Yes, the issue is that providers/i40iw was never designed to work with a =
unified driver
> which supports multiple hardware generations.

But Shiraz said it works fine with the new kernel driver.. So what is
actually the problem?

Jason
