Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4530918D2CA
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 16:24:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727534AbgCTPYV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 11:24:21 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:32506 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726847AbgCTPYU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 11:24:20 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02KFKX8M003323;
        Fri, 20 Mar 2020 08:24:04 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=Xlo9TfoRj808PTBTqCNGTgU2YuTzjHquSMGNj263OBM=;
 b=IzR0Fv/V2iCagSI8YMUwXTV70e0YdIbrmnmQkCW5DfNc0bKxWGjKRtNkJX5h+xLHTV7p
 jyI7Q+W4enoqyui8ssov263J/wb6h9AMPnuo9odHvWrbh03KsN02SJBfwaEi1FoAirmB
 zO6YaK1wuMU1+6oV6zHukP+VgfOC9/EHZBI= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2yu7qapu31-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 20 Mar 2020 08:24:03 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Fri, 20 Mar 2020 08:24:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I08J57Gvi5sI0CJSxuN0tYDdVdTDol8iWEeF/pazelzSIVBjzpht/weqb82BMo48ZVPqZesgAU4dPsf5ErxBykd7vAhdo9eYhAaVRf853OPth+CjcIdV3DaoQpxxLhs9ipc32vWoLuUEdZ0x/GYEfAMLRXZA28lExgZyvfaTguLtx1TzOYJU2s5/xjcrUjE2RRCj23MRkIVnPNQg8RTwzkH6UmOYVyYJRmplg5I+iqc85Ioed2dxo6w7cWYDI3NZf2A2IipNE4rwo3Vc5r76VY5VCpRznpGS6xktBK0KyHgk3OziNeAZa+2N8yJb9BkTzxjLbag6Rv1HKUX548WZ7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xlo9TfoRj808PTBTqCNGTgU2YuTzjHquSMGNj263OBM=;
 b=oJjIK8ioO7jFraD0WVvqjZroKJ5ucY4SDbAk2v8F3VeAbUJh/p9SQIh+mWSt2IcJL/NiDkHocpUc8Lsv5hOAsA7e6ESSdLGbFXJin0rVin+Bu0F9IA7dGpVXYDJ7UbweVSnPgTleEzizoYt+xlc+7mw2XClCkGOIDckoHltK9e8AtjdtM6EXMiJVY6zinEPz4GHocH5XFiq36NdI2GhBANihy7KjjcMgMJx8VSnxWq2AuTQtUuBYgDdH996fed+HQs5M79bgmSxk62OWabYPo30zM3plCm/j8jUY/4/gdRYXdcbj7Mw7seQnTRE6mFcAfjxpJ/eYGF6fWgJcqKRyUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xlo9TfoRj808PTBTqCNGTgU2YuTzjHquSMGNj263OBM=;
 b=gIDaeb8WQpstXbzpUpTAPe8vpJli9+eMG+d6HV8CeoJ1IQF8LPWxY802L90g5ziQ4Uknoo1ZmuRsFgQrNGSrDl/hoNTPBIaW6Qcu3b+kY5VhfPVWqyh4K2TnS2QMo23W8yq5JFziRmeICURAFD8/uJTQAwhL3FRQ9vXFjgNKajo=
Received: from MW3PR15MB3883.namprd15.prod.outlook.com (2603:10b6:303:51::22)
 by MW3PR15MB3755.namprd15.prod.outlook.com (2603:10b6:303:4c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.15; Fri, 20 Mar
 2020 15:24:00 +0000
Received: from MW3PR15MB3883.namprd15.prod.outlook.com
 ([fe80::a49b:8546:912f:dd98]) by MW3PR15MB3883.namprd15.prod.outlook.com
 ([fe80::a49b:8546:912f:dd98%5]) with mapi id 15.20.2835.017; Fri, 20 Mar 2020
 15:24:00 +0000
Subject: Re: [PATCH] bpf: explicitly memset the bpf_attr structure
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
CC:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        =?UTF-8?Q?Maciej_=c5=bbenczykowski?= <maze@google.com>,
        John Stultz <john.stultz@linaro.org>,
        Alexander Potapenko <glider@google.com>,
        Alistair Delva <adelva@google.com>
References: <20200320094813.GA421650@kroah.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <d0dfc2ff-8323-12ed-3c7e-e8c6a118b890@fb.com>
Date:   Fri, 20 Mar 2020 08:23:57 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.6.0
In-Reply-To: <20200320094813.GA421650@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MWHPR1701CA0003.namprd17.prod.outlook.com
 (2603:10b6:301:14::13) To MW3PR15MB3883.namprd15.prod.outlook.com
 (2603:10b6:303:51::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from bcho-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:a280) by MWHPR1701CA0003.namprd17.prod.outlook.com (2603:10b6:301:14::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.18 via Frontend Transport; Fri, 20 Mar 2020 15:23:59 +0000
X-Originating-IP: [2620:10d:c090:400::5:a280]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 458bbe48-851b-4ebf-c218-08d7cce2b710
X-MS-TrafficTypeDiagnostic: MW3PR15MB3755:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MW3PR15MB37555CF9A979C2B5B007C230D3F50@MW3PR15MB3755.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:541;
X-Forefront-PRVS: 03484C0ABF
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(346002)(396003)(136003)(39860400002)(366004)(376002)(199004)(2906002)(6512007)(54906003)(110136005)(7416002)(6486002)(53546011)(6506007)(4326008)(16526019)(186003)(316002)(966005)(52116002)(31686004)(66556008)(31696002)(5660300002)(2616005)(478600001)(8676002)(86362001)(66476007)(36756003)(81166006)(81156014)(66574012)(8936002)(66946007);DIR:OUT;SFP:1102;SCL:1;SRVR:MW3PR15MB3755;H:MW3PR15MB3883.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HPpJ2M6bfiKxW9bTZASEVBKJZUpaTZYsReNjI06y9bJxEsyNrYyO3wUdnN0GP34CF3AUMnI6aI3/LJIUcDElAPgdoV9EgUBtIwHYVpiiDuamj9SpENaQfJAYLtVv0D5q1bo428T32NdMvAzhJJM7Kju2Rh4QFcZUBtuHH6jMPfgPvtYltO7KMsnUvb7VL74qf8RF0SnnCPjQ9PlSZhYRSY+IVVEhs2hae/4DGZ3Au2bOT7KuNpKrODxMUDhgpvKHYaCUXDzxhV1SeTUoxdBhR3oqkLBG/2xfyeCBivHeAsmp0WuxpFM9LquvZLQAuFTM6ZOSrNARBI9iwhVwqNXcoePcZkTqkiFiUbq8d15Lwl/2nzNWRgAenpvF3EHXA0zS1RTFnFfk9080+sXIpUstaFtK7wvyYAxjeGI7YqZ/1FeVOCU/PrdzSSHcfI1gOwLqJVu/uL+Hb0QLd+rVY0n3ja2ziu+TLsJM3FvlcmzimUAPNKOwmtAyhDqnOMt3jrFaHK8KWO9pofsnmg1TQ/Jjvw==
X-MS-Exchange-AntiSpam-MessageData: nk/FKXITCRWKwn050VKj1HnP+KfM72J3OzdR+zI5lk1UT1V71IOS7iC+yiNLBGcVNXeO5ninNVj6Nwx9LUevc88qXMCJus+gl5e3bxkXy8IR/I6nY2W50C4uaul7pbf2mojgmGiMFROQlIdEewVApBCDqRcW3mnf5hUZmjO463hr4QI0XNPj50poWMVQ82Zr
X-MS-Exchange-CrossTenant-Network-Message-Id: 458bbe48-851b-4ebf-c218-08d7cce2b710
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2020 15:24:00.3761
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NpODfJUIDsBXiXuUZJP+SsRa20XO733uYB2ElquH7Q5iFQw5u5ySeue/ab+FW0lf
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB3755
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-20_05:2020-03-20,2020-03-20 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 impostorscore=0 spamscore=0 clxscore=1011 suspectscore=0 adultscore=0
 mlxscore=0 phishscore=0 lowpriorityscore=0 malwarescore=0
 priorityscore=1501 mlxlogscore=849 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2003200064
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/20/20 2:48 AM, Greg Kroah-Hartman wrote:
> For the bpf syscall, we are relying on the compiler to properly zero out
> the bpf_attr union that we copy userspace data into.  Unfortunately that
> doesn't always work properly, padding and other oddities might not be
> correctly zeroed, and in some tests odd things have been found when the
> stack is pre-initialized to other values.

Maybe add more contexts about the failure itself so it could be clear
why we need this patch.

As far as I know from the link below, the failure happens in
CHECK_ATTR() which checks any unused *area* for a particular subcommand
must be 0, and this patch tries to provide this guarantee beyond
area beyond min(uattr_size, sizeof(attr)).

> 
> Fix this by explicitly memsetting the structure to 0 before using it.
> 
> Reported-by: Maciej Żenczykowski <maze@google.com>
> Reported-by: John Stultz <john.stultz@linaro.org>
> Reported-by: Alexander Potapenko <glider@google.com>
> Reported-by: Alistair Delva <adelva@google.com>
> Cc: stable <stable@vger.kernel.org>
> Link: https://urldefense.proofpoint.com/v2/url?u=https-3A__android-2Dreview.googlesource.com_c_kernel_common_-2B_1235490&d=DwIDaQ&c=5VD0RTtNlTh3ycd41b3MUw&r=DA8e1B5r073vIqRrFz7MRA&m=LW31qE_U9SQxf_FnwMUaEXeM9h54NJ1fOf44hk_QDWk&s=HJ-aQi8Ho6V6ZegmWlPYJqnY7e3KRKfFjFj6C2yEN04&e=
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Acked-by: Yonghong Song <yhs@fb.com>

> ---
>   kernel/bpf/syscall.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> index a91ad518c050..a4b1de8ea409 100644
> --- a/kernel/bpf/syscall.c
> +++ b/kernel/bpf/syscall.c
> @@ -3354,7 +3354,7 @@ static int bpf_map_do_batch(const union bpf_attr *attr,
>   
>   SYSCALL_DEFINE3(bpf, int, cmd, union bpf_attr __user *, uattr, unsigned int, size)
>   {
> -	union bpf_attr attr = {};
> +	union bpf_attr attr;
>   	int err;
>   
>   	if (sysctl_unprivileged_bpf_disabled && !capable(CAP_SYS_ADMIN))
> @@ -3366,6 +3366,7 @@ SYSCALL_DEFINE3(bpf, int, cmd, union bpf_attr __user *, uattr, unsigned int, siz
>   	size = min_t(u32, size, sizeof(attr));
>   
>   	/* copy attributes from user space, may be less than sizeof(bpf_attr) */
> +	memset(&attr, 0, sizeof(attr));
>   	if (copy_from_user(&attr, uattr, size) != 0)
>   		return -EFAULT;
>   
> 
> base-commit: 6c90b86a745a446717fdf408c4a8a4631a5e8ee3
> 
