Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CD481BEE85
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 05:07:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726558AbgD3DHL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 23:07:11 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:17344 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726180AbgD3DHK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 23:07:10 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03U36bMZ024047;
        Wed, 29 Apr 2020 20:06:58 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=MqxTgXWxo634cq0gKhHzL5jYtYdSWEoqrXb6iHqVTNM=;
 b=bg8xjmzxnbToW0iKidKw8koFwomKh5gxQpH+1tEmqq8wLM6eMY3kKglxRAn0CMM4nCAr
 WQR+QBPvoHsZRRomOA8CQEoSrzE3NXjmPgyZ/nwX17J8Ni4jBqyTB4WnvrkQpk+NnUB5
 KXZem/GtFbHc5mWcQeZxiD2X8Wb2COK82CU= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 30n5bxk71e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 29 Apr 2020 20:06:58 -0700
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Wed, 29 Apr 2020 20:06:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AOtKZtoJSUIsMtt4GSPwBhBtSKwsFupl/isE+T5wi2jZupMNOgtO027sgtqqYGewr555o7/pxCaNB3PL2QFAyxqPY7hbArdk+ewJNgwfNTqRSEeo1jcX0YEML4D5sSH2eImwGLutCOheEcK1rfsgH7BduInn9gaP6K4HOQZqBFGtFitlsAtk+cPtuU2zwnyDUruMaLJXRhyqXdsI4f4FwMT/6JVCCoWPsK/ckzXS0ExYcjSONNmfZS2WoZcfFg3vthKq0HmtptLcu9ASsGs6CWezZa+8uPnmmXHlOZC/8r0j8d+f+ACTqmxUbJkL1C/7dDurqMlM1U16cVsWm/o12A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MqxTgXWxo634cq0gKhHzL5jYtYdSWEoqrXb6iHqVTNM=;
 b=WZucuVZre7nXs5G3RDxIMe83pvjtfr18TExUR/oT3ji6w4wnriqXVqyDijTWvxlszb9yCcTV689qEYMQisH1E35hwB8TcGQLuEkZhxPaRuTIKcXi9LgTZq5MqKAilAFBGGL9gTCq0wnz2Z17DZvUnahTRhudPoLdvGBPp5LZQGj+ffIpLuDEsJ6DN/YuMWnlmW7IQClk3QC2KYOpXR+ivPwwo5Vg+hTrVPKmfqtVP+ujbcbcYZV37r09WuzwQBy5W05If1D8M2OwTjKPE3AoxKyvA9ejpaxTUitf8xi+Ay9TR89rFdcQEJ+RrYjUDEBOq8a5dKMQG1Vt1znLJJszVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MqxTgXWxo634cq0gKhHzL5jYtYdSWEoqrXb6iHqVTNM=;
 b=KZUPM6Xk/pYmwE7U3Kt6mngEPFC0Cx2D0Xr0EykPEHbRIXbPTK65wlrb2He1S5Ph8OC2I9tPCMMdCNuZlgIuyims4iXp9L/2R6r+wYUh2qkkydjG9cAeiqz05dJWGdVeTMbZA+E/1joqEC817L8f6T7+A0ljlEibzD+lHewjIdU=
Received: from MW3PR15MB3772.namprd15.prod.outlook.com (2603:10b6:303:4c::14)
 by CH2SPR01MB0020.namprd15.prod.outlook.com (2603:10b6:610:8c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.19; Thu, 30 Apr
 2020 03:06:56 +0000
Received: from MW3PR15MB3772.namprd15.prod.outlook.com
 ([fe80::3032:6927:d600:772a]) by MW3PR15MB3772.namprd15.prod.outlook.com
 ([fe80::3032:6927:d600:772a%7]) with mapi id 15.20.2937.023; Thu, 30 Apr 2020
 03:06:56 +0000
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
 <2be3cd4a-cf55-2eeb-c33b-a25135defceb@fb.com>
 <CAEf4BzZgZ7h_asHNGk_34vJv_yvLtWGcTGwdTO4fgLPySaG-Eg@mail.gmail.com>
 <cc802671-76e6-e911-0e4e-53a4e99c69ff@fb.com>
From:   Alexei Starovoitov <ast@fb.com>
Message-ID: <9f5bd594-9511-1df4-093d-33111fc9c2dd@fb.com>
Date:   Wed, 29 Apr 2020 20:06:53 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.6.0
In-Reply-To: <cc802671-76e6-e911-0e4e-53a4e99c69ff@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MWHPR02CA0016.namprd02.prod.outlook.com
 (2603:10b6:300:4b::26) To MW3PR15MB3772.namprd15.prod.outlook.com
 (2603:10b6:303:4c::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21cf::103b] (2620:10d:c090:400::5:39f2) by MWHPR02CA0016.namprd02.prod.outlook.com (2603:10b6:300:4b::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20 via Frontend Transport; Thu, 30 Apr 2020 03:06:54 +0000
X-Originating-IP: [2620:10d:c090:400::5:39f2]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 193c2873-a27d-4a8b-a7d8-08d7ecb38a10
X-MS-TrafficTypeDiagnostic: CH2SPR01MB0020:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CH2SPR01MB0020B42D33C906C740695960D7AA0@CH2SPR01MB0020.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 0389EDA07F
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: j5gD5gynAoAI91ZNvc1X19RthniQ4BDcunLgtl7stATj950JXFI5yzyIKMy+DGnCMcMnn13LU5bb9IFFo0om2S6xVok6ubPZIMgaGLo7vckP8TG/DRalmDnkUNmAXFSxf3eIOpzl1e5TfwBDphLATle5XpIW7xs0ot4oh2llODVwAJuMVt2OKx/0LE8WyWtcmQyp53pt1FDhY6X1hmD/3hDoxrNmNxjQMeyc0yznPT44f3Qh0/hbwLIOOS9/F9iLz+7wMaqZMeQYKWvJkMNiHtBdE+YoVI1t44NY16vUc1LeZq2BPEXxHt5FtzAitrJtydV0A7v0ZLYhMzEstHYME9wxPPfhYUVu3VUCyjqLNiLK6MvO/03c9SoTFPwZ6OvwtDWSflZ9w0KRzTCXrpqLPx0RHa6+YX5PTV0HOBzvP3KwoXmYR/Oox1i1eiTKc6Jq
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR15MB3772.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(39860400002)(366004)(136003)(376002)(346002)(396003)(2616005)(31686004)(36756003)(8676002)(16526019)(8936002)(2906002)(5660300002)(6486002)(52116002)(66556008)(186003)(31696002)(4326008)(53546011)(66476007)(66946007)(86362001)(110136005)(54906003)(316002)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: RDtdkr2TvPWskUhAos82CydOFWKmqAEUXUe2L4WnpXXB2Z6Ef27N6CQP1S9wlLaYOrHAyCxxN4PiXBQuYNQgNpKK5vqBQ+unrDDqnADm9T6u0fwRSbuy4KC677nsR4ervMih9MuRiwTVx7BShMvCoB5tz7585+RChIJPnCZSLT3k/A1cxAg+Blw1dommxKTv2lMNk0WKSYsQ/9afkOSj2ym2Kf5xcNMoWNGgBQntC1oxykv+VtZqgOwOaQFUpkD5Vx145LcZlsyEy5oeHYWYkdCE+3NHFLTHvg//wz6vwB8WS7Mdpl3itKiil186mnIXvKAN8jDFWZuS8KL/ruAT3gD7SYm4mV/InEGUTpXGBVzi82f5KBYXHR/6a9K1PwSf27ZKHAlnMeN7tYzHmOLi/Fy7BMqUUlTAnuE0HvMhcGpLmD7ZDzKU7+W2iFJ9IOhGJTbLT7Kfts/Ps2gWf1RCb3oxKUtvRvCGVaFVJeBjfnobtRHDObTO9zZgzIKQn+reCRD7ednlfkLvm1qFUAbsVc6WY6Jl8k9Heyu1ydPkQbwjOEqiUA00RRSKB38eemNlqMBysoygYIedNmM2cEHAT/CynFv+/hSCoYxPuGsIiCYbCDIdNmT7W9WmxFWJWk/1ikgS8OaJtlBbEC4sjDuIR72CBxYylc64UaWrVi0LwWKt4nltU27+qS/Rjb9ab4HzL/vvaKv6CGsNctTrhRg+JFBcVIIt1XIcjegiKxbK+5J2VcfyY8gbxB/4mQdvk2WwXC7k7B5xx16cOaqqKp2wMT4zrbdcbKa0NmIu7WKGPVHOGkr/rlyUirUCmBX7q+B64DrTxVHMWLlWn1cRIZKT2Q==
X-MS-Exchange-CrossTenant-Network-Message-Id: 193c2873-a27d-4a8b-a7d8-08d7ecb38a10
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2020 03:06:55.8700
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 12+lhsmfUHI2StQl+P7ik7rzmL4N3X3ZwVdSKbouoMQkjDYoiN+nwdsMNkW/zDBn
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2SPR01MB0020
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-30_01:2020-04-30,2020-04-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 malwarescore=0
 mlxlogscore=999 suspectscore=0 bulkscore=0 clxscore=1015 impostorscore=0
 adultscore=0 priorityscore=1501 spamscore=0 phishscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004300023
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/29/20 1:15 PM, Yonghong Song wrote:
>>>
>>> Even without lseek stop() will be called multiple times.
>>> If I read seq_file.c correctly it will be called before
>>> every copy_to_user(). Which means that for a lot of text
>>> (or if read() is done with small buffer) there will be
>>> plenty of start,show,show,stop sequences.
>>
>>
>> Right start/stop can be called multiple times, but seems like there
>> are clear indicators of beginning of iteration and end of iteration:
>> - start() with seq_num == 0 is start of iteration (can be called
>> multiple times, if first element overflows buffer);
>> - stop() with p == NULL is end of iteration (seems like can be called
>> multiple times as well, if user keeps read()'ing after iteration
>> completed).
>>
>> There is another problem with stop(), though. If BPF program will
>> attempt to output anything during stop(), that output will be just
>> discarded. Not great. Especially if that output overflows and we need
> 
> The stop() output will not be discarded in the following cases:
>     - regular show() objects overflow and stop() BPF program not called
>     - regular show() objects not overflow, which means iteration is done,
>       and stop() BPF program does not overflow.
> 
> The stop() seq_file output will be discarded if
>     - regular show() objects not overflow and stop() BPF program output
>       overflows.
>     - no objects to iterate, BPF program got called, but its seq_file
>       write/printf will be discarded.
> 
> Two options here:
>    - implement Alexei suggestion to look ahead two elements to
>      always having valid object and indicating the last element
>      with a special flag.
>    - Per Andrii's suggestion below to implement new way or to
>      tweak seq_file() a little bit to resolve the above cases
>      where stop() seq_file outputs being discarded.
> 
> Will try to experiment with both above options...
> 
> 
>> to re-allocate buffer.
>>
>> We are trying to use seq_file just to reuse 140 lines of code in
>> seq_read(), which is no magic, just a simple double buffer and retry
>> piece of logic. We don't need lseek and traverse, we don't need all
>> the escaping stuff. I think bpf_iter implementation would be much
>> simpler if bpf_iter had better control over iteration. Then this whole
>> "end of iteration" behavior would be crystal clear. Should we maybe
>> reconsider again?

That's what I was advocating for some time now.

I think seq_file is barely usable as a /proc extension and completely
unusable for iterating.
All the discussions in the last few weeks are pointing out that
majority of use cases are in the iterating space instead of dumping.
Dumping human readable strings as unstable /proc extension is
a small subset. So I think we shouldn't use fs/seq_file.c.
The dance around double op->next() or introducing op->finish()
into seq_ops looks like fifth wheel to the car.
I think bpf_iter semantics and bpf prog logic would be much simpler
and easier to understand if op->read method was re-implemented
for the purpose of iterating the objects.
I mean seq_op->start/next/stop can be reused as-is to iterate
existing kernel objects like sockets, but seq_read() will not be
used. We should explicitly disable lseek and write on our
cat-able files and use new bpf_seq_read() as .read op.
This specialized bpf_seq_read() will still do a sequences of
start/show/show/stop for every copy_to_user, but we don't need to
add finish() to seq_op and hack existing seq_read().
We also will be able to provide precise seq_num into the program
instead of approximation.
bpf_seq_read wouldn't need to deal with ppos and traverse.
It wouldn't need fancy m->size<<=1 retries.
It can allocate fixed PAGE_SIZE and be done with it.
It's fine to restrict bpf progs to not dump more than 4k
chracters per object.
And we can call bpf_iter prog exactly once per element.
Plenty of pros and no real cons.
