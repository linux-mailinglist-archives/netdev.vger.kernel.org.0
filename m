Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F9E1295539
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 01:39:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2507162AbgJUXjd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Oct 2020 19:39:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2439511AbgJUXjc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Oct 2020 19:39:32 -0400
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [IPv6:2002:c35c:fd02::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86217C0613CE;
        Wed, 21 Oct 2020 16:39:31 -0700 (PDT)
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kVNhK-005pSF-DC; Wed, 21 Oct 2020 23:39:14 +0000
Date:   Thu, 22 Oct 2020 00:39:14 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Christoph Hellwig <hch@lst.de>, kernel-team@android.com,
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
Subject: Re: Buggy commit tracked to: "Re: [PATCH 2/9] iov_iter: move
 rw_copy_check_uvector() into lib/iov_iter.c"
Message-ID: <20201021233914.GR3576660@ZenIV.linux.org.uk>
References: <20200925045146.1283714-1-hch@lst.de>
 <20200925045146.1283714-3-hch@lst.de>
 <20201021161301.GA1196312@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201021161301.GA1196312@kroah.com>
Sender: Al Viro <viro@ftp.linux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 21, 2020 at 06:13:01PM +0200, Greg KH wrote:
> On Fri, Sep 25, 2020 at 06:51:39AM +0200, Christoph Hellwig wrote:
> > From: David Laight <David.Laight@ACULAB.COM>
> > 
> > This lets the compiler inline it into import_iovec() generating
> > much better code.
> > 
> > Signed-off-by: David Laight <david.laight@aculab.com>
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > ---
> >  fs/read_write.c | 179 ------------------------------------------------
> >  lib/iov_iter.c  | 176 +++++++++++++++++++++++++++++++++++++++++++++++
> >  2 files changed, 176 insertions(+), 179 deletions(-)
> 
> Strangely, this commit causes a regression in Linus's tree right now.
> 
> I can't really figure out what the regression is, only that this commit
> triggers a "large Android system binary" from working properly.  There's
> no kernel log messages anywhere, and I don't have any way to strace the
> thing in the testing framework, so any hints that people can provide
> would be most appreciated.

It's a pure move - modulo changed line breaks in the argument lists
the functions involved are identical before and after that (just checked
that directly, by checking out the trees before and after, extracting two
functions in question from fs/read_write.c and lib/iov_iter.c (before and
after, resp.) and checking the diff between those.

How certain is your bisection?
