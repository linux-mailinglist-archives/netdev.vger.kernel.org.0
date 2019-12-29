Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0C1412BFD9
	for <lists+netdev@lfdr.de>; Sun, 29 Dec 2019 02:23:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726378AbfL2BXq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Dec 2019 20:23:46 -0500
Received: from mail-dm6nam10on2105.outbound.protection.outlook.com ([40.107.93.105]:52435
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726187AbfL2BXq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 28 Dec 2019 20:23:46 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UIVweq+bTF3J0qDrEcz/UPrSQspvDxKMww448jWNKQO3xgxWQ4bZUPzNQORUZvJibGFUhBuR7aeMcjGBm65fd8FnmMw9Ntsf3v2MMMuyELcsrIXwIVIMcPX9+4RoN9MGe1Ojn6IRAthefZs1RIgeOgEqW/YhKcstqyKZ27Pfd0FohMtFycg47kRLKP2TRGtTdIKFfN/69AXWNmJOfglKL5VLiqB9oUCYb90MYw8tnFX/dfgu4KbV/ilctorp4V71pDNSbfkRh31WgA8luxDsodfKc5m39/4+h4vIHzVBy0Dq8x+PyRyJNMGP07sEtvmVsCEDPN4+9xTF+KVBQPSDyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wvuvWvswlAodDkgEWrh9GPcG7I/KKBSDPx7qZizFTOo=;
 b=cIHgBbSxwM1f0dAlHA13IaqNvIHeJnDUHPmPOFcxMu0BuPMR1CmdBMjdefJA0YU+RXAPALl4n7/17AFunU5q7cUQpQF2SVV8JKVp4PE4E6kmSyInUHFWl002YgHDdBpl/Inm/GO1Q12TLj71a49opGpkeIOXcSn+VZa3/Wd8rsXkDiurEHGgbd3zJRuEY9o5rvRhSVQT5kGvVJkjW6pIHi0Qr6JJx3XhKCZLnPrjuuVnQw8h88bnak5NToYPrMcoQ5DuPiZtMaSVYK+4S+zLxxdAiu6HnL9u3zBreAKL2fJVIB3nGvBmlE/oiovS+pWKC/V7Unk1HsaVoxKHmytwHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wvuvWvswlAodDkgEWrh9GPcG7I/KKBSDPx7qZizFTOo=;
 b=M2Ndw+wxmTTez8e7fJ+bs81gFHg4qoubqype2kAfPelCO4MAhb7sYAKh4wH3NaR3rLBW1W5ypAOjIGn76i84gf/W5o8QXyt+Kz+iCsfapsZ7F/ZMRNxWQ+F92MahzNsZmCIOvkLQ8sJH5JI8oY9MDj0aHAssF5Y8OmLRDPj+7gc=
Received: from MN2PR21MB1375.namprd21.prod.outlook.com (20.179.23.160) by
 MN2PR21MB1373.namprd21.prod.outlook.com (20.179.21.155) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2602.6; Sun, 29 Dec 2019 01:23:39 +0000
Received: from MN2PR21MB1375.namprd21.prod.outlook.com
 ([fe80::d15a:1864:efcd:6215]) by MN2PR21MB1375.namprd21.prod.outlook.com
 ([fe80::d15a:1864:efcd:6215%8]) with mapi id 15.20.2602.009; Sun, 29 Dec 2019
 01:23:39 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
CC:     "sashal@kernel.org" <sashal@kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "olaf@aepfle.de" <olaf@aepfle.de>, vkuznets <vkuznets@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next, 3/3] hv_netvsc: Name NICs based on vmbus offer
 sequence and use async probe
Thread-Topic: [PATCH net-next, 3/3] hv_netvsc: Name NICs based on vmbus offer
 sequence and use async probe
Thread-Index: AQHVvdkl/zsjLRjZ6kenAd68dpspsKfQPdgAgAAPEtA=
Date:   Sun, 29 Dec 2019 01:23:39 +0000
Message-ID: <MN2PR21MB13754551735F3F2A3639D269CA240@MN2PR21MB1375.namprd21.prod.outlook.com>
References: <1577576793-113222-1-git-send-email-haiyangz@microsoft.com>
        <1577576793-113222-4-git-send-email-haiyangz@microsoft.com>
 <20191228161318.4501bb79@hermes.lan>
In-Reply-To: <20191228161318.4501bb79@hermes.lan>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=haiyangz@microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2019-12-29T01:23:38.1840817Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=ff143648-f089-42a1-a556-6962c426d605;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=haiyangz@microsoft.com; 
x-originating-ip: [96.61.92.94]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 604cdb14-f510-4678-96f1-08d78bfdbc2c
x-ms-traffictypediagnostic: MN2PR21MB1373:|MN2PR21MB1373:|MN2PR21MB1373:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <MN2PR21MB1373081B1BCBCB42CB60B214CA240@MN2PR21MB1373.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0266491E90
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(136003)(346002)(376002)(396003)(39860400002)(189003)(199004)(13464003)(478600001)(2906002)(64756008)(81166006)(81156014)(6916009)(8990500004)(66946007)(7696005)(8936002)(76116006)(66446008)(66476007)(4326008)(66556008)(54906003)(5660300002)(186003)(33656002)(55016002)(6506007)(26005)(9686003)(86362001)(10290500003)(316002)(52536014)(8676002)(53546011)(71200400001);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR21MB1373;H:MN2PR21MB1375.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kpXwTy/u5+xjbA1DEXc1IfJJfqve/PwIhNLBdF0kS7aKT/zBvYBM+C4BU/AYS1amIiV5f51xQR8Kq0pYFtY68QKS2oke6j8rB/2N8gNUXbLNG221+Afp/4SGJ8Cpo4yZH7BNspgYF7mMYFcXTTLDgJFdxFMiQncQoTu5+uJTgJrWxm+ubhxfh5ra/TpBxlb0sQqsx/qzEkKMxmWC66jmw99oyrqXPdz6+Ku+gA1SwtM1lR2uxfxJYlzvDAiDBhvawp/u0dW68FO7neQe9KNOmM1q5hjynjg4C2q1UJ6S6n6HPxzHGf4ME3PzqhPjudlBb17/rtGdp9jkOVTHGAZOdLCPcQ+TH4qgIqXGeqdit8Hsha6uBH42BPV8Z+pxhYQTyUfffhDiAw+pYuSHS4oyFKiaBZ1SlyYASIaU+n/GJMvlEDCUcRbssV1lhydotNNU3gMGO/I6DYCqubTS9KvxHzY72CzwIhbHmUX0/Pt1WSb6bWUwKzMf6dVSJ/755lVA
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 604cdb14-f510-4678-96f1-08d78bfdbc2c
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Dec 2019 01:23:39.5097
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nAvnuOXC/l7QfW0im1w1fUPoAWw9FMVaT29BvG6bGPnR4tsLU7eFL9gFbPdF7RgJHv+emQljNNBwF2j29x5ojw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR21MB1373
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Stephen Hemminger <stephen@networkplumber.org>
> Sent: Saturday, December 28, 2019 7:13 PM
> To: Haiyang Zhang <haiyangz@microsoft.com>
> Cc: sashal@kernel.org; linux-hyperv@vger.kernel.org; netdev@vger.kernel.o=
rg;
> KY Srinivasan <kys@microsoft.com>; Stephen Hemminger
> <sthemmin@microsoft.com>; olaf@aepfle.de; vkuznets
> <vkuznets@redhat.com>; davem@davemloft.net; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH net-next, 3/3] hv_netvsc: Name NICs based on vmbus of=
fer
> sequence and use async probe
>=20
> On Sat, 28 Dec 2019 15:46:33 -0800
> Haiyang Zhang <haiyangz@microsoft.com> wrote:
>=20
> > -	net =3D alloc_etherdev_mq(sizeof(struct net_device_context),
> > -				VRSS_CHANNEL_MAX);
> > +	snprintf(name, IFNAMSIZ, "eth%d", dev->channel->dev_num);
> > +	net =3D alloc_netdev_mqs(sizeof(struct net_device_context), name,
> > +			       NET_NAME_ENUM, ether_setup,
> > +			       VRSS_CHANNEL_MAX, VRSS_CHANNEL_MAX);
> > +
>=20
> Naming is a hard problem, and best left to userspace.
> By choosing ethN as a naming policy, you potentially run into naming
> conflicts with other non netvsc devices like those passed through or
> SR-IOV devices.
If the dev_num based naming conflicts with existing device, it will fall ba=
ck to=20
the previous scheme: "choose the next available eth* name by specifying eth=
%d".
See the fall back code path below:
        if (ret =3D=3D -EEXIST) {
                pr_info("NIC name %s exists, request another name.\n",
                        net->name);
                strlcpy(net->name, "eth%d", IFNAMSIZ);
                ret =3D register_netdevice(net);
        }


> Better to have udev use dev_num and use something like envN or something.
> Udev also handles SRIOV devices in later versions.
>=20
> Fighting against systemd, netplan, etc is not going to be make friends.

When netvsc was initially created, it uses "seth*" naming. But with strong =
requests=20
from many customers, we switched back to the regular "eth*" naming format.

The results of using dev_num based "eth*" names is same as what we are doin=
g now --
The existing synchronous probing already generates "eth*" based on channel =
offer
sequence. With my patch, it still generates the same naming, but with async=
hronous
probing.

So all the udev, or other user daemons, sees the same name for each device =
as before.=20
And, they can still set these names like what they do today.

Thanks,
- Haiyang

