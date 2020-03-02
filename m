Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94550176006
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 17:35:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727490AbgCBQfh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 11:35:37 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:34456 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726872AbgCBQfg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Mar 2020 11:35:36 -0500
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 022GQXFr013435;
        Mon, 2 Mar 2020 08:35:23 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=w7qdDo/PZ5gA9f0gfWVHxiWwv6BgY2ulxMBcyVk8y3Y=;
 b=lx0/k9NQwsVbZ+w0jTCWALDxYExDvVDGc8biPJXI/Olpkicat8y4sbtFvwg3P4l6mx3H
 VLug1Sb7gwykHXu6GezQk8lKlnueAXiueto1+baoRsUQ1cvfbp7I3xJaMzqGSJOLvlJJ
 /NasrTLZfzmRc89XFYYra037+CfVFZ+ukTE= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2yh53508q3-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 02 Mar 2020 08:35:23 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Mon, 2 Mar 2020 08:35:21 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cUOTktekXtvFQxgduekcJdWTE188aP1VYz7R47pOW9EISPNkMKU/XUT5e/R4JudGLzFk+oooVE0Ov3661PXZGfss+qEcedbB+N1vdX7mgjXukea31E/BlwmwBdTWSWYnnLlvIpi8+zzPzX3/uo3dzRyZ0Bn4x2nNdzC2IBX4CxQEzaZ5I/y0vWrDT/ocB9Mo9S008JLTxnbXwMbwWJog4xF0w3J0DBEG1J5qDpqmr5zSczZi70nw2MMAM5Ekb/BL0jPpAbJpM1yMRSesOQSJAivagg1TNYYOGpUj5mN1kJ9NZcDuIyn4zbsBUiQ26dvIS1LcWB6NQ6Ua4Nus/hFVOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w7qdDo/PZ5gA9f0gfWVHxiWwv6BgY2ulxMBcyVk8y3Y=;
 b=V82R4pPOjdFXhv9B2MItNXMh4mTxJVymBtcoXTl9J4l7u4+rsQG2D4fqcdJeImsgzvlPYOujhEsFCoWepT3frXV8ak/LGKB52AUB51cnXFCN/yJIz0iEWiT9gY1B0nJJfG7+BW9PREqQq9wVjKbPF/GBYqobn5XYtVrvPCN2V4K5Vg/X2b8iq6zd3brsQE3vXYqPDok1MgJhptobnTzS0F7zBqHCKhPNq+cKalYfioc4MAC3txmmc7IJPa2j+EsEkWZEaTDJTbRT3/QIfCterKfObIM5TrrlFYa5uNlixUemcxQirjw3F6FKOJhk0uJHlPahr9/KSTMAMJl9Ckw3uA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w7qdDo/PZ5gA9f0gfWVHxiWwv6BgY2ulxMBcyVk8y3Y=;
 b=eWj0XCRSqGkCVfS7fUVVPK8X2Z063giYNF3j6Dg/njXbLyJyJIgOA74LP5U0sErAdRqGxnyu6HXalbPt5KiYEQMaJUtqTcNHtWVqG/kBTxJOLpxfnEvNhlCRRVBLcGvRzCf0XTT1grH9p283y1PAUdl7UR34BhSfDvTM5OFgJuA=
Received: from DM6PR15MB3001.namprd15.prod.outlook.com (2603:10b6:5:13c::16)
 by DM6PR15MB2905.namprd15.prod.outlook.com (2603:10b6:5:139::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.14; Mon, 2 Mar
 2020 16:35:21 +0000
Received: from DM6PR15MB3001.namprd15.prod.outlook.com
 ([fe80::294e:884:76fd:743c]) by DM6PR15MB3001.namprd15.prod.outlook.com
 ([fe80::294e:884:76fd:743c%4]) with mapi id 15.20.2772.019; Mon, 2 Mar 2020
 16:35:20 +0000
Subject: Re: [PATCH bpf-next 1/3] bpf: reliably preserve btf_trace_xxx types
To:     Andrii Nakryiko <andriin@fb.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <ast@fb.com>, <daniel@iogearbox.net>,
        <ethercflow@gmail.com>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>
References: <20200301081045.3491005-1-andriin@fb.com>
 <20200301081045.3491005-2-andriin@fb.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <eeec59cd-f564-23c7-9fd3-ef460ef162da@fb.com>
Date:   Mon, 2 Mar 2020 08:35:17 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.5.0
In-Reply-To: <20200301081045.3491005-2-andriin@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MWHPR04CA0055.namprd04.prod.outlook.com
 (2603:10b6:300:6c::17) To DM6PR15MB3001.namprd15.prod.outlook.com
 (2603:10b6:5:13c::16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from macbook-pro-52.dhcp.thefacebook.com (2620:10d:c090:500::6:87b3) by MWHPR04CA0055.namprd04.prod.outlook.com (2603:10b6:300:6c::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.15 via Frontend Transport; Mon, 2 Mar 2020 16:35:19 +0000
X-Originating-IP: [2620:10d:c090:500::6:87b3]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9b099678-b32d-4e14-5626-08d7bec7b306
X-MS-TrafficTypeDiagnostic: DM6PR15MB2905:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR15MB29052F93137B5A9D74E2172ED3E70@DM6PR15MB2905.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-Forefront-PRVS: 033054F29A
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(376002)(39860400002)(136003)(366004)(396003)(346002)(199004)(189003)(6512007)(16526019)(8936002)(186003)(8676002)(31696002)(86362001)(478600001)(2616005)(81156014)(966005)(81166006)(4326008)(53546011)(6486002)(36756003)(5660300002)(66556008)(2906002)(66946007)(66476007)(316002)(52116002)(31686004)(6506007)(21314003);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR15MB2905;H:DM6PR15MB3001.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: F6Di1Ij8ruxzreWpCTaiDFk7adTo05/4MXVxZDFK2h9UKRq/X/ZHIPNPcc/3f+qu0hurZmj+a9PWzY89k/M8x2eD+quC/i0J56c6ZHKFDx83H2hA8g8AM87gvyE0OCpVzVmCyaq3eyDjPbygxFDZriRHjuYyoikluqVcQpOtteJNvDpjOdTfXb8RTcJjIY9vKDNuZa8qgNmU69Jpy64NdmPF8tptHNJEkSONPFHKiR0YdyoNYGBqDcXeFRHjt8dudAzOb/OeyDT02vN9R6TEcid8XqU8PFiuIPDoaPGe/v98Is78EXzbR4Q7KeBidmNyOA7lSFgodFy0YIrRdOdAJFx3hywU3dsisZ0tTncBRmOMqstFTv6Z2pSF3kG4OI3YoT9pr1LQitBJMbMaX4rLp4G2ftKI06LofTOGuC1W1Qz9K9DHVmhafPhkrREq0Tn62Ebuev0JhzL46oXPbpUMC0DcrLW2ReCLjt5Q2v/p+R50gfWWQqyGJg/lhIGDueQByFGDR517klE2kMruCLmr0azEodIcIjkiqVC9oHB6X/eaoQKEJqSY7K7TuwJCBpGS
X-MS-Exchange-AntiSpam-MessageData: E5U0d8PeED/atHlh8Qkp4EgOMkC+dAnUXAX+fmMrdadeF/ERuIsuGTkiZZDCBbDek5iw3WWdVUXuUCVnAnB1EbNGVi/iTcUG5YbuoDYPTBsYMcR/Wq6xnydjsasUFTScP3t7S/PoIudYgT+QemtLWYmQrvD3nR/usHXldbqR0Z6c13MGkum+FBumzRvOlCDM
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b099678-b32d-4e14-5626-08d7bec7b306
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2020 16:35:20.9189
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0fIW7am0ZBXMZZ7491m8h2T4cUj+nSgHFpP9TS+YPTfFfJlE3yoSmtZN6rndFGPJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB2905
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-02_06:2020-03-02,2020-03-02 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 malwarescore=0
 mlxlogscore=999 spamscore=0 clxscore=1015 impostorscore=0
 lowpriorityscore=0 suspectscore=0 priorityscore=1501 adultscore=0
 bulkscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003020114
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/1/20 12:10 AM, Andrii Nakryiko wrote:
> btf_trace_xxx types, crucial for tp_btf BPF programs (raw tracepoint with
> verifier-checked direct memory access), have to be preserved in kernel BTF to
> allow verifier do its job and enforce type/memory safety. It was reported
> ([0]) that for kernels built with Clang current type-casting approach doesn't
> preserve these types.
> 
> This patch fixes it by declaring an anonymous union for each registered
> tracepoint, capturing both struct bpf_raw_event_map information, as well as
> recording btf_trace_##call type reliably. Structurally, it's still the same
> content as for a plain struct bpf_raw_event_map, so no other changes are
> necessary.
> 
>    [0] https://github.com/iovisor/bcc/issues/2770#issuecomment-591007692
> 
> Fixes: e8c423fb31fa ("bpf: Add typecast to raw_tracepoints to help BTF generation")
> Reported-by: Wenbo Zhang <ethercflow@gmail.com>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

clang seems doing a little bit optimization here...
The change looks good. It is hard to have code to preserve the types in 
the header. union seems an acceptable way.

Acked-by: Yonghong Song <yhs@fb.com>

> ---
>   include/trace/bpf_probe.h | 18 +++++++++++-------
>   1 file changed, 11 insertions(+), 7 deletions(-)
> 
> diff --git a/include/trace/bpf_probe.h b/include/trace/bpf_probe.h
> index b04c29270973..1ce3be63add1 100644
> --- a/include/trace/bpf_probe.h
> +++ b/include/trace/bpf_probe.h
> @@ -75,13 +75,17 @@ static inline void bpf_test_probe_##call(void)				\
>   	check_trace_callback_type_##call(__bpf_trace_##template);	\
>   }									\
>   typedef void (*btf_trace_##call)(void *__data, proto);			\
> -static struct bpf_raw_event_map	__used					\
> -	__attribute__((section("__bpf_raw_tp_map")))			\
> -__bpf_trace_tp_map_##call = {						\
> -	.tp		= &__tracepoint_##call,				\
> -	.bpf_func	= (void *)(btf_trace_##call)__bpf_trace_##template,	\
> -	.num_args	= COUNT_ARGS(args),				\
> -	.writable_size	= size,						\
> +static union {								\
> +	struct bpf_raw_event_map event;					\
> +	btf_trace_##call handler;					\
> +} __bpf_trace_tp_map_##call __used					\
> +__attribute__((section("__bpf_raw_tp_map"))) = {			\
> +	.event = {							\
> +		.tp		= &__tracepoint_##call,			\
> +		.bpf_func	= __bpf_trace_##template,		\
> +		.num_args	= COUNT_ARGS(args),			\
> +		.writable_size	= size,					\
> +	},								\
>   };
>   
>   #define FIRST(x, ...) x
> 
