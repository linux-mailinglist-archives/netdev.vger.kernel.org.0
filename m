Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15FC933B459
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 14:28:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231506AbhCON1Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 09:27:25 -0400
Received: from mail-co1nam11on2080.outbound.protection.outlook.com ([40.107.220.80]:9473
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231213AbhCON0Z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Mar 2021 09:26:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OiwvgeDsS7tYjy/STDuylOBK7zPsB09kIuDBHP15QZuRUcBveL7M7MDgqFcdYpZpxB86b//TegnxVF2g3OB3DQJV08cZxhPocBUBkwP+nZANByBC2EZ2KjBuvS5yXVgvIUOfUOxAe1CPNuHvzqlxp7XF2X1T+8jfZGOu1QP2wH8i7y15/mxmY6sxeLvDGvfTuRqJ4fgi/I+ENZSutRoSLw4aXMZ16tOBY9BuHx5qy7eHjSzNqrFnb0DvnFn+/sfHY1E1ur/bc4NG4UBszNXO8hMBMoGZgiwinHWv/YsgGDRchRGny5kCGppnp8L+OWKUPrYFha5G7P9sjmsPeVnZow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XLOlILZHl1+swJSIwchSBtKnDHyJG/1pxSDCPiyVRmU=;
 b=bno8I/uVsCZxswNxz57VbvmWZdMAnj4qhA5pdeBoN2d2qGm+VX95TKSPN9MC07hqOvyHH+CWxq5/mC7+MGXwO00foYj2fFu6HiIHeiOFs69ZDQmctkBG64bXlUWfwD+SKKu7Hs/7i6xEo2HhaJ1fdqSUCzNnb7pM9eenJXXgwr8+oI+SbfmkuCSR1t5AVVvD9eluLcyRxFU1yu322AZjfarCMA44R2WBPqOn/DMUn/kwDHRU4AGyZE44vFLf82WSSSFqwScYb3fhpTvwYi8F0tXEfhopTinOz5PEDr8mqzFHaIjdKD3wAOEApjQlb2J3mC7vF0cfzXQSXZ/OZQO+jQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XLOlILZHl1+swJSIwchSBtKnDHyJG/1pxSDCPiyVRmU=;
 b=QSQm0TiHeDHZspswo5JuxbiLXFv6WE1PuDd3hcYB80IV/XOWfxg06guNJ//jSGlODpHfA+UUU4JXghgYEY96ZpTwz2zb6hvRuT+hIGaFCs4JAeD6VzJ/CzNcvqSfkr7+khGU5FpsQCT9uvd+r8PMbKhA0BsBnNZEOM5C/Aj/csY=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SN6PR11MB3216.namprd11.prod.outlook.com (2603:10b6:805:c1::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32; Mon, 15 Mar
 2021 13:26:17 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::41bc:5ce:dfa0:9701]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::41bc:5ce:dfa0:9701%7]) with mapi id 15.20.3933.032; Mon, 15 Mar 2021
 13:26:17 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        linux-mmc@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH v5 20/24] wfx: add scan.c/scan.h
Date:   Mon, 15 Mar 2021 14:24:57 +0100
Message-Id: <20210315132501.441681-21-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315132501.441681-1-Jerome.Pouiller@silabs.com>
References: <20210315132501.441681-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-Originating-IP: [2a01:e35:2435:66a0:544b:f17b:7ae8:fb7]
X-ClientProxiedBy: SN4PR0801CA0014.namprd08.prod.outlook.com
 (2603:10b6:803:29::24) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.silabs.com (2a01:e35:2435:66a0:544b:f17b:7ae8:fb7) by SN4PR0801CA0014.namprd08.prod.outlook.com (2603:10b6:803:29::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32 via Frontend Transport; Mon, 15 Mar 2021 13:26:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 523690e2-d3e2-47e3-d14e-08d8e7b5ea12
X-MS-TrafficTypeDiagnostic: SN6PR11MB3216:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR11MB3216071827FA30537F9EA68E936C9@SN6PR11MB3216.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3044;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rE4sdzf78fiml24FMwRqx2m2sI3oFsYFqp8KNs3r3iuUgrwFJ1Y5Qmdp0ElzrCHLWkE5G6fa1WgiO8v6B2/vr3fS+wzSroXJEYwj4XjPLT4rALMTbgot7yhvFVsju5h+FIAc+CTzjLZ7RzpLAkVHDu2Cex0bVDdFZbLY0s/sQ5DZdJ/3FOsISBTTh/s/ywH+OgXUTWxnZDDMxQQP3SHAaT1y1tUkr7uAhU5qbdeIASfwN7IihR4RIM3iuHmrS0S6omPCyaH0mKTtNXBoeXeNRT0uIZnYWZl/KWILfjnsGZDXUDAaWbyfUDZkY2L7wGlysLE/APVMsTIAn9kbmnjbvMwAMwOvCj3JFBQy2QatbNQU31f2o85DEW2TxdUXWkH5g2kgg00ULWZGq+7USl6UmAmIVKoBrqauaG9c6Qy+sfDb90XnLNGM2MWFiW6puXhH61gDWbekzvfehMrSg6T+SM8Crh4iU19x5SvxjWiFsIC7U4F7cSNN+qvzVAh24fQImiHq3PGdOtAzSpmdXVnZyo5En2zXcza1JOSri7cfKDdhiDc6tl6mau+buwBfd6oN
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(396003)(366004)(39850400004)(136003)(86362001)(107886003)(2616005)(186003)(1076003)(4326008)(316002)(66556008)(478600001)(8676002)(66476007)(6486002)(7696005)(5660300002)(66946007)(2906002)(54906003)(83380400001)(6666004)(8936002)(36756003)(52116002)(7416002)(66574015)(16526019);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?Qk8wSjBvbUJ2OXpFbnZNZmhLT3RobGxSOWlraEhZcnlhL0JWUVhFbFpaWnpE?=
 =?utf-8?B?cWt1NS9RTDNXN1ptM2V2bk5hTjZwR2NJUmhBaHFwWkdFNXI3cVVhaEYzYlZz?=
 =?utf-8?B?Tlk0QXR1djZRM0FHUkh4N3A5Z3B0WFZsNC9FQWdtbmdURWFKUmZvdEdxaEV2?=
 =?utf-8?B?RWJ1UmtMUUZqZ1NiUTE1ekl1eEtERXhGUzkzcngxcnFESWY5bUJWVC9NSy9q?=
 =?utf-8?B?WFN6QVZrbWs4VFFaS3RWVTQvNzJIY3RzL0RtcHJvbGxycUZMSDhNb0JFbUhN?=
 =?utf-8?B?WituU25WZlREclhxNmlmZGE1c0t5Z05yRlNiRU11ODVjMC9RVGtzR2dYQ1dp?=
 =?utf-8?B?NmxGVHRRQVVFMmFxRmNqU0h1aSt0UFBnWHRRd2lDZzlBdloxbVp2TkwzLzFz?=
 =?utf-8?B?REIwMHpKM1pYTWQxaDIzdmJGUGFVWDhMMnR0ZU1YYkI2S3FIMEZTUlRoOTlp?=
 =?utf-8?B?ZFpPNnZDQ3lGVjVXdWpSY2JoaEpsK1ZUSEpBa0ViUjhGUlQxM1ZwdDhGWUxy?=
 =?utf-8?B?cXlBL2dMMnZncld3aXB3QVJ3dzVYWFAvblozczdkYWFVMVhDaUNlT0tOakZh?=
 =?utf-8?B?KzhWSnJnWDY0MlQ4UGRWUGJ6UjRwbkxOd1VsQ2NjZEZXMlY0Z3lzUjVwQUV6?=
 =?utf-8?B?Mk8zMHNLeFY2THh4dEdtNU5XRlJqNHBiRkNsaU5vOFhkM3l2dm03aFNjV05q?=
 =?utf-8?B?dkFQOHpUaVJlKzBjVW9RMjcxS1JJamFsbTVmSWIwZHozbGpqTElLM1pZVjVV?=
 =?utf-8?B?Z25na09rZ2lvRUVQUVAyRjlRN3BoOFFxTjBKVW5mUWYxeHFQanhlMDJqMWRw?=
 =?utf-8?B?Y3EyZnNabUoyWm4rSVUzSmsySHp2MDZNa0kzUG5zeEtjVDVJekN0VjNNb2ZE?=
 =?utf-8?B?TGlpUTBQU1ZnNXcxOGVOeElsYzhOMDZ5a3JRc1Z2T09INkdwd05wMVVKMTRX?=
 =?utf-8?B?MHZWcmFZQmNNbUdtbndPVm5BOE1iemt4ampORS9BVFVFa3FSRUtDczFHTzNF?=
 =?utf-8?B?OVRnSDNHRHlEUUtsQnJQbU9GTzgwV0RLNlVIWHdPaml6VjJMSVZmbFdzU0hq?=
 =?utf-8?B?WlRlR0N4WkpvZHI2SkFxdkNxbHlCbkhyQk9EZnUvS00yWVZKTXNDU21VOVN3?=
 =?utf-8?B?VlNhOHg2eXJqTDRjODRVZ2RWWjJFeCtadHhEMk9BaGtiS3JtZGFabVFIdm1E?=
 =?utf-8?B?UUtCZG9DUWF4TVZETjJwaXVhblNXR2t4dGhKNmNOcmZlT2h1YktiWS9paDdB?=
 =?utf-8?B?MnNmM0RHV0hvblIwbEZJMWpYRmlqVVB6eUZWNkM2ZERtT3ZJZktzZ0puRHI3?=
 =?utf-8?B?dnpRZGZuTDR4Mzh1d0gyOTExMkpIRmI2ZTYwVUk5SitIeHd3RWR5U2ZRbkg2?=
 =?utf-8?B?a1UrZWQycFl3bGVWNldSQmZhZW9LaHRFcDBnUGxRZ2xXTVlrZjlmeXVQOXlj?=
 =?utf-8?B?eTNVSGZ0TVkzeHptYTB5S2dEVmQ4S0QvV0hudWtXR1hsOEJ1STkrV3ltd0pv?=
 =?utf-8?B?L1pLcWhRK2VqT0xzTEozMDJMSnd3ZHphclMxdENUTFhQRGkxbEV2UGM4Zmpz?=
 =?utf-8?B?bzdjNCtaT0NsdEx0am43YWVOUDdmUlFPZkJMUDNWcEhEWWMzR29LQXFZZzJT?=
 =?utf-8?B?WEFsUnM4d1c5eUVBaUFWL1RBdUNXSGNHQWM1Wm55OHQ2bzArc0U2S0g4K3lx?=
 =?utf-8?B?Z1orNzVhS0VBTjFJZWt5d0g3SDV3cDNGL0Y0TFNHeEVkNi8zQjFIdHo0aEs5?=
 =?utf-8?B?b0N1SlZZdVducEZhYkFqdWtzWWVzNGVuZVB4VTVheHUrVW50Q1lyeWk5TzdX?=
 =?utf-8?B?QlVyQUs1TUxKbVJOclM0YlZvOWt0d3NLTzlmTXMrVWErTHg0Q0g0RDRDUWRG?=
 =?utf-8?Q?U5bniHBbPKJop?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 523690e2-d3e2-47e3-d14e-08d8e7b5ea12
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2021 13:26:17.7592
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zjsFirmSkvTAf3wpY6gwBtHfVpN/5KFLRiEmb4wGaIrPvnCQPvGEA4r07aJUSVi3mIE6QljIJCgBjYPoVAtYtA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3216
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKU2ln
bmVkLW9mZi1ieTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29t
PgotLS0KIGRyaXZlcnMvbmV0L3dpcmVsZXNzL3NpbGFicy93Zngvc2Nhbi5jIHwgMTMxICsrKysr
KysrKysrKysrKysrKysrKysrKysKIGRyaXZlcnMvbmV0L3dpcmVsZXNzL3NpbGFicy93Zngvc2Nh
bi5oIHwgIDIyICsrKysrCiAyIGZpbGVzIGNoYW5nZWQsIDE1MyBpbnNlcnRpb25zKCspCiBjcmVh
dGUgbW9kZSAxMDA2NDQgZHJpdmVycy9uZXQvd2lyZWxlc3Mvc2lsYWJzL3dmeC9zY2FuLmMKIGNy
ZWF0ZSBtb2RlIDEwMDY0NCBkcml2ZXJzL25ldC93aXJlbGVzcy9zaWxhYnMvd2Z4L3NjYW4uaAoK
ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3NpbGFicy93Zngvc2Nhbi5jIGIvZHJp
dmVycy9uZXQvd2lyZWxlc3Mvc2lsYWJzL3dmeC9zY2FuLmMKbmV3IGZpbGUgbW9kZSAxMDA2NDQK
aW5kZXggMDAwMDAwMDAwMDAwLi4zZDVmMTNjODliYWMKLS0tIC9kZXYvbnVsbAorKysgYi9kcml2
ZXJzL25ldC93aXJlbGVzcy9zaWxhYnMvd2Z4L3NjYW4uYwpAQCAtMCwwICsxLDEzMSBAQAorLy8g
U1BEWC1MaWNlbnNlLUlkZW50aWZpZXI6IEdQTC0yLjAtb25seQorLyoKKyAqIFNjYW4gcmVsYXRl
ZCBmdW5jdGlvbnMuCisgKgorICogQ29weXJpZ2h0IChjKSAyMDE3LTIwMjAsIFNpbGljb24gTGFi
b3JhdG9yaWVzLCBJbmMuCisgKiBDb3B5cmlnaHQgKGMpIDIwMTAsIFNULUVyaWNzc29uCisgKi8K
KyNpbmNsdWRlIDxuZXQvbWFjODAyMTEuaD4KKworI2luY2x1ZGUgInNjYW4uaCIKKyNpbmNsdWRl
ICJ3ZnguaCIKKyNpbmNsdWRlICJzdGEuaCIKKyNpbmNsdWRlICJoaWZfdHhfbWliLmgiCisKK3N0
YXRpYyB2b2lkIF9faWVlZTgwMjExX3NjYW5fY29tcGxldGVkX2NvbXBhdChzdHJ1Y3QgaWVlZTgw
MjExX2h3ICpodywKKwkJCQkJICAgICAgYm9vbCBhYm9ydGVkKQoreworCXN0cnVjdCBjZmc4MDIx
MV9zY2FuX2luZm8gaW5mbyA9IHsKKwkJLmFib3J0ZWQgPSBhYm9ydGVkLAorCX07CisKKwlpZWVl
ODAyMTFfc2Nhbl9jb21wbGV0ZWQoaHcsICZpbmZvKTsKK30KKworc3RhdGljIGludCB1cGRhdGVf
cHJvYmVfdG1wbChzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiwKKwkJCSAgICAgc3RydWN0IGNmZzgwMjEx
X3NjYW5fcmVxdWVzdCAqcmVxKQoreworCXN0cnVjdCBza19idWZmICpza2I7CisKKwlza2IgPSBp
ZWVlODAyMTFfcHJvYmVyZXFfZ2V0KHd2aWYtPndkZXYtPmh3LCB3dmlmLT52aWYtPmFkZHIsCisJ
CQkJICAgICBOVUxMLCAwLCByZXEtPmllX2xlbik7CisJaWYgKCFza2IpCisJCXJldHVybiAtRU5P
TUVNOworCisJc2tiX3B1dF9kYXRhKHNrYiwgcmVxLT5pZSwgcmVxLT5pZV9sZW4pOworCWhpZl9z
ZXRfdGVtcGxhdGVfZnJhbWUod3ZpZiwgc2tiLCBISUZfVE1QTFRfUFJCUkVRLCAwKTsKKwlkZXZf
a2ZyZWVfc2tiKHNrYik7CisJcmV0dXJuIDA7Cit9CisKK3N0YXRpYyBpbnQgc2VuZF9zY2FuX3Jl
cShzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiwKKwkJCSBzdHJ1Y3QgY2ZnODAyMTFfc2Nhbl9yZXF1ZXN0
ICpyZXEsIGludCBzdGFydF9pZHgpCit7CisJaW50IGksIHJldCwgdGltZW91dDsKKwlzdHJ1Y3Qg
aWVlZTgwMjExX2NoYW5uZWwgKmNoX3N0YXJ0LCAqY2hfY3VyOworCisJZm9yIChpID0gc3RhcnRf
aWR4OyBpIDwgcmVxLT5uX2NoYW5uZWxzOyBpKyspIHsKKwkJY2hfc3RhcnQgPSByZXEtPmNoYW5u
ZWxzW3N0YXJ0X2lkeF07CisJCWNoX2N1ciA9IHJlcS0+Y2hhbm5lbHNbaV07CisJCVdBUk4oY2hf
Y3VyLT5iYW5kICE9IE5MODAyMTFfQkFORF8yR0haLCAiYmFuZCBub3Qgc3VwcG9ydGVkIik7CisJ
CWlmIChjaF9jdXItPm1heF9wb3dlciAhPSBjaF9zdGFydC0+bWF4X3Bvd2VyKQorCQkJYnJlYWs7
CisJCWlmICgoY2hfY3VyLT5mbGFncyBeIGNoX3N0YXJ0LT5mbGFncykgJiBJRUVFODAyMTFfQ0hB
Tl9OT19JUikKKwkJCWJyZWFrOworCX0KKwl3ZnhfdHhfbG9ja19mbHVzaCh3dmlmLT53ZGV2KTsK
Kwl3dmlmLT5zY2FuX2Fib3J0ID0gZmFsc2U7CisJcmVpbml0X2NvbXBsZXRpb24oJnd2aWYtPnNj
YW5fY29tcGxldGUpOworCXJldCA9IGhpZl9zY2FuKHd2aWYsIHJlcSwgc3RhcnRfaWR4LCBpIC0g
c3RhcnRfaWR4LCAmdGltZW91dCk7CisJaWYgKHJldCkgeworCQl3ZnhfdHhfdW5sb2NrKHd2aWYt
PndkZXYpOworCQlyZXR1cm4gLUVJTzsKKwl9CisJcmV0ID0gd2FpdF9mb3JfY29tcGxldGlvbl90
aW1lb3V0KCZ3dmlmLT5zY2FuX2NvbXBsZXRlLCB0aW1lb3V0KTsKKwlpZiAocmVxLT5jaGFubmVs
c1tzdGFydF9pZHhdLT5tYXhfcG93ZXIgIT0gd3ZpZi0+dmlmLT5ic3NfY29uZi50eHBvd2VyKQor
CQloaWZfc2V0X291dHB1dF9wb3dlcih3dmlmLCB3dmlmLT52aWYtPmJzc19jb25mLnR4cG93ZXIp
OworCXdmeF90eF91bmxvY2sod3ZpZi0+d2Rldik7CisJaWYgKCFyZXQpIHsKKwkJZGV2X25vdGlj
ZSh3dmlmLT53ZGV2LT5kZXYsICJzY2FuIHRpbWVvdXRcbiIpOworCQloaWZfc3RvcF9zY2FuKHd2
aWYpOworCQlyZXR1cm4gLUVUSU1FRE9VVDsKKwl9CisJaWYgKHd2aWYtPnNjYW5fYWJvcnQpIHsK
KwkJZGV2X25vdGljZSh3dmlmLT53ZGV2LT5kZXYsICJzY2FuIGFib3J0XG4iKTsKKwkJcmV0dXJu
IC1FQ09OTkFCT1JURUQ7CisJfQorCXJldHVybiBpIC0gc3RhcnRfaWR4OworfQorCisvKiBJdCBp
cyBub3QgcmVhbGx5IG5lY2Vzc2FyeSB0byBydW4gc2NhbiByZXF1ZXN0IGFzeW5jaHJvbm91c2x5
LiBIb3dldmVyLAorICogdGhlcmUgaXMgYSBidWcgaW4gIml3IHNjYW4iIHdoZW4gaWVlZTgwMjEx
X3NjYW5fY29tcGxldGVkKCkgaXMgY2FsbGVkIGJlZm9yZQorICogd2Z4X2h3X3NjYW4oKSByZXR1
cm4KKyAqLwordm9pZCB3ZnhfaHdfc2Nhbl93b3JrKHN0cnVjdCB3b3JrX3N0cnVjdCAqd29yaykK
K3sKKwlzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiA9IGNvbnRhaW5lcl9vZih3b3JrLCBzdHJ1Y3Qgd2Z4
X3ZpZiwgc2Nhbl93b3JrKTsKKwlzdHJ1Y3QgaWVlZTgwMjExX3NjYW5fcmVxdWVzdCAqaHdfcmVx
ID0gd3ZpZi0+c2Nhbl9yZXE7CisJaW50IGNoYW5fY3VyLCByZXQ7CisKKwltdXRleF9sb2NrKCZ3
dmlmLT53ZGV2LT5jb25mX211dGV4KTsKKwltdXRleF9sb2NrKCZ3dmlmLT5zY2FuX2xvY2spOwor
CWlmICh3dmlmLT5qb2luX2luX3Byb2dyZXNzKSB7CisJCWRldl9pbmZvKHd2aWYtPndkZXYtPmRl
diwgIiVzOiBhYm9ydCBpbi1wcm9ncmVzcyBSRVFfSk9JTiIsCisJCQkgX19mdW5jX18pOworCQl3
ZnhfcmVzZXQod3ZpZik7CisJfQorCXVwZGF0ZV9wcm9iZV90bXBsKHd2aWYsICZod19yZXEtPnJl
cSk7CisJY2hhbl9jdXIgPSAwOworCWRvIHsKKwkJcmV0ID0gc2VuZF9zY2FuX3JlcSh3dmlmLCAm
aHdfcmVxLT5yZXEsIGNoYW5fY3VyKTsKKwkJaWYgKHJldCA+IDApCisJCQljaGFuX2N1ciArPSBy
ZXQ7CisJfSB3aGlsZSAocmV0ID4gMCAmJiBjaGFuX2N1ciA8IGh3X3JlcS0+cmVxLm5fY2hhbm5l
bHMpOworCW11dGV4X3VubG9jaygmd3ZpZi0+c2Nhbl9sb2NrKTsKKwltdXRleF91bmxvY2soJnd2
aWYtPndkZXYtPmNvbmZfbXV0ZXgpOworCV9faWVlZTgwMjExX3NjYW5fY29tcGxldGVkX2NvbXBh
dCh3dmlmLT53ZGV2LT5odywgcmV0IDwgMCk7Cit9CisKK2ludCB3ZnhfaHdfc2NhbihzdHJ1Y3Qg
aWVlZTgwMjExX2h3ICpodywgc3RydWN0IGllZWU4MDIxMV92aWYgKnZpZiwKKwkJc3RydWN0IGll
ZWU4MDIxMV9zY2FuX3JlcXVlc3QgKmh3X3JlcSkKK3sKKwlzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiA9
IChzdHJ1Y3Qgd2Z4X3ZpZiAqKXZpZi0+ZHJ2X3ByaXY7CisKKwlXQVJOX09OKGh3X3JlcS0+cmVx
Lm5fY2hhbm5lbHMgPiBISUZfQVBJX01BWF9OQl9DSEFOTkVMUyk7CisJd3ZpZi0+c2Nhbl9yZXEg
PSBod19yZXE7CisJc2NoZWR1bGVfd29yaygmd3ZpZi0+c2Nhbl93b3JrKTsKKwlyZXR1cm4gMDsK
K30KKwordm9pZCB3ZnhfY2FuY2VsX2h3X3NjYW4oc3RydWN0IGllZWU4MDIxMV9odyAqaHcsIHN0
cnVjdCBpZWVlODAyMTFfdmlmICp2aWYpCit7CisJc3RydWN0IHdmeF92aWYgKnd2aWYgPSAoc3Ry
dWN0IHdmeF92aWYgKil2aWYtPmRydl9wcml2OworCisJd3ZpZi0+c2Nhbl9hYm9ydCA9IHRydWU7
CisJaGlmX3N0b3Bfc2Nhbih3dmlmKTsKK30KKwordm9pZCB3Znhfc2Nhbl9jb21wbGV0ZShzdHJ1
Y3Qgd2Z4X3ZpZiAqd3ZpZikKK3sKKwljb21wbGV0ZSgmd3ZpZi0+c2Nhbl9jb21wbGV0ZSk7Cit9
CmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC93aXJlbGVzcy9zaWxhYnMvd2Z4L3NjYW4uaCBiL2Ry
aXZlcnMvbmV0L3dpcmVsZXNzL3NpbGFicy93Zngvc2Nhbi5oCm5ldyBmaWxlIG1vZGUgMTAwNjQ0
CmluZGV4IDAwMDAwMDAwMDAwMC4uNmQ3MDcxN2YyYmY3Ci0tLSAvZGV2L251bGwKKysrIGIvZHJp
dmVycy9uZXQvd2lyZWxlc3Mvc2lsYWJzL3dmeC9zY2FuLmgKQEAgLTAsMCArMSwyMiBAQAorLyog
U1BEWC1MaWNlbnNlLUlkZW50aWZpZXI6IEdQTC0yLjAtb25seSAqLworLyoKKyAqIFNjYW4gcmVs
YXRlZCBmdW5jdGlvbnMuCisgKgorICogQ29weXJpZ2h0IChjKSAyMDE3LTIwMjAsIFNpbGljb24g
TGFib3JhdG9yaWVzLCBJbmMuCisgKiBDb3B5cmlnaHQgKGMpIDIwMTAsIFNULUVyaWNzc29uCisg
Ki8KKyNpZm5kZWYgV0ZYX1NDQU5fSAorI2RlZmluZSBXRlhfU0NBTl9ICisKKyNpbmNsdWRlIDxu
ZXQvbWFjODAyMTEuaD4KKworc3RydWN0IHdmeF9kZXY7CitzdHJ1Y3Qgd2Z4X3ZpZjsKKwordm9p
ZCB3ZnhfaHdfc2Nhbl93b3JrKHN0cnVjdCB3b3JrX3N0cnVjdCAqd29yayk7CitpbnQgd2Z4X2h3
X3NjYW4oc3RydWN0IGllZWU4MDIxMV9odyAqaHcsIHN0cnVjdCBpZWVlODAyMTFfdmlmICp2aWYs
CisJCXN0cnVjdCBpZWVlODAyMTFfc2Nhbl9yZXF1ZXN0ICpyZXEpOwordm9pZCB3ZnhfY2FuY2Vs
X2h3X3NjYW4oc3RydWN0IGllZWU4MDIxMV9odyAqaHcsIHN0cnVjdCBpZWVlODAyMTFfdmlmICp2
aWYpOwordm9pZCB3Znhfc2Nhbl9jb21wbGV0ZShzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZik7CisKKyNl
bmRpZgotLSAKMi4zMC4yCgo=
