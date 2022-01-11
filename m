Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3064C48B388
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 18:18:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344155AbiAKRSD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 12:18:03 -0500
Received: from mail-dm6nam08on2041.outbound.protection.outlook.com ([40.107.102.41]:56193
        "EHLO NAM04-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1343981AbiAKRQf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 Jan 2022 12:16:35 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kl74rIAFrCmYM2V3pw6z8+iM4PqMjJzAzgOau58Il2MdU1fjYoOZNsjGugXlGbDz2a5KOBho2g4blPpNdFu92hvRyVKlMnFdK+8cB/N6BcbOo5ngR583OdlAHMwQO2+W/AufSvY6zCqpcRpI4RznAE46bZEBA7e/j3F1Tqo8Xy0wlcs2Kpr4X/jdsq/R/5DUvYj647V3OtZiRq1XvPUX5icoTfoA67JSpmX9uwLNZm7/IIhGt5urKGeMClUJNcIyEnUd6C/ucSwaFslUQzR2y6Mo29sG0WJ0p2rDYxwt5ABN7waVjsMZlM5hZ7Wdx7nJkUYwjJVOoAAIvk4ALVeeVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lePAfxkUqgdQz7jigsgnG9eopt3vSurPsdj6jhUNk68=;
 b=KmFAF4mr/2SxOEahjUtEgFt+Ihq8Bth0JaQNHILEaOP84kzcIAy2yzgKoPUmRUSw10gNCtO/TsJv+YhJs2rs8qVbgtGzNTQ1IJW8HWnD5OlAnNCT7Kof8aQKKWmqdK2llOiY0rc7iXpL76InU0/1hhjkzA6Sit2HI/3WmqJSsPs73eGgPvvF2+6vvsRHLSoQFPdCZmKnc/J+JWPL2jZBKdlbglS9LDApAWK/11uJHLjhAjtiVOgcEKL29kBkEyjCjlIDgfzorvEnbsJV7K0dMk+SeGotsn3LpuS4JATrbOJoapMWEUW/ZQLOVSd8wFD9QMEa2o2V7RwtcHGGTsrn3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lePAfxkUqgdQz7jigsgnG9eopt3vSurPsdj6jhUNk68=;
 b=PAHg953Zl+AOSV+pmNcV9f1+0RXwon9+BCa68ZyDa2tc9yGKH5IecJysilel08r3Tsa1NJw8POjGuhKiPAKFYodg+OVL6BxiFxxIJcqTFyzScY++V+9A+mj9O2E+2BhcYJkhx24LqVqF2AYySWXNhmrE27AykANCs0vgVy1P5ZE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=silabs.com;
Received: from PH0PR11MB5657.namprd11.prod.outlook.com (2603:10b6:510:ee::19)
 by PH0PR11MB5626.namprd11.prod.outlook.com (2603:10b6:510:ee::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.9; Tue, 11 Jan
 2022 17:15:51 +0000
Received: from PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::d031:da9e:71a:73e4]) by PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::d031:da9e:71a:73e4%6]) with mapi id 15.20.4867.012; Tue, 11 Jan 2022
 17:15:51 +0000
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
Subject: [PATCH v9 24/24] wfx: get out from the staging area
Date:   Tue, 11 Jan 2022 18:14:24 +0100
Message-Id: <20220111171424.862764-25-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220111171424.862764-1-Jerome.Pouiller@silabs.com>
References: <20220111171424.862764-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: SN1PR12CA0099.namprd12.prod.outlook.com
 (2603:10b6:802:21::34) To PH0PR11MB5657.namprd11.prod.outlook.com
 (2603:10b6:510:ee::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 894c67b8-9917-4da5-57cc-08d9d52604bb
X-MS-TrafficTypeDiagnostic: PH0PR11MB5626:EE_
X-Microsoft-Antispam-PRVS: <PH0PR11MB562676BCA67CF2CB41A087E393519@PH0PR11MB5626.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: l07boysaGVvmOQWbW2otCZk6BcMagyAwjJe0XNoEbq+2ONGZU3/FUZuwN4nxOYi2djB5UEimi3wvI2U4k+blM2YLjob8CBJNeoN196I8z+OzySX5D2Xovl/lnyqM4bIJr9pdR8f4hkI2KIJZ2b6dcLQpjirvMRsAUjcY3NLhwrLZTfeVupyksg4HKx6UwdBq8ULz9SURMnw2iDcpD5yzSVdDjITyi4TWYu5EUGQ9o9s2uAtMA1MH3lAQvaezKHV5wnuqpgus+Lx0xDre5Lcfzg57Le+yWQAM6q326oKcaM3t7vTJ5mKflTrhzHzdAc6yTgT4eDoGh2Exx28MRej1F9IY14qugv1eUvCR83kcrOTYEzeTbWRcTj1pzX5I7Sqz8GdCMcEO4EBJPbLh9lIfzXkvbnf/JF+c/27GIfRFeL41K12WiAjXc+8josB8NmJl6LmEgqEwTN6T0Gc9VgJrMhMnHup2m11rwDXlTQ7JLGuwj+wtnwQBN46e99ebmCRoJPy+1f1QNzgwQ5ewsiCcn/u4uKnrM+sW6noaBPIiL29+mBtQFDYD8rQ0bTPq54pVs02xTHQnvdeyKeRAx3HxE9mlgI9Up6yO0ZgQBkuGfgSD3cnAOI2rTRKQKp94+TmbTl5HNQC4OlrF0yG+185e+hRdLQl/aFkr/GQPqK6n5pUhUvJExvAeji37WrUwphFz4rz990YbV8R1fhZVru+qhFeRkhoVymw/5awUX2NHP+k=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(1076003)(83380400001)(38100700002)(54906003)(86362001)(8676002)(186003)(508600001)(66574015)(6512007)(6666004)(8936002)(6916009)(966005)(6506007)(36756003)(2616005)(6486002)(52116002)(2906002)(107886003)(4326008)(316002)(5660300002)(7416002)(66556008)(66946007)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VE9KczdjZ0VKRkFuRlN2Nk5jUEYzUnhkVXViVjd1aXV5dlhZd2NQWGpOTE1T?=
 =?utf-8?B?aU1ZZ094U1d2OW5RMUxHMkVndSs3K2IyVWhITjBNOWFzelZTR09lK2tRWCtW?=
 =?utf-8?B?Q25kVVJzcjNzQVlnZWtKQXNZZlV3OWN3VCtmY3h5YXpaL2duenpzTHpiQ1A0?=
 =?utf-8?B?RG5TV0tnUGlSUUp2d0I2bG1wSVRhSER0aUdzeks0MDQrRkxrODZ0ekkyQnpz?=
 =?utf-8?B?bXdFMnlHdCs4WTE3SVEvWTVpN1YwSkpORkNnMjdiT2VKcnlVUzBQcTI5eVhI?=
 =?utf-8?B?NlpvOVpId1ZBZmtqZVV5SFlGVVdFemFwT3ZRSXl1MXQ0TDM2THphSG4yZVds?=
 =?utf-8?B?MUpPZGNMZnQ5YWdpNXFadDdRajlKYVNGMDk5YnFCalpXQTJ5eVAwZzB6cVhz?=
 =?utf-8?B?SzF5Sk5tVU0vM2xZTUtJNjU0L2FhbTVKR3VyaXlwczdrWFl2Q0R2OGNZcU5K?=
 =?utf-8?B?T2xRVnFaMGNkc0h4SEROLzUydU84MXdNdzZRUUlDOEMyK0pHYUptOUpHenA5?=
 =?utf-8?B?QTd4eUlxRDM0T0pLYXV2cFJOK3ZQQjdqL2p4MGpTNndxREp1c0F6a1hxSFRS?=
 =?utf-8?B?RGFOVjJqclVVVTVZbUpsUHhtRm5ONlJXcTY2T0pWOWVWVWlDc1pyU3FrNVN4?=
 =?utf-8?B?c3AwZGF6Z2kxdy9IQjA3UEI4a3pSN2tmMndMclRJUzA0Tm5abUhNNGMrT2l4?=
 =?utf-8?B?S2lKSUR4Lys1OWNDRjB0RDU2dll3aFZTam1RZFFrbVFSWENGV1FsT0hlYUdK?=
 =?utf-8?B?S0dnU0tDakE1aUpJTTYwUXVCcXBRbUFSK2x0SVowdXdxdkk5MVc5MEdsWERa?=
 =?utf-8?B?ckNhb1didGcrdUw3TkRCVEFxOVlQbWptVkMvUXIzVDdZdVJzTFg4M2Y0WnlU?=
 =?utf-8?B?Y0ZvN0VNSWpia1dkcGJHYzN5RElQUjQxSHZTOExLNjdUQit1SDNsRnl3d1Q4?=
 =?utf-8?B?WmxPTFcrTDRnZmxjaWtweTllUzF1K0Z5ZkFvMk1sbEViQ2hqWFRnZE02NkM1?=
 =?utf-8?B?UGRtS1lRQTNtejh0amtGNS95emZ5dkhGYTdHSUZobDljM2w0TVNlOGM1Z3hu?=
 =?utf-8?B?ZVJ3d1R3NGpDb0IxakFIK2xwb1NndjhtVkhpMnRCb3BPbW5Mbnk5ejdLenNX?=
 =?utf-8?B?V2lRamJBUVNiazRtMEtxc3BaWm16dXJmMUs1cExkT21OK3FnVVZqZXArZ2R6?=
 =?utf-8?B?UEkrUnZoemRCT09zcVJEYnBFNGNFYklVRzhpSXcyRnBtZEZtRDFFM3hLaDFO?=
 =?utf-8?B?amJsajRKb3VjTXZCK3ZPRFZSY0c5bEkxaW91Mmx2OXJKbVFKbWxIdkJrT1hP?=
 =?utf-8?B?ZHhYbkNpZFlCdDdrK0UvNHN2Yzh1YmlGaERac3p1K0pTY056Z0d2MjNQcVlQ?=
 =?utf-8?B?Vkd6QTk0ajhONnZpeUFtODJhNDR0TUZSU1NTakZSK3NWcnRwMzdGK0s4S3Fj?=
 =?utf-8?B?alBGNUR5RFR0a2ROYlg3VG9MM0prV21neHQyaXNYRmNKKy9KdElTdDlaQ09R?=
 =?utf-8?B?cmg2UnRRTzJ1dEJ5VkJWU0d3SlpPc1phUlF5QTZEcE54MUl1RU5pSWhFcVZT?=
 =?utf-8?B?dWpqa0pRaUZXRFZCWXVKclNzVzU1UjltSWpMYlp6dlppeEVLRXkxcmdyU2Ez?=
 =?utf-8?B?dlViNnRiVnlwUTl2S3lYUC9ZL1RCSXg4WHExNUpxL3N3dERWS0R2ak83ZFNR?=
 =?utf-8?B?aUFsRUdTNUFxb2NDOWZVTDNPdWxlbEhwdTRjd2VINHlGdmNDdmRXZlZHQTJy?=
 =?utf-8?B?RWYxeDJlZzZlUkVZQkZnT2NweFNFOGtwSVpkajA2SkFkWU5QZk1WbE03c0Vn?=
 =?utf-8?B?UWVMbWhlYUlEZi9YOXlDTm0yZ2hmK2NRc3F3cTFTZTk4U25mNEtHNnIrK1pL?=
 =?utf-8?B?czRodXBFY2NYaXd2VTBTWWFEOHpHNHQ4U2VzL1J3c1haekM3Tk1ydVlqQ1J4?=
 =?utf-8?B?eTlrUnp3QWcvVDlLd3J6QkoxUW9pTnFKVUc3dm5VR1JaNXJEZzd3eW16Zzln?=
 =?utf-8?B?NmRTM3BucXovbVYyVnZZa3Nqdm90ektHZmdueWo2amw2MXplUUtncEZrM250?=
 =?utf-8?B?YmJLaVY2WDA0bXlXNUxEZ3pkR0ZsaVFuNTlkbzVhMDdnOFNTZ3QrWmY0K0lx?=
 =?utf-8?B?WVErYzFGMXhnWTBHWDhmOERoRU0rd0RTbHB3YjJySEpnNE9LOCtKR3A4Z2Q0?=
 =?utf-8?B?ejlkTVppQ0xzbWh6aGx5M0NxaWMrdUdlNStRaUVmRVJuUGxDeHpENHdqakJD?=
 =?utf-8?Q?ib7PSj/hpXUSr9uPv3Sje3x+m3yRr2aVq2OYwTPsIw=3D?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 894c67b8-9917-4da5-57cc-08d9d52604bb
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2022 17:15:51.6526
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vzbV1dVNAMIIskCIgGJ6cP03Wt24tRrr2pLcj1NPdRcCMZkp1WpXFWvmZQTpbdoiXjIzu+hCfV22ZcRrv6XQFQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5626
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVGhl
IHdmeCBkcml2ZXIgaXMgbm93IG1hdHVyZSBlbm91Z2ggdG8gbGVhdmUgdGhlIHN0YWdpbmcgYXJl
YS4KClNpZ25lZC1vZmYtYnk6IErDqXLDtG1lIFBvdWlsbGVyIDxqZXJvbWUucG91aWxsZXJAc2ls
YWJzLmNvbT4KLS0tCiBNQUlOVEFJTkVSUyAgICAgICAgICAgICAgICAgICAgICAgICAgfCAgMyAr
Ky0KIGRyaXZlcnMvbmV0L3dpcmVsZXNzL0tjb25maWcgICAgICAgICB8ICAxICsKIGRyaXZlcnMv
bmV0L3dpcmVsZXNzL01ha2VmaWxlICAgICAgICB8ICAxICsKIGRyaXZlcnMvbmV0L3dpcmVsZXNz
L3NpbGFicy9LY29uZmlnICB8IDE4ICsrKysrKysrKysrKysrKysrKwogZHJpdmVycy9uZXQvd2ly
ZWxlc3Mvc2lsYWJzL01ha2VmaWxlIHwgIDMgKysrCiBkcml2ZXJzL3N0YWdpbmcvS2NvbmZpZyAg
ICAgICAgICAgICAgfCAgMSAtCiBkcml2ZXJzL3N0YWdpbmcvTWFrZWZpbGUgICAgICAgICAgICAg
fCAgMSAtCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L1RPRE8gICAgICAgICAgICAgfCAgNiAtLS0tLS0K
IDggZmlsZXMgY2hhbmdlZCwgMjUgaW5zZXJ0aW9ucygrKSwgOSBkZWxldGlvbnMoLSkKIGNyZWF0
ZSBtb2RlIDEwMDY0NCBkcml2ZXJzL25ldC93aXJlbGVzcy9zaWxhYnMvS2NvbmZpZwogY3JlYXRl
IG1vZGUgMTAwNjQ0IGRyaXZlcnMvbmV0L3dpcmVsZXNzL3NpbGFicy9NYWtlZmlsZQogZGVsZXRl
IG1vZGUgMTAwNjQ0IGRyaXZlcnMvc3RhZ2luZy93ZngvVE9ETwoKZGlmZiAtLWdpdCBhL01BSU5U
QUlORVJTIGIvTUFJTlRBSU5FUlMKaW5kZXggNjhjNTc4NDMyNTk4Li5hMWY0ZjQ3MzJmZTUgMTAw
NjQ0Ci0tLSBhL01BSU5UQUlORVJTCisrKyBiL01BSU5UQUlORVJTCkBAIC0xNzQxNiw3ICsxNzQx
Niw4IEBAIEY6CWRyaXZlcnMvcGxhdGZvcm0veDg2L3RvdWNoc2NyZWVuX2RtaS5jCiBTSUxJQ09O
IExBQlMgV0lSRUxFU1MgRFJJVkVSUyAoZm9yIFdGeHh4IHNlcmllcykKIE06CUrDqXLDtG1lIFBv
dWlsbGVyIDxqZXJvbWUucG91aWxsZXJAc2lsYWJzLmNvbT4KIFM6CVN1cHBvcnRlZAotRjoJZHJp
dmVycy9zdGFnaW5nL3dmeC8KK0Y6CURvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy9u
ZXQvd2lyZWxlc3Mvc2lsYWJzLHdmeC55YW1sCitGOglkcml2ZXJzL25ldC93aXJlbGVzcy9zaWxh
YnMvd2Z4LwogCiBTSUxJQ09OIE1PVElPTiBTTTcxMiBGUkFNRSBCVUZGRVIgRFJJVkVSCiBNOglT
dWRpcCBNdWtoZXJqZWUgPHN1ZGlwbS5tdWtoZXJqZWVAZ21haWwuY29tPgpkaWZmIC0tZ2l0IGEv
ZHJpdmVycy9uZXQvd2lyZWxlc3MvS2NvbmZpZyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL0tjb25m
aWcKaW5kZXggN2FkZDIwMDJmZjRjLi5lNzhmZjdhZjY1MTcgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMv
bmV0L3dpcmVsZXNzL0tjb25maWcKKysrIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvS2NvbmZpZwpA
QCAtMzEsNiArMzEsNyBAQCBzb3VyY2UgImRyaXZlcnMvbmV0L3dpcmVsZXNzL21pY3JvY2hpcC9L
Y29uZmlnIgogc291cmNlICJkcml2ZXJzL25ldC93aXJlbGVzcy9yYWxpbmsvS2NvbmZpZyIKIHNv
dXJjZSAiZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVhbHRlay9LY29uZmlnIgogc291cmNlICJkcml2
ZXJzL25ldC93aXJlbGVzcy9yc2kvS2NvbmZpZyIKK3NvdXJjZSAiZHJpdmVycy9uZXQvd2lyZWxl
c3Mvc2lsYWJzL0tjb25maWciCiBzb3VyY2UgImRyaXZlcnMvbmV0L3dpcmVsZXNzL3N0L0tjb25m
aWciCiBzb3VyY2UgImRyaXZlcnMvbmV0L3dpcmVsZXNzL3RpL0tjb25maWciCiBzb3VyY2UgImRy
aXZlcnMvbmV0L3dpcmVsZXNzL3p5ZGFzL0tjb25maWciCmRpZmYgLS1naXQgYS9kcml2ZXJzL25l
dC93aXJlbGVzcy9NYWtlZmlsZSBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL01ha2VmaWxlCmluZGV4
IDgwYjMyNDQ5OTc4Ni4uNzY4ODVlNWYwZWE3IDEwMDY0NAotLS0gYS9kcml2ZXJzL25ldC93aXJl
bGVzcy9NYWtlZmlsZQorKysgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9NYWtlZmlsZQpAQCAtMTYs
NiArMTYsNyBAQCBvYmotJChDT05GSUdfV0xBTl9WRU5ET1JfTUlDUk9DSElQKSArPSBtaWNyb2No
aXAvCiBvYmotJChDT05GSUdfV0xBTl9WRU5ET1JfUkFMSU5LKSArPSByYWxpbmsvCiBvYmotJChD
T05GSUdfV0xBTl9WRU5ET1JfUkVBTFRFSykgKz0gcmVhbHRlay8KIG9iai0kKENPTkZJR19XTEFO
X1ZFTkRPUl9SU0kpICs9IHJzaS8KK29iai0kKENPTkZJR19XTEFOX1ZFTkRPUl9TSUxBQlMpICs9
IHNpbGFicy8KIG9iai0kKENPTkZJR19XTEFOX1ZFTkRPUl9TVCkgKz0gc3QvCiBvYmotJChDT05G
SUdfV0xBTl9WRU5ET1JfVEkpICs9IHRpLwogb2JqLSQoQ09ORklHX1dMQU5fVkVORE9SX1pZREFT
KSArPSB6eWRhcy8KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3NpbGFicy9LY29u
ZmlnIGIvZHJpdmVycy9uZXQvd2lyZWxlc3Mvc2lsYWJzL0tjb25maWcKbmV3IGZpbGUgbW9kZSAx
MDA2NDQKaW5kZXggMDAwMDAwMDAwMDAwLi42MjYyYTc5OWJmMzYKLS0tIC9kZXYvbnVsbAorKysg
Yi9kcml2ZXJzL25ldC93aXJlbGVzcy9zaWxhYnMvS2NvbmZpZwpAQCAtMCwwICsxLDE4IEBACisj
IFNQRFgtTGljZW5zZS1JZGVudGlmaWVyOiBHUEwtMi4wCisKK2NvbmZpZyBXTEFOX1ZFTkRPUl9T
SUxBQlMKKwlib29sICJTaWxpY29uIExhYm9yYXRvcmllcyBkZXZpY2VzIgorCWRlZmF1bHQgeQor
CWhlbHAKKwkgIElmIHlvdSBoYXZlIGEgd2lyZWxlc3MgY2FyZCBiZWxvbmdpbmcgdG8gdGhpcyBj
bGFzcywgc2F5IFkuCisKKwkgIE5vdGUgdGhhdCB0aGUgYW5zd2VyIHRvIHRoaXMgcXVlc3Rpb24g
ZG9lc24ndCBkaXJlY3RseSBhZmZlY3QgdGhlCisJICBrZXJuZWw6IHNheWluZyBOIHdpbGwganVz
dCBjYXVzZSB0aGUgY29uZmlndXJhdG9yIHRvIHNraXAgYWxsIHRoZQorCSAgcXVlc3Rpb25zIGFi
b3V0IHRoZXNlIGNhcmRzLiBJZiB5b3Ugc2F5IFksIHlvdSB3aWxsIGJlIGFza2VkIGZvcgorCSAg
eW91ciBzcGVjaWZpYyBjYXJkIGluIHRoZSBmb2xsb3dpbmcgcXVlc3Rpb25zLgorCitpZiBXTEFO
X1ZFTkRPUl9TSUxBQlMKKworc291cmNlICJkcml2ZXJzL25ldC93aXJlbGVzcy9zaWxhYnMvd2Z4
L0tjb25maWciCisKK2VuZGlmICMgV0xBTl9WRU5ET1JfU0lMQUJTCmRpZmYgLS1naXQgYS9kcml2
ZXJzL25ldC93aXJlbGVzcy9zaWxhYnMvTWFrZWZpbGUgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9z
aWxhYnMvTWFrZWZpbGUKbmV3IGZpbGUgbW9kZSAxMDA2NDQKaW5kZXggMDAwMDAwMDAwMDAwLi5j
MjI2M2VlMjEwMDYKLS0tIC9kZXYvbnVsbAorKysgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9zaWxh
YnMvTWFrZWZpbGUKQEAgLTAsMCArMSwzIEBACisjIFNQRFgtTGljZW5zZS1JZGVudGlmaWVyOiBH
UEwtMi4wCisKK29iai0kKENPTkZJR19XRlgpICAgICAgKz0gd2Z4LwpkaWZmIC0tZ2l0IGEvZHJp
dmVycy9zdGFnaW5nL0tjb25maWcgYi9kcml2ZXJzL3N0YWdpbmcvS2NvbmZpZwppbmRleCA3ZmVj
ODY5NDYxMzEuLjgxMGU3ZTQ5N2RhOSAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL0tjb25m
aWcKKysrIGIvZHJpdmVycy9zdGFnaW5nL0tjb25maWcKQEAgLTk2LDYgKzk2LDUgQEAgc291cmNl
ICJkcml2ZXJzL3N0YWdpbmcvZmllbGRidXMvS2NvbmZpZyIKIAogc291cmNlICJkcml2ZXJzL3N0
YWdpbmcvcWxnZS9LY29uZmlnIgogCi1zb3VyY2UgImRyaXZlcnMvc3RhZ2luZy93ZngvS2NvbmZp
ZyIKIAogZW5kaWYgIyBTVEFHSU5HCmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvTWFrZWZp
bGUgYi9kcml2ZXJzL3N0YWdpbmcvTWFrZWZpbGUKaW5kZXggZTY2ZTE5YzQ1NDI1Li43ZjZkYmQ4
MmMwMDEgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy9NYWtlZmlsZQorKysgYi9kcml2ZXJz
L3N0YWdpbmcvTWFrZWZpbGUKQEAgLTM4LDQgKzM4LDMgQEAgb2JqLSQoQ09ORklHX1NPQ19NVDc2
MjEpCSs9IG10NzYyMS1kdHMvCiBvYmotJChDT05GSUdfWElMX0FYSVNfRklGTykJKz0gYXhpcy1m
aWZvLwogb2JqLSQoQ09ORklHX0ZJRUxEQlVTX0RFVikgICAgICs9IGZpZWxkYnVzLwogb2JqLSQo
Q09ORklHX1FMR0UpCQkrPSBxbGdlLwotb2JqLSQoQ09ORklHX1dGWCkJCSs9IHdmeC8KZGlmZiAt
LWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93ZngvVE9ETyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvVE9E
TwpkZWxldGVkIGZpbGUgbW9kZSAxMDA2NDQKaW5kZXggMWI0YmMyYWY5NGI2Li4wMDAwMDAwMDAw
MDAKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9UT0RPCisrKyAvZGV2L251bGwKQEAgLTEsNiAr
MCwwIEBACi1UaGlzIGlzIGEgbGlzdCBvZiB0aGluZ3MgdGhhdCBuZWVkIHRvIGJlIGRvbmUgdG8g
Z2V0IHRoaXMgZHJpdmVyIG91dCBvZiB0aGUKLXN0YWdpbmcgZGlyZWN0b3J5LgotCi0gIC0gQXMg
c3VnZ2VzdGVkIGJ5IEZlbGl4LCByYXRlIGNvbnRyb2wgY291bGQgYmUgaW1wcm92ZWQgZm9sbG93
aW5nIHRoaXMgaWRlYToKLSAgICAgICAgaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGttbC8zMDk5
NTU5Lmd2M1E3NUtuTjFAcGMtNDIvCi0KLS0gCjIuMzQuMQoK
