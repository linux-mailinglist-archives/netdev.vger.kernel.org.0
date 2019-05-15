Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 000B01F99F
	for <lists+netdev@lfdr.de>; Wed, 15 May 2019 19:53:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726678AbfEORxi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 May 2019 13:53:38 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:36808 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726562AbfEORxi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 May 2019 13:53:38 -0400
Received: by mail-pf1-f196.google.com with SMTP id v80so354263pfa.3
        for <netdev@vger.kernel.org>; Wed, 15 May 2019 10:53:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/52eAZug8Bv7sPzRYpYieVuixQDyekiGKN7wcO9mEVA=;
        b=wPnynm7Rop6JVbzL3lhSqbxtNVDoYT454RwPpgAFPhkhL07VN8V20AT2MKvWiDNat/
         UBnhyofRlWMmFzLzOvMoKPejjaqUO2t/5EZorXhfggBsJMgIyFP8sObdBzWlFdFSvIoI
         4e8qgOBNmrjAjHm+cUfOjUbOj+34QHeK1Bfz9xlaheF5j2XgC8rxMoBgep5lbVvwA3Dp
         HMrPle/veH8XVLnL2V7rJlLqxanijDiy27kt3N1ztV6SZjqJsME1dnEKg8pQhLSv8jpw
         ZEsmftoi0ko5/QJ0as+QlahWzxkxg+JK62cZwsjnBwpo9cgYWE8SNnGieS4KH7FGuonZ
         nAbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/52eAZug8Bv7sPzRYpYieVuixQDyekiGKN7wcO9mEVA=;
        b=r9CgnbCC+8NqK5g5ySjncVpVeFeTahNu9EzvAqIwLIF82KKgy1YPrpnjo4Lj8wgMo7
         c1LbWQYC/4evlbxB9sT3ygfC9zpGF0QMGOV+bQ2wQoHfyc8q9FmqxaWnzKSNLNKdRgIl
         P5AmFDqcrPdAOhxo0IeruIWC+QZdp7cQDA3sFy8ihP7mAjm7UOGMuEW9FdfA825oXXss
         y/Di+nT4Wit0nQ7Bt/3W6J21NiuNW8ER1hl17pLZq6ujvdzZ91/BoC29VRadLn3Hrp/B
         JGu1zCGU+zsnPYxwSvGDLHpL5l5u5GGsn8Ds8MOwx1lZWcoRcrlkNNYA7F/hqriUgaCZ
         F8ww==
X-Gm-Message-State: APjAAAXDByTOuy9FFKJ1G7I5icDu7oSwSJTeerjBSWvvL9iXMTszVlhd
        bXyzRDkMWjIsLttayrnY+jaVJwRjc3Q=
X-Google-Smtp-Source: APXvYqxPR7S7euMkRK/xv3sjzQBEZNObSn89aXgsg/VZGDtceZi2It2zUVtPLeGARrCeNwipE6mMfQ==
X-Received: by 2002:a63:2b03:: with SMTP id r3mr44058060pgr.105.1557942817302;
        Wed, 15 May 2019 10:53:37 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id h13sm3126345pgk.55.2019.05.15.10.53.36
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 15 May 2019 10:53:37 -0700 (PDT)
Date:   Wed, 15 May 2019 10:53:30 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Haiyang Zhang <haiyangz@microsoft.com>
Cc:     KY Srinivasan <kys@microsoft.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Stephen Hemminger <sthemmin@microsoft.com>
Subject: Re: [RFC 1/2] netvsc: invoke xdp_generic from VF frame handler
Message-ID: <20190515105330.4b955e7d@hermes.lan>
In-Reply-To: <BYAPR21MB133640B374769CDF84685C03CA090@BYAPR21MB1336.namprd21.prod.outlook.com>
References: <20190515080319.15514-1-sthemmin@microsoft.com>
        <20190515080319.15514-2-sthemmin@microsoft.com>
        <BYAPR21MB133640B374769CDF84685C03CA090@BYAPR21MB1336.namprd21.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 15 May 2019 17:50:25 +0000
Haiyang Zhang <haiyangz@microsoft.com> wrote:

> > -----Original Message-----
> > From: Stephen Hemminger <stephen@networkplumber.org>
> > Sent: Wednesday, May 15, 2019 4:03 AM
> > To: KY Srinivasan <kys@microsoft.com>; Haiyang Zhang
> > <haiyangz@microsoft.com>; davem@davemloft.net
> > Cc: netdev@vger.kernel.org; Stephen Hemminger <sthemmin@microsoft.com>
> > Subject: [RFC 1/2] netvsc: invoke xdp_generic from VF frame handler
> > 
> > XDP generic does not work correctly with the Hyper-V/Azure netvsc device
> > because of packet processing order. Only packets on the synthetic path get
> > seen by the XDP program. The VF device packets are not seen.
> > 
> > By the time the packets that arrive on the VF are handled by netvsc after the
> > first pass of XDP generic (on the VF) has already been done.
> > 
> > A fix for the netvsc device is to do this in the VF packet handler.
> > by directly calling do_xdp_generic() if XDP program is present on the parent
> > device.
> > 
> > A riskier but maybe better alternative would be to do this netdev core code
> > after the receive handler is invoked (if RX_HANDLER_ANOTHER is returned).
> > 
> > Fixes: 0c195567a8f6 ("netvsc: transparent VF management")
> > Signed-off-by: Stephen Hemminger <sthemmin@microsoft.com>
> > ---
> >  drivers/net/hyperv/netvsc_drv.c | 6 ++++++
> >  1 file changed, 6 insertions(+)
> > 
> > diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
> > index 06393b215102..bb0fc1869bde 100644
> > --- a/drivers/net/hyperv/netvsc_drv.c
> > +++ b/drivers/net/hyperv/netvsc_drv.c
> > @@ -1999,9 +1999,15 @@ static rx_handler_result_t
> > netvsc_vf_handle_frame(struct sk_buff **pskb)
> >  	struct net_device_context *ndev_ctx = netdev_priv(ndev);
> >  	struct netvsc_vf_pcpu_stats *pcpu_stats
> >  		 = this_cpu_ptr(ndev_ctx->vf_stats);
> > +	struct bpf_prog *xdp_prog;
> > 
> >  	skb->dev = ndev;
> > 
> > +	xdp_prog = rcu_dereference(ndev->xdp_prog);
> > +	if (xdp_prog &&
> > +	    do_xdp_generic(xdp_prog, skb) != XDP_PASS)
> > +		return RX_HANDLER_CONSUMED;  
> 
> Looks fine overall.
> 
> The function do_xdp_generic() already checks NULL on xdp_prog,
> so we don't need to check it in our code. 
> 
> int do_xdp_generic(struct bpf_prog *xdp_prog, struct sk_buff *skb)
> {
>         if (xdp_prog) {
> 

The null check in the netvsc code was just an minor optimization
to avoid unnecessary function call in fast path.
