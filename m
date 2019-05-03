Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8989012A38
	for <lists+netdev@lfdr.de>; Fri,  3 May 2019 11:03:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726953AbfECJDW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 05:03:22 -0400
Received: from mail-eopbgr80084.outbound.protection.outlook.com ([40.107.8.84]:30689
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726138AbfECJDW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 May 2019 05:03:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yrEDpZWVwMd225XqkRd/JdqC5eDCN7BYEhBawF9UxaA=;
 b=mNCFc8wNwElb6cvRVh9IGe04U8DyUkia7UeBNnOIGhWkuzakU2tGdFAHGjWhpWyPh2w5Hwod2Bu2UsT5cvuZbZGAicW/wkx23lLYPzvucOk214UmdDpbDx7Pz4h65A732h6nEJaIfLVfquY3uYf+z5WStzUey2zmprmDlafi7kU=
Received: from HE1PR0502MB3641.eurprd05.prod.outlook.com (10.167.127.11) by
 HE1PR0502MB3817.eurprd05.prod.outlook.com (10.167.127.159) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1856.12; Fri, 3 May 2019 09:03:12 +0000
Received: from HE1PR0502MB3641.eurprd05.prod.outlook.com
 ([fe80::8a6:f9c8:9a75:8948]) by HE1PR0502MB3641.eurprd05.prod.outlook.com
 ([fe80::8a6:f9c8:9a75:8948%2]) with mapi id 15.20.1856.008; Fri, 3 May 2019
 09:03:12 +0000
From:   Vlad Buslov <vladbu@mellanox.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>,
        Matteo Croce <mcroce@redhat.com>
CC:     Vlad Buslov <vladbu@mellanox.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net] cls_matchall: avoid panic when receiving a packet
 before filter set
Thread-Topic: [PATCH net] cls_matchall: avoid panic when receiving a packet
 before filter set
Thread-Index: AQHU/rJZyWdv7dUO60+kMc0WWWwiZaZVOOWAgADJ0wCAAQFbgIACHJGA
Date:   Fri, 3 May 2019 09:03:11 +0000
Message-ID: <vbf8svnq59y.fsf@mellanox.com>
References: <20190429173805.4455-1-mcroce@redhat.com>
 <CAM_iQpXB83o+Nnbef8-h_8cg6rTVZn194uZvP1-VKPcJ+xMEjA@mail.gmail.com>
 <CAGnkfhzPZjqnemq+Sh=pAQPsoadYD2UYfdVf8UHt-Dd7gqhVOg@mail.gmail.com>
 <CAM_iQpXNdZPAWiGuwRGhgX4WdRGEwVnax5VyMrXZ+hM9xhhzCQ@mail.gmail.com>
In-Reply-To: <CAM_iQpXNdZPAWiGuwRGhgX4WdRGEwVnax5VyMrXZ+hM9xhhzCQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: LO2P265CA0261.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:8a::33) To HE1PR0502MB3641.eurprd05.prod.outlook.com
 (2603:10a6:7:85::11)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=vladbu@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [37.142.13.130]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0b5882c5-1c4f-494a-bf41-08d6cfa62b03
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:HE1PR0502MB3817;
x-ms-traffictypediagnostic: HE1PR0502MB3817:
x-microsoft-antispam-prvs: <HE1PR0502MB38171F06D32C09FB31393A98AD350@HE1PR0502MB3817.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0026334A56
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(346002)(396003)(366004)(376002)(136003)(51444003)(199004)(189003)(102836004)(81166006)(186003)(81156014)(68736007)(256004)(66446008)(64756008)(66556008)(66476007)(66946007)(73956011)(14444005)(26005)(54906003)(52116002)(86362001)(4326008)(229853002)(2906002)(478600001)(110136005)(316002)(25786009)(36756003)(76176011)(71200400001)(6486002)(486006)(99286004)(8676002)(2616005)(446003)(11346002)(305945005)(7736002)(14454004)(8936002)(6246003)(5660300002)(6436002)(53546011)(53936002)(6116002)(6506007)(386003)(3846002)(476003)(66066001)(6512007)(71190400001);DIR:OUT;SFP:1101;SCL:1;SRVR:HE1PR0502MB3817;H:HE1PR0502MB3641.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:3;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: P/BSrS8/eVmgpemDN7YDt70i8oXqEQw7mQE+aYD+1EgqafX84tOL1TjqT7NUrRJziawXyh2dQ4qawIbP8E4KeZDjO6SGYcQANsmo+5YTTXTIuiuN2Hp04tC9F3yq8mWoJTFXTmhztASbxg6SbU5vVl3556OVCW0R6CdHknAkgQB7dFnnfQakkMEY4ROMln9ab+5Lz+jY9iR7+RI3qsy7B90XEEm7kkxjoubYyozUNFX+qIuvqCk80ElRms8Kx2as8p+jjQpvmA/WKYcmfEA89zMjpsSyQhrr732y3qvkT4JNuvoq+tU8i1lGeP71xkNodKWeYUWdr5g035LTopq+TXntWvkB/KNfp9brRkOCt/Ue1ZMtX3xHF4n0HE2xjezQW89voc2N+1UdkVRJi2dZI+INJ6OF0ZcsCjD6d4ExkPY=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b5882c5-1c4f-494a-bf41-08d6cfa62b03
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 May 2019 09:03:11.9105
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0502MB3817
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1IDAyIE1heSAyMDE5IGF0IDAzOjQ4LCBDb25nIFdhbmcgPHhpeW91Lndhbmdjb25nQGdt
YWlsLmNvbT4gd3JvdGU6DQo+IE9uIFdlZCwgTWF5IDEsIDIwMTkgYXQgMjoyNyBBTSBNYXR0ZW8g
Q3JvY2UgPG1jcm9jZUByZWRoYXQuY29tPiB3cm90ZToNCj4+DQo+PiBPbiBUdWUsIEFwciAzMCwg
MjAxOSBhdCAxMToyNSBQTSBDb25nIFdhbmcgPHhpeW91Lndhbmdjb25nQGdtYWlsLmNvbT4gd3Jv
dGU6DQo+PiA+DQo+PiA+IE9uIE1vbiwgQXByIDI5LCAyMDE5IGF0IDEwOjM4IEFNIE1hdHRlbyBD
cm9jZSA8bWNyb2NlQHJlZGhhdC5jb20+IHdyb3RlOg0KPj4gPiA+DQo+PiA+ID4gV2hlbiBhIG1h
dGNoYWxsIGNsYXNzaWZpZXIgaXMgYWRkZWQsIHRoZXJlIGlzIGEgc21hbGwgdGltZSBpbnRlcnZh
bCBpbg0KPj4gPiA+IHdoaWNoIHRwLT5yb290IGlzIE5VTEwuIElmIHdlIHJlY2VpdmUgYSBwYWNr
ZXQgaW4gdGhpcyBzbWFsbCB0aW1lIHNsaWNlDQo+PiA+ID4gYSBOVUxMIHBvaW50ZXIgZGVyZWZl
cmVuY2Ugd2lsbCBoYXBwZW4sIGxlYWRpbmcgdG8gYSBrZXJuZWwgcGFuaWM6DQo+PiA+DQo+PiA+
IEhtbSwgd2h5IG5vdCBqdXN0IGNoZWNrIHRwLT5yb290IGFnYWluc3QgTlVMTCBpbiBtYWxsX2Ns
YXNzaWZ5KCk/DQo+PiA+DQo+PiA+IEFsc28sIHdoaWNoIGlzIHRoZSBvZmZlbmRpbmcgY29tbWl0
IGhlcmU/IFBsZWFzZSBhZGQgYSBGaXhlczogdGFnLg0KPj4gPg0KPj4gPiBUaGFua3MuDQo+Pg0K
Pj4gSGksDQo+Pg0KPj4gSSBqdXN0IHdhbnQgdG8gYXZvaWQgYW4gZXh0cmEgY2hlY2sgd2hpY2gg
d291bGQgYmUgbWFkZSBmb3IgZXZlcnkgcGFja2V0Lg0KPj4gUHJvYmFibHkgdGhlIGJlbmVmaXQg
b3ZlciBhIGNoZWNrIGlzIG5lZ2xpZ2libGUsIGJ1dCBpdCdzIHN0aWxsIGENCj4+IHBlci1wYWNr
ZXQgdGhpbmcuDQo+PiBJZiB5b3UgcHJlZmVyIGEgc2ltcGxlIGNoZWNrLCBJIGNhbiBtYWtlIGEg
djIgdGhhdCB3YXkuDQo+DQo+IFllYWgsIEkgdGhpbmsgdGhhdCBpcyBiZXR0ZXIsIHlvdSBjYW4g
YWRkIGFuIHVubGlrZWx5KCkgZm9yIHBlcmZvcm1hbmNlDQo+IGNvbmNlcm4sIGFzIE5VTEwgaXMg
YSByYXJlIGNhc2UuDQo+DQo+DQo+Pg0KPj4gRm9yIHRoZSBmaXhlcyB0YWcsIEkgZGlkbid0IHB1
dCBpdCBhcyBJJ20gbm90IHJlYWxseSBzdXJlIGFib3V0IHRoZQ0KPj4gb2ZmZW5kaW5nIGNvbW1p
dC4gSSBndWVzcyBpdCdzIHRoZSBmb2xsb3dpbmcsIHdoYXQgZG8geW91IHRoaW5rPw0KPj4NCj4+
IGNvbW1pdCBlZDc2ZjVlZGNjYzk4ZmE2NmYyMzM3ZjBiM2IyNTVkNmUxYTU2OGI3DQo+PiBBdXRo
b3I6IFZsYWQgQnVzbG92IDx2bGFkYnVAbWVsbGFub3guY29tPg0KPj4gRGF0ZTogICBNb24gRmVi
IDExIDEwOjU1OjM4IDIwMTkgKzAyMDANCj4+DQo+PiAgICAgbmV0OiBzY2hlZDogcHJvdGVjdCBm
aWx0ZXJfY2hhaW4gbGlzdCB3aXRoIGZpbHRlcl9jaGFpbl9sb2NrIG11dGV4DQo+DQo+IEkgdGhp
bmsgeW91IGFyZSByaWdodCwgdGhpcyBpcyB0aGUgY29tbWl0IGludHJvZHVjZWQgdGhlIGNvZGUN
Cj4gdGhhdCBpbnNlcnRzIHRoZSB0cCBiZWZvcmUgZnVsbHkgaW5pdGlhbGl6aW5nIGl0LiBQbGVh
c2UgQ2MgVmxhZA0KPiBmb3IgeW91ciB2MiwgaW4gY2FzZSB3ZSBibGFtZSBhIHdyb25nIGNvbW1p
dCBoZXJlLg0KPg0KPg0KPiBCVFcsIGl0IGxvb2tzIGxpa2UgY2xzX2Nncm91cCBuZWVkcyBhIHNh
bWUgZml4LiBQbGVhc2UgYXVkaXQNCj4gb3RoZXIgdGMgZmlsdGVycyBhcyB3ZWxsLg0KPg0KPiBU
aGFua3MhDQoNClNvcnJ5IGZvciBsYXRlIHJlc3BvbnNlLiBUaGlzIGlzIGluZGVlZCB0aGUgb2Zm
ZW5kaW5nIGNvbW1pdCB0aGF0IHNob3VsZA0KYmUgcmVmZXJlbmNlZCBieSBmaXhlcyB0YWcuDQoN
ClRoYW5rcyBmb3IgZml4aW5nIHRoaXMsIE1hdHRlbyENCg==
