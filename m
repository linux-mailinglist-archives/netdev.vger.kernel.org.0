Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1BCE418003
	for <lists+netdev@lfdr.de>; Sat, 25 Sep 2021 08:37:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343815AbhIYGio (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Sep 2021 02:38:44 -0400
Received: from mail-eopbgr1400101.outbound.protection.outlook.com ([40.107.140.101]:24522
        "EHLO JPN01-TY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S243488AbhIYGin (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 Sep 2021 02:38:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GmaLNTXqKyIIPU+wjtoFF6dbeNBGO5nSMxCFPDZ5PPvzVDhS4BKX94bcJyG7cRw/NYemK11LcCaSOs5vfWKS6unRMIBhg0h+Ud7PaBzvvJxAqD+pfcBcSobRG0h6WHelB5AS+OsBjUVWEJ/FmsVCjIY0K0abfIKDiTzlNOFqUw2+BcBz7rTFEnKat6t7Bvc+UGW6ANyS8JjVluiwawpHO+04Gmj+vte1fpUvdDyAdA7Qv32NagDN1+xJ9ZMsRnPQQqJbt8OopfmnWf+ZbauqPDfaV/S/0HS2qBZggvE/Ey5wwy3xCjY9bzbeQWHKGpQaneeoUTB7fFJqcJ03EP4qvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=p30M3uberrfEjU3lOIAN42yf1Q1H+3lTVhcQS+mCc1c=;
 b=Saal0M4dBDYYCSsWokyMhcgoqq+E+lNC5dcpE1DISMVC0eaEbVVCTYpNYUn4ZEj57zUiiwDFfKOK3GgUEQkfd6aG/if+YxyB/ZXU++1PVNXEkYwAuCzrgIH3+yF/HbN1c5GRaqciTnd8mGZSnHwINcyyQxMc7RcIhGRN/KPY7+CkTYFu/OakEAoY4lpIQXX0LCx6yqrkO9jEBWWEysN3ZIPBZgkoDIBhhBHiKaeU4E+EwitiWOeNqZiuW+zW0CFP7nk2jFPlZJgIp3IGQSlAi5UBIjc1rrR+Q05B6itNVQvzGEN1Y0xTNhMnwWZJ762kWND+ViwaLDwQgyByiFCoow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p30M3uberrfEjU3lOIAN42yf1Q1H+3lTVhcQS+mCc1c=;
 b=WATi6FNUf9XDJuvwvgp79pD92prYRvJ+CFLiRu+BFC8KUVWjHqDsAHVOsNTdvvCSnr6HRNH2MX0wgUuJVxvUC4mj0gJFbPQ/NKbV0JMli963KQZ8bz1vzYVqGzWJJ9fma4JS76Ow4gwaoH+kDNvrQfPVK/FjLJtUpSpjoYnZuZc=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by OSBPR01MB2519.jpnprd01.prod.outlook.com (2603:1096:604:22::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.18; Sat, 25 Sep
 2021 06:37:00 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::6532:19dd:dfa1:4097]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::6532:19dd:dfa1:4097%9]) with mapi id 15.20.4544.019; Sat, 25 Sep 2021
 06:37:00 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Sergey Shtylyov <s.shtylyov@omp.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Adam Ford <aford173@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>
Subject: RE: [RFC/PATCH 09/18] ravb: Add half_duplex to struct ravb_hw_info
Thread-Topic: [RFC/PATCH 09/18] ravb: Add half_duplex to struct ravb_hw_info
Thread-Index: AQHXsISJy9LH6bM3Z06mQG036IrPmKuznpWAgACvrBA=
Date:   Sat, 25 Sep 2021 06:37:00 +0000
Message-ID: <OS0PR01MB5922DBD660FB1B79048DA7D686A59@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20210923140813.13541-1-biju.das.jz@bp.renesas.com>
 <20210923140813.13541-10-biju.das.jz@bp.renesas.com>
 <ef5073e2-ceb6-6b6b-c36d-d13dc7856a4e@omp.ru>
In-Reply-To: <ef5073e2-ceb6-6b6b-c36d-d13dc7856a4e@omp.ru>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: omp.ru; dkim=none (message not signed)
 header.d=none;omp.ru; dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8a404e10-f66a-49db-1215-08d97feee11f
x-ms-traffictypediagnostic: OSBPR01MB2519:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <OSBPR01MB251925D2535FA0D3EB6F920386A59@OSBPR01MB2519.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: V79I+sDVt6gH1R8v1U7+ci/5AZUyeZFTqktpQV964KbwfwyGbZvEoTuZNIXkj3xofAwRomzpLmcl6lxetSeQ2iNamFssl6MzJPrSVuDReYnqjfqYucEux5mxVFa+585+1FKwZVlqmqQEbx+PE4kUgMMItAVceT7dBY6kEkA9kIR6a9R408vRwZuPPvUEWfgmTaul8BYf8sLauuO6pzDvRwq7NsIvDbyptOjDSkBo9IbWkL950B+ePEGEba5ddj95JR/jfpK2aP3oTT3F0Oi01I5LLwsSPf32hH4Pjj50cO0H/PKgbeRGGIag/EaUHKn5p0lQBVpJj/Zf36YNQiTXpSp1Al5N4RCGwYAgAI+sMlpHHEZTYMjMIrZco5sKaxfWzdxJAZllIvUAkrSl3FtRtOAt4HYHT83Mg56yrb/XQLg3hrBvH2d3NsEIhv+JmSHcYYBmjLonI4oAtR6wjlVN/XxVjVC9K8xy6HkipTmDbsU1YiZwK3Rd5qBVKOOfAwkd7w+qsF/zr4tZ9boCczVHs+kJvAPhdqOVMUHZKGKArjfHdrSw63UYySvGBXaym36eyHZDznMILi9GYM5i6pChyCLcfLzhRR2qXB/lyr51KkoTmHS2hvpEDQDpODVpqQ/U7TPCtsy4n/7CsxrnSiWwgWLA71+VfBPqiW4WEScBO9DK1WWDRBEd/mPDcpbN7GTJLFR6QtG1EPzVO+tuh3Qrpw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2906002)(316002)(38070700005)(4326008)(122000001)(55016002)(9686003)(54906003)(508600001)(38100700002)(110136005)(53546011)(83380400001)(107886003)(7696005)(52536014)(76116006)(71200400001)(33656002)(26005)(86362001)(5660300002)(8676002)(186003)(6506007)(8936002)(64756008)(66476007)(66446008)(66556008)(66946007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cmVFbHN2YXAydWkrZ2ZPZ2N1ODNqSGl1aVBieDM4amg0R0RUMFRMWXVjbndN?=
 =?utf-8?B?RVZ3Z0hhUnpjWEJHamU4d1c4c2ZRcjQxdVRCUXN3MG8yMVVZTUltUE1mQlpn?=
 =?utf-8?B?SEdSK2pXT1JkTFYxUHhkRTVkaG4ySEZVeVRpcXFhS2IzcW50RkdXa2EwWk1K?=
 =?utf-8?B?SnV0MjJxNldDSWpFNlRjYWo4YjgyL1JIMHBSL1llOWtqTlVNRno3NzNvWVhr?=
 =?utf-8?B?YUxENCtleGhqNDU0R3JVZVJzdHNJenJka0ZQUS95YllNUFA4SDNTdmxsMEZM?=
 =?utf-8?B?VXdtWG9ZU3hIM0VicUp5a1NVRG1JbWpXb1Zla0R6STZ4MmsxYStLbFFkMlFP?=
 =?utf-8?B?anFFb29pWk5nVXNVd21zWk5aZlFDb05IUkdiRXRkTzI0dWZ2NVFMUytSRitE?=
 =?utf-8?B?OS85ck0xaUs2TkpsdkcwVzhNNnJ6dG9OSDZxV3RJMVpoSFJldGphbUxEVnYz?=
 =?utf-8?B?SVBmeGR0eFdlcmFqYWszdDQvNUUvS0lHbStOVkg4clVJL0kvd0Q1SjB2eC9O?=
 =?utf-8?B?dnpBSGNBdkpoWDVHMUl2cFZmR1E3V3JyY1JTUWlnZWNkd1dMNGxUdTlPZUN0?=
 =?utf-8?B?THZQVHlUSWVWVEc2L3paclp0c09hZHJTVGdoTGtSSFJSalM5cjc1Q00yR3h6?=
 =?utf-8?B?Wkp6ZnBaWDZtdis2RTRrNUg4T1J0a1p3dEZ6bnJRZ2VaRnZhZTFnTTBiZnUr?=
 =?utf-8?B?YndQK3dWYmFYZHRjNXhGeFdFTWNhQ3pJKzRGMXdRZGFRaDE5MEZYc010Sm5q?=
 =?utf-8?B?Um1IbUhaN1hkRGFwUzB6SS9uN2pLSU5BeEl4ZnZLZVdQUE5PTWZyc3BCWnR1?=
 =?utf-8?B?R3RoU1FJWU5URVZYVzFGU1k4MnQ3dXBqUHE4aE1leElRL1RXWlFSdGF0Wit5?=
 =?utf-8?B?RkRWNE0wWWlqZXVvOGs4TFBwY0toWmdEZWhlYjFXMHV2MXg3SXpUUFFWeE96?=
 =?utf-8?B?Mk9PdzFweFI5eHhHNW5yYTF0RlJYM1hUcGVya3V1aDI4T2JBL3o5LzhyMnlo?=
 =?utf-8?B?UE9INzVHWFRmOWJQbUlVbHk0SHhlQTNzTEtNRDVhNGpwZlM3UVFKNUcvRXNo?=
 =?utf-8?B?MFVHeEdic0J3cU5hYk5udER6bTlqTG12S2dnVGRRdTdEUWtIUkVwVm54bVVu?=
 =?utf-8?B?M0NGeWFKSzRlcHpqMkVwODRJYnVGUGM5bjJZOEU0KzlkWEl1dnZON25ZZ3Na?=
 =?utf-8?B?N1hTWHVxTHNNdk5DS2YyRDZlSE1qOUZaWExCcW5UaHRjSEhIR1ZOdUlYd1dh?=
 =?utf-8?B?amdqcEFpUVdUMUo5MnFaZjF2WFFYdkJ5RHV5dXdGWnFUYTYrcC82WU9xZDQ4?=
 =?utf-8?B?RTZHZjJXbXNYbG5DdFgrYVVXV0xHU1g2RXY3ei9xS1M2bHdlVDk1ZnBsaTJh?=
 =?utf-8?B?MDVPV0hHTmhqcnZhdWlFYmR4U2loakxiSVJtdWhhRUovdnFJQTMrZ0NnK1Vv?=
 =?utf-8?B?bE1YVW5sQXNYUU91WU44aHFXWlZuNm02TCt5VjNLM0ZPNzJYeUgrZWFKUTk1?=
 =?utf-8?B?aWplTnpkWFlGejlwVmZZUUVvazE3aXZHM2lHSkFOUFlNM2dRSW1LTWgreWVN?=
 =?utf-8?B?V0xoS01ONzM1QmhGMmZpQktiVk5uYmx3MjVuS0EwSGorNEoxUGRveUNvUGUy?=
 =?utf-8?B?amhkK3NOS0lzZys4SURHMXRQU1hGcjNMYzF6UlhQTCtIblJuSUZrUXdlZGpr?=
 =?utf-8?B?VW9hQVl0WTRPYU1WS2NsRVFMeUJaSWoyajU2Mk92RWJneEVrejBmanlMSzVG?=
 =?utf-8?Q?KkOp7LESS+KUimonue0k20pCjjbks0T8LgiZ3Ri?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a404e10-f66a-49db-1215-08d97feee11f
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Sep 2021 06:37:00.3617
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GCY6OIQqs2cLSlmlihiOammCtoxIs7KD73B5/sGAnYCfEeSY/ALOtjHTOiHHqCAFrr7hpBH8c491q8y5uyJso0yVO69E4LsI7xMi+6hUqiw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSBPR01MB2519
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgU2VyZ2VpLA0KDQpUaGFua3MgZm9yIHRoZSBmZWVkYmFjay4NCg0KPiBTdWJqZWN0OiBSZTog
W1JGQy9QQVRDSCAwOS8xOF0gcmF2YjogQWRkIGhhbGZfZHVwbGV4IHRvIHN0cnVjdA0KPiByYXZi
X2h3X2luZm8NCj4gDQo+IE9uIDkvMjMvMjEgNTowOCBQTSwgQmlqdSBEYXMgd3JvdGU6DQo+IA0K
PiA+IFJaL0cyTCBzdXBwb3J0cyBoYWxmIGR1cGxleCBtb2RlLg0KPiA+IEFkZCBhIGhhbGZfZHVw
bGV4IGh3IGZlYXR1cmUgYml0IHRvIHN0cnVjdCByYXZiX2h3X2luZm8gZm9yIHN1cHBvcnRpbmcN
Cj4gPiBoYWxmIGR1cGxleCBtb2RlIGZvciBSWi9HMkwuDQo+ID4NCj4gPiBTaWduZWQtb2ZmLWJ5
OiBCaWp1IERhcyA8YmlqdS5kYXMuanpAYnAucmVuZXNhcy5jb20+DQo+IFsuLi5dDQo+IA0KPiBS
ZXZpZXdlZC1ieTogU2VyZ2V5IFNodHlseW92IDxzLnNodHlseW92QG9tcC5ydT4NCj4gDQo+ICAg
IEp1c3QgYSBsaXR0bGUgYml0IG9mIGNoYW5nZSBuZWVkZWQuLi4NCj4gDQo+IFsuLi5dDQo+ID4g
ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yl9tYWluLmMNCj4g
PiBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yl9tYWluLmMNCj4gPiBpbmRleCA1
ZDE4NjgxNTgyYjkuLjA0YmZmNDRiNzY2MCAxMDA2NDQNCj4gPiAtLS0gYS9kcml2ZXJzL25ldC9l
dGhlcm5ldC9yZW5lc2FzL3JhdmJfbWFpbi5jDQo+ID4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJu
ZXQvcmVuZXNhcy9yYXZiX21haW4uYw0KPiA+IEBAIC0xMDc2LDYgKzEwNzYsMTggQEAgc3RhdGlj
IGludCByYXZiX3BvbGwoc3RydWN0IG5hcGlfc3RydWN0ICpuYXBpLA0KPiBpbnQgYnVkZ2V0KQ0K
PiA+ICAJcmV0dXJuIGJ1ZGdldCAtIHF1b3RhOw0KPiA+ICB9DQo+ID4NCj4gPiArc3RhdGljIHZv
aWQgcmF2Yl9zZXRfZHVwbGV4X3JnZXRoKHN0cnVjdCBuZXRfZGV2aWNlICpuZGV2KSB7DQo+ID4g
KwlzdHJ1Y3QgcmF2Yl9wcml2YXRlICpwcml2ID0gbmV0ZGV2X3ByaXYobmRldik7DQo+ID4gKwl1
MzIgZWNtciA9IHJhdmJfcmVhZChuZGV2LCBFQ01SKTsNCj4gPiArDQo+ID4gKwlpZiAocHJpdi0+
ZHVwbGV4ID4gMCkJLyogRnVsbCAqLw0KPiA+ICsJCWVjbXIgfD0gIEVDTVJfRE07DQo+ID4gKwll
bHNlCQkJLyogSGFsZiAqLw0KPiA+ICsJCWVjbXIgJj0gfkVDTVJfRE07DQo+ID4gKwlyYXZiX3dy
aXRlKG5kZXYsIGVjbXIsIEVDTVIpOw0KPiANCj4gICAgSSB0aGluayB3ZSBzaG91bGQgZG8gdGhh
dCBsaWtlIHNoX2V0aC5jOg0KPiANCj4gCXJhdmJfbW9kaWZ5KG5kZXYsIEVDTVIsIEVDTVJfRE0s
IHByaXYtPmR1cGxleCA+IDAgPyBFQ01SX0RNIDogMCk7DQpPSy4gV2lsbCBkbw0KDQpSZWdhcmRz
LA0KQmlqdQ0KDQo+IA0KPiBbLi4uXQ0KPiANCj4gTUJSLCBTZXJnZXkNCg==
