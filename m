Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5467AF57D
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 13:26:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727695AbfD3L0y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 07:26:54 -0400
Received: from mail-eopbgr140048.outbound.protection.outlook.com ([40.107.14.48]:40103
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726129AbfD3L0w (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Apr 2019 07:26:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hJ6GvlGDuMHNLR3MY7R5wJKMjzpRTzdlO6IUd0jw1J4=;
 b=LBE49n48IuhptYOiwNQUmswSbkLBlLiXAVTNVeVFrbw7fhceJYp0esQVOObY/ukez40ruzhy99ZLbdSGXTVeKxNTGRdKWj2G6fEsxu8TaIN+JH70H819A51Zmoyg2EaXTH3MleDuP77l8xODPxjFelRIlAlsLPeH2W1sDXrrUPI=
Received: from AM0PR05MB5089.eurprd05.prod.outlook.com (20.177.41.153) by
 AM0PR05MB4257.eurprd05.prod.outlook.com (52.134.124.158) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1835.16; Tue, 30 Apr 2019 11:26:49 +0000
Received: from AM0PR05MB5089.eurprd05.prod.outlook.com
 ([fe80::4d74:8969:23d9:85c3]) by AM0PR05MB5089.eurprd05.prod.outlook.com
 ([fe80::4d74:8969:23d9:85c3%6]) with mapi id 15.20.1835.018; Tue, 30 Apr 2019
 11:26:49 +0000
From:   Aya Levin <ayal@mellanox.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>
Subject: Re: [PATCH net-next RFC] Dump SW SQ context as part of tx reporter
Thread-Topic: [PATCH net-next RFC] Dump SW SQ context as part of tx reporter
Thread-Index: AQHU/pZYnyLGqTM5xEOXiNRSU0YqZKZT4WmAgACwmgA=
Date:   Tue, 30 Apr 2019 11:26:49 +0000
Message-ID: <bc08fc27-820d-f73b-3fde-4c8c697a1c2a@mellanox.com>
References: <1556547459-7756-1-git-send-email-ayal@mellanox.com>
 <20190429205441.13c34785@cakuba>
In-Reply-To: <20190429205441.13c34785@cakuba>
Accept-Language: he-IL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM0PR06CA0008.eurprd06.prod.outlook.com
 (2603:10a6:208:ab::21) To AM0PR05MB5089.eurprd05.prod.outlook.com
 (2603:10a6:208:cd::25)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ayal@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e72d2a3b-58bb-4a8d-5499-08d6cd5ebc4d
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:AM0PR05MB4257;
x-ms-traffictypediagnostic: AM0PR05MB4257:
x-microsoft-antispam-prvs: <AM0PR05MB4257A7B49E548227A789DFE7B03A0@AM0PR05MB4257.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-forefront-prvs: 00235A1EEF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(136003)(39850400004)(396003)(376002)(366004)(199004)(189003)(2616005)(476003)(26005)(4326008)(6916009)(102836004)(316002)(31686004)(66476007)(73956011)(66946007)(66556008)(6506007)(54906003)(53546011)(11346002)(305945005)(2906002)(5660300002)(81166006)(81156014)(71200400001)(4744005)(8676002)(86362001)(14444005)(97736004)(52116002)(99286004)(3846002)(6116002)(76176011)(446003)(71190400001)(6512007)(53936002)(7736002)(256004)(386003)(8936002)(68736007)(31696002)(25786009)(66066001)(36756003)(6436002)(66446008)(107886003)(14454004)(6246003)(229853002)(486006)(64756008)(478600001)(6486002)(186003);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB4257;H:AM0PR05MB5089.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: gvgVsU1pscBz5csmXleAcJZXZm/kwZPtCCaq5919cbTL93iRt9bWZz5mZwsJIYsxNVQVKpcsmdVwTiRf0xo0Iaaw5UQXtghCz3xKTN9bsVmdtdxN3rlgec2n1EDRgBGYpvDpGb7pXuxWGz2Z/5IiUAxxvv9HsXjVCN2lxgIqjcrtWTwrZo+HiKM1rowpVJWAhYe+5CNO0B0G0T7priJQtSQaVnHzWPvRM7m8IDFC/8pa09A2Z/xOyI8dLVKTK82rW/J8HB4yT6HtZmQn8GO66L958FgMT5dHkYuxnX/WTLe4Ycz2pYy9QAw4lcLJKddVNYvEjTolzYLaROUv9KIUnMnAz8rU1G68FGmq2QPVENLMVpkJ25OVMlbDoFMoKZXC3UeFq1UT21f8BoxG8uuQiyWNTmzaVq8jsCfKAJBdhMQ=
Content-Type: text/plain; charset="utf-8"
Content-ID: <146782F939604240B7317CC3ED0D0301@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e72d2a3b-58bb-4a8d-5499-08d6cd5ebc4d
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Apr 2019 11:26:49.1976
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4257
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDQvMzAvMjAxOSAzOjU0IEFNLCBKYWt1YiBLaWNpbnNraSB3cm90ZToNCj4gT24gTW9u
LCAyOSBBcHIgMjAxOSAxNzoxNzozOSArMDMwMCwgQXlhIExldmluIHdyb3RlOg0KPj4gSW4gb3Jk
ZXIgdG8gb2ZmbGluZSB0cmFuc2xhdGUgdGhlIHJhdyBtZW1vcnkgaW50byBhIGh1bWFuIHJlYWRh
YmxlDQo+PiBmb3JtYXQsIHRoZSB1c2VyIGNhbiB1c2Ugc29tZSBvdXQtb2Yta2VybmVsIHNjcmlw
dHMgd2hpY2ggcmVjZWl2ZXMgYXMgYW4NCj4+IGlucHV0IHRoZSBmb2xsb3dpbmc6DQo+PiAtIE9i
amVjdCByYXcgbWVtb3J5DQo+PiAtIERyaXZlciBvYmplY3QgY29tcGlsZWQgd2l0aCBkZWJ1ZyBp
bmZvIChjYW4gYmUgdGFrZW4vZ2VuZXJhdGVkIGF0IGFueSB0aW1lIGZyb20gdGhlIG1hY2hpbmUp
DQo+PiAtIE9iamVjdCBuYW1lDQo+IA0KPiBOaWNlISAgSU1ITyB0aGlzIGlzIG1vcmUgY2xlYW4s
IHByZWNpc2UgYW5kIHNjYWxhYmxlIHRoYW4gdGhlIGZtc2cgc3R1ZmYNCj4gdGhhdCB3ZSBoYXZl
IG5vdy4NCj4gDQo+IFdvdWxkIHlvdSBtaW5kIHRha2luZyB0aGUgc3RyaW5nIGlkZW50aWZpZXJz
IGRvd24gYSBsaXR0bGUgYml0IG1vcmU/DQo+ICJtZW1vcnkiIGNvdWxkIGp1c3QgaGF2ZSBhIGZp
cnN0LWNsYXNzIG5ldGxpbmsgYXR0cmlidXRlLCBpdCBkb2Vzbid0DQo+IGhhdmUgdG8gYmUgdGhp
cyBmYWtlIEpTT04gc3RyaW5nIHBhaXIuLg0KPiANClRoYW5rcyENCkkgYW0gc3RpbGwgdXNpbmcg
Zm1zZyB3aGljaCBpcyB0aGUgQVBJIHRvIGNvbnN0cnVjdCBKU09OIGxpa2Ugb3V0cHV0LiANClRo
ZSBmbWcgb2JqZWN0IGNvbnRhaW5zIHRoZSByYXcgZGF0YS4NCkkgbGlrZSB5b3VyIGlkZWEgdG8g
cmVtb3ZlIHRoZSBtZW1vcnkgdGFnIGFuZCBqdXN0IGxlYXZlIHRoZSBhcnJheSBvZiANCmJ5dGUg
YXJyYXlzLiBUaGUgU1cgZHVtcCBkZXZsaW5rIG91dHB1dCB3aXRob3V0IHNjcmlwdGluZyBpcyBt
ZWFuaW5nbGVzcy4NCg==
