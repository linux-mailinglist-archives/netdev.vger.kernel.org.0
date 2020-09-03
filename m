Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39C1A25BE2E
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 11:15:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728134AbgICJPv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 05:15:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726293AbgICJPt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 05:15:49 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0D30C061244;
        Thu,  3 Sep 2020 02:15:48 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id q1so1176230pjd.1;
        Thu, 03 Sep 2020 02:15:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=hpWWd2JhTGYPsz7eNY+TnlcXpGFieQUpRJVY+cZuPqc=;
        b=juYP55QQfpcn0OBh+JwlaXanLT/teb4m9g8EM06VOvBZKprYPWzubZ7TZyu0yT7Q00
         A8poIsUbk0v4De3N6vOPIDnXAHaxgYlqVX94CdYLvskskIb0RqFxp77f8fBus/lOCuZv
         Zh1aqmYh81o8U8jav36Ox7ZQhDVetaK25nfLS50JfuS1J0AtiFVf9bMO1TzC5PIIcLlO
         zR5PjoP0SD4RoBExE2NJcFvpb6Bw20QGy165CgvJSJGQAZAzaqAzVgRYAQTwNgJF/leK
         zP775/BRiWg9KK1jzYDNYC/c95mMBXcx/MEQv+o9/JGSoe1D7qoKlS1d7dFh2rSmYvuV
         8cHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hpWWd2JhTGYPsz7eNY+TnlcXpGFieQUpRJVY+cZuPqc=;
        b=rqSgLttQeZaZ/T8ziTyrDVMt4BUmt2ez/RrIS/CtiZVKS8dS2yckJ1jcTDhvx8f8lL
         HxF5yg4slmfG/x1AGucJ6T0abFZfJdoYnq/z5Mk+VBf2E69BjoaKYnluQrECeKw/OJ0n
         4VeGR73a2h+Ynl2JiBa8HSLx3By6Qn/8BJxwErs3Z+yQpvZKBU3yfSyu2xDqGwklT7Zf
         2X0dtNy4r2Z23o6uE8xjb8cGeA12psHSPnmriUXxkCRRszMjmLysrHF0VZLZTnV88V3r
         f42kxi2Boom9blAOZiw/fTvB4C6ICWpfTkxmgibbXw8m/n0fx+cP5Wc8C/j2BmwwQGLJ
         /2fQ==
X-Gm-Message-State: AOAM532WFK3sbG55vw7nUuzuaociRvpUI8xInQFgynEQ+lqeDSNL9puV
        I6lVLj8MSCVntZSEnQ66Dhc=
X-Google-Smtp-Source: ABdhPJysQe9mPnOT/jp7EcRs2oMxM3OkWtI6qpr/G3uZ780XWl3zOC6NddBq4G8GTF5+oL3Ln56lFA==
X-Received: by 2002:a17:90a:1f43:: with SMTP id y3mr2355408pjy.28.1599124548398;
        Thu, 03 Sep 2020 02:15:48 -0700 (PDT)
Received: from dhcp-12-153.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id f28sm2393368pfq.191.2020.09.03.02.15.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2020 02:15:47 -0700 (PDT)
Date:   Thu, 3 Sep 2020 17:15:37 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Jiri Benc <jbenc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Andrii Nakryiko B <andrii.nakryiko@gmail.com>
Subject: Re: [PATCHv9 bpf-next 1/5] bpf: add a new bpf argument type
 ARG_CONST_MAP_PTR_OR_NULL
Message-ID: <20200903091537.GR2531@dhcp-12-153.nay.redhat.com>
References: <20200715130816.2124232-1-liuhangbin@gmail.com>
 <20200826132002.2808380-1-liuhangbin@gmail.com>
 <20200826132002.2808380-2-liuhangbin@gmail.com>
 <a6ef587d-8128-a926-16b3-01e7ef7b4c8b@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a6ef587d-8128-a926-16b3-01e7ef7b4c8b@iogearbox.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Daniel,

Sorry for the late reply. I was in PTO last few days.

On Fri, Aug 28, 2020 at 11:56:37PM +0200, Daniel Borkmann wrote:
> On 8/26/20 3:19 PM, Hangbin Liu wrote:
> > Add a new bpf argument type ARG_CONST_MAP_PTR_OR_NULL which could be
> > used when we want to allow NULL pointer for map parameter. The bpf helper
> > need to take care and check if the map is NULL when use this type.
> > 
> > Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> > ---
> > 
> > v9: merge the patch from [1] in to this series.
> > v1-v8: no this patch
> > 
> > [1] https://lore.kernel.org/bpf/20200715070001.2048207-1-liuhangbin@gmail.com/
> > ---
> >   include/linux/bpf.h   |  2 ++
> >   kernel/bpf/verifier.c | 23 ++++++++++++++++-------
> >   2 files changed, 18 insertions(+), 7 deletions(-)
> > 
> > diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> > index a6131d95e31e..cb40a1281ea2 100644
> > --- a/include/linux/bpf.h
> > +++ b/include/linux/bpf.h
> > @@ -276,6 +276,7 @@ enum bpf_arg_type {
> >   	ARG_PTR_TO_ALLOC_MEM,	/* pointer to dynamically allocated memory */
> >   	ARG_PTR_TO_ALLOC_MEM_OR_NULL,	/* pointer to dynamically allocated memory or NULL */
> >   	ARG_CONST_ALLOC_SIZE_OR_ZERO,	/* number of allocated bytes requested */
> > +	ARG_CONST_MAP_PTR_OR_NULL,	/* const argument used as pointer to bpf_map or NULL */
> >   };
> >   /* type of values returned from helper functions */
> > @@ -369,6 +370,7 @@ enum bpf_reg_type {
> >   	PTR_TO_RDONLY_BUF_OR_NULL, /* reg points to a readonly buffer or NULL */
> >   	PTR_TO_RDWR_BUF,	 /* reg points to a read/write buffer */
> >   	PTR_TO_RDWR_BUF_OR_NULL, /* reg points to a read/write buffer or NULL */
> > +	CONST_PTR_TO_MAP_OR_NULL, /* reg points to struct bpf_map or NULL */
> 
> Why is this needed & where do you assign it? Also, if we were to use CONST_PTR_TO_MAP_OR_NULL
> then it's missing few things like rejection of arithmetic in adjust_ptr_min_max_vals(), handling
> in pruning logic etc.
> 
> Either way, given no helper currently returns CONST_PTR_TO_MAP_OR_NULL, the ARG_CONST_MAP_PTR_OR_NULL
> one should be sufficient, so I'd suggest to remove the CONST_PTR_TO_MAP_OR_NULL bits.

Sorry, I misunderstand the bpf_reg_type when added it.

Thanks for the comment. I will remove it.

> > -	} else if (arg_type == ARG_CONST_MAP_PTR) {
> > +	} else if (arg_type == ARG_CONST_MAP_PTR ||
> > +		   arg_type == ARG_CONST_MAP_PTR_OR_NULL) {
> >   		expected_type = CONST_PTR_TO_MAP;
> > -		if (type != expected_type)
> > +		if (register_is_null(reg) &&
> > +		    arg_type == ARG_CONST_MAP_PTR_OR_NULL)
> > +			/* final test in check_stack_boundary() */;
> 
> Where is that test in the code? Copy-paste leftover comment?

Yeah...  I will remove it.

Thanks
Hangbin
