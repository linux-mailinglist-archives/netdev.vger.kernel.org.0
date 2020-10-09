Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0B96288FB7
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 19:14:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732488AbgJIRNm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 13:13:42 -0400
Received: from mail-eopbgr750058.outbound.protection.outlook.com ([40.107.75.58]:34017
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732717AbgJIRNi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Oct 2020 13:13:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rwb752P+D9sNjwX2VxL77q9FsS/bY49jD6trhxlb+Ri9s4Z/Ki3h7m4i+U3W/E7s51nDSvTwFhsjSSgDQNkJqLr5hfpmwuAZ352YXFTZYky+CWKZV675b1qcctJzARF78SZTJM/WOS9I1TasdkLdqraQmIO4W34iR2aoSL0lUCgyE/9GAVuyjCl3GBUYm7YEa0xjJkcoR9os6RbB2aHnBdnP9uwhYRnciGDJPJX21IaM4HQwP0ZC5VeIt/kneU4iheTWMJ4MMnP5vtFBdUA4wsEY8E86xLiOV5p49wwvpUXRkxqDXTJehfmT2VA1bJA9HyzTTFTv7S3sdkTRoLQVMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hwlTGiVBkp3Tv0OkYwphI1epijClxbMVwWdCBhhS5IM=;
 b=ijKOMyeBgEu0m9DsgkucO2GVQEAHow13+eF/L9hYpl9HYH4jsCBGfp5fdj5rT+TBkmXmltsF6SQSH13IW4cniP48bNSe3nFV5pfGdFD5I8wjLDJTKvm/6vKM7s4OYXGlWZFZwKN56h0yvB3p12CsRfqAKBPx82Rryzo7GVemnIvkpVGx7oLMLExLOMTa2hT9XxIffyJA3AiD4aAT8YB1QhV/gLTmZbB9V7J6M/W6HA5bxV/hUZ1Pk+RDz8zWQTXMgfE92QWz0J/Jwcn9G8X9c4XmhIF13AENludyclXtuIMyPs3fICV4yhq3/1eNBjHoV1eeydxO36gnyujy/nM26g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hwlTGiVBkp3Tv0OkYwphI1epijClxbMVwWdCBhhS5IM=;
 b=A7LG23S61hsjVb0Jbux9RdnJEk0g3imszd6FADAoxnxLjMWV5crxXCewoyjU4enV2Pak3yHqwe9w925lIYVnzT8EHLRCrV/NRZuU0GdudTMHy3Eb8wPdXjrYBH2uF7qZheA7adg4NiqtEVGuntzy0rgfOD90YDmpBR/kcWajd8Y=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SN6PR11MB3087.namprd11.prod.outlook.com (2603:10b6:805:d3::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.32; Fri, 9 Oct
 2020 17:13:35 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::4f5:fbe5:44a7:cb8a]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::4f5:fbe5:44a7:cb8a%5]) with mapi id 15.20.3455.024; Fri, 9 Oct 2020
 17:13:35 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 7/8] staging: wfx: drop unicode characters from strings
Date:   Fri,  9 Oct 2020 19:13:06 +0200
Message-Id: <20201009171307.864608-8-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201009171307.864608-1-Jerome.Pouiller@silabs.com>
References: <20201009171307.864608-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-Originating-IP: [82.67.86.106]
X-ClientProxiedBy: SA9PR10CA0004.namprd10.prod.outlook.com
 (2603:10b6:806:a7::9) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.silabs.com (82.67.86.106) by SA9PR10CA0004.namprd10.prod.outlook.com (2603:10b6:806:a7::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.24 via Frontend Transport; Fri, 9 Oct 2020 17:13:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 691305df-fc06-448b-1f97-08d86c76a816
X-MS-TrafficTypeDiagnostic: SN6PR11MB3087:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR11MB30873F4502D5389F88283BC893080@SN6PR11MB3087.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:813;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 96RoKKSvw6bMrdGOA/NABUuMVc/D036tG2qVt0nlWrTZIQ/Qo5vI7nu8fHBDEP5KqSgAaZxXTyafYJJaljLKLqQmdNqzZjdCFfbPCmm+SmYohhuRXz1uqU38FP37nWchQ7htRma8c3HFv0e0eBE9SnX+VQm1ZyXYXzMg3K961hxAben5R0jkYgMH0nTkcZPnHFD6v5ZL/UTE3K3Oqx+yHq61bVjEQhRX09iq1/Rfy2XvuGbV1qDFuNvB4j8zA7cpPcdnqJb/Y41O78I1PGRHVE/5S1xjsJ9R4ix2lUwNOAdlsB+SYdOeMirl13yR0nUG4p65l9S0KACNH/ZgR6FAuA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39850400004)(136003)(376002)(346002)(366004)(7696005)(1076003)(2616005)(66476007)(36756003)(66556008)(956004)(478600001)(2906002)(6666004)(5660300002)(54906003)(316002)(6486002)(4326008)(86362001)(8676002)(66946007)(8936002)(52116002)(107886003)(66574015)(186003)(26005)(16526019)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: cIGlgG1M5mslDldp+6mMs4SuFIgTKTuVZ+EYg3LLgSPUQSx/ECIOD7HF8n5R1ZRfdv0E/L80rmvcO7+JAFjBNzdlWXPHH1euE3vTKsNDiOtCrINUstNA6lUzFdJv9sKrz3mKhYTDXHJ8lRdRrYjVwQpum4M7uUbvJg0lGEJnvOWWLo8vLFEkN+z15jPP36zaQVgK8g4GZEPP7/BTPOqxUBX43kHHq+QdzBad3jPFUvEN7X6luBbjmrV4bOnHlJTzmRELpCY14ael7KX47bCIWVBYbDygY7DTH2k0fRfKsbP18/VJwfTDYk6HwRi2tksjInDkIcx5u8H0DvYcz9+gtTFVLNdUZ1Lntp99XsT4+ENwaOCDlIgAKEhmplDT9n9UIYZqHeHadN6Al+s8z7VkvIVTQmChTE7vEVHT901cvudp35g5qCLreWfXxPclSZHedKynNMzJxeVlmhYM9SHur2IXuPrHba4McbNalBFE2R79RsGTY/PSklHfQo7mI8Yy/myrr/VQcEnID4OIBXgG42KroFLonh82uu3MY3lM8RMmUZGzP8Sx0ODL3GBac7wk59Y/oK4FUwgNzCWFZShbZhLx4YvlECTA9mU+AZt02yPq6h3438V6xShoay8koos4j+4tuFKxtxFBMgf3DAT0XA==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 691305df-fc06-448b-1f97-08d86c76a816
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Oct 2020 17:13:35.7496
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fRBtOswuc8J64z9/V8bjh3896boXCc3Z8uvu1OUYOlsmCMielEYjEMZu7P+dt+cQPbubI7BMAZFG/TvreF2Ayg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3087
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKU21h
dGNoIGNvbXBsYWluczoKCiAgaGlmX3J4LmM6MjM1IGhpZl9nZW5lcmljX2luZGljYXRpb24oKSB3
YXJuOiBmb3JtYXQgc3RyaW5nIGNvbnRhaW5zIG5vbi1hc2NpaSBjaGFyYWN0ZXIgJ1x4YzInCiAg
aGlmX3J4LmM6MjM1IGhpZl9nZW5lcmljX2luZGljYXRpb24oKSB3YXJuOiBmb3JtYXQgc3RyaW5n
IGNvbnRhaW5zIG5vbi1hc2NpaSBjaGFyYWN0ZXIgJ1x4YjAnCiAgIDIzNCAgICAgICAgICAgICAg
ICAgIGlmICghd2Z4X2FwaV9vbGRlcl90aGFuKHdkZXYsIDEsIDQpKQogICAyMzUgICAgICAgICAg
ICAgICAgICAgICAgICAgIGRldl9pbmZvKHdkZXYtPmRldiwgIlJ4IHRlc3Qgb25nb2luZy4gVGVt
cGVyYXR1cmU6ICVkwrBDXG4iLAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgXgogICAyMzYg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGJvZHktPmRhdGEucnhfc3RhdHMuY3Vy
cmVudF90ZW1wKTsKClNvLCByZXBsYWNlIHRoZSB1bmljb2RlIGNoYXJhY3Rlci4KClJlcG9ydGVk
LWJ5OiBEYW4gQ2FycGVudGVyIDxkYW4uY2FycGVudGVyQG9yYWNsZS5jb20+ClNpZ25lZC1vZmYt
Ynk6IErDqXLDtG1lIFBvdWlsbGVyIDxqZXJvbWUucG91aWxsZXJAc2lsYWJzLmNvbT4KLS0tCiBk
cml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl9yeC5jIHwgMiArLQogMSBmaWxlIGNoYW5nZWQsIDEgaW5z
ZXJ0aW9uKCspLCAxIGRlbGV0aW9uKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dm
eC9oaWZfcnguYyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX3J4LmMKaW5kZXggZjk5OTIxZTc2
MDU5Li41NmE1Zjg5MTQ0N2IgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX3J4
LmMKKysrIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfcnguYwpAQCAtMjQ2LDcgKzI0Niw3IEBA
IHN0YXRpYyBpbnQgaGlmX2dlbmVyaWNfaW5kaWNhdGlvbihzdHJ1Y3Qgd2Z4X2RldiAqd2RldiwK
IAkJbXV0ZXhfbG9jaygmd2Rldi0+cnhfc3RhdHNfbG9jayk7CiAJCS8vIE9sZGVyIGZpcm13YXJl
IHNlbmQgYSBnZW5lcmljIGluZGljYXRpb24gYmVzaWRlIFJ4U3RhdHMKIAkJaWYgKCF3ZnhfYXBp
X29sZGVyX3RoYW4od2RldiwgMSwgNCkpCi0JCQlkZXZfaW5mbyh3ZGV2LT5kZXYsICJSeCB0ZXN0
IG9uZ29pbmcuIFRlbXBlcmF0dXJlOiAlZMKwQ1xuIiwKKwkJCWRldl9pbmZvKHdkZXYtPmRldiwg
IlJ4IHRlc3Qgb25nb2luZy4gVGVtcGVyYXR1cmU6ICVkIGRlZ3JlZXMgQ1xuIiwKIAkJCQkgYm9k
eS0+ZGF0YS5yeF9zdGF0cy5jdXJyZW50X3RlbXApOwogCQltZW1jcHkoJndkZXYtPnJ4X3N0YXRz
LCAmYm9keS0+ZGF0YS5yeF9zdGF0cywKIAkJICAgICAgIHNpemVvZih3ZGV2LT5yeF9zdGF0cykp
OwotLSAKMi4yOC4wCgo=
