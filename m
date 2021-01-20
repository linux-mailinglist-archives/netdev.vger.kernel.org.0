Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 265852FD179
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 14:54:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727885AbhATMsB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 07:48:01 -0500
Received: from mail-eopbgr140100.outbound.protection.outlook.com ([40.107.14.100]:8839
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731604AbhATL1W (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Jan 2021 06:27:22 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b+cAHBWvYFTqO0GbYn0lm9mS2smHR8UoR8ucliAGdjNP1bePz1nffs4uOybEVWXKQEJdjg47jJ1ZtytQcTuwDSW1QroFJ48NrQE4yMe8uv4FnE6TDQWrIqdofRAGeekQMwlH6/f5wl1iuAggo/PVgtCaxrwF1AuI3uYgJf/0/T9fxodMeSSihJxMBLoYMQlvjqT7x7oC7BQq7nJ6BzpC2rHl36P6xsG62VNN6cfBNHkFX+OzO0e1FNTZ077W8f1m7BnK6x+FZHT3X8U5duXmyjn5le6bqlG04Nx12mMqQvaeJxtI5ix4fmT1V0nB/pfSLzoMxynBLuorFt8Bs9S4JA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U9Sd6Y/nLFcKyvCpbLhPrRJfp2Pa2QVmIbgkcpUJwd0=;
 b=aBdyGtzz+BKeUIm3zmFmgAygdSR/HLgEltNqZ5KtCnGNHQIDZ2qThQheREOXxR9FpmyUoDAWMMtf15ZPAJgrXhz/WUBGGdcSbpAi9lef7TbMCT3f33jwZT6kZPmMizjRqUKSJPlK1cI+nA1M6cs/MLytTE6g4Be6T2YmuX/89XKUvbfeCnuuttQDQc++BSwLlDscvPJO+gAe+O74oih3CalEniKrhar58/dlwSiKr90WSjxnhc0At0UevCfAYT8RjQnnShAQGDCncvS9bs6SwcNSsK0feaeBy7+dbOF8RDEgzRmSoEKMGNj2H/dvCThj4kviYz7Ep+l3zEernvihQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=prevas.dk; dmarc=pass action=none header.from=prevas.dk;
 dkim=pass header.d=prevas.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U9Sd6Y/nLFcKyvCpbLhPrRJfp2Pa2QVmIbgkcpUJwd0=;
 b=TNcDG6ZMC6T+cTJuwlRH2dRpGfXqcpwRVQj3X+OybRqX85vSRJZoSYzT6QrRBi8gRkkUjNVEhnXTbBCPnhmBFASY5xTxmOkmCM/2myibLSVIeHLXPL+SwUmSHEB8INPfN42Z5F6+5sel8tYDh3BkK5kIbGkUf41uRMi+3CI4lGw=
Authentication-Results: infinera.com; dkim=none (message not signed)
 header.d=none;infinera.com; dmarc=none action=none header.from=prevas.dk;
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:3f::10)
 by AM0PR10MB2113.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:4b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12; Wed, 20 Jan
 2021 11:26:32 +0000
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3]) by AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3%6]) with mapi id 15.20.3763.014; Wed, 20 Jan 2021
 11:26:32 +0000
Subject: Re: [PATCH net-next v2 08/17] ethernet: ucc_geth: remove
 {rx,tx}_glbl_pram_offset from struct ucc_geth_private
To:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        netdev@vger.kernel.org
Cc:     Li Yang <leoyang.li@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Zhao Qiang <qiang.zhao@nxp.com>, Andrew Lunn <andrew@lunn.ch>,
        Jakub Kicinski <kuba@kernel.org>,
        Joakim Tjernlund <Joakim.Tjernlund@infinera.com>
References: <20210119150802.19997-1-rasmus.villemoes@prevas.dk>
 <20210119150802.19997-9-rasmus.villemoes@prevas.dk>
 <26c7c3cc-2dec-c86e-2e9d-63dc1a7ddba1@csgroup.eu>
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Message-ID: <e43bae34-b711-a1ab-bba3-1a07a31e28a7@prevas.dk>
Date:   Wed, 20 Jan 2021 12:26:31 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <26c7c3cc-2dec-c86e-2e9d-63dc1a7ddba1@csgroup.eu>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [5.186.115.188]
X-ClientProxiedBy: BEXP281CA0003.DEUP281.PROD.OUTLOOK.COM (2603:10a6:b10::13)
 To AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:3f::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.149] (5.186.115.188) by BEXP281CA0003.DEUP281.PROD.OUTLOOK.COM (2603:10a6:b10::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.5 via Frontend Transport; Wed, 20 Jan 2021 11:26:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d05d87fb-7712-46d0-89fa-08d8bd363d38
X-MS-TrafficTypeDiagnostic: AM0PR10MB2113:
X-Microsoft-Antispam-PRVS: <AM0PR10MB21131754F9751DCB976665B993A20@AM0PR10MB2113.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:1728;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8T1wtAo8UIJ1XIb+pPH7eyWIjw1gdiMFEWvPDtg/V11bf/Lhjz8jTbIEvPhP7wlVJav2lk7fGE4P9pDuxtbIOtZaPswRZ16mPAT7+kTbcCNtdoAM/gXGHmDxqa4KDQpq0D/qF5FIenKGrOnbYjp+RMUePQqdXWj/mXcUqDiqfvFhGEn9gxa5Zu3Zc1RuJApJaJ9oc35bqZZ+klEj1WOLewY8XB+j0xKUuW0pOc1087xyfHNZ8K3xkr50ZG4jfW9mjvKpdgfYL2k7pgiXOXw95TGWY3ePejPgRUdpShjfn0NswpPdxGLlMyjDDGiidS+gEjcMgFW2spEutBBEEm8f4QICQ5yO0DpgBj2I9E8VDu61RgZck8fYYS0Ta/HjHs/hf0OLfkPQv1ZMiCIdtKTvycCKYWvvpZcUyyhYBweilT9GdzMSqAO7v0emsaMQAqnQgiy1pJiEe+Hktu4QYQU845eAsq/3Z2N+B2SFfGXxPDw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(366004)(376002)(136003)(39840400004)(396003)(346002)(52116002)(8676002)(4326008)(956004)(54906003)(2616005)(44832011)(83380400001)(66574015)(31696002)(5660300002)(6486002)(186003)(16526019)(8976002)(31686004)(8936002)(26005)(16576012)(316002)(478600001)(66556008)(66476007)(2906002)(36756003)(66946007)(86362001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?VmpNeGJncGdxODRpMnNYU3BoZkE1TkFrbGhQa0NIdVViem0rNUp4aUMvdEg0?=
 =?utf-8?B?WjdwTlk3c1RsRU5yQVJNNE0xbGsxUjdPOUJSdzVzSzFuakZaSzM3WWViMkpq?=
 =?utf-8?B?RzZzamJlSXNNc3lJUEtRUGlVZlRjNzY3UDQ4c2wvYlFpeTNrdzBzZlBQY1Rm?=
 =?utf-8?B?MSszbEFQVG0yZlFRWndQWjdHZ2ovdHg0V1JTTHJtdjFWbG9QcEswSEwzTHVE?=
 =?utf-8?B?UDAzOUJoODVWeHVrSEdIUGlJTW5TU3FBT3lWQ1VManBPbkdaSHRBdUdWUVRG?=
 =?utf-8?B?dTVCSERpMXFzZWx6RjVEV0pmZE1PY2ZjVFk3bk00YWloTXpKaFpYMUpZaHU4?=
 =?utf-8?B?d3VaQ2JPQjlWZHRJaU4xVWNtd3dxWFRyWWJXRDBkWEhqQkg0RUNkRzdoZytu?=
 =?utf-8?B?TmhkSWpaYUFHYWVRL0ZHeTgvRjBWeDNBQ0xXcTR3SEVZVEVtb2VUZTg4MDJx?=
 =?utf-8?B?QXFjbWFtcG9sL2xEa2hwNHlRUWoyWC9mUytDZ2FGeFhKRGJoa3Q4Ung3bzEr?=
 =?utf-8?B?ZWZVUEpsOGF3eHk0bnJXdkNnQzNuSHM2Z1hWYU9qT0pFd3BrME1zNlF6aTU3?=
 =?utf-8?B?ZVVnSzcrVUQxOERsVUVWSmxJbXV0bHNHWXdiVjJITnhtRm81MTBaVDE2UGlM?=
 =?utf-8?B?dHhzSmlNcU8vWm94V3BpOXoyZWJMYXB3c3R0TzJOL3BVSzkzRGw3MTBBL3Bx?=
 =?utf-8?B?REtKQzRkbHJnVGRFM0g1S1MwTUpaVjRqcXpYWkx2dTdxVG5OS21Hd0txbkRX?=
 =?utf-8?B?TktGUndaU1REWmp4cTcvS1BaMjdNVE5jOWl3OFMyMDh4TkNsYjUwdWU2UzRC?=
 =?utf-8?B?WlFWU3NWUWJWM2FNRWllckEzSVkzVXpEWEZTQlpUSlBzOUVGdzlqNFN6aDU3?=
 =?utf-8?B?dlJhTGRhNjBGRDlqblFlYU9NT0pzTjE2ZHFaazI2S3hqZ2JnekxxOWJiMHAx?=
 =?utf-8?B?Q2tRemUvSzJaeWM0M01XMUUyNVZSVmkxOWxLQ0ZJaDdWWWtJckw0aCtRUVVB?=
 =?utf-8?B?dmVpcHIxNzNla2tTRmJVQWJIcVY0RThBd0dEeGNkZUE0VXdtZkcxTHE1MGRY?=
 =?utf-8?B?UTlOOVpYM3ZzQnUzOWoxdUxFUVVhdzdNS2VGblAxYitaVGFidXRFLzFaTzhR?=
 =?utf-8?B?SUdIREYxNGQrdnhJcVc2OGFRS1kzQTFBLzJ6dkJ6SEIrOWVoOWtFeWU5ZTNT?=
 =?utf-8?B?TzAyNlp0NDR1Y0VJamtGUUMyaWpZaklTWXd5b0N1aG5ESFRpVERWYUpHTnht?=
 =?utf-8?B?VnB4QW1VRk9pWE5ERWpKdjZJSUtRemtCY3RnVE9qY2RiK1VJTHVEdGFQRTFE?=
 =?utf-8?Q?rMi1aBYvL4WlemifOUeqcYgRLr0e38RgHv?=
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-Network-Message-Id: d05d87fb-7712-46d0-89fa-08d8bd363d38
X-MS-Exchange-CrossTenant-AuthSource: AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2021 11:26:32.7923
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /dYpmrDXIApKqsgfYoPYMZxzSZGDA3VHEz6FwLKRhaV6XhNRIFr/bPu+MhmRWnFsB93+FeJYKRzI9C7eC/hwMCyrWQ1H7ssmfgZYTn2Bp1Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR10MB2113
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20/01/2021 07.57, Christophe Leroy wrote:
> 
> 
> Le 19/01/2021 à 16:07, Rasmus Villemoes a écrit :
>> These fields are only used within ucc_geth_startup(), so they might as
>> well be local variables in that function rather than being stashed in
>> struct ucc_geth_private.
>>
>> Aside from making that struct a tiny bit smaller, it also shortens
>> some lines (getting rid of pointless casts while here), and fixes the
>> problems with using IS_ERR_VALUE() on a u32 as explained in commit
>> 800cd6fb76f0 ("soc: fsl: qe: change return type of cpm_muram_alloc()
>> to s32").
>>
>> Signed-off-by: Rasmus Villemoes <rasmus.villemoes@prevas.dk>
>> ---
>>   drivers/net/ethernet/freescale/ucc_geth.c | 21 +++++++++------------
>>   drivers/net/ethernet/freescale/ucc_geth.h |  2 --
>>   2 files changed, 9 insertions(+), 14 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/freescale/ucc_geth.c
>> b/drivers/net/ethernet/freescale/ucc_geth.c
>> index 74ee2ed2fbbb..75466489bf9a 100644
>> --- a/drivers/net/ethernet/freescale/ucc_geth.c
>> +++ b/drivers/net/ethernet/freescale/ucc_geth.c
>> @@ -2351,6 +2351,7 @@ static int ucc_geth_startup(struct
>> ucc_geth_private *ugeth)
>>       u8 function_code = 0;
>>       u8 __iomem *endOfRing;
>>       u8 numThreadsRxNumerical, numThreadsTxNumerical;
>> +    s32 rx_glbl_pram_offset, tx_glbl_pram_offset;
> 
> That's still a quite long name for a local variable. 

True, but I wanted to keep this mechanical and easy to verify. If
somebody wants to clean up the local variable names
(numThreads[RT]xNumerical also stand out), that can be done later.

Rasmus
