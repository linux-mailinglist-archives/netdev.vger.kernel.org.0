Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54670907E3
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 20:45:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727586AbfHPSpe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 14:45:34 -0400
Received: from mail-eopbgr130044.outbound.protection.outlook.com ([40.107.13.44]:62403
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727490AbfHPSpe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Aug 2019 14:45:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OoET56qMUwQd/TcDZYxbRpDofFSIhYLq+pph/xaqqykpbJDeUQULczjA4HemmAp8+r6NaLl0/NmjkkSYpFDmyoCBFPw/WXSckT4/OsOF6nZQ/TPKUF+ibnC+jZawRv48JESKlQqt4KomcJEv6BRHNzveVPKrAjH9vBKZX50NH0flIBTMZhILJOzZuDOYxEAD8QEPaV4Q7g++wV6uv8jcGCfl9W0OFxnIMzTXI1ZyhccCB/vVM9J0F3+uEG7ZLlKiDun9ToYPm/u+jh/SyWGwa+1lPfQ6cD/MBscDMgUTOEsp6nReBqxJi/ocxG9jLoyC0ERhIIsUfwCtMoLVLoIH8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CjoBMzqrXbjl+9uz+UWiBfx4t9EMM073wIE6huWusWE=;
 b=OSHIKZI6O4hkP7bJQmBEkALGqc/damd0qxyjQb4rig2jP3Y5xKW4nS6DMb3WeZyU5R0xRO0hIHPieJvpxpIXYsrxMw8cgV9KqnJqFeAkpy8L6ggu/XOWG87w6ybRO7lyuXnmMFepG7hAGxsQMA95cVxxT3cM+LIONPa6ZeZkSQSFCTuFBrQIlMOeeAlakZoZ2wENPBj6bjVXWlYLpDGTAaBxEMTCSMMmMo2bnfuZU4NUxdOpPpz0tGcNCIVkgV3EKi17HSrxsmT7l65Z0/GO+Ge+s9mZoSxPOg1iCUUvpfBOo0p60YmWobvSOh0ZlS60bdqFc9Pl7Rg+pv9+64o9yQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CjoBMzqrXbjl+9uz+UWiBfx4t9EMM073wIE6huWusWE=;
 b=iUJmUXLz3vQZ611bcvufgx4k7QtsFh+MFOEhdCEARPyfyVScjDc2H0rOu0iyyLUNCQM2gsPqQF8KTT7C9BLhb/sfaWwdGC1T5gGnInC0IzQDpiCX/bnxkbMg7upGZtdKvFucEdFao0VxoQdfEky7+BSHDSZHiOOlkC9XZkg8b4s=
Received: from VI1PR05MB5295.eurprd05.prod.outlook.com (20.178.12.80) by
 VI1PR05MB5248.eurprd05.prod.outlook.com (20.178.12.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.16; Fri, 16 Aug 2019 18:44:48 +0000
Received: from VI1PR05MB5295.eurprd05.prod.outlook.com
 ([fe80::ec21:2019:cb6f:44ae]) by VI1PR05MB5295.eurprd05.prod.outlook.com
 ([fe80::ec21:2019:cb6f:44ae%7]) with mapi id 15.20.2178.016; Fri, 16 Aug 2019
 18:44:48 +0000
From:   Vlad Buslov <vladbu@mellanox.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
CC:     Vlad Buslov <vladbu@mellanox.com>, wenxu <wenxu@ucloud.cn>,
        David Miller <davem@davemloft.net>,
        Jiri Pirko <jiri@resnulli.us>,
        "pablo@netfilter.org" <pablo@netfilter.org>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next v7 5/6] flow_offload: support get multi-subsystem
 block
Thread-Topic: [PATCH net-next v7 5/6] flow_offload: support get
 multi-subsystem block
Thread-Index: AQHVTL1pG2KieeISTEa5YG2C2+XO7qb3lk2AgAJmXYCAA/G0gIAAMACAgAANfAA=
Date:   Fri, 16 Aug 2019 18:44:48 +0000
Message-ID: <vbfr25l2bmt.fsf@mellanox.com>
References: <1565140434-8109-1-git-send-email-wenxu@ucloud.cn>
 <1565140434-8109-6-git-send-email-wenxu@ucloud.cn>
 <vbfimr2o4ly.fsf@mellanox.com>
 <f28ddefe-a7d8-e5ad-e03e-08cfee4db147@ucloud.cn>
 <vbfpnl55eyg.fsf@mellanox.com> <20190816105627.57c1c2aa@cakuba.netronome.com>
In-Reply-To: <20190816105627.57c1c2aa@cakuba.netronome.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: LO2P265CA0466.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a2::22) To VI1PR05MB5295.eurprd05.prod.outlook.com
 (2603:10a6:803:b1::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=vladbu@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [37.142.13.130]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e1db492d-3f8f-4d78-ed72-08d72279d04e
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR05MB5248;
x-ms-traffictypediagnostic: VI1PR05MB5248:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB524849360F0BDF6935C65666ADAF0@VI1PR05MB5248.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0131D22242
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(366004)(376002)(39860400002)(396003)(346002)(199004)(189003)(26005)(81166006)(8936002)(81156014)(8676002)(66556008)(6916009)(11346002)(86362001)(229853002)(14454004)(386003)(54906003)(99286004)(186003)(5660300002)(478600001)(6506007)(102836004)(52116002)(76176011)(446003)(486006)(476003)(2616005)(316002)(3846002)(6436002)(4326008)(256004)(14444005)(6512007)(25786009)(7736002)(71190400001)(66446008)(64756008)(66476007)(66946007)(6246003)(53936002)(6486002)(66066001)(305945005)(36756003)(71200400001)(2906002)(6116002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5248;H:VI1PR05MB5295.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 1zVD96sI9nJ1osISmcm6W/FxHGURbo0n+lmCv+7rwLMis8tP9CfpZrDuRLV4bIQyrS3vQBlJdvNdQUMV4zKvwkIfIRkGgyK5BVuz/ZfBmoDab95kQXpD4+3hB8yB72FbqY1dlM5C4TZPdRHliWDojnt1gthEuH/geqwrUJNCn3tmRbCSnnOjlWCDRkm0HBuu5ykJXIk4WHoel7j8o6u58OKep8VEmZ+HxcucQfYrWgPp/EyL46Vu+IXPntZNG6skhvHOaDJlsf30J1Pqyqahp4b4wdTmwp9IRmgakFAJ/AjKuQ0eWCVq96n0atazZJYl8UX+hskr8oZeOyAQ8FqtmkQxAf5C9lTAisggw9qgOd9n88XMk5bE1xsSxSRgPuVg9mwk8tBIZDJ9Iwsy5Bq1YeFj3xvn43zny1xxWZxXbhA=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e1db492d-3f8f-4d78-ed72-08d72279d04e
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Aug 2019 18:44:48.0443
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QlhqQxzdNi6q+g4exyG+BlfwtWZlycnBeSE2AJy52aw0ob9nzMDMm0ssz0ECrAiBr6cp07E1hHCLxarRhRUMSA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5248
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Fri 16 Aug 2019 at 20:56, Jakub Kicinski <jakub.kicinski@netronome.com> =
wrote:
> On Fri, 16 Aug 2019 15:04:44 +0000, Vlad Buslov wrote:
>> >> [  401.511871] RSP: 002b:00007ffca2a9fad8 EFLAGS: 00000246 ORIG_RAX: =
0000000000000001
>> >> [  401.511875] RAX: ffffffffffffffda RBX: 0000000000000002 RCX: 00007=
fad892d30f8
>> >> [  401.511878] RDX: 0000000000000002 RSI: 000055afeb072a90 RDI: 00000=
00000000001
>> >> [  401.511881] RBP: 000055afeb072a90 R08: 00000000ffffffff R09: 00000=
0000000000a
>> >> [  401.511884] R10: 000055afeb058710 R11: 0000000000000246 R12: 00000=
00000000002
>> >> [  401.511887] R13: 00007fad893a8780 R14: 0000000000000002 R15: 00007=
fad893a3740
>> >>
>> >> I don't think it is correct approach to try to call these callbacks w=
ith
>> >> rcu protection because:
>> >>
>> >> - Cls API uses sleeping locks that cannot be used in rcu read section
>> >>   (hence the included trace).
>> >>
>> >> - It assumes that all implementation of classifier ops reoffload() do=
n't
>> >>   sleep.
>> >>
>> >> - And that all driver offload callbacks (both block and classifier
>> >>   setup) don't sleep, which is not the case.
>> >>
>> >> I don't see any straightforward way to fix this, besides using some
>> >> other locking mechanism to protect block_ing_cb_list.
>> >>
>> >> Regards,
>> >> Vlad =20
>> >
>> > Maybe get the  mutex flow_indr_block_ing_cb_lock for both lookup, add,=
 delete?=20
>> >
>> > the callbacks_lists. the add and delete is work only on modules init c=
ase. So the
>> >
>> > lookup is also not frequently(ony [un]register) and can protect with t=
he locks. =20
>>=20
>> That should do the job. I'll send the patch.
>
> Hi Vlad!=20
>
> While looking into this, would you mind also add the missing
> flow_block_cb_is_busy() calls in the indirect handlers in the drivers?
>
> LMK if you're too busy, I don't want this to get forgotten :)

Hi Jakub,

Will do!
