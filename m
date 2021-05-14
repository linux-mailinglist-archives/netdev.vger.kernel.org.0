Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6069380F06
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 19:33:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235122AbhENReW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 13:34:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235166AbhENReT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 May 2021 13:34:19 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1F0AC061574
        for <netdev@vger.kernel.org>; Fri, 14 May 2021 10:33:07 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id f1so13323187edt.4
        for <netdev@vger.kernel.org>; Fri, 14 May 2021 10:33:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3bmbAftPboaY7hu+DnMgt2b6hH50EmPqKJHrC7bAGn8=;
        b=OCUpNcjguSpqlmqGqLclnsNCOhgzU3pBtJ+0aWvCc2SR59QNIHWTyn2iHNnFIXoHb/
         IlrJnYgxa3QKa7TD5DPjuhh0hv9dsnnG2SJC44eepw5A/YU6NsZQR/5smJrlWciM7Uz7
         oY/UTgSqeb9/fYqELWpyA+6END7cpdJzA1bkA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3bmbAftPboaY7hu+DnMgt2b6hH50EmPqKJHrC7bAGn8=;
        b=U14AElSslIhuE5v53qV6BHK8uwcSp1eOO2CAr14HyOPT67OPbhcpCt2vlXQYvCKIFk
         ng2NRqv+5Nff5PPP/v/Gfkr2BrhAykEISAlmnztL0T2Kc/nc0XKsCT/s18Y0z6/aSsmd
         ZEauQvOoLzBD2zuZEZBOLBnTa0SknM+5zL/QiITIRwRTi8qyVMLT4GdGWFbhiuPnK8bl
         Jsg1Xj4Y0wPIENlWeRsMCRxdBQmtmJhCQSOuJy8k3cMFvE5TvOOefn15oVVaCZkdvuM0
         aehpp6DC3MW+CO3bS8ZBrnHuJO4zZECZORGgkngjbtvHGw2QK1+k6av1BTDtW8yL4pE5
         Sn+g==
X-Gm-Message-State: AOAM533JicID63FomV2co+OA5WBbBdn2PnmAuDfp0Ts+i5tFwsBhvrrZ
        Ocy2HZnSyTSSBjCUWIEKl3K1tWVifdAd/nbnDmM=
X-Google-Smtp-Source: ABdhPJwBgEM9C+OPraFwjle541Bkyp9z4N+INKoBb4nsop4d+zQbLq5HRKCLKXmpgQWnuOEmaOeXZg==
X-Received: by 2002:a50:f744:: with SMTP id j4mr21683293edn.211.1621013586618;
        Fri, 14 May 2021 10:33:06 -0700 (PDT)
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com. [209.85.218.54])
        by smtp.gmail.com with ESMTPSA id y11sm4695584edd.91.2021.05.14.10.33.06
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 May 2021 10:33:06 -0700 (PDT)
Received: by mail-ej1-f54.google.com with SMTP id u21so45662217ejo.13
        for <netdev@vger.kernel.org>; Fri, 14 May 2021 10:33:06 -0700 (PDT)
X-Received: by 2002:a2e:9251:: with SMTP id v17mr38807472ljg.507.1621013573543;
 Fri, 14 May 2021 10:32:53 -0700 (PDT)
MIME-Version: 1.0
References: <20210514100106.3404011-1-arnd@kernel.org>
In-Reply-To: <20210514100106.3404011-1-arnd@kernel.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 14 May 2021 10:32:37 -0700
X-Gmail-Original-Message-ID: <CAHk-=whGObOKruA_bU3aPGZfoDqZM1_9wBkwREp0H0FgR-90uQ@mail.gmail.com>
Message-ID: <CAHk-=whGObOKruA_bU3aPGZfoDqZM1_9wBkwREp0H0FgR-90uQ@mail.gmail.com>
Subject: Re: [PATCH v2 00/13] Unify asm/unaligned.h around struct helper
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     linux-arch <linux-arch@vger.kernel.org>,
        Vineet Gupta <vgupta@synopsys.com>,
        Arnd Bergmann <arnd@arndb.de>,
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
        openrisc@lists.librecores.org,
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

On Fri, May 14, 2021 at 3:02 AM Arnd Bergmann <arnd@kernel.org> wrote:
>
> I've included this version in the asm-generic tree for 5.14 already,
> addressing the few issues that were pointed out in the RFC. If there
> are any remaining problems, I hope those can be addressed as follow-up
> patches.

This continues to look great to me, and now has the even simpler
remaining implementation.

I'd be tempted to just pull it in for 5.13, but I guess we don't
actually have any _outstanding_ bug in this area (the bug was in our
zlib code, required -O3 to trigger, has been fixed now, and the biggy
case didn't even use "get_unaligned()").

So I guess your 5.14 timing is the right thing to do.

        Linus
