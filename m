Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5BE026AC4A
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 20:42:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727954AbgIOSmE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 14:42:04 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:61882 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727902AbgIORgh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 13:36:37 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08FHZqUc007686;
        Tue, 15 Sep 2020 10:36:00 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=Ssdt9FBrYq3ZUb18qKqyPOlVJvAqpSXTJksYkFDtsqM=;
 b=R+T/7TPrNcnd69v8u0HRwwpaFAJkyBEztfyGfjtcsi6Qa5wax6zOTwAmcvQCu8AImRcW
 DBeOP31E1hSS8+ywRSAhIJOjYUBg21ZTkoXjfzVP7mSfeZFHiccQ/SFBWvuYLQBSVbRf
 sy9IgwhhD26PWGDI+ei606NCxWigtVV0UhE= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 33gv2pgveh-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 15 Sep 2020 10:35:59 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 15 Sep 2020 10:35:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UVAChU6YEDcDxAcQJ8Oqc+SiHgTBsY3mGyp3BO7H0l6e4Mwq7hhzS+cAaqM8ckKlhh2VlCXpIK/L/rG0+MhpV5+xMMHvfjq5P5lZyshhk16/QiN55NPJTR27fJKoJbLNhZ2dCEIyswzWGawExZhaAF/+4bHUR1EyDo1Bo2YrGEGO6pcgwEagGEA4Ze9cBBhtGmGQoi2IAAGlkBhFgDx6LsFPQ0xSamWsRNW3TaHSf9Srb7vBlJnCMXKvt6YRJgXhM99FndDtGO/hSS7Y4ENcZX5RnauXPp0MhwyKjgIqXIKnwjVCw/OVfJKhs41VgWRdSwvg9lae91CyCPHyZ9k0Og==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ssdt9FBrYq3ZUb18qKqyPOlVJvAqpSXTJksYkFDtsqM=;
 b=f+L8TnpYhUTpC0b0CC6s9kDZ1Ay0rw6pXQ4W5LUL2BNCWFh2PVwUr30dpTLRsBQXADJxNr+k1MTZYzZHiRv89NVnnOMbW3NUBSZHvwo2UmRLkYGC3CQIkCRlhW+Yqv4k4uOjSHGz06T0gNh+r6AYEnYAe8nbFGSwInxWAJHsH8Le79qrb0icl/V5GfFXPLqBkj0RjGd2qTTlmDFTDyIwKqKDrRwgs18k810kcGY07zs6+mRhGXk1qBwV1COE4vZUv883GA/kWWO/smaXFGBzAc8mWmFcFZyWjGXdjEr3MZghhujpb3Q8FJHWZ66P5YvTaPXpOhYcaYYRVDXRuoU3Dg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ssdt9FBrYq3ZUb18qKqyPOlVJvAqpSXTJksYkFDtsqM=;
 b=PxirxbtbMgEolU+sdKXyqaDcfKt49y1IquJfuironfR5MZr3svsny2Q61KDV1HsSO+S+wXDZTzMJvRCl8DwN7yaD7japo2yTdXmyi69VCe6OINGRnyHUTbaHTecs50LSLUgrJAw17o8L3dq4oAB/Es2tD8ME5Y0TaOU5rXfgI6Y=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB3512.namprd15.prod.outlook.com (2603:10b6:a03:10a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16; Tue, 15 Sep
 2020 17:35:53 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8887:dd68:f497:ea42]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8887:dd68:f497:ea42%3]) with mapi id 15.20.3391.011; Tue, 15 Sep 2020
 17:35:53 +0000
Subject: Re: [PATCH bpf-next] bpf: using rcu_read_lock for bpf_sk_storage_map
 iterator
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        Martin KaFai Lau <kafai@fb.com>
References: <20200914184630.1048718-1-yhs@fb.com>
 <20200915083327.7e98cf2d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <bc24e2da-33e5-e13c-8fe0-1e24c2a5a579@fb.com>
Date:   Tue, 15 Sep 2020 10:35:50 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
In-Reply-To: <20200915083327.7e98cf2d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MWHPR12CA0032.namprd12.prod.outlook.com
 (2603:10b6:301:2::18) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21c8::1005] (2620:10d:c090:400::5:15d8) by MWHPR12CA0032.namprd12.prod.outlook.com (2603:10b6:301:2::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16 via Frontend Transport; Tue, 15 Sep 2020 17:35:52 +0000
X-Originating-IP: [2620:10d:c090:400::5:15d8]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fa09f1c5-bfd4-4f17-845f-08d8599dcb5d
X-MS-TrafficTypeDiagnostic: BYAPR15MB3512:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB3512A1E14D55CB6E3DE2FDCFD3200@BYAPR15MB3512.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:1201;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QeEtAhX9nZIzjB5BaNfcyeJqHijl2hhVKIM55XTvRVH6dt3UxDT9S58nd5BgMVMZnMnzfAidNDl2fsqGoJ/qcDsN1+oWNHi1hSzzETFP+K71qZJd31+pv0rdfs0ZV+6qJ3PBQOFqZtKmIcC5ASCVWUKb92oXLNKPn1SCTVrENMw+vmf6pcGpKcY8apu+lHBJRrr7kZO94ejoyySi2ffpb8zLqavaSSwcf3t8toCWbn/9BB8uBKA3fHhuRIiXio87m9mK4/zuA6Fw8aiG7/xd5aZmmo5p7RgIgHakcmI4cdHiNFzVmtaqUh8OZxb7iuLVmaRDRDsqLMucMlLwMn1l9e6fXQxlU0r0heR2+GVH4o0QrYRWZxrpl1TKSzK5ZjSdr2eOVKKKUAntGPaU6Fp0TGXXBNU8uIwKgwjm/y18FAOf1Dq2oi0Yfmem1IOeOPqgnTqAZTnp8QmWmeZsW+cBgA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(39860400002)(396003)(346002)(136003)(66476007)(478600001)(66556008)(31696002)(2616005)(16526019)(66946007)(31686004)(4326008)(53546011)(186003)(8676002)(5660300002)(966005)(2906002)(86362001)(36756003)(6916009)(83380400001)(8936002)(6486002)(316002)(52116002)(54906003)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: ySWhWDIVBezAepOY6lEpHQHeuOs9ebaqfa3MyuXBCah4mjHic/tvok6OhMSLWoNgIuCu60sZ0eFXVrAa2q5MJBaxC0PkYkLBa62NGLkENTyfCyjDjeCxqQhBqrS7f+vX+rSpWGuOftJglOWiWQnYT4YiJpFmchZk/kgZaM+6PcuHhwI/HDROIcW1so1tKL8JsqrvSIJd7RcnqLYbvKHGvE4F6Ph0++F5TX9Cq8hEarkHAwTLAtUa1u2ScgBA48yBwzCNKCVbqIg68W37uHdaLO5pEXgI5pR7BR9m4a19iOlY9+BfRbjfJbmtl0yy4IsbqOZcyoAiXhGHDFkPP8P0+X+FJR+HZBRnyE99ocnOtm5/P2gBhIN3VASy3xKttqBwuPETQdEbMepuwQ+xfcagqOwSJ51XPzPyCcJ/oJ6ILWykzwf5QiVjhzpdgGctiABDvf3WlXTmJKmTtJNOAofvKdEspCYFDdN+PJ1Al1B094Hq0GDxkQ2L/1Bmz1F3RrtZkpngUnye12ztW+NECjWw+rC5mrbLWDuWzBbwpOLdcSEbqhSgVLlvJAM2fyGGlM/BZqP8qiUODCdxUB9TADuu2tlQj5QXzXePH0xgwcUlCIkWhkaGCNI3hrlPUbXgHTXgnNoTdlX7aCFUzFcaGVfEpYwc6NjFvMk3uk4Nm6fKt/o=
X-MS-Exchange-CrossTenant-Network-Message-Id: fa09f1c5-bfd4-4f17-845f-08d8599dcb5d
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2020 17:35:53.0905
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j9pwk3mh0XFTrUFK4PB/a/0c67nvVFeX1wdEu8icQh23GhP6RFLeuQY5E0YzWxz/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3512
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-15_12:2020-09-15,2020-09-15 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 malwarescore=0 mlxscore=0 spamscore=0 clxscore=1015 priorityscore=1501
 impostorscore=0 suspectscore=0 mlxlogscore=901 lowpriorityscore=0
 phishscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009150141
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/15/20 8:33 AM, Jakub Kicinski wrote:
> On Mon, 14 Sep 2020 11:46:30 -0700 Yonghong Song wrote:
>> Currently, we use bucket_lock when traversing bpf_sk_storage_map
>> elements. Since bpf_iter programs cannot use bpf_sk_storage_get()
>> and bpf_sk_storage_delete() helpers which may also grab bucket lock,
>> we do not have a deadlock issue which exists for hashmap when
>> using bucket_lock ([1]).
>>
>> If a bucket contains a lot of sockets, during bpf_iter traversing
>> a bucket, concurrent bpf_sk_storage_{get,delete}() may experience
>> some undesirable delays. Using rcu_read_lock() is a reasonable
>> compromise here. Although it may lose some precision, e.g.,
>> access stale sockets, but it will not hurt performance of other
>> bpf programs.
>>
>> [1] https://lore.kernel.org/bpf/20200902235341.2001534-1-yhs@fb.com
>>
>> Cc: Martin KaFai Lau <kafai@fb.com>
>> Signed-off-by: Yonghong Song <yhs@fb.com>
> 
> Sparse is not happy about it. Could you add some annotations, perhaps?
> 
> include/linux/rcupdate.h:686:9: warning: context imbalance in 'bpf_sk_storage_map_seq_find_next' - unexpected unlock
> include/linux/rcupdate.h:686:9: warning: context imbalance in 'bpf_sk_storage_map_seq_stop' - unexpected unlock

Okay, I will try.

On my system, sparse is unhappy and core dumped....

/data/users/yhs/work/net-next/include/linux/string.h:12:38: error: too 
many errors
/bin/sh: line 1: 2710132 Segmentation fault      (core dumped) sparse 
-D__linux__ -Dlinux -D__STDC__ -Dunix
-D__unix__ -Wbitwise -Wno-return-void -Wno-unknown-attribute 
-D__x86_64__ --arch=x86 -mlittle-endian -m64 -W
p,-MMD,net/core/.bpf_sk_storage.o.d -nostdinc -isystem
...
/data/users/yhs/work/net-next/net/core/bpf_sk_storage.c
make[3]: *** [net/core/bpf_sk_storage.o] Error 139
make[3]: *** Deleting file `net/core/bpf_sk_storage.o'

-bash-4.4$ rpm -qf /bin/sparse
sparse-0.5.2-1.el7.x86_64
-bash-4.4$
