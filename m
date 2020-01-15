Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6F1F13C064
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 13:18:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732459AbgAOMSQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 07:18:16 -0500
Received: from mail-co1nam11on2084.outbound.protection.outlook.com ([40.107.220.84]:24056
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730743AbgAOMMp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jan 2020 07:12:45 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lWGAI9TFlapsI6BCaR0jtwJJkLtk0Zg8ow3EufufFLe9CczusR7AkvTwyxFhWlKSAcHxAOLod5Oc/J+7XWTkqRghwcCAfOUKvgL1jROAgdj93D1THv3b2OTIkJw76raA4wLWliK4NrNd9uSnzMfxcAYZJCSuAzt+4CarWD5gV14zQ9n+937hdqx3WAbGovYDWlkfkMiLaF3bZen8ib5XNEt8shfZu+bZcvKROJxXLe9hnm3ZLZ6td1yLsvOhIPq4Kv263C/hl1uYHUrTlDxCMA2zLj4DweE412eXsQBDlR28BELSBAz3m/JbsmF6n9RpzVCcvoGwktt1OQrIncfUpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0WFNk92WggXIov5lK4aFRHDtvXTnPFFcz9MaezpiQ+I=;
 b=lezj/AAEk2gBxEcnggDmPQ4sfhqS+r4ChZUDZQpXo3xAcyrZIz0J/cSRwHValUyr6nfLYj+JIAcpHhYHnkG0SvUqFJxBQHCTrt4kG7VlAnt2edeFKXC9wK5Lk08R777P4F1sBQwpYwg5YCRyzJeiqbf6X0I9U/5KhaJxvwLQF1gDwXUhN26f2t6BcpuESX7jUVPfmu643wOVYtW00NekuwQ8dLm2FCKKQAwBu7RYeoz1aibiFWjpoS/aP8DpHYQJMWfXbav7OF73jaHbF1qjR+CWt5int4x+Nnfi11LGEkBwD4W/Cf6vbsoy+bD23oFLzlT5Iq5mR6RTUnpEIuLyeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0WFNk92WggXIov5lK4aFRHDtvXTnPFFcz9MaezpiQ+I=;
 b=LHrbR3Q+f6F6BpP1Tl9O+QQr4uv2CERahdWitv2Z0EZ3OfVm9p1oVRq5wgpg/SVwoR2fX+C6FdyqT5pzFnZoxwctHfINR5b+PSCjeGwlpShcO5KBKQ7WR9TY9QZc8FBCBVhvV2Dpot44QL06SfflKmObXZxIUSZ8RLYVTsUVy8s=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB3934.namprd11.prod.outlook.com (10.255.180.212) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.20; Wed, 15 Jan 2020 12:12:33 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2623.018; Wed, 15 Jan 2020
 12:12:33 +0000
Received: from pc-42.silabs.com (37.71.187.125) by PR2PR09CA0009.eurprd09.prod.outlook.com (2603:10a6:101:16::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.18 via Frontend Transport; Wed, 15 Jan 2020 12:12:32 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH 18/65] staging: wfx: simplify wfx_update_beaconing()
Thread-Topic: [PATCH 18/65] staging: wfx: simplify wfx_update_beaconing()
Thread-Index: AQHVy50RM8ificUHMEK/z+6ShGWyAg==
Date:   Wed, 15 Jan 2020 12:12:33 +0000
Message-ID: <20200115121041.10863-19-Jerome.Pouiller@silabs.com>
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
x-ms-office365-filtering-correlation-id: e1413e43-5ac5-418c-0e4d-08d799b43366
x-ms-traffictypediagnostic: MN2PR11MB3934:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB3934C5B999ECD520E35D416593370@MN2PR11MB3934.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:883;
x-forefront-prvs: 02830F0362
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39850400004)(396003)(136003)(376002)(366004)(346002)(199004)(189003)(54906003)(110136005)(86362001)(956004)(107886003)(2616005)(316002)(36756003)(71200400001)(52116002)(7696005)(478600001)(8936002)(81156014)(8676002)(4326008)(81166006)(6486002)(2906002)(26005)(66946007)(16526019)(186003)(5660300002)(66574012)(1076003)(66556008)(64756008)(66446008)(85182001)(66476007)(85202003);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB3934;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: iTMbUIbHOzA2KIScMMSRuSWzJ8i3bQ4iLDvJYtDCRwz+gVhkIOHZmHLnYgekN4QBb+xwDB7m0OoG9sfsaiRRvVm+KRdVtuMXz/ID4sH5LEkL59pJEvgPZlA4YUElcLnHTT1tJzqWaHI1LJfsT/sukxb/967p0Eylnz5BWNP2eplLa66QOQbAOnbdqVvD0aDaJdWvbVNe3UnKsFW2zF2vZGoxyc+qvmxadVbwSk9NYumUV6ErWUrjxdWqHfwB/bfos9pqO5C4vuLwASpOon9AiKE5GfPLJzPddGaCiR57wfF/XsFg++BEoMfLu76ITvw03VxKUmZlNFpcTftk+RBP1iVz26Lru64PSIvHCatCZFDB2rf2xQbCvRAtkoUsRLukeGhT8CSrkGku1Pl6KgUKbfuxKeXdCtb7y2MQThiz1dagEoSS702EjP6WVBRGlrTj
Content-Type: text/plain; charset="utf-8"
Content-ID: <7607017DFEEC264DBA3A71FAA95E0406@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e1413e43-5ac5-418c-0e4d-08d799b43366
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2020 12:12:33.3462
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 40S3PGBSkj5+Sa5YGP9cz+XUCitgIlaVMZl3HHAJ3jNwoisQUlKIkUyhQ8Lo6AMML+rbJLf/5qlOJuxdDq6x5g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3934
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKUmVt
b3ZlIG1vc3Qgb2YgaW5kZW50YXRpb24gb2Ygd2Z4X3VwZGF0ZV9iZWFjb25pbmcoKSBieSByZXdv
cmtpbmcgdGhlCmVycm9yIGhhbmRsaW5nLgoKU2lnbmVkLW9mZi1ieTogSsOpcsO0bWUgUG91aWxs
ZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgotLS0KIGRyaXZlcnMvc3RhZ2luZy93Zngv
c3RhLmMgfCAyOCArKysrKysrKysrKy0tLS0tLS0tLS0tLS0tLS0tCiAxIGZpbGUgY2hhbmdlZCwg
MTEgaW5zZXJ0aW9ucygrKSwgMTcgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9z
dGFnaW5nL3dmeC9zdGEuYyBiL2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMKaW5kZXggMTE4MTIw
MzQ4OWYwLi4wYzczNjkxYWI3MzYgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93Zngvc3Rh
LmMKKysrIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYwpAQCAtNzYwLDIzICs3NjAsMTcgQEAg
c3RhdGljIGludCB3Znhfc3RhcnRfYXAoc3RydWN0IHdmeF92aWYgKnd2aWYpCiAKIHN0YXRpYyBp
bnQgd2Z4X3VwZGF0ZV9iZWFjb25pbmcoc3RydWN0IHdmeF92aWYgKnd2aWYpCiB7Ci0Jc3RydWN0
IGllZWU4MDIxMV9ic3NfY29uZiAqY29uZiA9ICZ3dmlmLT52aWYtPmJzc19jb25mOwotCi0JaWYg
KHd2aWYtPnZpZi0+dHlwZSA9PSBOTDgwMjExX0lGVFlQRV9BUCkgewotCQkvKiBUT0RPOiBjaGVj
ayBpZiBjaGFuZ2VkIGNoYW5uZWwsIGJhbmQgKi8KLQkJaWYgKHd2aWYtPnN0YXRlICE9IFdGWF9T
VEFURV9BUCB8fAotCQkgICAgd3ZpZi0+YmVhY29uX2ludCAhPSBjb25mLT5iZWFjb25faW50KSB7
Ci0JCQl3ZnhfdHhfbG9ja19mbHVzaCh3dmlmLT53ZGV2KTsKLQkJCWlmICh3dmlmLT5zdGF0ZSAh
PSBXRlhfU1RBVEVfUEFTU0lWRSkgewotCQkJCWhpZl9yZXNldCh3dmlmLCBmYWxzZSk7Ci0JCQkJ
d2Z4X3R4X3BvbGljeV9pbml0KHd2aWYpOwotCQkJfQotCQkJd3ZpZi0+c3RhdGUgPSBXRlhfU1RB
VEVfUEFTU0lWRTsKLQkJCXdmeF9zdGFydF9hcCh3dmlmKTsKLQkJCXdmeF90eF91bmxvY2sod3Zp
Zi0+d2Rldik7Ci0JCX0gZWxzZSB7Ci0JCX0KLQl9CisJaWYgKHd2aWYtPnZpZi0+dHlwZSAhPSBO
TDgwMjExX0lGVFlQRV9BUCkKKwkJcmV0dXJuIDA7CisJaWYgKHd2aWYtPnN0YXRlID09IFdGWF9T
VEFURV9BUCAmJgorCSAgICB3dmlmLT5iZWFjb25faW50ID09IHd2aWYtPnZpZi0+YnNzX2NvbmYu
YmVhY29uX2ludCkKKwkJcmV0dXJuIDA7CisJd2Z4X3R4X2xvY2tfZmx1c2god3ZpZi0+d2Rldik7
CisJaGlmX3Jlc2V0KHd2aWYsIGZhbHNlKTsKKwl3ZnhfdHhfcG9saWN5X2luaXQod3ZpZik7CisJ
d3ZpZi0+c3RhdGUgPSBXRlhfU1RBVEVfUEFTU0lWRTsKKwl3Znhfc3RhcnRfYXAod3ZpZik7CisJ
d2Z4X3R4X3VubG9jayh3dmlmLT53ZGV2KTsKIAlyZXR1cm4gMDsKIH0KIAotLSAKMi4yNS4wCgo=
