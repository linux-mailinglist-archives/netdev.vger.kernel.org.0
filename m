Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E6931A2B6
	for <lists+netdev@lfdr.de>; Fri, 10 May 2019 19:55:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727709AbfEJRzl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 May 2019 13:55:41 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:36709 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727562AbfEJRzl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 May 2019 13:55:41 -0400
Received: by mail-qk1-f194.google.com with SMTP id c14so4224965qke.3
        for <netdev@vger.kernel.org>; Fri, 10 May 2019 10:55:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=Pjc7l4cVahv8WsgQQ1dlgXdKB0M3SKzEnmMux5cswH8=;
        b=oWcIecvHXeseYAEw32+WyP3f9E41xvVl2Wzdh9O/MAxPmTaIqAmXw3eUsFIKO0M7tA
         yn/PgBGtN2kEYoInMv7mDnUTfLjHq/6Us4x0OJYnQHvBMpdQoyRxgi2v668P9P57uORt
         cWrL7bNUlDVXVuSqCCworXQRXUTrLeaFFG86AgDuOM845amDN5c8ec10jyTPpMffXKtb
         8C6OHTVGInxsXAOV7DjloBRcUUx079iSGRwOIqtxiIntptze+f9FHZb536niv3cfenRH
         7mP2cwkbrVfm178I85RGRfsEv4M/Rd8jlFbmtAlQuzme2KRbVE62wYIOuhcsq8v0dwK4
         E56A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=Pjc7l4cVahv8WsgQQ1dlgXdKB0M3SKzEnmMux5cswH8=;
        b=sChG7lxv539LNSV+OaRzFjIXOrv9mTItA2AoQKeZNTLTXJ4T4XHWs3SdYAApcAJH73
         Vi8x1b//SXGWR7wliBLfcZxj/tyDH62OwqBYgrfM3OC3B5WEhVf8PjWAq0yg+EtymRjw
         uYi0araUGMh4Ugc0vzVBIdd3TiS1Akz8dZrUjQsps3GpTSQb6sggn6MyP5hsQFDo4cSu
         MTonY2PNnqd1B+lkSU9tFmgwyLlcygXGtF6iRdPX6ylFPZvqyUumd+UeNqSftlpilib5
         fdIV0y6iOFA9WPnTAvoWjL0P66PnYVeTLXicIT0cBliMkk3/ISUHD6CdWxSkbzhFlrNq
         7n+w==
X-Gm-Message-State: APjAAAUERJWSjdV+y9EOB2AjwnHztnONhDmm0TWPEFVttWuXXnlCTsYU
        Pbt9mzKkMOACEDszMjjsxgBA8w==
X-Google-Smtp-Source: APXvYqyqeFpVF40xdtSrt/lEUs78Yj8gqjHRGrDAU6A2yLchu7mgWpBWc4Z5ZzuLvg3OZ46Vv/sKBg==
X-Received: by 2002:a05:620a:13c9:: with SMTP id g9mr9647730qkl.307.1557510940573;
        Fri, 10 May 2019 10:55:40 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-156-34-49-251.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.49.251])
        by smtp.gmail.com with ESMTPSA id d41sm3679482qta.22.2019.05.10.10.55.38
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 10 May 2019 10:55:39 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1hP9kA-0006Y9-Gw; Fri, 10 May 2019 14:55:38 -0300
Date:   Fri, 10 May 2019 14:55:38 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Santosh Shilimkar <santosh.shilimkar@oracle.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        Hans Westgaard Ry <hans.westgaard.ry@oracle.com>
Subject: Re: [net-next][PATCH v2 1/2] rds: handle unsupported rdma request to
 fs dax memory
Message-ID: <20190510175538.GB13038@ziepe.ca>
References: <1556581040-4812-1-git-send-email-santosh.shilimkar@oracle.com>
 <1556581040-4812-2-git-send-email-santosh.shilimkar@oracle.com>
 <20190510125431.GA15434@ziepe.ca>
 <8b00b41c-bbc5-7584-e5cf-519b0d9100c5@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8b00b41c-bbc5-7584-e5cf-519b0d9100c5@oracle.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 10, 2019 at 09:11:24AM -0700, Santosh Shilimkar wrote:
> On 5/10/2019 5:54 AM, Jason Gunthorpe wrote:
> > On Mon, Apr 29, 2019 at 04:37:19PM -0700, Santosh Shilimkar wrote:
> > > From: Hans Westgaard Ry <hans.westgaard.ry@oracle.com>
> > > 
> > > RDS doesn't support RDMA on memory apertures that require On Demand
> > > Paging (ODP), such as FS DAX memory. User applications can try to use
> > > RDS to perform RDMA over such memories and since it doesn't report any
> > > failure, it can lead to unexpected issues like memory corruption when
> > > a couple of out of sync file system operations like ftruncate etc. are
> > > performed.
> > 
> > This comment doesn't make any sense..
> > 
> > > The patch adds a check so that such an attempt to RDMA to/from memory
> > > apertures requiring ODP will fail.
> > > 
> > > Reviewed-by: Håkon Bugge <haakon.bugge@oracle.com>
> > > Reviewed-tested-by: Zhu Yanjun <yanjun.zhu@oracle.com>
> > > Signed-off-by: Hans Westgaard Ry <hans.westgaard.ry@oracle.com>
> > > Signed-off-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>
> > >   net/rds/rdma.c | 5 +++--
> > >   1 file changed, 3 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/net/rds/rdma.c b/net/rds/rdma.c
> > > index 182ab84..e0a6b72 100644
> > > +++ b/net/rds/rdma.c
> > > @@ -158,8 +158,9 @@ static int rds_pin_pages(unsigned long user_addr, unsigned int nr_pages,
> > >   {
> > >   	int ret;
> > > -	ret = get_user_pages_fast(user_addr, nr_pages, write, pages);
> > > -
> > > +	/* get_user_pages return -EOPNOTSUPP for fs_dax memory */
> > > +	ret = get_user_pages_longterm(user_addr, nr_pages,
> > > +				      write, pages, NULL);
> > 
> > GUP is supposed to fully work on DAX filesystems.
> > 
> Above comment has typo. Should have been
> get_user_pages_longterm return -EOPNOTSUPP.
> 
> > You only need to switch to the long term version if the duration of
> > the GUP is under control of user space - ie it may last forever.
> > 
> > Short duration pins in the kernel do not need long term.
> > 
> Thats true but the intention here is to use the long term version
> which does check for the FS DAX memory. Instead of calling direct
> accessor to check DAX memory region, longterm version of the API
> is used
> 
> > At a minimum the commit message needs re-writing to properly explain
> > the motivation here.
> > 
> Commit is actually trying to describe the motivation describing more of
> issues of not making the call fail. The code comment typo was
> misleading.

Every single sentence in the commit message is wrong

Jason
