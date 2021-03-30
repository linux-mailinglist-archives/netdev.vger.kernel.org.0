Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40A9634F076
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 20:05:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229626AbhC3SFJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 14:05:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232502AbhC3SEt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 14:04:49 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B8CBC061574
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 11:04:49 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id w10so7963030pgh.5
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 11:04:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=5rdl5YwsTYTcXRqQ8Z6Dcr76jZBgzlcUh5V2aYDOzwQ=;
        b=RivjAW2X7oz2Vdd2sAugXQ2EfYIkbRCjmygk39Z9gegduphgEMUrrayyzu9aWnGlAz
         CTe7Y5nTSzF6H6hQPq2+LjUzscFqZ+IQO9r0CSy+RVF/HoaJ0esHdpjZPcKKOHfVzxwD
         JmR0J+XHNmdOOb8ZVHUMkAhNgJ4xzKOVPEaaX7gDlwA4FeCovc00ZSnnuH5rZ/lhE1E0
         4phnRh2t/OAZiPXRxmKPBVhyUaB7x9Y2AP1CE7DxxuMOX42cIWKEyyu17U+dbvgV++xf
         l60rqicgNT9BLLlza8hJup4TBd5V/B9KXlaIA3zeT3V+wtqjILXBfGxnadQdLt42G8Ne
         rtxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=5rdl5YwsTYTcXRqQ8Z6Dcr76jZBgzlcUh5V2aYDOzwQ=;
        b=gL4X2opFTgdKeq4/2/UarKYWgDx/iLHigpqBv2JuQl+dUvdIL7NKo+Du/6tbCDGXnT
         92YOq2yWlUtGeCRq5RGWD3TCFqZBCtiz+M0PKixqDvEBPZf/B2aZ8rVS40LfWGEl77rQ
         hosNBcOQpxOJDOL+AO+873M/sR0i8oUq5lSuO0ZHvdWyJjVjRjxH2YAXzuNRqc1jqZ5e
         6B23FHViJQv9sJ9h0wOsSZUhS5RvlxpRiWXHv+HaBn0mMANBsdtJV1n/SyZZOWBIVLS0
         Ew41Ipup/+/bQ8At+FSJnCG6/NDZFkLKXQjVik1525AMb3LH7DmILO0dl6/0l2FOycW6
         A7pw==
X-Gm-Message-State: AOAM531UoDPvlz1IeJwjOcijDsJAe7PLsoyDEBMyYCu+K9DbI0zFlUK3
        A/W+gzzuHCYXmtlLSvG9+hBY
X-Google-Smtp-Source: ABdhPJynjbespSF1hHd1Ir4/6xEoe9K5/dwd6bUgzXfzk0wJeLbr12RxQ2jG131hP9DnqYes8TbBJg==
X-Received: by 2002:a63:d40b:: with SMTP id a11mr29144794pgh.192.1617127488931;
        Tue, 30 Mar 2021 11:04:48 -0700 (PDT)
Received: from work ([103.77.37.178])
        by smtp.gmail.com with ESMTPSA id z4sm20814804pgv.73.2021.03.30.11.04.46
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 30 Mar 2021 11:04:48 -0700 (PDT)
Date:   Tue, 30 Mar 2021 23:34:45 +0530
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Bjorn Andersson <bjorn.andersson@linaro.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Eric Biggers <ebiggers@google.com>
Subject: Re: [PATCH] qrtr: Convert qrtr_ports from IDR to XArray
Message-ID: <20210330180445.GB27256@work>
References: <20200605120037.17427-1-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200605120037.17427-1-willy@infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 05, 2020 at 05:00:37AM -0700, Matthew Wilcox wrote:
> From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> 
> The XArray interface is easier for this driver to use.  Also fixes a
> bug reported by the improper use of GFP_ATOMIC.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

Patch looks good to me. Can you please rebase it on top of netdev or
v5.12-rc2 and resend?

Thanks,
Mani

> ---
>  net/qrtr/qrtr.c | 39 +++++++++++++--------------------------
>  1 file changed, 13 insertions(+), 26 deletions(-)
> 
> diff --git a/net/qrtr/qrtr.c b/net/qrtr/qrtr.c
> index 2d8d6131bc5f..488f8f326ee5 100644
> --- a/net/qrtr/qrtr.c
> +++ b/net/qrtr/qrtr.c
> @@ -20,6 +20,7 @@
>  /* auto-bind range */
>  #define QRTR_MIN_EPH_SOCKET 0x4000
>  #define QRTR_MAX_EPH_SOCKET 0x7fff
> +#define QRTR_PORT_RANGE	XA_LIMIT(QRTR_MIN_EPH_SOCKET, QRTR_MAX_EPH_SOCKET)
>  
>  /**
>   * struct qrtr_hdr_v1 - (I|R)PCrouter packet header version 1
> @@ -106,8 +107,7 @@ static LIST_HEAD(qrtr_all_nodes);
>  static DEFINE_MUTEX(qrtr_node_lock);
>  
>  /* local port allocation management */
> -static DEFINE_IDR(qrtr_ports);
> -static DEFINE_MUTEX(qrtr_port_lock);
> +static DEFINE_XARRAY_ALLOC(qrtr_ports);
>  
>  /**
>   * struct qrtr_node - endpoint node
> @@ -623,7 +623,7 @@ static struct qrtr_sock *qrtr_port_lookup(int port)
>  		port = 0;
>  
>  	rcu_read_lock();
> -	ipc = idr_find(&qrtr_ports, port);
> +	ipc = xa_load(&qrtr_ports, port);
>  	if (ipc)
>  		sock_hold(&ipc->sk);
>  	rcu_read_unlock();
> @@ -665,9 +665,7 @@ static void qrtr_port_remove(struct qrtr_sock *ipc)
>  
>  	__sock_put(&ipc->sk);
>  
> -	mutex_lock(&qrtr_port_lock);
> -	idr_remove(&qrtr_ports, port);
> -	mutex_unlock(&qrtr_port_lock);
> +	xa_erase(&qrtr_ports, port);
>  
>  	/* Ensure that if qrtr_port_lookup() did enter the RCU read section we
>  	 * wait for it to up increment the refcount */
> @@ -688,25 +686,18 @@ static int qrtr_port_assign(struct qrtr_sock *ipc, int *port)
>  {
>  	int rc;
>  
> -	mutex_lock(&qrtr_port_lock);
>  	if (!*port) {
> -		rc = idr_alloc(&qrtr_ports, ipc,
> -			       QRTR_MIN_EPH_SOCKET, QRTR_MAX_EPH_SOCKET + 1,
> -			       GFP_ATOMIC);
> -		if (rc >= 0)
> -			*port = rc;
> +		rc = xa_alloc(&qrtr_ports, port, ipc, QRTR_PORT_RANGE,
> +				GFP_KERNEL);
>  	} else if (*port < QRTR_MIN_EPH_SOCKET && !capable(CAP_NET_ADMIN)) {
>  		rc = -EACCES;
>  	} else if (*port == QRTR_PORT_CTRL) {
> -		rc = idr_alloc(&qrtr_ports, ipc, 0, 1, GFP_ATOMIC);
> +		rc = xa_insert(&qrtr_ports, 0, ipc, GFP_KERNEL);
>  	} else {
> -		rc = idr_alloc(&qrtr_ports, ipc, *port, *port + 1, GFP_ATOMIC);
> -		if (rc >= 0)
> -			*port = rc;
> +		rc = xa_insert(&qrtr_ports, *port, ipc, GFP_KERNEL);
>  	}
> -	mutex_unlock(&qrtr_port_lock);
>  
> -	if (rc == -ENOSPC)
> +	if (rc == -EBUSY)
>  		return -EADDRINUSE;
>  	else if (rc < 0)
>  		return rc;
> @@ -720,20 +711,16 @@ static int qrtr_port_assign(struct qrtr_sock *ipc, int *port)
>  static void qrtr_reset_ports(void)
>  {
>  	struct qrtr_sock *ipc;
> -	int id;
> -
> -	mutex_lock(&qrtr_port_lock);
> -	idr_for_each_entry(&qrtr_ports, ipc, id) {
> -		/* Don't reset control port */
> -		if (id == 0)
> -			continue;
> +	unsigned long index;
>  
> +	rcu_read_lock();
> +	xa_for_each_start(&qrtr_ports, index, ipc, 1) {
>  		sock_hold(&ipc->sk);
>  		ipc->sk.sk_err = ENETRESET;
>  		ipc->sk.sk_error_report(&ipc->sk);
>  		sock_put(&ipc->sk);
>  	}
> -	mutex_unlock(&qrtr_port_lock);
> +	rcu_read_unlock();
>  }
>  
>  /* Bind socket to address.
> -- 
> 2.26.2
> 
