Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27A291210D8
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 18:07:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727641AbfLPRGQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 12:06:16 -0500
Received: from mail-dm6nam11on2086.outbound.protection.outlook.com ([40.107.223.86]:11937
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727587AbfLPRGM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Dec 2019 12:06:12 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TbHSYiQLlVPmOQPrfY9xqFE3uJOTdgNwIV/GhY/7DeVfrLLNKeS5g8LePvpsJ4ZWIO/1s0VRiNX/DM8cJyWi8XG68AUKuZPNq+/QI4FTj17l4ZinjQUMdRNxQesRiMMQ9Vw4P1iB+gxpM+mghL1LqVUwA8EUy2jH/eMnex6+xc4+iVXeZ1Go9JIR26bMRA/jtklCllIzSqeDmdutwbMHSYSim4U64my/qib66IuaJhhvGfut6mijc5w28YES8S98G84Mlc087aPLXk62AdUba9bC0XDxwJRk6ckqIvVwR7E+bR/5fCCrtNTIXRSKqY8d7Ky8PxU3JUboikrP9cIZ8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sbl/bXZ+bLDvSHnhVzHYxr0r64r3gC8dl25ybMJqtZk=;
 b=GjX4Q68j49QUlXy4K5eRNjuFAnbHTxm9LLCvv2lAtA/JsZYA814xS+HAk/F5rYRIZYhY2JVYLf90PDXbeDBsS3CdY3ZdWmRYW+fxagQLAieeQW6KurTQjEZU3uMG1AlnofPi6qkzEHZxiZdL/D/zVCE3e09iU3+CMtYrErv0QWOGrXieWG8OY28jktEblqaduT1+4tKST4lPall1G2AXEoJMG7s2u9yZBN2RYRzZbE+i+cRqSpI9Z4u6DaEwJCUU/ez2eurAyv487SO7datQUKhl3/MWxlVXaLkNog1mHdRJCZMECGWS8rD8COOPG1zHQgjdA/szXHpNFRTm06Py8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sbl/bXZ+bLDvSHnhVzHYxr0r64r3gC8dl25ybMJqtZk=;
 b=hb7KJixGFBSz1Az73vsIvguO0s4gsHAWEjZLoMdmMtfQs2e479HYB35/Rila76em5n8IS7hb4huD6r+/cJ3oO0wgvkmR+pPxltiXZruNA6ymjXVaMMTYlvlrT38iwu1Y9Hp0rDx7VaTBH5Edy3bfo1DoAGB/zpqBVAdytljWAEA=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB4445.namprd11.prod.outlook.com (52.135.37.87) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.18; Mon, 16 Dec 2019 17:06:03 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2538.019; Mon, 16 Dec 2019
 17:06:03 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH 29/55] staging: wfx: simplify handling of tx_lock in
 wfx_do_join()
Thread-Topic: [PATCH 29/55] staging: wfx: simplify handling of tx_lock in
 wfx_do_join()
Thread-Index: AQHVtDLIl4aezkfCgkuXznKYSbYPhw==
Date:   Mon, 16 Dec 2019 17:03:48 +0000
Message-ID: <20191216170302.29543-30-Jerome.Pouiller@silabs.com>
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
x-ms-office365-filtering-correlation-id: a62a2beb-a3bf-4a0b-391d-08d7824a3b62
x-ms-traffictypediagnostic: MN2PR11MB4445:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB4445EA3AE3B92E74E9ECEDC593510@MN2PR11MB4445.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 02530BD3AA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(346002)(39860400002)(366004)(396003)(136003)(189003)(199004)(110136005)(6486002)(107886003)(36756003)(186003)(316002)(66946007)(54906003)(5660300002)(66574012)(66446008)(66556008)(85182001)(66476007)(76116006)(91956017)(64756008)(2616005)(6506007)(85202003)(2906002)(26005)(71200400001)(6512007)(4326008)(8936002)(81166006)(1076003)(478600001)(86362001)(81156014)(6666004)(8676002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB4445;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vPfpSvPS0/FAOmoln+J0/kzv56U22khqbhEZfmQlPbXksg+Tjj/pDZIlYzwXyZkNklnAddE0gSx5BE8IhQ501FT5BUDM8YgXRb3kNNMIxHIxHATvAXxsou8gKL3RrqJoujh1r6z9Vs9XJ7u6Xdy5sPi6yRhqcmj7GI3UzU7lAgHcAFEQ457VS8EE37SFe+7VSGhY7fpKy6w6lz9vN9c3jQtxm1j2NVGuRnOVyW85fTwr/YDGbmeW66Jk0FygAFoIByZcbbspR5f0mq9BNhRAHDc2nt5STdWHF7nL9uRD4ss+LHy1/aziOnVbGEkoKw8IpF7qjC2Udp9i0NaEbboSmSJMQjl+oIAiP8TRfEkwiRTkOTVaKr70Ux8huEW9x1ax6wml04dPvgMOYrpcz/IdBuiOaoPYM+8Mi07QZkV0cDe2MQhGxHdx2+Uxhdi7GEUH
Content-Type: text/plain; charset="utf-8"
Content-ID: <AFFFFC358BCB3A418AE27DD4E17DC8F3@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a62a2beb-a3bf-4a0b-391d-08d7824a3b62
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Dec 2019 17:03:48.7894
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vqhydZ3X/j+BbOvuEOKsSVB9o61oyjncXMWaAgBkBikQ4fE+fN7q/l0C8Vih/zMi9d0sfUdfjo10Z+nvLwQw4w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4445
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPg0KDQpJ
biB0aGUgb2xkIGRheXMsIHdmeF9kb19qb2luKCkgY291bGQgYmUgY2FsbGVkIGZyb20gZGlmZmVy
ZW50IGNvbnRleHRzLg0KTm93IHRoYXQgd2Z4X2RvX2pvaW4oKSBpcyBjYWxsZWQgb25seSBmcm9t
IG9uZSBwbGFjZSwgaXQgaXMgY2xlYW5lciB0bw0Ka2VlcCBsb2NrIGFuZCB1bmxvY2sgb2YgZGF0
YSBpbnNpZGUgdGhlIGZ1bmN0aW9uLg0KDQpTaWduZWQtb2ZmLWJ5OiBKw6lyw7RtZSBQb3VpbGxl
ciA8amVyb21lLnBvdWlsbGVyQHNpbGFicy5jb20+DQotLS0NCiBkcml2ZXJzL3N0YWdpbmcvd2Z4
L3N0YS5jIHwgOSArKysrLS0tLS0NCiAxIGZpbGUgY2hhbmdlZCwgNCBpbnNlcnRpb25zKCspLCA1
IGRlbGV0aW9ucygtKQ0KDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYyBi
L2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMNCmluZGV4IDkzOWM2NGYxMDhlZC4uNjJlNjU0OTNh
NGZlIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYw0KKysrIGIvZHJpdmVy
cy9zdGFnaW5nL3dmeC9zdGEuYw0KQEAgLTY0NCw3ICs2NDQsNiBAQCBzdGF0aWMgdm9pZCB3Znhf
c2V0X21mcChzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiwNCiAJaGlmX3NldF9tZnAod3ZpZiwgbWZwYywg
bWZwcik7DQogfQ0KIA0KLS8qIE1VU1QgYmUgY2FsbGVkIHdpdGggdHhfbG9jayBoZWxkISAgSXQg
d2lsbCBiZSB1bmxvY2tlZCBmb3IgdXMuICovDQogc3RhdGljIHZvaWQgd2Z4X2RvX2pvaW4oc3Ry
dWN0IHdmeF92aWYgKnd2aWYpDQogew0KIAljb25zdCB1OCAqYnNzaWQ7DQpAQCAtNjU5LDYgKzY1
OCw4IEBAIHN0YXRpYyB2b2lkIHdmeF9kb19qb2luKHN0cnVjdCB3ZnhfdmlmICp3dmlmKQ0KIAkJ
CQkJCSAgICAgIGNvbmYtPmJhc2ljX3JhdGVzKSwNCiAJfTsNCiANCisJd2Z4X3R4X2xvY2tfZmx1
c2god3ZpZi0+d2Rldik7DQorDQogCWlmICh3dmlmLT5jaGFubmVsLT5mbGFncyAmIElFRUU4MDIx
MV9DSEFOX05PX0lSKQ0KIAkJam9pbi5wcm9iZV9mb3Jfam9pbiA9IDA7DQogDQpAQCAtMTE4MCwx
MCArMTE4MSw4IEBAIHZvaWQgd2Z4X2Jzc19pbmZvX2NoYW5nZWQoc3RydWN0IGllZWU4MDIxMV9o
dyAqaHcsDQogCX0NCiAJbXV0ZXhfdW5sb2NrKCZ3ZGV2LT5jb25mX211dGV4KTsNCiANCi0JaWYg
KGRvX2pvaW4pIHsNCi0JCXdmeF90eF9sb2NrX2ZsdXNoKHdkZXYpOw0KLQkJd2Z4X2RvX2pvaW4o
d3ZpZik7IC8qIFdpbGwgdW5sb2NrIGl0IGZvciB1cyAqLw0KLQl9DQorCWlmIChkb19qb2luKQ0K
KwkJd2Z4X2RvX2pvaW4od3ZpZik7DQogfQ0KIA0KIHN0YXRpYyB2b2lkIHdmeF9wc19ub3RpZnko
c3RydWN0IHdmeF92aWYgKnd2aWYsIGVudW0gc3RhX25vdGlmeV9jbWQgbm90aWZ5X2NtZCwNCi0t
IA0KMi4yMC4xDQo=
