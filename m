Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8B30121088
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 18:05:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727144AbfLPRD7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 12:03:59 -0500
Received: from mail-eopbgr700081.outbound.protection.outlook.com ([40.107.70.81]:14720
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726515AbfLPRD6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Dec 2019 12:03:58 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EOkUvFM8twKoNiba5w4jisDGtsQHOwmQMLBiIv7qRqrxXlG6vpdCTh6BxJL4qEOmuaQcI+oEtjiObJggyPDoqgFV8hRqJNSSvK4WCtT3jqTElvdza9c5+TXmwrLPbFxRPEQyLE08sqykzk2GdRPD8Ph8HZHLB79v26CVB+JbtaFAg1+aR3MkOOtug6xBOMFlqaUrtdmE7xGU1ZvMhOXxpLaqEjOQJt/Q6foQapq1W4aTL6AZAZb+s30BCu0d+WR+db6GXGM4VNyv5drEjTFK7Pmd6H8tP/NExu7Db9ndAJuveLFYCbNrN39HQJZINlaHr4oP/7nM6N7GiA1JUv4QrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/Mo2itiTF5m1qzhffnA/bW5IxdEA8d25A9M1cz1TO1E=;
 b=OCU7+x6r8FhuftnqCBl4HKiO8M1UFDY7HDclnEFm1gk3mffHhEKCz2WaVwTGb+xP/wiqCJe0LXT5FxUgMsDdX7VorH+l2/7BK9sWsbeMOPoWsR4TDO8R9taLcyr+v+ZMnlGnJhyblBwEqTQmp2OzR8+4WIDbFV/lPfJBAhKzw+uzizKxf3Ghcwj6ZOFOa/Nezvrcz8jn1BTX35SmgrAAlPnfDDxvYMq1Ouz5DYo8cQ3IpLJRqXUNCrwz6WrA7uaG1AqTdj5ndujA5PjrEnynbiGZZpHxUqmEncTEtPl495zRXIG//fwEUuFsF9vOkAEdCm3tqGWZLXU5xcWnKp952Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/Mo2itiTF5m1qzhffnA/bW5IxdEA8d25A9M1cz1TO1E=;
 b=U6he/W+lv7xiG+iRe5W6mG1IXntfuQzHqSTNFC5NbVdi7a9xzWZLyCyIU7vR+tl98Q5mRHGZUwL76tTTlyzw6C59V9DW7IRNZbVJsS1AW17/53LY6Zwl5Pb1ZFEToi56U0+B/c17Y6LZsVbv1n75+DsGJ8oa/emI8r6MAZJd4TA=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB4351.namprd11.prod.outlook.com (52.135.39.159) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.19; Mon, 16 Dec 2019 17:03:51 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2538.019; Mon, 16 Dec 2019
 17:03:51 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH 19/55] staging: wfx: simplify variable assignment
Thread-Topic: [PATCH 19/55] staging: wfx: simplify variable assignment
Thread-Index: AQHVtDLFGbHH6ktqZk2PryyWpHB1AQ==
Date:   Mon, 16 Dec 2019 17:03:43 +0000
Message-ID: <20191216170302.29543-20-Jerome.Pouiller@silabs.com>
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
x-ms-office365-filtering-correlation-id: c6f09ae2-483c-40ff-7414-08d78249ecb1
x-ms-traffictypediagnostic: MN2PR11MB4351:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB435187FD862223DD9350DEF893510@MN2PR11MB4351.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:206;
x-forefront-prvs: 02530BD3AA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(366004)(376002)(346002)(396003)(39860400002)(199004)(189003)(66556008)(66446008)(64756008)(66476007)(76116006)(85202003)(91956017)(66946007)(4744005)(54906003)(107886003)(4326008)(478600001)(110136005)(71200400001)(6512007)(81156014)(8676002)(81166006)(186003)(36756003)(2906002)(85182001)(6666004)(66574012)(1076003)(316002)(6506007)(5660300002)(86362001)(26005)(2616005)(6486002)(8936002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB4351;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: u0bA11iaNzLNiwDTs/Izgg6tTtb8AHvfdrjqUy50wc3uEG5fVq/oU3fBbEQHoNBU52tKmWERSwQJl3887CNQs/hKY8IXXO4p9/nVJcnh0abRT+I9zaDB3tOKRraLKX6MJMOK+ortXKNBWOGeCwcnPx7zS3NsUkdTTDHRiMbEBqZI7UZSlDYdR0yvDtMWNiS69WAUqzjwUNXTffgQxFNRDxM8UokoEltOIBKCaOCN6MvF6Pa+6CoQ9ynF9oQBCDjr6VUaA92DlJRKoZ1FnxjGwBb6F4MxNV/TkmD6e7uqSEzZu1XMRrGvFHAccARqpzegOPv19I5POLfFKv/0+PxsS9L7mojSuGvih5e5BDyueVI2cO5U8v5zEqsQNrO0ULtPBnNI+FiTSoDFXpfLm3Z4o9GZfjeC9XG6KeoJ8wzO4YhaJrwfh2N2+Oe87v60Yfjy
Content-Type: text/plain; charset="utf-8"
Content-ID: <B2D52BA8DC33CD479C8F088B73BDD8CA@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c6f09ae2-483c-40ff-7414-08d78249ecb1
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Dec 2019 17:03:43.1696
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /XGZWC9Pxh3AKYx4ou8XrQ6jx5ZzIv+d1YWgyHca0okZl8xoovPiY5hHza5ytdcjQNgunyFnwuNJNybfWBXLiA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4351
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPg0KDQpB
dHRyaWJ1dGUgImFib3J0ZWQiIGFuZCBhcmd1bWVudCAiYWJvcnRlZCIgYXJlIGJvdGggYm9vbGVh
bnMuDQoNClNpZ25lZC1vZmYtYnk6IErDqXLDtG1lIFBvdWlsbGVyIDxqZXJvbWUucG91aWxsZXJA
c2lsYWJzLmNvbT4NCi0tLQ0KIGRyaXZlcnMvc3RhZ2luZy93Zngvc2Nhbi5jIHwgMiArLQ0KIDEg
ZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlvbigtKQ0KDQpkaWZmIC0tZ2l0
IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9zY2FuLmMgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3NjYW4u
Yw0KaW5kZXggMzVmY2Y5MTE5Zjk2Li5hNmM5MzQwMGE3YmEgMTAwNjQ0DQotLS0gYS9kcml2ZXJz
L3N0YWdpbmcvd2Z4L3NjYW4uYw0KKysrIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9zY2FuLmMNCkBA
IC0xNiw3ICsxNiw3IEBAIHN0YXRpYyB2b2lkIF9faWVlZTgwMjExX3NjYW5fY29tcGxldGVkX2Nv
bXBhdChzdHJ1Y3QgaWVlZTgwMjExX2h3ICpodywNCiAJCQkJCSAgICAgIGJvb2wgYWJvcnRlZCkN
CiB7DQogCXN0cnVjdCBjZmc4MDIxMV9zY2FuX2luZm8gaW5mbyA9IHsNCi0JCS5hYm9ydGVkID0g
YWJvcnRlZCA/IDEgOiAwLA0KKwkJLmFib3J0ZWQgPSBhYm9ydGVkLA0KIAl9Ow0KIA0KIAlpZWVl
ODAyMTFfc2Nhbl9jb21wbGV0ZWQoaHcsICZpbmZvKTsNCi0tIA0KMi4yMC4xDQo=
