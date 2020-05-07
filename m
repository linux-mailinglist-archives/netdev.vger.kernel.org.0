Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B5971C8645
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 12:00:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726948AbgEGKAk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 06:00:40 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:35182 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726612AbgEGKAF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 06:00:05 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0479vNLP155967;
        Thu, 7 May 2020 09:59:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=pUuuZ4frW2b/D0q4zeTBVFD+qrgsDvbjXe8pI8eyV00=;
 b=P/nXN+7bJ0lBDilfVqWPSledLohvAZ5Q1tprCcAAWCZXBo7ZqzX2hCe5xrSm1xzfZ92X
 g5+rPuyH45uDTb0nJsCKWVZIiKtUBQPX2NFkmJqEj/MSLieOo5P/W7JQa6bLM2MkfYVX
 9ZysOG7UyX4nYS9598QxfNW8OMcN1b7lKMTIfRl1xpP+eAnGlTh+wzBeTcxf9f2WwIxo
 tP+HI1+J0JXHrjfBZ/C9p2RtmsVnt16YIVG+kcDK0wXH3+SSLpb7ubCg+ARXG9Lhz6sD
 jFkJ4W7H1rKmWWMYRGLJoNZ87cW+1QlZ9cGLkzz8yRYQu+++nXkHLDd8APKbFan44Azx rg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 30usgq6a5u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 May 2020 09:59:57 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0479wiuM051284;
        Thu, 7 May 2020 09:59:57 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 30us7q4n8s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 May 2020 09:59:57 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0479xt41008072;
        Thu, 7 May 2020 09:59:56 GMT
Received: from kadam (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 07 May 2020 02:59:55 -0700
Date:   Thu, 7 May 2020 12:59:49 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Hillf Danton <hdanton@sina.com>
Cc:     syzbot <syzbot+e73ceacfd8560cc8a3ca@syzkaller.appspotmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Subject: Re: BUG: stack guard page was hit in unwind_next_frame
Message-ID: <20200507095949.GD9365@kadam>
References: <0000000000005a8fe005a4b8a114@google.com>
 <20200503102220.3848-1-hdanton@sina.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200503102220.3848-1-hdanton@sina.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9613 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 suspectscore=0
 mlxlogscore=999 malwarescore=0 phishscore=0 mlxscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005070081
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9613 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 mlxscore=0
 priorityscore=1501 lowpriorityscore=0 malwarescore=0 clxscore=1011
 mlxlogscore=999 spamscore=0 adultscore=0 bulkscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005070081
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 03, 2020 at 06:22:20PM +0800, Hillf Danton wrote:
> Bail out if it's detected to handle the event more than once.
> 
> --- a/drivers/net/bonding/bond_main.c
> +++ b/drivers/net/bonding/bond_main.c
> @@ -3273,9 +3273,19 @@ static int bond_netdev_event(struct noti
>  			return ret;
>  	}
>  
> -	if (event_dev->flags & IFF_SLAVE)
> -		return bond_slave_netdev_event(event, event_dev);
> +	if (event_dev->flags & IFF_SLAVE) {
> +		static void *tail_spin = NULL;
                             ^^^^^^^^^^^^^^^^
assigning NULL

> +		void *token = (void *) this + (void *) event_dev;

Adding a pointer to a pointer doesn't make any sense.  But the result
is non-NULL because event_dev is non-NULL.

> +
> +		if (tail_spin == token) {
                    ^^^^^^^^^^^^^^^^^^
Impossible because tail_spin is NULL and token is non-NULL.

> +			tail_spin = NULL;
                        ^^^^^^^^^^^^^^^^
re-assigning NULL.  local variable assigned right before a return is
pointless.

> +			return NOTIFY_DONE;
> +		}
> +		if (tail_spin == NULL)

Always true condition.

> +			tail_spin = token;

Pointless assign.

>  
> +		return bond_slave_netdev_event(event, event_dev);

This whole patch is a very complicated no-op.  :P  I'm not sure at all
what was intended by this patch.

> +	}
>  	return NOTIFY_DONE;
>  }

regards,
dan carpenter
