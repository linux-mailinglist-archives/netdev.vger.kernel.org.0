Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56C957D695
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 09:46:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730861AbfHAHqM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 03:46:12 -0400
Received: from mail-eopbgr60073.outbound.protection.outlook.com ([40.107.6.73]:58086
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728582AbfHAHqM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Aug 2019 03:46:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xqjyp4pSTnVzcRcHzpFqWGqpXD9UBCqhRhgl3ezX+Ty2sjEUDcoPcyM6eATBc89kpDB7gJETV8bKeDeduV763iueXhH5xqeSsOOEO4fZnCmb9xrCzHkh94x+iSugO+9dONFH8BDoy3z/Uk3PLToJS/XG0WmAegyx1Gm3ZBy9dHCyBqSDrSFz6ggzMHYJslDBMOMA9jsTFTB4jZ70RhMlu48jPiWrRIat9v2bVITstW3n7EPDkLoMwni3lZ6aRBtVltI4xvhrf/LlwQ4iiCSWBA8qPo0ruTkmCNq+9jzkSLfR7T98xHx2o0NAV/F1wp0b959A7gdKnOs+WH7lT3tfjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JDbi1mGOVB0mozz/4AGkoWP+Tc58mxw/pnZRZbQ/je8=;
 b=eazwIGh5S+W8Ikd9EeaKv1slo0+hbKQvlksLt7exoyrdKYKP35ODMYgqIQzW+Z2CRy1Y4RiVHcU6QR/If0mI/KJQ0LJi0J8U18PLSqSgcfg0e90pSfqPtnNtsIeh4u2Y3uZ5T+wojbkcXKogMswiS81uEns+wAQ+PnaY/ZgUUQx1H+LxlL4gP5ipowEgXt+Ah+UJG2+zqjHSlC5aRW1/1KasiNJRgplhD9VXfFvOFABVEDStLs+hdpOp//+C4W3L7v9Hxo9RiTc89o7nUAaxzl2ZLROUp5QSBqQ4TSrpcmhLqy8/mZETiDtNw9C59GIhwZLwqBqWz6uTevZKS4snNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JDbi1mGOVB0mozz/4AGkoWP+Tc58mxw/pnZRZbQ/je8=;
 b=TYzHKDAjdMbZzcujD/o+Ada3+Rj36D1CmaD/mE/+6C/OudHBsXrlxZZc26pld+KKsvFvXcDUaH6BzgrnN0HbHfdnFFXQr+lNuroFvFqSI/HAdufG96DgEvXwZwZZV9Zy+xtR50xpH5Sb85x5IKq+p6BAOqnDsqqfVuc+Wc80Ej0=
Received: from DBBPR05MB6283.eurprd05.prod.outlook.com (20.179.40.84) by
 DBBPR05MB6523.eurprd05.prod.outlook.com (20.179.43.148) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2136.14; Thu, 1 Aug 2019 07:46:08 +0000
Received: from DBBPR05MB6283.eurprd05.prod.outlook.com
 ([fe80::2833:939d:2b5c:4a2d]) by DBBPR05MB6283.eurprd05.prod.outlook.com
 ([fe80::2833:939d:2b5c:4a2d%6]) with mapi id 15.20.2115.005; Thu, 1 Aug 2019
 07:46:08 +0000
From:   Tariq Toukan <tariqt@mellanox.com>
To:     Qian Cai <cai@lca.pw>, "davem@davemloft.net" <davem@davemloft.net>
CC:     Saeed Mahameed <saeedm@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net/mlx5e: always initialize frag->last_in_page
Thread-Topic: [PATCH] net/mlx5e: always initialize frag->last_in_page
Thread-Index: AQHVR9Kbf5CT4Ace6EmXOJMujoxMBqbl6rIA
Date:   Thu, 1 Aug 2019 07:46:07 +0000
Message-ID: <f282830b-daf3-42fa-8e8a-f428e7a94b3a@mellanox.com>
References: <1564599773-9474-1-git-send-email-cai@lca.pw>
In-Reply-To: <1564599773-9474-1-git-send-email-cai@lca.pw>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR0P264CA0136.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1a::28) To DBBPR05MB6283.eurprd05.prod.outlook.com
 (2603:10a6:10:c1::20)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=tariqt@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d38c16d5-296e-4dd0-9029-08d716545059
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DBBPR05MB6523;
x-ms-traffictypediagnostic: DBBPR05MB6523:
x-microsoft-antispam-prvs: <DBBPR05MB652378DCB4E18E8783481BE9AEDE0@DBBPR05MB6523.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1728;
x-forefront-prvs: 01165471DB
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(366004)(39860400002)(346002)(396003)(136003)(199004)(189003)(6246003)(256004)(53936002)(52116002)(11346002)(446003)(476003)(2616005)(305945005)(4326008)(6512007)(7736002)(110136005)(186003)(486006)(54906003)(102836004)(316002)(26005)(229853002)(478600001)(6116002)(14454004)(31686004)(81156014)(3846002)(8936002)(66446008)(64756008)(66556008)(66476007)(66946007)(81166006)(99286004)(76176011)(6436002)(25786009)(36756003)(86362001)(31696002)(2906002)(66066001)(68736007)(386003)(6506007)(53546011)(6486002)(71190400001)(2501003)(5660300002)(8676002)(71200400001);DIR:OUT;SFP:1101;SCL:1;SRVR:DBBPR05MB6523;H:DBBPR05MB6283.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: yf0b1EOxNFHR3zgeYhCyo/TqdI6YJLSAn6ZHspwWn3hadhOL1ZQbDzhucn7ZFERKcPhmFMiYok40z0cXiFnPRssaiB5yWyOscC4PceYgX/mfdvBRQDdHdeeP56m/UkVq8TrsWjKY2H6Pw4Xm2GJ71sy6qjWDgEf6GdS9TMZZXYsCBqdF9y9gtrR+b//QAySweY8FRHhIOvyDzn+2O1opU17/hiZmNnv7ugQgSYwy49zw5RYbOGK36OjeBGEjoQLWPZKbEe4nRehiS2rWvJ0kHUm2YrYrZ0q3izDZWzDvGmL/qpaXRi/wnYUy90BF+bAVAIG6lcVEcY1YKibgKlqJ1C0YUFgk4AESPVLC1NJWu0v23eMii4R1E35YNbb5zNn0l+gjtp1OCZDxNiFp8OsC9KdxgOXSIPrDzEiFl0H9vHQ=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E2B58F9D9F9E8A4EB75A914DB593D83E@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d38c16d5-296e-4dd0-9029-08d716545059
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Aug 2019 07:46:07.9863
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tariqt@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR05MB6523
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDcvMzEvMjAxOSAxMDowMiBQTSwgUWlhbiBDYWkgd3JvdGU6DQo+IFRoZSBjb21taXQg
MDY5ZDExNDY1YTgwICgibmV0L21seDVlOiBSWCwgRW5oYW5jZSBsZWdhY3kgUmVjZWl2ZSBRdWV1
ZQ0KPiBtZW1vcnkgc2NoZW1lIikgaW50cm9kdWNlZCBhbiB1bmRlZmluZWQgYmVoYXZpb3VyIGJl
bG93IGR1ZSB0bw0KPiAiZnJhZy0+bGFzdF9pbl9wYWdlIiBpcyBvbmx5IGluaXRpYWxpemVkIGlu
DQo+IG1seDVlX2luaXRfZnJhZ3NfcGFydGl0aW9uKCkgd2hlbiwNCj4gDQo+IGlmIChuZXh0X2Zy
YWcub2Zmc2V0ICsgZnJhZ19pbmZvW2ZdLmZyYWdfc3RyaWRlID4gUEFHRV9TSVpFKQ0KPiANCj4g
b3IgYWZ0ZXIgYmFpbGVkIG91dCB0aGUgbG9vcCwNCj4gDQo+IGZvciAoaSA9IDA7IGkgPCBtbHg1
X3dxX2N5Y19nZXRfc2l6ZSgmcnEtPndxZS53cSk7IGkrKykNCj4gDQo+IEFzIHRoZSByZXN1bHQs
IHRoZXJlIGNvdWxkIGJlIHNvbWUgImZyYWciIGhhdmUgdW5pbml0aWFsaXplZA0KPiB2YWx1ZSBv
ZiAibGFzdF9pbl9wYWdlIi4NCj4gDQo+IExhdGVyLCBnZXRfZnJhZygpIG9idGFpbnMgdGhvc2Ug
ImZyYWciIGFuZCBjaGVjayAicmFnLT5sYXN0X2luX3BhZ2UiIGluDQo+IG1seDVlX3B1dF9yeF9m
cmFnKCkgYW5kIHRyaWdnZXJzIHRoZSBlcnJvciBkdXJpbmcgYm9vdC4gRml4IGl0IGJ5IGFsd2F5
cw0KPiBpbml0aWFsaXppbmcgImZyYWctPmxhc3RfaW5fcGFnZSIgdG8gImZhbHNlIiBpbg0KPiBt
bHg1ZV9pbml0X2ZyYWdzX3BhcnRpdGlvbigpLg0KPiANCj4gVUJTQU46IFVuZGVmaW5lZCBiZWhh
dmlvdXIgaW4NCj4gZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuX3J4
LmM6MzI1OjEyDQo+IGxvYWQgb2YgdmFsdWUgMTcwIGlzIG5vdCBhIHZhbGlkIHZhbHVlIGZvciB0
eXBlICdib29sJyAoYWthICdfQm9vbCcpDQo+IENhbGwgdHJhY2U6DQo+ICAgZHVtcF9iYWNrdHJh
Y2UrMHgwLzB4MjY0DQo+ICAgc2hvd19zdGFjaysweDIwLzB4MmMNCj4gICBkdW1wX3N0YWNrKzB4
YjAvMHgxMDQNCj4gICBfX3Vic2FuX2hhbmRsZV9sb2FkX2ludmFsaWRfdmFsdWUrMHgxMDQvMHgx
MjgNCj4gICBtbHg1ZV9oYW5kbGVfcnhfY3FlKzB4OGU4LzB4MTJjYyBbbWx4NV9jb3JlXQ0KPiAg
IG1seDVlX3BvbGxfcnhfY3ErMHhjYTgvMHgxYTk0IFttbHg1X2NvcmVdDQo+ICAgbWx4NWVfbmFw
aV9wb2xsKzB4MTdjLzB4YTMwIFttbHg1X2NvcmVdDQo+ICAgbmV0X3J4X2FjdGlvbisweDI0OC8w
eDk0MA0KPiAgIF9fZG9fc29mdGlycSsweDM1MC8weDdiOA0KPiAgIGlycV9leGl0KzB4MjAwLzB4
MjZjDQo+ICAgX19oYW5kbGVfZG9tYWluX2lycSsweGM4LzB4MTI4DQo+ICAgZ2ljX2hhbmRsZV9p
cnErMHgxMzgvMHgyMjgNCj4gICBlbDFfaXJxKzB4YjgvMHgxNDANCj4gICBhcmNoX2NwdV9pZGxl
KzB4MWE0LzB4MzQ4DQo+ICAgZG9faWRsZSsweDExNC8weDFiMA0KPiAgIGNwdV9zdGFydHVwX2Vu
dHJ5KzB4MjQvMHgyOA0KPiAgIHJlc3RfaW5pdCsweDFhYy8weDFkYw0KPiAgIGFyY2hfY2FsbF9y
ZXN0X2luaXQrMHgxMC8weDE4DQo+ICAgc3RhcnRfa2VybmVsKzB4NGQ0LzB4NTdjDQo+IA0KPiBG
aXhlczogMDY5ZDExNDY1YTgwICgibmV0L21seDVlOiBSWCwgRW5oYW5jZSBsZWdhY3kgUmVjZWl2
ZSBRdWV1ZSBtZW1vcnkgc2NoZW1lIikNCj4gU2lnbmVkLW9mZi1ieTogUWlhbiBDYWkgPGNhaUBs
Y2EucHc+DQo+IC0tLQ0KPiAgIGRyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29y
ZS9lbl9tYWluLmMgfCAxICsNCj4gICAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKykNCj4g
DQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUv
ZW5fbWFpbi5jIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuX21h
aW4uYw0KPiBpbmRleCA0N2VlYTZiM2ExYzMuLjk2ZjUxMTBhOWI0MyAxMDA2NDQNCj4gLS0tIGEv
ZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuX21haW4uYw0KPiArKysg
Yi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW5fbWFpbi5jDQo+IEBA
IC0zMzYsNiArMzM2LDcgQEAgc3RhdGljIHZvaWQgbWx4NWVfaW5pdF9mcmFnc19wYXJ0aXRpb24o
c3RydWN0IG1seDVlX3JxICpycSkNCj4gICANCj4gICAJbmV4dF9mcmFnLmRpID0gJnJxLT53cWUu
ZGlbMF07DQo+ICAgCW5leHRfZnJhZy5vZmZzZXQgPSAwOw0KPiArCW5leHRfZnJhZy5sYXN0X2lu
X3BhZ2UgPSBmYWxzZTsNCj4gICAJcHJldiA9IE5VTEw7DQo+ICAgDQo+ICAgCWZvciAoaSA9IDA7
IGkgPCBtbHg1X3dxX2N5Y19nZXRfc2l6ZSgmcnEtPndxZS53cSk7IGkrKykgew0KPiANCg0KVGhh
bmtzIFFpYW4uDQpQbGVhc2UgemVyby1pbml0IHRoZSB3aG9sZSBzdHJ1Y3QgaW5zdGVhZDoNCg0K
ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbl9t
YWluLmMgDQpiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbl9tYWlu
LmMNCmluZGV4IDFmNDMzYTA2ZTYzNy4uNTVmNGY1Y2MxZDhmIDEwMDY0NA0KLS0tIGEvZHJpdmVy
cy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuX21haW4uYw0KKysrIGIvZHJpdmVy
cy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuX21haW4uYw0KQEAgLTMxMiwxMSAr
MzEyLDEwIEBAIHN0YXRpYyBpbmxpbmUgdTY0IG1seDVlX2dldF9tcHdxZV9vZmZzZXQoc3RydWN0
IA0KbWx4NWVfcnEgKnJxLCB1MTYgd3FlX2l4KQ0KDQogIHN0YXRpYyB2b2lkIG1seDVlX2luaXRf
ZnJhZ3NfcGFydGl0aW9uKHN0cnVjdCBtbHg1ZV9ycSAqcnEpDQogIHsNCi0gICAgICAgc3RydWN0
IG1seDVlX3dxZV9mcmFnX2luZm8gbmV4dF9mcmFnLCAqcHJldjsNCisgICAgICAgc3RydWN0IG1s
eDVlX3dxZV9mcmFnX2luZm8gbmV4dF9mcmFnID0ge30sICpwcmV2Ow0KICAgICAgICAgaW50IGk7
DQoNCiAgICAgICAgIG5leHRfZnJhZy5kaSA9ICZycS0+d3FlLmRpWzBdOw0KLSAgICAgICBuZXh0
X2ZyYWcub2Zmc2V0ID0gMDsNCiAgICAgICAgIHByZXYgPSBOVUxMOw0KDQogICAgICAgICBmb3Ig
KGkgPSAwOyBpIDwgbWx4NV93cV9jeWNfZ2V0X3NpemUoJnJxLT53cWUud3EpOyBpKyspIHsNCg0K
DQpUaGFua3MsDQpUYXJpcQ0K
