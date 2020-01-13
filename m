Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24F09138F56
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 11:39:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726567AbgAMKjX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 05:39:23 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:45067 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726109AbgAMKjX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jan 2020 05:39:23 -0500
Received: by mail-wr1-f67.google.com with SMTP id j42so7951984wrj.12
        for <netdev@vger.kernel.org>; Mon, 13 Jan 2020 02:39:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=dQ8f56ZN/tVf4Fmykd/+TOCp3i7bYMcxDSDgUDAUo1E=;
        b=I/J1AVKLuQqhO4S+SvzdMffyCXy+uYZgm0c38ngerHwultb5RIZWiuCwQWwTr/bCVL
         CnoAirx+XQ8kXqy8CF+Kc4U9KTjO4nF1xdqenqeGtY8ZYDcCjmNUR1JejKskv1WunuW/
         W0PBAILbJV4dDyiuT8O+5cXT7xz5ur0taXW818sImlZj1DCEqLelqQEIOhTcjfmeV3L6
         EdTiFo94hxK7eCarF17wZbrkDLXxKfQuM2VKBjwMC8GP8TX4Ih55o0IC0a0L8efKTZTo
         1+4koKtXri0ic9WtvgcUdSucgCF07/7FWwvgYL6RaE+CeeRwlR8nuJfyzMOGS/Z6Y6P6
         tHEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dQ8f56ZN/tVf4Fmykd/+TOCp3i7bYMcxDSDgUDAUo1E=;
        b=Vv1EbhLEAQen2AceGtNFa97o60HN8WOboKaMOsj5VR8QWb9wWVc6YK4KhE2CRpfC70
         mgz/vRRI/joDyMyZYlEGZgCPtLrPbkyZc6pbUfJQWFmfkxOp0NLcjnrQxrL1KQZE3Y2c
         97TiArY5pHlfEGYdiq4AIh5Fa+uJj85Fu9y1WUZ7rrw6zeGqbgRsyf5hDItwKJ1QYHJk
         g9J4DBVQm4+KF0Y5YSqtjGlie6j17zxk4UV0+YG+Z+l2WhDgy1bl2o0q3Ij2zRGXTKLV
         tLk/ETn2rSPEKhvWllhoDSlKdlXgtmlk0d87b+7iITd7YiIPlaip6FPbh0EIN+Kg7rJt
         5IjA==
X-Gm-Message-State: APjAAAWhxziycB5POS4Co5COsKCr2P8UuceRo4VYcPIeU3bFIMsdf3Qo
        21IJSFTSSDQOr3oo3Sw5MqnyvQ==
X-Google-Smtp-Source: APXvYqxzktfTfQnEikQlTucXbD1GnAAPNdQhs3MFRBR7WE+4dW4JO/4CeSKVLg+lf94GgaHtz13Yeg==
X-Received: by 2002:adf:e3cd:: with SMTP id k13mr16847045wrm.338.1578911960295;
        Mon, 13 Jan 2020 02:39:20 -0800 (PST)
Received: from apalos.home (athedsl-270514.home.otenet.gr. [85.73.104.80])
        by smtp.gmail.com with ESMTPSA id w19sm13501970wmc.22.2020.01.13.02.39.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jan 2020 02:39:19 -0800 (PST)
Date:   Mon, 13 Jan 2020 12:39:17 +0200
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        netdev@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH v2 net-next] net: socionext: get rid of huge dma sync in
 netsec_alloc_rx_data
Message-ID: <20200113103917.GA115887@apalos.home>
References: <81eeb4aaf1cbbbdcd4f58c5a7f06bdab67f20633.1578664483.git.lorenzo@kernel.org>
 <20200110145631.GA69461@apalos.home>
 <20200110153413.GA31419@localhost.localdomain>
 <20200110183328.219ed2bd@carbon>
 <20200110181940.GB31419@localhost.localdomain>
 <20200110200156.041f063f@carbon>
 <20200110193651.GA14384@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200110193651.GA14384@localhost.localdomain>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 10, 2020 at 08:36:51PM +0100, Lorenzo Bianconi wrote:
> > On Fri, 10 Jan 2020 19:19:40 +0100
> > Lorenzo Bianconi <lorenzo.bianconi@redhat.com> wrote:
> > 
> > > > On Fri, 10 Jan 2020 16:34:13 +0100
> > > > Lorenzo Bianconi <lorenzo@kernel.org> wrote:
> > > >   
> > > > > > On Fri, Jan 10, 2020 at 02:57:44PM +0100, Lorenzo Bianconi wrote:    
> > > > > > > Socionext driver can run on dma coherent and non-coherent devices.
> > > > > > > Get rid of huge dma_sync_single_for_device in netsec_alloc_rx_data since
> > > > > > > now the driver can let page_pool API to managed needed DMA sync
> > > > > > > 
> > > > > > > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > > > > > > ---
> > > > > > > Changes since v1:
> > > > > > > - rely on original frame size for dma sync
> > > > > > > ---
> > > > > > >  drivers/net/ethernet/socionext/netsec.c | 43 +++++++++++++++----------
> > > > > > >  1 file changed, 26 insertions(+), 17 deletions(-)
> > > > > > >     
> > > > > 
> > > > > [...]
> > > > >   
> > > > > > > @@ -883,6 +881,8 @@ static u32 netsec_xdp_xmit_back(struct netsec_priv *priv, struct xdp_buff *xdp)
> > > > > > >  static u32 netsec_run_xdp(struct netsec_priv *priv, struct bpf_prog *prog,
> > > > > > >  			  struct xdp_buff *xdp)
> > > > > > >  {
> > > > > > > +	struct netsec_desc_ring *dring = &priv->desc_ring[NETSEC_RING_RX];
> > > > > > > +	unsigned int len = xdp->data_end - xdp->data;    
> > > > > > 
> > > > > > We need to account for XDP expanding the headers as well here. 
> > > > > > So something like max(xdp->data_end(before bpf), xdp->data_end(after bpf)) -
> > > > > > xdp->data (original)    
> > > > > 
> > > > > correct, the corner case that is not covered at the moment is when data_end is
> > > > > moved forward by the bpf program. I will fix it in v3. Thx  
> > > > 
> > > > Maybe we can simplify do:
> > > > 
> > > >  void *data_start = NETSEC_RXBUF_HEADROOM + xdp->data_hard_start;
> > > >  unsigned int len = xdp->data_end - data_start;
> > > >   
> > > 
> > > Hi Jesper,
> > > 
> > > please correct me if I am wrong but this seems to me the same as v2.
> > 
> > No, this is v2, where you do:
> >    len = xdp->data_end - xdp->data;
> 
> I mean in the solution you proposed you set (before running the bpf program):
> 
> len = xdp->data_end - data_start
> where:
> data_start = NETSEC_RXBUF_HEADROOM + xdp->data_hard_start
> 
> that is equivalent to what I did in v2 (before running the bpf program):
> len = xdp->data_end - xdp->data
> 
> since:
> xdp->data = xdp->data_hard_start + NETSEC_RXBUF_HEADROOM
> (set in netsec_process_rx())
> 
> Am I missing something?
> 
> > 
> > Maybe you mean v1? where you calc len like:
> >    len = xdp->data_end - xdp->data_hard_start;
> >    
> > 
> > > The leftover corner case is if xdp->data_end is moved 'forward' by
> > > the bpf program (I guess it is possible, right?). In this case we
> > > will not sync xdp->data_end(new) - xdp->data_end(old)
> > 
> > Currently xdp->data_end can only shrink (but I plan to extend it). Yes,
> > this corner case is left, but I don't think we need to handle it.  When
> > a BPF prog shrink xdp->data_end, then i believe it cannot change that
> > part the shunk part any longer.
> > 

Ok, i thought it could expand as well.
If that's the case the current patchset is ok

> 
> ack, fine to me.
> 
> Regards,
> Lorenzo
> 
> > 
> > > 
> > > > The cache-lines that need to be flushed/synced for_device is the area
> > > > used by NIC DMA engine.  We know it will always start at a certain
> > > > point (given driver configured hardware to this).
> > 
> > 
> > -- 
> > Best regards,
> >   Jesper Dangaard Brouer
> >   MSc.CS, Principal Kernel Engineer at Red Hat
> >   LinkedIn: http://www.linkedin.com/in/brouer
> > 

Reviewed-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
