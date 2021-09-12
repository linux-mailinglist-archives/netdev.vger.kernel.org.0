Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE561407F9A
	for <lists+netdev@lfdr.de>; Sun, 12 Sep 2021 21:12:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235943AbhILTNQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Sep 2021 15:13:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235914AbhILTNN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Sep 2021 15:13:13 -0400
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39E39C06175F
        for <netdev@vger.kernel.org>; Sun, 12 Sep 2021 12:11:59 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id q21so13152880ljj.6
        for <netdev@vger.kernel.org>; Sun, 12 Sep 2021 12:11:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=E1PHZ6ydkqEkrZPVcY11k8G+o6nXM73c5JaOIi36jdM=;
        b=Mmh3TCnuXic/hCA6XvkP2osD5zmauEUtEa852ODITJl9q7DRJZnlYFaFYG+mxH6vf6
         Z+ggUrlsmP9EQRyIHakVw8bJD81GHQopdHiqd4QBP+UGydXePHYv5SH2cpjAaKjOE5af
         i5L6vjez7vZKGjXnjuCG5wVITdXtC1IYH3rOc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=E1PHZ6ydkqEkrZPVcY11k8G+o6nXM73c5JaOIi36jdM=;
        b=YlqBYT+Iid4KkoFT1OZNRS7LDq8Bepf1vRyPriPwyIfOromiJQ1BDm02CcahgZtC8a
         fKhH5F6lZeWodVPKbEEyAiVA3xwc12TAKnw5tG+EueQyZ5+xLkup9n0VSjeNnPkYDJmm
         eplhOdlTzsO1lISOrJVDB2pnAvH/96tkKYCcgdEp7pgvTAUT6u+5RynnQnvys9Tetc6/
         JZwlFAN8UlwflZttIIL61QkVNLhRqbwroGkITYIGf1X81DnOO1nMxOK1MyX1aoMhX+DC
         bvRtgomOo0gcrk5aK9NBSCyciRJDsWbyuFTO/uUakpe7TYbru+3X90RPODoStDVVH8Wq
         VG2Q==
X-Gm-Message-State: AOAM5316I+SXeXxNjYnH9JO/tXN7bbziSIbm8i8vDb+H2BPqaq3xlDY2
        R2/WKBfH0UAtZTdR8jejklRlq+Jc8L2drV51w9w=
X-Google-Smtp-Source: ABdhPJwAhZVKI/ojZMUuypIN2f35o/Yry9JTpGOpomhs9WA+08NNCSufg6Sp2/OJgBXSNSkP0X/dsA==
X-Received: by 2002:a2e:9a04:: with SMTP id o4mr6987037lji.296.1631473917052;
        Sun, 12 Sep 2021 12:11:57 -0700 (PDT)
Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com. [209.85.167.43])
        by smtp.gmail.com with ESMTPSA id x28sm592471lfn.299.2021.09.12.12.11.54
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 12 Sep 2021 12:11:54 -0700 (PDT)
Received: by mail-lf1-f43.google.com with SMTP id k13so16252490lfv.2
        for <netdev@vger.kernel.org>; Sun, 12 Sep 2021 12:11:54 -0700 (PDT)
X-Received: by 2002:a05:6512:3d04:: with SMTP id d4mr6147162lfv.474.1631473913911;
 Sun, 12 Sep 2021 12:11:53 -0700 (PDT)
MIME-Version: 1.0
References: <20210912160149.2227137-1-linux@roeck-us.net> <20210912160149.2227137-4-linux@roeck-us.net>
In-Reply-To: <20210912160149.2227137-4-linux@roeck-us.net>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sun, 12 Sep 2021 12:11:38 -0700
X-Gmail-Original-Message-ID: <CAHk-=wi1TBvyk7SWX+5LLYN8ZnTJMut1keQbOrKCG=nb08hdiQ@mail.gmail.com>
Message-ID: <CAHk-=wi1TBvyk7SWX+5LLYN8ZnTJMut1keQbOrKCG=nb08hdiQ@mail.gmail.com>
Subject: Re: [PATCH 3/4] parisc: Use absolute_pointer for memcmp on fixed
 memory location
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Richard Henderson <rth@twiddle.net>,
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

On Sun, Sep 12, 2021 at 9:02 AM Guenter Roeck <linux@roeck-us.net> wrote:
>
> -       running_on_qemu = (memcmp(&PAGE0->pad0, "SeaBIOS", 8) == 0);
> +       running_on_qemu = (memcmp(absolute_pointer(&PAGE0->pad0), "SeaBIOS", 8) == 0);

This seems entirely the wrong thing to do, and makes no sense. That
"&PAGE0->pad0" is a perfectly valid pointer, and that's not where the
problem is.

The problem is "PAGE0" itself:

    #define PAGE0   ((struct zeropage *)__PAGE_OFFSET)

which takes that absolute offset and creates a pointer out of it.

IOW, _that_ is what should have the "absolute_pointer()" thing, and in
that context the name of that macro and its use actually makes sense.

No?

An alternative - and possibly cleaner - approach that doesn't need
absolute_pointer() at all might be to just do

        extern struct zeropage PAGE0;

and then make that PAGE0 be defined to __PAGE_OFFSET in the parisc
vmlinux.lds.S file.

Then doing things like

        running_on_qemu = !memcmp(&PAGE0.pad0, "SeaBIOS", 8);

would JustWork(tm).

Hmm?

             Linus
