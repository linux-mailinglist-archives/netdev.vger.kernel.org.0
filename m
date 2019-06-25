Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2286B558AC
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 22:23:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726955AbfFYUXb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 16:23:31 -0400
Received: from mail-eopbgr150089.outbound.protection.outlook.com ([40.107.15.89]:14901
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726447AbfFYUXa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Jun 2019 16:23:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EZlKUCWlkassRC2e4xFMg023+Pcx9HbYR4AxRtg6uSM=;
 b=ZAdA2q6+L/zRfbSnEscMPrzkgOEfgAPr9HdbmEMgqlNOBpY8s0ojQGn5JA7tAL/wy/s0aKgNv0e5qylvNBjeCtnkMvV9MSr/1Kuqr9ZIJIUNMGYNxiiMMDJYHDbM0Gm7tI4veI5P2WzhI20PZH5wt2XNmrozCGVBNdeAGEsx7FE=
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com (10.171.182.144) by
 VI1PR05MB6286.eurprd05.prod.outlook.com (20.179.24.86) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Tue, 25 Jun 2019 20:23:25 +0000
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::f5d8:df9:731:682e]) by VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::f5d8:df9:731:682e%5]) with mapi id 15.20.2008.014; Tue, 25 Jun 2019
 20:23:25 +0000
From:   Jason Gunthorpe <jgg@mellanox.com>
To:     Yishai Hadas <yishaih@dev.mellanox.co.il>
CC:     Leon Romanovsky <leon@kernel.org>,
        Doug Ledford <dledford@redhat.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Yishai Hadas <yishaih@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH rdma-next v1 11/12] IB/mlx5: Implement DEVX dispatching
 event
Thread-Topic: [PATCH rdma-next v1 11/12] IB/mlx5: Implement DEVX dispatching
 event
Thread-Index: AQHVJfmOhAl6cjxbGkeHYVIPFHC63aaqvcMAgABRjgCAABOuAIABWUuAgABfawA=
Date:   Tue, 25 Jun 2019 20:23:24 +0000
Message-ID: <20190625202320.GJ3607@mellanox.com>
References: <20190618171540.11729-1-leon@kernel.org>
 <20190618171540.11729-12-leon@kernel.org>
 <20190624120338.GD5479@mellanox.com>
 <3a2e53f8-e7dd-3e01-c7c7-99d41f711d87@dev.mellanox.co.il>
 <20190624180558.GL7418@mellanox.com>
 <a2380ea6-4542-c72c-96f7-e68786847ccc@dev.mellanox.co.il>
In-Reply-To: <a2380ea6-4542-c72c-96f7-e68786847ccc@dev.mellanox.co.il>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM4PR0701CA0040.eurprd07.prod.outlook.com
 (2603:10a6:200:42::50) To VI1PR05MB4141.eurprd05.prod.outlook.com
 (2603:10a6:803:4d::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jgg@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [66.187.232.66]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 44be5860-3d99-4cb6-00c4-08d6f9aaf96b
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR05MB6286;
x-ms-traffictypediagnostic: VI1PR05MB6286:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <VI1PR05MB628634AE2ED0ED56148C3D62CFE30@VI1PR05MB6286.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0079056367
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(376002)(39860400002)(366004)(396003)(346002)(189003)(199004)(14454004)(229853002)(99286004)(7736002)(305945005)(966005)(52116002)(86362001)(386003)(6512007)(26005)(6486002)(3846002)(6116002)(6436002)(8676002)(8936002)(316002)(71190400001)(53936002)(54906003)(6246003)(71200400001)(33656002)(4326008)(73956011)(81156014)(64756008)(25786009)(36756003)(66476007)(6306002)(66446008)(66556008)(68736007)(76176011)(66946007)(6862004)(81166006)(11346002)(476003)(2616005)(486006)(2906002)(66066001)(5660300002)(446003)(186003)(102836004)(478600001)(1076003)(256004)(6506007);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6286;H:VI1PR05MB4141.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 58IfWk/pGS39okTNyhpi6dBqB+vwZQzEmsHRFzBuHgL4vhP1yqEHH5tffj8uFmtl1VlagmguetnKSk6mgb6msxsLRIwnewBroyPggU+hY+55ALEh6lixenmVPktYz5GuYf1YYBiFBF694rPlHZ3/xJUqP0tX3Zo0gPE57e3JjK/aH/GG1AhfosFL3WGKUHX1RvtePxmbWTdpNvQx0za2rE+KaLyD7HwNQd+oi7GoTvRWgJFAPXACU10tVgZr31TuVM6Lb8B4ZEtH+kHLHOiJZcGxMP4Qs/rTCw12LfwWxXXajuB81gMediR00W0hKIIijvocnnElSi+/l3jjkuowlcxxzx1WGRIHvyhPQhYoD28ZGK8jCMJAt2ApztgDG6LxhK5yYa1P+wRlmTTYNcDdFfLVWcihUA4hCEyNkvdSh2U=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <40E9C00191753E49BCF30A92BCDAD487@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 44be5860-3d99-4cb6-00c4-08d6f9aaf96b
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jun 2019 20:23:25.0046
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jgg@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6286
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 25, 2019 at 05:41:49PM +0300, Yishai Hadas wrote:
> > > > Why don't we return EIO as soon as is-destroyed happens? What is th=
e
> > > > point of flushing out the accumulated events?
> > >=20
> > > It follows the above uverb code/logic that returns existing events ev=
en in
> > > that case, also the async command events in this file follows that lo=
gic, I
> > > suggest to stay consistent.
> >=20
> > Don't follow broken uverbs stuff...
>=20
> May it be that there is some event that we still want to deliver post
> unbind/hot-unplug ? for example IB_EVENT_DEVICE_FATAL in uverbs and other=
s
> from the driver code.

EIO is DEVICE_FATAL.

> Not sure that we want to change this logic.
> What do you think ?

I think this code should exit immediately with EIO if the device is
disassociated.

> > > > Maybe the event should be re-added on error? Tricky.
> > >=20
> > > What will happen if another copy_to_user may then fail again (loop ?)=
 ...
> > > not sure that we want to get into this tricky handling ...
> > >=20
> > > As of above, It follows the logic from uverbs at that area.
> > > https://elixir.bootlin.com/linux/latest/source/drivers/infiniband/cor=
e/uverbs_main.c#L267
> >=20
> > again it is wrong...
> >=20
> > There is no loop if you just stick the item back on the head of the
> > list and exit, which is probably the right thing to do..
> >=20
>=20
> What if copy_to_user() will fail again just later on ? we might end-up wi=
th
> loop of read(s) that always find an event as it was put back.

That is clearly an application bug and is not the concern of the
kernel..

> I suggest to leave this flow as it's now, at least for this series
> submission.
>=20
> Agree ?

I don't think you can actually fix this, so maybe we have to leave
it. But add a comment explaining=20

Jason
