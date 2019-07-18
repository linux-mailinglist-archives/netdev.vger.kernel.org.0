Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E40766D412
	for <lists+netdev@lfdr.de>; Thu, 18 Jul 2019 20:38:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391074AbfGRSij (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jul 2019 14:38:39 -0400
Received: from mail-eopbgr50082.outbound.protection.outlook.com ([40.107.5.82]:31876
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2391010AbfGRSij (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Jul 2019 14:38:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aaSMuGgq+9vRWiccNTG27c3hBUYzi6nGecDFaIs1YNjC/jNBRjYp+I6rZ9r9hMnHRwXvOiVJ619D2wohSpxw/hQgtQSwSOrBg1PBHqG71B8Rif74eZ9UdPX2wHaF/H/rWAI9keCMyBaxLkPetzGB773VC6ITXw3NQggZtyb42mCkdbfD0bCgz6igjxKPz+mmzm2vAuF6kcCRNtroF7lHME6ITkg0dge1m5K8lZb7wmibM30XTp0NuiF/hNvK7VshT8YYW4BOkyeDA5iaqMCUjgaI7byBDPHBqueT9rgfkfIOnEx156Pt7lFkIQMPItrxCjkhFyTW5eVorOiRMeNk3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EGcnDIdM/z2Haz0aH3+TSDh1c8E3qwPN7AIbLjWtm/w=;
 b=Uq9Z+B63ZYDh9rgXwiN82xHDuflQV1qZ7zaS908AUH0svG/kRvX2BfWupgoNV2UYGbIxVEjHx4vKnZUCmqBGcOmyUs8zxiwQEIXnln0OE20ywwi3m4aX1SaCEbhy7YoDRuVaf8cz9OFm901Uy3tPTH2GfP9i8lvV7SLb7WqGBnLfuaFbKxvxJZ4QiLHbY42ASC7kYdFGnCUCrr5NGDo3a9zw6QP7NXz4DwrqsiY2BX6LkUplYel0pAk2VYj5J7uPGm3iTBSw4k7mAhrxNSENY14httQRuTmuMBi213nLeU/JP5xm+lDacpXf8SWycpc3/1FS4OW3seRwQOWH3uxoqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EGcnDIdM/z2Haz0aH3+TSDh1c8E3qwPN7AIbLjWtm/w=;
 b=gE0IPk+8F0G5Gw4Jv+hSrPB3QO00M/9So1mKukLWTkX2QhkjDyguhHkvxlIOVlgaVMvDqFAepcC7THwpKfDkxz6lBZwFYAPLuemw1yqXMzz3Lun6WX2yH7OgqXpzpeqm86WMelQixCC9tynLRx2Bs/ZkCLrDVxm9GXE2c0ujPnA=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2232.eurprd05.prod.outlook.com (10.168.56.19) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2073.14; Thu, 18 Jul 2019 18:38:34 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::7148:ecd4:3a7f:f3f]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::7148:ecd4:3a7f:f3f%11]) with mapi id 15.20.2094.011; Thu, 18 Jul 2019
 18:38:34 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "hslester96@gmail.com" <hslester96@gmail.com>
CC:     "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "leon@kernel.org" <leon@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] net/mlx5: Replace kfree with kvfree
Thread-Topic: [PATCH v2] net/mlx5: Replace kfree with kvfree
Thread-Index: AQHVPIiD+q6qV5am40aetSTVO/Hh9KbQtu4A
Date:   Thu, 18 Jul 2019 18:38:34 +0000
Message-ID: <76783a8ca91cb7d0e454cf699c4984243df0081d.camel@mellanox.com>
References: <20190717101456.17401-1-hslester96@gmail.com>
In-Reply-To: <20190717101456.17401-1-hslester96@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.3 (3.32.3-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [73.93.153.50]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e541ba23-f9e8-4605-6e5a-08d70baf23f6
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2232;
x-ms-traffictypediagnostic: DB6PR0501MB2232:
x-microsoft-antispam-prvs: <DB6PR0501MB223233270E59B9CA797F7B3FBEC80@DB6PR0501MB2232.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-forefront-prvs: 01026E1310
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(396003)(366004)(346002)(136003)(39860400002)(199004)(189003)(6916009)(58126008)(6436002)(229853002)(8936002)(316002)(5640700003)(81156014)(3846002)(1361003)(81166006)(2501003)(68736007)(6512007)(14444005)(66066001)(25786009)(486006)(7736002)(256004)(53936002)(478600001)(8676002)(14454004)(54906003)(76116006)(71190400001)(71200400001)(2906002)(26005)(91956017)(36756003)(446003)(99286004)(186003)(76176011)(6116002)(102836004)(6486002)(2351001)(86362001)(305945005)(6246003)(11346002)(66476007)(66446008)(66556008)(1411001)(5660300002)(6506007)(66946007)(2616005)(118296001)(4326008)(476003)(64756008);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2232;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: BbshuiZdt34tnV8yChKbW/x6qir2cekgSguXzPbxkZF7CXakaMB5FKV3sHXUv3LkyfDXa4FaLRJUdjBqOeYEKT5Ub7cmANNgbDIaQdq6/EsUBrEifiVQvnVCJ/LWy/raZaBg50H8ge2xCpBzrTkIYq84YTizZCY7MdW+XpnQK6aFjblmN1V34DqkoIxnHysj7E8sKosUYF2i+jp7+iwEibnF4CAG/hIGkU2B+JnYQC09XCywclhkcRjxymCnbc+wS+1UEZ5UWCYUnG6wLSF3/jj0iuhcZKBqoLp9OwZzstaJsDYx3nFd19p5A13I1D57p6xbXRjvTOCXE/hgcLDzaTc26NzAfhW8C+w8yPLRqTDMbFzVEQs3fDQAhE45SStzJKGtX0pEb7nTaTaAWaTDXMC4oPICBC4JbT3vyAn3yv0=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0268E5955D3485479A4E3E191C96DE71@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e541ba23-f9e8-4605-6e5a-08d70baf23f6
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jul 2019 18:38:34.6179
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2232
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDE5LTA3LTE3IGF0IDE4OjE0ICswODAwLCBDaHVob25nIFl1YW4gd3JvdGU6DQo+
IFZhcmlhYmxlIGFsbG9jYXRlZCBieSBrdm1hbGxvYyBzaG91bGQgbm90IGJlIGZyZWVkIGJ5IGtm
cmVlLg0KPiBCZWNhdXNlIGl0IG1heSBiZSBhbGxvY2F0ZWQgYnkgdm1hbGxvYy4NCj4gU28gcmVw
bGFjZSBrZnJlZSB3aXRoIGt2ZnJlZSBoZXJlLg0KPiANCj4gRml4ZXM6IDliMWYyOTgyMzYwNTcg
KCJuZXQvbWx4NTogQWRkIHN1cHBvcnQgZm9yIEZXIGZhdGFsIHJlcG9ydGVyDQo+IGR1bXAiKQ0K
PiBTaWduZWQtb2ZmLWJ5OiBDaHVob25nIFl1YW4gPGhzbGVzdGVyOTZAZ21haWwuY29tPg0KDQpB
Y2tlZC1ieTogU2FlZWQgTWFoYW1lZWQgPHNhZWVkbUBtZWxsYW5veC5jb20+DQoNCkRhdmUsIGkg
Z3Vlc3MgdGhpcyBjYW4gZ28gdG8gbmV0Lg0KDQpUaGFua3MsDQpTYWVlZC4NCg0KPiAtLS0NCj4g
Q2hhbmdlcyBpbiB2MjoNCj4gICAtIEFkZCBjb3JyZXNwb25kaW5nIEZpeGVzIHRhZw0KPiANCj4g
IGRyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9oZWFsdGguYyB8IDIgKy0N
Cj4gIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlvbigtKQ0KPiANCj4g
ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9oZWFs
dGguYw0KPiBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9oZWFsdGgu
Yw0KPiBpbmRleCAyZmU2OTIzZjdjZTAuLjkzMTQ3NzdkOTllMyAxMDA2NDQNCj4gLS0tIGEvZHJp
dmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2hlYWx0aC5jDQo+ICsrKyBiL2Ry
aXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9oZWFsdGguYw0KPiBAQCAtNTk3
LDcgKzU5Nyw3IEBAIG1seDVfZndfZmF0YWxfcmVwb3J0ZXJfZHVtcChzdHJ1Y3QNCj4gZGV2bGlu
a19oZWFsdGhfcmVwb3J0ZXIgKnJlcG9ydGVyLA0KPiAgCWVyciA9IGRldmxpbmtfZm1zZ19hcnJf
cGFpcl9uZXN0X2VuZChmbXNnKTsNCj4gIA0KPiAgZnJlZV9kYXRhOg0KPiAtCWtmcmVlKGNyX2Rh
dGEpOw0KPiArCWt2ZnJlZShjcl9kYXRhKTsNCj4gIAlyZXR1cm4gZXJyOw0KPiAgfQ0KPiAgDQo=
