Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F1603E3D4A
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 02:02:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232435AbhHIACR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Aug 2021 20:02:17 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:16148 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229903AbhHIACQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Aug 2021 20:02:16 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 178NsjDP022379;
        Sun, 8 Aug 2021 17:01:41 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=tX7ndVwz77R9XR7sZ8euhFAHXC2GR1N8gCiS84rLnbg=;
 b=dc/mQnQMBhrKTXkXQHHVYKfW4KWxHkVkc+UZ9HxEPt4A5VrQepfduvDhZiRhJ//oahtV
 K2KhW6BkhanDl/VX5uHPbTkLWc/XIoE28yrgWD3K4m3Hh4y7ETZJqLpHAiYLiu0aFilC
 vBJDRB/Vio/IsHh2V0oS9nNS4rmznSJFEBg= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3a9p7ne0db-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sun, 08 Aug 2021 17:01:41 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.228) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Sun, 8 Aug 2021 17:01:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gERi3HDjrX0zZIEZ3Q1XDds2Vm4jfx/IF6Q60IfC61fvZ71QWoPQDFgkx8b+JwWY7KXSBWXbHa9QeRQG/POyDEN3WQ/jwmj6t/b69g/AsXiPVgr/+b7vtmtDc3PkWNLBvKNrV1SAsjIuI0S61pzSx22fWaWm235fniKTqBk7fmRm2zfuVXz1fSwmUj3WzYK7KOWNEDi2u4FlpBYVHMgL2kdh+G9bx1JtuLOvmG4gGWfQqFah0da4dEtmnkb92ZVSOXu+Z8C4a2qqpJ3cSyU8mBYioS1LxyzPClDplVoBmC5/2iXr7nGhmUbX1xnLxfcoiby6q9yjl8AQn/zB1TGUDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tX7ndVwz77R9XR7sZ8euhFAHXC2GR1N8gCiS84rLnbg=;
 b=L5fh3ZQrMXGHUn8TvIex0y86nHcj0YyR7YKLvUyk4bqAZSJ8UHzOfxap0JasDKYOIvc2LRrLJuTS3PRvV3ElDesJ/U3V1xgRL/dFJT6o13QIfVziAt1RxEvxmkYhWs9ubtrSRbp/NSxFb9u2bZvdMrgx/mhSPkvm0neX1zEv+cYXEcbG+Fi8CD7s6nDUF+rtGokBp4HqS2m8gPr39ZfL1coj9acMnoARxmCnKY3HxCvdqjTq4GJpWrJuj7dMpankgPcsov0efEyYSI8Dv8WSKO/d1pVRZ+JTPrMuw5xuDrQ+aKz3P9gpcFWP+rnsZEiW34UegswQA+BpZ0oPSryNpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA1PR15MB4386.namprd15.prod.outlook.com (2603:10b6:806:191::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15; Mon, 9 Aug
 2021 00:01:32 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::c143:fac2:85b4:14cb]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::c143:fac2:85b4:14cb%7]) with mapi id 15.20.4394.022; Mon, 9 Aug 2021
 00:01:32 +0000
Subject: Re: [PATCH] samples: bpf: xdp1: remove duplicate code to find
 protocol
To:     Muhammad Falak Reyaz <falakreyaz@gmail.com>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, <bpf@vger.kernel.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        KP Singh <kpsingh@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        open list <linux-kernel@vger.kernel.org>
References: <20210808122411.10980-1-falakreyaz@gmail.com>
 <be9121ef-cea7-d3f9-b1cf-edd9e4e1a756@fb.com>
 <CAOmbKqkYDXvMQntk39Ud-63G3ju+Kti2A8UFNodgJ6y1+4=AeA@mail.gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <4c897a6a-6f5e-b990-7c36-4258a26e1752@fb.com>
Date:   Sun, 8 Aug 2021 17:01:29 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
In-Reply-To: <CAOmbKqkYDXvMQntk39Ud-63G3ju+Kti2A8UFNodgJ6y1+4=AeA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0167.namprd03.prod.outlook.com
 (2603:10b6:a03:338::22) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21c1::10d4] (2620:10d:c090:400::5:bbaa) by SJ0PR03CA0167.namprd03.prod.outlook.com (2603:10b6:a03:338::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.17 via Frontend Transport; Mon, 9 Aug 2021 00:01:31 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 60c8f012-263c-43e5-6686-08d95ac8d846
X-MS-TrafficTypeDiagnostic: SA1PR15MB4386:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA1PR15MB43869D63338FD63825EE88AFD3F69@SA1PR15MB4386.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wznPYjX1T62pX3Z1K5bfCTuYjyTVvXx6u7uM7NMWG6lln09PBatw4csMAfC2cSKlfmrjyL7ojqy4Uy3jXLJR+heHtXXdKSDm0b3F9IRCXhCDFp/bfZnq1oDIRQzpux+cgT+WTkWXTCUokp11QkH8Qj0qCI/mxQzy83BeJCV3JncD33sGxG4GkYuKXGfSCv00hCi4WJvi/2Z8VYU5ugtMEdDDJAU97opHvT/z0W+E+CSc7IUBhofcHhBA4xvmiAe/0mL4NUbjDDz53ohyPo20jKKYaYG9j7KPRTXB3q2/3nBFB10Td7qDy9WKcWlcXqUr1R4h4KrWyIA1T6VSv/OxHd9IOLF61VBTdfvWZOthniOdA7nKDAh+C74yVntc/7IhyWoiSVD2uSc1GwRxs/wnNuUrC2mCFw6xNV+zQtIrAn9FyV6UqKNq1TIYO0Brmc7suBsCSAcLyyamQQcKNczMPgt4HMTfVCSlwiU+JEe5rHxlxt0/Tjxuzrw6t3AI4TUb4u0AeVZQ+Cm3Ppitxt1HVxC92ry2Mztoi77DNqMiNYv4gke6nI3pUPEqL8f6tFCOzTOMIuY8jnAaSHLT21653NWvXvlZArh5EPLltPwcFAaSLzII9/XeZypxvQKqiuYQ0+ALvtQYcVt02jk5wxHEctlN7UwJ8Z+AEeUIAnvEMZTA621XLvFF8qAncUyB5Gs9yy+9xvfk/fzHsiUgxCViC5fRztOBZ78Hlk5RF2AaLuJbT//UEHyRQbSNBHM8s0ab
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(366004)(396003)(376002)(39860400002)(66556008)(38100700002)(53546011)(52116002)(66476007)(5660300002)(66946007)(6486002)(2906002)(186003)(83380400001)(36756003)(6916009)(8676002)(478600001)(2616005)(8936002)(54906003)(31686004)(4326008)(7416002)(316002)(86362001)(31696002)(37363002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RUZoRmJZM202QTRRMEF4WUxZeWo0QmgxS0NTRXB3U1ZrcDk1bENCcDMwVnE5?=
 =?utf-8?B?Z3J4QmtCdlZJS3Y3aDdYVEcwaytueXdIRkdYd2wrdVhHY0dOVUEySDM1Wlls?=
 =?utf-8?B?eFVNZGZVOEJhRWJ4NERrNFM4WVFOQkhiVjdJWmZoRFM5VjdWSGdJWlkvcWRM?=
 =?utf-8?B?UGY5NGZyam9reGF2Ulh0NmRqelBKZkE3SG5HdzdKeUl0UnVmOC9QWHo2dUVS?=
 =?utf-8?B?UHd6L3JFOC9CSkdCY1U0SCtHb3YvVml4RUZzSTcvRUNOaE5yaXhhNzhNbDJq?=
 =?utf-8?B?NGVHN3BIeitENm5PSVhkSzltcThMZlcrUGpHc0x2OS9SZEVVN1NjNDk5Q1kv?=
 =?utf-8?B?VnJYTEd5WlF1ZWx2QTQwOHNwQUJYaG1zSnBYc2tRN1lENWFGQmN4Wk1YN1lI?=
 =?utf-8?B?ZHQydGtIK3VNS3lFTWwzSW5wZmk0WW43bUFWaGJQOFA2S0ZaNVBXWGRWWjZE?=
 =?utf-8?B?Vk1wQ1BmQjVIamJWS3NKaVlUSnBPWXZvYXBjRm1EblZnSVpyazZtY3RGUDNW?=
 =?utf-8?B?N0FMN0JQa3N1NlpYb1VJRnlRcmhsTERxSFRrdVZuYVJoM1ZzaFlNTUowR3FX?=
 =?utf-8?B?RXdjMXlzSXR1Vy9iRFoxbEFPcjhDT1ZIYkc1MmY5REJGc3c3WVhWNHZ3T1hp?=
 =?utf-8?B?TXh4ODU0QUFPZDdaUDVyblpZaVptZmF0SVBNWmlMenBUak1PSlJmSWM3YmVS?=
 =?utf-8?B?azUxZ2pPdkpFbWQ2bFpHUm9RWU4wSGRzbVVSeUp1YWVORU11SFBzckhVUFZ3?=
 =?utf-8?B?RlZDbzNhTHk2UWNZM1ppQWUrYXY0d1l3dE9jc2RXdnZ6Y1hrMmViZGw0clE0?=
 =?utf-8?B?SmZubC9LRnVnWTUxOUl6T3BkN0NOT1hvclA5MzlmR2xlK1NCbmJvVFRWdUs5?=
 =?utf-8?B?K3poMTRsR3ZMRGs5M0VDVlRoQXdTd0c5aWNkTGEzLzNKd0NQOUduanBXTHhl?=
 =?utf-8?B?Z0ZNMkF2RlFXZzFDUUdvWnZLdUQyWHRvZ3k5NlU3ZE1iLzJ3Y3R6eWdrbjYr?=
 =?utf-8?B?VkJoazkrZmJNNml4RHNLbDlhQ0p6VnE5U2MxbForK3Q0ZU83cXhTVXJaNlgw?=
 =?utf-8?B?N00vS1B2dTZmN2tGaFFyM1gvR2xWdFlicVFtYUJYbFVuSGFYTUpHWUxabUlD?=
 =?utf-8?B?U2o5Y2p3VC9la1hNb1crNVovMDRLcHpYcC9TdjFKK3J3bHBKakpTY3loY1lh?=
 =?utf-8?B?MCtFem5uNGFHaXJuSGJJdWQ2dllhZ0Q4VzQzSXpaV1NOWnlMRkhlY3lVNjdn?=
 =?utf-8?B?bnA3a1MvQ0xnYjFuc2VaZVRld1NjZ2NHUnZiWUFzZDRyZXpSUlNWbXFydEdC?=
 =?utf-8?B?cDVSNVpXT0Jyd0wrM1lSMXpubFpKcGVzc205ZFVmWjA2RkJoOUVhY2syOWxR?=
 =?utf-8?B?VWMwc1dYcmNGZkhtWGIxQXljSmt4YmZ6RC9Lc0d5RFExSmpGbmoyZkVoMFpk?=
 =?utf-8?B?UVRab3pDTDB5ZzBZU2p2MTFuQVl4QmdxR2N2eU10bjBHazNjdjIzcE1QR0x2?=
 =?utf-8?B?REV1Yno2MXJ0c3RVY1JQaHlhL0RVQWxWNjRqa1VVaTRpbXFPSkw5QkxoN2hU?=
 =?utf-8?B?NVAyaG5qNFhlN2NnMW5aMXdSTGhXQ3RyRGhYOVJHNVVuMGFuQUgzL21iUXZB?=
 =?utf-8?B?NWg4NmhxTzBzYmJVUVJTNlp3VlZGL3dUR2E4dUhmRmh4YWYraWJTRHRPVlQ4?=
 =?utf-8?B?RUdVZ05ta0Z5a0ZZeTNkbWhCNTZYQXE0T25oaWxxVzVQTnhiYklOTEFnbUlp?=
 =?utf-8?B?akVpbHV2YlEySUYvUWlaMjltdDBYY25CQ1pBR3RxZnFULzBRZzd6L2pXcC9z?=
 =?utf-8?B?NGFVdEtyeGNTU3ZIQ2pvQT09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 60c8f012-263c-43e5-6686-08d95ac8d846
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2021 00:01:31.9826
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 62xyU90/UTV97h//o0tp41OxtIAxMd/ffM/+VTbS5f3ygkYbRtnRrn5ZXQR/dtVR
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4386
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: rHKEH-ASB-Tw4fnpd76DCSziQO7e1pqT
X-Proofpoint-ORIG-GUID: rHKEH-ASB-Tw4fnpd76DCSziQO7e1pqT
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-08_08:2021-08-06,2021-08-08 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0 clxscore=1015
 adultscore=0 mlxscore=0 mlxlogscore=999 impostorscore=0 suspectscore=0
 lowpriorityscore=0 phishscore=0 priorityscore=1501 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108080155
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/8/21 10:19 AM, Muhammad Falak Reyaz wrote:
> On Sun, Aug 8, 2021 at 10:23 PM Yonghong Song <yhs@fb.com> wrote:
>>
>>
>>
>> On 8/8/21 5:24 AM, Muhammad Falak R Wani wrote:
>>> The code to find h_vlan_encapsulated_proto is duplicated.
>>> Remove the extra block.
>>>
>>> Signed-off-by: Muhammad Falak R Wani <falakreyaz@gmail.com>
>>> ---
>>>    samples/bpf/xdp1_kern.c | 9 ---------
>>>    1 file changed, 9 deletions(-)
>>>
>>> diff --git a/samples/bpf/xdp1_kern.c b/samples/bpf/xdp1_kern.c
>>> index 34b64394ed9c..a35e064d7726 100644
>>> --- a/samples/bpf/xdp1_kern.c
>>> +++ b/samples/bpf/xdp1_kern.c
>>> @@ -57,15 +57,6 @@ int xdp_prog1(struct xdp_md *ctx)
>>>
>>>        h_proto = eth->h_proto;
>>>
>>> -     if (h_proto == htons(ETH_P_8021Q) || h_proto == htons(ETH_P_8021AD)) {
>>> -             struct vlan_hdr *vhdr;
>>> -
>>> -             vhdr = data + nh_off;
>>> -             nh_off += sizeof(struct vlan_hdr);
>>> -             if (data + nh_off > data_end)
>>> -                     return rc;
>>> -             h_proto = vhdr->h_vlan_encapsulated_proto;
>>
>> No. This is not a duplicate. The h_proto in the above line will be used
>> in the below "if" condition.
>>
>>> -     }
>>>        if (h_proto == htons(ETH_P_8021Q) || h_proto == htons(ETH_P_8021AD)) {
>>>                struct vlan_hdr *vhdr;
>>>
>>>
> Apologies :(
> I now realize, it could be double vlan encapsulated.
> Would it make sense to add an explicit comment for newbies like me ?
> I can send a patch, if it is okay.

This is not the first time people sending a patch trying to remove this
"duplicated" code. I think it is okay to send a patch with comments to 
say this is intended to handle nested vlan, so we can save everybody's 
time. Thanks.

> 
> -mfrw
> 
