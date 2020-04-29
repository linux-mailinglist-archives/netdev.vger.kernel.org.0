Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAC001BE2D5
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 17:34:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726929AbgD2Pej (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 11:34:39 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:37504 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726519AbgD2Peh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 11:34:37 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03TFYCtN031567;
        Wed, 29 Apr 2020 08:34:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=1EXh8QUgtQCxAk/b0k5MOqTBUdW8h1y/tRdzrTfXbm8=;
 b=gtEwPkUTEhaV7sNLAUxNszqD2uUWwvwV4SJOx63kXbadxxu+15aX0ivCJAY5iqBHG85V
 YZjvwygoNC1lXhi+/Ap7LPxGaZEFwJ6TONhY0eCPQtaQUM+VYt4oG92kp3E0uIf7CY87
 Sqr4L1tGgZdQCSZbY8Aoe3/6fhSUmeBniuU= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 30q6y0sv21-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 29 Apr 2020 08:34:23 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Wed, 29 Apr 2020 08:34:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mn3n0u1GIezvHIOgSFIXj/050oFSrV7pbaMlNiwcbrDRT/VXvuJuDPvJTWVVvI3dXyPX1Poo2vkP6M/ShZqqYSPXo/gLRSqyXJu7MN7p3Y80oTLH8XFdJLi8/aZKgh0Iy5fI+xLVe0GCvJMljLuaF9ioLSCUjs8h7ymlm3dSVz0sCzf1cIGc80OBInZyk1prvD255Aqq7bR5qoac+/whrjSb2JKa5lVMVnfev2B4OHw4ANmt39Gbe8+1N9vHWvh2V4euYsfuVF/ektYKeSwaL45UedhoZPMUV4vP78Ut2QT3hdLuZwk0xU6R7DvH1fv0R1VSB1xe4GhLnooIR7rCUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1EXh8QUgtQCxAk/b0k5MOqTBUdW8h1y/tRdzrTfXbm8=;
 b=T96leiZ+q1SuzTXuJjuWntWl7TfQBQmtmXUUTQtCqVEAhCGFFtSaQWjfpAeKLzrD3K5IkHjyZaOeRUcdYIzUUSt4bWghKOvskJ3DcOSsIK4weqd/m/6IMxf+giiDHtWQBrv9S19BrT8pUD4f75s4OV8O3znSfc4skehZNVwCLRLxnwemo0J5vEz31aCt1jQB0DbMF/2cnXPyq2JIKhhwFm54Dc5zrT2i1DVNVimJnIp1axIJL+hQX8fHSWKJ6TNXRpV3jO0vVssuPG+j6nHAC4qqdWGysetKIs9FQpYoeOXEX7xgbCv9/HYzmbYgp04LgIE4Jeko6Py5PoHxjwAlLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1EXh8QUgtQCxAk/b0k5MOqTBUdW8h1y/tRdzrTfXbm8=;
 b=TtrcB6y9jy6javhJY8hSmIGlMxRuiPj7o3dQHNGNL4XfyCvIdHk7xTq3PBUP/I9I3ST5Cmh08ReBJBvoDfBHzZDRr8OPujAtHEZZJ2faBWJUxgcg7DF0XUXMOPDdSrkQ65mTC/SCh+EXgGv/oQiFIyZl8oRogYMnmpNj2Vuf7Eg=
Received: from MW3PR15MB3772.namprd15.prod.outlook.com (2603:10b6:303:4c::14)
 by MN2SPR01MB0048.namprd15.prod.outlook.com (2603:10b6:208:1ee::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.19; Wed, 29 Apr
 2020 15:34:18 +0000
Received: from MW3PR15MB3772.namprd15.prod.outlook.com
 ([fe80::3032:6927:d600:772a]) by MW3PR15MB3772.namprd15.prod.outlook.com
 ([fe80::3032:6927:d600:772a%7]) with mapi id 15.20.2937.023; Wed, 29 Apr 2020
 15:34:18 +0000
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
 <f9a3590f-1fd3-2151-5b52-4e7ddc0da934@fb.com>
 <CAEf4BzY1eycQ81h+nFKUhwAjCERAmAZhKXyHDAF2Sm4Gsb9UMw@mail.gmail.com>
 <b070519a-0956-01bb-35d9-3ced12e0cd11@fb.com>
From:   Alexei Starovoitov <ast@fb.com>
Message-ID: <2be3cd4a-cf55-2eeb-c33b-a25135defceb@fb.com>
Date:   Wed, 29 Apr 2020 08:34:16 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.6.0
In-Reply-To: <b070519a-0956-01bb-35d9-3ced12e0cd11@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MWHPR2001CA0011.namprd20.prod.outlook.com
 (2603:10b6:301:15::21) To MW3PR15MB3772.namprd15.prod.outlook.com
 (2603:10b6:303:4c::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21cf::11e1] (2620:10d:c090:400::5:a017) by MWHPR2001CA0011.namprd20.prod.outlook.com (2603:10b6:301:15::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20 via Frontend Transport; Wed, 29 Apr 2020 15:34:17 +0000
X-Originating-IP: [2620:10d:c090:400::5:a017]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: eaf4ccdb-b7a9-4947-cbb9-08d7ec52c807
X-MS-TrafficTypeDiagnostic: MN2SPR01MB0048:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2SPR01MB004876C601CF8D177C177EBED7AD0@MN2SPR01MB0048.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 03883BD916
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BYTDS/qardS0WtyxLq+HO5VYYY4PVXqMxXE71VbCIAcvmTuSQT9bwuhR2HX4knvVDn/zHtb2RY5IK1KqmXnBK6hTkrWNVQZKewysDIXya9TcBc3oYGND5Kr+7y0+ISw0IpAlAhvvlTxAzMQq9rRtw2nkdppkLKU3I+CfAmkUTX0GeRgi95erNv60od6uEtBV5a8c619dPfyAECzOj5/Bo6oKAn1Yg4KbnGIClPWhKfdCCcE0LyB4ZUhOiPwJdMkE5ebAobMin7F1eJe7scnM8zGvy+EghNl4tfJCEccBcwJ0yhvBccpsC6VwcsihK43ebWILPgtBT65+hTROxYQgc6M4OQaYHXRGoQva3DSDMUyd567zLmGIOQOXvpefraCtRRfPCMJ3jiI3ILq8F4Km/anNFILQGVjqT8dB5qt58Ap37gUikdhGolCADxzgb3Rr
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR15MB3772.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(346002)(396003)(39860400002)(376002)(366004)(136003)(2616005)(16526019)(66476007)(66946007)(31696002)(66556008)(86362001)(5660300002)(31686004)(36756003)(2906002)(8936002)(8676002)(316002)(6486002)(186003)(52116002)(54906003)(478600001)(4326008)(53546011)(110136005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: FRy67lPjfIMesp5HNbsdNjXjn5nM8JDoHxPp3eDJQVJpT4fyrVRXWjwzN2kuOhTig+czv6vsOdvntJgPXG6yE77NU3PYLbmayfshhzB5mkXsuUsk7DUNecJdAaI2u/nYih6b4sAgPQWFPx6hG7AJcIjsJ0jPQQo/hqAG9WtJRLE4Lw/yyHQpNKh53ZJKEzZRGOfkdp0ThMjEHdxjWWX4evHSPxNMwoWm7hl+NoEIZnqEM8JWQaj1dMdhP8tGOU2vSinDln59UKJgz+sqwhL3j3kKZFeEXShiOm/SFsK7DDckqU3EcSRvbeZ0BwuywRQ+7WomKGrKqI0cVIM08QWxJs5s+WcHGk+RJgRyWlwIeAi5vu3TIEc6EtPdqfhMLildD2AzVmKYs+kW69CdvATQLJefA2bM23eYhk6TLFaLTDLfU7WpQwHKMHydvxGnAdxlvvCLczRmiTJd+9W9xxy1hETO934mqeeVGbr8lJzjjJVDFihgEGbXkpZzBiIGG0oPu32jnW2CbpDOoFohiyWiEpZPFV7K+k5a4dlMm78JYEO9sVubs6zHqFVoxiQAmnc0RLdVSGcShZuSZDfBENe3KU5EPSTu2jsDjvshR8GrUXoU8AsbfIXPM5QCNb2URWOMbWHthJJwrJKC1pgdMpT8CDxKm1k1fTYOp0RcsPGZZs7D2r05LHyI577RushrkiFbSO+zqtHhRyh7PLQwEo8BFgx9hQlZhgQI/PAp+d9+hdICO/mgvliWDtbMIYCB8JhmDl7rJhUx7hO5Uelby1HM43rLIIY+g11nwnJAtpUSjNix9/7Qroh2bn1H5hNkM6Bdva0dRIgLFOKddFXuQc63PQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: eaf4ccdb-b7a9-4947-cbb9-08d7ec52c807
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2020 15:34:18.6589
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z+ZPt30C9kAaRcnKu1TrERn4Dv/bkYcEWfO6DCh6Kz7swJ1lo6S7HgKSpqaW5Tyi
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2SPR01MB0048
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-29_07:2020-04-29,2020-04-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0 phishscore=0
 malwarescore=0 impostorscore=0 mlxlogscore=999 suspectscore=0
 lowpriorityscore=0 bulkscore=0 mlxscore=0 clxscore=1015 priorityscore=1501
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004290129
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/28/20 11:44 PM, Yonghong Song wrote:
> 
> 
> On 4/28/20 11:40 PM, Andrii Nakryiko wrote:
>> On Tue, Apr 28, 2020 at 11:30 PM Alexei Starovoitov <ast@fb.com> wrote:
>>>
>>> On 4/28/20 11:20 PM, Yonghong Song wrote:
>>>>
>>>>
>>>> On 4/28/20 11:08 PM, Andrii Nakryiko wrote:
>>>>> On Tue, Apr 28, 2020 at 10:10 PM Yonghong Song <yhs@fb.com> wrote:
>>>>>>
>>>>>>
>>>>>>
>>>>>> On 4/28/20 7:44 PM, Alexei Starovoitov wrote:
>>>>>>> On 4/28/20 6:15 PM, Yonghong Song wrote:
>>>>>>>>
>>>>>>>>
>>>>>>>> On 4/28/20 5:48 PM, Alexei Starovoitov wrote:
>>>>>>>>> On 4/28/20 5:37 PM, Martin KaFai Lau wrote:
>>>>>>>>>>> +    prog = bpf_iter_get_prog(seq, sizeof(struct
>>>>>>>>>>> bpf_iter_seq_map_info),
>>>>>>>>>>> +                 &meta.session_id, &meta.seq_num,
>>>>>>>>>>> +                 v == (void *)0);
>>>>>>>>>>    From looking at seq_file.c, when will show() be called with 
>>>>>>>>>> "v ==
>>>>>>>>>> NULL"?
>>>>>>>>>>
>>>>>>>>>
>>>>>>>>> that v == NULL here and the whole verifier change just to allow
>>>>>>>>> NULL...
>>>>>>>>> may be use seq_num as an indicator of the last elem instead?
>>>>>>>>> Like seq_num with upper bit set to indicate that it's last?
>>>>>>>>
>>>>>>>> We could. But then verifier won't have an easy way to verify that.
>>>>>>>> For example, the above is expected:
>>>>>>>>
>>>>>>>>         int prog(struct bpf_map *map, u64 seq_num) {
>>>>>>>>            if (seq_num >> 63)
>>>>>>>>              return 0;
>>>>>>>>            ... map->id ...
>>>>>>>>            ... map->user_cnt ...
>>>>>>>>         }
>>>>>>>>
>>>>>>>> But if user writes
>>>>>>>>
>>>>>>>>         int prog(struct bpf_map *map, u64 seq_num) {
>>>>>>>>             ... map->id ...
>>>>>>>>             ... map->user_cnt ...
>>>>>>>>         }
>>>>>>>>
>>>>>>>> verifier won't be easy to conclude inproper map pointer tracing
>>>>>>>> here and in the above map->id, map->user_cnt will cause
>>>>>>>> exceptions and they will silently get value 0.
>>>>>>>
>>>>>>> I mean always pass valid object pointer into the prog.
>>>>>>> In above case 'map' will always be valid.
>>>>>>> Consider prog that iterating all map elements.
>>>>>>> It's weird that the prog would always need to do
>>>>>>> if (map == 0)
>>>>>>>      goto out;
>>>>>>> even if it doesn't care about finding last.
>>>>>>> All progs would have to have such extra 'if'.
>>>>>>> If we always pass valid object than there is no need
>>>>>>> for such extra checks inside the prog.
>>>>>>> First and last element can be indicated via seq_num
>>>>>>> or via another flag or via helper call like is_this_last_elem()
>>>>>>> or something.
>>>>>>
>>>>>> Okay, I see what you mean now. Basically this means
>>>>>> seq_ops->next() should try to get/maintain next two elements,
>>>>>
>>>>> What about the case when there are no elements to iterate to begin
>>>>> with? In that case, we still need to call bpf_prog for (empty)
>>>>> post-aggregation, but we have no valid element... For bpf_map
>>>>> iteration we could have fake empty bpf_map that would be passed, but
>>>>> I'm not sure it's applicable for any time of object (e.g., having a
>>>>> fake task_struct is probably quite a bit more problematic?)...
>>>>
>>>> Oh, yes, thanks for reminding me of this. I put a call to
>>>> bpf_prog in seq_ops->stop() especially to handle no object
>>>> case. In that case, seq_ops->start() will return NULL,
>>>> seq_ops->next() won't be called, and then seq_ops->stop()
>>>> is called. My earlier attempt tries to hook with next()
>>>> and then find it not working in all cases.
>>>
>>> wait a sec. seq_ops->stop() is not the end.
>>> With lseek of seq_file it can be called multiple times.
> 
> Yes, I have taken care of this. when the object is NULL,
> bpf program will be called. When the object is NULL again,
> it won't be called. The private data remembers it has
> been called with NULL.

Even without lseek stop() will be called multiple times.
If I read seq_file.c correctly it will be called before
every copy_to_user(). Which means that for a lot of text
(or if read() is done with small buffer) there will be
plenty of start,show,show,stop sequences.
