Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 935CA11A38A
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 05:40:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726691AbfLKEkf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 23:40:35 -0500
Received: from mail-eopbgr80072.outbound.protection.outlook.com ([40.107.8.72]:14466
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726631AbfLKEkf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Dec 2019 23:40:35 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LREcPxXnakxCnBLPT1/M2r7HQu566gTkHwlsPbAxRirQuzUrqEcJ4XUsp1n7mL8opune0M52UQbIWziNCPQYul1GhiTDYiktOd0w3z59xv1LKQ76gAYp5FSQQh6nOByq/mfBsMYfV2n3Qf+bhu3Tich88Go53JLrprvjDf7wNrelWMr+4j3TNo8YJdWbbzDC4CsT/wqCtTliImruZj0tZd/VocsVGitHg8U2Ubl0p1lMtLbF71bwe+HwMhHZooA9+MF6C7KpiKagr5I55qTJKVw8eUpw7gnavx/DFqZQB1TtqLkoY0Ifh7XDh2YOB5etJPA7wUTXmWd7/AOxfVC0tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kTQVIoBXT0+Ty1ZVXEe3L4qmguHT2PGEsYoZJq/IwbI=;
 b=NyMTn2FbdYROAjtCWC1LtpnfFJx8VRBKNldGVsaYS4ohnnSx6sDilYn6+kqStY7tWp3uxdtBGkM46pfQqt5M2WyCSOEVb1Od44bvwn3P9tWUc6+LeaXWguYYcHHj6tf57Y7as79KaM4x9U1nwK8xlhDkOu4Ow36mACTRxUP64oqW7noS+O/maPLJB+76RZDSTMGkFFTS0qM3KS+Glg69UcMXV77CW0/CX0VWpQcBgAjfm6un5XEgpzyOazSXmF0kJ8DAlpLmSIRXPBBbQ9g43ySdARTpNSZjKVpUyymkx5haBouR71Minx5PwGzhnUziqUX5Cg4OPQPoAz2Ti2caQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kTQVIoBXT0+Ty1ZVXEe3L4qmguHT2PGEsYoZJq/IwbI=;
 b=EhOlobBCChBBfcPbbZJEfKN62KxeeepnmXRm+o7XCImoUy2kgeLtIiIlgC4FUecoZ9ydlEmnQmpeRMxb5HxHK09/rCI+IHRXb9f2jso/5VcjzV4S1rXBOPfxiaGZP59F70J/NZqQ1u4PPZcVnmC/1Hokprnl0crebyWS/TSV5+I=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB4514.eurprd05.prod.outlook.com (52.133.55.152) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.14; Wed, 11 Dec 2019 04:40:31 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::16:9951:5a4b:9ec6]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::16:9951:5a4b:9ec6%7]) with mapi id 15.20.2516.018; Wed, 11 Dec 2019
 04:40:31 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Shannon Nelson <snelson@pensando.io>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH net-next 2/2] ionic: support sr-iov operations
Thread-Topic: [PATCH net-next 2/2] ionic: support sr-iov operations
Thread-Index: AQHVr6zOFjqN5wjDOEqkWYoFSecuO6e0KGwAgAAcJQCAABZRAA==
Date:   Wed, 11 Dec 2019 04:40:31 +0000
Message-ID: <66e99536-43b5-ad8c-4af0-46a73a7e1d7a@mellanox.com>
References: <20191210225421.35193-1-snelson@pensando.io>
 <20191210225421.35193-3-snelson@pensando.io>
 <84808074-6984-14ca-7d22-65332086ad19@mellanox.com>
 <2bdf19d1-55e3-60ff-bf6b-dd4f3097d672@pensando.io>
In-Reply-To: <2bdf19d1-55e3-60ff-bf6b-dd4f3097d672@pensando.io>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [68.203.16.89]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 587052ed-2da3-46bc-e275-08d77df44152
x-ms-traffictypediagnostic: AM0PR05MB4514:
x-microsoft-antispam-prvs: <AM0PR05MB45145A8937E502519DEF97CFD15A0@AM0PR05MB4514.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 024847EE92
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(396003)(39860400002)(136003)(366004)(346002)(189003)(199004)(66476007)(186003)(316002)(2616005)(71200400001)(66446008)(6486002)(478600001)(66946007)(2906002)(6506007)(64756008)(76116006)(66556008)(6512007)(110136005)(31696002)(5660300002)(81156014)(36756003)(31686004)(53546011)(8676002)(8936002)(26005)(86362001)(81166006);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB4514;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: v+fRrVaxYK8Uk+j6Oy6ECeX6r9KXiUeMAtIqt57JhPosW3jPyspxKYJK1yvaTsYHTAEpOe1qS/l8N0Vt3TH3EJHB3KPuuRiUHyjsMDeHEDAVIyLgxzLSBnvE2CNE2ALqk+2OSxiiyQflVypl1CUUxaAp3LZ4aBsBxNC0JeuchtLw6KfifU5LFWMfJl1atuRhn6EKZwrcgjtyiCMEuu4nuf8WUML0CtENZTijyAoGjUP5KtZWnIw2CoCMOyQQJD9SIdEV0iNd1/60oau8dH+9q08Ht1RznQHThr9hzsJn5eNL4X9GKzpmfw8y58T6WmTA5MU0kjvAW4Up/Hcf4rKJg5FdfbZnUrz/WJW4kgYuNhzFu9dwml3c2SklHIxwA0HZuY079z8E9a4x8vukv+1K3kU6M3U7z0Kg4PrGkl0TWD/CaLppAE+eScyvnZZvotBQ
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <C65F8D8654818448ABEAA5DED007370F@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 587052ed-2da3-46bc-e275-08d77df44152
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Dec 2019 04:40:31.6978
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZmoUAuChIDVBTr9Z8xkZdFj5ZwtHt0dzyDYkEYXYAxBFZXoZ74sDxhJrF/EdUQ4i7GCJSKbPt6Au56PSRObLCQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4514
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTIvMTAvMjAxOSA5OjIwIFBNLCBTaGFubm9uIE5lbHNvbiB3cm90ZToNCj4gT24gMTIvMTAv
MTkgNTozOSBQTSwgUGFyYXYgUGFuZGl0IHdyb3RlOg0KPj4gT24gMTIvMTAvMjAxOSA0OjU0IFBN
LCBTaGFubm9uIE5lbHNvbiB3cm90ZToNCj4+PiBBZGQgdGhlIG5ldGRldiBvcHMgZm9yIG1hbmFn
aW5nIFZGcy7CoCBTaW5jZSBtb3N0IG9mIHRoZQ0KPj4+IG1hbmFnZW1lbnQgd29yayBoYXBwZW5z
IGluIHRoZSBOSUMgZmlybXdhcmUsIHRoZSBkcml2ZXIgYmVjb21lcw0KPj4+IG1vc3RseSBhIHBh
c3MtdGhyb3VnaCBmb3IgdGhlIG5ldHdvcmsgc3RhY2sgY29tbWFuZHMgdGhhdCB3YW50DQo+Pj4g
dG8gY29udHJvbCBhbmQgY29uZmlndXJlIHRoZSBWRnMuDQo+Pj4NCj4+PiBXZSBhbHNvIHR3ZWFr
IGlvbmljX3N0YXRpb25fc2V0KCkgYSBsaXR0bGUgdG8gYWxsb3cgZm9yDQo+Pj4gdGhlIFZGcyB0
aGF0IHN0YXJ0IG9mZiB3aXRoIGEgemVybydkIG1hYyBhZGRyZXNzLg0KPj4+DQo+Pj4gU2lnbmVk
LW9mZi1ieTogU2hhbm5vbiBOZWxzb24gPHNuZWxzb25AcGVuc2FuZG8uaW8+DQo+Pj4gLS0tDQo+
IFsuLi5dDQo+Pj4gwqAgKy8qIFZGIGNvbW1hbmRzICovDQo+Pj4gK2ludCBpb25pY19zZXRfdmZf
Y29uZmlnKHN0cnVjdCBpb25pYyAqaW9uaWMsIGludCB2ZiwgdTggYXR0ciwgdTggKmRhdGEpDQo+
Pj4gK3sNCj4+IEkgZm9yZ290IHRvIG1lbnRpb24gaW4gbXkgcHJldmlvdXMgcmV2aWV3IGNvbW1l
bnQgdGhhdCBzZXRfdmZfY29uZmlnKCkNCj4+IGFuZCBvdGhlciBWRiBjb25maWcgZnJpZW5kIGNh
bGxiYWNrIGZ1bmN0aW9ucyBjYW4gcmFjZSB3aXRoDQo+PiBpb25pY19zcmlvdl9jb25maWd1cmUo
KS4NCj4+DQo+PiBGb3JtZXIgaXMgY2FsbGVkIGZyb20gbmV0bGluayBjb250ZXh0LCBsYXRlciBp
cyBjYWxsZWQgZnJvbSBzeXNmcy4NCj4+IEl0cyBub3QgdG9vIGhhcmQgdG8gY3Jhc2ggdGhlIHN5
c3RlbSBib3RoIHJhY2luZyB3aXRoIGVhY2ggb3RoZXIuDQo+Pg0KPj4gSGVuY2UgcHJvdGVjdCB0
aGVtIHVzaW5nIHJ3c2VtLCB3aGVyZSBzZXRfdmZfKCkgYW5kIHNyaW92X2NvbmZpZ3VyZSgpDQo+
PiBkb2VzIGRvd24vdXBfd3JpdGUoKSBhbmQgZ2V0X3ZmX2NvbmZpZygpIGFuZCBnZXRfdmZfc3Rh
dCgpIGRvZXMNCj4+IGRvd25fdXAvcmVhZCgpLg0KPj4NCj4+DQo+IA0KPiBBaCwgZ29vZCBjYXRj
aC7CoCBUaGF0IHNlZW1zIHRvIGJlIHJlbGF0aXZlbHkgYSBuZXcgdGhpbmcgYW5kIHdpdGggYQ0K
PiBxdWljayBsb29rIGFyb3VuZCBpdCBzZWVtcyBub3QgbWFueSBkcml2ZXJzIGRlYWwgd2l0aCB0
aGF0IHlldC4gVGhhbmtzDQo+IGZvciBwb2ludGluZyBpdCBvdXQuDQo+DQpZZXMuIEkgYW0gYXdh
cmUgb2YgaXQgZm9yIGEgd2hpbGUuIEkgYW0gZml4aW5nIG1seDUgZHJpdmVyIGN1cnJlbnRseS4N
Cg0KPiBzbG4NCj4gDQoNCg==
