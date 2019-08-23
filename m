Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D1549A754
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 08:00:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403776AbfHWGAu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 02:00:50 -0400
Received: from mail-eopbgr150087.outbound.protection.outlook.com ([40.107.15.87]:25497
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2390268AbfHWGAu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Aug 2019 02:00:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HSFu7zUyKYrQ7sQwqHKXaZHD0Z81GZULxazaIx0L3WxZw/EhGF0b1Eww9CqnAdXJAWmeVPQyyI7RawVtCXCIpjrRZ/T65DkIvaB3nRfdgF6J3p96gGyZe0j05/wryYOteDnjEBJqD9oTXz5JI9/OrjBWBFpcAKJ+zX81jcAf04viplbIPgFXTpb96LIN+DaZ24xRY/bYz+cxkxWPgq0cEjeuWa1DtE6B4W9DXPTkjZI2cHqJRyjWcWOY2mK5sG0WwVDvFpk/IapYCtcW3BM+ongH2N0ARyq6Sb5GSQTwtNgdyYBr08aIDThJSxlAt4K+wXa0j7pwE+nkIFN4bkX11w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5e2pqu0qlf7/YST+BFMg5jv0NA0ke2M43sa6dGYeujE=;
 b=UoNVbwuwXx4Tvs3EraSRy7T5AR9zkjgoiOhlXuNX904RKoEbLk7ZzGXwEGUCEsN0jzkyav7QdlluQaa2PLdCMHclBc76OTNZAON2ZehS3iaYRA1El7CVvkXn6IdooyDZbi4uSltmCku5OeBO+4uC1zPiDEsAXRWt5b04TXFhpw46hZ+KkqUYz5T2oVlUBiBpR4lsy0BotPGL6D5BpcBg6AhFRZEdzdAEBFsFdiRDTRyagNxlItlhs18H6detM0CpNzwYIFsdUD7SPUDe3joER5czcxYdwBgJDhKXd95pReV3Agl3ZQpzicG2ZnsiwuyoO5zFA2BSNEzIRp7992A4Vw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5e2pqu0qlf7/YST+BFMg5jv0NA0ke2M43sa6dGYeujE=;
 b=IE1DintSbzX2AeIIq4XW3U/922poZKo+6yFzvKFJnxjeaxXxUxHmMsTVgkq/Q8OtK/FrKmeE+t1ioXg8eVbwM4n5NIMj88RNF0Ii6EUJIZ94PIRX01N9+8Dfu9Z7OagtayVsnNmB9dzaD2GU68c9JMSprpZEsPGrC3a1HDbALNk=
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com (10.172.216.138) by
 AM4PR0501MB2658.eurprd05.prod.outlook.com (10.172.219.17) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.18; Fri, 23 Aug 2019 06:00:45 +0000
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::e414:3306:9996:bb7a]) by AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::e414:3306:9996:bb7a%4]) with mapi id 15.20.2178.020; Fri, 23 Aug 2019
 06:00:45 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Moshe Shemesh <moshe@mellanox.com>
Subject: Re: [net-next 4/8] net/mlx5e: Add device out of buffer counter
Thread-Topic: [net-next 4/8] net/mlx5e: Add device out of buffer counter
Thread-Index: AQHVWUJWlLdQtLGJp0+FOnAm6QwlfqcH8v0AgABKrwA=
Date:   Fri, 23 Aug 2019 06:00:45 +0000
Message-ID: <27f7cfa13d1b5e7717e2d75595ab453951b18a96.camel@mellanox.com>
References: <20190822233514.31252-1-saeedm@mellanox.com>
         <20190822233514.31252-5-saeedm@mellanox.com>
         <20190822183324.79b74f7b@cakuba.netronome.com>
In-Reply-To: <20190822183324.79b74f7b@cakuba.netronome.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.4 (3.32.4-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [73.15.39.150]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5aa3cb40-ffc8-4c9d-6c57-08d7278f3d03
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM4PR0501MB2658;
x-ms-traffictypediagnostic: AM4PR0501MB2658:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM4PR0501MB26587CA53064CD83EC152DEEBEA40@AM4PR0501MB2658.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0138CD935C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(366004)(346002)(39850400004)(376002)(396003)(199004)(189003)(5640700003)(71190400001)(71200400001)(25786009)(76176011)(66066001)(229853002)(6486002)(6116002)(3846002)(6436002)(6916009)(53936002)(186003)(64756008)(66476007)(91956017)(66446008)(76116006)(66946007)(66556008)(102836004)(4326008)(316002)(6506007)(6246003)(107886003)(26005)(305945005)(6512007)(58126008)(118296001)(7736002)(11346002)(2351001)(2906002)(86362001)(476003)(54906003)(99286004)(5660300002)(256004)(8676002)(81166006)(81156014)(2501003)(14454004)(478600001)(8936002)(486006)(36756003)(2616005)(446003);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR0501MB2658;H:AM4PR0501MB2756.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: +oN0tg2hWVGe+cZOfjFfHBSQVTSjBXfbLkQQH1pzLcQc9KH35yw5bA05BZKJAN0DEQFYm/SiPT1dAV5fp2yf0CflRLWj0BAp4Xx1YTx2OiXMdZEi8CSUzMSAtXJYfSBuljI1byaOUEZC6/dNpQQP4+LvNRk6sD0rnjcOn5lqG4xrn+c8ObEmbzogaRCqbQ+kf+Ktu88DJMPHRaT9oc/mPRLAR5YEtObHDrdWhvG6+sgHfjtR/Zn1HxgguZM5uXLS2Yl89xss1vrsHiEiJ0j/LJYjPUiaHUWcdf5xd5VOn9//11hfgZu+eCpi5Hc/3LQmZiz8vvI7uDdXzN/YcUYmFCF1wqmbTTPmZCqeZ5qrd0jTnNaw14M8Eu0bTrBQabFz78bs/XPegvjzhrZl4vjGHlkza71uAT/Q530gGSB6D9E=
Content-Type: text/plain; charset="utf-8"
Content-ID: <541A5E8E42D0CE4EA288215F7F4C9A34@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5aa3cb40-ffc8-4c9d-6c57-08d7278f3d03
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Aug 2019 06:00:45.2126
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SH58Lq2AVnaMpmI9pB7lzLi2QCLNRpqeynnZyyfRFjb+JKw80K/AzlIxZvP9Fy1///PYATKrGRmHDKYkNkY8lw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0501MB2658
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDE5LTA4LTIyIGF0IDE4OjMzIC0wNzAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gT24gVGh1LCAyMiBBdWcgMjAxOSAyMzozNTo1MiArMDAwMCwgU2FlZWQgTWFoYW1lZWQgd3Jv
dGU6DQo+ID4gRnJvbTogTW9zaGUgU2hlbWVzaCA8bW9zaGVAbWVsbGFub3guY29tPg0KPiA+IA0K
PiA+IEFkZGVkIHRoZSBmb2xsb3dpbmcgcGFja2V0cyBkcm9wIGNvdW50ZXI6DQo+ID4gRGV2aWNl
IG91dCBvZiBidWZmZXIgLSBjb3VudHMgcGFja2V0cyB3aGljaCB3ZXJlIGRyb3BwZWQgZHVlIHRv
DQo+ID4gZnVsbA0KPiA+IGRldmljZSBpbnRlcm5hbCByZWNlaXZlIHF1ZXVlLg0KPiA+IFRoaXMg
Y291bnRlciB3aWxsIGJlIHNob3duIG9uIGV0aHRvb2wgYXMgYSBuZXcgY291bnRlciBjYWxsZWQN
Cj4gPiBkZXZfb3V0X29mX2J1ZmZlci4NCj4gPiBUaGUgY291bnRlciBpcyByZWFkIGZyb20gRlcg
YnkgY29tbWFuZCBRVUVSWV9WTklDX0VOVi4NCj4gPiANCj4gPiBTaWduZWQtb2ZmLWJ5OiBNb3No
ZSBTaGVtZXNoIDxtb3NoZUBtZWxsYW5veC5jb20+DQo+ID4gU2lnbmVkLW9mZi1ieTogU2FlZWQg
TWFoYW1lZWQgPHNhZWVkbUBtZWxsYW5veC5jb20+DQo+IA0KPiBTb3VuZHMgbGlrZSByeF9maWZv
X2Vycm9ycywgbm8/IERvZXNuJ3QgcnhfZmlmb19lcnJvcnMgY291bnQgUlgNCj4gb3ZlcnJ1bnM/
DQoNCk5vLCB0aGF0IGlzIHBvcnQgYnVmZmVyIHlvdSBhcmUgbG9va2luZyBmb3IgYW5kIHdlIGdv
dCB0aGF0IGZ1bGx5DQpjb3ZlcmVkIGluIG1seDUuIHRoaXMgaXMgZGlmZmVyZW50Lg0KDQpUaGlz
IG5ldyBjb3VudGVyIGlzIGRlZXAgaW50byB0aGUgSFcgZGF0YSBwYXRoIHBpcGVsaW5lIGFuZCBp
dCBjb3ZlcnMNCnZlcnkgcmFyZSBhbmQgY29tcGxleCBzY2VuYXJpb3MgdGhhdCBnb3Qgb25seSBy
ZWNlbnRseSBpbnRyb2R1Y2VkIHdpdGgNCnN3aWNoZGV2IG1vZGUgYW5kICJzb21lIiBsYXRlbHkg
YWRkZWQgdHVubmVscyBvZmZsb2FkcyB0aGF0IGFyZSByb3V0ZWQNCmJldHdlZW4gVkZzL1BGcy4N
Cg0KTm9ybWFsbHkgdGhlIEhXIGlzIGxvc3NsZXNzIG9uY2UgdGhlIHBhY2tldCBwYXNzZXMgcG9y
dCBidWZmZXJzIGludG8NCnRoZSBkYXRhIHBsYW5lIHBpcGVsaW5lLCBsZXQncyBjYWxsIHRoYXQg
ImZhc3QgbGFuZSIsIEJVVCBmb3Igc3Jpb3YNCmNvbmZpZ3VyYXRpb25zIHdpdGggc3dpdGNoZGV2
IG1vZGUgZW5hYmxlZCBhbmQgc29tZSBzcGVjaWFsIGhhbmQNCmNyYWZ0ZWQgdGMgdHVubmVsIG9m
ZmxvYWRzIHRoYXQgcmVxdWlyZXMgaGFpcnBpbiBiZXR3ZWVuIFZGcy9QRnMsIHRoZQ0KaHcgbWln
aHQgZGVjaWRlIHRvIHNlbmQgc29tZSB0cmFmZmljIHRvIGEgInNlcnZpY2UgbGFuZSIgd2hpY2gg
aXMgc3RpbGwNCmZhc3QgcGF0aCBidXQgdW5saWtlIHRoZSAiZmFzdCBsYW5lIiBpdCBoYW5kbGVz
IHRyYWZmaWMgdGhyb3VnaCAiSFcNCmludGVybmFsIiByZWNlaXZlIGFuZCBzZW5kIHF1ZXVlcyAo
anVzdCBsaWtlIHdlIGRvIHdpdGggaGFpcnBpbikgdGhhdA0KbWlnaHQgZHJvcCBwYWNrZXRzLiB0
aGUgd2hvbGUgdGhpbmcgaXMgdHJhbnNwYXJlbnQgdG8gZHJpdmVyIGFuZCBpdCBpcw0KSFcgaW1w
bGVtZW50YXRpb24gc3BlY2lmaWMuDQoNClRoYW5rcywNClNhZWVkLg0KDQoNCg==
