Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF0EB2F1C16
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 18:19:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389333AbhAKRRq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 12:17:46 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:62071 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389214AbhAKRRp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 12:17:45 -0500
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10BHEQVJ022997;
        Mon, 11 Jan 2021 09:16:43 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=JSuDuJfdt1fYKfD+NJwOJKD4A0fd/ZaKtv4kdQ3JMk4=;
 b=MekuRAzB9RjLKS7a13dopfXZL1x8CjX/L1hx6GWqF5TIUakd0TUW8stYY5j7XIdGlAcB
 R4o7MuzhGIqaYA66Gtqcj7OAWJI/fTgvOm9fLUJQaZr4QYW3vl6mA8bVWf3L5Q5LZFac
 +k0r1c2QlcfiLZ8aQzOxXByHkWP2XLCE3Sg= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 35yavt0ee3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 11 Jan 2021 09:16:43 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 11 Jan 2021 09:16:42 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Op9jkAfEGYCsLGlraNLhwUwDKhnfwRfiEsB6e8j9MPhGtqJQUaPnRPVy9XGscUYu6c8ks2vEEjl4FQuKxqCYt5owam4CinMcu8DfJoXt3ZUQs/CB/mvtSC3Xrb+QavT4CEqO5newwiSZ7taOOmPKazeJaZaFGMHGYSwYeqp2acBVfzgmNGEUAp4YdIgtadAj+AsEQNNC7pA2AHw7GV5YVH9utKlgXzuue+AJUPqhcxO5JRQN/14GZD1tkMfObF2MMYQnL3F0QZ8DvkL/G9SjdIDUiV635iq4piXZiGG1KdSU8Qba3hEZtpvUPavPzFGDFUlGOgkUtltn/P/JB8R9Fg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JSuDuJfdt1fYKfD+NJwOJKD4A0fd/ZaKtv4kdQ3JMk4=;
 b=agAbyWxklpiZ63NL+7quWQ1t1Q7PSbVz/Bnmh5ccF9gJSLSoCKXl6noNV/NsIefna5h0dZsYA65ISXYikvGBkUhZuLLWzaf5Z4X2T29dKpn8xr2kXdQOEi5jhBxVMQrxRpX6IIpK956db4KwVwQ/22mGHREJGdb9KyevkB2aWbrLaSn2vD7zzkfN4ybKwJxVZ7OqESTHYhaxd7wglTcGI02BIaqEixItat5ZzqTJWnmF54sqz/ATTWLDF+BW2lU+Th4LuNqU0IeC9nlOluAxkJtJaaGySN5e7aK17un4Hg08YXhMqf+R9F6pP6vgdvjeB1s92v5uLjbt+tDClZo+1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JSuDuJfdt1fYKfD+NJwOJKD4A0fd/ZaKtv4kdQ3JMk4=;
 b=S27sKy0ANNwW3+gW+pDlI3ec4C6E7BLXOXDA+Y3TQ/wgATY+AQhxZbxuNqFfiel+urvSEGVhxiOPhhbkLkI2ePURyRvrLkXbmqzGD8AIyBxHXDiLylpRU3xPYveAzPS1ruanE6ySDxZcWPSVUydI1ZEwTkqBDdmX1c5ieQNp8x4=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB3208.namprd15.prod.outlook.com (2603:10b6:a03:10c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Mon, 11 Jan
 2021 17:16:36 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03%7]) with mapi id 15.20.3742.012; Mon, 11 Jan 2021
 17:16:36 +0000
Subject: Re: [PATCH bpf-next 1/4] bpf: enable task local storage for tracing
 programs
To:     Song Liu <songliubraving@fb.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <mingo@redhat.com>, <peterz@infradead.org>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <andrii@kernel.org>,
        <john.fastabend@gmail.com>, <kpsingh@chromium.org>,
        <kernel-team@fb.com>, <haoluo@google.com>,
        kernel test robot <lkp@intel.com>
References: <20210108231950.3844417-1-songliubraving@fb.com>
 <20210108231950.3844417-2-songliubraving@fb.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <a3421aeb-b293-e49a-cfe1-7163cc75bd84@fb.com>
Date:   Mon, 11 Jan 2021 09:16:33 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.0
In-Reply-To: <20210108231950.3844417-2-songliubraving@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:6450]
X-ClientProxiedBy: BY3PR04CA0004.namprd04.prod.outlook.com
 (2603:10b6:a03:217::9) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21c1::1158] (2620:10d:c090:400::5:6450) by BY3PR04CA0004.namprd04.prod.outlook.com (2603:10b6:a03:217::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6 via Frontend Transport; Mon, 11 Jan 2021 17:16:35 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8d9546e4-093d-476b-19c7-08d8b654a6bf
X-MS-TrafficTypeDiagnostic: BYAPR15MB3208:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB320819B029520AEBF07DAA40D3AB0@BYAPR15MB3208.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: W9edEDyMXSK15eN3i2UsMQSBccuQL/8HsPk+V343HGlWVq2cA6i+v9D54J19iMDzaDCIaiaMoyZRLA/jYsCIRxAfjSLyUkHWFYBp48cFXQcYjE7X8f00JfuODanC29uf5OD1nevPbn1D9pgGpvVd1wy27FgeW2iaat5Qp8kfsWzeEAowvTrx9aSXz7HsPZGkNo/IWY+QZmRW+A0Wq8kZ3MBaGT/3FU5KulqD0emlnMrJ0xKU9q/CG/7qOd4JwwRsMdYAG9sfjAxDU7tLCUQagyiFjs1ERP+n9sHu0aoSYhW+J0ZW3moiWfRypkAAHkdiXwggPKD4qYMHfDgby4s0twS9Sk2d2YHUdGFMix+Xg2nke8BDZdWkee+aCK4QLVgDKFZhHn2zwzWJMcuOFfGM72iAL5ZAkh3lRAdxsdVcj7ocnqXoKQwgDSipAuY3JQv/fau2eQVlDMRi4SefoU4RAnG8EnaB/pV7H6r9wqZuQN8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(366004)(376002)(346002)(396003)(136003)(2616005)(31686004)(7416002)(5660300002)(52116002)(31696002)(86362001)(478600001)(66476007)(66556008)(16526019)(186003)(4326008)(8936002)(2906002)(316002)(36756003)(6486002)(66946007)(8676002)(53546011)(83380400001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?cjUxZzBSNWZHOFB2RjEwWXZnbGZ5VC9TUTdud0txb0tqRGRzUzBPQUtkNWxq?=
 =?utf-8?B?bWMzZVV2c1hmQlFGVE5QUmFnRzkvQlZKL21YVzVyWFUxVlFmRmI4bzdqcmNM?=
 =?utf-8?B?TjZmZVRDV243dkd1NHZCYlhSaHhvRFhVL0RHREg2T08rZEhSQzM5OW92NFgy?=
 =?utf-8?B?Nm1abzFhSjV2am5PVHBZalZGeE1Dd29NbHlSSEVhS3d6bVlBQ2J3NnNTNEp1?=
 =?utf-8?B?OTc4N3A1VWlidkZjN00wWlpnOE83bTNvU2lyOXF1R0hDcklOYWI1Z1BZc3lQ?=
 =?utf-8?B?c2dWckVkUzJJYXpkOWhkQWJ2Y2dHSVJwMGx4dkdoTmRLY3ppRWROcnFQQTdN?=
 =?utf-8?B?em54Z3VmZHlYc1h3eWtiQWN1T0g0TzV0cjlNMExvNldGY0R5VW1JSWI0aXRY?=
 =?utf-8?B?enp4UVRRYUwxM3J2VkQxaTZDL0xQOU51eXpINjdlQ1lBWDlURTdKSDhBMXFt?=
 =?utf-8?B?VkcrN0lFZUtjR2s1SzVzanUraDNreng0Q3ZRTUVxSkxEVGFycmlRUmpFUlBM?=
 =?utf-8?B?SEhwcXJCOGpmNkE1UngrK3RwRWJKdEIvVmVQTmt1RmFnRnZ0bjNHNmE0Uk5h?=
 =?utf-8?B?MUZSRWtnRVJPeTgraFRRNVIyWVNydmxHN1RmY1JPV3owNUwyZDVoNDhGOHhF?=
 =?utf-8?B?a1JTU2ZTbVdmOCsvdCtLUjZUUklaS2k1VXQvcm81RGNqVGFhSXRMTnlQNXlH?=
 =?utf-8?B?dWJBOUFBVjA3VW5wZW5iTGlTRHIyMDA3UlRiN25JZzFwWEZqWlk4RUdYeWNL?=
 =?utf-8?B?YlFOQXVYM1pPT3FrZTJRalYzVVB1a3dlU0o4RVM1LzIwNmhKUUJWemd1T0VZ?=
 =?utf-8?B?TENVeStXNEZHQWdXRVBEcG1BVDRsWGl4elpULzYzbzZ3ME13cHgxQThmVlFi?=
 =?utf-8?B?c2s0Z1oyMXQyMDdmRm80NEVYWW1pQ0Q3dU9yYUhuY28vMFlweDdzR3VBajNo?=
 =?utf-8?B?QWJwWklUaDArVTdaN1JaWEc3bWxDVWNtMEpKNGJ4ZXFZMEVnaVQ5SnpqRzdN?=
 =?utf-8?B?MzIrbWVES0s4RUQ5UXpla2ZuT1JmdUx0dm9SWGNYVDMwZ2gxM21NM095WFcx?=
 =?utf-8?B?V084NDhHM09kc0RJU0U4dEthZVh2V3E3ekpITk1jRTZwWlFGdnd3V0d0YzJh?=
 =?utf-8?B?bzFVNWgrVW1Sc3JuMjB3RnpqLy9vUXNaZEFxS3ZBcEQ4Z1B6WkR3dURrRVZO?=
 =?utf-8?B?dUVGT2p3TFFvRWswUnJjdzFYVDBNS2xlTGx3cmNiZ1drT2ZPZUU5U0NQREQz?=
 =?utf-8?B?Vi9pdXM1WEZpRGR1dnhJd2NHaHoxRkFHSjhZYSswRndIQzlOazJCNEwwZUR0?=
 =?utf-8?B?UndPdW12SW1kNkN2d3M5Um50WDhzUzVNZkgvTm1zU21KbzhCOThmK3Raa215?=
 =?utf-8?B?ZGo5UGp2NlVrbnc9PQ==?=
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2021 17:16:36.2865
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d9546e4-093d-476b-19c7-08d8b654a6bf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ji3nuWwEkwg0iIDg/mXc54iU5JiwZ5DwGAefOaJlg5G/MXY/5BZJelawf1Kj2gtP
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3208
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-11_29:2021-01-11,2021-01-11 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 suspectscore=0
 clxscore=1015 priorityscore=1501 mlxlogscore=999 lowpriorityscore=0
 impostorscore=0 adultscore=0 bulkscore=0 spamscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101110099
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/8/21 3:19 PM, Song Liu wrote:
> To access per-task data, BPF program typically creates a hash table with
> pid as the key. This is not ideal because:
>   1. The use need to estimate requires size of the hash table, with may be
>      inaccurate;
>   2. Big hash tables are slow;
>   3. To clean up the data properly during task terminations, the user need
>      to write code.
> 
> Task local storage overcomes these issues and becomes a better option for
> these per-task data. Task local storage is only available to BPF_LSM. Now
> enable it for tracing programs.
> 
> Reported-by: kernel test robot <lkp@intel.com>

The whole patch is not reported by kernel test robot. I think we should
drop this.

> Signed-off-by: Song Liu <songliubraving@fb.com>
> ---
>   include/linux/bpf.h            |  7 +++++++
>   include/linux/bpf_lsm.h        | 22 ----------------------
>   include/linux/bpf_types.h      |  2 +-
>   include/linux/sched.h          |  5 +++++
>   kernel/bpf/Makefile            |  3 +--
>   kernel/bpf/bpf_local_storage.c | 28 +++++++++++++++++-----------
>   kernel/bpf/bpf_lsm.c           |  4 ----
>   kernel/bpf/bpf_task_storage.c  | 26 ++++++--------------------
>   kernel/fork.c                  |  5 +++++
>   kernel/trace/bpf_trace.c       |  4 ++++
>   10 files changed, 46 insertions(+), 60 deletions(-)
> 
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index 07cb5d15e7439..cf16548f28f7b 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -1480,6 +1480,7 @@ struct bpf_prog *bpf_prog_by_id(u32 id);
>   struct bpf_link *bpf_link_by_id(u32 id);
>   
>   const struct bpf_func_proto *bpf_base_func_proto(enum bpf_func_id func_id);
> +void bpf_task_storage_free(struct task_struct *task);
>   #else /* !CONFIG_BPF_SYSCALL */
>   static inline struct bpf_prog *bpf_prog_get(u32 ufd)
>   {
> @@ -1665,6 +1666,10 @@ bpf_base_func_proto(enum bpf_func_id func_id)
>   {
>   	return NULL;
>   }
> +
> +static inline void bpf_task_storage_free(struct task_struct *task)
> +{
> +}
>   #endif /* CONFIG_BPF_SYSCALL */
[...]
