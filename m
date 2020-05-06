Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 038171C6543
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 02:54:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729641AbgEFAyX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 20:54:23 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:21246 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729332AbgEFAyX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 20:54:23 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0460d8YD000728;
        Tue, 5 May 2020 17:54:09 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=tNa64aINdax7dn7PFahYhxJIHEECA+myq6yQBzC36QY=;
 b=cp92We+spGo6+ouhFWoq5MDeP5ibKlT/Y4UpWLbReaUeckhkuEk4IRW1ybIlw9QNPXbV
 RH5jv4HWMafNqujy225lDHNvSXEd0sgZ3/Sy7dCl+BJzVIRgIXG1Y0PQeX0dvORW2nDt
 TnrdHoK5fN1hpz//Sx7VF6F93BizbIMpu4Q= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 30srvyxj48-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 05 May 2020 17:54:09 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.198) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Tue, 5 May 2020 17:54:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lEaqUUGAwUl0P6BbS9kSAQ8Yk9Zb8iga1mRdGhrdDytww33d4mWVMNF8W8xcvze/4VrzcGoAizfOVMXivQowTbBY4bsL2eEStonDsHTC0AHJjJ2+NWY6yfjPvSTr3MRFG11Ql5Sz7jp8ADdiPe8AMap6RqEvT+6ohIkf7e93WxEFmV9lsg2I/mUAv4NkzMvuTKGMqcw9YIqghm1GV6AJKKlLoI4L4D8nw+Di8NtleUDBDHPnfYjAFKZ4tfK+cGiR5UZxWhfErD5vlmH5P8Ki+mnaw0VGmaHruIifeB+1SFDs3qDu/zYk7Wa4qD4sQeh1fIzPgkZSCAuI+4vv7b0I1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tNa64aINdax7dn7PFahYhxJIHEECA+myq6yQBzC36QY=;
 b=nuZNhqOg2upf3RC+nm0gcnhP7JXsZav+5Zew0VxYLd/vPFQX0CS/tkPxlmFsaCMILnh5N2hNTGzR80VUJvx2dQwutGDtlQBuIKpmzsJ9zc0Ko+1AkSH/6Fkoo3VUszVL8f7jAKXqPXvTjoIHEpNLBUEvPBuvHHYySXSM2ZxPhYO48PX1No5nLc3Lrjq1HdSXklk5yVQ3+6T5OtKAC2BWaIZdKfFMNRGOuUWIs7y4QBBDgVvXzPDsPYbuXHl/0uBkfPWTBbf8CbazBezqagD1peCgDi7aQdron+esinAc8/jMgr3fqqHJCJ1nKn3Y8nRIVl0ZTwy55OYIlVDNC/2o8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tNa64aINdax7dn7PFahYhxJIHEECA+myq6yQBzC36QY=;
 b=LH6crberH8fO91foIetNKBoq4vWOvPfSx4nLDUQoXF+LNnlJIZ3aQxJ8CsjxBQHZ0TaBpyWc96vRzl+2MFQmwxfae7gSjcqshZsEAmz0+Gn/UJsBnKkh+9nTrLq4JI3ErkxrkA30jTpWklHtgdhOSBVidXseBVLtGAX0xpVat5U=
Received: from MW3PR15MB3772.namprd15.prod.outlook.com (2603:10b6:303:4c::14)
 by MW3PR15MB3898.namprd15.prod.outlook.com (2603:10b6:303:43::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20; Wed, 6 May
 2020 00:54:07 +0000
Received: from MW3PR15MB3772.namprd15.prod.outlook.com
 ([fe80::3032:6927:d600:772a]) by MW3PR15MB3772.namprd15.prod.outlook.com
 ([fe80::3032:6927:d600:772a%8]) with mapi id 15.20.2958.030; Wed, 6 May 2020
 00:54:07 +0000
Subject: Re: [PATCH bpf-next v2 03/20] bpf: support bpf tracing/iter programs
 for BPF_LINK_CREATE
To:     Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Networking <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
References: <20200504062547.2047304-1-yhs@fb.com>
 <20200504062549.2047531-1-yhs@fb.com>
 <CAEf4BzYxTwmxEVk6DG9GzkqHDF--VqvZWik0YJigzdrn3whcXA@mail.gmail.com>
 <e71a26e7-1a78-7e4d-23d6-20070541524d@fb.com>
From:   Alexei Starovoitov <ast@fb.com>
Message-ID: <fe5d8d02-b263-c373-9ab8-c709f4c5841f@fb.com>
Date:   Tue, 5 May 2020 17:54:05 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
In-Reply-To: <e71a26e7-1a78-7e4d-23d6-20070541524d@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BY5PR20CA0034.namprd20.prod.outlook.com
 (2603:10b6:a03:1f4::47) To MW3PR15MB3772.namprd15.prod.outlook.com
 (2603:10b6:303:4c::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21e1::130e] (2620:10d:c090:400::5:e9bf) by BY5PR20CA0034.namprd20.prod.outlook.com (2603:10b6:a03:1f4::47) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20 via Frontend Transport; Wed, 6 May 2020 00:54:06 +0000
X-Originating-IP: [2620:10d:c090:400::5:e9bf]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 56ef8346-feeb-469f-c341-08d7f157faf5
X-MS-TrafficTypeDiagnostic: MW3PR15MB3898:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MW3PR15MB38987B78811DBB7647CEBB6AD7A40@MW3PR15MB3898.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 03950F25EC
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VrM5VLg4IIS/VMYyu3z36uAV0r7IJLtbyqx943PR4XHL8GHtztTGz9lw+Fr17/FNT3eE9vtBf7cqNLxpXoQJxtArUa77QCWhtQypspQMz2ogMQtxhXwz9xxefc9Mm9nKv2z7GxLPevn53qNgeLwQ/aU2eow1Mtup9u8FhBJsDO9FBkemc7K7RRl/BsVEm4p37GxfBbyuL80ZNmgv4V/7UZIVLcfOPLlCs7sT3UQ1WZ1ebbdnKUQuqooRg2Mk5XPLA7xzwz+ZxTKchA4rr4bHrAZ8G5+8WpVxwlwCJa+bth4TxHB5Lmdgnm+AMZb23ZGwyWMCLETQtX/KnSTg3QMO3VSnCZBAIfL+dXm+74m7I/hI2K4NHHYEXCfDQPXEjRFPRzttYfMa9c9ocQu4r5rV6UFzl3BrkWQ0LbxeYULLXPTSzF0z6ml30Fyh0XXCAiB7RfjeYEgRXP1i2rCmioCxwa/65eRyo6R10fR4NTIp8kmczLTgRtWRQg54QT+TYoG8biUeM9RHL+XmuuzSZ9rq+udLMDNy/fPUcEKPjLeVGzyoGKWPSykeKVOmuUATnEEY
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR15MB3772.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(366004)(33430700001)(4326008)(8936002)(36756003)(8676002)(5660300002)(498600001)(16526019)(186003)(2906002)(6486002)(66946007)(110136005)(31686004)(66556008)(53546011)(52116002)(54906003)(33440700001)(86362001)(31696002)(2616005)(66476007)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: pAJIQS56hySbe71olE/erUk4EiK4IJTBC4DdzPfm0rhIbUBs6oo/62Lanr8moiKwGCneict0kFssbygCt43DUi2ufUW7ITbU5XLzsCUInWp7DJJVJeAfnd7XrIm3nJAoKI3epL0co05sCLyhVgVPSrZRxkYMzkicBUo0rrR2b5Qyu08IwHZWRpxHIQjm9szSrhm0/7TIabMUOWXoEzSOE42OafVq5C/U+j4wtxzE+TqtFDMdjEzBtUrgleRbSIgdkINeSDFP+Eva/Ib1ZyPhnBDgDyi+kH3nhFWvCWbfKtt4B+WMJa/O58CJJmKT3XDw9d2lrZuE/2UoeQq8deundR2U5h+jiVSzPUuF/JBEJRN/7IDE+d9U5hBg/kU7n7ph//EiRVXvFlLianOlxVT0PVrj21RpBlzhHh5GRGAThg3EboD1H+HccylEsZ9X4tHlUN4+A2eqjK01d6f9WJ8uJxOGYdlWuvH2OOVCH+qUDke6tmWFpq0XrFhar+K2wGyPv3UZeb5I0ibItTf41Mshyc7bKo7ZaN3pRSenxvCDm6E/NiTmiitmAL4doodaajyRl7sY2vllWiyLb+nHDlpFyZuqwQxIqaeTJNcLPJw/PTZE9R8UUMMYNyyiIkGl4/xQ5gmXBUYJlon4LAU+JTAxwOPl9uP+F87TaNzgSK7//fjPg4yVvSgBIh7Q/185QcjgZ8jTvYv8ZfhAU381jhyvuGlv6OQchYigaWVcNfnfSdjdaM/T+/7mM2+xyTe3b+ntC0V5KAEKJ/MlFBcPh5XZ0384Wl1JVq038U9ijTd/TiQ2MZO25NAZUGVl62DuqQNBYzYLwNjyRsphvt/rPmy90w==
X-MS-Exchange-CrossTenant-Network-Message-Id: 56ef8346-feeb-469f-c341-08d7f157faf5
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2020 00:54:07.2816
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5XyXdWILloSl60C/pd+0XJUN2+DDRtg3r71qBIH5C6Oc09kbBg0hac2AaRZT1Vwn
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB3898
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-05-05_11:2020-05-04,2020-05-05 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 adultscore=0
 malwarescore=0 bulkscore=0 phishscore=0 clxscore=1015 impostorscore=0
 lowpriorityscore=0 priorityscore=1501 spamscore=0 suspectscore=2
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005060002
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/5/20 5:14 PM, Yonghong Song wrote:
> 
> 
> On 5/5/20 2:30 PM, Andrii Nakryiko wrote:
>> On Sun, May 3, 2020 at 11:26 PM Yonghong Song <yhs@fb.com> wrote:
>>>
>>> Given a bpf program, the step to create an anonymous bpf iterator is:
>>>    - create a bpf_iter_link, which combines bpf program and the target.
>>>      In the future, there could be more information recorded in the 
>>> link.
>>>      A link_fd will be returned to the user space.
>>>    - create an anonymous bpf iterator with the given link_fd.
>>>
>>> The bpf_iter_link can be pinned to bpffs mount file system to
>>> create a file based bpf iterator as well.
>>>
>>> The benefit to use of bpf_iter_link:
>>>    - using bpf link simplifies design and implementation as bpf link
>>>      is used for other tracing bpf programs.
>>>    - for file based bpf iterator, bpf_iter_link provides a standard
>>>      way to replace underlying bpf programs.
>>>    - for both anonymous and free based iterators, bpf link query
>>>      capability can be leveraged.
>>>
>>> The patch added support of tracing/iter programs for BPF_LINK_CREATE.
>>> A new link type BPF_LINK_TYPE_ITER is added to facilitate link
>>> querying. Currently, only prog_id is needed, so there is no
>>> additional in-kernel show_fdinfo() and fill_link_info() hook
>>> is needed for BPF_LINK_TYPE_ITER link.
>>>
>>> Signed-off-by: Yonghong Song <yhs@fb.com>
>>> ---
>>
>> LGTM. See small nit about __GFP_NOWARN.
>>
>> Acked-by: Andrii Nakryiko <andriin@fb.com>
>>
>>
>>>   include/linux/bpf.h            |  1 +
>>>   include/linux/bpf_types.h      |  1 +
>>>   include/uapi/linux/bpf.h       |  1 +
>>>   kernel/bpf/bpf_iter.c          | 62 ++++++++++++++++++++++++++++++++++
>>>   kernel/bpf/syscall.c           | 14 ++++++++
>>>   tools/include/uapi/linux/bpf.h |  1 +
>>>   6 files changed, 80 insertions(+)
>>>
>>
>> [...]
>>
>>> +int bpf_iter_link_attach(const union bpf_attr *attr, struct bpf_prog 
>>> *prog)
>>> +{
>>> +       struct bpf_link_primer link_primer;
>>> +       struct bpf_iter_target_info *tinfo;
>>> +       struct bpf_iter_link *link;
>>> +       bool existed = false;
>>> +       u32 prog_btf_id;
>>> +       int err;
>>> +
>>> +       if (attr->link_create.target_fd || attr->link_create.flags)
>>> +               return -EINVAL;
>>> +
>>> +       prog_btf_id = prog->aux->attach_btf_id;
>>> +       mutex_lock(&targets_mutex);
>>> +       list_for_each_entry(tinfo, &targets, list) {
>>> +               if (tinfo->btf_id == prog_btf_id) {
>>> +                       existed = true;
>>> +                       break;
>>> +               }
>>> +       }
>>> +       mutex_unlock(&targets_mutex);
>>> +       if (!existed)
>>> +               return -ENOENT;
>>> +
>>> +       link = kzalloc(sizeof(*link), GFP_USER | __GFP_NOWARN);
>>
>> nit: all existing link implementation don't specify __GFP_NOWARN,
>> wonder if bpf_iter_link should be special?
> 
> Nothing special. Just feel __GFP_NOWARN is the right thing to do to 
> avoid pollute dmesg since -ENOMEM is returned to user space. But in
> reality, unlike some key/value allocation where the size could be huge
> and __GFP_NOWARN might be more useful, here, sizeof(*link) is fixed
> and small, __GFP_NOWARN probably not that useful.
> 
> Will drop it.

actually all existing user space driven allocation have nowarn.
If we missed it in other link allocs we should probably add it.
