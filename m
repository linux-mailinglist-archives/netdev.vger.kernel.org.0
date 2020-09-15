Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 503FE26ACBA
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 20:58:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727653AbgIOS5g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 14:57:36 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:14164 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727898AbgIOS5E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 14:57:04 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08FIuePd027538;
        Tue, 15 Sep 2020 11:56:46 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=B71E8AJFVOoKGGZ6tTPv9yIFGgvvBnTwpHHuGvQhwLs=;
 b=lfYzH+5uiVroMgEvdRwLz63pk+D+Wwd74kIAlgwjC8sHRr3zFSDI/qbPx4hJxCRDgCAW
 tO+/FA7VI/gsOjSSskvqj5vaHCWj5WQZBa3QZhU4x4UyKGNc0YIjxeLFCf+QGzwDiXs5
 KIMzTTWALxpd7tQYUE/Uhx+fQ44QwgGMAeY= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 33k3acr05p-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 15 Sep 2020 11:56:46 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 15 Sep 2020 11:56:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SXDPhu/UPCMj6lgEDbbdnphWK+wBPWtcn3JGX+B4920fzGABYOEfvniRFl3mSVGk+iAEB/3R8jHrsuWGZ/YZLQcfdvUif5UixZaoS2yyRaJI8/40wIwZkHl7JomTBxXDSHZ+VIT59IQaXJEsuQVt7fmZW23LIVgVZbj5oF6dxsnSO79d6JpdPaNVfy9YXc3V8AW4B3yFkEWWdtwweb6l7iwBT9vzXw8hULQFCcLYvKljZe4NCbkgHxehHTvhf22y2pof0FBDwTwSZkTb5smOswItvJ8pZERnLooAcswCNK6LicvYGQDBrRDm80VVSKG0TVEojN7QyWAdJCxWfLLTeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B71E8AJFVOoKGGZ6tTPv9yIFGgvvBnTwpHHuGvQhwLs=;
 b=chr2q1/D4yNA5aGcEgLQ5Huun4Ck8C8726uYRgZgUbqJR2+zFFZVSrl01XcPptZS0zsoeiR+ZSXFZhORiPWv63pb37u6L0q0irB3JDmokg8yIwNI7SLdoZMAT0bEiw7aLhO26wV8+FzbToX5WIL/ALpfw02S2MbkQOlZiWbmB4Xsr3jiurraoxfzjlS/3Y3bLHVO4x9Jf6Fmd1EkZ4dxHt7H3biN8PQTAt5fE9AcEBqPFSYsJGuAZyTX+zGStt3itWYQPJvt2eAT6caCQ8OikWWJZmX8KT4kQoETLO/DQma0odu91y3mH89KPyswm/VJut/OBClmOa4ozb0f0+Z0MQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B71E8AJFVOoKGGZ6tTPv9yIFGgvvBnTwpHHuGvQhwLs=;
 b=idbz0hq22dPGqYHOPZW7GRIKFg+PutvaR5eMrgozcpCkPlkMmghOKnT7xs5uNq4PpqI3zvUJFZmWWcOfdMO/D0G0RKCva2KF/+1ZaY6gARSxIRDaw592povp0s7I9koKXaeVt69DXwh/Hcgadr5BJrzQ0UvFl2qlrdhfdb2Zdz8=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB4087.namprd15.prod.outlook.com (2603:10b6:a02:bd::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.17; Tue, 15 Sep
 2020 18:56:41 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8887:dd68:f497:ea42]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8887:dd68:f497:ea42%3]) with mapi id 15.20.3391.011; Tue, 15 Sep 2020
 18:56:41 +0000
Subject: Re: [PATCH bpf-next] bpf: using rcu_read_lock for bpf_sk_storage_map
 iterator
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        Martin KaFai Lau <kafai@fb.com>
References: <20200914184630.1048718-1-yhs@fb.com>
 <20200915083327.7e98cf2d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <bc24e2da-33e5-e13c-8fe0-1e24c2a5a579@fb.com>
 <20200915104001.0182ae73@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <837b7690-247a-083d-65f5-ea9dc48b972a@fb.com>
Date:   Tue, 15 Sep 2020 11:56:38 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
In-Reply-To: <20200915104001.0182ae73@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MWHPR12CA0059.namprd12.prod.outlook.com
 (2603:10b6:300:103::21) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21c8::1005] (2620:10d:c090:400::5:15d8) by MWHPR12CA0059.namprd12.prod.outlook.com (2603:10b6:300:103::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.11 via Frontend Transport; Tue, 15 Sep 2020 18:56:40 +0000
X-Originating-IP: [2620:10d:c090:400::5:15d8]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 58e42de5-ee1a-46d4-715c-08d859a914f6
X-MS-TrafficTypeDiagnostic: BYAPR15MB4087:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB40870E099804EB2556404F4CD3200@BYAPR15MB4087.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Xhswv307iZvW0xh2nlK/lvEvx3j/lxFGS/l0fenJV0tl2Fi3IybSOml8HxL1p3x5ES2uavHbLDVU3K8VXi6pItCX6Vi8+wFwF0jf5sBFnQtnZq9LJQ98SHvBPZcIDyBZ7Rs0cMhS5kAmt6bkoi4baSM1jz4vFj/mj85ulVDA+L0/LXzM4OjQ3rq2ieRnN+J0A/E1S5SzJd4xZJXvxi2FnaSRDRBasxElvwYn57jnjLtCWjXEElkCpZAWeX7PdBGA28dhVH/Q1hUm7SGPTpCCWCNcScmj2rQ57siyyr7qvQgtbiRHAXHuvRnbv9Qk0EY+fMFV20vJw00y2q/Lkg2d+Bth4JLVGoWwpcLmvjLv2HNdx56nosj87x1sl7mV5R+QF6lEmGvGIhkM9PATzQyK2YE0a4SUetMknDwcNZZgxIgUix2uSMr0C2bzeZR1cyWdeaorsuG/JVBnJhjHlrjkDg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(346002)(366004)(136003)(396003)(6916009)(2906002)(54906003)(16526019)(83380400001)(8936002)(186003)(966005)(36756003)(31686004)(2616005)(52116002)(8676002)(5660300002)(478600001)(6486002)(316002)(4326008)(66556008)(66476007)(66946007)(31696002)(86362001)(53546011)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: zA2GJC+kXErET+UrtcEa/XM3g7gjz3VU0u2+pholYUHxbUYsf2uUwAZO6tXh5U0x9DdaGqx2DZxCd5nyvJTBWl38vJlmKEkwOr3PFy9aBGTjCOo/t6rIRVUY6jvI2bDkXSycWreGbLbqoO3SefkRq97DDeWpFOmJUlahKLxLYbXWckvDocbiJlwcaqyNPcQH6qOll/cqhjDrxgiKIoh1Iyg6aN6xTg/iD96NCwSwFxWL9vp0LcO6dZ4mPBkaM6AREBdvzdw29arm/T1jj0aC99Sfx4bHvPFnlB9MUvdIrRDlJnA/7EwkYTCTHAJvjXOtwJfOXT1tHAMdY+q5pop4ABRKBTK73ktwhtKj48JyZ9i3oXeaKs9O8l8W4aHf0EvDhP2qfVmuD2qq5Tr42+mqGyVhSaNS1bWmEnkXXd9MdeGEPuvoyvRSUSkOb78K5KOBK6czdJcNtMrf8gsIsFQx0vtiIAMBKhpJqfG54egniK7yNZgzPTI620YlaWsn3qotLaec7qDCZMLAlHJCDFbOLP4g/nloGJuTyWDBHfx3OdLoW0Nc0ZMqlkfpk9OC+WGxiFVPm5oDRDkR4ES4jsX/CQWSkln4yjuv+Mr7CKyoSsIePsLMDdNHORwIyrelxNOPdxg0Rwtk5dkLACdU3YSLXHOBbHDNeJWo4m8IS73+NanrVJ01zTMrJd/QncBjd8sm
X-MS-Exchange-CrossTenant-Network-Message-Id: 58e42de5-ee1a-46d4-715c-08d859a914f6
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2020 18:56:41.1693
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /gO9ViHtbywMf40z1wYABSH4+gRI9dPnL1p4SNTL/dj+2Iw76O3W1Fb8U+aKwZ3r
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB4087
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-15_13:2020-09-15,2020-09-15 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 malwarescore=0 impostorscore=0 bulkscore=0 phishscore=0 mlxlogscore=962
 lowpriorityscore=0 clxscore=1015 adultscore=0 suspectscore=0 mlxscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009150149
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/15/20 10:40 AM, Jakub Kicinski wrote:
> On Tue, 15 Sep 2020 10:35:50 -0700 Yonghong Song wrote:
>> On 9/15/20 8:33 AM, Jakub Kicinski wrote:
>>> On Mon, 14 Sep 2020 11:46:30 -0700 Yonghong Song wrote:
>>>> Currently, we use bucket_lock when traversing bpf_sk_storage_map
>>>> elements. Since bpf_iter programs cannot use bpf_sk_storage_get()
>>>> and bpf_sk_storage_delete() helpers which may also grab bucket lock,
>>>> we do not have a deadlock issue which exists for hashmap when
>>>> using bucket_lock ([1]).
>>>>
>>>> If a bucket contains a lot of sockets, during bpf_iter traversing
>>>> a bucket, concurrent bpf_sk_storage_{get,delete}() may experience
>>>> some undesirable delays. Using rcu_read_lock() is a reasonable
>>>> compromise here. Although it may lose some precision, e.g.,
>>>> access stale sockets, but it will not hurt performance of other
>>>> bpf programs.
>>>>
>>>> [1] https://lore.kernel.org/bpf/20200902235341.2001534-1-yhs@fb.com
>>>>
>>>> Cc: Martin KaFai Lau <kafai@fb.com>
>>>> Signed-off-by: Yonghong Song <yhs@fb.com>
>>>
>>> Sparse is not happy about it. Could you add some annotations, perhaps?
>>>
>>> include/linux/rcupdate.h:686:9: warning: context imbalance in 'bpf_sk_storage_map_seq_find_next' - unexpected unlock
>>> include/linux/rcupdate.h:686:9: warning: context imbalance in 'bpf_sk_storage_map_seq_stop' - unexpected unlock
>>
>> Okay, I will try.
>>
>> On my system, sparse is unhappy and core dumped....
>>
>> /data/users/yhs/work/net-next/include/linux/string.h:12:38: error: too
>> many errors
>> /bin/sh: line 1: 2710132 Segmentation fault      (core dumped) sparse
>> -D__linux__ -Dlinux -D__STDC__ -Dunix
>> -D__unix__ -Wbitwise -Wno-return-void -Wno-unknown-attribute
>> -D__x86_64__ --arch=x86 -mlittle-endian -m64 -W
>> p,-MMD,net/core/.bpf_sk_storage.o.d -nostdinc -isystem
>> ...
>> /data/users/yhs/work/net-next/net/core/bpf_sk_storage.c
>> make[3]: *** [net/core/bpf_sk_storage.o] Error 139
>> make[3]: *** Deleting file `net/core/bpf_sk_storage.o'
>>
>> -bash-4.4$ rpm -qf /bin/sparse
>> sparse-0.5.2-1.el7.x86_64
>> -bash-4.4$
> 
> I think you need to build from source, sadly :(
> 
> https://git.kernel.org/pub/scm//devel/sparse/sparse.git

Indeed, building sparse from source works. After adding some 
__releases(RCU) and __acquires(RCU), I now have:
   context imbalance in 'bpf_sk_storage_map_seq_find_next' - different 
lock contexts for basic block
I may need to restructure code to please sparse...

> 
