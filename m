Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7DF52CF536
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 21:00:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730584AbgLDT7R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 14:59:17 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:21234 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729459AbgLDT7R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 14:59:17 -0500
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B4JnjPq015612;
        Fri, 4 Dec 2020 11:58:16 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=cRkbfXc/ZuM971xXL+FiegGOvguS7QuLwmMH+Sezxj0=;
 b=awGg7HHg9eHrNO4yI/Vhs9PPjeOxEO2hrpKJxxxClrWiOFoJYGTFMTBbWhONr1snRvct
 83xiScVxiFQp7A3ouaNh/tlCWy79aQNimBDGtCQDJDmR0em4GlgH4XV8M7cDWDywpEaW
 2XeRQrIjWfw9cp7iPjTDvLLdv9exr0jxGww= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 357quespyy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 04 Dec 2020 11:58:15 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 4 Dec 2020 11:58:14 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TlspojIKie+0JXB0+3+NZnag0Z4M8A/6cal+mLZzXDhannj6KLIniO/9v117+V892R/EX1m6vDO8yWCVtU5CnZOJyD5n7bQzUOkOnayT68ssgxC+VdZnL8FIkitRnR76zC9Zfk1z8I2+N/vrtWj4NQ/bC9Ihod+QTp2yYsk8n0Wp+xqLEX1cjiG8JnsIZJ4G+heH3U79TRww1cdozVwnSjJ9sisqC1OtUyzM1yYJoVmJShQ/DaTdejWIXACx+KTq8sZ2mjlx3d7OnK62Ztzb9K9K5eFXrQaz/a8eDChZqsu4MegdIMEALUHebQjRm6211Gi9wdf6jodtvVtB0G/CNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cRkbfXc/ZuM971xXL+FiegGOvguS7QuLwmMH+Sezxj0=;
 b=FTMyauaBHHE4jcUudur56Zky2PpFmUQYkCQPE0auHSmlizZ/wnwYrvRFv+MCQDBnogTLyx1yWIhgU5ddzJX68X43S/58tt2ny9WhHksSVG9uEXuc/0hq/157NdOiXdob7yRGS7aA91rvFVSVB6BZsedF8VaGLaCGrgsMJy6shD19jhGQrRNidfadu9GH0TGeMzQkJYCfDOHHOrrYn+HRvJO/20y423vCUCuCi4wmsZhxfmUN+LX2dN9KC5ZCoGtCGIAHTOyMJ1dRJTULYX9dkQ2GGY80uH2RWR+ODGAVLRQ4SuGurll3oQsmnmCu6y+85QTw18P+7bFROu5EEO5PsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cRkbfXc/ZuM971xXL+FiegGOvguS7QuLwmMH+Sezxj0=;
 b=fV+HXm+OuoCLT4gGMDI7nzHgkdSGJc13eWT+Zw/yBQH8HF6NVMG3ovSGz8g+syhk+LhtNvtgVz9YfTecBZONiAj/y+RmxnsWGuoxnWNfTB2EYFZgsJcKFsxc3vrgvn6We89RaYluqAzz2w5LsIi6m34TYWMqT3Ounqxxriddx8k=
Authentication-Results: amazon.co.jp; dkim=none (message not signed)
 header.d=none;amazon.co.jp; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB2950.namprd15.prod.outlook.com (2603:10b6:a03:f6::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.21; Fri, 4 Dec
 2020 19:58:13 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::2831:21bf:8060:a0b]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::2831:21bf:8060:a0b%7]) with mapi id 15.20.3632.021; Fri, 4 Dec 2020
 19:58:13 +0000
Date:   Fri, 4 Dec 2020 11:58:07 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>
CC:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Benjamin Herrenschmidt <benh@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <osa-contribution-log@amazon.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1 bpf-next 09/11] bpf: Support
 bpf_get_socket_cookie_sock() for BPF_PROG_TYPE_SK_REUSEPORT.
Message-ID: <20201204195807.mnckuteadncd4spr@kafai-mbp.dhcp.thefacebook.com>
References: <20201201144418.35045-1-kuniyu@amazon.co.jp>
 <20201201144418.35045-10-kuniyu@amazon.co.jp>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201201144418.35045-10-kuniyu@amazon.co.jp>
X-Originating-IP: [2620:10d:c090:400::5:adde]
X-ClientProxiedBy: MWHPR13CA0046.namprd13.prod.outlook.com
 (2603:10b6:300:95::32) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:adde) by MWHPR13CA0046.namprd13.prod.outlook.com (2603:10b6:300:95::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.7 via Frontend Transport; Fri, 4 Dec 2020 19:58:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a4d641b6-b34b-491e-a33c-08d8988eeef0
X-MS-TrafficTypeDiagnostic: BYAPR15MB2950:
X-Microsoft-Antispam-PRVS: <BYAPR15MB2950FE10B4872B67BE726287D5F10@BYAPR15MB2950.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RhQDy3LkI8LNyUsE9qrQ5HIxN/gOkmF6JjdkjSZf3Tb9z8Fyi4foiokBIFo9FqOm1fQnBAKAEwsdRXSEQiehqoeXmpWbCAKXTbC0SPmtE2ASPhBfoaQ3DjG4mvF+46IzjfuD6Tlf3rtucwoD4PXo7URxh0jSBvHqUO87s9JrVFrGjthO6PSPb3iMqdHRa4mXuuTz22j7wsU7sh0d5CAw6BTBgcOfWHgm/JGXmdJ8+4W3qdevvRqrBvtQ06mhLhW3Md/ONQc1N7XEx1+OWQY16FkrS/5tLBM5yabzFsADNSWuLWt4YyhJPWRtRWxMO4G6rj1LVTisVorDS61pVNy4Auvip8O0BwN3qDeT/7CxPv/ZtzcYd1xKCOMlrMefb/82nR5VsU2ootHnuIyoFFkfnw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(376002)(39860400002)(136003)(366004)(7696005)(83380400001)(6666004)(2906002)(478600001)(8676002)(52116002)(7416002)(8936002)(316002)(6506007)(6916009)(186003)(16526019)(54906003)(1076003)(86362001)(966005)(66556008)(66476007)(5660300002)(55016002)(66946007)(4326008)(9686003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?lyKD1ZkwUdzH6aafPf1oz/mQi70upzne3ZbCC2hj0S15PfT8kQPZQezHT7ID?=
 =?us-ascii?Q?mOejD/qbnvDhjxGVq0FUD1c2UI0KRQPcEj0+vSh8m04sRWo6LFzvIyRQYoji?=
 =?us-ascii?Q?btR4USEZWAJ/oAfxRBbmI+9Uz/s+Ee9Izu/XOrIefFJRhneGiDM9/5Cdpy7E?=
 =?us-ascii?Q?wD4SmzhAIBHnzW1ARXIo7oe7pJ+I0B0BzaaOiQ38HJagxEkLTVs5TPl0sEbk?=
 =?us-ascii?Q?cmwM6RA4yxFMsRpFRLuUAE3IxuMzE3LyfgxNR7AguVejcjB5SrUixhDvhS40?=
 =?us-ascii?Q?7SKq5+kJNebt0J0VJMBtPhHh2t0m2fEPTZydEg1XLDnN5cTn/8iuVN22hEhO?=
 =?us-ascii?Q?WiwVFyiVmK8yEg0m2JedBGQioLjOheqFSUhBMQSHaEIjKgizbsrZQ8Tuqtvx?=
 =?us-ascii?Q?iSTLE4ygVdSb+NruQrrKJzbfhRV1fMg39jMIHcw0U8tjyXpYiqPOBhD2HHe5?=
 =?us-ascii?Q?/h6FQxE5Pf8bsXXAlyBwmKIXJiRgOHgHdHX8BBMrf68byLBmZwYoxyieakiJ?=
 =?us-ascii?Q?GH7TJeNs0if6jT7lWrf+Wmyjpu3MOR+6Tb5SGIKec/p3iPzjlTK0/TXX4P0b?=
 =?us-ascii?Q?VbJwuSy+AkBd2eTdJFNTb26RT3wShz59q5/JjM0JZQlKP5H8GKbuIjEw4d7o?=
 =?us-ascii?Q?7lbAZi8b7aqKWpQNg6iN+9Z/OU/qUEVCG8b2lYMf8uuBV9oOTwqy1q9P8kCj?=
 =?us-ascii?Q?rAqwZQB7oHEEArtsSEENqMnjZWBcMwpZmA9zGi4I49yeGfvIWD3ysiObOdGB?=
 =?us-ascii?Q?veta4Y6CfrwoJoolIpWxwW8ccs5vk54E9TYRoMNtNXDve/paqRsNcqKwXU4m?=
 =?us-ascii?Q?Z1JmEnFR/83/uNUHbdr1+Lq9f0sFbOjlsQKUQ3UQMrjYpNrIgOkePrgnM19L?=
 =?us-ascii?Q?OSIuvVgeTEnH+msDnIbX5iqmUIca8TXElakOhpM9k2FJ71EPbsgITkyu/Llu?=
 =?us-ascii?Q?SoAu5m0tz5tmru9rqPCxdqPndSY5sIDvBIk8Fs/eCmiicjtf4AZ9qem5VnNi?=
 =?us-ascii?Q?cbJz2L+w5HhEKFfsfue2qbFFIw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a4d641b6-b34b-491e-a33c-08d8988eeef0
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Dec 2020 19:58:13.5650
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lHzaAgupYyVdp3J48f6J0lcPDHoW0qu86WK/mXIbUiZckzM9LXYBXJvjFOQ6vjss
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2950
X-OriginatorOrg: fb.com
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-04_09:2020-12-04,2020-12-04 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0 spamscore=0
 suspectscore=0 impostorscore=0 clxscore=1015 lowpriorityscore=0
 priorityscore=1501 phishscore=0 malwarescore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012040114
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 01, 2020 at 11:44:16PM +0900, Kuniyuki Iwashima wrote:
> We will call sock_reuseport.prog for socket migration in the next commit,
> so the eBPF program has to know which listener is closing in order to
> select the new listener.
> 
> Currently, we can get a unique ID for each listener in the userspace by
> calling bpf_map_lookup_elem() for BPF_MAP_TYPE_REUSEPORT_SOCKARRAY map.
> 
> This patch makes the sk pointer available in sk_reuseport_md so that we can
> get the ID by BPF_FUNC_get_socket_cookie() in the eBPF program.
> 
> Link: https://lore.kernel.org/netdev/20201119001154.kapwihc2plp4f7zc@kafai-mbp.dhcp.thefacebook.com/
> Suggested-by: Martin KaFai Lau <kafai@fb.com>
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
> ---
>  include/uapi/linux/bpf.h       |  8 ++++++++
>  net/core/filter.c              | 12 +++++++++++-
>  tools/include/uapi/linux/bpf.h |  8 ++++++++
>  3 files changed, 27 insertions(+), 1 deletion(-)
> 
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index efe342bf3dbc..3e9b8bd42b4e 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -1650,6 +1650,13 @@ union bpf_attr {
>   * 		A 8-byte long non-decreasing number on success, or 0 if the
>   * 		socket field is missing inside *skb*.
>   *
> + * u64 bpf_get_socket_cookie(struct bpf_sock *sk)
> + * 	Description
> + * 		Equivalent to bpf_get_socket_cookie() helper that accepts
> + * 		*skb*, but gets socket from **struct bpf_sock** context.
> + * 	Return
> + * 		A 8-byte long non-decreasing number.
> + *
>   * u64 bpf_get_socket_cookie(struct bpf_sock_addr *ctx)
>   * 	Description
>   * 		Equivalent to bpf_get_socket_cookie() helper that accepts
> @@ -4420,6 +4427,7 @@ struct sk_reuseport_md {
>  	__u32 bind_inany;	/* Is sock bound to an INANY address? */
>  	__u32 hash;		/* A hash of the packet 4 tuples */
>  	__u8 migration;		/* Migration type */
> +	__bpf_md_ptr(struct bpf_sock *, sk); /* current listening socket */
>  };
>  
>  #define BPF_TAG_SIZE	8
> diff --git a/net/core/filter.c b/net/core/filter.c
> index 0a0634787bb4..1059d31847ef 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -4628,7 +4628,7 @@ static const struct bpf_func_proto bpf_get_socket_cookie_sock_proto = {
>  	.func		= bpf_get_socket_cookie_sock,
>  	.gpl_only	= false,
>  	.ret_type	= RET_INTEGER,
> -	.arg1_type	= ARG_PTR_TO_CTX,
> +	.arg1_type	= ARG_PTR_TO_SOCKET,
This will break existing bpf prog (BPF_PROG_TYPE_CGROUP_SOCK)
using this proto.  A new proto is needed and there is
an on-going patch doing this [0].

[0]: https://lore.kernel.org/bpf/20201203213330.1657666-1-revest@google.com/
