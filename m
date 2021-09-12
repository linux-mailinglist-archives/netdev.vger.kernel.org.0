Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 070FB408225
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 00:59:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236699AbhILXAO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Sep 2021 19:00:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236631AbhILXAN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Sep 2021 19:00:13 -0400
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1801BC061762
        for <netdev@vger.kernel.org>; Sun, 12 Sep 2021 15:58:58 -0700 (PDT)
Received: by mail-lj1-x22a.google.com with SMTP id f2so13816033ljn.1
        for <netdev@vger.kernel.org>; Sun, 12 Sep 2021 15:58:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=X35Fq5OT81Nr4I6Qbip78STPxqD/PDV+RfIaRcMXDmA=;
        b=M7RyeS9xLb3mVaGM35ZObppxdx3xXQJgghifuu8UVsRcqA3tbQu/b3NBc4q9G58Skc
         TooyKBQ11SGfPWSLHHrBcpkzM1JhOK+0oM7hKbEmTR97BKf+c74T2tMKjBtHYbQLqmvW
         URtAxnOjLh0lc9MI1zr/I99Zl6xDfwYZhCri4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=X35Fq5OT81Nr4I6Qbip78STPxqD/PDV+RfIaRcMXDmA=;
        b=XX/ZFsdkPNU1oB5zLoPpTd+1Up0JKn0MnFY6o8yjJapqxV1fB4+dHyybscXJ0Cfq04
         fjDmmZ86MZ8hLuncNmjXocGDI6Z/6Xn1WuHQpjYpoKYOK7NpgzxgH69Fqdxt8ZApI1G8
         8oWhaL7kEMFAra9+zSAXPeLMRk6JnCcoqVAU5XxFvVUvnxtSo6YssgIBKtr2fcPPV14p
         z1ua/wUJOEqftNBRvyM0cZxhUwS59Z05nTUw+tSDqv9aQMwJjE4bfIjytoX74E1d8umE
         VEIHMvcp3xfgLuK+LLn9vEGVBKLr/gSdUVGO4FEajcW0zOvRgz8/0Oq606q1CsIKbgRm
         877w==
X-Gm-Message-State: AOAM5312D5+IEmUxlOHcnHc30zb+F8zU/Y+FaYoTittEg3oiQ0fXIcrR
        yGV4tKRO5VXrKi8hXq1A8Lslta7KMZxx9XTkRAw=
X-Google-Smtp-Source: ABdhPJwxD0VPB7jlLb5nwhnfod3f9fqceWT+tVPgdkehd/UXbSa0eCOUXvmNRkdxTKgCo59H7pQ+xA==
X-Received: by 2002:a2e:9182:: with SMTP id f2mr7594924ljg.57.1631487535898;
        Sun, 12 Sep 2021 15:58:55 -0700 (PDT)
Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com. [209.85.208.172])
        by smtp.gmail.com with ESMTPSA id bp5sm24361lfb.133.2021.09.12.15.58.53
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 12 Sep 2021 15:58:54 -0700 (PDT)
Received: by mail-lj1-f172.google.com with SMTP id s12so13862425ljg.0
        for <netdev@vger.kernel.org>; Sun, 12 Sep 2021 15:58:53 -0700 (PDT)
X-Received: by 2002:a2e:8107:: with SMTP id d7mr8107686ljg.68.1631487533580;
 Sun, 12 Sep 2021 15:58:53 -0700 (PDT)
MIME-Version: 1.0
References: <20210912160149.2227137-1-linux@roeck-us.net> <20210912160149.2227137-5-linux@roeck-us.net>
 <CAHk-=wi1=8shingNuo1CtfJ7eDByDsmwsz750Nbxq=7q0Gs+zg@mail.gmail.com> <0f36c218-d79c-145f-3368-7456dd39a3f2@roeck-us.net>
In-Reply-To: <0f36c218-d79c-145f-3368-7456dd39a3f2@roeck-us.net>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sun, 12 Sep 2021 15:58:37 -0700
X-Gmail-Original-Message-ID: <CAHk-=wi11WAHpJi8KDbbp7FGcqnfkB3r6TZqnZeOKvfYGCOsaQ@mail.gmail.com>
Message-ID: <CAHk-=wi11WAHpJi8KDbbp7FGcqnfkB3r6TZqnZeOKvfYGCOsaQ@mail.gmail.com>
Subject: Re: [PATCH 4/4] alpha: Use absolute_pointer for strcmp on fixed
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

On Sun, Sep 12, 2021 at 1:37 PM Guenter Roeck <linux@roeck-us.net> wrote:
>
> COMMAND_LINE is, for whatever reason, defined in
> arch/alpha/include/uapi/asm/setup.h, ie in the uapi.
>
> Can I even touch that ?

I think that's entirely a historical accident.

Note how most of those #define's don't even work for user space
because they use PAGE_OFFSET, which is defined in <asm/page.h>. And
others depend on the kernel config system.

There's a couple that do seem to be potentially for user space (MILO
bootloader), and who knows just what hacks that code might have with
internal knowledge of this header file. But anything I can find on the
net seems to predate our move to 'uapi' headers, so I wouldn't really
worry about it.

So I'd suggest just moving that whole file back to <asm/setup.h>,
changing it as necessary, and then seeing if anybody notices.

Because I suspect the answer to that is just crickets chirping..

              Linus
