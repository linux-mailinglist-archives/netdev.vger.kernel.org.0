Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7E691C620C
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 22:28:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729286AbgEEU2m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 16:28:42 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:8248 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728135AbgEEU2l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 16:28:41 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 045KNXdw024741;
        Tue, 5 May 2020 13:28:28 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=sibvFv+7zV6h7doKX2p8pe6tFfIzO1Ga9vaJdfg2yO0=;
 b=E1UiA/mOw2k1n6RAiIV1dHfzmeyKf8zEKCc6RKH6Q24y+TcQNObGK+bjvi0L9VtGw124
 9s/5IdO4M0+R196smnMnG0v7NeA5DaDNzkRcUgR1tsiTqgBCRXu7agO9sq4CbmHT0GR/
 b0cW1A/7xzCmFwJ/7c8J7HbbpMhcreFfrGU= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 30srsede0q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 05 May 2020 13:28:28 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.228) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Tue, 5 May 2020 13:28:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QX5tgbxcS13ZUsHaeTq00W03wz2LA4Uwxr6JqVcTLObAk8Esd1N9TEfnu6S3t/CtBKp0d6an1HRTR/Pzzdb8NHDmmZMXxXag+TVZODiLyeqMrT0dnKFyF9dOjOp0OBN9LMhFozMsoj82lhMBHxXXE1KJIM4KhoyhS/nGLRxz9TSJJpjJ/lif6aNuDzt5d6cIiVhTRpYfaaNz8magRKP21pAIdT3Llxhtiu5M/L7XWwzN2yPuxmyzF4JDtpt2St8Xb0CNQcvHEhvmIns7oH6617+1qyuoqWyHqu50+daDdBX54ECJuN/op3gqDjCDyeor30EBoqBY5TjgtcDeu6vNcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sibvFv+7zV6h7doKX2p8pe6tFfIzO1Ga9vaJdfg2yO0=;
 b=etDDQW6JKj+5A/SFnmozgIb++YEKdD9TVz9jguLbY1px8pqcCd6QMxS+b4WLvcuXcgG6cLMcwmQBT3Jo4vbL/nnd0HoAlY5mmqUxihdeXBOx6ZhaAueV5SQA493X7HPlRrBG0zOjfEuoSf8OZxzwh+vmnkQeubrG/dAM63PQf2yN4iE6MK4xz+9JRhf9lpyVoGrPRItZBiD3633qogVzQwzuJL1tPC2bFZBq+YVTaY0gi2549RzGuQDDSRl+1tRQuv7/350pn+UUvvCQAIpqUnBs6j02p11BlYwYdFZDLQLP7owKHxHcy7ka+SwB7Iqx1agky/6Wf3D+32zF+kDMTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sibvFv+7zV6h7doKX2p8pe6tFfIzO1Ga9vaJdfg2yO0=;
 b=L77oT3JLOdB3SffZoi69ine5AnW6zX5daQKU3ZXS/BYFgXhoVZi387oP1ARCO5nI5H1uZvQK4gv+3uV0u+uJgrpxJj3eNTBVXastGX0TfSx11A1idpbhW3PGjBQVNf+2olfxr4YSAXuvN157DjqxRg7kfDWUaciC1cOUMyOJtqY=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB3461.namprd15.prod.outlook.com (2603:10b6:a03:109::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20; Tue, 5 May
 2020 20:28:24 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8988:aa27:5d70:6923]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8988:aa27:5d70:6923%5]) with mapi id 15.20.2958.030; Tue, 5 May 2020
 20:28:24 +0000
Subject: Re: [PATCH bpf-next v2 06/20] bpf: create anonymous bpf iterator
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
References: <20200504062547.2047304-1-yhs@fb.com>
 <20200504062553.2047848-1-yhs@fb.com>
 <CAEf4BzadAZy+GQwV3DXoGk6KdNYbVMxaP7BFphSc47w5WeXiRA@mail.gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <8cf5ea90-6805-84fe-faae-3c894cd1b203@fb.com>
Date:   Tue, 5 May 2020 13:28:18 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
In-Reply-To: <CAEf4BzadAZy+GQwV3DXoGk6KdNYbVMxaP7BFphSc47w5WeXiRA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR07CA0031.namprd07.prod.outlook.com
 (2603:10b6:a02:bc::44) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from macbook-pro-52.local.dhcp.thefacebook.com (2620:10d:c090:400::5:99aa) by BYAPR07CA0031.namprd07.prod.outlook.com (2603:10b6:a02:bc::44) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.27 via Frontend Transport; Tue, 5 May 2020 20:28:23 +0000
X-Originating-IP: [2620:10d:c090:400::5:99aa]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: efbf3211-5080-441d-ad45-08d7f132dc1a
X-MS-TrafficTypeDiagnostic: BYAPR15MB3461:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB346117480E1EDD71B18DDC98D3A70@BYAPR15MB3461.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 0394259C80
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FgJEzdg60/MyYaAS+Ntp6jRn0tMY/IQDMJ1z4f83pcgjZu3QGjKx0UaM3eU85F92c9tRiaUBRj1m5vgxpWgGlhty9dBTKlFzobrlslVelum/J1qOLAA3znTFylq7OywGfNodB7AcGBsiCSyVUQdwhoXS/LJ5m8fUWbpUsHjfajtpfeUm2mygEF3K4X5AWer/Gb7cECH6ZTcoSiY8fGQIngjdN1uYxCJUeHbvw3GEuyHH/y4lQcRKSjhZkwwWYot7rytXVxMrjb0X66qfatovWovOok62TZqY/vAMbLmnPvDsM7pDyhYg051ZvvvWakviQOUtdMvUCJxoxtHUOuvt0I+my2A8Q5e3gvUHyU2ywClhOo2J9XRpgRl4TJVfvfJo1XWMQfv4eawerVe7C5GHKW8we5KjnzSKDURFCTcp0r8dt71HzT20rB+E4Hc3uSguLtq9xOacacdkChhI9fCEh08nCIncQve0PptMigDqYwMeb38a/ozPYC1Gey/hDfEec07/J6B5lQ4c0RuKfdOE9N8f0Hhea5z84KS+DyQ7T7RFvwfeRZ7Rpt1brVnxhKa7
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(366004)(346002)(376002)(136003)(396003)(39850400004)(33430700001)(31686004)(316002)(54906003)(52116002)(16526019)(186003)(6666004)(5660300002)(31696002)(2906002)(86362001)(8676002)(66476007)(66556008)(478600001)(6916009)(66946007)(8936002)(4326008)(53546011)(36756003)(6506007)(2616005)(6486002)(33440700001)(6512007)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: MKE3r6rRR4PR2rzsTozev40fFIuH3aBjaAfC0XMKAV+vql8y5drg7gv4sb8DB/OGloHpxcg95KAto3AqFtzOVs094AhMdsotitUUUbdop4J2McB1UqKJ2klveA05nt114spmGiFfqzplVEvj4xojLpHpZWDypdI4u5VfVZlkZpwRVLNl3OpEpI1seZMpWiOFeebKkxQwO7VUO3E5Lk8NYwPayAFK9f5vR0ZyIYy/vDf9zBPbmnLGsK1l6CQfzA1hWePiEAyUxdhQIsU1Ez9vsZ62ipjB1pbcZV84cFPmpXvdT4ROILAx2oS3D7K0F5clBUWYe6IQ0CCKPFpxjyxI1dD7zRImxyC8VnxcHnu/tUtMtqIt13c0zUyRabijgZI3R5bZ2Otdu1ciAHqq2lgvX7F9RS9m1Yzfn0J3uxHw4V69Gk9n0h7Xe/S+V48jdlItBSHzSOzi3soFDxfsY6cKxSrvPHwZNKymZMaLnxWmyB9d+ICYvwOuvVDXThdVvbXybeL0wRLNlqtD7viLeIyxRwbnTA3NBqLhf1dIj4QkTgp/UdSLJFusnC5aRX92I9s3FTsF06jdBws/yhovROwwm0SEQxodiDy4+Vk1MJFAahTuMyjiQTqvCXdy1xc4uVx1CUwwxgTCa6A+Dte00u1axcM/R9rbiZ0sMvjilwX87pC3SNCVCoL5zknaoMS/BuA2lRueH18In/cAPDLl+70WR/LZSrRKhCHWue9oBVxwHCgDRosYrtzCJmBaJlnWS5NpGSBrVhjW4//e71YroYqmQcrvvvbxtyNuRHomEXLDTK1V4arMr78hlJJVEvxn0vprohGUmYBfOjp9Ui/Opg0IOg==
X-MS-Exchange-CrossTenant-Network-Message-Id: efbf3211-5080-441d-ad45-08d7f132dc1a
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2020 20:28:24.1168
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CeIi2xrNyN56D8GDfCAJsHNVQDSTj4MGzmYvSWYLr7TxXj2P1h0zL2PMRyX77ags
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3461
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-05-05_10:2020-05-04,2020-05-05 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 priorityscore=1501 impostorscore=0 lowpriorityscore=0 phishscore=0
 adultscore=0 bulkscore=0 spamscore=0 malwarescore=0 suspectscore=0
 mlxscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005050157
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/5/20 1:11 PM, Andrii Nakryiko wrote:
> On Sun, May 3, 2020 at 11:29 PM Yonghong Song <yhs@fb.com> wrote:
>>
>> A new bpf command BPF_ITER_CREATE is added.
>>
>> The anonymous bpf iterator is seq_file based.
>> The seq_file private data are referenced by targets.
>> The bpf_iter infrastructure allocated additional space
>> at seq_file->private before the space used by targets
>> to store some meta data, e.g.,
>>    prog:       prog to run
>>    session_id: an unique id for each opened seq_file
>>    seq_num:    how many times bpf programs are queried in this session
>>    do_stop:    an internal state to decide whether bpf program
>>                should be called in seq_ops->stop() or not
>>
>> Signed-off-by: Yonghong Song <yhs@fb.com>
>> ---
>>   include/linux/bpf.h            |   1 +
>>   include/uapi/linux/bpf.h       |   6 ++
>>   kernel/bpf/bpf_iter.c          | 128 +++++++++++++++++++++++++++++++++
>>   kernel/bpf/syscall.c           |  26 +++++++
>>   tools/include/uapi/linux/bpf.h |   6 ++
>>   5 files changed, 167 insertions(+)
>>
> 
> [...]
> 
>>   /* The description below is an attempt at providing documentation to eBPF
>> diff --git a/kernel/bpf/bpf_iter.c b/kernel/bpf/bpf_iter.c
>> index 2674c9cbc3dc..2a9f939be6e6 100644
>> --- a/kernel/bpf/bpf_iter.c
>> +++ b/kernel/bpf/bpf_iter.c
>> @@ -2,6 +2,7 @@
>>   /* Copyright (c) 2020 Facebook */
>>
>>   #include <linux/fs.h>
>> +#include <linux/anon_inodes.h>
>>   #include <linux/filter.h>
>>   #include <linux/bpf.h>
>>
>> @@ -20,12 +21,26 @@ struct bpf_iter_link {
>>          struct bpf_iter_target_info *tinfo;
>>   };
>>
>> +struct bpf_iter_priv_data {
>> +       struct {
> 
> nit: anon struct seems unnecessary here? is it just for visual grouping?

Yes, this is just for virtual grouping. Not 100% sure whether this
is needed or not.

> 
>> +               struct bpf_iter_target_info *tinfo;
>> +               struct bpf_prog *prog;
>> +               u64 session_id;
>> +               u64 seq_num;
>> +               u64 do_stop;
>> +       };
>> +       u8 target_private[] __aligned(8);
>> +};
>> +
>>   static struct list_head targets = LIST_HEAD_INIT(targets);
>>   static DEFINE_MUTEX(targets_mutex);
>>
>>   /* protect bpf_iter_link changes */
>>   static DEFINE_MUTEX(link_mutex);
>>
>> +/* incremented on every opened seq_file */
>> +static atomic64_t session_id;
>> +
>>   /* bpf_seq_read, a customized and simpler version for bpf iterator.
>>    * no_llseek is assumed for this file.
>>    * The following are differences from seq_read():
>> @@ -154,6 +169,31 @@ static ssize_t bpf_seq_read(struct file *file, char __user *buf, size_t size,
>>          goto Done;
>>   }
>>
>> +static int iter_release(struct inode *inode, struct file *file)
>> +{
>> +       struct bpf_iter_priv_data *iter_priv;
>> +       void *file_priv = file->private_data;
>> +       struct seq_file *seq;
>> +
>> +       seq = file_priv;
> 
> 
> seq might be NULL, if anon_inode_getfile succeeded, but then
> prepare_seq_file failed, so you need to handle that.

Thanks for catching this. Missed this case.

> 
> Also, file_priv is redundant, assign to seq directly from file->private_data?

Ack.

> 
>> +       iter_priv = container_of(seq->private, struct bpf_iter_priv_data,
>> +                                target_private);
>> +
>> +       if (iter_priv->tinfo->fini_seq_private)
>> +               iter_priv->tinfo->fini_seq_private(seq->private);
>> +
>> +       bpf_prog_put(iter_priv->prog);
>> +       seq->private = iter_priv;
>> +
>> +       return seq_release_private(inode, file);
>> +}
>> +
>> +static const struct file_operations bpf_iter_fops = {
>> +       .llseek         = no_llseek,
>> +       .read           = bpf_seq_read,
>> +       .release        = iter_release,
>> +};
>> +
>>   int bpf_iter_reg_target(struct bpf_iter_reg *reg_info)
>>   {
>>          struct bpf_iter_target_info *tinfo;
>> @@ -289,3 +329,91 @@ int bpf_iter_link_attach(const union bpf_attr *attr, struct bpf_prog *prog)
>>
>>          return bpf_link_settle(&link_primer);
>>   }
>> +
>> +static void init_seq_meta(struct bpf_iter_priv_data *priv_data,
>> +                         struct bpf_iter_target_info *tinfo,
>> +                         struct bpf_prog *prog)
>> +{
>> +       priv_data->tinfo = tinfo;
>> +       priv_data->prog = prog;
>> +       priv_data->session_id = atomic64_add_return(1, &session_id);
> 
> nit: atomic64_inc_return?

Ack.

> 
>> +       priv_data->seq_num = 0;
>> +       priv_data->do_stop = 0;
>> +}
>> +
> 
> [...]
> 
