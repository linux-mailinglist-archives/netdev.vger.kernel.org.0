Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E96032B2B
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 10:52:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727786AbfFCIwn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 04:52:43 -0400
Received: from mail-eopbgr140130.outbound.protection.outlook.com ([40.107.14.130]:32741
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727674AbfFCIwn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Jun 2019 04:52:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.se;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V2xv2c1nXUpKS1eY7P223w68uiRCzJ17BNKotsoteVk=;
 b=MMzzb+EAohOK4x4sgqmXL1OAZmh7UBottp6GT1ZKx4Njr9mo1RZQDc3Utk3dEKGKV3RKopQFToMs8LqU6tNumYMHhcuMIqgB0zW2bbpPTjQVI5RCrpfnRcDZpG8eu0pr92c9W45HGrHQpYBz4Eoz8x08b2eePxQ1KgYaGbSQjgE=
Received: from VI1PR10MB2639.EURPRD10.PROD.OUTLOOK.COM (20.178.126.80) by
 VI1PR10MB2253.EURPRD10.PROD.OUTLOOK.COM (20.177.62.25) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1943.22; Mon, 3 Jun 2019 08:52:38 +0000
Received: from VI1PR10MB2639.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::8844:426d:816b:f5d5]) by VI1PR10MB2639.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::8844:426d:816b:f5d5%6]) with mapi id 15.20.1943.018; Mon, 3 Jun 2019
 08:52:38 +0000
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rasmus Villemoes <Rasmus.Villemoes@prevas.se>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 5/5] net: dsa: add support for mv88e6250
Thread-Topic: [PATCH v2 5/5] net: dsa: add support for mv88e6250
Thread-Index: AQHVEg8jEsslq8o0eEGsKLQNDGbj76Z6VYIAgA9Zv4A=
Date:   Mon, 3 Jun 2019 08:52:38 +0000
Message-ID: <b05a12b8-fe03-e3c4-dbf0-ca29c1931e54@prevas.dk>
References: <20190501193126.19196-1-rasmus.villemoes@prevas.dk>
 <20190524085921.11108-1-rasmus.villemoes@prevas.dk>
 <20190524085921.11108-6-rasmus.villemoes@prevas.dk>
 <20190524142728.GL2979@lunn.ch>
In-Reply-To: <20190524142728.GL2979@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: HE1PR0102CA0017.eurprd01.prod.exchangelabs.com
 (2603:10a6:7:14::30) To VI1PR10MB2639.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:803:e1::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Rasmus.Villemoes@prevas.se; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [81.216.59.226]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6960ac01-aa11-453e-b57b-08d6e800d461
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:VI1PR10MB2253;
x-ms-traffictypediagnostic: VI1PR10MB2253:
x-microsoft-antispam-prvs: <VI1PR10MB225369C29C39767379329EA88A140@VI1PR10MB2253.EURPRD10.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0057EE387C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(39850400004)(376002)(136003)(346002)(366004)(189003)(199004)(8936002)(14454004)(4326008)(81166006)(386003)(6512007)(76176011)(6506007)(54906003)(256004)(8976002)(102836004)(99286004)(68736007)(52116002)(36756003)(53936002)(66066001)(66946007)(73956011)(7736002)(31696002)(6246003)(305945005)(71190400001)(71200400001)(5660300002)(66446008)(64756008)(66556008)(66476007)(476003)(74482002)(26005)(44832011)(31686004)(186003)(316002)(3846002)(6116002)(25786009)(81156014)(6486002)(2616005)(478600001)(8676002)(229853002)(11346002)(486006)(42882007)(6916009)(446003)(2906002)(6436002)(72206003)(138113003);DIR:OUT;SFP:1102;SCL:1;SRVR:VI1PR10MB2253;H:VI1PR10MB2639.EURPRD10.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: prevas.se does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: fTqQ7wAEs36ltCQ8k971J05XeWrbdt8Q2FyQnSlLfvC3ElxPZLIBKAOAYDD2SHNQAm4auhbgf2R6UCxxcPjdnXEe2kxKrhM+EtXPBr8nzfT9q0fpDJpKAtO4qv7TX4CpvgB04F7wH4bPCx1lEOhJJI+Gh50YabBYOG9B7w2GRLeREE4oC6wyMckVgdo1vS5MhgKbJMF1OU/XXTnfN9ioQF2VVUN25ium2hHrSsMWJuS7ONaRmxTasq95Mw5O9x7rx8lVJhChapSGD0eVPXTYh5QLWAr2jX8GWvT+4Jc5UjIjky3I7gzIAEE1VD/SiqqIOHBck3HFoRSTSOqRpEKR0Mjc6hiktA0lmBdi8/PRaytPyV5bT81lmSw7Sgxu0/LJXbfnRW9I9/HiSuq8H6YZ1xUSfInzlkgnkMfLbw+alVU=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B133697A43333A438E4A334C231D9DEE@EURPRD10.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-Network-Message-Id: 6960ac01-aa11-453e-b57b-08d6e800d461
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jun 2019 08:52:38.4378
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Rasmus.Villemoes@prevas.dk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR10MB2253
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMjQvMDUvMjAxOSAxNi4yNywgQW5kcmV3IEx1bm4gd3JvdGU6DQo+PiBAQCAtNDg0MSw2ICs0
OTEwLDEwIEBAIHN0YXRpYyBjb25zdCBzdHJ1Y3Qgb2ZfZGV2aWNlX2lkIG12ODhlNnh4eF9vZl9t
YXRjaFtdID0gew0KPj4gIAkJLmNvbXBhdGlibGUgPSAibWFydmVsbCxtdjg4ZTYxOTAiLA0KPj4g
IAkJLmRhdGEgPSAmbXY4OGU2eHh4X3RhYmxlW01WODhFNjE5MF0sDQo+PiAgCX0sDQo+PiArCXsN
Cj4+ICsJCS5jb21wYXRpYmxlID0gIm1hcnZlbGwsbXY4OGU2MjUwIiwNCj4+ICsJCS5kYXRhID0g
Jm12ODhlNnh4eF90YWJsZVtNVjg4RTYyNTBdLA0KPj4gKwl9LA0KPj4gIAl7IC8qIHNlbnRpbmVs
ICovIH0sDQo+PiAgfTsNCj4gDQo+IEFoLCB5ZXMuIEkgaGFkIG5vdCB0aG91Z2h0IGFib3V0IHRo
YXQuIEEgZGV2aWNlIGF0IGFkZHJlc3MgMCB3b3VsZCBiZQ0KPiBmb3VuZCwgYnV0IGEgZGV2aWNl
IGF0IGFkZHJlc3MgMTYgd291bGQgYmUgbWlzc2VkLg0KDQpFaCwgbm8/IFRoZSBwb3J0IHJlZ2lz
dGVycyBhcmUgYXQgb2Zmc2V0IDB4OCwgaS5lLiBhdCBlaXRoZXIgU01JIGFkZHJlc3MNCjggb3Ig
MjQsIHNvIEkgZG9uJ3QgdGhpbmsgYSA2MjUwIGF0IGFkZHJlc3MgMCBjb3VsZCBiZSBkZXRlY3Rl
ZCB1c2luZw0KZWl0aGVyIG9mIHRoZSBleGlzdGluZyBmYW1pbGllcz8NCg0KPiBQbGVhc2UgYWRk
IHRoaXMgY29tcGF0aWJsZSBzdHJpbmcgdG8gRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRp
bmdzL25ldC9kc2EvbWFydmVsbC50eHQgDQoNCldpbGwgZG8uDQoNCj4+ICsrKyBiL2RyaXZlcnMv
bmV0L2RzYS9tdjg4ZTZ4eHgvZ2xvYmFsMS5jDQo+PiBAQCAtMTgyLDYgKzE4MiwyNSBAQCBpbnQg
bXY4OGU2MTg1X2cxX3Jlc2V0KHN0cnVjdCBtdjg4ZTZ4eHhfY2hpcCAqY2hpcCkNCj4+ICAJcmV0
dXJuIG12ODhlNjE4NV9nMV93YWl0X3BwdV9wb2xsaW5nKGNoaXApOw0KPj4gIH0NCj4+ICANCj4+
ICtpbnQgbXY4OGU2MjUwX2cxX3Jlc2V0KHN0cnVjdCBtdjg4ZTZ4eHhfY2hpcCAqY2hpcCkNCj4+
ICt7DQo+PiArCXUxNiB2YWw7DQo+PiArCWludCBlcnI7DQo+PiArDQo+PiArCS8qIFNldCB0aGUg
U1dSZXNldCBiaXQgMTUgKi8NCj4+ICsJZXJyID0gbXY4OGU2eHh4X2cxX3JlYWQoY2hpcCwgTVY4
OEU2WFhYX0cxX0NUTDEsICZ2YWwpOw0KPj4gKwlpZiAoZXJyKQ0KPj4gKwkJcmV0dXJuIGVycjsN
Cj4+ICsNCj4+ICsJdmFsIHw9IE1WODhFNlhYWF9HMV9DVEwxX1NXX1JFU0VUOw0KPj4gKw0KPj4g
KwllcnIgPSBtdjg4ZTZ4eHhfZzFfd3JpdGUoY2hpcCwgTVY4OEU2WFhYX0cxX0NUTDEsIHZhbCk7
DQo+PiArCWlmIChlcnIpDQo+PiArCQlyZXR1cm4gZXJyOw0KPj4gKw0KPj4gKwlyZXR1cm4gbXY4
OGU2eHh4X2cxX3dhaXRfaW5pdF9yZWFkeShjaGlwKTsNCj4+ICt9DQo+IA0KPiBJdCBsb29rcyBs
aWtlIHlvdSBjb3VsZCByZWZhY3RvciBtdjg4ZTYzNTJfZzFfcmVzZXQoKSB0byBjYWxsDQo+IHRo
aXMgZnVuY3Rpb24sIGFuZCB0aGVuIG12ODhlNjM1Ml9nMV93YWl0X3BwdV9wb2xsaW5nKGNoaXAp
Ow0KDQpZZXMsIEkgYWN0dWFsbHkgZGVsaWJlcmF0ZWx5IG1vdmVkIHRoZSA2MjUwIHJlc2V0IGZ1
bmN0aW9uIGZ1cnRoZXIgdXAgaW4NCnYyIHRvIGFsbG93IHRoYXQuIEknbGwgYWRkIHRoYXQgcmVm
YWN0b3JpbmcgYXMgYSBzZXBhcmF0ZSBwYXRjaC4NCg0KVGhhbmtzLA0KUmFzbXVzDQo=
