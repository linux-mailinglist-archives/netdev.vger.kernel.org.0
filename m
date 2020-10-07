Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF163285BAE
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 11:14:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727023AbgJGJOL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 05:14:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726131AbgJGJOL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Oct 2020 05:14:11 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A42EC061755;
        Wed,  7 Oct 2020 02:14:11 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id n15so1284990wrq.2;
        Wed, 07 Oct 2020 02:14:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=uP41AxAirI5kgSSLv8bjqRlk/ljwQNpF8oZxpTbY8l0=;
        b=GaFP92hQcXPefevT1rafT9Y2lzLCa0PU/iJdCs68CaNIMPfE8N/yUkE+HJeo83vI7b
         3a8zEF1p3W83wYJcK6loECboG6Ctmy3z4MB1t44aMba4ApV1ZR+dFY/0qhidQRAjsR8n
         4d76L4LqdSgk11UKPYJKUaC0UtWnuixf4EJgFF3VKT2JmbyC+2N+QiTuQODR4iphOs1H
         w2U6W2f7/9NG+EPMlvctKkxJVHKMzTi3I1ai67XW+oLiGtdi4JlNw7Di5gJG1iXOJRoU
         RueimpsH3igbboaavIuH8o/deFxWBNjRrwUSP4ZVMgnJWLIC080rwCHvxYeTM+7RiHiX
         GmtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uP41AxAirI5kgSSLv8bjqRlk/ljwQNpF8oZxpTbY8l0=;
        b=GpF3iZfSJGJK3Jaog3WxV/OQzg+IoZ16g1m3xkbIKgXtZIVZwVlefXmwHkrdr5Kq6L
         8SGsEMojpguAXQROW5EU343UUJgv45Jo/PJip3okm4rIwlmBGU9zkrHlAOHXY+vm8Bs8
         4f5nFJ1cqDTXCcuaoQTfRFwPy1/FZ7UBlNj5njzW4U+aVHNbwmQwhUd1cNUgDWoIZQf3
         GcCQw1JClH4RwGs+Io5uUcj83YJAiFeDI1xKyw6A1D3mtcYJWLeEkQhOJGUq7tJcCpWg
         rf3f/Iqhjwbmill5RA1MBIk0U+nUvPUkt4omapOT6mgJIvkqUX27BFJCPJzqPyDjHr/+
         Ms5g==
X-Gm-Message-State: AOAM533JGUoQIGHtYb177HYtMHOcgWIVFnjxC+DGdq3UVciu2m05aRUW
        42BQL3hSjy2JWhi+3s9qprG/wxvwRAXFyg==
X-Google-Smtp-Source: ABdhPJyjLZyu5A8Xu/6Ic0iV8U8JZb8lba1JYrHJt2Gh/tJ4di648lnr+MDKWlEgxAFO0pNk0DN3sg==
X-Received: by 2002:adf:dccd:: with SMTP id x13mr2531381wrm.403.1602062049745;
        Wed, 07 Oct 2020 02:14:09 -0700 (PDT)
Received: from medion (cpc83661-brig20-2-0-cust443.3-3.cable.virginm.net. [82.28.105.188])
        by smtp.gmail.com with ESMTPSA id i126sm672754wmi.0.2020.10.07.02.14.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Oct 2020 02:14:09 -0700 (PDT)
From:   Alex Dewar <alex.dewar90@gmail.com>
X-Google-Original-From: Alex Dewar <alex.dewar@gmx.co.uk>
Date:   Wed, 7 Oct 2020 10:13:49 +0100
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     Alex Dewar <alex.dewar90@gmail.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/mlx5e: Fix freeing of unassigned pointer
Message-ID: <20201007091349.cceyuje3ktilygzv@medion>
References: <20201003111050.25130-1-alex.dewar90@gmail.com>
 <80cb7391f0feb838cc61a608efe0c24dcef41115.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <80cb7391f0feb838cc61a608efe0c24dcef41115.camel@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 06, 2020 at 04:22:12PM -0700, Saeed Mahameed wrote:
> On Sat, 2020-10-03 at 12:10 +0100, Alex Dewar wrote:
> > Commit ff7ea04ad579 ("net/mlx5e: Fix potential null pointer
> > dereference")
> > added some missing null checks but the error handling in
> > mlx5e_alloc_flow() was left broken: the variable attr is passed to
> > kfree
> > although it is never assigned to and never needs to be freed in this
> > function. Fix this.
> > 
> > Addresses-Coverity-ID: 1497536 ("Memory - illegal accesses")
> > Fixes: ff7ea04ad579 ("net/mlx5e: Fix potential null pointer
> > dereference")
> > Signed-off-by: Alex Dewar <alex.dewar90@gmail.com>
> > ---
> >  drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 17 +++++++++----
> > ----
> >  1 file changed, 9 insertions(+), 8 deletions(-)
> > 
> 
> Hi Alex, thanks for the patch, 
> Colin submitted a one liner patch that I already picked up.
> 
> I hope you are ok with this.

Hi Saeed,

Sure. As long as attr is no longer being freed then that should fix the
problem.

Best,
Alex

> 
> Thanks,
> Saeed.
> 
