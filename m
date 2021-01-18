Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 219042FAC9D
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 22:27:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394656AbhARV1C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 16:27:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388244AbhARKIN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 05:08:13 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DAFCC061574;
        Mon, 18 Jan 2021 02:07:33 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id m5so9465107pjv.5;
        Mon, 18 Jan 2021 02:07:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=i8sevPA5T+bkynzdrMi5AZb1+pFwrIVmh94L7+b0P98=;
        b=cqqLPNAmJloZXONxln+vqI4lPrE05hEAC6zRNxtHo12gfLH7b+0Y7bJgrc8KWCpH4e
         EPDCA7lyYLydgidM5gnBirg8jFtRhCaVXHU2ReMbWeMEMdzqgIjkwhvcCjYAJCNhezQk
         zBCJn+VQCyPKHmyft1jP5YQudhCS9zhKOfe+mKDU40DjmVymIhDn3R6hwa6Bvy5Ji5WT
         OmWZB5lwl1T9BmhOF+i3tfCbLNzkPb868IkN7tZu36IflIQcUxYR71KNBRnMYK7TI8X0
         OX/zIZDEXWI6u4/1tldxt6P8x4inU8UZ/MoSvGdw+hnlBkydlmMP2VZNIIU4YIeQdJiA
         lIDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=i8sevPA5T+bkynzdrMi5AZb1+pFwrIVmh94L7+b0P98=;
        b=Xb6Q95FHxq6TS30HI2vxcTh2kJ5G0PHFA3SuBVeYUOVFuIRIkk/oRw4M8eVjZZZdJe
         78Zew4lbRmaPObwSEOzrEgPZnkPl6uKBAeEcS/Ca8Ap8sec+a9VV8SHJIaJFVvs3nhvz
         hactg1VDj9/C1gkUi62lrFZ0pfCCAZN3OiUcE99tHIHtEBvyzUg3Zq9Ckt92IR86jI2j
         OyvsCiNCSiMOZYAFDQqz0LSHFIoa15nCUoO69+OkKmAJ5lkIb4I9s49YQCBue6V9rb3S
         QlGofcs41QzcFyxHi4Ni6Dx4aFQik+MzYqQ84IJXGn7tmtZ8dst3X8+HIpXs1t3vopj/
         sA3w==
X-Gm-Message-State: AOAM532hAnaicZQQI+XWF9TvZcl7QfF4kbw+b7UySkuw8K/rwYDOKLES
        teT31W14OEWZJL/bGdBCzQQ=
X-Google-Smtp-Source: ABdhPJyqKI/dFXP0dZFNCDx26L2fYI3AI/zRjkDMfDk8fON05u9ynz7O3algVW14JR2x4Ma5SjTntQ==
X-Received: by 2002:a17:90a:dc01:: with SMTP id i1mr21188780pjv.134.1610964453012;
        Mon, 18 Jan 2021 02:07:33 -0800 (PST)
Received: from Leo-laptop-t470s ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id q12sm15487604pgj.24.2021.01.18.02.07.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jan 2021 02:07:31 -0800 (PST)
Date:   Mon, 18 Jan 2021 18:07:17 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Jiri Benc <jbenc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Subject: Re: [PATCHv14 bpf-next 1/6] bpf: run devmap xdp_prog on flush
 instead of bulk enqueue
Message-ID: <20210118100717.GF1421720@Leo-laptop-t470s>
References: <20201221123505.1962185-1-liuhangbin@gmail.com>
 <20210114142321.2594697-1-liuhangbin@gmail.com>
 <20210114142321.2594697-2-liuhangbin@gmail.com>
 <6004c0be660fd_2664208e8@john-XPS-13-9370.notmuch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6004c0be660fd_2664208e8@john-XPS-13-9370.notmuch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 17, 2021 at 02:57:02PM -0800, John Fastabend wrote:
[...]
> It looks like we could embed xdp_buff in xdp_frame and then keep the metadata
> at the end.
> 
> Because you are working performance here wdyt? <- @Jesper as well.

Leave this question to Jesper.

> >  
> > -	sent = dev->netdev_ops->ndo_xdp_xmit(dev, bq->count, bq->q, flags);
> > +	if (unlikely(bq->xdp_prog)) {
> 
> Whats the rational for making above unlikely()? Seems for users its not
> unlikely. Can you measure a performance increase/decrease here? I think
> its probably fine to just let compiler/prefetcher do its thing here. Or
> I'm not reading this right, but seems users of bq->xdp_prog would disagree
> on unlikely case?
> 
> Either way a comment might be nice to give us some insight in 6 months
> why we decided this is unlikely.

I agree that there is no need to use unlikely() here.
> 
> > +		xdp_drop = dev_map_bpf_prog_run(bq->xdp_prog, bq->q, cnt, dev);
> > +		cnt -= xdp_drop;
> > +		if (!cnt) {
> 
> 
> if dev_map_bpf_prog_run() returned sent packets this would read better
> imo.
> 
>   sent = dev_map_bpf_prog_run(...)
>   if (!sent)
>         goto out;
> 
> > +			sent = 0;
> > +			drops = xdp_drop;
> > +			goto out;
> > +		}
> > +	}
> > +
> > +	sent = dev->netdev_ops->ndo_xdp_xmit(dev, cnt, bq->q, flags);
> 
> And,    sent = dev->netdev_ops->ndo_xdp_xmit(dev, sent, bq->q, flags);
> 
> >  	if (sent < 0) {
> >  		err = sent;
> >  		sent = 0;
> >  		goto error;
> >  	}
> > -	drops = bq->count - sent;
> > +	drops = (cnt - sent) + xdp_drop;
> 
> With about 'sent' logic then drops will still be just, drops = bq->count - sent
> and move the calculation below the out label and I think you clean up above

If we use the 'sent' logic, we should also backup the drop value before
xmit as the erro label also need it.

> as well. Did I miss something...
> 
> >  out:
> >  	bq->count = 0;
> >  
> >  	trace_xdp_devmap_xmit(bq->dev_rx, dev, sent, drops, err);
> >  	bq->dev_rx = NULL;
> > +	bq->xdp_prog = NULL;
> >  	__list_del_clearprev(&bq->flush_node);
> >  	return;
> >  error:
> >  	/* If ndo_xdp_xmit fails with an errno, no frames have been
> >  	 * xmit'ed and it's our responsibility to them free all.
> >  	 */
> > -	for (i = 0; i < bq->count; i++) {
> > +	for (i = 0; i < cnt; i++) {
> >  		struct xdp_frame *xdpf = bq->q[i];

here it will be "for (i = 0; i < cnt - drops; i++)" to free none xmit'ed
frames.

To make the logic more clear, here is the full code:

	[...]
        if (bq->xdp_prog) {
                sent = dev_map_bpf_prog_run(bq->xdp_prog, bq->q, cnt, dev);
                if (!sent)
                        goto out;
        }

	/* Backup drops value before xmit as we may need it in error label */
        drops = cnt - sent;
        sent = dev->netdev_ops->ndo_xdp_xmit(dev, sent, bq->q, flags);
        if (sent < 0) {
                err = sent;
                sent = 0;
                goto error;
        }
out:
        drops = cnt - sent;
        bq->count = 0;

        trace_xdp_devmap_xmit(bq->dev_rx, dev, sent, drops, err);
        bq->dev_rx = NULL;
        bq->xdp_prog = NULL;
        __list_del_clearprev(&bq->flush_node);
        return;
error:
        /* If ndo_xdp_xmit fails with an errno, no frames have been
         * xmit'ed and it's our responsibility to them free all.
         */
        for (i = 0; i < cnt - drops; i++) {
                struct xdp_frame *xdpf = bq->q[i];
                xdp_return_frame_rx_napi(xdpf);
        }
        goto out;
}

Thanks
hangbin
