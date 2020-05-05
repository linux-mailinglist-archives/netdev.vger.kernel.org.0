Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 631F71C55B6
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 14:39:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729211AbgEEMjH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 08:39:07 -0400
Received: from mail-eopbgr770049.outbound.protection.outlook.com ([40.107.77.49]:46720
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729075AbgEEMjE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 May 2020 08:39:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YszpHvSDsg8pNtCokNrZkXBaebzT4rfRjGZLB7UJpz0lbKzYXRZW1bZgpEe3PbhhWUJrbQpLkHm9OLhymfRIYNIdd5RY5Ysz2SwvKz9Y9w1XTnxuTHdXfOD0c7K8Q7PCVHgyEVEaET8aYux+r2QelJcVxy/AAvER0tkc2ME2sguy7WIEYPL9/LRI5+8eqXIrv0mgmX8unGtcOz8eHLp/b9BapK3VzTzXK+iHtnVlDRfy4WcO+2ooMAhWYw90NJnR5AfOs7zog2pgkE7fnCZ2LMY14BUXNftkHLsh2csdvZkO6AA0tphGmR6RTlCiodIHATEQaLb13IbLfncPgdnaew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hvVYFq5Ib859CrVaN8bCL+/Tl/BK9dvkNhn9GJuSDnw=;
 b=BXhhKsY0CoKuQ5O53ipP8mmrqLVc6zQB3Eu+vrCe5IxJ/8DRqBIKrpWdL0pg2T7xLLnY4lrYXnXk2w5Ipr2qcDY/ZNmdI0nPusDw7bZpuOB7SH8Uyu8RpXfzxqGS46om7//3Q8xiBd0QK9wvQeCN/fntonskYCQwadNBFPznDjjVDcaXWjnZbDcBEfBEU+BZzUhkejQThsPEmSBSlLAFPMi9jfTZmbav0ar6VqfrE5eTMFHd31cKi1d4iRxQja++OsjcRndqFpj6xHOxtobTIj6/jWRYM9gIEHo2N/gCQta6toVTZSPaD3MMCdishy4hygSMo3Ch8DKJoH1FPiVeBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hvVYFq5Ib859CrVaN8bCL+/Tl/BK9dvkNhn9GJuSDnw=;
 b=YcY3khg6CjJgz5H4a1wUPr5uSO6uYrCDKJrFhB1CCjxNa8aK3ky7mGZLanhbJ92G2S406U3NaS4/qpBT6Y0gZ6dZtJ3JXMc2Dz7kGrlr8nxsT37L+XWDyMjlDKo9rIW/5DDj9kXKxVWpNK9JxRMy2beJ2GD4DvQ6CR/si9iFKHE=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from MWHPR11MB1775.namprd11.prod.outlook.com (2603:10b6:300:10e::14)
 by MWHPR11MB2046.namprd11.prod.outlook.com (2603:10b6:300:28::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20; Tue, 5 May
 2020 12:38:44 +0000
Received: from MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::81d5:b62b:3770:ffbe]) by MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::81d5:b62b:3770:ffbe%10]) with mapi id 15.20.2958.030; Tue, 5 May 2020
 12:38:44 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 15/15] staging: wfx: use kernel types instead of c99 ones
Date:   Tue,  5 May 2020 14:37:57 +0200
Message-Id: <20200505123757.39506-16-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200505123757.39506-1-Jerome.Pouiller@silabs.com>
References: <20200505123757.39506-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PR3P189CA0022.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:102:52::27) To MWHPR11MB1775.namprd11.prod.outlook.com
 (2603:10b6:300:10e::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.home (2a01:e35:2435:66a0:1265:30ff:fefd:6e7f) by PR3P189CA0022.EURP189.PROD.OUTLOOK.COM (2603:10a6:102:52::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20 via Frontend Transport; Tue, 5 May 2020 12:38:42 +0000
X-Mailer: git-send-email 2.26.1
X-Originating-IP: [2a01:e35:2435:66a0:1265:30ff:fefd:6e7f]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ea508385-2c43-4942-3880-08d7f0f13fcf
X-MS-TrafficTypeDiagnostic: MWHPR11MB2046:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR11MB2046D3CCBB7A851A4A45048993A70@MWHPR11MB2046.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:843;
X-Forefront-PRVS: 0394259C80
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qYsmir0SyA7LPx+6v/QaSJczhRDSckzNtzmoCgf95W0uUAzjHiBk6nTdqWpsitEPFs0/M1GV2uKM8oRHBP2RSZsAo9ATk731iq8Sr8fhStxT29KjJ+s8CRKiCmgTsh9hI4QZ30P7wKCkXy8u/gOFOfAaIFSmL8BkIjgSw8o4bUxsrcsd09mKUwtu67Tue+5ZzHrzH12AfeStAS5lRww0akfMUdDoVZC0Njr7FjX4kIzMMzJb7Egd5BHXILUWJ59HkJ1d53rDsK7qhO9LNFYVAUYl/AHfdB8GGw4hHJSnrnf+1phpCkZabHQxa6hFOxCKrVMZVBhah6AT0joahpOmaS+rvBGOa5TCA0yCPVnINoacWHLxqsJZO9/b56aPcX7X1chMneGz8iJ3gZk3M4+hPLRunbh5P1+xMLRfTL3ZFuNN5vTNHoG/awNxZl+VmGHZ7VoEgknQYpBEg/p7VJ0WdlqLOpOsRoehYtg0acDsiNzspHtXsOPL7ukuzAAUivr2O2EEftJX52FncM1490r1Tg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1775.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(396003)(366004)(346002)(39850400004)(136003)(376002)(33430700001)(2906002)(36756003)(52116002)(86362001)(5660300002)(6486002)(1076003)(8676002)(66574012)(8936002)(6666004)(107886003)(2616005)(66476007)(66946007)(16526019)(186003)(66556008)(6512007)(8886007)(478600001)(4326008)(6506007)(33440700001)(54906003)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: vIIY5hbFvcOb8SdBu/psX0WESD7zKVGPJRpf6al44MYh4u7VDpr/CMiQupsKbOJbAhkBz9iEqdvfDuNtxnbaHyNtaUteWdZ5N6igZCXKXp0h2Dh9ktDwDouKGq66vpjL+W/ViN1Kdo9auGdhVRjhK1berwquPYymzP4wYNWIR8QFHWXFdrfly7yIoRkziO1XsGFeF6bZzUBFGQcH4cqbpytONCl2ELLdEOu4vjgu5S48EH1A7DNyTwv1H7CQk+qvlSHBNKDB5XKkaCT9WxmJWF0vTL2yJ85pXKd/DXxhrg76xQPAoSTdX/E19wwI3LLw36uiQRdZ1yxLZH50TnadabOuz6vqGN1umKhosZBgaz6l7EOFWImsv6oAi/1DOL0hPIPUHnQNbpwfLsnWnDxsj0scirhIiP7+sER/6U+ds4jkrEkOANx5idyeg0c9+FL1FPUWaAQW9jHW4dQatamJk+7kEYu43iuZIOsyvQgTf02HwkUBuzywDeSmq/9K2SSJL4kHRYHrBsRkUnshvixWCC6GIvqY7hsMxkz1ZWg57/fv+AA+9XfSQA40OK48fCmFxNee6U5veielZ/iXQ3WcKUv6Te6SKgVvXUDXnphyci0oA6uWP7x4B19VLeFoqRzPy20AFpV3dansCB0IyjVeByCBCiQsOCO38HOEyPkpvo47Y/k9SqtExck+II2jFpqZ8H0w4vO7R6/i4WQffRc+rMhv13fFOznqCo5k+QkOUxByH/Sxh2oE+5wn4Ga7laT3sq1BadVU5vyWGsFpYyiWyDVKxiNajCIemsjuSXkvCn9SO15ERj981yw3TN5mK8fgNPuqRlSAqdjaU3tGWp/Zm/VM+/FqlNJZnB9gJ87P3JQ=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea508385-2c43-4942-3880-08d7f0f13fcf
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2020 12:38:44.6933
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: R6FH7byR2VblTxADzAnSHx0zHvN2obpf/yVYOT9rtp3QKxcOnErD8fBjuuoAqSf73t5lyBHrVFuDtUD+3JAx3w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB2046
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVGhl
IGtlcm5lbCBjb2Rpbmcgc3R5bGUgcHJvbW90ZXMgdGhlIHVzZSBvZiBrZXJuZWwgdHlwZXMgKHU4
LCB1MTYsIHUzMiwKZXRjLi4uKSBpbnN0ZWFkIG9mIHRoZSBDOTkgb25lcy4KClNpZ25lZC1vZmYt
Ynk6IErDqXLDtG1lIFBvdWlsbGVyIDxqZXJvbWUucG91aWxsZXJAc2lsYWJzLmNvbT4KLS0tCiBk
cml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl90eC5jICAgICB8IDUgKystLS0KIGRyaXZlcnMvc3RhZ2lu
Zy93ZngvaGlmX3R4X21pYi5jIHwgMiArLQogZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfdHhfbWli
LmggfCAyICstCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L21haW4uYyAgICAgICB8IDQgKystLQogZHJp
dmVycy9zdGFnaW5nL3dmeC9tYWluLmggICAgICAgfCAyICstCiA1IGZpbGVzIGNoYW5nZWQsIDcg
aW5zZXJ0aW9ucygrKSwgOCBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdp
bmcvd2Z4L2hpZl90eC5jIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfdHguYwppbmRleCBiMDgz
ZmNhY2UzMDMuLjU4MDEzYzAxOTE5MiAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9o
aWZfdHguYworKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl90eC5jCkBAIC00OTUsNyArNDk1
LDcgQEAgaW50IGhpZl91cGRhdGVfaWVfYmVhY29uKHN0cnVjdCB3ZnhfdmlmICp3dmlmLCBjb25z
dCB1OCAqaWVzLCBzaXplX3QgaWVzX2xlbikKIH0KIAogaW50IGhpZl9zbF9zZW5kX3B1Yl9rZXlz
KHN0cnVjdCB3ZnhfZGV2ICp3ZGV2LAotCQkJIGNvbnN0IHVpbnQ4X3QgKnB1YmtleSwgY29uc3Qg
dWludDhfdCAqcHVia2V5X2htYWMpCisJCQkgY29uc3QgdTggKnB1YmtleSwgY29uc3QgdTggKnB1
YmtleV9obWFjKQogewogCWludCByZXQ7CiAJc3RydWN0IGhpZl9tc2cgKmhpZjsKQEAgLTUyOSw4
ICs1MjksNyBAQCBpbnQgaGlmX3NsX2NvbmZpZyhzdHJ1Y3Qgd2Z4X2RldiAqd2RldiwgY29uc3Qg
dW5zaWduZWQgbG9uZyAqYml0bWFwKQogCXJldHVybiByZXQ7CiB9CiAKLWludCBoaWZfc2xfc2V0
X21hY19rZXkoc3RydWN0IHdmeF9kZXYgKndkZXYsCi0JCSAgICAgICBjb25zdCB1aW50OF90ICpz
bGtfa2V5LCBpbnQgZGVzdGluYXRpb24pCitpbnQgaGlmX3NsX3NldF9tYWNfa2V5KHN0cnVjdCB3
ZnhfZGV2ICp3ZGV2LCBjb25zdCB1OCAqc2xrX2tleSwgaW50IGRlc3RpbmF0aW9uKQogewogCWlu
dCByZXQ7CiAJc3RydWN0IGhpZl9tc2cgKmhpZjsKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2lu
Zy93ZngvaGlmX3R4X21pYi5jIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfdHhfbWliLmMKaW5k
ZXggNmZkZGU1YTRjOWExLi42NTM4MWIyMjQzN2UgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2lu
Zy93ZngvaGlmX3R4X21pYi5jCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX3R4X21pYi5j
CkBAIC0yMTUsNyArMjE1LDcgQEAgaW50IGhpZl9zZXRfYXNzb2NpYXRpb25fbW9kZShzdHJ1Y3Qg
d2Z4X3ZpZiAqd3ZpZiwKIH0KIAogaW50IGhpZl9zZXRfdHhfcmF0ZV9yZXRyeV9wb2xpY3koc3Ry
dWN0IHdmeF92aWYgKnd2aWYsCi0JCQkJIGludCBwb2xpY3lfaW5kZXgsIHVpbnQ4X3QgKnJhdGVz
KQorCQkJCSBpbnQgcG9saWN5X2luZGV4LCB1OCAqcmF0ZXMpCiB7CiAJc3RydWN0IGhpZl9taWJf
c2V0X3R4X3JhdGVfcmV0cnlfcG9saWN5ICphcmc7CiAJc2l6ZV90IHNpemUgPSBzdHJ1Y3Rfc2l6
ZShhcmcsIHR4X3JhdGVfcmV0cnlfcG9saWN5LCAxKTsKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3Rh
Z2luZy93ZngvaGlmX3R4X21pYi5oIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfdHhfbWliLmgK
aW5kZXggYmNlMzVlYjdlYWEwLi44NjY4M2RlN2RlN2MgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3Rh
Z2luZy93ZngvaGlmX3R4X21pYi5oCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX3R4X21p
Yi5oCkBAIC0zNiw3ICszNiw3IEBAIGludCBoaWZfc2V0X2Jsb2NrX2Fja19wb2xpY3koc3RydWN0
IHdmeF92aWYgKnd2aWYsCiBpbnQgaGlmX3NldF9hc3NvY2lhdGlvbl9tb2RlKHN0cnVjdCB3Znhf
dmlmICp3dmlmLAogCQkJICAgICBzdHJ1Y3QgaWVlZTgwMjExX2Jzc19jb25mICppbmZvKTsKIGlu
dCBoaWZfc2V0X3R4X3JhdGVfcmV0cnlfcG9saWN5KHN0cnVjdCB3ZnhfdmlmICp3dmlmLAotCQkJ
CSBpbnQgcG9saWN5X2luZGV4LCB1aW50OF90ICpyYXRlcyk7CisJCQkJIGludCBwb2xpY3lfaW5k
ZXgsIHU4ICpyYXRlcyk7CiBpbnQgaGlmX3NldF9tYWNfYWRkcl9jb25kaXRpb24oc3RydWN0IHdm
eF92aWYgKnd2aWYsCiAJCQkgICAgICAgaW50IGlkeCwgY29uc3QgdTggKm1hY19hZGRyKTsKIGlu
dCBoaWZfc2V0X3VjX21jX2JjX2NvbmRpdGlvbihzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiwKZGlmZiAt
LWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93ZngvbWFpbi5jIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9t
YWluLmMKaW5kZXggMThjOTZiODJjNjZlLi4yNWQ3MGViZTk5MzMgMTAwNjQ0Ci0tLSBhL2RyaXZl
cnMvc3RhZ2luZy93ZngvbWFpbi5jCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvbWFpbi5jCkBA
IC0yMDMsNyArMjAzLDcgQEAgc3RydWN0IGdwaW9fZGVzYyAqd2Z4X2dldF9ncGlvKHN0cnVjdCBk
ZXZpY2UgKmRldiwKIH0KIAogLyogTk9URTogd2Z4X3NlbmRfcGRzKCkgZGVzdHJveSBidWYgKi8K
LWludCB3Znhfc2VuZF9wZHMoc3RydWN0IHdmeF9kZXYgKndkZXYsIHVuc2lnbmVkIGNoYXIgKmJ1
Ziwgc2l6ZV90IGxlbikKK2ludCB3Znhfc2VuZF9wZHMoc3RydWN0IHdmeF9kZXYgKndkZXYsIHU4
ICpidWYsIHNpemVfdCBsZW4pCiB7CiAJaW50IHJldDsKIAlpbnQgc3RhcnQsIGJyYWNlX2xldmVs
LCBpOwpAQCAtMjUyLDcgKzI1Miw3IEBAIHN0YXRpYyBpbnQgd2Z4X3NlbmRfcGRhdGFfcGRzKHN0
cnVjdCB3ZnhfZGV2ICp3ZGV2KQogewogCWludCByZXQgPSAwOwogCWNvbnN0IHN0cnVjdCBmaXJt
d2FyZSAqcGRzOwotCXVuc2lnbmVkIGNoYXIgKnRtcF9idWY7CisJdTggKnRtcF9idWY7CiAKIAly
ZXQgPSByZXF1ZXN0X2Zpcm13YXJlKCZwZHMsIHdkZXYtPnBkYXRhLmZpbGVfcGRzLCB3ZGV2LT5k
ZXYpOwogCWlmIChyZXQpIHsKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93ZngvbWFpbi5o
IGIvZHJpdmVycy9zdGFnaW5nL3dmeC9tYWluLmgKaW5kZXggYTBmMzdjOGNlM2RmLi5mODMyY2U0
MDlmZGEgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93ZngvbWFpbi5oCisrKyBiL2RyaXZl
cnMvc3RhZ2luZy93ZngvbWFpbi5oCkBAIC00MSw2ICs0MSw2IEBAIHZvaWQgd2Z4X3JlbGVhc2Uo
c3RydWN0IHdmeF9kZXYgKndkZXYpOwogc3RydWN0IGdwaW9fZGVzYyAqd2Z4X2dldF9ncGlvKHN0
cnVjdCBkZXZpY2UgKmRldiwgaW50IG92ZXJyaWRlLAogCQkJICAgICAgIGNvbnN0IGNoYXIgKmxh
YmVsKTsKIGJvb2wgd2Z4X2FwaV9vbGRlcl90aGFuKHN0cnVjdCB3ZnhfZGV2ICp3ZGV2LCBpbnQg
bWFqb3IsIGludCBtaW5vcik7Ci1pbnQgd2Z4X3NlbmRfcGRzKHN0cnVjdCB3ZnhfZGV2ICp3ZGV2
LCB1bnNpZ25lZCBjaGFyICpidWYsIHNpemVfdCBsZW4pOworaW50IHdmeF9zZW5kX3BkcyhzdHJ1
Y3Qgd2Z4X2RldiAqd2RldiwgdTggKmJ1Ziwgc2l6ZV90IGxlbik7CiAKICNlbmRpZgotLSAKMi4y
Ni4xCgo=
