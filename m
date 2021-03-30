Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 472BB34F43C
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 00:29:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232925AbhC3W3W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 18:29:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232793AbhC3W3C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 18:29:02 -0400
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E06CC061574
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 15:29:02 -0700 (PDT)
Received: by mail-oi1-x22f.google.com with SMTP id i81so18050589oif.6
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 15:29:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=iyDCjIBIws/L+ehTZjgIrvz5lT2+FOTwj4ya3SPVdDY=;
        b=U4tcQ6jeyjswBjf3xXHnp/8KdiETlBa8qCJQZIMH5Ht+UrJav8wCdcqdf3ZEjXQlNm
         ph2VJHgdTYgiXCqVWhEmYA6nfG5kKAcjp0Gc1VBsdlwoTLUD5kIPkZl7PqO6eVBYkETX
         UjUa9x7G3cualBtRfCZcQZKfQg8+JkVN9m97xpxf29Yz9RCY6sO0JSuFAjoahPDNwtil
         u9nHmJbCE1PJTMne+FQyE8Zb+8x7j7BkQqwCSNYFTlEXrOQA5hnd4FuCVnb5FPtgRmle
         VdFIbOxT2QzKz+KlQ8FCeWslUCCT2GYRap6HGBm7z0Bkp0K8UsdrE/beKhkoTeELCMAX
         drhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=iyDCjIBIws/L+ehTZjgIrvz5lT2+FOTwj4ya3SPVdDY=;
        b=tUkXHMAPlDZsOB/09QavoETRqP7pZTs07FFGGtUunQ/vfZ66j6PTRbS7L5oguCj2Ey
         ujvwrb0Iyn4OSzCIjC87ueH1OlgtTGJRq1A+/zzPHF2II6GETCmi+TPW2yMh7SdBCnZS
         nhjPOTJ81NmnVu7iRIA5AhXirLy5BjK1sdRO8QeeyDrQ37/qMMXgikpfkIVg4IwVHaRa
         q97+1+PGJukJqCcODg6a1JSytKvIjeF3MdqYae0ln/MmfhoCPmrckkabWYX5h1hwk6n7
         kFwNpv6O07RDEhCQCqfLmJRPbmmYQ0XpJ4trEYUsN6dUC1m0/S6zAovxKnQOlsQTpFc1
         17hw==
X-Gm-Message-State: AOAM531tO4KUFlar/6VSTihU5BmF7/I0SLykkrO6OsXBxoJi/156dsKo
        cf83KTwVIxF9p9eTbEfVm8SepA==
X-Google-Smtp-Source: ABdhPJwwrtJB9x5NdvoHcnT+CH178PjF01/Ush1Ws5a4Ka8purBuvngl9l0sJAk82fHIvcpP5Je61w==
X-Received: by 2002:aca:ebd3:: with SMTP id j202mr138732oih.14.1617143341313;
        Tue, 30 Mar 2021 15:29:01 -0700 (PDT)
Received: from yoga (104-57-184-186.lightspeed.austtx.sbcglobal.net. [104.57.184.186])
        by smtp.gmail.com with ESMTPSA id v1sm57873ooh.3.2021.03.30.15.29.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Mar 2021 15:29:00 -0700 (PDT)
Date:   Tue, 30 Mar 2021 17:28:58 -0500
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc:     Matthew Wilcox <willy@infradead.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Eric Biggers <ebiggers@google.com>
Subject: Re: [PATCH] qrtr: Convert qrtr_ports from IDR to XArray
Message-ID: <20210330222858.GI904837@yoga>
References: <20200605120037.17427-1-willy@infradead.org>
 <20210330180445.GB27256@work>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210330180445.GB27256@work>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue 30 Mar 13:04 CDT 2021, Manivannan Sadhasivam wrote:

> On Fri, Jun 05, 2020 at 05:00:37AM -0700, Matthew Wilcox wrote:
> > From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> > 
> > The XArray interface is easier for this driver to use.  Also fixes a
> > bug reported by the improper use of GFP_ATOMIC.
> > 
> > Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> 
> Patch looks good to me. Can you please rebase it on top of netdev or
> v5.12-rc2 and resend?
> 

I asked Jay from Qualcomm to do this a few days ago, so we should
hopefully see this on the list shortly.

Regards,
Bjorn

> Thanks,
> Mani
> 
> > ---
> >  net/qrtr/qrtr.c | 39 +++++++++++++--------------------------
> >  1 file changed, 13 insertions(+), 26 deletions(-)
> > 
> > diff --git a/net/qrtr/qrtr.c b/net/qrtr/qrtr.c
> > index 2d8d6131bc5f..488f8f326ee5 100644
> > --- a/net/qrtr/qrtr.c
> > +++ b/net/qrtr/qrtr.c
> > @@ -20,6 +20,7 @@
> >  /* auto-bind range */
> >  #define QRTR_MIN_EPH_SOCKET 0x4000
> >  #define QRTR_MAX_EPH_SOCKET 0x7fff
> > +#define QRTR_PORT_RANGE	XA_LIMIT(QRTR_MIN_EPH_SOCKET, QRTR_MAX_EPH_SOCKET)
> >  
> >  /**
> >   * struct qrtr_hdr_v1 - (I|R)PCrouter packet header version 1
> > @@ -106,8 +107,7 @@ static LIST_HEAD(qrtr_all_nodes);
> >  static DEFINE_MUTEX(qrtr_node_lock);
> >  
> >  /* local port allocation management */
> > -static DEFINE_IDR(qrtr_ports);
> > -static DEFINE_MUTEX(qrtr_port_lock);
> > +static DEFINE_XARRAY_ALLOC(qrtr_ports);
> >  
> >  /**
> >   * struct qrtr_node - endpoint node
> > @@ -623,7 +623,7 @@ static struct qrtr_sock *qrtr_port_lookup(int port)
> >  		port = 0;
> >  
> >  	rcu_read_lock();
> > -	ipc = idr_find(&qrtr_ports, port);
> > +	ipc = xa_load(&qrtr_ports, port);
> >  	if (ipc)
> >  		sock_hold(&ipc->sk);
> >  	rcu_read_unlock();
> > @@ -665,9 +665,7 @@ static void qrtr_port_remove(struct qrtr_sock *ipc)
> >  
> >  	__sock_put(&ipc->sk);
> >  
> > -	mutex_lock(&qrtr_port_lock);
> > -	idr_remove(&qrtr_ports, port);
> > -	mutex_unlock(&qrtr_port_lock);
> > +	xa_erase(&qrtr_ports, port);
> >  
> >  	/* Ensure that if qrtr_port_lookup() did enter the RCU read section we
> >  	 * wait for it to up increment the refcount */
> > @@ -688,25 +686,18 @@ static int qrtr_port_assign(struct qrtr_sock *ipc, int *port)
> >  {
> >  	int rc;
> >  
> > -	mutex_lock(&qrtr_port_lock);
> >  	if (!*port) {
> > -		rc = idr_alloc(&qrtr_ports, ipc,
> > -			       QRTR_MIN_EPH_SOCKET, QRTR_MAX_EPH_SOCKET + 1,
> > -			       GFP_ATOMIC);
> > -		if (rc >= 0)
> > -			*port = rc;
> > +		rc = xa_alloc(&qrtr_ports, port, ipc, QRTR_PORT_RANGE,
> > +				GFP_KERNEL);
> >  	} else if (*port < QRTR_MIN_EPH_SOCKET && !capable(CAP_NET_ADMIN)) {
> >  		rc = -EACCES;
> >  	} else if (*port == QRTR_PORT_CTRL) {
> > -		rc = idr_alloc(&qrtr_ports, ipc, 0, 1, GFP_ATOMIC);
> > +		rc = xa_insert(&qrtr_ports, 0, ipc, GFP_KERNEL);
> >  	} else {
> > -		rc = idr_alloc(&qrtr_ports, ipc, *port, *port + 1, GFP_ATOMIC);
> > -		if (rc >= 0)
> > -			*port = rc;
> > +		rc = xa_insert(&qrtr_ports, *port, ipc, GFP_KERNEL);
> >  	}
> > -	mutex_unlock(&qrtr_port_lock);
> >  
> > -	if (rc == -ENOSPC)
> > +	if (rc == -EBUSY)
> >  		return -EADDRINUSE;
> >  	else if (rc < 0)
> >  		return rc;
> > @@ -720,20 +711,16 @@ static int qrtr_port_assign(struct qrtr_sock *ipc, int *port)
> >  static void qrtr_reset_ports(void)
> >  {
> >  	struct qrtr_sock *ipc;
> > -	int id;
> > -
> > -	mutex_lock(&qrtr_port_lock);
> > -	idr_for_each_entry(&qrtr_ports, ipc, id) {
> > -		/* Don't reset control port */
> > -		if (id == 0)
> > -			continue;
> > +	unsigned long index;
> >  
> > +	rcu_read_lock();
> > +	xa_for_each_start(&qrtr_ports, index, ipc, 1) {
> >  		sock_hold(&ipc->sk);
> >  		ipc->sk.sk_err = ENETRESET;
> >  		ipc->sk.sk_error_report(&ipc->sk);
> >  		sock_put(&ipc->sk);
> >  	}
> > -	mutex_unlock(&qrtr_port_lock);
> > +	rcu_read_unlock();
> >  }
> >  
> >  /* Bind socket to address.
> > -- 
> > 2.26.2
> > 
