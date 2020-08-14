Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 989DE244D4F
	for <lists+netdev@lfdr.de>; Fri, 14 Aug 2020 19:07:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728361AbgHNRHN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Aug 2020 13:07:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728269AbgHNRHL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Aug 2020 13:07:11 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EF6BC061386
        for <netdev@vger.kernel.org>; Fri, 14 Aug 2020 10:07:11 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id e5so7431052qth.5
        for <netdev@vger.kernel.org>; Fri, 14 Aug 2020 10:07:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9dxlpovzJD+TOEGVVjsD+xHktzeJbFiQKOPQEqkZM9M=;
        b=SAuPo0kB4++laPCsa/UJIFJ7sqnHBPnVC3kGXEza9f04NT29/1K9uJRiw/r7EK5U5u
         zO/yYdx38sU0we9d3cmvxhWEZKc5X6nwQ/XjLLeohAaIKY06PuBJaqR1trbDdIYnsGTH
         08eXLh8G+WR8e7CRlVIWWg1gEoZlYpFZ7hcOUzARI4KKmlviDtCF6F18vHxsBasvE2t6
         wAfTnGKPlE22dFrFIEH3weBYO2fU04//eTyCHDLLU0FvqwcgyhvTr+Y77w5T9pNVui0I
         fqiFrISZhNZ6ri+OWInsJI2CF2gs+c3eTR46kGxaCeZCwXLm7ay2e+mDwN+n2xutul2m
         3UYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9dxlpovzJD+TOEGVVjsD+xHktzeJbFiQKOPQEqkZM9M=;
        b=BfyqYZEa+rrnnlyI8VnaUuFDGw3iJF0tYYDO3WGJaVq3mF8HsPXpOSHMdUlQMYT6KZ
         KKrgq+Y2Ztoyk7yvybTjBjWOj2sVl+yE0FSd6dQLxIU28apIcKhFF5CsAAh6EO7lRDJk
         RYksMGeK0APzjIWoOHopRer/8WY9mbUQAUMA7ZNAk+6U4yLWMdOJjWzd2TE+JJgF0/mf
         8scdr4ot2uv9yaH66yuLHWyvVzgs9O3SaPnOyD31MiuSfcc17W57qMRiUzklsklKzNtA
         iA9xOFHAMnG9a9HcRRfVt8OchP6EOFzGxwW9gYhcbUT2VIMM3EGZawmaBzkGHl1rd06p
         xdAw==
X-Gm-Message-State: AOAM530H646nf7jFStTT28dsqbMnSseiVNyJgwXSuA7vvDAxFYUdknwe
        dNDJNQsRRpRatNQGNNn+u4Gzzw==
X-Google-Smtp-Source: ABdhPJxtxR/DpDD2wqT6cjrvAzJOAgKL557tPYvsOhNta+6vq5T+QXPHbnmTF7MBntLVhE9sMcpbrg==
X-Received: by 2002:aed:33e7:: with SMTP id v94mr2860210qtd.18.1597424829705;
        Fri, 14 Aug 2020 10:07:09 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-156-34-48-30.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.48.30])
        by smtp.gmail.com with ESMTPSA id x29sm10363864qtv.80.2020.08.14.10.07.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Aug 2020 10:07:08 -0700 (PDT)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1k6dAZ-006l92-QG; Fri, 14 Aug 2020 14:07:07 -0300
Date:   Fri, 14 Aug 2020 14:07:07 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Jack Leadford <leadford.jack@gmail.com>
Cc:     Joe Perches <joe@perches.com>, Leon Romanovsky <leon@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peilin Ye <yepeilin.cs@gmail.com>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        rds-devel@oss.oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [Linux-kernel-mentees] [PATCH net] rds: Prevent kernel-infoleak
 in rds_notify_queue_get()
Message-ID: <20200814170707.GV24045@ziepe.ca>
References: <20200731142148.GA1718799@kroah.com>
 <20200731143604.GF24045@ziepe.ca>
 <20200731171924.GA2014207@kroah.com>
 <20200801053833.GK75549@unreal>
 <20200802221020.GN24045@ziepe.ca>
 <fb7ec4d4ed78e6ae7fa6c04abb24d1c00dc2b0f7.camel@perches.com>
 <20200802222843.GP24045@ziepe.ca>
 <60584f4c0303106b42463ddcfb108ec4a1f0b705.camel@perches.com>
 <20200803230627.GQ24045@ziepe.ca>
 <ff066616-3bb8-b6c8-d329-7de5ab8ee982@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ff066616-3bb8-b6c8-d329-7de5ab8ee982@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 08, 2020 at 03:57:33PM -0700, Jack Leadford wrote:
> Hello!
> 
> Thanks to Jason for getting this conversation back on track.
> 
> Yes: in general, {} or a partial initializer /will/ zero padding bits.
> 
> However, there is a bug in some versions of GCC where {} will /not/ zero
> padding bits; actually, Jason's test program in this mail
> https://lore.kernel.org/lkml/20200731143604.GF24045@ziepe.ca/
> has the right ingredients to trigger the bug, but the GCC
> versions used are outside of the bug window. :)

It seems fine, at least Godbolt doesn't show a bug with that code.

Can you share the test that does fail?

This seems like the sort of security sensitive bug that should be
addressed in gcc, not worked around in the kernel code :\

Jason
