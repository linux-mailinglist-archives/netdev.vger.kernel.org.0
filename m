Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88FE542AA54
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 19:10:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232063AbhJLRMb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 13:12:31 -0400
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:38807 "EHLO
        relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbhJLRMa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Oct 2021 13:12:30 -0400
Received: (Authenticated sender: ralf@linux-mips.org)
        by relay5-d.mail.gandi.net (Postfix) with ESMTPSA id 828931C0010;
        Tue, 12 Oct 2021 17:10:25 +0000 (UTC)
Date:   Tue, 12 Oct 2021 19:10:23 +0200
From:   Ralf Baechle <ralf@linux-mips.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Osterried <thomas@osterried.de>,
        linux-hams@vger.kernel.org
Subject: Re: [PATCH] ax25: Fix use of copy_from_sockptr() in ax25_setsockopt()
Message-ID: <YWXBfx77qrbFzLAf@linux-mips.org>
References: <YVXkwzKZhPoD0Ods@linux-mips.org>
 <20211012062309.GD17407@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211012062309.GD17407@lst.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 12, 2021 at 08:23:09AM +0200, Christoph Hellwig wrote:

> On Thu, Sep 30, 2021 at 06:24:35PM +0200, Ralf Baechle wrote:
> > The destination pointer passed to copy_from_sockptr() is an unsigned long *
> > but the source in userspace is an unsigned int * resulting in an integer
> > of the wrong size being copied from userspace.
> > 
> > This happens to work on 32 bit but breaks 64-bit where bytes 4..7 will not
> > be initialized.  By luck it may work on little endian but on big endian
> > where the userspace data is copied to the upper 32 bit of the destination
> > it's most likely going to break.
> > 
> > A simple test case to demonstrate this setsockopt() issue is:
> 
> Looks good,
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Sadly the kernel test robot has raised a bunch of warnings in this patch.
To fix those I'll pull a few fixes from another patch I was planning to
send later and merge them into this patch and post the resulting patch
as v2.

Thanks for the review,

  Ralf
