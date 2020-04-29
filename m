Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC1CD1BD4CF
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 08:44:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726575AbgD2Gox (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 02:44:53 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:27254 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726430AbgD2Gox (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 02:44:53 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 03T6gCdn021857;
        Tue, 28 Apr 2020 23:44:36 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=x+46aSFJj8QyUWXgsi+1LMZAGVO0zeq0oZyxbCR3fSc=;
 b=laNZZKIl8am1Oe8x4wvtGNxH1Tv7BzR0eDskGfJfRw68WWNyit4hGMlLVNc9brmFc5yM
 oDmKdbThJpV/OycEIk+6bVnGsPntF8F0D6K/f4byMTQnMaht+j7Zi1KuOZ6AGDMN/wYt
 GaGsqh9q0vmImW+ETOB2B8cjFviahFmcHtw= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net with ESMTP id 30mgvnsuxj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 28 Apr 2020 23:44:36 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Tue, 28 Apr 2020 23:44:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mbIFnAT6O2mNQqPHyQXYy81L1CclaCROMEfQpLVjNQ6Dn4wLI5nFvxheXGc9EaU93u6qs56y+7V+qj+GNp+QuqPiwIIgKtHYIo5dzP6R5ZgQ9jC4p0UXNSfF62HPOpMIw05s0BpXKeHfucx+IK8kQoMN+aEw1QGDNhk2cxH6w2pIDoE9WmDOVf9IsiXi9yhCVSuYyp2r7d4AC2J9TAwFHM4IHIX0xtjC7JlUbGksrx0HzJ2yiHDeL+rInQHq3QrXmSEDKLS4opEJ21xXi9+QAaCgOLa9leyhhTBNMp4P7u863pKRDK8zs6UKWo8DQj5PrtSmzkAQzMn3182ObAaBzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x+46aSFJj8QyUWXgsi+1LMZAGVO0zeq0oZyxbCR3fSc=;
 b=A2G0kT2rzeUrjrEGWLY36HhhVIdCyAdkvtwmKlKgnFhxDOJQ2SqrI+bg2qnskNmVaTyOnbL7AR6+XR5E+haDF2lzCFENIN32IsYgVohXXD7GO6/XdY11SFplDp7N+bIyMrL9aUGe2WGSJiJ1F5r/yrllNOrIxI47wAVMHK6wqq3UID4yftG3BE1V/ofK2umz3SwiVHfAFvyIgkbm3OuKgbtENmZip1iqDTam1w/o9FS0YjCOuVq6xIEt/2w195vM4oObNDWUSg2GqA6w5oNFCJvY6CXR7YDRR6le5qwTzsIYwFYJWpA1A530tZdVeAS/6V94Lm1jKSJszPCevOgxMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x+46aSFJj8QyUWXgsi+1LMZAGVO0zeq0oZyxbCR3fSc=;
 b=aQF3/T4lWcPbdH5yPAUC9O+kUDsHOZCCrL0BCZI2gfAIiYOhF3GeOv/aa1rUhn+SSW1fNYPfXcySzncl9uB3udG8lPrCfRI/CeBc9m6vrmxMaE+nfPHKbX5D9CM0Hw0ccBU4LrI4fn4OpXdNK4o7a6opB+f3GtrG1t3ffdBxDdM=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB3064.namprd15.prod.outlook.com (2603:10b6:a03:fa::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.22; Wed, 29 Apr
 2020 06:44:33 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8988:aa27:5d70:6923]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8988:aa27:5d70:6923%5]) with mapi id 15.20.2937.023; Wed, 29 Apr 2020
 06:44:33 +0000
Subject: Re: [PATCH bpf-next v1 03/19] bpf: add bpf_map iterator
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <ast@fb.com>
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
 <f9a3590f-1fd3-2151-5b52-4e7ddc0da934@fb.com>
 <CAEf4BzY1eycQ81h+nFKUhwAjCERAmAZhKXyHDAF2Sm4Gsb9UMw@mail.gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <b070519a-0956-01bb-35d9-3ced12e0cd11@fb.com>
Date:   Tue, 28 Apr 2020 23:44:29 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
In-Reply-To: <CAEf4BzY1eycQ81h+nFKUhwAjCERAmAZhKXyHDAF2Sm4Gsb9UMw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MWHPR04CA0036.namprd04.prod.outlook.com
 (2603:10b6:300:ee::22) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from macbook-pro-52.local.dhcp.thefacebook.com (2620:10d:c090:400::5:e9ab) by MWHPR04CA0036.namprd04.prod.outlook.com (2603:10b6:300:ee::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20 via Frontend Transport; Wed, 29 Apr 2020 06:44:32 +0000
X-Originating-IP: [2620:10d:c090:400::5:e9ab]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f1e1c535-e30b-40a8-dd4e-08d7ec08c6a5
X-MS-TrafficTypeDiagnostic: BYAPR15MB3064:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB3064F1C0624D6EA0E7AF27B6D3AD0@BYAPR15MB3064.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 03883BD916
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(396003)(376002)(39860400002)(346002)(366004)(136003)(31686004)(36756003)(31696002)(2616005)(4326008)(86362001)(478600001)(66556008)(6486002)(66476007)(66946007)(2906002)(6666004)(6636002)(6506007)(5660300002)(8676002)(53546011)(316002)(8936002)(16526019)(186003)(110136005)(6512007)(52116002)(54906003);DIR:OUT;SFP:1102;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AN6ASc8CP+eSN8H4S0Q7zIonrLuGV0DSiPNCRX/wf0OqNMjA9RHHye/VLGJvn2jHVy6Fel29qWvkcuPL1v665uWM4x0FztkfKAvXtpowItiRamzZykwJvyRRbphUlcFWBJyTkxb9NgrrNyAcN4OJC/EdIPxlePt9hMmQ26B52bgu2JsKuZhKG+j98/Y1Ggs0jrlVpUZLSFF4+8IaSKQK1AYQZR6y0DyySAI+o7nxfQBMKgNYrN2RsPVDD2tm0DghOHbNZ2du3liDmDESySE9h7Ip3Y5VHMqFaksfPqzdQN9dPLVGy3JbX1ftHc4n60NmpXi299w+fXt4uKBP0ebKrxv3BvNcSDj4X738gDr6x+7hyyF6IPLix3R6OrWgjiBqFj4vIBaXydmvjFY42Evk0+qhFs8iZDu9RKDxBUcBWf0lh/MfeexCrzMFpIGI0GKt
X-MS-Exchange-AntiSpam-MessageData: j38X+yyKtNRvVbSecj3Gt1olwdvavmNIxV9O4GZeUDNx1WkbCxvKg8AfEvrzt2feQe/XtwWLzOE3Zs6IfrIkRbnG7yuMTHON8Zd3hZgVI/nj36jDQUxE5CEWwrQ+6A5R/P7MstnAqHWTtsrDmw7II2+/iYJ5KemeiQJRUPnT/x/9G+8hfVqiMGsAyoITuBOAY3BK0JaD1S6KPOh8ic2danDL/ksnhgs/gJ5EPTnn/BVKJ/gzW+b1IQGWX1sK+icgcj4YRvHZywM25qaZxHm0ox1MPDTmApidQeoL98SgZkr+j5csg4tk1pkvJjw/EDcxWGFo6NjTlCnQNrrEHLuxr4MiJ7MeMr8o0tN2yH3FBlwyT8QTH8g0WZ9lyqmaILv3Kpp3AwRQjBibxkpCy//Ci+8cvd3Yf0ONxiBFaL6fMVTczkyYl4PSczJl2XVibj8gJbidXgpTtxOEnZfrtpfzvDJr++qQkqlqYxz1JAwmK/W0Tbmi9py37jKg1ylVOS8eb0FoFtalCzEM7+g+TAMeYeU5NcadrPSOFA1ThSejqjgMip+mL0fdlaCp+kCEHNLYbfvZMnSuvL8Okw+Xa8tAZfJAZIJRVS/Q5BZOFiqk0KTHFd1xfCToTZgHNKMw2sC9Gh9ECf5RmhR+bJmzsxd4oZq0uYnnc1nRFm89+54N3ZoTyiVSciQbRgr4Aov118E8M5/lFv4KczA4O9acU2kVZPLwgI3yzRhRnhxBoFM4iNPaQPLOY5zgwS+qhykHXzPoiotfyLXPDJ4Jp9DZst0FCtAme0BlcUO4qfYX0Cje+kbzFr42ZkirD+a0aCblcdtD4BMNMZ9WmkKfZyRmq3veNA==
X-MS-Exchange-CrossTenant-Network-Message-Id: f1e1c535-e30b-40a8-dd4e-08d7ec08c6a5
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2020 06:44:33.3876
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 22bID0u/IUSUmPPcH7jupULiD2iJLWUYOvchrFTOOcYLEj6XW5HacqcAAZEyUAqg
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3064
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-29_02:2020-04-28,2020-04-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0 bulkscore=0
 malwarescore=0 lowpriorityscore=0 spamscore=0 mlxscore=0
 priorityscore=1501 impostorscore=0 mlxlogscore=999 clxscore=1015
 suspectscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2004290054
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/28/20 11:40 PM, Andrii Nakryiko wrote:
> On Tue, Apr 28, 2020 at 11:30 PM Alexei Starovoitov <ast@fb.com> wrote:
>>
>> On 4/28/20 11:20 PM, Yonghong Song wrote:
>>>
>>>
>>> On 4/28/20 11:08 PM, Andrii Nakryiko wrote:
>>>> On Tue, Apr 28, 2020 at 10:10 PM Yonghong Song <yhs@fb.com> wrote:
>>>>>
>>>>>
>>>>>
>>>>> On 4/28/20 7:44 PM, Alexei Starovoitov wrote:
>>>>>> On 4/28/20 6:15 PM, Yonghong Song wrote:
>>>>>>>
>>>>>>>
>>>>>>> On 4/28/20 5:48 PM, Alexei Starovoitov wrote:
>>>>>>>> On 4/28/20 5:37 PM, Martin KaFai Lau wrote:
>>>>>>>>>> +    prog = bpf_iter_get_prog(seq, sizeof(struct
>>>>>>>>>> bpf_iter_seq_map_info),
>>>>>>>>>> +                 &meta.session_id, &meta.seq_num,
>>>>>>>>>> +                 v == (void *)0);
>>>>>>>>>    From looking at seq_file.c, when will show() be called with "v ==
>>>>>>>>> NULL"?
>>>>>>>>>
>>>>>>>>
>>>>>>>> that v == NULL here and the whole verifier change just to allow
>>>>>>>> NULL...
>>>>>>>> may be use seq_num as an indicator of the last elem instead?
>>>>>>>> Like seq_num with upper bit set to indicate that it's last?
>>>>>>>
>>>>>>> We could. But then verifier won't have an easy way to verify that.
>>>>>>> For example, the above is expected:
>>>>>>>
>>>>>>>         int prog(struct bpf_map *map, u64 seq_num) {
>>>>>>>            if (seq_num >> 63)
>>>>>>>              return 0;
>>>>>>>            ... map->id ...
>>>>>>>            ... map->user_cnt ...
>>>>>>>         }
>>>>>>>
>>>>>>> But if user writes
>>>>>>>
>>>>>>>         int prog(struct bpf_map *map, u64 seq_num) {
>>>>>>>             ... map->id ...
>>>>>>>             ... map->user_cnt ...
>>>>>>>         }
>>>>>>>
>>>>>>> verifier won't be easy to conclude inproper map pointer tracing
>>>>>>> here and in the above map->id, map->user_cnt will cause
>>>>>>> exceptions and they will silently get value 0.
>>>>>>
>>>>>> I mean always pass valid object pointer into the prog.
>>>>>> In above case 'map' will always be valid.
>>>>>> Consider prog that iterating all map elements.
>>>>>> It's weird that the prog would always need to do
>>>>>> if (map == 0)
>>>>>>      goto out;
>>>>>> even if it doesn't care about finding last.
>>>>>> All progs would have to have such extra 'if'.
>>>>>> If we always pass valid object than there is no need
>>>>>> for such extra checks inside the prog.
>>>>>> First and last element can be indicated via seq_num
>>>>>> or via another flag or via helper call like is_this_last_elem()
>>>>>> or something.
>>>>>
>>>>> Okay, I see what you mean now. Basically this means
>>>>> seq_ops->next() should try to get/maintain next two elements,
>>>>
>>>> What about the case when there are no elements to iterate to begin
>>>> with? In that case, we still need to call bpf_prog for (empty)
>>>> post-aggregation, but we have no valid element... For bpf_map
>>>> iteration we could have fake empty bpf_map that would be passed, but
>>>> I'm not sure it's applicable for any time of object (e.g., having a
>>>> fake task_struct is probably quite a bit more problematic?)...
>>>
>>> Oh, yes, thanks for reminding me of this. I put a call to
>>> bpf_prog in seq_ops->stop() especially to handle no object
>>> case. In that case, seq_ops->start() will return NULL,
>>> seq_ops->next() won't be called, and then seq_ops->stop()
>>> is called. My earlier attempt tries to hook with next()
>>> and then find it not working in all cases.
>>
>> wait a sec. seq_ops->stop() is not the end.
>> With lseek of seq_file it can be called multiple times.

Yes, I have taken care of this. when the object is NULL,
bpf program will be called. When the object is NULL again,
it won't be called. The private data remembers it has
been called with NULL.

> 
> We don't allow seeking on seq_file created from bpf_iter_link, so
> there should be no lseek'ing?
> 
>> What's the point calling bpf prog with NULL then?
> 
> To know that iteration has ended, even if there were 0 elements to
> iterate. 0, 1 or N doesn't matter, we might still need to do some
> final actions (e.g., submit or print summary).
> 
