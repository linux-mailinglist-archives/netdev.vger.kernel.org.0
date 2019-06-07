Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10DC8394FB
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 20:56:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731221AbfFGS4h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 14:56:37 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:40248 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730938AbfFGS4g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jun 2019 14:56:36 -0400
Received: by mail-lj1-f193.google.com with SMTP id a21so2630450ljh.7
        for <netdev@vger.kernel.org>; Fri, 07 Jun 2019 11:56:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ldUxE0mi4WaCkQbvj9tDP1Y3dc9QMW/mTJhHqgLzTEc=;
        b=RKAsnvIg7cohPa9ftFN/RAF3uODOQevDuoFKHSPc0Xl7WdRdmcZdyGnMNLHluRHbqx
         u1w+QeICOks1DEl+AX3rcan7uhfcKxu3t+qYGPITFJ/CPSgD+SwNUDgnEQevDh4687CE
         28hm9HoLaAqEQO2OQjx2RFtlsWUqCO4SqrVko=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ldUxE0mi4WaCkQbvj9tDP1Y3dc9QMW/mTJhHqgLzTEc=;
        b=ioiQXmCLu66c3IiZzD9+cduiG3qYdF7qmOtg7wi8bMigziJNFvOSNAnUCVHpQBxaIc
         WsNOowOInJhCrEaTe49ersFxUagYpwTJ8zR4nlqBQGY+zGVoXrHIPhP1ZbGIqkP/6buT
         ks4yX3uH6vbk+5omLAF+FldQMQXscHugmojHQIMEcngtoj97MMZw+xHs71YkW4Z5nNdQ
         sDo8CaUCjjNztJwJgnkRywFgUqPxNNh74HvHRTgCJBp7OYDOYgoxGSAp32kxheGh/vkz
         41QtrZgw3sKFyitI3jJRiZXpGqnCz/NIQ/mPoJMYIQmFte2/7DbepjKzZ9Sloluzb5Ur
         EG/w==
X-Gm-Message-State: APjAAAUL/znoRyVQyR6DAGLC27uhiMH12tLQaXxxW9hJQ04NscV79t2w
        jREq7chz3jtb4FOEGf5ZF8HAPoOYPnw=
X-Google-Smtp-Source: APXvYqx99YSJbXxVrj6pt9G4zo2igYfDMG2cbtNKXvdvpaZiOxZ+fVYIm5AfDSKWt81O7kHvDZnBGA==
X-Received: by 2002:a2e:5b0f:: with SMTP id p15mr10445919ljb.82.1559933793828;
        Fri, 07 Jun 2019 11:56:33 -0700 (PDT)
Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com. [209.85.208.178])
        by smtp.gmail.com with ESMTPSA id r2sm544812lfi.51.2019.06.07.11.56.32
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 07 Jun 2019 11:56:33 -0700 (PDT)
Received: by mail-lj1-f178.google.com with SMTP id m23so2611874lje.12
        for <netdev@vger.kernel.org>; Fri, 07 Jun 2019 11:56:32 -0700 (PDT)
X-Received: by 2002:a2e:635d:: with SMTP id x90mr19091410ljb.140.1559933792458;
 Fri, 07 Jun 2019 11:56:32 -0700 (PDT)
MIME-Version: 1.0
References: <20190319165123.3967889-1-arnd@arndb.de> <alpine.DEB.2.21.1905072249570.19308@digraph.polyomino.org.uk>
 <87tvd2j9ye.fsf@oldenburg2.str.redhat.com> <CAHk-=wio1e4=WUUwmo-Ph55BEgH_X3oXzBpvPyLQg2TxzfGYuw@mail.gmail.com>
 <871s05fd8o.fsf@oldenburg2.str.redhat.com>
In-Reply-To: <871s05fd8o.fsf@oldenburg2.str.redhat.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 7 Jun 2019 11:56:16 -0700
X-Gmail-Original-Message-ID: <CAHk-=wg4ijSoPq-w7ct_VuZvgHx+tUv_QX-We-62dEwK+AOf2w@mail.gmail.com>
Message-ID: <CAHk-=wg4ijSoPq-w7ct_VuZvgHx+tUv_QX-We-62dEwK+AOf2w@mail.gmail.com>
Subject: Re: [PATCH] uapi: avoid namespace conflict in linux/posix_types.h
To:     Florian Weimer <fweimer@redhat.com>
Cc:     Joseph Myers <joseph@codesourcery.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Linux API <linux-api@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Laura Abbott <labbott@redhat.com>,
        Paul Burton <pburton@wavecomp.com>,
        Deepa Dinamani <deepa.kernel@gmail.com>,
        Linux List Kernel Mailing <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 7, 2019 at 11:43 AM Florian Weimer <fweimer@redhat.com> wrote:
>
> On the glibc side, we nowadays deal with this by splitting headers
> further.  (We used to suppress definitions with macros, but that tended
> to become convoluted.)  In this case, moving the definition of
> __kernel_long_t to its own header, so that
> include/uapi/asm-generic/socket.h can include that should fix it.

I think we should strive to do that on the kernel side too, since
clearly we shouldn't expose that "val[]" thing in the core posix types
due to namespace rules, but at the same time I think the patch to
rename val[] is fundamentally broken too.

Can you describe how you split things (perhaps even with a patch ;)?
Is this literally the only issue you currently have? Because I'd
expect similar issues to show up elsewhere too, but who knows.. You
presumably do.

                Linus
