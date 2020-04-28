Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7D681BC552
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 18:35:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728253AbgD1Qfv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 12:35:51 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:65044 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728129AbgD1Qfu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 12:35:50 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03SGU4tc021288;
        Tue, 28 Apr 2020 09:35:38 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=HxmBMY2vQU5npMCsbmcJC4R4SZuQajBJZtTz88Uf7mc=;
 b=aP3Pmg+Qv8ADVLvM/JnaZkfzG72Io+Zs1D1qlH0q1hQ7xgR8oBzUBuOR0dU93525zGZ3
 aQ2TLmVP8d+xiQhNKVtLaVtZfjqWNE7YJRpU5uiQWmzLPjoqQvTR9eV2I19siwiIWR4m
 vDKhNtWdSNcYMcUXjd7d89VFBQ1s9C4+N44= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 30n57pg0tt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 28 Apr 2020 09:35:37 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Tue, 28 Apr 2020 09:35:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IIkBJCPcxx1hO0T4hcvhPqF77FDskZ2YjFn82r2hppjeQDBJuQuAAtYdDtsPVO+q1taodTrhj8XaXxFL5RroRyg9HM9Dky6Bz1he6LVVe4P8FAEB1AKAimu2E6nu5oIPytj3Pv/eSoqPegEms0EVKCc+niPLUHSZHTvA5Pgb2GkRoslHroFyh0meJDnFmB+2HVSaJ7v2g3WH9XXlw+T2ypUYoFhE4QCM3H+HWOC2539jFD0BXZe8CicQSOTpPh7KsjK0ZIRxgrR8D64OuUMbmtQ62J6EiC2H3twx5Un7cJHieXOmNdG1wh5Qr6JfMkpzEuy8eCLGAYXxc0veRmoiZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HxmBMY2vQU5npMCsbmcJC4R4SZuQajBJZtTz88Uf7mc=;
 b=cGZtRgHVpYAf29vPzk5bUOsg7NSdI/EAd23uQDiX636Sk/7JFK/zi/RePl9RMbJ3NMsrf/hLMcv+ruAR2c1T30dQY57k5Z4R3/pAkKd9xyKTFSKq5ZCP/f9eVKi5zYEq774PhxPw3nfEO8ud21pWLLMLGVjyxroQXBAm2P5carhYW1sQ6YQVqQCHLd0xtzOFDcX844BPlMhrIsIi6eCWvIuaK3VRHMlWcp5LlF3CQL6x15DQWqfh9HFVMZZw4KJJPNRyorwUxMD/brcN/BugtMP2anFUtPhAOoZuwnT60BICvUwSwB0tib9Zz0/tjTm9ODLRXvWhGMT/XH+VSylaBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HxmBMY2vQU5npMCsbmcJC4R4SZuQajBJZtTz88Uf7mc=;
 b=QQUNVkfMux/Q+nnr7golOVhfj0/C/T2YHuuPYI5RlrJ5tFZSddr1JPDn3PBMo+9kLQAOraIh/xs62nPRahyJgwwgaBluFehVzsErItak41t/4QrouZIiXcocDQlvPJNPe3Nd5eDwmZ7aSkdY0EVG30wLkS9rsz+Ghrm+kpRG3uw=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2888.namprd15.prod.outlook.com (2603:10b6:a03:b5::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.22; Tue, 28 Apr
 2020 16:35:33 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8988:aa27:5d70:6923]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8988:aa27:5d70:6923%5]) with mapi id 15.20.2937.023; Tue, 28 Apr 2020
 16:35:33 +0000
Subject: Re: [PATCH bpf-next v1 12/19] bpf: add bpf_seq_printf and
 bpf_seq_write helpers
To:     kbuild test robot <lkp@intel.com>,
        Andrii Nakryiko <andriin@fb.com>, <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, <netdev@vger.kernel.org>
CC:     <kbuild-all@lists.01.org>, Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>
References: <20200427201249.2995688-1-yhs@fb.com>
 <202004281302.DSoHBqoM%lkp@intel.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <a9ae1071-a967-57b5-fa1c-e144a1c655d6@fb.com>
Date:   Tue, 28 Apr 2020 09:35:30 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
In-Reply-To: <202004281302.DSoHBqoM%lkp@intel.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MWHPR12CA0054.namprd12.prod.outlook.com
 (2603:10b6:300:103::16) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from MacBook-Pro-52.local (2620:10d:c090:400::5:4420) by MWHPR12CA0054.namprd12.prod.outlook.com (2603:10b6:300:103::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.19 via Frontend Transport; Tue, 28 Apr 2020 16:35:32 +0000
X-Originating-IP: [2620:10d:c090:400::5:4420]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 201555f7-1c9d-4113-a628-08d7eb922be8
X-MS-TrafficTypeDiagnostic: BYAPR15MB2888:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB288892443FB0016DD93CA061D3AC0@BYAPR15MB2888.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:1923;
X-Forefront-PRVS: 0387D64A71
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(366004)(346002)(376002)(39860400002)(136003)(396003)(478600001)(966005)(66556008)(66946007)(66476007)(316002)(83080400001)(52116002)(53546011)(6506007)(36756003)(5660300002)(2906002)(16526019)(110136005)(54906003)(8936002)(31696002)(6512007)(31686004)(4326008)(81156014)(2616005)(8676002)(186003)(6486002)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Hu8SaSn/DznmZUMkWlMILbWkvDya1pJirfISk2+upUpr6c2ZUWAjWcCcuw3XQTheL1m0zr1tm8SgmNltkw2JlAg7a5BIxhA/MDfZCnLY51xt9OJ9NCfhfJ9H2Vp2jRT3Xjw9p6Z5s/F309zO+Lfk3SdnviDlSddJ5noULieqSWtqBYwjmzx+c3mae+KChOKBVultQ84lpV5XFIbC4RyVZHZwsn0PnfJDh111NkpO6NyQhMy2gvgZSy5M+qhHfbWDk2ToSVHNGvWMKBCJel6MJ8zNTEGr6qViLh2P9SplqyoB4vUybJhFvoqWXxN/3k6D63v4yc1SKoVxdg1bB23bebgppAGvxn7jKxw1k7gXhtSfcMLjpslBxn60yDm7YJF1L6eHrYmWwcDZEdYCXv3gVnniWzbRjbMIR02HIXvB6oP4FSoAgMu/E8xi3XQgRrjaMbsmNDYLXxMRnmm3NTpHsg3SCvsh98QSp5exkcMZyzaq+DgDNTaJawvqrVO07fa0+Q1ttYWd+Bff0aTqOrrmVw==
X-MS-Exchange-AntiSpam-MessageData: 5/JQZEmtiNezCfaMoAGK2JphShG4KotC96QdLGbq7Dq4/coed3fO8eaoV0DDzRHLv67APxM/vnDcrf3RSaZYmdB/qdqhIgnLeCxvXzr0yr0yUqe1KXaR6jOEXCnHGgyBBAf1Vg5lumsUZZkIEaNfwql5oyqLEhrnYuZJcDBI7NWw9+ktBZUFe8D7zFHvxlHd1MoFh661jF+ptQD0NmMV/+b5BCMOWrvDllTQ62JRjDSPXNZBvRMa7Lm1Gy8YJelUJkRgcSotPnQA6NtDdpc19JIW86NcmZkUJU+DMArUCfvyT0G+UcmYvIhN7O2spsNYGMZUI8ukQB45WkntqM/1/W+HtzGhEugyguYH7FYsDgFHEeiLSuZ+tchzlipvCtEwu9liUHlN7O9q5RrDB2lEUkAESaZEWDMXOaMYCyN4QbvxYLhwSFAM/an24i/hCiYCGoBA4XpQbuiKdLzqFuNEitLI+Im2WgB1W5MGgTHCqc6aZQNGtPEuRC1fRSyBY/zzBcMWc1WGnPUaYNG6pNUNthgd8n5KhLN1dkRopBX3zMpBZb1BMmZNSzzC4R9WyMeZUubowpFoRz+3WvMWOshWNzoo44LR1iY1Lgfa3YUxkxGgWMdSlqcF9IZzpE2vd4YeE7uB0kyyoGqnhGp3pM9r7/3glWEk0Kj32wPNXMpLgxoog9RxrE3nR1tj/JTuCuaBX0Wn79Q+TuHjhHnAYfSg6Wg2Ik/YI0Xp8bE6uSpzAp4qA5YSnLD8/pzg3IKfOZtl3FBpBhIkPlKgnAQGvBHLElJOPl9hcHOBGeUD1W0R3fu5KtsRBtAFAC8u6NVkNfqW7H9CEmzN2h2/B9EqmGpRaw==
X-MS-Exchange-CrossTenant-Network-Message-Id: 201555f7-1c9d-4113-a628-08d7eb922be8
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2020 16:35:33.3792
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: R5uw6QK2SbnxhCvyL9O+1qkYluxAxi1FeFjmbeAeZdHXme39F44xnAG+300zbaJ/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2888
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-28_11:2020-04-28,2020-04-28 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 impostorscore=0 mlxscore=0 malwarescore=0 suspectscore=0 mlxlogscore=999
 lowpriorityscore=0 adultscore=0 bulkscore=0 spamscore=0 phishscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004280130
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/27/20 11:02 PM, kbuild test robot wrote:
> Hi Yonghong,
> 
> I love your patch! Perhaps something to improve:
> 
> [auto build test WARNING on bpf-next/master]
> [cannot apply to bpf/master net/master vhost/linux-next net-next/master linus/master v5.7-rc3 next-20200424]
> [if your patch is applied to the wrong git tree, please drop us a note to help
> improve the system. BTW, we also suggest to use '--base' option to specify the
> base tree in git format-patch, please see https://urldefense.proofpoint.com/v2/url?u=https-3A__stackoverflow.com_a_37406982&d=DwIBAg&c=5VD0RTtNlTh3ycd41b3MUw&r=DA8e1B5r073vIqRrFz7MRA&m=ecuvAWhErc8x32mTscXvNhgSPkwcM7tK05lEVYIQMbI&s=rUkkN8hfXpHttD7t9NCfe5OIFTZZ_cn_SQTDjvs1cj0&e= ]
> 
> url:    https://github.com/0day-ci/linux/commits/Yonghong-Song/bpf-implement-bpf-iterator-for-kernel-data/20200428-115101
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git master
> config: sh-allmodconfig (attached as .config)
> compiler: sh4-linux-gcc (GCC) 9.3.0
> reproduce:
>          wget https://urldefense.proofpoint.com/v2/url?u=https-3A__raw.githubusercontent.com_intel_lkp-2Dtests_master_sbin_make.cross&d=DwIBAg&c=5VD0RTtNlTh3ycd41b3MUw&r=DA8e1B5r073vIqRrFz7MRA&m=ecuvAWhErc8x32mTscXvNhgSPkwcM7tK05lEVYIQMbI&s=mm3zd05JFgyD1Fvvg5yehcYq7d9KLZkN7XSYyLaJRkA&e=  -O ~/bin/make.cross
>          chmod +x ~/bin/make.cross
>          # save the attached .config to linux build tree
>          COMPILER_INSTALL_PATH=$HOME/0day GCC_VERSION=9.3.0 make.cross ARCH=sh
> 
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kbuild test robot <lkp@intel.com>
> 
> All warnings (new ones prefixed by >>):
> 
>     In file included from kernel/trace/bpf_trace.c:10:
>     kernel/trace/bpf_trace.c: In function 'bpf_seq_printf':
>>> kernel/trace/bpf_trace.c:463:35: warning: the frame size of 1672 bytes is larger than 1024 bytes [-Wframe-larger-than=]
>       463 | BPF_CALL_5(bpf_seq_printf, struct seq_file *, m, char *, fmt, u32, fmt_size,

Thanks for reporting. Currently, I am supporting up to 12 string format 
specifiers and each string up to 128 bytes. To avoid racing and helper 
memory allocation, I put it on stack hence the above 1672 bytes, but
practically, I think support 4 strings with 128 bytes each is enough.
I will make a change in the next revision.

>           |                                   ^~~~~~~~
>     include/linux/filter.h:456:30: note: in definition of macro '__BPF_CAST'
>       456 |           (unsigned long)0, (t)0))) a
>           |                              ^
>>> include/linux/filter.h:449:27: note: in expansion of macro '__BPF_MAP_5'
>       449 | #define __BPF_MAP(n, ...) __BPF_MAP_##n(__VA_ARGS__)
>           |                           ^~~~~~~~~~
>>> include/linux/filter.h:474:35: note: in expansion of macro '__BPF_MAP'
>       474 |   return ((btf_##name)____##name)(__BPF_MAP(x,__BPF_CAST,__BPF_N,__VA_ARGS__));\
>           |                                   ^~~~~~~~~
>>> include/linux/filter.h:484:31: note: in expansion of macro 'BPF_CALL_x'
>       484 | #define BPF_CALL_5(name, ...) BPF_CALL_x(5, name, __VA_ARGS__)
>           |                               ^~~~~~~~~~
>>> kernel/trace/bpf_trace.c:463:1: note: in expansion of macro 'BPF_CALL_5'
>       463 | BPF_CALL_5(bpf_seq_printf, struct seq_file *, m, char *, fmt, u32, fmt_size,
>           | ^~~~~~~~~~
> 
> vim +463 kernel/trace/bpf_trace.c
> 
>     462	
>   > 463	BPF_CALL_5(bpf_seq_printf, struct seq_file *, m, char *, fmt, u32, fmt_size,
>     464		   const void *, data, u32, data_len)
>     465	{
>     466		char bufs[MAX_SEQ_PRINTF_VARARGS][MAX_SEQ_PRINTF_STR_LEN];
>     467		u64 params[MAX_SEQ_PRINTF_VARARGS];
>     468		int i, copy_size, num_args;
>     469		const u64 *args = data;
>     470		int fmt_cnt = 0;
>     471	
[...]
