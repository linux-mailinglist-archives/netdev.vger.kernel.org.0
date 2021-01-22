Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0FF92FFE33
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 09:32:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726820AbhAVIbq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 03:31:46 -0500
Received: from mail-eopbgr140134.outbound.protection.outlook.com ([40.107.14.134]:64414
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726167AbhAVIbC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Jan 2021 03:31:02 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NkWlY4CGXzYNk2Lyp6wPGYk2P0Pdw1Z8U+MngNz4OiWGzONl4y5EI/4jj+/4CXobdn6oafHayKZ9H0OgPvMbGSJxny2HYo5oIQQr1LFkRCCWyLjUbRqfPZVB64JTe7dQUd5pMq9SgJm55aseFM8TG5sQyKyOEjiWGg/nqLkHyn8WIEcTk7MLtE5VrR2OEHwaJw6SjAHwN4CEdFmn2RpoEiNjn6FxAapNDYY9o3eds9l/0WE/S6sRleyCDMD4C2thvymtNe/9MEZpCPQxsWAuVG7+McAwxdGv2SHYFPHk0JdKemvbTOFokxzTx6SpXWhbiCG5FRkFs971SVFhzloadg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rzedn+iwMDbiTrrkznjtnuBE8akfCB4zt6+4Hpd+6QE=;
 b=jD5SGDoN0JiYuq7RAa73/Pez01QWecsgkuKmKPZdaC8jEHMI/+qKJd75VtVgZ4NoHuiCC4QQXvxp/FbkuQEARsQbACy/U2UNbJS1FIV3PTX2MW4NvX8ZHgrN3gbzXspke3kxKWtkK6Qdh+57+bUGersMRZgOrd4hGUOItZKcFjWXxj72TADS4b2o+me59g3HY+k9fkZe2ojfkF5kt/z0JDIRTICYajc9fKBSPzsrMkuG4A3iYvH2Kr20j87LGsVGPyUBXjri5cUvPFFG+7MFrRsWFwRV4B9+Tb0kqppUbaX/buUd9/CSuL+Gi3QrTkR5cv16TiQ6JGMnrqnBPiD6fg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rzedn+iwMDbiTrrkznjtnuBE8akfCB4zt6+4Hpd+6QE=;
 b=kWdeG7BV5C6U/kHTzDzexivmowMhFbOsA6yPR/NLK4+GSIHxULe5uQYZaT94+WJFvrERGyTpFn8f8kOlxdTNlzVLUYd/PwggGQLL38WG/nhhc/dnHDpDEUZW0nWoCJAC01uO65VzNKJz7Q7O5j2t5eHWCdMb2hhpUru4uaAcMUo=
Received: from AM0P190MB0738.EURP190.PROD.OUTLOOK.COM (2603:10a6:208:19b::9)
 by AM9P190MB1282.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:26d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10; Fri, 22 Jan
 2021 08:30:13 +0000
Received: from AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
 ([fe80::3011:87e8:b505:d066]) by AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
 ([fe80::3011:87e8:b505:d066%9]) with mapi id 15.20.3784.015; Fri, 22 Jan 2021
 08:30:13 +0000
From:   Oleksandr Mazur <oleksandr.mazur@plvision.eu>
To:     Ido Schimmel <idosch@idosch.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "jiri@nvidia.com" <jiri@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>
Subject: Re: [PATCH net-next] net: core: devlink: add new trap action
 HARD_DROP
Thread-Topic: [PATCH net-next] net: core: devlink: add new trap action
 HARD_DROP
Thread-Index: AQHW7+i5SANyTFamkUKbFKKw5ahdBKoyAC0AgAFQP3o=
Date:   Fri, 22 Jan 2021 08:30:13 +0000
Message-ID: <AM0P190MB0738E480C28682A1744562EBE4A00@AM0P190MB0738.EURP190.PROD.OUTLOOK.COM>
References: <20210121112937.30989-1-oleksandr.mazur@plvision.eu>,<20210121122152.GA2647590@shredder.lan>
In-Reply-To: <20210121122152.GA2647590@shredder.lan>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: idosch.org; dkim=none (message not signed)
 header.d=none;idosch.org; dmarc=none action=none header.from=plvision.eu;
x-originating-ip: [185.219.76.174]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 225e31f9-962c-4c66-8177-08d8beaff097
x-ms-traffictypediagnostic: AM9P190MB1282:
x-microsoft-antispam-prvs: <AM9P190MB1282F0ABD0FD42C134F5C5A7E4A00@AM9P190MB1282.EURP190.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tXaXbrSxDDHPsnHmHgr5sRt1duGLjPQmVs49j0D8bFMaWAyBPB4KsE8RhppH+GBAF7QG7xinrAr3ZA4mmLgSt6sOSxVLykxGXuqAOvizw7ou2d075BO/3HGMJxMn6AGS0PflDl4pTanQIqJi3dLOUt0rMxEuwM8yQuelxkTY1g/Ik01AzoWH5YRkqkjVKKjTtyFgspWzt6w4bUefoRK8idC8zuo37u41oj2Unq9rfZ75hsu9PeDeEaKDfBPg4KjKe2t67i98DHw9mBXsF1uThardK94l/D5DZj2GF7v+kRocx6075V+EiAUsAjbn154KmJ1k2GTNDNSkz436I3SNnqLNVT+3vFHuGT5EQGtEqWHHs9fxC3Ngs2UvW2nvljp6w2ybbey5vrdHeXa4fv4P3g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0P190MB0738.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(376002)(136003)(346002)(396003)(39830400003)(366004)(44832011)(86362001)(9686003)(6916009)(76116006)(6506007)(66946007)(33656002)(52536014)(2906002)(66556008)(55016002)(478600001)(91956017)(4326008)(8936002)(186003)(8676002)(66476007)(83380400001)(64756008)(26005)(53546011)(7696005)(5660300002)(66446008)(71200400001)(316002)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?Windows-1252?Q?ExT4+pXBjKoKSIiCj4cphorJIRaPcpWomytMysSNCbCuQr1FmBoIlUg+?=
 =?Windows-1252?Q?zKdT/kZydMrPyjNsf0V/k/7sjc53tYRYuVaSvjMQmSVBWfwGmXK0Prs7?=
 =?Windows-1252?Q?KFKJpZldZfrb+mTmZnpUuS4hebAZ+q/F5ejRkUEdhmte8faHtyhkwKJO?=
 =?Windows-1252?Q?8DeenLGvDd5s4ad+P+b2Tr+WwzSDfd9M7DxJnNxkHb95ahaH8DPtm40I?=
 =?Windows-1252?Q?zyQ/COV+l8W4nJcB2dcBTmRGBCuGH/+QxAp16d/7cqDowlXBywvmO7a3?=
 =?Windows-1252?Q?Feq5fsZJYEeUnvDlFPXUboM5xZvLHr5vs6ouMnW+BStvYLzcc3PpKjqE?=
 =?Windows-1252?Q?tjUIqXvUqbpCyRhcx4JVV3/04vmKMhLBEKdypBV1dMpjP5QF/ymQLNqv?=
 =?Windows-1252?Q?cq/yyO9nMAOjY5VoSUORX0uVTOah0He/bWbyALXH7jDKYj5FzMeq1WXj?=
 =?Windows-1252?Q?s/P2EG7ILYJYpyR2K1n6/f+Z7Mzk/wiLzakhBRw2DfQDvw/QitaL4EPh?=
 =?Windows-1252?Q?BdkkelIuwPBnqUcMkaSqdkGI3pWRqIOSuZzzNC/MHY0SNzmiiwj7puGG?=
 =?Windows-1252?Q?QWrc9yEkx0tUYEmD33TL0oMZ7ynwkxd9cFRMZksc8SCQgVVvjQKTCBdc?=
 =?Windows-1252?Q?e2OqqjQERkrYmwRyw6c+l+zX/y4Kaw4pDPQgpP8IZRg7Db+PYRZYYBr0?=
 =?Windows-1252?Q?xuRBP/JQQmZqv/Kt7m06W29rAtrpRrFHb5TsMhCwbcdBBkAAzTEIi61j?=
 =?Windows-1252?Q?zADb3Oh3ZT3GmEqQVnE8Fr4rB/KRpukjK4CXcB5C5KKjhKIiSBuLHloI?=
 =?Windows-1252?Q?u+Ys6g2BUhG3IausrQeJWyT5KwI2t+GxPg8aA/i2OzwdEMLjTqVebPwy?=
 =?Windows-1252?Q?UE733o1nMJ8XuyFSmu+hYWt2G4DcBZtTrD2iHM/IV2nnyHmp0Ywxvtmo?=
 =?Windows-1252?Q?HBMszdVPGU9qwmLOMDsyEJ0EFPtFg9EtgefYeJD4aQpkWRiOWqmHvb+G?=
 =?Windows-1252?Q?ORZIGbB705c2JQzFkzmdhFLUPQvYoZLklTkjkcAGjM/THbQypvlFlh0Y?=
 =?Windows-1252?Q?ZHxA16L0KWIANJvxTj+otmjYlH8PH0z8x0iyKMDSxB5XkwynyResCC2v?=
 =?Windows-1252?Q?PsQ=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 225e31f9-962c-4c66-8177-08d8beaff097
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jan 2021 08:30:13.7492
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xsSigI7vBWfrSdw89A6cUVBqVcflMfqLdUovCG/oVide+1Pp6LP0Ak4ezUJ6dtFz+To1vhCeGMU8VLucGSsrXDoXMbVqJ2nijFX52Y7aupQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9P190MB1282
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@idosch.org>=0A=
Sent: Thursday, January 21, 2021 2:21 PM=0A=
To: Oleksandr Mazur <oleksandr.mazur@plvision.eu>=0A=
Cc: netdev@vger.kernel.org <netdev@vger.kernel.org>; jiri@nvidia.com <jiri@=
nvidia.com>; davem@davemloft.net <davem@davemloft.net>; linux-kernel@vger.k=
ernel.org <linux-kernel@vger.kernel.org>; kuba@kernel.org <kuba@kernel.org>=
=0A=
Subject: Re: [PATCH net-next] net: core: devlink: add new trap action HARD_=
DROP =0A=
=A0=0A=
On Thu, Jan 21, 2021 at 01:29:37PM +0200, Oleksandr Mazur wrote:=0A=
>> Add new trap action HARD_DROP, which can be used by the=0A=
>> drivers to register traps, where it's impossible to get=0A=
>> packet reported to the devlink subsystem by the device=0A=
>> driver, because it's impossible to retrieve dropped packet=0A=
>> from the device itself.=0A=
>> In order to use this action, driver must also register=0A=
>> additional devlink operation - callback that is used=0A=
>> to retrieve number of packets that have been dropped by=0A=
>> the device.=0A=
=0A=
>Are these global statistics about number of packets the hardware dropped=
=0A=
> for a specific reason or are these per-port statistics?=0A=
=0A=
Global statistics. Basically, it=92s the DROP action, with the only differe=
nce that device might be unable to post the packet to the devlink subsystem=
.=0A=
Also, as this is an action, it could also be altered: e.g. changed to =91mi=
rror=92 or else.=0A=
=0A=
> Anyway, this patch really needs to be marked as "RFC" since we cannot=0A=
> add infrastructure without anyone using it.=0A=
=0A=
Will do.=0A=
Also, should I make a V2 patch, that will already hold the RFC tag and the =
changes (which include the commentaries fixes)?=0A=
=0A=
> Additionally, the documentation=0A=
> (Documentation/networking/devlink/devlink-trap.rst) needs to be updated,=
=0A=
> netdevsim needs to be patched and the test over netdevsim=0A=
> (tools/testing/selftests/drivers/net/netdevsim/devlink_trap.sh) needs to=
=0A=
> be extended to cover the new functionality.=0A=
=0A=
Okay. Will do.=0A=
=0A=
>> @@ -9876,6 +9915,9 @@ void devlink_trap_report(struct devlink *devlink, =
struct sk_buff *skb,=0A=
>>  {=0A=
>>        struct devlink_trap_item *trap_item =3D trap_ctx;=0A=
>> =0A=
>> +     if (trap_item->action =3D=3D DEVLINK_TRAP_ACTION_HARD_DROP)=0A=
>> +             return;=0A=
=0A=
>How can this happen?=0A=
=0A=
My bad. Will get removed in V2.=
