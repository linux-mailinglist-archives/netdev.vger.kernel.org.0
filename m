Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9789A172C89
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 00:51:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730120AbgB0XvD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 18:51:03 -0500
Received: from mail-vi1eur05on2090.outbound.protection.outlook.com ([40.107.21.90]:17729
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729796AbgB0XvD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Feb 2020 18:51:03 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F+cF5ucuvkwxrJ0joWb4WWDBqiWWMmpOaOpHTgDb2WWHlxVdisC6Om2DdXtzff4D9O3PqNapUkoeDix5WqqCawnlYfHVJlEBTEkd4a7+25MqpMRyEzm3CX+TzGgKaQ0F8ijivMjSHsr8wh2PQ57LHkFR7kIPUIhMbteVK9uZ/HOYaJKKlxyJ+8t7bG07R2j12shbm8aRtqD/KqyaO9bVUdh7A4mfj4BD7M+bm0qE9+HrK4F7QQAePdO2Cpc0MiGOPJN34kkauUEc8nNYmvLZfGRApHIdqiXL90SXoxeIAOq0i/vMF8cgKpE79IQlz2eT86ih0PjP8R3lc+o0n2SQnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x0I5a1/JVcQmsyWyTYhGIWdnwKoxjoDjJMprHOBxHVo=;
 b=D1YwMJGO3j11XGaVIEs5ZjW/lqwmi+BgdmygKWwlpVQjUuoa65ZdeCQZok8VrGA5lIIHInRLX9jMZIdr9uJlLMNAXPG+983+bCnP1meSoZy5pDnpu6rwdmvFbQz/EZZWhtBcfBNnyYMM9TnujyONRPNm9ZSX6rMGySNewI6P8VM+vI+5X92C+a12q9WSJmfU/Ytn6ctP3w1eDpSXPuogqHUSXz1b6zBjMxwWF7eUl2AKY8VgmmbWecl5J8Lm4xx3BbHIYL8TDLYzNxVaKpIVjFDD+zJOVQBwvXQwTaMNdFUP1r+gVzY5hCnmeVPr+Y/gZmsuvJlw1raSGCUNu/8rqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x0I5a1/JVcQmsyWyTYhGIWdnwKoxjoDjJMprHOBxHVo=;
 b=asFs04S6rWEfAykxq25gArJ8IZOwZo/4U+yvOls5Zca0FHAKMsjXJo1QEd4aKxjunsorz36q7D0t1wsQBVFJjXl/rZiTrmQ2bdahNQDQhspw3bW9LoaoAC9qGG6XU4XvR8t0dc3EhCxFerBd9us0HAe4rVaTGRfzTX+uLmQl+08=
Received: from VI1P190MB0399.EURP190.PROD.OUTLOOK.COM (10.165.195.138) by
 VI1P190MB0285.EURP190.PROD.OUTLOOK.COM (10.165.195.24) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2750.22; Thu, 27 Feb 2020 23:50:59 +0000
Received: from VI1P190MB0399.EURP190.PROD.OUTLOOK.COM
 ([fe80::a587:f64e:cbb8:af96]) by VI1P190MB0399.EURP190.PROD.OUTLOOK.COM
 ([fe80::a587:f64e:cbb8:af96%4]) with mapi id 15.20.2772.012; Thu, 27 Feb 2020
 23:50:59 +0000
Received: from plvision.eu (217.20.186.93) by AM7PR03CA0011.eurprd03.prod.outlook.com (2603:10a6:20b:130::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2750.21 via Frontend Transport; Thu, 27 Feb 2020 23:50:57 +0000
From:   Vadym Kochan <vadym.kochan@plvision.eu>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Jiri Pirko <jiri@resnulli.us>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Andrii Savka <andrii.savka@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>
Subject: Re: [RFC net-next 1/3] net: marvell: prestera: Add Switchdev driver
 for Prestera family ASIC device 98DX325x (AC3x)
Thread-Topic: [RFC net-next 1/3] net: marvell: prestera: Add Switchdev driver
 for Prestera family ASIC device 98DX325x (AC3x)
Thread-Index: AQHV6/jzY7yqWky1LUqTk1e6REHYB6gtohWAgAHwnQCAAANjgIAAI3EA
Date:   Thu, 27 Feb 2020 23:50:58 +0000
Message-ID: <20200227235048.GA21304@plvision.eu>
References: <20200225163025.9430-1-vadym.kochan@plvision.eu>
 <20200225163025.9430-2-vadym.kochan@plvision.eu>
 <20200226155423.GC26061@nanopsycho> <20200227213150.GA9372@plvision.eu>
 <20200227214357.GB29979@lunn.ch>
In-Reply-To: <20200227214357.GB29979@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM7PR03CA0011.eurprd03.prod.outlook.com
 (2603:10a6:20b:130::21) To VI1P190MB0399.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:802:35::10)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=vadym.kochan@plvision.eu; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [217.20.186.93]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8c31fb22-e719-4eb8-8cb0-08d7bbdfe4ba
x-ms-traffictypediagnostic: VI1P190MB0285:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1P190MB028510E45B86E0C81A95E15F95EB0@VI1P190MB0285.EURP190.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 03264AEA72
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(396003)(346002)(136003)(376002)(39830400003)(199004)(189003)(16526019)(5660300002)(186003)(66446008)(26005)(7696005)(1076003)(66946007)(64756008)(4326008)(52116002)(55016002)(66556008)(66476007)(508600001)(36756003)(8676002)(71200400001)(86362001)(316002)(8936002)(33656002)(4744005)(2906002)(107886003)(54906003)(956004)(6916009)(8886007)(2616005)(81156014)(81166006)(44832011);DIR:OUT;SFP:1102;SCL:1;SRVR:VI1P190MB0285;H:VI1P190MB0399.EURP190.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: plvision.eu does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GH4jXdYHPvKEnsJINzz8UyPk17KPcAM084bOqO17A2f3UND36Ex9DAFlQwy7ChXrljJ099EGrWX2B4J4BZ+S2gM4gVkWqZF4bix2np6O87konNP1lpLTDacNuUmBP8bJn37WMbe82YOTaFXKxXQtNTY3ykos1iyAlVv7EwnGl4EmIDnMAtDSuN8hpft4B1KPVzoojO5Zm7OxQf0TAKhKnoEf+j4GKBKgdRHL08JMG+rPc2j4+Sw5FsnZsbnE2VLnZoc8FjyGzKfgCecGqo+11ScH/uGUjDaBApycqozQ2VfDPzCMCgU1ll4u4hVaME9g5ENl9hzf9NwErV/BMvwfGpiQoC3pOdc7h0Ajkg0rBt36ySfnYluwlNhVyKRifmERS7N9dbgJXGVbP4BTcDD0Ico/7ig4RKwfLeEM5k1ewlbZ6wDrDyTMJgA3FpJhcmf+
x-ms-exchange-antispam-messagedata: uVQJmN5m5uzsUGb8PXi2phd6bCV7hEo0Ae7/E8NsTcs9B+F3SFq5jZqUu7pamz6N5VhJX1s3PBnUQhNpI2uocIBYCxdAv8Ai6FfRCAixqjt9/aRStJCkhp+8+Ey5YiVMmRDda+Zas1qjJNnTonCTeA==
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1E5A8E04E48F7D4A988E7C1F5FCD531A@EURP190.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c31fb22-e719-4eb8-8cb0-08d7bbdfe4ba
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Feb 2020 23:50:58.9374
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /g/gg6rH89H1wblBYrIPZievNcAsQp+MSg8CwFIeKTyQJL9oIpox3qyr8vSltprBqHGroKzYcug+3UvytH6swCH7lIJnx33toa6KW1b5zqo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1P190MB0285
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 27, 2020 at 10:43:57PM +0100, Andrew Lunn wrote:
> > > Please be consistent. Make your prefixes, name, filenames the same.
> > > For example:
> > > prestera_driver_kind[] =3D "prestera";
> > >=20
> > > Applied to the whole code.
> > >=20
> > So you suggested to use prestera_ as a prefix, I dont see a problem
> > with that, but why not mvsw_pr_ ? So it has the vendor, device name par=
ts
> > together as a key. Also it is necessary to apply prefix for the static
> > names ?
>=20
> Although static names don't cause linker issues, you do still see them
> in opps stack traces, etc. It just helps track down where the symbols
> come from, if they all have a prefix.
>=20
>      Andrew

Sure, thanks, makes sense. But is it necessary that prefix should match
filenames too ? Would it be OK to use just 'mvpr_' instead of 'prestera_'
for funcs & types in this particular case ?

Regards,
Vadym Kochan
