Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 824B949FFF
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 14:00:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728527AbfFRMA2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 08:00:28 -0400
Received: from mail-eopbgr140045.outbound.protection.outlook.com ([40.107.14.45]:26174
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727964AbfFRMA2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Jun 2019 08:00:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5HNBjvGdyFIQOXNEVSOPpKMzWgZjNcLKwlw7XTbaXlU=;
 b=FcfObAX+AAA3bmI2hU//Pi5x6miV55+nSmiHCe4/8zA4T76bHsGXo6rwmgCXnPawvzcn/mm3YM3eFsZQUeVGgOKlcq4rlGNUmMdfZ0MwxQxdjiTCSvWLVHbb3UF7fKml9cLOFMrcp4FVej6Q+I/qg4LSn1EKrfXLw/LISTiiq4I=
Received: from AM6PR05MB5879.eurprd05.prod.outlook.com (20.179.0.76) by
 AM6PR05MB5333.eurprd05.prod.outlook.com (20.177.197.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.13; Tue, 18 Jun 2019 12:00:20 +0000
Received: from AM6PR05MB5879.eurprd05.prod.outlook.com
 ([fe80::9527:fe9d:2a02:41d5]) by AM6PR05MB5879.eurprd05.prod.outlook.com
 ([fe80::9527:fe9d:2a02:41d5%5]) with mapi id 15.20.1987.014; Tue, 18 Jun 2019
 12:00:20 +0000
From:   Maxim Mikityanskiy <maximmi@mellanox.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Jonathan Lemon <bsd@fb.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Maciej Fijalkowski <maciejromanfijalkowski@gmail.com>
Subject: Re: [PATCH bpf-next v4 17/17] net/mlx5e: Add XSK zero-copy support
Thread-Topic: [PATCH bpf-next v4 17/17] net/mlx5e: Add XSK zero-copy support
Thread-Index: AQHVITd9mSR80BU/Xk6COQfdHRqYuaac31gAgAR4/QA=
Date:   Tue, 18 Jun 2019 12:00:18 +0000
Message-ID: <2b05b279-b072-b49e-65b7-3e8fd5e40951@mellanox.com>
References: <20190612155605.22450-1-maximmi@mellanox.com>
 <20190612155605.22450-18-maximmi@mellanox.com>
 <20190615084208.1a9fc711@cakuba.netronome.com>
In-Reply-To: <20190615084208.1a9fc711@cakuba.netronome.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: HE1PR0802CA0017.eurprd08.prod.outlook.com
 (2603:10a6:3:bd::27) To AM6PR05MB5879.eurprd05.prod.outlook.com
 (2603:10a6:20b:a2::12)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=maximmi@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [95.67.35.250]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 060078f9-94e3-43af-352c-08d6f3e48703
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM6PR05MB5333;
x-ms-traffictypediagnostic: AM6PR05MB5333:
x-microsoft-antispam-prvs: <AM6PR05MB533397F88895F2BB47C4707BD1EA0@AM6PR05MB5333.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 007271867D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(366004)(346002)(39860400002)(136003)(396003)(199004)(52314003)(189003)(305945005)(66556008)(476003)(11346002)(66476007)(386003)(68736007)(478600001)(2616005)(6916009)(66066001)(66946007)(73956011)(86362001)(6436002)(66446008)(25786009)(26005)(81156014)(6486002)(64756008)(446003)(6506007)(4326008)(316002)(81166006)(8676002)(102836004)(8936002)(54906003)(486006)(186003)(53546011)(229853002)(6512007)(7416002)(31686004)(53936002)(71200400001)(76176011)(71190400001)(52116002)(36756003)(256004)(31696002)(14454004)(6246003)(6116002)(3846002)(5660300002)(7736002)(99286004)(2906002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB5333;H:AM6PR05MB5879.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: fKE7QWWSMmh15mbxl6Mqf9jZSGvZX7/+FcvNTqKaSPXlRnRYr3siTFd+5JZ2Srn9DLYbACz9k/F/4TEd/sG0KnZZqPJqU73033+84Vxe6acDQUY8He3INt3himHevPQvRq1Eb8h4sTA5IFFESMMDDy+1RadWMQLFYvFqjLBzlYxp6J84c4+BNv/OYLoZscf2zxlVPg18TzCEeRPFjEHTsJoVbDp+zP5mA+40YLigLfXqV9kWMjfTBmXUsOOLn633r6EaAS3DLA4wBfux2tKY/bgjDbPxrNwl0ofOAgX9B/o03xQRS5VGBKodIXqz6pjwjdBaVIFsbteKFYF6J/cih+hLb5hU6ia1wvpUpVxp1k1ivEZmbQvIMU60aFR4VbwfIEjjuNYSpWvbCrAxTjHvwtNcdDIwtgrWDe4Iv494Lm4=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E1BDCD8DB6570B459FD5F123C45EF7B0@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 060078f9-94e3-43af-352c-08d6f3e48703
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jun 2019 12:00:18.4688
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: maximmi@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB5333
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMjAxOS0wNi0xNSAxODo0MiwgSmFrdWIgS2ljaW5za2kgd3JvdGU6DQo+IE9uIFdlZCwgMTIg
SnVuIDIwMTkgMTU6NTc6MDkgKzAwMDAsIE1heGltIE1pa2l0eWFuc2tpeSB3cm90ZToNCj4+IEBA
IC0zOTAsNiArMzkxLDEyIEBAIHZvaWQgbWx4NWVfZXRodG9vbF9nZXRfY2hhbm5lbHMoc3RydWN0
IG1seDVlX3ByaXYgKnByaXYsDQo+PiAgIHsNCj4+ICAgCWNoLT5tYXhfY29tYmluZWQgICA9IG1s
eDVlX2dldF9uZXRkZXZfbWF4X2NoYW5uZWxzKHByaXYtPm5ldGRldik7DQo+PiAgIAljaC0+Y29t
YmluZWRfY291bnQgPSBwcml2LT5jaGFubmVscy5wYXJhbXMubnVtX2NoYW5uZWxzOw0KPj4gKw0K
Pj4gKwkvKiBYU0sgUlFzICovDQo+PiArCWNoLT5tYXhfcnggICAgICAgICA9IGNoLT5tYXhfY29t
YmluZWQ7DQo+PiArCS8qIHJ4X2NvdW50IHNob3dzIHRoZSBudW1iZXIgb2YgWFNLIFJRcyB1cCB0
byB0aGUgaGlnaGVzdCBhY3RpdmUgb25lLiAqLw0KPj4gKwljaC0+cnhfY291bnQgICAgICAgPSBt
bHg1ZV94c2tfZmlyc3RfdW51c2VkX2NoYW5uZWwoJnByaXYtPmNoYW5uZWxzLnBhcmFtcywNCj4+
ICsJCQkJCQkJICAgICZwcml2LT54c2spOw0KPj4gICB9DQo+IA0KPiBBaCwgTWFjaWVqIHBvaW50
ZWQgb3V0IHRvIG1lIHRoaXMgaXMgd2h5IHlvdSB3YW50IHRoZSBwYXRjaCA3IHRvIGRvDQo+IHdo
YXQgaXQgZG9lcw0KWW91IHNlZW0gdG8gYmUgY29uZnVzaW5nIGNhdXNlIGFuZCBlZmZlY3QuIFRo
ZSBsaWJicGYgcGF0Y2ggaXMgZ29vZCANCnJlZ2FyZGxlc3Mgb2YgbWx4NWUncyBuZWVkcywgYmVj
YXVzZSB0aGUgY3VycmVudCBmb3JtdWxhIGlzIGluY29ycmVjdCwgDQphbmQgSSdtIGZpeGluZyBp
dC4gVGhlbiBJIGRvIHRoZSBjaXRlZCBjaGFuZ2UgaW4gbWx4NWUsIHdoaWNoIHBlcmZlY3RseSAN
CmZpdHMgdGhlIGZpeGVkIGZvcm11bGEuIFNvLCBJJ20gbm90IGluc2VydGluZyBzb21lIGhhY2sg
aW4gbGliYnBmIGp1c3QgDQp0byBtYWtlIG1seDVlIHdvcmssIEknbSBmaXhpbmcgYW4gZXhpc3Rp
bmcgYnVnLCBhbmQgaXQgYWxsb3dzIG1lIHRvIGRvIA0KdGhpcyBzdHVmZiBpbiBtbHg1ZS4gSXQn
cyBub3QgYWJvdXQgIkkgbmVlZCB0byB1c2UgZXRodG9vbC5yeCBpbiBtbHg1ZSwgDQpzbyBJJ20g
YWRhcHRpbmcgbGliYnBmIHRvIGl0IiwgaXQncyBhYm91dCAiSSBzZWUgYW4gaXNzdWUgaW4gbGli
YnBmLCBzbyANCkknbSBmaXhpbmcgaXQsIHRoZW4gSSdtIGFkYXB0aW5nIG1seDVlIHRvIGZpdCB0
aGUgZm9ybXVsYSIuDQoNCiA+IFRoaXMgY291bnQgaXMgZm9yIHN0YWNrJ3MgcXVldWVzLg0KDQpT
ZWNvbmQsIEkgZGlzYWdyZWUgd2l0aCB0aGlzIHN0YXRlbWVudC4gWFNLIFJYIHF1ZXVlcyBhcmUg
bm90IHN0YWNrIA0KcXVldWVzLCBidXQgaW4gaTQwZSB0aGV5IGFyZSBzdGlsbCByZWdpc3RlcmVk
IGFzIHN0YWNrIHF1ZXVlcy4gVmFyaW91cyANCmJvdW5kYXJ5IGNoZWNrcyBpbiB0aGUga2VybmVs
IHVzZSB0aGUgImFtb3VudCBvZiBzdGFjayBxdWV1ZXMiIHRvIGNoZWNrIA0KWFNLIFFJRHMuIEFs
bCB0aGUgZXhpc3RpbmcgdXNhZ2Ugb2YgdGhpcyBjb3VudCBpbiBYU0sgY29kZSBzaG93cyBpdCdz
IA0Kbm90IGZvciBzdGFjayBxdWV1ZXMgb25seSwgbXkgdXNhZ2UgaXMgbm8gZGlmZmVyZW50IGZy
b20gdGhhdCwgc28gSSANCmRvbid0IHNlZSBhbnkgaXNzdWUgaW4gZXhwb3NpbmcgWFNLIFJYIHF1
ZXVlcyB2aWEgZXRodG9vbC5yeC4NCg0KQW55d2F5LCBJJ20gcmVzcGlubmluZyB3aXRob3V0IHBh
dGNoIDcgYW5kIGV0aHRvb2wucnguDQoNCj4gTmFja2VkLWJ5OiBKYWt1YiBLaWNpbnNraSA8amFr
dWIua2ljaW5za2lAbmV0cm9ub21lLmNvbT4NCj4gDQoNCg==
