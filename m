Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B86063F1ADF
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 15:47:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240073AbhHSNrg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 09:47:36 -0400
Received: from mail-eopbgr150100.outbound.protection.outlook.com ([40.107.15.100]:38471
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239919AbhHSNrf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Aug 2021 09:47:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RNmdYF56jXdJ9lEk0eIEpDoefgvOOXscZtM3Wa67K6gBjKj5xN30NiLc1ZfYcIKqYYq7Ts24E4pz+qIUqLhWEkxnFyAqE5H6IyDP+rKq8wJjNvswrmXBS924uTr0Z7a8CKW6jECUH1lvr994gCvM/jZ2+h7BvTvIbxcnCvq3dwpUc7wgANi0ksHVoLc3S5jANcWKmVhOkH+nb+2rdxNNaguptM9hGIo5YBMRq72SGA+boWmTb6USkLrm2V1Z9nyVWj3RCL1hM/DfDRGxXiy2Z0/UWltJeROYW5jOH5pdhzDEfOTASzJS+/4fv7L8x9izybJEqoL0AGs58iaLmQC8+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dz2wIj2Kvjh2OkJub8emBYx6KVPbEzcHKacuNpPwBVA=;
 b=aj5Wr/prLz6YhUVKyi8gvicOjgjXLnYuLJoLULr7GMnhp3cRQVb0lwub6WwM+JCgcrwPlN3aV2W5m0i2UmLSDbOM5mfeJIMVbpJE1qoBYen5Z4WoONeihxpY/lI1JzruH18tk7oln5ml+ewiNlvqcqkSQpD7qIv9l7DCQFHtx8b6bVlXI247t+vCK2ApfNWCuzVrkO8V9FVkhsQF1ymGzq9OTXQNiPBxBrd1l5tEHlSkleg5NXWK1K2lVpaRQ0mUTzjjubv6L2Id0sYyhyLmxfnaGjNePPWa/b2SBJwm9o6Mu24ZG5YY6d2mSN1BJrdJ1AHOhSJw2qwevkvjQ/fozQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bang-olufsen.dk; dmarc=pass action=none
 header.from=bang-olufsen.dk; dkim=pass header.d=bang-olufsen.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dz2wIj2Kvjh2OkJub8emBYx6KVPbEzcHKacuNpPwBVA=;
 b=W9xM6wJlrt0lGu7IXBwkHwFD7Qnpj7l5Qm220nhJgt0ZA73l6LXvBRCDZI/Qoi7+NxRN9UQ5GX7I9V9pjHwjZQtjUnMX1CMF9j151NxuK/xs4shUpBNAQDtxJy+WMDSsLuZKDQ1BP7MvM5CtIJafZE3KyuCH9mywnpDombw1ELA=
Received: from HE1PR03MB3114.eurprd03.prod.outlook.com (2603:10a6:7:60::18) by
 HE1PR0301MB2169.eurprd03.prod.outlook.com (2603:10a6:3:21::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4415.17; Thu, 19 Aug 2021 13:46:56 +0000
Received: from HE1PR03MB3114.eurprd03.prod.outlook.com
 ([fe80::7cc8:2d4:32b3:320f]) by HE1PR03MB3114.eurprd03.prod.outlook.com
 ([fe80::7cc8:2d4:32b3:320f%5]) with mapi id 15.20.4415.024; Thu, 19 Aug 2021
 13:46:56 +0000
From:   =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <ALSI@bang-olufsen.dk>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Saravana Kannan <saravanak@google.com>
CC:     Vladimir Oltean <olteanv@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Frank Rowand <frowand.list@gmail.com>,
        Rob Herring <robh+dt@kernel.org>
Subject: Re: [PATCH net] net: dsa: sja1105: fix use-after-free after calling
 of_find_compatible_node, or worse
Thread-Topic: [PATCH net] net: dsa: sja1105: fix use-after-free after calling
 of_find_compatible_node, or worse
Thread-Index: AQHXk3edAldLqW55BEm1kFydkTRTGqt4NdyAgAASUYCAAEdPAIAAfkAAgAEf9ACAAIR0AIAAKESA
Date:   Thu, 19 Aug 2021 13:46:56 +0000
Message-ID: <e36c7293-b5c4-f1b3-d224-4363d4b1caf2@bang-olufsen.dk>
References: <20210817145245.3555077-1-vladimir.oltean@nxp.com>
 <cd0d9c40-d07b-e2ab-b068-d0bcb4685d09@bang-olufsen.dk>
 <20210817223101.7wbdofi7xkeqa2cp@skbuf>
 <CAGETcx8T-ReJ_Gj-U+nxQyZPsv1v67DRBvpp9hS0fXgGRUQ17w@mail.gmail.com>
 <6b89a9e1-e92e-ca99-9fbd-1d98f6a7864b@bang-olufsen.dk>
 <CAGETcx_uj0V4DChME-gy5HGKTYnxLBX=TH2rag29f_p=UcG+Tg@mail.gmail.com>
 <20210819112246.k2om3r7der3xnxq6@skbuf>
In-Reply-To: <20210819112246.k2om3r7der3xnxq6@skbuf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
authentication-results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ee697669-7b67-4937-38bb-08d96317cf48
x-ms-traffictypediagnostic: HE1PR0301MB2169:
x-microsoft-antispam-prvs: <HE1PR0301MB2169CCDBAABA6D4E017BBD6983C09@HE1PR0301MB2169.eurprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2150;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6rvssTvN3UQrQlUhaiRezaYOvdKNRoEMwE5CEkO3Dpd8nbSf7+5cCYvx2W7GCVwaRZV3XPwlLXTZeHt6lj3VNBrhgj0CP7VyrP1DLaYYFVf0fPEC3VokCTUVw14E7ty8IZxL1rX9jGF8CT5c8Gnp85imlv/CgALHi3iScUvS0HveqspEs0tQNBz+/Db6jelVpnPOBGwy69EE/+oc8LGCZRCBj6S+w9pnbDqTSSaHlhDzRjUbWOzI5MIMSKIY8m9vFDoCFsQXgghjSXbftTE3frgnU7cobbofWLrpQ573kVyhZHk8NFoUjwvHVZFdAcH/ZyjYt0rYkzOXP2CXbekCvrDNkITdossA3T+KNuIntJNOvGwE9Uv5/g4kgUDCP10tNOiw5ZZt85+43Pk8uMTYDWcLBgD/cVZ79vvwJ9s1u8IuwbINqUsyvaAZQLpeUKfjpUVfJJkl3NJVGsa4SZh+XjVZGDqELj4NkjDhWXlSwJWaQ5fakC2422QBYJPFVuFUfe8beCu7qXQ2MpZCHfkiOrlF1f4eLGbzlDUgCgBjixvk4HF/9VNMWYIhsiTWtARphIyYSk6cTZvgpDfel5nL0pnPV/U6vxjd1p++BofSXsWwrqijKYfPO38Lfkki7gtnj8+SOCk4wHIoZGvMUKm0RLsOaP7KIEUtzEhMLx3urTNJ/NycWIx5EYmVS5+XJnC7fsa8k5kaAdzMkNJiPX5GMdY46rdgViBeRBDOQuiaiDl4BuVQVQf6Vc0mDriJcmiMR4O1MTjAJ5pfv10UKdjc2Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR03MB3114.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6506007)(38070700005)(6512007)(2906002)(54906003)(86362001)(8936002)(2616005)(4326008)(8976002)(83380400001)(85182001)(508600001)(53546011)(85202003)(8676002)(66556008)(66476007)(76116006)(66446008)(91956017)(66946007)(71200400001)(36756003)(64756008)(6486002)(31696002)(7416002)(31686004)(122000001)(26005)(38100700002)(186003)(110136005)(316002)(5660300002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?clgwWDJScW5CVmlOZ1ZPQXhZK1NtbXB4b3R2OWEwRTA4T05WM0V0RjY0bTZJ?=
 =?utf-8?B?TXFucXJtcUtPUkhyT0dlQTZIalpRRUdQckd2cUo3akdLSmVQeWdUV2FSSGVv?=
 =?utf-8?B?cDF4UTFyY1M2YlNKNFJBekhZUjY2TGRPMFc1ZFFsMUdVRStFaXpGSEVPM0RC?=
 =?utf-8?B?TndhWDRCU25seDZMTXJnR2l6aGJpZFRSTnlzT0d1TFU4a01Ea0VIYzNmejVC?=
 =?utf-8?B?RzlOUC9iV29ramZuR2V3c1Z3cklkZ2NtV3dyZXI0QUNGSmdncFFURUg1MWNE?=
 =?utf-8?B?a1Y5Ulp5Zjd2WVpCZEtaUFFqZVJDWDIwWEcvVlJqRDR2aVUvUFllT1NVYmtz?=
 =?utf-8?B?TnkwRXR3QXBpaUowZ3lqVmttZDZ1UEVyZm9XbEh5b2ZXVHNOU2NubFZ1anlw?=
 =?utf-8?B?WVBxUjl4VWIyMnlRd1lnNmw3TU41M0Z4My8zb0s3MUVaWU1GVFd6QUkyRm02?=
 =?utf-8?B?OWFaVmRIOHNvYW80OGcxdlorN0hGczlPNFBxc3VzMnhXamloYWtldEVJZUxQ?=
 =?utf-8?B?cnRYclk2dURCZEpxZldHYjErUUMrZkI3M0xSUlZUWnY4RG8vSHBqcVR3bnhK?=
 =?utf-8?B?RTZNY3FNYVlPVzByaC96SmZPUHJqWUovMjNmTW5WTStJZHhEVWc1dzg1T1Ra?=
 =?utf-8?B?dFFvSmI1MDU4NUt5RDJhVzRSZWhtVFZvYzRBTmdkUG9xcjhIM1VsV3NvS1h6?=
 =?utf-8?B?N01nZVlsaFE2bXF3QzJMZ2JHaHdMaVY3c1BSTURRdVMySkFMTWtHSFZQelRw?=
 =?utf-8?B?Rlp6Q0F0bE81R29VSk84cWIvbmRCbFdMeTVFcWNGeFhFNTR2TTNNZWxlMUpn?=
 =?utf-8?B?MElFdXc5UERIb3N4NlhSR3NMZlpzem9MNFZ3WFM1MUpVMUZCQ20zZnBIc2Zs?=
 =?utf-8?B?b3hCZURDUnA0dFBnaUIvelRWenpMU2l0dSs1dzZreEJ2bU4zSWxrUzk1Z0wx?=
 =?utf-8?B?N2o1eXd6aTZIcExvQmdvRDRSR0FKSlBDV1krNGx3VGNrTDJEK0h1OW1OckQv?=
 =?utf-8?B?RlExaHRDeW1kMEllZmJGNENmRlllY1dVWUVIOW0zS1Jsby9ncDdUSzlWem43?=
 =?utf-8?B?cWtESjdLblZPRHU4S2ZtZHpTNm83NTdKQ2xncCtaN2FIcDlKUGtRdHNMZFZn?=
 =?utf-8?B?am4zb1Mxa2wzeEtuUXBBTE1Xa3puT0lYUDdMS0lOcUd4d2NENFRjRlh3ZlZG?=
 =?utf-8?B?V2FHQkZKM2FrWHZrb3QvVEVUL1J2TVNoZy9nNHd3UmcyQWtrY0Y3dHk3U1dG?=
 =?utf-8?B?SW9CZFYxZFdUY3BGWmVXWlRFOGNSajYwdHN2S0JyaFF1ZWFFS2M0dHc4akU5?=
 =?utf-8?B?b2VSTnJwclFLRVB0VWkrUmFFbzFnYmp4VC9FVWZGNnlUMzNBVlgzNkM2bnZH?=
 =?utf-8?B?dFMwVnFmdFhMVE1OREpJVkFvR3RPSHZFTm9TdGdOZHJMWmxCd2RrdHg3eGI5?=
 =?utf-8?B?bmJrdENvY0JhUkF4cDBXQmxxOUgzclhoQW9LbFpGbUVDa2N0T0VuZGtkbzFj?=
 =?utf-8?B?YWlJNmtDb1NINythTFltazJQNi9mbHh6OFF0QUo0M3NCRUZaN2c5ZmkvWUR2?=
 =?utf-8?B?YjdVKzVEd05tQ1VrQ3VmZ2NnaVlGQy91Uy9NZWVRVVc4VTIrK1Y2aGZNbHBU?=
 =?utf-8?B?bGVpMjRmNUxIai9QRXI5SGx3UytGSDVvUGJ0YTM3Nm9KN0dQUFVSQVgzVnQy?=
 =?utf-8?B?Qk5mSmFrMy81OS94RmNjNURzampyM2NWMkRoNzQrb3BuUm9uNER6N3FEekhF?=
 =?utf-8?Q?xsKZYKTnGkIDhvZAZ30AIjnI9quM5YPmjXaL6nO?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <A00FEE618509534AB42E0A6BE73F666F@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: HE1PR03MB3114.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee697669-7b67-4937-38bb-08d96317cf48
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Aug 2021 13:46:56.1231
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fp4y8MD0Gt8fhpURlwCxpONk4tgjE/olHgNzsMF4uVarwajYM97SoSajbfhh4jAbLGiebbe6G97iZqkDJsx4rA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0301MB2169
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgVmxhZGltaXIsDQoNCk9uIDgvMTkvMjEgMToyMiBQTSwgVmxhZGltaXIgT2x0ZWFuIHdyb3Rl
Og0KPiANCj4gU29ycnkgZm9yIHRoZSBkZWxheSwgSSB3YW50ZWQgdG8gcmVjb25maXJtIHdoYXQg
SSBzYWlkIChoaW50LCBJIHdhcyB3cm9uZykuDQoNClRoYW5rcyBmb3IgdGhlIGNsYXJpZmljYXRp
b24uIEl0IGFsc28gbGluZXMgdXAgd2l0aCBTYXJhdmFuYSdzIGFuYWx5c2lzIA0KZm9yIG15IGNh
c2UuDQoNCj4gDQo+IEluIG15IGNhc2UsIHdoYXRldmVyIEkgZG8sIEkgY2Fubm90IGdldCB0aGUg
ZHJpdmVyIGNvcmUgZW5mb3JjZSBhIGRldmljZQ0KPiBsaW5rIGJldHdlZW4gdGhlIGV0aGVybmV0
LXN3aXRjaCBhbmQgdGhlIFBIWS4NCj4gDQo+IFNvIEkgY2Fubm90IGFjdHVhbGx5IHNlZSB0aGUg
c2FtZSBpc3N1ZS4gV2hhdCBJIHdhcyBzZWVpbmcgd2FzIGluIGZhY3QNCj4gc3R1cGlkIHRlc3Rp
bmcgb24gbXkgcGFydCAoaXQgd2FzIHdvcmtpbmcgd2l0aCB0aGUgUEhZIGRyaXZlciBhcw0KPiBi
dWlsdC1pbiwgaXQgd2FzIHdvcmtpbmcsIHRoZW4gSSBtYWRlIGl0IGEgbW9kdWxlLCBpdCBicm9r
ZSwgSSBmb3Jnb3QgdG8NCj4gc3dpdGNoIGl0IGJhY2sgdG8gbW9kdWxlLCB0aGVuIEkgdGhvdWdo
dCBpdCdzIGJyb2tlbiB3aGlsZSB0aGUgUEhZIGlzDQo+IGJ1aWx0LWluKS4NCg0KRG8geW91IG1l
YW4gdG8gc2F5IHRoYXQgeW91IGFyZSBoaXR0aW5nIHRoZSAiY2FzZSAoMSkiIHRoYXQgU2FyYXZh
bmEgDQpkZXNjcmliZWQ/IFNlZSBiZWxvdzoNCg0KT24gOC8xOS8yMSA1OjI4IEFNLCBTYXJhdmFu
YSBLYW5uYW4gd3JvdGU6DQo+IFRoZSBtYWluIHByb2JsZW0gaXMgdGhhdCB0aGUgcGFyZW50IGRl
dmljZSBzd2l0Y2ggc2VlbXMgdG8gYmUgYXNzdW1pbmcNCj4gaXQncyBjaGlsZC9ncmFuZGNoaWxk
IGRldmljZXMgKG1kaW9idXMvUEhZcykgd2lsbCBoYXZlIHByb2JlZA0KPiBzdWNjZXNzZnVsbHkg
YXMgc29vbiBhcyB0aGV5IGFyZSBhZGRlZC4gVGhpcyBhc3N1bXB0aW9uIGlzIG5vdCB0cnVlDQo+
IGFuZCBjYW4gYmUgYnJva2VuIGZvciBtdWx0aXBsZSByZWFzb25zIHN1Y2ggYXM6DQo+IA0KPiAx
LiBUaGUgZHJpdmVyIGZvciB0aGUgY2hpbGQgZGV2aWNlcyAoUEhZcyBpbiB0aGlzIGNhc2UpIGNv
dWxkIGJlDQo+IGxvYWRlZCBhcyBhIG1vZHVsZSBhZnRlciB0aGUgcGFyZW50IChzd2l0Y2gpIGlz
IHByb2JlZC4gU28gd2hlbiB0aGUNCj4gZGV2aWNlcyBhcmUgYWRkZWQsIHRoZSBQSFlzIHdvdWxk
IG5vdCBiZSBwcm9iZWQuDQo+IDIuIFRoZSBjaGlsZCBkZXZpY2VzIGNvdWxkIGRlZmVyIHByb2Jl
IGJlY2F1c2Ugb25lIG9mIHRoZWlyIHN1cHBsaWVycw0KPiBpc24ndCByZWFkeSB5ZXQuIEVpdGhl
ciBiZWNhdXNlIG9mIGZ3X2Rldmxpbms9b24gb3IgdGhlIGZyYW1ld29yaw0KPiBpdHNlbGYgcmV0
dXJuaW5nIC1FUFJPQkVfREVGRVIuDQo+IDMuIFRoZSBjaGlsZCBkZXZpY2VzIGNvdWxkIGJlIGdl
dHRpbmcgcHJvYmVkIGFzeW5jaHJvbm91c2x5LiBTbyB0aGUNCj4gZGV2aWNlX2FkZCgpIHdvdWxk
IGtpY2sgb2ZmIGEgdGhyZWFkIHRvIHByb2JlIHRoZSBjaGlsZCBkZXZpY2VzIGluIGENCj4gc2Vw
YXJhdGUgdGhyZWFkLg0KDQpJIHdvdWxkIHRoaW5rIHRoYXQgLSBpbiBnZW5lcmFsIC0gaXQgc2hv
dWxkIG5vdCBtYXR0ZXIgaWYgdGhlIFBIWSBkcml2ZXIgDQppcyBidWlsdCBhcyBhIG1vZHVsZS4N
Cg0KS2luZCByZWdhcmRzLA0KQWx2aW4=
