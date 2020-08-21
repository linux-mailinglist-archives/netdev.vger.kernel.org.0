Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4EF024D803
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 17:07:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728035AbgHUPHP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 11:07:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728047AbgHUPHE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 11:07:04 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50BCDC061574
        for <netdev@vger.kernel.org>; Fri, 21 Aug 2020 08:07:04 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id t15so2034163iob.3
        for <netdev@vger.kernel.org>; Fri, 21 Aug 2020 08:07:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GnYQNhwtXwVYlPdVsnrBy6dOuo2Ol5Ijyx6D4Eg1YoA=;
        b=ePdvtcgT7ltVEACaDkXOhjZZ02iFArzqiVXgTDQe++M82pCs5Zf0M73C4dRNooFsv/
         cgVAYMgsOzHtCuF+zIyKxbetlNSd0YbgaQjMzgkoNV1ZslxvAQKHHIMs4AuMmXRkwStD
         MxbkCWxUBT8aX9J7V4C58hIzUznGe9Ja//XJ3gocQY+1wW7Uf1c2OAAVtt6j/iB3Ive2
         /AsQS4f/5HH3nDNe9GiqlKBPJdVCcpFW9aEfQN/F1tkd+q+fPo3rAIRo7dOJMcmEFsPw
         /MqQtHQ1eHKBczcqsdcZmYgRVxC+t7yK7VUfgM+Iwx6+CU2Yv5USTsx2ilYXs/W6v0KY
         Htag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GnYQNhwtXwVYlPdVsnrBy6dOuo2Ol5Ijyx6D4Eg1YoA=;
        b=A2DFv9erbxb4iOA90zFJYT0D+y4840fdp5eKYnbE3AjFOsVrvdB25G0JwYTV3s8QQ+
         JIsBHLCWuGjts7QlFCrolcIhInBR4PfmVkEQqek52onFuDnzDe2N+hp9rLdZsRaVv1Ii
         y8u/l+T++G8Xwc5YjDvwO2H6aB4nDSgFEZ0IfCMSXZqiL/z38/AX/JxrkJPAF9p3aa/J
         B/nFcM6/M4E20t/Rr3m8N5mhwDNE1zDpDO2oQ+bhegovVq/VOEQs8ZVNGLqySV9ue6sw
         WWc0XbzNBXBEa4sHoYPA+5COWr0a/G8KgNYqFPCoDMaWGP8EKw4KRsue829dvKWfvIbw
         sVhA==
X-Gm-Message-State: AOAM5316eFlMD1pO4Z8xIB939QGPbJY4i3EXnjoU/BZHeCby11ELph0n
        asDhC1p8oUizt5y45F1d/TR/Oz+GQXLdMW9/9EB6dw==
X-Google-Smtp-Source: ABdhPJzB1KDJI41X8qYxbJ9m5IjiKVoEO8Gk4B7Q2R8J9LQz3LTFJRJTOF0VfsN9KiurkFP8iE4R3IK9Cog2hB3AgZA=
X-Received: by 2002:a6b:7846:: with SMTP id h6mr2643881iop.145.1598022421093;
 Fri, 21 Aug 2020 08:07:01 -0700 (PDT)
MIME-Version: 1.0
References: <20200821063043.1949509-1-elver@google.com> <20200821085907.GJ1362448@hirez.programming.kicks-ass.net>
In-Reply-To: <20200821085907.GJ1362448@hirez.programming.kicks-ass.net>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 21 Aug 2020 08:06:49 -0700
Message-ID: <CANn89i+1MQRCSRVg-af758en5e9nwQBes3aBSjQ6BY1pV5+HdQ@mail.gmail.com>
Subject: Re: [PATCH] random32: Use rcuidle variant for tracepoint
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Marco Elver <elver@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 21, 2020 at 1:59 AM <peterz@infradead.org> wrote:
>
> On Fri, Aug 21, 2020 at 08:30:43AM +0200, Marco Elver wrote:
> > With KCSAN enabled, prandom_u32() may be called from any context,
> > including idle CPUs.
> >
> > Therefore, switch to using trace_prandom_u32_rcuidle(), to avoid various
> > issues due to recursion and lockdep warnings when KCSAN and tracing is
> > enabled.
>
> At some point we're going to have to introduce noinstr to idle as well.
> But until that time this should indeed cure things.

I do not understand what the issue is.  This _rcuidle() is kind of opaque ;)

Would this alternative patch work, or is it something more fundamental ?

Thanks !

diff --git a/lib/random32.c b/lib/random32.c
index 932345323af092a93fc2690b0ebbf4f7485ae4f3..17af2d1631e5ab6e02ad1e9288af7e007bed6d5f
100644
--- a/lib/random32.c
+++ b/lib/random32.c
@@ -83,9 +83,10 @@ u32 prandom_u32(void)
        u32 res;

        res = prandom_u32_state(state);
-       trace_prandom_u32(res);
        put_cpu_var(net_rand_state);

+       trace_prandom_u32(res);
+
        return res;
 }
 EXPORT_SYMBOL(prandom_u32);
