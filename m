Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 052A2C26C5
	for <lists+netdev@lfdr.de>; Mon, 30 Sep 2019 22:40:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731474AbfI3Uj6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 16:39:58 -0400
Received: from mail-eopbgr1300115.outbound.protection.outlook.com ([40.107.130.115]:7872
        "EHLO APC01-HK2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730045AbfI3Uj5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Sep 2019 16:39:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gcZPzM3ki5PVGdhqZbtr57bP0IXzRJYa5QqHFBXpBWAgFRuhcvH93SU7EDoncwfsANl+OIeEZkJzxy8V4Iz6vxwYq2He3iFoqRhBg/wrBTQKXPkN1WxcJ+ybq/0lJSsmVpoOnS+dx7N6kJ+rdbEB9NW4WrbCKdkWVOhoOjWL7teehzbGGw7llCVERY5f1F0WZ9T1uC8iD1wEaN9BV+NfPDflOYY1EUr2himxp+06wIkRUhBhKtkB1Q157L85b9K4pQVqqfB/l0Qwlu51FSw/t2nnqMhH7njqXQNzDmtyuxy/p5crlbjgzlsjGmq+nYrXVCvWqy8ZrjCJbzkhNlK3Rw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=quRyfDV9X/IMjdHfBbApx/83GbSWpcsGl4LJGy3SB+k=;
 b=QkZ4hUt9zqVROwuwfv5/sJxNCgaahjGUOl25tVD+XCtsW3TR/El9e0+TK14/F6cUDuMP6RTn0rX7MXqQYcS7+NPfS8WJJeLM/b1Y5UVAoeHlouT6mIp1UJoACIpJyxotWxu8fteUP4UEIpulrQ42Qy4Z7Xggb2MB/4TL7k3/SykFjm67/XtpYgfVS6+OkD23VPyzIsV+1vNSzOqv/Y2kYb1nrL7lUsUd1SFQL9DDxntK3jIBbltX3FbkHQWohxQM8QXBrJQuemSNJIimRsDRZ7twfuEf6tro7ph/AejnuvL8oAWumgbC5T8Ce052h3aPZI2wMXiz9nfXHEuphizHvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=quRyfDV9X/IMjdHfBbApx/83GbSWpcsGl4LJGy3SB+k=;
 b=BeFxJMuAExN9VgHOS+3Fs9nG84pHEdBEVal4f5juMUecJ/yNdHpHGFpMkSG6fkwnCokUbZaPJR4Ap8qFWtoyLiUBOdIAtFDTR5NF8D3ni9ZwKa2Kl2aablIzygf06mMi+kUg5u9EWiS9mkqRFu3ZnM75d5oDfnR/X4kxowsz3v4=
Received: from PU1P153MB0169.APCP153.PROD.OUTLOOK.COM (10.170.189.13) by
 PU1P153MB0186.APCP153.PROD.OUTLOOK.COM (10.170.187.144) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2327.4; Mon, 30 Sep 2019 18:33:28 +0000
Received: from PU1P153MB0169.APCP153.PROD.OUTLOOK.COM
 ([fe80::fc44:a784:73e6:c1c2]) by PU1P153MB0169.APCP153.PROD.OUTLOOK.COM
 ([fe80::fc44:a784:73e6:c1c2%7]) with mapi id 15.20.2327.009; Mon, 30 Sep 2019
 18:33:28 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "sashal@kernel.org" <sashal@kernel.org>,
        "stefanha@redhat.com" <stefanha@redhat.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "deepa.kernel@gmail.com" <deepa.kernel@gmail.com>,
        "ytht.net@gmail.com" <ytht.net@gmail.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Michael Kelley <mikelley@microsoft.com>,
        "jhansen@vmware.com" <jhansen@vmware.com>
Subject: RE: [PATCH net v2] vsock: Fix a lockdep warning in __vsock_release()
Thread-Topic: [PATCH net v2] vsock: Fix a lockdep warning in __vsock_release()
Thread-Index: AQHVdD68klVN4bkfhUuYdmaenlvLyqc+f72ggAXEEoCAAE4IYA==
Date:   Mon, 30 Sep 2019 18:33:27 +0000
Message-ID: <PU1P153MB016958C4032818AC88E7C5A6BF820@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
References: <1569460241-57800-1-git-send-email-decui@microsoft.com>
 <20190926074749.sltehhkcgfduu7n2@steredhat.homenet.telecomitalia.it>
 <PU1P153MB01698C46C9348B9762D5E122BF810@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
 <20190930135125.prztj336splp74wq@steredhat>
In-Reply-To: <20190930135125.prztj336splp74wq@steredhat>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=decui@microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2019-09-30T18:33:26.1074996Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=8e36ee39-50ee-4834-9c28-d930e7186b4f;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=decui@microsoft.com; 
x-originating-ip: [2001:4898:80e8:2:d492:e91a:5e0:dd92]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 11ac7b3d-d607-45bd-7f6f-08d745d4afe8
x-ms-office365-filtering-ht: Tenant
X-MS-TrafficTypeDiagnostic: PU1P153MB0186:|PU1P153MB0186:|PU1P153MB0186:|PU1P153MB0186:|PU1P153MB0186:|PU1P153MB0186:|PU1P153MB0186:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PU1P153MB01866330AD8349213B4B58E5BF820@PU1P153MB0186.APCP153.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:519;
x-forefront-prvs: 01762B0D64
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(346002)(376002)(366004)(396003)(39860400002)(136003)(189003)(199004)(316002)(64756008)(66556008)(86362001)(66446008)(66476007)(55016002)(74316002)(76116006)(22452003)(33656002)(8936002)(81156014)(54906003)(52536014)(7696005)(9686003)(8676002)(186003)(99286004)(229853002)(6916009)(305945005)(66946007)(81166006)(6436002)(7416002)(7736002)(4326008)(46003)(558084003)(8990500004)(102836004)(5660300002)(6116002)(25786009)(14444005)(76176011)(71200400001)(2906002)(10090500001)(256004)(14454004)(10290500003)(6506007)(478600001)(446003)(6246003)(476003)(486006)(71190400001)(11346002);DIR:OUT;SFP:1102;SCL:1;SRVR:PU1P153MB0186;H:PU1P153MB0169.APCP153.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: N0v7evv77IWCSK2JUJwKioXVixDnE8EX4feKm652lLqQMXrYpr45hE3BeJQb350JkV1FDrig/xkgj+GPfU1+2pAbpiqjkPiAd/BiuS5Gil6KamDMA4bfNStp4B3JCoup6U4Pq8kiFVfVTuvPetDUewCrR5Y4Z1JcWQSuTaDEoGZzLLYjiTaiScMao6R/VNxpwIpU7DHCj2gN9zZipyYemy+EzcJmwNtrVX+z+3Ow9a1zIYmrw9mmTKk5NJuJGbwDCRrLkstcYWHojQKbdddaj6Nd/2/R76Qk+vX6QjAnfjpaanxIr6SzpaQXiIp7bdIurTvR2YGFZaHRM4OadsLUWBKfkFg8z9xgirPYQv/sot+VIa+ewt4ehDnQZVLmKZFSoOTQL2Q+heHVyaDtq1RPsyieMcMBwLwD+jHyLGRPcKU=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 11ac7b3d-d607-45bd-7f6f-08d745d4afe8
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Sep 2019 18:33:27.8320
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xycrHjBUtVc5/W4HD1YboZVHrc/7iRr8/uF/GX3OziMJJU+liWhQWoJ7d5SZzE8+SaSDdY3hEJZ/p1g+iT2nQA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PU1P153MB0186
X-OriginatorOrg: microsoft.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Stefano Garzarella <sgarzare@redhat.com>
> Sent: Monday, September 30, 2019 6:51 AM
> ...=20
> Feel free to add:
>=20
> Tested-by: Stefano Garzarella <sgarzare@redhat.com>

Thanks, Stefano!

I'll post a v3 with your suggestion "lock_sock_nested(sk, level);".
It does look better than v2 to me. :-)

Thanks,
-- Dexuan
