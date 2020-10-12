Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAEA328B29C
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 12:47:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387826AbgJLKrj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 06:47:39 -0400
Received: from mail-bn8nam11on2052.outbound.protection.outlook.com ([40.107.236.52]:61696
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387594AbgJLKrZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Oct 2020 06:47:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BRiz8a5COdsywSViBcSIyRuELqJGfaXJyWOKPIkgK2OP/tycz3b3oRUnV47T8FqnoSmQvR5k1x/OWSoknmhkSWPwwYU186J1O+kZRZsCb3ourPlGkHBsp/PicoohX8acaxVk2vKa8k/LfhSPTJ3XNcbRRD2t36Yg9oIoEwOovrOKjs7H6bHr+K2zY9T2nH94Orog9aJvuUGME1WFMAQFe+HHRbg/ExG80B/Tuyl2ebGrBgf7DCfZ9JtXdfwPZ0QQJQvP00t46HxxyyEPCZjSnJaVA6yDqhjbb9t90iQFg4OMaAoMdaKiZIgoG5k6IbsyywOLA+JIwQmrzGCpPEIGfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RqZzTE5IDNzLeiEeh0gtmEhR+vjHmPP5GDL6eBo8e3g=;
 b=d2ARdbMymwYz/zH519ug5MqD1tw7TOrveT3l3JXOvhWbOi3TuJG5vwzWUVeBjXpgAEnS0s4+aXoedPwRcAcGtIuCZ0xIUaDfmItzoCxKH5jPYsp3WluRvWbOhVzyIS3p3GoLwvmNF00U5AS+3sEZxh5iy2icIr5XBIoxAKHfol56I1EAtCDQLu2pOEDYtIux0spJ6P7epZzj8WKe1Wim+MZy4Q266Xl+93LvbzvoheBN18vWTF6XV9Xmcv5hzzTbaER0x/NGwh0VLdb/sgTQYcqajbeC0mSnfpQZ0nLwu8Csg+0q/eaMI5FCZGlzpdk3bvJI1eXA23aXnOZtcASvSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RqZzTE5IDNzLeiEeh0gtmEhR+vjHmPP5GDL6eBo8e3g=;
 b=LUT3PuVCf1A3dR2EtqjFvMi2QqO+H4jDdVXYFMtxi46RysmtoQbP1VD8anEKB/sB3YDH3R5RX1CwMYWWUoGiBXLX+TC7BoSiGKbXOJrWzx4Km+iXqZaCfFlwtT7NO9oDmPX7zvbnr3iiF3ZmU38M115FQaokVebhmYV5d6GaRGg=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SA0PR11MB4734.namprd11.prod.outlook.com (2603:10b6:806:99::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.23; Mon, 12 Oct
 2020 10:47:11 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::4f5:fbe5:44a7:cb8a]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::4f5:fbe5:44a7:cb8a%5]) with mapi id 15.20.3455.029; Mon, 12 Oct 2020
 10:47:11 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 03/23] wfx: add wfx.h
Date:   Mon, 12 Oct 2020 12:46:28 +0200
Message-Id: <20201012104648.985256-4-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012104648.985256-1-Jerome.Pouiller@silabs.com>
References: <20201012104648.985256-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-Originating-IP: [82.67.86.106]
X-ClientProxiedBy: PR3P189CA0005.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:102:52::10) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.home (82.67.86.106) by PR3P189CA0005.EURP189.PROD.OUTLOOK.COM (2603:10a6:102:52::10) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.21 via Frontend Transport; Mon, 12 Oct 2020 10:47:10 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9d36537c-6f12-483e-b6f9-08d86e9c2c9c
X-MS-TrafficTypeDiagnostic: SA0PR11MB4734:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR11MB4734EC01E6BFE8CE8611CF0793070@SA0PR11MB4734.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:773;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: U/L7BHOnLKTzogHYuy8UlA9iF1ujYEei3d60AKfyFiWjOVAEXyZYbknXBt5MrymU1MHPjK0IedicZUCgwaFhMbQps7uCTAOSJxLLSGxIPoq5yx+rBC5pAvGBPW8+DGIMq7++Stn743dkQfG9M67SIPWBJvAjZh3u+2SQQv9qRAaU5I1AXtKkcJ+9JKZzdBiTDrk7bkmnJ29e4l/uxYa+jy0Z7ygGUgAH3fJL+Hr9iv9eWpD1SCbWotJzBFavT5+xjgIzR1unTKmtnshWFlFMMBF4wxIfKmBjxOFZ6/O3xZHKxuFKJzdZ8Q/vyYVn1c9ouVTO6WwBmyz1Nljrc84FaA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(39850400004)(396003)(366004)(136003)(346002)(376002)(66556008)(66476007)(6512007)(26005)(36756003)(66946007)(16526019)(186003)(316002)(4326008)(2616005)(956004)(1076003)(5660300002)(107886003)(6486002)(54906003)(86362001)(8676002)(83380400001)(8936002)(66574015)(52116002)(2906002)(6506007)(8886007)(6666004)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: bQrgpirEcfBwfR59B1QLgqiTwveAfBuo/Qwb4b7QrIYCXIIxMapbQ1FE7WCYaJt9l5gp8PtWQM1NsNWbObpl5TBssCHeWaRqayOJu3qQGWubMraNMEqBx4EX+rM26SRu37yi3RUoASaXGvperBmMusVXHF4h1RA0fWvHhKioxdclfFe0XY6iIXJ+LmQOd7PgbKCeNWA1vVywfoMbeq3VBMvN9rcDB1W/pRTYqPOcXDlY/Hga/+wPMf+iXZXC3/ZYjB3wUsBawpQi6Ydg2d98Ye4du4y/6zGrqerbuczYcIK4YPljkWM0TmF90TugrmW0XLXnx0Ak1L9GyJS87qmDhiA1NEv4dzn6RkegB8iXKPITHxa6Thlg4eGC1LCqY6QA5+7dZzYVVDzMD21Stsp7N+glpWDBV+3Y0jUdHtqN6swJIAcBZTbUuy0Z8f3TVfCag4O/Jiqk1lLDnO/AjjYYXPpmSrhLbmx9fZvVspWjip+3h1nafJEzKzg5B0RZcov2LK/rsN5QNvbNlUXWWV13EgljY9N0kPw1srClevn5moglzt3nTZmvII0c7XaX7AOJfDBP2A2VuNaQyT/hx9+TOmbtgdjpgHd4U5Pkm4Q/4UmEKZdDrl5aIZu7+W0L/JeiokubT4u1+aYxzDxONv+Dbw==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d36537c-6f12-483e-b6f9-08d86e9c2c9c
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Oct 2020 10:47:11.6825
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WxQXTiU9vHbsG40/wFYyB9kdRx5mv8T+dbP1j6yh+udfSdVqZGFkMk+6nnef15uTAqLLdhWc/A/ZdeB6ghAWBQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4734
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKU2ln
bmVkLW9mZi1ieTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29t
PgotLS0KIGRyaXZlcnMvbmV0L3dpcmVsZXNzL3NpbGFicy93Zngvd2Z4LmggfCAxNjYgKysrKysr
KysrKysrKysrKysrKysrKysrKysKIDEgZmlsZSBjaGFuZ2VkLCAxNjYgaW5zZXJ0aW9ucygrKQog
Y3JlYXRlIG1vZGUgMTAwNjQ0IGRyaXZlcnMvbmV0L3dpcmVsZXNzL3NpbGFicy93Zngvd2Z4LmgK
CmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC93aXJlbGVzcy9zaWxhYnMvd2Z4L3dmeC5oIGIvZHJp
dmVycy9uZXQvd2lyZWxlc3Mvc2lsYWJzL3dmeC93ZnguaApuZXcgZmlsZSBtb2RlIDEwMDY0NApp
bmRleCAwMDAwMDAwMDAwMDAuLjk0ODk4NjgwY2NkZQotLS0gL2Rldi9udWxsCisrKyBiL2RyaXZl
cnMvbmV0L3dpcmVsZXNzL3NpbGFicy93Zngvd2Z4LmgKQEAgLTAsMCArMSwxNjYgQEAKKy8qIFNQ
RFgtTGljZW5zZS1JZGVudGlmaWVyOiBHUEwtMi4wLW9ubHkgKi8KKy8qCisgKiBDb21tb24gcHJp
dmF0ZSBkYXRhIGZvciBTaWxpY29uIExhYnMgV0Z4IGNoaXBzLgorICoKKyAqIENvcHlyaWdodCAo
YykgMjAxNy0yMDIwLCBTaWxpY29uIExhYm9yYXRvcmllcywgSW5jLgorICogQ29weXJpZ2h0IChj
KSAyMDEwLCBTVC1Fcmljc3NvbgorICogQ29weXJpZ2h0IChjKSAyMDA2LCBNaWNoYWVsIFd1IDxm
bGFtaW5naWNlQHNvdXJtaWxrLm5ldD4KKyAqIENvcHlyaWdodCAyMDA0LTIwMDYgSmVhbi1CYXB0
aXN0ZSBOb3RlIDxqYm5vdGVAZ21haWwuY29tPiwgZXQgYWwuCisgKi8KKyNpZm5kZWYgV0ZYX0gK
KyNkZWZpbmUgV0ZYX0gKKworI2luY2x1ZGUgPGxpbnV4L2NvbXBsZXRpb24uaD4KKyNpbmNsdWRl
IDxsaW51eC93b3JrcXVldWUuaD4KKyNpbmNsdWRlIDxsaW51eC9tdXRleC5oPgorI2luY2x1ZGUg
PGxpbnV4L25vc3BlYy5oPgorI2luY2x1ZGUgPG5ldC9tYWM4MDIxMS5oPgorCisjaW5jbHVkZSAi
YmguaCIKKyNpbmNsdWRlICJkYXRhX3R4LmgiCisjaW5jbHVkZSAibWFpbi5oIgorI2luY2x1ZGUg
InF1ZXVlLmgiCisjaW5jbHVkZSAiaGlmX3R4LmgiCisKKyNkZWZpbmUgVVNFQ19QRVJfVFhPUCAz
MiAvLyBzZWUgc3RydWN0IGllZWU4MDIxMV90eF9xdWV1ZV9wYXJhbXMKKyNkZWZpbmUgVVNFQ19Q
RVJfVFUgMTAyNAorCitzdHJ1Y3QgaHdidXNfb3BzOworCitzdHJ1Y3Qgd2Z4X2RldiB7CisJc3Ry
dWN0IHdmeF9wbGF0Zm9ybV9kYXRhIHBkYXRhOworCXN0cnVjdCBkZXZpY2UJCSpkZXY7CisJc3Ry
dWN0IGllZWU4MDIxMV9odwkqaHc7CisJc3RydWN0IGllZWU4MDIxMV92aWYJKnZpZlsyXTsKKwlz
dHJ1Y3QgbWFjX2FkZHJlc3MJYWRkcmVzc2VzWzJdOworCWNvbnN0IHN0cnVjdCBod2J1c19vcHMJ
Kmh3YnVzX29wczsKKwl2b2lkCQkJKmh3YnVzX3ByaXY7CisKKwl1OAkJCWtleXNldDsKKwlzdHJ1
Y3QgY29tcGxldGlvbglmaXJtd2FyZV9yZWFkeTsKKwlzdHJ1Y3QgaGlmX2luZF9zdGFydHVwCWh3
X2NhcHM7CisJc3RydWN0IHdmeF9oaWYJCWhpZjsKKwlzdHJ1Y3QgZGVsYXllZF93b3JrCWNvb2xp
bmdfdGltZW91dF93b3JrOworCWJvb2wJCQlwb2xsX2lycTsKKwlib29sCQkJY2hpcF9mcm96ZW47
CisJc3RydWN0IG11dGV4CQljb25mX211dGV4OworCisJc3RydWN0IHdmeF9oaWZfY21kCWhpZl9j
bWQ7CisJc3RydWN0IHNrX2J1ZmZfaGVhZAl0eF9wZW5kaW5nOworCXdhaXRfcXVldWVfaGVhZF90
CXR4X2RlcXVldWU7CisJYXRvbWljX3QJCXR4X2xvY2s7CisKKwlhdG9taWNfdAkJcGFja2V0X2lk
OworCXUzMgkJCWtleV9tYXA7CisKKwlzdHJ1Y3QgaGlmX3J4X3N0YXRzCXJ4X3N0YXRzOworCXN0
cnVjdCBtdXRleAkJcnhfc3RhdHNfbG9jazsKKwlzdHJ1Y3QgaGlmX3R4X3Bvd2VyX2xvb3BfaW5m
byB0eF9wb3dlcl9sb29wX2luZm87CisJc3RydWN0IG11dGV4CQl0eF9wb3dlcl9sb29wX2luZm9f
bG9jazsKKwlpbnQJCQlmb3JjZV9wc190aW1lb3V0OworfTsKKworc3RydWN0IHdmeF92aWYgewor
CXN0cnVjdCB3ZnhfZGV2CQkqd2RldjsKKwlzdHJ1Y3QgaWVlZTgwMjExX3ZpZgkqdmlmOworCXN0
cnVjdCBpZWVlODAyMTFfY2hhbm5lbCAqY2hhbm5lbDsKKwlpbnQJCQlpZDsKKworCXUzMgkJCWxp
bmtfaWRfbWFwOworCisJYm9vbAkJCWFmdGVyX2R0aW1fdHhfYWxsb3dlZDsKKwlib29sCQkJam9p
bl9pbl9wcm9ncmVzczsKKworCXN0cnVjdCBkZWxheWVkX3dvcmsJYmVhY29uX2xvc3Nfd29yazsK
KworCXN0cnVjdCB3ZnhfcXVldWUJdHhfcXVldWVbNF07CisJc3RydWN0IHR4X3BvbGljeV9jYWNo
ZQl0eF9wb2xpY3lfY2FjaGU7CisJc3RydWN0IHdvcmtfc3RydWN0CXR4X3BvbGljeV91cGxvYWRf
d29yazsKKworCXN0cnVjdCB3b3JrX3N0cnVjdAl1cGRhdGVfdGltX3dvcms7CisKKwl1bnNpZ25l
ZCBsb25nCQl1YXBzZF9tYXNrOworCisJLyogYXZvaWQgc29tZSBvcGVyYXRpb25zIGluIHBhcmFs
bGVsIHdpdGggc2NhbiAqLworCXN0cnVjdCBtdXRleAkJc2Nhbl9sb2NrOworCXN0cnVjdCB3b3Jr
X3N0cnVjdAlzY2FuX3dvcms7CisJc3RydWN0IGNvbXBsZXRpb24Jc2Nhbl9jb21wbGV0ZTsKKwli
b29sCQkJc2Nhbl9hYm9ydDsKKwlzdHJ1Y3QgaWVlZTgwMjExX3NjYW5fcmVxdWVzdCAqc2Nhbl9y
ZXE7CisKKwlzdHJ1Y3QgY29tcGxldGlvbglzZXRfcG1fbW9kZV9jb21wbGV0ZTsKK307CisKK3N0
YXRpYyBpbmxpbmUgc3RydWN0IHdmeF92aWYgKndkZXZfdG9fd3ZpZihzdHJ1Y3Qgd2Z4X2RldiAq
d2RldiwgaW50IHZpZl9pZCkKK3sKKwlpZiAodmlmX2lkID49IEFSUkFZX1NJWkUod2Rldi0+dmlm
KSkgeworCQlkZXZfZGJnKHdkZXYtPmRldiwgInJlcXVlc3Rpbmcgbm9uLWV4aXN0ZW50IHZpZjog
JWRcbiIsIHZpZl9pZCk7CisJCXJldHVybiBOVUxMOworCX0KKwl2aWZfaWQgPSBhcnJheV9pbmRl
eF9ub3NwZWModmlmX2lkLCBBUlJBWV9TSVpFKHdkZXYtPnZpZikpOworCWlmICghd2Rldi0+dmlm
W3ZpZl9pZF0pIHsKKwkJZGV2X2RiZyh3ZGV2LT5kZXYsICJyZXF1ZXN0aW5nIG5vbi1hbGxvY2F0
ZWQgdmlmOiAlZFxuIiwKKwkJCXZpZl9pZCk7CisJCXJldHVybiBOVUxMOworCX0KKwlyZXR1cm4g
KHN0cnVjdCB3ZnhfdmlmICopIHdkZXYtPnZpZlt2aWZfaWRdLT5kcnZfcHJpdjsKK30KKworc3Rh
dGljIGlubGluZSBzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZl9pdGVyYXRlKHN0cnVjdCB3ZnhfZGV2ICp3
ZGV2LAorCQkJCQkgICBzdHJ1Y3Qgd2Z4X3ZpZiAqY3VyKQoreworCWludCBpOworCWludCBtYXJr
ID0gMDsKKwlzdHJ1Y3Qgd2Z4X3ZpZiAqdG1wOworCisJaWYgKCFjdXIpCisJCW1hcmsgPSAxOwor
CWZvciAoaSA9IDA7IGkgPCBBUlJBWV9TSVpFKHdkZXYtPnZpZik7IGkrKykgeworCQl0bXAgPSB3
ZGV2X3RvX3d2aWYod2RldiwgaSk7CisJCWlmIChtYXJrICYmIHRtcCkKKwkJCXJldHVybiB0bXA7
CisJCWlmICh0bXAgPT0gY3VyKQorCQkJbWFyayA9IDE7CisJfQorCXJldHVybiBOVUxMOworfQor
CitzdGF0aWMgaW5saW5lIGludCB3dmlmX2NvdW50KHN0cnVjdCB3ZnhfZGV2ICp3ZGV2KQorewor
CWludCBpOworCWludCByZXQgPSAwOworCXN0cnVjdCB3ZnhfdmlmICp3dmlmOworCisJZm9yIChp
ID0gMDsgaSA8IEFSUkFZX1NJWkUod2Rldi0+dmlmKTsgaSsrKSB7CisJCXd2aWYgPSB3ZGV2X3Rv
X3d2aWYod2RldiwgaSk7CisJCWlmICh3dmlmKQorCQkJcmV0Kys7CisJfQorCXJldHVybiByZXQ7
Cit9CisKK3N0YXRpYyBpbmxpbmUgdm9pZCBtZW1yZXZlcnNlKHU4ICpzcmMsIHU4IGxlbmd0aCkK
K3sKKwl1OCAqbG8gPSBzcmM7CisJdTggKmhpID0gc3JjICsgbGVuZ3RoIC0gMTsKKwl1OCBzd2Fw
OworCisJd2hpbGUgKGxvIDwgaGkpIHsKKwkJc3dhcCA9ICpsbzsKKwkJKmxvKysgPSAqaGk7CisJ
CSpoaS0tID0gc3dhcDsKKwl9Cit9CisKK3N0YXRpYyBpbmxpbmUgaW50IG1lbXpjbXAodm9pZCAq
c3JjLCB1bnNpZ25lZCBpbnQgc2l6ZSkKK3sKKwl1OCAqYnVmID0gc3JjOworCisJaWYgKCFzaXpl
KQorCQlyZXR1cm4gMDsKKwlpZiAoKmJ1ZikKKwkJcmV0dXJuIDE7CisJcmV0dXJuIG1lbWNtcChi
dWYsIGJ1ZiArIDEsIHNpemUgLSAxKTsKK30KKworI2VuZGlmIC8qIFdGWF9IICovCi0tIAoyLjI4
LjAKCg==
