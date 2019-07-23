Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DC3B71EBD
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 20:10:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388600AbfGWSJr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 14:09:47 -0400
Received: from mail-eopbgr70070.outbound.protection.outlook.com ([40.107.7.70]:19983
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725848AbfGWSJq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jul 2019 14:09:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QdBbumlM4QcyrsZlkvZdhrsI4T1PGMk/k9JzrwMbUzR86uUwNPKSQ3YAPvqExypm+EgmI0eB3t6roNlp8OnjoEo220VonaPiBx7Zq6hZY2hpw5aMJ9dp7MJGzxDo6Y5WOB4Yr5CjR4cunpQpY4jqG0ca+WzWaK5IDutdyfkImG/ggFMxHETMwxvGH6D0he9APDD6CnYH2LBvKJH4Qf46OGvDEQ4DtTxGsD6s2io9YI1+VHD2F4ZdmxdBAWJgrAtwE1HD291axWlZC9GFogB00BXO3Ar36B6urtxNzKyaniPUcYKRh/heBVtewzUav/Fi3h2hIAWrE6lPMnM2YrHhjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Egn+zSNvq+As6cXRujBrfLR0w+3NVa+tC6UWUkczUx8=;
 b=J/iObs+m5DShrYG8NjgJz2VvLM7Ol1qtZfdwF1BD0vWRUxNCA32uChAYBoD2a570JNqrWJkNN4+1sgOoQI8HK5n3jwoIsIZwjq0ULyDS7dcNtAy+ssIbgFpXRNkSLLDAUkFE/+9b/1Mj1J3CHLgvRkicfVrkJgT7hC3aXm5qAYOo83TLQ0/3HF8OPd6UwDLr1kZRjels7gTxyYeG9778srJn/i68V5qTtxiI/UzRke2x4qbcZIDw8DEqR/ZAYHzomLQ+i7SnBH64nIrDc8AN7Qp+wu7XzRKIjU2wm1I4B65aoXp9HeBTppH7ztrEZPJKw2BnI6SH8YErVXl3tlcf8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Egn+zSNvq+As6cXRujBrfLR0w+3NVa+tC6UWUkczUx8=;
 b=DXo02XxfEzRiW8fX5LurNMNEhh4W73A1xHFP3WUe7kHj1dJD5l/aO4nuLuvaE+9dKjKrMDmLPjj77S47jx/CZULsMyUslYnqo6DOB6sEAeA5lFRo6WXzNOerew/NBKVgH5o7GRL9KkScgxWkaJr1Md+LbiwqwwBKauZc7SMHGqw=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2422.eurprd05.prod.outlook.com (10.168.75.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.15; Tue, 23 Jul 2019 18:09:40 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::7148:ecd4:3a7f:f3f]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::7148:ecd4:3a7f:f3f%11]) with mapi id 15.20.2094.011; Tue, 23 Jul 2019
 18:09:40 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "hslester96@gmail.com" <hslester96@gmail.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "siva.kallam@broadcom.com" <siva.kallam@broadcom.com>,
        "prashant@broadcom.com" <prashant@broadcom.com>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "GR-Linux-NIC-Dev@marvell.com" <GR-Linux-NIC-Dev@marvell.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "rmody@marvell.com" <rmody@marvell.com>
Subject: Re: [PATCH] net: broadcom: Use dev_get_drvdata
Thread-Topic: [PATCH] net: broadcom: Use dev_get_drvdata
Thread-Index: AQHVQVlJK3/ViIF5RkGnCRnjRK+/OKbYgOGA
Date:   Tue, 23 Jul 2019 18:09:40 +0000
Message-ID: <c4829e63a48cee1678ee46ea864135569cb9e72c.camel@mellanox.com>
References: <20190723131929.31987-1-hslester96@gmail.com>
In-Reply-To: <20190723131929.31987-1-hslester96@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.4 (3.32.4-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ccb543db-2b56-4f02-f1d4-08d70f98ee68
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2422;
x-ms-traffictypediagnostic: DB6PR0501MB2422:
x-microsoft-antispam-prvs: <DB6PR0501MB242279C496276D7D1470717DBEC70@DB6PR0501MB2422.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 0107098B6C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(376002)(366004)(136003)(396003)(346002)(199004)(189003)(66476007)(99286004)(81166006)(66066001)(81156014)(8936002)(316002)(64756008)(6506007)(58126008)(54906003)(6116002)(76176011)(102836004)(68736007)(2501003)(1361003)(3846002)(86362001)(118296001)(2351001)(4326008)(2906002)(66446008)(36756003)(6512007)(11346002)(5024004)(486006)(6436002)(71200400001)(14454004)(6486002)(229853002)(305945005)(7736002)(6246003)(71190400001)(8676002)(53936002)(256004)(91956017)(25786009)(14444005)(1411001)(5660300002)(6916009)(2616005)(476003)(186003)(76116006)(66556008)(66946007)(26005)(5640700003)(478600001)(446003);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2422;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: GhO2Av0W059yE/PrfFEP53otYblZWzTT7QPqPHIynBqy0AsYM4CyVnZCSVHnVQg8sYv5zcvkG3VA9CAfmRvfmb19dTWRBLPBLJgEzUBinN3kulP1wM6A2YIaC+ydCmtmLRS7OE4E7hpAuKWkK64oU4/fRv3frGe+vro/vB197sU/yFabCFHm5cZU4DLntf/tGgYemlpxGgcrwwd/Ah4ovk9Zy9b2cIER/r8MMCMe9QTNt89wp09sqNDTNIoearwA4JCuO1ce2r6zbpl+bUqsjJonXIJBdGvG8vrlhMiodDQBp9SjqDJdlIGnqFeFTrTM8/KbVoEZX/O9JwxHW6b9CYHcBbsx0AzSydhUS0+FVNbv8ZdpruGzTgeG5YrQ9SKaeAs37IKnTZ4mc5MQiQzTvERpM2ft6cEhSF+USuAe57M=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B4FCBAABC8D6D548B3E826295D1EF1A0@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ccb543db-2b56-4f02-f1d4-08d70f98ee68
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jul 2019 18:09:40.3296
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2422
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDE5LTA3LTIzIGF0IDIxOjE5ICswODAwLCBDaHVob25nIFl1YW4gd3JvdGU6DQo+
IEluc3RlYWQgb2YgdXNpbmcgdG9fcGNpX2RldiArIHBjaV9nZXRfZHJ2ZGF0YSwNCj4gdXNlIGRl
dl9nZXRfZHJ2ZGF0YSB0byBtYWtlIGNvZGUgc2ltcGxlci4NCj4gDQoNCkhpIENodWhvbmcsIGkg
c2VlIHRoYXQgeW91IGhhdmUgZ2VuZXJhdGVkIG1hbnkgc3RhbmQgYWxvbmUgcGF0Y2hlcyB0aGF0
DQpiZWxvbmcgdG8gdGhlIHNhbWUgc2VyaWVzL3BhdGNoc2V0Lg0KDQpBIGJldHRlciB3YXkgdG8g
ZG8gdGhpcyBpcyB0byBnZW5lcmF0ZSBvbmUgcGF0Y2hzZXQgdGhhdCBpbmNsdWRlcyBhbGwNCnRo
ZSBwYXRjaGVzIGFuZCBhdHRhY2ggYSBjb3ZlciBsZXR0ZXIgZm9yIGl0Og0KDQokIGdpdCBmb3Jt
YXQtcGF0Y2ggLXMgLS1jb3Zlci1sZXR0ZXIgLS1zdWJqZWN0LXByZWZpeD0iUEFUQ0ggbmV0LW5l
eHQiDQotbyAuL3BhdGNoc2V0LyAke0JBU0VfQ09NTUlUfS4uJHtIRUFEX0NPTU1JVH0NCg0KYW5k
IHJlc3VibWl0IHdpdGggdGhlIGVkaXRlZCBjb3Zlci1sZXR0ZXIuDQoNCj4gU2lnbmVkLW9mZi1i
eTogQ2h1aG9uZyBZdWFuIDxoc2xlc3Rlcjk2QGdtYWlsLmNvbT4NCj4gLS0tDQo+ICBkcml2ZXJz
L25ldC9ldGhlcm5ldC9icm9hZGNvbS9ibngyLmMgICAgICB8IDYgKystLS0tDQo+ICBkcml2ZXJz
L25ldC9ldGhlcm5ldC9icm9hZGNvbS9ibnh0L2JueHQuYyB8IDYgKystLS0tDQo+ICBkcml2ZXJz
L25ldC9ldGhlcm5ldC9icm9hZGNvbS90ZzMuYyAgICAgICB8IDYgKystLS0tDQo+ICAzIGZpbGVz
IGNoYW5nZWQsIDYgaW5zZXJ0aW9ucygrKSwgMTIgZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0t
Z2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvYnJvYWRjb20vYm54Mi5jDQo+IGIvZHJpdmVycy9u
ZXQvZXRoZXJuZXQvYnJvYWRjb20vYm54Mi5jDQo+IGluZGV4IGRmZGQxNGVhZGQ1Ny4uZmJjMTk2
YjQ4MGI2IDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9icm9hZGNvbS9ibngy
LmMNCj4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvYnJvYWRjb20vYm54Mi5jDQo+IEBAIC04
NjczLDggKzg2NzMsNyBAQCBibngyX3JlbW92ZV9vbmUoc3RydWN0IHBjaV9kZXYgKnBkZXYpDQo+
ICBzdGF0aWMgaW50DQo+ICBibngyX3N1c3BlbmQoc3RydWN0IGRldmljZSAqZGV2aWNlKQ0KPiAg
ew0KPiAtCXN0cnVjdCBwY2lfZGV2ICpwZGV2ID0gdG9fcGNpX2RldihkZXZpY2UpOw0KPiAtCXN0
cnVjdCBuZXRfZGV2aWNlICpkZXYgPSBwY2lfZ2V0X2RydmRhdGEocGRldik7DQo+ICsJc3RydWN0
IG5ldF9kZXZpY2UgKmRldiA9IGRldl9nZXRfZHJ2ZGF0YShkZXZpY2UpOw0KPiAgCXN0cnVjdCBi
bngyICpicCA9IG5ldGRldl9wcml2KGRldik7DQo+ICANCj4gIAlpZiAobmV0aWZfcnVubmluZyhk
ZXYpKSB7DQo+IEBAIC04NjkzLDggKzg2OTIsNyBAQCBibngyX3N1c3BlbmQoc3RydWN0IGRldmlj
ZSAqZGV2aWNlKQ0KPiAgc3RhdGljIGludA0KPiAgYm54Ml9yZXN1bWUoc3RydWN0IGRldmljZSAq
ZGV2aWNlKQ0KPiAgew0KPiAtCXN0cnVjdCBwY2lfZGV2ICpwZGV2ID0gdG9fcGNpX2RldihkZXZp
Y2UpOw0KPiAtCXN0cnVjdCBuZXRfZGV2aWNlICpkZXYgPSBwY2lfZ2V0X2RydmRhdGEocGRldik7
DQo+ICsJc3RydWN0IG5ldF9kZXZpY2UgKmRldiA9IGRldl9nZXRfZHJ2ZGF0YShkZXZpY2UpOw0K
PiAgCXN0cnVjdCBibngyICpicCA9IG5ldGRldl9wcml2KGRldik7DQo+ICANCj4gIAlpZiAoIW5l
dGlmX3J1bm5pbmcoZGV2KSkNCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2Jy
b2FkY29tL2JueHQvYm54dC5jDQo+IGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvYnJvYWRjb20vYm54
dC9ibnh0LmMNCj4gaW5kZXggNzEzNGQyYzNlYjFjLi4xYWFkNTliOGE0MTMgMTAwNjQ0DQo+IC0t
LSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2Jyb2FkY29tL2JueHQvYm54dC5jDQo+ICsrKyBiL2Ry
aXZlcnMvbmV0L2V0aGVybmV0L2Jyb2FkY29tL2JueHQvYm54dC5jDQo+IEBAIC0xMDkyMCw4ICsx
MDkyMCw3IEBAIHN0YXRpYyB2b2lkIGJueHRfc2h1dGRvd24oc3RydWN0IHBjaV9kZXYNCj4gKnBk
ZXYpDQo+ICAjaWZkZWYgQ09ORklHX1BNX1NMRUVQDQo+ICBzdGF0aWMgaW50IGJueHRfc3VzcGVu
ZChzdHJ1Y3QgZGV2aWNlICpkZXZpY2UpDQo+ICB7DQo+IC0Jc3RydWN0IHBjaV9kZXYgKnBkZXYg
PSB0b19wY2lfZGV2KGRldmljZSk7DQo+IC0Jc3RydWN0IG5ldF9kZXZpY2UgKmRldiA9IHBjaV9n
ZXRfZHJ2ZGF0YShwZGV2KTsNCj4gKwlzdHJ1Y3QgbmV0X2RldmljZSAqZGV2ID0gZGV2X2dldF9k
cnZkYXRhKGRldmljZSk7DQo+ICAJc3RydWN0IGJueHQgKmJwID0gbmV0ZGV2X3ByaXYoZGV2KTsN
Cj4gIAlpbnQgcmMgPSAwOw0KPiAgDQo+IEBAIC0xMDkzNyw4ICsxMDkzNiw3IEBAIHN0YXRpYyBp
bnQgYm54dF9zdXNwZW5kKHN0cnVjdCBkZXZpY2UNCj4gKmRldmljZSkNCj4gIA0KPiAgc3RhdGlj
IGludCBibnh0X3Jlc3VtZShzdHJ1Y3QgZGV2aWNlICpkZXZpY2UpDQo+ICB7DQo+IC0Jc3RydWN0
IHBjaV9kZXYgKnBkZXYgPSB0b19wY2lfZGV2KGRldmljZSk7DQo+IC0Jc3RydWN0IG5ldF9kZXZp
Y2UgKmRldiA9IHBjaV9nZXRfZHJ2ZGF0YShwZGV2KTsNCj4gKwlzdHJ1Y3QgbmV0X2RldmljZSAq
ZGV2ID0gZGV2X2dldF9kcnZkYXRhKGRldmljZSk7DQo+ICAJc3RydWN0IGJueHQgKmJwID0gbmV0
ZGV2X3ByaXYoZGV2KTsNCj4gIAlpbnQgcmMgPSAwOw0KPiAgDQo+IGRpZmYgLS1naXQgYS9kcml2
ZXJzL25ldC9ldGhlcm5ldC9icm9hZGNvbS90ZzMuYw0KPiBiL2RyaXZlcnMvbmV0L2V0aGVybmV0
L2Jyb2FkY29tL3RnMy5jDQo+IGluZGV4IDRjNDA0ZDIyMTNmOS4uNzdmMzUxMWI5N2RlIDEwMDY0
NA0KPiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9icm9hZGNvbS90ZzMuYw0KPiArKysgYi9k
cml2ZXJzL25ldC9ldGhlcm5ldC9icm9hZGNvbS90ZzMuYw0KPiBAQCAtMTgwNDEsOCArMTgwNDEs
NyBAQCBzdGF0aWMgdm9pZCB0ZzNfcmVtb3ZlX29uZShzdHJ1Y3QgcGNpX2Rldg0KPiAqcGRldikN
Cj4gICNpZmRlZiBDT05GSUdfUE1fU0xFRVANCj4gIHN0YXRpYyBpbnQgdGczX3N1c3BlbmQoc3Ry
dWN0IGRldmljZSAqZGV2aWNlKQ0KPiAgew0KPiAtCXN0cnVjdCBwY2lfZGV2ICpwZGV2ID0gdG9f
cGNpX2RldihkZXZpY2UpOw0KPiAtCXN0cnVjdCBuZXRfZGV2aWNlICpkZXYgPSBwY2lfZ2V0X2Ry
dmRhdGEocGRldik7DQo+ICsJc3RydWN0IG5ldF9kZXZpY2UgKmRldiA9IGRldl9nZXRfZHJ2ZGF0
YShkZXZpY2UpOw0KPiAgCXN0cnVjdCB0ZzMgKnRwID0gbmV0ZGV2X3ByaXYoZGV2KTsNCj4gIAlp
bnQgZXJyID0gMDsNCj4gIA0KPiBAQCAtMTgwOTgsOCArMTgwOTcsNyBAQCBzdGF0aWMgaW50IHRn
M19zdXNwZW5kKHN0cnVjdCBkZXZpY2UgKmRldmljZSkNCj4gIA0KPiAgc3RhdGljIGludCB0ZzNf
cmVzdW1lKHN0cnVjdCBkZXZpY2UgKmRldmljZSkNCj4gIHsNCj4gLQlzdHJ1Y3QgcGNpX2RldiAq
cGRldiA9IHRvX3BjaV9kZXYoZGV2aWNlKTsNCj4gLQlzdHJ1Y3QgbmV0X2RldmljZSAqZGV2ID0g
cGNpX2dldF9kcnZkYXRhKHBkZXYpOw0KPiArCXN0cnVjdCBuZXRfZGV2aWNlICpkZXYgPSBkZXZf
Z2V0X2RydmRhdGEoZGV2aWNlKTsNCj4gIAlzdHJ1Y3QgdGczICp0cCA9IG5ldGRldl9wcml2KGRl
dik7DQo+ICAJaW50IGVyciA9IDA7DQo+ICANCg==
