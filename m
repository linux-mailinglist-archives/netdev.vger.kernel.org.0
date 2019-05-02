Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6540612384
	for <lists+netdev@lfdr.de>; Thu,  2 May 2019 22:39:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726452AbfEBUjK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 May 2019 16:39:10 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:57050 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726201AbfEBUjK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 May 2019 16:39:10 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x42KZfWW031127;
        Thu, 2 May 2019 13:39:03 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=b1zJawd/2Y7DeWP96lCAUc7tUxynOE7QMXQfDieHFNM=;
 b=CLQ29pfAcPYNib0y6RzZ2Vi9iAhuQEUvMnpYTshs6RcwDP06xtpafYPb274z+mQPSfjc
 rFPwBCICyVFkQwFM+MYljlGBzFjviBAFycaUhKdtVXHzNFe3uQnVGIkisjQrNLkRUz0n
 KJOhlk/7Rmzls25RrJiCKrJw0AL2ULPPKZqPsrfRfbxGJc0NpqKACptfRPD+/TzeUCGe
 XabwckuUyoZ5Aieq2S841kxpHavQ2MY5WNjkZxXK2Z7MyFURJCGwBXYfR1B8zxHKrisB
 K51Sqfm0lyn3FCyMW7k6JEHhkcgpo6y7nrKRZxKpVYdlcmE8U8J5WRa8Y4jG4cnFCfjI xg== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 2s7k3bc17x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 02 May 2019 13:39:03 -0700
Received: from SC-EXCH02.marvell.com (10.93.176.82) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Thu, 2 May
 2019 13:39:02 -0700
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (104.47.44.54) by
 SC-EXCH02.marvell.com (10.93.176.82) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Thu, 2 May 2019 13:39:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b1zJawd/2Y7DeWP96lCAUc7tUxynOE7QMXQfDieHFNM=;
 b=rns+zZWHETrzKY0/zokq/OvOl9pvz/duU4ffB37tQjmIQ1SU0mSrirAZnw65fsIxYZSd0plN2adJBHPyGcV4h9S587xLbQXTqyP9OfTZuVGcO+YfI5CXE2sHJ3kYE20T48UVe3XdwuAcaK2AjpmxIi9ln2O/eq63KNAgowXgarE=
Received: from BLUPR18MB0130.namprd18.prod.outlook.com (10.160.188.26) by
 BLUPR18MB0130.namprd18.prod.outlook.com (10.160.188.26) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1835.18; Thu, 2 May 2019 20:38:57 +0000
Received: from BLUPR18MB0130.namprd18.prod.outlook.com
 ([fe80::d998:a162:bdee:3ed3]) by BLUPR18MB0130.namprd18.prod.outlook.com
 ([fe80::d998:a162:bdee:3ed3%7]) with mapi id 15.20.1835.018; Thu, 2 May 2019
 20:38:57 +0000
From:   Michal Kalderon <mkalderon@marvell.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     David Miller <davem@davemloft.net>,
        Ariel Elior <aelior@marvell.com>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>,
        "dledford@redhat.com" <dledford@redhat.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: RE: [EXT] Re: [PATCH net-next 07/10] qed*: Add iWARP 100g support
Thread-Topic: [EXT] Re: [PATCH net-next 07/10] qed*: Add iWARP 100g support
Thread-Index: AQHVAASJgb30DtcUnkKd3+vJ8gvix6ZW/dEAgABNqQCAAHNAoIAABx4AgACIFjA=
Date:   Thu, 2 May 2019 20:38:56 +0000
Message-ID: <BLUPR18MB013088A1CA1A8C618B0D4443A1340@BLUPR18MB0130.namprd18.prod.outlook.com>
References: <20190501095722.6902-1-michal.kalderon@marvell.com>
 <20190501095722.6902-8-michal.kalderon@marvell.com>
 <20190501.203522.1577716429222042609.davem@davemloft.net>
 <20190502051320.GF7676@mtr-leonro.mtl.com>
 <BLUPR18MB0130AF99D6AB674A85E075D9A1340@BLUPR18MB0130.namprd18.prod.outlook.com>
 <20190502123118.GR7676@mtr-leonro.mtl.com>
In-Reply-To: <20190502123118.GR7676@mtr-leonro.mtl.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [79.179.90.23]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e33d23b1-44fe-43d2-3345-08d6cf3e3309
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:BLUPR18MB0130;
x-ms-traffictypediagnostic: BLUPR18MB0130:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <BLUPR18MB01307321D202A4CF0A4C4183A1340@BLUPR18MB0130.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0025434D2D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(396003)(39860400002)(346002)(376002)(136003)(189003)(199004)(52536014)(478600001)(4326008)(73956011)(66556008)(54906003)(64756008)(229853002)(26005)(66946007)(66446008)(486006)(66476007)(316002)(81166006)(256004)(8936002)(81156014)(5660300002)(68736007)(8676002)(86362001)(76116006)(71200400001)(71190400001)(66066001)(14444005)(9686003)(7736002)(6916009)(6246003)(76176011)(6306002)(74316002)(33656002)(11346002)(53936002)(99286004)(446003)(6116002)(2906002)(102836004)(55016002)(14454004)(966005)(7696005)(6436002)(186003)(476003)(3846002)(305945005)(6506007)(25786009);DIR:OUT;SFP:1101;SCL:1;SRVR:BLUPR18MB0130;H:BLUPR18MB0130.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: KgrdKz0VlNUCivrAIkRZ7hwBlDju16uvyfWQZ48JHa6AxuoUQQ6COuaJegr4UVV+nbCKghPYQuheAjFYrE1ytT0+tnCKSk073+znKBv8esBeaG6HQrIJ9WDxO93rIkY4f0TvgeaC0HoXqxGK8Ts+RD5uHDzj+Is3evfDCHZvqDgi7eVra1oDZSxzzA5/9XsCw6GhftFGfhbN/Oly8wxcbl68ChYtnYs2tyPh3AIEBD+kdoKpX4NXebOUfQv0RISKDMOdEXkalXPK2KTxALiCIRAjW6VsnCZCW/jfM+p4wkM1Q4BdANHjcm9UGOrwWNWnzm82aeB52xFNaw3/h3FyNmwLNVy++s3qtYSCtJxKobpQSo5EXnFF0KF8WupRv52BTZJ0GwuBuFjYXJtcCUQ/RLLKlw4nD8yqZZDM8Ul614k=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: e33d23b1-44fe-43d2-3345-08d6cf3e3309
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 May 2019 20:38:56.7674
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLUPR18MB0130
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-02_12:,,
 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Leon Romanovsky <leon@kernel.org>
> Sent: Thursday, May 2, 2019 3:31 PM
>=20
> On Thu, May 02, 2019 at 12:10:39PM +0000, Michal Kalderon wrote:
> > > From: Leon Romanovsky <leon@kernel.org>
> > > Sent: Thursday, May 2, 2019 8:13 AM
> > > On Wed, May 01, 2019 at 08:35:22PM -0400, David Miller wrote:
> > > > From: Michal Kalderon <michal.kalderon@marvell.com>
> > > > Date: Wed, 1 May 2019 12:57:19 +0300
> > > >
> > > > > diff --git a/drivers/infiniband/hw/qedr/main.c
> > > > > b/drivers/infiniband/hw/qedr/main.c
> > > > > index d93c8a893a89..8bc6775abb79 100644
> > > > > --- a/drivers/infiniband/hw/qedr/main.c
> > > > > +++ b/drivers/infiniband/hw/qedr/main.c
> > > > > @@ -52,6 +52,10 @@ MODULE_DESCRIPTION("QLogic 40G/100G
> ROCE
> > > > > Driver");  MODULE_AUTHOR("QLogic Corporation");
> > > > > MODULE_LICENSE("Dual BSD/GPL");
> > > > >
> > > > > +static uint iwarp_cmt;
> > > > > +module_param(iwarp_cmt, uint, 0444);
> > > MODULE_PARM_DESC(iwarp_cmt, "
> > > > > +iWARP: Support CMT mode. 0 - Disabled, 1 - Enabled. Default:
> > > > > +Disabled");
> > > > > +
> > > >
> > > > Sorry no, this is totally beneath us.
> > >
> > > It is not acceptable for RDMA too.
> >
> > Dave and Leon,
> >
> > This is a bit of a special case related specifically to our hardware.
> > Enabling iWARP on this kind of configuration impacts L2 performance.
> > We don't want this to happen implicitly once the rdma driver is loaded
> > since that can happen automatically and could lead to unexpected behavi=
or
> from user perspective.
> > Therefore we need a way of giving the user control to decide whether
> > they want iWARP at the cost of L2 performance degradation.
> > We also need this information as soon as the iWARP device registers, so
> using the rdma-tool would be too late.
> >
> > If module parameter is not an option, could you please advise what woul=
d
> be ok ?
> > ethtool private flags ?
> > devlink ?
>=20
> Yes, devlink params are modern way to have same functionality as module
> parameters.
>=20
> This patch can help you in order to get a sense of how to do it.
> https://lore.kernel.org/patchwork/patch/959195/
>=20
Thanks Leon,=20
Michal

> Thanks
>=20
> >
> > thanks,
> > Michal
> >
> > >
> > > Also please don't use comments inside function calls, it complicates
> > > various checkers without real need.
> > > dev->ops->iwarp_set_engine_affin(dev->cdev, true /* reset */);
> > >                                                 ^^^^^^^^^^^^^^
> > > Thanks
