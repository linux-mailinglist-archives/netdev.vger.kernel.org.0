Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86B471BD17F
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 03:03:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726386AbgD2BDC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 21:03:02 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:39262 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726363AbgD2BDC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 21:03:02 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03T0sR3j021947;
        Tue, 28 Apr 2020 18:02:48 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=YiLLm+WPPb9gkelgXWtvpNwS79wUc7W9N4B/A3sCT6U=;
 b=GezYGojIYdTXAJKVQXy90z5JbDcGhMib+buklsqQHD/RzqdZ5251zNWIecYGLBKIYGdi
 KDqspwyN2lJE7wRNxvFwVMpXUJOg4NNcRzLUu2VozWleCiQQKl9i0JrtjFMHCC3eRVl3
 cwtjZNcb4KEyVVQZ6MyhNDLSTF0FrPsft9M= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 30n54ek52f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 28 Apr 2020 18:02:48 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Tue, 28 Apr 2020 18:02:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HLgPvCBYvh/MSV+eYocFSN9M/ZdmUvNEdJDFm1H3Rn1O+XtNtVlXxtlHi7hm+37XB0gv+c3tJptPtlm4b20tW1pf83NcbafsT1MAn+WkOtkJfkqskwQtbC27HBCmqQ/0yKiUdDUe+Wl7jNN/BXtH1+1wjzSYPtvi5LTgrgOHTBaqsAoFYOyfAX6RWYIvkNP9ywZMUodjyVDQ331SpMQsY4QjMgU1cN/9YlIXZr+20lIHJPC3aQx+z3+bTGlXFhfTuPABc3c86kdPaQiV5QZ/Q6cWndvL1OP6Cb6ZSGFL1b8ZATYswnXL5UxI3tjJx7QDuJTvzXAOBab4UwpLA1ebVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YiLLm+WPPb9gkelgXWtvpNwS79wUc7W9N4B/A3sCT6U=;
 b=Id3HZamu7zTv1O9jzxgulKbIn3JwFWRQgo3GglL7NiVE+24hNuUmGPcstXlNke94y7oG83z6tcEaRQfQCHPYaQvLIMYKc5SoIiq//V1PIJfyuSEaJXMgycoG+Ir1fyoc2OmyDwt6nfQZOLBJF0hhxYKfh9Q504R9ys2kBu6fAkuvMwfbITE7NPM/C+80kGwjEP6BE239WXPfUQyzxeDnfMSXotJsnRRKP6IZbNGihuCTrpiitMi08blUivHFdIJbpyOfaWZLZG/kVThs+IvfWE92fQWDej/tsDoWZkbuCnmHplXj3TJLyfFIHTPIWtZtdRVlXK21q34pdkM5/3/hHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YiLLm+WPPb9gkelgXWtvpNwS79wUc7W9N4B/A3sCT6U=;
 b=GOpCaRZq1xtmk2y9GV8vLIXdz8MpnkSHbExA/28IJOQnTQ9zc0g4uSg+W1Gf1Yr07s8HDzjuwmvOSXtQC25JelpCF0hTAFcrTt7/nq8QAS8fmCAtj1FT2EjvQgU0uTaCLrKHcLKInxHndQhiU315er0r2lEkXoM6OVa3Fo3A8LE=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2888.namprd15.prod.outlook.com (2603:10b6:a03:b5::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.22; Wed, 29 Apr
 2020 01:02:44 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8988:aa27:5d70:6923]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8988:aa27:5d70:6923%5]) with mapi id 15.20.2937.023; Wed, 29 Apr 2020
 01:02:44 +0000
Subject: Re: [PATCH bpf-next v1 03/19] bpf: add bpf_map iterator
To:     Martin KaFai Lau <kafai@fb.com>
CC:     Andrii Nakryiko <andriin@fb.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>
References: <20200427201235.2994549-1-yhs@fb.com>
 <20200427201237.2994794-1-yhs@fb.com>
 <20200429003738.pv4flhdaxpg66wiv@kafai-mbp>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <9ea9f74a-f0db-9ecb-acba-ff4f4c198615@fb.com>
Date:   Tue, 28 Apr 2020 18:02:40 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
In-Reply-To: <20200429003738.pv4flhdaxpg66wiv@kafai-mbp>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CO1PR15CA0070.namprd15.prod.outlook.com
 (2603:10b6:101:20::14) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from macbook-pro-52.local.dhcp.thefacebook.com (2620:10d:c090:400::5:2258) by CO1PR15CA0070.namprd15.prod.outlook.com (2603:10b6:101:20::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.19 via Frontend Transport; Wed, 29 Apr 2020 01:02:42 +0000
X-Originating-IP: [2620:10d:c090:400::5:2258]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 843321cb-232e-4e94-ca84-08d7ebd90605
X-MS-TrafficTypeDiagnostic: BYAPR15MB2888:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB2888391F592F8EC7CBC748AED3AD0@BYAPR15MB2888.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-Forefront-PRVS: 03883BD916
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(366004)(346002)(376002)(136003)(39860400002)(396003)(66556008)(66946007)(478600001)(66476007)(316002)(36756003)(52116002)(6506007)(53546011)(5660300002)(2906002)(16526019)(37006003)(8936002)(6512007)(6862004)(31696002)(54906003)(8676002)(6486002)(6636002)(2616005)(4326008)(186003)(86362001)(31686004);DIR:OUT;SFP:1102;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cty55vdvYSPQ2Pyv/omyK3+6EQ8nfwf1zynpuxBg3gLBHxSGqlvq4PNOqVo2IWM+Nh1jEQoCDrtHGnm+ruDI0cd2FFXVn2uDl2a8UufblX6vMPFqAUWQiCr1D9YDNBBSElOrIf0ECG2/WA72JnsrbhgSsDIPK+82ymQxJJIu+zAPRb6JEAkkcsxQgl0xtCIeLzSAJc54j9B5rO890U6ZLfD7Pt2q1qsJh7UNx9A9uxY6lLf4MKJQGpifSZACHJ775/13mxSFy0fc6u5uSrI3uu/L1qbmvzjA23Dipan3AHADDEhQrW8aQ8tqR+frpG0S6gdOkaBW6Iu/A1PUpvUi5k4TJzNrxHtVMe1yd5WO/oMfoKDZOYyZH9zJEx3/IQriHjIEwyQKYhQTgbLomSDoo1ZXdFjSLRjIxaC7iULvD4okozZv2Ls66vPaCrOV/h8j
X-MS-Exchange-AntiSpam-MessageData: +tTf7l/HW7FVbjzidKe44QgCeTPYFmcCjxi8PaG3P1FyMnaOFiTEXg5GbnymD+igvmI6858rBgpSUM0C3iqn+dorNivbnjLocuyPymEJ8Ti4aFguZolzdJNYwkrjcjYsB0Hdr8d8KNe6OMYfsV/44x3AaAMUYUbDTodsAmoQSA4CoVY/H8O1bFj61e1pZlIG703FQMfUnbvZ7W0wq8/rJArNgflJkVCvQDahjuK1FTI0V5RxJcNFypxOYkDR7xO7qbIEz1/+KePzdgLgDJEHpjxUQNkRPbGxv0O5t4VOoa+ztG5ix2OGhRbvE+VGsIgobcNx1ECgnRqFF7pPCZApv+NdyVyf1sxggQQc0xnZ2jgsZ5s4cUVkr09aIUOc+s891gWYUl8L87rz5FDeoF8Qhpxx6byDz9qve2dHgUxm1DTyZRY4MTt5cz/yyhOl+LYT9n47mvvpxKcSccUCXYUaTr8WNlFmCVQ1xp+dma+CVBPrfF/wTT2SE47PTvYk+RchwfPR+1TjLGlQWU1CbF+gtnCdW2ToFhUOxbC+WSDNQdIR7w3fopW2sJse235XwuSnGyAZWHcSFSNxfvZwtJdMFZ05l0BwpwxdVZOuvWRvby+0GIPJTraDLzhAjCp3YmMfqxYtNtsUWuAslycaLoDOqGhWw8l2VUSQ3ZUpsiKcrQ2fRdRUwC4hLEGbUV9D1Y8//4vQejYfF8Vc6vd3J0i+Ze2k/FoKtkQFMW2iigvuPl/f8JJP8qgU0KYStDSvYwUQhPgOudACVN3DVWe0ZV42oay2cg0JTrwHBOxMMNUP5lcgIZ8Iu9hebay9SH1lnLK/K42torhhCDwLENeRjNxJRA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 843321cb-232e-4e94-ca84-08d7ebd90605
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2020 01:02:43.9766
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HYGZmLmt8uz+8VK3LqHGsrlZFnHo6tBT7iqOLdDNEo+mSsvmP37JvNV/HIYhelUI
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2888
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-28_15:2020-04-28,2020-04-28 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 priorityscore=1501 suspectscore=0 spamscore=0 impostorscore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 adultscore=0 malwarescore=0
 clxscore=1015 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2004290004
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/28/20 5:37 PM, Martin KaFai Lau wrote:
> On Mon, Apr 27, 2020 at 01:12:37PM -0700, Yonghong Song wrote:
>> The bpf_map iterator is implemented.
>> The bpf program is called at seq_ops show() and stop() functions.
>> bpf_iter_get_prog() will retrieve bpf program and other
>> parameters during seq_file object traversal. In show() function,
>> bpf program will traverse every valid object, and in stop()
>> function, bpf program will be called one more time after all
>> objects are traversed.
>>
>> The first member of the bpf context contains the meta data, namely,
>> the seq_file, session_id and seq_num. Here, the session_id is
>> a unique id for one specific seq_file session. The seq_num is
>> the number of bpf prog invocations in the current session.
>> The bpf_iter_get_prog(), which will be implemented in subsequent
>> patches, will have more information on how meta data are computed.
>>
>> The second member of the bpf context is a struct bpf_map pointer,
>> which bpf program can examine.
>>
>> The target implementation also provided the structure definition
>> for bpf program and the function definition for verifier to
>> verify the bpf program. Specifically for bpf_map iterator,
>> the structure is "bpf_iter__bpf_map" andd the function is
>> "__bpf_iter__bpf_map".
>>
>> More targets will be implemented later, all of which will include
>> the following, similar to bpf_map iterator:
>>    - seq_ops() implementation
>>    - function definition for verifier to verify the bpf program
>>    - seq_file private data size
>>    - additional target feature
>>
>> Signed-off-by: Yonghong Song <yhs@fb.com>
>> ---
>>   include/linux/bpf.h   |  10 ++++
>>   kernel/bpf/Makefile   |   2 +-
>>   kernel/bpf/bpf_iter.c |  19 ++++++++
>>   kernel/bpf/map_iter.c | 107 ++++++++++++++++++++++++++++++++++++++++++
>>   kernel/bpf/syscall.c  |  13 +++++
>>   5 files changed, 150 insertions(+), 1 deletion(-)
>>   create mode 100644 kernel/bpf/map_iter.c
>>
>> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
>> index 5e56abc1e2f1..4ac8d61f7c3e 100644
>> --- a/include/linux/bpf.h
>> +++ b/include/linux/bpf.h
>> @@ -1078,6 +1078,7 @@ int  generic_map_update_batch(struct bpf_map *map,
>>   int  generic_map_delete_batch(struct bpf_map *map,
>>   			      const union bpf_attr *attr,
>>   			      union bpf_attr __user *uattr);
>> +struct bpf_map *bpf_map_get_curr_or_next(u32 *id);
>>   
>>   extern int sysctl_unprivileged_bpf_disabled;
>>   
>> @@ -1118,7 +1119,16 @@ struct bpf_iter_reg {
>>   	u32 target_feature;
>>   };
>>   
>> +struct bpf_iter_meta {
>> +	__bpf_md_ptr(struct seq_file *, seq);
>> +	u64 session_id;
>> +	u64 seq_num;
>> +};
>> +
>>   int bpf_iter_reg_target(struct bpf_iter_reg *reg_info);
>> +struct bpf_prog *bpf_iter_get_prog(struct seq_file *seq, u32 priv_data_size,
>> +				   u64 *session_id, u64 *seq_num, bool is_last);
>> +int bpf_iter_run_prog(struct bpf_prog *prog, void *ctx);
>>   
>>   int bpf_percpu_hash_copy(struct bpf_map *map, void *key, void *value);
>>   int bpf_percpu_array_copy(struct bpf_map *map, void *key, void *value);
>> diff --git a/kernel/bpf/Makefile b/kernel/bpf/Makefile
>> index 6a8b0febd3f6..b2b5eefc5254 100644
>> --- a/kernel/bpf/Makefile
>> +++ b/kernel/bpf/Makefile
>> @@ -2,7 +2,7 @@
>>   obj-y := core.o
>>   CFLAGS_core.o += $(call cc-disable-warning, override-init)
>>   
>> -obj-$(CONFIG_BPF_SYSCALL) += syscall.o verifier.o inode.o helpers.o tnum.o bpf_iter.o
>> +obj-$(CONFIG_BPF_SYSCALL) += syscall.o verifier.o inode.o helpers.o tnum.o bpf_iter.o map_iter.o
>>   obj-$(CONFIG_BPF_SYSCALL) += hashtab.o arraymap.o percpu_freelist.o bpf_lru_list.o lpm_trie.o map_in_map.o
>>   obj-$(CONFIG_BPF_SYSCALL) += local_storage.o queue_stack_maps.o
>>   obj-$(CONFIG_BPF_SYSCALL) += disasm.o
>> diff --git a/kernel/bpf/bpf_iter.c b/kernel/bpf/bpf_iter.c
>> index 1115b978607a..284c95587803 100644
>> --- a/kernel/bpf/bpf_iter.c
>> +++ b/kernel/bpf/bpf_iter.c
>> @@ -48,3 +48,22 @@ int bpf_iter_reg_target(struct bpf_iter_reg *reg_info)
>>   
>>   	return 0;
>>   }
>> +
>> +struct bpf_prog *bpf_iter_get_prog(struct seq_file *seq, u32 priv_data_size,
>> +				   u64 *session_id, u64 *seq_num, bool is_last)
>> +{
>> +	return NULL;
> Can this patch be moved after this function is implemented?

I tried to have an example on how regristration looks like,
so I put bpf_map iterator implementation patch immediately
after the bpf_iter_reg_target() patch. Unfortunately, I make
the iterator implementation complete and compiler can pass,
I need this function() to be implemented in the above.

I guess I can delay this patch until I can properly
implement it, just like my RFC v2.

> 
>> +}
>> +
>> +int bpf_iter_run_prog(struct bpf_prog *prog, void *ctx)
>> +{
>> +	int ret;
>> +
>> +	migrate_disable();
>> +	rcu_read_lock();
>> +	ret = BPF_PROG_RUN(prog, ctx);
>> +	rcu_read_unlock();
>> +	migrate_enable();
>> +
>> +	return ret;
>> +}
>> diff --git a/kernel/bpf/map_iter.c b/kernel/bpf/map_iter.c
>> new file mode 100644
>> index 000000000000..bb3ad4c3bde5
>> --- /dev/null
>> +++ b/kernel/bpf/map_iter.c
>> @@ -0,0 +1,107 @@
>> +// SPDX-License-Identifier: GPL-2.0-only
>> +/* Copyright (c) 2020 Facebook */
>> +#include <linux/bpf.h>
>> +#include <linux/fs.h>
>> +#include <linux/filter.h>
>> +#include <linux/kernel.h>
>> +
>> +struct bpf_iter_seq_map_info {
>> +	struct bpf_map *map;
>> +	u32 id;
>> +};
>> +
>> +static void *bpf_map_seq_start(struct seq_file *seq, loff_t *pos)
>> +{
>> +	struct bpf_iter_seq_map_info *info = seq->private;
>> +	struct bpf_map *map;
>> +	u32 id = info->id;
>> +
>> +	map = bpf_map_get_curr_or_next(&id);
>> +	if (IS_ERR_OR_NULL(map))
>> +		return NULL;
>> +
>> +	++*pos;
> Does pos always need to be incremented here?

Yes, I skipped passing SEQ_START_TOKEN to show(). Put it another way,
bpf program won't be called for SEQ_START_TOKEN, so I did a shortcut here.

> 
>> +	info->map = map;
>> +	info->id = id;
>> +	return map;
>> +}
>> +
>> +static void *bpf_map_seq_next(struct seq_file *seq, void *v, loff_t *pos)
>> +{
>> +	struct bpf_iter_seq_map_info *info = seq->private;
>> +	struct bpf_map *map;
>> +
>> +	++*pos;
>> +	++info->id;
>> +	map = bpf_map_get_curr_or_next(&info->id);
>> +	if (IS_ERR_OR_NULL(map))
>> +		return NULL;
>> +
>> +	bpf_map_put(info->map);
>> +	info->map = map;
>> +	return map;
>> +}
>> +
>> +struct bpf_iter__bpf_map {
>> +	__bpf_md_ptr(struct bpf_iter_meta *, meta);
>> +	__bpf_md_ptr(struct bpf_map *, map);
>> +};
>> +
>> +int __init __bpf_iter__bpf_map(struct bpf_iter_meta *meta, struct bpf_map *map)
>> +{
>> +	return 0;
>> +}
>> +
>> +static int bpf_map_seq_show(struct seq_file *seq, void *v)
>> +{
>> +	struct bpf_iter_meta meta;
>> +	struct bpf_iter__bpf_map ctx;
>> +	struct bpf_prog *prog;
>> +	int ret = 0;
>> +
>> +	ctx.meta = &meta;
>> +	ctx.map = v;
>> +	meta.seq = seq;
>> +	prog = bpf_iter_get_prog(seq, sizeof(struct bpf_iter_seq_map_info),
>> +				 &meta.session_id, &meta.seq_num,
>> +				 v == (void *)0);
>  From looking at seq_file.c, when will show() be called with "v == NULL"?

In the stop() function.

> 
>> +	if (prog)
>> +		ret = bpf_iter_run_prog(prog, &ctx);
>> +
>> +	return ret == 0 ? 0 : -EINVAL;
> The verifier change in patch 4 should have ensured that prog
> can only return 0?

Yes. I forgot to update this after last minutes I added verifier
enforcement. I can do
	if (prog)
		bpf_iter_run_prog(prog, &ctx);

	return 0;

> 
>> +}
>> +
>> +static void bpf_map_seq_stop(struct seq_file *seq, void *v)
>> +{
>> +	struct bpf_iter_seq_map_info *info = seq->private;
>> +
>> +	if (!v)
>> +		bpf_map_seq_show(seq, v);

bpf program for NULL object is called here.

>> +
>> +	if (info->map) {
>> +		bpf_map_put(info->map);
>> +		info->map = NULL;
>> +	}
>> +}
>> +
>> +static const struct seq_operations bpf_map_seq_ops = {
>> +	.start	= bpf_map_seq_start,
>> +	.next	= bpf_map_seq_next,
>> +	.stop	= bpf_map_seq_stop,
>> +	.show	= bpf_map_seq_show,
>> +};
>> +
>> +static int __init bpf_map_iter_init(void)
>> +{
>> +	struct bpf_iter_reg reg_info = {
>> +		.target			= "bpf_map",
>> +		.target_func_name	= "__bpf_iter__bpf_map",
>> +		.seq_ops		= &bpf_map_seq_ops,
>> +		.seq_priv_size		= sizeof(struct bpf_iter_seq_map_info),
>> +		.target_feature		= 0,
>> +	};
>> +
>> +	return bpf_iter_reg_target(&reg_info);
>> +}
>> +
>> +late_initcall(bpf_map_iter_init);
>> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
>> index 7626b8024471..022187640943 100644
>> --- a/kernel/bpf/syscall.c
>> +++ b/kernel/bpf/syscall.c
>> @@ -2800,6 +2800,19 @@ static int bpf_obj_get_next_id(const union bpf_attr *attr,
>>   	return err;
>>   }
>>   
>> +struct bpf_map *bpf_map_get_curr_or_next(u32 *id)
>> +{
>> +	struct bpf_map *map;
>> +
>> +	spin_lock_bh(&map_idr_lock);
>> +	map = idr_get_next(&map_idr, id);
>> +	if (map)
>> +		map = __bpf_map_inc_not_zero(map, false);
> nit. For the !map case, set "map = ERR_PTR(-ENOENT)" so that
> the _OR_NULL() test is not needed.  It will be more consistent
> with other error checking codes in syscall.c.

Good point, will do that.

> 
>> +	spin_unlock_bh(&map_idr_lock);
>> +
>> +	return map;
>> +}
>> +
>>   #define BPF_PROG_GET_FD_BY_ID_LAST_FIELD prog_id
>>   
>>   struct bpf_prog *bpf_prog_by_id(u32 id)
>> -- 
>> 2.24.1
>>
