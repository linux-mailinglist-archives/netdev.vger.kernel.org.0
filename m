Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C01651501AA
	for <lists+netdev@lfdr.de>; Mon,  3 Feb 2020 07:22:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727535AbgBCGV7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Feb 2020 01:21:59 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:42576 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727240AbgBCGV7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Feb 2020 01:21:59 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 0136A2sG017419;
        Sun, 2 Feb 2020 22:20:52 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=K/8ktSIsAvoJ0nUZ5dILkNtx4J6nUrEgEIG+FDKgSHI=;
 b=nqwHLhheXdj+Wal0rgZHuIOmcBK0MrFxvdaWSzqQj030yD3fInONWcaDZtLk8XxArsza
 3cYTKRoxS3WAw6feoP7S2ZTRDQwTPjrHunhGOOJdVy01YvPF5H7vr9laYtE9GTu0yOhH
 Rrj/w31JNcefJDzB+GwN7sxwVJvWGjbtIQI= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 2xw5vsntpg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sun, 02 Feb 2020 22:20:51 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Sun, 2 Feb 2020 22:20:51 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PBk8EfOHxNkQcjW3a/HAa7E9wy2f2w/8HKtETTK4xnP96Nlnt/saGGd/bQlpD1bR3i0JC/DvkAiDvfs3bJ5FJh6mEGYXTeb16LMNqFabYsM6oa2CV0y4ncUQ34IrtuFahq9VMVqhuWz6FIkBD3VKkEhLxy6U5vASAjFgijDLk8XMoBNH7p5cHViZesQnCtofO5zXEkZM37/mC+MKAEZQxzx+vU99qdNS/lxXNdK+h+mYMtIB/nrZuUJn7zJpC//7p3vog5TiqoHuaDrFSEvpxtS0nlBp5X4O71VvEToufNs7Sb8asE4DaZFk2KTVdK02UfnuEXxy30THhRjcNPA9Jg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K/8ktSIsAvoJ0nUZ5dILkNtx4J6nUrEgEIG+FDKgSHI=;
 b=Aw3Kedog5AS2xMmQ9NueWnbzQfx+2UzVbyfARfzQTAEVTHG+c654bphh+1Fx0LR3j6SIOhWSCz6tOSuOIYjNmzblv5DOYdfIdlh/fmzJd67OMn5A9b7rSal2oA9TK4zv78etY7ibFsFqEuFrHHZWZIsWN64UA+v/lkOdOIEiw+c0uDI/RcxX7f1PTkSurWLPD6QXkBlpLHE5TfKR83W2S7h0IzSfG6SkFls5D0eYBNeNtXC5VFt6wP9BarfZZC1FyY83FSUjQuEvWZUbfJrWNZPNH/yfMYLsHNwnx5HqRD2JAnTO2cVCjqW7qikaKXPXdl/3I/gtFaCc0cXfPRkaUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K/8ktSIsAvoJ0nUZ5dILkNtx4J6nUrEgEIG+FDKgSHI=;
 b=Q0KHKHKj4ZTn2rmPtzIjpwCgWRfKBbji0kKrcaWFY8aKF6xZzYeSsvyWYquNdegDIjMw87clI8RGZJNJt1SLsbXAzEZb2ug81pouD9C6X0rjh7HGKmrUbkmFZ9YJKQcZVVEeZWpHbALoVQHNz1fSwNZp7LulM3HDeAOcVwJudto=
Received: from DM6PR15MB3001.namprd15.prod.outlook.com (20.178.231.16) by
 DM6PR15MB2826.namprd15.prod.outlook.com (20.179.164.31) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2686.27; Mon, 3 Feb 2020 06:20:36 +0000
Received: from DM6PR15MB3001.namprd15.prod.outlook.com
 ([fe80::294e:884:76fd:743c]) by DM6PR15MB3001.namprd15.prod.outlook.com
 ([fe80::294e:884:76fd:743c%4]) with mapi id 15.20.2686.030; Mon, 3 Feb 2020
 06:20:36 +0000
Subject: Re: [PATCH -next] bpf: make btf_check_func_type_match() static
To:     Hongbo Yao <yaohongbo@huawei.com>, <ast@kernel.org>,
        <daniel@iogearbox.net>
CC:     <chenzhou10@huawei.com>, <kafai@fb.com>, <songliubraving@fb.com>,
        <andriin@fb.com>, <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <clang-built-linux@googlegroups.com>
References: <20200203020220.117152-1-yaohongbo@huawei.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <a29bf101-81b0-68ef-356c-dfdc9c53d899@fb.com>
Date:   Sun, 2 Feb 2020 22:20:31 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.4.1
In-Reply-To: <20200203020220.117152-1-yaohongbo@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MWHPR03CA0018.namprd03.prod.outlook.com
 (2603:10b6:300:117::28) To DM6PR15MB3001.namprd15.prod.outlook.com
 (2603:10b6:5:13c::16)
MIME-Version: 1.0
Received: from MacBook-Pro-52.local (2620:10d:c090:180::afe7) by MWHPR03CA0018.namprd03.prod.outlook.com (2603:10b6:300:117::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2686.29 via Frontend Transport; Mon, 3 Feb 2020 06:20:34 +0000
X-Originating-IP: [2620:10d:c090:180::afe7]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d9cea84e-7bd2-4a5e-b2cc-08d7a8712e73
X-MS-TrafficTypeDiagnostic: DM6PR15MB2826:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR15MB28264B169DAFFA6D1AB8BAC6D3000@DM6PR15MB2826.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:291;
X-Forefront-PRVS: 0302D4F392
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(346002)(376002)(366004)(396003)(136003)(39860400002)(189003)(199004)(6666004)(66946007)(53546011)(6506007)(5660300002)(66556008)(66476007)(52116002)(81156014)(8676002)(81166006)(478600001)(8936002)(316002)(16526019)(31686004)(2906002)(6486002)(6512007)(31696002)(86362001)(186003)(2616005)(4326008)(36756003);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR15MB2826;H:DM6PR15MB3001.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bkJgpyaHV8h8MGm9SfOruVxFeJuq/OQNuqcOP6Sgo0FJM2FsU8pEVQX1burRaPJVxdGbH85+vQ4VxEXoHy/pHlnU/Koi4GcJgJi2dIMGauLzqmqlztP67x0Ny4QwTM2V85UJ2N19obHPSYvRPwS/ULirmx8iNEslgAu3P2+/0ZOB8LBcyZz0L94k2Sh3YEw/TDX+vBuHkYWIKlB5bNz4dIh56flKZZZSxRdvosmPjFvhBqCx+mTMTqZJXsmzkSD2mj7bsmf8Jct6ITraD+a4WFPtuXy8lL62W8g010g9e3sXHjpU39Xgi/9XFXNQPldukNCFE4e3t/OBB+dC6lNE3WH7DiGB23mU60eeRH9kD2BvRj4ChDyoBew5TfVdkgm7gcu6qSTLGtBnO//cDFcf52gJONf9QlHBz+KBYWutqu97bq4HsUJHUAzGjOjXyy7v
X-MS-Exchange-AntiSpam-MessageData: +BG3KNvhsvVnHfDug5jXGdZXILspH3fQF6xMEeEXL0iFdOe9qLt4MpcGXeI0ABfGos3Am/+Pf/38a49H4siKLjjBLfNqJpPPPiYT6qXn4W8OC3HimgHfMCWCjjBbsa6XvJdtssWlFB5hJpKBujmqn7Amzt3ol65J2CkeF5BHjEE=
X-MS-Exchange-CrossTenant-Network-Message-Id: d9cea84e-7bd2-4a5e-b2cc-08d7a8712e73
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2020 06:20:36.3118
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OutLqTq+6zduPepUAz5Nzz49tHmOmRiJr3BuC7z32tFpbXgwchloDlz3VmGz3mdf
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB2826
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-03_01:2020-02-02,2020-02-03 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 mlxlogscore=999 suspectscore=0 clxscore=1011 priorityscore=1501
 adultscore=0 spamscore=0 mlxscore=0 lowpriorityscore=0 malwarescore=0
 bulkscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1911200001 definitions=main-2002030049
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/2/20 6:02 PM, Hongbo Yao wrote:
> Fix sparse warning:
> kernel/bpf/btf.c:4131:5: warning: symbol 'btf_check_func_type_match' was
> not declared. Should it be static?

Yes, static is better since the function is only used in one file.

Please use the tag "[PATCH bpf-next]" instead of "[PATCH -next]".
Since this is to fix a sparse warning, I think it should be okay
to target bpf-next. Please resubmit after bpf-next reopens in
about a week.

> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Hongbo Yao <yaohongbo@huawei.com>
> ---
>   kernel/bpf/btf.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> index 8c9d8f266bef..83d3d92023af 100644
> --- a/kernel/bpf/btf.c
> +++ b/kernel/bpf/btf.c
> @@ -4144,7 +4144,7 @@ int btf_distill_func_proto(struct bpf_verifier_log *log,
>    * EFAULT - verifier bug
>    * 0 - 99% match. The last 1% is validated by the verifier.
>    */
> -int btf_check_func_type_match(struct bpf_verifier_log *log,
> +static int btf_check_func_type_match(struct bpf_verifier_log *log,
>   			      struct btf *btf1, const struct btf_type *t1,
>   			      struct btf *btf2, const struct btf_type *t2)

Please also align
   struct btf *btf1, const struct btf_type *t1,
   struct btf *btf2, const struct btf_type *t2)
properly after you added 'static' before the function declaration.

>   {
> 
