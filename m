Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CAC9C1210AC
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 18:05:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726683AbfLPRFX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 12:05:23 -0500
Received: from mail-eopbgr700081.outbound.protection.outlook.com ([40.107.70.81]:14720
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726986AbfLPRD4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Dec 2019 12:03:56 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ABtkUdS5OoLTYmauaZp2k1i9wKTlF7cgBvlkqqR54pxDMiQiMR2cFUbXItbtt0SUyWBRPgKBwmuCLu0O07bf90mtOE2HvxW6mKE55bUBQTTZKr56JvAa8HoTavFHGasVIinjxWtrSg2IAnzpbvf7AU9r/7a232BZ+yJTqOb7ERqMWf9hjc6MQInlDzMdLZQ2sJ53yR7YtwWj60ye8DMrx/ylB+AeXzpLQQVv5UOCEYlOVuPprEeChfBwFh+2z90CmUF36W6LpqwqYIcvEF0nbxyzJz7mpT8xHGMBEBeQl9xtYgvimX1H6NpM0DKD/+BFfxquzTOd2gdUbUwhgxdj2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GQ1wUgzGThqBHCCC7BiSXV1bPyuYRh0fIY7GAdOUM+w=;
 b=mhmQ9Km8LpLQqqVYvEpRD6jPI706x/c+fOX4bNz4B+UMvCieth4HwB3V2fNwvOU+bw9hgCj0Rhyg+jMwkoNHMumh8cUUiN+dR+5Kp274jMKIsmhoNiHaEFUWH4pvmMj41uK3QeruvIwkkKlDEob7H5hUMD60x9K7vH3khmY/yxjlfWGPcN7wvY/P8jNcjDKidDwYdG4BArg7f3hcZkb1+DyN5EutFAShjuQbM1vqVrEmwiV5ijlIQmXqTJZOPjQkq3OmxiWR3qPBgdwclg3EmIwx9B1+gBnqq85BsUktztfRk/itRsuGo+fP4+pFVXw6tO6xv67hHDDdM0ddd9QuBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GQ1wUgzGThqBHCCC7BiSXV1bPyuYRh0fIY7GAdOUM+w=;
 b=KJudAa2fQDke0qD27t4b3Ca059kiAUHOu+YX7bwnKPXL/gImug5fYmLIkg5rETep29FDX15czmXDGKcrF24TdtxHxdKbPMUXIUDhcdSaKU5hG8u5VfoMqdY84Gukl2yijWJOmmfFE03kwg6oqo0oo4wbgGHhvWONQRiL/K7z+F8=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB4351.namprd11.prod.outlook.com (52.135.39.159) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.19; Mon, 16 Dec 2019 17:03:49 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2538.019; Mon, 16 Dec 2019
 17:03:49 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH 16/55] staging: wfx: uniformize naming rule
Thread-Topic: [PATCH 16/55] staging: wfx: uniformize naming rule
Thread-Index: AQHVtDLE0A4sEd9z+0GEXPy3J3ik9w==
Date:   Mon, 16 Dec 2019 17:03:41 +0000
Message-ID: <20191216170302.29543-17-Jerome.Pouiller@silabs.com>
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
x-ms-office365-filtering-correlation-id: 2815f2c2-d3bd-4066-a1fa-08d78249ebd4
x-ms-traffictypediagnostic: MN2PR11MB4351:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB435152B054616A8D213757C893510@MN2PR11MB4351.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:446;
x-forefront-prvs: 02530BD3AA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(366004)(376002)(346002)(396003)(39860400002)(199004)(189003)(66556008)(66446008)(64756008)(66476007)(76116006)(85202003)(91956017)(66946007)(54906003)(107886003)(4326008)(478600001)(110136005)(71200400001)(6512007)(81156014)(8676002)(81166006)(186003)(36756003)(2906002)(85182001)(6666004)(1076003)(316002)(6506007)(5660300002)(86362001)(26005)(2616005)(6486002)(8936002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB4351;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7OL0Xw0i69GCZMFBN6quMl+ZFyECvgsrdm7Dm7uZRuiWP5jgc6deliH3MUd1ji3cRg64+CbXkTId8cdu0fU+YQh6hfcOmkv+iZWyRzugbDRwJw2O3QnqqXAzoFcUVfrAkFlr43Qkotl/prPtwbRYnLb+A33CwK2kdbiWKnc18Bx/4Vl4LsGHoW+Q71pwFpQbrYU6hhWin7i8l7n0pqTc4OYHGfdhvNytw8F7qWj0iCHh6Qx0UKUkQzq6Rp6WDY6ljmkJZYZ00RVBB+XvhA9qYMsIPlqa+/lJqa1aiQXyt7DUbZ1AsxcACqhYlI7y68CvysX9WbT5eRO0SBr+n23jK0SuIw4QlhTBImzKNRgUS/TbzTIUxmYw01b5V18kBZyXjyljmiFrgb0liy7rTE+064VLpG2BIZGBM2C2awSBomogYbljDdtzpbafKrPTrs2z
Content-Type: text/plain; charset="utf-8"
Content-ID: <226BE52A5BFD5D45ABDB1C4A4C70EB47@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2815f2c2-d3bd-4066-a1fa-08d78249ebd4
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Dec 2019 17:03:41.8393
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: h3WQvK0DKUC5M5LTeECNH7TgbgPoZavn2Shz/a4DQ42Oaz9AUL1rDlRvf7OsdiOZ4gdEWcQ6bVJFurVvLOKUvg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4351
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPg0KDQpJ
biB3ZnggZHJpdmVyLCB3aGVuIGEgZnVuY3Rpb24gaXMgdXNlZCBhcyBhIHN0cnVjdCBtZW1iZXIs
IGl0cyBuYW1lIGlzDQp0aGUgbmFtZSBvZiB0aGUgbWVtYmVyIHByZWZpeGVkIHdpdGggIndmeF8i
Lg0KDQpUaGlzIHBhdGNoIGFwcGx5IHRoaXMgcnVsZSB0byB3Znhfc3BpX3JlbW92ZSgpLg0KDQpB
bHNvIHJlbW92ZSB0aGUgdXNlbGVzcyBjb21tZW50IGFib3ZlIHRoZSBmdW5jdGlvbi4NCg0KU2ln
bmVkLW9mZi1ieTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29t
Pg0KLS0tDQogZHJpdmVycy9zdGFnaW5nL3dmeC9idXNfc3BpLmMgfCA1ICsrLS0tDQogMSBmaWxl
IGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKSwgMyBkZWxldGlvbnMoLSkNCg0KZGlmZiAtLWdpdCBh
L2RyaXZlcnMvc3RhZ2luZy93ZngvYnVzX3NwaS5jIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9idXNf
c3BpLmMNCmluZGV4IDQ0ZmM0MmJiNDNhMC4uMGEwNTVjNDA0MWFmIDEwMDY0NA0KLS0tIGEvZHJp
dmVycy9zdGFnaW5nL3dmeC9idXNfc3BpLmMNCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvYnVz
X3NwaS5jDQpAQCAtMjIzLDggKzIyMyw3IEBAIHN0YXRpYyBpbnQgd2Z4X3NwaV9wcm9iZShzdHJ1
Y3Qgc3BpX2RldmljZSAqZnVuYykNCiAJcmV0dXJuIHJldDsNCiB9DQogDQotLyogRGlzY29ubmVj
dCBGdW5jdGlvbiB0byBiZSBjYWxsZWQgYnkgU1BJIHN0YWNrIHdoZW4gZGV2aWNlIGlzIGRpc2Nv
bm5lY3RlZCAqLw0KLXN0YXRpYyBpbnQgd2Z4X3NwaV9kaXNjb25uZWN0KHN0cnVjdCBzcGlfZGV2
aWNlICpmdW5jKQ0KK3N0YXRpYyBpbnQgd2Z4X3NwaV9yZW1vdmUoc3RydWN0IHNwaV9kZXZpY2Ug
KmZ1bmMpDQogew0KIAlzdHJ1Y3Qgd2Z4X3NwaV9wcml2ICpidXMgPSBzcGlfZ2V0X2RydmRhdGEo
ZnVuYyk7DQogDQpAQCAtMjYzLDUgKzI2Miw1IEBAIHN0cnVjdCBzcGlfZHJpdmVyIHdmeF9zcGlf
ZHJpdmVyID0gew0KIAl9LA0KIAkuaWRfdGFibGUgPSB3Znhfc3BpX2lkLA0KIAkucHJvYmUgPSB3
Znhfc3BpX3Byb2JlLA0KLQkucmVtb3ZlID0gd2Z4X3NwaV9kaXNjb25uZWN0LA0KKwkucmVtb3Zl
ID0gd2Z4X3NwaV9yZW1vdmUsDQogfTsNCi0tIA0KMi4yMC4xDQo=
