Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC5DB13BF9B
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 13:15:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732469AbgAOMOh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 07:14:37 -0500
Received: from mail-co1nam11on2064.outbound.protection.outlook.com ([40.107.220.64]:28929
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732440AbgAOMOg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jan 2020 07:14:36 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WFSoCFLtfMc/MB188BnaH/FikyttZcUc/P4pZD9lhnRw4qqJZGuozxL2tN08N2HrWcrPIFjjMCpZiAIyH1BVjp0scpZLlI6ceqsA87F35LX3QGK8LTws6Srs37B2zyntH8D7RK13g5SngTAXVrD60l0BLYHj7OpVV0h7/OQFzgI0xMQ5cRpEArGPowrPy66L107XjX7e0JWk6sBmY/f39kGKVNkJCIhUWuZh5Nz1jzmQDtZ//a4aLldVK7SUbI+05jUxIME9kc+Fz6qfXSTfPSyrOLytooATdgsam9UCy16M3DFVsZ0dXqEBXdy/C4pntPpmGPZ23VUdMmW06Q1IRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZpOPAFOQYwb3EhZHWrbwX3WD6n9UaCup1R7sH9XqU0M=;
 b=IZHlnvaB5/zX9USiiKqRxSbb3WLwSsuiRT07Q2GPfzcGz4qbTrbNpsbgtgU/Dre3l0TL+pzb6V19UJ8w7NTJ3WLNAjYd2tp/RMv7yx9roxwGp45F7/OeaJPZrqDfA7NTVGpDjvPJV2o4tRXFEX0eurTtk0n6KYJa0bmHROHBMGPnmMCLI+UmsU3iNxeEf4ztNPdY/Dl6fwuoXz1zM9N/hoyWNiYwhn2dV5XS8nJntS2bV5R2DK5bFgULJ6shQRqBPrFthPOs9p85wAvF6+8l65OxR+KBYTBsObnvxNPwyXNup387Cbq/SQEgWmW68CXBCKrne4LYX+6X79pNjabBqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZpOPAFOQYwb3EhZHWrbwX3WD6n9UaCup1R7sH9XqU0M=;
 b=owpeVvve4IldpmhWbtDFTInIqa5suLrS3uFB0sCwKNPcwrUc1264oY9M4gAigyx8fyFmysFX9J26wrwx5ycSEp+g5iSHLZ0NOQG2QIHRs+srn00+odQIiCAGI4Wychg0hzSoiZuKbJNRPRvYYb+TGQhRwZZkiTxKDYkhlA7Fg8U=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB3934.namprd11.prod.outlook.com (10.255.180.212) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.20; Wed, 15 Jan 2020 12:14:11 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2623.018; Wed, 15 Jan 2020
 12:14:11 +0000
Received: from pc-42.silabs.com (37.71.187.125) by PR2PR09CA0009.eurprd09.prod.outlook.com (2603:10a6:101:16::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.18 via Frontend Transport; Wed, 15 Jan 2020 12:13:35 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH 65/65] staging: wfx: update TODO
Thread-Topic: [PATCH 65/65] staging: wfx: update TODO
Thread-Index: AQHVy502FmB46xD2v0GFf69obNsAfA==
Date:   Wed, 15 Jan 2020 12:13:36 +0000
Message-ID: <20200115121041.10863-66-Jerome.Pouiller@silabs.com>
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
x-ms-office365-filtering-correlation-id: 8689424e-7255-460e-d789-08d799b458e1
x-ms-traffictypediagnostic: MN2PR11MB3934:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB3934CCF0119AD76A5F620E7B93370@MN2PR11MB3934.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 02830F0362
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39850400004)(396003)(136003)(376002)(366004)(346002)(199004)(189003)(54906003)(110136005)(86362001)(956004)(107886003)(2616005)(316002)(36756003)(71200400001)(52116002)(7696005)(478600001)(8936002)(966005)(81156014)(8676002)(4326008)(81166006)(6486002)(2906002)(26005)(66946007)(16526019)(186003)(5660300002)(66574012)(1076003)(66556008)(64756008)(66446008)(85182001)(66476007)(85202003);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB3934;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 93bljOmxw10NkibHUKqOrvbOJZYMxIfx1LbI1r2Iv7iF2yBNzWhXa8J1hk8aYb/5pd3tXNNNM6UlPP3e8aGrbLhHdywEp7eaz6+Wi/vLtDs+mNz0VZzJHHiORezY1Zqgj2PbPt/nlBLtJu4OSaXRD1dpgw7NjCtSEB/S4btuZ9S9mYglr4IvvJBOqDH9BfjPZKDekJDkMT0vFncFyW/KNNSZnYD99qCyTQDR1jqLu9mSQHqPrR/WHmtt6TLybsJjHHmGmCk8VIzTh/Xwmn6oc/k5RKGl92UEWG//+aj4+yCMNLggHu2KFx1X07uz+TOFldUpGKBzLoRIyuMlXhH+mTPUVOcmk7XclhnDysTkepE6SbbPNFBCmDMlFcBeotkApZ1ACjxaNyQ5krIPNKqdpM2J6VOWfaXJWacrqHi/d5zIcSjcmS5lPIwfUfOB0DZZve/HUQxOglWJRjAJ3xzRpXgS1/dPHNlxptQhFr3VO/nhXH6SVpLM8LAquon07VI/wafpirs5OMggM7ppPWYrqg==
Content-Type: text/plain; charset="utf-8"
Content-ID: <FDE3959A42BB5848A4EC638814775802@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8689424e-7255-460e-d789-08d799b458e1
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2020 12:13:36.3171
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DH5gObkuFIG82R0WAuxUG3zk0owDXz/I/ekHTpvfvrVB/+aV1Baod5c/D1Bkd9TyizKjS/EyFRImw2XeLRdmuw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3934
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
