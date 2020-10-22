Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C79112964F9
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 21:05:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S369864AbgJVTFJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Oct 2020 15:05:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S369868AbgJVTFH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Oct 2020 15:05:07 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2431C0613DC
        for <netdev@vger.kernel.org>; Thu, 22 Oct 2020 12:05:04 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id w11so1453007pll.8
        for <netdev@vger.kernel.org>; Thu, 22 Oct 2020 12:05:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ob2vCJvO6llStuDKjUpnqeOT2ObygH+mOzcnW04eANY=;
        b=KQqTFOK8RfeQlRsCMQ+rOlUOsaIw3aFT2tl0EvIIitPh93BRypnBq10dbZ1VQInVA9
         YBqadNAg8WpA2s2M51/9SZIy6oP0pnbbWbfMb7wIWJV2snjJBMbyo5oSDcHw4N1zr7/S
         VZLvINfglpSloiYKbOwAZRZgsEq5EwVd6j156C6w/ZUnsQNcPlNYKpHJP5uI2nd5y9vn
         Eb462d8qlKbplpH5u1WCwEWQN9mxoYO0QRuuyd1KRKvAJJWpZKPK5rzGEmieFY4kQrsm
         FHET+zmyltpbQH7fuqtpyH09Ge3zLiQZSD5eVuK163dQLFMNQGhprwY4hoqO0xWMFeFJ
         fZNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ob2vCJvO6llStuDKjUpnqeOT2ObygH+mOzcnW04eANY=;
        b=SI1NJkZcLtmFR/2JTW0VBmQULphvKBi2mQ633XzeveEh2Kls7srfJZh7ZRuR+SQoUG
         qU6AdeQkRZUfDCfLh4wzh2zXuSFbNJmC447PbGKEuH6NsJqq4NA8p/F4O63E1H0gwiWL
         IwwnDMo/2kKaFujB/0H9NLrA/VhARmifMbGDQTKYzRiJtTXDqO7fmiCnVrIPCeGwRfXm
         4tuu0Wz/ftb8YSGjhUg+tbI2O29PKHONuTThBGwbEKoq/E5Bto0cxmuVfS48BSkPGoQN
         mLy33vdKHRmj8zYwSeJk/Na5GDwDt3IcsCiizI3/+Walp9DuITJYqhjg2Di2ATb3aDT/
         uA0A==
X-Gm-Message-State: AOAM530CsR5sRCkCUqR3R8ovSC+eqKS5WNufGxpbnE7Y4i6FtT1lOykr
        IQ1xtSKGpekeP5NRuvKpwR/RcleUI9Z+FEP5jaUpoA==
X-Google-Smtp-Source: ABdhPJywMCKq0vfUuAKWQ9RLmH3NxEeoaMuMMn+wDHsffqxkAqXyKJ4o6MiCnyTmuBnnGxJWFn5poUUGRnshTJa4lRY=
X-Received: by 2002:a17:902:c40b:b029:d3:def2:d90f with SMTP id
 k11-20020a170902c40bb02900d3def2d90fmr3608595plk.29.1603393503931; Thu, 22
 Oct 2020 12:05:03 -0700 (PDT)
MIME-Version: 1.0
References: <20201021233914.GR3576660@ZenIV.linux.org.uk> <20201022082654.GA1477657@kroah.com>
 <80a2e5fa-718a-8433-1ab0-dd5b3e3b5416@redhat.com> <5d2ecb24db1e415b8ff88261435386ec@AcuMS.aculab.com>
 <df2e0758-b8ed-5aec-6adc-a18f499c0179@redhat.com> <20201022090155.GA1483166@kroah.com>
 <e04d0c5d-e834-a15b-7844-44dcc82785cc@redhat.com> <a1533569-948a-1d5b-e231-5531aa988047@redhat.com>
 <bc0a091865f34700b9df332c6e9dcdfd@AcuMS.aculab.com> <5fd6003b-55a6-2c3c-9a28-8fd3a575ca78@redhat.com>
 <20201022132342.GB8781@lst.de> <8f1fff0c358b4b669d51cc80098dbba1@AcuMS.aculab.com>
 <CAKwvOdnix6YGFhsmT_mY8ORNPTOsN3HwS33Dr0Ykn-pyJ6e-Bw@mail.gmail.com> <CAK8P3a3LjG+ZvmQrkb9zpgov8xBkQQWrkHBPgjfYSqBKGrwT4w@mail.gmail.com>
In-Reply-To: <CAK8P3a3LjG+ZvmQrkb9zpgov8xBkQQWrkHBPgjfYSqBKGrwT4w@mail.gmail.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Thu, 22 Oct 2020 12:04:52 -0700
Message-ID: <CAKwvOdnhONvrHLAuz_BrAuEpnF5mD9p0YPGJs=NZZ0EZNo7dFQ@mail.gmail.com>
Subject: Re: Buggy commit tracked to: "Re: [PATCH 2/9] iov_iter: move
 rw_copy_check_uvector() into lib/iov_iter.c"
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     David Laight <David.Laight@aculab.com>,
        Christoph Hellwig <hch@lst.de>,
        David Hildenbrand <david@redhat.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
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
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 22, 2020 at 11:13 AM Arnd Bergmann <arnd@arndb.de> wrote:
>
> On Thu, Oct 22, 2020 at 7:54 PM Nick Desaulniers
> <ndesaulniers@google.com> wrote:
> > On Thu, Oct 22, 2020 at 9:35 AM David Laight <David.Laight@aculab.com> wrote:
> > >
> > > Which makes it a bug in the kernel C syscall wrappers.
> > > They need to explicitly mask the high bits of 32bit
> > > arguments on arm64 but not x86-64.
> >
> > Why not x86-64? Wouldn't it be *any* LP64 ISA?
>
> x86-64 is slightly special because most instructions on a 32-bit
> argument clear the upper 32 bits, while on most architectures
> the same instruction would leave the upper bits unchanged.

Oh interesting, depends on the operations too on x86_64 IIUC?

>
> > Attaching a patch that uses the proper width, but I'm pretty sure
> > there's still a signedness issue .  Greg, would you mind running this
> > through the wringer?
>
> I would not expect this to change anything for the bug that Greg
> is chasing, unless there is also a bug in clang.
>
> In the version before the patch, we get a 64-bit argument from
> user space, which may consist of the intended value in the lower
> bits plus garbage in the upper bits. However, vlen only gets
> passed down  into import_iovec() without any other operations
> on it, and since import_iovec takes a 32-bit argument, this is
> where it finally gets narrowed.

Passing an `unsigned long` as an `unsigned int` does no such
narrowing: https://godbolt.org/z/TvfMxe (same vice-versa, just tail
calls, no masking instructions).
So if rw_copy_check_uvector() is inlined into import_iovec() (looking
at the mainline@1028ae406999), then children calls of
`rw_copy_check_uvector()` will be interpreting the `nr_segs` register
unmodified, ie. garbage in the upper 32b.

>
> After your patch, the SYSCALL_DEFINE3() does the narrowing
> conversion with the same clearing of the upper bits.
>
> If there is a problem somewhere leading up to import_iovec(),
> it would have to in some code that expects to get a 32-bit
> register argument but gets called with a register that has
> garbage in the upper bits /without/ going through a correct
> sanitizing function like SYSCALL_DEFINE3().
>
>       Arnd



-- 
Thanks,
~Nick Desaulniers
