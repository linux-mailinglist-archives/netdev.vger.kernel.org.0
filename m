Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2459D780EC
	for <lists+netdev@lfdr.de>; Sun, 28 Jul 2019 20:33:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726138AbfG1Sc6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Jul 2019 14:32:58 -0400
Received: from mail-eopbgr1320118.outbound.protection.outlook.com ([40.107.132.118]:10496
        "EHLO APC01-PU1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726046AbfG1Sc5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 28 Jul 2019 14:32:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LGuzqH0hKwcRzUhIizXpuUd5fhImlwS54sglgP1bjER90lxntiOjoNTzzkV3Gnu+qPo42XBB+p6r2OwBjiYdrt5/K3NxfKuO9j6u2sAjrWe8ldmzwSa5ijpUFfBui7fJJAfvTvOnyUK1A4kix/C07VibZoIhcuey5U7m/hTpfegEOIjk6mCgAQ9Np5X3209D/C+3OHl67CKxUAyKJgOnmi9q4HK55/KMo7yMK34kqmhkUHXhfuZKnRYPnanlkVagvgCSpZet1prITu3zinb2r4d5PWDmFvn0+UHmgOSw9msYy5KvCZy2tHLETau695hHsFO6FBtQd2kiV3OCZWcCyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jDkMnBFWZqFxTAkr/PY+mBdnZOGIVztPww6H/hImfx8=;
 b=GcSpLo0UmD+EhvlRxb18VgqygJYtGonUV8POzAKuOZLzbXoB5Yc/qzq79bSsB8OUL3OH5/79RB81XqPU7c+7i1SCTbXSvzrnbI3bKGU61cDhMANomkfvmkB3ITR/JSTLmPM6BzG9j7vSRVBDvWkCrWtrmgP8vSgqyUzYDenf/P/5zO7dcVJ7GXShkDPaqUjFfW36dtdPkgPkaG4Nh2OcUtqY5iKiceXNDAJLnaKqhzj8pamFXW2ftRZSKufXqe8Lnb/WSDEW5ZGIT54/86RQVlFVVwInf9/AQtiTn7V/OG88znNTpnRdB3WP6Ar1EOwH9+cMdhc2VwYe9UQ0PlUy5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=microsoft.com;dmarc=pass action=none
 header.from=microsoft.com;dkim=pass header.d=microsoft.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jDkMnBFWZqFxTAkr/PY+mBdnZOGIVztPww6H/hImfx8=;
 b=mEQThANNc7yWXXDRfKbh1N6J8UDw5ZgcgxRmgc1mMs2diDwQyBHAIeeLqHj2sjlqs4/ipjROXTRQNtoFvJDyvHNcDgXr2ec0GsHGU6xQPBVIsYAwvuDXUSnqfiODpb9wVOxK1RwaAtTTRiW1N2+icBM32bu6b6hdIMsGk7rcrVw=
Received: from PU1P153MB0169.APCP153.PROD.OUTLOOK.COM (10.170.189.13) by
 PU1P153MB0201.APCP153.PROD.OUTLOOK.COM (10.170.190.151) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2136.2; Sun, 28 Jul 2019 18:32:24 +0000
Received: from PU1P153MB0169.APCP153.PROD.OUTLOOK.COM
 ([fe80::d44e:57b7:d8fc:e91c]) by PU1P153MB0169.APCP153.PROD.OUTLOOK.COM
 ([fe80::d44e:57b7:d8fc:e91c%8]) with mapi id 15.20.2136.010; Sun, 28 Jul 2019
 18:32:24 +0000
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
Subject: [PATCH net] hv_sock: Fix hang when a connection is closed
Thread-Topic: [PATCH net] hv_sock: Fix hang when a connection is closed
Thread-Index: AdVFcLBEQpsBKkdqRUGheyyiHS7XPA==
Date:   Sun, 28 Jul 2019 18:32:24 +0000
Message-ID: <PU1P153MB01690A7767ECDF420FF78D66BFC20@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
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
x-originating-ip: [2601:600:a280:1760:49a2:2462:bb4a:421b]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 329de21a-f037-4bda-a1bc-08d71389ef95
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:PU1P153MB0201;
x-ms-traffictypediagnostic: PU1P153MB0201:|PU1P153MB0201:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <PU1P153MB020128758EDD9A2F27E78EE1BFC20@PU1P153MB0201.APCP153.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 01128BA907
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(39860400002)(376002)(346002)(396003)(366004)(136003)(199004)(189003)(51234002)(102836004)(7696005)(7736002)(33656002)(53936002)(6506007)(99286004)(110136005)(54906003)(478600001)(10290500003)(476003)(7416002)(46003)(9686003)(186003)(55016002)(74316002)(4326008)(1511001)(6436002)(6116002)(8676002)(305945005)(2501003)(86362001)(71200400001)(71190400001)(2906002)(8990500004)(14454004)(25786009)(5660300002)(66946007)(76116006)(68736007)(81166006)(81156014)(8936002)(10090500001)(316002)(22452003)(486006)(66446008)(64756008)(66556008)(66476007)(52536014)(256004)(14444005);DIR:OUT;SFP:1102;SCL:1;SRVR:PU1P153MB0201;H:PU1P153MB0169.APCP153.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: hAT+zBGf2FM9Xsli81Dy5SQilTv3GQ1rF9v9ZAGQ09NBP2V+Q7YNBeuuzxeWcCH6O/6vZqz4gwkoHEf+H3kqa6SwXAHNOHb5klMc90Sp82hzXJFYxyz/gknzMI/YvpBnv3l4VaSBvYh7/XETh0cJP0W5z+bB3vxHaXQBkMiZC0/ZABXuEtgYhLStXDtPKgJPjnqDSqW5Fa5LIRNVGl/Fzm87CMU8R3wX9IgjBp1YkxpxaLstiZu4iKEW2vaT+kz5ebTx4W51lxFwMB2CgJZwLK8t5s8JVgPOFqB2VNdDlC4zz2a+dUW3TzFxlGqotSwq9Hs/CKrQPKjQc0K3mV9e2JcVIDIPHAbxJQFa9j0AnN6EjLAINNIc4yHVBMgbO20iJNly989KMFNc18Ovw67uv9PphMSPzbaOMXBAk4AngK8=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 329de21a-f037-4bda-a1bc-08d71389ef95
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jul 2019 18:32:24.2595
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: decui@microsoft.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PU1P153MB0201
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


hvs_do_close_lock_held() may decrease the reference count to 0 and free the
sk struct completely, and then the following release_sock(sk) may hang.

Fixes: a9eeb998c28d ("hv_sock: Add support for delayed close")
Signed-off-by: Dexuan Cui <decui@microsoft.com>
Cc: stable@vger.kernel.org

---
With the proper kernel debugging options enabled, first a warning can
appear:

kworker/1:0/4467 is freeing memory ..., with a lock still held there!
stack backtrace:
Workqueue: events vmbus_onmessage_work [hv_vmbus]
Call Trace:
 dump_stack+0x67/0x90
 debug_check_no_locks_freed.cold.52+0x78/0x7d
 slab_free_freelist_hook+0x85/0x140
 kmem_cache_free+0xa5/0x380
 __sk_destruct+0x150/0x260
 hvs_close_connection+0x24/0x30 [hv_sock]
 vmbus_onmessage_work+0x1d/0x30 [hv_vmbus]
 process_one_work+0x241/0x600
 worker_thread+0x3c/0x390
 kthread+0x11b/0x140
 ret_from_fork+0x24/0x30

and then the following release_sock(sk) can hang:

watchdog: BUG: soft lockup - CPU#1 stuck for 22s! [kworker/1:0:4467]
...
irq event stamp: 62890
CPU: 1 PID: 4467 Comm: kworker/1:0 Tainted: G        W         5.2.0+ #39
Workqueue: events vmbus_onmessage_work [hv_vmbus]
RIP: 0010:queued_spin_lock_slowpath+0x2b/0x1e0
...
Call Trace:
 do_raw_spin_lock+0xab/0xb0
 release_sock+0x19/0xb0
 vmbus_onmessage_work+0x1d/0x30 [hv_vmbus]
 process_one_work+0x241/0x600
 worker_thread+0x3c/0x390
 kthread+0x11b/0x140
 ret_from_fork+0x24/0x30

 net/vmw_vsock/hyperv_transport.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/vmw_vsock/hyperv_transport.c b/net/vmw_vsock/hyperv_transp=
ort.c
index f2084e3f7aa4..efbda8ef1eff 100644
--- a/net/vmw_vsock/hyperv_transport.c
+++ b/net/vmw_vsock/hyperv_transport.c
@@ -309,9 +309,16 @@ static void hvs_close_connection(struct vmbus_channel =
*chan)
 {
 	struct sock *sk =3D get_per_channel_state(chan);
=20
+	/* Grab an extra reference since hvs_do_close_lock_held() may decrease
+	 * the reference count to 0 by calling sock_put(sk).
+	 */
+	sock_hold(sk);
+
 	lock_sock(sk);
 	hvs_do_close_lock_held(vsock_sk(sk), true);
 	release_sock(sk);
+
+	sock_put(sk);
 }
=20
 static void hvs_open_connection(struct vmbus_channel *chan)
--=20
2.19.1

