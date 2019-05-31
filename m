Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B654306DC
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 05:07:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726678AbfEaDG6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 23:06:58 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:18060 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726418AbfEaDG6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 May 2019 23:06:58 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 633C8FFE307F46C5E2D8;
        Fri, 31 May 2019 11:06:55 +0800 (CST)
Received: from [127.0.0.1] (10.133.213.239) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.439.0; Fri, 31 May 2019
 11:06:50 +0800
Subject: Re: [PATCH net-next] netfilter: nf_conntrack_bridge: Fix build error
 without IPV6
To:     <pablo@netfilter.org>, <kadlec@blackhole.kfki.hu>, <fw@strlen.de>
References: <20190531024643.3840-1-yuehaibing@huawei.com>
CC:     <linux-kernel@vger.kernel.org>, <coreteam@netfilter.org>,
        <netfilter-devel@vger.kernel.org>, <netdev@vger.kernel.org>
From:   Yuehaibing <yuehaibing@huawei.com>
Message-ID: <19095cab-fbc5-f200-a40c-cb4c1a12fbc6@huawei.com>
Date:   Fri, 31 May 2019 11:06:49 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.2.0
MIME-Version: 1.0
In-Reply-To: <20190531024643.3840-1-yuehaibing@huawei.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.133.213.239]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

+cc netdev

On 2019/5/31 10:46, YueHaibing wrote:
> Fix gcc build error while CONFIG_IPV6 is not set
> 
> In file included from net/netfilter/core.c:19:0:
> ./include/linux/netfilter_ipv6.h: In function 'nf_ipv6_br_defrag':
> ./include/linux/netfilter_ipv6.h:110:9: error: implicit declaration of function 'nf_ct_frag6_gather' [-Werror=implicit-function-declaration]
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Fixes: 764dd163ac92 ("netfilter: nf_conntrack_bridge: add support for IPv6")
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
>  include/linux/netfilter_ipv6.h | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/include/linux/netfilter_ipv6.h b/include/linux/netfilter_ipv6.h
> index a21b8c9..4ea97fd 100644
> --- a/include/linux/netfilter_ipv6.h
> +++ b/include/linux/netfilter_ipv6.h
> @@ -96,6 +96,8 @@ static inline int nf_ip6_route(struct net *net, struct dst_entry **dst,
>  #endif
>  }
>  
> +int nf_ct_frag6_gather(struct net *net, struct sk_buff *skb, u32 user);
> +
>  static inline int nf_ipv6_br_defrag(struct net *net, struct sk_buff *skb,
>  				    u32 user)
>  {
> 

