Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2D51121106
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 18:08:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727631AbfLPRIO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 12:08:14 -0500
Received: from mail-eopbgr690078.outbound.protection.outlook.com ([40.107.69.78]:42057
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727917AbfLPRHA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Dec 2019 12:07:00 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y7LV0368xuxGkVGqg6x0w+Ywz6uKiMdBn1hitwF5CZiYBqvkBtc3axYD9CG8UeFELoXSw2EdIWd9l/g0MRbi0qTBsMhhqySCIYip0X3kLY1B04PoeXpcZf/NY7g/6i3cO+cbxkuSAj0X7xjdjhcHd985irsVdzjGjlTaqIblmuKOHeHHtHZabvVm3ajbJ8amWYmdkRWpm8ZEQK3Ix1e74XZ4BJDVey/8onatqQwnDS4PpZCSDQ9K6HY8rNIPj7tIlsnFxqO/VEubemdWBulePqI+G1NnVswXji4SzTV8n40s/qSdr6xESMjK466qwKegWfA/QOCk83siqcBkVwJB+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JpekNFQ4BaFHhMa3F+Mu8dTR13JJLQ1MXOfdXlNJnzY=;
 b=jE6fzcXpCjRCHyBrnR/3VubjnL5KuaNv7K7xbheJs8kZZc9WL2uR59xXrSdXWu4yxDAenoczpUaj42LFNwY2ah96cJHoXe9Xs8ooXvk6IDx+wnMH+tQG8XUupOLmNyh+G94nyPYEoxz2L7NIWER06m9NYfLQvxQpp+MIFg8nvy6hqy8DMRxv4B0mtMLS3vFG70KBXRk4Y14WPosWHB8vMl1TYDIS8hIEQMnVJOvHeAWUvxjD9pbsSH8+SReO2+k1abgcSjy3W40xNIE4IzwewdbB0Rbln4OKUIuU935r2N6x9kT8XY5pPmU7sNDoOlYdPfhTDtDL8usMiJRqRNUAog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JpekNFQ4BaFHhMa3F+Mu8dTR13JJLQ1MXOfdXlNJnzY=;
 b=W5Wg+Ve/x1jMdbo2Gx60w3eupdY7hpptR5bBmGICLvGj2DekrUUGxMcPtlkWWtzPGc3MIlcwm+Folhl3ixMyCcm2Q5wjuhl3PmMWEfhiKjbO6DiGBE6In+49TdMo3wUy89Z3wU4aZgnRB/Re4C5hZ2mdr13UhNeLut7EyMcG5cA=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB4142.namprd11.prod.outlook.com (20.179.149.157) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.15; Mon, 16 Dec 2019 17:06:46 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2538.019; Mon, 16 Dec 2019
 17:06:46 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH 46/55] staging: wfx: drop useless wfx_scan_complete()
Thread-Topic: [PATCH 46/55] staging: wfx: drop useless wfx_scan_complete()
Thread-Index: AQHVtDLNVVOp3pR6kUO12tBC04f/PQ==
Date:   Mon, 16 Dec 2019 17:03:57 +0000
Message-ID: <20191216170302.29543-47-Jerome.Pouiller@silabs.com>
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
x-ms-office365-filtering-correlation-id: f92d0c9b-bb60-4ed9-146b-08d7824a554e
x-ms-traffictypediagnostic: MN2PR11MB4142:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB41424595FBDA5979894F249393510@MN2PR11MB4142.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:747;
x-forefront-prvs: 02530BD3AA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(396003)(346002)(136003)(376002)(39850400004)(199004)(189003)(6512007)(71200400001)(91956017)(6486002)(8676002)(2906002)(54906003)(81166006)(81156014)(186003)(76116006)(478600001)(36756003)(85182001)(85202003)(6666004)(66556008)(66476007)(66446008)(64756008)(1076003)(66574012)(316002)(2616005)(4326008)(6506007)(26005)(8936002)(4744005)(110136005)(5660300002)(107886003)(66946007)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB4142;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: p9k4/EcUHKPY2RvfMXzJ59MpvomK8iZeoBGrD33ZCBtlYWnHERaBV858g1O6HEnCR2KHLqlil+s8Wo69TRI9u6Wnta3qZwjR3OVuwjFvLsDFliR1s+SmDv0BQx9ob4wTRmcZ+gpx3GvuuytAhRQEUdqKjpqTgYDk4Y7cw76FNVvG4qxoJIYrBlbAPhgwAXj4sLBbeWedw45qYbdh3A/R7qy2BMt5Rq6Z8fBX5VzLFKIYMHM5FUqZlMMam+qVO+2p0ZsqiUVfvTbfYhoLg4k3Ma+sfK1f+fgPNMFJm5ZvKumdMh2962eI9jJ7eN+pQwxS6almoIOQP7mPP2V8Kz+Yf/ws1yC0do+Ybeuw62GWQWqw0R6tB3JYOChloqgIt0LEz1iTAvFLY8ZZluN/3INi8FjXT0h2WdRV6CH64753fKu4D50EI5ELHcXQwLoxblX0
Content-Type: text/plain; charset="utf-8"
Content-ID: <5E8CE646798A7546A5123E6CEF6AA528@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f92d0c9b-bb60-4ed9-146b-08d7824a554e
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Dec 2019 17:03:57.0276
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iZJkZNE0/JKGXrqDnWTbO4hhR17x5MXFUECnaRvZi3vrXVkhJH1Jpbe5BxWDSd/jKuTAqcnnJD7M+ZIfZNs7DA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4142
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPg0KDQpT
aW5jZSB3Znhfc2Nhbl9jb21wbGV0ZSgpIGlzIG5vdyBvbmx5IGNhbGxlZCBmcm9tDQp3Znhfc2Nh
bl9jb21wbGV0ZV9jYigpLCBpdCBtYWtlIHNlbnNlIHRvIG1lcmdlIHRoZSBib3RoIGZ1bmN0aW9u
cy4NCg0KU2lnbmVkLW9mZi1ieTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBz
aWxhYnMuY29tPg0KLS0tDQogZHJpdmVycy9zdGFnaW5nL3dmeC9zY2FuLmMgfCA5ICsrLS0tLS0t
LQ0KIDEgZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlvbnMoKyksIDcgZGVsZXRpb25zKC0pDQoNCmRp
ZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L3NjYW4uYyBiL2RyaXZlcnMvc3RhZ2luZy93
Zngvc2Nhbi5jDQppbmRleCAzOTdmZTUxMWQzNGEuLmMwNDNmMmY3OTU0MSAxMDA2NDQNCi0tLSBh
L2RyaXZlcnMvc3RhZ2luZy93Zngvc2Nhbi5jDQorKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3Nj
YW4uYw0KQEAgLTIyOCwxMiArMjI4LDYgQEAgdm9pZCB3Znhfc2Nhbl93b3JrKHN0cnVjdCB3b3Jr
X3N0cnVjdCAqd29yaykNCiAJc2NoZWR1bGVfd29yaygmd3ZpZi0+c2Nhbi53b3JrKTsNCiB9DQog
DQotc3RhdGljIHZvaWQgd2Z4X3NjYW5fY29tcGxldGUoc3RydWN0IHdmeF92aWYgKnd2aWYpDQot
ew0KLQl1cCgmd3ZpZi0+c2Nhbi5sb2NrKTsNCi0Jd2Z4X3NjYW5fd29yaygmd3ZpZi0+c2Nhbi53
b3JrKTsNCi19DQotDQogdm9pZCB3Znhfc2Nhbl9jb21wbGV0ZV9jYihzdHJ1Y3Qgd2Z4X3ZpZiAq
d3ZpZiwNCiAJCQkgIGNvbnN0IHN0cnVjdCBoaWZfaW5kX3NjYW5fY21wbCAqYXJnKQ0KIHsNCkBA
IC0yNTcsNiArMjUxLDcgQEAgdm9pZCB3Znhfc2Nhbl90aW1lb3V0KHN0cnVjdCB3b3JrX3N0cnVj
dCAqd29yaykNCiAJCQl3dmlmLT5zY2FuLmN1cnIgPSB3dmlmLT5zY2FuLmVuZDsNCiAJCQloaWZf
c3RvcF9zY2FuKHd2aWYpOw0KIAkJfQ0KLQkJd2Z4X3NjYW5fY29tcGxldGUod3ZpZik7DQorCQl1
cCgmd3ZpZi0+c2Nhbi5sb2NrKTsNCisJCXdmeF9zY2FuX3dvcmsoJnd2aWYtPnNjYW4ud29yayk7
DQogCX0NCiB9DQotLSANCjIuMjAuMQ0K
