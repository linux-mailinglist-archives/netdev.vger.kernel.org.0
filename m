Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3140E1FAD9B
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 12:11:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726526AbgFPKLp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 06:11:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726052AbgFPKLo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jun 2020 06:11:44 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E971C08C5C2;
        Tue, 16 Jun 2020 03:11:44 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id t7so9009371pgt.3;
        Tue, 16 Jun 2020 03:11:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+DDvbXVX193o17UcLMTUbMeH8CTAaBYWS5DD7w7zZaU=;
        b=lEK3UBVOkUsVf3zAPvTqQPR1zgadS22r1sA3WXu2swfUqsVGvEifaT6Ryx/3tA+KMl
         twfELE9qS2bc9f51ZQsWVXL/O+FoR2680VoOBGA/h/OBZxkB8KER7Pij4tjevwKN2ylb
         44Nvb2e6xwc463yygnahJZq76/1xWx5Gr6GAlwiRCdCyp9AW5u7oDvIzIjBmfny5HnqP
         mvHDsr4VzVclADwxPl8tcufmihgH0MdJKPqyGT+83iq+0y0j6TOk1+zxI6QEjaQ1Yv1P
         RzXxcIHf4J2vefTSXxhj+RhH0GA/Ek1zTa4VyiYPc0WJTHLWN5Qb1BM6niIOJW53jjG7
         sncw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+DDvbXVX193o17UcLMTUbMeH8CTAaBYWS5DD7w7zZaU=;
        b=pKOzxDy1DKpWPzdeMwdYCZzrwwQB6pM8m74gvwXxDicUYhaHWnw6S9UG1QCV/PwrTL
         Wx0GIcZGfL4P2X3CTPxw4uCVFWCgolq0yI8IHaCpMkg0exN1xdBA0sI/Zr8zQlmx8Npp
         MlmYPjSUY6s65aFAGheADSEqCg6k4HW8gTIdizRsq9UnMR3OLd91ObXpCbKKKw+KmV88
         shlVUuYmpPcFix/MXbJ7JAYeD8LaBbftBUl/10w5zCbI897V7hTvR8pLpDfmOj/1Kj7/
         z5RMx+CZ14MgBBXSYyKkdUQl1IOy+8kfHIJ8p1CZ5UKTzhpWpz6LenAoxW3TFzsrfEUh
         hLJA==
X-Gm-Message-State: AOAM533XqyOPGEVYPpCuHqyXIWONTKsOM0FMhCLeJLAR/1MINlDKOdFG
        2xvhGAUXv76ENEDrxrYKuPuusGRLwt4=
X-Google-Smtp-Source: ABdhPJw5R5Rqb6CDQM+EfFstskOgpiQ/u+MM6HY9i6ksDyACTBLgFn6HWI7V/jE+BotO6XBfZ3LGjg==
X-Received: by 2002:a05:6a00:50:: with SMTP id i16mr1389551pfk.25.1592302303925;
        Tue, 16 Jun 2020 03:11:43 -0700 (PDT)
Received: from dhcp-12-153.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id b19sm1995089pjo.57.2020.06.16.03.11.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jun 2020 03:11:43 -0700 (PDT)
Date:   Tue, 16 Jun 2020 18:11:33 +0800
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
Message-ID: <20200616101133.GV102436@dhcp-12-153.nay.redhat.com>
References: <20200415085437.23028-1-liuhangbin@gmail.com>
 <20200526140539.4103528-1-liuhangbin@gmail.com>
 <20200526140539.4103528-2-liuhangbin@gmail.com>
 <20200610121859.0412c111@carbon>
 <20200612085408.GT102436@dhcp-12-153.nay.redhat.com>
 <20200616105506.163ea5a3@carbon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200616105506.163ea5a3@carbon>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

HI Jesper,

On Tue, Jun 16, 2020 at 10:55:06AM +0200, Jesper Dangaard Brouer wrote:
> > Is there anything else I should do except add the following line?
> > 	nxdpf->mem.type = MEM_TYPE_PAGE_ORDER0;
> 
> You do realize that you also have copied over the mem.id, right?

Thanks for the reminding. To confirm, set mem.id to 0 is enough, right?
> 
> And as I wrote below you also need to update frame_sz.
> 
> > > 
> > > You also need to update xdpf->frame_sz, as you also cannot assume it is
> > > the same.  
> > 
> > Won't the memcpy() copy xdpf->frame_sz to nxdpf? 
> 
> You obviously cannot use the frame_sz from the existing frame, as you
> just allocated a new page for the new xdp_frame, that have another size
> (here PAGE_SIZE).

Thanks, I didn't understand the frame_sz correctly before.
> 
> 
> > And I didn't see xdpf->frame_sz is set in xdp_convert_zc_to_xdp_frame(),
> > do we need a fix?
> 
> Good catch, that sounds like a bug, that should be fixed.
> Will you send a fix?

OK, I will.

> 
> 
> > > > +
> > > > +	nxdpf = addr;
> > > > +	nxdpf->data = addr + headroom;
> > > > +
> > > > +	return nxdpf;
> > > > +}
> > > > +EXPORT_SYMBOL_GPL(xdpf_clone);  
> > > 
> > > 
> > > struct xdp_frame {
> > > 	void *data;
> > > 	u16 len;
> > > 	u16 headroom;
> > > 	u32 metasize:8;
> > > 	u32 frame_sz:24;
> > > 	/* Lifetime of xdp_rxq_info is limited to NAPI/enqueue time,
> > > 	 * while mem info is valid on remote CPU.
> > > 	 */
> > > 	struct xdp_mem_info mem;
> > > 	struct net_device *dev_rx; /* used by cpumap */
> > > };
> > >   
> > 
> 
> struct xdp_mem_info {
> 	u32                        type;                 /*     0     4 */
> 	u32                        id;                   /*     4     4 */
> 
> 	/* size: 8, cachelines: 1, members: 2 */
> 	/* last cacheline: 8 bytes */
> };
> 

Is this a struct reference or you want to remind me something else?

Thanks
Hangbin
