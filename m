Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D96E734CE52
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 12:56:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231953AbhC2K4C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 06:56:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232960AbhC2K4A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 06:56:00 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E80DC061574
        for <netdev@vger.kernel.org>; Mon, 29 Mar 2021 03:56:00 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id x7-20020a17090a2b07b02900c0ea793940so7509597pjc.2
        for <netdev@vger.kernel.org>; Mon, 29 Mar 2021 03:56:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=POvzJONCkQPXYC+hELvIUGM/2nPTnSDMwRGB706ohvs=;
        b=R5KlXmQYEYFbbwVF+ksJpXlH5R0WgWNo30eiZfLa7xI0kSg476kpMP+ibETWizlgYf
         nNQrhN2SovMZ/v17NJpavAVVOAehcxWfNS118o8NfafWWk4ke7kPck1ObDrHHxWmANjj
         p9l+csJssQpr6+lpV1LmOw1byQvHmm38yMH0GsekTvf5LGN6jdqT/qYNIGV3fYkVVxWV
         ssX4ZWyj2WU5zGi1HsGpZlBZuXwmPu7mEyQvkgkuniU5e6mNPkQxJdfr2mPMTXWyO5z3
         nIMoedhHNQ4E2UBh3rTh+F8lxhofarc4XSTQeqqoTWYHLUYK0Capl1yoQNltNbdu+rXw
         PEng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=POvzJONCkQPXYC+hELvIUGM/2nPTnSDMwRGB706ohvs=;
        b=S8mRFYL/cG7M/gKDSkyPfbHvLj+ZRcY4LwS9pI7nMdeyWUrmZch9g7msvC7PBiu3up
         tLBm/QZaZ3Po/z1/KJUkfose9IwapRGqKhO3KLibfcA69Mrzro+MF5EHMRuY4O1cRGHR
         1/MLjPts/oXBu05vGxRQKLzmMmoYFVyRIOq7cQ4y3vJFTDRr2V0Tcw9VzNeuDGJTnRhG
         BVyo2iQprQhzN7Ytm+lxdR+GSYggzoMaZgKwTmM9V5Pr/eP1GjwRZbaCYjhipArp79lE
         XmdGl+KMBh+Piu0cJTOepgBMFVwdzIEdzqxtDir0z4IcU/TRd3evLRK5YtCFG7T1kGGq
         z1FA==
X-Gm-Message-State: AOAM530D52pBeyxNQt/L1Ttvu6GQZMmaJeUCwcfURrrL91L6097r833t
        80ptUVmQ/0T0mACQnb1xaB0=
X-Google-Smtp-Source: ABdhPJy365hEdAL0nYl73rxCHz/j8Rk8Z4vWiSkebE0B9MI9JFjeluh9wFYBzmW7BoWW9jB9diHMlQ==
X-Received: by 2002:a17:902:8494:b029:e6:cb9a:9fd5 with SMTP id c20-20020a1709028494b02900e6cb9a9fd5mr27239447plo.81.1617015359910;
        Mon, 29 Mar 2021 03:55:59 -0700 (PDT)
Received: from ThinkCentre-M83 ([202.133.196.154])
        by smtp.gmail.com with ESMTPSA id f2sm14895464pju.46.2021.03.29.03.55.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Mar 2021 03:55:59 -0700 (PDT)
Date:   Mon, 29 Mar 2021 18:55:56 +0800
From:   Du Cheng <ducheng2@gmail.com>
To:     manivannan.sadhasivam@linaro.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>,
        syzbot+3eec59e770685e3dc879@syzkaller.appspotmail.com,
        Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v2] net:qrtr: fix atomic idr allocation in
 qrtr_port_assign()
Message-ID: <20210329105556.GA334561@ThinkCentre-M83>
References: <20210327140702.4916-1-ducheng2@gmail.com>
 <YF89PtWrs2N5XSgb@kroah.com>
 <20210327142520.GA5271@ThinkCentre-M83>
 <YF9BthXs2ha7hnrF@kroah.com>
 <20210327155110.GI1719932@casper.infradead.org>
 <YGAokfl9xvl3CnQR@kroah.com>
 <20210328100417.GA14132@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210328100417.GA14132@casper.infradead.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 28, 2021 at 11:04:17AM +0100, Matthew Wilcox wrote:
> On Sun, Mar 28, 2021 at 08:56:17AM +0200, Greg Kroah-Hartman wrote:
> > On Sat, Mar 27, 2021 at 03:51:10PM +0000, Matthew Wilcox wrote:
> > > On Sat, Mar 27, 2021 at 03:31:18PM +0100, Greg Kroah-Hartman wrote:
> > > > On Sat, Mar 27, 2021 at 10:25:20PM +0800, Du Cheng wrote:
> > > > > On Sat, Mar 27, 2021 at 03:12:14PM +0100, Greg Kroah-Hartman wrote:
> > > > > > Adding the xarray maintainer...
> > > > > > 
> > > > > > On Sat, Mar 27, 2021 at 10:07:02PM +0800, Du Cheng wrote:
> > > > > > > add idr_preload() and idr_preload_end() around idr_alloc_u32(GFP_ATOMIC)
> > > > > > > due to internal use of per_cpu variables, which requires preemption
> > > > > > > disabling/enabling.
> > > > > > > 
> > > > > > > reported as "BUG: "using smp_processor_id() in preemptible" by syzkaller
> > > > > > > 
> > > > > > > Reported-by: syzbot+3eec59e770685e3dc879@syzkaller.appspotmail.com
> > > > > > > Signed-off-by: Du Cheng <ducheng2@gmail.com>
> > > > > > > ---
> > > > > > > changelog
> > > > > > > v1: change to GFP_KERNEL for idr_alloc_u32() but might sleep
> > > > > > > v2: revert to GFP_ATOMIC but add preemption disable/enable protection
> > > > > > > 
> > > > > > >  net/qrtr/qrtr.c | 6 ++++++
> > > > > > >  1 file changed, 6 insertions(+)
> > > > > > > 
> > > > > > > diff --git a/net/qrtr/qrtr.c b/net/qrtr/qrtr.c
> > > > > > > index edb6ac17ceca..6361f169490e 100644
> > > > > > > --- a/net/qrtr/qrtr.c
> > > > > > > +++ b/net/qrtr/qrtr.c
> > > > > > > @@ -722,17 +722,23 @@ static int qrtr_port_assign(struct qrtr_sock *ipc, int *port)
> > > > > > >  	mutex_lock(&qrtr_port_lock);
> > > > > > >  	if (!*port) {
> > > > > > >  		min_port = QRTR_MIN_EPH_SOCKET;
> > > > > > > +		idr_preload(GFP_ATOMIC);
> > > > > > >  		rc = idr_alloc_u32(&qrtr_ports, ipc, &min_port, QRTR_MAX_EPH_SOCKET, GFP_ATOMIC);
> > > > > > > +		idr_preload_end();
> > > > > > 
> > > > > > This seems "odd" to me.  We are asking idr_alloc_u32() to abide by
> > > > > > GFP_ATOMIC, so why do we need to "preload" it with the same type of
> > > > > > allocation?
> > > > > > 
> > > > > > Is there something in the idr/radix/xarray code that can't really handle
> > > > > > GFP_ATOMIC during a "normal" idr allocation that is causing this warning
> > > > > > to be hit?  Why is this change the "correct" one?
> > > > > > 
> > > > > > thanks,
> > > > > > 
> > > > > > greg k-h
> > > > > 
> > > > > 
> > > > > >From the comment above idr_preload() in lib/radix-tree.c:1460
> > > > > /**
> > > > >  * idr_preload - preload for idr_alloc()
> > > > >  * @gfp_mask: allocation mask to use for preloading
> > > > >  *
> > > > >  * Preallocate memory to use for the next call to idr_alloc().  This function
> > > > >  * returns with preemption disabled.  It will be enabled by idr_preload_end().
> > > > >  */
> > > > > 
> > > > > idr_alloc is a very simple wrapper around idr_alloc_u32().
> > > > > 
> > > > > On top of radix_tree_node_alloc() which is called by idr_alloc_u32(), there is
> > > > > this comment at line 244 in the same radix-tree.c
> > > > > /*
> > > > >  * This assumes that the caller has performed appropriate preallocation, and
> > > > >  * that the caller has pinned this thread of control to the current CPU.
> > > > >  */
> > > > > 
> > > > > Therefore the preload/preload_end are necessary, or at least should have
> > > > > preemption disabled
> > > > 
> > > > Ah, so it's disabling preemption that is the key here.  Still odd, why
> > > > is GFP_ATOMIC not sufficient in a normal idr_alloc() call to keep things
> > > > from doing stuff like this?  Feels like a lot of "internal knowledge" is
> > > > needed here to use this api properly...
> > > > 
> > > > Matthew, is the above change really correct?
> > > 
> > > No.
> > > 
> > > https://lore.kernel.org/netdev/20200605112922.GB19604@bombadil.infradead.org/
> > > https://lore.kernel.org/netdev/20200605120037.17427-1-willy@infradead.org/
> > > https://lore.kernel.org/netdev/20200914192655.GW6583@casper.infradead.org/
> > > 
> > 
> > Ok, it looks like this code is just abandonded, should we remove it
> > entirely as no one wants to maintain it?
> 
> Fine by me.  I don't use it.  Better to get rid of abandonware than keep
> a potential source of security holes.

Hi Manivannan,

For your information.

Regards,
Du Cheng
