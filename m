Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45F623E19D9
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 18:54:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234746AbhHEQyR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 12:54:17 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:25860 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234218AbhHEQyQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Aug 2021 12:54:16 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 175GnvUW004260;
        Thu, 5 Aug 2021 09:53:46 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=Jd8gtcPvZDRDgqtwXfnL42nVLJr+cRaxQCQRxISS93c=;
 b=ETzn7l5bVVbisYGCoap6EAXphED7I7AtFins+jXqPBSQ4swFOuW34atP6igMKX0F3pIJ
 00DHZtt48BvvtDupO9nkIdPWvu0AKpzDEQzy5Dexxwekl4lF0pbg2Lw7gCv0+EKyLk7M
 /SEtgBfvOQVhadhYzHvwUuEKlVH9kQn+E1g= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3a8jha8m9b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 05 Aug 2021 09:53:45 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 5 Aug 2021 09:53:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KfM7BBTzqDvGvdxv5jID2GFxa1V8MGSCr1veuHzW85C4Gx5YJzajsxu2UexPce+PkT1LPj/hgblSDLDEZ7v3JcCSX8eW6b4Yx2RvuOaaevzTOvc9gg/YKJ5YDoYno4DxIoBkCyHUd/Ya7N0WzcET3/rMc0dZSX0A4hlay6j8ZmJOuJarfmDcdbfRKvNaW826ljGKdW/R5mleQoRFJWh94MxdG+lt/JdYPPB9juNRl9ik153MKkbASXlRXuL7yQVkTLPt15P5/mvWSI5/MjGmHZcbYlVY0aSXL+Y64UlAAl/boDqr22NC6J3WGEmmrXREnSybY3Gj8eJB1T0FzB8ZXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jd8gtcPvZDRDgqtwXfnL42nVLJr+cRaxQCQRxISS93c=;
 b=aXSAN2zzCUxtUBdXzG1VsG7Xk2p23V9Xt1V+nWbjTC3cfS3lC1AjmTNVJMILYB2zJQA0b0Jm5kOFxCbfzT77x+UjkjG2wgsvYI8BG4FykukSlu2yODRAPnfGcIudFXyrTC9Xjj822QurftgxaRCBdx+XF6VP/RaF9fHsDcFvd1XZKamFPic3wz8YxyXcSmp8LPla/ztML5BK83iwFSBEalN/3sjxw0zfo1WpkdoSOQWApAHP/a1uiCKMwM4eu2Q9ZlhS99t+vMnNyuuVFEmYSv2d1hoaPRwi3dmLirXv6ECPDnW1hUqun72q/Rf7bQ3Ut7RG71Lvv0TyCy2fP6to6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA1PR15MB4872.namprd15.prod.outlook.com (2603:10b6:806:1d3::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.21; Thu, 5 Aug
 2021 16:53:43 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::c143:fac2:85b4:14cb]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::c143:fac2:85b4:14cb%7]) with mapi id 15.20.4394.017; Thu, 5 Aug 2021
 16:53:42 +0000
Subject: Re: [PATCH v3 bpf-next 1/2] bpf: af_unix: Implement BPF iterator for
 UNIX domain socket.
To:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>
CC:     Benjamin Herrenschmidt <benh@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>
References: <20210804070851.97834-1-kuniyu@amazon.co.jp>
 <20210804070851.97834-2-kuniyu@amazon.co.jp>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <442b59b1-f7db-6bce-8fd8-d411ddec0956@fb.com>
Date:   Thu, 5 Aug 2021 09:53:40 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
In-Reply-To: <20210804070851.97834-2-kuniyu@amazon.co.jp>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0138.namprd03.prod.outlook.com
 (2603:10b6:a03:33c::23) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21e8::13bf] (2620:10d:c090:400::5:9ce) by SJ0PR03CA0138.namprd03.prod.outlook.com (2603:10b6:a03:33c::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15 via Frontend Transport; Thu, 5 Aug 2021 16:53:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f673b74f-f010-4c70-2120-08d958319509
X-MS-TrafficTypeDiagnostic: SA1PR15MB4872:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA1PR15MB487251EBB742F0DD88EAE1EBD3F29@SA1PR15MB4872.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:1284;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BpiKz3BSFuLunOXYJiVykHBbqcdP8tvIPubDb9KDovU1sqGi+UyPzBpD9DvXkTOz/6iZzIdTBEa4BigCFkFxs8GLEEXkocQTUQYCH1FRixmxnMlRmgx0/w1q43JfUAJx7UjFhLZjKrhHxjbHVpBwt/JJ+6RGh+J/g+jtAs4LmbNrkG1skrLt6Y8V1SOPM4cnnFVzr8HBqDQ3fPuN1l1xVI1KuHsgCCvgjCvTiI8XfjO8wQ99JUruPHl6OnGc2kZ+Izw/0grdiT+/Sq0zgDgibXF1n9ZKrki4ZBoynyM8M6M4/mV8hfefAVhBsqZpTMjmRSV9UrRJQNkz5QiBkS/rwmSM5VKxjCHmlS/ZOThh7xZ9ZQJ5T1Pbz83pFhy2JEciA2NoCSbh7Sh+MDnFTUNf8b0VyZfY6v3H4PU7ChnPCtbQdahEA8GQX/mAiY85j35XzDQCG6j1lxTdBSq2gpXgj6nndbjFs/sSELwB4yiYQ8euH6g2S/MuZK5omDfnttGoI/vfErX2neEOIl1in5ur3+IGmQ4yVK9kH0TCjXszOkGfygS0GJoYW9RUcpWjzmuRTlAHbcE3goAn3u0djnlF4Y983WOGlQdt1wV4+FF8LPbbT0QOpWdls4FbdhOPnzrgWhGZ3D8vIwoNDCx6NSBn78PBzA2JSaUt4t+voj3ADohELWgD+CIDAKcB+rN7nxCRMJsw+EpSzhxWMSSLTAsdJ1EOIT5TD2yzq928+pgzUp4fb1ROdyDBZLTt+l2XGiWJ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(7416002)(316002)(52116002)(5660300002)(38100700002)(2906002)(54906003)(6486002)(508600001)(110136005)(53546011)(2616005)(31686004)(4326008)(8676002)(66946007)(186003)(8936002)(86362001)(66556008)(66476007)(31696002)(83380400001)(36756003)(921005)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TGVnSkx5M003aUZaVVRGZTJWY0sybEk0Mjg3bjhlaDB5RjZOeUw5eXRLK2du?=
 =?utf-8?B?d1BqMkxzbmJIemhqc0w5NG00bHMwemRITWVENFMwRWt6M2tsQlBiVjRSUlZL?=
 =?utf-8?B?YVBEZWt6ZUJnWElKYWFSUkhBOTUyZzZTRFVqVitzYkg1VFo2K2gzeWo3TDBo?=
 =?utf-8?B?UEVMOHljNksvblJWU2h5SUptY21KbFNJS1FjQjhHWUNYTnZmR1hVdGtxcTBh?=
 =?utf-8?B?VW1tNkxZcEtyQjUyUTZ5WXdOQThRRmZWT1JtVktJN3M1MjBSVUZMSHU5UHNZ?=
 =?utf-8?B?dFY4UGlsM0hvQTd5MERwckZVZ0ZnU2JPMnVzNkxxZ3BJdUpKTWQxaWRZSFFx?=
 =?utf-8?B?Z2VBTm1adHlkMVpxNTNKNWd2VjdPck52STJwWHBYTk02Qncvb00rOWVqZFFH?=
 =?utf-8?B?WGFadXNJQmhrRFVZeXNHYVlXdlJKQUFlNWV2NTYzS0pTK3J2QkpNd0ZocFZI?=
 =?utf-8?B?YnRQbFkxNzY5RGtOQS9YY1lZOVM3M2JOZm5yb3hLZy9GK2JJUGtObmJkZ3dl?=
 =?utf-8?B?WEI1elRlY2lUL1RGSkFXbkJNdGRBaG5Ua3hjK2dSWGhTSVozalFkbHdZYlB5?=
 =?utf-8?B?MEErMnJVSFlITHBWUGVXMnFWTi9KTTFXdHR5MlNFQUk4VmtTbGg5cVRwRW1G?=
 =?utf-8?B?TFpHRUQzZmI0N1BXUW9wV3N0TE5NTmNsL0loM0RyZjhzV2c4a3hQd1kyaXBn?=
 =?utf-8?B?VFArYjVVc3JnTW4vMUo3R3NOdjEyMlMzY2V1VExTNXNldERKMlFadG1ITnNj?=
 =?utf-8?B?NFo4MUFGRE9GR25zZ3cxbEpTZ08yZjBwelBmN2xTM0lIdmt3TEh0a0p0amwy?=
 =?utf-8?B?V1FheU9Ka1J0czNnMm8zVDgxcVYwWGJCazVKUWdnckVkNFhyYS8yRjlYOUtp?=
 =?utf-8?B?MnZ1WEh5eGpnMjU2cU5jSkgxTEJXNlozbkFwZURueGdJd2JENnJNa0N5Wlgy?=
 =?utf-8?B?dyt0T2hQaUlLVnZmRTRnM0M1VU5BR0NJNktua3BuZ1hqK0wwc0hoS1RMZVN0?=
 =?utf-8?B?RGEzZ1AwaHFaMFZMeDg3U0RTaWF4SVY4bDRNQkkvZTRDS0ZDTzRGR1RkdUFl?=
 =?utf-8?B?clBrRTZQbVJ1SW5JTnVvQ0VXaUZSRllTd3VFa09mbDhObDJFNHlMeUU0K1hR?=
 =?utf-8?B?ZW52WGxKNzlIdzI2OTRqQVpiMnp6MVJKWEhZZjhWWlJRbTVqRjZ4ZUJ4SDIz?=
 =?utf-8?B?cGxtVUFWRCs3SkhvWVM5a0tmNW5jaXpIMGFrQnZZMVJxT1pjUUFIZmFiQmUx?=
 =?utf-8?B?RFAwVGtHVERYNU5JMjlyNWJmTlZIUmJDNkxuQ0c2RU1PVldscy9GdlcyTUp3?=
 =?utf-8?B?RmN4U2tJTlBmU3g4K3BCcHN4SnBSVUQ1Wlg4N1M1UjJZZWMxQnhWWVJmLzY0?=
 =?utf-8?B?YUJyL1M3SVVFWkpia1Q1eUJXajlGS0dXbkE0NTVhRGVyenlwbFZkZmVNbVBN?=
 =?utf-8?B?bG1tMTdOejIwV0hwcmtTZlJiUGhtYSthTEZISVBtMTFFNkNJOEVEUVdTejg1?=
 =?utf-8?B?ZDVIUlNiaUZqUjUyYmVnOFFvV3NFUmxDaGF5VWtTOVNoVG5HRzN4dWsvMXBK?=
 =?utf-8?B?aFRoc0FTWlpmeVpjOGd6WEZycE5RZWI0K1pkM2xZVGo3SjJwOHhvYVdtellR?=
 =?utf-8?B?ckUvTnQ0RG4yTmMxd09NbHBTVTZZVXhNME9tbzFEblM2Q0dneTd1WlJRWVQv?=
 =?utf-8?B?Tk5WUG1JUWJobS8wUGRBZ3pkQ2d2N2c1Ky9XWWJ1UzF5UkFkbHhuWHo3anhY?=
 =?utf-8?B?WWZZYmJuK296ejFvdi93MitLL0dOQXpIcWM0bjVWU1BEdVV3UDhwWmhTQUhX?=
 =?utf-8?B?Z0Jzc3hKOFR6TFdCOWUwQT09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f673b74f-f010-4c70-2120-08d958319509
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2021 16:53:42.8290
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AmNZjVhUXf3piBT4aoWgT34mFbWIODvrB4j5fTzK0bf228pUZS06T8QKAYDRcyTp
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4872
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: 7WoZQ_2aDmwYDUCNDNKikTlMfVzDbGcn
X-Proofpoint-GUID: 7WoZQ_2aDmwYDUCNDNKikTlMfVzDbGcn
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-05_05:2021-08-05,2021-08-05 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0 mlxscore=0
 impostorscore=0 lowpriorityscore=0 mlxlogscore=999 clxscore=1015
 priorityscore=1501 phishscore=0 suspectscore=0 adultscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108050101
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/4/21 12:08 AM, Kuniyuki Iwashima wrote:
> This patch implements the BPF iterator for the UNIX domain socket and
> exports some functions under GPL for the CONFIG_UNIX=m case.
> 
> Currently, the batch optimization introduced for the TCP iterator in the
> commit 04c7820b776f ("bpf: tcp: Bpf iter batching and lock_sock") is not
> applied.  It will require replacing the big lock for the hash table with
> small locks for each hash list not to block other processes.
> 
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
> ---
>   fs/proc/proc_net.c      |  2 +
>   include/linux/btf_ids.h |  3 +-
>   kernel/bpf/bpf_iter.c   |  3 ++
>   net/core/filter.c       |  1 +
>   net/unix/af_unix.c      | 93 +++++++++++++++++++++++++++++++++++++++++
>   5 files changed, 101 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/proc/proc_net.c b/fs/proc/proc_net.c
> index 15c2e55d2ed2..887a8102da9f 100644
> --- a/fs/proc/proc_net.c
> +++ b/fs/proc/proc_net.c
> @@ -91,6 +91,7 @@ int bpf_iter_init_seq_net(void *priv_data, struct bpf_iter_aux_info *aux)
>   #endif
>   	return 0;
>   }
> +EXPORT_SYMBOL_GPL(bpf_iter_init_seq_net);

bpf_iter does not support modules for now as it is implemented before 
module btf support. It needs some changes.
For example, currently bpf_iter only caches/uses the vmlinux btf_id
and module obj_id and module btf_id is not used.
One example is ipv6 and bpf_iter is guarded with IS_BUILTIN(CONFIG_IPV6).

So you could (1) add btf_iter support module btf in this patch set, or
(2). check IS_BUILTIN(CONFIG_UNIX). (2) might be easier and you can have
a subsequent patch set to add module support for bpf_iter. But it is
up to you.

>   
>   void bpf_iter_fini_seq_net(void *priv_data)
>   {
> @@ -100,6 +101,7 @@ void bpf_iter_fini_seq_net(void *priv_data)
>   	put_net(p->net);
>   #endif
[...]
