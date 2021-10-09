Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2190C427889
	for <lists+netdev@lfdr.de>; Sat,  9 Oct 2021 11:41:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232131AbhJIJnv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Oct 2021 05:43:51 -0400
Received: from mail-eopbgr1410098.outbound.protection.outlook.com ([40.107.141.98]:22448
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231555AbhJIJnv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 Oct 2021 05:43:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m6dbhAhVfJn5pi/cdrq3VpJZsYdY5VvIiK/t/Njkkn5rMx8P4gfXsevgi04BZkzHSOYHrpiY8F2D9BJVSZJuTJbdgB/xrz2o5FYkyfi6voo1VJNqVDJujmYz1076eajXY7AB8vMP68f8yQZGNV/YESLmd3s6/n6i5BxFNxVgMtYQ/GmY/BNIkPqmt2zbDtNNcPOD+mkwC5tGHSCfIyVgFHAIEBmQwjS04AKCw3jZd7ZT4zJcfUKxJt1P0BRi5WGQCkQVYaHpaHUhdRt4QuTpyu7I//xJbyDNyQWtGzDLRfN9lIlUHXBQv12vVNkKdwLBZHPxpvJDPihjaBk7+4DaCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2ACFx/Oz7XUskCAWPNfXpojLm8MgZfCSq5XCRTfOjWs=;
 b=BxRDAuos0MYFXonF/YWL2Da3Qr6hUqdsQWfqHg1mRdptwqbTJUF0s6Nzq4z++eNQXcGVjl2+ZzSbQBAPhrgnRfkLOEAmdxKvLqRiiIzXh2+wKjvhhNuh7O0ABx2eTI6rv8GCtBkPVI/H+S/Gr0k2y7Y4BbDHjB6JnyELwlssaU6JoQCcLv7SdRb7cn2AKMAqdrS7q1SJWbacjRH2DS0y8fsseB5Q34xpJyU/kdCjFgVb7l+NU4XLHHQt0qtonkIiFq2fTBP7zMHQErH3fZCfd2vBtZtwoNAYUcK58ThRM9l7hhqZedVyHyqvYsKxMmMMUPXmQLmrQVQjbolaCQRMUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2ACFx/Oz7XUskCAWPNfXpojLm8MgZfCSq5XCRTfOjWs=;
 b=p/l59H6bnC2sx8spr+3DrhbV7FWtWE6cLlQttV9Uk57Tz2f/W16IMn4ysy3K5fnGcbJfSLjQniUAJ295Ij2JYWhInxtJg+Wql7y6lZPhDTwwNa5qWjO5DLRYYyZIZdC7v1EqEmMvf463ldhKlHf4wpmA8Vh42OBjLXFqbR5t6y8=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by OSAPR01MB1908.jpnprd01.prod.outlook.com (2603:1096:603:1a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.19; Sat, 9 Oct
 2021 09:41:48 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::9ca6:1cf:5:9fc1]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::9ca6:1cf:5:9fc1%3]) with mapi id 15.20.4587.024; Sat, 9 Oct 2021
 09:41:48 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Adam Ford <aford173@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Yuusuke Ashizuka <ashiduka@fujitsu.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>
Subject: RE: [RFC 07/12] ravb: Fillup ravb_rx_gbeth() stub
Thread-Topic: [RFC 07/12] ravb: Fillup ravb_rx_gbeth() stub
Thread-Index: AQHXudknyVYpSr19EUOWd3E+ko3swavGX+aAgAAJbzCAAAV1gIAAlePwgADj/ACAAAp2UIAAuMcggAC8+wCAACVLgIAAyy6QgAAD7oCAABEB8A==
Date:   Sat, 9 Oct 2021 09:41:48 +0000
Message-ID: <OS0PR01MB59224CEBE8C062C8A14C1AC686B39@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20211005110642.3744-1-biju.das.jz@bp.renesas.com>
 <20211005110642.3744-8-biju.das.jz@bp.renesas.com>
 <63592646-7547-1a81-e6c3-5bac413cb94a@omp.ru>
 <OS0PR01MB592295BD59F39001AC63FD3886B09@OS0PR01MB5922.jpnprd01.prod.outlook.com>
 <7c31964b-8cde-50c5-d686-939b7c5bd7f0@omp.ru>
 <OS0PR01MB5922239A85405F807AE3C79A86B19@OS0PR01MB5922.jpnprd01.prod.outlook.com>
 <04dea1e6-c014-613d-f2f9-9ba018ced2a3@omp.ru>
 <OS0PR01MB5922BCF31F520F8F975606B286B19@OS0PR01MB5922.jpnprd01.prod.outlook.com>
 <OS0PR01MB5922165EFE14E02388B34F4086B29@OS0PR01MB5922.jpnprd01.prod.outlook.com>
 <52f0d801-9750-dbd6-7ba0-258a324208cf@omp.ru>
 <19204ce1-f689-3295-c5a5-7f91ceac2fca@omp.ru>
 <OS0PR01MB59228A4BA524B092F760B52E86B39@OS0PR01MB5922.jpnprd01.prod.outlook.com>
 <5dd44e8b-a927-7c9a-9ca5-a2e51b2f3bd7@gmail.com>
In-Reply-To: <5dd44e8b-a927-7c9a-9ca5-a2e51b2f3bd7@gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2f52f785-f894-49dc-f504-08d98b0903e4
x-ms-traffictypediagnostic: OSAPR01MB1908:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <OSAPR01MB1908B58F4AB844A188DED4A686B39@OSAPR01MB1908.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: khsqdSWNvG6bBNuqw2hlWg9J3g8IT4sM4SZtWof+kSBrCuHv0z4ptkSA+XGUzd0XUzhe98DJD5GrjUXcZhT1YugefyE/QZExXjmSh44d0+/qrY/Ou67Q3Z112w5cAuvQnoWxODr4V1p+9MQt8YwmXsX+4nINypH0iSJGCTtw7sZvwcjnOi5tiIKy0XJ3KXecBXWV/p1RXKu5YqAS6Eq0k3/L2tTs0n0f5X6CrA/fD/7oO2p7JN6whbFV8LKuTR9iAzkpJ3FMFS2VexNRLG5bWBLKqH9RPd9mOaEwQdiso9POZgZARXesDHDbQ9aynodc1rjfqHRJbA8LVBBj0lJ/3djNxN/u4gBPqtiwysAQSo4HuEif2e48i2YeC6Wv9k7dyLUdRXe8kNCKhpWB7v+tHeyryVcAASMsajWTC8J8WImy6Ye2hmUjktuahDq1V0fjfVd7hZQ7Gor1aQ4COvS5pC1BySpM4TiYC5zEakfbkyn7TsjU6EmYzQ8OFGPyMNQjeEvT6SJNoTobf83WcFfw5vN4kmqft0Un8KP6efH6as+3XXNVpkqvQxE/f3nfxC9McZMLwJ1TfN4jbQzIXlPS6G3vtrFdPvli8Y2RVQYC78dVddJFHWeQ7VqGICkFfotjjO2srop14Sa91xnBH5R0V04yEFP8AmfDs5mdtP8EmyOHYstueOcUCtRCLuBUE22haPIaTuSm5mBZwiKBUnmNbwk/p9BuRArkfcAYzTaJ/muouXYF6lLuGxL6alhdEjH4Svps+HmBDJH63EgNl91jpGqyh68AKKfLHmQuaMiTd9Y=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66446008)(64756008)(66556008)(66476007)(8936002)(107886003)(186003)(26005)(33656002)(71200400001)(52536014)(6506007)(53546011)(9686003)(38070700005)(86362001)(38100700002)(8676002)(83380400001)(4326008)(508600001)(966005)(316002)(110136005)(76116006)(66946007)(54906003)(122000001)(5660300002)(7696005)(55016002)(7416002)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NkFWQkdueno4b2VUc2ZuaDRPV2tQUFZjYnppK0wrLzBUQ1dCbmhDVzI3L0JL?=
 =?utf-8?B?eGFTcXNoekF6SEx1dWFPZ0JLZjFERDhxNlA1enVkR1d0djJjWENET3BqUU9r?=
 =?utf-8?B?SU5UczNMVEhwa0pqVk1XdVk5eXJzc0VoNlRZYkV3YlBWTnk1bTMyUzFQS2ZM?=
 =?utf-8?B?UmszMTdqQVdQZTdablBtYSthcTB1TjlBc0o2a3hhYklsRzhTM2VWV2U4eUFi?=
 =?utf-8?B?a3ltRmF5ajBjWCtZdnc2MHhjd25ZamEvU2I2enJvdDUyK0N6cXNBRU9Zalls?=
 =?utf-8?B?QThaekdPcGZWZFQ0WTY1Y2krY09XWFFSQ25GdDBjU2FucXFqekltSFBEelZj?=
 =?utf-8?B?eHVENnVEUjJMTGlUeTdqMUNaYitGQVZPRDVHRjBwcmZNUm8weUYwR01zdzhh?=
 =?utf-8?B?V1NMd1ZIeWtLeGpSNkVVZG93RERPNU04akxOeklLQXcwdlZnWUgwbWVzMWly?=
 =?utf-8?B?bEhVSTJoR2t1TElwVjlkdGcwNW01bXhRZTJ1RHhnd29QNTNEalFHSmJobmpn?=
 =?utf-8?B?RUQ5b2Evc3Z1NzdYbjBhaGFNRVJHSFNnNCtBRU5tY0lFeFJpSHp2Sy9EejZy?=
 =?utf-8?B?b292a05uUVcrTVZrRVFtQnYxSHhTWHlobHZJVVdDR2RMNTg4NmtNeHVUQzUv?=
 =?utf-8?B?aHlLSlRoejlpdGVUdFZHUzZWcmk0WmN0NlNYMm9iWkR3K3h2TjduVTZhUmky?=
 =?utf-8?B?MXMzR0dTWm45ckRpTTVEZ2JHVlFWTTk3ZFhNcXI0NklNalROTXY5R09xK0Np?=
 =?utf-8?B?NlMwdThMN3cyK0FBYVh1Y1c1MHhDdms0UzJXNitwZDEyTWx4MHVOS0UyYnNv?=
 =?utf-8?B?NUJ5aGF6azBneEhnaVMzVTAxYjBhUitMSnBVQUJnZGVFNUNlTXRoZWlNeXJP?=
 =?utf-8?B?S1FkaW9FQXNTcnBYZzJWUkRqeTROQVRERE9PbURzdTNCUWdVd0N5ZGJCdEhO?=
 =?utf-8?B?bFRaS0hUWXpIakJBd2dHNUR0aVJ5OWppbUVabUE0YXNSVTMxemsxVmdob3pK?=
 =?utf-8?B?S1gzN0YwS1pjRWdFMXBCM1JlL0pjK1VWR3E4Z0ZOM1hGdTI2bHN2SlEydGJy?=
 =?utf-8?B?NjA0bUxFR2I1d0FpTCtoVldmTjFBdWZLdGt1YmREMllvRUZpaSthcnd0N004?=
 =?utf-8?B?c3hPdkEvTVg2NUtUTlpRbUhaK0NJZ0tuczFkSW1CcFEvdzRoOHp1T0FlczJO?=
 =?utf-8?B?VGE2NU1wdm1OelRMdFdxZDAxdGRlRU1IRFFIQWExOVN5OGFOYktab1pJMXNF?=
 =?utf-8?B?dURNZHl6cm9KakRTR1ZCMWk1Mzh3TU9hQytLMFJMSHY5b0pTcWdSQXBaN1l4?=
 =?utf-8?B?cmxqUnhFS3R5eUllY05MUHNFL0tNM1JDMmdEYjBpVGVjNzB3YitreVAxN0ZS?=
 =?utf-8?B?R0RRTm1PRER2UGwxYWlJWUFYOVpxN3R5d1doamVFVGFNMmczQmxwSmNRZkNm?=
 =?utf-8?B?UnI3ZFNIYTZZTGdUUHhyUXhOYmFCNmV2UWtyZlo1Y0FRRmJaWmtRM3dzZjky?=
 =?utf-8?B?RXZFZ0d6MHREWkdSWDFtcFhMTHVIWFBwQjA3RVBGR2NQUzVGNDBIUVZWQVZl?=
 =?utf-8?B?R09ZU1ROTTRlL0lCWGRKVS9lZWx5NW1MMTN1cDMzOE80a0hoU1pzV3p6clVq?=
 =?utf-8?B?VXJjZ0RCQjFwUGNHOXZ2OUpWclhsNnp2SlArRU16ZTExTkFBSHhBRTA2QWIx?=
 =?utf-8?B?MjByQVN1MXowZlBZQUoyK01qY1hla0NuUDB0MGRubHk4V3gvUGYrWm8wQkcz?=
 =?utf-8?Q?oXIp2RmeXGGbuXRJ8s=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f52f785-f894-49dc-f504-08d98b0903e4
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Oct 2021 09:41:48.0243
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MDS/WrQ0Es17VsAGnSElHcG1u15fEi2EqXh7h1Hz1bvX59ouj3PKnKIwGoxLQGYiPInsKnsrW1VO6KiZEhXwfZ/VupzDUTzyZsswNEpwsGg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSAPR01MB1908
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgU2VyZ2V5LA0KDQo+IFN1YmplY3Q6IFJlOiBbUkZDIDA3LzEyXSByYXZiOiBGaWxsdXAgcmF2
Yl9yeF9nYmV0aCgpIHN0dWINCj4gDQo+IE9uIDA5LjEwLjIwMjEgMTE6MjcsIEJpanUgRGFzIHdy
b3RlOg0KPiANCj4gPj4+IFsuLi5dDQo+ID4+Pj4+Pj4+Pj4+IEZpbGx1cCByYXZiX3J4X2diZXRo
KCkgZnVuY3Rpb24gdG8gc3VwcG9ydCBSWi9HMkwuDQo+ID4+Pj4+Pj4+Pj4+DQo+ID4+Pj4+Pj4+
Pj4+IFRoaXMgcGF0Y2ggYWxzbyByZW5hbWVzIHJhdmJfcmNhcl9yeCB0byByYXZiX3J4X3JjYXIg
dG8gYmUNCj4gPj4+Pj4+Pj4+Pj4gY29uc2lzdGVudCB3aXRoIHRoZSBuYW1pbmcgY29udmVudGlv
biB1c2VkIGluIHNoX2V0aCBkcml2ZXIuDQo+ID4+Pj4+Pj4+Pj4+DQo+ID4+Pj4+Pj4+Pj4+IFNp
Z25lZC1vZmYtYnk6IEJpanUgRGFzIDxiaWp1LmRhcy5qekBicC5yZW5lc2FzLmNvbT4NCj4gPj4+
Pj4+Pj4+Pj4gUmV2aWV3ZWQtYnk6IExhZCBQcmFiaGFrYXINCj4gPj4+Pj4+Pj4+Pj4gPHByYWJo
YWthci5tYWhhZGV2LWxhZC5yakBicC5yZW5lc2FzLmNvbT5bLi4uXQ0KPiA+Pj4+Pj4+Pj4+PiBk
aWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiX21haW4uYw0KPiA+
Pj4+Pj4+Pj4+PiBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yl9tYWluLmMNCj4g
Pj4+Pj4+Pj4+Pj4gaW5kZXggMzcxNjRhOTgzMTU2Li40MjU3M2VhYzgyYjkgMTAwNjQ0DQo+ID4+
Pj4+Pj4+Pj4+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yl9tYWluLmMN
Cj4gPj4+Pj4+Pj4+Pj4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiX21h
aW4uYw0KPiA+Pj4+Pj4+Pj4+PiBAQCAtNzIwLDYgKzcyMCwyMyBAQCBzdGF0aWMgdm9pZCByYXZi
X2dldF90eF90c3RhbXAoc3RydWN0DQo+ID4+Pj4+Pj4+Pj4+IG5ldF9kZXZpY2UNCj4gPj4+Pj4+
Pj4+PiAqbmRldikNCj4gPj4+Pj4+Pj4+Pj4gICAJfQ0KPiA+Pj4+Pj4+Pj4+PiAgIH0NCj4gPj4+
Pj4+Pj4+Pj4NCj4gPj4+Pj4+Pj4+Pj4gK3N0YXRpYyB2b2lkIHJhdmJfcnhfY3N1bV9nYmV0aChz
dHJ1Y3Qgc2tfYnVmZiAqc2tiKSB7DQo+ID4+Pj4+Pj4+Pj4+ICsJdTggKmh3X2NzdW07DQo+ID4+
Pj4+Pj4+Pj4+ICsNCj4gPj4+Pj4+Pj4+Pj4gKwkvKiBUaGUgaGFyZHdhcmUgY2hlY2tzdW0gaXMg
Y29udGFpbmVkIGluIHNpemVvZihfX3N1bTE2KQ0KPiA+Pj4+Pj4+Pj4+PiArKDIpDQo+ID4+Pj4+
PiBieXRlcw0KPiA+Pj4+Pj4+Pj4+PiArCSAqIGFwcGVuZGVkIHRvIHBhY2tldCBkYXRhDQo+ID4+
Pj4+Pj4+Pj4+ICsJICovDQo+ID4+Pj4+Pj4+Pj4+ICsJaWYgKHVubGlrZWx5KHNrYi0+bGVuIDwg
c2l6ZW9mKF9fc3VtMTYpKSkNCj4gPj4+Pj4+Pj4+Pj4gKwkJcmV0dXJuOw0KPiA+Pj4+Pj4+Pj4+
PiArCWh3X2NzdW0gPSBza2JfdGFpbF9wb2ludGVyKHNrYikgLSBzaXplb2YoX19zdW0xNik7DQo+
ID4+PiBbLi4uXQ0KPiA+Pj4+Pj4+IFBsZWFzZSBjaGVjayB0aGUgc2VjdGlvbiAzMC41LjYuMSBj
aGVja3N1bSBjYWxjdWxhdGlvbiBoYW5kbGluZz4NCj4gPj4+Pj4+PiBBbmQgZmlndXJlIDMwLjI1
IHRoZSBmaWVsZCBvZiBjaGVja3N1bSBhdHRhY2hpbmcgZmllbGQNCj4gPj4+Pj4+DQo+ID4+Pj4+
PiAgICAgSSBoYXZlLg0KPiA+Pj4+Pj4NCj4gPj4+Pj4+PiBBbHNvIHNlZSBUYWJsZSAzMC4xNyBm
b3IgY2hlY2tzdW0gdmFsdWVzIGZvciBub24tZXJyb3IgY29uZGl0aW9ucy4NCj4gPj4+Pj4+DQo+
ID4+Pj4+Pj4gVENQL1VEUC9JQ1BNIGNoZWNrc3VtIGlzIGF0IGxhc3QgMmJ5dGVzLg0KPiA+Pj4+
Pj4NCj4gPj4+Pj4+ICAgICBXaGF0IGFyZSB5b3UgYXJndWluZyB3aXRoIHRoZW4/IDotKQ0KPiA+
Pj4+Pj4gICAgIE15IHBvaW50IHdhcyB0aGF0IHlvdXIgY29kZSBmZXRjaGVkIHRoZSBUQ1AvVURQ
L0lDTVAgY2hlY2tzdW0NCj4gPj4+Pj4+IElTTyB0aGUgSVAgY2hlY2tzdW0gYmVjYXVzZSBpdCBz
dWJ0cmFjdHMgc2l6ZW9mKF9fc3VtMTYpLCB3aGlsZQ0KPiA+Pj4+Pj4gc2hvdWxkIHByb2JhYmx5
IHN1YnRyYWN0IHNpemVvZihfX3dzdW0pDQo+ID4+Pj4+DQo+ID4+Pj4+IEFncmVlZC4gTXkgY29k
ZSBtaXNzZWQgSVA0IGNoZWNrc3VtIHJlc3VsdC4gTWF5IGJlIHdlIG5lZWQgdG8NCj4gPj4+Pj4g
ZXh0cmFjdCAyIGNoZWNrc3VtIGluZm8gZnJvbSBsYXN0IDQgYnl0ZXMuICBGaXJzdCBjaGVja3N1
bSgyYnl0ZXMpDQo+ID4+Pj4+IGlzIElQNCBoZWFkZXIgY2hlY2tzdW0gYW5kIG5leHQgY2hlY2tz
dW0oMiBieXRlcykgIGZvcg0KPiA+Pj4+PiBUQ1AvVURQL0lDTVAgYW5kIHVzZSB0aGlzIGluZm8g
ZmluZGluZyB0aGUgbm9uIGVycm9yIGNhc2UNCj4gPj4+Pj4gbWVudGlvbmVkIGluICBUYWJsZQ0K
PiA+PiAzMC4xNy4NCj4gPj4+Pj4NCj4gPj4+Pj4gRm9yIGVnOi0NCj4gPj4+Pj4gSVBWNiBub24g
ZXJyb3ItY29uZGl0aW9uIC0tPiAgIjB4RkZGRiItLT5JUFY0SGVhZGVyQ1N1bSB2YWx1ZSBhbmQN
Cj4gPj4gIjB4MDAwMCINCj4gPj4+Pj4gVENQL1VEUC9JQ01QIENTVU0gdmFsdWUNCj4gPj4+Pj4N
Cj4gPj4+Pj4gSVBWNCBub24gZXJyb3ItY29uZGl0aW9uIC0tPiAgIjB4MDAwMCItLT5JUFY0SGVh
ZGVyQ1N1bSB2YWx1ZSBhbmQNCj4gPj4gIjB4MDAwMCINCj4gPj4+Pj4gVENQL1VEUC9JQ01QIENT
VU0gdmFsdWUNCj4gPj4+Pj4NCj4gPj4+Pj4gRG8geW91IGFncmVlPw0KPiA+Pj4NCj4gPj4+PiBX
aGF0IEkgbWVhbnQgaGVyZSBpcyBzb21lIHRoaW5nIGxpa2UgYmVsb3csIHBsZWFzZSBsZXQgbWUg
a25vdyBpZg0KPiA+Pj4+IHlvdSBoYXZlIGFueSBpc3N1ZXMgd2l0aCB0aGlzLCBvdGhlcndpc2Ug
SSB3b3VsZCBsaWtlIHRvIHNlbmQgdGhlDQo+ID4+Pj4gcGF0Y2gNCj4gPj4gd2l0aCBiZWxvdyBj
aGFuZ2VzLg0KPiA+Pj4+DQo+ID4+Pj4gRnVydGhlciBpbXByb3ZlbWVudHMgY2FuIGhhcHBlbiBs
YXRlci4NCj4gPj4+Pg0KPiA+Pj4+IFBsZWFzZSBsZXQgbWUga25vdy4NCj4gPj4+Pg0KPiA+Pj4+
ICsvKiBIYXJkd2FyZSBjaGVja3N1bSBzdGF0dXMgKi8NCj4gPj4+PiArI2RlZmluZSBJUFY0X1JY
X0NTVU1fT0sgICAgICAgICAgICAgICAgMHgwMDAwMDAwMA0KPiA+Pj4+ICsjZGVmaW5lIElQVjZf
UlhfQ1NVTV9PSyAgICAgICAgICAgICAgICAweEZGRkYwMDAwDQo+ID4+Pg0KPiA+Pj4gICAgIE1o
bSwgdGhpcyBzaG91bGQgcHJvbGx5IGNvbWUgZnJvbSB0aGUgSVAgaGVhZGVycy4uLg0KPiA+Pj4N
Cj4gPj4+IFsuLi5dDQo+ID4+Pj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L3Jl
bmVzYXMvcmF2Yl9tYWluLmMNCj4gPj4+PiBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMv
cmF2Yl9tYWluLmMNCj4gPj4+PiBpbmRleCBiYmI0MmU1MzI4ZTQuLmQ5MjAxZmJiZDQ3MiAxMDA2
NDQNCj4gPj4+PiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9yZW5lc2FzL3JhdmJfbWFpbi5j
DQo+ID4+Pj4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiX21haW4uYw0K
PiA+Pj4+IEBAIC03MjIsMTYgKzcyMiwxOCBAQCBzdGF0aWMgdm9pZCByYXZiX2dldF90eF90c3Rh
bXAoc3RydWN0DQo+ID4+Pj4gbmV0X2RldmljZSAqbmRldikNCj4gPj4+Pg0KPiA+Pj4+ICAgc3Rh
dGljIHZvaWQgcmF2Yl9yeF9jc3VtX2diZXRoKHN0cnVjdCBza19idWZmICpza2IpICB7DQo+ID4+
Pj4gLSAgICAgICB1MTYgKmh3X2NzdW07DQo+ID4+Pj4gKyAgICAgICB1MzIgY3N1bV9yZXN1bHQ7
DQo+ID4+Pg0KPiA+Pj4gICAgIFRoaXMgaXMgbm90IGFnYWluc3QgdGhlIHBhdGNoIGN1cnJlbnRs
eSB1bmRlciBpbnZlc3RpZ2F0aW9uLiA6LSkNCj4gPj4+DQo+ID4+Pj4gKyAgICAgICB1OCAqaHdf
Y3N1bTsNCj4gPj4+Pg0KPiA+Pj4+ICAgICAgICAgIC8qIFRoZSBoYXJkd2FyZSBjaGVja3N1bSBp
cyBjb250YWluZWQgaW4gc2l6ZW9mKF9fc3VtMTYpDQo+ID4+Pj4gKDIpDQo+ID4+IGJ5dGVzDQo+
ID4+Pj4gICAgICAgICAgICogYXBwZW5kZWQgdG8gcGFja2V0IGRhdGENCj4gPj4+PiAgICAgICAg
ICAgKi8NCj4gPj4+PiAtICAgICAgIGlmICh1bmxpa2VseShza2ItPmxlbiA8IHNpemVvZihfX3N1
bTE2KSkpDQo+ID4+Pj4gKyAgICAgICBpZiAodW5saWtlbHkoc2tiLT5sZW4gPCBzaXplb2YoX193
c3VtKSkpDQo+ID4+Pg0KPiA+Pj4gICAgIEkgdGhpbmsgdGhpcyB1c2FnZSBvZiBfX3dzdW0gaXMg
dmFsaWQgKEkgcmVtZW1iZXIgdGhhdCBJDQo+ID4+PiBzdWdnZXN0ZWQNCj4gPj4gaXQpLiBXZSBo
YXZlIDIgMTYtYml0IGNoZWNrc3VtcyBoZXJlDQo+ID4+DQo+ID4+ICAgICBJIG1lYW50ICJJIGRv
bid0IHRoaW5rIiwgb2YgY291cnNlLiA6LSkNCj4gPg0KPiA+IE9rIHdpbGwgdXNlIDIgKiBzaXpl
b2YoX19zdW0xNikgaW5zdGVhZCBhbmQgZXh0cmFjdCBJUFY0IGhlYWRlciBjc3VtIGFuZA0KPiBU
Q1AvVURQL0lDTVAgY3N1bSByZXN1bHQuDQo+IA0KPiAgICAgSSdtIG5vdCBzdXJlIGhvdyB0byBk
ZWFsIHdpdGggdGhlIGxhdGVyLi4uDQo+IA0KPiA+IEFsbCBlcnJvciBjb25kaXRpb24vdW5zdXBw
b3J0ZWQgY2FzZXMgd2lsbCBiZSBwYXNzZWQgdG8gc3RhY2sgd2l0aA0KPiA+IENIRUNLU1VNX05P
TkUgYW5kIG9ubHkgbm9uLWVycm9yIGNhc2VzIHdpbGwgYmUgc2V0IGFzDQo+IENIRUNLU1VNX1VO
TkNFU1NBUlkuDQoNCj4gPg0KPiA+IERvZXMgaXQgc291bmRzIGdvb2QgdG8geW91Pw0KPiANCj4g
ICAgIE5vLiBUaGUgbmV0d29ya2luZyBzdGFjayBuZWVkcyB0byBrbm93IGFib3V0IHRoZSBiYWQg
Y2hlY2tzdW1zIHRvby4NCg0KQ3VycmVudGx5IHNvbWUgb2YgdGhlIGRyaXZlcnMgaXMgZG9pbmcg
dGhpcyB3YXkgb25seS4gSXQgZG9lc24ndCBwYXNzIGJhZCBjaGVja3N1bS4NCk5vbi1lcnJvciBj
YXNlIHNldHMgQ0hFQ0tTVU1fVU5OQ0VTU0FSWSBhbmQgb3RoZXIgY2FzZSBzZXRzIENIRUNLU1VN
X05PTkUgdG8gaGFuZGxlDQpJdCBieSBzdGFjay4NCg0KWzFdIGh0dHBzOi8vZWxpeGlyLmJvb3Rs
aW4uY29tL2xpbnV4L2xhdGVzdC9zb3VyY2UvZHJpdmVycy9uZXQvZXRoZXJuZXQvcXVhbGNvbW0v
ZW1hYy9lbWFjLW1hYy5jI0wxMTQ3DQpbMl0gaHR0cHM6Ly9lbGl4aXIuYm9vdGxpbi5jb20vbGlu
dXgvbGF0ZXN0L3NvdXJjZS9kcml2ZXJzL3N0YWdpbmcvb2N0ZW9uL2V0aGVybmV0LXJ4LmMjTDM0
Mw0KDQpSZWdhcmRzLA0KQmlqdQ0KDQo+IA0KPiA+IFJlZ2FyZHMsDQo+ID4gQmlqdQ0KPiANCj4g
Pj4gWy4uLl0NCj4gDQo+IE1CUiwgU2VyZ2V5DQo=
