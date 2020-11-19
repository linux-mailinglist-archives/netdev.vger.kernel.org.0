Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3D1B2B98E2
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 18:08:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728573AbgKSRFL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 12:05:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728264AbgKSRFL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 12:05:11 -0500
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9306EC0613CF;
        Thu, 19 Nov 2020 09:05:10 -0800 (PST)
Received: by mail-lj1-x235.google.com with SMTP id b17so6974747ljf.12;
        Thu, 19 Nov 2020 09:05:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Pdp2px/iS7YqbK+0lbuHDAjLg5kKmJIdvkTVN3rm+HA=;
        b=nFrkjPYj5vl0YiVByyuAPfx+cb+3H+MDG1Ianvgu4Z3URGmiV/WLvmnINr9f48kYUc
         IicByixTxjFT5pH2OUi+DWW31g+xU1ygpPrqSPGe8cvlFDjvlHmg0J4TTFJheDpVMYCY
         ChwdeoTwJqwOzksjwYT+9ij7EPq4qX+/a0ovn/RRQ7U4Ae9gmV6CY3MkHAAel72nvxp5
         osb3wGZD8j0TB5Y/sDFl2svkDZavV2/tegJ2IL8GMsN01D0ew9RSdsUySK7Q4tLxWUw8
         NocXBsPOvWw0fNXh4njlqGJ2RBlH2XWFKHwQG6NwMuf6FpfavlKjrx77OH9dkAsEx+JS
         WNCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Pdp2px/iS7YqbK+0lbuHDAjLg5kKmJIdvkTVN3rm+HA=;
        b=V24MVvuunDRgfciNGS4mVmmM0zWZw7NS2HP6FolAi5Fh1PaLwBo6Qao9JQu3EvNhEw
         RcdnyDreVs3NENE7UvhGGfAhuDJ42CkNELwyAY/RkK/Uso5uL3ZO8OWDnD55SBeXlLO8
         UdEj5aZH8jOXbubmRCbeNuRXBosz2EuOSmEFRM/CsBp4iP6qfhFTw9QZgE2/AN2+ZrA0
         S6fqNcpdXKgn9S+ZUvFLdFB4UxOC4ZY7Yh2T6KXXY4nKC2FrsCHL0q4tJsUrVfzJ2MvJ
         t1m8ppwGgvXbNNThfsLit3Uq5QjxX6pLFo5vG0Xtfw5mCvkrPD3opaADzVj4YONst9dz
         cJFw==
X-Gm-Message-State: AOAM533UNG9XHJhX4NOsYni9RRz7dSywNbAAnbNVi/W2I7cLOmOoZJmE
        CZUaaTyqJLX9YpfTrnxRDXy0kw2sInsqVaW/q3w=
X-Google-Smtp-Source: ABdhPJz84FHFdyN0TSp9MADPx8nbmsZjfZw5H5CotVdL+2BNemeMDX8r8YbIfwGewwb0rZZYIvJ0RyMGCdRdeeoHSHk=
X-Received: by 2002:a2e:b1c9:: with SMTP id e9mr5441355lja.283.1605805508987;
 Thu, 19 Nov 2020 09:05:08 -0800 (PST)
MIME-Version: 1.0
References: <375636043.48251.1605642440621.JavaMail.zimbra@efficios.com>
 <20201117153451.3015c5c9@gandalf.local.home> <20201118132136.GJ3121378@hirez.programming.kicks-ass.net>
 <CAKwvOdkptuS=75WjzwOho9ZjGVHGMirEW3k3u4Ep8ya5wCNajg@mail.gmail.com>
 <20201118121730.12ee645b@gandalf.local.home> <20201118181226.GK2672@gate.crashing.org>
 <87o8jutt2h.fsf@mid.deneb.enyo.de> <20201118135823.3f0d24b7@gandalf.local.home>
 <20201118191127.GM2672@gate.crashing.org> <20201119083648.GE3121392@hirez.programming.kicks-ass.net>
 <20201119143735.GU2672@gate.crashing.org> <20201119095951.30269233@gandalf.local.home>
In-Reply-To: <20201119095951.30269233@gandalf.local.home>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 19 Nov 2020 09:04:57 -0800
Message-ID: <CAADnVQL8d5zKTE_TohUcGgKKp6K1Noo7M22t_hKYQjO_g0Mb0g@mail.gmail.com>
Subject: Re: violating function pointer signature
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Segher Boessenkool <segher@kernel.crashing.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Florian Weimer <fw@deneb.enyo.de>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Matt Mullins <mmullins@mmlx.us>,
        Ingo Molnar <mingo@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Dmitry Vyukov <dvyukov@google.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        linux-toolchains@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 19, 2020 at 6:59 AM Steven Rostedt <rostedt@goodmis.org> wrote:
> Linux obviously
> supports multiple architectures (more than any other OS), but it is pretty
> stuck to gcc as a compiler (with LLVM just starting to work too).
>
> We are fine with being stuck to a compiler if it gives us what we want.

I beg to disagree.
android, chrome and others changed their kernel builds to
"make LLVM=1" some time ago.
It's absolutely vital for the health of the kernel to be built with
both gcc and llvm.
