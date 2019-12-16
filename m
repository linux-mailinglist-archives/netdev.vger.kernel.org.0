Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E4F01210F8
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 18:07:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728079AbfLPRHj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 12:07:39 -0500
Received: from mail-eopbgr690046.outbound.protection.outlook.com ([40.107.69.46]:24384
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727700AbfLPRHh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Dec 2019 12:07:37 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fy9x5Jpm/aekL+mwATz5dcIdto09J0Vlb/2bwTewX6g9MSf5pYBnWrjWhayFkUEzBfpg5wps0aYBeZQrPzQZVpFRoORXqJzjE5kLU27KPF/8ZSoz/VUhmZWqgOUlNRhG58c+vu1XI0S18YjIrTHRMP730bzy+JZj+J11k/K0nCyUZNc6Spg1wh/jKybN6bMb/dtIEHQqRVd/7mg7RU8JqOMbzzVsz6PfbYpNY456+7c+GNIat7JVMhWVlUPWDl2u5gQCHsx7HTwpIiMleqN7UID1O/PLITIMWEgC9HzB0ignLXRxKTLelpriqKUNOcGWMXTtpCPbsEEPD1lc7Mr1tg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m9A9zpFh+K27vg4ccCl/RIyP5HQhaCCjH9mzbuVqpUM=;
 b=S33r2+06UmSiD7TRB3zpskjxn1FGNN8k0p6eRZmcdhYKMkl+nO/2nrOsnXPlYin/FGfJt2DWHsAyCrOfvKiUChk2ShP/93IOEgfc0ctwrHIC46fIleVdSR0vBBCq1U79djHXlBFklzOi88duvdFq2IZ8LBItnFVgo+0z/TRcOb3kC7lzannHhGIeJ/Exba1LEmMkFzf+BrYHXjjbsPDWuliBCP2AoTGvslfsOdIPFcK0HnvuSU+A4q7rc0rvNhtckaWzmG0rFJTscWsv6TM/dTH4HPBquK6sv2z+Mdr4iU7he+vfivlqUtPHLun3i3CcinLOT8mlJ/3EQLR7TmjwJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m9A9zpFh+K27vg4ccCl/RIyP5HQhaCCjH9mzbuVqpUM=;
 b=BcbBJ1wTObku8xs77lbgeCaHRCRT6oneWavPLp89UZGvR6Y5Mq9ZNvpb1GwCyh+CpH6sZX3vkj5ugGYV7s2DgUD+zzcRntu139D4vgXaZmRL+ChfBnJ21VPhsuzocPBl5iI+N9ZYjuLmGtSiWMxVUmVx32YHJDmqFaVyfsrfX1c=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB4142.namprd11.prod.outlook.com (20.179.149.157) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.15; Mon, 16 Dec 2019 17:06:41 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2538.019; Mon, 16 Dec 2019
 17:06:41 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH 38/55] staging: wfx: prefer a bitmask instead of an array of
 boolean
Thread-Topic: [PATCH 38/55] staging: wfx: prefer a bitmask instead of an array
 of boolean
Thread-Index: AQHVtDLLrE8YN2iofkmCN8416toKYA==
Date:   Mon, 16 Dec 2019 17:03:53 +0000
Message-ID: <20191216170302.29543-39-Jerome.Pouiller@silabs.com>
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
x-ms-office365-filtering-correlation-id: a7348c68-6fcb-4ba6-2e52-08d7824a523b
x-ms-traffictypediagnostic: MN2PR11MB4142:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB4142F83ED0B453C31E45D8CC93510@MN2PR11MB4142.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1060;
x-forefront-prvs: 02530BD3AA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(396003)(346002)(136003)(376002)(39850400004)(199004)(189003)(6512007)(71200400001)(91956017)(6486002)(8676002)(2906002)(54906003)(81166006)(81156014)(186003)(76116006)(478600001)(36756003)(85182001)(85202003)(6666004)(66556008)(66476007)(66446008)(64756008)(1076003)(66574012)(316002)(2616005)(4326008)(6506007)(26005)(8936002)(110136005)(5660300002)(107886003)(66946007)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB4142;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Mx9QREP1nyt71f4b3nwz0Slv6+YdlNMH7f3vzkbKAqeLngi4m5gS+6v3cfRP+wwrsK99WlP1572OCj0Gl0eJvImuBZYWitYz+xS97DU3fJLQ9Z3zyfDHvBZGBN1oy4+wVnGYv8JHadTauTe3zIwtI8pa0IrBvmRBveoBl/swBb7+8w3TTYSW0lU7KXH7m5gPsQO0qB0ErR0EEuw27vIXMpx1Q5IC8K67pJSH7hnrtfxeXFPpRxG2cYlWNltSsGB7XOJgZj2OHAB3gMmfKZeR94Y4avIqB8V3s7BY3nwsFnD6roBTYUFWa3orOdo38K1Bd/+Pdp+5vHHMMfoQz9ExCME52nTfSTkFsd1yHBS8u2C4YE7XdDZ8SQZtfDjJIafvErGRhRNTNOq/O/dnczKV8WrB9aZC9GW4QCc8rhoCTC+jA6RejOWF2Tu9fpCw9WfX
Content-Type: text/plain; charset="utf-8"
Content-ID: <25463E47C800924BBD304B8C1DFBD716@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a7348c68-6fcb-4ba6-2e52-08d7824a523b
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Dec 2019 17:03:53.0089
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Klg72da8VaNNc8yl7Cnk1sy7ZO2jopGjP2XzbQu4xoRBHHS/j9z3Qa5xomwIbbuILwUHeMavAukEy+/tJrVHCg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4142
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPg0KDQpJ
dCBpcyBlYXNpZXIgdG8gbWFuaXB1bGF0ZSBhIGludCB0aGFuIGFuIGFycmF5IG9mIGJvb2xlYW5z
Lg0KDQpTaWduZWQtb2ZmLWJ5OiBKw6lyw7RtZSBQb3VpbGxlciA8amVyb21lLnBvdWlsbGVyQHNp
bGFicy5jb20+DQotLS0NCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jIHwgMTcgKysrKysrKy0t
LS0tLS0tLS0NCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5oIHwgIDIgKy0NCiAyIGZpbGVzIGNo
YW5nZWQsIDggaW5zZXJ0aW9ucygrKSwgMTEgZGVsZXRpb25zKC0pDQoNCmRpZmYgLS1naXQgYS9k
cml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYw0KaW5k
ZXggMDQ1ZDM5MTZhZGE4Li5lNTk1NjBmNDk5ZWEgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3N0YWdp
bmcvd2Z4L3N0YS5jDQorKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jDQpAQCAtMTE5LDIy
ICsxMTksMjIgQEAgc3RhdGljIGludCB3Znhfc2V0X3VhcHNkX3BhcmFtKHN0cnVjdCB3Znhfdmlm
ICp3dmlmLA0KIAkgKiAgVk8gWzAsM10sIFZJIFsxLCAyXSwgQkUgWzIsIDFdLCBCSyBbMywgMF0N
CiAJICovDQogDQotCWlmIChhcmctPnVhcHNkX2VuYWJsZVtJRUVFODAyMTFfQUNfVk9dKQ0KKwlp
ZiAoYXJnLT51YXBzZF9tYXNrICYgQklUKElFRUU4MDIxMV9BQ19WTykpDQogCQl3dmlmLT51YXBz
ZF9pbmZvLnRyaWdfdm9pY2UgPSAxOw0KIAllbHNlDQogCQl3dmlmLT51YXBzZF9pbmZvLnRyaWdf
dm9pY2UgPSAwOw0KIA0KLQlpZiAoYXJnLT51YXBzZF9lbmFibGVbSUVFRTgwMjExX0FDX1ZJXSkN
CisJaWYgKGFyZy0+dWFwc2RfbWFzayAmIEJJVChJRUVFODAyMTFfQUNfVkkpKQ0KIAkJd3ZpZi0+
dWFwc2RfaW5mby50cmlnX3ZpZGVvID0gMTsNCiAJZWxzZQ0KIAkJd3ZpZi0+dWFwc2RfaW5mby50
cmlnX3ZpZGVvID0gMDsNCiANCi0JaWYgKGFyZy0+dWFwc2RfZW5hYmxlW0lFRUU4MDIxMV9BQ19C
RV0pDQorCWlmIChhcmctPnVhcHNkX21hc2sgJiBCSVQoSUVFRTgwMjExX0FDX0JFKSkNCiAJCXd2
aWYtPnVhcHNkX2luZm8udHJpZ19iZSA9IDE7DQogCWVsc2UNCiAJCXd2aWYtPnVhcHNkX2luZm8u
dHJpZ19iZSA9IDA7DQogDQotCWlmIChhcmctPnVhcHNkX2VuYWJsZVtJRUVFODAyMTFfQUNfQktd
KQ0KKwlpZiAoYXJnLT51YXBzZF9tYXNrICYgQklUKElFRUU4MDIxMV9BQ19CSykpDQogCQl3dmlm
LT51YXBzZF9pbmZvLnRyaWdfYmNrZ3JuZCA9IDE7DQogCWVsc2UNCiAJCXd2aWYtPnVhcHNkX2lu
Zm8udHJpZ19iY2tncm5kID0gMDsNCkBAIC0zMzAsNyArMzMwLDYgQEAgc3RhdGljIGludCB3Znhf
dXBkYXRlX3BtKHN0cnVjdCB3ZnhfdmlmICp3dmlmKQ0KIHsNCiAJc3RydWN0IGllZWU4MDIxMV9j
b25mICpjb25mID0gJnd2aWYtPndkZXYtPmh3LT5jb25mOw0KIAlzdHJ1Y3QgaGlmX3JlcV9zZXRf
cG1fbW9kZSBwbTsNCi0JdTE2IHVhcHNkX2ZsYWdzOw0KIA0KIAlpZiAod3ZpZi0+c3RhdGUgIT0g
V0ZYX1NUQVRFX1NUQSB8fCAhd3ZpZi0+YnNzX3BhcmFtcy5haWQpDQogCQlyZXR1cm4gMDsNCkBA
IC0zNDUsOSArMzQ0LDcgQEAgc3RhdGljIGludCB3ZnhfdXBkYXRlX3BtKHN0cnVjdCB3Znhfdmlm
ICp3dmlmKQ0KIAkJCXBtLnBtX21vZGUuZmFzdF9wc20gPSAxOw0KIAl9DQogDQotCW1lbWNweSgm
dWFwc2RfZmxhZ3MsICZ3dmlmLT51YXBzZF9pbmZvLCBzaXplb2YodWFwc2RfZmxhZ3MpKTsNCi0N
Ci0JaWYgKHVhcHNkX2ZsYWdzICE9IDApDQorCWlmICh3dmlmLT5lZGNhLnVhcHNkX21hc2spDQog
CQlwbS5wbV9tb2RlLmZhc3RfcHNtID0gMDsNCiANCiAJLy8gS2VybmVsIGRpc2FibGUgUG93ZXJT
YXZlIHdoZW4gbXVsdGlwbGUgdmlmcyBhcmUgaW4gdXNlLiBJbiBjb250cmFyeSwNCkBAIC0zNzUs
NyArMzcyLDcgQEAgaW50IHdmeF9jb25mX3R4KHN0cnVjdCBpZWVlODAyMTFfaHcgKmh3LCBzdHJ1
Y3QgaWVlZTgwMjExX3ZpZiAqdmlmLA0KIAlXQVJOX09OKHF1ZXVlID49IGh3LT5xdWV1ZXMpOw0K
IA0KIAltdXRleF9sb2NrKCZ3ZGV2LT5jb25mX211dGV4KTsNCi0Jd3ZpZi0+ZWRjYS51YXBzZF9l
bmFibGVbcXVldWVdID0gcGFyYW1zLT51YXBzZDsNCisJYXNzaWduX2JpdChxdWV1ZSwgJnd2aWYt
PmVkY2EudWFwc2RfbWFzaywgcGFyYW1zLT51YXBzZCk7DQogCWVkY2EgPSAmd3ZpZi0+ZWRjYS5w
YXJhbXNbcXVldWVdOw0KIAllZGNhLT5haWZzbiA9IHBhcmFtcy0+YWlmczsNCiAJZWRjYS0+Y3df
bWluID0gcGFyYW1zLT5jd19taW47DQpAQCAtMTU1Miw5ICsxNTQ5LDkgQEAgaW50IHdmeF9hZGRf
aW50ZXJmYWNlKHN0cnVjdCBpZWVlODAyMTFfaHcgKmh3LCBzdHJ1Y3QgaWVlZTgwMjExX3ZpZiAq
dmlmKQ0KIAlmb3IgKGkgPSAwOyBpIDwgSUVFRTgwMjExX05VTV9BQ1M7IGkrKykgew0KIAkJbWVt
Y3B5KCZ3dmlmLT5lZGNhLnBhcmFtc1tpXSwgJmRlZmF1bHRfZWRjYV9wYXJhbXNbaV0sDQogCQkg
ICAgICAgc2l6ZW9mKGRlZmF1bHRfZWRjYV9wYXJhbXNbaV0pKTsNCi0JCXd2aWYtPmVkY2EudWFw
c2RfZW5hYmxlW2ldID0gZmFsc2U7DQogCQloaWZfc2V0X2VkY2FfcXVldWVfcGFyYW1zKHd2aWYs
ICZ3dmlmLT5lZGNhLnBhcmFtc1tpXSk7DQogCX0NCisJd3ZpZi0+ZWRjYS51YXBzZF9tYXNrID0g
MDsNCiAJd2Z4X3NldF91YXBzZF9wYXJhbSh3dmlmLCAmd3ZpZi0+ZWRjYSk7DQogDQogCXdmeF90
eF9wb2xpY3lfaW5pdCh3dmlmKTsNCmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0
YS5oIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuaA0KaW5kZXggNDcxOTgwN2JjMjVhLi43NDc1
NWY2ZmEwMzAgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5oDQorKysgYi9k
cml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5oDQpAQCAtMzcsNyArMzcsNyBAQCBzdHJ1Y3Qgd2Z4X2hp
Zl9ldmVudCB7DQogc3RydWN0IHdmeF9lZGNhX3BhcmFtcyB7DQogCS8qIE5PVEU6IGluZGV4IGlz
IGEgbGludXggcXVldWUgaWQuICovDQogCXN0cnVjdCBoaWZfcmVxX2VkY2FfcXVldWVfcGFyYW1z
IHBhcmFtc1tJRUVFODAyMTFfTlVNX0FDU107DQotCWJvb2wgdWFwc2RfZW5hYmxlW0lFRUU4MDIx
MV9OVU1fQUNTXTsNCisJdW5zaWduZWQgbG9uZyB1YXBzZF9tYXNrOw0KIH07DQogDQogc3RydWN0
IHdmeF9ncnBfYWRkcl90YWJsZSB7DQotLSANCjIuMjAuMQ0K
