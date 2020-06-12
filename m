Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B75B1F7581
	for <lists+netdev@lfdr.de>; Fri, 12 Jun 2020 10:54:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726367AbgFLIyW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jun 2020 04:54:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726327AbgFLIyU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jun 2020 04:54:20 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E65DC03E96F;
        Fri, 12 Jun 2020 01:54:20 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id a127so3981443pfa.12;
        Fri, 12 Jun 2020 01:54:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1h0U0on2B5eieW//0BjOn1nuqwFmMt2z2UwHZRgs9sY=;
        b=dzHSWgvHQidPUJPOLQ9tG26Ze1dNyZbBQPA7QTKYwDt5MfkokFNBdOLjWRC8beqoEr
         g0vwJwBpvWAjWexk4EVyC6tvXOgR2fdCgXybAMhmcNwBRMc30y6cYoOd0XWW1HKHu5Re
         jjj2nfe6r5JbHJXB7JxSUS0h/X1sT8zqXzhU/yh+mBTkgII8cMnN0J3CQF6FOakPZC/L
         IEZD2OpqvmcnAIN1Bui/IYPv+DwbO0u6Q1GJQhZ8AELtaS9+kQKLd+TOtaE/z/eMIJO2
         h/J/jpRzB05iQDU1qm5nhs3sxaDu7TKStKloYYofWRtkVhTkjlvf0Bj2h/JyQyF/TS66
         8iKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1h0U0on2B5eieW//0BjOn1nuqwFmMt2z2UwHZRgs9sY=;
        b=GBn825p8z/5FilAlrpZunSiJPc5wK51tLHG8i5NrwnzToEagwfyGcubtQz7w4GcHxB
         RlcvxGfj6ywjyYsT0V5P/R56LoSYlKWZVe0xZTCExUJx/paxR85UW/+s2vYPWw0ivvo0
         Ibj0TwncUrnsJnWSlo+htvYiWcq9j2P1ch8CEyvnVScPZR8lXYy/aKi5KHWhpuYyE8wB
         twSOreOLjN0C9CoP2rZVeKqRE66j4twzVN6RH1PPR904QQ9Hd2aAjVkMlbte2Ta0BRdH
         S/tiI3rOa/wB+7qo5ytk+skbFk/ETo03Fwg7ChwMOrBmXSB933YkKpBLBgaKwAvgvqq9
         2XRw==
X-Gm-Message-State: AOAM5313U2yCplrdO71nmnqxZKi0z4lx1aBZxi0EeOPZkRfHSIwkd1p2
        1PaDOkxCPmrliY11d7VuP0M=
X-Google-Smtp-Source: ABdhPJxfJkbaQXLHCaxdazaUT87ROcCfAiTKRl3Z3yo9Kf6Gpfn+YSk5DOH5/B9M0ANHrnr6QSK99g==
X-Received: by 2002:aa7:979b:: with SMTP id o27mr1975531pfp.284.1591952059854;
        Fri, 12 Jun 2020 01:54:19 -0700 (PDT)
Received: from dhcp-12-153.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 130sm5208060pfw.176.2020.06.12.01.54.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Jun 2020 01:54:19 -0700 (PDT)
Date:   Fri, 12 Jun 2020 16:54:08 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Jiri Benc <jbenc@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Subject: Re: [PATCHv4 bpf-next 1/2] xdp: add a new helper for dev map
 multicast support
Message-ID: <20200612085408.GT102436@dhcp-12-153.nay.redhat.com>
References: <20200415085437.23028-1-liuhangbin@gmail.com>
 <20200526140539.4103528-1-liuhangbin@gmail.com>
 <20200526140539.4103528-2-liuhangbin@gmail.com>
 <20200610121859.0412c111@carbon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200610121859.0412c111@carbon>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 10, 2020 at 12:18:59PM +0200, Jesper Dangaard Brouer wrote:
> On Tue, 26 May 2020 22:05:38 +0800
> Hangbin Liu <liuhangbin@gmail.com> wrote:
> 
> > diff --git a/net/core/xdp.c b/net/core/xdp.c
> > index 90f44f382115..acdc63833b1f 100644
> > --- a/net/core/xdp.c
> > +++ b/net/core/xdp.c
> > @@ -475,3 +475,29 @@ void xdp_warn(const char *msg, const char *func, const int line)
> >  	WARN(1, "XDP_WARN: %s(line:%d): %s\n", func, line, msg);
> >  };
> >  EXPORT_SYMBOL_GPL(xdp_warn);
> > +
> > +struct xdp_frame *xdpf_clone(struct xdp_frame *xdpf)
> > +{
> > +	unsigned int headroom, totalsize;
> > +	struct xdp_frame *nxdpf;
> > +	struct page *page;
> > +	void *addr;
> > +
> > +	headroom = xdpf->headroom + sizeof(*xdpf);
> > +	totalsize = headroom + xdpf->len;
> > +
> > +	if (unlikely(totalsize > PAGE_SIZE))
> > +		return NULL;
> > +	page = dev_alloc_page();
> > +	if (!page)
> > +		return NULL;
> > +	addr = page_to_virt(page);
> > +
> > +	memcpy(addr, xdpf, totalsize);
> 
> I don't think this will work.  You are assuming that the memory model
> (xdp_mem_info) is the same.
> 
> You happened to use i40, that have MEM_TYPE_PAGE_SHARED, and you should
> have changed this to MEM_TYPE_PAGE_ORDER0, but it doesn't crash as they
> are compatible.  If you were using mlx5, I suspect that this would
> result in memory leaking.

Is there anything else I should do except add the following line?
	nxdpf->mem.type = MEM_TYPE_PAGE_ORDER0;
> 
> You also need to update xdpf->frame_sz, as you also cannot assume it is
> the same.

Won't the memcpy() copy xdpf->frame_sz to nxdpf? 

And I didn't see xdpf->frame_sz is set in xdp_convert_zc_to_xdp_frame(),
do we need a fix?

Thanks
Hangbin
> 
> > +
> > +	nxdpf = addr;
> > +	nxdpf->data = addr + headroom;
> > +
> > +	return nxdpf;
> > +}
> > +EXPORT_SYMBOL_GPL(xdpf_clone);
> 
> 
> -- 
> Best regards,
>   Jesper Dangaard Brouer
>   MSc.CS, Principal Kernel Engineer at Red Hat
>   LinkedIn: http://www.linkedin.com/in/brouer
> 
> 
> struct xdp_frame {
> 	void *data;
> 	u16 len;
> 	u16 headroom;
> 	u32 metasize:8;
> 	u32 frame_sz:24;
> 	/* Lifetime of xdp_rxq_info is limited to NAPI/enqueue time,
> 	 * while mem info is valid on remote CPU.
> 	 */
> 	struct xdp_mem_info mem;
> 	struct net_device *dev_rx; /* used by cpumap */
> };
> 
