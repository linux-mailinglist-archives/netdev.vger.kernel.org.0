Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E02BE285CC8
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 12:20:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728116AbgJGKUj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 06:20:39 -0400
Received: from mail-bn8nam12on2066.outbound.protection.outlook.com ([40.107.237.66]:19424
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727527AbgJGKUU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Oct 2020 06:20:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fFP2rKdAfIwLyYCsScja1LCh4QiQGDFRw5H+ijKaD2LS890MfsJw8y5lbvpLIQCJ9/lwDDG/5G3qTChhSxS2AJwTCV8hByMTF5cRJCOCRrZtPZN9V/SzfUrmGLl8oAu0OB2aToOR88b2sB4cgb8OnijOUUXZaLq6LVMGcf5P8sgTjctjvXRhbt8haHtomR9w/GJdSLAt2HpwAmAZeTJkS9j2h2iYWuyKBuuFRgL7VDvFdOA1BgEIXHQ4PteJFJpkBbGwdTEC9Tuwq1pmep1vqaUUNpBNj3LiXRdSVvlvceC7o1xEfjYeBKtgwHO7VcM/GGGF8S2QnT7AGhxwiRXsAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6o3ILcCIWqLfEBgzOO4npMJ9j0rWoU4kQ/wh+Dukeok=;
 b=h9hf5++hGML8GOIXEY6L2g4hLkI7U+JvYXKm2z4GOToT5asJjwCTaCxXNh/zdEuLKf15PbgDwowP8IxCdk5Y6g7MigNAVa2P4gqtiSRuLEL3Pjiqk8CMCS1fKNbF3H1HOFcBar5zvomrIDsKBLbwP1mWddagu6aqMSZRGc6VakCYIu0+QCfQgjAacHpi2dXusRvWTNCZO3nwSr88qm5oCbSKATRAMK/p/VPSKT6oT7OIe4VmdGjaVBGTfv9Et6pqIXis2z5m3OTHdkWPKewGPwnRzonhuzwVJdW1ASVwH7S8Rpsp2kvb7Syu3ex18Qt60lAAEj9KnHcbuqOSBGNtRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6o3ILcCIWqLfEBgzOO4npMJ9j0rWoU4kQ/wh+Dukeok=;
 b=cTQXabH+//47H9mcLmImUUzcQ2MHinxItUAyZFOb8Zw4k8mhWTFnzwoTQxeyb5Q0BkJ1IjN9v7+KhDHqDHM/tq2y7yzWOABUQy1UhzbZVaiAjrNSp7owpSgtlNgLJZ2a22WWSvW6acpO1U5ZTuHKBF6Xtw4zOkcL4xboqLMkX40=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SA0PR11MB4670.namprd11.prod.outlook.com (2603:10b6:806:9a::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.23; Wed, 7 Oct
 2020 10:20:10 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::4f5:fbe5:44a7:cb8a]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::4f5:fbe5:44a7:cb8a%5]) with mapi id 15.20.3433.044; Wed, 7 Oct 2020
 10:20:10 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 4/7] staging: wfx: fix QoS priority for slow buses
Date:   Wed,  7 Oct 2020 12:19:40 +0200
Message-Id: <20201007101943.749898-5-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201007101943.749898-1-Jerome.Pouiller@silabs.com>
References: <20201007101943.749898-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-Originating-IP: [82.67.86.106]
X-ClientProxiedBy: PR0P264CA0111.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:19::27) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.home (82.67.86.106) by PR0P264CA0111.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:19::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.23 via Frontend Transport; Wed, 7 Oct 2020 10:20:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 541e8a23-ee36-4005-7ac6-08d86aaa920b
X-MS-TrafficTypeDiagnostic: SA0PR11MB4670:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR11MB4670097116FF6E40CE3C8E10930A0@SA0PR11MB4670.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IfN3WIrzhrVztlpYB4BYy59gQaGBEsbEM/Obn6K3NH4CKqFbPqKgW3ooUCI90PO8PPjdGPqnwDW+iMMAs0MShQ/RmD8KVoaaUJz0RBScffiLMF6ukQT3B/Xd8rvjkHjIgbdlzz1qIMj5Eb3E7qZAEDVQ8LLp6H1BVKkIokkqAx0I0ZJU0TeDTJQAUo6nONE1a9p9vPqxSSOa2iAFa7Rh7zvhkjl3JI3qchkfvK6U/7rQkHz2ZBQvHRfy/pJGWEPep3KnUR+pjXb7wYI+Ree0wYlEOA1StYlDa7ZBikhJw3rhkAdjbzNoE3EWc2JvFaa/
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(39850400004)(346002)(136003)(376002)(366004)(396003)(66556008)(66476007)(6486002)(66946007)(316002)(54906003)(4326008)(478600001)(2906002)(1076003)(5660300002)(186003)(8936002)(8676002)(16526019)(52116002)(83380400001)(26005)(6506007)(66574015)(2616005)(86362001)(956004)(107886003)(8886007)(36756003)(6666004)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: VHGdQmD4bqjOXMlqXomi/u8plX5pn+ranfggQLYCNhk8mHyi7MT8B873vZA7q3+PLOAdK5e+Ru/e7BUxxzTJrvdwWNB0eYVjP8gDu/PCjxN6C+Hh26I1ZBKgTb9YmgJTZVHAC0VyFuLdVZZIGCKEinaHlNpZZrAxdwtxADG1oug2VysigSb0G9ps0iodEUAAnMMwyxLcSoILaAtWq4SWss9jTBo3gDghtElSW4qWAyL1uIcjvh/Exe3Hx5atDHn4PdPIyb/D9wHR6oUg7k7b/7LIwBXGhDnPaqUpJRjaVgabBZnNbIjSXexFUtLV9Vqt+nCe+KhLdQUECNBXHXqEDsgJTmgOrDiTOM3G+8hglVYg5pa8n5FhOHEkaI3qFb2kO2UlkJJzH9RXCoYjkfm9tDLLQhS+oHF+P5QGBcYU4Tmo5LelyVquyrJwYUV2bATyXtfPNCePiZpoPRF7K0g38gBRQnqMpH0dh+o8F3lCoNnGRjg3b4YpRcOBg9Rnq6SJdaLFeu+vPlw8DGPEskHyNjLWFb+OAYhujCKzuMVQRmMZovjenHMFE7BSWTOcA7q/yKMX1s6e+1d0De+fslk2rtZi3GBzPigS88KrzLwPMc2/118UVsjc1QZ0C3n0yUy/pE6B6HqemBa6JdOdG0GTuw==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 541e8a23-ee36-4005-7ac6-08d86aaa920b
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Oct 2020 10:20:10.2394
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9LM2wDyWEsqmGBt00V7eRrOvn01XevOISUGRd7m0tXd1D/7N8P89G8hT+QP4JDM2PFcT3p+Q9cg4i7u55X6/bQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4670
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVGhl
IGRldmljZSBpcyBpbiBjaGFyZ2Ugb2YgcmVzcGVjdGluZyB0aGUgUW9TIGNvbnN0cmFpbnRzLiBU
aGUgZHJpdmVyCmhhdmUgdG8gZW5zdXJlIHRoYXQgYWxsIHRoZSBxdWV1ZXMgY29udGFpbiBkYXRh
IGFuZCB0aGUgZGV2aWNlIGNob29zZQp0aGUgcmlnaHQgcXVldWUgdG8gc2VuZC4KClRoZSB0aGlu
Z3Mgc3RhcnRzIHRvIGJlIG1vcmUgZGlmZmljdWx0IHdoZW4gdGhlIGJhbmR3aWR0aCBvZiB0aGUg
YnVzIGlzCmxvd2VyIHRoYW4gdGhlIGJhbmR3aWR0aCBvZiB0aGUgV2lGaS4gVGhlIGRldmljZSBx
dWlja2x5IHNlbmRzIHRoZQpmcmFtZXMgb2YgdGhlIGhpZ2hlc3QgcHJpb3JpdHkgcXVldWUuIFRo
ZW4sIGl0IHN0YXJ0cyB0byBzZW5kIGZyYW1lcwpmcm9tIGEgbG93ZXIgcHJpb3JpdHkgcXVldWUu
IFRob3VnaCwgdGhlcmUgYXJlIHN0aWxsIHNvbWUgaGlnaCBwcmlvcml0eQpmcmFtZXMgd2FpdGlu
ZyBpbiB0aGUgZHJpdmVyLgoKVG8gd29yayBhcm91bmQgdGhpcyBwcm9ibGVtLCB0aGlzIHBhdGNo
IGFkZCBzb21lIHByaW9yaXRpZXMgdG8gZWFjaApxdWV1ZS4gVGhlIHdlaWdoIG9mIHRoZSBxdWV1
ZSB3YXMgKHJvdWdobHkpIGNhbGN1bGF0ZWQgZXhwZXJpbWVudGFsbHkgYnkKY2hlY2tpbmcgdGhl
IHNwZWVkIHJhdGlvIG9mIGVhY2ggcXVldWUgd2hlbiB0aGUgYnVzIGRvZXMgbm90IGxpbWl0IHRo
ZQp0cmFmZmljOgogICAgLSBCZS9CayAtPiAyME1icHMvMTBNYnBzCiAgICAtIFZpL0JlIC0+IDM2
TWJwcy8xODBLYnBzCiAgICAtIFZvL0JlIC0+IDM1TWJwcy82MDBLYnBzCiAgICAtIFZpL1ZvIC0+
IDI0TWJwcy8xMk1icHMKClNvLCBpZiB3ZSBmaXggdGhlIHdlaWdoIG9mIHRoZSBCYWNrZ3JvdW5k
IHRvIDEsIHRoZSB3ZWlnaHQgb2YgQmVzdApFZmZvcnQgc2hvdWxkIGJlIDIuIFRoZSB3ZWlnaHQg
b2YgVmlkZW8gc2hvdWxkIGJlIDExNi4gSG93ZXZlciwgc2luY2UKdGhlcmUgaXMgb25seSAzMiBx
dWV1ZXMsIGl0IG1ha2Ugbm8gc2Vuc2UgdG8gdXNlIGEgdmFsdWUgZ3JlYXRlciB0aGFuCjY0WzFd
LiBBbmQgZmluYWxseSwgdGhlIHdlaWdodCBvZiB0aGUgVm9pY2UgaXMgc2V0IHRvIDEyOC4KClsx
XSBCZWNhdXNlIG9mIHRoaXMgYXBwcm94aW1hdGlvbiwgd2l0aCB2ZXJ5IHNsb3cgYnVzLCB3ZSBj
YW4gc3RpbGwKb2JzZXJ2ZSBmcmFtZSBzdGFydmF0aW9uIHdoZW4gd2UgbWVhc3VyZSB0aGUgc3Bl
ZWQgcmF0aW8gb2YgVmkvQmUuIEl0IGlzCmFyb3VuZCAzNU1icHMvMU1icHMgKGluc3RlYWQgb2Yg
MzZNYnBzLzE4MEticHMpLiBIb3dldmVyLCBpdCBpcyBzdGlsbCBpbgphY2NlcHRlZCBlcnJvciBy
YW5nZS4KClNpZ25lZC1vZmYtYnk6IErDqXLDtG1lIFBvdWlsbGVyIDxqZXJvbWUucG91aWxsZXJA
c2lsYWJzLmNvbT4KLS0tCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L3F1ZXVlLmMgfCAxNCArKysrKysr
KysrKystLQogZHJpdmVycy9zdGFnaW5nL3dmeC9xdWV1ZS5oIHwgIDEgKwogMiBmaWxlcyBjaGFu
Z2VkLCAxMyBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZl
cnMvc3RhZ2luZy93ZngvcXVldWUuYyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvcXVldWUuYwppbmRl
eCA2ZTMxNTkxNjUxNDMuLjU1YjgwMWEwMjk1OSAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5n
L3dmeC9xdWV1ZS5jCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvcXVldWUuYwpAQCAtNjAsMTEg
KzYwLDE2IEBAIHZvaWQgd2Z4X3R4X2xvY2tfZmx1c2goc3RydWN0IHdmeF9kZXYgKndkZXYpCiAK
IHZvaWQgd2Z4X3R4X3F1ZXVlc19pbml0KHN0cnVjdCB3ZnhfdmlmICp3dmlmKQogeworCS8vIFRo
ZSBkZXZpY2UgaXMgaW4gY2hhcmdlIHRvIHJlc3BlY3QgdGhlIGRldGFpbHMgb2YgdGhlIFFvUyBw
YXJhbWV0ZXJzLgorCS8vIFRoZSBkcml2ZXIganVzdCBlbnN1cmUgdGhhdCBpdCByb3VnaHRseSBy
ZXNwZWN0IHRoZSBwcmlvcml0aWVzIHRvCisJLy8gYXZvaWQgYW55IHNob3J0YWdlLgorCWNvbnN0
IGludCBwcmlvcml0aWVzW0lFRUU4MDIxMV9OVU1fQUNTXSA9IHsgMSwgMiwgNjQsIDEyOCB9Owog
CWludCBpOwogCiAJZm9yIChpID0gMDsgaSA8IElFRUU4MDIxMV9OVU1fQUNTOyArK2kpIHsKIAkJ
c2tiX3F1ZXVlX2hlYWRfaW5pdCgmd3ZpZi0+dHhfcXVldWVbaV0ubm9ybWFsKTsKIAkJc2tiX3F1
ZXVlX2hlYWRfaW5pdCgmd3ZpZi0+dHhfcXVldWVbaV0uY2FiKTsKKwkJd3ZpZi0+dHhfcXVldWVb
aV0ucHJpb3JpdHkgPSBwcmlvcml0aWVzW2ldOwogCX0KIH0KIApAQCAtMjE5LDYgKzIyNCwxMSBA
QCBib29sIHdmeF90eF9xdWV1ZXNfaGFzX2NhYihzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZikKIAlyZXR1
cm4gZmFsc2U7CiB9CiAKK3N0YXRpYyBpbnQgd2Z4X3R4X3F1ZXVlX2dldF93ZWlnaHQoc3RydWN0
IHdmeF9xdWV1ZSAqcXVldWUpCit7CisJcmV0dXJuIGF0b21pY19yZWFkKCZxdWV1ZS0+cGVuZGlu
Z19mcmFtZXMpICogcXVldWUtPnByaW9yaXR5OworfQorCiBzdGF0aWMgc3RydWN0IHNrX2J1ZmYg
KndmeF90eF9xdWV1ZXNfZ2V0X3NrYihzdHJ1Y3Qgd2Z4X2RldiAqd2RldikKIHsKIAlzdHJ1Y3Qg
d2Z4X3F1ZXVlICpxdWV1ZXNbSUVFRTgwMjExX05VTV9BQ1MgKiBBUlJBWV9TSVpFKHdkZXYtPnZp
ZildOwpAQCAtMjM0LDggKzI0NCw4IEBAIHN0YXRpYyBzdHJ1Y3Qgc2tfYnVmZiAqd2Z4X3R4X3F1
ZXVlc19nZXRfc2tiKHN0cnVjdCB3ZnhfZGV2ICp3ZGV2KQogCQkJV0FSTl9PTihudW1fcXVldWVz
ID49IEFSUkFZX1NJWkUocXVldWVzKSk7CiAJCQlxdWV1ZXNbbnVtX3F1ZXVlc10gPSAmd3ZpZi0+
dHhfcXVldWVbaV07CiAJCQlmb3IgKGogPSBudW1fcXVldWVzOyBqID4gMDsgai0tKQotCQkJCWlm
IChhdG9taWNfcmVhZCgmcXVldWVzW2pdLT5wZW5kaW5nX2ZyYW1lcykgPAotCQkJCSAgICBhdG9t
aWNfcmVhZCgmcXVldWVzW2ogLSAxXS0+cGVuZGluZ19mcmFtZXMpKQorCQkJCWlmICh3ZnhfdHhf
cXVldWVfZ2V0X3dlaWdodChxdWV1ZXNbal0pIDwKKwkJCQkgICAgd2Z4X3R4X3F1ZXVlX2dldF93
ZWlnaHQocXVldWVzW2ogLSAxXSkpCiAJCQkJCXN3YXAocXVldWVzW2ogLSAxXSwgcXVldWVzW2pd
KTsKIAkJCW51bV9xdWV1ZXMrKzsKIAkJfQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dm
eC9xdWV1ZS5oIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9xdWV1ZS5oCmluZGV4IDIyZDdjOTM2OTA3
Zi4uMjY5NWMxMGQ2YTIyIDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L3F1ZXVlLmgK
KysrIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9xdWV1ZS5oCkBAIC0xOCw2ICsxOCw3IEBAIHN0cnVj
dCB3ZnhfcXVldWUgewogCXN0cnVjdCBza19idWZmX2hlYWQJbm9ybWFsOwogCXN0cnVjdCBza19i
dWZmX2hlYWQJY2FiOyAvLyBDb250ZW50IEFmdGVyIChEVElNKSBCZWFjb24KIAlhdG9taWNfdAkJ
cGVuZGluZ19mcmFtZXM7CisJaW50CQkJcHJpb3JpdHk7CiB9OwogCiB2b2lkIHdmeF90eF9sb2Nr
KHN0cnVjdCB3ZnhfZGV2ICp3ZGV2KTsKLS0gCjIuMjguMAoK
