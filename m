Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A1EB4B100
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 07:00:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725899AbfFSFAo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 01:00:44 -0400
Received: from mail-eopbgr80049.outbound.protection.outlook.com ([40.107.8.49]:32262
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725562AbfFSFAo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Jun 2019 01:00:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b9YjhMAYIcTJnEM698GguJPHumujD5wTFty0p5BwHGQ=;
 b=VZD1n74SVpReRfMkpDNT1ZH1pfH+rWnrGnHZ5P6WoHcY60mRRwDKt8lXA7C+WvuzotUUcAGr+oy++cKoYHeT628XslGAiUemL3PpNJHP0rJxkLZC+mf/AFqnT/Wc0B9hoLolig0BjiIpfVIjjHF4xQdX3b799qnGL1WFRRJv+sk=
Received: from AM4PR05MB3137.eurprd05.prod.outlook.com (10.171.186.14) by
 AM4PR05MB3426.eurprd05.prod.outlook.com (10.171.188.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.11; Wed, 19 Jun 2019 05:00:39 +0000
Received: from AM4PR05MB3137.eurprd05.prod.outlook.com
 ([fe80::bc5a:ba8b:1a69:91b6]) by AM4PR05MB3137.eurprd05.prod.outlook.com
 ([fe80::bc5a:ba8b:1a69:91b6%6]) with mapi id 15.20.1987.014; Wed, 19 Jun 2019
 05:00:39 +0000
From:   Leon Romanovsky <leonro@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>
CC:     Parav Pandit <parav@mellanox.com>, Mark Bloch <markb@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Bodong Wang <bodong@mellanox.com>
Subject: Re: [PATCH mlx5-next 14/15] {IB, net}/mlx5: E-Switch, Use index of
 rep for vport to IB port mapping
Thread-Topic: [PATCH mlx5-next 14/15] {IB, net}/mlx5: E-Switch, Use index of
 rep for vport to IB port mapping
Thread-Index: AQHVJUIqpjj0/zKL/kquOc3ZH7UhNaahOoGAgAABfQCAAH/3gIAAsWMA
Date:   Wed, 19 Jun 2019 05:00:39 +0000
Message-ID: <20190619050036.GB11611@mtr-leonro.mtl.com>
References: <20190617192247.25107-1-saeedm@mellanox.com>
 <20190617192247.25107-15-saeedm@mellanox.com>
 <20190618104220.GH4690@mtr-leonro.mtl.com>
 <AM0PR05MB4866DF63BB7D80483630F0A9D1EA0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <7b098b42a51e5b96eca99c024719eebafa775f7a.camel@mellanox.com>
In-Reply-To: <7b098b42a51e5b96eca99c024719eebafa775f7a.camel@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM6PR0402CA0030.eurprd04.prod.outlook.com
 (2603:10a6:209::43) To AM4PR05MB3137.eurprd05.prod.outlook.com
 (2603:10a6:205:3::14)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=leonro@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [37.142.3.125]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 27765db3-d117-4f21-588b-08d6f4731272
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM4PR05MB3426;
x-ms-traffictypediagnostic: AM4PR05MB3426:
x-microsoft-antispam-prvs: <AM4PR05MB3426ECF78705D7B9F2F7C449B0E50@AM4PR05MB3426.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0073BFEF03
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(376002)(39860400002)(396003)(136003)(366004)(189003)(199004)(13464003)(14454004)(316002)(2906002)(6436002)(52116002)(53936002)(6246003)(9686003)(6506007)(386003)(256004)(76176011)(305945005)(6486002)(107886003)(66556008)(6636002)(64756008)(1076003)(66946007)(73956011)(86362001)(5660300002)(71190400001)(7736002)(71200400001)(6512007)(99286004)(8676002)(25786009)(102836004)(54906003)(68736007)(6116002)(450100002)(3846002)(53546011)(4326008)(66476007)(11346002)(66446008)(26005)(8936002)(33656002)(446003)(186003)(486006)(66066001)(476003)(229853002)(81166006)(81156014)(478600001)(6862004);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR05MB3426;H:AM4PR05MB3137.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: MlU8EHdEKvKsroMa5b2Z9KIoa1CARen/5Xsrn6FEH8EQCsakxwyrFzWC2CwBid5S+bnu/dqLv4yQwKi/0QvbOghyId/b3FoSnnTtJcWxpw/LXHnwarrUI7UJpOOOtZXfCXNpzdUuSfWCW2SRk19M+3RbiGufQGIm07cxpNwqWRxKh8ebr5njaHx/nfAqw1Tb/WNmNTSc2O85w5UIYD2jeTI7DsB+UFwvHHyhNCTeDJaixLC/RMOTJ4DBNf4h25FPXdm7Zrn1zSUzWyegHV6Tc5pZYz0NomECleeVUHqBeEM//bKt4shLT/RJNZXfvmL5qQfgmyBZelWyYthrzGn18iz+yGK087kdVpvT8M3p7M8QDBFICnLEFnTFSh2P7K7vhzuWMWPJmW+UKGEfpPMgiTiLG6irsIm8+2kMYRcfer0=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <EE5DDFCE7F16DE4F95A894DE8B61A130@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 27765db3-d117-4f21-588b-08d6f4731272
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jun 2019 05:00:39.4409
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: leonro@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR05MB3426
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 18, 2019 at 06:25:46PM +0000, Saeed Mahameed wrote:
> On Tue, 2019-06-18 at 10:47 +0000, Parav Pandit wrote:
> > Hi Leon,
> >
> > > -----Original Message-----
> > > From: Leon Romanovsky
> > > Sent: Tuesday, June 18, 2019 4:12 PM
> > > To: Saeed Mahameed <saeedm@mellanox.com>
> > > Cc: netdev@vger.kernel.org; linux-rdma@vger.kernel.org; Bodong Wang
> > > <bodong@mellanox.com>; Parav Pandit <parav@mellanox.com>; Mark
> > > Bloch
> > > <markb@mellanox.com>
> > > Subject: Re: [PATCH mlx5-next 14/15] {IB, net}/mlx5: E-Switch, Use
> > > index of rep
> > > for vport to IB port mapping
> > >
> > > On Mon, Jun 17, 2019 at 07:23:37PM +0000, Saeed Mahameed wrote:
> > > > From: Bodong Wang <bodong@mellanox.com>
> > > >
> > > > In the single IB device mode, the mapping between vport number
> > > > and rep
> > > > relies on a counter. However for dynamic vport allocation, it is
> > > > desired to keep consistent map of eswitch vport and IB port.
> > > >
> > > > Hence, simplify code to remove the free running counter and
> > > > instead
> > > > use the available vport index during load/unload sequence from
> > > > the
> > > > eswitch.
> > > >
> > > > Signed-off-by: Bodong Wang <bodong@mellanox.com>
> > > > Suggested-by: Parav Pandit <parav@mellanox.com>
> > > > Reviewed-by: Parav Pandit <parav@mellanox.com>
> > >
> > > We are not adding multiple "*-by" for same user, please choose one.
> > >
> > Suggested-by was added by Bodong during our discussion. Later on when
> > I did gerrit +1, RB tag got added.
> >
>
> Is there a rule against having multiple "*-by" ? i don't think so  and
> there shouldn't be, users need to get the exact amount of recognition
> as the amount of work they put into this patch, if they reviewed and
> tested a patch they deserve two tags ..

Not everything in the world has and needs rules, sometimes common sense
is enough. It goes without saying that during internal review process,
developer suggested something. Recognition comes in many ways in the
kernel but definitely not by number of tags with specific developer
name on it, especially if this developer comes from same company
as patch author.

If we extend your claim, both you and me should add this type of
signature block for almost every patch which we submit:

Reviewed-by: ....
Tested-by:  ....
Suggested-by: ...
Signed-by: ...

Thanks

>
>
