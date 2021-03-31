Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BDC834F843
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 07:24:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233629AbhCaFYF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 01:24:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233650AbhCaFYC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Mar 2021 01:24:02 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79A3FC061574
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 22:24:02 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id 11so13704197pfn.9
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 22:24:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=0mexkIjuXSwiS6AN0D3+0xDxMRVagePR4eP2IRwCk0c=;
        b=Tw93IDsaCraLH4lZrgXROs4s9G5hPYpfXbmoBju6ubI7cqp1PsA8zRN0hw1Fw1pCov
         Q6PGgyAMfcu+ouyuYCM8yBzQic/R7rXQRzTlxHBTDl/TZ3C75ANRCYJQjejFw+h4phO1
         Bst1TGPBT4M+NuWkqBcMh3hp4Oo27pjQvwTxmv7zzKOFL1do2hDkx39uazNXElDPNnAl
         y/qqUh8eux4hCqXNzTlsCJmkf+HanZxv66aKWB1lF8CtnBYqIgfLhscGdoYwNTF2PyOe
         uh9agE6cfm6Jp6Jb3pBcpoklmSZAsjY+7M8/Mppz/bzP9cSAMXOsA93RZbumgEHalcOo
         XD5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=0mexkIjuXSwiS6AN0D3+0xDxMRVagePR4eP2IRwCk0c=;
        b=VwhWZtvA2tI1+tI3qlELAJ+dPt/xy6rELUwNHTZj9tv+N1sSvaQIgcWscn+DsD2wKb
         P7pIe1kv3SPGVjE+V+GhdsXzAPElbkXqKYaGaGEbIm6E0A0ySFlgEVRlRzmREfRfXsiC
         78Z3LGqunAWfVEQ2Tyo0WJbYw7AA5KWb5EJcgc7l/KqZ23HZZUuThHDmLAPUOvENO5yr
         DQbFfQZ0L4Hfx/hruwfB4Dd4k7ERA+TwhaGKIkGI09uHXagVhXXAVOzbxhLHJ1XQM7jA
         M+LbAJj3c0TENKkfuWpb8EAv6/0uc5z8EQWW9nUaMWP9ebtrsvj5pwpuTtI44db+VFTl
         IiuQ==
X-Gm-Message-State: AOAM531gNCh+fAHSrndsHu6k+4rm4cHVkUCbrUhhAYLAtHgF9o62NYxp
        8slFnMrSQTnpUgEnzTjWvGl/
X-Google-Smtp-Source: ABdhPJw/UOOYNcC5xxK+3eCjb/Is8h9e9QIfNxpQD3jfKz/kqTs4X4QT6d/fwkQbKtFNrswfZPdLDw==
X-Received: by 2002:a63:2a88:: with SMTP id q130mr1567773pgq.49.1617168241952;
        Tue, 30 Mar 2021 22:24:01 -0700 (PDT)
Received: from work ([103.77.37.129])
        by smtp.gmail.com with ESMTPSA id j16sm704142pfa.213.2021.03.30.22.23.59
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 30 Mar 2021 22:24:01 -0700 (PDT)
Date:   Wed, 31 Mar 2021 10:53:57 +0530
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc:     Bjorn Andersson <bjorn.andersson@linaro.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Eric Biggers <ebiggers@google.com>
Subject: Re: [PATCH] qrtr: Convert qrtr_ports from IDR to XArray
Message-ID: <20210331052357.GA15610@work>
References: <20210331043643.959675-1-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210331043643.959675-1-willy@infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 31, 2021 at 05:36:42AM +0100, Matthew Wilcox (Oracle) wrote:
> The XArray interface is easier for this driver to use.  Also fixes a
> bug reported by the improper use of GFP_ATOMIC.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

Thanks,
Mani

> ---
>  net/qrtr/qrtr.c | 42 ++++++++++++++----------------------------
>  1 file changed, 14 insertions(+), 28 deletions(-)
> 
> diff --git a/net/qrtr/qrtr.c b/net/qrtr/qrtr.c
> index dfc820ee553a..4b46c69e14ab 100644
> --- a/net/qrtr/qrtr.c
> +++ b/net/qrtr/qrtr.c
> @@ -20,6 +20,8 @@
>  /* auto-bind range */
>  #define QRTR_MIN_EPH_SOCKET 0x4000
>  #define QRTR_MAX_EPH_SOCKET 0x7fff
> +#define QRTR_EPH_PORT_RANGE \
> +		XA_LIMIT(QRTR_MIN_EPH_SOCKET, QRTR_MAX_EPH_SOCKET)
>  
>  /**
>   * struct qrtr_hdr_v1 - (I|R)PCrouter packet header version 1
> @@ -106,8 +108,7 @@ static LIST_HEAD(qrtr_all_nodes);
>  static DEFINE_MUTEX(qrtr_node_lock);
>  
>  /* local port allocation management */
> -static DEFINE_IDR(qrtr_ports);
> -static DEFINE_MUTEX(qrtr_port_lock);
> +static DEFINE_XARRAY_ALLOC(qrtr_ports);
>  
>  /**
>   * struct qrtr_node - endpoint node
> @@ -653,7 +654,7 @@ static struct qrtr_sock *qrtr_port_lookup(int port)
>  		port = 0;
>  
>  	rcu_read_lock();
> -	ipc = idr_find(&qrtr_ports, port);
> +	ipc = xa_load(&qrtr_ports, port);
>  	if (ipc)
>  		sock_hold(&ipc->sk);
>  	rcu_read_unlock();
> @@ -695,9 +696,7 @@ static void qrtr_port_remove(struct qrtr_sock *ipc)
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
> @@ -716,29 +715,20 @@ static void qrtr_port_remove(struct qrtr_sock *ipc)
>   */
>  static int qrtr_port_assign(struct qrtr_sock *ipc, int *port)
>  {
> -	u32 min_port;
>  	int rc;
>  
> -	mutex_lock(&qrtr_port_lock);
>  	if (!*port) {
> -		min_port = QRTR_MIN_EPH_SOCKET;
> -		rc = idr_alloc_u32(&qrtr_ports, ipc, &min_port, QRTR_MAX_EPH_SOCKET, GFP_ATOMIC);
> -		if (!rc)
> -			*port = min_port;
> +		rc = xa_alloc(&qrtr_ports, port, ipc, QRTR_EPH_PORT_RANGE,
> +				GFP_KERNEL);
>  	} else if (*port < QRTR_MIN_EPH_SOCKET && !capable(CAP_NET_ADMIN)) {
>  		rc = -EACCES;
>  	} else if (*port == QRTR_PORT_CTRL) {
> -		min_port = 0;
> -		rc = idr_alloc_u32(&qrtr_ports, ipc, &min_port, 0, GFP_ATOMIC);
> +		rc = xa_insert(&qrtr_ports, 0, ipc, GFP_KERNEL);
>  	} else {
> -		min_port = *port;
> -		rc = idr_alloc_u32(&qrtr_ports, ipc, &min_port, *port, GFP_ATOMIC);
> -		if (!rc)
> -			*port = min_port;
> +		rc = xa_insert(&qrtr_ports, *port, ipc, GFP_KERNEL);
>  	}
> -	mutex_unlock(&qrtr_port_lock);
>  
> -	if (rc == -ENOSPC)
> +	if (rc == -EBUSY)
>  		return -EADDRINUSE;
>  	else if (rc < 0)
>  		return rc;
> @@ -752,20 +742,16 @@ static int qrtr_port_assign(struct qrtr_sock *ipc, int *port)
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
> 2.30.2
> 
