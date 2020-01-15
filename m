Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 878F113C092
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 13:19:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732546AbgAOMTn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 07:19:43 -0500
Received: from mail-co1nam11on2084.outbound.protection.outlook.com ([40.107.220.84]:24056
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730408AbgAOMM3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jan 2020 07:12:29 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hYnnIqhHJHnksMtdod8FEFFEX8TMstlZXSvwaS+76MgfFcjj5Xjg+VzHvsFsSPm+gKOin1JgudhzFGn7NLncE4gZH0nA3U2nhwvEtPbJiFdiFJlrwTRROxCqw8dYuHK8EWQtX3em9lipheZpusGfxvCI6BJ5NHT6k+hZt4d5WF3NrId6Df/UZPIuhzrpR4ssm73kDvre/j8zZ9YSid0CcOSnSbr42E5AKU3hdomOqeOu1k35d1QnCIx6VrOfVk57KKaQFvZydC+M1ecgw8unaZ5h/F5/tvUOjtQoBQpORvSjJOqVJfTCfBQVvQlYw1hNGJ1GYjmz7lZQueLqI1Ffww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VwI3KjAJe6wvPLS63CfYdnAwDrZRt0I+K5mruf2SzxI=;
 b=l3Y0pPJEFd1Pb+gpab4kIMyuEAuBCKxrHhbUwHC1lTYD6t8SW+C35bDT0e9WHUM2+m9XBsivuiDVphJZx0BbVsAJfHDdPnBQmoijcaXKnz9xgr3H5Pwi1Nus9j3/WcAK3hh0u85PiBF65i94WFD7tfUpuQ3vmO0alvvNNYR+auACH+Q20kFLTxPsAEwNOzMFMeOcEQ5UGVRYdstYZpzzm1Su6leOrF36pTmDDEeilehf6FElbZicAJK+SrEP1WDieQ/mbbaxmgTWGGg+RLJX5GU9dZz9jcjlYMposwBitxqCXjQYHaQjnuPle9fW/FojzX4aWC1wBXU0SQxObwmvLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VwI3KjAJe6wvPLS63CfYdnAwDrZRt0I+K5mruf2SzxI=;
 b=SE8z5CRREtQi5DMxVpW4+SFe0jFrijO1Jp7/A7lvU/b1DPuDw8voN/n1UbUlWTt6VD8gP31I8XTY2CRX7WgwdPReUjbditmpOpM5F80MnK1MYWip7MkczLhlupn34dFn8Tr4d4CoWaqcBBEJwU3XuI9t2pMxq5okpuDNOYqE06U=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB3934.namprd11.prod.outlook.com (10.255.180.212) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.20; Wed, 15 Jan 2020 12:12:15 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2623.018; Wed, 15 Jan 2020
 12:12:15 +0000
Received: from pc-42.silabs.com (37.71.187.125) by PR2PR09CA0009.eurprd09.prod.outlook.com (2603:10a6:101:16::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.18 via Frontend Transport; Wed, 15 Jan 2020 12:12:14 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH 05/65] staging: wfx: simplify hif_set_tx_rate_retry_policy()
 usage
Thread-Topic: [PATCH 05/65] staging: wfx: simplify
 hif_set_tx_rate_retry_policy() usage
Thread-Index: AQHVy50GWkyiLFnTvUOIaynlklVO2w==
Date:   Wed, 15 Jan 2020 12:12:15 +0000
Message-ID: <20200115121041.10863-6-Jerome.Pouiller@silabs.com>
References: <20200115121041.10863-1-Jerome.Pouiller@silabs.com>
In-Reply-To: <20200115121041.10863-1-Jerome.Pouiller@silabs.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR2PR09CA0009.eurprd09.prod.outlook.com
 (2603:10a6:101:16::21) To MN2PR11MB4063.namprd11.prod.outlook.com
 (2603:10b6:208:13f::22)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.25.0
x-originating-ip: [37.71.187.125]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: dc86e444-50af-4163-4d28-08d799b42891
x-ms-traffictypediagnostic: MN2PR11MB3934:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB39348D22F45C03EDE5A1315193370@MN2PR11MB3934.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 02830F0362
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39850400004)(396003)(136003)(376002)(366004)(346002)(199004)(189003)(54906003)(110136005)(86362001)(956004)(107886003)(2616005)(316002)(36756003)(71200400001)(52116002)(7696005)(478600001)(8936002)(81156014)(8676002)(4326008)(81166006)(6486002)(2906002)(26005)(66946007)(16526019)(186003)(5660300002)(66574012)(1076003)(66556008)(64756008)(66446008)(85182001)(66476007)(85202003);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB3934;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: m3/FFN0Mx4c7Vzjxl5UeXjqhIIfJ7KYNV4JmGM6PxwdWEJJNEphAmV2sl7k6zpbX96bjnRXpaQXw8Tb6LJl0fKZlgt2rmMVtLyX/roQz8hd54KzKp8Yh5ASfOb7GjfaDzAqt4JP7RKOm0KVyl8wdPWzLwy2XCyxYUq6J69OIVSQgitmftBmtVQmKvQpVDs+g5mynHSQOBlEDWIM6SZu2HRActiyNI4LErApHLM+rI9jpj4eU20Jo+Qj/1FAv/YlsQoflsyQPjWmpJtVn3tiexGKvIKz/DGOTseRwIGYHcOT5FwNwb2xJJKXzQmrTPIIRDymPRo/9xRAfy7r7PeAQNQ+QHE7yobOoCmo/Kxt9FRlEsZogog3t7Kkulk9HnlntVtZIfbGuBtm1lgU8A7chqTtPH5NJpVzZR46UdETap7MSOAKwzSLIS5r2ue3Ki0x4
Content-Type: text/plain; charset="utf-8"
Content-ID: <E2E87946826BAE4BA392DB1E345F1E02@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dc86e444-50af-4163-4d28-08d799b42891
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2020 12:12:15.2027
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jLKuwobqKv0R/HbenwU3E41e3Ps6FHwyVQvdppvP9avellDnf6pZkWxr3DLHja0iazvtO0ELCcTqQ2VBhyYFZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3934
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVGhl
IHN0cnVjdHVyZSBoaWZfbWliX3NldF90eF9yYXRlX3JldHJ5X3BvbGljeSBjb21lIGZyb20gaGFy
ZHdhcmUKQVBJLiBJdCBpcyBub3QgaW50ZW5kZWQgdG8gYmUgbWFuaXB1bGF0ZWQgaW4gdXBwZXIg
bGF5ZXJzIG9mIHRoZSBkcml2ZXIuCgpTbywgdGhpcyBwYXRjaCByZWxvY2F0ZSBoYW5kbGluZyBv
ZiB0aGlzIHN0cnVjdHVyZSB0bwpoaWZfc2V0X3R4X3JhdGVfcmV0cnlfcG9saWN5KCkgKHRoZSBs
b3cgbGV2ZWwgZnVuY3Rpb24pLgoKU2lnbmVkLW9mZi1ieTogSsOpcsO0bWUgUG91aWxsZXIgPGpl
cm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgotLS0KIGRyaXZlcnMvc3RhZ2luZy93ZngvZGF0YV90
eC5jICAgIHwgMTYgKysrLS0tLS0tLS0tLS0tLQogZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfdHhf
bWliLmggfCAyMyArKysrKysrKysrKysrKysrKystLS0tLQogZHJpdmVycy9zdGFnaW5nL3dmeC9z
dGEuYyAgICAgICAgfCAgMiArLQogZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuaCAgICAgICAgfCAg
MSArCiA0IGZpbGVzIGNoYW5nZWQsIDIzIGluc2VydGlvbnMoKyksIDE5IGRlbGV0aW9ucygtKQoK
ZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93ZngvZGF0YV90eC5jIGIvZHJpdmVycy9zdGFn
aW5nL3dmeC9kYXRhX3R4LmMKaW5kZXggZmI1MWM1OTEwYWNlLi42MDQ1OTI5OWEzYTkgMTAwNjQ0
Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93ZngvZGF0YV90eC5jCisrKyBiL2RyaXZlcnMvc3RhZ2lu
Zy93ZngvZGF0YV90eC5jCkBAIC0yMTcsOSArMjE3LDggQEAgc3RhdGljIHZvaWQgd2Z4X3R4X3Bv
bGljeV9wdXQoc3RydWN0IHdmeF92aWYgKnd2aWYsIGludCBpZHgpCiAKIHN0YXRpYyBpbnQgd2Z4
X3R4X3BvbGljeV91cGxvYWQoc3RydWN0IHdmeF92aWYgKnd2aWYpCiB7Ci0Jc3RydWN0IGhpZl9t
aWJfc2V0X3R4X3JhdGVfcmV0cnlfcG9saWN5ICphcmcgPQotCQlremFsbG9jKHN0cnVjdF9zaXpl
KGFyZywgdHhfcmF0ZV9yZXRyeV9wb2xpY3ksIDEpLCBHRlBfS0VSTkVMKTsKIAlzdHJ1Y3QgdHhf
cG9saWN5ICpwb2xpY2llcyA9IHd2aWYtPnR4X3BvbGljeV9jYWNoZS5jYWNoZTsKKwl1OCB0bXBf
cmF0ZXNbMTJdOwogCWludCBpOwogCiAJZG8gewpAQCAtMjMwLDIyICsyMjksMTMgQEAgc3RhdGlj
IGludCB3ZnhfdHhfcG9saWN5X3VwbG9hZChzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZikKIAkJCQlicmVh
azsKIAkJaWYgKGkgPCBISUZfTUlCX05VTV9UWF9SQVRFX1JFVFJZX1BPTElDSUVTKSB7CiAJCQlw
b2xpY2llc1tpXS51cGxvYWRlZCA9IDE7Ci0JCQlhcmctPm51bV90eF9yYXRlX3BvbGljaWVzID0g
MTsKLQkJCWFyZy0+dHhfcmF0ZV9yZXRyeV9wb2xpY3lbMF0ucG9saWN5X2luZGV4ID0gaTsKLQkJ
CWFyZy0+dHhfcmF0ZV9yZXRyeV9wb2xpY3lbMF0uc2hvcnRfcmV0cnlfY291bnQgPSAyNTU7Ci0J
CQlhcmctPnR4X3JhdGVfcmV0cnlfcG9saWN5WzBdLmxvbmdfcmV0cnlfY291bnQgPSAyNTU7Ci0J
CQlhcmctPnR4X3JhdGVfcmV0cnlfcG9saWN5WzBdLmZpcnN0X3JhdGVfc2VsID0gMTsKLQkJCWFy
Zy0+dHhfcmF0ZV9yZXRyeV9wb2xpY3lbMF0udGVybWluYXRlID0gMTsKLQkJCWFyZy0+dHhfcmF0
ZV9yZXRyeV9wb2xpY3lbMF0uY291bnRfaW5pdCA9IDE7Ci0JCQltZW1jcHkoJmFyZy0+dHhfcmF0
ZV9yZXRyeV9wb2xpY3lbMF0ucmF0ZXMsCi0JCQkgICAgICAgcG9saWNpZXNbaV0ucmF0ZXMsIHNp
emVvZihwb2xpY2llc1tpXS5yYXRlcykpOworCQkJbWVtY3B5KHRtcF9yYXRlcywgcG9saWNpZXNb
aV0ucmF0ZXMsIHNpemVvZih0bXBfcmF0ZXMpKTsKIAkJCXNwaW5fdW5sb2NrX2JoKCZ3dmlmLT50
eF9wb2xpY3lfY2FjaGUubG9jayk7Ci0JCQloaWZfc2V0X3R4X3JhdGVfcmV0cnlfcG9saWN5KHd2
aWYsIGFyZyk7CisJCQloaWZfc2V0X3R4X3JhdGVfcmV0cnlfcG9saWN5KHd2aWYsIGksIHRtcF9y
YXRlcyk7CiAJCX0gZWxzZSB7CiAJCQlzcGluX3VubG9ja19iaCgmd3ZpZi0+dHhfcG9saWN5X2Nh
Y2hlLmxvY2spOwogCQl9CiAJfSB3aGlsZSAoaSA8IEhJRl9NSUJfTlVNX1RYX1JBVEVfUkVUUllf
UE9MSUNJRVMpOwotCWtmcmVlKGFyZyk7CiAJcmV0dXJuIDA7CiB9CiAKZGlmZiAtLWdpdCBhL2Ry
aXZlcnMvc3RhZ2luZy93ZngvaGlmX3R4X21pYi5oIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZf
dHhfbWliLmgKaW5kZXggYjFlZWRhMmEzYWIzLi5lZjAzM2E0MDkzODEgMTAwNjQ0Ci0tLSBhL2Ry
aXZlcnMvc3RhZ2luZy93ZngvaGlmX3R4X21pYi5oCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93Zngv
aGlmX3R4X21pYi5oCkBAIC0xODEsMTMgKzE4MSwyNiBAQCBzdGF0aWMgaW5saW5lIGludCBoaWZf
c2V0X2Fzc29jaWF0aW9uX21vZGUoc3RydWN0IHdmeF92aWYgKnd2aWYsCiB9CiAKIHN0YXRpYyBp
bmxpbmUgaW50IGhpZl9zZXRfdHhfcmF0ZV9yZXRyeV9wb2xpY3koc3RydWN0IHdmeF92aWYgKnd2
aWYsCi0JCQkJCSAgICAgICBzdHJ1Y3QgaGlmX21pYl9zZXRfdHhfcmF0ZV9yZXRyeV9wb2xpY3kg
KmFyZykKKwkJCQkJICAgICAgIGludCBwb2xpY3lfaW5kZXgsIHVpbnQ4X3QgKnJhdGVzKQogewot
CXNpemVfdCBzaXplID0gc3RydWN0X3NpemUoYXJnLCB0eF9yYXRlX3JldHJ5X3BvbGljeSwKLQkJ
CQkgIGFyZy0+bnVtX3R4X3JhdGVfcG9saWNpZXMpOworCXN0cnVjdCBoaWZfbWliX3NldF90eF9y
YXRlX3JldHJ5X3BvbGljeSAqYXJnOworCXNpemVfdCBzaXplID0gc3RydWN0X3NpemUoYXJnLCB0
eF9yYXRlX3JldHJ5X3BvbGljeSwgMSk7CisJaW50IHJldDsKIAotCXJldHVybiBoaWZfd3JpdGVf
bWliKHd2aWYtPndkZXYsIHd2aWYtPmlkLAotCQkJICAgICBISUZfTUlCX0lEX1NFVF9UWF9SQVRF
X1JFVFJZX1BPTElDWSwgYXJnLCBzaXplKTsKKwlhcmcgPSBremFsbG9jKHNpemUsIEdGUF9LRVJO
RUwpOworCWFyZy0+bnVtX3R4X3JhdGVfcG9saWNpZXMgPSAxOworCWFyZy0+dHhfcmF0ZV9yZXRy
eV9wb2xpY3lbMF0ucG9saWN5X2luZGV4ID0gcG9saWN5X2luZGV4OworCWFyZy0+dHhfcmF0ZV9y
ZXRyeV9wb2xpY3lbMF0uc2hvcnRfcmV0cnlfY291bnQgPSAyNTU7CisJYXJnLT50eF9yYXRlX3Jl
dHJ5X3BvbGljeVswXS5sb25nX3JldHJ5X2NvdW50ID0gMjU1OworCWFyZy0+dHhfcmF0ZV9yZXRy
eV9wb2xpY3lbMF0uZmlyc3RfcmF0ZV9zZWwgPSAxOworCWFyZy0+dHhfcmF0ZV9yZXRyeV9wb2xp
Y3lbMF0udGVybWluYXRlID0gMTsKKwlhcmctPnR4X3JhdGVfcmV0cnlfcG9saWN5WzBdLmNvdW50
X2luaXQgPSAxOworCW1lbWNweSgmYXJnLT50eF9yYXRlX3JldHJ5X3BvbGljeVswXS5yYXRlcywg
cmF0ZXMsCisJICAgICAgIHNpemVvZihhcmctPnR4X3JhdGVfcmV0cnlfcG9saWN5WzBdLnJhdGVz
KSk7CisJcmV0ID0gaGlmX3dyaXRlX21pYih3dmlmLT53ZGV2LCB3dmlmLT5pZCwKKwkJCSAgICBI
SUZfTUlCX0lEX1NFVF9UWF9SQVRFX1JFVFJZX1BPTElDWSwgYXJnLCBzaXplKTsKKwlrZnJlZShh
cmcpOworCXJldHVybiByZXQ7CiB9CiAKIHN0YXRpYyBpbmxpbmUgaW50IGhpZl9zZXRfbWFjX2Fk
ZHJfY29uZGl0aW9uKHN0cnVjdCB3ZnhfdmlmICp3dmlmLApkaWZmIC0tZ2l0IGEvZHJpdmVycy9z
dGFnaW5nL3dmeC9zdGEuYyBiL2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMKaW5kZXggOTAxMWI1
ZDc4NzA2Li44ZjUzYTc4ZDcyMTUgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93Zngvc3Rh
LmMKKysrIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYwpAQCAtMTksNyArMTksNyBAQAogCiAj
ZGVmaW5lIEhJRl9NQVhfQVJQX0lQX0FERFJUQUJMRV9FTlRSSUVTIDIKIAotc3RhdGljIHUzMiB3
ZnhfcmF0ZV9tYXNrX3RvX2h3KHN0cnVjdCB3ZnhfZGV2ICp3ZGV2LCB1MzIgcmF0ZXMpCit1MzIg
d2Z4X3JhdGVfbWFza190b19odyhzdHJ1Y3Qgd2Z4X2RldiAqd2RldiwgdTMyIHJhdGVzKQogewog
CWludCBpOwogCXUzMiByZXQgPSAwOwpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9z
dGEuaCBiL2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmgKaW5kZXggOTU5NWUxZmM2MGRiLi5iNWQ4
ZDY0OTQxNTcgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmgKKysrIGIvZHJp
dmVycy9zdGFnaW5nL3dmeC9zdGEuaApAQCAtOTIsNSArOTIsNiBAQCB2b2lkIHdmeF9zdXNwZW5k
X3Jlc3VtZShzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiwKIHZvaWQgd2Z4X2NxbV9ic3Nsb3NzX3NtKHN0
cnVjdCB3ZnhfdmlmICp3dmlmLCBpbnQgaW5pdCwgaW50IGdvb2QsIGludCBiYWQpOwogdm9pZCB3
ZnhfdXBkYXRlX2ZpbHRlcmluZyhzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZik7CiBpbnQgd2Z4X2Z3ZF9w
cm9iZV9yZXEoc3RydWN0IHdmeF92aWYgKnd2aWYsIGJvb2wgZW5hYmxlKTsKK3UzMiB3ZnhfcmF0
ZV9tYXNrX3RvX2h3KHN0cnVjdCB3ZnhfZGV2ICp3ZGV2LCB1MzIgcmF0ZXMpOwogCiAjZW5kaWYg
LyogV0ZYX1NUQV9IICovCi0tIAoyLjI1LjAKCg==
