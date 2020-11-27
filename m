Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18BBE2C6047
	for <lists+netdev@lfdr.de>; Fri, 27 Nov 2020 08:01:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405145AbgK0HAu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 02:00:50 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:55678 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727612AbgK0HAs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Nov 2020 02:00:48 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AR6xHe3013968;
        Thu, 26 Nov 2020 23:00:12 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=2Xm+SkVQYcdyha7F+OXvAsn9MZFVRSF/cv3ybIRoAY8=;
 b=oxkUUUFP6Vjn+/HPZTag/VfyxgazKf971QuDOKfJRwSnksgUhTKu8vjSGBNRVm/Q6E43
 avBHNA98ijiMSZ8//VcCnBYGeUG5tHvhb9Ctmq2SNXQdY49tDN/wVsFppN+TH2AaOKLP
 57o6NjvYrssCXT1GbgDqC6G6GucMuVEGJ8c= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 352s3n0ma4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 26 Nov 2020 23:00:12 -0800
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 26 Nov 2020 23:00:11 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lyJOqcLbNjE5KtVWC1wmRJe+QIo1ZIGTSzyO9dG6qCC+hRuPFekF8j28TWxIukuk6c01L5hw2vk8e62uXiia9bAD+a6fW8VQ5YfQfXEhGMCq0dThjctYGIA1xa2bcM/tZ52rDjxhTCnTUTWaTqH39EHVaAToS1lWFfknhuxFEGjuUZ/T8obHYxA5QLJkgDU1WsO/fElhe+ANQNvrzqeg35W4WgsOLmDhwLSOVmnoL1GVHlBSv69n06a29nH3m1sH2pTGrwayG+TgfN7LHbWVeHmGKwqkizA67pNHJkwcKVzBXy/LfUA3kGeT560lgqCotCghQEW5+YebxTU3U688sw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2Xm+SkVQYcdyha7F+OXvAsn9MZFVRSF/cv3ybIRoAY8=;
 b=hfbM9T4BFBtxC6h48dxZcOpXtspA14sv/JOt9sgaJNBHt+V70kAVU7zyIQwoZlUZf9r7U0Xudi/iqN/V+74joErfDSVE+0jNeqAFxW6H4/nn/T9H7+Fw9L8FgL708ec2IjCkkWlMQcB0GN3qIGFaCNucRFg5kmk38XrLXxi6rxeB6JCrlmcGBVSDvD2tsUtmFl/clIeQVsfChKWdL7HXiT/ZqY9zog7xDaiA/XDZSNVmmvrP7q3PCoddUBB1vXRA4wHtqCPVKP0Xby8IyzYygHO/qhjrdtDCuFNWMfKhc2Eiud5b4MuoTGfSs8WMT6cw0BQM9X88QIfLl3c66nrR0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2Xm+SkVQYcdyha7F+OXvAsn9MZFVRSF/cv3ybIRoAY8=;
 b=E4GnNq/obhSqkUOqm6wPxlyG95BxvB3ybeHl+M+diwP8FSCtJOxRYCBWHY9UScmKz2rFj75p4Ny3/47tk5iDIGsLYMriqbvf4XjA6ProSDN2CXeURxE01oYbqLB3dt6Q+l/YlvpkDsegxJoG/WA9FadEQEEiYwkI/ljKwSyn0I0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2886.namprd15.prod.outlook.com (2603:10b6:a03:f7::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.22; Fri, 27 Nov
 2020 07:00:05 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03%7]) with mapi id 15.20.3611.025; Fri, 27 Nov 2020
 07:00:05 +0000
Subject: Re: [PATCH bpf-next v3 5/6] bpf: Add an iterator selftest for
 bpf_sk_storage_get
To:     Florent Revest <revest@chromium.org>, <bpf@vger.kernel.org>
CC:     <viro@zeniv.linux.org.uk>, <davem@davemloft.net>,
        <kuba@kernel.org>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <kafai@fb.com>, <andrii@kernel.org>, <kpsingh@chromium.org>,
        <revest@google.com>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>
References: <20201126164449.1745292-1-revest@google.com>
 <20201126164449.1745292-5-revest@google.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <2c5a814a-7b69-3a8d-e4e0-e595d009cf82@fb.com>
Date:   Thu, 26 Nov 2020 23:00:02 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.0
In-Reply-To: <20201126164449.1745292-5-revest@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:7e72]
X-ClientProxiedBy: CO2PR04CA0160.namprd04.prod.outlook.com
 (2603:10b6:104:4::14) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21cf::1008] (2620:10d:c090:400::5:7e72) by CO2PR04CA0160.namprd04.prod.outlook.com (2603:10b6:104:4::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.20 via Frontend Transport; Fri, 27 Nov 2020 07:00:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2ad5218c-a314-47f4-ddcf-08d892a211d4
X-MS-TrafficTypeDiagnostic: BYAPR15MB2886:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB28864057EAB1690BDF2BA0D7D3F80@BYAPR15MB2886.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:2657;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Fy9ZS8Nhv+mkU1Bx2hJLy67y5YSIVWe7ld0xnaGBwiFhtb4f+grP4Ka/Z9suCFfsMffwgioVjKVbp68c8bjnKinLOjBXMkJxrh7mRBWYfmSTQ+A83IeCt48pyA6Vc6iysxCmZSzzP+B58mLaHsSuJr3sNf8CY9oDBG6ceyRHhU4iH+fRLxM8lIfSea0wRI2NmhQGeZ4DmdHZy/2kJOyC45E2QBNo2Ql5Mvcl+6KvAdO3j8ENqPFeyNapRQLURoI2oRb6XMexPxSm5UbHgHXtTdATzCCAZhRmhToRR+ratr9duVzti/V9sMbymdwju1VJNefQyng7OKVxWbGZpZ+jR5Ta73x/6WfbCbxUHgszYAswybFuYskKF5umteJDqLZm
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(346002)(376002)(366004)(136003)(53546011)(52116002)(4326008)(83380400001)(86362001)(36756003)(31696002)(478600001)(31686004)(66946007)(5660300002)(16526019)(6486002)(8936002)(316002)(2616005)(66556008)(186003)(2906002)(8676002)(7416002)(66476007)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?QnN6N0cxMUptK2drMndkQnB6RXVmZWdHUFlyR3grVGNRVS9pbnhaRkI1RXcr?=
 =?utf-8?B?ME9UQy9XSkswNWUxM01sSjJNL0JGNXBZVVU5TWYxT0ZSS2JxbXd4Uzc0dVZn?=
 =?utf-8?B?bXVpVzg1Si9HVVJRa1liMnRnN2FtZkhGSERteUZXWndSQWRaZWFVVFlLN2ph?=
 =?utf-8?B?Smd5Q0dMT3JnTCtlVzFCV1g1SlNaakVKUjVpM0JoZ2pvaytLOWZlNi9Ic1Ja?=
 =?utf-8?B?Y1VrS1hxZ0JXNTduMk5YalRYSXdMQ0ZvbUZwVWxiTDZPMzFFVVV0b2pManV5?=
 =?utf-8?B?UStjaGhKT2dabWo2RzF2cEZ3YXRlRStXYXJPcU9nTHl2WTRGWDZsbWxiSW5Z?=
 =?utf-8?B?SmNhYVg1elYxZlRvUlRZT1dhUmxZc056RGFuOTJxZHloN1NCbkRRVTFqTEtP?=
 =?utf-8?B?QldRVFRtQlQzQ0xiS3pPMG9NeDAxUTBkdk96QVloUEI3RnVZZGJaRXpYRGtq?=
 =?utf-8?B?MmRaTnpPK0N0SC9XajVZd2NWWWJzS2FDTXdsd3ZYejBrWGNQSXB6NXlIaUNi?=
 =?utf-8?B?OXVRM29sR2I3TEszcjQ5RFRFUE51OTZmQlRNUS83UFFOQzIvTWpwTE84S281?=
 =?utf-8?B?cHZiUkpLZTB4eWgvVE9TYzdha1k1eVV0dmRVbUxsQzd2dnJhQUpTWHdPcHNt?=
 =?utf-8?B?RmZoanhCd2FtcnhqQkZJTVBCMlZ4YW1VckhPWFZiVWdsVy82YmVjRWRrMXNP?=
 =?utf-8?B?ODlPN0dTbDlQUEo1WW9IcWN3OXFORzA0UUxhOXozdmE0R2Y5SUFOcnJFM2Ix?=
 =?utf-8?B?MEI0OFpuR1Vmc2JaMVFxaWFhLzBaOXM5UzhlVk1JdUQ0L29lU2ZmbFFvYUZ0?=
 =?utf-8?B?ZzJBYXZFaWF0Yk5yY1J0dENucXd2b1B3L2lYZnFncllzWUtRMmpRbHFiWnFF?=
 =?utf-8?B?SU9MMjdLRXNSaEtjOVJyMUVhQXU3cDI4alhVMnVBcWs2ZVlyZmtoNkdobk1t?=
 =?utf-8?B?TklOQzl0SmNIREY3WEpjUE1KdEU0NGtHL2w3ZkJRZU9jYUI1dlRhKzhSMzFo?=
 =?utf-8?B?SDE3Rkt6Wko2NkMyZkV1RVBQS1djNU9CSVJ6dnZuRkl2MEEyL0ZsQ1FDejY0?=
 =?utf-8?B?V05manJ3VUVGdlpTOGVyNXdFRjgwNU8zQVMwaDBaY0tSQ0FtKzU2YW4zTmN3?=
 =?utf-8?B?ei9xL3o3SzliN0tFNjNQVWt3bVpKbGhLWVlteFluZEo0Sjl0N21QdENFZUp4?=
 =?utf-8?B?aStqWUk4WURUNit2cTMwZVQ2bmZPU3h1RTFvbzRtbDViTEh1RmNxN21PTGVj?=
 =?utf-8?B?NXlsMEJvQ0M2TVJVVkphZ1o2ZDBqRVJzcVlsazZxTVhEMEd5eTZkbEtqMFNp?=
 =?utf-8?B?dTd4UVpKaS8ydThFZlk4Z0lzbE5iYm54aGFKdEdrL01DbzNvRVI2T1gxV09K?=
 =?utf-8?B?cEFZTDAvZmFvU0E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ad5218c-a314-47f4-ddcf-08d892a211d4
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2020 07:00:05.6294
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Vta5fqUZaCcHN58SNZY9w2QyVp0YxNOoKxPwVD+aDMjTwVm418fkrQx3ujdYrfa9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2886
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-27_04:2020-11-26,2020-11-27 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 bulkscore=0 malwarescore=0 phishscore=0 adultscore=0 clxscore=1015
 spamscore=0 mlxlogscore=999 impostorscore=0 lowpriorityscore=0
 priorityscore=1501 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2011270040
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/26/20 8:44 AM, Florent Revest wrote:
> The eBPF program iterates over all files and tasks. For all socket
> files, it stores the tgid of the last task it encountered with a handle
> to that socket. This is a heuristic for finding the "owner" of a socket
> similar to what's done by lsof, ss, netstat or fuser. Potentially, this
> information could be used from a cgroup_skb/*gress hook to try to
> associate network traffic with processes.
> 
> The test makes sure that a socket it created is tagged with prog_tests's
> pid.
> 
> Signed-off-by: Florent Revest <revest@google.com>

Ack with two minor comments below.

Acked-by: Yonghong Song <yhs@fb.com>


> ---
>   .../selftests/bpf/prog_tests/bpf_iter.c       | 40 +++++++++++++++++++
>   .../progs/bpf_iter_bpf_sk_storage_helpers.c   | 25 ++++++++++++
>   2 files changed, 65 insertions(+)
> 
> diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_iter.c b/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
> index bb4a638f2e6f..9336d0f18331 100644
> --- a/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
> +++ b/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
> @@ -975,6 +975,44 @@ static void test_bpf_sk_storage_delete(void)
>   	bpf_iter_bpf_sk_storage_helpers__destroy(skel);
>   }
>   
> +/* This creates a socket and its local storage. It then runs a task_iter BPF
> + * program that replaces the existing socket local storage with the tgid of the
> + * only task owning a file descriptor to this socket, this process, prog_tests.
> + */
> +static void test_bpf_sk_storage_get(void)
> +{
> +	struct bpf_iter_bpf_sk_storage_helpers *skel;
> +	int err, map_fd, val = -1;
> +	int sock_fd = -1;
> +
> +	skel = bpf_iter_bpf_sk_storage_helpers__open_and_load();
> +	if (CHECK(!skel, "bpf_iter_bpf_sk_storage_helpers__open_and_load",
> +		  "skeleton open_and_load failed\n"))
> +		return;
> +
> +	sock_fd = socket(AF_INET6, SOCK_STREAM, 0);
> +	if (CHECK(sock_fd < 0, "socket", "errno: %d\n", errno))
> +		goto out;
> +
> +	map_fd = bpf_map__fd(skel->maps.sk_stg_map);
> +
> +	err = bpf_map_update_elem(map_fd, &sock_fd, &val, BPF_NOEXIST);
> +	if (CHECK(err, "bpf_map_update_elem", "map_update_failed\n"))
> +		goto close_socket;
> +
> +	do_dummy_read(skel->progs.fill_socket_owner);
> +
> +	err = bpf_map_lookup_elem(map_fd, &sock_fd, &val);
> +	CHECK(err || val != getpid(), "bpf_map_lookup_elem",
> +	      "map value wasn't set correctly (expected %d, got %d, err=%d)\n",
> +	      getpid(), val, err);
> +
> +close_socket:
> +	close(sock_fd);
> +out:
> +	bpf_iter_bpf_sk_storage_helpers__destroy(skel);
> +}
> +
>   static void test_bpf_sk_storage_map(void)
>   {
>   	DECLARE_LIBBPF_OPTS(bpf_iter_attach_opts, opts);
> @@ -1131,6 +1169,8 @@ void test_bpf_iter(void)
>   		test_bpf_sk_storage_map();
>   	if (test__start_subtest("bpf_sk_storage_delete"))
>   		test_bpf_sk_storage_delete();
> +	if (test__start_subtest("bpf_sk_storage_get"))
> +		test_bpf_sk_storage_get();
>   	if (test__start_subtest("rdonly-buf-out-of-bound"))
>   		test_rdonly_buf_out_of_bound();
>   	if (test__start_subtest("buf-neg-offset"))
> diff --git a/tools/testing/selftests/bpf/progs/bpf_iter_bpf_sk_storage_helpers.c b/tools/testing/selftests/bpf/progs/bpf_iter_bpf_sk_storage_helpers.c
> index 01ff3235e413..d7a7a802d172 100644
> --- a/tools/testing/selftests/bpf/progs/bpf_iter_bpf_sk_storage_helpers.c
> +++ b/tools/testing/selftests/bpf/progs/bpf_iter_bpf_sk_storage_helpers.c
> @@ -21,3 +21,28 @@ int delete_bpf_sk_storage_map(struct bpf_iter__bpf_sk_storage_map *ctx)
>   
>   	return 0;
>   }
> +
> +SEC("iter/task_file")
> +int fill_socket_owner(struct bpf_iter__task_file *ctx)
> +{
> +	struct task_struct *task = ctx->task;
> +	struct file *file = ctx->file;
> +	struct socket *sock;
> +	int *sock_tgid;
> +
> +	if (!task || !file || task->tgid != task->pid)

task->tgid != task->pid is not needed here.
The task_file iterator already tries to skip task with task->pid
if its file table is the same as task->tgid.

> +		return 0;
> +
> +	sock = bpf_sock_from_file(file);
> +	if (!sock)
> +		return 0;
> +
> +	sock_tgid = bpf_sk_storage_get(&sk_stg_map, sock->sk, 0, 0);
> +	if (!sock_tgid)
> +		return 0;
> +
> +	*sock_tgid = task->tgid;
> +
> +	return 0;
> +}
> +

Extra empty line.
