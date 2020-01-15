Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3876E13C487
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 15:00:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730395AbgAON7v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 08:59:51 -0500
Received: from mail-eopbgr770084.outbound.protection.outlook.com ([40.107.77.84]:58049
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729406AbgAONzZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jan 2020 08:55:25 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iuzIW8QuJf0+jrhB643So+ZWceb+0voqmwIpQ9+03Bx11KO+GPyKKczcrqWXNWVZzJ9AOmK4zP7XfHfefLtOQCxM+XNF/Gkr3JneuCAry/1gCO2Qge5ItUvSYPF1PI8snwCOVXdZEoD5GZgatlQGs+1SJ0A3Zs+gsfgEyddNQYhAh20ZYuNYhaQaVkFsadnoFxJ6TGdPc6nxjYKb28DCw0OLAWmSdOA48DiRJ+5vGhYjdc0vIK74gH8fj3wRDDaj/eOYlpQqBA0lalH0OlxrERkusI3XoM108BLhpw6V1IXTKLtOh3P0yELsR+/N6opCLWnWDUkYoa9naRSZvQFCgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XJqXurW4/VAnWUE+JXZ5tJhNqqZRExJP6P/RNttxtCI=;
 b=UOiiiKFaiLlk55xWlNLFp0X8v/z6FCpQJ9h8EckyGXYGsK1rKNcKM/cxng2Y8CjrVoADkP/5nu8LZq1/xl/zRzGvs9U2t/FKo2p/EQ23/i/zQKOlRRtltN7dUCiABf+qovxmJKpRQbKZASaoWT2vP7pN7UfzyRrlP4+P0SGiFj0Mvep8SWG8IEqSTnykn5Tu4pf+8lUBqlekFVoiT5U2EcRKMFQVXvaqhFUxU9huYKVRf28W2vq91+XEgBcIh5P2x7zMbB1S0eCqt4KKInERriCE6En4KS2nR+RDk0kErKA5x7OTKVfSUOJfqUdtX1fW9C6tE1duF28emckZ4zC2kQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XJqXurW4/VAnWUE+JXZ5tJhNqqZRExJP6P/RNttxtCI=;
 b=GZ/fW5ly5kM89fmNfoaCE0HSzkqvL55QvsbgVZxDM7u4e9gSHPjljBJw80YZZ9DYrcrpymbaPsPrazP6muNjGRR9+mc4EmLHPjhd6x+b1cushKGiBBHQSacYNn7thazaHpVgAUmOinj2Jwt8UupIb+uiX3joXQ2pZAToib2lO0c=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB3661.namprd11.prod.outlook.com (20.178.252.33) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.18; Wed, 15 Jan 2020 13:55:18 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2623.018; Wed, 15 Jan 2020
 13:55:18 +0000
Received: from pc-42.home (2a01:e35:8bf5:66a0:3dbe:4cb5:6059:a948) by PR2P264CA0008.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.18 via Frontend Transport; Wed, 15 Jan 2020 13:54:51 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH v2 34/65] staging: wfx: simplify hif_set_data_filtering()
Thread-Topic: [PATCH v2 34/65] staging: wfx: simplify hif_set_data_filtering()
Thread-Index: AQHVy6tcJMjL6pXhYEaaSdhDycP7yA==
Date:   Wed, 15 Jan 2020 13:54:52 +0000
Message-ID: <20200115135338.14374-35-Jerome.Pouiller@silabs.com>
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
x-ms-office365-filtering-correlation-id: 2f8b70c5-0313-40f9-d226-08d799c27ecb
x-ms-traffictypediagnostic: MN2PR11MB3661:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB36610EB2BA42EC874CBD641A93370@MN2PR11MB3661.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-forefront-prvs: 02830F0362
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(376002)(396003)(136003)(346002)(366004)(199004)(189003)(8886007)(6486002)(316002)(54906003)(71200400001)(36756003)(6506007)(66476007)(66446008)(66946007)(110136005)(8676002)(81166006)(81156014)(478600001)(86362001)(2616005)(4326008)(66574012)(2906002)(107886003)(1076003)(16526019)(186003)(85202003)(5660300002)(6512007)(52116002)(64756008)(66556008)(85182001)(8936002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB3661;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: J9i22Dsrps37SHzLzUkekox6WjxYdqeKNj5o6CKPxy8ssREkAFEYpK3t8vLLUNPnJaxHCRaN2S1DhroZrLgo9YvQ4RKLoe0UgQ26oH2hkVO8WXGFBl+YwYl9hJsYAdV+Nl/vRvq2zXJBer6MUTVA7DfHvPvSBJItQX2lb8Kj6VNxqEmTkEqoT/7NdBZbFBmmp+Sj3Ynp0HBWthV9EC6zj/O1zSgTwxw1N2sm6YTvA9RQPWog2XyarPAQSra7urINcVatUxjYLViD4q7U9wl15nkos0jxLvzPaGdedtkJyzyMnuN+oalFRfM3Z5JvgJVDGi/hrwCn0OaMlaiCjYGl5TrvRI87dx3wTY+U10pTtboXbcI8YcvBFWZ63G9aHa+e4dIW9UQjnLdqfnPKFNk5m2n46Y2vEP+oPYHlQZ7ycnOkxswDt2BeoJvU9PCEgKsR
Content-Type: text/plain; charset="utf-8"
Content-ID: <F972718BAA80574EB0939D7BCCC8E445@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f8b70c5-0313-40f9-d226-08d799c27ecb
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2020 13:54:52.8045
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: //fBWYRMmuKXqiORZIloRFN3RHujFYjB3HRFNJseVWKHo+lsm4qVnF+arfnXdCzbPyqZltRLoJTcVnEosKWLyg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3661
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVGhl
IHN0cnVjdHVyZSBoaWZfbWliX3NldF9kYXRhX2ZpbHRlcmluZyBjb21lIGZyb20gaGFyZHdhcmUg
QVBJLiBJdCBpcwpub3QgaW50ZW5kZWQgdG8gYmUgbWFuaXB1bGF0ZWQgaW4gdXBwZXIgbGF5ZXJz
IG9mIHRoZSBkcml2ZXIuCgpJbiBhZGQsIGN1cnJlbnQgY29kZSBmb3IgaGlmX3NldF9kYXRhX2Zp
bHRlcmluZygpIGlzIHRvbyBkdW1iLiBJdCBzaG91bGQKcGFjayBkYXRhIHdpdGggaGFyZHdhcmUg
cmVwcmVzZW50YXRpb24gaW5zdGVhZCBvZiBsZWF2aW5nIGFsbCB3b3JrIHRvCnRoZSBjYWxsZXIu
CgpTaWduZWQtb2ZmLWJ5OiBKw6lyw7RtZSBQb3VpbGxlciA8amVyb21lLnBvdWlsbGVyQHNpbGFi
cy5jb20+Ci0tLQogZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfdHhfbWliLmggfCAgOSArKysrKysr
LS0KIGRyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMgICAgICAgIHwgMTMgKysrKy0tLS0tLS0tLQog
MiBmaWxlcyBjaGFuZ2VkLCAxMSBpbnNlcnRpb25zKCspLCAxMSBkZWxldGlvbnMoLSkKCmRpZmYg
LS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl90eF9taWIuaCBiL2RyaXZlcnMvc3RhZ2lu
Zy93ZngvaGlmX3R4X21pYi5oCmluZGV4IDZlOGIwNTBjYmMyNS4uZWUyMmM3MTY5ZmFiIDEwMDY0
NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl90eF9taWIuaAorKysgYi9kcml2ZXJzL3N0
YWdpbmcvd2Z4L2hpZl90eF9taWIuaApAQCAtMjY3LDEwICsyNjcsMTUgQEAgc3RhdGljIGlubGlu
ZSBpbnQgaGlmX3NldF9jb25maWdfZGF0YV9maWx0ZXIoc3RydWN0IHdmeF92aWYgKnd2aWYsCiB9
CiAKIHN0YXRpYyBpbmxpbmUgaW50IGhpZl9zZXRfZGF0YV9maWx0ZXJpbmcoc3RydWN0IHdmeF92
aWYgKnd2aWYsCi0JCQkJCSBzdHJ1Y3QgaGlmX21pYl9zZXRfZGF0YV9maWx0ZXJpbmcgKmFyZykK
KwkJCQkJIGJvb2wgZW5hYmxlLCBib29sIGludmVydCkKIHsKKwlzdHJ1Y3QgaGlmX21pYl9zZXRf
ZGF0YV9maWx0ZXJpbmcgdmFsID0geworCQkuZW5hYmxlID0gZW5hYmxlLAorCQkuaW52ZXJ0X21h
dGNoaW5nID0gaW52ZXJ0LAorCX07CisKIAlyZXR1cm4gaGlmX3dyaXRlX21pYih3dmlmLT53ZGV2
LCB3dmlmLT5pZCwKLQkJCSAgICAgSElGX01JQl9JRF9TRVRfREFUQV9GSUxURVJJTkcsIGFyZywg
c2l6ZW9mKCphcmcpKTsKKwkJCSAgICAgSElGX01JQl9JRF9TRVRfREFUQV9GSUxURVJJTkcsICZ2
YWwsIHNpemVvZih2YWwpKTsKIH0KIAogc3RhdGljIGlubGluZSBpbnQgaGlmX2tlZXBfYWxpdmVf
cGVyaW9kKHN0cnVjdCB3ZnhfdmlmICp3dmlmLCBpbnQgcGVyaW9kKQpkaWZmIC0tZ2l0IGEvZHJp
dmVycy9zdGFnaW5nL3dmeC9zdGEuYyBiL2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMKaW5kZXgg
MjcyNDhlYTYyYWVhLi41ODgwOTQ0ODZhN2EgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93
Zngvc3RhLmMKKysrIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYwpAQCAtMTE4LDE2ICsxMTgs
MTMgQEAgc3RhdGljIGludCB3Znhfc2V0X21jYXN0X2ZpbHRlcihzdHJ1Y3Qgd2Z4X3ZpZiAqd3Zp
ZiwKIHsKIAlpbnQgaSwgcmV0OwogCXN0cnVjdCBoaWZfbWliX2NvbmZpZ19kYXRhX2ZpbHRlciBj
b25maWcgPSB7IH07Ci0Jc3RydWN0IGhpZl9taWJfc2V0X2RhdGFfZmlsdGVyaW5nIGZpbHRlcl9k
YXRhID0geyB9OwogCXN0cnVjdCBoaWZfbWliX21hY19hZGRyX2RhdGFfZnJhbWVfY29uZGl0aW9u
IGZpbHRlcl9hZGRyX3ZhbCA9IHsgfTsKIAogCS8vIFRlbXBvcmFyeSB3b3JrYXJvdW5kIGZvciBm
aWx0ZXJzCi0JcmV0dXJuIGhpZl9zZXRfZGF0YV9maWx0ZXJpbmcod3ZpZiwgJmZpbHRlcl9kYXRh
KTsKKwlyZXR1cm4gaGlmX3NldF9kYXRhX2ZpbHRlcmluZyh3dmlmLCBmYWxzZSwgdHJ1ZSk7CiAK
LQlpZiAoIWZwLT5lbmFibGUpIHsKLQkJZmlsdGVyX2RhdGEuZW5hYmxlID0gMDsKLQkJcmV0dXJu
IGhpZl9zZXRfZGF0YV9maWx0ZXJpbmcod3ZpZiwgJmZpbHRlcl9kYXRhKTsKLQl9CisJaWYgKCFm
cC0+ZW5hYmxlKQorCQlyZXR1cm4gaGlmX3NldF9kYXRhX2ZpbHRlcmluZyh3dmlmLCBmYWxzZSwg
dHJ1ZSk7CiAKIAkvLyBBMSBBZGRyZXNzIG1hdGNoIG9uIGxpc3QKIAlmb3IgKGkgPSAwOyBpIDwg
ZnAtPm51bV9hZGRyZXNzZXM7IGkrKykgewpAQCAtMTU0LDkgKzE1MSw3IEBAIHN0YXRpYyBpbnQg
d2Z4X3NldF9tY2FzdF9maWx0ZXIoc3RydWN0IHdmeF92aWYgKnd2aWYsCiAJaWYgKHJldCkKIAkJ
cmV0dXJuIHJldDsKIAotCWZpbHRlcl9kYXRhLmVuYWJsZSA9IDE7Ci0JZmlsdGVyX2RhdGEuaW52
ZXJ0X21hdGNoaW5nID0gMTsgLy8gZGlzY2FyZCBhbGwgYnV0IG1hdGNoaW5nIGZyYW1lcwotCXJl
dCA9IGhpZl9zZXRfZGF0YV9maWx0ZXJpbmcod3ZpZiwgJmZpbHRlcl9kYXRhKTsKKwlyZXQgPSBo
aWZfc2V0X2RhdGFfZmlsdGVyaW5nKHd2aWYsIHRydWUsIHRydWUpOwogCiAJcmV0dXJuIHJldDsK
IH0KLS0gCjIuMjUuMAoK
