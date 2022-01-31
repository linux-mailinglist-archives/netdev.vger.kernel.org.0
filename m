Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00BD34A4FAB
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 20:46:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232583AbiAaTqY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 14:46:24 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:11412 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231583AbiAaTqX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 14:46:23 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20VIa0ib032286;
        Mon, 31 Jan 2022 19:46:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=BHNUDP5GiTKTGhBKNrKC39J+HmI6BIablwOORHYIXp8=;
 b=mwA5jtDulLz/Gp/Y+qledbDEijGkW8CklVKEXKY/QKN5Ecj2UOTrxyI1MNZEIqbFcNq0
 oPbwrLr8RLAdh+brPjkrqBjSaYZ2c912/0YTD78L7VrcS6jwW0HjaLSNGyJ1g8kcnY9I
 HkyX7DxGR7bX7bQAZ5uICU+KhP2Mw8XdwKmUylMWjTkTQ9SMLmBS8ZCl8iop/an82gks
 J1TjhifYS5uGNoJs3F4RJgKg7+Ixz2YIoKhbP7yjc+bu2OEJp+GRhaGO1+9btNMFIVuc
 +N3Rva2rFr6T2L1Ya0slbYuvyRw69L/U+ccKk6zVVjLBrBWE0mdAPFbzzZXv5Z2Ylwp/ JA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dx33x64hg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 31 Jan 2022 19:46:21 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20VJ91E5022333;
        Mon, 31 Jan 2022 19:46:20 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dx33x64h0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 31 Jan 2022 19:46:20 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20VJMUm6022056;
        Mon, 31 Jan 2022 19:46:18 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3dvw79ektd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 31 Jan 2022 19:46:18 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20VJkFkD43778510
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 31 Jan 2022 19:46:15 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AC99E11C052;
        Mon, 31 Jan 2022 19:46:15 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5BB4211C054;
        Mon, 31 Jan 2022 19:46:15 +0000 (GMT)
Received: from [9.171.28.92] (unknown [9.171.28.92])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 31 Jan 2022 19:46:15 +0000 (GMT)
Message-ID: <3ebb60c6-016d-a770-ae1e-8109b4f29397@linux.ibm.com>
Date:   Mon, 31 Jan 2022 20:46:15 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH net-next 3/3] net/smc: Cork when sendpage with
 MSG_SENDPAGE_NOTLAST flag
Content-Language: en-US
To:     Tony Lu <tonylu@linux.alibaba.com>, kgraul@linux.ibm.com,
        kuba@kernel.org, davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org
References: <20220130180256.28303-1-tonylu@linux.alibaba.com>
 <20220130180256.28303-4-tonylu@linux.alibaba.com>
From:   Stefan Raspl <raspl@linux.ibm.com>
In-Reply-To: <20220130180256.28303-4-tonylu@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: tD9d7LC_HHriiRZ-PUM3h4xqXnCC_NLh
X-Proofpoint-ORIG-GUID: MC7cS4-fEHWOyoAbNIQuaAOK53EyDV9L
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-31_07,2022-01-31_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 bulkscore=0
 adultscore=0 impostorscore=0 mlxlogscore=999 malwarescore=0 phishscore=0
 suspectscore=0 mlxscore=0 spamscore=0 lowpriorityscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2201310125
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/30/22 19:02, Tony Lu wrote:
> This introduces a new corked flag, MSG_SENDPAGE_NOTLAST, which is
> involved in syscall sendfile() [1], it indicates this is not the last
> page. So we can cork the data until the page is not specify this flag.
> It has the same effect as MSG_MORE, but existed in sendfile() only.
> 
> This patch adds a option MSG_SENDPAGE_NOTLAST for corking data, try to
> cork more data before sending when using sendfile(), which acts like
> TCP's behaviour. Also, this reimplements the default sendpage to inform
> that it is supported to some extent.
> 
> [1] https://man7.org/linux/man-pages/man2/sendfile.2.html
> 
> Signed-off-by: Tony Lu <tonylu@linux.alibaba.com>
> ---
>   net/smc/af_smc.c |  4 +++-
>   net/smc/smc_tx.c | 19 ++++++++++++++++++-
>   net/smc/smc_tx.h |  2 ++
>   3 files changed, 23 insertions(+), 2 deletions(-)
> 
> diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
> index ef021ec6b361..8b78010afe01 100644
> --- a/net/smc/af_smc.c
> +++ b/net/smc/af_smc.c
> @@ -2729,8 +2729,10 @@ static ssize_t smc_sendpage(struct socket *sock, struct page *page,
>   		rc = kernel_sendpage(smc->clcsock, page, offset,
>   				     size, flags);
>   	} else {
> +		lock_sock(sk);
> +		rc = smc_tx_sendpage(smc, page, offset, size, flags);
> +		release_sock(sk);
>   		SMC_STAT_INC(smc, sendpage_cnt);
> -		rc = sock_no_sendpage(sock, page, offset, size, flags);
>   	}
>   
>   out:
> diff --git a/net/smc/smc_tx.c b/net/smc/smc_tx.c
> index 9cec62cae7cb..a96ce162825e 100644
> --- a/net/smc/smc_tx.c
> +++ b/net/smc/smc_tx.c
> @@ -235,7 +235,8 @@ int smc_tx_sendmsg(struct smc_sock *smc, struct msghdr *msg, size_t len)
>   		 */
>   		if ((msg->msg_flags & MSG_OOB) && !send_remaining)
>   			conn->urg_tx_pend = true;
> -		if ((msg->msg_flags & MSG_MORE || smc_tx_is_corked(smc)) &&
> +		if ((msg->msg_flags & MSG_MORE || smc_tx_is_corked(smc) ||
> +		     msg->msg_flags & MSG_SENDPAGE_NOTLAST) &&
>   		    (atomic_read(&conn->sndbuf_space)))
>   			/* for a corked socket defer the RDMA writes if
>   			 * sndbuf_space is still available. The applications
> @@ -257,6 +258,22 @@ int smc_tx_sendmsg(struct smc_sock *smc, struct msghdr *msg, size_t len)
>   	return rc;
>   }
>   
> +int smc_tx_sendpage(struct smc_sock *smc, struct page *page, int offset,
> +		    size_t size, int flags)
> +{
> +	struct msghdr msg = {.msg_flags = flags};
> +	char *kaddr = kmap(page);
> +	struct kvec iov;
> +	int rc;
> +
> +	iov.iov_base = kaddr + offset;
> +	iov.iov_len = size;
> +	iov_iter_kvec(&msg.msg_iter, WRITE, &iov, 1, size);
> +	rc = smc_tx_sendmsg(smc, &msg, size);
> +	kunmap(page);
> +	return rc;
> +}
> +
>   /***************************** sndbuf consumer *******************************/
>   
>   /* sndbuf consumer: actual data transfer of one target chunk with ISM write */
> diff --git a/net/smc/smc_tx.h b/net/smc/smc_tx.h
> index a59f370b8b43..34b578498b1f 100644
> --- a/net/smc/smc_tx.h
> +++ b/net/smc/smc_tx.h
> @@ -31,6 +31,8 @@ void smc_tx_pending(struct smc_connection *conn);
>   void smc_tx_work(struct work_struct *work);
>   void smc_tx_init(struct smc_sock *smc);
>   int smc_tx_sendmsg(struct smc_sock *smc, struct msghdr *msg, size_t len);
> +int smc_tx_sendpage(struct smc_sock *smc, struct page *page, int offset,
> +		    size_t size, int flags);
>   int smc_tx_sndbuf_nonempty(struct smc_connection *conn);
>   void smc_tx_sndbuf_nonfull(struct smc_sock *smc);
>   void smc_tx_consumer_update(struct smc_connection *conn, bool force);
> 

Reviewed-by: Stefan Raspl <raspl@linux.ibm.com>
