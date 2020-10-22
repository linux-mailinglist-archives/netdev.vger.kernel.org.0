Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 866D72965D4
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 22:11:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2898187AbgJVULa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Oct 2020 16:11:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2897892AbgJVUL3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Oct 2020 16:11:29 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AE74C0613D4
        for <netdev@vger.kernel.org>; Thu, 22 Oct 2020 13:11:27 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id j18so1909792pfa.0
        for <netdev@vger.kernel.org>; Thu, 22 Oct 2020 13:11:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GumHU2X+g85YksdsSI4rtK9zksU56rVy/CgxVuW0jEM=;
        b=vObNVdN2VFhAojESuCXkrxhn1YIwWVv+1XhIW4tZBL+fxMiFOMf/wpbwdQdbTEuqzU
         didUUL5vkJxiQnySAkNm5bA5dzi4HDPRY/b2q9PCHYr38o1QdWg4eoCCMy0LZ69odEBE
         EeVL+yKYldv1+Aa2ZS3w6i1XFzR6cyTrr6WpyCHfwh/bI39Aml+4GPRR3PK53sN4m6b3
         rUVDazS3OFa6481GJ9+htMab1H1YbLsr5SViapf30nhQCEj8D6AxmtXaycQnaAAFnPK+
         ve/0E2puLZtKaH/rY1wRoNU3uLbs1Hp/JNHjorNUJ0gL9lCRxpciXdv4OO2qkM+X3ZVh
         gy/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GumHU2X+g85YksdsSI4rtK9zksU56rVy/CgxVuW0jEM=;
        b=BEnhhUO3R7CxgdWE7ZGAwEIbD+WUfY8M/n6WaRoKpGU0PYApWGaeaqmG731oJMzZCA
         9QgdjoiZNtpk2ZfVdlkHfsQJnnt8RM+JLYDbIMvTzlgDVSI2upaeW7m7OM8MCfX4mwYk
         nbcczZlif17zyxSPg9xy5ZSQTUGx9FtwsUvK4UcJfSIwRYkT3LBKhsQ/NVJVjNzFqACu
         68+LLU0cbdoXQZbW5c8nSNSqO/THqFpJDv+PMDRFBnTV10qM4N0/9dQ6ajV1Cdc3MGOU
         1XZFdzi52mpU8fDh3A8SMoekfuVGiMaDd79mIIHuwXI0drjtSyw3w9/A+9G/jcAB9xgk
         9hkQ==
X-Gm-Message-State: AOAM531VEI1ghu91KTb7b2nhoW7UWdv0xrWHlowIAYvF+X2CYv9JiUhp
        GYK7JrLteDnIg9YcLHYTE/2iwP8zYqzmDRT3IpzrPg==
X-Google-Smtp-Source: ABdhPJzJwPfOlPnqmI7/5P7ibjxaxjQ3K/49C5Uiz6yY7FpMEBFECdyjYA4Y8meqnBbTveKDbTZgpESx4RovmeoudXg=
X-Received: by 2002:a17:90a:740a:: with SMTP id a10mr3865197pjg.32.1603397486718;
 Thu, 22 Oct 2020 13:11:26 -0700 (PDT)
MIME-Version: 1.0
References: <20201022090155.GA1483166@kroah.com> <e04d0c5d-e834-a15b-7844-44dcc82785cc@redhat.com>
 <a1533569-948a-1d5b-e231-5531aa988047@redhat.com> <bc0a091865f34700b9df332c6e9dcdfd@AcuMS.aculab.com>
 <5fd6003b-55a6-2c3c-9a28-8fd3a575ca78@redhat.com> <20201022132342.GB8781@lst.de>
 <8f1fff0c358b4b669d51cc80098dbba1@AcuMS.aculab.com> <CAKwvOdnix6YGFhsmT_mY8ORNPTOsN3HwS33Dr0Ykn-pyJ6e-Bw@mail.gmail.com>
 <CAK8P3a3LjG+ZvmQrkb9zpgov8xBkQQWrkHBPgjfYSqBKGrwT4w@mail.gmail.com>
 <CAKwvOdnhONvrHLAuz_BrAuEpnF5mD9p0YPGJs=NZZ0EZNo7dFQ@mail.gmail.com> <20201022192458.GV3576660@ZenIV.linux.org.uk>
In-Reply-To: <20201022192458.GV3576660@ZenIV.linux.org.uk>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Thu, 22 Oct 2020 13:11:14 -0700
Message-ID: <CAKwvOdkLHozVUs85Wx-_qo2OfbdkKwtmaJfQFJfvxi_vpEYxWQ@mail.gmail.com>
Subject: Re: Buggy commit tracked to: "Re: [PATCH 2/9] iov_iter: move
 rw_copy_check_uvector() into lib/iov_iter.c"
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        David Laight <David.Laight@aculab.com>,
        Christoph Hellwig <hch@lst.de>,
        David Hildenbrand <david@redhat.com>,
        Greg KH <gregkh@linuxfoundation.org>,
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

On Thu, Oct 22, 2020 at 12:25 PM Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> On Thu, Oct 22, 2020 at 12:04:52PM -0700, Nick Desaulniers wrote:
>
> > Passing an `unsigned long` as an `unsigned int` does no such
> > narrowing: https://godbolt.org/z/TvfMxe (same vice-versa, just tail
> > calls, no masking instructions).
> > So if rw_copy_check_uvector() is inlined into import_iovec() (looking
> > at the mainline@1028ae406999), then children calls of
> > `rw_copy_check_uvector()` will be interpreting the `nr_segs` register
> > unmodified, ie. garbage in the upper 32b.
>
> FWIW,
>
> void f(unsinged long v)
> {
>         if (v != 1)
>                 printf("failed\n");
> }
>
> void g(unsigned int v)
> {
>         f(v);
> }
>
> void h(unsigned long v)
> {
>         g(v);
> }
>
> main()
> {
>         h(0x100000001);
> }

A good/analogous example, but things get weird when the leaf node in
the call chain is inline asm: https://godbolt.org/z/s19TY5

(I'm not sure that's precisely what's going on here; I'll need to dive
more into the calls rw_copy_check_uvector() makes to see if there's
inline asm somewhere, pretty sure calls to get_user with `nr_regs`
exist).

>
> must not produce any output on a host with 32bit int and 64bit long, regardless of
> the inlining, having functions live in different compilation units, etc.
>
> Depending upon the calling conventions, compiler might do truncation in caller or
> in a callee, but it must be done _somewhere_.



-- 
Thanks,
~Nick Desaulniers
