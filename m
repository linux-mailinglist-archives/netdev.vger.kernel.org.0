Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 189B8C26E8
	for <lists+netdev@lfdr.de>; Mon, 30 Sep 2019 22:45:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730867AbfI3UmZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 16:42:25 -0400
Received: from mail-eopbgr730136.outbound.protection.outlook.com ([40.107.73.136]:25596
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726425AbfI3UmY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Sep 2019 16:42:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XD5PAy6VlrMFtYHfmwZiEwHxVRjdBd2r/AFMbS3msZLgHaIekAiAUHnFGTjrKEixyOIEuHwMbRfAg49DuZazAkwZyxv756CuucpLqPs2Xdx6kCZV8osn7gGsUth3BY5NuAoeekbzs1mJV9CjxuEP+rEOcI7NGA5il1y0guoTzEjmiVP3eB66A2wob6DjKgte/oZ5rG/JX/LanZsz7eYHIOlLUBD9Af2obES2Cfwy77vhp/2WPX2ZYQhU6+uUuw97YkIGbRV21YgSZ45qAEQcFl0Xh0YF4lf109dNMCNItrPyPX9tJxhOdT+Yr3kscKp+tYWEs7p6ZQx3X1nLbxYd3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4VLe6uWWiY/qpEe3s/bHgLDaeTsdh1kwDEUaDim+pJY=;
 b=Pe4ge3OjxiimrmuGfpnPFq1fba6Cs1TmLh7vlsc30+5kc00ZuJjLZpvZg8wg3nrlCSvlu++cGbiP5IqSEVxKsYFRfXPGEv3WDhqLhnv9jdHJlGgBJ15HJ9fsmwsvOR9CKcqTtatTxHQRpPLDmmnz/glvVx7TnDIP9RLZcSg51f2C9QNeuoRYh80ElQMWFjrzv4NrMZ2se+S/lRxkaGVdSIKbVb2xgOroIaxpJzvG8M330tu8c/SHXl1FsHVk+QIi2lSjqDNLgCe/YXSDb7pVNlVo2eo8wpGZIWWx7NXjdkHSW/nTj3jmiOFZ0FT3LonjaZRBmf19XAMWbCfm7bv7hA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4VLe6uWWiY/qpEe3s/bHgLDaeTsdh1kwDEUaDim+pJY=;
 b=ONatBT9rpDxOkGRRVqhVR8UPRpAK3xAvTTXxs4RUvFk581fVuzTNsftZHmvGwWPuxZqwLAPOz2t6TgCTq+j8jI9pCjz2hRsdNy/TYgXcgBR8dl1+8JktQFkoDvcHrp+5UCmgOO5zdfC0PegXZkk14zJh9i0UOvLI2BWrs0oe+nQ=
Received: from MW2PR2101MB0937.namprd21.prod.outlook.com (52.132.146.10) by
 MW2PR2101MB0972.namprd21.prod.outlook.com (52.132.146.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2327.3; Mon, 30 Sep 2019 18:43:50 +0000
Received: from MW2PR2101MB0937.namprd21.prod.outlook.com
 ([fe80::adb9:3e84:c02f:a6e5]) by MW2PR2101MB0937.namprd21.prod.outlook.com
 ([fe80::adb9:3e84:c02f:a6e5%4]) with mapi id 15.20.2305.017; Mon, 30 Sep 2019
 18:43:50 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     "davem@davemloft.net" <davem@davemloft.net>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "sashal@kernel.org" <sashal@kernel.org>,
        "stefanha@redhat.com" <stefanha@redhat.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "deepa.kernel@gmail.com" <deepa.kernel@gmail.com>,
        Dexuan Cui <decui@microsoft.com>,
        "ytht.net@gmail.com" <ytht.net@gmail.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Michael Kelley <mikelley@microsoft.com>,
        "sgarzare@redhat.com" <sgarzare@redhat.com>,
        "jhansen@vmware.com" <jhansen@vmware.com>
Subject: [PATCH net v3] vsock: Fix a lockdep warning in __vsock_release()
Thread-Topic: [PATCH net v3] vsock: Fix a lockdep warning in __vsock_release()
Thread-Index: AQHVd77/dTwgXN3aQEytMriZU2+CuA==
Date:   Mon, 30 Sep 2019 18:43:50 +0000
Message-ID: <1569868998-56603-1-git-send-email-decui@microsoft.com>
Reply-To: Dexuan Cui <decui@microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR21CA0032.namprd21.prod.outlook.com
 (2603:10b6:300:129::18) To MW2PR2101MB0937.namprd21.prod.outlook.com
 (2603:10b6:302:4::10)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=decui@microsoft.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 1.8.3.1
x-originating-ip: [13.77.154.182]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4298583d-c9ee-4ebb-fdf9-08d745d62258
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: MW2PR2101MB0972:|MW2PR2101MB0972:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW2PR2101MB097223F7D12543FBEA0CC0CCBF820@MW2PR2101MB0972.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:497;
x-forefront-prvs: 01762B0D64
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(136003)(39860400002)(366004)(396003)(346002)(376002)(199004)(189003)(1511001)(102836004)(6506007)(22452003)(71200400001)(25786009)(66476007)(316002)(64756008)(52116002)(386003)(66946007)(2201001)(66556008)(2906002)(2616005)(186003)(8936002)(10090500001)(7736002)(8676002)(81166006)(486006)(50226002)(5660300002)(99286004)(86362001)(66446008)(305945005)(3450700001)(14454004)(256004)(478600001)(3846002)(476003)(26005)(4720700003)(36756003)(10290500003)(71190400001)(81156014)(14444005)(66066001)(2501003)(7416002)(6116002)(6512007)(43066004)(110136005)(6486002)(6436002)(921003)(1121003);DIR:OUT;SFP:1102;SCL:1;SRVR:MW2PR2101MB0972;H:MW2PR2101MB0937.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VMot/gftkqjyeSWsI/zrWW/qP8FQE1ymAm8MNEeuLIGn+sF4U+5JE2NbeRF85thVKR+sL0xHdd6nOw0OV/IFlrcEkGJaX5Nzjat8bb3e8ZlBvN6BCx+Dup1JKq/uCuwiZwcJZBXlRCkpOT7A6+XqzJe28eAH7dNuJHE3X6ugGMAW6p+cNM6HK4geTQws+5f+OHkhZUqLapCpgflRs4oWyZAfgyn5nQRbIW4q2/sPbXX80oXb311SpGk/kqJb8wpD9A8W6+1A1YIXe/xyGaQj7tN7vcCC9pprlue9uICWZ4848+ONa4LCnEkN7bbX+jgJmwNNf+pIpCi9KpJ1SfQ5BSXN1cZbms//jBghmxNt16VJ9Fe8uwEzwB8FD+RtFdaNeaBC4uhf/oGUyWZ9ScpiimiTK7SqGxJb3YuBBXAgK74=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4298583d-c9ee-4ebb-fdf9-08d745d62258
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Sep 2019 18:43:50.2117
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: L6ytQc6JCDshj5jqInJdpnwy7kABz1ERGzhroQb12qbDXo+ISQM+aj64Dd8fEOixszkMZnbkzXXgQpV0NoDzXg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR2101MB0972
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lockdep is unhappy if two locks from the same class are held.

Fix the below warning for hyperv and virtio sockets (vmci socket code
doesn't have the issue) by using lock_sock_nested() when __vsock_release()
is called recursively:

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
WARNING: possible recursive locking detected
5.3.0+ #1 Not tainted
--------------------------------------------
server/1795 is trying to acquire lock:
ffff8880c5158990 (sk_lock-AF_VSOCK){+.+.}, at: hvs_release+0x10/0x120 [hv_s=
ock]

but task is already holding lock:
ffff8880c5158150 (sk_lock-AF_VSOCK){+.+.}, at: __vsock_release+0x2e/0xf0 [v=
sock]

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(sk_lock-AF_VSOCK);
  lock(sk_lock-AF_VSOCK);

 *** DEADLOCK ***

 May be due to missing lock nesting notation

2 locks held by server/1795:
 #0: ffff8880c5d05ff8 (&sb->s_type->i_mutex_key#10){+.+.}, at: __sock_relea=
se+0x2d/0xa0
 #1: ffff8880c5158150 (sk_lock-AF_VSOCK){+.+.}, at: __vsock_release+0x2e/0x=
f0 [vsock]

stack backtrace:
CPU: 5 PID: 1795 Comm: server Not tainted 5.3.0+ #1
Call Trace:
 dump_stack+0x67/0x90
 __lock_acquire.cold.67+0xd2/0x20b
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
 do_exit+0x344/0xc60
 do_group_exit+0x47/0xb0
 get_signal+0x15c/0xc50
 do_signal+0x30/0x720
 exit_to_usermode_loop+0x50/0xa0
 do_syscall_64+0x24e/0x270
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x7f4184e85f31

Tested-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: Dexuan Cui <decui@microsoft.com>
---

Changes in v2:
  Avoid the duplication of code in v1.
  Also fix virtio socket code.


Changes in v3:
  Use "lock_sock_nested(sk, level);" -- suggested by Stefano.
  Add Stefano's Tested-by.

 net/vmw_vsock/af_vsock.c                | 16 ++++++++++++----
 net/vmw_vsock/hyperv_transport.c        |  2 +-
 net/vmw_vsock/virtio_transport_common.c |  2 +-
 3 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index ab47bf3ab66e..2ab43b2bba31 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -638,7 +638,7 @@ struct sock *__vsock_create(struct net *net,
 }
 EXPORT_SYMBOL_GPL(__vsock_create);
=20
-static void __vsock_release(struct sock *sk)
+static void __vsock_release(struct sock *sk, int level)
 {
 	if (sk) {
 		struct sk_buff *skb;
@@ -648,9 +648,17 @@ static void __vsock_release(struct sock *sk)
 		vsk =3D vsock_sk(sk);
 		pending =3D NULL;	/* Compiler warning. */
=20
+		/* The release call is supposed to use lock_sock_nested()
+		 * rather than lock_sock(), if a sock lock should be acquired.
+		 */
 		transport->release(vsk);
=20
-		lock_sock(sk);
+		/* When "level" is SINGLE_DEPTH_NESTING, use the nested
+		 * version to avoid the warning "possible recursive locking
+		 * detected". When "level" is 0, lock_sock_nested(sk, level)
+		 * is the same as lock_sock(sk).
+		 */
+		lock_sock_nested(sk, level);
 		sock_orphan(sk);
 		sk->sk_shutdown =3D SHUTDOWN_MASK;
=20
@@ -659,7 +667,7 @@ static void __vsock_release(struct sock *sk)
=20
 		/* Clean up any sockets that never were accepted. */
 		while ((pending =3D vsock_dequeue_accept(sk)) !=3D NULL) {
-			__vsock_release(pending);
+			__vsock_release(pending, SINGLE_DEPTH_NESTING);
 			sock_put(pending);
 		}
=20
@@ -708,7 +716,7 @@ EXPORT_SYMBOL_GPL(vsock_stream_has_space);
=20
 static int vsock_release(struct socket *sock)
 {
-	__vsock_release(sock->sk);
+	__vsock_release(sock->sk, 0);
 	sock->sk =3D NULL;
 	sock->state =3D SS_FREE;
=20
diff --git a/net/vmw_vsock/hyperv_transport.c b/net/vmw_vsock/hyperv_transp=
ort.c
index 261521d286d6..c443db7af8d4 100644
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
diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio=
_transport_common.c
index 5bb70c692b1e..a666ef8fc54e 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -820,7 +820,7 @@ void virtio_transport_release(struct vsock_sock *vsk)
 	struct sock *sk =3D &vsk->sk;
 	bool remove_sock =3D true;
=20
-	lock_sock(sk);
+	lock_sock_nested(sk, SINGLE_DEPTH_NESTING);
 	if (sk->sk_type =3D=3D SOCK_STREAM)
 		remove_sock =3D virtio_transport_close(vsk);
=20
--=20
2.19.1

