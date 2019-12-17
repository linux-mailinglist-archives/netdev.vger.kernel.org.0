Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9095A12318E
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 17:16:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729125AbfLQQQE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 11:16:04 -0500
Received: from mail-dm6nam12on2072.outbound.protection.outlook.com ([40.107.243.72]:33729
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728755AbfLQQQC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Dec 2019 11:16:02 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B2e09eJlnJc9bDFQA+znnFFNisREeGhmVJF2cteRr2Y8cNmWFpZz98h9z/mqPlULNZSH1jthfNev+i1TZKUXYbc+bx5TST8Wqkcl59luLVwct+L/yJp7e65vLKjwyT9xqOxlapppUFI0f2AhZZ9pJ/jenpzkN+XdKHXymk5WTqr7CDjHQ+qfyv6mOv11OxEnppE9aVMBqdVVICs4oEmKEiAI8M38ZOZjramTsJUsw/iLPgb5KpcdXs83saVYZtDsrvmtFQLRXNUmeWJEEMJuPqkfjl5sN6S8BZPX7C3A6310OsbETIBuK64B08yb+Waj5ADQMzxbBTCGZve4+ykDfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WG7mVDBIsOq/9wU8ZAkU7UURWDrXtRLbBUtGNBqDBOI=;
 b=jU/SuQRHE3HMkcgVKMxrINzin3VJINlnPsQXdK37RLhQwwX8JU9kHvSb8sCktqSbDub/VgZ6u6cmPuD+f/cvilC2SZpOiUYblOy7O2+KAJiKklA6B7Rsp0wjVUuYKwwz9KlHUlPzlcS4SA2iLgNQux3Wf29WcR8762V2R9RyxJljw5d1f6uWZNAL5hLXrtJnwXCuZGzeLYc6wrl5xhGylC0MMPGevAOanzlNgSSM3haSoJXk0u5nW262F6zRELek5/0rolRiQbMt+saALSuWuqTQamxXS9IPcN5owrWdWusvOqS4fsQvxCsU7tNuokgqoa24SCwkq3+SzkZ0PqphHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WG7mVDBIsOq/9wU8ZAkU7UURWDrXtRLbBUtGNBqDBOI=;
 b=Zh8UaDBUfoGkkFSTiD9lVJfUtfjDX4vjU1P521llDcd493Y4ojgjrELdzDk91wZKPbr4OeTnt9QiGYFIu65FY6Gp6qUdMDOTMU5CrsUuIe5HMXLhtyeLD3D2iuBWfjIA4DT1TsMGHFL1C6IB3U++zPYvtJPbq14vfLEOzmqZ/Ek=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB4477.namprd11.prod.outlook.com (52.135.36.93) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.17; Tue, 17 Dec 2019 16:15:54 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2538.019; Tue, 17 Dec 2019
 16:15:54 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH v2 46/55] staging: wfx: drop useless wfx_scan_complete()
Thread-Topic: [PATCH v2 46/55] staging: wfx: drop useless wfx_scan_complete()
Thread-Index: AQHVtPUzSLDxS8jNvEC7gRp7wIri1g==
Date:   Tue, 17 Dec 2019 16:15:30 +0000
Message-ID: <20191217161318.31402-47-Jerome.Pouiller@silabs.com>
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
x-ms-office365-filtering-correlation-id: d3da11f6-715b-48df-a64d-08d7830c564e
x-ms-traffictypediagnostic: MN2PR11MB4477:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB447756255FF1641C22A8018493500@MN2PR11MB4477.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:747;
x-forefront-prvs: 02543CD7CD
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(346002)(396003)(136003)(366004)(39860400002)(199004)(189003)(1076003)(66574012)(186003)(107886003)(8676002)(4744005)(6506007)(86362001)(478600001)(85182001)(5660300002)(81156014)(26005)(4326008)(6486002)(8936002)(316002)(110136005)(54906003)(64756008)(66446008)(66946007)(2616005)(66556008)(66476007)(85202003)(36756003)(6512007)(2906002)(52116002)(6666004)(71200400001)(81166006);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB4477;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UPE1fycq4WRyrxg0DUcA+u5cFPk/w9+oF+JtzrlTml45sV/x7DkOmPQny2AH5uz0ZqVvJNQJpd2dYwqgu5bhyFhX/iwxDJ5akgYIzgtQIqGhvyIB/8bz/TDIijpKOe/3yT0Iz18VVMYoDE3d5dAuZ+O94DYfuWKn9Uubkc2xLFmAQ6nuRG7cYEpiVFg/FOW8yPJ21Dm6R86iaKhz9nb/LQD+hXArggIhx5J70SbqeA9iOph1LHdXnFwgu3NRHLriGZgwf3G6PdKKYNLm/pmysZ59ZZvEjMwmMm0yiF7k5zpZmby2jdaYztKlF5mhE60+pwvjyuakWwM3LupdC1vZP4ZVaVm4SPORKMWyDwJXt0cfUZY1OFk6hpYe33KjZevqvuV9+HLDpt/wBYYnA2xIqzJqagNZFLqSbTUnWxDH1dOGOvmqqS/iQNaYOWYPKJMl
Content-Type: text/plain; charset="utf-8"
Content-ID: <BA646E25EA666C49A3877DF0285DF080@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d3da11f6-715b-48df-a64d-08d7830c564e
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Dec 2019 16:15:30.8474
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bTcEyRO707FW0HTFKg9ogoQKk+XoM58XjPR96ozOe+kUQbA6aAjxIOmCRhdC+Vz+3/227pJqsotavaRrtPax2w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4477
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKU2lu
Y2Ugd2Z4X3NjYW5fY29tcGxldGUoKSBpcyBub3cgb25seSBjYWxsZWQgZnJvbQp3Znhfc2Nhbl9j
b21wbGV0ZV9jYigpLCBpdCBtYWtlIHNlbnNlIHRvIG1lcmdlIHRoZSBib3RoIGZ1bmN0aW9ucy4K
ClNpZ25lZC1vZmYtYnk6IErDqXLDtG1lIFBvdWlsbGVyIDxqZXJvbWUucG91aWxsZXJAc2lsYWJz
LmNvbT4KLS0tCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L3NjYW4uYyB8IDkgKystLS0tLS0tCiAxIGZp
bGUgY2hhbmdlZCwgMiBpbnNlcnRpb25zKCspLCA3IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBh
L2RyaXZlcnMvc3RhZ2luZy93Zngvc2Nhbi5jIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9zY2FuLmMK
aW5kZXggMzk3ZmU1MTFkMzRhLi5jMDQzZjJmNzk1NDEgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3Rh
Z2luZy93Zngvc2Nhbi5jCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93Zngvc2Nhbi5jCkBAIC0yMjgs
MTIgKzIyOCw2IEBAIHZvaWQgd2Z4X3NjYW5fd29yayhzdHJ1Y3Qgd29ya19zdHJ1Y3QgKndvcmsp
CiAJc2NoZWR1bGVfd29yaygmd3ZpZi0+c2Nhbi53b3JrKTsKIH0KIAotc3RhdGljIHZvaWQgd2Z4
X3NjYW5fY29tcGxldGUoc3RydWN0IHdmeF92aWYgKnd2aWYpCi17Ci0JdXAoJnd2aWYtPnNjYW4u
bG9jayk7Ci0Jd2Z4X3NjYW5fd29yaygmd3ZpZi0+c2Nhbi53b3JrKTsKLX0KLQogdm9pZCB3Znhf
c2Nhbl9jb21wbGV0ZV9jYihzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiwKIAkJCSAgY29uc3Qgc3RydWN0
IGhpZl9pbmRfc2Nhbl9jbXBsICphcmcpCiB7CkBAIC0yNTcsNiArMjUxLDcgQEAgdm9pZCB3Znhf
c2Nhbl90aW1lb3V0KHN0cnVjdCB3b3JrX3N0cnVjdCAqd29yaykKIAkJCXd2aWYtPnNjYW4uY3Vy
ciA9IHd2aWYtPnNjYW4uZW5kOwogCQkJaGlmX3N0b3Bfc2Nhbih3dmlmKTsKIAkJfQotCQl3Znhf
c2Nhbl9jb21wbGV0ZSh3dmlmKTsKKwkJdXAoJnd2aWYtPnNjYW4ubG9jayk7CisJCXdmeF9zY2Fu
X3dvcmsoJnd2aWYtPnNjYW4ud29yayk7CiAJfQogfQotLSAKMi4yNC4wCgo=
