Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9ABFC11449B
	for <lists+netdev@lfdr.de>; Thu,  5 Dec 2019 17:16:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729841AbfLEQQb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Dec 2019 11:16:31 -0500
Received: from mail-eopbgr20053.outbound.protection.outlook.com ([40.107.2.53]:58114
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729540AbfLEQQa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Dec 2019 11:16:30 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SatY+1r7pvCQpUcXNoE/t5jcvGj+RhlGv2BU5Y5WB92jDYD3KyWCOtakT0QY3su9jEGyl5z76oFUFVT2itKqrwj76u2JxO/gvnfuLbZ71FsE0C47caiiG+0qhkZRTOs2pWDokUdw1N3nFiN/EV2QxPNfZsNJ4U2UAeYi0oC7SyOz+DYD4ooNgwjIZEKO8T2U3t6b8JlIUa7OkvxG7vchgq2a8dvE1faqoEDzB/SdsocSNQhLvT382D6snD7JxCDA+9884bfXGMj9kZKyV4ZPZSmGSXTK2h9sBr3++f+S/SkqvMO/A2oK+l5bYXdPPfHW/9kEosJzjPOGj0OSsTNvhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JVg+QKT6VwCW2z5eNFy3nlRnO6o8PDsHQpQzMLWq8B4=;
 b=WUBeJAa9+EZ1vlznM2QuOgn/0wo4wfQFALLZ5ze8DiNEjT6fWAgLLGv8o2kABZ4LNpZCTZH5kIctpZImCiNUzjWmEQAVtMHWI3a5rm8/msTK1yO91YMp3j7wwTWYK1bOgTpeJOG8kLuV/VQzScxVvZH5j8abj9TECMllpDbYK6yi7TGrp0Sct/5rOSRPxS1MEDItm5kmMDErBYxWU3+bSGQ486rJAZgnddqodteJc4ZO9zGJKUjDQID1IhgnCNyPHY+kR8cH6Y7BsLZJ2tSsiUnaO2WG+0B+sPxZbzdbTlEoAXIUJvPmCKUvO2XcKuqDYoXJOM1xMYSNZFfhrX8VlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JVg+QKT6VwCW2z5eNFy3nlRnO6o8PDsHQpQzMLWq8B4=;
 b=mpkRH/ijqGyW/dzvE8fvsTjrQDQUjk0wUEyfiKr9iCBqxx+QPg/gvzV/9tOQjLJt3+bXmSPfU2BUc6EKad2YXktM1cyuk5VAQjsZZSZfgjYwaRPmBQBeLPCIeb45SlPUrJB857BJPBRqGRMzdwdlFWhZQ6jLKGwqvNrJT3QXLps=
Received: from AM0PR0502MB3603.eurprd05.prod.outlook.com (52.133.49.149) by
 AM0PR0502MB4083.eurprd05.prod.outlook.com (52.133.36.30) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2495.22; Thu, 5 Dec 2019 16:16:22 +0000
Received: from AM0PR0502MB3603.eurprd05.prod.outlook.com
 ([fe80::71b6:d517:71ac:63fc]) by AM0PR0502MB3603.eurprd05.prod.outlook.com
 ([fe80::71b6:d517:71ac:63fc%7]) with mapi id 15.20.2495.014; Thu, 5 Dec 2019
 16:16:22 +0000
From:   Noam Stolero <noams@mellanox.com>
To:     Catalin Marinas <catalin.marinas@arm.com>
CC:     "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@kernel.org>,
        Matthew Wilcox <willy@infradead.org>, Qian Cai <cai@lca.pw>,
        Tal Gilboa <talgi@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Amir Ancel <amira@mellanox.com>,
        Matan Nir <matann@mellanox.com>, Bar Tuaf <bartu@mellanox.com>,
        "brouer@redhat.com" <brouer@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Moshe Shemesh <moshe@mellanox.com>
Subject: Re: [PATCH v3 0/3] mm: kmemleak: Use a memory pool for kmemleak
 object allocations
Thread-Topic: [PATCH v3 0/3] mm: kmemleak: Use a memory pool for kmemleak
 object allocations
Thread-Index: AQHVqfGR6Skbhhwb2EindxaFzgFGGqeok84AgAMm9oA=
Date:   Thu, 5 Dec 2019 16:16:22 +0000
Message-ID: <25fb28e4-f3fe-4236-7d76-3aed04d84956@mellanox.com>
References: <20190812160642.52134-1-catalin.marinas@arm.com>
 <08847a90-c37b-890f-8d0e-3ae1c3a1dd71@mellanox.com>
 <20191203160806.GB23522@arrakis.emea.arm.com>
In-Reply-To: <20191203160806.GB23522@arrakis.emea.arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [193.47.165.251]
x-clientproxiedby: AM0PR06CA0088.eurprd06.prod.outlook.com
 (2603:10a6:208:fa::29) To AM0PR0502MB3603.eurprd05.prod.outlook.com
 (2603:10a6:208:23::21)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=noams@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 87da02b2-1d06-485a-5030-08d7799e77ea
x-ms-traffictypediagnostic: AM0PR0502MB4083:|AM0PR0502MB4083:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR0502MB4083BFBCF6C7BC07FBE29F12DB5C0@AM0PR0502MB4083.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 02426D11FE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(346002)(396003)(136003)(376002)(39860400002)(199004)(189003)(99286004)(26005)(2616005)(66946007)(2906002)(229853002)(14454004)(25786009)(305945005)(316002)(7416002)(8676002)(52116002)(6506007)(76176011)(53546011)(6486002)(11346002)(81166006)(8936002)(66446008)(64756008)(66476007)(86362001)(66556008)(186003)(102836004)(5660300002)(54906003)(81156014)(107886003)(31696002)(6916009)(6512007)(478600001)(71190400001)(31686004)(966005)(36756003)(71200400001)(4326008);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR0502MB4083;H:AM0PR0502MB3603.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: en9a3c4zPEmWhMdL0Y1BwsVjq3+B4nEVUfdadD2HmYMi8VcRc6chAspA1ftn8YY6k0wOXqSNA9iHGtrClJx3FW7KwQ1kDrQUUqm2BAVc/RhHwSceVzQtRyb7KDr3PXCLFcSln8jILtMxQSG/Hyp5g33V1ZzgHDuC6lMGi+m/kpX27ZPRGJ6M69pRsbI/tOHlMjO7WxjU1Io5fyCsGIO2o70yaxZ6AP/Y2dMpHZCRjVhaL5nkABJxePlkMGAhsCtRm7IaikVIwMZJXVPnwWT1j7+JOVcKlLI/CYpyrWLlDIyXsOHdXjiYNwS3SSiE9R45NKtyW6DC1fszZFkOqMQW9l510nrj/2pei4PhQ1KuN7gaDXf+BWfosl7yxWIvtJ5SqLWdJGmch7HXsqiEb6W1PuniP1DkJmGdU0xsOEfFO91XKzajPg7/SU00/XefBOShFIixFZM8hrn6i4KfZ97mBaxNwSxUReQ3dETQYhFsV64=
Content-Type: text/plain; charset="utf-8"
Content-ID: <70BDBCCD4C82204CB1F98F80E8104C7E@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87da02b2-1d06-485a-5030-08d7799e77ea
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Dec 2019 16:16:22.1489
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IYXEgsxvwcEJGDxsV/SQvHkI2qjTR3LtLnEmsQeRlS7ht2CEb//Egh7aW07qjg9Yj70Outo3LvW0Ts2Ml5pwhA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0502MB4083
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTIvMy8yMDE5IDY6MDggUE0sIENhdGFsaW4gTWFyaW5hcyB3cm90ZToNCj4gT24gVHVlLCBE
ZWMgMDMsIDIwMTkgYXQgMDM6NTE6NTBQTSArMDAwMCwgTm9hbSBTdG9sZXJvIHdyb3RlOg0KPj4g
T24gOC8xMi8yMDE5IDc6MDYgUE0sIENhdGFsaW4gTWFyaW5hcyB3cm90ZToNCj4+PiAgICAgIEZv
bGxvd2luZyB0aGUgZGlzY3Vzc2lvbnMgb24gdjIgb2YgdGhpcyBwYXRjaChzZXQpIFsxXSwgdGhp
cyBzZXJpZXMNCj4+PiAgICAgIHRha2VzIHNsaWdodGx5IGRpZmZlcmVudCBhcHByb2FjaDoNCj4+
Pg0KPj4+ICAgICAgLSBpdCBpbXBsZW1lbnRzIGl0cyBvd24gc2ltcGxlIG1lbW9yeSBwb29sIHRo
YXQgZG9lcyBub3QgcmVseSBvbiB0aGUNCj4+PiAgICAgICAgc2xhYiBhbGxvY2F0b3INCj4+Pg0K
Pj4+ICAgICAgLSBkcm9wcyB0aGUgZWFybHkgbG9nIGJ1ZmZlciBsb2dpYyBlbnRpcmVseSBzaW5j
ZSBpdCBjYW4gbm93IGFsbG9jYXRlDQo+Pj4gICAgICAgIG1ldGFkYXRhIGZyb20gdGhlIG1lbW9y
eSBwb29sIGRpcmVjdGx5IGJlZm9yZSBrbWVtbGVhayBpcyBmdWxseQ0KPj4+ICAgICAgICBpbml0
aWFsaXNlZA0KPj4+DQo+Pj4gICAgICAtIENPTkZJR19ERUJVR19LTUVNTEVBS19FQVJMWV9MT0df
U0laRSBvcHRpb24gaXMgcmVuYW1lZCB0bw0KPj4+ICAgICAgICBDT05GSUdfREVCVUdfS01FTUxF
QUtfTUVNX1BPT0xfU0laRQ0KPj4+DQo+Pj4gICAgICAtIG1vdmVzIHRoZSBrbWVtbGVha19pbml0
KCkgY2FsbCBlYXJsaWVyIChtbV9pbml0KCkpDQo+Pj4NCj4+PiAgICAgIC0gdG8gYXZvaWQgYSBz
ZXBhcmF0ZSBtZW1vcnkgcG9vbCBmb3Igc3RydWN0IHNjYW5fYXJlYSwgaXQgbWFrZXMgdGhlDQo+
Pj4gICAgICAgIHRvb2wgcm9idXN0IHdoZW4gc3VjaCBhbGxvY2F0aW9ucyBmYWlsIGFzIHNjYW4g
YXJlYXMgYXJlIHJhdGhlciBhbg0KPj4+ICAgICAgICBvcHRpbWlzYXRpb24NCj4+Pg0KPj4+ICAg
ICAgWzFdIGh0dHA6Ly9sa21sLmtlcm5lbC5vcmcvci8yMDE5MDcyNzEzMjMzNC45MTg0LTEtY2F0
YWxpbi5tYXJpbmFzQGFybS5jb20NCj4+Pg0KPj4+ICAgICAgQ2F0YWxpbiBNYXJpbmFzICgzKToN
Cj4+PiAgICAgICAgbW06IGttZW1sZWFrOiBNYWtlIHRoZSB0b29sIHRvbGVyYW50IHRvIHN0cnVj
dCBzY2FuX2FyZWEgYWxsb2NhdGlvbg0KPj4+ICAgICAgICAgIGZhaWx1cmVzDQo+Pj4gICAgICAg
IG1tOiBrbWVtbGVhazogU2ltcGxlIG1lbW9yeSBhbGxvY2F0aW9uIHBvb2wgZm9yIGttZW1sZWFr
IG9iamVjdHMNCj4+PiAgICAgICAgbW06IGttZW1sZWFrOiBVc2UgdGhlIG1lbW9yeSBwb29sIGZv
ciBlYXJseSBhbGxvY2F0aW9ucw0KPj4+DQo+Pj4gICAgICAgaW5pdC9tYWluLmMgICAgICAgfCAg
IDIgKy0NCj4+PiAgICAgICBsaWIvS2NvbmZpZy5kZWJ1ZyB8ICAxMSArLQ0KPj4+ICAgICAgIG1t
L2ttZW1sZWFrLmMgICAgIHwgMzI1ICsrKysrKysrKysrKy0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0NCj4+PiAgICAgICAzIGZpbGVzIGNoYW5nZWQsIDkxIGluc2VydGlvbnMoKyks
IDI0NyBkZWxldGlvbnMoLSkNCj4+IFdlIG9ic2VydmUgc2V2ZXJlIGRlZ3JhZGF0aW9uIGluIG91
ciBuZXR3b3JrIHBlcmZvcm1hbmNlIGFmZmVjdGluZyBhbGwNCj4+IG9mIG91ciBOSUNzLiBUaGUg
ZGVncmFkYXRpb24gaXMgZGlyZWN0bHkgbGlua2VkIHRvIHRoaXMgcGF0Y2guDQo+Pg0KPj4gV2hh
dCB3ZSBydW46DQo+PiBTaW1wbGUgSXBlcmYgVENQIGxvb3BiYWNrIHdpdGggOCBzdHJlYW1zIG9u
IENvbm5lY3RYNS0xMDBHYkUuDQo+PiBTaW5jZSBpdCdzIGEgbG9vcGJhY2sgdGVzdCwgdHJhZmZp
YyBnb2VzIGZyb20gdGhlIHNvY2tldCB0aHJvdWdoIHRoZSBJUA0KPj4gc3RhY2sgYW5kIGJhY2sg
dG8gdGhlIHNvY2tldCwgd2l0aG91dCBnb2luZyB0aHJvdWdoIHRoZSBOSUMgZHJpdmVyLg0KPiBT
b21ldGhpbmcgc2ltaWxhciB3YXMgcmVwb3J0ZWQgYmVmb3JlLiBDYW4geW91IHRyeSBjb21taXQg
MmFiZDgzOWFhN2U2DQo+ICgia21lbWxlYWs6IERvIG5vdCBjb3JydXB0IHRoZSBvYmplY3RfbGlz
dCBkdXJpbmcgY2xlYW4tdXAiKSBhbmQgc2VlIGlmDQo+IGl0IGZpeGVzIHRoZSBwcm9ibGVtIGZv
ciB5b3U/IEl0IHdhcyBtZXJnZWQgaW4gNS40LXJjNC4NCg0KSSd2ZSB0ZXN0ZWQgdGhpcyBjb21t
aXQsIGFzIHdlbGwgYXMgNS40LjAtcmM2IGFuZCA1LjQuMCBHQSB2ZXJzaW9ucy4gV2UgDQpkb24n
dCBzZWUgdGhlIGlzc3VlIEkndmUgbWVudGlvbmVkLg0KDQpUaGFuayB5b3UgZm9yIHRoZSBxdWlj
ayByZXNwb25zZSBhbmQgdGhlIGFzc2lzdGFuY2UuDQo=
