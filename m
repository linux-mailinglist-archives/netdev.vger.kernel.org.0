Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED2D513C3E4
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 14:55:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729103AbgAONz1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 08:55:27 -0500
Received: from mail-eopbgr770084.outbound.protection.outlook.com ([40.107.77.84]:58049
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729748AbgAONzW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jan 2020 08:55:22 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iSUJberSB4cFYNHcOpcu9h/b0BWXR9GkSY2kwqDK54kMcPZrvG1zcVsZQT7ZdyyeWIO5bHduuBqHJr0aHKWRJbDTT3EZaj7krDia4r0U//IBc7coczEtNuvT+HrplAikptib6zOa9uiEfVdh89gRk8i48GubjZbBd116X/fIY5FCwTUfKn0qqHfiMRlEFzPDvtTQzIGrCpt5p6Fm0Rv301JT5SpOTd5HmePgP0vyCFB7dTtlg2JH1njqPJlOusuYHBMVqtxAXBd34d+37PlvmlQjN+5MUaJplHqxFl24YfHX6iTriRf+4NSfF3KYmwA/jsCBW148JrcpcyMQHbhrnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ld8qSg592xPJar90gdpyQ+05JoxcTxmYOxSxOuYqNVc=;
 b=eJYk/jgVBXEXIaGP8XbNHmkw5qB6eBu0RMSaxY5UQqW0beHtYu0s+pveI2+DYStSBG2rXmby4Y8fqA4orniiyW19DSW/8JXs8GP+0J02ryXlAQOCcof8PMlXE33U8PbE7ijVhpo6GhF511D9aZWULQf5Jx2bUbKlnnQf308sCNIBLXBU0SXQW/RcY0VfP0tWh+9GBrAANeEty/ViFwmvEYKm9QdszG/olwBnP11pElh5KKRl7CG89lK/bDZ2UPghGI+QyNydEm+SQEP4nSriEwi1VhjqXLJjf7Pt0W5pxvSI+93ACU55GmvXaMeHbwsjY4slOYMBH6nMaUmmcSPlkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ld8qSg592xPJar90gdpyQ+05JoxcTxmYOxSxOuYqNVc=;
 b=BEsbF6ukoof9taNiNGroJ2nGMGXBGsusk6PlBI5i2Ql+jkm7Rqrv8oUygdghxuKLBlTLLaxH7AUGKMRxE+TM5da2racOiJqzkPqf13aCxCzOQpllnbtvwh6Q125xTjkuxdWtg429FBY5eObfQHV5JGAQe2OXg1M3siTndQYb3KE=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB3661.namprd11.prod.outlook.com (20.178.252.33) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.18; Wed, 15 Jan 2020 13:55:17 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2623.018; Wed, 15 Jan 2020
 13:55:17 +0000
Received: from pc-42.home (2a01:e35:8bf5:66a0:3dbe:4cb5:6059:a948) by PR2P264CA0008.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.18 via Frontend Transport; Wed, 15 Jan 2020 13:54:48 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH v2 32/65] staging: wfx: simplify
 hif_mib_uc_mc_bc_data_frame_condition
Thread-Topic: [PATCH v2 32/65] staging: wfx: simplify
 hif_mib_uc_mc_bc_data_frame_condition
Thread-Index: AQHVy6taUxMlsa8JlEWrZwQojnOBNQ==
Date:   Wed, 15 Jan 2020 13:54:49 +0000
Message-ID: <20200115135338.14374-33-Jerome.Pouiller@silabs.com>
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
x-ms-office365-filtering-correlation-id: ea7629b4-6ed3-4c75-ed81-08d799c27d0b
x-ms-traffictypediagnostic: MN2PR11MB3661:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB3661886D6DE939D0DE0C0FE093370@MN2PR11MB3661.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:843;
x-forefront-prvs: 02830F0362
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(376002)(396003)(136003)(346002)(366004)(199004)(189003)(8886007)(6486002)(316002)(54906003)(71200400001)(36756003)(6506007)(66476007)(66446008)(66946007)(110136005)(8676002)(81166006)(81156014)(478600001)(86362001)(2616005)(4326008)(2906002)(107886003)(1076003)(16526019)(186003)(85202003)(5660300002)(6512007)(52116002)(64756008)(66556008)(85182001)(8936002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB3661;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TkB+ISDGzylQdrbMd4SIGKRH7RusE8IYnbn1hple/tREYaXUY7pqrxtl2xbU5dFvtyaIdHCSOEIdxAVAIYS2eRJQM6nDuInRaut8ZTUJjxHjIjCU9ehEuf88fqT36opTjopLOmHqwdKAqcJCTw3VHfq7LCgZkzLgw5WE2v/QYXvFAPk/cSxyimCqUi4tPLfF2OXq+XhReuO9Z0GctYH7gPjV/FzAhvu+LN6Ra5jhNslAvZABIp1EK61mAyGOAz0kxNxqMyLMGmlgLkPGRR5/3Znmbc2VlKFkjSxTBtrwiE7Ao042HQoWLHwKR495SHI/Jsem34KSvi5PeqPI+VfwHeD33JPdPTJn1G266/+3h/hU5B+mNplMB8YuxQ/U2wplJBz+OZNHQV96Zg0j79lmoUV9nfZTdUz86aS4AP0RBTvGUEmC0HauI8ms//JwqwRw
Content-Type: text/plain; charset="utf-8"
Content-ID: <184AFF4A40C0674B8D50827BDC641DAE@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea7629b4-6ed3-4c75-ed81-08d799c27d0b
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2020 13:54:49.8792
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MhLJul30lfXkVGdYTkDaymYaQcutb1WLZ3tIqrA6Dvq8LlE75remy/zJRzlnjpM/M7VLv+xZO2C3klEU0B4DCA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3661
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVGhl
IGN1cnJlbnQgQVBJIGRlZmluZXMgYml0ZmllbGRzLiBJdCBpcyBub3QgdmVyeSBjb252ZW5pZW50
LiBQcmVmZXIgdG8KdXNlIGJpdG1hc2tzLgoKU2lnbmVkLW9mZi1ieTogSsOpcsO0bWUgUG91aWxs
ZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgotLS0KIGRyaXZlcnMvc3RhZ2luZy93Zngv
aGlmX2FwaV9taWIuaCB8IDE0ICsrKystLS0tLS0tLS0tCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L2hp
Zl90eF9taWIuaCAgfCAgOSArKystLS0tLS0KIGRyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMgICAg
ICAgICB8ICA0ICsrLS0KIDMgZmlsZXMgY2hhbmdlZCwgOSBpbnNlcnRpb25zKCspLCAxOCBkZWxl
dGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl9hcGlfbWliLmgg
Yi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl9hcGlfbWliLmgKaW5kZXggMTYwM2IzMDc0YmY3Li5l
MGVmMDMzN2UwMWMgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX2FwaV9taWIu
aAorKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl9hcGlfbWliLmgKQEAgLTE4MSwxOSArMTgx
LDEzIEBAIHN0cnVjdCBoaWZfbWliX2lwdjZfYWRkcl9kYXRhX2ZyYW1lX2NvbmRpdGlvbiB7CiAJ
dTggICAgaV9wdjZfYWRkcmVzc1tISUZfQVBJX0lQVjZfQUREUkVTU19TSVpFXTsKIH0gX19wYWNr
ZWQ7CiAKLXVuaW9uIGhpZl9hZGRyX3R5cGUgewotCXU4IHZhbHVlOwotCXN0cnVjdCB7Ci0JCXU4
ICAgIHR5cGVfdW5pY2FzdDoxOwotCQl1OCAgICB0eXBlX211bHRpY2FzdDoxOwotCQl1OCAgICB0
eXBlX2Jyb2FkY2FzdDoxOwotCQl1OCAgICByZXNlcnZlZDo1OwotCX0gYml0czsKLX07CisjZGVm
aW5lIEhJRl9GSUxURVJfVU5JQ0FTVCAgIDB4MQorI2RlZmluZSBISUZfRklMVEVSX01VTFRJQ0FT
VCAweDIKKyNkZWZpbmUgSElGX0ZJTFRFUl9CUk9BRENBU1QgMHg0CiAKIHN0cnVjdCBoaWZfbWli
X3VjX21jX2JjX2RhdGFfZnJhbWVfY29uZGl0aW9uIHsKIAl1OCAgICBjb25kaXRpb25faWR4Owot
CXVuaW9uIGhpZl9hZGRyX3R5cGUgcGFyYW07CisJdTggICAgYWxsb3dlZF9mcmFtZXM7CiAJdTgg
ICAgcmVzZXJ2ZWRbMl07CiB9IF9fcGFja2VkOwogCmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdp
bmcvd2Z4L2hpZl90eF9taWIuaCBiL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX3R4X21pYi5oCmlu
ZGV4IDRkMTcxZTZjZmM5YS4uNmU4YjA1MGNiYzI1IDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdp
bmcvd2Z4L2hpZl90eF9taWIuaAorKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl90eF9taWIu
aApAQCAtMjQ2LDE1ICsyNDYsMTIgQEAgc3RhdGljIGlubGluZSBpbnQgaGlmX3NldF9tYWNfYWRk
cl9jb25kaXRpb24oc3RydWN0IHdmeF92aWYgKnd2aWYsCiAJCQkgICAgIGFyZywgc2l6ZW9mKCph
cmcpKTsKIH0KIAotLy8gRklYTUU6IHVzZSBhIGJpdGZpZWxkIGluc3RlYWQgb2YgMyBib29sZWFu
IHZhbHVlcwotc3RhdGljIGlubGluZSBpbnQgaGlmX3NldF91Y19tY19iY19jb25kaXRpb24oc3Ry
dWN0IHdmeF92aWYgKnd2aWYsIGludCBpZHgsCi0JCQkJCSAgICAgYm9vbCB1bmljLCBib29sIG11
bHRpYywgYm9vbCBicm9hZGMpCitzdGF0aWMgaW5saW5lIGludCBoaWZfc2V0X3VjX21jX2JjX2Nv
bmRpdGlvbihzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiwKKwkJCQkJICAgICBpbnQgaWR4LCB1OCBhbGxv
d2VkX2ZyYW1lcykKIHsKIAlzdHJ1Y3QgaGlmX21pYl91Y19tY19iY19kYXRhX2ZyYW1lX2NvbmRp
dGlvbiB2YWwgPSB7CiAJCS5jb25kaXRpb25faWR4ID0gaWR4LAotCQkucGFyYW0uYml0cy50eXBl
X3VuaWNhc3QgPSB1bmljLAotCQkucGFyYW0uYml0cy50eXBlX211bHRpY2FzdCA9IG11bHRpYywK
LQkJLnBhcmFtLmJpdHMudHlwZV9icm9hZGNhc3QgPSBicm9hZGMsCisJCS5hbGxvd2VkX2ZyYW1l
cyA9IGFsbG93ZWRfZnJhbWVzLAogCX07CiAKIAlyZXR1cm4gaGlmX3dyaXRlX21pYih3dmlmLT53
ZGV2LCB3dmlmLT5pZCwKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMgYi9k
cml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jCmluZGV4IDc5Mjg1OTI3YzdiZi4uMWMxYjVhNmMyNDc0
IDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jCisrKyBiL2RyaXZlcnMvc3Rh
Z2luZy93Zngvc3RhLmMKQEAgLTE0Miw4ICsxNDIsOCBAQCBzdGF0aWMgaW50IHdmeF9zZXRfbWNh
c3RfZmlsdGVyKHN0cnVjdCB3ZnhfdmlmICp3dmlmLAogCQljb25maWcubWFjX2NvbmQgfD0gMSA8
PCBpOwogCX0KIAotCS8vIEFjY2VwdCB1bmljYXN0IGFuZCBicm9hZGNhc3QKLQlyZXQgPSBoaWZf
c2V0X3VjX21jX2JjX2NvbmRpdGlvbih3dmlmLCAwLCB0cnVlLCBmYWxzZSwgdHJ1ZSk7CisJcmV0
ID0gaGlmX3NldF91Y19tY19iY19jb25kaXRpb24od3ZpZiwgMCwgSElGX0ZJTFRFUl9VTklDQVNU
IHwKKwkJCQkJCSAgSElGX0ZJTFRFUl9CUk9BRENBU1QpOwogCWlmIChyZXQpCiAJCXJldHVybiBy
ZXQ7CiAKLS0gCjIuMjUuMAoK
