Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C1C3458FD4
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 14:59:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239142AbhKVOCR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 09:02:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:43062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232880AbhKVOCQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Nov 2021 09:02:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 85712608FB;
        Mon, 22 Nov 2021 13:59:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637589550;
        bh=mdJklURZcfc5e0LfT0HMi5+15iVbXFSPMMnEJ4rEGQ4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CAdNr5l/SO7DQcMd9YvUtPjG5anPjzGgUu1Bn/LJ6XPHnMO+C8n5NAdE9+8QKjfqW
         ZUaHlcbUUvC2g2nS5wMWxkITx3v4lDHJxL2G591r/hO7MN07oACCRjIaWZbfJJYfuE
         SmZrF0dKDH8B+MCPNiuoRUoeKyTHa7MdHHRqlf/g=
Date:   Mon, 22 Nov 2021 14:59:07 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Jeremy Kerr <jk@codeconstruct.com.au>, netdev@vger.kernel.org,
        Matt Johnston <matt@codeconstruct.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Slaby <jirislaby@kernel.org>
Subject: Re: [PATCH net-next] mctp: Add MCTP-over-serial transport binding
Message-ID: <YZuiKw0Q7TU/+lGE@kroah.com>
References: <20211122042817.2988517-1-jk@codeconstruct.com.au>
 <YZs1p+lkKO+194zN@kroah.com>
 <123a5491b8485f42c9279d397cdeb6358c610f6c.camel@codeconstruct.com.au>
 <YZtHOfdn4HQdF3LD@kroah.com>
 <9652c9dd6b6238922f45ee71cf341cac88449b98.camel@codeconstruct.com.au>
 <YZuXGBdRpAXTfONP@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YZuXGBdRpAXTfONP@casper.infradead.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 22, 2021 at 01:11:52PM +0000, Matthew Wilcox wrote:
> On Mon, Nov 22, 2021 at 04:23:10PM +0800, Jeremy Kerr wrote:
> > Hi Greg,
> > 
> > > ida_destroy() will not be a no-op if you have allocated some things
> > > in the past.  It should always be called when your module is removed.
> > > 
> > > Or at least that is how it used to be, if this has changed in the
> > > past year, then I am mistaken here.
> 
> I think Greg is remembering how the IDA behaved before it was converted
> to use the radix tree back in 2016 (0a835c4f090a).  About two-thirds
> of the users of the IDA and IDR forgot to call ida_destroy/idr_destroy,
> so rather than fix those places, I decided to make those data structures
> no longer require a destructor.

Ah, yes.  Glad to see that's no longer needed, sorry for the noise and
thanks for correcting me.

greg k-h
