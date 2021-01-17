Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A0AB2F9029
	for <lists+netdev@lfdr.de>; Sun, 17 Jan 2021 03:14:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727974AbhAQCN2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jan 2021 21:13:28 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:26196 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727629AbhAQCNY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Jan 2021 21:13:24 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10H24ThL023738;
        Sat, 16 Jan 2021 18:11:57 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=RR4gMMEi5HI47p9rmeSSdaxz3P2VqfFJFjVVXVexnSY=;
 b=LA5brx7/dum41fYN5e7ZFsHY1AsE5ZSyadNoGwNUucOT0yA0yMnnk/VIMzcP0zZPxwTW
 MSOESINbf+xpeoWe9j2sPXeZ+yRviBXsBY/UN1LDtBVdiFqLk0khDKhTcfPmZnURAENr
 PGXgZzpYlexdKHNHfpMfLN9XiYvoI55/57U= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3640b11nuh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sat, 16 Jan 2021 18:11:57 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Sat, 16 Jan 2021 18:11:56 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YZYZyt5vlnQ7TSg9bxHpjcWywDedSxpzrQT3sTH62+2Vhg+XrY5G2Q4220YNsakmnxKYQ7TfvJYpACuCvw398uWqvnvnyq3oz+AgbW3SSEymjDgC4Y3LiUnkF9ECEBf6XcfMG0WBqU/rWfaIiA0c6pP7TDcCUrpf5HInsroMbeSvY00Ly2y4sn48HIGYh89zXED4CyLiarR5+zLmjns5d/iXDzKD0XmV3gEc9AC555DXuboj2RsfRs2CQtJnfuZyBeBnV6zNQV+tu17Qy3O2AuBj5SV8pd+B+H17g01RNBTWDhK/jTq793ONWy6ZTylIU8IwvLI5QZ04iUb41PScqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RR4gMMEi5HI47p9rmeSSdaxz3P2VqfFJFjVVXVexnSY=;
 b=OOyUKCUgg3QRL2nNOnohenG0mZj85I9xbhgtyl3j8HEBs+TYs5bsEEmqiIVUvTEIjPpmdttPkGsOLSwhgcj2y/X7t1DegdrtXdJcFBxCbdq73kiu8cscwuzHRf5ksSZKURoEdjwAYWmRAB6jAoKDRIJAk/Ra5KL/RuVqyPFAg4BT7LZCSdYaSr1AQ2ga8gwTobL0riuAN2Q2/XMbEGnKcjqP4kD2gtE6LY4A7z9+OrG4uFPB11TohJGalC0+EMuuj6ClSNmwlp3i5/wzTLY3nSdroA6AspO0Xgg47eUMPwNfcwVFZyZga+mGengeQt5HZcN9yvA4UiINIvfCdAExGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RR4gMMEi5HI47p9rmeSSdaxz3P2VqfFJFjVVXVexnSY=;
 b=F3uSARPkHLoPrSjsZw5SsqY/BVQdYv6c3Em1lsNJltyYImIiJqZgOTnx6z8X/4pTFc3hIMIh4nh34pdPwWaK6MpRZMZK0n70jHXb+EeofYCapatF4AZUyaetxKtf780u1rzBAj0Q0eCK96cF5SaC1BX7cLRHMhhTmMYjmKPpcRM=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BY5PR15MB3714.namprd15.prod.outlook.com (2603:10b6:a03:1f7::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.14; Sun, 17 Jan
 2021 02:11:52 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03%7]) with mapi id 15.20.3763.014; Sun, 17 Jan 2021
 02:11:52 +0000
Subject: Re: [PATCH v2 bpf-next 2/2] selftests: bpf: Add a new test for bare
 tracepoints
To:     Qais Yousef <qais.yousef@arm.com>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        <linux-kernel@vger.kernel.org>
References: <20210116182133.2286884-1-qais.yousef@arm.com>
 <20210116182133.2286884-3-qais.yousef@arm.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <e9d4b132-288d-594f-308c-132e89fcf63f@fb.com>
Date:   Sat, 16 Jan 2021 18:11:50 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
In-Reply-To: <20210116182133.2286884-3-qais.yousef@arm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:a571]
X-ClientProxiedBy: MW3PR06CA0030.namprd06.prod.outlook.com
 (2603:10b6:303:2a::35) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21c8::1366] (2620:10d:c090:400::5:a571) by MW3PR06CA0030.namprd06.prod.outlook.com (2603:10b6:303:2a::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3721.23 via Frontend Transport; Sun, 17 Jan 2021 02:11:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5f43a73c-68b8-46c7-119b-08d8ba8d415a
X-MS-TrafficTypeDiagnostic: BY5PR15MB3714:
X-Microsoft-Antispam-PRVS: <BY5PR15MB3714A433717AA2E5E7B07121D3A50@BY5PR15MB3714.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:227;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: P9hR8cBCydEr6eH1LnrFdCEtANccsi5bEWAFGjA1LvloC7VsicervGvo7ScEwUUDlD0Y6yY3pXG+lO5u4Kt1TgIejWu/HDQka0ZJMiTK/14IeTAD7IqHULOuHtKStSGYfeSZOiUdLsH5dcvkfVZIlIFI0MR1g5H7mvHtdiDUw2aCM2wClclbs5KtpGPW0Eley6y+XWCSOXxEI6q5vL/lAKlUv4rpypxyazRvqz3FcPG2/QyJpcjOBTVbAPLzMCcTHAWXxbSOaMvnoduBHTOOSMXRT9ME0XHBI0zmSEOdWDbXEOXCFBWSnWvIPumrz13H2Y6zvILZ12etRy1ramsqM8d0eguWGt+N9QumW0u38584xf9+poM89re2lPAOwxS7tn0RgYq5XyY5bw5tyNSukm+tdIBVObIxgy1lzajALrFGeZlfup0AimTbW0tQg03xP6tv37XO7WTJx/ft77OnGAkAPUJpbmy0hd4BXNvHQLQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(366004)(396003)(136003)(39860400002)(36756003)(31696002)(186003)(2616005)(16526019)(53546011)(66556008)(8936002)(66946007)(66476007)(5660300002)(31686004)(83380400001)(316002)(52116002)(6486002)(54906003)(8676002)(478600001)(2906002)(86362001)(4326008)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?OFF0aEliQ0Rud3VOU09rNGd5ZWRERGU1Y0JEc2xHblJhVjJTblErNDNsbjZM?=
 =?utf-8?B?Z2hWUFdtUVNadXowbzZvVyttZ0IwWGxOR0ZGMTk4Y0k4TUJuc21tYWJVM2NR?=
 =?utf-8?B?N0lVOUdKd0l2czRSZGtWM3ZxUW1HMXhjWjR6MjVCaDRnNGdIYXBHekE3MUFv?=
 =?utf-8?B?ZUs2b3BLUnlHRjlzTktoNlNtN0FpcFNYTCsxTWhtSENKc0xZNHlYTG9DWmNI?=
 =?utf-8?B?d1M5RWFiT0hqOXFabFFJMHdRZWRTc0tRL3N5UTBzd0k1cmNDOEJJY3RMZ3pa?=
 =?utf-8?B?RGdhdkREbTQwcjNNbU8vTkJzKzdlOHBTRWFBem1JRERzL3I4VWxkNHpSOElQ?=
 =?utf-8?B?WVN4M0NJME83ZVZtaGhDVGpNd2tLMWRMMmd6amJIQzBveTBsNVFFZFlzOTdB?=
 =?utf-8?B?U2pyZllURTJ2ZFY3RUdUWUFLL21vWldQQzdhY09UaUp5MjRiNVlmSW1BRG5Q?=
 =?utf-8?B?ZWtPOWM0K3VmeEN1cDRoMkIrSnU0R2wrallYNzJxY0lOcUcrU09LdmJFOUtE?=
 =?utf-8?B?aVRTazkyM0YyOThOek5SeWhsK1ZYajd4RHRUWW9BN3JnQi8zY1I0VlVqRTA0?=
 =?utf-8?B?WkI4aEw0NE9uMGZEL3FFMXl2aUticnhBL2RBb1VoMHFzcEhTbWQ2dDNMVmNz?=
 =?utf-8?B?MlFKTTB4MS9KcXU0akZwSDY5T0pQN1FjeG9OMm1lNUVLVUp6RzJWbXNiV2NK?=
 =?utf-8?B?UHJiY0JpNWNRcFZoMkpHbnFzVGpwQU5tbGhjZVlvWHdqZ0JLUU5TaHN3RkZl?=
 =?utf-8?B?R1NwUEx3aGlaZEJtMWlWSVNhZ1pTcXNYL3loY1ZseXlNN2pGd0NPMVZURkZo?=
 =?utf-8?B?aFhBRlpwWFYwSmlSblF4RWd5MURBd2RXSVQ0Z2F2OVgweE1aK0IwYmNtQ2xm?=
 =?utf-8?B?Mkl5c29HTzhhY2o3a2ZYTVRGN2FPNExkSm9EVVQ2ZTBBU0psRWZwcS85Y2kz?=
 =?utf-8?B?bnhYZUNBeHRidm9FTUtzRmtVQW9sSUNmQ1pPYWZPRlA0ZHNxbE1tZE5lMmow?=
 =?utf-8?B?YWJ3dFlvWTlqMms3bERJL1lwM2g2b2JuWnVQTlF0cGNvRlE4YTJReWJ2NDc4?=
 =?utf-8?B?WWplNE1LK2RxcEtUR2FZRlp6cHpzMGNiYmR0akJjeDRFN1NLYkpzbzN5dDRr?=
 =?utf-8?B?OHo0b3FPVkx5RW5HcnVYeEFPaWtrd3M1VTQ3WEQyWm1jVFBBNXJLSnNZVjJC?=
 =?utf-8?B?Z0djclNNL3V4T0ZybFlWNmNZR3EvbmNNRGYyL2ExQ3I3VHZaZi9TSlVRR254?=
 =?utf-8?B?aVRaMGRqYkxMTFFFekE4elNheVMySjZIajlST2NORXM4YVJXaGNUR0E5aG5l?=
 =?utf-8?B?aFdhWVBGU0tMdmpzelhmMXFFTlYvekRjM0NjY0ovTXpYWTFGb0RlVVEzUHRT?=
 =?utf-8?B?VHBFZmZKWlJBNHc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f43a73c-68b8-46c7-119b-08d8ba8d415a
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jan 2021 02:11:52.4071
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nNuOWI7iT+Ds+Qx5JjtRCX9AYEe9uzWYlKsgxiMec4wlJFw1vecc6zWGJcmjurMv
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR15MB3714
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-16_16:2021-01-15,2021-01-16 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 phishscore=0 adultscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999
 priorityscore=1501 malwarescore=0 spamscore=0 impostorscore=0
 lowpriorityscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2101170011
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/16/21 10:21 AM, Qais Yousef wrote:
> Reuse module_attach infrastructure to add a new bare tracepoint to check
> we can attach to it as a raw tracepoint.
> 
> Signed-off-by: Qais Yousef <qais.yousef@arm.com>
> ---
>   .../bpf/bpf_testmod/bpf_testmod-events.h      |  6 +++++
>   .../selftests/bpf/bpf_testmod/bpf_testmod.c   | 21 ++++++++++++++-
>   .../selftests/bpf/bpf_testmod/bpf_testmod.h   |  6 +++++
>   .../selftests/bpf/prog_tests/module_attach.c  | 27 +++++++++++++++++++
>   .../selftests/bpf/progs/test_module_attach.c  | 10 +++++++
>   5 files changed, 69 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod-events.h b/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod-events.h
> index b83ea448bc79..89c6d58e5dd6 100644
> --- a/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod-events.h
> +++ b/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod-events.h
> @@ -28,6 +28,12 @@ TRACE_EVENT(bpf_testmod_test_read,
>   		  __entry->pid, __entry->comm, __entry->off, __entry->len)
>   );
>   
> +/* A bare tracepoint with no event associated with it */
> +DECLARE_TRACE(bpf_testmod_test_write_bare,
> +	TP_PROTO(struct task_struct *task, struct bpf_testmod_test_write_ctx *ctx),
> +	TP_ARGS(task, ctx)
> +);
> +
>   #endif /* _BPF_TESTMOD_EVENTS_H */
>   
>   #undef TRACE_INCLUDE_PATH
> diff --git a/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c b/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c
> index 2df19d73ca49..e900adad2276 100644
> --- a/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c
> +++ b/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c
> @@ -28,9 +28,28 @@ bpf_testmod_test_read(struct file *file, struct kobject *kobj,
>   EXPORT_SYMBOL(bpf_testmod_test_read);
>   ALLOW_ERROR_INJECTION(bpf_testmod_test_read, ERRNO);
>   
> +noinline ssize_t
> +bpf_testmod_test_write(struct file *file, struct kobject *kobj,
> +		      struct bin_attribute *bin_attr,
> +		      char *buf, loff_t off, size_t len)
> +{
> +	struct bpf_testmod_test_write_ctx ctx = {
> +		.buf = buf,
> +		.off = off,
> +		.len = len,
> +	};
> +
> +	trace_bpf_testmod_test_write_bare(current, &ctx);
> +
> +	return -EIO; /* always fail */
> +}
> +EXPORT_SYMBOL(bpf_testmod_test_write);
> +ALLOW_ERROR_INJECTION(bpf_testmod_test_write, ERRNO);
> +
>   static struct bin_attribute bin_attr_bpf_testmod_file __ro_after_init = {

Do we need to remove __ro_after_init?

> -	.attr = { .name = "bpf_testmod", .mode = 0444, },
> +	.attr = { .name = "bpf_testmod", .mode = 0666, },
>   	.read = bpf_testmod_test_read,
> +	.write = bpf_testmod_test_write,
>   };
>   
>   static int bpf_testmod_init(void)
> diff --git a/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.h b/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.h
> index b81adfedb4f6..b3892dc40111 100644
> --- a/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.h
> +++ b/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.h
> @@ -11,4 +11,10 @@ struct bpf_testmod_test_read_ctx {
>   	size_t len;
>   };
>   
> +struct bpf_testmod_test_write_ctx {
> +	char *buf;
> +	loff_t off;
> +	size_t len;
> +};
> +
>   #endif /* _BPF_TESTMOD_H */
> diff --git a/tools/testing/selftests/bpf/prog_tests/module_attach.c b/tools/testing/selftests/bpf/prog_tests/module_attach.c
> index 50796b651f72..e4605c0b5af1 100644
> --- a/tools/testing/selftests/bpf/prog_tests/module_attach.c
> +++ b/tools/testing/selftests/bpf/prog_tests/module_attach.c
> @@ -21,9 +21,34 @@ static int trigger_module_test_read(int read_sz)
>   	return 0;
>   }
>   
> +static int trigger_module_test_write(int write_sz)
> +{
> +	int fd, err;

Init err = 0?

> +	char *buf = malloc(write_sz);
> +
> +	if (!buf)
> +		return -ENOMEM;

Looks like we already non-negative value, so return ENOMEM?

> +
> +	memset(buf, 'a', write_sz);
> +	buf[write_sz-1] = '\0';
> +
> +	fd = open("/sys/kernel/bpf_testmod", O_WRONLY);
> +	err = -errno;
> +	if (CHECK(fd < 0, "testmod_file_open", "failed: %d\n", err))
> +		goto out;

Change the above to
	fd = open("/sys/kernel/bpf_testmod", O_WRONLY);
	if (CHECK(fd < 0, "testmod_file_open", "failed: %d\n", errno)) {
		err = -errno;
		goto out;
	}

> +
> +	write(fd, buf, write_sz);
> +	close(fd);
> +out:
> +	free(buf);
> +

No need for extra line here.

> +	return 0;

return err.

> +}
> +
>   void test_module_attach(void)
>   {
>   	const int READ_SZ = 456;
> +	const int WRITE_SZ = 457;
>   	struct test_module_attach* skel;
>   	struct test_module_attach__bss *bss;
>   	int err;
> @@ -48,8 +73,10 @@ void test_module_attach(void)
>   
>   	/* trigger tracepoint */
>   	ASSERT_OK(trigger_module_test_read(READ_SZ), "trigger_read");
> +	ASSERT_OK(trigger_module_test_write(WRITE_SZ), "trigger_write");
>   
>   	ASSERT_EQ(bss->raw_tp_read_sz, READ_SZ, "raw_tp");
> +	ASSERT_EQ(bss->raw_tp_bare_write_sz, WRITE_SZ, "raw_tp_bare");
>   	ASSERT_EQ(bss->tp_btf_read_sz, READ_SZ, "tp_btf");
>   	ASSERT_EQ(bss->fentry_read_sz, READ_SZ, "fentry");
>   	ASSERT_EQ(bss->fentry_manual_read_sz, READ_SZ, "fentry_manual");
> diff --git a/tools/testing/selftests/bpf/progs/test_module_attach.c b/tools/testing/selftests/bpf/progs/test_module_attach.c
> index efd1e287ac17..bd37ceec5587 100644
> --- a/tools/testing/selftests/bpf/progs/test_module_attach.c
> +++ b/tools/testing/selftests/bpf/progs/test_module_attach.c
> @@ -17,6 +17,16 @@ int BPF_PROG(handle_raw_tp,
>   	return 0;
>   }
>   
> +__u32 raw_tp_bare_write_sz = 0;
> +
> +SEC("raw_tp/bpf_testmod_test_write_bare")
> +int BPF_PROG(handle_raw_tp_bare,
> +	     struct task_struct *task, struct bpf_testmod_test_write_ctx *write_ctx)
> +{
> +	raw_tp_bare_write_sz = BPF_CORE_READ(write_ctx, len);
> +	return 0;
> +}
> +
>   __u32 tp_btf_read_sz = 0;
>   
>   SEC("tp_btf/bpf_testmod_test_read")
> 
