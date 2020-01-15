Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C4E713C02C
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 13:17:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730807AbgAOMMr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 07:12:47 -0500
Received: from mail-bn7nam10on2047.outbound.protection.outlook.com ([40.107.92.47]:27390
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730768AbgAOMMr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jan 2020 07:12:47 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H48j5rsNlMcwo2UslbG/uCUru8vN1eI7mVVWi24+qGFmGNOoe+T5fZ1gLQF8+7zdBSUDh5t3KO+Zt9vEG/dDJHjEvoMU10zPo9nlWJI3/rSYyC72rOklH5F4vpJJOhYzHotY7geYZ5kTLRoyzUQsOkms2aUpHbCgVwOzV6IxGJUMk8MgYO0pEtv3mxXxNbyzMgfQzawZJUFtUtpoIia7GxHHXKKL1daExmlGmAHzBwKmrouO4O/0bNClZiBhcnUK8W8+w1gLLqcpIbhCA/txKl6iNDr+L7+jwz7F0X9g3uWXiNYtKzvH5wo0l52jt3PuYWuKJL8UHQ/UuHOaD1Jl6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tjKAuLPHt5gNg/Eo1CFrDExKSrzLBhwAanAjvAIxEpw=;
 b=XDIR5hJwkqXsiBX4yRAmRA2zrvhV3lGU9x5ccEMLrd4xJrTx6/Bt44y+c2d7hJi8e5z9cnxDw4DWGLRVSfdAQQfcRP74Ef9/JfUaaSh6WXyzzNK4Skykjf/RYRY1tZoaQbBH1EPemagmScQwQU2G/vMzvu/0zudi8agybzAJc7dQnm2TvOy1QtxOV2poQOLWpPsNh93BEvf2HqCNkIBDFNX01tsbZvvXAgYR6Z9ZI9S+6WdNbp4CpCSBW1cUusGIg19Z7nXwk40VJ8QUpX3//JkHoFpMDohbrbCyKwPfG1G8rLFdSoktibfl00ecCB+do7oQNKag+yXfAEZJezkbfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tjKAuLPHt5gNg/Eo1CFrDExKSrzLBhwAanAjvAIxEpw=;
 b=B9UKXii9bmPwmDNUpanH7WeWNp39UXpDNw664I/jA6m0Wzxz55tb+K/eNI4edBDyAHe0q0KCQNYvlPtlCUL7FzIr2rSkF4YeTZ2nLC8aYcMvv4ZLJgRy8r69jIltKTngw5vDtCUJuD4JP9A8cJsjXIN9jIFtrEq6UVPJnj/spBA=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB4096.namprd11.prod.outlook.com (20.179.150.82) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.10; Wed, 15 Jan 2020 12:12:42 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2623.018; Wed, 15 Jan 2020
 12:12:42 +0000
Received: from pc-42.silabs.com (37.71.187.125) by PR2PR09CA0009.eurprd09.prod.outlook.com (2603:10a6:101:16::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.18 via Frontend Transport; Wed, 15 Jan 2020 12:12:41 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH 25/65] staging: wfx: drop wvif->setbssparams_done
Thread-Topic: [PATCH 25/65] staging: wfx: drop wvif->setbssparams_done
Thread-Index: AQHVy50WzQfPu0vHNUOzW0r1UjWjTQ==
Date:   Wed, 15 Jan 2020 12:12:42 +0000
Message-ID: <20200115121041.10863-26-Jerome.Pouiller@silabs.com>
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
x-ms-office365-filtering-correlation-id: 270c3111-4dff-4aee-7a72-08d799b438e5
x-ms-traffictypediagnostic: MN2PR11MB4096:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB40966F71CB014ACB3E4AFAA393370@MN2PR11MB4096.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2958;
x-forefront-prvs: 02830F0362
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(346002)(39860400002)(366004)(376002)(136003)(199004)(189003)(85202003)(66946007)(66446008)(66476007)(2906002)(107886003)(66556008)(1076003)(66574012)(64756008)(5660300002)(8936002)(6486002)(186003)(26005)(8676002)(316002)(81156014)(36756003)(52116002)(2616005)(7696005)(478600001)(16526019)(956004)(54906003)(110136005)(86362001)(71200400001)(85182001)(4326008)(81166006);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB4096;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: iY5V72mlDdlh+oqsENl/+Z3Y1pyXDP2AllKH4wYnXppw775p7q5CIsIV4R8Kr3Th0zanfllM596pw2yBVXRpDhzwhYbXjNIspDtoCiPqQWgQPRdIT0MEO8NwtHHCUaxWanw2O25FosM5uS3tEo/VedassqWmFn6314t35qQe8iByaE4mwfd1RIZtomQtFNwEz1czGb7oj0oz+QpgJdewlNPH+hgM5Yfb51oXaEGPIDG0f3rA6u/Czv/AcWv77RTNJWV2AGAlskjMZPpCHtwKomO9FZ692T1BtcyRn7ZQAOWgjrANMX91xnLiQE0OFocy4+ea4CqOZny+JrPZNrvCSFDRMjsVO4+0B1CyVIJwD4TOsfocZYI+NEqjm1Xb3snF7oGBjLJ6bE6f1908o3ySijxdcznefqph9wz0xw7NIRysF1HROFp8y+mhapq3J5tK
Content-Type: text/plain; charset="utf-8"
Content-ID: <D0599022FAFE41408E53242AF37686A8@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 270c3111-4dff-4aee-7a72-08d799b438e5
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2020 12:12:42.5789
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lwYIWj0HkurDu5ZdfS0mPfCkqg6ovO0WeF2nmYxocakdVuEJ0JnvreqWDUvmiDlB63X610gLoe2+RIacVl2G3g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4096
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKc2V0
YnNzcGFyYW1zX2RvbmUgd2FzIGhlcmUgdG8gZW5zdXJlIHRoYXQgdGhlIGZpcm13YXJlIGRvZXMg
bm90IGVuYWJsZQpwb3dlcnNhdmUgYmVmb3JlIHRvIGdldCB0aGUgZmlyc3QgYmVhY29uLiBIb3dl
dmVyLCBtYWM4MDIxMSBhbHJlYWR5CmVuc3VyZXMgaXQgZ2V0cyBhIGJlYWNvbiBiZWZvcmUgdG8g
YXNzb2NpYXRlIHRvIHRoZSBCU1MuIEFuZCBldmVuLCBpZgppdCB3b24ndCwgdGhlIGZpcm13YXJl
IHdha2UgdXAgYXQgbGVhc3Qgb24gZXZlcnkgRFRJTSwgd2hpY2ggaXMKc3VmZmljaWVudCB0byBm
aW5hbGl6ZSB0aGUgYXNzb2NpYXRpb24uCgpTaWduZWQtb2ZmLWJ5OiBKw6lyw7RtZSBQb3VpbGxl
ciA8amVyb21lLnBvdWlsbGVyQHNpbGFicy5jb20+Ci0tLQogZHJpdmVycy9zdGFnaW5nL3dmeC9z
dGEuYyB8IDggKysrLS0tLS0KIGRyaXZlcnMvc3RhZ2luZy93Zngvd2Z4LmggfCAxIC0KIDIgZmls
ZXMgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCspLCA2IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBh
L2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jCmlu
ZGV4IDAyMWRhYTlmN2EzMy4uN2FiZTI3MmRkYzBkIDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdp
bmcvd2Z4L3N0YS5jCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMKQEAgLTMyNiw4ICsz
MjYsNyBAQCBpbnQgd2Z4X2NvbmZfdHgoc3RydWN0IGllZWU4MDIxMV9odyAqaHcsIHN0cnVjdCBp
ZWVlODAyMTFfdmlmICp2aWYsCiAJaGlmX3NldF9lZGNhX3F1ZXVlX3BhcmFtcyh3dmlmLCBxdWV1
ZSwgcGFyYW1zKTsKIAlpZiAod3ZpZi0+dmlmLT50eXBlID09IE5MODAyMTFfSUZUWVBFX1NUQVRJ
T04pIHsKIAkJaGlmX3NldF91YXBzZF9pbmZvKHd2aWYsIHd2aWYtPnVhcHNkX21hc2spOwotCQlp
ZiAod3ZpZi0+c2V0YnNzcGFyYW1zX2RvbmUgJiYgd3ZpZi0+c3RhdGUgPT0gV0ZYX1NUQVRFX1NU
QSkKLQkJCXJldCA9IHdmeF91cGRhdGVfcG0od3ZpZik7CisJCXdmeF91cGRhdGVfcG0od3ZpZik7
CiAJfQogCW11dGV4X3VubG9jaygmd2Rldi0+Y29uZl9tdXRleCk7CiAJcmV0dXJuIHJldDsKQEAg
LTQ3NSw3ICs0NzQsNiBAQCBzdGF0aWMgdm9pZCB3ZnhfZG9fdW5qb2luKHN0cnVjdCB3Znhfdmlm
ICp3dmlmKQogCXd2aWYtPmRpc2FibGVfYmVhY29uX2ZpbHRlciA9IGZhbHNlOwogCXdmeF91cGRh
dGVfZmlsdGVyaW5nKHd2aWYpOwogCW1lbXNldCgmd3ZpZi0+YnNzX3BhcmFtcywgMCwgc2l6ZW9m
KHd2aWYtPmJzc19wYXJhbXMpKTsKLQl3dmlmLT5zZXRic3NwYXJhbXNfZG9uZSA9IGZhbHNlOwog
CiBkb25lOgogCW11dGV4X3VubG9jaygmd3ZpZi0+d2Rldi0+Y29uZl9tdXRleCk7CkBAIC03OTks
NyArNzk3LDYgQEAgc3RhdGljIHZvaWQgd2Z4X2pvaW5fZmluYWxpemUoc3RydWN0IHdmeF92aWYg
Knd2aWYsCiAJaWYgKCFpbmZvLT5pYnNzX2pvaW5lZCkgewogCQloaWZfa2VlcF9hbGl2ZV9wZXJp
b2Qod3ZpZiwgMzAgLyogc2VjICovKTsKIAkJaGlmX3NldF9ic3NfcGFyYW1zKHd2aWYsICZ3dmlm
LT5ic3NfcGFyYW1zKTsKLQkJd3ZpZi0+c2V0YnNzcGFyYW1zX2RvbmUgPSB0cnVlOwogCQloaWZf
c2V0X2JlYWNvbl93YWtldXBfcGVyaW9kKHd2aWYsIGluZm8tPmR0aW1fcGVyaW9kLAogCQkJCQkg
ICAgIGluZm8tPmR0aW1fcGVyaW9kKTsKIAkJd2Z4X3VwZGF0ZV9wbSh3dmlmKTsKQEAgLTEyMjQs
NyArMTIyMSw4IEBAIGludCB3ZnhfYWRkX2ludGVyZmFjZShzdHJ1Y3QgaWVlZTgwMjExX2h3ICpo
dywgc3RydWN0IGllZWU4MDIxMV92aWYgKnZpZikKIAlJTklUX1dPUksoJnd2aWYtPm1jYXN0X3N0
b3Bfd29yaywgd2Z4X21jYXN0X3N0b3Bfd29yayk7CiAJdGltZXJfc2V0dXAoJnd2aWYtPm1jYXN0
X3RpbWVvdXQsIHdmeF9tY2FzdF90aW1lb3V0LCAwKTsKIAotCXd2aWYtPnNldGJzc3BhcmFtc19k
b25lID0gZmFsc2U7CisJbWVtc2V0KCZ3dmlmLT5ic3NfcGFyYW1zLCAwLCBzaXplb2Yod3ZpZi0+
YnNzX3BhcmFtcykpOworCiAJbXV0ZXhfaW5pdCgmd3ZpZi0+YnNzX2xvc3NfbG9jayk7CiAJSU5J
VF9ERUxBWUVEX1dPUksoJnd2aWYtPmJzc19sb3NzX3dvcmssIHdmeF9ic3NfbG9zc193b3JrKTsK
IApkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC93ZnguaCBiL2RyaXZlcnMvc3RhZ2lu
Zy93Zngvd2Z4LmgKaW5kZXggMWI0ODdkOTZlY2EyLi41ZTFhNzYzZWI0YjUgMTAwNjQ0Ci0tLSBh
L2RyaXZlcnMvc3RhZ2luZy93Zngvd2Z4LmgKKysrIGIvZHJpdmVycy9zdGFnaW5nL3dmeC93Zngu
aApAQCAtMTA1LDcgKzEwNSw2IEBAIHN0cnVjdCB3ZnhfdmlmIHsKIAlzdHJ1Y3Qgd29ya19zdHJ1
Y3QJdXBkYXRlX2ZpbHRlcmluZ193b3JrOwogCiAJdTMyCQkJZXJwX2luZm87Ci0JYm9vbAkJCXNl
dGJzc3BhcmFtc19kb25lOwogCXVuc2lnbmVkIGxvbmcJCXVhcHNkX21hc2s7CiAJc3RydWN0IGll
ZWU4MDIxMV90eF9xdWV1ZV9wYXJhbXMgZWRjYV9wYXJhbXNbSUVFRTgwMjExX05VTV9BQ1NdOwog
CXN0cnVjdCBoaWZfcmVxX3NldF9ic3NfcGFyYW1zIGJzc19wYXJhbXM7Ci0tIAoyLjI1LjAKCg==
