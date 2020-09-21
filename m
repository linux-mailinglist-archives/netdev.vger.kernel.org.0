Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97C7B271A0C
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 06:28:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726355AbgIUE2V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 00:28:21 -0400
Received: from verein.lst.de ([213.95.11.211]:38359 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726011AbgIUE2U (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Sep 2020 00:28:20 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 979FC68AFE; Mon, 21 Sep 2020 06:28:15 +0200 (CEST)
Date:   Mon, 21 Sep 2020 06:28:15 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Al Viro <viro@zeniv.linux.org.uk>,
        Matthew Wilcox <willy@infradead.org>,
        Christoph Hellwig <hch@lst.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, Arnd Bergmann <arnd@arndb.de>,
        David Howells <dhowells@redhat.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        "open list:MIPS" <linux-mips@vger.kernel.org>,
        Parisc List <linux-parisc@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        sparclinux <sparclinux@vger.kernel.org>,
        linux-block <linux-block@vger.kernel.org>,
        Linux SCSI List <linux-scsi@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        linux-aio <linux-aio@kvack.org>, io-uring@vger.kernel.org,
        linux-arch <linux-arch@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Network Development <netdev@vger.kernel.org>,
        keyrings@vger.kernel.org,
        LSM List <linux-security-module@vger.kernel.org>
Subject: Re: [PATCH 1/9] kernel: add a PF_FORCE_COMPAT flag
Message-ID: <20200921042815.GA16281@lst.de>
References: <20200918124533.3487701-1-hch@lst.de> <20200918124533.3487701-2-hch@lst.de> <20200920151510.GS32101@casper.infradead.org> <20200920180742.GN3421308@ZenIV.linux.org.uk> <CALCETrWHW4wHG+Z-mxsY-kvjSi+S6gRUQ+LHd9syPcm5bhi3cw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrWHW4wHG+Z-mxsY-kvjSi+S6gRUQ+LHd9syPcm5bhi3cw@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 20, 2020 at 12:14:49PM -0700, Andy Lutomirski wrote:
> I wonder if this is really quite cast in stone.  We could also have
> FMODE_SHITTY_COMPAT and set that when a file like this is *opened* in
> compat mode.  Then that particular struct file would be read and
> written using the compat data format.  The change would be
> user-visible, but the user that would see it would be very strange
> indeed.
> 
> I don't have a strong opinion as to whether that is better or worse
> than denying io_uring access to these things, but at least it moves
> the special case out of io_uring.

open could have happened through an io_uring thread a well, so I don't
see how this would do anything but move the problem to a different
place.

> 
> --Andy
---end quoted text---
