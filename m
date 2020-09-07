Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D399825F864
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 12:32:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728659AbgIGKQM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 06:16:12 -0400
Received: from mail-eopbgr770081.outbound.protection.outlook.com ([40.107.77.81]:21675
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728578AbgIGKP7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Sep 2020 06:15:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gm8PFqYSvQkiuv6WbsLwvBZWnpPBx+F9Nep6oaVZBVrQMoJ56rY6A+vHCTAJ2AkeGzMUPgbIUhvOMFWeTKSwbKeokjO69DwTH2cx9+3lehAqltyQMmbFsn2SEpeI2cKLwJLHDgmt3Cs0ltEg6h3P07otkxsA2zfN+IAexDuZW3D5Bvio6k3tDBqdsTSIIvrgjndPwsgvpRpnjVucebo+rRbR1l5a2o55Pz5TPrfQTR1zF6gdI6nZQF2CGSU/MkH3altIXEeZoS0ByahwdS0oH7XGjn/cau5lG5P2QXwelJ4/mYwaaHpaJXuHqolvYP1Oqn8DCQnLe9WGY1PEQti0Sw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D2jM+kgD2WXgbBXIjo869uKm6EUwRZpEWfSKlncRfho=;
 b=JtzQAlpmYeX2ATtAnTBKeENQRTZy7XL27SKDfHJtuE8NLjplvRxcbRgX2JsOlS4QtaRtM9/OVGMMWjnNqaz/F5O3u8bi0wzNDdk5zX/8pRgiLqpa4oKMAvLTDJyyA7Di3DigYyU8G7nFkwB6j1opqwGaJPXpVMPU0teIwFM3/njNpufW9glp4lD0P0ZKitxwt5Id3W3wpPY46P5vQm0mQQA7HxDyvjczrOrq4Zuq/JS/733F6Lb92v8Laj8VSalBR07EvdN1ocTOYs8+6Q63UptAPncQLjxadevLGI9oRFjb9qnHff6IXtLnrLFey+nAsM3FnpVuaSb0lMVId3A7cg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D2jM+kgD2WXgbBXIjo869uKm6EUwRZpEWfSKlncRfho=;
 b=dkfBqzFfH/cwnZq0M6cA37RdZ2mGakV5IJvzME8EPFOW0B4judgsyW07OSKkZ3tZ3K20briZ0fHRmlbFtL9gHgCRlG0QoIVA17x3lB38Z83nro+AuWedp8Wr7UvCix7HVMuj9/XNd+LOMQueMXWY8RXxO+CM9WKEtIZEQ5U50wg=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SN6PR11MB2606.namprd11.prod.outlook.com (2603:10b6:805:55::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.17; Mon, 7 Sep
 2020 10:15:49 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::85c9:1aa9:aeab:3fa6]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::85c9:1aa9:aeab:3fa6%4]) with mapi id 15.20.3348.019; Mon, 7 Sep 2020
 10:15:49 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 03/31] staging: wfx: simplify hif_set_association_mode()
Date:   Mon,  7 Sep 2020 12:14:53 +0200
Message-Id: <20200907101521.66082-4-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200907101521.66082-1-Jerome.Pouiller@silabs.com>
References: <20200907101521.66082-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PR0P264CA0109.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:19::25) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.silabs.com (37.71.187.125) by PR0P264CA0109.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:19::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.16 via Frontend Transport; Mon, 7 Sep 2020 10:15:47 +0000
X-Mailer: git-send-email 2.28.0
X-Originating-IP: [37.71.187.125]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f42e480e-764d-4506-0dc8-08d85316fe02
X-MS-TrafficTypeDiagnostic: SN6PR11MB2606:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR11MB2606EB0918BE2FAC4DB12B5393280@SN6PR11MB2606.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XzhSlCPFQiJIPGLXA2Tfxnpg8CfIAntNK4SKiHWf3p/k6ZNz4Jw7glXzfPnn56AQiGSCCowpCepuIqxoXBjs4dZjU9VCFyo0/2agZhnBVB65pnAoyJylE6TPc7n2TK6PijgowV/56fWUkcVgwPre1eY/0t0alCO4a2jkDIPjATz3WkcFwHTnqeW944SBUjGnvV4dDzB88k8WbYhjqlUCktfH59EwiQ0gqIwkqGTfgueRofYYFnzeJCL16+ridse+5ONeeNIDdbSCm4XpUPNiKnDGZWhXsjXQv6wacwB7GZOqe5WzVZ03UtljvBu69R3d+UQGwsRPe8r8j/lUMGPc/Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(376002)(346002)(366004)(136003)(39850400004)(66946007)(4326008)(5660300002)(2616005)(66476007)(316002)(956004)(478600001)(6666004)(54906003)(52116002)(2906002)(66556008)(1076003)(36756003)(8676002)(86362001)(6486002)(8936002)(7696005)(66574015)(83380400001)(26005)(107886003)(16526019)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: RazQn8BFpc2QCJ183ysDoIUZq4XzODkud5KnhhLFi68WRbFhvQGwVXWuYPeNerfBCwof07UJu0xxp4cRfCrrTbGrOBpqeSOyan+J/A5vLNFiI3H5pxoIn2zNG0uUI2sWauT0hKrCJlU29GOS+hAK5jrZ/xi00j4KwSB2Bp33v4XqQ0cHYg+vnIg3gcchHQlHiPbf+YqOJDUOZy1i9CMaq4odzuyxFDzdiPVOF5RT8PtsfkNGWvtNvA3dqPcARqS2lbtC40c4g+PlAGnupjBsEpG4HpMVOjZQ4CiBhv+x1Jjg0C/M3GlYhlBdBiR75EqAcZGH7ZVXxKFx4HafkIWIZUeJJFY08A76LNqDI+owe5qnzr7uekhprb5JqeHovxe6CTxbgx/AEalxqVKdpWKahXp9OXFyozbENXES70PUR3WruJ+NmJ0zVdEABk7qOB8F5HrqG3bfVcdvX1nLejlNVF/5PySAUp6j+ByFOjn8h0em10o6SE2X5/Apf1i1oIAJ9kJsQNTAuV3T2BHSogHgKpyM+WjWMY2mRlrHSZnZ/i7wtfLVqmNA5SNeYdWRvRO1I6d53ymovcegI0+pE7Ig63yY4OUOrENJ01/hf4gHCesXr3W1XdBF8NMKZ/Uc2cbB2yMW9fm4onwL43bqL/1qRw==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f42e480e-764d-4506-0dc8-08d85316fe02
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2020 10:15:49.0507
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oyj3XIOeFDppA4HXUKYbvv7blwnGhJeJ2e3++mWspAD9QSE5OmGSzR/yUcxxd5NIgMJo7f11hICEmXx4AlDcJg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2606
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVGhl
IGZpbGUgaGlmX3R4X21pYi5jIGV4cGVjdHMgdG8gY29udGFpbiBmdW5jdGlvbnMgdGhhdCBmb3Jt
YXQgbWVzc2FnZXMKZm9yIHRoZSBoYXJkd2FyZS4gSXQgaXMgdW5leHBlY3RlZCB0byBmaW5kIGZ1
bmN0aW9uIHRoYXQgbWFuaXB1bGF0ZQpSQ1UgYW5kIHN0cnVjdHVyZXMgZnJvbSBtYWM4MDIxMS4K
CktlZXAgaGlmX3NldF9hc3NvY2lhdGlvbl9tb2RlKCkgd2l0aCB0aGUgY29kZSBuZWNlc3Nhcnkg
Zm9yIG1lc3NhZ2UKZm9ybWF0dGluZyBhbmQgcmVsb2NhdGUgdGhlIHNtYXJ0IHBhcnQgaW4gd2Z4
X2pvaW5fZmluYWxpemUoKS4KClNpZ25lZC1vZmYtYnk6IErDqXLDtG1lIFBvdWlsbGVyIDxqZXJv
bWUucG91aWxsZXJAc2lsYWJzLmNvbT4KLS0tCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl90eF9t
aWIuYyB8IDIxICsrKysrLS0tLS0tLS0tLS0tLS0tLQogZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZf
dHhfbWliLmggfCAgNCArKy0tCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jICAgICAgICB8IDE3
ICsrKysrKysrKysrKysrKystCiAzIGZpbGVzIGNoYW5nZWQsIDIzIGluc2VydGlvbnMoKyksIDE5
IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX3R4X21p
Yi5jIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfdHhfbWliLmMKaW5kZXggMDVmMWUxZTk4YWY5
Li4zYjIwYjc0ODZmMDggMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX3R4X21p
Yi5jCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX3R4X21pYi5jCkBAIC0xODcsMjkgKzE4
NywxOCBAQCBpbnQgaGlmX3NldF9ibG9ja19hY2tfcG9saWN5KHN0cnVjdCB3ZnhfdmlmICp3dmlm
LAogCQkJICAgICAmdmFsLCBzaXplb2YodmFsKSk7CiB9CiAKLWludCBoaWZfc2V0X2Fzc29jaWF0
aW9uX21vZGUoc3RydWN0IHdmeF92aWYgKnd2aWYsCi0JCQkgICAgIHN0cnVjdCBpZWVlODAyMTFf
YnNzX2NvbmYgKmluZm8pCitpbnQgaGlmX3NldF9hc3NvY2lhdGlvbl9tb2RlKHN0cnVjdCB3Znhf
dmlmICp3dmlmLCBpbnQgYW1wZHVfZGVuc2l0eSwKKwkJCSAgICAgYm9vbCBncmVlbmZpZWxkLCBi
b29sIHNob3J0X3ByZWFtYmxlKQogewotCXN0cnVjdCBpZWVlODAyMTFfc3RhICpzdGEgPSBOVUxM
OwogCXN0cnVjdCBoaWZfbWliX3NldF9hc3NvY2lhdGlvbl9tb2RlIHZhbCA9IHsKIAkJLnByZWFt
YnR5cGVfdXNlID0gMSwKIAkJLm1vZGUgPSAxLAogCQkuc3BhY2luZyA9IDEsCi0JCS5zaG9ydF9w
cmVhbWJsZSA9IGluZm8tPnVzZV9zaG9ydF9wcmVhbWJsZSwKKwkJLnNob3J0X3ByZWFtYmxlID0g
c2hvcnRfcHJlYW1ibGUsCisJCS5ncmVlbmZpZWxkID0gZ3JlZW5maWVsZCwKKwkJLm1wZHVfc3Rh
cnRfc3BhY2luZyA9IGFtcGR1X2RlbnNpdHksCiAJfTsKIAotCXJjdV9yZWFkX2xvY2soKTsgLy8g
cHJvdGVjdCBzdGEKLQlpZiAoaW5mby0+YnNzaWQgJiYgIWluZm8tPmlic3Nfam9pbmVkKQotCQlz
dGEgPSBpZWVlODAyMTFfZmluZF9zdGEod3ZpZi0+dmlmLCBpbmZvLT5ic3NpZCk7Ci0KLQkvLyBG
SVhNRTogaXQgaXMgc3RyYW5nZSB0byBub3QgcmV0cmlldmUgYWxsIGluZm9ybWF0aW9uIGZyb20g
YnNzX2luZm8KLQlpZiAoc3RhICYmIHN0YS0+aHRfY2FwLmh0X3N1cHBvcnRlZCkgewotCQl2YWwu
bXBkdV9zdGFydF9zcGFjaW5nID0gc3RhLT5odF9jYXAuYW1wZHVfZGVuc2l0eTsKLQkJaWYgKCEo
aW5mby0+aHRfb3BlcmF0aW9uX21vZGUgJiBJRUVFODAyMTFfSFRfT1BfTU9ERV9OT05fR0ZfU1RB
X1BSU05UKSkKLQkJCXZhbC5ncmVlbmZpZWxkID0gISEoc3RhLT5odF9jYXAuY2FwICYgSUVFRTgw
MjExX0hUX0NBUF9HUk5fRkxEKTsKLQl9Ci0JcmN1X3JlYWRfdW5sb2NrKCk7Ci0KIAlyZXR1cm4g
aGlmX3dyaXRlX21pYih3dmlmLT53ZGV2LCB3dmlmLT5pZCwKIAkJCSAgICAgSElGX01JQl9JRF9T
RVRfQVNTT0NJQVRJT05fTU9ERSwgJnZhbCwgc2l6ZW9mKHZhbCkpOwogfQpkaWZmIC0tZ2l0IGEv
ZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfdHhfbWliLmggYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hp
Zl90eF9taWIuaAppbmRleCA4NjY4M2RlN2RlN2MuLjFhNmY0MjIxYmRlYiAxMDA2NDQKLS0tIGEv
ZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfdHhfbWliLmgKKysrIGIvZHJpdmVycy9zdGFnaW5nL3dm
eC9oaWZfdHhfbWliLmgKQEAgLTMzLDggKzMzLDggQEAgaW50IGhpZl9zZXRfdGVtcGxhdGVfZnJh
bWUoc3RydWN0IHdmeF92aWYgKnd2aWYsIHN0cnVjdCBza19idWZmICpza2IsCiBpbnQgaGlmX3Nl
dF9tZnAoc3RydWN0IHdmeF92aWYgKnd2aWYsIGJvb2wgY2FwYWJsZSwgYm9vbCByZXF1aXJlZCk7
CiBpbnQgaGlmX3NldF9ibG9ja19hY2tfcG9saWN5KHN0cnVjdCB3ZnhfdmlmICp3dmlmLAogCQkJ
ICAgICB1OCB0eF90aWRfcG9saWN5LCB1OCByeF90aWRfcG9saWN5KTsKLWludCBoaWZfc2V0X2Fz
c29jaWF0aW9uX21vZGUoc3RydWN0IHdmeF92aWYgKnd2aWYsCi0JCQkgICAgIHN0cnVjdCBpZWVl
ODAyMTFfYnNzX2NvbmYgKmluZm8pOworaW50IGhpZl9zZXRfYXNzb2NpYXRpb25fbW9kZShzdHJ1
Y3Qgd2Z4X3ZpZiAqd3ZpZiwgaW50IGFtcGR1X2RlbnNpdHksCisJCQkgICAgIGJvb2wgZ3JlZW5m
aWVsZCwgYm9vbCBzaG9ydF9wcmVhbWJsZSk7CiBpbnQgaGlmX3NldF90eF9yYXRlX3JldHJ5X3Bv
bGljeShzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiwKIAkJCQkgaW50IHBvbGljeV9pbmRleCwgdTggKnJh
dGVzKTsKIGludCBoaWZfc2V0X21hY19hZGRyX2NvbmRpdGlvbihzdHJ1Y3Qgd2Z4X3ZpZiAqd3Zp
ZiwKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMgYi9kcml2ZXJzL3N0YWdp
bmcvd2Z4L3N0YS5jCmluZGV4IGIyYTI5YjJhYzIwYy4uZmVlYmI3YzNiZGZlIDEwMDY0NAotLS0g
YS9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93Zngvc3Rh
LmMKQEAgLTQ5OSw4ICs0OTksMjMgQEAgc3RhdGljIHZvaWQgd2Z4X2pvaW4oc3RydWN0IHdmeF92
aWYgKnd2aWYpCiBzdGF0aWMgdm9pZCB3Znhfam9pbl9maW5hbGl6ZShzdHJ1Y3Qgd2Z4X3ZpZiAq
d3ZpZiwKIAkJCSAgICAgIHN0cnVjdCBpZWVlODAyMTFfYnNzX2NvbmYgKmluZm8pCiB7CisJc3Ry
dWN0IGllZWU4MDIxMV9zdGEgKnN0YSA9IE5VTEw7CisJaW50IGFtcGR1X2RlbnNpdHkgPSAwOwor
CWJvb2wgZ3JlZW5maWVsZCA9IGZhbHNlOworCisJcmN1X3JlYWRfbG9jaygpOyAvLyBwcm90ZWN0
IHN0YQorCWlmIChpbmZvLT5ic3NpZCAmJiAhaW5mby0+aWJzc19qb2luZWQpCisJCXN0YSA9IGll
ZWU4MDIxMV9maW5kX3N0YSh3dmlmLT52aWYsIGluZm8tPmJzc2lkKTsKKwlpZiAoc3RhICYmIHN0
YS0+aHRfY2FwLmh0X3N1cHBvcnRlZCkKKwkJYW1wZHVfZGVuc2l0eSA9IHN0YS0+aHRfY2FwLmFt
cGR1X2RlbnNpdHk7CisJaWYgKHN0YSAmJiBzdGEtPmh0X2NhcC5odF9zdXBwb3J0ZWQgJiYKKwkg
ICAgIShpbmZvLT5odF9vcGVyYXRpb25fbW9kZSAmIElFRUU4MDIxMV9IVF9PUF9NT0RFX05PTl9H
Rl9TVEFfUFJTTlQpKQorCQlncmVlbmZpZWxkID0gISEoc3RhLT5odF9jYXAuY2FwICYgSUVFRTgw
MjExX0hUX0NBUF9HUk5fRkxEKTsKKwlyY3VfcmVhZF91bmxvY2soKTsKKwogCXd2aWYtPmpvaW5f
aW5fcHJvZ3Jlc3MgPSBmYWxzZTsKLQloaWZfc2V0X2Fzc29jaWF0aW9uX21vZGUod3ZpZiwgaW5m
byk7CisJaGlmX3NldF9hc3NvY2lhdGlvbl9tb2RlKHd2aWYsIGFtcGR1X2RlbnNpdHksIGdyZWVu
ZmllbGQsCisJCQkJIGluZm8tPnVzZV9zaG9ydF9wcmVhbWJsZSk7CiAJaGlmX2tlZXBfYWxpdmVf
cGVyaW9kKHd2aWYsIDApOwogCS8vIGJlYWNvbl9sb3NzX2NvdW50IGlzIGRlZmluZWQgdG8gNyBp
biBuZXQvbWFjODAyMTEvbWxtZS5jLiBMZXQncyB1c2UKIAkvLyB0aGUgc2FtZSB2YWx1ZS4KLS0g
CjIuMjguMAoK
