Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1129333A8BE
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 00:23:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229570AbhCNXWr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Mar 2021 19:22:47 -0400
Received: from mx0d-0054df01.pphosted.com ([67.231.150.19]:39674 "EHLO
        mx0d-0054df01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229476AbhCNXWZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Mar 2021 19:22:25 -0400
Received: from pps.filterd (m0209000.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12ENM5rg003767;
        Sun, 14 Mar 2021 19:22:05 -0400
Received: from can01-to1-obe.outbound.protection.outlook.com (mail-to1can01lp2057.outbound.protection.outlook.com [104.47.61.57])
        by mx0c-0054df01.pphosted.com with ESMTP id 378u6a8c6c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 14 Mar 2021 19:22:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mGq82M7Gr88waTYrjNkenoelBj6FQyuxwOoNtHh+VxYg3EJnXvGzQqmkjAySdTqdmD6zjFJ3KaVtBbWvgCC3LUjNBEhA4ntyRwRU5nkvqrtEAtWZTehHalgwOXqtz25Q53zbjP7REl9Cj5cnf0Qya18QzfzIO0TI0EmuyjZVhBmtvwrhlPbNeUFnp2WaydHguEkwW6h/J2mY3FBliMEPZgmEkt3Bl8VqTh5D4h0do2jJxZRKnO6l/7NsVRY6Uskgeomec6Dsw2KAEUNEQ+K6kseLuyhPLHQXoFXc5Jp2xeITP3kqMCFo2amIUzRkBs5QdDJUW9oFoEneT7W6lCpFyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jb1TzklqzvMAEiRJ6UIGPsCfDa+e9sp9J8YmT9BVFqc=;
 b=ZKd/sqjhUxn3iAtk4qG4uDKS6owFMVl6od5s29z6+2QmNDBOlBYP+h51RIFknIPB/qYu1lOIYW6l1oPTfALUnAFGMzZonZO+pJQOGssKr2/xiKc6IViPpcnABlzYQHwG+JyJNdGEyptG8P6p6oGKgLu1efkqJLePf5CmkHyoqkI0gLLhX+7OxXlhXsHbakuyi01M448rNq8xjJG+thY4Mj8hgRLz3jO/1l+CuVicuitSsfM1WPjHDSxGfgCTtVRmG2eXs0UZjPo2pygnUEcy7XdgoWMT+ZiWKlxWsm2UtYb17jVmXlvwIziOhFBfqBuJGKZ8ne6h6U2DM1fucCV/9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jb1TzklqzvMAEiRJ6UIGPsCfDa+e9sp9J8YmT9BVFqc=;
 b=JZV9vXUrIAUyJB0uR353ACLr0Eo8LWwjkez/+jDXbs6CTCw6847vdQ6i6pmqRGgCvlyJS7UCYzOVoQ0Fhs+2b3Yiudc+/dgH769ZV7/6u9pQssTNLUHFVKW2fKgZETBqwG35PJZqxs/Mjc1II4zlmhdLkJIyYIrPxhzqE7Q0ogU=
Received: from YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:f::20)
 by YTXPR0101MB0959.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b00:4::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32; Sun, 14 Mar
 2021 23:22:04 +0000
Received: from YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::90d4:4d5b:b4c2:fdeb]) by YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::90d4:4d5b:b4c2:fdeb%7]) with mapi id 15.20.3933.032; Sun, 14 Mar 2021
 23:22:04 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     "andrew@lunn.ch" <andrew@lunn.ch>
CC:     "nicolas.ferre@microchip.com" <nicolas.ferre@microchip.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "claudiu.beznea@microchip.com" <claudiu.beznea@microchip.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>
Subject: Re: [PATCH net-next 2/2] net: macb: Disable PCS auto-negotiation for
 SGMII fixed-link mode
Thread-Topic: [PATCH net-next 2/2] net: macb: Disable PCS auto-negotiation for
 SGMII fixed-link mode
Thread-Index: AQHXFrO5UwFEYFC6vUuqc1ilW2fYc6qBJ68AgAL8l4A=
Date:   Sun, 14 Mar 2021 23:22:03 +0000
Message-ID: <e2a5ec71e9897eedd8a826ca75f71a721425f4c7.camel@calian.com>
References: <20210311201813.3804249-1-robert.hancock@calian.com>
         <20210311201813.3804249-3-robert.hancock@calian.com>
         <YEwZOKNaKegMCyGv@lunn.ch>
In-Reply-To: <YEwZOKNaKegMCyGv@lunn.ch>
Accept-Language: en-CA, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5 (3.28.5-16.el8) 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=calian.com;
x-originating-ip: [204.83.154.189]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4878c92f-eaa1-4cb0-99bd-08d8e73ffa3e
x-ms-traffictypediagnostic: YTXPR0101MB0959:
x-microsoft-antispam-prvs: <YTXPR0101MB09599BA6C7CDEE9A4E4DD73DEC6D9@YTXPR0101MB0959.CANPRD01.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YbXvoScFxAZ+P+x7T7C2vB/33uIlIrAuhlfGOw1tJzdjHalY23MxZgUgTdYl/hJWWbMf3e5w8RzCmSaUeed5J2iWgQWrlwDQJxdovInxodae77Q1OXqeAMCLGcEJ30eBrc9PQ7dEtsxGLbqZOHldqL3BXKyQp3ngQh62BIHoGt4l/LqvJWoeJkQdup2anTzDadhyAODuHDU1lBlwjIcPQZKKv8DD3B685rts8wQ2AGXG1tOSDuPBN4MA/74HXz4gwljBDhTNLZhNQTzHCpcUbWB6BBdaltoNoXr5uw7GCzIsGXhpakjxaiN9lJyDJHw9U4KdzLNpQaaQ3jrN7W83L9i8tT5L6vwdy9N4wnnxBF9rgz70qGox7gODbWyqD1Av4PZjOrTGf9Rj30m6Hlpw3yt6Xcs3C2yg63wnG7L7+3TPZCtfSGfkh9xay87tS8t7TKWKb261cOVvG9vDKvQAyzWgS3B+uRcsDMxSXPPJZA4Fd1ZQ+knxcCcW067RyM89EprpKdm4ejibl3+4szD6guBJYPZrmu0xNkinyz2dZJqRLh4fqjRw9fAUphHxsWbou8yTRfqd9Nq6bwSMJAB8lL5H3YaauaKnWQS/uII57qW5r4GwftfkZMtK1ZLjxKbJni+RZrgfqiTFRyT4MX0DxoGLHdCioNbagrICWhGI53VnTDAPL4G0hemudelwMjykwYWBjJBj09rEpiUExZlP6Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(136003)(39840400004)(376002)(396003)(8936002)(6916009)(71200400001)(2906002)(91956017)(64756008)(76116006)(66446008)(6486002)(66476007)(6506007)(66946007)(5660300002)(8676002)(966005)(66556008)(86362001)(186003)(36756003)(4326008)(478600001)(2616005)(6512007)(15974865002)(54906003)(316002)(44832011)(26005)(99106002)(18886075002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?L2lNYzRnWE10ajM4UStLTDNaVURsNlVUWEpidjlHcWphdHRTTHNXUktXWmdO?=
 =?utf-8?B?elpaUkdZVkpPcFdRS3NYeThzVFJWeldCOTBrTlIvZmxUcUhXM3JmRE11TW1M?=
 =?utf-8?B?cWFqL0JpSktkSUFmeWw1SDRvSE1aU3pKcjBNOE5pZit4aDBzcTBvZ1Z4dFBl?=
 =?utf-8?B?N1R3d1N0NGJJZkgwcmRhamhxUkNlMWhUczNjWFlFU2NXcks4VzJMSFl3NlZ2?=
 =?utf-8?B?b1JLQTdmTlMxZXJRY0FDN3FtS1EyRU9wcnVvN0x4RnZ6QTlZeGZOWFVxRVYv?=
 =?utf-8?B?eHFxZjhuVUJQY1B1aDlNcW85NlRsQVZCYzIvdnRJanhxQ1orNkx2YjBZK2F4?=
 =?utf-8?B?ZVF2bTNOcitPNlljZVpIL2dMZ3JKV2cxR2l6Y2Z6UEVDU29IbHByaFlPYmt1?=
 =?utf-8?B?UGtQSVlqNGd3RWVQS1BPZjhTMVV5SC9vRlVSNGhRNk5pZWJUZ2haN05BMkgr?=
 =?utf-8?B?a2tTR050bVZFUGw2YUw2U0NONThPM3NMKzlkMGkzNkVoMHhWb3Q4Nm93T083?=
 =?utf-8?B?R09TTlVXc1gya0NQZEhYTEpzT0pXZ1hYem81UTliNVpUQkJ5TTNUa0xQcHdy?=
 =?utf-8?B?UmJtZzJGRHVKSUNFekN0bTEvSkpGWjk5WVV0eldhT0tPODhjWHZtdFVBS3N6?=
 =?utf-8?B?L3hvbmZiNHZLZ2RPcXptbEFpNlZ5YUlqSzRTdTlydzBmd0lvTkFzQW9jcHI1?=
 =?utf-8?B?MVk1NjkxVHBCMmJYeHgzYmljWUMvSnV3cXk0ZUFVaHcxRGRXZ3NldnZCdEdy?=
 =?utf-8?B?dkVXWnpTRWN5T0ExWmtuSHp2OEw4MHpPQndmY0IweUV0UmpuQXZ3MTRKaGhZ?=
 =?utf-8?B?WnoxSUtESGM4QjhGTGY0MHViYlpJZklvSk1odGNxRFlVNW5JaDdIOXpVb0NG?=
 =?utf-8?B?WHIvMjJZWmtEOEV3L1RIRjYwSWRBcE9lS1VFbGlicWpEZHRsWEJyNXkvdmJn?=
 =?utf-8?B?anVkb1FlZWEvSUlmVTZaVGlhTHkvdXdudXNkQ2VvWUx0WTdoWlArYXQ5MXJz?=
 =?utf-8?B?RGV4UVRaQzdOWmgrU2NacUcyTlg2Y1pJcmtFZjBqYnNRQzFQeFFqV21GL1Mr?=
 =?utf-8?B?Vkc2N1RrZGZpaDhWbE12d3dOTEQ4bU4zSjNpU09qd2NHcU1TRXlLbWdFRzdU?=
 =?utf-8?B?UGIrQ2xkclRPclIxV0J4Rysrc3BSWThkVTdrMzd3Y0VmczVXc0dkYzh3czFF?=
 =?utf-8?B?Nmdpd0pFM29sQ014Vkw5VURNVHZ0dXU3UXgza2xaZ2lSY24wMEhKWDg2Z0F1?=
 =?utf-8?B?Q0M2bWlxckJRR1RuTFBycnAxQm5DLzJUK1BYM0g0dFk4T290dmU5cVNRTDdP?=
 =?utf-8?B?OG9NWEE5M2ZBV0VVelFxdnV2QWR3cEVpUHpGbmN4M2RtRUFVSFZiNjdmeTlU?=
 =?utf-8?B?WkR1YWZQS1Z4MFdyV3d0dmlNYzZ5MjVLTHhrbUU3SzJsSGJaUmtsM2lPZXJv?=
 =?utf-8?B?UUs4VERMR0g0cW1IZmk4WGZ6UVhlT2NYQUhaS3l1T1QwZHdyYmtPaTlBVzI4?=
 =?utf-8?B?UnlqVzlQNEhDYmJIa1ltb0k0TEd0bU1aOWV1bE1KbDZiY0ZsR0xJTVUyMXd0?=
 =?utf-8?B?cllYZUpZM1MrNnlZbExmN1JjQnpPUkZPUG1Wa2lNNFF4ODR6bjlEK29IL2lV?=
 =?utf-8?B?SmRTdmFiNURFY0pPMUYzWjFDSnVueG1LZXNLZklXRzlZSG1ZZzNzMVJiQU9s?=
 =?utf-8?B?a2NXaDV3WFlIek5vdlh3TVF5UERqY3o1ckVFeXF0UG02WEREZlExNkJrMVZz?=
 =?utf-8?Q?uZmHOEQrYhEFnvmsmtvujWVEk6EcXjiPt17tw/c?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <349C95CEDE16B64CBD2BCCF073B81CD9@CANPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 4878c92f-eaa1-4cb0-99bd-08d8e73ffa3e
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Mar 2021 23:22:03.9018
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WlQEXuTA9LCKAeejvmZdRL+kYfwU+NEKFmbK4m2epZYNQfCcSdw9XsWaAatJt26JGwCA+Lz8FmR+jnOg76hv6bBESpmTeAwd8gFN8GcTLio=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YTXPR0101MB0959
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-14_13:2021-03-12,2021-03-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 lowpriorityscore=0
 suspectscore=0 phishscore=0 bulkscore=0 clxscore=1015 malwarescore=0
 priorityscore=1501 adultscore=0 spamscore=0 mlxlogscore=890
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103140180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gU2F0LCAyMDIxLTAzLTEzIGF0IDAyOjQ1ICswMTAwLCBBbmRyZXcgTHVubiB3cm90ZToNCj4g
T24gVGh1LCBNYXIgMTEsIDIwMjEgYXQgMDI6MTg6MTNQTSAtMDYwMCwgUm9iZXJ0IEhhbmNvY2sg
d3JvdGU6DQo+ID4gV2hlbiB1c2luZyBhIGZpeGVkLWxpbmsgY29uZmlndXJhdGlvbiBpbiBTR01J
SSBtb2RlLCBpdCdzIG5vdCByZWFsbHkNCj4gPiBzZW5zaWJsZSB0byBoYXZlIGF1dG8tbmVnb3Rp
YXRpb24gZW5hYmxlZCBzaW5jZSB0aGUgbGluayBzZXR0aW5ncyBhcmUNCj4gPiBmaXhlZCBieSBk
ZWZpbml0aW9uLiBJbiBvdGhlciBjb25maWd1cmF0aW9ucywgc3VjaCBhcyBhbiBTR01JSQ0KPiA+
IGNvbm5lY3Rpb24gdG8gYSBQSFksIGl0IHNob3VsZCBnZW5lcmFsbHkgYmUgZW5hYmxlZC4NCj4g
DQo+IFNvIGhvdyBkbyB5b3UgdGVsbCB0aGUgUENTIGl0IHNob3VsZCBiZSBkb2luZyAxME1icHMg
b3ZlciB0aGUgU0dNSUkNCj4gbGluaz8gSSdtIGFzc3VtaW5nIGl0IGlzIHRoZSBQQ1Mgd2hpY2gg
ZG9lcyB0aGUgYml0IHJlcGxpY2F0aW9uLCBub3QNCj4gdGhlIE1BQz8NCg0KSSdtIG5vdCBzdXJl
IGlmIHRoaXMgaXMgdGhlIHNhbWUgZm9yIGFsbCBkZXZpY2VzIHVzaW5nIHRoaXMgQ2FkZW5jZSBJ
UCwgYnV0IHRoZQ0KcmVnaXN0ZXIgZG9jdW1lbnRhdGlvbiBJIGhhdmUgZm9yIHRoZSBYaWxpbngg
VWx0cmFTY2FsZSsgTVBTb0Mgd2UgYXJlIHVzaW5nDQppbmRpY2F0ZXMgdGhpcyBQQ1MgaXMgb25s
eSBjYXBhYmxlIG9mIDEwMDAgTWJwcyBzcGVlZHM6DQoNCmh0dHBzOi8vd3d3LnhpbGlueC5jb20v
aHRtbF9kb2NzL3JlZ2lzdGVycy91ZzEwODcvZ2VtX19fcGNzX2NvbnRyb2wuaHRtbA0KDQpTbyBp
dCBkb2Vzbid0IGFjdHVhbGx5IHNlZW0gYXBwbGljYWJsZSBpbiB0aGlzIGNhc2UuDQoNCj4gDQo+
IEknbSBzdXJwcmlzZWQgeW91IGFyZSBldmVuIHVzaW5nIFNHTUlJIHdpdGggYSBmaXhlZCBsaW5r
LiAxMDAwQmFzZVggaXMNCj4gdGhlIG5vcm0sIGFuZCB0aGVuIHlvdSBkb24ndCBuZWVkIHRvIHdv
cnJ5IGFib3V0IHRoZSBzcGVlZC4NCj4gDQoNClRoYXQgd291bGQgYmUgYSBiaXQgc2ltcGxlciwg
eWVzIC0gYnV0IGl0IHNlZW1zIGxpa2UgdGhpcyBoYXJkd2FyZSBpcyBzZXQgdXANCm1vcmUgZm9y
IFNHTUlJIG1vZGUgLSBpdCdzIG5vdCBlbnRpcmVseSBjbGVhciB0byBtZSB0aGF0IDEwMDBCYXNl
WCBpcyBzdXBwb3J0ZWQNCmluIHRoZSBoYXJkd2FyZSwgYW5kIGl0J3Mgbm90IGN1cnJlbnRseSBz
dXBwb3J0ZWQgaW4gdGhlIGRyaXZlciB0aGF0IEkgY2FuIHNlZS4NCg0KLS0gDQpSb2JlcnQgSGFu
Y29jaw0KU2VuaW9yIEhhcmR3YXJlIERlc2lnbmVyLCBDYWxpYW4gQWR2YW5jZWQgVGVjaG5vbG9n
aWVzDQp3d3cuY2FsaWFuLmNvbQ0K
