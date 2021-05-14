Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC1133810ED
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 21:33:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233178AbhENTeS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 15:34:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:53670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231386AbhENTeO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 May 2021 15:34:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C8FB06145A;
        Fri, 14 May 2021 19:33:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621020782;
        bh=sx6RnRTXG/HkUYbZ66bme4Ihr6YCIRDKjve7uvyFxHE=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Kf5jsZXI52Zq2tpRgMl1O8c/U7y8d0w9MTmfdlRsUujEeAawhwUIMMGIQtMlsZQR+
         09M/wvcClTYpMdPwODUMv1lEUqwsxZg8kN+M27STmCVk1mXGfnwxvYTILPmrgioIip
         2DidMQ/s9r1u10t8JprtlXHoYMmOHC5NzqP5zI5qWxESG0s76XUoFdFhzvPxB2OknV
         Wl1y4oD0rWxRYnRD7OLp1efXk9B2P86nK8hne1Rf0EOQvqeFJm0vGI8G2NBqcS9E51
         pNUbKOerRoDcTyncAbJOnEzan5RkSIAHrktjzHjFuDRXPTX8fx4UJMFbBk15mWJGWi
         2t6jgV3Fc82HA==
Received: by mail-wr1-f48.google.com with SMTP id s8so282442wrw.10;
        Fri, 14 May 2021 12:33:02 -0700 (PDT)
X-Gm-Message-State: AOAM532MquXo4CcXnU0aIaGz9PJnnz6tfG6hOFSdWxKGnAjjpUcABeTd
        vuUvPo8OM9pRpqesSqxyehhCk9T3N9x+Nmj3WE0=
X-Google-Smtp-Source: ABdhPJwCQ1F0CBUPxIsNYOfoW01L5a5C+nTIh8ZsdXu8MlaXBtReQ+mP8NigDxBA9czvxj+u/ONPbc8umn+Z9hfl/zY=
X-Received: by 2002:a5d:6dc4:: with SMTP id d4mr62128225wrz.105.1621020781452;
 Fri, 14 May 2021 12:33:01 -0700 (PDT)
MIME-Version: 1.0
References: <20210514100106.3404011-1-arnd@kernel.org> <CAHk-=whGObOKruA_bU3aPGZfoDqZM1_9wBkwREp0H0FgR-90uQ@mail.gmail.com>
In-Reply-To: <CAHk-=whGObOKruA_bU3aPGZfoDqZM1_9wBkwREp0H0FgR-90uQ@mail.gmail.com>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Fri, 14 May 2021 21:31:59 +0200
X-Gmail-Original-Message-ID: <CAK8P3a2q8zEy+eQ1RJHT7UbD9E+KofKNjKxMHJ6hreHN0J_mEQ@mail.gmail.com>
Message-ID: <CAK8P3a2q8zEy+eQ1RJHT7UbD9E+KofKNjKxMHJ6hreHN0J_mEQ@mail.gmail.com>
Subject: Re: [PATCH v2 00/13] Unify asm/unaligned.h around struct helper
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-arch <linux-arch@vger.kernel.org>,
        Vineet Gupta <vgupta@synopsys.com>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Borislav Petkov <bp@alien8.de>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        James Morris <jmorris@namei.org>, Jens Axboe <axboe@kernel.dk>,
        John Johansen <john.johansen@canonical.com>,
        Jonas Bonn <jonas@southpole.se>,
        Kalle Valo <kvalo@codeaurora.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Paul Mackerras <paulus@samba.org>,
        Rich Felker <dalias@libc.org>,
        "Richard Russon (FlatCap)" <ldm@flatcap.org>,
        Russell King <linux@armlinux.org.uk>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Sharvari Harisangam <sharvari.harisangam@nxp.com>,
        Stafford Horne <shorne@gmail.com>,
        Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-m68k <linux-m68k@lists.linux-m68k.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Openrisc <openrisc@lists.librecores.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        linux-sparc <sparclinux@vger.kernel.org>,
        linux-ntfs-dev@lists.sourceforge.net,
        linux-block <linux-block@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 14, 2021 at 7:32 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Fri, May 14, 2021 at 3:02 AM Arnd Bergmann <arnd@kernel.org> wrote:
> >
> > I've included this version in the asm-generic tree for 5.14 already,
> > addressing the few issues that were pointed out in the RFC. If there
> > are any remaining problems, I hope those can be addressed as follow-up
> > patches.
>
> This continues to look great to me, and now has the even simpler
> remaining implementation.
>
> I'd be tempted to just pull it in for 5.13, but I guess we don't
> actually have any _outstanding_ bug in this area (the bug was in our
> zlib code, required -O3 to trigger, has been fixed now, and the biggy
> case didn't even use "get_unaligned()").
>
> So I guess your 5.14 timing is the right thing to do.

Yes, I think that's best, just in case something does come up. While all the
object code I looked at does appear better, this is one of those areas that
can be hard to pinpoint if we hit a regression in a particular combination of
architecture+compiler+source file.

I have pushed a signed tag to
https://git.kernel.org/pub/scm/linux/kernel/git/arnd/asm-generic.git
asm-generic-unaligned-5.14

and plan to send that in the 5.14 merge window unless you decide to
take it now after all.

        Arnd
