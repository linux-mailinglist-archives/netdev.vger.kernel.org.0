Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E206B17A664
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 14:31:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725990AbgCENbU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 08:31:20 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:52063 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725912AbgCENbT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Mar 2020 08:31:19 -0500
Received: by mail-wm1-f66.google.com with SMTP id a132so6325862wme.1
        for <netdev@vger.kernel.org>; Thu, 05 Mar 2020 05:31:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=bDSCo6hMfyEltG1hYn+8156dRjR7PPf+IPanTdcmbR4=;
        b=RtgmWpUpVGrohNw4WOJf/RSSohImHhaQVBAG6hCpVWemW/GNxMs5c7d/69UzClLcfS
         vVpp8m1wb9psv4jGFuEUZNxSVoIuiolFFngVDolnORSO4I/WK6nEN9DPPM6UO5X646EC
         WDGfxCWMk5FoSeQTcHfzHa/UqU8khdUt2C7Q+NVxsqryb3KnUToHW5RaGAq7x5CG/A/r
         pF8g6AuJNN1aIq1b2VzL6srT3zA+aqD/Zd3eNJm6gNHK4Zt5gTlnqoFl3Mh3gq350Vgl
         7ccm65eu/Db8oz8bHyoe0ZhiiO9uGlVWzczgCHwQp5hax3MP6mw5TCCSrNO0vLIcFtNG
         dxtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=bDSCo6hMfyEltG1hYn+8156dRjR7PPf+IPanTdcmbR4=;
        b=DaB73ixlOip7H7jvZBBto15ESBctBH9tOcc3V6vPRPNX04zPoU1Lzl2pYYLddVeoBq
         GxeB8GrAULNqv4IwSydNLs+qSyZidkoGnLCZdAg0RWkABvECLt1bwXb3gsmqMRFhoN+y
         gAC4uZ1/VX3ELBMj6F3TbG/JBM9YF4u3hDu/rGN0DeSLhmyfHuWR/7jKx7eCr4a8f3di
         1/d8npTYGznRsE7cYovnQ+Za0EKVNO/jcHVyVOG9coFTABA8Wohh0IGJXFvq7o+AaORp
         kQuQCZhTC5W8MTQxf4pgX2nR0SrrsJksePtVp1EHoLM4ipiPoHB8+41izApORhIrdiYo
         JbMg==
X-Gm-Message-State: ANhLgQ0AlQ0WtAhhqAreYtm3xuYUzEfqvv1xO+uA2+kn08MzfJHJRXrQ
        rPgYU8nryEeWbU8eobzAWW2OXw==
X-Google-Smtp-Source: ADFU+vuSzy+qMHzqCJQhubQzv3ce0clMiWYh5C/iMMJtMb1jtbA1PyoyZow8LJ9AdSQOg9cNQgmusQ==
X-Received: by 2002:a1c:4b0f:: with SMTP id y15mr9659826wma.87.1583415077243;
        Thu, 05 Mar 2020 05:31:17 -0800 (PST)
Received: from apalos.home (ppp-2-87-54-32.home.otenet.gr. [2.87.54.32])
        by smtp.gmail.com with ESMTPSA id o9sm46379788wrw.20.2020.03.05.05.31.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Mar 2020 05:31:16 -0800 (PST)
Date:   Thu, 5 Mar 2020 15:31:14 +0200
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Denis Kirjanov <kirjanov@gmail.com>
Cc:     Denis Kirjanov <kda@linux-powerpc.org>, netdev@vger.kernel.org,
        jgross@suse.com
Subject: Re: [PATCH net-next v2] xen-netfront: add basic XDP support
Message-ID: <20200305133114.GA574299@apalos.home>
References: <1583158874-2751-1-git-send-email-kda@linux-powerpc.org>
 <20200305130404.GA574021@apalos.home>
 <CAHj3AVndOjLsOkjC1h5WOb+NaswHaggC3MTaRq-r7mA6rGcCZw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHj3AVndOjLsOkjC1h5WOb+NaswHaggC3MTaRq-r7mA6rGcCZw@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 05, 2020 at 04:23:31PM +0300, Denis Kirjanov wrote:
> On 3/5/20, Ilias Apalodimas <ilias.apalodimas@linaro.org> wrote:
> > Hi Denis,
> >
> > There's a bunch of things still missing from my remarks on V1.
> > XDP is not supposed to allocate and free pages constantly as that's one of
> > the
> > things that's making it fast.
> 
> Hi Ilias,
> 
> I've removed the copying to an allocated page so there is no page
> allocation/free logic added.
> 
i
Yea that has been removed. I am not familiar with the driver though, so i'll
give you an example. 
Let's say the BPF program says the packet must be dropped. What will happen to
the page with the packet payload?
Ideally on XDP we want that page recycled back into the device descriptors, so
the driver won't have to allocate and map a fresh page.

> 
> >
> > You are also missing proper support for XDP_REDIRECT, ndo_xdp_xmit. We
> > usually
> > require the whole functionality to merge the driver.
> 
> I wanted to minimize changes and send follow-up patches
> 

Adding XDP_REDIRECT is pretty trivial and the ndo_xdp_xmit should be very
similar to XDP_TX. So assuming you'll fix XDP_TX adding the .ndo one will be
relatively small amount of code.

> >
> >
> > On Mon, Mar 02, 2020 at 05:21:14PM +0300, Denis Kirjanov wrote:
> >>
> > [...]
> >> +u32 xennet_run_xdp(struct netfront_queue *queue, struct page *pdata,
> >> +		   struct xen_netif_rx_response *rx, struct bpf_prog *prog,
> >> +		   struct xdp_buff *xdp)
> >> +{
> >> +	u32 len = rx->status;
> >> +	u32 act = XDP_PASS;
> >> +
> >> +	xdp->data_hard_start = page_address(pdata);
> >> +	xdp->data = xdp->data_hard_start + XDP_PACKET_HEADROOM;
> >> +	xdp_set_data_meta_invalid(xdp);
> >> +	xdp->data_end = xdp->data + len;
> >> +	xdp->handle = 0;
> >> +
> >> +	act = bpf_prog_run_xdp(prog, xdp);
> >> +	switch (act) {
> >> +	case XDP_PASS:
> >> +	case XDP_TX:
> >> +	case XDP_DROP:
> >
> > Maybe i am missing something on the usage, but XDP_TX and XDROP are handled
> > similarly?
> > XDP_TX is supposed to sent the packet out of the interface it arrived.
> 
> Yep, you're right. I'll add it to the next version.
> 
> Thanks!
> 

Cheers
/Ilias
