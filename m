Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BF26791F4
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 19:21:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387600AbfG2RVH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 13:21:07 -0400
Received: from mail-eopbgr810091.outbound.protection.outlook.com ([40.107.81.91]:17728
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725934AbfG2RVH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jul 2019 13:21:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JSyxdu1aZ0af82NUG33cvTT3ch9Om3WqKfqEx59e4jPO8g45FU9sMN4+WFqSTBRdb0qCCpNT91boxq3DKGMbFq+wXeq4oPbsj1fBYd5pYIghN4v2YWp7Iyz2GJo03c8GR5feudGH5T4QqcPM4bbCR+KH8uvwzj8Oa4/KODQ2uGm9VbnPukP47d7tpJJHCf+poM3XMEuTs1dlfTpHYJ8jQ806RS0pp6IblSqse7j5lIVg0CE9VBRNuXoGbpGZljTNP+2kN7841IQ6jVSLFjbWCkcCFxunnss1YshjPbbvaYheaw43tRJuxZ5Iez0KVvR3o62JxlxlI3Y/+EvFDVWYXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6yu7YE/YEsvcBZdYifqxdyRGyHJTFiegxWZ1xs2ehSg=;
 b=Wxd6WWu/oHdHaJCOExY9ipWOmrxYf3/I34SLQH7o3pcDk/coQrdD5oF3jPDjZGfUhIY2sd4Yv9Thhfx1Cl83T01Uy7mZmHJH2H/931ad+nBhQjx2DkG0ossVojhFOK0X/aggYVRO8Npp0kJeJmH/ZC1HujuVGf1Jq+Nd7tPxZQRI92B6aHWEv9l1wI8fe4sHvPIcL06euVdsxXes35r+uqJvPNw17Fa+12OYqUOkOxoXO41VRof3Y6rLzbCoTiSDffRsQBcD9N4R4Tlqo0qVU41OiVo6vixq3Wlf1KQBffjdIidGiYY7Sb6eIT6/HjdY4RgZtbBXWse+HyU1dMZACQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=microsoft.com;dmarc=pass action=none
 header.from=microsoft.com;dkim=pass header.d=microsoft.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6yu7YE/YEsvcBZdYifqxdyRGyHJTFiegxWZ1xs2ehSg=;
 b=TNJ8kLilud+eG+Lxzh4aazpxuf9mQq4lA7XaQtPuqRxZuy3dtRAwwiA93j3ufjKinlpDpC5v3+rjU+atG1qLuOY4SQbm1OHWJtr5U9KeA6eDWcrap7pVX7oFlr1YAYSHhjUWY3I2mkCVmjfCKc8RSvKTg43L8FERRXtxVv1RPkw=
Received: from MW2PR2101MB1116.namprd21.prod.outlook.com (52.132.149.33) by
 MW2PR2101MB0939.namprd21.prod.outlook.com (52.132.146.12) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2136.3; Mon, 29 Jul 2019 17:21:02 +0000
Received: from MW2PR2101MB1116.namprd21.prod.outlook.com
 ([fe80::bc7c:35c:7094:2c9c]) by MW2PR2101MB1116.namprd21.prod.outlook.com
 ([fe80::bc7c:35c:7094:2c9c%7]) with mapi id 15.20.2157.001; Mon, 29 Jul 2019
 17:21:02 +0000
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
Subject: RE: [PATCH net] hv_sock: Fix hang when a connection is closed
Thread-Topic: [PATCH net] hv_sock: Fix hang when a connection is closed
Thread-Index: AdVFcLBEQpsBKkdqRUGheyyiHS7XPAAwF1FQ
Date:   Mon, 29 Jul 2019 17:21:02 +0000
Message-ID: <MW2PR2101MB1116DC8461F1B02C232019E2C0DD0@MW2PR2101MB1116.namprd21.prod.outlook.com>
References: <PU1P153MB01690A7767ECDF420FF78D66BFC20@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
In-Reply-To: <PU1P153MB01690A7767ECDF420FF78D66BFC20@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
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
 smtp.mailfrom=sunilmut@microsoft.com; 
x-originating-ip: [2001:4898:80e8:0:3c44:d1ed:b2c2:4ed2]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 54b87845-3a2d-4a29-16fb-08d714492190
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:MW2PR2101MB0939;
x-ms-traffictypediagnostic: MW2PR2101MB0939:|MW2PR2101MB0939:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <MW2PR2101MB093913C08B724403EDB9980AC0DD0@MW2PR2101MB0939.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 01136D2D90
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(376002)(39860400002)(346002)(136003)(396003)(366004)(51234002)(189003)(199004)(13464003)(55016002)(316002)(7416002)(486006)(476003)(14454004)(229853002)(71190400001)(446003)(25786009)(22452003)(9686003)(305945005)(86362001)(110136005)(10090500001)(52536014)(2906002)(54906003)(71200400001)(11346002)(74316002)(8990500004)(81156014)(66476007)(68736007)(66446008)(64756008)(99286004)(256004)(14444005)(4326008)(76116006)(66556008)(53936002)(8936002)(6246003)(66946007)(33656002)(46003)(81166006)(6506007)(53546011)(76176011)(5660300002)(6436002)(102836004)(7736002)(186003)(8676002)(2501003)(1511001)(478600001)(7696005)(10290500003)(6116002);DIR:OUT;SFP:1102;SCL:1;SRVR:MW2PR2101MB0939;H:MW2PR2101MB1116.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: /t7iVFFyNg4ygMUayWaPc9S8mW7UwhRc+/kOmf17wh6FOKCUfrfkUYpgHYuJJjcuyx8ZjRY2+ArPAnGQxLxWD08LXvJLK7TCtDI5gVhffc9l1zLNCx8HJ8R/oNmBQV+3mK2V+ux8oDid/CZkiqbIz1opv5BCm48SDAInJm5E1cJbq9AsUvANUfSvgPr9GyTFhs2NN5Be/bkzA8o7UP54vJNUBE5KGe7dnoKHC4AvNAbXwYmybKuKsXpdslZvrBoHY66ZEEMTmfz7FYZarxnTBDAvsiMsqzfC5zuak5/LdcaMYLx2cLW5DiHOfJIhd3xkJlOWkWWTlpObpSplLX5Usu1jWrpPjBL9HiFenkWMfXhWpadtgMe1O1D+xDiaj67dL6r3wCbl+O5/roLuwwLdgPPoM5gJEpVV3gBZwCWp6vc=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 54b87845-3a2d-4a29-16fb-08d714492190
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jul 2019 17:21:02.3334
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +k4yMVDDQt39SHK+fI2N8INSk7JQQ58M/ONdtjsex3fX/jz9FxqiMsB2X2NVcM+FeRAHU9FAs07IX4KU0Sy+xaDDHpgkPEDdYghj4VjygoU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR2101MB0939
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Dexuan Cui <decui@microsoft.com>
> Sent: Sunday, July 28, 2019 11:32 AM
> To: Sunil Muthuswamy <sunilmut@microsoft.com>; David Miller <davem@daveml=
oft.net>; netdev@vger.kernel.org
> Cc: KY Srinivasan <kys@microsoft.com>; Haiyang Zhang <haiyangz@microsoft.=
com>; Stephen Hemminger
> <sthemmin@microsoft.com>; sashal@kernel.org; Michael Kelley <mikelley@mic=
rosoft.com>; linux-hyperv@vger.kernel.org; linux-
> kernel@vger.kernel.org; olaf@aepfle.de; apw@canonical.com; jasowang@redha=
t.com; vkuznets <vkuznets@redhat.com>;
> marcelo.cerri@canonical.com
> Subject: [PATCH net] hv_sock: Fix hang when a connection is closed
>=20
>=20
> hvs_do_close_lock_held() may decrease the reference count to 0 and free t=
he
> sk struct completely, and then the following release_sock(sk) may hang.
>=20
> Fixes: a9eeb998c28d ("hv_sock: Add support for delayed close")
> Signed-off-by: Dexuan Cui <decui@microsoft.com>
> Cc: stable@vger.kernel.org
>=20
> ---
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
>  net/vmw_vsock/hyperv_transport.c | 7 +++++++
>  1 file changed, 7 insertions(+)
>=20
> diff --git a/net/vmw_vsock/hyperv_transport.c b/net/vmw_vsock/hyperv_tran=
sport.c
> index f2084e3f7aa4..efbda8ef1eff 100644
> --- a/net/vmw_vsock/hyperv_transport.c
> +++ b/net/vmw_vsock/hyperv_transport.c
> @@ -309,9 +309,16 @@ static void hvs_close_connection(struct vmbus_channe=
l *chan)
>  {
>  	struct sock *sk =3D get_per_channel_state(chan);
>=20
> +	/* Grab an extra reference since hvs_do_close_lock_held() may decrease
> +	 * the reference count to 0 by calling sock_put(sk).
> +	 */
> +	sock_hold(sk);
> +

To me, it seems like when 'hvs_close_connection' is called, there should al=
ways be
an outstanding reference to the socket. The reference that is dropped by
' hvs_do_close_lock_held' is a legitimate reference that was taken by 'hvs_=
close_lock_held'.
Or, in other words, I think the right solution is to always maintain a refe=
rence to socket
until this routine is called and drop that here. That can be done by taking=
 the reference to
the socket prior to ' vmbus_set_chn_rescind_callback(chan, hvs_close_connec=
tion)' and
dropping that reference at the end of 'hvs_close_connection'.

>  	lock_sock(sk);
>  	hvs_do_close_lock_held(vsock_sk(sk), true);
>  	release_sock(sk);
> +
> +	sock_put(sk);
>  }
>=20
>  static void hvs_open_connection(struct vmbus_channel *chan)
> --
> 2.19.1

Thanks for taking a look at this. We should queue this fix and the other hv=
socket fixes
for the stable branch.
