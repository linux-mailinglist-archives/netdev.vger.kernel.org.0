Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6AA2A1A2D6
	for <lists+netdev@lfdr.de>; Fri, 10 May 2019 20:07:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728036AbfEJSHW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 May 2019 14:07:22 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:35802 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727779AbfEJSHW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 May 2019 14:07:22 -0400
Received: by mail-qt1-f193.google.com with SMTP id a39so6835760qtk.2
        for <netdev@vger.kernel.org>; Fri, 10 May 2019 11:07:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=X/4y1jS1oSBgiWhjuLYHKyiWM8RRDmAINybSXZW9arw=;
        b=EDj4e/eZ19E2scbuYKA3cEoxxI00S4Bsf7BMeJmE8hu+pwP1tFjSb92V0T6qmVf6mH
         ho0fkkUofH9chRGFxSJcgD64uq6igPibirJfx3zqkiMrzraOutmPY9S+iuyI+fQc1lvB
         FrsE3cfKzWo5xJYPJIZH3GwXS3n67Ly4qLXxreI7v1Q8BJHXkXEH103iu/5mT42egDov
         w6LCOMIo3ZNnRBYUbYZxujDH6RElXVCTuRrClNvsHFApCJPKy22f3mHBkhxQM1oQC1fO
         BmVa0JimkZH8uzKylKiOhey5Wmp100KvASnXV7NP6ljL8N+fH3rBDI6Zrs63if65AI0L
         NWfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=X/4y1jS1oSBgiWhjuLYHKyiWM8RRDmAINybSXZW9arw=;
        b=Mh3Oh6/Qhjo5Z+5Oz2rHlQM2SuULYIwTLCp1dCWBnXMhOYuTZi+C9LOcEhzNpp5yaF
         GEuRy9SX9gmrrAbcG9s84z/Ix1P/p4CvRT0ux2d4L1Se6d94BUZwtXxxEyuTe0k0DxcX
         2+oQmpayyjleenb0b0GUbDYkg9ePWu/JO5B/ebGDG1AYs0swmiLLZCR+CZvb+y8Gilt/
         H6ckygmn0Txi1sguWdIsslGhUOW9BHzzL8RYi7lf/MQUSdt/eSgokIMUO+f6eeMJtCin
         Omxs0wLbhqXUL+kohakHCMs2RyPM6gUWBkIDcAN21GOs0WMDJtOG2LLi+KMDlMa+B4vy
         PEkg==
X-Gm-Message-State: APjAAAUDuNg7gjFdcD4aULTKII6zf5M7hkTTbgnJA/UbXQAmXB/BDR4a
        KY++ZdFiA8oA/DYb6142MYZ/JQ==
X-Google-Smtp-Source: APXvYqwqzdtQ4kfZCb+uTmAa2XAh8/XNxzuHOsdldYXG5is5rRGc99q/I76WxYzPOxupInsO+UTYHg==
X-Received: by 2002:aed:2124:: with SMTP id 33mr10927329qtc.35.1557511640907;
        Fri, 10 May 2019 11:07:20 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-156-34-49-251.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.49.251])
        by smtp.gmail.com with ESMTPSA id r6sm3116546qkm.42.2019.05.10.11.07.20
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 10 May 2019 11:07:20 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1hP9vT-0006hn-NV; Fri, 10 May 2019 15:07:19 -0300
Date:   Fri, 10 May 2019 15:07:19 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     "santosh.shilimkar@oracle.com" <santosh.shilimkar@oracle.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        Hans Westgaard Ry <hans.westgaard.ry@oracle.com>
Subject: Re: [net-next][PATCH v2 1/2] rds: handle unsupported rdma request to
 fs dax memory
Message-ID: <20190510180719.GD13038@ziepe.ca>
References: <1556581040-4812-1-git-send-email-santosh.shilimkar@oracle.com>
 <1556581040-4812-2-git-send-email-santosh.shilimkar@oracle.com>
 <20190510125431.GA15434@ziepe.ca>
 <8b00b41c-bbc5-7584-e5cf-519b0d9100c5@oracle.com>
 <20190510175538.GB13038@ziepe.ca>
 <9b0e6760-b684-c1ce-6bf5-738eff325240@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9b0e6760-b684-c1ce-6bf5-738eff325240@oracle.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 10, 2019 at 11:02:35AM -0700, santosh.shilimkar@oracle.com wrote:
> 
> 
> On 5/10/19 10:55 AM, Jason Gunthorpe wrote:
> > On Fri, May 10, 2019 at 09:11:24AM -0700, Santosh Shilimkar wrote:
> > > On 5/10/2019 5:54 AM, Jason Gunthorpe wrote:
> > > > On Mon, Apr 29, 2019 at 04:37:19PM -0700, Santosh Shilimkar wrote:
> > > > > From: Hans Westgaard Ry <hans.westgaard.ry@oracle.com>
> > > > > 
> > > > > RDS doesn't support RDMA on memory apertures that require On Demand
> > > > > Paging (ODP), such as FS DAX memory. User applications can try to use
> > > > > RDS to perform RDMA over such memories and since it doesn't report any
> > > > > failure, it can lead to unexpected issues like memory corruption when
> > > > > a couple of out of sync file system operations like ftruncate etc. are
> > > > > performed.
> > > > 
> > > > This comment doesn't make any sense..
> > > > 
> > > > > The patch adds a check so that such an attempt to RDMA to/from memory
> > > > > apertures requiring ODP will fail.
> > > > > 
> > > > > Reviewed-by: Håkon Bugge <haakon.bugge@oracle.com>
> > > > > Reviewed-tested-by: Zhu Yanjun <yanjun.zhu@oracle.com>
> > > > > Signed-off-by: Hans Westgaard Ry <hans.westgaard.ry@oracle.com>
> > > > > Signed-off-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>
> > > > >    net/rds/rdma.c | 5 +++--
> > > > >    1 file changed, 3 insertions(+), 2 deletions(-)
> > > > > 
> > > > > diff --git a/net/rds/rdma.c b/net/rds/rdma.c
> > > > > index 182ab84..e0a6b72 100644
> > > > > +++ b/net/rds/rdma.c
> > > > > @@ -158,8 +158,9 @@ static int rds_pin_pages(unsigned long user_addr, unsigned int nr_pages,
> > > > >    {
> > > > >    	int ret;
> > > > > -	ret = get_user_pages_fast(user_addr, nr_pages, write, pages);
> > > > > -
> > > > > +	/* get_user_pages return -EOPNOTSUPP for fs_dax memory */
> > > > > +	ret = get_user_pages_longterm(user_addr, nr_pages,
> > > > > +				      write, pages, NULL);
> > > > 
> > > > GUP is supposed to fully work on DAX filesystems.
> > > > 
> > > Above comment has typo. Should have been
> > > get_user_pages_longterm return -EOPNOTSUPP.
> > > 
> > > > You only need to switch to the long term version if the duration of
> > > > the GUP is under control of user space - ie it may last forever.
> > > > 
> > > > Short duration pins in the kernel do not need long term.
> > > > 
> > > Thats true but the intention here is to use the long term version
> > > which does check for the FS DAX memory. Instead of calling direct
> > > accessor to check DAX memory region, longterm version of the API
> > > is used
> > > 
> > > > At a minimum the commit message needs re-writing to properly explain
> > > > the motivation here.
> > > > 
> > > Commit is actually trying to describe the motivation describing more of
> > > issues of not making the call fail. The code comment typo was
> > > misleading.
> > 
> > Every single sentence in the commit message is wrong
> > 
> I will rewrite commit message but can you please comment on other
> questions above. GUP long term was used to detect whether its
> fs_dax memory which could be misleading since the RDS MRs are
> short lived. Do you want us to use accessor instead to check
> if its FS DAX memory?

Why would you need to detect FS DAX memory? GUP users are not supposed
to care.

GUP is supposed to work just 'fine' - other than the usual bugs we
have with GUP and any FS backed memory.

Jason
