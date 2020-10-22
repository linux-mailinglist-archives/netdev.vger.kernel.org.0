Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BB75296649
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 22:59:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S372092AbgJVU7i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Oct 2020 16:59:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:47852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2897292AbgJVU7h (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Oct 2020 16:59:37 -0400
Received: from gmail.com (unknown [104.132.1.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8D47120874;
        Thu, 22 Oct 2020 20:59:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603400375;
        bh=Xexx6LzGU5CEQ5pUb/Rnl3sbc1IKJSCv776XJ3IiUZY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=zdUyA37A1L47KHgoyE+FT2EuXbQ76eLgYxDhD0pRsQ/vZP9VSxvex63p/S7m2wh2S
         LPo1qkQ3neXSHmpGEcAArmow8IRVH9ABGEBSoWdWkIGldhGddb2MyLlCZgza1+BxJr
         XSVfJ1lZvRBFbHtiVn91WdB+7mhw78zhWJSY/86E=
Date:   Thu, 22 Oct 2020 13:59:32 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Matthew Wilcox <willy@infradead.org>,
        David Laight <David.Laight@aculab.com>,
        Christoph Hellwig <hch@lst.de>,
        David Hildenbrand <david@redhat.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "kernel-team@android.com" <kernel-team@android.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, Arnd Bergmann <arnd@arndb.de>,
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
Message-ID: <20201022205932.GB3613750@gmail.com>
References: <df2e0758-b8ed-5aec-6adc-a18f499c0179@redhat.com>
 <20201022090155.GA1483166@kroah.com>
 <e04d0c5d-e834-a15b-7844-44dcc82785cc@redhat.com>
 <a1533569-948a-1d5b-e231-5531aa988047@redhat.com>
 <bc0a091865f34700b9df332c6e9dcdfd@AcuMS.aculab.com>
 <5fd6003b-55a6-2c3c-9a28-8fd3a575ca78@redhat.com>
 <20201022132342.GB8781@lst.de>
 <8f1fff0c358b4b669d51cc80098dbba1@AcuMS.aculab.com>
 <20201022164040.GV20115@casper.infradead.org>
 <CAKwvOdnq-yYLcF_coo=jMV-RH-SkuNp_kMB+KCBF5cz3PwiB8g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKwvOdnq-yYLcF_coo=jMV-RH-SkuNp_kMB+KCBF5cz3PwiB8g@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 22, 2020 at 10:00:44AM -0700, Nick Desaulniers wrote:
> On Thu, Oct 22, 2020 at 9:40 AM Matthew Wilcox <willy@infradead.org> wrote:
> >
> > On Thu, Oct 22, 2020 at 04:35:17PM +0000, David Laight wrote:
> > > Wait...
> > > readv(2) defines:
> > >       ssize_t readv(int fd, const struct iovec *iov, int iovcnt);
> >
> > It doesn't really matter what the manpage says.  What does the AOSP
> > libc header say?
> 
> Same: https://android.googlesource.com/platform/bionic/+/refs/heads/master/libc/include/sys/uio.h#38
> 
> Theoretically someone could bypass libc to make a system call, right?
> 
> >
> > > But the syscall is defined as:
> > >
> > > SYSCALL_DEFINE3(readv, unsigned long, fd, const struct iovec __user *, vec,
> > >                 unsigned long, vlen)
> > > {
> > >         return do_readv(fd, vec, vlen, 0);
> > > }
> >
> 

FWIW, glibc makes the readv() syscall assuming that fd and vlen are 'int' as
well.  So this problem isn't specific to Android's libc.

From objdump -d /lib/x86_64-linux-gnu/libc.so.6:

	00000000000f4db0 <readv@@GLIBC_2.2.5>:
	   f4db0:       64 8b 04 25 18 00 00    mov    %fs:0x18,%eax
	   f4db7:       00
	   f4db8:       85 c0                   test   %eax,%eax
	   f4dba:       75 14                   jne    f4dd0 <readv@@GLIBC_2.2.5+0x20>
	   f4dbc:       b8 13 00 00 00          mov    $0x13,%eax
	   f4dc1:       0f 05                   syscall
	   ...

There's some code for pthread cancellation, but no zeroing of the upper half of
the fd and vlen arguments, which are in %edi and %edx respectively.  But the
glibc function prototype uses 'int' for them, not 'unsigned long'
'ssize_t readv(int fd, const struct iovec *iov, int iovcnt);'.

So the high halves of the fd and iovcnt registers can contain garbage.  Or at
least that's what gcc (9.3.0) and clang (9.0.1) assume; they both compile the
following

void g(unsigned int x);

void f(unsigned long x)
{
        g(x);
}

into f() making a tail call to g(), without zeroing the top half of %rdi.

Also note the following program succeeds on Linux 5.9 on x86_64.  On kernels
that have this bug, it should fail.  (I couldn't get it to actually fail, so it
must depend on the compiler and/or the kernel config...)

	#include <fcntl.h>
	#include <stdio.h>
	#include <sys/syscall.h>
	#include <sys/uio.h>
	#include <unistd.h>

	int main()
	{
		int fd = open("/dev/zero", O_RDONLY);
		char buf[1000];
		struct iovec iov = { .iov_base = buf, .iov_len = sizeof(buf) };
		long ret;

		ret = syscall(__NR_readv, fd, &iov, 0x100000001);
		if (ret < 0)
			perror("readv failed");
		else
			printf("read %ld bytes\n", ret);
	}

I think the right fix is to change the readv() (and writev(), etc.) syscalls to
take 'unsigned int' rather than 'unsigned long', as that is what the users are
assuming...

- Eric
