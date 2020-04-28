Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15F8D1BC5C3
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 18:51:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728300AbgD1QvM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 12:51:12 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:24348 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728084AbgD1QvM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 12:51:12 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03SGoq4N013315;
        Tue, 28 Apr 2020 09:50:57 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=XViILeR1ZFvsNB2mGzPe+Vo5jGAgdugWqPjXtYLk4RA=;
 b=qhqZpuE8dcMC8xUs0DVlbNx/st01dlAAu2B2FGoyCTEIsgdsAz3lhajkRmJtSgBSMXQT
 GDMjZUNUqjozLdW8pKODWxB32oKkkVtj1/YraZS85+0heqQHs7VkETyn4YFa/g9wBDZP
 LcWZS0iwG+6QzEOF9/N6RSS37l6KaaaEOfs= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 30pq0d8kga-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 28 Apr 2020 09:50:57 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Tue, 28 Apr 2020 09:50:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OjNF5a3L6GQvEX0id5uBny4GYqrFdEcIKlFJlakjvtOIajjlHXfUJISicMY3FgCWMvxfWvGh57WtbcoKTcnxeILPshf+JbO79rJDrCh45ssvapolxETM7g4emnQXDM19yeGCb/uTfU42RA+p8NkaHBsWqNLiAmc87y2ki3jLE+CjgJRiJ6/4B1BSjeWwO3D9KfK10kOcgRF5yL0CFfxPnQ9rp8T7Wy7C97MmQRkFNvhaQqSL3rMkbtavZXPwXuqd3OAxAZ0qzz+SsGGA+Px9tz5kb4EUVMfkqBd48Jr+N70Gn+606eA3VULW/SV9LYC6C21g/d+O00OELdy6RfA1FQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XViILeR1ZFvsNB2mGzPe+Vo5jGAgdugWqPjXtYLk4RA=;
 b=UmnPuaPTZaqoKIVh0PFlVEiJ0r/UOJ2iXeNN+SDjsbB2QYaj0d10Pk5Ho5EdjlNSUJroO97NQ9+5Xe6mNJswt/I6eHJpsWMaHRHoxrT3WYTKnwNUG8besxPmNFJHm4PQmuBDevykp2E4eW28fGu667jmY1cQI21ySZUUNNdVw5S6twsuchrdDBT+CiJ3HKAwSj+L2vTeVmdEWmgOOMp2TuPwNydGme76TdtHMzopRMVyR6tdRlIF6P/H3UlYDYEqGk/y37bXMWbeZo5CM8GBEz+UfeDUsDjQ0x0RTmjhduW3wLt4zcddDOy+K+eSedvk62PxmvXQg4JvZs6kVhABDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XViILeR1ZFvsNB2mGzPe+Vo5jGAgdugWqPjXtYLk4RA=;
 b=QBpdI6k8abLhmre7K3hp/1lID++dir/vhYjwiuzpME7cB3v+3y+ZtIT0aq3ag/oN6Zj8B6flBMIDzeUkQX6xsAkWgAQ+pGMv73gunqJyw5NlB/4YgWhc7jP2xEWWhIBIHuOFMaE4+zYotL2kAupdtIUsifN3EvBlIaiMCQ0Byl4=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2693.namprd15.prod.outlook.com (2603:10b6:a03:155::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.22; Tue, 28 Apr
 2020 16:50:47 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8988:aa27:5d70:6923]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8988:aa27:5d70:6923%5]) with mapi id 15.20.2937.023; Tue, 28 Apr 2020
 16:50:47 +0000
Subject: Re: [PATCH bpf-next v1 02/19] bpf: implement an interface to register
 bpf_iter targets
To:     Martin KaFai Lau <kafai@fb.com>
CC:     Andrii Nakryiko <andriin@fb.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>
References: <20200427201235.2994549-1-yhs@fb.com>
 <20200427201236.2994722-1-yhs@fb.com>
 <20200428162024.72iaga3a63hizctg@kafai-mbp>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <243e3179-c1cc-4633-4d3f-84b070dea627@fb.com>
Date:   Tue, 28 Apr 2020 09:50:43 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
In-Reply-To: <20200428162024.72iaga3a63hizctg@kafai-mbp>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CO2PR07CA0058.namprd07.prod.outlook.com (2603:10b6:100::26)
 To BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from MacBook-Pro-52.local (2620:10d:c090:400::5:4420) by CO2PR07CA0058.namprd07.prod.outlook.com (2603:10b6:100::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13 via Frontend Transport; Tue, 28 Apr 2020 16:50:46 +0000
X-Originating-IP: [2620:10d:c090:400::5:4420]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ec0fe68f-65d1-4593-a0a6-08d7eb944caa
X-MS-TrafficTypeDiagnostic: BYAPR15MB2693:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB26932DF8027D01BBBC8FC661D3AC0@BYAPR15MB2693.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 0387D64A71
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(396003)(39860400002)(136003)(376002)(346002)(366004)(6486002)(86362001)(186003)(6636002)(6512007)(8936002)(52116002)(16526019)(6666004)(2906002)(4326008)(36756003)(6862004)(6506007)(53546011)(5660300002)(31686004)(478600001)(37006003)(66946007)(66476007)(66556008)(8676002)(316002)(31696002)(2616005)(54906003);DIR:OUT;SFP:1102;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1Thv+jRf4EKu1FXyqdhQO6mAtQH1h/pjStjHgISXn9+8+Db8AHTfVnTWhI4AJ1lr9TBW49Z9zN/gLvGxgZcnvK2OFnfRShHEP8qD7sA8qG4Uut5C57IdNZRtVGRDDRmzjogTjY1PfXGNEUXNveXYc3UV/Rdh7pt0jig3LsS2SVAnesqJ7/t+tEmnpM9WJkSaHWavfNyslrHS9hH5fV2JL/7Vma0BOztN55Hp4yBURP87dKGJNZOk0Y0zmhpNk8HQJ/Tx/nshUWJMsYcjLZADKJaV4jlkbw1LLRC3Pn/0yxaWdmvq0wgf1FlUqS6kZ5ItCihyJMvSUpzZ7x8fi/RfT8oqVw+x6qq3HBAuCs8hV3Byw12sSihDcK3xkJa8Z9Ljc5BnBRmqAB7Yb8Uc7rn9hStWQpEZxT4/1tGVXHvNIBm02wXxnQSZqj+jG1M64eYE
X-MS-Exchange-AntiSpam-MessageData: DkK1+OMUhyNWK3VhYsCtFoIIuW9XJ4mOAr2IzPLCmmwrozkWIph+CudDigHyIpqQleyOZqps+MIXm6Cr0an70N1H7gWeJJTta+klKmor+BnRL/TVA1/hxOptL3CTEvWkAXAEbtW/BMkm4fYbVwRKzSyfKezfnMIV6ttiVCvdRtzSwLa0aZ6urcufpucM85qMotFcdZzR0Glls+KeXrQPVKaSma0idRjAMvRZD0dXSXATYdA3NNRtvyxZ0PHusutRkRCLpIYWrqvwwMquE/XmOwDHcKC/7/8h2ZZoVc27nScJqb/OTkI31VkRIFyHvXI3ax9NjW1Ed6VtWORUcWPAxr6K2WafHb/CP/Mbp7qZSuco1E096OvpmJJp2Y9Jv3bmHT4K+cXIiysLCiTNuyo5lFrM6nq/ROyAqsJ1ii5zW/QfeMOzGLiXRfLkb++rGSz7Zn2YUvTaGh+x0NOKIUBv4ptdVYPD88TeQ9a0HrEuCB57L2bpd5ksc3YI9eWtHiSmDCA5smqr/vW1+dXrKJyjIF6s25xtpGbOQXQIbW+Y2WwcdCdzgPI6VtXRcaV823kZknrQxb9gh6eeHo9x/S4Ipc8hmC/zc50lXjzpbDlxuUNrcqTg0g37Zs3i9fPB3ul3cLHvfjxDnt0GABzlXiRETwQCMzunEeM2PFp8rs09Q6+e2kncJHSqXygH82GHmtrSYd3t+9nEYNLNL9lT56FKc9dciwds43fntSRo72d6ZtkVab9fv7WyMg5grGRku0ck2EyId6OYnwcY9FDrNEfSUFvjbhYtHUPcuNJUSjNbq3CwLxQN+IexOqCeeukM6cPHACnzhxejDkxWUAIil5ypvg==
X-MS-Exchange-CrossTenant-Network-Message-Id: ec0fe68f-65d1-4593-a0a6-08d7eb944caa
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2020 16:50:47.2411
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7kUnB8kRE4pdJ4yaSZlIRsOQHD++QrTUuf7WA8etAcj585P66/txW3vC7xHkg5xT
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2693
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-28_11:2020-04-28,2020-04-28 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 priorityscore=1501 clxscore=1015 adultscore=0 lowpriorityscore=0
 impostorscore=0 malwarescore=0 bulkscore=0 spamscore=0 mlxscore=0
 mlxlogscore=999 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2004280133
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/28/20 9:20 AM, Martin KaFai Lau wrote:
> On Mon, Apr 27, 2020 at 01:12:36PM -0700, Yonghong Song wrote:
>> The target can call bpf_iter_reg_target() to register itself.
>> The needed information:
>>    target:           target name, reprsented as a directory hierarchy
>>    target_func_name: the kernel func name used by verifier to
>>                      verify bpf programs
>>    seq_ops:          the seq_file operations for the target
>>    seq_priv_size:    the private_data size needed by the seq_file
>>                      operations
>>    target_feature:   certain feature requested by the target for
>>                      bpf_iter to prepare for seq_file operations.
>>
>> A little bit more explanations on the target name and target_feature.
>> For example, the target name can be "bpf_map", "task", "task/file",
>> which represents iterating all bpf_map's, all tasks, or all files
>> of all tasks.
>>
>> The target feature is mostly for reusing existing seq_file operations.
>> For example, /proc/net/{tcp6, ipv6_route, netlink, ...} seq_file private
>> data contains a reference to net namespace. When bpf_iter tries to
>> reuse the same seq_ops, its seq_file private data need the net namespace
>> setup properly too. In this case, the bpf_iter infrastructure can help
>> set up properly before doing seq_file operations.
>>
>> Signed-off-by: Yonghong Song <yhs@fb.com>
>> ---
>>   include/linux/bpf.h   | 11 ++++++++++
>>   kernel/bpf/Makefile   |  2 +-
>>   kernel/bpf/bpf_iter.c | 50 +++++++++++++++++++++++++++++++++++++++++++
>>   3 files changed, 62 insertions(+), 1 deletion(-)
>>   create mode 100644 kernel/bpf/bpf_iter.c
>>
>> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
>> index 10960cfabea4..5e56abc1e2f1 100644
>> --- a/include/linux/bpf.h
>> +++ b/include/linux/bpf.h
>> @@ -31,6 +31,7 @@ struct seq_file;
>>   struct btf;
>>   struct btf_type;
>>   struct exception_table_entry;
>> +struct seq_operations;
>>   
>>   extern struct idr btf_idr;
>>   extern spinlock_t btf_idr_lock;
>> @@ -1109,6 +1110,16 @@ struct bpf_link *bpf_link_get_from_fd(u32 ufd);
>>   int bpf_obj_pin_user(u32 ufd, const char __user *pathname);
>>   int bpf_obj_get_user(const char __user *pathname, int flags);
>>   
>> +struct bpf_iter_reg {
>> +	const char *target;
>> +	const char *target_func_name;
>> +	const struct seq_operations *seq_ops;
>> +	u32 seq_priv_size;
>> +	u32 target_feature;
>> +};
>> +
>> +int bpf_iter_reg_target(struct bpf_iter_reg *reg_info);
>> +
>>   int bpf_percpu_hash_copy(struct bpf_map *map, void *key, void *value);
>>   int bpf_percpu_array_copy(struct bpf_map *map, void *key, void *value);
>>   int bpf_percpu_hash_update(struct bpf_map *map, void *key, void *value,
>> diff --git a/kernel/bpf/Makefile b/kernel/bpf/Makefile
>> index f2d7be596966..6a8b0febd3f6 100644
>> --- a/kernel/bpf/Makefile
>> +++ b/kernel/bpf/Makefile
>> @@ -2,7 +2,7 @@
>>   obj-y := core.o
>>   CFLAGS_core.o += $(call cc-disable-warning, override-init)
>>   
>> -obj-$(CONFIG_BPF_SYSCALL) += syscall.o verifier.o inode.o helpers.o tnum.o
>> +obj-$(CONFIG_BPF_SYSCALL) += syscall.o verifier.o inode.o helpers.o tnum.o bpf_iter.o
>>   obj-$(CONFIG_BPF_SYSCALL) += hashtab.o arraymap.o percpu_freelist.o bpf_lru_list.o lpm_trie.o map_in_map.o
>>   obj-$(CONFIG_BPF_SYSCALL) += local_storage.o queue_stack_maps.o
>>   obj-$(CONFIG_BPF_SYSCALL) += disasm.o
>> diff --git a/kernel/bpf/bpf_iter.c b/kernel/bpf/bpf_iter.c
>> new file mode 100644
>> index 000000000000..1115b978607a
>> --- /dev/null
>> +++ b/kernel/bpf/bpf_iter.c
>> @@ -0,0 +1,50 @@
>> +// SPDX-License-Identifier: GPL-2.0-only
>> +/* Copyright (c) 2020 Facebook */
>> +
>> +#include <linux/fs.h>
>> +#include <linux/filter.h>
>> +#include <linux/bpf.h>
>> +
>> +struct bpf_iter_target_info {
>> +	struct list_head list;
>> +	const char *target;
>> +	const char *target_func_name;
>> +	const struct seq_operations *seq_ops;
>> +	u32 seq_priv_size;
>> +	u32 target_feature;
>> +};
>> +
>> +static struct list_head targets;
>> +static struct mutex targets_mutex;
>> +static bool bpf_iter_inited = false;
> The "!bpf_iter_inited" test below is racy.

Yes, as mentioned in the comments, all currently implemented
targets are called at __init stage (do_basic_setup()->do_initcalls()),
I think there is no race here. But looking at the
code again, I am not so sure about my assumption any more.

> 
> LIST_HEAD_INIT and DEFINE_MUTEX can be used instead.

Will use these macros instead. Thanks!

> 
>> +
>> +int bpf_iter_reg_target(struct bpf_iter_reg *reg_info)
>> +{
>> +	struct bpf_iter_target_info *tinfo;
>> +
>> +	/* The earliest bpf_iter_reg_target() is called at init time
>> +	 * where the bpf_iter registration is serialized.
>> +	 */
>> +	if (!bpf_iter_inited) {
>> +		INIT_LIST_HEAD(&targets);
>> +		mutex_init(&targets_mutex);
>> +		bpf_iter_inited = true;
>> +	}
