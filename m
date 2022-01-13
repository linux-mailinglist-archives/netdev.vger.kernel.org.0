Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A803948D421
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 09:57:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233248AbiAMI4k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 03:56:40 -0500
Received: from mail-co1nam11on2086.outbound.protection.outlook.com ([40.107.220.86]:28322
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233137AbiAMI4T (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jan 2022 03:56:19 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L8rHHY+r3CL2CiebgJMxGThPKAW6t7NaZkmirOahmavH9pa2DlzflPmOfMI46s+cguyo55udj3Z26fy8JAK7/snDKzkFSVvysar7KfY5Ra8aeD7X2SSG02OzMlSTLHt6WDdHTkJSGImHIY3jAjwfhqoOEaqs+hGZeO2wS7l8ejueNTofHaOZup4Gf+Of+XWdd6PNdQBvTwrVNSf5CX3+vNlFJ6g3S1nQAFyjSOWl7C3SOsTWcJGfnKKXdFC9J62RDCKLNOFw3rHJFixdILDo20t21E5vnE/G2YIEopDRlmQuCKmIU93NklTQff6vhVEomJWcANNIShGu/ufRRUSZCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HpAOB4jPiwFwFBf9z7IRPkeyewY+ZAvGsFdxxTP7PvQ=;
 b=YS64Gubhb+ric0Z0XwhCmrxzsHIa2IwdxKNdJr1dKxdgM6VNjpfA6zXO4h0rrKwt0qoEIy5bgWJeGgm8I5IYaJaMLnB9uceey1s4Fml6U7HAx356Z1jn/AXptOXd7t1WFyGI37bTNXBuPDocmWstYu5ngr9bNlYGoqKO/hdgr4iKNtQh78QRcM27ObMeEZ9x5IY4ax/2E+qntmh3nqQe5dEsi+SI3Fj0gVEiwO2FvDXp7cqMiDMtflrJ1QSLX9kF6N/9sqrWBXUmac1vzfDPRfc5QebTKaFPm/+oDmTkETdzWGLzgLFBENgy/0qnp72ZPJejL/hHWqJ8UXlb6kRnnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HpAOB4jPiwFwFBf9z7IRPkeyewY+ZAvGsFdxxTP7PvQ=;
 b=bpwVHPwqXHywQVxXMaAlTst3zDewyEb0z+BmwAvLNjmxqSZboEBULwtL8OjPkOVBgdmV+9CdJdVll0cwEeiFavAn0QMqJ0AXg77TmZ/GF5DRC9K5n4FmwU8VDP2CPjSe83or426aHDAbzMVPQihtdFo6Uen08tKgRV4p3o9fY34=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=silabs.com;
Received: from PH0PR11MB5657.namprd11.prod.outlook.com (2603:10b6:510:ee::19)
 by BY5PR11MB4040.namprd11.prod.outlook.com (2603:10b6:a03:186::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.10; Thu, 13 Jan
 2022 08:56:09 +0000
Received: from PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::d031:da9e:71a:73e4]) by PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::d031:da9e:71a:73e4%5]) with mapi id 15.20.4888.011; Thu, 13 Jan 2022
 08:56:09 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 16/31] staging: wfx: prefix functions from debug.h with wfx_
Date:   Thu, 13 Jan 2022 09:55:09 +0100
Message-Id: <20220113085524.1110708-17-Jerome.Pouiller@silabs.com>
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
X-MS-Office365-Filtering-Correlation-Id: 048bb83d-65d3-4ade-7914-08d9d6728ae4
X-MS-TrafficTypeDiagnostic: BY5PR11MB4040:EE_
X-Microsoft-Antispam-PRVS: <BY5PR11MB40402898BB5FB24A6B66CDE793539@BY5PR11MB4040.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:229;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oc3iBh0XeOG64m2kHbbzDvpOjnbWTa2FwGPaFKgiUcFCzh1K+Iy0+Kn1AZmtvNY4aBibG4TVnO6jGuqjl/wKzoOvXtuToxrwNoRaQRMbdz01GV4Jet1YuK16RGpA0BQoAVnE8UCseq9y7ljok5G45gR6G1z9lRsq4JpmkftwfbfkAE3Vczr/UZH3vS301CVv2O6ufk04kWoigCK3ri3DKc6/LoD7dtHdAorPTETGLPkhaMeMeEa0a7B6QhTW07JnLAMlplOG2c/UJTkCK6xY24Mcl/5X5lTs0q8HsyGAUTWGUkaXbqiWa2Lg7jW2qEHTPHuPYRGPSw2rC7UhPOy/fIqyytjG9ePWHUrkzlYNACE8iHtF2Jcvu5WNW7tZidpLx3YCLqTIYENTlftOhsMIl+A15EFsBid8/sDOvAZWg+IJHciIhI9QTVhJlHbX8/AeS9w/QZlN8CHj7XMuMqIYpw1NbhWANhgtWZ5439wjrsRBat/2EOGxAjEbIXrreSyjx1SKzyg0i4t6HegzhUARfj1p6SVcuC1OJqLKfvJFnS15YLTGMTLqccCVdQZcPSq6FzEHDQaSFY1CPT/7Tt7SNim6Ne4toFth4nPz5Mzqbiq/MIy0eLnF39+v8W+yPriGeP5LG9at6CKze0li7GunTQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6506007)(508600001)(186003)(38100700002)(4326008)(8936002)(6512007)(66946007)(83380400001)(1076003)(2616005)(54906003)(86362001)(66556008)(2906002)(66476007)(316002)(52116002)(36756003)(5660300002)(66574015)(8676002)(6486002)(107886003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Q2Vqd0FBWEc4K25kb0pPQWFrYlVYUGxFcGJOQ0NHQjBMaU9oRXI5N2g1U3hZ?=
 =?utf-8?B?V0tEYThDT1NNaVBkTmpOVWlzdzE1NWU0YWN0MUdrbG9DVWovNXJRSm11RnVI?=
 =?utf-8?B?dGN3c1VlRXlXcEJ3TVRNamRaY1V6RnpSVGRSNkpNK1BGNXRxT0FiVWVjWDFT?=
 =?utf-8?B?a3lLNDRoVTNVNUd4WGpISTJ1RzM4WGg1RStNTmlvMU1pNzNQMWtJM0NNMmU4?=
 =?utf-8?B?QWIyR3VmQ0lha1lvL0MzOVRRM1ZUamJRZHIvam5sMitxVitIbTlOWk9PREk4?=
 =?utf-8?B?eG5IQldtQ3pDQnMyM2hZcXdQcDlxZ1JpN1lnbHdzbStxZWtCbThjUnY0bFV5?=
 =?utf-8?B?TnNjZlVYM0Nzb1Q5Mko5dGU3NnRZS202TklMS2ZkNmZmM1h6NGFQb3dPWkVO?=
 =?utf-8?B?QUJ1Y3hlc1BlWXo1U0t6dlozUUcwSDNzMERyTDcvZGh3elJwN0R3OWZZSkZS?=
 =?utf-8?B?Z3hqazZpQlVyWTA5cnhRQ3NJYUlSTnpoUEJJb1kzSUoyN0VJSEs5bVg2UjRl?=
 =?utf-8?B?MlQrbFNxUTJqRDVwWUlJb3k2ekQ2WUF2b2F0QnJZZ2lJWmVoRTB3OUhTWVIr?=
 =?utf-8?B?ZWwvc0FNSGRLQ2JZL25iM1J1RThvaFZXNkR0SHA3UVN0ZTM4SVY0MW5Ya2t4?=
 =?utf-8?B?RjJOOGQrekFTbXJzK3V3ZThSajM2OHl5K2VsamdqOHk3TE1UWHNNZWNhSUpJ?=
 =?utf-8?B?MERTY2FIeW83WGRUSTBVa3FYdFhHNkIzeCtyNlgwRGxuVTdSUjcxNmVGYnhr?=
 =?utf-8?B?VElUUWVLSlNiaElnUnQrWEVKcWpPRlJlaXhJdi8vdE1KS2dSalZ2cG1rbmFm?=
 =?utf-8?B?T1g1ZENoZkRrdkVLcEVISG9xWDRqRkVnTzJPeVhmR3VUa09yU0pDcDRVMFBn?=
 =?utf-8?B?cmRVVWxiVjBkQytMT2dtNHlaMTUyZlBERjBBMDJHeFRac0N4WDE0YzQyVjFZ?=
 =?utf-8?B?L29DajNHclljUjhXSXBXQzVtY0ltQmpTTTJVRGFpencvSXV4OFA4dHBhdUVX?=
 =?utf-8?B?eENzV2F2Ym9xWVlNUExPc2hFMGV1UjYxbG5jM1FGbk56ZEtucjB3Z0hEbzI0?=
 =?utf-8?B?N3dRV1NXVm43MXJyUGhZTmdUcXdXVjdHQmN6N3hUeXlFaHgrbjg0VlVRZzhV?=
 =?utf-8?B?d3N2VlhRdFNaNGNLY2dwSXpQbGhVRDVubldaWU9qWEtUeE4ra3Z6YUo2MUQ1?=
 =?utf-8?B?VmdqR3UyMkNFOFNyMEdOQTR6R0Nxc1ZxNm03Q0Z2QUNmWW9iWWx3SGJzNVU5?=
 =?utf-8?B?WHNwNUNLUExZUFdjZXlWd0lZK29nK00rZ1hFTUtoZ1VtblBlNXFBZmJYQlRN?=
 =?utf-8?B?SzMyOHNLSGNqQUxyVVFlVHFkdVZNYlVmK0YvMnFsZ3ZPNHpFdjRJNkZFQnlq?=
 =?utf-8?B?d2ExR0hNUlRDU3VMZlRlQjMycjU0NWFKSTR4SEJ3WldVQWpUSkhVMEVGeWto?=
 =?utf-8?B?bXhBWkJoZGRQMTM3Z0RzZElaRENyakZmN1ArZ01wMVQ4VUp5ZHh2N0Y1Nldk?=
 =?utf-8?B?L2NOK1VnOTEwQXhjWU5vNXRMUXJTa3ZaRWd2RG5CYmJnSHJZNzN1TTdKMm03?=
 =?utf-8?B?a0FWeWtsL0QzYXUzbFpKRDNRdEU5dTBSUlVKS08wVk0yL0hVZzAwU01lamIv?=
 =?utf-8?B?RlNOMm9JNDZyUXJuS3B1YTVoS3dXYWhCaG9hcmhPdUlFZHlOVVBaSWsrRVVL?=
 =?utf-8?B?clhVc0V5L2QvZW05M0Zsa0QxUm93MVBrSmtrN0dSWUczNWoxNFh3THh6Q2I4?=
 =?utf-8?B?dDJsWWlZZnNRYWV2VWE0SzJMSjJsWG9JN3BJa3QwOEh4S29HOGhCdVU0dGdN?=
 =?utf-8?B?d1lqRkdpVW1MTlZNaDRHd1hZdG4yNC94anhkU0tPRS8xN0dLdVdFanNCc2JT?=
 =?utf-8?B?ZmtDUVJKSXFKTnc5c3VDN1RobmQ4b2poWjhKZ0Y2Z0ZIalJwVGdRdmlUUzZZ?=
 =?utf-8?B?Mm1adWJNWVp4K2doL0RhOTJTaGFRVHhCNHFiM2tHYWdwV3VJcnBhb1RIRDZY?=
 =?utf-8?B?UjVrbjArN3RJSDJiSXNza3gvWmpsVlBaMWhLSS9RdW40K0wwVGtuUGtsSTlr?=
 =?utf-8?B?WXZRVldEYWp1TzNRZitETXpsa1R3VmtldUkwUU00dFA0VkhTTlJoSmxYa2V6?=
 =?utf-8?B?Z1cvVW1LQmo3anZ5eGlLd0xqcDBwc1oyTjZ5QVpzU0diM3VEUElIeFpWTENj?=
 =?utf-8?B?VmZaQXdYNmRKNzc1T1pqT2N6QWExNTFKK28xM1Bzcy9KR3JadG5RKzdXT1Rt?=
 =?utf-8?Q?lEibCAOQtpD4FKJajRDOVqKpSy0X13B9AxwzcRVXNM=3D?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 048bb83d-65d3-4ade-7914-08d9d6728ae4
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2022 08:56:09.6980
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Bkmw5iBWUHFgF1HUm1Mbp0e4YRYSIL4oof/0525Vdy1HQHdxv/P9uAmlE/EIneG/Wls3NGxXeaURVgpkbBakxA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR11MB4040
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKQWxs
IHRoZSBmdW5jdGlvbnMgcmVsYXRlZCB0byBhIGRyaXZlciBzaG91bGQgdXNlIHRoZSBzYW1lIHBy
ZWZpeC4KClNpZ25lZC1vZmYtYnk6IErDqXLDtG1lIFBvdWlsbGVyIDxqZXJvbWUucG91aWxsZXJA
c2lsYWJzLmNvbT4KLS0tCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L2RlYnVnLmMgIHwgNiArKystLS0K
IGRyaXZlcnMvc3RhZ2luZy93ZngvZGVidWcuaCAgfCA2ICsrKy0tLQogZHJpdmVycy9zdGFnaW5n
L3dmeC9oaWZfdHguYyB8IDggKysrKy0tLS0KIDMgZmlsZXMgY2hhbmdlZCwgMTAgaW5zZXJ0aW9u
cygrKSwgMTAgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9k
ZWJ1Zy5jIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9kZWJ1Zy5jCmluZGV4IGU1Zjk0MGYxOWJiZS4u
OTMyNDI0OGIxZDIwIDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2RlYnVnLmMKKysr
IGIvZHJpdmVycy9zdGFnaW5nL3dmeC9kZWJ1Zy5jCkBAIC00NCwxNyArNDQsMTcgQEAgc3RhdGlj
IGNvbnN0IGNoYXIgKmdldF9zeW1ib2wodW5zaWduZWQgbG9uZyB2YWwsCiAJcmV0dXJuICJ1bmtu
b3duIjsKIH0KIAotY29uc3QgY2hhciAqZ2V0X2hpZl9uYW1lKHVuc2lnbmVkIGxvbmcgaWQpCitj
b25zdCBjaGFyICp3ZnhfZ2V0X2hpZl9uYW1lKHVuc2lnbmVkIGxvbmcgaWQpCiB7CiAJcmV0dXJu
IGdldF9zeW1ib2woaWQsIGhpZl9tc2dfcHJpbnRfbWFwKTsKIH0KIAotY29uc3QgY2hhciAqZ2V0
X21pYl9uYW1lKHVuc2lnbmVkIGxvbmcgaWQpCitjb25zdCBjaGFyICp3ZnhfZ2V0X21pYl9uYW1l
KHVuc2lnbmVkIGxvbmcgaWQpCiB7CiAJcmV0dXJuIGdldF9zeW1ib2woaWQsIGhpZl9taWJfcHJp
bnRfbWFwKTsKIH0KIAotY29uc3QgY2hhciAqZ2V0X3JlZ19uYW1lKHVuc2lnbmVkIGxvbmcgaWQp
Citjb25zdCBjaGFyICp3ZnhfZ2V0X3JlZ19uYW1lKHVuc2lnbmVkIGxvbmcgaWQpCiB7CiAJcmV0
dXJuIGdldF9zeW1ib2woaWQsIHdmeF9yZWdfcHJpbnRfbWFwKTsKIH0KZGlmZiAtLWdpdCBhL2Ry
aXZlcnMvc3RhZ2luZy93ZngvZGVidWcuaCBiL2RyaXZlcnMvc3RhZ2luZy93ZngvZGVidWcuaApp
bmRleCA0YjljNDlhOWZmZmIuLjM4NDA1NzVlNWUyOCAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFn
aW5nL3dmeC9kZWJ1Zy5oCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvZGVidWcuaApAQCAtMTIs
OCArMTIsOCBAQCBzdHJ1Y3Qgd2Z4X2RldjsKIAogaW50IHdmeF9kZWJ1Z19pbml0KHN0cnVjdCB3
ZnhfZGV2ICp3ZGV2KTsKIAotY29uc3QgY2hhciAqZ2V0X2hpZl9uYW1lKHVuc2lnbmVkIGxvbmcg
aWQpOwotY29uc3QgY2hhciAqZ2V0X21pYl9uYW1lKHVuc2lnbmVkIGxvbmcgaWQpOwotY29uc3Qg
Y2hhciAqZ2V0X3JlZ19uYW1lKHVuc2lnbmVkIGxvbmcgaWQpOworY29uc3QgY2hhciAqd2Z4X2dl
dF9oaWZfbmFtZSh1bnNpZ25lZCBsb25nIGlkKTsKK2NvbnN0IGNoYXIgKndmeF9nZXRfbWliX25h
bWUodW5zaWduZWQgbG9uZyBpZCk7Citjb25zdCBjaGFyICp3ZnhfZ2V0X3JlZ19uYW1lKHVuc2ln
bmVkIGxvbmcgaWQpOwogCiAjZW5kaWYKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93Zngv
aGlmX3R4LmMgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl90eC5jCmluZGV4IDk4OTllN2I2MjIw
My4uNjdmMTg0N2MxZmMxIDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl90eC5j
CisrKyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX3R4LmMKQEAgLTEwNiwxNSArMTA2LDE1IEBA
IGludCB3ZnhfY21kX3NlbmQoc3RydWN0IHdmeF9kZXYgKndkZXYsIHN0cnVjdCBoaWZfbXNnICpy
ZXF1ZXN0LAogCiAJaWYgKHJldCAmJgogCSAgICAoY21kID09IEhJRl9SRVFfSURfUkVBRF9NSUIg
fHwgY21kID09IEhJRl9SRVFfSURfV1JJVEVfTUlCKSkgewotCQltaWJfbmFtZSA9IGdldF9taWJf
bmFtZSgoKHUxNiAqKXJlcXVlc3QpWzJdKTsKKwkJbWliX25hbWUgPSB3ZnhfZ2V0X21pYl9uYW1l
KCgodTE2ICopcmVxdWVzdClbMl0pOwogCQltaWJfc2VwID0gIi8iOwogCX0KIAlpZiAocmV0IDwg
MCkKIAkJZGV2X2Vycih3ZGV2LT5kZXYsICJoYXJkd2FyZSByZXF1ZXN0ICVzJXMlcyAoJSMuMngp
IG9uIHZpZiAlZCByZXR1cm5lZCBlcnJvciAlZFxuIiwKLQkJCWdldF9oaWZfbmFtZShjbWQpLCBt
aWJfc2VwLCBtaWJfbmFtZSwgY21kLCB2aWYsIHJldCk7CisJCQl3ZnhfZ2V0X2hpZl9uYW1lKGNt
ZCksIG1pYl9zZXAsIG1pYl9uYW1lLCBjbWQsIHZpZiwgcmV0KTsKIAlpZiAocmV0ID4gMCkKIAkJ
ZGV2X3dhcm4od2Rldi0+ZGV2LCAiaGFyZHdhcmUgcmVxdWVzdCAlcyVzJXMgKCUjLjJ4KSBvbiB2
aWYgJWQgcmV0dXJuZWQgc3RhdHVzICVkXG4iLAotCQkJIGdldF9oaWZfbmFtZShjbWQpLCBtaWJf
c2VwLCBtaWJfbmFtZSwgY21kLCB2aWYsIHJldCk7CisJCQkgd2Z4X2dldF9oaWZfbmFtZShjbWQp
LCBtaWJfc2VwLCBtaWJfbmFtZSwgY21kLCB2aWYsIHJldCk7CiAKIAlyZXR1cm4gcmV0OwogfQpA
QCAtMTk2LDcgKzE5Niw3IEBAIGludCB3ZnhfaGlmX3JlYWRfbWliKHN0cnVjdCB3ZnhfZGV2ICp3
ZGV2LCBpbnQgdmlmX2lkLCB1MTYgbWliX2lkLAogCX0KIAlpZiAocmV0ID09IC1FTk9NRU0pCiAJ
CWRldl9lcnIod2Rldi0+ZGV2LCAiYnVmZmVyIGlzIHRvbyBzbWFsbCB0byByZWNlaXZlICVzICgl
enUgPCAlZClcbiIsCi0JCQlnZXRfbWliX25hbWUobWliX2lkKSwgdmFsX2xlbiwKKwkJCXdmeF9n
ZXRfbWliX25hbWUobWliX2lkKSwgdmFsX2xlbiwKIAkJCWxlMTZfdG9fY3B1KHJlcGx5LT5sZW5n
dGgpKTsKIAlpZiAoIXJldCkKIAkJbWVtY3B5KHZhbCwgJnJlcGx5LT5taWJfZGF0YSwgbGUxNl90
b19jcHUocmVwbHktPmxlbmd0aCkpOwotLSAKMi4zNC4xCgo=
