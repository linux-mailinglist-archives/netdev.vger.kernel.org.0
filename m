Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 314881C568
	for <lists+netdev@lfdr.de>; Tue, 14 May 2019 10:53:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726393AbfENIxE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 May 2019 04:53:04 -0400
Received: from mail-eopbgr60063.outbound.protection.outlook.com ([40.107.6.63]:42052
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725916AbfENIxE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 May 2019 04:53:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a/P0F/g8BowpK7wASU0CTzshQzfmfA9q3ELu+E9wk+8=;
 b=Ls6dHSsa7hghy/OidZq/RlgxGFaZUsjGGuwmi0NOeEqdgFr1eHKrZ17+NlliYkveic4KqmNjqRQG1iITixW5bzgi/SOv0wWuGQpXOlEmtc07cNTtYYSad673G5SnM5l6RIciL0Z/vpJN8JMeZc11vZVj5f8OgCaoN9bhieZ+lUk=
Received: from DB8PR05MB6251.eurprd05.prod.outlook.com (20.179.11.12) by
 DB8PR05MB5883.eurprd05.prod.outlook.com (20.179.11.82) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1878.22; Tue, 14 May 2019 08:53:00 +0000
Received: from DB8PR05MB6251.eurprd05.prod.outlook.com
 ([fe80::8453:fae:ea7d:4c45]) by DB8PR05MB6251.eurprd05.prod.outlook.com
 ([fe80::8453:fae:ea7d:4c45%2]) with mapi id 15.20.1878.024; Tue, 14 May 2019
 08:53:00 +0000
From:   Jianbo Liu <jianbol@mellanox.com>
To:     Edward Cree <ecree@solarflare.com>
CC:     netdev <netdev@vger.kernel.org>
Subject: Re: [RFC PATCH net-next 3/3] flow_offload: support CVLAN match
Thread-Topic: [RFC PATCH net-next 3/3] flow_offload: support CVLAN match
Thread-Index: AQHVAcIXXutRDZ7JxkeCZkw7jainaKZpmHYA//+DboCAAUVwAA==
Date:   Tue, 14 May 2019 08:53:00 +0000
Message-ID: <20190514085255.GA5175@mellanox.com>
References: <alpine.LFD.2.21.1905031607170.11823@ehc-opti7040.uk.solarflarecom.com>
 <20190513125400.GB22355@mellanox.com>
 <62a0f0f9-d576-baa6-f34d-f4875214ea7d@solarflare.com>
In-Reply-To: <62a0f0f9-d576-baa6-f34d-f4875214ea7d@solarflare.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: LO2P265CA0322.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a4::22) To DB8PR05MB6251.eurprd05.prod.outlook.com
 (2603:10a6:10:ac::12)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jianbol@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [37.142.13.130]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 13d55676-3c3b-4408-723f-08d6d849911c
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:DB8PR05MB5883;
x-ms-traffictypediagnostic: DB8PR05MB5883:
x-microsoft-antispam-prvs: <DB8PR05MB58832E5EC448BEEB99D6A89DC8080@DB8PR05MB5883.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0037FD6480
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(376002)(396003)(346002)(366004)(39860400002)(189003)(199004)(386003)(53936002)(102836004)(256004)(73956011)(6436002)(5660300002)(53546011)(6506007)(71200400001)(26005)(71190400001)(36756003)(6512007)(81166006)(2616005)(33656002)(8676002)(66946007)(476003)(6916009)(81156014)(76176011)(99286004)(86362001)(186003)(4326008)(11346002)(446003)(52116002)(478600001)(3846002)(4744005)(6246003)(305945005)(7736002)(14454004)(66476007)(6486002)(2906002)(66556008)(486006)(1076003)(8936002)(25786009)(64756008)(66446008)(68736007)(66066001)(229853002)(316002)(6116002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB8PR05MB5883;H:DB8PR05MB6251.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: p0zd5Z54EtI2Y4H/3nvgMcgk0VBbIdwdKBMDebV8KFQAVrlC2w1+kYCSXGw66wbcUc/GlBuqnjNFphz7pU/kwK2AdUQoW5QwOhKmpmcWuJMT0bxo6Acac3K1guhvnj1TWqHZNeKK89JnHgvx47b88Z0HdPKk+/Zlrli9J8FrxnSn/+82wylVT3qw8lBjlgYmWgu38j10uXml/6Nrd/yqDwBYbFa/HOl9HlOJSA5cv2KZROdqigYLj7B9NIec9eCKPMOXWdgrlu5aa2mGkhvDFX/NyKdiJkeVdUYEzK8pMhEXi6Uw4GjLm0/3e+bfXHDa1t/t7G8v+a0mDwBZez8IJTV2lItYg6P0j0HZ5C3orQYB/6+OWbp3sYZYFkOaWSZ4ll67IgB0PqbMc08BoSUFdX1OnI6TK/DeiZLOrNGHSkU=
Content-Type: text/plain; charset="utf-8"
Content-ID: <AD650ED8BBDC964E93272E93BFB8E0A3@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 13d55676-3c3b-4408-723f-08d6d849911c
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 May 2019 08:53:00.1749
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR05MB5883
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhlIDA1LzEzLzIwMTkgMTQ6MjgsIEVkd2FyZCBDcmVlIHdyb3RlOg0KPiBPbiAxMy8wNS8yMDE5
IDEzOjU0LCBKaWFuYm8gTGl1IHdyb3RlOg0KPiA+IENvdWxkIHlvdSBwbGVhc2UgcHVzaCB0byA1
LjEgYW5kIDUuMC1zdGFibGU/IFRoZSBvcmlnaW5hbCBwYXRjaCBicm91Z2h0IGEgYnVnDQo+ID4g
aW4gbWx4NV9jb3JlIGRyaXZlci4gTmVlZCB5b3VyIHBhdGNoIHRvIGZpeC4NCj4gPg0KPiA+IC0t
LSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbl90Yy5jDQo+ID4g
KysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuX3RjLmMNCj4g
PiBAQCAtMTYxNSw3ICsxNjE1LDcgQEAgc3RhdGljIGludCBfX3BhcnNlX2Nsc19mbG93ZXIoc3Ry
dWN0IG1seDVlX3ByaXYgKnByaXYsDQo+ID4gICAgICAgICBpZiAoZmxvd19ydWxlX21hdGNoX2tl
eShydWxlLCBGTE9XX0RJU1NFQ1RPUl9LRVlfQ1ZMQU4pKSB7DQo+ID4gICAgICAgICAgICAgICAg
IHN0cnVjdCBmbG93X21hdGNoX3ZsYW4gbWF0Y2g7DQo+ID4NCj4gPiAtICAgICAgICAgICAgICAg
Zmxvd19ydWxlX21hdGNoX3ZsYW4ocnVsZSwgJm1hdGNoKTsNCj4gPiArICAgICAgICAgICAgICAg
Zmxvd19ydWxlX21hdGNoX2N2bGFuKHJ1bGUsICZtYXRjaCk7DQo+ID4gICAgICAgICAgICAgICAg
IGlmIChtYXRjaC5tYXNrLT52bGFuX2lkIHx8DQo+ID4gICAgICAgICAgICAgICAgICAgICBtYXRj
aC5tYXNrLT52bGFuX3ByaW9yaXR5IHx8DQo+ID4gICAgICAgICAgICAgICAgICAgICBtYXRjaC5t
YXNrLT52bGFuX3RwaWQpIHsNCj4gPg0KPiA+IFRoYW5rcyENCj4gTXkgcGF0Y2ggd2lsbCBiZSBt
b3JlIGVhc2lseSBhY2NlcHRlZCB3aXRoIGEgdXNlciBpbi10cmVlLCBzbyBjb3VsZA0KPiDCoHlv
dSBnaXZlIHRoaXMgZml4IGEgY29tbWl0IG1lc3NhZ2UgYW5kIFNPQj/CoCBUaGVuIEknbGwgcm9s
bCBpdCBpbnRvDQo+IMKgbXkgbmV4dCBwb3N0aW5nIG9mIHRoaXMgc2VyaWVzLCB0aGFua3MhDQo+
IA0KDQpPSywgSSB3aWxsIHNlbmQgdGhlIHBhdGNoIGxhdGVyLCB0aGFua3MhDQoNCkppYW5ibw0K
