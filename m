Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C0A048D47D
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 10:49:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233278AbiAMI5s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 03:57:48 -0500
Received: from mail-dm6nam11on2047.outbound.protection.outlook.com ([40.107.223.47]:10080
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232209AbiAMI45 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jan 2022 03:56:57 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D/ltJFlSR8DD2TexN/YYefeS1j3PCs/qa+/yxcQuPwvKzxnRHj3L1EWWgT+gRvmxQ1lykRWp4IYt5zugv/cEQAtJpTy4S6g06adpGA7EYhF4nTHqs55JkZT5B7l0eCzTmj+2IfKRPGqwd30d5HKgDYLCoZmU4INysWEB7QUDZXnUighldl/BbIA6fjrd4lcRF4Ks1k1YIdGBHwB3DC9/FSmHzLFLxovyai9CpsYzdDiRQ2FRZFBOOkFPcRsQJmxITcaWfSkU9eCKg7iOim8ufc5mWhBxC6zbkkZsrG7uMU0S2sS3YK9FUsLRRbcU1x1mP29xvJFOghBzXbM938Murg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XiIr7gy9KeHlgbSlVN/Qd+VHZJQtENGovsSdj9Qff/I=;
 b=TX9cg82U97/SVCgSMTi73tZVVVQDenmVlzyRjkOiTD3Wh9Nv8DW2euZ2cJoScUTa6vHkA0f2u3vyFTgcjnYybpR9wH1LXA4lHIvqHtWQWOUBtaOomedMuVZMF+EelgehL98iPZAkhhP2w391sMBquAUpBEpC8OhACrG20zAYIvA7M88FR7l6vR6cKP3Y7kF+yxGSAGmMg3RKezk8x7lNWhJ7PwOJBXnbhCBJ0/wgm2you+n9TK1SRdpTUwkk2esBqfDtXCA8dl7h3nP0bzllEe1+MZVDJasyiXAGnfNx7I95HYnhmxAtnwIsYBrUE4p1zNxMPp9tEAwaoBDZ+GGPNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XiIr7gy9KeHlgbSlVN/Qd+VHZJQtENGovsSdj9Qff/I=;
 b=GBjx2fbp+ssyLEnszIHBvr5EnlNaGO8eRSU8XumzismdSeLCrcspUvKcZVBseMspbqgywl1izMHztkQmorlts0shLrqOncY1L+WaPKvdoURbAnVeSl7qgbcN0SFA8YMWv0d03VnN/OY8fiV2wYB3gACFh6qDSOnIs+Rc/azJckc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=silabs.com;
Received: from PH0PR11MB5657.namprd11.prod.outlook.com (2603:10b6:510:ee::19)
 by CY4PR1101MB2071.namprd11.prod.outlook.com (2603:10b6:910:1a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.9; Thu, 13 Jan
 2022 08:56:24 +0000
Received: from PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::d031:da9e:71a:73e4]) by PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::d031:da9e:71a:73e4%5]) with mapi id 15.20.4888.011; Thu, 13 Jan 2022
 08:56:24 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 23/31] staging: wfx: use explicit labels for errors
Date:   Thu, 13 Jan 2022 09:55:16 +0100
Message-Id: <20220113085524.1110708-24-Jerome.Pouiller@silabs.com>
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
X-MS-Office365-Filtering-Correlation-Id: 0d453a22-20c9-4dcf-064f-08d9d6729396
X-MS-TrafficTypeDiagnostic: CY4PR1101MB2071:EE_
X-Microsoft-Antispam-PRVS: <CY4PR1101MB2071C2162FC4B63942DE737093539@CY4PR1101MB2071.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:398;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WzyNLJ2KCDECLpuxXXPjTkSNDmmz2dEY7thSrB+vbgLbd8bdfVW96Cs1V6ZM2JJq2PVhmjT7jLlI7/VMrjKAWA+EMmToviG1gB+fji01n77yQqwIkc+RlBTHTCE4nwyAJQAVWvfDYpcay5ytZ99RIblsx13JPIbTq0DOQsYO6zL3/FiA61E5XOEfcCBOd92HNMILAH98Q1daarIS+xBeawyB1COhvdsrKO7YlWfUvp/U+XyWEGljgwnG8Xb/ExvMNnXfqjU7Zdb2x6ShaX1/BCgB1BzDOX49mOZVe35iCuTBzpcB5fD6v3RlR+dzpBLrUoaQFxX0N+uNxIycyvYoa0zf7BrcaN5Mc8ZfIFixba3lMJ2OxBOM1caSFnBJKhrY6rwHnIBuCKo6pBMHOjxZ7BxFvohMCF6I1x9VOJXLPXoFZZa2QhlpTWBElV6TEjwSDKDO24idj0u0Ejaqkgrj/DOgfMDjD1x9zI878EedHIy0S5t7tLnVvPw8pBq/W6SuGVBP/vDGr9VvFO8u8eZVp5c4zMz6A5uhRxBVNp82pB5wMzn26e2YbS1uTeeZgfJ9dSUVvl6u2fZggCFNXZnKs3Q0P5lDVOfqEUbvi5fbcLUCbsISdl1bCk65GrN+AWnRzOrGAzoXoKlST+X5R9rTzw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(2616005)(66476007)(52116002)(8676002)(6486002)(4326008)(38100700002)(8936002)(83380400001)(6506007)(107886003)(66556008)(6666004)(36756003)(508600001)(2906002)(5660300002)(6512007)(1076003)(86362001)(186003)(316002)(66946007)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?d1dXSlJqVHlWVFNvQVRWWHZZYVdHS1FRU01Za3hGTmRsbEVnamZLNVB4djBn?=
 =?utf-8?B?MHhpNTFPRnA3bVM2R3M3K0I1OXBxVFJCK2JZa1p5bGs4QUc3alZGRE9BeTJH?=
 =?utf-8?B?TWEwTFVzOUJ0N3U2VlFLMUU5blViMjlOUGJOTGR6WlNGMnlmTnVIVnlrY1VB?=
 =?utf-8?B?WTVJVVZxMGtIMTBUTFlGeTh6ekVIcmxwNFEzRjVEUXZqZmxnUmk2UVVkVENH?=
 =?utf-8?B?OVljeDlzNDBDbWdnMXVXNVVXTlFyamMrVlZ2bGRZdk1JSlBScWdBcW1sT0RK?=
 =?utf-8?B?bjV6VVB2R21JWnoyV2pXVWhDdUlOcUtmRXRNQWpRSnRqK0pBWlVhUWhmMUdN?=
 =?utf-8?B?UURycWhzK2dOQ1lKNHl6RkMrWGRoWHdVa0V6OS9FaytncitFWmpCUFdBeEtW?=
 =?utf-8?B?LzdNS1VodkZmZVJDZXk4L3NpQ2VHTStTMmR4YklSM0dIcGM3MGNVelBTamo3?=
 =?utf-8?B?alpRVCtWamhoblFBejBMcUl5WFZXZHA5ODB5UW1VTHR4N2pUL0RpeXdDVDBF?=
 =?utf-8?B?cWRTSlBqUmhrK3Vqek8vODVNRW9neXBEbDFRR0VGNjc2R2tTbXlZNWc0SFpZ?=
 =?utf-8?B?VjZkeDIrdmlwUGQ5cDJVRVUrb2NiNFYzbmJIS0xHTmtRTzNmclFHZllTMy80?=
 =?utf-8?B?M1VOVVVOQmpjSnZPTDBwM2xEbHNIKzhsNTh1Rms5dGQ2SDROa3FpeWxlbUNG?=
 =?utf-8?B?ZkxIQ3FJVWkrTzBrNlJ0NUFJRmFMUjI1U0YrNGpybFZPVkl4WGZ2L2wwb25z?=
 =?utf-8?B?eXF1WHdaY3ZmQ0tsS3p0d3AyK0pRU0d4THJ0R2JoVVBGUi9RajNJTTVwRWVr?=
 =?utf-8?B?QVo5c3FoZWMrOWlSTk1CTVdLQ3g5dWY3QktUZjk1YytzQmJLdWs4SVIweXZr?=
 =?utf-8?B?ZDhWOTR6NlVXeTNYVzNrNndrKzRNMnBlS3VLOUMwa05kUjdRUjFSaGVuNHJL?=
 =?utf-8?B?WDRsNXd2QXpZTXFxalIwVnNGd3Y3aUMzQ2luNnBQSmVKNW04SXZEcEFEMS82?=
 =?utf-8?B?K1k0cGdWSUFFYXlEb1FnNkFIa2VuakxXTG9Vdjlub1hoS3Mrc2kvYmxKQmo2?=
 =?utf-8?B?L0wzbXJPMU1RK1Rtc2FqRVVDYTNyVU1TQTU2YjlvNXpwMllVRGY2Z0JVUlZk?=
 =?utf-8?B?WTBFWXlOSzc1azltUkpjUnB0TFFVMU8zQ1J2TWVHS2FPTnNZVnNTcjFKM0RC?=
 =?utf-8?B?OVV3K2pkZkc2akNNYzMyVWlDc1hmRldlYmR0UVc1eEw3bVVrMStMVXF5djJr?=
 =?utf-8?B?dlViaExkOHdsRC9wUURqVXJPaE13TnlSMFdkWlZVMG1TaXRjZHhiT1FNR2Jz?=
 =?utf-8?B?aHV6eXgzelY2cUU5Q0hFU3V4K0RYZXUrcDNxL2M0YjBEakZBSXg5RVMwSmtQ?=
 =?utf-8?B?WU4rNjljK3JZcE5IeG5mT3grUUVxMEcrYUE0NTVIdkI1UzVTK01QeGkyNHZn?=
 =?utf-8?B?SzdQUFBxWTh1QUlWcGlHSzhtK1Z0Y0x6cUFOaURmbVlKMjF3aGFuSkJyVURU?=
 =?utf-8?B?MTFWYWxmWENDcE5ZRWFqR0NFYkpHTU9wWE5uQ01IT0QwUFRJdy9xbmsxWm1J?=
 =?utf-8?B?NnRUSnkwMlBLMktreVR3bFltekpRL2ZMeWdxYkhQaEFJRlhQZk43NUxlNVc0?=
 =?utf-8?B?Q1BKem1RRlZBNmVPVUkwKzR0N2dXTytDeHJDUCs3QXNDNnNPc3Zxb0VkbVU4?=
 =?utf-8?B?UDNEZE9pbFIydzBkR2JjUU81dzE5SXIyNjU3Q0p4LzVZZ1dncno1bmxlN0JQ?=
 =?utf-8?B?MVYxbUVvaUVkK2FFamM4UU9USHBWRlh4RFovZGszRHE3U2NsVWN4aUFWcXJ4?=
 =?utf-8?B?eS9JRlJGcFdKbmVDbTNDanNyQmc1WjMzVERSU0dlcmRFK0JlUm5nYmcvSFA0?=
 =?utf-8?B?L2l2Y3RKYnlSOVI4cUlJTjVOTEh1UFRRODNPV0pnUWpwY1FVUnRoeFZPa3FR?=
 =?utf-8?B?UldHR0t3NTYwUTMweWtjbHdVejl2NXBwM0MzZy9hSDhJNTdwNXZ4UTRDeW1h?=
 =?utf-8?B?TTI5N0ZoRm1UVXF1RlBGb2w2VTFPc1lQRTBmQjVKN1EzM2lnYklxb2RoczJQ?=
 =?utf-8?B?T3VMVU5ieGoweWo5VXNPM1dmYTR6Nk5ISzBSU3hLR2owcW81elJOVFdTTldt?=
 =?utf-8?B?bHV5QlBLR0RXdThYYk1SQU9WN0M2d25aMzhsMFhDVE4yTXlwT0t2Z3dVcEUr?=
 =?utf-8?B?SDJxWjQ5WTEvaXBpVEZ2bVUrazFFeWxCdzczMVRYRUUrTXVRSW5JVUd0R0tN?=
 =?utf-8?Q?MEQoTKtjy2yJIicMUMpzMJCPwCbhjWttyeDppePj7U=3D?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d453a22-20c9-4dcf-064f-08d9d6729396
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2022 08:56:24.3771
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WaQzRJmpWuk5LU1vtGWZuldpYkpc5WlYRT0EUEO24sV2WnzaQOaNkhCSU/bWRhu8bvm007k/tObpMtt9Cw2QOQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1101MB2071
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKUHJl
ZmVyIGZ1bGx5IG5hbWVkIGxhYmVscyB0byBoYW5kbGUgZXJyb3JzIGluc3RlYWQgb2YgZXJyMCwg
ZXJyMSwgLi4uCgpTaWduZWQtb2ZmLWJ5OiBKw6lyw7RtZSBQb3VpbGxlciA8amVyb21lLnBvdWls
bGVyQHNpbGFicy5jb20+Ci0tLQogZHJpdmVycy9zdGFnaW5nL3dmeC9idXNfc2Rpby5jIHwgIDkg
KysrKy0tLS0tCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L21haW4uYyAgICAgfCAzMSArKysrKysrKysr
KysrKystLS0tLS0tLS0tLS0tLS0tCiAyIGZpbGVzIGNoYW5nZWQsIDE5IGluc2VydGlvbnMoKyks
IDIxIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93ZngvYnVzX3Nk
aW8uYyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvYnVzX3NkaW8uYwppbmRleCA0Yjc3ZGYyZjQ2M2Uu
LjVjNDVjY2Q4NWE3ZCAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9idXNfc2Rpby5j
CisrKyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvYnVzX3NkaW8uYwpAQCAtMjE0LDI2ICsyMTQsMjUg
QEAgc3RhdGljIGludCB3Znhfc2Rpb19wcm9iZShzdHJ1Y3Qgc2Rpb19mdW5jICpmdW5jLCBjb25z
dCBzdHJ1Y3Qgc2Rpb19kZXZpY2VfaWQgKmkKIAlzZGlvX3NldF9ibG9ja19zaXplKGZ1bmMsIDY0
KTsKIAlzZGlvX3JlbGVhc2VfaG9zdChmdW5jKTsKIAlpZiAocmV0KQotCQlnb3RvIGVycjA7CisJ
CXJldHVybiByZXQ7CiAKIAlidXMtPmNvcmUgPSB3ZnhfaW5pdF9jb21tb24oJmZ1bmMtPmRldiwg
JndmeF9zZGlvX3BkYXRhLAogCQkJCSAgICAmd2Z4X3NkaW9faHdidXNfb3BzLCBidXMpOwogCWlm
ICghYnVzLT5jb3JlKSB7CiAJCXJldCA9IC1FSU87Ci0JCWdvdG8gZXJyMTsKKwkJZ290byBzZGlv
X3JlbGVhc2U7CiAJfQogCiAJcmV0ID0gd2Z4X3Byb2JlKGJ1cy0+Y29yZSk7CiAJaWYgKHJldCkK
LQkJZ290byBlcnIxOworCQlnb3RvIHNkaW9fcmVsZWFzZTsKIAogCXJldHVybiAwOwogCi1lcnIx
Ogorc2Rpb19yZWxlYXNlOgogCXNkaW9fY2xhaW1faG9zdChmdW5jKTsKIAlzZGlvX2Rpc2FibGVf
ZnVuYyhmdW5jKTsKIAlzZGlvX3JlbGVhc2VfaG9zdChmdW5jKTsKLWVycjA6CiAJcmV0dXJuIHJl
dDsKIH0KIApkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9tYWluLmMgYi9kcml2ZXJz
L3N0YWdpbmcvd2Z4L21haW4uYwppbmRleCAyMTdjMGM1YzYwZDEuLjQ2ZmQ1NzAyZTQ3MSAxMDA2
NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9tYWluLmMKKysrIGIvZHJpdmVycy9zdGFnaW5n
L3dmeC9tYWluLmMKQEAgLTIzMiwxOCArMjMyLDE3IEBAIHN0YXRpYyBpbnQgd2Z4X3NlbmRfcGRh
dGFfcGRzKHN0cnVjdCB3ZnhfZGV2ICp3ZGV2KQogCWlmIChyZXQpIHsKIAkJZGV2X2Vycih3ZGV2
LT5kZXYsICJjYW4ndCBsb2FkIGFudGVubmEgcGFyYW1ldGVycyAoUERTIGZpbGUgJXMpLiBUaGUg
ZGV2aWNlIG1heSBiZSB1bnN0YWJsZS5cbiIsCiAJCQl3ZGV2LT5wZGF0YS5maWxlX3Bkcyk7Ci0J
CWdvdG8gZXJyMTsKKwkJcmV0dXJuIHJldDsKIAl9CiAJdG1wX2J1ZiA9IGttZW1kdXAocGRzLT5k
YXRhLCBwZHMtPnNpemUsIEdGUF9LRVJORUwpOwogCWlmICghdG1wX2J1ZikgewogCQlyZXQgPSAt
RU5PTUVNOwotCQlnb3RvIGVycjI7CisJCWdvdG8gcmVsZWFzZV9mdzsKIAl9CiAJcmV0ID0gd2Z4
X3NlbmRfcGRzKHdkZXYsIHRtcF9idWYsIHBkcy0+c2l6ZSk7CiAJa2ZyZWUodG1wX2J1Zik7Ci1l
cnIyOgorcmVsZWFzZV9mdzoKIAlyZWxlYXNlX2Zpcm13YXJlKHBkcyk7Ci1lcnIxOgogCXJldHVy
biByZXQ7CiB9CiAKQEAgLTM1MCw3ICszNDksNyBAQCBpbnQgd2Z4X3Byb2JlKHN0cnVjdCB3Znhf
ZGV2ICp3ZGV2KQogCiAJZXJyID0gd2Z4X2luaXRfZGV2aWNlKHdkZXYpOwogCWlmIChlcnIpCi0J
CWdvdG8gZXJyMDsKKwkJZ290byBiaF91bnJlZ2lzdGVyOwogCiAJd2Z4X2JoX3BvbGxfaXJxKHdk
ZXYpOwogCWVyciA9IHdhaXRfZm9yX2NvbXBsZXRpb25fdGltZW91dCgmd2Rldi0+ZmlybXdhcmVf
cmVhZHksIDEgKiBIWik7CkBAIC0zNjEsNyArMzYwLDcgQEAgaW50IHdmeF9wcm9iZShzdHJ1Y3Qg
d2Z4X2RldiAqd2RldikKIAkJfSBlbHNlIGlmIChlcnIgPT0gLUVSRVNUQVJUU1lTKSB7CiAJCQlk
ZXZfaW5mbyh3ZGV2LT5kZXYsICJwcm9iZSBpbnRlcnJ1cHRlZCBieSB1c2VyXG4iKTsKIAkJfQot
CQlnb3RvIGVycjA7CisJCWdvdG8gYmhfdW5yZWdpc3RlcjsKIAl9CiAKIAkvKiBGSVhNRTogZmls
bCB3aXBoeTo6aHdfdmVyc2lvbiAqLwpAQCAtMzgwLDEzICszNzksMTMgQEAgaW50IHdmeF9wcm9i
ZShzdHJ1Y3Qgd2Z4X2RldiAqd2RldikKIAlpZiAod2Z4X2FwaV9vbGRlcl90aGFuKHdkZXYsIDEs
IDApKSB7CiAJCWRldl9lcnIod2Rldi0+ZGV2LCAidW5zdXBwb3J0ZWQgZmlybXdhcmUgQVBJIHZl
cnNpb24gKGV4cGVjdCAxIHdoaWxlIGZpcm13YXJlIHJldHVybnMgJWQpXG4iLAogCQkJd2Rldi0+
aHdfY2Fwcy5hcGlfdmVyc2lvbl9tYWpvcik7Ci0JCWVyciA9IC1FTk9UU1VQUDsKLQkJZ290byBl
cnIwOworCQllcnIgPSAtRU9QTk9UU1VQUDsKKwkJZ290byBiaF91bnJlZ2lzdGVyOwogCX0KIAog
CWlmICh3ZGV2LT5od19jYXBzLmxpbmtfbW9kZSA9PSBTRUNfTElOS19FTkZPUkNFRCkgewogCQlk
ZXZfZXJyKHdkZXYtPmRldiwgImNoaXAgcmVxdWlyZSBzZWN1cmVfbGluaywgYnV0IGNhbid0IG5l
Z290aWF0ZSBpdFxuIik7Ci0JCWdvdG8gZXJyMDsKKwkJZ290byBiaF91bnJlZ2lzdGVyOwogCX0K
IAogCWlmICh3ZGV2LT5od19jYXBzLnJlZ2lvbl9zZWxfbW9kZSkgewpAQCAtNDAxLDEyICs0MDAs
MTIgQEAgaW50IHdmeF9wcm9iZShzdHJ1Y3Qgd2Z4X2RldiAqd2RldikKIAlkZXZfZGJnKHdkZXYt
PmRldiwgInNlbmRpbmcgY29uZmlndXJhdGlvbiBmaWxlICVzXG4iLCB3ZGV2LT5wZGF0YS5maWxl
X3Bkcyk7CiAJZXJyID0gd2Z4X3NlbmRfcGRhdGFfcGRzKHdkZXYpOwogCWlmIChlcnIgPCAwICYm
IGVyciAhPSAtRU5PRU5UKQotCQlnb3RvIGVycjA7CisJCWdvdG8gYmhfdW5yZWdpc3RlcjsKIAog
CXdkZXYtPnBvbGxfaXJxID0gZmFsc2U7CiAJZXJyID0gd2Rldi0+aHdidXNfb3BzLT5pcnFfc3Vi
c2NyaWJlKHdkZXYtPmh3YnVzX3ByaXYpOwogCWlmIChlcnIpCi0JCWdvdG8gZXJyMDsKKwkJZ290
byBiaF91bnJlZ2lzdGVyOwogCiAJZXJyID0gd2Z4X2hpZl91c2VfbXVsdGlfdHhfY29uZih3ZGV2
LCB0cnVlKTsKIAlpZiAoZXJyKQpAQCAtNDQ0LDE5ICs0NDMsMTkgQEAgaW50IHdmeF9wcm9iZShz
dHJ1Y3Qgd2Z4X2RldiAqd2RldikKIAogCWVyciA9IGllZWU4MDIxMV9yZWdpc3Rlcl9odyh3ZGV2
LT5odyk7CiAJaWYgKGVycikKLQkJZ290byBlcnIxOworCQlnb3RvIGlycV91bnN1YnNjcmliZTsK
IAogCWVyciA9IHdmeF9kZWJ1Z19pbml0KHdkZXYpOwogCWlmIChlcnIpCi0JCWdvdG8gZXJyMjsK
KwkJZ290byBpZWVlODAyMTFfdW5yZWdpc3RlcjsKIAogCXJldHVybiAwOwogCi1lcnIyOgoraWVl
ZTgwMjExX3VucmVnaXN0ZXI6CiAJaWVlZTgwMjExX3VucmVnaXN0ZXJfaHcod2Rldi0+aHcpOwot
ZXJyMToKK2lycV91bnN1YnNjcmliZToKIAl3ZGV2LT5od2J1c19vcHMtPmlycV91bnN1YnNjcmli
ZSh3ZGV2LT5od2J1c19wcml2KTsKLWVycjA6CitiaF91bnJlZ2lzdGVyOgogCXdmeF9iaF91bnJl
Z2lzdGVyKHdkZXYpOwogCXJldHVybiBlcnI7CiB9Ci0tIAoyLjM0LjEKCg==
