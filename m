Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98A432C5F42
	for <lists+netdev@lfdr.de>; Fri, 27 Nov 2020 05:33:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392452AbgK0EcS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Nov 2020 23:32:18 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:28946 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2392434AbgK0EcR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Nov 2020 23:32:17 -0500
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AR4T5Yb008875;
        Thu, 26 Nov 2020 20:31:58 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=h1vOlL5DIl7KRK/QPPKqmH6TJvZIil9FaAnl+x3jtjY=;
 b=XP501WXRy6QhDVhsv0B0avoNWcVAzDNX4rZ1JxNxwUTUSVNFcXlRxrT7xqhd7lRRlc0X
 7rOfZRxXB4MAy8Gp5+te0zHoqo8M9GOZ6p3LdqY69+GJ3d8jAsbLJKUcHmyZg42/hj3s
 4f3vr/LXNZ+rSPeVqBSQ2I9wCZldxOz1usM= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 352q738gy8-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 26 Nov 2020 20:31:58 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 26 Nov 2020 20:31:53 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Iz4t+85jTRhvDr7INBBCS+yV5EXVe9EJiwRavpJpAADctdVwEKdgv8UtBlg1pghKeStwHtsQyM7zBO8oSCFeVHhFAPU+PZy3kKBftEOQT4jh0kaWIntA5NYKp/yyAHRNsX3IjLJEqHp9A51tXoEUen6WGZovYzTI7acXEZgGBiMODFXM0D7hnTxrpwzKXpGob3W4DyWdOkQxw50MOojV+WlaBUoqG3lBxHRiC3EmTd0npiqR+3RqeyzBzdB/t29nxXy1Q5ryiqjqOKeCaLvxRgwrlozV0wyiRO/aiwWQK59wpusbfu/+SYEX2kHZxOpIU/UgCAexmKy/ZaiiTnXf5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h1vOlL5DIl7KRK/QPPKqmH6TJvZIil9FaAnl+x3jtjY=;
 b=dmOgaCK0/1CxKePbYCedmxWGNHgFa/JaVzBVpoCo9OReNziUaSzeB6LzjIuF0aFZmVRkdBRcIeIgOTZVkVawTVLL1laBjC+iIKNeuOOURCyS6oE6CPVr0lI5IOIXI2Qaa2Zj7FdphDyCnuXOBadZw1DWX6NmKbfVNJMHxwd916xE+6JmVqj904hwUHK0kLQWFj0xnbxujzn14cPgZOIGmnlrPor2vITArqKVrTO7LpWGEK3EG/x95Duo/ya8lLyDrmSTD/6PFUdOYRd9HOcJnAg99MgO3CLrZqq3J5QLftJXQnMNHKLx+RYiSQrhxpVZWbreebxD3TukrzCGzgjmVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h1vOlL5DIl7KRK/QPPKqmH6TJvZIil9FaAnl+x3jtjY=;
 b=fFTLvsWVGhtTE2UgghIsEOqzUX6506scIxD11MjElvNRIeejbur2eMuTNCNtQ+PX2tx+NFP3ZpJ/OTbmjFcw87m4sRkC+MuuqWpbJyB6npmjj0H9sp3uaNuO66FrH2umvRVgLiXxxSsQz72zF8QGqXcGo6sISzsBsyeoO4UackU=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2199.namprd15.prod.outlook.com (2603:10b6:a02:83::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21; Fri, 27 Nov
 2020 04:31:52 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03%7]) with mapi id 15.20.3611.025; Fri, 27 Nov 2020
 04:31:52 +0000
Subject: Re: [PATCH bpf-next v3 2/5] selftests/bpf: xsk selftests - SKB POLL,
 NOPOLL
To:     Weqaar Janjua <weqaar.janjua@gmail.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <daniel@iogearbox.net>, <ast@kernel.org>,
        <magnus.karlsson@gmail.com>, <bjorn.topel@intel.com>
CC:     Weqaar Janjua <weqaar.a.janjua@intel.com>, <shuah@kernel.org>,
        <skhan@linuxfoundation.org>, <linux-kselftest@vger.kernel.org>,
        <anders.roxell@linaro.org>, <jonathan.lemon@gmail.com>
References: <20201125183749.13797-1-weqaar.a.janjua@intel.com>
 <20201125183749.13797-3-weqaar.a.janjua@intel.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <394e96ea-cf70-90e1-599e-eef8e613eef8@fb.com>
Date:   Thu, 26 Nov 2020 20:31:49 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.0
In-Reply-To: <20201125183749.13797-3-weqaar.a.janjua@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [2620:10d:c090:400::5:7e72]
X-ClientProxiedBy: MWHPR01CA0035.prod.exchangelabs.com (2603:10b6:300:101::21)
 To BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21cf::1008] (2620:10d:c090:400::5:7e72) by MWHPR01CA0035.prod.exchangelabs.com (2603:10b6:300:101::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.22 via Frontend Transport; Fri, 27 Nov 2020 04:31:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bd789a88-a423-44cd-e26e-08d8928d5d18
X-MS-TrafficTypeDiagnostic: BYAPR15MB2199:
X-Microsoft-Antispam-PRVS: <BYAPR15MB2199CE65D6F4CB4F26F835C4D3F80@BYAPR15MB2199.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:483;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pkvq6oHJJVDBPh8odNUlUZBB8I4Y0/tog7HM91SPtuB4F3ZEGbSWsx8PdiOJAs/56O7PT+6zzJKWlpQ+biggzYQs0o8/b+Cqp3ESopvOawYyXUPLXrbb+zSpowYIAIuc45QoteGY93RdJZq41RAVRgf+UwdFopsCVdtw+iM7UgjzKogUrKieR0wLFRosByfuHszCr1ZAwQk1qOhdQEKXUn28CgspxVNAjuQYLnHLYSpusKzQQgNX1Q1i0nv3jRAGry2hf7wMimw+87gaDTqbokia1ASM0agVf25HpUPHLr+l0dl+lRw2+FuF5s0DB/LzcwCY1YkZI+o6w0vXS2bTKky4DQHJLJExho202sqMUL+cZtMTkolsYGqqS8QhPm4L
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(136003)(396003)(376002)(366004)(39860400002)(7416002)(52116002)(478600001)(316002)(53546011)(6486002)(8676002)(86362001)(8936002)(2906002)(16526019)(66556008)(83380400001)(66946007)(186003)(66476007)(31696002)(4326008)(36756003)(2616005)(31686004)(5660300002)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?bllHQzRnUjZEdEFPWklwWUFWZjVJRGlzZjYrbERlNDRBOEhtMEN0U1hxS2tp?=
 =?utf-8?B?SHlZcGtFWnZvOW5OTWZkdWYvem4xUDI5T0FsQUxzK0xISWlLeTdJWGw3V0VX?=
 =?utf-8?B?dVhlVC9TRm03b240cGEvODNYYWpDc2s2MjRVUjZuL3BpanpSNm9zeXNOQWpi?=
 =?utf-8?B?aWp3VExrS2JWNWVzT24xU1VDM3pINDZmdjNaUlhqdlhiQkNYSTV0cm5DaHBt?=
 =?utf-8?B?THNaYThRRXAxc1dkMEVrRVptN1lodXdMUFJEbi9LT2N0Zm83bU04dVRZSTBF?=
 =?utf-8?B?RUxNWWVwVGx4b2dXRWUveDF4TWUzSVhtclhGbEYrbGhmUFB3TzlxT0VwZ1Iw?=
 =?utf-8?B?TnBhZ2tvb1RwVkFrL1h2ejMzMjRQeHYxb1FsOVdJNWlwYlpQVG1UbDJCRGZl?=
 =?utf-8?B?cFdQay9Zc3d1emlId2E0M0xVdTlsSVlxZjRqTXFoZnhQdmZkYTdndmtRNGUz?=
 =?utf-8?B?NzVFZGYyeThMZzFpbVZsTVM5cHNWT3ZRUDUvbjNWQmN2dWtUVm9SUmJlaXJG?=
 =?utf-8?B?SW96OEt1RmtEek1YNDQyNFd0RHM4aS8rVisvYjA5VTY2K0VFL2liUmdPejlz?=
 =?utf-8?B?QXBlaUdDb0dsdEpFVGxuZmNodkNNM2NTUmJXV3hWaUo4NlQxYXhEcCtQMGRD?=
 =?utf-8?B?RzdkeTRwZGxxKzhPOStDeWVWeHVKSWJBMlpudjBCOVo1OStIS3dxZUtQdmNU?=
 =?utf-8?B?Yzgwa0xvVnkyNXJLeXlGc2JEbVY3U2JoMEltaWpxMFpzUzgzQm1TNERIbG9j?=
 =?utf-8?B?VzVjL1FHUlFDQ2twTHk2ZFFXeUxrMGpvQ3N0bWVXYUVJZXVoYlU4Sk5zYmcw?=
 =?utf-8?B?OFpLbXMwcXFhMFRDU1dlZzRFYVJmMjBZL1grcWNPZzVtMlJDNld4bFJqUUxr?=
 =?utf-8?B?TTRlb3pDclhxWjN2Rkw0aDg3V3Fsck5xak9pa1ArUXY2Rk9FaDZ1ZWQwejUx?=
 =?utf-8?B?ZWZoTkp0bzU5cmhRU3lNaklGVEdmUTVua2E3SHlaODRtWCtGVjZ5K1VSRjBz?=
 =?utf-8?B?c3FYQ3BQa0VvWU9KUkhnc0lKWlpFZnU3N0lKZFZBU1d0VVBjQWZJOHd5UHE3?=
 =?utf-8?B?bDBQZ3QvSGxGSHBScXZRZDBLU0dDRzRhWS84Ty9JbnpudU1vaHhJUTRGTE83?=
 =?utf-8?B?a1FZbGl3dlZJankxeEZKN3pxVlkwbkN6RC9jVzZYZzBIbzFQaml1clNzaXds?=
 =?utf-8?B?UnBDTUxkb2hSeC94aHNhOERWTzJWZ1Q2VzdsRDVrZ0xMeDNyNTdITGtVTHA2?=
 =?utf-8?B?UFVhVGQ5OHFyWUVtWjB3YmhzcWIwbVIrK2s3NlY4QWUvZ292ZEJDbjhOMWVL?=
 =?utf-8?B?Ti9xSXRtYVVNNm5KSll3VmdxQ2JPRC9KWFhCQ2NCenM4UC8reS8xd20yb1dI?=
 =?utf-8?B?ZllzaHVWV2M5TEE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: bd789a88-a423-44cd-e26e-08d8928d5d18
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2020 04:31:52.4160
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xNcCRex6ko3ABjqdJKmMiTeGNFjtZjhV8zEV5+Sx/vxr1Oo0FYN6RnzxQoatMlZT
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2199
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-27_01:2020-11-26,2020-11-27 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0 mlxscore=0
 impostorscore=0 priorityscore=1501 phishscore=0 bulkscore=0 suspectscore=0
 lowpriorityscore=0 mlxlogscore=940 malwarescore=0 spamscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011270025
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/25/20 10:37 AM, Weqaar Janjua wrote:
> Adds following tests:
> 
> 1. AF_XDP SKB mode
>     Generic mode XDP is driver independent, used when the driver does
>     not have support for XDP. Works on any netdevice using sockets and
>     generic XDP path. XDP hook from netif_receive_skb().
>     a. nopoll - soft-irq processing
>     b. poll - using poll() syscall
> 
> Signed-off-by: Weqaar Janjua <weqaar.a.janjua@intel.com>
> ---
>   tools/testing/selftests/bpf/Makefile     |   2 +-
>   tools/testing/selftests/bpf/test_xsk.sh  |  36 +-
>   tools/testing/selftests/bpf/xdpxceiver.c | 961 +++++++++++++++++++++++
>   tools/testing/selftests/bpf/xdpxceiver.h | 151 ++++
>   tools/testing/selftests/bpf/xsk_env.sh   |  17 +
>   5 files changed, 1158 insertions(+), 9 deletions(-)
>   create mode 100644 tools/testing/selftests/bpf/xdpxceiver.c
>   create mode 100644 tools/testing/selftests/bpf/xdpxceiver.h
> 
> diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
> index 596ee5c27906..a2be2725be11 100644
> --- a/tools/testing/selftests/bpf/Makefile
> +++ b/tools/testing/selftests/bpf/Makefile
> @@ -83,7 +83,7 @@ TEST_PROGS_EXTENDED := with_addr.sh \
>   # Compile but not part of 'make run_tests'
>   TEST_GEN_PROGS_EXTENDED = test_sock_addr test_skb_cgroup_id_user \
>   	flow_dissector_load test_flow_dissector test_tcp_check_syncookie_user \
> -	test_lirc_mode2_user xdping test_cpp runqslower bench
> +	test_lirc_mode2_user xdping test_cpp runqslower bench xdpxceiver
>   
>   TEST_CUSTOM_PROGS = urandom_read
>   
[...]
> +
> +static void parse_command_line(int argc, char **argv)
> +{
> +	int option_index, interface_index = 0, c;
> +
> +	opterr = 0;
> +
> +	for (;;) {
> +		c = getopt_long(argc, argv, "i:q:pScDC:", long_options, &option_index);
> +
> +		if (c == -1)
> +			break;
> +
> +		switch (c) {
> +		case 'i':
> +			if (interface_index == MAX_INTERFACES)
> +				break;
> +			char *sptr, *token;
> +
> +			memcpy(ifdict[interface_index]->ifname,
> +			       strtok_r(optarg, ",", &sptr), MAX_INTERFACE_NAME_CHARS);

During compilation, I hit the following compiler warnings,

xdpxceiver.c: In function ‘main’:
xdpxceiver.c:461:4: warning: ‘__s’ may be used uninitialized in this 
function [-Wmaybe-uninitialized]
     memcpy(ifdict[interface_index]->ifname,
     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
            strtok_r(optarg, ",", &sptr), MAX_INTERFACE_NAME_CHARS);
            ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
xdpxceiver.c:443:13: note: ‘__s’ was declared here
  static void parse_command_line(int argc, char **argv)
              ^~~~~~~~~~~~~~~~~~

I am using gcc8. I am not sure whether we should silence such
warning or not (-Wno-maybe-uninitialized). Did you see such a warning
during your compilation?

> +			token = strtok_r(NULL, ",", &sptr);
> +			if (token)
> +				memcpy(ifdict[interface_index]->nsname, token,
> +				       MAX_INTERFACES_NAMESPACE_CHARS);
> +			interface_index++;
> +			break;
> +		case 'q':
> +			opt_queue = atoi(optarg);
> +			break;
> +		case 'p':
> +			opt_poll = 1;
> +			break;
> +		case 'S':
> +			opt_xdp_flags |= XDP_FLAGS_SKB_MODE;
> +			opt_xdp_bind_flags |= XDP_COPY;
> +			uut = ORDER_CONTENT_VALIDATE_XDP_SKB;
> +			break;
> +		case 'c':
> +			opt_xdp_bind_flags |= XDP_COPY;
> +			break;
> +		case 'D':
> +			debug_pkt_dump = 1;
> +			break;
> +		case 'C':
> +			opt_pkt_count = atoi(optarg);
> +			break;
> +		default:
> +			usage(basename(argv[0]));
> +			ksft_exit_xfail();
> +		}
> +	}
> +
> +	if (!validate_interfaces()) {
> +		usage(basename(argv[0]));
> +		ksft_exit_xfail();
> +	}
> +}
> +
[...]
