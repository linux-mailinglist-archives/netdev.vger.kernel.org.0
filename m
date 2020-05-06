Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 070CE1C6D07
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 11:36:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729069AbgEFJgK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 05:36:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728640AbgEFJgJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 05:36:09 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A917C061A0F;
        Wed,  6 May 2020 02:36:09 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id u22so247457plq.12;
        Wed, 06 May 2020 02:36:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=zlwaiD9rdqtMZ0gowM2D4HHwcxFJJau4BQ+MFaX1rEs=;
        b=tJoRW2FSPwChvqZesq7K8rHaPNSJmtvNC6xq0/swGRxU6xmlJ1AoFiK7eAykac3275
         7uRo4mJdQyT2F5HsLQ4GPkVgahb3xFzl/NGyAf+caXQxPWUA9bgOFOP4/kvP7QPJB84b
         839bQG2Mlpez1AuVEJcP0fOH0BJhrnx9+z+xA4f9EDtlvAmNoQvk0tDHxvTLi2GBolaB
         4JeTX5FnGU4v9rNn7FwF4deN1YsYEbDhr6eacDyVz+8V2U+0ljJsN6Qr+o5t01TAF+Qy
         kmUfevgouaUIOcEX3PolgUq5ZACKT/poMuMIXepkqdSUrzV+wd03gTqMkWZouNrUB8oK
         UgYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zlwaiD9rdqtMZ0gowM2D4HHwcxFJJau4BQ+MFaX1rEs=;
        b=Ui8chbnWPSUnoMoNFpt7emhe6/GgoYz2XbgPOG84IJoIVzQ7ZELAq2dk5rlbKrE4Fb
         ypSqntFi3PC2ua/DEXmqkH9ZAWbcsEcUmPLA4xb3s4HPk2EgdB0DoaAeIQBJ1i2me4uh
         Sn4iDKuHwWJphEhRbpWfFp2zmYmBOCu0P4uBoyZpJZT/GdzQRU1QwMEkryY4+tjQVTrf
         k+xeAlIZaoP6DtKkDhhEOhr3m2tRdZVnQT0k5y7Bs7dl/ocYWSXsM3vjAzQdJZbNh+oZ
         X78sWvHRvmwOHjsIZDOmYJNdPqtVRYl+/fZsOMgTiEtFVyLp6wRJqqj0Xzu9cUaHjCNT
         Y6pw==
X-Gm-Message-State: AGi0PuZvqihh8/OvvkJNWQ2NmqZmGZfWOBH03UWpQQWXuR9NXxu7uIgp
        4Wm82bqEy7b1+WC3X+khhDpFhjFhI98=
X-Google-Smtp-Source: APiQypIPFShqFMBJY2db6QLP9P+yQw+TFBzt7YFEZhBvpip348uaMC3SwJAAMDxBRZwtxqqKYWycjQ==
X-Received: by 2002:a17:90a:fa0e:: with SMTP id cm14mr7918564pjb.92.1588757768923;
        Wed, 06 May 2020 02:36:08 -0700 (PDT)
Received: from dhcp-12-153.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id gv7sm4233807pjb.16.2020.05.06.02.36.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 May 2020 02:36:08 -0700 (PDT)
Date:   Wed, 6 May 2020 17:35:57 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Jiri Benc <jbenc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: [RFC PATCHv2 bpf-next 1/2] xdp: add a new helper for dev map
 multicast support
Message-ID: <20200506093557.GB102436@dhcp-12-153.nay.redhat.com>
References: <20200415085437.23028-1-liuhangbin@gmail.com>
 <20200424085610.10047-1-liuhangbin@gmail.com>
 <20200424085610.10047-2-liuhangbin@gmail.com>
 <20200424141908.GA6295@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200424141908.GA6295@localhost.localdomain>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hi Lorenzo,

Thanks for the comments, please see replies below.

On Fri, Apr 24, 2020 at 04:19:08PM +0200, Lorenzo Bianconi wrote:
> > +bool dev_in_exclude_map(struct bpf_dtab_netdev *obj, struct bpf_map *map,
> > +			int exclude_ifindex)
> > +{
> > +	struct bpf_dtab_netdev *in_obj = NULL;
> > +	u32 key, next_key;
> > +	int err;
> > +
> > +	if (!map)
> > +		return false;
> 
> doing so it seems mandatory to define an exclude_map even if we want just to do
> not forward the packet to the "ingress" interface.
> Moreover I was thinking that we can assume to never forward to in the incoming
> interface. Doing so the code would be simpler I guess. Is there a use case for
> it? (forward even to the ingress interface)

Eelco has help answered one use case: VEPA. Another reason I added this flag
is that the other syscalls like bpf_redirect() or bpf_redirect_map() are
also able to forward to ingress interface. So we need to behave the same
by default.
> 
> > +int dev_map_enqueue_multi(struct xdp_buff *xdp, struct net_device *dev_rx,
> > +			  struct bpf_map *map, struct bpf_map *ex_map,
> > +			  bool exclude_ingress)
> > +{

[...]
> > +	}
> 
> Do we need to free 'incoming' xdp buffer here? I think most of the drivers assume
> the packet is owned by the stack if xdp_do_redirect returns 0

Yes, we need. I will fix it.
> > diff --git a/net/core/filter.c b/net/core/filter.c
> > index 7d6ceaa54d21..94d1530e5ac6 100644
> > --- a/net/core/filter.c
> > +++ b/net/core/filter.c
> > @@ -3473,12 +3473,17 @@ static const struct bpf_func_proto bpf_xdp_adjust_meta_proto = {
> >  };
> >  
> >  static int __bpf_tx_xdp_map(struct net_device *dev_rx, void *fwd,
> > -			    struct bpf_map *map, struct xdp_buff *xdp)
> > +			    struct bpf_map *map, struct xdp_buff *xdp,
> > +			    struct bpf_map *ex_map, bool exclude_ingress)
> >  {
> >  	switch (map->map_type) {
> >  	case BPF_MAP_TYPE_DEVMAP:
> >  	case BPF_MAP_TYPE_DEVMAP_HASH:
> > -		return dev_map_enqueue(fwd, xdp, dev_rx);
> > +		if (fwd)
> > +			return dev_map_enqueue(fwd, xdp, dev_rx);
> > +		else
> > +			return dev_map_enqueue_multi(xdp, dev_rx, map, ex_map,
> > +						     exclude_ingress);
> 
> I guess it would be better to do not make it the default case. Maybe you can
> add a bit in flags to mark it for "multicast"

But how do we distinguish the flag bit with other syscalls? e.g. If we define
0x02 as the "do_multicast" flag. What if other syscalls also used this flag.

Currently __bpf_tx_xdp_map() is only called by xdp_do_redirect(). If there
is a map and no fwd, it must be multicast forward. So we are still safe now.
Maybe we need an update in future.

Thanks
Hangbin
