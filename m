Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FB8B467B6
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 20:42:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726298AbfFNSmM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 14:42:12 -0400
Received: from mail-eopbgr140059.outbound.protection.outlook.com ([40.107.14.59]:42062
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726293AbfFNSmL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Jun 2019 14:42:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aKRlr5TKbad8JOQizcfOsncjh9EOyp4jE+pG0Ete6gA=;
 b=hcChkJqNxto0ernoSSXT/T/Wv+c/CIPf9iE/gAHDUFlsbs4ZvalomnT4KrqmJt5oMn62qwSa5LnrtHV5xPtvHIg609zQaeHEtQTPtsiuKUuBRJcDVYR+aATmx5N+psI2h6spbYu9Gas2lyolLMFY4SLxNjr3Rhr7A059hiEyJRU=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2613.eurprd05.prod.outlook.com (10.172.225.141) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.12; Fri, 14 Jun 2019 18:42:08 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::a901:6951:59de:3278]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::a901:6951:59de:3278%2]) with mapi id 15.20.1987.012; Fri, 14 Jun 2019
 18:42:08 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "leon@kernel.org" <leon@kernel.org>
Subject: Re: [PATCH net-next v3 2/2] net/mlx5e: use indirect calls wrapper for
 the rx packet handler
Thread-Topic: [PATCH net-next v3 2/2] net/mlx5e: use indirect calls wrapper
 for the rx packet handler
Thread-Index: AQHVIQg+MDMY5dq5G06A+ODXskWpZaabf6oA
Date:   Fri, 14 Jun 2019 18:42:08 +0000
Message-ID: <ad481203aabc0c3a5b8e93258711a081b1d799cb.camel@mellanox.com>
References: <cover.1560333783.git.pabeni@redhat.com>
         <93f577ed4761c9934acfe073334cbafbd6a6351f.1560333783.git.pabeni@redhat.com>
In-Reply-To: <93f577ed4761c9934acfe073334cbafbd6a6351f.1560333783.git.pabeni@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.2 (3.32.2-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 261c446e-56df-4896-9caa-08d6f0f8013d
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2613;
x-ms-traffictypediagnostic: DB6PR0501MB2613:
x-microsoft-antispam-prvs: <DB6PR0501MB2613FF216115AC7D04FC8A8DBEEE0@DB6PR0501MB2613.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 0068C7E410
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(136003)(39860400002)(366004)(376002)(346002)(199004)(189003)(8676002)(36756003)(6486002)(7736002)(305945005)(6436002)(53936002)(6246003)(11346002)(6512007)(446003)(2616005)(229853002)(476003)(5660300002)(486006)(66066001)(6506007)(2501003)(76176011)(6116002)(3846002)(81166006)(14454004)(8936002)(118296001)(68736007)(99286004)(26005)(186003)(64756008)(54906003)(66476007)(58126008)(316002)(14444005)(110136005)(66946007)(73956011)(71190400001)(91956017)(71200400001)(256004)(86362001)(4326008)(4744005)(76116006)(478600001)(66446008)(25786009)(2906002)(66556008)(102836004)(81156014);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2613;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 4jK1i4URqh1PTOqIS0edGVd7poC1KezF/8aQbIDSIxC/BEKR4LPmlncOucjYL85skVaZ/e49VTLlL7ZTerRPyfsRRfr4ZM4Ym4eWlGQAOfWGTLvWsr32RKNZXrPyy2sSiUBE+BTJd6CW3bjcu9wGGSJ9+WpS7XAxA41MOyc7aT3NjGeZlauQnixKGPD7c3APTbrpQxpjIgDvg5ib968j9M3i1Iz+Hn9T0EVzYA8hBo/PmIEsnUDGhXp0133Z0+e3Fmf9Z9GkFBeUv6k1YKWNT/YP/rpAZ7wMAKYcUcU9uc9oNnYUPq1OR0AI/LaTe4wtbCO6grgdOMEs6KjkCL+6u3dzY181XCQIymH70b/7ssixvtee/kRpQF97Nf6oQQeak0XbCV9rWCzSIdr98VYZsq58DRPTLS8S8kSu8RkcTn8=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3F240DC398B6E5429FF54CA497B71B11@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 261c446e-56df-4896-9caa-08d6f0f8013d
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jun 2019 18:42:08.1713
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2613
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDE5LTA2LTEyIGF0IDEyOjE4ICswMjAwLCBQYW9sbyBBYmVuaSB3cm90ZToNCj4g
V2UgY2FuIGF2b2lkIGFub3RoZXIgaW5kaXJlY3QgY2FsbCBwZXIgcGFja2V0IHdyYXBwaW5nIHRo
ZSByeA0KPiBoYW5kbGVyIGNhbGwgd2l0aCB0aGUgcHJvcGVyIGhlbHBlci4NCj4gDQo+IFRvIGVu
c3VyZSB0aGF0IGV2ZW4gdGhlIGxhc3QgbGlzdGVkIGRpcmVjdCBjYWxsIGV4cGVyaWVuY2UNCj4g
bWVhc3VyYWJsZSBnYWluLCBkZXNwaXRlIHRoZSBhZGRpdGlvbmFsIGNvbmRpdGlvbmFscyB3ZSBt
dXN0DQo+IHRyYXZlcnNlIGJlZm9yZSByZWFjaGluZyBpdCwgSSB0ZXN0ZWQgcmV2ZXJzaW5nIHRo
ZSBvcmRlciBvZiB0aGUNCj4gbGlzdGVkIG9wdGlvbnMsIHdpdGggcGVyZm9ybWFuY2UgZGlmZmVy
ZW5jZXMgYmVsb3cgbm9pc2UgbGV2ZWwuDQo+IA0KPiBUb2dldGhlciB3aXRoIHRoZSBwcmV2aW91
cyBpbmRpcmVjdCBjYWxsIHBhdGNoLCB0aGlzIGdpdmVzDQo+IH42JSBwZXJmb3JtYW5jZSBpbXBy
b3ZlbWVudCBpbiByYXcgVURQIHRwdXQuDQo+IA0KPiB2MiAtPiB2MzoNCj4gIC0gdXNlIG9ubHkg
dGhlIGRpcmVjdCBjYWxscyBhbHdheXMgYXZhaWxhYmxlIHJlZ2FyZGxlc3Mgb2YNCj4gICAgdGhl
IG1seDUgYnVpbGQgb3B0aW9ucw0KPiAgLSBkcm9wIHRoZSBkaXJlY3QgY2FsbCBsaXN0IG1hY3Jv
LCB0byBrZWVwIHRoZSBjb2RlIGFzIHNpbXBsZQ0KPiAgICBhcyBwb3NzaWJsZSBmb3IgZnV0dXJl
IHJld29yaw0KPiANCj4gdjEgLT4gdjI6DQo+ICAtIHVwZGF0ZSB0aGUgZGlyZWN0IGNhbGwgbGlz
dCBhbmQgdXNlIGEgbWFjcm8gdG8gZGVmaW5lIGl0LA0KPiAgICBhcyBwZXIgU2FlZWQgc3VnZ2Vz
dGlvbi4gQW4gaW50ZXJtZWRpYXRlZCBhZGRpdGlvbmFsDQo+ICAgIG1hY3JvIGlzIG5lZWRlZCB0
byBhbGxvdyBhcmcgbGlzdCBleHBhbnNpb24NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IFBhb2xvIEFi
ZW5pIDxwYWJlbmlAcmVkaGF0LmNvbT4NCj4gDQoNCkFja2VkLWJ5OiBTYWVlZCBNYWhhbWVlZCA8
c2FlZWRtQG1lbGxhbm94LmNvbT4NCg==
