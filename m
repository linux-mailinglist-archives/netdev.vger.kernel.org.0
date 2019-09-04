Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34DB3A7C5F
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 09:13:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728916AbfIDHNv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 03:13:51 -0400
Received: from mail-eopbgr10088.outbound.protection.outlook.com ([40.107.1.88]:22853
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727787AbfIDHNv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Sep 2019 03:13:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hc6G5JuM+E0qW5Y1NWuj4I6/Ve5dt0lis+/f0f9n+mz6InED+wk44NNnM+OZX/2mdAYK6fzS4Wd8FK0cxj3YKmfaA7s5MbygyOeYuiJsJL3NwcJp1rE8zu6eEq3OrJa8egXsolgWalhZbXBfzvLgcaOVNyaeUzWK2j8YBt0pVTpnvCjLEyjdQnUiVCc4h1auWoRA+o5rYWJVA9Vj6f4rPLG1JJ31Ko1Z7L4YE2IiG8eXvndB4eX7vLAjoCwH/Uy2m/cKlhC9weJ9Ojk1nxTpy21Q9r7PkLrl1x06GDT1ONOsWHgIZLJYVtChm4BvjytAywOF6SUaOOuXr/tgvSMDnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pQX+chdMseD3LnPs+FRFurZv9IIwa9Zs1OyXmBMTQ6U=;
 b=RViT0f4qpzTwWcAXGjC0WaamlQidsIKna8XkFUoSsbHvi0DXIfIbkQIo1AbiUZpZDuf6320CfvkkFsGpq4UJJLcVhDdNBamDcVczg7zB0J4frrqFqMjAWlYnLRT1dWPGEvxhuXrlEqEQT5Rx+MjWO5CdsFowj9qhvcVHtJZzWPODQ2IpX1qDx+alyD2Vx8KeCCTuyFEdUEEo4E8vsRb2l/5EEgrZA2qo9498mUXfHSnNwDvtnk5hChYMAt15MavCrrGqNw2F63Uf8BkM+tJudiY5mjtpNj2utICQbBwaffTjZjAUdqpGyJZzRato3UShr/dk3azefhAYoHaxYZ82bw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pQX+chdMseD3LnPs+FRFurZv9IIwa9Zs1OyXmBMTQ6U=;
 b=GeTE/4N0zwO/esH3yIPt9EZBk/EPjazRLbdK3rFTeUL5zIWloSV8fhF/ABShstmsevVQNGroV3Hy2a75N+G6dBz9KdmmJ9dNKYy5G01ImggAvx6aN4q6QHUMKe4WIn1imKEDDwjiszClSueUtuN90IfBWWuFgXVMtZBH//mwg+Q=
Received: from AM4PR05MB3411.eurprd05.prod.outlook.com (10.171.190.30) by
 AM4PR05MB3474.eurprd05.prod.outlook.com (10.171.186.159) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2220.20; Wed, 4 Sep 2019 07:13:46 +0000
Received: from AM4PR05MB3411.eurprd05.prod.outlook.com
 ([fe80::bd07:1f1a:7d30:7a5b]) by AM4PR05MB3411.eurprd05.prod.outlook.com
 ([fe80::bd07:1f1a:7d30:7a5b%7]) with mapi id 15.20.2220.020; Wed, 4 Sep 2019
 07:13:46 +0000
From:   Paul Blakey <paulb@mellanox.com>
To:     Edward Cree <ecree@solarflare.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Justin Pettit <jpettit@nicira.com>,
        Simon Horman <simon.horman@netronome.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Vlad Buslov <vladbu@mellanox.com>
CC:     Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>,
        Yossi Kuperman <yossiku@mellanox.com>,
        Rony Efraim <ronye@mellanox.com>, Oz Shlomo <ozsh@mellanox.com>
Subject: Re: [PATCH net-next v3] net: openvswitch: Set OvS recirc_id from tc
 chain index
Thread-Topic: [PATCH net-next v3] net: openvswitch: Set OvS recirc_id from tc
 chain index
Thread-Index: AQHVYlrbUKqndwhXAEqU3e07e25doqcaCswAgAERAgA=
Date:   Wed, 4 Sep 2019 07:13:46 +0000
Message-ID: <bda5e64b-2232-c44a-7c18-71d808971a06@mellanox.com>
References: <1567517015-10778-1-git-send-email-paulb@mellanox.com>
 <1567517015-10778-2-git-send-email-paulb@mellanox.com>
 <6d2e1ef7-f859-32f4-584f-1f0f772edadf@solarflare.com>
In-Reply-To: <6d2e1ef7-f859-32f4-584f-1f0f772edadf@solarflare.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM0PR06CA0101.eurprd06.prod.outlook.com
 (2603:10a6:208:fa::42) To AM4PR05MB3411.eurprd05.prod.outlook.com
 (2603:10a6:205:b::30)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=paulb@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8178a918-230f-4337-6b8a-08d731076d02
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM4PR05MB3474;
x-ms-traffictypediagnostic: AM4PR05MB3474:|AM4PR05MB3474:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM4PR05MB34743F18D01409071D43E8F6CFB80@AM4PR05MB3474.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0150F3F97D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(136003)(39860400002)(396003)(346002)(376002)(199004)(189003)(25786009)(26005)(6512007)(478600001)(3846002)(6116002)(66066001)(102836004)(53936002)(107886003)(6246003)(4326008)(14454004)(66946007)(66476007)(66556008)(66446008)(64756008)(186003)(6436002)(446003)(2501003)(71190400001)(71200400001)(316002)(110136005)(31696002)(86362001)(476003)(2616005)(256004)(14444005)(486006)(11346002)(2906002)(54906003)(386003)(8676002)(53546011)(6506007)(52116002)(5660300002)(31686004)(76176011)(99286004)(6486002)(8936002)(229853002)(81156014)(36756003)(81166006)(305945005)(6636002)(7736002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR05MB3474;H:AM4PR05MB3411.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: YU29HjyOuq+OfLfi0mZtd928HOEjy4X2bI/WdiDR5936guvcufD6AWHIlR1n3jf74RwB3t2kzPJrqXS+N8Vv1jNSfX+UkUTBwlv6nj1BfLjO56Xa3UYGRLuZ7bN7CPEVslCg7NvuqEvqeLeby6JR0KJhL/+SimKz9FWcje/VkzUrmlbNZ4L44GC4reiWU/pCeiTPItf5K1JmOfjmUsjkpoqYT41Q6f09lCrQlsMZR+XDthsnIeUZZFBDciPIBxbYNNh0Dr0fmLJFKsQi+5g/F1P7mgnu2nyx597G9S1Oty8dTCC39fti0y/wrK8Ul58VegESYHkwWLNoywQHlA91CMuOMFNK/YH4uS8iCspoEEsmfKXUlZ+pkn66ywZZvFZyD1m/aNkszGTW0iGpnb9treOqGtTIkRU1zISALN4uNU8=
Content-Type: text/plain; charset="utf-8"
Content-ID: <640B463E33A7104483E5D5E87634C288@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8178a918-230f-4337-6b8a-08d731076d02
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Sep 2019 07:13:46.4149
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: K+FmQ+gmxhSafRedNUB1sQtem1d33nDcPYf3/H/oTYwnW6fl0ZlD0iP6yGMs6uoKh/0Kht9uww1bZfNa3BghlQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR05MB3474
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpPbiA5LzMvMjAxOSA1OjU2IFBNLCBFZHdhcmQgQ3JlZSB3cm90ZToNCj4gT24gMDMvMDkvMjAx
OSAxNDoyMywgUGF1bCBCbGFrZXkgd3JvdGU6DQo+PiBPZmZsb2FkZWQgT3ZTIGRhdGFwYXRoIHJ1
bGVzIGFyZSB0cmFuc2xhdGVkIG9uZSB0byBvbmUgdG8gdGMgcnVsZXMsDQo+PiBmb3IgZXhhbXBs
ZSB0aGUgZm9sbG93aW5nIHNpbXBsaWZpZWQgT3ZTIHJ1bGU6DQo+Pg0KPj4gcmVjaXJjX2lkKDAp
LGluX3BvcnQoZGV2MSksZXRoX3R5cGUoMHgwODAwKSxjdF9zdGF0ZSgtdHJrKSBhY3Rpb25zOmN0
KCkscmVjaXJjKDIpDQo+Pg0KPj4gV2lsbCBiZSB0cmFuc2xhdGVkIHRvIHRoZSBmb2xsb3dpbmcg
dGMgcnVsZToNCj4+DQo+PiAkIHRjIGZpbHRlciBhZGQgZGV2IGRldjEgaW5ncmVzcyBcDQo+PiAJ
ICAgIHByaW8gMSBjaGFpbiAwIHByb3RvIGlwIFwNCj4+IAkJZmxvd2VyIHRjcCBjdF9zdGF0ZSAt
dHJrIFwNCj4+IAkJYWN0aW9uIGN0IHBpcGUgXA0KPj4gCQlhY3Rpb24gZ290byBjaGFpbiAyDQo+
Pg0KPj4gUmVjZWl2ZWQgcGFja2V0cyB3aWxsIGZpcnN0IHRyYXZlbCB0aG91Z2ggdGMsIGFuZCBp
ZiB0aGV5IGFyZW4ndCBzdG9sZW4NCj4+IGJ5IGl0LCBsaWtlIGluIHRoZSBhYm92ZSBydWxlLCB0
aGV5IHdpbGwgY29udGludWUgdG8gT3ZTIGRhdGFwYXRoLg0KPj4gU2luY2Ugd2UgYWxyZWFkeSBk
aWQgc29tZSBhY3Rpb25zIChhY3Rpb24gY3QgaW4gdGhpcyBjYXNlKSB3aGljaCBtaWdodA0KPj4g
bW9kaWZ5IHRoZSBwYWNrZXRzLCBhbmQgdXBkYXRlZCBhY3Rpb24gc3RhdHMsIHdlIHdvdWxkIGxp
a2UgdG8gY29udGludWUNCj4+IHRoZSBwcm9jY2Vzc2luZyB3aXRoIHRoZSBjb3JyZWN0IHJlY2ly
Y19pZCBpbiBPdlMgKGhlcmUgcmVjaXJjX2lkKDIpKQ0KPj4gd2hlcmUgd2UgbGVmdCBvZmYuDQo+
IElNSE8gZWFjaCBvZmZsb2FkIChPdlMgLT4gdGMsIGFuZCB0YyAtPiBodykgb3VnaHQgb25seSB0
YWtlIHBsYWNlIGZvciBhIHJ1bGUNCj4gIMKgaWYgYWxsIHNlcXVlbGFlIG9mIHRoYXQgcnVsZSBh
cmUgYWxzbyBvZmZsb2FkZWQsIG9yIGlmIG5vbi1vZmZsb2FkZWQgc2VxdWVsYWUNCj4gIMKgY2Fu
IGJlIGd1YXJhbnRlZWQgdG8gcHJvdmlkZSBhbiB1bm1vZGlmaWVkIHBhY2tldCBzbyB0aGF0IHRo
ZSBleGNlcHRpb24gcGF0aA0KPiAgwqBjYW4gc3RhcnQgZnJvbSB0aGUgYmVnaW5uaW5nLsKgIEkg
ZG9uJ3QgbGlrZSB0aGlzIGlkZWEgb2YgZG9pbmcgcGFydCBvZiB0aGUNCj4gIMKgcHJvY2Vzc2lu
ZyBpbiBvbmUgcGxhY2UgYW5kIHRoZW4gcmVzdW1pbmcgdGhlIHJlc3QgbGF0ZXIgaW4gYW4gZW50
aXJlbHkNCj4gIMKgZGlmZmVyZW50IHBpZWNlIG9mIGNvZGUuDQoNCldlIGhvcGUgdG8gcmVwbGlj
YXRlIHRoZSBlbnRpcmUgc29mdHdhcmUgbW9kdWxlIHRvIGhhcmR3YXJlLCBub3QganVzdCB0Yy4N
Cg0KRm9yIHRjIG9mZmxvYWRpbmcsIHdlIGN1cnJlbnRseSBvZmZsb2FkIHRjIHJ1bGVzIG9uZSBi
eSBvbmUsIGluY2x1ZGluZyANCnRjIGNoYWlucyBydWxlcyAobWF0Y2ggb24gY2hhaW4sIGFuZCBn
b3RvIGNoYWluIGFjdGlvbiksDQoNCmFuZCB0aGUgb2ZmbG9hZGVkIHJ1bGVzIG1pZ2h0IG5vdCBj
YXRjaCBhbGwgcGFja2V0czoNCg0KdGMgZml0ZXIgYWRkIGRldjEgLi4uLi4gY2hhaW4gMCAuLi4g
Zmxvd2VyIGRzdF9tYWMgYWE6YmI6Y2M6ZGQ6ZWU6ZmYgDQphY3Rpb24gcGVkaXQgbXVuZ2UgZXgg
c2V0IGRzdCBzcmMgMTI6MzQ6NTY6Nzg6YWE6YmIgYWN0aW9uIGdvdG8gY2hhaW4gNQ0KDQp0YyBm
aXRlciBhZGQgZGV2MSAuLi4uLiBjaGFpbiA1IC4uLiBmbG93ZXIgaXBfcHJvdG8gVURQIGFjdGlv
biBtaXJyZWQgDQplZ3Jlc3MgcmVkaXJlY3QgZGV2IGRldjINCg0KSWYgdGhlIHBhY2tldCBpc24n
dCBVRFAgd2UgbWlzcyBvbiBjaGFpbjUuDQoNCg0KQmVzaWRlcyB0aGlzIGJhc2ljIGNhc2UsIHRo
ZXJlIGNhbiBiZSBhY3Rpb25zIHRoYXQgYXJlbid0IGF2YWlsYWJsZSANCmN1cnJlbnRseSwgYW5k
IG5lZWQgc29mdHdhcmUgYXNzaXN0YW5jZSwgc3VjaCBhcyBlbmNhcHN1bGF0aW9uLg0KDQppZiB3
ZSBoYWQgdGhlIGZvbGxvd2luZyBydWxlOg0KDQp0YyBmaXRlciBhZGQgZGV2MSAuLi4uLiBjaGFp
biA1IC4uLiBmbG93ZXIgaXBfcHJvdG8gVURQIGFjdGlvbiANCnR1bm5lbF9rZXkgc2V0IGRzdF9w
b3J0IDQ3ODkgdm5pIDk4IGRzdF9pcCAxLjEuMS4xIG1pcnJlZCBlZ3Jlc3MgDQpyZWRpcmVjdCBk
ZXYgdnhsYW5fc3lzXzQ3ODkNCg0KQW5kIG5laWdoYm9yIGZvciB0aGUgZHN0X2lwIDEuMS4xLjEg
aXMgdW5yZWFjaGFibGUsIHdlIGNhbid0IGRvIHRoZSANCmVuY2Fwc3VsYXRpb24gaW4gaGFyZHdh
cmUgY3VycmVudGx5LCBhbmQgd2FpdCBmb3Igc29mdHdhcmUgdG8gcmVzb2x2ZQ0KDQp0aGUgbmVp
Z2hib3IgdmlhIGFycC4NCg0KQW5vdGhlciBpcyB0aGUgYWN0aW9uIGN0IHdlIHBsYW4gb24gb2Zm
bG9hZGluZyBoZXJlLCB3ZSBzZW5kIHBhY2tldHMgDQpiYWNrIHRvIGNvbm50cmFjayBpZiBuZWVk
ZWQgKGJlZm9yZSB0aGUgY29ubmVjdGlvbiBpcyBlc3RhYmxpc2hlZCwgZm9yIA0KY29ubmVjdGlv
biBzZXR1cCkNCg0KVGhlcmUgY2FuIGFsc28gYmUgdHJhcCBhY3Rpb24sIHRvIGV4cGxpY2l0bHkg
Y29udGludWUgaW4gc29mdHdhcmUsIGFuZCANCnRoZSB1c2VyIG1pZ2h0IHdhbnQgdGhlIHBhcnRp
YWwgcHJvY2Vzc2luZyBiZWZvcmUgaXQuDQoNCg0KV2UgY3VycmVudGx5IHN1cHBvcnQgdXAgdG8g
c2V2ZXJhbCBtaWxsaW9ucyBvZiBzdWNoIHJ1bGVzLCBhbmQgYW55IA0KdXBkYXRlIChkZWxldGUv
YWRkKSBvZiBhIGNvbnRpbnVhdGlvbiBvZiBhIHJ1bGUgKGUuZyBjaGFpbiA1IHJ1bGUpLA0KDQpt
aWdodCBhZmZlY3QgdGhlIHByb2Nlc3Npbmcgb2YgbWlsbGlvbnMgb2Ygb3RoZXIgcnVsZXMgYmVm
b3JlIGl0IChnb3RvIA0KY2hhaW4gNSBydWxlcyksIHdpdGggdGMgcHJpb3JpdGllcywgaXQncyBl
dmVuIHdvcnNlIGFuZCBoYXBwZW5zIG1vcmUgb2Z0ZW4uDQoNCg0K
