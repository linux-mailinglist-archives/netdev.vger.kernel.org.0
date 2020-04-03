Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9100619CEB8
	for <lists+netdev@lfdr.de>; Fri,  3 Apr 2020 04:34:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390219AbgDCCeF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Apr 2020 22:34:05 -0400
Received: from mail-eopbgr140073.outbound.protection.outlook.com ([40.107.14.73]:20496
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731842AbgDCCeE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Apr 2020 22:34:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IuxRkF9E+u3CrlKC8bmkR8EEfzCVy5aL5JFk5xBFuSn+jFXff7Na7g3mfLeDgdnJsX220rCUVWQcnoQnEIziHVcnQ1YhBw4JcNBaqBpGaPFIXK2dHrA1USaDf6p+fg19Dm0EAOldMWnJV4b21fqda9BMmMYY4/dyQmp1B/cbilIwqqJTuDadR9xwvRo8/4BBeY+C6+q96oCWuZdpol/kjmpObPwJHruGaXMx1eME9pmo67KzdCRFhxksmM7V9mcx3ev0ZpINSN5OwUX8fH0iojRtpkWyrQ6Co3qDBXC2Bct1QkWhcyM024jB1wALxDA3ODocwqI2dEuNkZhsjcUp0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9yEACqeUwLznndEJwy9GqyUE2cDsoC1OPlNSptND6Sc=;
 b=aTRDv/HbuO5+avDVsW/a2I9uPCDALN9YsYMm/g+eVQkB72nr/wnVQ3OOQ22lmXHv2R7X7ZuXLe9SartWPDXj5Htr949rNijEsI/S1RrN2FbGVTDLIIZ0hF/1JxEWWhERynTjcgt7gIjQOEY3+vqiq0x0zONDSbS/emht+Z6nMrBJaOybLWwr5j9FBvHg1kje/M13slfPa4J3mex5BM27PEe7FnOSf/eT3aaG7ztx3EGJ97xDe9bNwEKTsfrY997K3HotMHEZJUNbdNqx02HxVRormz/+UrLU6cmIQzA0jQgj7iC6WQ+fRTaWe9KK4e2h89V8lXatYfLMj3taQ+SK8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9yEACqeUwLznndEJwy9GqyUE2cDsoC1OPlNSptND6Sc=;
 b=O09bE+ignXts6fBjMXvrgd+Xk+X+G9xos0zg2BRrNqn9lbTHbwgF4EhArv/Zw+bmdZ0jz4xgfOxrP44JvnMD+bfdVqv8bTbvbVoY+oUGD0DKEbZro7sGCR3CEbYlZ0kadctARPYbJfMNEA1OFGdXSqmtIBcWQYhXSG8pAoy1x68=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB5197.eurprd05.prod.outlook.com (2603:10a6:803:ae::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.19; Fri, 3 Apr
 2020 02:33:58 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19%7]) with mapi id 15.20.2878.018; Fri, 3 Apr 2020
 02:33:58 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "davem@davemloft.net" <davem@davemloft.net>,
        "xianfengting221@163.com" <xianfengting221@163.com>,
        "leon@kernel.org" <leon@kernel.org>
CC:     "cai@lca.pw" <cai@lca.pw>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "stfrench@microsoft.com" <stfrench@microsoft.com>,
        "xiubli@redhat.com" <xiubli@redhat.com>,
        "guoren@kernel.org" <guoren@kernel.org>,
        "jeyu@kernel.org" <jeyu@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "wqu@suse.com" <wqu@suse.com>,
        "chris@chris-wilson.co.uk" <chris@chris-wilson.co.uk>,
        "yamada.masahiro@socionext.com" <yamada.masahiro@socionext.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH] net/mlx5: improve some comments
Thread-Topic: [PATCH] net/mlx5: improve some comments
Thread-Index: AQHWCCVN1YsHSTa0l0SaNpMgkl1qVqhkPooAgAJx0AA=
Date:   Fri, 3 Apr 2020 02:33:58 +0000
Message-ID: <1e7e26f7ef453268b7662f96ad3772ca3bbd7cd2.camel@mellanox.com>
References: <20200401125720.20276-1-xianfengting221@163.com>
         <16dea5e4-fb5b-d269-2dff-3349f260a13c@163.com>
In-Reply-To: <16dea5e4-fb5b-d269-2dff-3349f260a13c@163.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.34.4 (3.34.4-1.fc31) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [73.15.39.150]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 948fdeaf-482f-4853-3714-08d7d777768e
x-ms-traffictypediagnostic: VI1PR05MB5197:
x-microsoft-antispam-prvs: <VI1PR05MB5197D178A1346C0840DC8DC8BEC70@VI1PR05MB5197.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0362BF9FDB
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(376002)(366004)(396003)(39860400002)(136003)(346002)(64756008)(76116006)(81166006)(81156014)(71200400001)(478600001)(86362001)(4326008)(91956017)(2616005)(66556008)(66476007)(6506007)(66446008)(8936002)(316002)(110136005)(53546011)(8676002)(6486002)(186003)(26005)(54906003)(7416002)(36756003)(5660300002)(66946007)(2906002)(6512007);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cdWnAkK4Xf/nDrHILh8fXX4gF/gZm2MmcmUdjb7yJyW+YWPk6qJt7B0X7GKYaKeJQZP0xsJr5oaiPolIpk8NkMfRPvN5PCb/2rTAziBtAxR9qOhtK8QrDbAGVkGIDdgGKssCGVuMewh0PCFB2PtipUQoEgwiuwv2qw775sjM+GfanmeR30nczIbaDavrBeP4CfHWVLfeuaiajcO6FO08gmAODYzsznrCTWg/ul8eZF72Ogllu3rLQRAJRuB/FnaboHT5om9NOlkJF2i/nzjMNEIApiIsfsrpHd785Dtu+dxu3bYv5r5r9CTYN9O+L7OFW3ppgU8dgrHu17L5GbViOlhoWm0YOHQXyo7LppsT6fe2tI2GA31QsP0sHsC6mkczudpgnLtFFhYePSJyOeTTYPEsoYp/7HuJvAB9f+mZHvMLztZxRvu8XqPhOIBkvItZ
x-ms-exchange-antispam-messagedata: fpmiJok2TQT3cnhOp8UxCG+Z1qumXA5u86VwXBaxPzKEels/FWFBl8gS9P0TM5X0S0eTE/qBjb28+QX1nopYr+kPgKH0WxQB5h2pKY/jo/b74Cg2hDNfEz/rV7oZsFqimbPps6hp5EhwEyzxPP+I+Q==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <78BAA3F563AE8944BA5E0C78584AD7F5@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 948fdeaf-482f-4853-3714-08d7d777768e
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Apr 2020 02:33:58.4847
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: N/IYUePTcrpTRrqYl/mTUJ+ITo/z0+7swgJr0P0se598rVa/miNq+jWKeoUPKvMLRc/XpfTH2pw1di0FHYqRPQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5197
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDIwLTA0LTAxIGF0IDIxOjE0ICswODAwLCBIdSBIYW93ZW4gd3JvdGU6DQo+IE9u
IDIwMjAvNC8xIDg6NTcgUE0sIEh1IEhhb3dlbiB3cm90ZToNCj4gPiBBZGRlZCBhIG1pc3Npbmcg
c3BhY2UgY2hhcmFjdGVyIGFuZCByZXBsYWNlZCAiaXRzIiB3aXRoICJpdCdzIi4NCj4gDQo+IFNv
cnJ5LCB0aGlzIHBhdGNoIGRvZXMgbm90IGluY2x1ZGUgc3BhY2UgY2hhcmFjdGVyIGFkZGluZy4g
UGxlYXNlDQo+IGlnbm9yZSBhbmQgZGVsZXRlIHRoYXQgcGFydCBvZiB0aGUgY29tbWl0IG1lc3Nh
Z2UuDQo+IA0KDQpIaSwgDQoNClRoYW5rcyBmb3IgdGhlIHBhdGNoIEkgd2lsbCBhcHBseSBhbmQg
Zml4IHRoZSBjb21taXQgbWVzc2FnZS4gQlVULi4NCm5ldC1uZXh0IGlzIGNsb3NlZCBhbmQgdGhl
IHJ1bGVzIGFwcGx5IHRvIGV2ZXJ5b25lLCBldmVuIG1seDUgYnJhbmNoLA0Kc28gcGxlYXNlIGZv
ciBuZXh0IHRpbWUsIGxldCdzIHdhaXQgZm9yIG5ldC1uZXh0IHRvIG9wZW4uDQoNClRoYW5rcywN
ClNhZWVkLg0KDQo+IA0KPiA+IFNpZ25lZC1vZmYtYnk6IEh1IEhhb3dlbiA8eGlhbmZlbmd0aW5n
MjIxQDE2My5jb20+DQo+ID4gLS0tDQo+ID4gICBkcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5v
eC9tbHg1L2NvcmUvZGlhZy9md190cmFjZXIuYyB8IDIgKy0NCj4gPiAgIDEgZmlsZSBjaGFuZ2Vk
LCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlvbigtKQ0KPiA+IA0KPiA+IGRpZmYgLS1naXQNCj4g
PiBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9kaWFnL2Z3X3RyYWNl
ci5jDQo+ID4gYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZGlhZy9m
d190cmFjZXIuYw0KPiA+IGluZGV4IGM5YzliNDc5YmRhNS4uMGE4YWRkYTA3M2MyIDEwMDY0NA0K
PiA+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9kaWFnL2Z3
X3RyYWNlci5jDQo+ID4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9j
b3JlL2RpYWcvZndfdHJhY2VyLmMNCj4gPiBAQCAtNjg0LDcgKzY4NCw3IEBAIHN0YXRpYyB2b2lk
IG1seDVfZndfdHJhY2VyX2hhbmRsZV90cmFjZXMoc3RydWN0DQo+ID4gd29ya19zdHJ1Y3QgKndv
cmspDQo+ID4gICAJCWdldF9ibG9ja190aW1lc3RhbXAodHJhY2VyLA0KPiA+ICZ0bXBfdHJhY2Vf
YmxvY2tbVFJBQ0VTX1BFUl9CTE9DSyAtIDFdKTsNCj4gPiAgIA0KPiA+ICAgCXdoaWxlIChibG9j
a190aW1lc3RhbXAgPiB0cmFjZXItPmxhc3RfdGltZXN0YW1wKSB7DQo+ID4gLQkJLyogQ2hlY2sg
YmxvY2sgb3ZlcnJpZGUgaWYgaXRzIG5vdCB0aGUgZmlyc3QgYmxvY2sgKi8NCj4gPiArCQkvKiBD
aGVjayBibG9jayBvdmVycmlkZSBpZiBpdCdzIG5vdCB0aGUgZmlyc3QgYmxvY2sgKi8NCj4gPiAg
IAkJaWYgKCF0cmFjZXItPmxhc3RfdGltZXN0YW1wKSB7DQo+ID4gICAJCQl1NjQgKnRzX2V2ZW50
Ow0KPiA+ICAgCQkJLyogVG8gYXZvaWQgYmxvY2sgb3ZlcnJpZGUgYmUgdGhlIEhXIGluIGNhc2Ug
b2YNCj4gPiBidWZmZXINCg==
