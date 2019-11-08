Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA219F4EF9
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 16:10:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726561AbfKHPKs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 10:10:48 -0500
Received: from mail-eopbgr80050.outbound.protection.outlook.com ([40.107.8.50]:23108
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725941AbfKHPKr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Nov 2019 10:10:47 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EWi8pbEe8IBUkC2VpyWzqgUJ80gM6/KuxSROdNHV0qu1eVS/CeRwrSvu+YgRmFQaV7Fa6NSfutFoAFyxWjJ5feP4FYzInxFfZXSXIBH2DMyDIegG7dMd25c/kB5tdNHt+HzVglFApjx5DipJtAoCY+kVTqhOjbZg/GBmtAFYETkdwYrq4/7NLQ7nG1y4kxISvHoKAHb54+jjkYdc6IW+RKAScfnfO6eS6mRio3GRksiKYwyC3eEHaRHuYw+TYSP62OVwMqXGZs0RroxSTBZXVw54HV0TgCRedruaXrB6wHxOrG26FV8tC/DIZoCD5COGVwB9vf0XUTrC3kq1KstfjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=faC8numpgmQEt74rdBsXOt+w+j7bj7LJS/hS2l152K4=;
 b=PpJ2+NEQc3n+IwdwnuOFAbpP9CZlNXjSLo5nERMXeja8uB31zvmVZ/qjskxyCD8tTDt2PkwCdbxtlsH4LHq1+Wge/9QQT/gwJNma4YWu4+/zodT/ulApvMVlL37yNPhaUAYMpCcLAOYHnRhhc1lwS4ymzQX273r+R9f030gMx7KnD7tEIexhdq7TLx0WUnOJRL648vVK6L6r5piVkmeq1CALifKgporxWDm/4qdJ9jx87WaZfCKmqS3uZ9b8q8upUOSlsNv2ItAJh+3nLJl/EYzzx2BmqjQIW9Bvlfefu9swLWy/fRDOGdDhxDl73NLtIChoCuGEQt1o/fMWGZb4cQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=faC8numpgmQEt74rdBsXOt+w+j7bj7LJS/hS2l152K4=;
 b=jqdow5y13trm83IgMPT7E0UkAeLP4LlbaVcKMXU/svVdkguOAe/NQA8EjL+0oo4UHZk1PlzUNtaYpaJOzVSi551TPDCFfC5rSHxHOMUkFPyoO7t/b0zjZPvXukugsziXr9IbOFmNyZIaDsbDlSkeGeUIg+NXizdZ8GjINq+qswk=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB5667.eurprd05.prod.outlook.com (20.178.113.154) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.24; Fri, 8 Nov 2019 15:10:43 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::e5c2:b650:f89:12d4]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::e5c2:b650:f89:12d4%7]) with mapi id 15.20.2430.020; Fri, 8 Nov 2019
 15:10:43 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Cornelia Huck <cohuck@redhat.com>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "leon@kernel.org" <leon@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: RE: [PATCH net-next 19/19] mtty: Optionally support mtty alias
Thread-Topic: [PATCH net-next 19/19] mtty: Optionally support mtty alias
Thread-Index: AQHVlYXKCkwgRpy5N0GblxIWUl4Rt6eBSruAgAAXETA=
Date:   Fri, 8 Nov 2019 15:10:42 +0000
Message-ID: <AM0PR05MB48667622386BBC6D52BE8BE8D17B0@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20191107160448.20962-1-parav@mellanox.com>
        <20191107160834.21087-1-parav@mellanox.com>
        <20191107160834.21087-19-parav@mellanox.com>
 <20191108144615.3646e9bb.cohuck@redhat.com>
In-Reply-To: <20191108144615.3646e9bb.cohuck@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [2605:6000:ec82:1c00:9dfd:71f9:eb37:f669]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 63cf576d-83ac-4953-d3b6-08d7645dd2f9
x-ms-traffictypediagnostic: AM0PR05MB5667:|AM0PR05MB5667:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB5667C738FD4021D6AF39A5E2D17B0@AM0PR05MB5667.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-forefront-prvs: 0215D7173F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(346002)(396003)(366004)(136003)(376002)(199004)(13464003)(189003)(86362001)(25786009)(2906002)(6246003)(6116002)(71200400001)(486006)(229853002)(478600001)(256004)(316002)(71190400001)(5660300002)(33656002)(4326008)(8936002)(446003)(14454004)(66476007)(54906003)(66556008)(64756008)(6916009)(66446008)(8676002)(46003)(99286004)(66946007)(11346002)(76116006)(186003)(102836004)(6436002)(476003)(81156014)(81166006)(7736002)(305945005)(14444005)(52536014)(6506007)(53546011)(9686003)(74316002)(55016002)(7696005)(76176011);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB5667;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kV8F7phP7g60EaMqWLD2Dn1NX/OxOfxgyYdhRBXmkVH/08HqiG83yQ0E5/k/gXT1LRUipBfAyRk5CaRC2QlShxPDKkjIgDiUnkVlOw78M22hPazFtYYQUKvMxJY5z9SVT09JnzdumdSUCEoZQqs4kZjg+s1G0O/srvsfl5QrR7SQh4YzeQwjrlTed++L+XBs6qnpjD901T2j5SK/rzqNcLuXGigxPegIVxsjcPP47GatKr5kyBqw29r7pcghF6/iuv2ohtBMBVkP+u1Qa6PfTLVMPa5hoCGgHp4wUBVJNeNU6JQpqMGi7QyS3aA0fwXF0i5bsJUfguHRbjPGsTMUneFw9+E4DEumYbzwJkY91OPMWVoBiGOpbk0FFvaE+2CViU9P79vh1hk80UyDhNunksqoVrW0WcYY91f4D8jc3Ht08qMaVRFixkI1MDjr13OD
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 63cf576d-83ac-4953-d3b6-08d7645dd2f9
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Nov 2019 15:10:42.9219
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Z4sxCVSXt/HpZK9KQQAHFvRyREzIvx9ciCP4jHXFqCUTwZFal71i6tnbWWca7Ps+kdTG+1vAMCaFw/P8qAPxZg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB5667
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Cornelia Huck <cohuck@redhat.com>
> Sent: Friday, November 8, 2019 7:46 AM
> To: Parav Pandit <parav@mellanox.com>
> Cc: alex.williamson@redhat.com; davem@davemloft.net;
> kvm@vger.kernel.org; netdev@vger.kernel.org; Saeed Mahameed
> <saeedm@mellanox.com>; kwankhede@nvidia.com; leon@kernel.org; Jiri
> Pirko <jiri@mellanox.com>; linux-rdma@vger.kernel.org
> Subject: Re: [PATCH net-next 19/19] mtty: Optionally support mtty alias
>=20
> On Thu,  7 Nov 2019 10:08:34 -0600
> Parav Pandit <parav@mellanox.com> wrote:
>=20
> > Provide a module parameter to set alias length to optionally generate
> > mdev alias.
> >
> > Example to request mdev alias.
> > $ modprobe mtty alias_length=3D12
> >
> > Make use of mtty_alias() API when alias_length module parameter is set.
> >
> > Signed-off-by: Parav Pandit <parav@mellanox.com>
> > ---
> >  samples/vfio-mdev/mtty.c | 13 +++++++++++++
> >  1 file changed, 13 insertions(+)
>=20
> If you already have code using the alias interface, you probably don't ne=
ed
> to add it to the sample driver here. Especially as the alias looks kind o=
f
> pointless here.

It is pointless.
Alex point when we ran through the series in August, was, QA should be able=
 to do cover coverage of mdev_core where there is mdev collision and mdev_c=
reate() can fail.
And QA should be able to set alias length to be short to 1 or 2 letters to =
trigger it.
Hence this patch was added.
