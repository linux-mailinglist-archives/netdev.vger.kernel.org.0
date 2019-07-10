Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6D9C64831
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 16:22:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727328AbfGJOW1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 10:22:27 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:56978 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726458AbfGJOWZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 10:22:25 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6AE8qtY052156;
        Wed, 10 Jul 2019 14:22:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=rDVo1IDXNHtgsAjchJ0WWkLwjPkSG4RzJ4voQqZR/tk=;
 b=L0J3cZOCsLDWu057NHLlE76ihuV/tNZbNH8BeRbDe7KnHd4wj3aXH3koXJuoeB/yfVXD
 g9gGccFgWRQUxmAkfquXoDmX6QgUdE4BmqdXAVQeH3RpIjwgoGHCVkPKrc6iMp29P34p
 ylPWIuHt2S2Gqk69QJyiQQRJPIqmtnwlAMTPf3yhq5myGex9drPLJWnvUCctlQpJA4Ef
 P8OlZAhpYVzpC/+VFzSmBBCbME/LUKcbqJMsEKvZ6zpNfBRqjQyy7VApRDZSyAude/TS
 ls9D45zNcyaEI9Ua24RQoBKctJfHFfDQqYagOqsHU43RhtnPmYC7zrS4jo/MDbDt0XXd iQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2tjk2tth20-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Jul 2019 14:22:18 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6AE8Kjm159464;
        Wed, 10 Jul 2019 14:22:17 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2tnc8sw0gq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Jul 2019 14:22:17 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x6AEMGwJ025720;
        Wed, 10 Jul 2019 14:22:16 GMT
Received: from [10.182.69.170] (/10.182.69.170)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 10 Jul 2019 07:22:16 -0700
Subject: Re: [net][PATCH 1/5] rds: fix reordering with composite message
 notification
To:     Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        netdev@vger.kernel.org, davem@davemloft.net
References: <1562736764-31752-1-git-send-email-santosh.shilimkar@oracle.com>
 <1562736764-31752-2-git-send-email-santosh.shilimkar@oracle.com>
From:   Yanjun Zhu <yanjun.zhu@oracle.com>
Organization: Oracle Corporation
Message-ID: <fefd1ba3-484b-ff8d-7759-c8fd6eec229f@oracle.com>
Date:   Wed, 10 Jul 2019 22:23:42 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1562736764-31752-2-git-send-email-santosh.shilimkar@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9313 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907100166
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9313 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907100166
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/7/10 13:32, Santosh Shilimkar wrote:
> RDS composite message(rdma + control) user notification needs to be
> triggered once the full message is delivered and such a fix was
> added as part of commit 941f8d55f6d61 ("RDS: RDMA: Fix the composite
> message user notification"). But rds_send_remove_from_sock is missing
> data part notify check and hence at times the user don't get
> notification which isn't desirable.
>
> One way is to fix the rds_send_remove_from_sock to check of that case
> but considering the ordering complexity with completion handler and
> rdma + control messages are always dispatched back to back in same send
> context, just delaying the signaled completion on rmda work request also
> gets the desired behaviour. i.e Notifying application only after
> RDMA + control message send completes. So patch updates the earlier
> fix with this approach. The delay signaling completions of rdma op
> till the control message send completes fix was done by Venkat
> Venkatsubra in downstream kernel.
>
> Reviewed-and-tested-by: Zhu Yanjun <yanjun.zhu@oracle.com>

Thanks. I am fine with this.

Zhu Yanjun

> Reviewed-by: Gerd Rausch <gerd.rausch@oracle.com>
> Signed-off-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>
> ---
>   net/rds/ib_send.c | 29 +++++++++++++----------------
>   net/rds/rdma.c    | 10 ----------
>   net/rds/rds.h     |  1 -
>   net/rds/send.c    |  4 +---
>   4 files changed, 14 insertions(+), 30 deletions(-)
>
> diff --git a/net/rds/ib_send.c b/net/rds/ib_send.c
> index 18f2341..dfe6237 100644
> --- a/net/rds/ib_send.c
> +++ b/net/rds/ib_send.c
> @@ -69,6 +69,16 @@ static void rds_ib_send_complete(struct rds_message *rm,
>   	complete(rm, notify_status);
>   }
>   
> +static void rds_ib_send_unmap_data(struct rds_ib_connection *ic,
> +				   struct rm_data_op *op,
> +				   int wc_status)
> +{
> +	if (op->op_nents)
> +		ib_dma_unmap_sg(ic->i_cm_id->device,
> +				op->op_sg, op->op_nents,
> +				DMA_TO_DEVICE);
> +}
> +
>   static void rds_ib_send_unmap_rdma(struct rds_ib_connection *ic,
>   				   struct rm_rdma_op *op,
>   				   int wc_status)
> @@ -129,21 +139,6 @@ static void rds_ib_send_unmap_atomic(struct rds_ib_connection *ic,
>   		rds_ib_stats_inc(s_ib_atomic_fadd);
>   }
>   
> -static void rds_ib_send_unmap_data(struct rds_ib_connection *ic,
> -				   struct rm_data_op *op,
> -				   int wc_status)
> -{
> -	struct rds_message *rm = container_of(op, struct rds_message, data);
> -
> -	if (op->op_nents)
> -		ib_dma_unmap_sg(ic->i_cm_id->device,
> -				op->op_sg, op->op_nents,
> -				DMA_TO_DEVICE);
> -
> -	if (rm->rdma.op_active && rm->data.op_notify)
> -		rds_ib_send_unmap_rdma(ic, &rm->rdma, wc_status);
> -}
> -
>   /*
>    * Unmap the resources associated with a struct send_work.
>    *
> @@ -902,7 +897,9 @@ int rds_ib_xmit_rdma(struct rds_connection *conn, struct rm_rdma_op *op)
>   		send->s_queued = jiffies;
>   		send->s_op = NULL;
>   
> -		nr_sig += rds_ib_set_wr_signal_state(ic, send, op->op_notify);
> +		if (!op->op_notify)
> +			nr_sig += rds_ib_set_wr_signal_state(ic, send,
> +							     op->op_notify);
>   
>   		send->s_wr.opcode = op->op_write ? IB_WR_RDMA_WRITE : IB_WR_RDMA_READ;
>   		send->s_rdma_wr.remote_addr = remote_addr;
> diff --git a/net/rds/rdma.c b/net/rds/rdma.c
> index b340ed4..916f5ec 100644
> --- a/net/rds/rdma.c
> +++ b/net/rds/rdma.c
> @@ -641,16 +641,6 @@ int rds_cmsg_rdma_args(struct rds_sock *rs, struct rds_message *rm,
>   		}
>   		op->op_notifier->n_user_token = args->user_token;
>   		op->op_notifier->n_status = RDS_RDMA_SUCCESS;
> -
> -		/* Enable rmda notification on data operation for composite
> -		 * rds messages and make sure notification is enabled only
> -		 * for the data operation which follows it so that application
> -		 * gets notified only after full message gets delivered.
> -		 */
> -		if (rm->data.op_sg) {
> -			rm->rdma.op_notify = 0;
> -			rm->data.op_notify = !!(args->flags & RDS_RDMA_NOTIFY_ME);
> -		}
>   	}
>   
>   	/* The cookie contains the R_Key of the remote memory region, and
> diff --git a/net/rds/rds.h b/net/rds/rds.h
> index 0d8f67c..f0066d1 100644
> --- a/net/rds/rds.h
> +++ b/net/rds/rds.h
> @@ -476,7 +476,6 @@ struct rds_message {
>   		} rdma;
>   		struct rm_data_op {
>   			unsigned int		op_active:1;
> -			unsigned int		op_notify:1;
>   			unsigned int		op_nents;
>   			unsigned int		op_count;
>   			unsigned int		op_dmasg;
> diff --git a/net/rds/send.c b/net/rds/send.c
> index 166dd57..031b1e9 100644
> --- a/net/rds/send.c
> +++ b/net/rds/send.c
> @@ -491,14 +491,12 @@ void rds_rdma_send_complete(struct rds_message *rm, int status)
>   	struct rm_rdma_op *ro;
>   	struct rds_notifier *notifier;
>   	unsigned long flags;
> -	unsigned int notify = 0;
>   
>   	spin_lock_irqsave(&rm->m_rs_lock, flags);
>   
> -	notify =  rm->rdma.op_notify | rm->data.op_notify;
>   	ro = &rm->rdma;
>   	if (test_bit(RDS_MSG_ON_SOCK, &rm->m_flags) &&
> -	    ro->op_active && notify && ro->op_notifier) {
> +	    ro->op_active && ro->op_notify && ro->op_notifier) {
>   		notifier = ro->op_notifier;
>   		rs = rm->m_rs;
>   		sock_hold(rds_rs_to_sk(rs));
