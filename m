Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E60D113C4C2
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 15:02:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729154AbgAONyV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 08:54:21 -0500
Received: from mail-bn7nam10on2043.outbound.protection.outlook.com ([40.107.92.43]:8538
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729019AbgAONyV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jan 2020 08:54:21 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kHmE43A10rWxQ40JNx0Kjc1+mb23pNVRxpNFcs/RWqHqs+TzG7zgPEv6WHOjN7OGD08wDQCoLFPy3rahiGpaJsGxUmRGpcpFjvMf8dDLPTFQs6enJgfZuK3KiEzxJS2bQKse1f3EisBvzYlT5MZudO+UEFUS/zdSYdZbTq1sBLVtpEMtYekjovsNv5I8165gNelZDnKYdtsaxDJsJDrfmGDUq33q9uZgqaV3o6qn2Z44W038+xRIowlLZTYHfOKLPorJUgSCS5ddTrD7ZrRv7VZTUIojss3oLUfWumljQGsho+4tBtf7U9af+doJ+a+IkMcStLxihxTbU1KCntxmKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fhQww9H4Ug/YZqWy3+tCxx6M/uj8urd6WRAAOKOSgfk=;
 b=Xnj3a8tbaM1kBqCDssYh9xqqvgJFlrede1lF96O0gH4KZyYoKuVt7qJqWBTziIdp47wlzWZP78nIuRA8J08/A6cbb7O9sQr2kZahTZuCym9OwHImF1j+yYmyO+0vhfOpbAK0Uu2x8FgCgE9XW2njptsE6/18yNG97KFwUu+DR68jBlKhxVucFqv82urzgS4F7sqVStm6qyWIwuovKmHIUzmiLn4rfTi/42fIoITHMabm5OpKO5onNSpLUHRlJ9gppBCP3AXXT91YISnPEXOpq968lwn0cjk0EW21ckmg1W8sMnS0E0scOEcRYsmI21QxBK3mNUoSb9p1FR2v7XWeag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fhQww9H4Ug/YZqWy3+tCxx6M/uj8urd6WRAAOKOSgfk=;
 b=evc5ZanKjZdGZsQ+SDUri3ouy+K19BrvF+LADo3XCgjcE6V1L2gRwCt7Ux5YbikE2fmdSwOCgjpMR56I75I+T3bg0xXw2kDtL239t0Tixk6KBi5Fe8Z1XF1pY871QYrkMg7ta2H8uDS7koajD9iYB5nQVlYO+AUfrnY4dJNe6tY=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB3661.namprd11.prod.outlook.com (20.178.252.33) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.18; Wed, 15 Jan 2020 13:54:17 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2623.018; Wed, 15 Jan 2020
 13:54:17 +0000
Received: from pc-42.home (2a01:e35:8bf5:66a0:3dbe:4cb5:6059:a948) by PR2P264CA0008.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.18 via Frontend Transport; Wed, 15 Jan 2020 13:54:16 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH v2 11/65] staging: wfx: retrieve ampdu_density from
 sta->ht_cap
Thread-Topic: [PATCH v2 11/65] staging: wfx: retrieve ampdu_density from
 sta->ht_cap
Thread-Index: AQHVy6tHPpjVpkzfK0eN52IIaiVMww==
Date:   Wed, 15 Jan 2020 13:54:17 +0000
Message-ID: <20200115135338.14374-12-Jerome.Pouiller@silabs.com>
References: <20200115135338.14374-1-Jerome.Pouiller@silabs.com>
In-Reply-To: <20200115135338.14374-1-Jerome.Pouiller@silabs.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR2P264CA0008.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::20)
 To MN2PR11MB4063.namprd11.prod.outlook.com (2603:10b6:208:13f::22)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.25.0
x-originating-ip: [2a01:e35:8bf5:66a0:3dbe:4cb5:6059:a948]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b206454d-b500-45eb-8079-08d799c269ee
x-ms-traffictypediagnostic: MN2PR11MB3661:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB366141E34EF898FEA611013893370@MN2PR11MB3661.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:222;
x-forefront-prvs: 02830F0362
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(376002)(396003)(136003)(346002)(366004)(199004)(189003)(8886007)(6486002)(316002)(54906003)(71200400001)(36756003)(6506007)(66476007)(66446008)(66946007)(110136005)(8676002)(81166006)(81156014)(478600001)(86362001)(2616005)(4326008)(2906002)(107886003)(1076003)(16526019)(186003)(85202003)(5660300002)(6512007)(52116002)(64756008)(66556008)(85182001)(8936002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB3661;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: oEBxX86NLPKgNAGOiLTWoFjxTCEqJjL1+gJJpw8p+gbTi38pmlfOSjoX9abkNBJmpy4+w7n/Vo0NSlHlmsEYD5AD+VGXIao0ry45c/Avyc7UtWfg3oyeptPe/MS9y5vJsE5UJR4DFsl14BnJFRKwk4eODaHUfJ9iJNukPEPw0S+R0iOfJ+eSJ8NJwrwRSrSky+pLiO4ZC/nbLFLdU4mtRPMMB/nxduf42lah4TxhOegQiYXC4vQ8/Xg8lrL15QfSjWXqbIzSfLaqWfsO7Y3hlWExuaCeg3qaUppd/oZ2HfBlWx/7bSvfXRB95O3VkOWC6p7BsBZ+Aon6GvNI30ccIGUxFXw4NOwOlyiU9UvRfVcM9Iwh48S+xA7UGGug22Mm4Ch332tadg5fiz1fYeXklrIAGds/AM8JmCdu2LnwkrVATfm24VFVabYDGMQCOOV2
Content-Type: text/plain; charset="utf-8"
Content-ID: <0E6B6FF1B93E4F4FBBEF3B9BE9CEFD05@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b206454d-b500-45eb-8079-08d799c269ee
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2020 13:54:17.7926
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aE31wU3uQCSPvvzNPcCcJTBGuxl0Sayb9wAXhdas2HeX05tWc0+MY6jiPRVxcpSCUqq1ucd11q6ZOPKSLyCG1A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3661
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKd3Zp
Zi0+aHRfaW5mby5odF9jYXAgaXMgYSB1c2VsZXNzIGNvcHkgb2Ygc3RhLT5odF9jYXAuIEl0IG1h
a2VzIG5vIHNlbnNlCnRvIHJlbHkgb24gaXQuCgpTaWduZWQtb2ZmLWJ5OiBKw6lyw7RtZSBQb3Vp
bGxlciA8amVyb21lLnBvdWlsbGVyQHNpbGFicy5jb20+Ci0tLQogZHJpdmVycy9zdGFnaW5nL3dm
eC9zdGEuYyB8IDEwICsrLS0tLS0tLS0KIDEgZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlvbnMoKyks
IDggZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYyBi
L2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMKaW5kZXggNjYwYTc1MDI0ZjRiLi5mMTNhNWI0MTcz
NWMgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMKKysrIGIvZHJpdmVycy9z
dGFnaW5nL3dmeC9zdGEuYwpAQCAtODI1LDEzICs4MjUsNiBAQCBzdGF0aWMgaW50IHdmeF9odF9n
cmVlbmZpZWxkKGNvbnN0IHN0cnVjdCB3ZnhfaHRfaW5mbyAqaHRfaW5mbykKIAkJICBJRUVFODAy
MTFfSFRfT1BfTU9ERV9OT05fR0ZfU1RBX1BSU05UKTsKIH0KIAotc3RhdGljIGludCB3ZnhfaHRf
YW1wZHVfZGVuc2l0eShjb25zdCBzdHJ1Y3Qgd2Z4X2h0X2luZm8gKmh0X2luZm8pCi17Ci0JaWYg
KCF3ZnhfaXNfaHQoaHRfaW5mbykpCi0JCXJldHVybiAwOwotCXJldHVybiBodF9pbmZvLT5odF9j
YXAuYW1wZHVfZGVuc2l0eTsKLX0KLQogc3RhdGljIHZvaWQgd2Z4X2pvaW5fZmluYWxpemUoc3Ry
dWN0IHdmeF92aWYgKnd2aWYsCiAJCQkgICAgICBzdHJ1Y3QgaWVlZTgwMjExX2Jzc19jb25mICpp
bmZvKQogewpAQCAtODcwLDcgKzg2Myw4IEBAIHN0YXRpYyB2b2lkIHdmeF9qb2luX2ZpbmFsaXpl
KHN0cnVjdCB3ZnhfdmlmICp3dmlmLAogCWFzc29jaWF0aW9uX21vZGUuc2hvcnRfcHJlYW1ibGUg
PSBpbmZvLT51c2Vfc2hvcnRfcHJlYW1ibGU7CiAJYXNzb2NpYXRpb25fbW9kZS5iYXNpY19yYXRl
X3NldCA9IGNwdV90b19sZTMyKHdmeF9yYXRlX21hc2tfdG9faHcod3ZpZi0+d2RldiwgaW5mby0+
YmFzaWNfcmF0ZXMpKTsKIAlhc3NvY2lhdGlvbl9tb2RlLmdyZWVuZmllbGQgPSB3ZnhfaHRfZ3Jl
ZW5maWVsZCgmd3ZpZi0+aHRfaW5mbyk7Ci0JYXNzb2NpYXRpb25fbW9kZS5tcGR1X3N0YXJ0X3Nw
YWNpbmcgPSB3ZnhfaHRfYW1wZHVfZGVuc2l0eSgmd3ZpZi0+aHRfaW5mbyk7CisJaWYgKHN0YSAm
JiBzdGEtPmh0X2NhcC5odF9zdXBwb3J0ZWQpCisJCWFzc29jaWF0aW9uX21vZGUubXBkdV9zdGFy
dF9zcGFjaW5nID0gc3RhLT5odF9jYXAuYW1wZHVfZGVuc2l0eTsKIAogCXdmeF9jcW1fYnNzbG9z
c19zbSh3dmlmLCAwLCAwLCAwKTsKIAljYW5jZWxfd29ya19zeW5jKCZ3dmlmLT51bmpvaW5fd29y
ayk7Ci0tIAoyLjI1LjAKCg==
