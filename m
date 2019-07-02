Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 041D15C96F
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 08:41:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726150AbfGBGlP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 02:41:15 -0400
Received: from mail-eopbgr50061.outbound.protection.outlook.com ([40.107.5.61]:34784
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725775AbfGBGlO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Jul 2019 02:41:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q51U10N1efXcL4OLR9vZo1wZcXZpRk5PaQBst2BqxG8=;
 b=iLcIeHJ+4XsZj1qkuw6LLeSYazRJk1zM5v+5afmLg4ocwhzxWCTXbiHdOa9DUXgOzJdcU50P/fqUM57E9LZsihsIzaN9rOQ+BGuqdUkAnnPEtrPcF0gXJWDwKW0BMYcOHPJL87dLiydSaxnvpfGcZvlAZrW4OIihdTEsHTdoAWs=
Received: from AM4PR05MB3137.eurprd05.prod.outlook.com (10.171.186.14) by
 AM4PR05MB3267.eurprd05.prod.outlook.com (10.171.188.28) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2032.20; Tue, 2 Jul 2019 06:41:10 +0000
Received: from AM4PR05MB3137.eurprd05.prod.outlook.com
 ([fe80::bc5a:ba8b:1a69:91b6]) by AM4PR05MB3137.eurprd05.prod.outlook.com
 ([fe80::bc5a:ba8b:1a69:91b6%6]) with mapi id 15.20.2032.019; Tue, 2 Jul 2019
 06:41:10 +0000
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
Thread-Index: AQHVK5ipN3jilxV+8U2qs/jSBNzPpaas3rOAgACzgACACUbbgIAAEgGA
Date:   Tue, 2 Jul 2019 06:41:09 +0000
Message-ID: <20190702064107.GS4727@mtr-leonro.mtl.com>
References: <20190625205701.17849-1-saeedm@mellanox.com>
 <20190625205701.17849-11-saeedm@mellanox.com>
 <adb3687a-6db3-b1a4-cd32-8b4889550c81@grimberg.me>
 <AM5PR0501MB248327B260F97EF97CD5B80EC5E20@AM5PR0501MB2483.eurprd05.prod.outlook.com>
 <9d26c90c-8e0b-656f-341f-a67251549126@grimberg.me>
In-Reply-To: <9d26c90c-8e0b-656f-341f-a67251549126@grimberg.me>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM6P195CA0051.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:209:87::28) To AM4PR05MB3137.eurprd05.prod.outlook.com
 (2603:10a6:205:3::14)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=leonro@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [37.142.3.125]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fe5d869e-9ebc-488f-5f65-08d6feb84489
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM4PR05MB3267;
x-ms-traffictypediagnostic: AM4PR05MB3267:
x-microsoft-antispam-prvs: <AM4PR05MB32672840F8D4A1E400AF67BAB0F80@AM4PR05MB3267.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 008663486A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(396003)(136003)(39860400002)(376002)(366004)(189003)(199004)(6512007)(316002)(6246003)(9686003)(486006)(71190400001)(33656002)(476003)(14454004)(71200400001)(107886003)(76176011)(446003)(52116002)(54906003)(4326008)(53936002)(99286004)(14444005)(256004)(26005)(5660300002)(11346002)(186003)(68736007)(305945005)(25786009)(6506007)(81156014)(2906002)(66446008)(64756008)(1076003)(73956011)(66556008)(66476007)(6916009)(386003)(8676002)(81166006)(6436002)(229853002)(6486002)(478600001)(8936002)(66946007)(102836004)(86362001)(3846002)(66066001)(7736002)(6116002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR05MB3267;H:AM4PR05MB3137.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 8lhCUANWc/d33Xukf18ceduC+WIBrDWTxQnRcZvt6WdYFBzi9Zy4T0jFxSpwJiM9bGfC6L4U0rsFv9BxUA4yz7PVzpflceKotIaaL2kPoeuZ7H5YeB/LAAfXpa6rWqUHno4Db77E2QL/AwabzGJM0fVx9ML35tDlWYHqS2Cj4aoasYO527IL0XyGmzT69J4fO9iIrHF3PeAFIXUzXBRANDSZWUqet8+iCUfiHG/ujMb21I1B4++OdKa7+J607ik+aXOe7fl3busUUZYn4Y1jYeNgNHgx85KdiE+1ckKntUhsx7lH3h2VGjxoSaGEl89mbdQtLmZnqeQZOcQx/O9hrt0+84qc+gmHtB0yAjHZ3rwTi6iPYDYmffwryGe6Q/helm8VcnlIFax7I8XZFNGPfTASi6GYNvhu+k7p/+H55cU=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <99AC63E018BA7C40B5DC3552DAB7F0E2@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe5d869e-9ebc-488f-5f65-08d6feb84489
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Jul 2019 06:41:10.0063
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: leonro@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR05MB3267
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 01, 2019 at 10:36:41PM -0700, Sagi Grimberg wrote:
> Hey Idan,
>
> > " Please don't. This is a bad choice to opt it in by default."
> >
> > I disagree here. I'd prefer Linux to have good out of the box experienc=
e (e.g. reach 100G in 4K NVMeOF on Intel servers) with the default paramete=
rs. Especially since Yamin have shown it is beneficial / not hurting in ter=
ms of performance for variety of use cases. The whole concept of DIM is tha=
t it adapts to the workload requirements in terms of bandwidth and latency.
>
> Well, its a Mellanox device driver after all.
>
> But do note that by far, the vast majority of users are not saturating
> 100G of 4K I/O. The absolute vast majority of users are primarily
> sensitive to synchronous QD=3D1 I/O latency, and when the workload
> is much more dynamic than the synthetic 100%/50%/0% read mix.
>
> As much as I'm a fan (IIRC I was the one giving a first pass at this),
> the dim default opt-in is not only not beneficial, but potentially
> harmful to the majority of users out-of-the-box experience.
>
> Given that this is a fresh code with almost no exposure, and that was
> not tested outside of Yamin running limited performance testing, I think
> it would be a mistake to add it as a default opt-in, that can come as an
> incremental stage.
>
> Obviously, I cannot tell what Mellanox should/shouldn't do in its own
> device driver of course, but I just wanted to emphasize that I think
> this is a mistake.

Hi Sagi,

I'm not sharing your worries about bad out-of-the-box experience for a
number of reasons.

First of all, this code is part of upstream kernel and will take time
till users actually start to use it as is and not as part of some distro
backports or MOFED packages.

Second, Yamin did extensive testing and worked very close with Or G.
and I have very high confident in the results of their team work.

Third (outcome of first), actually the opposite is true, the setting
this option as a default will give us more time to fix/adjust code if
needed, before users will see any potential degradation.

>
> > Moreover, net-dim is enabled by default, I don't see why RDMA is differ=
ent.
>
> Very different animals.

Yes and no, the logic behind is the same and both solutions have same
constrains of throughput vs. latency.

Thanks
