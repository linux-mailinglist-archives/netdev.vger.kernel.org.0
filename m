Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAC0E3811A0
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 22:20:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232633AbhENUVf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 16:21:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230125AbhENUVe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 May 2021 16:21:34 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C5D4C06174A
        for <netdev@vger.kernel.org>; Fri, 14 May 2021 13:20:22 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id l7so36061470edb.1
        for <netdev@vger.kernel.org>; Fri, 14 May 2021 13:20:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zj/dlxgrTFi/afXdqvpoKnC0fO1FIFdLyxVrDXldBSs=;
        b=YFKY9Xahh+37BAr6aWqyWYu1Mb7APXH6ODm/OL23XmTx5cHPfE5nvsgH3V9cI44nS0
         EW6HUNU9PMYQx+djBq7ws8ietkyGay3lY9V3u/1Wuw/v3Pr2ScmDgx0fOcF6ZkLkBuPr
         cN3FjgtrPRUQDfA1h2PJ+U+sspjArlX7AElF0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zj/dlxgrTFi/afXdqvpoKnC0fO1FIFdLyxVrDXldBSs=;
        b=M8nH8aN/e+H2l10eG5WdiR/k+x3/pKlag7lVs4fDk1rBz/Znmf+48m1hAnKO90/XLf
         d3eL/NctDBEzMv18rxjS8I9n8sV2Mf03f7qPhgfB2bKsqWNRBet/zTc0UBluvbkEXW/y
         4hiY2GOa16OWjGU8qTu2x+HIWmsJlHUyYzVAMJcJQUvBMDv1xofxUhZ55NOuyeOYDXuw
         Fc6wZuJwktOHRy1HvkfggUbJGx2u4JTCLOpACQ1RJfLMJlUjMlGYzbMBealp7iK4j//Q
         Pvb7md0WqFydm3WN+QfHkyy/p05n2vASBneIYu8uyU4mKLv3tFWppz7xmGhScoCtC32e
         n0Hg==
X-Gm-Message-State: AOAM530afCVww9pWhivO1TLOgqc4Arpqx3M6W/mzEPsasaaugdLE64aO
        xQDKGUgt0mDuzn4k+USr7xttS5iGaUV/uH6bs2Y=
X-Google-Smtp-Source: ABdhPJzeKl727slR6cLft9L+nH2IEHG2avXs9J4leL1kxW3RE6xTZ0kZkzGUJe72vJwLEh26PYIqqA==
X-Received: by 2002:a05:6402:1a38:: with SMTP id be24mr58734804edb.293.1621023620645;
        Fri, 14 May 2021 13:20:20 -0700 (PDT)
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com. [209.85.208.50])
        by smtp.gmail.com with ESMTPSA id n12sm5216170edw.95.2021.05.14.13.20.19
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 May 2021 13:20:19 -0700 (PDT)
Received: by mail-ed1-f50.google.com with SMTP id a25so11883454edr.12
        for <netdev@vger.kernel.org>; Fri, 14 May 2021 13:20:19 -0700 (PDT)
X-Received: by 2002:a05:6512:374b:: with SMTP id a11mr32730248lfs.377.1621023609037;
 Fri, 14 May 2021 13:20:09 -0700 (PDT)
MIME-Version: 1.0
References: <20210514100106.3404011-1-arnd@kernel.org> <CAHk-=whGObOKruA_bU3aPGZfoDqZM1_9wBkwREp0H0FgR-90uQ@mail.gmail.com>
 <2408c893-4ae7-4f53-f58c-497c91f5b034@synopsys.com> <CAHk-=wih8UHDwJ8x6m-p0PQ7o4S4gOBwGNs=w=q10GNY7A-70w@mail.gmail.com>
 <14016937-b9c3-c131-db18-f97081806c7f@synopsys.com>
In-Reply-To: <14016937-b9c3-c131-db18-f97081806c7f@synopsys.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 14 May 2021 13:19:53 -0700
X-Gmail-Original-Message-ID: <CAHk-=whdR4OLJjwaU_nJhmS4n6ruGK4XFuLxA7zEOoCV7U=QLA@mail.gmail.com>
Message-ID: <CAHk-=whdR4OLJjwaU_nJhmS4n6ruGK4XFuLxA7zEOoCV7U=QLA@mail.gmail.com>
Subject: Re: [PATCH v2 00/13] Unify asm/unaligned.h around struct helper
To:     Vineet Gupta <Vineet.Gupta1@synopsys.com>
Cc:     Arnd Bergmann <arnd@kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
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
        "openrisc@lists.librecores.org" <openrisc@lists.librecores.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        linux-sparc <sparclinux@vger.kernel.org>,
        "linux-ntfs-dev@lists.sourceforge.net" 
        <linux-ntfs-dev@lists.sourceforge.net>,
        linux-block <linux-block@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 14, 2021 at 12:45 PM Vineet Gupta
<Vineet.Gupta1@synopsys.com> wrote:
>
> Well, not really, the issue manifested in ARC O3 testing, but I showed
> the problem existed for arm64 gcc too.

.. but not with a supported kernel configuration.

> > So in fact it's not even queued up for 5.14 due to this all, I just dropped it.
>
> But Why.

I just didn't have time to deal with it during the merge window. If
you keep it alive, that's all fine and good.

                Linus
