Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0EFF99D725
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 22:00:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387406AbfHZUAx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 16:00:53 -0400
Received: from mx0a-00190b01.pphosted.com ([67.231.149.131]:49608 "EHLO
        mx0a-00190b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732784AbfHZUAx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Aug 2019 16:00:53 -0400
Received: from pps.filterd (m0050095.ppops.net [127.0.0.1])
        by m0050095.ppops.net-00190b01. (8.16.0.42/8.16.0.42) with SMTP id x7QJl0E2001088;
        Mon, 26 Aug 2019 21:00:47 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=jan2016.eng;
 bh=ilkcEUxhytx2Ptl1Dl3Qap25YRWoxTUzUvNkKrr+OaM=;
 b=DwI01TYctbI3cpMNJBA/+CnXtW0DeVW15QD2jLGMhUH8Txjg5bogityf70ryddgvttAq
 uJzFpt8qzpHKvvoOCgSS/NexjRD1ixnbcJtw58PsGD73WtjJ5v+qKa24nxY84tb1JZYf
 eLteHpdnFDO27HMd7lUXfZxq9HQBUZfPZMoknNdn6g4FLaYJDD+PhlzaUP3bW7PesVtz
 bHMwKyMRFlxevz16IS+LqsX+/Dan0P/+3ofSpOWvp/+uO8yQLKw+LvaqwZZ0SF9Ybbpc
 DKGIcj0BSfeAO/DeQzYlFvt6sP4CQLuERQ1ttpm6UpLAApyoqWK6hPExlzVBq/RVPMdS 1g== 
Received: from prod-mail-ppoint5 (prod-mail-ppoint5.akamai.com [184.51.33.60] (may be forged))
        by m0050095.ppops.net-00190b01. with ESMTP id 2ujwcahv8s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 26 Aug 2019 21:00:46 +0100
Received: from pps.filterd (prod-mail-ppoint5.akamai.com [127.0.0.1])
        by prod-mail-ppoint5.akamai.com (8.16.0.27/8.16.0.27) with SMTP id x7QJl3bp020642;
        Mon, 26 Aug 2019 13:00:45 -0700
Received: from prod-mail-relay10.akamai.com ([172.27.118.251])
        by prod-mail-ppoint5.akamai.com with ESMTP id 2uk378vgdc-1;
        Mon, 26 Aug 2019 13:00:45 -0700
Received: from [172.29.170.83] (bos-lpjec.kendall.corp.akamai.com [172.29.170.83])
        by prod-mail-relay10.akamai.com (Postfix) with ESMTP id 5BFA320BF9;
        Mon, 26 Aug 2019 20:00:45 +0000 (GMT)
Subject: Re: [PATCH net] tcp: remove empty skb from write queue in error cases
To:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vladimir Rutsky <rutsky@google.com>
References: <20190826161915.81676-1-edumazet@google.com>
From:   Jason Baron <jbaron@akamai.com>
Openpgp: preference=signencrypt
Autocrypt: addr=jbaron@akamai.com; prefer-encrypt=mutual; keydata=
 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
 JeQ7iQ==
Message-ID: <58ae43f8-21e7-f08f-2632-ce567661d301@akamai.com>
Date:   Mon, 26 Aug 2019 15:56:52 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190826161915.81676-1-edumazet@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-26_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908260187
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:5.22.84,1.0.8
 definitions=2019-08-26_08:2019-08-26,2019-08-26 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 impostorscore=0
 bulkscore=0 priorityscore=1501 adultscore=0 phishscore=0 clxscore=1015
 mlxlogscore=999 malwarescore=0 spamscore=0 mlxscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-1906280000
 definitions=main-1908260187
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/26/19 12:19 PM, Eric Dumazet wrote:
> Vladimir Rutsky reported stuck TCP sessions after memory pressure
> events. Edge Trigger epoll() user would never receive an EPOLLOUT
> notification allowing them to retry a sendmsg().
> 
> Jason tested the case of sk_stream_alloc_skb() returning NULL,
> but there are other paths that could lead both sendmsg() and sendpage()
> to return -1 (EAGAIN), with an empty skb queued on the write queue.
> 
> This patch makes sure we remove this empty skb so that
> Jason code can detect that the queue is empty, and
> call sk->sk_write_space(sk) accordingly.
> 

Makes sense, thanks. I think this check for empty queue could also
benefit from and update to use tcp_write_queue_empty(). I will send a
follow-up for that.

Thanks,

-Jason



> Fixes: ce5ec440994b ("tcp: ensure epoll edge trigger wakeup when write queue is empty")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Jason Baron <jbaron@akamai.com>
> Reported-by: Vladimir Rutsky <rutsky@google.com>
> Cc: Soheil Hassas Yeganeh <soheil@google.com>
> Cc: Neal Cardwell <ncardwell@google.com>
> ---
>  net/ipv4/tcp.c | 30 ++++++++++++++++++++----------
>  1 file changed, 20 insertions(+), 10 deletions(-)
> 
> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> index 77b485d60b9d0e00edc4e2f0d6c5bb3a9460b23b..61082065b26a068975c411b74eb46739ab0632ca 100644
> --- a/net/ipv4/tcp.c
> +++ b/net/ipv4/tcp.c
> @@ -935,6 +935,22 @@ static int tcp_send_mss(struct sock *sk, int *size_goal, int flags)
>  	return mss_now;
>  }
>  
> +/* In some cases, both sendpage() and sendmsg() could have added
> + * an skb to the write queue, but failed adding payload on it.
> + * We need to remove it to consume less memory, but more
> + * importantly be able to generate EPOLLOUT for Edge Trigger epoll()
> + * users.
> + */
> +static void tcp_remove_empty_skb(struct sock *sk, struct sk_buff *skb)
> +{
> +	if (skb && !skb->len) {
> +		tcp_unlink_write_queue(skb, sk);
> +		if (tcp_write_queue_empty(sk))
> +			tcp_chrono_stop(sk, TCP_CHRONO_BUSY);
> +		sk_wmem_free_skb(sk, skb);
> +	}
> +}
> +
>  ssize_t do_tcp_sendpages(struct sock *sk, struct page *page, int offset,
>  			 size_t size, int flags)
>  {
> @@ -1064,6 +1080,7 @@ ssize_t do_tcp_sendpages(struct sock *sk, struct page *page, int offset,
>  	return copied;
>  
>  do_error:
> +	tcp_remove_empty_skb(sk, tcp_write_queue_tail(sk));
>  	if (copied)
>  		goto out;
>  out_err:
> @@ -1388,18 +1405,11 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
>  	sock_zerocopy_put(uarg);
>  	return copied + copied_syn;
>  
> +do_error:
> +	skb = tcp_write_queue_tail(sk);
>  do_fault:
> -	if (!skb->len) {
> -		tcp_unlink_write_queue(skb, sk);
> -		/* It is the one place in all of TCP, except connection
> -		 * reset, where we can be unlinking the send_head.
> -		 */
> -		if (tcp_write_queue_empty(sk))
> -			tcp_chrono_stop(sk, TCP_CHRONO_BUSY);
> -		sk_wmem_free_skb(sk, skb);
> -	}
> +	tcp_remove_empty_skb(sk, skb);
>  
> -do_error:
>  	if (copied + copied_syn)
>  		goto out;
>  out_err:
> 
