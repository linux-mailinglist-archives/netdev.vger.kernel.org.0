Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D06422B165
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 16:31:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729107AbgGWOa4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 10:30:56 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:59942 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726715AbgGWOa4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 10:30:56 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06NETc5f177210;
        Thu, 23 Jul 2020 14:30:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=sC9ikgxCdAId2FjwuAiIMWAdpmWMyGPubI1xPl1Ci74=;
 b=SIdFDBZUeQfxAJn2svTXpXwgZNNciCu1DUh7fq6b8KCb49Zf7f6z/Y1T2E7NA/UNpYvP
 pIIEYqWYl+/apLvEGx4+sWp+8ORDdOkk2UhKeoS8Gcdcc75aRZrU+TvuE6wEgfiCYHvo
 UegwsySFybvAMf7PJ1CKN1GY58g4WuoC6FwR9twka5FQBzQoUetCnCJjpDWtXltXJ5PH
 LFhdCFw1kAWuqUFY1FN+WvAWOlqt0Gi8csmGpUiEREPK1IiQKvjVqpk6R8Uexvgeb+Fx
 3Bobs8VVJmID+kUba8DZXsSbVpHiKHQgLqUH7vOG6rOPI3LOGxVEQ1bfryMxdh/bRdxN NA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 32brgrsq45-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 23 Jul 2020 14:30:34 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06NESUwT081469;
        Thu, 23 Jul 2020 14:28:34 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 32fc4qgfae-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Jul 2020 14:28:33 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06NESOmL023964;
        Thu, 23 Jul 2020 14:28:25 GMT
Received: from kadam (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 23 Jul 2020 14:28:24 +0000
Date:   Thu, 23 Jul 2020 17:28:15 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Peilin Ye <yepeilin.cs@gmail.com>
Cc:     Joerg Reuter <jreuter@yaina.de>,
        Ralf Baechle <ralf@linux-mips.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        syzkaller-bugs@googlegroups.com,
        linux-kernel-mentees@lists.linuxfoundation.org,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-hams@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [Linux-kernel-mentees] [PATCH net] AX.25: Fix out-of-bounds read
 in ax25_connect()
Message-ID: <20200723142814.GQ2549@kadam>
References: <20200722151901.350003-1-yepeilin.cs@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200722151901.350003-1-yepeilin.cs@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9690 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=999 adultscore=0 spamscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007230107
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9690 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 spamscore=0
 impostorscore=0 suspectscore=0 adultscore=0 clxscore=1011 mlxlogscore=999
 priorityscore=1501 phishscore=0 lowpriorityscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007230107
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 22, 2020 at 11:19:01AM -0400, Peilin Ye wrote:
> Checks on `addr_len` and `fsa->fsa_ax25.sax25_ndigis` are insufficient.
> ax25_connect() can go out of bounds when `fsa->fsa_ax25.sax25_ndigis`
> equals to 7 or 8. Fix it.
> 
> This issue has been reported as a KMSAN uninit-value bug, because in such
> a case, ax25_connect() reaches into the uninitialized portion of the
> `struct sockaddr_storage` statically allocated in __sys_connect().
> 
> It is safe to remove `fsa->fsa_ax25.sax25_ndigis > AX25_MAX_DIGIS` because
> `addr_len` is guaranteed to be less than or equal to
> `sizeof(struct full_sockaddr_ax25)`.
> 
> Reported-by: syzbot+c82752228ed975b0a623@syzkaller.appspotmail.com
> Link: https://syzkaller.appspot.com/bug?id=55ef9d629f3b3d7d70b69558015b63b48d01af66
> Signed-off-by: Peilin Ye <yepeilin.cs@gmail.com>
> ---
>  net/ax25/af_ax25.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
> index fd91cd34f25e..ef5bf116157a 100644
> --- a/net/ax25/af_ax25.c
> +++ b/net/ax25/af_ax25.c
> @@ -1187,7 +1187,9 @@ static int __must_check ax25_connect(struct socket *sock,
>  	if (addr_len > sizeof(struct sockaddr_ax25) &&
>  	    fsa->fsa_ax25.sax25_ndigis != 0) {
>  		/* Valid number of digipeaters ? */
> -		if (fsa->fsa_ax25.sax25_ndigis < 1 || fsa->fsa_ax25.sax25_ndigis > AX25_MAX_DIGIS) {
> +		if (fsa->fsa_ax25.sax25_ndigis < 1 ||
> +		    addr_len < sizeof(struct sockaddr_ax25) +
> +		    sizeof(ax25_address) * fsa->fsa_ax25.sax25_ndigis) {

The "sizeof(ax25_address) * fsa->fsa_ax25.sax25_ndigis" can have an
integer overflow so you still need the
"fsa->fsa_ax25.sax25_ndigis > AX25_MAX_DIGIS" check.

regards,
dan carpenter

