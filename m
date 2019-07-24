Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5B51740CD
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 23:24:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728206AbfGXVYt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 17:24:49 -0400
Received: from mail-eopbgr40081.outbound.protection.outlook.com ([40.107.4.81]:24655
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726622AbfGXVYs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Jul 2019 17:24:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D/vf6CeAxdvbzFuMHQ0NQfzWxeN1TKCf/AhoeQfeF6/rwGxWXjuoAXsyIJNkSmgHowoaPLy8HxJ0XMzWB96txk4CNSwiBsL+NVTC7ZTWvj1PD6iglk0Z8wxbsliPA7aTczKjOf1kLQqWCPVROAf1aGAJd3cqhRrTjwHWLT1MbRKwc63iunb6a9YHEuSOlyjXCvqL6id1nTZFFclUKhl9bxQXezR+/zyVAyaM9Pgc+IpwQ7BbkWT7fWGWKdTDoWaA70JvJcYNJgwd5jgNnVCZchclx8EGFwlQiaFKp7k/VoQqlTnK7Y98R2bptI5SP/cuTaCeqJz2r1UUzZfBlcLI9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JhteJDov5LDn5iQZT1AvzJra8/UVE2gRBsnoYWKPrPo=;
 b=GveZ3Ub1SwcODyBwZMT+6xetCgAZiCwU4tfGBY8wD9Gapx7/4J/PBOsLqZnnQwT3hnkCTBK3xCjwQUGVhc1XqgjgGNFe0OWSy6NOE4Z29Vghh+cLG01/eeg2k+9X/bkSb5BfvLW/7lUGjYsl1b1HRpoiRsNLLEEFYzUEl8vzcWf86K7bGA5DzpX8IgcDVFpQuVtf0mW4zTX0CiT8QpDk40OcZ9E63GbuF6DcJAzMJwpbr8RjDDSXbmSDjeLf/DrUOizvVuS8RyN7ZqJryJDr4yoV/8RzTm6+Z3eXlchR+GWh0wNY/EiRpvOCWusbA0M1OvZFBezGXyhKTiLvSVCkRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JhteJDov5LDn5iQZT1AvzJra8/UVE2gRBsnoYWKPrPo=;
 b=cXjnsyIGfgurzQonQWHizOMOJ/+boMclj0VQPoHa4f/ik4SR+jJCUtKLeAX9SBlJ/upoee7wlF7DeET1hch4dR8KAzvPTNFzygpguFgINwBIOgZ4zmMGblwI0NBy8dkBE2Ki0nLnES1RUqgfNqLPKnqFrlSBGB1rSFxmyCLThvE=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2856.eurprd05.prod.outlook.com (10.172.225.143) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.16; Wed, 24 Jul 2019 21:24:44 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::7148:ecd4:3a7f:f3f]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::7148:ecd4:3a7f:f3f%11]) with mapi id 15.20.2094.011; Wed, 24 Jul 2019
 21:24:44 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "nic_swsd@realtek.com" <nic_swsd@realtek.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] r8169: improve rtl_set_rx_mode
Thread-Topic: [PATCH net-next] r8169: improve rtl_set_rx_mode
Thread-Index: AQHVQmNd0SMbLR3wAUai7DMc5i8ICqbaR6MA
Date:   Wed, 24 Jul 2019 21:24:44 +0000
Message-ID: <228e1254af247a66ebbae649f5a1385b8da64597.camel@mellanox.com>
References: <d9900738-0eaf-63cc-dbbf-41ca05539794@gmail.com>
In-Reply-To: <d9900738-0eaf-63cc-dbbf-41ca05539794@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.4 (3.32.4-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e460eb8a-173b-4f94-52bd-08d7107d58fb
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2856;
x-ms-traffictypediagnostic: DB6PR0501MB2856:
x-microsoft-antispam-prvs: <DB6PR0501MB28560BC991927EBBA8EA2D56BEC60@DB6PR0501MB2856.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:635;
x-forefront-prvs: 0108A997B2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(136003)(396003)(376002)(346002)(366004)(189003)(199004)(86362001)(66066001)(229853002)(76116006)(118296001)(6506007)(26005)(91956017)(4326008)(186003)(486006)(6116002)(110136005)(102836004)(66446008)(66946007)(478600001)(66476007)(64756008)(66556008)(2906002)(76176011)(81156014)(7736002)(53936002)(6512007)(8676002)(256004)(58126008)(3846002)(316002)(5660300002)(14444005)(6436002)(14454004)(6246003)(2616005)(36756003)(11346002)(6486002)(2201001)(446003)(476003)(25786009)(2501003)(8936002)(68736007)(71200400001)(71190400001)(81166006)(99286004)(305945005);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2856;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: swq2K1MV8SH8D9z7X2Hfz4ZTen3uK01OyfGVfawFdFYV7wEdNACkWUSF+W+FfTacG8LOjdCiTYXZympv/5fS2LrHdOy/u4Irxtqx4isT+tKGSXn4AJ94tPAcszL2wMiFcn5/5e6j7z2GwepPPkq7rVrS4F9EJCh53ErWmbWn4EQUcPr/Vc/UlJkPtbK+n//IaBbQYjmaqm6cpyuST/64d2Blk/Hydn0ZgI7l8he/cojrJqw/vt2bViO/h7gQTHnyA1ENfCi7gsAqbd4CL9cKUfX9BoFlOVxO24ZOAp6GNzrfQU8RqcUtvdZRG9Wc0PCZ8FPRrzwuh+dcM9KCh9LQnPj3H5w0NUON5Rmkdy0QSwBoHUkNMu2fqbCfA2Gk59hBxrt64GjYO2stZk8LSQRt/hj9urK5V/278IvQbQcYMHE=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3DA7768DE6D40C4BBE0AA249FB1B5F12@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e460eb8a-173b-4f94-52bd-08d7107d58fb
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jul 2019 21:24:44.5227
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2856
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDE5LTA3LTI0IGF0IDIzOjA0ICswMjAwLCBIZWluZXIgS2FsbHdlaXQgd3JvdGU6
DQo+IFRoaXMgcGF0Y2ggaW1wcm92ZXMgYW5kIHNpbXBsaWZpZXMgcnRsX3NldF9yeF9tb2RlIGEg
bGl0dGxlLg0KPiBObyBmdW5jdGlvbmFsIGNoYW5nZSBpbnRlbmRlZC4NCj4gDQo+IFNpZ25lZC1v
ZmYtYnk6IEhlaW5lciBLYWxsd2VpdCA8aGthbGx3ZWl0MUBnbWFpbC5jb20+DQo+IC0tLQ0KPiAg
ZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVhbHRlay9yODE2OV9tYWluLmMgfCA1MiArKysrKysrKysr
LS0tLS0tLS0tLS0NCj4gLS0NCj4gIDEgZmlsZSBjaGFuZ2VkLCAyMiBpbnNlcnRpb25zKCspLCAz
MCBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9y
ZWFsdGVrL3I4MTY5X21haW4uYw0KPiBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L3JlYWx0ZWsvcjgx
NjlfbWFpbi5jDQo+IGluZGV4IDljNzQzZDJmYy4uYzM5ZDNhNzdjIDEwMDY0NA0KPiAtLS0gYS9k
cml2ZXJzL25ldC9ldGhlcm5ldC9yZWFsdGVrL3I4MTY5X21haW4uYw0KPiArKysgYi9kcml2ZXJz
L25ldC9ldGhlcm5ldC9yZWFsdGVrL3I4MTY5X21haW4uYw0KPiBAQCAtNjEsNyArNjEsNyBAQA0K
PiAgDQo+ICAvKiBNYXhpbXVtIG51bWJlciBvZiBtdWx0aWNhc3QgYWRkcmVzc2VzIHRvIGZpbHRl
ciAodnMuIFJ4LWFsbC0NCj4gbXVsdGljYXN0KS4NCj4gICAgIFRoZSBSVEwgY2hpcHMgdXNlIGEg
NjQgZWxlbWVudCBoYXNoIHRhYmxlIGJhc2VkIG9uIHRoZSBFdGhlcm5ldA0KPiBDUkMuICovDQo+
IC1zdGF0aWMgY29uc3QgaW50IG11bHRpY2FzdF9maWx0ZXJfbGltaXQgPSAzMjsNCj4gKyNkZWZp
bmUJTUNfRklMVEVSX0xJTUlUCTMyDQo+ICANCj4gICNkZWZpbmUgVFhfRE1BX0JVUlNUCTcJLyog
TWF4aW11bSBQQ0kgYnVyc3QsICc3JyBpcyB1bmxpbWl0ZWQgKi8NCj4gICNkZWZpbmUgSW50ZXJG
cmFtZUdhcAkweDAzCS8qIDMgbWVhbnMgSW50ZXJGcmFtZUdhcCA9DQo+IHRoZSBzaG9ydGVzdCBv
bmUgKi8NCj4gQEAgLTQxNDcsNTMgKzQxNDcsNDUgQEAgc3RhdGljIHZvaWQgcnRsODE2OV9zZXRf
bWFnaWNfcmVnKHN0cnVjdA0KPiBydGw4MTY5X3ByaXZhdGUgKnRwLCB1bnNpZ25lZCBtYWNfdmVy
c2kNCj4gIHN0YXRpYyB2b2lkIHJ0bF9zZXRfcnhfbW9kZShzdHJ1Y3QgbmV0X2RldmljZSAqZGV2
KQ0KPiAgew0KPiAgCXN0cnVjdCBydGw4MTY5X3ByaXZhdGUgKnRwID0gbmV0ZGV2X3ByaXYoZGV2
KTsNCj4gLQl1MzIgbWNfZmlsdGVyWzJdOwkvKiBNdWx0aWNhc3QgaGFzaCBmaWx0ZXIgKi8NCj4g
LQlpbnQgcnhfbW9kZTsNCj4gLQl1MzIgdG1wID0gMDsNCj4gKwkvKiBNdWx0aWNhc3QgaGFzaCBm
aWx0ZXIgKi8NCj4gKwl1MzIgbWNfZmlsdGVyWzJdID0geyAweGZmZmZmZmZmLCAweGZmZmZmZmZm
IH07DQo+ICsJdTMyIHJ4X21vZGUgPSBBY2NlcHRCcm9hZGNhc3QgfCBBY2NlcHRNeVBoeXMgfCBB
Y2NlcHRNdWx0aWNhc3Q7DQo+ICsJdTMyIHRtcDsNCj4gIA0KDQpXaGlsZSB5b3UgYXJlIGhlcmUs
IG1heWJlIGltcHJvdmUgdGhlIGRlY2xhcmF0aW9uIG9yZGVyIHdpdGggYSByZXZlcnNlZA0KeG1h
cyB0cmVlIC4uDQoNCg==
