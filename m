Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B9452249CB
	for <lists+netdev@lfdr.de>; Sat, 18 Jul 2020 10:18:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729232AbgGRISY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jul 2020 04:18:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:53966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729127AbgGRISX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 18 Jul 2020 04:18:23 -0400
Received: from mail-oi1-f175.google.com (mail-oi1-f175.google.com [209.85.167.175])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 393D4208DB;
        Sat, 18 Jul 2020 08:18:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595060302;
        bh=6bSnP9zSLOcQHizO1rasA7u0tKkcEq4oHRa4K8fp0g0=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=BWpipE5K64RS2xn1Uea0NWUjuFxXgJDpLLSF5vWya/CwhsGngEZwJpRA9sNnt2G9s
         +oIIIyfOCun0bkswzkShIbtuU04D+LseYp3GJMaovJtf+PbOogeLFZ3te/QfaC/NWr
         s2D+3bVZkecQnoGXJ3X1Stk+y8cZQHTpCZX8Mges=
Received: by mail-oi1-f175.google.com with SMTP id k6so10007890oij.11;
        Sat, 18 Jul 2020 01:18:22 -0700 (PDT)
X-Gm-Message-State: AOAM531BJ8NJ0a/6ur4x7Lwhj3gIDzusqdvii0oJ2AcBtyCAAXzxlcQG
        3xRNTVMx45NNf/HlXcrnNvC/QChe/DRrgfZCjzw=
X-Google-Smtp-Source: ABdhPJyrjrlpB0vjn/uMcpNBFaqc7e9Z3yQsTmVjfYCHkBVMTRH1cdDccYuf3xV53Y5h+dsSyXNDRMOBT8ZPvQoNHo4=
X-Received: by 2002:aca:d643:: with SMTP id n64mr10510907oig.33.1595060301468;
 Sat, 18 Jul 2020 01:18:21 -0700 (PDT)
MIME-Version: 1.0
References: <20200702101947.682-1-ardb@kernel.org> <20200702101947.682-5-ardb@kernel.org>
 <20200702175022.GA2753@sol.localdomain> <CAMj1kXFen1nickdZab0s8iY7SgauoH56VginEoPdxaAAL2qENw@mail.gmail.com>
 <CAMj1kXG7i1isB9cV57ccaOZhrG3s7x+nKGozzTewuE9uWvX_wg@mail.gmail.com>
In-Reply-To: <CAMj1kXG7i1isB9cV57ccaOZhrG3s7x+nKGozzTewuE9uWvX_wg@mail.gmail.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Sat, 18 Jul 2020 11:18:10 +0300
X-Gmail-Original-Message-ID: <CAMj1kXGiu5Wr8NAACBUtiJMY8rQAGCTOcQdK1QM6jgH-0Lm=YA@mail.gmail.com>
Message-ID: <CAMj1kXGiu5Wr8NAACBUtiJMY8rQAGCTOcQdK1QM6jgH-0Lm=YA@mail.gmail.com>
Subject: Re: [RFC PATCH 4/7] crypto: remove ARC4 support from the skcipher API
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-wireless@vger.kernel.org,
        Marcel Holtmann <marcel@holtmann.org>,
        Denis Kenzior <denkenz@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        "open list:BPF JIT for MIPS (32-BIT AND 64-BIT)" 
        <netdev@vger.kernel.org>, devel@driverdev.osuosl.org,
        linux-nfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 3 Jul 2020 at 02:04, Ard Biesheuvel <ardb@kernel.org> wrote:
>
> On Thu, 2 Jul 2020 at 20:21, Ard Biesheuvel <ardb@kernel.org> wrote:
> >
> > On Thu, 2 Jul 2020 at 19:50, Eric Biggers <ebiggers@kernel.org> wrote:
> > >
> > > [+linux-wireless, Marcel Holtmann, and Denis Kenzior]
> > >
> > > On Thu, Jul 02, 2020 at 12:19:44PM +0200, Ard Biesheuvel wrote:
> > > > Remove the generic ecb(arc4) skcipher, which is slightly cumbersome from
> > > > a maintenance perspective, since it does not quite behave like other
> > > > skciphers do in terms of key vs IV lifetime. Since we are leaving the
> > > > library interface in place, which is used by the various WEP and TKIP
> > > > implementations we have in the tree, we can safely drop this code now
> > > > it no longer has any users.
> > > >
> > > > Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> > >
> > > Last year there was a discussion where it was mentioned that iwd uses
> > > "ecb(arc4)" via AF_ALG.  So can we really remove it yet?
> > > See https://lkml.kernel.org/r/97BB95F6-4A4C-4984-9EAB-6069E19B4A4F@holtmann.org
> > > Note that the code isn't in "iwd" itself but rather in "libell" which iwd
> > > depends on: https://git.kernel.org/pub/scm/libs/ell/ell.git/
> > >
> > > Apparently it also uses md4 and ecb(des) too.
> > >
> >
> > Ah yes, I remember now :-(
> >
> > > Marcel and Denis, what's your deprecation plan for these obsolete and insecure
> > > algorithms?
> > >
> >
> > Given Denis's statement:
> >
> >   It sounds to me like it was broken and should be fixed.  So our vote /
> >   preference is to have ARC4 fixed to follow the proper semantics.  We
> >   can deal with the kernel behavioral change on our end easily enough;
> >   the required workarounds are the worse evil.
> >
> > I would think that an ABI break is not the end of the world for them,
> > and given how trivial it is to implement RC4 in C, the workaround
> > should be to simply implement RC4 in user space, and not even bother
> > trying to use AF_ALG to get at ecb(arc4)
> >
> > (same applies to md4 and ecb(des) btw)
> >
> > There will always be a long tail of use cases, and at some point, we
> > just have to draw the line and remove obsolete and insecure cruft,
> > especially when it impedes progress on other fronts.
> >
>
> I have ported iwd to Nettle's LGPL 2.1 implementation of ARC4, and the
> diffstat is
>
>  src/crypto.c      | 80 ++++++++++++--------
>  src/main.c        |  8 --
>  unit/test-eapol.c |  3 +-
>  3 files changed, 51 insertions(+), 40 deletions(-)
>
> https://git.kernel.org/pub/scm/linux/kernel/git/ardb/iwd.git/log/?h=arc4-cleanup

Marcel, Denis,

Do you have any objections to the ecb(arc4) skcipher being dropped
from the kernel, given the fallback i proposed above (which is a much
better way of doing rc4 in user space anyway)?

For libell, I would suggest dropping rc4 entirely, once iwd stops
relying on it, as using rc4 for tls is obsolete as well.
