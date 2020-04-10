Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF6FC1A4268
	for <lists+netdev@lfdr.de>; Fri, 10 Apr 2020 08:12:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726173AbgDJGMh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Apr 2020 02:12:37 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:20284 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725776AbgDJGMh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Apr 2020 02:12:37 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03A6AFB1013816;
        Thu, 9 Apr 2020 23:12:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=/HG5MLTwmvepx56erd934J/t0bFk6gA2+WmUbdMQ0FI=;
 b=cjfAHX9gcjkGrP49D00Ju7KtjYrxZwR0GyTR1X/4ydLHEnVHfkLUe0RiZlOfdfb8Idq6
 URKcoktFmK5COsxPyTr8rxgzgsa6MDiEzc5gd0Wgydct8UHW+dqt8fm9Zi4zAP37d0z3
 WZk/L43QlfWKHz7QSmOIW8Iev5b/VOBT6hw= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3091n45xjq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 09 Apr 2020 23:12:26 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Thu, 9 Apr 2020 23:12:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hd/wvUoSPKgsxnK9Nsd/aj/49qHr7r0PDBf4Y76GKh9hwpNpRTILVIODGmQG9kFZZAkLR1zU/f8EfsBISdzQBOL23PFxCGYHMbIWD9ZqSbXxLfdizbYzUT+FNUQYGr7fsrvLtNAZauAy8fSFUDhrdDU3Sx8clVhOJ+AuHl5Ot/EeCy6Im17t4QvRxo/CFfPm9di+Cm72Xd2WRh3sjye3pVEVP3F2z9HRsXzRWxAdw5D3Bsk9MvX7Jtne29mxOWvsrHBG2Sz830Vt3zya36dkUDP1bX/oT0CtNRa/VybSgvhmG0ASS2p25QFU110aHez/s4fiLsMd5pzfRl+M4zOsUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/HG5MLTwmvepx56erd934J/t0bFk6gA2+WmUbdMQ0FI=;
 b=NbjGTa76xrkKJHyU5wn/IERhfj+bJfsD7O4sWpx5xQ/Ugn67/i6c84cyi20UAbV/HtHTzRGcG6o5+V6UKRgM0bOgJp2+PREEHlsvRIVbEBlpC/j3LjtNyZZsGslwBQyy6i3CZhbg/uJl89GP3u+I0X5z27Ecr6HxasYG+YQUqWG1oXnBE4fbtmyGDZs0Odn6LNIit+XK8sHsU7wroYWtl+2UyRWdO5VtOfedLxmUv4lkvgSwunmYrL5eyhheDLlEdRWKpEa+hTA/mjdiaEYxQ5HmaitAMLWrJsdlDqTHq1B2+1KFwWDj0Cqa99cuBRZp68eoL6FBAmdfaw/z2/qjww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/HG5MLTwmvepx56erd934J/t0bFk6gA2+WmUbdMQ0FI=;
 b=JK13CRqrpKAhfDBAy65xFcg7sn2CjKEPbyZpTnHuIgH6YGN6L/CZpZodYoCa/GSG7ZrDH2tY8zh+3yF22aGoUQgYwINzC2NBmJgw6OQd0kZV/8rPfA2K4C/+RjKxFrVJk6+8haaGkDAcMgn4UfBST32bHhhSPVtP2Mdh9OxMbuI=
Received: from MW3PR15MB3883.namprd15.prod.outlook.com (2603:10b6:303:51::22)
 by MW3PR15MB3977.namprd15.prod.outlook.com (2603:10b6:303:4d::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.16; Fri, 10 Apr
 2020 06:12:25 +0000
Received: from MW3PR15MB3883.namprd15.prod.outlook.com
 ([fe80::a49b:8546:912f:dd98]) by MW3PR15MB3883.namprd15.prod.outlook.com
 ([fe80::a49b:8546:912f:dd98%5]) with mapi id 15.20.2878.018; Fri, 10 Apr 2020
 06:12:25 +0000
Subject: Re: [RFC PATCH bpf-next 09/16] bpf: add bpf_seq_printf and
 bpf_seq_write helpers
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     Andrii Nakryiko <andriin@fb.com>, <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>
References: <20200408232520.2675265-1-yhs@fb.com>
 <20200408232531.2676134-1-yhs@fb.com>
 <20200410032608.x5hloyizpfyxnudz@ast-mbp.dhcp.thefacebook.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <6dbe9918-0f6c-6b48-aa0c-f057deb18b0f@fb.com>
Date:   Thu, 9 Apr 2020 23:12:22 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.6.0
In-Reply-To: <20200410032608.x5hloyizpfyxnudz@ast-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CO2PR06CA0064.namprd06.prod.outlook.com
 (2603:10b6:104:3::22) To MW3PR15MB3883.namprd15.prod.outlook.com
 (2603:10b6:303:51::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from rutu-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:75b7) by CO2PR06CA0064.namprd06.prod.outlook.com (2603:10b6:104:3::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.17 via Frontend Transport; Fri, 10 Apr 2020 06:12:23 +0000
X-Originating-IP: [2620:10d:c090:400::5:75b7]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ebf74855-0267-4bbf-bd21-08d7dd16234a
X-MS-TrafficTypeDiagnostic: MW3PR15MB3977:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MW3PR15MB3977A77C1F71931AE8A310B4D3DE0@MW3PR15MB3977.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-Forefront-PRVS: 0369E8196C
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR15MB3883.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(346002)(136003)(39860400002)(376002)(366004)(396003)(2906002)(6916009)(31686004)(31696002)(36756003)(5660300002)(66556008)(66476007)(86362001)(66946007)(53546011)(6506007)(52116002)(8936002)(478600001)(6512007)(2616005)(316002)(8676002)(81156014)(4326008)(6486002)(54906003)(16526019)(186003);DIR:OUT;SFP:1102;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KTrzrY41UlmYqyQXbZcJGKn1K087xA6l1G1BAzg8MEo3R3f/mRvTvHjqAa6G0k01gFdRiW5EdbP6ockFnh3nYAMhmHcp5MK79APFUSHrj90lMKb/boru9cJWvTH6ogJ1cRn7KWVv91J1jDp6VYMARmcPzxHsVDMhaiUugm7UbafBOpzBqt7BDS1VITSvbb9wM66IqJkgTZaDI5wMXyR4lfWDuEb56GiWI6TZ4E/41SUWO6HGUQn4XrV+yL3pKA+rWP0srU8E2exvjYenwElvUxk/aTWlMpmeIg1fNGEl8tzyv+IwU6jCv8a8KHbjXl3Ypcj00xcNJ5/GiAF7l0cf/kXKWEhYd9W1XNavQ4OjLZzhlglcJCEUHgPa/KbAA82Mh+Awm9K4lIJ8qmc6Z3BKmKiFZnetvMQXHytMKvRPto392y+UY6fZ74Jm2IrqBXVS
X-MS-Exchange-AntiSpam-MessageData: KEcCHeGcbDNAsJNFnJixSYJHdSwOiYbjWG/bywhJBCaeJHMCHhy1lrVAWw0pqaMuJ8TgW5BWlieMAtHENoOGxUUCxak18PNz65AXqyw84GRcvz+PedEcTI1nqd/7VDqnqSdRfnoiD+jJl63uqiQ07s0XpmS49xfEou6CFg/RVhz/gdM6QvmXbtV9wz+MxXgp
X-MS-Exchange-CrossTenant-Network-Message-Id: ebf74855-0267-4bbf-bd21-08d7dd16234a
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2020 06:12:24.9813
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +qadJlbtu81Wvp2+ld8Ygsv+oTX6ra9NUjD9qqXTzquQbwviTN222L1+ZVTeytOi
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB3977
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-10_01:2020-04-07,2020-04-10 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0 mlxscore=0
 priorityscore=1501 malwarescore=0 suspectscore=0 adultscore=0
 lowpriorityscore=0 spamscore=0 bulkscore=0 clxscore=1015 mlxlogscore=999
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004100052
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/9/20 8:26 PM, Alexei Starovoitov wrote:
> On Wed, Apr 08, 2020 at 04:25:31PM -0700, Yonghong Song wrote:
>>   
>> +BPF_CALL_5(bpf_seq_printf, struct seq_file *, m, char *, fmt, u32, fmt_size, u64, arg1,
>> +	   u64, arg2)
>> +{
>> +	bool buf_used = false;
>> +	int i, copy_size;
>> +	int mod[2] = {};
>> +	int fmt_cnt = 0;
>> +	u64 unsafe_addr;
>> +	char buf[64];
>> +
>> +	/*
>> +	 * bpf_check()->check_func_arg()->check_stack_boundary()
>> +	 * guarantees that fmt points to bpf program stack,
>> +	 * fmt_size bytes of it were initialized and fmt_size > 0
>> +	 */
>> +	if (fmt[--fmt_size] != 0)
>> +		return -EINVAL;
> ...
>> +/* Horrid workaround for getting va_list handling working with different
>> + * argument type combinations generically for 32 and 64 bit archs.
>> + */
>> +#define __BPF_SP_EMIT()	__BPF_ARG2_SP()
>> +#define __BPF_SP(...)							\
>> +	seq_printf(m, fmt, ##__VA_ARGS__)
>> +
>> +#define __BPF_ARG1_SP(...)						\
>> +	((mod[0] == 2 || (mod[0] == 1 && __BITS_PER_LONG == 64))	\
>> +	  ? __BPF_SP(arg1, ##__VA_ARGS__)				\
>> +	  : ((mod[0] == 1 || (mod[0] == 0 && __BITS_PER_LONG == 32))	\
>> +	      ? __BPF_SP((long)arg1, ##__VA_ARGS__)			\
>> +	      : __BPF_SP((u32)arg1, ##__VA_ARGS__)))
>> +
>> +#define __BPF_ARG2_SP(...)						\
>> +	((mod[1] == 2 || (mod[1] == 1 && __BITS_PER_LONG == 64))	\
>> +	  ? __BPF_ARG1_SP(arg2, ##__VA_ARGS__)				\
>> +	  : ((mod[1] == 1 || (mod[1] == 0 && __BITS_PER_LONG == 32))	\
>> +	      ? __BPF_ARG1_SP((long)arg2, ##__VA_ARGS__)		\
>> +	      : __BPF_ARG1_SP((u32)arg2, ##__VA_ARGS__)))
>> +
>> +	__BPF_SP_EMIT();
>> +	return seq_has_overflowed(m);
>> +}
> 
> This function is mostly a copy-paste of bpf_trace_printk() with difference
> of printing via seq_printf vs __trace_printk.
> Please find a way to share the code.

Will do.
