Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF5781E53E2
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 04:27:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726701AbgE1C1T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 22:27:19 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:11220 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725849AbgE1C1T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 22:27:19 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04S2NAnA016270;
        Wed, 27 May 2020 19:26:55 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=VpkCS8UwLIQfwOHYW6Zix77gZeckddU/lMQJVkDRmw8=;
 b=K4b0icFOTtTLoxuDl0v268VD6twcV6JoFgRJwLMwmkD4Y7SZEQVOtWMJSL6mYasjyoje
 bO9bFZWGm8nzydM9+tMsGrD3xADJdNow8vIow9O3HK8CV7wctIWB15YO8cp20SHt6H2o
 zLry9leJGKLnz1VFqyZ95ZABVRIRNbYecsk= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 317ktsv83y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 27 May 2020 19:26:55 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 27 May 2020 19:26:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YqI1J/XKjrEoNqEQv6w364WXX1vy3qYBAXtpbhF/LCg0aP7fz7vBDAKKsXPhlQ4eSzF0qFhDLx327lLf5TuQ8g17SMen0xVJ6ZvVN1XDwjMrtwUxg2TJ9+EkiQyW9hAyLXzJJhClgkt3yEB37+lZu2YaRH2JLcHmxWkuCso7OG8kKAFNQxkf7Tl3dG+fKQu1jxGQ4EPuK8BQ8yi4rVbWuFFp4Z9ZeAGoq26UQ/xyb+CyYwsTITWNIHnoNFwaQNxfBpdeZhQFcRWfJZ019kLqboODIPDt7gpSL/G1FGti7F3hHjIlcQE739J/MrNGQhbuTjwOj4nI6HbWGntVEC5W+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VpkCS8UwLIQfwOHYW6Zix77gZeckddU/lMQJVkDRmw8=;
 b=E7GMkh+Y87RQ/8KlAlUaNtHhj+hx5K4g20dfN1WWSk6lEOberqO/ux6tTCS9cbGTVHbtHuSsN6+Bvp63AKVE7J/RZwFIyJIL0D7Fze9MLN0ahxFHJ9zbZXnzSRAl8I9JMiyQstCHtqnT60+FFSz+ghaohwBQMXOg5v+JDYJDTKnu3SG9MRXOPPC2utExGi2eAQ2EaId+o+hlridOLZLzXeAMzL5foVlR5iKWspVa8U0G00s8fUegLgLtpiJeSNlx30e/G9lCNTLXMx5Gr55K0lKzj3yNjknq9xx5dyUtWULC9JqhCvtY4JoohAG/JUlHM2+DFEln/myUOgmTvQevJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VpkCS8UwLIQfwOHYW6Zix77gZeckddU/lMQJVkDRmw8=;
 b=Osw7WNTlwPU7FPks8m+tahYe0Vy413voz0kbf01OKTF89wSHsoC3K4KsddWj+Zr53Jrglsd5ZDe9cyoK/HMCvMaiF7RhAXedhgkt7MqKE7ImHqLr3p1lIRWs3Zc1PeGwuPXNRSR+cUxgEDrd5gHNNm+dwkBMLmctyv/tE+ECQ4k=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (52.135.225.146) by
 BYAPR15MB2566.namprd15.prod.outlook.com (20.179.155.152) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3021.24; Thu, 28 May 2020 02:26:53 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301%7]) with mapi id 15.20.3021.030; Thu, 28 May 2020
 02:26:53 +0000
Subject: Re: [PATCH 12/23] bpf: handle the compat string in
 bpf_trace_copy_string better
To:     Andrew Morton <akpm@linux-foundation.org>,
        Christoph Hellwig <hch@lst.de>
CC:     <x86@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        <linux-parisc@vger.kernel.org>, <linux-um@lists.infradead.org>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
References: <20200521152301.2587579-1-hch@lst.de>
 <20200521152301.2587579-13-hch@lst.de>
 <20200527190432.e4af1fba00c13cb1421f5a37@linux-foundation.org>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <2b64fae6-394c-c1e5-8963-c256f4284065@fb.com>
Date:   Wed, 27 May 2020 19:26:30 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.1
In-Reply-To: <20200527190432.e4af1fba00c13cb1421f5a37@linux-foundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR17CA0053.namprd17.prod.outlook.com
 (2603:10b6:a03:167::30) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from macbook-pro-52.local.dhcp.thefacebook.com (2620:10d:c090:400::5:730d) by BY5PR17CA0053.namprd17.prod.outlook.com (2603:10b6:a03:167::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.17 via Frontend Transport; Thu, 28 May 2020 02:26:50 +0000
X-Originating-IP: [2620:10d:c090:400::5:730d]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 68f4f339-7cfa-44d5-e2c9-08d802ae9555
X-MS-TrafficTypeDiagnostic: BYAPR15MB2566:
X-Microsoft-Antispam-PRVS: <BYAPR15MB256681A825F92783F8E55456D38E0@BYAPR15MB2566.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 0417A3FFD2
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cO+2vWK0q4q6n8OWfeoOpbjmCIQa4i075hzSJJgxcKQPQH3C6C6n+sau5NvtdB7YqSztLJitkvpkWMS8lpR3AgsKDxu0UDYkGfREzsvyHZu8lacnrYslJy2wWWy7+6hlu2Q5Pem/oCotGIAGATpB/IhRj0N2KQRMxTbgJqLKr6NtetTnA0RCYJSzzBifaxLG6JMV/ZdORe7PTj98bqX8qH3RSTnPzDeYNd/b7hnYLZq6HRsRswd7QB9haQ/ULY0cAjGfJpL1ZL2oXZZOv7gxzHKwpUpXCJvKpvMZLskCGyIrcXMO6fPybR/Mo8sI2rZnzYW5fZIQMClsD6W/ZLHN+9NBuWMg0qbZXmvsTjVBQdkCasJQ/W5niJMw9DacDiA5zYCnsdxNA7ffhWlBr0SWLw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(396003)(39860400002)(366004)(346002)(136003)(376002)(2616005)(110136005)(478600001)(316002)(31686004)(8676002)(53546011)(66556008)(8936002)(66946007)(6666004)(6506007)(66476007)(4326008)(6486002)(54906003)(31696002)(5660300002)(2906002)(7416002)(6512007)(16526019)(52116002)(86362001)(83380400001)(36756003)(186003)(21314003)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: iNLhMXT5NuIG4iVeuFVfwjB06rdGcGNs2C8tqo+TXTXDY+TH/8Q9gBe8ls+UJuDeRSDslARHpEav9QHth2wnXw3wpKSwEhdS99aQVuTCWNwVL4MRa7m+5GNmwVs3D4i6jx6l+AEc66mzFYzPL9qEkwTNAYdSFY658zd6aafW6N51Fv4DhnCSYhaaQ2z9nf8Ok3Y7SFWkEnSnzg95XgKj92NJxTxnB3ZsLqVjaeWd0FEABRXLrZBo9EzDijxzxf8Tzp/m0ery7UPqTFEzJw61+SMl5Itrw9NGUoMgTiiUViWLQtKLzmKhylogtWAqAFW41eB0OLttTLZ5k9iEQXnrLZHXWdbhNg8mtwRm1/W8gufIRTi1NWnQZ8/7XHCIMQSLwy8gQzLUyoXJoV0UzTK6m/fA/wV0su1JExQNkMesAyK3MgQDIsKdclrLsZYskD25QjbDCXbzarTd74mr66SDu7pCP4zvB8kgP8+l1m4SVeZo1uByKUoOF4EvQia4j4OEYRJdEaZ5VqDGn7OJ0QCaBw==
X-MS-Exchange-CrossTenant-Network-Message-Id: 68f4f339-7cfa-44d5-e2c9-08d802ae9555
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2020 02:26:52.8842
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xDxFUc48sZRxKJAVibavYQjZJVrUNBgBKvL5de8isesxUeL39liqDVG8Z9aTyrSe
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2566
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-05-27_04:2020-05-27,2020-05-27 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 cotscore=-2147483648 phishscore=0 impostorscore=0 adultscore=0
 mlxlogscore=999 clxscore=1011 bulkscore=0 spamscore=0 mlxscore=0
 lowpriorityscore=0 malwarescore=0 suspectscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005280009
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/27/20 7:04 PM, Andrew Morton wrote:
> On Thu, 21 May 2020 17:22:50 +0200 Christoph Hellwig <hch@lst.de> wrote:
> 
>> User the proper helper for kernel or userspace addresses based on
>> TASK_SIZE instead of the dangerous strncpy_from_unsafe function.
>>
>> ...
>>
>> --- a/kernel/trace/bpf_trace.c
>> +++ b/kernel/trace/bpf_trace.c
>> @@ -331,8 +331,11 @@ static void bpf_trace_copy_string(char *buf, void *unsafe_ptr, char fmt_ptype,
>>   	switch (fmt_ptype) {
>>   	case 's':
>>   #ifdef CONFIG_ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE
>> -		strncpy_from_unsafe(buf, unsafe_ptr, bufsz);
>> -		break;
>> +		if ((unsigned long)unsafe_ptr < TASK_SIZE) {
>> +			strncpy_from_user_nofault(buf, user_ptr, bufsz);
>> +			break;
>> +		}
>> +		fallthrough;
>>   #endif
>>   	case 'k':
>>   		strncpy_from_kernel_nofault(buf, unsafe_ptr, bufsz);
> 
> Another user of strncpy_from_unsafe() has popped up in linux-next's
> bpf.  I did the below, but didn't try very hard - it's probably wrong
> if CONFIG_ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE=n?
> 
> Anyway, please take a look at all the bpf_trace.c changes in
> linux-next.
> 
> 
> From: Andrew Morton <akpm@linux-foundation.org>
> Subject: bpf:bpf_seq_printf(): handle potentially unsafe format string better
> 
> User the proper helper for kernel or userspace addresses based on
> TASK_SIZE instead of the dangerous strncpy_from_unsafe function.
> 
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Alexei Starovoitov <ast@kernel.org>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Masami Hiramatsu <mhiramat@kernel.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>   kernel/trace/bpf_trace.c |   13 ++++++++++---
>   1 file changed, 10 insertions(+), 3 deletions(-)
> 
> --- a/kernel/trace/bpf_trace.c~xxx
> +++ a/kernel/trace/bpf_trace.c
> @@ -588,15 +588,22 @@ BPF_CALL_5(bpf_seq_printf, struct seq_fi
>   		}
>   
>   		if (fmt[i] == 's') {
> +			void *unsafe_ptr;
> +
>   			/* try our best to copy */
>   			if (memcpy_cnt >= MAX_SEQ_PRINTF_MAX_MEMCPY) {
>   				err = -E2BIG;
>   				goto out;
>   			}
>   
> -			err = strncpy_from_unsafe(bufs->buf[memcpy_cnt],
> -						  (void *) (long) args[fmt_cnt],
> -						  MAX_SEQ_PRINTF_STR_LEN);
> +			unsafe_ptr = (void *)(long)args[fmt_cnt];
> +			if ((unsigned long)unsafe_ptr < TASK_SIZE) {
> +				err = strncpy_from_user_nofault(
> +					bufs->buf[memcpy_cnt], unsafe_ptr,
> +					MAX_SEQ_PRINTF_STR_LEN);
> +			} else {
> +				err = -EFAULT;
> +			}

This probably not right.
The pointer stored at args[fmt_cnt] is a kernel pointer,
but it could be an invalid address and we do not want to fault.
Not sure whether it exists or not, we should use 
strncpy_from_kernel_nofault()?

>   			if (err < 0)
>   				bufs->buf[memcpy_cnt][0] = '\0';
>   			params[fmt_cnt] = (u64)(long)bufs->buf[memcpy_cnt];
> _
> 
