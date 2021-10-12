Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E67242AE34
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 22:51:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234541AbhJLUxv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 16:53:51 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:59440 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230467AbhJLUxu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Oct 2021 16:53:50 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.1.2/8.16.1.2) with SMTP id 19CJHWC8024190;
        Tue, 12 Oct 2021 13:51:35 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=OL9o3S0IdToJY6iKhasSF8/6QOfzHtdlrOKDmjq5z1U=;
 b=a6dj1O3vZQR/lm++LDLRowMvT7sKPnEmow4S2eIHsISE6sfGuunBsVy/849Cm1VhgnHX
 +9Gld3YuP2fWyVnU3OCGixyTu76DycP52oEDpBQuBVTMyRDT+oD6y3x24IjDGW1geHkF
 ERpJuTTV1i1Dv7zwYZBIQ27y/K4JJUvW73Q= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net with ESMTP id 3bngct0m69-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 12 Oct 2021 13:51:35 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.230) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Tue, 12 Oct 2021 13:51:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kIK2HVpwVdb6A2wmR4Bq2OQXVyOK5nOhSmeXKx9R84EPZDdFxwQW3wjptQHVwVcDVEC/EVobcpx4ar5+1uq/uXsCwINojZk7YDR2vOd4/X/4ZqFRguhKIPN9PdZQCH+xLbT8dzHF9zCD3Ua25o0ZFBJNNB+dq6uws2Tvas4+7KHQv88iv6832hsR/Na5KT9jUM932mPngTN7F68MCPyabkXDkGJ4Uw//M7kSSyM+mSGI9a9Uu3K/pqT5p4QgOHgIHRRF+ZV99ejVwNp03t+DLkYapex+UUxRTSCoXvCsdnELQE9tCZdKsAwmNynFnGyfszMXLQur5f0ZWg9+IALxug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OL9o3S0IdToJY6iKhasSF8/6QOfzHtdlrOKDmjq5z1U=;
 b=WZyj1z4WqXfpVnNP9KeW6xrooK5fLXUqRLLY3LE2qvryMA0A/Ue6m0xy/AQh9v9ciN9RqhsBb7tUS2B06OKILPz3BY/iXjgsUlsz1e8+EZrF6Gd/Me0Um8B6ivwedbhgKwAJpjT0nqCABLGeUqO4vXH+YldJ0NSwUsAKMeEBuPirp2rT0l2RGZ2EVHqmFX4ZDFpUYJUjFlSX1UMT3VWtY5Ljp4yfz9xc9ETzVpgp6EKr5FBpIfuDdYPvezKUprE8tGKVX/M2VY8+H+SD9oCHlOuFR00aGAdq++QNXMgH8snAiDja5fMPmSRUTBWNPHTZOgKpp+24mKSbrxfG9Z9mqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=fb.com;
Received: from SA1PR15MB4465.namprd15.prod.outlook.com (2603:10b6:806:194::23)
 by SN6PR15MB2509.namprd15.prod.outlook.com (2603:10b6:805:1a::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18; Tue, 12 Oct
 2021 20:51:33 +0000
Received: from SA1PR15MB4465.namprd15.prod.outlook.com
 ([fe80::2413:3993:2f20:c304]) by SA1PR15MB4465.namprd15.prod.outlook.com
 ([fe80::2413:3993:2f20:c304%6]) with mapi id 15.20.4587.026; Tue, 12 Oct 2021
 20:51:33 +0000
Message-ID: <531ae597-f749-fcea-68c5-d3e2fa80d083@fb.com>
Date:   Tue, 12 Oct 2021 13:51:30 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.2.0
Subject: Re: [PATCH bpf-next v2 0/3] Add XDP support for bpf_load_hdr_opt
Content-Language: en-US
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Martin KaFai Lau <kafai@fb.com>
CC:     Daniel Borkmann <daniel@iogearbox.net>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <Kernel-team@fb.com>
References: <20211006230543.3928580-1-joannekoong@fb.com>
 <87h7dsnbh5.fsf@toke.dk> <9f8c195c-9c03-b398-2803-386c7af99748@fb.com>
 <43bfb0fe-5476-c62c-51f2-a83da9fef659@iogearbox.net>
 <20211007235203.uksujks57djohg3p@kafai-mbp> <87lf33jh04.fsf@toke.dk>
 <20211011184333.sb7zjdsty7gmtlvl@kafai-mbp> <87v922gwnw.fsf@toke.dk>
From:   Joanne Koong <joannekoong@fb.com>
In-Reply-To: <87v922gwnw.fsf@toke.dk>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MWHPR08CA0053.namprd08.prod.outlook.com
 (2603:10b6:300:c0::27) To SA1PR15MB4465.namprd15.prod.outlook.com
 (2603:10b6:806:194::23)
MIME-Version: 1.0
Received: from [IPV6:2620:10d:c085:21e1::1a1e] (2620:10d:c090:400::5:7eb) by MWHPR08CA0053.namprd08.prod.outlook.com (2603:10b6:300:c0::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18 via Frontend Transport; Tue, 12 Oct 2021 20:51:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: eaef91b0-7ee8-4c1b-b6db-08d98dc21336
X-MS-TrafficTypeDiagnostic: SN6PR15MB2509:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR15MB2509430AB8B7B9CF93B34013D2B69@SN6PR15MB2509.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ay4q9QtYJaQH3PjOk1Sih2LSCH02n4/STQQ8dqXoFI/+aBSeJIEYEDDSAVahXZydQNhFJmop6BgeHMV8PNo/3WkqADGj1L3Mwq/7VhDy7gXS4x0o18R1EdIOI8DcIHeLXbmEdy6abcYhLT9HPOReLcPAtzEx99OlDrQGrniLl5X5iBaxvKqGhfrfwyCkO1wtMBZvJjn9R155nHtgoYAUg5rw94yyqTjU5jYCZLaDTc+7RQPeqUazU5+XK8yZBKfs1a7+ieSLdIoWKaW0oMnZbrhWc+Dd3B6HuhEhwHCwzUzKw+zhvnEa+SKwDTlSng9+ORL4XARxllB0R8rx4u68JdOpvgEU1TDPMxORbD59P1QCPjPQJkP39UXNuLIhhA6zg+UWzufczwuRAolzGjki8nAB0Arx8vnLuMqncJNGvqod4ueaOiLKeSaQNXYHMj4SXPV3EPicYzRmzugL/fcw6qnhVw6SbdltmqR5HTB64oXUmOJiZo80QfhFlq7PMctTUTbKjtfiS8Bc54s9PzTVMv+PdpxptTUpx2VVHJUQHZb1w33t/mP25O+L0fSjI8AGkJNNdXLYgiBBK61Dwz96n18qX8Gw4ZPOt9xRWO7hoay02Kqo0lrE72meFMUeX3iktsJo7d19uJrHoGjZjC2lcermrlPqkevVeHr3L06i1B5Od4NBjwdZXAUm7eP660iSIJzEn1oBXCkVBiv123lBPJpRo7tMasTriZYnwT893PM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB4465.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66946007)(5660300002)(86362001)(31696002)(110136005)(4744005)(4326008)(66574015)(2616005)(66556008)(31686004)(316002)(66476007)(36756003)(53546011)(2906002)(6636002)(8676002)(38100700002)(508600001)(8936002)(186003)(6486002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SmxGbm5tMG5wSFlLZGM0d3kzdFVJQjZnd3QzZ2xRZGtZWm9kRGdtRUtZSWhG?=
 =?utf-8?B?UjdMQWQyQlBtdU4xb1BJeHBWTW80cHU2Yis0YjM5M0VHSC9yTmFpdkpEQ3FG?=
 =?utf-8?B?TWJBdmJMNmpHdE8vK2VPQ3pnNndqWk1meHBvNkZsWHl2alg3T3BScmNLYk5n?=
 =?utf-8?B?UktxYUw2UDNrNW1VVmdBK1psVHkyYk1BeGtrUXZOendsUFJEZXBtaFQ1S3pO?=
 =?utf-8?B?TDhVanQ0eE03c21jMWR5NTk5WTlCKzFRdDVQNUhYU083TjNsMnlaeDQ5MlEw?=
 =?utf-8?B?dWVOdjI5bjJZTHYvN0MrcFBYbEJzY3BTUFBLQUtyUmhHTXo3OHB3ODBINEpN?=
 =?utf-8?B?OHZRM25UQnQyVmhqbEFQNm5YbWsxditKWHNEd21LNk8rNTc1THluTXJZM1V0?=
 =?utf-8?B?Tm5QdHpQVldidSs2dzRaeTRzOUVqYlhseVRnRzIvM2lPL1dYQ0h1SEZsd01C?=
 =?utf-8?B?QjAraHY1K2o0K3U2SzlQejg2VUx1OFczY3p4U1NNV0JNUktxZ3QvaVBIQlc3?=
 =?utf-8?B?cVQ3eWpROTlhaUliMkJ4TmpqTmpwRFJjSjl4aUlLZUp0RzFzdjdMbVkxN3NX?=
 =?utf-8?B?ZUpMV09wZ0JtQWx5NS9WTmltUUk4c0dwQUlNa3B6dVNjWG4yY2YxQTJIOFM4?=
 =?utf-8?B?T3NjUEZKbG1nWTRlM05SZ0FPa1NQN3NTci9KSjdEYm44b3JZVHRpU3YyN1dw?=
 =?utf-8?B?U3AwUWUrZXUwVTZXTjFEalk3S1grQ1lDeHhiTU1wekpCajQ4c09lUGI5dlBE?=
 =?utf-8?B?K3lSSXB1Q3I4RWpHelE5d1Jhcjloc3Q0T05pK05SQm9icjdnZmQwTlVhUzNK?=
 =?utf-8?B?cUVVYlFDenE2VVpXTGg5bktNQ2l5U2cvNk9rUVozQ01FSnZidXo2aGoybEx0?=
 =?utf-8?B?cnhndnhwYUhyV1RxdGtGcTZrWXI0OUc1R256ekVpTGNXTExtTmlmWFFQaFc4?=
 =?utf-8?B?RE1rMElpNnc1cHNLVndkZTNMV05vMlU3NEMza29WeHRxYjM5SVpDektyRDJ0?=
 =?utf-8?B?T0xxVm5RRGdMWFJEMTBrOE9ERlJISHdFRDBld082NlM3YlJNODFWaVpCYXdK?=
 =?utf-8?B?VnUzSTQzTHBSd1QwQWY4eXlXdUxjcmYvOWFTRWFDQ0UzSWpEaXlvU2J4anZp?=
 =?utf-8?B?d1JQZjEwWlpJQ2dLWjBXZVFUc1F4OGFTczlNZm50SE9ENHBiM3MwMGtNMVpQ?=
 =?utf-8?B?aGdtdTRCZzZoT21sODk2WFJ0ZXBKRGE5NElaanRVdUxXdlpCRXRVZEJUaEow?=
 =?utf-8?B?ZFhsOEIyT2VBQW4vVHJVTkthOWw5Q09mSkJHTlJ1WlVPMU5keVR3MW03SnI2?=
 =?utf-8?B?NG53b2o3M1M2ODJlL2tEQklMeGtzS2NDSlF2cW9XTS9YRU9mMkpScnBRcW52?=
 =?utf-8?B?MjRZbGQzcldJLzA4UWZCR0hXbTkwVWlhWDBNMEV5VDg4ejdseUVvekwwRkdk?=
 =?utf-8?B?UXhDSkV2Q1dxYi9CT0E3YmVzdzY2OXJ5OE9GUGlWQ0VRQmxiS3JUZm1Ybkhv?=
 =?utf-8?B?eHg2SWFIdmp1MGxqa3BwWnhXRFhQanhPbDhsU2NkbG9xNmdQL2Z0L0dIeE42?=
 =?utf-8?B?dG1YR05JR2hZRlNEeGFENjR5cnFnb01hbTJDbVU5SGw4dVBiWWNmQk53b0hy?=
 =?utf-8?B?Smh6ZUpmODFzdDhpWDBGc2o3ZVdtYmVkVk9oNEY1S0hGSUNRKzZRY3dxOVFP?=
 =?utf-8?B?RDFuMmZKeVg3Z0hrUVM0UE9vYUZrV0tYZ3JDN0U2eThnaytYYURDMW12M2o4?=
 =?utf-8?B?QjYrbWhxbE0xUHFpSndWY2NkSURkUnBUZlBVa2xuVjlFWEM0Y0lBdHRBc1p5?=
 =?utf-8?B?OVRpNmcxMHpKSDIrd2dNdz09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: eaef91b0-7ee8-4c1b-b6db-08d98dc21336
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB4465.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Oct 2021 20:51:33.7271
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sCTp277w9FTJhWNznsqNBjRY2ZUu6DA86nacTOUmMCfdlzzlpEUvEVCnIAEmIqZVDAdo4ngmT3UlrcmLEwvlxw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR15MB2509
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: nvD7Lwr9yVaDBgmLncgG3nP1E8iGcD7a
X-Proofpoint-ORIG-GUID: nvD7Lwr9yVaDBgmLncgG3nP1E8iGcD7a
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-12_05,2021-10-12_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1011
 phishscore=0 spamscore=0 mlxlogscore=999 priorityscore=1501 bulkscore=0
 lowpriorityscore=0 mlxscore=0 suspectscore=0 adultscore=0 impostorscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110120110
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/12/21 7:11 AM, Toke Høiland-Jørgensen wrote:

> Martin KaFai Lau <kafai@fb.com> writes:
>> On Sat, Oct 09, 2021 at 12:20:27AM +0200, Toke Høiland-Jørgensen wrote:
>> [...] 
>> I don't mind to go with the for_each helper.  However, with another
>> thought, if it needs to call a function in the loop anyway, I think
>> it could also be done in bpf by putting a global function in a loop.
>> Need to try and double check.
> Hmm, that would be interesting if possible!
>
> -Toke
>
Martin and I tried this out. When we moved out the logic for parsing the
options into a global non-inlined function, the verifier approved the
program.

As such, I will abandon this patchset and submit a new separate patch
that will add a test to ensure we're always able to parse header options
through a global function.

Thanks for the conversation on this, Toke, Martin, and Daniel!

