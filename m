Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04D4B9C452
	for <lists+netdev@lfdr.de>; Sun, 25 Aug 2019 16:11:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728456AbfHYOLc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Aug 2019 10:11:32 -0400
Received: from mail-eopbgr150059.outbound.protection.outlook.com ([40.107.15.59]:56836
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728382AbfHYOLc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 25 Aug 2019 10:11:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Sj+l3nSrAHa4ak5IFyQ1sretpB8/HGHmHpIiaPt0u1LKW9NepVc9rcCLuUVGmpEHATmot4heSKYaV+nxnOxx5nn0kfbkK96JZ2DUuwSk4XUaylAMBViIFEQWmfFX/lFwn041cmeYNkW7hln/iekkTmL1bdTnUEic0nJObFp5IGToBwn3qqdTTocsMx76/QDm403Pt6IPgRwB/Lm0usWRzOUcPoE1x5gzxTGMfrNAKgQc+A9FN3OU1Ixk1EjLztQT/G92VgYhZgXk0UtZXr2LsQhe5PC89uutyIiVJQ5TvvbvAjQVceX2WLJKlm7/U1aicyR+RA8YEVSHX8Pp+pvUrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EWfov+/weAJrw1gAf5AvOFzlN4JCeufGKq3o3CtNuUg=;
 b=aPjv/INOrQVEBzd0kBpi78VfruRsGFVvh4Hl4IdvmZ18HMaNMvEKXQRCIbADhknNyHYVb3SXkEzHjNfnVZJkc0LoiGdEEXRZMXEWnQwaYOmOrEMOKlKxrIuPP2VM6NyekBSlcmZu+Ms691h0mEtBw58YjAkoECHPjZJIhw0U1ubTYjE6zd1VVrGjzUpto1ESw43BuseC6C0B4LNvmykgzpWPBjhGNJbuNHEmvxYLo/X0tDsYrhjix77bSEPxUa2eBckNMAQFuL5Hlv2yGjltjT58IcEnV0WTWKWrk3HODRiAmxWQqHYlir+tlkTrgKSL5qFSUEaCsY/mUaW9stRM8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EWfov+/weAJrw1gAf5AvOFzlN4JCeufGKq3o3CtNuUg=;
 b=IcWTBJpPEENTZI0aNJQ2N+roqTzNSpezzVeaspqE4lV61qFlQp3Qsv9SLmZrZ4S+qEZkIr3chGmzDbFh6ZTxgkrkySN2eXK2i4mayMTOWgv30WbpnJcJfvrc40ov8TI4in4nkgm8u+al8UhPJSMEybY9CYX6VRTKSU2Nq7Pmg38=
Received: from AM4PR05MB3411.eurprd05.prod.outlook.com (10.171.190.30) by
 AM4PR05MB3330.eurprd05.prod.outlook.com (10.171.191.28) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.18; Sun, 25 Aug 2019 14:11:25 +0000
Received: from AM4PR05MB3411.eurprd05.prod.outlook.com
 ([fe80::d027:14a2:95db:6f1f]) by AM4PR05MB3411.eurprd05.prod.outlook.com
 ([fe80::d027:14a2:95db:6f1f%7]) with mapi id 15.20.2178.023; Sun, 25 Aug 2019
 14:11:25 +0000
From:   Paul Blakey <paulb@mellanox.com>
To:     David Miller <davem@davemloft.net>
CC:     "pshelar@ovn.org" <pshelar@ovn.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "jpettit@nicira.com" <jpettit@nicira.com>,
        "simon.horman@netronome.com" <simon.horman@netronome.com>,
        "marcelo.leitner@gmail.com" <marcelo.leitner@gmail.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>,
        Yossi Kuperman <yossiku@mellanox.com>,
        Rony Efraim <ronye@mellanox.com>, Oz Shlomo <ozsh@mellanox.com>
Subject: Re: [PATCH net-next v2] net: openvswitch: Set OvS recirc_id from tc
 chain index
Thread-Topic: [PATCH net-next v2] net: openvswitch: Set OvS recirc_id from tc
 chain index
Thread-Index: AQHVV1NT8M5f8wQXwEWnAba2NRJFOacGjM+AgAVie4A=
Date:   Sun, 25 Aug 2019 14:11:24 +0000
Message-ID: <e3b95525-b72e-00f2-8cda-eb5a419901ad@mellanox.com>
References: <1566304251-15795-1-git-send-email-paulb@mellanox.com>
 <20190821.205735.2069656948701231785.davem@davemloft.net>
In-Reply-To: <20190821.205735.2069656948701231785.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR0P264CA0037.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1::25) To AM4PR05MB3411.eurprd05.prod.outlook.com
 (2603:10a6:205:b::30)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=paulb@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 57b3c07b-82f6-4a39-ed46-08d729661d23
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM4PR05MB3330;
x-ms-traffictypediagnostic: AM4PR05MB3330:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM4PR05MB33304B6C4EDD79E3B7F13BA6CFA60@AM4PR05MB3330.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 01401330D1
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(346002)(39860400002)(136003)(376002)(396003)(199004)(189003)(229853002)(6916009)(6486002)(53936002)(11346002)(476003)(99286004)(446003)(26005)(102836004)(256004)(31686004)(305945005)(14444005)(7736002)(36756003)(14454004)(5660300002)(107886003)(81156014)(81166006)(71190400001)(71200400001)(6246003)(486006)(478600001)(54906003)(8676002)(8936002)(66066001)(316002)(386003)(4326008)(53546011)(6506007)(86362001)(66476007)(66556008)(52116002)(76176011)(66946007)(2906002)(64756008)(2616005)(6436002)(31696002)(3846002)(6512007)(6116002)(186003)(25786009)(66446008);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR05MB3330;H:AM4PR05MB3411.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 2J3E9Qvhg63tJacB6XniFBq5Hpj9Pdhrb0iwtyxP6AdNRXutBTThA8iLWWWIM5KbR6Jc1efRjIrP9HKyqfkS4HFFc18gdjEylTyEchxFl+y6wJwz15iLXKl336Nuxmb+tp+uG4DcWafEmbkMDSnD8d/d0zS3THPz2ch9SsxrNgAng5IoKC24mhXDanTuXoQBKRgAo4+KD347DzsA4UuFzYUmGsiD1fLtmPIaOiqnsZZdl7irEEgr1tr4UbPUnW589WPD9Fa7d92Mm0KqOwaO0yZhWk7YcELti9RKfE+OnIg9SzpXugtoDJEAM3M1pC1R/OTDrrYmNg9b8LBB0ec0REzUV25rFvj7FRL8n6xkfxUntU9GrOmvnJ1VKx4ZiUDCvZPmePNcd82xNyOWpgwMMyBWP/oeG4KyC6FRM6xkl5I=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C03E7E205892A54E8090346204D3E614@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 57b3c07b-82f6-4a39-ed46-08d729661d23
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Aug 2019 14:11:24.9930
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PNQduiSlX8cF3t/lWNk9q5DePSsJ8qDebldw7a+x3q3sDlwTllcB14FyHgxszo7/slrjpqpTdCMagVcWH/dJww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR05MB3330
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gOC8yMi8yMDE5IDY6NTcgQU0sIERhdmlkIE1pbGxlciB3cm90ZToNCg0KPiBGcm9tOiBQYXVs
IEJsYWtleSA8cGF1bGJAbWVsbGFub3guY29tPg0KPiBEYXRlOiBUdWUsIDIwIEF1ZyAyMDE5IDE1
OjMwOjUxICswMzAwDQo+DQo+PiBAQCAtNDA1MCw2ICs0MDYwLDkgQEAgZW51bSBza2JfZXh0X2lk
IHsNCj4+ICAgI2lmZGVmIENPTkZJR19YRlJNDQo+PiAgIAlTS0JfRVhUX1NFQ19QQVRILA0KPj4g
ICAjZW5kaWYNCj4+ICsjaWYgSVNfRU5BQkxFRChDT05GSUdfTkVUX1RDX1NLQl9FWFQpDQo+PiAr
CVRDX1NLQl9FWFQsDQo+PiArI2VuZGlmDQo+PiAgIAlTS0JfRVhUX05VTSwgLyogbXVzdCBiZSBs
YXN0ICovDQo+PiAgIH07DQo+IFNvcnJ5LCBuby4NCj4NCj4gVGhlIFNLQiBleHRlbnNpb25zIGFy
ZSBub3QgYSBkdW1waW5nIGdyb3VuZCBmb3IgcGVvcGxlIHRvIHVzZSB3aGVuIHRoZXkgY2FuJ3QN
Cj4gZmlndXJlIG91dCBhbm90aGVyIG1vcmUgcmVhc29uYWJsZSBwbGFjZSB0byBwdXQgdGhlaXIg
dmFsdWVzLiAgVHJ5IHRvIHVzZQ0KPiB0aGUgbm9ybWFsIGNiW10sIGFuZCBpZiB5b3UgY2FuJ3Qg
eW91IG11c3QgZXhwbGFpbiBpbiBleGhhdXN0aXZlIGRldGFpbA0KPiB3aHkgeW91IGNhbm5vdCBp
biBhbnkgd2F5IHdoYXRzb2V2ZXIgbWFrZSB0aGF0IHdvcmsuDQo+DQo+IEFnYWluLCBTS0IgZXh0
ZW5zaW9ucyBhcmUgbm90IGEgZHVtcGluZyBncm91bmQuDQpIaSwNClRoZSBnZW5lcmFsIGNvbnRl
eHQgb2YgdGhpcyBza2IgZXh0ZW5zaW9uIHBhdGNoIGlzIGhhcmR3YXJlIG9mZmxvYWQgb2YgDQpt
dWx0aSBjaGFpbiBydWxlcy4NClRoaXMgcGF0Y2ggc2hvd3Mgb25seSBvbmUgdXNhZ2Ugb2YgdGhp
cyBleHRlbnNpb24gd2hpY2ggaXMgYnkgdGMgLT4gT3ZTIA0KbWlzcyBwYXRoLg0KQnV0IHdlIGFs
c28gcGxhbiB0byByZXVzZSB0aGlzIGV4dGVuc2lvbiB0byBwYXNzIGluZm9ybWF0aW9uIGZyb20g
DQpIVy9Ecml2ZXIgLT4gdGMgbWlzcyBwYXRoLg0KDQpJbiB0YyBtdWx0aSBjaGFpbiBydWxlcyBz
Y2VuYXJpb3MsIHNvbWUgb2YgdGhlIHJ1bGVzIG1pZ2h0IGJlIG9mZmxvYWRlZA0KYW5kIHNvbWUg
bm90IChlLmcgc2tpcF9odywgdW5zdXBwb3J0ZWQgcnVsZXMgYnkgSFcsIHZ4bGFuIGVuY2Fwc3Vs
YXRpb24sIA0Kb2ZmbG9hZCBvcmRlciwgZXRjKS4NClRoZXJlZm9yZSwgSFcgY2FuIG1pc3MgYXQg
YW55IHBvaW50IG9mIHRoZSBwcm9jZXNzaW5nIGNoYWluLg0KU1cgd2lsbCBuZWVkIHRvIGNvbnRp
bnVlIHByb2Nlc3NpbmcgaW4gY29ycmVjdCB0YyBjaGFpbiB3aGVyZSB0aGUgSFcgDQpsZWZ0IG9m
ZiwgYXMgSFcgbWlnaHQgaGF2ZSBtb2RpZmllZCB0aGUgcGFja2V0IGFuZCB1cGRhdGVkIHN0YXRz
IGZvciBpdC4NClRoaXMgc2NlbmFyaW8gY2FuIHJldXNlIHRoaXMgdGMgU0tCIGV4dGVuc2lvbiB0
byByZXN0b3JlIHRoZSB0YyBjaGFpbi4NCg0KU2tiIGNvbnRyb2wgYmxvY2sgYWN0cyBhIHNjcmF0
Y2hwYWQgYXJlYSBmb3Igc3RvcmluZyB0ZW1wb3JhcnkgDQppbmZvcm1hdGlvbiBhbmQgaXNuJ3Qg
c3VwcG9zZQ0KdG8gYmUgdXNlZCB0byBwYXNzIGFyb3VuZCBpbmZvcm1hdGlvbiBiZXR3ZWVuIGRp
ZmZlcmVudCBsYXllcnMgb2YgDQpwcm9jZXNzaW5nLg0KSFcvRHJpdmVyIC0+IHRjIC0gPk92U8Kg
IGFyZSBkaWZmZXJlbnQgbGF5ZXJzLCBhbmQgbm90IG5lY2Vzc2FyaWx5IA0KcHJvY2Vzc2luZyB0
aGUgcGFja2V0IG9uZSBhZnRlciBhbm90aGVyLg0KVGhlcmUgY2FuIGJlIGJyaWRnZXMsIHR1bm5l
bCBkZXZpY2VzLCBWTEFOIGRldmljZXMsIE5ldGZpbHRlciANCihDb25udHJhY2spIGFuZCBhIGhv
c3Qgb2Ygb3RoZXIgZW50aXRpZXMgcHJvY2Vzc2luZyB0aGUgcGFja2V0IGluIGJldHdlZW4NCnNv
IHdlIGNhbid0IGd1YXJhbnRlZSB0aGUgY29udHJvbCBibG9jayBpbnRlZ3JpdHkgYmV0d2VlbiB0
aGlzIG1haW4gDQpwcm9jZXNzaW5nIGVudGl0aWVzIChIVy9Ecml2ZXIsIFRjLCBPdnMpLg0KU28g
aWYgd2UnbGwgdXNlIHRoZSBjb250cm9sIGJsb2NrLCBpdCB3aWxsIHJlc3RyaWN0IHN1Y2ggdXNl
IGNhc2VzLg0KRm9yIGV4YW1wbGUsIHRoZSBuYXBpIEFQSSB3aGljaCB3ZSB1c2UsIHVzZXMgdGhl
IGNvbnRyb2wgYmxvY2sgYW5kIGNvbWVzIA0KcmlnaHQgYWZ0ZXIgb3VyIGRyaXZlciBsYXllci4N
ClRoaXMgd2lsbCBvdmVyd3JpdGUgYW55IHVzYWdlIG9mIENCIGJ5IHVzLg0KDQoNClRoYW5rcywN
ClBhdWwgQi4NCg0KDQoNCg==
