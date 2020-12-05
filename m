Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 681702CF8BE
	for <lists+netdev@lfdr.de>; Sat,  5 Dec 2020 02:44:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729423AbgLEBoI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 20:44:08 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:3776 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725601AbgLEBoI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 20:44:08 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B51h9jT013599;
        Fri, 4 Dec 2020 17:43:11 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=ePdcYsm7QrhJ+dZHfhBxucJmCwghvvqFtm9QbOZnkIU=;
 b=ZriBxh3+/0cAol1XV623ltUhnqFtx/Xd9YtqcS5LIiYBSfoWouqWqgdeD0zHKu47Xzue
 IdF/tTyrY1XTbK8de/ogy02TFcac2RjWPoS/gVxBfStA4M0EIaHxO1kXnvDKihLGgTmw
 qmk8X5cQOlJk5Wqsz5lYjdK1Xjy/PLc40RY= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 357rev3188-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 04 Dec 2020 17:43:11 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 4 Dec 2020 17:42:48 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iqNjVnrFrtuDe7BC6nwWpjkjDH+ORRP7JvTnApfVU0jWycwdwSbSCIA3kIIY5O3wV54fwKTfBp1ULSL0SR+hNaxyDq4XHli3IT2RIGcE6KRdWFs4UX3eit0lI+wkU5fifOXOmIHgt9zYZLuPOcHrno8/7U1wzA3UVy/PxrAqifeXHK4LYkmLzcsHO71gmmHyREQwuw5FhAncUAmAKlFmcSVDZvkiNp7gs9hSIVsIy3M9tESJwRA3PlNm8Drgf/g2SgLztSP9C5EIkS1Tigq3WE1PiEV3LgNSH69qrpClqjRNSWrBt7xqcX8hs4kizpWf1/5aKQ5aDi2tTj3Jb8mY7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ePdcYsm7QrhJ+dZHfhBxucJmCwghvvqFtm9QbOZnkIU=;
 b=AMMXSD87+m1r1kbtvvl5UtFnpA8JTzq2k9Oxt6UiWKkGcOEo3ztPAOVm3hGVbEt1XNZkaaVNjyfMSYDl2zYIDgTPLXkn7dWeSYffPmR162GPokNAUOiHdBxYSft/ekmHx8U2x5HP3TluHtPzYJ59FJg4Tx5jySIrSetHEIkHQM8sd46WRcxJTL6ocgqDuYcNDju/908yBBFZot8IMjzK3IQM1QGeQmHXdM8uX3c0CPS83BP4igHcyKrA1xrqkBxean884Pvr6gW/DJjeXOmh2zw6akGdO0dqKZbdW+NDdDU6Jz4ZiM1VfZz/QoWgS0/GUajlFEtvLU423wAt+0Jj2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ePdcYsm7QrhJ+dZHfhBxucJmCwghvvqFtm9QbOZnkIU=;
 b=Y3j556o3L0IRjO6GBqle1sSHzVQzlHcEACcccJh4IXs3qKz8OZqYuGqpLHlevE7VLY2Xj6bk6Zq9XTaGHFoUmUmIbe4vec5krf2Ac8Hmfl17O8mYlnMOGRmlMKL6UUkQ/tIWeks1HGXhr5lzbZmZwWHJd8w0tAgh5tk3wYXZeNw=
Authentication-Results: amazon.co.jp; dkim=none (message not signed)
 header.d=none;amazon.co.jp; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by SJ0PR15MB4235.namprd15.prod.outlook.com (2603:10b6:a03:2e3::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.22; Sat, 5 Dec
 2020 01:42:48 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::2831:21bf:8060:a0b]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::2831:21bf:8060:a0b%7]) with mapi id 15.20.3632.021; Sat, 5 Dec 2020
 01:42:48 +0000
Date:   Fri, 4 Dec 2020 17:42:41 -0800
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
Subject: Re: [PATCH v1 bpf-next 03/11] tcp: Migrate
 TCP_ESTABLISHED/TCP_SYN_RECV sockets in accept queues.
Message-ID: <20201205014241.afrcicgewlnyrzfu@kafai-mbp.dhcp.thefacebook.com>
References: <20201201144418.35045-1-kuniyu@amazon.co.jp>
 <20201201144418.35045-4-kuniyu@amazon.co.jp>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201201144418.35045-4-kuniyu@amazon.co.jp>
X-Originating-IP: [2620:10d:c090:400::5:4e20]
X-ClientProxiedBy: MWHPR21CA0026.namprd21.prod.outlook.com
 (2603:10b6:300:129::12) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:4e20) by MWHPR21CA0026.namprd21.prod.outlook.com (2603:10b6:300:129::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.2 via Frontend Transport; Sat, 5 Dec 2020 01:42:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d40c4a92-af2a-473d-0555-08d898bf122f
X-MS-TrafficTypeDiagnostic: SJ0PR15MB4235:
X-Microsoft-Antispam-PRVS: <SJ0PR15MB423563E1F01BDB68A2F1151ED5F00@SJ0PR15MB4235.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:758;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /BiDJ7YNUbszzMxLd/xiHODEH9lZYCpYnRBakJ2xyANUglpgX+kaxmv3n7Bvt9RsicTEFAlTN1idugLqumZllN1vI1NUsa2XttYy8/uPFnbz6FdBjlEYYR6qbWgCYhfN2iSiahfHzO0Kbzj31ZckYHXNR9g/Eb7ujmKe5Xn8TOi8DSMn8HOZLQaxvMqrI/Li3Y8JhSvhvEmuD6PCbey6K6F3dKDGQZGNTscqlnLpxtqm0/vjU/eBNlhptTn/vKsK7czlaAbsR3EhxOE8AGMMeWX/FAQ4o2LTZmDklCidK213eoWG9p31Wla+tjZemEXveYGDAiTkBZXcQf9PhJzE3g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(396003)(346002)(136003)(39860400002)(83380400001)(7696005)(52116002)(6916009)(3716004)(2906002)(16526019)(6506007)(8936002)(478600001)(55016002)(186003)(1076003)(316002)(66946007)(6666004)(4326008)(9686003)(54906003)(7416002)(8676002)(86362001)(66476007)(5660300002)(66556008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Q68rMhyYI2Q1cbyd5E44+2hQbZU/ALuiM+TEBgBPCSKAIMHHF0+b6EceIUIA?=
 =?us-ascii?Q?zlrRb268oetFfI9tfxhaVrUpfPUryTH7GSlZc5M/KC/wYqRBWnc3JNhy7bx1?=
 =?us-ascii?Q?l7fdN9BWFM26wPOAiTSe+Qx5O/poMz+0mDHyXRWHkhqTieHzf/VrxxibQ4aL?=
 =?us-ascii?Q?1h0uZHoOI32W5fsp03Rxz2K/hrbrXFGFa3ZXdXvfMVy0w55XIUm9ASrsXOY3?=
 =?us-ascii?Q?4hQCRIhPU/wXGB/HFAYJe4vPQTnLuFu0pPe24gNz9ejPh71O1j4zbK14wdBk?=
 =?us-ascii?Q?gucUNO3+59ihl6BednkZzGXO5O+SclQYSEmDKNYGmxzanhsma1WTl2+cdINt?=
 =?us-ascii?Q?SgHSLQW6EeUEN/stLyi+wwiOtHQEeKc19Zq05Y/nEKZrOA6UCEoHo+q2czKO?=
 =?us-ascii?Q?NMMa/F+KqwxsERM9dyVwSZeAVfUuQD3FgDAonQ68OrAXe7vr7ZbWyGnf6OQC?=
 =?us-ascii?Q?mAQcorXvUFQm/TTKhgFTPTDE8DOJiNAnp690EU3ZlSpXBtqybsPxL0y+0Xgx?=
 =?us-ascii?Q?3dRwe+bw2PXKSe0cKot8d24Tfa3q5d/GlktgmzAF35qcgGzwmhC5mLTATiSQ?=
 =?us-ascii?Q?PkSojQ2cvd9oaXTLsccmeb53s3vqAsnNSQSC5D/C19Rgbx2IN/k5aqpZpaNY?=
 =?us-ascii?Q?qN1idwxev8SLcUE5c/hREGCEqgk4nY8JDbXWbNDGek+IhVvk1LF7pAc1RodG?=
 =?us-ascii?Q?ZglccoubaHF6w5azApz3tQHdEo2p8yau17n+znnI4iOZnmbBAwdxOA36mfwu?=
 =?us-ascii?Q?dejs9yr2VWNSwx78G87VnJL2k5c62nc7hLFmadUXugZuzDWZjbdmt03YCaPe?=
 =?us-ascii?Q?AP6wwS+CIUfmy5AqVIGEVf3HSHy6oMp0SwaDDrHlrWYgB5g383fPmDq/Ik50?=
 =?us-ascii?Q?0wPV2LZUs7w39B9oPD/xknJh+IGZU7IOmR35zTbrKeSZ8mBKlUOhIqSPKVrZ?=
 =?us-ascii?Q?jceJkbqqtUsDcVxidgaqH/blgBRcMhjOui1nBnuzhFts8JMjHhZq2OoUaKvn?=
 =?us-ascii?Q?BC3yEyOLdRZbk1isaU4BgXE+aQ=3D=3D?=
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2020 01:42:48.3322
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-Network-Message-Id: d40c4a92-af2a-473d-0555-08d898bf122f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kTJYLt1sValMiFqe5XqdbfuvQew+JDY7YUr6h/lFxM5LzkahJkTLvR57tnM1hnJB
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR15MB4235
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-04_13:2020-12-04,2020-12-04 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0 phishscore=0
 suspectscore=5 clxscore=1015 priorityscore=1501 malwarescore=0
 lowpriorityscore=0 impostorscore=0 spamscore=0 mlxscore=0 mlxlogscore=649
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012050008
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 01, 2020 at 11:44:10PM +0900, Kuniyuki Iwashima wrote:
[ ... ]
> diff --git a/net/core/sock_reuseport.c b/net/core/sock_reuseport.c
> index fd133516ac0e..60d7c1f28809 100644
> --- a/net/core/sock_reuseport.c
> +++ b/net/core/sock_reuseport.c
> @@ -216,9 +216,11 @@ int reuseport_add_sock(struct sock *sk, struct sock *sk2, bool bind_inany)
>  }
>  EXPORT_SYMBOL(reuseport_add_sock);
>  
> -void reuseport_detach_sock(struct sock *sk)
> +struct sock *reuseport_detach_sock(struct sock *sk)
>  {
>  	struct sock_reuseport *reuse;
> +	struct bpf_prog *prog;
> +	struct sock *nsk = NULL;
>  	int i;
>  
>  	spin_lock_bh(&reuseport_lock);
> @@ -242,8 +244,12 @@ void reuseport_detach_sock(struct sock *sk)
>  
>  		reuse->num_socks--;
>  		reuse->socks[i] = reuse->socks[reuse->num_socks];
> +		prog = rcu_dereference(reuse->prog);
Is it under rcu_read_lock() here?

>  
>  		if (sk->sk_protocol == IPPROTO_TCP) {
> +			if (reuse->num_socks && !prog)
> +				nsk = i == reuse->num_socks ? reuse->socks[i - 1] : reuse->socks[i];
> +
>  			reuse->num_closed_socks++;
>  			reuse->socks[reuse->max_socks - reuse->num_closed_socks] = sk;
>  		} else {
> @@ -264,6 +270,8 @@ void reuseport_detach_sock(struct sock *sk)
>  		call_rcu(&reuse->rcu, reuseport_free_rcu);
>  out:
>  	spin_unlock_bh(&reuseport_lock);
> +
> +	return nsk;
>  }
>  EXPORT_SYMBOL(reuseport_detach_sock);
>  
> diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
> index 1451aa9712b0..b27241ea96bd 100644
> --- a/net/ipv4/inet_connection_sock.c
> +++ b/net/ipv4/inet_connection_sock.c
> @@ -992,6 +992,36 @@ struct sock *inet_csk_reqsk_queue_add(struct sock *sk,
>  }
>  EXPORT_SYMBOL(inet_csk_reqsk_queue_add);
>  
> +void inet_csk_reqsk_queue_migrate(struct sock *sk, struct sock *nsk)
> +{
> +	struct request_sock_queue *old_accept_queue, *new_accept_queue;
> +
> +	old_accept_queue = &inet_csk(sk)->icsk_accept_queue;
> +	new_accept_queue = &inet_csk(nsk)->icsk_accept_queue;
> +
> +	spin_lock(&old_accept_queue->rskq_lock);
> +	spin_lock(&new_accept_queue->rskq_lock);
I am also not very thrilled on this double spin_lock.
Can this be done in (or like) inet_csk_listen_stop() instead?

> +
> +	if (old_accept_queue->rskq_accept_head) {
> +		if (new_accept_queue->rskq_accept_head)
> +			old_accept_queue->rskq_accept_tail->dl_next =
> +				new_accept_queue->rskq_accept_head;
> +		else
> +			new_accept_queue->rskq_accept_tail = old_accept_queue->rskq_accept_tail;
> +
> +		new_accept_queue->rskq_accept_head = old_accept_queue->rskq_accept_head;
> +		old_accept_queue->rskq_accept_head = NULL;
> +		old_accept_queue->rskq_accept_tail = NULL;
> +
> +		WRITE_ONCE(nsk->sk_ack_backlog, nsk->sk_ack_backlog + sk->sk_ack_backlog);
> +		WRITE_ONCE(sk->sk_ack_backlog, 0);
> +	}
> +
> +	spin_unlock(&new_accept_queue->rskq_lock);
> +	spin_unlock(&old_accept_queue->rskq_lock);
> +}
> +EXPORT_SYMBOL(inet_csk_reqsk_queue_migrate);
> +
>  struct sock *inet_csk_complete_hashdance(struct sock *sk, struct sock *child,
>  					 struct request_sock *req, bool own_req)
>  {
> diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
> index 45fb450b4522..545538a6bfac 100644
> --- a/net/ipv4/inet_hashtables.c
> +++ b/net/ipv4/inet_hashtables.c
> @@ -681,6 +681,7 @@ void inet_unhash(struct sock *sk)
>  {
>  	struct inet_hashinfo *hashinfo = sk->sk_prot->h.hashinfo;
>  	struct inet_listen_hashbucket *ilb = NULL;
> +	struct sock *nsk;
>  	spinlock_t *lock;
>  
>  	if (sk_unhashed(sk))
> @@ -696,8 +697,12 @@ void inet_unhash(struct sock *sk)
>  	if (sk_unhashed(sk))
>  		goto unlock;
>  
> -	if (rcu_access_pointer(sk->sk_reuseport_cb))
> -		reuseport_detach_sock(sk);
> +	if (rcu_access_pointer(sk->sk_reuseport_cb)) {
> +		nsk = reuseport_detach_sock(sk);
> +		if (nsk)
> +			inet_csk_reqsk_queue_migrate(sk, nsk);
> +	}
> +
>  	if (ilb) {
>  		inet_unhash2(hashinfo, sk);
>  		ilb->count--;
> -- 
> 2.17.2 (Apple Git-113)
> 
