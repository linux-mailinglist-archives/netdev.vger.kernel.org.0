Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD9BB3A296E
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 12:37:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230026AbhFJKi4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 06:38:56 -0400
Received: from mailout1.secunet.com ([62.96.220.44]:42082 "EHLO
        mailout1.secunet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229778AbhFJKi4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 06:38:56 -0400
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout1.secunet.com (Postfix) with ESMTP id 1C356800057;
        Thu, 10 Jun 2021 12:36:56 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 10 Jun 2021 12:36:55 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Thu, 10 Jun
 2021 12:36:55 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 45084318054B; Thu, 10 Jun 2021 12:36:55 +0200 (CEST)
Date:   Thu, 10 Jun 2021 12:36:55 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Huy Nguyen <huyn@nvidia.com>
CC:     <netdev@vger.kernel.org>, <saeedm@nvidia.com>, <borisp@nvidia.com>,
        <raeds@nvidia.com>, <danielj@nvidia.com>, <yossiku@nvidia.com>,
        <kuba@kernel.org>
Subject: Re: [PATCH net-next v4 2/3] net/xfrm: Add inner_ipproto into sec_path
Message-ID: <20210610103655.GS40979@gauss3.secunet.de>
References: <20210607180046.13212-1-huyn@nvidia.com>
 <20210607180046.13212-3-huyn@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210607180046.13212-3-huyn@nvidia.com>
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 07, 2021 at 09:00:45PM +0300, Huy Nguyen wrote:
>  
> +/* For partial checksum offload, the outer header checksum is calculated
> + * by software and the inner header checksum is calculated by hardware.
> + * This requires hardware to know the inner packet type to calculate
> + * the inner header checksum. Save inner ip protocol here to avoid
> + * traversing the packet in the vendor's xmit code.
> + * If the encap type is IPIP, just save skb->inner_ipproto. Otherwise,
> + * get the ip protocol from the IP header.
> + */
> +static void xfrm_get_inner_ipproto(struct sk_buff *skb)
> +{
> +	struct xfrm_offload *xo = xfrm_offload(skb);
> +	const struct ethhdr *eth;
> +
> +	xo = xfrm_offload(skb);

You fetched the xo pointer already above.

