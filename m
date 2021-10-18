Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B558843296F
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 23:58:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233374AbhJRWAw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 18:00:52 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:31104 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230135AbhJRWAv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 18:00:51 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19ILKUYA010680;
        Mon, 18 Oct 2021 17:58:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=m6cs17KXv90k07us+CYZWzWzt/Uab1CXXZYHUP7YvQo=;
 b=NBCfRMpuwUmE7Fw+WTQtJ86RgR/aM1ydt17jwA0RMoOcQ77xkY9TabpOMt0uw5FXcl7W
 Jf9/BLy+I6UswHe10fP0CIwOWQmgYveZ0wLzwkBuo8dqQhR6QHzkmL+tJLvvcWbIEpjt
 xdkdPG52CdErZnc9C7ZX93kNZCiU0aAI0AvpToFtQWI2XTSKXIDbhPGcaJDCODoAHS5b
 RwuHyh01fjrdCUmbecEqgZMPpCZ894618+eQ+bwpg6ReQ42wnQWOCuINohnlvStrndUx
 olwIcHNxo6h+NmRAd32G9HbJNpC68q1i98TvoGAVz29k5ZEyCfl37P38gQeaR2AHRnqK DQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bsgrj0mf6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 18 Oct 2021 17:58:18 -0400
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19ILiGWo014531;
        Mon, 18 Oct 2021 17:58:17 -0400
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bsgrj0meq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 18 Oct 2021 17:58:17 -0400
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19ILlthu031273;
        Mon, 18 Oct 2021 21:58:16 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma01dal.us.ibm.com with ESMTP id 3bqpcba2cs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 18 Oct 2021 21:58:16 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19ILwFSm52887974
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 18 Oct 2021 21:58:15 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 037A6C6084;
        Mon, 18 Oct 2021 21:58:15 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E51D4C6062;
        Mon, 18 Oct 2021 21:58:11 +0000 (GMT)
Received: from suka-w540.localdomain (unknown [9.160.15.50])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with SMTP;
        Mon, 18 Oct 2021 21:58:11 +0000 (GMT)
Received: by suka-w540.localdomain (Postfix, from userid 1000)
        id A08922E185B; Mon, 18 Oct 2021 14:58:08 -0700 (PDT)
Date:   Mon, 18 Oct 2021 14:58:08 -0700
From:   Sukadev Bhattiprolu <sukadev@linux.ibm.com>
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     netdev@vger.kernel.org, linyunsheng@huawei.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Antoine Tenart <atenart@kernel.org>,
        Alexander Lobakin <alobakin@pm.me>,
        Wei Wang <weiwan@google.com>, Taehee Yoo <ap420073@gmail.com>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Neil Horman <nhorman@redhat.com>,
        Dust Li <dust.li@linux.alibaba.com>
Subject: Re: [PATCH net v2] napi: fix race inside napi_enable
Message-ID: <YW3t8AGxW6p261hw@us.ibm.com>
References: <20210918085232.71436-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210918085232.71436-1-xuanzhuo@linux.alibaba.com>
X-Operating-System: Linux 2.0.32 on an i486
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 6SqAweiN9E_g0SDgPkO067OSNbqCnZW4
X-Proofpoint-GUID: 3t3ZcXKlOe8jndRXtHrzKY5Q47hbV4Gz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-18_07,2021-10-18_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 impostorscore=0
 malwarescore=0 priorityscore=1501 mlxlogscore=999 suspectscore=0
 clxscore=1011 adultscore=0 spamscore=0 phishscore=0 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110180116
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Xuan Zhuo [xuanzhuo@linux.alibaba.com] wrote:
> The process will cause napi.state to contain NAPI_STATE_SCHED and
> not in the poll_list, which will cause napi_disable() to get stuck.
> 
> The prefix "NAPI_STATE_" is removed in the figure below, and
> NAPI_STATE_HASHED is ignored in napi.state.
> 
>                       CPU0       |                   CPU1       | napi.state
> ===============================================================================
> napi_disable()                   |                              | SCHED | NPSVC
> napi_enable()                    |                              |
> {                                |                              |
>     smp_mb__before_atomic();     |                              |
>     clear_bit(SCHED, &n->state); |                              | NPSVC
>                                  | napi_schedule_prep()         | SCHED | NPSVC
>                                  | napi_poll()                  |
>                                  |   napi_complete_done()       |
>                                  |   {                          |
>                                  |      if (n->state & (NPSVC | | (1)
>                                  |               _BUSY_POLL)))  |
>                                  |           return false;      |
>                                  |     ................         |
>                                  |   }                          | SCHED | NPSVC
>                                  |                              |
>     clear_bit(NPSVC, &n->state); |                              | SCHED
> }                                |                              |

So its possible that after cpu0 cleared SCHED, cpu1 could have set it
back and we are going to use cmpxchg() to detect and retry right? If so,


>                                  |                              |
> napi_schedule_prep()             |                              | SCHED | MISSED (2)
> 
> (1) Here return direct. Because of NAPI_STATE_NPSVC exists.
> (2) NAPI_STATE_SCHED exists. So not add napi.poll_list to sd->poll_list
> 
> Since NAPI_STATE_SCHED already exists and napi is not in the
> sd->poll_list queue, NAPI_STATE_SCHED cannot be cleared and will always
> exist.
> 
> 1. This will cause this queue to no longer receive packets.
> 2. If you encounter napi_disable under the protection of rtnl_lock, it
>    will cause the entire rtnl_lock to be locked, affecting the overall
>    system.
> 
> This patch uses cmpxchg to implement napi_enable(), which ensures that
> there will be no race due to the separation of clear two bits.
> 
> Fixes: 2d8bff12699abc ("netpoll: Close race condition between poll_one_napi and napi_disable")
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> Reviewed-by: Dust Li <dust.li@linux.alibaba.com>
> ---
>  net/core/dev.c | 16 ++++++++++------
>  1 file changed, 10 insertions(+), 6 deletions(-)
> 
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 74fd402d26dd..7ee9fecd3aff 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -6923,12 +6923,16 @@ EXPORT_SYMBOL(napi_disable);
>   */
>  void napi_enable(struct napi_struct *n)
>  {
> -	BUG_ON(!test_bit(NAPI_STATE_SCHED, &n->state));
> -	smp_mb__before_atomic();
> -	clear_bit(NAPI_STATE_SCHED, &n->state);
> -	clear_bit(NAPI_STATE_NPSVC, &n->state);
> -	if (n->dev->threaded && n->thread)
> -		set_bit(NAPI_STATE_THREADED, &n->state);
> +	unsigned long val, new;
> +
> +	do {
> +		val = READ_ONCE(n->state);
> +		BUG_ON(!test_bit(NAPI_STATE_SCHED, &val));

is this BUG_ON valid/needed? We could have lost the cmpxchg() and
the other thread could have set NAPI_STATE_SCHED?

Sukadev

> +
> +		new = val & ~(NAPIF_STATE_SCHED | NAPIF_STATE_NPSVC);
> +		if (n->dev->threaded && n->thread)
> +			new |= NAPIF_STATE_THREADED;
> +	} while (cmpxchg(&n->state, val, new) != val);
>  }
>  EXPORT_SYMBOL(napi_enable);
>  
> -- 
> 2.31.0
