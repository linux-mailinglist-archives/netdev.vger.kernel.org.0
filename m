Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EEA6E123227
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 17:20:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729005AbfLQQUp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 11:20:45 -0500
Received: from mail-eopbgr150048.outbound.protection.outlook.com ([40.107.15.48]:52522
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728527AbfLQQUo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Dec 2019 11:20:44 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N7xrbPO5yG3kFRwTCrjbvVW30xj706RBofpbNQysCb0SGc6tBI3KZf8FjOzpEwyyDCCR0oM9aS1kSqbvvMSNtOMG2is/0msx+pKofpf+cDHxJ31C5+u6BlxPXBT8XldbpziL6F0/TEgC8/H6TgeT63i+mnjPScVX/cUOspWKhF8DEeh2ihOnOQQwrr+KywZ7LPevJPrXYRBaKY2/leFQUGF16P5VbzLm7WXC55oL4p3/yj5+jtZ6d6NeZ+TQMZ3s98KU50fdVLjk0Ykd6jpPIEHRNixMtwZ2WVjS3JgeXWP3oeim1oYnMOHDr2hFL0gyb0vOxlbtMXbHicLOibikmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=92vLnVII87cwYWMOQh5lc1k3QeVufHT+n8V3xk8fVVI=;
 b=Utvf//uIdZkdOEMJkrVF6NapDODfOCBNHoZX9xCAtljmbqjOkffdV3jvdc0WxvdbOOnkXoWBTXuLD18jSKYX3xLXoCQpEzEZUxdJKEXv9seM6sv1o3wHL4ePDefxDo+6iG3/AjNkcCFv8TGeT5wgzOzjnLGBW7KryQjzdpRuVzI6JU96Bin4Xpg82iwxj2ukuXStnaJ0zqHrBP5W1JVPjUnFUblr8zqOckIG5YXKkpaaaVRJiXYQkZLDhGYekwACNt6+fp4hWYkKvkHQmz9fybGDCtUmdGiDEw+PuXaFegRA9yKwlRnhNzhGOVnCRltA6mOiboPcxkie/idT2Xicyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=92vLnVII87cwYWMOQh5lc1k3QeVufHT+n8V3xk8fVVI=;
 b=gkA0q0SGflwrb48QhfyiL4VPtv4pMCqSqD3xnuhSUl2ro0JyNC1k7hZl73QA6MgjRldzJZ2a+LAuNVF9uKzuBkBJ42QpdMtxaMHCwgBRkjIhk3ziVSQBpfThM3GcEH3IQH7L+VGe8VMVILJ9NADlkPdwtOvBZuJGBW4B3xZ4Hwc=
Received: from AM0PR05MB5875.eurprd05.prod.outlook.com (20.178.119.159) by
 AM0PR05MB4259.eurprd05.prod.outlook.com (52.134.126.24) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.18; Tue, 17 Dec 2019 16:20:41 +0000
Received: from AM0PR05MB5875.eurprd05.prod.outlook.com
 ([fe80::259f:70b4:dab1:8f2]) by AM0PR05MB5875.eurprd05.prod.outlook.com
 ([fe80::259f:70b4:dab1:8f2%5]) with mapi id 15.20.2538.019; Tue, 17 Dec 2019
 16:20:41 +0000
From:   Maxim Mikityanskiy <maximmi@mellanox.com>
To:     =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "David S. Miller" <davem@davemloft.net>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>
Subject: [PATCH bpf v2 0/4] Fix concurrency issues between XSK wakeup and
 control path using RCU
Thread-Topic: [PATCH bpf v2 0/4] Fix concurrency issues between XSK wakeup and
 control path using RCU
Thread-Index: AQHVtPXs+Va8FuX1jEyvTO2pLjnBKA==
Date:   Tue, 17 Dec 2019 16:20:41 +0000
Message-ID: <20191217162023.16011-1-maximmi@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM0PR02CA0106.eurprd02.prod.outlook.com
 (2603:10a6:208:154::47) To AM0PR05MB5875.eurprd05.prod.outlook.com
 (2603:10a6:208:12d::31)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=maximmi@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.20.1
x-originating-ip: [94.188.199.18]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 9f8b20b6-f5b9-4ff5-6405-08d7830d0f32
x-ms-traffictypediagnostic: AM0PR05MB4259:|AM0PR05MB4259:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB4259380A5B10DA49232DD162D1500@AM0PR05MB4259.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 02543CD7CD
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(136003)(366004)(346002)(396003)(39860400002)(199004)(189003)(54906003)(26005)(66556008)(6506007)(110136005)(66476007)(2906002)(7416002)(64756008)(186003)(5660300002)(66446008)(36756003)(52116002)(1076003)(8676002)(81166006)(71200400001)(86362001)(81156014)(6486002)(107886003)(2616005)(478600001)(316002)(66946007)(6512007)(66574012)(8936002)(4326008);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB4259;H:AM0PR05MB5875.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XUdh4Hjqug0sb3opZTigbmK855/O5nTDlq/V1yvgqwnZ0iulNZtYOCooOAMyOKR+JJbkc6Yh3qFk2kaPNWv+jQhJB6FzRwYaXVf0zYZLtYZnS0PsmfycAAQ+n9zex4NgsWQfjrM6akmlpU3bm86VvEqDMLlszUu5jbwWcAiPyYEVbtLjGzYL8UyE1lNpVxo2gyzUJlLhj9M7x8R3zUxrMRmZeBVAU9SjWMreu50HYuFa1Bghv6/AxOfWH5e0DApIPGnikeb+NmjUcWvBB58RZOhPwKToDQyUKwTcZjdQXq+VjHHUoaH/rq0Oa9JgU2xbGV+QoiBCMbn4ww/M6+xoK0ODKoDyDU/teRbmko6Zt750gdmxuhz8z4Ct7PcPEAN/w61Q2tZZiww2UQ2qIq6mDRibbtSsGCoGtIBQ8A4BZB7d3Ot1ywZq6pE/OYeJNMHm
Content-Type: text/plain; charset="utf-8"
Content-ID: <3DCB70404F4EDD4D9E9CEEB514DCF228@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f8b20b6-f5b9-4ff5-6405-08d7830d0f32
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Dec 2019 16:20:41.1047
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9SOpS7PmKjS6roEVkIw42pA7w9D8mkmNWnkrp7R3bfgePiTjVDnqLmjZxvpvc3RPY4WpDA3O/jKjni0mryS3mQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4259
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhpcyBzZXJpZXMgYWRkcmVzc2VzIHRoZSBpc3N1ZSBkZXNjcmliZWQgaW4gdGhlIGNvbW1pdCBt
ZXNzYWdlIG9mIHRoZQ0KZmlyc3QgcGF0Y2g6IGxhY2sgb2Ygc3luY2hyb25pemF0aW9uIGJldHdl
ZW4gWFNLIHdha2V1cCBhbmQgZGVzdHJveWluZw0KdGhlIHJlc291cmNlcyB1c2VkIGJ5IFhTSyB3
YWtldXAuIFRoZSBpZGVhIGlzIHNpbWlsYXIgdG8NCm5hcGlfc3luY2hyb25pemUuIFRoZSBzZXJp
ZXMgY29udGFpbnMgZml4ZXMgZm9yIHRoZSBkcml2ZXJzIHRoYXQNCmltcGxlbWVudCBYU0suIEkg
aGF2ZW4ndCB0ZXN0ZWQgdGhlIGNoYW5nZXMgdG8gSW50ZWwncyBkcml2ZXJzLCBzbywNCkludGVs
IGd1eXMsIHBsZWFzZSByZXZpZXcgdGhlbS4NCg0KdjIgY2hhbmdlczoNCg0KSW5jb3Jwb3JhdGVk
IGNoYW5nZXMgc3VnZ2VzdGVkIGJ5IEJqw7ZybjoNCg0KMS4gQ2FsbCBzeW5jaHJvbml6ZV9yY3Ug
aW4gSW50ZWwgZHJpdmVycyBvbmx5IGlmIHRoZSBYRFAgcHJvZ3JhbSBpcw0KYmVpbmcgdW5sb2Fk
ZWQuDQoNCjIuIERvbid0IGZvcmdldCByY3VfcmVhZF9sb2NrIHdoZW4gd2FrZXVwIGlzIGNhbGxl
ZCBmcm9tIHhza19wb2xsLg0KDQozLiBVc2UgeHMtPnpjIGFzIHRoZSBjb25kaXRpb24gdG8gY2Fs
bCBuZG9feHNrX3dha2V1cC4NCg0KTWF4aW0gTWlraXR5YW5za2l5ICg0KToNCiAgeHNrOiBBZGQg
cmN1X3JlYWRfbG9jayBhcm91bmQgdGhlIFhTSyB3YWtldXANCiAgbmV0L21seDVlOiBGaXggY29u
Y3VycmVuY3kgaXNzdWVzIGJldHdlZW4gY29uZmlnIGZsb3cgYW5kIFhTSw0KICBuZXQvaTQwZTog
Rml4IGNvbmN1cnJlbmN5IGlzc3VlcyBiZXR3ZWVuIGNvbmZpZyBmbG93IGFuZCBYU0sNCiAgbmV0
L2l4Z2JlOiBGaXggY29uY3VycmVuY3kgaXNzdWVzIGJldHdlZW4gY29uZmlnIGZsb3cgYW5kIFhT
Sw0KDQogZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaTQwZS9pNDBlLmggICAgICAgIHwgIDIg
Ky0NCiBkcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9pNDBlL2k0MGVfbWFpbi5jICAgfCAxMCAr
KysrKystLS0NCiBkcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9pNDBlL2k0MGVfeHNrLmMgICAg
fCAgNCArKysrDQogZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaXhnYmUvaXhnYmVfbWFpbi5j
IHwgIDcgKysrKystDQogZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaXhnYmUvaXhnYmVfeHNr
LmMgIHwgIDggKysrKystLQ0KIGRyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29y
ZS9lbi5oICB8ICAyICstDQogLi4uL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW4v
eGRwLmggIHwgMjIgKysrKysrKystLS0tLS0tLS0tLQ0KIC4uLi9tZWxsYW5veC9tbHg1L2NvcmUv
ZW4veHNrL3NldHVwLmMgICAgICAgICB8ICAxICsNCiAuLi4vZXRoZXJuZXQvbWVsbGFub3gvbWx4
NS9jb3JlL2VuL3hzay90eC5jICAgfCAgMiArLQ0KIC4uLi9uZXQvZXRoZXJuZXQvbWVsbGFub3gv
bWx4NS9jb3JlL2VuX21haW4uYyB8IDE5ICstLS0tLS0tLS0tLS0tLS0NCiBuZXQveGRwL3hzay5j
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgfCAyMiArKysrKysrKysrKystLS0tLS0t
DQogMTEgZmlsZXMgY2hhbmdlZCwgNTEgaW5zZXJ0aW9ucygrKSwgNDggZGVsZXRpb25zKC0pDQoN
Ci0tIA0KMi4yMC4xDQoNCg==
