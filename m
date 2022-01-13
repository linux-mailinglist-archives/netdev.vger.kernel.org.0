Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB97E48D482
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 10:49:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233433AbiAMI6R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 03:58:17 -0500
Received: from mail-dm6nam11on2073.outbound.protection.outlook.com ([40.107.223.73]:16221
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232463AbiAMI5e (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jan 2022 03:57:34 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gGZw1gsa+ckb6Iogp0J1MLALm5LbBLWT7FFiDGUkFTp529u7JgSr/9AJq8Kjyiwn84itvyIEJ2ff1Mo4ciGJ8pEPJIZGbZh3sxacQrL2UARkR6RMJkIMKgzwHIh7EtXIgaELdpe2YWQ415aIquZJHCdE+Uli39bMB7Qr6oDBCxx0Ktmyet1oOfG6EhlRzykwaUtwlkV4bt9BKEA6F82QD3rU+XOdrRxTV9eMFHhx6xHcZVPeW0jdgCRzFiXcxmiZmXvHviiR7JPl1MeFjWu5vkB25eNpanM0VXj392QmaqGfLY9pZDDCgYGJUSOPSw61oqmo+9g5WCOCXQV55cksww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qIcn4Cf4/8ZtWki0hhroUT1yK9q1a3c0Ptu+hemQpCE=;
 b=TKXaqnOEc4/NuthzbmvoBet5q24N8GinVi4QLZc68ff0R5fqazxgUZn3V1kPBpJG3duRMXT7qFtaJqNRXP72lq3jmVa1xlDdxECjHkOaCZEmZ5W0JbKBRrYgymJ2G33F92/7/RQO8bwY/vZILtZKkQkjvh0KeGxhuQ4I5CKdvUKer+uE76mGOK5xsxjRMR2eNUaDC9vFsK3VxCDICO5JSx8xOOQthfiWh62CT3TMlnXxuUAQVaZN7B0Ga5ycCVqAhO5rmC2NY/J9/Inj6LD7qGcOR31GpY+96T/zjShwj06m9ZfsLt+Kc2v4sCOecrbeVsGXZUxGwTIuH+QuUU17aw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qIcn4Cf4/8ZtWki0hhroUT1yK9q1a3c0Ptu+hemQpCE=;
 b=P72QgOd3Hbn56/PQPXoXBlvyiEKM4gy0Uj/X1reUpWAzTYQDV6qH4WyKKJUAXDzkrv9EuoGD+YzX9zbu5zwMTdu3rKYRZLrXpN+vk/BBjpPXcsOMTmejFB/CrnGwm5hbHs/p8cbz6N9SXbK4wNu4SoD+CD3i/1VPxMhlSmifT1I=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=silabs.com;
Received: from PH0PR11MB5657.namprd11.prod.outlook.com (2603:10b6:510:ee::19)
 by CY4PR1101MB2071.namprd11.prod.outlook.com (2603:10b6:910:1a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.9; Thu, 13 Jan
 2022 08:56:28 +0000
Received: from PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::d031:da9e:71a:73e4]) by PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::d031:da9e:71a:73e4%5]) with mapi id 15.20.4888.011; Thu, 13 Jan 2022
 08:56:28 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 25/31] staging: wfx: do not display functions names in logs
Date:   Thu, 13 Jan 2022 09:55:18 +0100
Message-Id: <20220113085524.1110708-26-Jerome.Pouiller@silabs.com>
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
X-MS-Office365-Filtering-Correlation-Id: e941f6d5-75b1-4660-db02-08d9d6729638
X-MS-TrafficTypeDiagnostic: CY4PR1101MB2071:EE_
X-Microsoft-Antispam-PRVS: <CY4PR1101MB207129F6AF024F05BBA2671593539@CY4PR1101MB2071.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NMq1SZxEvAAXJpatY9K9Yhb+jNbx+o6W+ACpgeO6whZUSXuNKClTRY6Llr5AHLV60q3UVnzrkhC9NlscwEykfPtHJTYjN7qDV4L2dF21wYZbTgLZNbpBI2CHiLiBq+ZQ6zDBkzTXoF7wfZOVTk3E9PZ1oBMgSAKu06MNKHvSTNrbfjxi0CNX4UOiABj5EQbchn9axJS/7MIlmZz7X9lnrAOHoE4qL9lLkGGcwdpSp+pNYCLlf//WB1PHLzUckVN3w4nnoYJPYCKuZjYjnRz+1NgFL1AkOX5gvm2Q7k7tBppJvUXIZO8J4TuzyYAdPdsjPajop2Ar4jwAUC4FgeqNnygbsXOHl7TW1RsRZZElAgkIlWV7gOiF7ELA9DLfbZvtwNA03uLKLruzIAp5jJ2RhR0KSKArJIM0ainhSxWp0PIzjdHhX2vI/9Z6h3SyAlF/CyWY/a/HH7poTTrtcu6emoCi6ciWRIscrCEMnb9ivUaifjAy4N/TveEk1361RP2ZNskweIqf73UbpR/iff7sBaCg66VpVEMBx6Jdg+Dd9g3ICtXh7Jg18s2PCO8kVt4sGa2KpFrFB6DpIRM7A7zq8Kl6NYvUdJHYP0RpQpMHJZOjAPBDHBV2FlCJhYg0cgdMiy1sUWcH0QN0kMLrRAP9Jw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(2616005)(66476007)(52116002)(8676002)(6486002)(4326008)(66574015)(38100700002)(8936002)(83380400001)(6506007)(107886003)(66556008)(6666004)(36756003)(508600001)(2906002)(5660300002)(6512007)(1076003)(86362001)(186003)(316002)(66946007)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TUpWQjRid3VHaWhZOUQ1U1FPcStNc0Jhcm1CNGVUaXo2VlFTc3poSmo5MlUv?=
 =?utf-8?B?UDh1anJEbURCbDd5aFM5dysvMFFkZGdjaFR1OHpneTZ6bVVHVklVanVYR2Jq?=
 =?utf-8?B?cFUxdGZXOHhyNVRCcVE5WXRrd081UWlqd2FiVEp2T2VKN1F4enJ2dkJuWUJX?=
 =?utf-8?B?UzRmR2EyWGpPbWZTSEVxcm1CWHd4cllVZHJGK0I0UTlwNE0wU29YVWVTaGlL?=
 =?utf-8?B?TjJFd3RuYzBjaWFINEsyM0V6OWRJNC8vRG55TWprdFNodGQ0a0xUUEN2MlhD?=
 =?utf-8?B?NURBV3orUzFnV01sNEVkTFFzSXJvcmpmcUtiVWM2c3Rxek5qOHEvKzNlM2xJ?=
 =?utf-8?B?aTJwdEhUNjVkbWVBOHVqMkpWWWVvaTFldGV1R3NWRWpINTdIUGI1dzl1VjR0?=
 =?utf-8?B?a3hUcUg3dlhFSU1zS2JZcEVMN09jWkM3WFdpaFhRaDdqOFIvQnJzeVdPbzNs?=
 =?utf-8?B?YTBHb0czV1oyL3gyWVFLS09iajBRYkxFZWpjMjhWOTdsbGRoTkNQT1BMa3dG?=
 =?utf-8?B?R2dWcStPRVVBL20zQnpzOW9vRlA2d2pJQVEweXVVZlN5d0daSUpidVBnWGVi?=
 =?utf-8?B?MDFmb3NmWSsrZ2VmLzFCKy9RdDZQVkdlNUJrNyt2WGYyTVVMcGZReVVmUGcr?=
 =?utf-8?B?MDNmZWlTZ1ljanpFbnNtdXprdUtpVWhGdnd3SWhkLzNpYXI0Vy9BT0JodHdN?=
 =?utf-8?B?ZTVZeXlXbHFHQWt0bFVCNWU4bnNCRUp5dkFpWjZNMnh0VWNpeUk1UU5iQXZa?=
 =?utf-8?B?RjV1OXFsdFpyS21TQTg1WW1NellOOHdoVGtvcnJuNy9DOVM5L0xnZHcrODFi?=
 =?utf-8?B?bHRqQzRuWmlLTElSWVRhNE1sbFpKN0JnRk42ZDltQ2Zrdi9SWG5HMmlCajZD?=
 =?utf-8?B?ZVMwamlLc1hqVEFsaHpmZFJpVEdEZHVwV2s1N3pMcVdoSGg4b00rWDdlSE5p?=
 =?utf-8?B?NkRYQzROd2lrUEk3OGM3TDlMNDh6b1d6UFhmM3o5Y2tad29oRVdTSW4zOHU5?=
 =?utf-8?B?aC9QdGh0K2h4cWFlWWRSUEFuTXF5THkvTnpHTFV0Q1hCRGxmS1Y1SWc1clpZ?=
 =?utf-8?B?VEc4Sk5XaGtEK1NhZHNWRHBRZ0pTbzF2WUJBcCtFWXBvMU5PaWgzUjExbkFG?=
 =?utf-8?B?ejIyZkxQcDZ6U3FNNEw5Q1VWMFRkR21MSjlab2RoV3lraWlXNDQyVXFZb3NE?=
 =?utf-8?B?aWRyc0xYMzZpTzdiSmVQMCtIYlNwRXhseFZZOWVoTkZhd29ucXpWd2Vva2NY?=
 =?utf-8?B?bldSc0xzZGdmU2dlaUd2Nlc3ZVR6YVV4Z3BXU1dyL2hWUEd0dkp3Zkl6K0N2?=
 =?utf-8?B?WEdaQWlvekV5WEVLNk9uNWJrdWtpb3l4VDlRajhjSExVN296ZnFOb3VscnFq?=
 =?utf-8?B?YjdwUFFkc1doRDZ6OGp1RnhrcFFvKzZVZkdLYW9kZG1nU0kzMSt1K1VkRGtk?=
 =?utf-8?B?YUhtelloVHByZWF6NWhRdEkyTUwxTTh4NllqVmRMdDR4YlVXNmxOOVByRlNm?=
 =?utf-8?B?cWE3czBPNjhpa2tMU0g5ZTNjM1lQSWh2TGc1YXR2SXkrR2N1ZDJNRXZJd05F?=
 =?utf-8?B?akQvRTk1MzVsTmtseUl5WU9peVdBTTlIRkFPRUsxc3lzS2FKSWRsalpicHlP?=
 =?utf-8?B?aHArNjVnajdINXlheVZFU2hjcm5sU3o2aUZNT3JDZDlDL21Yd0dVaUpNNHZZ?=
 =?utf-8?B?bWRVQ2NZTmhOdW4wNjB2MFk4MU91STZNekozTEZMWW1JZ0RpWjVCRVNucGhU?=
 =?utf-8?B?OW1GNnRRSHFma3hwNU1PaFdRZE52T3JNSGhjSzBIOThLbWN4Tm84d0FVdmpv?=
 =?utf-8?B?RXlLMGE3RUtvUHl2QWRjcGwrSHk4cm9GR2p4emZkSkdzb3FxdzNLbXRvTG1V?=
 =?utf-8?B?WERWcTFmY21YRzZ3N0E4WEhkUXJ2VEFGTXlPQUFQeGNkZ3U2VE1icUpHdXM0?=
 =?utf-8?B?cndyU0dXY2NNWnQyVW5KTkFNVkFLTDkxL2NKV08wcUM4dWhkbFR1aGV5cThQ?=
 =?utf-8?B?TGREMzNVVkNQK1Q5L2tpQzRFVWZkR0hZVjRwM3h4bHRSSmR1SDBGdDA4bTJt?=
 =?utf-8?B?WGVBM3ova0pHc0NVTUZYMzVZV3ZJRWFRRDhXMTYyMGdRZk9UTHh0WTRERURG?=
 =?utf-8?B?ckxOU21NQmh2Rmw3dkwxaUFlQWNOU1Y3aEdxWXE0Wlg4am9nS1B3d01rb1BJ?=
 =?utf-8?B?cHNhRXdtNFF3NWNXSkhtUWZFZEtLQjBGWGg2QkFXVG1nK2lWMWt6NTF4Z01r?=
 =?utf-8?Q?v1y5jmhyCTbbkvkchubkBjbSSG1SZMccuHkJQIATlU=3D?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e941f6d5-75b1-4660-db02-08d9d6729638
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2022 08:56:28.6590
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MDKfUVBw11HY/IjV0BahVqHB2gBD9iyeRzrJt5oYx5RZqBHyKtAD6863B3/tN2sP27Laf3AGRjifcljuYhLXHg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1101MB2071
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKSXQg
aXMgbm90IG5lY2Vzc2FyeSB0byBwcmVmaXggZXJyb3IgbG9ncyB3aXRoIHRoZSBmdW5jdGlvbiBu
YW1lIHdoZW4gYW4KZXJyb3IgbWVzc2FnZSBpcyB1bmlxdWUgaW4gdGhlIGNvZGUuCgpOb3RlIHRo
aXMgcGF0Y2ggc3RpbGwgcHJlZml4ZXMgdGhlIG1lc3NhZ2UgJ3JlY2VpdmVkIGV2ZW50IGZvcgpu
b24tZXhpc3RlbnQgdmlmJyB3aXRoIHRoZSBmdW5jdGlvbiBuYW1lIHNpbmNlIGl0IGlzIHVzZWQg
c2V2ZXJhbAp0aW1lcy4KClNpZ25lZC1vZmYtYnk6IErDqXLDtG1lIFBvdWlsbGVyIDxqZXJvbWUu
cG91aWxsZXJAc2lsYWJzLmNvbT4KLS0tCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L2JoLmMgICAgICB8
IDMgKy0tCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L2RhdGFfdHguYyB8IDIgKy0KIGRyaXZlcnMvc3Rh
Z2luZy93ZngvaGlmX3J4LmMgIHwgMyArLS0KIGRyaXZlcnMvc3RhZ2luZy93Zngvc2Nhbi5jICAg
IHwgMyArLS0KIGRyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMgICAgIHwgNSArKy0tLQogNSBmaWxl
cyBjaGFuZ2VkLCA2IGluc2VydGlvbnMoKyksIDEwIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBh
L2RyaXZlcnMvc3RhZ2luZy93ZngvYmguYyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvYmguYwppbmRl
eCAxZWM0YTQ5NTFkOTkuLjRjNmJhOWMzNDJhNiAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5n
L3dmeC9iaC5jCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvYmguYwpAQCAtNjksOCArNjksNyBA
QCBzdGF0aWMgaW50IHJ4X2hlbHBlcihzdHJ1Y3Qgd2Z4X2RldiAqd2Rldiwgc2l6ZV90IHJlYWRf
bGVuLCBpbnQgKmlzX2NuZikKIAlpbnQgcmVsZWFzZV9jb3VudDsKIAlpbnQgcGlnZ3liYWNrID0g
MDsKIAotCVdBUk4ocmVhZF9sZW4gPiByb3VuZF9kb3duKDB4RkZGLCAyKSAqIHNpemVvZih1MTYp
LAotCSAgICAgIiVzOiByZXF1ZXN0IGV4Y2VlZCB0aGUgY2hpcCBjYXBhYmlsaXR5IiwgX19mdW5j
X18pOworCVdBUk4ocmVhZF9sZW4gPiByb3VuZF9kb3duKDB4RkZGLCAyKSAqIHNpemVvZih1MTYp
LCAicmVxdWVzdCBleGNlZWQgdGhlIGNoaXAgY2FwYWJpbGl0eSIpOwogCiAJLyogQWRkIDIgdG8g
dGFrZSBpbnRvIGFjY291bnQgcGlnZ3liYWNrIHNpemUgKi8KIAlhbGxvY19sZW4gPSB3ZGV2LT5o
d2J1c19vcHMtPmFsaWduX3NpemUod2Rldi0+aHdidXNfcHJpdiwgcmVhZF9sZW4gKyAyKTsKZGlm
ZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93ZngvZGF0YV90eC5jIGIvZHJpdmVycy9zdGFnaW5n
L3dmeC9kYXRhX3R4LmMKaW5kZXggYmZjM2Q0NDEyYWM2Li5kN2JjZjNiYWUwOGEgMTAwNjQ0Ci0t
LSBhL2RyaXZlcnMvc3RhZ2luZy93ZngvZGF0YV90eC5jCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93
ZngvZGF0YV90eC5jCkBAIC00MjUsNyArNDI1LDcgQEAgc3RhdGljIHZvaWQgd2Z4X3NrYl9kdG9y
KHN0cnVjdCB3ZnhfdmlmICp3dmlmLCBzdHJ1Y3Qgc2tfYnVmZiAqc2tiKQogCQkJICAgICAgcmVx
LT5mY19vZmZzZXQ7CiAKIAlpZiAoIXd2aWYpIHsKLQkJcHJfd2FybigiJXM6IHZpZiBhc3NvY2lh
dGVkIHdpdGggdGhlIHNrYiBkb2VzIG5vdCBleGlzdCBhbnltb3JlXG4iLCBfX2Z1bmNfXyk7CisJ
CXByX3dhcm4oInZpZiBhc3NvY2lhdGVkIHdpdGggdGhlIHNrYiBkb2VzIG5vdCBleGlzdCBhbnlt
b3JlXG4iKTsKIAkJcmV0dXJuOwogCX0KIAl3ZnhfdHhfcG9saWN5X3B1dCh3dmlmLCByZXEtPnJl
dHJ5X3BvbGljeV9pbmRleCk7CmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl9y
eC5jIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfcnguYwppbmRleCA1MzAwZWY1NzQxM2YuLjMw
MmJkYjJiZjAzNiAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfcnguYworKysg
Yi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl9yeC5jCkBAIC0xMDEsOCArMTAxLDcgQEAgc3RhdGlj
IGludCB3ZnhfaGlmX3JlY2VpdmVfaW5kaWNhdGlvbihzdHJ1Y3Qgd2Z4X2RldiAqd2RldiwgY29u
c3Qgc3RydWN0IHdmeF9oaWYKIAljb25zdCBzdHJ1Y3Qgd2Z4X2hpZl9pbmRfcnggKmJvZHkgPSBi
dWY7CiAKIAlpZiAoIXd2aWYpIHsKLQkJZGV2X3dhcm4od2Rldi0+ZGV2LCAiJXM6IGlnbm9yZSBy
eCBkYXRhIGZvciBub24tZXhpc3RlbnQgdmlmICVkXG4iLAotCQkJIF9fZnVuY19fLCBoaWYtPmlu
dGVyZmFjZSk7CisJCWRldl93YXJuKHdkZXYtPmRldiwgIiVzOiByZWNlaXZlZCBldmVudCBmb3Ig
bm9uLWV4aXN0ZW50IHZpZlxuIiwgX19mdW5jX18pOwogCQlyZXR1cm4gLUVJTzsKIAl9CiAJc2ti
X3B1bGwoc2tiLCBzaXplb2Yoc3RydWN0IHdmeF9oaWZfbXNnKSArIHNpemVvZihzdHJ1Y3Qgd2Z4
X2hpZl9pbmRfcngpKTsKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93Zngvc2Nhbi5jIGIv
ZHJpdmVycy9zdGFnaW5nL3dmeC9zY2FuLmMKaW5kZXggY2UwYWU0YzkxMTkwLi43ZjM0ZjBkMzIy
ZjkgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93Zngvc2Nhbi5jCisrKyBiL2RyaXZlcnMv
c3RhZ2luZy93Zngvc2Nhbi5jCkBAIC05NCw4ICs5NCw3IEBAIHZvaWQgd2Z4X2h3X3NjYW5fd29y
ayhzdHJ1Y3Qgd29ya19zdHJ1Y3QgKndvcmspCiAJbXV0ZXhfbG9jaygmd3ZpZi0+d2Rldi0+Y29u
Zl9tdXRleCk7CiAJbXV0ZXhfbG9jaygmd3ZpZi0+c2Nhbl9sb2NrKTsKIAlpZiAod3ZpZi0+am9p
bl9pbl9wcm9ncmVzcykgewotCQlkZXZfaW5mbyh3dmlmLT53ZGV2LT5kZXYsICIlczogYWJvcnQg
aW4tcHJvZ3Jlc3MgUkVRX0pPSU4iLAotCQkJIF9fZnVuY19fKTsKKwkJZGV2X2luZm8od3ZpZi0+
d2Rldi0+ZGV2LCAiYWJvcnQgaW4tcHJvZ3Jlc3MgUkVRX0pPSU4iKTsKIAkJd2Z4X3Jlc2V0KHd2
aWYpOwogCX0KIAl1cGRhdGVfcHJvYmVfdG1wbCh3dmlmLCAmaHdfcmVxLT5yZXEpOwpkaWZmIC0t
Z2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYyBiL2RyaXZlcnMvc3RhZ2luZy93Zngvc3Rh
LmMKaW5kZXggZjY0YWRiYTM1MGViLi44M2YxYWM4N2UwZjIgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMv
c3RhZ2luZy93Zngvc3RhLmMKKysrIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYwpAQCAtNTEz
LDEzICs1MTMsMTIgQEAgdm9pZCB3ZnhfYnNzX2luZm9fY2hhbmdlZChzdHJ1Y3QgaWVlZTgwMjEx
X2h3ICpodywgc3RydWN0IGllZWU4MDIxMV92aWYgKnZpZiwKIAkJZWxzZSBpZiAoIWluZm8tPmFz
c29jICYmIHZpZi0+dHlwZSA9PSBOTDgwMjExX0lGVFlQRV9TVEFUSU9OKQogCQkJd2Z4X3Jlc2V0
KHd2aWYpOwogCQllbHNlCi0JCQlkZXZfd2Fybih3ZGV2LT5kZXYsICIlczogbWlzdW5kZXJzdG9v
ZCBjaGFuZ2U6IEFTU09DXG4iLAotCQkJCSBfX2Z1bmNfXyk7CisJCQlkZXZfd2Fybih3ZGV2LT5k
ZXYsICJtaXN1bmRlcnN0b29kIGNoYW5nZTogQVNTT0NcbiIpOwogCX0KIAogCWlmIChjaGFuZ2Vk
ICYgQlNTX0NIQU5HRURfQkVBQ09OX0lORk8pIHsKIAkJaWYgKHZpZi0+dHlwZSAhPSBOTDgwMjEx
X0lGVFlQRV9TVEFUSU9OKQotCQkJZGV2X3dhcm4od2Rldi0+ZGV2LCAiJXM6IG1pc3VuZGVyc3Rv
b2QgY2hhbmdlOiBCRUFDT05fSU5GT1xuIiwgX19mdW5jX18pOworCQkJZGV2X3dhcm4od2Rldi0+
ZGV2LCAibWlzdW5kZXJzdG9vZCBjaGFuZ2U6IEJFQUNPTl9JTkZPXG4iKTsKIAkJd2Z4X2hpZl9z
ZXRfYmVhY29uX3dha2V1cF9wZXJpb2Qod3ZpZiwgaW5mby0+ZHRpbV9wZXJpb2QsIGluZm8tPmR0
aW1fcGVyaW9kKTsKIAkJLyogV2UgdGVtcG9yYXJ5IGZvcndhcmRlZCBiZWFjb24gZm9yIGpvaW4g
cHJvY2Vzcy4gSXQgaXMgbm93IG5vIG1vcmUgbmVjZXNzYXJ5LiAqLwogCQl3ZnhfZmlsdGVyX2Jl
YWNvbih3dmlmLCB0cnVlKTsKLS0gCjIuMzQuMQoK
