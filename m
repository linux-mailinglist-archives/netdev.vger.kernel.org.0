Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 284E73DB384
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 08:25:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237463AbhG3GZI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 02:25:08 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:48358 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230203AbhG3GZH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Jul 2021 02:25:07 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16U6KLGT026087;
        Thu, 29 Jul 2021 23:24:48 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=kJleVAxVBQNrDuKymvKfRptmkLafA2pADpsp0CIXdaY=;
 b=J9W8eI84jY1zzZN/+Yz8TMEmX9GUfAeY0tamZPGhIARPtGPh8hQkszfL9wjxo7Nua+fK
 rtClttmahfMzeTe8tN5BQ3ZUzPmohmA7XPLDU7t85pVraCk+9l+GD+fP05oR3ucaJSYf
 ngvUAipGnM2raHA9Ub/zSimgNeEICtbsr04= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3a37bjneqq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 29 Jul 2021 23:24:48 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 29 Jul 2021 23:24:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LHG8KUolt2dO+opBYW8shgPqqYj3rrhyeISAr0Ki+hUywB+8eM1w2f8ol1S35vIhToEMbGmgrcyuw57qLnlZPLso45ywAQEluHRrB+uwH8gKoBIBCdk2NUnl+X7eqMH53uEkEst6JDpvLO0wK60GbMCych1CZLoRiPf21gmEuzPBfH8gPmQugRgFXd9hA4QLiBMByOS6yaIVqfSG6GjtZnisT0PFgyZBCW6hZgvqj2fXy+AQ6Q+VU96KJUCKJnRMJXyj2+U7kSNFAGBlHVY3nkbuc9LxnlWXguEBj2UUfyszDK3ZBq8uRs0hYeMp3UnP5irhHsed8RXzU6ZhxVYm9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kJleVAxVBQNrDuKymvKfRptmkLafA2pADpsp0CIXdaY=;
 b=fFbhxrSra7eVIbZ0uMByWbN1OMxJvG3eHuzrOkNVcK8ANHcDogctEZ+W9VLAOUc3Smy+nbYq/PO9PWx5Uae6KjLdRGOIPvrlRFO8SQsEwdOT9PZtsIDap8POevLk2Yr89tlmtfN24IBmD23vYJY3Ttila4Tw9+gvyi9dqCshaLgVeG2eskQXE9QwusAs3APbXuaFaJy2hucjrO8wbPHz4AJoV7rupYOITc9hiAfP5h3lL9/vAkAu6zm9pDAZzoDXwsQTJXyXa1e9hz9mS9t09TXpYtkp4mbvxPXmbtlWypmR4shNbJki5PRyYIm1r7lB7CuXHrGF2UAIwpJEbMl0NA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA1PR15MB4385.namprd15.prod.outlook.com (2603:10b6:806:190::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18; Fri, 30 Jul
 2021 06:24:44 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::c143:fac2:85b4:14cb]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::c143:fac2:85b4:14cb%7]) with mapi id 15.20.4373.021; Fri, 30 Jul 2021
 06:24:44 +0000
Subject: Re: [PATCH bpf-next 1/2] bpf: af_unix: Implement BPF iterator for
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
References: <20210729233645.4869-1-kuniyu@amazon.co.jp>
 <20210729233645.4869-2-kuniyu@amazon.co.jp>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <bcdc1540-c957-51b8-2a94-1b350a1a5a6a@fb.com>
Date:   Thu, 29 Jul 2021 23:24:41 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
In-Reply-To: <20210729233645.4869-2-kuniyu@amazon.co.jp>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR05CA0083.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::24) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21d6::1130] (2620:10d:c090:400::5:1fa2) by BYAPR05CA0083.namprd05.prod.outlook.com (2603:10b6:a03:e0::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.6 via Frontend Transport; Fri, 30 Jul 2021 06:24:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 06c2c7c7-4079-4b53-7fdb-08d95322b8b9
X-MS-TrafficTypeDiagnostic: SA1PR15MB4385:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA1PR15MB438557E50EADDE8FA8256245D3EC9@SA1PR15MB4385.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:883;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +O+9UnHGcJSDeyF31jqZAjnP6rSTEPxgtUWUUkwJcbqmuic65G7WH7mF7A40luUXUajyB1CQKRGwc3pTROTry7MZPgL1k1U0UWT418mYGPXa9CkxjWKEmk2/aCzscmPCBl8Pf+5G5e6WJlW7kuIoxiKFgjiptXRVFKYb3GN5sKGA76lQVlaxV2XEPrUYaxnr2pU/0eZlWis5DjsNK8He3Gi6bSiRvJwrn9wFO8z8H7ldwN3kuDJhFbhBJIQGpDDlPOJLuzi8wsRjY2VLY5rpn6MR8fUaC32f1Z1UyDFMBs4wfQ2+sSmH++nbWWPPHaaORZmbTtg7nm4b2sEk6Gc54Zg+qfC8mbdoi7fheWH8FFZCFk7k8OTNrZLJ5UY0erAIKdOrwOz8wBVub4oY4CwafHl6AYG29gntZZBFZtC6FUaHkYu0yG6rAT2e1MK/LWoZ/HAgUmCJRSk3wb4bTAm6E9HVlc52pBK7HtTHehXZXNQ8KGFLy6orRWFTnoKHTUQUXlua7ti+ITMlweQoEt42MDYhBlASNZgPeEaKSlDlPkktDI6tyUJZn0V1YoPp1/hKs1a+2xBklkJTV6I0vy8vEDDy+KzD/iLTiOiEKm8k0c72pQjH1b7x/K7ymaDj0WRoMYb0Y6EWTEnRzOvcN731uJkyG72amOS0CTz7Jw2ScxN0RmIsfPdG1MGqxM3NoioCxKyl3v53FIG7pgVzn0O6ZnNWHP+ukb6Z39KykpO8QsfTobHE//XFe7ZrFuVPVq15
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(39860400002)(136003)(366004)(396003)(31696002)(2906002)(5660300002)(8936002)(316002)(110136005)(478600001)(54906003)(8676002)(38100700002)(52116002)(6486002)(2616005)(36756003)(7416002)(31686004)(53546011)(66946007)(66476007)(66556008)(4326008)(921005)(186003)(86362001)(83380400001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WmNSbldwR0EwNmZXanZoQlJ2UU5WdSt6K3dXQXptTDhudFNiTXg1TTYxQnNi?=
 =?utf-8?B?bUVjTUY2L1ZSZ3JNVjdnU1UxcGxVYlEzNVkxRVR6VUR5Q1FSZHBMS1J6VXpt?=
 =?utf-8?B?N0EwRjhYZDYwMGlEVTlESDAwNkgram5JWnBXL0EwbWpjY3NCN2lrbFUzRWV6?=
 =?utf-8?B?SmVhY0x0ZFpXWmtkVzI4NFhMR3JJZFAyM0xqT3dCN0pmd0NWSGZ1cEd3QzZw?=
 =?utf-8?B?R0VDY2RyNDNtMGUyRjZNU1VVZHJ4ZVlEWFpRQ3N2STVERzBDN0V3bFFCNjR5?=
 =?utf-8?B?MGE3dE9SbjNRUFllNnZpUWhjVDVOVEpDcGoxTzA0eTlSeWxxSXM5N0d0RU10?=
 =?utf-8?B?TlpFa0NVMEdDeW53K2M3VmlSSmR5czRwTVYzUU1wbXJlYXhxV0NjbjYwSEhY?=
 =?utf-8?B?L0VjU1VoUmp5UGVORjR6WVlub2FwM3FnaFE4QVh6TTFWSDlyMnR4VGNiMlNU?=
 =?utf-8?B?aTErZk1QUnRoeUxvT3Fwd0Q3T2xHbnRENXhUb3orRjdqN003eEtkNUpoTkpB?=
 =?utf-8?B?d2lVdmRVUjIwS0RDOHJNb2RrVmtpUk1CcjYwa09pTnBQNXJrclRzSG5KOFhU?=
 =?utf-8?B?aGhucG15VnJFTHFYSEJSUnpHZk51WUlieitKV21valU5TnpxYUxCUE9nWnhm?=
 =?utf-8?B?OHJ6NHNQU29qSmNEWXdxOHRsYmlZUWw1cC9nQ0U0OCtRSVBiL2lobFU0U3FX?=
 =?utf-8?B?ZWhYNll1N2JHdnh4S1pWZTNmWWd2aERWcnVmTGEwZUhGTFJ4WnVNMURSQnFR?=
 =?utf-8?B?VGIyK0VCZGRWaW4yR0R0RnRFMUtVdEF0M1NpbFNWWTJDeWhNYkVJNEdITytK?=
 =?utf-8?B?RCt3RkZEZFl1YUhPRDczbk8zak9BVEl2NmRxeUMweW51S0QzRGd6ZndoUHRS?=
 =?utf-8?B?S3FpZTNrMDZDWDJsNXptM2k5TGhiYW9TNVdZai9PUXZ2d0J0cGRpc1FyUUFL?=
 =?utf-8?B?bEx0UnNHbkMxaVZxR2xlZ00wN2xRMWFrcURoY0VDeWIxblZvRmUwdWtPZlN0?=
 =?utf-8?B?Ym50b0ZRU0gxWHNZV05xVkFON0tqR0d3OUR2c0tJQVpIdGtJaXFRdHJEVDhm?=
 =?utf-8?B?SWZOTXJPZXZFYUJ5SHRraUR4bHpkMVJ3ZFNzdGsydGhOK1NjcDkrOUJDU1Nw?=
 =?utf-8?B?QmUzZDhTb3dXWDdkWGlFRFFkMnJ5MFpDQ08wbVpNRUluNEFUOHNVOU5jdzNw?=
 =?utf-8?B?dEJybGNycFY4aTFWaUREUjErVnVqRHdlQTFOWGp5bzhDQ1hadFNOb3pQa1lE?=
 =?utf-8?B?ZGx2RmtleDlEWmRHWENLNml2ayswdGJSZ3RScUdXMlQ2N2xIMDgrMWVYcDdU?=
 =?utf-8?B?OFJNeEV1T0QxVzRxQkhGZGVERWN4T0FJTVdDS1ptS05QRkRtZHp6UUtqbGtV?=
 =?utf-8?B?YzV3WDA3Ykc3b294YmhNYlphcFM4bTRJN1NYbTlIZ2NyMVN3UGFjM3hCdjZB?=
 =?utf-8?B?Ui9ob0tjSlZkRGFlak13amIyNlM3T2o0elVRa01jQklWOXBUMGZNRDhOZjJi?=
 =?utf-8?B?VWdXcDNjZ29KUnFLR1YvWmdBL0lIUTJUSld0MmkrQ2xMbUxjTEF4b2w1Sy9O?=
 =?utf-8?B?dmc2b1d4M3NERHB6Y3J1YVhEN0Vhd3lSRSt2VWdidU96RjQ0OFhzTVVaNFJ6?=
 =?utf-8?B?d1NjeTVST3lsR0lnK1FwSG9SckxzcnBObUUxVDBSMUszV0twbWVxVWRHbkgy?=
 =?utf-8?B?N2c4Um9VT2pmL0Y1Ny91WGVzWENKTmRQVEVlSGVaRFAwRENwcFJmWnhPN01o?=
 =?utf-8?B?QUdKcHVhNnZva3R6YjNGY1ZSVCtaemNLQkxXNkVURFo5eWVYVnNsUWE4d0sv?=
 =?utf-8?Q?4vdAy26hmgMHo0DWAyOVaTx5xM6qhHWHZSL20=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 06c2c7c7-4079-4b53-7fdb-08d95322b8b9
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2021 06:24:44.3953
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YJDRGFUPsDHQhBNOLzLpZKWQW/2XWFeR27MFCjbbehm2QM/AHPIO+hvJN8dLcZRz
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4385
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: bR7DRUS_be-ulPeyNtGOzrKTFrC2EUtC
X-Proofpoint-ORIG-GUID: bR7DRUS_be-ulPeyNtGOzrKTFrC2EUtC
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-30_03:2021-07-29,2021-07-30 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0 bulkscore=0
 priorityscore=1501 lowpriorityscore=0 suspectscore=0 adultscore=0
 mlxscore=0 mlxlogscore=999 impostorscore=0 clxscore=1011 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107300037
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/29/21 4:36 PM, Kuniyuki Iwashima wrote:
> This patch implements the BPF iterator for the UNIX domain socket.
> 
> Currently, the batch optimization introduced for the TCP iterator in the
> commit 04c7820b776f ("bpf: tcp: Bpf iter batching and lock_sock") is not
> applied.  It will require replacing the big lock for the hash table with
> small locks for each hash list not to block other processes.

Thanks for the contribution. The patch looks okay except
missing seq_ops->stop implementation, see below for more explanation.

> 
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
> ---
>   include/linux/btf_ids.h |  3 +-
>   net/unix/af_unix.c      | 78 +++++++++++++++++++++++++++++++++++++++++
>   2 files changed, 80 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/btf_ids.h b/include/linux/btf_ids.h
> index 57890b357f85..bed4b9964581 100644
> --- a/include/linux/btf_ids.h
> +++ b/include/linux/btf_ids.h
> @@ -172,7 +172,8 @@ extern struct btf_id_set name;
>   	BTF_SOCK_TYPE(BTF_SOCK_TYPE_TCP_TW, tcp_timewait_sock)		\
>   	BTF_SOCK_TYPE(BTF_SOCK_TYPE_TCP6, tcp6_sock)			\
>   	BTF_SOCK_TYPE(BTF_SOCK_TYPE_UDP, udp_sock)			\
> -	BTF_SOCK_TYPE(BTF_SOCK_TYPE_UDP6, udp6_sock)
> +	BTF_SOCK_TYPE(BTF_SOCK_TYPE_UDP6, udp6_sock)			\
> +	BTF_SOCK_TYPE(BTF_SOCK_TYPE_UNIX, unix_sock)
>   
>   enum {
>   #define BTF_SOCK_TYPE(name, str) name,
> diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
> index 89927678c0dc..d45ad87e3a49 100644
> --- a/net/unix/af_unix.c
> +++ b/net/unix/af_unix.c
> @@ -113,6 +113,7 @@
>   #include <linux/security.h>
>   #include <linux/freezer.h>
>   #include <linux/file.h>
> +#include <linux/btf_ids.h>
>   
>   #include "scm.h"
>   
> @@ -2935,6 +2936,49 @@ static const struct seq_operations unix_seq_ops = {
>   	.stop   = unix_seq_stop,
>   	.show   = unix_seq_show,
>   };
> +
> +#ifdef CONFIG_BPF_SYSCALL
> +struct bpf_iter__unix {
> +	__bpf_md_ptr(struct bpf_iter_meta *, meta);
> +	__bpf_md_ptr(struct unix_sock *, unix_sk);
> +	uid_t uid __aligned(8);
> +};
> +
> +static int unix_prog_seq_show(struct bpf_prog *prog, struct bpf_iter_meta *meta,
> +			      struct unix_sock *unix_sk, uid_t uid)
> +{
> +	struct bpf_iter__unix ctx;
> +
> +	meta->seq_num--;  /* skip SEQ_START_TOKEN */
> +	ctx.meta = meta;
> +	ctx.unix_sk = unix_sk;
> +	ctx.uid = uid;
> +	return bpf_iter_run_prog(prog, &ctx);
> +}
> +
> +static int bpf_iter_unix_seq_show(struct seq_file *seq, void *v)
> +{
> +	struct bpf_iter_meta meta;
> +	struct bpf_prog *prog;
> +	struct sock *sk = v;
> +	uid_t uid;
> +
> +	if (v == SEQ_START_TOKEN)
> +		return 0;
> +
> +	uid = from_kuid_munged(seq_user_ns(seq), sock_i_uid(sk));
> +	meta.seq = seq;
> +	prog = bpf_iter_get_info(&meta, false);
> +	return unix_prog_seq_show(prog, &meta, v, uid);
> +}
> +
> +static const struct seq_operations bpf_iter_unix_seq_ops = {
> +	.start	= unix_seq_start,
> +	.next	= unix_seq_next,
> +	.stop	= unix_seq_stop,

Although it is not required for /proc/net/unix, we should still
implement bpf_iter version of seq_ops->stop here. The main purpose
of bpf_iter specific seq_ops->stop is to call bpf program one
more time after ALL elements have been traversed. Such
functionality is implemented in all other bpf_iter variants.

> +	.show	= bpf_iter_unix_seq_show,
> +};
> +#endif
>   #endif
>   
>   static const struct net_proto_family unix_family_ops = {
> @@ -2975,6 +3019,35 @@ static struct pernet_operations unix_net_ops = {
>   	.exit = unix_net_exit,
>   };
>   
[...]
