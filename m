Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 908F94CC6BE
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 21:02:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236049AbiCCUDY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 15:03:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235666AbiCCUDV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 15:03:21 -0500
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 244192A73B
        for <netdev@vger.kernel.org>; Thu,  3 Mar 2022 12:02:35 -0800 (PST)
Received: by mail-lf1-x133.google.com with SMTP id i11so10440564lfu.3
        for <netdev@vger.kernel.org>; Thu, 03 Mar 2022 12:02:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=F++KWIByQw15zKEln3xtCXqdyRaB/5lOWU6i+7W/zvU=;
        b=PknX5RT2csG8YCPJJzeTThmKtWYz/gqBuB+ekT0aM3WjTZ3KKVFIpSIWfpfKVPM5Ki
         o+9YfSG9Yy7saDcQotbBnEVnPMoCo7IhS9uKplbQdtuhfSP4iQ1IBYoIUnm3uY7DHZq3
         5Xjkqbv8O1UbcN/o1GM/kFCbUdwyb65CjJdIs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=F++KWIByQw15zKEln3xtCXqdyRaB/5lOWU6i+7W/zvU=;
        b=uMW9sa9Qgq9JVt1IbEslRiB6SSNSPEv1ubaqLtntj/dy4z3FkNh73/sJaVfIcxpr44
         XBdYA1Cmds+kcR4/AtE8aslq/t/LytgqNx1MTpGQKzh7UPhuTC/KGGs7Z+z1O1pCz+6B
         157SkqMzdFJFycV7I5aQJNMI3YeNI8ngR6cFXk+f5AHLi18zZMHIVgYYnvXUG6IAiymX
         pNFKrRoZrhs559C1EVK5hGtShEEO2Bi8O/gpeqOGAVtnGBrWrWIoNt/3LyxO7+v+n0ln
         d7/nzrKD81ltCiiwjhi8xxKrlxHgAh/S0zrvwCwzT/Vv6989d+By0ovVsB96c/ztuUkX
         Arbg==
X-Gm-Message-State: AOAM53194hlr6LybRC1rVpaJ1KqdNCHYnlqz17X1O7rVlcxwB8l1QXnD
        MnTLhtJVnHL+Y3EXuAg4whQMlRgSZ5yI0tsdABk=
X-Google-Smtp-Source: ABdhPJzgV0c/mUpKb8bO580viprwGhHknxRPbwDhWVI81vfOxbFfGz7X0exCK1cG2CyEeqzjj06rqQ==
X-Received: by 2002:a05:6512:234f:b0:445:bbc8:8c3a with SMTP id p15-20020a056512234f00b00445bbc88c3amr5796253lfu.623.1646337753191;
        Thu, 03 Mar 2022 12:02:33 -0800 (PST)
Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com. [209.85.167.53])
        by smtp.gmail.com with ESMTPSA id v25-20020ac25939000000b0044662feaa50sm352823lfi.0.2022.03.03.12.02.31
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Mar 2022 12:02:32 -0800 (PST)
Received: by mail-lf1-f53.google.com with SMTP id u20so10441047lff.2
        for <netdev@vger.kernel.org>; Thu, 03 Mar 2022 12:02:31 -0800 (PST)
X-Received: by 2002:a05:6512:6c6:b0:447:ca34:b157 with SMTP id
 u6-20020a05651206c600b00447ca34b157mr75483lff.435.1646337750887; Thu, 03 Mar
 2022 12:02:30 -0800 (PST)
MIME-Version: 1.0
References: <20220301075839.4156-1-xiam0nd.tong@gmail.com> <20220301075839.4156-3-xiam0nd.tong@gmail.com>
In-Reply-To: <20220301075839.4156-3-xiam0nd.tong@gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 3 Mar 2022 12:02:14 -0800
X-Gmail-Original-Message-ID: <CAHk-=whJX52b1jNsmzXeVr6Z898R=9rBcSYx2oLt69XKDbqhOg@mail.gmail.com>
Message-ID: <CAHk-=whJX52b1jNsmzXeVr6Z898R=9rBcSYx2oLt69XKDbqhOg@mail.gmail.com>
Subject: Re: [PATCH 2/6] list: add new MACROs to make iterator invisiable
 outside the loop
To:     Xiaomeng Tong <xiam0nd.tong@gmail.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Jakob Koschel <jakobkoschel@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kees Cook <keescook@chromium.org>,
        Jann Horn <jannh@google.com>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>, Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 28, 2022 at 11:59 PM Xiaomeng Tong <xiam0nd.tong@gmail.com> wrote:
>
> +#define list_for_each_entry_inside(pos, type, head, member)            \

So as mentioned in another thread, I actually tried exactly this.

And it was horrendous.

It's _technically_ probably a very nice solution, but

 - it means that the already *good* cases are the ones that are
penalized by having to change

 - the syntax of the thing becomes absolutely nasty

which means that _practially_ it's exactly the wrong thing to do.

Just as an example, this is a random current "good user" in kernel/exit.c:

-       list_for_each_entry_safe(p, n, dead, ptrace_entry) {
+       list_for_each_entry_safe_inside(p, n, struct task_struct,
dead, ptrace_entry) {

and while some of the effects are nice (no need to declare p/n ahead
of time), just look at how nasty that line is.

Basically every single use will result in an over-long line. The above
example has minimal indentation, almost minimal variable names (to the
point of not being very descriptive at all), and one of the most basic
kernel structure types. And it still ended up 87 columns wide.

 And no, the answer to that is not "do it on multiple lines then".
That is just even worse.

So I really think this is a major step in the wrong direction.

We should strive for the *bad* cases to have to do extra work, and
even there we should really strive for legibility.

Now, I think that "safe" version in particular can be simplified:
there's no reason to give the "n" variable a name. Now that we can
(with -stc=gnu11) just declare our own variables in the for-loop, the
need for that externally visible 'next' declaration just goes away.

So three of those 87 columns are pointless and should be removed. The
macro can just internally decare 'n' like it always wanted (but
couldn't do due to legacy C language syntax restrictions).

But even with that fixed, it's still a very cumbersome line.

Note how the old syntax was "only" 60 characters - long but still
quite legible (and would have space for two more levels of indentation
without even hitting 80 characters). And that was _despute_ having to
have that 'n' declaration.

And yes, the old syntax does require that

        struct task_struct *p, *n;

line to declare the types, but that really is not a huge burden, and
is not complicated. It's just another "variables of the right type"
line (and as mentioned, the 'n' part has always been a C syntax
annoyance).

              Linus
