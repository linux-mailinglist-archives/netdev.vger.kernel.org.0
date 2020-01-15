Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8989513BFCD
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 13:16:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730959AbgAOMQd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 07:16:33 -0500
Received: from mail-bn7nam10on2064.outbound.protection.outlook.com ([40.107.92.64]:6048
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731380AbgAOMNe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jan 2020 07:13:34 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TCg8fCw95yLkxyQ0PRDgyDfFm1XyC2AbpBicsV6xE2uqyw7xe9GXYwSEybOA3D9jWdnFPzw+DvbC00U3DwShJg+eIs3mzVMUdc1Gs70jPiiwllMMm/ENRRzgDE+OxeFBA5gxh4QGftWuaRmZs/h1PVo/VRPFS0lZeJIhUi2LRn48jjcs0LNklCE0pSpxShtRoQ/yNQfsgzSLDn+k5yfPbilQ3cAljlmR8tcJXP1V7/igPKZ6Moa2ES9qxQvxx8N6m+xlKNtzzqXdEN2uN8aReP/xbgOoBVkDOkZFC33VCORgi/gu2x1g8N5Bly/3/CO0EaPc76t2nN6VKfyb4yP5dw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+r+hH6i8d3N1IAb/CKSuC2M9LsNeoz8vnFD1h6dEiDg=;
 b=SEOBk7oU7/SpoTfFyQnW7DQMqUekPuJQVuCDYlIIebbyq8bT+JqajIGgA2B7rCKO5HIuIF8xmleYQLRhtoqoKaALMVNaGqrzMDDDJ6TVHvzYMpwsuVnz6Uf3JFfJUxxp6f8nmwR6CbTWqqiSeZP1H2H/V8t5f0+dCBOr7vlQWthwzOytkFmHIzcIrR8W3FUCPVksg5SXqU+pPI9YzecZXmjhwZQlvUZII5Ooi5d/sfrLNOjGZFGeSAUmP/TJbWay9ilmihMeWFRnFyKKwpEZJYbumrsqCjj497akcCuTnKzRkGqwBIyUScjlYOzvFS+YyTq53JmLEW0sKv21YRDt7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+r+hH6i8d3N1IAb/CKSuC2M9LsNeoz8vnFD1h6dEiDg=;
 b=o1f3fcQAwWkUgpGIl6rAFvGQIEwnmgWOpMP6AWH6cY6meQRNV9nJmO5yBBchfuEQ67Pxttw5tR/p2L6fQv/lfRG/KX2SDIsyASjSgn3QUmp/cZyXYYFnj0dz6PkJCmdA2i+12lyhxX6DGJsd3/pES8egwfB9gqNl8S97rfpX03Q=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB4096.namprd11.prod.outlook.com (20.179.150.82) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.10; Wed, 15 Jan 2020 12:13:24 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2623.018; Wed, 15 Jan 2020
 12:13:24 +0000
Received: from pc-42.silabs.com (37.71.187.125) by PR2PR09CA0009.eurprd09.prod.outlook.com (2603:10a6:101:16::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.18 via Frontend Transport; Wed, 15 Jan 2020 12:12:58 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH 38/65] staging: wfx: simplify wfx_update_filtering()
Thread-Topic: [PATCH 38/65] staging: wfx: simplify wfx_update_filtering()
Thread-Index: AQHVy50gmE8hFxRoREC7HU8Jsv9+fA==
Date:   Wed, 15 Jan 2020 12:12:59 +0000
Message-ID: <20200115121041.10863-39-Jerome.Pouiller@silabs.com>
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
x-ms-office365-filtering-correlation-id: 45dbcff9-751c-42c6-1739-08d799b4431c
x-ms-traffictypediagnostic: MN2PR11MB4096:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB40960467F5F9254143BA73F893370@MN2PR11MB4096.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1051;
x-forefront-prvs: 02830F0362
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(346002)(39860400002)(366004)(376002)(136003)(199004)(189003)(85202003)(66946007)(66446008)(66476007)(2906002)(107886003)(66556008)(1076003)(66574012)(64756008)(5660300002)(8936002)(6486002)(186003)(26005)(8676002)(316002)(81156014)(36756003)(52116002)(2616005)(7696005)(478600001)(16526019)(956004)(54906003)(110136005)(86362001)(71200400001)(85182001)(4326008)(81166006);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB4096;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0poF44AWJ/9kBC8BtCiJsWsars4LnQm5ig5eCFqBakDUrAiP5rrjtDSLpTEKlQfpAgBqjGYw0Qf3WJ0gK6uLPMUTAAqkqLh4iH1MWI49J5abHDLIPPcOWV3uc08dW1byvO6sh1qbykTqdbozJZg1XTb3AknH3xt2brd1SgG5zoMTd7mCy/LiqM89V1fY4COO8zo102ii2ne+bQ+0ro/bUDBuDM4l2vsqVEjKVQr0Ij5jcspKZhwHCB6nrko0VI0Mg8j/bgTcbkmfq9hxfKbGFRhxlk5YSaKuvnbezViRTdKT1Z778DN0BiSFs8zL9swijs7NF/myqWNoLlRGS+jMcdnz6vgiX5REk4Ocvjxy9eWf9Vd3+JHLt81hysFDzjfCT4ehniw3vPqfS7DC431LTqf0pcB5UBEXeo08N7x6TGGOGcwTV0MTUNcsOlG7hVkY
Content-Type: text/plain; charset="utf-8"
Content-ID: <B6723192FB298F4B9643253EE086E715@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 45dbcff9-751c-42c6-1739-08d799b4431c
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2020 12:12:59.7050
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iYzGDwfqFyK48NSBFtBgIoZ9WMKovooRidRC6cSLDaa8oDBhjgcnWZgiz60271EIsuSh9WprwNwVt54V7sxFSA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4096
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKd2Z4
X3VwZGF0ZV9maWx0ZXJpbmcoKSBoYXMgbm8gcmVhc29uIHRvIGluc3RhbnRpYXRlIGEgc3RydWN0
CmhpZl9taWJfYmNuX2ZpbHRlcl9lbmFibGUuIERyb3AgaXQgYW5kIHNpbXBsaWZ5IHRoZSBjb2Rl
LgoKU2lnbmVkLW9mZi1ieTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxh
YnMuY29tPgotLS0KIGRyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMgfCAzMSArKysrKysrKysrKysr
LS0tLS0tLS0tLS0tLS0tLS0tCiAxIGZpbGUgY2hhbmdlZCwgMTMgaW5zZXJ0aW9ucygrKSwgMTgg
ZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYyBiL2Ry
aXZlcnMvc3RhZ2luZy93Zngvc3RhLmMKaW5kZXggYTkzNGY2NmYzYTRjLi4wYzMxNTBhOTRjN2Mg
MTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMKKysrIGIvZHJpdmVycy9zdGFn
aW5nL3dmeC9zdGEuYwpAQCAtMTM4LDEwICsxMzgsOSBAQCBzdGF0aWMgaW50IHdmeF9zZXRfbWNh
c3RfZmlsdGVyKHN0cnVjdCB3ZnhfdmlmICp3dmlmLAogdm9pZCB3ZnhfdXBkYXRlX2ZpbHRlcmlu
ZyhzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZikKIHsKIAlpbnQgcmV0OwotCWJvb2wgaXNfc3RhID0gd3Zp
Zi0+dmlmICYmIE5MODAyMTFfSUZUWVBFX1NUQVRJT04gPT0gd3ZpZi0+dmlmLT50eXBlOwotCWJv
b2wgZmlsdGVyX2Jzc2lkID0gd3ZpZi0+ZmlsdGVyX2Jzc2lkOwotCWJvb2wgZndkX3Byb2JlX3Jl
cSA9IHd2aWYtPmZ3ZF9wcm9iZV9yZXE7Ci0Jc3RydWN0IGhpZl9taWJfYmNuX2ZpbHRlcl9lbmFi
bGUgYmZfY3RybDsKKwlpbnQgYmZfZW5hYmxlOworCWludCBiZl9jb3VudDsKKwlpbnQgbl9maWx0
ZXJfaWVzOwogCXN0cnVjdCBoaWZfaWVfdGFibGVfZW50cnkgZmlsdGVyX2llc1tdID0gewogCQl7
CiAJCQkuaWVfaWQgICAgICAgID0gV0xBTl9FSURfVkVORE9SX1NQRUNJRklDLApAQCAtMTYxLDMz
ICsxNjAsMjkgQEAgdm9pZCB3ZnhfdXBkYXRlX2ZpbHRlcmluZyhzdHJ1Y3Qgd2Z4X3ZpZiAqd3Zp
ZikKIAkJCS5oYXNfYXBwZWFyZWQgPSAxLAogCQl9CiAJfTsKLQlpbnQgbl9maWx0ZXJfaWVzOwog
CiAJaWYgKHd2aWYtPnN0YXRlID09IFdGWF9TVEFURV9QQVNTSVZFKQogCQlyZXR1cm47CiAKIAlp
ZiAod3ZpZi0+ZGlzYWJsZV9iZWFjb25fZmlsdGVyKSB7Ci0JCWJmX2N0cmwuZW5hYmxlID0gMDsK
LQkJYmZfY3RybC5iY25fY291bnQgPSAxOworCQliZl9lbmFibGUgPSAwOworCQliZl9jb3VudCA9
IDE7CiAJCW5fZmlsdGVyX2llcyA9IDA7Ci0JfSBlbHNlIGlmICghaXNfc3RhKSB7Ci0JCWJmX2N0
cmwuZW5hYmxlID0gSElGX0JFQUNPTl9GSUxURVJfRU5BQkxFIHwKLQkJCQkgSElGX0JFQUNPTl9G
SUxURVJfQVVUT19FUlA7Ci0JCWJmX2N0cmwuYmNuX2NvdW50ID0gMDsKKwl9IGVsc2UgaWYgKHd2
aWYtPnZpZi0+dHlwZSAhPSBOTDgwMjExX0lGVFlQRV9TVEFUSU9OKSB7CisJCWJmX2VuYWJsZSA9
IEhJRl9CRUFDT05fRklMVEVSX0VOQUJMRSB8IEhJRl9CRUFDT05fRklMVEVSX0FVVE9fRVJQOwor
CQliZl9jb3VudCA9IDA7CiAJCW5fZmlsdGVyX2llcyA9IDI7CiAJfSBlbHNlIHsKLQkJYmZfY3Ry
bC5lbmFibGUgPSBISUZfQkVBQ09OX0ZJTFRFUl9FTkFCTEU7Ci0JCWJmX2N0cmwuYmNuX2NvdW50
ID0gMDsKKwkJYmZfZW5hYmxlID0gSElGX0JFQUNPTl9GSUxURVJfRU5BQkxFOworCQliZl9jb3Vu
dCA9IDA7CiAJCW5fZmlsdGVyX2llcyA9IDM7CiAJfQogCi0JcmV0ID0gaGlmX3NldF9yeF9maWx0
ZXIod3ZpZiwgZmlsdGVyX2Jzc2lkLCBmd2RfcHJvYmVfcmVxKTsKKwlyZXQgPSBoaWZfc2V0X3J4
X2ZpbHRlcih3dmlmLCB3dmlmLT5maWx0ZXJfYnNzaWQsIHd2aWYtPmZ3ZF9wcm9iZV9yZXEpOwog
CWlmICghcmV0KQotCQlyZXQgPSBoaWZfc2V0X2JlYWNvbl9maWx0ZXJfdGFibGUod3ZpZiwgbl9m
aWx0ZXJfaWVzLAotCQkJCQkJICBmaWx0ZXJfaWVzKTsKKwkJcmV0ID0gaGlmX3NldF9iZWFjb25f
ZmlsdGVyX3RhYmxlKHd2aWYsIG5fZmlsdGVyX2llcywgZmlsdGVyX2llcyk7CiAJaWYgKCFyZXQp
Ci0JCXJldCA9IGhpZl9iZWFjb25fZmlsdGVyX2NvbnRyb2wod3ZpZiwgYmZfY3RybC5lbmFibGUs
Ci0JCQkJCQliZl9jdHJsLmJjbl9jb3VudCk7CisJCXJldCA9IGhpZl9iZWFjb25fZmlsdGVyX2Nv
bnRyb2wod3ZpZiwgYmZfZW5hYmxlLCBiZl9jb3VudCk7CiAJaWYgKCFyZXQpCiAJCXJldCA9IHdm
eF9zZXRfbWNhc3RfZmlsdGVyKHd2aWYsICZ3dmlmLT5tY2FzdF9maWx0ZXIpOwogCWlmIChyZXQp
Ci0tIAoyLjI1LjAKCg==
