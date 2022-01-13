Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5419748D404
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 09:56:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231984AbiAMI4N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 03:56:13 -0500
Received: from mail-dm6nam11on2047.outbound.protection.outlook.com ([40.107.223.47]:10080
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231950AbiAMI4E (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jan 2022 03:56:04 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AgU9kc+zmcs5G2YCHe5b8qepuiY83IFzTZCvH1AiXfpUxDykoabroFNpnu6ZOCibCHc643a2IdpPWQADj7mr3Wa96NsQlo2rRIkwk2cTGYc3DbB1qQcYh/GATEafIWYUXKT11jHd38qFvq4WhX/lAr9NMsco1YWAIgvfXaluZu+WujVYbwTMR/yuZyE2GmMNTujaVqKgM5vk3cl2UUSvXRn1QJ8CWMgivYbojvX0WpQxCzutp6l/H6cERVHXdl4Ob5yaqNYy5VCs4x7ko1ZQwP7potPz/VBqqQqwLIT9qLJ+VuMn3JacoDs+aDyOxahHp6EJt+qd7q6WCpwTxiK/bQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+xvJ0MZ95/evykgq3ZVCecbw8UJnlO4e+q6rZ3V4EpU=;
 b=fDCdS3fQXMpeP9LDzpXEPTq0POoM6APIy13/6yrLBXICvktjFLMyjvcT4IYQciPfFKv0viV5uKu9I7eBs57fp4QOuEbniVbKqGaUoXfEq3YZXtLdOyl7ZtTQwC8e4bFxbp/ODMEMv3KsV/v4zqmkqAx2GqPpHt8N/SkdFw1BAqFQaxizUQgf/SlTFWG/R4FF/Jo56Rl42dOFPi/ay+AoRLGm84h/Of2HS/wQinhlVT0j1gSQ7TRavHoPZ2lUC8OLg6Cbm0EFIumDGREvBeD/ScbkAzImxVrYrQQfapi9niVuBG8W9TrGDTj6y3dItjLAcae3Trpg3uB+HQ5VKq3dLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+xvJ0MZ95/evykgq3ZVCecbw8UJnlO4e+q6rZ3V4EpU=;
 b=ddVhdVoNqpuKjv/XeaUZPbeDG0cYhMONnNbrCL07vCuGaQGME/HVdWI3OT1i93Ak5/oE+mGMCz1zg2WUn2sBdoFWKDE5zSc+17cNjuy9qyvlztcHAHRnCXerAoGbGfnkx1yLzDmLNegeJX1kJ1LFEas7GPwVBsXv9BJ5BK+O03k=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=silabs.com;
Received: from PH0PR11MB5657.namprd11.prod.outlook.com (2603:10b6:510:ee::19)
 by CY4PR1101MB2071.namprd11.prod.outlook.com (2603:10b6:910:1a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.9; Thu, 13 Jan
 2022 08:56:01 +0000
Received: from PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::d031:da9e:71a:73e4]) by PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::d031:da9e:71a:73e4%5]) with mapi id 15.20.4888.011; Thu, 13 Jan 2022
 08:56:01 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 12/31] staging: wfx: fix ambiguous function name
Date:   Thu, 13 Jan 2022 09:55:05 +0100
Message-Id: <20220113085524.1110708-13-Jerome.Pouiller@silabs.com>
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
X-MS-Office365-Filtering-Correlation-Id: bb03a002-08ee-4f3b-5f0e-08d9d6728605
X-MS-TrafficTypeDiagnostic: CY4PR1101MB2071:EE_
X-Microsoft-Antispam-PRVS: <CY4PR1101MB2071CD345BC2DDF7A697CA6593539@CY4PR1101MB2071.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xmLi/05hjIAIFnDnkQWDlHspaDmWbs5bvm+nbCDfE9h4sBM/ULMb1jQPbMcIQ03aYsjT1ti043lRTT1aH54RBHmUqggpKVZWzXmmfdRhym52Y86ivjcS7kxwm/d34RmfObUlSffpO5MhxC5CD6z1N17rOvA0mDaGxRGVdOTCgZ3gyTEY8/w2LfLfCIjgyKMSEJqvxpYSNiOoqr6+2iRRQTZkEnEus5ZNehyQU80dVpu8Ps8gtMJfVEeBaWRP8JDa9wiCW91S1SFI8HAdgaN5VtQBZVL+nZF1j+5LsW0wn9UDD3t47Kuq04BL6lzWkmyOEoTfwEsXWgbc0xUT+wB8OjUGvbVVPrYoKMomSKjgMvagllhrdxePWUrh+O+axqSAWNbbIDUqF/tYQkf4BgqhtYw2QpO9sgpQft6sqRxXyPeXl7FJ6vmAOMv/cpZT05HUuhRhgRFw/9RHqFT4CRdbEqdh5VdHWwsKUj/DRzMJsQLozkKtGZLuETw0V7uSFvpKy6iYGFSZC7FVkkL60+rycA9dXX/KZ/7EByBCvLVJZD0vmcwX3Wbei0lulbzAHNPj8f1j9eQ37WhTRYPwiCQRMMtMDGin/yqknvRaxlMbuqrcACbqbVxCZq0LQcxBSGYz8FcVGLiokcYA2OB4Bko5cg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(2616005)(66476007)(52116002)(8676002)(6486002)(4326008)(66574015)(38100700002)(8936002)(83380400001)(6506007)(107886003)(66556008)(36756003)(508600001)(2906002)(5660300002)(6512007)(1076003)(86362001)(186003)(316002)(66946007)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UFYzZUdKYXRBRlFYbjg3dEs5b0RpLzBjbFo0WVFMckRHQ2JLS3ZycWFkb1hW?=
 =?utf-8?B?a292NU1ZaHMwN0RVZzBvQllibmZ1MTVBN0gvRnl5QjJ0Y2EzVmxVL21YWm8w?=
 =?utf-8?B?TmlJNXVSUktYendVeVNxQmFJZlVaeUE2OGJ5Z2lBUVlHQXpKODNkSFNkSWVj?=
 =?utf-8?B?a3pSd251b00zUlF4aE5LRzlpL0xaVmpYL0poKzNmR0grSmZ5Q0IxR0pKK3Rr?=
 =?utf-8?B?R0lvSll4UEdLUGV4L0ROUzU5RUNLWm1SSmpnbXV1N2lEenEvbGMrVnpMa1Bp?=
 =?utf-8?B?R2gyL0M0c2JrenJlRzBidElXL0M0elBuSERSeHdDbGF1djMrbjJJTTlETk1q?=
 =?utf-8?B?WVprVU1xOGlqY3RRN2thTnd3bmlvRmxZVWxUTzNRekkzSDZ5K1JNNWRDUSsx?=
 =?utf-8?B?V0pZOS9GZS9BU291NjhXMU9rV2JET1lQTkljYjN2bzRUZDBsdVNkYzlHeU9r?=
 =?utf-8?B?OVF1V0RqMkhvZ0ljVVdXWno0U2hKWnJQU0gxYlRZZmVSd01zMWdON3o5L1FY?=
 =?utf-8?B?SHVxVGxCVWw3WWhycS9ha1FBVmsyTlc0ZDN2dmxZLzJWS3FxbEU4TGdOcFNn?=
 =?utf-8?B?b292cUdjTGFzSEoyaDJQWXpWNnFmRnhHWk9EemNRajhXSWRnd281bXNaSVVr?=
 =?utf-8?B?b1ZXS3I4L0Z3TXBXR3FpamR0dXJ4VGFVd1RZSlhPdVgzQ1pSWU14ci9GZjB4?=
 =?utf-8?B?bndkSFJtbVZJM2JBRmQyVThFem15b0lzeEluK2EvZDlzejF4SS92Mml1MXps?=
 =?utf-8?B?d09pdHN3bEx3Y3JCN3AwUUZtT3Q3NzVmaEJSeGFqQnk2UDVManFXK2dOVTJZ?=
 =?utf-8?B?ditYNHZFcG1ZYzhDUzkvS0xRSHoySUs0NFhpSkE3MWtmWXhLRmI4OWFNbUxD?=
 =?utf-8?B?a1Q1bis2WEU3N3doaVhKTSt6SldDaTZja3c3ZUZMOW43VVBjTlgzN0dFcms1?=
 =?utf-8?B?OXlhczVXM2lYVTVjL2NCa29WdG1YWmxQd2RGQUJ5Ulcrd0hiYnhGWGVLYmpo?=
 =?utf-8?B?bkpNejZ0ekxFY1R4UCtjRXY2UCs2SWtTT2ZIUktnS0NCWGY0MCt3M1BVT1dB?=
 =?utf-8?B?SnlYR3k2SldQWmdvYTh2bTV6VnI0K3gwWnUwc09tMXlkZmJZMDlYZDN6aDJQ?=
 =?utf-8?B?SUtyakpXTjRHdUNlYzVlOUh5Z2RqR3k4ZHRuUjE4NVZ0Ykk1bFpqbFJqbFlk?=
 =?utf-8?B?SUo0VURySHNzWEd3dWlmcy96Lyt4ZGtuQmtVS0s4VzZiVWtCMS9XK2RWNnNh?=
 =?utf-8?B?VC8yTm9QWXpmbmJzQWNDQm9OdW1LbFJOd0RVWkpMOTZWUkgzdUlXNElsUXJX?=
 =?utf-8?B?TDd6MzZCY3ZwdEVXUGdHWnhQVXNvWGNBS2kxODFoSlRMb21GNkdVY013anBF?=
 =?utf-8?B?c0xXdUxpM3FsTEFPd3ErMkZyb1IxcFBXMktGUnVtWXBYcGplMlpoOWFvRkRm?=
 =?utf-8?B?Z2xGQXdVTVVzTnV5ejR5cWI2Vk4rZ0IrRS80Vk90Y3Yyb2pDUy9sanpsWk5O?=
 =?utf-8?B?dTdkZk9uTG9LQy9TS0FhYmgwRnZVZW1mMG5TUlNBU0xUQjJOaS9ER0R5MHZZ?=
 =?utf-8?B?TitPRHJkeFNIYW5pZnRNWU02SGxWdTlFaXl2eVo2ZWZnUFp4Z3lQcDZGdEMz?=
 =?utf-8?B?VTMzZzZvekZiSkg2enMzREkvNEt5TTFHNnQ4ZTRqYkY2NVRQYXlpMWFwZVll?=
 =?utf-8?B?aStOQUlXcXJxUDAvL1hFZHJuaVVnZmZFQnZ6NTF2NytVK2EwMlBQTThKQ1No?=
 =?utf-8?B?ZlpNTVBKMkc1ai9pZGVwU3BFZDMyU0Y4ZzlSaXZ4d0duZU5VbHNnaUxKYTJJ?=
 =?utf-8?B?M1MweVMwQzB6SU5RQVU4UlJ5Q0pWSDNyMkUrTERjMlhYTmxqYUo5S1EzcGt4?=
 =?utf-8?B?NTFkOHBoQkVDWUtaVWgyVXM2cjcyc2hzbkRaemNhOTZ5NTN2S2JLKytwN3B3?=
 =?utf-8?B?bDJkZnNBaWJKV09La3FPOTBycDkwV2pVVlhLcXFObUh3a1JOeEpsRG1XSGxN?=
 =?utf-8?B?TmN2QzNnWkU5WS9TTnV5QzhvSWpCQjFFSUU1YkRrK3NieDNYS1N1ZEJiWWRG?=
 =?utf-8?B?RnhYd1UxalZab1Axd0oxNk9KMTN2QW84SWxwWklsZjliOE9qTXlJSUxxQWxs?=
 =?utf-8?B?TGVxWXFiN1lYMzFyaEovWE9xQlR4L0w5NnBmNThBNW85N21scnFnYThTY0g3?=
 =?utf-8?B?WDJ2eEFmd0M2eGl0YkU5NnErTloxSi9SZitWMWY4bllwTFloOWNUL3dFUXNn?=
 =?utf-8?Q?cunR1K874B1P7ebG0sxafJ2+aav3yynfonka4Luqdk=3D?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb03a002-08ee-4f3b-5f0e-08d9d6728605
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2022 08:56:01.4794
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p0OIZJx240U1DLZzdUJWWrBqyTOTgDRzLFy8Fp8ZYrc/ZVg6TK1TwuSg7QeAlFRo2qhMKz2hsu/Vsm5tG/scDw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1101MB2071
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVGhl
IHByZWZpeCAnaWVlZTgwMjExJyBpcyByZXNlcnZlZCBmb3IgbWFjODAyMTEuIEl0IHNob3VsZCBu
b3QgYmVlbgp1c2VkLgoKU2lnbmVkLW9mZi1ieTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5w
b3VpbGxlckBzaWxhYnMuY29tPgotLS0KIGRyaXZlcnMvc3RhZ2luZy93Zngvc2Nhbi5jIHwgNiAr
KystLS0KIDEgZmlsZSBjaGFuZ2VkLCAzIGluc2VydGlvbnMoKyksIDMgZGVsZXRpb25zKC0pCgpk
aWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9zY2FuLmMgYi9kcml2ZXJzL3N0YWdpbmcv
d2Z4L3NjYW4uYwppbmRleCA2NjhlZjJjNjA4MzcuLmExZmQwZjg1MDQ4MSAxMDA2NDQKLS0tIGEv
ZHJpdmVycy9zdGFnaW5nL3dmeC9zY2FuLmMKKysrIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9zY2Fu
LmMKQEAgLTEyLDggKzEyLDggQEAKICNpbmNsdWRlICJzdGEuaCIKICNpbmNsdWRlICJoaWZfdHhf
bWliLmgiCiAKLXN0YXRpYyB2b2lkIF9faWVlZTgwMjExX3NjYW5fY29tcGxldGVkX2NvbXBhdChz
dHJ1Y3QgaWVlZTgwMjExX2h3ICpodywKLQkJCQkJICAgICAgYm9vbCBhYm9ydGVkKQorc3RhdGlj
IHZvaWQgd2Z4X2llZWU4MDIxMV9zY2FuX2NvbXBsZXRlZF9jb21wYXQoc3RydWN0IGllZWU4MDIx
MV9odyAqaHcsCisJCQkJCQlib29sIGFib3J0ZWQpCiB7CiAJc3RydWN0IGNmZzgwMjExX3NjYW5f
aW5mbyBpbmZvID0gewogCQkuYWJvcnRlZCA9IGFib3J0ZWQsCkBAIC0xMjAsNyArMTIwLDcgQEAg
dm9pZCB3ZnhfaHdfc2Nhbl93b3JrKHN0cnVjdCB3b3JrX3N0cnVjdCAqd29yaykKIAl9IHdoaWxl
IChyZXQgPj0gMCAmJiBjaGFuX2N1ciA8IGh3X3JlcS0+cmVxLm5fY2hhbm5lbHMpOwogCW11dGV4
X3VubG9jaygmd3ZpZi0+c2Nhbl9sb2NrKTsKIAltdXRleF91bmxvY2soJnd2aWYtPndkZXYtPmNv
bmZfbXV0ZXgpOwotCV9faWVlZTgwMjExX3NjYW5fY29tcGxldGVkX2NvbXBhdCh3dmlmLT53ZGV2
LT5odywgcmV0IDwgMCk7CisJd2Z4X2llZWU4MDIxMV9zY2FuX2NvbXBsZXRlZF9jb21wYXQod3Zp
Zi0+d2Rldi0+aHcsIHJldCA8IDApOwogfQogCiBpbnQgd2Z4X2h3X3NjYW4oc3RydWN0IGllZWU4
MDIxMV9odyAqaHcsIHN0cnVjdCBpZWVlODAyMTFfdmlmICp2aWYsCi0tIAoyLjM0LjEKCg==
