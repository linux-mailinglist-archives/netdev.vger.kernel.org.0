Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9264325F80B
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 12:25:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728814AbgIGKZU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 06:25:20 -0400
Received: from mail-dm6nam11on2053.outbound.protection.outlook.com ([40.107.223.53]:35584
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728716AbgIGKQi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Sep 2020 06:16:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bJfj/u9vGU4ClpGP0d7LYo/VLzPq0sCLD9xVL12wbHqGlrq6wSAzK1IPLm8miYIh/rskWLaJ5+/hMuzpZ0SoFoCc7wOAxW0kmH4x+/djD13nhTGDzwrpEgeZZwZFhiFxNtFp9xv7Rjp5L8uYJF17TDy6vONQhvOHOz05XaTKHsyq9FP5YmX6/ihfM1AgcXKy5AxK8Dt5yN8dgGnHP+BTsWCK8egkvW1RwbmgfggrMltTjZyKW/BAshHtThqJfD4EQINwTilApAMPxoht8dcJvmKZxZnUlSnbsOnsSFqn7TYhma5PrRiUmunrdjyihh9OkYez93z9o1hfzGd/kIu4rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T9kslUkyFYLokogGAq7Sj2kXuTtF4FpGls5NgcASykQ=;
 b=R2ApV7J6Fs+xTSCf3itzN3C0rEiaLKA2ZROEkBffw+u+bvYWqTMJFCwG+KkN5xOkiHSdoEUXS9ZhwE7q4t6/85bVOyUU+r0Rui5AfTFGtKao73/7Ho4Jqo3Nkl1rTDydsIvFcJhNWdvgatYRgKPxqREWKBN0w8ZD5PmGA6XYzzpepkwv3/40fvyZU/0oQcRlv5W5EYGkYG22p0QEhKige5KqjGxCQFLtWRBLi9Vvv/1klHz396dJekBij/L3q58NShVz2oH6uHyQUCWb6F0210Y2I/Q0rNHNcakzspHxhty9ptZKEBmpE8rBOkUtKYkiTFCX/ZLBFaRwSuRLEzyPuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T9kslUkyFYLokogGAq7Sj2kXuTtF4FpGls5NgcASykQ=;
 b=OdHxT+3WW30+nMc5nImSszzR/J80TCOj4SPt74Q+K109H8p43iJ9fWnVrUbXQtCvmt6Hu0zUxSQQeDwgQCFQQ31fMBi4cT8qpqeF8LLjFozS59ezBeQTLcrZaBte466txjHi7P+sW49Xs1D8J/gxBZWUGj6n9rhG10liaa+kE9Q=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SN6PR11MB2606.namprd11.prod.outlook.com (2603:10b6:805:55::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.17; Mon, 7 Sep
 2020 10:16:09 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::85c9:1aa9:aeab:3fa6]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::85c9:1aa9:aeab:3fa6%4]) with mapi id 15.20.3348.019; Mon, 7 Sep 2020
 10:16:09 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 15/31] staging: wfx: drop useless struct hif_suspend_resume_flags
Date:   Mon,  7 Sep 2020 12:15:05 +0200
Message-Id: <20200907101521.66082-16-Jerome.Pouiller@silabs.com>
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
Received: from pc-42.silabs.com (37.71.187.125) by PR0P264CA0109.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:19::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.16 via Frontend Transport; Mon, 7 Sep 2020 10:16:07 +0000
X-Mailer: git-send-email 2.28.0
X-Originating-IP: [37.71.187.125]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 74c6d5ac-56ba-44d5-9c16-08d853170a02
X-MS-TrafficTypeDiagnostic: SN6PR11MB2606:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR11MB26064557BE4B76BA6315175393280@SN6PR11MB2606.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:826;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: b1UKnD3m/5wQjv2nJaGik0Dc0k9izHx2Wd1wt+kWc7bAVKNU/cJSMsW2V+hGOzIqVC/Cs8lrFzMK2N2AkVtjqsNcPnUgH9b1tTi7bbNQrf/WHKKoCnLbVjMEPIrPmx7z2yvxy5iRion6SKXbvYj2CSwxxUujdDdMlABg/hI+vfF3taoZY0qs4AAsKZwl93vg6S1UJqE0xn4cg3N92yeYNPmT8G2nw/sJGj9gEU9AMm3cidOvfYD/OBqaArZa/S65uuG4aZA0A3EyCNwS/aZOwquvwqv5v8AZcLPS/uBTFLJ4NwZ+oGdgGkagNssWdLF6WdUVd1e7DXU42AOCz8db3g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(376002)(346002)(366004)(136003)(39850400004)(66946007)(4326008)(5660300002)(2616005)(66476007)(316002)(956004)(478600001)(54906003)(52116002)(2906002)(66556008)(1076003)(36756003)(8676002)(86362001)(6486002)(8936002)(7696005)(66574015)(83380400001)(26005)(107886003)(16526019)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: b6UmhTUO8bBeFD1J0LG6+SUFUl0hWSaAsVZZTawVpg+BgCc5rRTiiViajnrPKOVFzs45z2ncnfrw85olxghn0e5HgRU4IiUit+6i6d//RhaF3KOf68ttpzl+tunSUFiIwZ/qubAATDH7pVX59TICfuYbnU+zNFp0ILS1erxGDgbtFyClkg/0w+oyL+TgAohx9ffOmYV22w5+7Ti/BInFkujgRPPmzvuwqf+8cYEU6SKUOxqJGhV7JQJewOYxFSaZMmKoG0i3gGW0+TVHXAD8Lmw5bc7NP9cClZBCKfuLQRZiL1q98LEa1a4poMwJdYAc9fdbCbSvtqFqwS04atmE6UTnK9mcoPoKb1Um7B1IbfU+eVdtcRfESlJEEfdexLnTp4pLmpyqe1iAJkWn6Qqjs6Bu6C4l8lCnUOiB2FcWPYkTOPs7lhnzoteq36vNlsQqiVx8Q73WXIWC7Mlhrz45ASeYKvhVhY4ICiL+MK61iufyAV+zWB0JOHnQmJy7vDz2ZIjUECvIU70rX7nRPCLxehABONHjbZUojSCQyvnK2zVzISuy7IiWVtY4wgZwQGIib9gzIY/gozKJQO5v5hs8emfXeuQRHx07MlNMa668wWDqtyNs83jUR/3J3Qic7EhWErWtMl19gsxRPYVP5FRedw==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 74c6d5ac-56ba-44d5-9c16-08d853170a02
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2020 10:16:09.1850
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nSKYknctZyv5qXpPDZnw2HKrdMuw8AizLTFe4i6i+CoYx/kJ/Fa1WcUbnllzcHczvax+fB1Px54uRWVCdob5+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2606
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKU3Ry
dWN0IGhpZl9zdXNwZW5kX3Jlc3VtZV9mbGFncyBoYXMgbm8gcmVhc29uIHRvIGV4aXN0LiBEcm9w
IGl0IGFuZApzaW1wbGlmeSBhY2Nlc3MgdG8gc3RydWN0IGhpZl9pbmRfc3VzcGVuZF9yZXN1bWVf
dHguCgpTaWduZWQtb2ZmLWJ5OiBKw6lyw7RtZSBQb3VpbGxlciA8amVyb21lLnBvdWlsbGVyQHNp
bGFicy5jb20+Ci0tLQogZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfYXBpX2NtZC5oIHwgNiArLS0t
LS0KIGRyaXZlcnMvc3RhZ2luZy93ZngvaGlmX3J4LmMgICAgICB8IDYgKysrLS0tCiAyIGZpbGVz
IGNoYW5nZWQsIDQgaW5zZXJ0aW9ucygrKSwgOCBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9k
cml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl9hcGlfY21kLmggYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hp
Zl9hcGlfY21kLmgKaW5kZXggZjg2ZjZkNDkxZmIyLi40YjAxYmU2NzdlMDggMTAwNjQ0Ci0tLSBh
L2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX2FwaV9jbWQuaAorKysgYi9kcml2ZXJzL3N0YWdpbmcv
d2Z4L2hpZl9hcGlfY21kLmgKQEAgLTQ0NiwxNiArNDQ2LDEyIEBAIHN0cnVjdCBoaWZfY25mX21h
cF9saW5rIHsKIAlfX2xlMzIgc3RhdHVzOwogfSBfX3BhY2tlZDsKIAotc3RydWN0IGhpZl9zdXNw
ZW5kX3Jlc3VtZV9mbGFncyB7CitzdHJ1Y3QgaGlmX2luZF9zdXNwZW5kX3Jlc3VtZV90eCB7CiAJ
dTggICAgIHJlc3VtZToxOwogCXU4ICAgICByZXNlcnZlZDE6MjsKIAl1OCAgICAgYmNfbWNfb25s
eToxOwogCXU4ICAgICByZXNlcnZlZDI6NDsKIAl1OCAgICAgcmVzZXJ2ZWQzOwotfSBfX3BhY2tl
ZDsKLQotc3RydWN0IGhpZl9pbmRfc3VzcGVuZF9yZXN1bWVfdHggewotCXN0cnVjdCBoaWZfc3Vz
cGVuZF9yZXN1bWVfZmxhZ3Mgc3VzcGVuZF9yZXN1bWVfZmxhZ3M7CiAJX19sZTE2IHBlZXJfc3Rh
X3NldDsKIH0gX19wYWNrZWQ7CiAKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlm
X3J4LmMgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl9yeC5jCmluZGV4IGNmN2E5NTZlZjAwYS4u
Nzk4MTY3YWE0YzdmIDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl9yeC5jCisr
KyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX3J4LmMKQEAgLTIwMywxNiArMjAzLDE2IEBAIHN0
YXRpYyBpbnQgaGlmX3N1c3BlbmRfcmVzdW1lX2luZGljYXRpb24oc3RydWN0IHdmeF9kZXYgKndk
ZXYsCiAJc3RydWN0IHdmeF92aWYgKnd2aWYgPSB3ZGV2X3RvX3d2aWYod2RldiwgaGlmLT5pbnRl
cmZhY2UpOwogCWNvbnN0IHN0cnVjdCBoaWZfaW5kX3N1c3BlbmRfcmVzdW1lX3R4ICpib2R5ID0g
YnVmOwogCi0JaWYgKGJvZHktPnN1c3BlbmRfcmVzdW1lX2ZsYWdzLmJjX21jX29ubHkpIHsKKwlp
ZiAoYm9keS0+YmNfbWNfb25seSkgewogCQlXQVJOX09OKCF3dmlmKTsKLQkJaWYgKGJvZHktPnN1
c3BlbmRfcmVzdW1lX2ZsYWdzLnJlc3VtZSkKKwkJaWYgKGJvZHktPnJlc3VtZSkKIAkJCXdmeF9z
dXNwZW5kX3Jlc3VtZV9tYyh3dmlmLCBTVEFfTk9USUZZX0FXQUtFKTsKIAkJZWxzZQogCQkJd2Z4
X3N1c3BlbmRfcmVzdW1lX21jKHd2aWYsIFNUQV9OT1RJRllfU0xFRVApOwogCX0gZWxzZSB7CiAJ
CVdBUk4oYm9keS0+cGVlcl9zdGFfc2V0LCAibWlzdW5kZXJzdG9vZCBpbmRpY2F0aW9uIik7CiAJ
CVdBUk4oaGlmLT5pbnRlcmZhY2UgIT0gMiwgIm1pc3VuZGVyc3Rvb2QgaW5kaWNhdGlvbiIpOwot
CQlpZiAoYm9keS0+c3VzcGVuZF9yZXN1bWVfZmxhZ3MucmVzdW1lKQorCQlpZiAoYm9keS0+cmVz
dW1lKQogCQkJd2Z4X3N1c3BlbmRfaG90X2Rldih3ZGV2LCBTVEFfTk9USUZZX0FXQUtFKTsKIAkJ
ZWxzZQogCQkJd2Z4X3N1c3BlbmRfaG90X2Rldih3ZGV2LCBTVEFfTk9USUZZX1NMRUVQKTsKLS0g
CjIuMjguMAoK
