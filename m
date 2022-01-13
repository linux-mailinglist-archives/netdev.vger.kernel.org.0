Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DEEC48D41A
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 09:57:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233208AbiAMI4c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 03:56:32 -0500
Received: from mail-mw2nam10on2077.outbound.protection.outlook.com ([40.107.94.77]:35104
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231576AbiAMI4I (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jan 2022 03:56:08 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=agKL6kuvioK5++3d3BFnQ5i4x8vjifQnZdp1enwzkx7fMCsEa5qhxwGQitEXKtyuz+qLHzZq+agbkmVkVGxXYwcmvGrwUI7CDp/OZrKB3y5j2ibQsQQp1G3/l1UprIkLfV7uIoQOJ/XrouuBFiJ6j2gNaarzEQF6hbvxPnwctz4gfujtz8yCXNt3tUs8dbnaEta6wNKDu/YbCfZ+B+xFbIm19fwktZ/xfPt5DjN/YdDDXWlog6BHYjNBd5N1674bunOTD1VwySz52onhtRHsOCmWxQJeqtYnSN1T1KAk6/CsXgMJxE8E10qPtXzM1PL5x15jdLUzEqFijErKkBUkJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ksytp06C9OwuefGlf79uqyNLgoHJ7mhaEpS7Pt1UJYs=;
 b=AGGBkXJGB2eaqedvSQp4qdtMy13dYRB06qcbYN9ca2KW+FraM0Rk2GLSBt92YsJB03P84TPxyNK6i4rU9WSAHlj6SgCgTjQBq9hBGdgZcnPnykmcDWbNRqmAhjwwdpVI/4FfTW2EIUUAdaQUBpzXfx5IBtcumP3SW6yi2FgJU2qz3TdbjR1eskhjKgWa98xVpLNl+ODhSAKIOmFKKL2Hbk+iGUOtH3g/WAyLD2NM4Ks/PIPzOhx3w1EhLi3elpv+Bkll6fgds5l0W7ViwifIS4YlZBjFK3MLtAiGHZ4sWjphWw3Wkg6qmFaZQlwPbVt3iaM5uztUIlLtdQOnfi/lQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ksytp06C9OwuefGlf79uqyNLgoHJ7mhaEpS7Pt1UJYs=;
 b=LPVc+Jwn497sS0C/f1omj4wSZ4nlaGQe3/CcOSHpOGQ8uJkl9QMBk+vIK4332pM1GGOxpgSCso1VxBgl6z54Uovcn/kFIKavXXX882PH522g8LBDDse4S4/WQccxoXDe8F4ZhJroa/TncuFvykXXoafbrNUU/4/trNAq3yT3P+8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=silabs.com;
Received: from PH0PR11MB5657.namprd11.prod.outlook.com (2603:10b6:510:ee::19)
 by BY5PR11MB4040.namprd11.prod.outlook.com (2603:10b6:a03:186::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.10; Thu, 13 Jan
 2022 08:55:55 +0000
Received: from PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::d031:da9e:71a:73e4]) by PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::d031:da9e:71a:73e4%5]) with mapi id 15.20.4888.011; Thu, 13 Jan 2022
 08:55:55 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 09/31] staging: wfx: replace magic value by WFX_HIF_BUFFER_SIZE
Date:   Thu, 13 Jan 2022 09:55:02 +0100
Message-Id: <20220113085524.1110708-10-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220113085524.1110708-1-Jerome.Pouiller@silabs.com>
References: <20220113085524.1110708-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: SA0PR11CA0117.namprd11.prod.outlook.com
 (2603:10b6:806:d1::32) To PH0PR11MB5657.namprd11.prod.outlook.com
 (2603:10b6:510:ee::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bb07ffc4-2e60-4ba3-6e12-08d9d672829c
X-MS-TrafficTypeDiagnostic: BY5PR11MB4040:EE_
X-Microsoft-Antispam-PRVS: <BY5PR11MB40402C515B85239F6C8CB5F693539@BY5PR11MB4040.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:415;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lIvIy7tqqeJyex6A8dqUAn1PnLtGwaZkKJTW/nPwXtmrJZftc8kTF7JkXJuv1plrpa/99rNaInnTXzdMLNkAOq8YknYk51LNE7Y/yvqxCQFrEfWoLEzDqop4kxpQOoWpOaO1KpCAh4/OoUrcE6FkumPwRUCNAyeRXUvBZRLHkAX76VTQeS0AGhJC8hApxsoEvazJ6AkdrO+K1McX9hOIPn2CqRvB0VF/o8SYDKS41YCAAlMltqS+yDVv7NWZTZZO1UPBE6zI/v2ficyOMRYUWkTY4hlNsF9xyWwUlGpBPTTZ5Z9Jb0T3w4/2O5zm4XcVPoTyGXnUoR4i5qgLI5yo8cEovku4/d6UNDNMo7FkKyoHcG0ukEmfTNhd0YBQxf60vU5JOuWwOLS10FEfdVxHGzocf6xIRn7PONIAz0owoYMXaYWyzCBknXpT5mmbmlYBUWOGcoz1QbkD7gTQjwaoM3qdW+2yQ4VpW0gAz4hc7humZeZArnauAwmYTdlW0Fx596yGkoFJ6bQXGSOslUS3XSD7XW4h4TPPIGW/GpOUCxCR2Fmp7GNKOZqgvsVnrxGbjIGUbYbJrPgad4JpVRUjQoOlv3syAVmF7m60urCreDGA7C0GOTaRr3GMsv8Ya5qWYuziydPEKVMy9sjXWW4BDg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6506007)(508600001)(186003)(38100700002)(4326008)(8936002)(6512007)(6666004)(66946007)(83380400001)(1076003)(2616005)(54906003)(86362001)(66556008)(2906002)(66476007)(316002)(52116002)(36756003)(5660300002)(8676002)(6486002)(107886003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aGE3b29YMWdiQ3dTYURTOG5vVHI3MTlGYW4rSjRyTHRNamVQZzJOc3dpTmhu?=
 =?utf-8?B?cXdRbjM3VVRiSUwxV25OV0F3ZmdlbGtSOE11YzNkY2crdzB0bFVyM1Ayb1BT?=
 =?utf-8?B?Mlo1QjNyY2ZRRHhlemJvRkxIU3VXdi9yWEZuZm0yZFZLY3g4OXdscXBRU3h6?=
 =?utf-8?B?RFl1M2R4L09Uek01aUFVc1p4T1Q3OXo5aFNsZzlNZFN5Z1k5QXlsL3dxaFUr?=
 =?utf-8?B?NWF1L0Y2YStVeXJGWWl4dGpzcHRZRFF4K0RyaHk3TDZ4R2puVGJsNzUzMjJH?=
 =?utf-8?B?cW51bzFoM2lwSmQ2ZUo3MlpxTzlWdlNhSzZZVEJ6bXJqd0I5NGZicXVxWFdZ?=
 =?utf-8?B?SnJwS2pzUklrMWhsVC9zRXhaK3dWaEJCUG9LQUsrU0Z5K3p6azdQd0NnWXpq?=
 =?utf-8?B?UGloNmdUbEd4cFhiNFNVbGdDTEptTjBCdDBlemRoS1VjbjBhQU5SRFUvWUpk?=
 =?utf-8?B?clA0MmFBYi9VRHZUWFdxa3Y5UVZEOGRxMmtFbDFnYllKRW04RGVHbW9XR3lj?=
 =?utf-8?B?azJkMENzVzhXeG9KQi9MS1Brczc0Tzc2emMwd2RJclVlT01qaGdjTlZQdko2?=
 =?utf-8?B?ZVpXdmZrSVNFWWQwbXpJc0VBRzRTUEU0d0VxY1pLdkxTc0VIYXU4VVRvVTNU?=
 =?utf-8?B?a3E0QmYydlp6c25IZzdDN2J0Yk9vdGxqbVlwR095K1B2QU1PTVBWVWw4TGIx?=
 =?utf-8?B?MGUwNXB6UHpienovaW9oSHVCZjFYa0VDbW05V29Ud0syODRBR0JpYkppVkZP?=
 =?utf-8?B?dGF4aGRiTVhWK0RkTnVmWUZHUGl3Y3lOemR1SXE0aWRTSkdoMWJHaExidk1E?=
 =?utf-8?B?R0c4UzNpTVlqbk9NRTFBRDdPTHFtMWRFRnNpeVRYL05jM1pnOWhPeEpTamJT?=
 =?utf-8?B?bWxsYzhHNTZzbnZXL2pYdVZDdFNuTkc5K0U0SXAwNFExRUJKTWIvd2dJdmtw?=
 =?utf-8?B?eW5Vb0NHWXNnQ0dqNjJKNDIvM2hmK1MzMENFV3MyOFE5Qm9RSnZ3Rzc0SEVV?=
 =?utf-8?B?eXd1ZVVuaUVaR09KL1hDY2dSMFc1dkJySUNuTzE5L0xKWnlsdURndGR1N3pQ?=
 =?utf-8?B?V0FzQS9DeVM1OWNDRENicjl6V3JFTFZTUXdhMVFFZDlXTHNoeTNiSnF6N3dB?=
 =?utf-8?B?bmRvYzRob093RFNmMnlqOXp1QWdrOUdEMER5UXNnOEt5bEdqaVAxVlJXaWEw?=
 =?utf-8?B?ZmZDTExZc0tEUmlMalByemRaQS96U0ZDWk1Lem1GR0JQbk1rU0xOSXY2YmlS?=
 =?utf-8?B?TG1YMHdCYVQvR2ExL0pzc010bHJTRm1VbElVeTMzcWhub1hOZmNneE1McDZz?=
 =?utf-8?B?dFZ0ejZjdGFNQlIvR21scXkyQUZIVU9sVS9FdkRwcWt4MFVJNU1jQ2FzZHVT?=
 =?utf-8?B?QlZrVVRXbDRkTTBxZG5lTG5iVFZXOE5kVU1GMStibVFBNU01aUYzNlNFL2Yw?=
 =?utf-8?B?b3FudVRsTUllRFZDczRMbHRVajJoakUvZG1KOVdNcWFwMlV4ZWVLREZxcy9B?=
 =?utf-8?B?OGtjUURQSVRCWDZNR3NWOGhzbkJZTmR5SXpSV2lyTWZUa3ZOMnJ4NWlpWCs2?=
 =?utf-8?B?OVZKV3BIMWJoNUVZV2tySVV3bzNaUERCclJJa2kzelExRW13cjhrcU53dm8x?=
 =?utf-8?B?Mml4S3pWTE1CUzlsdFRMRTROZjNkeXNLMk9BYmx6aWlDRm4va3BHVDJwOFFx?=
 =?utf-8?B?UlEyaFBOTXR4Sm0vWjB5TjRZRVpiQkpFcTZZOXBESEI1b0JpRVJpNmQ2MjYr?=
 =?utf-8?B?TVUxQXJ0RkxnQ09mWTJBalhuTUhvOXpFSU5GNkpCZ3dCemJZcHVYdDJwajFW?=
 =?utf-8?B?MnU2R2tlZWFhTUpTTXpEazVrekt6TytrMGxNM2U0dDNCZnVjTW5VSnVadmk4?=
 =?utf-8?B?cCtuMlVNd0hoNVpoMTQ5OVUxaW0rZE9NOFZsMk0wdUdVa3JQL1lEeVNSL1Y4?=
 =?utf-8?B?ZmsyTDZFeDZ5MGJBZ1lnQ2hucEVhQjZLY3FWYnExeHg2ejMvRldXV29uR2VM?=
 =?utf-8?B?ZXJ4YjNoRFV0UUxORXIyc3N4UU5zaGtiNFNTaUJuYVF0ZnVRZ21uczZ0TkNo?=
 =?utf-8?B?dzM0Z2wxRjY5S2Y3dW5HODc5NEVOYXRrcmlXdTFaSUkvSktEYS9WSFBOeTNu?=
 =?utf-8?B?NzBGUXhGck1ncVFWb2lRYncvaVgzRU50TjkrRXdVbkxGcGNYYyt2M2k0OUJu?=
 =?utf-8?B?a2FURzd0R01qOGJQT3NCVlhMVUdyMC81UHpGdytWdEtmdndheStwT1F0VmtF?=
 =?utf-8?Q?TVw26wids+Wl1ATEhgQOy4ZiDpyn/oqMj3MQavoA1A=3D?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb07ffc4-2e60-4ba3-6e12-08d9d672829c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2022 08:55:55.7728
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4k9f5C/NEumxgNvW9xfcAz5rcPeCB88gQHtbcqYNz0iJ+7NC+jJ2GpoNe9l5XyDp17bx2bLMG6hDwUXMbykBkw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR11MB4040
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKTWFn
aWMgdmFsdWVzIGFyZSBub3QgcmVjb21tZW5kZWQuCgpTaWduZWQtb2ZmLWJ5OiBKw6lyw7RtZSBQ
b3VpbGxlciA8amVyb21lLnBvdWlsbGVyQHNpbGFicy5jb20+Ci0tLQogZHJpdmVycy9zdGFnaW5n
L3dmeC9od2lvLmMgfCA2ICsrKystLQogMSBmaWxlIGNoYW5nZWQsIDQgaW5zZXJ0aW9ucygrKSwg
MiBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2h3aW8uYyBi
L2RyaXZlcnMvc3RhZ2luZy93ZngvaHdpby5jCmluZGV4IGEyYTM3ZWZjNTFhNi4uOTc3YjkzMjVm
NDk2IDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2h3aW8uYworKysgYi9kcml2ZXJz
L3N0YWdpbmcvd2Z4L2h3aW8uYwpAQCAtMTUsNiArMTUsOCBAQAogI2luY2x1ZGUgImJ1cy5oIgog
I2luY2x1ZGUgInRyYWNlcy5oIgogCisjZGVmaW5lIFdGWF9ISUZfQlVGRkVSX1NJWkUgMHgyMDAw
CisKIHN0YXRpYyBpbnQgcmVhZDMyKHN0cnVjdCB3ZnhfZGV2ICp3ZGV2LCBpbnQgcmVnLCB1MzIg
KnZhbCkKIHsKIAlpbnQgcmV0OwpAQCAtMTAzLDcgKzEwNSw3IEBAIHN0YXRpYyBpbnQgaW5kaXJl
Y3RfcmVhZChzdHJ1Y3Qgd2Z4X2RldiAqd2RldiwgaW50IHJlZywgdTMyIGFkZHIsCiAJdTMyIGNm
ZzsKIAl1MzIgcHJlZmV0Y2g7CiAKLQlXQVJOX09OKGxlbiA+PSAweDIwMDApOworCVdBUk5fT04o
bGVuID49IFdGWF9ISUZfQlVGRkVSX1NJWkUpOwogCVdBUk5fT04ocmVnICE9IFdGWF9SRUdfQUhC
X0RQT1JUICYmIHJlZyAhPSBXRlhfUkVHX1NSQU1fRFBPUlQpOwogCiAJaWYgKHJlZyA9PSBXRlhf
UkVHX0FIQl9EUE9SVCkKQEAgLTE1MSw3ICsxNTMsNyBAQCBzdGF0aWMgaW50IGluZGlyZWN0X3dy
aXRlKHN0cnVjdCB3ZnhfZGV2ICp3ZGV2LCBpbnQgcmVnLCB1MzIgYWRkciwKIHsKIAlpbnQgcmV0
OwogCi0JV0FSTl9PTihsZW4gPj0gMHgyMDAwKTsKKwlXQVJOX09OKGxlbiA+PSBXRlhfSElGX0JV
RkZFUl9TSVpFKTsKIAlXQVJOX09OKHJlZyAhPSBXRlhfUkVHX0FIQl9EUE9SVCAmJiByZWcgIT0g
V0ZYX1JFR19TUkFNX0RQT1JUKTsKIAlyZXQgPSB3cml0ZTMyKHdkZXYsIFdGWF9SRUdfQkFTRV9B
RERSLCBhZGRyKTsKIAlpZiAocmV0IDwgMCkKLS0gCjIuMzQuMQoK
