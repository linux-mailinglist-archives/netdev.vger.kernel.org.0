Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 322E52726B0
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 16:10:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727343AbgIUOKx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 10:10:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726419AbgIUOKx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 10:10:53 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4347EC061755;
        Mon, 21 Sep 2020 07:10:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=yL1qF0aWWP0bMtXdapi9UogEl1FauHKmuCr6mJ08kK4=; b=Fp2RyECL/5ModReK5lhfjx5Sr6
        LaO2KYTOkCNMDqk7RmMlvvvwDOY6DxEgsVG10yKK5NRHXWdhdws/UgLMpqtXOxUKIBJfOjrw71ce1
        rashfv0z/atsJbrMeo7RUhL7av61A0nxR3pMKXuHqoTGX32WI1CszS31FdpMqNt/E+vJZPag7vXac
        jxVo7WHqiM6mP57XnrdBx0MKtboHejZ4KxRzM6iDZMpvUeaXTWLM3LGa++fmXhfS9MygB1T80IQiw
        b1LDcg0UjMkEdjs0/N4rkrL3yt21QRV6pT0rjQhEBXCgdQkPo5mSGwj6ODxfQUSraB+reqPqRs9D5
        4hWfg9Yg==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kKMWp-0006Yc-TV; Mon, 21 Sep 2020 14:10:51 +0000
Date:   Mon, 21 Sep 2020 15:10:51 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     David Laight <David.Laight@aculab.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        "David S. Miller" <davem@davemloft.net>,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 3/9 next] lib/iov_iter: Improved function for importing
 iovec[] from userpace.
Message-ID: <20200921141051.GC24515@infradead.org>
References: <a24498efacd94e61a2af9df3976b0de6@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a24498efacd94e61a2af9df3976b0de6@AcuMS.aculab.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 15, 2020 at 02:55:17PM +0000, David Laight wrote:
> 
> import_iovec() has a 'pointer by reference' parameter to pass in the
> (on-stack) iov[] cache and return the address of a larger copy that
> the caller must free.
> This is non-intuitive, faffy to setup, and not that efficient.
> Instead just pass in the address of the cache and return the address
> to free (on success) or PTR_ERR() (on error).

To me it seems pretty sensible, and in fact the conversions to your
new API seem to add more lines than they remove.
