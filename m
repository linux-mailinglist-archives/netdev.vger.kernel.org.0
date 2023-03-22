Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52F9D6C51F1
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 18:10:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230060AbjCVRKB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 13:10:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229768AbjCVRKA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 13:10:00 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A84C212872;
        Wed, 22 Mar 2023 10:09:58 -0700 (PDT)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32MGt5lZ030391;
        Wed, 22 Mar 2023 17:09:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=vf706j/q8zAoF+Y1g3q6v/SeTXyELu+wV3+Yl/NGnK8=;
 b=Mi+gKx+0/fo8w72jO9ASKKswlWVlhYzh7hUBWbd3CNKc67aqGNIL7UdEHcujkLQrF42+
 Cxcn/hqFO5E8S/6sCpydpn68Of9fCwDxMNuGWRlvPfX+ByoIXFlUZiGn6wZHk+zO1Z8L
 tPdGkW2HVE1oMlBLBBQrvmiB5uhQbEscSjbjF30B+E4pBjwxKkuFww9bqONacfpidodV
 3HeUf/6VVgE96omKZLW8a7CEVk462LE3BoSWaCH6fY7QQ3r2wPXVhVQrVQ5O81B0RR4F
 LiFL1E1bQIyrL4PlZhkqcJlLK8VPm1eVcz+hBdGpceX1crxboszdrj7cp24oyVUFrBIF vg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pg5m70hsf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Mar 2023 17:09:47 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32MGtF9i030718;
        Wed, 22 Mar 2023 17:09:47 GMT
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pg5m70hrc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Mar 2023 17:09:46 +0000
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32MG5XA7014977;
        Wed, 22 Mar 2023 17:09:45 GMT
Received: from smtprelay04.dal12v.mail.ibm.com ([9.208.130.102])
        by ppma01dal.us.ibm.com (PPS) with ESMTPS id 3pd4x7qp5r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Mar 2023 17:09:45 +0000
Received: from smtpav05.wdc07v.mail.ibm.com (smtpav05.wdc07v.mail.ibm.com [10.39.53.232])
        by smtprelay04.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32MH9iDB11272720
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Mar 2023 17:09:44 GMT
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 25B2358053;
        Wed, 22 Mar 2023 17:09:44 +0000 (GMT)
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4287D5805D;
        Wed, 22 Mar 2023 17:09:42 +0000 (GMT)
Received: from [9.163.26.126] (unknown [9.163.26.126])
        by smtpav05.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 22 Mar 2023 17:09:42 +0000 (GMT)
Message-ID: <170b35d9-2071-caf3-094e-6abfb7cefa75@linux.ibm.com>
Date:   Wed, 22 Mar 2023 18:09:41 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.9.0
Subject: Re: [PATCH net-next] net/smc: introduce shadow sockets for fallback
 connections
To:     Kai Shen <KaiShen@linux.alibaba.com>, kgraul@linux.ibm.com,
        jaka@linux.ibm.com, kuba@kernel.org, davem@davemloft.net,
        dsahern@kernel.org
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org
References: <20230321071959.87786-1-KaiShen@linux.alibaba.com>
From:   Wenjia Zhang <wenjia@linux.ibm.com>
In-Reply-To: <20230321071959.87786-1-KaiShen@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: bP6G5GaKNxIDsWoie4owz1UXHITzbQUR
X-Proofpoint-ORIG-GUID: n13PFWurJKxknnqg_Q9H7v6nQ-U9_SRm
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-22_13,2023-03-22_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0 mlxscore=0
 malwarescore=0 adultscore=0 clxscore=1015 bulkscore=0 spamscore=0
 priorityscore=1501 mlxlogscore=999 impostorscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303150002 definitions=main-2303220117
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 21.03.23 08:19, Kai Shen wrote:
> SMC-R performs not so well on fallback situations right now,
> especially on short link server fallback occasions. We are planning
> to make SMC-R widely used and handling this fallback performance
> issue is really crucial to us. Here we introduce a shadow socket
> method to try to relief this problem.
> 
Could you please elaborate the problem?
> Basicly, we use two more accept queues to hold incoming connections,
> one for fallback connections and the other for smc-r connections.
> We implement this method by using two more 'shadow' sockets and
> make the connection path of fallback connections almost the same as
> normal tcp connections.
> 
> Now the SMC-R accept path is like:
>    1. incoming connection
>    2. schedule work to smc sock alloc, tcp accept and push to smc
>       acceptq
>    3. wake up user to accept
> 
> When fallback happens on servers, the accepting path is the same
> which costs more than normal tcp accept path. In fallback
> situations, the step 2 above is not necessary and the smc sock is
> also not needed. So we use two more shadow sockets when one smc
> socket start listening. When new connection comes, we pop the req
> to the fallback socket acceptq or the non-fallback socket acceptq
> according to its syn_smc flag. As a result, when fallback happen we
> can graft the user socket with a normal tcp sock instead of a smc
> sock and get rid of the cost generated by step 2 and smc sock
> releasing.
> 
>                 +-----> non-fallback socket acceptq
>                 |
> incoming req --+
>                 |
>                 +-----> fallback socket acceptq
> 
> With the help of shadow socket, we gain similar performance as tcp
> connections on short link nginx server fallback occasions as what
> is illustrated below.
> 
> Cases are like "./wrk http://x.x.x.x:x/
> 	-H 'Connection: Close' -c 1600 -t 32 -d 20 --latency"
> 
> TCP:
>      Requests/sec: 145438.65
>      Transfer/sec:     21.64MB
> 
> Server fallback occasions on original SMC-R:
>      Requests/sec: 114192.82
>      Transfer/sec:     16.99MB
> 
> Server fallback occasions on SMC-R with shadow sockets:
>      Requests/sec: 143528.11
>      Transfer/sec:     21.35MB
> 

Generally, I don't have a good feeling about the two non-listenning 
sockets, and I can not see why it is necessary to introduce the socket 
actsock instead of using the clcsock itself. Maybe you can convince me 
with a good reason.

> On the other hand, as a result of using another accept queue, the
> fastopenq lock is not the right lock to access when accepting. So
> we need to find the right fastopenq lock in inet_csk_accept.
> 
> Signed-off-by: Kai Shen <KaiShen@linux.alibaba.com>
> ---
>   net/ipv4/inet_connection_sock.c |  13 ++-
>   net/smc/af_smc.c                | 143 ++++++++++++++++++++++++++++++--
>   net/smc/smc.h                   |   2 +
>   3 files changed, 150 insertions(+), 8 deletions(-)
> 
> diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
> index 65ad4251f6fd..ba2ec5ad4c04 100644
> --- a/net/ipv4/inet_connection_sock.c
> +++ b/net/ipv4/inet_connection_sock.c
> @@ -658,6 +658,7 @@ struct sock *inet_csk_accept(struct sock *sk, int flags, int *err, bool kern)
>   {
>   	struct inet_connection_sock *icsk = inet_csk(sk);
>   	struct request_sock_queue *queue = &icsk->icsk_accept_queue;
> +	spinlock_t *fastopenq_lock = &queue->fastopenq.lock;
>   	struct request_sock *req;
>   	struct sock *newsk;
>   	int error;
> @@ -689,7 +690,15 @@ struct sock *inet_csk_accept(struct sock *sk, int flags, int *err, bool kern)
>   
>   	if (sk->sk_protocol == IPPROTO_TCP &&
>   	    tcp_rsk(req)->tfo_listener) {
> -		spin_lock_bh(&queue->fastopenq.lock);
> +#if IS_ENABLED(CONFIG_SMC)
> +		if (tcp_sk(sk)->syn_smc) {
> +			struct request_sock_queue *orig_queue;
> +
> +			orig_queue = &inet_csk(req->rsk_listener)->icsk_accept_queue;
> +			fastopenq_lock = &orig_queue->fastopenq.lock;
> +		}
> +#endif
> +		spin_lock_bh(fastopenq_lock);
>   		if (tcp_rsk(req)->tfo_listener) {
>   			/* We are still waiting for the final ACK from 3WHS
>   			 * so can't free req now. Instead, we set req->sk to
> @@ -700,7 +709,7 @@ struct sock *inet_csk_accept(struct sock *sk, int flags, int *err, bool kern)
>   			req->sk = NULL;
>   			req = NULL;
>   		}
> -		spin_unlock_bh(&queue->fastopenq.lock);
> +		spin_unlock_bh(fastopenq_lock);
>   	}
>   
>   out:
> diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
> index a4cccdfdc00a..ad6c3b9ec9a6 100644
> --- a/net/smc/af_smc.c
> +++ b/net/smc/af_smc.c
> @@ -126,7 +126,9 @@ static struct sock *smc_tcp_syn_recv_sock(const struct sock *sk,
>   
>   	smc = smc_clcsock_user_data(sk);
>   
> -	if (READ_ONCE(sk->sk_ack_backlog) + atomic_read(&smc->queued_smc_hs) >
> +	if (READ_ONCE(sk->sk_ack_backlog) + atomic_read(&smc->queued_smc_hs)
> +			+ READ_ONCE(smc->actsock->sk->sk_ack_backlog)
> +			+ READ_ONCE(smc->fbsock->sk->sk_ack_backlog) >
>   				sk->sk_max_ack_backlog)
>   		goto drop;
>   
> @@ -286,6 +288,10 @@ static int __smc_release(struct smc_sock *smc)
>   				/* wake up clcsock accept */
>   				rc = kernel_sock_shutdown(smc->clcsock,
>   							  SHUT_RDWR);
> +				if (smc->fbsock)
> +					sock_release(smc->fbsock);
> +				if (smc->actsock)
> +					sock_release(smc->actsock);
>   			}
>   			sk->sk_state = SMC_CLOSED;
>   			sk->sk_state_change(sk);
> @@ -1681,7 +1687,7 @@ static int smc_clcsock_accept(struct smc_sock *lsmc, struct smc_sock **new_smc)
>   
>   	mutex_lock(&lsmc->clcsock_release_lock);
>   	if (lsmc->clcsock)
> -		rc = kernel_accept(lsmc->clcsock, &new_clcsock, SOCK_NONBLOCK);
> +		rc = kernel_accept(lsmc->actsock, &new_clcsock, SOCK_NONBLOCK);
>   	mutex_unlock(&lsmc->clcsock_release_lock);
>   	lock_sock(lsk);
>   	if  (rc < 0 && rc != -EAGAIN)
> @@ -2486,9 +2492,46 @@ static void smc_tcp_listen_work(struct work_struct *work)
>   	sock_put(&lsmc->sk); /* sock_hold in smc_clcsock_data_ready() */
>   }
>   
> +#define SMC_LINK 1
> +#define FALLBACK_LINK 2
> +static inline int smc_sock_pop_to_another_acceptq(struct smc_sock *lsmc)
> +{
> +	struct sock *lsk = lsmc->clcsock->sk;
> +	struct inet_connection_sock *icsk = inet_csk(lsk);
> +	struct inet_connection_sock *dest_icsk;
> +	struct request_sock_queue *queue = &icsk->icsk_accept_queue;
> +	struct request_sock_queue *dest_queue;
> +	struct request_sock *req;
> +	struct sock *dst_sock;
> +	int ret;
> +
> +	req = reqsk_queue_remove(queue, lsk);
> +	if (!req)
> +		return -EINVAL;
> +
> +	if (tcp_sk(req->sk)->syn_smc || lsmc->sockopt_defer_accept) {
> +		dst_sock = lsmc->actsock->sk;
> +		ret = SMC_LINK;
> +	} else {
> +		dst_sock = lsmc->fbsock->sk;
> +		ret = FALLBACK_LINK;
> +	}
> +
> +	dest_icsk = inet_csk(dst_sock);
> +	dest_queue = &dest_icsk->icsk_accept_queue;
> +
> +	spin_lock_bh(&dest_queue->rskq_lock);
> +	WRITE_ONCE(req->dl_next, dest_queue->rskq_accept_head);
> +	sk_acceptq_added(dst_sock);
> +	dest_queue->rskq_accept_head = req;
> +	spin_unlock_bh(&dest_queue->rskq_lock);
> +	return ret;
> +}
> +
>   static void smc_clcsock_data_ready(struct sock *listen_clcsock)
>   {
>   	struct smc_sock *lsmc;
> +	int ret;
>   
>   	read_lock_bh(&listen_clcsock->sk_callback_lock);
>   	lsmc = smc_clcsock_user_data(listen_clcsock);
> @@ -2496,14 +2539,41 @@ static void smc_clcsock_data_ready(struct sock *listen_clcsock)
>   		goto out;
>   	lsmc->clcsk_data_ready(listen_clcsock);
>   	if (lsmc->sk.sk_state == SMC_LISTEN) {
> -		sock_hold(&lsmc->sk); /* sock_put in smc_tcp_listen_work() */
> -		if (!queue_work(smc_tcp_ls_wq, &lsmc->tcp_listen_work)) > -			sock_put(&lsmc->sk);
> +		ret = smc_sock_pop_to_another_acceptq(lsmc);
> +		if (ret == SMC_LINK) {
> +			sock_hold(&lsmc->sk); /* sock_put in smc_tcp_listen_work() */
> +			if (!queue_work(smc_tcp_ls_wq, &lsmc->tcp_listen_work))
> +				sock_put(&lsmc->sk);
> +		} else if (ret == FALLBACK_LINK) {
> +			lsmc->sk.sk_data_ready(&lsmc->sk);
> +		}
>   	}
>   out:
>   	read_unlock_bh(&listen_clcsock->sk_callback_lock);
>   }
>   
> +static void smc_shadow_socket_init(struct socket *sock)
> +{
> +	struct inet_connection_sock *icsk = inet_csk(sock->sk);
> +	struct request_sock_queue *queue = &icsk->icsk_accept_queue;
> +
> +	tcp_set_state(sock->sk, TCP_LISTEN);
> +	sock->sk->sk_ack_backlog = 0;
> +
> +	inet_csk_delack_init(sock->sk);
> +
> +	spin_lock_init(&queue->rskq_lock);
> +
> +	spin_lock_init(&queue->fastopenq.lock);
> +	queue->fastopenq.rskq_rst_head = NULL;
> +	queue->fastopenq.rskq_rst_tail = NULL;
> +	queue->fastopenq.qlen = 0;
> +
> +	queue->rskq_accept_head = NULL;
> +
> +	tcp_sk(sock->sk)->syn_smc = 1;
> +}
> +
>   static int smc_listen(struct socket *sock, int backlog)
>   {
>   	struct sock *sk = sock->sk;
> @@ -2551,6 +2621,18 @@ static int smc_listen(struct socket *sock, int backlog)
>   	if (smc->limit_smc_hs)
>   		tcp_sk(smc->clcsock->sk)->smc_hs_congested = smc_hs_congested;
>   
> +	rc = sock_create_kern(sock_net(sk), PF_INET, SOCK_STREAM, IPPROTO_TCP,
> +			      &smc->fbsock);
> +	if (rc)
> +		goto out;
> +	smc_shadow_socket_init(smc->fbsock);
> +
> +	rc = sock_create_kern(sock_net(sk), PF_INET, SOCK_STREAM, IPPROTO_TCP,
> +			      &smc->actsock);
> +	if (rc)
> +		goto out;
> +	smc_shadow_socket_init(smc->actsock);
> +
>   	rc = kernel_listen(smc->clcsock, backlog);
>   	if (rc) {
>   		write_lock_bh(&smc->clcsock->sk->sk_callback_lock);
> @@ -2569,6 +2651,30 @@ static int smc_listen(struct socket *sock, int backlog)
>   	return rc;
>   }
>   
> +static inline bool tcp_reqsk_queue_empty(struct sock *sk)
> +{
> +	struct inet_connection_sock *icsk = inet_csk(sk);
> +	struct request_sock_queue *queue = &icsk->icsk_accept_queue;
> +
> +	return reqsk_queue_empty(queue);
> +}
> +
Since this is only used by smc, I'd like to suggest to use 
smc_tcp_reqsk_queue_empty instead of tcp_reqsk_queue_empty.

> +static inline void
> +smc_restore_fbsock_protocol_family(struct socket *new_sock, struct socket *sock)
> +{
> +	struct smc_sock *lsmc = smc_sk(sock->sk);
> +
> +	new_sock->sk->sk_data_ready = lsmc->fbsock->sk->sk_data_ready;
> +	new_sock->ops = lsmc->fbsock->ops;
> +	new_sock->type = lsmc->fbsock->type;
> +
> +	module_put(sock->ops->owner);
> +	__module_get(new_sock->ops->owner);
> +
> +	if (tcp_sk(new_sock->sk)->syn_smc)
> +		pr_err("new sock is not fallback.\n");
> +}
> +
>   static int smc_accept(struct socket *sock, struct socket *new_sock,
>   		      int flags, bool kern)
>   {
> @@ -2579,6 +2685,18 @@ static int smc_accept(struct socket *sock, struct socket *new_sock,
>   	int rc = 0;
>   
>   	lsmc = smc_sk(sk);
> +	/* There is a lock in inet_csk_accept, so to make a fast path we do not lock_sock here */
> +	if (lsmc->sk.sk_state == SMC_LISTEN && !tcp_reqsk_queue_empty(lsmc->fbsock->sk)) {
> +		rc = lsmc->clcsock->ops->accept(lsmc->fbsock, new_sock, O_NONBLOCK, true);
> +		if (rc == -EAGAIN)
> +			goto normal_path;
> +		if (rc < 0)
> +			return rc;
> +		smc_restore_fbsock_protocol_family(new_sock, sock);
> +		return rc;
> +	}
> +
> +normal_path:
>   	sock_hold(sk); /* sock_put below */
>   	lock_sock(sk);
>   
> @@ -2593,6 +2711,18 @@ static int smc_accept(struct socket *sock, struct socket *new_sock,
>   	add_wait_queue_exclusive(sk_sleep(sk), &wait);
>   	while (!(nsk = smc_accept_dequeue(sk, new_sock))) {
>   		set_current_state(TASK_INTERRUPTIBLE);
> +		if (!tcp_reqsk_queue_empty(lsmc->fbsock->sk)) {
> +			rc = lsmc->clcsock->ops->accept(lsmc->fbsock, new_sock, O_NONBLOCK, true);
> +			if (rc == -EAGAIN)
> +				goto next_round;
> +			if (rc < 0)
> +				break;
> +
> +			smc_restore_fbsock_protocol_family(new_sock, sock);
> +			nsk = new_sock->sk;
> +			break;
> +		}
> +next_round:
>   		if (!timeo) {
>   			rc = -EAGAIN;
>   			break;
> @@ -2731,7 +2861,8 @@ static __poll_t smc_accept_poll(struct sock *parent)
>   	__poll_t mask = 0;
>   
>   	spin_lock(&isk->accept_q_lock);
> -	if (!list_empty(&isk->accept_q))
> +	if (!list_empty(&isk->accept_q) ||
> +	    !reqsk_queue_empty(&inet_csk(isk->fbsock->sk)->icsk_accept_queue))
>   		mask = EPOLLIN | EPOLLRDNORM;
>   	spin_unlock(&isk->accept_q_lock);
>   
> diff --git a/net/smc/smc.h b/net/smc/smc.h
> index 5ed765ea0c73..9a62c8f37e26 100644
> --- a/net/smc/smc.h
> +++ b/net/smc/smc.h
> @@ -241,6 +241,8 @@ struct smc_connection {
>   struct smc_sock {				/* smc sock container */
>   	struct sock		sk;
>   	struct socket		*clcsock;	/* internal tcp socket */
> +	struct socket		*fbsock;	/* socket for fallback connection */
> +	struct socket		*actsock;	/* socket for non-fallback conneciotn */
>   	void			(*clcsk_state_change)(struct sock *sk);
>   						/* original stat_change fct. */
>   	void			(*clcsk_data_ready)(struct sock *sk);
