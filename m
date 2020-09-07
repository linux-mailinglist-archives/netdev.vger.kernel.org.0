Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BAE4260123
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 19:00:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730394AbgIGRAu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 13:00:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727897AbgIGRAo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Sep 2020 13:00:44 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92C3EC061573
        for <netdev@vger.kernel.org>; Mon,  7 Sep 2020 10:00:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=KnBGEfcD9j4GfXURa8U0/5sBc1WBawl4N9DOeno2SUE=; b=q2QONb4Iz6rrJaUNTqy2o9L6OS
        P6ZnnYaacZ8SLgXK+6xURBZOm7CY1iaI/PSecxmFHUu1Jh4/1t1T4/3xzZLpmIKArnjcdOQe3D2Wt
        MnTBt+sAw7HfbEtgmaXN+YPUkrtVvQIy//dS4ppinJZNJPZnvBalVpVY0HL1VSfuRmHloP6+25388
        kz+i4zn5SESAkZVqxPvSjxPefxV5i8grwudNseov1sr3nnVo+xVpw9kyHKhNOvQ6delboE3uLlFsO
        NIp82ZiAGeFoo260GNJ6FQj+8JMQ7w60Ktn4AuxMxEsOXBe6lUhoUREHFqAon0UKiSCxcHKwsdDgv
        dqcZeUZw==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kFKVT-0003k7-7I; Mon, 07 Sep 2020 17:00:39 +0000
Date:   Mon, 7 Sep 2020 18:00:39 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@infradead.org>,
        Networking <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH for-next] net: provide __sys_shutdown_sock() that takes a
 socket
Message-ID: <20200907170039.GA13982@infradead.org>
References: <d3973f5b-2d86-665d-a5f3-95d017f9c79f@kernel.dk>
 <20200907054836.GA8956@infradead.org>
 <378cfa5a-eb06-d04c-bbbc-07b377f60c11@kernel.dk>
 <20200907095813.4cdacb5c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200907095813.4cdacb5c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 07, 2020 at 09:58:13AM -0700, Jakub Kicinski wrote:
> On Mon, 7 Sep 2020 10:45:00 -0600 Jens Axboe wrote:
> > On 9/6/20 11:48 PM, Christoph Hellwig wrote:
> > > On Sat, Sep 05, 2020 at 04:05:48PM -0600, Jens Axboe wrote:  
> > >> There's a trivial io_uring patch that depends on this one. If this one
> > >> is acceptable to you, I'd like to queue it up in the io_uring branch for
> > >> 5.10.  
> > > 
> > > Can you give it a better name?  These __ names re just horrible.
> > > sock_shutdown_sock?  
> > 
> > Sure, I don't really care, just following what is mostly done already. And
> > it is meant to be internal in the sense that it's not exported to modules.
> > 
> > I'll let the net guys pass the final judgement on that, I'm obviously fine
> > with anything in terms of naming :-)
> 
> So am I :) But if Christoph prefers sock_shutdown_sock() let's use that.

Let's go with the original naming.  I might eventually do a big
naming sweep in socket.c after cleaning up more of the compat mess.
