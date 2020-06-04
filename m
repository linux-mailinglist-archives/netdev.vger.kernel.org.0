Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A95721EE7A0
	for <lists+netdev@lfdr.de>; Thu,  4 Jun 2020 17:22:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729482AbgFDPWa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jun 2020 11:22:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729292AbgFDPW3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jun 2020 11:22:29 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7F7CC08C5C0;
        Thu,  4 Jun 2020 08:22:28 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id c17so7770158lji.11;
        Thu, 04 Jun 2020 08:22:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Hll+dJXiojyLXcK519mMreswBK6PHaxvzDLgh0p26WU=;
        b=L2DmN0uXC2KyUjBXJZi+YdM6TZcgHaAo/hwU1tP/L4478bcM5q0UoroK+b7mXP2R4P
         CY4dtFPVvkSyAVNSadDFjTzPdwsP+D6eUqcI3kZvGZ6ajCkMMqMOFbgr3IfT104hlH1u
         lRWeEsjQCwyQyAj9FSqtUsV2OVn1GCiiakgSfTvZ8K2MYTUl7u0hUTkpplg3e1KrWY/9
         snhpOMwvfzp6FxIPzFqDy43iUYePSSShfDdso4J4gku4w5tWVs2i8FRQHbva/jSkg7vd
         YZLPjLfOXFlhjCK9IXDlSvavi8M3D5kpvb1fwEUGzSEYis+R9Un5BXefFLYIPHMBjNN1
         WgrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Hll+dJXiojyLXcK519mMreswBK6PHaxvzDLgh0p26WU=;
        b=ffYiP/9LdZIGGHEg3/yn5vdwNpkJkoApMsKSre+NtyHImdcfErpYuDedU7oOS/3wFg
         +RlJ3jRaOAf0CqiW0yGavgZiUl2idJ+HJI4Ev+h7UgZrFsBJJpP1yEr7P5CPOw/OFQ3J
         /SsvkuMeX/fYJchh/sVVYgFZgmFGW7Tu8oPt16zpEAHMgTdxdUGKcaUz+HuxzNr6tUyu
         zDiv9YxeHRjbEpILSxzzznQJt4MvRQkD/KN+/XFq+UHer8qL6ZzwkKnsdUqXL4hfKhiz
         Saq5I6ww9yAQQAQ9wxo52FgRimoFRsccjORXrmAtkUTMQe+5vsRW1LQSzoZt4FtVmrEW
         VKZQ==
X-Gm-Message-State: AOAM5330SmK9XPiS9IqN7kD+3OhQvWs7RoV/w/7OhOVKri89dvaBYqxi
        +v3Qdmt9gx9rMnuWiizuFm4z3AAFGwkbpCeOd8Q=
X-Google-Smtp-Source: ABdhPJxQH/KP1voSsxjAeba8kcNASoNK9+7gLFDlFHUbaiNIt96Mc8wIex8PnUIxUMkLvQS6umX4ZEAcM7RZRhjcGv4=
X-Received: by 2002:a2e:a544:: with SMTP id e4mr2625204ljn.264.1591284147467;
 Thu, 04 Jun 2020 08:22:27 -0700 (PDT)
MIME-Version: 1.0
References: <20200603233203.1695403-2-keescook@chromium.org>
 <874krr8dps.fsf@nanos.tec.linutronix.de> <CANiq72kLqvriYmMkdD3yU+xJwbn-68Eiu-fTNtC+Lb+1ZRM75g@mail.gmail.com>
 <202006040745.525ECD1@keescook>
In-Reply-To: <202006040745.525ECD1@keescook>
From:   Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date:   Thu, 4 Jun 2020 17:22:15 +0200
Message-ID: <CANiq72mHhzfPMGbBn=NZfqLeejPG+t=GN++NJ-L0hg-2x4UPag@mail.gmail.com>
Subject: Re: [PATCH 01/10] x86/mm/numa: Remove uninitialized_var() usage
To:     Kees Cook <keescook@chromium.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Alexander Potapenko <glider@google.com>,
        Joe Perches <joe@perches.com>,
        Andy Whitcroft <apw@canonical.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        drbd-dev@lists.linbit.com, linux-block@vger.kernel.org,
        b43-dev@lists.infradead.org,
        Network Development <netdev@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        linux-ide@vger.kernel.org, linux-clk@vger.kernel.org,
        linux-spi@vger.kernel.org, Linux-MM <linux-mm@kvack.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Masahiro Yamada <masahiroy@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 4, 2020 at 4:56 PM Kees Cook <keescook@chromium.org> wrote:
>
> Er? That's not what it looked like to me:
>
> #define IS_BUILTIN(option) __is_defined(option)
> #define IS_ENABLED(option) __or(IS_BUILTIN(option), IS_MODULE(option))
>
> But just to be sure, I just tested in with a real build:
>
> [    3.242160] IS_ENABLED(TEST_UNDEF) false
> [    3.242691] __is_defined(TEST_UNDEF) false
> [    3.243240] IS_ENABLED(TEST_VALUE_EMPTY) false
> [    3.243794] __is_defined(TEST_VALUE_EMPTY) false
> [    3.244353] IS_ENABLED(TEST_VALUE_1) true
> [    3.244848] __is_defined(TEST_VALUE_1) true
>
> and nope, it only works with a defined value present.

You are right, it follows the Kconfig logic, returning false for
defined-but-to-0 too.

We should probably add an `IS_DEFINED()` macro kernel-wide for this
(and add it to the `coding-guidelines.rst` since `IS_ENABLED()` is
mentioned there, with a warning not to mix it with `__is_defined()`
which looks it was only intended as an implementation detail for
`include/linux/kconfig.h`).

CC'ing Masahiro by the way.

Cheers,
Miguel
