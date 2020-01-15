Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04D5613C3F1
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 14:55:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730037AbgAONzf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 08:55:35 -0500
Received: from mail-eopbgr770047.outbound.protection.outlook.com ([40.107.77.47]:48566
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729955AbgAONze (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jan 2020 08:55:34 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HM7GncxmHJhiXvhtLMaF2WVPHimMXlhaI/8CfND1T67HtWvqJoGDHxBTjKAQWmL0VJAANBhnv7zd/Mx/bgb9WzbOE42tMEn3pYbLisoKNsHoz77f6l85RtxLAxK6XD0/kbj27M51drny1Y8G8yJYybLk/KGznXSAZw6862MJnLgzHx5iW5ORhNMrgNn+jd+L4fpfzT9bWzs/g9iPURNoKteK03kHoIf0F2d2NDy7k3ODboGAcA9auzDnhBJ03motKVj3e8sYE9rZp7sXnM5WMogHBv4BseSBtgfGtSKWXbis9wd1A8gHe2SV74HxBQYb/JA85teQBICf2qPv0bZu5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S58a9nBVLutMsEJZPV8bHoCpGXQyMjCyT50cVLTOSZ8=;
 b=LytiwQ0WnQ3aMLBlk5J0xVmUkukhMtSI0HIEPxxKVbC+bz3GCMaaZAFGt8X5PMHz1KFti/DwFHaFM35DFla0zu1sjrbqFDP2ujgL4bXcEtsZWmquyjyuu7WaDB5dCfQtCU2Su6I4xJb1iNSWx2TSElRwq4wwp+YdMDDth2zMuqEHy+HFKIzqtJNwXQiPSb+jC4IjLMPKOzh3OjQXH/yUIuk9rTYnDk37ze9pQh9l5o7UR67/KsLogPDXQ1L2ZoilNmw6s3kGPniPMJwqTg1ovqYZbzEhlMUT3UPcB/WiRobVNI2F73jg3jCz5mDeTqM68Vlpttb0wgoyla7scSP0lA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S58a9nBVLutMsEJZPV8bHoCpGXQyMjCyT50cVLTOSZ8=;
 b=IP5fm4u34uT+JdFfSsJqyoYe+ruNjaVKiUKH47+8e8wZRlyCbJk79OPz0lx4nZnuFEzN8zH1OZEUqur6Mq1og8+b8bgSA5D7etr73mQpYG8W2ukibjE+HGf6K0wO1XPgsg+KWJYbox2227Mnn4m4XfdcL3v2IdG8Sa/6fOZUaIw=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB3661.namprd11.prod.outlook.com (20.178.252.33) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.18; Wed, 15 Jan 2020 13:55:25 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2623.018; Wed, 15 Jan 2020
 13:55:25 +0000
Received: from pc-42.home (2a01:e35:8bf5:66a0:3dbe:4cb5:6059:a948) by PR2P264CA0008.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.18 via Frontend Transport; Wed, 15 Jan 2020 13:55:11 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH v2 48/65] staging: wfx: fix RCU usage
Thread-Topic: [PATCH v2 48/65] staging: wfx: fix RCU usage
Thread-Index: AQHVy6toAXQ1JWeWU06vV4WjT0TLSw==
Date:   Wed, 15 Jan 2020 13:55:12 +0000
Message-ID: <20200115135338.14374-49-Jerome.Pouiller@silabs.com>
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
x-ms-office365-filtering-correlation-id: 9789353e-7c4a-4ae6-1977-08d799c28a6b
x-ms-traffictypediagnostic: MN2PR11MB3661:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB3661E9DF9AAED8B1DFAEA6ED93370@MN2PR11MB3661.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:390;
x-forefront-prvs: 02830F0362
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(376002)(396003)(136003)(346002)(366004)(199004)(189003)(8886007)(6486002)(316002)(54906003)(71200400001)(36756003)(6506007)(66476007)(66446008)(66946007)(110136005)(8676002)(81166006)(81156014)(478600001)(86362001)(2616005)(4326008)(66574012)(2906002)(107886003)(1076003)(16526019)(186003)(85202003)(5660300002)(6512007)(52116002)(64756008)(66556008)(85182001)(8936002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB3661;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pNuT7HyEhSwa2PfBEQdtUe6p9koYyyWtEpASn+sJOgIOUMWix8TKPchbJqilopLPT1yy5Ct46GZdttuPrFHyKG5mACGHdT9boYACpfojl+1vwKRPqS8600MoazBXnvkkpZogqIlXy6miFY9DwGmN2MFKlNdKGf4gUGezPVYUQLInVUQ+4bBpV/ULO2M/N/ADpd6o+HgBxukDUWIyuU+k5MYj5RnVNZnNaUmYWEKAFP+QgpJMq4O3Yr3pasR091YhEXCIk6lKpAisrAQ4OlVrLsbsecIt5DzdKR8jdiv0wBsXhpHDtVx5twZ7T3TXAY+btjHWmIGKggBR/UQbF9dLRKiMKJCM4EtTPF0LsAT5xxxAFwPVgNuH59Z7LDzHpKy0ODc9U93jMjLPJ9q4n8vwrTwY2yCD0XqKAW0eEGaREqIrFOqrFpLQPoceJ9Abq1gD
Content-Type: text/plain; charset="utf-8"
Content-ID: <E2D97004960FF14BA82276E764D9FDDF@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9789353e-7c4a-4ae6-1977-08d799c28a6b
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2020 13:55:12.3023
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IKiWCp7PdyIs6DS/6TjL7DsCgtvC7UTF+EqS7QNsMz/I+aL9IDBY1TRQLcumDNbwosqYlbC8x2BgUx04oB252Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3661
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKSW5k
ZWVkLCBzdGEgd2FzIHVzZWQgYWZ0ZXIgY2FsbCB0byByY3VfdW5sb2NrKCkKClNpZ25lZC1vZmYt
Ynk6IErDqXLDtG1lIFBvdWlsbGVyIDxqZXJvbWUucG91aWxsZXJAc2lsYWJzLmNvbT4KLS0tCiBk
cml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jIHwgNCArKy0tCiAxIGZpbGUgY2hhbmdlZCwgMiBpbnNl
cnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93
Zngvc3RhLmMgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jCmluZGV4IDFjMTBlYmQxMTk0NC4u
Y2M3Mjg3N2EwOTBmIDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jCisrKyBi
L2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMKQEAgLTY5MCwxMCArNjkwLDkgQEAgc3RhdGljIHZv
aWQgd2Z4X2pvaW5fZmluYWxpemUoc3RydWN0IHdmeF92aWYgKnd2aWYsCiAJc3RydWN0IGllZWU4
MDIxMV9zdGEgKnN0YSA9IE5VTEw7CiAKIAl3dmlmLT5iZWFjb25faW50ID0gaW5mby0+YmVhY29u
X2ludDsKLQlyY3VfcmVhZF9sb2NrKCk7CisJcmN1X3JlYWRfbG9jaygpOyAvLyBwcm90ZWN0IHN0
YQogCWlmIChpbmZvLT5ic3NpZCAmJiAhaW5mby0+aWJzc19qb2luZWQpCiAJCXN0YSA9IGllZWU4
MDIxMV9maW5kX3N0YSh3dmlmLT52aWYsIGluZm8tPmJzc2lkKTsKLQlyY3VfcmVhZF91bmxvY2so
KTsKIAlpZiAoc3RhKQogCQl3dmlmLT5ic3NfcGFyYW1zLm9wZXJhdGlvbmFsX3JhdGVfc2V0ID0K
IAkJCXdmeF9yYXRlX21hc2tfdG9faHcod3ZpZi0+d2Rldiwgc3RhLT5zdXBwX3JhdGVzW3d2aWYt
PmNoYW5uZWwtPmJhbmRdKTsKQEAgLTcxMiw2ICs3MTEsNyBAQCBzdGF0aWMgdm9pZCB3Znhfam9p
bl9maW5hbGl6ZShzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiwKIAl3dmlmLT5ic3NfcGFyYW1zLmFpZCA9
IGluZm8tPmFpZDsKIAogCWhpZl9zZXRfYXNzb2NpYXRpb25fbW9kZSh3dmlmLCBpbmZvLCBzdGEg
PyAmc3RhLT5odF9jYXAgOiBOVUxMKTsKKwlyY3VfcmVhZF91bmxvY2soKTsKIAogCWlmICghaW5m
by0+aWJzc19qb2luZWQpIHsKIAkJaGlmX2tlZXBfYWxpdmVfcGVyaW9kKHd2aWYsIDMwIC8qIHNl
YyAqLyk7Ci0tIAoyLjI1LjAKCg==
