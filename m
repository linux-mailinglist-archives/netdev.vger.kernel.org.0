Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A9B724C2D8
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 18:03:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729700AbgHTQDL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 12:03:11 -0400
Received: from mail-bn7nam10on2087.outbound.protection.outlook.com ([40.107.92.87]:47585
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729490AbgHTP7x (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Aug 2020 11:59:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aoc9pRgP0NEJM5qymmy5T5cvr+U4pNmZsLA8xPsAAgul794M0KSeMn719ARQFmVUwQQXFdSwQzQxwFZK3UIJyj5Cg3N5cywVqNHkuDsoTyQig0GNkCPyGL7i69zXbr1Gw5TbaW5f2W8SFoHhHn6+pRxQPdP+I7cMELMi7cM3OUqBPKRRfhRIjF2AMLTip5S2E6xh/WmYOS9a5NhyhiTekfWGSdR1FuB3MhULQQ044utMDvCru0uwcbbskIxLZLkLq0bK1onz18zZZnh+eCtMpPARviiGBJYxykyuTIdkYvPBnACZpTxo/1cIo2AXEaCIlH1UZcvmqQ9l5M0HjQ8CFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wQXvApKjr0cY61ggIb8gLuomgp6b/xpqnIfJVhA+1WE=;
 b=T70bEuyduMel4f8jVZ30v7NEpDYbQjxv8mwMUhJ+qZpYCbuJ0V0AESFptXHHplAwZzp70q/k4acn6nDxeQGGCMxNwrQrVe/U5ly8YhyNpnK4RbapJHhnMIobWTdRnCzwSx2GPmSg9fZ6bKVc8AGt7aDqmkCwQvnTH6yNchkn9EIgWxsg8bAul4ofBv7mIe6TXDt34a1zU6Fk7irPTSHj/X+5oaGRj42dpLmVZzP6A86FHIfQC78YxwYplnKKo9AQ6GPpcAhwpRW24Eo7PZMxJC4xC0LRS8rnOpaVxwhcg89tKCAlEveUluO/RPWTweBre7PFv7Zn0oubnvLbMCBEdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wQXvApKjr0cY61ggIb8gLuomgp6b/xpqnIfJVhA+1WE=;
 b=ctIY+MbcqMnUp7vJDTjzU/+76oqw8yS7tQ9GE9BBq4bNr8IEWNGUHoB33l7LjEDozQtHDVLGiZHueP+lLtJq6geo8xWQdYDmvXcj8v0tu/9n2Fq9QInERxbBpUgoG01K1CIIS/ub2ihakyZnM7zmzXRZZ1Fi50kobyDk1E92ims=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SA0PR11MB4541.namprd11.prod.outlook.com (2603:10b6:806:94::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.25; Thu, 20 Aug
 2020 15:59:32 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::85c9:1aa9:aeab:3fa6]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::85c9:1aa9:aeab:3fa6%4]) with mapi id 15.20.3305.026; Thu, 20 Aug 2020
 15:59:32 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 06/12] staging: wfx: drop useless field from struct wfx_tx_priv
Date:   Thu, 20 Aug 2020 17:58:52 +0200
Message-Id: <20200820155858.351292-6-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820155858.351292-1-Jerome.Pouiller@silabs.com>
References: <20200820155858.351292-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PR0P264CA0122.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1a::14) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from 255.255.255.255 (255.255.255.255) by PR0P264CA0122.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:1a::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.24 via Frontend Transport; Thu, 20 Aug 2020 15:59:30 +0000
X-Mailer: git-send-email 2.28.0
X-Originating-IP: [37.71.187.125]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0f78d5e2-afb3-42db-465c-08d8452206bf
X-MS-TrafficTypeDiagnostic: SA0PR11MB4541:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR11MB4541ED5C60313C4DF174B8E2935A0@SA0PR11MB4541.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tE92PA3TroTkEvHJweLnlPGr2NFzOzpvP/TRo6X1Tw5DFckFc0lmX2o+zilVHBW1PbigBRgKM11PPEcNYzvSo3egjPpK6yc6dhwH9ZqRlaboSYcTNXp+JtpqBDw2aE8kpj4nEVXS09cPkm35aFgZVlIUOayogefgTLGVbTNM4WITAtSGVRYAvttQ5kqzl6Xg82Pf/FP8PBFZtIt4RhCLZWtOyhmirbIBF6rwnpc+IVSGWm8uqE8K0QJmMZJGshqGiWMuZrmvlDt12elH4eFgByfAnuVz88MVParfa6C6nT8JX7Ls2ytJk9JIF8hicOsS92DN2aLO5eWdtr3hFK2N1LlpbswvpszMsYHPFVWztrs3BeOXg02mn84zA7GGMq4P
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(39850400004)(366004)(346002)(136003)(186003)(6666004)(2906002)(8676002)(316002)(16576012)(54906003)(956004)(26005)(66574015)(8936002)(2616005)(110011004)(52116002)(83380400001)(107886003)(1076003)(5660300002)(478600001)(36756003)(4326008)(66476007)(66556008)(66946007)(86362001)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: ucKawbgDHIaSxcLH9b1t+jgU04mY1QymNo0hkREhg3T3ziSFJxMmi98DjgPwa+5v7yWvLCtG+ZztukUNdTQe6G9US9fGXW4gFa9RdSOwB5HHJVi/Ew7XGCBINPPXlhsWeUDEJbv+MgLgeuc73AWwJ6WxW62FfXQfNfaz04aJWDLBdnm6DipO2pnyc3y3xnAo2K+r4yKL1SJ2pwf2YNS+zffyJYmnVIlG3T5lWSkv8CN5ol3V3bzUwlpgIAoXs0f6G/sCFW1kYx9KcyuSkAK9E4L1VmB26vyuGpEGDUIXGSp+SOccbh7sv8psVwYLRDMHd6tzQpSFrxPctX4PQtd4qkf1eySeUdycaiH7X2mpVodfuDPxTc4AwD45myGD8j+qZPd+mo5Q4dC2TNWaX8Zh+Wp6BF5lyIwvowk4M+DOOIB1sVQ1UENe1wJKlUmP6P83RFa6RCNR8jjSR0/b45eEXdrUNB6n/FfF0HcyEYH+u/DpDftCVXLmvguA/+5hyxR4tGxQa2Qo1PyvaYamMmNZUadGroZFPrw8aO05shQxcMBkz3jSZTrclTYSTcTug9rVlp8oOyb3ESKYL5HGT4hBDsG5sn+UF3lh7c+k7+fgyzlwI0Z1nFyG3DriqhA7GGH0WlAcGBml4NZnso+rJL92kQ==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f78d5e2-afb3-42db-465c-08d8452206bf
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2020 15:59:31.8747
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: c1l8LP/OjNVDKIhV+kDXE15T1BwsUPVwsKupNX37DApeNk6/ZqegPNX/0w4jkr1i3fy0MXdesm+U/SwsIhhnlw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4541
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVGhl
IGRldmljZSBuZWVkIHRvIHJlY2VpdmUgYSBza2Igd2l0aCBuZWNlc3Nhcnkgc3BhY2UgZm9yIHRo
ZSBJQ1YuIFNvLAp0aGUgZHJpdmVyIGFkZHMgdGhpcyBzcGFjZSBiZWZvcmUgdG8gc2VuZCB0aGUg
ZnJhbWUuCgpDdXJyZW50bHksIG9uY2UgdGhlIGZyYW1lIGlzIHNlbnQsIHRoZSBkcml2ZXIgcmVz
dG9yZSB0aGUgb3JpZ2luYWwKY29udGVudCBvZiB0aGUgc2tiLiBIb3dldmVyLCB0aGlzIHN0ZXAg
aXMgdXNlbGVzcy4gTWFjODAyMTEgZG9uJ3QgZG8gaXQKd2hlbiBzb2Z0d2FyZSBlbmNyeXB0aW9u
IGlzIGVuYWJsZWQuCgpPbmNlIHdlIGhhdmUgcmVtb3ZlZCB0aGlzIHN0ZXAsIGl0IGFwcGVhcnMg
dGhhdCBpdCBpcyBubyBtb3JlIG5lY2Vzc2FyeQp0byBrZWVwIGh3X2tleSBpbiB0eF9wcml2LiBU
aGVuLCBpdCBpcyBwb3NzaWJsZSB0byBzaW1wbGlmeSBhIGJ1bmNoIG9mCmNvZGUgaW4gdGhlIFR4
IHBhdGguCgpTaWduZWQtb2ZmLWJ5OiBKw6lyw7RtZSBQb3VpbGxlciA8amVyb21lLnBvdWlsbGVy
QHNpbGFicy5jb20+Ci0tLQogZHJpdmVycy9zdGFnaW5nL3dmeC9kYXRhX3R4LmMgfCAxNiArKysr
LS0tLS0tLS0tLS0tCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L2RhdGFfdHguaCB8ICAzICstLQogMiBm
aWxlcyBjaGFuZ2VkLCA1IGluc2VydGlvbnMoKyksIDE0IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdp
dCBhL2RyaXZlcnMvc3RhZ2luZy93ZngvZGF0YV90eC5jIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9k
YXRhX3R4LmMKaW5kZXggZDE2YjUxNmFkN2NmLi40ODU5MDdiMGZhYTIgMTAwNjQ0Ci0tLSBhL2Ry
aXZlcnMvc3RhZ2luZy93ZngvZGF0YV90eC5jCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvZGF0
YV90eC5jCkBAIC0zMzYsNyArMzM2LDYgQEAgc3RhdGljIGludCB3ZnhfdHhfaW5uZXIoc3RydWN0
IHdmeF92aWYgKnd2aWYsIHN0cnVjdCBpZWVlODAyMTFfc3RhICpzdGEsCiB7CiAJc3RydWN0IGhp
Zl9tc2cgKmhpZl9tc2c7CiAJc3RydWN0IGhpZl9yZXFfdHggKnJlcTsKLQlzdHJ1Y3Qgd2Z4X3R4
X3ByaXYgKnR4X3ByaXY7CiAJc3RydWN0IGllZWU4MDIxMV90eF9pbmZvICp0eF9pbmZvID0gSUVF
RTgwMjExX1NLQl9DQihza2IpOwogCXN0cnVjdCBpZWVlODAyMTFfa2V5X2NvbmYgKmh3X2tleSA9
IHR4X2luZm8tPmNvbnRyb2wuaHdfa2V5OwogCXN0cnVjdCBpZWVlODAyMTFfaGRyICpoZHIgPSAo
c3RydWN0IGllZWU4MDIxMV9oZHIgKilza2ItPmRhdGE7CkBAIC0zNTAsMTQgKzM0OSwxMSBAQCBz
dGF0aWMgaW50IHdmeF90eF9pbm5lcihzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiwgc3RydWN0IGllZWU4
MDIxMV9zdGEgKnN0YSwKIAogCS8vIEZyb20gbm93IHR4X2luZm8tPmNvbnRyb2wgaXMgdW51c2Fi
bGUKIAltZW1zZXQodHhfaW5mby0+cmF0ZV9kcml2ZXJfZGF0YSwgMCwgc2l6ZW9mKHN0cnVjdCB3
ZnhfdHhfcHJpdikpOwotCS8vIEZpbGwgdHhfcHJpdgotCXR4X3ByaXYgPSAoc3RydWN0IHdmeF90
eF9wcml2ICopdHhfaW5mby0+cmF0ZV9kcml2ZXJfZGF0YTsKLQl0eF9wcml2LT5od19rZXkgPSBo
d19rZXk7CiAKIAkvLyBGaWxsIGhpZl9tc2cKIAlXQVJOKHNrYl9oZWFkcm9vbShza2IpIDwgd21z
Z19sZW4sICJub3QgZW5vdWdoIHNwYWNlIGluIHNrYiIpOwogCVdBUk4ob2Zmc2V0ICYgMSwgImF0
dGVtcHQgdG8gdHJhbnNtaXQgYW4gdW5hbGlnbmVkIGZyYW1lIik7Ci0Jc2tiX3B1dChza2IsIHdm
eF90eF9nZXRfaWN2X2xlbih0eF9wcml2LT5od19rZXkpKTsKKwlza2JfcHV0KHNrYiwgd2Z4X3R4
X2dldF9pY3ZfbGVuKGh3X2tleSkpOwogCXNrYl9wdXNoKHNrYiwgd21zZ19sZW4pOwogCW1lbXNl
dChza2ItPmRhdGEsIDAsIHdtc2dfbGVuKTsKIAloaWZfbXNnID0gKHN0cnVjdCBoaWZfbXNnICop
c2tiLT5kYXRhOwpAQCAtNDg5LDcgKzQ4NSw2IEBAIHN0YXRpYyB2b2lkIHdmeF90eF9maWxsX3Jh
dGVzKHN0cnVjdCB3ZnhfZGV2ICp3ZGV2LAogdm9pZCB3ZnhfdHhfY29uZmlybV9jYihzdHJ1Y3Qg
d2Z4X2RldiAqd2RldiwgY29uc3Qgc3RydWN0IGhpZl9jbmZfdHggKmFyZykKIHsKIAlzdHJ1Y3Qg
aWVlZTgwMjExX3R4X2luZm8gKnR4X2luZm87Ci0JY29uc3Qgc3RydWN0IHdmeF90eF9wcml2ICp0
eF9wcml2OwogCXN0cnVjdCB3ZnhfdmlmICp3dmlmOwogCXN0cnVjdCBza19idWZmICpza2I7CiAK
QEAgLTQ5OSwxOCArNDk0LDE1IEBAIHZvaWQgd2Z4X3R4X2NvbmZpcm1fY2Ioc3RydWN0IHdmeF9k
ZXYgKndkZXYsIGNvbnN0IHN0cnVjdCBoaWZfY25mX3R4ICphcmcpCiAJCQkgYXJnLT5wYWNrZXRf
aWQpOwogCQlyZXR1cm47CiAJfQorCXR4X2luZm8gPSBJRUVFODAyMTFfU0tCX0NCKHNrYik7CiAJ
d3ZpZiA9IHdkZXZfdG9fd3ZpZih3ZGV2LCAoKHN0cnVjdCBoaWZfbXNnICopc2tiLT5kYXRhKS0+
aW50ZXJmYWNlKTsKIAlXQVJOX09OKCF3dmlmKTsKIAlpZiAoIXd2aWYpCiAJCXJldHVybjsKLQl0
eF9pbmZvID0gSUVFRTgwMjExX1NLQl9DQihza2IpOwotCXR4X3ByaXYgPSB3Znhfc2tiX3R4X3By
aXYoc2tiKTsKKworCS8vIE5vdGUgdGhhdCB3ZnhfcGVuZGluZ19nZXRfcGt0X3VzX2RlbGF5KCkg
Z2V0IGRhdGEgZnJvbSB0eF9pbmZvCiAJX3RyYWNlX3R4X3N0YXRzKGFyZywgc2tiLCB3ZnhfcGVu
ZGluZ19nZXRfcGt0X3VzX2RlbGF5KHdkZXYsIHNrYikpOwotCi0JLy8gWW91IGNhbiB0b3VjaCB0
byB0eF9wcml2LCBidXQgZG9uJ3QgdG91Y2ggdG8gdHhfaW5mby0+c3RhdHVzLgogCXdmeF90eF9m
aWxsX3JhdGVzKHdkZXYsIHR4X2luZm8sIGFyZyk7Ci0Jc2tiX3RyaW0oc2tiLCBza2ItPmxlbiAt
IHdmeF90eF9nZXRfaWN2X2xlbih0eF9wcml2LT5od19rZXkpKTsKLQogCS8vIEZyb20gbm93LCB5
b3UgY2FuIHRvdWNoIHRvIHR4X2luZm8tPnN0YXR1cywgYnV0IGRvIG5vdCB0b3VjaCB0bwogCS8v
IHR4X3ByaXYgYW55bW9yZQogCS8vIEZJWE1FOiB1c2UgaWVlZTgwMjExX3R4X2luZm9fY2xlYXJf
c3RhdHVzKCkKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93ZngvZGF0YV90eC5oIGIvZHJp
dmVycy9zdGFnaW5nL3dmeC9kYXRhX3R4LmgKaW5kZXggY2ZmN2I5ZmY5OWE5Li44N2UxYjliNjJk
YmIgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93ZngvZGF0YV90eC5oCisrKyBiL2RyaXZl
cnMvc3RhZ2luZy93ZngvZGF0YV90eC5oCkBAIC0zNSw4ICszNSw3IEBAIHN0cnVjdCB0eF9wb2xp
Y3lfY2FjaGUgewogCiBzdHJ1Y3Qgd2Z4X3R4X3ByaXYgewogCWt0aW1lX3QgeG1pdF90aW1lc3Rh
bXA7Ci0Jc3RydWN0IGllZWU4MDIxMV9rZXlfY29uZiAqaHdfa2V5OwotfSBfX3BhY2tlZDsKK307
CiAKIHZvaWQgd2Z4X3R4X3BvbGljeV9pbml0KHN0cnVjdCB3ZnhfdmlmICp3dmlmKTsKIHZvaWQg
d2Z4X3R4X3BvbGljeV91cGxvYWRfd29yayhzdHJ1Y3Qgd29ya19zdHJ1Y3QgKndvcmspOwotLSAK
Mi4yOC4wCgo=
