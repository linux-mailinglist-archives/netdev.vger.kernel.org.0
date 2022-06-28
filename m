Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17A7755EA97
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 19:05:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231343AbiF1REB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 13:04:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231214AbiF1RDt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 13:03:49 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45CEA11A13;
        Tue, 28 Jun 2022 10:03:48 -0700 (PDT)
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25SEdmg2031352;
        Tue, 28 Jun 2022 10:03:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=bHDFu8VXUdm9WiUBC74LtlnbSm4fT0xrve1qxTkczfc=;
 b=n4VTvLaJdxEavJbfpa69x0TEULZ/7PlV44YiqnvSY1jIoF9Yi9JWLa2luQfrMZ3WONFt
 eXmoFO16VQP7eOQCEgt6q6we2B5DS8hhIazsMpVmM/VBnqmlKr4J/ujPKimqn0w1hcVb
 HW0pfLVKreNpwwJRvKdPKhgC27+wDHHXIdk= 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3h03kf1a1n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Jun 2022 10:03:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nhwVdK4rdyEslw/dCCT355caLxwfVBWxGED2ILuPKI9qzjcqQ4GkMWy0xA+qO5AoEHGY9DveUof1lrejHVB8cXAbEMQpNAg/6PJZEx/6y5y88UEbRSv4GAP/mxRX6hU5eQVwzQ+AAZOw61y3IoqJnC0P2DT+UsKadYD07i3yHTEtNpCCSDsjt31rNEYKb3mLwhsvcAlfQfTRFTeclWTR38GvdZWdAKXNXXkODiHpo9fBu609vCSJmde/x5bC6y5fiNqXvp0wbNsc25VebIl69yRFklHJFBQ22maMFMhcN+xXiEcul4SpTnS8KdkwD1Iz10zZEg6UpTpL1I23JIULww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bHDFu8VXUdm9WiUBC74LtlnbSm4fT0xrve1qxTkczfc=;
 b=gPbNrhp/Li/IEHSW8P//NKLxy7v4Pe0OPJdGne07pAVRSICn6VBtOCgp+w3yOzeQraep3yqP5B7fgs41lQGDcXGKXsPeAoRJ5T23bo0YFwcAEDw3RpB9yjQTnEdTgvk1tOyzlqK0bRyk0QSGffTc6RMUNzArJYMlxuqvCP3m7DkARGo5A7108RUcLY8PiPpwNFIrXi8dHXNN05tOJrKHmfyj9ZC6Kmbx1UEg933MidgpZ0xyRHU+1XjadJ8zDhM8itXGDviRnAI6t5HxBUlMaSVToEX0CDILtmQYte85aDixNWSmIMNoKKGDm9ycULV2ZZtUjdC2fWQqM23uSrmWYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by BYAPR15MB3350.namprd15.prod.outlook.com (2603:10b6:a03:109::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.18; Tue, 28 Jun
 2022 17:03:23 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::9568:e5d9:b8ab:bb23]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::9568:e5d9:b8ab:bb23%6]) with mapi id 15.20.5373.018; Tue, 28 Jun 2022
 17:03:23 +0000
Message-ID: <17b7e938-914a-b431-c389-ddaf3ad45aae@fb.com>
Date:   Tue, 28 Jun 2022 10:03:19 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.10.0
Subject: Re: [PATCH bpf-next v2 4/8] bpf: Introduce cgroup iter
Content-Language: en-US
To:     Yosry Ahmed <yosryahmed@google.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Hao Luo <haoluo@google.com>,
        Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Shuah Khan <shuah@kernel.org>,
        Michal Hocko <mhocko@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        David Rientjes <rientjes@google.com>,
        Stanislav Fomichev <sdf@google.com>,
        Greg Thelen <gthelen@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>
References: <20220610194435.2268290-1-yosryahmed@google.com>
 <20220610194435.2268290-5-yosryahmed@google.com>
 <40114462-d5e2-ab07-7af9-5e60180027f9@fb.com>
 <CAJD7tkaeR=QFRqq4B-abyYRrJ0p4FB9aDg7ESNvo9GS2KMS-4w@mail.gmail.com>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <CAJD7tkaeR=QFRqq4B-abyYRrJ0p4FB9aDg7ESNvo9GS2KMS-4w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR04CA0014.namprd04.prod.outlook.com
 (2603:10b6:a03:217::19) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c81e0195-f0d8-4155-32d7-08da59281c18
X-MS-TrafficTypeDiagnostic: BYAPR15MB3350:EE_
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Pd51aLHaCw8mPZBJ9r14uKtnZKkgAooY+R2/dQHhqtnnjk8m0X/eUWx+hV0ZgmDItag+JfVV6erjrukbcBqFpJKf/ceXdAbAjT6UY/OlZ5Q924cU/51AyPdk6Og0k+2qGBViIkTfZYiCPMQskI6QYvjB4T+HypiPpZ024m2C2pIepIQYMegqfchvJxbZfMklq4hDEIhWDhCjShGCsIP5VI9DefDDIdyzOvKUjuizJDVg+c7ZsUiwQriP5OdReNyG0S9PllJMuffx34gGj7R7u0WZemzrxGayXIYXM1+1KsRYcpMAlznFnN3aYWbVYTA5AdwTESTdOduWiOttIVFMu+qPOb85yY5Z+1BmhXhbPrh/gg3cMCtl4uTJGm7M2CkmU4d/bikh84gH5eaaVn7X8BNhDO6A4tfpLF5eqpQcXMRGPKiz+8Wriey9yRlDKTUwMvUkiQLqhDSoJt/FqWNuD28ROyKBXpjCajqVlN02kkpd0Z7yYrOM5Mx4Gp0RyivmuWDXPkxcPDU9epF7R4MswzWracEICHVUdlO8DY7kwPNzCx3XENtVsz5eTULyJz/QkM5YDt6AiVoM/lFtt+G3FT1yIss/IADNp3S5xqN43KvuiMyDb34eg2CGujmuqUgh0hZdRtwfSJugW1NPjtgDDD3F9h8SrFgrvFd+Rja5Ys6k0bxos+WgRSm7iVWImigCd7Izf+jSNXJpD1uKroByhwCvRbkTU1iQzT2dlppzmnuNlH6TWuFUErw3ztiqGLtYcZjnIJCrxpjnbiU2XVLdDeseIupiv4+wLSXSuHH5CV4KGGu+uNDHBlSIidxZiUSZ7pnZirfNPlWjRE65aRQjFg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(376002)(396003)(346002)(366004)(39860400002)(83380400001)(6512007)(53546011)(7416002)(41300700001)(478600001)(31686004)(36756003)(6916009)(6486002)(6666004)(6506007)(2616005)(2906002)(66946007)(66476007)(186003)(66556008)(8676002)(86362001)(316002)(38100700002)(8936002)(31696002)(4326008)(54906003)(5660300002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WU5FaFdCQXhKekltdytiTjlVdnU4cXIxSzlYeGFreWd0QitKR0daN2gwUG1B?=
 =?utf-8?B?Y2UvaS9NTENiSTNNUVhDNWZqVU5XZ1RoUDQ3V1MrRXJqblRqV051czZvbGtV?=
 =?utf-8?B?R0hrQ1pGaWx2QndYalZWaFk3b09VaHVtY1hkRXhCbmJVN2dzS1JDbU83STlQ?=
 =?utf-8?B?OUZLdzdIaG5ySTBBY0tjMEwyQ09YNFNBTXBVck4xeVlIa2tzNkIrdGFtWld0?=
 =?utf-8?B?T3hVbjNWM2dhSXlhS2FsdkNza01PbzJpYWpGeXZoRElkZUI2TklST2NuWFFP?=
 =?utf-8?B?U0FsL3ZlYVBtbUF5dHJueWR4QXN5TUJwbXpkTllsS2NJc09oa0FldytsT0FM?=
 =?utf-8?B?MEVhcCt6a2lZZVY5aHcrTGZLQkxON3gvUlVhWnl0MmJGeUJBUmI1ZU15alVE?=
 =?utf-8?B?bjhPaGpPRS8vTVFXWFNsMGxMS2tFVE9MM2xoTFk2TUsrZCticnM2N1ZkL0hs?=
 =?utf-8?B?aHl1L2Q1OHBzNTJFcHBIUFFwdUVyQTJIOTlEVGgxQW9KQitmTkp3SzFEVDVq?=
 =?utf-8?B?RHB4OFF6ejg4M3ZXazUzZEM2c1RBc29UWFJmN2xwTXU2QVBuZTV5UTV0cWNr?=
 =?utf-8?B?dDQ4bEdhaG9NcElTZldTQmxiRkw4ZW10ZFZiRTlLVDZZSVpOb0FNMXU0Y1FN?=
 =?utf-8?B?bVltM0l2VUlIdFY4WmRTZGZ4aWc1NVo0ZVJtdzBWd1dLQWxUWTlGajVDc29l?=
 =?utf-8?B?RHRhejJEMytLR3BneFdqdktCZWhhM0p2bUpLaWVXTFp4cDk2ays5TmhvbWR6?=
 =?utf-8?B?ZTlPSFRBdnBBamVhd3BnY0pjcllPRXd1SE5JbUdMbHZabGZacHMwc283Rkkx?=
 =?utf-8?B?T3FZZEYwZWNiUWtRREFOR1JrVGtYbmxFcHF2Z0RiUXl3c0ZQREdkNHlkV0hT?=
 =?utf-8?B?dEZXNGdudkN5SThvMlExa09rc3RMU1hkOE44SHh6ZW5SL0tFS1RTWUFENE9Y?=
 =?utf-8?B?R0hBeCtyTEdickVjU3RzSmcwemVGNFhTS2VMSHpTdDIyaVNzWFl3RjMxVWFq?=
 =?utf-8?B?bzB5b1BlV1VFMU9OOUJVekxOOFlnZWlWb2E1Qi9qV0ZmbTAvRitoNmdIRnJ1?=
 =?utf-8?B?YnFYZ2RkNzFsSGwzUDA1ZnI0V3ZsNkhKclJpdVVMNVJGaUZDajVYTkVOZy9y?=
 =?utf-8?B?SGhMTkt0S1FpRzJNNkhJR25UU1RDdm11bTYwVndjaFNUSnpUMnBRV3hrdlQ2?=
 =?utf-8?B?eGZIdlRyOFdaS1pyb2NjRkVud25Say9sNTIxdUFTa3p0Z2xwbm9ubGRCZWgv?=
 =?utf-8?B?cEFGNGkzQ3BNT1VEeUdJaVFkbkNiR0lDcWRkRWRRNzUzSzJITldWKzlFUWJm?=
 =?utf-8?B?cFZZcmVMTDRtVXREQldOa3NaTCtnd2N0LzJObGRiSVE4dlZFTXBLZGNuNHZo?=
 =?utf-8?B?bzFSOFBFdzFuZ25idVJKUXBxZm13cXF4dUlvUmhlWjNNZGZMNENqSTRiVXdZ?=
 =?utf-8?B?VjJXdGovSHNUSUx3UmFpeHNiNDRPUzZvMStkNENhUHRhR2VSL0pTK2hYMmo2?=
 =?utf-8?B?UjJ6TldiUEc1dTQwMXkvWmNzQ2orQytRMTJPbjg1SGwyaTBNbmxsNWhPWUtG?=
 =?utf-8?B?aXFYcXZMWUxpVG5HSCtqblQySHRBaStiMDFmckpBaVFEOGRRdTBEdVQveUFD?=
 =?utf-8?B?YlovOTIwQktpM2p2dFh1MGlrc1M3ZTB5TmkyNk4yODZNZWJORkY0Y1NkbjYr?=
 =?utf-8?B?S3l1OGZBNXByTDkxOXRTQzdJV2hnYXBzZ3R4UEVBNzZQMkJnWmxGUjBzeURk?=
 =?utf-8?B?ZFJJaUM0cGdTcmpycEVYVWxieXZCNzhhUTdsVDY5K1EwSmkrTEdkbmkzUUFW?=
 =?utf-8?B?bTNQd3FVWWhwNXMxZEZqd0hFOXdkdGtNYjN4dmMrbVlXdHd5UTlOZEhpeks1?=
 =?utf-8?B?d3JDcU1OUSsxWnBTQVhiQXlyUE5oTC9LSDUzSm9TbDB0SDBXOHBON0R4b0N0?=
 =?utf-8?B?bkRNTGRsTU5sRzR4UnM4cjFTZmx1Ly9DVFJZc0VYUkxKMjFrU0ExRHcxSGR2?=
 =?utf-8?B?d2pxeDFlcEFNTEdhSllDVkZMUE8yTnNOYXgzc2syUzJ2L2xWUHJMRmV0aWdJ?=
 =?utf-8?B?SWNENThxdSs4UU4rMzNkTGtjM0tDdEdEMXFGbnl5TlVzVUJOdTdsRlRUK2Uw?=
 =?utf-8?Q?pNy0lGZUWns/0rgmEZ+UvaVC7?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c81e0195-f0d8-4155-32d7-08da59281c18
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2022 17:03:23.3758
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ckae2kTtpeldqUSKT/W+Oh7LHUywLzc4L9rOugnbz2aor78nBFjAdZti3uY+ywX6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3350
X-Proofpoint-GUID: -SXhphCbmCuoR4gjqQnguqzBGWoJ5cuD
X-Proofpoint-ORIG-GUID: -SXhphCbmCuoR4gjqQnguqzBGWoJ5cuD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-28_09,2022-06-28_01,2022-06-22_01
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/27/22 11:03 PM, Yosry Ahmed wrote:
> On Mon, Jun 27, 2022 at 9:14 PM Yonghong Song <yhs@fb.com> wrote:
>>
>>
>>
>> On 6/10/22 12:44 PM, Yosry Ahmed wrote:
>>> From: Hao Luo <haoluo@google.com>
>>>
>>> Cgroup_iter is a type of bpf_iter. It walks over cgroups in two modes:
>>>
>>>    - walking a cgroup's descendants.
>>>    - walking a cgroup's ancestors.
>>>
>>> When attaching cgroup_iter, one can set a cgroup to the iter_link
>>> created from attaching. This cgroup is passed as a file descriptor and
>>> serves as the starting point of the walk. If no cgroup is specified,
>>> the starting point will be the root cgroup.
>>>
>>> For walking descendants, one can specify the order: either pre-order or
>>> post-order. For walking ancestors, the walk starts at the specified
>>> cgroup and ends at the root.
>>>
>>> One can also terminate the walk early by returning 1 from the iter
>>> program.
>>>
>>> Note that because walking cgroup hierarchy holds cgroup_mutex, the iter
>>> program is called with cgroup_mutex held.
>>>
>>> Signed-off-by: Hao Luo <haoluo@google.com>
>>> Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
>>> ---
>>>    include/linux/bpf.h            |   8 ++
>>>    include/uapi/linux/bpf.h       |  21 +++
>>>    kernel/bpf/Makefile            |   2 +-
>>>    kernel/bpf/cgroup_iter.c       | 235 +++++++++++++++++++++++++++++++++
>>>    tools/include/uapi/linux/bpf.h |  21 +++
>>>    5 files changed, 286 insertions(+), 1 deletion(-)
>>>    create mode 100644 kernel/bpf/cgroup_iter.c
>>>
>>> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
>>> index 8e6092d0ea956..48d8e836b9748 100644
>>> --- a/include/linux/bpf.h
>>> +++ b/include/linux/bpf.h
>>> @@ -44,6 +44,7 @@ struct kobject;
>>>    struct mem_cgroup;
>>>    struct module;
>>>    struct bpf_func_state;
>>> +struct cgroup;
>>>
>>>    extern struct idr btf_idr;
>>>    extern spinlock_t btf_idr_lock;
>>> @@ -1590,7 +1591,14 @@ int bpf_obj_get_user(const char __user *pathname, int flags);
>>>        int __init bpf_iter_ ## target(args) { return 0; }
>>>
>>>    struct bpf_iter_aux_info {
>>> +     /* for map_elem iter */
>>>        struct bpf_map *map;
>>> +
>>> +     /* for cgroup iter */
>>> +     struct {
>>> +             struct cgroup *start; /* starting cgroup */
>>> +             int order;
>>> +     } cgroup;
>>>    };
>>>
>> [...]
>>> +
>>> +static void *cgroup_iter_seq_start(struct seq_file *seq, loff_t *pos)
>>> +{
>>> +     struct cgroup_iter_priv *p = seq->private;
>>> +
>>> +     mutex_lock(&cgroup_mutex);
>>> +
>>> +     /* support only one session */
>>> +     if (*pos > 0)
>>> +             return NULL;
>>> +
>>> +     ++*pos;
>>> +     p->terminate = false;
>>> +     if (p->order == BPF_ITER_CGROUP_PRE)
>>> +             return css_next_descendant_pre(NULL, p->start_css);
>>> +     else if (p->order == BPF_ITER_CGROUP_POST)
>>> +             return css_next_descendant_post(NULL, p->start_css);
>>> +     else /* BPF_ITER_CGROUP_PARENT_UP */
>>> +             return p->start_css;
>>> +}
>>> +
>>> +static int __cgroup_iter_seq_show(struct seq_file *seq,
>>> +                               struct cgroup_subsys_state *css, int in_stop);
>>> +
>>> +static void cgroup_iter_seq_stop(struct seq_file *seq, void *v)
>>> +{
>>> +     /* pass NULL to the prog for post-processing */
>>> +     if (!v)
>>> +             __cgroup_iter_seq_show(seq, NULL, true);
>>> +     mutex_unlock(&cgroup_mutex);
>>> +}
>>> +
>>> +static void *cgroup_iter_seq_next(struct seq_file *seq, void *v, loff_t *pos)
>>> +{
>>> +     struct cgroup_subsys_state *curr = (struct cgroup_subsys_state *)v;
>>> +     struct cgroup_iter_priv *p = seq->private;
>>> +
>>> +     ++*pos;
>>> +     if (p->terminate)
>>> +             return NULL;
>>> +
>>> +     if (p->order == BPF_ITER_CGROUP_PRE)
>>> +             return css_next_descendant_pre(curr, p->start_css);
>>> +     else if (p->order == BPF_ITER_CGROUP_POST)
>>> +             return css_next_descendant_post(curr, p->start_css);
>>> +     else
>>> +             return curr->parent;
>>> +}
>>> +
>>> +static int __cgroup_iter_seq_show(struct seq_file *seq,
>>> +                               struct cgroup_subsys_state *css, int in_stop)
>>> +{
>>> +     struct cgroup_iter_priv *p = seq->private;
>>> +     struct bpf_iter__cgroup ctx;
>>> +     struct bpf_iter_meta meta;
>>> +     struct bpf_prog *prog;
>>> +     int ret = 0;
>>> +
>>> +     /* cgroup is dead, skip this element */
>>> +     if (css && cgroup_is_dead(css->cgroup))
>>> +             return 0;
>>> +
>>> +     ctx.meta = &meta;
>>> +     ctx.cgroup = css ? css->cgroup : NULL;
>>> +     meta.seq = seq;
>>> +     prog = bpf_iter_get_info(&meta, in_stop);
>>> +     if (prog)
>>> +             ret = bpf_iter_run_prog(prog, &ctx);
>>
>> Do we need to do anything special to ensure bpf program gets
>> up-to-date stat from ctx.cgroup?
> 
> Later patches in the series add cgroup_flush_rstat() kfunc which
> flushes cgroup stats that use rstat (e.g. memcg stats). It can be
> called directly from the bpf program if needed.
> 
> It would be better to leave this to the bpf program, it's an
> unnecessary toll to flush the stats for any cgroup_iter program, that
> could be not accessing stats, or stats that are not maintained using
> rstat.

Okay, this should work.

> 
>>
>>> +
>>> +     /* if prog returns > 0, terminate after this element. */
>>> +     if (ret != 0)
>>> +             p->terminate = true;
>>> +
>>> +     return 0;
>>> +}
>>> +
>> [...]
