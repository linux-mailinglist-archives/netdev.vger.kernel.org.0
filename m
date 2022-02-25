Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD0F34C4376
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 12:25:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240100AbiBYLZ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 06:25:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240105AbiBYLZ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 06:25:26 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam08on2056.outbound.protection.outlook.com [40.107.100.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F5B41DBA91;
        Fri, 25 Feb 2022 03:24:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T0IzxDssojy0s0/kNJLPqddgCTscyaTVgcUXJk3WwnQl4f79r8A+KMNIITf+AwCAWu8ZlvTcV2SB4KDh1dNG4doZnUIfUXLL3NPZ35HZTfSnl0utko6GB/gtmIZ8HOy98cBQwThZToVdQNFYb9V+wPuvE5lOmXquhctgpqj5PPBqWIji15ECt1vXOdfYjjwIEmOKsm7POBM8wV7LLZmMYTK927tB3HXe15HAKNOWMarCXfhNLlonVJP/d5qQJlupPj4QHPt/xE//Q9z5Ep5OEV363DlT2Ssn0oabYPrIFJO39POpf/xYU8U+3wBXb5eC9Wn9n3eVJfW3j7J1rHgofg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=028fwsTfDIyITA6iQaqifK+WmjUP+SPDAeGTjiM6TDU=;
 b=QIRVeONeDiwyoyqRQrgw9qvhiB0kB6bqexXpWCEbUGTxDrKMSGTqMRB/mq5I9byNhC+/XIPdt214Oq9sCJrdCX3gxK368oZTyfXs0Ei2EJtkSAChv7ZLGKJKBYDua7Pg8Qsv7emrBk/11eN/r0QhkK8XbM0OtC0xHLUd3d0t9St5NR6ZedDA5DIMrMa5DqzG64tHnyY7rB4egRSisYkYNlsT24c6ICm57n9rSxY3FHqTAVX1KJ533meDRAUH97Bpwo7UKFs41YQHd6gtE2TOFNbxV1VkFSIgEUcCvQncPL4iJGpExaQnR3bo+GY7iCmJCUl6bzTHM6f//9OYvYvMUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=028fwsTfDIyITA6iQaqifK+WmjUP+SPDAeGTjiM6TDU=;
 b=NMGEkD65IA39wQh2FfyaONzgpyM9KFOaatZZ3MKD3Q4n414ukoIPuKiDY/a0UW/l9F6dDve3WL8kmNAafXH0JRDNauPbYKhgeMit2EfIFdK9srKJ7LWinyW7dQR7+a0gVceIa7dByzmaabTOaPosO5c8ojVBup/co9j2lAf8wi8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=silabs.com;
Received: from PH0PR11MB5657.namprd11.prod.outlook.com (2603:10b6:510:ee::19)
 by DM6PR11MB4362.namprd11.prod.outlook.com (2603:10b6:5:1dd::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.22; Fri, 25 Feb
 2022 11:24:41 +0000
Received: from PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::dd2e:8a4e:fc77:1e66]) by PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::dd2e:8a4e:fc77:1e66%5]) with mapi id 15.20.5017.023; Fri, 25 Feb 2022
 11:24:41 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     linux-wireless@vger.kernel.org, Kalle Valo <kvalo@kernel.org>
Cc:     devel@driverdev.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 03/10] staging: wfx: format comments on 100 columns
Date:   Fri, 25 Feb 2022 12:23:58 +0100
Message-Id: <20220225112405.355599-4-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220225112405.355599-1-Jerome.Pouiller@silabs.com>
References: <20220225112405.355599-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PR3P189CA0052.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:102:53::27) To PH0PR11MB5657.namprd11.prod.outlook.com
 (2603:10b6:510:ee::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8e236a48-cd28-41a1-8250-08d9f8516a02
X-MS-TrafficTypeDiagnostic: DM6PR11MB4362:EE_
X-Microsoft-Antispam-PRVS: <DM6PR11MB43624634C88AE28FCF33BA75933E9@DM6PR11MB4362.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uStitFjVazwJCymupZaVSIEEQZPWRP+ufbyfCuL0lEy0M7S4JOAFhLswoJsFfbNAaHKPTJZzLgZpHYGYr0wc9t7FbzJgbIJdZI1dWe3J0jWiqHHpDZJJE/9/8gkynTkpv/H5sfPtUIiiuZ5pFSiU2rct/e8ExEMZKnSvRRDa7p6UJV1S6ILXCTV8bt/mgvynawvO72mMLLYzhTuPwm51U7+qkpf33QDFwxQCA86RbIA5sqCdzl/b67IKfDDmCW+Uf2licJ5qVsGGdSaQX0B4bjVtXnk+VZMFIFRkwlB6DiIfmE/ETT/RqaCWJj+PoIXo1Ylc8jxAzl+EO5mP9gp014+BXGsO7DWN+E8c1jt7tuWQjliKVLssYQYokDHrlli7tchaLSBasfalRYI1PWbCy61bpv6MPjQD8xBDOn37TeYosdIIFjx1G0IaOEe978FkNiTsh8ERNVq6MV5o8VHOawEjaHDz4Jqr7enW1rX3Ml7VGOiDV0bWqwYHBdc20gbS6WG5dpjr11yfIm9YaNwcHmVmCv5EeuUVMesO7ekOAannFpCMmbKW2gfc7ZBxpuKX8izbol2bUp/yy1M+inZatv9KRszgAGEuZcA87Fvj1BlNi1esHO26xudtrmFPEV0XAnSI3kE7JhLso0g70qhLjdPOu5LznILPCumYexBGGrrcBdel2UlrN4lCYSGioHERoqHj4ESv+meoHXQ/bfAhWkMsT0ct4rYDCiaero74R2977zpcuLesWm87v9yqHDNP
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6512007)(6506007)(1076003)(66946007)(52116002)(8676002)(2616005)(66574015)(26005)(66476007)(5660300002)(66556008)(508600001)(2906002)(83380400001)(54906003)(38100700002)(4326008)(86362001)(6486002)(8936002)(186003)(6666004)(107886003)(36756003)(316002)(38350700002)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TnRHbFF6WTdrQmVRcFQ1cGZVQUdhTHY1RmdIWng3YXU1RDR6Q2lTcDQ3K3Jx?=
 =?utf-8?B?Wlo1bEFXVnRxb3FEZDJMQXlGVFo5Q0ViajQzdTdmZ1pMYk1Wam5BWi8zdEpt?=
 =?utf-8?B?MThGdHpRZTZXZWQ1Y0VCOG54a1FqLzA3VXNKaGd4OG9wNnhxbHoyVTVBK3B4?=
 =?utf-8?B?eTVwL1FXS0tCR2MrYzZmR3krV2M5YVc5Y25kKzdlVjBUelBaM0FCTTl2NVR1?=
 =?utf-8?B?cUhpRmlBMldQMDVTTld2L21LSTFDSzBzaTFDZ0NYOEh5d2ZIblBibC9jRDJn?=
 =?utf-8?B?OS9TNWJaTUw1SnR0U1NLUnlnYm9vcWc5M0lqdlE0eFNjNDI3VjZqcHh0dmIw?=
 =?utf-8?B?MUZ2b253ZUo3VTFEdHNaT1Fuc1ZSdFpJa01DSVc4WEpBYzRwanhleXFoOTR3?=
 =?utf-8?B?WDgraStKU09MSkxtRDFZZjYyYVZtY1BWVXN3aXByZ3Z2ZE1DNFpnSHJ5ZUFS?=
 =?utf-8?B?WHBGU1ZURjUwK2REbnd1TlVwYmpGNU1jZkFyU0tpNmpuL2dsSzN6QmtIdEd5?=
 =?utf-8?B?ZHp6bGRDRU5UQTNpUEhQUU9udDRyT1E3Y09FeTFDVXUzdzc0VWppMm9NMHlz?=
 =?utf-8?B?N2hLUVFOUGpGOFptVFgyRkFRWTEzTy9NMkFnbmt1amVZbUMrUnF3Q2lvWUxn?=
 =?utf-8?B?ejhyWGVHTEFnUmZQK3k3YlZVZWtNM1JCbHZFL2liNDg1SlFqMHV6YXRNc09D?=
 =?utf-8?B?Vk1RdGdzV0VjVzF0b0MwSndzRnlxTXFLY3hBTTNJVHhHN2JMNmdEWHZyLzEz?=
 =?utf-8?B?b01UdWJnMlVWK2NMQ0FmY3p3UFZ1RHlzUWV0VUh3bExodndwYkgxU0w1RnQ2?=
 =?utf-8?B?b3lEN2d4aE1JVHZXZGcrWmIxWXpBRW4zMm5hSE84V1FaSG1SaTZjK2FEOHNL?=
 =?utf-8?B?SUpnblVsa21xNk1Ea2hBMVUxakxwMElTS29sU1BLUG11TTR4ZmNVano3dlAr?=
 =?utf-8?B?NCtuUjNLSjhiVk4wU1lPL081cWNUdTMwcTNLdzEzei9TaXZxR2xrd1pRV0Vn?=
 =?utf-8?B?NFI4aVZDUG9PL0YxQndOcysxQ1lLcU41Y1FVN05qUGo1eHFLZTJ2TVUyVnhm?=
 =?utf-8?B?b05JdHJuM3lhQndKS3lLa2t4S3dtN0hBYnd4K2RXdzdWU1dObmc0S2lEdkli?=
 =?utf-8?B?VDYyQ0YzdjhXaTN6V041UU9QRWtsczc4K0RmWUhYN05FdUNsbWZzUUd1dlE0?=
 =?utf-8?B?bGliN2IzZTRqZW1ETnI3bDlZeDY3NlpNNWRWVVFyWmQzeHZ6VTdSNzJIV2pK?=
 =?utf-8?B?SmhIUnBVMzM5NGlUR2tvWU5NVlJhdlQxSWhxMVV6TkNldWFBeWczUFB6cWgz?=
 =?utf-8?B?YXp2dUUvQWdnVjhYRjZZQkFndEcxV1JBNnlEVC80RE5sL0MycGlMdEtDUGI5?=
 =?utf-8?B?OFdJWlc2U0h3V2xOK012YldaSzBGOU5ZK24wQ0E1UlVpWTNtWFp2Q0FqdmdS?=
 =?utf-8?B?N09wUnZaejVmeXNSdTVyNkRhTEtpbzc2ZU4xU1RDeDlDenNpSTRuK09LRmk3?=
 =?utf-8?B?Q1YwUzlTMy9ybDZlS2lyVzE4bEp4M3A1R1NWeSt3YWlBQ2VFWUw4bGNobDFp?=
 =?utf-8?B?M1d0NW1hSUFBUURIT3ZHanVLMUNTOHNoZm5aSDVCMjJ0aVBLem96NUdwSEtl?=
 =?utf-8?B?YjRBVEpUU0o4U2FtV0NPblR0ZlgyMFl1VUt0QVN5UFBXSVQ1ZXhtUG4xQjlx?=
 =?utf-8?B?TCtyTDJSbVN1Wk1FMmtMMTJzMjd2YUhpY21za0ZhZ3FFZ3hFTm9OYzdUZERn?=
 =?utf-8?B?VW15Y1hLcUxBd2NwaUlPNFBRK2tsRWJPL3RiVExpK3JQTlNqdkxOK1pTbVcw?=
 =?utf-8?B?RkVBZFY5SE1TS2gvN1FZVGU5WUh4cTNoT1pNWStMd25VeU0rUU9rVWJ6ZGNV?=
 =?utf-8?B?ZlFNcXJRU1EzU2ZVTFIrTDIvVXdNNWE4ejgxVW1QQVRSRjlhZGVQRnkrYXFZ?=
 =?utf-8?B?VGg3eFJtTHBzaVBVUkhHWE8xSFV4MjRvTUsrQnFGMFpXZFZyK3hGcTlQaVIw?=
 =?utf-8?B?VzFYUG84YlFidm1kSm55TnRnVnJ2OWpDK3czSDBlWTgwcVBuMHBLUFlUeHpy?=
 =?utf-8?B?Vk9BcytkZzlGclphMW84Q1pIZTMyaVNkeHE0Rk1rNjJhc2dUVzdoZkF3Tzl0?=
 =?utf-8?B?U1ZvVGNWNWVjRXdsb2ZjS1ZaU2lVMlE3VVA3cC9QZFhxTkZIdUdjaXBiN0lR?=
 =?utf-8?Q?rDixQRmD1SCcrvYCzlrs8Ss=3D?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e236a48-cd28-41a1-8250-08d9f8516a02
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2022 11:24:40.5453
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WD3kmLrIpsxNlv1kplirVznwDkyJdrnzgfooO2dcPtO6dvXQZUVvbdRPuwDt8fSgYYBhMt67j6ObgVjR43RGZw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4362
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKQSBm
ZXcgY29tbWVudHMgd2VyZSBub3QgeWV0IGZvcm1hdHRlZCBvbiAxMDAgY29sdW1ucy4KClNpZ25l
ZC1vZmYtYnk6IErDqXLDtG1lIFBvdWlsbGVyIDxqZXJvbWUucG91aWxsZXJAc2lsYWJzLmNvbT4K
LS0tCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L2RhdGFfdHguYyB8IDggKystLS0tLS0KIGRyaXZlcnMv
c3RhZ2luZy93ZngvcXVldWUuYyAgIHwgOSArKysrLS0tLS0KIDIgZmlsZXMgY2hhbmdlZCwgNiBp
bnNlcnRpb25zKCspLCAxMSBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdp
bmcvd2Z4L2RhdGFfdHguYyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvZGF0YV90eC5jCmluZGV4IGQ3
YmNmM2JhZTA4YS4uZTA3MzgxYjJmZjRkIDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4
L2RhdGFfdHguYworKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2RhdGFfdHguYwpAQCAtMTE3LDkg
KzExNyw3IEBAIHN0YXRpYyBpbnQgd2Z4X3R4X3BvbGljeV9nZXQoc3RydWN0IHdmeF92aWYgKnd2
aWYsIHN0cnVjdCBpZWVlODAyMTFfdHhfcmF0ZSAqcmF0CiAJaWYgKGlkeCA+PSAwKSB7CiAJCSpy
ZW5ldyA9IGZhbHNlOwogCX0gZWxzZSB7Ci0JCS8qIElmIHBvbGljeSBpcyBub3QgZm91bmQgY3Jl
YXRlIGEgbmV3IG9uZSB1c2luZyB0aGUgb2xkZXN0Ci0JCSAqIGVudHJ5IGluICJmcmVlIiBsaXN0
Ci0JCSAqLworCQkvKiBJZiBwb2xpY3kgaXMgbm90IGZvdW5kIGNyZWF0ZSBhIG5ldyBvbmUgdXNp
bmcgdGhlIG9sZGVzdCBlbnRyeSBpbiAiZnJlZSIgbGlzdCAqLwogCQkqcmVuZXcgPSB0cnVlOwog
CQllbnRyeSA9IGxpc3RfZW50cnkoY2FjaGUtPmZyZWUucHJldiwgc3RydWN0IHdmeF90eF9wb2xp
Y3ksIGxpbmspOwogCQltZW1jcHkoZW50cnktPnJhdGVzLCB3YW50ZWQucmF0ZXMsIHNpemVvZihl
bnRyeS0+cmF0ZXMpKTsKQEAgLTQ5NCw5ICs0OTIsNyBAQCB2b2lkIHdmeF90eF9jb25maXJtX2Ni
KHN0cnVjdCB3ZnhfZGV2ICp3ZGV2LCBjb25zdCBzdHJ1Y3Qgd2Z4X2hpZl9jbmZfdHggKmFyZykK
IAl3ZnhfdHhfZmlsbF9yYXRlcyh3ZGV2LCB0eF9pbmZvLCBhcmcpOwogCXNrYl90cmltKHNrYiwg
c2tiLT5sZW4gLSB0eF9wcml2LT5pY3Zfc2l6ZSk7CiAKLQkvKiBGcm9tIG5vdywgeW91IGNhbiB0
b3VjaCB0byB0eF9pbmZvLT5zdGF0dXMsIGJ1dCBkbyBub3QgdG91Y2ggdG8KLQkgKiB0eF9wcml2
IGFueW1vcmUKLQkgKi8KKwkvKiBGcm9tIG5vdywgeW91IGNhbiB0b3VjaCB0byB0eF9pbmZvLT5z
dGF0dXMsIGJ1dCBkbyBub3QgdG91Y2ggdG8gdHhfcHJpdiBhbnltb3JlICovCiAJLyogRklYTUU6
IHVzZSBpZWVlODAyMTFfdHhfaW5mb19jbGVhcl9zdGF0dXMoKSAqLwogCW1lbXNldCh0eF9pbmZv
LT5yYXRlX2RyaXZlcl9kYXRhLCAwLCBzaXplb2YodHhfaW5mby0+cmF0ZV9kcml2ZXJfZGF0YSkp
OwogCW1lbXNldCh0eF9pbmZvLT5wYWQsIDAsIHNpemVvZih0eF9pbmZvLT5wYWQpKTsKZGlmZiAt
LWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93ZngvcXVldWUuYyBiL2RyaXZlcnMvc3RhZ2luZy93Zngv
cXVldWUuYwppbmRleCA5MTg2NzI2ZmYwN2YuLjcyOTgyNTIzMGRiMiAxMDA2NDQKLS0tIGEvZHJp
dmVycy9zdGFnaW5nL3dmeC9xdWV1ZS5jCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvcXVldWUu
YwpAQCAtMjEwLDggKzIxMCw4IEBAIGJvb2wgd2Z4X3R4X3F1ZXVlc19oYXNfY2FiKHN0cnVjdCB3
ZnhfdmlmICp3dmlmKQogCWlmICh3dmlmLT52aWYtPnR5cGUgIT0gTkw4MDIxMV9JRlRZUEVfQVAp
CiAJCXJldHVybiBmYWxzZTsKIAlmb3IgKGkgPSAwOyBpIDwgSUVFRTgwMjExX05VTV9BQ1M7ICsr
aSkKLQkJLyogTm90ZTogc2luY2Ugb25seSBBUCBjYW4gaGF2ZSBtY2FzdCBmcmFtZXMgaW4gcXVl
dWUgYW5kIG9ubHkKLQkJICogb25lIHZpZiBjYW4gYmUgQVAsIGFsbCBxdWV1ZWQgZnJhbWVzIGhh
cyBzYW1lIGludGVyZmFjZSBpZAorCQkvKiBOb3RlOiBzaW5jZSBvbmx5IEFQIGNhbiBoYXZlIG1j
YXN0IGZyYW1lcyBpbiBxdWV1ZSBhbmQgb25seSBvbmUgdmlmIGNhbiBiZSBBUCwKKwkJICogYWxs
IHF1ZXVlZCBmcmFtZXMgaGFzIHNhbWUgaW50ZXJmYWNlIGlkCiAJCSAqLwogCQlpZiAoIXNrYl9x
dWV1ZV9lbXB0eV9sb2NrbGVzcygmd3ZpZi0+dHhfcXVldWVbaV0uY2FiKSkKIAkJCXJldHVybiB0
cnVlOwpAQCAtMjUzLDkgKzI1Myw4IEBAIHN0YXRpYyBzdHJ1Y3Qgc2tfYnVmZiAqd2Z4X3R4X3F1
ZXVlc19nZXRfc2tiKHN0cnVjdCB3ZnhfZGV2ICp3ZGV2KQogCQkJc2tiID0gc2tiX2RlcXVldWUo
JnF1ZXVlc1tpXS0+Y2FiKTsKIAkJCWlmICghc2tiKQogCQkJCWNvbnRpbnVlOwotCQkJLyogTm90
ZTogc2luY2Ugb25seSBBUCBjYW4gaGF2ZSBtY2FzdCBmcmFtZXMgaW4gcXVldWUKLQkJCSAqIGFu
ZCBvbmx5IG9uZSB2aWYgY2FuIGJlIEFQLCBhbGwgcXVldWVkIGZyYW1lcyBoYXMKLQkJCSAqIHNh
bWUgaW50ZXJmYWNlIGlkCisJCQkvKiBOb3RlOiBzaW5jZSBvbmx5IEFQIGNhbiBoYXZlIG1jYXN0
IGZyYW1lcyBpbiBxdWV1ZSBhbmQgb25seSBvbmUgdmlmIGNhbgorCQkJICogYmUgQVAsIGFsbCBx
dWV1ZWQgZnJhbWVzIGhhcyBzYW1lIGludGVyZmFjZSBpZAogCQkJICovCiAJCQloaWYgPSAoc3Ry
dWN0IHdmeF9oaWZfbXNnICopc2tiLT5kYXRhOwogCQkJV0FSTl9PTihoaWYtPmludGVyZmFjZSAh
PSB3dmlmLT5pZCk7Ci0tIAoyLjM0LjEKCg==
