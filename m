Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 584E313BFC7
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 13:16:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732389AbgAOMQY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 07:16:24 -0500
Received: from mail-bn7nam10on2064.outbound.protection.outlook.com ([40.107.92.64]:33252
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731458AbgAOMNh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jan 2020 07:13:37 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S8JZRa9IuLitV8XepUyNF2tVURV3tfJLOOhX0/YkRCgVXF1nUUhXryW+MRVXQUqGeJCKkgo/SPEzLET8oY7RgcutfgZdp5YlHKHDZ71pLJT+7hRLbj5GnyrCwjpneDmexkfXTDtIsPJqJaF4CiRUn9saZTE0M5PwOEZhi0QQjy4i9OGgV4VaJM+KCqOMtTiUDp0O1l9OeOrHDymcd+jnCgh4fIFzdCBsJhdjry0qnj0liv1LBAPRVjkfcNvZctf47fLDRw1KSJYYzW/+Wt4aTVe7783kkakg24KYfJi5Fecep9D1B6347WSKraRe1UPl1siCTWVCUh47NAJygUIPIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=deqXYivdmrIQ1V4pRuNVzQroye4fOZlmczykJ4IKe6k=;
 b=kXUxCC9l8zsMYHajV9HdePMrTesmvOWfPkJl5zjK2XCwoVAiPLJcSlnG0jh6ciDJTVLFH3x+i3Sf3hJk4xaueV4nyjU0tcB+On1qOePFkZhdc3XdnJ7sgsOprzwWMdZIza7bFMhe2wwBS+g3vu2qxsizhGJCBzvTsk/jNohVRxmFaJXcx/tTQdPT5MPaYbq/+27g0PLSko5bYWzVa2mD4AzqhNjA5p8tSWSk27Krx2/LknClY6yDuNaATKluIeM+4NP47frnfpAg4NtYIa0hsU63g81fji8EI9Ja1Z9yCjZcJCBlGTxkxiBqx5NqBBJgowddrsBL0G5q12xRs45YJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=deqXYivdmrIQ1V4pRuNVzQroye4fOZlmczykJ4IKe6k=;
 b=KkBCNfdPcXjVDv2AeGUckCTx7zur7iVIpE6UXk62EXblAOe1V3hVv+l8BjpB5eTPpR97cMnNWsY+INIKn6rfIdvADOXhi7NX31FTM0lcxTS20iPeJKQZ9Xh84d1tfgMpYEX6LgqMEp2BYNJR44+D1BmUYQqBRCO/0NJh8Q6qZGA=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB3934.namprd11.prod.outlook.com (10.255.180.212) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.20; Wed, 15 Jan 2020 12:13:27 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2623.018; Wed, 15 Jan 2020
 12:13:27 +0000
Received: from pc-42.silabs.com (37.71.187.125) by PR2PR09CA0009.eurprd09.prod.outlook.com (2603:10a6:101:16::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.18 via Frontend Transport; Wed, 15 Jan 2020 12:13:05 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH 43/65] staging: wfx: fix case where RTS threshold is 0
Thread-Topic: [PATCH 43/65] staging: wfx: fix case where RTS threshold is 0
Thread-Index: AQHVy50kG5G+Faw/0UycvuxK/spbsw==
Date:   Wed, 15 Jan 2020 12:13:06 +0000
Message-ID: <20200115121041.10863-44-Jerome.Pouiller@silabs.com>
References: <20200115121041.10863-1-Jerome.Pouiller@silabs.com>
In-Reply-To: <20200115121041.10863-1-Jerome.Pouiller@silabs.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR2PR09CA0009.eurprd09.prod.outlook.com
 (2603:10a6:101:16::21) To MN2PR11MB4063.namprd11.prod.outlook.com
 (2603:10b6:208:13f::22)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.25.0
x-originating-ip: [37.71.187.125]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f5c65040-9760-41a4-49cf-08d799b44701
x-ms-traffictypediagnostic: MN2PR11MB3934:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB3934757A3982F984AA5DDF6793370@MN2PR11MB3934.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2958;
x-forefront-prvs: 02830F0362
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(136003)(39860400002)(376002)(366004)(346002)(199004)(189003)(54906003)(110136005)(86362001)(956004)(107886003)(2616005)(316002)(36756003)(71200400001)(52116002)(7696005)(478600001)(8936002)(81156014)(8676002)(4326008)(81166006)(6486002)(2906002)(26005)(66946007)(16526019)(186003)(5660300002)(66574012)(1076003)(66556008)(64756008)(66446008)(4744005)(85182001)(66476007)(85202003);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB3934;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Jf4tpGdOdTO3Ebv1sNh4datFZgdQMLmx2Gtf43AUnqYxhJNiahIBmi0BI+zF1bEZUgqtud4W0N2Zsre5sTVvxysDZ8QKjPzTPRxGpY1Y9DPIOQW/rBdvg1yuOo1OpKGu6xzGeFoZofP7815anw7oyES/fioV147jFdgqDCpF071N64JDaPePoT/BFMB/sDr4d/Nmlk97fKYC77sLCH/3FPs2PdOqkI3PqlcLaon5KbeFE+NtK1PR+Zu6qY90m1lyW8e4ldqVzjQ7VrF2ASkDymQ+dPV6LRyimxDkJKloyh4xD/AZkMc2Fb98FRQDuPL0v9fXemyHneRudD3AEn1f/h2/xLmGajG9b27DzyIM/adjGG+sCiHx9S2+qkHyWXiT3ObSNCxaZSCjkMw+DWTvJjAeJ4ns/Bko2OzhI2enu7JpHOqTltr0DAyWIKLpGuRx
Content-Type: text/plain; charset="utf-8"
Content-ID: <B24FE2A77D0A674294143C9DF0A70EEB@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f5c65040-9760-41a4-49cf-08d799b44701
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2020 12:13:06.3532
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0LtHWpH9fKgynkeVzYTClfioIz1JeE3c/mGeZCGYdBmjtTbvzsD1tRZu2ws+pLcsluJN8bk1y4QJC/CNjERh9Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3934
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKSWYg
UlRTIHRocmVzaG9sZCBpcyAwLCBpdCBjdXJyZW50bHkgZGlzYWJsZXMgUlRTLiBJdCBzaG91bGQg
bWVhbgoiZW5hYmxlZCBmb3IgZXZlcnkgZnJhbWVzIi4KClNpZ25lZC1vZmYtYnk6IErDqXLDtG1l
IFBvdWlsbGVyIDxqZXJvbWUucG91aWxsZXJAc2lsYWJzLmNvbT4KLS0tCiBkcml2ZXJzL3N0YWdp
bmcvd2Z4L2hpZl90eF9taWIuaCB8IDIgKy0KIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigr
KSwgMSBkZWxldGlvbigtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX3R4
X21pYi5oIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfdHhfbWliLmgKaW5kZXggY2NlYTNmMTVh
MzRkLi5iZjM3NjljMmE5YjYgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX3R4
X21pYi5oCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX3R4X21pYi5oCkBAIC0zOTEsNyAr
MzkxLDcgQEAgc3RhdGljIGlubGluZSBpbnQgaGlmX3dlcF9kZWZhdWx0X2tleV9pZChzdHJ1Y3Qg
d2Z4X3ZpZiAqd3ZpZiwgaW50IHZhbCkKIHN0YXRpYyBpbmxpbmUgaW50IGhpZl9ydHNfdGhyZXNo
b2xkKHN0cnVjdCB3ZnhfdmlmICp3dmlmLCBpbnQgdmFsKQogewogCXN0cnVjdCBoaWZfbWliX2Rv
dDExX3J0c190aHJlc2hvbGQgYXJnID0gewotCQkudGhyZXNob2xkID0gY3B1X3RvX2xlMzIodmFs
ID4gMCA/IHZhbCA6IDB4RkZGRiksCisJCS50aHJlc2hvbGQgPSBjcHVfdG9fbGUzMih2YWwgPj0g
MCA/IHZhbCA6IDB4RkZGRiksCiAJfTsKIAogCXJldHVybiBoaWZfd3JpdGVfbWliKHd2aWYtPndk
ZXYsIHd2aWYtPmlkLAotLSAKMi4yNS4wCgo=
