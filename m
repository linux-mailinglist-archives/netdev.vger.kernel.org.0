Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98565452D26
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 09:51:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232481AbhKPIyH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 03:54:07 -0500
Received: from mail-eopbgr70119.outbound.protection.outlook.com ([40.107.7.119]:39137
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232473AbhKPIyD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Nov 2021 03:54:03 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XEggXUSMN+S577v3CTDBaUytQdJ6I2fgOjS/ZqDpVDFhr0eBRusEv8Bm+h1br3D/PZW8A3SC84L4jBP8N8PEvSP8PrMB1l6z96c12drtVXOWqW+bAP22a5ITKFxcFj9ZtqLZDzBzmFQvtpxDvEgR47yXLBNvMYHGIuUWSIVAFOgfNnyig3Y09KDFxFBXAewFSwhIs+ICJJRVAUWX+xEw/yRDRkZs8sEJW84hjA62NfNxFshBRuvsP1UGPj2lCaX7qVNuNRXkgArexAlRntrvJ6kn3l/2rAEPNbf5Ez5nrD62QHJCQ0Xp8/wJljtO0eZ7SD9evcz48DRdnDXyHTtA0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GbHlC4YnSYNpRh4B0SnuAIhv40Ak4qV82rzlMWRMrVE=;
 b=B1/3uBskg8FS/9ARTFFA2HLObJJChUlizUayaEB6mS9IKe55/kc9NqFdRGHq9tKRs265kUSc2usPcrSgEmoTsBpd5uXC5SLUMIQfclWdLgxExpNYQP3d/wkltDMeD5pnutqimxPRdV4O1+kkJZvFhWJdW1ssV5t9ay/4vLt9U4hqUXsEzP4EG8lJj/YLuv1zSYtBhG3Xi3x1YTo6rUSDiKwyp3Fr1akdDzyotBPir6FOGffuG2d+ZA7dj8fco4RgynWUqT0yAgZs7sfONzh3K2txuItx9xsSpVYZD6AiMyr8lAOFBa9fgp8YY8lpXb3hcYf0BxekYiyLVSv/ng9cVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GbHlC4YnSYNpRh4B0SnuAIhv40Ak4qV82rzlMWRMrVE=;
 b=ARNj+g0jL050MqxNdxqkSIKZLzwwJ1XRfE6S+T8M/roXhkLfjwT3GhJh+xs2lJ9cVQ4VBqMkmoHCpduNVBn6oVgbDXNXTATdSBjuUVhimC+nv7N2AT+61N2TxfVZs+dU0gj0ZECx7cm5/+pr6dd/4F+7CNJtohrdTi2JItfjtNw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=virtuozzo.com;
Received: from VE1PR08MB5630.eurprd08.prod.outlook.com (2603:10a6:800:1ae::7)
 by VI1PR08MB3710.eurprd08.prod.outlook.com (2603:10a6:803:c5::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.26; Tue, 16 Nov
 2021 08:51:03 +0000
Received: from VE1PR08MB5630.eurprd08.prod.outlook.com
 ([fe80::f875:8aa8:47af:3b75]) by VE1PR08MB5630.eurprd08.prod.outlook.com
 ([fe80::f875:8aa8:47af:3b75%5]) with mapi id 15.20.4690.027; Tue, 16 Nov 2021
 08:51:03 +0000
To:     Stefano Brivio <sbrivio@redhat.com>
Cc:     Netdev <netdev@vger.kernel.org>
From:   Nikita Yushchenko <nikita.yushchenko@virtuozzo.com>
Subject: "AVX2-based lookup implementation" has broken ebtables --among-src
Message-ID: <d35db9d6-0727-1296-fa78-4efeadf3319c@virtuozzo.com>
Date:   Tue, 16 Nov 2021 11:51:01 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS8PR05CA0023.eurprd05.prod.outlook.com
 (2603:10a6:20b:311::28) To VE1PR08MB5630.eurprd08.prod.outlook.com
 (2603:10a6:800:1ae::7)
MIME-Version: 1.0
Received: from [192.168.112.17] (94.141.168.29) by AS8PR05CA0023.eurprd05.prod.outlook.com (2603:10a6:20b:311::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19 via Frontend Transport; Tue, 16 Nov 2021 08:51:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c2600f66-ae91-49b1-5e4b-08d9a8de3891
X-MS-TrafficTypeDiagnostic: VI1PR08MB3710:
X-Microsoft-Antispam-PRVS: <VI1PR08MB3710AEC471D9CBB657BC5E74F4999@VI1PR08MB3710.eurprd08.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:541;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZtCymPROSmrBOhyInjtqXyTxZAtEA0f8bh5dk+UY/yK3Lvn0a3kjGAhGs33EWMQ3cLUX3dwuMoQjXhgSntOqJcWl6rSfwDm75984Ixl4UCKo7Sqt91QxSC3vJ4g0JaDepkNmx8MT1uI6ClcnokVpF9XXE6meCeawJn3cuXLIYJDQonjpvIf9irJVao+uboslYhF9BHrCaeQ6sXyeorco41HdNBXs4HfzrLmB1tGWf+ixhlpYSYdjVLO4+yJonH/fLRCZDIJ8yOHcptnFYJgx5CqHJCiMF3N3XNBtDDECArk2wPpNGUI/VF0WJYmj7D0gcXV9js6CDW0CRuQPH+fRpQoTofcy4MIt9xP1XNwbAtdPDOfKsrN/f34pUzrLiMQGdRxVcTIB7vHVKB9wJ2jPkj88YRbXUhPhjUeYUwY5fJP5JH9d/WmsQJwUixDcvrH9ODX6/jYPqlSojaTfGlwriq0FrsMntXGZpW9xvfAELdvoRc0yJUkwyA58Hka+T+o/u1C/ybvYTI23m2SDuaCfTo9oV493mYOepNjy+clYWfxJ0TuLmP2t1KDZlRBRVfqAav29q8dF76ZkAtKw3m6+uFdavGhR01uIBkr4vJZyt6pyzGd5EuJke43fwD3MqwSDOxohBnrJP1X1x9x50wqrLhrIO7cR/GrWJJW8zssHMdYclysCr40Vxzm+MzJoFcodXG3utiel9fqNMz8HcZmLLWJ9TAVzb69X2d/oED7RjvA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR08MB5630.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2616005)(6916009)(66946007)(36756003)(956004)(508600001)(44832011)(186003)(66476007)(5660300002)(31696002)(2906002)(66556008)(38100700002)(316002)(16576012)(26005)(4744005)(6486002)(86362001)(8936002)(83380400001)(4326008)(31686004)(8676002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OUY5MndlNEZISkx5R0NTalJjdVhESmtXTUt0TFBxbHpmaWxSV29jNGVGTkc2?=
 =?utf-8?B?Z2w5allsMmZGbEpaRW1GcXM5cTFxOTJROWdjcUVwenFEYUNES0ExMGkzUDdo?=
 =?utf-8?B?VzYxNlAzMytodkZHaVR1c0xWR3hQdEVrZDh0cGwvUXJ1UFRPbjFlTXhGd29q?=
 =?utf-8?B?VjhxK1JzYmpWcGZPWmJaS001MzdkQWtkTWkrdWd2S1R2R2JWWEZYZG5GRGtQ?=
 =?utf-8?B?c3Jaak16QUo2and3My9IOVNnYmw2Z1UxV201REJlRXNFVUtzQkliNlFEakhZ?=
 =?utf-8?B?ZjlHTFU2UUxOT3hlQlM4U3poYzFCQzhvSHZ5YndEcm53Nkt6ajk2M1hndEFr?=
 =?utf-8?B?SWM1dUJXRW5ZMUpzN1Q1cDI1RHBRNVdnV0Vkd3B5NnpSK0VqZ2VrQXF6cFpL?=
 =?utf-8?B?R1pWRnpNeUUvSDZqSXBZVUV5Z3Nrb1lJYk5xMkI2OW5ibkZZRHhaMVBHTXJ1?=
 =?utf-8?B?WFBCdmxXN21pU0FjaXlBR2FyOEZ1dTdUOVNRZjJwVjIyMlVKUFluNG10d0xD?=
 =?utf-8?B?OXJaanVLREMvRTIrMnp1VGo5c0lCSTNjaVFBKzBtZkFXUDlXakduQnI2cTY3?=
 =?utf-8?B?QWRYRE1IR1RkdFJ5U05KTmdDSjJ2cmJSd0I3dklhZkE4azdTL1BwZDc3YkNm?=
 =?utf-8?B?aW1Yc25kcHBLSG1tOWxyMDViQWVQOGw5aTh2SFN4TEoxbWtwdjV6WUphNVlv?=
 =?utf-8?B?NGt5cXRhSFZnalJJU0daOHlLOUpITm9pRlgvbnYzWjd5clpHMFI0SC9GZWho?=
 =?utf-8?B?S01Jb0x3V2Ztdk8wWUdFakdjVGtISU9aOUNYNnYxVHFwTm9xNVkwMnplekhH?=
 =?utf-8?B?cWowMDRIdmtXKzVMaVZ2d3A2dDRNaVNEbG5qSXgrYTd2ZExSN2czVnlHa1NZ?=
 =?utf-8?B?c0xOQzFIT3F5eUZpRHQ4NzFKNlhLM3NmYlF1RXBiYUd5S0JuS2podERSSk9O?=
 =?utf-8?B?VEhpZXZtS1dGajVPL0VKaXBKK3RQZytQWDNkWTBPdjBjazlnSFZMVnZ0OEdT?=
 =?utf-8?B?V1MzUjB4V2RRVDdNS0FsTDBOZTR6andtaithNWhEV1hhb2wxdjZlY1FpZ29W?=
 =?utf-8?B?cTd6dzVHTXM2d1lmMVRVTXppNHRPWXZqcVVHUE1taHRjZ3pWaElTalo3d0ZU?=
 =?utf-8?B?amRuakNRK2phK0c1TmlkYUhvRVIxdXpWQkEzcTQvUVBLZSs0Q2U5eUtMWjRZ?=
 =?utf-8?B?VHI0WEIvVVAvSm1OTmtkSC9mbk1XWFRuUytGOW1XTEpjQUpGN2hkUlZaRHpq?=
 =?utf-8?B?V1RxUWtld2UyblF3QjhZY0JrOWs5aE03RU1UZWFVUHBBRGVPZTcxYUZGWFZK?=
 =?utf-8?B?UzA0Qkw3RmlUY0Q2MGVWZmhac25XbEdMUG5nY2RLY091a3l0S00raGovVFA2?=
 =?utf-8?B?ZzVwTEdZNHJjUTYrSFFoTWlmK3NuZFV0ZldJS0g0K2Fzak5Wa2w4UlNYUER3?=
 =?utf-8?B?ZXdZMkU0dCt3bVFkOVZnZXdJcjZHL0hrTCtNK2U2YjNDMStGQ3dzd2k5YlhR?=
 =?utf-8?B?UXZRVnUrOEV5NkpDckcxbFRBMTZJMUVzTDNsQXg0WjVBcGRmTDVVTytubFlH?=
 =?utf-8?B?ekVtQjJJR202M1JPempiSUYzQ0dObVFUcS9vZ3VHNGdpRENXd0hKMG5XcTND?=
 =?utf-8?B?Qm82TXFkK3l4OXN6aUtsNzJGZGlLZGI4bEdjcVY0WDgzU3dBcHlTMWxQbngy?=
 =?utf-8?B?MlNsUkFteFlVRGc4R0tvei9jM0hRNVBocW1weCtOV3RJejNKWGRxZUpQRFJM?=
 =?utf-8?B?QnFZeTQxNzcvZUxYbzRMTUQxd3RUVE9sSm0wMEVTWDJ3YXdXN3BEY2xxdDQ3?=
 =?utf-8?B?OHZUU2l0Tmhwb2V3TWZtakZWSnc5V2tvMUp1L3FMN3cvcVRBNFhmUmRHSTZK?=
 =?utf-8?B?dTJsMjN5LzNtdTZxc1E1Rkp4ekRtY25UdzQ1THdkUjJ2YmhIWmJVeDdGMkdw?=
 =?utf-8?B?cXA0U3NXdCt6RlJVMWs1SUpsNU9FNk0wdGtQQmdXWXR2dkNnR2RNVUd6T09G?=
 =?utf-8?B?eU1qYkdNa3E3aVZBbUZTUDVMMWNXb1hrRXNNc0FCaHdkYldjRUJ3YkRBd3lx?=
 =?utf-8?B?ZEc5YkpnckJNNGFWSHZOUTc3WXA5TTVZblh6Y3pVZmpkeGlKdC9Cem9sYXp3?=
 =?utf-8?B?b2dodk5aRnAxdGFXWUt1TDd6eEZFbXF4SHJGcG5LeHE3bEtpMDZqVkF5T3hZ?=
 =?utf-8?B?ZTV6c2QyZ3gwMTNRTmc3TElZTG05cGJOOStGSXNBUHNuSS9HM21XQmd2R2hz?=
 =?utf-8?B?UkhCVVdRanFobmhDdG9ZR2YwdVJBPT0=?=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c2600f66-ae91-49b1-5e4b-08d9a8de3891
X-MS-Exchange-CrossTenant-AuthSource: VE1PR08MB5630.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2021 08:51:03.6227
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CWIQWKYGajxB+l2t3WLiS/SnGpfD0DtpTee70ZTKCmUstblGbPedDp6TeTacq3+xlGojjnnsXnKHOCwqaeRvz9vC9aN25jJPHKGobfoIpx4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB3710
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Stefano.

I've found that nftables rule added by

# ebtables -A INPUT --among-src 8:0:27:40:f7:9=192.168.56.10 -j log

does not match packets on kernel 5.14 and on current mainline.
Although it matched correctly on kernel 4.18

I've bisected this issue. It was introduced by your commit 7400b063969b ("nft_set_pipapo: Introduce 
AVX2-based lookup implementation") from 5.7 development cycle.

The nftables rule created by the above command uses concatenation:

# nft list chain bridge filter INPUT
table bridge filter {
         chain INPUT {
                 type filter hook input priority filter; policy accept;
                 ether saddr . ip saddr { 08:00:27:40:f7:09 . 192.168.56.10 } counter packets 0 bytes 0 
log level notice flags ether
         }
}

Looks like the AVX2-based lookup does not process this correctly.


Nikita
