Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 938AE48D3ED
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 09:56:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231250AbiAMIzn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 03:55:43 -0500
Received: from mail-co1nam11on2053.outbound.protection.outlook.com ([40.107.220.53]:51425
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230451AbiAMIzl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jan 2022 03:55:41 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VwUTJYmuXTv1rXCuBlLHOdw7Pnh3j7tlQ2b6j3XtSWilFvRWOK6lSczIi4nVco0lW84JxcOHW/iym0qCl5Fl1z6TS9G2APq24mWyip49E+4JbRKqAXPDWTD2PlFNLGUvKBOS7Y5jHGgIzP4BsOk4QbGN3RPz3ztKa/sr1CGD3QLoTWKxbRf93+sCHO/xWAo01QcDe4MUmobv49CE7EWsdnEhhOFfq4X7JXiaj1evWB4HYvc5p66jVkxYPYiXZmFi89NvDDYnV5jlKkD03hn4MRLTt3tWnu4wmq8utXkpmVNxC6VJCcCT10Gl77as0E5dxwxrMSaBAnU3IV3LWEtYzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eD1NMlmq7cmiMho79n84K3B5x4AIEUAhxEv4VKxZHcw=;
 b=PWzZpqTLEcXE4ksOMBdmIUIUbby7MxMh4r3YIC217GLjvBngiNFUBf6QFTya0SCD3VW/LVkoBh4jIa57OK9xY6QZBktoOq8RDQ3bUxooYGUYY8JhsaJKjg4Lqyo4RE5THH02CoTEC++xRLbGcf/TYN/iGGLQtGQ6QDfO9A94ILqWE+lzVYqB1nXuhU1uwJmUgIktOreX+iCNFCj/rbuRNoktz5n2fdH1dI9wFejnqFTKgZKFBSNYAQwCusQM3iKB7c3MWQpGoPQB9nbuVapfAvmjBiVYK3G8yJTn7fSwGGEWnprxAiLlQOj0KWEG6CAUPD3GwWjjjZEMq/P6R0xBFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eD1NMlmq7cmiMho79n84K3B5x4AIEUAhxEv4VKxZHcw=;
 b=DX6HVkCBupgrbuyqxvBixd7Sb2pWNC/DZP/NtgnJXAKJ91lIh2ukDgJ8sbo5q1a7OreTDj2yE4bLGFqF27kgRsEOOv9l8c0S5L8WB8aEjJNBe0AhAk/6ChY4iswO2Dv4z+Bes5g5mf2pWUN85tr+ZIr+AazU7OSb+bstB6OQFbk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=silabs.com;
Received: from PH0PR11MB5657.namprd11.prod.outlook.com (2603:10b6:510:ee::19)
 by BY5PR11MB4040.namprd11.prod.outlook.com (2603:10b6:a03:186::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.10; Thu, 13 Jan
 2022 08:55:40 +0000
Received: from PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::d031:da9e:71a:73e4]) by PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::d031:da9e:71a:73e4%5]) with mapi id 15.20.4888.011; Thu, 13 Jan 2022
 08:55:40 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 01/31] staging: wfx: fix Makefile and Kconfig licenses
Date:   Thu, 13 Jan 2022 09:54:54 +0100
Message-Id: <20220113085524.1110708-2-Jerome.Pouiller@silabs.com>
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
X-MS-Office365-Filtering-Correlation-Id: e2a64cab-a733-4e0f-54aa-08d9d6727956
X-MS-TrafficTypeDiagnostic: BY5PR11MB4040:EE_
X-Microsoft-Antispam-PRVS: <BY5PR11MB4040B7DE80852C0CD7EFF07393539@BY5PR11MB4040.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 25HmAFrCSo8UZU1QgK/5ErImf+e4JWNhCEFVgEYlMcoyksHwUksXxTq8wh6nCY4DHuDomGs7iqM3yPqvvksd7efg19j91zdLgztycBLQhV1ZQmFXSlxtmi6dOB9V9aZ1f7VPcdIjNvj0KH158z0ynxUHiuKp07cvygAjs/GrB93+RXzRwVw2dfVejvMKCgX6PqboUb53B6L+0EjZd5KbE43kYSuHsRGLnZcVLVc/92uBkKVD9RKrQ4Kq3BdMsV+No39OMwdbTmg2MuQZSrJ2gFR2K1x2lymwBNczzcVkF/vrGSg6BNTTNsZnUd4+TNG+bNjvd+Cxp9WBaB67B3h95zrSBkSFPZuDKZwjyxwBw1nk48Ibmm8OgQIybTJaGARsgTmVEMNOklCmloyJpHNsBXPR1kHr/t+3GXSuyq0b1PiwZ7fYRGbiS11bbi33A7bzAArGz1EDWpiwuA5QD8DQQMW0H8Dv9rZ8MIEhIQvCc3J58/kHTmQk9Ji075WFzACs8g2Se1CKneMHQwLuWr29YQwVbiZHxQrhnF/lGndhFOXNgmHehZTAszo+1/peH6WQdXAr9k3O3aeBunqWlmE3KhRezfj+mzn4oMnJCckAcsykpqu9ExWpUHFwBaD5c6z3kwCF6tkNE3CqrKEv7uhywQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6506007)(508600001)(186003)(38100700002)(4326008)(8936002)(6512007)(6666004)(66946007)(83380400001)(1076003)(2616005)(54906003)(86362001)(66556008)(2906002)(66476007)(316002)(52116002)(36756003)(5660300002)(66574015)(8676002)(6486002)(107886003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MDRVc0R4UUhJV1RNRG5ENTlxSXY0UldPeVNzelQxUVM4L2wwSTNTY2UwcG03?=
 =?utf-8?B?U1VLQ1c5WEJqVGZCZTBubzA1THN0VzArWlBnSUs5Y2dvVGoyTTk1YkZnSC9u?=
 =?utf-8?B?cHlCY1p1MkUvS1VDOFlSOEZnWVR4ZnBidE5uM1FYTExxdFE0bENIVm9SZkNx?=
 =?utf-8?B?b1g4N0ZEMHBZUHlybG5WaXZxSTBjTmlFRWxyR2NBVys4cUpabENhaVhuS1NF?=
 =?utf-8?B?c09ROE43alcwNHhSdXg0b3U1U1hKaEdRam1UL0daUlp0TndUQnMzTlNCU3dM?=
 =?utf-8?B?L3Q5eXB2bFNRVHRvUHg1eithNHM3NnM0Ui85ODVjZUMxVmE2QUFjaS9vcUk1?=
 =?utf-8?B?eGc2VDQvMHY1dW9tSHdRU012LytrMm5xWnRML3ZPZ1IvT0NxZ0krSXZDcVZO?=
 =?utf-8?B?Z0pzWEVwOVVpVTVGSi8rZ2RDR1VKOUFuN0xPSVdnZDloQ0N6QVhyaVNkbjVo?=
 =?utf-8?B?RTJOM2UxUi9mUjRnVFJ4d0RGOW5rZFNYSEtZOWNBRW1UWnk4Y2x4R2IrbE80?=
 =?utf-8?B?cjhJc3VBdDUxbW5lYm9TSU0vMUxUYXhJSUVjOTFJNnRyVFl4L3FwUG10dCsw?=
 =?utf-8?B?RVhrTW14WHlVcTRYR2hWNmhQOGRoM21YcjJhckorYUlLTzVMcFRHcE5BSjZJ?=
 =?utf-8?B?WGo5MHRQTVQ1WjFMMnVIdVVTczRPcGpQM3dWRXBHWGVsOWdFNUVva2NBRG5t?=
 =?utf-8?B?RGFDMHdMSXJ4OEZ6VjZSMUhGWDZUWHhwVVZGdjhLZFZjNlc0Tzcyc2JML0F0?=
 =?utf-8?B?NVorK1N0NkJDYTg4QXVGMmRlUjE1Vkk5eXNFWG1rcWN1Z3FBbnZrYlQ2TUxq?=
 =?utf-8?B?UmhHN3lPVkJOUFFlSVNXWkg2d1JrVkJ3NEZydHdVWUpJRitqa1pQSFVGNzBx?=
 =?utf-8?B?VE1PVVY1RjBpbWs5a21KU3dIdlFkL094djZCOGp6WEw1WnhmcU5HWlFzTjhX?=
 =?utf-8?B?MUVQdm5JTmt2MEUvVlI2eW40Nm96WmpaUVd6RFhSU2E2M2piaGRScE5Ud0No?=
 =?utf-8?B?dVNSNjFyRWI0L0F5VTZoWGtqSkowMUhPQVdxNVB3VHBYekg5TjZNTDJ0bDlW?=
 =?utf-8?B?MjlaSzZYMzlkRVVxMWkwT1RBWlRrOVJQWGtscTRwb0c0VGYrSTVBdWpyWmRz?=
 =?utf-8?B?TlZRQWRTcFZOV1AwR3lkOTlrOVB4emJVN2NkUlppcDJJdUFueXZJOXN1amQ2?=
 =?utf-8?B?b2ZYTzlva29zKzhMellTeldqNm1IRGhXU1hldmVRdStwRXdJdUxEYjZjUFNm?=
 =?utf-8?B?NmtQK3JCcnJ3SUVxVkFvNklJdkVnN08rYVNhNlJOSzVnTU5uL3RndVNNRjFp?=
 =?utf-8?B?MXJ0Y2Y1S0pjY2pWWFE4ZGNtWWdnQXc1STViRDdKMVdTZ2RsbncvN0x5T1Fw?=
 =?utf-8?B?ZTFha3ZVQWJ3SzFnZWJqZFZEVUNEeDFDYk9GcE13NmpZNVBkd3F5OVdCSEhh?=
 =?utf-8?B?QUF5eUh6azNwelFZc2RpaUw2U1ZTRlBoMHVEOEsvdXdYTkRUWjNPclBUU2ZZ?=
 =?utf-8?B?d0pGWEljUTd3YjkyUjdWQmlZZWZaVWgzMWx4UXU5ek9JVmp6T1paRVVPV0FC?=
 =?utf-8?B?MTQrUmdsM1lOMUU0SXR5dWtRZmdKcGN2d3ZPb2NRNGh2TXFjMTNRaTYxcjFP?=
 =?utf-8?B?MGU5cmF2Z1JUNnljY3dSbVZ4M1R3a0pOWVJ1aUUvR0syRkNFYzlBQzMxbGVo?=
 =?utf-8?B?SFczSXZ0b3hnZTN5cmgwQ0Fqd1BhY0ZKcjRkUlN1d001emNXYk1udTFLUmYv?=
 =?utf-8?B?c2ZjNGZHOTROWkNOaGFIRVN0dUdMS0FYZms1Nnh5ZGo2QTJjbEcwTFBmcFY4?=
 =?utf-8?B?U0M2SFFJcFJEcmdTR0ZPOVlPQTdMRFBPQ25mb2ZHakkwQ3lua0p6Q0k2SWZv?=
 =?utf-8?B?NzR6SDlBNGZvN0RmdDI4cHBYNENGVFZ1dElZZ3R6RWx4T0E4aCtnWHhtaEFU?=
 =?utf-8?B?S3pjNTNIQnRhdUQzbVVwcDZRSS9SKzlnSFZXT2lwYUFkQjhnYjFkRmpGSEta?=
 =?utf-8?B?SHBPRnNhdTV5TGEyTFlFWGQ4VGNNallUOFdZajZoRTFmRGlQb1F0aWxaUmJJ?=
 =?utf-8?B?ajV1TVhNRjA4V3h4NTZQSWZPb0Q4d2lUUC9EaVVjT1daL3hXYzBWM2g5cUVK?=
 =?utf-8?B?YU5RdnBlQnNvL2FUOFJCZkppcDhaR25vbm9kUFQ0MmU0ZjhvN0tFUm1BNUFa?=
 =?utf-8?B?amdRV0E2ZVpwc2RrdlhYcHVJeHh2bWQ5OWlwUFhlSENNbEVDSHBRWTZhUGxV?=
 =?utf-8?Q?Hq+FgjH+JDojhdq0a+xauy5k3ZvRmqT3cR4vC4/jEs=3D?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e2a64cab-a733-4e0f-54aa-08d9d6727956
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2022 08:55:40.2139
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OqtYSFXlhuUTqCM9XSuLaMxYP7vghthF5sXlQvM/WgOIWgieya92vmYuy4CNEdFikC5XMki8Mh5Y3HEQfHMeGg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR11MB4040
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKTGlj
ZW5zZSB3YXMgbWlzc2luZyBpbiBLY29uZmlnLgoKTWFrZWZpbGUgbGljZW5zZSB3YXMgR1BMLTIu
MCB3aGlsZSByZXN0IG9mIHRoZSBkcml2ZXIgdXNlIEdQTC0yLjAtb25seS4KClNpZ25lZC1vZmYt
Ynk6IErDqXLDtG1lIFBvdWlsbGVyIDxqZXJvbWUucG91aWxsZXJAc2lsYWJzLmNvbT4KLS0tCiBk
cml2ZXJzL3N0YWdpbmcvd2Z4L0tjb25maWcgIHwgMSArCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L01h
a2VmaWxlIHwgMiArLQogMiBmaWxlcyBjaGFuZ2VkLCAyIGluc2VydGlvbnMoKyksIDEgZGVsZXRp
b24oLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L0tjb25maWcgYi9kcml2ZXJz
L3N0YWdpbmcvd2Z4L0tjb25maWcKaW5kZXggODNlZTRkMGNhOGM2Li4wMWVhMDljYjk2OTcgMTAw
NjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93ZngvS2NvbmZpZworKysgYi9kcml2ZXJzL3N0YWdp
bmcvd2Z4L0tjb25maWcKQEAgLTEsMyArMSw0IEBACisjIFNQRFgtTGljZW5zZS1JZGVudGlmaWVy
OiBHUEwtMi4wLW9ubHkKIGNvbmZpZyBXRlgKIAl0cmlzdGF0ZSAiU2lsaWNvbiBMYWJzIHdpcmVs
ZXNzIGNoaXBzIFdGMjAwIGFuZCBmdXJ0aGVyIgogCWRlcGVuZHMgb24gTUFDODAyMTEKZGlmZiAt
LWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93ZngvTWFrZWZpbGUgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4
L01ha2VmaWxlCmluZGV4IDBlMGNjOTgyY2VhYi4uMWU5OWU2ZmZlMDQ0IDEwMDY0NAotLS0gYS9k
cml2ZXJzL3N0YWdpbmcvd2Z4L01ha2VmaWxlCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvTWFr
ZWZpbGUKQEAgLTEsNCArMSw0IEBACi0jIFNQRFgtTGljZW5zZS1JZGVudGlmaWVyOiBHUEwtMi4w
CisjIFNQRFgtTGljZW5zZS1JZGVudGlmaWVyOiBHUEwtMi4wLW9ubHkKIAogIyBOZWNlc3Nhcnkg
Zm9yIENSRUFURV9UUkFDRV9QT0lOVFMKIENGTEFHU19kZWJ1Zy5vID0gLUkkKHNyYykKLS0gCjIu
MzQuMQoK
