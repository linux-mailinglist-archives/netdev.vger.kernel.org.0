Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D96B6FFC2
	for <lists+netdev@lfdr.de>; Mon, 22 Jul 2019 14:35:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729554AbfGVMfd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 08:35:33 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:55174 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728062AbfGVMfc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jul 2019 08:35:32 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6MCNlXu128635;
        Mon, 22 Jul 2019 12:34:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=+kLueem9WMUqNcxD9IjzUoxdJXL84wtAlV58iaOuVG8=;
 b=pZJzayND+wZiT/MVYESoo67JGHRPEK+kthwJ68ZZTcrUm2wEwsaBlPkLjhT003QT6uly
 oyj23H8uRmUneEhGyY0DtzgrK0kxHhQhMCDOe+VM/lMMARd0wUokg1i8WzYpN9RtEjHd
 I1XAZLJz8xwmdCX6WFbyJf1o5ExoOLZfWS1qstynV+OAQlbbVUUHkEBTw39sjU/m3mkh
 pSv+60Tyik4RjHhvl0y2luAxOVUo7+ZVgoHWKSLSLIP3GLXO1RFz8Kxtdrak56sO62Xk
 f/HSatw0p3r40NewVUZlqfEPNP8hU83F8NJbvu6mckMRrAB5yhuwKPjs6I1G/WZ9Ll6I zA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2tuukqe8yc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 Jul 2019 12:34:42 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6MCRbs2083749;
        Mon, 22 Jul 2019 12:32:41 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2tut9m87mk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 Jul 2019 12:32:41 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x6MCWbl4010722;
        Mon, 22 Jul 2019 12:32:37 GMT
Received: from oracle.com (/23.233.26.138)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 22 Jul 2019 05:32:36 -0700
Date:   Mon, 22 Jul 2019 08:32:33 -0400
From:   "Liam R. Howlett" <Liam.Howlett@Oracle.com>
To:     Wenwen Wang <wang6495@umn.edu>
Cc:     Wenwen Wang <wenwen@cs.uga.edu>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        "David S. Miller" <davem@davemloft.net>,
        "open list:NETFILTER" <netfilter-devel@vger.kernel.org>,
        "open list:NETFILTER" <coreteam@netfilter.org>,
        "moderated list:ETHERNET BRIDGE" <bridge@lists.linux-foundation.org>,
        "open list:ETHERNET BRIDGE" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] netfilter: ebtables: compat: fix a memory leak bug
Message-ID: <20190722123204.rvsqlqgynfgjcif7@oracle.com>
Mail-Followup-To: Wenwen Wang <wang6495@umn.edu>,
        Wenwen Wang <wenwen@cs.uga.edu>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        "David S. Miller" <davem@davemloft.net>,
        "open list:NETFILTER" <netfilter-devel@vger.kernel.org>,
        "open list:NETFILTER" <coreteam@netfilter.org>,
        "moderated list:ETHERNET BRIDGE" <bridge@lists.linux-foundation.org>,
        "open list:ETHERNET BRIDGE" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <1563625366-3602-1-git-send-email-wang6495@umn.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1563625366-3602-1-git-send-email-wang6495@umn.edu>
User-Agent: NeoMutt/20180716
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9325 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907220147
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9325 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907220147
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Nice catch.  The code that exists is confusing due to newinfo->entries
being overwritten and then freed in the existing code path as you state
in your commit log.

* Wenwen Wang <wang6495@umn.edu> [190720 08:23]:
> From: Wenwen Wang <wenwen@cs.uga.edu>
> 
> In compat_do_replace(), a temporary buffer is allocated through vmalloc()
> to hold entries copied from the user space. The buffer address is firstly
> saved to 'newinfo->entries', and later on assigned to 'entries_tmp'. Then
> the entries in this temporary buffer is copied to the internal kernel
> structure through compat_copy_entries(). If this copy process fails,
> compat_do_replace() should be terminated. However, the allocated temporary
> buffer is not freed on this path, leading to a memory leak.
> 
> To fix the bug, free the buffer before returning from compat_do_replace().
> 
> Signed-off-by: Wenwen Wang <wenwen@cs.uga.edu>
> ---
>  net/bridge/netfilter/ebtables.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
> index 963dfdc..fd84b48e 100644
> --- a/net/bridge/netfilter/ebtables.c
> +++ b/net/bridge/netfilter/ebtables.c
> @@ -2261,8 +2261,10 @@ static int compat_do_replace(struct net *net, void __user *user,
>  	state.buf_kern_len = size64;
>  
>  	ret = compat_copy_entries(entries_tmp, tmp.entries_size, &state);
> -	if (WARN_ON(ret < 0))
> +	if (WARN_ON(ret < 0)) {
> +		vfree(entries_tmp);
>  		goto out_unlock;
> +	}


Would it be worth adding a new goto label above out_unlock and free this
entries_tmp?  It could then be used in previous failure path as well.

Thanks,
Liam
