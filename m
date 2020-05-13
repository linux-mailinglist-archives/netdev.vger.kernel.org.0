Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5847D1D1BA7
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 18:57:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389760AbgEMQ5i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 12:57:38 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:21064 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727120AbgEMQ5h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 12:57:37 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04DGvDVo001693;
        Wed, 13 May 2020 09:57:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=DYVwG5ON5lzCTRBteUy7cD98dW9OXzXg4okorzjS1fA=;
 b=UARzwKFZdHG8D3uD96gohnTXSyd2MngSn+db9YNIQ/QA9iaYA5oa7jK3SnJr+TQ+r/KC
 0LB/5EHwWfUrra+4vndypq0GRw6ErIvr3YfqsrIyzKoqMajJIv2DExlLPQqH7uYpaOvd
 LleHMsoCV6QUkvJLPunLnHnjKVPJQ5wszs0= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3100y1p1u2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 13 May 2020 09:57:23 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Wed, 13 May 2020 09:57:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H3k+cNIrvPfAewiFAZMd6dn14uHMdUX6IHQVVe2E5MvC/hlhhwRBTdE47HemK95wNWMhN1bmFaqM51T+FE1eKmr8iAKFtc9f3oRQjD2WQkY1ms2ovmw+Yb7SDg0z3YSK8hIT1DLnxnCjlX62VNjcNO6eYAbONKDtVxknjEDoj+vEvNLltMUYwXXjQDGcir3B6Y5DmId0439uaWgUfoK02GJz4LxrWwRtbMbupj9k08dUL1gzFkyU+7PTyzEvWNlSVjqBY5kmDCjHgbTwMGFFL8uUSkf9YdJoZ/VA9I4Ey/Lv3W1KFG8KVMamq4UJtxQVMjoWI8DpFDjsWE0zBQ2pTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DYVwG5ON5lzCTRBteUy7cD98dW9OXzXg4okorzjS1fA=;
 b=d2g5fKfQZ9G6bAt9S+fIYK45rKK+Ok2v0r/qb7TP7W1wRUW08+G2SzFrMS1CeDh1XdoEoPrqi6lfXsAU1nFj8YGL9hk8PB8MD9XXIoYjMR3iFjmso/7MjoABpXeZBaqEdlHFQI6K7dAGGaUkE9mvCLVq7uPqNB2EOcUwN3EhESL2oIu7GjiRO4fOxExe5COy6mrrb2LYY56iUXyX3cDdZQQu5FjYf0yqS7AxMwV9wkjsB5qQpGi4rgz83Asq81fTGZlpiRaksuRsS1f9hBDb4i7slHnOvbOssSen4Kfjnsc6DvYAMMCo/NoE6HixS2Be+vMzTpHtNGv7h07cGWidqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DYVwG5ON5lzCTRBteUy7cD98dW9OXzXg4okorzjS1fA=;
 b=inTpIjLFDoLJ+zkwBeaDCoBL51ZR6lulXZ0QsyXT9FPHKoo0j9FAb8gkEYR7z+K/zNxrz4VKDSFjxnnvcUzXpWeABG/uQ7jtpVBz7thba8CppmV3j7SJZYJM+QKvls5uKspmx0/VLORsMSqHLcd/525MWFuBvH8hOAb3CbOeuxw=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2536.namprd15.prod.outlook.com (2603:10b6:a03:159::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.34; Wed, 13 May
 2020 16:57:20 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301%7]) with mapi id 15.20.2979.033; Wed, 13 May 2020
 16:57:19 +0000
Subject: Re: [PATCH bpf-next v3 03/21] bpf: support bpf tracing/iter programs
 for BPF_LINK_CREATE
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
References: <20200507053915.1542140-1-yhs@fb.com>
 <20200507053918.1542509-1-yhs@fb.com>
 <CAEf4BzaV6u1eTta4h4+mftQCQVOGPf0Q++B8tZxho+Uq3M1=mA@mail.gmail.com>
 <849a051d-5c42-a61c-91ef-15a2bdb2b509@fb.com>
 <CAEf4BzYzwnQuvjR-deQ1OaPMaNSQcnFQOCEaAWvTrdgqOQarJg@mail.gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <cde871aa-4539-5fbf-6063-fdb7c80f275f@fb.com>
Date:   Wed, 13 May 2020 09:57:16 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
In-Reply-To: <CAEf4BzYzwnQuvjR-deQ1OaPMaNSQcnFQOCEaAWvTrdgqOQarJg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR01CA0017.prod.exchangelabs.com (2603:10b6:a02:80::30)
 To BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from macbook-pro-52.local.dhcp.thefacebook.com (2620:10d:c090:400::5:86c3) by BYAPR01CA0017.prod.exchangelabs.com (2603:10b6:a02:80::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.25 via Frontend Transport; Wed, 13 May 2020 16:57:18 +0000
X-Originating-IP: [2620:10d:c090:400::5:86c3]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5d33f81c-3bd2-4ce6-9988-08d7f75eb2bb
X-MS-TrafficTypeDiagnostic: BYAPR15MB2536:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB253683A73E3710779C2A0943D3BF0@BYAPR15MB2536.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 0402872DA1
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: K+UAvibGNfj4i7Ue5W1+euHj+D5FmX2wAalr6d/pvbCl+5jBqfqrfuyTcBden3EzbPkVlrzLkVlyOhcqWD6H6aILv/buGYGR2oQormMzqDfjVluaGhIiwm5ZpO0iTBph/zGpM2qZIFXtS/Kv5qLwu2pFR+MOXNKP5bSyzVYZsfBL5hQzRsPB/+M/fiSHHJUDZTBv+yFMg5wixWpik8EqJh2rATzYDzF+DbUKzl585+qNAXz23aVpl64XUP4rZyeQvt02Y3wE6sGXwp0vTqbJoufs2f0w6E9Ii7VlW9Oc0E6m3Fn9juu5/xDy1H92hYgeKwas1+iXjPz3XX4IbmBJQfIpEA29PVw3DLOJiGSzxtjOgkG6V7oE3utY34+ThgdNg65j2YmOccN4SpP8tAElNVH1jjuEvCebutovwFg6LNv8oxomBOT6gAYj6c+faCaD/B+qOM2jvk8dobcGOu0uKQeGINcjkhVVKxi/PJ9L0RN+bxnzwOxDxtduIjTnsIEqAcZbnme5q+hTS2KssVogVYQZxz8Q/Tw1dAb8WkVcPem233pjP954fgBfeccjWA9b
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(136003)(396003)(346002)(39860400002)(376002)(366004)(33430700001)(31686004)(86362001)(316002)(2616005)(4326008)(52116002)(6916009)(2906002)(33440700001)(16526019)(6512007)(66476007)(54906003)(8676002)(66946007)(186003)(5660300002)(66556008)(36756003)(53546011)(478600001)(8936002)(6486002)(6506007)(31696002)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: Ux6EaGaiR7klfU2xiZzM74Ddc4rgIAFZ4mI4zPQsu+OJbstGhfftdlYpREIIgiL/tB9hjEaXmGD4cZHjzz1Ze37Okioz8k25PVoDYHSaIo0+ZdWA+jTnGhX1DNQ6B2ENgpgMPwyL+H998YBRex3vivZaXh0+khYO6aSDMxmVfeYeYtAjBbcZAR8w0bSq3G6FG9FcfeLSsOSSGUQY+dMb3rC9inanusMS4uUskA0fdQO29TW722EwYrNFOPHrOQVxeP3zIOFU23GgC/D5hB4oMiDTu3wPAnZvoZeaznZUXDe263FtpTiC95apggN3xUlVUtbM/Twc3Tr1icioM1IqRJduvEeW/i2qeMSMj1D1op9rdwbHE90ctN43tfb3Cwv9L1KWnTrPVOSby1IL9RRd+KIzCr7JIkD27s7hAFrWBMRjEuvPY208yGsEf5qU+U8uoktQn1Tpws5y8Ge3rcmlQn5L/PHSlNbsqV0vUGQ+3n1G/cndB1nKI9gFTQ+tx2H0lY+mTmLgBEoJT6ItXGKGeQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d33f81c-3bd2-4ce6-9988-08d7f75eb2bb
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2020 16:57:19.7537
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Wsudg7ZF/QU0/J1znpratJkQy5VAA7O45zlcOZzvzoL8zAmiQLAdXxXZWbSwih9H
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2536
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-13_08:2020-05-13,2020-05-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 suspectscore=2 phishscore=0 cotscore=-2147483648 mlxscore=0 spamscore=0
 malwarescore=0 bulkscore=0 adultscore=0 mlxlogscore=999 clxscore=1015
 impostorscore=0 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005130148
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/11/20 8:15 PM, Andrii Nakryiko wrote:
> On Fri, May 8, 2020 at 6:36 PM Yonghong Song <yhs@fb.com> wrote:
>>
>>
>>
>> On 5/8/20 11:24 AM, Andrii Nakryiko wrote:
>>> On Wed, May 6, 2020 at 10:41 PM Yonghong Song <yhs@fb.com> wrote:
>>>>
>>>> Given a bpf program, the step to create an anonymous bpf iterator is:
>>>>     - create a bpf_iter_link, which combines bpf program and the target.
>>>>       In the future, there could be more information recorded in the link.
>>>>       A link_fd will be returned to the user space.
>>>>     - create an anonymous bpf iterator with the given link_fd.
>>>>
>>>> The bpf_iter_link can be pinned to bpffs mount file system to
>>>> create a file based bpf iterator as well.
>>>>
>>>> The benefit to use of bpf_iter_link:
>>>>     - using bpf link simplifies design and implementation as bpf link
>>>>       is used for other tracing bpf programs.
>>>>     - for file based bpf iterator, bpf_iter_link provides a standard
>>>>       way to replace underlying bpf programs.
>>>>     - for both anonymous and free based iterators, bpf link query
>>>>       capability can be leveraged.
>>>>
>>>> The patch added support of tracing/iter programs for BPF_LINK_CREATE.
>>>> A new link type BPF_LINK_TYPE_ITER is added to facilitate link
>>>> querying. Currently, only prog_id is needed, so there is no
>>>> additional in-kernel show_fdinfo() and fill_link_info() hook
>>>> is needed for BPF_LINK_TYPE_ITER link.
>>>>
>>>> Acked-by: Andrii Nakryiko <andriin@fb.com>
>>>> Signed-off-by: Yonghong Song <yhs@fb.com>
>>>> ---
>>>
>>> still looks good, but I realized show_fdinfo and fill_link_info is
>>> missing, see request for a follow-up below :)
>>>
>>>
>>>>    include/linux/bpf.h            |  1 +
>>>>    include/linux/bpf_types.h      |  1 +
>>>>    include/uapi/linux/bpf.h       |  1 +
>>>>    kernel/bpf/bpf_iter.c          | 62 ++++++++++++++++++++++++++++++++++
>>>>    kernel/bpf/syscall.c           | 14 ++++++++
>>>>    tools/include/uapi/linux/bpf.h |  1 +
>>>>    6 files changed, 80 insertions(+)
>>>>
>>>
>>> [...]
>>>
>>>> +static const struct bpf_link_ops bpf_iter_link_lops = {
>>>> +       .release = bpf_iter_link_release,
>>>> +       .dealloc = bpf_iter_link_dealloc,
>>>> +};
>>>
>>> Link infra supports .show_fdinfo and .fill_link_info methods, there is
>>> no need to block on this, but it would be great to implement them from
>>> BPF_LINK_TYPE_ITER as well in the same release as a follow-up. Thanks!
>>
>> The reason I did not implement is due to we do not have additional
>> information beyond prog_id to present. The prog_id itself gives all
>> information about this link. I looked at tracing program
> 
> Not all, e.g., bpf_iter target is invisible right now. It's good to
> have this added in a follow up, but certainly not a blocker.

Indeed, bpf_iter target is not visible now. We can add it to program
or to link. Adding to link is a reasonable idea as link itself is
the concept to merge program and target.

Will have a follow up patch for this later.

> 
> 
>> show_fdinfo/fill_link_info, the additional attach_type is printed.
>> But attach_type is obvious for BPF_LINK_TYPE_ITER which does not
>> need print.
>>
>> In the future when we add more stuff to parameterize the bpf_iter,
>> will need to implement these two callbacks as well as bpftool.
> 
> yep
> 
>>
>>>
>>>
>>> [...]
>>>
