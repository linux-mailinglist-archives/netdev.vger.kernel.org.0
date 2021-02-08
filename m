Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F5EA3129CE
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 05:40:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229731AbhBHEjm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Feb 2021 23:39:42 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:7428 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229615AbhBHEjc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Feb 2021 23:39:32 -0500
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1184Y6bF017551;
        Sun, 7 Feb 2021 20:38:35 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=gVPKvd9DJJx2Q7Z6kkvmGCEqu0NshJGMn/GX4JAs1Mk=;
 b=QTqaXjBAkInh8rrTrVnTL2/9P8FnxHiFB3KyzBb36+kFsUnhZ64x0gDZ4DI9FmVTfsDw
 LsfIypVy6Zs2azYzS5vD0zBw/r10qodKk6mh+Phor/WVCBaDnFammVRcirMs7C2beIGT
 K4+3s0Qp/ZAb78wXzGUpk0O4Zp+Rutz3Ykw= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 36hsgtddrs-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sun, 07 Feb 2021 20:38:34 -0800
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Sun, 7 Feb 2021 20:38:34 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RSgf7rTtxdARbAdgsInbEcNQnOJ23Abq7iYJk6puZ87sRa8zJp0yNpFStecu8yXhaMfWZoPkoh7QIv9X87p1OhdDCtYcjttexRBmhqe3w1aVYbpsMS2BjC59MIOOcEM6OkZhvh3zibvjPK4ml7+FuvgMlMCxLr7SploDE8XDukJmrYWatG8wewSKECQ5URJ6+6eiAdgO5kxRQ34Sq52eqByV9coN5TLWRvdBbNaVHMevttFKYXfoK2sHiKt/BMSDS9hRBZhXNZMKBKlU7l63ydqpnmhRZ9LlFjCWHfyfRuuj12QFe5EudKawj3gKpFcCT4a7wyQfcHmffmoY8r6jLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gVPKvd9DJJx2Q7Z6kkvmGCEqu0NshJGMn/GX4JAs1Mk=;
 b=LI0Q0jlWS0ASFyuEmzOd5Khx+M2BBpxJrRBmELppRji69WQaLS7rWo7LL5pl+GQHV/YSIvampzziLl+6MaguoTMEAtinGMrq/JXEp0bejn9ywYuQlPpRs3+HknDhZ5yOhqCcEg+H0tQ0WcJE44IjtRLGNy2T4fsyErmbvqNLO6joL32vGlyXYAexPT1chGyyEyDm3ruEN1xBCw+djsutkzugWaUE9AGlbF8PCWEs+0yZlWDf036y7vq4kli7cfxu8q8CHP19AC9rhUUEF7hjhW0nsn43SHH4mDEmTAsYvt8o+56DmoBtDiJOfgn1hc4YkzPOrTDCMrIknV3juVCsWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gVPKvd9DJJx2Q7Z6kkvmGCEqu0NshJGMn/GX4JAs1Mk=;
 b=Yx5m4Rlx4p0ptkKjrtgeDvG/SOEWY44+n+1eQjxFHYXjr24x0euNkkXpzCKiR7bRfx/8PCe6iKFho3LQzWFnWLbJLti/L7rysk5SV3GhkUpd7rCH4IRQMrm1qJUskuDjhQ3HqVe8A2D00ajO+EENYLQ+Jp//M/tfxSjFjM9A0cI=
Authentication-Results: linux-foundation.org; dkim=none (message not signed)
 header.d=none;linux-foundation.org; dmarc=none action=none
 header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2582.namprd15.prod.outlook.com (2603:10b6:a03:154::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.30; Mon, 8 Feb
 2021 04:38:31 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::61d6:781d:e0:ada5]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::61d6:781d:e0:ada5%5]) with mapi id 15.20.3825.030; Mon, 8 Feb 2021
 04:38:31 +0000
Subject: Re: [PATCH v4 bpf-next 4/4] selftests/bpf: add test for
 bpf_iter_task_vma
To:     Song Liu <songliubraving@fb.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-mm@kvack.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <akpm@linux-foundation.org>
References: <20210204205002.4075937-1-songliubraving@fb.com>
 <20210204205002.4075937-5-songliubraving@fb.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <cf806cda-679b-ff8c-2f65-0d7554b0381d@fb.com>
Date:   Sun, 7 Feb 2021 20:38:26 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.0
In-Reply-To: <20210204205002.4075937-5-songliubraving@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:ba14]
X-ClientProxiedBy: MWHPR22CA0039.namprd22.prod.outlook.com
 (2603:10b6:300:69::25) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21c1::1261] (2620:10d:c090:400::5:ba14) by MWHPR22CA0039.namprd22.prod.outlook.com (2603:10b6:300:69::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.17 via Frontend Transport; Mon, 8 Feb 2021 04:38:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e5be927e-5de1-4ac9-08f2-08d8cbeb62fc
X-MS-TrafficTypeDiagnostic: BYAPR15MB2582:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB2582A87A06326DFB647E23A3D38F9@BYAPR15MB2582.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:163;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: weQLCIH+Sw4trgfk16hgtEl4XVkyXmkrc4heNfLuRvF+hELcvgNKxPNFWfFkG6PbqcGNhL62/yqGHeq34/Gd3FT/s8sNI6hOiEC4c87+S1EHpH0vJ7Yd/WGXlAY67GrZBudJEaZBeDoNL+xr7dnJquMdKR9JLM5bBSpHEI6tmBkymhhQkyMqyzGtKOUUTgaqfO0Nu8JlJrm3YSnUmbIGfXMUVPS5lQIuSzVXIdeXn9NzbNeDBpERlgKcH86dUsqBNhQrvfjny4vXYudFrR+9TIuV4qjv8JW+YSIkxDsjmQ5sWwzl1lqJf5cxh38cJtyI1vyGN9usLgsyaU3nF9953IidXg22M2gZ5EIko3yx/OOKz3Z/stYGAzGT5YHcooP3o0e8TkkCk9mtYvLj2wHH0fGMpBc07JvYLGh/KckA8f0u3YJscmUQIR5LG4yHlieqTtQXEXCm7JhFcKvGZ3tfkHGFpuIRKXJr6A8sBjd7lXTJa0QXwuq/+coFF9o8vcLtvlgSiI3dtRNUw8cP8xfbvX4+tB7ke61ScKczg2+5iKWFb5b+xgAz5pJPWvUNENRiw+osbMvz4dpwRpzLL/096bQj94zHKgNkbz8E4l3mJaw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(39860400002)(136003)(366004)(396003)(376002)(316002)(2906002)(6666004)(52116002)(8676002)(83380400001)(186003)(2616005)(31696002)(31686004)(16526019)(86362001)(4326008)(6486002)(53546011)(36756003)(8936002)(5660300002)(66946007)(66476007)(66556008)(478600001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?K043azBHbmJNcWp6MFFhMnZvQURKZHAvYjR0cVYyMDNXK1ZGbXhFdEZWMFg4?=
 =?utf-8?B?cHU3bFNyaFNsRWlUcFRZdmNvRTR4c0E1S0hCaFdOaHRaM3UrMVl3elJiUU4x?=
 =?utf-8?B?ZFM3eDgzcEtXYkNzbGlSYlAxakRzTW5ONm1Qa08xRHlWaklabVZmUklCN0JI?=
 =?utf-8?B?SkFzT1dzRjlBRU1tU3h0cEYzOTZQWmR4WTFMN042YTNGWUIrUGpvTVBVRkZ3?=
 =?utf-8?B?VXR2Yi8vZVJpcG45cWlPZzdlR3g3V29yS3hIRExxL2ZhYjJNK2ljdW5kSlRQ?=
 =?utf-8?B?N2tpdHE3UC9FRk5rbE5XT0l5MnJuLzhURWNrc292UlVHMWI0bm1qNGlXdmdP?=
 =?utf-8?B?aWs4VDZmQUcyNk44T0lIYlNpK3ozdHBPblVZNE01RGwydXJiVCtTMWN2M0Fx?=
 =?utf-8?B?SjRWdEtQRkdSVkcrRzBkR1FZTGh1aklOZjFCR0paWk85Sy9TSTloRUdITVRz?=
 =?utf-8?B?ci9BVVFRZ1MvQ1daL0JmVmJYbm5iYUErRnBBcDc4SmtsUktzRFJOMENpWm1F?=
 =?utf-8?B?OWt4b0VmVWdjTURlNExKTG5mcWFFRFRBVnhwcDVZbTY2cFNvUTMwWUZ3UjZ6?=
 =?utf-8?B?eTlUM0VDdlJJN1dQbVY5TU11NHVrcHdUckVmZFVIclFwSkUyRDZZVFdBTCs1?=
 =?utf-8?B?Y210cDNJL2xKY0FKaGoyb0lrUHpabEk1clZjSmI2amJXVzQvZHJEd2hjSXRG?=
 =?utf-8?B?K2dRZGg0cGhCTno2aUlUQi80WkNlVTFGeS9KbExKYXpIeHJRZnJwNjNrdTdH?=
 =?utf-8?B?bjUvemgwS2E1cFhmSk04VDNsY29NMUxoV3F3dlQvZWw5ZGt5TFBPdjFhTml4?=
 =?utf-8?B?bVJqU0RoR2FlMnpWVjJvZktVb1RjS3A0dXJFRmprakptNE9mQ2ltMG5RK0xD?=
 =?utf-8?B?UkxtNmE0WXZrRlV5NWd3OHB6NGV6MS8wOS9YRmJ6OE05OTVzaWVTeGJZQ0hT?=
 =?utf-8?B?ckI0YWl4blo0TGc2NkF0R2dwSUVLZGdVMEhEaDY5d1Q0NnF2Wjd6ZGd3N2pz?=
 =?utf-8?B?ZE5odnpJaHJKTHBTbDl1UHRXRGt6dVBURVFBOFJFcC9McUZNTWlSTnhYNFJB?=
 =?utf-8?B?aGUwUzk3bmw4MzRmMS9BWjF2WVZoQVlWaDhZNFRyRXEzK3ZFTWszWDlhRlg0?=
 =?utf-8?B?algvcXcranJ2UUgwTTg3cXZnYnVzc0tlYVl5eTNlc0VoZk5iRVhoUDUxcHZv?=
 =?utf-8?B?WHBzYnRmZVpDdkhxVi9wN2R3SDVFREs0UUlrbFVTVy9BUjVqUk4vdDFLTzZ6?=
 =?utf-8?B?cXRyQXJ2SWJZV284clVjK1dBeitKWlJubitQUXVHanp0REphWEhNV1dRdlZZ?=
 =?utf-8?B?QnUvcml2U1NGRmxWOTQxYzVaUDFPNGhUUkMxYTZtWnQ2U1VQMFBkOXIvKzJU?=
 =?utf-8?B?NWplcENUM3hxV3ZIZTVpNmZNK0ZTNnNISjJIcVFwVm42TkYwRUFvTm9LdEIw?=
 =?utf-8?B?eDJFdWxnaGRUVUVYMVRZbFNnTG01MzFjUGwyWEJaVmZ4MEVRTXRBL2laMkZ2?=
 =?utf-8?B?dEdTaXRhOGt2VWJudXVrVm50OVhwMGNTclJxMlZkUUp3dlh2VlFETml4WEg1?=
 =?utf-8?B?QTNvQmRnWDZwK3RJOGtZNk1GSTVqN1pBUnlMbW9TTGRqaWppcXR5aWRSN3Jy?=
 =?utf-8?B?VENYK2k1N05kdHRCZUlqUzlTN3NZbU4vbWhnMGxOQWlERldPaGk2Y0xUUDBw?=
 =?utf-8?B?bDM2Z28wODZpOGxTY05VaklPdk5pcTdDYW91R2UzdTd5WHkrb09aTGs3MDVP?=
 =?utf-8?B?d3hhanVVSmRrejJkbnllRWFmdzVsanpNVm0zYllBOTFOdElhd293QTVXaWpN?=
 =?utf-8?Q?du+qIK0iYIZ9WoqjI1vtxFo4Fak0THWIvDmOY=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e5be927e-5de1-4ac9-08f2-08d8cbeb62fc
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2021 04:38:31.2612
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aF/g1LbdGugjAirmfi2Ri0DBLxDdbcQ698TvOrfRW5EyXSEaiFkRK6malJ5JoHcX
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2582
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-08_01:2021-02-05,2021-02-08 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 mlxlogscore=999 spamscore=0 mlxscore=0 clxscore=1015
 adultscore=0 bulkscore=0 phishscore=0 suspectscore=0 lowpriorityscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102080030
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/4/21 12:50 PM, Song Liu wrote:
> The test dumps information similar to /proc/pid/maps. The first line of
> the output is compared against the /proc file to make sure they match.
> 
> Signed-off-by: Song Liu <songliubraving@fb.com>
> ---
>   .../selftests/bpf/prog_tests/bpf_iter.c       | 114 ++++++++++++++++--
>   tools/testing/selftests/bpf/progs/bpf_iter.h  |   8 ++
>   .../selftests/bpf/progs/bpf_iter_task_vma.c   |  58 +++++++++
>   3 files changed, 170 insertions(+), 10 deletions(-)
>   create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_task_vma.c
> 
> diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_iter.c b/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
> index 0e586368948dd..9e8027685e859 100644
> --- a/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
> +++ b/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
> @@ -7,6 +7,7 @@
>   #include "bpf_iter_task.skel.h"
>   #include "bpf_iter_task_stack.skel.h"
>   #include "bpf_iter_task_file.skel.h"
> +#include "bpf_iter_task_vma.skel.h"
>   #include "bpf_iter_task_btf.skel.h"
>   #include "bpf_iter_tcp4.skel.h"
>   #include "bpf_iter_tcp6.skel.h"
> @@ -64,6 +65,22 @@ static void do_dummy_read(struct bpf_program *prog)
>   	bpf_link__destroy(link);
>   }
>   
> +static int read_fd_into_buffer(int fd, char *buf, int size)
> +{
> +	int bufleft = size;
> +	int len;
> +
> +	do {
> +		len = read(fd, buf, bufleft);
> +		if (len > 0) {
> +			buf += len;
> +			bufleft -= len;
> +		}
> +	} while (len > 0);
> +
> +	return len < 0 ? len : size - bufleft;
> +}
> +
>   static void test_ipv6_route(void)
>   {
>   	struct bpf_iter_ipv6_route *skel;
> @@ -177,7 +194,7 @@ static int do_btf_read(struct bpf_iter_task_btf *skel)
>   {
>   	struct bpf_program *prog = skel->progs.dump_task_struct;
>   	struct bpf_iter_task_btf__bss *bss = skel->bss;
> -	int iter_fd = -1, len = 0, bufleft = TASKBUFSZ;
> +	int iter_fd = -1, err;
>   	struct bpf_link *link;
>   	char *buf = taskbuf;
>   	int ret = 0;
> @@ -190,14 +207,7 @@ static int do_btf_read(struct bpf_iter_task_btf *skel)
>   	if (CHECK(iter_fd < 0, "create_iter", "create_iter failed\n"))
>   		goto free_link;
>   
> -	do {
> -		len = read(iter_fd, buf, bufleft);
> -		if (len > 0) {
> -			buf += len;
> -			bufleft -= len;
> -		}
> -	} while (len > 0);
> -
> +	err = read_fd_into_buffer(iter_fd, buf, TASKBUFSZ);
>   	if (bss->skip) {
>   		printf("%s:SKIP:no __builtin_btf_type_id\n", __func__);
>   		ret = 1;
> @@ -205,7 +215,7 @@ static int do_btf_read(struct bpf_iter_task_btf *skel)
>   		goto free_link;
>   	}
>   
> -	if (CHECK(len < 0, "read", "read failed: %s\n", strerror(errno)))
> +	if (CHECK(err < 0, "read", "read failed: %s\n", strerror(errno)))
>   		goto free_link;
>   
>   	CHECK(strstr(taskbuf, "(struct task_struct)") == NULL,
> @@ -1133,6 +1143,88 @@ static void test_buf_neg_offset(void)
>   		bpf_iter_test_kern6__destroy(skel);
>   }
>   
> +#define CMP_BUFFER_SIZE 1024
> +static char task_vma_output[CMP_BUFFER_SIZE];
> +static char proc_maps_output[CMP_BUFFER_SIZE];
> +
> +/* remove \0 and \t from str, and only keep the first line */
> +static void str_strip_first_line(char *str)
> +{
> +	char *dst = str, *src = str;
> +
> +	do {
> +		if (*src == ' ' || *src == '\t')
> +			src++;
> +		else
> +			*(dst++) = *(src++);
> +
> +	} while (*src != '\0' && *src != '\n');
> +
> +	*dst = '\0';
> +}
> +
> +#define min(a, b) ((a) < (b) ? (a) : (b))
> +
> +static void test_task_vma(void)
> +{
> +	int err, iter_fd = -1, proc_maps_fd = -1;
> +	struct bpf_iter_task_vma *skel;
> +	int len, read_size = 4;
> +	char maps_path[64];
> +
> +	skel = bpf_iter_task_vma__open();
> +	if (CHECK(!skel, "bpf_iter_task_vma__open", "skeleton open failed\n"))
> +		return;
> +
> +	skel->bss->pid = getpid();
> +
> +	err = bpf_iter_task_vma__load(skel);
> +	if (CHECK(err, "bpf_iter_task_vma__load", "skeleton load failed\n"))
> +		goto out;
> +
> +	skel->links.proc_maps = bpf_program__attach_iter(
> +		skel->progs.proc_maps, NULL);
> +
> +	if (CHECK(IS_ERR(skel->links.proc_maps), "bpf_program__attach_iter",
> +		  "attach iterator failed\n"))
> +		goto out;

You need to set skel->links.proc_maps = NULL before goto out. Otherwise,
libbpf may segfault.

> +
> +	/* read CMP_BUFFER_SIZE (1kB) from bpf_iter */

This comment better right before
     /* read in small chunks to trigger seq_file corner cases */

> +	iter_fd = bpf_iter_create(bpf_link__fd(skel->links.proc_maps));
> +	if (CHECK(iter_fd < 0, "create_iter", "create_iter failed\n"))
> +		goto out;
> +
> +	/* read in small chunks to trigger seq_file corner cases */
> +	len = 0;
> +	while (len < CMP_BUFFER_SIZE) {

Some comment will be better to assure that we won't trigger infinite 
loop here, e.g., err == 0 case.

> +		err = read_fd_into_buffer(iter_fd, task_vma_output + len,
> +					  min(read_size, CMP_BUFFER_SIZE - len));
> +		if (CHECK(err < 0, "read_iter_fd", "read_iter_fd failed\n"))
> +			goto out;
> +		len += err;
> +	}
> +
> +	/* read CMP_BUFFER_SIZE (1kB) from /proc/pid/maps */
> +	snprintf(maps_path, 64, "/proc/%u/maps", skel->bss->pid);
> +	proc_maps_fd = open(maps_path, O_RDONLY);
> +	if (CHECK(proc_maps_fd < 0, "open_proc_maps", "open_proc_maps failed\n"))
> +		goto out;
> +	err = read_fd_into_buffer(proc_maps_fd, proc_maps_output, CMP_BUFFER_SIZE);
> +	if (CHECK(err < 0, "read_prog_maps_fd", "read_prog_maps_fd failed\n"))
> +		goto out;
> +
> +	/* strip and compare the first line of the two files */
> +	str_strip_first_line(task_vma_output);
> +	str_strip_first_line(proc_maps_output);
> +
> +	CHECK(strcmp(task_vma_output, proc_maps_output), "compare_output",
> +	      "found mismatch\n");
> +out:
> +	close(proc_maps_fd);
> +	close(iter_fd);
> +	bpf_iter_task_vma__destroy(skel);
> +}
> +
>   void test_bpf_iter(void)
>   {
>   	if (test__start_subtest("btf_id_or_null"))
> @@ -1149,6 +1241,8 @@ void test_bpf_iter(void)
>   		test_task_stack();
>   	if (test__start_subtest("task_file"))
>   		test_task_file();
> +	if (test__start_subtest("task_vma"))
> +		test_task_vma();
>   	if (test__start_subtest("task_btf"))
>   		test_task_btf();
>   	if (test__start_subtest("tcp4"))
> diff --git a/tools/testing/selftests/bpf/progs/bpf_iter.h b/tools/testing/selftests/bpf/progs/bpf_iter.h
> index 6a1255465fd6d..3d83b185c4bcb 100644
> --- a/tools/testing/selftests/bpf/progs/bpf_iter.h
> +++ b/tools/testing/selftests/bpf/progs/bpf_iter.h
[...]
