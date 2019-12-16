Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 053D212110F
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 18:08:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727671AbfLPRId (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 12:08:33 -0500
Received: from mail-dm6nam11on2044.outbound.protection.outlook.com ([40.107.223.44]:54496
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727842AbfLPRG6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Dec 2019 12:06:58 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dRCAy9kveX6rn4UKHwIX+CLm/oFd0CoJMDCcgJSdpktzocfucFuVd6vpumpu9PEFK9oyRYiiz+SbfTXiNVR4IXT4ZrkbyjFe2BCApIt1Ggm8oKmAkItMozNijzAxHBhm2PVlbCc6IUVSKV3sNZSHKJtuN79QgRDxgXFq1q/Nc52MqgaayUZonvfQk4aESJiJt/Im6wnAhNAM4AqU7COlxCH9E96qfwDsDp+ZMHli/KbCbQve5PeJmGdR74cB0u2zy7M2fQM0LNELpTFplJJd4qGks+PCTByVkTb7wjV4iI1XC3zMOWxi/XbeIzAcTlIZRdEsO6d8TlKYdxAWt8yJNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BknZ6/vVeDiyYg38ZyZZ7DJX3Z1VRAYQ2Qogo2oC7Jk=;
 b=TZ03SbM+1MUF8cVcEXpTMFxN/asE5MsfnbmRWn+QrEmcV/m0mf89eN1eZnx7YOhCKbn585WXD1kRjv05faFhPDDteezf1/4Ic5fhLImBgy7EuIYURipFQ47spwafABwtPvFLL+mpOPScxXgW/WbT9Fn5827amnb+U0VMAisNT75ukika5b8XXwEUUbFtGD5AUVcX/T491QUtyrBKImqnnDlfsn1oaw/RBLe7QjeJYYdKrniJO6Hxa0dweN7gOZlEGkXQTxa8pNKYPKzQvBgmeQVoy+kj2AzrsSow5wEv4Iun7DDsrRBj5MKE9chOiuvj2LFEjX1FDNH2b8YolF/vEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BknZ6/vVeDiyYg38ZyZZ7DJX3Z1VRAYQ2Qogo2oC7Jk=;
 b=CQ+uAoQXN0auX+lWFK9rilxuwxVaIQOxy6fESEdhUhDsgD5sEqNgihsnHtVjZzVkSplPErbMgA/PHOY2qMsDbRST2yhSdb5NBIZChMdDj9wBm6wQHKpLDpwkSktHTZFUw3c92bD1RMK4MA6GX2qZJlrTAthebHEPV41gMWQe/Qk=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB4445.namprd11.prod.outlook.com (52.135.37.87) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.18; Mon, 16 Dec 2019 17:06:50 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2538.019; Mon, 16 Dec 2019
 17:06:50 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH 52/55] staging: wfx: delayed_unjoin cannot happen
Thread-Topic: [PATCH 52/55] staging: wfx: delayed_unjoin cannot happen
Thread-Index: AQHVtDLPYDhkmxPTK0mSWKbBk04+CQ==
Date:   Mon, 16 Dec 2019 17:03:59 +0000
Message-ID: <20191216170302.29543-53-Jerome.Pouiller@silabs.com>
References: <20191216170302.29543-1-Jerome.Pouiller@silabs.com>
In-Reply-To: <20191216170302.29543-1-Jerome.Pouiller@silabs.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
x-originating-ip: [37.71.187.125]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7427762c-5324-4004-112b-08d7824a5763
x-ms-traffictypediagnostic: MN2PR11MB4445:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB44453DE89998346EAFF037C193510@MN2PR11MB4445.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-forefront-prvs: 02530BD3AA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(346002)(366004)(39850400004)(396003)(136003)(189003)(199004)(110136005)(6486002)(107886003)(36756003)(186003)(316002)(66946007)(54906003)(5660300002)(66574012)(66446008)(66556008)(85182001)(66476007)(76116006)(91956017)(64756008)(2616005)(6506007)(85202003)(2906002)(26005)(71200400001)(6512007)(4326008)(8936002)(81166006)(1076003)(478600001)(86362001)(81156014)(8676002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB4445;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: f+orFObs1m1b2vI6ryPeQRhoLuxu3i+/EilepAm8x41AF+jXF8sJJFNjU3UnSO05kQj5BqQq1uB+pIIFPdacMe9lRtKuJmGMNO/WXZ6yOG4dwTRtCkdoquLMUSV905GTLTArcSf0uB4clq7krAVDKdgMnAmKVnirm5pfJff4YIfM3n5dVnrTpGmNRKKpGpCAaEeGFcnYpOCn8nUhrxJLBo2WUjTrdShhj+fUg8J+JIsEuDAv2F94HjnKgAd/YIxIG6EAI/49ZtRdpyso+yjArGYteO2mJmvb4jLQga+ZiwopJnJTii8mnB9Ik8WBUQpTna1cQe/MLr7mZX2EmCHeOyc643GR6ubq2gX1NMJ2dyBLvL1Pw085//VRJU9K25TGyGjLth6IedI9Q5j7WyvVW31nYUp6MrQAJNZGvzJBLXNI1jOsq9Nj7PtMTx1dW1d9
Content-Type: text/plain; charset="utf-8"
Content-ID: <ACBDD948EC097242957B90EDEBEFA967@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7427762c-5324-4004-112b-08d7824a5763
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Dec 2019 17:03:59.8570
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BVKMSe9Q1lmAg1G12WXfx7gPCN32b4GSN1fYd2A0GjS7pUXQZrMsj70Bui9GFewp+8DkYnt3DvAwJVscm76s5A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4445
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPg0KDQpP
cmlnaW5hbCBjb2RlIGFsbG93cyB0byBkZXRlY3QgYW4gdW5qb2luIHJlcXVlc3QgZHVyaW5nIGEg
c2NhbiBhbmQNCmRlbGF5aW5nIHRoZSB1bmpvaW4gcmVxdWVzdC4gSG93ZXZlciwgaXQgaXMgZmFy
IGVhc2llciB0byBqdXN0IGJsb2NrIHRoZQ0KdW5qb2luIHJlcXVlc3QgdW50aWwgdGhlIGVuZCBv
ZiB0aGUgc2NhbiByZXF1ZXN0Lg0KDQpJbiBmYWN0LCBpdCBpcyBhbHJlYWR5IHRoZSBjYXNlIHNp
bmNlIHNjYW4gYW5kIHVuam9pbiBhcmUgcHJvdGVjdGVkIGJ5DQpjb25mX211dGV4LiBTbywgY3Vy
cmVudGx5LCB0aGUgaGFuZGxpbmcgb2YgZGVsYXllZF91bmpvaW4gaXMganVzdCBkZWFkDQpjb2Rl
Lg0KDQpTaWduZWQtb2ZmLWJ5OiBKw6lyw7RtZSBQb3VpbGxlciA8amVyb21lLnBvdWlsbGVyQHNp
bGFicy5jb20+DQotLS0NCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L3NjYW4uYyB8ICA3ICstLS0tLS0N
CiBkcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jICB8IDE0IC0tLS0tLS0tLS0tLS0tDQogZHJpdmVy
cy9zdGFnaW5nL3dmeC93ZnguaCAgfCAgMSAtDQogMyBmaWxlcyBjaGFuZ2VkLCAxIGluc2VydGlv
bigrKSwgMjEgZGVsZXRpb25zKC0pDQoNCmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4
L3NjYW4uYyBiL2RyaXZlcnMvc3RhZ2luZy93Zngvc2Nhbi5jDQppbmRleCA1NDAwMDliNzIyNDAu
LmJkYmNlNjkyNmU5MSAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvc3RhZ2luZy93Zngvc2Nhbi5jDQor
KysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3NjYW4uYw0KQEAgLTk1LDEyICs5NSw3IEBAIHZvaWQg
d2Z4X2h3X3NjYW5fd29yayhzdHJ1Y3Qgd29ya19zdHJ1Y3QgKndvcmspDQogCW11dGV4X3VubG9j
aygmd3ZpZi0+d2Rldi0+Y29uZl9tdXRleCk7DQogCW11dGV4X3VubG9jaygmd3ZpZi0+c2Nhbl9s
b2NrKTsNCiAJX19pZWVlODAyMTFfc2Nhbl9jb21wbGV0ZWRfY29tcGF0KHd2aWYtPndkZXYtPmh3
LCByZXQgPCAwKTsNCi0JaWYgKHd2aWYtPmRlbGF5ZWRfdW5qb2luKSB7DQotCQl3dmlmLT5kZWxh
eWVkX3Vuam9pbiA9IGZhbHNlOw0KLQkJd2Z4X3R4X2xvY2sod3ZpZi0+d2Rldik7DQotCQlpZiAo
IXNjaGVkdWxlX3dvcmsoJnd2aWYtPnVuam9pbl93b3JrKSkNCi0JCQl3ZnhfdHhfdW5sb2NrKHd2
aWYtPndkZXYpOw0KLQl9IGVsc2UgaWYgKHd2aWYtPmRlbGF5ZWRfbGlua19sb3NzKSB7DQorCWlm
ICh3dmlmLT5kZWxheWVkX2xpbmtfbG9zcykgew0KIAkJd3ZpZi0+ZGVsYXllZF9saW5rX2xvc3Mg
PSBmYWxzZTsNCiAJCXdmeF9jcW1fYnNzbG9zc19zbSh3dmlmLCAxLCAwLCAwKTsNCiAJfQ0KZGlm
ZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4
L3N0YS5jDQppbmRleCA0MzU0YmI4MDgxYzUuLjdhZTc2M2U5NjQ1NSAxMDA2NDQNCi0tLSBhL2Ry
aXZlcnMvc3RhZ2luZy93Zngvc3RhLmMNCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMN
CkBAIC02NiwxMCArNjYsNiBAQCB2b2lkIHdmeF9jcW1fYnNzbG9zc19zbShzdHJ1Y3Qgd2Z4X3Zp
ZiAqd3ZpZiwgaW50IGluaXQsIGludCBnb29kLCBpbnQgYmFkKQ0KIAl3dmlmLT5kZWxheWVkX2xp
bmtfbG9zcyA9IDA7DQogCWNhbmNlbF93b3JrX3N5bmMoJnd2aWYtPmJzc19wYXJhbXNfd29yayk7
DQogDQotCS8qIElmIHdlIGhhdmUgYSBwZW5kaW5nIHVuam9pbiAqLw0KLQlpZiAod3ZpZi0+ZGVs
YXllZF91bmpvaW4pDQotCQlnb3RvIGVuZDsNCi0NCiAJaWYgKGluaXQpIHsNCiAJCXNjaGVkdWxl
X2RlbGF5ZWRfd29yaygmd3ZpZi0+YnNzX2xvc3Nfd29yaywgSFopOw0KIAkJd3ZpZi0+YnNzX2xv
c3Nfc3RhdGUgPSAwOw0KQEAgLTUwMSwxNiArNDk3LDYgQEAgc3RhdGljIHZvaWQgd2Z4X2RvX3Vu
am9pbihzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZikNCiB7DQogCW11dGV4X2xvY2soJnd2aWYtPndkZXYt
PmNvbmZfbXV0ZXgpOw0KIA0KLQlpZiAoIW11dGV4X3RyeWxvY2soJnd2aWYtPnNjYW5fbG9jaykp
IHsNCi0JCWlmICh3dmlmLT5kZWxheWVkX3Vuam9pbikNCi0JCQlkZXZfZGJnKHd2aWYtPndkZXYt
PmRldiwNCi0JCQkJImRlbGF5ZWQgdW5qb2luIGlzIGFscmVhZHkgc2NoZWR1bGVkXG4iKTsNCi0J
CWVsc2UNCi0JCQl3dmlmLT5kZWxheWVkX3Vuam9pbiA9IHRydWU7DQotCQlnb3RvIGRvbmU7DQot
CX0NCi0JbXV0ZXhfdW5sb2NrKCZ3dmlmLT5zY2FuX2xvY2spOw0KLQ0KIAl3dmlmLT5kZWxheWVk
X2xpbmtfbG9zcyA9IGZhbHNlOw0KIA0KIAlpZiAoIXd2aWYtPnN0YXRlKQ0KZGlmZiAtLWdpdCBh
L2RyaXZlcnMvc3RhZ2luZy93Zngvd2Z4LmggYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3dmeC5oDQpp
bmRleCBiNWY3NjNjM2ZhYzcuLjVlN2M5MTFkYjAyNCAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvc3Rh
Z2luZy93Zngvd2Z4LmgNCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93Zngvd2Z4LmgNCkBAIC0xMjIs
NyArMTIyLDYgQEAgc3RydWN0IHdmeF92aWYgew0KIAlzdHJ1Y3Qgd29ya19zdHJ1Y3QJc2V0X2N0
c193b3JrOw0KIA0KIAlpbnQJCQlqb2luX2NvbXBsZXRlX3N0YXR1czsNCi0JYm9vbAkJCWRlbGF5
ZWRfdW5qb2luOw0KIAlzdHJ1Y3Qgd29ya19zdHJ1Y3QJdW5qb2luX3dvcms7DQogDQogCS8qIGF2
b2lkIHNvbWUgb3BlcmF0aW9ucyBpbiBwYXJhbGxlbCB3aXRoIHNjYW4gKi8NCi0tIA0KMi4yMC4x
DQo=
