Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F4431E7205
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 03:20:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438346AbgE2BUL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 21:20:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2438280AbgE2BUK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 21:20:10 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8B7DC08C5C7
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 18:20:09 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id nu7so402852pjb.0
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 18:20:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=CIuZ+Yn1aaMK9WhAfm/hcRWbq+KsBQmrxG2/Liqk9N8=;
        b=Cl51k3H2PZVUygzELXZlXSlQTCGXIiD5HgsVvP6MpuVGtv44XKH6upwiIIp++EvlxM
         uQ4i+B/0kD8jBWpqz96G+SIwgfXH7ESHoNTLIdqfrnoVPREVZ9GBKdrGv/lmXoC8QYQb
         kuMbfgtIru1mbFVe/L/NjhPdzFuugjszhW6uFxp8InMSmc+SlBn/a4ZVjMlbqXnzZedR
         iNqsQOS6DCRyq/6sDpe1KS2WL0WIl9KWi6VAZnfnKnNUM3R/ujVhvnqWVsgVhHT1zyf8
         mVughTAOm3oRRaV4d6MLDQQsg3+jVxtbucCNYr/t78DI4br5QpgV8LpE9GoC4G4TJMCE
         8opg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=CIuZ+Yn1aaMK9WhAfm/hcRWbq+KsBQmrxG2/Liqk9N8=;
        b=esPhgBJA1m7js/Xc5mjiqdZeikd9hgA1c0yTyimRDszaNKgMlQ6GzkQh5YBoeWWBhg
         UtO9qu9x2RO39Ogc6QxsXDARdb62WzJVhd6JhFTc/CXxgFTbP0o/0COLtKf4wC72KOsP
         CqXafY2RQcmGdG6w+MTWooSgjKfVP7rm8BUZW7kEYdLQMwLv4ecvdJfyinXk5T1gdfH2
         zZtSvaHRthX4nX1bwnQk/66+YL3wk9VRQJ70F7VK6KZkVP7w4fQWT9Bhpled9vM9KBUF
         mr84tS0iPiOjB8Eww2sQaIIRnzYzkeAPmkgLF74sqtekoCmQidTN6vXZh8MUHbFROd5I
         RPjw==
X-Gm-Message-State: AOAM533AMiNydQUiHK1NKwvs19wu035o8giqj+9fHzCN2BehZPVXB9g5
        G+5us0INSIxsQkNXyLn0S3dv1N5pWbg=
X-Google-Smtp-Source: ABdhPJy+feqGwdjtzTkUZpZoR9F4XcE3qsPUfk2ZKabbt6FatNZJhmrSe/ZIeM6IB2C/vxomZdJShA==
X-Received: by 2002:a17:90a:240c:: with SMTP id h12mr1410281pje.42.1590715209124;
        Thu, 28 May 2020 18:20:09 -0700 (PDT)
Received: from builder.lan (104-188-17-28.lightspeed.sndgca.sbcglobal.net. [104.188.17.28])
        by smtp.gmail.com with ESMTPSA id gz19sm5968301pjb.33.2020.05.28.18.20.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 May 2020 18:20:08 -0700 (PDT)
Date:   Thu, 28 May 2020 18:19:03 -0700
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Chris Lew <clew@codeaurora.org>
Cc:     davem@davemloft.net, manivannan.sadhasivam@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH] net: qrtr: Allocate workqueue before kernel_bind
Message-ID: <20200529011903.GK279327@builder.lan>
References: <1590707126-16957-1-git-send-email-clew@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1590707126-16957-1-git-send-email-clew@codeaurora.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu 28 May 16:05 PDT 2020, Chris Lew wrote:

> A null pointer dereference in qrtr_ns_data_ready() is seen if a client
> opens a qrtr socket before qrtr_ns_init() can bind to the control port.
> When the control port is bound, the ENETRESET error will be broadcasted
> and clients will close their sockets. This results in DEL_CLIENT
> packets being sent to the ns and qrtr_ns_data_ready() being called
> without the workqueue being allocated.
> 
> Allocate the workqueue before setting sk_data_ready and binding to the
> control port. This ensures that the work and workqueue structs are
> allocated and initialized before qrtr_ns_data_ready can be called.
> 

Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>

Regards,
Bjorn

> Fixes: 0c2204a4ad71 ("net: qrtr: Migrate nameservice to kernel from userspace")
> Signed-off-by: Chris Lew <clew@codeaurora.org>
> ---
>  net/qrtr/ns.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/net/qrtr/ns.c b/net/qrtr/ns.c
> index e7d0fe3f4330..c5b3202a14ca 100644
> --- a/net/qrtr/ns.c
> +++ b/net/qrtr/ns.c
> @@ -712,6 +712,10 @@ void qrtr_ns_init(void)
>  		goto err_sock;
>  	}
>  
> +	qrtr_ns.workqueue = alloc_workqueue("qrtr_ns_handler", WQ_UNBOUND, 1);
> +	if (!qrtr_ns.workqueue)
> +		goto err_sock;
> +
>  	qrtr_ns.sock->sk->sk_data_ready = qrtr_ns_data_ready;
>  
>  	sq.sq_port = QRTR_PORT_CTRL;
> @@ -720,17 +724,13 @@ void qrtr_ns_init(void)
>  	ret = kernel_bind(qrtr_ns.sock, (struct sockaddr *)&sq, sizeof(sq));
>  	if (ret < 0) {
>  		pr_err("failed to bind to socket\n");
> -		goto err_sock;
> +		goto err_wq;
>  	}
>  
>  	qrtr_ns.bcast_sq.sq_family = AF_QIPCRTR;
>  	qrtr_ns.bcast_sq.sq_node = QRTR_NODE_BCAST;
>  	qrtr_ns.bcast_sq.sq_port = QRTR_PORT_CTRL;
>  
> -	qrtr_ns.workqueue = alloc_workqueue("qrtr_ns_handler", WQ_UNBOUND, 1);
> -	if (!qrtr_ns.workqueue)
> -		goto err_sock;
> -
>  	ret = say_hello(&qrtr_ns.bcast_sq);
>  	if (ret < 0)
>  		goto err_wq;
> -- 
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
> a Linux Foundation Collaborative Project
> 
