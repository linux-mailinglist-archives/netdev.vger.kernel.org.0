Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45D3C13C42C
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 14:56:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730422AbgAON4v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 08:56:51 -0500
Received: from mail-eopbgr770085.outbound.protection.outlook.com ([40.107.77.85]:39089
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730398AbgAON4t (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jan 2020 08:56:49 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jHonwi+pro3YE3G1JYfQA1PjxBusA9UjxrOUMJkE+QfJy5pGPaeS7fL5M93uthU+0fJ7stO9O2rFljB4rMjkSJM59Gu7DiIyWtOWNn5N74iPAabcshq014fAEY1740nxLzLF+4NwkdHAaFmEx4e7qEc5KkdZ6D9fLBYYZNNLewChHVN6P6wn91J4NEhIXHs8TAWMxCFdwFqLa98HT9djn6Qc0fUlVO6NqK9GyWTkiSLBb9KniAtgRmkomASbR0QZdTwWG09UN63B4A7Kgiueg3znviUfgMczJd6eKTItSuc2y6gxtiLjDiNVPPB7RG0+hFzaUaiA5pzGB1spAcPGYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZpOPAFOQYwb3EhZHWrbwX3WD6n9UaCup1R7sH9XqU0M=;
 b=C4wXeb25IvgnVhhaYd7FnPX83Js1cyqJZ1VDA6TS9OD7ShrfLm3yWRssvI3fj0D4pmJBx65PhYSzHm716odaLv5/gBtRK8OitGHiPHtpEbYgXOmM+j5YBwrZUUnEKpADjpmwqdkIrw5L9RW1clELuw/qyx77WlERqiTnMm9eq6Ft8lonpg6z4WsDUgZUkYIXtoyhikO07AUqgAUNkT26YFS8m/3kL7y591eae0h2H4s6geftplv5Rdt2zERyEW80P0K/R9tsJEEH5zQEDvl7RhhAnJ02TIHTCB2fNl9YqM5WCFOkDpZE3wfvUtk/WB8a//EacIjovW5ePnJh94QwjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZpOPAFOQYwb3EhZHWrbwX3WD6n9UaCup1R7sH9XqU0M=;
 b=RtfU26NXq/5pU/o+hzgKtSlYxJcsSqyomG7wBptogft+TrX4KZpjnfhZ7TCwNlVc+/YvuiUXQKU/XiNinYlkvmm+q4WtWIdHgN4n4OtJZAUi5NJEz3AonOaaS+erQT45lqhVGvgv9xDiPX5W8MCvP4Lq4DC73pKn7Uj3sKJCYi8=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB3661.namprd11.prod.outlook.com (20.178.252.33) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.18; Wed, 15 Jan 2020 13:56:05 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2623.018; Wed, 15 Jan 2020
 13:56:05 +0000
Received: from pc-42.home (2a01:e35:8bf5:66a0:3dbe:4cb5:6059:a948) by PR2P264CA0008.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.18 via Frontend Transport; Wed, 15 Jan 2020 13:55:37 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH v2 65/65] staging: wfx: update TODO
Thread-Topic: [PATCH v2 65/65] staging: wfx: update TODO
Thread-Index: AQHVy6t3Hm0c29vLfEWj1uwC9bWIsA==
Date:   Wed, 15 Jan 2020 13:55:38 +0000
Message-ID: <20200115135338.14374-66-Jerome.Pouiller@silabs.com>
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
x-ms-office365-filtering-correlation-id: 520067d5-67d4-40c6-d82b-08d799c299fc
x-ms-traffictypediagnostic: MN2PR11MB3661:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB3661922BE66740947B8E625393370@MN2PR11MB3661.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 02830F0362
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(376002)(396003)(136003)(346002)(366004)(199004)(189003)(8886007)(6486002)(316002)(54906003)(71200400001)(36756003)(6506007)(66476007)(66446008)(66946007)(110136005)(8676002)(81166006)(81156014)(478600001)(86362001)(2616005)(4326008)(966005)(66574012)(2906002)(107886003)(1076003)(16526019)(186003)(85202003)(5660300002)(6512007)(52116002)(64756008)(66556008)(85182001)(8936002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB3661;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wZ65O/GVjpLWYBZOrVC3t1GhTGDbgLJtdx7GWvfK/6numk6PrYAESIFEgnpGWuvEzPk/EkFvUyDtzZcEWEg2xm5J3ONNvj7Hqr/+QdMOHnOoI9TrEvJODIEfk/uHoULuLVNG/Gj9oQ8cZ39KOGwnDk9Ah30oxXlyfutJtT/PxLs641rAAsm4+s1mJYFigPJMiuh5qCyk9NRYnDW4FppSlJ/Qe89nKk4bOr6AIizwip/eicV1WEpyDHj/4nfX3eSQXjG4tA7ig6sKKTSOS86mZzGX5Rg8pSmG/UMjN1sLPbissAVY8WW2fLO2b0NMGMNOS/H+XK0hiM5jJibxG5mdaLWs1DTEhK6t3NsYtqjaUHz72akJ1TL9eqcE6AdYw6G0c8DFqYoB7Me/XrXikHANBQK8AtejS51IsUgemj/TxcrR8YdplLFErktKj5wqOL94CEPehTVBqdDso11Q5UmiZ3e7aSp2BsbBD13rYvnRwJVOtOr7WsWkHlu6USoMDuzIQ9xrXT0N6reIjYVi9xIXyw==
Content-Type: text/plain; charset="utf-8"
Content-ID: <91381A686DCA8B4CBCCD6ACB0CBAA276@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 520067d5-67d4-40c6-d82b-08d799c299fc
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2020 13:55:38.4183
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Qry25PzQpLxlP7WISUzMMyDNN0+93w6Uvx8n3SaVenc6zVYILQUsfzcLlWoRIhGmzl0tG3mV/dS6TzTES8q3lw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3661
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKU29t
ZSB3b3JrIGhhcyBiZWVuIGRvbmUgOikKClNpZ25lZC1vZmYtYnk6IErDqXLDtG1lIFBvdWlsbGVy
IDxqZXJvbWUucG91aWxsZXJAc2lsYWJzLmNvbT4KLS0tCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L1RP
RE8gfCAxMiArLS0tLS0tLS0tLS0KIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMTEg
ZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9UT0RPIGIvZHJp
dmVycy9zdGFnaW5nL3dmeC9UT0RPCmluZGV4IDZiMWNkZDI0YWZjOS4uZWZjYjdjNmE1YWE3IDEw
MDY0NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L1RPRE8KKysrIGIvZHJpdmVycy9zdGFnaW5n
L3dmeC9UT0RPCkBAIC0xLDE4ICsxLDggQEAKIFRoaXMgaXMgYSBsaXN0IG9mIHRoaW5ncyB0aGF0
IG5lZWQgdG8gYmUgZG9uZSB0byBnZXQgdGhpcyBkcml2ZXIgb3V0IG9mIHRoZQogc3RhZ2luZyBk
aXJlY3RvcnkuCiAKLSAgLSBBbGxvY2F0aW9uIG9mICJsaW5rIGlkcyIgaXMgdG9vIGNvbXBsZXgu
IEFsbG9jYXRpb24vcmVsZWFzZSBvZiBsaW5rIGlkcyBmcm9tCi0gICAgc3RhX2FkZCgpL3N0YV9y
ZW1vdmUoKSBzaG91bGQgYmUgc3VmZmljaWVudC4KLQotICAtIFRoZSBwYXRoIGZvciBwYWNrZXRz
IHdpdGggSUVFRTgwMjExX1RYX0NUTF9TRU5EX0FGVEVSX0RUSU0gZmxhZ3Mgc2hvdWxkIGJlCi0g
ICAgY2xlYW5lZCB1cC4gQ3VycmVudGx5LCB0aGUgcHJvY2VzcyBpbnZvbHZlIG11bHRpcGxlIHdv
cmsgc3RydWN0cyBhbmQgYQotICAgIHRpbWVyLiBJdCBjb3VsZCBiZSBzaW1wbGlmZWQuIEluIGFk
ZCwgdGhlIHJlcXVldWUgbWVjaGFuaXNtIHRyaWdnZXJzIG1vcmUKLSAgICBmcmVxdWVudGx5IHRo
YW4gaXQgc2hvdWxkLgotCiAgIC0gQWxsIHN0cnVjdHVyZXMgZGVmaW5lZCBpbiBoaWZfYXBpXyou
aCBhcmUgaW50ZW5kZWQgdG8gc2VudC9yZWNlaXZlZCB0by9mcm9tCi0gICAgaGFyZHdhcmUuIEFs
bCB0aGVpciBtZW1iZXJzIHdob3VsZCBiZSBkZWNsYXJlZCBfX2xlMzIgb3IgX19sZTE2LiBUaGVz
ZQotICAgIHN0cnVjdHMgc2hvdWxkIG9ubHkgYmVlbiB1c2VkIGluIGZpbGVzIG5hbWVkIGhpZl8q
IChhbmQgbWF5YmUgaW4gZGF0YV8qLmMpLgotICAgIFRoZSB1cHBlciBsYXllcnMgKHN0YS5jLCBz
Y2FuLmMgZXRjLi4uKSBzaG91bGQgbWFuYWdlIG1hYzgwMjExIHN0cnVjdHVyZXMuCisgICAgaGFy
ZHdhcmUuIEFsbCB0aGVpciBtZW1iZXJzIHdob3VsZCBiZSBkZWNsYXJlZCBfX2xlMzIgb3IgX19s
ZTE2LgogICAgIFNlZToKICAgICAgICBodHRwczovL2xvcmUua2VybmVsLm9yZy9sa21sLzIwMTkx
MTExMjAyODUyLkdYMjY1MzBAWmVuSVYubGludXgub3JnLnVrCiAKLS0gCjIuMjUuMAoK
