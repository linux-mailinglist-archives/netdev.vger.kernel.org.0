Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0AF127161B
	for <lists+netdev@lfdr.de>; Sun, 20 Sep 2020 18:59:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726473AbgITQ7w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Sep 2020 12:59:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:48400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726466AbgITQ7w (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 20 Sep 2020 12:59:52 -0400
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EEB67214F1
        for <netdev@vger.kernel.org>; Sun, 20 Sep 2020 16:59:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600621191;
        bh=x0CbGoy7QDKeuRiDyZ0r+bpumnscmCVOPI/85NlktW8=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=STZH/t3yOYC4lt6Mbr2vmd9GDCGx8Do5AUPf2HvBn5gwFKMQ3g4WFLR/bZxO/Emf0
         YAXVcXDnnKpM12deRHGOwsnphIt05ikwCvTQNr2FQ2s0fWMIK36VWVl89rPjxqXYb7
         Sm0INJJVrL1NorNVa7M3stCqorDtqJTlsBOwypoE=
Received: by mail-wm1-f50.google.com with SMTP id a9so10248878wmm.2
        for <netdev@vger.kernel.org>; Sun, 20 Sep 2020 09:59:50 -0700 (PDT)
X-Gm-Message-State: AOAM5305NHOqUQNMehtzRaLfmtjoA9ItnfTmivSY7zBCzATQ1YgfFk/l
        7YOAUzOMp63Y+7WKiazWNK9YU9mkAZdugVQ5fduV1Q==
X-Google-Smtp-Source: ABdhPJwqhOCovrDdCcRZECZNQYs8Sx/d9wwPnQKSY4d4VjHeXmP8XzKxWrTfmcwJ7rQVtp7oa0fbaMUpJAjukisl/1Y=
X-Received: by 2002:a1c:7e15:: with SMTP id z21mr25730921wmc.21.1600621188572;
 Sun, 20 Sep 2020 09:59:48 -0700 (PDT)
MIME-Version: 1.0
References: <20200919224122.GJ3421308@ZenIV.linux.org.uk> <36CF3DE7-7B4B-41FD-9818-FDF8A5B440FB@amacapital.net>
 <20200919232411.GK3421308@ZenIV.linux.org.uk> <CALCETrViwOdFia_aX4p4riE8aqop1zoOqVfiQtSAZEzheC+Ozg@mail.gmail.com>
 <20200920025745.GL3421308@ZenIV.linux.org.uk>
In-Reply-To: <20200920025745.GL3421308@ZenIV.linux.org.uk>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Sun, 20 Sep 2020 09:59:36 -0700
X-Gmail-Original-Message-ID: <CALCETrWj1i-oyfA1rCXsNqdJddK6Vwm=W31YEf=k-OMBTC0vHw@mail.gmail.com>
Message-ID: <CALCETrWj1i-oyfA1rCXsNqdJddK6Vwm=W31YEf=k-OMBTC0vHw@mail.gmail.com>
Subject: Re: [PATCH 1/9] kernel: add a PF_FORCE_COMPAT flag
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     Andy Lutomirski <luto@kernel.org>, Christoph Hellwig <hch@lst.de>,
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
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 19, 2020 at 7:57 PM Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> On Sat, Sep 19, 2020 at 05:14:41PM -0700, Andy Lutomirski wrote:
>
> > > 2) have you counted the syscalls that do and do not need that?
> >
> > No.
>
> Might be illuminating...
>
> > > 3) how many of those realistically *can* be unified with their
> > > compat counterparts?  [hint: ioctl(2) cannot]
> >
> > There would be no requirement to unify anything.  The idea is that
> > we'd get rid of all the global state flags.
>
> _What_ global state flags?  When you have separate SYSCALL_DEFINE3(ioctl...)
> and COMPAT_SYSCALL_DEFINE3(ioctl...), there's no flags at all, global or
> local.  They only come into the play when you try to share the same function
> for both, right on the top level.

...

>
> > For ioctl, we'd have a new file_operation:
> >
> > long ioctl(struct file *, unsigned int, unsigned long, enum syscall_arch);
> >
> > I'm not saying this is easy, but I think it's possible and the result
> > would be more obviously correct than what we have now.
>
> No, it would not.  Seriously, from time to time a bit of RTFS before grand
> proposals turns out to be useful.

As one example, look at __sys_setsockopt().  It's called for the
native and compat versions, and it contains an in_compat_syscall()
check.  (This particularly check looks dubious to me, but that's
another story.)  If this were to be done with equivalent semantics
without a separate COMPAT_DEFINE_SYSCALL and without
in_compat_syscall(), there would need to be some indication as to
whether this is compat or native setsockopt.  There are other
setsockopt implementations in the net stack with more
legitimate-seeming uses of in_compat_syscall() that would need some
other mechanism if in_compat_syscall() were to go away.

setsockopt is (I hope!) out of scope for io_uring, but the situation
isn't fundamentally different from read and write.
