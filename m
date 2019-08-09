Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75AE6882E6
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 20:49:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726558AbfHIStz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 14:49:55 -0400
Received: from mail-eopbgr140084.outbound.protection.outlook.com ([40.107.14.84]:5602
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726168AbfHIStz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Aug 2019 14:49:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZT6E8BOlaYNk4nIRcUxREnxQmsq2IIEhF+MWd5/JV67I1ShOrLiR6W1Thgg2DXseGveqoqg1UW3Ln6q/ZQwAZmLvaH9f3nXGkInJOqpcLwYuHOU1teGbmJ6iw/FT9cAllFqLwfZS6mkhjp1zp3NIIfpY89suy/foZTpUTN2pU8LlGNRcxGqGRZaoezrmXq43jZS1qaSSuzHJF6L0lQleDzMDDNU6gyMDHSgyFmDhGjDsc5daqZyiiVPfUozitD3nMrurtuQZwR13LwJEijw29/YAv4VyKzTKwcg8B7OBtWGLS92sPE64iZQ8CgPQk7eWyrz/KIleZfNMpww1LfJ1LQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5fwpl+fKnvpPM/IXQUlVHtltKJRUaWfg7YkDFsV1s5o=;
 b=dgUVxxDPuF7669fglfv5GXy0PmxYtwZwEDyD+C/RUD7hpXAIoGYiqZTPex+vW8UBbSYg/4RE+msAAxyc7JLAAeCxro03K/TUAfsGwFLH4JIm/jOLtI7NOB0WxR7+lJPlkNCxV9oS6KgHvK03njZVdwbu2tK9f0qYMZl8xG3CgLKIPaXW33KiIWBISmvGnrS8qWwpO1ZszIMaFGeHOUnRDquWaLOJNvDi0/7diD56WnFomIPl2xQd0lh+9qHEFBMYnq5Ah5/5njrIGrawLtVaRvCKcGV6BuBNYVJxsQCY4lqRJQve9T5L5QUubtl5Su83fRRDWp5w6Y+DiX17MmigCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5fwpl+fKnvpPM/IXQUlVHtltKJRUaWfg7YkDFsV1s5o=;
 b=dXcqKzoIhd0tswDjF/L3NCOrWFJ2cJXbcJ/x0sXzQVWx5MesjswBTbnlm4Ci5G+8/cv1qlYUa4YefNecCO0oCXX8B/eMBlVRqjWbEmuawgqiBuAi9kCu1V8/7FXUNkf+5Bb8lXF7VK7PNlr8lk1AMe+C7tw7LOHcEnXif1dm3yU=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2822.eurprd05.prod.outlook.com (10.172.227.146) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.20; Fri, 9 Aug 2019 18:49:51 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2%5]) with mapi id 15.20.2157.020; Fri, 9 Aug 2019
 18:49:51 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>
Subject: Re: [net 01/12] net/mlx5e: Use flow keys dissector to parse packets
 for ARFS
Thread-Topic: [net 01/12] net/mlx5e: Use flow keys dissector to parse packets
 for ARFS
Thread-Index: AQHVTibv/OkIHzBCKU2Xiaya0wY6wqbyA30AgAEmpoA=
Date:   Fri, 9 Aug 2019 18:49:50 +0000
Message-ID: <02ebed305b6bb50f272c7f3decfa204dc72311f0.camel@mellanox.com>
References: <20190808202025.11303-1-saeedm@mellanox.com>
         <20190808202025.11303-2-saeedm@mellanox.com>
         <20190808181514.4cd68a37@cakuba.netronome.com>
In-Reply-To: <20190808181514.4cd68a37@cakuba.netronome.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.4 (3.32.4-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 43ae084b-f024-4589-d04a-08d71cfa5c44
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2822;
x-ms-traffictypediagnostic: DB6PR0501MB2822:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB6PR0501MB2822F5F85A061B8C4044A881BED60@DB6PR0501MB2822.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 01244308DF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(366004)(136003)(376002)(39860400002)(396003)(199004)(189003)(36756003)(54906003)(81166006)(81156014)(256004)(14444005)(5660300002)(478600001)(8676002)(3846002)(4326008)(107886003)(25786009)(6246003)(6116002)(305945005)(58126008)(7736002)(71200400001)(71190400001)(99286004)(14454004)(53936002)(316002)(6506007)(66446008)(64756008)(66556008)(76176011)(66476007)(118296001)(6512007)(86362001)(66946007)(76116006)(91956017)(26005)(2501003)(486006)(102836004)(186003)(8936002)(6916009)(229853002)(5640700003)(6486002)(2906002)(6436002)(2351001)(2616005)(11346002)(446003)(66066001)(476003);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2822;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: ZnVOIwKzOdSkaZS2IzfdPkDCnBaiEeezIXmeehpd7WWKGS5HnaN3LjXqfAUTurthW3iKK3HEWKrZjrxPYbjbgz/wgcPE2wV38teJ/o60d52+7XjuyO+X7bqWfc41KjrWdk4k16xrGa5HppdYn+G3mbplewy01OFS6Ka4Pn/+JjIyQLdd+DczqP28sIhOxSUceRNaX0Se4XMxKT/mEs6Qeepq/OV+UWbrMniQaJIck1DnYP565apMv7tmMt30KrrFqudJjh596BaLUBMJNvp63Ma+ZsDRor66CykUFmfiK+HWCNza1Ek17goS31HwdD2AHDesq9o7bnMpXLTDEAePPsug9wTucpEJOY2OzYUpsNlmAc9TpKcOcr4e1xNFYezt/z06s0+DJmUaS4FmerkxBderPWBiKJkbNvRlrWV96jE=
Content-Type: text/plain; charset="utf-8"
Content-ID: <79E0222690F4274587F72A3A4540A402@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 43ae084b-f024-4589-d04a-08d71cfa5c44
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Aug 2019 18:49:50.9770
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cER3O2TAScriKnE/yYMxW5/13sHh6oQ8FoP7HGcm1c0yzN7XS4pG63IdHcI4NAhvS9B4dE1vJhI0TiFl3ZBOaw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2822
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDE5LTA4LTA4IGF0IDE4OjE1IC0wNzAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gT24gVGh1LCA4IEF1ZyAyMDE5IDIwOjIyOjAwICswMDAwLCBTYWVlZCBNYWhhbWVlZCB3cm90
ZToNCj4gPiBGcm9tOiBNYXhpbSBNaWtpdHlhbnNraXkgPG1heGltbWlAbWVsbGFub3guY29tPg0K
PiA+IA0KPiA+IFRoZSBjdXJyZW50IEFSRlMgY29kZSByZWxpZXMgb24gY2VydGFpbiBmaWVsZHMg
dG8gYmUgc2V0IGluIHRoZSBTS0INCj4gPiAoZS5nLiB0cmFuc3BvcnRfaGVhZGVyKSBhbmQgZXh0
cmFjdHMgSVAgYWRkcmVzc2VzIGFuZCBwb3J0cyBieQ0KPiA+IGN1c3RvbQ0KPiA+IGNvZGUgdGhh
dCBwYXJzZXMgdGhlIHBhY2tldC4gVGhlIG5lY2Vzc2FyeSBTS0IgZmllbGRzLCBob3dldmVyLCBh
cmUNCj4gPiBub3QNCj4gPiBhbHdheXMgc2V0IGF0IHRoYXQgcG9pbnQsIHdoaWNoIGxlYWRzIHRv
IGFuIG91dC1vZi1ib3VuZHMgYWNjZXNzLg0KPiA+IFVzZQ0KPiA+IHNrYl9mbG93X2Rpc3NlY3Rf
Zmxvd19rZXlzKCkgdG8gZ2V0IHRoZSBuZWNlc3NhcnkgaW5mb3JtYXRpb24NCj4gPiByZWxpYWJs
eSwNCj4gPiBmaXggdGhlIG91dC1vZi1ib3VuZHMgYWNjZXNzIGFuZCByZXVzZSB0aGUgY29kZS4N
Cj4gDQo+IFRoZSB3aG9sZSBzZXJpZXMgTEdUTSwgRldJVy4NCj4gDQo+IEknZCBiZSBjdXJpb3Vz
IHRvIGhlYXIgd2hpY2ggcGF0aCBkb2VzIG5vdCBoYXZlIHRoZSBza2IgZnVsbHkgDQo+IHNldCB1
cCwgY291bGQgeW91IGVsYWJvcmF0ZT8gKEknbSBjZXJ0YWlubHkgbm8gYVJGQyBleHBlcnQgdGhp
cw0KPiBpcyBwdXJlIGN1cmlvc2l0eSkuDQoNCkluIG91ciByZWdyZXNzaW9uIHdlIGZvdW5kIHR3
byB1c2UgY2FzZXMgdGhhdCBtaWdodCBsZWFkIGFSRlMgdXNpbmcgdW4tDQppbml0aWFsaXplZCB2
YWx1ZXMuDQoxKSBHUk8gRGlzYWJsZWQsIFVzdWFsbHkgR1JPIGZpbGxzIHRoZSBuZWNlc3Nhcnkg
ZmllbGRzLg0KMikgUmF3IHNvY2tldCB0eXBlIG9mIHRlc3RzLg0KDQpBbmQgaSBhbSBzdXJlIHRo
ZXJlIGFyZSBtYW55IG90aGVyIHVzZSBjYXNlcy4gU28gZHJpdmVycyBtdXN0IHVzZQ0Kc2tiX2Zs
b3dfZGlzc2VjdF9mbG93X2tleXMoKSBmb3IgYVJGUyBwYXJzaW5nIGFuZCBlbGltaW5hdGUgYWxs
DQp1bmNlcnRhaW50aWVzLiANCg0K
