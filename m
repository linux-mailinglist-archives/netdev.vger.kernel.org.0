Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B5C0295081
	for <lists+netdev@lfdr.de>; Wed, 21 Oct 2020 18:13:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502895AbgJUQMZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Oct 2020 12:12:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:56946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502871AbgJUQMX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Oct 2020 12:12:23 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 77C932087D;
        Wed, 21 Oct 2020 16:12:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603296742;
        bh=Skv4VHOsxkbjExqgUALTljS6pv/j0ztelpvS9+0CtRw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SY2cnni/yKiqNX2D+MolwtBJkJZ25el2hwQIqa11SFtDmBTq22ksfzgjhnYpbguzD
         uBJI7QL3KluS3eIdXrPW4GsEYXfXh8wZGwW2M5LAz2S2HyPezXFwhGB9FXwsuwf6Qg
         XKD6E/hfwsCovIhfz5qaKfu2Q5NHx6cNpzquq6Po=
Date:   Wed, 21 Oct 2020 18:13:01 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Christoph Hellwig <hch@lst.de>, kernel-team@android.com
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, Arnd Bergmann <arnd@arndb.de>,
        David Howells <dhowells@redhat.com>,
        David Laight <David.Laight@aculab.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org,
        sparclinux@vger.kernel.org, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-aio@kvack.org, io-uring@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-mm@kvack.org,
        netdev@vger.kernel.org, keyrings@vger.kernel.org,
        linux-security-module@vger.kernel.org
Subject: Buggy commit tracked to: "Re: [PATCH 2/9] iov_iter: move
 rw_copy_check_uvector() into lib/iov_iter.c"
Message-ID: <20201021161301.GA1196312@kroah.com>
References: <20200925045146.1283714-1-hch@lst.de>
 <20200925045146.1283714-3-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200925045146.1283714-3-hch@lst.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 25, 2020 at 06:51:39AM +0200, Christoph Hellwig wrote:
> From: David Laight <David.Laight@ACULAB.COM>
> 
> This lets the compiler inline it into import_iovec() generating
> much better code.
> 
> Signed-off-by: David Laight <david.laight@aculab.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/read_write.c | 179 ------------------------------------------------
>  lib/iov_iter.c  | 176 +++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 176 insertions(+), 179 deletions(-)

Strangely, this commit causes a regression in Linus's tree right now.

I can't really figure out what the regression is, only that this commit
triggers a "large Android system binary" from working properly.  There's
no kernel log messages anywhere, and I don't have any way to strace the
thing in the testing framework, so any hints that people can provide
would be most appreciated.

thanks,

greg k-h
