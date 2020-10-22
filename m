Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FE0F296105
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 16:39:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2900990AbgJVOjt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Oct 2020 10:39:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:49228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2900951AbgJVOjq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Oct 2020 10:39:46 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 276A224171;
        Thu, 22 Oct 2020 14:39:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603377583;
        bh=ma7f6ciQXaB7O32bDDp+GeQJ6WrSJ5EDDu1VyaA7rGo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PxugVsee9PWrXt/gXzudeuTvI47TjXebpNxq+V4HCmVCe1sKZHLosNqAbXuuvW+/i
         F3Omc7qJjCGcZpsoZ0gvdBLvvwF6P71x/p/bcwNCyzTjDInFt6yyFfEubOEEK8j98S
         eCVIVyZ2FmbbCU8ALan3OPjQJXwF2/c6hnwwd7rg=
Date:   Thu, 22 Oct 2020 16:40:21 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     David Hildenbrand <david@redhat.com>,
        David Laight <David.Laight@aculab.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Christoph Hellwig <hch@lst.de>,
        "kernel-team@android.com" <kernel-team@android.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        David Howells <dhowells@redhat.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
        "linux-parisc@vger.kernel.org" <linux-parisc@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "sparclinux@vger.kernel.org" <sparclinux@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-aio@kvack.org" <linux-aio@kvack.org>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "keyrings@vger.kernel.org" <keyrings@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>
Subject: Re: Buggy commit tracked to: "Re: [PATCH 2/9] iov_iter: move
 rw_copy_check_uvector() into lib/iov_iter.c"
Message-ID: <20201022144021.GA1969554@kroah.com>
References: <e04d0c5d-e834-a15b-7844-44dcc82785cc@redhat.com>
 <a1533569-948a-1d5b-e231-5531aa988047@redhat.com>
 <bc0a091865f34700b9df332c6e9dcdfd@AcuMS.aculab.com>
 <5fd6003b-55a6-2c3c-9a28-8fd3a575ca78@redhat.com>
 <20201022104805.GA1503673@kroah.com>
 <20201022121849.GA1664412@kroah.com>
 <98d9df88-b7ef-fdfb-7d90-2fa7a9d7bab5@redhat.com>
 <20201022125759.GA1685526@kroah.com>
 <20201022135036.GA1787470@kroah.com>
 <CAK8P3a1B7OVdyzW0-97JwzZiwp0D0fnSfyete16QTvPp_1m07A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK8P3a1B7OVdyzW0-97JwzZiwp0D0fnSfyete16QTvPp_1m07A@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 22, 2020 at 04:28:20PM +0200, Arnd Bergmann wrote:
> On Thu, Oct 22, 2020 at 3:50 PM Greg KH <gregkh@linuxfoundation.org> wrote:
> > On Thu, Oct 22, 2020 at 02:57:59PM +0200, Greg KH wrote:
> > > On Thu, Oct 22, 2020 at 02:42:24PM +0200, David Hildenbrand wrote:
> 
> > > >  struct iovec *iovec_from_user(const struct iovec __user *uvec,
> > > > -               unsigned long nr_segs, unsigned long fast_segs,
> > > > +               unsigned nr_segs, unsigned fast_segs,
> > > >                 struct iovec *fast_iov, bool compat)
> > > >  {
> > > >         struct iovec *iov = fast_iov;
> > > > @@ -1738,7 +1738,7 @@ ssize_t __import_iovec(int type, const struct
> > > > iovec __user *uvec,
> > > >                  struct iov_iter *i, bool compat)
> > > >  {
> > > >         ssize_t total_len = 0;
> > > > -       unsigned long seg;
> > > > +       unsigned seg;
> > > >         struct iovec *iov;
> > > >
> > > >         iov = iovec_from_user(uvec, nr_segs, fast_segs, *iovp, compat);
> > > >
> > >
> > > Ah, I tested the other way around, making everything "unsigned long"
> > > instead.  Will go try this too, as other tests are still running...
> >
> > Ok, no, this didn't work either.
> >
> > Nick, I think I need some compiler help here.  Any ideas?
> 
> I don't think the patch above would reliably clear the upper bits if they
> contain garbage.
> 
> If the integer extension is the problem, the way I'd try it is to make the
> function take an 'unsigned long' and then explictly mask the upper
> bits with
> 
>      seg = lower_32_bits(seg);
> 
> Can you attach the iov_iter.s files from the broken build, plus the
> one with 'noinline' for comparison? Maybe something can be seen
> in there.

I don't know how to extract the .s files easily from the AOSP build
system, I'll look into that.  I'm also now testing by downgrading to an
older version of clang (10 instead of 11), to see if that matters at all
or not...

thanks,

greg k-h
