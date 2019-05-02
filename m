Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96196116BE
	for <lists+netdev@lfdr.de>; Thu,  2 May 2019 11:53:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726289AbfEBJxy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 May 2019 05:53:54 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:35614 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726127AbfEBJxy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 May 2019 05:53:54 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x429o76m023566;
        Thu, 2 May 2019 09:53:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : in-reply-to : message-id : references : mime-version :
 content-type; s=corp-2018-07-02;
 bh=jCOv2IB+99FgoGG+HZuRwDd5uyXuUrVxmQE1oOOcEy4=;
 b=a4Nl+WzqsCUdG6IBoiak1okiUK/TtuCkwY/hsT4whIfLs9swtJyn+NzKlGMTwrhvnrOm
 z/3lmsKTbrNYl+KvaOJP0E13nhmcjdCsI6ajxaOwQlh08ZwRbgdfWD5iAUKylSjCBXVz
 1+mCdlLymwJ4oMVjXci+nqA/E/UPvowxGh/sXUm2FAo0DkLKUbOWng2xGigBlkkTrIet
 4k5D6Pxo1PJ96djp6prR3MJcFwBJVYhBGsx8T8gS2g6dFeQRh7pc7oXMYAk+Hx6WXkLb
 ZOKt2T1r0nl43QLysjO/0dO9GHvDfclQG/Icy2M7LqKrUQ6Wv9BdwzKUGoPPL46ralMf jg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2s6xhyffj8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 May 2019 09:53:43 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x429rfcf137157;
        Thu, 2 May 2019 09:53:43 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2s7p89p2j0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 May 2019 09:53:43 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x429rffp032244;
        Thu, 2 May 2019 09:53:41 GMT
Received: from dhcp-10-175-160-224.vpn.oracle.com (/10.175.160.224)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 02 May 2019 02:53:41 -0700
Date:   Thu, 2 May 2019 10:53:34 +0100 (BST)
From:   Alan Maguire <alan.maguire@oracle.com>
X-X-Sender: alan@dhcp-10-175-160-224.vpn.oracle.com
To:     David Ahern <dsahern@kernel.org>
cc:     davem@davemloft.net, netdev@vger.kernel.org, ian.kumlien@gmail.com,
        alan.maguire@oracle.com, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH net] neighbor: Reset gc_entries counter if new entry is
 released before insert
In-Reply-To: <20190502010834.25519-1-dsahern@kernel.org>
Message-ID: <alpine.LRH.2.20.1905021052550.5146@dhcp-10-175-160-224.vpn.oracle.com>
References: <20190502010834.25519-1-dsahern@kernel.org>
User-Agent: Alpine 2.20 (LRH 67 2015-01-07)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9244 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905020074
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9244 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905020074
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 1 May 2019, David Ahern wrote:

> From: David Ahern <dsahern@gmail.com>
> 
> Ian and Alan both reported seeing overflows after upgrades to 5.x kernels:
>   neighbour: arp_cache: neighbor table overflow!
> 
> Alan's mpls script helped get to the bottom of this bug. When a new entry
> is created the gc_entries counter is bumped in neigh_alloc to check if a
> new one is allowed to be created. ___neigh_create then searches for an
> existing entry before inserting the just allocated one. If an entry
> already exists, the new one is dropped in favor of the existing one. In
> this case the cleanup path needs to drop the gc_entries counter. There
> is no memory leak, only a counter leak.
> 
> Fixes: 58956317c8d ("neighbor: Improve garbage collection")
> Reported-by: Ian Kumlien <ian.kumlien@gmail.com>
> Reported-by: Alan Maguire <alan.maguire@oracle.com>
> Signed-off-by: David Ahern <dsahern@gmail.com>
Tested-by: Alan Maguire <alan.maguire@oracle.com>
> ---
>  net/core/neighbour.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/net/core/neighbour.c b/net/core/neighbour.c
> index 30f6fd8f68e0..aff051e5521d 100644
> --- a/net/core/neighbour.c
> +++ b/net/core/neighbour.c
> @@ -663,6 +663,8 @@ static struct neighbour *___neigh_create(struct neigh_table *tbl,
>  out_tbl_unlock:
>  	write_unlock_bh(&tbl->lock);
>  out_neigh_release:
> +	if (!exempt_from_gc)
> +		atomic_dec(&tbl->gc_entries);
>  	neigh_release(n);
>  	goto out;
>  }
> -- 
> 2.11.0
> 
> 
