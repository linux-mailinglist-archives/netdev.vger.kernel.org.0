Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1874C12F303
	for <lists+netdev@lfdr.de>; Fri,  3 Jan 2020 03:41:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727323AbgACClT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jan 2020 21:41:19 -0500
Received: from mail-mw2nam12on2111.outbound.protection.outlook.com ([40.107.244.111]:6208
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726089AbgACClS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Jan 2020 21:41:18 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iq1Kil9TjaYrRAfdlpG05bmfrd5gmI8JogSgCfdQ3XLqIelWHbIhyoXAyMUi6vYyU3T5+ZkQMtvrAhUNvIhEBJu3mCZrDvleOFNUrJrrJsHjnA05raQurZzbr4ENfbWnEkKEKXBuPkZeRm1IjJdvZLmBkmIP6ETi1/TDrOqg5UCXSu+5P2XxbCaJEaTKMja0fI0n/XldDcI+UQ+zA+pAnPoasUyItVGwnfwdepVYzcBOz8JWp+pvpNk0xj6VC/CDnU7ckwPahwCAEoNMwVWeYmY9B1Q9KqUCyrCpzl5W5o9ErdLD9/Wf4qBmLaU/Di0AkH2LAgiC7RuQrKWU8aCZAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KtRQ+woOgSKSpq1Y/GPn5WSWeBpsUYFNTrJCt1MuBrA=;
 b=Yv3Jcx4oaqW82MVjc83pZnr3oGEswFZXlFDyIzF6RHOPGPKlb2lywqk9TTJXB/bEGy33hKfQPWC+rLXMdG0+rH9rkYa8UaHzv8tReeTFtFoDaZCgQQ2yipiUm+TxH517J0syDhbsv5PZKNXWXrlF1HVD99GixaYJtMG/kuICJhX9x3KM3X1ff8305FFNCeZeE7lxJaYKWX4aJcjzbLi9nRalbB3pvOlcF826RolDg5iIThI+isK24PSzP0ePIpYi+KaBHhidmO9CwvPhIHjsDb4rry53dLERorVRU0+VmLO/atXWbbaT1g2cfKDzLM9nc/IosW+aVdyT8jaAHQOe+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KtRQ+woOgSKSpq1Y/GPn5WSWeBpsUYFNTrJCt1MuBrA=;
 b=iGnRspGmUN+hfFHHeCFoCCVoQG1Hxxlv6IBdzNgmzeaaL9xwWMVuSDbUFnOvTgYd4rIdlXqJh3OjPh885ei9q37XVkqsxek7fR1qFF8CHYF7FDDgCCjYdFaRFFugCdhuCuIeEcOS6Gn7gHMHgiJfvVd+Uu1MCN6HmHmZZhyOmCs=
Received: from MN2PR21MB1375.namprd21.prod.outlook.com (20.179.23.160) by
 MN2PR21MB1406.namprd21.prod.outlook.com (20.180.26.202) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.1; Fri, 3 Jan 2020 02:41:12 +0000
Received: from MN2PR21MB1375.namprd21.prod.outlook.com
 ([fe80::6de3:c062:9e55:ffc4]) by MN2PR21MB1375.namprd21.prod.outlook.com
 ([fe80::6de3:c062:9e55:ffc4%5]) with mapi id 15.20.2623.002; Fri, 3 Jan 2020
 02:41:12 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     David Miller <davem@davemloft.net>
CC:     "sashal@kernel.org" <sashal@kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "olaf@aepfle.de" <olaf@aepfle.de>, vkuznets <vkuznets@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH V3,net-next, 0/3] Add vmbus dev_num and allow netvsc probe
 options
Thread-Topic: [PATCH V3,net-next, 0/3] Add vmbus dev_num and allow netvsc
 probe options
Thread-Index: AQHVwCepyoALlUMkVESHJGSoiaYPr6fYGXeAgAAZPMA=
Date:   Fri, 3 Jan 2020 02:41:12 +0000
Message-ID: <MN2PR21MB1375E1485B7A09D87A7EED0DCA230@MN2PR21MB1375.namprd21.prod.outlook.com>
References: <1577830414-119508-1-git-send-email-haiyangz@microsoft.com>
 <20200102.162941.1933071871521624803.davem@davemloft.net>
In-Reply-To: <20200102.162941.1933071871521624803.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=haiyangz@microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2020-01-03T02:41:10.6426679Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=d4522d5c-019b-4149-8b3a-6cc1a691747c;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=haiyangz@microsoft.com; 
x-originating-ip: [96.61.92.94]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: dd2d02b1-2087-43ed-7a93-08d78ff66595
x-ms-traffictypediagnostic: MN2PR21MB1406:|MN2PR21MB1406:|MN2PR21MB1406:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <MN2PR21MB1406EE5C486E3BE579685427CA230@MN2PR21MB1406.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0271483E06
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(39860400002)(396003)(376002)(366004)(136003)(13464003)(189003)(199004)(55016002)(81156014)(81166006)(9686003)(8676002)(6916009)(186003)(26005)(54906003)(10290500003)(53546011)(66446008)(6506007)(478600001)(33656002)(316002)(4326008)(8990500004)(5660300002)(76116006)(52536014)(66556008)(66946007)(2906002)(86362001)(66476007)(8936002)(7696005)(64756008)(71200400001);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR21MB1406;H:MN2PR21MB1375.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IgXgeRyhjIHGgIz1Z7wrn+/A+Fo/67m8+VTat6yJT7K3MJHDgMsHsBLgdzNs2xBy03HFDd4krTKyiImHdsBhAqokyERf2U4tENsEH8ooAK885EoGVYWh/RPv86AikP8iYMyn9VZcuo6rx7VAYfYiuFuWFQr4RbLRvxFjj8WvgjW533qLisNGAk2ddUkxY+3ArrPsjItzLd4D0NGzbPAK3u2zLcGtZ7BglqnG82gCz9cST05nXIZE7Nhgu9qrtd0+LgWqqETohT7akdO/byKWSH09ZvAu0bwfWjMN2Gf6iv6TC0NFyLxSLX2Q5dUbIOQZT8FjBFvk8XHa+VG66nuwRUiqAdWJj4HI62uW6a5qGWVHL73A2zKTmwtJGZYfJUHTYky6TWamsDvchKodipL5I9L09xW3eFonRK+j5RNK/7p8czl8m4KrUPaH/TlEnU8UAIJuAq8XiCwM0CRQnl+DhI+XR/oIl0llpmEi2vcn9BwePLtEoi9Jl3+41dQRkH7b
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd2d02b1-2087-43ed-7a93-08d78ff66595
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jan 2020 02:41:12.3327
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QYMo0yCl2ogPqcHW9qHoOST0R/kPG9rq/8uzTq4oTJFY5u5eR/M8xUzD44TgM9f9cDhMoZYbaZXNrMm/GU+cIw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR21MB1406
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: David Miller <davem@davemloft.net>
> Sent: Thursday, January 2, 2020 7:30 PM
> To: Haiyang Zhang <haiyangz@microsoft.com>
> Cc: sashal@kernel.org; linux-hyperv@vger.kernel.org; netdev@vger.kernel.o=
rg;
> KY Srinivasan <kys@microsoft.com>; Stephen Hemminger
> <sthemmin@microsoft.com>; olaf@aepfle.de; vkuznets
> <vkuznets@redhat.com>; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH V3,net-next, 0/3] Add vmbus dev_num and allow netvsc
> probe options
>=20
> From: Haiyang Zhang <haiyangz@microsoft.com>
> Date: Tue, 31 Dec 2019 14:13:31 -0800
>=20
> > Add dev_num for vmbus device based on channel offer sequence.
> > User programs can use this number for nic naming.
> > Async probing option is allowed for netvsc. Sync probing is still the
> > default.
>=20
> I don't like this at all, sorry.
>=20
> If 4 devices get channels we will have IDs 1, 2, 3, 4.
>=20
> Then if channel 3 is taken down, the next one will get 3 which is not in =
order
> any more.
>=20
> It is not even clear what semantics these numbers have in any particular
> sequence or probe situation.
>=20
> You have to use something more persistent across boots to number and stri=
ctly
> identify these virtual devices.
>=20
> I'm not applying this.

The idea of this patch set is to make the naming of async probing same as t=
hat
in sync probing.

So, the semantics of this dev_num is actually same as the default "eth%d" n=
aming --
	"Find the smallest number >=3D0, which is not in use."

In cases:
1) There is no hot add/remove devices in current boot, this scheme does pro=
vide=20
persistent dev_num across reboot, because Hyper-V hosts offer the primary c=
hannels
in order. So the results based on this number with async probing will be th=
e same=20
as existing Sync probing.

2) If there is hot add/remove devices, this scheme generates the same resul=
ts (when
user program use dev_num)  as the default naming mode -- by using the small=
est
available number N in the format ethN.

In case of hot add/remove of virtual NICs, the removed NIC are gone, and th=
e newly=20
added NIC is a completely new virtual device with new device instance UUID.=
 So if we=20
don't reuse the previous numbers, the device name ethN will grow unbounded.=
 For=20
example, hot add/remove a virtual NIC 100 times, you will have a name like =
eth100. This=20
not what the default naming scheme does, and we are not doing it for dev_nu=
m here=20
either.

So the semantics is: "Find smallest number >=3D0, and not in use".

But if any customer wants to have a 1:1 mapping between the UUID and device=
 name, they
can still implement that in user mode... And that's why this patch set does=
n't change
the kernel naming from driver -- it just provides a new variable, "dev_num"=
, so user=20
mode program has the option to use it in async mode with knowledge of the c=
hannel
offer sequence.

Thanks,
- Haiyang

