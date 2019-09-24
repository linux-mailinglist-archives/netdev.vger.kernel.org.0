Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4961ABCBB4
	for <lists+netdev@lfdr.de>; Tue, 24 Sep 2019 17:43:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388910AbfIXPnq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Sep 2019 11:43:46 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:43702 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388309AbfIXPnq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Sep 2019 11:43:46 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8OFY9I2177032;
        Tue, 24 Sep 2019 15:43:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=qgFnN5uLCMpgJE+A8V79D30t+Fr+XIQBP5TwKJXpoCs=;
 b=QpmewZ8k9bzy+ra6l2a1O2JGlUWedyKKptwCwMbXH3W4L8puGmgcqqf/dRFx4fuQVvkW
 senkf7kpGQepOWGfEU3/sx2DCVWqYvYd1zqb04iwej6x7aXdHPXcUqHgB8hpCnZAjOdF
 4WRxmhQsn8U0R76A6ApeVOYWzM6YJzEp3p8MfiRyFxLLAOAVzxhwnRqmwM4BjYQPF7bz
 5n1dXaGe5R88aFznZ+jH+2OExeKqUXUWqDp012thSEFAAOxSVUw3dI1eHAKpM6Ke6Rrs
 5v/6grYZVqvNqGFxAspaGE2HHdjmEcfMJuSMIerNMgxZH6JEvg8sciXHW8mmB8ln9dq+ jg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2v5cgqxy8q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Sep 2019 15:43:43 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8OFXRcS148123;
        Tue, 24 Sep 2019 15:43:43 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3020.oracle.com with ESMTP id 2v6yvrxs64-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 24 Sep 2019 15:43:43 +0000
Received: from aserp3020.oracle.com (aserp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x8OFhgJ7178729;
        Tue, 24 Sep 2019 15:43:42 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2v6yvrxs5h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Sep 2019 15:43:42 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x8OFhfKG001711;
        Tue, 24 Sep 2019 15:43:41 GMT
Received: from [10.159.211.29] (/10.159.211.29)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 24 Sep 2019 08:43:41 -0700
Subject: Re: [PATCH net-next] net/rds: Check laddr_check before calling it
To:     netdev@vger.kernel.org
Cc:     santosh.shilimkar@oracle.com, davem@davemloft.net,
        rds-devel@oss.oracle.com
References: <1568734158-18021-1-git-send-email-ka-cheong.poon@oracle.com>
 <1569338876-12857-1-git-send-email-ka-cheong.poon@oracle.com>
From:   Ka-Cheong Poon <ka-cheong.poon@oracle.com>
Organization: Oracle Corporation
Message-ID: <b3048536-8451-8892-1113-09da3b0ab9f0@oracle.com>
Date:   Tue, 24 Sep 2019 23:43:33 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <1569338876-12857-1-git-send-email-ka-cheong.poon@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9390 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909240146
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/24/19 11:27 PM, Ka-Cheong Poon wrote:
> In rds_bind(), laddr_check is called without checking if it is NULL or
> not.  And rs_transport should be reset if rds_add_bound() fails.
> 
> Fixes: c5c1a030a7db ("net/rds: Check laddr_check before calling it")


Oops, wrong Subject.  Will re-submit.  Sorry about that.


> Reported-by: syzbot+fae39afd2101a17ec624@syzkaller.appspotmail.com
> Signed-off-by: Ka-Cheong Poon <ka-cheong.poon@oracle.com>
> Acked-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>
> ---
>   net/rds/bind.c | 5 ++++-
>   1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/net/rds/bind.c b/net/rds/bind.c
> index 20c156a..5b5fb4c 100644
> --- a/net/rds/bind.c
> +++ b/net/rds/bind.c
> @@ -244,7 +244,8 @@ int rds_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
>   	 */
>   	if (rs->rs_transport) {
>   		trans = rs->rs_transport;
> -		if (trans->laddr_check(sock_net(sock->sk),
> +		if (!trans->laddr_check ||
> +		    trans->laddr_check(sock_net(sock->sk),
>   				       binding_addr, scope_id) != 0) {
>   			ret = -ENOPROTOOPT;
>   			goto out;
> @@ -263,6 +264,8 @@ int rds_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
>   
>   	sock_set_flag(sk, SOCK_RCU_FREE);
>   	ret = rds_add_bound(rs, binding_addr, &port, scope_id);
> +	if (ret)
> +		rs->rs_transport = NULL;
>   
>   out:
>   	release_sock(sk);
> 


-- 
K. Poon
ka-cheong.poon@oracle.com


