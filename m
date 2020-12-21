Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D0682DFA0A
	for <lists+netdev@lfdr.de>; Mon, 21 Dec 2020 09:41:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728448AbgLUIjf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Dec 2020 03:39:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728428AbgLUIje (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Dec 2020 03:39:34 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90FE3C061282;
        Mon, 21 Dec 2020 00:38:54 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id w5so5960669pgj.3;
        Mon, 21 Dec 2020 00:38:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=6ZLY8sD0xtzGQ6bTKBu3ddMABucrM5ugzsGXgPCG6xk=;
        b=k2OVdU3RqaSif2X2I6Vki1uhik9+/6coTO3uKPCGnJM9c6YgOTDXFlHt5YgP29i0pp
         a5xPJSpTxNUBeU9LuVHGzP/41GBVvH9uTVbxGo/y4xkpURCirhPMCAJWLqwbvLmk5NMv
         7K9AOZBP1F78rANe8PtfEF0lC7w3ZRLMY5JhrnTgSn5V1Mx+5QrPEHG4zk1QFlr+0dje
         uRY1KLq//nt3e2LfR2Mki7R/wZ184ALlQ4YKIgL2eKhiYoykroPqXmf4Z2fI3BOZjBZK
         nB6gjWCg82AOK7oZ1XoMeAhhmJC/7d1nO/dMuBwPaNJdP8akm5+loLzjn9xnPh7ScddR
         Mkmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6ZLY8sD0xtzGQ6bTKBu3ddMABucrM5ugzsGXgPCG6xk=;
        b=c9vryzAExQymhmua/DYLXz87og83vsMIA2AfdSEz62trvbBuOjIhIw9MhP6YGMj0lN
         0dy9xB6mXvUTarq75JYG7OEgycgW6O8XAMNPaLBud8L78KD8Jz/kWlXCwc9HSGQhkjM7
         i0bukQtx/ULk53jOf+y48uDSpAFEg8iFqULvfbXlFhmzB5sNjEEpMuPYhER6zr8203Lr
         KwNLA2UASnpWSC/Wsi/iPn27eg9LdgHbdVt2BDMYZd5xykjnRP9tklY0Yyt3JIzdp1P6
         NdU0G8Ir1hDfvRLM7tG+Q0JWtdIIuZyh/8v1GR73SHPQMG/BaKucosDbquhTPd9RHKPZ
         6RdQ==
X-Gm-Message-State: AOAM531tALJFJYBea/oEzBWfLM+S3+e5EmEcaClpyUBD/2qqOGwgEug6
        x35/Ek58599ytwz5NLUBy9g=
X-Google-Smtp-Source: ABdhPJwWFK2oLX98n2UD5k4I/+FzpaTxfCsHZYPlLgWOLdQMEEOB3M6NLgnAgmbsK38VK5vFTiZJ1g==
X-Received: by 2002:aa7:9813:0:b029:19d:c82a:92e7 with SMTP id e19-20020aa798130000b029019dc82a92e7mr14481702pfl.71.1608539933962;
        Mon, 21 Dec 2020 00:38:53 -0800 (PST)
Received: from localhost.localdomain ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 19sm15964424pfu.85.2020.12.21.00.38.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Dec 2020 00:38:53 -0800 (PST)
Date:   Mon, 21 Dec 2020 16:38:41 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Jiri Benc <jbenc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Hangbin Liu <haliu@redhat.com>
Subject: Re: [PATCHv12 bpf-next 1/6] bpf: run devmap xdp_prog on flush
 instead of bulk enqueue
Message-ID: <20201221083841.GA95616@localhost.localdomain>
References: <20200907082724.1721685-1-liuhangbin@gmail.com>
 <20201216143036.2296568-1-liuhangbin@gmail.com>
 <20201216143036.2296568-2-liuhangbin@gmail.com>
 <913a8e62-3f17-84ed-e4f5-099ba441508c@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <913a8e62-3f17-84ed-e4f5-099ba441508c@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

I just aware that,
On Thu, Dec 17, 2020 at 09:07:03AM -0700, David Ahern wrote:
> > +static int dev_map_bpf_prog_run(struct bpf_prog *xdp_prog,
> > +				struct xdp_frame **frames, int n,
> > +				struct net_device *dev)
> > +{
> > +	struct xdp_txq_info txq = { .dev = dev };
> > +	struct xdp_buff xdp;
> > +	int i, nframes = 0;
> > +
> > +	for (i = 0; i < n; i++) {
> > +		struct xdp_frame *xdpf = frames[i];
> > +		u32 act;
> > +		int err;
> > +
> > +		xdp_convert_frame_to_buff(xdpf, &xdp);
> > +		xdp.txq = &txq;
> > +
> > +		act = bpf_prog_run_xdp(xdp_prog, &xdp);
> > +		switch (act) {
> > +		case XDP_PASS:
> > +			err = xdp_update_frame_from_buff(&xdp, xdpf);
> > +			if (unlikely(err < 0))
> > +				xdp_return_frame_rx_napi(xdpf);
> > +			else
> > +				frames[nframes++] = xdpf;
> > +			break;
> > +		default:
> > +			bpf_warn_invalid_xdp_action(act);
> > +			fallthrough;
> > +		case XDP_ABORTED:
> > +			trace_xdp_exception(dev, xdp_prog, act);
> > +			fallthrough;
> > +		case XDP_DROP:
> > +			xdp_return_frame_rx_napi(xdpf);
> > +			break;
> > +		}
> > +	}
> > +	return n - nframes; /* dropped frames count */
> 
> just return nframes here, since ...

If we return nframes here,
> 
> > +}
> > +
> >  static void bq_xmit_all(struct xdp_dev_bulk_queue *bq, u32 flags)
> >  {
> >  	struct net_device *dev = bq->dev;
> >  	int sent = 0, drops = 0, err = 0;
> > +	unsigned int cnt = bq->count;
> > +	unsigned int xdp_drop;
> >  	int i;
> >  
> > -	if (unlikely(!bq->count))
> > +	if (unlikely(!cnt))
> >  		return;
> >  
> > -	for (i = 0; i < bq->count; i++) {
> > +	for (i = 0; i < cnt; i++) {
> >  		struct xdp_frame *xdpf = bq->q[i];
> >  
> >  		prefetch(xdpf);
> >  	}
> >  
> > -	sent = dev->netdev_ops->ndo_xdp_xmit(dev, bq->count, bq->q, flags);
> > +	if (unlikely(bq->xdp_prog)) {
> > +		xdp_drop = dev_map_bpf_prog_run(bq->xdp_prog, bq->q, cnt, dev);
> > +		cnt -= xdp_drop;
> 
> ... that is apparently what you really want.

then this will be 

		cnt = dev_map_bpf_prog_run(bq->xdp_prog, bq->q, cnt, dev);
		xdp_drop = bq->count - cnt;

So there is no much difference whether we return passed frames or dropped
frames.
> 
> > +		if (!cnt) {
> > +			sent = 0;
> > +			drops = xdp_drop;
> > +			goto out;
> > +		}
> > +	}

Thanks
Hangbin
