Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE17C1A3A99
	for <lists+netdev@lfdr.de>; Thu,  9 Apr 2020 21:35:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726777AbgDITfx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Apr 2020 15:35:53 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:43697 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725987AbgDITfx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Apr 2020 15:35:53 -0400
Received: by mail-pg1-f196.google.com with SMTP id s4so5419763pgk.10
        for <netdev@vger.kernel.org>; Thu, 09 Apr 2020 12:35:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ZFP+FR08i1s+W9X/XmCSBipjwAMer5IJn5kP7NkKJSQ=;
        b=HIYBjOt621x44z9HbG9j4NfjwMFl6MJKebKLQcx5wGrwENvjwPquktrGcT3wBFq5Ck
         /Xhs+b7DcYyVxNaX9dtaIkK0yDcfUlVdiZ5rgkhovmxc1HdtjgW7kscnsabVieQnMFvy
         jOdVas7tP8po0Lq69NS0gxa+2iZlHe99/KZeM3H0vl2rqS2Fvmm0HaMpgxOQ3k0nZpM+
         N0122VJZeB8i+QUy3FDOjWECfOYLB2cNwQYgO3SaAYVt8CLCDgYDvj+XPpt/aBZeKm29
         iTKmBxvna2NLCgTnsZyvo4wbTy+qFcpKClx5UbXwEnYRvMJzhXikwMT7jVjoBSi2318X
         pdWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ZFP+FR08i1s+W9X/XmCSBipjwAMer5IJn5kP7NkKJSQ=;
        b=sC+khr0dvNeX4Ir6V1U2A+5L0k/jklWpeHnnpdsj9qb1h3qtWKKNTLpkMGuUNr0EZ0
         l660YqVn7LK72/CMIBL81GBV3JAoj+YJ7tB4lwN4CGcb1O4KmYcWVrS25TYtWkPjJPo5
         GSkHCh4yqhxNXp1jWemUPEIzjjcf7FYH4opyFDlrswUPekyFjGG3VlabMe6ABvGHxtd5
         Hp8CfrQd744Nd6MCqI4DPz5JGQZhqsRUZOVpVO6bRgM6AwHgKpeUnN8Lp8l4teevP/2R
         sAuCQJlrKujRB6OYyja9tXJ2gQKiAkby0799uOyvr3BG752n4CM1qCu/Jclz54evturL
         RV5w==
X-Gm-Message-State: AGi0Pub9AT5ehNSZJK9xy8CGIqJh2sACV1imZzm3CW614b7cjMHnJaTF
        z/nmTOBp3XPaF18wAeUTRNFBMjE6UDU=
X-Google-Smtp-Source: APiQypJpng2c9uyJ13km8UqsABXbC96LzH37XJys7RkPANWfPwe1duDDCSXKaU0/QcMa0l+eZylFRw==
X-Received: by 2002:a63:d4f:: with SMTP id 15mr984185pgn.237.1586460952679;
        Thu, 09 Apr 2020 12:35:52 -0700 (PDT)
Received: from builder.lan (104-188-17-28.lightspeed.sndgca.sbcglobal.net. [104.188.17.28])
        by smtp.gmail.com with ESMTPSA id o12sm2838199pjt.16.2020.04.09.12.35.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Apr 2020 12:35:51 -0700 (PDT)
Date:   Thu, 9 Apr 2020 12:36:00 -0700
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     WANG Wenhu <wenhu.wang@vivo.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Carl Huang <cjhuang@codeaurora.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arnd Bergmann <arnd@arndb.de>,
        Nicholas Mc Guire <hofrat@osadl.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel@vivo.com
Subject: Re: [PATCH v2] net: qrtr: send msgs from local of same id as
 broadcast
Message-ID: <20200409193600.GR20625@builder.lan>
References: <20200407132930.109738-1-wenhu.wang@vivo.com>
 <20200408033249.120608-1-wenhu.wang@vivo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200408033249.120608-1-wenhu.wang@vivo.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue 07 Apr 20:32 PDT 2020, WANG Wenhu wrote:

> From: Wang Wenhu <wenhu.wang@vivo.com>
> 
> If the local node id(qrtr_local_nid) is not modified after its
> initialization, it equals to the broadcast node id(QRTR_NODE_BCAST).
> So the messages from local node should not be taken as broadcast
> and keep the process going to send them out anyway.
> 
> The definitions are as follow:
> static unsigned int qrtr_local_nid = NUMA_NO_NODE;
> 
> Fixes: commit fdf5fd397566 ("net: qrtr: Broadcast messages only from control port")
> Signed-off-by: Wang Wenhu <wenhu.wang@vivo.com>
> ---
> Changlog:
>  - For coding style, line up the newline of the if conditional judgement
>    with the one exists before.
> 
>  net/qrtr/qrtr.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/net/qrtr/qrtr.c b/net/qrtr/qrtr.c
> index 5a8e42ad1504..545a61f8ef75 100644
> --- a/net/qrtr/qrtr.c
> +++ b/net/qrtr/qrtr.c
> @@ -907,20 +907,21 @@ static int qrtr_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
>  
>  	node = NULL;
>  	if (addr->sq_node == QRTR_NODE_BCAST) {
> -		enqueue_fn = qrtr_bcast_enqueue;
> -		if (addr->sq_port != QRTR_PORT_CTRL) {
> +		if (addr->sq_port != QRTR_PORT_CTRL &&
> +			qrtr_local_nid != QRTR_NODE_BCAST) {

So this would mean that if local_nid is configured to be the bcast
address then rather than rejecting messages to non-control ports we will
broadcast them.

What happens when some other node in the network replies? Wouldn't it be
better to explicitly prohibit usage of the bcast address as our node
address?


That said, in torvalds/master qrtr_local_nid is no longer initialized to
QRTR_NODE_BCAST, but 1. So I don't think you need this patch anymore.

Regards,
Bjorn

>  			release_sock(sk);
>  			return -ENOTCONN;
>  		}
> +		enqueue_fn = qrtr_bcast_enqueue;
>  	} else if (addr->sq_node == ipc->us.sq_node) {
>  		enqueue_fn = qrtr_local_enqueue;
>  	} else {
> -		enqueue_fn = qrtr_node_enqueue;
>  		node = qrtr_node_lookup(addr->sq_node);
>  		if (!node) {
>  			release_sock(sk);
>  			return -ECONNRESET;
>  		}
> +		enqueue_fn = qrtr_node_enqueue;
>  	}
>  
>  	plen = (len + 3) & ~3;
> -- 
> 2.17.1
> 
