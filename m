Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55F8DAF388
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 02:03:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726373AbfIKADU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 20:03:20 -0400
Received: from rcdn-iport-2.cisco.com ([173.37.86.73]:5216 "EHLO
        rcdn-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726198AbfIKADU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Sep 2019 20:03:20 -0400
X-Greylist: delayed 425 seconds by postgrey-1.27 at vger.kernel.org; Tue, 10 Sep 2019 20:03:19 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=3576; q=dns/txt; s=iport;
  t=1568160199; x=1569369799;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=cu/ASNGt2xtMmbbsfEmr3ob4fEcrHvoQvxncOv06Umo=;
  b=HNbSvzjhel187McD3VYksvTC+5QzqUs4z9DTQJfx+61kLQdDjCgmIorK
   ZKCwBqOHZfcrGNSALodeA0Voui/WYuve1jGo1zRO9hat5oztuTSZvMgQA
   uf1x4SNE5YOAk0PIPR3lA5WAHmJ95p9L0uPzTtas26ctZFEj/G4AibQ4n
   w=;
IronPort-PHdr: =?us-ascii?q?9a23=3A0KzXTBMkiDCSkemSJp4l6mtXPHoupqn0MwgJ65?=
 =?us-ascii?q?Eul7NJdOG58o//OFDEu6w/l0fHCIPc7f8My/HbtaztQyQh2d6AqzhDFf4ETB?=
 =?us-ascii?q?oZkYMTlg0kDtSCDBj2Kv3nZCw3GuxJVURu+DewNk0GUMs=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A0C+AADuN3hd/4wNJK1lGgEBAQEBAgE?=
 =?us-ascii?q?BAQEHAgEBAQGBZ4FFUAOBQyAECyqEIYNHA4p7TYFqJZdwglIDVAkBAQEMAQE?=
 =?us-ascii?q?tAgEBhD8CF4IyIzgTAgMJAQEEAQEBAgEGBG2FLgyFSgEBAQECARILBhEMAQE?=
 =?us-ascii?q?3AQQHBAIBCA4DAwECAwImAgICMBUICAIEDgUigwCBawMODwGdVAKBOIhhc4E?=
 =?us-ascii?q?ygn0BAQWFCxiCFgkUeCiLeBiBQD+BOAwTgh4uPoREF4J0MoImjww0nQsKgiG?=
 =?us-ascii?q?UdxuZCoo+nC8CBAIEBQIOAQEFgWkhgVhwFTsqAYJBgkKDcopTc4Epjn8BAQ?=
X-IronPort-AV: E=Sophos;i="5.64,491,1559520000"; 
   d="scan'208";a="632023466"
Received: from alln-core-7.cisco.com ([173.36.13.140])
  by rcdn-iport-2.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 10 Sep 2019 23:56:03 +0000
Received: from XCH-RCD-017.cisco.com (xch-rcd-017.cisco.com [173.37.102.27])
        by alln-core-7.cisco.com (8.15.2/8.15.2) with ESMTPS id x8ANu3YP018337
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=FAIL);
        Tue, 10 Sep 2019 23:56:03 GMT
Received: from xhs-aln-003.cisco.com (173.37.135.120) by XCH-RCD-017.cisco.com
 (173.37.102.27) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 10 Sep
 2019 18:56:02 -0500
Received: from xhs-aln-002.cisco.com (173.37.135.119) by xhs-aln-003.cisco.com
 (173.37.135.120) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 10 Sep
 2019 18:56:02 -0500
Received: from NAM05-CO1-obe.outbound.protection.outlook.com (173.37.151.57)
 by xhs-aln-002.cisco.com (173.37.135.119) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Tue, 10 Sep 2019 18:56:02 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dv0ZoFmWQ30GzoXJPxWzOpDRcA3dbS0AVeGKeauc+Yog0410ro613SR9BlB3AMaFeGzrxZA9357g5tn3i9cwuqOYBq/ZhONnV9BLsB+84KAwIPAUAfDbjQm8VaPR3vn8qe6VE7qu0Imf7A6uVGTzVSU3alqSY6AAKfHel98Qpuw7v++qGQBxE5ziq0Vg/KRBCrqy+Qv8N9fQNdrNcPfC1bmwiKH2Krta4XA6iSFdDUUFNWv3M8WqrlC14k9bGUA5DqzR+RnEMzB8KCH1rsaZeGyLl+hZITVF5FmbcaN76gox/5VP3OvGWmhxtEAHbDeLSe9lsXVO7fhmAxNgp2hzTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cu/ASNGt2xtMmbbsfEmr3ob4fEcrHvoQvxncOv06Umo=;
 b=gmyhkyoIcZwPWQLwjCazPYErsaI47y1znHdprdNsPUS/hoN49D1IzTPtxwwSQu/f8tU02U4MliPETOoFAdCNPnwnqtWlFn12XVP4oY7E7pbLsn+DFvP6xBunoeDBp9pthVwg4XnGHnE6JE4TTd77OiZ5POn560QdSZFdQGr/24iOGD+KRelwtRwkA2CKUz9DhWbeNnK2T3UUA8OY2dV7S7HM6X9baMQmyP2HdvGn+XrAtZ+knuFZsmjrF3/ngqSqlxpX0YQaQkN5Wd3fwvJ+ai2bKMMHEBwtIlnnPGO+2PfzlwyHHWUoIngFZ3dOSWZWS56aCO7IwVaIYgc2ZBpJOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cisco.onmicrosoft.com;
 s=selector2-cisco-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cu/ASNGt2xtMmbbsfEmr3ob4fEcrHvoQvxncOv06Umo=;
 b=VtRPI9k30cknPPa88qsUHotA7SwM5Op4D3b5sMk2CRSyr+oGfVlMRa/aZ37bdljLFgIUsQoFe8IYYDLIlNLhp6CKX7RherthEj4CZJANzVSGi905mEhvfDAc5TLI5/C1zdPA8qfmmOgqwZA5laJK1BrIoFqNm7pR0z3yLMNezcg=
Received: from BY5PR11MB3990.namprd11.prod.outlook.com (10.255.162.95) by
 BY5PR11MB4006.namprd11.prod.outlook.com (10.255.161.31) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.15; Tue, 10 Sep 2019 23:55:59 +0000
Received: from BY5PR11MB3990.namprd11.prod.outlook.com
 ([fe80::3997:cece:5e36:49a8]) by BY5PR11MB3990.namprd11.prod.outlook.com
 ([fe80::3997:cece:5e36:49a8%5]) with mapi id 15.20.2241.018; Tue, 10 Sep 2019
 23:55:59 +0000
From:   "Enke Chen (enkechen)" <enkechen@cisco.com>
To:     David Miller <davem@davemloft.net>
CC:     "kuznet@ms2.inr.ac.ru" <kuznet@ms2.inr.ac.ru>,
        "yoshfuji@linux-ipv6.org" <yoshfuji@linux-ipv6.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xe-linux-external(mailer list)" <xe-linux-external@cisco.com>,
        "Enke Chen (enkechen)" <enkechen@cisco.com>
Subject: Re: [PATCH] net: Remove the source address setting in connect() for
 UDP
Thread-Topic: [PATCH] net: Remove the source address setting in connect() for
 UDP
Thread-Index: AQHVZF6CHsOdeXPHPUGTpDh6i+p9EacePIYA//+NawCAB152AA==
Date:   Tue, 10 Sep 2019 23:55:59 +0000
Message-ID: <324B00C3-4526-4026-809B-299634E49368@cisco.com>
References: <20190906025437.613-1-enkechen@cisco.com>
 <20190906.091350.2133455010162259391.davem@davemloft.net>
 <1DCD31CA-E94F-4127-876F-8DD355E6CF9A@cisco.com>
In-Reply-To: <1DCD31CA-E94F-4127-876F-8DD355E6CF9A@cisco.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-Auto-Response-Suppress: DR, OOF, AutoReply
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/10.1c.0.190812
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=enkechen@cisco.com; 
x-originating-ip: [2001:420:30a:4e05:2c10:12ba:2d63:dec5]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8ea7736d-043c-46ed-d464-08d7364a6e1b
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BY5PR11MB4006;
x-ms-traffictypediagnostic: BY5PR11MB4006:
x-ld-processed: 5ae1af62-9505-4097-a69a-c1553ef7840e,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR11MB400664DB99A04F92BEA774C1C5B60@BY5PR11MB4006.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 01565FED4C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(396003)(136003)(376002)(366004)(39860400002)(13464003)(189003)(199004)(8676002)(305945005)(81156014)(81166006)(102836004)(6486002)(229853002)(256004)(476003)(7736002)(99286004)(6512007)(6436002)(107886003)(46003)(11346002)(446003)(2616005)(6246003)(478600001)(2906002)(53546011)(36756003)(316002)(6506007)(86362001)(58126008)(71190400001)(71200400001)(25786009)(54906003)(6116002)(14454004)(4326008)(6916009)(5660300002)(66446008)(64756008)(186003)(53936002)(66946007)(66476007)(66556008)(76176011)(486006)(76116006)(8936002)(33656002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY5PR11MB4006;H:BY5PR11MB3990.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: cisco.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: lKMNxmp5Gwa4fTP8vE7zLP3U+O2axMRdbLLGtZtWO6FKX69yM5yWRuhnlJiGwXeGkd8PZ3hrDwZux86izo9hw0k2WRVWuCO8OfUBL9dGvRzxuAjZBCziUdVbfgFCQZBqzRJVrSSnqeQmt2Czb7qVLNrt8T1FL/jp8Cq+rUSxRO14TONEVlAXdBC96eAsQ8k1Q52YDZn/RBZB4E6jKv3fIs5Mqto+gQOI07ppWFvBI1ZpTm7w2i6Ld+mx30MMMYPBYXGumXKqigYEPnIA9JywBm3QH6v0Gi+gTJn2VbFC8Zj73xG3k7SKmyGMWc+026LfcDZzpR1Yma4qsNeVa9MYR9G/SvrG4CLY98a1f4I2MvUQzAxO7FR9TH7R1mjrFhZX1MRWBAyrP1jrN8AI7AyUWTPqWfi7aGZwH+asbfl9BUU=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1B5A6CEC63473945BFC29C83496B69BA@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ea7736d-043c-46ed-d464-08d7364a6e1b
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Sep 2019 23:55:59.7552
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3MWflheoEkRXR31/4oI1Ox0jocBlUn6O3gbrk/KbvUXl8KCvBGZ9DUUMqDNAJp0wo9z9rLLULLPEEbC2ztt9RQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR11MB4006
X-OriginatorOrg: cisco.com
X-Outbound-SMTP-Client: 173.37.102.27, xch-rcd-017.cisco.com
X-Outbound-Node: alln-core-7.cisco.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGksIERhdmlkOg0KDQpEbyB5b3Ugc3RpbGwgaGF2ZSBjb25jZXJucyBhYm91dCBiYWNrd2FyZCBj
b21wYXRpYmlsaXR5IG9mIHRoZSBmaXg/DQoNCkkgcmVhbGx5IGRvIG5vdCBzZWUgaG93IGV4aXN0
aW5nLCB3b3JraW5nIGFwcGxpY2F0aW9ucyB3b3VsZCBiZSBuZWdhdGl2ZWx5IGltcGFjdGVkDQpi
eSB0aGUgZml4Lg0KDQpUaGFua3MuICAgLS0gRW5rZQ0KDQrvu78tLS0tLU9yaWdpbmFsIE1lc3Nh
Z2UtLS0tLQ0KRnJvbTogIkVua2UgQ2hlbiAoZW5rZWNoZW4pIiA8ZW5rZWNoZW5AY2lzY28uY29t
Pg0KRGF0ZTogRnJpZGF5LCBTZXB0ZW1iZXIgNiwgMjAxOSBhdCAxMjoyMyBBTQ0KVG86IERhdmlk
IE1pbGxlciA8ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldD4NCkNjOiAia3V6bmV0QG1zMi5pbnIuYWMucnUi
IDxrdXpuZXRAbXMyLmluci5hYy5ydT4sICJ5b3NoZnVqaUBsaW51eC1pcHY2Lm9yZyIgPHlvc2hm
dWppQGxpbnV4LWlwdjYub3JnPiwgIm5ldGRldkB2Z2VyLmtlcm5lbC5vcmciIDxuZXRkZXZAdmdl
ci5rZXJuZWwub3JnPiwgImxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmciIDxsaW51eC1rZXJu
ZWxAdmdlci5rZXJuZWwub3JnPiwgInhlLWxpbnV4LWV4dGVybmFsKG1haWxlciBsaXN0KSIgPHhl
LWxpbnV4LWV4dGVybmFsQGNpc2NvLmNvbT4sICJFbmtlIENoZW4gKGVua2VjaGVuKSIgPGVua2Vj
aGVuQGNpc2NvLmNvbT4NClN1YmplY3Q6IFJlOiBbUEFUQ0hdIG5ldDogUmVtb3ZlIHRoZSBzb3Vy
Y2UgYWRkcmVzcyBzZXR0aW5nIGluIGNvbm5lY3QoKSBmb3IgVURQDQoNCkhpLCBEYXZpZDoNCg0K
WWVzLCBJIHVuZGVyc3RhbmQgdGhlIGNvZGUgaGFzIGJlZW4gdGhlcmUgZm9yIGEgbG9uZyB0aW1l
LiAgQnV0IHRoZSBpc3N1ZXMgYXJlIHJlYWwsIGFuZCBpdCdzIHJlYWxseSBuYXN0eSB3aGVuDQpZ
b3UgcnVuIGludG8gdGhlbS4gIEFzIEkgZGVzY3JpYmVkIGluIHRoZSBwYXRjaCBsb2csIHRoZXJl
IGlzIG5vIGJhY2t3YXJkIGNvbXBhdGliaWxpdHkgSXNzdWUgZm9yIGZpeGluZyBpdC4NCg0KLS0t
DQpUaGVyZSBpcyBubyBiYWNrd2FyZCBjb21wYXRpYmlsaXR5IGlzc3VlIGhlcmUgYXMgdGhlIHNv
dXJjZSBhZGRyZXNzIHNldHRpbmcNCmluIGNvbm5lY3QoKSBpcyBub3QgbmVlZGVkIGFueXdheS4N
Cg0KICAtIE5vIGltcGFjdCBvbiB0aGUgc291cmNlIGFkZHJlc3Mgc2VsZWN0aW9uIHdoZW4gdGhl
IHNvdXJjZSBhZGRyZXNzDQogICAgaXMgZXhwbGljaXRseSBzcGVjaWZpZWQgYnkgImJpbmQoKSIs
IG9yIGJ5IHRoZSAiSVBfUEtUSU5GTyIgb3B0aW9uLg0KDQogIC0gSW4gdGhlIGNhc2UgdGhhdCB0
aGUgc291cmNlIGFkZHJlc3MgaXMgbm90IGV4cGxpY2l0bHkgc3BlY2lmaWVkLA0KICAgIHRoZSBz
ZWxlY3Rpb24gb2YgdGhlIHNvdXJjZSBhZGRyZXNzIHdvdWxkIGJlIG1vcmUgYWNjdXJhdGUgYW5k
DQogICAgcmVsaWFibGUgYmFzZWQgb24gdGhlIHVwLXRvLWRhdGUgcm91dGluZyB0YWJsZS4NCi0t
LQ0KDQpUaGFua3MuICAtLSBFbmtlDQoNCi0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQpGcm9t
OiA8bGludXgta2VybmVsLW93bmVyQHZnZXIua2VybmVsLm9yZz4gb24gYmVoYWxmIG9mIERhdmlk
IE1pbGxlciA8ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldD4NCkRhdGU6IEZyaWRheSwgU2VwdGVtYmVyIDYs
IDIwMTkgYXQgMTI6MTQgQU0NClRvOiAiRW5rZSBDaGVuIChlbmtlY2hlbikiIDxlbmtlY2hlbkBj
aXNjby5jb20+DQpDYzogImt1em5ldEBtczIuaW5yLmFjLnJ1IiA8a3V6bmV0QG1zMi5pbnIuYWMu
cnU+LCAieW9zaGZ1amlAbGludXgtaXB2Ni5vcmciIDx5b3NoZnVqaUBsaW51eC1pcHY2Lm9yZz4s
ICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiA8bmV0ZGV2QHZnZXIua2VybmVsLm9yZz4sICJsaW51
eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnIiA8bGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZz4s
ICJ4ZS1saW51eC1leHRlcm5hbChtYWlsZXIgbGlzdCkiIDx4ZS1saW51eC1leHRlcm5hbEBjaXNj
by5jb20+DQpTdWJqZWN0OiBSZTogW1BBVENIXSBuZXQ6IFJlbW92ZSB0aGUgc291cmNlIGFkZHJl
c3Mgc2V0dGluZyBpbiBjb25uZWN0KCkgZm9yIFVEUA0KDQpGcm9tOiBFbmtlIENoZW4gPGVua2Vj
aGVuQGNpc2NvLmNvbT4NCkRhdGU6IFRodSwgIDUgU2VwIDIwMTkgMTk6NTQ6MzcgLTA3MDANCg0K
PiBUaGUgY29ubmVjdCgpIHN5c3RlbSBjYWxsIGZvciBhIFVEUCBzb2NrZXQgaXMgZm9yIHNldHRp
bmcgdGhlIGRlc3RpbmF0aW9uDQo+IGFkZHJlc3MgYW5kIHBvcnQuIEJ1dCB0aGUgY3VycmVudCBj
b2RlIG1pc3Rha2VubHkgc2V0cyB0aGUgc291cmNlIGFkZHJlc3MNCj4gZm9yIHRoZSBzb2NrZXQg
YXMgd2VsbC4gUmVtb3ZlIHRoZSBzb3VyY2UgYWRkcmVzcyBzZXR0aW5nIGluIGNvbm5lY3QoKSBm
b3INCj4gVURQIGluIHRoaXMgcGF0Y2guDQoNCkRvIHlvdSBoYXZlIGFueSBpZGVhIGhvdyBtYW55
IGRlY2FkZXMgb2YgcHJlY2VkZW5jZSB0aGlzIGJlaGF2aW9yIGhhcyBhbmQNCnRoZXJlZm9yZSBo
b3cgbXVjaCB5b3UgcG90ZW50aWFsbHkgd2lsbCBicmVhayB1c2Vyc3BhY2U/DQoNClRoaXMgYm9h
dCBoYXMgc2FpbGVkIGEgbG9uZyB0aW1lIGFnbyBJJ20gYWZyYWlkLg0KDQoNCg==
