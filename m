Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92642799D8
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 22:23:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729315AbfG2UXK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 16:23:10 -0400
Received: from mail-eopbgr1320122.outbound.protection.outlook.com ([40.107.132.122]:47376
        "EHLO APC01-PU1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726129AbfG2UXJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jul 2019 16:23:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LL3q1pDuI5Iw1hqYsB7ezqnnIBlx5OzNn60iiF9ZQqprLmaUUjucN4y8wEJstkmMeUQlIB6JqhVoQlis2oKANYJtl14bGbHKZZWE6AOl3K98yx9GODdGzRURZqkZI3PLWCahEAeQDs/kR75VPvn1tOzMETTk3nzPoezFmBPF2vkMK4IQCjtQf4/LlLVdQ3M+W9IyaA01fHmUxmm36FR1NcX7wmvI9Lsx/5xXicQhWsbqVr2XvDUHIlOX1zxNQJq7X+WZbREHlxSC9c/dDIz+vH3jWDIP6X+XMjmddfWzAnDbTERgD5xy1jYSAmMOHhoYmmLGq8umJ8oE3V8kgLTaVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5YwRaw8R2up+Y5NTThMnTAHzHk+nQ4DebaxeLjp9YPU=;
 b=IphQPKRMTuuzwMpAUnnkGWBItm+lNa7+yAGyyTl6bsfoRWf1hQwMvKz6hsujKAi9+bWR57PaIUnLIRvvou3tTrhVSLgNO958ewPzslHEo1ri0C2+tHu8dU8nd3o9vHwleRYX8Wx9ELUzV6e4qiv2ee0JKGtuOomjbHSzgwvPuChVjBT3M0SlHRxBG2vWjFlrEnMwHwmqunamCSpUZeDO5dm8rQOzIIOx3MWVSfejZkrGrP4ImiFbjA1ZvAxYcH5Do8lBlQcc9vy7HGe/ThRFGgFX6+AVwsJeA1x90/c1znslT1cErYuVAXGixHIJfq4jCkzofP2lFM545Epm2goI1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5YwRaw8R2up+Y5NTThMnTAHzHk+nQ4DebaxeLjp9YPU=;
 b=LQlXAFN4UVogfHgjqeMCGLIzsjiyKAKafKPOvKvp3bn5XIxXuAfAdsqjczDgeLDW3dfeE5Cg5miFnA/r0uKHtFf1F3CeTrZkrW6REZRz2AqBEJIGHCAn66bgx+j/io7V8RsMP2ZLWMgXKGOrIqy6qTfH0QMiFCkYwQ0YEm1nZc8=
Received: from KU1P153MB0166.APCP153.PROD.OUTLOOK.COM (10.170.173.13) by
 KU1P153MB0118.APCP153.PROD.OUTLOOK.COM (10.170.172.143) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.3; Mon, 29 Jul 2019 20:23:02 +0000
Received: from KU1P153MB0166.APCP153.PROD.OUTLOOK.COM
 ([fe80::9d89:362d:94a7:bf9b]) by KU1P153MB0166.APCP153.PROD.OUTLOOK.COM
 ([fe80::9d89:362d:94a7:bf9b%2]) with mapi id 15.20.2157.001; Mon, 29 Jul 2019
 20:23:02 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     Sunil Muthuswamy <sunilmut@microsoft.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "sashal@kernel.org" <sashal@kernel.org>,
        Michael Kelley <mikelley@microsoft.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        vkuznets <vkuznets@redhat.com>,
        "marcelo.cerri@canonical.com" <marcelo.cerri@canonical.com>
Subject: RE: [PATCH net] hv_sock: Fix hang when a connection is closed
Thread-Topic: [PATCH net] hv_sock: Fix hang when a connection is closed
Thread-Index: AdVFcLBEQpsBKkdqRUGheyyiHS7XPAAwF1FQAAQIqHA=
Date:   Mon, 29 Jul 2019 20:23:02 +0000
Message-ID: <KU1P153MB016639445D1816077E1A7D94BFDD0@KU1P153MB0166.APCP153.PROD.OUTLOOK.COM>
References: <PU1P153MB01690A7767ECDF420FF78D66BFC20@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
 <MW2PR2101MB1116DC8461F1B02C232019E2C0DD0@MW2PR2101MB1116.namprd21.prod.outlook.com>
In-Reply-To: <MW2PR2101MB1116DC8461F1B02C232019E2C0DD0@MW2PR2101MB1116.namprd21.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=decui@microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2019-07-28T18:32:21.9786854Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=443dba4b-dc1d-4504-8fd5-802055f65389;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=decui@microsoft.com; 
x-originating-ip: [2001:4898:80e8:7:7187:8d8c:7740:5f55]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5a000ea7-8d14-4d2d-8a19-08d714628ea6
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:KU1P153MB0118;
x-ms-traffictypediagnostic: KU1P153MB0118:|KU1P153MB0118:
x-ms-exchange-transport-forked: True
x-ms-exchange-purlcount: 1
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <KU1P153MB01188185B29640F07CA1702DBFDD0@KU1P153MB0118.APCP153.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 01136D2D90
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(376002)(136003)(366004)(346002)(39860400002)(396003)(189003)(199004)(76176011)(66446008)(8676002)(64756008)(66946007)(66476007)(66556008)(6116002)(1511001)(229853002)(10090500001)(9686003)(7696005)(186003)(55016002)(53936002)(33656002)(74316002)(25786009)(102836004)(99286004)(6306002)(6506007)(76116006)(8990500004)(305945005)(7416002)(22452003)(7736002)(6436002)(14454004)(71190400001)(71200400001)(256004)(86362001)(14444005)(68736007)(316002)(4326008)(10290500003)(52536014)(486006)(476003)(446003)(966005)(2501003)(11346002)(46003)(81156014)(2906002)(8936002)(54906003)(5660300002)(110136005)(6246003)(81166006)(478600001);DIR:OUT;SFP:1102;SCL:1;SRVR:KU1P153MB0118;H:KU1P153MB0166.APCP153.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: wA5W1l8/yl0geFLQSWCOnY/FtuDym6SGlcjxDt6wUvZbvk8QKtJZva1Ly7rHPRrYBFAwrZspqDmDaVu7fcjsqMPE4lH0D60NMpCm9RCtRJeA0ej8RYShckp1hXG75IbbBAtHbaC0kpnZY2D4eLRa4BYuara9Z2evuBQA5Y1nPUPmxUoWC0IBDhzT0AQTSeTUd/8CNilQvHP1ANC6M2Xd5iGXN5/lG4edryRYOzUWO5yqHPaohiQbiGRdJzI4lw3qz4kUz5MaUQphJVN4YoDUsSRZT0h39+0CZ2p7HMcsYz883Bwl3dYOmDnjc7fabEDeEjTpNtkDHn3iOGKODjvsBJ9cc+CQPmeShfQtIEHWjNBdvJWIgifaoQTM+wWNxQ4FnybT5UGFd9CBj8UcCc97TwHgxyU3aGTTr7i2m6mB3U4=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a000ea7-8d14-4d2d-8a19-08d714628ea6
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jul 2019 20:23:02.3956
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: r7bsU1xXwSV/2Z7jfvtvGwjpFdz4XvuD1MerZ2EGe+FtQ6Ve428Ix8z1NKSXgQRG919BBZ3qihLCfsj070Pn8A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KU1P153MB0118
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Sunil Muthuswamy <sunilmut@microsoft.com>
> Sent: Monday, July 29, 2019 10:21 AM
> > --- a/net/vmw_vsock/hyperv_transport.c
> > +++ b/net/vmw_vsock/hyperv_transport.c
> > @@ -309,9 +309,16 @@ static void hvs_close_connection(struct
> vmbus_channel *chan)
> >  {
> >  	struct sock *sk =3D get_per_channel_state(chan);
> >
> > +	/* Grab an extra reference since hvs_do_close_lock_held() may decreas=
e
> > +	 * the reference count to 0 by calling sock_put(sk).
> > +	 */
> > +	sock_hold(sk);
> > +
>=20
> To me, it seems like when 'hvs_close_connection' is called, there should =
always
> be an outstanding reference to the socket.=20

I agree. There *should* be, but it turns out there is race condition:=20

For an established connectin that is being closed by the guest, the refcnt =
is 4
at the end of hvs_release() (Note: here the 'remove_sock' is false):

1 for the initial value;
1 for the sk being in the bound list;
1 for the sk being in the connected list;
1 for the delayed close_work.

After hvs_release() finishes, __vsock_release() -> sock_put(sk) *may* decre=
ase
the refcnt to 3.=20

Concurrently, hvs_close_connection() runs in another thread:
  calls vsock_remove_sock() to decrease the refcnt by 2;
  call sock_put() to decrease the refcnt to 0, and free the sk;
  Next, the "release_sock(sk)" may hang due to use-after-free.

In the above, after hvs_release() finishes, if hvs_close_connection() runs
faster than "__vsock_release() -> sock_put(sk)", then there is not any issu=
e,
because at the beginning of hvs_close_connection(), the refcnt is still 4.

So, this patch can work, but it's not the right fix.=20
Your suggestion is correct and here is the patch.=20
I'll give it more tests and send a v2.

--- a/net/vmw_vsock/hyperv_transport.c
+++ b/net/vmw_vsock/hyperv_transport.c
@@ -312,6 +312,11 @@ static void hvs_close_connection(struct vmbus_channel =
*chan)
        lock_sock(sk);
        hvs_do_close_lock_held(vsock_sk(sk), true);
        release_sock(sk);
+
+       /* Release the refcnt for the channel that's opened in
+        * hvs_open_connection().
+        */
+       sock_put(sk);
 }

 static void hvs_open_connection(struct vmbus_channel *chan)
@@ -407,6 +412,9 @@ static void hvs_open_connection(struct vmbus_channel *c=
han)
        }

        set_per_channel_state(chan, conn_from_host ? new : sk);
+
+       /* This reference will be dropped by hvs_close_connection(). */
+       sock_hold(conn_from_host ? new: sk);
        vmbus_set_chn_rescind_callback(chan, hvs_close_connection);

        /* Set the pending send size to max packet size to always get


> The reference that is dropped by
> ' hvs_do_close_lock_held' is a legitimate reference that was taken by
> 'hvs_close_lock_held'.

Correct.

> Or, in other words, I think the right solution is to always maintain a re=
ference to
> socket
> until this routine is called and drop that here. That can be done by taki=
ng the
> reference to
> the socket prior to ' vmbus_set_chn_rescind_callback(chan,
> hvs_close_connection)' and
> dropping that reference at the end of 'hvs_close_connection'.
>=20
> >  	lock_sock(sk);
> >  	hvs_do_close_lock_held(vsock_sk(sk), true);
> >  	release_sock(sk);
> > +
> > +	sock_put(sk);
>=20
> Thanks for taking a look at this. We should queue this fix and the other
> hvsocket fixes
> for the stable branch.

I added a "Cc: stable@vger.kernel.org" tag so this pach will go to the
stable kernels automatically.

Your previous two fixes are in the v5.2.4 stable kernel, but not in the oth=
er
longterm stable kernels 4.19 and 4.14:
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/log/?h=3Dv=
5.2.4&qt=3Dauthor&q=3DMuthuswamy

I'll request them to be backported for 4.19 and 4.14.
I'll also request the patch "vsock: correct removal of socket from the list=
"
to be backported.

The other two "hv_sock: perf" patches are more of features rather than
fixes. Usually the stable kernel maintaners don't backport feature patches.

Thanks,
-- Dexuan
