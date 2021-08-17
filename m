Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3B473EEF64
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 17:47:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238471AbhHQPrx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 11:47:53 -0400
Received: from mail-eopbgr1410127.outbound.protection.outlook.com ([40.107.141.127]:11824
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233045AbhHQPrp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Aug 2021 11:47:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M519eS40y2ZeckD6LXd9CPJC26cTLG1FuurLJCayUbAQBeLj+CDpAGs6XD0ulpJUKVVEe98akvWSdMjRyqn0Br84UBfBUj11fl77XlqxxyZ+tGkl2Mcg6VrzGuKLvn6naVyg+A4XfmYsQ+bbzPwOCXwHK4XDW5ZJsogWXlKA62gib7OlQN1+gODdBmqJxA8DztPTDnGiruknRFk9D6iFasla8vdpWP/U9BxmWhUq5kuTcq4xSnha9hdOTgJzqET5824hb332ABqhpLjbpSEGh/PWwU5637oeAVRufofqAnfCqxxaW/czYV2KjriMHY9XEIeEEBHa2w1k9b876dwwxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BaJuLRXsne419tqNkB+VQhcS0G9u0eDEo4SvbJ2WYOA=;
 b=N4+1WyRB1vZk69Z2s2IhwJBBCXxE81ffUF4fuSVcCPuQ4HelwrtgvBBpcKcGYdADzzatfkjRILmiaS2S+WZ1fT6nPr5bd/EFborssEqBU2nmwjtiyARYzMvcFVHjTlrTXnp20HU3pAduGSwUu/9Ec2+WVdjbLjkrhp7Tzj6SSozGGQh4dxBE9PmV/EDiPIUde8IJ3dwP9O5Ur8VpWMXeDn5sVMhUc2JzfLzZvy4x+d2am2wEJzqaZ8d3Vf/fFsXJeVz41P2WM+V16dTPMRmavpSCK6FcUttkKpeCHX79pkB7fQrXYbSPt+E5bQT44lQpDnifVU9vZFqnKLA2zy2yfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BaJuLRXsne419tqNkB+VQhcS0G9u0eDEo4SvbJ2WYOA=;
 b=g5c3w33dIwr0TtemXE0iQ5q88qMDccPub59m9G9VzMcAFTncBH9lsOV6T73u4bW7HwoXghk89te/p5aYH0ETCZrtvUCqy2YJFjEdLGGGPl9fo1NUGvjT6RhtvAgBYZYOzej6Da8BQO7qho/LKZ7fn3CNr/LtaQbmODMNhQHzFJ8=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by OS3PR01MB5927.jpnprd01.prod.outlook.com (2603:1096:604:c2::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.14; Tue, 17 Aug
 2021 15:47:09 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::c6f:e31f:eaa9:60fe]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::c6f:e31f:eaa9:60fe%9]) with mapi id 15.20.4415.024; Tue, 17 Aug 2021
 15:47:08 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Sergei Shtylyov <sergei.shtylyov@gmail.com>,
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
Subject: RE: [PATCH net-next v2 8/8] ravb: Add tx_drop_cntrs to struct
 ravb_hw_info
Thread-Topic: [PATCH net-next v2 8/8] ravb: Add tx_drop_cntrs to struct
 ravb_hw_info
Thread-Index: AQHXh4kMhjmmRbUodUeqNfnthDyvtKtj1bOAgBQYucA=
Date:   Tue, 17 Aug 2021 15:47:08 +0000
Message-ID: <OS0PR01MB59220310BBD822BB863F642786FE9@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20210802102654.5996-1-biju.das.jz@bp.renesas.com>
 <20210802102654.5996-9-biju.das.jz@bp.renesas.com>
 <24d63e2c-8f3b-9f75-a917-e7dc79085c84@gmail.com>
In-Reply-To: <24d63e2c-8f3b-9f75-a917-e7dc79085c84@gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 638e94fd-c0e4-475f-48bf-08d961964593
x-ms-traffictypediagnostic: OS3PR01MB5927:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <OS3PR01MB59276014199B298EAAC72C9B86FE9@OS3PR01MB5927.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KlQaFHCOf3CSxLRsWrDog/MNG2QwxSJhjqn5lOOsmpXHbej6De5AS0uBSFJSuRoscmcsMhz6GMP8v3BqVegkdtB65zCc2pLaUR0CpAXQkkOjS6LQsOQRrrFVK+usRR7JmAK9f+obANGTgEs+JzW4wAI45ayKDj4epSrfQ/1CCPR0iUImtt9muy0SbAy29hU3Kq2nFBlLV4NfMz1vwSXZ0CfydU/HyXQNJFwPBvv4JjtYiUz98YpCOmWHxD5CaC1dgG4UiJD2uT+bLQL272cmguTagYLViocLS9xtOOqoQ/FbkPzLDS8/ZYt1Kz4U0kwpHTEazcKZnLZqi6puLq3oDOgIFaxFU3YUPD3Hq9QZkky2+gzBi3Qdbh/h0W/jlsWwrTnnlSBTa6ZoaUsaOLm58J5xZug52ry3N0Sgh1cIItSh4eLcH4M2cXuIeEpAQay1T3fadnda79TOO4JhjJPXpW9dptJu46J/K5ERW20OIcoexd2eLfZyH2zjjUrl8w8XHpvoa3uscc3hLpg2+0tOS8L3zmOA1Sx7ktm5m8yd/oTyzKXNSXE6JDUrnnvzQFrph+6LP1mhtlRJRH4RGrHAJoBPzbGvOgez8FGy+nYv6HqUhq2R0eSqKzn15VvR5X1n5HN19tAOUI1iQob2tQI+0cmQaQAEQsP63Y5CfJm7wsxtZWZw2sHrro2aPwCrf+tQKpKCIMK160BIan5Leawz0g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(346002)(366004)(396003)(39850400004)(86362001)(26005)(478600001)(71200400001)(76116006)(8936002)(55016002)(186003)(4326008)(64756008)(66446008)(66556008)(9686003)(66476007)(8676002)(107886003)(66946007)(38070700005)(7416002)(54906003)(52536014)(5660300002)(7696005)(316002)(110136005)(33656002)(6506007)(122000001)(53546011)(2906002)(83380400001)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Ty90MGNsNUNmQzhsd2piSDd5SnpIcDU5SjV4OGhKR3pBdDhrelZtbm9MeDlo?=
 =?utf-8?B?MHVsQzh2N1FFbk5oOUFBeWtuV25DSWdYNWZLMXFZSDhqcXgxcHJhMlpHam01?=
 =?utf-8?B?TS9HZXB6dVUwOWgxVVo2TEhEQjlFUWtpbGR5alkwb2N4WXAzZTZkbDhCald5?=
 =?utf-8?B?OFpUc1RjcmFXRURFdEZiQjBaTXJRWm91TmlOWVhzTUFDRlo4RjZhc1F1UTkr?=
 =?utf-8?B?M2FSYTYxQnNxK1JnMW9mUFh1ZlJ6ejI2UHRqS1Bmdytvamc4MUFBaStQNkha?=
 =?utf-8?B?djI5UGRYb0ZUaUxYLzFuVU5uUUhDMFFXcmxMT3hIdEE2eXlhUy90dkkyZ1c3?=
 =?utf-8?B?ZU41ME9qTDE0Nnk5SGZ5bGhVWlIzSktadDg5U21EQXp5Z3hxNXpNK25OR25E?=
 =?utf-8?B?YnJ5WEVxNDRxRStFNnV2UGxrd24rdjhPUWhpNm9YdzJDckd3bCtMQlFnSkZy?=
 =?utf-8?B?dDYzWi9IbmFUVWIwSkxrdTlpaVl2K1ZVMUt6SHBYT2x1cnNDV3o0TnF2U0hN?=
 =?utf-8?B?c2dQREJJREpqdzBMQVN0OExpdmNkYnRFOTVMM2VnV2Z1dnJ6dUkxS2JKeDRE?=
 =?utf-8?B?YWxqclY2QmNtTGFuKzV2L1NyOFkveG5xbUZyb3QzQmtwNlpuSTFPeEQvRmZ1?=
 =?utf-8?B?L3kyLzd0OFE2cHdYbXFqU2VtUHZnM0gvb01PM2VoUkpKdnBiWFdDVk5VWUJQ?=
 =?utf-8?B?SHBQRmFqSlB3VlhKa1FJOGlPWkZFODN1RzhVZ0EyZkQrUGk0aWNKd3RWNDFQ?=
 =?utf-8?B?a1liOXJCZXlpRkROd2Z4WlFjbmFITmJtT1dWRmUwTy8yT2dhbmNrUncvZjdC?=
 =?utf-8?B?Ym1RQ0lOTTQ3NzZuZFkzYlMwVXZSNk00QzlLYTFqRGhha3hSbzJaTFdvNFVF?=
 =?utf-8?B?TzgrMXNpckVXODJVU2p0bzUxRThUTFdJR2tBbHRjd0t0aFpqSnJnU0V6V2Zi?=
 =?utf-8?B?Wk80N1hLMjlYZVU1QUVRSklrTXY1Ry9EUDl3dnUzWmJ6NTVCU3o4eVllSllu?=
 =?utf-8?B?MGNiK2hqbWRiMURDZjhyamJ6Y2pUU0RUYk9WVGFReHh1TW9VTGVqWFBpY3pq?=
 =?utf-8?B?MjByMC9pdkQxYTJPcjJXRTlQdnQwbWhZSWkyOThRZkltUWk3dDc4ZnduR1M4?=
 =?utf-8?B?ZlM3WDN3YkJDWnUyYlZ1Zjh1bWlDc2l3bi9mQ1JRZDhPU1IrYS9PQ1JydkNL?=
 =?utf-8?B?bm5OaXVRbURIdlNqS1BKMFFaOWZxSktsc0FxV0pqN3B5Q0Fib2RDbXlzYmg2?=
 =?utf-8?B?aXBxdXZGZW03S3Y3MXlLbGVkK2FDYVNhZjVvZEZGY1dIRXU5YTdtYWRyM2ZG?=
 =?utf-8?B?cnVsdTd6QzVsS1I3cVo0Z0Z3MEtBSmIrdlBuV0RjSW9HRWNGKzdZSFpLYk5O?=
 =?utf-8?B?WW9MVW9EcUZkZjZvMmpBZWVDcmwyaXlXNVJaR09LUGc0aElzVjkrazMvTzAr?=
 =?utf-8?B?ZXVUNEtFWStrZkR1bWNtMitVRTk1ZGdXclMyNzZtdjlUemVVMitiNXlPNHlm?=
 =?utf-8?B?ZUxUUDFScXhpUmZLcmhTekdmS00zbUlITWVPSGhoblNsTXVsQzRlNWh3V2dP?=
 =?utf-8?B?dlBsaWs5dHpvb1FKcEdtOGZva0dkOHNhSkplUVQxZ1g4ZWNXY3d4cldRUW1o?=
 =?utf-8?B?VVlNWms3c3NpVncvZDFwbUVUT3FSc0FqWDJCaHBIeTA3QVYwYzA0YzdSYjlQ?=
 =?utf-8?B?OTQyajFuNnZqUkgxcTQxaGw1dFd3Z0pkMThuelBBd0FXQXNJNytaenp0cVdv?=
 =?utf-8?Q?f1Uxt5lxYrGp0+HwUWfZKSSOOMU9z50NB5A+2kr?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 638e94fd-c0e4-475f-48bf-08d961964593
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Aug 2021 15:47:08.7171
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lpPK6Q73gooKLH6yxm3sxl6Fa3V2uM87iWc1fFgrxNacS/VsbJY2Cvmh7z5VhLGonUg/x3qCE6gVoAEAzKSlxqeoo2zhcLvqg5/+nWQ8KQs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS3PR01MB5927
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgU2VyZ2VpLA0KDQpUaGFua3MgZm9yIHRoZSBmZWVkYmFjay4NCg0KPiBTdWJqZWN0OiBSZTog
W1BBVENIIG5ldC1uZXh0IHYyIDgvOF0gcmF2YjogQWRkIHR4X2Ryb3BfY250cnMgdG8gc3RydWN0
DQo+IHJhdmJfaHdfaW5mbw0KPiANCj4gT24gOC8yLzIxIDE6MjYgUE0sIEJpanUgRGFzIHdyb3Rl
Og0KPiANCj4gPiBUaGUgcmVnaXN0ZXIgZm9yIHJldHJpZXZpbmcgVFggZHJvcCBjb3VudGVycyBp
cyBwcmVzZW50IG9ubHkgb24gUi1DYXINCj4gPiBHZW4zIGFuZCBSWi9HMkw7IGl0IGlzIG5vdCBw
cmVzZW50IG9uIFItQ2FyIEdlbjIuDQo+ID4NCj4gPiBBZGQgdGhlIHR4X2Ryb3BfY250cnMgaHcg
ZmVhdHVyZSBiaXQgdG8gc3RydWN0IHJhdmJfaHdfaW5mbywgdG8gZW5hYmxlDQo+ID4gdGhpcyBm
ZWF0dXJlIHNwZWNpZmljYWxseSBmb3IgUi1DYXIgR2VuMyBub3cgYW5kIGxhdGVyIGV4dGVuZCBp
dCB0bw0KPiBSWi9HMkwuDQo+ID4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBCaWp1IERhcyA8YmlqdS5k
YXMuanpAYnAucmVuZXNhcy5jb20+DQo+ID4gUmV2aWV3ZWQtYnk6IExhZCBQcmFiaGFrYXIgPHBy
YWJoYWthci5tYWhhZGV2LWxhZC5yakBicC5yZW5lc2FzLmNvbT4NCj4gPiAtLS0NCj4gPiB2MjoN
Cj4gPiAgKiBJbmNvcnBvcmF0ZWQgQW5kcmV3IGFuZCBTZXJnZWkncyByZXZpZXcgY29tbWVudHMg
Zm9yIG1ha2luZyBpdA0KPiBzbWFsbGVyIHBhdGNoDQo+ID4gICAgYW5kIHByb3ZpZGVkIGRldGFp
bGVkIGRlc2NyaXB0aW9uLg0KPiA+IC0tLQ0KPiA+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9yZW5l
c2FzL3JhdmIuaCAgICAgIHwgMSArDQo+ID4gIGRyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMv
cmF2Yl9tYWluLmMgfCA0ICsrKy0NCj4gPiAgMiBmaWxlcyBjaGFuZ2VkLCA0IGluc2VydGlvbnMo
KyksIDEgZGVsZXRpb24oLSkNCj4gPg0KPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhl
cm5ldC9yZW5lc2FzL3JhdmIuaA0KPiA+IGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9y
YXZiLmgNCj4gPiBpbmRleCAwZDY0MGRiZTFlZWQuLjM1ZmJiOWY2MGJhOCAxMDA2NDQNCj4gPiAt
LS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9yZW5lc2FzL3JhdmIuaA0KPiA+ICsrKyBiL2RyaXZl
cnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yi5oDQo+ID4gQEAgLTEwMDEsNiArMTAwMSw3IEBA
IHN0cnVjdCByYXZiX2h3X2luZm8gew0KPiA+DQo+ID4gIAkvKiBoYXJkd2FyZSBmZWF0dXJlcyAq
Lw0KPiA+ICAJdW5zaWduZWQgaW50ZXJuYWxfZGVsYXk6MTsJLyogUkFWQiBoYXMgaW50ZXJuYWwg
ZGVsYXlzICovDQo+ID4gKwl1bnNpZ25lZCB0eF9kcm9wX2NudHJzOjE7CS8qIFJBVkIgaGFzIFRY
IGVycm9yIGNvdW50ZXJzICovDQo+IA0KPiAgICBJIHN1Z2dlc3QgJ3R4X2NvdW50ZXJzJyAtLSB0
aGlzIG5hbWUgY29tZXMgZnJvbSB0aGUgc2hfZXRoIGRyaXZlciBmb3INCj4gdGhlIHNhbWUgcmVn
cyAoYnV0IG5lZ2F0ZWQgbWVhbmluZykuIEFuZCBwbGVhc2UgZG9uJ3QgY2FsbCB0aGUgaGFyZHdh
cmUNCj4gUkFWQi4gOi0pDQoNCkFncmVlZC4gV2lsbCBjaGFuZ2UgaXQgdG8gJ3R4X2NvdW50ZXJz
JyBvbiBuZXh0IHZlcnNpb24gYW5kIGNvbW1lbnQgaXQgYXMNCi8qIEFWQi1ETUFDIGhhcyBUWCBj
b3VudGVycyAqLw0KDQpDaGVlcnMsDQpCaWp1DQo=
