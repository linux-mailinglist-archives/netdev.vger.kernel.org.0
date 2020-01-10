Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BE421376D6
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 20:20:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728184AbgAJTT7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 14:19:59 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:35660 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727801AbgAJTT7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 14:19:59 -0500
Received: by mail-wr1-f68.google.com with SMTP id g17so2872609wro.2
        for <netdev@vger.kernel.org>; Fri, 10 Jan 2020 11:19:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=i8NVVkamP9B070Nj3ntj5fmApwam985/jaw107pEvyk=;
        b=sb0X62tjBLpBrHNTxPf8rI8QCGcsmFEDfJG2OccRD7fKpiRToCy9l32apwFqdJJZI8
         1c1fqac2AY+rOTEm6zuf0L1sYGqScSsO/RFJHT5fWC+lODyN9JZDzGYxQE1SiIAlfMCP
         1TG371J0ClCXL+zZgLM4XSp2I/YGWT0c0Bbk3jszjnmD7Rd714rNqLApec4SGirMctH1
         3lqP0bhN5dhmV32spfdml9zdkOjGaMjO58M7yC5VkNG4FNK332UMjmkW3hIwBM/HqIup
         UVGKCcSrGp/eIfGItVpf39paD8w4awzeqMLgS4mqAX709TyMGAqDI7A1k3y0ZtVQL+C7
         E//g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=i8NVVkamP9B070Nj3ntj5fmApwam985/jaw107pEvyk=;
        b=q4b47TuYnGVyot6hTUr+qJXHAUDSvWmBlCOMUK4YQb1oofKs+f+GFIABkGPfJtEAUP
         nbu3Or7K2n8EozW6yShkS7tb5rAjuiTVD9JBUVE80AwNvT7DCbv4MnTgRc4HEb01yBW1
         iv4jBByRvtHOQNCOHk4KHSky0px/OKjxBsOkpKM6HHG0Fv3d1lovPswU4TPvIRmSnk0J
         IRtZFfTNqePU20+KCzlS0bE1rEa+TjjZk1XdXCOAPCP3Mj61Yre1zuJHnhVbnizuGz8p
         KZDslwY/d+NNz/m1IljPeuOYtc7I7B/vs/L3Y0MI5C7o4xSvQ5oGR7eqbbkJZWJREGbT
         s9hg==
X-Gm-Message-State: APjAAAUxCNm8+fPCrJhufLZsb+K9vnsjB3XsMaUnezdCkPMOzersTxLi
        yHbGpSWmY6Y6PoJzCokMNkejX/nuFmywDw==
X-Google-Smtp-Source: APXvYqwVNglLHOmn5KLz5p8FmBDRGmFnuSZdx2rRjsI5TYkeHamF85ve9HYxzIOkTpB+pqkj+fRRuQ==
X-Received: by 2002:adf:f501:: with SMTP id q1mr5201006wro.263.1578683997085;
        Fri, 10 Jan 2020 11:19:57 -0800 (PST)
Received: from apalos.home (athedsl-321073.home.otenet.gr. [85.72.109.207])
        by smtp.gmail.com with ESMTPSA id w20sm3253427wmk.34.2020.01.10.11.19.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jan 2020 11:19:56 -0800 (PST)
Date:   Fri, 10 Jan 2020 21:19:54 +0200
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        davem@davemloft.net
Subject: Re: [PATCH v2 net-next] net: socionext: get rid of huge dma sync in
 netsec_alloc_rx_data
Message-ID: <20200110191954.GA72950@apalos.home>
References: <81eeb4aaf1cbbbdcd4f58c5a7f06bdab67f20633.1578664483.git.lorenzo@kernel.org>
 <20200110145631.GA69461@apalos.home>
 <20200110153413.GA31419@localhost.localdomain>
 <20200110183328.219ed2bd@carbon>
 <20200110181940.GB31419@localhost.localdomain>
 <20200110200156.041f063f@carbon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200110200156.041f063f@carbon>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 10, 2020 at 08:01:56PM +0100, Jesper Dangaard Brouer wrote:
> On Fri, 10 Jan 2020 19:19:40 +0100
> Lorenzo Bianconi <lorenzo.bianconi@redhat.com> wrote:
> 
> > > On Fri, 10 Jan 2020 16:34:13 +0100
> > > Lorenzo Bianconi <lorenzo@kernel.org> wrote:
> > >   
> > > > > On Fri, Jan 10, 2020 at 02:57:44PM +0100, Lorenzo Bianconi wrote:    
> > > > > > Socionext driver can run on dma coherent and non-coherent devices.
> > > > > > Get rid of huge dma_sync_single_for_device in netsec_alloc_rx_data since
> > > > > > now the driver can let page_pool API to managed needed DMA sync
> > > > > > 
> > > > > > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > > > > > ---
> > > > > > Changes since v1:
> > > > > > - rely on original frame size for dma sync
> > > > > > ---
> > > > > >  drivers/net/ethernet/socionext/netsec.c | 43 +++++++++++++++----------
> > > > > >  1 file changed, 26 insertions(+), 17 deletions(-)
> > > > > >     
> > > > 
> > > > [...]
> > > >   
> > > > > > @@ -883,6 +881,8 @@ static u32 netsec_xdp_xmit_back(struct netsec_priv *priv, struct xdp_buff *xdp)
> > > > > >  static u32 netsec_run_xdp(struct netsec_priv *priv, struct bpf_prog *prog,
> > > > > >  			  struct xdp_buff *xdp)
> > > > > >  {
> > > > > > +	struct netsec_desc_ring *dring = &priv->desc_ring[NETSEC_RING_RX];
> > > > > > +	unsigned int len = xdp->data_end - xdp->data;    
> > > > > 
> > > > > We need to account for XDP expanding the headers as well here. 
> > > > > So something like max(xdp->data_end(before bpf), xdp->data_end(after bpf)) -
> > > > > xdp->data (original)    
> > > > 
> > > > correct, the corner case that is not covered at the moment is when data_end is
> > > > moved forward by the bpf program. I will fix it in v3. Thx  
> > > 
> > > Maybe we can simplify do:
> > > 
> > >  void *data_start = NETSEC_RXBUF_HEADROOM + xdp->data_hard_start;
> > >  unsigned int len = xdp->data_end - data_start;
> > >   
> > 
> > Hi Jesper,
> > 
> > please correct me if I am wrong but this seems to me the same as v2.
> 
> No, this is v2, where you do:
>    len = xdp->data_end - xdp->data;
> 
> Maybe you mean v1? where you calc len like:
>    len = xdp->data_end - xdp->data_hard_start;
>    
> 
> > The leftover corner case is if xdp->data_end is moved 'forward' by
> > the bpf program (I guess it is possible, right?). In this case we
> > will not sync xdp->data_end(new) - xdp->data_end(old)
> 
> Currently xdp->data_end can only shrink (but I plan to extend it). Yes,
> this corner case is left, but I don't think we need to handle it.  When
> a BPF prog shrink xdp->data_end, then i believe it cannot change that
> part the shunk part any longer.
> 

What about a bpf prog that adds a vlan header for example?
Won't that push extra bytes in the memory the NIC will potentially will write
the next packet, once the memory is recycled?

Regards
/Ilias
> 
> > 
> > > The cache-lines that need to be flushed/synced for_device is the area
> > > used by NIC DMA engine.  We know it will always start at a certain
> > > point (given driver configured hardware to this).
> 
> 
> -- 
> Best regards,
>   Jesper Dangaard Brouer
>   MSc.CS, Principal Kernel Engineer at Red Hat
>   LinkedIn: http://www.linkedin.com/in/brouer
> 
