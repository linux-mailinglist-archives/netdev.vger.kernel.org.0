Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BE974229BB
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 15:58:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236305AbhJEOAZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 10:00:25 -0400
Received: from mail-co1nam11on2088.outbound.protection.outlook.com ([40.107.220.88]:52640
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236513AbhJEN6f (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Oct 2021 09:58:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XTnpev+gH5Zwe7KlxJ3ptFM3oKDCxKl6AoXfcGWU3hAZ3V+ioVbEVI1z2w/1KURL905yKFVg4EYBdpM5CVdFTT8/wtSIG4rDJPFtF73bKX7c32P5xTb6WqQzf4nahoAfZwgXLLo80rle3Z2XlLh+IPTuQiORdvFa88EYflL14CUozJ0spBE+tsIMtPmMVyKQ3mU98ryBZayYPcRYHXT1nP89ifckMiiut1el6LZDsatlfbcI1HgK3SkNsUUWU5CZ6YB05rltFxGohj3vB0DbRPOwyEtvzPRQkh4D66rMJIT6+D8hJFSxbDWMqTZEAU5vl5dwhFkHy7IhqjajIXQzqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mUblQj3HYl3up8TQr4oInUGypnja+FbX2pQYP1SXPC0=;
 b=YxebN2qWYVdhZlJ8YyeAWVpu6TlsU9X05xTqaW1ZcEA9xtsIG11ErSYHyFH/nn4mOV0+iqXLal4EXLi2wqKNj1XEJ3t2JkjyT1OMbF7yF1fQpTcBJRMX2NN2AnHzuqD0raWariftZ0t3hnZPWdvGcfU4k8WQoEELnTe1fGa6kFSIrkv5osT2LjGrtp11tVTz3Zcpj9xAerz130KHCRt6BeMTgpfS5nmVnDOohkgnGGmssi0pimoSdfpdPMh42WHxAmwfJYXg5dk2t4cmSK9BlHN0nFTodWM3hrzeb0iyiEiZTWf0nx+KWG4ghyz3DfYRMCwIsLAP8WugrAd9bg+joA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mUblQj3HYl3up8TQr4oInUGypnja+FbX2pQYP1SXPC0=;
 b=QG+CWobL3kUbTPSTDXo4rFT8L48ERej7DlyEjkjmvXqGCJ5ySrLG58acORH8U+QpjpW+HpTsOxCt3Py+YrzRFpiqWDKBH26QjMeR5X9d3gjfwaQyyB7YlVPbaQ/syHcssvKKitUS0s6FuGnXJ4h8TaZNaWgCvVBC9Hplz+VxuCQ=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=silabs.com;
Received: from PH0PR11MB5657.namprd11.prod.outlook.com (2603:10b6:510:ee::19)
 by PH0PR11MB5642.namprd11.prod.outlook.com (2603:10b6:510:e5::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14; Tue, 5 Oct
 2021 13:55:31 +0000
Received: from PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::31cb:3b13:b0e8:d8f4]) by PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::31cb:3b13:b0e8:d8f4%9]) with mapi id 15.20.4566.022; Tue, 5 Oct 2021
 13:55:31 +0000
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
Subject: [PATCH v8 24/24] wfx: get out from the staging area
Date:   Tue,  5 Oct 2021 15:54:00 +0200
Message-Id: <20211005135400.788058-25-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211005135400.788058-1-Jerome.Pouiller@silabs.com>
References: <20211005135400.788058-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PR3P189CA0084.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:102:b4::29) To PH0PR11MB5657.namprd11.prod.outlook.com
 (2603:10b6:510:ee::19)
MIME-Version: 1.0
Received: from pc-42.silabs.com (37.71.187.125) by PR3P189CA0084.EURP189.PROD.OUTLOOK.COM (2603:10a6:102:b4::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14 via Frontend Transport; Tue, 5 Oct 2021 13:55:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0c6d2e2c-5b7d-477c-95c0-08d98807cb8c
X-MS-TrafficTypeDiagnostic: PH0PR11MB5642:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR11MB5642BD82AC72745413E7FAF293AF9@PH0PR11MB5642.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xUQHCprZPBpinXTprTwZ2KUEgvlWwVFswo+7fthAKFIe/qSeb4uqh41I0dTJs2gkccCK9lDOcPay/Payf9ino41rPYU2DgoFZr/7XoqR0EL/OwCCdFArQ1IoSLWiJfcTIv/+7J1pyox3Z50TKZrHRqCGjcowWtDn+x7qKIwZI3bxazruSWMOa62mUkuRQyYJFywM6WH1zlyjW4KRplFMtoYUMnw/32+NXjbdknoahfoQee+ZJGYcn9nQhjyJzOrghoXHPwJKaJmIJ5elbBSaNpinXDiL9VlAy9r1JgkkJDHduWPlKy46R1UeZb3b5FWLcZfejtQiH7f2/21KJpnMClXRr4OmJg9e37Tn5N8DA4UIP3X9LJYLsOm1ppP0+sdd6714rhf45OZ628K6kwKsTAJlZs28+dJsCoHhQFeH8xYg83JBc+WeC606eQ3TCgoac3RvfnDSaVUBouAIiqiindagO+LzcblthRjwgG1z5yUWppGwbjN6rMxaWrVf89qYqHmCugRxrx6dwGYmphvDLvNMsGtDj3EXOEMIqsDJp3QYYUHj8gEaSf5eOE7Kv0q0BZO0nZEeCqECXjskZGEOxRvd1C1c4l175hLA/MtaE81n4fDM1DQ4YRMs/IytKU+GHcDE2evelL0eZDVFTsGLFcjIFbCBsAWJimk7+aec0+pL4ccmvLMaMHG1mZP9MQSopjiE/O+lTzqBZckhO/M4+rfqJ7+8bFInLMLVMZ9Y9X4/yGFWenLRkefdzktSPqZ77FRGAS8mSANeBFUClMZofgjhnlxrKRuMP7CMaDo8NQ4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(86362001)(5660300002)(26005)(52116002)(7696005)(956004)(8676002)(2616005)(38100700002)(8936002)(38350700002)(4326008)(6666004)(186003)(7416002)(6916009)(66574015)(107886003)(83380400001)(36756003)(66476007)(66556008)(508600001)(2906002)(966005)(316002)(6486002)(1076003)(66946007)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?b1lVaHdNOUJwT295R3A1OWJiTXRzTUpnNkpyQlNvTUhTL0RIZ1Nnb2xEV001?=
 =?utf-8?B?MTV2bjZnVWsweWIrZGt1RGtNUzNBUGRNbGwzOVcyQlEzQy9RLzdJTGRTZWJP?=
 =?utf-8?B?eWxpN204RUlhakdCVkk4VTZzY29XN25TUW1TK3B0QWZNVHpZSE5KQXdkVlFs?=
 =?utf-8?B?SHdXWVViNXJVTTR0aTlZVFpWbVFpZmhyL2FVNVdaUFgwOWppMlIxdU9IRWpB?=
 =?utf-8?B?c3h5V2pDQU51N3o2L05rWTV3UVAxbmtBTzJpMDhzQzkvOW1zekFUa0s0VjU4?=
 =?utf-8?B?Zm9vR2QxcWhMZEk3V1V0VU0yQnRYM0QycGd0R0lGR3BzS2FXM2p3NXJyNDQy?=
 =?utf-8?B?S3V6WHcxNTV6TXNLYnZkTi9IMTVob1RKSTRMRk1CcXd6dWFoR2I2b041ay9i?=
 =?utf-8?B?Q1NHQ0JZODBFckU3Zm1WNU1jaXZwT2FBeFlYNkxycFdhblJyczd1YWNCd2Ji?=
 =?utf-8?B?aVFlZWZ3bUZnUUNuQi9wMlNobnBDSEVFYUtMaU1lL0ZNYjdCZ2psa256S0dT?=
 =?utf-8?B?dk1PQk8yeEp4YS9CaG8yRHZxV3dCZ0dYZ2Y0anlqdmdlN3ZZM3hxaWsrdUgy?=
 =?utf-8?B?TUpJc0NrVERXYlZGMWYxeWpJeFJXOTl3UzN2YUFUaUhsNGFsRURFT0Z2ajNX?=
 =?utf-8?B?S1I3NkxzUW1SQU1oeUlDV01GcUoybkw4UlptZms0OWtOZzBuUEFIeDRDOEtK?=
 =?utf-8?B?cG9HN3R2Vm8wdnp6TGZXeVYreVd0aXdMRjBuL1VLS2xvQ29VNmozWXZhQWRh?=
 =?utf-8?B?Q2hDZGNrTmxqZmlTazk1dmloNFZqajBIM25INjBDTzk0OVNGc0pUNWgySWJZ?=
 =?utf-8?B?eHEveVFwU2s4eFZIY2p1UmxJR2t5YjVJbzhqM1duODN3TE1zNkxDdlpZeG9L?=
 =?utf-8?B?VnM2WDduREY1RlBTbmZWMnErM01TTGdGMHJIM01yMG5MbXpSWkdIS1d6ejVG?=
 =?utf-8?B?cFNaU3NLdVR1RnVwYTF1aEZRWkNVVHJzeGFSdCtLNkFJUUYzVldObEJJN25S?=
 =?utf-8?B?by9ZUUNCTnpKOFpxQzdmeXdkSjRTUUUxblVtSGdhOUFOakpGYzZLVnRXTmtv?=
 =?utf-8?B?US9vYisraXU5T2Zzd1NWaDg3eFkwaDZxUHE1MHdlQktjT3ZtSGNnK2JhTUdt?=
 =?utf-8?B?dGxLU2FDQWtGdm1oVDlzTTdiTnI4eEhlc00wc1ZXQkxmdVFhZzdLM2dTRGxa?=
 =?utf-8?B?WFF0bW9rQzE2YXFSOWZnbEVaV3RNelc5ZU1VYmUzQVpLS20wckxSUUl3RkEx?=
 =?utf-8?B?b1Q0S3JEQ3Q1Sk1xUDNIeHVwV2djSzNTbGQzSC81QW5CZ3V6TCtSelJoS3Bt?=
 =?utf-8?B?WndvOHB2REYyTHhJS0lOUXE2T3g5TEtZQ3VsVWJ2SG9kRmJmbUUyVlNYemVD?=
 =?utf-8?B?Q0hmTGZuVlpWQWNQZ3RzeVh0Vkh2YmJVc0kyUFNLRVNhK1pYUE1yT3JWeElk?=
 =?utf-8?B?MEdGLzlRR0VrMjNuTlFiYnlLOHZZMHAvSHREbVVGS2tEeG91cTI0eFVqQ1pE?=
 =?utf-8?B?dEMrTEx1SU1IY0xIay9oUkhjeE1iOUJiMDVtWEhNUElZa2VmQWdjZHF6cXRD?=
 =?utf-8?B?UjFwM3NRanVRZUJFcmcrL3pvNHpTdVo5Mng4QWUzVC90Z2EzNkg5eHJHU1NI?=
 =?utf-8?B?WE9VRDdRbGptZmFFNk5NaUMvTGtZUG5CQTZuY0hDbjlhYm96c1lmbFhuNmhl?=
 =?utf-8?B?QUZlQkZPKzBGUDdqSkNveVpHVkk3OXp4Q0dSQkU2cmxNU0NPeDkrejF3eCtH?=
 =?utf-8?Q?25xGkXv671MSJCgShNvYR8o2WRTz3eoZ+/8rh5Y?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c6d2e2c-5b7d-477c-95c0-08d98807cb8c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2021 13:55:31.2883
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jRS0n0FPiMKicj7oMoH70vCeDtZqyoox7V9N1d7K592qt7acT6J1B6Ln7VX20yNog+q07Y4wtyo0EmUPXiQzdw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5642
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
QUlORVJTIGIvTUFJTlRBSU5FUlMKaW5kZXggZWViNGM3MGIzZDViLi41MTk5M2Y2ODM3OWEgMTAw
NjQ0Ci0tLSBhL01BSU5UQUlORVJTCisrKyBiL01BSU5UQUlORVJTCkBAIC0xNzA5OSw3ICsxNzA5
OSw4IEBAIEY6CWRyaXZlcnMvcGxhdGZvcm0veDg2L3RvdWNoc2NyZWVuX2RtaS5jCiBTSUxJQ09O
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
dmVycy9zdGFnaW5nL0tjb25maWcgYi9kcml2ZXJzL3N0YWdpbmcvS2NvbmZpZwppbmRleCBlMDM2
MjdhZDQ0NjAuLjY2NmUyM2EzY2U3ZSAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL0tjb25m
aWcKKysrIGIvZHJpdmVycy9zdGFnaW5nL0tjb25maWcKQEAgLTEwMCw2ICsxMDAsNSBAQCBzb3Vy
Y2UgImRyaXZlcnMvc3RhZ2luZy9maWVsZGJ1cy9LY29uZmlnIgogCiBzb3VyY2UgImRyaXZlcnMv
c3RhZ2luZy9xbGdlL0tjb25maWciCiAKLXNvdXJjZSAiZHJpdmVycy9zdGFnaW5nL3dmeC9LY29u
ZmlnIgogCiBlbmRpZiAjIFNUQUdJTkcKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy9NYWtl
ZmlsZSBiL2RyaXZlcnMvc3RhZ2luZy9NYWtlZmlsZQppbmRleCBjN2Y4ZDhkOGRkMTEuLjUyYTBh
ZTFlMWE1MiAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL01ha2VmaWxlCisrKyBiL2RyaXZl
cnMvc3RhZ2luZy9NYWtlZmlsZQpAQCAtNDAsNCArNDAsMyBAQCBvYmotJChDT05GSUdfU09DX01U
NzYyMSkJKz0gbXQ3NjIxLWR0cy8KIG9iai0kKENPTkZJR19YSUxfQVhJU19GSUZPKQkrPSBheGlz
LWZpZm8vCiBvYmotJChDT05GSUdfRklFTERCVVNfREVWKSAgICAgKz0gZmllbGRidXMvCiBvYmot
JChDT05GSUdfUUxHRSkJCSs9IHFsZ2UvCi1vYmotJChDT05GSUdfV0ZYKQkJKz0gd2Z4LwpkaWZm
IC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9UT0RPIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9U
T0RPCmRlbGV0ZWQgZmlsZSBtb2RlIDEwMDY0NAppbmRleCAxYjRiYzJhZjk0YjYuLjAwMDAwMDAw
MDAwMAotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L1RPRE8KKysrIC9kZXYvbnVsbApAQCAtMSw2
ICswLDAgQEAKLVRoaXMgaXMgYSBsaXN0IG9mIHRoaW5ncyB0aGF0IG5lZWQgdG8gYmUgZG9uZSB0
byBnZXQgdGhpcyBkcml2ZXIgb3V0IG9mIHRoZQotc3RhZ2luZyBkaXJlY3RvcnkuCi0KLSAgLSBB
cyBzdWdnZXN0ZWQgYnkgRmVsaXgsIHJhdGUgY29udHJvbCBjb3VsZCBiZSBpbXByb3ZlZCBmb2xs
b3dpbmcgdGhpcyBpZGVhOgotICAgICAgICBodHRwczovL2xvcmUua2VybmVsLm9yZy9sa21sLzMw
OTk1NTkuZ3YzUTc1S25OMUBwYy00Mi8KLQotLSAKMi4zMy4wCgo=
