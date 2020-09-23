Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C123C275E4D
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 19:09:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726788AbgIWRJD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 13:09:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726130AbgIWRJB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 13:09:01 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EE84C0613CE;
        Wed, 23 Sep 2020 10:09:01 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id t12so346238ilh.3;
        Wed, 23 Sep 2020 10:09:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ytIfUWOmJqLPL+KzEZROrbe3lD4J5ZzRU4bHZaNkG6o=;
        b=SJdkZUQ5ybixC9OLlVL9ihYm0CGLZ1cfDuOlRdKBWI5QTOmULV2iGenUUbUD5nTor1
         kqILyv2JLjuaan6UAW6DDaQNCIcU/yd6/FB4cjytVESzyvnF521+vXIlGuspDiz4mn1x
         0pe9AHsIqqDfUYIywe8ABpEPxZ0PmyFGn5nW6irTMP9h7VkNxgroibbBOMNzUXMn7vKx
         rVhw9xS6DwUCuluTBETmo7u/kv8kt+9usmeZxWSMpFV/oDBu5nsCmM/Qw8xhLz8Y3lKG
         ByUShFY2nuSD519gJ//MM/eqO74kPkrESHRriPZ7jnkjAQUVo2q29u3OUNdwzjm6srT3
         IBjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ytIfUWOmJqLPL+KzEZROrbe3lD4J5ZzRU4bHZaNkG6o=;
        b=l/ejPnyC86aP/SIXBnObQ0REfhnvAMPlGBTgsjnoFbe8WZ/E9ar6LY5+XXFvAPGJ21
         BuLa8kUA40Po3oMi6wWKfqXGeJn4ufi7/bLU0Bd2DmtlFDc9S5umwxQh0YkGQEpARN29
         MX2uFX2kfGXqpncZgaW3XrgcZ2li5Wvr8K81BztGqG8rwGiR1sF9i8/w9phnCh8A0W6d
         zYUThtXKioC2Q1oQVF+Tlhfoy7NpqOvmSIgXZwh1VXl3igvc+XAq2Fxe2e7P++MSyYkW
         cf/JXlv6zuUj8SNz7YnwjOF1KVdvHcbPi8bzZO7USkKb3Se8s9IMzgl3FuKkAwK1F75+
         SSMw==
X-Gm-Message-State: AOAM530RUah7vGM7wPg7ndnrod5ofQsKXQloTK+Nj9PBklvMLec+ZkKP
        Fb6DANmx9gHkRARKufBcE0scHKcQN5ihOFVkDA==
X-Google-Smtp-Source: ABdhPJx9AHt865Jv+eAAUR1TTStZMpA1/c10T3SLrotTbGP81GAP4lHvM3CmBFRNspJd1OouW0Bqrb/e9Ox1UsZBcH4=
X-Received: by 2002:a92:99cb:: with SMTP id t72mr675478ilk.172.1600880940723;
 Wed, 23 Sep 2020 10:09:00 -0700 (PDT)
MIME-Version: 1.0
References: <20200923060547.16903-1-hch@lst.de> <20200923060547.16903-6-hch@lst.de>
 <20200923142549.GK3421308@ZenIV.linux.org.uk> <20200923143251.GA14062@lst.de>
 <20200923145901.GN3421308@ZenIV.linux.org.uk> <20200923163831.GO3421308@ZenIV.linux.org.uk>
In-Reply-To: <20200923163831.GO3421308@ZenIV.linux.org.uk>
From:   Brian Gerst <brgerst@gmail.com>
Date:   Wed, 23 Sep 2020 13:08:49 -0400
Message-ID: <CAMzpN2idk7bc7+37sj5UFD_PUOXCxn+RS8xmviq6Yc_LU4jyCw@mail.gmail.com>
Subject: Re: [PATCH 5/9] fs: remove various compat readv/writev helpers
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     Christoph Hellwig <hch@lst.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, Arnd Bergmann <arnd@arndb.de>,
        David Howells <dhowells@redhat.com>,
        David Laight <David.Laight@aculab.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "open list:BROADCOM NVRAM DRIVER" <linux-mips@vger.kernel.org>,
        Parisc List <linux-parisc@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        sparclinux <sparclinux@vger.kernel.org>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>,
        linux-aio@kvack.org, io-uring@vger.kernel.org,
        linux-arch <linux-arch@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>, netdev@vger.kernel.org,
        keyrings@vger.kernel.org, linux-security-module@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 23, 2020 at 12:39 PM Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> On Wed, Sep 23, 2020 at 03:59:01PM +0100, Al Viro wrote:
>
> > > That's a very good question.  But it does not just compile but actually
> > > works.  Probably because all the syscall wrappers mean that we don't
> > > actually generate the normal names.  I just tried this:
> > >
> > > --- a/include/linux/syscalls.h
> > > +++ b/include/linux/syscalls.h
> > > @@ -468,7 +468,7 @@ asmlinkage long sys_lseek(unsigned int fd, off_t offset,
> > >  asmlinkage long sys_read(unsigned int fd, char __user *buf, size_t count);
> > >  asmlinkage long sys_write(unsigned int fd, const char __user *buf,
> > >                             size_t count);
> > > -asmlinkage long sys_readv(unsigned long fd,
> > > +asmlinkage long sys_readv(void *fd,
> > >
> > > for fun, and the compiler doesn't care either..
> >
> > Try to build it for sparc or ppc...
>
> FWIW, declarations in syscalls.h used to serve 4 purposes:
>         1) syscall table initializers needed symbols declared
>         2) direct calls needed the same
>         3) catching mismatches between the declarations and definitions
>         4) centralized list of all syscalls
>
> (2) has been (thankfully) reduced for some time; in any case, ksys_... is
> used for the remaining ones.
>
> (1) and (3) are served by syscalls.h in architectures other than x86, arm64
> and s390.  On those 3 (1) is done otherwise (near the syscall table initializer)
> and (3) is not done at all.
>
> I wonder if we should do something like
>
> SYSCALL_DECLARE3(readv, unsigned long, fd, const struct iovec __user *, vec,
>                  unsigned long, vlen);
> in syscalls.h instead, and not under that ifdef.
>
> Let it expand to declaration of sys_...() in generic case and, on x86, into
> __do_sys_...() and __ia32_sys_...()/__x64_sys_...(), with types matching
> what SYSCALL_DEFINE ends up using.
>
> Similar macro would cover compat_sys_...() declarations.  That would
> restore mismatch checking for x86 and friends.  AFAICS, the cost wouldn't
> be terribly high - cpp would have more to chew through in syscalls.h,
> but it shouldn't be all that costly.  Famous last words, of course...
>
> Does anybody see fundamental problems with that?

I think this would be a good idea.  I have been working on a patchset
to clean up the conditional syscall handling (sys_ni.c), and conflicts
with the prototypes in syscalls.h have been getting in the way.
Having the prototypes use SYSCALL_DECLAREx(...) would solve that
issue.

--
Brian Gerst
