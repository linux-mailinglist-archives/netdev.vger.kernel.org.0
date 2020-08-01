Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3E2E2350B2
	for <lists+netdev@lfdr.de>; Sat,  1 Aug 2020 07:38:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726889AbgHAFii (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Aug 2020 01:38:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:40250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725497AbgHAFii (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 1 Aug 2020 01:38:38 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 30581206E9;
        Sat,  1 Aug 2020 05:38:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596260317;
        bh=lGpwK1KfpscxUqahcA06uhD573mu3C8E7CKIwtqzqVI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BJmM0f1UXvY+GZiG48xH1hniSbfQOjEcu2PZGU6M97JyZ9pegPUHZKTk0KCCtUwV8
         6C3nkXPO9Tq7cb2m+M/aZyM0uGv5FT3niWUayWOm6zuJrVhiXfYMlQEvp8Scf76dP7
         ycWYDTIg4oIUopWDINNKCuCrNPcQaJCMnZX+djFQ=
Date:   Sat, 1 Aug 2020 08:38:33 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Jason Gunthorpe <jgg@ziepe.ca>, Peilin Ye <yepeilin.cs@gmail.com>,
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
Message-ID: <20200801053833.GK75549@unreal>
References: <20200730192026.110246-1-yepeilin.cs@gmail.com>
 <20200731045301.GI75549@unreal>
 <20200731053306.GA466103@kroah.com>
 <20200731053333.GB466103@kroah.com>
 <20200731140452.GE24045@ziepe.ca>
 <20200731142148.GA1718799@kroah.com>
 <20200731143604.GF24045@ziepe.ca>
 <20200731171924.GA2014207@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200731171924.GA2014207@kroah.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 31, 2020 at 07:19:24PM +0200, Greg Kroah-Hartman wrote:
> On Fri, Jul 31, 2020 at 11:36:04AM -0300, Jason Gunthorpe wrote:
> > On Fri, Jul 31, 2020 at 04:21:48PM +0200, Greg Kroah-Hartman wrote:
> >
> > > > The spec was updated in C11 to require zero'ing padding when doing
> > > > partial initialization of aggregates (eg = {})
> > > >
> > > > """if it is an aggregate, every member is initialized (recursively)
> > > > according to these rules, and any padding is initialized to zero
> > > > bits;"""
> > >
> > > But then why does the compilers not do this?
> >
> > Do you have an example?
>
> At the moment, no, but we have had them in the past due to security
> issues we have had to fix for this.

Is it still relevant after bump of required GCC version to build kernel?

I afraid that without solid example such changes will start to be
treated with cargo cult.

Jason,

I'm using {} instead of {0} because of this GCC bug.
https://gcc.gnu.org/bugzilla/show_bug.cgi?id=53119

Thanks
