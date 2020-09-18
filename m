Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99B7026FDA3
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 14:58:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726609AbgIRM4T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 08:56:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726064AbgIRM4S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 08:56:18 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71A6EC06174A;
        Fri, 18 Sep 2020 05:56:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=zoOf0E5vEVvypLQZvTu3Qa4P//IZej+JhDzkQ4SZUbU=; b=Twr3txXoOUgAutBdzGyZB+lY1J
        jlGkbNw57ycQeyDICn1qQL9BIF49y+wvEY79YsJqm+klFYXfm0D4wJQy3SSrZuX4oN/X8scImOz1x
        iAvwhjjALzGEztMeZqVmVcGLW9G+To4auxoqyNMS/2NkqC80s33Ta7xmNuQV1rY8qKanIvXoGLe8B
        6fal0Zox8xpamGqpfYQasr4KUlD6H2FixgEIiyw2pdQ2ZDQlOzArXaJmv2bnI8JP8Jm2wf1+J0rcP
        pG1NLuH/an00oo9pw7YDidPu4WRCYUnv3lQPu2dFwfhtiUQ2ogaw+KlPq/67Y5JGwwImp7XdmncP5
        jHtexrUQ==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kJFvv-0001A7-Pu; Fri, 18 Sep 2020 12:56:11 +0000
Date:   Fri, 18 Sep 2020 13:56:11 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, Arnd Bergmann <arnd@arndb.de>,
        David Howells <dhowells@redhat.com>,
        linux-arm-kernel@lists.infradead.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-s390@vger.kernel.org, sparclinux@vger.kernel.org,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-aio@kvack.org,
        io-uring@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-mm@kvack.org, netdev@vger.kernel.org,
        keyrings@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH 3/9] fs: explicitly check for CHECK_IOVEC_ONLY in
 rw_copy_check_uvector
Message-ID: <20200918125611.GE32101@casper.infradead.org>
References: <20200918124533.3487701-1-hch@lst.de>
 <20200918124533.3487701-4-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200918124533.3487701-4-hch@lst.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 18, 2020 at 02:45:27PM +0200, Christoph Hellwig wrote:
>  		}
> -		if (type >= 0
> -		    && unlikely(!access_ok(buf, len))) {
> +		if (type != CHECK_IOVEC_ONLY && unlikely(!access_ok(buf, len))) {

drop the unlikely() at the same time?  if it's really advantageous,
that should be embedded in the access_ok macro.

