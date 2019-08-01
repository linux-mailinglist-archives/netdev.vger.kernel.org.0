Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A7187D264
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 02:51:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728364AbfHAAur (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 20:50:47 -0400
Received: from mail-eopbgr770099.outbound.protection.outlook.com ([40.107.77.99]:10724
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727884AbfHAAuq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Jul 2019 20:50:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GPGZ3yJjWQ50GZ5MN9CRFA6WHeC2CAeykyrFPDq3b9hDYf3FQOAB6i3Mzg9ac8n+QjWBVveMlht9Bu44u+fwhGwzWNNSu54EgQdwYKpa23boPXjfkrdQQtxYoN3noaKKOAIJY764zK/GtmLl5wQbbXcWvz6IV28cDhd2ZECgbrvev81LLfNK6Bb+CuIhpO4hEmYyODVSbIY0GnXzKhq12fb1ej23TRvW8vfVlwBwWPR+7x2puH0vCzf0rLpgfrMk/yJ0u2+92Z9+9f8Emgr7U91D0U6OvbfhthYVqRLWEpvtyxmn87Wh4vYextR6ahpYbcOs9e1OZVUzw9/I0tvFkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qLfUUkj4AsOiV7W03BF6ufXNGgcT71JuGmqxuiS23Eg=;
 b=hjw6bP2jhv7ggVOvN4ZZeE0URgIbXgzIurX3zpMX5NDqMNrHw8V53EJ5iCUYP9GirxXEghRnOdXjQgcU/dS8Tlhz4muYBD8wD2Zxz12orcF6BXbJUgQaq8qsHA62b0VZ2JXBgYAhUat2aDSNhSdWtjkBIf69kdv50cIdl+QzJg2qy4SyGU6GAKOemW21Ix6sw44AL9TOzD3m5Kle5Ar4m/Aqb6YfcSquBeIJN0BqpUg7ACrDmnZXUiLJ9NxdeZ7+MWSEfHP2FtmOkoSi10KQz9s5ZVKhzmTN+xuF0C9C/fMTp5q62JezwCtnxAwwXLk/LpbJXrBpSIYk1Tf6as1WHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qLfUUkj4AsOiV7W03BF6ufXNGgcT71JuGmqxuiS23Eg=;
 b=l4yMfufxzAsY0SC7FZQc1DqIEcM0DeRxsxVw7w0kDFZqk7e8JNVzEEfYuajR0HLnBsC6QxalPStMWM1zrfy/FHbKpjOx2IFufY3eAtCuf1qdkmoQ7mrgJpUITdhc1b3yDscd2V38VNPiB/bSwgNVnK6NAH7PJSN9ekwbFNlT/28=
Received: from MW2PR2101MB1116.namprd21.prod.outlook.com (52.132.149.33) by
 MW2PR2101MB0922.namprd21.prod.outlook.com (52.132.152.30) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.2; Thu, 1 Aug 2019 00:50:23 +0000
Received: from MW2PR2101MB1116.namprd21.prod.outlook.com
 ([fe80::bc7c:35c:7094:2c9c]) by MW2PR2101MB1116.namprd21.prod.outlook.com
 ([fe80::bc7c:35c:7094:2c9c%7]) with mapi id 15.20.2157.001; Thu, 1 Aug 2019
 00:50:23 +0000
From:   Sunil Muthuswamy <sunilmut@microsoft.com>
To:     Dexuan Cui <decui@microsoft.com>,
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
Subject: RE: [PATCH v2 net] hv_sock: Fix hang when a connection is closed
Thread-Topic: [PATCH v2 net] hv_sock: Fix hang when a connection is closed
Thread-Index: AdVHPmu2nCw89Ds2Tx6HccJLUcFnXgAxGuGQ
Date:   Thu, 1 Aug 2019 00:50:22 +0000
Message-ID: <MW2PR2101MB11165B4F0105DEBA0A9E879DC0DE0@MW2PR2101MB1116.namprd21.prod.outlook.com>
References: <PU1P153MB01696DDD3A3F601370701DD2BFDF0@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
In-Reply-To: <PU1P153MB01696DDD3A3F601370701DD2BFDF0@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
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
 smtp.mailfrom=sunilmut@microsoft.com; 
x-originating-ip: [2001:4898:80e8:3:4ae:85f3:2e55:f613]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e0d7fdb9-27de-48fc-da0f-08d7161a3c57
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:MW2PR2101MB0922;
x-ms-traffictypediagnostic: MW2PR2101MB0922:|MW2PR2101MB0922:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <MW2PR2101MB0922AE5652ACA4C32712760AC0DE0@MW2PR2101MB0922.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 01165471DB
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(136003)(39860400002)(396003)(376002)(366004)(346002)(13464003)(199004)(54534003)(189003)(51234002)(7416002)(8936002)(6436002)(55016002)(102836004)(71200400001)(71190400001)(22452003)(2501003)(305945005)(10290500003)(8676002)(478600001)(74316002)(53546011)(110136005)(54906003)(6506007)(68736007)(316002)(186003)(86362001)(7736002)(99286004)(66446008)(76116006)(14454004)(7696005)(66946007)(66556008)(66476007)(4326008)(8990500004)(10090500001)(1511001)(76176011)(64756008)(6246003)(53936002)(5660300002)(14444005)(81166006)(81156014)(229853002)(2906002)(6116002)(33656002)(486006)(256004)(52536014)(446003)(11346002)(25786009)(9686003)(46003)(476003);DIR:OUT;SFP:1102;SCL:1;SRVR:MW2PR2101MB0922;H:MW2PR2101MB1116.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: yPyp+FD0Hozjs8mm1iFTioQ7zOwbyW6EqgRq9ML1/zJ9eXuMY2iuNPKSCZkdvXqPWr+TtTt4hUrsx5+5V0a/BS/rKcJSpMf7OW0N+Z8K2XPIfwF632DIHOxgOnmkZ0O/cbsRW7E0dYiiWnW7NYMNQk1/P20ugnjXKGHCqtU4vpev2bRrOWnklEUy1ezUikhlLfHV8SP6OsS2FP/ig36LG1Ep33hHKQ+zfE8i1qgyX5YYwVw6BuaRtiyhOV/vjwrKFGIZU6RGdzAC63uFl2avUevCqGvHt6ArJynHczuljvPRI+r2QX9jaWydvC1moYqovG/gpV6TRCqQhNj1Dmj9cGrtcUAljT0yg9qgvfe9GNBT/wW4WVnkVhgiwT5A/erMKQAta4LAuteJ7Ua8B8PFoqYE37pgpPZYn2N3efIUZTs=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e0d7fdb9-27de-48fc-da0f-08d7161a3c57
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Aug 2019 00:50:23.1346
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KenzmcgXGl7GO2Td7WiCkyaYNyqYYstIuIXN0tqF56sk4+JoE3CHlqY/V6NsGJlpfXbAp5gQlEW+WEjKS9BfpSN3UPtvcePNNqr9fVqRZcE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR2101MB0922
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Dexuan Cui <decui@microsoft.com>
> Sent: Tuesday, July 30, 2019 6:26 PM
> To: Sunil Muthuswamy <sunilmut@microsoft.com>; David Miller <davem@daveml=
oft.net>; netdev@vger.kernel.org
> Cc: KY Srinivasan <kys@microsoft.com>; Haiyang Zhang <haiyangz@microsoft.=
com>; Stephen Hemminger
> <sthemmin@microsoft.com>; sashal@kernel.org; Michael Kelley <mikelley@mic=
rosoft.com>; linux-hyperv@vger.kernel.org; linux-
> kernel@vger.kernel.org; olaf@aepfle.de; apw@canonical.com; jasowang@redha=
t.com; vkuznets <vkuznets@redhat.com>;
> marcelo.cerri@canonical.com
> Subject: [PATCH v2 net] hv_sock: Fix hang when a connection is closed
>=20
>=20
> There is a race condition for an established connection that is being clo=
sed
> by the guest: the refcnt is 4 at the end of hvs_release() (Note: here the
> 'remove_sock' is false):
>=20
> 1 for the initial value;
> 1 for the sk being in the bound list;
> 1 for the sk being in the connected list;
> 1 for the delayed close_work.
>=20
> After hvs_release() finishes, __vsock_release() -> sock_put(sk) *may*
> decrease the refcnt to 3.
>=20
> Concurrently, hvs_close_connection() runs in another thread:
>   calls vsock_remove_sock() to decrease the refcnt by 2;
>   call sock_put() to decrease the refcnt to 0, and free the sk;
>   next, the "release_sock(sk)" may hang due to use-after-free.
>=20
> In the above, after hvs_release() finishes, if hvs_close_connection() run=
s
> faster than "__vsock_release() -> sock_put(sk)", then there is not any is=
sue,
> because at the beginning of hvs_close_connection(), the refcnt is still 4=
.
>=20
> The issue can be resolved if an extra reference is taken when the
> connection is established.
>=20
> Fixes: a9eeb998c28d ("hv_sock: Add support for delayed close")
> Signed-off-by: Dexuan Cui <decui@microsoft.com>
> Cc: stable@vger.kernel.org
>=20
> ---
>=20
> Changes in v2:
>   Changed the location of the sock_hold() call.
>   Updated the changelog accordingly.
>=20
>   Thanks Sunil for the suggestion!
>=20
>=20
> With the proper kernel debugging options enabled, first a warning can
> appear:
>=20
> kworker/1:0/4467 is freeing memory ..., with a lock still held there!
> stack backtrace:
> Workqueue: events vmbus_onmessage_work [hv_vmbus]
> Call Trace:
>  dump_stack+0x67/0x90
>  debug_check_no_locks_freed.cold.52+0x78/0x7d
>  slab_free_freelist_hook+0x85/0x140
>  kmem_cache_free+0xa5/0x380
>  __sk_destruct+0x150/0x260
>  hvs_close_connection+0x24/0x30 [hv_sock]
>  vmbus_onmessage_work+0x1d/0x30 [hv_vmbus]
>  process_one_work+0x241/0x600
>  worker_thread+0x3c/0x390
>  kthread+0x11b/0x140
>  ret_from_fork+0x24/0x30
>=20
> and then the following release_sock(sk) can hang:
>=20
> watchdog: BUG: soft lockup - CPU#1 stuck for 22s! [kworker/1:0:4467]
> ...
> irq event stamp: 62890
> CPU: 1 PID: 4467 Comm: kworker/1:0 Tainted: G        W         5.2.0+ #39
> Workqueue: events vmbus_onmessage_work [hv_vmbus]
> RIP: 0010:queued_spin_lock_slowpath+0x2b/0x1e0
> ...
> Call Trace:
>  do_raw_spin_lock+0xab/0xb0
>  release_sock+0x19/0xb0
>  vmbus_onmessage_work+0x1d/0x30 [hv_vmbus]
>  process_one_work+0x241/0x600
>  worker_thread+0x3c/0x390
>  kthread+0x11b/0x140
>  ret_from_fork+0x24/0x30
>=20
>  net/vmw_vsock/hyperv_transport.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
>=20
> diff --git a/net/vmw_vsock/hyperv_transport.c b/net/vmw_vsock/hyperv_tran=
sport.c
> index f2084e3f7aa4..9d864ebeb7b3 100644
> --- a/net/vmw_vsock/hyperv_transport.c
> +++ b/net/vmw_vsock/hyperv_transport.c
> @@ -312,6 +312,11 @@ static void hvs_close_connection(struct vmbus_channe=
l *chan)
>  	lock_sock(sk);
>  	hvs_do_close_lock_held(vsock_sk(sk), true);
>  	release_sock(sk);
> +
> +	/* Release the refcnt for the channel that's opened in
> +	 * hvs_open_connection().
> +	 */
> +	sock_put(sk);
>  }
>=20
>  static void hvs_open_connection(struct vmbus_channel *chan)
> @@ -407,6 +412,9 @@ static void hvs_open_connection(struct vmbus_channel =
*chan)
>  	}
>=20
>  	set_per_channel_state(chan, conn_from_host ? new : sk);
> +
> +	/* This reference will be dropped by hvs_close_connection(). */
> +	sock_hold(conn_from_host ? new : sk);
>  	vmbus_set_chn_rescind_callback(chan, hvs_close_connection);
>=20
>  	/* Set the pending send size to max packet size to always get
> --
> 2.19.1

Reviewed-by: Sunil Muthuswamy <sunilmut@microsoft.com>
