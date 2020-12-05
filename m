Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90AD82CF8A0
	for <lists+netdev@lfdr.de>; Sat,  5 Dec 2020 02:34:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726868AbgLEBcQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 20:32:16 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:3022 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725300AbgLEBcP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 20:32:15 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B51PFXZ018810;
        Fri, 4 Dec 2020 17:31:14 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=srfjLgF/Gy9YPsRqjyuH/yb0Tk41GEOXJgn+OGfxKjg=;
 b=KyhXSRlK6Z2ZDF8Y1pWeusSK/7oPAJVQ99bbnu1lQBj9eSwd/tludmydHbAWJ5dFPHw1
 j6cz3lbHMjnk87GfQwxg9KWvTxpoy+NFv2GVGdZCkKP+2MM/8GUAdXBrICBxMZGYH0/P
 KN2PYG/uLz5erZpGmIM6X06f7tWoQOKGSk0= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 356xfr56ck-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 04 Dec 2020 17:31:14 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 4 Dec 2020 17:31:12 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BjbB1aVM1HHLs6QzK+JmYe68WoWiBOk0Xd9WmZKA1XksSowO8h+ddlKIy5t3ZbFVHyQ6FRs3jUtUuXQVKPVQwAnB0ZuHm3nwxQlNa6ChUEDcFQx1rO+NS+ckblARTZwh/xkp1slo3Me7+0EuwvPpwbsCej99T+mR5CqjrlpbyFlJ3ccb7sXJwMK8LfDRTNzOHBHTILGRhh1JHTXwLxRXY4tAUHkLWstC1YW2B9xebVWcywLOBUBlFFAdDHm7VN0sKVMFe1cyTuVFe7wwQdJzEUiK/3x5TQGCff3WKNlP9E49PYn+twJchwovIy7837S+ybSXgw93KeZu+LVaQBsXIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=srfjLgF/Gy9YPsRqjyuH/yb0Tk41GEOXJgn+OGfxKjg=;
 b=U7sWODq9DoZdR1I/4POY2x6FcR6EiUle+GLeVJkdcstjd416VOuwMiesczuw106g/zmcgyUlOzlglNzmn5ZxTUmpHgdeae3oJc220/MlTZ1MjZNxz6/gtyvgNakKklDBHR2xCiG7Ds8Pu1OFPDAA7q9STunUkGYM6pjJg7JW2z3WyQySzvpvp3siSmNYA6BHvAhXAjO6oTg35YI/up0tAHcUVBCJgeycyBfhYGt8VVrZx51eaB+viYs0rtcemfFcXPueLZsobMeayka/NVqpB1THcJmFk6BGODkW/bz0MEYE8Pjil5AAIt+QebmhfMGuHqr6+v8JpasEvQ1YX62jgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=srfjLgF/Gy9YPsRqjyuH/yb0Tk41GEOXJgn+OGfxKjg=;
 b=NZO+NmZwKF58pUj9fzSks5WfIi8T+MN/1gUoeU+5nqAiTQx1s/Jw/cMZbkFSSufpnCb/DnmfUR0lQulRE/EhsHEKhXhHauhQX/QFWh3pR5G/EY1ceCgiaYlUoPhv2UZrCrotooXeqFMrtNAoHZvRiHSyfRZqMPFb5fUForsNJRU=
Authentication-Results: amazon.co.jp; dkim=none (message not signed)
 header.d=none;amazon.co.jp; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB3461.namprd15.prod.outlook.com (2603:10b6:a03:109::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.20; Sat, 5 Dec
 2020 01:31:11 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::2831:21bf:8060:a0b]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::2831:21bf:8060:a0b%7]) with mapi id 15.20.3632.021; Sat, 5 Dec 2020
 01:31:11 +0000
Date:   Fri, 4 Dec 2020 17:31:03 -0800
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
Subject: Re: [PATCH v1 bpf-next 01/11] tcp: Keep TCP_CLOSE sockets in the
 reuseport group.
Message-ID: <20201205013103.eo5chfx57kf25pz3@kafai-mbp.dhcp.thefacebook.com>
References: <20201201144418.35045-1-kuniyu@amazon.co.jp>
 <20201201144418.35045-2-kuniyu@amazon.co.jp>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201201144418.35045-2-kuniyu@amazon.co.jp>
X-Originating-IP: [2620:10d:c090:400::5:4e20]
X-ClientProxiedBy: MWHPR11CA0024.namprd11.prod.outlook.com
 (2603:10b6:301:1::34) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:4e20) by MWHPR11CA0024.namprd11.prod.outlook.com (2603:10b6:301:1::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17 via Frontend Transport; Sat, 5 Dec 2020 01:31:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 160a988a-c036-4a1a-2ee3-08d898bd72a1
X-MS-TrafficTypeDiagnostic: BYAPR15MB3461:
X-Microsoft-Antispam-PRVS: <BYAPR15MB34615ACC47C6D58D54148093D5F00@BYAPR15MB3461.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dY/cQva6iPHQA5hmocb3cS2DRwlkw8SD5Vst4lHwwVDOJ+DFJPNFKQpXwKcWW5Wary71XB3VBybQfqFFU2gBeDBVQ3oOKkh+Un6txKVsXbPWcmdxTQrMvlaFEPpbsWuXwP8Cw97fhCVFxp5+fBd5zSbbR/rJTKLNAWWNpu5OoKGHMymm16d8l+eQroVfGD9jAgPScHfmrtFuoIYYttIYBTYeuWHNIFp85bMhC0CqT87sJTU/Fz/YgWr9P6qZ54diaaRRyoZYu4qv1lBlbDAe+e2AQc2ESJYhON+twjfqA4YKXBgX2VomevRBOj81Sl1EqStkzrUhNmTo3q7dndWFjQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(376002)(39860400002)(366004)(346002)(316002)(55016002)(54906003)(9686003)(83380400001)(86362001)(6666004)(2906002)(52116002)(8936002)(6506007)(478600001)(66476007)(5660300002)(7416002)(66946007)(66556008)(1076003)(4326008)(6916009)(8676002)(7696005)(186003)(16526019);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?/Xxww8Am89bNPS2qK8WjvfYMZRFnBtXGrB2AvyN2z09Bqc0zVCm6PK3e5k+r?=
 =?us-ascii?Q?vI9OhmOiOazOGUTdwW/ZYms7ybnAJN3caK6f6QQLnjlmLgkxy+l0wtgvGW4w?=
 =?us-ascii?Q?A8g2FX7OR1Fz0thsd655JqRBUplhDUrLvpjKayCjntMCpVq596GQOfXyQgmT?=
 =?us-ascii?Q?lhnHkNBpE8abGP8RP1cGLnO7k7KUoOs7t+Ur9IRzE3tXKJxyKtdzpRgxw3Ht?=
 =?us-ascii?Q?uEZwS6h3IykEaFW3kzPP3e8HEjGCDPaXOGKvX4vrrwWj79OVWSBjoTCI5mZo?=
 =?us-ascii?Q?EdHyEvJrSKXbFVNK86fRRqwsFtRgiX3ptuw7wF/u1nAC61n8YIT4ojaHvDLE?=
 =?us-ascii?Q?EON1lbDIm2B1xtoHvdgyqG6iRo9aDLMGrt1atELZHzNtlMQo0Ia7qnR8AIh8?=
 =?us-ascii?Q?FCULnh553ZHoSzcBCpuwGDpwIX5Jefzk7B0I9R7pYux4mKSUSYRzr/Q2AOsM?=
 =?us-ascii?Q?wcrNkcpjekasn7Gd8ZMiXtKvLme5YYq3FOIimCxx5rZJIRVyyl7melMD9gmS?=
 =?us-ascii?Q?L22/5HLeI7vylVjrkp/vDhPHsFybrv+ABjm8M1yIemFPmLcoJfl+dSlHaPHK?=
 =?us-ascii?Q?OsRGlhsyTzXaoFgLk6W6ARkJr1iuWedn/CrR/7LF1CPQtDFW9YVefazpBPdY?=
 =?us-ascii?Q?sga/DrO052j3t4c30fpEi+gSiWyY4dltyk7Cl5xDuOeToYqRJYSohwtnXfwa?=
 =?us-ascii?Q?ux7nzYkSIfvaGBGmlzYUCS9fZE1ilyVUiEHSX+Xl8qim53UG65bpQlkOtgPg?=
 =?us-ascii?Q?25EVDwTByWosrvHkzRtiEiZ9ZPFGJ2zIOLGC7jW0mXKSjsITR4qyJRdFp/33?=
 =?us-ascii?Q?aYBkQSoYEEojgYXAdr7qBn1zrpVmjQBFc6jBo5svIE0cRKm5p/SkIbdeniCB?=
 =?us-ascii?Q?rxdNVg/3erk/8x5esPP5nBAYK8NA8eOlRtsrGLTVxLykLtXXJiy2Ygtxbwfx?=
 =?us-ascii?Q?UQLiUuaysXHABgMNK+x2Rdqjo20B+aczVhJZTaVx1jgUHpE0kfDpJjjh4LYS?=
 =?us-ascii?Q?lf5pO2WB78Fo1YFVvqBztxWcUg=3D=3D?=
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2020 01:31:11.1612
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-Network-Message-Id: 160a988a-c036-4a1a-2ee3-08d898bd72a1
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v6sM37k6NurSHDTZPCZtHKRmoBOQxte5znsW/P6FsTqvY3X+zoOg8VA7bWT4iUrx
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3461
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-04_13:2020-12-04,2020-12-04 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0 adultscore=0
 priorityscore=1501 spamscore=0 mlxlogscore=999 mlxscore=0 clxscore=1015
 impostorscore=0 lowpriorityscore=0 malwarescore=0 phishscore=0
 suspectscore=5 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012050006
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 01, 2020 at 11:44:08PM +0900, Kuniyuki Iwashima wrote:
> This patch is a preparation patch to migrate incoming connections in the
> later commits and adds a field (num_closed_socks) to the struct
> sock_reuseport to keep TCP_CLOSE sockets in the reuseport group.
> 
> When we close a listening socket, to migrate its connections to another
> listener in the same reuseport group, we have to handle two kinds of child
> sockets. One is that a listening socket has a reference to, and the other
> is not.
> 
> The former is the TCP_ESTABLISHED/TCP_SYN_RECV sockets, and they are in the
> accept queue of their listening socket. So, we can pop them out and push
> them into another listener's queue at close() or shutdown() syscalls. On
> the other hand, the latter, the TCP_NEW_SYN_RECV socket is during the
> three-way handshake and not in the accept queue. Thus, we cannot access
> such sockets at close() or shutdown() syscalls. Accordingly, we have to
> migrate immature sockets after their listening socket has been closed.
> 
> Currently, if their listening socket has been closed, TCP_NEW_SYN_RECV
> sockets are freed at receiving the final ACK or retransmitting SYN+ACKs. At
> that time, if we could select a new listener from the same reuseport group,
> no connection would be aborted. However, it is impossible because
> reuseport_detach_sock() sets NULL to sk_reuseport_cb and forbids access to
> the reuseport group from closed sockets.
> 
> This patch allows TCP_CLOSE sockets to remain in the reuseport group and to
> have access to it while any child socket references to them. The point is
> that reuseport_detach_sock() is called twice from inet_unhash() and
> sk_destruct(). At first, it moves the socket backwards in socks[] and
> increments num_closed_socks. Later, when all migrated connections are
> accepted, it removes the socket from socks[], decrements num_closed_socks,
> and sets NULL to sk_reuseport_cb.
> 
> By this change, closed sockets can keep sk_reuseport_cb until all child
> requests have been freed or accepted. Consequently calling listen() after
> shutdown() can cause EADDRINUSE or EBUSY in reuseport_add_sock() or
> inet_csk_bind_conflict() which expect that such sockets should not have the
> reuseport group. Therefore, this patch also loosens such validation rules
> so that the socket can listen again if it has the same reuseport group with
> other listening sockets.
> 
> Reviewed-by: Benjamin Herrenschmidt <benh@amazon.com>
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
> ---
>  include/net/sock_reuseport.h    |  5 ++-
>  net/core/sock_reuseport.c       | 79 +++++++++++++++++++++++++++------
>  net/ipv4/inet_connection_sock.c |  7 ++-
>  3 files changed, 74 insertions(+), 17 deletions(-)
> 
> diff --git a/include/net/sock_reuseport.h b/include/net/sock_reuseport.h
> index 505f1e18e9bf..0e558ca7afbf 100644
> --- a/include/net/sock_reuseport.h
> +++ b/include/net/sock_reuseport.h
> @@ -13,8 +13,9 @@ extern spinlock_t reuseport_lock;
>  struct sock_reuseport {
>  	struct rcu_head		rcu;
>  
> -	u16			max_socks;	/* length of socks */
> -	u16			num_socks;	/* elements in socks */
> +	u16			max_socks;		/* length of socks */
> +	u16			num_socks;		/* elements in socks */
> +	u16			num_closed_socks;	/* closed elements in socks */
>  	/* The last synq overflow event timestamp of this
>  	 * reuse->socks[] group.
>  	 */
> diff --git a/net/core/sock_reuseport.c b/net/core/sock_reuseport.c
> index bbdd3c7b6cb5..fd133516ac0e 100644
> --- a/net/core/sock_reuseport.c
> +++ b/net/core/sock_reuseport.c
> @@ -98,16 +98,21 @@ static struct sock_reuseport *reuseport_grow(struct sock_reuseport *reuse)
>  		return NULL;
>  
>  	more_reuse->num_socks = reuse->num_socks;
> +	more_reuse->num_closed_socks = reuse->num_closed_socks;
>  	more_reuse->prog = reuse->prog;
>  	more_reuse->reuseport_id = reuse->reuseport_id;
>  	more_reuse->bind_inany = reuse->bind_inany;
>  	more_reuse->has_conns = reuse->has_conns;
> +	more_reuse->synq_overflow_ts = READ_ONCE(reuse->synq_overflow_ts);
>  
>  	memcpy(more_reuse->socks, reuse->socks,
>  	       reuse->num_socks * sizeof(struct sock *));
> -	more_reuse->synq_overflow_ts = READ_ONCE(reuse->synq_overflow_ts);
> +	memcpy(more_reuse->socks +
> +	       (more_reuse->max_socks - more_reuse->num_closed_socks),
> +	       reuse->socks + reuse->num_socks,
> +	       reuse->num_closed_socks * sizeof(struct sock *));
>  
> -	for (i = 0; i < reuse->num_socks; ++i)
> +	for (i = 0; i < reuse->max_socks; ++i)
>  		rcu_assign_pointer(reuse->socks[i]->sk_reuseport_cb,
>  				   more_reuse);
>  
> @@ -129,6 +134,25 @@ static void reuseport_free_rcu(struct rcu_head *head)
>  	kfree(reuse);
>  }
>  
> +static int reuseport_sock_index(struct sock_reuseport *reuse, struct sock *sk,
> +				bool closed)
> +{
> +	int left, right;
> +
> +	if (!closed) {
> +		left = 0;
> +		right = reuse->num_socks;
> +	} else {
> +		left = reuse->max_socks - reuse->num_closed_socks;
> +		right = reuse->max_socks;
> +	}
> +
> +	for (; left < right; left++)
> +		if (reuse->socks[left] == sk)
> +			return left;
> +	return -1;
> +}
> +
>  /**
>   *  reuseport_add_sock - Add a socket to the reuseport group of another.
>   *  @sk:  New socket to add to the group.
> @@ -153,12 +177,23 @@ int reuseport_add_sock(struct sock *sk, struct sock *sk2, bool bind_inany)
>  					  lockdep_is_held(&reuseport_lock));
>  	old_reuse = rcu_dereference_protected(sk->sk_reuseport_cb,
>  					     lockdep_is_held(&reuseport_lock));
> -	if (old_reuse && old_reuse->num_socks != 1) {
> +
> +	if (old_reuse == reuse) {
> +		int i = reuseport_sock_index(reuse, sk, true);
> +
> +		if (i == -1) {
When will this happen?

I found the new logic in the closed sk shuffling within socks[] quite
complicated to read.  I can see why the closed sk wants to keep its
sk->sk_reuseport_cb.  However, does it need to stay
in socks[]?


> +			spin_unlock_bh(&reuseport_lock);
> +			return -EBUSY;
> +		}
> +
> +		reuse->socks[i] = reuse->socks[reuse->max_socks - reuse->num_closed_socks];
> +		reuse->num_closed_socks--;
> +	} else if (old_reuse && old_reuse->num_socks != 1) {
>  		spin_unlock_bh(&reuseport_lock);
>  		return -EBUSY;
>  	}
>  
> -	if (reuse->num_socks == reuse->max_socks) {
> +	if (reuse->num_socks + reuse->num_closed_socks == reuse->max_socks) {
>  		reuse = reuseport_grow(reuse);
>  		if (!reuse) {
>  			spin_unlock_bh(&reuseport_lock);
