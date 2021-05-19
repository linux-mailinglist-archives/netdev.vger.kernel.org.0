Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7C4D389083
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 16:16:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354222AbhESOR5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 10:17:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:41456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1354213AbhESOQa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 May 2021 10:16:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A7381613AA;
        Wed, 19 May 2021 14:15:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621433710;
        bh=ThtU2KVb061FESXUqP9mzeYpSF2o2toGVNDSpucGG1Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sngsqF22KolnPOyLHETglroYOIvZA0VvHpL3bZaBnS48Ix/VgkftHickLfiro7c4N
         8RUIodIc+syR4XcIDEWoCQJGnr1ftbKnd9q3kHbd03qTbYr1C2Svt8jRhyS8zjBg3b
         C07o2vvOe26c1mxp6Z+zaeZlw9kKJsmM38HJO1tgQMnNC9udbgu1d57P0X3XJ7Gvxb
         rx3+Ud/vNx6j9XonRyWBkeDpy0B5x817hXI61fz23tq/s+5la632ZjXcxYuisS4mWi
         7tf9V/GV9FZJ8+qodB2Fyyo6vV8LtpRfduOW/+y7rxl7ZSUJRO/vzVxod4/KdXmYz3
         5gXS8LeADH1AQ==
Date:   Wed, 19 May 2021 19:45:01 +0530
From:   Manivannan Sadhasivam <mani@kernel.org>
To:     Wei Yongjun <weiyongjun1@huawei.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-arm-msm@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, Hulk Robot <hulkci@huawei.com>
Subject: Re: [PATCH net-next] net: qrtr: ns: Fix error return code in
 qrtr_ns_init()
Message-ID: <20210519141501.GA119648@thinkpad>
References: <20210519141621.3044684-1-weiyongjun1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210519141621.3044684-1-weiyongjun1@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 19, 2021 at 02:16:21PM +0000, Wei Yongjun wrote:
> Fix to return a negative error code -ENOMEM from the error handling
> case instead of 0, as done elsewhere in this function.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>

Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

Thanks,
Mani

> ---
>  net/qrtr/ns.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/net/qrtr/ns.c b/net/qrtr/ns.c
> index 8d00dfe8139e..1990d496fcfc 100644
> --- a/net/qrtr/ns.c
> +++ b/net/qrtr/ns.c
> @@ -775,8 +775,10 @@ int qrtr_ns_init(void)
>  	}
>  
>  	qrtr_ns.workqueue = alloc_workqueue("qrtr_ns_handler", WQ_UNBOUND, 1);
> -	if (!qrtr_ns.workqueue)
> +	if (!qrtr_ns.workqueue) {
> +		ret = -ENOMEM;
>  		goto err_sock;
> +	}
>  
>  	qrtr_ns.sock->sk->sk_data_ready = qrtr_ns_data_ready;
>  
> 
