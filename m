Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7407DBE9E9
	for <lists+netdev@lfdr.de>; Thu, 26 Sep 2019 03:10:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729380AbfIZBK3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Sep 2019 21:10:29 -0400
Received: from mail-eopbgr1320108.outbound.protection.outlook.com ([40.107.132.108]:59647
        "EHLO APC01-PU1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727374AbfIZBK2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Sep 2019 21:10:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dSsGMUUqASrRchi/4o8Xi1rvaDUyEEA0pdmDg48UQ7+vO1jEAJEPGTzH7NrODvNt2C7pPkkeL6vPDCRtXWAUDYCaud4b4sOJz7O+Z/QHtGKZNeABoLmjxd6hTijS8GcEqDDXgUhAO+57WTom8SajWDM3L1E+Ya7qlK6VjQEEspRx3wxq/bcSWFx0JlnO9GRzDqkVWzADu8rLP6RMhzTfTRW7DZ0NcoYup2NfnTuJsX9m8ni0FuOvZOTSf0HMTwC6UIgsGdN5NIx89Sj52bQdeOM6bd5bt8qTMLG4PBvisdgmvR9ptCI0rIDueF5MHnz8Kb7B+8LaBQrFnriK77oJXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EPmrxQS77Bk6Hv/QxI2OMe8+2TjIWDnUp0hy+hiYYpw=;
 b=FgG6v6f4GrCmUsqpImYc8C7LoRAyL4Pn59pGKz3bgepsDOfoGtWaxQXR8AgvwSrHaiKMSOEX5YUdUsu8W1Ai38frIFcResi3Sj5vY16FVgCw8VAq/p0xwxmv4fr6YGJBJ1ul1gT8toXweYOOe0nENOF1fYXQ+65c/eWoxn7EcF8XKZDePFBqOy6XY4mZA3nqhK8LWZba+J9Q7MQ+RxNL9PewG8nobpupR4k/djTh/TbXn7iKQfs8CvlJ1GjAWVtsm89qdnUUnGtVDpxljWQ0QXaUKNKmmVfH1KM7zrmUDn234okwQ4hIeqa4xNDyeCcQvAxReotqW83pV1Z7CSXP8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EPmrxQS77Bk6Hv/QxI2OMe8+2TjIWDnUp0hy+hiYYpw=;
 b=b0gqixKFCjFCVAF15Dq7XydBA3qSQqv2dFk1NpJEK6QytsBWtcEySzFMPihKNy2fsjH3+SSESSbjRP7af3ac9xyKgMDmuPKezwfGlNMKXWCEErR5ftX270wqSKCjeZsxQGN15+koN5zF7O6Dp8KM9iFy8vwMV7YKwidYDAa9O5A=
Received: from PU1P153MB0169.APCP153.PROD.OUTLOOK.COM (10.170.189.13) by
 PU1P153MB0187.APCP153.PROD.OUTLOOK.COM (10.170.188.151) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2327.3; Thu, 26 Sep 2019 01:10:20 +0000
Received: from PU1P153MB0169.APCP153.PROD.OUTLOOK.COM
 ([fe80::fc44:a784:73e6:c1c2]) by PU1P153MB0169.APCP153.PROD.OUTLOOK.COM
 ([fe80::fc44:a784:73e6:c1c2%7]) with mapi id 15.20.2327.009; Thu, 26 Sep 2019
 01:10:20 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
CC:     "jhansen@vmware.com" <jhansen@vmware.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "stefanha@redhat.com" <stefanha@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Sasha Levin <Alexander.Levin@microsoft.com>,
        "sashal@kernel.org" <sashal@kernel.org>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        KY Srinivasan <kys@microsoft.com>,
        Michael Kelley <mikelley@microsoft.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] vsock: Fix a lockdep warning in __vsock_release()
Thread-Topic: [PATCH] vsock: Fix a lockdep warning in __vsock_release()
Thread-Index: AQHVWNPr10tg0nhDo0mDd0baql6kLac9W8QA
Date:   Thu, 26 Sep 2019 01:10:19 +0000
Message-ID: <PU1P153MB0169DCA9F95858D42F685259BF860@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
References: <1566270830-28981-1-git-send-email-decui@microsoft.com>
 <20190822102529.q5ozdvh6kbymi6ni@steredhat>
In-Reply-To: <20190822102529.q5ozdvh6kbymi6ni@steredhat>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=decui@microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2019-09-26T01:10:18.0100107Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=8de3862e-3d2d-4c7a-8456-a1219b357018;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=decui@microsoft.com; 
x-originating-ip: [2001:4898:80e8:9:35f2:636:b84a:df21]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bf9ca0f2-5391-4915-43ed-08d7421e4cf3
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: PU1P153MB0187:|PU1P153MB0187:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PU1P153MB0187F53DD2AC98D31098B0ACBF860@PU1P153MB0187.APCP153.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-forefront-prvs: 0172F0EF77
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(39860400002)(396003)(136003)(366004)(346002)(376002)(189003)(199004)(6116002)(86362001)(476003)(99286004)(102836004)(256004)(14454004)(14444005)(229853002)(52536014)(8936002)(446003)(5660300002)(11346002)(316002)(6436002)(486006)(186003)(22452003)(55016002)(8990500004)(4326008)(54906003)(66446008)(66556008)(64756008)(33656002)(76116006)(66946007)(6916009)(9686003)(74316002)(10090500001)(10290500003)(2906002)(66476007)(6506007)(76176011)(81166006)(6246003)(8676002)(71200400001)(7696005)(7736002)(25786009)(46003)(305945005)(81156014)(478600001)(71190400001)(4744005);DIR:OUT;SFP:1102;SCL:1;SRVR:PU1P153MB0187;H:PU1P153MB0169.APCP153.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HH745Rziwl1BknB72wovgMXUa2b3QOOCJJarhnbWxgK3JUmYg/BWSD4V5jioC/Y+VJN7ecJcufKbEqHuj+cJvd+RHv7SzwKUrUhbhenUxAVuTNqoc9mCUze7txnfbULxg40cJB7aojEkflfZ9XPhnurocfzlkmYe0rMYKWlhnDgOg1UL23qzP5bTDn4qPkm6MvreMWvnDyEj0emUSe6UruQefE9fuxwKGcOvzHwKp7mh87pL8S41tZI0I4RFUWjweyaqonA5+8FGzlJqw8QTK47rOtnTM0RJkrqq/Uig6/9VA4qaHo+BIRb9HEbFsMEffO515LTkXna9nVNFW/hqtx+W4piuQ931idmBkn6xaE4jciduIiO43vdAmXCz2f5w63Hx4WpkoGG0EZYgJ0Whmg6fjvK8rIUEVt1EmNzrOFE=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bf9ca0f2-5391-4915-43ed-08d7421e4cf3
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Sep 2019 01:10:19.9550
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: P1Yc43NQ7bByPnZWpmQwWi0zybf3d7bjeDIuO0VEV6Ll2Fe7Qq/N1sVI+EHTYT6XP/fZIWI9/1l8pLkPPSVWnw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PU1P153MB0187
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Stefano Garzarella <sgarzare@redhat.com>
> Sent: Thursday, August 22, 2019 3:25 AM
> > [...snipped...]
> > --- a/net/vmw_vsock/hyperv_transport.c
> > +++ b/net/vmw_vsock/hyperv_transport.c
> > @@ -559,7 +559,7 @@ static void hvs_release(struct vsock_sock *vsk)
> >  	struct sock *sk =3D sk_vsock(vsk);
> >  	bool remove_sock;
> >
> > -	lock_sock(sk);
> > +	lock_sock_nested(sk, SINGLE_DEPTH_NESTING);
>=20
> Should we update also other transports?
>=20
> Stefano

Hi Stefano,
Sorry for the late reply! I'll post a v2 shortly.

As I checked, hyperv socket and virtio socket need to be fixed.

The vmci socket code doesn't acquire the sock lock in the release
callback, so it doesn't need any fix.

Thanks,
-- Dexuan
