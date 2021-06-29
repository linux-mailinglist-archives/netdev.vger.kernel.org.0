Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 238953B782C
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 21:01:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235348AbhF2TDo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Jun 2021 15:03:44 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:64761 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S233442AbhF2TDn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Jun 2021 15:03:43 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 15TIhWUo004931;
        Tue, 29 Jun 2021 12:01:01 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=/M9mfBolwaywMsj/TLzMgMIcGhFOJzBpbGbgKXtZEmA=;
 b=V9cu+rYFRYxJsb6Ah3FQ5n2BEfyJA77fG8KdY3EWV+iL/ztc8DgDUwxTXhTWiG5uOi4c
 lq5WVC8SN4GU2KvrYImqL+SpY2M7RviQUHBhwxTvoCdmaaep1eBnvChaKMguEVhEapCL
 /IXOCB2rebwDxsuQqmZegdYn3VTKIZM6l4E= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 39fjhu03y9-8
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 29 Jun 2021 12:01:00 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 29 Jun 2021 12:00:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TsuG0QJPqms/bR4UK7WCPH65Pggo763zS0eSqid8sRPPQv2ro9xfWunFzVeePttXb7Udqn+Tz/eJ15om0vIOgpbbghHmDWOYVm4Ac2Q0V9v1ss/T0kIHZLFaXa/bkXPvbt8+JJ7/4N70oVZ5XPUsRNmy3dl/dH9cUl0q4AKOe8F0Zr3ueabdCza8DHpR1EqbeqCQ3JSWpC0dswOeNfJ4xrmpCn/s6RWqc7cSHww8dO1O63AG0h+MllkITCwUq9gyc0XCFxsWHA2TFDPmZ1jeHJoislKp5L3QgZM4ghDyKgUpbBlU695ZltA2TYTXYUnALxepzHvHg9x0/Ukp2+3ERA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/M9mfBolwaywMsj/TLzMgMIcGhFOJzBpbGbgKXtZEmA=;
 b=T5c1If6QtDucaBqQKmcWkYHAAvztW9jcy9T57rGb05hmsW6f3ffEY/Z/sZU7udYYf7RAYHEjTp7fpLhkt/JwWXuekNq6JgYJN3OEfZhchrvA6jiQZv1LBT6QR+6vk7n/eKOYNNIHMFKSGUmKDwLqL4jSlhFzvTHv/mDi51aP22ZJcb8Kf5hyUVlF4pDjSEODdWfYSqEb49JWhDYsvYnCksyKgqv+6O5yzfBvew9mOn4U/tWop46Sfd1Uqk8oojVuR8/NfyQ0YoStAKGEKqnDzS9F9hwEnrOOrNHnz619/nGtQg0S1czqdFJYU8CFyLtnRvzJzzGqjfAfgixsQ6IcyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=fb.com;
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA1PR15MB4918.namprd15.prod.outlook.com (2603:10b6:806:1d1::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.18; Tue, 29 Jun
 2021 19:00:56 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::d886:b658:e2eb:a906]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::d886:b658:e2eb:a906%5]) with mapi id 15.20.4264.026; Tue, 29 Jun 2021
 19:00:56 +0000
Subject: Re: [PATCH bpf-next 8/8] bpf: selftest: Test batching and
 bpf_setsockopt in bpf tcp iter
To:     Martin KaFai Lau <kafai@fb.com>, <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>, <kernel-team@fb.com>,
        Neal Cardwell <ncardwell@google.com>, <netdev@vger.kernel.org>,
        Yuchung Cheng <ycheng@google.com>
References: <20210625200446.723230-1-kafai@fb.com>
 <20210625200536.728323-1-kafai@fb.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <9a9e81ef-7896-4df7-d3a7-601466d70588@fb.com>
Date:   Tue, 29 Jun 2021 12:00:53 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
In-Reply-To: <20210625200536.728323-1-kafai@fb.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:6625]
X-ClientProxiedBy: BYAPR07CA0036.namprd07.prod.outlook.com
 (2603:10b6:a02:bc::49) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21d6::1a57] (2620:10d:c090:400::5:6625) by BYAPR07CA0036.namprd07.prod.outlook.com (2603:10b6:a02:bc::49) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.19 via Frontend Transport; Tue, 29 Jun 2021 19:00:55 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 58a0d7f6-40a9-4316-4695-08d93b3039b5
X-MS-TrafficTypeDiagnostic: SA1PR15MB4918:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA1PR15MB49181F032FFCD4A42EC79909D3029@SA1PR15MB4918.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: diP9Iqm72vHS7lmNcyKhiQ0Q8cq8HHkGmX7EmIlWR6/DyFtt9dgGZdfxwtbGKHPRNBBE+VqeTV02BFh6wnHqAMaCHH05CFNcH9JiSCYbQku8aR4gdVe6yWQHPPjTlv3kNqJmluPOYpIDf1i/Bf6VcEOv743iLsMSxigARIcMkn41fPFcnF8HwHGZyfD3tg6CaKRXx9IUyLtiudse1C+LQLiSlNIZJRvKk6G0+S9mgaQ7gD9HPWHKQpsMB1/1l/6Js13GSJHNskglAzl9dR3Vz15otn/iFFriXaAZC9K2+x43dYutu5z48P8kJzTL/JHJleqqext/CtYjjwrtjT8mBQUXmxfFumc9s8fnWwL5tGTmgBbxj6kF93ZU7sQCUX8nKU04F9XrrQ06w/xHGWDhvbxk4Lf4kQTZqMXR0jNq3oEiii6ZJPTJmPxnD9loCM9i6AWx/sgYdo4lu5tkknBbQAbtmeDeip8k19cYj7Y+kThS3d10kYR/tMHRIA5jOFJTAu6bieS2kDaF2z2BMPprVZsZE8HqObUt1wWAb3J/2RATmyd8wHqHi9F85qI/MFI9fMrMaJ6tWBYusg71iBulSgqaNvLPAULExEwOJS3nMbu9lgLcr4ypFdeaf59z8sn1kCa9zCntOT/SPNnZbwrwzxZ7GzkqBNYO3Ym3L0VB12klPaMVqDP2vB9xv15KSuJcFZmYyRyHT60YoZ3c/xQ9GTNlZ9nJQh1EYLPTf2d8PVJVmd28SatFGzhOvFrrsEPp
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(376002)(346002)(136003)(366004)(186003)(83380400001)(8676002)(16526019)(2616005)(36756003)(38100700002)(6486002)(8936002)(316002)(54906003)(31696002)(66476007)(86362001)(52116002)(53546011)(66556008)(478600001)(66946007)(5660300002)(4326008)(2906002)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?d3pGYlB6S3c4NjhFZWIrMTNjZk11cmdYUXB4RDBBYkhZZnJ1OUNMSHRPdGJI?=
 =?utf-8?B?SUg4WGM3Z3JsSHFBeWlLL2hoa2R5TCsySGJCR1VodG0xQmNKaGFLNDVIUUo2?=
 =?utf-8?B?OHlKRVVaY21HL3IyWmpzRm9XNXhwVlN2c3BMV3laVHVXRS80V1RvcGswQ2R1?=
 =?utf-8?B?V1Awdk51R0tGbDNqaXlSMlNiTFRqU0ZBekwwZ3JNckdMeWE5bXlHUHF6c0FW?=
 =?utf-8?B?d0xJS2NVbkNGUTFBdmpITWVtYSs3QnY5b3BHb0NVNTJZZVhtdXYwMEpxQlU4?=
 =?utf-8?B?a0c1Y1VaanQ5bEo5cU13MTd6Qy9XQzI0UFpwNXJKM3dhQ1R0YWhEcnBWS0o5?=
 =?utf-8?B?ejZHWm45RTVNd2ttSzZKNlgvaHVtSElmU1lXVGpucXNJRTFkNGVYTXFuWklS?=
 =?utf-8?B?Y1dXdzhXNE4zUmVzZmpGUzdTYWcyVDd6TG1rb0I5bGNsMTQxRzF3NUM4cW1H?=
 =?utf-8?B?d0ExbWNyaldLbjBQWFhUWUNqVXo1dmdKZVZ5Q1pCVDJaZEliRlNwK1ZsVVkr?=
 =?utf-8?B?OE1CaUJMdGxtYzF2UTh2MDU1ck9NallBMytuU1dHQ1c4VlAwUUFVVE54RWUr?=
 =?utf-8?B?WDBnTmZwazVWbVZEQkU0blZjSGRDS1FrQ0pjSHFKQzhoemNQcGx4V2cvRVRY?=
 =?utf-8?B?Y29JVXVNcXR1bWthNWx6YjFFdC85WThabDNWemY4MzBOejlZMHBHd1gxaXQy?=
 =?utf-8?B?VTVhWGxOSFU2eHdXOS8rOEJoKzVxT01keWVYSnVJRSt6TWZZTjdEcnhSd2c4?=
 =?utf-8?B?M29WNHFMM0s5ZG11UDZWN2R0Yjk5WjBPUXJGWVVPY2hFYmx0Wk01V0RMZ2Ev?=
 =?utf-8?B?L053QWNFT2grQUxmWm15UmJ6dldWUTBMbU9UdmVWK0tlWjVVbXpDM0xyVmpw?=
 =?utf-8?B?dmJWaVArM0NOazZiQndTdUxwOXVxTHVVMW9jT3dqeERsRFNPTGhySGtUV3lB?=
 =?utf-8?B?THpqbGliV2RnUlZZRXBiWENCb0ZRWkZXWHVyOHE4ZEduQzNjUHZucUo4RlMv?=
 =?utf-8?B?YjFuTWVicVMxamk0NkEzcjgvRCtEd2dPSFMxc3BDeUtmYU1vYXhHdEl1NlVu?=
 =?utf-8?B?QUsxYXpkaXNHSXNUTDdLWXR0clNxSnRBbjVLY3lvRzF6QWFSRTVJV05RRTc2?=
 =?utf-8?B?cnE0Q21sT3hXbTlmSzVrcE9lNHhrRVIrM2lYLzl2V1RqOE55bG9Bd1o2dUhF?=
 =?utf-8?B?Qlk0RHl6ZWV3R0JYbnVzaWllVDc0VE9YUloweG50aTB5am9ld2tud3NpMHY5?=
 =?utf-8?B?NzgzZDRxa0ViQkZvRm9yNnpzc01Fb1hFR01KOWdjZTNjdllZSTlBQ1BKeGFE?=
 =?utf-8?B?Vm5EOVFpVkdvVDg0TG5kSlBMVERuZEdzRVlDWjEraittWklpaVFtN2txTVR6?=
 =?utf-8?B?am11My9LNFNaWElwQ0ZZWjlIZnFGMEhsZXBNSHlTR20vWlpxMlk1RlU0UmJJ?=
 =?utf-8?B?YmFVU0o5aXg4bzltVWxEblJ4QXlYS3RFVURsaG5RYmxVSDJQdXU4Y0VNeGp5?=
 =?utf-8?B?ejFQWTUxeTM2Q3VlSExnK2NDZkt1ckRzK0FpUDZEb0NIU0JoazI4cWpvZmxW?=
 =?utf-8?B?OVYzNnV5bUNCdjBBVkozbjhsVDZ4Wk1qYXRxVE5rdzVkcUpMdHBSSVhnL2hV?=
 =?utf-8?B?RGdydk0vY0Q4TlBTV1hucXFkbUxXeUpBVWxIZ0VyNDJDdE5YQllrazdYQ3hu?=
 =?utf-8?B?NEZMVnhDSU1sSmg2UURqalNnZEZiRXBXNDJKVmVLQzVUNGlHSzF0ckFEUUw3?=
 =?utf-8?B?b1dtaDNjUjc4NVVZSTZmeVhsOGwyWEFrRzhORmwyUnM4SVVoeGc3cWF3T3gr?=
 =?utf-8?Q?CJJH9WxI7KdovDmFSNwb8A9Rde5g5639JhxIQ=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 58a0d7f6-40a9-4316-4695-08d93b3039b5
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jun 2021 19:00:56.3915
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lbKQIZzGxqcht+4mYF7BlTpainC3sCoMsRYGI1Ok0mLoTEvXr91MCOyAdCod+pMU
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4918
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: qDfyfafW_krSP9ksmMNr3ZgmWgrJZiVB
X-Proofpoint-ORIG-GUID: qDfyfafW_krSP9ksmMNr3ZgmWgrJZiVB
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-29_11:2021-06-29,2021-06-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 bulkscore=0 mlxlogscore=999 malwarescore=0 spamscore=0 impostorscore=0
 suspectscore=0 mlxscore=0 phishscore=0 clxscore=1015 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106290119
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/25/21 1:05 PM, Martin KaFai Lau wrote:
> This patch adds tests for the batching and bpf_setsockopt in bpf tcp iter.
> 
> It first creates:
> a) 1 non SO_REUSEPORT listener in lhash2.
> b) 256 passive and active fds connected to the listener in (a).
> c) 256 SO_REUSEPORT listeners in one of the lhash2 bucket.
> 
> The test sets all listeners and connections to bpf_cubic before
> running the bpf iter.
> 
> The bpf iter then calls setsockopt(TCP_CONGESTION) to switch
> each listener and connection from bpf_cubic to bpf_dctcp.
> 
> The bpf iter has a random_retry mode such that it can return EAGAIN
> to the usespace in the middle of a batch.
> 
> Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> ---
>   tools/testing/selftests/bpf/network_helpers.c |  85 ++++++-
>   tools/testing/selftests/bpf/network_helpers.h |   4 +
>   .../bpf/prog_tests/bpf_iter_setsockopt.c      | 226 ++++++++++++++++++
>   .../selftests/bpf/progs/bpf_iter_setsockopt.c |  76 ++++++
>   .../selftests/bpf/progs/bpf_tracing_net.h     |   4 +
>   5 files changed, 386 insertions(+), 9 deletions(-)
>   create mode 100644 tools/testing/selftests/bpf/prog_tests/bpf_iter_setsockopt.c
>   create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_setsockopt.c
> 
> diff --git a/tools/testing/selftests/bpf/network_helpers.c b/tools/testing/selftests/bpf/network_helpers.c
> index 2060bc122c53..26468a8f44f3 100644
> --- a/tools/testing/selftests/bpf/network_helpers.c
> +++ b/tools/testing/selftests/bpf/network_helpers.c
> @@ -66,17 +66,13 @@ int settimeo(int fd, int timeout_ms)
>   
>   #define save_errno_close(fd) ({ int __save = errno; close(fd); errno = __save; })
>   
> -int start_server(int family, int type, const char *addr_str, __u16 port,
> -		 int timeout_ms)
> +static int __start_server(int type, const struct sockaddr *addr,
> +			  socklen_t addrlen, int timeout_ms, bool reuseport)
>   {
> -	struct sockaddr_storage addr = {};
> -	socklen_t len;
> +	int on = 1;
>   	int fd;
>   
> -	if (make_sockaddr(family, addr_str, port, &addr, &len))
> -		return -1;
> -
> -	fd = socket(family, type, 0);
> +	fd = socket(addr->sa_family, type, 0);
>   	if (fd < 0) {
>   		log_err("Failed to create server socket");
>   		return -1;
> @@ -85,7 +81,13 @@ int start_server(int family, int type, const char *addr_str, __u16 port,
>   	if (settimeo(fd, timeout_ms))
>   		goto error_close;
>   
> -	if (bind(fd, (const struct sockaddr *)&addr, len) < 0) {
> +	if (reuseport &&
> +	    setsockopt(fd, SOL_SOCKET, SO_REUSEPORT, &on, sizeof(on))) {
> +		log_err("Failed to set SO_REUSEPORT");
> +		return -1;
> +	}
> +
> +	if (bind(fd, addr, addrlen) < 0) {
>   		log_err("Failed to bind socket");
>   		goto error_close;
>   	}
> @@ -104,6 +106,69 @@ int start_server(int family, int type, const char *addr_str, __u16 port,
>   	return -1;
>   }
>   
[...]
> +void test_bpf_iter_setsockopt(void)
> +{
> +	struct bpf_iter_setsockopt *iter_skel = NULL;
> +	struct bpf_cubic *cubic_skel = NULL;
> +	struct bpf_dctcp *dctcp_skel = NULL;
> +	struct bpf_link *cubic_link = NULL;
> +	struct bpf_link *dctcp_link = NULL;
> +
> +	if (create_netns())
> +		return;
> +
> +	/* Load iter_skel */
> +	iter_skel = bpf_iter_setsockopt__open_and_load();
> +	if (!ASSERT_OK_PTR(iter_skel, "iter_skel"))
> +		return;
> +	iter_skel->links.change_tcp_cc = bpf_program__attach_iter(iter_skel->progs.change_tcp_cc, NULL);
> +	if (!ASSERT_OK_PTR(iter_skel->links.change_tcp_cc, "attach iter"))
> +		goto done;
> +
> +	/* Load bpf_cubic */
> +	cubic_skel = bpf_cubic__open_and_load();
> +	if (!ASSERT_OK_PTR(cubic_skel, "cubic_skel"))
> +		goto done;
> +	cubic_link = bpf_map__attach_struct_ops(cubic_skel->maps.cubic);
> +	if (!ASSERT_OK_PTR(cubic_link, "cubic_link"))
> +		goto done;
> +
> +	/* Load bpf_dctcp */
> +	dctcp_skel = bpf_dctcp__open_and_load();
> +	if (!ASSERT_OK_PTR(dctcp_skel, "dctcp_skel"))
> +		goto done;
> +	dctcp_link = bpf_map__attach_struct_ops(dctcp_skel->maps.dctcp);
> +	if (!ASSERT_OK_PTR(dctcp_link, "dctcp_link"))
> +		goto done;
> +
> +	do_bpf_iter_setsockopt(iter_skel, true);
> +	do_bpf_iter_setsockopt(iter_skel, false);
> +
> +done:
> +	bpf_link__destroy(cubic_link);
> +	bpf_link__destroy(dctcp_link);
> +	bpf_cubic__destroy(cubic_skel);
> +	bpf_dctcp__destroy(dctcp_skel);
> +	bpf_iter_setsockopt__destroy(iter_skel);
> +}
> diff --git a/tools/testing/selftests/bpf/progs/bpf_iter_setsockopt.c b/tools/testing/selftests/bpf/progs/bpf_iter_setsockopt.c
> new file mode 100644
> index 000000000000..72cc4c1c681e
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/bpf_iter_setsockopt.c
> @@ -0,0 +1,76 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (c) 2021 Facebook */
> +#include "bpf_iter.h"
> +#include "bpf_tracing_net.h"
> +#include <bpf/bpf_helpers.h>
> +#include <bpf/bpf_endian.h>
> +
> +#define sk_num			__sk_common.skc_num
> +#define sk_dport		__sk_common.skc_dport
> +#define sk_state		__sk_common.skc_state
> +#define sk_family		__sk_common.skc_family

The above macros can be defined in bpf_tracing_net.h. For example,
sk_state and sk_family are alraedy defined in bpf_tracing_net.h.

#define sk_family               __sk_common.skc_family
#define sk_rmem_alloc           sk_backlog.rmem_alloc
#define sk_refcnt               __sk_common.skc_refcnt
#define sk_state                __sk_common.skc_state
#define sk_v6_daddr             __sk_common.skc_v6_daddr
#define sk_v6_rcv_saddr         __sk_common.skc_v6_rcv_saddr

> +
> +#define bpf_tcp_sk(skc)	({				\
> +	struct sock_common *_skc = skc;			\
> +	sk = NULL;					\
> +	tp = NULL;					\
> +	if (_skc) {					\
> +		tp = bpf_skc_to_tcp_sock(_skc);		\
> +		sk = (struct sock *)tp;			\
> +	}						\
> +	tp;						\
> +})
[...]
> +
> +char _license[] SEC("license") = "GPL";
> diff --git a/tools/testing/selftests/bpf/progs/bpf_tracing_net.h b/tools/testing/selftests/bpf/progs/bpf_tracing_net.h
> index 01378911252b..d66c4caaeec1 100644
> --- a/tools/testing/selftests/bpf/progs/bpf_tracing_net.h
> +++ b/tools/testing/selftests/bpf/progs/bpf_tracing_net.h
> @@ -5,6 +5,10 @@
>   #define AF_INET			2
>   #define AF_INET6		10
>   
> +#define SOL_TCP			6
> +#define TCP_CONGESTION		13
> +#define TCP_CA_NAME_MAX		16
> +
>   #define ICSK_TIME_RETRANS	1
>   #define ICSK_TIME_PROBE0	3
>   #define ICSK_TIME_LOSS_PROBE	5
> 
