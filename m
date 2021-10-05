Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CA2242292B
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 15:55:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235303AbhJEN5S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 09:57:18 -0400
Received: from mail-dm3nam07on2073.outbound.protection.outlook.com ([40.107.95.73]:28128
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235630AbhJEN4b (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Oct 2021 09:56:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NP7z0BE8xLgqwaJUV1ZrWWpCzMmX9mr7mlveHG1yHZj2K5AiaXIiNxGhtbw2AqeWj6aVo0EfjRXmdUaVmfLSM9MJ9yxf3XOLS0V0aF3FIVXWjtjHtkqwK//9ptdIe9cwvNiCN6C2Z4CGgcyWHRlUK2PurPi6FoB1wk+JkMXv2cSEVHOS5qBjWTvHanddMPKAEC5T+fnhUdSGLBeEb+5GPpH/+7Ho1Axrr1HiwKYd5Iy4t8LTvXWgko9Lph23QZMl1id4XrnSK0354GVOZ7d6oRLwIG+Yr1supZNcSe4Zn/v7grhI/pE+k8RXH3UfLVSFBdEBD4SQVn8oIeP3ZWhSnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/CHhItvbGeo+w1ZRY6GP4IAdEvdHNYPBx4tLT6XYmdA=;
 b=GEimqOtt2Zg5dI0V/1fkHPPch85qhA8wseu8koN/94RQ0Mdr9LUNvjNIagVzbCmVh8mTgzoNYOYgF2CyE/sxArJ9f1NI/C00gqVfQSIdCPPIGs33dBvqfbPCqoWz1ptImOrY0raW5TBOkY3SJieF357VUPDrq4nMVKon4spl6ofWNDyXBkwNTUPx4mFxyXT/cOBzpFAFWs0rqlxPGcdOQhXxUGfeJs3rwKuuZTtpbaHxf3b8bTLhi3nYas4sFTxrcar2huq/dUgEJkKC0mXOy8QcAmQNXJnBKBMVRrPKD2AftKEysJn9SmuaOhUhILPZH3ljed7b0GZ0lFL7CYt7fA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/CHhItvbGeo+w1ZRY6GP4IAdEvdHNYPBx4tLT6XYmdA=;
 b=GbFdt/eaNzjaxTUscxUmbAsZwwTcnclxhsTaad9Ts0Kyo+DNTZHukhrCYeySLuaeK6Pg9bcKgLXzjsW7JrrbZDo+PgOYO6Y8TD5nJYHPYbdiqKmre587kefbramPZuZpwXduiR/GPq2vUYA7+Yikug6roWF2+Y7sM6SQRXYzeKc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=silabs.com;
Received: from PH0PR11MB5657.namprd11.prod.outlook.com (2603:10b6:510:ee::19)
 by PH0PR11MB5643.namprd11.prod.outlook.com (2603:10b6:510:d5::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14; Tue, 5 Oct
 2021 13:54:25 +0000
Received: from PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::31cb:3b13:b0e8:d8f4]) by PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::31cb:3b13:b0e8:d8f4%9]) with mapi id 15.20.4566.022; Tue, 5 Oct 2021
 13:54:25 +0000
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
Subject: [PATCH v8 02/24] dt-bindings: introduce silabs,wfx.yaml
Date:   Tue,  5 Oct 2021 15:53:38 +0200
Message-Id: <20211005135400.788058-3-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211005135400.788058-1-Jerome.Pouiller@silabs.com>
References: <20211005135400.788058-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PR3P189CA0084.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:102:b4::29) To PH0PR11MB5657.namprd11.prod.outlook.com
 (2603:10b6:510:ee::19)
MIME-Version: 1.0
Received: from pc-42.silabs.com (37.71.187.125) by PR3P189CA0084.EURP189.PROD.OUTLOOK.COM (2603:10a6:102:b4::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14 via Frontend Transport; Tue, 5 Oct 2021 13:54:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c9953e13-3843-4b64-83ce-08d98807a44e
X-MS-TrafficTypeDiagnostic: PH0PR11MB5643:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR11MB5643712D394DB10FBAEAE98F93AF9@PH0PR11MB5643.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mpGuGNZ8jUGVpjxbZbcMgwFySn+rJ7byivFBesna5XuIYYqkpUa40z9yeXGktyqTZl9OJEkBIni2aTEBvWoupyw3EqjIB/zl4yEqvZl4kK/Yq1RydTvNqlOkmyCuj1LfyeOOTri3pwg2cklh1Wq8RBx+DgIvyMSROKnLfPt2x54VqqnHYIbgZhDhWw7BBg5t3KClwWbPycFpcZB7a/UQL5qbn5hNADcgvuYMcNeNew0ZwpmME6kZi/U3EcYujAbLgFYQR1Xs33Br/LLwedpzBG89DPtBqI1JM5DEuROQBCKsr1Nn+IN//V5OeOfizYZK6TvmAroebTbR2bcSTZHB/7NU8QsaXKwfe6Oj1mjcC/JkSwX2MSgsuvaWRKytQq7nQmDMzriIpJxt4Gc25fEanPuEnFUpMriLqXd0fMAwn+rGQkUd3fnDIl59qUGxdtEu/mEXM0mgERyxrUvBXTj/69yh6XUtEfJylbRQnGoGHmkyZEuoxdwwVgEVVaxTl1Z56kQkKOfOVOtGHk/szftE1g02ZnGhX7UfIaO+Yl12VUzdV8QpnywXaC3bRJ465jPxkDo1Ih3QqsDDz6Xs0+ZuCkY9LQjXbCFiwEjGgyDvopRc1Umhalo5DeQxojNKvBYUGNUZOFfTC1+2ZOlxi4ksFjpHs/X0o/C+mmm/Hk6PVIKRLPBakoDNb9yPGLe38fM2LrLEQxkmijCM9vMp9I/GzTcoLQDBvIxILU9Rm6gvE5Yl7jxznZh8YWF6Z/26yl2EBID67KDa2pwKdhXG7vbhyMuRaVcKEkrGvHSY6ticXfg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(7416002)(2616005)(956004)(54906003)(8936002)(36756003)(1076003)(186003)(38100700002)(86362001)(6486002)(6916009)(5660300002)(38350700002)(966005)(66946007)(66476007)(66556008)(52116002)(7696005)(508600001)(6666004)(2906002)(316002)(4326008)(26005)(107886003)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dnlNYnpEYXlwMEQwUUhOcENOankzbjdlWnUrektoTk9RNFlLOUxhc1JyWGQ1?=
 =?utf-8?B?MVNyWkpvR0FnbTVvN2Q3RHlOSGhzakVwdTJzbzZtZWZpRG1LUnBFSVU2eW9M?=
 =?utf-8?B?QVJMbVBrb0Y1WlU2cFNqQStLTHNkeUYzMjVZNUZhOWFuUjhSbFloMHM4aVRl?=
 =?utf-8?B?TnZUN2xpbnZqcDJPck00OFVGdW5JNjNBQmNoMTBoc3pPcTVyRjRaSGZDT0tQ?=
 =?utf-8?B?TXdPU0hndHE4QWs5bU1nazk3Y3YvaWdtN2I5c1Z5Tjh4TnZoY2FVL3ZYekUv?=
 =?utf-8?B?ZTkxejA4Skp3WUlxZ3JoRTNlYWV0S25haVFuOWZXbXNUZlcyOVJyUmMxa0pv?=
 =?utf-8?B?RTdnUE12WnBKSUI0a3NQZklRUUt3UXhHVWZBbTRvNkJMMmpTQTladEh6czVO?=
 =?utf-8?B?UTJZeWdkYzlMMDVJeDlKVCtjRE9TejQrTmF3eGJ0QmRVbW15bEIrelh2NXVP?=
 =?utf-8?B?RFJuSnNKOGtibE5TV21NalVtOVpPMjcwMkZ3Mms4WDJSVUJTSTVFWkxSdkxE?=
 =?utf-8?B?emJ6cmhveWM0L0ZBUnAwTTZFK3h4M3l5REdCM1Z0U093VkI0ZGdady82ZlV0?=
 =?utf-8?B?Q1M0OHBJZnZwMi9LR2doSjFXWjJWOThzeVEybXozMnBHM3FSUVdPelZFZUo3?=
 =?utf-8?B?YVlUMElORlVkUFg4dm1ETGV1Z1dmYndlZDFKbS9EYkdsbFdUekt1QmhJZURX?=
 =?utf-8?B?OXdJK2tPM0tnUzhvQUZLblgwL3hJN0ZQajR3RE9XZWZObGUrYWFjTFRrTnp5?=
 =?utf-8?B?cWtiUDJZdlI1Y1c1QmQyQW1mdFBkemEyS3ppME1taXBOQlczdFFmcU5TbXpV?=
 =?utf-8?B?SW4vRjlTejdiMGhTd1QxR2ZaamtXTldWRTZiN3ppYjFIZU02bXBMaVF4MTM0?=
 =?utf-8?B?Skl4dHJLTFltSUNOa2xpN243L0VVV284SGdOZUs2OStoOXlneHg5dGNhNzZK?=
 =?utf-8?B?TkdRZ3ZVYVptLzFvNm5YbGFBdlYrcjkydmVQRlBld1AwNVVsUnlEczlET0c1?=
 =?utf-8?B?Wld1N2g5N0d3aVJ5d3doYW80L2ZnSm42amtneDV3Q0x1UTNOalFsUnc4c1dH?=
 =?utf-8?B?MkFDU2hLWlN2QVZPai95eU9wVDNtY0lyT05jdkpJaDBMNE5jNUVCZVp1TlFB?=
 =?utf-8?B?WDB2eUFsR25TY1BzTTdkNkg2NVBCS1ZqWE9mWHl3OGRiUDg4MFVKMlhYSXlX?=
 =?utf-8?B?YnJaTDlpSUFoelRnTHFtTzJmTGFnNUhmaStVQnpjR1FHRE1zQ3BaWlB6N3Ev?=
 =?utf-8?B?d1VKWnE3YnV1bjA3c3FtNDB3Z2xSS1ZFOTRPWXdnOUtNdGFaTzdBcGs5YndE?=
 =?utf-8?B?cHVyM0taTUVhMy9IMnM5QnZvdVFWUTl5ZWI1Z2NFRmcySFBZaUJmc2ZSbndM?=
 =?utf-8?B?blZMVU9hUlcwSnQzRjEvSFY4UkwxWktkUm8zczJ4ZTJQZURGdXpRVFdkV3A2?=
 =?utf-8?B?bHhwcE1VNDhqQTlGcTF3Ykk2T3BVNSthMU5oVmp2M25qOVlkU2tzZ0R4Sys0?=
 =?utf-8?B?U2xRcWhvMXZjK0JIYzloS0htUG05UDJteUlWNjM4bERjQVJCSGxNWGhyL3Vr?=
 =?utf-8?B?cHFSZFBuQ0F4TUlwNkQ0d1VkT3hUU0FpKzdOdm1IU3lvK0pFSk1hb1ZKb1BC?=
 =?utf-8?B?RHVHdFBJbHpyaHJQam8zN20vRys0a0pYRDErQzFnUVhRTm9HUnNPZHlZOXp6?=
 =?utf-8?B?QXIzUk10a1RjWTlTQXYwN2I0aEp0SEdOTWJqWTI0UGFZV2hLcnJNYzRXT2dC?=
 =?utf-8?Q?fjRJ9yIP49IKs3HspIHO1YMCRlyyBlBiRpO4TEk?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c9953e13-3843-4b64-83ce-08d98807a44e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2021 13:54:25.3956
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QEU0jF/V7fTa3hfarRknzMAgOErjMbnG4mF0l9Bcqs3UrSQeRqL+s/U588Dg4qMdyXaetnylC7It7Gy12JxCOQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5643
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKUHJl
cGFyZSB0aGUgaW5jbHVzaW9uIG9mIHRoZSB3ZnggZHJpdmVyIGluIHRoZSBrZXJuZWwuCgpTaWdu
ZWQtb2ZmLWJ5OiBKw6lyw7RtZSBQb3VpbGxlciA8amVyb21lLnBvdWlsbGVyQHNpbGFicy5jb20+
Ci0tLQogLi4uL2JpbmRpbmdzL25ldC93aXJlbGVzcy9zaWxhYnMsd2Z4LnlhbWwgICAgIHwgMTM3
ICsrKysrKysrKysrKysrKysrKwogMSBmaWxlIGNoYW5nZWQsIDEzNyBpbnNlcnRpb25zKCspCiBj
cmVhdGUgbW9kZSAxMDA2NDQgRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL25ldC93
aXJlbGVzcy9zaWxhYnMsd2Z4LnlhbWwKCmRpZmYgLS1naXQgYS9Eb2N1bWVudGF0aW9uL2Rldmlj
ZXRyZWUvYmluZGluZ3MvbmV0L3dpcmVsZXNzL3NpbGFicyx3ZngueWFtbCBiL0RvY3VtZW50YXRp
b24vZGV2aWNldHJlZS9iaW5kaW5ncy9uZXQvd2lyZWxlc3Mvc2lsYWJzLHdmeC55YW1sCm5ldyBm
aWxlIG1vZGUgMTAwNjQ0CmluZGV4IDAwMDAwMDAwMDAwMC4uNmRjMzBlYjU2NjFiCi0tLSAvZGV2
L251bGwKKysrIGIvRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL25ldC93aXJlbGVz
cy9zaWxhYnMsd2Z4LnlhbWwKQEAgLTAsMCArMSwxMzcgQEAKKyMgU1BEWC1MaWNlbnNlLUlkZW50
aWZpZXI6IChHUEwtMi4wLW9ubHkgT1IgQlNELTItQ2xhdXNlKQorIyBDb3B5cmlnaHQgKGMpIDIw
MjAsIFNpbGljb24gTGFib3JhdG9yaWVzLCBJbmMuCislWUFNTCAxLjIKKy0tLQorCiskaWQ6IGh0
dHA6Ly9kZXZpY2V0cmVlLm9yZy9zY2hlbWFzL25ldC93aXJlbGVzcy9zaWxhYnMsd2Z4LnlhbWwj
Ciskc2NoZW1hOiBodHRwOi8vZGV2aWNldHJlZS5vcmcvbWV0YS1zY2hlbWFzL2NvcmUueWFtbCMK
KwordGl0bGU6IFNpbGljb24gTGFicyBXRnh4eCBkZXZpY2V0cmVlIGJpbmRpbmdzCisKK21haW50
YWluZXJzOgorICAtIErDqXLDtG1lIFBvdWlsbGVyIDxqZXJvbWUucG91aWxsZXJAc2lsYWJzLmNv
bT4KKworZGVzY3JpcHRpb246ID4KKyAgU3VwcG9ydCBmb3IgdGhlIFdpZmkgY2hpcCBXRnh4eCBm
cm9tIFNpbGljb24gTGFicy4gQ3VycmVudGx5LCB0aGUgb25seSBkZXZpY2UKKyAgZnJvbSB0aGUg
V0Z4eHggc2VyaWVzIGlzIHRoZSBXRjIwMCBkZXNjcmliZWQgaGVyZToKKyAgICAgaHR0cHM6Ly93
d3cuc2lsYWJzLmNvbS9kb2N1bWVudHMvcHVibGljL2RhdGEtc2hlZXRzL3dmMjAwLWRhdGFzaGVl
dC5wZGYKKworICBUaGUgV0YyMDAgY2FuIGJlIGNvbm5lY3RlZCB2aWEgU1BJIG9yIHZpYSBTRElP
LgorCisgIEZvciBTRElPOgorCisgICAgRGVjbGFyaW5nIHRoZSBXRnh4eCBjaGlwIGluIGRldmlj
ZSB0cmVlIGlzIG1hbmRhdG9yeSAodXN1YWxseSwgdGhlIFZJRC9QSUQgaXMKKyAgICBzdWZmaWNp
ZW50IGZvciB0aGUgU0RJTyBkZXZpY2VzKS4KKworICAgIEl0IGlzIHJlY29tbWVuZGVkIHRvIGRl
Y2xhcmUgYSBtbWMtcHdyc2VxIG9uIFNESU8gaG9zdCBhYm92ZSBXRnguIFdpdGhvdXQKKyAgICBp
dCwgeW91IG1heSBlbmNvdW50ZXIgaXNzdWVzIGR1cmluZyByZWJvb3QuIFRoZSBtbWMtcHdyc2Vx
IHNob3VsZCBiZQorICAgIGNvbXBhdGlibGUgd2l0aCBtbWMtcHdyc2VxLXNpbXBsZS4gUGxlYXNl
IGNvbnN1bHQKKyAgICBEb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3MvbW1jL21tYy1w
d3JzZXEtc2ltcGxlLnlhbWwgZm9yIG1vcmUKKyAgICBpbmZvcm1hdGlvbi4KKworICBGb3IgU1BJ
OgorCisgICAgSW4gYWRkIG9mIHRoZSBwcm9wZXJ0aWVzIGJlbG93LCBwbGVhc2UgY29uc3VsdAor
ICAgIERvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy9zcGkvc3BpLWNvbnRyb2xsZXIu
eWFtbCBmb3Igb3B0aW9uYWwgU1BJCisgICAgcmVsYXRlZCBwcm9wZXJ0aWVzLgorCitwcm9wZXJ0
aWVzOgorICBjb21wYXRpYmxlOiBTaG91bGQgYmUgb25lIG9mOgorICAgIC0gInNpbGFicyx3ZjIw
MCI6IENoaXAgYWxvbmUgd2l0aG91dCBhbnRlbm5hCisgICAgLSAic2lsYWJzLGJyZDQwMDFhIjog
RGV2ZWxvcG1lbnQgYm9hcmQgd2l0aCBhIFdGMjAwIGFuZCBhbiBhbnRlbm5hCisgICAgLSAic2ls
YWJzLGJyZDgwMjJhIjogRGV2ZWxvcG1lbnQgYm9hcmQgd2l0aCBhIFdGMjAwIGFuZCBhbiBhbnRl
bm5hCisgICAgLSAic2lsYWJzLGJyZDgwMjNhIjogRGV2ZWxvcG1lbnQgYm9hcmQgd2l0aCBhIFdG
MjAwIGFuZCBhbiBhbnRlbm5hCisKKyAgcmVnOgorICAgIGRlc2NyaXB0aW9uOgorICAgICAgV2hl
biB1c2VkIG9uIFNESU8gYnVzLCA8cmVnPiBtdXN0IGJlIHNldCB0byAxLiBXaGVuIHVzZWQgb24g
U1BJIGJ1cywgaXQgaXMKKyAgICAgIHRoZSBjaGlwIHNlbGVjdCBhZGRyZXNzIG9mIHRoZSBkZXZp
Y2UgYXMgZGVmaW5lZCBpbiB0aGUgU1BJIGRldmljZXMKKyAgICAgIGJpbmRpbmdzLgorICAgIG1h
eEl0ZW1zOiAxCisKKyAgc3BpLW1heC1mcmVxdWVuY3k6IHRydWUKKworICBpbnRlcnJ1cHRzOgor
ICAgIGRlc2NyaXB0aW9uOiBUaGUgaW50ZXJydXB0IGxpbmUuIFRyaWdnZXJzIElSUV9UWVBFX0xF
VkVMX0hJR0ggYW5kCisgICAgICBJUlFfVFlQRV9FREdFX1JJU0lORyBhcmUgYm90aCBzdXBwb3J0
ZWQgYnkgdGhlIGNoaXAgYW5kIHRoZSBkcml2ZXIuIFdoZW4KKyAgICAgIFNQSSBpcyB1c2VkLCB0
aGlzIHByb3BlcnR5IGlzIHJlcXVpcmVkLiBXaGVuIFNESU8gaXMgdXNlZCwgdGhlICJpbi1iYW5k
IgorICAgICAgaW50ZXJydXB0IHByb3ZpZGVkIGJ5IHRoZSBTRElPIGJ1cyBpcyB1c2VkIHVubGVz
cyBhbiBpbnRlcnJ1cHQgaXMgZGVmaW5lZAorICAgICAgaW4gdGhlIERldmljZSBUcmVlLgorICAg
IG1heEl0ZW1zOiAxCisKKyAgcmVzZXQtZ3Bpb3M6CisgICAgZGVzY3JpcHRpb246IChTUEkgb25s
eSkgUGhhbmRsZSBvZiBncGlvIHRoYXQgd2lsbCBiZSB1c2VkIHRvIHJlc2V0IGNoaXAKKyAgICAg
IGR1cmluZyBwcm9iZS4gV2l0aG91dCB0aGlzIHByb3BlcnR5LCB5b3UgbWF5IGVuY291bnRlciBp
c3N1ZXMgd2l0aCB3YXJtCisgICAgICBib290LiAoRm9yIGxlZ2FjeSBwdXJwb3NlLCB0aGUgZ3Bp
byBpbiBpbnZlcnRlZCB3aGVuIGNvbXBhdGlibGUgPT0KKyAgICAgICJzaWxhYnMsd2Z4LXNwaSIp
CisKKyAgICAgIEZvciBTRElPLCB0aGUgcmVzZXQgZ3BpbyBzaG91bGQgZGVjbGFyZWQgdXNpbmcg
YSBtbWMtcHdyc2VxLgorICAgIG1heEl0ZW1zOiAxCisKKyAgd2FrZXVwLWdwaW9zOgorICAgIGRl
c2NyaXB0aW9uOiBQaGFuZGxlIG9mIGdwaW8gdGhhdCB3aWxsIGJlIHVzZWQgdG8gd2FrZS11cCBj
aGlwLiBXaXRob3V0IHRoaXMKKyAgICAgIHByb3BlcnR5LCBkcml2ZXIgd2lsbCBkaXNhYmxlIG1v
c3Qgb2YgcG93ZXIgc2F2aW5nIGZlYXR1cmVzLgorICAgIG1heEl0ZW1zOiAxCisKKyAgc2lsYWJz
LGFudGVubmEtY29uZmlnLWZpbGU6CisgICAgJHJlZjogL3NjaGVtYXMvdHlwZXMueWFtbCMvZGVm
aW5pdGlvbnMvc3RyaW5nCisgICAgZGVzY3JpcHRpb246IFVzZSBhbiBhbHRlcm5hdGl2ZSBmaWxl
IGZvciBhbnRlbm5hIGNvbmZpZ3VyYXRpb24gKGFrYQorICAgICAgIlBsYXRmb3JtIERhdGEgU2V0
IiBpbiBTaWxhYnMgamFyZ29uKS4gRGVmYXVsdCBkZXBlbmRzIG9mICJjb21wYXRpYmxlIgorICAg
ICAgc3RyaW5nLiBGb3IgInNpbGFicyx3ZjIwMCIsIHRoZSBkZWZhdWx0IGlzICd3ZjIwMC5wZHMn
LgorCisgIGxvY2FsLW1hYy1hZGRyZXNzOiB0cnVlCisKKyAgbWFjLWFkZHJlc3M6IHRydWUKKwor
YWRkaXRpb25hbFByb3BlcnRpZXM6IGZhbHNlCisKK3JlcXVpcmVkOgorICAtIGNvbXBhdGlibGUK
KyAgLSByZWcKKworZXhhbXBsZXM6CisgIC0gfAorICAgICNpbmNsdWRlIDxkdC1iaW5kaW5ncy9n
cGlvL2dwaW8uaD4KKyAgICAjaW5jbHVkZSA8ZHQtYmluZGluZ3MvaW50ZXJydXB0LWNvbnRyb2xs
ZXIvaXJxLmg+CisKKyAgICBzcGkwIHsKKyAgICAgICAgI2FkZHJlc3MtY2VsbHMgPSA8MT47Cisg
ICAgICAgICNzaXplLWNlbGxzID0gPDA+OworCisgICAgICAgIHdpZmlAMCB7CisgICAgICAgICAg
ICBjb21wYXRpYmxlID0gInNpbGFicyx3ZjIwMCI7CisgICAgICAgICAgICBwaW5jdHJsLW5hbWVz
ID0gImRlZmF1bHQiOworICAgICAgICAgICAgcGluY3RybC0wID0gPCZ3ZnhfaXJxICZ3ZnhfZ3Bp
b3M+OworICAgICAgICAgICAgcmVnID0gPDA+OworICAgICAgICAgICAgaW50ZXJydXB0cy1leHRl
bmRlZCA9IDwmZ3BpbyAxNiBJUlFfVFlQRV9FREdFX1JJU0lORz47CisgICAgICAgICAgICB3YWtl
dXAtZ3Bpb3MgPSA8JmdwaW8gMTIgR1BJT19BQ1RJVkVfSElHSD47CisgICAgICAgICAgICByZXNl
dC1ncGlvcyA9IDwmZ3BpbyAxMyBHUElPX0FDVElWRV9MT1c+OworICAgICAgICAgICAgc3BpLW1h
eC1mcmVxdWVuY3kgPSA8NDIwMDAwMDA+OworICAgICAgICB9OworICAgIH07CisKKyAgLSB8Cisg
ICAgI2luY2x1ZGUgPGR0LWJpbmRpbmdzL2dwaW8vZ3Bpby5oPgorICAgICNpbmNsdWRlIDxkdC1i
aW5kaW5ncy9pbnRlcnJ1cHQtY29udHJvbGxlci9pcnEuaD4KKworICAgIHdmeF9wd3JzZXE6IHdm
eF9wd3JzZXEgeworICAgICAgICBjb21wYXRpYmxlID0gIm1tYy1wd3JzZXEtc2ltcGxlIjsKKyAg
ICAgICAgcGluY3RybC1uYW1lcyA9ICJkZWZhdWx0IjsKKyAgICAgICAgcGluY3RybC0wID0gPCZ3
ZnhfcmVzZXQ+OworICAgICAgICByZXNldC1ncGlvcyA9IDwmZ3BpbyAxMyBHUElPX0FDVElWRV9M
T1c+OworICAgIH07CisKKyAgICBtbWMwIHsKKyAgICAgICAgbW1jLXB3cnNlcSA9IDwmd2Z4X3B3
cnNlcT47CisgICAgICAgICNhZGRyZXNzLWNlbGxzID0gPDE+OworICAgICAgICAjc2l6ZS1jZWxs
cyA9IDwwPjsKKworICAgICAgICB3aWZpQDEgeworICAgICAgICAgICAgY29tcGF0aWJsZSA9ICJz
aWxhYnMsd2YyMDAiOworICAgICAgICAgICAgcGluY3RybC1uYW1lcyA9ICJkZWZhdWx0IjsKKyAg
ICAgICAgICAgIHBpbmN0cmwtMCA9IDwmd2Z4X3dha2V1cD47CisgICAgICAgICAgICByZWcgPSA8
MT47CisgICAgICAgICAgICB3YWtldXAtZ3Bpb3MgPSA8JmdwaW8gMTIgR1BJT19BQ1RJVkVfSElH
SD47CisgICAgICAgIH07CisgICAgfTsKKy4uLgotLSAKMi4zMy4wCgo=
