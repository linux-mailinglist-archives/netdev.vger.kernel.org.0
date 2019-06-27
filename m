Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3859857F73
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 11:40:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726425AbfF0Jkc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 05:40:32 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:38256 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726292AbfF0Jkc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 05:40:32 -0400
Received: by mail-wr1-f68.google.com with SMTP id d18so1744483wrs.5
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 02:40:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ZaFDKaeKxhVF5DeCL2y8drhtPFAOM9fEMlkrJ0c/5aA=;
        b=wBa9nV4D3G91vL8B+bLaj0Tn27z1pLDvGU+s4F4wgLtTRg3U0JO4qgonFm6sNVWCgD
         WE9wlRvA97JYP2qe6yUU2V3hn9ZR4RfTWmQo1ir4Tbhf67lMnl7wshkzxyThjmXs3cjL
         fgu5LgMKjN5MTTSwthfDbfJ3X4a3Q2DsfzhQc7ukpaQqWGv2IBpSZR8m2UUs46uxAk3H
         NsHlsdyI1ZK9AHg6Ba37ujMO5nlxMojzcedsicpKyZhvoKZL6Ov9cPCmxrgsThP37eI1
         1IV8L1fIMyE+eaOe4l4bnX9f6M6GaNwjE07hU99rnOd6PAP72925Ddj10PwUuPScYloP
         JVFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ZaFDKaeKxhVF5DeCL2y8drhtPFAOM9fEMlkrJ0c/5aA=;
        b=rr5mfTY9wGGdqfv7n/+DUTpdjnHLRdoGbaW/u1S3moQpGEGXyZI95xcVUFPpU/lVvz
         SSpcmuLHcU6SOnNWNe61wbqZXqjP48zDMBdpapL5TCBx4Nu3WevYq/NUvEqfxGtyYw3L
         3EV/GT3RyI/NXIDpHLHlyLvEaBQ80mK4RquDQGHvBmu+U7kmbCekpOpliSYl/DcyzyAX
         IBPSysT4h36YpY9v9XOu64uz/M9w7kLBZJ1uDqUP0jHevCZW4bfb8ZfUad9xUSIL+3fw
         0wd+fKY7wjt5uB6G6G7HEMamq2U/iwvjdvvdGtitRiEU6EML417IHma2kjGjqJQMqtiG
         Ftfw==
X-Gm-Message-State: APjAAAVQIbZpto79N+sQuiyRwXMRKC1esrxaD4cLWvE0h65fLCROifyo
        11nQXZm/CnlfTgC0T01jGEYeDw==
X-Google-Smtp-Source: APXvYqz0Fx5frLzAttgh41GIzEPqdqH6gsO/Nq9cDOvJ/EQdifmsYze1I9xfXjKHPNRPhatgNs11tw==
X-Received: by 2002:adf:e9c6:: with SMTP id l6mr2573807wrn.216.1561628429779;
        Thu, 27 Jun 2019 02:40:29 -0700 (PDT)
Received: from apalos (athedsl-4461147.home.otenet.gr. [94.71.2.75])
        by smtp.gmail.com with ESMTPSA id a64sm4490714wmf.1.2019.06.27.02.40.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 27 Jun 2019 02:40:29 -0700 (PDT)
Date:   Thu, 27 Jun 2019 12:40:26 +0300
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     netdev@vger.kernel.org, jaswinder.singh@linaro.org,
        ard.biesheuvel@linaro.org, bjorn.topel@intel.com,
        magnus.karlsson@intel.com, daniel@iogearbox.net, ast@kernel.org,
        makita.toshiaki@lab.ntt.co.jp, jakub.kicinski@netronome.com,
        john.fastabend@gmail.com, davem@davemloft.net
Subject: Re: [RFC, PATCH 1/2, net-next] net: netsec: Use page_pool API
Message-ID: <20190627094026.GA21962@apalos>
References: <1561475179-7686-1-git-send-email-ilias.apalodimas@linaro.org>
 <1561475179-7686-2-git-send-email-ilias.apalodimas@linaro.org>
 <20190627113708.67a8575a@carbon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190627113708.67a8575a@carbon>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jepser, 

> On Tue, 25 Jun 2019 18:06:18 +0300
> Ilias Apalodimas <ilias.apalodimas@linaro.org> wrote:
> 
> > @@ -1059,7 +1059,23 @@ static void netsec_setup_tx_dring(struct netsec_priv *priv)
> >  static int netsec_setup_rx_dring(struct netsec_priv *priv)
> >  {
> >  	struct netsec_desc_ring *dring = &priv->desc_ring[NETSEC_RING_RX];
> > -	int i;
> > +	struct page_pool_params pp_params = { 0 };
> > +	int i, err;
> > +
> > +	pp_params.order = 0;
> > +	/* internal DMA mapping in page_pool */
> > +	pp_params.flags = PP_FLAG_DMA_MAP;
> > +	pp_params.pool_size = DESC_NUM;
> > +	pp_params.nid = cpu_to_node(0);
> > +	pp_params.dev = priv->dev;
> > +	pp_params.dma_dir = DMA_FROM_DEVICE;
> 
> I was going to complain about this DMA_FROM_DEVICE, until I noticed
> that in next patch you have:
> 
>  pp_params.dma_dir = xdp_prog ? DMA_BIDIRECTIONAL : DMA_FROM_DEVICE;
True. Since the first patch only adds page_pool support, i wanted to be clear
that DMA_BIDIRECTIONAL is only needed for XDP use cases (and especially XDP_TX)

> 
> Making a note here to help other reviewers.
Thanks

> 
> > +	dring->page_pool = page_pool_create(&pp_params);
> > +	if (IS_ERR(dring->page_pool)) {
> > +		err = PTR_ERR(dring->page_pool);
> > +		dring->page_pool = NULL;
> > +		goto err_out;
> > +	}
> >  

Cheers
/Ilias
