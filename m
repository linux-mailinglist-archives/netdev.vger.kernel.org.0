Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0616EBFE99
	for <lists+netdev@lfdr.de>; Fri, 27 Sep 2019 07:38:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726061AbfI0Fhf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Sep 2019 01:37:35 -0400
Received: from mail-eopbgr1310108.outbound.protection.outlook.com ([40.107.131.108]:49922
        "EHLO APC01-SG2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725808AbfI0Fhf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Sep 2019 01:37:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ChKo6vVuhyq0GqELy5w17O0KIqODaVGd9NX7YSgZdAcg1YDcggmvSVP6amgp+kJ/BuQbAPph6psnQIaaiLl1vMkNP6pZTJLRV/CAltJ1Xy6/a2TRavOUnHXumFF/Y8V3lsb7dLL8U3oGZCSbBFjargK9QB3jl+dd+mU0usD067n+ZuLVPYwu/f6J0NmiDaR5bS1I0iESai8C9Of97wDDcjSGOExsY3mcGRbv0S8Xfon79cbaY5/9Aqd4Sayy847I8NYK08EHKHuAvRDdzWVYqcQZadpgua2NlefQC9mfnRSiYKepsAF0Zv23yFwgxuvE17HiWIQW2PKU452XR02tHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZAAXR3FCzOoTrhzd6PCupsSSh3wkAsNZKvZVepr1cn4=;
 b=hrzhOBxyI/WwSQlqDFdXlnKwrJM4Ym+asZv5U59QB07sg8JlrHHxif1THT8BgBdGdcU9gfosVQTCVQdL4AXyqTOn3VR+9Z6RFfq3BQMnGlg+pe2GzcYXoPl6sT98cBK9eUJKF+EQtf3AMFZi9tBoOhYh6hqliRXDc3Ljjd7c+wUGgAQ8HGOxKMGd5+wFEn0XFb/BsYpun91AHUOXDJgA9KApelRyAdRVCvWpYF+dBGFIsHSkhF48IvNj0H5RYLR8ZsHchwKt6MOuKwYnLLgRsYQJxAREKJSVHWHWoD1q4dksDTR0rlEr3dQTeZvQj+Q6l6VsY8ju5wXv2jQ+ukRXTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZAAXR3FCzOoTrhzd6PCupsSSh3wkAsNZKvZVepr1cn4=;
 b=D7YSSfL+AFc7fuzRSkwRwNrSpwCNCb9nEB5SZHCI/1vA6xHEd493MV3KnBlNJ+ks/+7rbUQzYtD6fk+C8ijy3VmSQmGNuPQCJbgjUSDlnHPB2OCotMNCZYxUJO1r7e2nLvkiBmZEmQ2Avn6iL16FwcKexnbV7ZN76Q/mBakshe8=
Received: from PU1P153MB0169.APCP153.PROD.OUTLOOK.COM (10.170.189.13) by
 PU1P153MB0153.APCP153.PROD.OUTLOOK.COM (10.170.188.143) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2327.3; Fri, 27 Sep 2019 05:37:20 +0000
Received: from PU1P153MB0169.APCP153.PROD.OUTLOOK.COM
 ([fe80::fc44:a784:73e6:c1c2]) by PU1P153MB0169.APCP153.PROD.OUTLOOK.COM
 ([fe80::fc44:a784:73e6:c1c2%7]) with mapi id 15.20.2327.009; Fri, 27 Sep 2019
 05:37:20 +0000
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
Thread-Index: AQHVdD68klVN4bkfhUuYdmaenlvLyqc+f72g
Date:   Fri, 27 Sep 2019 05:37:20 +0000
Message-ID: <PU1P153MB01698C46C9348B9762D5E122BF810@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
References: <1569460241-57800-1-git-send-email-decui@microsoft.com>
 <20190926074749.sltehhkcgfduu7n2@steredhat.homenet.telecomitalia.it>
In-Reply-To: <20190926074749.sltehhkcgfduu7n2@steredhat.homenet.telecomitalia.it>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=decui@microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2019-09-27T05:37:18.5544737Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=9e8ec7b3-ed0e-4ce7-ad35-de9fe91d997d;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=decui@microsoft.com; 
x-originating-ip: [2601:600:a280:7f70:557a:f14b:ea25:465f]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1f733711-fa9e-4440-a02f-08d7430cc436
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: PU1P153MB0153:|PU1P153MB0153:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PU1P153MB0153A8AC1C6682511DF24C6EBF810@PU1P153MB0153.APCP153.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0173C6D4D5
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(346002)(396003)(366004)(376002)(136003)(39860400002)(199004)(189003)(7416002)(6246003)(71200400001)(74316002)(102836004)(81166006)(7696005)(46003)(71190400001)(81156014)(2906002)(76176011)(6506007)(86362001)(478600001)(316002)(54906003)(10290500003)(22452003)(6916009)(305945005)(8676002)(25786009)(7736002)(8936002)(99286004)(14454004)(186003)(76116006)(14444005)(66476007)(66446008)(64756008)(66556008)(256004)(66946007)(33656002)(486006)(52536014)(6436002)(229853002)(476003)(6116002)(446003)(11346002)(5660300002)(4326008)(55016002)(10090500001)(8990500004)(9686003);DIR:OUT;SFP:1102;SCL:1;SRVR:PU1P153MB0153;H:PU1P153MB0169.APCP153.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: EiPE8APPTVqh1xOtt+Mcz7kf7hnFg7OSRlnHSU+jSH4lFzNftZ4BHChG4xLFNryybua08aFVmdD5jl72f5NgGzZVyvbNvh+TkdKnkh2iPB//aEJvdEm1RFAa3qlIm4zFg5xyeTK9sYUTVBS5V3bq6Ee0BwKxvn3Hm4VrAsTlLLggA2z1S3PzzoDLqnnSQE2bX0ZiEEsLEaewJhYhm73aI1L1jfdBwz5Fo0YQSaP2BGI8kzdwkX/IyZcaWgnBODhEbiVO+ztEvIo4wWTmN6YgxJAwhPAuyK0ovCe/8VqHSo+piaswzQY7ye8Scag4UryX9yEiPMRbDc4jvfD0sTqEEE/dn+iMRxlxE84icTZOAyKPNX+X1VXEEnej5CRUQgcybkwyBtNDJr5x1S82s2OKRz2sv0nrobiyhzoGCa68hUE=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f733711-fa9e-4440-a02f-08d7430cc436
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Sep 2019 05:37:20.1920
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /wrA1Hb3PkEUxgC4l6FZlwy5GZvxd2IUVo9KVNlid2db+wgJp9N8/UT6t9roqCE2qxJeYYC+4jW35stqyCxenw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PU1P153MB0153
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: linux-hyperv-owner@vger.kernel.org
> <linux-hyperv-owner@vger.kernel.org> On Behalf Of Stefano Garzarella
> Sent: Thursday, September 26, 2019 12:48 AM
>=20
> Hi Dexuan,
>=20
> On Thu, Sep 26, 2019 at 01:11:27AM +0000, Dexuan Cui wrote:
> > ...
> > NOTE: I only tested the code on Hyper-V. I can not test the code for
> > virtio socket, as I don't have a KVM host. :-( Sorry.
> >
> > @Stefan, @Stefano: please review & test the patch for virtio socket,
> > and let me know if the patch breaks anything. Thanks!
>=20
> Comment below, I'll test it ASAP!

Stefano, Thank you!

BTW, this is how I tested the patch:
1. write a socket server program in the guest. The program calls listen()
and then calls sleep(10000 seconds). Note: accept() is not called.

2. create some connections to the server program in the guest.

3. kill the server program by Ctrl+C, and "dmesg" will show the scary
call-trace, if the kernel is built with=20
	CONFIG_LOCKDEP=3Dy
	CONFIG_LOCKDEP_SUPPORT=3Dy

4. Apply the patch, do the same test and we should no longer see the call-t=
race.

> > -		lock_sock(sk);
> > +		/* When "level" is 2, use the nested version to avoid the
> > +		 * warning "possible recursive locking detected".
> > +		 */
> > +		if (level =3D=3D 1)
> > +			lock_sock(sk);
>=20
> Since lock_sock() calls lock_sock_nested(sk, 0), could we use directly
> lock_sock_nested(sk, level) with level =3D 0 in vsock_release() and
> level =3D SINGLE_DEPTH_NESTING here in the while loop?
>=20
> Thanks,
> Stefano

IMHO it's better to make the lock usage more explicit, as the patch does.

lock_sock_nested(sk, level) or lock_sock_nested(sk, 0) seems a little
odd to me. But I'm open to your suggestion: if any of the network
maintainers, e.g. davem, also agrees with you, I'll change the code=20
as you suggested. :-)

Thanks,
-- Dexuan
