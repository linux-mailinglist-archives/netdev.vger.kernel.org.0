Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DB9E22492B
	for <lists+netdev@lfdr.de>; Sat, 18 Jul 2020 08:00:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726888AbgGRGAw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jul 2020 02:00:52 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:56342 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725920AbgGRGAv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jul 2020 02:00:51 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06I5wve7009735;
        Fri, 17 Jul 2020 23:00:34 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=muwaErU2+Q0d75UM6WA9YQvwQ3htnvQ1L+0WwpvLWr4=;
 b=px2qUNzkrrfFy+NhSdfQemnhIa/hFNzDYWt9bktfUuaB2W1E6OqnHN2Fp1Fa3wDjb9Yz
 F5oz5M6oc5sKPoufVL8I/DkD4JoG5IiO/EJAi88dUz/55yJtVrbaBVI2jv6zYNjYBJ3m
 IsoqyKGNvdHmM1u5gt1dSAkNfV0iWrBcadU= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 32ax1veq6g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 17 Jul 2020 23:00:34 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 17 Jul 2020 23:00:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eSocK4PS8ZmIcOjZIEpbuZHyeFcTXS/COhy57k/VldTqW0h/n/TDIIBDegnmG151dv2oEsb+nj3Bhw3KppXMyVDu1s/kLtKjS2p4kZ+sSn7Gi9csCuzLNNvuW9VLT0mZjjlbxzferRy/Didvl/AgCW1/YW8k1vNttMdMtjSVaVrqroq7y0SYb0TldZOuP8JhUno5XJxbPQbUvu5DbXdwV5QzQP7Od9hxiirFSfOwJLRmOjZnkAevEd/9H8qBKLyUvL8jNyNQjc1ynviaiXMXXJPH30L0jLAxQCV0pR8vQMOZJ5xM6leYHxa06eept/ZBNFz2CoIjz0rqemBCtZGmaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=muwaErU2+Q0d75UM6WA9YQvwQ3htnvQ1L+0WwpvLWr4=;
 b=LerXc6z9x+Z3wTYSbP7eeUe828D6SERhVfaEfQgPgkt3myfyYNuWWYLBcthDZPrG3njy9lRiuRUKzgYnSL4nRhdVL3SH3cdpkbh92XrS61PQonxCe0TKETEy/tZttgmWxjAF8/ZcwzrwtdiDoQPMO+Hc2vKzulaq+aTZsxs0N7cHMX+7XP+ixzOtq1ADVamqh6zg0hkxL7BdXuUQLC7p9IqiQkceT0REA4YKhCCH0GtzfdAJjSKD60W6YJ2TT2cJIMPizxAdd28Yz7RjwHL3cZ4Kndfg70NEwRibiNS1Y1ReztgRWxVBUD29rMRKM2xN21EaAFy9YMU2ahoZ1dffOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=muwaErU2+Q0d75UM6WA9YQvwQ3htnvQ1L+0WwpvLWr4=;
 b=QmXITM4Q+gOQRj+RAvTtccUfZqTTELFV19KX+nyw96DSh9L2ViNz+154ZsB+MLKaZDcfEKjfNkVaW7enlyuW+aE2aCmbPwaQrmGKiXm6G2AYYtiZBgo1+aom7IHWXSorCbPAXt/lTQHCKF6wDJ3VPa/gazmhg43YOHUuY7zhbmY=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2566.namprd15.prod.outlook.com (2603:10b6:a03:150::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.17; Sat, 18 Jul
 2020 06:00:31 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80%7]) with mapi id 15.20.3174.026; Sat, 18 Jul 2020
 06:00:31 +0000
Subject: Re: [PATCH] libbpf bpf_helpers: Use __builtin_offsetof for offsetof
 if available
To:     Ian Rogers <irogers@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     Stanislav Fomichev <sdf@google.com>
References: <20200717072319.101302-1-irogers@google.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <a0a26308-a1d7-a57c-727c-000652a5d246@fb.com>
Date:   Fri, 17 Jul 2020 23:00:29 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.10.0
In-Reply-To: <20200717072319.101302-1-irogers@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR01CA0015.prod.exchangelabs.com (2603:10b6:a02:80::28)
 To BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21cf::1160] (2620:10d:c090:400::5:6f2d) by BYAPR01CA0015.prod.exchangelabs.com (2603:10b6:a02:80::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.18 via Frontend Transport; Sat, 18 Jul 2020 06:00:30 +0000
X-Originating-IP: [2620:10d:c090:400::5:6f2d]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6a786fff-1278-466b-512f-08d82adfe0dd
X-MS-TrafficTypeDiagnostic: BYAPR15MB2566:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB2566EF3329EE239D73143F0BD37D0@BYAPR15MB2566.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: G3JmIS1yLx+reOx+c7BOSXW6/MS2bh6GMo3eyRAb/Va0E0tWl8E7Yg4tyNCE+6dISxbiEWm2TL4c5LOkxOT9A1ahfGGDcQk6H+ENxvH/w0m8dlOA3hSMrSRAhm95DmSj2wIAnLQdbYbojrBD44E+HwDWvJwZLw6KNd8ijjzwLLKL+T16iFPNvhti1c8IIZCZNcYwxi+keW91KQ9aGv0dqlBFpe632JHuYFa68qGl53FLMXe7H6aEWB/yy8oDL3hF9olijCKypOncjORREfyTgg+2uX5OQd9AEDZLsC73VhnSPcww/f/yHpG25fXl+kYwpPIdpT3DL0nKbmGqXBeKypQ7KphoQe+U19yDDRXgsML7HuhbN+DT2IeSQ/CdDOZuN7MJuAX3IIXvm6p4Ry5F3g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(396003)(346002)(366004)(136003)(39860400002)(376002)(4326008)(2616005)(16526019)(8936002)(31696002)(31686004)(66946007)(66476007)(5660300002)(66556008)(478600001)(52116002)(316002)(2906002)(53546011)(36756003)(86362001)(8676002)(110136005)(186003)(6486002)(921003)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: OloaASI/Utwq52ta5oApyk+M7vmhLuH5idotBys0rCTWofDE7Xtsj4NfuPdIwMpvggzj5nu4IwpmLFBo7DAScrhZubGz6UqmtwCP6Ky2n1yIa2yCYaBPXAvvPwpQY4ZRPyqX1KJnfjCrsawqohGCOT0zo/+RJBZHI0JM5prfmIRL+IlKQVReAz2fAH3nDTBDDmNgVSOMm3TzMjkMMR0omMp9rIGhlMWO6QkrsWmEnpUf1hQd4gMfeOc4dAJ6TN2/CHbcB+YUOh+AJbVUriuE5kbHcN6ZsH4Ck0dM+7EEUX4+/RiH3clZjNJGFDXcjFCf6ZL95yRsrQGJ+Ogr1DNl5WuGkBozWWnbgbeYLUkkvolz6s7wEVc6U+/LUsaZ/pOFhZC/HYyncEkakAJyrcf7MSSS3NLNtq259ouNw0ywE44kZjdkDfCzsUeUBg7XUsb7SAHLEvfPx0+87nVQfQ267o3raq5SXkg25DJ5pC9slzN30QVE6xE1/jhTM70fJyiwPf4jbe1kVFBotO61GnDakQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a786fff-1278-466b-512f-08d82adfe0dd
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2020 06:00:31.7246
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tK/j2toB1494yxSXW/1sWTfgY8fsaLaRzxNuzGOcDC3P6hvA6ECyEX5hgMvFIT/U
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2566
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-18_01:2020-07-17,2020-07-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 clxscore=1011 impostorscore=0 suspectscore=0 spamscore=0 mlxlogscore=999
 lowpriorityscore=0 bulkscore=0 phishscore=0 malwarescore=0 mlxscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007180043
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/17/20 12:23 AM, Ian Rogers wrote:
> The non-builtin route for offsetof has a dependency on size_t from
> stdlib.h/stdint.h that is undeclared and may break targets.
> The offsetof macro in bpf_helpers may disable the same macro in other
> headers that have a #ifdef offsetof guard. Rather than add additional
> dependencies improve the offsetof macro declared here to use the
> builtin if available.
> 
> Signed-off-by: Ian Rogers <irogers@google.com>

Thanks. I didn't pay attention to __builtin_offsetof() and clearly
it is preferred. Ack the change with a nit below.

Acked-by: Yonghong Song <yhs@fb.com>

> ---
>   tools/lib/bpf/bpf_helpers.h | 4 ++++
>   1 file changed, 4 insertions(+)
> 
> diff --git a/tools/lib/bpf/bpf_helpers.h b/tools/lib/bpf/bpf_helpers.h
> index a510d8ed716f..ed2ac74fc515 100644
> --- a/tools/lib/bpf/bpf_helpers.h
> +++ b/tools/lib/bpf/bpf_helpers.h
> @@ -40,8 +40,12 @@
>    * Helper macro to manipulate data structures
>    */
>   #ifndef offsetof
> +#if __has_builtin(__builtin_offsetof)
> +#define offsetof(TYPE, MEMBER)  __builtin_offsetof(TYPE, MEMBER)

The __builtin_offsetof is actually available at least since llvm 3.7,
so it is safe to use it always.

> +#else
>   #define offsetof(TYPE, MEMBER)  ((size_t)&((TYPE *)0)->MEMBER)
>   #endif
> +#endif
>   #ifndef container_of
>   #define container_of(ptr, type, member)				\
>   	({							\
> 
