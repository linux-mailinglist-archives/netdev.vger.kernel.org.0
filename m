Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D74E31BD4A5
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 08:30:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726539AbgD2GaU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 02:30:20 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:11048 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726158AbgD2GaT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 02:30:19 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03T6L5Wq011984;
        Tue, 28 Apr 2020 23:30:08 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=iwfhqVUSWABZ150UXD4bxXL9QyK1HGdTF+6kl86xTKM=;
 b=F3UXVJabAUHwg7LeEtBrRJJBTXIc9XuoDx8JUcBcUhEVRJuwn0xSQ9FYhJJEOfjPc1Cv
 bVf1nhURtrrB04uWshQcD8YMOZKxqo+90h5JOE2ETxRLVOatXmt3D6tgWhaJ3a3w5x8m
 D31C60apMFyZ9/CW2WsTb58p7zM7QmA7PtA= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 30nq5409jn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 28 Apr 2020 23:30:08 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Tue, 28 Apr 2020 23:30:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SfTJVfU4GvlwRWMN2qjiDOMTiuixhoW/tMQiotTqaqtOz94n5bmf9OFaEJrDWalueO1HmDllOHeiC4vo1oFR3Q8JyEnOoDUTvvkd8uQAT2qj3yHjgkFZs/rHQMPiPLFz4IwUqwTfrJzlkQKEkH0u+thqUJnov1uWY8k9l8p7kvXPm86E0dkytoCweTPGeP0eAJbgZeNXfBS9JyM2aGY4oc5kV+qSa/JQqrTGmJOuBh3/d0E9EBkC24ySw5nP1KeksABB1R2Ym6/x4kCQdl7D4DCA/YpT8WGLdKH7zaOQaN02Moa/4+iuwKEnjPIieln/k1RUVQ2W1MBL0gqK7bfKew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iwfhqVUSWABZ150UXD4bxXL9QyK1HGdTF+6kl86xTKM=;
 b=FuJTKf4raCD+B/BVkE2tAwqlnqak3eET/xDuATJYBM77EK4Y/xxmEY59aGXEWtv91N5j/xsAfzU9lXiaIvcYFRwA98b/IDkpSNVubeYDGuWXkA5nX3zyLJ42rHHoFutUA1yQXYSaCFWQO0oLIonoF2WO/mqY8z6kHU8U2yWm+w9dL6ys4O20p17AH+5NW5mknAKHoo1Zmw3/OeIcLxs90P29vmJd73kX/jnUm04QNWfhtS7g4+vxpavh6S/psxfsYZc38xL5ExPAGRnX3MrxmS2/UERNdHrJnyNacIBS0p+Q9DkLolZ94R/AYvSjjbplSx8VhvXBIDY4VJU80vVXZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iwfhqVUSWABZ150UXD4bxXL9QyK1HGdTF+6kl86xTKM=;
 b=cl45do9cu+aWeZhZB1whJEkC39vjCbeA2KDl6ckFA1JDNvLiBNegOrbSGOaccEudozz2gJwTQur3c6MZjzCZLI7N6kGmvvqkKO1anv6R6GG0t5kpIlwKvE6EqTU2dIenOdiRMmNDHofZxc4nRHRVDSYn09GMxaWrX+y5ZFHJqlg=
Received: from MW3PR15MB3772.namprd15.prod.outlook.com (2603:10b6:303:4c::14)
 by MW3PR15MB3916.namprd15.prod.outlook.com (2603:10b6:303:48::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.22; Wed, 29 Apr
 2020 06:30:06 +0000
Received: from MW3PR15MB3772.namprd15.prod.outlook.com
 ([fe80::3032:6927:d600:772a]) by MW3PR15MB3772.namprd15.prod.outlook.com
 ([fe80::3032:6927:d600:772a%7]) with mapi id 15.20.2937.023; Wed, 29 Apr 2020
 06:30:05 +0000
Subject: Re: [PATCH bpf-next v1 03/19] bpf: add bpf_map iterator
To:     Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     Martin KaFai Lau <kafai@fb.com>, Andrii Nakryiko <andriin@fb.com>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
References: <20200427201235.2994549-1-yhs@fb.com>
 <20200427201237.2994794-1-yhs@fb.com>
 <20200429003738.pv4flhdaxpg66wiv@kafai-mbp>
 <3df31c9a-2df7-d76a-5e54-b2cd48692883@fb.com>
 <a5255338-94e8-3f4b-518e-e7f7146f69f2@fb.com>
 <65a83b48-3965-5ae9-fafd-3e8836b03d2c@fb.com>
 <7f15274d-46dd-f43f-575e-26a40032f900@fb.com>
 <CAEf4BzaCVZem4O9eR9gBTO5c+PHy5zE8BdLD2Aa-PCLHC4ywRg@mail.gmail.com>
 <401b5bd2-dc43-4465-1232-34428a1b3e4e@fb.com>
From:   Alexei Starovoitov <ast@fb.com>
Message-ID: <f9a3590f-1fd3-2151-5b52-4e7ddc0da934@fb.com>
Date:   Tue, 28 Apr 2020 23:30:03 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.6.0
In-Reply-To: <401b5bd2-dc43-4465-1232-34428a1b3e4e@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MW2PR16CA0007.namprd16.prod.outlook.com (2603:10b6:907::20)
 To MW3PR15MB3772.namprd15.prod.outlook.com (2603:10b6:303:4c::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21e8::11b6] (2620:10d:c090:400::5:562d) by MW2PR16CA0007.namprd16.prod.outlook.com (2603:10b6:907::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13 via Frontend Transport; Wed, 29 Apr 2020 06:30:04 +0000
X-Originating-IP: [2620:10d:c090:400::5:562d]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8cd6aac8-780d-4794-11fb-08d7ec06c160
X-MS-TrafficTypeDiagnostic: MW3PR15MB3916:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MW3PR15MB3916EBD34C9CD4BA2B856F7DD7AD0@MW3PR15MB3916.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 03883BD916
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR15MB3772.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(39860400002)(376002)(396003)(136003)(346002)(366004)(86362001)(5660300002)(53546011)(186003)(31686004)(8936002)(31696002)(8676002)(316002)(478600001)(110136005)(54906003)(2616005)(36756003)(4326008)(52116002)(16526019)(6486002)(66556008)(2906002)(66476007)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: o8iydekwGXHtqBAjNPn610V2ELYM08Nj/LhcuQ4bKuvaSieu8XhjSn9pE4vK9ntSpW2lqAKXP8W66HGjTZy6VaQQv43Mqmj4OExgAx3hi5bG87Q6hvOndPBTB2EzROWGDXIz+nSzEbNNYR8AcnJ+P5dNOkVyirisBoHwsTYp/rBmVh0yC9x/2sHXZ0CWSqj3TZGMAbQQYFkWrPIx+s+a2h57mMzzc4V4eERKm+OXKasuMf/YKr7+xDQc/SooEQJuRNLGIvPVxo9KBwMCesDFXx6v1sb2AxbQvFoBHwxfj0Yz4uioeG/DJ6MF6QJO+ZO60IQM34yj4ZXE0x/rn6KYRYeHCThFmvnRb6ESWTZNJBiBS50CVKs+Gqx63/41v1jHSTQ5QoJCNGDbr44WWAPTsL5MIOK8z6oO3mpuwWkaJ5+plA7sQQ7tQCb72FOLCBAP
X-MS-Exchange-AntiSpam-MessageData: CvOGWWfQ6mP7ot4d47jh7rW0jeTwKNFrTzxwGfYAfIxqOpfVfgc5WufrnJFWUvVf8yrDNzOwyaVWCN3xIFb4q7rLP/Hs7uhp0jMI7xLyrEU8BJ284F0tsAO+uSetrgtar0mRftUh4LdzQS3pZxnZFd5XE5QwcfQ9ylBFZirCvOKYRugPuc60OkyjiajYP5xtJTXbcZsDhF5bXTHHKd9ddkZ2pfrIftG6JiVfmauf4kfrfiIp5ju1rYVQ+0HAW+q+e9515HWZO0PHh0HDhwDXlujHRBCgJXz9JsJAXjT8rcSBZWGcuW4PzWfM/LYnUaaHluifExIJfqccgw2B39qULlf6i/0HGttgVvAtjmrRCZNxmjcz2+hxLgJ3WHvVtk1Y115fxANMhnKcCYcRJgH8Mhoe1vI1Mu0mX25gNZSteEQ1iQFPNOvzc1dgu6c3vtE8Bxw8Itk/bzJkxxipo956hWQvBlfEkkkIm+w4ww6+IdxYShi9DrtomH9v8RcKBgzp8Tylh+aMWYApFM2dGdxOI00mVZw3PZkY9sf919bvSnPp7Wxp1qeKrWcoHj73WYLggIpxZlxfcetDhC7bvrgmsWQz7DfQuJdzw9jL6G/7gPHaUhc0TQjrYr2gXN3EGYhKwpgbLhAr4Tog891VG/Yd0Yk/Yxu93AiGqzxahhVIE1UgwqdXq814QmZVtyUvJHWm8rEd4jRvTaN2S5o9a29kcw+uHt3/1Ga8WPOoWyw0xpyopm/Z1fQHHSxORq1ux7dt9MRw36E4VtStMSl3rdj4aK6zw/RVkY3CozyanW4lHyqCxBcT5jMQU5pu8y7xo3qDyhQ7wqMIyOIbH+J3yDbZ3A==
X-MS-Exchange-CrossTenant-Network-Message-Id: 8cd6aac8-780d-4794-11fb-08d7ec06c160
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2020 06:30:05.6523
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lYZSzx9WodYcX6iHjRcq2jK0MwgBp4oy9IxT/mqhkrGT3OS5OVey8tB06XrUsQdC
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB3916
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-29_01:2020-04-28,2020-04-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 spamscore=0 lowpriorityscore=0 suspectscore=0 impostorscore=0
 priorityscore=1501 phishscore=0 bulkscore=0 malwarescore=0 adultscore=0
 mlxscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004290051
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/28/20 11:20 PM, Yonghong Song wrote:
> 
> 
> On 4/28/20 11:08 PM, Andrii Nakryiko wrote:
>> On Tue, Apr 28, 2020 at 10:10 PM Yonghong Song <yhs@fb.com> wrote:
>>>
>>>
>>>
>>> On 4/28/20 7:44 PM, Alexei Starovoitov wrote:
>>>> On 4/28/20 6:15 PM, Yonghong Song wrote:
>>>>>
>>>>>
>>>>> On 4/28/20 5:48 PM, Alexei Starovoitov wrote:
>>>>>> On 4/28/20 5:37 PM, Martin KaFai Lau wrote:
>>>>>>>> +    prog = bpf_iter_get_prog(seq, sizeof(struct
>>>>>>>> bpf_iter_seq_map_info),
>>>>>>>> +                 &meta.session_id, &meta.seq_num,
>>>>>>>> +                 v == (void *)0);
>>>>>>>   From looking at seq_file.c, when will show() be called with "v ==
>>>>>>> NULL"?
>>>>>>>
>>>>>>
>>>>>> that v == NULL here and the whole verifier change just to allow 
>>>>>> NULL...
>>>>>> may be use seq_num as an indicator of the last elem instead?
>>>>>> Like seq_num with upper bit set to indicate that it's last?
>>>>>
>>>>> We could. But then verifier won't have an easy way to verify that.
>>>>> For example, the above is expected:
>>>>>
>>>>>        int prog(struct bpf_map *map, u64 seq_num) {
>>>>>           if (seq_num >> 63)
>>>>>             return 0;
>>>>>           ... map->id ...
>>>>>           ... map->user_cnt ...
>>>>>        }
>>>>>
>>>>> But if user writes
>>>>>
>>>>>        int prog(struct bpf_map *map, u64 seq_num) {
>>>>>            ... map->id ...
>>>>>            ... map->user_cnt ...
>>>>>        }
>>>>>
>>>>> verifier won't be easy to conclude inproper map pointer tracing
>>>>> here and in the above map->id, map->user_cnt will cause
>>>>> exceptions and they will silently get value 0.
>>>>
>>>> I mean always pass valid object pointer into the prog.
>>>> In above case 'map' will always be valid.
>>>> Consider prog that iterating all map elements.
>>>> It's weird that the prog would always need to do
>>>> if (map == 0)
>>>>     goto out;
>>>> even if it doesn't care about finding last.
>>>> All progs would have to have such extra 'if'.
>>>> If we always pass valid object than there is no need
>>>> for such extra checks inside the prog.
>>>> First and last element can be indicated via seq_num
>>>> or via another flag or via helper call like is_this_last_elem()
>>>> or something.
>>>
>>> Okay, I see what you mean now. Basically this means
>>> seq_ops->next() should try to get/maintain next two elements,
>>
>> What about the case when there are no elements to iterate to begin
>> with? In that case, we still need to call bpf_prog for (empty)
>> post-aggregation, but we have no valid element... For bpf_map
>> iteration we could have fake empty bpf_map that would be passed, but
>> I'm not sure it's applicable for any time of object (e.g., having a
>> fake task_struct is probably quite a bit more problematic?)...
> 
> Oh, yes, thanks for reminding me of this. I put a call to
> bpf_prog in seq_ops->stop() especially to handle no object
> case. In that case, seq_ops->start() will return NULL,
> seq_ops->next() won't be called, and then seq_ops->stop()
> is called. My earlier attempt tries to hook with next()
> and then find it not working in all cases.

wait a sec. seq_ops->stop() is not the end.
With lseek of seq_file it can be called multiple times.
What's the point calling bpf prog with NULL then?
