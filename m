Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09DA58284C
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 01:56:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731031AbfHEXz4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 19:55:56 -0400
Received: from mail-eopbgr1320128.outbound.protection.outlook.com ([40.107.132.128]:20557
        "EHLO APC01-PU1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728483AbfHEXz4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Aug 2019 19:55:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P1RdAm6HfpAWD0NcjLmkiIn//yITTzfFlEl9Xkh00JbiZf7tR8BwplZuOISw+7L0oTWya0oZ0j1e00+1km7SW4j42nYieQZAq1LrL0xtf5Aw8hhlf3KNlpd3j0RZnO903Fko8187BrKFgKVF3uNWvzpJ6cK3RX8DX/JE+kNLVe2yA1fwbbhubSu93uqpT0ysOoYBEkRRD1W7Jt0eYmSVat31bOymZrjUfRCS0XD1lcz7YOLOOlUz7XHvakT6J+9rQkOPEsB7odHxvWoNwqnKe9IORahZelobzW6Y49zd9kx3WQkgOQlR+JHw07SsIfSklYKgJR+ITABYAMVjxtxVBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5gTZ5ZZD63ZifUDMQygz2r+KVwTABQE++Oq/DRGLRFo=;
 b=BxDawDzaw8LU4fC+ZfQTj9KPNMNoAIpXJzBXKK9KEPg3XIFcEGVW4LrtRmEfllw/ReKOmxpJMcffU6qTEOzBX1JKf47unSjA5ktVsufQ2HedFpY4Byc3Llo4Vjouo8UzW/JNVsM5VHGsTiE5THMe/fSgYzR/+6Nsk5XOyp4MgRdTlFR1RC4yjo3R1ZZT/DAi7eM6e9KFOYC2bxPA7Ijp6H+Jkju92nvj7k2MPGHlz8/ADemU4ocByxDvYg1GIZMNZctvGkoUNUURqg5qJfqzIvLnKMPtX/mAQ6eqA1M7aJ2ZRYekzUSgyJSr7Zgw98eeFMAgdfUeErwxJ4+eZjgDgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5gTZ5ZZD63ZifUDMQygz2r+KVwTABQE++Oq/DRGLRFo=;
 b=Uo12q3Bd/WCYZ2KXxOxbIQPeY0Kyk0L6X7V5hZi7bWKYyF38+1FyIcaeDwMiqy+/cmi1C7WOl40mx514qUeymHZiHzFxMy8y/8yrOCD8c8zLtBxD4fsvj27ZUqkG3BmVI9pDNsNeG5CbwqykSDE2HcnEpCywsOX1LAu/LQbTAf4=
Received: from PU1P153MB0169.APCP153.PROD.OUTLOOK.COM (10.170.189.13) by
 PU1P153MB0169.APCP153.PROD.OUTLOOK.COM (10.170.189.13) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.2; Mon, 5 Aug 2019 23:55:47 +0000
Received: from PU1P153MB0169.APCP153.PROD.OUTLOOK.COM
 ([fe80::d44e:57b7:d8fc:e91c]) by PU1P153MB0169.APCP153.PROD.OUTLOOK.COM
 ([fe80::d44e:57b7:d8fc:e91c%7]) with mapi id 15.20.2157.001; Mon, 5 Aug 2019
 23:55:47 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Yidong Ren <Yidong.Ren@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>
CC:     "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>
Subject: hv_netvsc: WARNING: suspicious RCU usage?
Thread-Topic: hv_netvsc: WARNING: suspicious RCU usage?
Thread-Index: AdVK97JbsdQk75jSTeGC/HNWaEL3qg==
Date:   Mon, 5 Aug 2019 23:55:47 +0000
Message-ID: <PU1P153MB0169B7073A4865D50AED9EE5BFDA0@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=decui@microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2019-08-05T23:55:44.4679731Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=1a064ef1-8d65-41ee-93fc-f62f22dbc6b5;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=decui@microsoft.com; 
x-originating-ip: [2001:4898:80e8:1:821c:4530:43a5:69ff]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 22bb41f6-8081-4793-5b9a-08d71a006fcd
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:PU1P153MB0169;
x-ms-traffictypediagnostic: PU1P153MB0169:|PU1P153MB0169:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PU1P153MB016930A71E8B7BF63C3505E5BFDA0@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 01208B1E18
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(366004)(136003)(346002)(39860400002)(396003)(376002)(199004)(189003)(2906002)(71200400001)(66556008)(102836004)(22452003)(478600001)(8990500004)(66476007)(316002)(110136005)(6506007)(6436002)(52536014)(55016002)(256004)(10290500003)(305945005)(81166006)(81156014)(9686003)(76116006)(5660300002)(8936002)(14454004)(8676002)(33656002)(68736007)(7696005)(186003)(10090500001)(7736002)(74316002)(14444005)(476003)(2501003)(66446008)(64756008)(25786009)(53936002)(6116002)(86362001)(99286004)(1511001)(486006)(46003)(71190400001)(66946007)(4326008);DIR:OUT;SFP:1102;SCL:1;SRVR:PU1P153MB0169;H:PU1P153MB0169.APCP153.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: YlK8YV0XQgdx5ZaOq/smPbyHFnscfFjMVSKgfzxwiwvWNvLsi7i2gBw3jj4P/aV5TVQPZiail/El5l1EHTrxZ5zJDkw7SI1JJ8mUP1BNs9UeZy3rxY8NhENZELN8w7P26+XBF3rGSvNAQSRhtckA2Ym7UN0we1v0PAF/aKx99T47bFAQzj5HzyaIc4dlzajOUJV5o+YFaw+iEr8N9rHRFte8aAUT/lzqjp66GcDnysfFV8HOlBgS/zEjNHB0KRXDoxkqvkDUTcFvQmnhJHC5L2fUedgiBqvWAq1B4s06jmL4TQL4YRlxcgbmCIgjqLIwu358Oq4aEzSl3mkCzT2MJvSr3CLMG85sWO8EBNoxQBwkmITNoeSXAl0WOEyswm5EImQeQpWZRrvaoVgYgbAAvy5qxXhGpsNPbu1+SjrGfew=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22bb41f6-8081-4793-5b9a-08d71a006fcd
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Aug 2019 23:55:47.0558
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TBWHflb/vnxUVID0fkhn4qzY9zYTpRM+UoOjY8E+70EL11VIZDjl6xm9XI0TdKvjIMop6Xu/Ko6Q0q0rmUmkjg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PU1P153MB0169
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,
After the VM boots up, I always get the below call-trace when I run "nload"=
 for the first time:

[  113.910911] WARNING: suspicious RCU usage
[  113.913244] 5.2.0+ #19 Not tainted
[  113.915216] -----------------------------
[  113.917521] drivers/net/hyperv/netvsc_drv.c:1243 suspicious rcu_derefere=
nce_check() usage!
[  113.922191]
[  113.922191] other info that might help us debug this:
[  113.926573]
[  113.926573] rcu_scheduler_active =3D 2, debug_locks =3D 1
[  113.930052] 4 locks held by nload/1977:
[  113.932251]  #0: 0000000080b71e86 (&p->lock){+.+.}, at: seq_read+0x41/0x=
3d0
[  113.936115]  #1: 00000000cacff770 (&of->mutex){+.+.}, at: kernfs_seq_sta=
rt+0x2a/0x90
[  113.940115]  #2: 00000000287c988f (kn->count#134){.+.+}, at: kernfs_seq_=
start+0x32/0x90
[  113.944292]  #3: 00000000996fa9cc (dev_base_lock){++.+}, at: netstat_sho=
w.isra.25+0x4a/0xb0
[  113.958076]
[  113.958076] stack backtrace:
[  113.958081] CPU: 3 PID: 1977 Comm: nload Not tainted 5.2.0+ #19
[  113.958083] Hardware name: Microsoft Corporation Virtual Machine/Virtual=
 Machine, BIOS 090006  04/28/2016
[  113.958084] Call Trace:
[  113.958091]  dump_stack+0x67/0x90
[  113.973663]  netvsc_get_stats64+0x159/0x170 [hv_netvsc]
[  113.973663]  dev_get_stats+0x55/0xb0
[  113.973663]  netstat_show.isra.25+0x5b/0xb0
[  113.973663]  dev_attr_show+0x15/0x40
[  113.981661]  sysfs_kf_seq_show+0xad/0xf0
[  113.981661]  seq_read+0x146/0x3d0
[  113.981661]  vfs_read+0x9c/0x160
[  113.989025]  ksys_read+0x5c/0xd0
[  113.989025]  do_syscall_64+0x5e/0x220
[  113.989025]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[  113.989025] RIP: 0033:0x7f4485daaf31

nload is a console application which monitors network traffic and bandwidth=
 usage in real time.

The warning is caused by the rcu_dereference_rtnl() :

1239 static void netvsc_get_stats64(struct net_device *net,
1240                                struct rtnl_link_stats64 *t)
1241 {
1242         struct net_device_context *ndev_ctx =3D netdev_priv(net);
1243         struct netvsc_device *nvdev =3D rcu_dereference_rtnl(ndev_ctx-=
>nvdev);

I think here netvsc_get_stats64() neither holds rcu_read_lock() nor RTNL

IMO it should call rcu_read_lock()/unlock(), or get RTNL to fix the warning=
?

Thanks,
-- Dexuan

