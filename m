Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E162E43BC7B
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 23:35:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239661AbhJZVhu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 17:37:50 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:23728 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239651AbhJZVht (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 17:37:49 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19QFWuGh022644;
        Tue, 26 Oct 2021 14:35:08 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=2sHGI1DHz3xYH3yaOBUI+Hc+iMShl+gVHmXN6wwT+uA=;
 b=nR0FuJIzNSnhhCwjEQevjRWT8/Z8gwD8Egp+U6Amt5yi5MTKVHusFPS1YW8l30n7F8Oa
 MBUpbsCpjqUlKl+ZTOR4sVrUqjXdEEBMUc/6eLxq7J6v1GKM7ansbYlYooaBDgobCgr6
 fZhnUeNnNh+d1R4OoQ1ZSfsKzUpJRULHjEA= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3bxkkcb6sh-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 26 Oct 2021 14:35:07 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Tue, 26 Oct 2021 14:35:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A23yJ0ZLDSxp0cX7UxysAKLv5DORdsD5hdrb1JrKvQUl84UvwOyUGm1xCrunDx/HmPR5sZxV02zomCUCZfmzMnimSgwiAT86VByDrb2efNd4M4ZXY/nkwQuthyDxqEdlAWC6QKW672RrN00O00R6vUfafWFF9Ki6Ls3U3JrFn89tbdKYYFViKv+oiVmsXuDeg3P1dZE0BH/bLvGFJgk83p0Rc/BlgCrft0mXZDkcUbN/Gv98Uq6Ngf3tbZVawFEBAREGMADTzVfUVmPJ1efSL3dobp4n6Yn9adfJ/w5aKj9+Ge6qZ0DRRJ7djAj6+QsrA4SP72YG4CbHCCcMT6qXJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2sHGI1DHz3xYH3yaOBUI+Hc+iMShl+gVHmXN6wwT+uA=;
 b=CqbKbXYhjHTplKlduA2hRH/H4pYbWnKI5vVkaBg2yxtkGyFpyXkhRr43Wx5dTYWBrCPCYqPMgxhj7u7wjLIAoEOOTonf58kZ9Ml9YJZH/vQviA6HPYGYSjxuM+m111BDivFLCtGoLK1fhOqDhFcSrB8OF2C4NELEEG7/JZHyxQiNpmacPCr0ldM90H8PB53PrHEkKN7IZVpY/8y5o6cumvsNBZOEblonuTGTJiusZ7lz9e2xTNla3gO5m/IhzaQ6m1SdXRtYBdehKKl5R5U5GthMBzmXtYPRsVjOQMYWVu4QTtwmDChuOBGnlrmIFIVK6kk+vpvRNQ3gZMHTP5u1bQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=fb.com;
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by SN6PR15MB4269.namprd15.prod.outlook.com (2603:10b6:805:eb::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16; Tue, 26 Oct
 2021 21:35:06 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::6c34:bcb:51af:6160]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::6c34:bcb:51af:6160%7]) with mapi id 15.20.4628.020; Tue, 26 Oct 2021
 21:35:05 +0000
Date:   Tue, 26 Oct 2021 14:35:02 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Hou Tao <houtao1@huawei.com>
CC:     Alexei Starovoitov <ast@kernel.org>, Yonghong Song <yhs@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next] bpf: bpf_log() clean-up for kernel log output
Message-ID: <20211026213502.s5arrmvh42tbymvv@kafai-mbp.dhcp.thefacebook.com>
References: <20211026133819.4138245-1-houtao1@huawei.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20211026133819.4138245-1-houtao1@huawei.com>
X-ClientProxiedBy: MWHPR12CA0068.namprd12.prod.outlook.com
 (2603:10b6:300:103::30) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:8034) by MWHPR12CA0068.namprd12.prod.outlook.com (2603:10b6:300:103::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.14 via Frontend Transport; Tue, 26 Oct 2021 21:35:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5fb90d69-33ab-4ba2-9740-08d998c879df
X-MS-TrafficTypeDiagnostic: SN6PR15MB4269:
X-Microsoft-Antispam-PRVS: <SN6PR15MB4269EAB790B9DF16DC30E4B9D5849@SN6PR15MB4269.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:2958;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UBKKlrvvDuIJwUhofAY2Iu1/QAxZKoY8OndGm5xuIwvmpUhix4IAqHIHWoL5/gqQW9DfkiGYXc1K3zcb/8oSiqeARqvukRKUaK2pAoRxJYfSvKZIHH4Rqa1ySWTYTRNNb6kcpqtGr7XHHIsXpQ3+UetF7VLfh7dPIRYkAkOCgTAfUuBFCuNMoUvVP2ZwP1mv0bodJp0RfURUjRwuSn5PCzWQOnYKKMbsOKb50GbNpTOzJaR0UWLDAQuyJScgWVKWr8TPPUwnTOdLNVLA4yQKKUyGJ807JYpD1rFZcUdlfmedjqXJCA3PyUCBo8RVcKux93XYmuHHhtTW0V7Fz34ug7ohltQEV7EQdSiZ6NBDaMEFn175G+tLv4M+uD7/uL3AmNolhRjyMTE6Jq76Yn9LJHWjXgGf4qxlNrripPSv2aOKzbmdziXRjVq4PQWU+m336q2IWtOs6KTU773T9hNhReS69LPkTHqBE0L0zdZLt0qX6IHD2vB+Q7Q6vXlD62hpAeHBubnsQ2jHkVrW5atz3Ez3fcrOdQbphLJf+jcOrSZRz2LGONH+pLX9KGPd//BpNZd3ppd6rKwz5mwufZ/EoyPrtb6oInlnBP3RskbqC8TCu4DGg9NFyafE4MrZ7JCaDM7SZacquxAMhQcKpeVklg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8676002)(66946007)(66476007)(66556008)(52116002)(6916009)(54906003)(7696005)(316002)(8936002)(186003)(83380400001)(9686003)(38100700002)(1076003)(4326008)(2906002)(86362001)(55016002)(6506007)(508600001)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?61iWNj3WG41Peh8CFJoVmEoy93pbvmhrTiupgvgLoJ0rBU6zi+GOfxK+S+WE?=
 =?us-ascii?Q?ouaBCIrCAmjpsRIkQd7t9gq2P/BTdfPMmPFLynTt1wdGBkHafgdk79RWMUwM?=
 =?us-ascii?Q?hD6qT3DS9WEqvrd6CLruUt2HFSnMK+t0AYlg9zeKUe00UxlqmTwqnBahNeHP?=
 =?us-ascii?Q?6GLWmvKVkWJVolueUpbC1RJOTLiWTqtmd1XjRdjDctJeGCa8rasURnHLk2UN?=
 =?us-ascii?Q?rq0VEfuPcYx8DWp6mGbUs4EfkEfXKhWe6PbGvU3i6aQSoSgoNPsjJSFx70GD?=
 =?us-ascii?Q?zkxIzpqqnYUg7hOl//+QWVaEVn/LT/77zOuejYVkAMAfllwsudAe5Q7BcwVZ?=
 =?us-ascii?Q?RXR81E8eRlwwKfhCwGk8GP32IX54FH7ob/VTs1saeR/0RUR/Vh4qKwQJQD+7?=
 =?us-ascii?Q?AK0zqNPKBC3Fi0dNBNNreSZ/Do4fdvqhWP9Fw7DnjYiLyvPDjL5eXOt3LsVo?=
 =?us-ascii?Q?vArUqzfHbMgwKDXLz1Jx640UUKKYA/2P+6r9/BKd2TU3mZCkPBsIQxGnfx9o?=
 =?us-ascii?Q?urIdk5tZIf58EJWcCOkNTuAsqexzyrMRj/WMEiEPGyG3TZ1EBCKR/g+1PrBD?=
 =?us-ascii?Q?tjxeYtszxOAVwYT4IpXW6JYOmQ2A8TYwkOA3rQHqCAZBiv50Pacj/n2nt3tC?=
 =?us-ascii?Q?Cu0ShRxrA6gpbZk/OCz3kub3ZdpEWA92L1pM7d6K87xOc7wb3tJrEDaDjh7K?=
 =?us-ascii?Q?fxVjUdkMCvxNUUm+mzsgsb+qidJqh+GUwmIkSo2hj35j7v4qzGNYXVal+gZg?=
 =?us-ascii?Q?qLPg4SaeS27Gj3gyjde/+oUwPmQ/Ktk5SUFioNmokXNDcLD8kbQMDZhSIwxP?=
 =?us-ascii?Q?bPM4yvZHWgBn/Amz4W0dVATYQC6IsddkO7Q1HJ2iyg6mQHn/8aBU6N8LXsPM?=
 =?us-ascii?Q?gm9yM+KfgiMfHeDvjFS1KWYnWlSytXoS+kQ8Y9tKfF1DgQITZ+4IdEgjJjqC?=
 =?us-ascii?Q?X2eHwyNonW6z/YzOGJIUL1drXPhCw5PLFhPN2lyKZMG2MRYboUd+JZ+aHUBI?=
 =?us-ascii?Q?cis2RAzFXknUQXI8Vf+6yvXYMJGsaDfC27F/sZ65BgPh7D/OvtY3wSL2QWdE?=
 =?us-ascii?Q?h1FRFbbgYASS2x19yo1z2m3hiUgWBoixges6aQa4fgAySjIyiAXnIWgyCd1U?=
 =?us-ascii?Q?9bHorMsXXMtkweaSsH6AE+wxOx6V+op8sdBTdJH7NxlZTXwkVkA9l5+cdM4i?=
 =?us-ascii?Q?M5XK5Oeb4EuU+qHdD8KVVs0J5vWeZ7WOI/FruvJimT8hZdU0MEAUE98eSAdl?=
 =?us-ascii?Q?JHZadkukBLWuy9soPqlX0jCBRMH44h+CDd2VXd4H9A8mBSl1IFo4zzFrLSV4?=
 =?us-ascii?Q?VnyO+iY5Xdd79etRxN6qaJYdFpdnroc4w7tElc/McYeQEhAyuBeBeXKy6hAR?=
 =?us-ascii?Q?/sGN8wR06jii/UQgIG6iwmfnZmLg694oC/acx9X3NUdP7xgFNj/6HPkME0uK?=
 =?us-ascii?Q?NN7stm5aXHaCHPqYhGbW8pzbw6ezaE0fyJjQ00ZCRST0cIL5crfPfzw06POR?=
 =?us-ascii?Q?tT5Ff/GQodrOPCB/WubTRkggl2+GekOaKSokE4iXJgZtvky2jNOrrcnMu31o?=
 =?us-ascii?Q?ZkYLBufYfKGnb29divvbSrPkF0POyRf0vkGBpdJO?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5fb90d69-33ab-4ba2-9740-08d998c879df
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2021 21:35:05.6995
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6/IffTDXHaxp0JLvOhWZCtf0CBGn7kjmW9RAT48L+4guk34pVJh7Mnvc4PBCvn4L
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR15MB4269
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: wcveJcgHDRHr7eq3Gz31Q8fo5ccJf7Ss
X-Proofpoint-GUID: wcveJcgHDRHr7eq3Gz31Q8fo5ccJf7Ss
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-26_06,2021-10-26_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 malwarescore=0 mlxscore=0 suspectscore=0 spamscore=0 clxscore=1015
 phishscore=0 lowpriorityscore=0 priorityscore=1501 adultscore=0
 mlxlogscore=999 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2110150000 definitions=main-2110260117
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 26, 2021 at 09:38:19PM +0800, Hou Tao wrote:
> An extra newline will output for bpf_log() with BPF_LOG_KERNEL level
> as shown below:
> 
> [   52.095704] BPF:The function test_3 has 12 arguments. Too many.
> [   52.095704]
> [   52.096896] Error in parsing func ptr test_3 in struct bpf_dummy_ops
> 
> Now all bpf_log() are ended by newline, so just remove the extra newline.
bpf_verifier_vlog is also called by btf_verifier_log.
Not all of them is ended with newline.

> 
> Also there is no need to calculate the left userspace buffer size
> for kernel log output and to truncate the output by '\0' which
> has already been done by vscnprintf(), so only do these for
> userspace log output.
> 
> Signed-off-by: Hou Tao <houtao1@huawei.com>
> ---
>  kernel/bpf/verifier.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index c6616e325803..7d4a313da86e 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -299,13 +299,13 @@ void bpf_verifier_vlog(struct bpf_verifier_log *log, const char *fmt,
>  	WARN_ONCE(n >= BPF_VERIFIER_TMP_LOG_SIZE - 1,
>  		  "verifier log line truncated - local buffer too short\n");
>  
> -	n = min(log->len_total - log->len_used - 1, n);
> -	log->kbuf[n] = '\0';
> -
>  	if (log->level == BPF_LOG_KERNEL) {
> -		pr_err("BPF:%s\n", log->kbuf);
> +		pr_err("BPF:%s", log->kbuf);
How about trim the tailing '\n' (if any) from kbuf?
or just test if kbuf is ended with '\n'?

>  		return;
>  	}
> +
> +	n = min(log->len_total - log->len_used - 1, n);
> +	log->kbuf[n] = '\0';
>  	if (!copy_to_user(log->ubuf + log->len_used, log->kbuf, n + 1))
>  		log->len_used += n;
>  	else
> -- 
> 2.29.2
> 
