Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 912BBBE9EB
	for <lists+netdev@lfdr.de>; Thu, 26 Sep 2019 03:11:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729575AbfIZBLc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Sep 2019 21:11:32 -0400
Received: from mail-eopbgr680130.outbound.protection.outlook.com ([40.107.68.130]:42460
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725943AbfIZBLc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Sep 2019 21:11:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gXs5Y6X8Muf9QDYugqPTjcIChuSZMOs4fP2GuvKQjCwk57LdKoGo/4b0V/0uJA9+d+ed4hGciuzFCHlBHVaN8Xzx6kj0DRdKkMPoE5TLrKe7UMBSDEEJbSn16S5GtGOvgCZIqx3jvpB2lppgY6i9WWNlv1m+5I6o3/RV/Ol+z/072iyjnN580HTdr5m8nFynOBScY1L5ZpwpTNzpCy+Mt94zfQEMvujS112Z5X7jcLbRuXctI8L6bBc5MTWajhk4g8E3mgC2kM+RFQCjhy8a6kvSf3M+Q0gl47gaFtMr1RSoqhA0sj96dM96qpyRXGMN5gEFLI9MQjlEmhRY11fxyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kaSt70zK0SQxbnC2gp4oZ7f1ncDlx8JQAZhaoL/VWHI=;
 b=VkOKNsNG0sdT6V0FNxiZVED+wmWU60zSrrTytgHudHZl9Egp16c6+ULcGclF/qJiOVrxLLDewp/UizlIoLMVlIp/VtVrJELka7BDxXU1CEDubux3Gtl3NhQfHWwE5RXq5vhceMa8j+m9yPYYna3ugIiFCXl8KhgVhFNy4yv35hRQLEg1Hofv2gNm2oToEUBhFuE5AHpY/5Lfd6vxk49OIvRpQQi28hBb7TK8zK/4NzpM7OfYREhKxXSrj/HQNsJR7TJtQar5rYyL+J8HoEDGyG+iYiQbE6Tkkef6WU4uG+BUHG8Bm16j9w6ybkK1RZgqkOIjOr0jscpa4OY/dNYbDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kaSt70zK0SQxbnC2gp4oZ7f1ncDlx8JQAZhaoL/VWHI=;
 b=JxD1ijDTa1XQuiyc1pYCVItCE0CMvaWMJHZc7ymSYpjqREFlZum4R9EekZw5hBOz7rw4GvUt1+DAPzTGhUCJjangABLbpJzyLHG3SrU1chysBW7+35EdnAHPnfhL2QV3MVzISo5yWdFHt1yljTul961GRCjrJhwwe6Z56tnRRq8=
Received: from SN6PR2101MB0942.namprd21.prod.outlook.com (52.132.114.19) by
 SN6PR2101MB0974.namprd21.prod.outlook.com (52.132.114.27) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2327.6; Thu, 26 Sep 2019 01:11:27 +0000
Received: from SN6PR2101MB0942.namprd21.prod.outlook.com
 ([fe80::7d1a:ddb:3473:b383]) by SN6PR2101MB0942.namprd21.prod.outlook.com
 ([fe80::7d1a:ddb:3473:b383%9]) with mapi id 15.20.2327.004; Thu, 26 Sep 2019
 01:11:27 +0000
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
Subject: [PATCH net v2] vsock: Fix a lockdep warning in __vsock_release()
Thread-Topic: [PATCH net v2] vsock: Fix a lockdep warning in __vsock_release()
Thread-Index: AQHVdAdSHQkvUaSfZES8M2hNpnvQKg==
Date:   Thu, 26 Sep 2019 01:11:27 +0000
Message-ID: <1569460241-57800-1-git-send-email-decui@microsoft.com>
Reply-To: Dexuan Cui <decui@microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR08CA0012.namprd08.prod.outlook.com
 (2603:10b6:301:5f::25) To SN6PR2101MB0942.namprd21.prod.outlook.com
 (2603:10b6:805:4::19)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=decui@microsoft.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 1.8.3.1
x-originating-ip: [13.77.154.182]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7f6e13ac-ba2a-48c6-f94c-08d7421e74cb
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: SN6PR2101MB0974:|SN6PR2101MB0974:
x-ms-exchange-transport-forked: True
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <SN6PR2101MB0974D0D64A0501309E9947C0BF860@SN6PR2101MB0974.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1468;
x-forefront-prvs: 0172F0EF77
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(136003)(396003)(346002)(376002)(366004)(39860400002)(199004)(189003)(8936002)(66556008)(6436002)(81166006)(110136005)(81156014)(8676002)(2906002)(386003)(66946007)(6486002)(6506007)(476003)(66446008)(2201001)(66476007)(6306002)(10090500001)(52116002)(64756008)(7736002)(43066004)(50226002)(2616005)(4720700003)(22452003)(486006)(316002)(99286004)(14444005)(25786009)(66066001)(36756003)(5660300002)(1511001)(102836004)(86362001)(6116002)(3846002)(6512007)(71200400001)(14454004)(2501003)(966005)(256004)(3450700001)(71190400001)(186003)(26005)(10290500003)(305945005)(7416002)(478600001)(921003)(1121003);DIR:OUT;SFP:1102;SCL:1;SRVR:SN6PR2101MB0974;H:SN6PR2101MB0942.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zDxKH2hFQEvMhjrZEF6zg0k78XYP2yRBjwo0c5xeoumDjIO7UQjo3yg+NrxpmhhhUxR3zLZsGsm4ZGF/qz63wNfy4whHhLE2uiQKiX8ggh0fJuq/pjajlYUGk9SZAF9v+DbIEa7ghUMxrLXO0EQioLqVi4nVuxuhzr6BFhhC9qzPSVFq2BvwOz2zM1rmVQIlbFqmHw7Xf/4tNEjoR9UJki6m+2AJ6726FcZphevqkHFlIdIb1cZftH6cmtqWRimebAnF7S9lhKxt8HrY3+jBdkq7E6yWHW2veIgtCTSQybX9QrL0hLzX14hqFeyOY/3Fry3dKPVJBsSPGsk5WEzkahztWO0T7ZfK0tfwoItYhS1Bxaivgm2wTa9ONAeMwS+YBu9ub6nnMhYSrn4fp1qfKpx6HPIyXOQR6xAi7mfCjj7GUVoZvvYGfxMc63n2USBTj20vVBshkLcYrtyvNwBLzQ==
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f6e13ac-ba2a-48c6-f94c-08d7421e74cb
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Sep 2019 01:11:27.5779
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pDTK7QoOE/3Eq07vl5g7UEagi9bAe+QSzq43Uw/S5PYwHxGB8nniP05dIHeupm6dTXD990pv9/7oJs/YWKdH0w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR2101MB0974
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

Signed-off-by: Dexuan Cui <decui@microsoft.com>
---

NOTE: I only tested the code on Hyper-V. I can not test the code for
virtio socket, as I don't have a KVM host. :-( Sorry.

@Stefan, @Stefano: please review & test the patch for virtio socket,
and let me know if the patch breaks anything. Thanks!

Changes in v2:
  Avoid the duplication of code in v1: https://lkml.org/lkml/2019/8/19/1361
  Also fix virtio socket code.

 net/vmw_vsock/af_vsock.c                | 19 +++++++++++++++----
 net/vmw_vsock/hyperv_transport.c        |  2 +-
 net/vmw_vsock/virtio_transport_common.c |  2 +-
 3 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index ab47bf3ab66e..dbae4373cbab 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -638,8 +638,10 @@ struct sock *__vsock_create(struct net *net,
 }
 EXPORT_SYMBOL_GPL(__vsock_create);
=20
-static void __vsock_release(struct sock *sk)
+static void __vsock_release(struct sock *sk, int level)
 {
+	WARN_ON(level !=3D 1 && level !=3D 2);
+
 	if (sk) {
 		struct sk_buff *skb;
 		struct sock *pending;
@@ -648,9 +650,18 @@ static void __vsock_release(struct sock *sk)
 		vsk =3D vsock_sk(sk);
 		pending =3D NULL;	/* Compiler warning. */
=20
+		/* The release call is supposed to use lock_sock_nested()
+		 * rather than lock_sock(), if a sock lock should be acquired.
+		 */
 		transport->release(vsk);
=20
-		lock_sock(sk);
+		/* When "level" is 2, use the nested version to avoid the
+		 * warning "possible recursive locking detected".
+		 */
+		if (level =3D=3D 1)
+			lock_sock(sk);
+		else
+			lock_sock_nested(sk, SINGLE_DEPTH_NESTING);
 		sock_orphan(sk);
 		sk->sk_shutdown =3D SHUTDOWN_MASK;
=20
@@ -659,7 +670,7 @@ static void __vsock_release(struct sock *sk)
=20
 		/* Clean up any sockets that never were accepted. */
 		while ((pending =3D vsock_dequeue_accept(sk)) !=3D NULL) {
-			__vsock_release(pending);
+			__vsock_release(pending, 2);
 			sock_put(pending);
 		}
=20
@@ -708,7 +719,7 @@ EXPORT_SYMBOL_GPL(vsock_stream_has_space);
=20
 static int vsock_release(struct socket *sock)
 {
-	__vsock_release(sock->sk);
+	__vsock_release(sock->sk, 1);
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

