Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BBDFF1654E2
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 03:13:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727934AbgBTCNQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 21:13:16 -0500
Received: from mail-eopbgr60087.outbound.protection.outlook.com ([40.107.6.87]:54274
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727578AbgBTCNP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Feb 2020 21:13:15 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K2uG3M1pPiZtuLB5XMgs9U9AD0a4JuIrZ1UqdWiTuGoK2evnjqnmDOoAoJq1QKsCQCA+4gxw1srbL4owKhBLo+dHvnI0p6D0JBNCJfnbz1UNefF5eTfb8hJkNr9AlkNPy6VT02D1GLTKbMw6Xo1gpqqWTfKtv6/x8eJ3MG6jBfA+BCITgpSEHaWGYbGffScjikG9Oilp+4RUoxXuPDLrnO3Cr/faq+caLgYIx5XDBaWRRPzP5TNIPmn5gTJPgtmbeilFV84a4sFAgHA/pwDDv4aOLwzuqJIYpUFCxd/AeJRWDwXcsrD/wVMBqk0qD5dMK3ZBcxbKFPCQdpBMyUQwDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mG2748XmA7ttyFydoHJoNkGZAqF0mJ/DcEr4SxtIgiE=;
 b=RI/CDurnSVjYWPk2B3EWqTTXLcM7raguv0ID18xKC8PoUMeKCl0G4v+QwJ2eXoFPanBnYuLGS55hpgczjJjLhu513HlxXyrL4rOimE73NuPVOQEFf6RjsWnWnrWEnfYsa1VK8dTXcDLLC8LrTblrCEWLh3J/LShjIQ3FccDpM6+YkfPE9LPaZR4WxXYLPZ1WRu1ZnpH9CpJNgxc90lOrs7gQfuYyg9dyEcbLsH1TUCJjKFVb4P8hqT8AQIZZwxJN4jirh8MeO0w+IpLdGHPtun7DlwpTSxSZkQC7DEgb2XXQhignyJXDFjXnzULVQYNMHOTeemNyiKaUhgKFA9KKyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mG2748XmA7ttyFydoHJoNkGZAqF0mJ/DcEr4SxtIgiE=;
 b=bM1h2tY7MhPTpwmN73LDQEMbPNKj3gocVAAY7Lh/SeCBvE9jdkMaPpdvgoXhXsbHERwsoRoQJkiWuBj+DJ72M/qMHrMX/EdYdxkDw9jhdk32X7zCow2VL8/NsiPetokTfrlqTJnxFddHZT17b3H3lbZ4yU1hOXCtkgW7xdFqRLY=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4270.eurprd05.prod.outlook.com (52.133.12.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2729.22; Thu, 20 Feb 2020 02:13:08 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2729.028; Thu, 20 Feb 2020
 02:13:07 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "davem@davemloft.net" <davem@davemloft.net>
CC:     Jiri Pirko <jiri@mellanox.com>,
        "kuba@kernel.org" <kuba@kernel.org>, Roi Dayan <roid@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Paul Blakey <paulb@mellanox.com>
Subject: Re: [PATCH net-next v3 00/16] Handle multi chain hardware misses
Thread-Topic: [PATCH net-next v3 00/16] Handle multi chain hardware misses
Thread-Index: AQHV5LAnyud6kwbVa0i6QDoYOjJZc6gh0z6AgAFoYICAACGQAA==
Date:   Thu, 20 Feb 2020 02:13:07 +0000
Message-ID: <fdb4fd7bf8f3f93ee62b7949d185addda6aa6cc0.camel@mellanox.com>
References: <1581847296-19194-1-git-send-email-paulb@mellanox.com>
         <41b34b364a2656a6f3e37ba256161de477e7881d.camel@mellanox.com>
         <20200219.161255.733098365672070487.davem@davemloft.net>
In-Reply-To: <20200219.161255.733098365672070487.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.34.3 (3.34.3-1.fc31) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [73.15.39.150]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: b5e0c232-86ea-4190-31fa-08d7b5aa6d3e
x-ms-traffictypediagnostic: VI1PR05MB4270:|VI1PR05MB4270:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB427075479029762C02D90002BE130@VI1PR05MB4270.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 031996B7EF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(396003)(39860400002)(366004)(346002)(136003)(199004)(189003)(6916009)(71200400001)(186003)(5660300002)(4326008)(6486002)(478600001)(86362001)(36756003)(6506007)(316002)(2616005)(966005)(2906002)(107886003)(76116006)(81156014)(26005)(66556008)(66476007)(64756008)(66446008)(54906003)(91956017)(81166006)(6512007)(66946007)(8936002)(8676002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4270;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yi2dF/avtbAgeSog3Qa5IeKmTks9/iAX6f02ysJZ1WFHiX77ZRfYtbDKwSjIsy6/BK/qu2LGwpsCmYxOg2laEGU0I0hgMsmMPk9wI1e1maFPls9j0jpin2kTrMgFR141NY/xwVqGpgDUgRj/UGIKWhfcnJfgCSNdz/hVuKxQILbS/ks1CX8LCdnB/ohpIAo8G3hHKYE2M9FcvsMxnCGEmpIC5vhatVx7pwinw1M5wmSX1zSttDvaGWGS1pQN0Mu1YZJn2/0lDjcRdeChLLbCI62+clHlapqbuj4+JR1HrMGqDIl7tcuS3tBEN7PvrDsjxddm12AP0ZdT0K1yzxqC1/1CPh84mljYegysVWiGoalu/Ei/Tz3YAIvowWnbWEprY1hLeLal5nXT7HECqYkBCUBG1jBO247oixnsWnK8E2Fk2h5zzYUnMD4GXyFbVpXr1I3LC0zKAxftJHQ19zYNJKNWMcZTpuuc5GqTDeE/60zRVCol8iRndstt6o/oArikIxE073mKgnjTKs9h6/WUeQ==
x-ms-exchange-antispam-messagedata: 2Rj7U6dex32742nKG6M7D2JYTvK6m89cPFdCkEM8AO+mZOPm4no1d1F1IERYS0Kt1rojC0N95R7kN3IXDf8FOFWMoRA+F2Pk0wvESim+lEyrSP27aPDverypmKUmvLz6cuViKdSsQ6/SZye0UqDr4w==
Content-Type: text/plain; charset="utf-8"
Content-ID: <BFE11E7EE2DA1344B761546B518E180D@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b5e0c232-86ea-4190-31fa-08d7b5aa6d3e
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Feb 2020 02:13:07.6545
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GSshf+xSAUkACZQOHvohAlixqPHQjs5pepzcNB9c38mryKAV1NCtU1cX66JsfdUSUKqSJvMwR39K8p+KJI2Acw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4270
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDIwLTAyLTE5IGF0IDE2OjEyIC0wODAwLCBEYXZpZCBNaWxsZXIgd3JvdGU6DQo+
IEZyb206IFNhZWVkIE1haGFtZWVkIDxzYWVlZG1AbWVsbGFub3guY29tPg0KPiBEYXRlOiBXZWQs
IDE5IEZlYiAyMDIwIDAyOjQzOjA4ICswMDAwDQo+IA0KPiA+IE9uIFN1biwgMjAyMC0wMi0xNiBh
dCAxMjowMSArMDIwMCwgUGF1bCBCbGFrZXkgd3JvdGU6DQo+ID4+IEhpIERhdmlkL0pha3ViL1Nh
ZWVkLA0KPiA+PiANCj4gPj4gVEMgbXVsdGkgY2hhaW4gY29uZmlndXJhdGlvbiBjYW4gY2F1c2Ug
b2ZmbG9hZGVkIHRjIGNoYWlucyB0byBtaXNzDQo+IGluDQo+ID4+IGhhcmR3YXJlIGFmdGVyIGp1
bXBpbmcgdG8gc29tZSBjaGFpbi4gSW4gc3VjaCBjYXNlcyB0aGUgc29mdHdhcmUNCj4gPj4gc2hv
dWxkDQo+ID4+IGNvbnRpbnVlIGZyb20gdGhlIGNoYWluIHRoYXQgd2FzIG1pc3NlZCBpbiBoYXJk
d2FyZSwgYXMgdGhlDQo+IGhhcmR3YXJlDQo+ID4+IG1heSBoYXZlDQo+ID4+IG1hbmlwdWxhdGVk
IHRoZSBwYWNrZXQgYW5kIHVwZGF0ZWQgc29tZSBjb3VudGVycy4NCj4gPj4gDQo+ID4gDQo+ID4g
Wy4uLl0NCj4gPiANCj4gPj4gTm90ZSB0aGF0IG1pc3MgcGF0aCBoYW5kbGluZyBvZiBtdWx0aS1j
aGFpbiBydWxlcyBpcyBhIHJlcXVpcmVkDQo+ID4+IGluZnJhc3RydWN0dXJlDQo+ID4+IGZvciBj
b25uZWN0aW9uIHRyYWNraW5nIGhhcmR3YXJlIG9mZmxvYWQuIFRoZSBjb25uZWN0aW9uIHRyYWNr
aW5nDQo+ID4+IG9mZmxvYWQNCj4gPj4gc2VyaWVzIHdpbGwgZm9sbG93IHRoaXMgb25lLg0KPiA+
PiANCj4gPiANCj4gPiBIaSBEYXZlLCANCj4gPiANCj4gPiBBcyB3YXMgYWdyZWVkLCBpIHdpbGwg
YXBwbHkgdGhpcyBzZXJpZXMgYW5kIHRoZSB0d28gdG8gZm9sbG93IHRvIGENCj4gc2lkZQ0KPiA+
IGJyYW5jaCB1bnRpbCBhbGwgdGhlIGNvbm5lY3Rpb24gdHJhY2tpbmcgb2ZmbG9hZHMgcGF0Y2hz
ZXRzIGFyZQ0KPiBwb3N0ZWQNCj4gPiBieSBQYXVsIGFuZCByZXZpZXdlZC9hY2tlZC4NCj4gPiAN
Cj4gPiBpbiBjYXNlIG9mIG5vIG9iamVjdGlvbiBpIHdpbGwgYXBwbHkgdGhpcyBwYXRjaHNldCB0
byBhbGxvdyBQYXVsIHRvDQo+ID4gbW92ZSBmb3J3YXJkIHdpdGggdGhlIG90aGVyIHR3byBjb25u
ZWN0aW9uIHRyYWNraW5nIHBhdGNoc2V0cy4NCj4gDQo+IEkgaGF2ZSBubyBvYmplY3Rpb24gdG8g
dGhpcyBzZXJpZXMsIGNhbiB5b3Ugc2V0dXAgYSBwdWxsIHJlcXVlc3Qgd2l0aA0KPiB0aGlzDQo+
IHNlcmllcyBpbiBpdCB0aGF0IEkgY2FuIHB1bGwgZnJvbSBpbnRvIG5ldC1uZXh0Pw0KPiANCg0K
R3JlYXQsIFllcyBpIHdpbGwgc2V0dXAgdGhlIHB1bGwgcmVxdWVzdC4gDQoNClNlcmllcyBhcHBs
aWVkIHRvIGN0LW9mZmxvYWQgYnJhbmNoOg0KaHR0cHM6Ly9naXQua2VybmVsLm9yZy9wdWIvc2Nt
L2xpbnV4L2tlcm5lbC9naXQvc2FlZWQvbGludXguZ2l0L2xvZy8/aD1jdC1vZmZsb2FkDQoNCkkg
d2lsbCBzZW5kIHRoZSBwdWxsIHJlcXVlc3Qgb25jZSBhbGwgY29ubmVjdGlvbiB0cmFja2luZyBv
ZmZsb2FkDQpwYXRjaGVzIGFyZSBwb3N0ZWQgYW5kIHJldmlld2VkIGluIG5ldC1uZXh0Lg0KDQpU
aGFua3MuDQoNCg==
