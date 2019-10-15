Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1E6ED811B
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 22:33:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387947AbfJOUdc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 16:33:32 -0400
Received: from mail-eopbgr40062.outbound.protection.outlook.com ([40.107.4.62]:15246
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726227AbfJOUdb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Oct 2019 16:33:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OyWFH6ZA8wKXnjGM7trmQPJ8UieKb+HmP8qMCMcAZue1+2m0KzlchmDmlFRSasHABqttGBB0lJPlcflJaGsVGR4ykIXqK/cBpBaRyJpC0bzypR9BzCy5v5slSM7HqotoKHItkhf8i9q9QA+B/k9ROwUsl6AbUn+hvQALXeYYA3sSPGWd06lT0VMsr/Y9IpZO8vHSISsHTkOBYRDSnNd5KPtd7Ze08Du1fzKPqNh6FlmV1blB7RDMQ2WM7dB8eMbsjmIKHiGsKm9lhcefpCqMZYVW3WHhJnMg9EVILsWiZwSpbnrhi1oY8cKYUkeaZh3KAU/aavCGkfVTAc1icxEUbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K1fHxH0CNXVG9/mdbEh9Sn2cWdBIqvVj4CtHb1F2zpg=;
 b=YwVIfHWR5fyJipnljSgAbt8tMJb8NEOkeGYiaBtxqlC0xbqsgNJWUzbSHWpn8vTMlFQq4Xjogfb7sFPA4h199mqMfvCMwKGdtCCtnWr5PrXLxzIxvdWD9MiflvGwE/P1xYbxvXK+Rn61oQELLKtz8FDC+8PIHFlwrKnwZ+OHJytbcH9004uqhxtPmDXIo6GE/IsxgcJ6jAK9ZtooYOVsVL/dpOL5FQyo9nGW6ibqSJqW+CPrzuoHVkFTTH089vWcBVFfcXLNN8EMcojea7itizV4STRi3EfIMgTrUyZNHomzEfLjki0pEtcIGHF43NknxBitRHLh5npDISldpPa+GA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K1fHxH0CNXVG9/mdbEh9Sn2cWdBIqvVj4CtHb1F2zpg=;
 b=ivwCOB3ndajRDOic1d8i3fJGrG5dLV2woy3gtIWXLkg7/PhhJGKZE01Z79EZt8MQs7yV7rM0+zk7cDl0yJziZxuGBzy7UHvZU2AkVI7QQzZxGfGi5fCllBpjPkZSS4+mLPOnycpemHBkns6QHC96IARBebvts1UxZVAHjzD4Jrs=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB5597.eurprd05.prod.outlook.com (20.177.203.29) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.19; Tue, 15 Oct 2019 20:33:28 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::f42d:b87a:e6b2:f841]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::f42d:b87a:e6b2:f841%7]) with mapi id 15.20.2347.023; Tue, 15 Oct 2019
 20:33:28 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "navid.emamdoost@gmail.com" <navid.emamdoost@gmail.com>
CC:     "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "emamd001@umn.edu" <emamd001@umn.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "smccaman@umn.edu" <smccaman@umn.edu>,
        "leon@kernel.org" <leon@kernel.org>, "kjlu@umn.edu" <kjlu@umn.edu>
Subject: Re: [PATCH] net/mlx5: fix memory leak in mlx5_fw_fatal_reporter_dump
Thread-Topic: [PATCH] net/mlx5: fix memory leak in mlx5_fw_fatal_reporter_dump
Thread-Index: AQHVdYQs/F1AbLj07EC64xteHnFDoqdcRIuA
Date:   Tue, 15 Oct 2019 20:33:28 +0000
Message-ID: <721412ca4de2a496f6869b9620e7b47382582dde.camel@mellanox.com>
References: <20190927223729.18043-1-navid.emamdoost@gmail.com>
In-Reply-To: <20190927223729.18043-1-navid.emamdoost@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.4 (3.32.4-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 92fbf125-566d-48a6-c105-08d751aeeff2
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: VI1PR05MB5597:
x-microsoft-antispam-prvs: <VI1PR05MB559780B95CBD61343D590554BE930@VI1PR05MB5597.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1360;
x-forefront-prvs: 01917B1794
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(366004)(39860400002)(396003)(376002)(346002)(199004)(189003)(2906002)(14444005)(256004)(76176011)(6916009)(8936002)(2351001)(316002)(3846002)(6116002)(6506007)(6512007)(102836004)(5640700003)(4326008)(81156014)(6246003)(229853002)(8676002)(6436002)(81166006)(478600001)(2616005)(6486002)(11346002)(446003)(476003)(25786009)(486006)(186003)(58126008)(99286004)(86362001)(7736002)(26005)(305945005)(71200400001)(71190400001)(36756003)(54906003)(118296001)(91956017)(76116006)(1361003)(64756008)(66556008)(66446008)(66476007)(66946007)(2501003)(66066001)(14454004)(5660300002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5597;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zz7gnuohcNgMssF0Of5ZbBf4CK7Oh3sS217g0IqfTtS13A+y/CWKJBDyyGgELypJxbG2L6tUVSPLNRe/OnC3uOARon0jlgPoBomuibea91c9L/tqojMFfWHTvvOuz/4vDLTy8Fr9uxc9oeY+ahVFzwwwfUdsRblAUDQ6Xyl9kWXxaWZv7svguJOw+VmUy1ypXJ6pFWMjkxUdAtyW1ZXfwwxBul47goqlLjMS+PIV+ruG9cD5TkulCqgHjFatmaoh/46ktzavNh1Y86BzkMcRmF0cIrITk88VIrsCIpQydt4PmTtkXgC+p5pOFw9qzvJvgUfSCD/eim4a6mKDtVcA/7L90uujhqmTmuf6/Uu/HgY7iXY+8dR49QryG+qdD/pKqGnSO0FpMwpbW1tf/O+lCT6xmczSjiW+BiG/2UOaMVw=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <E063ABC493A0B64092C1EC16E39FDDD5@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 92fbf125-566d-48a6-c105-08d751aeeff2
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Oct 2019 20:33:28.5259
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QdAEfRQqy40Q4MpIELG8UidTaE/dvkPGLyEmewGm49mKrPTswniu2bufNwiZoDY9fklCvlghts8gaZeiP5s40w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5597
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDE5LTA5LTI3IGF0IDE3OjM3IC0wNTAwLCBOYXZpZCBFbWFtZG9vc3Qgd3JvdGU6
DQo+IEluIG1seDVfZndfZmF0YWxfcmVwb3J0ZXJfZHVtcCBpZiBtbHg1X2NyZHVtcF9jb2xsZWN0
IGZhaWxzIHRoZQ0KPiBhbGxvY2F0ZWQgbWVtb3J5IGZvciBjcl9kYXRhIG11c3QgYmUgcmVsZWFz
ZWQgb3RoZXJ3aXNlIHRoZXJlIHdpbGwgYmUNCj4gbWVtb3J5IGxlYWsuIFRvIGZpeCB0aGlzLCB0
aGlzIGNvbW1pdCBjaGFuZ2VzIHRoZSByZXR1cm4gaW5zdHJ1Y3Rpb24NCj4gaW50byBnb3RvIGVy
cm9yIGhhbmRsaW5nLg0KPiANCj4gRml4ZXM6IDliMWYyOTgyMzYwNSAoIm5ldC9tbHg1OiBBZGQg
c3VwcG9ydCBmb3IgRlcgZmF0YWwgcmVwb3J0ZXINCj4gZHVtcCIpDQo+IA0KPiBTaWduZWQtb2Zm
LWJ5OiBOYXZpZCBFbWFtZG9vc3QgPG5hdmlkLmVtYW1kb29zdEBnbWFpbC5jb20+DQo+IA0KDQpB
cHBsaWVkIHRvIG5ldC1uZXh0LW1seDUsIHdpbGwgYmUgc2VudCB0byBuZXQtbmV4dCBzaG9ydGx5
LCBpIHdpbGwgZml4DQp0aGUgZXh0cmEgZW1wdHkgbGluZSBhcyBMZW9uIHBvaW50ZWQgb3V0Lg0K
DQpUaGFua3MsDQpTYWVlZC4NCg0KPiAtLS0NCj4gIGRyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxh
bm94L21seDUvY29yZS9oZWFsdGguYyB8IDIgKy0NCj4gIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2Vy
dGlvbigrKSwgMSBkZWxldGlvbigtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0
aGVybmV0L21lbGxhbm94L21seDUvY29yZS9oZWFsdGguYw0KPiBiL2RyaXZlcnMvbmV0L2V0aGVy
bmV0L21lbGxhbm94L21seDUvY29yZS9oZWFsdGguYw0KPiBpbmRleCBkNjg1MTIyZDlmZjcuLmMw
N2YzMTU0NDM3YyAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gv
bWx4NS9jb3JlL2hlYWx0aC5jDQo+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94
L21seDUvY29yZS9oZWFsdGguYw0KPiBAQCAtNTcyLDcgKzU3Miw3IEBAIG1seDVfZndfZmF0YWxf
cmVwb3J0ZXJfZHVtcChzdHJ1Y3QNCj4gZGV2bGlua19oZWFsdGhfcmVwb3J0ZXIgKnJlcG9ydGVy
LA0KPiAgCQlyZXR1cm4gLUVOT01FTTsNCj4gIAllcnIgPSBtbHg1X2NyZHVtcF9jb2xsZWN0KGRl
diwgY3JfZGF0YSk7DQo+ICAJaWYgKGVycikNCj4gLQkJcmV0dXJuIGVycjsNCj4gKwkJZ290byBm
cmVlX2RhdGE7DQo+ICANCj4gIAlpZiAocHJpdl9jdHgpIHsNCj4gIAkJc3RydWN0IG1seDVfZndf
cmVwb3J0ZXJfY3R4ICpmd19yZXBvcnRlcl9jdHggPQ0KPiBwcml2X2N0eDsNCg==
