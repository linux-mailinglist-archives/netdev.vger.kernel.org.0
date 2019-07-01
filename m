Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50E795C2A8
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 20:09:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727129AbfGASJx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 14:09:53 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:38031 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727103AbfGASJw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 14:09:52 -0400
Received: by mail-wr1-f68.google.com with SMTP id p11so3649432wro.5
        for <netdev@vger.kernel.org>; Mon, 01 Jul 2019 11:09:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Tom75Cnwd9KKAYGdXJ7Or9I0viw4ifzUP1kVH1ESMr8=;
        b=r26eGlI1oqCOpnXCm4AsDUOM5RswG8gCYs0bjgpUBI0fKoIHZg+WqZxRT1aAsgRSAk
         8kH2SyOCSTp0UduPVOs8QBX0rTJ6o3eGX+oZaYir7F0LxaxU8XXC1mF4U1Vdxub6/Y6g
         S+tOsv4kgy1/rRzES+rFtF0O0jPss2QqcA8D+cC4KtV/TOfrvymqGWL9AA3D/6treW0D
         oClgF5W0X1xWymCtw0qO6uONaqOEylA1/ccMb1yb32Yxrgg2G1yylJRwcYH/TgrbSXga
         rrZYncxZJsEQPyqQwRWNKfRzcq+qY9p5UFfM9TpGA/qvd8ueef+iXyj+L5QFNBGPDj1M
         XI5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Tom75Cnwd9KKAYGdXJ7Or9I0viw4ifzUP1kVH1ESMr8=;
        b=ZsL+80RHCH9gn2vrgryNvsYQ4s6CrxajcexN31+iPMt54jjFdBZ7oS5p59soa/81Rm
         c5kCxm1PPBVulvXJTwJpHE7NJJyqHVw3Kq+AWydoqUd5yf/T8t1/f3+ga7AHWTqZ5We6
         q+zvw4bxCB2uwZq/mjIJcpbb1eGfylDihUJPqyUFvqxjMutWQEGuFf4ywXh/MKdfW1Wn
         GPAN5kPYAzqu3jM0ZIwAsobsOl6NPP5fTjKL+qo/7GePVJQpCAu5tLUkVW7rGcOQxXyU
         34NaIXmVS/vUBFpCww4tA3aNimfJd4YECgOZf5B+nDadfInm4cWJ6lR3BwSZlwJ39nta
         WV1g==
X-Gm-Message-State: APjAAAXAEpsNLY1Z/UBi+Q0DLOkYRzl7EMkOzQLSW0A//JDNNccbC3U2
        8df+2wpAOXxNsMbpCVfab1OolJDKKqk=
X-Google-Smtp-Source: APXvYqyqnPEBYWJD2HDs73mHTpLrCMSCr8+1moM/RFyoqZCzx7VQioeT7CTQ9oag+wGFtPQeWyajcg==
X-Received: by 2002:adf:fb47:: with SMTP id c7mr19185842wrs.116.1562004590929;
        Mon, 01 Jul 2019 11:09:50 -0700 (PDT)
Received: from apalos (athedsl-4461147.home.otenet.gr. [94.71.2.75])
        by smtp.gmail.com with ESMTPSA id n1sm9267934wrx.39.2019.07.01.11.09.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 01 Jul 2019 11:09:50 -0700 (PDT)
Date:   Mon, 1 Jul 2019 21:09:47 +0300
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        grygorii.strashko@ti.com, davem@davemloft.net, ast@kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        netdev@vger.kernel.org, daniel@iogearbox.net,
        jakub.kicinski@netronome.com, john.fastabend@gmail.com
Subject: Re: [PATCH v5 net-next 6/6] net: ethernet: ti: cpsw: add XDP support
Message-ID: <20190701180947.GA11915@apalos>
References: <20190630172348.5692-1-ivan.khoronzhuk@linaro.org>
 <20190630172348.5692-7-ivan.khoronzhuk@linaro.org>
 <20190701181901.150c0b71@carbon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190701181901.150c0b71@carbon>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 01, 2019 at 06:19:01PM +0200, Jesper Dangaard Brouer wrote:
> On Sun, 30 Jun 2019 20:23:48 +0300
> Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org> wrote:
> 
> > +static int cpsw_ndev_create_xdp_rxq(struct cpsw_priv *priv, int ch)
> > +{
> > +	struct cpsw_common *cpsw = priv->cpsw;
> > +	int ret, new_pool = false;
> > +	struct xdp_rxq_info *rxq;
> > +
> > +	rxq = &priv->xdp_rxq[ch];
> > +
> > +	ret = xdp_rxq_info_reg(rxq, priv->ndev, ch);
> > +	if (ret)
> > +		return ret;
> > +
> > +	if (!cpsw->page_pool[ch]) {
> > +		ret =  cpsw_create_rx_pool(cpsw, ch);
> > +		if (ret)
> > +			goto err_rxq;
> > +
> > +		new_pool = true;
> > +	}
> > +
> > +	ret = xdp_rxq_info_reg_mem_model(rxq, MEM_TYPE_PAGE_POOL,
> > +					 cpsw->page_pool[ch]);
> > +	if (!ret)
> > +		return 0;
> > +
> > +	if (new_pool) {
> > +		page_pool_free(cpsw->page_pool[ch]);
> > +		cpsw->page_pool[ch] = NULL;
> > +	}
> > +
> > +err_rxq:
> > +	xdp_rxq_info_unreg(rxq);
> > +	return ret;
> > +}
> 
> Looking at this, and Ilias'es XDP-netsec error handling path, it might
> be a mistake that I removed page_pool_destroy() and instead put the
> responsibility on xdp_rxq_info_unreg().
> 
> As here, we have to detect if page_pool_create() was a success, and then
> if xdp_rxq_info_reg_mem_model() was a failure, explicitly call
> page_pool_free() because the xdp_rxq_info_unreg() call cannot "free"
> the page_pool object given it was not registered.  
> 
> Ivan's patch in[1], might be a better approach, which forced all
> drivers to explicitly call page_pool_free(), even-though it just
> dec-refcnt and the real call to page_pool_free() happened via
> xdp_rxq_info_unreg().
We did discuss that xdp_XXXXX naming might be confusing.
That being said since Ivan's approach serves 'special' hardware and fixes the
naming irregularity, i perfectly fine doing that as long as we clearly document
that the API is supposed to serve a pool per queue (unless the hardware needs to
deal with it differently)
> 
> To better handle error path, I would re-introduce page_pool_destroy(),
> as a driver API, that would gracefully handle NULL-pointer case, and
> then call page_pool_free() with the atomic_dec_and_test().  (It should
> hopefully simplify the error handling code a bit)
> 
> [1] https://lore.kernel.org/netdev/20190625175948.24771-2-ivan.khoronzhuk@linaro.org/
> 
>

Thanks
/Ilias
> > +void cpsw_ndev_destroy_xdp_rxqs(struct cpsw_priv *priv)
> > +{
> > +	struct cpsw_common *cpsw = priv->cpsw;
> > +	struct xdp_rxq_info *rxq;
> > +	int i;
> > +
> > +	for (i = 0; i < cpsw->rx_ch_num; i++) {
> > +		rxq = &priv->xdp_rxq[i];
> > +		if (xdp_rxq_info_is_reg(rxq))
> > +			xdp_rxq_info_unreg(rxq);
> > +	}
> > +}
> 
> Are you sure you need to test xdp_rxq_info_is_reg() here?
> 
> You should just call xdp_rxq_info_unreg(rxq), if you know that this rxq
> should be registered.  If your assumption failed, you will get a
> WARNing, and discover your driver level bug.  This is one of the ways
> the API is designed to "detect" misuse of the API.  (I found this
> rather useful, when I converted the approx 12 drivers using this
> xdp_rxq_info API).
> 
> -- 
> Best regards,
>   Jesper Dangaard Brouer
>   MSc.CS, Principal Kernel Engineer at Red Hat
>   LinkedIn: http://www.linkedin.com/in/brouer
