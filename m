Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B5247B797
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 03:26:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726508AbfGaBZ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 21:25:56 -0400
Received: from mail-eopbgr1320101.outbound.protection.outlook.com ([40.107.132.101]:35882
        "EHLO APC01-PU1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725911AbfGaBZz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Jul 2019 21:25:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bEH6c27w+PM3nfGYEpFiDEjzn9DUnEK7N6WZVBUP5F5/sD+Rcnzo5eFlDNm2kAQC7LzcltmUOnO1YtV3B/jGTuN02ewPPFYQ0JunWwwhd9HF2F617yVIfB0tAZ2fJJZ+UVhDGlhRaTBShgA9npgkBUNODWzvLpyDLA7s56oqj/228su8G5nqshcLSQcSsWnyMHg0j9mhcbMtgdSYaw46xmjRMbFDwFNhJHLqYiP5CVWlfIIkar2vUAdI8ghtTC0jrloGvUWiWVw7LCxFLtkKtFqIHmu3xwYybgvF9F/80YZeBNYa9HkeRMLpSOQIamtNMTU+ltd/88boTqy6qiEncg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=thm68vWJDTJqC+ZV40mX//nMUgdYsUcdxVCjvVDMtbc=;
 b=nxJrgKhWQIU27ktpOPGKu2QM/NuyOZ63kdJto5b0kIxSU8tdNISRItvwcByJnQRxAxhaUcjNG1Z8UIGICBXiq+qO+A/2nwb3Mp57awybsw6LVUJu/XY4OorvzeksZJ5Tu+oMjhTFEblCVtgKhrZbktb2Ogki2Gfv/UGFM5wzGnhQTj6kpHhTZOY/ASu73/ivNnWjUOL997FA2iRFN7cG7SsqKUYSZ4TxBIzAkldbJkHHhok9nRd0V5/q/mDiWKN9Lwv/ynbZcxWn3+aZQeXnZ8dYdwf4QFlnlQL7zFJtB5cJYk9b/zFpRR1x6L2I+v+CMRgYpwnR9Uzn3sZrdJqMKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=thm68vWJDTJqC+ZV40mX//nMUgdYsUcdxVCjvVDMtbc=;
 b=NuBjPQ/K+EyRrVqp7BoHyqCVmVxRcpZd/fV8iGcBHlGZyPjPPs0TJxnVcqpW1V5/GetRg4BQufZeoX/HUvoAZz2lHexgZqJ4ekjH5GDWibQA5CPULwzPQQiIUmWbojfO7iTu+Xh65nUmHhlqpmf2jHsx5ERM47IKow5BRYCOJoc=
Received: from PU1P153MB0169.APCP153.PROD.OUTLOOK.COM (10.170.189.13) by
 PU1P153MB0139.APCP153.PROD.OUTLOOK.COM (10.170.188.141) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.3; Wed, 31 Jul 2019 01:25:46 +0000
Received: from PU1P153MB0169.APCP153.PROD.OUTLOOK.COM
 ([fe80::d44e:57b7:d8fc:e91c]) by PU1P153MB0169.APCP153.PROD.OUTLOOK.COM
 ([fe80::d44e:57b7:d8fc:e91c%8]) with mapi id 15.20.2157.001; Wed, 31 Jul 2019
 01:25:46 +0000
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
Subject: [PATCH v2 net] hv_sock: Fix hang when a connection is closed
Thread-Topic: [PATCH v2 net] hv_sock: Fix hang when a connection is closed
Thread-Index: AdVHPmu2nCw89Ds2Tx6HccJLUcFnXg==
Date:   Wed, 31 Jul 2019 01:25:45 +0000
Message-ID: <PU1P153MB01696DDD3A3F601370701DD2BFDF0@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=decui@microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2019-07-31T01:25:42.9249599Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=5fb33ce5-3f70-4230-92d8-446001a362ef;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=decui@microsoft.com; 
x-originating-ip: [2001:4898:80e8:1:c0f7:3271:ccd8:4d01]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f875bf19-0189-4eb7-6107-08d71556034c
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:PU1P153MB0139;
x-ms-traffictypediagnostic: PU1P153MB0139:|PU1P153MB0139:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <PU1P153MB01399350552811B6F45317E1BFDF0@PU1P153MB0139.APCP153.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 011579F31F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(346002)(396003)(366004)(39860400002)(136003)(376002)(54534003)(51234002)(199004)(189003)(52536014)(316002)(486006)(7416002)(10090500001)(10290500003)(25786009)(81166006)(81156014)(305945005)(4326008)(5660300002)(110136005)(68736007)(186003)(8676002)(2906002)(66446008)(64756008)(66556008)(2501003)(74316002)(1511001)(6116002)(33656002)(66946007)(54906003)(6506007)(66476007)(22452003)(71200400001)(14444005)(71190400001)(76116006)(6436002)(478600001)(7736002)(53936002)(8990500004)(86362001)(256004)(14454004)(99286004)(476003)(7696005)(55016002)(9686003)(8936002)(102836004)(46003);DIR:OUT;SFP:1102;SCL:1;SRVR:PU1P153MB0139;H:PU1P153MB0169.APCP153.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: rO7CYCcEHk8JKSQf/pzsEjaHBDT4Rxf1IvOjsj0WZevs9Lz1yJ3+GVYI+Tu5W03bCpoh0zz+1zMD4lPYOlPNsAmrXzuBAoHNOiRNF3ljIMGzcZ1cy/MDbJt8EGk3Z3J/GSCDEskyJNPItPPCW2vbLFC024Xp0Cz+9UgY5+Wk++TP2sIzKOf+tZkI62KCSLuA2MhEqDByBcg3G3EaFu8m+swxbM+pO9NPOx8r2CH0r8g2n1DgmI/cHNLiVDpPcV9LSEBsLbbNmA74n0GiDicJRFPCDC4vg/59W4mvB4jHnqnYv6HnuoKOdNUjoLBgShMAAQsvSEjR8EnPP2S8Bm0rJD3QfCtd383glmEWbuIc0hO94WB006bAOc1LQqqrZqeZ6WQbh7R2IJlcYh0+TWw2rKBvs+oFCckTIXXV492PsUc=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f875bf19-0189-4eb7-6107-08d71556034c
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jul 2019 01:25:45.8275
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: E6dZU1lHIMdHnIGLvTcVfBDnvb22Pth1kbvGOcvZBs3K+6BbWfKZyk0h031jxQiTeCST3xLK2MQfXEBfzsKAVg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PU1P153MB0139
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


There is a race condition for an established connection that is being close=
d
by the guest: the refcnt is 4 at the end of hvs_release() (Note: here the
'remove_sock' is false):

1 for the initial value;
1 for the sk being in the bound list;
1 for the sk being in the connected list;
1 for the delayed close_work.

After hvs_release() finishes, __vsock_release() -> sock_put(sk) *may*
decrease the refcnt to 3.

Concurrently, hvs_close_connection() runs in another thread:
  calls vsock_remove_sock() to decrease the refcnt by 2;
  call sock_put() to decrease the refcnt to 0, and free the sk;
  next, the "release_sock(sk)" may hang due to use-after-free.

In the above, after hvs_release() finishes, if hvs_close_connection() runs
faster than "__vsock_release() -> sock_put(sk)", then there is not any issu=
e,
because at the beginning of hvs_close_connection(), the refcnt is still 4.

The issue can be resolved if an extra reference is taken when the
connection is established.

Fixes: a9eeb998c28d ("hv_sock: Add support for delayed close")
Signed-off-by: Dexuan Cui <decui@microsoft.com>
Cc: stable@vger.kernel.org

---

Changes in v2:=20
  Changed the location of the sock_hold() call.=20
  Updated the changelog accordingly.
 =20
  Thanks Sunil for the suggestion!


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

 net/vmw_vsock/hyperv_transport.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/vmw_vsock/hyperv_transport.c b/net/vmw_vsock/hyperv_transp=
ort.c
index f2084e3f7aa4..9d864ebeb7b3 100644
--- a/net/vmw_vsock/hyperv_transport.c
+++ b/net/vmw_vsock/hyperv_transport.c
@@ -312,6 +312,11 @@ static void hvs_close_connection(struct vmbus_channel =
*chan)
 	lock_sock(sk);
 	hvs_do_close_lock_held(vsock_sk(sk), true);
 	release_sock(sk);
+
+	/* Release the refcnt for the channel that's opened in
+	 * hvs_open_connection().
+	 */
+	sock_put(sk);
 }
=20
 static void hvs_open_connection(struct vmbus_channel *chan)
@@ -407,6 +412,9 @@ static void hvs_open_connection(struct vmbus_channel *c=
han)
 	}
=20
 	set_per_channel_state(chan, conn_from_host ? new : sk);
+
+	/* This reference will be dropped by hvs_close_connection(). */
+	sock_hold(conn_from_host ? new : sk);
 	vmbus_set_chn_rescind_callback(chan, hvs_close_connection);
=20
 	/* Set the pending send size to max packet size to always get
--=20
2.19.1

