Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 785FAAC724
	for <lists+netdev@lfdr.de>; Sat,  7 Sep 2019 17:03:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406723AbfIGPDj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Sep 2019 11:03:39 -0400
Received: from mail-eopbgr40073.outbound.protection.outlook.com ([40.107.4.73]:12181
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2406077AbfIGPDj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 7 Sep 2019 11:03:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XilVHR8njVn928K2FoWl6PZxVqBPrhE8HtAOJzj7Rq4kQK75f6KKfmePsEYuD0C9bSFR615+v0Pt176kMub+tZD8KpZGnF64HeBPDTURlrkiI9bYnALe4gzGRASn1RTXYLVvPuct6xnzUPo3ZQdSjzSrqdOHV6Fmc97l0AL5Has7dRsqslXm9ix61YKj8o/hUX8+ja7njIQ0DmQ0DL67C2Bb5wpBR4uZPwP7AvzX4aKO9eMohPYtJTsvaSWr/JS0agGM7UpAKyNOvYEiMJKHm/WRfEfQLsLnRtyzrT7Lh9YQDEMC4ceImat2hkcVkzZf646/ajGjuGloFS11LgSp5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nkhU6WRg1mOPBg6c9WFprl+flEhqSQL+E2ThJSfmXIk=;
 b=g5zbMqiq7Wlqt5CnPXf2vTc9bkydZo3z7oxScT6izureKImksfINdbC9RdFb35dEq0wivhtSj/RMya5K2ic5ZKZYliasSRPGR3SdgHdR3pod1iTVXBXpPA2gM9/uuSQasmalCha8vwtp7FSRO+1w/sf7fclcOeAU1hvQykhb+4HuaESqXkLZYedrFULmQsi1EFiPQd2AH/LbnnWZJqxyfKamdvIkkSKUJ4uF+J8Fybxa1mVLawXtW1/fS51jIDyouVr4gBfI5qKEH2+D74i1SptfLg5kwlnwbJl9WV9PjxgqGYWky04ShvN+mqRcvZb+BsrowEMaVBji6sQe58XsgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nkhU6WRg1mOPBg6c9WFprl+flEhqSQL+E2ThJSfmXIk=;
 b=U7S5FLl3rtBHikPfgtfdC3B2v+zo8Q2ZEgNug2r5CQ9qemwE7mxqjqFf1w/uBLKMu3Rcyd4DQw0w7nbQp5on9yD65tttBVwHQF0yqikq4hnV6uYJI8i/fno9fmP8QD6Ps/qaMzDVl6/oIOWAMpMiGUckKhyoG/6auWNms4+VJdk=
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com (10.171.182.144) by
 VI1PR05MB3328.eurprd05.prod.outlook.com (10.170.238.141) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.15; Sat, 7 Sep 2019 15:03:32 +0000
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::79a3:d971:d1f3:ab6f]) by VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::79a3:d971:d1f3:ab6f%7]) with mapi id 15.20.2220.022; Sat, 7 Sep 2019
 15:03:32 +0000
From:   Jason Gunthorpe <jgg@mellanox.com>
To:     Jason Wang <jasowang@redhat.com>
CC:     "mst@redhat.com" <mst@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "aarcange@redhat.com" <aarcange@redhat.com>,
        "jglisse@redhat.com" <jglisse@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 0/2] Revert and rework on the metadata accelreation
Thread-Topic: [PATCH 0/2] Revert and rework on the metadata accelreation
Thread-Index: AQHVY+VUnpT/Tzy9vUuDxdg4xWUdk6cdHGCAgAFQPoCAAeZoAA==
Date:   Sat, 7 Sep 2019 15:03:32 +0000
Message-ID: <20190907150330.GC2940@mellanox.com>
References: <20190905122736.19768-1-jasowang@redhat.com>
 <20190905135907.GB6011@mellanox.com>
 <7785d39b-b4e7-8165-516c-ee6a08ac9c4e@redhat.com>
In-Reply-To: <7785d39b-b4e7-8165-516c-ee6a08ac9c4e@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: LO2P265CA0437.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:e::17) To VI1PR05MB4141.eurprd05.prod.outlook.com
 (2603:10a6:803:4d::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jgg@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [81.218.143.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8a921fc1-10d9-47f0-8a50-08d733a48c92
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR05MB3328;
x-ms-traffictypediagnostic: VI1PR05MB3328:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <VI1PR05MB33284BEEEC5A848E792B47DCCFB50@VI1PR05MB3328.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 0153A8321A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(376002)(136003)(346002)(39850400004)(396003)(189003)(199004)(76176011)(99286004)(66446008)(6506007)(86362001)(71190400001)(71200400001)(66946007)(52116002)(256004)(386003)(5660300002)(478600001)(6116002)(6916009)(7736002)(14444005)(25786009)(3846002)(966005)(81156014)(33656002)(54906003)(14454004)(8676002)(1076003)(486006)(4326008)(305945005)(316002)(66066001)(476003)(64756008)(2906002)(53936002)(446003)(81166006)(6246003)(11346002)(2616005)(66556008)(8936002)(26005)(6486002)(186003)(66476007)(36756003)(229853002)(102836004)(6436002)(6512007)(6306002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB3328;H:VI1PR05MB4141.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: xxuY2pPvq99pYKWpjAcid3zlFUBcjTLJ8Y+Z3fG9th2PQaVrjiwokecx4TBf7/K55bxWRjZXOIxbNCCky7m53B+05MF5yJlHnKOzhXy61nlqG+VFPG/QpTl0GskJYagSGB2w5jZ62JdTV/TVdTTDc34uQD+YGuar/y8M/v+e3uy0SGvIX9xTzin+23ksCsC0JNqeTFgiGsbGdjEoFCPcr/Yso6SIleJR9Y55GADfIKj4cY8vD+imsMq1V0+7ofAie3XlbfyOYpO62lGyo4Y9xrP3iykNXAKmpTcxZIMatq7HphcXQBPJ8XDF3C+dYn2oXEu/j0/UVaf9kvq2tEvmtfIERZteMFSPOzCeVHqRG42PwFr7jv260c7z+sW4ZCV0Kd1fgL9N5oOjw6K5T+5cX2q0tzeipH5lsQLfsmjDgHE=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <1C5F76DC2A6AD84FA5F277E8F3D586C0@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a921fc1-10d9-47f0-8a50-08d733a48c92
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Sep 2019 15:03:32.4230
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UrS2Fv3py7cTCu60J+995/F+M9vCTlkTcKEpTXwyUHexsIja+Pm03l4VhLxxADzr8eLVJdrA0ZFPomovx9/S/w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB3328
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCBTZXAgMDYsIDIwMTkgYXQgMDY6MDI6MzVQTSArMDgwMCwgSmFzb24gV2FuZyB3cm90
ZToNCj4gDQo+IE9uIDIwMTkvOS81IOS4i+WNiDk6NTksIEphc29uIEd1bnRob3JwZSB3cm90ZToN
Cj4gPiBPbiBUaHUsIFNlcCAwNSwgMjAxOSBhdCAwODoyNzozNFBNICswODAwLCBKYXNvbiBXYW5n
IHdyb3RlOg0KPiA+ID4gSGk6DQo+ID4gPiANCj4gPiA+IFBlciByZXF1ZXN0IGZyb20gTWljaGFl
bCBhbmQgSmFzb24sIHRoZSBtZXRhZGF0YSBhY2NlbHJlYXRpb24gaXMNCj4gPiA+IHJldmVydGVk
IGluIHRoaXMgdmVyc2lvbiBhbmQgcmV3b3JrIGluIG5leHQgdmVyc2lvbi4NCj4gPiA+IA0KPiA+
ID4gUGxlYXNlIHJldmlldy4NCj4gPiA+IA0KPiA+ID4gVGhhbmtzDQo+ID4gPiANCj4gPiA+IEph
c29uIFdhbmcgKDIpOg0KPiA+ID4gICAgUmV2ZXJ0ICJ2aG9zdDogYWNjZXNzIHZxIG1ldGFkYXRh
IHRocm91Z2gga2VybmVsIHZpcnR1YWwgYWRkcmVzcyINCj4gPiA+ICAgIHZob3N0OiByZS1pbnRy
b2R1Y2luZyBtZXRhZGF0YSBhY2NlbGVyYXRpb24gdGhyb3VnaCBrZXJuZWwgdmlydHVhbA0KPiA+
ID4gICAgICBhZGRyZXNzDQo+ID4gVGhlcmUgYXJlIGEgYnVuY2ggb2YgcGF0Y2hlcyBpbiB0aGUg
cXVldWUgYWxyZWFkeSB0aGF0IHdpbGwgaGVscA0KPiA+IHZob3N0LCBhbmQgSSBhIHdvcmtpbmcg
b24gb25lIGZvciBuZXh0IGN5Y2xlIHRoYXQgd2lsbCBoZWxwIGFsb3QgbW9yZQ0KPiA+IHRvby4N
Cj4gDQo+IA0KPiBJIHdpbGwgY2hlY2sgdGhvc2UgcGF0Y2hlcywgYnV0IGlmIHlvdSBjYW4gZ2l2
ZSBtZSBzb21lIHBvaW50ZXJzIG9yIGtleXdvcmRzDQo+IGl0IHdvdWxkIGJlIG11Y2ggYXBwcmVj
aWF0ZWQuDQoNCllvdSBjYW4gbG9vayBoZXJlOg0KDQpodHRwczovL2dpdGh1Yi5jb20vamd1bnRo
b3JwZS9saW51eC9jb21taXRzL21tdV9ub3RpZmllcg0KDQpUaGUgZmlyc3QgcGFydHMsIHRoZSBn
ZXQvcHV0IGFyZSBpbiB0aGUgaG1tIHRyZWUsIGFuZCB0aGUgbGFzdCBwYXJ0LA0KdGhlIGludGVy
dmFsIHRyZWUgaW4gdGhlIGxhc3QgY29tbWl0IGlzIHN0aWxsIGEgV0lQLCBidXQgaXQgd291bGQN
CnJlbW92ZSBhbG90IG9mIHRoYXQgY29kZSBmcm9tIHZob3N0IGFzIHdlbGwuDQoNCkphc29uDQo=
