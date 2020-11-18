Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5FF42B850C
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 20:49:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726136AbgKRTqQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 14:46:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725710AbgKRTqQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 14:46:16 -0500
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 161ADC0613D4;
        Wed, 18 Nov 2020 11:46:16 -0800 (PST)
Received: by mail-lj1-x231.google.com with SMTP id b17so3634655ljf.12;
        Wed, 18 Nov 2020 11:46:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KKZ4gb6lDjaHxR6iESt9TC7rWEjeXXRpmBGWuLjwqho=;
        b=UD2kY9Ja3dRw3CDr2g34AQQdxq9Id4kG+7UsWQFKu7Se6KpwNZmwIKzxkH0CBiN73E
         WzSYz4z6USEXQJJzSyuPeDj32w3IKuLLnTqREi1ObZD6euPYVUjtv4mBJaUdLJhZ50fZ
         rJnJtZBZGWvWI7t7R/a2VmG/fgbH9e5QYMysS5OzzLD9D517t6kW68NjdgSRjBrv81l8
         ALaTrA7Y3XV0tBmKNR4rFTTW6Hfyg0Z+ghgJlOKUVNAAfjkJJgb5lffKZS9ta6tC/oIe
         cjcLJ5++yvAyjgsE0k/O/egJi0ygALZDUBdILGotcOg338c/r3vWqVekySTSuL606oa8
         eiRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KKZ4gb6lDjaHxR6iESt9TC7rWEjeXXRpmBGWuLjwqho=;
        b=Gduq4ReqIfmHbkkmj1m3r4k0KrXvUA/+0HToYhQotllu1TYWLrq3zxfJJSXEDs4VlW
         O/+r0mpv+0RKEjdQpHyGj2L7o7XWflgf4w4BS2Tsrt1P1haHUQnl2GHktwNOkMFwN3bv
         vU60mRZkSc+Pwc4L/u3WbAMLVZorFxpLTfqKfNeNi6Chrzp+GyeQDmmypkemJkJ99iQq
         1R/fsg3XrgicqdAOHwFhBPjL4pae8VYsCOUBTJ8JKA5JXASikv5A1JfkDDvQ5QhtdOtA
         wuza7eombRWwbBiFej00Avp0SVk3FnHgOcrVPIF9SPPuadG5Hthg7KhNw9vTBMKc8+BG
         F5Jw==
X-Gm-Message-State: AOAM531kb/QSaQ7e4qflL8y8xF1Fe/Wb8eXiXMCeb79oexTrTdTnujni
        gVhLmTCupMaeYMN/excgGMzpbAFbstVpEDfFo7GDTbJReRY=
X-Google-Smtp-Source: ABdhPJwzuPmS1cgjgZVNL6pP4CI/HcN9peF/Y7NTvyncavVMzXu/u/1FNFCypGB6OXXldxaxhG+zlLvnZVpBNqBTEbQ=
X-Received: by 2002:a2e:86c5:: with SMTP id n5mr4627251ljj.450.1605728774563;
 Wed, 18 Nov 2020 11:46:14 -0800 (PST)
MIME-Version: 1.0
References: <20201116175107.02db396d@gandalf.local.home> <47463878.48157.1605640510560.JavaMail.zimbra@efficios.com>
 <20201117142145.43194f1a@gandalf.local.home> <375636043.48251.1605642440621.JavaMail.zimbra@efficios.com>
 <20201117153451.3015c5c9@gandalf.local.home> <20201118132136.GJ3121378@hirez.programming.kicks-ass.net>
 <87h7pmwyta.fsf@mid.deneb.enyo.de> <20201118092228.4f6e5930@gandalf.local.home>
In-Reply-To: <20201118092228.4f6e5930@gandalf.local.home>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 18 Nov 2020 11:46:02 -0800
Message-ID: <CAADnVQLv2pnw1x66Y_cYmdBg=sF+7s31VVoEmSerDnbuR0pU_g@mail.gmail.com>
Subject: Re: violating function pointer signature
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Florian Weimer <fw@deneb.enyo.de>,
        Peter Zijlstra <peterz@infradead.org>,
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

On Wed, Nov 18, 2020 at 6:22 AM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> Thus, all functions will be non-variadic in these cases.

That's not the only case where it will blow up.
Try this on sparc:
struct foo {
int a;
};

struct foo foo_struct(void) {
struct foo f = {};
return f;
}
int foo_int(void) {
return 0;
}
or this link:
https://godbolt.org/z/EdM47b

Notice:
jmp %i7+12
The function that returns small struct will jump to a different
instruction in the caller.

I think none of the tracepoints return structs and void foo(void) is
fine on x86.
Just pointing out that it's more than just variadic.
