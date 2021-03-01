Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A22E732A2BA
	for <lists+netdev@lfdr.de>; Tue,  2 Mar 2021 15:57:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245080AbhCBIXt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 03:23:49 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:49636 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241172AbhCAXA0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 18:00:26 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 121Msx3I020810;
        Mon, 1 Mar 2021 14:59:29 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=O1juWnrcBys31ckmTyUCFvFPGMfTVcwWOmn0ZEBDtkw=;
 b=lr5r4Wq2fjyMXajGV9yjj/gV/lpoQ9kLZ454WitUxxMKDIPJDXI0P7O/CGKiCOgplxuE
 gMTI2/hORBdJfLc7rjeWFGAdLWkq6mh12BNWeu/NQg6IH0TUV6NsYXI7PC/FdgV1omaz
 0nipXoVOBaj24qH5ceFguy1J3mpRDPM6wtA= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3706sv04d9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 01 Mar 2021 14:59:29 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 1 Mar 2021 14:59:28 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j5kkduBZjKPhb5LHE8VxQPussocNCcJtsqQeWbbshntnRQCG91t39TFKgVSRBeaAgVqM3mhzSltLanGPI78aNjk5w3CFxJnCagOoMEEAluqRppJk8YrBvhCTzkYXJZiCGFBC5/KPUOfQ0DUhiPC8p9p56DgjWs1A0+HKWs4BXBGrYwxpbtaxbBTyD2vFPiGDqjK6035BhpcI7xyck+sc0mZ0E9DEIppVM8JeuqMj2AloX6+bYTPfZyFQProU8gmB+YzQhsv7SCs06qbxhh6wVfhx5KUUFE7x/WOv5WR10CNQ7z8j8oBINlchOMdKWsZoEj0nGLXA+DmYJTmjztv8JQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O1juWnrcBys31ckmTyUCFvFPGMfTVcwWOmn0ZEBDtkw=;
 b=kY8CGzKzX1WVfFgQX5ZzVO1KYIGMY04ZhZIwpb0qkoWnhhafJ0dTBDdfz9GKUQ0ultF6cgkxfzscT4d1OlGyoocakzqRk4CZGnNp2pPZCnPXYN7zH/e+vyVPMuHZM7Rnwg/wG2PP4jFa98J/b7z6omqrwK/rL6Ke1Z0je9FBDBN+NAJZUHTlcv9c8yUyYEjwzpE4gO4Cjz7k2/wveTWWXmLDSxXDdTxJBjsUaSkC/sjsc0H8OibdxE9zE30MQ9AtT0TNdlvHrfb1/aHgSKOURLjNdxhQx9NaYMx5+rwAF9A2oLpwKuVzAGnpZJpl4aMbgZkRwWaPURd5dkoGhb1YDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=fb.com;
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SN7PR15MB4205.namprd15.prod.outlook.com (2603:10b6:806:100::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19; Mon, 1 Mar
 2021 22:58:56 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912%3]) with mapi id 15.20.3890.028; Mon, 1 Mar 2021
 22:58:56 +0000
Subject: Re: [PATCH bpf-next] selftests/bpf: Fix test_attach_probe for powerpc
 uprobes
To:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Yauheni Kaliuta <ykaliuta@redhat.com>
References: <20210301190416.90694-1-jolsa@kernel.org>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <309d8d05-4bbd-56b8-6c05-12a1aa98b843@fb.com>
Date:   Mon, 1 Mar 2021 14:58:53 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.0
In-Reply-To: <20210301190416.90694-1-jolsa@kernel.org>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:c460]
X-ClientProxiedBy: MWHPR15CA0046.namprd15.prod.outlook.com
 (2603:10b6:300:ad::32) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21c8::177e] (2620:10d:c090:400::5:c460) by MWHPR15CA0046.namprd15.prod.outlook.com (2603:10b6:300:ad::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.23 via Frontend Transport; Mon, 1 Mar 2021 22:58:55 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 29432e93-04f7-416a-faf1-08d8dd0597df
X-MS-TrafficTypeDiagnostic: SN7PR15MB4205:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN7PR15MB42057AE85161BFF2BA4E9DEBD39A9@SN7PR15MB4205.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hcacqUZ7ElUbX74pl/q6tSM+g8FXj3pyNdBuBM0ok33iVJ+x0KEQPvlq0YA0gYoPSSnltwu+xlg6k9Haxe+tu2Z51DD/RRFNSFJ1CDlQ0JK5nm3WC7bFe59HFrpHfeRk768TLhWHuXyRIaqaJy4x9q39l91s8iiUIE7g2C1Q3+D+FzXnI8d+DnT/WsUHJw3OxioN0o21V5LkAcPeJS374YlZjJ5B0Dz0X9/PKbVCdf8SB+bNZrsH3sM+jdY2nxW43jwSLVHk1JmPf7GEgn1ojw+7G6wOG2t74Eh9V7SaKhgz2YdzVHKhkIDyaO6p4vxtKwiDlEOGo6OncLmAjQvxb+RDK2qtVjKrJodTGORowjDKkbNY9epgVgofcSp0WhckBqRD6Gud7axBT6J8V2r9KixyhiC4HuWSXdmaHRQis3SOkKSdWGq0P8pw2fh4779l2/5263XqkAARTTYW2gwyppR4LmCIojAiiv8AmukyAE8ufXiNqPb/cWNQ0oXTrz1Sml8zt6JBsM9S4m7oPahILAFtOr+bZqny8NZbul6WZ+VEQ3xUR3MXmsI9tPQPiEuPt/b/eRQOhqElvZaMuisYlnI2L8dkSlaGnZxRY1ce5dY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(396003)(366004)(376002)(136003)(346002)(6486002)(16526019)(186003)(66476007)(66556008)(36756003)(2616005)(31686004)(4326008)(66946007)(86362001)(2906002)(316002)(83380400001)(6636002)(54906003)(53546011)(5660300002)(478600001)(52116002)(8936002)(8676002)(110136005)(31696002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?Windows-1252?Q?DuPjQbVBsl7TmmyTc9+hUR+Ax1kt4rByFL1+/3YyvOsdBuFzO4E9U51V?=
 =?Windows-1252?Q?e9oQ89k1gC5BR/ZJwarqwocYZjLXjrt+D1R8V/493Ty50BRTiMmqkOaZ?=
 =?Windows-1252?Q?MulejDgoI9pZJrHRtkrU5gEIPjLlfaNguOXgcAwvKITiegrlnKyydBnA?=
 =?Windows-1252?Q?nv5WZWjY5DDNEraLWWY3cqEwL1LtjYgqUAsFZDzN8WGoNacsoWUzySPS?=
 =?Windows-1252?Q?sjoOfNyFgCPTREqqCd8h0UDkttSKlU2mo5Xecqpp5l57AlYrHo85jb1S?=
 =?Windows-1252?Q?07PSqgNJ9Hsr+idzIZyvA8H7LVjcy7lyLt5831rZ5ev9hzPM1VEc4bTr?=
 =?Windows-1252?Q?5/fw6BYroZemt9otkyhpBw5QAQO3zdbiQ/8wgKu3ZL7r/xKaoDhOy7q5?=
 =?Windows-1252?Q?uavBDK8OKgFy/NvYcRPrwcA/gsoxXD577QaZ1quQ8DFbjeLL9kaF7F6G?=
 =?Windows-1252?Q?wyNdG7E6tp6Xx4OvXAU94JexqgFUz1gFsWEIl5A7WaahkGCgBLYMHk0l?=
 =?Windows-1252?Q?L0zZuXiIauZxmleOUZfMtVHhcsJml8Q/UO+4NZzu496O8GkFYdPABndT?=
 =?Windows-1252?Q?8aUuPUilV6tzXfn0n13MpdTD8Q58A/ql2AxujJ6ct/ufXWGcS19Hu6MW?=
 =?Windows-1252?Q?4PWPep90p3WKNXmyZ72qtKwEFizNMscTjLW1BS6J+SMCWXpHai191U0F?=
 =?Windows-1252?Q?dQzLNx9jmf+ybqLfQGur1XImz79956OffJvCTXSMLS38CIxbiAjxOEhV?=
 =?Windows-1252?Q?MNdJRCzvnbfVSIiK7FoSvWCBowEzAf57RsZG1u/NtH2EKv4TwXaPlfTn?=
 =?Windows-1252?Q?LBUMkmZkVEWEzKYw9n2gqtxwbMyVTWcF1VwdcWzGyhhVkxEeaZ77uK8B?=
 =?Windows-1252?Q?qHRtK0ZJoVsv0Amnl0gD71D2pW9YBgd91jM0fhtNHZqSwrshoKaJEFfG?=
 =?Windows-1252?Q?NxQIViTItDgEuVKwP2M44qnYxwtE5nyJKtxwJV10wdlAGen5Jboy0UsO?=
 =?Windows-1252?Q?0Pc1SjrPP9wHhgZnEeZDD0PUJdnw0eusD6dFQW1dHBJ+bvuhYZs6uVY8?=
 =?Windows-1252?Q?3/1QaCGQfMm0sHdj/xTxI/Wu89Hph16ka6UuGBdnr5LauNNtWTOxh7Zp?=
 =?Windows-1252?Q?SH9DFmmlqSgpILFG9dWE3aEiYq2sQrMtSweXEN4ZGRO+NGV//mlUhx6l?=
 =?Windows-1252?Q?n1TIUtjyGMDG8uO18WKeeSX+1JCDX90oCwRR8E7WLFHf9djOcnNvof2z?=
 =?Windows-1252?Q?7tI+1TYl6akSZwqXWQQtzKdsjLw7s5yC2j1EDWGgHx1DpRE2Q/S7Se5I?=
 =?Windows-1252?Q?Lm8n2nPe7eVjKtQ2JqHJRyqfyaOKd90GZBc0WIs9nt0QqUjWHgrj3k9i?=
 =?Windows-1252?Q?NC3xlsGk3nKVwDiRUJADS2fabqBoQ6bQl2H6aB+zZXW1WyW5BNOsvqTA?=
 =?Windows-1252?Q?ZMoa56miWP5W0WJFT8gxVw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 29432e93-04f7-416a-faf1-08d8dd0597df
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Mar 2021 22:58:56.7467
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: epc6Ca5g0wjy4NYAj6VrMQQVfk6qvTvj6guve540KA6uQo8Z3kwtjrY/BvE7gpJz
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR15MB4205
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-01_15:2021-03-01,2021-03-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 impostorscore=0 clxscore=1011 spamscore=0 mlxscore=0 mlxlogscore=999
 lowpriorityscore=0 adultscore=0 bulkscore=0 priorityscore=1501
 phishscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2103010186
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/1/21 11:04 AM, Jiri Olsa wrote:
> When testing uprobes we the test gets GEP (Global Entry Point)
> address from kallsyms, but then the function is called locally
> so the uprobe is not triggered.
> 
> Fixing this by adjusting the address to LEP (Local Entry Point)
> for powerpc arch.
> 
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>   .../selftests/bpf/prog_tests/attach_probe.c    | 18 +++++++++++++++++-
>   1 file changed, 17 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/bpf/prog_tests/attach_probe.c b/tools/testing/selftests/bpf/prog_tests/attach_probe.c
> index a0ee87c8e1ea..c3cfb48d3ed0 100644
> --- a/tools/testing/selftests/bpf/prog_tests/attach_probe.c
> +++ b/tools/testing/selftests/bpf/prog_tests/attach_probe.c
> @@ -2,6 +2,22 @@
>   #include <test_progs.h>
>   #include "test_attach_probe.skel.h"
>   
> +#if defined(__powerpc64__)
> +/*
> + * We get the GEP (Global Entry Point) address from kallsyms,
> + * but then the function is called locally, so we need to adjust
> + * the address to get LEP (Local Entry Point).

Any documentation in the kernel about this behavior? This will
help to validate the change without trying with powerpc64 qemu...

> + */
> +#define LEP_OFFSET 8
> +
> +static ssize_t get_offset(ssize_t offset)
> +{
> +	return offset + LEP_OFFSET;
> +}
> +#else
> +#define get_offset(offset) (offset)
> +#endif
> +
>   ssize_t get_base_addr() {
>   	size_t start, offset;
>   	char buf[256];
> @@ -36,7 +52,7 @@ void test_attach_probe(void)
>   	if (CHECK(base_addr < 0, "get_base_addr",
>   		  "failed to find base addr: %zd", base_addr))
>   		return;
> -	uprobe_offset = (size_t)&get_base_addr - base_addr;
> +	uprobe_offset = get_offset((size_t)&get_base_addr - base_addr);
>   
>   	skel = test_attach_probe__open_and_load();
>   	if (CHECK(!skel, "skel_open", "failed to open skeleton\n"))
> 
