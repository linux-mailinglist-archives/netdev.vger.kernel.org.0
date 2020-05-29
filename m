Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A3411E78A2
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 10:46:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726729AbgE2Iq2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 04:46:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726064AbgE2IqZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 04:46:25 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4FF5C08C5C6
        for <netdev@vger.kernel.org>; Fri, 29 May 2020 01:46:23 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id k2so952994pjs.2
        for <netdev@vger.kernel.org>; Fri, 29 May 2020 01:46:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=XiIwcIBaCjacNvQQiGLxskNtGMHCMoH6FbpJtFd+1bk=;
        b=xeh7YBtNLEg/HSHajEUKqjg00CUU1WpaXmJGLNkGlhAEyBmFt0sUQ+SEm4iiDCg6Ap
         4hiWdMIri0YvFdptKT236rPnFWAse7EO0mwSgX3dwsi41CIjD5XNM+TpZIXfU0wCkWEa
         F4/S+lzMYxRF4Uvl31ZjzVoEpXMr4ml7Nyh4EKm/gpF2qlJtdNIfcv3d0zdx/eIm3Wyl
         95Bh9PElu3SB0xXOKliink64R6ECiTuBIX4geW1ol4dHZyLEhMz8Bbv2EBwuhD886IHu
         t3+Ovs+G1V6GSYC8sV89Fzj2PGmJ2Uocd19lpFoDNjaHWms+7zgLhy4LtR7JumPEGtTD
         jWWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=XiIwcIBaCjacNvQQiGLxskNtGMHCMoH6FbpJtFd+1bk=;
        b=nHpNsJLx+/cMHxAHJB33qxWFBSumrvDQ+yG2af0MH6MxPbkBsmh5fq3H0HXnHiJ0Xw
         B56rf5sz+wFNlCGB7Vy6IZxnPXZwymOHAmQqsZglRZKtypw9HW4xJcHvL1yT21DHu4g+
         uN/epFEKRjtKFdjpFpbqt1LNtumeYl90UtB5IxzPX9ExNsJruv2S3rrFLpbL9kRtWS2A
         2DePFnMHPq2XQJ7rlau0nuOSzN2VbtQ96OW+YssmBekQsJoUaSBxdpAuw7h+gqxyVMcE
         PtzmfOZS7l+NDJf0mB833E0hxjAVOOVt7iDH+8bJuw4mHOT1JMJpSA31tEN12IRV5UoL
         oCyQ==
X-Gm-Message-State: AOAM531yYLM+SIND6uhZjyL6+GJaEvOjNHipYBNSaBsBlbyxpcDYwqIs
        +VX089ZZCmzZKk1wP8m5K0lE
X-Google-Smtp-Source: ABdhPJw2IVsRy1qcylsIEgJDPGvIMlFPrIHQgr9qNQXu3NhWSVtIWrdCs97oISksqqFQyrjbCnIsZw==
X-Received: by 2002:a17:902:8218:: with SMTP id x24mr7894288pln.150.1590741983196;
        Fri, 29 May 2020 01:46:23 -0700 (PDT)
Received: from Mani-XPS-13-9360 ([2409:4072:6417:1d6e:1408:1e13:b32e:6edf])
        by smtp.gmail.com with ESMTPSA id i29sm6950738pfk.38.2020.05.29.01.46.17
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 29 May 2020 01:46:22 -0700 (PDT)
Date:   Fri, 29 May 2020 14:16:14 +0530
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     Chris Lew <clew@codeaurora.org>
Cc:     davem@davemloft.net, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH] net: qrtr: Allocate workqueue before kernel_bind
Message-ID: <20200529084613.GA23769@Mani-XPS-13-9360>
References: <1590707126-16957-1-git-send-email-clew@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1590707126-16957-1-git-send-email-clew@codeaurora.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 28, 2020 at 04:05:26PM -0700, Chris Lew wrote:
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
> Fixes: 0c2204a4ad71 ("net: qrtr: Migrate nameservice to kernel from userspace")
> Signed-off-by: Chris Lew <clew@codeaurora.org>

Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

Thanks,
Mani

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
