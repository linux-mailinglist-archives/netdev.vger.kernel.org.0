Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 537204086A9
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 10:32:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238122AbhIMIdV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 04:33:21 -0400
Received: from mail-bn8nam12on2064.outbound.protection.outlook.com ([40.107.237.64]:55755
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237987AbhIMIdD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Sep 2021 04:33:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZxwIF+rfakbS7YtFTAT2czKoh89pWjykWr/O4COSBzoeRN6i/YC5/mY1zvJZyH2MNI/tESwlndOX+xg1kPmR91FH/SLxgi4odGH+Ril7anxAH1YLhpMbw6vvIkNTiZkcYTYvqVQjIIExwPXSZ7Pdg7bagSDf6ny6Yl1YB305OeuiL61t8f6Fk79V2yk867euvsP22p3U5p92xhiJsGLwaJOKz4jKE35kSDsv5iJQhH+rqvbMujy4m2+6thTJ8f3nuFazU+yFibqY6w9qCXKFpw1oZiWWv5UEXAKiI1p6nDYXoU1bKwPZtOZRsiq4Sn1x0u9rPHMU3ZgzjYplLkZREg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=Ltkb34xn1l2676USN4kZ+ng0WW2jWxAd1JTkXQJO7zI=;
 b=fSlIysBZhJey7R4RlEDXiIS/Nfae7fAVBSYaRe9hQU4Y13SbMjnqR4He3pou2OJBoc+auNNoz1l3lKw56x5/d6S8d7xm61rHFg7f7jvSPZGH6z3wxphmPQyNRdNPwHBQr1TaM+p59jnkALyrRF2Z4O3j/vu3K6x4T8AKmVKeYArzYb41kWQuKAmmv1M3Whwl/hRbBWpIOjlxhlqBgt8yeJc2tuMWUBPuHgNi/iOn/U7jOh0CRriYrMSmvJyot11m4kEYBcsP4/pLL68mEszh8LdEy8moKAlfDfV5QBsfFudNKVrOE6JrHaZSTl28tTDptpNeGhKMncELFrX3qC4V7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ltkb34xn1l2676USN4kZ+ng0WW2jWxAd1JTkXQJO7zI=;
 b=otPHp+/HdcuH5t96RGhUhD7WAtIz5a3g+TVysddxfiDcDq/R3Zwl1TXJ6EOhSfyzmIGxhlfgOSJuQDp//ImhxSb3jcr/vVTfMmF2fCSfDo/rrmSZ8P9wLxwIfayRLQ+j1rMOjuVtP9DUs1EQpk0Ak5tN7gaPmRcWil3AdyJOcWc=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (52.135.97.18) by
 SN6PR11MB3263.namprd11.prod.outlook.com (52.135.109.86) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4500.18; Mon, 13 Sep 2021 08:31:45 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd%7]) with mapi id 15.20.4500.017; Mon, 13 Sep 2021
 08:31:45 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH v2 06/33] staging: wfx: drop unused argument from hif_scan()
Date:   Mon, 13 Sep 2021 10:30:18 +0200
Message-Id: <20210913083045.1881321-7-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913083045.1881321-1-Jerome.Pouiller@silabs.com>
References: <20210913083045.1881321-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PAZP264CA0067.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:1fd::10) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
Received: from pc-42.silabs.com (37.71.187.125) by PAZP264CA0067.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:1fd::10) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend Transport; Mon, 13 Sep 2021 08:31:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c685d950-0724-41ad-4ccd-08d97690d988
X-MS-TrafficTypeDiagnostic: SN6PR11MB3263:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR11MB32637D755210538F7DDB17D393D99@SN6PR11MB3263.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:854;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GOJ7vKga3LRfEM6OAiHDIFKdgtegPXB7RDaFjVFL0HtWtTRN529kK4Js8pozI34np6pnRsc7qa9nn0iZTVfZC0+aLsAhjGSzT/6UFODNevHj6SBVpZJfqMV6v3ywawb2OqDTzESlgAcEk+XY5l0pdbNMInvjRFcQhEqTMdNPPwRrgja2CTuX9og4a4Xrs3rqpimk4zXVJfyKT03niFeixzG8c/rxVpe1aWlgST9VtUu5o8qZtTpurZkuxwF6MLKbtRnfodaMRHjTsr4ueDEUe9BWTsqrRv/r0xQ6WtgUtqF6kuuJklZeSzfTmc6XVnvU6Tr1reRyCdEtCRT5xFX8kLT58ajpCxZijyZ+rUb5ma0s0UvEFqueJXwqGHdsUI8ReB43wvLSKFuVsmDnStEXPiEqDzgCIJ8MavsWpgWcirsEy9sPgMr+H+uYOUfbsMwtm2VwIfT1hsgfGZ+yEIMLs4CiPqqttG3NkGmjF5mSSzrR2OWlQ8E25AQGbCTZOfmYm4lH2YtWx1xJEgct4ee+r3KNldyiPIaKVeHMqN2ztmHV/ZuzfHW4taS69BMwJQlkgYCa8ZgdQdycn+K3h9E4sc2rWlNVXtJEw1T5NC3b/wfCSRZrTpMn10ytBBsO3qEDJjhIF77qvVPrftbBku7Q1PjeTYTGaJF/wQ9SGHU84DXgjLSXFRCVxleTCDthXPZdJQARZ3D3pSvJgwr9mhjkkg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(83380400001)(66574015)(107886003)(956004)(2616005)(5660300002)(54906003)(38350700002)(4326008)(316002)(38100700002)(66946007)(26005)(66476007)(66556008)(186003)(8676002)(36756003)(8936002)(86362001)(508600001)(52116002)(7696005)(6486002)(1076003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bFU5ZSttbU1mZ2dsZHcrWjFIalVuRXBILzVqQlVabi9hY3hIVXZNYUdobmky?=
 =?utf-8?B?SVozS0RDb3F6TTR3ZUxxWC9XaHp5VU9aUjF1K1lXeUdsMCtFczJYTHJLWlBo?=
 =?utf-8?B?TW0zWExVUk9NbkQ4d096U3I4dVV1Mkl3Y203QzNNRWNnVlhMUmtja0VCOFAx?=
 =?utf-8?B?a0xHRzE2aWZuNzZFL0cyWThvU2JoWXo2dkEyTmozSkFGTnk3SGQxWTZBMHBB?=
 =?utf-8?B?TkhuSjhRbG1NeGM3R1o4eStCWE1WY25JQmpEWEJOOW5MQmJLNkFYR2FtUDNH?=
 =?utf-8?B?Q3lteTFscmxjejdEYTNyQ3BUUE13QmJlU0QrM1M5SlJQdHRHTW5NTzFIa1J3?=
 =?utf-8?B?a0tGMVY4TjNVTHFUK2Z0d0V0VC9majI3NEJDL3NrK1MyUlhYeC9ZUU1UQ2VI?=
 =?utf-8?B?SXJXZmQvUm04WVl3TkMyN28wOUw1TFp6VndhZFgyMUNFcEFXQldCQzZwUjlF?=
 =?utf-8?B?R0RUdUZqVXhiTzE4dmJIQU5ZeGl1dlhNeENEVSs3MmZrcktWYkU3RGhHZnhO?=
 =?utf-8?B?YjBMZlVydkphNjJPZ2NSLyt6aFR6RUhVVE1LTXM3bk03VHBDTm85djB0TVJN?=
 =?utf-8?B?R2UzYVZCNUFpUXRUUVp5OGUxTWxENjNINmswb0hCY1FkZ05XSnBERGwyOTIy?=
 =?utf-8?B?MWd5c0s3bW5yY21FZndYb3NrL0hXQjNRZjVOa1RXOUt4R3h6ejZ0V2tWTDBx?=
 =?utf-8?B?VUV0NVVKU2FkVWd2UEJPZGNhVm5DZllIVDlKS0FBUmpaRGVvWGpoMFh4OGpG?=
 =?utf-8?B?dUFtODBhTG5qdXFPQVgxL0hzT1ZmT0xoTWxTMVB6b1Yzd2dBTzdDUjZzZWky?=
 =?utf-8?B?KzNRT1dwRmgrYzRuaEs1UjB4YUo5WHBFRVdjY3diUFo1Z1N0R24zKzFYaGRl?=
 =?utf-8?B?RVgvK0QzK2thM1ZCS0U4OFVJaitMYTBrdWYvM1ZVMjBRdzdBdzdUZkUvV2l2?=
 =?utf-8?B?M1RNOEZBQ2NtWXhzWEhnc3FrMFlzUFJFZTFYUXppMFpwSnBucm1QQml1TjBN?=
 =?utf-8?B?R2k3OEJhSU80cGNlejB6TWYxdEYvMzlYUGNIdTdoQWtwaGc3RXcxT2FmZXJV?=
 =?utf-8?B?U29SU0VOenVoOW1uMURVTTRSM1JiZWZYSDBMektiWCs5cXN1YW54aEVEL3Vn?=
 =?utf-8?B?TE00YldndDY0L3N2RmtrYkp5MGRmWVF3SENPanF4RzJYdzdiZ1hhMnBSbmJy?=
 =?utf-8?B?RTkwSDJQa3dQdkJDMkdYbHNXcU50SmJ6SnZGZ2VCajdFQk5KditwOVJzRDlj?=
 =?utf-8?B?eVRuV1VjNWFNaWZDYXNnRGRrdW5OQWtMZW8vb3JDN3YvdWJjV1B6bm1kaGNl?=
 =?utf-8?B?dVlRbTVOTlBlQlg5dzJKMjdaYnM5UVZXT2trWExlWlZUV2lFWXBzNWd0Q0h6?=
 =?utf-8?B?MElTQjFrakxnemNsYUMvU01PWUE0alkxVGlvNkplYURQcmRvRDRDcWc4SkJa?=
 =?utf-8?B?WGdGS2JIbGNkYVFEeXpLdWIzdG5hVmNpQU10VXUxMmlLU0V4MnhONGNIMGkz?=
 =?utf-8?B?WU1vRDl1aUh5SkdPaHYvYnl6aXp5UERJdjRYMmlhTmVhRjY5RFZDMWxCN1Bz?=
 =?utf-8?B?K1dwOUFTaVVVN2t5SURDam5ZVTIxM1REOFg4RkVmVlRyYm9TZU5HVTVWVzBu?=
 =?utf-8?B?cVBEeGxwRnZXazBKUmJUeHpHVS9pM01TZWhiaVZ4UXZWeHcxT09BVkxZNXZq?=
 =?utf-8?B?TEVQK09EN3N5bWV1RERBbjVzUXRPbEw0T1d5Tkk5N3ZxSjJOa2lwcTU5bEFK?=
 =?utf-8?Q?GveeMuSsouDKKHJo271VH+/xm9jOH6vvOcvo9MO?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c685d950-0724-41ad-4ccd-08d97690d988
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2021 08:31:14.8351
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JVHHfrKHcLkhGDZaE2mwukBVBOKvv7KKUQZSMAX4wJFgm9A7KI/pXs18bhq/m4SU7Q8zkE5bOxVEeaTb1iYlBg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3263
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKSXQg
aXMgbm8gbW9yZSBuZWNlc3NhcnkgdG8gY29tcHV0ZSB0aGUgZXhwZWN0ZWQgZHVyYXRpb24gb2Yg
dGhlIHNjYW4KcmVxdWVzdC4KClNpZ25lZC1vZmYtYnk6IErDqXLDtG1lIFBvdWlsbGVyIDxqZXJv
bWUucG91aWxsZXJAc2lsYWJzLmNvbT4KLS0tCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl90eC5j
IHwgOSArLS0tLS0tLS0KIGRyaXZlcnMvc3RhZ2luZy93ZngvaGlmX3R4LmggfCAyICstCiBkcml2
ZXJzL3N0YWdpbmcvd2Z4L3NjYW4uYyAgIHwgMiArLQogMyBmaWxlcyBjaGFuZ2VkLCAzIGluc2Vy
dGlvbnMoKyksIDEwIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93
ZngvaGlmX3R4LmMgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl90eC5jCmluZGV4IDYzYjQzNzI2
MWViNy4uMTRiN2UwNDc5MTZlIDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl90
eC5jCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX3R4LmMKQEAgLTIyNywxNCArMjI3LDEz
IEBAIGludCBoaWZfd3JpdGVfbWliKHN0cnVjdCB3ZnhfZGV2ICp3ZGV2LCBpbnQgdmlmX2lkLCB1
MTYgbWliX2lkLAogfQogCiBpbnQgaGlmX3NjYW4oc3RydWN0IHdmeF92aWYgKnd2aWYsIHN0cnVj
dCBjZmc4MDIxMV9zY2FuX3JlcXVlc3QgKnJlcSwKLQkgICAgIGludCBjaGFuX3N0YXJ0X2lkeCwg
aW50IGNoYW5fbnVtLCBpbnQgKnRpbWVvdXQpCisJICAgICBpbnQgY2hhbl9zdGFydF9pZHgsIGlu
dCBjaGFuX251bSkKIHsKIAlpbnQgcmV0LCBpOwogCXN0cnVjdCBoaWZfbXNnICpoaWY7CiAJc2l6
ZV90IGJ1Zl9sZW4gPQogCQlzaXplb2Yoc3RydWN0IGhpZl9yZXFfc3RhcnRfc2Nhbl9hbHQpICsg
Y2hhbl9udW0gKiBzaXplb2YodTgpOwogCXN0cnVjdCBoaWZfcmVxX3N0YXJ0X3NjYW5fYWx0ICpi
b2R5ID0gd2Z4X2FsbG9jX2hpZihidWZfbGVuLCAmaGlmKTsKLQlpbnQgdG1vX2NoYW5fZmcsIHRt
b19jaGFuX2JnLCB0bW87CiAKIAlXQVJOKGNoYW5fbnVtID4gSElGX0FQSV9NQVhfTkJfQ0hBTk5F
TFMsICJpbnZhbGlkIHBhcmFtcyIpOwogCVdBUk4ocmVxLT5uX3NzaWRzID4gSElGX0FQSV9NQVhf
TkJfU1NJRFMsICJpbnZhbGlkIHBhcmFtcyIpOwpAQCAtMjY5LDEyICsyNjgsNiBAQCBpbnQgaGlm
X3NjYW4oc3RydWN0IHdmeF92aWYgKnd2aWYsIHN0cnVjdCBjZmc4MDIxMV9zY2FuX3JlcXVlc3Qg
KnJlcSwKIAkJYm9keS0+bnVtX29mX3Byb2JlX3JlcXVlc3RzID0gMjsKIAkJYm9keS0+cHJvYmVf
ZGVsYXkgPSAxMDA7CiAJfQotCXRtb19jaGFuX2JnID0gbGUzMl90b19jcHUoYm9keS0+bWF4X2No
YW5uZWxfdGltZSkgKiBVU0VDX1BFUl9UVTsKLQl0bW9fY2hhbl9mZyA9IDUxMiAqIFVTRUNfUEVS
X1RVICsgYm9keS0+cHJvYmVfZGVsYXk7Ci0JdG1vX2NoYW5fZmcgKj0gYm9keS0+bnVtX29mX3By
b2JlX3JlcXVlc3RzOwotCXRtbyA9IGNoYW5fbnVtICogbWF4KHRtb19jaGFuX2JnLCB0bW9fY2hh
bl9mZykgKyA1MTIgKiBVU0VDX1BFUl9UVTsKLQlpZiAodGltZW91dCkKLQkJKnRpbWVvdXQgPSB1
c2Vjc190b19qaWZmaWVzKHRtbyk7CiAKIAl3ZnhfZmlsbF9oZWFkZXIoaGlmLCB3dmlmLT5pZCwg
SElGX1JFUV9JRF9TVEFSVF9TQ0FOLCBidWZfbGVuKTsKIAlyZXQgPSB3ZnhfY21kX3NlbmQod3Zp
Zi0+d2RldiwgaGlmLCBOVUxMLCAwLCBmYWxzZSk7CmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdp
bmcvd2Z4L2hpZl90eC5oIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfdHguaAppbmRleCAzNTIx
YzU0NWFlNmIuLjQ2ZWVkNmNmYTI0NyAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9o
aWZfdHguaAorKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl90eC5oCkBAIC00MCw3ICs0MCw3
IEBAIGludCBoaWZfcmVhZF9taWIoc3RydWN0IHdmeF9kZXYgKndkZXYsIGludCB2aWZfaWQsIHUx
NiBtaWJfaWQsCiBpbnQgaGlmX3dyaXRlX21pYihzdHJ1Y3Qgd2Z4X2RldiAqd2RldiwgaW50IHZp
Zl9pZCwgdTE2IG1pYl9pZCwKIAkJICB2b2lkICpidWYsIHNpemVfdCBidWZfc2l6ZSk7CiBpbnQg
aGlmX3NjYW4oc3RydWN0IHdmeF92aWYgKnd2aWYsIHN0cnVjdCBjZmc4MDIxMV9zY2FuX3JlcXVl
c3QgKnJlcTgwMjExLAotCSAgICAgaW50IGNoYW5fc3RhcnQsIGludCBjaGFuX251bSwgaW50ICp0
aW1lb3V0KTsKKwkgICAgIGludCBjaGFuX3N0YXJ0LCBpbnQgY2hhbl9udW0pOwogaW50IGhpZl9z
dG9wX3NjYW4oc3RydWN0IHdmeF92aWYgKnd2aWYpOwogaW50IGhpZl9qb2luKHN0cnVjdCB3Znhf
dmlmICp3dmlmLCBjb25zdCBzdHJ1Y3QgaWVlZTgwMjExX2Jzc19jb25mICpjb25mLAogCSAgICAg
c3RydWN0IGllZWU4MDIxMV9jaGFubmVsICpjaGFubmVsLCBjb25zdCB1OCAqc3NpZCwgaW50IHNz
aWRsZW4pOwpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9zY2FuLmMgYi9kcml2ZXJz
L3N0YWdpbmcvd2Z4L3NjYW4uYwppbmRleCA2OTViMDY5NzQxOTQuLjllMmQwODMxN2M5ZSAxMDA2
NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9zY2FuLmMKKysrIGIvZHJpdmVycy9zdGFnaW5n
L3dmeC9zY2FuLmMKQEAgLTU2LDcgKzU2LDcgQEAgc3RhdGljIGludCBzZW5kX3NjYW5fcmVxKHN0
cnVjdCB3ZnhfdmlmICp3dmlmLAogCXdmeF90eF9sb2NrX2ZsdXNoKHd2aWYtPndkZXYpOwogCXd2
aWYtPnNjYW5fYWJvcnQgPSBmYWxzZTsKIAlyZWluaXRfY29tcGxldGlvbigmd3ZpZi0+c2Nhbl9j
b21wbGV0ZSk7Ci0JcmV0ID0gaGlmX3NjYW4od3ZpZiwgcmVxLCBzdGFydF9pZHgsIGkgLSBzdGFy
dF9pZHgsIE5VTEwpOworCXJldCA9IGhpZl9zY2FuKHd2aWYsIHJlcSwgc3RhcnRfaWR4LCBpIC0g
c3RhcnRfaWR4KTsKIAlpZiAocmV0KSB7CiAJCXdmeF90eF91bmxvY2sod3ZpZi0+d2Rldik7CiAJ
CXJldHVybiAtRUlPOwotLSAKMi4zMy4wCgo=
