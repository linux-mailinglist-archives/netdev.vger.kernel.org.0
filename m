Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E24234A89D0
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 18:21:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240314AbiBCRUw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 12:20:52 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:23052 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1352827AbiBCRPx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 12:15:53 -0500
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 213H4wRx006351;
        Thu, 3 Feb 2022 17:14:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=TMXY3P8kkzZJ3J4Ei5fCX0A5/mzdsFl85OYYgWgiVgU=;
 b=I2UzzmhMd6RPjW4QA30rbIxYMHIufBXKND2ofgxi1afbKcRBJbtpFvkwQaJpTcWu7xh0
 wOCkb8NuUYcB/HDZw1ew5pCTl1fvWehy69vG7wZdYukRt6rspLDU6nk4hHH06kpi33ed
 vbdFjCpoLerkok+JGp43sl/AFPC25kX5gkJfZbEMr59jMSpz5BgT7gAYylcc7299Xthw
 tASK8oxuqlJpNXkn5lvkzuzFiO0rRBPtXNAWDHxDEJJzlxZSjd7qmmTxAwtigDRXpZhm
 HRudZRknZSLoz9xovBqYw/XUsPQL03CMOAVd+kcFn7DB0moDEDnGD92MLKUDcwMl75TV jg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e0hfsrc2k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Feb 2022 17:14:56 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 213H5mAZ195463;
        Thu, 3 Feb 2022 17:14:54 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2105.outbound.protection.outlook.com [104.47.58.105])
        by aserp3030.oracle.com with ESMTP id 3dvumky35x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Feb 2022 17:14:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=etGQ9vXrkSmyHY/kfMApD6NKnCx8wWdchuJRzQff2jcHXYi4gSn15No/sq0uU6lCDAl95LToaU4ycGjqLIqwweGwPDtxDcBltiFQFR7hQlzvyejS+08oHChOMMnGC5WQkpl7LdKBTuhbvb/6kXjyD9gHKileYJGGE+jk43y+cWh+BiQb6VTTZdKhTV2sKMCFTHJCwLAV78f1ic0im31OonfkHvhyhFIvc/NdsGjE+4iz3RvbZLtuqhZ1bveLcDUbeGra2Uivy4Yh+sIBbdCsGvmP+tTjRMoa2sXn8bj198O3+io/qkfQ5LXuQnhF9k6V80VPXTC/H8PeiHpQSJoWOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TMXY3P8kkzZJ3J4Ei5fCX0A5/mzdsFl85OYYgWgiVgU=;
 b=nJkEN4pXHHhM9T7vafVG8pD5jlqy01S+vxQlmIHziWmfqdoY4S7Qlr+VVNSbLnxHiZNWp5tNKGooRLBEiCwI+0CxxOSuA7dv/Q94f3DO9VBJVW+j96KbWaB+jJt8XE4N4P1jX7JrGLadAFL+lqcdtM6zBbGOeWOCQKcWNw4k/ENo8DGaR6jITzIclSOHzE4/zN+KdElJwyMO6o5Ud/5MMbGCRKTQRE1tx5YM6wD0xM08RGBaexX1FT78+CstnO/fQAhNYEcwq9Rvpoytl2/AeoEYXBstn+I1ibzQMxfVzuJVg/pM/QtIQS65QzfY7SjdV8aihiSzVL9Zew4NTIi+0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TMXY3P8kkzZJ3J4Ei5fCX0A5/mzdsFl85OYYgWgiVgU=;
 b=ip765Mz9f7JKbdVcTewdQ7NTVJL6L3Aq66YxoQ5iw8qFT9dPGMrRTP8dpQGsVXPanRnqzwnCSdrBJxfr7ohBgviSTZjG9ayLNENTymn4+5ostWbsJymvEBjMoU9b8k5FvwTxSLRhvTlWRcXx8i4tyRNipyd/zUjwT2j1GDj9DP8=
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by DM6PR10MB3132.namprd10.prod.outlook.com (2603:10b6:5:1af::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.19; Thu, 3 Feb
 2022 17:14:53 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::60be:11d2:239:dcef]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::60be:11d2:239:dcef%7]) with mapi id 15.20.4930.021; Thu, 3 Feb 2022
 17:14:53 +0000
Subject: Re: [PATCH RFC 1/4] net: skb: use line number to trace dropped skb
To:     Eric Dumazet <edumazet@google.com>
Cc:     netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Menglong Dong <imagedong@tencent.com>,
        Joao Martins <joao.m.martins@oracle.com>, joe.jin@oracle.com
References: <20220203153731.8992-1-dongli.zhang@oracle.com>
 <20220203153731.8992-2-dongli.zhang@oracle.com>
 <CANn89iLB-zmM1YTn4mjikMLhZwQ6fQUAHeCBznLuvE=gB2R-sg@mail.gmail.com>
From:   Dongli Zhang <dongli.zhang@oracle.com>
Message-ID: <3234b5dc-9a96-1786-96eb-a319d2359358@oracle.com>
Date:   Thu, 3 Feb 2022 09:14:50 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
In-Reply-To: <CANn89iLB-zmM1YTn4mjikMLhZwQ6fQUAHeCBznLuvE=gB2R-sg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA0PR11CA0093.namprd11.prod.outlook.com
 (2603:10b6:806:d1::8) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d9158c35-1053-445c-11e1-08d9e738b146
X-MS-TrafficTypeDiagnostic: DM6PR10MB3132:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB313207E057C7DFC9EE0EC3D3F0289@DM6PR10MB3132.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:397;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: keTfJCDbuk+QUBjbf3An2G6hxD7zwqL1MeL63spirDX3G2GijjW9WzIWZDBQb07VjWVXvuUnpB3LC5UQjtF9vIUZ2scowDE0BTEgH/4rakHkHe2vCjBXbamt4mpktgE4MfxcUKfrZmMOj6jAmv/jyht9z49Lxr/FVudebvjkZ7R/8T9TAro0SNKruInHWWQItCj3QoQQ+n+p6EfX0gcbk7T7kEx21S+nRl66TcazUYKGRvmfBc/9L8ep9IZlNjhOdK3fhNnk1chPavEjGZigjUsSgrC3zOIrxfwIdhKoc/1nXE6ORbqxxgGbzRiS8dMo644G3xhqJUlfumuZ+ZcecUlp8Z8WERL6dmdlUnfihPhx4/8QINF/9taqOA0d2Mek4n0mvsszYFWZcaMnylzk+7N2DeZmq2v9ejccGkouDx9rfHHjJsw0178yluR4c64GLf+0PY6F2A+mGLmxe4RgroWOoeaNev633InNXbLngrvS67EyrTfxNvL/mp6apT1h7ozqiXuyY4ElrUHryV6SaO2R8qxXa28BqSvcI1qT1GxBRmxpc0PxeDo6LMPvm+JY4hDM4rnUX2lQiTgUWiz/zpdLPSx4/EWrC1Qn5oPn6F2nxKMxQWrllPdI1Od/gbJXs1nfrjXopg/X2YBgiGJJ6+kkVJU0hCpSa8SD0RwEGCQ2cu7hH4kgCGg8EMtVOYLs1GJ9KuskxQy0poAykNlJKOnPMlYwlpxEZrLjUcvRZh5IxLfpS6vWA/HR4d5orBLW
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(2616005)(107886003)(6916009)(508600001)(38100700002)(7416002)(186003)(2906002)(316002)(31696002)(83380400001)(36756003)(6486002)(5660300002)(66946007)(66476007)(44832011)(4326008)(31686004)(6506007)(8676002)(6512007)(66556008)(53546011)(86362001)(8936002)(54906003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WjJsbDNKckU2T2xaZlRSRnpaMlZwN0ZKNklOc3UyMGNtL2FJemNiY2lseEk1?=
 =?utf-8?B?cjJKM3h6dk40bVFTVmRVblFJTkJEbzlPVFZPd1BEYVE1YTZwTjAvNkZEYkNh?=
 =?utf-8?B?Nk9SNjB5ZDRKbFdvMHIyTmZtUlp3d2V4T1d3dldZRFBWTEZoNUwwNFJvRDR2?=
 =?utf-8?B?dHdibm9lekFqVm1Zbis3a3c1T2Z3N2tnZ3BNWjJWZGEwQzhvdXRUdkN3N0pL?=
 =?utf-8?B?N1Y0Y0tTQ0lGOHRVWENLRWRSczArdG9JS1hlWE9ua21UVStialJiWFZMTldI?=
 =?utf-8?B?U2ZpRkdIaFVNbXNrR2lYREFFZlJqOHRnWmdvcVc4NkkwcThaL3JsRjV3WEFz?=
 =?utf-8?B?dmhLcnNLMFBpTGMrekpqT0t0akcxWlhkeElLY0FxdTQrWTluQjVKb3BYZllr?=
 =?utf-8?B?ZHpRaFhpSGdsU002MnBrbE43ZGhlY3BLb3JvYVJlcjdtMmZaelFVamFsb2Ri?=
 =?utf-8?B?VUszd05BVndsc2FUZWFKbzg4SzN3OVQzVUJZZ1hEampjcHZUaFl2NnEyZFVO?=
 =?utf-8?B?S3lHU2lDTFJWUnMrQ25pTGZseW1wSUZ6NkFGdFJKSDUwVEs1VEYxSnhucWx6?=
 =?utf-8?B?QzFkbzN4aTNTV281dzIxNEZocDdmMzZaSW1GTmtyeFRnRXBwY29rYVBSQ2hi?=
 =?utf-8?B?cXpaT0lBWkxrUDRxQk0yUUZ1SnFpeExDMmhrMVdwZHFPdWtoajlwOVkvUXdx?=
 =?utf-8?B?UHdyb0JTQU90OHJ5cVNXYmEvMzllbkx6Um8vMW5lNWNkMm4rL2N3aXJqajlT?=
 =?utf-8?B?WElldC9rOG54NzJxbGZCem8vbVVzT1BtZzNXTWZydFNQODhRR2NSM2lHcGln?=
 =?utf-8?B?Q3EydTJCeWxRYzRuM1EwUFpHS25JamR5R255UlhUZUN5UUE5cEtzZWJ0eUFk?=
 =?utf-8?B?bGphT2gwNG95b0RCQWVZMWR5KzRWa3NJRTk3UkhrL25vd2J0cHUyTXhDQjRr?=
 =?utf-8?B?SDJ1TEZTR0owVXJIdzdCWjFRVGEvSFh3Z2ZWeFMvV0xLc2RwZHJ1K2k3Wktm?=
 =?utf-8?B?bTc5cXl6cktNOElDNFYrSUxEY2t6VDhaR3BNbkprWGtGL0ErZTl2ZitiRFhh?=
 =?utf-8?B?ODNTMlRUK3NxZGM3eDNYY2ZIT2dHVFJyOWZMdGErZ3RCTlhxQ3NlY2hFQkxx?=
 =?utf-8?B?SWEvZjZRUDAzbmVMamNzTzEzczBGajVxc0hkQXlJSXJsTEM3K3E2WkY4NDRX?=
 =?utf-8?B?TlArNUdpaFAxOC9QMUh6MC9yTGtBMi82cE5RZlc0bVc1MzE3SjNTSXJqSDRE?=
 =?utf-8?B?WjRzTDkyb1pOWHZiUmxHWUZ4QWViMlN1WStYc2VLVERNSlZFZXFBTnExbHJz?=
 =?utf-8?B?cTVaajA1SmVmT1FnRmRBQTlOTEN6MzFRVjIxS2FNS3pzbDZTdmdSVkFPV2hU?=
 =?utf-8?B?eUx0TElYaTNmc1dEWjdNaWlYOEQwQ1ppSlZDVURNdTBuOXpXYlloazNVZVpH?=
 =?utf-8?B?S0FSYmdvb09XZ0N0Tjh0UmtYTjJ6djZLbHJrcldCSi9QU0xjTDVCT1A3VEhH?=
 =?utf-8?B?Zm1aSnN1SDA4R2xYWW9jK3Viak5jNEgvaUlKZ2VqeURGdXVDSzhVY094YWwr?=
 =?utf-8?B?OVl6c0pyaVBnWnJOcmFGdlhiQ0U5TXduZnZEdURKVmF1SUh1TndXaVlZK053?=
 =?utf-8?B?c3dNcEt4eUR6aEhLN3RodWxPUitYWHA3Nk9oQmJ6b2VsY3E3SWEzbVdkbWd1?=
 =?utf-8?B?YVFnaHN5RGZla2kvY2d0dEgwbllkNGw3UFFVeTM4TEV6cVBqTXFhTm5sTGZV?=
 =?utf-8?B?eHpFOVVpZGNhTGRTUTNVMk1ObEZSZVhFc2JCbi9kWEhmekYrT29uRzc2blE5?=
 =?utf-8?B?WXZoeDFlejIwMEE5ZHdMVjIwSUwzbHhqSGJKd0VBbGNuaWJ1dTV6TnFiNHBX?=
 =?utf-8?B?Snc3cUlGZlZYQUxGSlRtdk0zR0ViVExqQ3VQOTlVUzJ3YVYzTk1ZaHNXY1hP?=
 =?utf-8?B?emRucmR4dDJUM3RhZy84aU1xRU1RRjllbHREa1pHM25VSWp0UzcrNzlEMkNO?=
 =?utf-8?B?Z2wvdjhhQjBxazZTSTZIeklUWUd2Z0p3czRxWXA1Vkg3NnBRclNRS245U1lY?=
 =?utf-8?B?RlpuM1g2SzlicDlDQXl0bGxEaUFKL1F0T2FSS3Z4VjhTVUJESkhqU1poZmZL?=
 =?utf-8?B?NHJhbk4xeTBkSXIyRnpsc3gzQTN0Z3RpaTR2TnFLM3B1cTBpMWFNS0NHL0ZF?=
 =?utf-8?B?TjdNK3ZhNFByQWIwMzgzZ1ZvREVNN2UrRVA2Y0l0RVlTVVU1SkNBejhPb0Fh?=
 =?utf-8?B?M2R4dXpUMUx4ZndLWWVBMmY5eHh3PT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d9158c35-1053-445c-11e1-08d9e738b146
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2022 17:14:52.9698
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tRKj3I+vOvQWDEE824bQdsfVIjSeht14C3qG2JIU3Y1r68QuTovdNEKrBzorakN3a3ntanGFM4MqsBq6cBQIrg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3132
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10247 signatures=673430
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 phishscore=0
 mlxscore=0 adultscore=0 suspectscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202030104
X-Proofpoint-GUID: MQh6Ry4uaWk5N44lFJ20qBICRpdY8-bH
X-Proofpoint-ORIG-GUID: MQh6Ry4uaWk5N44lFJ20qBICRpdY8-bH
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Eric,

On 2/3/22 7:59 AM, Eric Dumazet wrote:
> On Thu, Feb 3, 2022 at 7:38 AM Dongli Zhang <dongli.zhang@oracle.com> wrote:
>>
>> Sometimes the kernel may not directly call kfree_skb() to drop the sk_buff.
>> Instead, it "goto drop" and call kfree_skb() at 'drop'. This make it
>> difficult to track the reason that the sk_buff is dropped.
>>
>> The commit c504e5c2f964 ("net: skb: introduce kfree_skb_reason()") has
>> introduced the kfree_skb_reason() to help track the reason. However, we may
>> need to define many reasons for each driver/subsystem.
>>
>> To avoid introducing so many new reasons, this is to use line number
>> ("__LINE__") to trace where the sk_buff is dropped. As a result, the reason
>> will be generated automatically.
>>
>> Cc: Joao Martins <joao.m.martins@oracle.com>
>> Cc: Joe Jin <joe.jin@oracle.com>
>> Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
>> ---
>>  include/linux/skbuff.h     | 21 ++++-----------------
>>  include/trace/events/skb.h | 35 ++++++-----------------------------
>>  net/core/dev.c             |  2 +-
>>  net/core/skbuff.c          |  9 ++++-----
>>  net/ipv4/tcp_ipv4.c        | 14 +++++++-------
>>  net/ipv4/udp.c             | 14 +++++++-------
>>  6 files changed, 29 insertions(+), 66 deletions(-)
>>
>> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
>> index 8a636e678902..471268a4a497 100644
>> --- a/include/linux/skbuff.h
>> +++ b/include/linux/skbuff.h
>> @@ -307,21 +307,8 @@ struct sk_buff_head {
>>
>>  struct sk_buff;
>>
>> -/* The reason of skb drop, which is used in kfree_skb_reason().
>> - * en...maybe they should be splited by group?
>> - *
>> - * Each item here should also be in 'TRACE_SKB_DROP_REASON', which is
>> - * used to translate the reason to string.
>> - */
>> -enum skb_drop_reason {
>> -       SKB_DROP_REASON_NOT_SPECIFIED,
>> -       SKB_DROP_REASON_NO_SOCKET,
>> -       SKB_DROP_REASON_PKT_TOO_SMALL,
>> -       SKB_DROP_REASON_TCP_CSUM,
>> -       SKB_DROP_REASON_SOCKET_FILTER,
>> -       SKB_DROP_REASON_UDP_CSUM,
>> -       SKB_DROP_REASON_MAX,
>> -};
> 
> 
> Seriously, we have to stop messing with things like that.
> 
> Your patch comes too late, another approach has been taken.
> 
> Please continue this effort by providing patches that improve things,
> instead of throwing away effort already done.

Thank you very much for the suggestion!

I will introduce new reasons to TUN and TAP drivers, in order to track the
dropped sk_buff.

Dongli Zhang

> 
> I say no to this patch.
> 
