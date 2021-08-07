Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA09F3E3794
	for <lists+netdev@lfdr.de>; Sun,  8 Aug 2021 01:33:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229874AbhHGXdx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Aug 2021 19:33:53 -0400
Received: from mx0a-0064b401.pphosted.com ([205.220.166.238]:30020 "EHLO
        mx0a-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229578AbhHGXdw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Aug 2021 19:33:52 -0400
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 177NXEFl019440;
        Sat, 7 Aug 2021 16:33:14 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=subject : to : cc
 : references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=PPS06212021;
 bh=GIHd3+3l+6F+phtTe482YbghBu6kc8QuxB+Vy7ZW2r4=;
 b=N0/w87YLRMLSOqt2YY/a6CNG8KaJKsgMu5IAcA8nO9r+9lRhpqpB93tXM6LxPtEHcUtg
 WL8YyDR/OiiB9s1QmFGRPfN6aNuCm/YA/PSLDpm58XYKc4Ylu3G7fDnUVKjAJUIeXdTs
 7Ayep7mj3cPe1BA0dCBQrk71w46jUoC4PhUJWFkCONaSobOwRUdNkj0R7D/54S6wYDKg
 oAp3pDl5ZlcngjklRJJw1tf7UtsZx7kbeleSoyq59njmMKn5+6AbV+5sAtY0pofaW1U3
 MpFG5M6xl+a/fdCbUfiI4PIFMUu0ojf3uiY1F/q5zCuLC7dqPv12G9IUshLGCtYJLLqo QA== 
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2048.outbound.protection.outlook.com [104.47.66.48])
        by mx0a-0064b401.pphosted.com with ESMTP id 3a9nf3rbpy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 07 Aug 2021 16:33:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MUQs3xS3xiXTifydvJwe660gN2qEagI66ux6ABj73XsJl0IPMAl6IgfezTRC12w8UoLB7esDocz1oyXzjL3YIQFHBHs7QqwDHcR0LRxyeo6j4ASz8p0fa8XBZL6tRnLVGrDHsq8Yx133RNsiTg7jgRraXmGOImEzBI9W5lKnB4N/NLNIBlcI10E6C+uyLtoWNtK761ZGm3cYPNThA2DmxM7ospcvAJe/dpj6mrdvCeG0P2U2WmSdNz31DErANaPvaFPfDCCxy0OUG0DgGGeI+nWhidBsGMCBVNBtIjLmCj952PHThPRXt/mDpog1AgP8Cmst9r59ZH6qYsqqCtza6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GIHd3+3l+6F+phtTe482YbghBu6kc8QuxB+Vy7ZW2r4=;
 b=FM5b9VHtHLenKKbqs5txHQUBsSxkx4o6zz+4lncKuVg0EudmaYwHjCyRgrHdODvTjOVW+qiVSCZ5+uPie0RHwGFH52cpym3K+WmhAz84mk2DYF+1JXw7g8ECWH4tLZqx4h7S6kbFVXgzo6UlkYou/neOz06zi0lQKWU+ELHxb3ZG5Pxa/Hb9RLQfiFH3GRyYcji2QuKYnkp8TdpXBDbvJLDw/pK1z1wG5NZEUL6VamZ2tBZEleCgTJO6vPk4z3fkRnokyG7+4gCnwaRDS0oOHMWKp6Eer/PlFpSwqh5cCuP3ZZeM9fxmIgoUTTtiUY/ECwsJGnFPGBE20psQB3LUgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=windriver.com;
Received: from DM6PR11MB2587.namprd11.prod.outlook.com (2603:10b6:5:c3::16) by
 DM4PR11MB5501.namprd11.prod.outlook.com (2603:10b6:5:39d::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4394.17; Sat, 7 Aug 2021 23:33:10 +0000
Received: from DM6PR11MB2587.namprd11.prod.outlook.com
 ([fe80::8ccc:636b:dcea:7a5d]) by DM6PR11MB2587.namprd11.prod.outlook.com
 ([fe80::8ccc:636b:dcea:7a5d%5]) with mapi id 15.20.4394.021; Sat, 7 Aug 2021
 23:33:10 +0000
Subject: Re: [V2][PATCH] atm: horizon: Fix spelling mistakes in TX comment
To:     Joe Perches <joe@perches.com>, 3chas3@gmail.com
Cc:     linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210807153830.1293760-1-jun.miao@windriver.com>
 <7afa073ece002f84f4f2c28b3ac3032ded94bf43.camel@perches.com>
From:   Jun Miao <jun.miao@windriver.com>
Message-ID: <333b35d9-3d44-cf2e-a9cd-b9de762b84df@windriver.com>
Date:   Sun, 8 Aug 2021 07:33:02 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <7afa073ece002f84f4f2c28b3ac3032ded94bf43.camel@perches.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-ClientProxiedBy: HK2PR06CA0016.apcprd06.prod.outlook.com
 (2603:1096:202:2e::28) To DM6PR11MB2587.namprd11.prod.outlook.com
 (2603:10b6:5:c3::16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [128.224.162.214] (60.247.85.82) by HK2PR06CA0016.apcprd06.prod.outlook.com (2603:1096:202:2e::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15 via Frontend Transport; Sat, 7 Aug 2021 23:33:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 57ed52dc-dac9-4e4b-d161-08d959fbb776
X-MS-TrafficTypeDiagnostic: DM4PR11MB5501:
X-Microsoft-Antispam-PRVS: <DM4PR11MB55014CB621CDE2F00F803DA78EF49@DM4PR11MB5501.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9k6jFaGJ/HtItVsLUWxsDOZsOzt3fy9g32Wx3yFXgGUq6dJe3UVQD+3C5nVdzYSP3EQ6JglxKcvnet6n5xX2JHXjz+7j1i26xuhNs+bPxIDxEl6KZ5HRvg+/qihk1q21YUAtl5o8/uXwdFjB2mPVKR3+7yOoXegffQ/2l4ujbr3IGlWS8H9n6zV66KsCPTbdioGjianUuegDAFEC6XXBduvYJhxZicUeFz5C7IiajnP6qu50Fm3U/vKy+khJNlg06Mf32pI53rH7bBXHVaV0asA4K9X7NKhhDfL/OxyiP+DZiH/Gszb4ZajePdCRK5sgHiAsV54ycLiPoxS1vbMKtk2i9qBKTpGJWiD0Qxysyzc//yA3DybSGHZjShqCMvD33ymS09W4r5kHclidVJ59S7Hs8tR2O/2Gp8E7YXAj2w77LCmJFgbP4Rve1dYDHoY4z6sd071fOFKbXUW1qqBjM+fhRhrbswihzUmGvMEnCI69NEmnxRuQjxxw0RxlgikOx0brFpomZeFIgUHZf70i+CGsIN4KTGJBiiRuX0CjroTYxk2d5yuxjMnnKpNdNb9mviqUWVBeu7hjfYZ1ca1GBaXdUUM+9M56nS8payIj2EkTABYFqgADfYzgo7pG3t09upPmt5ztNaDKYPY1J6SKA6snaSHbT2L11yV4Kk0ODaMIuwYW9JBxdEANluqr0TGpgnfQTL0WhOEkp5M0b/zBsR0vNjMu5OUGr4WqLbxx1cQEYYwNzBiCbvC/SyXpVpY2vmQWwa64lvc5lzoZ8/BP/aph01Z4SWZGq46WfeLnVQL+Ny6DTbHxCrdfnRY+USoF
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2587.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39830400003)(346002)(376002)(136003)(366004)(396003)(26005)(36756003)(16576012)(6706004)(6486002)(186003)(2906002)(38350700002)(38100700002)(53546011)(4326008)(52116002)(316002)(66556008)(66946007)(66476007)(31686004)(8676002)(86362001)(31696002)(6666004)(8936002)(5660300002)(478600001)(44832011)(83380400001)(956004)(2616005)(169013001)(78286007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TEh1QnFueEVCNC9vL2hHSEZ2a0tCVDgxZmpZK0tjVkZEdm5FaUxGQ2ovWHJT?=
 =?utf-8?B?SzhjS3VkYWFSK0laajBuMGYxT09mL0Z6RUE4TFlNSzd2MCtOWE1QV000U05y?=
 =?utf-8?B?cHFHVlJqdjZnMngyNUhON3NJOG93OVZYaW5KZUNueEVLRFVvSGFiQUdHdHFh?=
 =?utf-8?B?dlFiYlN3ZVkxZnhnK25taDlEaFpIUjgwMENCWHN5Vm5FSk0vRkwvdWxaejFj?=
 =?utf-8?B?aDMzNVZyVHNMdTRXZnVsd05oZk5palBoTzZmdmlkV3hPeUwvRlBFR1VNdXVX?=
 =?utf-8?B?NmZISTlibUljT24waFRZTVU0TVJvcE9rSzNaZWVnbnV1L2lsUjcwcnFyVE5j?=
 =?utf-8?B?a20xc05PUkdsbWpDbjh5Um9KaEFXVEdXN0hXaC9vZkZ1MU93WERTQnhpelFQ?=
 =?utf-8?B?UXlKaXFPNStEbDJMTjR6S0pwMExpcjJUdkM1R0Q4cTlzMnNxNlJPSXByOFYr?=
 =?utf-8?B?aGhpVnlVa2F5aTAyb25mTDBLNTdTR3l4T1l1L3lDRFZOSDhZc1FvblJwUzlX?=
 =?utf-8?B?WWdkR05XOEFReFgrM3c1Q3pDOXRUbXE3THJ4VWwrRU80aWp1a1dscStqbXM4?=
 =?utf-8?B?QTN6TkFDbEtPdmxoaTlEakpCcVBwVFF3U0h4YkN1ekJmaTBoZGlRemdVN0hH?=
 =?utf-8?B?S0tMWnVsUTh6dGFiU1Nnc2Z4dUg2bFpjdGkzWWFyL2pyRy9vU29KVE05WnZH?=
 =?utf-8?B?VEhCUXNVR2xsTk95Sjc5QmxjRHY1aFp6dFhwN0hlODk0RkYzdUdjekJUSUFa?=
 =?utf-8?B?VWZhZjBGM2xMUTBCK0NHVkxCa1pEYm1KbkR4cnJZYm9ndC9GQTRUYmxGT0xp?=
 =?utf-8?B?cXdvWjBCZERDaEFiZW4rNkJKczFnekNjNzdXeXhlNXNNQjYxWWJWWk9RRjN4?=
 =?utf-8?B?UHJEeFNjajQ2aFFGb0xneVdXbHp5VGp1MlpTNG9HeHhaU1lVRnErazJEbnNp?=
 =?utf-8?B?dmlzN0ZyS2MvaEMzMTk1WVlMVnpkU1E1ZndJcUZHQThGUlZqSU8vQ081UnB3?=
 =?utf-8?B?RUkrRzhPUndyZ1RyMjVGWkE4eWFsMkhEbjZEV01ObERJdm9qWHlzRmRNTURF?=
 =?utf-8?B?a0M2UVJ5bHdlWW1nVHBjRm1EZno4bzlKS083cXlSZjE0Q0RqUkVYaFR4ZTcv?=
 =?utf-8?B?cnBNSWpxMlpUbmlzNCs3ZlFyaG1zQlNSRUxaSHJPb1JaSUdHVnVUU250YitJ?=
 =?utf-8?B?R3g3UGpIWnB3WGludWxMSWp1ZSs3K1BWdk9aOGg2V2JXN1V6RUVDUktwOVBn?=
 =?utf-8?B?dE9FUGhOZjJVR1pTT29ZZlZ1TFpBd0dOaFZ4d05iSmFYeXJhWFRzL2VKMDBQ?=
 =?utf-8?B?MWl0cERWY3UxeDNaNlN6ZUZuUmRaYTNsV3B6RzRrQzBsRWpxZnhlQ3lsWVoy?=
 =?utf-8?B?RmtYUzVjeW9MbWFXZ3U5QjloaENvczNOdmFNb3RMaFlLMnlDaFZNN2xVbEw3?=
 =?utf-8?B?TUw5WnFyU3lMUWlocWUrdFh6Y2FGMzNJVlhPenA3L3lIWngvOWYycFRTamw1?=
 =?utf-8?B?elI5NDJLbW9PcDRvTzc4aU1NNEhrZTBFZGhqTjAyVHlmWXBIN2VMbG5CV2pw?=
 =?utf-8?B?ZzVCblhSd2NNZENFRG5MWGNQWWlJOGVwK04yMThSZk5KcUJjTFNXWDF4MGJz?=
 =?utf-8?B?R3pOek1kU3NndE9RSkdic2UvNnZZUHduSFBuS0FsT1loRzVGYTdwV1pmbmVF?=
 =?utf-8?B?cWg5Z0RMYUlFbmdXOWZmKzRFdWpkbkZqa0FvZUJmVTVjR3FuakpGMFpzMmdm?=
 =?utf-8?Q?aVgN5MUM3w/ng4g6zKRWC+nJvwUbV1kov0Lu69h?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 57ed52dc-dac9-4e4b-d161-08d959fbb776
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2587.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2021 23:33:10.1335
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: t8ec4pswY5fqGNKSxcsL22znx4/G0PMmkaQ1bscluc0jyYdt7v0+q0DBByavaAKwyL6nEDupri1i8U9PF92vsA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5501
X-Proofpoint-GUID: oPXCmK8Y_2K5NMHISpL8bZvyafPxdyAy
X-Proofpoint-ORIG-GUID: oPXCmK8Y_2K5NMHISpL8bZvyafPxdyAy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-08-07_09,2021-08-06_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501 mlxscore=0
 malwarescore=0 bulkscore=0 spamscore=0 clxscore=1015 suspectscore=0
 adultscore=0 mlxlogscore=999 impostorscore=0 phishscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108070166
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 8/8/21 12:58 AM, Joe Perches wrote:
> [Please note: This e-mail is from an EXTERNAL e-mail address]
>
> On Sat, 2021-08-07 at 23:38 +0800, Jun Miao wrote:
>> It's "must not", not "musn't", meaning "shall not".
>> Let's fix that.
>>
>> Suggested-by: Joe Perches <joe@perches.com>
>> Signed-off-by: Jun Miao <jun.miao@windriver.com>
>> ---
>>   drivers/atm/horizon.c | 6 +++---
>>   1 file changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/atm/horizon.c b/drivers/atm/horizon.c
>> index 4f2951cbe69c..9ee494bc5c51 100644
>> --- a/drivers/atm/horizon.c
>> +++ b/drivers/atm/horizon.c
>> @@ -2167,10 +2167,10 @@ static int hrz_open (struct atm_vcc *atm_vcc)
>>
>>
>>     // Part of the job is done by atm_pcr_goal which gives us a PCR
>>     // specification which says: EITHER grab the maximum available PCR
>> -  // (and perhaps a lower bound which we musn't pass), OR grab this
>> +  // (and perhaps a lower bound which we mustn't pass), OR grab this
> I meant to suggest you change the patch to use "must not" not
> the commit message.

Please ignore this e-mail. Sorry, confuse the mailing list.

I am so careless to forget change there. After this 2 minutest, i send 
new  same V2(in fact should v3 but forgive for a freshman)

>>     // amount, rounding down if you have to (and perhaps a lower bound
>> -  // which we musn't pass) OR grab this amount, rounding up if you
>> -  // have to (and perhaps an upper bound which we musn't pass). If any
>> +  // which we mustn't pass) OR grab this amount, rounding up if you
>> +  // have to (and perhaps an upper bound which we mustn't pass). If any
>>     // bounds ARE passed we fail. Note that rounding is only rounding to
>>     // match device limitations, we do not round down to satisfy
>>     // bandwidth availability even if this would not violate any given
>
