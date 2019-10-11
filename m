Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3423DD43F8
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 17:16:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726891AbfJKPQe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 11:16:34 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:40236 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726331AbfJKPQe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Oct 2019 11:16:34 -0400
Received: by mail-wm1-f66.google.com with SMTP id b24so10588292wmj.5
        for <netdev@vger.kernel.org>; Fri, 11 Oct 2019 08:16:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=QRYgxr5D5ScBd2KqG5liFxSiSuxfSIfRa9EBPtMyEuo=;
        b=UpxS6hx8lT3WrKnyNqMOLRF5uMIe5JqcXzqjCq5iKonu2Yju/ZyJDTjH4E9RX8k00W
         QezzJAxhFFJuiIE+yoisO73jq2o3Hp/J4NdmxbMv0WMow7mwcOAnIiAR2aaInfYAFBsW
         4cNAYn+P+MShjqSbRdIZhDxBS7PvtLK2xWhQtknw+skh7F0Co91fWUci3D30bZOc7cd1
         QmJKxUZOOFHhB/gJxrac4oo5bxJ48yUTc+sZMBn2VhQAj8l+TUa5ePeiGzenF1Q4tfhN
         IYnPFLrvDFCph2lQh1vOyN93hW6h0jSrguGh41z/KsrEASq/Bp683XorfHUprLQBV2vQ
         cRFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=QRYgxr5D5ScBd2KqG5liFxSiSuxfSIfRa9EBPtMyEuo=;
        b=A0WGW7TW/FUmV1j42g/JM5uQiqRT0ipVDnjumT/yNIM9nMt4YKu88VEh8E8qrF20br
         +NNESjbwVrtvoyaZcyyFek31El4YcWenwlaXIk1bMQ7oNAXqn1OYZZe/goQEFKAhUtXJ
         0gVM0D4Kc/CalX4G2+xqisSiFSDAX43EU593BKYBWErRoaKFJMW7mzM8BCkmgccgO7uB
         ymRRnGTYQk8xhW6wKDTQvOTg7Wq88NcyeVdnEVlUjL+D+KojtB322AAgRezaNriV9gBp
         YNmWggrgtWb/qbLlRKy/7sKdPxu/9E/P0gl5hgm/xS1SPQbWn8dZdKJ6lTwgcSNE4o0w
         Ujjg==
X-Gm-Message-State: APjAAAUhTB/QawsceNn7aRtNDeqmp3CI3j9zdRHLv7UOgR/pA90yudRu
        PbeW2b8f6NgD44JOvd6Eh5NHxg==
X-Google-Smtp-Source: APXvYqwb5O9vkdMWnZEwiZqmedtitQ/GpZdIYJEj+VYjePWlYroOYa2jDDoTAtdcBp0K2KYGsKoseQ==
X-Received: by 2002:a1c:2884:: with SMTP id o126mr3961669wmo.153.1570806991532;
        Fri, 11 Oct 2019 08:16:31 -0700 (PDT)
Received: from apalos.home (ppp-94-65-93-45.home.otenet.gr. [94.65.93.45])
        by smtp.gmail.com with ESMTPSA id a13sm20454268wrf.73.2019.10.11.08.16.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Oct 2019 08:16:31 -0700 (PDT)
Date:   Fri, 11 Oct 2019 18:16:28 +0300
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        lorenzo.bianconi@redhat.com
Subject: Re: [PATCH net] net: socionext: netsec: fix xdp stats accounting
Message-ID: <20191011151628.GA12122@apalos.home>
References: <40c5519a86f2c611de84661a9d1e136bda2cd78e.1570801159.git.lorenzo@kernel.org>
 <20191011141503.GA11359@apalos.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191011141503.GA11359@apalos.home>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 11, 2019 at 05:15:03PM +0300, Ilias Apalodimas wrote:
> Hi Lorenzo, 
> 
> On Fri, Oct 11, 2019 at 03:45:38PM +0200, Lorenzo Bianconi wrote:
> > Increment netdev rx counters even for XDP_DROP verdict. Moreover report
> > even tx bytes for xdp buffers (TYPE_NETSEC_XDP_TX or
> > TYPE_NETSEC_XDP_NDO)
> 
> The RX counters work fine. The TX change is causing a panic though and i am
> looking into it since your patch seems harmless. In any case please don't merge
> this yet
> 

Ok i think i know what's going on. 
Our clean TX routine has a netdev_completed_queue(). This is properly accounted
for on netsec_netdev_start_xmit() which calls netdev_sent_queue().

Since the XDP never had support for that you need to account for the extra bytes
in netsec_xdp_queue_one(). That's what triggering the BUG_ON 
(lib/dynamic_queue_limits.c line 27) 

Since netdev_completed_queue() enforces barrier() and in some cases smp_mb() i
think i'd prefer it per function, although it looks uglier. 
Can you send a patch with this call in netsec_xdp_queue_one()? If we cant
measure any performance difference i am fine with adding it in that only.

Thanks
/Ilias

> Thanks
> /Ilias
> 
> > Fixes: ba2b232108d3 ("net: netsec: add XDP support")
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > ---
> > just compiled not tested on a real device
> > ---
> >  drivers/net/ethernet/socionext/netsec.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/net/ethernet/socionext/netsec.c b/drivers/net/ethernet/socionext/netsec.c
> > index f9e6744d8fd6..b1c2a79899b3 100644
> > --- a/drivers/net/ethernet/socionext/netsec.c
> > +++ b/drivers/net/ethernet/socionext/netsec.c
> > @@ -252,7 +252,6 @@
> >  #define NETSEC_XDP_CONSUMED      BIT(0)
> >  #define NETSEC_XDP_TX            BIT(1)
> >  #define NETSEC_XDP_REDIR         BIT(2)
> > -#define NETSEC_XDP_RX_OK (NETSEC_XDP_PASS | NETSEC_XDP_TX | NETSEC_XDP_REDIR)
> >  
> >  enum ring_id {
> >  	NETSEC_RING_TX = 0,
> > @@ -661,6 +660,7 @@ static bool netsec_clean_tx_dring(struct netsec_priv *priv)
> >  			bytes += desc->skb->len;
> >  			dev_kfree_skb(desc->skb);
> >  		} else {
> > +			bytes += desc->xdpf->len;
> >  			xdp_return_frame(desc->xdpf);
> >  		}
> >  next:
> > @@ -1030,7 +1030,7 @@ static int netsec_process_rx(struct netsec_priv *priv, int budget)
> >  
> >  next:
> >  		if ((skb && napi_gro_receive(&priv->napi, skb) != GRO_DROP) ||
> > -		    xdp_result & NETSEC_XDP_RX_OK) {
> > +		    xdp_result) {
> >  			ndev->stats.rx_packets++;
> >  			ndev->stats.rx_bytes += xdp.data_end - xdp.data;
> >  		}
> > -- 
> > 2.21.0
> > 
