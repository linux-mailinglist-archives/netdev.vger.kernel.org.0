Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E3593B1306
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 06:55:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230048AbhFWE5j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 00:57:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229688AbhFWE5i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Jun 2021 00:57:38 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39D79C061574;
        Tue, 22 Jun 2021 21:55:21 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id m17so514339plx.7;
        Tue, 22 Jun 2021 21:55:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Z98M28/S5DTkRaCcduNwo8JvvrtDJam3SJ6vLPsh7e8=;
        b=t0j8pqTBwCofwBmzsMnRKN8o9RrKS1dthZm7imB1FnfTXT4A2CS3bmDV2d8UFN/n4N
         fbTB+6140FV1SHkH6VwmXE1szaiWj2fZGCdsVaXGt142q2M9RNTxNs4GXuqKZDyqsfnD
         LyO2vGQ9mfzOMJM23AnGFSEteQCimeJv+P7eMFcL4y/91lB+NW3HQakXN7LYiDIpFa9s
         JBPPxLeMYO3mQR/2yCyVtlOGPgIhWRzGS+HlX2G6ymqCxqdcULDl9ATcoGU5mULnuOlO
         N9BwAjm5kVRj5cZ87t1LVHOgCrsEErDJW6ILBQ08et/0UmsKEkaz8RbC7dJAXjwOYxBP
         DeMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Z98M28/S5DTkRaCcduNwo8JvvrtDJam3SJ6vLPsh7e8=;
        b=jj37eMHceGTT+xAIPSjvnMm+z5vacl1wAJExopmjaGBR7uCTRZ26vLhBhih2K7Jemu
         +d8p1cp0cyb693hIVPNSjrvCnaE7F8SSc88vtlu0rNyIoYpfjvsyVf/41w8ok4jAUJfQ
         1z761+zFK3/8iiL/N2RqrQEIQwYGgkrbMJWrQfSn2wGA8bFJ5hJ5CWYdZua2PmgJGfkK
         GbYLis3luAZuzbPbbM5jS+oJ9uCj4gfpfC4rWcmCiObavPHyT85/13lN6DFUYXedJX+h
         sNRQOx/Gcu8UaQ+2gv4Br84om2oOZebkQRAUYQS07/WNkr5WsRJ905wESBi0CXOXUadg
         yg4g==
X-Gm-Message-State: AOAM533aixgI5Gg0yAegaQNglku90xmGrUL9r3tE7tFB5kM2pLxSn1yk
        ZwlMqURJQauO2JaLBg7/dxc=
X-Google-Smtp-Source: ABdhPJyr34usZfM4otBZLMCgqdIkx6xknpF7q6eN/7Pl6CxcYIkUbun7aJssJW51BLb6HSZg9pSefQ==
X-Received: by 2002:a17:90a:4410:: with SMTP id s16mr7264860pjg.25.1624424120569;
        Tue, 22 Jun 2021 21:55:20 -0700 (PDT)
Received: from d3 ([2405:6580:97e0:3100:ae94:2ee7:59a:4846])
        by smtp.gmail.com with ESMTPSA id r14sm16539508pgu.18.2021.06.22.21.55.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Jun 2021 21:55:19 -0700 (PDT)
Date:   Wed, 23 Jun 2021 13:55:15 +0900
From:   Benjamin Poirier <benjamin.poirier@gmail.com>
To:     Coiby Xu <coiby.xu@gmail.com>
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        linux-staging@lists.linux.dev, netdev@vger.kernel.org,
        Shung-Hsi Yu <shung-hsi.yu@suse.com>,
        Manish Chopra <manishc@marvell.com>,
        "supporter:QLOGIC QLGE 10Gb ETHERNET DRIVER" 
        <GR-Linux-NIC-Dev@marvell.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [RFC 01/19] staging: qlge: fix incorrect truesize accounting
Message-ID: <YNK+s9Rm7OtL++YM@d3>
References: <20210621134902.83587-1-coiby.xu@gmail.com>
 <20210621134902.83587-2-coiby.xu@gmail.com>
 <20210621141027.GJ1861@kadam>
 <20210622113649.vm2hfh2veqr4dq6y@Rk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210622113649.vm2hfh2veqr4dq6y@Rk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-06-22 19:36 +0800, Coiby Xu wrote:
> On Mon, Jun 21, 2021 at 05:10:27PM +0300, Dan Carpenter wrote:
> > On Mon, Jun 21, 2021 at 09:48:44PM +0800, Coiby Xu wrote:
> > > Commit 7c734359d3504c869132166d159c7f0649f0ab34 ("qlge: Size RX buffers
> > > based on MTU") introduced page_chunk structure. We should add
> > > qdev->lbq_buf_size to skb->truesize after __skb_fill_page_desc.
> > > 
> > 
> > Add a Fixes tag.
> 
> I will fix it in next version, thanks!
> 
> > 
> > The runtime impact of this is just that ethtool will report things
> > incorrectly, right?  It's not 100% from the commit message.  Could you
> > please edit the commit message so that an ignoramous like myself can
> > understand it?

truesize is used in socket memory accounting, the stuff behind sysctl
net.core.rmem_max, SO_RCVBUF, ss -m, ...

Some helpful chap wrote a page about it a while ago:
http://vger.kernel.org/~davem/skb_sk.html

> 
> I'm not sure how it would affect ethtool. But according to "git log
> --grep=truesize", it affects coalescing SKBs. Btw, I fixed the issue
> according to the definition of truesize which according to Linux Kernel
> Network by Rami Rosen, it's defined as follows,
> > The total memory allocated for the SKB (including the SKB structure
> > itself and the size of the allocated data block).
> 
> I'll edit the commit message to include it, thanks!
> 
> > 
> > Why is this an RFC instead of just a normal patch which we can apply?
> 
> After doing the tests mentioned in the cover letter, I found Red Hat's
> network QE team has quite a rigorous test suite. But I needed to return the
> machine before having the time to learn about the test suite and run it by
> myself. So I mark it as an RFC before I borrow the machine again to run the
> test suite.

Interesting. Is this test suite based on a public project?
