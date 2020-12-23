Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CBDA2E1E8D
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 16:43:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729375AbgLWPmL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Dec 2020 10:42:11 -0500
Received: from mail-mw2nam12on2078.outbound.protection.outlook.com ([40.107.244.78]:27104
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729276AbgLWPmI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Dec 2020 10:42:08 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KGMl6HftnihIbgOcYVgNkNn1wEHCezwdauDJ5uGd2JPPaWMZUXDEjcUADbsMppf8NIvV80jm67r+jOYpdbBY2LehjnEJshN47as9Vvx16q3ejP5rnc2rYOoL6gn9RF0jqd4UZbIK/2Kgl09Jg+adlb+Fm0+QrDbZYSXMogjhNX9W1f6bEqHY3KtvO5RER9zyE68q6yTlZ+8L9ohQYcLHHDlrTiCKDaC3sM0orV4AQd+mHGRCm280O5RIqiQvmHoxVxBuWe9KzSncEEpTmwDURPpeF/cMpF5sKVS01NTKk3Y2Y/bepbc21m1bKdybyb+n0CoYW5zybRSUxy3O5PufbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CQc6ZYUK2M+3BmwXyEkzV68I/OmK35WRLPH8bgVx02s=;
 b=UOQnEOCU+AVv6MI9gaR2FAoVpbOyjKawkensLOl/Fy+EB754wx5l8hPs8MJfW7JeGRqZa+yq+JvBRIQAeDUkDG4STuEij14wa2s6yf9op8YJacstQ+evrLtD85QTSKqbJKx119OCMoCZc3ZPSnabLejLFGUJYY0GOZSq9v1jAi1IGzTpoAHQRCSDf1Qw6i3knNfz1qBoLwt8QxDibLPA/wy/yt8J0kTzWzAQ6NVMWjPxpWMbvxZ8+BcAXRtQS3ujSTMakbXh1ioFbdg2vtKDJSxVNndSGU4C3BqETvDc3TM64igkG3/wKNFI6ZlrxHPbVbDaz6EsfdvOcfHU+43Ipg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CQc6ZYUK2M+3BmwXyEkzV68I/OmK35WRLPH8bgVx02s=;
 b=CX/BdndxKstEERq7qIl7rafLmaADcs6LC8hlH3u5zZi5hFpN680w2lbLoOQwqnErXGuEL9ZDC29TWOhax0nN4jWRb5C5oSQBpD5aM+Ryt1nL/Y7V47YlXsp4kQPTft4GxcnJ95D8ftb0t/ickJ4kkDpMppo3AQG1rPdKR3bbjhg=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SN6PR11MB2815.namprd11.prod.outlook.com (2603:10b6:805:62::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3676.25; Wed, 23 Dec
 2020 15:40:27 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::a989:f850:6736:97ca]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::a989:f850:6736:97ca%5]) with mapi id 15.20.3700.026; Wed, 23 Dec 2020
 15:40:27 +0000
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
Subject: [PATCH v4 20/24] wfx: add scan.c/scan.h
Date:   Wed, 23 Dec 2020 16:39:21 +0100
Message-Id: <20201223153925.73742-21-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201223153925.73742-1-Jerome.Pouiller@silabs.com>
References: <20201223153925.73742-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-Originating-IP: [82.67.86.106]
X-ClientProxiedBy: SA0PR12CA0024.namprd12.prod.outlook.com
 (2603:10b6:806:6f::29) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.silabs.com (82.67.86.106) by SA0PR12CA0024.namprd12.prod.outlook.com (2603:10b6:806:6f::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3700.27 via Frontend Transport; Wed, 23 Dec 2020 15:40:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3d4a22d4-8513-4f61-f3e6-08d8a759129f
X-MS-TrafficTypeDiagnostic: SN6PR11MB2815:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR11MB281586549C0719866640155193DE0@SN6PR11MB2815.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3044;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ITE5UdYo5XgfXtZ1kVA8JIjtsr1O1qF4MGKKOGHQQbBhWQ7QzEc/0aYTp1ASJmfp849bQiy17DCt6PHhDon80YFqBDnEdEF9zrUVsowEQH1sOpPRrssOkXEWOqRuA5Wma7i2OZJmV03gYmBmSZlzCItSIj2yDsvFQNssX/WV4C1Wpq5buPh2Ss+9R02HxKr/GgR/NWJsG6O7xu3pHDnZMbRPnbUWG/qQbQVlndvBcdvasaIXGwyELPIedVlEmM0C48xHEOJY83MUufQJ/q9XhTa0RnKzlUmCd7MQ0EkULj/OYXAh++tnnHip2BddN92mAiRaGn7WT9I03TIfMFmoeocS/2lf3YvlG3intj6kaUgeVKrTH/aoKBxbOxOC9AV2kzOvE0U2wzg+HGcT6dJG0g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(136003)(366004)(376002)(39850400004)(346002)(66574015)(478600001)(83380400001)(8676002)(186003)(2906002)(8936002)(26005)(52116002)(107886003)(16526019)(7696005)(66946007)(7416002)(6486002)(956004)(2616005)(54906003)(66476007)(316002)(4326008)(6666004)(36756003)(5660300002)(1076003)(86362001)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?ZTF1eEhoMVdDcDUrUHVGcllQUGhKbkJXQ05GS2ZUOWdwYlhSYkdJQU5SbGo4?=
 =?utf-8?B?KzU5MWE1RzBLc2gxWTFKbS9PMHMydTZlUHllTjZPQkJrcFpiRmFYckQ0STZh?=
 =?utf-8?B?OEZYOTBkMng3REhhZDFBUEVqaUhJM0lNcnVZKzJ1dXFwbXZZYUxpRlpqRDFD?=
 =?utf-8?B?anMwc0VTWHFYQVBuanJLNWY1ZFZIRHRkTEt5N2l1QWRrR1JwWXF2QmtPSE5R?=
 =?utf-8?B?Y2dPUHBxN1dDK1ZDaTlTVnZvZy9KWE45WUxuVDkrQkxoTUdPRzQ5L0RNYm12?=
 =?utf-8?B?VnBUR3Awb2VRdTRWaWN0WFNTbnJHNFNySFFvRzFFdUQraGFLWTFreDREbW5n?=
 =?utf-8?B?N29aWndYVmhWQkdIWk5LL01URFJ4NWRxdmRkY2dlVHMrWXA5Y2ZDNHo2anJI?=
 =?utf-8?B?SzljM0lLdjNHTENEN3N6V3JXQkRPQW1nQ0d1SHNLeHRya2NLOGhsSWYyOGpi?=
 =?utf-8?B?OWU5TXptRlMwbEJpVUNJVFJDRlNzWERIL3NEbzlSTVVrYlBaU3lPajQxTTlm?=
 =?utf-8?B?S2xnOHFwRitEU0taVUpXMUFTSXp2RHB2bGhvR3cwU0Q2NEU0aEZSMHFwQVBz?=
 =?utf-8?B?NDFnYW1kUkk2aFhMV1JuU2UwcHJCMnVHc3VrTEpVL1p4L1JkK3RrTytVOU5V?=
 =?utf-8?B?Y1pzWUExRmVFVGRPNHkyUHBodlpyOXNzaDNyMityb1V3QVdlVkVwRTJ1MU93?=
 =?utf-8?B?Rng5ak82Z0NlZHM4WWI2WFJHanBaT21FMXVoMktrRmpPT1VkVVFGUGxtcUY3?=
 =?utf-8?B?WHNmTDJ4WGppRmIrdWNYR3NXMThHTjNFNjZkMXVWQjEzdGxYKzMrdk13aVl3?=
 =?utf-8?B?TVNLUDRMZFRzQTBNNmpVV0dxdUJtd0FMQ0I1eWpxMUl3UHpVM25kUnQvZEJv?=
 =?utf-8?B?cWlKMEZESnB6Qm5Yc29IS3E4VVl6R2JEaWRnWFgrVkNSSWhlVG93QnRtRXdj?=
 =?utf-8?B?amRWeHNQWW1XQytXVU9zcXM4cDNIS0pRWDRkbHlqTjVPdVhSajNVQUhIeitC?=
 =?utf-8?B?S2FGejNnK2tyYkI4azNxM2RuaFVRS3dlY2UvQUtyUWVRQXY1OU9PeG5CcFNz?=
 =?utf-8?B?TmR0eFVDcUpOdkYyYTA1OVR5eWdsSkVTRDhyLzV3Mlh2R3ZkQ21TZG83S1dY?=
 =?utf-8?B?NzFobnNSRFJEaGxtWGJLUGQvQVRVL1hsMnlNMGI0eE5qWE5WaUFOck5vVGFt?=
 =?utf-8?B?b3U0VlkvbGVjWmI1STFsRzFwOXZqYVRjSVc0UUs1b1Q4WjN6SUZtbHZSaEZR?=
 =?utf-8?B?YVZXdlcyenZNUEVxaTdpZ1ZxeTBSSGd5dmJ6a2JoMEE0U3ZZS1djaEtIVGpY?=
 =?utf-8?Q?R39y6c+Wuoqgs/CLHgUJ8VQ/56dHYHtJRh?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Dec 2020 15:40:27.8146
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d4a22d4-8513-4f61-f3e6-08d8a759129f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XPAckouN2EFk3To7narz9hH+r/31EFDT534qJttOR3EM61RckLDkI1wxLAgiAlA4BxlbdZ+IOCUdf04mWg6fLg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2815
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
bmRpZgotLSAKMi4yOS4yCgo=
