Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78D9E4107D8
	for <lists+netdev@lfdr.de>; Sat, 18 Sep 2021 19:28:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239786AbhIRRaM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Sep 2021 13:30:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236861AbhIRRaL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Sep 2021 13:30:11 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D67C9C061574
        for <netdev@vger.kernel.org>; Sat, 18 Sep 2021 10:28:47 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id t10so40805343lfd.8
        for <netdev@vger.kernel.org>; Sat, 18 Sep 2021 10:28:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PPMj8VLwTy75eprkO41oC3JgAE7NDa67ow6tA6A6/r0=;
        b=cy1UQNMOS0XYpgCCs7UW1bRKopN5C73/mDGBe3xOEvU9Qfc5peAlSaAnDkUL4a5c+l
         T+T9VcGwQGkOsVeyqqcFOdpSy7FTSjlq6zJMH39qCslLX05iJqtLvtCekhr85+YjZU3Q
         mY8lX8VUfk8l+z37c+OMtnVi/VdXUVL9PCefk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PPMj8VLwTy75eprkO41oC3JgAE7NDa67ow6tA6A6/r0=;
        b=vR6/EVp1OGhDfynF8d7PVbdJJJC0OQySfF0qFvV9xdLxdfPHb1YzpiFp0wp8BApmiz
         7HilZ7Vlquehpyy0p21lkmVsekDzFic7z8ygSkqbA6VQjN5+sOvqOEJVmKjbm5/xB8La
         fuYQuFSnfw+lStBberMCYjSI0dA/BptVR+1R4ptzUPxiaCyX9rewJfnYFeWi4SPsNYnN
         CN+gFUqSVpFgz2OHekRBm/Kyj9kyuibjSeaRJs7WtD6sayTA/pHCOVTTC57XNUxqQrPd
         C0/J9qbPftsQPDoyzFBcK3TMwJ1dkiq8CVCwa7jDOtJKFa1qBm3uEDLuqghgEQLO/l53
         wjXA==
X-Gm-Message-State: AOAM532YfeQJ6pf7nd+JiGfDgiK0gICJJs473r6qQGVv/zQzbwBf8ZmC
        btHXqq65CdlT1zr9CFhy1ABqbyIuFXUpB8JR5mk=
X-Google-Smtp-Source: ABdhPJxgXwFyNWmRVvF9BH3LQToaqAyKGrIE31FG1Z1qsaQvMuSa8bGl4w05ljx/KgdzxNqU0i70Fw==
X-Received: by 2002:a05:6512:1596:: with SMTP id bp22mr6313594lfb.608.1631986125566;
        Sat, 18 Sep 2021 10:28:45 -0700 (PDT)
Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com. [209.85.167.53])
        by smtp.gmail.com with ESMTPSA id v1sm190524lfo.308.2021.09.18.10.28.44
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 18 Sep 2021 10:28:44 -0700 (PDT)
Received: by mail-lf1-f53.google.com with SMTP id c8so46914181lfi.3
        for <netdev@vger.kernel.org>; Sat, 18 Sep 2021 10:28:44 -0700 (PDT)
X-Received: by 2002:a2e:5815:: with SMTP id m21mr7711431ljb.95.1631986124170;
 Sat, 18 Sep 2021 10:28:44 -0700 (PDT)
MIME-Version: 1.0
References: <20210918095134.GA5001@tower> <202109181311.18IDBKQB005215@valdese.nms.ulrich-teichert.org>
 <CAHk-=whY5mLggPSr2U00mqgUbRJYnYSxtNZm4FnEtQrHftYr8Q@mail.gmail.com>
In-Reply-To: <CAHk-=whY5mLggPSr2U00mqgUbRJYnYSxtNZm4FnEtQrHftYr8Q@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sat, 18 Sep 2021 10:28:28 -0700
X-Gmail-Original-Message-ID: <CAHk-=wixOnf0i1GwYqCT=ihx=QTfB248GOFu6SZQhd3w6mm3aA@mail.gmail.com>
Message-ID: <CAHk-=wixOnf0i1GwYqCT=ihx=QTfB248GOFu6SZQhd3w6mm3aA@mail.gmail.com>
Subject: Re: [PATCH v2 0/4] Introduce and use absolute_pointer macro
To:     Ulrich Teichert <krypton@ulrich-teichert.org>
Cc:     Michael Cree <mcree@orcon.net.nz>,
        Guenter Roeck <linux@roeck-us.net>,
        Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>,
        "James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>,
        Helge Deller <deller@gmx.de>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        alpha <linux-alpha@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-parisc@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
        Sparse Mailing-list <linux-sparse@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 18, 2021 at 10:04 AM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> I do not see why you should be using that horrible __EXERN_INLINE. It
> will cause gcc to sometimes not inline at all, and not generate the
> out-of-line body either.

Yeah, that patch doesn't work at all with my cross-compiler, and only results in

  alpha-linux-gnu-ld: arch/alpha/kernel/sys_jensen.o:(.ref.data+0x58):
undefined reference to `jensen_ioread8'

because some of those 'extern inline' cases are never instantiated.

I'll look into it, we can make Jensen build again in case somebody
then gets the energy to see what causes it to not boot.

              Linus
