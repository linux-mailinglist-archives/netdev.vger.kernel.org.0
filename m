Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E8BB2C56ED
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 15:19:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390826AbgKZOTR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Nov 2020 09:19:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390772AbgKZOTQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Nov 2020 09:19:16 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54435C0613D4;
        Thu, 26 Nov 2020 06:19:16 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id n137so1775008pfd.3;
        Thu, 26 Nov 2020 06:19:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=n5lWvINJ7iHP6wHSBGrj4q3zKA3iyMiEBZRNbNungNQ=;
        b=VJLJtHWJG3TroDkrEtoMTsCUpLsqNFvFPQVk7m2WSWNEMDzx3fjU2ccfic492frTtO
         7wT8mOt8CxhUXK9opyHFgxhqrKE32NDh1UL7yuTbX7INXUpIZrqce2xFVw2KORyRJJgL
         xgYkgnyyeE5CNd6DC/NkPWxd4yXIBeSvuf39YQ0A6i0ZAQsKt7lY6G7yPSw7S2No+G6s
         hsfmJtJ2d29VAUQx6ctOuGnUEe7DEGzeuQkSGxZSaJTfEwA79u+vU8UZxUNOOZYSHlGj
         ttuMSAjBQTP6+uTDCxVdiE8j8b31HiO+ihJyNTeqtFgA2ZKA8boV0tOh5+vx29zL0sSu
         4rEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=n5lWvINJ7iHP6wHSBGrj4q3zKA3iyMiEBZRNbNungNQ=;
        b=rjaWSF8+Iu4N5uyFA1U0n6MBGEjLinMWl7z8qkayGWeMMyVz3UWakxDZHOMlTLbdYW
         pBfhxokYOraaP+pGxf6hmSUWdrwrLi615j+XeYRUhGCh2hnA/RRS5tSk8N5yFtgKzGxy
         zDPdqhqDcMZO2wnz/d9KB2dQpVYh4yuQ9huS97uuBqx8JmdY3mNoU8PTqhF9/w77uKjC
         ngac/R0qAMgf3HzhlbhU3C2I5b0ndUHxDKZJf1I9FzlyKPgcvBYMOCvTqZ9iPp5hVHka
         MM2+9nd5M110C8y86lBdOqc4cTNxSnODJeTfptaKgtfqDjVPVRF2psyzNtkdUlC1Ru3f
         JR1w==
X-Gm-Message-State: AOAM532CSVGHY0mQKyFH078bmHIh9b3Bzl7YeHqINOh0Rpo4+iNn4nPc
        JiYrOvWqM1kY0hobWBEywPw=
X-Google-Smtp-Source: ABdhPJxIVDtfIQOdCsi27gYbyYXybepN3PycojakaBqeIM3hYehfapBq/3dEjaeN6LQx9F4Tj+w/hw==
X-Received: by 2002:a17:90a:cc06:: with SMTP id b6mr2484328pju.94.1606400355786;
        Thu, 26 Nov 2020 06:19:15 -0800 (PST)
Received: from localhost.localdomain ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id w2sm6304353pjq.57.2020.11.26.06.19.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Nov 2020 06:19:14 -0800 (PST)
Date:   Thu, 26 Nov 2020 22:19:04 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: Re: [PATCHv2 bpf-next] samples/bpf: add xdp program on egress for
 xdp_redirect_map
Message-ID: <20201126141904.GA277949@localhost.localdomain>
References: <20201110124639.1941654-1-liuhangbin@gmail.com>
 <20201126084325.477470-1-liuhangbin@gmail.com>
 <20201126115119.20f82cba@carbon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201126115119.20f82cba@carbon>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 26, 2020 at 11:51:19AM +0100, Jesper Dangaard Brouer wrote:
> On Thu, 26 Nov 2020 16:43:25 +0800
> Hangbin Liu <liuhangbin@gmail.com> wrote:
> 
> > Current sample test xdp_redirect_map only count pkts on ingress. But we
> > can't know whether the pkts are redirected or dropped. So add a counter
> > on egress interface so we could know how many pkts are redirect in fact.
> 
> This is not true.
> 
> The 2nd devmap XDP-prog will run in the same RX-context, so it doesn't
> tell us if the redirect was successful.  I looked up the code, and the
> 2nd XDP-prog is even allowed to run when the egress driver doesn't
> support the NDO to xmit (dev->netdev_ops->ndo_xdp_xmit), which is very
> misleading, if you place a output counter here.
> 
> -- 
> Best regards,
>   Jesper Dangaard Brouer
>   MSc.CS, Principal Kernel Engineer at Red Hat
>   LinkedIn: http://www.linkedin.com/in/brouer
> 
> 
> static inline int __xdp_enqueue(struct net_device *dev, struct xdp_buff *xdp,
> 			       struct net_device *dev_rx)
> {
> 	struct xdp_frame *xdpf;
> 	int err;
> 
> 	if (!dev->netdev_ops->ndo_xdp_xmit)
> 		return -EOPNOTSUPP;
> 

Err... You are right. I didn't read this part carefully.

Based on Toke's suggestion, maybe edit the src mac address to the egress
iface's mac address is a better example. WDYT?

And does it make any sense to run perf test for 2nd xdp program
for xdp_redirect_map?

Thanks
Hangbin


> 	err = xdp_ok_fwd_dev(dev, xdp->data_end - xdp->data);
> 	if (unlikely(err))
> 		return err;
> 
> 	xdpf = xdp_convert_buff_to_frame(xdp);
> 	if (unlikely(!xdpf))
> 		return -EOVERFLOW;
> 
> 	bq_enqueue(dev, xdpf, dev_rx);
> 	return 0;
> }
> 
> 
> int dev_map_enqueue(struct bpf_dtab_netdev *dst, struct xdp_buff *xdp,
> 		    struct net_device *dev_rx)
> {
> 	struct net_device *dev = dst->dev;
> 
> 	if (dst->xdp_prog) {
> 		xdp = dev_map_run_prog(dev, xdp, dst->xdp_prog);
> 		if (!xdp)
> 			return 0;
> 	}
> 	return __xdp_enqueue(dev, xdp, dev_rx);
> }
> 
