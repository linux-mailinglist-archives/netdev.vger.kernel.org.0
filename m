Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9E83121117
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 18:08:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728133AbfLPRIm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 12:08:42 -0500
Received: from mail-eopbgr690078.outbound.protection.outlook.com ([40.107.69.78]:42057
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727826AbfLPRG5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Dec 2019 12:06:57 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UgvRqzaFASGekgzVXx7DzEro/KYxv6uBTUp62k3WWV+HaIdf5yTrRPTv+kXoKMlo+xckn/ANTPjY0KAM9LOYgra/RWDwTtW3gTuLVJ7PHHIgsB/7YPdB3XHEWgh1BrU3oQb3wCJvRTkRYWbUGsYajOI8WQDknpPZ2JZUZpP5AsCVidrrt4TbX9m71soPVSfGkwCPIO8ySiZ2irXByC6FKCvRlOTrvOu8ufDywV4ynV2GnI2EJI6qiFld+zhkyAI7wYR0YMNijYbf9YAJYoeU2yRpThct+5iq9PxIARwfHe0f7U+zHbs4cDucZmbQ9bH9j047tGGUBMNs2lHkweKU3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e0aQ6MJkeUQsgBZxdMQAUiaKgOPGbRtQxZj8GK9qEH4=;
 b=g3FMc35fkG4mCRbc7xmud0KMkCsfAiKWgB/3ctwC2SZTRRSRptcLTicIeiOGFBSD4nyJIN/yQPLh2IoKDeVTQjIfuYiyA4AgFykeHm9BR489d5nCmx78Nu+Ox4ONZkerlwzup6Q4tNi4UJVxJKVSTDdZqOjv+sz9r+89iOVXiC8E33QLgrD9uAR+PWLs6vovq+nwElq5y9QTTG4tYPaxtueTvUazZlTP/S93jTh848UOFIKQr7aOy3gEM546Aw1fiaxode9cAEQbZySA9xUpwvJ9fQDQXFk8jRBYBQTthPqEeRpefzqf/mqbAXWUKd1SpFc9Cy941rRNijAL8DT3ww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e0aQ6MJkeUQsgBZxdMQAUiaKgOPGbRtQxZj8GK9qEH4=;
 b=C077mM50J/OmRvCJr6R+01HpaQ5Q8uMp7UcySFYH6kanheZytFNYraY4uIqwESznbnfGxpQEeCy2senMc3Hub7TmbCj56KQakXNj0mlzVcfwmETz45+qd480Bh8wKVR1Ti4OQpWx6lgOGyf4ZeKewZf/kKZ536LpjQ7fASPIFXI=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB4142.namprd11.prod.outlook.com (20.179.149.157) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.15; Mon, 16 Dec 2019 17:06:43 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2538.019; Mon, 16 Dec 2019
 17:06:43 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH 42/55] staging: wfx: remove unnecessary EDCA initialisation
Thread-Topic: [PATCH 42/55] staging: wfx: remove unnecessary EDCA
 initialisation
Thread-Index: AQHVtDLM2AMC7rqmkU+zq7P13kpdcQ==
Date:   Mon, 16 Dec 2019 17:03:55 +0000
Message-ID: <20191216170302.29543-43-Jerome.Pouiller@silabs.com>
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
x-ms-office365-filtering-correlation-id: 68b42b89-529d-4730-00ab-08d7824a5389
x-ms-traffictypediagnostic: MN2PR11MB4142:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB4142EA686BCDEC987E82456493510@MN2PR11MB4142.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3826;
x-forefront-prvs: 02530BD3AA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(396003)(346002)(136003)(376002)(39850400004)(199004)(189003)(6512007)(71200400001)(91956017)(6486002)(8676002)(2906002)(54906003)(81166006)(81156014)(186003)(76116006)(478600001)(36756003)(85182001)(85202003)(6666004)(66556008)(66476007)(66446008)(64756008)(1076003)(66574012)(316002)(2616005)(4326008)(6506007)(26005)(8936002)(110136005)(5660300002)(107886003)(66946007)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB4142;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Q0nwZjD1pHnDQ1O2wN8uChfTjq8cJE/e1gD+sj4c+12k/yTBPzb3hrCYFq2N594dDeRKK2ddVfRI9BFGgIgeRIJzML+LBfA/WN0j2Tv3DXlZY2ynOM/nZpqbQvkHHH8QFvG1vG4oD1JYmV41Gnswk0ULcLzTV8FX6eNlJ5xN3ejqTpkk15oxBDj0RCgbt4/+roFepFUtm8NYCjzTLWFt3vLCzQeZxNaz5ItuC7NOFWlBFGohXkWgeP8vlf3Hk6r6ugttdGGi6x74U/kucS4jmw7p7Nfw+hXw2rXPaJnRkP8ZkHoD20JoYumtRujSozS+hrTiiYDSiGQHK7twMBJdSBt6fQybvWYiUWlHzfPzJlxMQUtI67UmS1WLrchDuWgNt5O6rSwW/DLHcNXXB9T9W88VM6TV2zMVEnRG/Tx9UC7gmH769xUnx9+4BDfSo8d4
Content-Type: text/plain; charset="utf-8"
Content-ID: <10D85AE184CBFE44B9EEE3BA7D93B6F4@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 68b42b89-529d-4730-00ab-08d7824a5389
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Dec 2019 17:03:55.2167
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: myY/3qeepcom23OJ8EKxqXyX9Ub4U564yE4KCcDJ41vg1vc4F/d7SpVwAYjYVL9AABb1d+XXH3XanxsZTZrbLQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4142
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPg0KDQpt
YWM4MDIxMSBhbHJlYWR5IGNhbGwgd2Z4X2NvbmZfdHgoKSBvbiBldmVyeSBWSUYgaW5zdGFuY2lh
dGlvbi4gU28sIHRoZQ0KZHJpdmVyIGRvZXMgbm90IG5lZWQgdG8gZG8gaXQuDQoNCk5vdGUgdGhh
dCBjdXJyZW50IGNvZGUgZGlkIGRpcnR5IHRoaW5ncyB3aXRoIHd2aWYtPmVkY2FfcGFyYW1zLiBU
aGlzDQpzdHJ1Y3Qgd2FzIGluaXRpYWxpemVkLCBidXQgb25seSAncXVldWVfaWQnIHdhcyByZWFs
bHkgdXNlZC4gVGhlIG90aGVyDQptZW1iZXJzIGFyZSBvbmx5IHVzZWQgdG8gc3RvcmUgdGVtcG9y
YXJ5IHZhbHVlcy4NCg0KU2lnbmVkLW9mZi1ieTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5w
b3VpbGxlckBzaWxhYnMuY29tPg0KLS0tDQogZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYyB8IDUx
ICsrKysrLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0KIDEgZmlsZSBjaGFuZ2Vk
LCA2IGluc2VydGlvbnMoKyksIDQ1IGRlbGV0aW9ucygtKQ0KDQpkaWZmIC0tZ2l0IGEvZHJpdmVy
cy9zdGFnaW5nL3dmeC9zdGEuYyBiL2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMNCmluZGV4IGQ1
MmY2MTgwNjJhNi4uMzUwNGI2YjM1MTVlIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dm
eC9zdGEuYw0KKysrIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYw0KQEAgLTMzNCw2ICszMzQs
MTIgQEAgaW50IHdmeF9jb25mX3R4KHN0cnVjdCBpZWVlODAyMTFfaHcgKmh3LCBzdHJ1Y3QgaWVl
ZTgwMjExX3ZpZiAqdmlmLA0KIAllZGNhLT5jd19tYXggPSBwYXJhbXMtPmN3X21heDsNCiAJZWRj
YS0+dHhfb3BfbGltaXQgPSBwYXJhbXMtPnR4b3AgKiBUWE9QX1VOSVQ7DQogCWVkY2EtPmFsbG93
ZWRfbWVkaXVtX3RpbWUgPSAwOw0KKwllZGNhLT5xdWV1ZV9pZCA9IDMgLSBxdWV1ZTsNCisJLy8g
QVBJIDIuMCBoYXMgY2hhbmdlZCBxdWV1ZSBJRHMgdmFsdWVzDQorCWlmICh3ZnhfYXBpX29sZGVy
X3RoYW4od2RldiwgMiwgMCkgJiYgcXVldWUgPT0gSUVFRTgwMjExX0FDX0JFKQ0KKwkJZWRjYS0+
cXVldWVfaWQgPSBISUZfUVVFVUVfSURfQkFDS0dST1VORDsNCisJaWYgKHdmeF9hcGlfb2xkZXJf
dGhhbih3ZGV2LCAyLCAwKSAmJiBxdWV1ZSA9PSBJRUVFODAyMTFfQUNfQkspDQorCQllZGNhLT5x
dWV1ZV9pZCA9IEhJRl9RVUVVRV9JRF9CRVNURUZGT1JUOw0KIAloaWZfc2V0X2VkY2FfcXVldWVf
cGFyYW1zKHd2aWYsIGVkY2EpOw0KIA0KIAlpZiAod3ZpZi0+dmlmLT50eXBlID09IE5MODAyMTFf
SUZUWVBFX1NUQVRJT04pIHsNCkBAIC0xMzkzLDQ0ICsxMzk5LDYgQEAgaW50IHdmeF9hZGRfaW50
ZXJmYWNlKHN0cnVjdCBpZWVlODAyMTFfaHcgKmh3LCBzdHJ1Y3QgaWVlZTgwMjExX3ZpZiAqdmlm
KQ0KIAlpbnQgaTsNCiAJc3RydWN0IHdmeF9kZXYgKndkZXYgPSBody0+cHJpdjsNCiAJc3RydWN0
IHdmeF92aWYgKnd2aWYgPSAoc3RydWN0IHdmeF92aWYgKikgdmlmLT5kcnZfcHJpdjsNCi0JLy8g
RklYTUU6IHBhcmFtZXRlcnMgYXJlIHNldCBieSBrZXJuZWwganVzdGUgYWZ0ZXIgaW50ZXJmYWNl
X2FkZC4NCi0JLy8gS2VlcCBzdHJ1Y3QgaGlmX3JlcV9lZGNhX3F1ZXVlX3BhcmFtcyBibGFuaz8N
Ci0Jc3RydWN0IGhpZl9yZXFfZWRjYV9xdWV1ZV9wYXJhbXMgZGVmYXVsdF9lZGNhX3BhcmFtc1td
ID0gew0KLQkJW0lFRUU4MDIxMV9BQ19WT10gPSB7DQotCQkJLnF1ZXVlX2lkID0gSElGX1FVRVVF
X0lEX1ZPSUNFLA0KLQkJCS5haWZzbiA9IDIsDQotCQkJLmN3X21pbiA9IDMsDQotCQkJLmN3X21h
eCA9IDcsDQotCQkJLnR4X29wX2xpbWl0ID0gVFhPUF9VTklUICogNDcsDQotCQl9LA0KLQkJW0lF
RUU4MDIxMV9BQ19WSV0gPSB7DQotCQkJLnF1ZXVlX2lkID0gSElGX1FVRVVFX0lEX1ZJREVPLA0K
LQkJCS5haWZzbiA9IDIsDQotCQkJLmN3X21pbiA9IDcsDQotCQkJLmN3X21heCA9IDE1LA0KLQkJ
CS50eF9vcF9saW1pdCA9IFRYT1BfVU5JVCAqIDk0LA0KLQkJfSwNCi0JCVtJRUVFODAyMTFfQUNf
QkVdID0gew0KLQkJCS5xdWV1ZV9pZCA9IEhJRl9RVUVVRV9JRF9CRVNURUZGT1JULA0KLQkJCS5h
aWZzbiA9IDMsDQotCQkJLmN3X21pbiA9IDE1LA0KLQkJCS5jd19tYXggPSAxMDIzLA0KLQkJCS50
eF9vcF9saW1pdCA9IFRYT1BfVU5JVCAqIDAsDQotCQl9LA0KLQkJW0lFRUU4MDIxMV9BQ19CS10g
PSB7DQotCQkJLnF1ZXVlX2lkID0gSElGX1FVRVVFX0lEX0JBQ0tHUk9VTkQsDQotCQkJLmFpZnNu
ID0gNywNCi0JCQkuY3dfbWluID0gMTUsDQotCQkJLmN3X21heCA9IDEwMjMsDQotCQkJLnR4X29w
X2xpbWl0ID0gVFhPUF9VTklUICogMCwNCi0JCX0sDQotCX07DQotDQotCUJVSUxEX0JVR19PTihB
UlJBWV9TSVpFKGRlZmF1bHRfZWRjYV9wYXJhbXMpICE9IEFSUkFZX1NJWkUod3ZpZi0+ZWRjYV9w
YXJhbXMpKTsNCi0JaWYgKHdmeF9hcGlfb2xkZXJfdGhhbih3ZGV2LCAyLCAwKSkgew0KLQkJZGVm
YXVsdF9lZGNhX3BhcmFtc1tJRUVFODAyMTFfQUNfQkVdLnF1ZXVlX2lkID0gSElGX1FVRVVFX0lE
X0JBQ0tHUk9VTkQ7DQotCQlkZWZhdWx0X2VkY2FfcGFyYW1zW0lFRUU4MDIxMV9BQ19CS10ucXVl
dWVfaWQgPSBISUZfUVVFVUVfSURfQkVTVEVGRk9SVDsNCi0JfQ0KIA0KIAl2aWYtPmRyaXZlcl9m
bGFncyB8PSBJRUVFODAyMTFfVklGX0JFQUNPTl9GSUxURVIgfA0KIAkJCSAgICAgSUVFRTgwMjEx
X1ZJRl9TVVBQT1JUU19VQVBTRCB8DQpAQCAtMTUwMSwxMyArMTQ2OSw2IEBAIGludCB3ZnhfYWRk
X2ludGVyZmFjZShzdHJ1Y3QgaWVlZTgwMjExX2h3ICpodywgc3RydWN0IGllZWU4MDIxMV92aWYg
KnZpZikNCiAJbXV0ZXhfdW5sb2NrKCZ3ZGV2LT5jb25mX211dGV4KTsNCiANCiAJaGlmX3NldF9t
YWNhZGRyKHd2aWYsIHZpZi0+YWRkcik7DQotCWZvciAoaSA9IDA7IGkgPCBJRUVFODAyMTFfTlVN
X0FDUzsgaSsrKSB7DQotCQltZW1jcHkoJnd2aWYtPmVkY2FfcGFyYW1zW2ldLCAmZGVmYXVsdF9l
ZGNhX3BhcmFtc1tpXSwNCi0JCSAgICAgICBzaXplb2YoZGVmYXVsdF9lZGNhX3BhcmFtc1tpXSkp
Ow0KLQkJaGlmX3NldF9lZGNhX3F1ZXVlX3BhcmFtcyh3dmlmLCAmd3ZpZi0+ZWRjYV9wYXJhbXNb
aV0pOw0KLQl9DQotCXd2aWYtPnVhcHNkX21hc2sgPSAwOw0KLQloaWZfc2V0X3VhcHNkX2luZm8o
d3ZpZiwgd3ZpZi0+dWFwc2RfbWFzayk7DQogDQogCXdmeF90eF9wb2xpY3lfaW5pdCh3dmlmKTsN
CiAJd3ZpZiA9IE5VTEw7DQotLSANCjIuMjAuMQ0K
