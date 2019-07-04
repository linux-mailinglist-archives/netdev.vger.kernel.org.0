Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E41E5F423
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 09:52:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727236AbfGDHwF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 03:52:05 -0400
Received: from mail-eopbgr150081.outbound.protection.outlook.com ([40.107.15.81]:62883
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726087AbfGDHwE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Jul 2019 03:52:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uHdO7VBEkgOdtAvs6RwEc6xshBRio1RnZAVROBLGKiQ=;
 b=Jwr74QFIBgTNDKmxUQyhht08r4R0VUuCUPJMt6mJ4OAqiKldIGyQI9bsSy9GrR3BBBll7/lkZ6SbC9AtrLM0GdGgQ9zOuLstpzwzeYk5ZWHmrLICQETBB0lFOJSJGd7KgRxqfHO2oIcKtnIXt8aCvFsSmN/CWTf6KY3/vTFUdhM=
Received: from VI1PR05MB3152.eurprd05.prod.outlook.com (10.170.237.145) by
 VI1PR05MB5677.eurprd05.prod.outlook.com (20.178.121.19) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2052.18; Thu, 4 Jul 2019 07:51:59 +0000
Received: from VI1PR05MB3152.eurprd05.prod.outlook.com
 ([fe80::1044:d313:989:d54d]) by VI1PR05MB3152.eurprd05.prod.outlook.com
 ([fe80::1044:d313:989:d54d%5]) with mapi id 15.20.2032.019; Thu, 4 Jul 2019
 07:51:59 +0000
From:   Leon Romanovsky <leonro@mellanox.com>
To:     Sagi Grimberg <sagi@grimberg.me>
CC:     Idan Burstein <idanb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Tal Gilboa <talgi@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Yamin Friedman <yaminf@mellanox.com>,
        Max Gurtovoy <maxg@mellanox.com>
Subject: Re: [for-next V2 10/10] RDMA/core: Provide RDMA DIM support for ULPs
Thread-Topic: [for-next V2 10/10] RDMA/core: Provide RDMA DIM support for ULPs
Thread-Index: AQHVK5ipN3jilxV+8U2qs/jSBNzPpaas3rOAgACzgACACUbbgIAAEgGAgAJfrQCAANjGAA==
Date:   Thu, 4 Jul 2019 07:51:59 +0000
Message-ID: <20190704075156.GI4727@mtr-leonro.mtl.com>
References: <20190625205701.17849-1-saeedm@mellanox.com>
 <20190625205701.17849-11-saeedm@mellanox.com>
 <adb3687a-6db3-b1a4-cd32-8b4889550c81@grimberg.me>
 <AM5PR0501MB248327B260F97EF97CD5B80EC5E20@AM5PR0501MB2483.eurprd05.prod.outlook.com>
 <9d26c90c-8e0b-656f-341f-a67251549126@grimberg.me>
 <20190702064107.GS4727@mtr-leonro.mtl.com>
 <8d525d64-6da1-48c3-952d-8c6b0d541859@grimberg.me>
In-Reply-To: <8d525d64-6da1-48c3-952d-8c6b0d541859@grimberg.me>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM5PR0701CA0067.eurprd07.prod.outlook.com
 (2603:10a6:203:2::29) To VI1PR05MB3152.eurprd05.prod.outlook.com
 (2603:10a6:802:1b::17)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=leonro@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3b1d8d5d-0694-4ad9-5ce3-08d700547e54
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR05MB5677;
x-ms-traffictypediagnostic: VI1PR05MB5677:
x-microsoft-antispam-prvs: <VI1PR05MB56771EF3F012AF47A84C8542B0FA0@VI1PR05MB5677.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0088C92887
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(396003)(346002)(366004)(136003)(376002)(199004)(189003)(229853002)(316002)(6436002)(102836004)(6506007)(386003)(26005)(6916009)(53936002)(2906002)(478600001)(76176011)(54906003)(8676002)(6486002)(71190400001)(71200400001)(81166006)(81156014)(7736002)(305945005)(66066001)(14454004)(8936002)(1076003)(14444005)(256004)(86362001)(3846002)(68736007)(66946007)(73956011)(6116002)(25786009)(11346002)(5660300002)(476003)(486006)(4326008)(33656002)(9686003)(6512007)(107886003)(66446008)(99286004)(186003)(66476007)(66556008)(52116002)(446003)(6246003)(64756008);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5677;H:VI1PR05MB3152.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: ycY6Loh0o8/tI67lXsBxvadsseYfcRf/CItekpQzUM6V3D8t+lw8JozGMHri6iNZEXCME3rAIRZQYsKolBWWkL7winLMfYekGD+phx+JP3NaPySCP4hxFhT611s0KBwl8VKo2JI1qfeftUZGEQKutOoE30SvwL2fr4IedfuNUCHDuJghWOzjMchHZO3uBpbqpiT8mOY21CMTmv9M5vbkTOIfm8q/Qr31i5hKS6/bI+hrcEhPNTEcGF9QEiYcCGaiMN3o5LXTJiPMvJTqSLrAL5RxqNvsibNIO8XszY9PzKKZd4MaCiWl7YYHGIlzmDNrnzx5YxYi6Ga7xytE+Cfi+vk2MpZxNtseyahi1zUNdI+g3hQYR3CNk19ZhhGKU+T2VPSdfx5nFmYQ2faJD+XYQpE2KdEXl90FZcw01qGTeDI=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <B421801F2F9C31429E873489784ECECF@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b1d8d5d-0694-4ad9-5ce3-08d700547e54
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jul 2019 07:51:59.6583
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: leonro@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5677
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 03, 2019 at 11:56:04AM -0700, Sagi Grimberg wrote:
>
> > Hi Sagi,
> >
> > I'm not sharing your worries about bad out-of-the-box experience for a
> > number of reasons.
> >
> > First of all, this code is part of upstream kernel and will take time
> > till users actually start to use it as is and not as part of some distr=
o
> > backports or MOFED packages.
>
> True, but I am still saying that this feature is damaging sync IO which
> represents the majority of the users. It might not be an extreme impact
> but it is still a degradation (from a very limited testing I did this
> morning I'm seeing a consistent 5%-10% latency increase for low QD
> workloads which is consistent with what Yamin reported AFAIR).
>
> But having said that, the call is for you guys to make as this is a
> Mellanox device. I absolutely think that this is useful (as I said
> before), I just don't think its necessarily a good idea to opt it by
> default given that only a limited set of users would take full advantage
> of it while the rest would see a negative impact (even if its 10%).
>
> I don't have  a hard objection here, just wanted to give you my
> opinion on this because mlx5 is an important driver for rdma
> users.

Your opinion is very valuable for us and we started internal thread to
challenge this "enable by default", it just takes time and I prefer to
enable this code to get test coverage as wide as possible.

>
> > Second, Yamin did extensive testing and worked very close with Or G.
> > and I have very high confident in the results of their team work.
>
> Has anyone tested other RDMA ulps? NFS/RDMA or SRP/iSER?
>
> Would be interesting to understand how other subsystems with different
> characteristics behave with this.

Me too, and I'll revert this default if needed.

Thanks

