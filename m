Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59F0813C3BF
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 14:54:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729501AbgAONyq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 08:54:46 -0500
Received: from mail-dm6nam11on2085.outbound.protection.outlook.com ([40.107.223.85]:14113
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729406AbgAONyn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jan 2020 08:54:43 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d+GoQ7egCPPeNcT73Nar3B0WdySKWEyqowTGENnavMVJ2GwEirQDbnmi3fkah0FxltJ0UhHPAA+FXY0EYlWDFCe/TVzmucm4q9F0Zh4jRmRGeI2pJ6fyFQENFY7V2BMA2gU3X3iw6pwUKvOsdaqlwhLRXb1MQnhEy0BgT3PCO5vQIKO+ETTOg+iQW6+rfky+aFTJHy3uebU00Ca78xHapluqHNK6/RFKrfBhdxtGGj1HmYc2Ybc+kSruWNHC9llxuj1gpTQvXL5Z/0BS7FY8v5VP1jG4Ah+8UUZN/x17mUO8RESGAKYXy4v9n4EwSa1FGU9LsPHYGbym5nk/v+KsJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0WFNk92WggXIov5lK4aFRHDtvXTnPFFcz9MaezpiQ+I=;
 b=hyl2rjje97p9qs56kB/d9J+wqwa27lZGZUBgoRpwrAcmj8DDUWY1T2wHbz3fCLSSlteDoCugKC0C6OHQDEX0et2lfXLBSE7M2PFrRli6Gt9xolny46oeO+jX+B+PNUp/8NJmuggVgv7I05GM2ZohC7qozQSyJOuHH1FfZc93runrgnti7mxqxBP95ZWHcHd/CqfmcdMnPKT8azQPhLzaH9dt/J3chByXI+KAT7DS6srcEgVro4VHJvwYVZLouqnHRH2qa58McEsA93tmYXjeuHjTa+BYkeJtw3DCUq1B/iXrnDwchRRkYc7wtXXEjUyR7zG0eVB3CFU1Cx7GbumRPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0WFNk92WggXIov5lK4aFRHDtvXTnPFFcz9MaezpiQ+I=;
 b=VprawZwGOs4gzF8FJ+AJBxhTkPp4SxBgoVFdwbGtHwN5trF5RGuSlQ3e79yuB2BsePvKngQWdzNJgullqAlD3f1XM345nsOyP5f8YaBrbKoHmcNjLB/lhymR+QThqz6vUgDssLC1W5KT9bCp7KAXjZCU89gZ2NseMejtaQxVw20=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB4094.namprd11.prod.outlook.com (10.255.180.202) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.19; Wed, 15 Jan 2020 13:54:27 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2623.018; Wed, 15 Jan 2020
 13:54:27 +0000
Received: from pc-42.home (2a01:e35:8bf5:66a0:3dbe:4cb5:6059:a948) by PR2P264CA0008.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.18 via Frontend Transport; Wed, 15 Jan 2020 13:54:26 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH v2 18/65] staging: wfx: simplify wfx_update_beaconing()
Thread-Topic: [PATCH v2 18/65] staging: wfx: simplify wfx_update_beaconing()
Thread-Index: AQHVy6tNp+meLQUoRU2/rB6Mv5Zugw==
Date:   Wed, 15 Jan 2020 13:54:27 +0000
Message-ID: <20200115135338.14374-19-Jerome.Pouiller@silabs.com>
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
x-ms-office365-filtering-correlation-id: d8740b46-daa8-4a15-4190-08d799c26fcb
x-ms-traffictypediagnostic: MN2PR11MB4094:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB409458297CE13ED0E07FB18293370@MN2PR11MB4094.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:883;
x-forefront-prvs: 02830F0362
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39850400004)(366004)(396003)(346002)(136003)(376002)(189003)(199004)(316002)(110136005)(54906003)(85202003)(81156014)(5660300002)(8676002)(71200400001)(8936002)(81166006)(186003)(6506007)(86362001)(66946007)(66446008)(66476007)(66556008)(2906002)(64756008)(478600001)(6512007)(52116002)(66574012)(6486002)(1076003)(16526019)(4326008)(85182001)(107886003)(36756003)(8886007)(2616005);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB4094;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FnPrZwl4zC9hfWYSZBrq3pG6XmyRiuv2OKcvst9HWW08XOUp+5ZQ/Y0v37vnlY4diixdjm0e75QJzjmjF5NT3+knOzcX+alIFmEY/ZYk8eX0xy4hnFb6b+j3Uv1bMbSqfdBfrN8pKDNmwqrnPnM2UgJX3pkQSJdnQtvtY1f1/HzGc0TLqIIgidIan7NteI1PeFM5Sea4MoL6GKq0s0FC5POUKiqffcnzMyiHQHzkVbyS8klVGkKP9NeXp2CxLAjVOalOLf08zSObbSK05stgygl3Qp9eaD2c3wclM+9A1sNbqYrtTtK9DIyfgQNSNrsIQhKJZlsx6wleRle3V5FQozwd2OuiMe26/SVs1SODj23WPbszSmPL5gJrYlds6kCzT6EZia9jHlJt+/Z7gOqxH9CKnjuSoyBALe2AKvvxepkvAgNJUGhevZPSn6v7AbF8
Content-Type: text/plain; charset="utf-8"
Content-ID: <4173EE1ED676AD4E8AE0778453EE7128@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d8740b46-daa8-4a15-4190-08d799c26fcb
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2020 13:54:27.6190
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SKcRYFgHpCdznZAnND6Cin6jn6yVAY/llygWR1LSEmgFUsx13ZQ6orL/RG6K9z3j3fz3upXz5Iqa6qPoMY1w0g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4094
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
