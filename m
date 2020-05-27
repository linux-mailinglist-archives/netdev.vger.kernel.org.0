Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9C151E350E
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 03:56:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727852AbgE0B4U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 21:56:20 -0400
Received: from mail-eopbgr60072.outbound.protection.outlook.com ([40.107.6.72]:1154
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727772AbgE0B4T (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 May 2020 21:56:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YAcrkIBSMGQmn8iuIhmz5CzZJHwRDcIzm+K9S2fCDgoZuxMZ8agrwT1tZSw7BsyvxtIpFtywr6DCsdCKZYwff3/iz7ybjAjzn+86Ng2fPxd7G4Fo7Jalmxnjn67Z3f7QrHKT79yud/DnjIb+YzciJNNpAcNU1QfgoVRUwp3xUPMK315DrMabzloaCMLBTjeIq36mJkOi61Tab36bTp0xhHFSFFVRLgJt95tsFMr8aYZfiPN7JidQzEEJZFe3rvPHEUr32ChVdJNkB1Fgn94vbDU6rz+fxL+osQfqBLdqCpX7LwaddBn2d1jsk0JbDSSjkVNGCd1nbudhwuJd8JIPtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oLOPHHQsEWlhxFQWFkc9Oxxf9x5nlDZXpjUWrKWcskY=;
 b=XVlktO9scNpcFa0o4/rkTqowOdKauy2PgvlZHpqmtDkfa+lBX7hsxexIj8SRKieWM+T0woD/rhOv4R1Kh64RXEDlt7tcu2lUPp8o7BfLOVYNt5jDmkW3583ZQhaNn2SfeRrps2SpBAanvSmZDYh6Nj5J3HpJROxs+zsu/Xt6+MYoItcOZeuxh7c2W0+xPALfUnmiUR5Oom0Sx0CGRVrXrTfAw5L8QUb6D9Inf0ZHYb0VghJXZpy+NjbBXo/aNGijleawhGHgb05nXXg7Vq/jDbiNOoKSzZ8nopJ2yyhEln6UqEDJ9umrQx4bSg7GSn2bWcTsFh/yeNNlNYeyLuy5sg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oLOPHHQsEWlhxFQWFkc9Oxxf9x5nlDZXpjUWrKWcskY=;
 b=Su+j117I7lcq+TZyNlSt7nFZA0Ha4NKWZuO9DNOfiFjRPd7Mr7rB4JeKgUC2sEGif9YoK1Oi6Pw8XO2qjPPS8qI40ntbwN0Xpu/dGSodW6jZRo6bspVSrIRV1631k6BtA4cX2aDIjodKfw6SKfZebn5mNnNckiZnFv48vBV9+Pk=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB4704.eurprd05.prod.outlook.com (2603:10a6:802:68::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.27; Wed, 27 May
 2020 01:56:16 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3021.029; Wed, 27 May 2020
 01:56:16 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "dsahern@gmail.com" <dsahern@gmail.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "brouer@redhat.com" <brouer@redhat.com>
Subject: Re: bpf-next/net-next: panic using bpf_xdp_adjust_head
Thread-Topic: bpf-next/net-next: panic using bpf_xdp_adjust_head
Thread-Index: AQHWM5CHfIT64iBK50WQOTz4iga31Ki64JOAgAA0jQCAABe+gA==
Date:   Wed, 27 May 2020 01:56:15 +0000
Message-ID: <e7d481d62d13607f57d5ecbdaf92f1c45b189bb6.camel@mellanox.com>
References: <8d211628-9290-3315-fb1e-b0651d6e1966@gmail.com>
         <52d793f86d36baac455630a03d76f09a388e549f.camel@mellanox.com>
         <0ee9e514-9008-6b30-9665-38607169146d@gmail.com>
In-Reply-To: <0ee9e514-9008-6b30-9665-38607169146d@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.2 (3.36.2-1.fc32) 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=mellanox.com;
x-originating-ip: [73.15.39.150]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 7b7f7100-fccf-4df5-0bc0-08d801e12444
x-ms-traffictypediagnostic: VI1PR05MB4704:
x-microsoft-antispam-prvs: <VI1PR05MB4704D709D178679FA8DC43F4BEB10@VI1PR05MB4704.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 04163EF38A
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rRMLTmZKbJB1JS64mNnFcDvGihmhOHBrVJQ7U3Qd9bmlYIbCM8IlXyoFNz5Kszp24/PaB4e9TckS9FOOduYtbWy5gSeEUbGMHW/RDPpQkIHuaYyiEBOrO8AtVjTMfrlnipia573ANnGcPOdnACjs08EZNME72NIxcuy1EZFEl+fx0Au4zxUNDQ6P4rJu0DxEBMPZ1RyI2RZ86BXNiCxmI7POIavyXDLSgX9ReZjRTK1CZUNOv5HjFMwokb3Ui6VhnRvNHAKiS0nGRLXauU4/+5Zonfm4FRjaaHNxG3LbJlDCiAsHgEK5NA7ixQSHT4ePbatE6uLtDF8YaQABcJz8Xg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(376002)(39850400004)(396003)(136003)(366004)(2906002)(2616005)(66556008)(53546011)(66446008)(26005)(64756008)(91956017)(76116006)(66476007)(66946007)(6506007)(6512007)(478600001)(36756003)(316002)(186003)(110136005)(86362001)(4744005)(8936002)(71200400001)(8676002)(5660300002)(83380400001)(6486002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: SulAAH5XWb9faSjXUbIuh2LkuAEa4+Jn5kbBpdpnniXqejDnADfzuuIA/Uw4s7uM0QFJvu4mSa1R9f6hx8hF40WonH/D+/5I9XeNcRZyfmfM/BJ1Sg9iCTVB43J2AN8dERceLZKR6tOqBsQChvQX3udFshveTrIFueYAzkCnMTwT6H6Q4jTWRVLTmA6DFTRxkCv5DnH5J1mNmK4RHAD9h09zXIIMARB5YzXw7ZdNn8jF6qzFgLKBEDd2agag/WJFcn6UZ3aMur4xbEgAyIl7xFlB/i7ZFhlu5YKe+x07fhiScwAU5mZi75iK9QTwe34MCjoaBaT9Nsp8eppsVpQjrmpvod/ulNuMWuAkRlAl48EMHUx5Q4jxqdgL3L/YvjTtjbaZZWYM5yGvCl6QbQzsWYzq6Z2AlddUUNXGMcmG7o++zpCmna4lkvLZjePfZd4c7cqtqaoi6ee3C6HaSM+lC7QlP0a533xkl9v4V1TD/Jo=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <0518BB176FA85A4B9300F29A077F5A56@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b7f7100-fccf-4df5-0bc0-08d801e12444
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 May 2020 01:56:15.8914
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ulsqEIjZJKwf3IueEfDVz0bMBDe7Jvm2/kWTSmesLSr8AezVsXODiAlBR3/4BlYxMfxOnzRi8n2YYiL3clemcA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4704
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDIwLTA1LTI2IGF0IDE4OjMxIC0wNjAwLCBEYXZpZCBBaGVybiB3cm90ZToNCj4g
T24gNS8yNi8yMCAzOjIzIFBNLCBTYWVlZCBNYWhhbWVlZCB3cm90ZToNCj4gPiBBbnl3YXkgSSBj
YW4ndCBmaWd1cmUgb3V0IHRoZSByZWFzb24gZm9yIHRoaXMgd2l0aG91dCBleHRyYSBkaWdnaW5n
DQo+ID4gc2luY2UgaW4gbWx4NSB3ZSBkbyB4ZHBfc2V0X2RhdGFfbWV0YV9pbnZhbGlkKCk7IGJl
Zm9yZSBwYXNzaW5nIHRoZQ0KPiA+IHhkcA0KPiA+IGJ1ZmYgdG8gdGhlIGJwZiBwcm9ncmFtLCBz
byBpdCBpcyBub3QgY2xlYXIgd2h5IHdvdWxkIHlvdSBoaXQgdGhlDQo+ID4gbWVtb3ZlIGluIGJw
Zl94ZHBfYWRqdXN0X2hlYWQoKS4NCj4gDQo+IEkgY29tbWVudGVkIG91dCB0aGUgbWV0YWxlbiBj
aGVjayBpbiBicGZfeGRwX2FkanVzdF9oZWFkIHRvIG1vdmUgb24uDQo+IA0KPiBUaGVyZSBhcmUg
bnVtYmVyIG9mIGNoYW5nZXMgaW4gdGhlIG1seDUgZHJpdmVyIHJlbGF0ZWQgdG8geGRwX2J1ZmYN
Cj4gc2V0dXANCg0KVGhlc2UgY2hhbmdlcyBhcmUgZnJvbSBuZXQtbmV4dCwgdGhlIG9mZmVuZGlu
ZyBtZXJnZSBjb21taXQgaXMgZnJvbQ0KbmV0Li4NCnNvIGVpdGhlciBpdCBpcyB0aGUgY29tYmlu
YXRpb24gb2YgYm90aCBvciBzb21lIHNpbmdsZSBwYXRjaCBpc3N1ZSBmcm9tDQpuZXQuDQoNCj4g
YW5kIHJ1bm5pbmcgdGhlIHByb2dyYW1zLCBzbyBpdCBpcyB0aGUgbGlrZWx5IGNhbmRpZGF0ZS4g
TGV0IG1lIGtub3cNCj4gaWYNCj4geW91IGhhdmUgc29tZXRoaW5nIHRvIHRlc3QuDQo+IA0KDQpT
dXJlLCBsZXQncyBhaW0gdG93YXJkIHRoaXMgVGh1cnNkYXkgb3IgRnJpZGF5Lg0KSSB3aWxsIGxl
dCB5b3Uga25vdy4NCg0KDQpUaGFua3MsDQpTYWVlZC4NCg0K
