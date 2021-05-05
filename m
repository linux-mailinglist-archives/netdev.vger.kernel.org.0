Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E370137347F
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 06:56:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231650AbhEEE5j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 00:57:39 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:37180 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231126AbhEEE5i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 May 2021 00:57:38 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 1454qZvh032097;
        Tue, 4 May 2021 21:56:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=xvpMG4JIQlIgu2rKqGX7vOrsZHBwVtcSgaZ41eG3jfI=;
 b=cmMX2YHu+6CO8D/3c3OTYfmb6TMKpSNvFNyK7wyUFr/zavNBLmgR90+vnpmXFKNlcZIa
 8YX44leODvuidwfrxNl2eSiAzMwWXmWB9fnbUYbRbCir07+tdxMB4UTVaYX9UiPv1wl6
 UVgxd7jYlSJt9oWNwSIz6XdyJZfof+BjfMs= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net with ESMTP id 38beb1hmyv-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 04 May 2021 21:56:24 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.230) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 4 May 2021 21:56:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CTnB8NcjpgSLfl3I+vsyMje4zaWnB9AhhdNt4qwanttiPXf1KbmjVq55+JzlPuOwDqD/uQ5S+uJQdxhzkQekPkXP7PTFaJ8Yu/X95xnk2M/GPyh4blMASY9903BrVyR+xoMhMFH7ChG0mjkEM1mdYfsEs32xpKAlmQR7gM1rOGF19POs+bHy2DtM7JBrltkDWyEoRC4yOPq/zzYcO5Gq+UDrID2pEhGLOlM1DBfT4nsVt8IwXqSIYqiGfWnFccer6D4/SKkpND2xtvGOvsRHDiPDZFP0oJd/jfAJX2M/xMCqC5e/lx4bCl7Dv9rqYosG0/g64MWNk2+/f6JATueQZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xvpMG4JIQlIgu2rKqGX7vOrsZHBwVtcSgaZ41eG3jfI=;
 b=Ubkz5n5s5V1kyg84yvTgJsKbenv8EQ9sCexsSwSMvqQPbrrd6NhoEUVFHc/CQe5isuaUaD1qNGExg9HtYvt9ZAxlyQY8HbKGAXMG082p6bCxh3GW9oog4vWfbEibotTEem5yC57oBQXTkp/BS42oV56p2JZNHwbV8OCBniwNEUue3E9NqPj2LiGI1gCHVmyYsMbcd+PinvHJ7zjJg42yruSWwdGOcCv/fCfAKK4YNAgDr/vfQNo1T4yh7ReJxeunkX0vM4zgqLLYDks7EcnXjLH5loax4KXsGnObN4exSY9NDfPlcv+1BMf0CJlQDfLUwk8tM/mLwqO+qMdQRFNSDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: amazon.co.jp; dkim=none (message not signed)
 header.d=none;amazon.co.jp; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB2245.namprd15.prod.outlook.com (2603:10b6:a02:89::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25; Wed, 5 May
 2021 04:56:21 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::718a:4142:4c92:732f]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::718a:4142:4c92:732f%6]) with mapi id 15.20.4087.044; Wed, 5 May 2021
 04:56:21 +0000
Date:   Tue, 4 May 2021 21:56:18 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>
CC:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Benjamin Herrenschmidt <benh@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 bpf-next 06/11] tcp: Migrate TCP_NEW_SYN_RECV requests
 at retransmitting SYN+ACKs.
Message-ID: <20210505045618.flihfg3hcesdyfak@kafai-mbp.dhcp.thefacebook.com>
References: <20210427034623.46528-1-kuniyu@amazon.co.jp>
 <20210427034623.46528-7-kuniyu@amazon.co.jp>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210427034623.46528-7-kuniyu@amazon.co.jp>
X-Originating-IP: [2620:10d:c090:400::5:5bbb]
X-ClientProxiedBy: MWHPR2001CA0017.namprd20.prod.outlook.com
 (2603:10b6:301:15::27) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:5bbb) by MWHPR2001CA0017.namprd20.prod.outlook.com (2603:10b6:301:15::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.24 via Frontend Transport; Wed, 5 May 2021 04:56:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3d51b9e2-646d-4fa1-5a95-08d90f82207b
X-MS-TrafficTypeDiagnostic: BYAPR15MB2245:
X-Microsoft-Antispam-PRVS: <BYAPR15MB2245D562FF47FFCDB66FCC60D5599@BYAPR15MB2245.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KaD6R4eguuQ04a24QUMYZtolQcFMBD6vNmpfZyDb64PJqB2SI7FxPmpVfZL8kSzZkYXmVdGfrT0RG4n6xQKedAMr/fjMFopj/091P2ufICq2zuNrzVNFJ6fTg0QEdzO8U5iLOtqfQz/DEN6SVa+PxiLkaxqITwCAyHUT1zmWeRj+c5YrZmEbQylrFTRx5LIcdPQTqpUs1KtVpFyfE2qSE1O7DyAIx+xar448WQsrj7xrmYktEmD4yYJ3wfaUo0tHokhuOV+t+DuZdk96HyynlFFvXBrh11hQCzZofnY+VfCGaBkMZnF803RoiFNeWpjmE0yfncTu1lIXo4umPlkBB7Rr4/tc/yUiruQi0cX5JrvS1i85hsViUQQuKdZhpIaamNYTf0mn78dcGj19C0gxT8njnsPeN2ZDRvTqqdU0oJqorxtokqH00d7a29/xiQWsx22/o3bTH6+4pbzoaxH3MFm73mMzkCBF5QR0ccBbdiwN0TFDzQ4KE67go+4O+So1vlGMd9s//R4Sngr+P7jtPq690bbWuceO0++455ArRxE1SCcHsO7kvvdQveCYzh1XTZ7VtDuRtpePCdccOPkb/A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(136003)(366004)(396003)(39860400002)(86362001)(8936002)(16526019)(8676002)(4326008)(7416002)(316002)(83380400001)(54906003)(478600001)(186003)(66946007)(1076003)(6506007)(66556008)(6916009)(52116002)(2906002)(9686003)(38100700002)(55016002)(7696005)(66476007)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?iFNi6SOdhYwKtyednmyxKFJQEqA+r6LSWWQGwMcOWDQR+VkMBIjSeb4C0B9g?=
 =?us-ascii?Q?B5L3snTr3pAsjrmzMO3LxouQ41N5y0ZwasjHlNWDI7Pm9KvGVeC2+kdoiUQe?=
 =?us-ascii?Q?NzpK62WQQHJeLSN1tDL7UiZxZHujxYB/508l6pp4tCvWSTKuUIp4sEepBMfs?=
 =?us-ascii?Q?dDBfC8aUKNOA03xtyc75yiCSCiOAc/9s8BviWRPpZ4E/fV8poJB6CjubkDXf?=
 =?us-ascii?Q?epmvh5Wtm01CezGxSL1cGtk8BjoNaNVpmfNiehi0xuV/nilKQiV/exaUM7P8?=
 =?us-ascii?Q?6A2vBMutkXnne1yKEXkHx+jTHJoQCAOeFYzbrfDBJtLEopTiio8bJ3bo5OOC?=
 =?us-ascii?Q?7nWzbwmwsZigw2sAVcnWkNJ6DBy0Nfef9gdwPiK5exi75PgxER2BvYBEhhec?=
 =?us-ascii?Q?b5TDh1kIPQOjNBTQ/6LIbGUtBO2NvgDR5WoE7iK/480bUsPNTauQ/biTP1bH?=
 =?us-ascii?Q?2TLijAxYQHQBCNKUkWbm/jmihEsk9Dh7odxcQF21PFJE+I1oHRAkaH3NhdXA?=
 =?us-ascii?Q?QYGLYvqKiEqFfbjqtpNfXyIG/kwitebsiFgOhi7zTx3JfviTCty9D5hfeJtQ?=
 =?us-ascii?Q?/PdHnTrhlYXI1CMe2iZdjKvTVZOQ9LZjPQpGisRbDumGleD0XE4L9A0D5VTT?=
 =?us-ascii?Q?/xzwSTDt1IH/hqjKsVVs7fRFpWqdDrqgWPhQJon17NJ2TJ6CjohsvKF9Dx9l?=
 =?us-ascii?Q?qo0M4C6KuPFvGhzfLwXgoqbxYp3zgGQsmP6S5tzWTqgaVcbxjYv6XzGf46eI?=
 =?us-ascii?Q?z8l0vwV458ZH2UXXJlgBZYCzBmg/+46YEtuTeOFhpdmERtPmDoHSisC7FqbT?=
 =?us-ascii?Q?2h+k/YZGMjDpZ1Ig5y6eh+cPlEYm15MIP1UdpHGWTwQR8d/pGttEzzIy/zyF?=
 =?us-ascii?Q?kZtcMg1sSNLRLcD15nXP3KgU2ZXQwb4jJeNrqgVVQIdfEqAa5pBb/AlXn92O?=
 =?us-ascii?Q?aIMBQl37pCN4nRq6/lnOIgFh90uFBr8kk0gXgUrs6e/NfcgIyidMMlgz3NCV?=
 =?us-ascii?Q?Kue0sqTMbF/ID9+fqsregw73DNDjvKjwhC84ErQClqCwlNtyGBgI6+OBlzPr?=
 =?us-ascii?Q?RZV/aA7fBNJxUIXyF3W+risWS/xHHGguiNCdjCv+yb/BBt5L5gI9tJB6Uymz?=
 =?us-ascii?Q?My/d4c09Si/4T8Z+yDy46g8L0dD+LusuPADhzmlWq78n+uhha2B19L9mdSSE?=
 =?us-ascii?Q?2CkMwJMvrqTrrSoUEUT79MQrEmbmtJpzGTHh9pzSJNfEXB6j9S7eSLdLPTi2?=
 =?us-ascii?Q?TPpJfE8vKXrGcKiIv9a8iMI916nJeYfwSDeo3sUeCUfA91VFVMaN3xtHwDU/?=
 =?us-ascii?Q?pTexIhdOi/pVMyW+x817FD9+s5bQdQLQSMbyOcwQrAHfhg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d51b9e2-646d-4fa1-5a95-08d90f82207b
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2021 04:56:21.7694
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MiuSgWfHYOruTuideCiQi8Jk54dTL9ApHFqinkvl/21jFlKoRYM8sZrYsTuWATDn
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2245
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: 6F7ECIgvgVbeQ9jTy4JHEzbcIvInKbJm
X-Proofpoint-GUID: 6F7ECIgvgVbeQ9jTy4JHEzbcIvInKbJm
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-05_01:2021-05-04,2021-05-05 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 bulkscore=0
 suspectscore=0 clxscore=1015 malwarescore=0 phishscore=0 adultscore=0
 priorityscore=1501 spamscore=0 mlxlogscore=999 impostorscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2105050033
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 27, 2021 at 12:46:18PM +0900, Kuniyuki Iwashima wrote:
[ ... ]

> diff --git a/net/core/request_sock.c b/net/core/request_sock.c
> index 82cf9fbe2668..08c37ecd923b 100644
> --- a/net/core/request_sock.c
> +++ b/net/core/request_sock.c
> @@ -151,6 +151,7 @@ struct request_sock *reqsk_clone(struct request_sock *req, struct sock *sk)
>  	memcpy(&nreq_sk->sk_dontcopy_end, &req_sk->sk_dontcopy_end,
>  	       req->rsk_ops->obj_size - offsetof(struct sock, sk_dontcopy_end));
>  
> +	sk_node_init(&nreq_sk->sk_node);
This belongs to patch 5.
"rsk_refcnt" also needs to be 0 instead of staying uninitialized
after reqsk_clone() returned.

>  	nreq_sk->sk_tx_queue_mapping = req_sk->sk_tx_queue_mapping;
>  #ifdef CONFIG_XPS
>  	nreq_sk->sk_rx_queue_mapping = req_sk->sk_rx_queue_mapping;
> diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
> index 851992405826..dc984d1f352e 100644
> --- a/net/ipv4/inet_connection_sock.c
> +++ b/net/ipv4/inet_connection_sock.c
> @@ -695,10 +695,20 @@ int inet_rtx_syn_ack(const struct sock *parent, struct request_sock *req)
>  }
>  EXPORT_SYMBOL(inet_rtx_syn_ack);
>  
> +static void reqsk_queue_migrated(struct request_sock_queue *queue,
> +				 const struct request_sock *req)
> +{
> +	if (req->num_timeout == 0)
> +		atomic_inc(&queue->young);
> +	atomic_inc(&queue->qlen);
> +}
> +
>  static void reqsk_migrate_reset(struct request_sock *req)
>  {
> +	req->saved_syn = NULL;
> +	inet_rsk(req)->ireq_opt = NULL;
>  #if IS_ENABLED(CONFIG_IPV6)
> -	inet_rsk(req)->ipv6_opt = NULL;
> +	inet_rsk(req)->pktopts = NULL;
>  #endif
>  }
>  
> @@ -741,16 +751,37 @@ EXPORT_SYMBOL(inet_csk_reqsk_queue_drop_and_put);
>  
>  static void reqsk_timer_handler(struct timer_list *t)
>  {
> -	struct request_sock *req = from_timer(req, t, rsk_timer);
> -	struct sock *sk_listener = req->rsk_listener;
> -	struct net *net = sock_net(sk_listener);
> -	struct inet_connection_sock *icsk = inet_csk(sk_listener);
> -	struct request_sock_queue *queue = &icsk->icsk_accept_queue;
> +	struct request_sock *req = from_timer(req, t, rsk_timer), *nreq = NULL, *oreq = req;
nit. This line is too long.
Lets move the new "*nreq" and "*oreg" to a new line and keep the current
"*req" line as is:
	struct request_sock *req = from_timer(req, t, rsk_timer);
	struct request_sock *oreq = req, *nreq = NULL;

> +	struct sock *sk_listener = req->rsk_listener, *nsk = NULL;
"*nsk" can be moved into the following "!= TCP_LISTEN" case below.
Keep the current "*sk_listener" line as is.

> +	struct inet_connection_sock *icsk;
> +	struct request_sock_queue *queue;
> +	struct net *net;
>  	int max_syn_ack_retries, qlen, expire = 0, resend = 0;
>  
> -	if (inet_sk_state_load(sk_listener) != TCP_LISTEN)
> -		goto drop;
> +	if (inet_sk_state_load(sk_listener) != TCP_LISTEN) {

		struct sock *nsk;

> +		nsk = reuseport_migrate_sock(sk_listener, req_to_sk(req), NULL);
> +		if (!nsk)
> +			goto drop;
> +
> +		nreq = reqsk_clone(req, nsk);
> +		if (!nreq)
> +			goto drop;
> +
> +		/* The new timer for the cloned req can decrease the 2
> +		 * by calling inet_csk_reqsk_queue_drop_and_put(), so
> +		 * hold another count to prevent use-after-free and
> +		 * call reqsk_put() just before return.
> +		 */
> +		refcount_set(&nreq->rsk_refcnt, 2 + 1);
> +		timer_setup(&nreq->rsk_timer, reqsk_timer_handler, TIMER_PINNED);
> +		reqsk_queue_migrated(&inet_csk(nsk)->icsk_accept_queue, req);
> +
> +		req = nreq;
> +		sk_listener = nsk;
> +	}
