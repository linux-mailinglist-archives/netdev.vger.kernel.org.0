Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE38439D342
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 05:08:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230197AbhFGDKr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Jun 2021 23:10:47 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:23698 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230145AbhFGDKq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Jun 2021 23:10:46 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15736J78032110;
        Sun, 6 Jun 2021 20:07:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=isQ6TQmivEPkaunSv4BZevBAQomxgXzUDak2mnmQsnY=;
 b=Yxdnig4RlLQdxEr0kCIutUKAEmS/9DhgQoBjld1bZUPWS6Gz/9NokMNDo8RW21VhldDK
 9iynv9yYYikioQOyb6Gtm9yv4dU7g9z622e3d3vrLUTgXLw7a2vm5Ha4i3mxQvcIJrCg
 8vLE0aMnqytCXu17OiCMKMUOzU7RqustK/8= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 390sbwb526-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sun, 06 Jun 2021 20:07:49 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Sun, 6 Jun 2021 20:07:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jtRoBe48HNDiwLssyREkq4Aji4JUI0SzkDARo43WsObzRxv4HzIzRZeuKy0fxiKqZn93uMJQia/6wQrsd80u/OulvwwlkGKYsSBN2sjW9N08BLgVu0ru6BeRXmmIqmcJLq1XCIp5GEvLqJgRoun5BJL+0g1vxvizhGWWeiEBnwrCHQnJcc/vHn8/02uSPSowwPiSnui3dNP/FojxpTbgIPp8tA1oW4mhoXbdEAiWGtwHr0IYVckk3m+Yr6m71gsHR7BOJ++T/xKsszhVPwWs+VAcgSOXizWbZg2gGxJOfllNe3JHbhJP4gV9ZVsFdhBSzfG9h1r1F8zQV0DSUAVn/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=isQ6TQmivEPkaunSv4BZevBAQomxgXzUDak2mnmQsnY=;
 b=e12di0f9jUm/3cyLDuByRQnw65oG6hsK0AgOsICSXMFmOJ/e737PMUlPwGFQyn49qsMEB9yLdxbtsTkJxB8iI90u+Hw5WL62EPf60OWTOsml2edoM5gQ8MujZ9o9bqbut/3YWDcDANP1B+N+7KcqMIg4V8XUELYYm3SCzBJQTUA5tIt+xX8geESRc7FrtvOtP7jg4dzfkHUal4Kze0isgnPsPCRxDKdfLFtTYxd4t2eOiwYTWavHUT0PIZdyV+3xmWixDkdoWTPAaJHDQnbghrDQFNX029F2DAwgOL7SrsVD01X0J+Wo/SO2hctyMGiCT4XyfyjXGPZJtbFaDTjiiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=fb.com;
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA1PR15MB4387.namprd15.prod.outlook.com (2603:10b6:806:192::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20; Mon, 7 Jun
 2021 03:07:47 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::d886:b658:e2eb:a906]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::d886:b658:e2eb:a906%5]) with mapi id 15.20.4195.030; Mon, 7 Jun 2021
 03:07:47 +0000
Subject: Re: [PATCH 09/19] bpf, x64: Allow to use caller address from stack
To:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, Daniel Xu <dxu@dxuuu.xyz>,
        Viktor Malik <vmalik@redhat.com>
References: <20210605111034.1810858-1-jolsa@kernel.org>
 <20210605111034.1810858-10-jolsa@kernel.org>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <e590aa58-bdfa-86c1-eaca-79b4e5bff1f3@fb.com>
Date:   Sun, 6 Jun 2021 20:07:44 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
In-Reply-To: <20210605111034.1810858-10-jolsa@kernel.org>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:1571]
X-ClientProxiedBy: MWHPR15CA0032.namprd15.prod.outlook.com
 (2603:10b6:300:ad::18) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21cf::1097] (2620:10d:c090:400::5:1571) by MWHPR15CA0032.namprd15.prod.outlook.com (2603:10b6:300:ad::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.15 via Frontend Transport; Mon, 7 Jun 2021 03:07:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 45a57d9b-6164-43e1-29d1-08d929616d59
X-MS-TrafficTypeDiagnostic: SA1PR15MB4387:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA1PR15MB4387336C32082B5B7901AD5BD3389@SA1PR15MB4387.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:962;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Sh6kt33f6DxhmAvzuVyQao1H2MAfnMU5AKudfJ2YwsaGa2+0ckwnLbhORfPyFJl0oC80p2ZnJ3f6mMjjVUpSl2c1yR7uydpuwmU5iL9QtPMStP72I9BIWksR/fsj4OIvmLdc2RyASkG2dfHQtpdS52J3oMZqsd9HDfxjJz1n4wyY0vpPmLxgeFEmfbwk593jZqIyxTI6atpphX4NHLjJfabrr0sf09C3HAlYrXZD492NlOLDS0E8tFvWeO/zA7M/96RhAPqHEJkWxaFcp0dcpn5x0AVOtvrn3ARaIIu+0nZHPKAOMGtp2v7ITKYEzhJEIlV2PIvThRezedOrkgZYW39aoUf7YAXDN2EFfHAYrTUMlcUgh2y0E/isjQDnAE4WWxgmOHS6JuMrxnYyNHEExi3KrmPW/79kiUXmIVZ6o1fLEDzJJK7gfSXALN9hFw1k1tsresXvEVLndgrTTm88IwiryJidwAKMzYoPvyNb5152VIl546rgmJAaqSlyHbe/+kRb3ymhIyW7NcUrarWaJIZji1XxqPbdy/m1Vs8KAP8zC8JZPaNaL+aRusrKbkQXkpnTuaXJX2kMXp3L62wzokw84J1yEFuJ7iJ3C0IW1a6kjvskbvJ1xtyXjXEWuxwO8s7ICepjSaCzThsiZwINcA1EJ55sgj4WnzRz5FNhGm1Ommgcy2cpy7yiR505HyYq
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(39860400002)(396003)(346002)(376002)(186003)(16526019)(7416002)(6486002)(31696002)(316002)(110136005)(2616005)(54906003)(2906002)(4326008)(478600001)(53546011)(83380400001)(38100700002)(66476007)(66556008)(66946007)(8676002)(5660300002)(52116002)(86362001)(31686004)(8936002)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?Windows-1252?Q?xwfN0pdPxif1AbFbrPMC6OyKTLhCCO7s/1ERGZeninA62nJ3AJHK3fSU?=
 =?Windows-1252?Q?9J6erE6v7DppjTYtCIkHTuxxytq829gYefDOQkMYj/jvx6UTWGu4yrI8?=
 =?Windows-1252?Q?jF1gR1ahjkpQZklXrcswwdieTLUwqyU6VphBVRmDO8F+1kiTfA5RuwyT?=
 =?Windows-1252?Q?h5mXzJZ6G5vpCgZYm8rDEYRGzXg1KhKIBAMf74wxk8/FMOYpNU9raB2W?=
 =?Windows-1252?Q?kFNgzZC/JtcnRID5KYGMn6buGAB1oktOkGd0JW0dBPqnFt44g2jnB1Xq?=
 =?Windows-1252?Q?48i39lVehd5dSbBwDpVIdxQc2hHSTAxrOR3KGJLAFfwwH2/B8VxqYQut?=
 =?Windows-1252?Q?Az57JMd+PzhFpxrKPGXijxhGXaJdrEKqZ4fR9W8Ow4zoVEM5chFPyKHs?=
 =?Windows-1252?Q?GjcS5qZzbNNb+kBZRxZEKsEFpNUUdZdzJ60Yx+4p1bp5mpR4AIuJ9u8E?=
 =?Windows-1252?Q?1/oOBOevd0gmwgftQ0s4hP4kFWMelNlbwSkQ+gfkLpxuBfvRYUM+sscq?=
 =?Windows-1252?Q?aRW3WECn56kPVdPemq79Gl4jbdlmxc7zAQ9J1MYHId3YW0qx9qp2scio?=
 =?Windows-1252?Q?sC2V36fajwNw6otJ45idgoA7d9po0LMaqFE3mWH60LTy3Nt4+JjwMEz1?=
 =?Windows-1252?Q?3ojHpc1jZyGOqdB7qeN1g9eNi4MH/UURu1iMSQJWTIJ00Xi7uOtCL43/?=
 =?Windows-1252?Q?28wB2p+3eRq+346hBnbygcUnczDd+9zGfWJ9Jy2IMCYjHuOVQhvcPwUk?=
 =?Windows-1252?Q?bYZffNh1GVGnPoLrbNP8nlxh7z/hquto0EnTU8YLPgPuRqcRop663WLQ?=
 =?Windows-1252?Q?wDdCqwx9wudPPnlNst6z5wQ8J9g+R0kF5FE3ao+jeTXps5YZS/VEpEUW?=
 =?Windows-1252?Q?dNb+q4xg8zQn8CI2jd3fNRNNDWeodSD563As/otIlilbEWzs1bKloOFi?=
 =?Windows-1252?Q?PyE307CnzdgSRoKZCjgTc09NdogtYdgde+3tiRqT403jY2Po14G9JEMr?=
 =?Windows-1252?Q?+66NsTMTGnsERn2r28695JK8qitLk/4IxZlgJvpZx/gb6mQn9rYW1NRz?=
 =?Windows-1252?Q?uQ9ikZ1lhmisN+zXKu2rn+8P5PB7SlUk3EfK+nYpjjz3XAJzCodOMNMQ?=
 =?Windows-1252?Q?qmMYpXub5wHeA6Yf8j8/19+wu3aE38q3PaLF6IE30UFYL31kaKsTCCGb?=
 =?Windows-1252?Q?sznDWKiET/vHrlFXyBKbi4rXRsyLLzjSUPs4tDcKo7xYB3UvhlIZwkyx?=
 =?Windows-1252?Q?BNCPBUEfwoFle5LIaslLqtqZVZyJ4h9sqT+kdcNUMbg+NrvO+cwpJhbx?=
 =?Windows-1252?Q?pewg7j/gtBkA7Wz7PmMpxZfmcXOv2NkUaKwhNkzAa9LXlyYkgP5iX3UO?=
 =?Windows-1252?Q?3jo52HcZ+ibvJrQlx91z1PRsxjOOxtGWEOIoNfL4gGb0xv/6E3rT34Ho?=
 =?Windows-1252?Q?tMmSy/U1iJ85eVm656L0fg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 45a57d9b-6164-43e1-29d1-08d929616d59
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2021 03:07:47.4341
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tT2f5j19pCjldTfuiu1o4RHsBTpDEBWL4tX83J9WP/7L0Z3L9LFLsr9caPuZju6z
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4387
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: YJgNmwSG2ASg7CyHjZa-9YfJj3mNKin6
X-Proofpoint-ORIG-GUID: YJgNmwSG2ASg7CyHjZa-9YfJj3mNKin6
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-07_03:2021-06-04,2021-06-07 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 lowpriorityscore=0 clxscore=1011 adultscore=0 suspectscore=0
 mlxlogscore=956 impostorscore=0 bulkscore=0 malwarescore=0
 priorityscore=1501 mlxscore=0 spamscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106070020
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/5/21 4:10 AM, Jiri Olsa wrote:
> Currently we call the original function by using the absolute address
> given at the JIT generation. That's not usable when having trampoline
> attached to multiple functions. In this case we need to take the
> return address from the stack.

Here, it is mentioned to take the return address from the stack.

> 
> Adding support to retrieve the original function address from the stack

Here, it is said to take original funciton address from the stack.

> by adding new BPF_TRAMP_F_ORIG_STACK flag for arch_prepare_bpf_trampoline
> function.
> 
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>   arch/x86/net/bpf_jit_comp.c | 13 +++++++++----
>   include/linux/bpf.h         |  5 +++++
>   2 files changed, 14 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
> index 2a2e290fa5d8..b77e6bd78354 100644
> --- a/arch/x86/net/bpf_jit_comp.c
> +++ b/arch/x86/net/bpf_jit_comp.c
> @@ -2013,10 +2013,15 @@ int arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *image, void *i
>   	if (flags & BPF_TRAMP_F_CALL_ORIG) {
>   		restore_regs(m, &prog, nr_args, stack_size);
>   
> -		/* call original function */
> -		if (emit_call(&prog, orig_call, prog)) {
> -			ret = -EINVAL;
> -			goto cleanup;
> +		if (flags & BPF_TRAMP_F_ORIG_STACK) {
> +			emit_ldx(&prog, BPF_DW, BPF_REG_0, BPF_REG_FP, 8);

This is load double from base_pointer + 8 which should be func return 
address for x86, yet we try to call it.
I guess I must have missed something
here. Could you give some explanation?

> +			EMIT2(0xff, 0xd0); /* call *rax */
> +		} else {
> +			/* call original function */
> +			if (emit_call(&prog, orig_call, prog)) {
> +				ret = -EINVAL;
> +				goto cleanup;
> +			}
>   		}
>   		/* remember return value in a stack for bpf prog to access */
>   		emit_stx(&prog, BPF_DW, BPF_REG_FP, BPF_REG_0, -8);
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index 86dec5001ae2..16fc600503fb 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -554,6 +554,11 @@ struct btf_func_model {
>    */
>   #define BPF_TRAMP_F_SKIP_FRAME		BIT(2)
>   
> +/* Get original function from stack instead of from provided direct address.
> + * Makes sense for fexit programs only.
> + */
> +#define BPF_TRAMP_F_ORIG_STACK		BIT(3)
> +
>   /* Each call __bpf_prog_enter + call bpf_func + call __bpf_prog_exit is ~50
>    * bytes on x86.  Pick a number to fit into BPF_IMAGE_SIZE / 2
>    */
> 
