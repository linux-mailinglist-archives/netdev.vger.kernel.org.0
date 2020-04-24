Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3F371B7F56
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 21:49:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729280AbgDXTsv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 15:48:51 -0400
Received: from mail-eopbgr70075.outbound.protection.outlook.com ([40.107.7.75]:1413
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726793AbgDXTsv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Apr 2020 15:48:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DGpc1AUgTZmZDU1MdS//WqRCn512HSEkeFfNmWKJoka8sifIp7021sx6kVmZts4g2Xny6FqX8Sl1kF3eC/RbxHsrv1IB6QaNv/NDGR38VvwpErIVSng4MbUDamLwPChD0oY1Pvyxqkcm9/Cgfv1Vjf7ivs/edoQ7KUtGHHEcp+8hDltW5TJDua4LNaghRX6hPmDLWSAqL4GyqaXwiPvs3FAIIVcVcF7GnsNzfTWltRODfXb3XENlkxr4qQ4TphAyiJCTVCioxKzEw/5GKOYVp5yTF0Kn5WevLnWxKSThnvi06brUXVHi0A59eXfIfbwuA21pnWHxEtNPUeTEef3hLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r1MJmJDPbP7rEyP1uxRiWx040ZyqN05SlFWv0N9jzBI=;
 b=SsT4jfvUIeCqlXbkh6rdha2TS8hxcyafJ+cj9GUOTvWBopMrnwAoh3C+7RacoYQUI5sGzHzPyMs5Elf57+ClF8cErGhk94RZaQHDxZlKVJgP4/N/rteOsTD4ST+pmoE8wMk0YpjScSLHONZYI4pdS+NfZ9xrx0Pv9lrYSO+me1846OvzdFX3QSWIxXDqgNgkGSUPSRa9zbLHFGqdM+aLPkGkhNtyxVbaQapSBMV9wb6UsMgH08m3kO2Kcxk25x44zyOE/LYCPE9y06H3uMWGsQkY9jPcv1gvXSJUjzYkki5QJrJ5CyYxGMYrHV1mcdJP7ePne04dwHqFPk7t290tng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r1MJmJDPbP7rEyP1uxRiWx040ZyqN05SlFWv0N9jzBI=;
 b=jreYJ2lMZwgt4ShF97/hN6+k3NJuAoCo2ZMawiEhtps7S8rQRQn7nJQJNp3EaersxvfU1v0h0MTexf4k1W3hRVJKiXLclju393a3CMOBnxGY3vw/v3ZDK4anjUoiYV9SxA2etTDjspvx0PPjwt2avJj8+ZmAOVgrWiTNM9SodhY=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB5072.eurprd05.prod.outlook.com (2603:10a6:803:61::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.29; Fri, 24 Apr
 2020 19:48:45 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19%7]) with mapi id 15.20.2937.020; Fri, 24 Apr 2020
 19:48:45 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "zou_wei@huawei.com" <zou_wei@huawei.com>,
        Tariq Toukan <tariqt@mellanox.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -next] net/mlx4_core: Add missing iounmap() in error path
Thread-Topic: [PATCH -next] net/mlx4_core: Add missing iounmap() in error path
Thread-Index: AQHWGj7ghy4QI43+DEKPe4gxkW8riqiIrjgA
Date:   Fri, 24 Apr 2020 19:48:45 +0000
Message-ID: <ad1635d845bb364f02010f61ab1240860df14f9a.camel@mellanox.com>
References: <1587736394-111502-1-git-send-email-zou_wei@huawei.com>
In-Reply-To: <1587736394-111502-1-git-send-email-zou_wei@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.34.4 (3.34.4-1.fc31) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [73.15.39.150]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: aab03938-361a-4e94-04b6-08d7e8887fb4
x-ms-traffictypediagnostic: VI1PR05MB5072:|VI1PR05MB5072:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB50724140C2DAB2535F9FBEE4BED00@VI1PR05MB5072.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2331;
x-forefront-prvs: 03838E948C
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(39860400002)(136003)(396003)(376002)(366004)(346002)(6506007)(26005)(4744005)(2616005)(8936002)(8676002)(66446008)(316002)(71200400001)(6636002)(36756003)(91956017)(66946007)(76116006)(66556008)(81156014)(478600001)(66476007)(64756008)(6512007)(5660300002)(110136005)(4326008)(54906003)(186003)(2906002)(6486002)(86362001);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1/WzL+r4zjiAXG2DT5za2G2H/zleuqdpKTbUVTgWt88GMiv9jKTNZmp4rFW1Snt7lBfmmKSK7/pJKS2VVVxmHYBazIzG9OO316gYkfru4SXkw2FGL1omUOlVoO+j9tbpPtmnkDITUYAntaIE/qQRCZSpgz+1uzvQXbu0Q98k3V9hNhwFDdE7EUyACMvwd88vk6YyfrgussTxzrsliXsSZ44V95HpQzbiFUN+0rf1VKbdz4mYiZ3pTJ1+TL2o+eX+Kh3HKbuj/kWsjfl5DGTKb9jJh6ymTt/LSTanOnNBE6SLk+5Z2tt05vnh8xLBIwsbaTcRn3pvp41ZetEBe0+YPoJh9Gw/FTeKXXPmTu/hj2KcknBZ7nSV3c/zMFRuBO4fpMiR9DPSCoTDmlQbOYoFX/eUxfyWdZhSvt82cQpjGhgZW0nW96yYqxkvNwYNAd0A
x-ms-exchange-antispam-messagedata: J9+tQWuisKTthmXMSWc5Ij/EVI/f9rUvyPxiyqMw1iusGyYd0xZH7CDg7EHGprpHsUMCvq1xXYrXGMjISJmYh+YOzwzdOoIBQ0YxnskcHkAxTs8wEx3Gw7+rsBU08f2qMAT6DDRD7kXkfi6HnodWzA==
Content-Type: text/plain; charset="utf-8"
Content-ID: <89B94B14B85D474298157E9CA5DDE8AB@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aab03938-361a-4e94-04b6-08d7e8887fb4
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Apr 2020 19:48:45.0825
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: U0VHWkpndXwKGGzhm4z61ivAXaJ2yzMas3Mq7DKkKunBnc5RmRxVjqiJei9wsHJqCfy2Ui8dWkX5LQCXFazxtA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5072
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDIwLTA0LTI0IGF0IDIxOjUzICswODAwLCBab3UgV2VpIHdyb3RlOg0KPiBUaGlz
IGZpeGVzIHRoZSBmb2xsb3dpbmcgY29jY2ljaGVjayB3YXJuaW5nOg0KPiANCj4gZHJpdmVycy9u
ZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NC9jcmR1bXAuYzoyMDA6Mi04OiBFUlJPUjogbWlzc2lu
Zw0KPiBpb3VubWFwOw0KPiBpb3JlbWFwIG9uIGxpbmUgMTkwIGFuZCBleGVjdXRpb24gdmlhIGNv
bmRpdGlvbmFsIG9uIGxpbmUgMTk4DQo+IA0KPiBGaXhlczogN2VmMTlkM2IxZDVlICgiZGV2bGlu
azogcmVwb3J0IGVycm9yIG9uY2UgVTMyX01BWCBzbmFwc2hvdCBpZHMNCj4gaGF2ZSBiZWVuIHVz
ZWQiKQ0KPiBSZXBvcnRlZC1ieTogSHVsayBSb2JvdCA8aHVsa2NpQGh1YXdlaS5jb20+DQo+IFNp
Z25lZC1vZmYtYnk6IFpvdSBXZWkgPHpvdV93ZWlAaHVhd2VpLmNvbT4NCj4gLS0tDQo+ICBkcml2
ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg0L2NyZHVtcC5jIHwgMSArDQo+ICAxIGZpbGUg
Y2hhbmdlZCwgMSBpbnNlcnRpb24oKykNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9l
dGhlcm5ldC9tZWxsYW5veC9tbHg0L2NyZHVtcC5jDQo+IGIvZHJpdmVycy9uZXQvZXRoZXJuZXQv
bWVsbGFub3gvbWx4NC9jcmR1bXAuYw0KPiBpbmRleCA3M2VhZTgwZS4uYWM1NDY4YiAxMDA2NDQN
Cj4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NC9jcmR1bXAuYw0KPiAr
KysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg0L2NyZHVtcC5jDQo+IEBAIC0x
OTcsNiArMTk3LDcgQEAgaW50IG1seDRfY3JkdW1wX2NvbGxlY3Qoc3RydWN0IG1seDRfZGV2ICpk
ZXYpDQo+ICAJZXJyID0gZGV2bGlua19yZWdpb25fc25hcHNob3RfaWRfZ2V0KGRldmxpbmssICZp
ZCk7DQo+ICAJaWYgKGVycikgew0KPiAgCQltbHg0X2VycihkZXYsICJjcmR1bXA6IGRldmxpbmsg
Z2V0IHNuYXBzaG90IGlkIGVycg0KPiAlZFxuIiwgZXJyKTsNCj4gKwkJaW91bm1hcChjcl9zcGFj
ZSk7DQo+ICAJCXJldHVybiBlcnI7DQo+ICAJfQ0KPiAgDQoNClJldmlld2VkLWJ5OiBTYWVlZCBN
YWhhbWVlZCA8c2FlZWRtQG1lbGxhbm94LmNvbT4NCg0K
