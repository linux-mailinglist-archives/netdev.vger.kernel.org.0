Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA2951A4CAE
	for <lists+netdev@lfdr.de>; Sat, 11 Apr 2020 01:42:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726702AbgDJXmE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Apr 2020 19:42:04 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:63768 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726594AbgDJXmE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Apr 2020 19:42:04 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 03ANbfN0012918;
        Fri, 10 Apr 2020 16:41:52 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=qOMvxx99+9oHkg8Yf92OfSx8t4StUiIPlEqzLOFBTxo=;
 b=Ree657fyRFEzIl0N1iVMdg98nr7yzDbD6gKa0FIn+uSnoiG5ni6nlq7QpIyWGQC/HaXb
 Yq9da5bHPcq7rIY07kShOG3DQ8Dnv1z4yOlP63lzAaJVNaYRfKhAdoJAId6rce2fu+R+
 /rLxD2YmOeeGnQVanOCOiy5toYsCWAmz3kk= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net with ESMTP id 30av6w2bbh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 10 Apr 2020 16:41:52 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Fri, 10 Apr 2020 16:41:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g1kcjiRLto5RV1fmTfxR9qv5TRXXM7XGD8o9KU2LxaG2oIVx5AlBMEG57vTc/fYmRJnElcZzppJTQdO56OFRsDgwqWUBQq2IW7/3EPHCz73ZmZAgaSHvNHuBHsTx3BxHnaLXLlPNDC39gdgaJho3ElPUyJ+5IRA9AjR3T8r+7fN/N0s8NRNSPlhG57KdBUUR+sNIX5Xcab7+bGMCXs0gw3c+llq6An2uCcMAWlRaIePacQirVPqmBYxlLtA5+IuJ1L0/1exEQKYTLWX842pN1UsQe8yu69uMfR8FlBfHoATNtDfUIB9eGyXpWVj6CVD+JdMHC3rn5ZNpGcmlSAc+Kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qOMvxx99+9oHkg8Yf92OfSx8t4StUiIPlEqzLOFBTxo=;
 b=ecIqhW0jnwPO8wH4AIZclPy35Eec6qjSzjrx/yeI+cDqJvd6MDPK21PAzJ/mXLykurq9pFOcLJcK0jusHWRjycF1Ni/ZUGGJPpyl+SjSfrCY2BeUeikeaCoXvl0gKpjsXvpliAPOWiIBJSo8NQEB06PyHXseHTecrdRrnL+wYPEe3f5EEbjlcqZhRGR0AI05SWKlbV4B3lYr1b48qd5nP5tPb7qvrvz4LsRrLPukjlMbXesAFqCj8vRFdwk+fAB6PXBxs0IAYjWClvFk4g7irZgDKHXvrKoAmdA5OLQ6TP7JTvgv/PilX7+rpr5ANNJRtHfYRr/5aAWltUpn+ZTA8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qOMvxx99+9oHkg8Yf92OfSx8t4StUiIPlEqzLOFBTxo=;
 b=OGo0fnfZshYyXrvq7RAEoG2mpKzHt7NcmkEAQDm98MAS/Peh/dcChUiKLyCFGPheCGzm61H32h7qC9431dKMcsGE+1WQA0R7VIFYy4LiSMP+fJ08zBaAkShNZz83laVBrIFzGcf1Hql6XtoA8IGyyHR0F0oeo5GKj8GN9/acmVU=
Received: from MW3PR15MB3883.namprd15.prod.outlook.com (2603:10b6:303:51::22)
 by MW3PR15MB3962.namprd15.prod.outlook.com (2603:10b6:303:45::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.19; Fri, 10 Apr
 2020 23:41:50 +0000
Received: from MW3PR15MB3883.namprd15.prod.outlook.com
 ([fe80::a49b:8546:912f:dd98]) by MW3PR15MB3883.namprd15.prod.outlook.com
 ([fe80::a49b:8546:912f:dd98%5]) with mapi id 15.20.2878.018; Fri, 10 Apr 2020
 23:41:50 +0000
Subject: Re: [RFC PATCH bpf-next 05/16] bpf: create file or anonymous dumpers
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
References: <20200408232520.2675265-1-yhs@fb.com>
 <20200408232526.2675664-1-yhs@fb.com>
 <CAEf4BzajwPzHUyBvVZzafgKZHXv7b0pmL_avtFO6-_QHh46z1g@mail.gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <ed14f5c8-dacc-369f-07d0-f5ee2877e8ea@fb.com>
Date:   Fri, 10 Apr 2020 16:41:46 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
In-Reply-To: <CAEf4BzajwPzHUyBvVZzafgKZHXv7b0pmL_avtFO6-_QHh46z1g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CO2PR07CA0058.namprd07.prod.outlook.com (2603:10b6:100::26)
 To MW3PR15MB3883.namprd15.prod.outlook.com (2603:10b6:303:51::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from MacBook-Pro-52.local (2620:10d:c090:400::5:e0e4) by CO2PR07CA0058.namprd07.prod.outlook.com (2603:10b6:100::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.20 via Frontend Transport; Fri, 10 Apr 2020 23:41:49 +0000
X-Originating-IP: [2620:10d:c090:400::5:e0e4]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 71ff467e-ba67-407e-6ec4-08d7dda8bd64
X-MS-TrafficTypeDiagnostic: MW3PR15MB3962:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MW3PR15MB396251EDA156552776CC6DA4D3DE0@MW3PR15MB3962.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 0369E8196C
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR15MB3883.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(39860400002)(136003)(346002)(376002)(366004)(396003)(186003)(4326008)(36756003)(6916009)(16526019)(31696002)(52116002)(31686004)(478600001)(53546011)(66946007)(6666004)(66556008)(66476007)(5660300002)(2906002)(2616005)(86362001)(54906003)(81156014)(6512007)(8936002)(6486002)(316002)(6506007)(8676002);DIR:OUT;SFP:1102;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WUouhOV1SQ8UWHMVDc8dar0FMvI32KgJO7KOc1R9Nrsdikws9KQ6/BH80X+s2uDGru2fBkxQ+KbQjr6gRR4YcEU4bktNzBsgDeKypSCw8zXWLUoaeY90OhMF9HYkMzAu79jY1SI357QugIMVJbWBmSF90OZgm7ISi5n3WIV81BKsFNSAveWayAti67LaLmhglCMWPrTR/a0xsYbndqISF4EZbAwdwh3U3zNiNHojKJl0CsAod7yli0whQlfA634MR7C9yStdUqeBawiIPfbFH4+AhJIuiCpO+rHBP/4fqRwm1PNGOxSVxYKJEN/u7qMfdUDpv9dYqH3hMJtI5/ZrrgWBTGyjTdS67TJk7rZFM/8xfazlt4pht0QGA4ULcjkOQkbwyv8epoBxZJqDkLHTRRORIiBFUzoIc19Pjd96fw/TDh79wPkv0UVmBluOWkCx
X-MS-Exchange-AntiSpam-MessageData: IT1QF5Y5NmxW6hyEr3FcYpP5saHd2bvCZq1X+wW2EX6IidMfThAAv9tk+6UMXw0WxfxrN00QblpCePMd5RiM40o1JPvDM+sJmKULKyOeJOg4OEv/CsOdUVaXu5dY3fyDgMKoK1Rkw/BAX9ercT+MtaFBv/FMF8HkDKBO83jm4QVjzoxZU3YbtdAY3iT4OLgU
X-MS-Exchange-CrossTenant-Network-Message-Id: 71ff467e-ba67-407e-6ec4-08d7dda8bd64
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2020 23:41:49.9686
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ju2hcFA57rsNTUH1Ny4A2ZlK0R7A0xcpGvrE451mzm7JssG4Bm8YXmes45IDOMzv
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB3962
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-10_10:2020-04-09,2020-04-10 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 adultscore=0 spamscore=0 clxscore=1015 lowpriorityscore=0
 priorityscore=1501 impostorscore=0 bulkscore=0 mlxlogscore=999
 phishscore=0 mlxscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2004100166
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/10/20 3:51 PM, Andrii Nakryiko wrote:
> On Wed, Apr 8, 2020 at 4:26 PM Yonghong Song <yhs@fb.com> wrote:
>>
>> Given a loaded dumper bpf program, which already
>> knows which target it should bind to, there
>> two ways to create a dumper:
>>    - a file based dumper under hierarchy of
>>      /sys/kernel/bpfdump/ which uses can
>>      "cat" to print out the output.
>>    - an anonymous dumper which user application
>>      can "read" the dumping output.
>>
>> For file based dumper, BPF_OBJ_PIN syscall interface
>> is used. For anonymous dumper, BPF_PROG_ATTACH
>> syscall interface is used.
>>
>> To facilitate target seq_ops->show() to get the
>> bpf program easily, dumper creation increased
>> the target-provided seq_file private data size
>> so bpf program pointer is also stored in seq_file
>> private data.
>>
>> Further, a seq_num which represents how many
>> bpf_dump_get_prog() has been called is also
>> available to the target seq_ops->show().
>> Such information can be used to e.g., print
>> banner before printing out actual data.
>>
>> Note the seq_num does not represent the num
>> of unique kernel objects the bpf program has
>> seen. But it should be a good approximate.
>>
>> A target feature BPF_DUMP_SEQ_NET_PRIVATE
>> is implemented specifically useful for
>> net based dumpers. It sets net namespace
>> as the current process net namespace.
>> This avoids changing existing net seq_ops
>> in order to retrieve net namespace from
>> the seq_file pointer.
>>
>> For open dumper files, anonymous or not, the
>> fdinfo will show the target and prog_id associated
>> with that file descriptor. For dumper file itself,
>> a kernel interface will be provided to retrieve the
>> prog_id in one of the later patches.
>>
>> Signed-off-by: Yonghong Song <yhs@fb.com>
>> ---
>>   include/linux/bpf.h            |   5 +
>>   include/uapi/linux/bpf.h       |   6 +-
>>   kernel/bpf/dump.c              | 338 ++++++++++++++++++++++++++++++++-
>>   kernel/bpf/syscall.c           |  11 +-
>>   tools/include/uapi/linux/bpf.h |   6 +-
>>   5 files changed, 362 insertions(+), 4 deletions(-)
>>
> 
> [...]
> 
>>
>> +struct dumper_inode_info {
>> +       struct bpfdump_target_info *tinfo;
>> +       struct bpf_prog *prog;
>> +};
>> +
>> +struct dumper_info {
>> +       struct list_head list;
>> +       /* file to identify an anon dumper,
>> +        * dentry to identify a file dumper.
>> +        */
>> +       union {
>> +               struct file *file;
>> +               struct dentry *dentry;
>> +       };
>> +       struct bpfdump_target_info *tinfo;
>> +       struct bpf_prog *prog;
>> +};
> 
> This is essentially a bpf_link. Why not do it as a bpf_link from the
> get go? Instead of having all this duplication for anonymous and

This is a good question. Maybe part of bpf-link can be used and
I have to implement others. I will check.

> pinned dumpers, it would always be a bpf_link-based dumper, but for
> those pinned bpf_link itself is going to be pinned. You also get a
> benefit of being able to list all dumpers through existing bpf_link
> API (also see my RFC patches with bpf_link_prime/bpf_link_settle,
> which makes using bpf_link safe and simple).

Agree. Alternative is to use BPF_OBJ_GET_INFO_BY_FD to query individual
dumper as directory tree walk can be easily done at user space.


> 
> [...]
> 
>> +
>> +static void anon_dumper_show_fdinfo(struct seq_file *m, struct file *filp)
>> +{
>> +       struct dumper_info *dinfo;
>> +
>> +       mutex_lock(&anon_dumpers.dumper_mutex);
>> +       list_for_each_entry(dinfo, &anon_dumpers.dumpers, list) {
> 
> this (and few other places where you search in a loop) would also be
> simplified, because struct file* would point to bpf_dumper_link, which
> then would have a pointer to bpf_prog, dentry (if pinned), etc. No
> searching at all.

This is a reason for this. the same as bpflink, bpfdump already has
the full information about file, inode, etc.
The file private_data actually points to seq_file. The seq_file private 
data is used in the target. That is exactly why we try to have this 
mapping to keep track. bpf_link won't help here.

> 
>> +               if (dinfo->file == filp) {
>> +                       seq_printf(m, "target:\t%s\n"
>> +                                     "prog_id:\t%u\n",
>> +                                  dinfo->tinfo->target,
>> +                                  dinfo->prog->aux->id);
>> +                       break;
>> +               }
>> +       }
>> +       mutex_unlock(&anon_dumpers.dumper_mutex);
>> +}
>> +
>> +#endif
>> +
> 
> [...]
> 
