Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF79240FBDB
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 17:17:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344097AbhIQPSX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 11:18:23 -0400
Received: from mail-mw2nam12on2053.outbound.protection.outlook.com ([40.107.244.53]:15265
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1344026AbhIQPRJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Sep 2021 11:17:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kmsAJtoyMo0GdiZjNQ0ReX3kpOhEv5PfM/6qK20URHbU1raK+wvggeYWmaMiqMENWv46WvJzzZmcB2baWr1XBL4YdFbdeiqyC8Udgk/6eYluMpBUk9FOzh44e9M3jMvJYKhnyTJ4JtbAh8QBpanITwSVSZ637r4JgDtscJvF8IvoLZHL7eO7DH5oar+rH1LOKWRE8wkR4cdREjibndkwrba1pUxA+HazxTKDZ0DvTdNZPUDE39212amLGOgWyzjNk7a/OBm2Hsc03VZ7FA/PaKeHhFOQfAp8uWk+hmXoVi2/Z3ex2f2La6YleGQhlVgEEO2zMTRDoNb3+Dvt+6YldA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=B060dwVEfeTW4dRn140ZNuQdsL6yUQFgWMlzSPffF14=;
 b=j2+mD2e3Arfr6Jj3p7eZPbFqdsg69wPrRRkJoe+shFz6Nz9YKIFExRIPtWfSDpQ7l4Lbsg/pUsl//SfGqdLfvUEyu31hFYVsiFJvY4wigTPNGv/5sqeZ7ZzuMTdSH6zahwJIRnmdrO49ol26MaLzySi+3iEuVKnL6qfes/WFwCG2eukDuQym5TpqCYT0q9AAhf53HtDnqUnYkuNSWMzWjMVjYa9R8eMOVUc5iwa0cA875X1S5hLmh8jOnFaF8jRpeYauzw3rDKb3Qy9ueOelMb34cv0S73hwZJS3RqHsIGZV+eIrVm4k3Aasjmgnz1vxKuV21t2zff0Rram9rzaYLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B060dwVEfeTW4dRn140ZNuQdsL6yUQFgWMlzSPffF14=;
 b=ZA3RtcJ/KXjB1HcrrdbOa/gv8DygjB6PoIcaJN7FAzJTz4QnOc09byZabP/GFD382LFEn1+HKYoObY/C4qlCenXUwkuW6BXK+BAvvWtp0diDbwolgJn72hRzqHci5iNEp9+NaHkfBxIa1RXImEmSJS6eQENkILq3fWfs0PafF1M=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SA2PR11MB4876.namprd11.prod.outlook.com (2603:10b6:806:119::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Fri, 17 Sep
 2021 15:14:59 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd%7]) with mapi id 15.20.4500.017; Fri, 17 Sep 2021
 15:14:59 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        linux-mmc@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH v6 16/24] wfx: add data_rx.c/data_rx.h
Date:   Fri, 17 Sep 2021 17:13:52 +0200
Message-Id: <20210917151401.2274772-17-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210917151401.2274772-1-Jerome.Pouiller@silabs.com>
References: <20210917151401.2274772-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: SA9PR03CA0029.namprd03.prod.outlook.com
 (2603:10b6:806:20::34) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
Received: from pc-42.silabs.com (2a01:e34:ecb5:66a0:9876:e1d7:65be:d294) by SA9PR03CA0029.namprd03.prod.outlook.com (2603:10b6:806:20::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14 via Frontend Transport; Fri, 17 Sep 2021 15:14:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ffa1fd2c-18d0-459f-16d9-08d979edea3a
X-MS-TrafficTypeDiagnostic: SA2PR11MB4876:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA2PR11MB487657B4B52DBDC75808B0DD93DD9@SA2PR11MB4876.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:644;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 59cEB7ArmhXp9LT2MQTSQZ3hW2YqPnMqnXUXb9VLr1AfnLwqCj+R3KQmO/dwzuIoH2hX0vQH+dd5aT4GvpCZQ4ghZEhjLUPeh2F31/wSnd6xFrZ9LFy+OQkmWpg17w7XhXFb4XFmYW4+0OSH9E16CzGnLQb6UWHQ6lB376v6sPAX7ZX2JunUpKFGqUdmhIgwikJhc6WDSh+YdYkJ4NdvMqZkW0ItvRThmayw1lI4i8EUsJjvZASD1A3j2VSD7RVe7tyaVRayrb51nviy0YGvWQDhRArPp5gsslVqXMQmCMU5zx8c1Fs+jAzVGOkxUu/+HPkyLGu0v4IldpOuR9tf5TxihsaiCgzGiHkUkeqP6U7KFWbxpFeAQSDE4ETN2D+a8yhP7/zPsTxZtZg9TetSnPPRn8Zyy7pXUFUAKGqAf2BNmGTC4CXzBjujHImZDODKrJsp1FH95fdY4+0NIGkq3RZ7BC1ECtTl0jkBGfWZo49RIHRWYXRrV6+KMVQIQwcc+TldvY4G1YxVu6xmHMBrOI5HmoQ6ga3wE7p0KWlSYNqhG9C6b0zm978joFig6V8Y8ZqnSN2utZ8aWwwNImLIQX7gu/CpFjWPUDq4d7kDmb0FtEjw6j7KhbTysHxrTrRL1nO+Xc6BY/yydI+zPxnkfQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(83380400001)(1076003)(6486002)(38100700002)(107886003)(36756003)(8936002)(2906002)(7416002)(54906003)(5660300002)(186003)(8676002)(508600001)(52116002)(7696005)(6916009)(66476007)(66946007)(66556008)(2616005)(86362001)(316002)(4326008)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VExHb1VkNGYrbGFKN1RIbWpGZFJrenNZMW1JVXFHVnQwVUdUWU92eWVvQ2xM?=
 =?utf-8?B?QnV3ekZkNnVpa08xNnJ0blBLYmJwUGI4N1RkbFp2bmJld3hjbkhXMlBTVkE5?=
 =?utf-8?B?a1BTWUpyeDBIdEZla1dpWUR3VnpNbk9xK2dxaEUxZ28wMGlTWElPNTdtOVZU?=
 =?utf-8?B?ZUZjSUt4UHg1M1FzRmxONEl5Q2RVTDVKUnF6dVRJTUhFWGIrcEJZR2ZZUWNw?=
 =?utf-8?B?MkJyNWxBUUdWNkJ6RXo0eVJ3dC95dGxZQnJMU0FYaXllaTVycFBqTzVIajBV?=
 =?utf-8?B?MTJGd0VyZkdPb3licmdjTFl6MjEvWGJGN0xHY05oSzJBTlpqRWZ6Sjk2TTJ6?=
 =?utf-8?B?OEJZcHI4VE90RU5oV2x3TEhDL2NweUlEM3pJZ0l5U0Zpc1hWMC9lM0pUOEdO?=
 =?utf-8?B?TGpmZXJ3b1JoK2JJcXBoMUJkME5BY1Y4SnRSVndEVER5dHhjaVV4UXhJTk1L?=
 =?utf-8?B?a1hwcnNuWStGSW5UMHpLR3ZFMGY5WEI1SFp0TWFXSnhkamN0SmVaSDdIeHps?=
 =?utf-8?B?UTZBaTlaNTNvMUpHSXZZRWlFQnQwNUFubDVtMXVmdktMMWpkalpITjhqODFG?=
 =?utf-8?B?UVdYaks1WjU0aDI4SGd1V2J0OXRwRWNuaitqamx6bVhITVdBYTBpM2l3S2Zx?=
 =?utf-8?B?WVd3U1FqanR3VmpjL2htRUV6cWtKVGNBY0Y0Qm9UZHArTWNwOGs1dzh0a25u?=
 =?utf-8?B?RmhMTFROVkpBZ2pZQ0d2djU1b3RqU0FqUEFsckNZTWp4ZEVxcnVLZ3Zjamxv?=
 =?utf-8?B?aWN3RVpwVEMrbWV2WTM5dlZkOWxnb0RSK2c3Zkg3NDRXd2x1My9aa3Q4U1dU?=
 =?utf-8?B?TGEyazJqK3llTmNCcUNtejRZd0NZWjBibnBKZVpUVUhwUjBIbXoxTlViQVFx?=
 =?utf-8?B?ekd2RXBwVW50ZVd2WUV0Vi9NVVppN0psTCtXc2JWaEJWV000T3loUko3Q01H?=
 =?utf-8?B?cGtRV2R6aEExZXdlWWRzM0F3aWJaMllBbDA5TVpVNHNNS29FcllWV1R4aUNY?=
 =?utf-8?B?TDB4aHloWVNBcy9UblZhakx2THdqZ3RZTk9DZThrS2FCditRcFF6VVIwUUI2?=
 =?utf-8?B?czFFaFQzT04rKzlySERuemFIZXRyTC9KM0NwN21mNU8vNWhnKzUyUXkyZTNo?=
 =?utf-8?B?OXgzc0JpVTBpMU5MMXhSVVRRWS9Pd3A0VVRYOEtvVDkxRmt4cTFOZDBrRVNq?=
 =?utf-8?B?SXZ3T1d0b1VZRUZlcmVFTkZLVmRRMkZUenVTeE5iOFdtUkhYOU0vNXBnUUs0?=
 =?utf-8?B?Ky9YNjNVeElLQ3gyaGFMQ3NiQlNoSnZ6c0lKMmM5amRwYWJSWlBwbDhCYktC?=
 =?utf-8?B?MGwwRDRHVEduRXhNSG04WWpOcW1yVklVbENrOHFVRXRLc2NXVjNUUndiZ2J3?=
 =?utf-8?B?SGhUdGRlQ3BVWEpLMm81a05WdmR1OEZyRW1tTWlzMm1aMVlnWUF1V1hiaURK?=
 =?utf-8?B?TEFSckZjbE9ScnRJNlpTYTA3blV2NzR6bGNndVNFbTZrcVZmL0NrZEdqOVYw?=
 =?utf-8?B?OGVhbldrdVBOZUpHTUVMVGRMK2RKU3QvcVFVVTlBbTluZ0lkcUd5dmZLL2tx?=
 =?utf-8?B?dk85TkljK0FRRnhtdXhwNDRUTnFPeEJVeEJqNjZyWEhoMkowdGliWjBsTDFH?=
 =?utf-8?B?N0gwaG5KajNrT3RURUxncnd1YXJUWkJpSnlmYWNxTWE4L1FkWURzbHVuQ1Qz?=
 =?utf-8?B?RVREc0UzSXNWeWgxUHYwaS9wTkJlczJEc001SEs3SEtXZmsydVJKN3hIQ282?=
 =?utf-8?B?NkZDc3Vyakg0b1R3TTFiekl0UXhTQVJLM1UzQzFzS0VJL3V6M0RmSU03RkFS?=
 =?utf-8?B?Ylg1akdSNnMxSTltelQxK1FRSWFaelNnM1JjS3krOHRqRjBmWlNYYWZPdWVR?=
 =?utf-8?Q?763IMgMjcv6CS?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ffa1fd2c-18d0-459f-16d9-08d979edea3a
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2021 15:14:59.5720
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6ox7nSdFo/MGYAvBSyQJX3NpePNA5L+fXsTkOd4MVaqf06N5EbvFCo4wpuU0zpTQq9ci4lOVNEhArAgdgoRq8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4876
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKU2ln
bmVkLW9mZi1ieTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29t
PgotLS0KIGRyaXZlcnMvbmV0L3dpcmVsZXNzL3NpbGFicy93ZngvZGF0YV9yeC5jIHwgOTQgKysr
KysrKysrKysrKysrKysrKysrKysKIGRyaXZlcnMvbmV0L3dpcmVsZXNzL3NpbGFicy93ZngvZGF0
YV9yeC5oIHwgMTggKysrKysKIDIgZmlsZXMgY2hhbmdlZCwgMTEyIGluc2VydGlvbnMoKykKIGNy
ZWF0ZSBtb2RlIDEwMDY0NCBkcml2ZXJzL25ldC93aXJlbGVzcy9zaWxhYnMvd2Z4L2RhdGFfcngu
YwogY3JlYXRlIG1vZGUgMTAwNjQ0IGRyaXZlcnMvbmV0L3dpcmVsZXNzL3NpbGFicy93ZngvZGF0
YV9yeC5oCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvd2lyZWxlc3Mvc2lsYWJzL3dmeC9kYXRh
X3J4LmMgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9zaWxhYnMvd2Z4L2RhdGFfcnguYwpuZXcgZmls
ZSBtb2RlIDEwMDY0NAppbmRleCAwMDAwMDAwMDAwMDAuLmJmYzM5NjFiN2I4OQotLS0gL2Rldi9u
dWxsCisrKyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3NpbGFicy93ZngvZGF0YV9yeC5jCkBAIC0w
LDAgKzEsOTQgQEAKKy8vIFNQRFgtTGljZW5zZS1JZGVudGlmaWVyOiBHUEwtMi4wLW9ubHkKKy8q
CisgKiBEYXRhIHJlY2VpdmluZyBpbXBsZW1lbnRhdGlvbi4KKyAqCisgKiBDb3B5cmlnaHQgKGMp
IDIwMTctMjAyMCwgU2lsaWNvbiBMYWJvcmF0b3JpZXMsIEluYy4KKyAqIENvcHlyaWdodCAoYykg
MjAxMCwgU1QtRXJpY3Nzb24KKyAqLworI2luY2x1ZGUgPGxpbnV4L2V0aGVyZGV2aWNlLmg+Cisj
aW5jbHVkZSA8bmV0L21hYzgwMjExLmg+CisKKyNpbmNsdWRlICJkYXRhX3J4LmgiCisjaW5jbHVk
ZSAid2Z4LmgiCisjaW5jbHVkZSAiYmguaCIKKyNpbmNsdWRlICJzdGEuaCIKKworc3RhdGljIHZv
aWQgd2Z4X3J4X2hhbmRsZV9iYShzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiwgc3RydWN0IGllZWU4MDIx
MV9tZ210ICptZ210KQoreworCWludCBwYXJhbXMsIHRpZDsKKworCWlmICh3ZnhfYXBpX29sZGVy
X3RoYW4od3ZpZi0+d2RldiwgMywgNikpCisJCXJldHVybjsKKworCXN3aXRjaCAobWdtdC0+dS5h
Y3Rpb24udS5hZGRiYV9yZXEuYWN0aW9uX2NvZGUpIHsKKwljYXNlIFdMQU5fQUNUSU9OX0FEREJB
X1JFUToKKwkJcGFyYW1zID0gbGUxNl90b19jcHUobWdtdC0+dS5hY3Rpb24udS5hZGRiYV9yZXEu
Y2FwYWIpOworCQl0aWQgPSAocGFyYW1zICYgSUVFRTgwMjExX0FEREJBX1BBUkFNX1RJRF9NQVNL
KSA+PiAyOworCQlpZWVlODAyMTFfc3RhcnRfcnhfYmFfc2Vzc2lvbl9vZmZsKHd2aWYtPnZpZiwg
bWdtdC0+c2EsIHRpZCk7CisJCWJyZWFrOworCWNhc2UgV0xBTl9BQ1RJT05fREVMQkE6CisJCXBh
cmFtcyA9IGxlMTZfdG9fY3B1KG1nbXQtPnUuYWN0aW9uLnUuZGVsYmEucGFyYW1zKTsKKwkJdGlk
ID0gKHBhcmFtcyAmICBJRUVFODAyMTFfREVMQkFfUEFSQU1fVElEX01BU0spID4+IDEyOworCQlp
ZWVlODAyMTFfc3RvcF9yeF9iYV9zZXNzaW9uX29mZmwod3ZpZi0+dmlmLCBtZ210LT5zYSwgdGlk
KTsKKwkJYnJlYWs7CisJfQorfQorCit2b2lkIHdmeF9yeF9jYihzdHJ1Y3Qgd2Z4X3ZpZiAqd3Zp
ZiwKKwkgICAgICAgY29uc3Qgc3RydWN0IGhpZl9pbmRfcnggKmFyZywgc3RydWN0IHNrX2J1ZmYg
KnNrYikKK3sKKwlzdHJ1Y3QgaWVlZTgwMjExX3J4X3N0YXR1cyAqaGRyID0gSUVFRTgwMjExX1NL
Ql9SWENCKHNrYik7CisJc3RydWN0IGllZWU4MDIxMV9oZHIgKmZyYW1lID0gKHN0cnVjdCBpZWVl
ODAyMTFfaGRyICopc2tiLT5kYXRhOworCXN0cnVjdCBpZWVlODAyMTFfbWdtdCAqbWdtdCA9IChz
dHJ1Y3QgaWVlZTgwMjExX21nbXQgKilza2ItPmRhdGE7CisKKwltZW1zZXQoaGRyLCAwLCBzaXpl
b2YoKmhkcikpOworCisJaWYgKGFyZy0+c3RhdHVzID09IEhJRl9TVEFUVVNfUlhfRkFJTF9NSUMp
CisJCWhkci0+ZmxhZyB8PSBSWF9GTEFHX01NSUNfRVJST1IgfCBSWF9GTEFHX0lWX1NUUklQUEVE
OworCWVsc2UgaWYgKGFyZy0+c3RhdHVzKQorCQlnb3RvIGRyb3A7CisKKwlpZiAoc2tiLT5sZW4g
PCBzaXplb2Yoc3RydWN0IGllZWU4MDIxMV9wc3BvbGwpKSB7CisJCWRldl93YXJuKHd2aWYtPndk
ZXYtPmRldiwgIm1hbGZvcm1lZCBTRFUgcmVjZWl2ZWRcbiIpOworCQlnb3RvIGRyb3A7CisJfQor
CisJaGRyLT5iYW5kID0gTkw4MDIxMV9CQU5EXzJHSFo7CisJaGRyLT5mcmVxID0gaWVlZTgwMjEx
X2NoYW5uZWxfdG9fZnJlcXVlbmN5KGFyZy0+Y2hhbm5lbF9udW1iZXIsCisJCQkJCQkgICBoZHIt
PmJhbmQpOworCisJaWYgKGFyZy0+cnhlZF9yYXRlID49IDE0KSB7CisJCWhkci0+ZW5jb2Rpbmcg
PSBSWF9FTkNfSFQ7CisJCWhkci0+cmF0ZV9pZHggPSBhcmctPnJ4ZWRfcmF0ZSAtIDE0OworCX0g
ZWxzZSBpZiAoYXJnLT5yeGVkX3JhdGUgPj0gNCkgeworCQloZHItPnJhdGVfaWR4ID0gYXJnLT5y
eGVkX3JhdGUgLSAyOworCX0gZWxzZSB7CisJCWhkci0+cmF0ZV9pZHggPSBhcmctPnJ4ZWRfcmF0
ZTsKKwl9CisKKwlpZiAoIWFyZy0+cmNwaV9yc3NpKSB7CisJCWhkci0+ZmxhZyB8PSBSWF9GTEFH
X05PX1NJR05BTF9WQUw7CisJCWRldl9pbmZvKHd2aWYtPndkZXYtPmRldiwgInJlY2VpdmVkIGZy
YW1lIHdpdGhvdXQgUlNTSSBkYXRhXG4iKTsKKwl9CisJaGRyLT5zaWduYWwgPSBhcmctPnJjcGlf
cnNzaSAvIDIgLSAxMTA7CisJaGRyLT5hbnRlbm5hID0gMDsKKworCWlmIChhcmctPmVuY3J5cCkK
KwkJaGRyLT5mbGFnIHw9IFJYX0ZMQUdfREVDUllQVEVEOworCisJLyogQmxvY2sgYWNrIG5lZ290
aWF0aW9uIGlzIG9mZmxvYWRlZCBieSB0aGUgZmlybXdhcmUuIEhvd2V2ZXIsCisJICogcmUtb3Jk
ZXJpbmcgbXVzdCBiZSBkb25lIGJ5IHRoZSBtYWM4MDIxMS4KKwkgKi8KKwlpZiAoaWVlZTgwMjEx
X2lzX2FjdGlvbihmcmFtZS0+ZnJhbWVfY29udHJvbCkgJiYKKwkgICAgbWdtdC0+dS5hY3Rpb24u
Y2F0ZWdvcnkgPT0gV0xBTl9DQVRFR09SWV9CQUNLICYmCisJICAgIHNrYi0+bGVuID4gSUVFRTgw
MjExX01JTl9BQ1RJT05fU0laRSkgeworCQl3ZnhfcnhfaGFuZGxlX2JhKHd2aWYsIG1nbXQpOwor
CQlnb3RvIGRyb3A7CisJfQorCisJaWVlZTgwMjExX3J4X2lycXNhZmUod3ZpZi0+d2Rldi0+aHcs
IHNrYik7CisJcmV0dXJuOworCitkcm9wOgorCWRldl9rZnJlZV9za2Ioc2tiKTsKK30KZGlmZiAt
LWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3NpbGFicy93ZngvZGF0YV9yeC5oIGIvZHJpdmVy
cy9uZXQvd2lyZWxlc3Mvc2lsYWJzL3dmeC9kYXRhX3J4LmgKbmV3IGZpbGUgbW9kZSAxMDA2NDQK
aW5kZXggMDAwMDAwMDAwMDAwLi44NGQwZTNjMDUwN2IKLS0tIC9kZXYvbnVsbAorKysgYi9kcml2
ZXJzL25ldC93aXJlbGVzcy9zaWxhYnMvd2Z4L2RhdGFfcnguaApAQCAtMCwwICsxLDE4IEBACisv
KiBTUERYLUxpY2Vuc2UtSWRlbnRpZmllcjogR1BMLTIuMC1vbmx5ICovCisvKgorICogRGF0YSBy
ZWNlaXZpbmcgaW1wbGVtZW50YXRpb24uCisgKgorICogQ29weXJpZ2h0IChjKSAyMDE3LTIwMjAs
IFNpbGljb24gTGFib3JhdG9yaWVzLCBJbmMuCisgKiBDb3B5cmlnaHQgKGMpIDIwMTAsIFNULUVy
aWNzc29uCisgKi8KKyNpZm5kZWYgV0ZYX0RBVEFfUlhfSAorI2RlZmluZSBXRlhfREFUQV9SWF9I
CisKK3N0cnVjdCB3ZnhfdmlmOworc3RydWN0IHNrX2J1ZmY7CitzdHJ1Y3QgaGlmX2luZF9yeDsK
Kwordm9pZCB3ZnhfcnhfY2Ioc3RydWN0IHdmeF92aWYgKnd2aWYsCisJICAgICAgIGNvbnN0IHN0
cnVjdCBoaWZfaW5kX3J4ICphcmcsIHN0cnVjdCBza19idWZmICpza2IpOworCisjZW5kaWYKLS0g
CjIuMzMuMAoK
