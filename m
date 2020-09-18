Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 895FA26FEF4
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 15:45:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726696AbgIRNoN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 09:44:13 -0400
Received: from verein.lst.de ([213.95.11.211]:32784 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725955AbgIRNoM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Sep 2020 09:44:12 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 8EEFA68B05; Fri, 18 Sep 2020 15:44:06 +0200 (CEST)
Date:   Fri, 18 Sep 2020 15:44:06 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     Christoph Hellwig <hch@lst.de>,
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
Subject: Re: [PATCH 1/9] kernel: add a PF_FORCE_COMPAT flag
Message-ID: <20200918134406.GA17064@lst.de>
References: <20200918124533.3487701-1-hch@lst.de> <20200918124533.3487701-2-hch@lst.de> <20200918134012.GY3421308@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200918134012.GY3421308@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 18, 2020 at 02:40:12PM +0100, Al Viro wrote:
> >  	/* Vector 0x110 is LINUX_32BIT_SYSCALL_TRAP */
> > -	return pt_regs_trap_type(current_pt_regs()) == 0x110;
> > +	return pt_regs_trap_type(current_pt_regs()) == 0x110 ||
> > +		(current->flags & PF_FORCE_COMPAT);
> 
> Can't say I like that approach ;-/  Reasoning about the behaviour is much
> harder when it's controlled like that - witness set_fs() shite...

I don't particularly like it either.  But do you have a better idea
how to deal with io_uring vs compat tasks?
