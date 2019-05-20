Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21D2F242CD
	for <lists+netdev@lfdr.de>; Mon, 20 May 2019 23:24:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726859AbfETVYA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 May 2019 17:24:00 -0400
Received: from mail-eopbgr80040.outbound.protection.outlook.com ([40.107.8.40]:44326
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725978AbfETVYA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 May 2019 17:24:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V4Bzgh6jFP4BozxOfe5GzcUSkK2NodxkXKO9fhMxSMU=;
 b=Fm/Wm/PaV0z19/ODvTNOS9IiEMtVVpovy3xALexBKv44IN24wNlp4omPIAUVJljBL4ZSL+g7WfmIu6d+sokUpSzyF07vEaEfKoFydQvRGwUBrWYvF8fhYOUOKmRp5hHEBtvmM11Dsn6b5QnveX+xX8jXE2XgWTMFjTQ6gPJfDJM=
Received: from DB8PR05MB5898.eurprd05.prod.outlook.com (20.179.9.32) by
 DB8PR05MB6011.eurprd05.prod.outlook.com (20.179.11.203) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1900.16; Mon, 20 May 2019 21:23:56 +0000
Received: from DB8PR05MB5898.eurprd05.prod.outlook.com
 ([fe80::7159:5f3a:906:6aab]) by DB8PR05MB5898.eurprd05.prod.outlook.com
 ([fe80::7159:5f3a:906:6aab%7]) with mapi id 15.20.1900.020; Mon, 20 May 2019
 21:23:56 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Gavi Teitz <gavi@mellanox.com>,
        "wenxu@ucloud.cn" <wenxu@ucloud.cn>, Roi Dayan <roid@mellanox.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        Jianbo Liu <jianbol@mellanox.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH] net/mlx5e: restrict the real_dev of vlan device is the
 same as uplink device
Thread-Topic: [PATCH] net/mlx5e: restrict the real_dev of vlan device is the
 same as uplink device
Thread-Index: AQHVCwCZ1GHvPCVNAk+Rb9K0gcDQ16ZvyNyAgABvmYCAAc9+gIAChrIA
Date:   Mon, 20 May 2019 21:23:55 +0000
Message-ID: <31ed08fab7192eb4c2703430cd7650478b3759d5.camel@mellanox.com>
References: <1557912345-14649-1-git-send-email-wenxu@ucloud.cn>
         <32affe9e97f26ff1c7b5993255a6783533fe6bff.camel@mellanox.com>
         <e22c5097-028e-2e23-b1e9-0d7098802d1f@ucloud.cn>
         <a5ee3798-1cd8-198d-ec85-da11444770f8@mellanox.com>
In-Reply-To: <a5ee3798-1cd8-198d-ec85-da11444770f8@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.2 (3.32.2-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5a945cc3-03d4-43a0-6e3c-08d6dd697729
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:DB8PR05MB6011;
x-ms-traffictypediagnostic: DB8PR05MB6011:
x-microsoft-antispam-prvs: <DB8PR05MB6011F3E18B316D642F3165DDBE060@DB8PR05MB6011.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 004395A01C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(39860400002)(376002)(346002)(366004)(136003)(199004)(189003)(3846002)(53936002)(6116002)(76176011)(478600001)(102836004)(6506007)(14454004)(53546011)(305945005)(6436002)(81166006)(14444005)(256004)(7736002)(8676002)(71200400001)(71190400001)(99286004)(81156014)(8936002)(66476007)(6636002)(118296001)(91956017)(76116006)(2906002)(66446008)(64756008)(66946007)(66556008)(73956011)(6512007)(66066001)(58126008)(68736007)(26005)(186003)(229853002)(25786009)(2501003)(5660300002)(6486002)(6246003)(4326008)(110136005)(36756003)(11346002)(446003)(2616005)(86362001)(486006)(316002)(476003);DIR:OUT;SFP:1101;SCL:1;SRVR:DB8PR05MB6011;H:DB8PR05MB5898.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: TFMmewKL/DpfoE781HR1pS6R7A7dwXaZUKegLbbVWTVExLc9Nd/DLQprJDHazS//vdvPHOAJ2+142K43kJdZDBLjlhdvpAVX0aDrkSp83hOFrtL4Z3xCl8kSKwK/Z3gGoOzVJ7+DVdaQDASxkGptNcVymXmmH1IlSB2nMwlPU6IqocVxu2ullpy/LvVLmFq+DQUv4j/ZSDuJrviRskP96r8Ja5H3Ynxbo5gkPZTRDXTCLOqwMcd908mx06XqHave0K2v/pIeKq3hsBuiTRoXQILEmw7usFcCfYeTn/J1pINCIrjbzjZQvhGVvfh/+3tVmjW1Yx90cVxptWaU0wvTe5OWQN9mZwJ8EB+E5BA7+jf3ebK/4PFOs3OkEX0H31ZYJDjM8omyzHmRMZ02lWVQRpqOmgBJmlFI+wrOP9s2eSQ=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5D9CB560F68A7B489BEC0AD295133443@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a945cc3-03d4-43a0-6e3c-08d6dd697729
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 May 2019 21:23:55.8743
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR05MB6011
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gU3VuLCAyMDE5LTA1LTE5IGF0IDA2OjQ5ICswMDAwLCBSb2kgRGF5YW4gd3JvdGU6DQo+IA0K
PiBPbiAxOC8wNS8yMDE5IDA2OjEwLCB3ZW54dSB3cm90ZToNCj4gPiBUaGVyZSB3aWxsIGJlIG11
bHRpcGxlIHZsYW4gZGV2aWNlIHdoaWNoIG1heWJlIG5vdCBiZWxvbmcgdG8gdGhlDQo+ID4gdXBs
aW5rIHJlcCBkZXZpY2UsIHNvIHdlbiBjYW4gbGltaXQgaXQNCj4gPiANCj4gPiDlnKggMjAxOS81
LzE4IDQ6MzAsIFNhZWVkIE1haGFtZWVkIOWGmemBkzoNCj4gPiA+IE9uIFdlZCwgMjAxOS0wNS0x
NSBhdCAxNzoyNSArMDgwMCwgd2VueHVAdWNsb3VkLmNuIHdyb3RlOg0KPiA+ID4gPiBGcm9tOiB3
ZW54dSA8d2VueHVAdWNsb3VkLmNuPg0KPiA+ID4gPiANCj4gPiA+ID4gV2hlbiByZWdpc3RlciBp
bmRyIGJsb2NrIGZvciB2bGFuIGRldmljZSwgaXQgc2hvdWxkIGNoZWNrIHRoZQ0KPiA+ID4gPiBy
ZWFsX2Rldg0KPiA+ID4gPiBvZiB2bGFuIGRldmljZSBpcyBzYW1lIGFzIHVwbGluayBkZXZpY2Uu
IE9yIGl0IHdpbGwgc2V0IG9mZmxvYWQNCj4gPiA+ID4gcnVsZQ0KPiA+ID4gPiB0byBtbHg1ZSB3
aGljaCB3aWxsIG5ldmVyIGhpdC4NCj4gPiA+ID4gDQo+ID4gPiBJIHdvdWxkIGltcHJvdmUgdGhl
IGNvbW1pdCBtZXNzYWdlLCBpdCBpcyBub3QgcmVhbGx5IGNsZWFyIHRvIG1lDQo+ID4gPiB3aGF0
DQo+ID4gPiBpcyBnb2luZyBvbiBoZXJlLg0KPiA+ID4gDQo+ID4gPiBBbnl3YXkgUm9pIGFuZCB0
ZWFtLCBjYW4geW91IHBsZWFzZSBwcm92aWRlIGZlZWRiYWNrIC4uDQo+ID4gPiANCj4gPiA+ID4g
U2lnbmVkLW9mZi1ieTogd2VueHUgPHdlbnh1QHVjbG91ZC5jbj4NCj4gPiA+ID4gLS0tDQo+ID4g
PiA+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW5fcmVwLmMgfCAy
ICstDQo+ID4gPiA+ICAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDEgZGVsZXRpb24o
LSkNCj4gPiA+ID4gDQo+ID4gPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9t
ZWxsYW5veC9tbHg1L2NvcmUvZW5fcmVwLmMNCj4gPiA+ID4gYi9kcml2ZXJzL25ldC9ldGhlcm5l
dC9tZWxsYW5veC9tbHg1L2NvcmUvZW5fcmVwLmMNCj4gPiA+ID4gaW5kZXggOTFlMjRmMS4uYTM5
ZmRhYyAxMDA2NDQNCj4gPiA+ID4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gv
bWx4NS9jb3JlL2VuX3JlcC5jDQo+ID4gPiA+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21l
bGxhbm94L21seDUvY29yZS9lbl9yZXAuYw0KPiA+ID4gPiBAQCAtNzk2LDcgKzc5Niw3IEBAIHN0
YXRpYyBpbnQNCj4gPiA+ID4gbWx4NWVfbmljX3JlcF9uZXRkZXZpY2VfZXZlbnQoc3RydWN0DQo+
ID4gPiA+IG5vdGlmaWVyX2Jsb2NrICpuYiwNCj4gPiA+ID4gIAlzdHJ1Y3QgbmV0X2RldmljZSAq
bmV0ZGV2ID0NCj4gPiA+ID4gbmV0ZGV2X25vdGlmaWVyX2luZm9fdG9fZGV2KHB0cik7DQo+ID4g
PiA+ICANCj4gPiA+ID4gIAlpZiAoIW1seDVlX3RjX3R1bl9kZXZpY2VfdG9fb2ZmbG9hZChwcml2
LCBuZXRkZXYpICYmDQo+ID4gPiA+IC0JICAgICFpc192bGFuX2RldihuZXRkZXYpKQ0KPiA+ID4g
PiArCSAgICAhKGlzX3ZsYW5fZGV2KG5ldGRldikgJiYgdmxhbl9kZXZfcmVhbF9kZXYobmV0ZGV2
KQ0KPiA+ID4gPiA9PQ0KPiA+ID4gPiBycHJpdi0+bmV0ZGV2KSkNCj4gPiA+ID4gIAkJcmV0dXJu
IE5PVElGWV9PSzsNCj4gPiA+ID4gIA0KPiA+ID4gPiAgCXN3aXRjaCAoZXZlbnQpIHsNCj4gDQo+
IHRoYW5rcyENCj4gDQo+IHlvdSBzaG91bGQgYWRkIGEgZml4ZXMgbGluZQ0KPiBGaXhlczogMzVh
NjA1ZGIxNjhjICgibmV0L21seDVlOiBPZmZsb2FkIFRDIGUtc3dpdGNoIHJ1bGVzIHdpdGgNCj4g
aW5ncmVzcyBWTEFOIGRldmljZSIpDQo+IA0KPiBiZXNpZGUgdGhhdCBhbGwgZ29vZC4NCj4gUmV2
aWV3ZWQtYnk6IFJvaSBEYXlhbiA8cm9pZEBtZWxsYW5veC5jb20+DQo+IA0KPiANCg0KQXBwbGll
ZCB0byBuZXQtbWx4NSBhbmQgYWRkZWQgdGhlIEZpeGVzIGxpbmUuDQpUaGFua3MgIQ0K
