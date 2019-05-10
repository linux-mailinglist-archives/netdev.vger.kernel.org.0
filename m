Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F6551A405
	for <lists+netdev@lfdr.de>; Fri, 10 May 2019 22:39:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727897AbfEJUj0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 May 2019 16:39:26 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:34922 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727676AbfEJUjZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 May 2019 16:39:25 -0400
Received: by mail-qk1-f194.google.com with SMTP id c15so4539965qkl.2
        for <netdev@vger.kernel.org>; Fri, 10 May 2019 13:39:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=axTtub+WGA/3tmTmM2EJ5+eFzFN20uhxBzvkh4rf/6c=;
        b=TQPRYwZb33bpQWd3EodPWrWvvPAUplZ+e8iPAAplbSEHEuLUe/Wh696KVb1jUcj+Xu
         0xfdX7x7aFMSTz7rLuKoEbdHH0ER5yif9yoNC2mF09TEgbDGXPW61ehcPV1CJilbEpIZ
         E9EDwi6kEFCDRLUecT5cVu7BKFJ8Ozs/pm1jxFxjjUPH9lB3iNCqMregj/KpiFiRzWjx
         HWiP2uU2yv6jAwTfIWXd/ANsVHwlAPA6SVuNqC+TADp+6+ThqFDANbyVLZR+gxStYQJh
         KESpJRtwDUqEmKASR47K7pz5D8lXzXtMxSls+LSB8OZ9ez4edZwzXm8cWZxAN+DX90so
         Rsvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=axTtub+WGA/3tmTmM2EJ5+eFzFN20uhxBzvkh4rf/6c=;
        b=SQ8EioH5Owhxyah9xwrXM+3kSnvVJ6KhXYJE3R5d1qh8tf9QwTR12dBHTpIlUGWf2e
         ngewX1peVBvnFrLQUsvZ6OnXsyIueEGZx12osRISW3rHLYgubsHBmQ4Dcy3F4N3vTM50
         Bfjj579i6J7qYe/+D9yKhctnywoq/sFD2cpZXyTfyQvjfmOkilISqj8vIcXne+jlFuQL
         D0qGW35TaJZLGc+DT5uP9vM1F4a7/kaIB51wxK/Wrj+Mg8G4s/dXEmuMccQT7WxlOyFt
         YNsjnV6Jljv8SPy1jdbLa6lTGw+ZwP6i0kcJKbJPTOqge6Y7jch5xKJmI/818B2JuqPk
         DzWg==
X-Gm-Message-State: APjAAAWKae0/p2SO9pSoJKKU3SMRAcztnuvTkbdp9B5YARuFrOsIGDxf
        r5AT4GfcaIE15DyT8f+NXsvXHQ==
X-Google-Smtp-Source: APXvYqzBbCg+qPGUy3Acl2+Wa3shta/hs29nsehBn1as2LwBcq1HK7SXl8bPwxgB7yhcHxvwOrxG+g==
X-Received: by 2002:a37:9587:: with SMTP id x129mr11035799qkd.9.1557520764385;
        Fri, 10 May 2019 13:39:24 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-156-34-49-251.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.49.251])
        by smtp.gmail.com with ESMTPSA id y14sm3839716qth.48.2019.05.10.13.39.22
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 10 May 2019 13:39:23 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1hPCIc-0001Qq-Du; Fri, 10 May 2019 17:39:22 -0300
Date:   Fri, 10 May 2019 17:39:22 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Santosh Shilimkar <santosh.shilimkar@oracle.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        Hans Westgaard Ry <hans.westgaard.ry@oracle.com>
Subject: Re: [net-next][PATCH v2 1/2] rds: handle unsupported rdma request to
 fs dax memory
Message-ID: <20190510203922.GJ13038@ziepe.ca>
References: <20190510125431.GA15434@ziepe.ca>
 <8b00b41c-bbc5-7584-e5cf-519b0d9100c5@oracle.com>
 <20190510175538.GB13038@ziepe.ca>
 <9b0e6760-b684-c1ce-6bf5-738eff325240@oracle.com>
 <20190510180719.GD13038@ziepe.ca>
 <d25910f3-51f1-9214-3479-150b1d320e43@oracle.com>
 <20190510192046.GH13038@ziepe.ca>
 <2c16b35d-c20c-e51d-5d4e-0904c740a4ec@oracle.com>
 <20190510194753.GI13038@ziepe.ca>
 <bb3d7aa4-e400-1b2f-dfd0-2b711816ee53@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bb3d7aa4-e400-1b2f-dfd0-2b711816ee53@oracle.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 10, 2019 at 01:12:49PM -0700, Santosh Shilimkar wrote:
> On 5/10/2019 12:47 PM, Jason Gunthorpe wrote:
> > On Fri, May 10, 2019 at 12:38:31PM -0700, Santosh Shilimkar wrote:
> > > On 5/10/2019 12:20 PM, Jason Gunthorpe wrote:
> > > > On Fri, May 10, 2019 at 11:58:42AM -0700, santosh.shilimkar@oracle.com wrote:
> > > > > On 5/10/19 11:07 AM, Jason Gunthorpe wrote:
> > > > > > On Fri, May 10, 2019 at 11:02:35AM -0700, santosh.shilimkar@oracle.com wrote:
> > > 
> > > [...]
> > > 
> > > > > > Why would you need to detect FS DAX memory? GUP users are not supposed
> > > > > > to care.
> > > > > > 
> > > > > > GUP is supposed to work just 'fine' - other than the usual bugs we
> > > > > > have with GUP and any FS backed memory.
> > > > > > 
> > > > > Am not saying there is any issue with GUP. Let me try to explain the
> > > > > issue first. You are aware of various discussions about doing DMA
> > > > > or RDMA on FS DAX memory. e.g [1] [2] [3]
> > > > > 
> > > > > One of the proposal to do safely RDMA on FS DAX memory is/was ODP
> > > > 
> > > > It is not about safety. ODP is required in all places that would have
> > > > used gup_longterm because ODP avoids th gup_longterm entirely.
> > > > 
> > > > > Currently RDS doesn't have support for ODP MR registration
> > > > > and hence we don't want user application to do RDMA using
> > > > > fastreg/fmr on FS DAX memory which isn't safe.
> > > > 
> > > > No, it is safe.
> > > > 
> > > > The only issue is you need to determine if this use of GUP is longterm
> > > > or short term. Longterm means userspace is in control of how long the
> > > > GUP lasts, short term means the kernel is in control.
> > > > 
> > > > ie posting a fastreg, sending the data, then un-GUP'ing on completion
> > > > is a short term GUP and it is fine on any type of memory.
> > > > 
> > > > So if it is a long term pin then it needs to be corrected and the only
> > > > thing the comment needs to explain is that it is a long term pin.
> > > > 
> > > Thanks for clarification. At least the distinction is clear to me now. Yes
> > > the key can be valid for long term till the remote RDMA IO is issued and
> > > finished. After that user can issue an invalidate/free key or
> > > upfront specify a flag to free/invalidate the key on remote IO
> > > completion.
> > 
> > Again, the test is if *userspace* controls this. So if userspace is
> > the thing that does the invalidate/free then it is long term. Sounds
> > like if it specifies the free/invalidate flag then it short term.
> > 
> > At this point you'd probably be better to keep both options.
> > 
> Thats possible using the provided flag state but I am still not sure
> whether its guaranteed to be safe when marked as short term even with
> flag which tells kernel to invalidate/free the MR on remote IO
> completion. Till the remote server finishes the IO, 

This is fine.

> there is still a window where userspace on local server can modify
> the file mappings. Registered file handle say was ftuncated to zero
> by another process and the backing memory was allocated by some
> other process as part of fallocate.  

The FS is supposed to maintain sane semantics across GUP - fallocate
should block until GUP is done. This is normal.

> How do we avoid such an issue without GUP_longterm ?

You don't, there is no problem using GUP for short term - ie a time
frame entirely under control of the kernel.

Jason
