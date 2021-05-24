Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3989F38F535
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 23:55:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233316AbhEXV4c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 17:56:32 -0400
Received: from mail-eopbgr10058.outbound.protection.outlook.com ([40.107.1.58]:40465
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232662AbhEXV4b (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 May 2021 17:56:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BgQxUAG41vranVAxED+KP7jdPNEo0i3zrr/Y7dgLQ6j57v5Nkuvkv3pX4j/ODdLg9Fj+bieOid0paTmUQ96BWSxUXcJ98pgOZNhTo0jUAYw1ckf5fqd7XPLy0tjigCxVjIiYHqPuL8AalDhjZDnjavMPZEXm/TC4ia/CsY1I4e/ja4QkUpKJXASDSDsEJQ4AmW0X7PgsNk00MczeCP+uJVN0KeiZnFOAS0sCzVhbf+zeGvzxkv7S9RHXNvkYQYY50k/EbZ8Ws6W5nMuGH1XPVp5cXe9UqKp068ZevzYx/5TYUw0PUtZxFUvSWS4+zBod7sEyBaSZne3gk79o918bnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t476JhZ82OXoRqLZ8URQd6mkGt05AiVQE+cO7YgQ6mU=;
 b=FMBsnxG4YYMpuuamlmpGG3mtcjSHPrKCmNeXde7vk6B5zHVYicJCZKwHt12q6qmdZI/YcL8xqb0VxwEwqQYyEkCZ2rmJ7rRc+5zWI4+GdGM8vNd9SVbp4q0URXTy3Bn03CarcIB5NxyLWfJ3zDyAnNBYRa5/aLJYpWZYNTFwEdGKapZdq6wmRUSu1Km+uY2uokJi3CTCk60vlTjeqc5oIUIWzebK17Ax0UiNVB/nEsIeWjn7xJti1BmVumNwZ+2yEZO+vsA8IrhJdjyzWhSYesYsH/B+31I5xRuxda5R8nPjKQHmztkjD4WLnCjzohPKk+lwEXz3ZFnDi9gCR8GvfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t476JhZ82OXoRqLZ8URQd6mkGt05AiVQE+cO7YgQ6mU=;
 b=Mb8GZAR9/lebn0qyZfySxmCHOuR9Mbtu6Q9YQHxh6UFkUyTeh2hublIVX/QBQoEFX5V9mi9Uoj7gynKXjQGPU0tvmhzlen+qNhZlD5JqxiZ5xhIBbIi3z82L5SYEhGonqzMDG+PyF1yRLE4jZ5LhPPoYte3qF6YOt3FT0/arHhA=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB7216.eurprd04.prod.outlook.com (2603:10a6:800:1b0::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.25; Mon, 24 May
 2021 21:55:00 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::b1a0:d654:a578:53ab]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::b1a0:d654:a578:53ab%7]) with mapi id 15.20.4150.027; Mon, 24 May 2021
 21:55:00 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "cao88yu@gmail.com" <cao88yu@gmail.com>
Subject: Re: [PATCH net 2/3] dsa: mv88e6xxx: Fix MTU definition
Thread-Topic: [PATCH net 2/3] dsa: mv88e6xxx: Fix MTU definition
Thread-Index: AQHXUOR3h9IAKTlDoEi9bxTX5ekj4qrzLRiA
Date:   Mon, 24 May 2021 21:54:59 +0000
Message-ID: <20210524215459.mj4yrm55vqu3dflp@skbuf>
References: <20210524213313.1437891-1-andrew@lunn.ch>
 <20210524213313.1437891-3-andrew@lunn.ch>
In-Reply-To: <20210524213313.1437891-3-andrew@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.26.52.84]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f67d2f1f-e4a7-48a0-2778-08d91efe93da
x-ms-traffictypediagnostic: VE1PR04MB7216:
x-microsoft-antispam-prvs: <VE1PR04MB721669F279908656FF518C59E0269@VE1PR04MB7216.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Brz5woCK/kdr8yw5mDU9Jzc5V3bD1dnQQqC/dG9L0G8Yanzg22W8QHmqIVt3rT4yaNICu8LEXersj26rti+m1OuGt8IuT0ix33YxYH3LEIdpAjYzTmE6hxI48TgqNGwTS71Gcutqpp0k5oXkbDf+afUOcbZjH1hEKBXdemo20bDrywrJ84pJauxKqQYosTI5Vg2obd1txkRNqHds+6Kf/5uO1FPOqtNVVMftnPxd7FVUKXKxdA3bWxsZNeraUVKLWm0fIKdAZ3S3CtkO1T1RYjMJklamdUyY5hUO+88ntzAOCR/xPTHcMMctqghk9PnDhK8Am2MEL+1DhQwq6ZcpfzRgn7eMF/kSbvND38waKkJ4P3KsBT474NxAKY8zg3do5hzQv7QdNvnA3v96kTBvBwJne80QhBG9ed6j8TtM1oZSfebR4HNm6rbsItCCm3dDRhcpB6tRmAMx/K7SRygicjlJxnKLxHi8FWF+IsG75kPUYgJT/FFsOlTReAx8TRVuDSos7CMiT5KpJXzOsI+nkG+Rd7cprM6wgLREqOlLuDXUB2ZJ3LseIYJo5N6vr/DuxqeGNX41jSaB+WNkuBeAJjr4uWhEFiT2bNgiBslpEh4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(346002)(39860400002)(396003)(136003)(376002)(366004)(478600001)(186003)(5660300002)(71200400001)(6512007)(86362001)(6506007)(8936002)(26005)(83380400001)(1076003)(8676002)(9686003)(91956017)(66446008)(54906003)(4326008)(66476007)(33716001)(66556008)(66946007)(64756008)(44832011)(6916009)(38100700002)(6486002)(316002)(122000001)(76116006)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?UkQwMXY2eWk3Zlo3K2hGWkFFT0dkOWxEeGY0SFkwZ1BwV0pHd1o0MUxxWkJa?=
 =?utf-8?B?SnVaZTJOeFp0NHp4ajV3VGdPc1BqUHNOU1JhK3N5UHp4ZWRvWG1lTGN1aTVK?=
 =?utf-8?B?ZWlvM0ltK25LNEdaOGI4UlVrRnV0bk0xZkx1M3dVaC93bkZpYlNVL1I5d3NI?=
 =?utf-8?B?TjBweTdVVE5xNGpvZGhBdlhkUVBVcit5anNnd1FnM2xhMGZPeVZYQzBUYVRp?=
 =?utf-8?B?Z29hMzBmUXNIcXVpUHNDc1AwY1RGbWpHRmZBcFdQd1FpSitkMHZRMTVIQ2ZJ?=
 =?utf-8?B?ZUVyd0JZVkpzZmF6bGsxdjM3dXBmOENES1pXLzk4NkZ1dWxLRWNPZUpDQnEw?=
 =?utf-8?B?eUgxYXpWQU5mbUxlYkhJclA2aGJ2OUROL0Y2MWhFUEhQTEtHZVpaRVlIbGdq?=
 =?utf-8?B?TkZvUHRGckMzeVArV0ZMczc2UVM2eko0Z0JnSktFQm5CektZNXltSHpHVmt3?=
 =?utf-8?B?NlNkTmtvbU1JRVFTVWJzTTlFVmRRcVEwRVMvTG5yMEdnVzR3akgzU2xJRTJZ?=
 =?utf-8?B?T1FVb3YvTEJkOVM5Lzh0YzM0S2Q1bkppcXFrUDZLa05sQkRDUzZCVGlLeW84?=
 =?utf-8?B?a3EyRU1XTi81RHdlRVcrRDZtQlFnOXN4WmF6dHUxSXVORXRvV2JhOWRlbkMx?=
 =?utf-8?B?Zm1Wc0Z3UDEyQ0IxNnZmMGZVaWRSVlNKTXJaVlZjQzFaeERlbStmZFIzNS9n?=
 =?utf-8?B?dlc0VVY4SzZ3NVU3Vk40cTQxeEM4ZERTeUE0TWRNdjNGT1hXNmNIRncyS0sy?=
 =?utf-8?B?RmZJejdwb0t4YUFkL1VuYStiV3lmZmh2NzdOckh3SEhlaVM2d2FJeGlycVlT?=
 =?utf-8?B?b3c5WHZ5RklYMENlaEVvNVpyM000VGFROUhHcDR2NWxQZ2tJV1ArK2FINjNS?=
 =?utf-8?B?QlNZZnBsbzNZTW10cHhMazVqTXY3QTF3ZFA0aUJIZldxTzlSZWtsR1JtY0RE?=
 =?utf-8?B?Rm42cXRjeXVYeVFpNXdzMDBFWStwS2xwTlJhSThEelNIYjY2djBQK0RQR1Zj?=
 =?utf-8?B?Y1lONlB1b2xidWNscGJFV29Pc2NSNzFJVUw1T3JVZHRKS1VneHhMV09oSERD?=
 =?utf-8?B?cXdOaENucFRPK3VQQ3h4QWRlcjFGUE44R1p5R0cyN1lLZ09Xc28reElONVpT?=
 =?utf-8?B?Z3U1eGdYNUVQNUZxSVVrTXVyK25KYVVmRllWQldia3EwTXlkN0dNQldHUEFM?=
 =?utf-8?B?ellyODVTRVVQbU1VanpuSmJiY2ZHQ094T3drWmNTQTNKSFluMW9MNFRaUGNP?=
 =?utf-8?B?ZXlkSTJzVlBlSVphQ04vcVJzeml5YkRRUlVkOGVBamUrWWhQZmlIRVlCMnh5?=
 =?utf-8?B?UzVCdVVvUC9maXpCT2dZUElzdzlya21meXJVenRiaFFOM2xSVEgwekp0d1lw?=
 =?utf-8?B?L09xZVp6NWYzUXYrcWZzSlNBSU1jZHFMbHhGT25oS1dmWW9yNjhNR1dSVEZx?=
 =?utf-8?B?QkMrZFNyTW1UUjNWS0l5VjdLS0hsN211bzM5Y2dCYVBvL2dVWUhvT215ZXh3?=
 =?utf-8?B?ZGVwdUhoOEJaV3A4QXZJUnVITzdJb0hYQXNKVGJoSzJ3SWFwQ2V2OVY0a1U2?=
 =?utf-8?B?NjNYbDdnZm5YZk04TnBXTGVnRjR2bll1TzJpT3pKRmdaMytKMU1ZaUN5eXkx?=
 =?utf-8?B?c3RubVNLL3ZFOXl1amI3SEhFQUN3Z2ZWaDRSME9IZlJYZHBqaXFvS3liR3kr?=
 =?utf-8?B?bjVaREJ2VG5RM2hiby9tRG1CL1cwSjhMTG5wRXNZcWN4L3FyZXhFdGpDMHo1?=
 =?utf-8?Q?VfkJUbE+YslSahhKLYTYXIrEawmkqxCTrcNdaOq?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <196782AF7C597344BE1577371F4E25B8@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f67d2f1f-e4a7-48a0-2778-08d91efe93da
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 May 2021 21:54:59.9390
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: F/hI79QgmEKTMkqApHlTuQ67Y1QdIZRdhOJQEi7b43C92uNHtqItmm3fabcOdTCejXu2GUOpcZ4DClEeqm/BcA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7216
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCBNYXkgMjQsIDIwMjEgYXQgMTE6MzM6MTJQTSArMDIwMCwgQW5kcmV3IEx1bm4gd3Jv
dGU6DQo+IFRoZSBNVFUgcGFzc2VkIHRvIHRoZSBEU0EgZHJpdmVyIGlzIHRoZSBwYXlsb2FkIHNp
emUsIHR5cGljYWxseSAxNTAwLg0KPiBIb3dldmVyLCB0aGUgc3dpdGNoIHVzZXMgdGhlIGZyYW1l
IHNpemUgd2hlbiBhcHBseWluZyByZXN0cmljdGlvbnMuDQo+IEFkanVzdCB0aGUgTVRVIHdpdGgg
dGhlIHNpemUgb2YgdGhlIEV0aGVybmV0IGhlYWRlciBhbmQgdGhlIGZyYW1lDQo+IGNoZWNrc3Vt
Lg0KPiANCj4gRml4ZXM6IDFiYWYwZmFjMTBmYiAoIm5ldDogZHNhOiBtdjg4ZTZ4eHg6IFVzZSBj
aGlwLXdpZGUgbWF4IGZyYW1lIHNpemUgZm9yIE1UVSIpDQo+IFJlcG9ydGVkIGJ5OiDmm7nnhZwg
PGNhbzg4eXVAZ21haWwuY29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBBbmRyZXcgTHVubiA8YW5kcmV3
QGx1bm4uY2g+DQo+IC0tLQ0KPiAgZHJpdmVycy9uZXQvZHNhL212ODhlNnh4eC9jaGlwLmMgfCAx
MiArKysrKystLS0tLS0NCj4gIGRyaXZlcnMvbmV0L2RzYS9tdjg4ZTZ4eHgvcG9ydC5jIHwgIDIg
KysNCj4gIDIgZmlsZXMgY2hhbmdlZCwgOCBpbnNlcnRpb25zKCspLCA2IGRlbGV0aW9ucygtKQ0K
PiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2RzYS9tdjg4ZTZ4eHgvY2hpcC5jIGIvZHJp
dmVycy9uZXQvZHNhL212ODhlNnh4eC9jaGlwLmMNCj4gaW5kZXggY2JlZGFlZTNjZWZkLi41OTNk
YzczNDU4MmUgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvbmV0L2RzYS9tdjg4ZTZ4eHgvY2hpcC5j
DQo+ICsrKyBiL2RyaXZlcnMvbmV0L2RzYS9tdjg4ZTZ4eHgvY2hpcC5jDQo+IEBAIC0yNzc1LDgg
KzI3NzUsOCBAQCBzdGF0aWMgaW50IG12ODhlNnh4eF9zZXR1cF9wb3J0KHN0cnVjdCBtdjg4ZTZ4
eHhfY2hpcCAqY2hpcCwgaW50IHBvcnQpDQo+ICAJaWYgKGVycikNCj4gIAkJcmV0dXJuIGVycjsN
Cj4gIA0KPiAtCS8qIFBvcnQgQ29udHJvbCAyOiBkb24ndCBmb3JjZSBhIGdvb2QgRkNTLCBzZXQg
dGhlIG1heGltdW0gZnJhbWUgc2l6ZSB0bw0KPiAtCSAqIDEwMjQwIGJ5dGVzLCBkaXNhYmxlIDgw
Mi4xcSB0YWdzIGNoZWNraW5nLCBkb24ndCBkaXNjYXJkIHRhZ2dlZCBvcg0KPiArCS8qIFBvcnQg
Q29udHJvbCAyOiBkb24ndCBmb3JjZSBhIGdvb2QgRkNTLCBzZXQgdGhlIE1UVSBzaXplIHRvDQo+
ICsJICogMTAyMjIgYnl0ZXMsIGRpc2FibGUgODAyLjFxIHRhZ3MgY2hlY2tpbmcsIGRvbid0IGRp
c2NhcmQgdGFnZ2VkIG9yDQo+ICAJICogdW50YWdnZWQgZnJhbWVzIG9uIHRoaXMgcG9ydCwgZG8g
YSBkZXN0aW5hdGlvbiBhZGRyZXNzIGxvb2t1cCBvbiBhbGwNCj4gIAkgKiByZWNlaXZlZCBwYWNr
ZXRzIGFzIHVzdWFsLCBkaXNhYmxlIEFSUCBtaXJyb3JpbmcgYW5kIGRvbid0IHNlbmQgYQ0KPiAg
CSAqIGNvcHkgb2YgYWxsIHRyYW5zbWl0dGVkL3JlY2VpdmVkIGZyYW1lcyBvbiB0aGlzIHBvcnQg
dG8gdGhlIENQVS4NCj4gQEAgLTI3OTUsNyArMjc5NSw3IEBAIHN0YXRpYyBpbnQgbXY4OGU2eHh4
X3NldHVwX3BvcnQoc3RydWN0IG12ODhlNnh4eF9jaGlwICpjaGlwLCBpbnQgcG9ydCkNCj4gIAkJ
cmV0dXJuIGVycjsNCj4gIA0KPiAgCWlmIChjaGlwLT5pbmZvLT5vcHMtPnBvcnRfc2V0X2p1bWJv
X3NpemUpIHsNCj4gLQkJZXJyID0gY2hpcC0+aW5mby0+b3BzLT5wb3J0X3NldF9qdW1ib19zaXpl
KGNoaXAsIHBvcnQsIDEwMjQwKTsNCj4gKwkJZXJyID0gY2hpcC0+aW5mby0+b3BzLT5wb3J0X3Nl
dF9qdW1ib19zaXplKGNoaXAsIHBvcnQsIDEwMjIyKTsNCj4gIAkJaWYgKGVycikNCj4gIAkJCXJl
dHVybiBlcnI7DQo+ICAJfQ0KPiBAQCAtMjg4NSwxMCArMjg4NSwxMCBAQCBzdGF0aWMgaW50IG12
ODhlNnh4eF9nZXRfbWF4X210dShzdHJ1Y3QgZHNhX3N3aXRjaCAqZHMsIGludCBwb3J0KQ0KPiAg
CXN0cnVjdCBtdjg4ZTZ4eHhfY2hpcCAqY2hpcCA9IGRzLT5wcml2Ow0KPiAgDQo+ICAJaWYgKGNo
aXAtPmluZm8tPm9wcy0+cG9ydF9zZXRfanVtYm9fc2l6ZSkNCj4gLQkJcmV0dXJuIDEwMjQwOw0K
PiArCQlyZXR1cm4gMTAyNDAgLSBFVEhfSExFTiAtIEVUSF9GQ1NfTEVOOw0KPiAgCWVsc2UgaWYg
KGNoaXAtPmluZm8tPm9wcy0+c2V0X21heF9mcmFtZV9zaXplKQ0KPiAtCQlyZXR1cm4gMTYzMjsN
Cj4gLQlyZXR1cm4gMTUyMjsNCj4gKwkJcmV0dXJuIDE2MzIgLSBFVEhfSExFTiAtIEVUSF9GQ1Nf
TEVOOw0KPiArCXJldHVybiAxNTIyIC0gRVRIX0hMRU4gLSBFVEhfRkNTX0xFTjsNCj4gIH0NCj4g
IA0KPiAgc3RhdGljIGludCBtdjg4ZTZ4eHhfY2hhbmdlX210dShzdHJ1Y3QgZHNhX3N3aXRjaCAq
ZHMsIGludCBwb3J0LCBpbnQgbmV3X210dSkNCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2Rz
YS9tdjg4ZTZ4eHgvcG9ydC5jIGIvZHJpdmVycy9uZXQvZHNhL212ODhlNnh4eC9wb3J0LmMNCj4g
aW5kZXggZjc3ZTJlZTY0YTYwLi4yODY2NGVhOTEyNDQgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMv
bmV0L2RzYS9tdjg4ZTZ4eHgvcG9ydC5jDQo+ICsrKyBiL2RyaXZlcnMvbmV0L2RzYS9tdjg4ZTZ4
eHgvcG9ydC5jDQo+IEBAIC0xMjc3LDYgKzEyNzcsOCBAQCBpbnQgbXY4OGU2MTY1X3BvcnRfc2V0
X2p1bWJvX3NpemUoc3RydWN0IG12ODhlNnh4eF9jaGlwICpjaGlwLCBpbnQgcG9ydCwNCj4gIAl1
MTYgcmVnOw0KPiAgCWludCBlcnI7DQo+ICANCj4gKwlzaXplICs9IEVUSF9ITEVOICsgRVRIX0ZD
U19MRU47DQo+ICsNCj4gIAllcnIgPSBtdjg4ZTZ4eHhfcG9ydF9yZWFkKGNoaXAsIHBvcnQsIE1W
ODhFNlhYWF9QT1JUX0NUTDIsICZyZWcpOw0KPiAgCWlmIChlcnIpDQo+ICAJCXJldHVybiBlcnI7
DQo+IC0tIA0KPiAyLjMxLjENCj4gDQoNCkRvZXMgdGhlIGhhcmR3YXJlIGFjY291bnQgZm9yIFZM
QU4tdGFnZ2VkIGZyYW1lcyBhdXRvbWF0aWNhbGx5PyBJZiBub3QsDQppdCBpcyBub3QgdW5jb21t
b24gdG8gdXNlIFZMQU5fRVRIX0hMRU4gaW5zdGVhZCBvZiBFVEhfSExFTiAodGhlIFZMQU4NCmhl
YWRlciBpcyBub3QgcGFydCBvZiB0aGUgTDIgU0RVKS4=
