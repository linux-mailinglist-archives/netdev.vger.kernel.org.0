Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E07612323F
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 17:21:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728380AbfLQQOh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 11:14:37 -0500
Received: from mail-eopbgr770078.outbound.protection.outlook.com ([40.107.77.78]:1089
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728319AbfLQQOg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Dec 2019 11:14:36 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I1GGw+CrBrRVkgkVRDzRYUWX33Nw+NFXX/j2/o7V8pqYJBPX7JRhHeWsTSy33DP4bOzUrm+/P2l2rg5TUD5e65BmZA6nf3/k/TrTTFPZPfrFgi6kBBgkUd5UXN1/4OlkG8T3ZIEgibtMM+9JmK9kTFCND7BCe82jnGYPO55WMp+Hn198yM5WYEumomYsjWTYyKjChwOwjViPlKG8u7orvjUcgDjUEAsmDgFX43bLkMS6lv0H+x22Dy0Dt6i41ibVf9USwIvxrOrCn5iedN9uKRiGJY4CJyZcogmWTeNvwHnfqnGIdJj/OSWaoTMeT+eknGXNL3xNJKg0Pf5EnV4wcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+MaZG4rkBwaB6SOqrI578ikfP+9Cx+5JWAci0T8RjR8=;
 b=IXiutTxmLav36CG+wpmtp8eAw32XIxts9euQntGldtun/fN/SH1t8wEiIvdn7iqly3QihwBbVmxzrjCcqjTe5j+U6jZHqZ++FCsmhUAwtaD4T6kK9Tp9us1zijUkD1Ddgo6htdgTH48zoNvtopYyOPCQ4khU8rRBicLMvWraGgMvKNYguZowPOhJ5P8FQX4+GZ2y5gTHtUboh4BEPJ3LFK6RkacanGxTxUGqxmXcESSCvIlPXDIhk2tql0a0WSsGaW/EoyGjsBl3QeExHInxcILFI4C9YVoylYUJH7fQTpsjbUhwJ8YhYw4nzFaGGzh+Z1bUIxb1DAk4dgI8AEuEpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+MaZG4rkBwaB6SOqrI578ikfP+9Cx+5JWAci0T8RjR8=;
 b=SOFs4whYTklH7kSp8b4r4p9q574XnJhoAmMFlkfdBh4DtGKhoUqpeN+x9iR/cWvrCM7q7xhGk54in4FLXRe305oTw2Vtu5smNTxYGjWgkFZpM19QzTI6p8IuV2ePu4eoHxiq53B/L8MFQTnOQUBMrqxB/iYalCRyd/Qnd1kQ2Hc=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB3678.namprd11.prod.outlook.com (20.178.254.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.16; Tue, 17 Dec 2019 16:14:31 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2538.019; Tue, 17 Dec 2019
 16:14:31 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH v2 03/55] staging: wfx: fix counter overflow
Thread-Topic: [PATCH v2 03/55] staging: wfx: fix counter overflow
Thread-Index: AQHVtPUPmZkDXln6Ikml0iljrbg3Ow==
Date:   Tue, 17 Dec 2019 16:14:30 +0000
Message-ID: <20191217161318.31402-4-Jerome.Pouiller@silabs.com>
References: <20191217161318.31402-1-Jerome.Pouiller@silabs.com>
In-Reply-To: <20191217161318.31402-1-Jerome.Pouiller@silabs.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR0P264CA0174.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1c::18) To MN2PR11MB4063.namprd11.prod.outlook.com
 (2603:10b6:208:13f::22)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.24.0
x-originating-ip: [37.71.187.125]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bc4656c6-2758-4efa-ccdb-08d7830c324b
x-ms-traffictypediagnostic: MN2PR11MB3678:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB367886ED77BC632F99C2FAC493500@MN2PR11MB3678.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:510;
x-forefront-prvs: 02543CD7CD
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(346002)(396003)(39840400004)(366004)(136003)(199004)(189003)(6512007)(66574012)(1076003)(4744005)(478600001)(86362001)(8936002)(110136005)(316002)(2616005)(26005)(6506007)(5660300002)(36756003)(6486002)(66946007)(66476007)(66556008)(64756008)(66446008)(71200400001)(52116002)(85182001)(81166006)(81156014)(8676002)(54906003)(107886003)(2906002)(4326008)(186003)(85202003);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB3678;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ONWwIsalOxjNbg2KQmdN9u6fpBv9K4zmZoJf3h+ak2uM5v5DQxFzuEorZQKI0/CoRep3NvJAUB1Eh2/OA74n9i0K2ernrpA43bbYez/T1h8o+09Pg/HxIFpaan7d9RMvwsW9SVKeodQcL0Dkj1G7aU6ZkSI90JC/YW6G1eLCkMCaWyfQVKs1sc5gY1zN56FiYKR+VROGJ5ZO5KQ2gKer9hCri4DyX3fq5SnIB0kMA8a2r7GlYR4+sZYmRAcDCoLsjZWDi9TnPxFH1ppJV8ET29ymCZazcTlxojMoFBHo/fSigLUpzJ6kkI7WrGnqVWq2AdYW+F0/PBhO4K4oHiGmSXbehyjFdWtevftQlWdADskuPxeGjY+Z2TG7t0gzH2opW/R7aa9BQrutqaCYATk5KFsfh4+CFtzkPYSj+lS2S09vM2gswh+YiVNZtVWEsXP0
Content-Type: text/plain; charset="utf-8"
Content-ID: <819317DD139DC9428B0DA8D01D36A1C7@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc4656c6-2758-4efa-ccdb-08d7830c324b
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Dec 2019 16:14:30.5507
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: J3exoCOmsmnvpDVWhtrqEiWJmvsxoDfwfZ+LPyHoQe3I6LUBwtL5cS7yjWuWSIMQD5DbOic2ymCn287TkNifdg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3678
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKU29t
ZSB3ZWlyZCBiZWhhdmlvcnMgd2VyZSBvYnNlcnZlZCB3aGVuIGNvbm5lY3Rpb24gaXMgcmVhbGx5
IGdvb2QgYW5kCnBhY2tldHMgYXJlIHNtYWxsLiBJdCBhcHBlYXJzIHRoYXQgc29tZXRpbWUsIG51
bWJlciBvZiBwYWNrZXRzIGluIHF1ZXVlcwpjYW4gZXhjZWVkIDI1NSBhbmQgZ2VuZXJhdGUgYW4g
b3ZlcmZsb3cgaW4gZmllbGQgdXNhZ2VfY291bnQuCgpTaWduZWQtb2ZmLWJ5OiBKw6lyw7RtZSBQ
b3VpbGxlciA8amVyb21lLnBvdWlsbGVyQHNpbGFicy5jb20+Ci0tLQogZHJpdmVycy9zdGFnaW5n
L3dmeC9kYXRhX3R4LmggfCAyICstCiAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDEg
ZGVsZXRpb24oLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2RhdGFfdHguaCBi
L2RyaXZlcnMvc3RhZ2luZy93ZngvZGF0YV90eC5oCmluZGV4IGEwZjlhZTY5YmFmNS4uZjYzZTVk
OGNmOTI5IDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2RhdGFfdHguaAorKysgYi9k
cml2ZXJzL3N0YWdpbmcvd2Z4L2RhdGFfdHguaApAQCAtMzksOCArMzksOCBAQCBzdHJ1Y3Qgd2Z4
X2xpbmtfZW50cnkgewogCiBzdHJ1Y3QgdHhfcG9saWN5IHsKIAlzdHJ1Y3QgbGlzdF9oZWFkIGxp
bms7CisJaW50IHVzYWdlX2NvdW50OwogCXU4IHJhdGVzWzEyXTsKLQl1OCB1c2FnZV9jb3VudDsK
IAl1OCB1cGxvYWRlZDsKIH07CiAKLS0gCjIuMjQuMAoK
