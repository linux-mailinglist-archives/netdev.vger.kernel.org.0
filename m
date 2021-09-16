Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3592440EE3B
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 01:47:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241014AbhIPXsX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 19:48:23 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:36494 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238769AbhIPXsW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Sep 2021 19:48:22 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18GFgtRO013738;
        Thu, 16 Sep 2021 16:46:40 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=Vvrf+9A9qBi1gD3sh8wJH5Dwf9PgAh9iuwyoTTASHzU=;
 b=TBjzot05yvrZk+GrGUtS1LGR1JoY7cZnv3X/s5SpO3QlCoLKi31pfw49fhEYrUvWkCvE
 pt4oQUv4yfjpYO/ph5QsWu1Q3ulAHB4wHR9+cb25pSxS3qxo9nflFDOU7wQA1EF+oHSb
 lZbqWv25+bZDLOEgNBXQgKKkPTBg2lwynyw= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3b3kv0tu5a-8
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 16 Sep 2021 16:46:40 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Thu, 16 Sep 2021 16:46:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ctDInafng3Gug9IjWuvBK1Xe8cQ6pGuTLveZbgqbN6BPNbfNIYi6jQfY/27es01OERK0qI4/wTuqXaTb4y05W3ZpVcmTATwFml3kmsTFpzMGXEkLrDGPjlKRaXsumGnN1HcGjmN+q7e5a55csHmcPCZQwfItv1lP38mYIRX7y135fIqR200N48GJ+7MkLrLIjNYdkHAxhcrPg14IsqZu85xvw0/eBxLFHyZVg2qZaWC4pRLRppA026Y0vgETXvFDB2e1rVLZnG8+fhsKHCtSCtfiDtn/2hRVq/Io/86W6ltKOGOe+aEMw8EwgAbwtcBNEtpm0P8OaQD4HniWNsCWTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=Vvrf+9A9qBi1gD3sh8wJH5Dwf9PgAh9iuwyoTTASHzU=;
 b=DFmUYdvaIRaPm0IcY1eWNOnBl9x7EY+fCQt2Cdp9PgQdOlVJ72hv0PY+oIfNlCoDYmhXERw6/i286Sk02P2Q9fWMgwg0ntMqPqV2r+bK/8Q0TAmiJ9VgiCTRbslMRk83L8TXCJvfatCdTa3T924MgiqRjQdj9qhKHURAU+QefrNgWsENJmgbMRfEzSMKsJU159suqcunWm8A0PErlr9cBKLu2XQoGYnAKsOmOFdHVAwK3zS0sbg3DbZnNSqJyelCBFT7G4Fc7yV+e6sCXsr0xIltNouoiCET2L4L8pw3R29iFBa32nOGw5iEmNhY+X0+hMDDX0Rjbs79TUGkcEFMng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SN6PR15MB2205.namprd15.prod.outlook.com (2603:10b6:805:20::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Thu, 16 Sep
 2021 23:46:36 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::51ef:4b41:5aea:3f75]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::51ef:4b41:5aea:3f75%6]) with mapi id 15.20.4500.019; Thu, 16 Sep 2021
 23:46:36 +0000
Subject: Re: [PATCH 3/3] bpf/selftests: add test for writable bare tracepoint
To:     Hou Tao <houtao1@huawei.com>, Alexei Starovoitov <ast@kernel.org>
CC:     Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>
References: <20210916135511.3787194-1-houtao1@huawei.com>
 <20210916135511.3787194-4-houtao1@huawei.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <c70c0a07-a337-1710-fae7-41ab77f75544@fb.com>
Date:   Thu, 16 Sep 2021 16:46:33 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
In-Reply-To: <20210916135511.3787194-4-houtao1@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR20CA0018.namprd20.prod.outlook.com
 (2603:10b6:a03:1f4::31) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
Received: from [IPv6:2620:10d:c085:21e8::1426] (2620:10d:c090:400::5:fd5b) by BY5PR20CA0018.namprd20.prod.outlook.com (2603:10b6:a03:1f4::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14 via Frontend Transport; Thu, 16 Sep 2021 23:46:35 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f4d683c8-2d85-4c0a-b768-08d9796c3873
X-MS-TrafficTypeDiagnostic: SN6PR15MB2205:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR15MB22053567D25CDA6620015A38D3DC9@SN6PR15MB2205.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:298;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: liZqxD9ACuEGTi+qf++ds9NdEntiEh8YkJPEjiRahWsxPVg/X7s9JJ1/rLMPFQk2tTBYaHp89YlEvwj1+bmRTYV7cGvzq17mcRBm/XmppUIMbavzVTrZ0DB2EY0aZGgM5iiZ5dSjDCBKXFqLZmg3733MxkKeyE1Rd/mirmIEdu3wRVhZNK5XWFzYRTrT8e4BwEPrm5tt6tMLz6RoIfv6UbF9V5DSgtRnfD9GCZ8cKldPd2uk/s9hRiAwHsQNlzhDTMeefx9ziT7/IzT7+WurTXM5rMHOWZnoXCNqeQK8brrXAH5J/OBs3fZzOv2XMbsxVV0JXs84gXHNWevlfVx5jpZ1lO5EP6iQ8Y9uJz9Vp1HKkgXA8trMn+hCh82l/EldbMf6A9K+G47nLNNKx3AvTsvlBipihzNn6b2FzC28CIT23MfnH6tF++yRZrxlu2MyDcl+DQyWydvqLvXFEupe0KIm5sTLZE4zTu4iYtaF/IFiS6nZAdoUEFd6n6VuHziBll8k21jB87XWs7FZsKXiw+xeV2Qm3rbJF9tFzyzUkruqSE/UlALYjpj41Eu8S5LW30Uom/FUKVJLpEzmtRqXsqqobeDq6qv+v54y9NSMG8+NnQtqHZ2CMKJDiI1fz1MQHgfV2DNHdftNLSXAaT+3EdiD6OGMh1H7/ePPE2knMfs1CIFJ2vy6BHfQ7rATW90AS3U6yzNtpHVt8OQAeuxIk5jy1V8l7FjztA1cxFf8N+iaJzkjMy+OgUyjfAIZ050K
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(366004)(136003)(376002)(39860400002)(2616005)(38100700002)(31696002)(66476007)(66556008)(110136005)(54906003)(316002)(4326008)(6486002)(8936002)(86362001)(83380400001)(5660300002)(52116002)(186003)(2906002)(8676002)(31686004)(66946007)(36756003)(478600001)(53546011)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?THVNdzVwL0FIeVBBSFJiUUNkSEYxNlQ4N1BMY0hUOTBMa29rNFBEcHcwdHJt?=
 =?utf-8?B?Z1RWN3kzLzcvTk1lNUdIUTF4NnlORFFTMUt6WkwwVjdrdkFvVjZ3OXlGT3lQ?=
 =?utf-8?B?WDBUWEJaaGNMTXNVdkUxSVhDYm1oajFoMWk4cTJMNFZZcE5WdnZNUzFYQnFL?=
 =?utf-8?B?MjhBNk45bGtvOTNISDAvSFZmSGVTeFIvSkVHK3paMEgyd2JGR2EreDU5KzdR?=
 =?utf-8?B?MUxaTHR3Nkx1cGRSU1NpanVMdUdEQ1p1Rzg2RjI0NG5pd0RWUms0eUpINThN?=
 =?utf-8?B?WDJnbUo5MW4zdDhOZEVVRmIxZGFVRklxSGVFdUxvOGM4d3NnNTZ2T3VmcGRQ?=
 =?utf-8?B?cEFwRTRLQlhJdkJiQnRZOEFCNS93T3JtcC80SUpYaHA2ZGZqdCtIQnZPTDFy?=
 =?utf-8?B?eVhwWWdiUlhJUkZNV1hKN0dhZ0N2VFBSSW51M1BaaFRUYjNML0k1eGRLdWp6?=
 =?utf-8?B?b0RMU2xmQmRPdGswQ2lMdTUzVTlHV3crYmRZWWt2b1FHM0ZCdmd0b3FRN2VH?=
 =?utf-8?B?N0hXZTBXOGdjZHdnT0FDMTVTVnJXeUowT3o0RkdHSFFqYXZsY3VPTjlCS3Bz?=
 =?utf-8?B?dmFaTlM5U3Y4N2FrNGlWSUxkUXhycm0wWWFoeWk3Y1BHVW14RWlnOFUxNS9r?=
 =?utf-8?B?WTVOV3NBTmF6Z3lxYUNkUmJ2cXBjcGh4QVR6Qkd6RDh0VmhJTXRic3pyV2pq?=
 =?utf-8?B?eEdNeEo2ZmQwMmlXaCtmTFFuTXhQbGMyT25FeXk4NTlvaGNjcWJJWUxPM1dV?=
 =?utf-8?B?Ump2aFZxMUxKUXhsS1ZtY0JQWEFOWUtFZlluaEJiYVZCVlcwVnRONmdXbHU5?=
 =?utf-8?B?T2R2YlJaNi92YTk2RmR4U21KMksyYXlkN0tGdzcyQjg1b0h3WHpXblNNTTNk?=
 =?utf-8?B?WGxSWDF1dzd5ZnRlS29MS0U1WkVYWVRHeTBRK1dUZnZGdzBhc2ZrL0xlNm1S?=
 =?utf-8?B?d3hubGlVTElJc1FnYkNaQ2xMbjRXU1VyUi9RaFpXUFppekN1MmpuVmU1WjVh?=
 =?utf-8?B?dE4yS1BGUE82RUp6MVBDSHNESStaMkVlSk1Mb3VyOHRCK3dkOEh2RUpmKzJ0?=
 =?utf-8?B?Mi8wdC9tRHIxZi9iRExzQnhJamZUTEo3YTNuRkY0bmFDYTFQc0NCK3E1MWRi?=
 =?utf-8?B?WHhFb3ZldnR6R0RaaWlmajlWMjVFb3lUUFE5UUFjNDlrUGlmSVRnNmgzOXRB?=
 =?utf-8?B?T2dOaktEL0c3V0YyK0dUc0VuREhqTi91WWE2UkF6Q0x6V2pmR0VySWtHa3Iy?=
 =?utf-8?B?YUxaRkg1MGZoRVN1US82bWFwdjJQemszM0M4emVrYW9uQ3o2ajZaWnNKRjZl?=
 =?utf-8?B?YW80SWZyZVA2eXpQQVlqcDYwSWJESitoaVFYcFcxeDVXd3U3VmVseXZLdmti?=
 =?utf-8?B?ZVl6bDhrOGdQeExBYTRydWdoUTg1Y01xeXRyajNsbXNrYmZraXVZUmh4VW9B?=
 =?utf-8?B?SXEzbUJIY2I5aEZ4U2k3ZjdJNEg4WGFwcDY5b0h6RG1kVVdKZmpzZzhIWURN?=
 =?utf-8?B?SGNyeEEwYjJFTzBqbUUxbmlGdlRRRGx3clZuUDR5WWZTK0Ruc2pwT1dmN0p2?=
 =?utf-8?B?QVhqNHRtbjVSeFhUN0hoSGEydnhmTW04M2VsbGVzaEJ0MW1rVkYyeG41TFor?=
 =?utf-8?B?cy92aFZQSVc1RFY0U2JEZVZsbkEwNm05ZmY1RE94U004L3hZTFVxb2JabU9p?=
 =?utf-8?B?RFVnQ0JJYlMyRFlnekJ5U2Z4aGVBQy83blU4ZFRBczNyZ3lrTm5nMTM4Z0Rj?=
 =?utf-8?B?RmZPalhEMFJWd21mMEtuUkpzM3pGZEJ6WER6eVhmaWFvbWtEN3E3THpzRWZU?=
 =?utf-8?Q?5JdaPgie+sSMPDEbbE6mIxqm/5TOSsg/joHWw=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f4d683c8-2d85-4c0a-b768-08d9796c3873
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2021 23:46:36.1091
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WSDW2HYZgnfk3qoUtspmxD784VujNWyuog6jEGqwC07LBvaSrADCs0aEOzyKsb3o
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR15MB2205
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: K4c3IsUdACZzhkxEEG0UcfauLIn8XdcI
X-Proofpoint-GUID: K4c3IsUdACZzhkxEEG0UcfauLIn8XdcI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-16_07,2021-09-16_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0 mlxscore=0
 clxscore=1015 phishscore=0 priorityscore=1501 malwarescore=0 adultscore=0
 lowpriorityscore=0 suspectscore=0 impostorscore=0 mlxlogscore=978
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109160133
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/16/21 6:55 AM, Hou Tao wrote:
> Add a writable bare tracepoint in bpf_testmod module, and
> trigger its calling when reading /sys/kernel/bpf_testmod
> with a specific buffer length.

The patch cannot be applied cleanly with bpf-next tree.
Please rebase and resubmit.

> 
> Signed-off-by: Hou Tao <houtao1@huawei.com>
> ---
>   .../bpf/bpf_testmod/bpf_testmod-events.h      | 15 +++++++
>   .../selftests/bpf/bpf_testmod/bpf_testmod.c   | 10 +++++
>   .../selftests/bpf/bpf_testmod/bpf_testmod.h   |  5 +++
>   .../selftests/bpf/prog_tests/module_attach.c  | 40 ++++++++++++++++++-
>   .../selftests/bpf/progs/test_module_attach.c  | 14 +++++++
>   5 files changed, 82 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod-events.h b/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod-events.h
> index 89c6d58e5dd6..11ee801e75e7 100644
> --- a/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod-events.h
> +++ b/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod-events.h
> @@ -34,6 +34,21 @@ DECLARE_TRACE(bpf_testmod_test_write_bare,
>   	TP_ARGS(task, ctx)
>   );
>   
> +#undef BPF_TESTMOD_DECLARE_TRACE
> +#ifdef DECLARE_TRACE_WRITABLE
> +#define BPF_TESTMOD_DECLARE_TRACE(call, proto, args, size) \
> +	DECLARE_TRACE_WRITABLE(call, PARAMS(proto), PARAMS(args), size)
> +#else
> +#define BPF_TESTMOD_DECLARE_TRACE(call, proto, args, size) \
> +	DECLARE_TRACE(call, PARAMS(proto), PARAMS(args))
> +#endif
> +
> +BPF_TESTMOD_DECLARE_TRACE(bpf_testmod_test_writable_bare,
> +	TP_PROTO(struct bpf_testmod_test_writable_ctx *ctx),
> +	TP_ARGS(ctx),
> +	sizeof(struct bpf_testmod_test_writable_ctx)
> +);
> +
>   #endif /* _BPF_TESTMOD_EVENTS_H */
>   
>   #undef TRACE_INCLUDE_PATH
> diff --git a/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c b/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c
> index 141d8da687d2..3d3fb16eaf8c 100644
> --- a/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c
> +++ b/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c
> @@ -26,6 +26,16 @@ bpf_testmod_test_read(struct file *file, struct kobject *kobj,
>   
>   	trace_bpf_testmod_test_read(current, &ctx);
>   
> +	/* Magic number to enable writable tp */
> +	if (len == 1024) {
> +		struct bpf_testmod_test_writable_ctx writable = {
> +			.val = 1024,
> +		};
> +		trace_bpf_testmod_test_writable_bare(&writable);
> +		if (writable.ret)
> +			return snprintf(buf, len, "%d\n", writable.val);
> +	}
> +
>   	return -EIO; /* always fail */
>   }
>   EXPORT_SYMBOL(bpf_testmod_test_read);
> diff --git a/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.h b/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.h
> index b3892dc40111..553d94214aa6 100644
> --- a/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.h
> +++ b/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.h
> @@ -17,4 +17,9 @@ struct bpf_testmod_test_write_ctx {
>   	size_t len;
>   };
>   
> +struct bpf_testmod_test_writable_ctx {
> +	bool ret;
> +	int val;
> +};
> +
>   #endif /* _BPF_TESTMOD_H */
> diff --git a/tools/testing/selftests/bpf/prog_tests/module_attach.c b/tools/testing/selftests/bpf/prog_tests/module_attach.c
> index d85a69b7ce44..5565bcab1531 100644
> --- a/tools/testing/selftests/bpf/prog_tests/module_attach.c
> +++ b/tools/testing/selftests/bpf/prog_tests/module_attach.c
> @@ -6,11 +6,39 @@
>   
>   static int duration;
>   
> +#define BPF_TESTMOD_PATH "/sys/kernel/bpf_testmod"
> +
> +static int trigger_module_test_writable(int *val)
> +{
> +	int fd, err;
> +	char buf[1025];

Not critical, but do you need such a big stack size?
Maybe smaller one?

> +	ssize_t rd;
> +
> +	fd = open(BPF_TESTMOD_PATH, O_RDONLY);
> +	err = -errno;
> +	if (CHECK(fd < 0, "testmod_file_open", "failed: %d\n", err))
> +		return err;
> +
> +	rd = read(fd, buf, sizeof(buf) - 1);
> +	err = rd < 0 ? -errno : -EIO;
> +	if (CHECK(rd <= 0, "testmod_file_read", "failed: %d\n", err)) {

Please use ASSERT_* macros. You can take a look at other self tests.

> +		close(fd);
> +		return err;
> +	}

Put one blank line here and remove the following three blank lines.

> +	buf[rd] = '\0';
> +
> +	*val = strtol(buf, NULL, 0);
> +
> +	close(fd);
> +
> +	return 0;
> +}
> +
>   static int trigger_module_test_read(int read_sz)
>   {
>   	int fd, err;
>   
> -	fd = open("/sys/kernel/bpf_testmod", O_RDONLY);
> +	fd = open(BPF_TESTMOD_PATH, O_RDONLY);
>   	err = -errno;
>   	if (CHECK(fd < 0, "testmod_file_open", "failed: %d\n", err))
>   		return err;
> @@ -32,7 +60,7 @@ static int trigger_module_test_write(int write_sz)
>   	memset(buf, 'a', write_sz);
>   	buf[write_sz-1] = '\0';
>   
> -	fd = open("/sys/kernel/bpf_testmod", O_WRONLY);
> +	fd = open(BPF_TESTMOD_PATH, O_WRONLY);
>   	err = -errno;
>   	if (CHECK(fd < 0, "testmod_file_open", "failed: %d\n", err)) {
>   		free(buf);
> @@ -58,6 +86,7 @@ void test_module_attach(void)
>   	struct test_module_attach__bss *bss;
>   	struct bpf_link *link;
>   	int err;
> +	int writable_val;
>   
>   	skel = test_module_attach__open();
>   	if (CHECK(!skel, "skel_open", "failed to open skeleton\n"))
> @@ -90,6 +119,13 @@ void test_module_attach(void)
>   	ASSERT_EQ(bss->fexit_ret, -EIO, "fexit_tet");
>   	ASSERT_EQ(bss->fmod_ret_read_sz, READ_SZ, "fmod_ret");
>   
> +	bss->raw_tp_writable_bare_ret = 1;
> +	bss->raw_tp_writable_bare_val = 511;
> +	writable_val = 0;
> +	ASSERT_OK(trigger_module_test_writable(&writable_val), "trigger_writable");
> +	ASSERT_EQ(bss->raw_tp_writable_bare_in_val, 1024, "writable_test");
> +	ASSERT_EQ(bss->raw_tp_writable_bare_val, writable_val, "writable_test");
> +
>   	test_module_attach__detach(skel);
>   
>   	/* attach fentry/fexit and make sure it get's module reference */
> diff --git a/tools/testing/selftests/bpf/progs/test_module_attach.c b/tools/testing/selftests/bpf/progs/test_module_attach.c
> index bd37ceec5587..4f5c780fcd21 100644
> --- a/tools/testing/selftests/bpf/progs/test_module_attach.c
> +++ b/tools/testing/selftests/bpf/progs/test_module_attach.c
> @@ -27,6 +27,20 @@ int BPF_PROG(handle_raw_tp_bare,
>   	return 0;
>   }
>   
> +int raw_tp_writable_bare_in_val = 0;
> +int raw_tp_writable_bare_ret = 0;
> +int raw_tp_writable_bare_val = 0;
> +
> +SEC("raw_tp_writable/bpf_testmod_test_writable_bare")
> +int BPF_PROG(handle_raw_tp_writable_bare,
> +	     struct bpf_testmod_test_writable_ctx *writable)
> +{
> +	raw_tp_writable_bare_in_val = writable->val;
> +	writable->ret = raw_tp_writable_bare_ret;
> +	writable->val = raw_tp_writable_bare_val;
> +	return 0;
> +}
> +
>   __u32 tp_btf_read_sz = 0;
>   
>   SEC("tp_btf/bpf_testmod_test_read")
> 
