Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8FAE2514BF
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 10:59:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729556AbgHYI7L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 04:59:11 -0400
Received: from mail-dm6nam12on2052.outbound.protection.outlook.com ([40.107.243.52]:53959
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728033AbgHYI7K (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Aug 2020 04:59:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K/g6npRGDt3zip5HjkdenYT0LYy/YQ5Tu+UZLe5gS05jAUs3CKNKOnKt+RycgoF61ttuAFTAGIJ7AdcSmTI+wdwmePlFO8QCZWhkQvtUMPvb6yoKmFSGSELRz5zKWCiRyr4QTd/3clsMJEKcD0pvw4kUJmULoZ4nJXZm9xTqWrnKFO7gwwWuet/TzedcI/tX1PIztdqH5qhAkTVeGFIuqVRNfZi72N6AgjznGPX+iVi1QxttOlb1jiMtPNqewlp22wupDIIjRJcCGbrOJPivUDpRbN4jVz69wVlr6HFJLMvunfshq+ugBmkXOG8X0AZhfziBvTNdVo/XDWQ41RNsAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s0sp6y30pjqI5Gazn1kr2gtAgYJ9qqAzqY75gitmdAo=;
 b=XwodiuVqZpXTin2Hz6IQ0+OwoXbk1nGE8zG+Nh3uUAj6biQIkQzy2JGhsg/WQR4IWQC4ARdi9aHbWXen+tT1NVhSOUUF30W88eS4CDFDK7/r5B50OVQ9GGflKDYlNeo7vEMEJlW06jLXF2cyRBE7GDBxDQsv0QLxSekDYTpRRbC1fqbhtJRAY2w/cxB3Gh+MwuAqdzA+NjiaU7REQesQ1sJMPOY5Hsu1T7HhO7n8KzcieIWH3WkdSrB0a4PA2TKMdwcSHn8pYqYiQEh61e4qNM4RDcBEvn3UFE0kC4lpsqnAEkkA+Dma4sRlMqOG2fJVBjgZ0D9QCgkV1HHGqbeWrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s0sp6y30pjqI5Gazn1kr2gtAgYJ9qqAzqY75gitmdAo=;
 b=bKcNggBtOCMlrGWWlRY7NwEGPmgS2Jo1/YwkxHOGjmd2iqLqc9cdqlYRFKcF1NDJA82Pb9EhzNhmyoZfaem4IKelfuUeOVDQnaf4uiMA26UjmaJ0kizZln5MKIKUyDr0xGxabmN7pck3Pmmvx3+x8oMSas7aNbWEfj0+PKmsZLI=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SN6PR11MB3501.namprd11.prod.outlook.com (2603:10b6:805:d4::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.26; Tue, 25 Aug
 2020 08:58:58 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::85c9:1aa9:aeab:3fa6]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::85c9:1aa9:aeab:3fa6%4]) with mapi id 15.20.3305.026; Tue, 25 Aug 2020
 08:58:58 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH v2 03/12] staging: wfx: fix BA when MFP is disabled but BSS is MFP capable
Date:   Tue, 25 Aug 2020 10:58:19 +0200
Message-Id: <20200825085828.399505-3-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200825085828.399505-1-Jerome.Pouiller@silabs.com>
References: <20200825085828.399505-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PR3P192CA0002.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:102:56::7) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from 255.255.255.255 (255.255.255.255) by PR3P192CA0002.EURP192.PROD.OUTLOOK.COM (2603:10a6:102:56::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.19 via Frontend Transport; Tue, 25 Aug 2020 08:58:56 +0000
X-Mailer: git-send-email 2.28.0
X-Originating-IP: [37.71.187.125]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: de8e4718-8781-483a-64bb-08d848d51a6f
X-MS-TrafficTypeDiagnostic: SN6PR11MB3501:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR11MB3501820427FCA35D49D7DCC893570@SN6PR11MB3501.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6b/aNcRRR9Z8lU26fqoMPDPKKHiuVlKPbrkOHFlWPbq7H1qfsBICspRxfDQJtFnjeMx3e4rBMmshRB5OMtPOz0TCdEZ1Wwybl08BLjI9+0oIxqW3BMnesu7COwZyyMvuRRPNstASRdqFVm4LnkydM4VHuXWS8PFdm4xAuASt0KjGE8QsZjyFGIeqrhHRtU+/pB6qSDj57YjHFn47BXqe/McugmMvkphbTNzhqNGXdG2lzx+LNbzZq0rc3G5WiwVgBa7ix/svPG0cFpaL+R24VMV6ZYa10x/YohG880wTmY1/bRuSf8PaXHCB/rUl9VLMDlurz8eZdJx4E27LMh7k7Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39830400003)(396003)(346002)(376002)(366004)(316002)(5660300002)(478600001)(107886003)(1076003)(8936002)(83380400001)(16576012)(956004)(66556008)(66476007)(26005)(2616005)(186003)(8676002)(86362001)(66946007)(6486002)(54906003)(6666004)(36756003)(4326008)(66574015)(2906002)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: L41zHTgrwyPjhzCJGmoQNTtxXXFmYxIPh9prwjvk9lpqsOxyekzeZrtAODyOPPiEfTVC98mrSP2S7ki/c5sA+eR0gNP/HD9/s/E5sxGrBXthMOumU8Rwg8c/f1S3NC05jHyMxZym3wgDooTFFbrbRPMNT6txpDS0O5yuFvjXXw/vxck0pGFSLVnz3CJ9YNaAH8fNSmoJJWxLVJJi9GXDncfM/+Z5o9m2Zeys3lDvzynrGwWcwp1FWplBf3V3HSzROYY0eLv5llg+KQab/xGJgjxrMyUW8/z98ISJpszyq8a+E31l7zrZnMjOKYlTTd3M6FUufD3Q21wUR5KS4o07vU/aqoE8kqUsTTsArmCQJ2cLNe4KaFY9KOB7DwD716se5hoEQPePJBNvy4aSol5J1kstz9iqVVmNjs74JLFrUf4cq4paDzqrUtDMnV+BS2ctFu5bGGXNov00vlTjs5KEA20CJDwinvYFYT3Rmd4cB9nCY4/qiDsh0MzQRKFAbuKILvcZ+1cquSPrmwfmSSGN5MTanwpSJeQrlnuxvGAYINywjDfLCM5tDc1d0ngIiUM8Gx0QkLRBJSxW0VLWrfLR3H2YsEL7li5uCv/VeNCtME6iAATn5WvX4Jd9S07SnPzch0KJmbBpgkAFb8dGvaSK4A==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: de8e4718-8781-483a-64bb-08d848d51a6f
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2020 08:58:58.3735
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8ndhZjhv/mq3CZtJxFQwhGYaM5/01+jCf5Cbm/WAD692vsRC3Fewl/bH3OXq206OYL4M9JH01jw1mMTEsMuzKw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3501
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVGhl
IHByb3RlY3Rpb24gb2YgdGhlIG1hbmFnZW1lbnQgZnJhbWVzIGlzIG1haW5seSBkb25lIGJ5IG1h
YzgwMjExLgpIb3dldmVyLCBmcmFtZXMgZm9yIHRoZSBtYW5hZ2VtZW50IG9mIHRoZSBCbG9ja0Fj
ayBzZXNzaW9ucyBhcmUgZGlyZWN0bHkKc2VudCBieSB0aGUgZGV2aWNlLiBUaGVzZSBmcmFtZXMg
aGF2ZSB0byBiZSBwcm90ZWN0ZWQgaWYgTUZQIGlzIGluIHVzZS4KU28gdGhlIGRyaXZlciBoYXMg
dG8gcGFzcyB0aGUgTUZQIGNvbmZpZ3VyYXRpb24gdG8gdGhlIGRldmljZS4KClVudGlsIG5vdywg
dGhlIGRyaXZlciBkaXJlY3RseSByZWFkIHRoZSBSU04gSUUgb2YgdGhlIEJTUy4gSG93ZXZlciwg
aXQKZGlkbid0IHdvcmsgd2hlbiB0aGUgQlNTIHdhcyBNRlAgY2FwYWJsZSAoaWVlZTgwMjExdz0x
KSBhbmQgdGhlIGxvY2FsCmRldmljZSBoYXMgZGlzYWJsZWQgTUZQIChpZWVlODAyMTF3PTApLgoK
VGhpcyBwYXRjaCByZWFkIHRoZSBNRlAgaW5mb3JtYXRpb24gZGlyZWN0bHkgZnJvbSB0aGUgc3Ry
dWN0CmllZWU4MDIxMV9zdGEuIFRoaXMgaW5mb3JtYXRpb24gdGFrZSBpbnRvIGFjY291bnQgdGhl
IE1GUCBuZWdvdGlhdGVkCmR1cmluZyB0aGUgYXNzb2NpYXRpb24uIEluIGFkZGl0aW9uLCB0aGUg
Y29kZSBpcyBmYXIgc2ltcGxlci4KClNpZ25lZC1vZmYtYnk6IErDqXLDtG1lIFBvdWlsbGVyIDxq
ZXJvbWUucG91aWxsZXJAc2lsYWJzLmNvbT4KLS0tCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5j
IHwgMzQgKysrLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQogMSBmaWxlIGNoYW5nZWQs
IDMgaW5zZXJ0aW9ucygrKSwgMzEgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9z
dGFnaW5nL3dmeC9zdGEuYyBiL2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMKaW5kZXggYjZjY2Iw
NGYzMDhhLi4yYjg0OGI4OTg1ZGYgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93Zngvc3Rh
LmMKKysrIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYwpAQCAtMzIzLDM2ICszMjMsNiBAQCB2
b2lkIHdmeF9zZXRfZGVmYXVsdF91bmljYXN0X2tleShzdHJ1Y3QgaWVlZTgwMjExX2h3ICpodywK
IAloaWZfd2VwX2RlZmF1bHRfa2V5X2lkKHd2aWYsIGlkeCk7CiB9CiAKLXN0YXRpYyB2b2lkIHdm
eF9zZXRfbWZwKHN0cnVjdCB3ZnhfdmlmICp3dmlmLAotCQkJc3RydWN0IGNmZzgwMjExX2JzcyAq
YnNzKQotewotCWNvbnN0IGludCBwYWlyd2lzZV9jaXBoZXJfc3VpdGVfY291bnRfb2Zmc2V0ID0g
OCAvIHNpemVvZih1MTYpOwotCWNvbnN0IGludCBwYWlyd2lzZV9jaXBoZXJfc3VpdGVfc2l6ZSA9
IDQgLyBzaXplb2YodTE2KTsKLQljb25zdCBpbnQgYWttX3N1aXRlX3NpemUgPSA0IC8gc2l6ZW9m
KHUxNik7Ci0JY29uc3QgdTE2ICpwdHIgPSBOVUxMOwotCWJvb2wgbWZwYyA9IGZhbHNlOwotCWJv
b2wgbWZwciA9IGZhbHNlOwotCi0JLyogODAyLjExdyBwcm90ZWN0ZWQgbWdtdCBmcmFtZXMgKi8K
LQotCS8qIHJldHJpZXZlIE1GUEMgYW5kIE1GUFIgZmxhZ3MgZnJvbSBiZWFjb24gb3IgUEJSU1Ag
Ki8KLQotCXJjdV9yZWFkX2xvY2soKTsKLQlpZiAoYnNzKQotCQlwdHIgPSAoY29uc3QgdTE2ICop
aWVlZTgwMjExX2Jzc19nZXRfaWUoYnNzLCBXTEFOX0VJRF9SU04pOwotCi0JaWYgKHB0cikgewot
CQlwdHIgKz0gcGFpcndpc2VfY2lwaGVyX3N1aXRlX2NvdW50X29mZnNldDsKLQkJcHRyICs9IDEg
KyBwYWlyd2lzZV9jaXBoZXJfc3VpdGVfc2l6ZSAqICpwdHI7Ci0JCXB0ciArPSAxICsgYWttX3N1
aXRlX3NpemUgKiAqcHRyOwotCQltZnByID0gKnB0ciAmIEJJVCg2KTsKLQkJbWZwYyA9ICpwdHIg
JiBCSVQoNyk7Ci0JfQotCXJjdV9yZWFkX3VubG9jaygpOwotCi0JaGlmX3NldF9tZnAod3ZpZiwg
bWZwYywgbWZwcik7Ci19Ci0KIHZvaWQgd2Z4X3Jlc2V0KHN0cnVjdCB3ZnhfdmlmICp3dmlmKQog
ewogCXN0cnVjdCB3ZnhfZGV2ICp3ZGV2ID0gd3ZpZi0+d2RldjsKQEAgLTQwMCw3ICszNzAsNiBA
QCBzdGF0aWMgdm9pZCB3ZnhfZG9fam9pbihzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZikKIAl9CiAJcmN1
X3JlYWRfdW5sb2NrKCk7CiAKLQl3Znhfc2V0X21mcCh3dmlmLCBic3MpOwogCWNmZzgwMjExX3B1
dF9ic3Mod3ZpZi0+d2Rldi0+aHctPndpcGh5LCBic3MpOwogCiAJd3ZpZi0+am9pbl9pbl9wcm9n
cmVzcyA9IHRydWU7CkBAIC00MjcsNiArMzk2LDkgQEAgaW50IHdmeF9zdGFfYWRkKHN0cnVjdCBp
ZWVlODAyMTFfaHcgKmh3LCBzdHJ1Y3QgaWVlZTgwMjExX3ZpZiAqdmlmLAogCiAJc3RhX3ByaXYt
PnZpZl9pZCA9IHd2aWYtPmlkOwogCisJaWYgKHZpZi0+dHlwZSA9PSBOTDgwMjExX0lGVFlQRV9T
VEFUSU9OKQorCQloaWZfc2V0X21mcCh3dmlmLCBzdGEtPm1mcCwgc3RhLT5tZnApOworCiAJLy8g
SW4gc3RhdGlvbiBtb2RlLCB0aGUgZmlybXdhcmUgaW50ZXJwcmV0cyBuZXcgbGluay1pZCBhcyBh
IFRETFMgcGVlci4KIAlpZiAodmlmLT50eXBlID09IE5MODAyMTFfSUZUWVBFX1NUQVRJT04gJiYg
IXN0YS0+dGRscykKIAkJcmV0dXJuIDA7Ci0tIAoyLjI4LjAKCg==
