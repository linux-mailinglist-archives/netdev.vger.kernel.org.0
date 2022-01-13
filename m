Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58CFD48D487
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 10:49:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233444AbiAMI6Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 03:58:25 -0500
Received: from mail-dm6nam11on2085.outbound.protection.outlook.com ([40.107.223.85]:34208
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233451AbiAMI5f (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jan 2022 03:57:35 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fC652Ts07GlJdedmizfA/TNirWD2yFP+6HwLwV3b22LDzI4Oy9VrxN2l6QKNK3VV/hpnZMEAmV1GmSKHFCUhPhuG/vBpJiJtNtyUg9+aYqL6WGa+HklGDPCiCBS7SBjilHdFlUyEX2M8TeBmkP9hOhCxJeq9aiad94RznfQQViNMefINe8981z3kz0CDTr2lOS6ieBzz4IfkVRU4sV3WqBILAk41ZlARyTFugFwnsG++r8ufIBOZQW2sgwi8MQA1kfLsvxHxpw+hDj8ewYSXY9K58xcprE7WPB3MR57bM2MNfc9lrF1K+Zc/WEiNCAp7TfPJwvLkaeCBgrcGsYxaUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dg4CGuc2nBytV62h3DFwdZV0CKyHJG+AG38cTB1YZVo=;
 b=HQle/gQhQ8iBQNJT1ZrGRaytlqBeTHNkR6dyhwEZcN8gOeYTa6ptE/1ZIQOs1AOYw2bypj9l9O7PVHSjG4vPdD7L8vulpBqTsr2WaWQLNciyITK/eNlUCrC/xwvObbxrcGoLax12Xjhf/aiEH5Ee5j53LWufsPrFJOnS2mTTf+82GoHQHQdZTOsFCaXDmy+pqY+3hCyTA5T2YVRwQgnSPfCW3imMnfzf/zSQAQXpXkvClPUDkN7KIX2Z8dFmFao7d8zfhBA4qRa3HeVXaCoIIgDK5bE1vVhSLMhzvZWlwaKtavVoluu/GYIfY0t2nFBBKabkYiNOrwUV8KITiAPzEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dg4CGuc2nBytV62h3DFwdZV0CKyHJG+AG38cTB1YZVo=;
 b=bSFfTNOhONyJvgKCtF4xCCcm1VlS2IJa3Dvu7O2RAcS7n0HM7OdnL+bbLPlwRh3f2SPpT18VEzSxs96b7o/f/M2RFYIjKAM5rOnkwv8KoTADEwT81I0FtOs2lODhRKDdXcwnWHU8/aSYAs5KwAddNAjCQMauFlPnIhbvlwkr8O4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=silabs.com;
Received: from PH0PR11MB5657.namprd11.prod.outlook.com (2603:10b6:510:ee::19)
 by CY4PR1101MB2071.namprd11.prod.outlook.com (2603:10b6:910:1a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.9; Thu, 13 Jan
 2022 08:56:30 +0000
Received: from PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::d031:da9e:71a:73e4]) by PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::d031:da9e:71a:73e4%5]) with mapi id 15.20.4888.011; Thu, 13 Jan 2022
 08:56:30 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 26/31] staging: wfx: remove force_ps_timeout
Date:   Thu, 13 Jan 2022 09:55:19 +0100
Message-Id: <20220113085524.1110708-27-Jerome.Pouiller@silabs.com>
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
X-MS-Office365-Filtering-Correlation-Id: a55299d7-24df-4827-e9d6-08d9d6729769
X-MS-TrafficTypeDiagnostic: CY4PR1101MB2071:EE_
X-Microsoft-Antispam-PRVS: <CY4PR1101MB2071B99F6B4388D301C536B293539@CY4PR1101MB2071.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2201;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: t11hr28O5GYoK4hRX6VUlLX53HNMqAsNwjajp/gehn0Is2TSfpjNUpWiN7Bwg4g8gsfXhx8vKz9SO76fg6lcb4bgS13RLarLqHKjbK+tEiHTri2mu6ptb8OJLmu2a6SKaOxIWR/siHNEtHbkrWjuMzPvEnrTx7byiTDLdk4R6ILwSN2IpxaUK86ujZ5/F5x0tM5DEbwNwhA73XcGTNAt7iM31EN6ZGhNF+vtumc3OnX87W49HZW8+O7tBRubzCciGcYBBi9R67qUWbn2NepsDuQR/yifK7QsAqwFvflo2HbjGXVsIwMammfij8eWcWVWnUf0Ud1+kDlsQL8neUzq1Zi0OsShiV56MKGOAsWcQOqDjYpKnQeVloGxWup8v7HAgMB11ybDEfXd8MsnjxTL7HHlnY7cBLS+NdeSfaR8ww2jmvKe4HI97fm6H7kRBdO1WUSEvDiBBf9pQg21m4ivboa0i53XTzObHJz8bmW50T+iVe4yz5tNAtmeE9UtNZPBpbREWluSHPTvbR9T57eOn6sYMxHu3MdsJSDXNQxRLIK6LvIdm0uz+D6ESNHzadeEytaMMFKThsycvFpHJkKQhs28QKP50OCfkSBiOz9OwgsbEvSY+hPdwsjE2mmOZZ8JjB0Jg3U1J0egLBo5qjMYlA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(2616005)(66476007)(52116002)(8676002)(6486002)(4326008)(66574015)(38100700002)(8936002)(83380400001)(6506007)(107886003)(66556008)(6666004)(36756003)(508600001)(2906002)(5660300002)(6512007)(1076003)(86362001)(186003)(316002)(66946007)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NGJrZ1FPUGFWWFlIZCtLVWV3SlJBWlcxMk1mTnZpelB3cVJGQVZEbU04SHNV?=
 =?utf-8?B?UTlhYUFaZ1ViRmhEbTcySE5TSjZtV1N0ZlpWK0RhR3dOOXlKdStqN2lmZ3lM?=
 =?utf-8?B?YzZsNERQbmJxd3BUTXJ1Zi96REFGQWpFQlIvT3lBQUFhMjd5YjZ1SkxLazNq?=
 =?utf-8?B?eHJhSTZxTTQramp1SmgydUVwNlRST3UyMVpiTXRrMGFiLzRvSGZ6V0hSaHpi?=
 =?utf-8?B?OG9FMEk2U1MrN2tLUmx2eER3eFV6VExkc2pURVltR3VLbUh1bjhyYVkrSEJw?=
 =?utf-8?B?VCswN3IvcnlEa0lRNHVDL2h2dUFad1FzcmVtNnlCNHBEaVl3eHhZdFZ4ckJ6?=
 =?utf-8?B?dUc3citwb0dsREtYVVlsdTNZVFRWaUJ2RldQWXliWFpxZDVpZlNTTklXcEkw?=
 =?utf-8?B?VlltWFdzZUl3aWh2KzFMT1MrdzhWRjIvVUx2WnR4d2I0RS8zT2ltaHp0T0R3?=
 =?utf-8?B?Mi9wVk1QaTdyZmYxZlNEQnMwNG5uZW53blZmK1Q5T3JkM0I2UUcrY1QzcE1o?=
 =?utf-8?B?NFN4MElkWHNrNkJSM1BoY1o5SmsxMWd6WXFNakk2clp3bkxFbUtueU8zZUNp?=
 =?utf-8?B?cUNiR1QwanZ1cHNGVXdMTTgwYytPZXBkQXlSZHFaeENFazZuMHl0NVRlcEVO?=
 =?utf-8?B?UXA5RTRtOXE5TUdPSkI2RkRyd0F1M3lSVHpnblh1dWo5dnJyajBUOWpzUGJp?=
 =?utf-8?B?WDJEdlR4THM3d3kwYmdYTVdneitmTjdXVmxaQ0JEYW1qWWlPTFk2TFFESSt3?=
 =?utf-8?B?eDdid0FOSnh0eUlXTEJnaXNzMFRhcUp4S25xWFZYOFppM2RhNkdKK1BNMHlC?=
 =?utf-8?B?RDNLZVpVS0czc2JUYVJZUzNObEJFMVQvR0JVK0xiMi84V0RMTUo1NjNEMUYw?=
 =?utf-8?B?ampaS210L1JUL0tyTE9qNEVQbU1qNmJEOXRhcTc2Z1pkVzhEbG9jSFlIeXZY?=
 =?utf-8?B?czVtRzA1MUtldkhpbDNuYXdCeE40cGVpKzQ4cWpjMzZ3QXRGTEVaT0pONENl?=
 =?utf-8?B?ejhMRkZHNXMyclNEb1NQallKa3NmNFpFMHl5eHRsU3N0eVpqRXhrSUVBSkh4?=
 =?utf-8?B?SThOZGpBNU1wWUhIVURmWVZXaXhJREQzbGkwWGJHTERiN3V4dFA5bVF2VEhi?=
 =?utf-8?B?NlRMUEpocUJyNU1TS21aWFdSQjRXazhyVWhZdGlDZjdDU1k4Ykdad24rMVhl?=
 =?utf-8?B?c0RKaWR5SlFsUHpxVnVGOGsxLzFZemNPeDVnTFZCL1p4N0o3d0t6Qm1aY1lD?=
 =?utf-8?B?YjRmUWlzQmxPbWtpdTZFcTJKdFQydUtYSjlRS1VUSWo2REM1dVFPbndYZHRs?=
 =?utf-8?B?YUxBUkJvckxQYmN1a2xFUlZqdmNxck5TNnFKVUdnZi9TQkZpVms4SmhMOTh1?=
 =?utf-8?B?VTVJSGdrUVp2T1BGdVo3UFNuSWY3dmlSRXNncVhVS3FnaDJ0MytOMzl4cWNL?=
 =?utf-8?B?NysyUGZrNEJXV0VSRzNjOTd6aWQ3b08rK2w3TEpsYks3bkIxSVVtVFlvdDZv?=
 =?utf-8?B?R1pqeDFGbVp6VkhjMVRCL3h1WVM0bHQ0ZkMyV3hMVUZhQm1GUFp2aTg3V29k?=
 =?utf-8?B?ZktYMUgreEkzaGZIYjlydzdVamNyQ2RlV0ZsaG5mbGhDTk1XZVRuS01ObHRZ?=
 =?utf-8?B?N3N2aE80SWRlZlVRb3BtMmtRWlJaR3ZiWUdDalh0OEQxRGQrSlUxaTlkdHF3?=
 =?utf-8?B?cWxRV1BqQUZxYjg3NG9FVHk4cGNZMkNkV0ZtaW1EQUQ3UnpNaDB6dDFWT1FT?=
 =?utf-8?B?Y0tuZnpUWWl2RHJ2U1cwNFlCQ0tsa2FXN0d4dHpleXhJZWJKZXRVTWVOQ0dT?=
 =?utf-8?B?SHpPcit1eHpJTkFWVVJrNGRXNDl6eGpPN3NXVFpuL29uS05WdU1rSitmZk5D?=
 =?utf-8?B?SlViWm1KL3l0MUJUdVZJRUd1UWJOTXdnTHo1czUvcVNZYkltSkNiYmRiYnJ3?=
 =?utf-8?B?UC9Oc1NsL1VSVURkcXdka0g3OERoSjdwUXFCNkM1S0pZNUIwdVprMGQ5RHlz?=
 =?utf-8?B?MkJuUGQ4anFxRjlzdzRrNUhkZGhxMUtrM1VMNkJGZVVSSjBlTGt1VlJtbU5j?=
 =?utf-8?B?V0Z6dkt1S3JUN1ZGNW81NHh4ZTVvdE9BWnJrOEdoOUtPemtjZlMzZFduSGJU?=
 =?utf-8?B?eHAreUROTmoxSjdRVTI4YzlHeFRNTm1DWTRONm5hbEdZaW5oazBXYVdBM1BT?=
 =?utf-8?B?UGxJTGlOSDA3dFVuQUxYMmVlalRDV3A3bkZoOWhLVkVXT0dkdENyUkVJVDcy?=
 =?utf-8?Q?DENX3MlEezhg32nrBcCaC7YBVJeG9cjkF5oXEL70Hg=3D?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a55299d7-24df-4827-e9d6-08d9d6729769
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2022 08:56:30.6583
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RBBSlHOSZ0ABtDBEGkJ4YcVY+b5ghsrOVX/Y5+1UGxVsygjqpN+F2yGXBfpJ1yLH4ebRrF6NoIKIghRFrcWIdw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1101MB2071
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKcHNf
dGltZW91dCBzaG91bGQgYmUgaW4gbmw4MDIxMSwgbm90IGluIGRlYnVnZnMuIExldCdzIHJlbW92
ZSBpdCB1bnRpbAp0aGUgZHJpdmVyIGlzIGFjY2VwdGVkLgoKU2lnbmVkLW9mZi1ieTogSsOpcsO0
bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgotLS0KIGRyaXZlcnMvc3Rh
Z2luZy93ZngvZGVidWcuYyB8IDIzIC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tCiBkcml2ZXJzL3N0
YWdpbmcvd2Z4L21haW4uYyAgfCAgMSAtCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jICAgfCAg
OCArKy0tLS0tLQogZHJpdmVycy9zdGFnaW5nL3dmeC93ZnguaCAgIHwgIDEgLQogNCBmaWxlcyBj
aGFuZ2VkLCAyIGluc2VydGlvbnMoKyksIDMxIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2Ry
aXZlcnMvc3RhZ2luZy93ZngvZGVidWcuYyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvZGVidWcuYwpp
bmRleCBhZTc4OTVlYTM2ZDkuLmU4MjY1MjA4ZjlhNSAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFn
aW5nL3dmeC9kZWJ1Zy5jCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvZGVidWcuYwpAQCAtMzE2
LDI4ICszMTYsNiBAQCBzdGF0aWMgY29uc3Qgc3RydWN0IGZpbGVfb3BlcmF0aW9ucyB3Znhfc2Vu
ZF9oaWZfbXNnX2ZvcHMgPSB7CiAJLnJlYWQgPSB3Znhfc2VuZF9oaWZfbXNnX3JlYWQsCiB9Owog
Ci1zdGF0aWMgaW50IHdmeF9wc190aW1lb3V0X3NldCh2b2lkICpkYXRhLCB1NjQgdmFsKQotewot
CXN0cnVjdCB3ZnhfZGV2ICp3ZGV2ID0gKHN0cnVjdCB3ZnhfZGV2ICopZGF0YTsKLQlzdHJ1Y3Qg
d2Z4X3ZpZiAqd3ZpZjsKLQotCXdkZXYtPmZvcmNlX3BzX3RpbWVvdXQgPSB2YWw7Ci0Jd3ZpZiA9
IE5VTEw7Ci0Jd2hpbGUgKCh3dmlmID0gd3ZpZl9pdGVyYXRlKHdkZXYsIHd2aWYpKSAhPSBOVUxM
KQotCQl3ZnhfdXBkYXRlX3BtKHd2aWYpOwotCXJldHVybiAwOwotfQotCi1zdGF0aWMgaW50IHdm
eF9wc190aW1lb3V0X2dldCh2b2lkICpkYXRhLCB1NjQgKnZhbCkKLXsKLQlzdHJ1Y3Qgd2Z4X2Rl
diAqd2RldiA9IChzdHJ1Y3Qgd2Z4X2RldiAqKWRhdGE7Ci0KLQkqdmFsID0gd2Rldi0+Zm9yY2Vf
cHNfdGltZW91dDsKLQlyZXR1cm4gMDsKLX0KLQotREVGSU5FX0RFQlVHRlNfQVRUUklCVVRFKHdm
eF9wc190aW1lb3V0X2ZvcHMsIHdmeF9wc190aW1lb3V0X2dldCwgd2Z4X3BzX3RpbWVvdXRfc2V0
LCAiJWxsZFxuIik7Ci0KIGludCB3ZnhfZGVidWdfaW5pdChzdHJ1Y3Qgd2Z4X2RldiAqd2RldikK
IHsKIAlzdHJ1Y3QgZGVudHJ5ICpkOwpAQCAtMzQ4LDcgKzMyNiw2IEBAIGludCB3ZnhfZGVidWdf
aW5pdChzdHJ1Y3Qgd2Z4X2RldiAqd2RldikKIAlkZWJ1Z2ZzX2NyZWF0ZV9maWxlKCJ0eF9wb3dl
cl9sb29wIiwgMDQ0NCwgZCwgd2RldiwgJndmeF90eF9wb3dlcl9sb29wX2ZvcHMpOwogCWRlYnVn
ZnNfY3JlYXRlX2ZpbGUoInNlbmRfcGRzIiwgMDIwMCwgZCwgd2RldiwgJndmeF9zZW5kX3Bkc19m
b3BzKTsKIAlkZWJ1Z2ZzX2NyZWF0ZV9maWxlKCJzZW5kX2hpZl9tc2ciLCAwNjAwLCBkLCB3ZGV2
LCAmd2Z4X3NlbmRfaGlmX21zZ19mb3BzKTsKLQlkZWJ1Z2ZzX2NyZWF0ZV9maWxlKCJwc190aW1l
b3V0IiwgMDYwMCwgZCwgd2RldiwgJndmeF9wc190aW1lb3V0X2ZvcHMpOwogCiAJcmV0dXJuIDA7
CiB9CmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L21haW4uYyBiL2RyaXZlcnMvc3Rh
Z2luZy93ZngvbWFpbi5jCmluZGV4IDQ2ZmQ1NzAyZTQ3MS4uYTk4YTI2MWY2ZDc2IDEwMDY0NAot
LS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L21haW4uYworKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4
L21haW4uYwpAQCAtMzI0LDcgKzMyNCw2IEBAIHN0cnVjdCB3ZnhfZGV2ICp3ZnhfaW5pdF9jb21t
b24oc3RydWN0IGRldmljZSAqZGV2LCBjb25zdCBzdHJ1Y3Qgd2Z4X3BsYXRmb3JtX2RhCiAJc2ti
X3F1ZXVlX2hlYWRfaW5pdCgmd2Rldi0+dHhfcGVuZGluZyk7CiAJaW5pdF93YWl0cXVldWVfaGVh
ZCgmd2Rldi0+dHhfZGVxdWV1ZSk7CiAJd2Z4X2luaXRfaGlmX2NtZCgmd2Rldi0+aGlmX2NtZCk7
Ci0Jd2Rldi0+Zm9yY2VfcHNfdGltZW91dCA9IC0xOwogCiAJaWYgKGRldm1fYWRkX2FjdGlvbl9v
cl9yZXNldChkZXYsIHdmeF9mcmVlX2NvbW1vbiwgd2RldikpCiAJCXJldHVybiBOVUxMOwpkaWZm
IC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYyBiL2RyaXZlcnMvc3RhZ2luZy93Zngv
c3RhLmMKaW5kZXggODNmMWFjODdlMGYyLi5iYTUzZTRkNzBjNGYgMTAwNjQ0Ci0tLSBhL2RyaXZl
cnMvc3RhZ2luZy93Zngvc3RhLmMKKysrIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYwpAQCAt
MTcxLDE4ICsxNzEsMTQgQEAgc3RhdGljIGludCB3ZnhfZ2V0X3BzX3RpbWVvdXQoc3RydWN0IHdm
eF92aWYgKnd2aWYsIGJvb2wgKmVuYWJsZV9wcykKIAkJLyogSXQgaXMgbmVjZXNzYXJ5IHRvIGVu
YWJsZSBQUyBpZiBjaGFubmVscyBhcmUgZGlmZmVyZW50LiAqLwogCQlpZiAoZW5hYmxlX3BzKQog
CQkJKmVuYWJsZV9wcyA9IHRydWU7Ci0JCWlmICh3dmlmLT53ZGV2LT5mb3JjZV9wc190aW1lb3V0
ID4gLTEpCi0JCQlyZXR1cm4gd3ZpZi0+d2Rldi0+Zm9yY2VfcHNfdGltZW91dDsKLQkJZWxzZSBp
ZiAod2Z4X2FwaV9vbGRlcl90aGFuKHd2aWYtPndkZXYsIDMsIDIpKQorCQlpZiAod2Z4X2FwaV9v
bGRlcl90aGFuKHd2aWYtPndkZXYsIDMsIDIpKQogCQkJcmV0dXJuIDA7CiAJCWVsc2UKIAkJCXJl
dHVybiAzMDsKIAl9CiAJaWYgKGVuYWJsZV9wcykKIAkJKmVuYWJsZV9wcyA9IHd2aWYtPnZpZi0+
YnNzX2NvbmYucHM7Ci0JaWYgKHd2aWYtPndkZXYtPmZvcmNlX3BzX3RpbWVvdXQgPiAtMSkKLQkJ
cmV0dXJuIHd2aWYtPndkZXYtPmZvcmNlX3BzX3RpbWVvdXQ7Ci0JZWxzZSBpZiAod3ZpZi0+dmlm
LT5ic3NfY29uZi5hc3NvYyAmJiB3dmlmLT52aWYtPmJzc19jb25mLnBzKQorCWlmICh3dmlmLT52
aWYtPmJzc19jb25mLmFzc29jICYmIHd2aWYtPnZpZi0+YnNzX2NvbmYucHMpCiAJCXJldHVybiBj
b25mLT5keW5hbWljX3BzX3RpbWVvdXQ7CiAJZWxzZQogCQlyZXR1cm4gLTE7CmRpZmYgLS1naXQg
YS9kcml2ZXJzL3N0YWdpbmcvd2Z4L3dmeC5oIGIvZHJpdmVycy9zdGFnaW5nL3dmeC93ZnguaApp
bmRleCAwZmM4MzY2ZDlmYjMuLjY1OTRjYzY0N2MyZiAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFn
aW5nL3dmeC93ZnguaAorKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3dmeC5oCkBAIC01Nyw3ICs1
Nyw2IEBAIHN0cnVjdCB3ZnhfZGV2IHsKIAlzdHJ1Y3QgbXV0ZXggICAgICAgICAgICAgICByeF9z
dGF0c19sb2NrOwogCXN0cnVjdCB3ZnhfaGlmX3R4X3Bvd2VyX2xvb3BfaW5mbyB0eF9wb3dlcl9s
b29wX2luZm87CiAJc3RydWN0IG11dGV4ICAgICAgICAgICAgICAgdHhfcG93ZXJfbG9vcF9pbmZv
X2xvY2s7Ci0JaW50CQkJZm9yY2VfcHNfdGltZW91dDsKIH07CiAKIHN0cnVjdCB3ZnhfdmlmIHsK
LS0gCjIuMzQuMQoK
