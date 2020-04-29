Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7EC31BD3E1
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 07:05:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726746AbgD2FF0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 01:05:26 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:34562 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726305AbgD2FFZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 01:05:25 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03T54uhj005400;
        Tue, 28 Apr 2020 22:05:12 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : subject : to : cc
 : references : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=040rs2jY6dsEuiTGt+HCR3BRe6WaTvQ2oEtibkbL2wQ=;
 b=JVZmqjac7NhfvU86OTXeDRso6+C2P3ejnE7EYnZvBrUGyKYIboNPg3uZqp+al+tZ4l1o
 PNJODd8G+ypzAwHhwcW48t2VY/kpL5USd1OO+Kzz/nnoDrkGxtI9B2fNwYBb9MCVtfbq
 63XzyBbGadMl/ZiZ2L2KrZXg2hEuXGBpcwI= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 30nq53yw6w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 28 Apr 2020 22:05:12 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Tue, 28 Apr 2020 22:05:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e/plCZlobrZSpFkB04j1Rov92jOpf321N6MLFEaGUY0HrG4zFYW16+01tmL15ZKhVfpza656VfxX/8TxXykuKCYQUQjwpgLGlsOnCkckvRSkIO6gM/pnCI8PJaetlNAVSkDUlDA1srgKvmwHzQWR/yFLnC6vIdn9MM1ZUPplMMMMRaaK1ChN2yPdnA7jXsJSJqdZ2bfv+TKd4NZEO5ngmndLHUf5eD/gtTW0QDl0osfT4WLxeeEBZE6IoZ7+Dyt7RYs468D0/jk1SPpy6zjNLp72uGjMlTCsRIeWxABuK6fgYpVpm8WCzp/xGq0BMtdvWz36dFDlQILJw2yL5q8O3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=040rs2jY6dsEuiTGt+HCR3BRe6WaTvQ2oEtibkbL2wQ=;
 b=HowlTxCBDDtyF6wWLXg+FnM+m7eMl+eznvjjG09bjayqVdN07XVqlbAE5O63c5fvI2LW4pOgdIGouOFkfa5PgjSScgy1zD8IJqhEDq8M/HArDfWnGuiVhGvATTSOIf1kJmURe4FrVik+ou38Q1JaVaZCs7kzA4KlJ7rdfiKDgxcnH4EAkdd9Auy24neFlCp7Gzl3QL7JI02xOSknVEEkDj50SuDCpkbPkbQ4hTEOa1H6W4Y4hTXKOUgKBSakjSpXXtk/yBnSCIbRUpdIc7+gnQR4U5z6gR0cGhUmDvJWGQdFuAAYRkOnI3lw1z2Fg9tv9UTT17Lr+OFT5YbkyaJJ8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=040rs2jY6dsEuiTGt+HCR3BRe6WaTvQ2oEtibkbL2wQ=;
 b=j/uj/58e+/qkKvOHBamHRU40WaPQuS7df8dcGRKzOavolWAG3dNTOusxk8JfzBE8xqKw6a6EwwXj/NJOcJxmp2vsW+JGPMANHF9b8v28viOYYiPXnaZJvXHqjQ70JZ1e2tKE9n4Ibj8mi3qiWZ5VXMdteKJoEhe04j0hzytUtSA=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2485.namprd15.prod.outlook.com (2603:10b6:a02:85::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.22; Wed, 29 Apr
 2020 05:05:09 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8988:aa27:5d70:6923]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8988:aa27:5d70:6923%5]) with mapi id 15.20.2937.023; Wed, 29 Apr 2020
 05:05:09 +0000
From:   Yonghong Song <yhs@fb.com>
Subject: Re: [PATCH bpf-next v1 06/19] bpf: support bpf tracing/iter programs
 for BPF_LINK_UPDATE
To:     Martin KaFai Lau <kafai@fb.com>
CC:     Andrii Nakryiko <andriin@fb.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>
References: <20200427201235.2994549-1-yhs@fb.com>
 <20200427201241.2995075-1-yhs@fb.com>
 <20200429013239.apxevcpdc3kpqlrq@kafai-mbp>
Message-ID: <f63cd9f5-a39e-1fc8-bba3-53ebffef9cc5@fb.com>
Date:   Tue, 28 Apr 2020 22:04:54 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
In-Reply-To: <20200429013239.apxevcpdc3kpqlrq@kafai-mbp>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MWHPR04CA0061.namprd04.prod.outlook.com
 (2603:10b6:300:6c::23) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from macbook-pro-52.local.dhcp.thefacebook.com (2620:10d:c090:400::5:e9ab) by MWHPR04CA0061.namprd04.prod.outlook.com (2603:10b6:300:6c::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.19 via Frontend Transport; Wed, 29 Apr 2020 05:05:08 +0000
X-Originating-IP: [2620:10d:c090:400::5:e9ab]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c5757cf1-abab-4974-adca-08d7ebfae3c6
X-MS-TrafficTypeDiagnostic: BYAPR15MB2485:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB2485F29BEF1A812C0B4BC2D2D3AD0@BYAPR15MB2485.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-Forefront-PRVS: 03883BD916
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(376002)(396003)(39860400002)(136003)(346002)(366004)(31686004)(36756003)(54906003)(316002)(2906002)(6666004)(478600001)(6486002)(6636002)(2616005)(8676002)(86362001)(37006003)(6512007)(6506007)(8936002)(4326008)(31696002)(5660300002)(52116002)(16526019)(6862004)(66946007)(66476007)(66556008)(186003)(53546011);DIR:OUT;SFP:1102;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MoXsrjvREgsshgQNFqGjhfDmJNrdytCbEqLkIVPQHT/Hbwcc41m2vnDFqdcazaKXeKjWkuW8M3GLXWP7xZMYdmP4lzwtbwJzwvUKBR5Z0o4NJbuWDUBOF3QS0ctn5EjLc0HhU8Ynsgn+0dZM7WloAFwVcFb9SoSc6qHvUG9+6dvt970K28MWEEDidWPckv9Y9dj7T2eTqDIm0K3u96KS2Y4JxcyLsKNhEFra/OUpukQ8JDjzkmFFmlD/SHwRPj4gUdkOoqd+YhxmuKVKjx3eA/9GU6jQ1MOlm+3PzCv+11+e6iKgoF+lEKeW399v8f4Km0rvSIj1SCELYOQH6t8z4l407gjQ+/3FlKFVPAjRqvhPX636/Q6ADxCRqhhYQqhFdGEuMIkqmHqwvqhS3fgn7TtZ89saWTdnUlJNBv+2EQ+h9OXamJt8KYEPxkNPnj96
X-MS-Exchange-AntiSpam-MessageData: Q6ZjvoDb+WFWbKApnqv3XwGmlvlI71KZH52qr3silBMFs6re+5nVJzatT00zWEGx76N4dAkoncYwp/ec12BggIa7914wQ1340dNGiOCp9bJzwckYOVda+U0xONjdSphUnhilHFZNu2aurSSHo6TonbrVDk6yIwArl7TuJ0jPJsQGUMAYByoC8/NunM3avrz3ASLxstKp/tsyilnIO7yI3ftwADCExfh5W9qlnjMczFKrUA0TisH2I342Tog0GmvlbheoLTs7pgSCzO0WVDeU9U737I9zy1dey2NRoXVycfG3coe8/uqGZBu9LcivvM1UIfenQa4hm87tSPl5Yf863ncXB+lwhVBNSdCgA5NR/P7Z9wmIpc0fTLsWDzB9Hy5MS3i4jPN1rRJo4yHpaml69cUWrBxQPUwx4wD3kSELcuiPKj4C+b+P+TRnmf9sHq7MMZU0MRoftXK/Surg1sd+bA2eaaLOMruSaK1xKk9fUDVpLvqh8WcKU3bdHQN0djnQCWvBwzZ6QZxamlKg46BcQnH21u78ENHYftL71SZ8QHNMKwRjZnTnV44ElUJpySeTh/4vZePwSA4UPO3IJu+iM0GIkPiSuYOz/G54kYMXqZGPjrUujS7nLATCFAT/rN07/UHgqTrfcaRAlKHS2VUPzqxKZV/+xR59NvZOdZgZvLSbVI/aoEMbz9vm1HsxmnC1Rx2M4lpravHtV+XkCnl+mx6hz9nkBv+D/4xxKnmabmY94OZ2hBZ+XR8RQkRQjRlJ59SNKLgk+0mx6ONO/oSuLsK4G63QtI+RgrqlDcjdHjAebBaZp2QzIhPyU5JJnpprh7R3k1q+S79Bu2rixt144A==
X-MS-Exchange-CrossTenant-Network-Message-Id: c5757cf1-abab-4974-adca-08d7ebfae3c6
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2020 05:05:09.4273
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ajy8v2Tqi9hN7iPKVVKYO4sCUNX8VPBs391+E3jcxW5SmzbKrHqE0vcl7jhGV0Qj
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2485
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-29_01:2020-04-28,2020-04-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 spamscore=0 lowpriorityscore=0 suspectscore=0 impostorscore=0
 priorityscore=1501 phishscore=0 bulkscore=0 malwarescore=0 adultscore=0
 mlxscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004290039
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/28/20 6:32 PM, Martin KaFai Lau wrote:
> On Mon, Apr 27, 2020 at 01:12:41PM -0700, Yonghong Song wrote:
>> Added BPF_LINK_UPDATE support for tracing/iter programs.
>> This way, a file based bpf iterator, which holds a reference
>> to the link, can have its bpf program updated without
>> creating new files.
>>
>> Signed-off-by: Yonghong Song <yhs@fb.com>
>> ---
>>   include/linux/bpf.h   |  2 ++
>>   kernel/bpf/bpf_iter.c | 29 +++++++++++++++++++++++++++++
>>   kernel/bpf/syscall.c  |  5 +++++
>>   3 files changed, 36 insertions(+)
>>
>> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
>> index 60ecb73d8f6d..4fc39d9b5cd0 100644
>> --- a/include/linux/bpf.h
>> +++ b/include/linux/bpf.h
>> @@ -1131,6 +1131,8 @@ struct bpf_prog *bpf_iter_get_prog(struct seq_file *seq, u32 priv_data_size,
>>   				   u64 *session_id, u64 *seq_num, bool is_last);
>>   int bpf_iter_run_prog(struct bpf_prog *prog, void *ctx);
>>   int bpf_iter_link_attach(const union bpf_attr *attr, struct bpf_prog *prog);
>> +int bpf_iter_link_replace(struct bpf_link *link, struct bpf_prog *old_prog,
>> +			  struct bpf_prog *new_prog);
>>   
>>   int bpf_percpu_hash_copy(struct bpf_map *map, void *key, void *value);
>>   int bpf_percpu_array_copy(struct bpf_map *map, void *key, void *value);
>> diff --git a/kernel/bpf/bpf_iter.c b/kernel/bpf/bpf_iter.c
>> index 9532e7bcb8e1..fc1ce5ee5c3f 100644
>> --- a/kernel/bpf/bpf_iter.c
>> +++ b/kernel/bpf/bpf_iter.c
>> @@ -23,6 +23,9 @@ static struct list_head targets;
>>   static struct mutex targets_mutex;
>>   static bool bpf_iter_inited = false;
>>   
>> +/* protect bpf_iter_link.link->prog upddate */
>> +static struct mutex bpf_iter_mutex;
>> +
>>   int bpf_iter_reg_target(struct bpf_iter_reg *reg_info)
>>   {
>>   	struct bpf_iter_target_info *tinfo;
>> @@ -33,6 +36,7 @@ int bpf_iter_reg_target(struct bpf_iter_reg *reg_info)
>>   	if (!bpf_iter_inited) {
>>   		INIT_LIST_HEAD(&targets);
>>   		mutex_init(&targets_mutex);
>> +		mutex_init(&bpf_iter_mutex);
>>   		bpf_iter_inited = true;
>>   	}
>>   
>> @@ -121,3 +125,28 @@ int bpf_iter_link_attach(const union bpf_attr *attr, struct bpf_prog *prog)
>>   		kfree(link);
>>   	return err;
>>   }
>> +
>> +int bpf_iter_link_replace(struct bpf_link *link, struct bpf_prog *old_prog,
>> +			  struct bpf_prog *new_prog)
>> +{
>> +	int ret = 0;
>> +
>> +	mutex_lock(&bpf_iter_mutex);
>> +	if (old_prog && link->prog != old_prog) {
>> +		ret = -EPERM;
>> +		goto out_unlock;
>> +	}
>> +
>> +	if (link->prog->type != new_prog->type ||
>> +	    link->prog->expected_attach_type != new_prog->expected_attach_type ||
>> +	    strcmp(link->prog->aux->attach_func_name, new_prog->aux->attach_func_name)) {
> Can attach_btf_id be compared instead of strcmp()?

Yes, we can do it.

> 
>> +		ret = -EINVAL;
>> +		goto out_unlock;
>> +	}
>> +
>> +	link->prog = new_prog;
> Does the old link->prog need a bpf_prog_put()?

The old_prog is replaced in caller link_update (syscall.c):
static int link_update(union bpf_attr *attr)
{
         struct bpf_prog *old_prog = NULL, *new_prog;
         struct bpf_link *link;
         u32 flags;
         int ret;
...
         if (link->ops == &bpf_iter_link_lops) {
                 ret = bpf_iter_link_replace(link, old_prog, new_prog);
                 goto out_put_progs;
         }
         ret = -EINVAL;

out_put_progs:
         if (old_prog)
                 bpf_prog_put(old_prog);
...

> 
>> +
>> +out_unlock:
>> +	mutex_unlock(&bpf_iter_mutex);
>> +	return ret;
>> +}
