Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAE6048D3F4
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 09:56:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231528AbiAMIzw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 03:55:52 -0500
Received: from mail-co1nam11on2053.outbound.protection.outlook.com ([40.107.220.53]:51425
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231301AbiAMIzp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jan 2022 03:55:45 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LFzZPaQCBWx9vpBIGyOWAXcHAmKo3aNhkYTyZVNErYnDEkQFnhRGdeqbeCr0t3AzusKbV8yA6mMt841q3CxCjSCfbuoM8Obft4m3mQEImX6NDdEztnHXQqsW+n1+X/+zv7PMixCVmpWvNSdIEaCBH8BKwddha9ComziGnYI5a6B4+1lNsgCsuw2ywSlsmayqCCxQKhLERZ5ocgz0lxSqD8/mAfwKQrEUgeYz4q0UEQxUnA3xx8MDToWFR9Yy8asXgkYEi2kqJkljY11nqf7XI61eXCn925hSQ6xs2BrfbnAdx5BYsOBzWdjls7/iH2SZlHFBIKj51ZLVTt3FL/L1bg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9+/IB7ST8nlr1026UP+IngQPCmbmpjBPYvEwZJa3Mhs=;
 b=DXc4gFmzyHgotmMfpALhTErh077fxE4eOxScsBO4oAIJ3T6er6DRw0E1A4N9m/15nHmjBy4njFDmoWqO3PgFzZZP93H0uNFq1DKBxvAVAWgjSh9FUutp5K18vihUYP7gxxMVbzoc1omvDrIqzj0hEDBJNGdkxwxKRq+hXAYhlSk6zhPFIk6y006jZRXfo+PEspbPE9dhceQ9N/jCiT/XCEn6V+4AASNGr3W0zJHYyZ7i6z+abGXDMwTMalJq+DVRzKdCYANCBmPMA5KRJPYS8Lf00//ncRw27tLMup6+f7b4NyGSlxbUPjFbDbSt9aH/yN1KMEDFXx0ZxEyqRy8P/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9+/IB7ST8nlr1026UP+IngQPCmbmpjBPYvEwZJa3Mhs=;
 b=BLQwfu1mf3Ndq1p6IMXG4eQbke2OVRakKpIcXhzI9/UlUJkqYiRCZp3uGAr3Y4xqPt4GB8nsTZhasoc0mhNPzD4jU5RR0rAiYfFOjtH2eLnyPvXcTD4rABV/ZD7vAnrdSthMaDLEJYqHJfO9kn48/4aNE0rzV1iIkkYVwvdQqmA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=silabs.com;
Received: from PH0PR11MB5657.namprd11.prod.outlook.com (2603:10b6:510:ee::19)
 by BY5PR11MB4040.namprd11.prod.outlook.com (2603:10b6:a03:186::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.10; Thu, 13 Jan
 2022 08:55:44 +0000
Received: from PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::d031:da9e:71a:73e4]) by PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::d031:da9e:71a:73e4%5]) with mapi id 15.20.4888.011; Thu, 13 Jan 2022
 08:55:44 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 03/31] staging: wfx: fix missing headers
Date:   Thu, 13 Jan 2022 09:54:56 +0100
Message-Id: <20220113085524.1110708-4-Jerome.Pouiller@silabs.com>
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
X-MS-Office365-Filtering-Correlation-Id: b622f7f8-f28d-44f7-913f-08d9d6727b90
X-MS-TrafficTypeDiagnostic: BY5PR11MB4040:EE_
X-Microsoft-Antispam-PRVS: <BY5PR11MB4040C6E7266A031012423BE193539@BY5PR11MB4040.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:551;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6gyyL0K2L5bJuEgZXSPFFlViEFoAPP1FNrAH/zOMgNUhWgxVtQ/TZYuK4r6dyDkYD6PEv0viq7S4U3mfEDq/lvHAS7VfiiCe2EcNEujIPtmI4UvAtj8PypYPz1Oyqj3Erc2jvPlMam1fcwl41GlnLXuvCWbaisId34TSOj6otV68BfURLRDsQo0js4r/cZwdqKWjqzJstVlW5Mqid2dbzPaHPWvuiFZEW6YbygFV4gVvNTug+CgCAqm80XrMQjpsshZU4Hr9QYpUlVoWzeIuMVHaVvlvY0wJm7q9eOY5fJRaSsPCU1AK7UCl6ouiq7dNzCtqA0SXeVRXc0fLxFV7g6o8LDTgiSNW1ZnNK8XuXsvWukWaypbzQyXk5xhu0FLJ8eTUpNx89kEf7n8WWYmY98V8nBbBa8K7014nHKpMSjs2o+lbBU5NfYDwiQpGPw4b/ZvtzZZBLev3/csBUKqUmfhXSLVIxCjGIanjNfyRMDG9rewOREKKYA2p/6t/+y6LVzT98io37xBY8Y8OgDYwfFYEz1OIDC9+VBRJAFNkaYDLpq3BvrVKSzOr9D9PSRB8jPth1SJFUC9UfDucsDbVUcASBtiBcv+iAn22N0fX82Mf56OFfPrB2PcDEjImlSdjB+IEVTBvqCyJt8CdUeJyjA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6506007)(508600001)(186003)(38100700002)(4326008)(8936002)(6512007)(6666004)(66946007)(83380400001)(1076003)(2616005)(54906003)(86362001)(66556008)(2906002)(66476007)(316002)(52116002)(36756003)(5660300002)(66574015)(8676002)(6486002)(107886003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?M3VnZ0VmckE1bTE5Mndwc3lpSk4vczAzOWh5VUtMV3JxcnZJMmRtTWwxTnda?=
 =?utf-8?B?TXZBdU8ySFNPVkRPZ0daNEdpYkFNSDJ4NlcwQ1FURjRQeDdqVFAwK0pIc2xY?=
 =?utf-8?B?V1dDalgyaXBZSFV1cUl5TlhXY0NYTHIvUFNzb283Vmw2ZlhybnlqK05ESlNB?=
 =?utf-8?B?R3NndFMvcTlwazFWN1RtUG9rdmV1NnpCOWpaMVB6czF4TXZSWWxoeW5iVllh?=
 =?utf-8?B?NkpnU2ZQQXdFT1ZQZkptczdCaVhVUEphd0dYQkU3dlFyeE4wbU9FcU8wWURz?=
 =?utf-8?B?blNGTnNUS0RxK3JUOEkxUlJPM0JIZE0zUVFCUGhBZG5RRytpcVhBSDQzdlRI?=
 =?utf-8?B?OS9zQWhQSDB3dmN4dW9VNnZhTnF1MjdVclRhNEp4d2FFQkxVS3EzeG9BQmR2?=
 =?utf-8?B?Y00rajdVSSs4eHUzaVV6dUpFS1FSRUgyTUg2VjUvV28rMFZUUWdhNHdEV1hL?=
 =?utf-8?B?WDcyUXd2Z2tWRlRiYWtLQ0VsUE9wVXV2YnBXcyt5WXdrVC9oL3dLdWcwdk9E?=
 =?utf-8?B?V1UxTCtQSitIMkhMSzhGeFRNK1hSZjVtK2V6N2d1bTQrT3M2NmtzUXVoTkJr?=
 =?utf-8?B?R2ZQaEJlN3VBRFF4RXBES1dLV0I0VGdtcFBDU1pyQmxKKzd0a2Q2Nnd4bnlD?=
 =?utf-8?B?b0k3MGUrbkJpZGRuU0JGdGhRR0Q2a3VUbm5BODVQUkdESnVJUzU2NFJsTExv?=
 =?utf-8?B?VmxIR0U3WDRlMjh1NEtKQXJBM3NuamJhZVBLZ2JtVXpYRmxLTHJNMDlPSVJI?=
 =?utf-8?B?U0xZSUIyK3FCWkU5YVdKMGoyYUdIb0pxVjFmaDlYalNDMXpnZ0hkMVU2UzRt?=
 =?utf-8?B?MnpmdXlpdVN0amloOGZjSEZHZzJ3czJPTlo3NngxMDV4N3JjeXQ0SXlRNGxa?=
 =?utf-8?B?L1EvUXdIMlF2WnhoQWJ4YkhyUDRHcFllL3ZIRDg2amtXd2FIYmhmTEplVEVW?=
 =?utf-8?B?OXNEQ2hHSk9tYVZ3emV6SWV1MmlhRTN4ZGw3UGRZc1hOemk4TlhiYVI2cWVl?=
 =?utf-8?B?bm1nYzRiRlphdk1Xa2pyRW1RYUE4YUcvQXl0YnFCWVJQS0JraVV5VzFPR1FH?=
 =?utf-8?B?NHJGc3c2RkJqT2N6a2lXK2RZdGVNM2lTeUVQN05LYXZLY1piNzE0VDJkbE1W?=
 =?utf-8?B?eldKR0JNOVBuMER2Yyt5dVUwZmQ3WEozUUN1eW5JR25oSERwUEtOTmZGKzhV?=
 =?utf-8?B?MWNpYzN0aHBZRWVNb3dhOGdNQm9pT3JCQ3N6bVEvOWV1V01sMjh0bWV6YWR5?=
 =?utf-8?B?Q1JkTlY5ZFFHY05GcE0vaERyeGZEbGVtVTdRcEpDT2tvQWJYSWFOSDJHRnIw?=
 =?utf-8?B?SWtZd0FqNEVIK09Dc0crcGYwTThBN3ZEV3RMZWZtbmovdVVUUFFKdFdNbzRn?=
 =?utf-8?B?WnBVS2ZUc1gwMFgzSE1SaU9JVFZKSGdScjhqQ1JxQ1pvYmRNeXJpNkp1RnpP?=
 =?utf-8?B?YXFBd3MyR0VlU1FyeTZUb2RlSWFBQVlCbXlCNjA3ZGl3aWdNRWdYVlliZUFj?=
 =?utf-8?B?SFZiWll4WTZzK0xrMXdNUmVESlRiSVovTEpCQXNYUGNQNTlURDhjcTZZWEVO?=
 =?utf-8?B?T3lQbUhJa2dtdDl5RU5mZGlZVkNoWTEyeWZLNmxtOTcvbVRMUDRyWnB3QS8r?=
 =?utf-8?B?U1Ruenc1WVF4dGpKWnJrcHFaUFc2Rng2Q2lWRFlKZE5DK3Baa2IydkhTdnl2?=
 =?utf-8?B?ckFNTVI2R2FnWVRlTWZJZlNnQmlVeEZrZzhMZStBZkY5VDVsYVN5ZGo3VWJG?=
 =?utf-8?B?OUtJU3R1TU5wS2paTVZsTVhIYTF1a3VRblFuSVo0OFIrZ3Y2SHIrR3F2WlVC?=
 =?utf-8?B?dWd1T2tabGVPVGtHR1BUWkE3d0QrWE1PVTdWcFgzbG9vZjUxSS85STZLWGpK?=
 =?utf-8?B?M3FMeVZGVTlqUlhRUW1QRmkvSXFLY0s1MFJqRWpVTmtNODdOenFva29pbTRx?=
 =?utf-8?B?VWNaY3N5bmMwYU5qK2FVTTdIVlY2Z2VveXR1YzlaSmVSSWd3NFZ2c1QzOTU3?=
 =?utf-8?B?bHV1a0F3R2VGZWh2M3ZZVkZQMjdGaXhBVjc3SGliS2lISW5kQUc5WEZucHlG?=
 =?utf-8?B?b2NEMEUvNzhBaUVRQVI0OUdCelRPSlF3c0tUYUxQNW0rQWpNNmpMRWFhRTla?=
 =?utf-8?B?YWtlRnhnUGVuMG1jaVZNZWI3R3VXU043Q2NTU2ZCbVpIT01aR2l1TU0xaDJv?=
 =?utf-8?B?VXhGMmZsaHNkdkNuS1lzYWV0NW1DYjJwRUlmQi82VVZMc2NOOXlZUGp6VHc3?=
 =?utf-8?Q?2uy6vRYyRRUrz2DuRELMIYJT8g+aPPuBzVbTrEuTKg=3D?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b622f7f8-f28d-44f7-913f-08d9d6727b90
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2022 08:55:43.9979
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ruzHruSeKO+MYnzbx8weMpkWJaG0uUHhqfPiDg9o6snwjJzimw6LJfXKuzUqj28tOnJ4tJpGOm7pjTCqK830Ow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR11MB4040
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKRWFj
aCBoZWFkZXJzIGZpbGVzIHNob3VsZCBpbmNsdWRlIGV2ZXJ5IHR5cGVzIGl0IG5lZWRzIHRvIGNv
bXBpbGUgKGllLgoiZ2NjICRDRkxBR1MgLXhjIGZpbGUuaCIgc2hvdWxkIGNvbXBpbGUpCgpTaWdu
ZWQtb2ZmLWJ5OiBKw6lyw7RtZSBQb3VpbGxlciA8amVyb21lLnBvdWlsbGVyQHNpbGFicy5jb20+
Ci0tLQogZHJpdmVycy9zdGFnaW5nL3dmeC9iaC5oICAgICAgICAgfCAxICsKIGRyaXZlcnMvc3Rh
Z2luZy93ZngvaGlmX3R4LmggICAgIHwgNCArKysrCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl90
eF9taWIuaCB8IDcgKysrKysrLQogMyBmaWxlcyBjaGFuZ2VkLCAxMSBpbnNlcnRpb25zKCspLCAx
IGRlbGV0aW9uKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9iaC5oIGIvZHJp
dmVycy9zdGFnaW5nL3dmeC9iaC5oCmluZGV4IDZjMTIxY2U0ZGQzZi4uYTQ0YzhiNDIxYjdjIDEw
MDY0NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2JoLmgKKysrIGIvZHJpdmVycy9zdGFnaW5n
L3dmeC9iaC5oCkBAIC0xMCw2ICsxMCw3IEBACiAKICNpbmNsdWRlIDxsaW51eC9hdG9taWMuaD4K
ICNpbmNsdWRlIDxsaW51eC93YWl0Lmg+CisjaW5jbHVkZSA8bGludXgvY29tcGxldGlvbi5oPgog
I2luY2x1ZGUgPGxpbnV4L3dvcmtxdWV1ZS5oPgogCiBzdHJ1Y3Qgd2Z4X2RldjsKZGlmZiAtLWdp
dCBhL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX3R4LmggYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hp
Zl90eC5oCmluZGV4IGU1N2VhYmRjZmE3Ny4uZjc4OTU4NDU2ODZmIDEwMDY0NAotLS0gYS9kcml2
ZXJzL3N0YWdpbmcvd2Z4L2hpZl90eC5oCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX3R4
LmgKQEAgLTEwLDYgKzEwLDEwIEBACiAjaWZuZGVmIFdGWF9ISUZfVFhfSAogI2RlZmluZSBXRlhf
SElGX1RYX0gKIAorI2luY2x1ZGUgPGxpbnV4L3R5cGVzLmg+CisjaW5jbHVkZSA8bGludXgvbXV0
ZXguaD4KKyNpbmNsdWRlIDxsaW51eC9jb21wbGV0aW9uLmg+CisKIHN0cnVjdCBpZWVlODAyMTFf
Y2hhbm5lbDsKIHN0cnVjdCBpZWVlODAyMTFfYnNzX2NvbmY7CiBzdHJ1Y3QgaWVlZTgwMjExX3R4
X3F1ZXVlX3BhcmFtczsKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX3R4X21p
Yi5oIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfdHhfbWliLmgKaW5kZXggMmEzYjg0ODY4ZWU0
Li5mZTA4YTY5NDEyYWIgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX3R4X21p
Yi5oCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX3R4X21pYi5oCkBAIC05LDggKzksMTMg
QEAKICNpZm5kZWYgV0ZYX0hJRl9UWF9NSUJfSAogI2RlZmluZSBXRlhfSElGX1RYX01JQl9ICiAK
LXN0cnVjdCB3ZnhfdmlmOworI2luY2x1ZGUgPGxpbnV4L3R5cGVzLmg+CisKIHN0cnVjdCBza19i
dWZmOworc3RydWN0IHdmeF92aWY7CitzdHJ1Y3Qgd2Z4X2RldjsKK3N0cnVjdCBoaWZfaWVfdGFi
bGVfZW50cnk7CitzdHJ1Y3QgaGlmX21pYl9leHRlbmRlZF9jb3VudF90YWJsZTsKIAogaW50IGhp
Zl9zZXRfb3V0cHV0X3Bvd2VyKHN0cnVjdCB3ZnhfdmlmICp3dmlmLCBpbnQgdmFsKTsKIGludCBo
aWZfc2V0X2JlYWNvbl93YWtldXBfcGVyaW9kKHN0cnVjdCB3ZnhfdmlmICp3dmlmLAotLSAKMi4z
NC4xCgo=
