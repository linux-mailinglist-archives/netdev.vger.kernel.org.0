Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B92711345
	for <lists+netdev@lfdr.de>; Thu,  2 May 2019 08:18:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726231AbfEBGSF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 May 2019 02:18:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:51646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726202AbfEBGSF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 May 2019 02:18:05 -0400
Received: from localhost (unknown [37.142.3.125])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D1CC42085A;
        Thu,  2 May 2019 06:18:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556777884;
        bh=XXaTpMTC9nZg6UM+aFyb7QneNlScezsgXqar1ar7ohs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dfeSjGR6puxpygJv9D51wnnPZiK4wDMVqUtRB1rQdDRyvrVQPkZTA2DMIZ2Tz4GVw
         CU7tXZdnd6xqSabbxDnXd0YsA4ztxlf1kPh4VEbWE/hMDQs3Evb0WjFemcK9EE+dHv
         UeGXXOfyyXRHfB7hzxejOWAcobMBOEb/jsHB8vk8=
Date:   Thu, 2 May 2019 09:18:00 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Santosh Shilimkar <santosh.shilimkar@oracle.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
Subject: Re: [net-next][PATCH v2 2/2] rds: add sysctl for rds support of
 On-Demand-Paging
Message-ID: <20190502061800.GL7676@mtr-leonro.mtl.com>
References: <1556581040-4812-1-git-send-email-santosh.shilimkar@oracle.com>
 <1556581040-4812-3-git-send-email-santosh.shilimkar@oracle.com>
 <20190501074500.GC7676@mtr-leonro.mtl.com>
 <81e6e4c1-a57c-0f66-75ad-90f75417cc4a@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <81e6e4c1-a57c-0f66-75ad-90f75417cc4a@oracle.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 01, 2019 at 10:54:50AM -0700, Santosh Shilimkar wrote:
> On 5/1/2019 12:45 AM, Leon Romanovsky wrote:
> > On Mon, Apr 29, 2019 at 04:37:20PM -0700, Santosh Shilimkar wrote:
> > > RDS doesn't support RDMA on memory apertures that require On Demand
> > > Paging (ODP), such as FS DAX memory. A sysctl is added to indicate
> > > whether RDMA requiring ODP is supported.
> > >
> > > Reviewed-by: Håkon Bugge <haakon.bugge@oracle.com>
> > > Reviewed-tested-by: Zhu Yanjun <yanjun.zhu@oracle.com>
> > > Signed-off-by: Hans Westgaard Ry <hans.westgaard.ry@oracle.com>
> > > Signed-off-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>
> > > ---
> > >   net/rds/ib.h        | 1 +
> > >   net/rds/ib_sysctl.c | 8 ++++++++
> > >   2 files changed, 9 insertions(+)
> >
> > This sysctl is not needed at all
> >
> Its needed for application to check the support of the ODP support
> feature which in progress. Failing the RDS_GET_MR was just one path
> and we also support inline MR registration along with message request.
>
> Basically application runs on different kernel versions and to be
> portable, it will check if underneath RDS support ODP and then only
> use RDMA. If not it will fallback to buffer copy mode. Hope
> it clarifies.

Using ODP sysctl to determine if to use RDMA or not, looks like very
problematic approach. How old applications will work in such case
without knowledge of such sysctl?
How new applications will distinguish between ODP is not supported, but
RDMA works?

Thanks

>
>
> Regards,
> Santosh
