Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D289E1210B7
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 18:05:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727260AbfLPRFz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 12:05:55 -0500
Received: from mail-eopbgr750081.outbound.protection.outlook.com ([40.107.75.81]:59109
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726922AbfLPRDu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Dec 2019 12:03:50 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k7VtEWdPRq5DnULIdIRFXioSU2QUtqSDNiCqxj8Bxr5MpgO50hUNbGVsie1zKtOUQhQFIeVWhG6VAHFgJvIaVueIgjH28KYLUoFRgDFq7/5qstVp1rTizsvZWNQ9ywlLV0pZA88WOg2auKQ3t5LOwTzvn8FmItbYIWCNBGUtN7cRH+/1kuMeAqO13ioqZL6RAhOiK+d9/aVA2SHSOaaQ1Vpv08smaJ3EgGNZJBO514WvkLz/DESCCENZ/V7VQj+16K4zlyWSAnRe81JrPINNDTmvT0XBOHAnHakxLRWekWXJtuXPzO7+Zy85+vG5bwMIIlmKAw593K8FqFasnaItjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IEOwGuXdXRIto0oo457DaTZyfUjV59QqHiZcKzdMaLY=;
 b=bRnvyWmrWA5FiUn8ZNg7zEwMQ4uK5Fq+BoLND7dIboJQgkMrkMlhHWYf8nh8m7aIyDhACOt3Q95Q0h2FACPcOvfQ6a57Cnhn8gDG2Qn+T4cXR28LmUDKM/rqAKOgkC8ehFmMDkWhhmyhcEXAMUd4LfZSrXhcBn4JMY4qJwQ87ZHY0+W+oY+RhFaqGz+KpdDFGkKCgewwRoxO+r7tBD/XlUdS2FqslIDDa49flw1j9fwQMNgYQYSbBS3RxAZMHbMt+y2DhnVL8XDvrTCsghtSVivT6COpjl874x+xfjDV9NVe3PVa49DPWbCWLdEUKTF+Zm01XnktdbtBY5bcRegfiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IEOwGuXdXRIto0oo457DaTZyfUjV59QqHiZcKzdMaLY=;
 b=h+Uc434YXt3Yck8Yg3Dv551DZzfojIDgaqcMnFh3v5uDJAidHvNLH3yCzzy49hvRdqWim4XnMQbjUglI9WLXtQKVP/4YeiKV24uwNlWe3a8/m60sO9MMqKvb0vABcba2BYl9o/NUr+VCfSanh61tldqlTtoIaHExC/zcnAKzPOI=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB3838.namprd11.prod.outlook.com (20.178.252.202) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.19; Mon, 16 Dec 2019 17:03:43 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2538.019; Mon, 16 Dec 2019
 17:03:43 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH 07/55] staging: wfx: ensure that retry policy always fallbacks
 to MCS0 / 1Mbps
Thread-Topic: [PATCH 07/55] staging: wfx: ensure that retry policy always
 fallbacks to MCS0 / 1Mbps
Thread-Index: AQHVtDLBov0Pg1nqV0CYOt2kPrSx7Q==
Date:   Mon, 16 Dec 2019 17:03:36 +0000
Message-ID: <20191216170302.29543-8-Jerome.Pouiller@silabs.com>
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
x-ms-office365-filtering-correlation-id: fba85927-32fe-4ded-dc22-08d78249e7e1
x-ms-traffictypediagnostic: MN2PR11MB3838:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB383811480C281D3AF93A1A0993510@MN2PR11MB3838.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 02530BD3AA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(346002)(136003)(39860400002)(396003)(366004)(189003)(199004)(85202003)(8936002)(81166006)(8676002)(54906003)(110136005)(316002)(85182001)(6506007)(186003)(2906002)(5660300002)(6512007)(26005)(107886003)(81156014)(36756003)(4326008)(6666004)(2616005)(76116006)(91956017)(64756008)(66556008)(66476007)(66946007)(71200400001)(86362001)(66446008)(6486002)(478600001)(1076003);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB3838;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: q4cgaCFbbtbbvwienuId7IpK2lB+j1nthONvKPOFhp4BPwJDM5NB8dSpTxtBN9j7ywDs6TN/g+QeCbibniRA7sSfX/Zuv9GE/yRZScQniGs2RHktf/0m6im90/yEfVK/3FKIfSD/06QCsTbDtUO8kRAorZhfr90TUZap1umCD6Lu/7f2vNDpxKjs4s6cxlYh1EFsUd3GhW2FgL0dvKu9YyDubDrSQUQXnIcnvxcQgTlqHJi/fKs+ZT23q5QCw7um+4K/TCwuITzlK6FYzvmliBG6nz7va61IjesufjHipRCqZ1A6m27cBJ4ROLBtebEBiBm2PAdW5UUduiZP1eScwCjufZkVpW2PDI830+tyoBVdHycDNd140+iICSTCDxjNrRGBrdhoGTX0nypiPZD3wWaGgO5JkmHs5ebBgburx71eBmdMeIWplnKpZEEHkZjH
Content-Type: text/plain; charset="utf-8"
Content-ID: <23308CCBA6D4A0469272770443370CC9@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fba85927-32fe-4ded-dc22-08d78249e7e1
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Dec 2019 17:03:36.8822
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nqnHvveDJmPqqFgGLXSc6j7ms/tuQ+nVabDxryVbHgYUELk+WT6z7salSPQlbUngAkEg7glzYzZATtL0dvRwew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3838
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPg0KDQpX
aGVuIG5vdCB1c2luZyBIVCBtb2RlLCBtaW5zdHJlbCBhbHdheXMgaW5jbHVkZXMgMU1icHMgYXMg
ZmFsbGJhY2sgcmF0ZS4NCkJ1dCwgd2hlbiB1c2luZyBIVCBtb2RlLCB0aGlzIGZhbGxiYWNrIGlz
IG5vdCBpbmNsdWRlZC4gWWV0LCBpdCBzZWVtcw0KdGhhdCBpdCBjb3VsZCBzYXZlIHNvbWUgZnJh
bWVzLiBTbywgdGhpcyBwYXRjaCBhZGQgaXQgdW5jb25kaXRpb25hbGx5Lg0KDQpTaWduZWQtb2Zm
LWJ5OiBKw6lyw7RtZSBQb3VpbGxlciA8amVyb21lLnBvdWlsbGVyQHNpbGFicy5jb20+DQotLS0N
CiBkcml2ZXJzL3N0YWdpbmcvd2Z4L2RhdGFfdHguYyB8IDExICsrKysrKysrKysrDQogMSBmaWxl
IGNoYW5nZWQsIDExIGluc2VydGlvbnMoKykNCg0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2lu
Zy93ZngvZGF0YV90eC5jIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9kYXRhX3R4LmMNCmluZGV4IDQ2
YWQ4M2I5NWY1Mi4uNzM4YTZjYTVlZGFkIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dm
eC9kYXRhX3R4LmMNCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvZGF0YV90eC5jDQpAQCAtNTM4
LDYgKzUzOCwxNyBAQCBzdGF0aWMgdm9pZCB3ZnhfdHhfZml4dXBfcmF0ZXMoc3RydWN0IGllZWU4
MDIxMV90eF9yYXRlICpyYXRlcykNCiAJCQl9DQogCQl9DQogCX0gd2hpbGUgKCFmaW5pc2hlZCk7
DQorCS8vIEVuc3VyZSB0aGF0IE1DUzAgb3IgMU1icHMgaXMgcHJlc2VudCBhdCB0aGUgZW5kIG9m
IHRoZSByZXRyeSBsaXN0DQorCWZvciAoaSA9IDA7IGkgPCBJRUVFODAyMTFfVFhfTUFYX1JBVEVT
OyBpKyspIHsNCisJCWlmIChyYXRlc1tpXS5pZHggPT0gMCkNCisJCQlicmVhazsNCisJCWlmIChy
YXRlc1tpXS5pZHggPT0gLTEpIHsNCisJCQlyYXRlc1tpXS5pZHggPSAwOw0KKwkJCXJhdGVzW2ld
LmNvdW50ID0gODsgLy8gPT0gaHctPm1heF9yYXRlX3RyaWVzDQorCQkJcmF0ZXNbaV0uZmxhZ3Mg
PSByYXRlc1tpIC0gMV0uZmxhZ3MgJiBJRUVFODAyMTFfVFhfUkNfTUNTOw0KKwkJCWJyZWFrOw0K
KwkJfQ0KKwl9DQogCS8vIEFsbCByZXRyaWVzIHVzZSBsb25nIEdJDQogCWZvciAoaSA9IDE7IGkg
PCBJRUVFODAyMTFfVFhfTUFYX1JBVEVTOyBpKyspDQogCQlyYXRlc1tpXS5mbGFncyAmPSB+SUVF
RTgwMjExX1RYX1JDX1NIT1JUX0dJOw0KLS0gDQoyLjIwLjENCg==
