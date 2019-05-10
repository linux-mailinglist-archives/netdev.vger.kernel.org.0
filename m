Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A4A21A35F
	for <lists+netdev@lfdr.de>; Fri, 10 May 2019 21:20:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727740AbfEJTUt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 May 2019 15:20:49 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:46130 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727642AbfEJTUt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 May 2019 15:20:49 -0400
Received: by mail-qk1-f196.google.com with SMTP id a132so4292860qkb.13
        for <netdev@vger.kernel.org>; Fri, 10 May 2019 12:20:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=noOAVh6GTDLbpn+PHNAUrHLXzqD3eO/ls10iJbVAkpo=;
        b=dj1+JIEl3QtKbrJ7jtUU2EnDYV0X/LXgwapNzimsYr2/fQQ6TaY8Nk5ksG9dVuYqDv
         n90rBP8HfwUq8qsCv+nb/XVf3YdF4uQyc4n6ueKCos/LZvUuovkAYqcapJiyS0u22h2Z
         7/p6AbU++CT+c5bgHt21z9uu4FNsREGdMmCAH0TGE9tvrDPJ7xX4m2WQOrp6gRCGtJim
         +EW+ijsII+FZCyH2XNDiEe0URfdZD+PKoZW+thPaXTgRkcAiYXHuIwHp87UMo3vq+Pux
         MTxpwtJLXnrCGHEyt9v+zXOaCEYHR/sG9ZBHz8sFxtUaUZVITCD5vdWG8DjT8RkmVm2V
         voFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=noOAVh6GTDLbpn+PHNAUrHLXzqD3eO/ls10iJbVAkpo=;
        b=F6VA8X/W58lfB0ldpz5XcKdOIcw4LSrdDnm3UUQRZsoio8qxlOPoj6FAtV7YdZaP7c
         t0q/ucf3rU9lmOzBnyvD4UiOadnFvVqMQugH6CWt62XOFDDExNSIC1laKyyvje/8GA1B
         g2hiUfgc4yG1ofURAR0qr29Y2+qj5BOQrI6i/HIHxKjcregnMQazE4Yw0tuszGxhWVLI
         i7x+cVe7ytH+s/xIp+hmCGN3ABYeGaV3g3zva9Vw84eCL/h/ms+fVTyRK57+gWCWWi5d
         T15UpgIq5Le6LaNa1gSgn4e89rv5mMgrYl3s3D4ZMCFxGBDkCERv60CkVkNHsA6QYEul
         Vdyg==
X-Gm-Message-State: APjAAAU/ZPo/p6Z91fUpZJ0gg+HyJmad+R9tV9O8DcXThyNvXtiSfB9N
        mH7LtL1mJprVEU0Am1VynG6lCw==
X-Google-Smtp-Source: APXvYqyylLuSXXUSQDqzrpX1Lup3mYNoL+iV54w2UW33DQYLaZ0w4ZWjqJ0NWMfp6MZ9IXlZKL1Tag==
X-Received: by 2002:a05:620a:16b4:: with SMTP id s20mr10579334qkj.34.1557516047775;
        Fri, 10 May 2019 12:20:47 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-156-34-49-251.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.49.251])
        by smtp.gmail.com with ESMTPSA id u15sm3519076qth.54.2019.05.10.12.20.47
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 10 May 2019 12:20:47 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1hPB4Y-0004bH-Nr; Fri, 10 May 2019 16:20:46 -0300
Date:   Fri, 10 May 2019 16:20:46 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     "santosh.shilimkar@oracle.com" <santosh.shilimkar@oracle.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        Hans Westgaard Ry <hans.westgaard.ry@oracle.com>
Subject: Re: [net-next][PATCH v2 1/2] rds: handle unsupported rdma request to
 fs dax memory
Message-ID: <20190510192046.GH13038@ziepe.ca>
References: <1556581040-4812-1-git-send-email-santosh.shilimkar@oracle.com>
 <1556581040-4812-2-git-send-email-santosh.shilimkar@oracle.com>
 <20190510125431.GA15434@ziepe.ca>
 <8b00b41c-bbc5-7584-e5cf-519b0d9100c5@oracle.com>
 <20190510175538.GB13038@ziepe.ca>
 <9b0e6760-b684-c1ce-6bf5-738eff325240@oracle.com>
 <20190510180719.GD13038@ziepe.ca>
 <d25910f3-51f1-9214-3479-150b1d320e43@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d25910f3-51f1-9214-3479-150b1d320e43@oracle.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 10, 2019 at 11:58:42AM -0700, santosh.shilimkar@oracle.com wrote:
> On 5/10/19 11:07 AM, Jason Gunthorpe wrote:
> > On Fri, May 10, 2019 at 11:02:35AM -0700, santosh.shilimkar@oracle.com wrote:
> > > 
> > > 
> > > On 5/10/19 10:55 AM, Jason Gunthorpe wrote:
> > > > On Fri, May 10, 2019 at 09:11:24AM -0700, Santosh Shilimkar wrote:
> > > > > On 5/10/2019 5:54 AM, Jason Gunthorpe wrote:
> > > > > > On Mon, Apr 29, 2019 at 04:37:19PM -0700, Santosh Shilimkar wrote:
> > > > > > > From: Hans Westgaard Ry <hans.westgaard.ry@oracle.com>
> > > > > > > 
> > > > > > > RDS doesn't support RDMA on memory apertures that require On Demand
> > > > > > > Paging (ODP), such as FS DAX memory. User applications can try to use
> > > > > > > RDS to perform RDMA over such memories and since it doesn't report any
> > > > > > > failure, it can lead to unexpected issues like memory corruption when
> > > > > > > a couple of out of sync file system operations like ftruncate etc. are
> > > > > > > performed.
> > > > > > 
> > > > > > This comment doesn't make any sense..
> > > > > > 
> > > > > > > The patch adds a check so that such an attempt to RDMA to/from memory
> > > > > > > apertures requiring ODP will fail.
> > > > > > > 
> > > > > > > Reviewed-by: Håkon Bugge <haakon.bugge@oracle.com>
> > > > > > > Reviewed-tested-by: Zhu Yanjun <yanjun.zhu@oracle.com>
> > > > > > > Signed-off-by: Hans Westgaard Ry <hans.westgaard.ry@oracle.com>
> > > > > > > Signed-off-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>
> > > > > > >     net/rds/rdma.c | 5 +++--
> > > > > > >     1 file changed, 3 insertions(+), 2 deletions(-)
> > > > > > > 
> [...]
> 
> > 
> > Why would you need to detect FS DAX memory? GUP users are not supposed
> > to care.
> > 
> > GUP is supposed to work just 'fine' - other than the usual bugs we
> > have with GUP and any FS backed memory.
> > 
> Am not saying there is any issue with GUP. Let me try to explain the
> issue first. You are aware of various discussions about doing DMA
> or RDMA on FS DAX memory. e.g [1] [2] [3]
> 
> One of the proposal to do safely RDMA on FS DAX memory is/was ODP

It is not about safety. ODP is required in all places that would have
used gup_longterm because ODP avoids th gup_longterm entirely.

> Currently RDS doesn't have support for ODP MR registration
> and hence we don't want user application to do RDMA using
> fastreg/fmr on FS DAX memory which isn't safe.

No, it is safe.

The only issue is you need to determine if this use of GUP is longterm
or short term. Longterm means userspace is in control of how long the
GUP lasts, short term means the kernel is in control.

ie posting a fastreg, sending the data, then un-GUP'ing on completion
is a short term GUP and it is fine on any type of memory.

So if it is a long term pin then it needs to be corrected and the only
thing the comment needs to explain is that it is a long term pin.

Jason
