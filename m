Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9C6F12D588
	for <lists+netdev@lfdr.de>; Tue, 31 Dec 2019 02:35:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726658AbfLaBfQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Dec 2019 20:35:16 -0500
Received: from mail-bn7nam10on2110.outbound.protection.outlook.com ([40.107.92.110]:28257
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725379AbfLaBfQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Dec 2019 20:35:16 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X+KVGRhAwjSS8SqOUnkf6C6XJ8CZHqY71x7ZWIhc4kEum/VsSPBcyQCkKTPi1KzMawjtEkwa8BfDIZtxoIsXwFXC+2QTHA5k5hBUkSOWqEipjzg3h3sb3N8nHPF9Na2mTw/WfXteyUXq2Ys6cTXvpubz+rEN7U40HOgtg5/MyR8aezKLZO1svNKC5rfwLqOdr1HfkbpnoF93swnp58PPbBds9/YMEsenCAIP8S248uJptoKjDIZkHLVLVy2OR1emxnS/5fmJgRmnExrHr2ePHosSFdwuhE39Zgm9ZyOpct1KVSA0Cko8GU8nzNUPyEDr90e4JB8fw/LJ9XI6OQ5BUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1k9dfFh7ngf2SygoSlsYcbM/hzplUYqyfZU/Gge0dDs=;
 b=ctm91am/eYfDLyN7ezDpBj0Df5f66TZ66m3X0V2AxZ1rhHLOxlxbGiVAvAKc8XxtlbHun0xdRhODS6fuhBPzyV4B3FJoJCbs6RKyccN/3Gg9EaN2yxTkOX+opaPn76PLQiTiFfz5lTbjJa3MSeFHXfJ5hvikbuO/2UAPprCpm9N1WPnuxduZ35c2uZhybnsiDyVxkPuRiFbAuKW1ppASIxXqQCtZvgIjraiqFwVzU+Tf44P4XsItzJb5a1Xv0hsJo3r83QV98eGz8EyvqeBIlvm5a6uEgpGJ6xl4/Xqmyx1qnDzu/M0iHnkpxpXfeZy/KP2IW6iOZhd/wuPrBGYFow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1k9dfFh7ngf2SygoSlsYcbM/hzplUYqyfZU/Gge0dDs=;
 b=hta+4BHdTDEk5LkIpehysztlObHWnL5TUYk74LHu+Gx2DcAxf5Ae5Ok8lgH8h4hwUNk5FSL7j+d/H0Zl7m5O6QJu7UD42JhRoJ9Z1noJc8Va4dzMAPqqWu5cSCQ0qf1shJGPlw+/xKzydirngOhBxi1hQaQ5qwI8UCvpYLymX4I=
Received: from CY4PR21MB0629.namprd21.prod.outlook.com (10.175.115.19) by
 CY4PR21MB0277.namprd21.prod.outlook.com (10.173.193.143) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2602.6; Tue, 31 Dec 2019 01:35:11 +0000
Received: from CY4PR21MB0629.namprd21.prod.outlook.com
 ([fe80::654d:8bdd:471:e0ac]) by CY4PR21MB0629.namprd21.prod.outlook.com
 ([fe80::654d:8bdd:471:e0ac%9]) with mapi id 15.20.2602.010; Tue, 31 Dec 2019
 01:35:11 +0000
From:   Michael Kelley <mikelley@microsoft.com>
To:     Haiyang Zhang <haiyangz@microsoft.com>,
        "sashal@kernel.org" <sashal@kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Haiyang Zhang <haiyangz@microsoft.com>,
        KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "olaf@aepfle.de" <olaf@aepfle.de>, vkuznets <vkuznets@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH V2,net-next, 3/3] hv_netvsc: Name NICs based on vmbus
 offer sequence and use async probe
Thread-Topic: [PATCH V2,net-next, 3/3] hv_netvsc: Name NICs based on vmbus
 offer sequence and use async probe
Thread-Index: AQHVv03JfgxS8TjhIU2t+ATN+XstAafTcfvw
Date:   Tue, 31 Dec 2019 01:35:11 +0000
Message-ID: <CY4PR21MB0629771D2D6FECB76339EFA0D7260@CY4PR21MB0629.namprd21.prod.outlook.com>
References: <1577736814-21112-1-git-send-email-haiyangz@microsoft.com>
 <1577736814-21112-4-git-send-email-haiyangz@microsoft.com>
In-Reply-To: <1577736814-21112-4-git-send-email-haiyangz@microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=mikelley@ntdev.microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2019-12-31T01:35:09.3127531Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=7a2a8dcb-4e6c-4c83-96e4-76533ee43af9;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=mikelley@microsoft.com; 
x-originating-ip: [24.22.167.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 652b60ff-d86c-4706-e3c8-08d78d91ad9f
x-ms-traffictypediagnostic: CY4PR21MB0277:|CY4PR21MB0277:|CY4PR21MB0277:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <CY4PR21MB02773D71FDE7D43FBB9A7DDCD7260@CY4PR21MB0277.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0268246AE7
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(39860400002)(396003)(376002)(346002)(366004)(199004)(189003)(76116006)(10290500003)(8936002)(66476007)(66556008)(66446008)(64756008)(8676002)(4326008)(81166006)(81156014)(52536014)(7696005)(66946007)(26005)(8990500004)(71200400001)(316002)(186003)(86362001)(33656002)(5660300002)(54906003)(478600001)(9686003)(2906002)(6506007)(110136005)(55016002);DIR:OUT;SFP:1102;SCL:1;SRVR:CY4PR21MB0277;H:CY4PR21MB0629.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VSttQQUm44uHpp9vrto4FrHyFc+XMW8juk7enPgwb1QFLM3Z/G7wXp4vUFU5kbpZN8oS4I/Zv2y0Ad6/rgJ/julreBT6NKFTydChhKH224oWdmGY3ohPzXImtd2ffjauEhKWa+OiyjLo1MraNBnfreCAcMH94ZELOxWzgCUyltfbaLo4I6acm1OhXWtcUkvAvEt5m4k9N3tIC6fuHDwgU5PXljwrV1on6QaeSXH1nP4aa8CCWJHs+OXCtdFSyAdEo/8w/QwNb84e8CXDc7CobXHge6fHl2/iVvC1L28ydFE9BFWJBa+Z0QRozTjnMh7+5s0iOspRWCKRBuBZ2IVQaig4aUU6Yax1q1/7QuHo5WYNIypW4KHk/3IzmtlaC7Rngk3Uf6UkVF8rxOBxLGkubmFfTEGsIA+VQXH9CjOK+Og3G58dRGFHJrMK3G8AmXB4
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 652b60ff-d86c-4706-e3c8-08d78d91ad9f
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Dec 2019 01:35:11.7126
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dKGCk2NK1RlBGpjTuSecu/BHZ7EhwzDJJccgk9QGn0kRyHA6HW3jbNPflLHvnYOj5m4q1u7nhefnP3ZzDBTseqBoupPC4o5Cs8xWmYK9NjM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR21MB0277
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Haiyang Zhang <haiyangz@microsoft.com> Sent: Monday, December 30, 201=
9 12:14 PM
>=20
> The dev_num field in vmbus channel structure is assigned to the first

Let's use "VMBus" in text.

> available number when the channel is offered. So netvsc driver uses it
> for NIC naming based on channel offer sequence. Now re-enable the async
> probing mode for faster probing.
>=20
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> ---
>  drivers/net/hyperv/netvsc_drv.c | 18 +++++++++++++++---
>  1 file changed, 15 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_=
drv.c
> index f3f9eb8..39c412f 100644
> --- a/drivers/net/hyperv/netvsc_drv.c
> +++ b/drivers/net/hyperv/netvsc_drv.c
> @@ -2267,10 +2267,14 @@ static int netvsc_probe(struct hv_device *dev,
>  	struct net_device_context *net_device_ctx;
>  	struct netvsc_device_info *device_info =3D NULL;
>  	struct netvsc_device *nvdev;
> +	char name[IFNAMSIZ];
>  	int ret =3D -ENOMEM;
>=20
> -	net =3D alloc_etherdev_mq(sizeof(struct net_device_context),
> -				VRSS_CHANNEL_MAX);
> +	snprintf(name, IFNAMSIZ, "eth%d", dev->channel->dev_num);
> +	net =3D alloc_netdev_mqs(sizeof(struct net_device_context), name,
> +			       NET_NAME_ENUM, ether_setup,
> +			       VRSS_CHANNEL_MAX, VRSS_CHANNEL_MAX);
> +
>  	if (!net)
>  		goto no_net;
>=20
> @@ -2355,6 +2359,14 @@ static int netvsc_probe(struct hv_device *dev,
>  		net->max_mtu =3D ETH_DATA_LEN;
>=20
>  	ret =3D register_netdevice(net);
> +
> +	if (ret =3D=3D -EEXIST) {
> +		pr_info("NIC name %s exists, request another name.\n",
> +			net->name);
> +		strlcpy(net->name, "eth%d", IFNAMSIZ);
> +		ret =3D register_netdevice(net);

The message above could be confusing.  "request another name" sounds
like a directive to the user/sysadmin, which I don't think it is.  Perhaps
better would be "requesting another name", which says the system is
handling the collision automatically.

Also will this second call to register_netdevice() actually assign a numeri=
c
name?  If so, it would be really nice for the message to be output *after*
the second call to register_netdevice() and to show both the originally
selected name that collided as well as the new name.  We sometimes get
into NIC naming issues with customers in Azure, and when a new name
has to be selected it will help debugging if we can show both the original
selection and the new selection.  With both pieces of data, there's less
guessing about who did what regarding NIC naming.

Finally, having to choose a different name because of a collision does
*not* update the channel->dev_num value.  Subsequent calls to=20
hv_set_devnum() will detect "in use" based on the originally assigned
dev_num value.  I don't think that fundamentally breaks anything, but
I wondered if you had thought about that case.   Maybe a comment here
to that effect would help a future reader of this code.

Michael

> +	}
> +
>  	if (ret !=3D 0) {
>  		pr_err("Unable to register netdev.\n");
>  		goto register_failed;
> @@ -2496,7 +2508,7 @@ static int netvsc_resume(struct hv_device *dev)
>  	.suspend =3D netvsc_suspend,
>  	.resume =3D netvsc_resume,
>  	.driver =3D {
> -		.probe_type =3D PROBE_FORCE_SYNCHRONOUS,
> +		.probe_type =3D PROBE_PREFER_ASYNCHRONOUS,
>  	},
>  };
>=20
> --
> 1.8.3.1

