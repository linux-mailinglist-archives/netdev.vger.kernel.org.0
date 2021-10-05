Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCBA9422983
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 15:57:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236543AbhJEN7S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 09:59:18 -0400
Received: from mail-co1nam11on2088.outbound.protection.outlook.com ([40.107.220.88]:52640
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236088AbhJEN5x (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Oct 2021 09:57:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PvOUwf24J+S4w6HECq3OKr9/dMJSx7CLjdUd7y8jkoiN7P3n7yI8Uzk19xMo72sUYKjuKmV5zb1gFBntWHGqYJ/81n9uF+eMW6dcB5WhoJnCVuqtohYQxJb33Y8nE36nne0wkmDEDM7gYV1nqb1BK00tchlMVcW4g8Am+7P/9hjRs5gNUnx8DWEQQU0G9DIrwftjlrqw91i2JSneVL3K+Fl8vyAqywUbDi7PjV2iQlhjrZOpV6Ph38tYsUTg5w+YI9B8mtJfSkIay2jD8FbC/mwZ93Y9ARROEMXZx9Ohuu9PqOMSd3eMARh6sYBZz8I8KSCekwhT8+qJWzle887JuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hU0n7knVPWJ6nLLzMJmEZuM53P6meleovWN/Ag+kRQw=;
 b=kGyP+8xNouxIfHf8qGoBhr4eF55RlxgpHVeJPV3TXrYZdnHCwHGswOIU/+UHYUELbWJr9rZXx01dOsLVAGOfny3FceZ7BUZVTW5OAl9PCplUwgBbxIMwAEvCv5zCFaSXvkLU2uv3PD6njSLSiN3YrdNCFuUi1SXD6gAitbRTPJdv29G5yyFfx38kDKdava1d+mfHz7hEUPJhNrYJBnO/mlAqGIWK/shVlwchuvFrvHC2Z5QozWy/d//f+LCkmEpdmDSNCEMrpSyKNwuOdZhsDp5J8WCtaMwBxV5aX462Ip/NU5/P2kYFN8nY1T4/t8kEvzONjNDoZCpR7TS9AuxRZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hU0n7knVPWJ6nLLzMJmEZuM53P6meleovWN/Ag+kRQw=;
 b=Uq5UdN+2V+Y6jtueZMllk5Ze3eGWwg1GJfxvIBym7tBmzqknTQo5OkNcmA5y/TkPFjvcrSXEzWltz94Ai6cj2mQal+5JJ/qfk/p8NRglGCoJCXZT1Ahmtgb4RgT6rao1pxVzRs2Me6+e53sYpgrtOuj3gqopvhPtnEWNw+6nuuI=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=silabs.com;
Received: from PH0PR11MB5657.namprd11.prod.outlook.com (2603:10b6:510:ee::19)
 by PH0PR11MB5642.namprd11.prod.outlook.com (2603:10b6:510:e5::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14; Tue, 5 Oct
 2021 13:55:19 +0000
Received: from PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::31cb:3b13:b0e8:d8f4]) by PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::31cb:3b13:b0e8:d8f4%9]) with mapi id 15.20.4566.022; Tue, 5 Oct 2021
 13:55:19 +0000
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
Subject: [PATCH v8 20/24] wfx: add scan.c/scan.h
Date:   Tue,  5 Oct 2021 15:53:56 +0200
Message-Id: <20211005135400.788058-21-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211005135400.788058-1-Jerome.Pouiller@silabs.com>
References: <20211005135400.788058-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PR3P189CA0084.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:102:b4::29) To PH0PR11MB5657.namprd11.prod.outlook.com
 (2603:10b6:510:ee::19)
MIME-Version: 1.0
Received: from pc-42.silabs.com (37.71.187.125) by PR3P189CA0084.EURP189.PROD.OUTLOOK.COM (2603:10a6:102:b4::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14 via Frontend Transport; Tue, 5 Oct 2021 13:55:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 380c1646-b1cd-4818-0c9b-08d98807c4a6
X-MS-TrafficTypeDiagnostic: PH0PR11MB5642:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR11MB5642E1E0C94312482A96B65B93AF9@PH0PR11MB5642.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZMRbtdvsHSOJRudeUhsNgUnxrOeJLPZ5xQ5M+biVQFJidLma3/4ULDLuTb5GfLG1+whDWA+AUHCDz5DqEeZ3av44mjTlQTbMsm+7EJ1FSeVgO9261s9JpHURfzZ65vxJxipSL4nrFC4w1UONfgBf/u4rJx8v4HZlmXWPlxVBjwHr88ENt7KR8zI+0twlCqxGnNIMkmMkQIZNb0lNOpMr8nCHMcRavCIMPu5VhQRsJKEevD8aLvKV3ajnxmM9hubjdrHbVnsJkZv/ItoUPVRaT0p2cxWG0VglxQSIRFVb8LX2ZMjQ2Z/BL9f6ot6luE92xwsGR9DasOtVJKloEuHF0jM1tyVt8j49YxIA9GKU+JHlV5STJEq7ig5wDq1ohiocxr64coZT4iXgdnkWcn4p6GqfQ6VNwtde+zW8PXlj2q8OAkUbTOaHAWt33AMUabWH4Eye2TsV2DeKhOTwd4ssSTIplRHqcZyInY0WGdpwna5pW9xDgDmbGMyeTcq5U5jselRCLkk344xTC81nzHf6SclsTAZ7bQueqyhaJnOzvlxfwQ+XV52KFiDOJY06wp6nAShk8FGO4/WPLhSPF/h5FG3wzYhVavtoX6mlRuA+B45Ufs4vwLRyAYnY9qEE/bOd3CvHpbxsv3s9zjVPYYgyiLkm9+793D49TdZRQHTOj4Q3I5UsSwGfrBRLDYKVjiNeAyQi8nYBavje74n65pUxgQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(86362001)(5660300002)(26005)(52116002)(7696005)(956004)(8676002)(2616005)(38100700002)(8936002)(38350700002)(4326008)(6666004)(186003)(7416002)(6916009)(66574015)(107886003)(83380400001)(36756003)(66476007)(66556008)(508600001)(2906002)(316002)(6486002)(1076003)(66946007)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?U0JNMUxiMDArUDk2ZVZpRGxtUnozVjFzTkJYV0dwMjZ4NHQ1aUcwWVRISUFp?=
 =?utf-8?B?OTdxTFh5dmN5RVdlazZybzhyL0t2Zk1MWHIrQ3JadVJ1MStNbVZQMWNJSVNh?=
 =?utf-8?B?cUNIdThuQUxOVERXNE9DM095TTJCOEVIQkdId05QbEU2TmRqV2lva3plMDky?=
 =?utf-8?B?NWR6U0lqMEhXUWFTNTZheDROVFRDTHZtM0huQlJxeHAvMmZOM3I2NGVsODB3?=
 =?utf-8?B?QmMwOUZWOVBXbTFzMlVzSVFIaGMzbUxCc3NkTWMrVTVXYjdIN2xmd2hFa2c2?=
 =?utf-8?B?aThKZ1d1VkU4K0c3dk9nQUJsZWQwei92VDIyRzRtYWR1MG5GUk1zNlZoUlhv?=
 =?utf-8?B?eDd5dllCdy9jbmlVZjZVM1VOL3BINHkxRjZkWVhheC91VExDV2pkUGh6YnFE?=
 =?utf-8?B?MTE2OXc0TlFGRmR6OVgrR1hYNVpldUdqbU9rU2RCMVJCeCtXK24rUGxSNUxW?=
 =?utf-8?B?U2xLdEFnSXlrNDBlNThDYUJ1NWRNZmtlODh1NlJuMVNvWFBmNlZaMjhSWXRF?=
 =?utf-8?B?MDZlOXZiVWFBL2hMeFc1Y3lhRGxTdHNzcm5vSkJBTmgvMHpQYXcwVXJkdmp3?=
 =?utf-8?B?STNiSkdMd3VZYXp6ZXdGck02cDIzZVBMUUQ4MWFSZkxmMTkrRTlGL1NLekhw?=
 =?utf-8?B?U1Z5K09WUjM5ZmlLbDI4aEVvMnh4UFFNaVY4cHh6dGQzNDA3NVZHTVRPMHlC?=
 =?utf-8?B?WENRZEJPMFpIeXcwdUlkZzVZbjlRbEIxUGdQRys5UHhlMjkxWjZFYmZ6eDdJ?=
 =?utf-8?B?Y3Q2ZTRRSUJNUlFtMHZYRzBmY1pUQ0FndnkxREFidlRYd1h2WnhEdTd0ZDFR?=
 =?utf-8?B?dm9aVUhJQ1FydFZiL3JiTEFlZFNNdE9MWDluZk5YN1FmemNtbXdaWGMrMEJE?=
 =?utf-8?B?Y3k0Q0pFc3lYaE5Wd3A2SENpdU9mck0xaGh6cFo2NUlXbDJuYXpPMVVmQUZD?=
 =?utf-8?B?ZEV3YUtqQVphTUUxRHU1bkx0WU4zdXgxelZic0JRL3p3ZDc4TkE2d2dmNGpJ?=
 =?utf-8?B?VVVkREU1YXRPZVo4bGNMZllZTXN4YnRFZzdUaG1hMWpNMDNPaWxaOUJCZ3Nt?=
 =?utf-8?B?WUpybUZUbzBleGlNcmVwUjRNdlErZnFuUVJDTFZmTlBHTlo0bGFQUE56aEty?=
 =?utf-8?B?ZmhneUFPRWxpQ0M3aGdrZGVDd3pJbm9Cd2ZRMTR0T3AzUHFXMWp0VWxyQ1RG?=
 =?utf-8?B?TjhIQ0x0dExvQnNmbkZpSjFDZFdsRHVPaCtDdXZWYW12VXRBcDN5UkFiL1JH?=
 =?utf-8?B?UDhSMHBPQ0VLd0NFdElNcFNuNU1EWkxnR1lBc0JTV2k1Z3ZNcmNqdzBINlBS?=
 =?utf-8?B?ZjBNbnhDdmpOQ0djVEtFZkd6VVdyVnBOdWNyK1FYTjAvUnUwbWtrelZsQWlW?=
 =?utf-8?B?UHcwSGhtckNGbnAvd1BxUTRqQzRjQkpKeEhZSUticjhkS1R3SStZWGhHa0Ji?=
 =?utf-8?B?bVJPNFJDbTZuK2NKbnBKOTlkamhPY0NOUlYxeEc1MSttOWRFeGlJWnNJK1Bp?=
 =?utf-8?B?MjI5RnRhcnhkQXY4dnNOUkdLbjJvdWpnQUFvMWs3Y09wN0c4Q1VXaGFubFB5?=
 =?utf-8?B?UHQvZjdna2pGeHFXSFdqR09OVUZKTTBxd0JHb0RKWUlYYWxEYVJ4VUxuZ25P?=
 =?utf-8?B?MGg5VC9RdW9NVGhBdTY0UDZHZHJpOVFrWm1uR0ticVN5aFhDbzJ5cEVSb29E?=
 =?utf-8?B?Z1lqQkJyQkQ5ZldYdHU1alo0ODZvamtJOEVCQzZjRzRkR2pzVklQUlhnazUv?=
 =?utf-8?Q?5Wz+jhFqFJdXIIMBgmEpP8fQFXkAMA04uic/4Ej?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 380c1646-b1cd-4818-0c9b-08d98807c4a6
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2021 13:55:19.6554
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mFXpHzzkUyOsK0gC0J9WsbaOcra562KJCHfVj672npix13Vwi7GgV63nAv1haxT74X8xvrYLIZprGIUo0I1dag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5642
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKU2ln
bmVkLW9mZi1ieTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29t
PgotLS0KIGRyaXZlcnMvbmV0L3dpcmVsZXNzL3NpbGFicy93Zngvc2Nhbi5jIHwgMTQ4ICsrKysr
KysrKysrKysrKysrKysrKysrKysKIGRyaXZlcnMvbmV0L3dpcmVsZXNzL3NpbGFicy93Zngvc2Nh
bi5oIHwgIDIyICsrKysKIDIgZmlsZXMgY2hhbmdlZCwgMTcwIGluc2VydGlvbnMoKykKIGNyZWF0
ZSBtb2RlIDEwMDY0NCBkcml2ZXJzL25ldC93aXJlbGVzcy9zaWxhYnMvd2Z4L3NjYW4uYwogY3Jl
YXRlIG1vZGUgMTAwNjQ0IGRyaXZlcnMvbmV0L3dpcmVsZXNzL3NpbGFicy93Zngvc2Nhbi5oCgpk
aWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvd2lyZWxlc3Mvc2lsYWJzL3dmeC9zY2FuLmMgYi9kcml2
ZXJzL25ldC93aXJlbGVzcy9zaWxhYnMvd2Z4L3NjYW4uYwpuZXcgZmlsZSBtb2RlIDEwMDY0NApp
bmRleCAwMDAwMDAwMDAwMDAuLmE3NzYzOGU5YTI5NAotLS0gL2Rldi9udWxsCisrKyBiL2RyaXZl
cnMvbmV0L3dpcmVsZXNzL3NpbGFicy93Zngvc2Nhbi5jCkBAIC0wLDAgKzEsMTQ4IEBACisvLyBT
UERYLUxpY2Vuc2UtSWRlbnRpZmllcjogR1BMLTIuMC1vbmx5CisvKgorICogU2NhbiByZWxhdGVk
IGZ1bmN0aW9ucy4KKyAqCisgKiBDb3B5cmlnaHQgKGMpIDIwMTctMjAyMCwgU2lsaWNvbiBMYWJv
cmF0b3JpZXMsIEluYy4KKyAqIENvcHlyaWdodCAoYykgMjAxMCwgU1QtRXJpY3Nzb24KKyAqLwor
I2luY2x1ZGUgPG5ldC9tYWM4MDIxMS5oPgorCisjaW5jbHVkZSAic2Nhbi5oIgorI2luY2x1ZGUg
IndmeC5oIgorI2luY2x1ZGUgInN0YS5oIgorI2luY2x1ZGUgImhpZl90eF9taWIuaCIKKworc3Rh
dGljIHZvaWQgd2Z4X2llZWU4MDIxMV9zY2FuX2NvbXBsZXRlZF9jb21wYXQoc3RydWN0IGllZWU4
MDIxMV9odyAqaHcsCisJCQkJCQlib29sIGFib3J0ZWQpCit7CisJc3RydWN0IGNmZzgwMjExX3Nj
YW5faW5mbyBpbmZvID0geworCQkuYWJvcnRlZCA9IGFib3J0ZWQsCisJfTsKKworCWllZWU4MDIx
MV9zY2FuX2NvbXBsZXRlZChodywgJmluZm8pOworfQorCitzdGF0aWMgaW50IHVwZGF0ZV9wcm9i
ZV90bXBsKHN0cnVjdCB3ZnhfdmlmICp3dmlmLAorCQkJICAgICBzdHJ1Y3QgY2ZnODAyMTFfc2Nh
bl9yZXF1ZXN0ICpyZXEpCit7CisJc3RydWN0IHNrX2J1ZmYgKnNrYjsKKworCXNrYiA9IGllZWU4
MDIxMV9wcm9iZXJlcV9nZXQod3ZpZi0+d2Rldi0+aHcsIHd2aWYtPnZpZi0+YWRkciwKKwkJCQkg
ICAgIE5VTEwsIDAsIHJlcS0+aWVfbGVuKTsKKwlpZiAoIXNrYikKKwkJcmV0dXJuIC1FTk9NRU07
CisKKwlza2JfcHV0X2RhdGEoc2tiLCByZXEtPmllLCByZXEtPmllX2xlbik7CisJd2Z4X2hpZl9z
ZXRfdGVtcGxhdGVfZnJhbWUod3ZpZiwgc2tiLCBISUZfVE1QTFRfUFJCUkVRLCAwKTsKKwlkZXZf
a2ZyZWVfc2tiKHNrYik7CisJcmV0dXJuIDA7Cit9CisKK3N0YXRpYyBpbnQgc2VuZF9zY2FuX3Jl
cShzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiwKKwkJCSBzdHJ1Y3QgY2ZnODAyMTFfc2Nhbl9yZXF1ZXN0
ICpyZXEsIGludCBzdGFydF9pZHgpCit7CisJaW50IGksIHJldDsKKwlzdHJ1Y3QgaWVlZTgwMjEx
X2NoYW5uZWwgKmNoX3N0YXJ0LCAqY2hfY3VyOworCisJZm9yIChpID0gc3RhcnRfaWR4OyBpIDwg
cmVxLT5uX2NoYW5uZWxzOyBpKyspIHsKKwkJY2hfc3RhcnQgPSByZXEtPmNoYW5uZWxzW3N0YXJ0
X2lkeF07CisJCWNoX2N1ciA9IHJlcS0+Y2hhbm5lbHNbaV07CisJCVdBUk4oY2hfY3VyLT5iYW5k
ICE9IE5MODAyMTFfQkFORF8yR0haLCAiYmFuZCBub3Qgc3VwcG9ydGVkIik7CisJCWlmIChjaF9j
dXItPm1heF9wb3dlciAhPSBjaF9zdGFydC0+bWF4X3Bvd2VyKQorCQkJYnJlYWs7CisJCWlmICgo
Y2hfY3VyLT5mbGFncyBeIGNoX3N0YXJ0LT5mbGFncykgJiBJRUVFODAyMTFfQ0hBTl9OT19JUikK
KwkJCWJyZWFrOworCX0KKwl3ZnhfdHhfbG9ja19mbHVzaCh3dmlmLT53ZGV2KTsKKwl3dmlmLT5z
Y2FuX2Fib3J0ID0gZmFsc2U7CisJcmVpbml0X2NvbXBsZXRpb24oJnd2aWYtPnNjYW5fY29tcGxl
dGUpOworCXJldCA9IHdmeF9oaWZfc2Nhbih3dmlmLCByZXEsIHN0YXJ0X2lkeCwgaSAtIHN0YXJ0
X2lkeCk7CisJaWYgKHJldCkgeworCQl3ZnhfdHhfdW5sb2NrKHd2aWYtPndkZXYpOworCQlyZXR1
cm4gLUVJTzsKKwl9CisJcmV0ID0gd2FpdF9mb3JfY29tcGxldGlvbl90aW1lb3V0KCZ3dmlmLT5z
Y2FuX2NvbXBsZXRlLCAxICogSFopOworCWlmICghcmV0KSB7CisJCXdmeF9oaWZfc3RvcF9zY2Fu
KHd2aWYpOworCQlyZXQgPSB3YWl0X2Zvcl9jb21wbGV0aW9uX3RpbWVvdXQoJnd2aWYtPnNjYW5f
Y29tcGxldGUsIDEgKiBIWik7CisJCWRldl9kYmcod3ZpZi0+d2Rldi0+ZGV2LCAic2NhbiB0aW1l
b3V0ICglZCBjaGFubmVscyBkb25lKVxuIiwKKwkJCXd2aWYtPnNjYW5fbmJfY2hhbl9kb25lKTsK
Kwl9CisJaWYgKCFyZXQpIHsKKwkJZGV2X2Vycih3dmlmLT53ZGV2LT5kZXYsICJzY2FuIGRpZG4n
dCBzdG9wXG4iKTsKKwkJcmV0ID0gLUVUSU1FRE9VVDsKKwl9IGVsc2UgaWYgKHd2aWYtPnNjYW5f
YWJvcnQpIHsKKwkJZGV2X25vdGljZSh3dmlmLT53ZGV2LT5kZXYsICJzY2FuIGFib3J0XG4iKTsK
KwkJcmV0ID0gLUVDT05OQUJPUlRFRDsKKwl9IGVsc2UgaWYgKHd2aWYtPnNjYW5fbmJfY2hhbl9k
b25lID4gaSAtIHN0YXJ0X2lkeCkgeworCQlyZXQgPSAtRUlPOworCX0gZWxzZSB7CisJCXJldCA9
IHd2aWYtPnNjYW5fbmJfY2hhbl9kb25lOworCX0KKwlpZiAocmVxLT5jaGFubmVsc1tzdGFydF9p
ZHhdLT5tYXhfcG93ZXIgIT0gd3ZpZi0+dmlmLT5ic3NfY29uZi50eHBvd2VyKQorCQl3ZnhfaGlm
X3NldF9vdXRwdXRfcG93ZXIod3ZpZiwgd3ZpZi0+dmlmLT5ic3NfY29uZi50eHBvd2VyKTsKKwl3
ZnhfdHhfdW5sb2NrKHd2aWYtPndkZXYpOworCXJldHVybiByZXQ7Cit9CisKKy8qIEl0IGlzIG5v
dCByZWFsbHkgbmVjZXNzYXJ5IHRvIHJ1biBzY2FuIHJlcXVlc3QgYXN5bmNocm9ub3VzbHkuIEhv
d2V2ZXIsCisgKiB0aGVyZSBpcyBhIGJ1ZyBpbiAiaXcgc2NhbiIgd2hlbiBpZWVlODAyMTFfc2Nh
bl9jb21wbGV0ZWQoKSBpcyBjYWxsZWQgYmVmb3JlCisgKiB3ZnhfaHdfc2NhbigpIHJldHVybgor
ICovCit2b2lkIHdmeF9od19zY2FuX3dvcmsoc3RydWN0IHdvcmtfc3RydWN0ICp3b3JrKQorewor
CXN0cnVjdCB3ZnhfdmlmICp3dmlmID0gY29udGFpbmVyX29mKHdvcmssIHN0cnVjdCB3Znhfdmlm
LCBzY2FuX3dvcmspOworCXN0cnVjdCBpZWVlODAyMTFfc2Nhbl9yZXF1ZXN0ICpod19yZXEgPSB3
dmlmLT5zY2FuX3JlcTsKKwlpbnQgY2hhbl9jdXIsIHJldCwgZXJyOworCisJbXV0ZXhfbG9jaygm
d3ZpZi0+d2Rldi0+Y29uZl9tdXRleCk7CisJbXV0ZXhfbG9jaygmd3ZpZi0+c2Nhbl9sb2NrKTsK
KwlpZiAod3ZpZi0+am9pbl9pbl9wcm9ncmVzcykgeworCQlkZXZfaW5mbyh3dmlmLT53ZGV2LT5k
ZXYsICJhYm9ydCBpbi1wcm9ncmVzcyBSRVFfSk9JTiIpOworCQl3ZnhfcmVzZXQod3ZpZik7CisJ
fQorCXVwZGF0ZV9wcm9iZV90bXBsKHd2aWYsICZod19yZXEtPnJlcSk7CisJY2hhbl9jdXIgPSAw
OworCWVyciA9IDA7CisJZG8geworCQlyZXQgPSBzZW5kX3NjYW5fcmVxKHd2aWYsICZod19yZXEt
PnJlcSwgY2hhbl9jdXIpOworCQlpZiAocmV0ID4gMCkgeworCQkJY2hhbl9jdXIgKz0gcmV0Owor
CQkJZXJyID0gMDsKKwkJfQorCQlpZiAoIXJldCkKKwkJCWVycisrOworCQlpZiAoZXJyID4gMikg
eworCQkJZGV2X2Vycih3dmlmLT53ZGV2LT5kZXYsICJzY2FuIGhhcyBub3QgYmVlbiBhYmxlIHRv
IHN0YXJ0XG4iKTsKKwkJCXJldCA9IC1FVElNRURPVVQ7CisJCX0KKwl9IHdoaWxlIChyZXQgPj0g
MCAmJiBjaGFuX2N1ciA8IGh3X3JlcS0+cmVxLm5fY2hhbm5lbHMpOworCW11dGV4X3VubG9jaygm
d3ZpZi0+c2Nhbl9sb2NrKTsKKwltdXRleF91bmxvY2soJnd2aWYtPndkZXYtPmNvbmZfbXV0ZXgp
OworCXdmeF9pZWVlODAyMTFfc2Nhbl9jb21wbGV0ZWRfY29tcGF0KHd2aWYtPndkZXYtPmh3LCBy
ZXQgPCAwKTsKK30KKworaW50IHdmeF9od19zY2FuKHN0cnVjdCBpZWVlODAyMTFfaHcgKmh3LCBz
dHJ1Y3QgaWVlZTgwMjExX3ZpZiAqdmlmLAorCQlzdHJ1Y3QgaWVlZTgwMjExX3NjYW5fcmVxdWVz
dCAqaHdfcmVxKQoreworCXN0cnVjdCB3ZnhfdmlmICp3dmlmID0gKHN0cnVjdCB3ZnhfdmlmICop
dmlmLT5kcnZfcHJpdjsKKworCVdBUk5fT04oaHdfcmVxLT5yZXEubl9jaGFubmVscyA+IEhJRl9B
UElfTUFYX05CX0NIQU5ORUxTKTsKKwl3dmlmLT5zY2FuX3JlcSA9IGh3X3JlcTsKKwlzY2hlZHVs
ZV93b3JrKCZ3dmlmLT5zY2FuX3dvcmspOworCXJldHVybiAwOworfQorCit2b2lkIHdmeF9jYW5j
ZWxfaHdfc2NhbihzdHJ1Y3QgaWVlZTgwMjExX2h3ICpodywgc3RydWN0IGllZWU4MDIxMV92aWYg
KnZpZikKK3sKKwlzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiA9IChzdHJ1Y3Qgd2Z4X3ZpZiAqKXZpZi0+
ZHJ2X3ByaXY7CisKKwl3dmlmLT5zY2FuX2Fib3J0ID0gdHJ1ZTsKKwl3ZnhfaGlmX3N0b3Bfc2Nh
bih3dmlmKTsKK30KKwordm9pZCB3Znhfc2Nhbl9jb21wbGV0ZShzdHJ1Y3Qgd2Z4X3ZpZiAqd3Zp
ZiwgaW50IG5iX2NoYW5fZG9uZSkKK3sKKwl3dmlmLT5zY2FuX25iX2NoYW5fZG9uZSA9IG5iX2No
YW5fZG9uZTsKKwljb21wbGV0ZSgmd3ZpZi0+c2Nhbl9jb21wbGV0ZSk7Cit9CmRpZmYgLS1naXQg
YS9kcml2ZXJzL25ldC93aXJlbGVzcy9zaWxhYnMvd2Z4L3NjYW4uaCBiL2RyaXZlcnMvbmV0L3dp
cmVsZXNzL3NpbGFicy93Zngvc2Nhbi5oCm5ldyBmaWxlIG1vZGUgMTAwNjQ0CmluZGV4IDAwMDAw
MDAwMDAwMC4uNzhlM2I5ODRmMzc1Ci0tLSAvZGV2L251bGwKKysrIGIvZHJpdmVycy9uZXQvd2ly
ZWxlc3Mvc2lsYWJzL3dmeC9zY2FuLmgKQEAgLTAsMCArMSwyMiBAQAorLyogU1BEWC1MaWNlbnNl
LUlkZW50aWZpZXI6IEdQTC0yLjAtb25seSAqLworLyoKKyAqIFNjYW4gcmVsYXRlZCBmdW5jdGlv
bnMuCisgKgorICogQ29weXJpZ2h0IChjKSAyMDE3LTIwMjAsIFNpbGljb24gTGFib3JhdG9yaWVz
LCBJbmMuCisgKiBDb3B5cmlnaHQgKGMpIDIwMTAsIFNULUVyaWNzc29uCisgKi8KKyNpZm5kZWYg
V0ZYX1NDQU5fSAorI2RlZmluZSBXRlhfU0NBTl9ICisKKyNpbmNsdWRlIDxuZXQvbWFjODAyMTEu
aD4KKworc3RydWN0IHdmeF9kZXY7CitzdHJ1Y3Qgd2Z4X3ZpZjsKKwordm9pZCB3ZnhfaHdfc2Nh
bl93b3JrKHN0cnVjdCB3b3JrX3N0cnVjdCAqd29yayk7CitpbnQgd2Z4X2h3X3NjYW4oc3RydWN0
IGllZWU4MDIxMV9odyAqaHcsIHN0cnVjdCBpZWVlODAyMTFfdmlmICp2aWYsCisJCXN0cnVjdCBp
ZWVlODAyMTFfc2Nhbl9yZXF1ZXN0ICpyZXEpOwordm9pZCB3ZnhfY2FuY2VsX2h3X3NjYW4oc3Ry
dWN0IGllZWU4MDIxMV9odyAqaHcsIHN0cnVjdCBpZWVlODAyMTFfdmlmICp2aWYpOwordm9pZCB3
Znhfc2Nhbl9jb21wbGV0ZShzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiwgaW50IG5iX2NoYW5fZG9uZSk7
CisKKyNlbmRpZgotLSAKMi4zMy4wCgo=
