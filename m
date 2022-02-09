Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 067A04AF5F1
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 17:02:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236431AbiBIQCh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 11:02:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231135AbiBIQCg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 11:02:36 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5868C0613C9;
        Wed,  9 Feb 2022 08:02:39 -0800 (PST)
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 219EM8aB015595;
        Wed, 9 Feb 2022 16:02:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=GfcpnRbDd1SuVigiQfI/wod0FStopRogiADx+8bl1wg=;
 b=HVApvjyBaUSWqUlxMGX17AkNK+Mv2IXlvRbQvIj6mGrvrTZsgwiDmUXLqlh69Y7Ch3Mr
 fK+Kh4sWxEiyHiZCyk337sN1M6wfGEf+MzXzoXlvrb37gqLL+N8vIkgnV0HKhIWLbFQb
 ZYjOMJeuJKgXVfojt6dWBwRMWsvutyoCbeM+n3fmK0cqoeRqwPhUI7eUgf546EqSRf4T
 hgLLu4HIE2RX4yGjIYbQXAPyr81lxrKOSngcoFterSPPrkz+VlQWK3pQypyTQaJsUqyB
 Q+yNv8k5K+tpN3T21k5nNBRAEpq1U/gtknv2rMMNGrLKQ4i+AWhu8eMuMUVV2TdEP2xc vA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e4b0x0af1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Feb 2022 16:02:37 +0000
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 219FeWCo017581;
        Wed, 9 Feb 2022 16:02:36 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e4b0x0adv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Feb 2022 16:02:36 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 219FvT14002502;
        Wed, 9 Feb 2022 16:02:33 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma02fra.de.ibm.com with ESMTP id 3e1gv9pvgh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Feb 2022 16:02:33 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 219G2V3T42271074
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 9 Feb 2022 16:02:31 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 387DA11C058;
        Wed,  9 Feb 2022 16:02:31 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DA5BC11C05E;
        Wed,  9 Feb 2022 16:02:30 +0000 (GMT)
Received: from [9.145.0.171] (unknown [9.145.0.171])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  9 Feb 2022 16:02:30 +0000 (GMT)
Message-ID: <ed4c056d-03ee-d825-845d-a9e5b4d58c26@linux.ibm.com>
Date:   Wed, 9 Feb 2022 17:02:32 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH net-next v6 2/5] net/smc: Limit backlog connections
Content-Language: en-US
To:     "D. Wythe" <alibuda@linux.alibaba.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
References: <cover.1644413637.git.alibuda@linux.alibaba.com>
 <412a5ddd496c5966a8910435a33552c78868d86d.1644413637.git.alibuda@linux.alibaba.com>
From:   Karsten Graul <kgraul@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <412a5ddd496c5966a8910435a33552c78868d86d.1644413637.git.alibuda@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: hKaDT6e0kzOSZmWwVi8NcWcLA5ZkupAz
X-Proofpoint-ORIG-GUID: jA1SBz_Uf0PA_hDVDyC9qsV2hnSpvlJ0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-09_08,2022-02-09_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 clxscore=1015
 mlxscore=0 suspectscore=0 adultscore=0 priorityscore=1501 impostorscore=0
 phishscore=0 bulkscore=0 mlxlogscore=999 spamscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202090090
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09/02/2022 15:11, D. Wythe wrote:
> +static struct sock *smc_tcp_syn_recv_sock(const struct sock *sk, struct sk_buff *skb,
> +					  struct request_sock *req,
> +					  struct dst_entry *dst,
> +					  struct request_sock *req_unhash,
> +					  bool *own_req)
> +{
> +	struct smc_sock *smc;
> +
> +	smc = (struct smc_sock *)((uintptr_t)sk->sk_user_data & ~SK_USER_DATA_NOCOPY);

Did you run checkpatch.pl for these patches, for me this and other lines look longer 
than 80 characters.

> +
> +	if (READ_ONCE(sk->sk_ack_backlog) + atomic_read(&smc->smc_pendings) >
> +				sk->sk_max_ack_backlog)
> +		goto drop;
> +
> +	if (sk_acceptq_is_full(&smc->sk)) {
> +		NET_INC_STATS(sock_net(sk), LINUX_MIB_LISTENOVERFLOWS);
> +		goto drop;
> +	}
> +
> +	/* passthrough to origin syn recv sock fct */
> +	return smc->ori_af_ops->syn_recv_sock(sk, skb, req, dst, req_unhash, own_req);
> +
> +drop:
> +	dst_release(dst);
> +	tcp_listendrop(sk);
> +	return NULL;
> +}
> +
>  static struct smc_hashinfo smc_v4_hashinfo = {
>  	.lock = __RW_LOCK_UNLOCKED(smc_v4_hashinfo.lock),
>  };
> @@ -1595,6 +1623,9 @@ static void smc_listen_out(struct smc_sock *new_smc)
>  	struct smc_sock *lsmc = new_smc->listen_smc;
>  	struct sock *newsmcsk = &new_smc->sk;
>  
> +	if (tcp_sk(new_smc->clcsock->sk)->syn_smc)
> +		atomic_dec(&lsmc->smc_pendings);
> +
>  	if (lsmc->sk.sk_state == SMC_LISTEN) {
>  		lock_sock_nested(&lsmc->sk, SINGLE_DEPTH_NESTING);
>  		smc_accept_enqueue(&lsmc->sk, newsmcsk);
> @@ -2200,6 +2231,9 @@ static void smc_tcp_listen_work(struct work_struct *work)
>  		if (!new_smc)
>  			continue;
>  
> +		if (tcp_sk(new_smc->clcsock->sk)->syn_smc)
> +			atomic_inc(&lsmc->smc_pendings);
> +
>  		new_smc->listen_smc = lsmc;
>  		new_smc->use_fallback = lsmc->use_fallback;
>  		new_smc->fallback_rsn = lsmc->fallback_rsn;
> @@ -2266,6 +2300,15 @@ static int smc_listen(struct socket *sock, int backlog)
>  	smc->clcsock->sk->sk_data_ready = smc_clcsock_data_ready;
>  	smc->clcsock->sk->sk_user_data =
>  		(void *)((uintptr_t)smc | SK_USER_DATA_NOCOPY);
> +
> +	/* save origin ops */
> +	smc->ori_af_ops = inet_csk(smc->clcsock->sk)->icsk_af_ops;
> +
> +	smc->af_ops = *smc->ori_af_ops;
> +	smc->af_ops.syn_recv_sock = smc_tcp_syn_recv_sock;
> +
> +	inet_csk(smc->clcsock->sk)->icsk_af_ops = &smc->af_ops;
> +
>  	rc = kernel_listen(smc->clcsock, backlog);
>  	if (rc) {
>  		smc->clcsock->sk->sk_data_ready = smc->clcsk_data_ready;
> diff --git a/net/smc/smc.h b/net/smc/smc.h
> index 37b2001..5e5e38d 100644
> --- a/net/smc/smc.h
> +++ b/net/smc/smc.h
> @@ -252,6 +252,10 @@ struct smc_sock {				/* smc sock container */
>  	bool			use_fallback;	/* fallback to tcp */
>  	int			fallback_rsn;	/* reason for fallback */
>  	u32			peer_diagnosis; /* decline reason from peer */
> +	atomic_t                smc_pendings;   /* pending smc connections */

I don't like the name smc_pendings, its not very specific. 
What about queued_smc_hs?
And for the comment: queued smc handshakes

> +	struct inet_connection_sock_af_ops		af_ops;
> +	const struct inet_connection_sock_af_ops	*ori_af_ops;
> +						/* origin af ops */
origin -> original
>  	int			sockopt_defer_accept;
>  						/* sockopt TCP_DEFER_ACCEPT
>  						 * value

-- 
Karsten
