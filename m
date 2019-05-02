Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 488C7116C1
	for <lists+netdev@lfdr.de>; Thu,  2 May 2019 11:54:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726295AbfEBJyg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 May 2019 05:54:36 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:42686 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726127AbfEBJyg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 May 2019 05:54:36 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x429n62s043275;
        Thu, 2 May 2019 09:54:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : in-reply-to : message-id : references : mime-version :
 content-type; s=corp-2018-07-02;
 bh=phARmWrUUFklG2sorbnzj3QJtzvL0eVMZkLbYL7fjLk=;
 b=V9AJp6IXu8RqVbnXf0gbbi6P5bZ+5v28izkqDhWQHC7GEMu0fMoDPFWr72uFR1A79qKG
 PlzhZMtoy+XovREeX99z3t/P5tkkMz0wNFVOXSmQKnlf21Q66/smG+75fLwyqnNgQe6q
 B50t6tF1+ZrZh2GgDUPcFgre/m3OYXCw3WwIlebzL/5IxIDAE1HTXiyIwr1vU4sYAxwl
 Ytthwv4Rxu6j9Un8rGC5d9jRWYIfl8K7vBo2uWzdnkiL1bKe+EysKIc1yTnBJjfVMtvV
 PhqjgmDOZusK3g0Lk3iJZuETV0w9YRkL5bhKU4aJo4ZZD+qltpDcsUdoymu7xBr6hOq+ NA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2s6xhyqf85-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 May 2019 09:54:30 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x429r8U9175587;
        Thu, 2 May 2019 09:54:30 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2s6xhgqar6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 May 2019 09:54:30 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x429sSoI009765;
        Thu, 2 May 2019 09:54:28 GMT
Received: from dhcp-10-175-160-224.vpn.oracle.com (/10.175.160.224)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 02 May 2019 02:54:27 -0700
Date:   Thu, 2 May 2019 10:54:23 +0100 (BST)
From:   Alan Maguire <alan.maguire@oracle.com>
X-X-Sender: alan@dhcp-10-175-160-224.vpn.oracle.com
To:     David Ahern <dsahern@kernel.org>
cc:     davem@davemloft.net, netdev@vger.kernel.org,
        alan.maguire@oracle.com, jwestfall@surrealistic.net,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH net] neighbor: Call __ipv4_neigh_lookup_noref in
 neigh_xmit
In-Reply-To: <20190502011842.1645-1-dsahern@kernel.org>
Message-ID: <alpine.LRH.2.20.1905021054000.5146@dhcp-10-175-160-224.vpn.oracle.com>
References: <20190502011842.1645-1-dsahern@kernel.org>
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
> Commit cd9ff4de0107 changed the key for IFF_POINTOPOINT devices to
> INADDR_ANY but neigh_xmit which is used for MPLS encapsulations was not
> updated to use the altered key. The result is that every packet Tx does
> a lookup on the gateway address which does not find an entry, a new one
> is created only to find the existing one in the table right before the
> insert since arp_constructor was updated to reset the primary key. This
> is seen in the allocs and destroys counters:
>     ip -s -4 ntable show | head -10 | grep alloc
> 
> which increase for each packet showing the unnecessary overhread.
> 
> Fix by having neigh_xmit use __ipv4_neigh_lookup_noref for NEIGH_ARP_TABLE.
> 
> Fixes: cd9ff4de0107 ("ipv4: Make neigh lookup keys for loopback/point-to-point devices be INADDR_ANY")
> Reported-by: Alan Maguire <alan.maguire@oracle.com>
> Signed-off-by: David Ahern <dsahern@gmail.com>
Tested-by: Alan Maguire <alan.maguire@oracle.com>
> ---
>  net/core/neighbour.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/net/core/neighbour.c b/net/core/neighbour.c
> index aff051e5521d..9b9da5142613 100644
> --- a/net/core/neighbour.c
> +++ b/net/core/neighbour.c
> @@ -31,6 +31,7 @@
>  #include <linux/times.h>
>  #include <net/net_namespace.h>
>  #include <net/neighbour.h>
> +#include <net/arp.h>
>  #include <net/dst.h>
>  #include <net/sock.h>
>  #include <net/netevent.h>
> @@ -2984,7 +2985,13 @@ int neigh_xmit(int index, struct net_device *dev,
>  		if (!tbl)
>  			goto out;
>  		rcu_read_lock_bh();
> -		neigh = __neigh_lookup_noref(tbl, addr, dev);
> +		if (index == NEIGH_ARP_TABLE) {
> +			u32 key = *((u32 *)addr);
> +
> +			neigh = __ipv4_neigh_lookup_noref(dev, key);
> +		} else {
> +			neigh = __neigh_lookup_noref(tbl, addr, dev);
> +		}
>  		if (!neigh)
>  			neigh = __neigh_create(tbl, addr, dev, false);
>  		err = PTR_ERR(neigh);
> -- 
> 2.11.0
> 
> 
