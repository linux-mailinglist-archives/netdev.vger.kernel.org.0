Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CC3C365501
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 11:11:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231328AbhDTJMU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 05:12:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:54646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231231AbhDTJMS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Apr 2021 05:12:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 62F83600EF;
        Tue, 20 Apr 2021 09:11:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618909907;
        bh=AbCLPgWtB15dlO8E6CVD1vybO1ZDjPyfjpbux3ATgTk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AYSlSeZJC47nese3DFnk+MX87q/P4K3UjBdAXawoSaPVrwtScj4Alb/yFuV6SiIAQ
         7aWYhIPxUeGUdMEwW0KREgEezCrWsHpnrQGfjJLX5wUAtvVE61vwl0zK88JfUbwlgW
         bKogLPlI6F9l35ahrqoiHVPLxcNmeYZD+RPZYeT1hvq8l/f2bKfDSGmI3irl2VNOn6
         Y4VxNpS/JCgMBu5tcQCGhjQXWH4zIj/uec2VHDF6ycP3wAXhqM6wmmNKPyS1y7gxR/
         47hrq7xaW4lebBsf8hAn/mYt5Pw7fVylPpoO5r13jYnqcjB8Sh6ArlGJEmd0GXzIld
         yFLk7LFI0nMcA==
Date:   Tue, 20 Apr 2021 12:11:43 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Aditya Pakki <pakki001@umn.edu>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        rds-devel@oss.oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/rds: Avoid potential use after free in
 rds_send_remove_from_sock
Message-ID: <YH6azwtJXIyebCnc@unreal>
References: <20210407000913.2207831-1-pakki001@umn.edu>
 <YH6aMsbqruMZiWFe@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YH6aMsbqruMZiWFe@unreal>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 20, 2021 at 12:09:06PM +0300, Leon Romanovsky wrote:
> On Tue, Apr 06, 2021 at 07:09:12PM -0500, Aditya Pakki wrote:
> > In case of rs failure in rds_send_remove_from_sock(), the 'rm' resource
> > is freed and later under spinlock, causing potential use-after-free.
> > Set the free pointer to NULL to avoid undefined behavior.
> > 
> > Signed-off-by: Aditya Pakki <pakki001@umn.edu>
> > ---
> >  net/rds/message.c | 1 +
> >  net/rds/send.c    | 2 +-
> >  2 files changed, 2 insertions(+), 1 deletion(-)
> 
> Dave, Jakub
> 
> Please revert this patch, given responses from Eric and Al together
> with this response from Greg here https://lore.kernel.org/lkml/YH5/i7OvsjSmqADv@kroah.com

https://lore.kernel.org/lkml/YH5%2Fi7OvsjSmqADv@kroah.com/

> 
> BTW, I looked on the rds code too and agree with Eric, this patch
> is a total garbage.
> 
> Thanks
