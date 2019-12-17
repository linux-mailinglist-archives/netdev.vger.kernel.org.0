Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B310A123562
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 20:06:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727836AbfLQTGn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 14:06:43 -0500
Received: from mail-eopbgr70071.outbound.protection.outlook.com ([40.107.7.71]:7461
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726731AbfLQTGm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Dec 2019 14:06:42 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l95Pi+8R82nrFkY/VhMgAOLxqz5y+KXRP+uIQQz2lO39TN9mPQYY60qNettfwVMkSnY6Odl2DhVOvBkCp4WxecLmRKBe33rGhWaUmSuATeyeKpk6uq80KEs0p5E3/nhcKGALZxopwuapgp4gSmNumJqf6IYWtrb+05FCv7vYhe00o3yfhlsFBSPFYHFSGTn5NqvOB+Xbpt9uJnfc13nBlJ1v4ho91BMb8S/rEJHEiPPrgKufDoleXAZhLwxyFyTA4DqnbJ7l166X9GnqC+qTRpShaEMcHO1jzvn2jC5r8j0C2YMl1gg7l6LtX4F+FM7QnKUbBnQetqZNnrnIoGlGkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xOpH8AakbB5+NGQoCfu+jv/sEY9ZZ72yAlcHMqhD6ts=;
 b=RMb76zzq6dcXSSiyWhCBIgWENpHRXewkTGI1oGcbOQp5R5wMMTff4QxsL4j8/SbU3CZAogHTwepdBhBlUjCDtWtkYMotRf1Dzg/TvgVthw9cQhSshYxnKKWkZEZAJsK6cgNUMJx13bvT+zsc0hGLhA9a+2wg86/zrfdWvWtGrna6WZ/uHsU61sCKfSnLbFkSwbqRqRkgAYc4jmlDjSFJ/GbJv5ZXCs7/l/N3tSeo0Qiq424/ZnmSS2blwQgY35aqyvrPo5zBRQr+K3HjUOn9rMnJG5Bd+HnUek9lGAhYp35AQ+ZKaARTmGc+1MWphAbSTOre4+SaDvtiCGJeTNkTGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xOpH8AakbB5+NGQoCfu+jv/sEY9ZZ72yAlcHMqhD6ts=;
 b=e7/TAZl5nOkTcoM7iYwBqVNr8YrU/QVMt+MAdHKpehn5NXHAOe0y49Vye7pVeaKU7HOSLUDBz/au6VYeEde9Gwu3QUaeMyPpq9krA5EGHrGVwjGkZWRIHbokZNzvyLjNgFbfMtj5eZZLwLmOAQvoRvRuvJclgG2Q8U60swowrm4=
Received: from AM6PR05MB5142.eurprd05.prod.outlook.com (20.177.197.210) by
 AM6PR05MB5015.eurprd05.prod.outlook.com (20.177.33.75) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.16; Tue, 17 Dec 2019 19:06:38 +0000
Received: from AM6PR05MB5142.eurprd05.prod.outlook.com
 ([fe80::e8d3:c539:7550:2fdd]) by AM6PR05MB5142.eurprd05.prod.outlook.com
 ([fe80::e8d3:c539:7550:2fdd%6]) with mapi id 15.20.2538.019; Tue, 17 Dec 2019
 19:06:38 +0000
From:   Yuval Avnery <yuvalav@mellanox.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
CC:     Jiri Pirko <jiri@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andy Gospodarek <andy@greyhouse.net>,
        Daniel Jurgens <danielj@mellanox.com>,
        Parav Pandit <parav@mellanox.com>
Subject: RE: [PATCH net-next] netdevsim: Add max_vfs to bus_dev
Thread-Topic: [PATCH net-next] netdevsim: Add max_vfs to bus_dev
Thread-Index: AQHVr871nDBB5hrvy0ak2C7+9Ay1lae1Oa8AgAAB1gCAABOZgIAACO8QgAArtYCAAAxfkIAAC50AgABVJmCAAOJ/gIAAIpgggABa3ACAABH7IIAA/jMAgAAW14CABMvNgIAAB5GAgAFT8RA=
Date:   Tue, 17 Dec 2019 19:06:38 +0000
Message-ID: <AM6PR05MB51423540AF9A93ED4B607735C5500@AM6PR05MB5142.eurprd05.prod.outlook.com>
References: <1576033133-18845-1-git-send-email-yuvalav@mellanox.com>
        <20191211095854.6cd860f1@cakuba.netronome.com>
        <AM6PR05MB514244DC6D25DDD433C0E238C55A0@AM6PR05MB5142.eurprd05.prod.outlook.com>
        <20191211111537.416bf078@cakuba.netronome.com>
        <AM6PR05MB5142CCAB9A06DAC199F7100CC55A0@AM6PR05MB5142.eurprd05.prod.outlook.com>
        <20191211142401.742189cf@cakuba.netronome.com>
        <AM6PR05MB51423D365FB5A8DB22B1DE62C55A0@AM6PR05MB5142.eurprd05.prod.outlook.com>
        <20191211154952.50109494@cakuba.netronome.com>
        <AM6PR05MB51425B74E736C5D765356DC8C5550@AM6PR05MB5142.eurprd05.prod.outlook.com>
        <20191212102517.602a8a5d@cakuba.netronome.com>
        <AM6PR05MB5142F0F18EA6B6F16C5888CEC5550@AM6PR05MB5142.eurprd05.prod.outlook.com>
        <20191212175418.3b07b7a9@cakuba.netronome.com>
        <AM6PR05MB514261CD6F95F104C0353A4BC5540@AM6PR05MB5142.eurprd05.prod.outlook.com>
        <20191213100828.6767de6e@cakuba.netronome.com>
        <AM6PR05MB51422CE9C249DB03F486CB63C5540@AM6PR05MB5142.eurprd05.prod.outlook.com>
 <20191216124441.634ea8ea@cakuba.netronome.com>
 <AM6PR05MB5142B1D44D6190BBDE19F7E0C5510@AM6PR05MB5142.eurprd05.prod.outlook.com>
In-Reply-To: <AM6PR05MB5142B1D44D6190BBDE19F7E0C5510@AM6PR05MB5142.eurprd05.prod.outlook.com>
Accept-Language: he-IL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=yuvalav@mellanox.com; 
x-originating-ip: [70.66.202.183]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 6ad890d6-ed30-4d17-8068-08d783243e7c
x-ms-traffictypediagnostic: AM6PR05MB5015:|AM6PR05MB5015:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM6PR05MB5015E8F2BDE35FF36AD7D541C5500@AM6PR05MB5015.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 02543CD7CD
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(366004)(376002)(346002)(396003)(136003)(189003)(199004)(13464003)(5660300002)(53546011)(186003)(52536014)(26005)(86362001)(107886003)(6916009)(6506007)(8676002)(478600001)(76116006)(55016002)(316002)(2906002)(54906003)(71200400001)(8936002)(81166006)(66556008)(66476007)(66946007)(7696005)(64756008)(66446008)(33656002)(81156014)(4326008)(9686003);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB5015;H:AM6PR05MB5142.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jobF6ipAXMYdYCCzJDOIxCUPs8S23Hy5Nweeb4wuRkMKCqrhCQSj+jhxQxX9h4OuJW//3lay68h4hBNwOlSEBQKLodbFhOTL//nnvsPlKEWho3+d+qmL5rv39+wK4nvCYXMEDVQAZrcFwr/C9vx1DqRXVmbv3wnrNrqoEAL9DkJm6MBnenJsylgZvAjStk1MlRM46iIYPeXBSB4MERMvEz5J1wKD262kuqk2c94nC1wmt3SkFvI1qAp4j41mwrOQ1UPolgk9SVhVAJ5VPG37EAo7xS944J1szgg3MKCAk8FRhw5PfwUBnWWBTlXToYUWEEwlQrbTSmWlUF3KD3wTYw37Y1sF9regXGIL4TfYLAzjNIGP5ytaGqoPleYGNuEyjnrWJ6GVcR2C4qnOAVY+FN/XFi23LNE1jH2giR2yrp59UTjY+42IDvAIpzYKfmD+U7nL9mTqXc6XaMvc6n4IEOg44pKV7LBkVa3vQq987n+P/54ZeqxTziL2LNp4Z1JU
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ad890d6-ed30-4d17-8068-08d783243e7c
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Dec 2019 19:06:38.4873
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oG05tKk5rlW+NJr+M229t6HQaxXQSjKdPySeVZIM7948aTAuilgsP3y2z/NbN31yOKab/xDvMWP6FAgzmYl0kA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB5015
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jacob,

I doubled check, use case is not VF MAC. But for setting PF MAC.
We are talking about bare metal cloud machine, where the whole host is give=
n to the customer.
So you have no control over what is running there.

For this scenario the cloud orchestration SW wants to distribute MAC addres=
ses to the hosts's PFs.
So you can consider the PF as a "VF" and the control CPU is the "real" PF h=
ere.
There is nothing cloud related running on the host.

The reason we extended it to support VFs, is to a have a unified API that w=
ill work
in smartnic and non-smartnic modes.
Thus replacing "ip link vf set" in non-smartnic mode.

Furthermore, when considering min/max_rate groups for the same bare metal s=
cenario,
It doesn't make sense to implement it for PF in devlink for this scenario,
and in "ip link" for any other scenarios (running from host).
So again, single user API which does not depend on the PCI topology.

Ideally, if "ip link" wasn't PCI dependent, we could have added it there.

As for your concern about ip link getting errors on the host.
it is configurable (NVCFG) whether to allow host to configure MACs and othe=
r attributes.
So is up to the cloud administrator.

> -----Original Message-----
> From: Yuval Avnery
> Sent: Monday, December 16, 2019 2:53 PM
> To: Jakub Kicinski <jakub.kicinski@netronome.com>
> Cc: Jiri Pirko <jiri@mellanox.com>; davem@davemloft.net;
> netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Andy Gospodarek
> <andy@greyhouse.net>; Daniel Jurgens <danielj@mellanox.com>; Parav
> Pandit <parav@mellanox.com>
> Subject: RE: [PATCH net-next] netdevsim: Add max_vfs to bus_dev
>=20
>=20
>=20
> > -----Original Message-----
> > From: Jakub Kicinski <jakub.kicinski@netronome.com>
> > Sent: Monday, December 16, 2019 12:45 PM
> > To: Yuval Avnery <yuvalav@mellanox.com>
> > Cc: Jiri Pirko <jiri@mellanox.com>; davem@davemloft.net;
> > netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Andy Gospodarek
> > <andy@greyhouse.net>; Daniel Jurgens <danielj@mellanox.com>
> > Subject: Re: [PATCH net-next] netdevsim: Add max_vfs to bus_dev
> >
>=20
> > The ip-link API will suddenly start returning errors which may not be
> > expected to the user space. So the question is what the user space is
> > you're expecting to run/testing with? _Some_ user space should prove
> > this design out before we merge it.
> >
> > The alternative design is to "forward" hosts ip-link requests to the
> > NIC CPU and let software running there talk to the cloud back end.
> > Rather than going
> >   customer -> could API -> NIC,
> > go
> >   customer -> NIC -> cloud API
> > That obviously is more complex, but has the big advantage of nothing
> > on the host CPU having to change.
>=20
> I will try to summarize your comments:
> 1. There will always be encapsulation, therefore network management
> shouldn't care what MACs customers use.
> 2.  Customer is always requesting MAC, it never simply acquires it from t=
he
> NIC.
>      There is always going to be an entity running on the host setting MA=
Cs to
> VFs.
>=20
> Is that correct?
>=20
>=20
>=20
>=20

