Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FBCC954E7
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 05:15:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729126AbfHTDO1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 23:14:27 -0400
Received: from mail-eopbgr680091.outbound.protection.outlook.com ([40.107.68.91]:39765
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728719AbfHTDO0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Aug 2019 23:14:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QzyWXS65cHqh06NbZ2JrYF8Mj0iRIzu2Xv+M5x3NqXKOJsYMCdR0VKLw3xq6pwCSmcFrjIli+mE+6CaxiL3GixA7u0RRSxJYlc5/jH0k8HvvZ3vx2YPOToFVBzDOV4FKh6bu38sxHfeADk7FtA6FS0TsIb+n4S6sj+uFBSnKwEMUXCcU9XEFdkmG8BSSaKLxAEo7bGhAUU6OHh2i9pEu/cEuMHAdSkkOnMCzXICswm7YYWqVp/9qAB9k5yxILI64QtgbNJhB/v873FDcvRc+r084l2GbboS8sDgHYp1fvczxrU/m/kVhVQT/0+AKmP2nJOez82c7tH+QQVffIw6LCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rQBLdIxgvoWE8byS2jA1IRzQY2WeZr+a+CH/s80mqV8=;
 b=T1WtKmYJUK6Y9Gxe305x7LojikqHX+7kusZ6LUBPOQHfJH6Ej5LcjbUDavlWKUVqmucHm1OP2B9IKXJptQFqGyeSAvG2YOACbJNguSAwpZzQcTooM2blpBad9zAPZskLt6pk58z7kY8KBuR5vDWWgUguCFHn3TBM3f2njkbcfmke1BiomN6QTMKn7QKBJYJm7GY8/ttOYFf2pqpUqWT7QpzHULXOqluPitG46JBRfrurA4Pi3Z1iHV6aK6o6fDxkfWNDb+2lOTyrDX3tWQ60p82iCEWaLhy3zUIKF6gC/MwDrlJWRDaidmVoztRNlHVT+Y1F9aCstUTDrs2lz6Yfig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rQBLdIxgvoWE8byS2jA1IRzQY2WeZr+a+CH/s80mqV8=;
 b=ANmNzx7cGlo1tQDbV+Y39KuM6dDtMEmp5eqEXpa1UIMlq47WDlTK3b9oQUyTW0rLrhlK+rO9ttIqMZKvkQmxz1XuJ0nErHLT0bzOVX8nQZ2IZ4OwaEtuxhl+6tr3soK/6ttjz/Gels06rVuyJB5HGJNVEpTCtjqHwgha92SJnRo=
Received: from SN6PR2101MB0942.namprd21.prod.outlook.com (52.132.114.19) by
 SN6PR2101MB1055.namprd21.prod.outlook.com (52.132.115.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.5; Tue, 20 Aug 2019 03:14:22 +0000
Received: from SN6PR2101MB0942.namprd21.prod.outlook.com
 ([fe80::f9d7:f678:4131:e0e5]) by SN6PR2101MB0942.namprd21.prod.outlook.com
 ([fe80::f9d7:f678:4131:e0e5%8]) with mapi id 15.20.2199.004; Tue, 20 Aug 2019
 03:14:22 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     "jhansen@vmware.com" <jhansen@vmware.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "stefanha@redhat.com" <stefanha@redhat.com>,
        "sgarzare@redhat.com" <sgarzare@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Sasha Levin <Alexander.Levin@microsoft.com>,
        "sashal@kernel.org" <sashal@kernel.org>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        KY Srinivasan <kys@microsoft.com>,
        Michael Kelley <mikelley@microsoft.com>
CC:     "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dexuan Cui <decui@microsoft.com>
Subject: [PATCH] vsock: Fix a lockdep warning in __vsock_release()
Thread-Topic: [PATCH] vsock: Fix a lockdep warning in __vsock_release()
Thread-Index: AQHVVwVcym1CZW34XkidIpoYaOKV3w==
Date:   Tue, 20 Aug 2019 03:14:22 +0000
Message-ID: <1566270830-28981-1-git-send-email-decui@microsoft.com>
Reply-To: Dexuan Cui <decui@microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR08CA0020.namprd08.prod.outlook.com
 (2603:10b6:301:5f::33) To SN6PR2101MB0942.namprd21.prod.outlook.com
 (2603:10b6:805:4::19)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=decui@microsoft.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 1.8.3.1
x-originating-ip: [13.77.154.182]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0a3548b1-c813-41dc-49bc-08d7251c7f2f
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600158)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:SN6PR2101MB1055;
x-ms-traffictypediagnostic: SN6PR2101MB1055:|SN6PR2101MB1055:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR2101MB1055A5F5455AD4D2524B3036BFAB0@SN6PR2101MB1055.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1751;
x-forefront-prvs: 013568035E
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(346002)(396003)(376002)(39860400002)(136003)(366004)(199004)(189003)(66556008)(81166006)(2616005)(81156014)(66446008)(66476007)(64756008)(14454004)(6436002)(66946007)(86362001)(43066004)(26005)(6512007)(476003)(186003)(3450700001)(25786009)(107886003)(2201001)(478600001)(54906003)(6636002)(110136005)(6116002)(305945005)(3846002)(22452003)(4326008)(316002)(52116002)(66066001)(4720700003)(486006)(10090500001)(10290500003)(8676002)(53936002)(6486002)(50226002)(7736002)(1511001)(256004)(71190400001)(71200400001)(14444005)(2501003)(6506007)(5660300002)(99286004)(36756003)(386003)(2906002)(8936002)(102836004)(921003)(1121003);DIR:OUT;SFP:1102;SCL:1;SRVR:SN6PR2101MB1055;H:SN6PR2101MB0942.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 1lIpW8nZRNrpX79ij27+c5d9hEvnhrbjohgxbxaVQu5gnCJQ+hutUUo1399jA1baQkxMzyr5xnzeC4RTdxwrUiTi0hXNkDFc+l3Bw6ZAofTtEsyeWHQ/9Q3TMGHCrEwiJ6Ahm2Syq3tWlIAszu+6c0zjqt8dLfBFTRxOcSnag1Sedzvfiy5iyrCyj9KyyIV66Gli6z53Jm9qGjjq0Rk+35zk/O5eHFXf93KDrAYT+qJsmlcfy+XF0MtmqjVUiZ3oDywO4G3Z3i1uzz02BU7uQqjxb1f+mYCRPBxEtlOLeFWzPLoM77A5W6P4wtApW6Pxx5+OmwaifMaHFxRBbE73WjAhUxQHVKlJUgrPXI8C39P5vzNcJvQR7KDiT8jSEr8Fv8C5g+XKf8EXETunmtWH5HbOyeR7nMvR4fErnfLzeSQ=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a3548b1-c813-41dc-49bc-08d7251c7f2f
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Aug 2019 03:14:22.2321
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: K0HBZfHNhUBBActz5pkqooa5oqV9sNPNaZ9Mv4ZeCK97R7awhpF11+FDnMGi58bps/CoHNlRNSg6dU4eqTWK1g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR2101MB1055
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lockdep is unhappy if two locks from the same class are held.

Fix the below warning by making __vsock_release() non-recursive -- this
patch is kind of ugly, but it looks to me there is not a better way to
deal with the problem here.

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
WARNING: possible recursive locking detected
5.2.0+ #6 Not tainted
--------------------------------------------
a.out/1020 is trying to acquire lock:
0000000074731a98 (sk_lock-AF_VSOCK){+.+.}, at: hvs_release+0x10/0x120 [hv_s=
ock]

but task is already holding lock:
0000000014ff8397 (sk_lock-AF_VSOCK){+.+.}, at: __vsock_release+0x2e/0xf0 [v=
sock]

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(sk_lock-AF_VSOCK);
  lock(sk_lock-AF_VSOCK);

 *** DEADLOCK ***

 May be due to missing lock nesting notation

2 locks held by a.out/1020:
 #0: 00000000f8bceaa7 (&sb->s_type->i_mutex_key#10){+.+.}, at: __sock_relea=
se+0x2d/0xa0
 #1: 0000000014ff8397 (sk_lock-AF_VSOCK){+.+.}, at: __vsock_release+0x2e/0x=
f0 [vsock]

stack backtrace:
CPU: 7 PID: 1020 Comm: a.out Not tainted 5.2.0+ #6
Call Trace:
 dump_stack+0x67/0x90
 __lock_acquire.cold.66+0x14d/0x1f8
 lock_acquire+0xb5/0x1c0
 lock_sock_nested+0x6d/0x90
 hvs_release+0x10/0x120 [hv_sock]
 __vsock_release+0x24/0xf0 [vsock]
 __vsock_release+0xa0/0xf0 [vsock]
 vsock_release+0x12/0x30 [vsock]
 __sock_release+0x37/0xa0
 sock_close+0x14/0x20
 __fput+0xc1/0x250
 task_work_run+0x98/0xc0
 do_exit+0x3dd/0xc60
 do_group_exit+0x47/0xc0
 get_signal+0x169/0xc60
 do_signal+0x30/0x710
 exit_to_usermode_loop+0x50/0xa0
 do_syscall_64+0x1fc/0x220
 entry_SYSCALL_64_after_hwframe+0x49/0xbe

Signed-off-by: Dexuan Cui <decui@microsoft.com>
---
 net/vmw_vsock/af_vsock.c         | 33 ++++++++++++++++++++++++++++++++-
 net/vmw_vsock/hyperv_transport.c |  2 +-
 2 files changed, 33 insertions(+), 2 deletions(-)

diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index ab47bf3..420f605 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -638,6 +638,37 @@ struct sock *__vsock_create(struct net *net,
 }
 EXPORT_SYMBOL_GPL(__vsock_create);
=20
+static void __vsock_release2(struct sock *sk)
+{
+	if (sk) {
+		struct sk_buff *skb;
+		struct vsock_sock *vsk;
+
+		vsk =3D vsock_sk(sk);
+
+		/* The release call is supposed to use lock_sock_nested()
+		 * rather than lock_sock(), if a lock should be acquired.
+		 */
+		transport->release(vsk);
+
+		/* Use the nested version to avoid the warning
+		 * "possible recursive locking detected".
+		 */
+		lock_sock_nested(sk, SINGLE_DEPTH_NESTING);
+		sock_orphan(sk);
+		sk->sk_shutdown =3D SHUTDOWN_MASK;
+
+		while ((skb =3D skb_dequeue(&sk->sk_receive_queue)))
+			kfree_skb(skb);
+
+		/* This sk can not be a listener, so it's unnecessary
+		 * to call vsock_dequeue_accept().
+		 */
+		release_sock(sk);
+		sock_put(sk);
+	}
+}
+
 static void __vsock_release(struct sock *sk)
 {
 	if (sk) {
@@ -659,7 +690,7 @@ static void __vsock_release(struct sock *sk)
=20
 		/* Clean up any sockets that never were accepted. */
 		while ((pending =3D vsock_dequeue_accept(sk)) !=3D NULL) {
-			__vsock_release(pending);
+			__vsock_release2(pending);
 			sock_put(pending);
 		}
=20
diff --git a/net/vmw_vsock/hyperv_transport.c b/net/vmw_vsock/hyperv_transp=
ort.c
index 9d864eb..4b126b2 100644
--- a/net/vmw_vsock/hyperv_transport.c
+++ b/net/vmw_vsock/hyperv_transport.c
@@ -559,7 +559,7 @@ static void hvs_release(struct vsock_sock *vsk)
 	struct sock *sk =3D sk_vsock(vsk);
 	bool remove_sock;
=20
-	lock_sock(sk);
+	lock_sock_nested(sk, SINGLE_DEPTH_NESTING);
 	remove_sock =3D hvs_close_lock_held(vsk);
 	release_sock(sk);
 	if (remove_sock)
--=20
1.8.3.1

