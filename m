Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A7E41E8762
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 21:12:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727094AbgE2TMv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 15:12:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726549AbgE2TMu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 15:12:50 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC07DC03E969
        for <netdev@vger.kernel.org>; Fri, 29 May 2020 12:12:50 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id y1so2817680qtv.12
        for <netdev@vger.kernel.org>; Fri, 29 May 2020 12:12:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ACiu2dQda9PBJXSE7IXUBFb1/qdieyWqap/JzEJlViY=;
        b=Kt1KpbcD6fbOcBx2twz0YjUh0++icuot9nRLnKfuD+VhzrhyfcqBBBSSGNVVrgpigh
         i+/TRItedCZt2NAPAg8R61mat8NyyPJSy+vtQf0jFPXJtP6D8zYGdudrORlg01gtih0A
         ZVDLU2njkoBTkU/JtKNiitqD9BhmTZWj0oK4dKMWZLgqNimCd7iriHlKraUcx9c8B8Iu
         Ic7uzTi6t7vwmZ8VA/AnLml+RTYTN8cJv0+rNJkSnKFuhnd5hWzbipPiCSWpdsd1H0yH
         dWRjQIgvfp2YS5uz8pYGuxBWRoFMffvVl2tgaiqRcgVeEyn/zpS4xCQV1ZzauSOoF0x5
         cccA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ACiu2dQda9PBJXSE7IXUBFb1/qdieyWqap/JzEJlViY=;
        b=KJUhVoMxsiEKzJbCisldH7E118KTQUpPWlsKE9LelnYHHZNqKbm7ICwPGiiV9AIzFw
         oco0a5+epfgQWVwEm6mVVAiV8L5lnYdVo/HctQZLE14d4IojZ8k4eYYUEudjB1eVLK6q
         Xo+bKUNHdiHKX2HSXEhjd7V+eGHvlbx+bCvpTb+KEBJrWH5AuID0MTrK7JMnFsKJjcJ1
         MDS3J3qDl8aYI3f5xxa2an09gnw9wFQY3CrXIP6n6Prm/dk7wDkA1SFsxtaRhLnG05Qr
         V6dQ+ZF2Kr1PXiSZU/0/+8wOTGE6NVmVdIyMX2yFjojyE/dZc+KsY4V6+VJOsjZ7QAZe
         bvwQ==
X-Gm-Message-State: AOAM530o9t/tPCQTE5KPXysGvRJPPKlrm1nPLoNyAQqnM10ssa3zFlAq
        3l+d9j/3E8gpyLi5hahJdKcCUg==
X-Google-Smtp-Source: ABdhPJy7C8fa3/ShJ0Wm9RjYKVSLeDMIuHMTsqYfHuZYNoyzLrebsqcY62O39HKCiDt07YdBZctPRQ==
X-Received: by 2002:aed:3b54:: with SMTP id q20mr10745858qte.362.1590779569958;
        Fri, 29 May 2020 12:12:49 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-156-34-48-30.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.48.30])
        by smtp.gmail.com with ESMTPSA id v126sm7454194qkd.36.2020.05.29.12.12.49
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 29 May 2020 12:12:49 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1jekQy-0007ci-RJ; Fri, 29 May 2020 16:12:48 -0300
Date:   Fri, 29 May 2020 16:12:48 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     santosh.shilimkar@oracle.com
Cc:     linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        aron.silverton@oracle.com, Max Gurtovoy <maxg@mellanox.com>,
        oren@mellanox.com, shlomin@mellanox.com, vladimirk@mellanox.com
Subject: Re: [PATCH v3 03/13] RDMA/rds: Remove FMR support for memory
 registration
Message-ID: <20200529191248.GB21651@ziepe.ca>
References: <3-v3-f58e6669d5d3+2cf-fmr_removal_jgg@mellanox.com>
 <27824c0c-06ba-40dd-34c2-2888fe8db5c8@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <27824c0c-06ba-40dd-34c2-2888fe8db5c8@oracle.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 28, 2020 at 01:21:33PM -0700, santosh.shilimkar@oracle.com wrote:
> On 5/28/20 12:45 PM, Jason Gunthorpe wrote:
> > From: Max Gurtovoy <maxg@mellanox.com>
> > 
> > Use FRWR method for memory registration by default and remove the ancient
> > and unsafe FMR method.
> > 
> > Signed-off-by: Max Gurtovoy <maxg@mellanox.com>
> > Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
> 
> >   net/rds/Makefile  |   2 +-
> >   net/rds/ib.c      |  20 ++--
> >   net/rds/ib.h      |   2 -
> >   net/rds/ib_cm.c   |   4 +-
> >   net/rds/ib_fmr.c  | 269 ----------------------------------------------
> >   net/rds/ib_frmr.c |   4 +-
> >   net/rds/ib_mr.h   |  14 +--
> >   net/rds/ib_rdma.c |  28 ++---
> >   8 files changed, 21 insertions(+), 322 deletions(-)
> >   delete mode 100644 net/rds/ib_fmr.c
> > 
> Patch looks accurate to me Jason/Max. I wanted to get few regression
> tests run with it before providing the ack. Will send a note once
> its tested ok.

Okay, since we are at the merge window I'm going to put it in
linux-next to look for build regressions with the idea to send it on
Thursday

Thanks,
Jason
